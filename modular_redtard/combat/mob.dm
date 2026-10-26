/proc/rogue_combat_enabled()
	return SSmapping.current_map?.map_era == MAP_ERA_MEDIEVAL

/mob/living/carbon/human/Initialize(mapload)
	. = ..()
	if(!rogue_combat_enabled())
		return
	AddElement(/datum/element/rogue_combat_bus)
	AddElement(/datum/element/rogue_energy)
	add_fov_trait(ROGUE_FOV_SOURCE, FOV_90_DEGREES)
	if(rogue_sight_shadows_enabled())
		AddComponent(/datum/component/rogue_sight_shadows)
