/// Vibelin's blood (block VR1, the Vibelin base of medicine) on medieval maps, in place of TG's handle_blood(): the parts
/// bleed by their injuries and crits (combat/injuries/, combat/wounds.dm), the heart pumps it out faster or slower with its
/// pulse (combat/heart.dm), a body bled near out bleeds slower; the body makes its blood back by itself, faster with blood
/// restoring drinks; constitution, traits and yielding slow or quicken the bleeding (Ratwood, Azure Peak), and too little
/// blood reaching the body weakens it in three steps and then chokes it, which Roguetown's crit (combat/crit.dm) turns into
/// unconsciousness and death. TG's own count of a part (lodged things, TG wounds from smites, surgery) still bleeds as TG
/// has it. Vibelin's blood is counted on Vibelin's volume and scaled to TG's (blood_volume_scale).
///
/// The element rogue_blood also runs the Life tick of the body's medicine, in the order of the block's contract: injuries,
/// crits, bandages, the easing of pain, shock, pulse; TG then calls handle_blood(), which bleeds.

/mob/living/carbon/human
	/// The step of blood loss the body is at (Ratwood bleeding_tier): 0 none, 1 dizzy, 2 faint, 3 drained.
	var/rogue_bleed_tier = 0
	/// When the bled-out body rattles for breath next (Azure Peak last_gasp).
	var/rogue_next_gasp = 0

/mob/living/carbon
	/// Vibelin BLEEDOUT: too little blood reaches the body, which bleeds slower for it.
	var/rogue_bleedout = FALSE

/obj/item/bodypart
	/// What the blood tick last wrote into TG's cached_bleed_rate, and how much of it was the module's own: TG's
	/// refresh_bleed_rate() may not be overridden, so the tick adds Vibelin's bleeding to TG's count itself, for the HUD,
	/// is_bleeding() and the bleeding overlay.
	var/rogue_bleed_written = 0
	var/rogue_bleed_added = 0

// --- The fallback path: a TG wound on a medieval body (a smite, an admin) bleeds by TG's count, with Ratwood's arteries.

/datum/wound
	/// Which artery a crit opened with this cut or stab of TG: the throat's or the heart's; null for a limb's.
	var/rogue_artery
	/// The crit that opened it has had its say.
	var/rogue_artery_opened = FALSE

/// Blood per second this TG wound loses at Ratwood's rate where it bleeds harder than TG lets it: 0 if TG's count stands.
/datum/wound/proc/rogue_artery_bleed()
	return 0

/datum/wound/slash/flesh/rogue_artery_bleed()
	return rogue_artery_rate()

/datum/wound/pierce/bleed/rogue_artery_bleed()
	return rogue_artery_rate()

/// A critical cut or stab of TG is an opened artery.
/datum/wound/proc/rogue_artery_rate()
	if(severity < WOUND_SEVERITY_CRITICAL)
		return 0
	switch(rogue_artery)
		if(ROGUE_ARTERY_THROAT)
			return rogue_value("artery_bleed_neck")
		if(ROGUE_ARTERY_HEART)
			return rogue_value("artery_bleed_chest")
	return rogue_value("artery_bleed")

/// What Ratwood's counting changes in TG's for this TG wound: an opened artery bleeds harder, stitches hold blood back.
/datum/wound/proc/rogue_bleed_delta()
	var/extra = max(rogue_artery_bleed() - blood_flow, 0)
	return extra - min(rogue_stitched, blood_flow + extra)

// --- Bleeding of a part.

/// Vibelin get_bleed_multiplier(): a tourniquet, clamped vessels and one's own grasp stem the module's bleeding of the part
/// (TG's own count has TG's factors already); grips by others are combat/grab_bleed.dm's.
/obj/item/bodypart/proc/rogue_bleed_factor(datum/rogue_physiology_numbers/numbers = rogue_physiology())
	. = 1
	if(LAZYACCESS(applied_items, LIMB_ITEM_TOURNIQUET))
		. *= numbers.bleed_tourniquet_factor
	if(grasped_by)
		. *= numbers.bleed_grasp_factor
	if(HAS_ANY_SURGERY_STATE(surgery_state, SURGERY_VESSELS_CLAMPED))
		. *= numbers.bleed_clamped_factor

