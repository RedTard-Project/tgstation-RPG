GLOBAL_LIST_EMPTY(rockhill_dungeon_markers)
GLOBAL_LIST_EMPTY(rockhill_dungeon_entries)
GLOBAL_LIST_EMPTY(rockhill_unlinked_dungeon_entries)
GLOBAL_LIST_EMPTY(rockhill_dungeon_exits)

/datum/map_template/dungeon
	abstract_type = /datum/map_template/dungeon
	// A dungeon loads each of its ~90 templates many times (659 loads in a Rockhill round): parse each .dmm once, not per load.
	keep_cached_map = TRUE
	var/rarity = 100
	var/type_weight = 1
	var/north_offset
	var/south_offset
	var/east_offset
	var/west_offset

/datum/map_template/dungeon/proc/offset_for(direction)
	switch(direction)
		if(NORTH)
			return north_offset
		if(SOUTH)
			return south_offset
		if(EAST)
			return east_offset
		if(WEST)
			return west_offset

/datum/map_template/dungeon/proc/spawn_turf(turf/creator, direction)
	switch(direction)
		if(WEST)
			return locate(creator.x, creator.y - west_offset, creator.z)
		if(NORTH)
			return locate(creator.x - north_offset, creator.y - (height - 1), creator.z)
		if(SOUTH)
			return locate(creator.x - south_offset, creator.y, creator.z)
		if(EAST)
			return locate(creator.x - (width - 1), creator.y - east_offset, creator.z)

/datum/map_template/dungeon/proc/fits(turf/creator, direction)
	if(!offset_for(direction))
		return FALSE
	var/turf/corner = spawn_turf(creator, direction)
	if(!corner || corner.x + width - 1 > world.maxx || corner.y + height - 1 > world.maxy)
		return FALSE
	for(var/turf/checked as anything in block(corner, locate(corner.x + width - 1, corner.y + height - 1, corner.z)))
		if(checked.type != /turf/closed/dungeon_void)
			return FALSE
	return corner

/obj/effect/rockhill/dungeon_helper
	name = "Dungeon Direction Helper"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x"
	invisibility = INVISIBILITY_ABSTRACT
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/top = FALSE

/obj/effect/rockhill/dungeon_helper/Initialize(mapload)
	. = ..()
	if(!(locate(/obj/effect/rockhill/dungeon_helper) in get_step(src, dir)))
		GLOB.rockhill_dungeon_markers |= src

/obj/effect/rockhill/dungeon_helper/Destroy(force)
	GLOB.rockhill_dungeon_markers -= src
	return ..()

/obj/structure/rockhill/dungeon_entry
	name = "The Tomb of Alotheos"
	desc = "Greedy fool, will you emerge rich and victorious, or be entombed forever?"
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/portal.dmi'
	icon_state = "portal"
	density = TRUE
	anchored = TRUE
	pixel_x = -48
	bound_width = 128
	appearance_flags = NONE
	opacity = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/dungeon_id
	var/claim_free_exit = FALSE
	var/target_exit_id
	var/list/obj/structure/rockhill/dungeon_exit/dungeon_exits = list()
	var/can_enter = TRUE

/obj/structure/rockhill/dungeon_entry/Initialize(mapload)
	. = ..()
	GLOB.rockhill_dungeon_entries |= src
	if(!dungeon_id || claim_free_exit)
		GLOB.rockhill_unlinked_dungeon_entries |= src
	if(dungeon_id)
		var/linked = FALSE
		for(var/obj/structure/rockhill/dungeon_exit/exit as anything in GLOB.rockhill_dungeon_exits)
			if(exit.dungeon_id != dungeon_id)
				continue
			linked = TRUE
			link_exit(exit)
		if(!linked && claim_free_exit)
			for(var/obj/structure/rockhill/dungeon_exit/free_exit as anything in GLOB.rockhill_dungeon_exits)
				if(free_exit.entry || (free_exit.dungeon_id && free_exit.dungeon_id != dungeon_id))
					continue
				free_exit.dungeon_id = dungeon_id
				link_exit(free_exit)
				linked = TRUE
				break
		if(linked)
			GLOB.rockhill_unlinked_dungeon_entries -= src
		return
	for(var/obj/structure/rockhill/dungeon_exit/exit as anything in shuffle(GLOB.rockhill_dungeon_exits))
		if(exit.dungeon_id)
			continue
		link_exit(exit)
		GLOB.rockhill_unlinked_dungeon_entries -= src
		break

