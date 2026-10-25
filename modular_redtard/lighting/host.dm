var/global/rogue_host_unthrottle = "not tried"

/world/New()
	if(world.system_type == MS_WINDOWS)
		var/path = rogue_light_library_path("rogue_light")
		if(path)
			try
				rogue_host_unthrottle = call_ext(path, "byond:rlight_unthrottle")()
			catch(var/exception/error)
				rogue_host_unthrottle = "failed: [error]"
	return ..()

/datum/controller/subsystem/rogue_light/Initialize()
	log_world("Rogue host: Windows power throttling opt-out [rogue_host_unthrottle] (1 = no EcoQoS, 2 = 1 ms timer, 3 = both)")
	return ..()
