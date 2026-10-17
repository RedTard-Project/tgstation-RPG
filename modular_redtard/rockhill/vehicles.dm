/obj/vehicle/ridden/rockhill
	can_buckle = TRUE

/obj/vehicle/ridden/rockhill/dinghy
	max_buckled_mobs = 2
	max_occupants = 2
	max_drivers = 2
	layer = ABOVE_MOB_LAYER
	var/obj/item/stored_oar

/obj/vehicle/ridden/rockhill/dinghy/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/lavaboat/rockhill_dinghy)

/obj/vehicle/ridden/rockhill/dinghy/Destroy()
	QDEL_NULL(stored_oar)
	return ..()

/obj/vehicle/ridden/rockhill/dinghy/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == stored_oar)
		stored_oar = null

/obj/vehicle/ridden/rockhill/dinghy/examine(mob/user)
	. = ..()
	if(stored_oar)
		. += span_notice("An oar is secured to the side of the dinghy.")
		. += span_notice("Right-click the dinghy to retrieve it.")
	else
		. += span_notice("An oar can be secured to the side by clicking the dinghy with one.")

/obj/vehicle/ridden/rockhill/dinghy/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, ROCKHILL_OAR))
		return ..()
	if(stored_oar)
		to_chat(user, span_warning("There's already an oar secured to [src]."))
		return ITEM_INTERACT_BLOCKING
	if(!user.transferItemToLoc(tool, src))
		to_chat(user, span_warning("I can't secure [tool] to [src]."))
		return ITEM_INTERACT_BLOCKING
	stored_oar = tool
	to_chat(user, span_notice("I secure [tool] to [src]."))
	return ITEM_INTERACT_SUCCESS

/obj/vehicle/ridden/rockhill/dinghy/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || !isliving(user))
		return
	if(!stored_oar)
		to_chat(user, span_warning("There isn't an oar stored on [src]."))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	var/obj/item/oar = stored_oar
	oar.forceMove(drop_location())
	user.put_in_hands(oar)
	to_chat(user, span_notice("I retrieve the oar from [src]."))
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/datum/component/riding/vehicle/lavaboat/rockhill_dinghy
	keytype = ROCKHILL_OAR
	allowed_turfs = list(/turf/open/water)

/datum/component/riding/vehicle/lavaboat/rockhill_dinghy/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	if(pass_index == 2)
		return list(
			TEXT_NORTH = list(0, -5),
			TEXT_SOUTH = list(0, 11),
			TEXT_EAST = list(-10, 3),
			TEXT_WEST = list(10, 3),
		)
	return list(
		TEXT_NORTH = list(0, 3),
		TEXT_SOUTH = list(0, 3),
		TEXT_EAST = list(-2, 3),
		TEXT_WEST = list(2, 3),
	)

/datum/component/riding/vehicle/lavaboat/rockhill_dinghy/keycheck(mob/user)
	return user.is_holding_item_of_type(keytype)

/datum/component/riding/vehicle/lavaboat/rockhill_dinghy/driver_move(atom/movable/movable_parent, mob/living/user, direction)
	if(!keycheck(user))
		if(COOLDOWN_FINISHED(src, message_cooldown))
			to_chat(user, span_warning("I'll need an oar in one of my hands to row [movable_parent]."))
			COOLDOWN_START(src, message_cooldown, 5 SECONDS)
		return COMPONENT_DRIVER_BLOCK_MOVE
	return ..()
