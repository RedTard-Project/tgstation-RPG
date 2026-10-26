/// Ratwood's player quality (code/modules/admin/playerquality.dm): a number per player, from -100 to 500, that admins raise
/// and lower with a reason. It lives beside the player's preferences in Ratwood's own files (pq_num.json and the log
/// playerquality.txt in data/player_saves/<c>/<ckey>/), so saves brought over from a Ratwood server keep their PQ.

#define ROGUE_PQ_FLOOR -100
#define ROGUE_PQ_CAP 500

/// A file of the player's own folder, where TG keeps their preferences.
/proc/rogue_player_save_path(ckey, file_name)
	ckey = ckey(ckey)
	return "data/player_saves/[copytext(ckey, 1, 2)]/[ckey]/[file_name]"

/// Whether the server has ever seen this player: TG writes their preferences on their first connection.
/proc/rogue_player_known(ckey)
	return ckey(ckey) && fexists(rogue_player_save_path(ckey, "preferences.json"))

/proc/rogue_get_pq(ckey)
	ckey = ckey(ckey)
	if(!ckey)
		return 0
	var/path = rogue_player_save_path(ckey, "pq_num.json")
	if(!fexists(path))
		return 0
	var/list/json = json_decode(file2text(path))
	return islist(json) && isnum(json[ckey]) ? json[ckey] : 0

/// Ratwood's names for the steps of PQ, as the admin panels show them.
/proc/rogue_pq_rank(pq)
	if(pq >= 500)
		return "<span style='color: #FFD700;'>ASCENDANT</span>"
	if(pq >= 440)
		return "<span style='color: #B0C4DE;'>UNDYING</span>"
	if(pq >= 375)
		return "<span style='color: #9B59B6;'>DIVINE</span>"
	if(pq >= 310)
		return "<span style='color: #E8D44D;'>EXALTED</span>"
	if(pq >= 250)
		return "<span style='color: #5DADE2;'>RENOWNED</span>"
	if(pq >= 200)
		return "<span style='color: #52BE80;'>FABLED</span>"
	if(pq >= 160)
		return "<span style='color: #45B39D;'>STORIED</span>"
	if(pq >= 130)
		return "<span style='color: #4CAF50;'>PROVEN</span>"
	if(pq >= 100)
		return "<span style='color: #617C46;'>VALE DWELLER</span>"
	if(pq >= 70)
		return "<span style='color: #00ff00;'>Magnificent!</span>"
	if(pq >= 50)
		return "<span style='color: #00ff00;'>Exceptional!</span>"
	if(pq >= 30)
		return "<span style='color: #47b899;'>Great!</span>"
	if(pq >= 10)
		return "<span style='color: #69c975;'>Good!</span>"
	if(pq >= 5)
		return "<span style='color: #58a762;'>Nice</span>"
	if(pq >= -4)
		return "Normal"
	if(pq >= -30)
		return "<span style='color: #be6941;'>Poor</span>"
	if(pq >= -70)
		return "<span style='color: #cd4232;'>Terrible</span>"
	if(pq >= -99)
		return "<span style='color: #e2221d;'>Abysmal</span>"
	return "<span style='color: #ff00ff;'>Shitter</span>"

/// Changes a player's PQ and writes the change into their log; an amount of 0 with a reason is a note. The player is told
/// when they are online.
/proc/rogue_adjust_pq(amount, ckey, admin_key, reason)
	ckey = ckey(ckey)
	if(!ckey)
		return
	var/pq = clamp(rogue_get_pq(ckey) + amount, ROGUE_PQ_FLOOR, ROGUE_PQ_CAP)
	var/path = rogue_player_save_path(ckey, "pq_num.json")
	fdel(path)
	text2file(json_encode(list("[ckey]" = pq)), path)
	if(!amount && !reason)
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

/// The player's PQ and its whole log, newest first (Ratwood's check_pq_menu).
/proc/rogue_show_pq(client/viewer, ckey)
	ckey = ckey(ckey)
	if(!viewer || !ckey)
		return
	var/pq = rogue_get_pq(ckey)
	var/list/body = list("<center><b>[ckey]</b></center>", "<center>PQ: [rogue_pq_rank(pq)] ([pq])</center>")
	body += "<center>Triumphs: [rogue_get_triumphs(ckey)]</center><hr>"
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
