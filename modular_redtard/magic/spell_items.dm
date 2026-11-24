/// Vibelin's arcyne spell objects (items/arcyne_spellobject.dm): a scroll, spellstone or wand holds spells with a few charges
/// each. A spellstone gives its spells while held, free of mana and cooldown, and spends a charge a cast; a scroll or wand
/// casts its first spell where it is pointed, the aim rolled against the arcyne skill (a miss strikes the caster, or with a
/// chaotic wand someone at random). A spell is sealed in by one who knows it, for twice its mana (imbue_spell(), the
/// imbuement rune of block ВМ2), or the item comes filled. Medieval maps only.

/// One spell held (Vibelin /datum/spellobject_entry).
/datum/rogue_spellobject_entry
	var/spell_type
	var/spell_name
	var/charges = 1
	/// The spell given while the item is held (spellstones).
	var/datum/action/cooldown/spell/live_spell

/datum/rogue_spellobject_entry/Destroy(force)
	QDEL_NULL(live_spell)
	return ..()

/// The tier of a spell for what an item may hold: the module's spells go by form rank (required_level), two ranks a tier.
/proc/rogue_spell_item_tier(spell_type)
	var/datum/action/cooldown/spell/rogue/path = spell_type
	if(!ispath(path, /datum/action/cooldown/spell/rogue))
		return 0
	return CEILING(initial(path.required_level) / ROGUE_MASTERY_RANK_ADEPT, 1)

/obj/item/rogue_spellobject
	name = "arcyne spell object"
	desc = "An object threaded with arcyne filaments."
	icon = 'modular_redtard/rockhill/icons/roguetown/items/gems.dmi'
	icon_state = "quartz"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 64
	rogue_grid_height = 32
	/// The key of its numbers: magic_spellobject_<kind>_max_spells, _min_tier, _max_tier.
	var/kind = "spellstone"
	var/spellobject_flags = NONE
	var/max_spells = 0
	var/min_spell_tier = 0
	var/max_spell_tier = 0
	var/list/datum/rogue_spellobject_entry/stored_spells = list()
	/// Who has its spells now (spellstones).
	var/mob/living/active_user
	/// Comes filled with a random spell.
	var/has_random_spells = FALSE

/obj/item/rogue_spellobject/Initialize(mapload)
	. = ..()
	max_spells = rogue_value("magic_spellobject_[kind]_max_spells")
	min_spell_tier = rogue_value("magic_spellobject_[kind]_min_tier")
	max_spell_tier = rogue_value("magic_spellobject_[kind]_max_tier")
	if(has_random_spells)
		generate_random_spell()

/obj/item/rogue_spellobject/Destroy()
	revoke_all_spells()
	QDEL_LIST(stored_spells)
	return ..()

/obj/item/rogue_spellobject/examine(mob/user)
	. = ..()
	if(!length(stored_spells))
		. += span_warning("It is cold and empty.")
		return
	. += span_notice("Spells stored within ([length(stored_spells)]/[max_spells]):")
	for(var/datum/rogue_spellobject_entry/entry as anything in stored_spells)
		. += span_notice("  [(spellobject_flags & ROGUE_SPELLOBJECT_CHAOTIC) ? "???" : entry.spell_name] - [entry.charges] charge\s remaining.")
	if(spellobject_flags & ROGUE_SPELLOBJECT_HIJACK_CLICK)
		. += span_notice("It crackles faintly, point and click to unleash its magic.")
	if(spellobject_flags & ROGUE_SPELLOBJECT_CHAOTIC)
		. += span_warning("The magic within feels wild and unpredictable.")

/obj/item/rogue_spellobject/update_overlays()
	. = ..()
	if(!(spellobject_flags & ROGUE_SPELLOBJECT_VISUAL))
		return
	var/i = 0
	for(var/datum/rogue_spellobject_entry/entry as anything in stored_spells)
		var/datum/action/cooldown/spell/path = entry.spell_type
		var/mutable_appearance/button = mutable_appearance(initial(path.button_icon), initial(path.button_icon_state))
		button.alpha = max(40, 120 - i * 20)
		button.pixel_z = i * 2
		. += button
		i++

/obj/item/rogue_spellobject/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if((spellobject_flags & ROGUE_SPELLOBJECT_HIJACK_CLICK) || !(slot & ITEM_SLOT_HANDS))
		return
	grant_all_spells(user)

/obj/item/rogue_spellobject/dropped(mob/user, silent = FALSE)
	. = ..()
	revoke_all_spells()