/obj/structure/rockhill/dungeon_entry/proc/link_exit(obj/structure/rockhill/dungeon_exit/exit)
	dungeon_exits |= exit
	exit.entry = src
	exit.target_exit_id = target_exit_id

/obj/structure/rockhill/dungeon_entry/Destroy()
	for(var/obj/structure/rockhill/dungeon_exit/exit as anything in dungeon_exits)
		exit.entry = null
	dungeon_exits = null
	GLOB.rockhill_dungeon_entries -= src
	GLOB.rockhill_unlinked_dungeon_entries -= src
	return ..()

/obj/structure/rockhill/dungeon_entry/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	INVOKE_ASYNC(src, PROC_REF(use), user)
	return TRUE

/obj/structure/rockhill/dungeon_entry/attack_ghost(mob/dead/observer/user)
	if(length(dungeon_exits))
		user.abstract_move(get_turf(pick(dungeon_exits)))
		return TRUE
	return ..()

/obj/structure/rockhill/dungeon_entry/proc/use(mob/living/user)
	if(!can_enter || !length(dungeon_exits))
		return
	var/obj/structure/rockhill/dungeon_exit/exit = pick(dungeon_exits)
	playsound(src, 'modular_redtard/rockhill/sound/foley/ladder.ogg', 100, FALSE)
	if(!do_after(user, ROCKHILL_DUNGEON_TRAVEL_TIME, src) || QDELETED(exit))
		return
	user.forceMove(get_turf(exit))

/obj/structure/rockhill/dungeon_exit
	name = "dungeon exit"
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "ladder10"
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/dungeon_id
	var/target_exit_id
	var/obj/structure/rockhill/dungeon_entry/entry

/obj/structure/rockhill/dungeon_exit/Initialize(mapload)
	. = ..()
	GLOB.rockhill_dungeon_exits |= src
	if(dungeon_id)
		for(var/obj/structure/rockhill/dungeon_entry/found as anything in GLOB.rockhill_dungeon_entries)
			if(found.dungeon_id != dungeon_id)
				continue
			found.link_exit(src)
			GLOB.rockhill_unlinked_dungeon_entries -= found
		return
	for(var/obj/structure/rockhill/dungeon_entry/found as anything in shuffle(GLOB.rockhill_unlinked_dungeon_entries))
		if(found.dungeon_id && !found.claim_free_exit)
			continue
		if(found.dungeon_id)
			dungeon_id = found.dungeon_id
		found.link_exit(src)
		GLOB.rockhill_unlinked_dungeon_entries -= found
		break

/obj/structure/rockhill/dungeon_exit/examine(mob/user)
	. = ..()
	for(var/obj/structure/rockhill/dungeon_exit/other as anything in GLOB.rockhill_dungeon_exits)
		if(other != src && other.dungeon_id && other.dungeon_id == target_exit_id && other.z == z)
			. += span_notice("The exit seems to hum with a faint magical energy, pulling you toward the [dir2text(get_dir(src, other))].")
			break

/obj/structure/rockhill/dungeon_exit/Destroy()
	if(entry)
		entry.dungeon_exits -= src
	entry = null
	GLOB.rockhill_dungeon_exits -= src
	return ..()

/obj/structure/rockhill/dungeon_exit/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	INVOKE_ASYNC(src, PROC_REF(use), user)
	return TRUE

/obj/structure/rockhill/dungeon_exit/attack_ghost(mob/dead/observer/user)
	if(entry)
		user.abstract_move(get_turf(entry))
		return TRUE
	return ..()

/obj/structure/rockhill/dungeon_exit/proc/use(mob/living/user)
	if(!entry)
		return
	playsound(src, 'modular_redtard/rockhill/sound/foley/ladder.ogg', 100, FALSE)
	if(!do_after(user, ROCKHILL_DUNGEON_TRAVEL_TIME, src) || QDELETED(entry))
		return
	user.forceMove(get_turf(entry))

