/// Vibelin's own operations (code/modules/surgery/operations/surgeries/), which Ratwood has not, on a medieval body, rolled
/// as every step of the module (combat/surgery/operation.dm):
/// - tend wounds (healing.dm): through an opened chest, the superficial cuts, bruises and burns of the whole body are patched,
///   again and again while any are left - Vibelin's injuries (combat/injuries/), the surgical ones aside; the advanced tending
///   of a journeyman does cuts and burns at once and quicker;
/// - facial reconstruction (plastic_surgery.dm): a disfigured face is mended, a sound one reshaped under a new name; a failure
///   disfigures it;
/// - a wooden limb sawn off by an engineer (amputation.dm amputate/pegleg), and a prosthetic fitted on a stump by one
///   (prosthetic_replacement.dm limb_replacement/prosthetic): the craft's skill, not Medicine's, rolls and learns them.
/// Vibelin's other steps are Ratwood's in steps.dm on Vibelin's model (incise, clamp, retract, saw, amputate, bones, the
/// relocation, what is lodged in a limb, the rot), its teeth in combat/teeth.dm. Not taken: closing the skin (the needle and
/// the searing of steps.dm do it), the revival, the lux and the chimeric node (content of the faiths).

/// Key of an operation's arguments: the name the reconstructed face is given.
#define ROGUE_OPERATION_NEW_NAME "rogue_new_name"

// ---------------------------------------------------------------------------------------------------------------------------
// Tend wounds.

/// Vibelin /datum/surgery_operation/basic/tend_wounds: with the chest opened, the superficial injuries of the body are patched
/// a share at a time, more for a better surgeon, less on a corpse or through clothes; each turn is rolled anew while any are
/// left. A failure cuts the body somewhere instead.
/datum/surgery_operation/basic/rogue/tend_wounds
	name = "tend wounds"
	desc = "Perform superficial wound care on a patient's cuts, bruises and burns."
	operation_flags = OPERATION_LOCKED | OPERATION_NO_WIKI | OPERATION_SELF_OPERABLE | OPERATION_STANDING_ALLOWED | OPERATION_LOOPING | OPERATION_IGNORE_CLOTHES
	/// Vibelin's suture (TOOL_SUTURE 1.2) is left out: a needle on an opened body must still sew (combat/medicine.dm
	/// rogue_sew()), and TG offers the operations of a tool before the tool's own use.
	implements = list(TOOL_HEMOSTAT = 1, ROGUE_TOOL_IMPROVISED_HEMOSTAT = 1, /obj/item/natural/feather = 1)
	time = 2.5 SECONDS
	success_sound = 'sound/items/handling/surgery/retractor2.ogg'
	failure_sound = 'sound/items/handling/surgery/organ2.ogg'
	any_surgery_states_required = ALL_SURGERY_SKIN_STATES|SURGERY_VESSELS_CLAMPED
	/// Vibelin COMBO_SURGERY: cuts and burns are tended at once.
	var/rogue_combo = FALSE
	/// Vibelin healing_amount: the damage a turn tends, before the share of what the body has.
	var/rogue_heal_flat = 0
	/// Vibelin healing_multiplier: the share of the body's damage a turn tends besides.
	var/rogue_heal_share = 0
	/// Radial options by kind of tending, made once.
	var/list/rogue_tend_options

/datum/surgery_operation/basic/rogue/tend_wounds/rogue_read_numbers()
	. = ..()
	time = rogue_value("surgery_tend_time")
	rogue_dice_requirement = rogue_value("surgery_tend_dice")
	rogue_skill_min = rogue_value("surgery_tend_least_skill")
	rogue_skill_median = rogue_value("surgery_tend_median_skill")
	rogue_heal_flat = rogue_value("surgery_tend_heal")
	rogue_heal_share = rogue_value("surgery_tend_heal_share")
	rogue_step_qualities = list(TOOL_HEMOSTAT = rogue_value("surgery_tend_q_hemostat"), ROGUE_TOOL_IMPROVISED_HEMOSTAT = rogue_value("surgery_tend_q_improvised"), /obj/item/natural/feather = rogue_value("surgery_tend_q_feather"))

