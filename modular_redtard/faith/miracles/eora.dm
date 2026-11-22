/// The miracles of Eora of the basket (miracle.dm), from Ratwood's acolyte/eora.dm, eora/eora_bed.dm and the Massage of the
/// skills: Eoran Bloom, Heartweave, Eora's Rest, Eora's Blessing and Massage, with the statuses and things they leave.
/// Azure Peak and Twilight Axis have these five too, in versions of their own; this is Ratwood's. Eora's Curse waits for
/// drink and drugs, and the pomegranate tree for farming. Every number is a value of faith.txt: the miracle's own by its
/// value_key (miracle.dm), the rest by the name written where it is read.

#define ROGUE_HEARTWEAVE_FILTER "rogue_heartweave"

/// Ratwood buff/peaceflower: the stats of one who wears the bud.
/datum/status_effect/rogue_peaceflower
	id = "rogue_peaceflower"
	status_type = STATUS_EFFECT_UNIQUE
	tick_interval = STATUS_EFFECT_NO_TICK
	duration = STATUS_EFFECT_PERMANENT
	alert_type = /atom/movable/screen/alert/status_effect/rogue_peaceflower

/datum/status_effect/rogue_peaceflower/on_apply()
	owner.attributes?.set_variable_attribute_modifier(id, list(ROGUE_STAT_STRENGTH = rogue_value("eora_bud_strength"), ROGUE_STAT_PERCEPTION = rogue_value("eora_bud_perception")))
	return TRUE

/datum/status_effect/rogue_peaceflower/on_remove()
	owner.attributes?.remove_attribute_modifier(id)
	return ..()

/atom/movable/screen/alert/status_effect/rogue_peaceflower
	name = "Eoran Bud"
	desc = "Eora's beauty fills me with a sharpened clarity."
	icon = ROGUE_COMBAT_ALERTS_ICON
	icon_state = "buff"

/// Ratwood peaceflower: a flower of Eora, worn on the head or in the mouth. Whoever wears it cannot raise a hand to another (the
/// followers of Eora only feel contented) and cannot take it off themselves: someone else must. It sharpens the wearer a little.
/obj/item/clothing/head/peaceflower
	name = "eoran bud"
	desc = "A flower of gentle petals, associated with Eora or Necra. Usually adorned as a headress or laid at graves as a symbol of love or peace."
	icon = 'modular_redtard/rockhill/icons/roguetown/items/produce.dmi'
	icon_state = "peaceflower"
	worn_icon = 'modular_redtard/rockhill/icons/roguetown/clothing/onmob/head_items.dmi'
	worn_icon_state = "peaceflower"
	slot_flags = ITEM_SLOT_HEAD | ITEM_SLOT_MASK
	body_parts_covered = NONE
	w_class = WEIGHT_CLASS_TINY
	force = 0
	throwforce = 0
	throw_speed = 1
	throw_range = 3

/// The one who wears it, if it is on their head or in their mouth.
/obj/item/clothing/head/peaceflower/proc/wearer()
	var/mob/living/carbon/wearing = loc
	if(!iscarbon(wearing))
		return null
	return (wearing.get_item_by_slot(ITEM_SLOT_HEAD) == src || wearing.get_item_by_slot(ITEM_SLOT_MASK) == src) ? wearing : null

/obj/item/clothing/head/peaceflower/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(!isliving(user) || !(slot & (ITEM_SLOT_HEAD | ITEM_SLOT_MASK)))
		return
	var/mob/living/carbon/human/follower = user
	var/calm_trait = TRAIT_PACIFISM
	if(istype(follower) && istype(follower.rogue_patron, /datum/patron/divine/eora))
		calm_trait = TRAIT_EORAN_CONTENTED
	ADD_TRAIT(user, calm_trait, "peaceflower_[REF(src)]")
	var/mob/living/wearing = user
	wearing.apply_status_effect(/datum/status_effect/rogue_peaceflower)
	RegisterSignal(src, COMSIG_ITEM_PRE_UNEQUIP, PROC_REF(on_pre_unequip), override = TRUE)

