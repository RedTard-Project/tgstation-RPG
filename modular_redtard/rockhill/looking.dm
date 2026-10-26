/mob/living
	var/rogue_look_locked = FALSE

/datum/keybinding/living/look_up/up(client/user, turf/target)
	var/mob/living/looker = user.mob
	if(istype(looker) && looker.rogue_look_locked)
		return TRUE
	return ..()

/datum/keybinding/living/look_down/up(client/user, turf/target)
	var/mob/living/looker = user.mob
	if(istype(looker) && looker.rogue_look_locked)
		return TRUE
	return ..()

/datum/keybinding/living/rogue_look_lock
	hotkey_keys = list("ShiftL")
	name = "rogue_look_lock"
	full_name = "Lock looking up or down"
	description = "Keep looking up or down after the look key is released. Press again to stop looking."
	keybind_signal = COMSIG_KB_LIVING_ROGUE_LOOK_LOCK_DOWN

/datum/keybinding/living/rogue_look_lock/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/looker = user.mob
	looker.toggle_look_lock()
	return TRUE

/mob/living/proc/toggle_look_lock()
	if(rogue_look_locked)
		rogue_look_locked = FALSE
		end_look()
		balloon_alert(src, "stopped looking")
		return
	if(!looking_vertically)
		balloon_alert(src, "look up or down first")
		return
	rogue_look_locked = TRUE
	balloon_alert(src, "view locked")

/mob/living/end_look()
	rogue_look_locked = FALSE
	return ..()

/mob/living/look_up()
	if(!looking_vertically && rockhill_under_sky())
		rockhill_look_at_sky()
		return
	. = ..()
	if(looking_vertically != UP)
		return
	var/area/rogue/sky = get_area(looking_holder)
	if(istype(sky) && sky.rockhill_sunlit)
		rockhill_time_change()

/mob/living/proc/rockhill_under_sky()
	var/area/rogue/here = get_area(src)
	return istype(here) && here.rockhill_sunlit && !get_step_multiz(src, UP)

/mob/living/proc/rockhill_look_at_sky()
	if(!can_look_up())
		return
	changeNext_move(CLICK_CD_LOOK_UP)
	var/sky_message = SSrockhill_weather.initialized ? SSrockhill_weather.sky_message() : null
	to_chat(src, sky_message || span_warning("There is nothing special to say about this weather."))
	rockhill_time_change()
