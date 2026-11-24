// Vibelin's buff potions (crafting/alchemy/reagents.dm, potionbuffs.dm): a draught is nothing until enough of it is in the blood
// (alch_rg_buff_trigger units, a concentrated one alch_rg_buff_trigger_concentrated); then the whole of it becomes the buff, a
// stat raised for alch_rg_buff_time (alch_rg_buff_stat, a concentrated one alch_rg_buff_stat_concentrated), and the reagent is
// gone. A buff that is already up is not raised again; buffs of different stats stack. Ratwood's potions of temperature and fire
// stay what they were: a buff that holds while the potion is in the blood and lingers a little after the last of it.

/datum/reagent/buff
	abstract_type = /datum/reagent/buff
	description = "A draught that strengthens the body or the mind while it lasts."
	rogue_rate = "buff"
	/// The status effect it becomes.
	var/rogue_effect
	/// Whether it is a concentrated draught (fewer units to take, a bigger buff).
	var/rogue_concentrated = FALSE
	/// Whether it keeps the effect up while it is in the blood instead of turning into it (Ratwood's temperature potion).
	var/rogue_sustained = FALSE

/datum/reagent/buff/New()
	. = ..()
	rogue_set_rates()

/datum/reagent/buff/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(!rogue_effect)
		return
	if(rogue_sustained)
		affected_mob.apply_status_effect(rogue_effect)
		return
	if(affected_mob.has_status_effect(rogue_effect))
		return
	if(volume < rogue_rg(rogue_concentrated ? "buff_trigger_concentrated" : "buff_trigger"))
		return
	affected_mob.apply_status_effect(rogue_effect)
	holder.remove_reagent(type, volume)

/datum/reagent/buff/strength
	rogue_effect = /datum/status_effect/rogue_potion/strength

/datum/reagent/buff/strength/concentrated
	rogue_effect = /datum/status_effect/rogue_potion/strength/concentrated
	rogue_concentrated = TRUE

/datum/reagent/buff/perception
	rogue_effect = /datum/status_effect/rogue_potion/perception

/datum/reagent/buff/perception/concentrated
	rogue_effect = /datum/status_effect/rogue_potion/perception/concentrated
	rogue_concentrated = TRUE

/datum/reagent/buff/intelligence
	rogue_effect = /datum/status_effect/rogue_potion/intelligence

/datum/reagent/buff/intelligence/concentrated
	rogue_effect = /datum/status_effect/rogue_potion/intelligence/concentrated
	rogue_concentrated = TRUE

/datum/reagent/buff/constitution
	rogue_effect = /datum/status_effect/rogue_potion/constitution

/datum/reagent/buff/constitution/concentrated
	rogue_effect = /datum/status_effect/rogue_potion/constitution/concentrated
	rogue_concentrated = TRUE

/datum/reagent/buff/endurance
	rogue_effect = /datum/status_effect/rogue_potion/endurance

/datum/reagent/buff/endurance/concentrated
	rogue_effect = /datum/status_effect/rogue_potion/endurance/concentrated
	rogue_concentrated = TRUE

/datum/reagent/buff/speed
	rogue_effect = /datum/status_effect/rogue_potion/speed

/datum/reagent/buff/speed/concentrated
	rogue_effect = /datum/status_effect/rogue_potion/speed/concentrated
	rogue_concentrated = TRUE

/datum/reagent/buff/fortune
	rogue_effect = /datum/status_effect/rogue_potion/fortune

/datum/reagent/buff/fortune/concentrated
	rogue_effect = /datum/status_effect/rogue_potion/fortune/concentrated
	rogue_concentrated = TRUE

/// Ratwood's potion (Vibelin has none): it keeps the body's heat in bounds while it is in the blood.
/datum/reagent/buff/temperature_normalize
	name = "Temperature Potion"
	color = "#FF9000"
	taste_description = "like water"
	rogue_rate = "buff_sustained"
	rogue_sustained = TRUE
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

/// The buff of a potion: it lasts alch_rg_buff_time from the moment it is raised (a refresh starts the time anew).
/datum/status_effect/rogue_potion
	id = "rogue_potion"
	status_type = STATUS_EFFECT_REFRESH
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = /atom/movable/screen/alert/status_effect/rogue_potion
	/// The stat the potion raises, ROGUE_STAT_*; null for one that does something else.
	var/rogue_stat
	/// The name of its alert (Ratwood names it by the stat).
	var/rogue_alert_name = "Potion"
	/// Whether it is the buff of a concentrated draught (twice the stat).
	var/rogue_concentrated = FALSE

/datum/status_effect/rogue_potion/on_creation(mob/living/new_owner)
	duration = rogue_linger()
	. = ..()
	if(linked_alert)
		linked_alert.name = rogue_alert_name

/datum/status_effect/rogue_potion/refresh(effect)
	duration = max(duration, rogue_linger())

/// How long the buff lasts from the last time it was raised.
/datum/status_effect/rogue_potion/proc/rogue_linger()
	return rogue_rg("buff_time")

/datum/status_effect/rogue_potion/on_apply()
	if(rogue_stat)
		var/list/stats = list()
		stats[rogue_stat] = rogue_rg(rogue_concentrated ? "buff_stat_concentrated" : "buff_stat")
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

/datum/status_effect/rogue_potion/strength/concentrated
	id = "rogue_potion_strength_concentrated"
	rogue_concentrated = TRUE

/datum/status_effect/rogue_potion/perception
	id = "rogue_potion_perception"
	rogue_stat = ROGUE_STAT_PERCEPTION
	rogue_alert_name = "Perception"

/datum/status_effect/rogue_potion/perception/concentrated
	id = "rogue_potion_perception_concentrated"
	rogue_concentrated = TRUE

/datum/status_effect/rogue_potion/intelligence
	id = "rogue_potion_intelligence"
	rogue_stat = ROGUE_STAT_INTELLIGENCE
	rogue_alert_name = "Intelligence"

/datum/status_effect/rogue_potion/intelligence/concentrated
	id = "rogue_potion_intelligence_concentrated"
	rogue_concentrated = TRUE

/datum/status_effect/rogue_potion/constitution
	id = "rogue_potion_constitution"
	rogue_stat = ROGUE_STAT_CONSTITUTION
	rogue_alert_name = "Constitution"

/datum/status_effect/rogue_potion/constitution/concentrated
	id = "rogue_potion_constitution_concentrated"
	rogue_concentrated = TRUE

/datum/status_effect/rogue_potion/endurance
	id = "rogue_potion_endurance"
	rogue_stat = ROGUE_STAT_WILLPOWER
	rogue_alert_name = "Willpower"

/datum/status_effect/rogue_potion/endurance/concentrated
	id = "rogue_potion_endurance_concentrated"
	rogue_concentrated = TRUE

/datum/status_effect/rogue_potion/speed
	id = "rogue_potion_speed"
	rogue_stat = ROGUE_STAT_SPEED
	rogue_alert_name = "Speed"

/datum/status_effect/rogue_potion/speed/concentrated
	id = "rogue_potion_speed_concentrated"
	rogue_concentrated = TRUE

/datum/status_effect/rogue_potion/fortune
	id = "rogue_potion_fortune"
	rogue_stat = ROGUE_STAT_FORTUNE
	rogue_alert_name = "Fortune"

/datum/status_effect/rogue_potion/fortune/concentrated
	id = "rogue_potion_fortune_concentrated"
	rogue_concentrated = TRUE

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
