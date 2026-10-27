/// The player's language (Vibelin's _localization.dm): Russian by default, as on Vibelin. Russian translates the chat
/// in the panel and the texts the server resolves per player (examine, character setup); English shows the game as it is.
/datum/preference/choiced/rogue_ui_language
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_identifier = PREFERENCE_PLAYER
	savefile_key = "rogue_ui_language"
	can_randomize = FALSE

/datum/preference/choiced/rogue_ui_language/init_possible_values()
	return list(ROGUE_LANGUAGE_RUSSIAN, ROGUE_LANGUAGE_ENGLISH)

/datum/preference/choiced/rogue_ui_language/create_default_value()
	return ROGUE_LANGUAGE_RUSSIAN

/// The chat panel and the open character menu switch at once (the menu's catalogs are its static data).
/datum/preference/choiced/rogue_ui_language/apply_to_client(client/client, value)
	client?.tgui_panel?.rogue_send_language()
	if(client?.mob && client.prefs?.rogue_charsetup)
		client.prefs.rogue_charsetup.update_static_data(client.mob)

/// ROGUE_LANG_RU or ROGUE_LANG_EN for this player; Russian when they have no preferences yet.
/proc/rogue_ui_lang(client/target)
	if(target?.prefs?.read_preference(/datum/preference/choiced/rogue_ui_language) == ROGUE_LANGUAGE_ENGLISH)
		return ROGUE_LANG_EN
	return ROGUE_LANG_RU

/// TRUE when this player reads Russian.
/proc/rogue_ui_russian(client/target)
	return rogue_ui_lang(target) == ROGUE_LANG_RU

GAME_VERB_DESC(/client, rogue_toggle_ui_language, "Язык / Language", "Переключить язык чата и интерфейса (RU/EN) / Switch the chat and interface language", "OOC")
	if(!prefs)
		return
	var/new_language = rogue_ui_russian(src) ? ROGUE_LANGUAGE_ENGLISH : ROGUE_LANGUAGE_RUSSIAN
	prefs.update_preference(GLOB.preference_entries[/datum/preference/choiced/rogue_ui_language], new_language)
	prefs.save_preferences()
	SStgui.update_uis(prefs)
	to_chat(src, span_notice("Язык: [new_language] / Language: [new_language]"))
