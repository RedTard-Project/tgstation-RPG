/obj/structure/flora/newtree
	obj_flags = CAN_BE_HIT | BLOCK_Z_IN_UP | BLOCK_Z_OUT_DOWN
	var/tree_type = 1
	var/crown_state

/obj/structure/flora/newtree/Initialize(mapload)
	. = ..()
	tree_type = rand(1, 2)
	var/turf/here = get_turf(src)
	var/turf/above = GET_TURF_ABOVE(here)
	if(isopenspaceturf(above) && !(locate(/obj/structure/flora/newtree) in above))
		var/obj/structure/flora/newtree/upper = new(above)
		upper.crown_state = "center-leaf[rand(1, 2)]"
		upper.update_appearance()
	if(istype(here, /turf/open/floor/rogue/grass))
		here.ChangeTurf(/turf/open/floor/rogue/dirt)
	update_appearance()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/flora/newtree/LateInitialize()
	build_branches()
	build_leaves()

/obj/structure/flora/newtree/update_icon_state()
	icon_state = ""
	return ..()

/obj/structure/flora/newtree/update_overlays()
	. = ..()
	if(crown_state)
		. += mutable_appearance(icon, crown_state)
	var/mutable_appearance/trunk = mutable_appearance(icon, "tree[tree_type]")
	trunk.dir = dir
	. += trunk

/obj/structure/flora/newtree/proc/build_branches()
	var/lowest = !isopenspaceturf(loc)
	for(var/direction in GLOB.cardinals)
		var/turf/near = get_step(src, direction)
		if(!near || locate(/obj/structure) in near)
			continue
		if(!isopenspaceturf(near))
			if(lowest && isopenturf(near) && prob(70))
				var/obj/structure/flora/newbranch/leafless/stub = new(near)
				stub.setDir(direction)
			continue
		if(lowest)
			continue
		var/turf/far = get_step(near, direction)
		var/obj/structure/flora/newbranch/branch
		if(isopenspaceturf(far) && prob(50) && !(locate(/obj/structure) in far))
			if(prob(50))
				var/obj/structure/flora/newbranch/tip = new(far)
				tip.setDir(direction)
				branch = new /obj/structure/flora/newbranch/connector(near)
			else
				new /obj/structure/flora/newleaf(far)
				branch = new /obj/structure/flora/newbranch(near)
		else
			branch = new /obj/structure/flora/newbranch(near)
		branch.setDir(direction)

/obj/structure/flora/newtree/proc/build_leaves()
	for(var/direction in GLOB.diagonals)
		var/turf/near = get_step(src, direction)
		if(isopenspaceturf(near) && !(locate(/obj/structure) in near))
			var/obj/structure/flora/newleaf/corner/leaf = new(near)
			leaf.setDir(direction)

/obj/structure/flora/newtree/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(. || !isliving(user) || user.stat != STABLE || user.body_position == LYING_DOWN || user.incapacitated)
		return
	var/turf/user_turf = get_turf(user)
	var/turf/target = GET_TURF_ABOVE(user_turf)
	if(!isopenspaceturf(target))
		to_chat(user, span_warning("I can't climb here."))
		return TRUE
	user.visible_message(span_warning("[user] starts to climb [src]."), span_warning("I start to climb [src]..."))
	if(do_after(user, 3 SECONDS, src))
		user.zMove(target = target, z_move_flags = ZMOVE_CHECK_PULLEDBY | ZMOVE_ALLOW_BUCKLED | ZMOVE_INCLUDE_PULLED)
	return TRUE

/obj/structure/flora/newtree/atom_destruction(damage_flag)
	var/turf/here = get_turf(src)
	var/turf/above = GET_TURF_ABOVE(here)
	for(var/obj/structure/flora/newtree/upper in above)
		upper.atom_destruction(damage_flag)
	for(var/direction in GLOB.cardinals)
		var/turf/near = get_step(src, direction)
		for(var/obj/structure/flora/newbranch/branch in near)
			if(branch.dir != direction)
				continue
			var/turf/far = get_step(near, direction)
			for(var/obj/structure/flora/newbranch/tip in far)
				if(tip.dir == direction)
					qdel(tip)
			for(var/obj/structure/flora/newleaf/leaf in far)
				qdel(leaf)
			qdel(branch)
	for(var/turf/corner as anything in block(get_step(src, SOUTHWEST), get_step(src, NORTHEAST)))
		for(var/obj/structure/flora/newleaf/leaf in corner)
			qdel(leaf)
	if(!isopenspaceturf(here) && !(locate(/obj/structure/flora/roguetree/stump) in here))
		new /obj/structure/flora/roguetree/stump(here)
	// The log is Ratwood's static_debris, dropped by rockhill/destruction.dm.
	return ..()

/obj/structure/flora/newbranch
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN
	var/leafy = TRUE
	var/branch_state
	var/leaf_state
	var/leaf_dir

/obj/structure/flora/newbranch/Initialize(mapload)
	branch_state = "branch-end[rand(1, 2)]"
	if(leafy)
		leaf_state = "center-leaf[rand(1, 2)]"
		leaf_dir = pick(GLOB.cardinals)
	. = ..()
	update_appearance()

/obj/structure/flora/newbranch/update_icon_state()
	icon_state = ""
	return ..()

/obj/structure/flora/newbranch/update_overlays()
	. = ..()
	if(leaf_state)
		var/mutable_appearance/leaf = mutable_appearance(icon, leaf_state)
		leaf.dir = leaf_dir
		. += leaf
	var/mutable_appearance/branch = mutable_appearance(icon, branch_state)
	branch.dir = dir
	. += branch

/obj/structure/flora/newbranch/connector/Initialize(mapload)
	. = ..()
	branch_state = "branch-extend"
	update_appearance()

/obj/structure/flora/newbranch/leafless
	leafy = FALSE
