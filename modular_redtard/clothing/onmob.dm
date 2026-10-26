/// Back and hip sprites of Ratwood's experimental_onback/experimental_onhip items, baked at build time by ai-skills
/// bake_onmob_sheets.py from their getonmobprop tables (the porter writes the jobs to rockhill/onmob_bake.json).
/// The sheet holds "back_", "backr_", "hipl_" and "hipr_" states of the item's sprite, and "<state>_behind" for the
/// parts drawn under the body; the left back and left hip are the mirrored ones, as in Ratwood.
/obj/item
	var/rogue_onmob_sheet
	/// State base in the sheet when it is not the item's icon_state (two items share a sprite but hold it differently).
	var/rogue_onmob_state

/obj/item/proc/rogue_baked_looks(prefix, front_layer)
	if(!rogue_onmob_sheet)
		return null
	var/base = rogue_onmob_state || icon_state
	if(!icon_exists(rogue_onmob_sheet, "[prefix][base]") && !icon_exists(rogue_onmob_sheet, "[prefix][base]_behind"))
		base = rogue_onmob_state || initial(icon_state)
	var/list/looks = list()
	for(var/behind in list(FALSE, TRUE))
		var/state = "[prefix][base][behind ? "_behind" : ""]"
		if(!icon_exists(rogue_onmob_sheet, state))
			continue
		var/mutable_appearance/look = mutable_appearance(rogue_onmob_sheet, state, -(behind ? BODY_BEHIND_LAYER : front_layer))
		center_image(look, ROGUE_BAKED_SIZE, ROGUE_BAKED_SIZE)
		look.color = color
		looks += look
	return length(looks) ? looks : null

/mob/living/carbon/human/update_worn_back()
	. = ..()
	var/list/looks
	if(back && !HAS_TRAIT(back, TRAIT_NO_WORN_ICON))
		looks = back.rogue_baked_looks("back_", BACK_LAYER)
	if(looks)
		remove_overlay(BACK_LAYER)
	set_rogue_overlay(ROGUE_OVERLAY_BACK_LEFT, looks)

/mob/living/carbon/human/update_pockets()
	. = ..()
	update_rogue_hip(r_store, ROGUE_OVERLAY_HIP_RIGHT, "hipr_", r_store?.worn_icon_hipr)
	update_rogue_hip(l_store, ROGUE_OVERLAY_HIP_LEFT, "hipl_", l_store?.worn_icon_hipl)

/mob/living/carbon/human/proc/update_rogue_hip(obj/item/worn, key, prefix, sheet)
	var/looks
	if(worn && (worn.slot_flags & ITEM_SLOT_POCKETS) && !(obscured_slots & HIDEBELT) && !HAS_TRAIT(worn, TRAIT_NO_WORN_ICON))
		looks = worn.rogue_baked_looks(prefix, BELT_LAYER)
		if(!looks && (sheet || worn.worn_icon))
			looks = worn.build_worn_icon(default_layer = BELT_LAYER, override_file = sheet)
	set_rogue_overlay(key, looks)
