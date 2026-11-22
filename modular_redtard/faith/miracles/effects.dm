/// What the combat, fire and craft miracles of Astrata, Ravox, Graggar, Malum, Matthios, Abyssor, Psydon and the Ten Undivided
/// share (Ratwood's buff/debuff status effects of roguebuff.dm and debuff.dm, Azure Peak's physiology multipliers of Ravox's
/// Persistence): a stat change for a while, the flesh made to bleed and hurt more for a while, a trial on a creature's mind.

/// A change of stats for a while (Ratwood effectedstats): the base of the buffs and debuffs of the miracles. The subtype
/// names its stats in stat_changes() and its time in new_duration(), both from the numbers of faith.txt.
/datum/status_effect/rogue_miracle_stats
	id = "rogue_miracle_stats"
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null
	tick_interval = STATUS_EFFECT_NO_TICK
	/// What the creature is told when it comes and goes.
	var/start_message
	var/end_message

/// The stats this effect moves, stat type = change.
/datum/status_effect/rogue_miracle_stats/proc/stat_changes()
	return list()

/// How long it lasts.
/datum/status_effect/rogue_miracle_stats/proc/new_duration()
	return 10 SECONDS

/datum/status_effect/rogue_miracle_stats/on_creation(mob/living/new_owner, set_duration)
	duration = set_duration || new_duration()
	return ..()

/datum/status_effect/rogue_miracle_stats/refresh(effect, set_duration)
	duration = set_duration || new_duration()

/datum/status_effect/rogue_miracle_stats/on_apply()
	owner.attributes?.set_variable_attribute_modifier(id, stat_changes())
	if(start_message)
		to_chat(owner, start_message)
	return TRUE

/datum/status_effect/rogue_miracle_stats/on_remove()
	owner.attributes?.remove_attribute_modifier(id)
	if(end_message)
		to_chat(owner, end_message)

/mob/living/carbon/human
	/// What the pain of this body is multiplied by right now (Ratwood physiology pain_mod): rogue_complex_pain() of
	/// combat/pain.dm reads it. 1 is the pain as it is.
	var/rogue_pain_mult = 1

/// Ratwood and Azure Peak's wounds made worse (Persistence on the undead, Revel in Slaughter): for a while the body bleeds
/// and hurts more. The multipliers are put back when the time runs out, by the effect itself (Ratwood put them back with
/// VARSET_CALLBACK, which does not keep up when a second cast comes in between).
/datum/status_effect/rogue_inflamed
	id = "rogue_inflamed"
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null
	tick_interval = STATUS_EFFECT_NO_TICK
	/// Bleeding and pain multipliers this effect holds on the body, to give back.
	var/bleed_mult = 1
	var/pain_mult = 1

/datum/status_effect/rogue_inflamed/on_creation(mob/living/new_owner, set_duration, new_bleed_mult = 1, new_pain_mult = 1)
	duration = set_duration
	bleed_mult = new_bleed_mult
	pain_mult = new_pain_mult
	return ..()

/datum/status_effect/rogue_inflamed/refresh(effect, set_duration, new_bleed_mult, new_pain_mult)
	duration = max(duration, set_duration)

/datum/status_effect/rogue_inflamed/on_apply()
	if(bleed_mult != 1)
		MODIFY_PHYSIOLOGY(owner, PHYS_COEFF_BLEED, bleed_mult)
	if(pain_mult != 1 && ishuman(owner))
		var/mob/living/carbon/human/patient = owner
		patient.rogue_pain_mult *= pain_mult
	return TRUE

/datum/status_effect/rogue_inflamed/on_remove()
	if(bleed_mult != 1)
		MODIFY_PHYSIOLOGY(owner, PHYS_COEFF_BLEED, 1 / bleed_mult)
	if(pain_mult != 1 && ishuman(owner))
		var/mob/living/carbon/human/patient = owner
		patient.rogue_pain_mult /= pain_mult

/// Ratwood lightningstruck (spells_status_effects.dm): shocked, slowed for as long as it lasts and wound down by the shock, and
/// disoriented: one cannot swing a blade or think.
/datum/status_effect/rogue_miracle_stats/lightningstruck
	id = "rogue_lightningstruck"
	start_message = "<span class='warning'>Shocked, slowed and disoriented, I cannot swing my blade or think properly.</span>"

/datum/status_effect/rogue_miracle_stats/lightningstruck/stat_changes()
	return list(ROGUE_STAT_STRENGTH = -rogue_value("faith_lightning_strength"), ROGUE_STAT_PERCEPTION = -rogue_value("faith_lightning_perception"), ROGUE_STAT_INTELLIGENCE = -rogue_value("faith_lightning_intelligence"))

/datum/status_effect/rogue_miracle_stats/lightningstruck/new_duration()
	return rogue_value("faith_lightning_time")

/datum/status_effect/rogue_miracle_stats/lightningstruck/on_apply()
	. = ..()
	owner.rogue_slow_for(duration)
	owner.adjust_stamina_loss(rogue_value("faith_lightning_stamina"))

#define ROGUE_HASTE_FILTER "rogue_haste_glow"

/// Ratwood buff/haste (Eora's master food, Azure Peak's haste): the body moves with uncanny swiftness, Speed up, a faint gold
/// glow about it.
/datum/status_effect/rogue_miracle_stats/haste
	id = "rogue_haste"
	alert_type = /atom/movable/screen/alert/status_effect/rogue_haste
	start_message = "<span class='warning'>My limbs move with uncanny swiftness.</span>"
	end_message = "<span class='warning'>My body move slowly again...</span>"

/datum/status_effect/rogue_miracle_stats/haste/stat_changes()
	return list(ROGUE_STAT_SPEED = rogue_value("haste_speed"))

/datum/status_effect/rogue_miracle_stats/haste/new_duration()
	return rogue_value("haste_time")

/datum/status_effect/rogue_miracle_stats/haste/on_apply()
	. = ..()
	if(!owner.get_filter(ROGUE_HASTE_FILTER))
		owner.add_filter(ROGUE_HASTE_FILTER, 2, list("type" = "outline", "color" = "#F0E68C", "alpha" = 25, "size" = 1))

/datum/status_effect/rogue_miracle_stats/haste/on_remove()
	owner.remove_filter(ROGUE_HASTE_FILTER)
	return ..()

/atom/movable/screen/alert/status_effect/rogue_haste
	name = "Haste"
	desc = "I am magically hastened."
	icon = ROGUE_COMBAT_ALERTS_ICON
	icon_state = "buff"

#undef ROGUE_HASTE_FILTER
