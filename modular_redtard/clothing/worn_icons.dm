/obj/item
	var/rogue_female_worn = FALSE
	var/rogue_inhand = FALSE

/obj/item/build_worn_icon(default_layer = 0, default_icon_file = null, isinhands = FALSE, female_uniform = NO_FEMALE_UNIFORM, override_state = null, override_file = null, bodyshape = NONE)
	if(isinhands && rogue_draws_held())
		var/mutable_appearance/held = rogue_held_look(FALSE)
		if(held)
			return held
	if(!isinhands && rogue_female_worn && rogue_worn_by_female())
		var/state = "[override_state || worn_icon_state || icon_state][ROGUE_FEMALE_SUFFIX]"
		if(icon_exists(override_file || worn_icon || default_icon_file, state))
			override_state = state
			female_uniform = NO_FEMALE_UNIFORM
	return ..(default_layer, default_icon_file, isinhands, female_uniform, override_state, override_file, bodyshape)

/obj/item/proc/rogue_worn_by_female()
	var/mob/living/carbon/human/wearer = loc
	return istype(wearer) && wearer.physique == FEMALE

/obj/item/proc/rogue_draws_held()
	return rogue_inhand

/obj/item/proc/rogue_held_look(behind)
	var/mob/holder = loc
	if(!istype(holder))
		return null
	var/tag = (HAS_TRAIT(src, TRAIT_WIELDED) && rogue_onmob_prop(ROGUE_ONMOB_WIELDED)) ? ROGUE_ONMOB_WIELDED : ROGUE_ONMOB_HAND
	var/list/built = rogue_onmob_icon(tag, behind, IS_LEFT_INDEX(holder.get_held_index_of_item(src)))
	if(!built)
		return null
	var/mutable_appearance/look = mutable_appearance(built[1], layer = -(behind ? BODY_BEHIND_LAYER : HANDS_LAYER))
	center_image(look, built[2], built[2])
	var/list/offsets = get_worn_offsets(TRUE)
	look.pixel_w += offsets[1]
	look.pixel_z += offsets[2]
	look.alpha = alpha
	return look

/mob/living/carbon/human/update_held_items()
	. = ..()
	var/list/behind = list()
	for(var/obj/item/held in held_items)
		if(!held.rogue_draws_held())
			continue
		var/mutable_appearance/look = held.rogue_held_look(TRUE)
		if(!look)
			continue
		apply_height(look, LOWER_BODY)
		var/obj/item/bodypart/arm/hand = hand_bodyparts[get_held_index_of_item(held)]
		hand?.held_hand_offset?.apply_offset(look)
		behind += look
	set_rogue_overlay(ROGUE_OVERLAY_HANDS_BEHIND, length(behind) ? behind : null)
