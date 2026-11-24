/// The module's combat (and what goes by it) on medieval maps and in the light launch on any map (rogue_lowmem, owner's
/// decision 2026-11-22: on Runtime Station in the light launch blows, blood and pain are the module's, not TG's). Modern maps
/// outside the light launch stay as in TG.
/proc/rogue_combat_enabled()
	return SSmapping.current_map?.map_era == MAP_ERA_MEDIEVAL || SSmapping.current_map?.rogue_lowmem

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
