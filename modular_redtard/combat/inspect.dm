// Ratwood's and Azure Peak's inspection of an item (game/objects/items.dm: get_inspect_button(), Topic "inspect",
// get_force_string()): the examine text ends with {?}, and clicking it prints the item's properties in one block - force in
// words, wielded force, balance, length, defense, sharpness, skill, special, coverage and durability. Medieval maps only;
// there it takes the place of TG's combat label (weapon_description), whose hits to take down an enemy know nothing of
// Ratwood's combat.

/obj/item/examine(mob/user)
	. = ..()
	if(rogue_combat_enabled() && (force || throwforce || max_integrity || offensive_notes))
		. += span_info("<a href='byond://?src=[REF(src)];rogue_inspect=1'>Inspect {?}</a>")

/obj/item/add_weapon_description()
	if(rogue_combat_enabled())
		return
	return ..()

/obj/item/Topic(href, list/href_list)
	. = ..()
	if(!href_list["rogue_inspect"] || !rogue_combat_enabled())
		return
	var/mob/viewer = usr
	if(!viewer?.client || (!isobserver(viewer) && get_dist(get_turf(viewer), get_turf(src)) > 1))
		return
	to_chat(viewer, boxed_message(jointext(rogue_inspect_lines(), "\n")))

/// The inspection block (Ratwood's inspec list), without the links that explain each line.
/obj/item/proc/rogue_inspect_lines()
	. = list(span_notice("Properties of [src]"))
	if(minstr)
		. += "<b>MIN.STR:</b> [minstr]"
	if(force)
		. += "<b>FORCE:</b> [rogue_force_word(force)]"
	if(rogue_force_wielded)
		. += "<b>WIELDED FORCE:</b> [rogue_force_word(rogue_force_wielded)]"
	switch(wbalance)
		if(WBALANCE_HEAVY)
			. += "<b>BALANCE:</b> Heavy"
		if(WBALANCE_SWIFT)
			. += "<b>BALANCE:</b> Swift"
	switch(wlength)
		if(WLENGTH_SHORT)
			. += "<b>LENGTH:</b> Short"
		if(WLENGTH_LONG)
			. += "<b>LENGTH:</b> Long"
		if(WLENGTH_GREAT)
			. += "<b>LENGTH:</b> Great"
	if(rogue_force_wielded)
		. += "<b>TWO-HANDED</b>"
	if(can_parry)
		. += "<b>DEFENSE:</b> [wdefense][wdefense_wbonus ? " (+[wdefense_wbonus] wielded)" : ""]"
	if(max_blade_int)
		. += "<b>SHARPNESS:</b> [round(blade_int / max_blade_int * 100)]% ([round(blade_int)])"
	if(associated_skill)
		var/datum/attribute/skill/skill = GET_ROGUE_ATTRIBUTE(associated_skill)
		if(skill)
			. += "<b>SKILL:</b> [skill.name]"
	var/datum/special_intent/special_type = special_instance || special
	if(special_type)
		. += "<b>SPECIAL:</b> [ispath(special_type) ? initial(special_type.name) : special_type.name]"
	if(intdamage_factor != 1 && force >= 5)
		. += "<b>INTEGRITY DAMAGE:</b> [intdamage_factor * 100]%"
	if(isclothing(src))
		. += rogue_coverage_lines()
	if(max_integrity)
		// Ratwood counts durability down to where the item is broken, not down to zero; worn armor breaks at the module's share.
		var/failure = max_integrity * (isclothing(src) ? ROGUE_ARMOR_FAILURE_SHARE : integrity_failure)
		var/whole = max_integrity - failure
		var/left = max(get_integrity() - failure, 0)
		. += "<b>DURABILITY:</b> [whole > 0 ? round(left / whole * 100) : 0]% ([floor(left)])"
	// What TG's label added past its own lines: the item's notes and what its components tell.
	if(offensive_notes)
		. += offensive_notes
	SEND_SIGNAL(src, COMSIG_ITEM_WEAPON_LABEL_READOUT, .)

/// What the garment covers, part by part as a blow looks for it (rogue_coverage_flags(), combat/armor.dm): the body, then the face.
/obj/item/proc/rogue_coverage_lines()
	var/static/list/part_names = list(
		"Head" = HEAD,
		"Neck" = NECK,
		"Chest" = CHEST,
		"Stomach" = ROGUE_COVER_VITALS,
		"Groin" = GROIN,
		"Right arm" = ARM_RIGHT,
		"Left arm" = ARM_LEFT,
		"Right hand" = HAND_RIGHT,
		"Left hand" = HAND_LEFT,
		"Right leg" = LEG_RIGHT,
		"Left leg" = LEG_LEFT,
		"Right foot" = FOOT_RIGHT,
		"Left foot" = FOOT_LEFT,
	)
	var/static/list/face_names = list(
		"Right eye" = ROGUE_COVER_RIGHT_EYE,
		"Left eye" = ROGUE_COVER_LEFT_EYE,
		"Nose" = ROGUE_COVER_NOSE,
		"Mouth" = ROGUE_COVER_MOUTH,
		"Ears" = ROGUE_COVER_EARS,
		"Skull" = ROGUE_COVER_HAIR,
	)
	. = list()
	var/coverage = rogue_coverage_flags()
	var/list/parts = list()
	for(var/part in part_names)
		if(coverage & part_names[part])
			parts += part
	if(length(parts))
		. += "<b>COVERAGE:</b> [jointext(parts, " | ")]"
	var/list/face = list()
	for(var/part in face_names)
		if(coverage & face_names[part])
			face += part
	if((coverage & ROGUE_COVER_EYES) == ROGUE_COVER_EYES)
		face -= list("Right eye", "Left eye")
		face.Insert(1, "Eyes")
	if(length(face))
		. += "<b>FACE:</b> [jointext(face, " | ")]"

/// Ratwood's get_force_string(): force in words.
/proc/rogue_force_word(force)
	if(force < 10)
		return "Puny"
	if(force < 15)
		return "Weak"
	if(force < 20)
		return "Modest"
	if(force < 25)
		return "Fine"
	if(force < 30)
		return "Great"
	if(force <= 35)
		return "Grand"
	return "Mighty"
