GLOBAL_LIST_EMPTY(rockhill_weather_sounds)

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
	target_trait = ZTRAIT_ROCKHILL_WEATHER
	weather_flags = WEATHER_INDOORS | WEATHER_STRICT_ALERT
	overlay_planes = list()
	use_glow = FALSE
	var/severity_steps = 5
	var/lightning_strikes = 0
	var/rockhill_warning
	var/datum/looping_sound/outdoor_sound
	var/datum/looping_sound/indoor_sound
	var/rockhill_temperature_shift = 0
	var/rockhill_wet_stacks = 0
	var/rockhill_clean = NONE
	var/rockhill_douses_fires = FALSE
	var/datum/mood_event/rockhill_mood
	COOLDOWN_DECLARE(lightning_cooldown)

/datum/weather/particle/rockhill/setup_weather_areas(list/forced_areas)
	return ..(forced_areas || rockhill_sky_areas())

/datum/weather/particle/rockhill/get_playlist_ref()
	return GLOB.rockhill_weather_sounds

/datum/weather/particle/rockhill/telegraph(list/weather_data)
	GLOB.rockhill_weather_sounds.Cut()
	for(var/area/rogue/area in GLOB.areas)
		var/loop_type = (area in impacted_areas) ? outdoor_sound : indoor_sound
		if(loop_type)
			GLOB.rockhill_weather_sounds[area] = loop_type
	. = ..()
	severity_cooldown = max(initial(severity_cooldown), weather_duration / severity_steps)

/datum/weather/particle/rockhill/end()
	. = ..()
	if(.)
		GLOB.rockhill_weather_sounds.Cut()
		qdel(src)

/datum/weather/particle/rockhill/weather_act_mob(mob/living/living)
	if(rockhill_temperature_shift)
		var/delta = BODYTEMP_NORMAL + rockhill_temperature_shift - living.bodytemperature
		if(delta * rockhill_temperature_shift > 0)
			if(iscarbon(living))
				var/mob/living/carbon/carbon_living = living
				carbon_living.adjust_bodytemperature(delta, use_insulation = TRUE, use_steps = TRUE)
			else
				living.adjust_bodytemperature(delta > 0 ? min(delta / BODYTEMP_HEAT_DIVISOR, BODYTEMP_HEATING_MAX) : max(delta / BODYTEMP_COLD_DIVISOR, BODYTEMP_COOLING_MAX))
	if(rockhill_wet_stacks)
		living.extinguish_mob()
		living.adjust_wet_stacks(rockhill_wet_stacks)
	if(rockhill_clean && prob(ROCKHILL_RAIN_WASH_CHANCE))
		living.wash(rockhill_clean)
	if(rockhill_mood && living.client)
		living.add_mood_event("rockhill_weather", rockhill_mood)

/datum/weather/particle/rockhill/proc/rockhill_douse_fires()
	if(!rockhill_douses_fires || stage != MAIN_STAGE)
		return
	for(var/obj/machinery/light/rogue/campfire/fire as anything in GLOB.rockhill_lit_fires)
		if(istype(fire) && fire.crossfire && (get_area(fire) in impacted_areas))
			fire.extinguish()

/datum/weather/particle/rockhill/proc/rockhill_tick()
	rockhill_douse_fires()
	if(!lightning_strikes || stage != MAIN_STAGE || !length(GLOB.alive_player_list) || !COOLDOWN_FINISHED(src, lightning_cooldown))
		return
	COOLDOWN_START(src, lightning_cooldown, rand(ROCKHILL_LIGHTNING_MIN_DELAY, ROCKHILL_LIGHTNING_MAX_DELAY))
	for(var/i in 1 to lightning_strikes)
		var/mob/living/watcher = pick(GLOB.alive_player_list)
		if(!istype(watcher) || !(watcher.z in impacted_z_levels))
			continue
		if((get_area(watcher) in impacted_areas) && watcher.rogue_badluck(ROCKHILL_LIGHTNING_BADLUCK))
			rockhill_strike(watcher)
		var/list/candidates = list()
		for(var/turf/open/nearby in RANGE_TURFS(ROCKHILL_LIGHTNING_RANGE, watcher))
			if(nearby.loc in impacted_areas)
				candidates += nearby
		if(length(candidates))
			new /obj/effect/temp_visual/rockhill_lightning(pick(candidates))

/datum/weather/particle/rockhill/proc/rockhill_strike(mob/living/victim)
	new /obj/effect/temp_visual/rockhill_lightning(get_turf(victim))
	victim.electrocute_act(ROCKHILL_LIGHTNING_DAMAGE, "lightning", 1, SHOCK_NOSTUN)
	victim.Immobilize(ROCKHILL_LIGHTNING_IMMOBILIZE)
	victim.changeNext_move(ROCKHILL_LIGHTNING_CLICK_DELAY)
	victim.log_message("was struck by lightning", LOG_GAME)

