/// Migrant waves on medieval maps, as Ratwood and Azure Peak run them (code/controllers/subsystem/migrants.dm,
/// code/datums/migrants): while the round goes on, a wave rolls on its track every few minutes and forms for a while;
/// players in the lobby queue for it, and for a role in it, from the migrant panel (the Migrants button of the menu);
/// once it has formed, the queued players arrive together at its landmark, each as their role, dressed and picking the
/// role's class. A wave whose required roles stay empty scatters and cools down. The waves and roles are Ratwood's,
/// ported (rockhill/ported/migrants.dm). Players in the lobby pledge triumphs to a wave (Ratwood
/// contribute_triumph_to_wave()): each pledged triumph makes it roll likelier, its pledgers take their roles first, and a
/// wave pledged up to its threshold forms on the triumph track at once; when a wave of the triumph track scatters, its
/// pledges come back. Not ported: antagonist roles, the event track, races and ages of roles, roles' own after_spawn.

#define ROGUE_MIGRANT_TRACK_REGULAR "regular"
#define ROGUE_MIGRANT_TRACK_SPECIAL "special"
#define ROGUE_MIGRANT_TRACK_TRIUMPH "triumph"
#define ROGUE_MIGRANT_ROLE(role_type) GLOB.rogue_migrant_roles[role_type]
#define ROGUE_MIGRANT_WAVE(wave_type) GLOB.rogue_migrant_waves[wave_type]

GLOBAL_LIST_INIT(rogue_migrant_waves, rogue_migrant_singletons(/datum/rogue_migrant_wave))
GLOBAL_LIST_INIT(rogue_migrant_roles, rogue_migrant_singletons(/datum/rogue_migrant_role))
/// Where waves arrive, by Ratwood's landmark name (a wave's spawn_landmark): the start landmarks that carried it.
GLOBAL_LIST_EMPTY(rogue_migrant_spawns)

/proc/rogue_migrant_singletons(root)
	. = list()
	for(var/path in valid_subtypesof(root))
		.[path] = new path

/datum/rogue_migrant_role
	abstract_type = /datum/rogue_migrant_role
	var/name = "Migrant"
	/// Told to the player on arrival.
	var/greet_text
	/// Restricts the role to these sexes if set.
	var/list/allowed_sexes
	/// Worn on arrival, before the class (Ratwood's role outfit).
	var/outfit
	/// The classes the migrant picks from on arrival (Ratwood's advclass_cat_rolls).
	var/list/rockhill_advclasses
	var/grant_lit_torch = FALSE

/datum/rogue_migrant_wave
	abstract_type = /datum/rogue_migrant_wave
	var/name = "Migrant Wave"
	var/track = ROGUE_MIGRANT_TRACK_REGULAR
	/// Role type -> count: all must fill, or the wave scatters.
	var/list/required_roles = list()
	/// Role type -> count: filled as players want them; empty slots vanish.
	var/list/optional_roles = list()
	/// The wave scatters if fewer optional slots than this fill.
	var/min_optional_fills = 0
	/// Earliest time into the round the wave may roll.
	var/min_round_time = 0
	/// Rolls without being shown in the panel.
	var/hidden = FALSE
	/// A hostile raid: it cools down longer when it scatters.
	var/is_raid = FALSE
	var/min_active
	var/max_active
	var/min_pop
	var/max_pop
	var/max_spawns
	/// How likely the wave is picked against the others of its track.
	var/weight = 20
	/// Ratwood's landmark name the wave arrives at.
	var/spawn_landmark = "Pilgrim"
	var/greet_text
	/// Never rolls by itself; an admin can still force it.
	var/can_roll = TRUE
	/// The wave whose spawn count this one shares for max_spawns.
	var/shared_wave_type
	var/spawn_on_location = TRUE
	/// Triumphs pledged to the wave, by ckey.
	var/list/triumph_contributions = list()
	var/triumph_total = 0
	/// Pledged up to this, the wave forms next on the triumph track.
	var/triumph_threshold = 25
	/// Whether the pledges are spent once the wave arrives.
	var/reset_contributions_on_spawn = TRUE

/// Ratwood's thresholds of the two default waves.
/datum/rogue_migrant_wave/pilgrim
	triumph_threshold = 10

/datum/rogue_migrant_wave/adventurer
	triumph_threshold = 15

/datum/rogue_migrant_wave/proc/role_types()
	. = list()
	for(var/role_type in required_roles)
		. |= role_type
	for(var/role_type in optional_roles)
		. |= role_type

/datum/rogue_migrant_assignment
	var/client/client
	var/role_type
	var/turf/spawn_location