/// Vibelin get_bleed_rate() of a part, a second's, on TG's volume: its injuries (a bandaged one does not bleed), and while no
/// bandage holds, its crits and a part burnt nearly through.
/obj/item/bodypart/proc/rogue_own_bleed_rate(datum/rogue_physiology_numbers/numbers = rogue_physiology())
	if(!owner || !can_bleed())
		return 0
	var/rate = LAZYLEN(rogue_injuries) ? rogue_injury_bleed() : 0
	if(!rogue_bandage || rogue_bandage_health <= 0)
		for(var/datum/wound/rogue/crit in wounds)
			rate += crit.rogue_bleed()
		if(burn_dam >= max_damage * numbers.bleed_burnt_share)
			rate += numbers.bleed_burnt_rate
	if(rate <= 0)
		return 0
	return rate * rogue_bleed_factor(numbers) * numbers.blood_volume_scale

/// TG's own count of the part (refresh_bleed_rate()), without what the blood tick added to it since TG last counted.
/obj/item/bodypart/proc/rogue_tg_bleed_rate()
	if(cached_bleed_rate == rogue_bleed_written)
		return max(cached_bleed_rate - rogue_bleed_added, 0)
	return cached_bleed_rate

/// Blood per second the part loses (the name stays: NPCs, sleep): TG's count with Ratwood's arteries and stitches on TG
/// wounds, and the module's own bleeding. With write, TG's cached_bleed_rate is set to it for the HUD and the overlay.
/obj/item/bodypart/proc/rogue_limb_bleed_rate(write = FALSE)
	var/datum/rogue_physiology_numbers/numbers = rogue_physiology()
	var/tg_rate = rogue_tg_bleed_rate()
	var/rate = tg_rate
	if(LAZYLEN(wounds))
		var/factor = rogue_bleed_factor(numbers)
		for(var/datum/wound/wound as anything in wounds)
			if(!istype(wound, /datum/wound/rogue))
				rate += wound.rogue_bleed_delta() * factor
	rate = max(rate + rogue_own_bleed_rate(numbers), 0)
	if(write)
		rogue_bleed_added = rate - tg_rate
		rogue_bleed_written = rate
		if(cached_bleed_rate != rate)
			cached_bleed_rate = rate
			update_part_wound_overlay()
	return rate

/// Blood per second, part by part (rogue_limb_bleed_rate()). With write, the parts' counts are set for the HUD.
/mob/living/carbon/proc/rogue_bleed_rate(write = FALSE)
	. = 0
	if(HAS_TRAIT(src, TRAIT_GODMODE) || !can_bleed())
		return
	for(var/obj/item/bodypart/limb as anything in bodyparts)
		if(!limb.rogue_needs_life())
			continue
		. += limb.rogue_limb_bleed_rate(write)
	. *= GET_PHYSIOLOGY(src, PHYS_COEFF_BLEED)

/// Vibelin handle_blood() of the heart: the pulse pumps the blood out faster or slower; no pulse, no bleeding; a body bled
/// near out bleeds at half the rate.
/mob/living/carbon/proc/rogue_pulse_bleed_factor(datum/rogue_physiology_numbers/numbers)
	switch(rogue_pulse)
		if(ROGUE_PULSE_NONE)
			return 0
		if(ROGUE_PULSE_SLOW)
			. = numbers.bleed_pulse_slow
		if(ROGUE_PULSE_FAST)
			. = numbers.bleed_pulse_fast
		if(ROGUE_PULSE_FASTER, ROGUE_PULSE_THREADY)
			. = numbers.bleed_pulse_faster
		else
			. = 1
	if(rogue_bleedout)
		. *= numbers.bleed_bleedout_factor

// --- The element and the Life tick.

/datum/element/rogue_blood

