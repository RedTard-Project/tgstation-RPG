/// Vibelin's form and technique modifiers (datums/components/spell_modifiers.dm, spell.dm get_form_technique_modifiers()):
/// what a caster holds or wears can make the spells of a form or technique cheaper, quicker to charge or stronger. A spell
/// asks its caster with COMSIG_ROGUE_SPELL_REQUEST_MODIFIERS; every answer is an entry for one form or one technique, and
/// get_modifiers() folds the entries that match the spell's required_form and required_technique: price and cast speed
/// factors multiply, magnitude bonuses add to 1. With no answer the spell is as it was: factors 1, magnitude 1.
/// The magnitude of the cast (the spell's magnitude) is set once a cast goes ahead (before_cast(), spell.dm); a spell or a
/// primitive scales its damage, radius or duration by it, as Vibelin's spells do spell_magnitude_modifier.

/// Vibelin get_form_technique_modifiers(): list(ROGUE_SPELLMOD_COST = factor, ROGUE_SPELLMOD_CASTSPEED = factor,
/// ROGUE_SPELLMOD_MAGNITUDE = magnitude) for this spell and its caster.
/datum/action/cooldown/spell/rogue/proc/get_modifiers()
	var/list/result = list(ROGUE_SPELLMOD_COST = 1, ROGUE_SPELLMOD_CASTSPEED = 1, ROGUE_SPELLMOD_MAGNITUDE = 1)
	if(!owner || (!required_form && !required_technique))
		return result
	var/list/entries = list()
	SEND_SIGNAL(owner, COMSIG_ROGUE_SPELL_REQUEST_MODIFIERS, entries)
	for(var/list/entry as anything in entries)
		if(!islist(entry))
			continue
		var/matches = 0
		if(required_form && entry[ROGUE_SPELLMOD_FORM] == required_form)
			matches++
		if(required_technique && entry[ROGUE_SPELLMOD_TECHNIQUE] == required_technique)
			matches++
		// An entry for both the form and the technique counts for each, as Vibelin's two separate checks do.
		for(var/i in 1 to matches)
			result[ROGUE_SPELLMOD_COST] *= isnull(entry[ROGUE_SPELLMOD_COST]) ? 1 : entry[ROGUE_SPELLMOD_COST]
			result[ROGUE_SPELLMOD_CASTSPEED] *= isnull(entry[ROGUE_SPELLMOD_CASTSPEED]) ? 1 : entry[ROGUE_SPELLMOD_CASTSPEED]
			result[ROGUE_SPELLMOD_MAGNITUDE] += entry[ROGUE_SPELLMOD_MAGNITUDE] || 0
	return result

/// Vibelin /datum/component/spell_modifier: an item (while worn or held) or a mob that changes the spells of some forms and
/// techniques. Each list is keyed by form (ROGUE_FORM_*) or technique (ROGUE_TECHNIQUE_*): price and cast speed factors (a
/// missing key is 1), magnitude bonuses (a missing key is 0). Several may sit on one item.
/datum/component/rogue_spell_modifier
	dupe_mode = COMPONENT_DUPE_ALLOWED
	var/list/form_cost_multipliers
	var/list/form_cast_speed_multipliers
	var/list/form_magnitude_modifications
	var/list/technique_cost_multipliers
	var/list/technique_cast_speed_multipliers
	var/list/technique_magnitude_modifications
	/// The mob that wears or holds the item and is answered for.
	var/datum/weakref/wearer_ref

/datum/component/rogue_spell_modifier/Initialize(list/form_cost_multipliers, list/form_cast_speed_multipliers, list/form_magnitude_modifications, list/technique_cost_multipliers, list/technique_cast_speed_multipliers, list/technique_magnitude_modifications)
	if(!isitem(parent) && !ismob(parent))
		return COMPONENT_INCOMPATIBLE
	src.form_cost_multipliers = form_cost_multipliers || list()
	src.form_cast_speed_multipliers = form_cast_speed_multipliers || list()
	src.form_magnitude_modifications = form_magnitude_modifications || list()
	src.technique_cost_multipliers = technique_cost_multipliers || list()
	src.technique_cast_speed_multipliers = technique_cast_speed_multipliers || list()
	src.technique_magnitude_modifications = technique_magnitude_modifications || list()

/datum/component/rogue_spell_modifier/RegisterWithParent()
	if(ismob(parent))
		RegisterSignal(parent, COMSIG_ROGUE_SPELL_REQUEST_MODIFIERS, PROC_REF(on_request_modifiers))
		return
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equipped))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_dropped))
	var/obj/item/item_parent = parent
	if(ismob(item_parent.loc))
		watch(item_parent.loc)

/datum/component/rogue_spell_modifier/UnregisterFromParent()
	if(ismob(parent))
		UnregisterSignal(parent, COMSIG_ROGUE_SPELL_REQUEST_MODIFIERS)
		return
	UnregisterSignal(parent, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED))
	unwatch()

/datum/component/rogue_spell_modifier/Destroy(force)
	unwatch()
	return ..()

/datum/component/rogue_spell_modifier/proc/watch(mob/wearer)
	unwatch()
	wearer_ref = WEAKREF(wearer)
	RegisterSignal(wearer, COMSIG_ROGUE_SPELL_REQUEST_MODIFIERS, PROC_REF(on_request_modifiers))

/datum/component/rogue_spell_modifier/proc/unwatch()
	var/mob/wearer = wearer_ref?.resolve()
	if(wearer)
		UnregisterSignal(wearer, COMSIG_ROGUE_SPELL_REQUEST_MODIFIERS)
	wearer_ref = null

/datum/component/rogue_spell_modifier/proc/on_equipped(datum/source, mob/user, slot)
	SIGNAL_HANDLER
	watch(user)

/datum/component/rogue_spell_modifier/proc/on_dropped(datum/source, mob/user)
	SIGNAL_HANDLER
	unwatch()

/datum/component/rogue_spell_modifier/proc/on_request_modifiers(datum/source, list/out)
	SIGNAL_HANDLER
	add_entries(out, ROGUE_SPELLMOD_FORM, form_cost_multipliers, form_cast_speed_multipliers, form_magnitude_modifications)
	add_entries(out, ROGUE_SPELLMOD_TECHNIQUE, technique_cost_multipliers, technique_cast_speed_multipliers, technique_magnitude_modifications)

/// Vibelin add_modifier_entries(): an entry for each form or technique that changes anything.
/datum/component/rogue_spell_modifier/proc/add_entries(list/out, key, list/cost_multipliers, list/cast_speed_multipliers, list/magnitude_modifications)
	for(var/entry_key in cost_multipliers | cast_speed_multipliers | magnitude_modifications)
		var/cost = isnull(cost_multipliers[entry_key]) ? 1 : cost_multipliers[entry_key]
		var/cast_speed = isnull(cast_speed_multipliers[entry_key]) ? 1 : cast_speed_multipliers[entry_key]
		var/magnitude = magnitude_modifications[entry_key] || 0
		if(cost == 1 && cast_speed == 1 && magnitude == 0)
			continue
		var/list/entry = list(ROGUE_SPELLMOD_COST = cost, ROGUE_SPELLMOD_CASTSPEED = cast_speed, ROGUE_SPELLMOD_MAGNITUDE = magnitude)
		entry[key] = entry_key
		out += list(entry)
