/// Vibelin's character menu (modular_abel/character_setup: character_menu.dm, PreferencesMenu.tsx and its parts) for
/// medieval maps, on TG's preferences: the same savefile, the same preference datums and their checks, TG's feature
/// catalogs and spritesheets, a TG character preview in a map view. Vibelin's menu is a browser datum of its own
/// preferences system; here it is a tgui window (RogueCharacterSetup) over /datum/preferences, and TG's
/// PreferencesMenu stays as it is everywhere else (and for the loadout, quirks and keybindings).
///
/// The window gets everything that is the same for everyone once, as static data (catalog.dm); its data is only what
/// the player changes, pushed after each change and never on a timer: the values of the shown preferences, the job
/// priorities, the character slots and the lobby's round state (the countdown runs in the window).

/// The menus open right now, refreshed when someone readies up or the round starts.
GLOBAL_LIST_EMPTY(rogue_charsetup_open)

/datum/preferences
	/// The character menu of medieval maps, made when first opened.
	var/datum/rogue_charsetup/rogue_charsetup

/datum/preferences/proc/rogue_charsetup()
	if(!rogue_charsetup)
		rogue_charsetup = new(src)
	return rogue_charsetup

/datum/preferences/Destroy(force)
	QDEL_NULL(rogue_charsetup)
	return ..()

/// The doll of the menu's looking glass: a TG character preview of its own, so that TG's menu, if it is open too,
/// keeps its own.
/atom/movable/screen/map_view/char_preview/rogue_charsetup

/atom/movable/screen/map_view/char_preview/rogue_charsetup/Destroy()
	// TG's preview clears preferences.character_preview_view, which is TG's menu's preview, not this one.
	preferences = null
	return ..()

/datum/rogue_charsetup
	var/datum/preferences/prefs
	var/atom/movable/screen/map_view/char_preview/rogue_charsetup/preview

/datum/rogue_charsetup/New(datum/preferences/prefs)
	src.prefs = prefs

/datum/rogue_charsetup/Destroy()
	GLOB.rogue_charsetup_open -= src
	QDEL_NULL(preview)
	prefs = null
	return ..()

/datum/rogue_charsetup/ui_state(mob/user)
	return GLOB.always_state

/// As TG's preferences: only their owner may use them.
/datum/rogue_charsetup/ui_status(mob/user, datum/ui_state/state)
	return user.client == prefs?.parent ? UI_INTERACTIVE : UI_CLOSE

/datum/rogue_charsetup/ui_interact(mob/user, datum/tgui/ui)
	// TG's menu waits for IconForge and the spritesheets as well.
	if(SSearly_assets.initialized != INITIALIZATION_INNEW_REGULAR)
		to_chat(user, span_warning(rogue_ui_russian(user.client) ? "Меню персонажа ещё готовится, попробуйте через минуту." : "The character menu is still being prepared, try again in a moment."))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(ui)
		return
	QDEL_NULL(preview)
	var/static/map_count = 0
	preview = new(null, null, prefs)
	preview.generate_view("rogue_charsetup_[++map_count]_map")
	preview.update_body()
	ui = new(user, src, "RogueCharacterSetup", rogue_ui_russian(user.client) ? "Настройка персонажа" : "Character Setup")
	ui.set_autoupdate(FALSE)
	ui.open()
	preview.display_to(user, ui.window)
	GLOB.rogue_charsetup_open |= src
	RegisterSignal(SSticker, COMSIG_TICKER_ROUND_STARTING, PROC_REF(on_round_starting), override = TRUE)

/// As TG's menu: what was changed is saved when the window closes, and the doll goes.
/datum/rogue_charsetup/ui_close(mob/user)
	GLOB.rogue_charsetup_open -= src
	UnregisterSignal(SSticker, COMSIG_TICKER_ROUND_STARTING)
	stop_combat_music_preview(user)
	prefs?.save_character()
	prefs?.save_preferences()
	QDEL_NULL(preview)

/datum/rogue_charsetup/proc/on_round_starting()
	SIGNAL_HANDLER
	SStgui.update_uis(src)

/// TG's spritesheets: the preference icons (hair, underwear...) and the species portraits; and the foods and drinks of
/// the culinary picker (culinary.dm).
/datum/rogue_charsetup/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet_batched/preferences),
		get_asset_datum(/datum/asset/spritesheet_batched/species),
		get_asset_datum(/datum/asset/spritesheet_batched/rogue_culinary),
	)