/datum/element/rogue_blood/Attach(datum/target)
	. = ..()
	if(!ishuman(target))
		return ELEMENT_INCOMPATIBLE
	ADD_TRAIT(target, TRAIT_ROGUE_WOUNDS, ELEMENT_TRAIT(type))
	RegisterSignal(target, COMSIG_HUMAN_ON_HANDLE_BLOOD, PROC_REF(on_handle_blood))
	RegisterSignal(target, COMSIG_CARBON_GAIN_WOUND, PROC_REF(on_gain_wound))
	RegisterSignal(target, COMSIG_CARBON_POST_LOSE_WOUND, PROC_REF(on_lose_wound))
	RegisterSignal(target, COMSIG_LIVING_LIFE, PROC_REF(on_life))

/datum/element/rogue_blood/Detach(datum/source, ...)
	REMOVE_TRAIT(source, TRAIT_ROGUE_WOUNDS, ELEMENT_TRAIT(type))
	UnregisterSignal(source, list(COMSIG_HUMAN_ON_HANDLE_BLOOD, COMSIG_CARBON_GAIN_WOUND, COMSIG_CARBON_POST_LOSE_WOUND, COMSIG_LIVING_LIFE))
	return ..()

/// A healed or replaced fracture no longer slows one (combat/crits.dm rogue_update_fracture_slowdown()).
/datum/element/rogue_blood/proc/on_lose_wound(mob/living/carbon/human/source, datum/wound/wound, obj/item/bodypart/limb)
	SIGNAL_HANDLER
	if(istype(wound, /datum/wound/blunt/bone))
		source.rogue_update_fracture_slowdown()

/datum/element/rogue_blood/proc/on_life(mob/living/carbon/human/source, seconds_per_tick)
	SIGNAL_HANDLER
	source.rogue_medicine_life(seconds_per_tick)

/datum/element/rogue_blood/proc/on_handle_blood(mob/living/carbon/human/source, seconds_per_tick)
	SIGNAL_HANDLER
	if(!CAN_HAVE_BLOOD(source))
		return NONE
	source.rogue_handle_blood(seconds_per_tick)
	return HANDLE_BLOOD_HANDLED

/// Vibelin on_bodypart_gain(): "new bleeding wounds always expire bandages" (combat/medicine.dm).
/datum/element/rogue_blood/proc/on_gain_wound(mob/living/carbon/human/source, datum/wound/wound, obj/item/bodypart/limb)
	SIGNAL_HANDLER
	if(limb?.rogue_bandage && wound.rogue_soaks_bandage())
		limb.rogue_bandage_expire()

/// The Life tick of the body's medicine, living or dead, in the order of the block's contract. The leeches on the parts
/// drink or a squeezed cheele gives (combat/leeches.dm); a part with nothing to do is skipped (rogue_needs_life()); the
/// others run their injuries, their crits, their bandage and the easing of their pain. Then, alive, the body counts its
/// shock, suffers its stage and finds its pulse; TG bleeds it after this, in handle_blood().
/mob/living/carbon/human/proc/rogue_medicine_life(seconds_per_tick)
	var/datum/rogue_physiology_numbers/numbers = rogue_physiology()
	var/alive = stat != DEAD
	var/ticks = seconds_per_tick / ROGUE_LIFE_TICK
	var/busy = FALSE
	for(var/obj/item/bodypart/limb as anything in bodyparts)
		for(var/obj/item/natural/worms/leech/leech as anything in limb.rogue_leeches)
			leech.rogue_leech_tick(src, ticks)
		if(!limb.rogue_needs_life())
			continue
		busy = TRUE
		limb.rogue_injury_life(seconds_per_tick)
		if(LAZYLEN(limb.wounds))
			for(var/datum/wound/rogue/crit in limb.wounds.Copy())
				crit.rogue_on_life(seconds_per_tick)
		limb.rogue_bandage_tick(seconds_per_tick)
		if(alive)
			limb.rogue_pain_decay(seconds_per_tick, numbers)
	if(!alive)
		return
	if(busy || rogue_traumatic_shock > 0)
		rogue_update_shock(numbers)
	if(rogue_traumatic_shock > 0 || rogue_shock_stage > 0 || undergoing_cardiac_arrest())
		rogue_handle_shock(seconds_per_tick, numbers)
		rogue_handle_shock_stage(seconds_per_tick, numbers)
	rogue_update_pulse(seconds_per_tick, numbers)

