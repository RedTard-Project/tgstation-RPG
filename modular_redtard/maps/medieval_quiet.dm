/proc/rogue_station_events_enabled()
	return SSmapping.current_map?.map_era != MAP_ERA_MEDIEVAL

/datum/centcom_announcer/rogue
	welcome_sounds = list('modular_redtard/rockhill/sound/misc/roundstart.ogg')
	alert_sounds = list('modular_redtard/rockhill/sound/misc/bell.ogg')
	command_report_sounds = list('modular_redtard/rockhill/sound/misc/notice.ogg')

/datum/centcom_announcer/rogue/New()
	. = ..()
	var/datum/centcom_announcer/default/station_announcer = new
	for(var/sound_key in station_announcer.event_sounds)
		event_sounds[sound_key] = alert_sounds[1]
	qdel(station_announcer)

/datum/controller/subsystem/processing/station/Initialize()
	if(!rogue_station_events_enabled())
		announcer = /datum/centcom_announcer/rogue
	return ..()

/datum/controller/subsystem/processing/station/SetupTraits()
	if(!rogue_station_events_enabled())
		return
	return ..()

/datum/controller/subsystem/events/Initialize()
	. = ..()
	if(!rogue_station_events_enabled())
		can_fire = FALSE

/datum/controller/subsystem/dynamic/select_roundstart_antagonists()
	if(rogue_station_events_enabled())
		return ..()
	load_config()
	if(!current_tier)
		set_tier(/datum/dynamic_tier/greenshift, 0)
	force_extended()
	antag_events_enabled = FALSE
	can_fire = FALSE
	log_dynamic("Medieval map: no station antagonists, midrounds or latejoin rulesets.")
	return TRUE

/datum/communciations_controller/queue_roundstart_report()
	if(!rogue_station_events_enabled())
		return
	return ..()

/obj/docking_port/mobile/hyperspace_sound(phase, list/areas)
	if(!rogue_station_events_enabled())
		return
	return ..()

/area/shuttle/arrival/on_joining_game(mob/living/boarder)
	if(!rogue_station_events_enabled())
		return
	return ..()

/area/space
	/// Set while TG's add_base_lighting() runs on a medieval map: the turf walk then sees only CentCom's levels.
	var/rogue_starlight_centcom_only = FALSE

/// On medieval maps space keeps its starlight only on CentCom's levels, where the title screen stands. Elsewhere space
/// only fills what the other levels leave empty: the world is 255×430 on every level and the dungeons and camps take a
/// corner of theirs, hundreds of thousands of tiles nobody plays on. TG gives every one of them light while the area
/// initialises, one loop long enough for BYOND to report an infinite one at every start.
/area/space/add_base_lighting()
	if(rogue_station_events_enabled())
		return ..()
	rogue_starlight_centcom_only = TRUE
	. = ..()
	rogue_starlight_centcom_only = FALSE

/area/space/get_turfs_by_zlevel(zlevel)
	if(rogue_starlight_centcom_only && !is_centcom_level(zlevel))
		return list()
	return ..()