/datum/weather/particle/rockhill/proc/rockhill_visuals()
	return

/datum/weather/particle/rockhill/heat_wave/rockhill_visuals()
	if(stage != MAIN_STAGE || !length(GLOB.alive_player_list) || !COOLDOWN_FINISHED(src, ripple_cooldown))
		return
	COOLDOWN_START(src, ripple_cooldown, rand(ROCKHILL_RIPPLE_MIN_DELAY, ROCKHILL_RIPPLE_MAX_DELAY))
	for(var/i in 1 to clamp(round(severity / ROCKHILL_RIPPLE_SEVERITY_STEP), 1, ROCKHILL_RIPPLE_MAX))
		var/mob/living/watcher = pick(GLOB.alive_player_list)
		if(!istype(watcher) || !(watcher.z in impacted_z_levels))
			continue
		var/list/candidates = rockhill_turfs_near(watcher, ROCKHILL_RIPPLE_RANGE)
		if(length(candidates))
			new /obj/effect/temp_visual/rockhill_heat_ripple(pick(candidates))

/datum/weather/particle/rockhill/fog/New(list/z_levels, list/weather_data)
	. = ..()
	for(var/z_level, holder_list in weather_objects)
		for(var/obj/effect/abstract/weather_holder/holder as anything in holder_list)
			holder.add_filter("rockhill_fog_light", 1, alpha_mask_filter(render_source = OFFSET_RENDER_TARGET(get_plane_master_render_base(ROCKHILL_OVERLAY_LIGHT_PLATE), GET_Z_PLANE_OFFSET(z_level)), flags = MASK_INVERSE))

/datum/weather/particle/rockhill/proc/rockhill_turfs_near(mob/living/watcher, range)
	. = list()
	for(var/turf/open/nearby in RANGE_TURFS(range, watcher))
		if(nearby.loc in impacted_areas)
			. += nearby

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

/obj/effect/temp_visual/rockhill_lightning/Initialize(mapload)
	. = ..()
	playsound(src, 'modular_redtard/rockhill/sound/weather/rain/thunder_1.ogg', 80, TRUE)

/obj/effect/temp_visual/rockhill_heat_ripple
	icon = 'modular_redtard/rockhill/icons/effects/effects.dmi'
	icon_state = "heatwave"
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE
	alpha = 0
	randomdir = FALSE
	duration = 2 SECONDS

/obj/effect/temp_visual/rockhill_heat_ripple/Initialize(mapload)
	. = ..()
	animate(src, alpha = rand(20, 40), time = 0.5 SECONDS)
	animate(src, transform = matrix(1.02, 0, rand(-0.3, 0.3), 0, 0.98, rand(0, 0.6)), time = rand(6, 10), easing = SINE_EASING, loop = -1, flags = ANIMATION_PARALLEL)
	animate(transform = matrix(0.98, 0, rand(-0.3, 0.3), 0, 1.02, rand(0, 0.6)), time = rand(6, 10), easing = SINE_EASING)

/datum/looping_sound/rockhill_weather
	sound_channel = CHANNEL_WEATHER
	direct = TRUE

/datum/looping_sound/rockhill_weather/rain
	mid_sounds = 'modular_redtard/rockhill/sound/weather/rain/weather_rain.ogg'
	mid_length = 40 SECONDS
	volume = 100

/datum/looping_sound/rockhill_weather/indoor_rain
	mid_sounds = 'modular_redtard/rockhill/sound/weather/rain/weather_rain_indoors.ogg'
	mid_length = 15 SECONDS
	volume = 100

/datum/looping_sound/rockhill_weather/storm
	mid_sounds = 'modular_redtard/rockhill/sound/weather/rain/weather_storm.ogg'
	mid_length = 30 SECONDS
	volume = 100

/datum/looping_sound/rockhill_weather/snow
	mid_sounds = 'modular_redtard/rockhill/sound/weather/snow/weather_snow.ogg'
	mid_length = 50 SECONDS
	volume = 100

/datum/looping_sound/rockhill_weather/sandstorm
	mid_sounds = 'modular_redtard/rockhill/sound/weather/sand/weather_sandstorm.ogg'
	mid_length = 14 SECONDS
	volume = 100

/datum/looping_sound/rockhill_weather/wind
	mid_sounds = list(
		'modular_redtard/rockhill/sound/weather/rain/wind_1.ogg' = 1,
		'modular_redtard/rockhill/sound/weather/rain/wind_2.ogg' = 1,
		'modular_redtard/rockhill/sound/weather/rain/wind_3.ogg' = 1,
		'modular_redtard/rockhill/sound/weather/rain/wind_4.ogg' = 1,
		'modular_redtard/rockhill/sound/weather/rain/wind_5.ogg' = 1,
		'modular_redtard/rockhill/sound/weather/rain/wind_6.ogg' = 1,
	)
	mid_length = 30 SECONDS
	volume = 100

