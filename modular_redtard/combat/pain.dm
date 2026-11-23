/// Vibelin's pain (block VR1, the Vibelin base of medicine) on medieval maps: pain is a state of each part of the body
/// (rogue_pain_dam), added by hits and by custom pain, easing by itself, more while lying; with what injuries, crits, lodged
/// things and organs hurt it makes the part's shock (rogue_get_shock()). The parts add up, the worst first, to traumatic
/// shock (Vibelin getShock()), and the shock stage follows it at a pace set by willpower, through eight stages: slowed,
/// stuttering, held, knocked down, blacked out (Vibelin carbon_shock.dm). Painkillers are the chemical effect
/// ROGUE_CE_PAINKILLER (combat/chem_effects.dm); the body's own are endorphins, the status rogue_adrenaline.
/// Death and unconsciousness stay Roguetown's (combat/crit.dm): the shock's faints are knock-outs.
/// The Life tick that runs all this is the element rogue_blood's (combat/blood.dm).

/// The physiology numbers (pain, shock, pulse, blood), read once and again only when the mechanics numbers change (a reload,
/// a value set in the Rogue Mechanics panel): the Life tick of every body reads them.
/datum/rogue_physiology_numbers
	var/revision = -1
	var/pain_max_factor
	var/pain_heal_per_second
	var/pain_heal_rest_factor
	var/pain_painkiller_divisor
	var/pain_grab_factor
	var/pain_embedded_factor
	var/pain_limb_pick_chance
	var/pain_limb_bad
	var/pain_limb_terrible
	var/pain_limb_message_chance
	var/pain_limb_message_chance_bad
	var/shock_stage_1
	var/shock_stage_2
	var/shock_stage_3
	var/shock_stage_4
	var/shock_stage_5
	var/shock_stage_6
	var/shock_stage_7
	var/shock_stage_8
	var/shock_hysteresis
	var/shock_limb_full_share
	var/shock_limb_overshoot
	var/shock_stack_decay
	var/shock_useless_decay
	var/shock_stack_limbs
	var/shock_speed
	var/shock_recovery
	var/shock_growth_share
	var/shock_slowdown
	var/shock_arrest_slowdown
	var/shock_penalty_pain
	var/shock_penalty_divisor
	var/shock_penalty_chance_cap
	var/shock_penalty_chance_divisor
	var/shock_penalty_cap
	var/shock_stutter_chance
	var/shock_stutter
	var/shock_stage1_pain
	var/shock_stage3_pain
	var/shock_stage4_hold
	var/shock_stage4_chance
	var/shock_stage4_knockdown
	var/shock_stage5_chance
	var/shock_stage5_knockdown
	var/shock_stage5_gasp_chance
	var/shock_stage6_chance
	var/shock_stage6_unconscious
	var/shock_stage7_stun
	var/shock_stage7_knockdown
	var/shock_stage7_chance
	var/shock_stage7_unconscious
	var/shock_stage8_pain
	var/shock_stage8_unconscious
	var/shock_stage8_hold_unconscious
	var/pulse_chem_safe
	var/pulse_chem_damage_share
	var/heart_pulse_damage
	var/pulse_thready_damage_chance
	var/pulse_faster_damage_chance
	var/circulation_pulse_none
	var/circulation_pulse_slow
	var/circulation_pulse_fast
	var/circulation_pulse_faster
	var/heart_min_efficiency
	var/oxygenated_weak
	var/oxygenated_strong
	var/oxygenated_strong_power
	var/blood_safe
	var/blood_okay
	var/blood_bad
	var/blood_survive
	var/blood_regen
	var/blood_volume_scale
	var/blood_excess_share
	var/blood_excess_artery_chance
	var/bleed_pulse_slow
	var/bleed_pulse_fast
	var/bleed_pulse_faster
	var/bleed_bleedout_factor
	var/bleed_burnt_share
	var/bleed_burnt_rate
	var/bleed_tourniquet_factor
	var/bleed_grasp_factor
	var/bleed_clamped_factor
	var/bleed_con_base
	var/bleed_con_share
	var/bleed_con_cap
	var/bleed_thick_blood
	var/bleed_crit_resistance
	var/bleed_crit_weakness
	var/bleed_yield
	var/bleed_sign_chance
	var/bleed_blur
	var/bleed_faint_min
	var/bleed_faint_max
	var/bleed_oxy_bad
	var/bleed_oxy_survive
	var/bleed_oxy_heal
	var/bleed_oxy_mindless_factor
	var/bleed_sound_low
	var/bleed_sound_mid
	var/bleed_sound_high

