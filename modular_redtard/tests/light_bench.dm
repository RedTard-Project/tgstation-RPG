#ifdef REDTARD_LIGHT_BENCH

#define ROGUE_BENCH_FLICKERS 300
#define ROGUE_BENCH_SKY_A "#f2e6c7"
#define ROGUE_BENCH_SKY_B "#33406b"
#define ROGUE_BENCH_SETTLE_TIMEOUT (120 SECONDS)
#define ROGUE_BENCH_FILE "data/light_bench.json"

GLOBAL_VAR_INIT(rogue_bench_lighting_ms, 0)
GLOBAL_VAR_INIT(rogue_bench_rogue_ms, 0)
GLOBAL_LIST_EMPTY(rogue_bench_results)
GLOBAL_VAR_INIT(rogue_bench_serial, 0)

/datum/controller/subsystem/lighting/fire(resumed, init_tick_checks)
	var/started = TICK_USAGE_REAL
	. = ..()
	if(!init_tick_checks)
		GLOB.rogue_bench_lighting_ms += (TICK_USAGE_REAL - started) * world.tick_lag

/datum/controller/subsystem/rogue_light/fire(resumed)
	var/started = TICK_USAGE_REAL
	. = ..()
	GLOB.rogue_bench_rogue_ms += (TICK_USAGE_REAL - started) * world.tick_lag

#ifndef REDTARD_LIGHT_BENCH_CLIENT
/datum/controller/subsystem/rogue_light/Initialize()
	Master.sleep_offline_after_initializations = FALSE
	. = ..()
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(rogue_bench_launch)), 20 SECONDS)
#endif

/proc/rogue_bench_launch()
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(rogue_bench_run))

/proc/rogue_bench_settled()
	if(length(SSlighting.sources_queue) || length(SSlighting.corners_queue) || length(SSlighting.objects_queue) || length(SSlighting.current_sources))
		return FALSE
	if(!SSrogue_light.native_ready)
		return TRUE
	if(length(SSrogue_light.pending))
		return FALSE
	SSrogue_light.poll_status()
	var/list/status = SSrogue_light.status
	return length(status) >= ROGUE_LIGHT_STATUS_SIZE && !status[ROGUE_LIGHT_STATUS_JOBS] && !status[ROGUE_LIGHT_STATUS_RECORDS]

/proc/rogue_bench_worker_ms()
	if(!SSrogue_light.native_ready)
		return 0
	SSrogue_light.poll_status()
	var/list/status = SSrogue_light.status
	return length(status) >= ROGUE_LIGHT_STATUS_SIZE ? status[ROGUE_LIGHT_STATUS_TOTAL_JOB_MS] : 0

/proc/rogue_bench_wait_settled()
	var/deadline = REALTIMEOFDAY + ROGUE_BENCH_SETTLE_TIMEOUT
	var/stable = 0
	while(stable < 3)
		if(REALTIMEOFDAY > deadline)
			return FALSE
		sleep(world.tick_lag)
		stable = rogue_bench_settled() ? stable + 1 : 0
	return TRUE

/proc/rogue_bench_reset()
	GLOB.rogue_bench_lighting_ms = 0
	GLOB.rogue_bench_rogue_ms = 0

/proc/rogue_bench_sample(list/into, label, started, worker_before, settled)
	into[label] = list(
		"wall_ms" = (REALTIMEOFDAY - started) * 100,
		"main_ms" = round(GLOB.rogue_bench_lighting_ms + GLOB.rogue_bench_rogue_ms, 0.1),
		"lighting_ms" = round(GLOB.rogue_bench_lighting_ms, 0.1),
		"rogue_ms" = round(GLOB.rogue_bench_rogue_ms, 0.1),
		"worker_ms" = rogue_bench_worker_ms() - worker_before,
		"settled" = settled,
	)

/proc/rogue_bench_switch(list/into, backend, carrier)
	var/started = REALTIMEOFDAY
	var/is_native = SSrogue_light.native
	if((backend == ROGUE_LIGHT_BACKEND_NATIVE) != is_native)
		SSrogue_light.set_backend(backend)
	SSrogue_light.set_carrier_mode(carrier)
	into["switch_ms"] = (REALTIMEOFDAY - started) * 100
	into["native"] = SSrogue_light.native
	into["carrier_now"] = SSrogue_light.carrier_mode
	var/worker_before = rogue_bench_worker_ms()
	rogue_bench_reset()
	var/settle_started = REALTIMEOFDAY
	var/settled = rogue_bench_wait_settled()
	rogue_bench_sample(into, "rebuild", settle_started, worker_before, settled)

/proc/rogue_bench_control()
	var/list/objects = list()
	for(var/turf/lit as anything in SSrogue_light.static_turfs())
		var/atom/movable/lighting_object/object = lit.lighting_object
		if(istype(object))
			objects += object
		if(length(objects) >= 4000)
			break
	if(!length(objects))
		return 0
	var/started = TICK_USAGE_REAL
	for(var/index in 1 to length(objects))
		var/atom/movable/lighting_object/object = objects[index]
		var/serial = ++GLOB.rogue_bench_serial
		object.color = list(serial / 16777216, (serial % 4096) / 4096, 0.25, 0, 0.3, 0.5, 0.1, 0, 0.2, 0.6, 0.4, 0, 0.7, 0.4, 0.5, 0, 0, 0, 0, 1)
	var/spent = (TICK_USAGE_REAL - started) * world.tick_lag
	for(var/atom/movable/lighting_object/object as anything in objects)
		object.update()
	return round(spent * 1000 / length(objects), 0.1)