/datum/looping_sound/rockhill_weather/drythunder
	mid_sounds = list(
		'modular_redtard/rockhill/sound/weather/rain/thunder_1.ogg' = 1,
		'modular_redtard/rockhill/sound/weather/rain/thunder_2.ogg' = 1,
		'modular_redtard/rockhill/sound/weather/rain/thunder_3.ogg' = 1,
		'modular_redtard/rockhill/sound/weather/rain/thunder_4.ogg' = 1,
		'modular_redtard/rockhill/sound/weather/rain/thunder_5.ogg' = 1,
		'modular_redtard/rockhill/sound/weather/rain/thunder_6.ogg' = 1,
	)
	mid_length = 30 SECONDS
	volume = 100

/datum/looping_sound/rockhill_weather/drythunder/indoors
	volume = 50

/datum/weather/particle/rockhill/rain_gentle
	name = "Rain"
	desc = "Gentle rain falls over the realm."
	particle_type = /particles/weather/rockhill/rain
	min_severity = 7
	optimal_severity = 53
	severity_variation = 13
	weather_flags = WEATHER_INDOORS | WEATHER_STRICT_ALERT | WEATHER_MOBS
	rockhill_temperature_shift = ROCKHILL_RAIN_TEMPERATURE_SHIFT
	rockhill_wet_stacks = ROCKHILL_RAIN_WET_STACKS
	rockhill_clean = CLEAN_WASH
	rockhill_douses_fires = TRUE
	rockhill_warning = span_greenannounce("Grey clouds gather up above the realm, beholding the gift of life.")
	telegraph_message = span_greenannounce("Heavy drops begin to fall in rapid succession.")
	outdoor_sound = /datum/looping_sound/rockhill_weather/rain
	indoor_sound = /datum/looping_sound/rockhill_weather/indoor_rain

/datum/weather/particle/rockhill/rain_storm
	name = "Rain Storm"
	desc = "Dark clouds break into a heavy storm."
	particle_type = /particles/weather/rockhill/rain
	min_severity = 4
	optimal_severity = 52
	severity_variation = 50
	severity_steps = 50
	lightning_strikes = 6
	weather_flags = WEATHER_INDOORS | WEATHER_STRICT_ALERT | WEATHER_MOBS
	rockhill_temperature_shift = ROCKHILL_STORM_TEMPERATURE_SHIFT
	rockhill_wet_stacks = ROCKHILL_STORM_WET_STACKS
	rockhill_clean = CLEAN_SCRUB
	rockhill_douses_fires = TRUE
	rockhill_warning = span_greenannounce("Dark clouds gather up above the realm, sparks arcing between heavenly reaches.")
	telegraph_message = span_greenannounce("The wind shifts and the storm breaks.")
	outdoor_sound = /datum/looping_sound/rockhill_weather/storm
	indoor_sound = /datum/looping_sound/rockhill_weather/indoor_rain

/datum/weather/particle/rockhill/snow_gentle
	name = "Snowfall"
	desc = "Flakes swirl as snow drifts down from the sky."
	particle_type = /particles/weather/rockhill/snow
	min_severity = 25
	optimal_severity = 62
	severity_variation = 25
	weather_flags = WEATHER_INDOORS | WEATHER_STRICT_ALERT | WEATHER_MOBS
	rockhill_temperature_shift = ROCKHILL_SNOW_TEMPERATURE_SHIFT
	rockhill_warning = span_greenannounce("The air chills across the realm, soft white specs appearing near warm breaths.")
	telegraph_message = span_greenannounce("Flakes swirl as snow starts to drift down from the sky.")
	outdoor_sound = /datum/looping_sound/rockhill_weather/snow

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
	weather_flags = WEATHER_INDOORS | WEATHER_STRICT_ALERT | WEATHER_MOBS
	rockhill_temperature_shift = ROCKHILL_BLIZZARD_TEMPERATURE_SHIFT
	rockhill_warning = span_greenannounce("Heavy clouds build in the sky as the air chills across the realm, soft white specs appearing near warm breaths.")
	telegraph_message = span_greenannounce("Heavy snow begins to fall thick and fast.")
	outdoor_sound = /datum/looping_sound/rockhill_weather/snow

/datum/weather/particle/rockhill/leaves_gentle
	name = "Strong Winds"
	desc = "Strong winds carry leaves across the realm."
	particle_type = /particles/weather/rockhill/leaves
	min_severity = 7
	optimal_severity = 53
	severity_variation = 13
	rockhill_warning = span_greenannounce("Light winds blow in through the forests across the realm.")
	telegraph_message = span_greenannounce("A sudden gust scatters leaves wildly through the air.")