/datum/rogue_migrant_assignment/New(role_type)
	src.role_type = role_type

/// The rank every migrant holds (Ratwood's Migrant job); the role and its class dress them.
/datum/job/roguetown/rockhill_migrant
	title = "Migrant"
	description = "You came with a wave of travellers from beyond the realm."
	total_positions = 0
	spawn_positions = 0
	config_tag = "ROCKHILL_MIGRANT"
	outfit = /datum/outfit/job/roguetown/rockhill_migrant
	job_flags = ROCKHILL_JOB_FLAGS & ~JOB_NEW_PLAYER_JOINABLE
	departments_list = list(
		/datum/job_department/rockhill_wanderers,
		)

/datum/outfit/job/roguetown/rockhill_migrant
	name = "Migrant"
	jobtype = /datum/job/roguetown/rockhill_migrant

/// Start landmarks that carry Ratwood's arrival names stay after roundstart for the waves.
/obj/effect/landmark/start/rockhill
	var/list/rockhill_migrant_spawns

/obj/effect/landmark/start/rockhill/Initialize(mapload)
	. = ..()
	if(!length(rockhill_migrant_spawns))
		return
	delete_after_roundstart = FALSE
	for(var/spawn_name in rockhill_migrant_spawns)
		LAZYADDASSOCLIST(GLOB.rogue_migrant_spawns, spawn_name, src)

/obj/effect/landmark/start/rockhill/Destroy()
	for(var/spawn_name in rockhill_migrant_spawns)
		LAZYREMOVEASSOC(GLOB.rogue_migrant_spawns, spawn_name, src)
	return ..()

SUBSYSTEM_DEF(rogue_migrants)
	name = "Migrants"
	wait = 2 SECONDS
	runlevels = RUNLEVEL_GAME
	var/wave_number = 1
	/// How long a rolled wave forms before it arrives.
	var/wave_wait_time = 3 MINUTES
	var/regular_roll_interval = 5 MINUTES
	var/special_roll_interval = 12 MINUTES
	var/faction_fail_cooldown = 20 MINUTES
	var/raid_fail_cooldown = 30 MINUTES
	/// Lobby players are told of a forming special wave at most this often.
	var/announce_interval = 5 MINUTES
	var/last_announce = 0
	/// Track -> the wave forming on it, when it arrives, when the track rolls next, whether an admin forced it.
	var/list/track_forming = list()
	var/list/track_arrival = list()
	var/list/track_next_roll = list()
	var/list/track_forced = list()
	/// Wave type -> the time it may roll again after it scattered.
	var/list/wave_cooldown = list()
	/// Wave type -> how many times it arrived.
	var/list/spawned_waves = list()
	/// Ckey -> wave type -> triumphs that player pledged to the wave (Ratwood global_triumph_contributions).
	var/list/pledges = list()

/datum/controller/subsystem/rogue_migrants/Initialize()
	if(!rogue_lobby_enabled())
		can_fire = FALSE
		return SS_INIT_NO_NEED
	// The round's triumphs and PQ (triumphs/round.dm) live on medieval maps, as this subsystem does.
	GLOB.rogue_round_rewards.start()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/rogue_migrants/fire(resumed)
	if(!length(track_next_roll))
		track_next_roll[ROGUE_MIGRANT_TRACK_REGULAR] = world.time + 2 MINUTES
		track_next_roll[ROGUE_MIGRANT_TRACK_SPECIAL] = world.time + special_roll_interval
	process_track(ROGUE_MIGRANT_TRACK_REGULAR, regular_roll_interval, FALSE)
	process_track(ROGUE_MIGRANT_TRACK_SPECIAL, special_roll_interval, TRUE)
	process_triumph_track()
	update_panels()

/// A wave pledged up to its threshold forms at once on a track of its own (Ratwood process_triumph_track()).
/datum/controller/subsystem/rogue_migrants/proc/process_triumph_track()
	if(track_forming[ROGUE_MIGRANT_TRACK_TRIUMPH])
		if(world.time >= track_arrival[ROGUE_MIGRANT_TRACK_TRIUMPH])
			resolve_forming_wave(ROGUE_MIGRANT_TRACK_TRIUMPH)
		return
	var/wave_type = pledged_wave()
	if(wave_type)
		begin_forming(ROGUE_MIGRANT_TRACK_TRIUMPH, wave_type)
		announce_wave(wave_type)