/proc/rogue_bench_profile_start()
	world.Profile(PROFILE_CLEAR)

/proc/rogue_bench_profile_save(list/run, label)
	rustg_file_write(world.Profile(PROFILE_REFRESH, format = "json"), "data/profile_[run["index"]]_[run["backend"]]_[run["carrier"]]_[label].json")

/proc/rogue_bench_sky(list/into, label, new_color)
	rogue_bench_wait_settled()
	into["[label]_control_us"] = rogue_bench_control()
	rogue_bench_wait_settled()
	var/worker_before = rogue_bench_worker_ms()
	rogue_bench_reset()
	rogue_bench_profile_start()
	var/started = REALTIMEOFDAY
	SSrockhill_daynight.update_emitters(new_color)
	var/action_ms = (REALTIMEOFDAY - started) * 100
	var/settled = rogue_bench_wait_settled()
	rogue_bench_sample(into, label, started, worker_before, settled)
	rogue_bench_profile_save(into, label)
	var/list/row = into[label]
	row["emitters_ms"] = action_ms

/proc/rogue_bench_spots()
	var/list/by_z = list()
	for(var/turf/open/lit in SSrogue_light.static_turfs())
		if(lit.density || !lit.lighting_object || istransparentturf(lit))
			continue
		var/key = "[lit.z]"
		if(!by_z[key])
			by_z[key] = list()
		var/list/level = by_z[key]
		level += lit
	var/list/best = list()
	for(var/key in by_z)
		var/list/level = by_z[key]
		if(length(level) > length(best))
			best = level
	return best

/proc/rogue_bench_flicker_sources()
	var/list/emitters = GLOB.rockhill_sun_emitters
	var/list/sources = list()
	for(var/datum/light_source/light)
		if(light.source_atom && !(light.source_atom in emitters) && light.light_power > 0)
			sources += light.source_atom
		if(length(sources) >= ROGUE_BENCH_FLICKERS)
			break
	return sources

/proc/rogue_bench_flicker(list/into, list/sources)
	rogue_bench_wait_settled()
	var/worker_before = rogue_bench_worker_ms()
	rogue_bench_reset()
	rogue_bench_profile_start()
	var/started = REALTIMEOFDAY
	var/list/powers = list()
	for(var/atom/source as anything in sources)
		powers += source.light_power
		source.set_light(l_power = source.light_power * 0.5)
	rogue_bench_wait_settled()
	for(var/index in 1 to length(sources))
		var/atom/source = sources[index]
		source.set_light(l_power = powers[index])
	var/settled = rogue_bench_wait_settled()
	rogue_bench_sample(into, "flicker", started, worker_before, settled)
	rogue_bench_profile_save(into, "flicker")
	var/list/row = into["flicker"]
	row["sources"] = length(sources)

/proc/rogue_bench_run()
	SSrockhill_daynight.can_fire = FALSE
	SSprofiler.can_fire = FALSE
	world.Profile(PROFILE_START)
	var/list/sources = rogue_bench_flicker_sources()
#ifdef REDTARD_LIGHT_BENCH_SHORT
	var/list/plan = list(
		list(ROGUE_LIGHT_BACKEND_NATIVE, ROGUE_LIGHT_CARRIER_TENT),
		list(ROGUE_LIGHT_BACKEND_NATIVE, ROGUE_LIGHT_CARRIER_TENT),
	)
#else
	var/list/plan = list(
		list(ROGUE_LIGHT_BACKEND_DM, ROGUE_LIGHT_CARRIER_OBJECT),
		list(ROGUE_LIGHT_BACKEND_NATIVE, ROGUE_LIGHT_CARRIER_OBJECT),
		list(ROGUE_LIGHT_BACKEND_NATIVE, ROGUE_LIGHT_CARRIER_TENT),
		list(ROGUE_LIGHT_BACKEND_DM, ROGUE_LIGHT_CARRIER_OBJECT),
		list(ROGUE_LIGHT_BACKEND_NATIVE, ROGUE_LIGHT_CARRIER_TENT),
	)
#endif
	GLOB.rogue_bench_results["flicker_sources"] = length(sources)
	GLOB.rogue_bench_results["tick_lag"] = world.tick_lag
	var/list/runs = list()
	GLOB.rogue_bench_results["runs"] = runs
	for(var/list/mode as anything in plan)
		var/list/run = list("index" = length(runs) + 1, "backend" = mode[1], "carrier" = mode[2])
		runs += list(run)
		log_world("LIGHT BENCH: [mode[1]] [mode[2]]")
		rogue_bench_switch(run, mode[1], mode[2])
		rogue_bench_sky(run, "sky_night", ROGUE_BENCH_SKY_B)
		rogue_bench_sky(run, "sky_day", ROGUE_BENCH_SKY_A)
		if(length(sources))
			rogue_bench_flicker(run, sources)
		log_world("LIGHT BENCH: [json_encode(run)]")
		run["tents"] = SSrogue_light.tent_count
		rustg_file_write(json_encode(GLOB.rogue_bench_results), ROGUE_BENCH_FILE)
	GLOB.rogue_bench_results["done"] = TRUE
	rustg_file_write(json_encode(GLOB.rogue_bench_results), ROGUE_BENCH_FILE)
	log_world("LIGHT BENCH: done")

#undef ROGUE_BENCH_FLICKERS
#undef ROGUE_BENCH_SKY_A
#undef ROGUE_BENCH_SKY_B
#undef ROGUE_BENCH_SETTLE_TIMEOUT
#undef ROGUE_BENCH_FILE

#endif
