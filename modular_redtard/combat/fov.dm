/// Field of view of Roguetown as Ratwood and Vibelin have it: a human sees ahead and to the sides, and a helmet's visor or a hood
/// (block2add), an eyepatch or a scarred eye takes away the back or one side. A raised visor or a lowered hood blocks nothing
/// (clothing/adjustable.dm), and the sun in light-sensitive eyes closes both sides (clothing/sun_glare.dm). The cone is TG's
/// fov_handler; its mask is a state of Ratwood's vision_cone sheet, which cuts each side on its own, and in_fov checks the same
/// uneven arc. Whoever stands in the closed part of the cone is not drawn at all, as in Ratwood (its game_world_fov_hidden plane);
/// the world there is only shaded (see the planes at the end of this file).

/// Planes of what hides behind one's back. On medieval maps living things are drawn on a plane of their own, right above TG's game
/// plane, and that plane loses the closed part of the cone before it joins the game world. The cut is TG's FOV blocker less the
/// viewer's own tile (Ratwood draws the viewer above the cone): the own tile plane holds a tile at the centre of the view, the mob
/// mask plane holds the blocker with that tile cut out. The masks are planes below the mob plane so they are drawn before it.
#define ROGUE_FOV_SELF_PLANE -44
#define ROGUE_FOV_SELF_RENDER_TARGET "*ROGUE_FOV_SELF_RENDER_TARGET"
#define ROGUE_FOV_MOB_MASK_PLANE -43
#define ROGUE_FOV_MOB_MASK_RENDER_TARGET "*ROGUE_FOV_MOB_MASK_RENDER_TARGET"
#define ROGUE_MOB_PLANE -42

/obj/item/clothing
	/// Parts of the wearer's view this headgear or mask hides, ROGUE_FOV_* flags (Ratwood block2add).
	var/block2add = NONE

/mob/living/carbon/human
	/// How far the view reaches to each side of where the human faces, in degrees.
	var/rogue_fov_left = ROGUE_FOV_SIDE
	var/rogue_fov_right = ROGUE_FOV_SIDE
	/// State of the cone in the vision_cone sheet; null leaves TG's own mask.
	var/rogue_fov_mask

/// What narrows the view now: worn head and mask, scarred eyes and the sun's glare. The item being taken off still sits in its slot
/// while the unequip signal runs, so it is passed in to be left out.
/mob/living/carbon/human/proc/rogue_fov_flags(obj/item/removed)
	. = NONE
	for(var/obj/item/clothing/worn in list(head, wear_mask))
		if(worn != removed)
			. |= worn.block2add
	var/scars = get_eye_scars()
	if(scars & RIGHT_EYE_SCAR)
		. |= ROGUE_FOV_RIGHT
	if(scars & LEFT_EYE_SCAR)
		. |= ROGUE_FOV_LEFT
	if(HAS_TRAIT(src, TRAIT_ROGUE_SUN_BLINDED))
		. |= ROGUE_FOV_RIGHT | ROGUE_FOV_LEFT

/proc/rogue_fov_mask_state(flags)
	switch(flags & (ROGUE_FOV_RIGHT | ROGUE_FOV_LEFT | ROGUE_FOV_BEHIND))
		if(ROGUE_FOV_BEHIND)
			return "behind_v"
		if(ROGUE_FOV_RIGHT)
			return "right_v"
		if(ROGUE_FOV_RIGHT | ROGUE_FOV_BEHIND)
			return "behind_r_v"
		if(ROGUE_FOV_LEFT)
			return "left_v"
		if(ROGUE_FOV_LEFT | ROGUE_FOV_BEHIND)
			return "behind_l_v"
		if(ROGUE_FOV_RIGHT | ROGUE_FOV_LEFT, ROGUE_FOV_RIGHT | ROGUE_FOV_LEFT | ROGUE_FOV_BEHIND)
			return "both_v"
	return "combat_v"

/// A blocked side leaves only the front of it; a blocked back halves both sides. TG's cone gets the widest side, so its own
/// check never hides more than the mask does.
/mob/living/carbon/human/proc/rogue_update_fov(obj/item/removed)
	var/flags = rogue_fov_flags(removed)
	var/side = (flags & ROGUE_FOV_BEHIND) ? ROGUE_FOV_SIDE_BEHIND : ROGUE_FOV_SIDE
	rogue_fov_left = (flags & ROGUE_FOV_LEFT) ? ROGUE_FOV_SIDE_BLOCKED : side
	rogue_fov_right = (flags & ROGUE_FOV_RIGHT) ? ROGUE_FOV_SIDE_BLOCKED : side
	rogue_fov_mask = rogue_fov_mask_state(flags)
	add_fov_trait(ROGUE_FOV_SOURCE, 360 - 2 * max(rogue_fov_left, rogue_fov_right))