/obj/item/rogue_spellobject/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!(spellobject_flags & ROGUE_SPELLOBJECT_HIJACK_CLICK))
		return NONE
	if(!rogue_magic_enabled())
		to_chat(user, span_warning("The arcyne does not answer here."))
		return ITEM_INTERACT_BLOCKING
	if(!length(stored_spells))
		to_chat(user, span_warning("Nothing is stored within."))
		return ITEM_INTERACT_BLOCKING
	if(HAS_TRAIT(user, TRAIT_SPELLCOCKBLOCK) || !user.can_cast_magic(MAGIC_RESISTANCE))
		user.balloon_alert(user, "can't focus on casting...")
		return ITEM_INTERACT_BLOCKING
	fire_hijack_spell(user, interacting_with)
	return ITEM_INTERACT_SUCCESS

/obj/item/rogue_spellobject/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	return ranged_interact_with_atom(interacting_with, user, modifiers)

/// Vibelin fire_hijack_spell(): the aim is rolled against the arcyne skill of the user.
/obj/item/rogue_spellobject/proc/fire_hijack_spell(mob/living/user, atom/intended_target)
	var/datum/rogue_spellobject_entry/entry = stored_spells[1]
	var/atom/actual_target = intended_target
	if(!(spellobject_flags & ROGUE_SPELLOBJECT_STABLE))
		var/roll = user.rogue_diceroll(requirement = aim_requirement(user), crit = rogue_value("magic_spellobject_aim_crit"))
		switch(roll)
			if(ROGUE_DICE_CRIT_SUCCESS)
				user.visible_message(span_notice("[user] levels [src], a searing bolt lances straight and true!"), span_notice("The magic responds perfectly, [entry.spell_name] fires true."))
			if(ROGUE_DICE_SUCCESS)
				user.visible_message(span_notice("[user] levels [src] and a burst of energy lances toward [intended_target]!"), span_notice("The spell fires toward [intended_target]."))
			if(ROGUE_DICE_FAILURE)
				actual_target = misfire_target(user, rogue_value("magic_spellobject_misfire_range"))
				user.visible_message(span_warning("[user]'s [name] sputters, the magic lurches toward [actual_target]!"), span_warning("The magic slips my control, [entry.spell_name] careens toward [actual_target]!"))
			else
				actual_target = misfire_target(user, rogue_value("magic_spellobject_wild_misfire_range"))
				user.visible_message(span_boldwarning("[user]'s [name] violently misfires, the spell erupts toward [actual_target]!"), span_boldwarning("Catastrophic misfire, the spell explodes toward [actual_target]!"))
	var/datum/action/cooldown/spell/instance = new entry.spell_type(user)
	free_of_price(instance)
	instance.Grant(user)
	instance.cast(actual_target)
	if(!QDELETED(instance))
		instance.Remove(user)
		qdel(instance)
	consume_entry_charge(user, entry)

/// A miss strikes the caster, or with a chaotic item someone at random around them.
/obj/item/rogue_spellobject/proc/misfire_target(mob/living/user, range)
	if(!(spellobject_flags & ROGUE_SPELLOBJECT_CHAOTIC))
		return user
	var/list/nearby = list()
	for(var/atom/thing as anything in get_hearers_in_view(range, user))
		if(thing != user && isliving(thing))
			nearby += thing
	return length(nearby) ? pick(nearby) : user

/// Vibelin SPELLOBJECT_AIM_REQ_*: what the aim must beat, by the user's rank in the spell's skill.
/obj/item/rogue_spellobject/proc/aim_requirement(mob/living/user)
	var/datum/rogue_spellobject_entry/entry = stored_spells[1]
	var/datum/action/cooldown/spell/rogue/path = entry.spell_type
	var/skill_type = ispath(path, /datum/action/cooldown/spell/rogue) ? initial(path.associated_skill) : /datum/attribute/skill/magic/arcane
	var/skill = ROGUE_NULLTOZERO(user.rogue_skill(skill_type))
	if(skill >= ROGUE_SKILL_LEVEL_LEGENDARY)
		return rogue_value("magic_spellobject_aim_legendary")
	if(skill >= ROGUE_SKILL_LEVEL_MASTER)
		return rogue_value("magic_spellobject_aim_master")
	if(skill >= ROGUE_SKILL_LEVEL_EXPERT)
		return rogue_value("magic_spellobject_aim_expert")
	if(skill >= ROGUE_SKILL_LEVEL_JOURNEYMAN)
		return rogue_value("magic_spellobject_aim_journeyman")
	if(skill >= ROGUE_SKILL_LEVEL_APPRENTICE)
		return rogue_value("magic_spellobject_aim_apprentice")
	if(skill >= ROGUE_SKILL_LEVEL_NOVICE)
		return rogue_value("magic_spellobject_aim_novice")
	return rogue_value("magic_spellobject_aim_none")