/datum/rogue_charsetup/ui_static_data(mob/user)
	var/static/regex/markup = regex(@"<[^>]*>", "g")
	var/static/regex/rank_color = regex(@"color:\s*(#[0-9a-fA-F]+)")
	var/pq = rogue_get_pq(user.ckey)
	var/rank = rogue_pq_rank(pq)
	var/list/job_bans = list()
	for(var/datum/job/job as anything in SSjob.joinable_occupations)
		if(is_banned_from(user.ckey, job.title))
			job_bans += job.title
	var/lang = rogue_ui_lang(user.client)
	return list(
		"preview_view" = preview?.assigned_map,
		"species" = rogue_charsetup_species_catalog(lang),
		"features" = rogue_charsetup_feature_catalog(),
		"jobs" = rogue_charsetup_job_catalog(),
		"job_bans" = job_bans,
		"ages" = rogue_charsetup_age_catalog(lang),
		"heritage" = rogue_charsetup_heritage_catalog(lang),
		"homelands" = rogue_charsetup_homeland_catalog(lang),
		"culinary" = rogue_charsetup_culinary_catalog(lang),
		"combat_music" = rogue_charsetup_combat_music_catalog(),
		"max_slots" = prefs.max_save_slots,
		"flavor_min" = CONFIG_GET(number/rogue_minimum_flavor_text),
		"ooc_min" = CONFIG_GET(number/rogue_minimum_ooc_notes),
		"pq" = pq,
		"pq_rank" = markup.Replace(rank, ""),
		"pq_color" = rank_color.Find(rank) ? rank_color.group[1] : null,
		"triumphs" = rogue_get_triumphs(user.ckey),
	)

/datum/rogue_charsetup/ui_data(mob/user)
	return list(
		"lang" = rogue_ui_lang(user.client),
		"heritage_species" = heritage_species(),
		"active_slot" = prefs.default_slot,
		"profiles" = prefs.create_character_profiles(),
		"character_preferences" = compile_preferences(user),
		"job_preferences" = prefs.job_preferences,
		"job_clothes" = preview ? preview.show_job_clothes : TRUE,
		"round" = round_state(user),
	)

/// The values of the shown preferences the player can use now (TG's compile_character_preferences, in TG's shape, so
/// TG's feature components read them as in TG's menu).
/datum/rogue_charsetup/proc/compile_preferences(mob/user)
	var/list/out = list()
	var/list/shown = rogue_charsetup_shown_preferences()
	for(var/key in shown)
		var/datum/preference/preference = shown[key]
		if(!accessible(preference))
			continue
		var/category = preference.savefile_identifier == PREFERENCE_PLAYER ? PREFERENCE_CATEGORY_GAME_PREFERENCES : preference.category
		var/list/values = out[category]
		if(!values)
			values = list()
			out[category] = values
		values[key] = preference.compile_ui_data(user, prefs.read_preference(preference.type))
	return out

/// TG's is_accessible() also asks which page of TG's menu is open (character or game); this menu shows both, so it
/// asks as if the matching page were open, and puts TG's page back.
/datum/rogue_charsetup/proc/accessible(datum/preference/preference)
	var/old_window = prefs.current_window
	prefs.current_window = preference.savefile_identifier == PREFERENCE_CHARACTER ? PREFERENCE_TAB_CHARACTER_PREFERENCES : PREFERENCE_TAB_GAME_PREFERENCES
	. = preference.is_accessible(prefs)
	prefs.current_window = old_window

/// TG's update_preference() with this menu's accessibility (above) and its own doll: the same validation, the same
/// cache and pending save, the client applies a player preference at once.
/datum/rogue_charsetup/proc/update_preference(datum/preference/preference, value)
	if(!accessible(preference))
		return FALSE
	var/new_value = preference.deserialize(value, prefs)
	if(!preference.write(null, new_value, prefs))
		return FALSE
	prefs.recently_updated_keys |= preference.type
	prefs.value_cache[preference.type] = new_value
	if(preference.savefile_identifier == PREFERENCE_PLAYER)
		preference.apply_to_client_updated(prefs.parent, prefs.read_preference(preference.type))
		SStgui.update_uis(prefs)
	else if(preference.should_update_preview)
		refresh_preview()
	else
		SStgui.update_uis(prefs)
	return TRUE

