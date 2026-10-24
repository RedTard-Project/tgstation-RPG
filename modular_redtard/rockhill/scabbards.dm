/obj/item/rogueweapon
	var/sheathe_icon

/obj/item/rogueweapon/scabbard
	var/obj/item/rogueweapon/valid_blade
	var/list/valid_blades
	var/list/invalid_blades
	var/obj/item/sheathed

/obj/item/rogueweapon/scabbard/Destroy()
	sheathed?.forceMove(drop_location())
	sheathed = null
	return ..()

/obj/item/rogueweapon/scabbard/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone != sheathed)
		return
	sheathed = null
	refresh_look()

/obj/item/rogueweapon/scabbard/examine(mob/user)
	. = ..()
	if(sheathed)
		. += span_notice("[sheathed] is sheathed in it. Click it with an empty hand to draw.")

/obj/item/rogueweapon/scabbard/update_icon_state()
	icon_state = initial(icon_state)
	var/obj/item/rogueweapon/blade = sheathed
	if(istype(blade) && blade.sheathe_icon && icon_exists(icon, "[initial(icon_state)]_[blade.sheathe_icon]"))
		icon_state = "[initial(icon_state)]_[blade.sheathe_icon]"
	return ..()

/obj/item/rogueweapon/scabbard/proc/blade_fits(mob/user, obj/item/blade)
	if(sheathed)
		to_chat(user, span_warning("The sheath is occupied!"))
		return FALSE
	if(HAS_TRAIT(blade, TRAIT_NODROP))
		to_chat(user, span_warning("I cannot sheath [blade] while it is bound."))
		return FALSE
	if((valid_blade && !istype(blade, valid_blade)) || (valid_blades && !(blade.type in valid_blades)) || (invalid_blades && (blade.type in invalid_blades)))
		to_chat(user, span_warning("[blade] won't fit in there."))
		return FALSE
	return TRUE

/obj/item/rogueweapon/scabbard/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/rogueweapon) || istype(tool, /obj/item/rogueweapon/scabbard))
		return ..()
	if(!blade_fits(user, tool) || !user.transferItemToLoc(tool, src))
		return ITEM_INTERACT_BLOCKING
	sheathed = tool
	playsound(src, 'modular_redtard/rockhill/sound/items/scabbard_holster.ogg', 100, TRUE)
	user.visible_message(span_notice("[user] sheathes [tool] into [src]."), span_notice("I sheathe [tool] into [src]."))
	refresh_look()
	return ITEM_INTERACT_SUCCESS

/obj/item/rogueweapon/scabbard/attack_hand(mob/user, list/modifiers)
	if(!sheathed)
		return ..()
	var/obj/item/blade = sheathed
	if(!user.put_in_hands(blade))
		to_chat(user, span_warning("My hands are full."))
		return TRUE
	playsound(src, 'modular_redtard/rockhill/sound/items/scabbard_holster.ogg', 100, TRUE)
	user.visible_message(span_warning("[user] draws [blade] out of [src]!"), span_notice("I draw [blade] out of [src]."))
	return TRUE

/obj/item/rogueweapon/scabbard/proc/refresh_look()
	update_appearance(UPDATE_ICON_STATE)
	update_slot_icon()
	if(ismob(loc))
		var/mob/holder = loc
		holder.update_held_items()
