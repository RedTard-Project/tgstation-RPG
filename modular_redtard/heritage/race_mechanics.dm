/// Vibelin's mechanics of its races that this build has (tools/port_vibelin_races.py marks the races): flight on a harpy's
/// or a formikrag's wings (Vibelin's wings/flight, functional_wings.dm), the triton's bioluminescence, and the aasimar,
/// whose only age is "Immortal". The triton's breath under water is the TG traits it already has (TRAIT_NODROWN,
/// TRAIT_SWIMMER).

/// Source of the flier's traits.
#define ROGUE_FLIGHT_TRAIT "rogue_flight"

/datum/species
	/// Flies on its wings (Vibelin's wings/flight).
	var/rogue_flight = FALSE
	/// Rises a level as it takes off, when asked (can_takeoff); a formikrag's wings only keep it up.
	var/rogue_flight_takeoff = TRUE
	/// Deciseconds it stays up at most; 0 for as long as it has the strength (flight_time).
	var/rogue_flight_time = 0
	/// Glows at will (Vibelin's triton bioluminescence).
	var/rogue_bioluminescence = FALSE
	/// The years do not weaken it (Vibelin's AGE_IMMORTAL races).
	var/rogue_ageless = FALSE

/datum/species/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load, regenerate_icons = TRUE, replace_missing = TRUE)
	. = ..()
	if(rogue_flight)
		var/datum/action/innate/rogue_flight/flight = new(human_who_gained_species)
		flight.takeoff = rogue_flight_takeoff
		flight.flight_time = rogue_flight_time
		flight.Grant(human_who_gained_species)
	if(rogue_bioluminescence)
		var/datum/action/innate/rogue_bioluminescence/glow = new(human_who_gained_species)
		glow.Grant(human_who_gained_species)

/datum/species/on_species_loss(mob/living/carbon/human/human, datum/species/new_species, pref_load)
	for(var/datum/action/action as anything in LAZYCOPY(human.actions))
		if(istype(action, /datum/action/innate/rogue_flight) || istype(action, /datum/action/innate/rogue_bioluminescence))
			qdel(action)
	return ..()

/// An ageless race takes no sheet of age.
/mob/living/carbon/human/rogue_apply_age()
	if(dna?.species?.rogue_ageless)
		return
	return ..()

/// Vibelin's flight: a few seconds to take wing (right-click: and rise a level, where the wings can), then the flier
/// hovers over gaps, glides down a level over a deeper one and pays stamina for each step; worn out, laid low or
/// stuck, it drops, and a blow may knock it out of the air. Landing takes a few seconds more and hurts nothing.
/datum/action/innate/rogue_flight
	name = "Toggle Flying"
	desc = "Take to the air or land. Right-click to rise a level as you take off."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "flight"
	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_IMMOBILE | AB_CHECK_INCAPACITATED | AB_CHECK_LYING
	/// The wings can lift the flier a level.
	var/takeoff = TRUE
	/// Deciseconds the flier stays up at most, 0 for no limit.
	var/flight_time = 0
	/// The flier asked to rise as it takes off (right-click).
	var/rising = FALSE
	/// Taking wing or landing now.
	var/busy = FALSE
	/// Gliding down a level now, so the move that does it does not glide again.
	var/gliding = FALSE
	var/flight_timer

/datum/action/innate/rogue_flight/Destroy()
	stop_flying(drop = TRUE)
	return ..()

/datum/action/innate/rogue_flight/Remove(mob/removed_from)
	stop_flying(drop = TRUE)
	return ..()

/datum/action/innate/rogue_flight/Trigger(mob/clicker, trigger_flags)
	rising = !!(trigger_flags & TRIGGER_SECONDARY_ACTION)
	return ..()

