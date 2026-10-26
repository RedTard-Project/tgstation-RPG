/datum/status_effect/rogue
	id = STATUS_EFFECT_ID_ABSTRACT
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null
	var/effect_state
	var/mutable_appearance/effect_overlay
	var/base_duration = 0

/datum/status_effect/rogue/on_creation(mob/living/new_owner, set_duration)
	duration = set_duration || base_duration || duration
	return ..()

/datum/status_effect/rogue/refresh(effect, set_duration)
	duration = max(duration, set_duration || base_duration || initial(duration))

/datum/status_effect/rogue/on_apply()
	. = ..()
	if(effect_state)
		effect_overlay = mutable_appearance(ROGUE_MOB_EFFECTS_ICON, effect_state, ABOVE_ALL_MOB_LAYER)
		owner.add_overlay(effect_overlay)

/datum/status_effect/rogue/on_remove()
	if(effect_overlay)
		owner.cut_overlay(effect_overlay)
		effect_overlay = null
	return ..()

/atom/movable/screen/alert/status_effect/rogue
	icon = ROGUE_COMBAT_ALERTS_ICON

/datum/status_effect/rogue/exposed
	id = "rogue_exposed"
	effect_state = "eff_exposed"
	alert_type = /atom/movable/screen/alert/status_effect/rogue/exposed

/datum/status_effect/rogue/exposed/on_creation(mob/living/new_owner, set_duration)
	base_duration = ROGUE_EXPOSED_DURATION
	return ..()

/atom/movable/screen/alert/status_effect/rogue/exposed
	name = "Exposed"
	desc = "My guard is open. I cannot parry or dodge, and the next blow will land hard."
	icon_state = "exposed"

/datum/status_effect/rogue/guard
	id = "rogue_guard"
	effect_state = "eff_riposte"
	alert_type = /atom/movable/screen/alert/status_effect/rogue/guard
	tick_interval = 1 SECONDS

/datum/status_effect/rogue/guard/on_creation(mob/living/new_owner, set_duration)
	base_duration = ROGUE_GUARD_DURATION
	return ..()

/datum/status_effect/rogue/guard/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_ROGUE_STRIKE_INCOMING, PROC_REF(on_incoming))
	RegisterSignal(owner, COMSIG_ROGUE_STRIKE_SWING, PROC_REF(on_swing))
	RegisterSignal(owner, COMSIG_ROGUE_MANOEUVRE, PROC_REF(on_manoeuvre))
	playsound(owner, 'modular_redtard/rockhill/sound/combat/clash_initiate.ogg', 100, TRUE)

/datum/status_effect/rogue/guard/on_remove()
	UnregisterSignal(owner, list(COMSIG_ROGUE_STRIKE_INCOMING, COMSIG_ROGUE_STRIKE_SWING, COMSIG_ROGUE_MANOEUVRE))
	owner.apply_status_effect(/datum/status_effect/rogue/guard_cooldown, max(ROGUE_GUARD_COOLDOWN - owner.rogue_tempo_bonus("rmb_cooldown"), 1))
	return ..()

/datum/status_effect/rogue/guard/tick(seconds_between_ticks)
	var/mob/living/carbon/human/guardian = owner
	if(guardian.body_position == LYING_DOWN || (!guardian.get_active_held_item() && guardian.rogue_skill_rank(/datum/attribute/skill/combat/unarmed) < ROGUE_GUARD_UNARMED_RANK))
		guardian.rogue_bad_guard()

/datum/status_effect/rogue/guard/proc/on_incoming(mob/living/carbon/human/source, datum/rogue_strike/strike)
	SIGNAL_HANDLER
	switch(strike.kind)
		if(ROGUE_STRIKE_MELEE, ROGUE_STRIKE_CLEAVE)
			INVOKE_ASYNC(source, TYPE_PROC_REF(/mob/living/carbon/human, rogue_process_clash), strike)
			return ROGUE_STRIKE_CANCEL
		if(ROGUE_STRIKE_BITE)
			INVOKE_ASYNC(source, TYPE_PROC_REF(/mob/living/carbon/human, rogue_catch_bite), strike.attacker)
			return ROGUE_STRIKE_CANCEL
		if(ROGUE_STRIKE_KICK)
			INVOKE_ASYNC(source, TYPE_PROC_REF(/mob/living/carbon/human, rogue_bad_guard), "My focus was disrupted!")
	return NONE

/datum/status_effect/rogue/guard/proc/on_swing(mob/living/carbon/human/source, datum/rogue_strike/strike)
	SIGNAL_HANDLER
	if(strike.target == source || strike.target.has_status_effect(/datum/status_effect/rogue/guard))
		return NONE
	INVOKE_ASYNC(source, TYPE_PROC_REF(/mob/living/carbon/human, rogue_bad_guard), "I tried to strike while focused on defense whole! It drains me!", TRUE)
	return NONE

