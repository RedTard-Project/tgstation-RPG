/// Vibelin's broken bones and dislocations (code/datums/wounds/fractures.dm, dislocations.dm) as crits of combat/wounds.dm, with
/// Azure Peak's shatter on top (datums/wounds/types/fractures.dm: a second break of a skull, a cranium or a neck already
/// broken shatters it). A broken bone numbs its limb until a splint holds it, makes it brittle while it lasts, bleeds hard
/// but clots fast, and a broken or dislocated leg slows one's steps. Setting the bone (surgery, combat/surgery/wounds.dm
/// rogue_set_bone()) stems its bleeding and lets it mend; a dislocation set back in place is gone.

/datum/wound/rogue/fracture
	name = "fracture"
	rogue_key = "fracture"
	severity = WOUND_SEVERITY_SEVERE
	crit_message = list(
		"The bone shatters!",
		"The bone is broken!",
		"The %BODYPART is mauled!",
		"The bone snaps through the skin!",
	)
	sound_effect = 'sound/effects/wounds/crack2.ogg'
	rogue_clots = TRUE
	disabling = TRUE
	critical = TRUE
	splint_suppression = TRUE
	ignore_bloody = TRUE
	can_roll = TRUE
	strong_intent_bonus = TRUE
	brittle_bonus = TRUE
	gain_emote = "paincrit"
	rogue_chat_span = "bone"
	associated_bclasses = list(BCLASS_BLUNT, BCLASS_SMASH, BCLASS_CHOP, BCLASS_PICK, BCLASS_PUNCH)
	viable_zones = list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_PRECISE_L_FOOT)
	/// Vibelin can_set and bone_set.
	var/can_set = TRUE
	var/bone_set = FALSE

/datum/wound/rogue/fracture/rogue_visible_marks()
	. = ..()
	if(bone_set)
		. += " (set)"

/// Vibelin on_bodypart_gain(): besides the numbing of a crit, the limb stays brittle while the bone is broken, and a broken
/// leg slows one's steps.
/datum/wound/rogue/fracture/rogue_on_gain()
	. = ..()
	if(QDELETED(src) || !limb)
		return
	limb.rogue_set_brittle(REF(src), TRUE)
	victim.rogue_update_fracture_slowdown()

/datum/wound/rogue/fracture/rogue_on_loss(obj/item/bodypart/old_limb, mob/living/carbon/old_victim, replaced, destroying)
	. = ..()
	old_limb?.rogue_set_brittle(REF(src), FALSE)
	if(old_victim && !QDELETED(old_victim))
		old_victim.rogue_update_fracture_slowdown()

/datum/wound/rogue/fracture/rogue_on_regain()
	. = ..()
	limb.rogue_set_brittle(REF(src), TRUE)
	victim.rogue_update_fracture_slowdown()

/datum/wound/rogue/fracture/rogue_settable()
	return can_set && !bone_set

/// Vibelin set_bone(): the set bone bleeds a little, mends by itself and in sleep, and mends at once a share of a fresh one.
/datum/wound/rogue/fracture/rogue_set_bone()
	if(!rogue_settable())
		return FALSE
	bone_set = TRUE
	bleed_rate = rogue_number("set_bleed")
	var/mending = rogue_number("sewn_mending")
	sleep_healing = max(sleep_healing, mending)
	passive_healing = max(passive_healing, mending)
	rogue_heal_wound(rogue_number("whp") / rogue_number("set_heal_divisor"))
	return TRUE

/// The head's broken bones (Vibelin fracture/head): they knock one out for a while, disfigure, keep one stuttering; a mortal
/// one kills the critically weak. Some paralyze the whole body and take hearing and pain (Vibelin paralysis).
/datum/wound/rogue/fracture/head
	name = "compound cranial fracture"
	rogue_key = "fracture_head"
	disabling = FALSE
	splint_suppression = FALSE
	mortal = TRUE
	crit_message = list(
		"The skull shatters in a gruesome way!",
		"The head is smashed!",
		"The skull is broken!",
		"The skull caves in!",
	)
	viable_zones = list(BODY_ZONE_HEAD)
	/// Vibelin paralysis: the body is paralyzed, deaf and feels no pain while it lasts.
	var/paralysis = FALSE

