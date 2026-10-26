/datum/map_config/var/rogue_lowmem = FALSE

/datum/map_config/LoadConfig(filename, error_if_missing)
	. = ..()
	var/list/map_json = .
	if(islist(map_json))
		rogue_lowmem = !!map_json[ROGUE_LOWMEM_MARKER]
	return .

/mob/living/proc/rogue_max_attributes()
	if(!attributes)
		return
	for(var/stat_type in GLOB.rogue_stats)
		rogue_adjust_stat(stat_type, ROGUE_ATTRIBUTE_MAX - ROGUE_NULLTOZERO(attributes.raw_attribute_list[stat_type]))
	for(var/skill_type in GLOB.rogue_skills)
		rogue_set_skill(skill_type, ROGUE_SKILL_MAX)

/datum/job/assistant/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	if(rogue_combat_enabled() || SSmapping.current_map?.rogue_lowmem)
		spawned.rogue_max_attributes()
