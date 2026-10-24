GLOBAL_VAR_INIT(rogue_skill_xp_modifier, 1)

/datum/attribute_holder/proc/xp_for_level(level)
	level = clamp(ROGUE_NULLTOZERO(level), skill_min, skill_max)
	if(level >= ROGUE_SKILL_LEVEL_LEGENDARY)
		return ROGUE_SKILL_XP_LEGENDARY
	var/static/list/floors = list(ROGUE_SKILL_XP_NONE, ROGUE_SKILL_XP_NOVICE, ROGUE_SKILL_XP_APPRENTICE, ROGUE_SKILL_XP_JOURNEYMAN, ROGUE_SKILL_XP_EXPERT, ROGUE_SKILL_XP_MASTER, ROGUE_SKILL_XP_LEGENDARY)
	var/tier = floor(level / ROGUE_SKILL_PER_RANK)
	var/progress = (level - tier * ROGUE_SKILL_PER_RANK) / ROGUE_SKILL_PER_RANK
	return floors[tier + 1] + progress * (floors[tier + 2] - floors[tier + 1])

/datum/attribute_holder/proc/level_for_xp(xp)
	var/static/list/floors = list(ROGUE_SKILL_XP_NONE, ROGUE_SKILL_XP_NOVICE, ROGUE_SKILL_XP_APPRENTICE, ROGUE_SKILL_XP_JOURNEYMAN, ROGUE_SKILL_XP_EXPERT, ROGUE_SKILL_XP_MASTER, ROGUE_SKILL_XP_LEGENDARY)
	if(xp <= ROGUE_SKILL_XP_NONE)
		return ROGUE_SKILL_LEVEL_NONE
	if(xp >= ROGUE_SKILL_XP_LEGENDARY)
		return ROGUE_SKILL_LEVEL_LEGENDARY
	for(var/tier in length(floors) - 1 to 1 step -1)
		if(xp >= floors[tier])
			var/progress = (xp - floors[tier]) / (floors[tier + 1] - floors[tier])
			return floor((tier - 1) * ROGUE_SKILL_PER_RANK + progress * ROGUE_SKILL_PER_RANK)
	return ROGUE_SKILL_LEVEL_NONE

/datum/attribute_holder/proc/get_skill_xp(skill_type)
	return LAZYACCESS(skill_xp, skill_type) || 0

/datum/attribute_holder/proc/seed_skill_xp(skill_type)
	if(skill_type)
		seed_single_skill_xp(skill_type)
		return
	for(var/each_skill in raw_attribute_list)
		if(ispath(each_skill, ROGUE_SKILL))
			seed_single_skill_xp(each_skill)

/datum/attribute_holder/proc/seed_single_skill_xp(skill_type)
	var/current_level = ROGUE_NULLTOZERO(raw_attribute_list[skill_type])
	var/current_xp = get_skill_xp(skill_type)
	var/xp_level = level_for_xp(current_xp)
	if(xp_level == current_level)
		return
	var/old_floor = xp_for_level(xp_level)
	var/progress = (current_xp - old_floor) / max(1, xp_for_level(xp_level + 1) - old_floor)
	var/new_floor = xp_for_level(current_level)
	LAZYSET(skill_xp, skill_type, new_floor + progress * (xp_for_level(current_level + 1) - new_floor))

/datum/attribute_holder/proc/adjust_experience(skill_type, amount, silent = FALSE, shared = TRUE)
	if(!ispath(skill_type, ROGUE_SKILL) || (parent && HAS_TRAIT(parent, TRAIT_ROGUE_NO_EXPERIENCE)))
		return FALSE
	if(shared)
		share_parent_skill_xp(skill_type, amount, silent)
	amount *= GLOB.rogue_skill_xp_modifier * get_skill_xp_multiplier(skill_type)
	var/new_xp = clamp(get_skill_xp(skill_type) + amount, 0, xp_for_level(skill_max))
	LAZYSET(skill_xp, skill_type, new_xp)
	var/old_level = raw_attribute_list[skill_type]
	var/new_level = clamp(level_for_xp(new_xp), skill_min, skill_max)
	if(new_level != ROGUE_NULLTOZERO(old_level) || isnull(old_level))
		apply_skill_level(skill_type, new_level, old_level, silent)
	else
		SStgui.update_uis(src)
	return TRUE

/datum/attribute_holder/proc/share_parent_skill_xp(skill_type, amount, silent)
	var/datum/attribute/skill/skill = GET_ROGUE_ATTRIBUTE(skill_type)
	if(!istype(skill) || !skill.shared_xp_percent || !LAZYLEN(skill.default_attributes))
		return
	var/shared_amount = floor(amount * skill.shared_xp_percent)
	if(!shared_amount)
		return
	for(var/parent_skill in skill.default_attributes)
		if(ispath(parent_skill, ROGUE_SKILL))
			adjust_experience(parent_skill, shared_amount, silent, FALSE)

/datum/attribute_holder/proc/get_skill_xp_multiplier(skill_type)
	. = LAZYACCESS(skill_xp_multipliers, skill_type) || 1
	var/datum/attribute/skill/skill = GET_ROGUE_ATTRIBUTE(skill_type)
	if(!istype(skill) || !LAZYLEN(skill.default_attributes))
		return
	var/current_level = ROGUE_NULLTOZERO(raw_attribute_list[skill_type])
	var/default_floor = 0
	for(var/attribute_type in skill.default_attributes)
		if(ispath(attribute_type, ROGUE_SKILL))
			default_floor = max(default_floor, ROGUE_NULLTOZERO(raw_attribute_list[attribute_type]) + skill.default_attributes[attribute_type])
	if(current_level < default_floor)
		. += (skill.catchup_multiplier - 1) * min((default_floor - current_level) / max(1, skill.catchup_level_range), 1)

/datum/attribute_holder/proc/set_skill_xp_multiplier(skill_type, multiplier)
	LAZYSET(skill_xp_multipliers, skill_type, max(0, multiplier))

/datum/attribute_holder/proc/adjust_skill_xp_multiplier(skill_type, delta)
	LAZYSET(skill_xp_multipliers, skill_type, max(0, (LAZYACCESS(skill_xp_multipliers, skill_type) || 1) + delta))

/datum/attribute_holder/proc/remove_skill_xp_multiplier(skill_type)
	LAZYREMOVE(skill_xp_multipliers, skill_type)
