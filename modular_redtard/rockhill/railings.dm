/obj/structure/fluff/railing
	flags_1 = ON_BORDER_1
	var/pass_crawl = TRUE

/obj/structure/fluff/railing/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/climbable)
	if(!(dir in GLOB.diagonals))
		var/static/list/loc_connections = list(COMSIG_ATOM_EXIT = PROC_REF(on_exit))
		AddElement(/datum/element/connect_loc, loc_connections)
	switch(dir)
		if(NORTH)
			layer = BELOW_MOB_LAYER - 0.01
		if(EAST, WEST)
			layer = BELOW_MOB_LAYER
		if(SOUTH)
			layer = ABOVE_MOB_LAYER

/obj/structure/fluff/railing/proc/blocked_dirs()
	if(dir in GLOB.diagonals)
		return icon_state == "woodrailing" ? dir : NONE
	return dir

/obj/structure/fluff/railing/proc/lets_through(atom/movable/mover)
	if(isobserver(mover) || mover.throwing || isprojectile(mover) || (mover.movement_type & MOVETYPES_NOT_TOUCHING_GROUND))
		return TRUE
	var/mob/living/crawler = mover
	return pass_crawl && isliving(crawler) && crawler.body_position == LYING_DOWN

/obj/structure/fluff/railing/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if((border_dir & blocked_dirs()) && !lets_through(mover))
		return FALSE
	return TRUE

/obj/structure/fluff/railing/proc/on_exit(datum/source, atom/movable/leaving, direction)
	SIGNAL_HANDLER
	if(leaving == src || !(direction & dir) || lets_through(leaving))
		return
	leaving.Bump(src)
	return COMPONENT_ATOM_BLOCK_EXIT
