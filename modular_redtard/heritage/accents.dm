/// Vibelin's accents (code/__DEFINES/accents.dm and strings/accents, ported by tools/port_vibelin_races.py into
/// heritage/strings/accents): a speaker of one of Vibelin's races swaps the words of what they say as their accent does
/// (Vibelin's species handle_speech(): a tiefling's Infernal lilt, a dwarf's burr). The race's own accent colours the
/// languages other than its native one; an accent picked in the character menu (one the race or the culture speaks
/// with) colours every language, and "No Accent" none. The swaps are English words, so Russian speech keeps its words.

#define ROGUE_ACCENT_SPECIES "Species Accent"
#define ROGUE_ACCENT_NONE "No Accent"
#define ROGUE_ACCENT_DIRECTORY "modular_redtard/heritage/strings"

/datum/species
	/// The language the race speaks without its accent (Vibelin's native_language).
	var/rogue_native_language
	/// The accent the race speaks the other languages with (Vibelin's get_accent() of its native language).
	var/rogue_accent
	/// The accents a character of the race may pick instead (Vibelin's multiple_accents).
	var/list/rogue_accents

/datum/culture
	/// The accent people of the culture may pick (Vibelin's accent of a culture).
	var/rogue_accent

/mob/living/carbon/human
	/// The accent picked in the character menu: the race's own, none, or one of the race's or the culture's.
	var/rogue_accent_choice = ROGUE_ACCENT_SPECIES

/// The character's accent (Vibelin's selected_accent). A pick the race and the culture do not have speaks the race's own.
/datum/preference/choiced/rogue_accent
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "rogue_accent"
	can_randomize = FALSE
	should_update_preview = FALSE

/datum/preference/choiced/rogue_accent/is_accessible(datum/preferences/preferences)
	return ..() && rogue_lobby_enabled()

/datum/preference/choiced/rogue_accent/init_possible_values()
	. = list(ROGUE_ACCENT_SPECIES, ROGUE_ACCENT_NONE)
	for(var/accent in GLOB.rogue_accents)
		. |= accent

/datum/preference/choiced/rogue_accent/create_default_value()
	return ROGUE_ACCENT_SPECIES

/datum/preference/choiced/rogue_accent/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.rogue_accent_choice = value
	target.RegisterSignal(target, COMSIG_MOB_SAY, TYPE_PROC_REF(/mob/living/carbon/human, rogue_accent_speech), override = TRUE)

/// The accents this character may pick besides the race's own and none: the race's others and the culture's.
/mob/living/carbon/human/proc/rogue_accent_options()
	. = list()
	for(var/accent in dna?.species?.rogue_accents)
		if(accent != ROGUE_ACCENT_NONE)
			. |= accent
	if(rogue_culture?.rogue_accent)
		. |= rogue_culture.rogue_accent

/// The accent this character speaks the language with, or null.
/mob/living/carbon/human/proc/rogue_spoken_accent(language)
	var/datum/species/species = dna?.species
	if(!species?.rogue_vibelin_type || rogue_accent_choice == ROGUE_ACCENT_NONE || !rogue_lobby_enabled())
		return null
	if(rogue_accent_choice != ROGUE_ACCENT_SPECIES && (rogue_accent_choice in rogue_accent_options()))
		return rogue_accent_choice
	if(language == species.rogue_native_language)
		return null
	return species.rogue_accent

/// Vibelin's handle_speech(): the words of the accent swapped where a word of what is said begins with them, as they are
/// written, capitalised and in capitals.
/mob/living/carbon/human/proc/rogue_accent_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER
	var/message = speech_args[SPEECH_MESSAGE]
	if(!message || message[1] == "*")
		return
	var/accent = rogue_spoken_accent(speech_args[SPEECH_LANGUAGE])
	var/list/source_file = accent && GLOB.rogue_accents[accent]
	if(!source_file)
		return
	var/list/words = strings(source_file[1], source_file[2], ROGUE_ACCENT_DIRECTORY)
	message = " [message]"
	for(var/key in words)
		var/value = words[key]
		if(islist(value))
			value = pick(value)
		message = replacetextEx(message, " [uppertext(key)]", " [uppertext(value)]")
		message = replacetextEx(message, " [capitalize(key)]", " [capitalize(value)]")
		message = replacetextEx(message, " [key]", " [value]")
	speech_args[SPEECH_MESSAGE] = trim(message)

/// The accents the edited character may pick, in the reader's language (ROGUE_LANG_*): the race's own (named after the
/// accent it is), none, the race's others and the culture's; null for a race without accents of Vibelin's.
/datum/rogue_charsetup/proc/accent_choices(lang)
	var/datum/species/species = GLOB.species_prototypes[prefs.read_preference(/datum/preference/choiced/species)]
	if(!species?.rogue_vibelin_type || !accessible(GLOB.preference_entries[/datum/preference/choiced/rogue_accent]))
		return null
	var/ru = (lang == ROGUE_LANG_RU)
	var/own = rogue_chargen_term(ru, species.rogue_accent || ROGUE_ACCENT_NONE)
	. = list(list("id" = ROGUE_ACCENT_SPECIES, "name" = "[rogue_chargen_term(ru, ROGUE_ACCENT_SPECIES)] ([own])"))
	var/list/accents = list(ROGUE_ACCENT_NONE)
	for(var/accent in species.rogue_accents)
		accents |= accent
	var/datum/culture/culture = GLOB.rogue_cultures[text2path(prefs.read_preference(/datum/preference/choiced/rogue_heritage/culture))]
	if(culture?.rogue_accent)
		accents |= culture.rogue_accent
	for(var/accent in accents)
		. += list(list("id" = accent, "name" = rogue_chargen_term(ru, accent)))

#undef ROGUE_ACCENT_SPECIES
#undef ROGUE_ACCENT_NONE
#undef ROGUE_ACCENT_DIRECTORY
