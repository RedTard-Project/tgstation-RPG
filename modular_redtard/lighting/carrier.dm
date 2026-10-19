/atom/movable/rogue_light_tent
	name = ""
	anchored = TRUE
	icon = 'modular_redtard/icons/effects/rogue_light_tent.dmi'
	icon_state = "tent"
	plane = LIGHTING_PLANE
	blend_mode = BLEND_ADD
	appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = INVISIBILITY_LIGHTING
	move_resist = INFINITY
	var/tent_id = 0

/atom/movable/rogue_light_tent/Initialize(mapload, tent_id, plane_offset)
	. = ..()
	src.tent_id = tent_id
	var/index = tent_id - 1
	var/red = index % ROGUE_LIGHT_TENT_LEVELS
	var/green = round(index / ROGUE_LIGHT_TENT_LEVELS) % ROGUE_LIGHT_TENT_LEVELS
	var/blue = round(index / (ROGUE_LIGHT_TENT_LEVELS * ROGUE_LIGHT_TENT_LEVELS))
	var/scale = 255 / (ROGUE_LIGHT_TENT_LEVELS - 1)
	color = rgb(round(red * scale), round(green * scale), round(blue * scale))
	if(plane_offset)
		plane = LIGHTING_PLANE - (PLANE_RANGE * plane_offset)

/atom/movable/rogue_light_tent/Destroy(force)
	if(!force)
		return QDEL_HINT_LETMELIVE
	return ..()

/atom/movable/rogue_light_tent/forceMove(atom/destination, no_tp = FALSE, harderforce = FALSE)
	if(harderforce)
		return ..()

/atom/movable/rogue_light_tent/ex_act(severity)
	return FALSE

/atom/movable/rogue_light_tent/singularity_act()
	return

/atom/movable/rogue_light_tent/singularity_pull()
	return

/atom/movable/rogue_light_tent/wash(clean_types)
	SHOULD_CALL_PARENT(FALSE)
	return

/atom/movable/rogue_light_tent/quarter
	icon = 'modular_redtard/icons/effects/rogue_light_quarter.dmi'
	icon_state = "ne"

/atom/movable/rogue_light_tent/quarter/Initialize(mapload, tent_id, plane_offset, corner)
	. = ..()
	icon_state = GLOB.rogue_light_quarter_states[corner]

/datum/rogue_light_sentinel
	var/turf/affected_turf
	var/needs_update = FALSE
	var/rogue_lum = 0
	var/appearance

/datum/rogue_light_sentinel/Destroy(force)
	return QDEL_HINT_LETMELIVE

/datum/rogue_light_sentinel/proc/update()
	return

/datum/rogue_light_sentinel/proc/rogue_show_record(list/batch, index)
	return

/datum/rogue_light_sentinel/proc/rogue_show_dark()
	return

/datum/rogue_light_cell
	var/turf/affected_turf
	var/needs_update = FALSE
	var/mutable_appearance/underlay
	var/underlay_shown = FALSE
	var/rogue_lum = 0
	var/appearance

/datum/rogue_light_cell/New(turf/lit)
	affected_turf = lit
	appearance = SSrogue_light.dark_appearance
	if(lit.lighting_object)
		qdel(lit.lighting_object, force = TRUE)
	lit.lighting_object = src
	lit.luminosity = 1
	if(SSrogue_light.native)
		if(SSlighting.initialized)
			SSrogue_light.turf_changed(lit)
		return
	needs_update = TRUE
	SSlighting.objects_queue += src

/datum/rogue_light_cell/Destroy(force)
	if(!force && !isnull(affected_turf))
		return QDEL_HINT_LETMELIVE
	SSlighting.objects_queue -= src
	var/turf/lit = affected_turf
	if(lit)
		rogue_show_dark()
		if(lit.lighting_object == src)
			lit.lighting_object = null
		lit.luminosity = 1
		if(SSrogue_light.native)
			SSrogue_light.turf_changed(lit)
	affected_turf = null
	underlay = null
	return ..()

/datum/rogue_light_cell/proc/update()
	var/turf/lit = affected_turf
	if(!lit)
		return
	if(SSrogue_light.native)
		reapply()
		return
	var/static/datum/lighting_corner/dummy/dummy_corner = new
	var/datum/lighting_corner/red = lit.lighting_corner_SW || dummy_corner
	var/datum/lighting_corner/green = lit.lighting_corner_SE || dummy_corner
	var/datum/lighting_corner/blue = lit.lighting_corner_NW || dummy_corner
	var/datum/lighting_corner/alpha = lit.lighting_corner_NE || dummy_corner
	if(max(red.largest_color_luminosity, green.largest_color_luminosity, blue.largest_color_luminosity, alpha.largest_color_luminosity) <= ROGUE_LIGHT_LUM_EPSILON)
		rogue_show_dark()
		return
	show_underlay(ROGUE_LIGHT_CORNERS_MATRIX(red, green, blue, alpha), ROGUE_LIGHT_CORNERS_LUM(red, green, blue, alpha))

/datum/rogue_light_cell/proc/reapply()
	if(!underlay_shown)
		return
	var/turf/lit = affected_turf
	lit.underlays -= underlay
	lit.underlays += underlay

/datum/rogue_light_cell/proc/rogue_show_record(list/batch, index)
	if(batch[index + 4] == ROGUE_LIGHT_DARK)
		rogue_show_dark()
		return
	var/values_at = index + 5
	show_underlay(ROGUE_LIGHT_RECORD_MATRIX(batch, values_at), ROGUE_LIGHT_RECORD_LUM(batch, values_at))

/datum/rogue_light_cell/proc/rogue_show_dark()
	rogue_lum = 0
	appearance = SSrogue_light.dark_appearance
	if(underlay_shown)
		affected_turf.underlays -= underlay
		underlay_shown = FALSE

/datum/rogue_light_cell/proc/show_underlay(list/color_matrix, lum)
	var/turf/lit = affected_turf
	if(underlay_shown)
		lit.underlays -= underlay
	else if(!underlay)
		underlay = new(SSrogue_light.light_template(lit.z))
	underlay.color = color_matrix
	lit.underlays += underlay
	underlay_shown = TRUE
	appearance = underlay
	rogue_lum = lum

/datum/rogue_light_cell/ref_search_details()
	return "[text_ref(src)] (turf: [affected_turf ? "[affected_turf.type] @ [AREACOORD(affected_turf)]" : "null"])"
