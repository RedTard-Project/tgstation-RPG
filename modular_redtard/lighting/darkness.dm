/atom/movable/screen/plane_master/rendering_plate/transparent/Initialize(mapload, datum/hud/hud_owner, datum/plane_master_group/home, offset)
	. = ..()
	if(!rogue_light_map_enabled())
		return
	var/shade = CONFIG_GET(number/rogue_lower_level_shade)
	color = list(shade, 0, 0, 0, 0, shade, 0, 0, 0, 0, shade, 0, 0, 0, 0, 1, 0, 0, 0, 0)

/mob/living/carbon/human/restore_initial_sight()
	. = ..()
	if(rogue_light_map_enabled())
		lighting_cutoff = max(lighting_cutoff, CONFIG_GET(number/rogue_darkness_floor))
