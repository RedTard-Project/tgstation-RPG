#define REDTARD_FULL_CENTCOM_NAME "CentCom"
#define REDTARD_FULL_CENTCOM_PATH "map_files/generic"
#define REDTARD_FULL_CENTCOM_FILE "CentCom.dmm"

/datum/controller/subsystem/mapping/loadWorld()
	. = ..()
	if(current_map?.map_era == MAP_ERA_MEDIEVAL)
		return
	var/list/failed = list()
	log_world("Loading [REDTARD_FULL_CENTCOM_NAME]...")
	LoadGroup(failed, REDTARD_FULL_CENTCOM_NAME, REDTARD_FULL_CENTCOM_PATH, REDTARD_FULL_CENTCOM_FILE, default_traits = ZTRAITS_CENTCOM)
	for(var/failure in failed)
		stack_trace("CentCom failed to load: [failure]")

/// CentCom_minimal, which medieval maps load, has TG's observer start by the title screen; loaded first, it is the one
/// TG's make_me_an_observer() finds, so every observer from the lobby stood on the title screen. On medieval maps it gives
/// way to the map's own observer starts.
/obj/effect/landmark/observer_start/Initialize(mapload)
	. = ..()
	if(SSmapping.current_map?.map_era == MAP_ERA_MEDIEVAL && is_centcom_level(z))
		return INITIALIZE_HINT_QDEL

#undef REDTARD_FULL_CENTCOM_NAME
#undef REDTARD_FULL_CENTCOM_PATH
#undef REDTARD_FULL_CENTCOM_FILE
