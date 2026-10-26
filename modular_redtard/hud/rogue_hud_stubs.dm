/atom/movable/screen/proc/rogue_hud_not_implemented(mob/user)
	if(!ismob(user))
		return
	user.balloon_alert(user, ROGUE_HUD_STUB_TEXT)

/atom/movable/screen/rogue
	icon = ROGUE_HUD_ICON
	layer = ROGUE_HUD_LAYER

/atom/movable/screen/rogue/placeholder
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/screen/rogue/placeholder/grain
	icon = ROGUE_HUD_ICON_GRAIN
	icon_state = "grain"
	screen_loc = rogueui_screen_origin
	alpha = 0
	plane = HUD_PLANE
	layer = 13
	blend_mode = BLEND_MULTIPLY

/atom/movable/screen/rogue/placeholder/scannies
	icon = ROGUE_HUD_ICON_BACK
	icon_state = "crt"
	screen_loc = rogueui_backhudl
	alpha = 0
	plane = FULLSCREEN_PLANE
	layer = ROGUE_SCANNIES_LAYER
	blend_mode = BLEND_MULTIPLY

/atom/movable/screen/rogue/placeholder/read
	icon = ROGUE_HUD_ICON_READ
	icon_state = ""
	screen_loc = rogueui_screen_origin
	alpha = 0

/atom/movable/screen/rogue/placeholder/readtext
	icon = null
	icon_state = ""
	screen_loc = rogueui_readtext
	layer = ROGUE_HUD_LAYER + 0.02

/atom/movable/screen/rogue/placeholder/fov
	icon = ROGUE_HUD_ICON_VISION_CONE
	icon_state = "combat"
	screen_loc = rogueui_screen_origin
	alpha = 0
	plane = FULLSCREEN_PLANE
	layer = FLASH_LAYER - 0.5

/atom/movable/screen/rogue/placeholder/fov_blocker
	icon = ROGUE_HUD_ICON_VISION_CONE
	icon_state = "combat_v"
	screen_loc = rogueui_screen_origin
	alpha = 0
	plane = FIELD_OF_VISION_BLOCKER_PLANE
