/// What a medieval round gives players beyond the round itself, as Ratwood does: triumphs for every night lived through
/// (nightshift.dm handle_sleep_triumphs(), townsfolk get more), the role's round contributor points at round end for
/// whoever played long enough and lived through a night (roundend.dm), a round played on record, and anonymous
/// commendations of other characters, offered at round end (client_procs.dm commendsomeone()). The triumph shop's round
/// effects reach every character that spawns here. Started by the migrant subsystem, which lives only on medieval maps.
GLOBAL_DATUM_INIT(rogue_round_rewards, /datum/rogue_round_rewards, new)

/datum/rogue_round_rewards
	var/started = FALSE
	/// Characters of this round: real name -> ckey (Ratwood character_ckey_list), to commend.
	var/list/characters = list()
	/// Ckey -> when the player last spawned as a character (Ratwood round_join_times).
	var/list/join_times = list()
	/// Ckeys that commended someone this round.
	var/list/commended = list()

/datum/rogue_round_rewards/proc/start()
	if(started)
		return
	started = TRUE
	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN, PROC_REF(on_job_after_spawn))
	RegisterSignal(SSdcs, COMSIG_GLOB_ROCKHILL_TIME_OF_DAY, PROC_REF(on_time_of_day))
	SSticker.OnRoundstart(CALLBACK(GLOB.rogue_triumph_shop, TYPE_PROC_REF(/datum/rogue_triumph_shop, round_started)))
	SSticker.OnRoundend(CALLBACK(src, PROC_REF(on_round_end)))

/datum/rogue_round_rewards/proc/on_job_after_spawn(datum/source, datum/job/job, mob/living/spawned, client/player_client)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/human = spawned
	if(!istype(human))
		return
	var/ckey = player_client?.ckey || ckey(human.mind?.key)
	if(ckey)
		characters[human.real_name] = ckey
		join_times[ckey] = world.time
	INVOKE_ASYNC(GLOB.rogue_triumph_shop, TYPE_PROC_REF(/datum/rogue_triumph_shop, on_spawn), human)

/datum/rogue_round_rewards/proc/on_time_of_day(datum/source, datum/rockhill_clock_step/phase/old_phase, datum/rockhill_clock_step/phase/new_phase)
	SIGNAL_HANDLER
	if(new_phase?.name == ROCKHILL_NIGHT)
		INVOKE_ASYNC(src, PROC_REF(award_night))

/// Nightfall: every living character with a player gets a triumph, a townsman one more (Ratwood handle_sleep_triumphs()).
/datum/rogue_round_rewards/proc/award_night()
	var/list/towners = list(/datum/job_department/rockhill_yeomen, /datum/job_department/rockhill_peasants, /datum/job_department/rockhill_youngfolk)
	for(var/mob/living/carbon/human/human in GLOB.alive_player_list)
		if(QDELETED(human) || !human.mind || !human.ckey)
			continue
		human.rogue_nights_survived++
		var/triumphs = rogue_value("triumph_night")
		var/datum/job/job = human.mind.assigned_role
		for(var/department in job?.departments_list)
			if(department in towners)
				triumphs += rogue_value("triumph_night_towner")
				break
		rogue_adjust_triumphs(human.ckey, triumphs)
		to_chat(human, span_danger("Days Survived: \Roman[human.rogue_nights_survived]"))
		CHECK_TICK

/datum/rogue_round_rewards/proc/on_round_end()
	var/list/played = list()
	for(var/client/player as anything in GLOB.clients)
		if(isliving(player.mob) && player.ckey)
			played += player.ckey
	rogue_add_rounds_played(played)
	for(var/mob/living/carbon/human/human in GLOB.player_list)
		if(!QDELETED(human))
			award_round_points(human)
		CHECK_TICK
	for(var/client/player as anything in GLOB.clients)
		INVOKE_ASYNC(src, PROC_REF(offer_commend), player, TRUE)

/// The role's round contributor points, for a round played long enough and through a night (Ratwood roundend.dm).
/datum/rogue_round_rewards/proc/award_round_points(mob/living/carbon/human/human)
	var/ckey = human.ckey
	var/datum/job/roguetown/role = human.mind?.assigned_role
	if(!ckey || !istype(role) || role.rogue_round_contrib_points <= 0 || !human.rogue_nights_survived)
		return
	if(isnull(join_times[ckey]) || world.time - join_times[ckey] < rogue_value("pq_rcp_round_time"))
		return
	if(rogue_add_round_points(ckey, role.rogue_round_contrib_points))
		to_chat(human, "<font color='purple'><b>[role.rogue_round_contrib_points]</b> ROUND CONTRIBUTOR POINTS AWARDED. Thank you for playing!</font>")

/// Asks the player whom of this round's characters they commend, once a round (Ratwood commendsomeone()). At round end
/// a player who already commended someone is not asked.
/datum/rogue_round_rewards/proc/offer_commend(client/player, quiet = FALSE)
	if(!player?.ckey || !rogue_lobby_enabled())
		return
	if(commended[player.ckey])
		if(!quiet)
			to_chat(player, span_danger("You already commended someone this round."))
		return
	var/list/choices = characters.Copy()
	for(var/name in choices)
		if(choices[name] == player.ckey)
			choices -= name
	if(!length(choices))
		if(!quiet)
			to_chat(player, span_warning("There is no one else to commend this round."))
		return
	if(tgui_alert(player.mob, "Was there a character during this round that you would like to anonymously commend?", "Commendation", list("Yes", "No")) != "Yes" || !player)
		return
	var/picked = tgui_input_list(player.mob, "Which character?", "Commendation", sort_list(choices))
	if(!picked || !player?.ckey || commended[player.ckey])
		return
	var/ckey = choices[picked]
	commended[player.ckey] = TRUE
	rogue_add_commend(ckey, player.ckey)
	to_chat(player, span_notice("[picked] commended."))
	log_game("COMMEND: [player.ckey] commends [ckey].")
	log_admin("COMMEND: [player.ckey] commends [ckey].")

/mob/living/carbon/human
	/// Nights this character lived through (Ratwood allmig_reward).
	var/rogue_nights_survived = 0

GAME_VERB_DESC(/client, rogue_commend, "Commend", "Anonymously commend a character of this round, once a round.", "OOC")
	if(!rogue_lobby_enabled())
		to_chat(src, span_warning("There is no one to commend in this world."))
		return
	GLOB.rogue_round_rewards.offer_commend(src)
