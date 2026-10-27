/obj/item
	var/rogue_female_worn = FALSE
	/// Held sprites baked from Ratwood's getonmobprop tables (lefthand/righthand_file are the baked sheets): the state
	/// is the sprite's own, with "_wielded" and the alternate grip's suffix beside it and "_behind" for the parts under
	/// the body. Baked at build time by ai-skills bake_onmob_sheets.py, see clothing/onmob.dm.
	var/rogue_baked_inhand = FALSE

/obj/item/build_worn_icon(default_layer = 0, default_icon_file = null, isinhands = FALSE, female_uniform = NO_FEMALE_UNIFORM, override_state = null, override_file = null, bodyshape = NONE)
	if(isinhands)
		if(rogue_baked_inhand && !override_state)
			override_state = rogue_held_state(override_file || default_icon_file)
		return ..(default_layer, default_icon_file, isinhands, female_uniform, override_state, override_file, bodyshape)
	var/mob/living/carbon/human/goblin = loc
	if(istype(goblin) && HAS_TRAIT(goblin, TRAIT_ROGUE_GOBLIN_BODY))
		if(rogue_goblin_state && (default_layer == SUIT_LAYER || default_layer == HEAD_LAYER))
			return mutable_appearance(ROGUE_BODIES_ICON, rogue_goblin_state, -default_layer)
		return mutable_appearance(layer = -default_layer)
	var/plain_state = override_state || worn_icon_state || icon_state
	var/file = override_file || worn_icon || default_icon_file
	var/wears_female = rogue_worn_by_female()
	if(!wears_female)
		female_uniform = NO_FEMALE_UNIFORM
	if(rogue_female_worn && wears_female)
		var/state = "[plain_state][ROGUE_FEMALE_SUFFIX]"
		if(icon_exists(file, state))
			override_state = state
			female_uniform = NO_FEMALE_UNIFORM
	. = ..(default_layer, default_icon_file, isinhands, female_uniform, override_state, override_file, bodyshape)
	rogue_worn_layers(., file, override_state || plain_state, plain_state)

/obj/item/proc/rogue_worn_by_female()
	var/mob/living/carbon/human/wearer = loc
	return istype(wearer) && wearer.rogue_wears_female()

/// Whether the body wears women's clothes: its sex, unless its race wears the other's (Ratwood use_m, use_f).
/mob/living/carbon/human/proc/rogue_wears_female()
	var/forced = dna?.species?.rogue_worn_sex
	return forced ? forced == "f" : physique == FEMALE

/// The baked held state for the current sprite: the alternate grip's or the wielded one when the sheet has it. A sprite
/// the bake never saw (a state set at runtime) falls back to the one it was baked from.
/obj/item/proc/rogue_held_state(file)
	var/base = inhand_icon_state || icon_state
	if(!icon_exists(file, base) && !icon_exists(file, "[base]_behind"))
		base = initial(inhand_icon_state) || initial(icon_state)
	if(rogue_alt_grip?.inhand_suffix && (icon_exists(file, "[base][rogue_alt_grip.inhand_suffix]") || icon_exists(file, "[base][rogue_alt_grip.inhand_suffix]_behind")))
		return "[base][rogue_alt_grip.inhand_suffix]"
	if(HAS_TRAIT(src, TRAIT_WIELDED) && (icon_exists(file, "[base]_wielded") || icon_exists(file, "[base]_wielded_behind")))
		return "[base]_wielded"
	return base

/// Ratwood draws part of a held item under the body (a sword's blade behind the back when facing north); TG has one
/// layer for hands, so those parts go to an overlay of their own.
/mob/living/carbon/human/update_held_items()
	. = ..()
	var/list/behind = list()
	for(var/obj/item/held in held_items)
		if(!held.rogue_baked_inhand)
			continue
		var/index = get_held_index_of_item(held)
		var/file = IS_LEFT_INDEX(index) ? held.lefthand_file : held.righthand_file
		var/state = "[held.rogue_held_state(file)]_behind"
		if(!icon_exists(file, state))
			continue
		var/mutable_appearance/look = held.build_worn_icon(default_layer = BODY_BEHIND_LAYER, default_icon_file = file, isinhands = TRUE, override_state = state)
		apply_height(look, LOWER_BODY)
		var/obj/item/bodypart/arm/hand = hand_bodyparts[index]
		hand?.held_hand_offset?.apply_offset(look)
		behind += look
	set_rogue_overlay(ROGUE_OVERLAY_HANDS_BEHIND, length(behind) ? behind : null)
