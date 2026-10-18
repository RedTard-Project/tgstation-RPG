/atom/movable/screen/proc/rogue_hud_not_implemented(mob/user)
	if(!ismob(user))
		return
	user.balloon_alert(user, ROGUE_HUD_STUB_TEXT)

/atom/movable/screen/rogue
	icon = ROGUE_HUD_ICON
	layer = ROGUE_HUD_LAYER

/atom/movable/screen/rogue/stub
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/rogue/stub/Click(location, control, params)
	. = ..()
	rogue_hud_not_implemented(usr)

/atom/movable/screen/rogue/stub/rmb_intent
	name = "alt intents"
	icon_state = "rmbintent"
	screen_loc = rogueui_rmbintents

/atom/movable/screen/rogue/stub/quad_intents
	name = "mmb intents"
	icon_state = "mmbintents0"
	screen_loc = rogueui_quad

/atom/movable/screen/rogue/stub/defdelay
	name = "defense readiness"
	icon_state = "defdelay0"
	screen_loc = rogueui_defdelay
	layer = ROGUE_ABOVE_HUD_LAYER
	alpha = 230

/atom/movable/screen/rogue/stub/sneak
	name = "sneak mode"
	icon_state = "sneak0"
	screen_loc = rogueui_moves

/atom/movable/screen/rogue/stub/energy
	name = "energy"
	icon = ROGUE_HUD_ICON_HEAT
	icon_state = "energy100"
	screen_loc = rogueui_fat

/atom/movable/screen/rogue/stub/feint
	name = "feint"
	icon = ROGUE_HUD_ICON_FEINT
	icon_state = "feintbar0"
	screen_loc = rogueui_feint
	layer = ROGUE_HUD_LAYER + 0.1

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

/atom/movable/screen/rogue/placeholder/advsetup
	icon = null
	icon_state = ""
	screen_loc = rogueui_advsetup