/datum/rogue_physiology_numbers/proc/read()
	pain_max_factor = rogue_value("pain_max_factor")
	pain_heal_per_second = rogue_value("pain_heal_per_second")
	pain_heal_rest_factor = rogue_value("pain_heal_rest_factor")
	pain_painkiller_divisor = max(rogue_value("pain_painkiller_divisor"), 1)
	pain_grab_factor = rogue_value("pain_grab_factor")
	pain_embedded_factor = rogue_value("pain_embedded_factor")
	pain_limb_pick_chance = rogue_value("pain_limb_pick_chance")
	pain_limb_bad = rogue_value("pain_limb_bad")
	pain_limb_terrible = rogue_value("pain_limb_terrible")
	pain_limb_message_chance = rogue_value("pain_limb_message_chance")
	pain_limb_message_chance_bad = rogue_value("pain_limb_message_chance_bad")
	shock_stage_1 = rogue_value("shock_stage_1")
	shock_stage_2 = rogue_value("shock_stage_2")
	shock_stage_3 = rogue_value("shock_stage_3")
	shock_stage_4 = rogue_value("shock_stage_4")
	shock_stage_5 = rogue_value("shock_stage_5")
	shock_stage_6 = rogue_value("shock_stage_6")
	shock_stage_7 = rogue_value("shock_stage_7")
	shock_stage_8 = max(rogue_value("shock_stage_8"), 1)
	shock_hysteresis = rogue_value("shock_hysteresis")
	shock_limb_full_share = max(rogue_value("shock_limb_full_share"), 0.01)
	shock_limb_overshoot = rogue_value("shock_limb_overshoot")
	shock_stack_decay = rogue_value("shock_stack_decay")
	shock_useless_decay = rogue_value("shock_useless_decay")
	shock_stack_limbs = rogue_value("shock_stack_limbs")
	shock_speed = rogue_value("shock_speed")
	shock_recovery = rogue_value("shock_recovery")
	shock_growth_share = rogue_value("shock_growth_share")
	shock_slowdown = rogue_value("shock_slowdown")
	shock_arrest_slowdown = rogue_value("shock_arrest_slowdown")
	shock_penalty_pain = rogue_value("shock_penalty_pain")
	shock_penalty_divisor = max(rogue_value("shock_penalty_divisor"), 0.01)
	shock_penalty_chance_cap = rogue_value("shock_penalty_chance_cap")
	shock_penalty_chance_divisor = max(rogue_value("shock_penalty_chance_divisor"), 0.01)
	shock_penalty_cap = rogue_value("shock_penalty_cap")
	shock_stutter_chance = rogue_value("shock_stutter_chance")
	shock_stutter = rogue_value("shock_stutter")
	shock_stage1_pain = rogue_value("shock_stage1_pain")
	shock_stage3_pain = rogue_value("shock_stage3_pain")
	shock_stage4_hold = rogue_value("shock_stage4_hold")
	shock_stage4_chance = rogue_value("shock_stage4_chance")
	shock_stage4_knockdown = rogue_value("shock_stage4_knockdown")
	shock_stage5_chance = rogue_value("shock_stage5_chance")
	shock_stage5_knockdown = rogue_value("shock_stage5_knockdown")
	shock_stage5_gasp_chance = rogue_value("shock_stage5_gasp_chance")
	shock_stage6_chance = rogue_value("shock_stage6_chance")
	shock_stage6_unconscious = rogue_value("shock_stage6_unconscious")
	shock_stage7_stun = rogue_value("shock_stage7_stun")
	shock_stage7_knockdown = rogue_value("shock_stage7_knockdown")
	shock_stage7_chance = rogue_value("shock_stage7_chance")
	shock_stage7_unconscious = rogue_value("shock_stage7_unconscious")
	shock_stage8_pain = rogue_value("shock_stage8_pain")
	shock_stage8_unconscious = rogue_value("shock_stage8_unconscious")
	shock_stage8_hold_unconscious = rogue_value("shock_stage8_hold_unconscious")
	pulse_chem_safe = rogue_value("pulse_chem_safe")
	pulse_chem_damage_share = rogue_value("pulse_chem_damage_share")
	heart_pulse_damage = rogue_value("heart_pulse_damage")
	pulse_thready_damage_chance = rogue_value("pulse_thready_damage_chance")
	pulse_faster_damage_chance = rogue_value("pulse_faster_damage_chance")
	circulation_pulse_none = rogue_value("circulation_pulse_none")
	circulation_pulse_slow = rogue_value("circulation_pulse_slow")
	circulation_pulse_fast = rogue_value("circulation_pulse_fast")
	circulation_pulse_faster = rogue_value("circulation_pulse_faster")
	heart_min_efficiency = rogue_value("heart_min_efficiency")
	oxygenated_weak = rogue_value("oxygenated_weak")
	oxygenated_strong = rogue_value("oxygenated_strong")
	oxygenated_strong_power = rogue_value("oxygenated_strong_power")
	blood_safe = rogue_value("blood_safe")
	blood_okay = rogue_value("blood_okay")
	blood_bad = rogue_value("blood_bad")
	blood_survive = rogue_value("blood_survive")
	blood_regen = rogue_value("blood_regen")
	blood_volume_scale = rogue_value("blood_volume_scale")
	blood_excess_share = rogue_value("blood_excess_share")
	blood_excess_artery_chance = rogue_value("blood_excess_artery_chance")
	bleed_pulse_slow = rogue_value("bleed_pulse_slow")
	bleed_pulse_fast = rogue_value("bleed_pulse_fast")
	bleed_pulse_faster = rogue_value("bleed_pulse_faster")
	bleed_bleedout_factor = rogue_value("bleed_bleedout_factor")
	bleed_burnt_share = rogue_value("bleed_burnt_share")
	bleed_burnt_rate = rogue_value("bleed_burnt_rate")
	bleed_tourniquet_factor = rogue_value("bleed_tourniquet_factor")
	bleed_grasp_factor = rogue_value("bleed_grasp_factor")
	bleed_clamped_factor = rogue_value("bleed_clamped_factor")
	bleed_con_base = rogue_value("bleed_con_base")
	bleed_con_share = rogue_value("bleed_con_share")
	bleed_con_cap = rogue_value("bleed_con_cap")
	bleed_thick_blood = rogue_value("bleed_thick_blood")
	bleed_crit_resistance = rogue_value("bleed_crit_resistance")
	bleed_crit_weakness = rogue_value("bleed_crit_weakness")
	bleed_yield = rogue_value("bleed_yield")
	bleed_sign_chance = rogue_value("bleed_sign_chance")
	bleed_blur = rogue_value("bleed_blur")
	bleed_faint_min = rogue_value("bleed_faint_min")
	bleed_faint_max = rogue_value("bleed_faint_max")
	bleed_oxy_bad = rogue_value("bleed_oxy_bad")
	bleed_oxy_survive = rogue_value("bleed_oxy_survive")
	bleed_oxy_heal = rogue_value("bleed_oxy_heal")
	bleed_oxy_mindless_factor = rogue_value("bleed_oxy_mindless_factor")
	bleed_sound_low = rogue_value("bleed_sound_low")
	bleed_sound_mid = rogue_value("bleed_sound_mid")
	bleed_sound_high = rogue_value("bleed_sound_high")
	revision = rogue_mechanics_revision()

/// The physiology numbers, fresh for the current revision of the mechanics numbers.
/proc/rogue_physiology()
	var/static/datum/rogue_physiology_numbers/numbers
	if(!numbers)
		numbers = new
	if(numbers.revision != rogue_mechanics_revision())
		numbers.read()
	return numbers

