/// Vibelin's spell (code/modules/spells/spell.dm) on TG's /datum/action/cooldown/spell: the base of every spell of the
/// basket (block M2). What Vibelin adds to TG's spell and this one keeps:
/// - a price in mana (or stamina) that its skill (Arcyne or a form's sub-skill, skills.dm) and Intelligence lower or raise
///   (get_adjusted_cost()), paid once the spell went off; a spell that fizzled (fail()) costs nothing and gives its
///   cooldown back;
/// - a charge: a pointed spell is armed with its button, then the mouse is held over the target and let go once charged
///   (start_casting(), try_casting()); a spell cast on oneself charges as a channel instead (Vibelin do_after()); its
///   skill and Intelligence shorten the charge (get_adjusted_charge_time());
/// - experience in its skill for every cast, waiting for sleep from Apprentice on (Vibelin handle_exp());
/// - a form and a technique that the spellbook buys it with (mastery.dm);
/// - Shift+G: the alt mode of the armed spell (toggle_alt_mode(); arc mode of a projectile, projectile.dm).
/// From Ratwood and Azure Peak: a staff or tome in hand gives a share of the price back over a while (residual focus), a
/// weapon in hand makes an offensive spell dearer and slower to come back (weapon_cast_penalized).
/// The type carries no balance number: its price, cooldown, charge and slowdown are spell_<type>_<tunable> of magic.txt
/// (tune()), as the special intents do it; a spell needs more numbers by naming them in `tunables` too.
/datum/action/cooldown/spell/rogue
	name = "Spell"
	desc = "A spell of the arcyne."
	button_icon = ROGUE_SPELLS_ICON
	button_icon_state = "shieldsparkles"
	background_icon = ROGUE_SPELLS_ICON
	background_icon_state = "spell0"
	base_background_icon_state = "spell0"
	active_background_icon_state = "spell1"
	overlay_icon_state = null
	active_overlay_icon_state = null
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC|SPELL_REQUIRES_HUMAN
	school = SCHOOL_EVOCATION
	sound = ROGUE_SPELL_CAST_SOUND
	click_to_activate = TRUE
	invocation_type = INVOCATION_NONE
	// Vibelin's invocations are said as written; TG garbles half of them.
	garbled_invocation_prob = 0
	/// A family of spells, not one of the basket (TG's abstract_type is not on datums here).
	var/abstract_spell_type = /datum/action/cooldown/spell/rogue
	/// What the price is paid with.
	var/cost_type = ROGUE_SPELL_COST_MANA
	/// The numbers of the type in magic.txt (spell_<type>_<name>): cost, cooldown and charge in deciseconds, slowdown while
	/// charging. A spell that needs more (damage, duration) lists them too and reads them with tune().
	var/list/tunables = list("cost", "cooldown", "charge", "slowdown")
	/// Read from tunables in New().
	var/spell_cost = 0
	var/charge_time = 0
	var/charge_slowdown = 0
	/// The skill and characteristic the price, charge and experience go by (Vibelin associated_skill, associated_stat).
	var/associated_skill = /datum/attribute/skill/magic/arcane
	var/associated_stat = ROGUE_STAT_INTELLIGENCE
	/// Experience: price x modifier (Vibelin experience_modifier); none when 0.
	var/experience_modifier_key = "magic_experience_modifier"
	/// Vibelin required_technique, required_form, required_level, prerequisite_spells, learnable: what the spellbook asks.
	var/required_technique
	var/required_form
	var/required_level = 0
	var/list/prerequisite_spells
	var/learnable = TRUE
	/// The colour of the charge glow (Vibelin spell_color; the form's colour when unset).
	var/spell_color
	/// Pointed spells: may be cast on oneself; tiles of reach; a person on the clicked tile is aimed at.
	var/self_cast_possible = TRUE
	/// Tiles of reach, set by New(): the spell's own spell_<type>_range, else the kind's. The kind (Vibelin SPELL_RANGE_*, as
	/// Vibelin writes cast_range = SPELL_RANGE_PROJECTILE) is a name in magic.txt: magic_range_projectile, _ground,
	/// _two_screens, _aura, _adjacent.
	var/cast_range
	var/cast_range_key = "magic_range_ground"
	var/aim_assist = TRUE
	var/active_msg
	var/deactive_msg
	/// Vibelin's requirements TG has not (ROGUE_SPELL_REQUIRES_NO_MOVE, ROGUE_SPELL_CASTABLE_WHILE_MOUNTED).
	var/rogue_requirements = NONE
	/// Ratwood weapon_cast_penalized: an offensive spell costs more and comes back later with a weapon in hand.
	var/weapon_cast_penalized = FALSE
	/// Where the source forks had it: "Vibelin", "Azure Peak"..., and its type there. Text, read off the type by the basket.
	var/spell_forks = ""
	var/spell_source_type = ""
	/// Charge state.
	var/currently_charging = FALSE
	var/charged = FALSE
	var/charge_started_at = 0
	var/charge_target_time = 0
	var/auto_cancel_timer
	/// The cast went wrong after it began: nothing is paid and the cooldown comes back.
	var/spell_failed = FALSE
	/// A weapon was in hand at the cast.
	var/weapon_penalty_active = FALSE

