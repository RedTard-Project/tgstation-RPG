/obj/item
	var/rogue_onhip = FALSE
	var/rogue_onback = FALSE

/obj/item/proc/rogue_onmob_prop(tag)
	switch(tag)
		if(ROGUE_ONMOB_HAND)
			return list("shrink" = 0.2, "sx" = -7, "sy" = -4, "nx" = 7, "ny" = -4, "wx" = -4, "wy" = -4, "ex" = 2, "ey" = -4, "nturn" = 0, "sturn" = 0, "wturn" = 0, "eturn" = 0, "nflip" = 0, "sflip" = 0, "wflip" = 0, "eflip" = 0, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0)
		if(ROGUE_ONMOB_HIP)
			return list("shrink" = 0.3, "sx" = -2, "sy" = -5, "nx" = 4, "ny" = -5, "wx" = 0, "wy" = -5, "ex" = 2, "ey" = -5, "nturn" = 0, "sturn" = 0, "wturn" = 0, "eturn" = 0, "nflip" = 0, "sflip" = 0, "wflip" = 0, "eflip" = 0, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0)
		if(ROGUE_ONMOB_BACK)
			return list("shrink" = 0.5, "sx" = 1, "sy" = -1, "nx" = 1, "ny" = -1, "wx" = 4, "wy" = -1, "ex" = -1, "ey" = -1, "nturn" = 0, "sturn" = 0, "wturn" = 0, "eturn" = 0, "nflip" = 8, "sflip" = 0, "wflip" = 0, "eflip" = 0, "northabove" = 1, "southabove" = 0, "eastabove" = 0, "westabove" = 0)

/obj/item/proc/rogue_onmob_overlays(tag, mirrored, front_layer)
	var/list/looks = list()
	for(var/behind in list(FALSE, TRUE))
		var/list/built = rogue_onmob_icon(tag, behind, mirrored)
		if(!built)
			continue
		var/mutable_appearance/look = mutable_appearance(built[1], layer = -(behind ? BODY_BEHIND_LAYER : front_layer))
		center_image(look, built[2], built[2])
		looks += look
	return length(looks) ? looks : null

/obj/item/proc/rogue_onmob_icon(tag, behind, mirrored)
	var/static/list/cache = list()
	var/key = "[type]|[icon]|[icon_state]|[color]|[tag]|[behind]|[mirrored]"
	if(!(key in cache))
		cache[key] = build_rogue_onmob_icon(tag, behind, mirrored)
	return cache[key]

/obj/item/proc/build_rogue_onmob_icon(tag, behind, mirrored)
	var/list/prop = rogue_onmob_prop(tag)
	if(!prop || !icon || isnull(icon_state))
		return null
	var/state = (behind && icon_exists(icon, "[icon_state]_behind")) ? "[icon_state]_behind" : icon_state
	var/icon/blended = icon(icon, state)
	if(istext(color))
		blended.Blend(color, ICON_MULTIPLY)
	var/size = blended.Height() == ICON_SIZE_Y ? ICON_SIZE_Y : ICON_SIZE_Y * 2
	var/mask = size == ICON_SIZE_Y ? 'modular_redtard/icons/mob/onmob_mask.dmi' : 'modular_redtard/icons/mob/onmob_mask_64.dmi'
	var/icon/result = icon(mask, "blank")
	var/static/list/directions = list(
		list("north", "n", "northabove", WEST),
		list("south", "s", "southabove", EAST),
		list("east", "e", "eastabove", EAST),
		list("west", "w", "westabove", EAST),
	)
	for(var/list/dir_data as anything in directions)
		var/direction = dir_data[1]
		var/prefix = dir_data[2]
		var/above_key = dir_data[3]
		if(mirrored && direction == "east")
			prefix = "w"
			above_key = "westabove"
		else if(mirrored && direction == "west")
			prefix = "e"
			above_key = "eastabove"
		if(prop[above_key] != (behind ? 0 : 1))
			continue
		var/icon/holder = icon(blended)
		holder.Blend(icon(mask, direction), ICON_MULTIPLY)
		if(prop["[prefix]flip"])
			holder.Flip(prop["[prefix]flip"])
		if(prop["[prefix]turn"])
			holder.Turn(prop["[prefix]turn"])
		var/px = prop["[prefix]x"]
		var/py = prop["[prefix]y"]
		if(mirrored)
			px = -px
			if(direction == "north" || direction == "south")
				px += rogue_mirror_fix(prop["shrink"], size > ICON_SIZE_Y)
		if(prop["shrink"])
			holder.Scale(size * prop["shrink"], size * prop["shrink"])
			var/shift = ICON_SIZE_X - holder.Width() / 2
			px += shift
			py += shift
		if(mirrored)
			holder.Flip(dir_data[4])
		result.Blend(holder, ICON_OVERLAY, px, py)
	return list(fcopy_rsc(result), size)

/proc/rogue_mirror_fix(shrink, big)
	switch(shrink)
		if(0.5)
			return 1
		if(0.6)
			return big ? 1 : 2
		if(0.7)
			return 1
	return 0

/mob/living/carbon/human/update_worn_back()
	. = ..()
	var/list/looks
	if(back?.rogue_onback && !HAS_TRAIT(back, TRAIT_NO_WORN_ICON))
		looks = back.rogue_onmob_overlays(ROGUE_ONMOB_BACK, TRUE, BACK_LAYER)
	if(looks)
		remove_overlay(BACK_LAYER)
	set_rogue_overlay(ROGUE_OVERLAY_BACK_LEFT, looks)

/mob/living/carbon/human/update_pockets()
	. = ..()
	update_rogue_hip(r_store, ROGUE_OVERLAY_HIP_RIGHT, FALSE, r_store?.worn_icon_hipr)
	update_rogue_hip(l_store, ROGUE_OVERLAY_HIP_LEFT, TRUE, l_store?.worn_icon_hipl)

/mob/living/carbon/human/proc/update_rogue_hip(obj/item/worn, key, mirrored, sheet)
	var/looks
	if(worn && (worn.slot_flags & ITEM_SLOT_POCKETS) && !(obscured_slots & HIDEBELT) && !HAS_TRAIT(worn, TRAIT_NO_WORN_ICON))
		if(worn.rogue_onhip)
			looks = worn.rogue_onmob_overlays(ROGUE_ONMOB_HIP, mirrored, BELT_LAYER)
		else if(sheet || worn.worn_icon)
			looks = worn.build_worn_icon(default_layer = BELT_LAYER, override_file = sheet)
	set_rogue_overlay(key, looks)