/// Redraws both dolls and lets TG's menu, if it is open too, show the change.
/datum/rogue_charsetup/proc/refresh_preview()
	prefs.character_preview_view?.update_body()
	preview?.update_body()
	SStgui.update_uis(prefs)

/// The lobby's round as Vibelin's "Round Start" box shows it; only for a player in the lobby.
/datum/rogue_charsetup/proc/round_state(mob/user)
	var/mob/dead/new_player/player = user
	if(!istype(player) || !SSticker)
		return null
	var/phase
	switch(SSticker.current_state)
		if(GAME_STATE_STARTUP, GAME_STATE_PREGAME)
			phase = "pregame"
		if(GAME_STATE_SETTING_UP)
			phase = "setting_up"
		if(GAME_STATE_PLAYING)
			phase = "playing"
		else
			phase = "postgame"
	var/time_left = SSticker.GetTimeLeft()
	var/seconds = 0
	if(time_left > 0)
		seconds = round(time_left / 10)
	else if(time_left == -10)
		seconds = -1
	return list(
		"phase" = phase,
		"seconds" = seconds,
		"ready" = player.ready == PLAYER_READY_TO_PLAY,
		"ready_count" = SSticker.totalPlayersReady,
		"players" = length(GLOB.clients),
		"migrant" = !!prefs.rogue_migrant?.queued_wave,
	)

/datum/rogue_charsetup/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = ui.user
	switch(action)
		if("set_preference")
			return set_preference(user, params["preference"], params["value"])
		if("set_color_preference")
			if(!istext(params["preference"]))
				return FALSE
			var/list/shown = rogue_charsetup_shown_preferences()
			var/datum/preference/color/preference = shown[params["preference"]]
			if(!istype(preference))
				return FALSE
			var/new_color = tgui_color_picker(user, rogue_ui_russian(user.client) ? "Выберите цвет" : "Select new color", null, prefs.read_preference(preference.type) || COLOR_WHITE)
			if(!new_color || QDELETED(src))
				return FALSE
			return update_preference(preference, new_color)
		if("randomize_name")
			var/datum/preference/name/real_name = GLOB.preference_entries[/datum/preference/name/real_name]
			if(!update_preference(real_name, real_name.create_random_value(prefs)))
				return FALSE
			prefs.tainted_character_profiles = TRUE
			return TRUE
		if("randomize_appearance")
			randomize_appearance()
			return TRUE
		if("set_job_preference")
			return set_job_preference(params["job"], params["level"])
		if("select_faith")
			return select_faith(params["faith"])
		if("select_patron")
			return select_patron(params["patron"])
		if("listen_combat_music")
			return preview_combat_music(user, params["track"])
		if("stop_combat_music")
			return stop_combat_music_preview(user)
		if("rotate")
			preview?.setDir(turn(preview.dir, params["dir"] == "left" ? 90 : -90))
			return FALSE
		if("toggle_job_clothes")
			if(!preview)
				return FALSE
			preview.show_job_clothes = !preview.show_job_clothes
			preview.update_body()
			return TRUE
		if("change_slot")
			return change_slot(user, params["slot"])
		if("undo")
			prefs.load_character()
			prefs.tainted_character_profiles = TRUE
			refresh_preview()
			return TRUE
		if("save")
			prefs.save_character()
			prefs.save_preferences()
			to_chat(user, span_notice(rogue_ui_russian(user.client) ? "Персонаж сохранён." : "Your character is saved."))
			return FALSE
		if("done")
			ui.close()
			return FALSE
		if("round_action")
			return round_action(user)
		if("open_tg")
			return open_tg_menu(user, params["page"])
		if("open_triumph_shop")
			GLOB.rogue_triumph_shop.ui_interact(user)
			return FALSE
	return FALSE