/datum/action/cooldown/spell/rogue/New(Target)
	. = ..()
	spell_cost = tune("cost")
	cooldown_time = tune("cooldown")
	charge_time = tune("charge")
	charge_slowdown = tune("slowdown")
	// A reach of its own (Vibelin cast_range = 12) instead of the kind's (cast_range_key).
	var/range = tune("range")
	cast_range = range > 0 ? range : rogue_value(cast_range_key)
	if(!spell_color && required_form)
		spell_color = GLOB.rogue_spell_form_colors[required_form]
	if(!active_msg)
		active_msg = "I prepare to cast [src]..."
	if(!deactive_msg)
		deactive_msg = "I dispel [src]."
	if(click_to_activate)
		ranged_mousepointer = ROGUE_SPELL_CHARGED_CURSOR
	desc = "[desc]<br>[spell_cost ? "Costs [spell_cost] [cost_type == ROGUE_SPELL_COST_STAMINA ? "stamina" : "mana"]." : ""][required_form ? " [required_form], [required_technique]." : ""]"

/datum/action/cooldown/spell/rogue/Destroy()
	if(currently_charging)
		cancel_casting()
	return ..()

/// The key of the type in magic.txt: spell_ and the path after /datum/action/cooldown/spell/rogue/, slashes as underscores.
/datum/action/cooldown/spell/rogue/proc/value_key()
	return rogue_spell_value_key(type)

/// A number of the spell (magic.txt spell_<type>_<name>); a name the file lacks is none (0).
/datum/action/cooldown/spell/rogue/proc/tune(var_name)
	return rogue_value_or("[value_key()]_[var_name]", 0)

/datum/action/cooldown/spell/rogue/Grant(mob/grant_to)
	. = ..()
	if(!owner)
		return
	RegisterSignal(owner, COMSIG_MOB_ROGUE_MANA_CHANGED, PROC_REF(update_status_on_signal))
	if(ishuman(owner) && cost_type == ROGUE_SPELL_COST_MANA)
		var/mob/living/carbon/human/caster = owner
		caster.rogue_get_mana()

/datum/action/cooldown/spell/rogue/Remove(mob/living/remove_from)
	if(currently_charging)
		cancel_casting()
	UnregisterSignal(remove_from, COMSIG_MOB_ROGUE_MANA_CHANGED)
	return ..()

/datum/action/cooldown/spell/rogue/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if(!rogue_magic_enabled())
		if(feedback)
			to_chat(owner, span_warning("The arcyne does not answer here."))
		return FALSE
	if(HAS_TRAIT(owner, TRAIT_SPELLCOCKBLOCK))
		if(feedback)
			owner.balloon_alert(owner, "can't focus on casting...")
		return FALSE
	for(var/datum/action/cooldown/spell/rogue/other in owner.actions)
		if(other != src && other.currently_charging)
			if(feedback)
				owner.balloon_alert(owner, "already channeling!")
			return FALSE
	if(!(rogue_requirements & ROGUE_SPELL_CASTABLE_WHILE_MOUNTED) && isliving(owner.buckled))
		if(feedback)
			owner.balloon_alert(owner, "too distracted riding to cast!")
		return FALSE
	return check_cost(feedback = feedback)

