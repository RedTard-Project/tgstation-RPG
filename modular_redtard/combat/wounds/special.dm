/// Vibelin's other crits (code/datums/wounds/special.dm, disembowel.dm) and Azure Peak's charring (datums/wounds/types/burns.dm)
/// as crits of combat/wounds.dm: the stabs of the face (ears torn out, eyes gouged, the tongue cut out, the face or nose
/// mangled; they stay for good), the groin's torsion, the disembowelment of a gaping belly, the scarring of the whip, and
/// the charring of a burn. Vibelin's gut spill needs intestines, which TG's bodies have not; it is not taken.

/// Vibelin /datum/wound/facial: a stab to the face; it never mends by itself.
/datum/wound/rogue/facial
	name = "facial trauma"
	abstract_type = /datum/wound/rogue/facial
	rogue_key = "facial"
	severity = WOUND_SEVERITY_SEVERE
	sound_effect = 'modular_redtard/rockhill/sound/combat/crit.ogg'
	rogue_permanent = TRUE
	can_sew = TRUE
	can_roll = TRUE
	associated_bclasses = list(BCLASS_STAB, BCLASS_PICK, BCLASS_PIERCE)
	viable_zones = list(BODY_ZONE_HEAD)

/// Vibelin facial/ears: the eardrums gored; the ears come off. A critically resistant body keeps them.
/datum/wound/rogue/facial/ears
	name = "tympanosectomy"
	rogue_key = "facial_ears"
	crit_message = list(
		"The eardrums are gored!",
		"The eardrums are ruptured!",
	)
	can_cauterize = TRUE
	critical = TRUE
	viable_zones = list("ears")

/datum/wound/rogue/facial/ears/rogue_can_apply(obj/item/bodypart/limb, zone, bclass)
	if(HAS_TRAIT(limb.owner, TRAIT_CRITICAL_RESISTANCE) || !limb.owner.get_organ_slot(ORGAN_SLOT_EARS))
		return FALSE
	return ..()

/datum/wound/rogue/facial/ears/rogue_on_gain()
	. = ..()
	if(QDELETED(src) || !victim)
		return
	victim.Stun(rogue_number("stun"))
	victim.rogue_drop_organ(ORGAN_SLOT_EARS)

/// Vibelin facial/eyes: an eye gouged; the eyes are hurt and one is blinded a while. Both eyes gouged, the eyes come out.
/datum/wound/rogue/facial/eyes
	name = "eye evisceration"
	abstract_type = /datum/wound/rogue/facial/eyes
	rogue_key = "facial_eyes"
	critical = TRUE
	viable_zones = list("r_eye", "l_eye")

/datum/wound/rogue/facial/eyes/rogue_can_apply(obj/item/bodypart/limb, zone, bclass)
	return limb.owner.get_organ_slot(ORGAN_SLOT_EYES) && ..()

/datum/wound/rogue/facial/eyes/rogue_on_gain()
	. = ..()
	if(QDELETED(src) || !victim)
		return
	victim.Stun(rogue_number("stun"))
	victim.adjust_temp_blindness(rogue_number("blindness"))
	var/obj/item/organ/eyes/eyes = victim.get_organ_slot(ORGAN_SLOT_EYES)
	eyes?.apply_organ_damage(rogue_number("eye_damage"))
	if(limb.rogue_has_wound(/datum/wound/rogue/facial/eyes/right) && limb.rogue_has_wound(/datum/wound/rogue/facial/eyes/left))
		victim.rogue_drop_organ(ORGAN_SLOT_EYES)

/datum/wound/rogue/facial/eyes/right
	name = "right eye evisceration"
	crit_message = list(
		"The right eye is poked!",
		"The right eye is gouged!",
		"The right eye is destroyed!",
	)
	viable_zones = list("r_eye")

/datum/wound/rogue/facial/eyes/left
	name = "left eye evisceration"
	crit_message = list(
		"The left eye is poked!",
		"The left eye is gouged!",
		"The left eye is destroyed!",
	)
	viable_zones = list("l_eye")

