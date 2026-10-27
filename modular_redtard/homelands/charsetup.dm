/// Ratwood's origin picker (preferences.dm open_origin_map(), a map of pins with each land's description) in the
/// character menu (charsetup/): the homelands with their descriptions, traits and who resents them, in the reader's
/// language where a translation exists (localization/strings/chargen.txt by the homeland's type path, strings/traits.txt
/// by trait). Built once per language (ROGUE_LANG_*).
/proc/rogue_charsetup_homeland_catalog(lang)
	var/static/list/catalogs = list()
	if(catalogs[lang])
		return catalogs[lang]
	var/static/regex/markup = regex(@"<[^>]*>", "g")
	var/ru = (lang == ROGUE_LANG_RU)
	var/list/homelands = rogue_homelands()
	var/list/catalog = list()
	for(var/homeland_name in homelands)
		var/datum/rogue_homeland/homeland = homelands[homeland_name]
		var/list/traits = list()
		for(var/trait in homeland.traits)
			var/list/translated = ru ? rogue_trait_sheet_entry(trait) : null
			var/trait_desc = islist(translated) ? translated[2] : GLOB.rogue_trait_descriptions[trait]
			traits += list(list(
				"name" = islist(translated) ? translated[1] : trait,
				"desc" = istext(trait_desc) ? markup.Replace(trait_desc, "") : null,
			))
		var/list/resented_by = list()
		for(var/hater_name in homeland.hated_by)
			var/datum/rogue_homeland/hater = homelands[hater_name]
			resented_by += hater ? rogue_chargen_name(ru, hater.type, hater.name) : hater_name
		catalog += list(list(
			"id" = homeland.name,
			"name" = rogue_chargen_name(ru, homeland.type, homeland.name),
			"desc" = rogue_chargen_desc(ru, homeland.type, homeland.desc),
			"traits" = traits,
			"prejudice" = !!homeland.prejudice,
			"resented_by" = resented_by,
		))
	catalogs[lang] = catalog
	return catalog
