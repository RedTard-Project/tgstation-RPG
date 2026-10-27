/// The character's faith, patron and culture on medieval maps (Vibelin's preferences faith, patron, culture). The
/// values are type paths as text. A patron must belong to the faith and accept the race, a culture must fit the race;
/// what does not fit falls back when the character is made (the faith's godhead, the ambiguous culture), so a change
/// of race never leaves a character without one.

#define ROGUE_DEFAULT_FAITH "/datum/faith/divine_pantheon"
#define ROGUE_DEFAULT_CULTURE "/datum/culture/universal/ambiguous"

/datum/preference/choiced/rogue_heritage
	abstract_type = /datum/preference/choiced/rogue_heritage
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	should_update_preview = FALSE

/datum/preference/choiced/rogue_heritage/is_accessible(datum/preferences/preferences)
	return ..() && rogue_lobby_enabled()

/datum/preference/choiced/rogue_heritage/faith
	savefile_key = "rogue_faith"

/datum/preference/choiced/rogue_heritage/faith/init_possible_values()
	. = list()
	for(var/path in GLOB.rogue_faiths)
		. += "[path]"

/datum/preference/choiced/rogue_heritage/faith/create_default_value()
	return ROGUE_DEFAULT_FAITH

/datum/preference/choiced/rogue_heritage/faith/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(rogue_lobby_enabled())
		target.rogue_faith = GLOB.rogue_faiths[text2path(value)]

/datum/preference/choiced/rogue_heritage/patron
	savefile_key = "rogue_patron"

/datum/preference/choiced/rogue_heritage/patron/init_possible_values()
	. = list()
	for(var/path in GLOB.rogue_patrons)
		. += "[path]"

/datum/preference/choiced/rogue_heritage/patron/create_default_value()
	var/datum/faith/faith = GLOB.rogue_faiths[text2path(ROGUE_DEFAULT_FAITH)]
	return "[faith?.godhead || pick(GLOB.rogue_patrons)]"

/datum/preference/choiced/rogue_heritage/patron/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(!rogue_lobby_enabled())
		return
	var/datum/faith/faith = GLOB.rogue_faiths[text2path(preferences.read_preference(/datum/preference/choiced/rogue_heritage/faith))]
	target.rogue_set_patron(rogue_fitting_patron(faith, text2path(value), target.dna?.species?.id))

/// The picked patron if it fits the faith and the race, else the faith's godhead, else its first patron that fits.
/proc/rogue_fitting_patron(datum/faith/faith, patron_path, species_id)
	var/datum/patron/picked = GLOB.rogue_patrons[patron_path]
	if(picked && (!faith || picked.associated_faith == faith.type) && picked.preference_accessible(species_id))
		return picked
	if(!faith)
		return picked
	var/datum/patron/godhead = GLOB.rogue_patrons[faith.godhead]
	if(godhead?.preference_accessible(species_id))
		return godhead
	for(var/datum/patron/patron as anything in faith.patrons())
		if(patron.preference_accessible(species_id))
			return patron
	return godhead

/datum/preference/choiced/rogue_heritage/culture
	savefile_key = "rogue_culture"

/datum/preference/choiced/rogue_heritage/culture/init_possible_values()
	. = list()
	for(var/path in GLOB.rogue_cultures)
		. += "[path]"

/datum/preference/choiced/rogue_heritage/culture/create_default_value()
	return ROGUE_DEFAULT_CULTURE

/datum/preference/choiced/rogue_heritage/culture/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(!rogue_lobby_enabled())
		return
	var/datum/culture/culture = GLOB.rogue_cultures[text2path(value)]
	if(!culture?.is_selectable(target.dna?.species?.id))
		culture = GLOB.rogue_cultures[text2path(ROGUE_DEFAULT_CULTURE)]
	target.rogue_culture = culture

#undef ROGUE_DEFAULT_FAITH
#undef ROGUE_DEFAULT_CULTURE