/datum/action/cooldown/spell/rogue/is_valid_target(atom/cast_on)
	if(click_to_activate && !self_cast_possible && cast_on == owner)
		owner.balloon_alert(owner, "can't self cast!")
		return FALSE
	return TRUE

/// Vibelin get_adjusted_cost(): every rank of the skill takes a share of the price off, every point of the characteristic
/// above the middle another (below it adds); a weapon in hand makes it dearer.
/datum/action/cooldown/spell/rogue/proc/get_adjusted_cost(base)
	if(isnull(base))
		base = spell_cost
	if(base <= 0)
		return 0
	var/mob/living/caster = owner
	var/factor = 1 - caster.rogue_magic_rank(associated_skill) * rogue_value("magic_cost_per_skill_rank")
	factor -= (caster.rogue_stat(associated_stat) - ROGUE_ATTRIBUTE_MIDDLING) * rogue_value("magic_cost_per_stat_point")
	if(weapon_cast_penalized && check_weapon_in_hand())
		factor *= rogue_value("magic_weapon_penalty")
	return max(base * factor, 0)

/// Vibelin get_adjusted_charge_time(), with Ratwood's Leyline's Clarity (TRAIT_LEYLINE_HASTE).
/datum/action/cooldown/spell/rogue/proc/get_adjusted_charge_time()
	if(charge_time <= 0)
		return 0
	var/mob/living/caster = owner
	var/factor = 1 - caster.rogue_magic_rank(associated_skill) * rogue_value("magic_charge_per_skill_rank")
	factor -= (caster.rogue_stat(associated_stat) - ROGUE_ATTRIBUTE_MIDDLING) * rogue_value("magic_charge_per_stat_point")
	if(HAS_TRAIT(caster, TRAIT_LEYLINE_HASTE))
		factor *= rogue_value("magic_leyline_haste")
	return max(charge_time * factor, rogue_value("magic_charge_min"))

/// Vibelin check_cost().
/datum/action/cooldown/spell/rogue/proc/check_cost(price, feedback = TRUE)
	var/used = isnull(price) ? get_adjusted_cost() : price
	if(used <= 0)
		return TRUE
	var/mob/living/carbon/human/caster = owner
	switch(cost_type)
		if(ROGUE_SPELL_COST_STAMINA)
			if(caster.get_stamina_loss() + used >= caster.maxHealth - caster.crit_threshold)
				if(feedback)
					caster.balloon_alert(caster, "not enough stamina to cast!")
				return FALSE
		if(ROGUE_SPELL_COST_MANA)
			if(!istype(caster) || !caster.rogue_has_mana(used))
				if(feedback)
					caster.balloon_alert(caster, "not enough mana to cast!")
				return FALSE
	return TRUE

/// Vibelin invoke_cost(): pays and returns the price.
/datum/action/cooldown/spell/rogue/proc/invoke_cost(price)
	var/used = isnull(price) ? get_adjusted_cost() : price
	if(used <= 0)
		return 0
	var/mob/living/carbon/human/caster = owner
	switch(cost_type)
		if(ROGUE_SPELL_COST_STAMINA)
			caster.adjust_stamina_loss(used)
		if(ROGUE_SPELL_COST_MANA)
			if(!istype(caster))
				return 0
			used = caster.rogue_spend_mana(used)
	return used

/// Vibelin handle_exp(): the characteristic and a share of the price, up to the skill's cap; from Apprentice on it waits for
/// sleep (rogue_craft_experience(), crafting/experience.dm).
/datum/action/cooldown/spell/rogue/proc/handle_exp(spent)
	var/modifier = experience_modifier_key ? rogue_value_or(experience_modifier_key, 0) : 0
	if(modifier <= 0 || !associated_skill || !isliving(owner))
		return
	var/mob/living/caster = owner
	if(caster.rogue_learned_rank(associated_skill) >= rogue_value("magic_experience_rank_cap"))
		return
	caster.rogue_craft_experience(associated_skill, caster.rogue_stat(associated_stat) + spent * modifier / 2, silent = TRUE)

