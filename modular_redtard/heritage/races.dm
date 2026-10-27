/// Vibelin's playable races (heritage/ported/races.dm, made by tools/port_vibelin_races.py) on what Ratwood's races
/// have here (rockhill/species.dm: bodies, offsets, race sheets, traits, features): their origins, hair colours, the
/// women's attribute sheet and name lists. They are TG species /datum/species/vib_<id>, <id> being Vibelin's species
/// id, so the heritage data (allowed_races, a culture's species) names them as Vibelin does.

/datum/species
	/// Vibelin's get_skin_list(): the origins a character of the race picks from, name -> skin colour.
	var/list/rogue_origins
	/// What Vibelin calls the origin for the race ("Ancestry", "Progenitor", "Ore Attunement"...).
	var/rogue_origin_wording
	/// Vibelin's get_hairc_list(): name -> hair colour, offered beside TG's colour picker.
	var/list/rogue_hair_colors
	/// The race's own name lists: "m" and "f" first names, "last" surnames (file paths).
	var/list/rogue_names
	/// The race's attribute sheet for women, when it differs (Vibelin's statsheet_female).
	var/rogue_race_sheet_female
	/// The Vibelin species type this one is (its key in localization/strings/chargen.txt).
	var/rogue_vibelin_type

/datum/species/get_species_description()
	return rogue_description || ..()

/datum/species/get_species_lore()
	return rogue_lore || ..()

/// A name from the race's own lists, or null when it has none.
/datum/species/proc/rogue_random_name(gender)
	if(!length(rogue_names))
		return null
	var/list/first = rogue_name_list(rogue_names[gender == FEMALE ? "f" : "m"])
	if(!length(first))
		return null
	var/list/last = rogue_name_list(rogue_names["last"])
	return length(last) ? "[pick(first)] [pick(last)]" : pick(first)

/// The names of a name list file, read once.
/proc/rogue_name_list(path)
	var/static/list/cache = list()
	if(!path)
		return null
	if(isnull(cache[path]))
		var/list/names = list()
		for(var/line in world.file2list(path))
			line = trim(line)
			if(line)
				names += line
		cache[path] = names
	return cache[path]

/datum/preference/name/real_name/create_informed_default_value(datum/preferences/preferences)
	var/datum/species/species = GLOB.species_prototypes[preferences.read_preference(/datum/preference/choiced/species)]
	return species?.rogue_random_name(preferences.read_preference(/datum/preference/choiced/gender)) || ..()

/mob/living/carbon/generate_random_mob_name(unique)
	return dna?.species?.rogue_random_name(gender) || ..()

/// The race sheet follows the sex the preferences give, which they set after the species.
/datum/preferences/apply_prefs_to(mob/living/carbon/human/character, icon_updates = TRUE, list/do_not_apply)
	. = ..()
	character.rogue_update_race_sheet()

/// Vibelin's origin (its "Ancestry" picker): one of the race's named skin colours, the body's colour once the species is
/// set. A name the race does not have falls back to its first origin, so a change of race always leaves a colour.
/datum/preference/choiced/rogue_origin
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "rogue_origin"
	priority = PREFERENCE_PRIORITY_BODYPARTS
	can_randomize = FALSE

/datum/preference/choiced/rogue_origin/is_accessible(datum/preferences/preferences)
	return ..() && rogue_lobby_enabled()

/datum/preference/choiced/rogue_origin/init_possible_values()
	. = list()
	for(var/datum/species/species_type as anything in subtypesof(/datum/species))
		if(!initial(species_type.rogue_vibelin_type))
			continue
		var/datum/species/species = GLOB.species_prototypes?[species_type] || new species_type
		for(var/origin in species.rogue_origins)
			. |= origin

/datum/preference/choiced/rogue_origin/create_default_value()
	var/list/choices = get_choices()
	return choices[1]

/datum/preference/choiced/rogue_origin/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	var/list/origins = target.dna?.species?.rogue_origins
	if(!length(origins))
		return
	if(!(value in origins))
		value = origins[1]
	target.dna.features[FEATURE_MUTANT_COLOR] = origins[value]
