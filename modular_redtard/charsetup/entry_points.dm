/// Where TG opens its character preferences, medieval maps open the character menu instead: the lobby's "Character
/// Setup" button, the "Open Character Preferences" verb and the escape menu's character button. TG's menu stays for
/// the game preferences, the keybindings and, from the character menu, the loadout and quirks.

/datum/lobby_menu/rogue/on_message(type, payload, href_list)
	if(type != "action" || !islist(payload))
		return ..()
	if(payload["action"] == "character_setup")
		var/mob/dead/new_player/player = client?.mob
		if(istype(player) && !client.interviewee)
			client.prefs.rogue_charsetup().ui_interact(player)
		return TRUE
	. = ..()
	if(payload["action"] == "ready_toggle")
		rogue_charsetup_refresh_rounds()

/client/__gvb_open_character_preferences(list/structured_args)
	if(!rogue_lobby_enabled() || !prefs || !mob)
		return ..()
	prefs.rogue_charsetup().ui_interact(mob)

/datum/escape_menu/on_message(type, payload, href_list)
	if(type == "action" && islist(payload) && payload["action"] == "character" && rogue_lobby_enabled() && client?.prefs && client.mob)
		client.prefs.rogue_charsetup().ui_interact(client.mob)
		return TRUE
	return ..()
