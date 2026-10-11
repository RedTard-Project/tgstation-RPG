/obj/item
	var/worn_icon_backr
	var/worn_icon_hipl
	var/worn_icon_hipr

/mob/living/carbon/human
	var/obj/item/wear_shirt
	var/obj/item/wear_cloak
	var/obj/item/wear_wrists
	var/obj/item/wear_mouth
	var/obj/item/wear_backr
	var/list/obj/item/wear_rings
	var/rogue_ring_target
	var/rogue_back_target
	var/list/rogue_worn_overlays

/mob/living/carbon/human/get_item_by_slot(slot_id)
	switch(slot_id)
		if(ITEM_SLOT_ROGUE_SHIRT)
			return wear_shirt
		if(ITEM_SLOT_ROGUE_CLOAK)
			return wear_cloak
		if(ITEM_SLOT_ROGUE_WRISTS)
			return wear_wrists
		if(ITEM_SLOT_ROGUE_MOUTH)
			return wear_mouth
		if(ITEM_SLOT_ROGUE_RING)
			if(rogue_ring_target)
				return get_rogue_ring(rogue_ring_target)
			for(var/obj/item/ring in wear_rings)
				return ring
			return null
		if(ITEM_SLOT_BACK)
			if(rogue_back_target == ROGUE_BACK_RIGHT)
				return wear_backr
	return ..()

/mob/living/carbon/human/get_slot_by_item(obj/item/looking_for)
	if(looking_for)
		if(looking_for == wear_shirt)
			return ITEM_SLOT_ROGUE_SHIRT
		if(looking_for == wear_cloak)
			return ITEM_SLOT_ROGUE_CLOAK
		if(looking_for == wear_wrists)
			return ITEM_SLOT_ROGUE_WRISTS
		if(looking_for == wear_mouth)
			return ITEM_SLOT_ROGUE_MOUTH
		if(looking_for == wear_backr)
			return ITEM_SLOT_BACK
		if(looking_for in wear_rings)
			return ITEM_SLOT_ROGUE_RING
	return ..()

/mob/living/carbon/human/proc/get_rogue_ring(index)
	return LAZYACCESS(wear_rings, index)

/mob/living/carbon/human/proc/free_rogue_ring()
	if(rogue_ring_target)
		return get_rogue_ring(rogue_ring_target) ? 0 : rogue_ring_target
	for(var/index in 1 to ROGUE_RING_SLOTS)
		if(!get_rogue_ring(index))
			return index
	return 0

/mob/living/carbon/human/proc/get_rogue_indexed(slot, index)
	switch(slot)
		if(ITEM_SLOT_ROGUE_RING)
			return get_rogue_ring(index)
		if(ITEM_SLOT_BACK)
			return index == ROGUE_BACK_RIGHT ? wear_backr : back

/mob/living/carbon/human/proc/aim_rogue_slot(slot, index)
	switch(slot)
		if(ITEM_SLOT_ROGUE_RING)
			rogue_ring_target = index
		if(ITEM_SLOT_BACK)
			rogue_back_target = index

/mob/living/carbon/human/proc/equip_to_rogue_cell(obj/item/equipping, slot, index, qdel_on_fail = FALSE, bypass_equip_delay_self = FALSE, initial = FALSE, indirect_action = FALSE)
	aim_rogue_slot(slot, index)
	. = equip_to_slot_if_possible(equipping, slot, qdel_on_fail, disable_warning = TRUE, bypass_equip_delay_self = bypass_equip_delay_self, initial = initial, indirect_action = indirect_action)
	aim_rogue_slot(slot, null)

/mob/living/carbon/equip_to_slot(obj/item/equipping, slot, initial = FALSE, redraw_mob = FALSE, indirect_action = FALSE)
	. = ..()
	if(!. || !((slot & ITEM_SLOTS_ROGUE) || slot == ITEM_SLOT_BACK) || !ishuman(src))
		return
	var/mob/living/carbon/human/wearer = src
	if(!wearer.set_rogue_slot(slot, equipping))
		return
	has_equipped(equipping, slot, initial)
	return FALSE