/datum/wound/rogue/fracture/head/rogue_on_gain()
	. = ..()
	if(QDELETED(src) || !victim)
		return
	ADD_TRAIT(victim, TRAIT_DISFIGURED, REF(src))
	if(paralysis)
		rogue_paralyze_body(victim, TRUE)
		victim.add_traits(list(TRAIT_DEAF, TRAIT_NOPAIN), REF(src))
		victim.become_nearsighted(REF(src))

/datum/wound/rogue/fracture/head/rogue_on_loss(obj/item/bodypart/old_limb, mob/living/carbon/old_victim, replaced, destroying)
	. = ..()
	if(!old_victim)
		return
	REMOVE_TRAIT(old_victim, TRAIT_DISFIGURED, REF(src))
	if(paralysis)
		rogue_paralyze_body(old_victim, FALSE)
		old_victim.remove_traits(list(TRAIT_DEAF, TRAIT_NOPAIN), REF(src))
		old_victim.cure_nearsighted(REF(src))

/datum/wound/rogue/fracture/head/rogue_on_regain()
	. = ..()
	ADD_TRAIT(victim, TRAIT_DISFIGURED, REF(src))
	if(paralysis)
		rogue_paralyze_body(victim, TRUE)
		victim.add_traits(list(TRAIT_DEAF, TRAIT_NOPAIN), REF(src))
		victim.become_nearsighted(REF(src))

/datum/wound/rogue/fracture/head/rogue_on_life(seconds_per_tick)
	. = ..()
	if(victim && victim.stat != DEAD)
		var/stutter = rogue_number("stutter")
		if(stutter > 0)
			victim.set_stutter_if_lower(stutter)

/// Vibelin fracture/head/surgical: the skull a surgeon saws open knocks no one out and is never rolled.
/datum/wound/rogue/fracture/head/surgical
	rogue_key = "fracture_head_surgical"
	can_roll = FALSE
	crit_message = null

/// Azure Peak fracture/head/shatter: the skull broken again shatters; it paralyzes, and kills the critically weak.
/datum/wound/rogue/fracture/head/shatter
	name = "shattered skull"
	rogue_key = "fracture_head_shatter"
	shatter_wound = TRUE
	paralysis = TRUE
	crit_message = list(
		"THE SKULL SHATTERS!",
		"THE HEAD IS PULVERIZED!",
		"THE SKULL IS MINCED INTO DUST!",
	)

/// Azure Peak: a shatter rolls only where its bone is broken already.
/datum/wound/rogue/fracture/head/shatter/rogue_can_apply(obj/item/bodypart/limb, zone, bclass)
	return ..() && limb.rogue_has_wound(/datum/wound/rogue/fracture/head)

/datum/wound/rogue/fracture/head/shatter/rogue_can_stack_with(datum/wound/other)
	return !istype(other, /datum/wound/rogue/fracture/head/shatter)

/// Vibelin fracture/head/brain: the cranium caved in; it chokes one each Life tick.
/datum/wound/rogue/fracture/head/brain
	name = "depressed cranial fracture"
	rogue_key = "fracture_brain"
	paralysis = TRUE
	crit_message = list(
		"The cranium is fractured!",
		"The cranium is cracked!",
		"The cranium is shattered!",
	)
	viable_zones = list("skull")

/datum/wound/rogue/fracture/head/brain/rogue_on_life(seconds_per_tick)
	. = ..()
	if(victim && victim.stat != DEAD)
		victim.adjust_oxy_loss(rogue_number("oxy_loss") * seconds_per_tick / ROGUE_LIFE_TICK)

/// Azure Peak fracture/head/brain/shatter.
/datum/wound/rogue/fracture/head/brain/shatter
	name = "shattered cranium"
	rogue_key = "fracture_brain_shatter"
	shatter_wound = TRUE
	crit_message = list(
		"THE CRANIUM IS UNSEWN!",
		"THE CRANIUM COMES APART IN A GRUESOME WAY!",
		"THE CRANIUM CAVES IN!",
	)

/datum/wound/rogue/fracture/head/brain/shatter/rogue_can_apply(obj/item/bodypart/limb, zone, bclass)
	return ..() && limb.rogue_has_wound(/datum/wound/rogue/fracture/head/brain)

/datum/wound/rogue/fracture/head/brain/shatter/rogue_can_stack_with(datum/wound/other)
	return !istype(other, /datum/wound/rogue/fracture/head/brain/shatter)

