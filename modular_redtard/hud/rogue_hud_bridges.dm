/datum/plane_master_group/main
	relay_loc = "SCREEN_SOUTHWEST"

/atom/movable/screen/fov_blocker
	screen_loc = rogueui_fov_blocker

/atom/movable/screen/plane_master/generate_relay_to(target_plane, relay_loc, client/show_to, blend_override, relay_layer)
	if(!relay_loc && home?.relay_loc)
		relay_loc = home.map ? "[home.map]:[home.relay_loc]" : home.relay_loc
	return ..(target_plane, relay_loc, show_to, blend_override, relay_layer)

/mob/living/carbon/update_health_hud(shown_health_amount)
	var/atom/movable/screen/healths/rogue/rogue_health = hud_used?.screen_objects[HUD_MOB_HEALTH]
	if(!istype(rogue_health) || !client)
		return ..()
	if(SEND_SIGNAL(src, COMSIG_CARBON_UPDATING_HEALTH_HUD, shown_health_amount) & COMPONENT_OVERRIDE_HEALTH_HUD)
		return
	rogue_health.update_for(src)
	var/atom/movable/screen/zone_sel/rogue/doll = hud_used.screen_objects[HUD_MOB_ZONE_SELECTOR]
	if(istype(doll))
		doll.refresh_limbs()

/mob/living/update_stamina_hud(shown_stamina_loss)
	var/atom/movable/screen/stamina/rogue/rogue_stamina = hud_used?.screen_objects[HUD_MOB_STAMINA]
	if(!istype(rogue_stamina) || !client)
		return ..()
	rogue_stamina.update_for(src, shown_stamina_loss)

/datum/mood/update_mood_icon()
	var/atom/movable/screen/mood/rogue/rogue_mood = mob_parent.hud_used?.screen_objects[HUD_MOB_MOOD]
	if(!istype(rogue_mood))
		return ..()
	rogue_mood.update_from_mood()

/datum/mood/modify_hud(datum/source)
	. = ..()
	if(istype(mob_parent.hud_used, /datum/hud/rogue))
		update_mood_icon()

/// TG's place for an action button or for one of the palette's own buttons, as the rogue HUD has it (owner's decision
/// 2026-11-24). TG counts its rows down from the top left corner of the field; here they start a little right of the
/// inventory and grow up from the field's bottom edge, so TG's whole block is mirrored top to bottom: its first row is
/// the lowest, the palette's strip and the palette's rows stand above the rows of the list. `height` is the height of
/// the button's icon, which the mirroring turns about.
/proc/rogueui_action_place(screen_loc, height = ICON_SIZE_Y)
	var/static/regex/corner = regex(@"^WEST(?:\+(\d+))?(?::(-?\d+))?,NORTH(?:\+0|-(\d+))?(?::(-?\d+))?$")
	if(!screen_loc || !corner.Find(screen_loc))
		return screen_loc
	var/static/first_column = 6
	var/static/first_row = 6
	var/across = text2num(corner.group[1] || "0") * ICON_SIZE_X + text2num(corner.group[2] || "0") - first_column + rogueui_action_left
	// From the field's top edge down to the top of the icon, less the same for TG's first row.
	var/above = (text2num(corner.group[3] || "0") + 1) * ICON_SIZE_Y - text2num(corner.group[4] || "0") - height - first_row
	var/up = rogueui_action_inset + above
	return "WEST+[round(across / ICON_SIZE_X)]:[across % ICON_SIZE_X],SOUTH+[round(up / ICON_SIZE_Y)]:[up % ICON_SIZE_Y]"

/datum/action_group/ButtonNumberToScreenCoords(number, landing = FALSE)
	if(!istype(owner, /datum/hud/rogue))
		return ..()
	if(location == SCRN_OBJ_IN_LIST)
		max_rows = rogueui_action_rows
	return rogueui_action_place(..())

/// TG shortens its rows of buttons to the view by trying places from the top left corner, and takes a place in the
/// field's lowest tile row for one off the screen; the rogue HUD's rows stand there, so their length is counted here.
/datum/action_group/check_against_view()
	if(!istype(owner, /datum/hud/rogue))
		return ..()
	var/owner_view = owner.mymob?.canon_client?.view
	if(!owner_view)
		return
	var/list/view_size = view_to_pixels(owner_view)
	// TG's step from button to button is a tile and two pixels.
	var/fit = round((view_size[1] - rogueui_action_inset - rogueui_action_left - ICON_SIZE_X) / (ICON_SIZE_X + 2)) + 1
	column_max = clamp(fit, 1, initial(column_max))
	refresh_actions()

/datum/action_group/palette/refresh_actions()
	. = ..()
	if(!istype(owner, /datum/hud/rogue))
		return
	// The palette's strip is a quarter of a tile high (icons/hud/64x16_actions.dmi); its scroll buttons are whole tiles.
	var/static/list/heights = list(HUD_MOB_TOGGLE_PALETTE = 16, HUD_MOB_PALETTE_DOWN = ICON_SIZE_Y, HUD_MOB_PALETTE_UP = ICON_SIZE_Y)
	for(var/hud_key in heights)
		var/atom/movable/screen/piece = owner.screen_objects[hud_key]
		if(piece?.screen_loc)
			piece.screen_loc = rogueui_action_place(piece.screen_loc, heights[hud_key])

/// TG refreshes what hangs on the blood once a Life tick after it changes (QUEUE_BLOOD_UPDATE); the heart is refreshed with
/// it, wherever the blood changed (PR 2546's mark_blood_hud_dirty()).
/mob/living/carbon/update_blood_effects()
	. = ..()
	update_health_hud()
