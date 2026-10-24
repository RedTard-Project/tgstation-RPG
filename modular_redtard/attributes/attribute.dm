GLOBAL_LIST_INIT(rogue_attributes, rogue_init_attributes())
GLOBAL_LIST_INIT(rogue_stats, rogue_attributes_of(ROGUE_STAT))
GLOBAL_LIST_INIT(rogue_skills, rogue_attributes_of(ROGUE_SKILL))
GLOBAL_LIST_INIT(rogue_skill_categories, rogue_init_skill_categories())
GLOBAL_LIST_EMPTY(rogue_attribute_sheets)
GLOBAL_LIST_EMPTY(rogue_attribute_modifier_cache)
GLOBAL_LIST_EMPTY(rogue_diceroll_modifier_cache)

/proc/rogue_init_attributes()
	. = list()
	for(var/datum/attribute/attribute as anything in init_subtypes(/datum/attribute))
		if(isnull(attribute.name))
			qdel(attribute)
			continue
		.[attribute.type] = attribute

/proc/rogue_attributes_of(root)
	. = list()
	for(var/attribute_type in GLOB.rogue_attributes)
		if(ispath(attribute_type, root))
			.[attribute_type] = GLOB.rogue_attributes[attribute_type]

/proc/rogue_init_skill_categories()
	. = list()
	for(var/skill_type in GLOB.rogue_skills)
		var/datum/attribute/skill/skill = GLOB.rogue_skills[skill_type]
		LAZYADD(.[skill.category], skill_type)

/datum/attribute
	var/name
	var/desc = ""

/datum/attribute/proc/description_from_level(level)
	return ""

/datum/attribute/proc/on_level_change(mob/living/owner, new_level, old_level)
	return

/datum/attribute/stat
	var/shorthand = ""

/datum/attribute/stat/description_from_level(level)
	switch(ROGUE_NULLTOZERO(level))
		if(-INFINITY to 5)
			return "dismal"
		if(6 to 8)
			return "poor"
		if(9 to 11)
			return "average"
		if(12 to 14)
			return "good"
		if(15 to 17)
			return "excellent"
	return "legendary"

/datum/attribute/stat/strength
	name = "Strength"
	shorthand = "STR"
	desc = "Strength measures how strong your blows are, as well as your capacity at carrying weight."

/datum/attribute/stat/perception
	name = "Perception"
	shorthand = "PER"
	desc = "Perception measures your general alertness and keenness of sight."

/datum/attribute/stat/intelligence
	name = "Intelligence"
	shorthand = "INT"
	desc = "Intelligence measures your abilities to perform magic and retain information."

/datum/attribute/stat/constitution
	name = "Constitution"
	shorthand = "CON"
	desc = "Constitution measures your ability to withstand damage."

/datum/attribute/stat/willpower
	name = "Willpower"
	shorthand = "WIL"
	desc = "Willpower measures your ability to handle pain and physical activity."

/datum/attribute/stat/speed
	name = "Speed"
	shorthand = "SPD"
	desc = "Speed measures your reflexes and balance, making you better at landing blows as well as avoiding them."

/datum/attribute/stat/fortune
	name = "Fortune"
	shorthand = "FOR"
	desc = "Fortune measures your luck and ability to defy odds."

/datum/attribute/skill
	var/category = ROGUE_SKILL_CATEGORY_GENERAL
	var/governing_attribute
	var/list/default_attributes
	var/difficulty = ROGUE_SKILL_DIFFICULTY_AVERAGE
	var/list/dreams
	var/catchup_level_range = ROGUE_SKILL_XP_CATCHUP_RANGE
	var/catchup_multiplier = ROGUE_SKILL_XP_CATCHUP_MAX
	var/shared_xp_percent = 0

/datum/attribute/skill/description_from_level(level)
	if(isnull(level))
		return "untrained"
	switch(CEILING(level, 1))
		if(-INFINITY to 9)
			return "untrained"
		if(10 to 19)
			return "novice"
		if(20 to 29)
			return "apprentice"
		if(30 to 39)
			return "journeyman"
		if(40 to 49)
			return "expert"
		if(50 to 59)
			return "master"
	return "legendary"

/datum/attribute/skill/proc/get_skill_speed_modifier(level)
	if(isnull(level) || level < ROGUE_SKILL_LEVEL_NOVICE)
		return 1.3
	if(level < ROGUE_SKILL_LEVEL_APPRENTICE)
		return 1.2
	if(level < ROGUE_SKILL_LEVEL_JOURNEYMAN)
		return 1.1
	if(level < ROGUE_SKILL_LEVEL_EXPERT)
		return 1
	if(level < ROGUE_SKILL_LEVEL_MASTER)
		return 0.9
	if(level < ROGUE_SKILL_LEVEL_LEGENDARY)
		return 0.75
	return 0.5