/datum/status_effect/rogue/guard/proc/on_manoeuvre(mob/living/carbon/human/source, kind)
	SIGNAL_HANDLER
	INVOKE_ASYNC(source, TYPE_PROC_REF(/mob/living/carbon/human, rogue_bad_guard), "My focus was disrupted!")

/atom/movable/screen/alert/status_effect/rogue/guard
	name = "Ready to Clash"
	desc = "I am on guard, and ready to clash. If I am hit, I will successfully defend. Attacking will make me lose my focus."
	icon_state = "clash"

/datum/status_effect/rogue/guard_cooldown
	id = "rogue_guard_cooldown"

/datum/status_effect/rogue/guard_cooldown/on_creation(mob/living/new_owner, set_duration)
	base_duration = ROGUE_GUARD_COOLDOWN
	return ..()

/datum/status_effect/rogue/bind
	id = "rogue_bind"
	effect_state = "eff_binded"
	alert_type = /atom/movable/screen/alert/status_effect/rogue/bind

/datum/status_effect/rogue/bind/on_creation(mob/living/new_owner, set_duration)
	base_duration = ROGUE_BIND_DURATION
	return ..()

/atom/movable/screen/alert/status_effect/rogue/bind
	name = "Bound Blades"
	desc = "I have bound my foe's weapon. Parrying them is easier for now."
	icon = 'modular_redtard/icons/hud/rogue_combat_alerts.dmi'
	icon_state = "bindcd"

/datum/status_effect/rogue/bind_cooldown
	id = "rogue_bind_cooldown"

/datum/status_effect/rogue/bind_cooldown/on_creation(mob/living/new_owner, set_duration)
	base_duration = ROGUE_BIND_COOLDOWN
	return ..()

/datum/status_effect/rogue/baited
	id = "rogue_baited"
	alert_type = /atom/movable/screen/alert/status_effect/rogue/baited

/datum/status_effect/rogue/baited/on_creation(mob/living/new_owner, set_duration)
	base_duration = ROGUE_BAITED_DURATION
	return ..()

/atom/movable/screen/alert/status_effect/rogue/baited
	name = "Baited"
	desc = "I fell for a bait. I won't fall for another so soon."
	icon_state = "bait"

/datum/status_effect/rogue/bait_cooldown
	id = "rogue_bait_cooldown"

/datum/status_effect/rogue/bait_cooldown/on_creation(mob/living/new_owner, set_duration)
	base_duration = ROGUE_BAIT_COOLDOWN
	return ..()

/datum/status_effect/rogue/special_cooldown
	id = "rogue_special_cooldown"
	alert_type = /atom/movable/screen/alert/status_effect/rogue/special_cooldown

/atom/movable/screen/alert/status_effect/rogue/special_cooldown
	name = "Special Spent"
	desc = "I need to recover before using my weapon's special again."
	icon_state = "specialcd"

/datum/status_effect/rogue/slowed
	id = "rogue_slowed"

/datum/status_effect/rogue/slowed/on_apply()
	. = ..()
	owner.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/rogue_slowed, multiplicative_slowdown = ROGUE_SLOW_FACTOR)

/datum/status_effect/rogue/slowed/on_remove()
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/rogue_slowed)
	return ..()

/datum/movespeed_modifier/rogue_slowed
	variable = TRUE

/mob/living/proc/rogue_slowdown(ticks)
	if(ticks > 0 && !HAS_TRAIT(src, TRAIT_STUNIMMUNE))
		apply_status_effect(/datum/status_effect/rogue/slowed, ticks * ROGUE_SLOW_TICK)

/mob/living/proc/rogue_delay_action(delay)
	next_move = max(next_move, world.time + delay)

/mob/living/proc/rogue_open(delay = ROGUE_EXPOSED_DURATION)
	apply_status_effect(mind ? /datum/status_effect/rogue_vulnerable : /datum/status_effect/rogue/exposed, delay)

/mob/living/proc/rogue_is_open()
	return has_status_effect(/datum/status_effect/rogue/exposed) || has_status_effect(/datum/status_effect/rogue_vulnerable)

/mob/living/proc/rogue_pop_open()
	if(remove_status_effect(/datum/status_effect/rogue/exposed))
		playsound(src, 'modular_redtard/rockhill/sound/combat/exposed_pop.ogg', 100, TRUE)
		visible_message(span_danger("[src] suffers a savage hit while exposed!"))
		return TRUE
	if(remove_status_effect(/datum/status_effect/rogue_vulnerable))
		playsound(src, 'modular_redtard/rockhill/sound/combat/vulnerable_pop.ogg', 100, TRUE)
		visible_message(span_danger("[src] is struck while vulnerable!"))
		return TRUE
	return FALSE
