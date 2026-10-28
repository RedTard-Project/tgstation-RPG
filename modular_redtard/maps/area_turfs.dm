/**
 * Sets the turf lists of every area on these z-levels right in one pass, after many map templates were loaded on them.
 *
 * TG's map reader files every tile a template loads over an existing level as a turf its old area has to drop
 * (area.turfs_to_uncontain_by_zlevel), and SSarea_contents drops them one at a time from that area's turf list, a linear
 * search each. Hundreds of templates on one level (the Rockhill dungeon: 659) cost it about half of every tick for the first
 * ten minutes of the round. Code that loads many templates calls this once it is done, with the levels it loaded on: every
 * area's list is rebuilt from where its turfs really are and the queue is emptied.
 */
/proc/rogue_rebuild_area_turfs(list/zlevels)
	var/started = REALTIMEOFDAY
	for(var/zlevel in zlevels)
		var/list/turfs_of = list()
		for(var/turf/level_turf as anything in Z_TURFS(zlevel))
			var/area/turf_area = level_turf.loc
			var/list/area_turfs = turfs_of[turf_area]
			if(!area_turfs)
				area_turfs = list()
				turfs_of[turf_area] = area_turfs
			area_turfs += level_turf
		for(var/area/each_area as anything in GLOB.areas)
			if(length(each_area.turfs_to_uncontain_by_zlevel) >= zlevel)
				each_area.turfs_to_uncontain_by_zlevel[zlevel] = list()
			var/list/rebuilt = turfs_of[each_area]
			if(rebuilt || length(each_area.turfs_by_zlevel) >= zlevel)
				LISTASSERTLEN(each_area.turfs_by_zlevel, zlevel, list())
				each_area.turfs_by_zlevel[zlevel] = rebuilt || list()
		CHECK_TICK
	log_world("Rebuilt the area turf lists of [length(zlevels)] z-level\s in [round((REALTIMEOFDAY - started) / 10, 0.01)] s.")
