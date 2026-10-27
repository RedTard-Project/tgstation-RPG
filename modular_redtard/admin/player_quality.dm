/// Ratwood's player quality (code/modules/admin/playerquality.dm): a number per player, from -100 to 500, that admins raise
/// and lower with a reason, that commendations of other players and the round contributor points of a role raise, and
/// that the roles ask for (triumphs/roles.dm). It lives beside the player's preferences in Ratwood's own files (pq_num.json,
/// the log playerquality.txt, commends.json and rcp.json in data/player_saves/<c>/<ckey>/; data/roundsplayed.json), so
/// saves brought over from a Ratwood server keep it.

#define ROGUE_PQ_FLOOR -100
#define ROGUE_PQ_CAP 500

/// A file of the server's own records. Every record of PQ, triumphs and their tables is reached through this proc or
/// rogue_player_save_path(), so moving them out of data/ is one change here.
/proc/rogue_shared_data_path(file_name)
	return "data/[file_name]"

/// A file of the player's own folder, where TG keeps their preferences.
/proc/rogue_player_save_path(ckey, file_name)
	ckey = ckey(ckey)
	return rogue_shared_data_path("player_saves/[copytext(ckey, 1, 2)]/[ckey]/[file_name]")

/// A JSON object read from a record; an empty list when the file is missing or broken.
/proc/rogue_read_json(path)
	if(!fexists(path))
		return list()
	var/list/json = safe_json_decode(file2text(path))
	return islist(json) ? json : list()

/proc/rogue_write_json(path, list/data)
	fdel(path)
	text2file(json_encode(data), path)

/// Whether the server has ever seen this player: TG writes their preferences on their first connection.
/proc/rogue_player_known(ckey)
	return ckey(ckey) && fexists(rogue_player_save_path(ckey, "preferences.json"))

/// PQ read from the files, by ckey: each player's file is read once a round (the roles ask for it many times at roundstart).
GLOBAL_LIST_EMPTY(rogue_pq_cache)

/proc/rogue_get_pq(ckey)
	ckey = ckey(ckey)
	if(!ckey)
		return 0
	if(isnull(GLOB.rogue_pq_cache[ckey]))
		var/list/json = rogue_read_json(rogue_player_save_path(ckey, "pq_num.json"))
		GLOB.rogue_pq_cache[ckey] = isnum(json[ckey]) ? json[ckey] : 0
	return GLOB.rogue_pq_cache[ckey]

/// Ratwood's steps of PQ, highest first: the least PQ of the step, its name, its colour (null for plain text).
GLOBAL_LIST_INIT(rogue_pq_ranks, list(
	list(500, "ASCENDANT", "#FFD700"),
	list(440, "UNDYING", "#B0C4DE"),
	list(375, "DIVINE", "#9B59B6"),
	list(310, "EXALTED", "#E8D44D"),
	list(250, "RENOWNED", "#5DADE2"),
	list(200, "FABLED", "#52BE80"),
	list(160, "STORIED", "#45B39D"),
	list(130, "PROVEN", "#4CAF50"),
	list(100, "VALE DWELLER", "#617C46"),
	list(70, "Magnificent!", "#00ff00"),
	list(50, "Exceptional!", "#00ff00"),
	list(30, "Great!", "#47b899"),
	list(10, "Good!", "#69c975"),
	list(5, "Nice", "#58a762"),
	list(-4, "Normal", null),
	list(-30, "Poor", "#be6941"),
	list(-70, "Terrible", "#cd4232"),
	list(-99, "Abysmal", "#e2221d"),
	list(-INFINITY, "Shitter", "#ff00ff"),
))

/// The step of PQ a number falls on: list(least PQ, name, colour).
/proc/rogue_pq_rank_step(pq)
	for(var/list/rank as anything in GLOB.rogue_pq_ranks)
		if(pq >= rank[1])
			return rank
	return GLOB.rogue_pq_ranks[length(GLOB.rogue_pq_ranks)]

/// Ratwood's names for the steps of PQ, as the admin panels show them.
/proc/rogue_pq_rank(pq)
	var/list/rank = rogue_pq_rank_step(pq)
	return rank[3] ? "<span style='color: [rank[3]];'>[rank[2]]</span>" : rank[2]

/// Changes a player's PQ and writes the change into their log; an amount of 0 with a reason is a note. The player is told
/// when an admin changed it and they are online. A change with neither admin nor reason (commendations, round points) is
/// not logged, as in Ratwood.
/proc/rogue_adjust_pq(amount, ckey, admin_key, reason)
	ckey = ckey(ckey)
	if(!ckey)
		return
	var/pq = round(clamp(rogue_get_pq(ckey) + amount, ROGUE_PQ_FLOOR, ROGUE_PQ_CAP), 0.01)
	GLOB.rogue_pq_cache[ckey] = pq
	var/path = rogue_player_save_path(ckey, "pq_num.json")
	var/list/json = rogue_read_json(path)
	json[ckey] = pq
	rogue_write_json(path, json)
	if(!admin_key && !reason)
		return
	var/entry
	if(amount)
		entry = "[amount > 0 ? "+" : ""][amount][admin_key ? " by [admin_key]" : ""][reason ? " for reason: [reason]" : ""]"
	else
		entry = "NOTE[admin_key ? " from [admin_key]" : ""]: [reason]"
	text2file("[entry] ([GLOB.round_id])\n", rogue_player_save_path(ckey, "playerquality.txt"))
	if(!admin_key)
		return
	message_admins("[admin_key] adjusted [ckey]'s PQ by [amount] for reason: [reason]")
	log_admin("[admin_key] adjusted [ckey]'s PQ by [amount] for reason: [reason]")
	var/client/player = GLOB.directory[ckey]
	if(player)
		to_chat(player, span_adminnotice("Your PQ has been adjusted by [amount] by [admin_key] for reason: [reason]"), confidential = TRUE)

