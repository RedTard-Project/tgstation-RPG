/// Magic in Rogue Systems: give a person a spell of the basket (with mana and the magic of a magic user, if they lack them),
/// take one away, set their mana, give them points for the spellbook, and look the basket over with whose each spell was in
/// the forks and which of its numbers magic.txt lacks. Until the owner hands the spells out to roles, this is how they reach
/// the game (block M2's test: every fork's spells are granted by an admin and cast).

/proc/rogue_admin_grant_spell(client/user, mob/living/carbon/human/target)
	if(!rogue_magic_enabled())
		to_chat(user, span_warning("Magic works on medieval maps only."), confidential = TRUE)
		return
	var/list/choices = list()
	for(var/spell_type in rogue_spell_basket())
		choices[rogue_spell_summary(spell_type)] = spell_type
	var/picked = tgui_input_list(user, "Which spell shall [target] be granted?", "Grant Spell", choices)
	if(!picked || QDELETED(target))
		return
	var/spell_type = choices[picked]
	if(locate(spell_type) in target.actions)
		to_chat(user, span_warning("[target] already has that spell."), confidential = TRUE)
		return
	var/datum/action/cooldown/spell/spell = new spell_type(target.mind || target)
	spell.Grant(target)
	target.rogue_attune_magic()
	log_admin("[key_name(user)] granted the spell [spell.name] to [key_name(target)].")
	message_admins("[key_name_admin(user)] granted the spell [spell.name] to [key_name_admin(target)].")

/proc/rogue_admin_remove_spell(client/user, mob/living/carbon/human/target)
	var/list/spells = list()
	for(var/datum/action/cooldown/spell/rogue/spell in target.actions)
		spells["[spell.name] ([spell.type])"] = spell
	if(!length(spells))
		to_chat(user, span_warning("[target] has no spells."), confidential = TRUE)
		return
	var/picked = tgui_input_list(user, "Which spell shall [target] lose?", "Remove Spell", spells)
	var/datum/action/cooldown/spell/rogue/taken = spells[picked]
	if(!taken || QDELETED(taken))
		return
	var/datum/rogue_spell_mastery/mastery = target.rogue_spell_mastery
	if(mastery)
		mastery.learned -= taken.type
	log_admin("[key_name(user)] took the spell [taken.name] from [key_name(target)].")
	message_admins("[key_name_admin(user)] took the spell [taken.name] from [key_name_admin(target)].")
	qdel(taken)

/proc/rogue_admin_adjust_mana(client/user, mob/living/carbon/human/target)
	if(!rogue_magic_enabled())
		to_chat(user, span_warning("Magic works on medieval maps only."), confidential = TRUE)
		return
	var/datum/rogue_mana/mana = target.rogue_get_mana()
	var/list/options = list("Fill to the soft cap", "Add mana", "Make a magic user", "Stop being a magic user", "Give spellbook points")
	var/what = tgui_input_list(user, "[target]'s mana: [round(mana.amount)]/[round(mana.softcap())] (hard cap [mana.capacity]); magic user: [HAS_TRAIT(target, TRAIT_ARCYNE) ? "yes" : "no"].", "Adjust Mana", options)
	if(!what || QDELETED(target) || QDELETED(mana))
		return
	switch(what)
		if("Fill to the soft cap")
			mana.adjust(mana.softcap() - mana.amount)
		if("Add mana")
			var/amount = tgui_input_number(user, "How much mana to add (negative to take)? It may pass the soft cap.", "Adjust Mana", 100, mana.capacity, -mana.capacity)
			if(isnull(amount) || QDELETED(mana))
				return
			mana.adjust(amount)
		if("Make a magic user")
			target.rogue_attune_magic()
		if("Stop being a magic user")
			REMOVE_TRAIT(target, TRAIT_ARCYNE, ROGUE_MAGIC_TRAIT)
		if("Give spellbook points")
			var/form_points = tgui_input_number(user, "Form points?", "Spellbook Points", 1, 50, -50)
			var/technique_points = tgui_input_number(user, "Technique points?", "Spellbook Points", 1, 50, -50)
			if(QDELETED(target))
				return
			target.rogue_give_spell_points(form_points || 0, technique_points || 0)
	log_admin("[key_name(user)] adjusted the mana of [key_name(target)]: [what].")
	message_admins("[key_name_admin(user)] adjusted the mana of [key_name_admin(target)]: [what].")