SUBSYSTEM_DEF(rockhill_dungeon)
	name = "Rockhill Dungeon"
	dependencies = list(
		/datum/controller/subsystem/mapping,
		/datum/controller/subsystem/atoms,
	)
	wait = 1 SECONDS
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT
	var/list/datum/map_template/dungeon/templates
	var/list/parent_weights
	var/list/placed_types = list()
	var/created_since = 0
	var/unlinked_entries = 0
	/// Z-levels templates were loaded on since their area turf lists were last rebuilt.
	var/list/loaded_zlevels = list()

/datum/controller/subsystem/rockhill_dungeon/Initialize()
	if(!length(GLOB.rockhill_dungeon_markers))
		can_fire = FALSE
		return SS_INIT_NO_NEED
	templates = list()
	for(var/template_type in valid_subtypesof(/datum/map_template/dungeon))
		var/datum/map_template/dungeon/template = new template_type
		templates[template] = template.rarity
	parent_weights = list()
	for(var/datum/map_template/dungeon/parent_type as anything in subtypesof(/datum/map_template/dungeon))
		if(initial(parent_type.abstract_type) == parent_type && initial(parent_type.type_weight))
			parent_weights[parent_type] = initial(parent_type.type_weight)
	unlinked_entries = length(GLOB.rockhill_unlinked_dungeon_entries)
	while(length(GLOB.rockhill_dungeon_markers))
		process_marker(GLOB.rockhill_dungeon_markers[1])
	rebuild_area_turfs()
	return SS_INIT_SUCCESS

/// The area turf lists of the levels templates were loaded on, set right in one pass (maps/area_turfs.dm).
/datum/controller/subsystem/rockhill_dungeon/proc/rebuild_area_turfs()
	rogue_rebuild_area_turfs(loaded_zlevels)
	loaded_zlevels.Cut()

/datum/controller/subsystem/rockhill_dungeon/fire(resumed)
	var/processed = 0
	while(length(GLOB.rockhill_dungeon_markers) && processed < ROCKHILL_DUNGEON_MARKERS_PER_FIRE)
		process_marker(GLOB.rockhill_dungeon_markers[1])
		processed++
		if(MC_TICK_CHECK)
			return
	if(!length(GLOB.rockhill_dungeon_markers) && length(loaded_zlevels))
		rebuild_area_turfs()

/datum/controller/subsystem/rockhill_dungeon/proc/process_marker(obj/effect/rockhill/dungeon_helper/marker)
	GLOB.rockhill_dungeon_markers -= marker
	var/turf/start = get_turf(marker)
	if(!start)
		return
	var/turf/creator = get_step(start, marker.dir)
	if(creator?.type != /turf/closed/dungeon_void || !GET_TURF_ABOVE(creator))
		return
	var/direction = REVERSE_DIR(marker.dir)
	var/datum/map_template/dungeon/picked_type = length(parent_weights) ? pick_weight(parent_weights) : null
	if(unlinked_entries > 0 && created_since > ROCKHILL_DUNGEON_ENTRY_SPACING)
		if(required_entries_missing() || prob(ROCKHILL_DUNGEON_ENTRY_CHANCE + created_since))
			picked_type = /datum/map_template/dungeon/entry
	if(picked_type && place_from(picked_type, creator, direction, TRUE))
		if(picked_type == /datum/map_template/dungeon/entry)
			created_since = 0
			unlinked_entries--
		return
	place_from(picked_type, creator, direction, FALSE)

/datum/controller/subsystem/rockhill_dungeon/proc/required_entries_missing()
	return placed_types[/datum/map_template/dungeon/entry] < ROCKHILL_DUNGEON_REQUIRED_ENTRIES

/datum/controller/subsystem/rockhill_dungeon/proc/place_from(picked_type, turf/creator, direction, inside_type)
	var/list/candidates = templates.Copy()
	while(length(candidates))
		var/datum/map_template/dungeon/template = pick_weight(candidates)
		candidates -= template
		var/matches = picked_type && istype(template, picked_type)
		if(inside_type ? !matches : (matches || istype(template, /datum/map_template/dungeon/entry)))
			continue
		var/turf/corner = template.fits(creator, direction)
		if(!corner || !template.load(corner))
			continue
		placed_types[template.type]++
		placed_types[/datum/map_template/dungeon/entry] += istype(template, /datum/map_template/dungeon/entry) ? 1 : 0
		loaded_zlevels |= corner.z
		created_since++
		return TRUE
	return FALSE
