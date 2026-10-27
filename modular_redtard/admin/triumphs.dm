/// Ratwood's triumphs (controllers/subsystem/rogue/triumphs): points a player keeps from round to round, in Ratwood's own
/// files (triumphs.json in data/player_saves/<c>/<ckey>/, the season in data/triumph_wipe_season.json, the leaderboard of
/// each season in data/triumph_leaderboards/), so saves brought over from a Ratwood server keep them. A new season wipes
/// everyone: a file from an older season counts as none. In the first season a player without a file inherits Ratwood's
/// older table (data/triumphs.json). What triumphs are earned and spent on is in triumphs/.

/// The current season; read from its file once.
GLOBAL_VAR(rogue_triumph_season)

/proc/rogue_triumph_season()
	if(isnull(GLOB.rogue_triumph_season))
		var/list/json = rogue_read_json(rogue_shared_data_path("triumph_wipe_season.json"))
		GLOB.rogue_triumph_season = isnum(json["current_wipe_season"]) ? json["current_wipe_season"] : 1
	return GLOB.rogue_triumph_season

/// Triumphs read from the files, by ckey: each player's file is read once a round.
GLOBAL_LIST_EMPTY(rogue_triumph_counts)

/proc/rogue_get_triumphs(ckey)
	ckey = ckey(ckey)
	if(!ckey)
		return 0
	if(!isnull(GLOB.rogue_triumph_counts[ckey]))
		return GLOB.rogue_triumph_counts[ckey]
	var/count = 0
	var/path = rogue_player_save_path(ckey, "triumphs.json")
	if(fexists(path))
		var/list/json = rogue_read_json(path)
		if(isnum(json["triumph_count"]) && json["triumph_wipe_season"] >= rogue_triumph_season())
			count = json["triumph_count"]
	else if(rogue_triumph_season() <= 1)
		count = rogue_legacy_triumphs(ckey)
	GLOB.rogue_triumph_counts[ckey] = count
	return count

/// Ratwood's triumphs from before its seasons, by key (get_legacy_triumph_value()); only the first season inherits them.
/proc/rogue_legacy_triumphs(ckey)
	var/static/list/legacy
	if(isnull(legacy))
		legacy = list()
		var/list/json = rogue_read_json(rogue_shared_data_path("triumphs.json"))
		for(var/key in json)
			if(istext(key) && isnum(json[key]))
				legacy[ckey(key)] = json[key]
	return legacy[ckey] || 0

/// Adds triumphs to a player (never below none) and saves them; returns the new count. The leaderboard and the open
/// triumph windows follow.
/proc/rogue_adjust_triumphs(ckey, amount)
	ckey = ckey(ckey)
	if(!ckey)
		return 0
	var/count = max(0, rogue_get_triumphs(ckey) + amount)
	GLOB.rogue_triumph_counts[ckey] = count
	rogue_write_json(rogue_player_save_path(ckey, "triumphs.json"), list("triumph_count" = count, "triumph_wipe_season" = rogue_triumph_season()))
	rogue_triumph_board_update(ckey, count)
	var/client/player = GLOB.directory[ckey]
	if(player && amount)
		to_chat(player, "<font color='purple'>[abs(amount)] TRIUMPH(S) [amount > 0 ? "awarded" : "lost"].</font>")
	SStgui.update_uis(GLOB.rogue_triumph_shop)
	return count

/// Starts a new season (Ratwood wipe_all_triumphs()): everyone's triumphs count as none from now on, and the leaderboard
/// starts empty. The files of the old season stay.
/proc/rogue_triumph_new_season()
	GLOB.rogue_triumph_season = rogue_triumph_season() + 1
	rogue_write_json(rogue_shared_data_path("triumph_wipe_season.json"), list("current_wipe_season" = GLOB.rogue_triumph_season))
	GLOB.rogue_triumph_counts = list()
	GLOB.rogue_triumph_board = list()
	log_game("Triumphs: season [GLOB.rogue_triumph_season] began.")
	GLOB.rogue_triumph_shop.season_changed()

/// The leaderboard of the current season (Ratwood triumph_leaderboard): player key -> triumphs, most first.
GLOBAL_LIST(rogue_triumph_board)

/proc/rogue_triumph_board_path(season)
	return rogue_shared_data_path("triumph_leaderboards/triumphs_leaderboard_season_[season].json")

/// The leaderboard of a season; the current one when none is named.
/proc/rogue_triumph_board(season)
	if(season && season != rogue_triumph_season())
		return rogue_read_triumph_board(season)
	if(isnull(GLOB.rogue_triumph_board))
		GLOB.rogue_triumph_board = rogue_read_triumph_board(rogue_triumph_season())
	return GLOB.rogue_triumph_board

/proc/rogue_read_triumph_board(season)
	var/list/board = list()
	var/list/json = rogue_read_json(rogue_triumph_board_path(season))
	for(var/key in json)
		if(istext(key) && isnum(json[key]))
			board[key] = json[key]
	return sortTim(board, GLOBAL_PROC_REF(cmp_numeric_dsc), associative = TRUE)

/// Puts a player's new count on the leaderboard (Ratwood adjust_leaderboard()): only the best triumph_board_size players
/// with at least triumph_board_min triumphs are on it. Written to its file whenever it changes.
/proc/rogue_triumph_board_update(ckey, count)
	var/list/board = rogue_triumph_board()
	var/key = GLOB.directory[ckey]?.key
	var/was_listed = FALSE
	for(var/listed in board)
		if(ckey(listed) == ckey)
			key ||= listed
			board -= listed
			was_listed = TRUE
			break
	key ||= ckey
	if(count >= rogue_value("triumph_board_min"))
		board[key] = count
		sortTim(board, GLOBAL_PROC_REF(cmp_numeric_dsc), associative = TRUE)
		var/size = rogue_value("triumph_board_size")
		if(length(board) > size)
			board.Cut(size + 1)
	if(was_listed || (key in board))
		rogue_write_json(rogue_triumph_board_path(rogue_triumph_season()), board)

ADMIN_VERB(rogue_admin_new_triumph_season, R_ADMIN, "Triumphs - New Season", "Wipe everyone's triumphs and start a new season of the leaderboard.", ADMIN_CATEGORY_ROGUE)
	if(tgui_alert(user, "Start triumph season [rogue_triumph_season() + 1]? Everyone's triumphs go back to none. The old leaderboard stays on record.", "New Season", list("Yes", "No")) != "Yes")
		return
	rogue_triumph_new_season()
	message_admins("[key_name_admin(user)] started triumph season [rogue_triumph_season()].")
	log_admin("[key_name(user)] started triumph season [rogue_triumph_season()].")
	BLACKBOX_LOG_ADMIN_VERB("Triumphs New Season")
