/datum/controller/global_vars/InitGlobalstrippable_human_items()
	..()
	strippable_human_items += create_strippable_list(list(
		/datum/strippable_item/mob_item_slot/rogue/shirt,
		/datum/strippable_item/mob_item_slot/rogue/cloak,
		/datum/strippable_item/mob_item_slot/rogue/wrists,
		/datum/strippable_item/mob_item_slot/rogue/mouth,
		/datum/strippable_item/mob_item_slot/rogue/indexed/backr,
	))
	for(var/index in 1 to ROGUE_RING_SLOTS)
		var/datum/strippable_item/mob_item_slot/rogue/indexed/ring/ring = new(index)
		strippable_human_items[ring.key] = ring

/datum/strip_menu/ui_interact(mob/user, datum/tgui/ui)
	if(!ishuman(owner))
		return ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RogueStripMenu")
		ui.open()

/datum/strippable_item/mob_item_slot/rogue
	var/hidden_by = NONE

/datum/strippable_item/mob_item_slot/rogue/get_obscuring(atom/source)
	. = ..()
	if(. != STRIPPABLE_OBSCURING_NONE || !iscarbon(source))
		return
	var/mob/living/carbon/carbon_source = source
	if(carbon_source.obscured_slots & hidden_by)
		return STRIPPABLE_OBSCURING_COMPLETELY

/datum/strippable_item/mob_item_slot/rogue/shirt
	key = STRIPPABLE_ITEM_ROGUE_SHIRT
	item_slot = ITEM_SLOT_ROGUE_SHIRT
	hidden_by = HIDEJUMPSUIT

/datum/strippable_item/mob_item_slot/rogue/cloak
	key = STRIPPABLE_ITEM_ROGUE_CLOAK
	item_slot = ITEM_SLOT_ROGUE_CLOAK

/datum/strippable_item/mob_item_slot/rogue/wrists
	key = STRIPPABLE_ITEM_ROGUE_WRISTS
	item_slot = ITEM_SLOT_ROGUE_WRISTS

/datum/strippable_item/mob_item_slot/rogue/mouth
	key = STRIPPABLE_ITEM_ROGUE_MOUTH
	item_slot = ITEM_SLOT_ROGUE_MOUTH

/datum/strippable_item/mob_item_slot/rogue/indexed
	var/slot_index

/datum/strippable_item/mob_item_slot/rogue/indexed/get_item(atom/source)
	var/mob/living/carbon/human/wearer = source
	return istype(wearer) ? wearer.get_rogue_indexed(item_slot, slot_index) : null

/datum/strippable_item/mob_item_slot/rogue/indexed/try_equip(atom/source, obj/item/equipping, mob/user)
	var/mob/living/carbon/human/wearer = source
	if(!istype(wearer))
		return FALSE
	wearer.aim_rogue_slot(item_slot, slot_index)
	. = ..()
	wearer.aim_rogue_slot(item_slot, null)

/datum/strippable_item/mob_item_slot/rogue/indexed/start_equip(atom/source, obj/item/equipping, mob/user)
	var/mob/living/carbon/human/wearer = source
	if(!istype(wearer))
		return FALSE
	equipping.item_start_equip(source, equipping, user, show_visible_message)
	if(!do_after(user, get_equip_delay(equipping), source))
		return FALSE
	wearer.aim_rogue_slot(item_slot, slot_index)
	var/fits = equipping.mob_can_equip(source, item_slot, disable_warning = TRUE, bypass_equip_delay_self = TRUE)
	wearer.aim_rogue_slot(item_slot, null)
	if(!fits)
		return FALSE
	return user.temporarilyRemoveItemFromInventory(equipping)

/datum/strippable_item/mob_item_slot/rogue/indexed/finish_equip(atom/source, obj/item/equipping, mob/user)
	var/mob/living/carbon/human/wearer = source
	if(!istype(wearer))
		return FALSE
	wearer.aim_rogue_slot(item_slot, slot_index)
	. = ..()
	wearer.aim_rogue_slot(item_slot, null)

/datum/strippable_item/mob_item_slot/rogue/indexed/ring
	item_slot = ITEM_SLOT_ROGUE_RING
	hidden_by = HIDEGLOVES

/datum/strippable_item/mob_item_slot/rogue/indexed/ring/New(index)
	. = ..()
	slot_index = index
	key = STRIPPABLE_ITEM_ROGUE_RING(index)

/datum/strippable_item/mob_item_slot/rogue/indexed/backr
	key = STRIPPABLE_ITEM_ROGUE_BACKR
	item_slot = ITEM_SLOT_BACK
	slot_index = ROGUE_BACK_RIGHT
