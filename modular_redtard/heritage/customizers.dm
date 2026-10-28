/// Vibelin's customizers (code/modules/client/customizer): the ears, horns, snout, neck, tail and wings of one of
/// Vibelin's races picked in the character menu in place of the race's own, in colours of the player's where Vibelin lets
/// them change. tools/port_vibelin_races.py ports every feature the race's customizers offer as a bodypart overlay
/// (rogue_feature/vib_<accessory>) and writes what each race offers per slot (rogue_customizers); the picks are one
/// character preference (rogue_features) put on the body the race gets.

#define ROGUE_FEATURE_NONE "none"
#define ROGUE_FEATURE_PATH "/datum/bodypart_overlay/simple/rogue_feature/"
/// Vibelin's accessories have at most three colour keys.
#define ROGUE_FEATURE_MAX_KEYS 3

/// The customizer slots in the menu's order, by the body zone their features are drawn on.
GLOBAL_LIST_INIT(rogue_customizer_zones, list(
	"ears" = BODY_ZONE_HEAD,
	"horns" = BODY_ZONE_HEAD,
	"snout" = BODY_ZONE_HEAD,
	"neck" = BODY_ZONE_HEAD,
	"tail" = BODY_ZONE_CHEST,
	"wings" = BODY_ZONE_CHEST,
))

/// What moves a feature of the chest as Vibelin moves it for the race and sex: wings with the back, a tail with the
/// trousers (Vibelin's OFFSET_UNDIES, which the races shift as their trousers). Features of the head move with the face.
GLOBAL_LIST_INIT(rogue_feature_offsets, list(
	"tail" = OFFSET_UNIFORM,
	"wings" = OFFSET_BACK,
))

/datum/species
	/// Vibelin's customizers of the race, by slot: list("name" = the choice's name, "default" = the feature its body has or
	/// "none", "none" = it may go without, "colors" = its colours may change, "choices" = the features to pick from).
	var/list/rogue_customizers

/datum/bodypart_overlay/simple/rogue_feature
	/// Vibelin's name of the accessory, shown in the character menu.
	var/name
	/// The customizer slot it fills: a pick in the character menu replaces it.
	var/rogue_slot
	/// Vibelin's colour keys: past the first, each key is a state of its own ("<state>_<layer>_<key>") in its own colour.
	var/rogue_color_keys = 1
	/// The default of each key: "skin", "hair", a colour, or null for the sprite as it is.
	var/list/rogue_color_defaults
	/// Vibelin's names of the keys ("Ears", "Inner", "Tips").
	var/list/rogue_color_names
	/// The colours the player picked, one per key; the keys past them keep their defaults.
	var/list/rogue_colors
	/// The layers with Vibelin's extra state, drawn uncoloured over the keys ("<state>_<layer>_extra").
	var/list/rogue_extra
	/// Vibelin's pixel_y of the accessory.
	var/rogue_pixel_y = 0

/datum/bodypart_overlay/simple/rogue_feature/get_image(obj/item/bodypart/limb, layer_index, layer_real)
	. = ..()
	var/mutable_appearance/appearance = .
	appearance.pixel_y += rogue_pixel_y
	var/offset_key = GLOB.rogue_feature_offsets[rogue_slot]
	if(offset_key)
		var/datum/worn_feature_offset/offset = limb?.feature_offsets?[offset_key]
		offset?.apply_offset(appearance)
	var/state = appearance.icon_state
	if(rogue_color_keys > 1)
		for(var/key in 2 to rogue_color_keys)
			var/mutable_appearance/part = mutable_appearance(icon, "[state]_[key]")
			part.color = rogue_key_color(limb, key)
			part.appearance_flags |= RESET_COLOR
			appearance.overlays += part
	if(layer_index in rogue_extra)
		var/mutable_appearance/extra = mutable_appearance(icon, "[state]_extra")
		extra.appearance_flags |= RESET_COLOR
		appearance.overlays += extra

/datum/bodypart_overlay/simple/rogue_feature/color_image(image/overlay, obj/item/bodypart/limb, layer_index)
	if(length(rogue_colors))
		overlay.color = rogue_colors[1]
		return
	return ..()

/// The picked colours, and the hair colour a second or third key may take, change how the limb looks.
/datum/bodypart_overlay/simple/rogue_feature/icon_render_key(obj/item/bodypart/limb)
	. = ..()
	if(length(rogue_colors))
		. += "-[jointext(rogue_colors, "-")]"
	if(rogue_color_keys > 1 && ("hair" in rogue_color_defaults))
		. += "-[rogue_hair_colour(limb)]"