/// Ratwood check_weapon_in_hand(): a weapon that is not a staff, tome or shield, or a gun, in either hand.
/datum/action/cooldown/spell/rogue/proc/check_weapon_in_hand()
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/caster = owner
	for(var/obj/item/held as anything in caster.held_items)
		if(!held || rogue_implement_tier(held))
			continue
		if(ispath(held.associated_skill, /datum/attribute/skill/combat/staves) || ispath(held.associated_skill, /datum/attribute/skill/combat/arcyne))
			continue
		if(istype(held, /obj/item/gun))
			return TRUE
		if(istype(held, /obj/item/rogueweapon) && !istype(held, /obj/item/rogueweapon/shield))
			return TRUE
	return FALSE

/// The best staff or tome in hand (Ratwood get_held_implement()).
/datum/action/cooldown/spell/rogue/proc/get_held_implement()
	if(!ishuman(owner))
		return null
	var/mob/living/carbon/human/caster = owner
	var/obj/item/best
	for(var/obj/item/held as anything in caster.held_items)
		if(held && rogue_implement_tier(held) > (best ? rogue_implement_tier(best) : ROGUE_IMPLEMENT_NONE))
			best = held
	return best

/// The cast went wrong after it began (Ratwood's cast() returning FALSE): nothing is paid, the cooldown comes back. Returns
/// FALSE for cast() to return.
/datum/action/cooldown/spell/rogue/proc/fail(message)
	spell_failed = TRUE
	if(message)
		to_chat(owner, span_warning(message))
	return FALSE

/datum/action/cooldown/spell/rogue/before_cast(atom/cast_on)
	spell_failed = FALSE
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	if(click_to_activate && cast_on != owner && get_dist(get_turf(owner), get_turf(cast_on)) > cast_range)
		owner.balloon_alert(owner, "too far away!")
		return . | SPELL_CANCEL_CAST
	if(!check_cost())
		return . | SPELL_CANCEL_CAST
	weapon_penalty_active = weapon_cast_penalized && check_weapon_in_hand()
	if(weapon_penalty_active)
		to_chat(owner, span_warning("Holding a weapon interferes with my arcyne conduits! This spell is more exhausting than usual."))
	// A spell cast on oneself charges as a channel (Vibelin's do_after path).
	if(!click_to_activate && charge_time > 0)
		var/flags = IGNORE_HELD_ITEM
		if(!(rogue_requirements & ROGUE_SPELL_REQUIRES_NO_MOVE))
			flags |= IGNORE_USER_LOC_CHANGE
		on_start_charge()
		var/success = do_after(owner, get_adjusted_charge_time(), owner, timed_action_flags = flags, extra_checks = CALLBACK(src, PROC_REF(channel_checks)))
		end_charging()
		if(!success)
			owner.balloon_alert(owner, "channeling was interrupted!")
			return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/rogue/proc/channel_checks()
	return currently_charging && can_cast_spell(FALSE)

/datum/action/cooldown/spell/rogue/after_cast(atom/cast_on)
	if(spell_failed)
		reset_spell_cooldown()
	else
		var/spent = invoke_cost()
		if(spent)
			handle_exp(spent)
			give_residual_focus(spent)
		if(weapon_penalty_active && cooldown_time)
			StartCooldown(cooldown_time * rogue_value("magic_weapon_penalty"))
		var/obj/item/rogueweapon/implement = get_held_implement()
		if(istype(implement) && spell_color)
			rogue_attune_implement(implement, spell_color)
	weapon_penalty_active = FALSE
	charged = FALSE
	return ..()

/// Ratwood apply_residual_focus(): a staff or tome in hand gives back a share of the price over a while.
/datum/action/cooldown/spell/rogue/proc/give_residual_focus(spent)
	if(cost_type != ROGUE_SPELL_COST_MANA || !ishuman(owner))
		return
	var/obj/item/implement = get_held_implement()
	if(!implement)
		return
	var/mob/living/carbon/human/caster = owner
	caster.rogue_get_mana()?.add_residual(spent * rogue_implement_refund(implement))