/obj/item/bodypart
	/// Vibelin pain_dam: the pain this part holds by itself, besides what its injuries and crits hurt.
	var/rogue_pain_dam = 0
	/// The part's shock at the last count of traumatic shock (rogue_update_shock()), so the pain messages need not count it again.
	var/rogue_last_shock = 0

/mob/living/carbon
	/// A wound's pain changed without damage that would refresh the HUD (Ratwood mark_pain_hud_dirty()): the heart is redrawn
	/// on the next Life tick.
	var/rogue_pain_hud_dirty = FALSE
	/// Vibelin traumatic_shock: the pain of the body as one number (rogue_update_shock()), 0 to the last stage and a little past.
	var/rogue_traumatic_shock = 0
	/// Vibelin shock_stage: what the body suffers of it, following the traumatic shock slower than it changes.
	var/rogue_shock_stage = 0
	/// Vibelin highest_shock_stage_triggered: the stage whose one-time effects have run.
	var/rogue_shock_highest = 0
	/// Vibelin shock_penalty: perception, intelligence and speed taken by a sharp pain for a while.
	var/rogue_shock_penalty = 0
	/// The step of the heart's pain the HUD last showed (a fifth of the stages each).
	var/rogue_shock_hud_step = 0
	/// When pain may next be felt as custom pain, a message be sent, a cry be heard (Vibelin next_pain_time and the rest).
	var/rogue_next_pain = 0
	var/rogue_next_pain_message = 0
	var/rogue_next_pain_emote = 0
	/// When the body may make its own endorphins again (Vibelin COOLDOWN_CARBON_ENDORPHINATION).
	var/rogue_next_endorphin = 0

/datum/wound
	/// The pain healing has eased (Ratwood heal_wound(): woundpain falls by half of what is healed).
	var/rogue_pain_eased = 0

/datum/movespeed_modifier/rogue_shock
	variable = TRUE

/datum/movespeed_modifier/rogue_cardiac_arrest
	variable = TRUE

// --- Pain of the wounds. The module's crits (/datum/wound/rogue, combat/wounds.dm) count their own; a TG wound on a medieval
// body (a smite, an admin) hurts by Ratwood's old table, the fallback path.

/// What this wound hurts now: what a wound of the same kind hurts in Ratwood, less what healing has eased of it.
/datum/wound/proc/rogue_pain()
	return max(rogue_base_pain() - rogue_pain_eased, 0)

/// What a fresh wound of this kind and size hurts.
/datum/wound/proc/rogue_base_pain()
	return 0

/// Ratwood heal_wound(): healing eases the pain of the wound by half of what it heals, never below none.
/datum/wound/proc/rogue_ease_pain(amount)
	var/eased = min(rogue_pain(), round(amount / 2, DAMAGE_PRECISION))
	if(eased <= 0)
		return
	rogue_pain_eased += eased
	if(victim)
		victim.rogue_pain_hud_dirty = TRUE

/datum/wound/slash/flesh/rogue_base_pain()
	return rogue_cut_pain()

/datum/wound/pierce/bleed/rogue_base_pain()
	return rogue_cut_pain()

/// A cut or a stab of TG: a critical one is an opened artery (combat/blood.dm).
/datum/wound/proc/rogue_cut_pain()
	if(severity >= WOUND_SEVERITY_CRITICAL)
		switch(rogue_artery)
			if(ROGUE_ARTERY_THROAT)
				return rogue_value("pain_artery_neck")
			if(ROGUE_ARTERY_HEART)
				return rogue_value("pain_artery_chest")
		return rogue_value("pain_artery")
	return severity >= WOUND_SEVERITY_SEVERE ? rogue_value("pain_cut_severe") : rogue_value("pain_cut_moderate")

/// A dislocation, or a fracture from severe up.
/datum/wound/blunt/bone/rogue_base_pain()
	return severity >= WOUND_SEVERITY_SEVERE ? rogue_value("pain_fracture") : rogue_value("pain_dislocation")

/datum/wound/cranial_fissure/rogue_base_pain()
	return rogue_value("pain_fracture")

/datum/wound/burn/flesh/rogue_base_pain()
	switch(severity)
		if(WOUND_SEVERITY_CRITICAL)
			return rogue_value("pain_burn_critical")
		if(WOUND_SEVERITY_SEVERE)
			return rogue_value("pain_burn_severe")
	return rogue_value("pain_burn_moderate")

/datum/wound/rogue_stump/rogue_base_pain()
	return ROGUE_STUMP_PAIN * (stumps - sewn) + ROGUE_STUMP_SEWN_PAIN * sewn

/// A stump eases by half of what searing and medicine have closed of it (its integrity, combat/dismember.dm), as Ratwood's
/// cauterize_wound() and heal_wound() ease its woundpain.
/datum/wound/rogue_stump/rogue_pain()
	return max(rogue_base_pain() - max(ROGUE_STUMP_INTEGRITY * stumps - integrity, 0) / 2, 0)

// --- Pain of a part (Vibelin _bodyparts.dm add_pain(), remove_pain(), get_shock()).

/// Whether this part feels pain: a part of flesh on a body that feels pain (a prosthesis does not hurt).
/obj/item/bodypart/proc/rogue_can_feel_pain()
	if(!owner || !(biological_state & BIO_FLESH))
		return FALSE
	return owner.rogue_feels_pain()

/// The most this part can hurt, all included (Vibelin max_pain_damage: half again its most damage).
/obj/item/bodypart/proc/rogue_max_pain(datum/rogue_physiology_numbers/numbers = rogue_physiology())
	return max_damage * numbers.pain_max_factor

/// Adds pain to the part, up to what it can hold (Vibelin add_pain()); TRUE when some was added. The body counts its shock
/// anew unless told not to (the Life tick counts it once for all parts).
/obj/item/bodypart/proc/rogue_add_pain(amount, update_shock = TRUE)
	if(amount <= 0 || !rogue_can_feel_pain())
		return FALSE
	amount = min(rogue_max_pain() - rogue_pain_dam, amount)
	if(amount <= 0)
		return FALSE
	rogue_pain_dam = round(rogue_pain_dam + amount, DAMAGE_PRECISION)
	if(update_shock)
		owner.rogue_update_shock()
	return TRUE