/// The item pays for its spells: no mana, no cooldown.
/obj/item/rogue_spellobject/proc/free_of_price(datum/action/cooldown/spell/instance)
	instance.cooldown_time = 0
	if(istype(instance, /datum/action/cooldown/spell/rogue))
		var/datum/action/cooldown/spell/rogue/rogue_instance = instance
		rogue_instance.spell_cost = 0
		// The drains are cast numbers read again when the mechanics move: read them now, then zero them.
		rogue_instance.read_cast_numbers()
		rogue_instance.charge_drain = 0
		rogue_instance.hold_drain = 0

/obj/item/rogue_spellobject/proc/consume_entry_charge(mob/living/user, datum/rogue_spellobject_entry/entry)
	entry.charges--
	if(entry.charges > 0)
		to_chat(user, span_notice("[entry.spell_name]: [entry.charges] charge\s remaining."))
		return
	if(entry.live_spell && user)
		UnregisterSignal(entry.live_spell, COMSIG_SPELL_AFTER_CAST)
		entry.live_spell.Remove(user)
	stored_spells -= entry
	user?.visible_message(span_notice("A thread of light unravels from [user]'s [name], [entry.spell_name] is spent."), span_notice("The last charge of [entry.spell_name] is spent."))
	qdel(entry)
	update_appearance(UPDATE_OVERLAYS)
	if(length(stored_spells))
		return
	active_user = null
	user?.visible_message(span_warning("[user]'s [name] dims, all spells exhausted."), span_warning("The [name] is now empty."))
	if(spellobject_flags & ROGUE_SPELLOBJECT_CONSUMABLE)
		qdel(src)

/obj/item/rogue_spellobject/proc/grant_all_spells(mob/living/user)
	if(active_user || !length(stored_spells) || !rogue_magic_enabled())
		return
	active_user = user
	for(var/datum/rogue_spellobject_entry/entry as anything in stored_spells)
		if(entry.live_spell)
			continue
		entry.live_spell = new entry.spell_type(src)
		free_of_price(entry.live_spell)
		entry.live_spell.background_icon_state = "spelltemp"
		entry.live_spell.base_background_icon_state = "spelltemp0"
		entry.live_spell.active_background_icon_state = "spelltemp1"
		RegisterSignal(entry.live_spell, COMSIG_SPELL_AFTER_CAST, PROC_REF(on_spell_fired))
		entry.live_spell.Grant(user)
	to_chat(user, span_notice("The [name] thrums, [length(stored_spells)] spell\s ready."))

/obj/item/rogue_spellobject/proc/revoke_all_spells()
	if(!active_user)
		return
	var/mob/living/old_user = active_user
	active_user = null
	for(var/datum/rogue_spellobject_entry/entry as anything in stored_spells)
		if(!entry.live_spell)
			continue
		UnregisterSignal(entry.live_spell, COMSIG_SPELL_AFTER_CAST)
		entry.live_spell.Remove(old_user)
		QDEL_NULL(entry.live_spell)

/// The charge is spent once the cast is over: the spell base still works on its caster after this signal.
/obj/item/rogue_spellobject/proc/on_spell_fired(datum/action/cooldown/spell/source, atom/cast_on)
	SIGNAL_HANDLER
	// A cast that went wrong (spell_failed, set by fail() and kept until the next before_cast()) spends no charge.
	var/datum/action/cooldown/spell/rogue/rogue_spell = source
	if(istype(rogue_spell) && rogue_spell.spell_failed)
		return
	addtimer(CALLBACK(src, PROC_REF(spend_fired), source), 1)

/obj/item/rogue_spellobject/proc/spend_fired(datum/action/cooldown/spell/fired)
	for(var/datum/rogue_spellobject_entry/entry as anything in stored_spells)
		if(entry.live_spell == fired)
			consume_entry_charge(active_user, entry)
			return

