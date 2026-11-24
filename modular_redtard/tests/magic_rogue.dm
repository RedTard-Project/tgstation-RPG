#ifdef UNIT_TESTS
/// Every spell of the basket (magic/spell.dm) has its button, says which forks it came from, has every number it names in
/// magic.txt, and a spell the spellbook sells names a form and a technique of the book (magic/mastery.dm).
/datum/unit_test/rogue_spell_basket

/datum/unit_test/rogue_spell_basket/Run()
	var/list/basket = rogue_spell_basket()
	if(!length(basket))
		Fail("The basket of spells is empty.", __FILE__, __LINE__)
	for(var/datum/action/cooldown/spell/rogue/spell_type as anything in basket)
		var/icon_file = initial(spell_type.button_icon)
		var/state = initial(spell_type.button_icon_state)
		if(!icon_exists(icon_file, state))
			Fail("[spell_type] has no button icon state \"[state]\" in [icon_file].", __FILE__, __LINE__)
		if(!length(initial(spell_type.spell_forks)))
			Fail("[spell_type] does not say which forks it came from.", __FILE__, __LINE__)
		var/form = initial(spell_type.required_form)
		if(form && !(form in GLOB.rogue_spell_forms))
			Fail("[spell_type] has the form \"[form]\", which the spellbook does not know.", __FILE__, __LINE__)
		var/technique = initial(spell_type.required_technique)
		if(technique && !(technique in GLOB.rogue_spell_techniques))
			Fail("[spell_type] has the technique \"[technique]\", which the spellbook does not know.", __FILE__, __LINE__)
		var/datum/action/cooldown/spell/rogue/prototype = rogue_spell_prototype(spell_type)
		for(var/tunable in prototype.tunables)
			if(isnull(rogue_value_or("[prototype.value_key()]_[tunable]", null)))
				Fail("[spell_type] names the number \"[tunable]\", but magic.txt has no [prototype.value_key()]_[tunable].", __FILE__, __LINE__)
		var/skill = initial(spell_type.associated_skill)
		if(skill && !GLOB.rogue_skills[skill])
			Fail("[spell_type] trains [skill], which is not a skill.", __FILE__, __LINE__)

/// Every form of the spellbook has its skill (magic/skills.dm), and an Arcyne sub-skill stands on Arcyne Magic: it defaults
/// to it and shares experience with it.
/datum/unit_test/rogue_magic_subskills

/datum/unit_test/rogue_magic_subskills/Run()
	for(var/form in GLOB.rogue_spell_forms)
		var/skill_type = rogue_form_skill(form)
		var/datum/attribute/skill/skill = GLOB.rogue_skills[skill_type]
		if(!istype(skill))
			Fail("The form [form] has no skill.", __FILE__, __LINE__)
			continue
		if(!ispath(skill_type, /datum/attribute/skill/magic/arcane) || skill_type == /datum/attribute/skill/magic/arcane)
			continue
		if(isnull(LAZYACCESS(skill.default_attributes, /datum/attribute/skill/magic/arcane)))
			Fail("[skill_type] does not default to Arcyne Magic.", __FILE__, __LINE__)
		if(skill.shared_xp_percent <= 0)
			Fail("[skill_type] shares no experience with Arcyne Magic.", __FILE__, __LINE__)

/// Every Vibelin role a role of the port answers to (magic/points.dm) has its spellbook points in magic.txt.
/datum/unit_test/rogue_role_spell_points

/datum/unit_test/rogue_role_spell_points/Run()
	var/list/keys = list("arcyne")
	var/list/table = rogue_role_spell_point_table()
	for(var/role_type in table)
		keys |= table[role_type]
	for(var/key in keys)
		for(var/kind in list("form", "technique"))
			if(isnull(rogue_value_or("magic_points_[key]_[kind]", null)))
				Fail("magic.txt has no magic_points_[key]_[kind].", __FILE__, __LINE__)
#endif
