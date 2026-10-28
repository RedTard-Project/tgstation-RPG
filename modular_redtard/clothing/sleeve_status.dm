/// Sleeves of Ratwood clothing (items.dm, clothing.dm MiddleClick(), human update_icons.dm wear_dismembered_version()). The worn sprite of
/// a shirt, armor, bracers, gloves, trousers or boots draws the arms or legs into its north and south views, so a lost limb, a torn
/// sleeve or a rolled one has that side cut out of it by Ratwood's mask for the garment's cut (sleevetype), and that side's sleeve
/// layer (rogue_sleeved, clothing/sleeves.dm) is not drawn. Middle click on the garment with the sleeve's arm (or the trouser leg's
/// leg) targeted tears the sleeve off for a scrap of cloth, as strength allows; Alt+middle click rolls it up or back down. A bare limb
/// is no longer covered by the garment.
/obj/item
	/// The masks that cut this item's sleeves out of its worn sprite (Ratwood sleevetype): "shirt", "leg"; null - nothing is cut.
	var/sleevetype
	/// The sleeves are pauldrons: drawn without the arm, never cut, never torn (Ratwood nodismemsleeves).
	var/nodismemsleeves = FALSE
	/// Each side's sleeve or trouser leg, ROGUE_SLEEVE_* (Ratwood r_sleeve_status, l_sleeve_status).
	var/r_sleeve_status = ROGUE_SLEEVE_NOMOD
	var/l_sleeve_status = ROGUE_SLEEVE_NOMOD
	/// Sleeves torn off by hand (Ratwood torn_sleeve_number).
	var/torn_sleeve_number = 0

/obj/item/clothing
	/// What a torn sleeve leaves in the hand (Ratwood salvage_result of clothing).
	var/rogue_sleeve_scrap = /obj/item/natural/cloth

/obj/item/proc/rogue_sleeve_status(side)
	return side == "r" ? r_sleeve_status : l_sleeve_status

/// The limb of this side shows: the sleeve is torn off or rolled up.
/obj/item/proc/rogue_sleeve_bare(side)
	var/status = rogue_sleeve_status(side)
	return status == ROGUE_SLEEVE_TORN || status == ROGUE_SLEEVE_ROLLED

/// The sleeve of this side can still be torn or rolled.
/obj/item/proc/rogue_sleeve_whole(side)
	var/status = rogue_sleeve_status(side)
	return status == ROGUE_SLEEVE_NORMAL || status == ROGUE_SLEEVE_ROLLED

/// Trousers and boots have legs where the rest has sleeves (Ratwood r_sleeve_zone of pants).
/obj/item/proc/rogue_sleeves_on_legs()
	return (slot_flags & ROGUE_SLEEVE_LEG_SLOTS) && !(slot_flags & ROGUE_SLEEVE_ARM_SLOTS)

/// The side, "r" or "l", whose sleeve a targeted zone means; null - neither.
/obj/item/proc/rogue_sleeve_side(zone)
	var/legs = rogue_sleeves_on_legs()
	for(var/side in list("r", "l"))
		if(zone == rogue_sleeve_zone(side, legs))
			return side
	return null

/// Masks that cut a missing limb's or a bare limb's side out of the worn sprite (Ratwood sleeveindex below 4); null - nothing to cut.
/// Only the slots Ratwood cuts, and only sprites of the mask's size. A sprite in a race's own cut (race_cut, "_dwarf") takes that
/// cut's masks, "<side>_<sleevetype>[_f]_<id>" as Ratwood's sleevejazz; a side without one is not cut.
/obj/item/proc/rogue_sleeve_cut_masks(mob/living/carbon/human/wearer, race_cut = "")
	if(!sleevetype || !rogue_sleeved || nodismemsleeves || worn_x_dimension != ICON_SIZE_X || worn_y_dimension != ICON_SIZE_Y)
		return null
	var/slot = wearer.get_slot_by_item(src)
	var/legs = FALSE
	if(slot & ROGUE_SLEEVE_LEG_SLOTS)
		legs = TRUE
	else if(!(slot & ROGUE_SLEEVE_ARM_SLOTS))
		return null
	var/female = wearer.rogue_wears_female()
	var/list/masks
	for(var/side in list("r", "l"))
		if(wearer.get_bodypart(rogue_sleeve_zone(side, legs)) && !rogue_sleeve_bare(side))
			continue
		var/mask = "[side]_[sleevetype]"
		if(female && icon_exists(ROGUE_SLEEVE_MASK_ICON, "[mask][ROGUE_FEMALE_SUFFIX][race_cut]"))
			mask += ROGUE_FEMALE_SUFFIX
		mask += race_cut
		if(icon_exists(ROGUE_SLEEVE_MASK_ICON, mask))
			LAZYADD(masks, mask)
	return masks