/// What the basket says of a spell type: name, form and technique, price and the fork it came from.
/proc/rogue_spell_summary(datum/action/cooldown/spell/rogue/spell_type)
	var/form = initial(spell_type.required_form)
	return "[initial(spell_type.name)] ([form ? "[form], [initial(spell_type.required_technique) || "no technique"]" : "no form"]; [rogue_spell_tune(spell_type, "cost")] mana; [initial(spell_type.spell_forks)])"

/proc/rogue_admin_show_spell_basket(client/user)
	var/list/rows = list("<table><tr><th>Spell</th><th>Form</th><th>Technique</th><th>Form rank</th><th>Forks</th><th>Source type</th><th>Missing numbers</th><th>Type</th></tr>")
	for(var/datum/action/cooldown/spell/rogue/spell_type as anything in rogue_spell_basket())
		var/datum/action/cooldown/spell/rogue/prototype = rogue_spell_prototype(spell_type)
		var/list/missing = list()
		for(var/tunable in prototype.tunables)
			if(isnull(rogue_value_or("[prototype.value_key()]_[tunable]", null)))
				missing += tunable
		rows += "<tr><td>[initial(spell_type.name)]</td><td>[initial(spell_type.required_form)]</td><td>[initial(spell_type.required_technique)]</td><td>[initial(spell_type.required_level)]</td><td>[initial(spell_type.spell_forks)]</td><td>[initial(spell_type.spell_source_type)]</td><td>[jointext(missing, ", ")]</td><td>[spell_type]</td></tr>"
	rows += "</table>"
	var/datum/browser/popup = new(user.mob, "rogue_spell_basket", "The Basket of Spells", 1000, 600)
	popup.set_content(jointext(rows, ""))
	popup.open()

ADMIN_VERB_AND_CONTEXT_MENU(rogue_grant_spell, R_ADMIN, "Grant Spell", "Give a person a spell of the basket, and the mana of a magic user to cast it.", ADMIN_CATEGORY_ROGUE, /mob/living/carbon/human)
	VERB_ARG_TYPED(target, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /mob/living/carbon/human)
	rogue_admin_grant_spell(user, target)
	BLACKBOX_LOG_ADMIN_VERB("Grant Spell")

ADMIN_VERB_AND_CONTEXT_MENU(rogue_remove_spell, R_ADMIN, "Remove Spell", "Take a spell away from a person.", ADMIN_CATEGORY_ROGUE, /mob/living/carbon/human)
	VERB_ARG_TYPED(target, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /mob/living/carbon/human)
	rogue_admin_remove_spell(user, target)
	BLACKBOX_LOG_ADMIN_VERB("Remove Spell")

ADMIN_VERB_AND_CONTEXT_MENU(rogue_adjust_mana, R_ADMIN, "Adjust Mana", "Fill, add or take a person's mana, make them a magic user or give them spellbook points.", ADMIN_CATEGORY_ROGUE, /mob/living/carbon/human)
	VERB_ARG_TYPED(target, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /mob/living/carbon/human)
	rogue_admin_adjust_mana(user, target)
	BLACKBOX_LOG_ADMIN_VERB("Adjust Mana")

ADMIN_VERB(rogue_show_spell_basket, R_ADMIN, "Spell Basket", "Every spell ported, with its form, technique, the forks it came from and the numbers magic.txt lacks.", ADMIN_CATEGORY_ROGUE)
	rogue_admin_show_spell_basket(user)
	BLACKBOX_LOG_ADMIN_VERB("Spell Basket")
