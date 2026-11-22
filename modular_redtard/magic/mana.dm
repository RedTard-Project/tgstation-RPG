/// Vibelin's mana (datums/mana/mana_pool.dm, living_mana.dm, spells/_casting/casting.dm) for a person: the pool spells are
/// paid from. Its soft cap grows with the Arcyne skill (Vibelin get_softcap(): base + per rank, at least one rank); above the
/// soft cap mana bleeds away again (Vibelin's exponential decay), up to the hard cap nothing holds more. A magic user
/// (TRAIT_ARCYNE) refills by themselves up to the soft cap, as Vibelin's magic users draw on the leylines; everyone else only
/// by what gives them mana (potions, the M2 spells, an admin). Leylines as objects of the world, pylons, crystals and mana
/// overload are not ported (see the M1 report).
/datum/rogue_mana
	var/mob/living/carbon/human/holder
	/// Mana held now.
	var/amount = 0
	/// Mana the pool can never pass (Vibelin maximum_mana_capacity).
	var/capacity = 0
	/// Soft cap without the Arcyne skill (Vibelin softcap).
	var/base_softcap = 0
	/// Refill a second of a magic user (Vibelin: what the leylines give).
	var/regen = 0
	/// Pool kept by staff and tome refunds (Ratwood residual focus), spent a share every second.
	var/residual = 0
	var/residual_left = 0
	var/processing = FALSE

/datum/rogue_mana/New(mob/living/carbon/human/new_holder)
	. = ..()
	holder = new_holder
	holder.rogue_mana = src
	capacity = rogue_value("magic_mana_capacity")
	base_softcap = rogue_value("magic_mana_softcap")
	regen = rogue_value("magic_mana_regen")
	amount = min(rogue_value("magic_mana_start"), capacity)
	RegisterSignal(holder, COMSIG_QDELETING, PROC_REF(on_holder_deleted))
	RegisterSignal(holder, COMSIG_MOB_GET_STATUS_TAB_ITEMS, PROC_REF(on_status_tab))
	RegisterSignals(holder, list(SIGNAL_ADDTRAIT(TRAIT_ARCYNE), SIGNAL_REMOVETRAIT(TRAIT_ARCYNE)), PROC_REF(on_attunement_changed))
	update_processing()
	changed()

/datum/rogue_mana/Destroy(force)
	if(processing)
		STOP_PROCESSING(SSprocessing, src)
	if(holder)
		UnregisterSignal(holder, list(COMSIG_QDELETING, COMSIG_MOB_GET_STATUS_TAB_ITEMS, SIGNAL_ADDTRAIT(TRAIT_ARCYNE), SIGNAL_REMOVETRAIT(TRAIT_ARCYNE)))
		holder.rogue_mana = null
		SEND_SIGNAL(holder, COMSIG_MOB_ROGUE_MANA_CHANGED, 0)
		holder = null
	return ..()

/datum/rogue_mana/proc/on_holder_deleted(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/rogue_mana/proc/on_attunement_changed(datum/source)
	SIGNAL_HANDLER
	update_processing()

/// Vibelin mana_status_report(): the status panel tells a magic user how full they are, everyone else a rough guess.
/datum/rogue_mana/proc/on_status_tab(mob/living/source, list/items)
	SIGNAL_HANDLER
	if(HAS_TRAIT(holder, TRAIT_ARCYNE))
		items += "Mana: [round(amount)]/[round(softcap())]"
		return
	var/share = amount / max(softcap(), 1)
	items += "Mana: [share < 0.1 ? "Very Low" : (share < 0.3 ? "Low" : (share < 0.6 ? "Medium" : (share < 1 ? "High" : "Overflowing")))]"

/// Vibelin get_softcap(): the base and a step per rank of the Arcyne skill, at least one rank; only a mob with a mind grows it.
/datum/rogue_mana/proc/softcap()
	if(!holder?.mind)
		return base_softcap
	return min(base_softcap + max(1, holder.rogue_skill_rank(/datum/attribute/skill/magic/arcane)) * rogue_value("magic_mana_softcap_per_rank"), capacity)

/datum/rogue_mana/proc/update_processing()
	var/needed = (HAS_TRAIT(holder, TRAIT_ARCYNE) && amount < softcap()) || amount > softcap() || residual_left > 0
	if(needed && !processing)
		processing = TRUE
		START_PROCESSING(SSprocessing, src)
	else if(!needed && processing)
		processing = FALSE
		STOP_PROCESSING(SSprocessing, src)

/datum/rogue_mana/process(seconds_per_tick)
	if(QDELETED(holder))
		return PROCESS_KILL
	var/cap = softcap()
	if(residual_left > 0)
		var/share = min(residual_left, residual * seconds_per_tick / max(rogue_value("magic_residual_focus_duration") / (1 SECONDS), 1))
		residual_left -= share
		adjust(share, safe = TRUE)
	if(HAS_TRAIT(holder, TRAIT_ARCYNE) && holder.stat != DEAD && amount < cap)
		adjust(regen * seconds_per_tick, safe = TRUE)
	else if(amount > cap)
		// Vibelin's exponential decay: the further past the soft cap, the faster it goes, never below the cap.
		adjust(-min(amount - cap, max((amount - cap) / rogue_value("magic_mana_overflow_divisor"), 1) * seconds_per_tick))
	if(residual_left <= 0)
		residual = 0
	update_processing()

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

/// Ratwood's residual focus: a share of a spell's price comes back over a while when it was cast through a staff or tome.
/datum/rogue_mana/proc/add_residual(refund)
	if(refund <= 0)
		return
	residual_left += refund
	residual = residual_left
	update_processing()

/datum/rogue_mana/proc/changed()
	SEND_SIGNAL(holder, COMSIG_MOB_ROGUE_MANA_CHANGED, amount)

/// The mana of the human, made if they have none (Vibelin carbons have a pool from birth; here it comes with the first need).
/mob/living/carbon/human
	var/datum/rogue_mana/rogue_mana

/mob/living/carbon/human/proc/rogue_get_mana()
	RETURN_TYPE(/datum/rogue_mana)
	if(!rogue_mana && rogue_magic_enabled())
		new /datum/rogue_mana(src)
	return rogue_mana

/// Vibelin has_mana_available(): there is more than the price.
/mob/living/carbon/human/proc/rogue_has_mana(price)
	if(price <= 0)
		return TRUE
	var/datum/rogue_mana/mana = rogue_get_mana()
	return mana && mana.amount >= price

/// Vibelin consume_mana(): takes the price; returns what was taken.
/mob/living/carbon/human/proc/rogue_spend_mana(price)
	if(price <= 0)
		return 0
	var/datum/rogue_mana/mana = rogue_get_mana()
	return mana ? -mana.adjust(-price) : 0

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
