/particles/weather/rockhill
	icon = 'modular_redtard/rockhill/icons/effects/particles/particle.dmi'
	count = 3000
	bound1 = list(-500, -256, -10)
	bound2 = list(500, 500, 10)
	lifespan = 285
	fade = 10
	fadein = 5
	transform = list(
		1, 0, 0, 0,
		0, 1, 0, 0,
		0, 0, 1, 1/4,
		0, 0, 0, 1,
	)

/particles/weather/rockhill/animate_severity(severity, wind_sign)
	spawning = severity > 0 ? max(min_spawn, max_spawn * max(ROCKHILL_WEATHER_MIN_STRENGTH, severity)) : 0

/particles/weather/rockhill/rain
	icon_state = "drop"
	color = "#ccffff"
	position = generator(GEN_BOX, list(-500, -256, 0), list(400, 500, 0))
	grow = list(-0.01, -0.01)
	gravity = list(0, -10, 0.5)
	drift = generator(GEN_CIRCLE, 0, 1)
	friction = 0.3
	transform = null
	spin = 0
	min_spawn = 50
	max_spawn = 250

/particles/weather/rockhill/snow
	icon_state = list("cross" = 2, "snow_1" = 5, "snow_2" = 2, "snow_3" = 2)
	color = "#ffffff"
	position = generator(GEN_BOX, list(-500, -256, 5), list(500, 500, 0))
	spin = generator(GEN_NUM, -10, 10)
	gravity = list(0, -2, 0.1)
	drift = generator(GEN_CIRCLE, 0, 3)
	friction = 0.3
	transform = null
	count = 150
	min_spawn = 5
	max_spawn = 30

/particles/weather/rockhill/snow/storm
	icon_state = list("cross" = 2, "snow_1" = 5, "snow_2" = 2, "snow_3" = 2, "puff" = 1)
	gravity = list(0, -4, 0.5)
	count = 3000
	min_spawn = 10
	max_spawn = 80

/particles/weather/rockhill/leaves
	icon_state = list("leaf1" = 7, "leaf2" = 1, "leaf3" = 1)
	spin = 6
	position = generator(GEN_BOX, list(-500, -256, 0), list(400, 500, 0))
	gravity = list(0, -1, 0.1)
	friction = 0.3
	transform = null
	lifespan = 55
	fadein = 6
	min_spawn = 3
	max_spawn = 25

/particles/weather/rockhill/fireflies
	icon_state = list("firefly_1" = 2, "firefly_2" = 4)
	count = 150
	position = generator(GEN_BOX, list(-500, -256, 5), list(500, 500, 0))
	spin = generator(GEN_NUM, -2, 2)
	gravity = list(0, 1, 0)
	drift = generator(GEN_CIRCLE, 0, 2)
	friction = 0.4
	transform = null
	lifespan = 30
	min_spawn = 5
	max_spawn = 10

/particles/weather/rockhill/fog
	icon = 'modular_redtard/rockhill/icons/effects/96x96.dmi'
	icon_state = list("smoke-static" = 5, "smoke-static-alt" = 5)
	gradient = list(0, "#a1a1a1e3", 100, "#e2dcd8e3", "loop")
	color = 0
	color_change = generator(GEN_NUM, 0, 3)
	position = generator(GEN_BOX, list(-500, -256, 0), list(500, 500, 0))
	gravity = list(-1, 0.1)
	drift = generator(GEN_CIRCLE, 0, 3)
	friction = 0.3
	max_spawn = 35

/particles/weather/rockhill/heat
	icon = 'modular_redtard/rockhill/icons/effects/effects.dmi'
	icon_state = "heatwave"
	color = "#453723"
	position = generator(GEN_BOX, list(-600, -256, 5), list(600, 500, 0))
	gravity = list(0, 0.02, 0)
	drift = generator(GEN_BOX, list(-0.2, 0.2, 0), list(0.2, 0.6, 0))
	fade = 1.5
	fadein = 2
	friction = 0.02
	transform = null
	min_spawn = 10
	max_spawn = 40