/datum/component/fov_handler/set_fov_angle(new_angle)
	. = ..()
	var/mob/living/carbon/human/owner = parent
	if(istype(owner) && owner.rogue_fov_mask && new_angle == LAZYACCESS(owner.fov_traits, ROGUE_FOV_SOURCE))
		blocker_mask.icon = ROGUE_HUD_ICON_VISION_CONE
		blocker_mask.icon_state = owner.rogue_fov_mask
		// The edge of the cone fades out instead of cutting the view in two.
		var/edge = ROGUE_FOV_EDGE_BLUR
		if(edge > 0)
			blocker_mask.add_filter("rogue_fov_edge", 1, gauss_blur_filter(edge))
		else
			blocker_mask.remove_filter("rogue_fov_edge")
	else
		blocker_mask.icon = initial(blocker_mask.icon)
		blocker_mask.remove_filter("rogue_fov_edge")

/// TG draws what is behind one's back through its own plate: blurred, greyed out and dimmed to about a fifth of its brightness.
/// Roguetown shades it far lighter (Ratwood's cone is a black shadow at most 35% opaque), so on medieval maps the plate's filters
/// are replaced under TG's own names by gentler ones, set by the fov_behind_* values. Living things are no longer on this plate
/// there: the mob plane has already lost them.
/atom/movable/screen/plane_master/rendering_plate/masked_game_plate/Initialize(mapload, datum/hud/hud_owner, datum/plane_master_group/home, offset)
	. = ..()
	if(!rogue_combat_enabled())
		return
	var/blur = ROGUE_FOV_BEHIND_BLUR
	if(blur > 0)
		add_filter("fov_blur", 1, gauss_blur_filter(blur))
	else
		remove_filter("fov_blur")
	add_filter("fov_matrix", 3, color_matrix_filter(rogue_fov_behind_matrix(ROGUE_FOV_BEHIND_BRIGHTNESS / 100, ROGUE_FOV_BEHIND_SATURATION / 100)))

/// A colour matrix that keeps `saturation` of the colour (the rest goes to grey by Rec. 601 luma) and `brightness` of the light.
/proc/rogue_fov_behind_matrix(brightness, saturation)
	var/grey = 1 - saturation
	var/list/luma = list(0.299, 0.587, 0.114)
	. = list()
	for(var/channel in 1 to 3)
		for(var/output in 1 to 3)
			. += brightness * (luma[channel] * grey + (channel == output ? saturation : 0))
		. += 0
	. += list(0, 0, 0, 1, 0, 0, 0, 0)

/// TG's cone is even on both sides; with one side cut, what it lets through is checked against that side.
/mob/living/carbon/human/in_fov(atom/observed_atom, ignore_self = FALSE)
	. = ..()
	if(!. || rogue_fov_left == rogue_fov_right || fov_view != LAZYACCESS(fov_traits, ROGUE_FOV_SOURCE))
		return
	var/turf/here = get_turf(src)
	var/turf/there = get_turf(observed_atom)
	if(!here || !there || (abs(there.x - here.x) <= 1 && abs(there.y - here.y) <= 1))
		return
	var/offset = closer_angle_difference(dir2angle(dir), get_angle(here, there))
	return offset < 0 ? -offset < rogue_fov_left : offset < rogue_fov_right

/datum/element/rogue_combat/proc/on_organ_change(mob/living/carbon/human/source, obj/item/organ/organ)
	SIGNAL_HANDLER
	if(istype(organ, /obj/item/organ/eyes))
		source.rogue_update_fov()

/obj/item/organ/eyes/apply_scarring_effects()
	. = ..()
	if(ishuman(owner) && rogue_combat_enabled())
		var/mob/living/carbon/human/human_owner = owner
		human_owner.rogue_update_fov()

/obj/item/organ/eyes/fix_scar(side)
	. = ..()
	if(ishuman(owner) && rogue_combat_enabled())
		var/mob/living/carbon/human/human_owner = owner
		human_owner.rogue_update_fov()

// Hiding behind one's back (Ratwood's mobs on GAME_PLANE_FOV_HIDDEN, masked by the FOV blocker).