/// The eligible wave pledged furthest past its threshold, if any (Ratwood get_maxed_wave()).
/datum/controller/subsystem/rogue_migrants/proc/pledged_wave()
	var/best_total = 0
	for(var/wave_type in GLOB.rogue_migrant_waves)
		var/datum/rogue_migrant_wave/wave = ROGUE_MIGRANT_WAVE(wave_type)
		if(wave.triumph_total < wave.triumph_threshold || wave.triumph_total <= best_total || !wave_eligible(wave) || is_forming(wave_type))
			continue
		best_total = wave.triumph_total
		. = wave_type

/datum/controller/subsystem/rogue_migrants/proc/is_forming(wave_type)
	for(var/track in track_forming)
		if(track_forming[track] == wave_type)
			return TRUE
	return FALSE

/datum/controller/subsystem/rogue_migrants/proc/process_track(track, roll_interval, announce)
	if(track_forming[track])
		if(world.time < track_arrival[track])
			return
		resolve_forming_wave(track)
		track_next_roll[track] = world.time + roll_interval
		return
	if(world.time < track_next_roll[track])
		return
	var/wave_type = roll_wave(track)
	if(wave_type)
		begin_forming(track, wave_type)
		if(announce)
			announce_wave(wave_type)
	track_next_roll[track] = world.time + roll_interval

/datum/controller/subsystem/rogue_migrants/proc/is_forced_forming(wave_type)
	for(var/track in track_forced)
		if(track_forced[track] && track_forming[track] == wave_type)
			return TRUE
	return FALSE

/datum/controller/subsystem/rogue_migrants/proc/begin_forming(track, wave_type, forced = FALSE)
	track_forming[track] = wave_type
	track_arrival[track] = world.time + wave_wait_time
	track_forced[track] = forced
	log_game("Migrants: [track] track rolled wave: [wave_type][forced ? " (forced)" : ""]")

/datum/controller/subsystem/rogue_migrants/proc/resolve_forming_wave(track)
	var/wave_type = track_forming[track]
	var/forced = track_forced[track]
	track_forming[track] = null
	track_arrival[track] = 0
	track_forced[track] = FALSE
	var/datum/rogue_migrant_wave/wave = ROGUE_MIGRANT_WAVE(wave_type)
	if(try_spawn_wave(wave, forced))
		log_game("Migrants: spawned wave: [wave_type]")
		wave_number++
		return
	log_game("Migrants: wave failed to assemble: [wave_type]")
	message_admins("MIGRANTS: Wave '[wave.name]' failed to assemble on the [track] track.")
	wave_cooldown[wave_type] = world.time + (wave.is_raid ? raid_fail_cooldown : faction_fail_cooldown)
	for(var/client/client as anything in wave_candidates(wave_type))
		to_chat(client, span_boldwarning("The wave you queued for, [wave.name], failed to gather enough people and scattered into the mist. You have left the queue."))
		client.prefs.rogue_migrant().clear_queue(silent = TRUE)
	if(track == ROGUE_MIGRANT_TRACK_TRIUMPH)
		refund_pledges(wave)

/datum/controller/subsystem/rogue_migrants/proc/try_spawn_wave(datum/rogue_migrant_wave/wave, forced = FALSE)
	var/list/candidates = shuffle(wave_candidates(wave.type))
	if(!length(candidates))
		return FALSE
	var/list/picked = list()
	var/list/assignments = assemble_wave(wave, candidates, picked)
	if(isnull(assignments))
		return FALSE

	var/turf/arrival = get_turf(pick(GLOB.rogue_migrant_spawns[wave.spawn_landmark] || list(null)))
	var/list/turfs = arrival ? safe_turfs_around(arrival) : list()
	for(var/i in 1 to min(length(turfs), length(assignments)))
		var/datum/rogue_migrant_assignment/assignment = assignments[i]
		assignment.spawn_location = turfs[i]
	for(var/datum/rogue_migrant_assignment/assignment as anything in assignments)
		assignment.spawn_location ||= arrival

	for(var/client/client as anything in picked)
		client.prefs.rogue_migrant().post_spawn()
	for(var/datum/rogue_migrant_assignment/assignment as anything in assignments)
		spawn_migrant(wave, assignment)

	var/counted_type = wave.shared_wave_type || wave.type
	spawned_waves[counted_type] += 1
	if(wave.reset_contributions_on_spawn)
		clear_pledges(wave)
	message_admins("MIGRANTS: Spawned wave: [wave.name] (players: [length(assignments)]) at [arrival ? ADMIN_VERBOSEJMP(arrival) : "the latejoin points"]")
	return TRUE

