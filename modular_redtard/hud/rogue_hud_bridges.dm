// Upstream procs the rogue HUD hooks into. Each falls through to TG unless the mob shows a rogue element; see OVERRIDES.md.

/// The rogue HUD puts screen tiles left of the map, which widens the map with a border. A render relay anchored at
/// the view's "1,1" then draws its copy of a plane shifted right by the border, once per relay hop. BYOND's reference
/// anchors render_source copies at SCREEN_SOUTHWEST, the plane's corner; with no border it is the same tile as "1,1".
/datum/plane_master_group/main
	relay_loc = "SCREEN_SOUTHWEST"

/// TG's add_relay_to() (emissives, parallax) passes no anchor and gets a hardcoded "1,1"; it takes the group's anchor instead
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

/// TG tints its mood element when it takes it over; the rogue element gets its sprite right away instead
/datum/mood/modify_hud(datum/source)
	. = ..()
	if(istype(mob_parent.hud_used, /datum/hud/rogue))
		update_mood_icon()