/mob/living/carbon/human/doUnEquip(obj/item/item_dropping, force, newloc, no_move, invdrop = TRUE, silent = FALSE)
	var/slot = item_dropping ? (get_slot_by_item(item_dropping) & ITEM_SLOTS_ROGUE) : NONE
	var/ring_index = (slot == ITEM_SLOT_ROGUE_RING) ? wear_rings.Find(item_dropping) : 0
	var/second_back = item_dropping && item_dropping == wear_backr
	var/dropped_belt = item_dropping && item_dropping == belt
	. = ..()
	if(!.)
		return
	if(dropped_belt && invdrop)
		for(var/obj/item/hip as anything in list(l_store, r_store))
			if(hip && !can_equip(hip, get_slot_by_item(hip), TRUE, ignore_equipped = TRUE))
				dropItemToGround(hip)
	if(second_back)
		wear_backr = null
		update_rogue_backr()
		return
	if(!slot)
		return
	if(ring_index)
		wear_rings[ring_index] = null
		update_rogue_ring(ring_index)
		return
	set_rogue_slot(slot, null)

/mob/living/carbon/human/update_clothing(slot_flags)
	. = ..()
	for(var/slot in ROGUE_SLOT_LIST)
		if(slot_flags & slot)
			update_rogue_slot(slot)
	if(slot_flags & ITEM_SLOT_BACK)
		update_rogue_backr()
	if(slot_flags & ITEM_SLOT_BELT)
		update_pockets()

/mob/living/carbon/human/proc/set_rogue_slot(slot, obj/item/worn)
	if(slot == ITEM_SLOT_ROGUE_RING)
		var/index = worn ? free_rogue_ring() : 0
		if(!index)
			return FALSE
		if(!wear_rings)
			wear_rings = new /list(ROGUE_RING_SLOTS)
		wear_rings[index] = worn
		update_rogue_ring(index)
		return TRUE
	if(slot == ITEM_SLOT_BACK)
		if(rogue_back_target != ROGUE_BACK_RIGHT || (worn && wear_backr))
			return FALSE
		wear_backr = worn
		update_rogue_backr()
		return TRUE
	if(worn && get_item_by_slot(slot))
		return FALSE
	switch(slot)
		if(ITEM_SLOT_ROGUE_SHIRT)
			wear_shirt = worn
		if(ITEM_SLOT_ROGUE_CLOAK)
			wear_cloak = worn
		if(ITEM_SLOT_ROGUE_WRISTS)
			wear_wrists = worn
		if(ITEM_SLOT_ROGUE_MOUTH)
			wear_mouth = worn
		else
			return FALSE
	update_rogue_slot(slot)
	return TRUE

/mob/living/carbon/human/proc/update_rogue_slot(slot)
	if(slot == ITEM_SLOT_ROGUE_RING)
		for(var/index in 1 to ROGUE_RING_SLOTS)
			update_rogue_ring(index)
		return
	var/layer_value
	switch(slot)
		if(ITEM_SLOT_ROGUE_SHIRT)
			layer_value = ROGUE_SHIRT_LAYER
		if(ITEM_SLOT_ROGUE_CLOAK)
			layer_value = ROGUE_CLOAK_LAYER
		if(ITEM_SLOT_ROGUE_WRISTS)
			layer_value = ROGUE_WRISTS_LAYER
		if(ITEM_SLOT_ROGUE_MOUTH)
			layer_value = ROGUE_MOUTH_LAYER
	var/obj/item/worn = get_item_by_slot(slot)
	if(slot == ITEM_SLOT_ROGUE_MOUTH && (!worn?.worn_icon || !get_bodypart(BODY_ZONE_HEAD)))
		worn = null
	hud_used?.update_inventory_slot(slot)
	var/mutable_appearance/look
	if(worn)
		look = worn.build_worn_icon(default_layer = layer_value, default_icon_file = worn.icon)
	set_rogue_overlay("[slot]", look)

