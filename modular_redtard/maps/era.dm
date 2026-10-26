/datum/map_config/var/map_era = MAP_ERA_MODERN

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