/particles/weather/rockhill/static_spark
	icon_state = "spark"
	color = "#f8ff30"
	position = generator(GEN_BOX, list(-400, -300, 0), list(400, 300, 0))
	gravity = list(0, 0, 0)
	drift = generator(GEN_CIRCLE, 0, 0.6)
	scale = generator(GEN_NUM, 0.4, 0.7)
	lifespan = 50
	min_spawn = 1
	max_spawn = 3

/datum/weather/particle/rockhill
	abstract_type = /datum/weather/particle/rockhill
	telegraph_message = null
	weather_message = null
	end_message = null
	weather_duration_lower = 1 MINUTES
	weather_duration_upper = 3 MINUTES
	area_type = /area/rogue
	weather_flags = WEATHER_INDOORS
	overlay_planes = list()
	use_glow = FALSE
	var/severity_steps = 5
	var/lightning_strikes = 0
	COOLDOWN_DECLARE(lightning_cooldown)

/datum/weather/particle/rockhill/setup_weather_areas(list/forced_areas)
	return ..(forced_areas || rockhill_sky_areas())

/datum/weather/particle/rockhill/telegraph(list/weather_data)
	. = ..()
	severity_cooldown = max(initial(severity_cooldown), weather_duration / severity_steps)

/datum/weather/particle/rockhill/end()
	. = ..()
	if(.)
		qdel(src)

/datum/weather/particle/rockhill/proc/rockhill_tick()
	if(!lightning_strikes || stage != MAIN_STAGE || !length(GLOB.alive_player_list) || !COOLDOWN_FINISHED(src, lightning_cooldown))
		return
	COOLDOWN_START(src, lightning_cooldown, rand(ROCKHILL_LIGHTNING_MIN_DELAY, ROCKHILL_LIGHTNING_MAX_DELAY))
	for(var/i in 1 to lightning_strikes)
		var/mob/living/watcher = pick(GLOB.alive_player_list)
		if(!istype(watcher) || !(watcher.z in impacted_z_levels))
			continue
		var/list/candidates = list()
		for(var/turf/open/nearby in RANGE_TURFS(ROCKHILL_LIGHTNING_RANGE, watcher))
			if(nearby.loc in impacted_areas)
				candidates += nearby
		if(length(candidates))
			new /obj/effect/temp_visual/rockhill_lightning(pick(candidates))

/obj/effect/temp_visual/rockhill_lightning
	icon = 'modular_redtard/rockhill/icons/effects/32x200.dmi'
	icon_state = "lightning"
	plane = ABOVE_GAME_PLANE
	layer = FLY_LAYER
	randomdir = FALSE
	duration = 1.2 SECONDS
	light_system = OVERLAY_LIGHT
	light_range = 15
	light_power = 3
	light_color = COLOR_PALE_BLUE_GRAY
	light_on = TRUE

/datum/weather/particle/rockhill/rain_gentle
	name = "Rain"
	desc = "Gentle rain falls over the realm."
	particle_type = /particles/weather/rockhill/rain
	min_severity = 7
	optimal_severity = 53
	severity_variation = 13

/datum/weather/particle/rockhill/rain_storm
	name = "Rain Storm"
	desc = "Dark clouds break into a heavy storm."
	particle_type = /particles/weather/rockhill/rain
	min_severity = 4
	optimal_severity = 52
	severity_variation = 50
	severity_steps = 50
	lightning_strikes = 6

/datum/weather/particle/rockhill/snow_gentle
	name = "Snowfall"
	desc = "Flakes swirl as snow drifts down from the sky."
	particle_type = /particles/weather/rockhill/snow
	min_severity = 25
	optimal_severity = 62
	severity_variation = 25

/datum/weather/particle/rockhill/snow_storm
	name = "Snow storm"
	desc = "A heavy blizzard buries the realm."
	particle_type = /particles/weather/rockhill/snow/storm
	weather_duration_lower = 4 MINUTES
	weather_duration_upper = 10 MINUTES
	min_severity = 40
	optimal_severity = 70
	severity_variation = 50
	severity_steps = 50

