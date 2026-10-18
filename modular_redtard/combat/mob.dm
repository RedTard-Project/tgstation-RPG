/proc/rogue_combat_enabled()
	return SSmapping.current_map?.map_era == MAP_ERA_MEDIEVAL

/mob/living/carbon/human/Initialize(mapload)
	. = ..()
	if(!rogue_combat_enabled())
		return
	AddElement(/datum/element/rogue_armor_wearer)
	AddElement(/datum/element/rogue_defender)