/// The wave's slots filled from its queue: every required slot (by those who chose that role first, then anyone who can
/// be it), then the optional ones; null when a required slot or the optional minimum stays empty.
/datum/controller/subsystem/rogue_migrants/proc/assemble_wave(datum/rogue_migrant_wave/wave, list/candidates, list/picked)
	var/list/required = list()
	for(var/role_type in wave.required_roles)
		for(var/i in 1 to wave.required_roles[role_type])
			required += new /datum/rogue_migrant_assignment(role_type)
	for(var/datum/rogue_migrant_assignment/assignment as anything in shuffle(required))
		fill_assignment(assignment, candidates, picked, prefer = TRUE, wave_type = wave.type)
		if(!assignment.client)
			fill_assignment(assignment, candidates, picked, prefer = FALSE)
		if(!assignment.client)
			return null

	var/list/optional = list()
	for(var/role_type in wave.optional_roles)
		for(var/i in 1 to wave.optional_roles[role_type])
			optional += new /datum/rogue_migrant_assignment(role_type)
	optional = shuffle(optional)
	for(var/datum/rogue_migrant_assignment/assignment as anything in optional)
		fill_assignment(assignment, candidates, picked, prefer = TRUE, wave_type = wave.type)
	var/list/filled = list()
	for(var/datum/rogue_migrant_assignment/assignment as anything in optional)
		if(!assignment.client)
			fill_assignment(assignment, candidates, picked, prefer = FALSE)
		if(assignment.client)
			filled += assignment
	if(length(filled) < wave.min_optional_fills)
		return null
	return required + filled

/// Gives the slot to the first candidate who can take it; preferring, only to those who chose the role, the ones who
/// pledged most triumphs to the wave first (Ratwood get_priority_players()).
/datum/controller/subsystem/rogue_migrants/proc/fill_assignment(datum/rogue_migrant_assignment/assignment, list/candidates, list/picked, prefer, wave_type)
	var/list/order = prefer ? pledge_order(candidates, assignment.role_type, wave_type) : candidates.Copy()
	for(var/client/client as anything in order)
		if(!can_be_role(client, assignment.role_type))
			continue
		assignment.client = client
		candidates -= client
		picked += client
		return

/// The candidates who chose the role: those who pledged to the wave, most first, then the rest in their shuffled order.
/datum/controller/subsystem/rogue_migrants/proc/pledge_order(list/candidates, role_type, wave_type)
	var/list/pledged = list()
	var/list/unpledged = list()
	for(var/client/client as anything in candidates)
		if(client.prefs.rogue_migrant().queued_role != role_type)
			continue
		var/amount = pledged_by(client.ckey, wave_type)
		if(amount > 0)
			pledged[client] = amount
		else
			unpledged += client
	sortTim(pledged, GLOBAL_PROC_REF(cmp_numeric_dsc), associative = TRUE)
	. = list()
	for(var/client/client as anything in pledged)
		. += client
	. += unpledged

/datum/controller/subsystem/rogue_migrants/proc/can_be_role(client/player, role_type)
	var/datum/rogue_migrant_role/role = ROGUE_MIGRANT_ROLE(role_type)
	if(!role || !player?.prefs)
		return FALSE
	if(role.allowed_sexes && !(player.prefs.read_preference(/datum/preference/choiced/gender) in role.allowed_sexes))
		return FALSE
	return TRUE

/datum/controller/subsystem/rogue_migrants/proc/safe_turfs_around(turf/center)
	. = list()
	for(var/turf/turf as anything in RANGE_TURFS(2, center))
		if(!isfloorturf(turf) || islava(turf) || turf.is_blocked_turf(exclude_mobs = TRUE))
			continue
		. += turf
	shuffle_inplace(.)