/// The worn sprite with the sides of missing or bare limbs cut out, for build_worn_icon() (clothing/worn_icons.dm); null - the item's
/// own sprite. TG's female and body-shape variants are left alone.
/obj/item/proc/rogue_cut_sprite(mob/living/carbon/human/wearer, file, state, female_uniform, bodyshape)
	if(!istype(wearer) || female_uniform || (bodyshapes_with_variations & bodyshape))
		return null
	// The race's cut (rockhill/species.dm rogue_custom_worn_state()) ends the state with "_<clothes_id>".
	var/race_cut = ""
	var/clothes_id = wearer.dna?.species?.rogue_clothes_id
	if(clothes_id && length(state) > length(clothes_id) + 1 && copytext(state, -(length(clothes_id) + 1)) == "_[clothes_id]")
		race_cut = "_[clothes_id]"
	var/list/masks = rogue_sleeve_cut_masks(wearer, race_cut)
	return masks ? rogue_cut_worn_icon(file, state, masks) : null

/// A worn sprite with sides cut out by masks, made once per file, state and masks (as TG's wear_female_version()). The result keeps the
/// state's name, so build_worn_icon() takes it in place of the item's own file.
/proc/rogue_cut_worn_icon(file, state, list/masks)
	var/static/list/cut_icons = list()
	var/key = "[file]|[state]|[jointext(masks, "|")]"
	if(cut_icons[key])
		return cut_icons[key]
	if(!icon_exists(file, state))
		return null
	var/icon/cut = icon(file, state)
	for(var/mask in masks)
		cut.Blend(icon(ROGUE_SLEEVE_MASK_ICON, mask), ICON_MULTIPLY)
	cut.Insert(icon(cut), state)
	cut_icons[key] = fcopy_rsc(cut)
	return cut_icons[key]

/// Ratwood MiddleClick() on clothing, with no middle-click intent chosen; anything else is TG's middle click (hand swap).
/mob/living/carbon/human/MiddleClickOn(atom/A, params)
	var/obj/item/clothing/garment = A
	if(istype(garment) && rogue_mmb_intent == ROGUE_MMB_NONE && garment.rogue_sleeve_click(src, params))
		return
	return ..()

/// The sleeve of the targeted arm or leg: torn off with a plain middle click, rolled up or down with Alt. FALSE - nothing to do here.
/obj/item/clothing/proc/rogue_sleeve_click(mob/living/carbon/human/user, params)
	if(nodismemsleeves || user.incapacitated || !Adjacent(user))
		return FALSE
	var/side = rogue_sleeve_side(deprecise_zone(user.zone_selected))
	if(!side)
		return FALSE
	var/status = rogue_sleeve_status(side)
	if(status == ROGUE_SLEEVE_NOMOD)
		return FALSE
	if(status == ROGUE_SLEEVE_TORN)
		to_chat(user, span_info("It's torn away."))
		return TRUE
	if(LAZYACCESS(params2list(params), ALT_CLICK))
		rogue_set_sleeve(side, status == ROGUE_SLEEVE_ROLLED ? ROGUE_SLEEVE_NORMAL : ROGUE_SLEEVE_ROLLED)
		return TRUE
	INVOKE_ASYNC(src, PROC_REF(rogue_tear_sleeve), user, side)
	return TRUE