/// The default of a key: "skin", "hair", a colour, or null for the sprite as it is.
/datum/bodypart_overlay/simple/rogue_feature/proc/rogue_default_source(key)
	if(key > 1)
		return LAZYACCESS(rogue_color_defaults, key)
	if(skin_coloured)
		return "skin"
	if(rogue_hair_coloured)
		return "hair"
	return draw_color

/// The colour a key past the first is drawn in: the picked one, else its default ("skin" is the limb's own colour).
/datum/bodypart_overlay/simple/rogue_feature/proc/rogue_key_color(obj/item/bodypart/limb, key)
	if(length(rogue_colors) >= key)
		return rogue_colors[key]
	var/source = rogue_default_source(key)
	switch(source)
		if("skin")
			return limb?.draw_color
		if("hair")
			return rogue_hair_colour(limb)
	return source

/// The feature's thumbnail in the character menu: its layers from the back to the front, each key in its default
/// colour (a skin and a hair of the menu's own for "skin" and "hair").
/datum/bodypart_overlay/simple/rogue_feature/proc/rogue_thumbnail()
	var/static/list/order = list("BEHIND", "ADJ", "FRONT")
	var/datum/universal_icon/sprite
	for(var/layer in order)
		if(!(layer in layers))
			continue
		var/state = "[icon_state]_[layer]"
		for(var/key in 1 to rogue_color_keys)
			var/color = rogue_default_source(key)
			switch(color)
				if("skin")
					color = "#E2B9A3"
				if("hair")
					color = "#584A3B"
			var/datum/universal_icon/part = uni_icon(icon, key > 1 ? "[state]_[key]" : state, SOUTH, null, null, color)
			if(sprite)
				sprite.blend_icon(part, ICON_OVERLAY)
			else
				sprite = part
		if(layer in rogue_extra)
			sprite.blend_icon(uni_icon(icon, "[state]_extra", SOUTH), ICON_OVERLAY)
	return sprite

/// One instance of each feature, for what the menu reads of it; null for an id that is no feature.
/proc/rogue_feature_prototype(id)
	var/static/list/prototypes = list()
	if(!istext(id))
		return null
	if(!(id in prototypes))
		var/feature_type = text2path("[ROGUE_FEATURE_PATH][id]")
		prototypes[id] = ispath(feature_type, /datum/bodypart_overlay/simple/rogue_feature) ? new feature_type : null
	return prototypes[id]

/// The features a character of one of Vibelin's races picked (Vibelin's customizer entries): slot -> list("id" = the
/// feature or "none", "colors" = the picked colours, one per key). A slot left out has the race's own; a pick the race
/// does not offer gives the race's own when it is applied, so a change of race keeps the picks of the old one for later.
/datum/preference/rogue_features
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "rogue_features"
	priority = PREFERENCE_PRIORITY_BODYPARTS
	can_randomize = FALSE

/datum/preference/rogue_features/is_accessible(datum/preferences/preferences)
	return ..() && rogue_lobby_enabled()

/datum/preference/rogue_features/deserialize(input, datum/preferences/preferences)
	. = list()
	if(!islist(input))
		return
	var/list/picked = input
	for(var/slot in GLOB.rogue_customizer_zones)
		var/list/entry = picked[slot]
		if(!islist(entry) || !istext(entry["id"]))
			continue
		var/list/clean = list("id" = copytext(entry["id"], 1, 100))
		var/list/colors = entry["colors"]
		if(islist(colors) && length(colors))
			var/list/clean_colors = list()
			for(var/color in colors.Copy(1, min(length(colors), ROGUE_FEATURE_MAX_KEYS) + 1))
				clean_colors += sanitize_hexcolor(color)
			clean["colors"] = clean_colors
		.[slot] = clean

/datum/preference/rogue_features/is_valid(value, datum/preferences/preferences)
	return islist(value)

/datum/preference/rogue_features/create_default_value()
	return list()

/datum/preference/rogue_features/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.rogue_apply_features(value)

/// Puts the picked features on the body, slot by slot of the race's customizers: the pick if the race offers it, else the
/// race's own. The same preferences put on twice give the same body (TG's character preview reuses its doll).
/mob/living/carbon/human/proc/rogue_apply_features(list/picked)
	var/list/customizers = dna?.species?.rogue_customizers
	for(var/slot in customizers)
		var/list/customizer = customizers[slot]
		var/list/entry = picked?[slot]
		var/id = entry?["id"]
		if(id == ROGUE_FEATURE_NONE ? !customizer["none"] : !(id in customizer["choices"]))
			id = customizer["default"]
			entry = null
		var/obj/item/bodypart/part = get_bodypart(GLOB.rogue_customizer_zones[slot])
		part?.rogue_set_feature(slot, id, customizer["colors"] ? entry?["colors"] : null)

