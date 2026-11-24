/// Vibelin's mana pool (datums/mana/mana_pool.dm, living_mana.dm, spells/_casting/casting.dm) on any movable: a person
/// (/datum/rogue_mana/person below, the human's own var), an item or a structure (held by /datum/component/rogue_mana_pool,
/// mana_pools.dm), or nothing at all (a leyline, leylines.dm). rogue_mana_of() finds the pool of a thing. Mana above the soft
/// cap bleeds away (Vibelin's exponential decay), up to the hard cap nothing holds more. A pool refills from nothing (regen),
/// from the leylines and pylons it stands near (rogue_mana_sources) and keeps feeding the pool it is linked to (a pylon's
/// link). It processes only while it has something to do: needs_processing().
/datum/rogue_mana
	/// What holds the pool: any movable, or null for a leyline.
	var/atom/movable/holder
	/// Mana held now.
	var/amount = 0
	/// Mana the pool can never pass (Vibelin maximum_mana_capacity).
	var/capacity = 0
	/// Soft cap: refills stop there, anything above bleeds away (Vibelin softcap).
	var/base_softcap = 0
	/// Mana a second it makes from nothing, up to the soft cap (Vibelin ethereal_recharge_rate).
	var/regen = 0
	/// How slowly mana above the soft cap bleeds away (Vibelin exponential_decay_divisor); 0 keeps it.
	var/overflow_divisor = 0
	/// What the pool draws on by itself: ROGUE_MANA_LEYLINES, ROGUE_MANA_PYLONS (Vibelin intrinsic_recharge_sources).
	var/rogue_mana_sources = NONE
	/// Mana a second it gives at most to a link or to a pool drawing on it (Vibelin max_donation_rate_per_second).
	var/donation_rate = 0
	/// The gem type the pool is attuned to (Vibelin network_attunement): an attuned pylon feeds only pools of the same.
	var/attunement
	/// The pool this one keeps feeding (a pylon's link) and how much it keeps for itself (Vibelin transfer_threshold).
	var/datum/rogue_mana/linked
	var/link_reserve = 0
	/// The pools linked to this one: they wake when it has room again.
	var/list/datum/rogue_mana/feeders
	/// Whether a leyline or pylon is in reach of a pool that draws on them (looked at again when the holder moves).
	var/source_near = FALSE
	/// Follows the holder and what carries it, for a pool with sources (not a person: a person looks every second).
	var/datum/movement_detector/mover
	var/processing = FALSE

	// The numbers of the hot path, read once and again when the mechanics numbers change (rogue_mechanics_revision()).
	var/static/person_overflow_divisor
	var/static/softcap_per_rank
	var/static/residual_duration
	var/static/leyline_range
	var/static/leyline_share
	var/static/pylon_range
	var/static/overload_share
	var/static/overload_step
	var/static/overload_coefficient
	var/static/overload_damage_threshold
	var/static/overload_damage
	var/static/overload_blood_share
	var/static/numbers_revision = -1

/datum/rogue_mana/New(atom/movable/new_holder)
	. = ..()
	holder = new_holder
	fresh_numbers()
	setup()
	if(holder)
		RegisterSignal(holder, COMSIG_QDELETING, PROC_REF(on_holder_deleted))
	if(rogue_mana_sources && holder && !ishuman(holder))
		GLOB.rogue_mana_sourced_pools += src
		mover = new(holder, CALLBACK(src, PROC_REF(on_holder_moved)))
		recheck_sources()
	update_processing()

/datum/rogue_mana/Destroy(force)
	if(processing)
		processing = FALSE
		STOP_PROCESSING(SSprocessing, src)
	unlink()
	for(var/datum/rogue_mana/feeder as anything in feeders?.Copy())
		feeder.unlink()
	feeders = null
	GLOB.rogue_mana_sourced_pools -= src
	QDEL_NULL(mover)
	if(holder)
		UnregisterSignal(holder, COMSIG_QDELETING)
		holder = null
	return ..()

/// Sets the caps and the start of a kind of pool; subtypes read their numbers here.
/datum/rogue_mana/proc/setup()
	return