/datum/surgery_operation/basic/rogue/tend_wounds/get_default_radial_image()
	return image(/obj/item/natural/cloth)

/// Vibelin check_for_injuries(): an injury of the kinds the body may still have tended - one that can heal, not surgical.
/datum/surgery_operation/basic/rogue/tend_wounds/proc/rogue_tendable(mob/living/carbon/patient, brute, burn)
	if(!iscarbon(patient))
		return FALSE
	for(var/obj/item/bodypart/part as anything in patient.bodyparts)
		for(var/datum/rogue_injury/injury as anything in part.rogue_injuries)
			if(!injury.can_heal() || injury.is_surgical())
				continue
			if(brute && (injury.kind & ROGUE_INJURY_BRUTE))
				return TRUE
			if(burn && (injury.kind & ROGUE_INJURY_FIRE))
				return TRUE
	return FALSE

/datum/surgery_operation/basic/rogue/tend_wounds/state_check(mob/living/patient)
	return rogue_tendable(patient, TRUE, TRUE)

/// One radial option of tending, made once.
/datum/surgery_operation/basic/rogue/tend_wounds/proc/rogue_tend_option(key, option_name, info, icon_path)
	var/datum/radial_menu_choice/option = LAZYACCESS(rogue_tend_options, key)
	if(!option)
		option = new()
		option.name = option_name
		option.info = info
		option.image = image(icon_path)
		LAZYSET(rogue_tend_options, key, option)
	return option

/// Vibelin get_radial_options(): bruises and cuts, or burns, whichever the body has; both at once for the advanced tending.
/// The arguments of each option are a fresh list, as the operation writes into them.
/datum/surgery_operation/basic/rogue/tend_wounds/get_radial_options(mob/living/patient, obj/item/tool, operating_zone)
	var/list/options = list()
	if(rogue_combo)
		options[rogue_tend_option("combo", "advanced tend wounds", "Heal a patient's superficial bruises, cuts, and burns.", /obj/item/natural/cloth)] = list(
			"[OPERATION_ACTION]" = "heal",
			"[OPERATION_BRUTE_HEAL]" = rogue_heal_flat,
			"[OPERATION_BURN_HEAL]" = rogue_heal_flat,
			"[OPERATION_BRUTE_MULTIPLIER]" = rogue_heal_share,
			"[OPERATION_BURN_MULTIPLIER]" = rogue_heal_share,
		)
		return options
	if(rogue_tendable(patient, TRUE, FALSE))
		options[rogue_tend_option("brute", "tend bruises", "Heal a patient's superficial bruises and cuts.", /obj/item/rogueweapon/surgery/hemostat)] = list(
			"[OPERATION_ACTION]" = "heal",
			"[OPERATION_BRUTE_HEAL]" = rogue_heal_flat,
			"[OPERATION_BRUTE_MULTIPLIER]" = rogue_heal_share,
		)
	if(rogue_tendable(patient, FALSE, TRUE))
		options[rogue_tend_option("burn", "tend burns", "Heal a patient's superficial burns.", /obj/item/natural/cloth)] = list(
			"[OPERATION_ACTION]" = "heal",
			"[OPERATION_BURN_HEAL]" = rogue_heal_flat,
			"[OPERATION_BURN_MULTIPLIER]" = rogue_heal_share,
		)
	return options

/// Vibelin can_loop(): another turn while the body still has injuries of the kinds tended.
/datum/surgery_operation/basic/rogue/tend_wounds/can_loop(mob/living/patient, mob/living/operating_on, mob/living/surgeon, tool, list/operation_args)
	if(!..())
		return FALSE
	return rogue_tendable(patient, operation_args[OPERATION_BRUTE_HEAL] > 0, operation_args[OPERATION_BURN_HEAL] > 0)

