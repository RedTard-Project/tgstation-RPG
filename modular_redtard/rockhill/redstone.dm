GLOBAL_LIST_EMPTY(rockhill_redstone)

/obj/structure/rockhill
	var/redstone_id

/obj/structure/rockhill/proc/register_redstone()
	if(redstone_id)
		LAZYADDASSOCLIST(GLOB.rockhill_redstone, redstone_id, src)

/obj/structure/rockhill/proc/unregister_redstone()
	if(redstone_id)
		LAZYREMOVEASSOC(GLOB.rockhill_redstone, redstone_id, src)

/obj/structure/rockhill/proc/send_redstone(mob/user)
	if(!redstone_id)
		return
	for(var/obj/structure/rockhill/linked as anything in GLOB.rockhill_redstone[redstone_id])
		if(linked != src)
			INVOKE_ASYNC(linked, PROC_REF(redstone_triggered), user)

/obj/structure/rockhill/proc/redstone_triggered(mob/user)
	return

/obj/structure/lever
	var/toggled = FALSE

/obj/structure/lever/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(. || !isliving(user))
		return
	user.changeNext_move(CLICK_CD_MELEE)
	user.visible_message(span_warning("[user] pulls [src]."))
	user.log_message("pulled the lever with redstone id \"[redstone_id]\"", LOG_GAME)
	if(ROCKHILL_LEVER_TIME > 0 && !do_after(user, ROCKHILL_LEVER_TIME, target = user))
		return TRUE
	toggled = !toggled
	icon_state = "[copytext(icon_state, 1, -1)][toggled]"
	playsound(src, 'modular_redtard/rockhill/sound/foley/lever.ogg', 100, extrarange = 3)
	send_redstone(user)
	return TRUE

/obj/structure/bars/passage/redstone_triggered(mob/user)
	set_density(!density)
	icon_state = "[copytext(icon_state, 1, -1)][density ? 0 : 1]"

/obj/structure/bars/passage/shutter/redstone_triggered(mob/user)
	. = ..()
	set_opacity(density)

/obj/structure/bars/passage/shutter/hidden/redstone_triggered(mob/user)
	. = ..()
	alpha = density ? 255 : 60

/obj/structure/floordoor
	var/togg = FALSE
	var/base_state = "floorhatch"

/obj/structure/floordoor/redstone_triggered(mob/user)
	set_hatch(!togg)

/obj/structure/floordoor/proc/set_hatch(opened)
	togg = opened
	icon_state = "[base_state][opened ? 0 : 1]"
	if(!opened)
		obj_flags |= BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP
		return
	obj_flags &= ~(BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP)
	var/turf/open/openspace/hole = loc
	if(!istype(hole))
		return
	for(var/atom/movable/thing in hole)
		hole.zfall_if_on_turf(thing)

/obj/structure/floordoor/gatehatch
	var/changing_state = FALSE
	var/delay2open = 0
	var/delay2close = 0

/obj/structure/floordoor/gatehatch/redstone_triggered(mob/user)
	if(changing_state)
		return
	changing_state = TRUE
	addtimer(CALLBACK(src, PROC_REF(set_hatch), !togg), togg ? delay2close : delay2open)
	addtimer(VARSET_CALLBACK(src, changing_state, FALSE), ROCKHILL_HATCH_CYCLE)

/obj/structure/kybraxor
	var/openn = FALSE
	var/changing_state = FALSE

/obj/structure/kybraxor/redstone_triggered(mob/user)
	if(changing_state)
		return
	changing_state = TRUE
	openn = !openn
	playsound(src, openn ? 'modular_redtard/rockhill/sound/misc/kybraxorop.ogg' : 'modular_redtard/rockhill/sound/misc/kybraxor.ogg', 100, FALSE)
	flick(openn ? "kybraxoropening" : "kybraxorclosing", src)
	addtimer(CALLBACK(src, PROC_REF(finish_turn)), ROCKHILL_HATCH_CYCLE)

/obj/structure/kybraxor/proc/finish_turn()
	icon_state = openn ? "kybraxor0" : "kybraxor1"
	changing_state = FALSE
