/// The healing miracles of the basket (miracle.dm): Ratwood acolyte/general.dm and pestra.dm, Azure Peak's and Twilight
/// Axis's miracle/heal, miracle/fortify and miracle/bloodmiracle.

#define ROGUE_MIRACLE_HEAL_FILTER "rogue_miracle_heal"
#define ROGUE_FORTIFY_FILTER "rogue_fortify"

/// Ratwood buff/healing (status_effects/rogue/roguebuff.dm), the aura of the lesser miracle: every second some brute, burn,
/// suffocation, toxin and brain damage mend, blood comes back up to normal and bleeding slows. Fortify makes it stronger.
/datum/status_effect/rogue_miracle_heal
	id = "rogue_miracle_heal"
	tick_interval = 1 SECONDS
	alert_type = null
	/// Healing every second (Ratwood healing_on_tick).
	var/healing = 0
	/// Bleeding (TG blood_flow of each wound) stopped per point of healing.
	var/bleed_mend = 0

/datum/status_effect/rogue_miracle_heal/on_creation(mob/living/new_owner, new_healing)
	duration = rogue_value("faith_heal_aura_time")
	bleed_mend = rogue_value("faith_heal_aura_bleed")
	healing = isnull(new_healing) ? rogue_value("faith_heal_aura_healing") : new_healing
	return ..()

/datum/status_effect/rogue_miracle_heal/on_apply()
	if(!owner.get_filter(ROGUE_MIRACLE_HEAL_FILTER))
		owner.add_filter(ROGUE_MIRACLE_HEAL_FILTER, 2, list("type" = "outline", "color" = "#c7aa5c", "alpha" = 60, "size" = 1))
	return TRUE

/datum/status_effect/rogue_miracle_heal/on_remove()
	owner.remove_filter(ROGUE_MIRACLE_HEAL_FILTER)

/datum/status_effect/rogue_miracle_heal/tick(seconds_between_ticks)
	var/amount = healing * seconds_between_ticks
	if(owner.has_status_effect(/datum/status_effect/rogue_fortify))
		amount *= rogue_value("faith_fortify_bonus")
	SEND_SIGNAL(owner, COMSIG_LIVING_MIRACLE_HEAL_APPLY, amount, src)
	new /obj/effect/temp_visual/heal(get_turf(owner), "#c7aa5c")
	if(owner.get_blood_volume() < BLOOD_VOLUME_NORMAL)
		owner.adjust_blood_volume(amount, maximum = BLOOD_VOLUME_NORMAL)
	if(iscarbon(owner))
		var/mob/living/carbon/patient = owner
		for(var/datum/wound/wound as anything in patient.all_wounds)
			wound.adjust_blood_flow(-amount * bleed_mend)
	var/need_update = FALSE
	need_update += owner.adjust_brute_loss(-amount, updating_health = FALSE)
	need_update += owner.adjust_fire_loss(-amount, updating_health = FALSE)
	need_update += owner.adjust_oxy_loss(-amount, updating_health = FALSE)
	need_update += owner.adjust_tox_loss(-amount, updating_health = FALSE)
	owner.adjust_organ_loss(ORGAN_SLOT_BRAIN, -amount)
	if(need_update)
		owner.updatehealth()

/// Ratwood buff/fortify: for a minute all healing of the miracles takes better (faith_fortify_bonus).
/datum/status_effect/rogue_fortify
	id = "rogue_fortify"
	alert_type = null
	status_type = STATUS_EFFECT_REFRESH

/datum/status_effect/rogue_fortify/on_creation(mob/living/new_owner)
	duration = rogue_value("faith_fortify_time")
	return ..()

/datum/status_effect/rogue_fortify/refresh(effect)
	duration = rogue_value("faith_fortify_time")

/datum/status_effect/rogue_fortify/on_apply()
	if(!owner.get_filter(ROGUE_FORTIFY_FILTER))
		owner.add_filter(ROGUE_FORTIFY_FILTER, 2, list("type" = "outline", "color" = "#fbe59d", "alpha" = 200, "size" = 1))
	return TRUE

/datum/status_effect/rogue_fortify/on_remove()
	owner.remove_filter(ROGUE_FORTIFY_FILTER)

/datum/status_effect/rogue_fortify/get_examine_text(mob/examiner)
	return span_notice("[owner.p_They()] stand[owner.p_s()] alight with divine energy!")

