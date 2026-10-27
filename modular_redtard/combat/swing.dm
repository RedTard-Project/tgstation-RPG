/// Swing delay of an intent (Azure Peak "Adds more Swingdelay Types", Ratwood combat 2.0): the attacker winds up for swingdelay
/// deciseconds under a status that tells the kind. Penalty weakens their parries and dodges, rigid leaves them no defense and is broken by any hit.
/datum/status_effect/rogue/swing
	id = "rogue_swing"
	effect_state = "eff_swingdelay"
	alert_type = /atom/movable/screen/alert/status_effect/rogue/swing
	status_type = STATUS_EFFECT_REPLACE

/datum/status_effect/rogue/swing/on_creation(mob/living/new_owner, set_duration)
	base_duration = set_duration
	return ..()

/atom/movable/screen/alert/status_effect/rogue/swing
	name = "Swinging!"
	desc = "I am swinging my weapon!"
	icon = ROGUE_COMBAT_DEBUFFS_ICON
	icon_state = "swingdelay"

/datum/status_effect/rogue/swing/penalty
	id = "rogue_swing_penalty"
	effect_state = "eff_swingdelay_penalty"
	alert_type = /atom/movable/screen/alert/status_effect/rogue/swing/penalty

/atom/movable/screen/alert/status_effect/rogue/swing/penalty
	name = "Swinging with a penalty!"
	desc = "I am swinging my weapon! My guard is weaker!"
	icon_state = "swingdelay_penalty"

/datum/status_effect/rogue/swing/rigid
	id = "rogue_swing_rigid"
	effect_state = "eff_swingdelay_cancel"
	alert_type = /atom/movable/screen/alert/status_effect/rogue/swing/rigid
	var/disrupted = FALSE
	var/slows = FALSE

/datum/status_effect/rogue/swing/rigid/on_creation(mob/living/new_owner, set_duration, slows = FALSE)
	src.slows = slows
	return ..()

/datum/status_effect/rogue/swing/rigid/on_apply()
	. = ..()
	if(slows && owner.attributes)
		owner.attributes.set_variable_attribute_modifier(id, list(ROGUE_STAT_SPEED = ROGUE_ATTRIBUTE_MIDDLING - owner.rogue_stat(ROGUE_STAT_SPEED)))

/datum/status_effect/rogue/swing/rigid/on_remove()
	if(slows)
		owner.attributes?.remove_attribute_modifier(id)
	return ..()

/datum/status_effect/rogue/swing/rigid/proc/disrupt()
	if(disrupted)
		return FALSE
	disrupted = TRUE
	playsound(owner, 'modular_redtard/rockhill/sound/combat/swingdelay_disrupted.ogg', 100, TRUE)
	if(effect_overlay)
		owner.cut_overlay(effect_overlay)
		effect_overlay = mutable_appearance(ROGUE_MOB_EFFECTS_ICON, "eff_swingdelay_disrupted", ABOVE_ALL_MOB_LAYER)
		owner.add_overlay(effect_overlay)
	return TRUE

/atom/movable/screen/alert/status_effect/rogue/swing/rigid
	name = "Swinging fiercely!"
	desc = "I cannot defend while I swing, and any hit will break the swing!"
	icon_state = "swingdelay_disrupt"

/// Starts the wind-up of an intent; returns the status so the caller can tell afterwards whether a hit broke it.
/mob/living/proc/rogue_start_swing(datum/intent/intent)
	var/duration = intent.swingdelay + ROGUE_SWINGDELAY_OVERHEAD
	switch(intent.swingdelay_type)
		if(ROGUE_SWINGDELAY_PENALTY)
			return apply_status_effect(/datum/status_effect/rogue/swing/penalty, duration)
		if(ROGUE_SWINGDELAY_CANCEL, ROGUE_SWINGDELAY_CANCELSLOW)
			return apply_status_effect(/datum/status_effect/rogue/swing/rigid, duration, intent.swingdelay_type == ROGUE_SWINGDELAY_CANCELSLOW)
	return apply_status_effect(/datum/status_effect/rogue/swing, duration)

/mob/living/proc/rogue_end_swing()
	remove_status_effect(/datum/status_effect/rogue/swing)
	remove_status_effect(/datum/status_effect/rogue/swing/penalty)
	remove_status_effect(/datum/status_effect/rogue/swing/rigid)

/// A rigid swing breaks on any hit, combat mode or not, and leaves no defense against that hit (Ratwood checkdefense).
/mob/living/proc/rogue_swing_struck()
	var/datum/status_effect/rogue/swing/rigid/rigid = has_status_effect(/datum/status_effect/rogue/swing/rigid)
	return rigid?.disrupt()

/mob/living/proc/rogue_swing_defense_penalty()
	return has_status_effect(/datum/status_effect/rogue/swing/penalty) ? ROGUE_SWINGDELAY_DEFENSE_PENALTY : 0
