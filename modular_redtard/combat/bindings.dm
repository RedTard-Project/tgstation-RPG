/// B15: ropes, chains and nets (Azure Peak ropechainbola/rope.dm, chain.dm, net.dm; carbon.dm cuff_resist()).
///
/// A rope or a chain on the tie intent binds the arms of the one clicked, or the legs when the legs or feet are aimed at; it
/// takes a while, half as long on one who yields or complies, and cannot be done to one standing tense in combat stance.
/// Bound legs walk slowly. Slipping out takes the binding's own time, the less the stronger one is; one strong enough snaps
/// it at once. The planar binding shackles are chains, and bind the same way. A thrown net ensnares a target: from close it
/// only holds them a moment, from further it holds, unbalances and opens them and slows them for a while, thrown from afar
/// it knocks them down and slows them longer; a net that ensnares is spent.

/obj/item/rope
	/// The stem of its numbers in combat.txt (bind_<kind>_slip_time, bind_<kind>_break_time).
	var/rogue_bind_kind = "rope"
	/// Azure Peak cuffsound.
	var/rogue_bind_sound

/obj/item/rope/chain
	rogue_bind_kind = "chain"
	rogue_bind_sound = 'modular_redtard/combat/sound/bindings/chains.ogg'

/obj/item/rope/Initialize(mapload)
	. = ..()
	breakouttime = rogue_value("bind_[rogue_bind_kind]_break_time")

/obj/item/rope/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!iscarbon(interacting_with) || interacting_with == user || !rogue_combat_enabled() || !istype(user.rogue_active_intent(), /datum/intent/tie))
		return ..()
	var/legs = (rogue_zone_target(user.rogue_precise_zone()) in list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
	INVOKE_ASYNC(src, PROC_REF(rogue_try_bind), interacting_with, user, legs)
	return ITEM_INTERACT_SUCCESS

/// Whether the arms (or legs) of the target can be bound now; says why not.
/obj/item/rope/proc/rogue_can_bind(mob/living/carbon/target, mob/living/user, legs)
	if(QDELETED(target) || !user.Adjacent(target) || !user.is_holding(src))
		return FALSE
	if(legs ? target.legcuffed : target.handcuffed)
		to_chat(user, span_warning("[target] is already bound."))
		return FALSE
	if(legs && target.num_legs < 2)
		to_chat(user, span_warning("[target] is missing a leg."))
		return FALSE
	if(!legs && !target.canBeHandcuffed())
		to_chat(user, span_warning("[target] has no arms to tie up."))
		return FALSE
	if(target.combat_mode && target.body_position == STANDING_UP)
		to_chat(user, span_warning("I can't tie them, they are too tense!"))
		return FALSE
	return TRUE

/// Azure Peak try_cuff_arms() and try_cuff_legs().
/obj/item/rope/proc/rogue_try_bind(mob/living/carbon/target, mob/living/user, legs)
	if(!rogue_can_bind(target, user, legs))
		return
	var/part = legs ? "legs" : "arms"
	var/time = rogue_value("bind_tie_time")
	if(target.rogue_yielding || target.has_status_effect(/datum/status_effect/rogue_compliance))
		time *= rogue_value("bind_surrender_factor")
	target.visible_message(span_warning("[user] is trying to tie [target]'s [part] with [src]!"), span_userdanger("[user] is trying to tie my [part] with [src]!"), null, COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_notice("I start tying [target]'s [part] with [src]..."))
	if(rogue_bind_sound)
		playsound(target, rogue_bind_sound, legs ? 30 : 100, TRUE, -2)
	if(!do_after(user, time, target) || !rogue_can_bind(target, user, legs))
		to_chat(user, span_warning("I fail to tie up [target]!"))
		return
	if(!user.temporarilyRemoveItemFromInventory(src))
		return
	target.equip_to_slot(src, legs ? ITEM_SLOT_LEGCUFFED : ITEM_SLOT_HANDCUFFED)
	if(legs)
		target.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/rogue_leg_bound, multiplicative_slowdown = rogue_value("bind_legs_slowdown"))
	target.visible_message(span_warning("[user] ties [target]'s [part] with [src]."), span_danger("[user] ties my [part] with [src]."), null, COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_notice("I tie [target]'s [part] with [src]."))
	log_combat(user, target, legs ? "legcuffed" : "handcuffed", src)

/// Off the legs: they walk freely again.
/obj/item/rope/dropped(mob/user, silent)
	var/mob/living/carbon/bound = user
	if(istype(bound) && bound.legcuffed == src)
		bound.remove_movespeed_modifier(/datum/movespeed_modifier/rogue_leg_bound)
	return ..()

