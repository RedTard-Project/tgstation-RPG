/// Detail and bust layers of Ratwood clothing (clothing.dm, build_worn_icon of update_icons.dm). A tabard's trim or a hat's band is
/// a state of its own, "[state][detail_tag]", drawn over the item in its own color, so dyeing the cloth leaves the trim as it is.
/// A worn sprite drawn for a flat chest has a "[state]_boob" layer that female wearers get on top.
/obj/item
	/// The worn sprite has a "_boob" layer for female wearers (Ratwood boobed).
	var/boobed = FALSE

/obj/item/clothing
	/// Suffix of the detail layer and its color; null color keeps the layer's own pixels (Ratwood detail_tag, detail_color).
	var/detail_tag
	var/detail_color
	/// A second detail layer, such as a helmet's plume next to its band.
	var/altdetail_tag
	var/altdetail_color
	/// The detail layers have "_boob" states of their own.
	var/boobed_detail = TRUE
	/// The sleeves (rogue_sleeved) have detail states of their own.
	var/sleeved_detail = TRUE

/obj/item/clothing/Initialize(mapload)
	. = ..()
	if(detail_tag || altdetail_tag)
		update_appearance(UPDATE_OVERLAYS)

/obj/item/clothing/update_overlays()
	. = ..()
	. += rogue_detail_layers(icon, icon_state)

/// The detail layers a state has, each in its own color; a female state without them falls back to the plain one.
/obj/item/clothing/proc/rogue_detail_layers(file, state, plain_state)
	. = list()
	for(var/list/detail in list(list(detail_tag, detail_color), list(altdetail_tag, altdetail_color)))
		var/tag = detail[1]
		if(!tag)
			continue
		var/detail_state = "[state][tag]"
		if(!icon_exists(file, detail_state))
			detail_state = "[plain_state][tag]"
			if(!plain_state || !icon_exists(file, detail_state))
				continue
		. += rogue_color_layer(file, detail_state, detail[2])

/// A layer with a color of its own, not the item's.
/proc/rogue_color_layer(file, state, color)
	var/mutable_appearance/layer = mutable_appearance(file, state, appearance_flags = RESET_COLOR)
	layer.color = color
	return layer

/// Layers added on top of the worn sprite: the bust layer, then the details. The bust layer carries the item's color itself,
/// since TG may nest the sprite under a KEEP_TOGETHER holder that has none.
/obj/item/proc/rogue_worn_layers(mutable_appearance/standing, file, state, plain_state)
	if(boobed && rogue_worn_by_female() && icon_exists(file, "[state]_boob"))
		standing.overlays += rogue_color_layer(file, "[state]_boob", color)

/obj/item/clothing/rogue_worn_layers(mutable_appearance/standing, file, state, plain_state)
	. = ..()
	standing.overlays += rogue_detail_layers(file, state, plain_state)
	if(boobed && boobed_detail && rogue_worn_by_female())
		standing.overlays += rogue_detail_layers(file, "[state]_boob", "[plain_state]_boob")
