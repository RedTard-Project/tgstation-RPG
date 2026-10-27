/// Field of view of Roguetown as Ratwood and Vibelin have it: a human sees ahead and to the sides, and a helmet's visor or a hood
/// (block2add), an eyepatch or a scarred eye takes away the back or one side. A raised visor or a lowered hood blocks nothing
/// (clothing/adjustable.dm), and the sun in light-sensitive eyes closes both sides (clothing/sun_glare.dm). The cone is TG's
/// fov_handler; its mask is a state of Ratwood's vision_cone sheet, which cuts each side on its own, and in_fov checks the same
/// uneven arc.

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
/// are replaced under TG's own names by gentler ones, set by the fov_behind_* values.
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