/datum/movespeed_modifier/rogue_leg_bound
	variable = TRUE

/// Azure Peak cuff_resist() for a rope or a chain: the binding's time to slip out, cut by every point of strength above the
/// middling; one strong enough snaps it at once.
/mob/living/carbon/human/cuff_resist(obj/item/cuffs, breakouttime = null, cuff_break = 0)
	var/obj/item/rope/binding = cuffs
	if(!istype(binding) || !rogue_combat_enabled() || !isnull(breakouttime) || cuff_break)
		return ..()
	var/strength = rogue_stat(ROGUE_STAT_STRENGTH)
	if(strength > rogue_value("bind_snap_strength"))
		return ..(cuffs, 0, INSTANT_CUFFBREAK)
	var/time = rogue_value("bind_[binding.rogue_bind_kind]_slip_time")
	if(strength > ROGUE_ATTRIBUTE_MIDDLING)
		time = max(0, time - time * (strength - ROGUE_ATTRIBUTE_MIDDLING) * rogue_value("bind_slip_per_strength"))
	return ..(cuffs, time, 0)

// --- Nets ---

/obj/item/net/Initialize(mapload)
	. = ..()
	throw_range = rogue_value("net_throw_range")

/obj/item/net/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(. || !iscarbon(hit_atom) || !throwingdatum || !rogue_combat_enabled())
		return
	rogue_ensnare(hit_atom, throwingdatum.dist_travelled, throwingdatum.get_thrower())

/// Azure Peak ensnare(): the further the throw, the harder it holds.
/obj/item/net/proc/rogue_ensnare(mob/living/carbon/target, dist_travelled, mob/thrower)
	if(target.legcuffed || target.num_legs < 2)
		return
	if(dist_travelled <= rogue_value("net_close_range"))
		target.Immobilize(rogue_value("net_close_hold"))
		return
	if(dist_travelled >= rogue_value("net_far_range"))
		target.Knockdown(rogue_value("net_far_knockdown"))
		target.apply_status_effect(/datum/status_effect/rogue/exposed, rogue_value("net_far_exposed"))
		target.apply_status_effect(/datum/status_effect/rogue_netted, rogue_value("net_far_time"))
		target.visible_message(span_danger("[src] <b>EXPERTLY</b> ensnares [target]!"), span_userdanger("[src] <b>EXPERTLY</b> entraps me!"))
		playsound(target, 'modular_redtard/combat/sound/bindings/net_impact_heavy.ogg', 100, TRUE, 5)
	else
		target.Immobilize(rogue_value("net_mid_hold"))
		var/mob/living/carbon/human/unbalanced = target
		if(istype(unbalanced))
			unbalanced.rogue_off_balance(rogue_value("net_mid_off_balance"))
		target.apply_status_effect(/datum/status_effect/rogue/exposed, rogue_value("net_mid_exposed"))
		target.apply_status_effect(/datum/status_effect/rogue_netted, rogue_value("net_mid_time"))
		target.visible_message(span_danger("[src] ensnares [target]!"), span_userdanger("[src] entraps me!"))
		playsound(target, 'modular_redtard/combat/sound/bindings/net_impact.ogg', 100, TRUE)
	if(thrower)
		log_combat(thrower, target, "netted", src)
	qdel(src)

/// Azure Peak /datum/status_effect/debuff/netted: slower feet and less will while the net clings.
/datum/status_effect/rogue_netted
	id = "rogue_netted"
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null
	tick_interval = STATUS_EFFECT_NO_TICK

/datum/status_effect/rogue_netted/on_creation(mob/living/new_owner, set_duration)
	duration = set_duration
	return ..()

/datum/status_effect/rogue_netted/refresh(effect, set_duration)
	duration = max(duration, set_duration)

/datum/status_effect/rogue_netted/on_apply()
	owner.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/rogue_netted, multiplicative_slowdown = rogue_value("net_slowdown"))
	owner.attributes?.set_variable_attribute_modifier(id, list(ROGUE_STAT_SPEED = -rogue_value("net_speed_malus"), ROGUE_STAT_WILLPOWER = -rogue_value("net_will_malus")))
	return TRUE

/datum/status_effect/rogue_netted/on_remove()
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/rogue_netted)
	owner.attributes?.remove_attribute_modifier(id)
	owner.visible_message(span_notice("[owner] slips free of the net."), span_notice("I slip free of the net."))

/datum/movespeed_modifier/rogue_netted
	variable = TRUE