/// One Life tick of the blood: it comes back, too little of it reaching the body weakens and chokes it, too much tears an
/// artery; then the parts bleed, as fast as the pulse pumps.
/mob/living/carbon/human/proc/rogue_handle_blood(seconds_per_tick)
	var/datum/rogue_physiology_numbers/numbers = rogue_physiology()
	var/ticks = seconds_per_tick / ROGUE_LIFE_TICK
	var/changed = FALSE
	var/volume = get_blood_volume()
	if(volume > 0 && volume < BLOOD_VOLUME_NORMAL)
		// Vibelin spleen: blood restoring drinks multiply the body's own making of blood.
		var/regen = numbers.blood_regen * ticks * (1 + max(rogue_get_chem_effect(ROGUE_CE_BLOODRESTORE), 0))
		changed = !!adjust_blood_volume(regen, maximum = BLOOD_VOLUME_NORMAL)
	var/circulation = rogue_blood_circulation(numbers)
	rogue_update_bleedout(circulation, numbers)
	if(stat != DEAD)
		rogue_blood_loss_effects(ticks, numbers)
		rogue_excess_blood(circulation, seconds_per_tick, numbers)
	var/rate = rogue_bleed_rate(TRUE)
	var/amount = rate > 0 ? rogue_bleed_amount(rate * seconds_per_tick * rogue_pulse_bleed_factor(numbers), numbers) : 0
	if(amount > 0)
		bleed(amount)
		changed = TRUE
		bleed_warn(rate)
		rogue_bleed_sound(amount / ticks, numbers)
		if(volume > 0 && get_blood_volume() <= 0)
			to_chat(src, span_userdanger("The last of my lyfeblood ebbs from my ravaged body and soaks the cold earth below..."))
	// TG's handle_blood() lets the bleeding stacks of the parts run out; it does not run now.
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		if(bodypart.generic_bleedstacks)
			bodypart.adjustBleedStacks(-1, 0)
	if(changed)
		update_health_hud()

/// Vibelin BLEEDOUT: while the heart beats, too little blood reaching the body slows its bleeding; it is told once.
/mob/living/carbon/proc/rogue_update_bleedout(circulation, datum/rogue_physiology_numbers/numbers)
	if(!rogue_pulse)
		return
	if(circulation > numbers.blood_survive)
		rogue_bleedout = FALSE
		return
	if(!rogue_bleedout)
		rogue_bleedout = TRUE
		to_chat(src, span_userdanger("My organs feel outrageously heavy!"))

/// Vibelin: far too much blood pumped (an overdose of blood restoring drinks) tears an artery now and then.
/mob/living/carbon/proc/rogue_excess_blood(circulation, seconds_per_tick, datum/rogue_physiology_numbers/numbers)
	if(circulation < BLOOD_VOLUME_NORMAL * numbers.blood_excess_share || !length(bodyparts) || !SPT_PROB(numbers.blood_excess_artery_chance, seconds_per_tick))
		return
	var/obj/item/bodypart/limb = pick(bodyparts)
	if(limb.rogue_artery_torn())
		return
	to_chat(src, span_userdanger("Blood starts to tear my arteries apart!"))
	limb.rogue_add_wound(/datum/wound/rogue/artery)

