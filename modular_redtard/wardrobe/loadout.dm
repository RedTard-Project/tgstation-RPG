/// The wardrobe of Vibelin (Azure, Twilight, Desert and Rivermist clothes, garments, amulets, masks and gear) as a TG loadout tab.
/// The clothes and their entries are written into ported.dm by ai-skills scripts/dm_type_port.py from port.json.
/datum/loadout_category/rogue_wardrobe
	category_name = "Wardrobe"
	category_ui_icon = FA_ICON_SHIRT
	type_to_generate = /datum/loadout_item/rogue_wardrobe
	tab_order = 20

/datum/loadout_item/rogue_wardrobe
	abstract_type = /datum/loadout_item/rogue_wardrobe

/// Entries port.json makes for the face masks, which Vibelin only forges and gives no loadout entry.
/datum/loadout_item/rogue_wardrobe/facemask
	abstract_type = /datum/loadout_item/rogue_wardrobe/facemask

/// The item takes the outfit slot it is worn in, the Roguetown outfit's own shirt, cloak, wrists, ring and mouth included;
/// an item no slot of the outfit fits goes to the bag.
/datum/loadout_item/rogue_wardrobe/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	var/static/list/outfit_slots = list(
		"[ITEM_SLOT_HEAD]" = "head",
		"[ITEM_SLOT_MASK]" = "mask",
		"[ITEM_SLOT_ROGUE_MOUTH]" = "mouth",
		"[ITEM_SLOT_NECK]" = "neck",
		"[ITEM_SLOT_ROGUE_CLOAK]" = "cloak",
		"[ITEM_SLOT_OCLOTHING]" = "suit",
		"[ITEM_SLOT_ROGUE_SHIRT]" = "shirt",
		"[ITEM_SLOT_ICLOTHING]" = "uniform",
		"[ITEM_SLOT_ROGUE_WRISTS]" = "wrists",
		"[ITEM_SLOT_GLOVES]" = "gloves",
		"[ITEM_SLOT_ROGUE_RING]" = "ring",
		"[ITEM_SLOT_FEET]" = "shoes",
	)
	var/slots = item_path::slot_flags
	for(var/slot in outfit_slots)
		var/outfit_var = outfit_slots[slot]
		if((slots & text2num(slot)) && (outfit_var in outfit.vars))
			outfit.vars[outfit_var] = item_path
			return
	return ..()
