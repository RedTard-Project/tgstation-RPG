/// Vibelin's heart (organ_processing/heart.dm, carbon/blood.dm) on medieval maps, on TG's own heart organ: the pulse, in
/// steps from none to thready, quickens when too little blood reaches the body and with stimulants, is calmed by
/// stabilisers, and a racing heart wears itself; the blood that reaches the body (circulation) is the blood there is, as
/// much as a hurt heart and the pulse pump of it, and what of it carries air (oxygenation) is less for a choking body and
/// more with oxygenating drinks. A heart stops as TG has it (a failing heart, cardiac arrest); a stopped heart has no pulse
/// and pumps almost nothing. The bleeding follows the pulse (combat/blood.dm), and too little blood reaching the body chokes
/// it (combat/blood.dm rogue_blood_loss_effects()), which Roguetown's crit turns into unconsciousness and death.
/// The Vibelin brain that dies of it is not taken (combat/crit.dm stays).

/mob/living/carbon
	/// Vibelin pulse: ROGUE_PULSE_NONE to ROGUE_PULSE_THREADY (combat/_medical_defines.dm), set each Life tick.
	var/rogue_pulse = ROGUE_PULSE_NORM

/// How well the heart pumps, 0 to 1 (Vibelin getorganslotefficiency(ORGAN_SLOT_HEART)): none for a stopped or missing heart.
/mob/living/carbon/proc/rogue_heart_efficiency()
	var/obj/item/organ/heart/heart = get_organ_slot(ORGAN_SLOT_HEART)
	if(!istype(heart) || !heart.is_beating() || (heart.organ_flags & ORGAN_FAILING))
		return 0
	if(!heart.maxHealth)
		return 1
	return clamp(1 - heart.damage / heart.maxHealth, 0, 1)

/// Vibelin get_blood_circulation(): the blood there is, as much as the heart pumps of it and as fast as the pulse goes; a
/// stopped heart of the living still moves a little, a dead body none. A body without a heart to need has its blood as it is.
/mob/living/carbon/proc/rogue_blood_circulation(datum/rogue_physiology_numbers/numbers = rogue_physiology())
	var/volume = get_blood_volume()
	if(HAS_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE))
		volume = max(volume, BLOOD_VOLUME_NORMAL)
	if(!needs_heart())
		return volume
	var/factor = 1
	if(!HAS_TRAIT(src, TRAIT_FAKEDEATH))
		switch(rogue_pulse)
			if(ROGUE_PULSE_NONE)
				factor = stat == DEAD ? 0 : numbers.circulation_pulse_none
			if(ROGUE_PULSE_SLOW)
				factor = numbers.circulation_pulse_slow
			if(ROGUE_PULSE_FAST)
				factor = numbers.circulation_pulse_fast
			if(ROGUE_PULSE_FASTER, ROGUE_PULSE_THREADY)
				factor = numbers.circulation_pulse_faster
	return volume * max(rogue_heart_efficiency(), numbers.heart_min_efficiency) * factor

/// Vibelin get_blood_oxygenation(): the circulating blood that carries air; a choking body's carries less (unless told to
/// leave the choking out), oxygenating drinks make up for it. A body that needs no breath has its circulation.
/mob/living/carbon/proc/rogue_blood_oxygenation(include_suffocation = TRUE, datum/rogue_physiology_numbers/numbers = rogue_physiology())
	if(!CAN_HAVE_BLOOD(src))
		return BLOOD_VOLUME_NORMAL
	var/volume = rogue_blood_circulation(numbers)
	if(HAS_TRAIT(src, TRAIT_NOBREATH))
		return volume
	var/factor = include_suffocation ? max(0, 1 - get_oxy_loss() / max(maxHealth, 1)) : 1
	var/oxygenated = rogue_get_chem_effect(ROGUE_CE_OXYGENATED)
	if(oxygenated >= numbers.oxygenated_strong_power)
		factor += numbers.oxygenated_strong
	else if(oxygenated > 0)
		factor += numbers.oxygenated_weak
	return volume * factor

/// Vibelin handle_pulse(): the pulse starts from the stimulants (none under a stabiliser), quickens a step for too little
/// air in the blood and another for far too little; a pretended death shows almost none; thready when the blood is nearly
/// gone; a stabiliser pulls it back toward normal. Too many stimulants and a racing pulse hurt the heart.
/mob/living/carbon/proc/rogue_update_pulse(seconds_per_tick, datum/rogue_physiology_numbers/numbers = rogue_physiology())
	if(!needs_heart())
		rogue_pulse = ROGUE_PULSE_NORM
		return
	if(stat == DEAD || !rogue_heart_efficiency())
		rogue_pulse = ROGUE_PULSE_NONE
		return
	var/stable = rogue_get_chem_effect(ROGUE_CE_STABLE) > 0
	var/pulse_mod = stable ? 0 : rogue_get_chem_effect(ROGUE_CE_PULSE)
	if(!stable && pulse_mod > numbers.pulse_chem_safe && SPT_PROB(((pulse_mod - numbers.pulse_chem_safe) ** 2) * numbers.pulse_chem_damage_share, seconds_per_tick))
		adjust_organ_loss(ORGAN_SLOT_HEART, numbers.heart_pulse_damage)
	var/oxygenation = rogue_blood_oxygenation(TRUE, numbers)
	if(oxygenation < numbers.blood_okay)
		pulse_mod++
	if(oxygenation < numbers.blood_bad)
		pulse_mod++
	if(HAS_TRAIT(src, TRAIT_FAKEDEATH))
		rogue_pulse = clamp(round(ROGUE_PULSE_NONE + pulse_mod), ROGUE_PULSE_NONE, ROGUE_PULSE_FASTER)
		return
	rogue_pulse = clamp(round(ROGUE_PULSE_NORM + pulse_mod), ROGUE_PULSE_SLOW, pulse_mod < ROGUE_PULSE_THREADY ? ROGUE_PULSE_FASTER : ROGUE_PULSE_THREADY)
	if(oxygenation <= numbers.blood_survive)
		rogue_pulse = ROGUE_PULSE_THREADY
	if(stable && rogue_pulse != ROGUE_PULSE_NORM)
		rogue_pulse += rogue_pulse > ROGUE_PULSE_NORM ? -1 : 1
	if(rogue_pulse >= ROGUE_PULSE_THREADY)
		if(SPT_PROB(numbers.pulse_thready_damage_chance, seconds_per_tick))
			adjust_organ_loss(ORGAN_SLOT_HEART, numbers.heart_pulse_damage)
	else if(rogue_pulse >= ROGUE_PULSE_FASTER && SPT_PROB(numbers.pulse_faster_damage_chance, seconds_per_tick))
		adjust_organ_loss(ORGAN_SLOT_HEART, numbers.heart_pulse_damage)