/// Ratwood lesser_heal "Miracle" (Azure Peak and Twilight Axis miracle/heal): a healing aura on the target for ten seconds.
/// Holy light burns the undead instead; wounds tear around an embedded object. A caster with Astrata's resonance fortifies
/// those around too.
/datum/action/cooldown/spell/pointed/rogue_miracle/lesser_heal
	name = "Miracle"
	desc = "Heals the target over time. Burns the undead instead, and tears the wounds of one with something embedded in them."
	button_icon_state = "heal"
	sound = 'modular_redtard/faith/sound/heal.ogg'
	value_key = "lesser_heal"
	miracle_tier = ROGUE_MIRACLE_TIER_1
	miracle_forks = "Ratwood, Azure Peak, Twilight Axis"
	miracle_gods = "every god of the Ten and the Inhumen T1"

/datum/action/cooldown/spell/pointed/rogue_miracle/lesser_heal/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !isliving(cast_on))
		to_chat(owner, span_warning("Only the living can be healed."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/lesser_heal/cast(mob/living/cast_on)
	. = ..()
	if(HAS_TRAIT(owner, TRAIT_RESONANCE))
		for(var/mob/living/carbon/fortified in view(rogue_value("faith_lesser_heal_resonance_range"), get_turf(owner)))
			if(burns_undead(fortified))
				fortified.adjust_fire_loss(rogue_value("faith_lesser_heal_resonance_burn"))
			else
				fortified.apply_status_effect(/datum/status_effect/rogue_fortify)
	if(turned_away(cast_on))
		return
	if(burns_undead(cast_on))
		cast_on.visible_message(span_danger("[cast_on] is burned by holy light!"), span_userdanger("I'm burned by holy light!"))
		cast_on.adjust_fire_loss(rogue_value("faith_lesser_heal_burn"))
		return
	if(cast_on.has_status_effect(/datum/status_effect/rogue_miracle_heal))
		return fail("[cast_on] is already under the effects of a healing aura!")
	if(iscarbon(cast_on))
		var/mob/living/carbon/patient = cast_on
		if(patient.has_embedded_objects())
			patient.visible_message(span_danger("The wounds of [patient] tear and rip around the embedded objects!"), span_userdanger("Agonising pain shoots through my body as the miracle tries to sew around the embedded objects!"))
			patient.adjust_brute_loss(rogue_value("faith_lesser_heal_embedded"))
			patient.emote("scream")
			return
	// Healing every second of the aura (Ratwood healing).
	cast_on.apply_status_effect(/datum/status_effect/rogue_miracle_heal, rogue_value("faith_lesser_heal_healing"))
	cast_on.visible_message(span_info("A choral sound comes from above and [cast_on] is healed!"), span_notice("I am bathed in healing choral hymns!"))

/// Ratwood heal "Fortify" (Azure Peak and Twilight Axis miracle/fortify): the target takes all healing better for a minute;
/// a beast is mended at once and the undead are burned.
/datum/action/cooldown/spell/pointed/rogue_miracle/fortify
	name = "Fortify"
	desc = "For a minute the target receives all healing half again as well. Mends a beast at once; burns the undead."
	button_icon_state = "fortify"
	sound = 'modular_redtard/faith/sound/heal.ogg'
	value_key = "fortify"
	miracle_tier = ROGUE_MIRACLE_TIER_2
	needs_holy_symbol = TRUE
	miracle_forks = "Ratwood, Azure Peak, Twilight Axis"
	miracle_gods = "Astrata T2, Pestra T3"

/datum/action/cooldown/spell/pointed/rogue_miracle/fortify/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !isliving(cast_on))
		to_chat(owner, span_warning("Only the living can be fortified."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/fortify/cast(mob/living/cast_on)
	. = ..()
	if(turned_away(cast_on))
		return
	if(burns_undead(cast_on))
		cast_on.visible_message(span_danger("[cast_on] is burned by holy light!"), span_userdanger("I'm burned by holy light!"))
		cast_on.adjust_fire_loss(rogue_value("faith_fortify_burn"))
		return
	cast_on.visible_message(span_info("A wreath of gentle light passes over [cast_on]!"), span_notice("I'm bathed in holy light!"))
	if(iscarbon(cast_on))
		cast_on.apply_status_effect(/datum/status_effect/rogue_fortify)
		return
	var/beast_heal = rogue_value("faith_fortify_beast_heal")
	cast_on.heal_overall_damage(beast_heal, beast_heal)

/// Ratwood blood_heal "Blood Transfer Miracle" (Azure Peak and Twilight Axis miracle/bloodmiracle "Lyfeblood Transfer"): a
/// strand of blood from the caster to the target while the caster stands still; the more skilled the caster, the less of
/// their own blood it takes and the more it gives.
/datum/action/cooldown/spell/pointed/rogue_miracle/blood_transfer
	name = "Blood Transfer Miracle"
	desc = "Transfers my own blood to the target. The more skilled I am in miracles, the less of my blood it takes."
	button_icon_state = "bloodheal"
	sound = 'modular_redtard/faith/sound/bloodheal.ogg'
	value_key = "blood_transfer"
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_1
	miracle_forks = "Ratwood, Azure Peak, Twilight Axis"
	miracle_gods = "every god of the Ten and the Inhumen T1, Xylix T2"

/datum/action/cooldown/spell/pointed/rogue_miracle/blood_transfer/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !ishuman(cast_on))
		to_chat(owner, span_warning("Only a person can take my blood."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/blood_transfer/cast(mob/living/carbon/human/cast_on)
	. = ..()
	var/mob/living/carbon/human/caster = owner
	if(HAS_TRAIT(caster, TRAIT_NOBLOOD))
		return fail("I have no blood to provide.")
	if(cast_on.get_blood_volume() >= BLOOD_VOLUME_NORMAL)
		return fail("Their lyfeblood is at capacity. There is no need.")
	if(turned_away(cast_on))
		return
	INVOKE_ASYNC(src, PROC_REF(transfer), caster, cast_on)

/datum/action/cooldown/spell/pointed/rogue_miracle/blood_transfer/proc/transfer(mob/living/carbon/human/caster, mob/living/carbon/human/target)
	caster.visible_message(span_warning("Tiny strands of red link between [caster] and [target], blood being transferred!"))
	playsound(caster, 'modular_redtard/faith/sound/bloodheal_start.ogg', 100, TRUE)
	var/rank = caster.rogue_skill_rank(/datum/attribute/skill/magic/holy)
	// Blood the caster gives up per pulse, by their rank in miracles (Ratwood blood_price; faith_blood_transfer_price_0 to _6, the last for every rank above).
	var/price = rogue_value("faith_blood_transfer_price_[clamp(rank, 0, 6)]")
	// Blood the target gets per pulse (Ratwood 7.5), and more per rank above novice.
	var/given = rogue_value("faith_blood_transfer_given") + (rank > rogue_value("faith_blood_transfer_given_above") ? rogue_value("faith_blood_transfer_given_rank") * rank : 0)
	var/pulse = rogue_value("faith_blood_transfer_pulse")
	var/pulses = round(caster.get_blood_volume() / price) * rogue_value("faith_blood_transfer_pulse_factor")
	var/datum/beam/strand = caster.Beam(target, icon_state = "blood", time = pulses * pulse)
	var/told = FALSE
	for(var/i in 1 to pulses)
		if(QDELETED(caster) || QDELETED(target) || caster.get_blood_volume() <= BLOOD_VOLUME_SURVIVE * rogue_value("faith_blood_transfer_survive_share") || !do_after(caster, pulse, target = target))
			break
		target.adjust_blood_volume(given, maximum = BLOOD_VOLUME_NORMAL)
		caster.adjust_blood_volume(-price)
		if(!told && target.get_blood_volume() >= BLOOD_VOLUME_NORMAL)
			to_chat(caster, span_info("They're at a healthy blood level, but I can keep going."))
			told = TRUE
	QDEL_NULL(strand)
	if(!QDELETED(caster))
		caster.visible_message(span_warning("[caster] severs the bloodlink from [target]!"))

/// Ratwood wound_heal "Wound Miracle": after a short prayer (shorter the more skilled), all wounds of the targeted limb close
/// and its damage mends. Not with an object lodged in the limb.
/datum/action/cooldown/spell/pointed/rogue_miracle/wound_heal
	name = "Wound Miracle"
	desc = "Closes all wounds of the limb I aim at and mends it, after a short prayer. Not with something lodged in it."
	button_icon_state = "woundheal"
	sound = 'modular_redtard/faith/sound/woundheal.ogg'
	value_key = "wound_heal"
	miracle_tier = ROGUE_MIRACLE_TIER_4
	miracle_forks = "Ratwood"
	miracle_gods = "Xylix T4"

/datum/action/cooldown/spell/pointed/rogue_miracle/wound_heal/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !iscarbon(cast_on))
		to_chat(owner, span_warning("Only a body of flesh can have its wounds closed."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/wound_heal/cast(mob/living/carbon/cast_on)
	. = ..()
	if(turned_away(cast_on))
		return
	var/obj/item/bodypart/limb = cast_on.get_bodypart(rogue_zone_target(owner.zone_selected))
	if(!limb)
		return fail("There is no limb there.")
	if(length(limb.embedded_objects))
		return fail("I cannot seal wounds with objects inside this limb!")
	if(!length(limb.wounds) && !limb.brute_dam && !limb.burn_dam)
		return fail("The limb is free of wounds.")
	INVOKE_ASYNC(src, PROC_REF(close_wounds), owner, cast_on, limb)

/datum/action/cooldown/spell/pointed/rogue_miracle/wound_heal/proc/close_wounds(mob/living/carbon/human/caster, mob/living/carbon/patient, obj/item/bodypart/limb)
	// The prayer before the wounds close (Ratwood 4.5 seconds), shorter by a step per rank in miracles.
	var/time = max(rogue_value("faith_wound_heal_prayer") - rogue_value("faith_wound_heal_prayer_rank") * caster.rogue_skill_rank(/datum/attribute/skill/magic/holy), rogue_value("faith_wound_heal_prayer_least"))
	if(!do_after(caster, time, target = patient) || QDELETED(limb) || limb.owner != patient)
		to_chat(caster, span_warning("I was interrupted!"))
		refund()
		return
	for(var/datum/wound/wound as anything in LAZYCOPY(limb.wounds))
		caster.visible_message("<font color='#488f33'>[capitalize(wound.name)] oozes a clear fluid and closes shut!</font>")
		wound.remove_wound()
	limb.heal_damage(limb.brute_dam, limb.burn_dam)
	playsound(patient, 'modular_redtard/faith/sound/woundheal_crunch.ogg', 100, TRUE)

/// Ratwood diagnose "Diagnose" (Pestra's orison): the state of the target's body, limb by limb, its humours and its blood.
/datum/action/cooldown/spell/pointed/rogue_miracle/diagnose
	name = "Diagnose"
	desc = "Examine another's vitals: wounds limb by limb, toxins, breath and blood."
	button_icon = ROGUE_MIRACLES_PESTRA_ICON
	button_icon_state = "diagnose"
	sound = 'modular_redtard/faith/sound/diagnose.ogg'
	value_key = "diagnose"
	miracle_tier = ROGUE_MIRACLE_TIER_0
	miracle_forks = "Ratwood, Azure Peak, Twilight Axis"
	miracle_gods = "Pestra T0"

/datum/action/cooldown/spell/pointed/rogue_miracle/diagnose/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !ishuman(cast_on))
		to_chat(owner, span_warning("I can only read the vitals of a person."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/diagnose/cast(mob/living/carbon/human/cast_on)
	. = ..()
	var/list/report = list(span_notice("<b>The vitals of [cast_on]:</b>"))
	if(cast_on.stat == DEAD)
		report += span_danger("The lyfe has left this body.")
	for(var/obj/item/bodypart/limb as anything in cast_on.bodyparts)
		var/list/findings = list()
		switch(limb.brute_dam)
			if(1 to 20)
				findings += "bruised"
			if(20 to 40)
				findings += "battered"
			if(40 to INFINITY)
				findings += "mangled"
		switch(limb.burn_dam)
			if(1 to 20)
				findings += "singed"
			if(20 to 40)
				findings += "burned"
			if(40 to INFINITY)
				findings += "charred"
		for(var/datum/wound/wound as anything in limb.wounds)
			findings += LOWER_TEXT(wound.name)
		if(length(limb.embedded_objects))
			findings += "something lodged in it"
		if(length(findings))
			report += "[capitalize(limb.plaintext_zone)]: [english_list(findings)]."
	switch(cast_on.get_tox_loss())
		if(0 to 1)
			report += span_notice("No sign of toxicity in the body.")
		if(1 to 50)
			report += span_notice("Some traces of toxicity are found under scrutiny.")
		if(50 to 100)
			report += span_warning("Significant signs of toxicity are apparent.")
		if(100 to INFINITY)
			report += span_danger("The body is steeped in poison.")
	if(cast_on.get_oxy_loss() > 20)
		report += span_warning("The breath comes short; the lips are blue.")
	switch(cast_on.get_blood_volume())
		if(0 to BLOOD_VOLUME_BAD)
			report += span_danger("Pale as a corpse: most of the lyfeblood is gone.")
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
			report += span_warning("Pale; a good deal of blood has been lost.")
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			report += span_notice("A little short of blood.")
	to_chat(owner, boxed_message(jointext(report, "<br>")))

#undef ROGUE_MIRACLE_HEAL_FILTER
#undef ROGUE_FORTIFY_FILTER