/// Sets a sleeve's state. A bare limb is no longer covered; a sleeve rolled back down covers it again, if the garment ever did.
/obj/item/clothing/proc/rogue_set_sleeve(side, status)
	if(side == "r")
		r_sleeve_status = status
	else
		l_sleeve_status = status
	var/legs = rogue_sleeves_on_legs()
	var/part = side == "r" ? (legs ? LEG_RIGHT : ARM_RIGHT) : (legs ? LEG_LEFT : ARM_LEFT)
	if(rogue_sleeve_bare(side))
		body_parts_covered &= ~part
		if(!isnull(rogue_coverage))
			rogue_coverage &= ~part
	else
		body_parts_covered |= part & initial(body_parts_covered)
		if(!isnull(rogue_coverage))
			rogue_coverage |= part & initial(rogue_coverage)
	update_slot_icon()

/// Ratwood: two seconds of pulling, then strength * 8 percent that the sleeve gives; a torn one leaves a scrap in the hand.
/obj/item/clothing/proc/rogue_tear_sleeve(mob/living/carbon/human/user, side)
	if(!do_after(user, ROGUE_SLEEVE_TEAR_TIME, user))
		return
	var/status = rogue_sleeve_status(side)
	if(QDELETED(src) || !Adjacent(user) || status == ROGUE_SLEEVE_TORN || status == ROGUE_SLEEVE_NOMOD)
		return
	if(!prob(user.rogue_stat(ROGUE_STAT_STRENGTH) * ROGUE_SLEEVE_TEAR_PER_STRENGTH))
		user.visible_message(span_warning("[user] tries to tear [src]."))
		return
	torn_sleeve_number++
	rogue_set_sleeve(side, ROGUE_SLEEVE_TORN)
	user.visible_message(span_notice("[user] tears [src]."))
	playsound(src, ROGUE_CLOTH_RIP_SOUND, 50, TRUE)
	if(!rogue_sleeve_scrap)
		return
	var/obj/item/scrap = new rogue_sleeve_scrap(get_turf(src))
	scrap.color = color
	user.put_in_hands(scrap)

/obj/item/clothing/examine(mob/user)
	. = ..()
	if(torn_sleeve_number)
		. += span_notice((torn_sleeve_number == 1 ? "It has one torn sleeve." : "Both its sleeves have been torn!"))
	if(nodismemsleeves || !(rogue_sleeve_whole("r") || rogue_sleeve_whole("l")))
		return
	if(rogue_sleeves_on_legs())
		. += span_info("Middle-click it with a leg targeted to tear that trouser leg off, Alt+middle-click to roll it up or down.")
	else
		. += span_info("Middle-click it with an arm targeted to tear that sleeve off, Alt+middle-click to roll it up or down.")

/// A lost or regained limb changes what the worn clothes cut out and which sleeves they draw. TG redraws only gloves for that.
/obj/item/bodypart/arm/drop_limb(special, dismembered, move_to_floor = TRUE)
	var/mob/living/carbon/human/wearer = owner
	. = ..()
	if(!special && istype(wearer) && !QDELETED(wearer))
		wearer.update_clothing(ROGUE_SLEEVE_ARM_SLOTS)

/obj/item/bodypart/leg/drop_limb(special, dismembered, move_to_floor = TRUE)
	var/mob/living/carbon/human/wearer = owner
	. = ..()
	if(!special && istype(wearer) && !QDELETED(wearer))
		wearer.update_clothing(ROGUE_SLEEVE_LEG_SLOTS)

/obj/item/bodypart/arm/try_attach_limb(mob/living/carbon/new_arm_owner, special, lazy)
	. = ..()
	if(. && !lazy && ishuman(new_arm_owner))
		new_arm_owner.update_clothing(ROGUE_SLEEVE_ARM_SLOTS)

/obj/item/bodypart/leg/try_attach_limb(mob/living/carbon/new_leg_owner, special, lazy)
	. = ..()
	if(. && !lazy && ishuman(new_leg_owner))
		new_leg_owner.update_clothing(ROGUE_SLEEVE_LEG_SLOTS)
