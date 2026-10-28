/proc/rogue_combat_enabled()
	return SSmapping.current_map?.map_era == MAP_ERA_MEDIEVAL

/mob/living/carbon/human/Initialize(mapload)
	. = ..()
	if(!rogue_combat_enabled())
		return
	AddElement(/datum/element/rogue_combat)
	AddElement(/datum/element/rogue_energy)
	AddElement(/datum/element/rogue_blood)
	AddElement(/datum/element/rogue_pain)
	rogue_update_fov()
	if(rogue_sight_shadows_enabled())
		AddComponent(/datum/component/rogue_sight_shadows)