/datum/action/innate/rogue_flight/Activate()
	if(busy || !can_fly(feedback = TRUE))
		return
	var/rise = takeoff && rising
	if(rise)
		to_chat(owner, span_info("I will try to fly upwards if possible."))
	busy = TRUE
	if(do_after(owner, rogue_value("flight_startup"), owner, extra_checks = CALLBACK(src, PROC_REF(can_fly))))
		start_flying(rise)
	busy = FALSE

/datum/action/innate/rogue_flight/Deactivate()
	if(busy)
		return
	busy = TRUE
	if(do_after(owner, rogue_value("flight_wind_down"), owner))
		stop_flying()
	busy = FALSE

/datum/action/innate/rogue_flight/proc/can_fly(feedback = FALSE)
	var/mob/living/carbon/human/flier = owner
	if(!istype(flier))
		return FALSE
	if(flier.stat || flier.body_position == LYING_DOWN || isnull(flier.client) || flier.incapacitated)
		if(feedback)
			flier.balloon_alert(flier, "can't spread my wings!")
		return FALSE
	if(flier.get_stamina_loss() >= rogue_value("flight_stamina_limit"))
		if(feedback)
			flier.balloon_alert(flier, "too tired!")
		return FALSE
	return TRUE

/datum/action/innate/rogue_flight/proc/start_flying(rise)
	var/mob/living/carbon/human/flier = owner
	if(active || !can_fly())
		return
	active = TRUE
	MODIFY_PHYSIOLOGY(flier, PHYS_COEFF_STUN, 2)
	flier.add_traits(list(TRAIT_MOVE_FLOATING, TRAIT_PASSTABLE), ROGUE_FLIGHT_TRAIT)
	flier.set_resting(FALSE, TRUE)
	RegisterSignal(flier, COMSIG_MOB_APPLY_DAMAGE, PROC_REF(on_damage))
	RegisterSignal(flier, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignal(flier, COMSIG_LIVING_SET_BODY_POSITION, PROC_REF(on_body_position))
	RegisterSignal(flier, SIGNAL_ADDTRAIT(TRAIT_IMMOBILIZED), PROC_REF(on_immobilized))
	RegisterSignal(flier, COMSIG_LIVING_Z_IMPACT, PROC_REF(on_z_impact))
	if(rise)
		flier.stop_pulling()
		flier.zMove(UP, z_move_flags = ZMOVE_FLIGHT_FLAGS)
	playsound(flier, 'modular_redtard/heritage/sound/wingflap.ogg', 75, FALSE)
	to_chat(flier, span_notice("I beat my wings and begin to hover..."))
	if(flight_time)
		to_chat(flier, span_userdanger("I can only stay airborne for [flight_time / 10] seconds!"))
		flight_timer = addtimer(CALLBACK(src, PROC_REF(stop_flying), TRUE), flight_time, TIMER_STOPPABLE)
	build_all_button_icons(UPDATE_BUTTON_STATUS)

/// Back on the ground: landing hurts nothing (the impact handler stays through the fall the lost lift makes), a drop is a
/// fall like any other.
/datum/action/innate/rogue_flight/proc/stop_flying(drop = FALSE)
	var/mob/living/carbon/human/flier = owner
	if(!active || !istype(flier))
		return
	active = FALSE
	deltimer(flight_timer)
	flight_timer = null
	MODIFY_PHYSIOLOGY(flier, PHYS_COEFF_STUN, 0.5)
	UnregisterSignal(flier, list(COMSIG_MOB_APPLY_DAMAGE, COMSIG_MOVABLE_MOVED, COMSIG_LIVING_SET_BODY_POSITION, SIGNAL_ADDTRAIT(TRAIT_IMMOBILIZED)))
	if(drop)
		to_chat(flier, span_userdanger("My wings give out, and I suddenly stop flying!"))
		UnregisterSignal(flier, COMSIG_LIVING_Z_IMPACT)
		flier.remove_traits(list(TRAIT_MOVE_FLOATING, TRAIT_PASSTABLE), ROGUE_FLIGHT_TRAIT)
	else
		flier.remove_traits(list(TRAIT_MOVE_FLOATING, TRAIT_PASSTABLE), ROGUE_FLIGHT_TRAIT)
		UnregisterSignal(flier, COMSIG_LIVING_Z_IMPACT)
	playsound(flier, 'modular_redtard/heritage/sound/wingflap.ogg', 75, FALSE)
	build_all_button_icons(UPDATE_BUTTON_STATUS)

/datum/action/innate/rogue_flight/proc/on_moved(mob/living/carbon/human/flier, atom/old_loc, movement_dir, forced)
	SIGNAL_HANDLER
	if(gliding)
		return
	flier.adjust_stamina_loss(rogue_value("flight_move_stamina"))
	if(flier.get_stamina_loss() >= rogue_value("flight_stamina_limit"))
		to_chat(flier, span_warning("I'm too exhausted to keep flying!"))
		stop_flying(drop = TRUE)
		return
	// Laden flight: over a drop of more than a level the flier sinks to a height its wings can bear.
	// GET_TURF_BELOW() reads its argument's vars unbracketed, so it takes a variable, not a call.
	var/turf/here = get_turf(flier)
	if(!here)
		return
	var/turf/below = GET_TURF_BELOW(here)
	if(flier.throwing || !isopenspaceturf(below))
		return
	gliding = TRUE
	if(flier.zMove(DOWN, z_move_flags = ZMOVE_CHECK_PULLS))
		to_chat(flier, span_info("I glide down to a more manageable height!"))
		playsound(flier, 'modular_redtard/heritage/sound/wingflap.ogg', 75, FALSE)
	gliding = FALSE

/datum/action/innate/rogue_flight/proc/on_damage(mob/living/carbon/human/flier, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	if((damagetype == BRUTE || damagetype == BURN) && prob(damage / rogue_value("flight_knockdown_divisor")))
		to_chat(flier, span_warning("The blow knocks me out of the air!"))
		flier.Knockdown(rogue_value("flight_knockdown_time"))

/datum/action/innate/rogue_flight/proc/on_body_position(mob/living/carbon/human/flier, new_position, old_position)
	SIGNAL_HANDLER
	if(new_position == LYING_DOWN)
		stop_flying(drop = TRUE)

/datum/action/innate/rogue_flight/proc/on_immobilized(mob/living/carbon/human/flier)
	SIGNAL_HANDLER
	stop_flying(drop = TRUE)

/datum/action/innate/rogue_flight/proc/on_z_impact(mob/living/carbon/human/flier, levels, turf/impacted_turf)
	SIGNAL_HANDLER
	return ZIMPACT_CANCEL_DAMAGE

/// Vibelin's triton bioluminescence: a deep blue glow from the body that moves with it.
/datum/action/innate/rogue_bioluminescence
	name = "Bioluminescence"
	desc = "Toggle a bright bioluminescent light from your body, moving with you."
	button_icon = 'modular_redtard/heritage/icons/actions.dmi'
	button_icon_state = "bioluminescence"
	var/obj/effect/dummy/lighting_obj/moblight/glow

/datum/action/innate/rogue_bioluminescence/Destroy()
	QDEL_NULL(glow)
	return ..()

/datum/action/innate/rogue_bioluminescence/Remove(mob/removed_from)
	QDEL_NULL(glow)
	active = FALSE
	return ..()

/datum/action/innate/rogue_bioluminescence/Activate()
	if(QDELETED(glow))
		glow = new(owner, rogue_value("bioluminescence_range"), rogue_value("bioluminescence_power"), "#66ddff")
	else
		glow.set_light_on(TRUE)
	owner.visible_message(span_notice("[owner]'s body begins to glow with a deep blue bioluminescent light!"))
	active = TRUE

/datum/action/innate/rogue_bioluminescence/Deactivate()
	glow?.set_light_on(FALSE)
	owner.visible_message(span_notice("[owner]'s bioluminescent glow fades away."))
	active = FALSE

#undef ROGUE_FLIGHT_TRAIT
