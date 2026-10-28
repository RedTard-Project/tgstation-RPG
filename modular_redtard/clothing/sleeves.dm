/obj/item
	var/rogue_sleeved

/// The arm or leg of a side, "r" or "l".
/proc/rogue_sleeve_zone(side, legs)
	if(legs)
		return side == "r" ? BODY_ZONE_R_LEG : BODY_ZONE_L_LEG
	return side == "r" ? BODY_ZONE_R_ARM : BODY_ZONE_L_ARM

/// The sleeves of one side are drawn only over a limb that is there and only while the sleeve is not torn off or rolled up (Ratwood
/// get_sleeves_layer() sleeveindex); a cloak's (whole) and pauldrons (nodismemsleeves) are drawn always.
/mob/living/carbon/human/proc/rogue_sleeves(obj/item/worn, sleeve_layer, legs = FALSE, whole = FALSE)
	if(!worn?.rogue_sleeved)
		return null
	var/always = whole || worn.nodismemsleeves
	var/list/sleeves = list()
	for(var/side in list("r", "l"))
		var/zone = rogue_sleeve_zone(side, legs)
		var/state = "[side]_[worn.icon_state]"
		if(rogue_wears_female() && icon_exists(worn.rogue_sleeved, "[state][ROGUE_FEMALE_SUFFIX]"))
			state += ROGUE_FEMALE_SUFFIX
		if((!always && (!get_bodypart(zone) || worn.rogue_sleeve_bare(side))) || !icon_exists(worn.rogue_sleeved, state))
			continue
		var/mutable_appearance/sleeve = mutable_appearance(worn.rogue_sleeved, state, -sleeve_layer)
		sleeve.color = worn.color
		sleeve.alpha = worn.alpha
		var/obj/item/clothing/garment = worn
		if(istype(garment) && garment.sleeved_detail)
			sleeve.overlays += garment.rogue_detail_layers(worn.rogue_sleeved, state, "[side]_[worn.icon_state]")
		sleeves += sleeve
	return length(sleeves) ? sleeves : null

/mob/living/carbon/human/update_worn_oversuit()
	. = ..()
	set_rogue_overlay(ROGUE_OVERLAY_SLEEVES_SUIT, overlays_standing[SUIT_LAYER] ? rogue_sleeves(wear_suit, ROGUE_ARMOR_SLEEVE_LAYER) : null)

/mob/living/carbon/human/update_worn_gloves()
	. = ..()
	set_rogue_overlay(ROGUE_OVERLAY_SLEEVES_GLOVES, overlays_standing[GLOVES_LAYER] ? rogue_sleeves(gloves, ROGUE_GLOVES_SLEEVE_LAYER) : null)

/mob/living/carbon/human/update_worn_undersuit()
	. = ..()
	set_rogue_overlay(ROGUE_OVERLAY_SLEEVES_UNIFORM, overlays_standing[UNIFORM_LAYER] ? rogue_sleeves(w_uniform, ROGUE_LEG_SLEEVE_LAYER, legs = TRUE) : null)

/mob/living/carbon/human/update_worn_shoes()
	. = ..()
	set_rogue_overlay(ROGUE_OVERLAY_SLEEVES_SHOES, overlays_standing[SHOES_LAYER] ? rogue_sleeves(shoes, ROGUE_SHOES_SLEEVE_LAYER, legs = TRUE) : null)