/// What a turn tends: the cuts and bruises, the burns, or all of them.
/datum/surgery_operation/basic/rogue/tend_wounds/proc/rogue_tend_words(list/operation_args)
	var/brute = operation_args[OPERATION_BRUTE_HEAL] > 0
	var/burn = operation_args[OPERATION_BURN_HEAL] > 0
	if(brute && burn)
		return "wounds"
	return brute ? "bruises" : "burns"

/datum/surgery_operation/basic/rogue/tend_wounds/on_preop(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	var/words = rogue_tend_words(operation_args)
	display_results(surgeon, patient, span_notice("I attempt to patch some of [patient]'s [words]."),
		span_notice("[surgeon] attempts to patch some of [patient]'s [words]."),
		span_notice("[surgeon] attempts to patch some of [patient]'s [words]."))
	display_pain(patient, "My [words] sting like hell!")

/// Vibelin skill_modifier of the tending: a journeyman and better tend more.
/datum/surgery_operation/basic/rogue/tend_wounds/proc/rogue_tend_skill_factor(mob/living/surgeon)
	switch(surgeon.rogue_skill_rank(rogue_skill_used))
		if(ROGUE_RANK_JOURNEYMAN)
			return rogue_value("surgery_tend_skill_journeyman")
		if(ROGUE_RANK_EXPERT)
			return rogue_value("surgery_tend_skill_expert")
		if(ROGUE_RANK_MASTER)
			return rogue_value("surgery_tend_skill_master")
		if(ROGUE_RANK_LEGENDARY)
			return rogue_value("surgery_tend_skill_legendary")
	return 1

/// Vibelin tend_wounds on_success(): the turn tends its share of the body's damage over the injuries it may, one by one
/// (heal_damage() returns what is left, and the limb's damage follows).
/datum/surgery_operation/basic/rogue/tend_wounds/rogue_effect(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	var/mob/living/carbon/body = patient
	if(!istype(body))
		return
	var/self_text = "I succeed in fixing some of [patient]'s wounds"
	var/other_text = "[surgeon] fixes some of [patient]'s wounds"
	var/factor = rogue_tend_skill_factor(surgeon)
	if(patient.stat == DEAD)
		factor *= rogue_value("surgery_tend_dead_factor")
	if(!patient.is_location_accessible(BODY_ZONE_CHEST, IGNORED_OPERATION_CLOTHING_SLOTS))
		factor *= rogue_value("surgery_tend_clothed_factor")
		self_text += " as best as I can while [patient.p_they()] [patient.p_have()] clothing on"
		other_text += " as best as [surgeon.p_they()] can while [patient.p_they()] [patient.p_have()] clothing on"
	var/brute_left = 0
	var/burn_left = 0
	if(operation_args[OPERATION_BRUTE_HEAL] > 0)
		brute_left = operation_args[OPERATION_BRUTE_HEAL] + round(body.get_brute_loss() * operation_args[OPERATION_BRUTE_MULTIPLIER] * factor, DAMAGE_PRECISION)
	if(operation_args[OPERATION_BURN_HEAL] > 0)
		burn_left = operation_args[OPERATION_BURN_HEAL] + round(body.get_fire_loss() * operation_args[OPERATION_BURN_MULTIPLIER] * factor, DAMAGE_PRECISION)
	for(var/obj/item/bodypart/part as anything in body.bodyparts)
		for(var/datum/rogue_injury/injury as anything in LAZYCOPY(part.rogue_injuries))
			if(brute_left <= 0 && burn_left <= 0)
				break
			if(QDELETED(injury) || !injury.can_heal() || injury.is_surgical())
				continue
			if(brute_left > 0 && (injury.kind & ROGUE_INJURY_BRUTE))
				brute_left = injury.heal_damage(brute_left)
			else if(burn_left > 0 && (injury.kind & ROGUE_INJURY_FIRE))
				burn_left = injury.heal_damage(burn_left)
	display_results(surgeon, patient, span_notice("[self_text]."), span_notice("[other_text]."), span_notice("[other_text]."))

/// Vibelin tend_wounds on_failure(): the clumsy hand cuts the body somewhere, by a share of what the turn would have tended.
/datum/surgery_operation/basic/rogue/tend_wounds/rogue_failure_effect(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	var/mob/living/carbon/body = patient
	if(!istype(body))
		return
	var/dealt = (operation_args[OPERATION_BRUTE_HEAL] + operation_args[OPERATION_BURN_HEAL]) * rogue_value("surgery_tend_fail_heal_share")
	var/loss_share = rogue_value("surgery_tend_fail_loss_share")
	if(operation_args[OPERATION_BRUTE_HEAL] > 0)
		dealt += round(body.get_brute_loss() * operation_args[OPERATION_BRUTE_MULTIPLIER] * loss_share, DAMAGE_PRECISION)
	if(operation_args[OPERATION_BURN_HEAL] > 0)
		dealt += round(body.get_fire_loss() * operation_args[OPERATION_BURN_MULTIPLIER] * loss_share, DAMAGE_PRECISION)
	var/list/parts = list()
	for(var/obj/item/bodypart/part as anything in body.bodyparts)
		if(IS_ORGANIC_LIMB(part))
			parts += part
	if(!length(parts) || dealt <= 0)
		return
	var/obj/item/bodypart/picked = pick(parts)
	picked.receive_damage(brute = dealt, wound_bonus = CANT_WOUND, sharpness = SHARP_EDGED, damage_source = isitem(tool) ? tool : null)

/// Vibelin tend_wounds/combo: a journeyman tends cuts and burns at once, quicker, a little less at a time.
/datum/surgery_operation/basic/rogue/tend_wounds/advanced
	name = "advanced tend wounds"
	desc = "Perform superficial wound care on all of a patient's cuts, bruises and burns at once."
	time = 1 SECONDS
	rogue_combo = TRUE

/datum/surgery_operation/basic/rogue/tend_wounds/advanced/rogue_read_numbers()
	. = ..()
	time = rogue_value("surgery_tend_advanced_time")
	rogue_dice_requirement = rogue_value("surgery_tend_advanced_dice")
	rogue_skill_min = rogue_value("surgery_tend_advanced_least_skill")
	rogue_skill_median = rogue_value("surgery_tend_advanced_median_skill")
	rogue_heal_flat = rogue_value("surgery_tend_advanced_heal")

// ---------------------------------------------------------------------------------------------------------------------------
// Facial reconstruction.

/// Vibelin /datum/surgery_operation/limb/plastic_surgery: through an opened head, a face mangled (Vibelin's disfigurement, or
/// TG's) is mended; a sound one is reshaped, and its bearer takes the name the surgeon gives. A failure disfigures the face.
/datum/surgery_operation/limb/rogue/plastic_surgery
	name = "facial reconstruction"
	desc = "Reshape a patient's face to fix disfigurement or make them a new person."
	implements = list(TOOL_SCALPEL = 1, ROGUE_IMPLEMENT_SHARP = 1)
	time = 6.4 SECONDS
	operation_flags = OPERATION_LOCKED | OPERATION_NO_WIKI | OPERATION_SELF_OPERABLE | OPERATION_STANDING_ALLOWED | OPERATION_NOTABLE
	preop_sound = 'sound/items/handling/surgery/scalpel1.ogg'
	success_sound = 'sound/items/handling/surgery/scalpel2.ogg'
	all_surgery_states_required = SURGERY_SKIN_OPEN
	rogue_zones = list(BODY_ZONE_HEAD)

/datum/surgery_operation/limb/rogue/plastic_surgery/rogue_read_numbers()
	. = ..()
	time = rogue_value("surgery_plastic_time")
	rogue_dice_requirement = rogue_value("surgery_plastic_dice")
	rogue_skill_min = rogue_value("surgery_plastic_least_skill")
	rogue_skill_median = rogue_value("surgery_plastic_median_skill")
	rogue_step_qualities = list(TOOL_SCALPEL = rogue_value("surgery_plastic_q_scalpel"), ROGUE_IMPLEMENT_SHARP = rogue_value("surgery_plastic_q_sharp"))

/datum/surgery_operation/limb/rogue/plastic_surgery/get_default_radial_image()
	return image(/obj/item/rogueweapon/surgery/scalpel)

/// The face is mangled: Vibelin's disfigurement (the nose cut off too), or TG's.
/datum/surgery_operation/limb/rogue/plastic_surgery/proc/rogue_disfigured(obj/item/bodypart/limb)
	return limb.rogue_has_wound(/datum/wound/rogue/facial/disfigurement) || HAS_TRAIT_FROM(limb, TRAIT_DISFIGURED, TRAIT_GENERIC)

/// Vibelin pre_preop(): a sound face is given a name first - one of ten of the patient's kind, or the surgeon's own. Then the
/// roll (operation.dm).
/datum/surgery_operation/limb/rogue/plastic_surgery/pre_preop(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	if(!rogue_disfigured(limb))
		var/mob/living/carbon/patient = limb.owner
		var/list/names = list("Custom")
		for(var/i in 1 to 10)
			names += patient.generate_random_mob_name(TRUE)
		var/choice = tgui_input_list(surgeon, "New name to assign", "Facial Reconstruction", names)
		if(choice == "Custom")
			choice = tgui_input_text(surgeon, "New name to assign", "Facial Reconstruction", patient.real_name, max_length = MAX_NAME_LEN)
		if(!choice)
			return FALSE
		operation_args[ROGUE_OPERATION_NEW_NAME] = choice
	return ..()

/datum/surgery_operation/limb/rogue/plastic_surgery/on_preop(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	display_results(surgeon, limb.owner, span_notice("I begin to alter [limb.owner]'s appearance..."),
		span_notice("[surgeon] begins to alter [limb.owner]'s appearance."),
		span_notice("[surgeon] begins to make an incision in [limb.owner]'s face."))
	display_pain(limb.owner, "I feel a slicing pain across my face!")

/datum/surgery_operation/limb/rogue/plastic_surgery/rogue_effect(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	var/mob/living/carbon/patient = limb.owner
	if(rogue_disfigured(limb))
		for(var/datum/wound/rogue/facial/disfigurement/mangled in LAZYCOPY(limb.wounds))
			qdel(mangled)
		REMOVE_TRAIT(limb, TRAIT_DISFIGURED, TRAIT_GENERIC)
		display_results(surgeon, patient, span_notice("I successfully restore [patient]'s appearance."),
			span_notice("[surgeon] successfully restores [patient]'s appearance!"),
			span_notice("[surgeon] finishes the operation on [patient]'s face."))
		display_pain(patient, "The pain fades, my face feels normal again!")
		return
	var/new_name = operation_args[ROGUE_OPERATION_NEW_NAME]
	if(!new_name)
		return
	var/old_name = patient.real_name
	patient.real_name = new_name
	if(ishuman(patient))
		var/mob/living/carbon/human/person = patient
		person.update_ID_card()
	log_game("[key_name(surgeon)] used facial reconstruction to rename [key_name(patient)] from [old_name] to [new_name].")
	display_results(surgeon, patient, span_notice("I alter [old_name]'s appearance completely, [patient.p_they()] [patient.p_are()] now [new_name]."),
		span_notice("[surgeon] alters [old_name]'s appearance completely, [patient.p_they()] [patient.p_are()] now [new_name]!"),
		span_notice("[surgeon] finishes the operation on [patient]'s face."))
	display_pain(patient, "The pain fades, my face feels new and unfamiliar!")

/// Vibelin plastic_surgery on_failure(): the face is left disfigured.
/datum/surgery_operation/limb/rogue/plastic_surgery/rogue_failure_effect(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	display_results(surgeon, limb.owner, span_warning("I screw up, leaving [limb.owner]'s appearance disfigured!"),
		span_warning("[surgeon] screws up, disfiguring [limb.owner]'s appearance!"),
		span_notice("[surgeon] finishes the operation on [limb.owner]'s face."))
	display_pain(limb.owner, "My face feels horribly scarred and deformed!")
	limb.rogue_add_wound(/datum/wound/rogue/facial/disfigurement)
	rogue_surgery_cry(limb.owner)

// ---------------------------------------------------------------------------------------------------------------------------
// The engineer's limbs.

/// Vibelin amputate/pegleg: a wooden limb is sawn off by the craft of engineering - quicker than the surgeon's way, with a saw,
/// an axe, or badly with a scalpel.
/datum/surgery_operation/limb/rogue/remove_prosthetic/wooden
	name = "detach wooden limb (engineering)"
	desc = "Saw off a patient's wooden limb using engineering skill."
	implements = list(TOOL_SAW = 1, /obj/item/rogueweapon/stoneaxe = 1, TOOL_SCALPEL = 1)
	time = 3 SECONDS
	success_sound = 'modular_redtard/rockhill/sound/foley/sewflesh.ogg'
	rogue_skill_used = /datum/attribute/skill/craft/engineering

/datum/surgery_operation/limb/rogue/remove_prosthetic/wooden/rogue_read_numbers()
	. = ..()
	time = rogue_value("surgery_detach_wood_time")
	rogue_dice_requirement = rogue_value("surgery_detach_wood_dice")
	rogue_skill_min = rogue_value("surgery_detach_wood_least_skill")
	rogue_skill_median = rogue_value("surgery_detach_wood_median_skill")
	rogue_step_qualities = list(TOOL_SAW = rogue_value("surgery_detach_wood_q_saw"), /obj/item/rogueweapon/stoneaxe = rogue_value("surgery_detach_wood_q_axe"), TOOL_SCALPEL = rogue_value("surgery_detach_wood_q_scalpel"))

/// Vibelin required_bodytype BODYPART_ROBOTIC of the pegleg: a limb of wood (the module's wooden prosthetics are TG's pegs).
/datum/surgery_operation/limb/rogue/remove_prosthetic/wooden/state_check(obj/item/bodypart/limb)
	return ..() && (limb.bodytype & BODYTYPE_PEG)

/// Vibelin limb_replacement/prosthetic: a prosthetic of wood or metal is fitted on a stump by the craft of engineering.
/datum/surgery_operation/limb/rogue/attach_limb/prosthetic
	name = "fit prosthetic (engineering)"
	desc = "Fit a prosthetic on the stump of a missing limb using engineering skill."
	rogue_skill_used = /datum/attribute/skill/craft/engineering

/datum/surgery_operation/limb/rogue/attach_limb/prosthetic/rogue_read_numbers()
	. = ..()
	time = rogue_value("surgery_fit_prosthetic_time")
	rogue_dice_requirement = rogue_value("surgery_fit_prosthetic_dice")
	rogue_skill_min = rogue_value("surgery_fit_prosthetic_least_skill")
	rogue_skill_median = rogue_value("surgery_fit_prosthetic_median_skill")
	rogue_step_qualities = list(ROGUE_IMPLEMENT_LIMB = rogue_value("surgery_fit_prosthetic_q_limb"))

/// Only a prosthetic: a limb of flesh is the surgeon's to put back.
/datum/surgery_operation/limb/rogue/attach_limb/prosthetic/rogue_part_zone(tool)
	if(isbodypart(tool))
		var/obj/item/bodypart/part = tool
		if(part.biological_state & BIO_FLESH)
			return null
	return ..()

/datum/surgery_operation/limb/rogue/attach_limb/prosthetic/rogue_option_words(obj/item/tool)
	return list("fit [tool.name]", "Fit [tool.name] on the stump of the patient's missing limb, by the craft of engineering.")

/// A prosthetic's stump takes no injury of a failure: the engineer misses the fitting, not the flesh.
/datum/surgery_operation/limb/rogue/attach_limb/prosthetic/rogue_fail_kind(tool)
	return null

#undef ROGUE_OPERATION_NEW_NAME