/// Brings the player in as their role: TG's late join (the Migrant rank, the character of their slot, the manifest)
/// at the wave's landmark, then the role's greeting, outfit, torch and class.
/datum/controller/subsystem/rogue_migrants/proc/spawn_migrant(datum/rogue_migrant_wave/wave, datum/rogue_migrant_assignment/assignment)
	var/mob/dead/new_player/player = assignment.client?.mob
	if(!istype(player) || !player.mind)
		return FALSE
	var/client/player_client = player.client
	var/datum/job/job = SSjob.get_job_type(/datum/job/roguetown/rockhill_migrant)
	if(!job || !SSjob.assign_role(player, job, latejoin = TRUE, do_eligibility_checks = FALSE))
		return FALSE
	var/datum/rogue_migrant_role/role = ROGUE_MIGRANT_ROLE(assignment.role_type)
	SSticker.queued_players -= player
	player.mind.late_joiner = TRUE
	var/atom/destination = (wave.spawn_on_location && assignment.spawn_location) || job.get_latejoin_spawn_point()
	var/mob/living/character = player.create_character(destination, forced_slot = player_client.prefs.default_slot)
	if(!character)
		return FALSE
	player.transfer_character()
	SSjob.equip_rank(character, job, character.client)
	job.after_latejoin_spawn(character)
	SSticker.minds += character.mind
	GLOB.joined_player_list += character.ckey

	to_chat(character, span_boldnotice("I am the [role.name]!"))
	if(wave.greet_text)
		to_chat(character, span_notice(wave.greet_text))
	if(role.greet_text)
		to_chat(character, span_notice(role.greet_text))
	var/mob/living/carbon/human/human = character
	if(istype(human))
		if(role.outfit)
			human.equipOutfit(role.outfit)
		if(role.grant_lit_torch)
			var/obj/item/flashlight/flare/torch/torch = new(human.drop_location())
			torch.ignition(human)
			human.put_in_hands(torch)
		GLOB.manifest.inject(human)
		SEND_SIGNAL(human, COMSIG_HUMAN_CHARACTER_SETUP_FINISHED)
		if(length(role.rockhill_advclasses))
			rockhill_start_class_choice(human, human.client, role.name, role.rockhill_advclasses)
	log_manifest(character.mind.key, character.mind, character, latejoin = TRUE)
	return TRUE

/datum/controller/subsystem/rogue_migrants/proc/wave_eligible(datum/rogue_migrant_wave/wave)
	if(!wave.can_roll)
		return FALSE
	if(wave.min_round_time && (world.time - SSticker.round_start_time) < wave.min_round_time)
		return FALSE
	var/queued = length(active_migrants())
	if(!isnull(wave.min_active) && queued < wave.min_active)
		return FALSE
	if(!isnull(wave.max_active) && queued > wave.max_active)
		return FALSE
	var/population = round_active_players()
	if(!isnull(wave.min_pop) && population < wave.min_pop)
		return FALSE
	if(!isnull(wave.max_pop) && population > wave.max_pop)
		return FALSE
	return !wave_maxed(wave)

/datum/controller/subsystem/rogue_migrants/proc/wave_maxed(datum/rogue_migrant_wave/wave)
	return !isnull(wave.max_spawns) && spawned_waves[wave.shared_wave_type || wave.type] >= wave.max_spawns

/datum/controller/subsystem/rogue_migrants/proc/roll_wave(track)
	var/list/weighted = list()
	for(var/wave_type in GLOB.rogue_migrant_waves)
		var/datum/rogue_migrant_wave/wave = ROGUE_MIGRANT_WAVE(wave_type)
		if(wave.track != track || !wave_eligible(wave))
			continue
		if(wave_cooldown[wave_type] && world.time < wave_cooldown[wave_type])
			continue
		weighted[wave_type] = triumph_weight(wave)
	if(!length(weighted))
		return null
	return pick_weight(weighted)

/// A wave's roll weight with its pledged triumphs (Ratwood calculate_triumph_weight()).
/datum/controller/subsystem/rogue_migrants/proc/triumph_weight(datum/rogue_migrant_wave/wave)
	return max(round(wave.weight + wave.triumph_total * rogue_value("triumph_wave_weight")), 1)

/datum/controller/subsystem/rogue_migrants/proc/pledged_by(ckey, wave_type)
	var/list/by_wave = pledges[ckey]
	return by_wave ? (by_wave[wave_type] || 0) : 0

/// A lobby player pledges triumphs to a wave (Ratwood contribute_triumph_to_wave()).
/datum/controller/subsystem/rogue_migrants/proc/pledge(client/player, wave_type, amount)
	var/datum/rogue_migrant_wave/wave = ROGUE_MIGRANT_WAVE(wave_type)
	if(!player?.ckey || !wave || wave.hidden || !wave.can_roll || wave.is_raid || amount < 1)
		return FALSE
	var/have = rogue_get_triumphs(player.ckey)
	if(have < amount)
		to_chat(player, span_warning("You don't have enough triumph! You have [have], need [amount]."))
		return FALSE
	rogue_adjust_triumphs(player.ckey, -amount)
	wave.triumph_contributions[player.ckey] += amount
	wave.triumph_total += amount
	var/list/by_wave = pledges[player.ckey] || list()
	by_wave[wave_type] += amount
	pledges[player.ckey] = by_wave
	to_chat(player, span_notice("You've contributed [amount] triumph to '[wave.name]'. Total: [wave.triumph_total]/[wave.triumph_threshold]"))
	log_game("Migrants: [key_name(player)] pledged [amount] triumph to [wave_type].")
	if(wave.triumph_total >= wave.triumph_threshold)
		message_admins("TRIUMPH: Wave '[wave.name]' has reached its triumph threshold ([wave.triumph_total]/[wave.triumph_threshold]) and will be prioritized!")
		log_game("Migrants: wave [wave_type] reached its triumph threshold.")
	update_panels()
	return TRUE

