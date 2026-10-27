/// Yielding (Azure Peak, Ratwood "more punishing yield"): a white flag over the head, out of combat, on the ground, hands empty,
/// slowed for a minute and too weak to fight for five. A yielder is meant to be taken, not killed.
/mob/living/var/rogue_yielding = FALSE

/mob/living/proc/rogue_yield(instant = FALSE)
	if(rogue_yielding || stat == DEAD)
		return FALSE
	if(!instant && tgui_alert(src, "Do you yield?", "SURRENDER", list("Yes", "No")) != "Yes")
		return FALSE
	if(rogue_yielding || stat == DEAD)
		return FALSE
	rogue_yielding = TRUE
	set_combat_mode(FALSE)
	changeNext_move(ROGUE_YIELD_CLICK)
	var/obj/effect/temp_visual/rogue_surrender/flag = new(src)
	vis_contents += flag
	Stun(ROGUE_YIELD_STUN)
	Knockdown(ROGUE_YIELD_STUN)
	drop_all_held_items()
	apply_status_effect(/datum/status_effect/rogue/yielded)
	apply_status_effect(/datum/status_effect/rogue/conceded)
	visible_message(span_notice("[src] yields!"))
	playsound(src, 'modular_redtard/rockhill/sound/misc/surrender.ogg', 100, FALSE, -1, ignore_walls = TRUE)
	addtimer(CALLBACK(src, PROC_REF(rogue_end_yield)), ROGUE_YIELD_DURATION, TIMER_DELETE_ME)
	log_combat(src, src, "surrendered")
	return TRUE

/mob/living/proc/rogue_end_yield()
	rogue_yielding = FALSE
	log_combat(src, src, "stopped surrendering")

/obj/effect/temp_visual/rogue_surrender
	icon = ROGUE_EFFECTS_ICON
	icon_state = "surrender_large"
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_GAME_PLANE
	appearance_flags = RESET_TRANSFORM
	pixel_z = 10
	vis_flags = NONE
	duration = 60 SECONDS

/obj/effect/temp_visual/rogue_surrender/Initialize(mapload)
	duration = ROGUE_YIELD_DURATION
	return ..()

/datum/status_effect/rogue/yielded
	id = "rogue_yielded"
	alert_type = /atom/movable/screen/alert/status_effect/rogue/yielded

/datum/status_effect/rogue/yielded/on_creation(mob/living/new_owner, set_duration)
	base_duration = ROGUE_YIELD_DURATION
	return ..()

/datum/status_effect/rogue/yielded/on_apply()
	. = ..()
	owner.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/rogue_yielded, multiplicative_slowdown = ROGUE_YIELD_SLOWDOWN)

/datum/status_effect/rogue/yielded/on_remove()
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/rogue_yielded)
	return ..()

/datum/movespeed_modifier/rogue_yielded
	variable = TRUE

/atom/movable/screen/alert/status_effect/rogue/yielded
	name = "Conformable"
	desc = "Falling in line is my only choice."
	icon_state = "debuff"

/datum/status_effect/rogue/conceded
	id = "rogue_conceded"
	alert_type = /atom/movable/screen/alert/status_effect/rogue/conceded

/datum/status_effect/rogue/conceded/on_creation(mob/living/new_owner, set_duration)
	base_duration = ROGUE_CONCEDED_DURATION
	return ..()

/datum/status_effect/rogue/conceded/on_apply()
	. = ..()
	var/penalty = -ROGUE_CONCEDED_PENALTY
	owner.attributes?.set_variable_attribute_modifier(id, list(ROGUE_STAT_STRENGTH = penalty, ROGUE_STAT_PERCEPTION = penalty, ROGUE_STAT_SPEED = penalty, ROGUE_STAT_FORTUNE = penalty))

/datum/status_effect/rogue/conceded/on_remove()
	owner.attributes?.remove_attribute_modifier(id)
	return ..()

/atom/movable/screen/alert/status_effect/rogue/conceded
	name = "Conceded"
	desc = "I conceded and won't be fighting for some time."
	icon_state = "debuff"
