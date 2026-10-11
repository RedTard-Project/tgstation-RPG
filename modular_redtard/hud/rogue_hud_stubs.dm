/// Tells the clicking player that the mechanic behind this rogue HUD element is not ported yet
/atom/movable/screen/proc/rogue_hud_not_implemented(mob/user)
	if(!ismob(user))
		return
	user.balloon_alert(user, ROGUE_HUD_STUB_TEXT)

/// Base for rogue HUD elements that have no TG screen type to extend
/atom/movable/screen/rogue
	icon = ROGUE_HUD_ICON
	layer = ROGUE_HUD_LAYER

/// A visible, clickable element whose mechanic is not ported yet; every click answers with a balloon alert
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

/atom/movable/screen/rogue/stub/def_intent
	name = "defense intent"
	icon_state = "def1n"
	screen_loc = rogueui_def

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

/// Azure inventory slot with no TG item slot behind it; same sprite and place as in Azure
/atom/movable/screen/rogue/stub/slot
	/// Key suffix, Azure's slot name
	var/slot_name

/atom/movable/screen/rogue/stub/slot/wrists
	name = "wrists"
	icon_state = "wrist"
	screen_loc = rogueui_wrists
	slot_name = "wrists"

/atom/movable/screen/rogue/stub/slot/backr
	name = "backr"
	icon_state = "back"
	screen_loc = rogueui_backr
	slot_name = "backr"

/atom/movable/screen/rogue/stub/slot/pants
	name = "trou"
	icon_state = "pants"
	screen_loc = rogueui_pants
	slot_name = "pants"

/atom/movable/screen/rogue/stub/slot/cloak
	name = "cloak"
	icon_state = "cloak"
	screen_loc = rogueui_cloak
	slot_name = "cloak"

/atom/movable/screen/rogue/stub/slot/mouth
	name = "mouth"
	icon_state = "mouth"
	screen_loc = rogueui_mouth
	slot_name = "mouth"

/// Present in Azure's HUD but invisible until a mechanic that is not ported turns it on.
/// Registered under its key with Azure's sprite and place, kept off the client screen.
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