/datum/weather/particle/rockhill/leaves_gentle
	name = "Strong Winds"
	desc = "Strong winds carry leaves across the realm."
	particle_type = /particles/weather/rockhill/leaves
	min_severity = 7
	optimal_severity = 53
	severity_variation = 13

/datum/weather/particle/rockhill/fog
	name = "Fog"
	desc = "A cold mist rolls in, swallowing the horizon."
	particle_type = /particles/weather/rockhill/fog
	weather_duration_upper = 10 MINUTES
	min_severity = 33
	optimal_severity = 67
	severity_variation = 13

/datum/weather/particle/rockhill/fireflies
	name = "Fireflies"
	desc = "Tiny glowing insects drift lazily through the air."
	emissive_type = /particles/weather/rockhill/fireflies
	min_severity = 20
	optimal_severity = 60
	severity_variation = 100

/datum/weather/particle/rockhill/heat_wave
	name = "Heatwave"
	desc = "The air ripples with brutal, suffocating heat."
	particle_type = /particles/weather/rockhill/heat
	min_severity = 40
	optimal_severity = 70
	severity_variation = 50
	severity_steps = 50

/datum/weather/particle/rockhill/dry_thunderstorm
	name = "Dry Thunderstorm"
	desc = "Thunder cracks overhead, but no rain follows."
	particle_type = /particles/weather/rockhill/static_spark
	min_severity = 4
	optimal_severity = 52
	severity_variation = 50
	severity_steps = 50
	lightning_strikes = 10

/datum/rockhill_clock_step/phase
	var/weather_chance = 0
	var/list/weathers

/datum/rockhill_clock_step/phase/dawn
	weather_chance = 20
	weathers = list(
		/datum/weather/particle/rockhill/rain_gentle = 20,
		/datum/weather/particle/rockhill/fireflies = 20,
		/datum/weather/particle/rockhill/leaves_gentle = 15,
		/datum/weather/particle/rockhill/fog = 10,
		/datum/weather/particle/rockhill/snow_gentle = 10,
		/datum/weather/particle/rockhill/heat_wave = 5,
		/datum/weather/particle/rockhill/rain_storm = 3,
		/datum/weather/particle/rockhill/dry_thunderstorm = 2,
		/datum/weather/particle/rockhill/snow_storm = 2,
	)

/datum/rockhill_clock_step/phase/day
	weather_chance = 15
	weathers = list(
		/datum/weather/particle/rockhill/rain_gentle = 25,
		/datum/weather/particle/rockhill/leaves_gentle = 20,
		/datum/weather/particle/rockhill/snow_gentle = 10,
		/datum/weather/particle/rockhill/heat_wave = 10,
		/datum/weather/particle/rockhill/fog = 5,
		/datum/weather/particle/rockhill/rain_storm = 5,
		/datum/weather/particle/rockhill/dry_thunderstorm = 3,
	)

/datum/rockhill_clock_step/phase/dusk
	weather_chance = 20
	weathers = list(
		/datum/weather/particle/rockhill/rain_gentle = 20,
		/datum/weather/particle/rockhill/fireflies = 20,
		/datum/weather/particle/rockhill/leaves_gentle = 15,
		/datum/weather/particle/rockhill/fog = 10,
		/datum/weather/particle/rockhill/snow_gentle = 10,
		/datum/weather/particle/rockhill/rain_storm = 5,
		/datum/weather/particle/rockhill/heat_wave = 5,
		/datum/weather/particle/rockhill/dry_thunderstorm = 2,
		/datum/weather/particle/rockhill/snow_storm = 2,
	)

/datum/rockhill_clock_step/phase/night
	weather_chance = 20
	weathers = list(
		/datum/weather/particle/rockhill/rain_gentle = 25,
		/datum/weather/particle/rockhill/fireflies = 25,
		/datum/weather/particle/rockhill/fog = 15,
		/datum/weather/particle/rockhill/snow_gentle = 10,
		/datum/weather/particle/rockhill/leaves_gentle = 10,
		/datum/weather/particle/rockhill/rain_storm = 5,
		/datum/weather/particle/rockhill/snow_storm = 2,
		/datum/weather/particle/rockhill/heat_wave = 2,
		/datum/weather/particle/rockhill/dry_thunderstorm = 2,
	)