/mob/living/carbon/human/proc/update_rogue_ring(index)
	hud_used?.update_inventory_slot(ITEM_SLOT_ROGUE_RING, index)
	var/obj/item/ring = get_rogue_ring(index)
	var/mutable_appearance/look
	if(ring)
		look = ring.build_worn_icon(default_layer = ROGUE_RING_LAYER, default_icon_file = ring.icon)
	set_rogue_overlay(ROGUE_RING_ID(index), look)

/mob/living/carbon/human/proc/update_rogue_backr()
	hud_used?.update_inventory_slot(ITEM_SLOT_BACK, ROGUE_BACK_RIGHT)
	if(!wear_backr || HAS_TRAIT(wear_backr, TRAIT_NO_WORN_ICON))
		set_rogue_overlay(HUD_ROGUE_BACKR, null)
		return
	if(wear_backr.rogue_onback)
		set_rogue_overlay(HUD_ROGUE_BACKR, wear_backr.rogue_onmob_overlays(ROGUE_ONMOB_BACK, FALSE, ROGUE_BACKR_LAYER))
		return
	var/mutable_appearance/look = wear_backr.build_worn_icon(default_layer = ROGUE_BACKR_LAYER, default_icon_file = 'icons/mob/clothing/back.dmi', override_file = wear_backr.worn_icon_backr, bodyshape = bodyshape)
	apply_height(look, ENTIRE_BODY)
	var/obj/item/bodypart/chest/my_chest = get_bodypart(BODY_ZONE_CHEST)
	my_chest?.worn_back_offset?.apply_offset(look)
	set_rogue_overlay(HUD_ROGUE_BACKR, look)

/mob/living/carbon/human/proc/set_rogue_overlay(key, look)
	var/mutable_appearance/old = LAZYACCESS(rogue_worn_overlays, key)
	if(old)
		cut_overlay(old)
		LAZYREMOVE(rogue_worn_overlays, key)
	if(QDELETED(src) || !look)
		return
	add_overlay(look)
	LAZYSET(rogue_worn_overlays, key, look)

/datum/species/can_equip(obj/item/I, slot, disable_warning, mob/living/carbon/human/H, bypass_equip_delay_self = FALSE, ignore_equipped = FALSE, indirect_action = FALSE)
	if(slot & (ITEM_SLOT_POCKETS|ITEM_SLOT_BELT))
		return can_equip_rogue_hip(I, slot, disable_warning, H, bypass_equip_delay_self, ignore_equipped)
	if(!(slot & ITEM_SLOTS_ROGUE))
		return ..()
	if(!(I.slot_flags & slot))
		return FALSE
	if(slot == ITEM_SLOT_ROGUE_MOUTH && !H.get_bodypart(BODY_ZONE_HEAD))
		return FALSE
	if(!ignore_equipped)
		if(slot == ITEM_SLOT_ROGUE_RING ? !H.free_rogue_ring() : H.get_item_by_slot(slot))
			return FALSE
	return equip_delay_self_check(I, H, bypass_equip_delay_self)

/datum/species/proc/can_equip_rogue_hip(obj/item/I, slot, disable_warning, mob/living/carbon/human/H, bypass_equip_delay_self, ignore_equipped)
	if((no_equip_flags & slot) && !is_type_in_list(src, I.species_exception))
		return FALSE
	if(!ignore_equipped && H.get_item_by_slot(slot))
		return FALSE
	if(!(I.slot_flags & slot) && !((slot & ITEM_SLOT_POCKETS) && I.w_class <= POCKET_WEIGHT_CLASS))
		return FALSE
	if(slot == ITEM_SLOT_BELT)
		return equip_delay_self_check(I, H, bypass_equip_delay_self)
	if(HAS_TRAIT(I, TRAIT_NODROP))
		return FALSE
	if(!H.belt)
		if(!disable_warning)
			to_chat(H, span_warning("You need a belt before you can hang [I] on it!"))
		return FALSE
	return TRUE

