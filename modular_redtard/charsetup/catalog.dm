/// The parts of Vibelin's character menu (modular_abel/character_setup, PreferencesMenu.tsx) that are the same for every
/// player, built once: the playable species with their descriptions, perks and race stats, TG's catalogs of the
/// appearance choices (compile_constant_data, the data TG's own menu fetches as preferences.json), the joinable roles by
/// department with their subclasses, the age bands with their stats and the rows of the settings page. The menu sends
/// them as its static data through the tgui window, so none of it is fetched over HTTP: Vibelin fetched its catalog
/// (chargen_catalog.json) with fetch(), which a CDN answers only with CORS headers, and gave up after one failure.

/// The preferences the menu shows, by savefile key, in TG's priority order (species before the features that follow
/// it). Character preferences: the appearance categories, the name, species, gender, age and the module's own
/// non-contextual texts (rogue_*), if some playable species has them; player preferences: the settings page.
/proc/rogue_charsetup_shown_preferences()
	var/static/list/shown
	if(shown)
		return shown
	var/static/list/appearance = list(
		PREFERENCE_CATEGORY_FEATURES,
		PREFERENCE_CATEGORY_CLOTHING,
		PREFERENCE_CATEGORY_SECONDARY_FEATURES,
		PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES,
	)
	// Station things a medieval character never uses: the job's backpack and jumpsuit.
	var/static/list/hidden = list("backpack", "jumpsuit_style")
	var/list/settings = list()
	for(var/list/group as anything in rogue_charsetup_settings_catalog())
		settings |= group["keys"]
	var/list/species_types = list()
	for(var/species_id in get_selectable_species())
		species_types += GLOB.species_list[species_id]
	shown = list()
	for(var/datum/preference/preference as anything in get_preferences_in_priority_order())
		var/key = preference.savefile_key
		if(key in hidden)
			continue
		if(preference.savefile_identifier == PREFERENCE_PLAYER)
			if(key in settings)
				shown[key] = preference
			continue
		var/wanted = (preference.category in appearance) || (key in list("real_name", "species", "gender", "age"))
		if(!wanted && preference.category == PREFERENCE_CATEGORY_NON_CONTEXTUAL && findtext(key, "rogue_") == 1)
			wanted = TRUE
		if(wanted && rogue_charsetup_relevant(preference, species_types))
			shown[key] = preference
	return shown

/// Whether some playable species has this preference (TG's has_relevant_feature, asked of every species at once).
/proc/rogue_charsetup_relevant(datum/preference/preference, list/species_types)
	if(isnull(preference.relevant_inherent_trait) && isnull(preference.relevant_organ) && isnull(preference.relevant_head_flag) && isnull(preference.relevant_body_markings))
		return TRUE
	for(var/species_type in species_types)
		var/datum/species/species = GLOB.species_prototypes[species_type]
		if(species && (preference.savefile_key in species.get_features()))
			return TRUE
	return FALSE

/// TG's constant data of the shown preferences, by savefile key: choices, icon classes of TG's preferences spritesheet,
/// names, limits. TG's feature components read it as their serverData.
/proc/rogue_charsetup_feature_catalog()
	var/static/list/catalog
	if(catalog)
		return catalog
	catalog = list()
	var/list/shown = rogue_charsetup_shown_preferences()
	for(var/key in shown)
		var/datum/preference/preference = shown[key]
		if(istype(preference, /datum/preference/choiced/species))
			continue
		var/data = preference.compile_constant_data()
		if(!isnull(data))
			catalog[key] = data
	return catalog

/// The playable species (TG's selectable species: on medieval maps the config's and Ratwood's playable races), with
/// TG's description, lore and perks, and the race's stats from its attribute sheet, as Vibelin shows them; built once
/// per language (ROGUE_LANG_*). In Russian a race Vibelin describes gets Vibelin's name and text (chargen.txt), which
/// stands in for the English lore.
/proc/rogue_charsetup_species_catalog(lang)
	var/static/list/catalogs = list()
	if(catalogs[lang])
		return catalogs[lang]
	var/ru = (lang == ROGUE_LANG_RU)
	var/list/catalog = list()
	catalogs[lang] = catalog
	for(var/species_id in get_selectable_species())
		var/species_type = GLOB.species_list[species_id]
		var/datum/species/species = GLOB.species_prototypes[species_type]
		if(!species)
			continue
		var/list/stats = rogue_charsetup_sheet_stats(species.rogue_race_sheet, ru)
		var/list/stat_perks = list()
		for(var/list/stat as anything in rogue_charsetup_sheet_stats(species.rogue_race_sheet))
			stat_perks += "[stat["name"]] [stat["value"] > 0 ? "+" : ""][stat["value"]]"
		// The race's stat bonuses are perks too (rockhill/species.dm); the menu shows them as stats instead.
		var/list/perks = species.get_species_perks()
		for(var/kind in perks)
			var/list/kept = list()
			for(var/list/perk as anything in perks[kind])
				if(!(perk[SPECIES_PERK_NAME] in stat_perks))
					kept += list(perk)
			perks[kind] = kept
		var/desc = species.get_species_description()
		var/translated_desc = rogue_chargen_desc(ru, species_type, desc)
		var/list/origins = list()
		for(var/origin in species.rogue_origins)
			origins += list(list("name" = origin, "label" = rogue_chargen_compound(ru, origin), "color" = species.rogue_origins[origin]))
		var/list/hair_colors = list()
		for(var/hair in species.rogue_hair_colors)
			hair_colors += list(list("name" = rogue_chargen_compound(ru, hair), "color" = species.rogue_hair_colors[hair]))
		catalog += list(list(
			"id" = species_id,
			"name" = rogue_chargen_name(ru, species_type, species.name),
			"desc" = translated_desc,
			"lore" = translated_desc == desc ? species.get_species_lore() : list(),
			"icon" = sanitize_css_class_name(species.name),
			"sexes" = !!species.sexes,
			"skin_tones" = (TRAIT_USES_SKINTONES in species.inherent_traits),
			"mutant_colors" = (TRAIT_MUTANT_COLORS in species.inherent_traits) && !(TRAIT_FIXED_MUTANT_COLORS in species.inherent_traits),
			"medieval" = !!species.rogue_playable,
			"stats" = stats,
			"perks" = perks,
			"origins" = origins,
			"origin_wording" = species.rogue_origin_wording ? rogue_chargen_term(ru, species.rogue_origin_wording) : null,
			"hair_colors" = hair_colors,
		))
	return catalog

