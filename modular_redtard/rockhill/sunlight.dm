GLOBAL_LIST_EMPTY(rockhill_sun_emitters)

/area/rogue/LateInitialize()
	. = ..()
	if(!rockhill_sunlit)
		return
	for(var/list/zlevel_turfs as anything in get_zlevel_turf_lists())
		for(var/turf/sunlit as anything in zlevel_turfs)
			for(var/turf/neighbor as anything in RANGE_TURFS(1, sunlit))
				var/area/rogue/neighbor_area = neighbor.loc
				if(istype(neighbor_area) && !neighbor_area.rockhill_sunlit)
					GLOB.rockhill_sun_emitters += sunlit
					sunlit.rogue_light_channel = ROGUE_LIGHT_CHANNEL_SUN
					rockhill_light_emitter(sunlit, GLOB.starlight_color)
					break

/proc/rockhill_light_emitter(turf/emitter, sky_color)
	if(SSrogue_light.splits_sun())
		emitter.set_light(l_range = ROCKHILL_SUNLIGHT_RANGE, l_power = ROCKHILL_SUNLIGHT_POWER, l_color = COLOR_WHITE, l_on = TRUE)
		return
	emitter.set_light(l_range = ROCKHILL_SUNLIGHT_RANGE, l_power = ROCKHILL_SUNLIGHT_POWER, l_color = sky_color, l_on = sky_color != COLOR_BLACK)
