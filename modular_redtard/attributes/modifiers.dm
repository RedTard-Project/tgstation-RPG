/datum/attribute_modifier
	var/variable = FALSE
	var/id
	var/priority = 0
	var/list/attribute_list
	var/conflicts_with

/datum/attribute_modifier/New()
	. = ..()
	if(!id)
		id = "[type]"

/datum/attribute_modifier/variable
	variable = TRUE

/proc/rogue_cached_attribute_modifier(datum/attribute_modifier/modifier_type)
	if(!ispath(modifier_type, /datum/attribute_modifier))
		CRASH("[modifier_type] is not an attribute modifier typepath.")
	if(initial(modifier_type.variable))
		CRASH("[modifier_type] is a variable modifier and can never be cached.")
	if(!GLOB.rogue_attribute_modifier_cache[modifier_type])
		GLOB.rogue_attribute_modifier_cache[modifier_type] = new modifier_type
	return GLOB.rogue_attribute_modifier_cache[modifier_type]

/datum/attribute_holder/proc/modifier_key(datum/attribute_modifier/type_id_datum)
	if(ispath(type_id_datum))
		return initial(type_id_datum.id) || "[type_id_datum]"
	if(istext(type_id_datum))
		return type_id_datum
	return type_id_datum.id

/datum/attribute_holder/proc/add_attribute_modifier(datum/attribute_modifier/type_or_datum, update = TRUE)
	if(ispath(type_or_datum))
		type_or_datum = initial(type_or_datum.variable) ? new type_or_datum : rogue_cached_attribute_modifier(type_or_datum)
	var/datum/attribute_modifier/existing = LAZYACCESS(attribute_modification, type_or_datum.id)
	if(existing == type_or_datum)
		return TRUE
	if(existing)
		remove_attribute_modifier(existing, FALSE)
	if(length(attribute_modification))
		BINARY_INSERT(type_or_datum.id, attribute_modification, /datum/attribute_modifier, type_or_datum, priority, COMPARE_VALUE)
	LAZYSET(attribute_modification, type_or_datum.id, type_or_datum)
	if(update)
		update_attributes()
	return TRUE

/datum/attribute_holder/proc/remove_attribute_modifier(datum/attribute_modifier/type_id_datum, update = TRUE)
	var/key = modifier_key(type_id_datum)
	if(!LAZYACCESS(attribute_modification, key))
		return FALSE
	LAZYREMOVE(attribute_modification, key)
	if(update)
		update_attributes()
	return TRUE

/datum/attribute_holder/proc/set_variable_attribute_modifier(id, list/new_modification, update = TRUE)
	var/datum/attribute_modifier/variable/modifier = LAZYACCESS(attribute_modification, id)
	if(!length(new_modification))
		return remove_attribute_modifier(id, update)
	if(!modifier)
		modifier = new
		modifier.id = id
		add_attribute_modifier(modifier, FALSE)
	modifier.attribute_list = new_modification
	if(update)
		update_attributes()
	return modifier

/datum/attribute_holder/proc/has_attribute_modifier(datum/attribute_modifier/type_id_datum)
	return LAZYACCESS(attribute_modification, modifier_key(type_id_datum))

/datum/attribute_holder/proc/get_attribute_modification()
	. = LAZYCOPY(attribute_modification)
	for(var/id in attribute_mod_immunities)
		. -= id

/datum/attribute_holder/proc/add_attribute_mod_immunities(source, mod_type, update = TRUE)
	for(var/listed in islist(mod_type) ? mod_type : list(mod_type))
		LAZYADDASSOCLIST(attribute_mod_immunities, ispath(listed) ? "[listed]" : listed, source)
	if(update)
		update_attributes()

/datum/attribute_holder/proc/remove_attribute_mod_immunities(source, mod_type, update = TRUE)
	for(var/listed in islist(mod_type) ? mod_type : list(mod_type))
		LAZYREMOVEASSOC(attribute_mod_immunities, ispath(listed) ? "[listed]" : listed, source)
	if(update)
		update_attributes()

/datum/attribute_holder/proc/update_attributes()
	var/list/computed = raw_attribute_list.Copy()
	var/list/conflict_tracker = list()
	var/list/active = get_attribute_modification()
	for(var/key in active)
		var/datum/attribute_modifier/modifier = active[key]
		if(modifier.conflicts_with)
			if(!(modifier.conflicts_with in conflict_tracker) || conflict_tracker[modifier.conflicts_with] < modifier.priority)
				conflict_tracker[modifier.conflicts_with] = modifier.priority
			else
				continue
		for(var/attribute_type in modifier.attribute_list)
			var/amount = modifier.attribute_list[attribute_type]
			if(isnull(amount) || !(attribute_type in computed))
				continue
			if(ispath(attribute_type, ROGUE_SKILL))
				if(!isnull(computed[attribute_type]))
					computed[attribute_type] = clamp(computed[attribute_type] + amount, skill_min, skill_max)
			else
				computed[attribute_type] = clamp(ROGUE_NULLTOZERO(computed[attribute_type]) + amount, attribute_min, attribute_max)
	attribute_list = computed
	if(parent)
		SEND_SIGNAL(parent, COMSIG_ROGUE_ATTRIBUTES_UPDATED)
		parent.rogue_attributes_updated()
	SStgui.update_uis(src)

/datum/diceroll_modifier
	var/variable = FALSE
	var/id
	var/priority = 0
	var/modification = 0
	var/list/applicable_contexts = list(ROGUE_DICE_PHYSICAL = TRUE, ROGUE_DICE_MENTAL = TRUE)

/datum/diceroll_modifier/New()
	. = ..()
	if(!id)
		id = "[type]"

/datum/diceroll_modifier/proc/applies_to(datum/attribute_holder/holder, context)
	return applicable_contexts[context]

/datum/attribute_holder/proc/add_diceroll_modifier(datum/diceroll_modifier/type_or_datum)
	if(ispath(type_or_datum))
		if(initial(type_or_datum.variable))
			type_or_datum = new type_or_datum
		else
			if(!GLOB.rogue_diceroll_modifier_cache[type_or_datum])
				GLOB.rogue_diceroll_modifier_cache[type_or_datum] = new type_or_datum
			type_or_datum = GLOB.rogue_diceroll_modifier_cache[type_or_datum]
	LAZYSET(diceroll_modification, type_or_datum.id, type_or_datum)
	return TRUE

/datum/attribute_holder/proc/remove_diceroll_modifier(datum/diceroll_modifier/type_id_datum)
	var/key = ispath(type_id_datum) ? (initial(type_id_datum.id) || "[type_id_datum]") : (istext(type_id_datum) ? type_id_datum : type_id_datum.id)
	if(!LAZYACCESS(diceroll_modification, key))
		return FALSE
	LAZYREMOVE(diceroll_modification, key)
	return TRUE

/datum/attribute_holder/proc/get_diceroll_modifier(context = ROGUE_DICE_PHYSICAL)
	. = 0
	for(var/key in diceroll_modification)
		var/datum/diceroll_modifier/modifier = diceroll_modification[key]
		if(modifier.applies_to(src, context))
			. += modifier.modification
