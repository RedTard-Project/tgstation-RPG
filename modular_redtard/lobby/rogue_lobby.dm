/// The main menu of medieval maps: TG's lobby menu (code/modules/lobby_menu: a browser over the title screen, its own
/// tgui-lobby bundle, messages through a tgui_window) as it is, with Azure Peak's lobby beside it (Azure
/// new_player_panel.dm, subsystem/lobby.dm, NewPlayerPanel.tsx): the welcome, the character one plays as, the classes
/// the ready players took, keybindings, and Azure's wait before late joining. It runs its own bundle,
/// tgui-rogue-lobby (modular_redtard/tgui/rogue_lobby), which draws TG's LobbyMenu unchanged and Azure's panel over it;
/// the module build makes it. The title screen moves there: a browser only gets the first frame of a DMI, so the menu plays
/// a WebP of its own over TG's still picture. On other maps TG's lobby runs untouched.

/// TG's LOBBY_TITLE_ASSET_NAME (code/modules/lobby_menu/lobby_menu.dm undefines it after itself): the title screen picture.
#define ROGUE_LOBBY_TITLE_ASSET "lobby_title_screen.png"

/// Minutes after the round starts before anyone may join late (Azure timetojoin); 0 lets them join at once.
/datum/config_entry/number/rogue_latejoin_delay
	default = 0
	integer = TRUE
	min_val = 0

/proc/rogue_lobby_enabled()
	return rogue_combat_enabled()

/// TG's start of the lobby menu, with the medieval one in its place on medieval maps.
/client/initialize_lobby_menu()
	set waitfor = FALSE
	if(!rogue_lobby_enabled())
		return ..()
	register_lobby_title_asset()
	UNTIL(SSassets.transport.get_asset_url(ROGUE_LOBBY_TITLE_ASSET))
	if(!src)
		return
	lobby_menu = new /datum/lobby_menu/rogue(src)

/// Azure's lobby fonts: MedievalSharp for the panel, Parisienne and its stroke data for the handwritten welcome (tegaki).
/datum/asset/simple/namespaced/rogue_lobby_font
	assets = list(
		"medievalsharp.ttf" = file("modular_redtard/lobby/medievalsharp.ttf"),
		"parisienne.ttf" = file("modular_redtard/lobby/parisienne.ttf"),
		"parisienne_data.json" = file("modular_redtard/lobby/parisienne_data.json"),
	)
	parents = list(
		"rogue_lobby_fonts.css" = file("modular_redtard/tgui/rogue_lobby/rogue_lobby_fonts.css"),
	)

/// The title screen in motion. The browser plays it in its own process, so the game client spends nothing on the frames,
/// and BYOND sends it once: browse_rsc transmits nothing the client's cache already has.
/datum/asset/simple/rogue_lobby_title
	assets = list(
		"rogue_lobby_title.webp" = file("modular_redtard/lobby/rogue_lobby_title.webp"),
	)

/datum/lobby_menu/rogue

/// TG only hides the page. The moving title leaves with the lobby, so that it costs nothing during the round.
/datum/lobby_menu/rogue/update_visibility()
	. = ..()
	if(!rogue_in_lobby())
		send_update(list("inLobby" = FALSE))

/datum/lobby_menu/rogue/proc/rogue_in_lobby()
	return istype(client?.mob, /mob/dead/new_player) && !client.interviewee

/// TG's assets (our bundle draws TG's menu), Azure's font and the moving title, with our bundle in place of tgui-lobby.
/// The title goes last: it is the biggest and the menu does not wait for it.
/datum/lobby_menu/rogue/initialize_browser()
	window.initialize(
		strict_mode = TRUE,
		inline_css = file("tgui/public/tgui-rogue-lobby.bundle.css"),
		inline_js = file("tgui/public/tgui-rogue-lobby.bundle.js"),
	)
	window.send_asset(get_asset_datum(/datum/asset/simple/namespaced/lobby_menu_font))
	window.send_asset(get_asset_datum(/datum/asset/simple/namespaced/lobby_menu_sounds))
	window.send_asset(get_asset_datum(/datum/asset/simple/namespaced/lobby_menu_icons))
	window.send_asset(get_asset_datum(/datum/asset/simple/namespaced/rogue_lobby_font))
	SSassets.transport.send_assets(client, ROGUE_LOBBY_TITLE_ASSET)
	window.send_asset(get_asset_datum(/datum/asset/simple/rogue_lobby_title))

