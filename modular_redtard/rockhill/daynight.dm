GLOBAL_VAR(rockhill_time_of_day)
GLOBAL_VAR(rockhill_time_override)
GLOBAL_VAR_INIT(rockhill_days_passed, 0)
GLOBAL_VAR_INIT(rockhill_clock_shift, 0)
GLOBAL_VAR(rockhill_clock_frozen)
GLOBAL_LIST_INIT(rockhill_day_names, list("MOON'S DAE", "TIW'S DAE", "WEDDING'S DAE", "THULE'S DAE", "FREYJA'S DAE", "SATURN'S DAE", "SUN'S DAE"))

/datum/rockhill_clock_step
	var/name
	var/start

/datum/rockhill_clock_step/sky
	var/list/colors

/datum/rockhill_clock_step/sky/dawn
	name = "Dawn"
	colors = list("#394579", "#49385d", "#3a1537")
	start = 8 HOURS

/datum/rockhill_clock_step/sky/sunrise
	name = "Sunrise"
	colors = list("#F598AB", "#e26d6d", "#e96e4f")
	start = 9.5 HOURS

/datum/rockhill_clock_step/sky/daytime
	name = "Daytime"
	colors = list("#dbbfbf", "#ddd7bd", "#add1b0", "#a4c0ca", "#ae9dc6", "#d09fbf")
	start = 10 HOURS

/datum/rockhill_clock_step/sky/sunset
	name = "Sunset"
	colors = list("#ff8a63")
	start = 15 HOURS

/datum/rockhill_clock_step/sky/dusk
	name = "Dusk"
	colors = list("#c26f56", "#c05271", "#b84933")
	start = 15.5 HOURS

/datum/rockhill_clock_step/sky/midnight
	name = "Midnight"
	colors = list(COLOR_BLACK)
	start = 16 HOURS

/datum/rockhill_clock_step/phase
	var/sky

/datum/rockhill_clock_step/phase/dawn
	sky = /datum/rockhill_clock_step/sky/dawn
	name = ROCKHILL_DAWN
	start = 8 HOURS

/datum/rockhill_clock_step/phase/day
	sky = /datum/rockhill_clock_step/sky/daytime
	name = ROCKHILL_DAY
	start = 10 HOURS

/datum/rockhill_clock_step/phase/dusk
	sky = /datum/rockhill_clock_step/sky/dusk
	name = ROCKHILL_DUSK
	start = 14 HOURS

/datum/rockhill_clock_step/phase/night
	sky = /datum/rockhill_clock_step/sky/midnight
	name = ROCKHILL_NIGHT
	start = 16 HOURS

/proc/rockhill_time()
	if(!isnull(GLOB.rockhill_clock_frozen))
		return GLOB.rockhill_clock_frozen
	return rockhill_running_time(GLOB.rockhill_clock_shift)

/proc/rockhill_running_time(shift)
	return MODULUS((world.time - SSticker.round_start_time) * ROCKHILL_DAY_RATE + ROCKHILL_DAY_START + shift, MIDNIGHT_ROLLOVER)

/proc/rockhill_set_clock(time, frozen)
	GLOB.rockhill_clock_shift = MODULUS(GLOB.rockhill_clock_shift + time - rockhill_running_time(GLOB.rockhill_clock_shift), MIDNIGHT_ROLLOVER)
	GLOB.rockhill_clock_frozen = frozen ? time : null
	if(SSticker.HasRoundStarted())
		SSrockhill_daynight.update_phase(rockhill_time())

/proc/rockhill_timestamp(format = "hh:mm")
	return time2text(rockhill_time(), format, NO_TIMEZONE)

/proc/rockhill_day_name()
	if(!GLOB.rockhill_days_passed)
		return "TWILIGHT"
	var/list/parts = rockhill_date_parts()
	return GLOB.rockhill_day_names[MODULUS(parts[1] - 1, ROCKHILL_CALENDAR_DAYS_IN_WEEK) + 1]

/proc/rockhill_clock_steps(base_type)
	var/list/steps = list()
	for(var/step_type in subtypesof(base_type))
		steps += new step_type
	sortTim(steps, GLOBAL_PROC_REF(cmp_rockhill_clock_step))
	return steps