/// The wave arrived: its pledges are spent (Ratwood reset_wave_contributions()).
/datum/controller/subsystem/rogue_migrants/proc/clear_pledges(datum/rogue_migrant_wave/wave)
	wave.triumph_contributions = list()
	wave.triumph_total = 0
	for(var/ckey in pledges)
		var/list/by_wave = pledges[ckey]
		by_wave -= wave.type

/// The wave of the triumph track scattered: its pledges go back (Ratwood refund_wave_contributions()).
/datum/controller/subsystem/rogue_migrants/proc/refund_pledges(datum/rogue_migrant_wave/wave)
	for(var/ckey in wave.triumph_contributions)
		var/amount = wave.triumph_contributions[ckey]
		if(amount <= 0)
			continue
		rogue_adjust_triumphs(ckey, amount)
		var/client/player = GLOB.directory[ckey]
		if(player)
			to_chat(player, span_nicegreen("[wave.name] failed to arrive - your [amount] pledged triumph has been refunded."))
	clear_pledges(wave)

/// Tells the lobby that a special wave is forming, with a link to the panel.
/datum/controller/subsystem/rogue_migrants/proc/announce_wave(wave_type)
	var/datum/rogue_migrant_wave/wave = ROGUE_MIGRANT_WAVE(wave_type)
	if(wave.hidden || (last_announce && world.time - last_announce < announce_interval))
		return
	last_announce = world.time
	var/list/needs = list()
	for(var/role_type in wave.required_roles)
		var/datum/rogue_migrant_role/role = ROGUE_MIGRANT_ROLE(role_type)
		needs += "[wave.required_roles[role_type]] [role.name]"
	var/list/slots = list()
	for(var/role_type in wave.optional_roles)
		var/datum/rogue_migrant_role/role = ROGUE_MIGRANT_ROLE(role_type)
		slots += "[wave.optional_roles[role_type]] [role.name]"
	var/line = "<b>A wave is forming: [wave.name]</b>"
	if(length(needs))
		line += "<br>Needs: [needs.Join(", ")]."
	if(length(slots))
		line += "<br>Slots open for [slots.Join(", ")]."
	line += "<br><a href='byond://?src=[REF(src)];rogue_migrant_panel=1'>Click to join.</a> [wave_wait_time / (1 SECONDS)]s remaining."
	for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
		if(player.client)
			to_chat(player, span_purple(line))

/datum/controller/subsystem/rogue_migrants/Topic(href, list/href_list)
	. = ..()
	if(href_list["rogue_migrant_panel"] && isnewplayer(usr))
		usr.client?.prefs?.rogue_migrant().ui_interact(usr)

/datum/controller/subsystem/rogue_migrants/proc/update_panels()
	for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
		var/datum/rogue_migrant_pref/pref = player.client?.prefs?.rogue_migrant
		if(pref)
			SStgui.update_uis(pref)

/// Lobby players queued for any wave.
/datum/controller/subsystem/rogue_migrants/proc/active_migrants()
	. = list()
	for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
		if(player.client?.prefs?.rogue_migrant?.queued_wave)
			. += player.client

/datum/controller/subsystem/rogue_migrants/proc/wave_candidates(wave_type)
	. = list()
	for(var/client/client as anything in active_migrants())
		if(client.prefs.rogue_migrant.queued_wave == wave_type)
			. += client

/datum/controller/subsystem/rogue_migrants/proc/queued_on_role(role_type)
	. = 0
	for(var/client/client as anything in active_migrants())
		if(client.prefs.rogue_migrant.queued_role == role_type)
			.++

/datum/controller/subsystem/rogue_migrants/proc/round_active_players()
	. = 0
	for(var/mob/living/carbon/human/player in GLOB.player_list)
		if(player.client && player.stat != DEAD && !player.client.is_afk())
			.++

/// Lets an admin start a wave forming on its track now.
/datum/controller/subsystem/rogue_migrants/proc/force_wave(mob/admin)
	var/wave_type = tgui_input_list(admin, "Choose the migrant wave to form", "Migrants", GLOB.rogue_migrant_waves)
	if(!wave_type)
		return
	var/datum/rogue_migrant_wave/wave = ROGUE_MIGRANT_WAVE(wave_type)
	message_admins("[key_name_admin(admin)] forced the migrant wave [wave.name].")
	log_admin("[key_name(admin)] forced the migrant wave [wave_type].")
	begin_forming(wave.track, wave_type, forced = TRUE)