/obj/item/clothing/head/peaceflower/dropped(mob/user, silent = FALSE)
	REMOVE_TRAIT(user, TRAIT_EORAN_CONTENTED, "peaceflower_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_PACIFISM, "peaceflower_[REF(src)]")
	if(isliving(user))
		var/mob/living/dropper = user
		dropper.remove_status_effect(/datum/status_effect/rogue_peaceflower)
	UnregisterSignal(src, COMSIG_ITEM_PRE_UNEQUIP)
	return ..()

/// Ratwood peace_check(): the wearer cannot pull it off themselves.
/obj/item/clothing/head/peaceflower/proc/on_pre_unequip(datum/source, force, atom/newloc, no_move, invdrop, silent)
	SIGNAL_HANDLER
	if(force || !wearer() || usr != wearer())
		return NONE
	to_chat(wearer(), span_warning("I feel at peace. <b style='color:pink'>Why would I want anything else?</b>"))
	return COMPONENT_ITEM_BLOCK_UNEQUIP

/// Ratwood bud "Eoran Bloom": after a short prayer, a flower of Eora blooms on the target's head, or on the spot if it is a place;
/// the one who wears it can raise no hand to another until it is taken off them.
/datum/action/cooldown/spell/pointed/rogue_miracle/eoran_bloom
	name = "Eoran Bloom"
	desc = "Try to grow an Eoran bud on the target tile or on the target's head, forcing their thoughts away from violence until it is removed."
	button_icon = ROGUE_MIRACLES_EORA_ICON
	button_icon_state = "love"
	sound = 'modular_redtard/faith/sound/magnet.ogg'
	value_key = "eoran_bloom"
	miracle_tier = ROGUE_MIRACLE_TIER_1
	needs_holy_symbol = TRUE
	miracle_forks = "Ratwood, Azure Peak, Twilight Axis"
	miracle_gods = "Eora T1"

/datum/action/cooldown/spell/pointed/rogue_miracle/eoran_bloom/cast(atom/cast_on)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(bloom), owner, cast_on)

/datum/action/cooldown/spell/pointed/rogue_miracle/eoran_bloom/proc/bloom(mob/living/caster, atom/target)
	caster.visible_message(span_notice("[caster] holds out a hand, and the air smells of flowers..."), span_notice("I call on Eora to make a flower bloom..."))
	if(!do_after(caster, rogue_value("eora_bloom_prayer"), target = target, timed_action_flags = IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE))
		to_chat(caster, span_warning("My prayer was interrupted!"))
		refund()
		return
	if(QDELETED(target) || QDELETED(caster))
		return
	if(ishuman(target))
		var/mob/living/carbon/human/head = target
		if(head.get_item_by_slot(ITEM_SLOT_HEAD))
			to_chat(caster, span_warning("The target's head is covered. The flowers of Eora need an open space to bloom."))
			refund()
			return
		var/obj/item/clothing/head/peaceflower/flower = new(get_turf(head))
		head.equip_to_slot_if_possible(flower, ITEM_SLOT_HEAD, TRUE, TRUE)
		to_chat(head, span_info("A flower of Eora blooms on my head. I feel at peace."))
		return
	var/turf/spot = get_turf(target)
	if(!spot || isclosedturf(spot))
		to_chat(caster, span_warning("The targeted location is blocked. The flowers of Eora refuse to grow."))
		refund()
		return
	new /obj/item/clothing/head/peaceflower(spot)

/// Ratwood status_effect/eora_bond: the glow of the bond on both of its halves.
/datum/status_effect/rogue_eora_bond
	id = "rogue_eora_bond"
	status_type = STATUS_EFFECT_UNIQUE
	tick_interval = STATUS_EFFECT_NO_TICK
	duration = STATUS_EFFECT_PERMANENT
	alert_type = /atom/movable/screen/alert/status_effect/rogue_eora_bond

/datum/status_effect/rogue_eora_bond/on_apply()
	if(!owner.get_filter(ROGUE_HEARTWEAVE_FILTER))
		owner.add_filter(ROGUE_HEARTWEAVE_FILTER, 2, list("type" = "outline", "color" = "#FF69B4", "alpha" = 60, "size" = 2))
	return TRUE

/datum/status_effect/rogue_eora_bond/on_remove()
	owner.remove_filter(ROGUE_HEARTWEAVE_FILTER)
	return ..()

/atom/movable/screen/alert/status_effect/rogue_eora_bond
	name = "Eora's Bond"
	desc = "Your life force is linked to another soul."
	icon = ROGUE_COMBAT_ALERTS_ICON
	icon_state = "buff"

/// The healing Heartweave carries across the bond: the aura of a healing miracle (healing.dm), under a name of its own so that it
/// does not carry itself back again.
/datum/status_effect/rogue_miracle_heal/eora
	id = "rogue_miracle_heal_eora"

