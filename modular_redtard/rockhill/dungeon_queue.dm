/// Building the dungeon in the lobby (block H2, task H2a). The world reaches the lobby without the Rockhill dungeon (about 36 s of
/// its start): SSrockhill_dungeon parses its templates and lays its rooms in its fires while the players wait, as much of each
/// tick as the controller leaves it, and the dungeon entries stay shut until it is done. Nothing waits on the build: the round
/// starts on the lobby countdown as always, a build still going on goes on in the round, and a timer opens the entries after
/// rockhill_dungeon_lobby_build_timeout whatever the build has come to (world log, admins told; the rest is then laid at the
/// pace of a round). A marker or template that fails is logged and skipped. ROGUE_DUNGEON_IN_LOBBY 0 in config/redtard/config.txt builds it while the world loads, as before.

/// On by default; 0 builds the dungeon while the world loads.
/datum/config_entry/flag/rogue_dungeon_in_lobby
	default = TRUE

/// Whether this start builds the dungeon in the lobby: on medieval maps with ROGUE_DUNGEON_IN_LOBBY on. Unit tests build it
/// while the world loads, so that it is all there when they run.
/proc/rogue_dungeon_in_lobby()
#ifdef UNIT_TESTS
	return FALSE
#else
	return CONFIG_GET(flag/rogue_dungeon_in_lobby) && rogue_medieval_map()
#endif

/datum/controller/subsystem/rockhill_dungeon
	/// The lobby build is running: every fire parses templates and takes markers until the tick is spent.
	var/building = FALSE
	/// The entries do not let anyone down: from the start of the lobby build until it is done or times out.
	var/entries_shut = FALSE
	/// When the lobby build started, in game time and in real time.
	var/build_started = 0
	var/build_started_real = 0
	/// The timer that opens the entries if the build has not finished in time.
	var/build_deadline
	/// Markers the lobby build has taken and markers or templates that failed with an error.
	var/build_markers = 0
	var/build_errors = 0
	/// SSarea_contents is held while the build runs: the build moves thousands of turfs between areas and SSarea_contents would
	/// strike them off one by one, while rebuild_area_turfs() sets every list right in one pass at the end.
	var/area_contents_paused = FALSE
	var/area_contents_could_fire

/datum/controller/subsystem/rockhill_dungeon/stat_entry(msg)
	if(building)
		msg = "Building: T:[length(template_types_left)] M:[length(GLOB.rockhill_dungeon_markers)] P:[templates_loaded] E:[build_errors][entries_shut ? " shut" : ""]"
	else
		msg = "P:[templates_loaded] M:[length(GLOB.rockhill_dungeon_markers)]"
	return ..()

/// Whether the dungeon entries let anyone down (rockhill/dungeon.dm, /obj/structure/rockhill/dungeon_entry/use()).
/datum/controller/subsystem/rockhill_dungeon/proc/entries_open()
	return !entries_shut

/// Starts the lobby build from Initialize(). FALSE, and the dungeon is built while the world loads, if the timeout is not known.
/datum/controller/subsystem/rockhill_dungeon/proc/start_lobby_build()
	var/timeout
	try
		timeout = rogue_value("rockhill_dungeon_lobby_build_timeout")
	catch(var/exception/error)
		log_world("Rockhill dungeon: cannot read rockhill_dungeon_lobby_build_timeout ([error]).")
	if(!isnum(timeout) || timeout <= 0)
		log_world("Rockhill dungeon: no lobby build timeout, building while the world loads.")
		return FALSE
	// The timer first: whatever happens to the build from here, the entries open.
	build_deadline = addtimer(CALLBACK(src, PROC_REF(lobby_build_timed_out)), timeout, TIMER_STOPPABLE)
	building = TRUE
	entries_shut = TRUE
	build_started = world.time
	build_started_real = REALTIMEOFDAY
	build_markers = 0
	build_errors = 0
	pause_area_contents()
	log_world("Rockhill dungeon: building in the lobby: [length(template_types_left)] templates to parse, [length(GLOB.rockhill_dungeon_markers)] markers queued, entries shut for up to [round(timeout / 10, 0.1)] s.")
	return TRUE