/// Living things on medieval maps: drawn between TG's game plane and the plane above it, as Ratwood draws mobs above its
/// structures and below its upper plane. While the viewer's view is narrowed the mob mask cuts the closed part of the cone out.
/atom/movable/screen/plane_master/rogue_mobs
	name = "Rogue mobs"
	documentation = "Living mobs on medieval maps (combat/fov.dm). Relayed onto the game world right above the game plane and below the upper one,\
		<br>so on these maps mobs always draw over the game plane, as Ratwood draws them over its structures.\
		<br>While the viewer has a field of view, the closed part of the cone (less the viewer's own tile) is cut out of this plane,\
		<br>so whoever stands behind one's back is not drawn at all; the world there is only shaded by the masked game plate."
	plane = ROGUE_MOB_PLANE
	render_relay_planes = list()

/atom/movable/screen/plane_master/rogue_mobs/Initialize(mapload, datum/hud/hud_owner, datum/plane_master_group/home, offset)
	start_hidden = !rogue_combat_enabled()
	. = ..()
	if(start_hidden || . == INITIALIZE_HINT_QDEL)
		return
	// A layer of its own between the relays of the game plane and of the upper one, whatever the plane's number.
	add_relay_to(GET_NEW_PLANE(RENDER_PLANE_GAME_WORLD, offset), relay_layer = GET_NEW_PLANE(GAME_PLANE, offset) + abs(LOWEST_EVER_PLANE * 30) + 0.5)

/atom/movable/screen/plane_master/rogue_mobs/show_to(mob/mymob)
	. = ..()
	if(!. || !mymob)
		return .
	RegisterSignal(mymob, SIGNAL_ADDTRAIT(TRAIT_FOV_APPLIED), PROC_REF(fov_enabled), override = TRUE)
	RegisterSignal(mymob, SIGNAL_REMOVETRAIT(TRAIT_FOV_APPLIED), PROC_REF(fov_disabled), override = TRUE)
	if(HAS_TRAIT(mymob, TRAIT_FOV_APPLIED))
		fov_enabled(mymob)
	else
		fov_disabled(mymob)

/atom/movable/screen/plane_master/rogue_mobs/proc/fov_enabled(mob/source)
	SIGNAL_HANDLER
	add_filter("rogue_fov_hidden", 1, alpha_mask_filter(render_source = OFFSET_RENDER_TARGET(ROGUE_FOV_MOB_MASK_RENDER_TARGET, offset), flags = MASK_INVERSE))

/atom/movable/screen/plane_master/rogue_mobs/proc/fov_disabled(mob/source)
	SIGNAL_HANDLER
	remove_filter("rogue_fov_hidden")

/// The viewer's own tile, which the mob mask leaves out: the viewer is never cut by their own cone (Ratwood shows the viewer
/// above it). Like TG's blocker, only drawn while the view is narrowed.
/atom/movable/screen/plane_master/field_of_vision_blocker/rogue_self
	name = "Rogue FOV own tile"
	documentation = "Only a mask (combat/fov.dm): one tile at the centre of the view, where the viewer stands.\
		<br>The mob mask plane cuts it out of the field of vision blocker, so the viewer's own sprite is never hidden by the cone."
	plane = ROGUE_FOV_SELF_PLANE
	render_target = ROGUE_FOV_SELF_RENDER_TARGET
	var/atom/movable/screen/rogue_fov_self/own_tile

/atom/movable/screen/plane_master/field_of_vision_blocker/rogue_self/Initialize(mapload, datum/hud/hud_owner, datum/plane_master_group/home, offset)
	start_hidden = !rogue_combat_enabled()
	. = ..()
	if(start_hidden || . == INITIALIZE_HINT_QDEL)
		return
	own_tile = new
	if(home?.map)
		own_tile.screen_loc = "[home.map]:[own_tile.screen_loc]"

/atom/movable/screen/plane_master/field_of_vision_blocker/rogue_self/Destroy()
	var/client/viewer = home?.our_hud?.mymob?.canon_client
	if(viewer)
		viewer.screen -= own_tile
	QDEL_NULL(own_tile)
	return ..()

/atom/movable/screen/plane_master/field_of_vision_blocker/rogue_self/show_to(mob/mymob)
	. = ..()
	var/client/viewer = mymob?.canon_client
	if(. && !force_hidden && viewer)
		viewer.screen += own_tile

/atom/movable/screen/plane_master/field_of_vision_blocker/rogue_self/hide_from(mob/oldmob)
	. = ..()
	var/client/viewer = oldmob?.client
	if(viewer)
		viewer.screen -= own_tile

