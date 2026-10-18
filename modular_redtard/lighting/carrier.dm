/atom/movable/rogue_light_carrier
	name = ""
	anchored = TRUE
	icon = LIGHTING_ICON
	plane = LIGHTING_PLANE
	appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = INVISIBILITY_LIGHTING
	move_resist = INFINITY
	var/look
	var/z_level
	var/users = 0
	var/idle_since = 0
	var/lum = 0

/atom/movable/rogue_light_carrier/Initialize(mapload, look, z_level, list/color_matrix, lum)
	. = ..()
	verbs.Cut()
	src.look = look
	src.z_level = z_level
	src.lum = lum
	layer = z_level * 0.01
	if(SSmapping.max_plane_offset)
		plane = LIGHTING_PLANE - (PLANE_RANGE * GET_Z_PLANE_OFFSET(z_level))
	color = color_matrix

/atom/movable/rogue_light_carrier/Destroy(force)
	SSrogue_light.forget_carrier(src)
	return ..()

/atom/movable/rogue_light_carrier/proc/acquire()
	if(users++ <= 0)
		SSrogue_light.idle_carriers -= src

/atom/movable/rogue_light_carrier/proc/release()
	if(--users > 0)
		return
	users = 0
	idle_since = world.time
	SSrogue_light.idle_carriers[src] = TRUE

/atom/movable/rogue_light_carrier/forceMove(atom/destination, no_tp = FALSE, harderforce = FALSE)
	if(harderforce)
		return ..()

/atom/movable/rogue_light_carrier/ex_act(severity)
	return FALSE

/atom/movable/rogue_light_carrier/singularity_act()
	return

/atom/movable/rogue_light_carrier/singularity_pull()
	return

/atom/movable/rogue_light_carrier/wash(clean_types)
	SHOULD_CALL_PARENT(FALSE)
	return

/datum/rogue_light_cell
	var/turf/affected_turf
	var/needs_update = FALSE
	var/atom/movable/rogue_light_carrier/carrier
	var/look = ROGUE_LIGHT_DARK
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
		set_carrier(null)
		if(lit.lighting_object == src)
			lit.lighting_object = null
		lit.luminosity = 1
		if(SSrogue_light.native)
			SSrogue_light.turf_changed(lit)
	affected_turf = null
	return ..()

/datum/rogue_light_cell/proc/update()
	var/turf/lit = affected_turf
	if(!lit)
		return
	if(SSrogue_light.native)
		set_carrier(SSrogue_light.carrier_for_look(lit.z, look))
		return
	var/static/datum/lighting_corner/dummy/dummy_corner = new
	var/datum/lighting_corner/red = lit.lighting_corner_SW || dummy_corner
	var/datum/lighting_corner/green = lit.lighting_corner_SE || dummy_corner
	var/datum/lighting_corner/blue = lit.lighting_corner_NW || dummy_corner
	var/datum/lighting_corner/alpha = lit.lighting_corner_NE || dummy_corner
	if(max(red.largest_color_luminosity, green.largest_color_luminosity, blue.largest_color_luminosity, alpha.largest_color_luminosity) <= ROGUE_LIGHT_LUM_EPSILON)
		set_carrier(null)
		return
	set_carrier(SSrogue_light.carrier_for_corners(lit.z, red, green, blue, alpha))

/datum/rogue_light_cell/proc/rogue_show_look(new_look)
	look = new_look
	set_carrier(SSrogue_light.carrier_for_look(affected_turf.z, new_look))

/datum/rogue_light_cell/proc/set_carrier(atom/movable/rogue_light_carrier/new_carrier)
	var/turf/lit = affected_turf
	var/atom/movable/rogue_light_carrier/old_carrier = carrier
	if(old_carrier == new_carrier)
		if(new_carrier)
			SSrogue_light.reattach(lit, new_carrier)
		return
	if(old_carrier)
		SSrogue_light.detach(lit, old_carrier)
		old_carrier.release()
	carrier = new_carrier
	if(!new_carrier)
		appearance = SSrogue_light.dark_appearance
		rogue_lum = 0
		return
	new_carrier.acquire()
	SSrogue_light.attach(lit, new_carrier)
	appearance = new_carrier.appearance
	rogue_lum = new_carrier.lum

/datum/rogue_light_cell/ref_search_details()
	return "[text_ref(src)] (turf: [affected_turf ? "[affected_turf.type] @ [AREACOORD(affected_turf)]" : "null"] carrier: [carrier ? text_ref(carrier) : "none"])"
