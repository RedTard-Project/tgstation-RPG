/datum/controller/subsystem/air/Initialize()
	. = ..()
	if(SSmapping.current_map?.map_era == MAP_ERA_MEDIEVAL)
		can_fire = FALSE

/datum/controller/subsystem/machines/Initialize()
	. = ..()
	if(SSmapping.current_map?.map_era == MAP_ERA_MEDIEVAL)
		can_fire = FALSE
