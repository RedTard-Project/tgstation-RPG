/datum/controller/subsystem/mapping/PreInit()
	..()
	if(!current_map?.defaulted)
		return
	var/datum/map_config/picked = pick_medieval_map()
	if(!picked)
		return
	var/datum/map_config/fresh = new
	if(!fresh.LoadConfig(picked.config_filename, TRUE))
		qdel(fresh)
		return
	current_map = fresh

/datum/controller/subsystem/mapping/proc/pick_medieval_map()
	var/list/candidates = list()
	for(var/map_name in config.maplist)
		var/datum/map_config/candidate = config.maplist[map_name]
		if(candidate.map_era == MAP_ERA_MEDIEVAL && candidate.votable)
			candidates += candidate
	if(!length(candidates))
		return null
	return pick(candidates)

/datum/job/map_check()
	. = ..()
	if(!.)
		return
	var/datum/map_config/active = SSmapping.current_map
	if(!active || map_era == JOB_ERA_ANY || map_era == active.map_era)
		return
	job_flags &= ~JOB_NEW_PLAYER_JOINABLE
	total_positions = 0
	spawn_positions = 0
