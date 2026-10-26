/proc/rogue_map_has_shuttles()
	return SSmapping.current_map?.map_era != MAP_ERA_MEDIEVAL

/datum/controller/subsystem/shuttle/Initialize()
	. = ..()
	if(!rogue_map_has_shuttles())
		can_fire = FALSE

/datum/controller/subsystem/mapping/preloadShuttleTemplates()
	if(!rogue_map_has_shuttles())
		return
	return ..()

/datum/dynamic_ruleset/midround/pirates/can_be_selected()
	return rogue_map_has_shuttles() && ..()

/datum/dynamic_ruleset/midround/from_ghosts/nukies/can_be_selected()
	return rogue_map_has_shuttles() && ..()

/datum/dynamic_ruleset/midround/from_ghosts/fugitives/can_be_selected()
	return rogue_map_has_shuttles() && ..()

/datum/dynamic_ruleset/roundstart/nukies/can_be_selected()
	return rogue_map_has_shuttles() && ..()

/datum/round_event_control/shuttle_catastrophe/can_spawn_event(players_amt, allow_magic = FALSE)
	return rogue_map_has_shuttles() && ..()

/datum/round_event_control/shuttle_insurance/can_spawn_event(players_amt, allow_magic = FALSE)
	return rogue_map_has_shuttles() && ..()

/datum/round_event_control/shuttle_loan/can_spawn_event(players_amt, allow_magic = FALSE)
	return rogue_map_has_shuttles() && ..()