/// Ratwood eora_bond: one half of the bond between the caster and a ward. The ward's hurts are shared, in part, with the caster:
/// for the share of the damage the ward takes, the ward is mended and the caster is hurt in the same place, and may bleed for it.
/// The healing of either is shared, in part, with the other. It ends when its time runs out, when either dies, or when they are too
/// far apart.
/datum/component/rogue_eora_bond
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/datum/weakref/other_ref
	/// The ward is the one whose hurts are shared (Ratwood ispartner).
	var/is_ward = FALSE
	var/damage_share = 0
	var/heal_share = 0
	var/wound_chance = 0
	var/max_distance = 0
	var/end_timer

/datum/component/rogue_eora_bond/Initialize(mob/living/other, new_is_ward = FALSE, rank = 0)
	if(!isliving(parent) || !isliving(other))
		return COMPONENT_INCOMPATIBLE
	other_ref = WEAKREF(other)
	is_ward = new_is_ward
	damage_share = rogue_value("eora_bond_share") + rogue_value("eora_bond_share_rank") * rank
	if(rank >= rogue_value("eora_bond_bonus_rank"))
		damage_share += rogue_value("eora_bond_share_bonus")
	heal_share = damage_share
	wound_chance = max(rogue_value("eora_bond_wound_base") - rogue_value("eora_bond_wound_rank") * rank, 0)
	max_distance = rogue_value("eora_bond_distance")
	var/mob/living/bonded = parent
	bonded.apply_status_effect(/datum/status_effect/rogue_eora_bond)
	START_PROCESSING(SSprocessing, src)
	end_timer = addtimer(CALLBACK(src, PROC_REF(remove_bond)), rogue_value("eora_bond_time"), TIMER_STOPPABLE)

/datum/component/rogue_eora_bond/RegisterWithParent()
	if(is_ward)
		RegisterSignal(parent, COMSIG_MOB_APPLY_DAMAGE, PROC_REF(on_damage))
	RegisterSignal(parent, COMSIG_LIVING_MIRACLE_HEAL_APPLY, PROC_REF(on_healed))
	RegisterSignal(parent, COMSIG_QDELETING, PROC_REF(on_parent_gone))

/datum/component/rogue_eora_bond/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_MOB_APPLY_DAMAGE, COMSIG_LIVING_MIRACLE_HEAL_APPLY, COMSIG_QDELETING))

/datum/component/rogue_eora_bond/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	if(end_timer)
		deltimer(end_timer)
		end_timer = null
	var/mob/living/bonded = parent
	if(bonded)
		bonded.remove_status_effect(/datum/status_effect/rogue_eora_bond)
	return ..()

