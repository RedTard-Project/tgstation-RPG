/// D2 (owner, 2026-11-22): Roguetown's unconsciousness and death in place of TG's soft and hard crit, on medieval maps and
/// in the low-memory launch (Azure Peak carbon updatehealth() and update_stat()):
/// - health is the maximum less the worse of suffocation and toxins; cuts, bruises and burns hurt the parts (up to their
///   maximum), bleed and give pain, but no longer lower health as TG's sum over the parts does;
/// - there is no soft crit; the body falls unconscious (TG's HARD_CRIT) when it has bled out, suffocates past a mark, or its
///   health is down to the mark, and the room is told why, once;
/// - it dies at the death mark of health (bleeding and choking get it there through suffocation), or as TG has it
///   otherwise: a vital organ fails, the head comes off.
/// Knock-outs and sleep stay TG's TRAIT_KNOCKEDOUT without a change of stat, as Azure Peak's IsUnconscious() and
/// IsSleeping() did with one.

#define ROGUE_CRIT_BLED_OUT "bled out"
#define ROGUE_CRIT_SUFFOCATING "suffocating"
#define ROGUE_CRIT_POISONED "poisoned"
#define ROGUE_CRIT_BEATEN "beaten down"

/proc/rogue_crit_enabled()
	return rogue_combat_enabled() || SSmapping.current_map?.rogue_lowmem

/mob/living/carbon
	/// Whether this body falls and dies as in Roguetown (rogue_enable_crit()); TG's crit otherwise.
	var/rogue_crit = FALSE
	/// Suffocation above which it falls unconscious whatever its health (crit_unconscious_oxy), read once.
	var/rogue_crit_oxy = 0
	/// Blood at or below which it falls unconscious (blood_survive), read once.
	var/rogue_crit_blood = 0

/mob/living/carbon/human/Initialize(mapload)
	. = ..()
	if(rogue_crit_enabled())
		rogue_enable_crit()

/// Switches the body to Roguetown's crit: the marks are read once here, since health is counted on every hit.
/mob/living/carbon/proc/rogue_enable_crit()
	if(rogue_crit)
		return
	rogue_crit = TRUE
	hardcrit_threshold = rogue_value("crit_unconscious_health")
	dead_threshold = rogue_value("crit_death_health")
	rogue_crit_oxy = rogue_value("crit_unconscious_oxy")
	rogue_crit_blood = ROGUE_BLOOD_SURVIVE
	AddElement(/datum/element/rogue_crit)
	updatehealth()

/// Listens for the body's breath and Life tick (an element: the body's own registrations of COMSIG_LIVING_LIFE, as
/// sneaking's, would replace and later remove one of the body's own).
/datum/element/rogue_crit