/// Takes pain from the part (Vibelin remove_pain()); TRUE when some was taken.
/obj/item/bodypart/proc/rogue_remove_pain(amount, update_shock = TRUE)
	if(amount <= 0 || rogue_pain_dam <= 0)
		return FALSE
	rogue_pain_dam = max(FLOOR(rogue_pain_dam - min(amount, rogue_pain_dam), DAMAGE_PRECISION), 0)
	if(update_shock)
		owner?.rogue_update_shock()
	return TRUE

/// What the part hurts now (Vibelin get_shock()): its own pain, its injuries, its crits and wounds, what is lodged in it;
/// a hold on it eases it a little, painkillers take the edge off when asked to count them.
/obj/item/bodypart/proc/rogue_get_shock(painkillers = FALSE, datum/rogue_physiology_numbers/numbers = rogue_physiology())
	if(!rogue_can_feel_pain())
		return 0
	var/multiplier = 1
	if(grasped_by || LAZYLEN(rogue_grips))
		multiplier *= numbers.pain_grab_factor
	var/pain = rogue_pain_dam
	if(LAZYLEN(rogue_injuries))
		pain += rogue_injury_pain()
	for(var/datum/wound/wound as anything in wounds)
		pain += wound.rogue_pain()
	for(var/obj/item/lodged as anything in embedded_objects)
		var/datum/embedding/embed = lodged.get_embed()
		if(embed)
			pain += embed.pain_mult * lodged.w_class * numbers.pain_embedded_factor
	// Hurt organs under the part (combat/organ_hits.dm, Vibelin organ.get_shock()).
	pain += rogue_organ_pain()
	if(painkillers)
		pain -= owner.rogue_get_chem_effect(ROGUE_CE_PAINKILLER) / numbers.pain_painkiller_divisor
	return clamp(FLOOR(pain * multiplier, DAMAGE_PRECISION), 0, rogue_max_pain(numbers))

/// Vibelin on_life(): pain eases by itself, three times faster lying down; not under a tourniquet (combat/splints.dm).
/obj/item/bodypart/proc/rogue_pain_decay(seconds_per_tick, datum/rogue_physiology_numbers/numbers)
	if(rogue_pain_dam <= 0 || rogue_tourniqueted())
		return
	var/amount = numbers.pain_heal_per_second * seconds_per_tick
	if(owner?.body_position == LYING_DOWN)
		amount *= numbers.pain_heal_rest_factor
	rogue_remove_pain(amount, update_shock = FALSE)

/// Whether this part has anything for the Life tick to do (Vibelin consider_processing()): pain, injuries, germs, crits or
/// wounds, a bandage, a splint or a tourniquet, bleeding. A part with none is skipped, which most parts of most bodies are.
/obj/item/bodypart/proc/rogue_needs_life()
	return rogue_pain_dam > 0 || LAZYLEN(rogue_injuries) || rogue_germ_level > 0 || LAZYLEN(wounds) || rogue_bandage || LAZYLEN(applied_items) || cached_bleed_rate > 0

/// Whether the part has anything that hurts it, so that the count of the shock may skip it.
/obj/item/bodypart/proc/rogue_may_hurt()
	return rogue_pain_dam > 0 || LAZYLEN(rogue_injuries) || LAZYLEN(wounds) || LAZYLEN(embedded_objects)

// --- Pain of the body.

/// Whether the body feels pain at all (Vibelin can_feel_pain()).
/mob/living/carbon/proc/rogue_feels_pain()
	return !HAS_TRAIT(src, TRAIT_NOPAIN) && !HAS_TRAIT(src, TRAIT_ANALGESIA)

/// Vibelin getShock() and update_shock(): each part's share of what it can hurt, at most a little past full, the worst
/// first and each next one weighed less, against as many parts as a whole body has (so a lost limb does not lower the
/// count), on the scale of the shock stages; painkillers count. Miracles that make wounds hurt more multiply it.
/mob/living/carbon/proc/rogue_update_shock(datum/rogue_physiology_numbers/numbers = rogue_physiology())
	. = 0
	if(rogue_feels_pain())
		var/list/fractions = list()
		for(var/obj/item/bodypart/limb as anything in bodyparts)
			if(!limb.rogue_may_hurt())
				limb.rogue_last_shock = 0
				fractions += 0
				continue
			var/most = limb.rogue_max_pain(numbers)
			if(!most)
				continue
			var/shock = limb.rogue_get_shock(TRUE, numbers)
			limb.rogue_last_shock = shock
			fractions += clamp(shock / (most * numbers.shock_limb_full_share), 0, numbers.shock_limb_overshoot)
		sortTim(fractions, GLOBAL_PROC_REF(cmp_numeric_dsc))
		var/weighted = 0
		var/most_weighted = 0
		var/weight = 1
		var/decay = (length(fractions) && fractions[1] > 0) ? numbers.shock_stack_decay : numbers.shock_useless_decay
		for(var/fraction in fractions)
			weighted += fraction * weight
			most_weighted += weight
			weight *= decay
		for(var/i in length(fractions) + 1 to numbers.shock_stack_limbs)
			most_weighted += weight
			weight *= numbers.shock_stack_decay
		if(most_weighted)
			. = weighted / most_weighted * numbers.shock_stage_8
		if(ishuman(src))
			var/mob/living/carbon/human/human_self = src
			. *= human_self.rogue_pain_mult
	rogue_traumatic_shock = max(., 0)
	return rogue_traumatic_shock

/// The pain of the body as one number: its traumatic shock, counted anew (miracles and tests read it).
/mob/living/carbon/proc/rogue_complex_pain()
	return rogue_update_shock()

/// The pain the heart shows, in percent of the last shock stage; 0 off medieval maps and for bodies that do not count pain.
/mob/living/proc/rogue_heart_pain()
	return 0

/mob/living/carbon/rogue_heart_pain()
	if(!rogue_combat_enabled() || !rogue_feels_pain())
		return 0
	return rogue_shock_stage / rogue_physiology().shock_stage_8 * 100

