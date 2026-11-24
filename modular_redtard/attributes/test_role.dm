/datum/map_config/var/rogue_lowmem = FALSE

/datum/map_config/LoadConfig(filename, error_if_missing)
	. = ..()
	var/list/map_json = .
	if(islist(map_json))
		rogue_lowmem = !!map_json[ROGUE_LOWMEM_MARKER]
		// The light launch is for a quick test round (maps/lowmem.dm): the preview icons TG regenerates at every start on a
		// developer's machine (GENERATE_ASSETS_IN_INIT of TG's config, the Map Previews and Greyscale Previews
		// subsystems, 3.3 s) are of no use to it. The current map's config is loaded in SSmapping.PreInit(), before
		// either of them initializes.
		if(rogue_lowmem)
			CONFIG_SET(flag/generate_assets_in_init, FALSE)
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
	if(rogue_combat_enabled())
		spawned.rogue_max_attributes()
