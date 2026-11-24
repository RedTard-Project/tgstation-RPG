/// Vibelin's mana overload (datums/mana/overload.dm, mana_pool.dm process()): a person holding more mana than their body
/// bears - past a share of the hard cap - loses all of it at once and pays for it: disgust by how far past it was and, far
/// enough past, wounds spread over the body and blood. The next second, with nothing held, they feel normal again. Only a
/// person overloads (Vibelin's items only mark it). Overfilling comes from what may pass the soft cap: an overfilling
/// potion, a crystal drawn by hand, an admin.

/// Vibelin mana_overload_threshold: a share of the hard cap.
/datum/rogue_mana/person/proc/overload_threshold()
	return capacity * overload_share

/datum/rogue_mana/person/proc/check_overload()
	var/threshold = overload_threshold()
	if(threshold > 0 && amount > threshold)
		// Vibelin: how many steps of the threshold it holds, less one, times the coefficient.
		overload(((amount / max(threshold * overload_step, 1)) - 1) * overload_coefficient)
	else if(overloaded)
		stop_overload()

/// Vibelin /mob/living/carbon/process_mana_overload().
/datum/rogue_mana/person/proc/overload(effect)
	var/mob/living/carbon/human/person = holder
	if(!overloaded)
		to_chat(person, span_warning("I start feeling fuzzy and tingly all around..."))
	overloaded = TRUE
	adjust(-amount)
	person.adjust_disgust(effect)
	if(effect > overload_damage_threshold)
		person.apply_damage(overload_damage * effect, BRUTE, forced = TRUE, spread_damage = TRUE)
		person.adjust_blood_volume(-round(effect * overload_blood_share, 1), minimum = BLOOD_VOLUME_BAD)
	update_processing()

/datum/rogue_mana/person/proc/stop_overload()
	overloaded = FALSE
	to_chat(holder, span_notice("I feel my body returning to normal."))
	update_processing()
