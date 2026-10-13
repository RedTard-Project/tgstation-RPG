/area/rogue/LateInitialize()
	. = ..()
	if(static_lighting)
		return
	for(var/list/zlevel_turfs as anything in get_zlevel_turf_lists())
		for(var/turf/sunlit as anything in zlevel_turfs)
			for(var/turf/neighbor as anything in RANGE_TURFS(1, sunlit))
				var/area/neighbor_area = neighbor.loc
				if(neighbor_area.static_lighting)
					sunlit.set_light(l_range = ROCKHILL_SUNLIGHT_RANGE, l_power = ROCKHILL_SUNLIGHT_POWER, l_color = ROCKHILL_SUNLIGHT_COLOR)
					break
