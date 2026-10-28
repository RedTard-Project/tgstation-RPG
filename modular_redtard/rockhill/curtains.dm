/// Ratwood's curtain (code/game/objects/structures/curtain.dm): a cloth that a click opens and closes, hiding what is behind it
/// while closed. TG has its own /obj/structure/curtain, so the port rebases Ratwood's under this one.
/obj/structure/rockhill/curtain
	name = "curtain"
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "curtain-open"
	plane = ABOVE_GAME_PLANE
	layer = ABOVE_MOB_LAYER
	obj_flags = CAN_BE_HIT
	/// The states are "[icon_type]-open" and "[icon_type]-closed".
	var/icon_type = "curtain"
	var/open = TRUE
	/// Moves only from the side it faces, the dir it was mapped or built with.
	var/directional = FALSE
	var/closedir

/// The map shows its side as an arrow ("curtaindir"); in game it is the plain cloth.
/obj/structure/rockhill/curtain/directional
	icon_state = "curtaindir"
	directional = TRUE

/obj/structure/rockhill/curtain/Initialize(mapload)
	. = ..()
	closedir = dir
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/rockhill/curtain/update_icon_state()
	. = ..()
	icon_state = "[icon_type]-[open ? "open" : "closed"]"

/obj/structure/rockhill/curtain/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(directional && get_dir(src, user) != closedir)
		to_chat(user, span_warning("These curtains can't be manipulated from this side."))
		return TRUE
	toggle()
	return TRUE

/obj/structure/rockhill/curtain/proc/toggle()
	open = !open
	set_opacity(!open)
	playsound(src, 'modular_redtard/rockhill/sound/foley/doors/curtain.ogg', 50, TRUE)
	update_appearance(UPDATE_ICON_STATE)

/// Ratwood's OnCrafted(): the crafter stands on the side it opens from.
/obj/structure/rockhill/curtain/on_craft_completion(list/components, datum/crafting_recipe/current_recipe, atom/crafter)
	. = ..()
	if(directional && crafter)
		closedir = get_dir(src, crafter) || turn(dir, 180)