SUBSYSTEM_DEF(rockhill_weather)
	name = "Rockhill Weather"
	ss_flags = SS_BACKGROUND
	dependencies = list(
		/datum/controller/subsystem/weather,
		/datum/controller/subsystem/rockhill_daynight,
	)
	wait = 1 SECONDS
	runlevels = RUNLEVEL_GAME
	var/list/sky_levels
	var/queued_timer

/datum/controller/subsystem/rockhill_weather/Initialize()
	sky_levels = list()
	for(var/area/rogue/area as anything in rockhill_sky_areas())
		for(var/z in 1 to length(area.turfs_by_zlevel))
			if(length(area.turfs_by_zlevel[z]))
				sky_levels |= z
	if(!length(sky_levels))
		can_fire = FALSE
		return SS_INIT_NO_NEED
	RegisterSignal(SSdcs, COMSIG_GLOB_ROCKHILL_TIME_OF_DAY, PROC_REF(roll_forecast))
	return SS_INIT_SUCCESS

/datum/controller/subsystem/rockhill_weather/stat_entry(msg)
	var/datum/weather/active = active_weather()
	msg = "[active ? active.name : (queued_timer ? "queued" : "clear")]"
	return ..()

/datum/controller/subsystem/rockhill_weather/fire(resumed)
	for(var/datum/weather/particle/rockhill/weather in SSweather.processing)
		weather.process_particles()
		weather.rockhill_tick()

/datum/controller/subsystem/rockhill_weather/proc/roll_forecast(datum/source, datum/rockhill_clock_step/phase/old_phase, datum/rockhill_clock_step/phase/new_phase)
	SIGNAL_HANDLER
	if(GLOB.rockhill_time_override || queued_timer || active_weather() || !prob(new_phase.weather_chance))
		return
	var/datum/weather/weather_type = pick_weight(new_phase.weathers)
	queued_timer = addtimer(CALLBACK(src, PROC_REF(start_weather), weather_type), rand(0, ROCKHILL_WEATHER_MAX_DELAY) + initial(weather_type.weather_duration_upper), TIMER_STOPPABLE)

/datum/controller/subsystem/rockhill_weather/proc/active_weather()
	return locate(/datum/weather/particle/rockhill) in SSweather.processing

/datum/controller/subsystem/rockhill_weather/proc/start_weather(weather_type)
	queued_timer = null
	SSweather.run_weather(weather_type, sky_levels)

ADMIN_VERB(rockhill_run_weather, R_ADMIN|R_FUN, "Weather - Particle", "Start a Rockhill weather right now on every level under the sky.", ADMIN_CATEGORY_EVENTS)
	if(!SSrockhill_weather.initialized || !SSrockhill_weather.can_fire)
		to_chat(user, span_warning("This map has no Rockhill sky."))
		return
	var/list/choices = list()
	for(var/datum/weather/particle/rockhill/weather_type as anything in valid_subtypesof(/datum/weather/particle/rockhill))
		choices[initial(weather_type.name)] = weather_type
	var/choice = tgui_input_list(user, "Choose a weather", "Weather", choices)
	if(!choice)
		return
	SSrockhill_weather.force_weather(choices[choice])
	message_admins("[key_name_admin(user)] started weather of type [choices[choice]].")
	log_admin("[key_name(user)] started weather of type [choices[choice]].")
	BLACKBOX_LOG_ADMIN_VERB("Run Rockhill Weather")

/datum/controller/subsystem/rockhill_weather/proc/force_weather(weather_type)
	if(queued_timer)
		deltimer(queued_timer)
		queued_timer = null
	var/datum/weather/active = active_weather()
	active?.end()
	start_weather(weather_type)
