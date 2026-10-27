/// Creatures far from players sleep, as Vibelin has it (controllers/subsystem/mobs/_mobs.dm, subsystem/ai_controller.dm): on a
/// medieval map a mob without a client lives (SSmobs Life) only while a living player is within ROGUE_MOB_AWAKE_RANGE tiles,
/// and its mind thinks only while a player is in the grid cells around it.
///
/// TG already puts a mind to sleep when no client is near, but never on the station, and every Rockhill area is a station
/// area (/area/rogue), so here every mind would think all round; TG's SSmobs runs the Life of every living mob everywhere.
/datum/config_entry/flag/rogue_mob_sleep
	default = TRUE

/datum/config_entry/number/rogue_mob_awake_range
	default = 15
	integer = TRUE
	min_val = 1
	max_val = 60

/proc/rogue_mob_sleep_enabled()
	return CONFIG_GET(flag/rogue_mob_sleep) && rogue_combat_enabled()

/// A fresh run lives only the awake; a resumed one goes on with the list it was building.
/datum/controller/subsystem/mobs/fire(resumed = FALSE)
	if(resumed || !rogue_mob_sleep_enabled())
		return ..()
	currentrun = rogue_awake_mobs()
	return ..(TRUE)

/// Every living player, and every living mob in the hearing cells within range of one.
/datum/controller/subsystem/mobs/proc/rogue_awake_mobs()
	var/list/awake = list()
	var/list/seen_cells = list()
	var/range = CONFIG_GET(number/rogue_mob_awake_range)
	for(var/list/players as anything in clients_by_zlevel)
		for(var/mob/living/player as anything in players)
			awake[player] = TRUE
			var/turf/spot = get_turf(player)
			if(!spot)
				continue
			for(var/datum/spatial_grid_cell/cell as anything in SSspatial_grid.get_cells_in_range(spot, range))
				if(seen_cells[cell])
					continue
				seen_cells[cell] = TRUE
				for(var/mob/living/neighbour in cell.hearing_contents)
					awake[neighbour] = TRUE
	return awake

/// The station rule of TG does not hold on Rockhill: a mind there with no client around goes to sleep (or to low priority
/// if it runs unwatched) and wakes when a living client enters its cells, as everywhere off the station.
/datum/ai_controller/get_active_ai_status()
	. = ..()
	if(. != AI_STATUS_ON || !istype(get_area(pawn), /area/rogue) || has_nearby_client())
		return
	if(!(ai_traits & RUN_WHILE_UNWATCHED))
		return AI_STATUS_OFF
	if(!(ai_traits & ALWAYS_HIGH_PRIORITY))
		return AI_STATUS_ON_LOW
