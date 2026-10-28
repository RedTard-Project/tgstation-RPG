/// Loads the mechanics registry (mechanics/registry.dm) while the world initializes: values.txt, formulas.txt and the armor,
/// intent and item tables of config/redtard/mechanics are read and parsed here, in the early stage before the map and its
/// items, so nothing in the round pays for them on first use and the init log shows what the load costs.
/// rogue_mechanics() still loads the registry itself when something asks before this subsystem; the log then says so.
SUBSYSTEM_DEF(rogue_mechanics)
	name = "Rogue Mechanics"
	ss_flags = SS_NO_FIRE
	init_stage = INITSTAGE_EARLY

/datum/controller/subsystem/rogue_mechanics/Initialize()
	if(GLOB.rogue_mechanics)
		log_world("Rogue mechanics: the registry was loaded on first use, before its subsystem initialized.")
	rogue_mechanics()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/rogue_mechanics/stat_entry(msg)
	var/datum/rogue_mechanics/mechanics = GLOB.rogue_mechanics
	if(mechanics)
		msg = "Entries:[length(mechanics.formulas)] Problems:[length(mechanics.problems)]"
	return ..()
