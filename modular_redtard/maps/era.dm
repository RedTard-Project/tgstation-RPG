/datum/map_config/var/map_era = MAP_ERA_MODERN

/// The round runs on a medieval map: the gate of everything medieval that is not the fight itself. The light launch loads
/// its test map as a medieval one (owner's decision 2026-11-24: build_modular.ts writes "era": "medieval" into the map
/// config it launches), so every rule of Roguetown runs there. Launched with --era modern, the test map keeps its own era
/// and only the module's combat is on (rogue_combat_enabled(), combat/mob.dm): the lobby, the character menu, the races,
/// survival, crafting, PvE and the rest stay off.
/proc/rogue_medieval_map()
	return SSmapping.current_map?.map_era == MAP_ERA_MEDIEVAL

/datum/map_config/LoadConfig(filename, error_if_missing)
	. = ..()
	if(!.)
		return .
	var/list/map_json = json_decode(file2text(file(filename)))
	var/era = LOWER_TEXT("[map_json?["era"] || MAP_ERA_MODERN]")
	if(era != MAP_ERA_MODERN && era != MAP_ERA_MEDIEVAL)
		log_world("map_config [filename]: unknown era [era], loading it as [MAP_ERA_MODERN]")
		era = MAP_ERA_MODERN
	map_era = era
	return .

/datum/job/var/map_era = MAP_ERA_MODERN

/datum/job/assistant/map_era = JOB_ERA_ANY
