/// Character names in Russian cases (Vibelin's declension_prefs.dm, declension_registry.dm). A Russian chat line wants
/// "кусает Ивана", not "кусает Иван", and a name cannot be declined by rule, so the player writes their own five cases;
/// a blank case falls back to the name as it is. Each character's cases go to every open panel when they spawn.

#define ROGUE_DECLENSION_MAX_LENGTH 128

/// Cases by character name, for the panels that open later.
GLOBAL_LIST_EMPTY(rogue_chat_declensions)

/datum/preference/text/rogue_declension
	abstract_type = /datum/preference/text/rogue_declension
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE
	should_update_preview = FALSE
	maximum_value_length = ROGUE_DECLENSION_MAX_LENGTH
	/// The case this field holds, as the panel names it.
	var/case_key

/// Chat data only, read by rogue_read_declensions(): nothing goes on the body.
/datum/preference/text/rogue_declension/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return

/datum/preference/text/rogue_declension/genitive
	savefile_key = "rogue_declension_genitive"
	case_key = "gen"

/datum/preference/text/rogue_declension/dative
	savefile_key = "rogue_declension_dative"
	case_key = "dat"

/datum/preference/text/rogue_declension/accusative
	savefile_key = "rogue_declension_accusative"
	case_key = "acc"

/datum/preference/text/rogue_declension/instrumental
	savefile_key = "rogue_declension_instrumental"
	case_key = "ins"

/datum/preference/text/rogue_declension/prepositional
	savefile_key = "rogue_declension_prepositional"
	case_key = "pre"

/datum/preferences/proc/rogue_read_declensions()
	. = list()
	for(var/datum/preference/text/rogue_declension/field as anything in subtypesof(/datum/preference/text/rogue_declension))
		var/value = trim(read_preference(field))
		if(value)
			.[initial(field.case_key)] = value

/proc/rogue_register_declensions(name, list/cases)
	if(!name || !length(cases) || (GLOB.rogue_chat_declensions[name] ~= cases))
		return
	GLOB.rogue_chat_declensions[name] = cases
	// The server's dictionaries (translate.dm) decline names too.
	rogue_dictionaries_forget()
	var/list/delta = list("[name]" = cases)
	for(var/client/target as anything in GLOB.clients)
		target.tgui_panel?.rogue_send_declensions(delta)

/datum/preferences/apply_prefs_to(mob/living/carbon/human/character, icon_updates = TRUE, list/do_not_apply)
	. = ..()
	if(!QDELETED(character))
		rogue_register_declensions(character.real_name, rogue_read_declensions())

#undef ROGUE_DECLENSION_MAX_LENGTH
