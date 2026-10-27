/// Ratwood's player quality of roles (jobs/_job.dm min_pq and round_contrib_points, controllers/subsystem/job.dm,
/// new_player.dm): a Rockhill role asks for a least PQ, both at roundstart and to join late, and a round played through
/// in it earns its round contributor points (triumphs/round.dm). The numbers are Ratwood's
/// (triumphs/ported/roles.dm). Not ported: Ratwood's max_pq (no Ratwood role sets it), PQ limits of classes, and
/// Ratwood's leave for required roles set to Low at roundstart.

/// Whether the roles of medieval maps ask for their least PQ (Ratwood USES_PQ).
/datum/config_entry/flag/rogue_role_pq
	default = TRUE

/datum/job/roguetown
	/// The least PQ to take the role; null for none (Ratwood min_pq, 0 unless the role sets it).
	var/rogue_min_pq = 0
	/// Round contributor points of a round played through in the role (Ratwood round_contrib_points).
	var/rogue_round_contrib_points = 0

/datum/job/roguetown/New()
	. = ..()
	var/list/quality = GLOB.rogue_role_quality[type]
	if(quality)
		rogue_min_pq = quality[1]
		rogue_round_contrib_points = quality[2]

/// Whether the player's PQ is too low for the job.
/proc/rogue_role_pq_blocks(ckey, datum/job/job)
	var/datum/job/roguetown/role = job
	if(!istype(role) || isnull(role.rogue_min_pq) || !ckey || !rogue_lobby_enabled() || !CONFIG_GET(flag/rogue_role_pq))
		return FALSE
	return rogue_get_pq(ckey) < role.rogue_min_pq

/proc/rogue_role_pq_message(ckey, datum/job/roguetown/role)
	return "You do not meet the Player Quality requirement for [role.title]. (Required: [role.rogue_min_pq], Your PQ: [rogue_get_pq(ckey)])"

/// TG's job checks, then Ratwood's least PQ of the role: it keeps the role from the player at roundstart and late.
/datum/controller/subsystem/job/check_job_eligibility(mob/dead/new_player/player, datum/job/possible_job, debug_prefix = "", add_job_to_log = FALSE)
	. = ..()
	if(. != JOB_AVAILABLE || QDELETED(player) || !rogue_role_pq_blocks(player.ckey, possible_job))
		return
	var/datum/job/roguetown/role = possible_job
	job_debug("[debug_prefix] Error: PQ below [role.rogue_min_pq], Player: [player][add_job_to_log ? ", Job: [possible_job]" : ""]")
	return JOB_UNAVAILABLE_GENERIC

/// The late join menu tells why a role is closed by PQ, as Ratwood's does.
/datum/latejoin_menu/ui_data(mob/user)
	. = ..()
	var/mob/dead/new_player/owner = user
	if(!istype(owner) || !rogue_lobby_enabled())
		return
	var/list/data = .
	var/list/departments = data["departments"]
	for(var/department_name in departments)
		var/list/jobs = departments[department_name]["jobs"]
		for(var/title in jobs)
			var/list/job_data = jobs[title]
			if(!job_data["unavailable_reason"])
				continue
			var/datum/job/job = SSjob.get_job(title)
			if(rogue_role_pq_blocks(owner.ckey, job))
				job_data["unavailable_reason"] = rogue_role_pq_message(owner.ckey, job)

/// Joining late as a role closed by PQ says why.
/mob/dead/new_player/AttemptLateSpawn(rank)
	var/datum/job/job = SSjob.get_job(rank)
	if(rogue_role_pq_blocks(ckey, job))
		tgui_alert(usr, rogue_role_pq_message(ckey, job))
		return FALSE
	return ..()