/// Pointed spells (Vibelin puts them on the base): the armed spell takes the next click; a charged one waits for the mouse
/// to be held and let go (start_casting()). Right click disarms it, a click with Shift, Ctrl or Alt goes on as usual.
/datum/action/cooldown/spell/rogue/set_click_ability(mob/on_who)
	if(currently_charging)
		return FALSE
	. = ..()
	if(!.)
		return
	var/tip = charge_time > 0 ? "<B>Hold the mouse on a target and let go once charged.</B>" : "<B>Click a target to cast it.</B>"
	to_chat(on_who, span_notice("[active_msg] [tip]"))
	if(charge_time > 0 && on_who.client)
		RegisterSignal(on_who.client, COMSIG_CLIENT_MOUSEDOWN, PROC_REF(start_casting), override = TRUE)

/datum/action/cooldown/spell/rogue/unset_click_ability(mob/on_who, refund_cooldown = TRUE)
	. = ..()
	if(!.)
		return
	if(refund_cooldown)
		to_chat(on_who, span_notice("[deactive_msg]"))
	if(currently_charging)
		cancel_casting()
	if(on_who.client)
		UnregisterSignal(on_who.client, list(COMSIG_CLIENT_MOUSEDOWN, COMSIG_CLIENT_MOUSEUP))

/datum/action/cooldown/spell/rogue/InterceptClickOn(mob/living/clicker, params, atom/target)
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, SHIFT_CLICK) || LAZYACCESS(modifiers, CTRL_CLICK) || LAZYACCESS(modifiers, ALT_CLICK))
		return FALSE
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		unset_click_ability(clicker, refund_cooldown = TRUE)
		return TRUE
	// A charged spell is cast from try_casting() only; a plain click is swallowed.
	if(charge_time > 0 && !charged)
		return TRUE
	var/atom/aimed = target
	if(aim_assist && isturf(target))
		aimed = (locate(/mob/living/carbon/human) in target) || (locate(/mob/living) in target) || target
	. = ..(clicker, params, aimed)
	charged = FALSE

/// Vibelin start_casting(): the mouse went down with the spell armed; the charge begins and the click is held back.
/datum/action/cooldown/spell/rogue/proc/start_casting(client/source, atom/object, turf/location, control, params)
	SIGNAL_HANDLER
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, SHIFT_CLICK) || LAZYACCESS(modifiers, CTRL_CLICK) || LAZYACCESS(modifiers, ALT_CLICK) || LAZYACCESS(modifiers, RIGHT_CLICK))
		return
	if(!owner || source.mob != owner || !isturf(owner.loc) || currently_charging)
		return
	if(istype(object, /atom/movable/screen) && object.plane != CLICKCATCHER_PLANE)
		return
	if(!can_cast_spell(TRUE))
		return
	RegisterSignal(source, COMSIG_CLIENT_MOUSEUP, PROC_REF(try_casting), override = TRUE)
	RegisterSignals(owner, list(COMSIG_LIVING_DEATH, COMSIG_MOB_LOGOUT), PROC_REF(signal_cancel), override = TRUE)
	if(rogue_requirements & ROGUE_SPELL_REQUIRES_NO_MOVE)
		RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(signal_cancel), override = TRUE)
	// The click of this press is not to reach Click() (TG fullauto).
	source.click_intercept_time = world.time + rogue_value("magic_charge_timeout")
	auto_cancel_timer = addtimer(CALLBACK(src, PROC_REF(cancel_casting)), rogue_value("magic_charge_timeout"), TIMER_STOPPABLE)
	charge_started_at = world.time
	charge_target_time = get_adjusted_charge_time()
	on_start_charge()

