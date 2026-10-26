/// Ratwood's triumphs (controllers/subsystem/rogue/triumphs): points a player keeps from round to round, in Ratwood's own
/// files (triumphs.json in data/player_saves/<c>/<ckey>/, the season in data/triumph_wipe_season.json), so saves brought
/// over from a Ratwood server keep them. A wipe starts a new season, and a file from an older season counts as none.
/// Here are only the count and its change; what triumphs buy is the triumphs stage.

/// The current season, read once.
/proc/rogue_triumph_season()
	var/static/season
	if(isnull(season))
		var/list/json = fexists("data/triumph_wipe_season.json") ? json_decode(file2text("data/triumph_wipe_season.json")) : null
		season = islist(json) && isnum(json["current_wipe_season"]) ? json["current_wipe_season"] : 1
	return season

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
		var/list/json = json_decode(file2text(path))
		if(islist(json) && isnum(json["triumph_count"]) && json["triumph_wipe_season"] >= rogue_triumph_season())
			count = json["triumph_count"]
	GLOB.rogue_triumph_counts[ckey] = count
	return count

/// Adds triumphs to a player (never below none) and saves them; returns the new count.
/proc/rogue_adjust_triumphs(ckey, amount)
	ckey = ckey(ckey)
	if(!ckey)
		return 0
	var/count = max(0, rogue_get_triumphs(ckey) + amount)
	GLOB.rogue_triumph_counts[ckey] = count
	var/path = rogue_player_save_path(ckey, "triumphs.json")
	fdel(path)
	text2file(json_encode(list("triumph_count" = count, "triumph_wipe_season" = rogue_triumph_season())), path)
	var/client/player = GLOB.directory[ckey]
	if(player && amount)
		to_chat(player, "<font color='purple'>[abs(amount)] TRIUMPH(S) [amount > 0 ? "awarded" : "lost"].</font>")
	return count