/datum/element/rogue_crit/Attach(datum/target)
	. = ..()
	if(!iscarbon(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_CARBON_PRE_BREATHE, PROC_REF(on_pre_breathe))
	RegisterSignal(target, COMSIG_LIVING_LIFE, PROC_REF(on_life))

/datum/element/rogue_crit/Detach(datum/source)
	UnregisterSignal(source, list(COMSIG_CARBON_PRE_BREATHE, COMSIG_LIVING_LIFE))
	return ..()

/datum/element/rogue_crit/proc/on_pre_breathe(mob/living/carbon/source, seconds_per_tick)
	SIGNAL_HANDLER
	source.rogue_crit_breathe()

/datum/element/rogue_crit/proc/on_life(mob/living/carbon/source, seconds_per_tick)
	SIGNAL_HANDLER
	source.rogue_crit_life()

/// Azure Peak's carbon updatehealth(): health counts only the worse of suffocation and toxins. The rest is TG's: stamina,
/// the husk of a body burnt past its chest, the medical HUD.
/mob/living/carbon/updatehealth()
	if(!rogue_crit)
		return ..()
	if(HAS_TRAIT(src, TRAIT_GODMODE))
		return
	set_health(round(maxHealth - max(get_oxy_loss(), get_tox_loss()), DAMAGE_PRECISION))
	update_stat()
	update_stamina()
	if(stat == DEAD)
		var/obj/item/bodypart/chest = get_bodypart(BODY_ZONE_CHEST)
		if(chest)
			var/total_burn = 0
			for(var/obj/item/bodypart/part as anything in get_bodyparts())
				total_burn += part.burn_dam * part.body_damage_coeff
			if(maxHealth - total_burn < -chest.max_damage)
				become_husk(BURN)
	med_hud_set_health()
	remove_movespeed_modifier(/datum/movespeed_modifier/carbon_softcrit)
	SEND_SIGNAL(src, COMSIG_LIVING_HEALTH_UPDATE)

/// Azure Peak's carbon update_stat(): death at the death mark, unconsciousness for one of rogue_crit_cause(), awake
/// otherwise; no soft crit.
/mob/living/carbon/update_stat()
	if(!rogue_crit)
		return ..()
	if(HAS_TRAIT(src, TRAIT_GODMODE))
		return
	if(stat != DEAD)
		if(health <= dead_threshold && !HAS_TRAIT(src, TRAIT_NODEATH))
			death()
			return
		var/cause = rogue_crit_cause()
		if(cause)
			if(stat != HARD_CRIT)
				rogue_crit_collapse(cause)
			set_stat(HARD_CRIT)
		else
			set_stat(STABLE)
	update_damage_hud()
	update_health_hud()
	update_stamina_hud()
	med_hud_set_status()

/// Why the body is unconscious, in Azure Peak's order, or null when it is not: it has bled out (whatever its health), it
/// suffocates past the mark (whatever its health), its health is down to the mark (poisoned when toxins outweigh both
/// brute and burn, beaten down otherwise).
/mob/living/carbon/proc/rogue_crit_cause()
	if(CAN_HAVE_BLOOD(src) && !HAS_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE) && get_blood_volume(apply_modifiers = TRUE) <= rogue_crit_blood)
		return ROGUE_CRIT_BLED_OUT
	var/oxy = get_oxy_loss()
	if(oxy > rogue_crit_oxy)
		return ROGUE_CRIT_SUFFOCATING
	if(health > hardcrit_threshold || HAS_TRAIT(src, TRAIT_NOHARDCRIT))
		return null
	var/tox = get_tox_loss()
	if(tox >= get_fire_loss() && tox >= get_brute_loss())
		return ROGUE_CRIT_POISONED
	return ROGUE_CRIT_BEATEN

/// Azure Peak's word on falling unconscious, once: to the room, to the body, and over its head.
/mob/living/carbon/proc/rogue_crit_collapse(cause)
	switch(cause)
		if(ROGUE_CRIT_BLED_OUT)
			visible_message(span_danger("<b>[src] collapses, [p_their()] skin pale as parchment!</b>"), span_userdanger("My blood... there is nothing left. I cannot feel my limbs."))
			balloon_alert_to_viewers("<font color='#bb2b2b'>bled out!</font>")
		if(ROGUE_CRIT_SUFFOCATING)
			visible_message(span_danger("<b>[src] collapses, [p_their()] lips turning blue!</b>"), span_userdanger("I cannot breathe... the world grows dark."))
			balloon_alert_to_viewers("<font color='#5b7ec4'>suffocating!</font>")
		if(ROGUE_CRIT_POISONED)
			visible_message(span_danger("<b>[src] collapses, [p_their()] body wracked with poison!</b>"), span_userdanger("The poison is too much... I cannot go on."))
			balloon_alert_to_viewers("<font color='#2b8a3e'>poisoned!</font>")
		if(ROGUE_CRIT_BEATEN)
			visible_message(span_danger("<b>[src] collapses, broken and bloodied!</b>"), span_userdanger("My bones are shattered... I cannot go on."))
			balloon_alert_to_viewers("<font color='#bb2b2b'>beaten down!</font>")

/// TG takes a breath from every body in HARD_CRIT (carbon breathe()); Azure Peak's unconscious breathe as before and get
/// their wind back. This gives the breath back first, unless a failing lung or a kill grip takes it anyway.
/mob/living/carbon/proc/rogue_crit_breathe()
	if(stat != HARD_CRIT || pulledby?.grab_state >= GRAB_KILL || get_organ_slot(ORGAN_SLOT_BREATHING_TUBE))
		return
	var/obj/item/organ/lungs/lungs = get_organ_slot(ORGAN_SLOT_LUNGS)
	if(lungs?.organ_flags & ORGAN_FAILING)
		return
	losebreath--

/// Blood and suffocation also change between hits: a Life tick fells or wakes the body when its stat no longer matches.
/mob/living/carbon/proc/rogue_crit_life()
	if(stat == DEAD)
		return
	if((stat == HARD_CRIT) != !isnull(rogue_crit_cause()))
		update_stat()

#undef ROGUE_CRIT_BLED_OUT
#undef ROGUE_CRIT_SUFFOCATING
#undef ROGUE_CRIT_POISONED
#undef ROGUE_CRIT_BEATEN
