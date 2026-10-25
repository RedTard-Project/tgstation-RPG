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

#undef REDTARD_FULL_CENTCOM_NAME
#undef REDTARD_FULL_CENTCOM_PATH
#undef REDTARD_FULL_CENTCOM_FILE
