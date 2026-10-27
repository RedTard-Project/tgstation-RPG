/// Alternate grips of Azure Peak as Ratwood has them (alt_grip.dm): a sword can be held by the blade (halfsword) or swung by the
/// crossguard (mordhau). A grip brings its own intents and on-hand pose and changes the weapon's length and defense while held so.
/// The grip datums are Ratwood data written by the porter (rockhill/ported/alt_grips.dm); items list them in alt_grips.
GLOBAL_LIST_EMPTY(rogue_alt_grips)

/proc/rogue_alt_grip(grip_type)
	if(!ispath(grip_type, /datum/alt_grip))
		return null
	if(!GLOB.rogue_alt_grips[grip_type])
		GLOB.rogue_alt_grips[grip_type] = new grip_type
	return GLOB.rogue_alt_grips[grip_type]

/datum/alt_grip
	var/name = "alternate grip"
	/// The grip needs the other hand free.
	var/two_handed = FALSE
	/// Least rank in the weapon's skill (Ratwood skill_req).
	var/skill_rank = 0
	/// Any of these traits allows the grip; none listed means everyone may.
	var/list/trait_applied
	var/list/grip_intents
	/// Suffix of the held state baked from the grip's pose (getonmobprop "altgrip" of Ratwood), see clothing/worn_icons.dm.
	var/inhand_suffix
	/// Item vars set to these values while the grip is held.
	var/list/var_overrides
	/// Item vars raised or lowered by these amounts while the grip is held.
	var/list/additive_var_overrides

/datum/alt_grip/proc/usable_by(obj/item/weapon, mob/living/user)
	if(length(trait_applied))
		var/allowed = FALSE
		for(var/trait in trait_applied)
			if(HAS_TRAIT(user, trait))
				allowed = TRUE
				break
		if(!allowed)
			return FALSE
	return user.rogue_weapon_rank(weapon) >= skill_rank

/datum/alt_grip/proc/describe(obj/item/weapon, mob/living/user)
	var/text = name
	if(two_handed)
		text += " (2H)"
	if(!usable_by(weapon, user))
		text = span_danger(text)
	return text

/obj/item
	var/list/alt_grips
	var/datum/alt_grip/rogue_alt_grip
	/// Values the current grip replaced, to put back when it is let go.
	var/list/rogue_alt_grip_restore

/// Steps to the next usable grip of the item, or back to the normal grip after the last one (Ratwood cycle_altgrip).
/obj/item/proc/rogue_cycle_alt_grip(mob/living/user, direction = 1)
	if(!length(alt_grips) || !user.is_holding(src))
		return FALSE
	var/start = rogue_alt_grip ? alt_grips.Find(rogue_alt_grip.type) + direction : (direction > 0 ? 1 : length(alt_grips))
	for(var/index = start; index >= 1 && index <= length(alt_grips); index += direction)
		var/datum/alt_grip/grip = rogue_alt_grip(alt_grips[index])
		if(!grip?.usable_by(src, user))
			continue
		if(grip.two_handed && user.get_inactive_held_item())
			to_chat(user, span_warning("I need a free hand to hold [src] like that."))
			return FALSE
		rogue_set_alt_grip(grip, user)
		to_chat(user, span_notice("I shift [src] into \a [grip.name] grip[grip.two_handed ? " with both hands" : ""]."))
		rogue_show_grip(user, "[grip.name]!")
		user.changeNext_move(CLICK_CD_RAPID)
		return TRUE
	if(!rogue_alt_grip)
		return FALSE
	rogue_set_alt_grip(null, user)
	to_chat(user, span_notice("I return to a normal grip on [src]."))
	rogue_show_grip(user, "normal grip")
	user.changeNext_move(CLICK_CD_RAPID)
	return TRUE

/obj/item/proc/rogue_set_alt_grip(datum/alt_grip/grip, mob/living/user)
	for(var/var_name in rogue_alt_grip_restore)
		vars[var_name] = rogue_alt_grip_restore[var_name]
	rogue_alt_grip_restore = null
	rogue_alt_grip = grip
	if(grip)
		for(var/var_name in grip.var_overrides)
			if(var_name in vars)
				LAZYSET(rogue_alt_grip_restore, var_name, vars[var_name])
				vars[var_name] = grip.var_overrides[var_name]
		for(var/var_name in grip.additive_var_overrides)
			if(!(var_name in vars) || !isnum(vars[var_name]))
				continue
			if(!(var_name in rogue_alt_grip_restore))
				LAZYSET(rogue_alt_grip_restore, var_name, vars[var_name])
			vars[var_name] += grip.additive_var_overrides[var_name]
	if(user)
		user.rogue_refresh_intents()
		user.update_held_items()

/// The grip's name over the wielder's head for themselves, and for onlookers who know the weapon or are Combat Aware (Ratwood).
/obj/item/proc/rogue_show_grip(mob/living/user, text)
	text = "<font color='#cc9900'>[text]</font>"
	user.balloon_alert(user, text)
	if(HAS_TRAIT(user, TRAIT_DECEIVING_MEEKNESS))
		return
	for(var/mob/living/carbon/human/onlooker in viewers(DEFAULT_MESSAGE_RANGE, user))
		if(onlooker != user && onlooker.client && (HAS_TRAIT(onlooker, TRAIT_COMBAT_AWARE) || onlooker.rogue_weapon_rank(src) >= ROGUE_ALT_GRIP_KNOW_RANK))
			user.balloon_alert(onlooker, text)

/datum/element/rogue_weapon/proc/on_attack_self_secondary(obj/item/source, mob/living/user)
	SIGNAL_HANDLER
	if(!length(source.alt_grips) || !isliving(user))
		return NONE
	source.rogue_cycle_alt_grip(user)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/element/rogue_weapon/proc/on_dropped(obj/item/source, mob/user)
	SIGNAL_HANDLER
	if(source.rogue_alt_grip)
		source.rogue_set_alt_grip(null, null)
