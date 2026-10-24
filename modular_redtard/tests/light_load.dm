#ifdef REDTARD_LIGHT_LOAD

#define ROGUE_LOAD_FILE "data/light_load.json"
#define ROGUE_LOAD_PLAYERS 40
#define ROGUE_LOAD_STEP (1 SECONDS)
#define ROGUE_LOAD_WARMUP (60 SECONDS)
#define ROGUE_LOAD_PHASE (180 SECONDS)
#define ROGUE_LOAD_SKY_GAP (60 SECONDS)
#define ROGUE_LOAD_LANTERN_RANGE 4
#define ROGUE_LOAD_LANTERN_POWER 1
#define ROGUE_LOAD_LANTERN_COLOR "#ffb060"
#define ROGUE_LOAD_SKY_NIGHT "#33406b"
#define ROGUE_LOAD_SKY_DAY "#f2e6c7"

GLOBAL_LIST_EMPTY(rogue_load_players)
GLOBAL_LIST_EMPTY(rogue_load_results)
GLOBAL_VAR_INIT(rogue_load_walking, FALSE)

/datum/controller/subsystem/rogue_light/Initialize()
	Master.sleep_offline_after_initializations = FALSE
	. = ..()
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(rogue_load_launch)), 20 SECONDS)

/proc/rogue_load_launch()
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(rogue_load_run))

/proc/rogue_load_save()
	rustg_file_write(json_encode(GLOB.rogue_load_results), ROGUE_LOAD_FILE)

/proc/rogue_load_walk()
	while(GLOB.rogue_load_walking)
		for(var/mob/living/carbon/human/player as anything in GLOB.rogue_load_players)
			if(!QDELETED(player))
				step(player, pick(GLOB.cardinals))
		sleep(ROGUE_LOAD_STEP)

/proc/rogue_load_phase(label, duration, sky_changes)
	rogue_bench_reset()
	var/started = REALTIMEOFDAY
	var/cpu_total = 0
	var/samples = 0
	var/dilation_total = 0
	var/next_sky = started + ROGUE_LOAD_SKY_GAP
	var/sky_index = 0
	while(REALTIMEOFDAY - started < duration)
		sleep(1 SECONDS)
		cpu_total += world.cpu
		dilation_total += SStime_track.time_dilation_current
		samples++
		if(sky_changes && sky_index < sky_changes && REALTIMEOFDAY >= next_sky)
			sky_index++
			SSrockhill_daynight.update_emitters(sky_index % 2 ? ROGUE_LOAD_SKY_NIGHT : ROGUE_LOAD_SKY_DAY)
			next_sky = REALTIMEOFDAY + ROGUE_LOAD_SKY_GAP
	var/seconds = (REALTIMEOFDAY - started) / 10
	GLOB.rogue_load_results[label] = list(
		"seconds" = seconds,
		"lighting_ms_per_s" = round((GLOB.rogue_bench_lighting_ms + GLOB.rogue_bench_rogue_ms) / seconds, 0.01),
		"cpu" = round(cpu_total / max(samples, 1), 0.1),
		"dilation" = round(dilation_total / max(samples, 1), 0.1),
		"sky_changes" = sky_index,
	)
	rogue_load_save()
	log_world("LIGHT LOAD: [label] [json_encode(GLOB.rogue_load_results[label])]")

/proc/rogue_load_run()
	SSrockhill_daynight.can_fire = FALSE
	SSrockhill_weather.can_fire = FALSE
	GLOB.rogue_load_results["carrier"] = SSrogue_light.carrier_mode
	GLOB.rogue_load_results["backend"] = SSrogue_light.native ? ROGUE_LIGHT_BACKEND_NATIVE : ROGUE_LIGHT_BACKEND_DM
	rogue_bench_wait_settled()
	rogue_load_phase("idle", ROGUE_LOAD_PHASE / 3, 0)
	var/list/spots = rogue_bench_spots()
	for(var/index in 1 to ROGUE_LOAD_PLAYERS)
		var/turf/spot = spots[(index * 104729) % length(spots) + 1]
		var/mob/living/carbon/human/player = new(spot)
		ADD_TRAIT(player, TRAIT_GODMODE, "light_load")
		player.set_light(l_range = ROGUE_LOAD_LANTERN_RANGE, l_power = ROGUE_LOAD_LANTERN_POWER, l_color = ROGUE_LOAD_LANTERN_COLOR)
		GLOB.rogue_load_players += player
	GLOB.rogue_load_walking = TRUE
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(rogue_load_walk))
	sleep(ROGUE_LOAD_WARMUP)
	rogue_load_phase("walking", ROGUE_LOAD_PHASE, 0)
	rogue_load_phase("walking_sky", ROGUE_LOAD_PHASE, 2)
	GLOB.rogue_load_walking = FALSE
	GLOB.rogue_load_results["tents"] = SSrogue_light.tent_count
	GLOB.rogue_load_results["done"] = TRUE
	rogue_load_save()
	log_world("LIGHT LOAD: done")

#undef ROGUE_LOAD_FILE
#undef ROGUE_LOAD_PLAYERS
#undef ROGUE_LOAD_STEP
#undef ROGUE_LOAD_WARMUP
#undef ROGUE_LOAD_PHASE
#undef ROGUE_LOAD_SKY_GAP
#undef ROGUE_LOAD_LANTERN_RANGE
#undef ROGUE_LOAD_LANTERN_POWER
#undef ROGUE_LOAD_LANTERN_COLOR
#undef ROGUE_LOAD_SKY_NIGHT
#undef ROGUE_LOAD_SKY_DAY

#endif
