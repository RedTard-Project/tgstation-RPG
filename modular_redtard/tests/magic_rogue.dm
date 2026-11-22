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
#endif