/// Vibelin facial/tongue: the tongue cut out, which falls; the wound goes with it.
/datum/wound/rogue/facial/tongue
	name = "glossectomy"
	rogue_key = "facial_tongue"
	crit_message = list(
		"The tongue is cut!",
		"The tongue is severed!",
		"The tongue flies off in an arc!",
	)
	critical = TRUE
	viable_zones = list(BODY_ZONE_PRECISE_MOUTH)

/datum/wound/rogue/facial/tongue/rogue_can_apply(obj/item/bodypart/limb, zone, bclass)
	return limb.owner.get_organ_slot(ORGAN_SLOT_TONGUE) && ..()

/datum/wound/rogue/facial/tongue/rogue_on_gain()
	. = ..()
	if(QDELETED(src) || !victim)
		return
	victim.Stun(rogue_number("stun"))
	victim.rogue_drop_organ(ORGAN_SLOT_TONGUE)
	QDEL_IN(src, 1)

/// Vibelin facial/disfigurement: the face mangled beyond recognition.
/datum/wound/rogue/facial/disfigurement
	name = "disfigurement"
	rogue_key = "facial_face"
	severity = WOUND_SEVERITY_MODERATE
	crit_message = list("The face is mangled beyond recognition!")
	can_sew = FALSE
	critical = TRUE

/datum/wound/rogue/facial/disfigurement/rogue_on_gain()
	. = ..()
	if(!QDELETED(src) && victim)
		ADD_TRAIT(victim, TRAIT_DISFIGURED, REF(src))

/datum/wound/rogue/facial/disfigurement/rogue_on_loss(obj/item/bodypart/old_limb, mob/living/carbon/old_victim, replaced, destroying)
	. = ..()
	if(old_victim)
		REMOVE_TRAIT(old_victim, TRAIT_DISFIGURED, REF(src))

/datum/wound/rogue/facial/disfigurement/rogue_on_regain()
	. = ..()
	ADD_TRAIT(victim, TRAIT_DISFIGURED, REF(src))

/// Vibelin facial/disfigurement/nose: the nose cut off; one smells nothing; mortal.
/datum/wound/rogue/facial/disfigurement/nose
	name = "rhinotomy"
	crit_message = list(
		"The nose is mangled beyond recognition!",
		"The nose is destroyed!",
	)
	mortal = TRUE
	viable_zones = list("nose")

/datum/wound/rogue/facial/disfigurement/nose/rogue_on_gain()
	. = ..()
	if(!QDELETED(src) && victim)
		ADD_TRAIT(victim, TRAIT_ANOSMIA, REF(src))

/datum/wound/rogue/facial/disfigurement/nose/rogue_on_loss(obj/item/bodypart/old_limb, mob/living/carbon/old_victim, replaced, destroying)
	. = ..()
	if(old_victim)
		REMOVE_TRAIT(old_victim, TRAIT_ANOSMIA, REF(src))

/datum/wound/rogue/facial/disfigurement/nose/rogue_on_regain()
	. = ..()
	ADD_TRAIT(victim, TRAIT_ANOSMIA, REF(src))

/// Vibelin /datum/wound/cbt: a torsion of the groin; it stuns, numbs, makes one retch; mortal. Its chance is the blow's damage
/// alone, twice for a striker with the Nutcracker trait. A critically resistant body is spared.
/datum/wound/rogue/cbt
	name = "testicular torsion"
	rogue_key = "cbt"
	severity = WOUND_SEVERITY_SEVERE
	crit_message = list(
		"The testicles are twisted!",
		"The testicles are torsioned!",
	)
	sound_effect = 'modular_redtard/rockhill/sound/combat/crit.ogg'
	disabling = TRUE
	critical = TRUE
	mortal = TRUE
	can_roll = TRUE
	gain_emote = "scream"
	rogue_chat_span = "userdanger"
	associated_bclasses = list(BCLASS_BLUNT, BCLASS_SMASH, BCLASS_CHOP, BCLASS_PICK, BCLASS_PUNCH, BCLASS_TWIST)
	viable_zones = list(BODY_ZONE_PRECISE_GROIN)

/datum/wound/rogue/cbt/rogue_can_apply(obj/item/bodypart/limb, zone, bclass)
	if(HAS_TRAIT(limb.owner, TRAIT_CRITICAL_RESISTANCE) || !IS_ORGANIC_LIMB(limb))
		return FALSE
	return ..()

