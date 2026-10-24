/obj/structure/fluff/statue/Initialize(mapload)
	. = ..()
	var/static/list/loc_connections = list(COMSIG_ATOM_EXIT = PROC_REF(on_exit))
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/fluff/statue/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(border_dir == dir)
		return FALSE

/obj/structure/fluff/statue/proc/on_exit(datum/source, atom/movable/leaving, direction)
	SIGNAL_HANDLER
	if(leaving == src || direction != dir)
		return
	leaving.Bump(src)
	return COMPONENT_ATOM_BLOCK_EXIT