ADMIN_VERB(rogue_force_migrant_wave, R_ADMIN, "Force Migrant Wave", "Start a migrant wave forming now.", ADMIN_CATEGORY_ROGUE)
	SSrogue_migrants.force_wave(user.mob)

/datum/preferences
	/// The player's place in the migrant queue.
	var/datum/rogue_migrant_pref/rogue_migrant

/datum/preferences/proc/rogue_migrant()
	if(!rogue_migrant)
		rogue_migrant = new(src)
	return rogue_migrant

/// A player's place in the migrant queue and their migrant panel (Ratwood's migrant_pref and MigrantPanel).
/datum/rogue_migrant_pref
	var/datum/preferences/prefs
	/// The wave the player is queued for, or null.
	var/queued_wave
	/// The role in it the player wants, or null for any.
	var/queued_role

/datum/rogue_migrant_pref/New(datum/preferences/prefs)
	src.prefs = prefs

/datum/rogue_migrant_pref/Destroy()
	prefs = null
	return ..()

/datum/rogue_migrant_pref/proc/queue_for(wave_type, role_type)
	var/datum/rogue_migrant_wave/wave = ROGUE_MIGRANT_WAVE(wave_type)
	if(!wave || (wave.hidden && !SSrogue_migrants.is_forced_forming(wave_type)))
		return
	if(role_type && !(role_type in wave.role_types()))
		return
	if(role_type && !SSrogue_migrants.can_be_role(prefs.parent, role_type))
		to_chat(prefs.parent, span_warning("You can't be this role."))
		return
	queued_wave = wave_type
	queued_role = role_type
	var/datum/rogue_migrant_role/role = role_type && ROGUE_MIGRANT_ROLE(role_type)
	to_chat(prefs.parent, span_nicegreen("You are queued for [wave.name][role ? " as the [role.name]" : ""]. This does not guarantee a slot."))

/datum/rogue_migrant_pref/proc/clear_queue(silent = FALSE)
	if(!queued_wave)
		return
	queued_wave = null
	queued_role = null
	if(!silent)
		to_chat(prefs.parent, span_boldwarning("You are no longer in the migrant queue."))

/datum/rogue_migrant_pref/proc/post_spawn()
	clear_queue(silent = TRUE)
	SStgui.close_uis(src)

/datum/rogue_migrant_pref/ui_state(mob/user)
	return GLOB.new_player_state

/datum/rogue_migrant_pref/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RogueMigrantPanel", "Migration")
		ui.open()

/datum/rogue_migrant_pref/ui_data(mob/user)
	var/list/data = list(
		"server_time" = world.time,
		"wave_number" = SSrogue_migrants.wave_number,
		"active_migrants" = length(SSrogue_migrants.active_migrants()),
		"queued_wave" = queued_wave ? "[queued_wave]" : null,
		"queued_role" = queued_role ? "[queued_role]" : null,
		"next_regular_at" = SSrogue_migrants.track_next_roll[ROGUE_MIGRANT_TRACK_REGULAR],
		"next_special_at" = SSrogue_migrants.track_next_roll[ROGUE_MIGRANT_TRACK_SPECIAL],
		"player_triumph" = rogue_get_triumphs(prefs.parent?.ckey),
	)
	var/list/forming = list()
	for(var/track in list(ROGUE_MIGRANT_TRACK_REGULAR, ROGUE_MIGRANT_TRACK_SPECIAL, ROGUE_MIGRANT_TRACK_TRIUMPH))
		var/wave_type = SSrogue_migrants.track_forming[track]
		if(!wave_type)
			continue
		var/datum/rogue_migrant_wave/wave = ROGUE_MIGRANT_WAVE(wave_type)
		if(wave.hidden && !SSrogue_migrants.track_forced[track])
			continue
		forming += list(list(
			"track" = track,
			"ref" = "[wave_type]",
			"name" = wave.name,
			"arrival_at" = SSrogue_migrants.track_arrival[track],
			"queued" = queued_wave == wave_type,
			"min_optional_fills" = wave.min_optional_fills,
			"roles" = role_rows(wave),
		))
	data["forming"] = forming

	var/list/track_weight = list()
	for(var/wave_type in GLOB.rogue_migrant_waves)
		var/datum/rogue_migrant_wave/wave = ROGUE_MIGRANT_WAVE(wave_type)
		if(!wave.hidden && wave.can_roll && !wave.is_raid)
			track_weight[wave.track] += SSrogue_migrants.triumph_weight(wave)
	var/ckey = prefs.parent?.ckey
	var/list/waves = list()
	for(var/wave_type in GLOB.rogue_migrant_waves)
		var/datum/rogue_migrant_wave/wave = ROGUE_MIGRANT_WAVE(wave_type)
		if(wave.hidden || !wave.can_roll || wave.is_raid)
			continue
		var/locked_until = 0
		if(wave.min_round_time && (world.time - SSticker.round_start_time) < wave.min_round_time)
			locked_until = SSticker.round_start_time + wave.min_round_time
		waves += list(list(
			"ref" = "[wave_type]",
			"name" = wave.name,
			"track" = wave.track,
			"roll_chance" = track_weight[wave.track] ? round(SSrogue_migrants.triumph_weight(wave) / track_weight[wave.track] * 100, 0.1) : 0,
			"maxed" = SSrogue_migrants.wave_maxed(wave),
			"locked_until" = locked_until,
			"min_optional_fills" = wave.min_optional_fills,
			"roles" = role_rows(wave),
			"triumph_total" = wave.triumph_total,
			"triumph_threshold" = wave.triumph_threshold,
			"my_contribution" = (ckey && wave.triumph_contributions[ckey]) || 0,
		))
	data["waves"] = waves
	return data