/datum/wound/rogue/cbt/rogue_can_stack_with(datum/wound/other)
	return !istype(other, /datum/wound/rogue/cbt)

/datum/wound/rogue/cbt/get_crit_prob(bclass, damage, share, mob/living/attacker, obj/item/bodypart/limb)
	if(!(bclass in associated_bclasses) || damage < min_damage)
		return 0
	var/factor = (attacker && HAS_TRAIT(attacker, TRAIT_NUTCRACKER)) ? rogue_number("nutcracker") : 1
	return round(damage / rogue_number("chance_divisor")) * factor

/datum/wound/rogue/cbt/apply_wound(obj/item/bodypart/limb, silent = FALSE, datum/wound/old_wound = null, smited = FALSE, attack_direction = null, wound_source = "Unknown", replacing = FALSE)
	if(limb?.owner && limb.owner.gender != MALE)
		name = "ovarian torsion"
		crit_message = list(
			"The ovaries are twisted!",
			"The ovaries are torsioned!",
		)
	return ..()

/datum/wound/rogue/cbt/rogue_on_gain()
	. = ..()
	if(QDELETED(src) || !victim)
		return
	victim.Stun(rogue_number("stun"))
	to_chat(victim, span_userdanger("Something twists inside my groin!"))

/datum/wound/rogue/cbt/rogue_on_life(seconds_per_tick)
	. = ..()
	if(victim && victim.stat == STABLE && prob(rogue_number("vomit_chance") * seconds_per_tick / ROGUE_LIFE_TICK))
		victim.vomit(VOMIT_CATEGORY_DEFAULT, lost_nutrition = 1)

/// Vibelin /datum/wound/slash/disembowel: a gaping belly torn open spills the stomach, maybe the liver, and what the chest
/// holds; it bleeds terribly and is awful to sew. A critically resistant body is spared.
/datum/wound/rogue/disembowel
	name = "disembowelment"
	rogue_key = "disembowel"
	severity = WOUND_SEVERITY_CRITICAL
	crit_message = list(
		"%VICTIM spills %P_THEIR organs!",
		"%VICTIM spills %P_THEIR entrails!",
	)
	sound_effect = 'modular_redtard/rockhill/sound/combat/crit2.ogg'
	rogue_clots = TRUE
	can_sew = TRUE
	can_cauterize = TRUE
	critical = TRUE
	can_roll = TRUE
	strong_intent_bonus = TRUE
	aimed_intent_bonus = TRUE
	gain_emote = "paincrit"
	rogue_chat_span = "userdanger"
	associated_bclasses = list(BCLASS_CUT, BCLASS_CHOP, BCLASS_STAB, BCLASS_PICK, BCLASS_BITE, BCLASS_PIERCE)
	viable_zones = list("stomach")

/datum/wound/rogue/disembowel/rogue_can_apply(obj/item/bodypart/limb, zone, bclass)
	if(HAS_TRAIT(limb.owner, TRAIT_CRITICAL_RESISTANCE))
		return FALSE
	if(!..())
		return FALSE
	return rogue_forced || limb.rogue_gaping(rogue_number("gaping"))

/datum/wound/rogue/disembowel/rogue_on_gain()
	. = ..()
	if(QDELETED(src) || !victim)
		return
	var/turf/spill = victim.drop_location()
	var/obj/item/bodypart/chest/chest = limb
	if(istype(chest) && chest.cavity_item)
		chest.cavity_item.forceMove(spill)
		chest.cavity_item = null
	if(prob(rogue_number("stomach_chance")))
		victim.rogue_drop_organ(ORGAN_SLOT_STOMACH)
	if(prob(rogue_number("liver_chance")))
		victim.rogue_drop_organ(ORGAN_SLOT_LIVER)
	if(isturf(spill) && victim.can_bleed())
		victim.add_splatter_floor(spill)