/// Shows this feature (or none) in the slot, in these colours: what the slot shows is taken off, unless it is that already.
/obj/item/bodypart/proc/rogue_set_feature(slot, id, list/colors)
	var/feature_type = id == ROGUE_FEATURE_NONE ? null : text2path("[ROGUE_FEATURE_PATH][id]")
	if(!length(colors))
		colors = null
	var/kept = FALSE
	for(var/datum/bodypart_overlay/simple/rogue_feature/feature in LAZYCOPY(bodypart_overlays))
		if(feature.rogue_slot != slot)
			continue
		if(!kept && feature.type == feature_type && feature.rogue_colors ~= colors)
			kept = TRUE
			continue
		remove_bodypart_overlay(feature, update = FALSE)
	if(kept || !ispath(feature_type, /datum/bodypart_overlay/simple/rogue_feature))
		return
	var/datum/bodypart_overlay/simple/rogue_feature/feature = new feature_type
	feature.rogue_colors = colors?.Copy()
	add_bodypart_overlay(feature, update = FALSE)

// The character menu (charsetup/): a button per slot beside the looking glass (RogueCharacterSetup/customizers.tsx).

/// The thumbnails of the features in the character menu, at their sprite sizes.
/datum/asset/spritesheet_batched/rogue_customizers
	name = "rogue_customizers"

/datum/asset/spritesheet_batched/rogue_customizers/create_spritesheets()
	for(var/datum/bodypart_overlay/simple/rogue_feature/feature_type as anything in subtypesof(/datum/bodypart_overlay/simple/rogue_feature))
		if(!initial(feature_type.rogue_slot))
			continue
		var/id = copytext("[feature_type]", length(ROGUE_FEATURE_PATH) + 1)
		var/datum/bodypart_overlay/simple/rogue_feature/feature = rogue_feature_prototype(id)
		var/datum/universal_icon/sprite = feature?.rogue_thumbnail()
		if(sprite)
			insert_icon(id, sprite)

/// The customizers of the playable races, by species id: per slot, in the menu's order, its name, its default, whether
/// it may go without, whether its colours may change and its features (name, sprite size, the name and default of each
/// colour key). A slot with nothing to pick is left out. Built once per language (ROGUE_LANG_*).
/proc/rogue_charsetup_customizer_catalog(lang)
	var/static/list/catalogs = list()
	if(catalogs[lang])
		return catalogs[lang]
	var/ru = (lang == ROGUE_LANG_RU)
	var/list/catalog = list()
	for(var/species_id in get_selectable_species())
		var/datum/species/species = GLOB.species_prototypes[GLOB.species_list[species_id]]
		if(!length(species?.rogue_customizers))
			continue
		var/list/slots = list()
		for(var/slot in GLOB.rogue_customizer_zones)
			var/list/customizer = species.rogue_customizers[slot]
			if(!customizer)
				continue
			var/list/choices = customizer["choices"]
			if(length(choices) < 2 && !customizer["none"] && !customizer["colors"])
				continue
			var/list/options = list()
			for(var/id in choices)
				var/datum/bodypart_overlay/simple/rogue_feature/feature = rogue_feature_prototype(id)
				if(!feature)
					continue
				var/list/keys = list()
				for(var/key in 1 to feature.rogue_color_keys)
					var/key_name = LAZYACCESS(feature.rogue_color_names, key)
					keys += list(list(
						"name" = key_name ? rogue_chargen_term(ru, key_name) : null,
						"default" = feature.rogue_default_source(key),
					))
				var/list/size = get_icon_dimensions(feature.icon)
				options += list(list(
					"id" = id,
					"name" = rogue_chargen_term(ru, feature.name || id),
					"size" = "[size["width"]]x[size["height"]]",
					"keys" = keys,
				))
			slots += list(list(
				"slot" = slot,
				"name" = rogue_chargen_term(ru, customizer["name"]),
				"default" = customizer["default"],
				"none" = !!customizer["none"],
				"colors" = !!customizer["colors"],
				"options" = options,
			))
		if(length(slots))
			catalog[species_id] = slots
	catalogs[lang] = catalog
	return catalog

/// The customizer of the edited character's race for this slot, if it has one.
/datum/rogue_charsetup/proc/customizer(slot)
	if(!istext(slot))
		return null
	var/datum/species/species = GLOB.species_prototypes[prefs.read_preference(/datum/preference/choiced/species)]
	return species?.rogue_customizers?[slot]