/// Ratwood's bleed(): constitution slows or quickens the bleeding of a body with a mind, as thick blood, critical
/// resistance and weakness do; one who yields bleeds a quarter.
/mob/living/carbon/human/proc/rogue_bleed_amount(amount, datum/rogue_physiology_numbers/numbers = rogue_physiology())
	// Azure Peak get_bleed_mod(): thick blood and critical resistance count for every body, not only one with a mind.
	if(HAS_TRAIT(src, TRAIT_CRITICAL_RESISTANCE))
		amount *= numbers.bleed_crit_resistance
	else if(HAS_TRAIT(src, TRAIT_BLOOD_RESISTANCE))
		amount *= numbers.bleed_thick_blood
	if(mind)
		var/constitution = min(rogue_stat(ROGUE_STAT_CONSTITUTION), numbers.bleed_con_cap)
		amount -= amount * (constitution - numbers.bleed_con_base) * numbers.bleed_con_share
		if(HAS_TRAIT(src, TRAIT_CRITICAL_WEAKNESS))
			amount *= numbers.bleed_crit_weakness
	if(rogue_yielding)
		amount *= numbers.bleed_yield
	return max(amount, 0)

/// The bleeding heard, by the blood a Life tick loses (Ratwood bleed (1)-(3).ogg); not from one lying down.
/mob/living/carbon/human/proc/rogue_bleed_sound(per_tick, datum/rogue_physiology_numbers/numbers)
	if(body_position == LYING_DOWN)
		return
	var/sound
	if(per_tick > numbers.bleed_sound_high)
		sound = 'modular_redtard/rockhill/sound/misc/bleed (3).ogg'
	else if(per_tick > numbers.bleed_sound_mid)
		sound = 'modular_redtard/rockhill/sound/misc/bleed (2).ogg'
	else if(per_tick > numbers.bleed_sound_low)
		sound = 'modular_redtard/rockhill/sound/misc/bleed (1).ogg'
	if(sound)
		playsound(src, sound, 100, FALSE)

/// Ratwood's effects of blood loss by the blood left: dizzy, faint and drained, each weaker and slower; a drained body may
/// black out. The choking is Vibelin's lack of blood reaching the body (rogue_blood_oxygenation() without the choking itself,
/// so that it does not feed on its own): below the bad level it chokes, the more so near the bottom, and one with a mind is
/// left critically wounded; above it the choking heals. The pulse quickens to make up for it (combat/heart.dm).
/mob/living/carbon/human/proc/rogue_blood_loss_effects(ticks, datum/rogue_physiology_numbers/numbers = rogue_physiology())
	if(HAS_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE))
		rogue_set_bleed_tier(0)
		return
	var/volume = get_blood_volume()
	var/tier = 0
	if(volume < numbers.blood_bad)
		tier = 3
	else if(volume < numbers.blood_okay)
		tier = 2
	else if(volume < numbers.blood_safe)
		tier = 1
	rogue_set_bleed_tier(tier)
	if(tier && prob(numbers.bleed_sign_chance * ticks))
		if(tier == 1)
			to_chat(src, span_warning("I feel dizzy."))
		else
			set_eye_blur_if_lower(numbers.bleed_blur)
			to_chat(src, span_warning("I feel faint."))
	if(tier == 3 && !IsUnconscious() && prob(numbers.bleed_sign_chance * ticks))
		Unconscious(rand(numbers.bleed_faint_min, numbers.bleed_faint_max))
		to_chat(src, span_warning("I feel drained."))
	var/flow = rogue_blood_oxygenation(FALSE, numbers)
	if(flow <= numbers.blood_bad)
		// Azure Peak: one with a mind is left critically wounded; a body without one chokes faster, so the dying do not linger.
		if(mind)
			rogue_critwound()
		var/choke = flow <= numbers.blood_survive ? numbers.bleed_oxy_survive : numbers.bleed_oxy_bad
		if(!mind)
			choke *= numbers.bleed_oxy_mindless_factor
		adjust_oxy_loss(choke * ticks)
		rogue_death_rattle()
	else if(get_oxy_loss())
		adjust_oxy_loss(-numbers.bleed_oxy_heal * ticks)