/// Who commended the player and how often: giver ckey -> count (Ratwood commends.json).
/proc/rogue_commenders(ckey)
	return rogue_read_json(rogue_player_save_path(ckey, "commends.json"))

/proc/rogue_get_commends(ckey)
	. = 0
	var/list/commenders = rogue_commenders(ckey)
	for(var/giver in commenders)
		if(isnum(commenders[giver]))
			. += commenders[giver]

/// One player commends another (Ratwood add_commend()): the first commendation from a giver is worth a point of PQ, and
/// from a high PQ on every commendation is worth a little.
/proc/rogue_add_commend(ckey, giver)
	ckey = ckey(ckey)
	giver = ckey(giver)
	if(!ckey || !giver)
		return
	var/path = rogue_player_save_path(ckey, "commends.json")
	var/list/json = rogue_read_json(path)
	var/count = (isnum(json[giver]) ? json[giver] : 0) + 1
	json[giver] = count
	rogue_write_json(path, json)
	if(rogue_get_pq(ckey) >= rogue_value("pq_commend_high"))
		rogue_adjust_pq(count == 1 ? rogue_value("pq_commend_high_first") : rogue_value("pq_commend_high_repeat"), ckey)
	else if(count == 1)
		rogue_adjust_pq(rogue_value("pq_commend"), ckey)

/proc/rogue_get_round_points(ckey)
	var/list/json = rogue_read_json(rogue_player_save_path(ckey, "rcp.json"))
	return isnum(json["RCP"]) ? json["RCP"] : 0

/// The round contributor points of a role played through a round (Ratwood add_roundpoints()): every
/// pq_rcp_per_pq of them is a point of PQ. They stop counting from a high PQ, and stop raising PQ once enough were
/// gathered, unless the PQ is still low. Returns whether they were counted.
/proc/rogue_add_round_points(ckey, amount)
	ckey = ckey(ckey)
	if(!ckey || amount <= 0 || rogue_get_pq(ckey) >= rogue_value("pq_rcp_pq_ceiling"))
		return FALSE
	var/path = rogue_player_save_path(ckey, "rcp.json")
	var/list/json = rogue_read_json(path)
	var/total = (isnum(json["RCP"]) ? json["RCP"] : 0) + amount
	json["RCP"] = total
	rogue_write_json(path, json)
	if(total < rogue_value("pq_rcp_total_cap") || rogue_get_pq(ckey) < rogue_value("pq_rcp_pq_floor"))
		rogue_adjust_pq(round(amount / rogue_value("pq_rcp_per_pq"), 0.1), ckey)
	return TRUE

/// Counts a round played for each of these players (Ratwood add_roundplayed(), data/roundsplayed.json by ckey).
/proc/rogue_add_rounds_played(list/ckeys)
	if(!length(ckeys))
		return
	var/path = rogue_shared_data_path("roundsplayed.json")
	var/list/json = rogue_read_json(path)
	for(var/ckey in ckeys)
		json[ckey] = (isnum(json[ckey]) ? json[ckey] : 0) + 1
	rogue_write_json(path, json)

/proc/rogue_get_rounds_played(ckey)
	var/list/json = rogue_read_json(rogue_shared_data_path("roundsplayed.json"))
	return isnum(json[ckey(ckey)]) ? json[ckey(ckey)] : 0

/// The player's PQ, commendations, round points and rounds, and the whole log, newest first (Ratwood's check_pq_menu).
/// Admins also see who commended them.
/proc/rogue_show_pq(client/viewer, ckey)
	ckey = ckey(ckey)
	if(!viewer || !ckey)
		return
	var/pq = rogue_get_pq(ckey)
	var/list/body = list("<center><b>[ckey]</b></center>", "<center>PQ: [rogue_pq_rank(pq)] ([pq])</center>")
	body += "<center>Triumphs: [rogue_get_triumphs(ckey)]</center>"
	body += "<table width=100%><tr><td width=33%>Commends: [rogue_get_commends(ckey)]</td>"
	body += "<td width=34%><center>Round Contributor Points: [rogue_get_round_points(ckey)]</center></td>"
	body += "<td width=33% style='text-align:right'>Rounds Survived: [rogue_get_rounds_played(ckey)]</td></tr></table>"
	if(check_rights_for(viewer, R_ADMIN))
		var/list/commenders = rogue_commenders(ckey)
		var/list/givers = list()
		for(var/giver in commenders)
			givers += "[html_encode(giver)] ([commenders[giver]])"
		if(length(givers))
			body += "<span class='info'>Commended by: [givers.Join(", ")]</span>"
	body += "<hr>"
	var/list/entries = world.file2list(rogue_player_save_path(ckey, "playerquality.txt"))
	var/shown = 0
	for(var/index in length(entries) to 1 step -1)
		if(entries[index])
			body += "<span class='info'>[html_encode(entries[index])]</span><br>"
			shown++
	if(!shown)
		body += "<span class='info'>No data on record.</span>"
	var/datum/browser/popup = new(viewer.mob, "rogue_playerquality", "Player Quality", 420, 360)
	popup.set_content(jointext(body, ""))
	popup.open()

#undef ROGUE_PQ_FLOOR
#undef ROGUE_PQ_CAP