/datum/rogue_migrant_pref/proc/role_rows(datum/rogue_migrant_wave/wave)
	. = list()
	for(var/role_type in wave.required_roles)
		. += list(role_row(role_type, wave.required_roles[role_type], "required"))
	for(var/role_type in wave.optional_roles)
		. += list(role_row(role_type, wave.optional_roles[role_type], "optional"))

/datum/rogue_migrant_pref/proc/role_row(role_type, amount, kind)
	var/datum/rogue_migrant_role/role = ROGUE_MIGRANT_ROLE(role_type)
	var/list/classes = list()
	for(var/path in role.rockhill_advclasses)
		var/datum/rockhill_advclass/advclass = rockhill_advclass(path)
		if(advclass)
			classes += advclass.name
	return list(
		"ref" = "[role_type]",
		"name" = role.name,
		"amount" = amount,
		"kind" = kind,
		"stars" = SSrogue_migrants.queued_on_role(role_type),
		"queued" = queued_role == role_type,
		"can_be" = SSrogue_migrants.can_be_role(prefs.parent, role_type),
		"desc" = role.greet_text,
		"classes" = classes,
	)

/datum/rogue_migrant_pref/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("queue_role")
			var/wave_type = text2path(params["wave"])
			var/role_type = text2path(params["role"])
			if(!(wave_type in GLOB.rogue_migrant_waves))
				return TRUE
			if(queued_wave == wave_type && queued_role == role_type)
				clear_queue()
			else
				queue_for(wave_type, role_type)
			return TRUE
		if("clear_queue")
			clear_queue()
			return TRUE
		if("pledge")
			var/wave_type = text2path(params["wave"])
			if(wave_type in GLOB.rogue_migrant_waves)
				pledge_prompt(wave_type)
			return TRUE

/// Asks how many triumphs to pledge to the wave (Ratwood handle_triumph_contribution()).
/datum/rogue_migrant_pref/proc/pledge_prompt(wave_type)
	var/client/player = prefs.parent
	var/datum/rogue_migrant_wave/wave = ROGUE_MIGRANT_WAVE(wave_type)
	if(!player || !wave || wave.hidden || !wave.can_roll || wave.is_raid)
		return
	var/have = rogue_get_triumphs(player.ckey)
	if(have <= 0)
		to_chat(player, span_warning("You don't have any triumph to contribute!"))
		return
	var/most = min(have, rogue_value("triumph_wave_max_pledge"))
	var/amount = tgui_input_number(player.mob, "Contribute triumph to '[wave.name]'?\n\nYour triumph: [have]\nYour contribution: [wave.triumph_contributions[player.ckey] || 0]\nWave total: [wave.triumph_total]/[wave.triumph_threshold]", "Triumph Contribution", 1, most, 1)
	if(!amount || QDELETED(src) || !prefs.parent)
		return
	SSrogue_migrants.pledge(prefs.parent, wave_type, min(amount, most))

#undef ROGUE_MIGRANT_TRACK_REGULAR
#undef ROGUE_MIGRANT_TRACK_SPECIAL
#undef ROGUE_MIGRANT_TRACK_TRIUMPH
#undef ROGUE_MIGRANT_ROLE
#undef ROGUE_MIGRANT_WAVE