/// One fire of the lobby build: templates first, then markers, each on its own so that a failing one is only skipped.
/datum/controller/subsystem/rockhill_dungeon/proc/lobby_build_fire()
	while(building && length(template_types_left))
		var/template_type = template_types_left[length(template_types_left)]
		try
			prepare_next_template()
		catch(var/exception/template_error)
			build_errors++
			log_world("Rockhill dungeon: template [template_type] failed: [template_error] ([template_error.file]:[template_error.line]).")
		if(MC_TICK_CHECK)
			return
	// The timeout may have come while a load slept: what is left goes at the pace of a round (fire() in dungeon.dm).
	if(!building)
		return
	while(building && length(GLOB.rockhill_dungeon_markers))
		var/obj/effect/rockhill/dungeon_helper/marker = GLOB.rockhill_dungeon_markers[1]
		// Off the queue before anything else: a marker is tried once, whatever happens to it.
		GLOB.rockhill_dungeon_markers.Cut(1, 2)
		build_markers++
		try
			process_marker(marker)
		catch(var/exception/marker_error)
			build_errors++
			log_world("Rockhill dungeon: the marker at [marker?.x],[marker?.y],[marker?.z] failed: [marker_error] ([marker_error.file]:[marker_error.line]).")
		if(MC_TICK_CHECK)
			return
	if(!length(GLOB.rockhill_dungeon_markers))
		finish_lobby_build()

/// The queue has run dry: the entries open, the area lists are set right, the time goes to the world log.
/datum/controller/subsystem/rockhill_dungeon/proc/finish_lobby_build()
	building = FALSE
	var/timed_out = !entries_shut
	open_entries()
	rebuild_area_turfs()
	resume_area_contents()
	log_world("Rockhill dungeon: built in the lobby in [round((world.time - build_started) / 10, 0.1)] s of game time, [round((REALTIMEOFDAY - build_started_real) / 10, 0.1)] s real: [templates_loaded] templates from [build_markers] markers, [build_errors] errors[timed_out ? ", the entries had opened on the timeout" : ""].")
	build_started = 0
	if(build_errors)
		message_admins("Rockhill dungeon: [build_errors] errors while building in the lobby, see the world log.")

/datum/controller/subsystem/rockhill_dungeon/proc/open_entries()
	entries_shut = FALSE
	if(build_deadline)
		deltimer(build_deadline)
		build_deadline = null

/// The build has not finished in time: the entries open anyway, and what is left is built at the pace of a round
/// (ROCKHILL_DUNGEON_MARKERS_PER_FIRE a fire, fire() in dungeon.dm), not at the lobby's whole-tick pace.
/datum/controller/subsystem/rockhill_dungeon/proc/lobby_build_timed_out()
	build_deadline = null
	if(!entries_shut)
		return
	entries_shut = FALSE
	building = FALSE
	resume_area_contents()
	var/message = "Rockhill dungeon: not built after [round((world.time - build_started) / 10, 0.1)] s, the entries open anyway and the rest is built at the pace of a round: [length(template_types_left)] templates unparsed, [length(GLOB.rockhill_dungeon_markers)] markers left, [templates_loaded] templates placed, [build_errors] errors, the subsystem [can_fire ? "fires" : "does not fire"]."
	log_world(message)
	message_admins(message)

/// The controller replaced the subsystem in the middle of a lobby build: the entries open and the rest is built at the pace
/// of a round (ROCKHILL_DUNGEON_MARKERS_PER_FIRE).
/datum/controller/subsystem/rockhill_dungeon/proc/recover_lobby_build(datum/controller/subsystem/rockhill_dungeon/old)
	if(!old.building && !old.entries_shut)
		return
	old.building = FALSE
	old.open_entries()
	old.resume_area_contents()
	log_world("Rockhill dungeon: the controller restarted the subsystem during the lobby build; the entries are open, the rest is built at the pace of a round.")

/datum/controller/subsystem/rockhill_dungeon/proc/pause_area_contents()
	if(area_contents_paused)
		return
	area_contents_could_fire = SSarea_contents.can_fire
	SSarea_contents.can_fire = FALSE
	area_contents_paused = TRUE

/datum/controller/subsystem/rockhill_dungeon/proc/resume_area_contents()
	if(!area_contents_paused)
		return
	area_contents_paused = FALSE
	if(!SSarea_contents.can_fire)
		SSarea_contents.can_fire = area_contents_could_fire