/atom/movable/screen/rogue_fov_self
	icon = 'icons/effects/alphacolors.dmi'
	icon_state = "white"
	plane = ROGUE_FOV_SELF_PLANE
	screen_loc = "CENTER"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/// What the mob plane loses: a copy of TG's FOV blocker with the viewer's own tile cut out. Like TG's blocker, only drawn while
/// the view is narrowed.
/atom/movable/screen/plane_master/field_of_vision_blocker/rogue_mob_mask
	name = "Rogue FOV mob mask"
	documentation = "Only a mask (combat/fov.dm): the field of vision blocker drawn again, less the viewer's own tile.\
		<br>The mob plane is cut by it, so living things in the closed part of the cone are not drawn at all."
	plane = ROGUE_FOV_MOB_MASK_PLANE
	render_target = ROGUE_FOV_MOB_MASK_RENDER_TARGET
	/// Draws TG's blocker plane onto this one, as a relay does.
	var/atom/movable/render_plane_relay/blocker_copy

/atom/movable/screen/plane_master/field_of_vision_blocker/rogue_mob_mask/Initialize(mapload, datum/hud/hud_owner, datum/plane_master_group/home, offset)
	start_hidden = !rogue_combat_enabled()
	. = ..()
	if(start_hidden || . == INITIALIZE_HINT_QDEL)
		return
	add_filter("rogue_fov_own_tile", 1, alpha_mask_filter(render_source = OFFSET_RENDER_TARGET(ROGUE_FOV_SELF_RENDER_TARGET, 0), flags = MASK_INVERSE))
	blocker_copy = new
	blocker_copy.render_source = OFFSET_RENDER_TARGET(FIELD_OF_VISION_BLOCKER_RENDER_TARGET, 0)
	blocker_copy.plane = ROGUE_FOV_MOB_MASK_PLANE
	blocker_copy.layer = 1
	blocker_copy.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/relay_loc = home?.relay_loc || "1,1"
	blocker_copy.screen_loc = home?.map ? "[home.map]:[relay_loc]" : relay_loc

/atom/movable/screen/plane_master/field_of_vision_blocker/rogue_mob_mask/Destroy()
	var/client/viewer = home?.our_hud?.mymob?.canon_client
	if(viewer)
		viewer.screen -= blocker_copy
	QDEL_NULL(blocker_copy)
	return ..()

/atom/movable/screen/plane_master/field_of_vision_blocker/rogue_mob_mask/show_to(mob/mymob)
	. = ..()
	var/client/viewer = mymob?.canon_client
	if(. && !force_hidden && viewer)
		viewer.screen += blocker_copy

/atom/movable/screen/plane_master/field_of_vision_blocker/rogue_mob_mask/hide_from(mob/oldmob)
	. = ..()
	var/client/viewer = oldmob?.client
	if(viewer)
		viewer.screen -= blocker_copy

/// On medieval maps living things go onto the mob plane. The dummies of the character previews stay on the game plane.
/mob/living/Initialize(mapload)
	. = ..()
	if(rogue_combat_enabled() && PLANE_TO_TRUE(plane) == GAME_PLANE && !istype(src, /mob/living/carbon/human/dummy))
		SET_PLANE_IMPLICIT(src, ROGUE_MOB_PLANE)

/// Ratwood hides the splash of a blow with the one struck.
/obj/effect/temp_visual/dir_setting/bloodsplatter/Initialize(mapload, set_dir, set_color = BLOOD_COLOR_RED)
	. = ..()
	if(rogue_combat_enabled() && PLANE_TO_TRUE(plane) == GAME_PLANE)
		SET_PLANE_IMPLICIT(src, ROGUE_MOB_PLANE)

/// TG's water only takes in what lies on the floor to game planes; a mob on the mob plane wades in as if it were on the game
/// plane (the overlay itself does not depend on the plane).
/datum/element/immerse/on_init_or_entered(turf/source, atom/movable/movable)
	SIGNAL_HANDLER
	if(QDELETED(movable) || PLANE_TO_TRUE(movable.plane) != ROGUE_MOB_PLANE)
		return ..()
	var/mob_plane = movable.plane
	movable.plane = GET_NEW_PLANE(GAME_PLANE, PLANE_TO_OFFSET(mob_plane))
	. = ..()
	movable.plane = mob_plane

#undef ROGUE_FOV_SELF_PLANE
#undef ROGUE_FOV_SELF_RENDER_TARGET
#undef ROGUE_FOV_MOB_MASK_PLANE
#undef ROGUE_FOV_MOB_MASK_RENDER_TARGET
#undef ROGUE_MOB_PLANE