/// The damage the ward is taking: after it lands, the share of it is mended on the ward and falls on the caster instead.
/datum/component/rogue_eora_bond/proc/on_damage(datum/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	if(damagetype != BRUTE || damage <= 0)
		return
	addtimer(CALLBACK(src, PROC_REF(share_hurt), damage * damage_share, def_zone), 1)

/datum/component/rogue_eora_bond/proc/share_hurt(shared, def_zone)
	var/mob/living/ward = parent
	var/mob/living/caster = other_ref?.resolve()
	if(QDELETED(ward) || QDELETED(caster))
		return
	if(iscarbon(ward))
		var/mob/living/carbon/mended = ward
		mended.rogue_heal_wounds(shared)
	ward.adjust_brute_loss(-shared)
	var/zone = check_zone(def_zone)
	caster.apply_damage(shared, BRUTE, zone, forced = TRUE, wound_bonus = CANT_WOUND)
	if(iscarbon(caster) && prob(wound_chance))
		var/mob/living/carbon/hurt = caster
		var/obj/item/bodypart/limb = hurt.get_bodypart(zone) || hurt.get_bodypart(BODY_ZONE_CHEST)
		if(limb)
			caster.visible_message(span_danger("[caster]'s wounds bleed profusely!"))
			hurt.cause_wound_of_type_and_severity(WOUND_PIERCE, limb, WOUND_SEVERITY_TRIVIAL, WOUND_SEVERITY_TRIVIAL, wound_source = "Eora's bond")

/// The healing of one half: the share of it goes to the other half, but not what is itself a share, nor to a Psydonite.
/datum/component/rogue_eora_bond/proc/on_healed(datum/source, amount, datum/status_effect/healing)
	SIGNAL_HANDLER
	if(istype(healing, /datum/status_effect/rogue_miracle_heal/eora) || HAS_TRAIT(parent, TRAIT_PSYDONITE))
		return
	var/mob/living/other = other_ref?.resolve()
	if(other)
		other.apply_status_effect(/datum/status_effect/rogue_miracle_heal/eora, amount * heal_share)

/datum/component/rogue_eora_bond/proc/on_parent_gone(datum/source)
	SIGNAL_HANDLER
	remove_bond()

/datum/component/rogue_eora_bond/process(seconds_per_tick)
	var/mob/living/bonded = parent
	var/mob/living/other = other_ref?.resolve()
	if(!istype(bonded) || !istype(other) || bonded.stat == DEAD || other.stat == DEAD || get_dist(bonded, other) > max_distance)
		remove_bond()

/// Ends both halves.
/datum/component/rogue_eora_bond/proc/remove_bond()
	var/mob/living/other = other_ref?.resolve()
	other_ref = null
	var/datum/component/rogue_eora_bond/twin = other?.GetComponent(/datum/component/rogue_eora_bond)
	if(twin && twin != src)
		twin.other_ref = null
		qdel(twin)
	qdel(src)

/// Ratwood heartweave "Heartweave": the caster and a ward, a touch away, are bound for a quarter of an hour: the ward's hurts fall
/// in part on the caster, and the healing of either goes in part to the other. Only one bond at a time for the caster.
/datum/action/cooldown/spell/pointed/rogue_miracle/heartweave
	name = "Heartweave"
	desc = "Forge a symbiotic bond between two souls: a share of the ward's wounds falls on me, and the healing of either goes in part to the other."
	button_icon = ROGUE_MIRACLES_EORA_ICON
	button_icon_state = "bliss"
	sound = 'modular_redtard/faith/sound/magnet.ogg'
	invocation = "By Eora's grace, let our fates intertwine!"
	invocation_type = INVOCATION_SHOUT
	value_key = "heartweave"
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_2
	miracle_forks = "Ratwood, Azure Peak, Twilight Axis"
	miracle_gods = "Eora T2"

/datum/action/cooldown/spell/pointed/rogue_miracle/heartweave/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !iscarbon(cast_on))
		to_chat(owner, span_warning("Only a body of flesh can be bound."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/heartweave/cast(mob/living/carbon/cast_on)
	. = ..()
	if(owner.GetComponent(/datum/component/rogue_eora_bond))
		return fail("I am already bonded!")
	if(cast_on.GetComponent(/datum/component/rogue_eora_bond))
		return fail("They are already bonded.")
	INVOKE_ASYNC(src, PROC_REF(weave), owner, cast_on)

/datum/action/cooldown/spell/pointed/rogue_miracle/heartweave/proc/weave(mob/living/caster, mob/living/ward)
	if(!do_after(caster, rogue_value("eora_heartweave_prayer"), target = ward))
		to_chat(caster, span_warning("The bond requires focused concentration!"))
		refund()
		return
	if(QDELETED(ward) || caster.GetComponent(/datum/component/rogue_eora_bond) || ward.GetComponent(/datum/component/rogue_eora_bond))
		refund()
		return
	var/rank = caster.rogue_skill_rank(/datum/attribute/skill/magic/holy)
	caster.AddComponent(/datum/component/rogue_eora_bond, ward, FALSE, rank)
	ward.AddComponent(/datum/component/rogue_eora_bond, caster, TRUE, rank)
	caster.visible_message(span_notice("A golden tether forms between [caster] and [ward]!"), span_notice("I feel [ward]'s life force linked to mine."))

/// Ratwood bed/rogue/eora: a bed of flower petals; whoever sleeps in it is mended and breathes easier. It is a conjured thing and
/// does not last: the spell keeps count of its beds.
/obj/structure/bed/rockhill/rogue/eora
	name = "flower bed"
	desc = "A bed of flower petals that looks soft enough to sleep on! Said to spare the dying from Necra's domain."
	icon_state = "eora"
	build_stack_type = null
	rockhill_debris = null
	/// When the bed may next mend someone.
	var/next_heal_time = 0

/obj/structure/bed/rockhill/rogue/eora/Initialize(mapload)
	. = ..()
	sleepy = rogue_value("eora_bed_sleepy")
	max_integrity = rogue_value("eora_bed_integrity")
	atom_integrity = max_integrity
	if(prob(50))
		transform = transform.Turn(180)
	START_PROCESSING(SSobj, src)

/obj/structure/bed/rockhill/rogue/eora/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/// Ratwood process(): of those lying on it who are not being mended already, the one who breathes worst, or if none does, who is hurt
/// the most, gets a mending; one at a time.
/obj/structure/bed/rockhill/rogue/eora/process(seconds_per_tick)
	if(world.time < next_heal_time)
		return
	var/mob/living/patient
	var/worst_oxy = -1
	var/worst_brute = -1
	for(var/mob/living/lying in loc)
		if(lying.body_position != LYING_DOWN || lying.has_status_effect(/datum/status_effect/rogue_bed_rest))
			continue
		var/oxy = lying.get_oxy_loss()
		var/brute = lying.get_brute_loss()
		if(oxy > worst_oxy || (oxy == worst_oxy && brute > worst_brute))
			patient = lying
			worst_oxy = oxy
			worst_brute = brute
	if(!patient)
		return
	patient.apply_status_effect(/datum/status_effect/rogue_bed_rest)
	next_heal_time = world.time + rogue_value("eora_bed_cooldown")

/// Ratwood buff/healing/bed_rest: a second of the bed's mending, every second for as long as it lasts.
/datum/status_effect/rogue_bed_rest
	id = "rogue_eora_bed"
	status_type = STATUS_EFFECT_UNIQUE
	tick_interval = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/rogue_bed_rest

/datum/status_effect/rogue_bed_rest/on_creation(mob/living/new_owner)
	duration = rogue_value("eora_bed_time")
	return ..()

/datum/status_effect/rogue_bed_rest/tick(seconds_between_ticks)
	if(owner.stat == DEAD)
		return
	var/healing = rogue_value("eora_bed_healing") * seconds_between_ticks
	new /obj/effect/temp_visual/heal(get_turf(owner), "#d04ae2")
	if(iscarbon(owner))
		var/mob/living/carbon/patient = owner
		patient.rogue_heal_wounds(healing)
	owner.adjust_brute_loss(-healing, updating_health = FALSE)
	owner.adjust_fire_loss(-healing, updating_health = FALSE)
	owner.adjust_tox_loss(-healing, updating_health = FALSE)
	owner.adjust_oxy_loss(-rogue_value("eora_bed_oxygen") * seconds_between_ticks, updating_health = FALSE)
	owner.adjust_organ_loss(ORGAN_SLOT_BRAIN, -rogue_value("eora_bed_brain") * seconds_between_ticks)
	if(owner.get_blood_volume() < BLOOD_VOLUME_NORMAL)
		owner.adjust_blood_volume(healing, maximum = BLOOD_VOLUME_NORMAL)
	owner.updatehealth()

/atom/movable/screen/alert/status_effect/rogue_bed_rest
	name = "Eora's reprieve"
	desc = "The warmth of the petals soothes my breathing and heals my ails."
	icon = ROGUE_COMBAT_ALERTS_ICON
	icon_state = "eorabed"

/// Ratwood summon_bed "Eora's Rest": a sacred bed of petals conjured on the spot pointed at, an open place. A caster keeps one bed,
/// two from the second rank, three from the third: a new one makes the oldest vanish.
/datum/action/cooldown/spell/pointed/rogue_miracle/eoras_rest
	name = "Eora's Rest"
	desc = "Summon a sacred Eoran bed to provide sanctuary and stabilize the wounded. I may keep only a few beds at a time, by my skill in miracles; a new one makes the oldest vanish."
	button_icon = ROGUE_MIRACLES_EORA_ICON
	button_icon_state = "eorabed"
	sound = 'modular_redtard/faith/sound/holyshield.ogg'
	invocation = "Eora, provider of beauty-sleeps!"
	invocation_type = INVOCATION_SHOUT
	value_key = "eoras_rest"
	miracle_tier = ROGUE_MIRACLE_TIER_1
	miracle_forks = "Ratwood, Azure Peak, Twilight Axis"
	miracle_gods = "Eora T1"
	var/list/bed_refs = list()

/datum/action/cooldown/spell/pointed/rogue_miracle/eoras_rest/Destroy()
	for(var/datum/weakref/ref as anything in bed_refs)
		qdel(ref.resolve())
	bed_refs.Cut()
	return ..()

/datum/action/cooldown/spell/pointed/rogue_miracle/eoras_rest/cast(atom/cast_on)
	. = ..()
	var/mob/living/caster = owner
	var/turf/spot = get_turf(cast_on) || get_turf(caster)
	if(!isopenturf(spot) || spot.density)
		return fail("The ground here is unsuitable for a sanctuary.")
	var/rank = caster.rogue_skill_rank(/datum/attribute/skill/magic/holy)
	var/max_beds = 1 + (rank >= rogue_value("eora_rest_rank_second_bed")) + (rank >= rogue_value("eora_rest_rank_third_bed"))
	for(var/datum/weakref/ref as anything in bed_refs)
		if(!ref.resolve())
			bed_refs -= ref
	if(length(bed_refs) >= max_beds)
		var/datum/weakref/oldest = bed_refs[1]
		var/obj/structure/bed/old_bed = oldest.resolve()
		if(old_bed)
			old_bed.visible_message(span_nicegreen("The bed fades as a new one is summoned."))
			qdel(old_bed)
		bed_refs.Cut(1, 2)
	var/obj/structure/bed/rockhill/rogue/eora/new_bed = new(spot)
	bed_refs += WEAKREF(new_bed)
	caster.visible_message(span_notice("[caster] conjures a beautiful bed of Eoran petals!"), span_notice("I summon a sanctuary for the weary."))

/// Ratwood stressevent/eoran_blessing and eoran_blessing_greater: the brightness an Eoran shone upon one.
/datum/mood_event/rogue_eoran_blessing
	description = "An Eoran shone their brightness upon me."

/datum/mood_event/rogue_eoran_blessing/New(category)
	mood_change = rogue_value("eora_blessing_mood")
	timeout = rogue_value("eora_blessing_mood_time")
	return ..()

/datum/mood_event/rogue_eoran_blessing/greater
	description = "A Devout Eoran shone their brightness upon me."

/datum/mood_event/rogue_eoran_blessing/greater/New(category)
	mood_change = rogue_value("eora_blessing_greater_mood")
	timeout = rogue_value("eora_blessing_greater_mood_time")
	return ..()

/// Ratwood eora_blessing: Eora's calm for a minute for each rank of the one who blessed, and a little bread and water if the body
/// is hungry or thirsty (the less so the less skilled the blessing).
/datum/status_effect/rogue_eora_blessing
	id = "rogue_eora_blessing"
	status_type = STATUS_EFFECT_UNIQUE
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = /atom/movable/screen/alert/status_effect/rogue_eora_blessing
	var/rank = 0

/datum/status_effect/rogue_eora_blessing/on_creation(mob/living/new_owner, blessing_rank = 0)
	rank = blessing_rank
	duration = rogue_value("eora_blessing_time_rank") * max(rank, 1)
	return ..()

/datum/status_effect/rogue_eora_blessing/on_apply()
	ADD_TRAIT(owner, TRAIT_EORAN_SERENE, id)
	var/mob/living/carbon/human/blessed = owner
	var/margin = rogue_value("eora_blessing_margin")
	var/low_ranks = rogue_value("eora_blessing_low_ranks")
	if(blessed.nutrition <= NUTRITION_LEVEL_FED)
		if(rank <= 0)
			blessed.set_nutrition(NUTRITION_LEVEL_STARVING + margin)
		else if(rank <= low_ranks)
			blessed.set_nutrition(NUTRITION_LEVEL_HUNGRY + margin)
		else
			blessed.set_nutrition(NUTRITION_LEVEL_WELL_FED)
	if(!isnull(blessed.rogue_hydration) && blessed.rogue_hydration <= rogue_value("thirst_little"))
		if(rank <= 0)
			blessed.rogue_set_hydration(rogue_value("thirst_parched") + margin)
		else if(rank <= low_ranks)
			blessed.rogue_set_hydration(rogue_value("thirst_thirsty") + margin)
		else
			blessed.rogue_set_hydration(rogue_value("thirst_quenched"))
	if(rank > rogue_value("eora_blessing_greater_above"))
		blessed.add_mood_event("rogue_eoran_blessing", /datum/mood_event/rogue_eoran_blessing/greater)
	else
		blessed.add_mood_event("rogue_eoran_blessing", /datum/mood_event/rogue_eoran_blessing)
	return TRUE

/datum/status_effect/rogue_eora_blessing/on_remove()
	REMOVE_TRAIT(owner, TRAIT_EORAN_SERENE, id)
	return ..()

/atom/movable/screen/alert/status_effect/rogue_eora_blessing
	name = "Eora's Calm"
	desc = "A refreshing calm. All your troubles have washed away. Why can't it always be like this?"
	icon = ROGUE_COMBAT_ALERTS_ICON
	icon_state = "eora_bless"

/// Ratwood eora_blessing "Eora's Blessing": the target is given Eora's calm, and fed and watered a little.
/datum/action/cooldown/spell/pointed/rogue_miracle/eoras_blessing
	name = "Eora's Blessing"
	desc = "Bestow a person with Eora's calm, if only for a little while: it lifts the spirit and eases hunger and thirst."
	button_icon = ROGUE_MIRACLES_EORA_ICON
	button_icon_state = "eora_bless"
	sound = 'modular_redtard/faith/sound/eora_bless.ogg'
	invocation = "Let the beauty of lyfe fill you whole."
	invocation_type = INVOCATION_SHOUT
	value_key = "eoras_blessing"
	miracle_tier = ROGUE_MIRACLE_TIER_0
	miracle_forks = "Ratwood, Azure Peak, Twilight Axis"
	miracle_gods = "Eora T0"

/datum/action/cooldown/spell/pointed/rogue_miracle/eoras_blessing/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !ishuman(cast_on))
		to_chat(owner, span_warning("Only a person can be given Eora's calm."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/eoras_blessing/cast(mob/living/carbon/human/cast_on)
	. = ..()
	var/mob/living/caster = owner
	cast_on.apply_status_effect(/datum/status_effect/rogue_eora_blessing, cast_on.rogue_skill_rank(/datum/attribute/skill/magic/holy))
	if(cast_on != caster)
		to_chat(caster, span_notice("I give [cast_on] Eora's calm."))

/// The four effects of a massage and its strain, on the stats of the Ratwood status effects: an ok one, a good one and a great one
/// (Ratwood buff/massage, goodmassage, greatmassage) and the soreness of a massage cut short (debuff/muscle_sore).
/datum/status_effect/rogue_miracle_stats/massage
	id = "rogue_massage"
	alert_type = /atom/movable/screen/alert/status_effect/rogue_massage
	/// The names of the values: eora_massage_<level>_<stat> and _time.
	var/level = "ok"

/datum/status_effect/rogue_miracle_stats/massage/stat_changes()
	var/list/changes = list(ROGUE_STAT_CONSTITUTION = rogue_value("massage_[level]_constitution"))
	if(level != "ok")
		changes[ROGUE_STAT_SPEED] = rogue_value("massage_[level]_speed")
		changes[ROGUE_STAT_STRENGTH] = rogue_value("massage_[level]_strength")
	if(level == "great")
		changes[ROGUE_STAT_FORTUNE] = rogue_value("massage_great_fortune")
	return changes

/datum/status_effect/rogue_miracle_stats/massage/new_duration()
	return rogue_value("massage_time")

/datum/status_effect/rogue_miracle_stats/massage/good
	id = "rogue_goodmassage"
	level = "good"
	alert_type = /atom/movable/screen/alert/status_effect/rogue_massage/good

/datum/status_effect/rogue_miracle_stats/massage/great
	id = "rogue_greatmassage"
	level = "great"
	alert_type = /atom/movable/screen/alert/status_effect/rogue_massage/great

/atom/movable/screen/alert/status_effect/rogue_massage
	name = "Massage"
	desc = "My muscles feel relaxed"
	icon = ROGUE_COMBAT_ALERTS_ICON
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/rogue_massage/good
	name = "Good Massage"
	desc = "My muscles feel relaxed and better than before"

/atom/movable/screen/alert/status_effect/rogue_massage/great
	name = "Great Massage"
	desc = "My body feels better than ever!"

/datum/status_effect/rogue_miracle_stats/muscle_sore
	id = "rogue_muscle_sore"
	alert_type = /atom/movable/screen/alert/status_effect/rogue_muscle_sore

/datum/status_effect/rogue_miracle_stats/muscle_sore/stat_changes()
	return list(ROGUE_STAT_STRENGTH = -rogue_value("massage_sore_strength"), ROGUE_STAT_WILLPOWER = -rogue_value("massage_sore_willpower"))

/datum/status_effect/rogue_miracle_stats/muscle_sore/new_duration()
	return rogue_value("massage_sore_time")

/// Ratwood: the soreness is slept off.
/datum/status_effect/rogue_miracle_stats/muscle_sore/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_LIVING_STATUS_SLEEP, PROC_REF(on_sleep))

/datum/status_effect/rogue_miracle_stats/muscle_sore/on_remove()
	UnregisterSignal(owner, COMSIG_LIVING_STATUS_SLEEP)
	return ..()

/datum/status_effect/rogue_miracle_stats/muscle_sore/proc/on_sleep(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/atom/movable/screen/alert/status_effect/rogue_muscle_sore
	name = "Muscle Soreness"
	desc = "My muscles need some sleep to recover."
	icon = ROGUE_COMBAT_ALERTS_ICON
	icon_state = "muscles"

/// Ratwood massage "Massage" (the skill of the bathhouse's attendants, in Eora's list as well): a client who lies down, or stands in
/// bathing water, and agrees, is massaged for twenty to forty seconds; if the attendant is not interrupted the client's body
/// is the better for it for half an hour, by luck an ok, a good or a great massage. One who is already sore, or still feeling a massage,
/// cannot be given another.
/datum/action/cooldown/spell/pointed/rogue_miracle/massage
	name = "Massage"
	desc = "Massage a client, working out the soreness in their muscles. They must lie down or stand in bathing water, and agree."
	button_icon = ROGUE_MIRACLES_EORA_ICON
	button_icon_state = "bliss"
	sound = null
	antimagic_flags = NONE
	value_key = "massage"
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_0
	miracle_forks = "Ratwood, Azure Peak, Twilight Axis"
	miracle_gods = "Eora T0, and the bathhouse's attendants"

/datum/action/cooldown/spell/pointed/rogue_miracle/massage/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !ishuman(cast_on))
		to_chat(owner, span_warning("I don't think I can massage that."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/massage/cast(mob/living/carbon/human/cast_on)
	. = ..()
	var/mob/living/massager = owner
	if(cast_on.body_position != LYING_DOWN)
		var/turf/spot = get_turf(cast_on)
		if(!istype(spot, /turf/open/water/bath) && !(locate(/obj/structure/hotspring) in spot))
			return fail("My client must be laying down, or standing in water suitable for bathing.")
	if(cast_on.has_status_effect(/datum/status_effect/rogue_miracle_stats/muscle_sore) || cast_on.has_status_effect(/datum/status_effect/rogue_miracle_stats/massage) || cast_on.has_status_effect(/datum/status_effect/rogue_miracle_stats/massage/good) || cast_on.has_status_effect(/datum/status_effect/rogue_miracle_stats/massage/great))
		to_chat(cast_on, span_warning("My muscles are still recovering"))
		return fail("My client has had too many strains on their muscles and needs time.")
	if(get_dist(massager, cast_on) > 1)
		INVOKE_ASYNC(src, PROC_REF(strain), cast_on)
		return fail("[cast_on] needs to stay near me during the massage!")
	INVOKE_ASYNC(src, PROC_REF(give_massage), massager, cast_on)

/// A client that was not near enough: they may cramp.
/datum/action/cooldown/spell/pointed/rogue_miracle/massage/proc/strain(mob/living/carbon/human/client)
	to_chat(client, span_warning("I need to stay near [owner] during my massage!"))
	if(prob(rogue_value("massage_cramp_spare")))
		to_chat(client, span_warning("Ah, I barely managed to escape a cramp just then, I must be careful."))
	else
		to_chat(client, span_bad("Oh no, I can feel it, A CRAMP!"))
		client.apply_status_effect(/datum/status_effect/rogue_miracle_stats/muscle_sore)

/datum/action/cooldown/spell/pointed/rogue_miracle/massage/proc/give_massage(mob/living/massager, mob/living/carbon/human/client)
	if(tgui_alert(massager, "Are you sure you want give [client.name] a massage?", "Do you want give a Massage?", list("Yes", "No")) != "Yes")
		to_chat(massager, span_warning("I decided not to"))
		refund()
		return
	to_chat(massager, span_warning("I ask if they are ready"))
	if(tgui_alert(client, "Do you want to be given a massage by [massager.name]?", "Do you want a Massage?", list("No", "Yes")) != "Yes")
		to_chat(massager, span_warning("They declined"))
		refund()
		return
	to_chat(massager, span_warning("They agree"))
	to_chat(client, span_notice("[massager] starts to give me a massage."))
	to_chat(massager, span_notice("[client] starts to receive a massage."))
	playsound(massager, pick('modular_redtard/survival/sound/kneading.ogg', 'modular_redtard/survival/sound/kneading_alt.ogg'), 10, TRUE)
	var/massage_time = rogue_value("massage_time_least") + rogue_value("massage_time_step") * rand(0, rogue_value("massage_time_options") - 1)
	if(!do_after(massager, massage_time, target = client))
		refund()
		return
	var/roll = min(rand(0, 100) + max((massager.rogue_stat(ROGUE_STAT_FORTUNE) - rogue_value("massage_luck_base")) * rogue_value("massage_luck_step"), 0), 100)
	if(roll <= rogue_value("massage_ok_up_to"))
		to_chat(client, span_notice("Ah, a massage helps my body relax"))
		client.apply_status_effect(/datum/status_effect/rogue_miracle_stats/massage)
		to_chat(massager, span_warning("I gave an ok massage."))
	else if(roll <= rogue_value("massage_good_up_to"))
		to_chat(client, span_notice("That massage made my body feel really good"))
		client.apply_status_effect(/datum/status_effect/rogue_miracle_stats/massage/good)
		to_chat(massager, span_warning("I gave a good massage."))
	else
		to_chat(client, span_notice("WOW! That massage made me feel great!"))
		client.apply_status_effect(/datum/status_effect/rogue_miracle_stats/massage/great)
		to_chat(massager, span_warning("I gave a great massage!"))

#undef ROGUE_HEARTWEAVE_FILTER