/// Vibelin custom_pain(): a pain felt with a message, which adds to the part named (or the chest) unless told not to;
/// painkillers dull it, a weak one is not told, and the messages, the cries and the pains themselves have their pauses.
/mob/living/carbon/proc/rogue_custom_pain(message, power, forced = FALSE, obj/item/bodypart/limb, nopainloss = FALSE)
	if(stat != STABLE || HAS_TRAIT(src, TRAIT_KNOCKEDOUT) || !rogue_feels_pain() || world.time < rogue_next_pain)
		return FALSE
	if(limb && !limb.rogue_can_feel_pain())
		return FALSE
	var/datum/rogue_physiology_numbers/numbers = rogue_physiology()
	if(!nopainloss && power > 0)
		var/obj/item/bodypart/hurt = limb || get_bodypart(BODY_ZONE_CHEST)
		hurt?.rogue_add_pain(CEILING(power, 1))
	power -= rogue_get_chem_effect(ROGUE_CE_PAINKILLER) / numbers.pain_painkiller_divisor
	if(power < rogue_value("pain_emote_minimum"))
		return FALSE
	if(world.time >= rogue_next_pain_message)
		to_chat(src, span_userdanger("[message]"))
		rogue_next_pain_message = world.time + rogue_value("pain_message_cooldown") + power
	if(world.time >= rogue_next_pain_emote && prob(power))
		INVOKE_ASYNC(src, TYPE_PROC_REF(/mob, emote), rogue_pain_emote(power))
		rogue_next_pain_emote = world.time + rogue_value("pain_emote_cooldown") + power
	rogue_next_pain = world.time + rand(rogue_value("pain_next_min"), rogue_value("pain_next_max")) + power
	return TRUE

/// The cry of a pain of this power (Vibelin get_pain_emote()), in the voice of the body's race (rockhill/races.dm).
/mob/living/carbon/proc/rogue_pain_emote(power)
	if(power >= rogue_value("pain_emote_scream"))
		return "painscream"
	if(power >= rogue_value("pain_emote_cry"))
		return "pain"
	return "painmoan"

/// Vibelin update_shock_penalty(): a sharp pain takes perception, intelligence and speed for a while; the bigger of the
/// old and the new penalty holds, and the time starts over.
/mob/living/carbon/proc/rogue_apply_shock_penalty(amount)
	if(amount <= 0)
		return
	rogue_shock_penalty = max(amount, rogue_shock_penalty)
	attributes?.set_variable_attribute_modifier("rogue_shock_penalty", list(ROGUE_STAT_PERCEPTION = -rogue_shock_penalty, ROGUE_STAT_INTELLIGENCE = -rogue_shock_penalty, ROGUE_STAT_SPEED = -rogue_shock_penalty))
	addtimer(CALLBACK(src, PROC_REF(rogue_remove_shock_penalty)), rogue_value("shock_penalty_duration"), TIMER_UNIQUE|TIMER_OVERRIDE)

/mob/living/carbon/proc/rogue_remove_shock_penalty()
	attributes?.remove_attribute_modifier("rogue_shock_penalty")
	rogue_shock_penalty = 0

/// Vibelin endorphinate(): the body numbs its own pain (the status rogue_adrenaline), no oftener than its pause allows
/// (shorter for the Psydonian grit), unless forced.
/mob/living/carbon/proc/rogue_endorphinate(forced = FALSE, duration)
	if(!forced && world.time < rogue_next_endorphin)
		return
	var/pause = rogue_value("endorphin_cooldown")
	if(HAS_TRAIT(src, TRAIT_PSYDONIAN_GRIT))
		pause *= rogue_value("endorphin_grit_cooldown_factor")
	rogue_next_endorphin = world.time + pause
	apply_status_effect(/datum/status_effect/rogue_adrenaline, duration)

/// How long the body's own endorphins last: longer for the strong-willed (Vibelin: as much endorphin as endurance, within bounds).
/mob/living/proc/rogue_endorphin_duration()
	return clamp(rogue_stat(ROGUE_STAT_WILLPOWER), rogue_value("endorphin_min_willpower"), rogue_value("endorphin_max_willpower")) * rogue_value("endorphin_time_per_willpower")

/// Vibelin handle_shock(): the worst-hurting part (now and then another hurt one) tells of its pain; past the penalty mark
/// the pain takes perception, intelligence and speed now and then.
/mob/living/carbon/proc/rogue_handle_shock(seconds_per_tick, datum/rogue_physiology_numbers/numbers)
	if(!rogue_feels_pain() || stat != STABLE || HAS_TRAIT(src, TRAIT_KNOCKEDOUT))
		return
	var/willpower = max(rogue_stat(ROGUE_STAT_WILLPOWER), 1)
	var/most = 0
	var/obj/item/bodypart/worst
	for(var/obj/item/bodypart/limb as anything in bodyparts)
		var/shock = limb.rogue_last_shock
		if(shock > 0 && shock >= most && (most <= 0 || prob(numbers.pain_limb_pick_chance)))
			worst = limb
			most = shock
	if(worst)
		var/burning = worst.burn_dam > worst.brute_dam
		var/message
		var/chance = numbers.pain_limb_message_chance
		if(most >= numbers.pain_limb_terrible)
			chance = numbers.pain_limb_message_chance_bad
			message = "[pick("WHAT A PAIN!", "OH THE PAIN!!", "I SUFFER!")] My [worst.plaintext_zone] [burning ? "is on fire" : "is hurting terribly"]!"
		else if(most >= numbers.pain_limb_bad)
			chance = numbers.pain_limb_message_chance_bad
			message = "My [worst.plaintext_zone] [burning ? "burns" : "hurts"] badly!"
		else
			message = "My [worst.plaintext_zone] [burning ? "burns" : "hurts"]."
		if(SPT_PROB(chance, seconds_per_tick))
			rogue_custom_pain(message, most, TRUE, worst, TRUE)
	if(rogue_traumatic_shock < numbers.shock_penalty_pain)
		return
	var/penalty = min(numbers.shock_penalty_cap, FLOOR(rogue_traumatic_shock / (willpower * numbers.shock_penalty_divisor), 1))
	if(!penalty)
		return
	var/penalty_chance = CEILING(min(numbers.shock_penalty_chance_cap, rogue_traumatic_shock / (numbers.shock_penalty_chance_divisor * (willpower / ROGUE_ATTRIBUTE_MIDDLING))), 1)
	if(SPT_PROB(penalty_chance, seconds_per_tick))
		rogue_apply_shock_penalty(penalty)