/mob/living/carbon/human/get_worn_bodypart_armor_value(obj/item/bodypart/def_zone, damage_type)
	. = ..()
	if(!damage_type)
		return
	var/unblocked_damage = 100 - .
	for(var/obj/item/clothing/layer in list(wear_shirt, wear_cloak, wear_wrists) + wear_rings)
		if(layer.body_parts_covered & def_zone.body_part)
			unblocked_damage *= (100 - min(layer.get_armor_rating(damage_type), 100)) * 0.01
	return 100 - unblocked_damage

/mob/living/carbon/human/equip_to_appropriate_slot(obj/item/W, qdel_on_fail = FALSE, indirect_action = FALSE)
	if(istype(W) && !W.slot_equipment_priority)
		if(W.slot_flags & ITEM_SLOTS_ROGUE)
			for(var/slot in list(ITEM_SLOT_ROGUE_SHIRT, ITEM_SLOT_ROGUE_CLOAK, ITEM_SLOT_ROGUE_WRISTS, ITEM_SLOT_ROGUE_RING))
				if((W.slot_flags & slot) && equip_to_slot_if_possible(W, slot, disable_warning = TRUE, indirect_action = indirect_action))
					return TRUE
			if((W.slot_flags & ITEM_SLOT_ROGUE_MOUTH) && !(W.slot_flags & ~(ITEM_SLOTS_ROGUE|ITEM_SLOT_POCKETS)) && equip_to_slot_if_possible(W, ITEM_SLOT_ROGUE_MOUTH, disable_warning = TRUE, indirect_action = indirect_action))
				return TRUE
		if((W.slot_flags & ITEM_SLOT_BACK) && back && !wear_backr && equip_to_rogue_cell(W, ITEM_SLOT_BACK, ROGUE_BACK_RIGHT, indirect_action = indirect_action))
			return TRUE
	return ..()

/mob/living/carbon/human/get_clothing_examine_info(mob/living/user)
	. = ..()
	var/t_He = p_They()
	var/t_his = p_their()
	var/t_has = p_have()
	var/t_is = p_are()
	if(wear_shirt && !(obscured_slots & HIDEJUMPSUIT) && !HAS_TRAIT(wear_shirt, TRAIT_EXAMINE_SKIP))
		. += "[t_He] [t_is] wearing [wear_shirt.examine_title(user)]."
	if(wear_cloak && !HAS_TRAIT(wear_cloak, TRAIT_EXAMINE_SKIP))
		. += "[t_He] [t_is] wearing [wear_cloak.examine_title(user)] over [t_his] shoulders."
	if(wear_backr && !HAS_TRAIT(wear_backr, TRAIT_EXAMINE_SKIP))
		. += "[t_He] [t_has] [wear_backr.examine_title(user)] on [t_his] back."
	if(wear_wrists && !HAS_TRAIT(wear_wrists, TRAIT_EXAMINE_SKIP))
		. += "[t_He] [t_has] [wear_wrists.examine_title(user)] on [t_his] wrists."
	if(wear_mouth && !HAS_TRAIT(wear_mouth, TRAIT_EXAMINE_SKIP))
		. += "[t_He] [t_has] [wear_mouth.examine_title(user)] in [t_his] mouth."
	if(obscured_slots & HIDEGLOVES)
		return
	var/list/rings = list()
	for(var/obj/item/ring in wear_rings)
		if(!HAS_TRAIT(ring, TRAIT_EXAMINE_SKIP))
			rings += ring.examine_title(user)
	if(length(rings))
		. += "[t_He] [t_is] wearing [english_list(rings)] on [t_his] fingers."

/obj/item/bodypart/head/drop_limb(special, dismembered, move_to_floor = TRUE)
	var/mob/living/carbon/human/head_owner = owner
	if(!special && istype(head_owner) && head_owner.wear_mouth)
		head_owner.dropItemToGround(head_owner.wear_mouth, force = TRUE)
	return ..()