/// Vibelin fracture/head/eyes: the orbit broken blinds one for a while and leaves one nearsighted.
/datum/wound/rogue/fracture/head/eyes
	name = "orbital fracture"
	rogue_key = "fracture_eyes"
	crit_message = list(
		"The orbital bone is fractured!",
		"The orbital bone is cracked!",
	)
	viable_zones = list("r_eye", "l_eye")

/datum/wound/rogue/fracture/head/eyes/rogue_on_gain()
	. = ..()
	if(QDELETED(src) || !victim)
		return
	victim.adjust_temp_blindness(rogue_number("blindness"))
	victim.become_nearsighted(REF(src))

/datum/wound/rogue/fracture/head/eyes/rogue_on_loss(obj/item/bodypart/old_limb, mob/living/carbon/old_victim, replaced, destroying)
	. = ..()
	old_victim?.cure_nearsighted(REF(src))

/datum/wound/rogue/fracture/head/eyes/rogue_on_regain()
	. = ..()
	victim.become_nearsighted(REF(src))

/// Vibelin fracture/head/ears: the temporal bone caved in paralyzes.
/datum/wound/rogue/fracture/head/ears
	name = "depressed temporal fracture"
	rogue_key = "fracture_ears"
	paralysis = TRUE
	crit_message = list(
		"The temporal bone is fractured!",
		"The temporal bone is cracked!",
	)
	viable_zones = list("ears")

/// Vibelin fracture/head/nose: not mortal; one smells nothing while it lasts.
/datum/wound/rogue/fracture/head/nose
	name = "nasal fracture"
	rogue_key = "fracture_nose"
	mortal = FALSE
	crit_message = list(
		"The nasal bone is fractured!",
		"The nasal bone is shattered!",
	)
	viable_zones = list("nose")

/datum/wound/rogue/fracture/head/nose/rogue_on_gain()
	. = ..()
	if(!QDELETED(src) && victim)
		ADD_TRAIT(victim, TRAIT_ANOSMIA, REF(src))

/datum/wound/rogue/fracture/head/nose/rogue_on_loss(obj/item/bodypart/old_limb, mob/living/carbon/old_victim, replaced, destroying)
	. = ..()
	if(old_victim)
		REMOVE_TRAIT(old_victim, TRAIT_ANOSMIA, REF(src))

/datum/wound/rogue/fracture/head/nose/rogue_on_regain()
	. = ..()
	ADD_TRAIT(victim, TRAIT_ANOSMIA, REF(src))

/// Vibelin fracture/mouth: the broken jaw.
/datum/wound/rogue/fracture/mouth
	name = "mandibular fracture"
	rogue_key = "fracture_jaw"
	disabling = FALSE
	splint_suppression = FALSE
	crit_message = list(
		"The mandible comes apart beautifully!",
		"The jaw is smashed!",
		"The jaw is shattered!",
		"The jaw caves in!",
	)
	viable_zones = list(BODY_ZONE_PRECISE_MOUTH)

/// Vibelin fracture/neck: the broken neck paralyzes the body, takes its pain and chokes it each Life tick; mortal.
/datum/wound/rogue/fracture/neck
	name = "cervical fracture"
	rogue_key = "fracture_neck"
	disabling = FALSE
	splint_suppression = FALSE
	mortal = TRUE
	crit_message = list(
		"The spine shatters in a spectacular way!",
		"The spine snaps!",
		"The spine cracks!",
		"The spine is broken!",
	)
	viable_zones = list("neck")

/datum/wound/rogue/fracture/neck/rogue_on_gain()
	. = ..()
	if(QDELETED(src) || !victim)
		return
	rogue_paralyze_body(victim, TRUE)
	ADD_TRAIT(victim, TRAIT_NOPAIN, REF(src))

/datum/wound/rogue/fracture/neck/rogue_on_loss(obj/item/bodypart/old_limb, mob/living/carbon/old_victim, replaced, destroying)
	. = ..()
	if(!old_victim)
		return
	rogue_paralyze_body(old_victim, FALSE)
	REMOVE_TRAIT(old_victim, TRAIT_NOPAIN, REF(src))

/datum/wound/rogue/fracture/neck/rogue_on_regain()
	. = ..()
	rogue_paralyze_body(victim, TRUE)
	ADD_TRAIT(victim, TRAIT_NOPAIN, REF(src))

/datum/wound/rogue/fracture/neck/rogue_on_life(seconds_per_tick)
	. = ..()
	if(victim && victim.stat != DEAD)
		victim.adjust_oxy_loss(rogue_number("oxy_loss") * seconds_per_tick / ROGUE_LIFE_TICK)