/// Azure Peak's death rattle below the bad blood level: a choking gasp every few seconds; a player's also shows over them
/// to those who would notice.
/mob/living/carbon/human/proc/rogue_death_rattle()
	if(world.time < rogue_next_gasp || stat == DEAD)
		return
	rogue_next_gasp = world.time + rand(rogue_value("bleed_gasp_interval_min"), rogue_value("bleed_gasp_interval_max"))
	if(!HAS_TRAIT(src, TRAIT_NOBREATH))
		var/gasp_sound
		if(gender == MALE)
			gasp_sound = 'modular_redtard/rockhill/sound/vo/male/gen/choke.ogg'
		else if(gender == FEMALE)
			gasp_sound = pick('modular_redtard/rockhill/sound/vo/female/gen/choke (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/choke (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/choke (3).ogg')
		if(gasp_sound)
			playsound(src, gasp_sound, 50, FALSE, ignore_walls = FALSE)
	if(!mind?.key)
		return
	balloon_alert_to_viewers("[pick("gasp", "choke", "gag", "wheeze", "gurgle", "sputter")]! (dying)")
	if(prob(rogue_value("bleed_gasp_emote_chance")))
		INVOKE_ASYNC(src, TYPE_PROC_REF(/mob, emote), "me", EMOTE_VISIBLE, "struggles to breathe, deathly pale!")

/// Puts on the debuff of the step and takes off the others, only when the step changes (as Ratwood's bleeding_tier; the
/// three debuffs are Vibelin's too).
/mob/living/carbon/human/proc/rogue_set_bleed_tier(tier)
	if(tier == rogue_bleed_tier)
		return
	rogue_bleed_tier = tier
	var/static/list/steps = list(/datum/status_effect/rogue_bleeding, /datum/status_effect/rogue_bleeding/faint, /datum/status_effect/rogue_bleeding/drained)
	for(var/index in 1 to length(steps))
		if(index == tier)
			apply_status_effect(steps[index])
		else
			remove_status_effect(steps[index])

/// Ratwood's bleeding debuffs (debuff/bleeding, bleedingworse, bleedingworst), with their alerts.
/datum/status_effect/rogue_bleeding
	id = "rogue_bleeding_dizzy"
	duration = STATUS_EFFECT_PERMANENT
	tick_interval = STATUS_EFFECT_NO_TICK
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/rogue_bleeding

/// The stat changes of the step (Ratwood effectedstats).
/datum/status_effect/rogue_bleeding/proc/rogue_stats()
	return list(ROGUE_STAT_SPEED = rogue_value("bleed_dizzy_speed"))

/datum/status_effect/rogue_bleeding/on_apply()
	owner.attributes?.set_variable_attribute_modifier(id, rogue_stats())
	return TRUE

/datum/status_effect/rogue_bleeding/on_remove()
	owner.attributes?.remove_attribute_modifier(id)
	return ..()

/datum/status_effect/rogue_bleeding/faint
	id = "rogue_bleeding_faint"
	alert_type = /atom/movable/screen/alert/status_effect/rogue_bleeding/faint

/datum/status_effect/rogue_bleeding/faint/rogue_stats()
	return list(ROGUE_STAT_STRENGTH = rogue_value("bleed_faint_strength"), ROGUE_STAT_SPEED = rogue_value("bleed_faint_speed"))

/datum/status_effect/rogue_bleeding/drained
	id = "rogue_bleeding_drained"
	alert_type = /atom/movable/screen/alert/status_effect/rogue_bleeding/drained

/datum/status_effect/rogue_bleeding/drained/rogue_stats()
	return list(ROGUE_STAT_STRENGTH = rogue_value("bleed_drained_strength"), ROGUE_STAT_SPEED = rogue_value("bleed_drained_speed"))

/atom/movable/screen/alert/status_effect/rogue_bleeding
	name = "Dizzy"
	desc = "I have lost some blood. My steps are slower."
	icon = ROGUE_COMBAT_ALERTS_ICON
	icon_state = "bleed1"

/atom/movable/screen/alert/status_effect/rogue_bleeding/faint
	name = "Faint"
	desc = "I have lost much blood. I am weaker and slower."
	icon_state = "bleed2"

/atom/movable/screen/alert/status_effect/rogue_bleeding/drained
	name = "Drained"
	desc = "Too much of my blood is gone. I can hardly stand, and my breath fails me."
	icon_state = "bleed3"
