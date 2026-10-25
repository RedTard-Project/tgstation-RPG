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
