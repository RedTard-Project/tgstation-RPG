#ifdef REDTARD_LIGHT_BENCH_CLIENT

#define ROGUE_CLIENT_BENCH_TOUR 25
#define ROGUE_CLIENT_BENCH_HOLD (20 SECONDS)
#define ROGUE_CLIENT_BENCH_FPS 30

GLOBAL_LIST_EMPTY(rogue_client_bench_marks)

/datum/controller/subsystem/rogue_light/Initialize()
	Master.sleep_offline_after_initializations = FALSE
	. = ..()
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(rogue_client_bench_launch)), 20 SECONDS)

/proc/rogue_client_bench_launch()
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(rogue_client_bench_run))

/proc/rogue_client_bench_mark(label)
	GLOB.rogue_client_bench_marks += list(list("label" = label, "seconds" = REALTIMEOFDAY / 10))
	rustg_file_write(json_encode(GLOB.rogue_client_bench_marks), "data/light_bench_client.json")
	log_world("CLIENT BENCH: [label]")

/proc/rogue_client_bench_lit_spot(list/spots)
	var/turf/best
	var/best_lit = -1
	for(var/index in 1 to min(length(spots), 400))
		var/turf/spot = spots[(index * 7919) % length(spots) + 1]
		var/lit = 0
		for(var/turf/around as anything in RANGE_TURFS(7, spot))
			if(around.lighting_object && around.get_static_lumcount() > 0.05)
				lit++
		if(lit > best_lit)
			best_lit = lit
			best = spot
	return best

/proc/rogue_client_bench_run()
	SSrockhill_daynight.can_fire = FALSE
	rogue_client_bench_mark("waiting")
	UNTIL(length(GLOB.clients))
	var/client/viewer = GLOB.clients[1]
	var/list/spots = rogue_bench_spots()
	var/turf/home = rogue_client_bench_lit_spot(spots)
	var/mob/living/carbon/human/body = new(home)
	ADD_TRAIT(body, TRAIT_GODMODE, "light_bench")
	body.key = viewer.key
	sleep(5 SECONDS)
	viewer = body.client
	viewer?.fps = ROGUE_CLIENT_BENCH_FPS
	sleep(30 SECONDS)
	var/list/plan = list(ROGUE_LIGHT_CARRIER_OBJECT, ROGUE_LIGHT_CARRIER_TENT, ROGUE_LIGHT_CARRIER_OBJECT, ROGUE_LIGHT_CARRIER_TENT)
	if(!SSrogue_light.native)
		SSrogue_light.set_backend(ROGUE_LIGHT_BACKEND_NATIVE)
	for(var/carrier in plan)
		body.forceMove(home)
		SSrogue_light.set_carrier_mode(carrier)
		rogue_bench_wait_settled()
		sleep(5 SECONDS)
		rogue_client_bench_mark("[carrier] fresh start")
		sleep(ROGUE_CLIENT_BENCH_HOLD)
		rogue_client_bench_mark("[carrier] fresh end")
		for(var/index in 1 to ROGUE_CLIENT_BENCH_TOUR)
			body.forceMove(spots[(index * 104729) % length(spots) + 1])
			sleep(1 SECONDS)
		body.forceMove(home)
		sleep(5 SECONDS)
		rogue_client_bench_mark("[carrier] toured start")
		sleep(ROGUE_CLIENT_BENCH_HOLD)
		rogue_client_bench_mark("[carrier] toured end")
		rogue_client_bench_mark("[carrier] walking start")
		var/walk_started = REALTIMEOFDAY
		var/step_dir = EAST
		while(REALTIMEOFDAY - walk_started < ROGUE_CLIENT_BENCH_HOLD)
			if(!step(body, step_dir))
				step_dir = turn(step_dir, 90)
			else
				step_dir = turn(step_dir, 180)
			sleep(4)
		rogue_client_bench_mark("[carrier] walking end")
	rogue_client_bench_mark("done")

#undef ROGUE_CLIENT_BENCH_TOUR
#undef ROGUE_CLIENT_BENCH_HOLD
#undef ROGUE_CLIENT_BENCH_FPS

#endif