/proc/rockhill_clock_step_at(list/steps, time)
	var/datum/rockhill_clock_step/found = steps[length(steps)]
	for(var/datum/rockhill_clock_step/step as anything in steps)
		if(time >= step.start)
			found = step
	return found

/proc/cmp_rockhill_clock_step(datum/rockhill_clock_step/a, datum/rockhill_clock_step/b)
	return a.start - b.start

/proc/rockhill_sky_areas()
	var/list/sky = list()
	for(var/area/rogue/area in GLOB.areas)
		if(area.rockhill_sunlit)
			sky += area
	return sky

SUBSYSTEM_DEF(rockhill_daynight)
	name = "Rockhill Day Cycle"
	dependencies = list(
		/datum/controller/subsystem/atoms,
		/datum/controller/subsystem/lighting,
	)
	wait = 2 SECONDS
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT
	var/list/datum/rockhill_clock_step/sky/steps
	var/list/datum/rockhill_clock_step/phase/phases
	var/datum/rockhill_clock_step/sky/current
	var/datum/rockhill_clock_step/phase/phase
	var/shown_color
	var/from_color
	var/target_color
	var/transition_start = 0

/datum/controller/subsystem/rockhill_daynight/Initialize()
	if(!length(rockhill_sky_areas()))
		can_fire = FALSE
		return SS_INIT_NO_NEED
	steps = rockhill_clock_steps(/datum/rockhill_clock_step/sky)
	phases = rockhill_clock_steps(/datum/rockhill_clock_step/phase)
	rockhill_load_calendar_events()
	current = rockhill_clock_step_at(steps, rockhill_time())
	shown_color = target_color = from_color = pick(current.colors)
	apply_sky(shown_color)
	update_emitters(shown_color)
	RegisterSignal(SSdcs, COMSIG_GLOB_ROGUE_LIGHT_CARRIER, PROC_REF(carrier_changed))
	return SS_INIT_SUCCESS

/datum/controller/subsystem/rockhill_daynight/stat_entry(msg)
	msg = "[phase?.name || current?.name][GLOB.rockhill_time_override ? " (override)" : ""] [rockhill_timestamp()]"
	return ..()

/datum/controller/subsystem/rockhill_daynight/fire(resumed)
	var/time = rockhill_time()
	if(SSticker.HasRoundStarted())
		update_phase(time)
	var/datum/rockhill_clock_step/sky/now = rockhill_clock_step_at(steps, time)
	if(GLOB.rockhill_time_override && phase)
		now = locate(phase.sky) in steps
	if(now != current)
		current = now
		from_color = shown_color
		target_color = pick(now.colors)
		transition_start = world.time
	if(shown_color == target_color)
		return
	var/progress = min(1, (world.time - transition_start) / ROCKHILL_DAY_TRANSITION)
	shown_color = progress >= 1 ? target_color : BlendRGB(from_color, target_color, progress)
	apply_sky(shown_color)
	if(progress >= 1)
		update_emitters(target_color)

/datum/controller/subsystem/rockhill_daynight/proc/update_phase(time)
	var/datum/rockhill_clock_step/phase/now = rockhill_clock_step_at(phases, time)
	if(GLOB.rockhill_time_override)
		for(var/datum/rockhill_clock_step/phase/forced as anything in phases)
			if(forced.name == GLOB.rockhill_time_override)
				now = forced
	if(now == phase)
		return
	var/datum/rockhill_clock_step/phase/old = phase
	phase = now
	GLOB.rockhill_time_of_day = now.name
	if(now.name == ROCKHILL_DAWN)
		GLOB.rockhill_days_passed = GLOB.rockhill_days_passed % length(GLOB.rockhill_day_names) + 1
		GLOB.rockhill_dawns++
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_ROCKHILL_TIME_OF_DAY, old, now)
	if(now.name == ROCKHILL_DAWN)
		rockhill_announce_new_dawn()
	for(var/mob/living/player as anything in GLOB.alive_player_list)
		player.rockhill_time_change()
	rockhill_refresh_all_area_sounds()