/// Vibelin try_casting(): the mouse came up; cast at what is under it if the charge is full, else stay armed.
/datum/action/cooldown/spell/rogue/proc/try_casting(client/source, atom/object, turf/location, control, params)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_CLIENT_MOUSEUP)
	if(auto_cancel_timer)
		deltimer(auto_cancel_timer)
		auto_cancel_timer = null
	// click_intercept_time stays: the Click() that follows this release is swallowed and clears it (TG fullauto).
	if(!currently_charging)
		return
	var/full = world.time >= charge_started_at + charge_target_time
	end_charging()
	if(!full)
		owner.balloon_alert(owner, "released too early!")
		return
	if(!can_cast_spell(TRUE))
		return
	var/atom/target = object
	if(isnull(location) || istype(object, /atom/movable/screen))
		target = parse_caught_click_modifiers(params2list(params), get_turf(source.eye), source)
	if(!target)
		return
	charged = TRUE
	INVOKE_ASYNC(src, PROC_REF(InterceptClickOn), owner, params, target)

/datum/action/cooldown/spell/rogue/proc/signal_cancel()
	SIGNAL_HANDLER
	cancel_casting()

/// Vibelin on_start_charge(): the caster slows, glows in the spell's colour, and the cursor fills while the charge runs.
/datum/action/cooldown/spell/rogue/proc/on_start_charge()
	currently_charging = TRUE
	build_all_button_icons(UPDATE_BUTTON_STATUS|UPDATE_BUTTON_BACKGROUND)
	if(charge_slowdown)
		owner.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/rogue_spell_charge, multiplicative_slowdown = charge_slowdown)
	// On a channel of its own, so end_charging() can cut it off (Vibelin CHANNEL_CHARGED_SPELL; TG has the same channel).
	playsound(owner, ROGUE_SPELL_CHARGE_SOUND, 50, FALSE, channel = CHANNEL_CHARGED_SPELL)
	owner.add_filter(ROGUE_SPELL_CHARGE_FILTER, 2, list("type" = "outline", "color" = spell_color || "#9932CC", "alpha" = 120, "size" = 1))
	if(owner.client)
		owner.client.mouse_override_icon = ROGUE_SPELL_CHARGING_CURSOR
		owner.update_mouse_pointer()
		if(charge_target_time > 0)
			addtimer(CALLBACK(src, PROC_REF(show_charged), charge_started_at), charge_target_time)
	if(rogue_requirements & ROGUE_SPELL_REQUIRES_NO_MOVE)
		owner.balloon_alert(owner, "be still while channelling...")

/// The charge is full: the cursor says so.
/datum/action/cooldown/spell/rogue/proc/show_charged(started_at)
	if(!currently_charging || charge_started_at != started_at || !owner?.client)
		return
	owner.client.mouse_override_icon = ROGUE_SPELL_CHARGED_CURSOR
	owner.update_mouse_pointer()

/// Vibelin end_charging().
/datum/action/cooldown/spell/rogue/proc/end_charging()
	currently_charging = FALSE
	charge_started_at = 0
	charge_target_time = 0
	if(!owner)
		return
	UnregisterSignal(owner, list(COMSIG_LIVING_DEATH, COMSIG_MOB_LOGOUT, COMSIG_MOVABLE_MOVED))
	// Vibelin end_charging(): the charge sound stops for the caster and, by a silent sound on its channel, for those near.
	owner.stop_sound_channel(CHANNEL_CHARGED_SPELL)
	playsound(owner, sound(null, repeat = 0), 50, FALSE, channel = CHANNEL_CHARGED_SPELL)
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/rogue_spell_charge)
	owner.remove_filter(ROGUE_SPELL_CHARGE_FILTER)
	if(owner.client)
		owner.client.mouse_override_icon = owner.click_intercept == src ? ranged_mousepointer : null
		owner.update_mouse_pointer()
	build_all_button_icons(UPDATE_BUTTON_STATUS|UPDATE_BUTTON_BACKGROUND)

/// Vibelin cancel_casting().
/datum/action/cooldown/spell/rogue/proc/cancel_casting()
	if(auto_cancel_timer)
		deltimer(auto_cancel_timer)
		auto_cancel_timer = null
	if(owner?.client)
		owner.client.click_intercept_time = 0
		UnregisterSignal(owner.client, COMSIG_CLIENT_MOUSEUP)
	charged = FALSE
	end_charging()

/datum/action/cooldown/spell/rogue/is_action_active(atom/movable/screen/movable/action_button/current_button)
	return currently_charging || ..()

