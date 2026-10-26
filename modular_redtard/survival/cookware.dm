/// Ratwood platter (modular/Neu_Food/code/cookware/platter.dm) is a TG plate: one dish goes on it and is eaten off it, and food on
/// a platter does not rot. Metal and carved platters do not shatter.
/obj/item/cooking/platter
	parent_type = /obj/item/plate
	max_items = 1
	fragile = FALSE
	biggest_w_class = WEIGHT_CLASS_NORMAL

/obj/item/cooking/platter/AddToPlate(obj/item/item_to_plate)
	. = ..()
	name = "platter of [item_to_plate.name]"

/obj/item/cooking/platter/ItemRemovedFromPlate(obj/item/removed_item)
	. = ..()
	name = initial(name)

/// Ratwood frypan (modular/Neu_Food/code/cookware/pan.dm): it goes on a hearth, and food fries in it while the hearth burns.
/obj/item/cooking/pan/examine(mob/user)
	. = ..()
	. += span_notice("Put it on a hearth, then put food in it to fry while the hearth burns. Food left in the pan too long burns.")