/// The picked features with one slot's entry changed: a copy, so the cached value stays as it was until it is written.
/datum/rogue_charsetup/proc/features_with(slot, list/entry)
	var/list/picked = prefs.read_preference(/datum/preference/rogue_features)
	picked = picked.Copy()
	picked[slot] = entry
	return update_preference(GLOB.preference_entries[/datum/preference/rogue_features], picked)

/// The slot's pick and its colours as they are, a copy to change.
/datum/rogue_charsetup/proc/feature_entry(slot)
	var/list/picked = prefs.read_preference(/datum/preference/rogue_features)
	var/list/entry = picked[slot]
	return islist(entry) ? entry.Copy() : list()

/// Vibelin's choice of an accessory: a feature the race offers in this slot, or none where it may go without. The
/// picked colours stay, key by key.
/datum/rogue_charsetup/proc/set_customizer(slot, id)
	var/list/customizer = customizer(slot)
	if(!customizer || !istext(id))
		return FALSE
	if(id == ROGUE_FEATURE_NONE ? !customizer["none"] : !(id in customizer["choices"]))
		return FALSE
	var/list/entry = feature_entry(slot)
	entry["id"] = id
	return features_with(slot, entry)

/// Vibelin's colour of a key of the slot's feature, from TG's colour picker; the keys before it take the colours they
/// are drawn in now.
/datum/rogue_charsetup/proc/set_customizer_color(mob/user, slot, index)
	var/list/customizer = customizer(slot)
	index = isnum(index) ? index : text2num(index)
	if(!customizer?["colors"] || !isnum(index))
		return FALSE
	var/list/entry = feature_entry(slot)
	var/id = entry["id"] || customizer["default"]
	var/datum/bodypart_overlay/simple/rogue_feature/feature = rogue_feature_prototype(id)
	if(!feature || index < 1 || index > feature.rogue_color_keys)
		return FALSE
	var/list/colors = feature_colors(entry["colors"], feature)
	var/new_color = tgui_color_picker(user, rogue_ui_russian(user.client) ? "Выберите цвет" : "Select new color", null, colors[index])
	if(!new_color || QDELETED(src))
		return FALSE
	colors[index] = new_color
	entry = feature_entry(slot)
	entry["id"] = id
	entry["colors"] = colors
	return features_with(slot, entry)

/// Vibelin's "Reset colors": the slot's feature back in its default colours.
/datum/rogue_charsetup/proc/reset_customizer_colors(slot)
	if(!customizer(slot))
		return FALSE
	var/list/entry = feature_entry(slot)
	entry -= "colors"
	return features_with(slot, entry)

/// The colours the feature is drawn in for this character, one per key: the picked ones, the rest by their defaults (the
/// skin of the origin or the body colour, the hair colour, the feature's own, white).
/datum/rogue_charsetup/proc/feature_colors(list/stored, datum/bodypart_overlay/simple/rogue_feature/feature)
	. = list()
	var/datum/species/species = GLOB.species_prototypes[prefs.read_preference(/datum/preference/choiced/species)]
	for(var/key in 1 to feature.rogue_color_keys)
		if(length(stored) >= key)
			. += stored[key]
			continue
		var/source = feature.rogue_default_source(key)
		switch(source)
			if("skin")
				. += species?.rogue_origins?[prefs.read_preference(/datum/preference/choiced/rogue_origin)] || prefs.read_preference(/datum/preference/color/mutant_color)
			if("hair")
				. += prefs.read_preference(/datum/preference/color/hair_color)
			else
				. += source || COLOR_WHITE

/// Vibelin's random customizers for "Randomise Appearance": each slot of the race a feature it offers, or none where it
/// may go without, in the default colours.
/datum/rogue_charsetup/proc/randomize_customizers()
	var/datum/preference/rogue_features/preference = GLOB.preference_entries[/datum/preference/rogue_features]
	var/datum/species/species = GLOB.species_prototypes[prefs.read_preference(/datum/preference/choiced/species)]
	if(!length(species?.rogue_customizers) || !accessible(preference))
		return
	var/list/picked = prefs.read_preference(/datum/preference/rogue_features)
	picked = picked.Copy()
	for(var/slot in species.rogue_customizers)
		var/list/customizer = species.rogue_customizers[slot]
		var/list/options = customizer["choices"]
		options = options.Copy()
		if(customizer["none"])
			options += ROGUE_FEATURE_NONE
		picked[slot] = list("id" = pick(options))
	prefs.write_preference(preference, picked)

#undef ROGUE_FEATURE_NONE
#undef ROGUE_FEATURE_PATH
#undef ROGUE_FEATURE_MAX_KEYS