/// Shift+G on the armed spell (Vibelin, Twilight Axis toggle_alt_mode()): a spell with an alt mode switches it and returns TRUE.
/datum/action/cooldown/spell/rogue/proc/toggle_alt_mode(mob/user)
	return FALSE

/datum/movespeed_modifier/rogue_spell_charge
	variable = TRUE

/// The key of a spell type in magic.txt.
/proc/rogue_spell_value_key(spell_type)
	return "spell_[replacetext(copytext("[spell_type]", length("/datum/action/cooldown/spell/rogue/") + 1), "/", "_")]"

/// A number of a spell type without making the spell (the basket and the book show them).
/proc/rogue_spell_tune(spell_type, var_name)
	return rogue_value_or("[rogue_spell_value_key(spell_type)]_[var_name]", 0)

/// One spell of each type, never granted, for what initial() cannot read (lists).
/proc/rogue_spell_prototype(spell_type)
	var/static/list/prototypes = list()
	if(!prototypes[spell_type])
		prototypes[spell_type] = new spell_type
	return prototypes[spell_type]

/// The basket: every spell type but the families, by name.
/proc/rogue_spell_basket()
	var/static/list/basket
	if(basket)
		return basket
	var/list/by_name = list()
	for(var/datum/action/cooldown/spell/rogue/spell_type as anything in subtypesof(/datum/action/cooldown/spell/rogue))
		if(initial(spell_type.abstract_spell_type) == spell_type)
			continue
		by_name["[initial(spell_type.name)] [spell_type]"] = spell_type
	basket = list()
	for(var/key in sort_list(by_name))
		basket += by_name[key]
	return basket

/// The tier of a staff or tome (Ratwood implement_tier): lesser, greater and grand staves, lesser, greater and grand tomes.
/proc/rogue_implement_tier(obj/item/held)
	if(istype(held, /obj/item/rogueweapon/woodstaff/implement/grand) || istype(held, /obj/item/rogueweapon/spellbook/grand))
		return ROGUE_IMPLEMENT_GRAND
	if(istype(held, /obj/item/rogueweapon/woodstaff/implement/greater) || istype(held, /obj/item/rogueweapon/spellbook/greater))
		return ROGUE_IMPLEMENT_GREATER
	if(istype(held, /obj/item/rogueweapon/woodstaff/implement) || istype(held, /obj/item/rogueweapon/spellbook))
		return ROGUE_IMPLEMENT_LESSER
	return ROGUE_IMPLEMENT_NONE

/// The share of a spell's price a staff or tome gives back (Ratwood IMPLEMENT_REFUND_*).
/proc/rogue_implement_refund(obj/item/held)
	switch(rogue_implement_tier(held))
		if(ROGUE_IMPLEMENT_GRAND)
			return rogue_value("magic_implement_refund_grand")
		if(ROGUE_IMPLEMENT_GREATER)
			return rogue_value("magic_implement_refund_greater")
		if(ROGUE_IMPLEMENT_LESSER)
			return rogue_value("magic_implement_refund_lesser")
	return 0

/// Ratwood apply_attunement_glow(): the staff takes the colour of the last spell cast through it, brighter the better it is.
/proc/rogue_attune_implement(obj/item/rogueweapon/implement, spell_color)
	if(implement.get_filter(ROGUE_IMPLEMENT_GLOW_FILTER) && implement.rogue_attuned_color == spell_color)
		return
	if(!COOLDOWN_FINISHED(implement, rogue_attunement_cd))
		return
	COOLDOWN_START(implement, rogue_attunement_cd, rogue_value("magic_implement_attune_cooldown"))
	implement.rogue_attuned_color = spell_color
	implement.remove_filter(ROGUE_IMPLEMENT_GLOW_FILTER)
	implement.add_filter(ROGUE_IMPLEMENT_GLOW_FILTER, 2, list("type" = "outline", "color" = spell_color, "alpha" = 40 + 40 * rogue_implement_tier(implement), "size" = 1))

/obj/item/rogueweapon
	var/rogue_attuned_color
	COOLDOWN_DECLARE(rogue_attunement_cd)