/datum/rogue_mana/proc/read_numbers()
	person_overflow_divisor = rogue_value("magic_mana_overflow_divisor")
	softcap_per_rank = rogue_value("magic_mana_softcap_per_rank")
	residual_duration = rogue_value("magic_residual_focus_duration")
	leyline_range = rogue_value("magic_leyline_range")
	leyline_share = rogue_value("magic_leyline_inflow_share")
	pylon_range = rogue_value("magic_pylon_range")
	overload_share = rogue_value("magic_overload_threshold_share")
	overload_step = rogue_value("magic_overload_step_share")
	overload_coefficient = rogue_value("magic_overload_coefficient")
	overload_damage_threshold = rogue_value("magic_overload_damage_threshold")
	overload_damage = rogue_value("magic_overload_damage")
	overload_blood_share = rogue_value("magic_overload_blood_share")
	numbers_revision = rogue_mechanics_revision()

/datum/rogue_mana/proc/fresh_numbers()
	if(numbers_revision != rogue_mechanics_revision())
		read_numbers()

/datum/rogue_mana/proc/on_holder_deleted(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/rogue_mana/proc/softcap()
	return base_softcap

/datum/rogue_mana/proc/needs_processing()
	var/cap = softcap()
	if(amount > cap)
		return overflow_divisor > 0
	if(regen > 0 && amount < cap)
		return TRUE
	if(rogue_mana_sources && source_near && amount < cap)
		return TRUE
	if(linked && amount > link_reserve && linked.amount < linked.capacity)
		return TRUE
	return FALSE

/datum/rogue_mana/proc/update_processing()
	var/needed = needs_processing()
	if(needed && !processing)
		processing = TRUE
		START_PROCESSING(SSprocessing, src)
	else if(!needed && processing)
		processing = FALSE
		STOP_PROCESSING(SSprocessing, src)

/datum/rogue_mana/process(seconds_per_tick)
	if(holder && QDELETED(holder))
		return PROCESS_KILL
	fresh_numbers()
	tick(seconds_per_tick)
	update_processing()

/// Vibelin's order: draw on the sources, refill, give to the link, bleed what is past the soft cap.
/datum/rogue_mana/proc/tick(seconds_per_tick)
	var/cap = softcap()
	if(rogue_mana_sources && source_near && amount < cap)
		draw_sources(seconds_per_tick, rogue_mana_sources)
	if(regen > 0 && amount < cap)
		adjust(regen * seconds_per_tick, safe = TRUE)
	if(linked)
		feed_link(seconds_per_tick)
	if(amount > cap && overflow_divisor > 0)
		bleed(cap, overflow_divisor, seconds_per_tick)

/// Vibelin's exponential decay: the further past the soft cap, the faster it goes, never below the cap.
/datum/rogue_mana/proc/bleed(cap, divisor, seconds_per_tick)
	adjust(-min(amount - cap, max((amount - cap) / divisor, 1) * seconds_per_tick))

/// Vibelin process(), leylines and pylons: every leyline in reach gives its rate for this pool over the distance plus one,
/// a share of it, never past the soft cap; every pylon in reach (of the same attunement, if it has one) its rate over the
/// distance plus one.
/datum/rogue_mana/proc/draw_sources(seconds_per_tick, sources)
	var/turf/here = get_turf(holder)
	if(!here)
		return
	if(sources & ROGUE_MANA_LEYLINES)
		var/list/near = rogue_leylines_near(here, leyline_range)
		for(var/datum/rogue_mana/leyline/line as anything in near)
			if(amount >= softcap())
				return
			line.transfer_to(src, min(line.donation_rate, softcap()) / (near[line] + 1) * leyline_share * seconds_per_tick, safe = TRUE)
	if(sources & ROGUE_MANA_PYLONS)
		for(var/obj/structure/rogue_mana_pylon/pylon as anything in rogue_pylons_near(here, pylon_range, attunement))
			if(amount >= softcap())
				return
			var/datum/rogue_mana/pylon_pool = rogue_mana_of(pylon)
			if(pylon_pool)
				pylon_pool.transfer_to(src, min(pylon_pool.donation_rate, softcap()) / (get_dist(here, pylon) + 1) * seconds_per_tick, safe = TRUE)

/// Looks again whether a source is in reach (the holder moved, a pylon was built or lost, a leyline was made).
/datum/rogue_mana/proc/recheck_sources()
	fresh_numbers()
	var/turf/here = get_turf(holder)
	var/near = FALSE
	if(here)
		if((rogue_mana_sources & ROGUE_MANA_LEYLINES) && length(rogue_leylines_near(here, leyline_range)))
			near = TRUE
		else if((rogue_mana_sources & ROGUE_MANA_PYLONS) && length(rogue_pylons_near(here, pylon_range, attunement)))
			near = TRUE
	source_near = near
	update_processing()

/datum/rogue_mana/proc/on_holder_moved(atom/movable/tracked, atom/movable/moving, atom/oldloc, direction)
	recheck_sources()

/// Vibelin adjust_mana(): returns what was really added (negative when taken). safe stops at the soft cap, as the leylines
/// and refunds do; otherwise only the hard cap holds it back.
/datum/rogue_mana/proc/adjust(change, safe = FALSE)
	if(!change)
		return 0
	var/ceiling = safe ? max(softcap(), amount) : capacity
	var/result = clamp(amount + change, 0, ceiling)
	. = result - amount
	amount = result
	if(.)
		changed()
		update_processing()
		if(. < 0)
			for(var/datum/rogue_mana/feeder as anything in feeders)
				feeder.update_processing()

/// Vibelin transfer_specific_mana(): moves up to amount of this pool's mana into the target, never more than this holds
/// nor than the target can hold (with safe, than its soft cap); returns what moved.
/datum/rogue_mana/proc/transfer_to(datum/rogue_mana/target, amount, safe = FALSE)
	if(!target || target == src || amount <= 0 || QDELETED(target))
		return 0
	var/room = safe ? target.softcap() - target.amount : target.capacity - target.amount
	var/moving = min(amount, src.amount, room)
	if(moving <= 0)
		return 0
	adjust(-moving)
	. = target.adjust(moving)
	if(. < moving)
		adjust(moving - .)

/// Vibelin start_transfer() of a pylon to another: this pool keeps feeding the target, keeping its reserve.
/datum/rogue_mana/proc/link_to(datum/rogue_mana/target, reserve = 0)
	unlink()
	if(!target || target == src)
		return
	linked = target
	link_reserve = max(reserve, 0)
	LAZYADD(target.feeders, src)
	RegisterSignal(target, COMSIG_QDELETING, PROC_REF(on_linked_deleted))
	update_processing()

/datum/rogue_mana/proc/unlink()
	if(!linked)
		return
	UnregisterSignal(linked, COMSIG_QDELETING)
	LAZYREMOVE(linked.feeders, src)
	linked = null
	update_processing()

/datum/rogue_mana/proc/on_linked_deleted(datum/source)
	SIGNAL_HANDLER
	unlink()

/// Vibelin transfer_mana_to(): the link gets the donation rate a second, past the target's soft cap if need be (a pylon
/// fills a pylon), never this pool's reserve.
/datum/rogue_mana/proc/feed_link(seconds_per_tick)
	if(amount <= link_reserve)
		return
	transfer_to(linked, min(donation_rate * seconds_per_tick, amount - link_reserve))

/datum/rogue_mana/proc/changed()
	if(holder)
		SEND_SIGNAL(holder, COMSIG_ROGUE_MANA_POOL_CHANGED, src, amount)

/// The pool of a thing, or null: a human's own (made at the first need), an item's or a structure's (made the first time
/// it is asked for, if its type has one: rogue_mana_pool_type()). Magic is a medieval thing: on other maps there is none.
/proc/rogue_mana_of(atom/movable/thing)
	RETURN_TYPE(/datum/rogue_mana)
	if(!ismovable(thing) || QDELETED(thing) || !rogue_magic_enabled())
		return null
	if(ishuman(thing))
		var/mob/living/carbon/human/person = thing
		return person.rogue_get_mana()
	var/datum/component/rogue_mana_pool/held = thing.GetComponent(/datum/component/rogue_mana_pool)
	if(held)
		return held.pool
	var/pool_type = thing.rogue_mana_pool_type()
	if(!pool_type)
		return null
	held = thing.AddComponent(/datum/component/rogue_mana_pool, pool_type)
	return held?.pool

/// The kind of pool this has (a /datum/rogue_mana type), or null when it holds no mana.
/atom/movable/proc/rogue_mana_pool_type()
	return null

/// Whether a spell may be paid from this thing's pool while it is carried (Vibelin TRAIT_POOL_AVAILABLE_FOR_CAST: a focus).
/atom/movable/proc/rogue_mana_cast_source()
	return FALSE

// ---------------------------------------------------------------------------------------------------------------------------
// A person's pool.

/// The pool of a human: its soft cap grows with the Arcyne skill (Vibelin get_softcap(): base + per rank, at least one
/// rank). A magic user (TRAIT_ARCYNE) refills by themselves up to the soft cap (magic_mana_regen), as Vibelin's magic users
/// draw on the leylines, and also draws on the leylines near them; everyone else only by what gives them mana (potions,
/// the mana fountain, crystals, an admin). Too much of it overloads the body (overload.dm).
/datum/rogue_mana/person
	/// Pool kept by staff and tome refunds (Ratwood residual focus), spent a share every second.
	var/residual = 0
	var/residual_left = 0
	/// Vibelin mana_overloaded.
	var/overloaded = FALSE

/datum/rogue_mana/person/setup()
	var/mob/living/carbon/human/person = holder
	person.rogue_mana = src
	capacity = rogue_value("magic_mana_capacity")
	base_softcap = rogue_value("magic_mana_softcap")
	regen = rogue_value("magic_mana_regen")
	amount = min(rogue_value("magic_mana_start"), capacity)
	RegisterSignal(person, COMSIG_MOB_GET_STATUS_TAB_ITEMS, PROC_REF(on_status_tab))
	RegisterSignals(person, list(SIGNAL_ADDTRAIT(TRAIT_ARCYNE), SIGNAL_REMOVETRAIT(TRAIT_ARCYNE)), PROC_REF(on_attunement_changed))
	// Death stops the refill and a revival starts it again (process() never refills the dead).
	RegisterSignal(person, COMSIG_MOB_STATCHANGE, PROC_REF(on_attunement_changed))

/datum/rogue_mana/person/New(mob/living/carbon/human/new_holder)
	. = ..()
	changed()

/datum/rogue_mana/person/Destroy(force)
	var/mob/living/carbon/human/person = holder
	if(person)
		UnregisterSignal(person, list(COMSIG_MOB_GET_STATUS_TAB_ITEMS, SIGNAL_ADDTRAIT(TRAIT_ARCYNE), SIGNAL_REMOVETRAIT(TRAIT_ARCYNE), COMSIG_MOB_STATCHANGE))
		person.rogue_mana = null
		SEND_SIGNAL(person, COMSIG_MOB_ROGUE_MANA_CHANGED, 0)
	return ..()

/datum/rogue_mana/person/proc/on_attunement_changed(datum/source)
	SIGNAL_HANDLER
	update_processing()

/// Vibelin mana_status_report(): the status panel tells a magic user how full they are, everyone else a rough guess.
/datum/rogue_mana/person/proc/on_status_tab(mob/living/source, list/items)
	SIGNAL_HANDLER
	if(HAS_TRAIT(holder, TRAIT_ARCYNE))
		items += "Mana: [round(amount)]/[round(softcap())]"
		return
	var/share = amount / max(softcap(), 1)
	items += "Mana: [share < 0.1 ? "Very Low" : (share < 0.3 ? "Low" : (share < 0.6 ? "Medium" : (share < 1 ? "High" : "Overflowing")))]"

/// Vibelin get_softcap(): the base and a step per rank of the Arcyne skill (the main one, not a form's sub-skill), the
/// fraction of a rank kept, at least one rank; only a mob with a mind grows it.
/datum/rogue_mana/person/softcap()
	var/mob/living/carbon/human/person = holder
	if(!person?.mind)
		return base_softcap
	return min(base_softcap + max(1, person.rogue_magic_rank(/datum/attribute/skill/magic/arcane)) * softcap_per_rank, capacity)

/// What a person draws on by itself: a magic user the leylines (Vibelin set_intrinsic_recharge(MANA_ALL_LEYLINES)), and
/// whatever else was given to the pool (a leyline attunement rite).
/datum/rogue_mana/person/proc/person_sources()
	return rogue_mana_sources | (HAS_TRAIT(holder, TRAIT_ARCYNE) ? ROGUE_MANA_LEYLINES : NONE)

/datum/rogue_mana/person/needs_processing()
	var/mob/living/carbon/human/person = holder
	if(!person)
		return FALSE
	var/cap = softcap()
	var/alive = person.stat != DEAD
	if(HAS_TRAIT(person, TRAIT_ARCYNE) && alive && amount < cap)
		return TRUE
	if(amount > cap || residual_left > 0 || overloaded)
		return TRUE
	if(alive && amount < cap && person_sources())
		return TRUE
	return amount > overload_threshold()

/datum/rogue_mana/person/tick(seconds_per_tick)
	var/mob/living/carbon/human/person = holder
	var/cap = softcap()
	if(residual_left > 0)
		var/share = min(residual_left, residual * seconds_per_tick / max(residual_duration / (1 SECONDS), 1))
		residual_left -= share
		adjust(share, safe = TRUE)
	var/alive = person.stat != DEAD
	if(HAS_TRAIT(person, TRAIT_ARCYNE) && alive && amount < cap)
		adjust(regen * seconds_per_tick, safe = TRUE)
	else if(amount > cap)
		bleed(cap, person_overflow_divisor, seconds_per_tick)
	// The leylines only add to the refill above (magic_mana_regen is kept as it was).
	var/sources = person_sources()
	if(sources && alive && amount < cap)
		draw_sources(seconds_per_tick, sources)
	check_overload()
	if(residual_left <= 0)
		residual = 0

/// Ratwood's residual focus: a share of a spell's price comes back over a while when it was cast through a staff or tome.
/datum/rogue_mana/person/proc/add_residual(refund)
	if(refund <= 0)
		return
	residual_left += refund
	residual = residual_left
	update_processing()

/datum/rogue_mana/person/changed()
	. = ..()
	SEND_SIGNAL(holder, COMSIG_MOB_ROGUE_MANA_CHANGED, amount)

/// The mana of the human, made if they have none (Vibelin carbons have a pool from birth; here it comes with the first need).
/mob/living/carbon/human
	var/datum/rogue_mana/person/rogue_mana

/mob/living/carbon/human/proc/rogue_get_mana()
	RETURN_TYPE(/datum/rogue_mana/person)
	if(!rogue_mana && rogue_magic_enabled())
		new /datum/rogue_mana/person(src)
	return rogue_mana

/// Vibelin get_all_pools(): the foci carried (worn or held), then the person's own pool last, so the foci pay first.
/mob/living/carbon/human/proc/rogue_mana_pools()
	RETURN_TYPE(/list)
	. = list()
	for(var/atom/movable/thing as anything in contents)
		if(!thing.rogue_mana_cast_source())
			continue
		var/datum/rogue_mana/pool = rogue_mana_of(thing)
		if(pool)
			. += pool
	var/datum/rogue_mana/own = rogue_get_mana()
	if(own)
		. += own

/// Vibelin has_mana_available(): all the pools together hold the price.
/mob/living/carbon/human/proc/rogue_has_mana(price)
	if(price <= 0)
		return TRUE
	var/total = 0
	for(var/datum/rogue_mana/pool as anything in rogue_mana_pools())
		total += pool.amount
	return total >= price

/// Vibelin consume_mana(): takes the price from the pools in turn; returns what was taken.
/mob/living/carbon/human/proc/rogue_spend_mana(price)
	if(price <= 0)
		return 0
	var/left = price
	for(var/datum/rogue_mana/pool as anything in rogue_mana_pools())
		left += pool.adjust(-min(left, pool.amount))
		if(left <= 0)
			break
	return price - max(left, 0)

/// Gives mana: past the soft cap only when overfill is set (a potion may, the leylines do not).
/mob/living/carbon/human/proc/rogue_restore_mana(amount, overfill = FALSE)
	var/datum/rogue_mana/mana = rogue_get_mana()
	return mana ? mana.adjust(amount, safe = !overfill) : 0

/// Makes the human a magic user: their mana refills by itself (Vibelin set_intrinsic_recharge(MANA_ALL_LEYLINES)).
/mob/living/carbon/human/proc/rogue_attune_magic(source = ROGUE_MAGIC_TRAIT)
	ADD_TRAIT(src, TRAIT_ARCYNE, source)
	rogue_get_mana()

/// Magic is a medieval thing.
/proc/rogue_magic_enabled()
	return SSmapping.current_map?.map_era == MAP_ERA_MEDIEVAL