/// Azure Peak fracture/neck/shatter: the neck broken again.
/datum/wound/rogue/fracture/neck/shatter
	name = "shattered spine"
	rogue_key = "fracture_neck_shatter"
	shatter_wound = TRUE
	crit_message = list(
		"THE SPINE SHATTERS!",
		"THE SPINE SNAPS IN A SPECTACULAR WAY!",
		"THE SPINE POPS WITH A SICKENING NOISE!",
	)

/datum/wound/rogue/fracture/neck/shatter/rogue_can_apply(obj/item/bodypart/limb, zone, bclass)
	return ..() && limb.rogue_has_wound(/datum/wound/rogue/fracture/neck)

/datum/wound/rogue/fracture/neck/shatter/rogue_can_stack_with(datum/wound/other)
	return !istype(other, /datum/wound/rogue/fracture/neck/shatter)

/// Vibelin fracture/chest: broken ribs hold one in place a moment.
/datum/wound/rogue/fracture/chest
	name = "rib fracture"
	rogue_key = "fracture_ribs"
	disabling = FALSE
	splint_suppression = FALSE
	crit_message = list(
		"The ribs shatter in a splendid way!",
		"The ribs are smashed!",
		"The ribs are mauled!",
		"The ribcage caves in!",
	)
	viable_zones = list(BODY_ZONE_CHEST)

/datum/wound/rogue/fracture/chest/rogue_on_gain()
	. = ..()
	if(!QDELETED(src) && victim)
		victim.Immobilize(rogue_number("immobilize"))

/// Vibelin fracture/groin: the broken pelvis holds one in place and paralyzes both legs.
/datum/wound/rogue/fracture/groin
	name = "pelvic fracture"
	rogue_key = "fracture_pelvis"
	disabling = FALSE
	splint_suppression = FALSE
	crit_message = list(
		"The pelvis shatters in a magnificent way!",
		"The pelvis is smashed!",
		"The pelvis is mauled!",
		"The pelvic floor caves in!",
	)
	viable_zones = list(BODY_ZONE_PRECISE_GROIN)

/datum/wound/rogue/fracture/groin/rogue_on_gain()
	. = ..()
	if(QDELETED(src) || !victim)
		return
	victim.Immobilize(rogue_number("immobilize"))
	victim.add_traits(list(TRAIT_PARALYSIS_L_LEG, TRAIT_PARALYSIS_R_LEG), REF(src))

/datum/wound/rogue/fracture/groin/rogue_on_loss(obj/item/bodypart/old_limb, mob/living/carbon/old_victim, replaced, destroying)
	. = ..()
	old_victim?.remove_traits(list(TRAIT_PARALYSIS_L_LEG, TRAIT_PARALYSIS_R_LEG), REF(src))

/datum/wound/rogue/fracture/groin/rogue_on_regain()
	. = ..()
	victim.add_traits(list(TRAIT_PARALYSIS_L_LEG, TRAIT_PARALYSIS_R_LEG), REF(src))

/// Vibelin dislocation: a twisted joint, out of its socket; it mends by itself, a leg out of joint slows one, and a brittle
/// limb breaks instead (the fracture rolls, the dislocation does not).
/datum/wound/rogue/dislocation
	name = "dislocation"
	rogue_key = "dislocation"
	severity = WOUND_SEVERITY_MODERATE
	crit_message = list(
		"The %BODYPART jolts painfully!",
		"The %BODYPART is twisted out of place!",
		"The %BODYPART is wrenched out of its socket!",
		"The %BODYPART is dislocated!",
	)
	sound_effect = 'sound/effects/wounds/crack1.ogg'
	critical = TRUE
	splint_suppression = TRUE
	ignore_bloody = TRUE
	can_roll = TRUE
	gain_emote = "paincrit"
	rogue_chat_span = "bone"
	associated_bclasses = list(BCLASS_TWIST)
	viable_zones = list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_PRECISE_L_FOOT)
	/// Vibelin can_relocate.
	var/can_relocate = TRUE

/datum/wound/rogue/dislocation/rogue_can_apply(obj/item/bodypart/limb, zone, bclass)
	return !limb.rogue_brittle() && ..()

/datum/wound/rogue/dislocation/rogue_on_gain()
	. = ..()
	if(QDELETED(src) || !limb)
		return
	limb.rogue_set_brittle(REF(src), TRUE)
	victim.rogue_update_fracture_slowdown()

