/obj/structure/rockhill/stairs
	name = "stairs"
	icon = 'modular_redtard/rockhill/icons/obj/stairs.dmi'
	icon_state = "stairs"
	move_resist = INFINITY
	plane = FLOOR_PLANE
	layer = ABOVE_OPEN_TURF_LAYER

/obj/structure/rockhill/stairs/Initialize(mapload)
	. = ..()
	var/static/list/loc_connections = list(COMSIG_ATOM_EXIT = PROC_REF(on_exit))
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/rockhill/stairs/proc/on_exit(datum/source, atom/movable/leaving, direction)
	SIGNAL_HANDLER
	if(isobserver(leaving) || leaving.throwing)
		return
	var/turf/target = get_target_loc(direction)
	if(!target)
		return
	INVOKE_ASYNC(leaving, TYPE_PROC_REF(/atom/movable, zMove), null, target, ZMOVE_STAIRS_FLAGS|ZMOVE_INCLUDE_PULLED)
	leaving.Bump(src)
	return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/rockhill/stairs/proc/get_target_loc(direction)
	var/turf/here = get_turf(src)
	var/turf/level
	if(direction == dir)
		level = GET_TURF_ABOVE(here)
	else if(direction == REVERSE_DIR(dir))
		level = GET_TURF_BELOW(here)
	if(!level)
		return null
	var/turf/target = get_step(level, direction)
	for(var/obj/structure/rockhill/stairs/partner in target)
		if(partner.dir == dir)
			return target
	return null
