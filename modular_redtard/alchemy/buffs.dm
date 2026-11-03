// Ratwood's buff potions (roguecrafting/alchemy/reagents.dm, potionbuffs.dm): while one is in the blood it keeps its buff up,
// and the buff lingers buff_potion_linger after the last of it, so it lasts as long as the potion does (a slow one, a vial of
// 30 units, ten minutes and more). Two buff potions do not stack: each purges the others. From buff_potion_overdose units, more
// than a vial at once, it is an overdose: jitters, and toxins but for Baotha's blessed.

/datum/reagent/buff
	abstract_type = /datum/reagent/buff
	description = "A draught that strengthens the body or the mind while it lasts."
	metabolization_rate = ROGUE_REAGENT_RATE(0.1)
	/// The status effect it keeps up while it is in the blood.
	var/rogue_effect

/datum/reagent/buff/New()
	. = ..()
	overdose_threshold = ROGUE_BUFF_POTION_OVERDOSE

/datum/reagent/buff/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/purge = ROGUE_BUFF_POTION_PURGE * seconds_per_tick / ROGUE_REAGENT_TICK
	for(var/datum/reagent/buff/other as anything in holder.reagent_list)
		if(istype(other) && other != src)
			holder.remove_reagent(other.type, purge)
	if(rogue_effect)
		affected_mob.apply_status_effect(rogue_effect)

