/atom/movable/screen/plane_master/rogue_sun
	name = "Rogue sunlight"
	documentation = "Sunlight that the medieval sky spills indoors. The library draws it white on its own plane, and this plane master tints it with the sky colour,\
		<br>so a sky change recolours one plane per client instead of relighting every turf the sun reaches."
	plane = ROGUE_SUN_PLANE
	appearance_flags = PLANE_MASTER|NO_CLIENT_COLOR
	render_relay_planes = list(RENDER_PLANE_TURF_LIGHTING)
	blend_mode_override = BLEND_ADD
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	critical = PLANE_CRITICAL_DISPLAY

/atom/movable/screen/plane_master/rogue_sun/Initialize(mapload, datum/hud/hud_owner, datum/plane_master_group/home, offset)
	start_hidden = !SSrogue_light.splits_sun()
	. = ..()
	color = GLOB.starlight_color
	RegisterSignal(SSdcs, COMSIG_STARLIGHT_COLOR_CHANGED, PROC_REF(sky_changed))

/atom/movable/screen/plane_master/rogue_sun/Destroy()
	UnregisterSignal(SSdcs, COMSIG_STARLIGHT_COLOR_CHANGED)
	return ..()

/atom/movable/screen/plane_master/rogue_sun/proc/sky_changed(datum/source, old_color, new_color)
	SIGNAL_HANDLER
	color = new_color

/proc/rogue_light_refresh_sun_planes()
	var/split = SSrogue_light.splits_sun()
	for(var/mob/viewer as anything in GLOB.player_list)
		var/datum/hud/hud = viewer.hud_used
		if(!hud)
			continue
		for(var/atom/movable/screen/plane_master/rogue_sun/sun as anything in hud.get_true_plane_masters(ROGUE_SUN_PLANE))
			if(split)
				sun.unhide_plane(viewer)
			else
				sun.hide_plane(viewer)

/proc/rogue_light_sky_level(sky_color)
	var/list/channels = rgb2num(sky_color)
	return (channels[1] + channels[2] + channels[3]) / (3 * 255)