/// Vibelin handle_shock_stage(): the stage climbs toward the traumatic shock and falls back slower, at a pace set by
/// willpower; a stopped heart throws it to the fourth stage. Past the second it slows; each stage once and then now and
/// then: a sting, heavy eyes and a stutter, distraction, held still, knocked down, a black-out, a stun, the collapse. The
/// body answers with its own endorphins. The enduring are not felled by it.
/mob/living/carbon/proc/rogue_handle_shock_stage(seconds_per_tick, datum/rogue_physiology_numbers/numbers)
	if(!rogue_feels_pain())
		rogue_shock_stage = 0
		rogue_shock_highest = 0
		remove_movespeed_modifier(/datum/movespeed_modifier/rogue_shock)
		remove_movespeed_modifier(/datum/movespeed_modifier/rogue_cardiac_arrest)
		rogue_update_shock_hud(numbers)
		return
	var/previous = rogue_shock_stage
	var/willpower = max(rogue_stat(ROGUE_STAT_WILLPOWER), 1)
	var/pace = seconds_per_tick * numbers.shock_speed
	if(rogue_shock_stage < rogue_shock_highest - numbers.shock_hysteresis)
		rogue_shock_highest = max(rogue_shock_stage, 0)
	var/arrest = undergoing_cardiac_arrest()
	if(arrest)
		rogue_shock_stage = max(rogue_shock_stage, numbers.shock_stage_4)
		add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/rogue_cardiac_arrest, multiplicative_slowdown = numbers.shock_arrest_slowdown)
	else
		remove_movespeed_modifier(/datum/movespeed_modifier/rogue_cardiac_arrest)
	if(rogue_traumatic_shock > numbers.shock_growth_share * rogue_shock_stage)
		rogue_shock_stage += pace * (ROGUE_ATTRIBUTE_MIDDLING / willpower)
	if(!arrest)
		var/difference = rogue_traumatic_shock - rogue_shock_stage
		if(difference > 0)
			rogue_shock_stage += min(difference, pace * (ROGUE_ATTRIBUTE_MIDDLING / willpower))
		else if(difference < 0)
			rogue_shock_stage += max(difference, -pace * (willpower / ROGUE_ATTRIBUTE_MIDDLING) * numbers.shock_recovery)
	rogue_shock_stage = clamp(rogue_shock_stage, 0, numbers.shock_stage_8)
	rogue_update_shock_hud(numbers)
	if(rogue_shock_stage >= numbers.shock_stage_2 * (willpower / ROGUE_ATTRIBUTE_MIDDLING))
		add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/rogue_shock, multiplicative_slowdown = numbers.shock_slowdown)
	else
		remove_movespeed_modifier(/datum/movespeed_modifier/rogue_shock)
	if(stat != STABLE || HAS_TRAIT(src, TRAIT_KNOCKEDOUT) || rogue_shock_stage <= 0)
		return
	var/stage = rogue_shock_stage
	var/enduring = HAS_TRAIT(src, TRAIT_NOPAINSTUN)
	if(stage >= numbers.shock_stage_1 && rogue_shock_highest < numbers.shock_stage_1)
		rogue_shock_highest = numbers.shock_stage_1
		rogue_custom_pain("The pain stings a little!", numbers.shock_stage1_pain, nopainloss = TRUE)
	if(stage >= numbers.shock_stage_2 && rogue_shock_highest < numbers.shock_stage_2)
		rogue_shock_highest = numbers.shock_stage_2
		INVOKE_ASYNC(src, TYPE_PROC_REF(/mob, emote), "me", EMOTE_VISIBLE, "is having trouble keeping [p_their()] eyes open.")
	if(stage >= numbers.shock_stage_2 && previous >= numbers.shock_stage_2 && SPT_PROB(numbers.shock_stutter_chance, seconds_per_tick))
		set_stutter_if_lower(numbers.shock_stutter)
	if(stage >= numbers.shock_stage_3 && rogue_shock_highest < numbers.shock_stage_3)
		rogue_shock_highest = numbers.shock_stage_3
		rogue_custom_pain("The pain is starting to distract me!", numbers.shock_stage3_pain, nopainloss = TRUE)
	// The fourth stage is Vibelin's "soft crit".
	if(stage >= numbers.shock_stage_4 && rogue_shock_highest < numbers.shock_stage_4)
		rogue_shock_highest = numbers.shock_stage_4
		if(!enduring)
			Immobilize(numbers.shock_stage4_hold)
	if(stage >= numbers.shock_stage_4 && previous >= numbers.shock_stage_4 && SPT_PROB(numbers.shock_stage4_chance, seconds_per_tick))
		rogue_custom_pain("[pick("The pain is excruciating", "Please, just end the pain", "My whole body is going numb")]!", stage, nopainloss = TRUE)
		if(!enduring)
			Knockdown(numbers.shock_stage4_knockdown)
		rogue_endorphinate()
	if(stage >= numbers.shock_stage_5 && previous >= numbers.shock_stage_5)
		if(SPT_PROB(numbers.shock_stage5_chance, seconds_per_tick))
			rogue_custom_pain("[pick("The pain is excruciating", "Please, just end the pain", "My whole body is going numb")]!", stage, nopainloss = TRUE)
			if(!enduring)
				Knockdown(numbers.shock_stage5_knockdown)
			rogue_endorphinate()
		if(SPT_PROB(numbers.shock_stage5_gasp_chance, seconds_per_tick))
			INVOKE_ASYNC(src, TYPE_PROC_REF(/mob, emote), "gasp")
	if(stage >= numbers.shock_stage_6 && previous >= numbers.shock_stage_6 && SPT_PROB(numbers.shock_stage6_chance, seconds_per_tick))
		if(!IsUnconscious())
			rogue_custom_pain("[pick("I black out", "I feel like I could die at any moment now", "I'm about to lose consciousness")]!", stage, nopainloss = TRUE)
			if(!enduring)
				Unconscious(numbers.shock_stage6_unconscious)
		rogue_endorphinate()
	// The seventh stage is Vibelin's "hard crit".
	if(stage >= numbers.shock_stage_7 && rogue_shock_highest < numbers.shock_stage_7)
		rogue_shock_highest = numbers.shock_stage_7
		if(!IsUnconscious())
			rogue_custom_pain("[pick("I feel like I could die at any moment now", "I'm about to lose consciousness")]!", stage, nopainloss = TRUE)
		if(!enduring)
			INVOKE_ASYNC(src, TYPE_PROC_REF(/mob, emote), "agony")
			Stun(numbers.shock_stage7_stun)
	if(stage >= numbers.shock_stage_7 && previous >= numbers.shock_stage_7)
		if(!enduring)
			Knockdown(numbers.shock_stage7_knockdown)
		if(SPT_PROB(numbers.shock_stage7_chance, seconds_per_tick))
			if(!enduring)
				Unconscious(numbers.shock_stage7_unconscious)
			rogue_endorphinate(TRUE)
	if(stage >= numbers.shock_stage_8 && rogue_shock_highest < numbers.shock_stage_8)
		rogue_shock_highest = numbers.shock_stage_8
		if(!IsUnconscious())
			visible_message(span_bolddanger("[src] scrunches [p_their()] body and collapses!"), ignored_mobs = src)
			rogue_custom_pain("OH LORD! The PAIN!", numbers.shock_stage8_pain, nopainloss = TRUE)
		if(!enduring)
			Unconscious(numbers.shock_stage8_unconscious)
		rogue_endorphinate(TRUE)
	else if(stage >= numbers.shock_stage_8 && previous >= numbers.shock_stage_8)
		if(!enduring)
			Unconscious(numbers.shock_stage8_hold_unconscious)
		rogue_endorphinate(TRUE)

/// The heart of the HUD is redrawn when the stage crosses a fifth of the last stage (its steps of pain).
/mob/living/carbon/proc/rogue_update_shock_hud(datum/rogue_physiology_numbers/numbers)
	var/step = round(rogue_shock_stage / numbers.shock_stage_8 * 5)
	if(step == rogue_shock_hud_step)
		return
	rogue_shock_hud_step = step
	rogue_pain_hud_dirty = TRUE

// --- Reactions of a human.

/// Ratwood's paincrit(): the pain breaks one. A scream (Azure Peak's painscream) and a moment held, then the stun and the
/// fall. Left for the loss of a limb (rogue_delimb_pain()); the shock stages do the rest.
/mob/living/carbon/human/proc/rogue_paincrit()
	Immobilize(rogue_value("paincrit_hold"))
	emote("painscream", forced = TRUE)
	adjust_stutter(rogue_value("pain_stutter"))
	addtimer(CALLBACK(src, PROC_REF(Stun), rogue_value("paincrit_stun")), rogue_value("paincrit_delay"))
	addtimer(CALLBACK(src, PROC_REF(Knockdown), rogue_value("paincrit_stun")), rogue_value("paincrit_delay"))

/// Ratwood's delimb_pain(): losing a limb breaks one, unless constitution and will hold (get_delimb_survival_chance());
/// who holds screams and fights on, the willful on their own endorphins, the faithful of Psydon with a roar.
/mob/living/carbon/human/proc/rogue_delimb_pain()
	if(!client || stat || HAS_TRAIT(src, TRAIT_KNOCKEDOUT) || !rogue_feels_pain() || HAS_TRAIT(src, TRAIT_NUMBED_LIMBS))
		return
	var/grit = HAS_TRAIT(src, TRAIT_PSYDONIAN_GRIT)
	var/chance = (rogue_stat(ROGUE_STAT_CONSTITUTION) + rogue_stat(ROGUE_STAT_WILLPOWER) - ROGUE_DELIMB_SURVIVE_BASE) * ROGUE_DELIMB_SURVIVE_SHARE
	if(grit)
		chance += ROGUE_DELIMB_GRIT_BONUS
	if(!HAS_TRAIT(src, TRAIT_NOPAINSTUN) && !prob(max(chance, 0)))
		rogue_paincrit()
		return
	if(grit)
		var/static/list/his_will = list(
			"THROUGH HIM, I ENDURE!!",
			"THE BELLS TOLL MY NAME, BUT I CAN STILL FIGHT!!",
			"ENDURE!!",
			"IF I AM TO FALL, THEN THEY SHALL FALL WITH ME!!",
		)
		emote("rage", forced = TRUE)
		visible_message(span_danger("[src] ROARS through the pain, teeth bared in defiant fury!"), span_userdanger(pick(his_will)))
		rogue_endorphinate(TRUE, rogue_endorphin_duration() + rogue_value("adrenaline_grit_bonus"))
		return
	emote("painscream", forced = TRUE)
	visible_message(span_danger("[src] staggers back from the shock, but holds fast with fire in [p_their()] eyes!"), span_danger("I can still fight!"))
	if(rogue_stat(ROGUE_STAT_WILLPOWER) >= ROGUE_DELIMB_ADRENALINE_WILLPOWER)
		rogue_endorphinate(TRUE)

/// A hit on a part (Vibelin receive_damage()): it hurts by the damage, a bruise less than a burn of the same, less what
/// painkillers dull; a sharp hurt may draw a scream and takes perception, intelligence and speed for a moment. Then Azure
/// Peak and Ratwood: a heavy blow wakes the sleeper, holds the struck and shakes their sight, a hit past ten slows them.
/mob/living/carbon/human/proc/rogue_pain_react(damage, damagetype, def_zone)
	if(stat == DEAD || !rogue_feels_pain() || (damagetype != BRUTE && damagetype != BURN))
		return
	var/datum/rogue_physiology_numbers/numbers = rogue_physiology()
	var/obj/item/bodypart/limb = isbodypart(def_zone) ? def_zone : get_bodypart(check_zone(def_zone))
	var/pain = damage * (damagetype == BRUTE ? rogue_value("pain_damage_brute") : rogue_value("pain_damage_burn"))
	pain -= rogue_get_chem_effect(ROGUE_CE_PAINKILLER) / numbers.pain_painkiller_divisor
	if(limb && pain > 0 && limb.rogue_add_pain(pain))
		if(prob(pain * rogue_value("pain_scream_share")))
			emote(rogue_pain_emote(pain))
		var/penalty = min(numbers.shock_penalty_cap, FLOOR(pain / max(rogue_stat(ROGUE_STAT_WILLPOWER), 1), 1))
		if(penalty)
			rogue_apply_shock_penalty(penalty)
	if(damagetype != BRUTE)
		return
	var/constitution = rogue_stat(ROGUE_STAT_CONSTITUTION)
	if(damage > rogue_value("pain_cry_damage"))
		AdjustSleeping(-rogue_value("pain_wake"))
	if(HAS_TRAIT(src, TRAIT_NOPAINSTUN))
		return
	if(damage > constitution * rogue_value("pain_hold_con_factor"))
		Immobilize(rogue_value("pain_hold"))
		shake_camera(src, 2, 2)
		adjust_stutter(rogue_value("pain_stutter"))
	// Azure Peak apply_slowdown(): the slowdown of a hit lasts longer the harder it is, within bounds.
	if(damage > rogue_value("pain_slow_damage") && !HAS_TRAIT(src, TRAIT_IGNOREDAMAGESLOWDOWN))
		rogue_slow_for(clamp(damage * rogue_value("pain_slow_per_damage"), rogue_value("pain_slow_min_time"), rogue_value("pain_slow_max_time")))
		shake_camera(src, 1, 1)

/// The pain of a medieval body: the reaction to hits, and the heart of the HUD redrawn when pain changes; the tick of pain
/// and shock is the blood element's (combat/blood.dm), in the order of the block's contract.
/datum/element/rogue_pain

/datum/element/rogue_pain/Attach(datum/target)
	. = ..()
	if(!ishuman(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_LIVING_LIFE, PROC_REF(on_life))
	RegisterSignal(target, COMSIG_MOB_AFTER_APPLY_DAMAGE, PROC_REF(on_damage))
	RegisterSignals(target, list(SIGNAL_ADDTRAIT(TRAIT_ADRENALINE_RUSH), SIGNAL_REMOVETRAIT(TRAIT_ADRENALINE_RUSH), SIGNAL_ADDTRAIT(TRAIT_NOPAIN), SIGNAL_REMOVETRAIT(TRAIT_NOPAIN), COMSIG_ROGUE_ATTRIBUTES_UPDATED), PROC_REF(on_threshold_changed))

/datum/element/rogue_pain/Detach(datum/source, ...)
	UnregisterSignal(source, list(COMSIG_LIVING_LIFE, COMSIG_MOB_AFTER_APPLY_DAMAGE, SIGNAL_ADDTRAIT(TRAIT_ADRENALINE_RUSH), SIGNAL_REMOVETRAIT(TRAIT_ADRENALINE_RUSH), SIGNAL_ADDTRAIT(TRAIT_NOPAIN), SIGNAL_REMOVETRAIT(TRAIT_NOPAIN), COMSIG_ROGUE_ATTRIBUTES_UPDATED))
	return ..()

/// Endorphins, painlessness or willpower changed: the heart shows the pain at once.
/datum/element/rogue_pain/proc/on_threshold_changed(mob/living/carbon/human/source)
	SIGNAL_HANDLER
	source.update_health_hud()

/datum/element/rogue_pain/proc/on_life(mob/living/carbon/human/source, seconds_per_tick)
	SIGNAL_HANDLER
	if(source.rogue_pain_hud_dirty)
		source.rogue_pain_hud_dirty = FALSE
		source.update_health_hud()

/datum/element/rogue_pain/proc/on_damage(mob/living/carbon/human/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	if(damage > 0)
		INVOKE_ASYNC(source, TYPE_PROC_REF(/mob/living/carbon/human, rogue_pain_react), damage, damagetype, def_zone)

/// The body's own endorphins (Vibelin endorphinate() and its reagent): for a while pain is dulled by a painkiller, as the
/// rush of Ratwood was. Its name stays rogue_adrenaline: miracles give it (faith/miracles/graggar.dm).
/datum/status_effect/rogue_adrenaline
	id = "rogue_adrenaline"
	status_type = STATUS_EFFECT_REFRESH
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = /atom/movable/screen/alert/status_effect/rogue_adrenaline

/datum/status_effect/rogue_adrenaline/on_creation(mob/living/new_owner, set_duration)
	duration = set_duration || new_owner.rogue_endorphin_duration()
	return ..()

/datum/status_effect/rogue_adrenaline/refresh(effect, set_duration)
	duration = max(duration, set_duration || owner.rogue_endorphin_duration())

/datum/status_effect/rogue_adrenaline/on_apply()
	ADD_TRAIT(owner, TRAIT_ADRENALINE_RUSH, TRAIT_STATUS_EFFECT(id))
	owner.rogue_add_chem_effect(ROGUE_CE_PAINKILLER, rogue_value("endorphin_painkiller"), id)
	owner.playsound_local(get_turf(owner), 'modular_redtard/rockhill/sound/misc/adrenaline_rush.ogg', 100, TRUE)
	return TRUE

/datum/status_effect/rogue_adrenaline/on_remove()
	REMOVE_TRAIT(owner, TRAIT_ADRENALINE_RUSH, TRAIT_STATUS_EFFECT(id))
	owner.rogue_remove_chem_effect(ROGUE_CE_PAINKILLER, id)
	return ..()

/atom/movable/screen/alert/status_effect/rogue_adrenaline
	name = "Adrenaline Rush"
	desc = "The gambit worked! I can do anything! My heart races, the throb of my wounds wavers."
	icon = ROGUE_COMBAT_ALERTS_ICON
	icon_state = "adrrush"