/datum/reagent/buff/overdose_process(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/ticks = seconds_per_tick / ROGUE_REAGENT_TICK
	affected_mob.adjust_jitter(ROGUE_BUFF_OVERDOSE_JITTER * ticks)
	if(!HAS_TRAIT(affected_mob, TRAIT_CRACKHEAD) && affected_mob.adjust_tox_loss(ROGUE_BUFF_OVERDOSE_TOXIN * ticks, updating_health = FALSE))
		return UPDATE_MOB_HEALTH

/datum/reagent/buff/strength
	name = "Strength Potion"
	color = "#FF9000"
	taste_description = "old meat"
	rogue_effect = /datum/status_effect/rogue_potion/strength

/datum/reagent/buff/perception
	name = "Perception Potion"
	color = "#E9E98C"
	taste_description = "cat piss"
	metabolization_rate = ROGUE_REAGENT_RATE(0.05)
	rogue_effect = /datum/status_effect/rogue_potion/perception

/datum/reagent/buff/intelligence
	name = "Intelligence Potion"
	color = "#438127"
	taste_description = "bog water"
	metabolization_rate = ROGUE_REAGENT_RATE(0.05)
	rogue_effect = /datum/status_effect/rogue_potion/intelligence

/datum/reagent/buff/constitution
	name = "Constitution Potion"
	color = "#130604"
	taste_description = "bile"
	rogue_effect = /datum/status_effect/rogue_potion/constitution

/datum/reagent/buff/endurance
	name = "Endurance Potion"
	color = "#E2C3E1"
	taste_description = "oversweetened milk"
	rogue_effect = /datum/status_effect/rogue_potion/endurance

/datum/reagent/buff/speed
	name = "Speed Potion"
	color = "#CEA63A"
	taste_description = "raw egg yolk"
	rogue_effect = /datum/status_effect/rogue_potion/speed

/datum/reagent/buff/fortune
	name = "Fortune Potion"
	color = "#FFFF00"
	taste_description = "sour lemons"
	metabolization_rate = ROGUE_REAGENT_RATE(0.05)
	rogue_effect = /datum/status_effect/rogue_potion/fortune

/datum/reagent/buff/temperature_normalize
	name = "Temperature Potion"
	color = "#FF9000"
	taste_description = "like water"
	rogue_effect = /datum/status_effect/rogue_potion/temperature

/// Not a buff potion at Ratwood's: it stacks with them and spends itself as fast as any reagent.
/datum/reagent/fire_resist
	name = "Fire Resistance Potion"
	description = "Toughens the hide to fire."
	color = "#FF7300"
	taste_description = "burning coal"
	metabolization_rate = ROGUE_REAGENT_RATE(1)

/datum/reagent/fire_resist/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.apply_status_effect(/datum/status_effect/rogue_potion/fire_resist)

/// The buff of a potion: renewed while the potion is in the blood, it lingers rogue_linger() after the last of it.
/datum/status_effect/rogue_potion
	id = "rogue_potion"
	status_type = STATUS_EFFECT_REFRESH
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = /atom/movable/screen/alert/status_effect/rogue_potion
	/// The stat the potion raises, ROGUE_STAT_*; null for one that does something else.
	var/rogue_stat
	/// The name of its alert (Ratwood names it by the stat).
	var/rogue_alert_name = "Potion"

/datum/status_effect/rogue_potion/on_creation(mob/living/new_owner)
	duration = rogue_linger()
	. = ..()
	if(linked_alert)
		linked_alert.name = rogue_alert_name

/datum/status_effect/rogue_potion/refresh(effect)
	duration = max(duration, rogue_linger())

/datum/status_effect/rogue_potion/proc/rogue_linger()
	return ROGUE_BUFF_POTION_LINGER

/datum/status_effect/rogue_potion/on_apply()
	if(rogue_stat)
		var/list/stats = list()
		stats[rogue_stat] = ROGUE_BUFF_POTION_STAT
		owner.attributes?.set_variable_attribute_modifier(id, stats)
	return TRUE

/datum/status_effect/rogue_potion/on_remove()
	if(rogue_stat)
		owner.attributes?.remove_attribute_modifier(id)
	return ..()

/datum/status_effect/rogue_potion/strength
	id = "rogue_potion_strength"
	rogue_stat = ROGUE_STAT_STRENGTH
	rogue_alert_name = "Strength"

/datum/status_effect/rogue_potion/perception
	id = "rogue_potion_perception"
	rogue_stat = ROGUE_STAT_PERCEPTION
	rogue_alert_name = "Perception"

/datum/status_effect/rogue_potion/intelligence
	id = "rogue_potion_intelligence"
	rogue_stat = ROGUE_STAT_INTELLIGENCE
	rogue_alert_name = "Intelligence"

/datum/status_effect/rogue_potion/constitution
	id = "rogue_potion_constitution"
	rogue_stat = ROGUE_STAT_CONSTITUTION
	rogue_alert_name = "Constitution"

/datum/status_effect/rogue_potion/endurance
	id = "rogue_potion_endurance"
	rogue_stat = ROGUE_STAT_WILLPOWER
	rogue_alert_name = "Willpower"

/datum/status_effect/rogue_potion/speed
	id = "rogue_potion_speed"
	rogue_stat = ROGUE_STAT_SPEED
	rogue_alert_name = "Speed"

/datum/status_effect/rogue_potion/fortune
	id = "rogue_potion_fortune"
	rogue_stat = ROGUE_STAT_FORTUNE
	rogue_alert_name = "Fortune"

/// Keeps the body's heat within temperature_potion_min..max, a step a second, while it lasts.
/datum/status_effect/rogue_potion/temperature
	id = "rogue_potion_temperature"
	tick_interval = 1 SECONDS
	rogue_alert_name = "Temperature Equilibrium"

/datum/status_effect/rogue_potion/temperature/rogue_linger()
	return ROGUE_TEMPERATURE_POTION_TIME

/datum/status_effect/rogue_potion/temperature/tick(seconds_between_ticks)
	if(owner.bodytemperature > ROGUE_TEMPERATURE_POTION_MAX)
		owner.adjust_bodytemperature(-ROGUE_TEMPERATURE_POTION_STEP * seconds_between_ticks)
	else if(owner.bodytemperature < ROGUE_TEMPERATURE_POTION_MIN)
		owner.adjust_bodytemperature(ROGUE_TEMPERATURE_POTION_STEP * seconds_between_ticks)

/// Fire does not catch on the body while it lasts.
/datum/status_effect/rogue_potion/fire_resist
	id = "rogue_potion_fire_resist"
	rogue_alert_name = "Fire Resistance"

/datum/status_effect/rogue_potion/fire_resist/rogue_linger()
	return ROGUE_FIRE_RESIST_TIME

/datum/status_effect/rogue_potion/fire_resist/on_apply()
	ADD_TRAIT(owner, TRAIT_NOFIRE, TRAIT_STATUS_EFFECT(id))
	return ..()

/datum/status_effect/rogue_potion/fire_resist/on_remove()
	REMOVE_TRAIT(owner, TRAIT_NOFIRE, TRAIT_STATUS_EFFECT(id))
	return ..()

/atom/movable/screen/alert/status_effect/rogue_potion
	name = "Potion"
	desc = "Power rushes through your veins."
	icon = ROGUE_COMBAT_ALERTS_ICON
	icon_state = "buff"