/datum/controller/subsystem/rockhill_daynight/proc/apply_sky(new_color)
	var/old_color = GLOB.starlight_color
	if(old_color == new_color)
		return
	GLOB.starlight_color = new_color
	for(var/obj/light as anything in GLOB.starlight_objects)
		light.color = new_color
	SEND_GLOBAL_SIGNAL(COMSIG_STARLIGHT_COLOR_CHANGED, old_color, new_color)

/datum/controller/subsystem/rockhill_daynight/proc/update_emitters(new_color, force = FALSE)
	if(!force && SSrogue_light.splits_sun())
		return
	for(var/turf/emitter as anything in GLOB.rockhill_sun_emitters)
		rockhill_light_emitter(emitter, new_color)

/datum/controller/subsystem/rockhill_daynight/proc/carrier_changed(datum/source, carrier)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(update_emitters), target_color, TRUE)

/mob/get_status_tab_items()
	. = ..()
	if(GLOB.rockhill_time_of_day)
		. += "Time of day: [rockhill_day_name()] ᛉ [uppertext(GLOB.rockhill_time_of_day)] ᛉ [rockhill_timestamp()]"
		. += "IC Date: [rockhill_date_short()]"

ADMIN_VERB(rockhill_set_clock, R_ADMIN, "Set Clock", "Set the Rockhill clock to any hour, freeze it or let it run again.", ADMIN_CATEGORY_ROGUE)
	if(!SSrockhill_daynight.initialized || !SSrockhill_daynight.can_fire)
		to_chat(user, span_warning("This map has no Rockhill sky."))
		return
	var/frozen = !isnull(GLOB.rockhill_clock_frozen)
	var/list/choices = list("Set the hour", frozen ? "Let the clock run" : "Freeze the clock")
	var/choice = tgui_input_list(user, "It is [rockhill_timestamp()][frozen ? ", the clock is frozen" : ""].", "Rockhill clock", choices)
	if(!choice)
		return
	switch(choice)
		if("Set the hour")
			var/hour = tgui_input_number(user, "Hour (0-23)", "Rockhill clock", text2num(rockhill_timestamp("hh")), 23, 0)
			if(isnull(hour))
				return
			var/minute = tgui_input_number(user, "Minute (0-59)", "Rockhill clock", 0, 59, 0)
			if(isnull(minute))
				return
			rockhill_set_clock(hour HOURS + minute MINUTES, frozen)
		if("Freeze the clock")
			rockhill_set_clock(rockhill_time(), TRUE)
		if("Let the clock run")
			rockhill_set_clock(rockhill_time(), FALSE)
	message_admins("[key_name_admin(user)] set the Rockhill clock: [choice], now [rockhill_timestamp()].")
	log_admin("[key_name(user)] set the Rockhill clock: [choice], now [rockhill_timestamp()].")
	BLACKBOX_LOG_ADMIN_VERB("Set Rockhill Clock")

ADMIN_VERB(rockhill_set_time_of_day, R_DEBUG, "SetTODOverride", "Force the Rockhill time of day, or hand it back to the clock.", ADMIN_CATEGORY_ROGUE)
	if(!SSrockhill_daynight.initialized || !SSrockhill_daynight.can_fire)
		to_chat(user, span_warning("This map has no Rockhill sky."))
		return
	var/list/choices = list(ROCKHILL_DAWN, ROCKHILL_DAY, ROCKHILL_DUSK, ROCKHILL_NIGHT, ROCKHILL_CLOCK)
	var/choice = tgui_input_list(user, "Set time of day override", "Time of day", choices, GLOB.rockhill_time_override || ROCKHILL_CLOCK)
	if(!choice)
		return
	GLOB.rockhill_time_override = choice == ROCKHILL_CLOCK ? null : choice
	if(SSticker.HasRoundStarted())
		SSrockhill_daynight.update_phase(rockhill_time())
	message_admins("[key_name_admin(user)] [GLOB.rockhill_time_override ? "set the time of day override to [choice]" : "disabled the time of day override"].")
	log_admin("[key_name(user)] [GLOB.rockhill_time_override ? "set the time of day override to [choice]" : "disabled the time of day override"].")
	BLACKBOX_LOG_ADMIN_VERB("Set Time of Day Override")
