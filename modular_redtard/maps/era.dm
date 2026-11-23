/datum/map_config/var/map_era = MAP_ERA_MODERN

/// The round runs on a medieval map: the gate of everything medieval that is not the fight itself. The light launch turns
/// the module's combat on on any map (rogue_combat_enabled(), combat/mob.dm), and nothing else: the lobby, the character
/// menu, the races, survival, crafting, PvE and the world of Rockhill stay with the era of the map.
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
