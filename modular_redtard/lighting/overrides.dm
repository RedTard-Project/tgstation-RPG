/datum/controller/subsystem/lighting/Initialize()
	SSrogue_light.configure()
	return ..()

/datum/controller/subsystem/lighting/create_all_lighting_objects()
	var/tents = SSrogue_light.uses_tents()
	if(!tents && !SSrogue_light.uses_cells())
		return ..()
	for(var/area/lit_area as anything in GLOB.areas)
		if(!lit_area.static_lighting)
			continue
		for(var/list/zlevel_turfs as anything in lit_area.get_zlevel_turf_lists())
			for(var/turf/area_turf as anything in zlevel_turfs)
				if(area_turf.space_lit)
					continue
				if(tents)
					rogue_light_attach_sentinel(area_turf)
					continue
				var/datum/rogue_light_cell/existing = area_turf.lighting_object
				if(!QDELETED(existing) && istype(existing) && existing.affected_turf == area_turf)
					continue
				new /datum/rogue_light_cell(area_turf)
			CHECK_TICK
		CHECK_TICK

/proc/rogue_light_attach_sentinel(turf/lit)
	var/datum/existing = lit.lighting_object
	if(existing == GLOB.rogue_light_sentinel)
		return
	if(existing)
		qdel(existing, force = TRUE)
	lit.lighting_object = GLOB.rogue_light_sentinel
	lit.luminosity = 1

/turf/lighting_build_overlay()
	if(SSrogue_light.uses_tents())
		rogue_light_attach_sentinel(src)
		if(SSlighting.initialized)
			SSrogue_light.turf_changed(src)
		return
	if(!SSrogue_light.uses_cells())
		return ..()
	if(lighting_object)
		qdel(lighting_object, force = TRUE)
	new /datum/rogue_light_cell(src)

/turf/lighting_clear_overlay()
	if(lighting_object != GLOB.rogue_light_sentinel)
		return ..()
	lighting_object = null
	luminosity = 1
	SSrogue_light.turf_changed(src)

/turf/reconsider_lights()
	if(!SSrogue_light.native)
		return ..()
	SSrogue_light.turf_changed(src)

/turf/recalculate_directional_opacity()
	. = ..()
	if(SSrogue_light.native && SSlighting.initialized)
		SSrogue_light.turf_changed(src, SSrogue_light.uses_tents())

/turf/get_static_lumcount(minlum = 0, maxlum = 1)
	if(!SSrogue_light.native)
		return ..()
	return (SSrogue_light.turf_lum(src) - minlum) / (maxlum - minlum)

/atom/movable/lighting_object
	var/rogue_look = ROGUE_LIGHT_DARK
	var/rogue_lum = 0

/atom/movable/lighting_object/Initialize(mapload)
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return
	var/tents = SSrogue_light.uses_tents()
	if(tents || SSrogue_light.uses_cells())
		var/turf/lit = affected_turf
		SSlighting.objects_queue -= src
		needs_update = FALSE
		lit.lighting_object = null
		affected_turf = null
		if(tents)
			rogue_light_attach_sentinel(lit)
			if(SSlighting.initialized)
				SSrogue_light.turf_changed(lit)
		else
			new /datum/rogue_light_cell(lit)
		return INITIALIZE_HINT_QDEL
	if(SSrogue_light.native && SSlighting.initialized)
		SSrogue_light.turf_changed(affected_turf)

/atom/movable/lighting_object/Destroy(force)
	var/turf/lit = affected_turf
	. = ..()
	if(. != QDEL_HINT_LETMELIVE && lit && SSrogue_light.native)
		SSrogue_light.turf_changed(lit)

/atom/movable/lighting_object/update()
	if(!SSrogue_light.native)
		return ..()
	if(!rogue_look)
		rogue_show_dark()

/atom/movable/lighting_object/proc/rogue_show_record(list/batch, index)
	var/new_look = batch[index + 4]
	if(new_look == ROGUE_LIGHT_DARK)
		rogue_show_dark()
		return
	var/values_at = index + 5
	rogue_look = new_look
	rogue_lum = ROGUE_LIGHT_RECORD_LUM(batch, values_at)
	icon_state = null
	color = ROGUE_LIGHT_RECORD_MATRIX(batch, values_at)
	luminosity = TRUE

/atom/movable/lighting_object/proc/rogue_show_dark()
	rogue_look = ROGUE_LIGHT_DARK
	rogue_lum = 0
	icon_state = "lighting_dark"
	color = null
	luminosity = FALSE

/datum/light_source
	var/rogue_light_id = 0

/datum/light_source/update_corners()
	if(!SSrogue_light.native)
		return ..()
	if(!refresh_values())
		return
	SSrogue_light.light_set(src)
	applied_lum_r = lum_r
	applied_lum_g = lum_g
	applied_lum_b = lum_b

/datum/light_source/remove_lum()
	if(!SSrogue_light.native)
		return ..()
	applied = FALSE
	effect_str = null
	SSrogue_light.light_remove(src)

/datum/light_source/recalc_corner(datum/lighting_corner/corner)
	if(!SSrogue_light.native)
		return ..()