/datum/lobby_menu/rogue/send_init()
	. = ..()
	send_update(rogue_state(full = TRUE))

/datum/lobby_menu/rogue/process(seconds_per_tick)
	. = ..()
	send_update(rogue_state())

/// What Azure's panel shows beside TG's menu: the server's name, the character the player plays as, the classes; and
/// whether the title plays.
/datum/lobby_menu/rogue/proc/rogue_state(full = FALSE)
	. = list(
		"activeCharacter" = client?.prefs?.read_preference(/datum/preference/name/real_name),
		"readyJobs" = rogue_ready_jobs(),
		"migrantQueued" = !!client?.prefs?.rogue_migrant?.queued_wave,
	)
	if(full)
		.["serverName"] = CONFIG_GET(string/servername) || world.name
		.["inLobby"] = rogue_in_lobby()

/datum/lobby_menu/rogue/on_message(type, payload, href_list)
	if(type != "action")
		return ..()
	var/mob/dead/new_player/player = client?.mob
	switch(payload["action"])
		if("keybindings")
			if(istype(player) && !client.interviewee)
				var/datum/preferences/prefs = client.prefs
				prefs.current_window = PREFERENCE_TAB_KEYBINDINGS
				prefs.update_static_data(player)
				prefs.ui_interact(player)
			return TRUE
		if("migrants")
			if(istype(player))
				client.prefs.rogue_migrant().ui_interact(player)
			return TRUE
		if("ready_toggle")
			if(istype(player) && player.ready == PLAYER_NOT_READY && rogue_ready_blocked(player))
				send_update(list("isReady" = FALSE))
				return TRUE
		if("join")
			if(client?.prefs?.rogue_migrant?.queued_wave)
				to_chat(player, span_boldwarning("You are in the migrant queue."))
				return TRUE
			if(istype(player) && (rogue_latejoin_wait(player) || rogue_patron_join(player)))
				return TRUE
	return ..()

/// Azure keeps late joiners out for the first minutes of the round; the player is told how long is left.
/datum/lobby_menu/rogue/proc/rogue_latejoin_wait(mob/dead/new_player/player)
	var/delay = CONFIG_GET(number/rogue_latejoin_delay) MINUTES
	if(!delay || !SSticker.round_start_time)
		return FALSE
	var/left = SSticker.round_start_time + delay - world.time
	if(left <= 0)
		return FALSE
	var/static/list/excuses = list("Not yet.", "You cannot join yet.", "It won't work yet.", "Please be patient.", "Try again later.", "Late-joining is not yet possible.")
	to_chat(player, span_warning("[pick(excuses)] ([round(left / 10)])."))
	return TRUE

/// Azure's classes list (SSlobbymenu): the ready players by the role they want most, the wanderers' roles counted together
/// and some roles only counted. Built once a tick for every open lobby.
/proc/rogue_ready_jobs()
	var/static/list/wanderer_jobs = list("Adventurer", "Wretch", "Court Agent")
	var/static/list/count_only_jobs = list("Hag")
	var/static/list/built = list()
	var/static/built_at = -1
	if(built_at == world.time)
		return built
	built_at = world.time
	var/list/by_job = list()
	for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
		if(player.ready != PLAYER_READY_TO_PLAY || !player.client?.prefs)
			continue
		var/list/wanted = player.client.prefs.job_preferences
		for(var/title in wanted)
			if(wanted[title] != JP_HIGH)
				continue
			var/shown = (title in wanderer_jobs) ? "Wanderer" : title
			LAZYADD(by_job[shown], player.client.prefs.read_preference(/datum/preference/name/real_name))
			break
	built = list()
	for(var/title in by_job)
		var/list/names = by_job[title]
		built += list(list(
			"name" = title,
			"length" = length(names),
			"players" = (title in count_only_jobs) ? null : jointext(names, ", "),
		))
	return built

#undef ROGUE_LOBBY_TITLE_ASSET