/datum/wound/rogue/dislocation/rogue_on_loss(obj/item/bodypart/old_limb, mob/living/carbon/old_victim, replaced, destroying)
	. = ..()
	old_limb?.rogue_set_brittle(REF(src), FALSE)
	if(old_victim && !QDELETED(old_victim))
		old_victim.rogue_update_fracture_slowdown()

/datum/wound/rogue/dislocation/rogue_on_regain()
	. = ..()
	limb.rogue_set_brittle(REF(src), TRUE)
	victim.rogue_update_fracture_slowdown()

/datum/wound/rogue/dislocation/rogue_settable()
	return can_relocate

/// Vibelin relocate_bone(): the joint set back in place is gone.
/datum/wound/rogue/dislocation/rogue_set_bone()
	if(!can_relocate)
		return FALSE
	qdel(src)
	return TRUE

/// Vibelin dislocation/neck: one feels nothing of it, and the body is paralyzed while it lasts.
/datum/wound/rogue/dislocation/neck
	name = "cervical dislocation"
	rogue_key = "dislocation_neck"
	crit_message = list(
		"The spine slips!",
		"The spine twists!",
		"The %BODYPART is wrenched out of its socket!",
	)
	viable_zones = list("neck")

/datum/wound/rogue/dislocation/neck/rogue_on_gain()
	. = ..()
	if(!QDELETED(src) && victim)
		rogue_paralyze_body(victim, TRUE)

/datum/wound/rogue/dislocation/neck/rogue_on_loss(obj/item/bodypart/old_limb, mob/living/carbon/old_victim, replaced, destroying)
	. = ..()
	if(old_victim)
		rogue_paralyze_body(old_victim, FALSE)

/datum/wound/rogue/dislocation/neck/rogue_on_regain()
	. = ..()
	rogue_paralyze_body(victim, TRUE)

/// Vibelin FRACTURED_ADD_SLOWDOWN, DISLOCATED_ADD_SLOWDOWN: each leg broken or out of joint slows one's steps until it heals.
/mob/living/carbon/proc/rogue_update_fracture_slowdown()
	var/slowdown = 0
	for(var/obj/item/bodypart/limb as anything in bodyparts)
		if(limb.body_zone != BODY_ZONE_L_LEG && limb.body_zone != BODY_ZONE_R_LEG)
			continue
		for(var/datum/wound/rogue/crit in limb.wounds)
			if(istype(crit, /datum/wound/rogue/fracture) || istype(crit, /datum/wound/rogue/dislocation))
				slowdown += crit.rogue_number("leg_slowdown")
	if(slowdown > 0)
		add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/rogue_fracture, multiplicative_slowdown = slowdown)
	else
		remove_movespeed_modifier(/datum/movespeed_modifier/rogue_fracture)

/datum/movespeed_modifier/rogue_fracture
	variable = TRUE

/// The pregen data of the bone crits.
/datum/wound_pregen_data/rogue_crit/fracture
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/fracture

/datum/wound_pregen_data/rogue_crit/fracture_head
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/fracture/head

/datum/wound_pregen_data/rogue_crit/fracture_head_surgical
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/fracture/head/surgical

/datum/wound_pregen_data/rogue_crit/fracture_head_shatter
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/fracture/head/shatter

/datum/wound_pregen_data/rogue_crit/fracture_brain
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/fracture/head/brain

/datum/wound_pregen_data/rogue_crit/fracture_brain_shatter
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/fracture/head/brain/shatter

/datum/wound_pregen_data/rogue_crit/fracture_eyes
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/fracture/head/eyes

/datum/wound_pregen_data/rogue_crit/fracture_ears
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/fracture/head/ears

/datum/wound_pregen_data/rogue_crit/fracture_nose
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/fracture/head/nose

/datum/wound_pregen_data/rogue_crit/fracture_jaw
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/fracture/mouth

/datum/wound_pregen_data/rogue_crit/fracture_neck
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/fracture/neck

/datum/wound_pregen_data/rogue_crit/fracture_neck_shatter
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/fracture/neck/shatter

/datum/wound_pregen_data/rogue_crit/fracture_ribs
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/fracture/chest

/datum/wound_pregen_data/rogue_crit/fracture_pelvis
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/fracture/groin

/datum/wound_pregen_data/rogue_crit/dislocation
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/dislocation

/datum/wound_pregen_data/rogue_crit/dislocation_neck
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/dislocation/neck
