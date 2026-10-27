/// Vibelin's faith picker and culture choice in the character menu (charsetup/): the faiths with the patrons a player
/// may pick and the cultures, in the reader's language (localization/strings/chargen.txt), each with the races it is
/// for. The window filters them by the race the character has now (ui_data's heritage_species).

/// The faiths and cultures for a reader of this language (ROGUE_LANG_*), built once per language.
/proc/rogue_charsetup_heritage_catalog(lang)
	var/static/list/catalogs = list()
	if(catalogs[lang])
		return catalogs[lang]
	var/ru = (lang == ROGUE_LANG_RU)
	var/list/faiths = list()
	for(var/faith_path in GLOB.rogue_faiths)
		var/datum/faith/faith = GLOB.rogue_faiths[faith_path]
		var/list/patrons = list()
		for(var/datum/patron/patron as anything in faith.patrons())
			if(patron.rogue_hidden)
				continue
			patrons += list(list(
				"id" = "[patron.type]",
				"name" = rogue_chargen_name(ru, patron.type, patron.display_title()),
				"desc" = rogue_chargen_desc(ru, patron.type, patron.desc),
				"domain" = rogue_chargen_field(ru, patron.type, "domain", patron.domain),
				"worshippers" = rogue_chargen_field(ru, patron.type, "worshippers", patron.worshippers),
				"flaws" = rogue_chargen_field(ru, patron.type, "flaws", patron.flaws),
				"sins" = rogue_chargen_field(ru, patron.type, "sins", patron.sins),
				"boons" = rogue_chargen_field(ru, patron.type, "boons", patron.boons),
				"races" = patron.allowed_races || list(),
			))
		if(!length(patrons))
			continue
		faiths += list(list(
			"id" = "[faith_path]",
			"name" = rogue_chargen_name(ru, faith_path, faith.name),
			"desc" = rogue_chargen_desc(ru, faith_path, faith.desc),
			"godhead" = "[faith.godhead]",
			"patrons" = patrons,
		))
	var/list/cultures = list()
	for(var/culture_path in GLOB.rogue_cultures)
		var/datum/culture/culture = GLOB.rogue_cultures[culture_path]
		cultures += list(list(
			"id" = "[culture_path]",
			"name" = rogue_chargen_name(ru, culture_path, culture.name),
			"desc" = rogue_chargen_desc(ru, culture_path, culture.description),
			"races" = culture.species || list(),
		))
	catalogs[lang] = list("faiths" = faiths, "cultures" = cultures)
	return catalogs[lang]

/// The species id of the character the menu edits, as the heritage data knows it.
/datum/rogue_charsetup/proc/heritage_species()
	var/datum/species/species_type = prefs.read_preference(/datum/preference/choiced/species)
	return rogue_heritage_species(initial(species_type.id))

/// Vibelin's "Use Faith": the faith, with its godhead as the patron (or the first of its patrons the race may have).
/datum/rogue_charsetup/proc/select_faith(faith_id)
	if(!istext(faith_id))
		return FALSE
	var/datum/faith/faith = GLOB.rogue_faiths[text2path(faith_id)]
	if(!faith?.preference_accessible(heritage_species()))
		return FALSE
	var/datum/patron/patron = rogue_fitting_patron(faith, faith.godhead, heritage_species())
	if(!update_preference(GLOB.preference_entries[/datum/preference/choiced/rogue_heritage/faith], "[faith.type]"))
		return FALSE
	if(patron)
		update_preference(GLOB.preference_entries[/datum/preference/choiced/rogue_heritage/patron], "[patron.type]")
	return TRUE

/// A patron the race may worship, and its faith with it.
/datum/rogue_charsetup/proc/select_patron(patron_id)
	if(!istext(patron_id))
		return FALSE
	var/datum/patron/patron = GLOB.rogue_patrons[text2path(patron_id)]
	if(!patron?.preference_accessible(heritage_species()))
		return FALSE
	if(!update_preference(GLOB.preference_entries[/datum/preference/choiced/rogue_heritage/faith], "[patron.associated_faith]"))
		return FALSE
	return update_preference(GLOB.preference_entries[/datum/preference/choiced/rogue_heritage/patron], "[patron.type]")
