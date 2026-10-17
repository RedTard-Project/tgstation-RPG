/datum/keybinding/living/rockhill_look
	hotkey_keys = list("ShiftF")
	name = "rockhill_look"
	full_name = "Look up or down"
	description = "Look at what's above you through an open space. If there is none, look down through an open space at your feet or next to you. Press again to stop looking."
	keybind_signal = COMSIG_KB_LIVING_ROCKHILL_LOOK_DOWN

/datum/keybinding/living/rockhill_look/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/looker = user.mob
	INVOKE_ASYNC(looker, TYPE_PROC_REF(/mob/living, rockhill_look))
	return TRUE

/mob/living/proc/rockhill_look()
	if(looking_vertically)
		end_look()
		return
	if(!client || !can_look_up())
		return
	var/direction = rockhill_look_turf(UP) ? UP : (rockhill_look_turf(DOWN) ? DOWN : NONE)
	if(!direction)
		rockhill_look_at_sky()
		return
	if(move_intent != MOVE_INTENT_WALK)
		visible_message(span_info("[src] looks [direction == UP ? "up" : "down"]."))
	if(!do_after(src, ROCKHILL_LOOK_TIME, target = src))
		return
	if(direction == UP)
		look_up()
		var/area/rogue/sky = get_area(looking_holder)
		if(istype(sky) && sky.rockhill_sunlit)
			rockhill_time_change()
	else
		look_down()

/mob/living/proc/rockhill_look_turf(direction)
	var/turf/start = get_step_multiz(src, direction == DOWN ? NONE : direction)
	if(!start || !get_step_multiz(src, direction))
		return null
	var/turf/hole = istransparentturf(start) ? start : null
	if(!hole)
		var/turf/front = get_step(start, dir)
		if(istransparentturf(front))
			hole = front
	if(!hole)
		for(var/turf/neighbor in TURF_NEIGHBORS(start))
			if(istransparentturf(neighbor))
				hole = neighbor
				break
	if(!hole)
		return null
	return direction == DOWN ? get_step_multiz(hole, DOWN) : hole

/mob/living/proc/rockhill_look_at_sky()
	var/area/rogue/here = get_area(src)
	if(get_step_multiz(src, UP) || !istype(here) || !here.rockhill_sunlit)
		to_chat(src, span_warning("A ceiling above my head."))
		return
	changeNext_move(CLICK_CD_LOOK_UP)
	var/datum/weather/active = SSrockhill_weather.initialized ? SSrockhill_weather.active_weather() : null
	to_chat(src, span_warning(active ? active.desc : "There is nothing special to say about this weather."))
	rockhill_time_change()
