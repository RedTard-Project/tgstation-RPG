/datum/attribute_holder
	var/mob/living/parent
	var/attribute_default = ROGUE_ATTRIBUTE_DEFAULT
	var/attribute_min = ROGUE_ATTRIBUTE_MIN
	var/attribute_max = ROGUE_ATTRIBUTE_MAX
	var/skill_default = null
	var/skill_min = ROGUE_SKILL_MIN
	var/skill_max = ROGUE_SKILL_MAX
	var/list/attribute_list = list()
	var/list/raw_attribute_list = list()
	var/list/attribute_modification
	var/list/attribute_mod_immunities
	var/list/diceroll_modification
	var/list/skill_xp
	var/list/skill_xp_multipliers

/datum/attribute_holder/New(mob/living/new_parent)
	. = ..()
	for(var/attribute_type in GLOB.rogue_attributes)
		var/is_skill = ispath(attribute_type, ROGUE_SKILL)
		if(!(attribute_type in raw_attribute_list))
			raw_attribute_list[attribute_type] = is_skill ? skill_default : attribute_default
		else if(!isnull(raw_attribute_list[attribute_type]))
			raw_attribute_list[attribute_type] = is_skill ? clamp(raw_attribute_list[attribute_type], skill_min, skill_max) : clamp(raw_attribute_list[attribute_type], attribute_min, attribute_max)
	if(new_parent)
		set_parent(new_parent)
	else
		update_attributes()

/datum/attribute_holder/Destroy()
	set_parent(null)
	attribute_modification = null
	attribute_mod_immunities = null
	diceroll_modification = null
	skill_xp = null
	skill_xp_multipliers = null
	return ..()

/datum/attribute_holder/proc/set_parent(mob/living/new_parent)
	if(parent)
		UnregisterSignal(parent, list(COMSIG_MOB_MIND_TRANSFERRED_OUT_OF, COMSIG_QDELETING))
		if(parent.attributes == src)
			parent.attributes = null
	parent = new_parent
	if(parent)
		if(istype(parent.attributes) && parent.attributes != src)
			qdel(parent.attributes)
		parent.attributes = src
		RegisterSignal(parent, COMSIG_MOB_MIND_TRANSFERRED_OUT_OF, PROC_REF(on_mind_transfer))
		RegisterSignal(parent, COMSIG_QDELETING, PROC_REF(on_parent_deleted))
	update_attributes()

