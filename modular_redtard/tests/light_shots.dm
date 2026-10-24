#ifdef REDTARD_LIGHT_SHOTS

#define ROGUE_SHOTS_FILE "data/light_shots.json"
#define ROGUE_SHOTS_HOLD (8 SECONDS)
#define ROGUE_SHOTS_NIGHT "#33406b"

GLOBAL_LIST_EMPTY(rogue_shots_marks)

/datum/controller/subsystem/rogue_light/Initialize()
	Master.sleep_offline_after_initializations = FALSE
	. = ..()
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(rogue_shots_launch)), 20 SECONDS)

/proc/rogue_shots_launch()
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(rogue_shots_run))

/proc/rogue_shots_mark(label, list/extra)
	var/list/mark = list("label" = label, "seconds" = REALTIMEOFDAY / 10)
	if(extra)
		mark += extra
	GLOB.rogue_shots_marks += list(mark)
	rustg_file_write(json_encode(GLOB.rogue_shots_marks), ROGUE_SHOTS_FILE)
	log_world("LIGHT SHOTS: [label]")

/proc/rogue_shots_lum_around(turf/center, radius)
	var/lit = 0
	for(var/turf/around as anything in RANGE_TURFS(radius, center))
		if(around.lighting_object && around.get_static_lumcount() > 0.05)
			lit++
	return lit

/proc/rogue_shots_pick(list/spots, list/chosen)
	var/list/emitters = GLOB.rockhill_sun_emitters
	var/turf/lit_spot
	var/best = -1
	for(var/index in 1 to min(length(spots), 300))
		var/turf/spot = spots[(index * 7919) % length(spots) + 1]
		var/area/spot_area = spot.loc
		if(!spot_area.static_lighting)
			continue
		var/lit = rogue_shots_lum_around(spot, 7)
		if(lit > best)
			best = lit
			lit_spot = spot
	if(lit_spot)
		chosen["lit"] = lit_spot
	for(var/datum/light_source/light)
		var/atom/source = light.source_atom
		if(!source || (source in emitters) || light.light_power <= 0 || light.light_range < 3)
			continue
		var/turf/source_turf = get_turf(source)
		var/area/source_area = source_turf?.loc
		if(!source_area?.static_lighting || rogue_shots_lum_around(source_turf, 7) > 60)
			continue
		chosen["falloff"] = source_turf
		break
	for(var/turf/hole as anything in SSrogue_light.static_turfs())
		if(!istransparentturf(hole))
			continue
		var/turf/below = GET_TURF_BELOW(hole)
		if(!below || below.get_static_lumcount() < 0.2)
			continue
		var/turf/stand_on
		for(var/turf/around as anything in RANGE_TURFS(2, hole))
			if(!istransparentturf(around) && !around.density && isopenturf(around))
				stand_on = around
				break
		if(stand_on)
			chosen["openspace"] = stand_on
			break
	for(var/turf/edge as anything in SSrogue_light.static_turfs())
		if(edge.x > 3 && edge.y > 3)
			continue
		if(edge.density || edge.get_static_lumcount() < 0.1)
			continue
		chosen["map_edge"] = locate(min(edge.x + 6, world.maxx), min(edge.y + 6, world.maxy), edge.z)
		break

/proc/rogue_shots_run()
	SSrockhill_daynight.can_fire = FALSE
	SSrockhill_weather.can_fire = FALSE
	rogue_shots_mark("waiting")
	UNTIL(length(GLOB.clients))
	var/client/viewer = GLOB.clients[1]
	var/list/chosen = list()
	rogue_shots_pick(rogue_bench_spots(), chosen)
	var/turf/first = chosen[chosen[1]]
	var/mob/living/carbon/human/body = new(first)
	ADD_TRAIT(body, TRAIT_GODMODE, "light_shots")
	body.key = viewer.key
	if(!SSrogue_light.native)
		SSrogue_light.set_backend(ROGUE_LIGHT_BACKEND_NATIVE)
	SSrockhill_daynight.update_emitters(ROGUE_SHOTS_NIGHT)
	rogue_bench_wait_settled()
	sleep(10 SECONDS)
	for(var/name in chosen)
		var/turf/spot = chosen[name]
		body.forceMove(spot)
		body.setDir(NORTH)
		for(var/carrier in list(ROGUE_LIGHT_CARRIER_OBJECT, ROGUE_LIGHT_CARRIER_TENT, ROGUE_LIGHT_CARRIER_QUARTER))
			SSrogue_light.set_carrier_mode(carrier)
			rogue_bench_wait_settled()
			sleep(3 SECONDS)
			rogue_shots_mark("[name] [carrier] start", list("x" = spot.x, "y" = spot.y, "z" = spot.z))
			sleep(ROGUE_SHOTS_HOLD)
			rogue_shots_mark("[name] [carrier] end")
	rogue_shots_mark("done")

#undef ROGUE_SHOTS_FILE
#undef ROGUE_SHOTS_HOLD
#undef ROGUE_SHOTS_NIGHT

#endif