/// Vibelin /datum/wound/scarring: the whip rends the tissue for good; it does not mend in sleep.
/datum/wound/rogue/scarring
	name = "permanent scarring"
	rogue_key = "scarring"
	severity = WOUND_SEVERITY_SEVERE
	crit_message = list(
		"The whiplash cuts deep!",
		"The tissue is irreversibly rended!",
		"The %BODYPART is thoroughly disfigured!",
	)
	sound_effect = 'modular_redtard/rockhill/sound/combat/crit.ogg'
	disabling = TRUE
	critical = TRUE
	can_roll = TRUE
	strong_intent_bonus = TRUE
	gain_emote = "scream"
	rogue_chat_span = "userdanger"
	associated_bclasses = list(BCLASS_LASHING)

/datum/wound/rogue/scarring/rogue_can_stack_with(datum/wound/other)
	return !istype(other, /datum/wound/rogue/scarring)

/// Azure Peak /datum/wound/charring: the flesh seared to the bone by a burning blow; it numbs the limb until sewn, drops and
/// slows one.
/datum/wound/rogue/charring
	name = "severe burn"
	rogue_key = "charring"
	severity = WOUND_SEVERITY_SEVERE
	crit_message = list(
		"The flesh is seared to the bone!",
		"The %BODYPART is charred black!",
		"The skin blisters and splits open!",
		"The flesh crackles and chars!",
	)
	sound_effect = 'sound/effects/wounds/sizzle1.ogg'
	can_sew = TRUE
	disabling = TRUE
	critical = TRUE
	ignore_bloody = TRUE
	can_roll = TRUE
	gain_emote = "scream"
	rogue_chat_span = "necrosis"
	associated_bclasses = list(BCLASS_BURN)
	viable_zones = list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_PRECISE_L_FOOT)

/datum/wound/rogue/charring/rogue_on_gain()
	. = ..()
	if(QDELETED(src) || !victim)
		return
	flash_color(victim, "#a83c1a", 15)
	victim.rogue_slow_for(rogue_number("slowdown"))
	victim.Paralyze(rogue_number("paralyze"))

/// Azure Peak charring/chest: mortal.
/datum/wound/rogue/charring/chest
	name = "torso charring"
	crit_message = list(
		"The torso is seared!",
		"The chest is charred black!",
		"The ribcage crackles with heat!",
	)
	mortal = TRUE
	viable_zones = list(BODY_ZONE_CHEST, "stomach", BODY_ZONE_PRECISE_GROIN)

/// Azure Peak charring/head: mortal.
/datum/wound/rogue/charring/head
	name = "head charring"
	crit_message = list(
		"The skull is seared!",
		"The face is charred beyond recognition!",
		"The head is engulfed in searing heat!",
	)
	mortal = TRUE
	viable_zones = list(BODY_ZONE_HEAD, "skull", "ears", "r_eye", "l_eye", "nose", BODY_ZONE_PRECISE_MOUTH, "neck")

/// An organ torn out of the body by a crit falls at its feet (Vibelin organ.Remove(); forceMove(drop_location())).
/mob/living/carbon/proc/rogue_drop_organ(slot)
	var/obj/item/organ/organ = get_organ_slot(slot)
	if(!organ)
		return null
	organ.Remove(src)
	if(QDELETED(organ))
		return null
	organ.forceMove(drop_location())
	organ.add_mob_blood(src)
	return organ

/datum/wound_pregen_data/rogue_crit/facial_ears
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/facial/ears

/datum/wound_pregen_data/rogue_crit/facial_eye_right
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/facial/eyes/right

/datum/wound_pregen_data/rogue_crit/facial_eye_left
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/facial/eyes/left

/datum/wound_pregen_data/rogue_crit/facial_tongue
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/facial/tongue

/datum/wound_pregen_data/rogue_crit/facial_face
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/facial/disfigurement

/datum/wound_pregen_data/rogue_crit/facial_nose
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/facial/disfigurement/nose

/datum/wound_pregen_data/rogue_crit/cbt
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/cbt

/datum/wound_pregen_data/rogue_crit/disembowel
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/disembowel

/datum/wound_pregen_data/rogue_crit/scarring
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/scarring

/datum/wound_pregen_data/rogue_crit/charring
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/charring

/datum/wound_pregen_data/rogue_crit/charring_chest
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/charring/chest

/datum/wound_pregen_data/rogue_crit/charring_head
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/charring/head