/// The stats an attribute sheet changes, as Vibelin's stat chips: name, shorthand, amount; in Russian (ru) with
/// Vibelin's names of the stats (chargen_terms.txt).
/proc/rogue_charsetup_sheet_stats(sheet_type, ru = FALSE)
	. = list()
	if(!sheet_type)
		return
	var/datum/attribute_holder/sheet/sheet = rockhill_sheet(sheet_type)
	for(var/stat_type in GLOB.rogue_stats)
		var/value = sheet.raw_attribute_list[stat_type]
		if(!isnum(value) || !value)
			continue
		var/datum/attribute/stat/stat = GLOB.rogue_stats[stat_type]
		. += list(list(
			"name" = rogue_chargen_term(ru, stat.name),
			"label" = rogue_chargen_term(ru, stat.shorthand || stat.name),
			"value" = value,
		))

/// The roles a player can ask for (TG's jobs middleware: joinable, not late-join only), by department in their order,
/// with the subclasses a Rockhill role picks from when it spawns (Vibelin shows alternate titles in their place).
/// Built once the jobs exist.
/proc/rogue_charsetup_job_catalog()
	var/static/list/catalog
	if(catalog)
		return catalog
	if(!length(SSjob.joinable_occupations))
		return list()
	var/list/departments = list()
	for(var/datum/job/job as anything in SSjob.joinable_occupations)
		if(job.job_flags & JOB_LATEJOIN_ONLY)
			continue
		var/datum/job_department/department_type = job.department_for_prefs || job.departments_list?[1]
		if(isnull(department_type))
			continue
		var/department_name = initial(department_type.department_name)
		var/list/department = departments[department_name]
		if(!department)
			department = list(
				"name" = department_name,
				"color" = initial(department_type.ui_color),
				"order" = initial(department_type.display_order),
				"jobs" = list(),
			)
			departments[department_name] = department
		var/list/classes = list()
		var/datum/job/roguetown/rogue_job = job
		if(istype(rogue_job))
			for(var/class_path in rogue_job.rockhill_advclasses)
				var/datum/rockhill_advclass/advclass = rockhill_advclass(class_path)
				if(advclass)
					classes += list(list("name" = advclass.name, "desc" = advclass.desc))
		var/list/jobs = department["jobs"]
		jobs += list(list(
			"title" = job.title,
			"description" = job.description,
			"slots" = job.spawn_positions,
			"classes" = classes,
		))
	catalog = list()
	for(var/department_name in departments)
		catalog += list(departments[department_name])
	return catalog

/// The age bands of medieval characters (attributes/mob.dm rogue_apply_age(): the middle-aged and the old get an
/// attribute sheet), for Vibelin's age tooltip, per language (ROGUE_LANG_*).
/proc/rogue_charsetup_age_catalog(lang)
	var/static/list/catalogs = list()
	if(catalogs[lang])
		return catalogs[lang]
	var/ru = (lang == ROGUE_LANG_RU)
	catalogs[lang] = list(
		"min" = AGE_MIN,
		"max" = AGE_MAX,
		"bands" = list(
			list("name" = rogue_chargen_term(ru, "Adult"), "from" = AGE_MIN, "stats" = list()),
			list("name" = rogue_chargen_term(ru, "Middle-Aged"), "from" = ROGUE_AGE_MIDDLE, "stats" = rogue_charsetup_sheet_stats(/datum/attribute_holder/sheet/age_middle, ru)),
			list("name" = rogue_chargen_term(ru, "Old"), "from" = ROGUE_AGE_OLD, "stats" = rogue_charsetup_sheet_stats(/datum/attribute_holder/sheet/age_old, ru)),
		),
	)
	return catalogs[lang]

/// Vibelin's settings page on TG's player preferences: the groups and the keys that exist here.
/proc/rogue_charsetup_settings_catalog()
	var/static/list/catalog
	if(catalog)
		return catalog
	var/static/list/groups = list(
		"Interface" = list("rogue_ui_language", "hotkeys", "buttons_locked", "tgui_lock", "tgui_input", "windowflashing", "ui_scale"),
		"Display" = list("ambientocclusion", "auto_fit_viewport", "widescreenpref", "fullscreen_mode", "pixel_size", "scaling_method", "see_chat_non_mob"),
		"Audio" = list("sound_lobby_volume", "sound_midi", "sound_ambience_volume", "sound_instruments"),
	)
	catalog = list()
	for(var/title in groups)
		var/list/keys = list()
		for(var/key in groups[title])
			var/datum/preference/preference = GLOB.preference_entries_by_key[key]
			if(preference?.savefile_identifier == PREFERENCE_PLAYER)
				keys += key
		if(length(keys))
			catalog += list(list("title" = title, "keys" = keys))
	return catalog