/datum/weather/particle/rockhill/fog
	name = "Fog"
	desc = "A cold mist rolls in, swallowing the horizon."
	particle_type = /particles/weather/rockhill/fog
	weather_duration_upper = 10 MINUTES
	min_severity = 33
	optimal_severity = 67
	severity_variation = 13
	rockhill_warning = span_greenannounce("The air is thick and damp, and a rush of cool dry air foretells what approachs.")
	telegraph_message = span_greenannounce("A cold mist rolls in, swallowing the horizon.")

/datum/weather/particle/rockhill/fireflies
	name = "Fireflies"
	desc = "Tiny glowing insects drift lazily through the air."
	emissive_type = /particles/weather/rockhill/fireflies
	min_severity = 20
	optimal_severity = 60
	severity_variation = 100
	weather_flags = WEATHER_INDOORS | WEATHER_STRICT_ALERT | WEATHER_MOBS
	rockhill_mood = /datum/mood_event/rockhill_fireflies
	rockhill_warning = span_greenannounce("Faint glows appear in the distance across the realm.")
	telegraph_message = span_greenannounce("Tiny lights begin to flicker in and out nearby.")

/datum/weather/particle/rockhill/heat_wave
	name = "Heatwave"
	desc = "The air ripples with brutal, suffocating heat."
	particle_type = /particles/weather/rockhill/heat
	min_severity = 40
	optimal_severity = 70
	severity_variation = 50
	severity_steps = 50
	weather_flags = WEATHER_INDOORS | WEATHER_STRICT_ALERT | WEATHER_MOBS
	rockhill_temperature_shift = ROCKHILL_HEAT_TEMPERATURE_SHIFT
	rockhill_warning = span_greenannounce("A brutal heatwave rolls across the realm, warping the very air.")
	telegraph_message = span_greenannounce("The air becomes stifling and unbearably still.")
	outdoor_sound = /datum/looping_sound/rockhill_weather/sandstorm
	indoor_sound = /datum/looping_sound/rockhill_weather/wind
	COOLDOWN_DECLARE(ripple_cooldown)

/datum/weather/particle/rockhill/dry_thunderstorm
	name = "Dry Thunderstorm"
	desc = "Thunder cracks overhead, but no rain follows."
	particle_type = /particles/weather/rockhill/static_spark
	min_severity = 4
	optimal_severity = 52
	severity_variation = 50
	severity_steps = 50
	lightning_strikes = 10
	rockhill_warning = span_greenannounce("Dark clouds roll across the sky, echo's of thunder rumbling across the dry realm.")
	telegraph_message = span_greenannounce("Thunder cracks overhead, but no rain follows.")
	outdoor_sound = /datum/looping_sound/rockhill_weather/drythunder
	indoor_sound = /datum/looping_sound/rockhill_weather/drythunder/indoors

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
	var/datum/weather/particle/rockhill/queued_type

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
		weather.rockhill_visuals()

/datum/controller/subsystem/rockhill_weather/proc/roll_forecast(datum/source, datum/rockhill_clock_step/phase/old_phase, datum/rockhill_clock_step/phase/new_phase)
	SIGNAL_HANDLER
	if(GLOB.rockhill_time_override || queued_timer || active_weather() || !prob(new_phase.weather_chance))
		return
	var/datum/weather/particle/rockhill/weather_type = pick_weight(new_phase.weathers)
	queued_type = weather_type
	queued_timer = addtimer(CALLBACK(src, PROC_REF(start_weather), weather_type), rand(0, ROCKHILL_WEATHER_MAX_DELAY) + initial(weather_type.weather_duration_upper), TIMER_STOPPABLE)
	var/warning = initial(weather_type.rockhill_warning)
	if(!warning)
		return
	for(var/mob/living/player as anything in GLOB.alive_player_list)
		var/area/rogue/sky = get_area(player)
		if(istype(sky) && sky.rockhill_sunlit)
			to_chat(player, warning)

/datum/controller/subsystem/rockhill_weather/proc/sky_message()
	var/datum/weather/particle/rockhill/active = active_weather()
	if(active)
		return active.rockhill_warning
	return queued_type ? initial(queued_type.rockhill_warning) : null

/datum/controller/subsystem/rockhill_weather/proc/active_weather()
	return locate(/datum/weather/particle/rockhill) in SSweather.processing

/datum/controller/subsystem/rockhill_weather/proc/start_weather(weather_type)
	queued_timer = null
	queued_type = null
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

/datum/mood_event/rockhill_fireflies
	description = "What wonderous fireflies..."
	mood_change = ROCKHILL_FIREFLIES_MOOD
	timeout = ROCKHILL_FIREFLIES_MOOD_TIME