/// TG's set_preference action: the middlewares first (the quirks one asks before a species change drops quirks), then
/// the update and the middlewares after it. Only what the menu shows can be set.
/datum/rogue_charsetup/proc/set_preference(mob/user, key, value)
	if(!istext(key))
		return FALSE
	var/list/shown = rogue_charsetup_shown_preferences()
	var/datum/preference/preference = shown[key]
	if(!istype(preference))
		return FALSE
	for(var/datum/preference_middleware/middleware as anything in prefs.middleware)
		if(middleware.pre_set_preference(user, key, value))
			return TRUE
	if(QDELETED(src) || !update_preference(preference, value))
		return FALSE
	if(istype(preference, /datum/preference/name))
		prefs.tainted_character_profiles = TRUE
	for(var/datum/preference_middleware/middleware as anything in prefs.middleware)
		middleware.post_set_preference(user, key, value)
	return TRUE

/// Vibelin's "Randomise Appearance": new random looks for the appearance preferences the species has, keeping the
/// name, species, gender, age and texts (TG's randomise_appearance_prefs() would clear the flavor text too).
/datum/rogue_charsetup/proc/randomize_appearance()
	var/static/list/appearance = list(
		PREFERENCE_CATEGORY_FEATURES,
		PREFERENCE_CATEGORY_CLOTHING,
		PREFERENCE_CATEGORY_SECONDARY_FEATURES,
		PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES,
	)
	var/list/shown = rogue_charsetup_shown_preferences()
	for(var/key in shown)
		var/datum/preference/preference = shown[key]
		if(!(preference.category in appearance) || !preference.is_randomizable() || !accessible(preference))
			continue
		prefs.write_preference(preference, preference.create_random_value(prefs))
	refresh_preview()

/// TG's jobs middleware: a priority for a role the lobby offers, or null for never.
/datum/rogue_charsetup/proc/set_job_preference(job_title, level)
	if(!isnull(level) && level != JP_LOW && level != JP_MEDIUM && level != JP_HIGH)
		return FALSE
	var/datum/job/job = SSjob.get_job(job_title)
	if(isnull(job) || job.faction != FACTION_STATION || !(job in SSjob.joinable_occupations))
		return FALSE
	if(!prefs.set_job_preference_level(job, level))
		return FALSE
	refresh_preview()
	return TRUE

/// TG's switch_to_slot() with this menu's doll (TG's redraws its own preview, which is not there when its menu is shut).
/datum/rogue_charsetup/proc/change_slot(mob/user, slot)
	if(!isnum(slot) || slot == prefs.default_slot)
		return FALSE
	prefs.save_character()
	if(!prefs.load_character(slot))
		prefs.randomise_appearance_prefs()
		prefs.all_quirks = list()
		prefs.recently_updated_keys |= /datum/preference/name/real_name
		prefs.save_character()
	prefs.tainted_character_profiles = TRUE
	for(var/datum/preference_middleware/middleware as anything in prefs.middleware)
		middleware.on_new_character(user)
	refresh_preview()
	return TRUE

/// Vibelin's round button: ready up (or stand down) before the round, join once it runs. It goes through the lobby
/// menu, so the medieval lobby's rules apply (the flavor text and OOC notes, the late join wait, the migrant queue).
/datum/rogue_charsetup/proc/round_action(mob/user)
	var/mob/dead/new_player/player = user
	var/datum/lobby_menu/lobby = prefs.parent?.lobby_menu
	if(!istype(player) || !lobby || !SSticker)
		return FALSE
	var/lobby_action
	switch(SSticker.current_state)
		if(GAME_STATE_STARTUP, GAME_STATE_PREGAME)
			lobby_action = "ready_toggle"
		if(GAME_STATE_SETTING_UP, GAME_STATE_PLAYING)
			lobby_action = "join"
	if(!lobby_action)
		return FALSE
	lobby.on_message("action", list("action" = lobby_action))
	return TRUE

/// TG's menu for what this one leaves to it: the loadout and quirks (its character page) and the keybindings.
/datum/rogue_charsetup/proc/open_tg_menu(mob/user, page)
	switch(page)
		if("character")
			prefs.current_window = PREFERENCE_TAB_CHARACTER_PREFERENCES
		if("keybindings")
			prefs.current_window = PREFERENCE_TAB_KEYBINDINGS
		else
			return FALSE
	prefs.update_static_data(user)
	prefs.ui_interact(user)
	return FALSE

/// Pushes the round state to every open menu (a ready toggle changes the count everyone sees).
/proc/rogue_charsetup_refresh_rounds()
	for(var/datum/rogue_charsetup/menu as anything in GLOB.rogue_charsetup_open)
		SStgui.update_uis(menu)