/datum/attribute_holder/proc/on_parent_deleted(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/attribute_holder/proc/on_mind_transfer(datum/source, mob/living/new_body, datum/mind/mind)
	SIGNAL_HANDLER
	if(isliving(new_body))
		set_parent(new_body)

/datum/attribute_holder/proc/governing_contribution(datum/attribute/skill/skill, effective)
	var/governing_raw = return_raw_calculated_skill(skill.governing_attribute)
	if(!effective)
		return floor(governing_raw * (governing_raw >= 0 ? ROGUE_SKILL_GOVERNING_POSITIVE : ROGUE_SKILL_GOVERNING_NEGATIVE))
	var/governing_effective = return_calculated_skill(skill.governing_attribute)
	var/governing_delta = governing_effective - governing_raw
	if(governing_delta < 0)
		return floor((governing_raw * ROGUE_SKILL_GOVERNING_POSITIVE) + (governing_delta * ROGUE_SKILL_GOVERNING_NEGATIVE))
	return floor(governing_effective * ROGUE_SKILL_GOVERNING_POSITIVE)

/datum/attribute_holder/proc/best_default(datum/attribute/skill/skill, effective)
	for(var/attribute_type in skill.default_attributes)
		var/default_value = effective ? return_calculated_skill(attribute_type) : return_raw_calculated_skill(attribute_type)
		if(isnull(default_value))
			continue
		default_value = min(default_value + skill.default_attributes[attribute_type], ROGUE_SKILL_DEFAULT_CAP)
		if(isnull(.) || default_value > .)
			. = default_value

/datum/attribute_holder/proc/return_raw_effective_skill(skill_type)
	if(parent && HAS_TRAIT(parent, TRAIT_ROGUE_NO_SKILLS))
		return 0
	. = raw_attribute_list[skill_type]
	var/datum/attribute/skill/skill = GET_ROGUE_ATTRIBUTE(skill_type)
	if(!istype(skill))
		return
	if(skill.governing_attribute && !isnull(.) && . >= 0)
		. += governing_contribution(skill, FALSE)
	if(LAZYLEN(skill.default_attributes))
		var/fallback = best_default(skill, FALSE)
		if(!isnull(fallback) && (isnull(.) || fallback > .))
			. = fallback

/datum/attribute_holder/proc/return_effective_skill(skill_type)
	if(parent && HAS_TRAIT(parent, TRAIT_ROGUE_NO_SKILLS))
		return 0
	. = attribute_list[skill_type]
	var/datum/attribute/skill/skill = GET_ROGUE_ATTRIBUTE(skill_type)
	if(!istype(skill))
		return
	if(skill.governing_attribute && !isnull(.) && . > 0)
		. += governing_contribution(skill, TRUE)
	if(LAZYLEN(skill.default_attributes))
		var/fallback = best_default(skill, TRUE)
		if(!isnull(fallback) && (isnull(.) || fallback > .))
			. = fallback

/datum/attribute_holder/proc/return_raw_calculated_skill(attribute_type)
	if(parent && HAS_TRAIT(parent, TRAIT_ROGUE_NO_SKILLS))
		return 0
	. = raw_attribute_list[attribute_type]
	var/datum/attribute/skill/skill = GET_ROGUE_ATTRIBUTE(attribute_type)
	if(istype(skill) && !isnull(.) && skill.governing_attribute)
		. += governing_contribution(skill, FALSE)

/datum/attribute_holder/proc/return_calculated_skill(attribute_type)
	if(parent && HAS_TRAIT(parent, TRAIT_ROGUE_NO_SKILLS))
		return 0
	. = attribute_list[attribute_type]
	var/datum/attribute/skill/skill = GET_ROGUE_ATTRIBUTE(attribute_type)
	if(istype(skill) && !isnull(.) && skill.governing_attribute)
		. += governing_contribution(skill, TRUE)

/datum/attribute_holder/proc/skill_breakdown(skill_type)
	var/list/breakdown = list("base" = raw_attribute_list[skill_type], "governing" = 0, "defaulted" = 0)
	var/datum/attribute/skill/skill = GET_ROGUE_ATTRIBUTE(skill_type)
	var/value = attribute_list[skill_type]
	if(istype(skill) && skill.governing_attribute && !isnull(value) && value > 0)
		breakdown["governing"] = governing_contribution(skill, TRUE)
		value += breakdown["governing"]
	if(istype(skill) && LAZYLEN(skill.default_attributes))
		var/fallback = best_default(skill, TRUE)
		if(!isnull(fallback) && (isnull(value) || fallback > value))
			breakdown["defaulted"] = fallback - ROGUE_NULLTOZERO(value)
			value = fallback
	breakdown["value"] = value
	return breakdown

/datum/attribute_holder/proc/sheet_from(datum/attribute_holder/sheet/sheet)
	if(istype(sheet))
		return sheet
	if(!ispath(sheet, /datum/attribute_holder/sheet))
		return null
	if(!GLOB.rogue_attribute_sheets[sheet])
		GLOB.rogue_attribute_sheets[sheet] = new sheet
	return GLOB.rogue_attribute_sheets[sheet]

/datum/attribute_holder/proc/add_sheet(datum/attribute_holder/sheet/to_add)
	var/datum/attribute_holder/sheet/sheet = sheet_from(to_add)
	if(sheet)
		add_holder(sheet)

/datum/attribute_holder/proc/subtract_sheet(datum/attribute_holder/sheet/to_remove)
	var/datum/attribute_holder/sheet/sheet = sheet_from(to_remove)
	if(sheet)
		subtract_holder(sheet)

/datum/attribute_holder/proc/add_holder(datum/attribute_holder/to_add)
	for(var/attribute_type in to_add.raw_attribute_list)
		var/amount = to_add.raw_attribute_list[attribute_type]
		if(isnull(amount))
			continue
		if(ispath(attribute_type, ROGUE_SKILL))
			var/old_value = raw_attribute_list[attribute_type]
			raw_attribute_list[attribute_type] = clamp(ROGUE_NULLTOZERO(old_value) + amount, skill_min, skill_max)
			on_skill_level_changed(attribute_type, raw_attribute_list[attribute_type], old_value)
		else
			raw_attribute_list[attribute_type] = clamp(ROGUE_NULLTOZERO(raw_attribute_list[attribute_type]) + amount, attribute_min, attribute_max)
	for(var/skill_type in to_add.skill_xp_multipliers)
		adjust_skill_xp_multiplier(skill_type, to_add.skill_xp_multipliers[skill_type] - 1)
	to_add.on_add(src)
	update_attributes()
	seed_skill_xp()

/datum/attribute_holder/proc/subtract_holder(datum/attribute_holder/to_remove)
	for(var/attribute_type in to_remove.raw_attribute_list)
		var/amount = to_remove.raw_attribute_list[attribute_type]
		if(isnull(amount))
			continue
		if(ispath(attribute_type, ROGUE_SKILL))
			var/old_value = raw_attribute_list[attribute_type]
			raw_attribute_list[attribute_type] = clamp(ROGUE_NULLTOZERO(old_value) - amount, skill_min, skill_max)
			on_skill_level_changed(attribute_type, raw_attribute_list[attribute_type], old_value)
		else
			raw_attribute_list[attribute_type] = clamp(ROGUE_NULLTOZERO(raw_attribute_list[attribute_type]) - amount, attribute_min, attribute_max)
	for(var/skill_type in to_remove.skill_xp_multipliers)
		adjust_skill_xp_multiplier(skill_type, -(to_remove.skill_xp_multipliers[skill_type] - 1))
	to_remove.on_remove(src)
	update_attributes()
	seed_skill_xp()

/datum/attribute_holder/proc/on_add(datum/attribute_holder/receiver)
	return

/datum/attribute_holder/proc/on_remove(datum/attribute_holder/receiver)
	return

/datum/attribute_holder/proc/adjust_stat(stat_type, amount)
	if(!ispath(stat_type, ROGUE_STAT) || !amount)
		return
	raw_attribute_list[stat_type] = clamp(ROGUE_NULLTOZERO(raw_attribute_list[stat_type]) + amount, attribute_min, attribute_max)
	update_attributes()

/datum/attribute_holder/proc/set_skill_level(skill_type, level, silent = TRUE)
	if(!ispath(skill_type, ROGUE_SKILL))
		return
	level = clamp(level, skill_min, skill_max)
	var/old_level = ROGUE_NULLTOZERO(raw_attribute_list[skill_type])
	LAZYSET(skill_xp, skill_type, xp_for_level(level))
	if(level != old_level || isnull(raw_attribute_list[skill_type]))
		apply_skill_level(skill_type, level, old_level, silent)

/datum/attribute_holder/proc/adjust_skill_level(skill_type, delta, max_level, silent = FALSE)
	if(!ispath(skill_type, ROGUE_SKILL))
		return
	var/current = ROGUE_NULLTOZERO(raw_attribute_list[skill_type])
	var/target = clamp(current + delta, skill_min, skill_max)
	if(!isnull(max_level))
		target = min(target, max_level)
	if(target != current)
		set_skill_level(skill_type, target, silent)

/datum/attribute_holder/proc/raise_skill_to(skill_type, level, silent = TRUE)
	if(ROGUE_NULLTOZERO(raw_attribute_list[skill_type]) < level)
		set_skill_level(skill_type, level, silent)

/datum/attribute_holder/proc/purge_all_skills(silent = TRUE)
	for(var/skill_type in raw_attribute_list)
		if(!ispath(skill_type, ROGUE_SKILL) || isnull(raw_attribute_list[skill_type]))
			continue
		LAZYSET(skill_xp, skill_type, 0)
		apply_skill_level(skill_type, null, raw_attribute_list[skill_type], TRUE)
	if(!silent && parent)
		to_chat(parent, span_boldwarning("I forget all my skills!"))

/datum/attribute_holder/proc/apply_skill_level(skill_type, new_level, old_level, silent)
	raw_attribute_list[skill_type] = new_level
	update_attributes()
	if(parent)
		SEND_SIGNAL(parent, COMSIG_ROGUE_SKILL_CHANGED, skill_type, new_level, old_level)
	on_skill_level_changed(skill_type, new_level, old_level)
	if(silent || !parent)
		return
	var/old_tier = floor(ROGUE_NULLTOZERO(old_level) / ROGUE_SKILL_PER_RANK)
	var/new_tier = floor(ROGUE_NULLTOZERO(new_level) / ROGUE_SKILL_PER_RANK)
	if(old_tier == new_tier)
		return
	var/datum/attribute/skill/skill = GET_ROGUE_ATTRIBUTE(skill_type)
	if(new_tier > old_tier)
		to_chat(parent, span_nicegreen("My proficiency in [skill.name] grows to [skill.description_from_level(return_raw_effective_skill(skill_type))]!"))
	else
		to_chat(parent, span_warning("My [skill.name] has weakened to [skill.description_from_level(return_raw_effective_skill(skill_type))]!"))

/datum/attribute_holder/proc/on_skill_level_changed(skill_type, new_level, old_level)
	var/datum/attribute/skill = GET_ROGUE_ATTRIBUTE(skill_type)
	skill?.on_level_change(parent, new_level, old_level)

/datum/attribute_holder/proc/attribute_probability(modifier = ROGUE_ATTRIBUTE_MIDDLING, base_prob = 50, delta_value = ROGUE_ATTRIBUTE_MIDDLING, increment = 5)
	return base_prob + (modifier - delta_value) * increment

/datum/attribute_holder/proc/diceroll(requirement = 0, crit = 10, dice_num = 3, dice_sides = 6, count_modifiers = TRUE, context = ROGUE_DICE_PHYSICAL, return_flags = ROGUE_DICE_RETURN_SUCCESS)
	var/dice = roll(dice_num, dice_sides)
	var/requirement_sum = requirement
	if(count_modifiers)
		var/final_modifier = (get_diceroll_modifier(context) / 18) * dice_num * dice_sides
		requirement_sum += final_modifier >= 0 ? CEILING(final_modifier, 1) : FLOOR(final_modifier, 1)
	var/difference = dice - requirement_sum
	var/result
	if(dice <= requirement_sum)
		var/bonus = 0
		if(dice_num == 3 && dice_sides == 6)
			bonus = requirement_sum >= 16 ? 3 : (requirement_sum >= 15 ? 2 : 1)
		result = dice <= max(dice_num + bonus, requirement_sum - crit) ? ROGUE_DICE_CRIT_SUCCESS : ROGUE_DICE_SUCCESS
	else
		var/malus = (dice_num == 3 && dice_sides == 6 && requirement_sum <= 15) ? 1 : 0
		result = dice >= min((dice_num * dice_sides) - malus, requirement_sum + crit) ? ROGUE_DICE_CRIT_FAILURE : ROGUE_DICE_FAILURE
	if((return_flags & ROGUE_DICE_RETURN_BOTH) == ROGUE_DICE_RETURN_BOTH)
		return list(result, difference)
	if(return_flags & ROGUE_DICE_RETURN_DIFFERENCE)
		return difference
	return result
