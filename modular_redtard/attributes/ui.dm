GLOBAL_LIST_EMPTY(rogue_attribute_static_data)

/proc/rogue_attribute_static_data()
	if(length(GLOB.rogue_attribute_static_data))
		return GLOB.rogue_attribute_static_data
	var/list/stats = list()
	for(var/stat_type in GLOB.rogue_stats)
		var/datum/attribute/stat/stat = GLOB.rogue_stats[stat_type]
		stats += list(list("key" = "[stat_type]", "name" = stat.name, "shorthand" = stat.shorthand, "desc" = stat.desc))
	var/list/categories = list()
	for(var/category in GLOB.rogue_skill_categories)
		var/list/skills = list()
		for(var/skill_type in GLOB.rogue_skill_categories[category])
			var/datum/attribute/skill/skill = GLOB.rogue_skills[skill_type]
			var/datum/attribute/governing = GET_ROGUE_ATTRIBUTE(skill.governing_attribute)
			var/list/defaults = list()
			for(var/default_type in skill.default_attributes)
				var/datum/attribute/default_attribute = GET_ROGUE_ATTRIBUTE(default_type)
				if(default_attribute)
					defaults += list(list("name" = default_attribute.name, "value" = skill.default_attributes[default_type]))
			skills += list(list(
				"key" = "[skill_type]",
				"name" = skill.name,
				"desc" = skill.desc,
				"difficulty" = skill.difficulty,
				"governing" = governing?.name,
				"defaults" = defaults,
			))
		categories += list(list("name" = category, "skills" = skills))
	GLOB.rogue_attribute_static_data = list("stat_meta" = stats, "categories" = categories)
	return GLOB.rogue_attribute_static_data

/datum/attribute_holder/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RogueAttributes")
		ui.open()

/datum/attribute_holder/ui_state(mob/user)
	return GLOB.always_state

/datum/attribute_holder/ui_static_data(mob/user)
	return rogue_attribute_static_data()

/datum/attribute_holder/ui_data(mob/user)
	var/list/stats = list()
	for(var/stat_type in GLOB.rogue_stats)
		var/datum/attribute/stat/stat = GLOB.rogue_stats[stat_type]
		var/value = ROGUE_NULLTOZERO(attribute_list[stat_type])
		stats["[stat_type]"] = list(
			"base" = ROGUE_NULLTOZERO(raw_attribute_list[stat_type]),
			"value" = value,
			"level" = stat.description_from_level(value),
		)
	var/list/skills = list()
	for(var/skill_type in GLOB.rogue_skills)
		var/datum/attribute/skill/skill = GLOB.rogue_skills[skill_type]
		var/list/breakdown = skill_breakdown(skill_type)
		var/xp = get_skill_xp(skill_type)
		var/base = raw_attribute_list[skill_type]
		var/floor_level = floor(ROGUE_NULLTOZERO(base) / ROGUE_SKILL_PER_RANK) * ROGUE_SKILL_PER_RANK
		skills["[skill_type]"] = list(
			"base" = base,
			"value" = breakdown["value"],
			"governing" = breakdown["governing"],
			"defaulted" = breakdown["defaulted"],
			"level" = skill.description_from_level(breakdown["value"]),
			"rank" = clamp(floor(ROGUE_NULLTOZERO(breakdown["value"]) / ROGUE_SKILL_PER_RANK), 0, ROGUE_SKILL_RANK_MAX),
			"trained" = !isnull(base),
			"xp" = round(xp, 1),
			"xp_floor" = round(xp_for_level(floor_level), 1),
			"xp_next" = round(xp_for_level(min(floor_level + ROGUE_SKILL_PER_RANK, skill_max)), 1),
		)
	var/list/modifiers = list()
	for(var/key in get_attribute_modification())
		var/datum/attribute_modifier/modifier = attribute_modification[key]
		var/list/changes = list()
		for(var/attribute_type in modifier.attribute_list)
			var/datum/attribute/attribute = GET_ROGUE_ATTRIBUTE(attribute_type)
			if(attribute && modifier.attribute_list[attribute_type])
				changes += list(list("name" = attribute.name, "value" = modifier.attribute_list[attribute_type]))
		if(length(changes))
			modifiers += list(list("id" = modifier.id, "changes" = changes))
	return list(
		"name" = parent?.real_name || parent?.name,
		"stats" = stats,
		"skills" = skills,
		"modifiers" = modifiers,
	)

/mob/living/proc/rogue_open_attributes(mob/viewer)
	if(!attributes)
		to_chat(viewer, span_warning("[src] has no attributes."))
		return
	attributes.ui_interact(viewer)

GAME_VERB_DESC(/mob/living, rogue_check_attributes, "Attributes", "Look over your stats and skills.", "IC")
	rogue_open_attributes(src)