/// Vibelin imbue_spell(): one who knows the spell seals it in for twice its mana, and its cooldown starts.
/obj/item/rogue_spellobject/proc/imbue_spell(mob/living/carbon/human/caster, spell_type, charges = 1)
	if(length(stored_spells) >= max_spells)
		to_chat(caster, span_warning("The [name] is already full ([max_spells] spells)."))
		return FALSE
	var/tier = rogue_spell_item_tier(spell_type)
	if(tier < min_spell_tier || tier > max_spell_tier)
		to_chat(caster, span_warning("This object cannot hold a spell of that tier."))
		return FALSE
	var/datum/action/cooldown/spell/rogue/live
	for(var/datum/action/cooldown/spell/rogue/known in caster.actions)
		if(known.type == spell_type)
			live = known
			break
	if(!live)
		to_chat(caster, span_warning("I don't know that spell, I can't store what I don't have."))
		return FALSE
	var/price = live.spell_cost * rogue_value("magic_spellobject_imbue_cost_mult")
	if(!caster.rogue_has_mana(price))
		to_chat(caster, span_warning("I need [price] mana to imbue this spell."))
		return FALSE
	caster.rogue_spend_mana(price)
	live.StartCooldown()
	var/datum/rogue_spellobject_entry/entry = new
	entry.spell_type = spell_type
	entry.spell_name = live.name
	entry.charges = charges
	stored_spells += entry
	update_appearance(UPDATE_OVERLAYS)
	to_chat(caster, span_notice("I pour [price] mana into the [name], [live.name] is sealed within."))
	return TRUE

/// Vibelin generate_random_spells(): a mana spell of the basket the item can hold, with a few charges.
/obj/item/rogue_spellobject/proc/generate_random_spell()
	var/list/candidates = list()
	for(var/datum/action/cooldown/spell/rogue/spell_type as anything in rogue_spell_basket())
		if(!initial(spell_type.learnable) || initial(spell_type.cost_type) != ROGUE_SPELL_COST_MANA)
			continue
		var/tier = rogue_spell_item_tier(spell_type)
		if(tier >= min_spell_tier && tier <= max_spell_tier)
			candidates += spell_type
	if(!length(candidates))
		return
	var/datum/action/cooldown/spell/rogue/picked = pick(candidates)
	var/datum/rogue_spellobject_entry/entry = new
	entry.spell_type = picked
	entry.spell_name = initial(picked.name)
	entry.charges = rand(rogue_value("magic_spellobject_random_charges_min"), rogue_value("magic_spellobject_random_charges_max"))
	stored_spells += entry
	update_appearance(UPDATE_OVERLAYS)

/obj/item/rogue_spellobject/scroll
	name = "arcyne scroll"
	desc = "Dry parchment veined with cold arcyne light. Whatever is written here was not meant to last."
	icon = 'modular_redtard/rockhill/icons/roguetown/items/misc.dmi'
	icon_state = "scroll"
	kind = "scroll"
	spellobject_flags = ROGUE_SPELLOBJECT_HIJACK_CLICK | ROGUE_SPELLOBJECT_CONSUMABLE | ROGUE_SPELLOBJECT_VISUAL | ROGUE_SPELLOBJECT_STABLE

/obj/item/rogue_spellobject/scroll/random
	has_random_spells = TRUE

/obj/item/rogue_spellobject/spellstone
	name = "arcyne spellstone"
	desc = "A polished stone threaded with arcyne filaments. Hold it to channel its spells."
	icon_state = "quartz"
	kind = "spellstone"
	spellobject_flags = ROGUE_SPELLOBJECT_VISUAL

/obj/item/rogue_spellobject/spellstone/random
	has_random_spells = TRUE

/obj/item/rogue_spellobject/spellstone/lesser
	name = "lesser arcyne spellstone"
	icon_state = "quartz"
	kind = "spellstone_lesser"

/obj/item/rogue_spellobject/spellstone/greater
	name = "greater arcyne spellstone"
	icon_state = "sapphire"
	kind = "spellstone_greater"

/obj/item/rogue_spellobject/spellstone/supreme
	name = "supreme arcyne spellstone"
	icon_state = "ruby"
	kind = "spellstone_supreme"

/obj/item/rogue_spellobject/wand
	name = "arcyne wand"
	desc = "A slender wand crackling with stored magic. Point and click to fire."
	icon = ROGUE_WANDS_ICON
	icon_state = "wand_lesser"
	kind = "wand"
	spellobject_flags = ROGUE_SPELLOBJECT_HIJACK_CLICK

/obj/item/rogue_spellobject/wand/greater
	name = "greater arcyne wand"
	icon_state = "wand_greater"
	kind = "wand_greater"

/obj/item/rogue_spellobject/wand/chaotic
	name = "chaotic arcyne wand"
	desc = "A warped wand fizzing with wild magic. Something is inside but what?"
	kind = "wand_chaotic"
	spellobject_flags = ROGUE_SPELLOBJECT_HIJACK_CLICK | ROGUE_SPELLOBJECT_CHAOTIC

/obj/item/rogue_spellobject/wand/chaotic/random
	has_random_spells = TRUE
