#ifdef UNIT_TESTS
#define TEST_ASSERT(assertion, reason) if (!(assertion)) { return Fail("Assertion failed: [reason || "No reason"]", __FILE__, __LINE__) }
#define TEST_ASSERT_EQUAL(a, b, message) do { \
	var/lhs = ##a; \
	var/rhs = ##b; \
	if (lhs != rhs) { \
		return Fail("Expected [isnull(lhs) ? "null" : lhs] to be equal to [isnull(rhs) ? "null" : rhs].[message ? " [message]" : ""]", __FILE__, __LINE__); \
	} \
} while (FALSE)

/// The module's surgery on TG's operations (combat/surgery/), rolled Vibelin's way on the injuries and crits of block VR1. The
/// test map is not a medieval one, so the patient is given the surgery element (and the blood element, for the injuries) by
/// hand, as a medieval map gives them to every human. A step is done by TG's success() or failure(), past its roll and its
/// time. The mechanism is tested on a probe step of the test's own; the steps of combat/surgery/steps.dm and steps_vibelin.dm
/// are found by their path at run time (step_of()), so that the test builds whatever those files name.
/datum/unit_test/rogue_surgery
	abstract_type = /datum/unit_test/rogue_surgery

/datum/unit_test/rogue_surgery/proc/make_patient()
	var/mob/living/carbon/human/consistent/patient = allocate(__IMPLIED_TYPE__)
	patient.AddElement(/datum/element/rogue_blood)
	patient.AddElement(/datum/element/rogue_surgery)
	return patient

/datum/unit_test/rogue_surgery/proc/make_surgeon(rank = ROGUE_RANK_JOURNEYMAN)
	var/mob/living/carbon/human/consistent/surgeon = allocate(__IMPLIED_TYPE__)
	surgeon.rogue_set_skill(/datum/attribute/skill/misc/medicine, rank * ROGUE_SKILL_PER_RANK)
	return surgeon

/// A step of the module by its path; null when no such step is built.
/datum/unit_test/rogue_surgery/proc/step_of(path_text)
	var/path = text2path(path_text)
	return path ? GLOB.operations.operations_by_typepath[path] : null

/// The surgical injuries of a limb (Vibelin INJURY_SURGICAL).
/datum/unit_test/rogue_surgery/proc/surgical_injuries(obj/item/bodypart/limb)
	. = list()
	for(var/datum/rogue_injury/injury as anything in limb.rogue_injuries)
		if(injury.is_surgical())
			. += injury

/// The test's own step: it counts its effects and its critical rolls, and takes a scalpel, a knife (worse) and the hand.
/datum/surgery_operation/limb/rogue/rogue_test_probe
	abstract_type = /datum/surgery_operation/limb/rogue/rogue_test_probe
	name = "rogue test probe"
	desc = "A step only the unit tests do."
	var/effects = 0
	var/failure_effects = 0
	var/crit_successes = 0
	var/crit_failures = 0

/datum/surgery_operation/limb/rogue/rogue_test_probe/rogue_implements()
	return list(TOOL_SCALPEL = 1, /obj/item/knife = 2, IMPLEMENT_HAND = 3)

/datum/surgery_operation/limb/rogue/rogue_test_probe/rogue_effect(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	effects++

/datum/surgery_operation/limb/rogue/rogue_test_probe/rogue_failure_effect(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	failure_effects++

/datum/surgery_operation/limb/rogue/rogue_test_probe/rogue_on_crit_success(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	crit_successes++

/datum/surgery_operation/limb/rogue/rogue_test_probe/rogue_on_crit_failure(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	crit_failures++

/// A medieval body offers the module's operations and only those, to the skilled; a body of TG's offers none of them.
/datum/unit_test/rogue_surgery/offered

/datum/unit_test/rogue_surgery/offered/Run()
	var/mob/living/carbon/human/patient = make_patient()
	var/mob/living/carbon/human/surgeon = make_surgeon()
	var/obj/item/rogueweapon/surgery/scalpel/scalpel = allocate(__IMPLIED_TYPE__)
	TEST_ASSERT(HAS_TRAIT(patient, TRAIT_READY_TO_OPERATE), "A medieval body cannot be operated on without drapes")
	var/datum/surgery_operation/incise = step_of("/datum/surgery_operation/limb/rogue/incise")
	TEST_ASSERT(incise, "There is no incision step")
	var/list/offered = surgeon.get_available_operations(patient, scalpel, BODY_ZONE_L_ARM)
	var/incision = FALSE
	for(var/slice in offered)
		var/datum/surgery_operation/offer = offered[slice][1]
		TEST_ASSERT(offer.rogue_medieval, "A medieval body offers [offer.type], which is not the module's")
		if(offer == incise)
			incision = TRUE
	TEST_ASSERT(incision, "A scalpel cannot incise a medieval arm")
	var/mob/living/carbon/human/novice = make_surgeon(ROGUE_RANK_NONE)
	ADD_TRAIT(novice, TRAIT_ROGUE_NO_SKILLS, "rogue_surgery_test")
	if(incise.rogue_skill_min > 0)
		TEST_ASSERT(!incise.rogue_skilled(novice), "One without Medicine may incise")
	var/mob/living/carbon/human/consistent/townie = allocate(__IMPLIED_TYPE__)
	var/list/tg_offered = surgeon.get_available_operations(townie, scalpel, BODY_ZONE_L_ARM)
	for(var/slice in tg_offered)
		var/list/entry = tg_offered[slice]
		var/datum/surgery_operation/offer = entry[1]
		TEST_ASSERT(!offer.rogue_medieval, "A body of TG's offers the module's [offer.type]")

/// The ported tools answer to their steps, the cautery only while it is hot; a tool's quality is the step's and its speed's.
/datum/unit_test/rogue_surgery/tools

/datum/unit_test/rogue_surgery/tools/Run()
	var/obj/item/rogueweapon/surgery/scalpel/scalpel = allocate(__IMPLIED_TYPE__)
	TEST_ASSERT_EQUAL(scalpel.tool_behaviour, TOOL_SCALPEL, "The scalpel is no scalpel")
	TEST_ASSERT(scalpel.item_flags & SURGICAL_TOOL, "The scalpel is no surgical tool")
	var/obj/item/rogueweapon/surgery/hemostat/improv/clamp = allocate(__IMPLIED_TYPE__)
	TEST_ASSERT_EQUAL(clamp.tool_behaviour, ROGUE_TOOL_IMPROVISED_HEMOSTAT, "The improvised clamp is no clamp")
	var/obj/item/rogueweapon/surgery/cautery/cautery = allocate(__IMPLIED_TYPE__)
	TEST_ASSERT_NULL(cautery.tool_behaviour, "A cold cautery sears")
	cautery.rogue_heat(10 SECONDS)
	TEST_ASSERT_EQUAL(cautery.tool_behaviour, TOOL_CAUTERY, "A hot cautery does not sear")
	TEST_ASSERT(cautery.get_temperature() >= FIRE_MINIMUM_TEMPERATURE_TO_EXIST, "A hot cautery is not hot")
	var/datum/surgery_operation/limb/rogue/rogue_test_probe/probe = allocate(__IMPLIED_TYPE__)
	var/obj/item/knife/kitchen/knife = allocate(__IMPLIED_TYPE__)
	TEST_ASSERT_EQUAL(probe.rogue_implement(scalpel), TOOL_SCALPEL, "A scalpel is not the probe's scalpel")
	TEST_ASSERT_EQUAL(probe.rogue_implement(knife), /obj/item/knife, "A knife is not the probe's knife")
	TEST_ASSERT_EQUAL(probe.rogue_implement(IMPLEMENT_HAND), IMPLEMENT_HAND, "The probe cannot be done by hand")
	TEST_ASSERT_NULL(probe.rogue_implement(clamp), "A clamp does for the probe")
	TEST_ASSERT_EQUAL(probe.rogue_tool_quality(clamp), 0, "A tool the step does not take has a quality")
	TEST_ASSERT(abs(probe.rogue_tool_quality(knife) - 2 * knife.toolspeed) < 0.001, "A knife's quality is not the step's times its speed")
	TEST_ASSERT_EQUAL(probe.rogue_fail_kind(scalpel), ROGUE_INJURY_SLASH, "A scalpel's failure is no cut")
	TEST_ASSERT_EQUAL(probe.rogue_fail_kind(cautery), ROGUE_INJURY_BURN, "A hot cautery's failure is no burn")
	TEST_ASSERT_EQUAL(probe.rogue_fail_kind(IMPLEMENT_HAND), ROGUE_INJURY_BLUNT, "A failure by hand is no bruise")
	cautery.rogue_set_heated(FALSE)
	TEST_ASSERT_NULL(cautery.tool_behaviour, "A cooled cautery still sears")
	// Ratwood's chances still work: a step's chance in percent is its quality's reciprocal.
	var/datum/surgery_operation/incise = step_of("/datum/surgery_operation/limb/rogue/incise")
	TEST_ASSERT(incise, "There is no incision step")
	TEST_ASSERT(incise.rogue_tool_quality(scalpel) > 0, "A scalpel cannot incise")
	TEST_ASSERT_NULL(incise.rogue_implement(IMPLEMENT_HAND), "A bare hand can incise")

/// Vibelin's requirement: each part moves it by its own share - the surgeon's skill over the median, the tool's quality, the
/// place, an overseer - and the requirement rolled is whole and within the dice.
/datum/unit_test/rogue_surgery/requirement

/datum/unit_test/rogue_surgery/requirement/Run()
	var/mob/living/carbon/human/patient = make_patient()
	var/mob/living/carbon/human/journeyman = make_surgeon(ROGUE_RANK_JOURNEYMAN)
	var/mob/living/carbon/human/expert = make_surgeon(ROGUE_RANK_EXPERT)
	var/obj/item/rogueweapon/surgery/scalpel/scalpel = allocate(__IMPLIED_TYPE__)
	var/obj/item/knife/kitchen/knife = allocate(__IMPLIED_TYPE__)
	var/obj/item/bodypart/arm = patient.get_bodypart(BODY_ZONE_L_ARM)
	var/datum/surgery_operation/limb/rogue/rogue_test_probe/probe = allocate(__IMPLIED_TYPE__)
	probe.rogue_refresh_numbers()
	TEST_ASSERT_EQUAL(probe.rogue_dice_requirement, rogue_value("surgery_dice_requirement"), "A step without a requirement of its own does not take the default")
	TEST_ASSERT_EQUAL(probe.rogue_skill_min, rogue_value("surgery_skill_min"), "A step without a least skill of its own does not take the default")
	var/skill_share = (probe.rogue_surgery_skill(expert) - probe.rogue_surgery_skill(journeyman)) * rogue_value("surgery_roll_skill")
	var/skill_moved = probe.rogue_requirement_raw(arm, expert, scalpel) - probe.rogue_requirement_raw(arm, journeyman, scalpel)
	TEST_ASSERT(abs(skill_moved - skill_share) < 0.001, "The surgeon's skill moves the requirement by [skill_moved], not [skill_share]")
	var/tool_share = (probe.rogue_tool_quality(knife) - probe.rogue_tool_quality(scalpel)) * rogue_value("surgery_roll_tool")
	var/tool_moved = probe.rogue_requirement_raw(arm, journeyman, scalpel) - probe.rogue_requirement_raw(arm, journeyman, knife)
	TEST_ASSERT(abs(tool_moved - tool_share) < 0.001, "The tool moves the requirement by [tool_moved], not [tool_share]")
	TEST_ASSERT_EQUAL(probe.rogue_place_modifier(arm), rogue_value("surgery_place_standing"), "A patient standing is not operated on as standing")
	patient.set_body_position(LYING_DOWN)
	TEST_ASSERT_EQUAL(probe.rogue_place_modifier(arm), rogue_value("surgery_place_floor"), "A patient on the floor is not operated on as on the floor")
	var/on_floor = probe.rogue_requirement_raw(arm, journeyman, scalpel)
	allocate(/obj/structure/table, get_turf(patient))
	var/table_modifier = probe.rogue_place_modifier(arm)
	TEST_ASSERT_EQUAL(table_modifier, min(rogue_value("surgery_place_floor"), rogue_value("surgery_place_table")), "A patient on a table is not operated on as on a table")
	var/place_share = (rogue_value("surgery_place_floor") - table_modifier) * rogue_value("surgery_roll_place")
	var/place_moved = probe.rogue_requirement_raw(arm, journeyman, scalpel) - on_floor
	TEST_ASSERT(abs(place_moved - place_share) < 0.001, "The table moves the requirement by [place_moved], not [place_share]")
	var/overseer_moved = probe.rogue_requirement_raw(arm, journeyman, scalpel, 2) - probe.rogue_requirement_raw(arm, journeyman, scalpel)
	TEST_ASSERT(abs(overseer_moved - 2 * rogue_value("surgery_roll_overseer")) < 0.001, "An overseer's bonus does not move the requirement by its share")
	var/dice = rogue_value("surgery_dice_count")
	var/requirement = probe.rogue_roll_requirement(arm, journeyman, scalpel)
	TEST_ASSERT(requirement >= dice && requirement <= dice * rogue_value("surgery_dice_sides"), "The requirement [requirement] is out of the dice")
	TEST_ASSERT_EQUAL(requirement, round(requirement), "The requirement is not whole")
	TEST_ASSERT(probe.rogue_crit_margin() >= rogue_value("surgery_crit_margin_least"), "A step's critical margin is under the least")

/// A better surgeon in sight steadies a weak one by how far over the step's median they are; one under the median or no better
/// does not, nor the patient, nor anyone for a surgeon of the median.
/datum/unit_test/rogue_surgery/overseer

/datum/unit_test/rogue_surgery/overseer/Run()
	var/mob/living/carbon/human/patient = make_patient()
	var/mob/living/carbon/human/surgeon = make_surgeon(ROGUE_RANK_NOVICE)
	var/mob/living/carbon/human/master = make_surgeon(ROGUE_RANK_MASTER)
	var/datum/surgery_operation/limb/rogue/rogue_test_probe/probe = allocate(__IMPLIED_TYPE__)
	probe.rogue_refresh_numbers()
	probe.rogue_skill_median = ROGUE_RANK_JOURNEYMAN * ROGUE_SKILL_PER_RANK
	master.forceMove(get_step(surgeon, EAST))
	var/expected = (probe.rogue_surgery_skill(master) - probe.rogue_skill_median) * rogue_value("surgery_overseer_per_skill")
	TEST_ASSERT(abs(probe.rogue_overseer_bonus(surgeon, patient) - expected) < 0.001, "A master in sight does not steady a novice by their skill")
	TEST_ASSERT_EQUAL(probe.rogue_overseer_bonus(surgeon, master), 0, "The patient steadies the surgeon")
	TEST_ASSERT_EQUAL(probe.rogue_overseer_bonus(master, patient), 0, "A surgeon over the median is steadied")

/// The roll: one of the four results; a lost one fails the step (TG's force fail), a won one does not; a step failed on purpose
/// is not rolled.
/datum/unit_test/rogue_surgery/roll

/datum/unit_test/rogue_surgery/roll/Run()
	var/mob/living/carbon/human/patient = make_patient()
	var/mob/living/carbon/human/surgeon = make_surgeon()
	var/obj/item/rogueweapon/surgery/scalpel/scalpel = allocate(__IMPLIED_TYPE__)
	var/obj/item/bodypart/arm = patient.get_bodypart(BODY_ZONE_L_ARM)
	var/datum/surgery_operation/limb/rogue/rogue_test_probe/probe = allocate(__IMPLIED_TYPE__)
	for(var/attempt in 1 to 30)
		var/list/operation_args = list()
		var/result = probe.rogue_roll(arm, surgeon, scalpel, operation_args)
		TEST_ASSERT(result in list(ROGUE_DICE_CRIT_FAILURE, ROGUE_DICE_FAILURE, ROGUE_DICE_SUCCESS, ROGUE_DICE_CRIT_SUCCESS), "The roll gave [result]")
		TEST_ASSERT_EQUAL(operation_args[ROGUE_OPERATION_ROLL], result, "The roll is not kept")
		TEST_ASSERT(!isnull(operation_args[ROGUE_OPERATION_REQUIREMENT]), "The requirement is not kept")
		TEST_ASSERT_EQUAL(!!operation_args[OPERATION_FORCE_FAIL], result <= ROGUE_DICE_FAILURE, "A [result] roll does not fail the step as it should")
		TEST_ASSERT(!operation_args[ROGUE_OPERATION_ON_PURPOSE], "A step not failed on purpose is taken as one")
	var/list/on_purpose = list(OPERATION_FORCE_FAIL = TRUE)
	TEST_ASSERT_EQUAL(probe.rogue_roll(arm, surgeon, scalpel, on_purpose), ROGUE_DICE_FAILURE, "A step failed on purpose is won")
	TEST_ASSERT(on_purpose[ROGUE_OPERATION_ON_PURPOSE], "A step failed on purpose is not known as one")
	TEST_ASSERT_NULL(on_purpose[ROGUE_OPERATION_REQUIREMENT], "A step failed on purpose is rolled")
	var/mob/living/carbon/human/novice = make_surgeon(ROGUE_RANK_NONE)
	ADD_TRAIT(novice, TRAIT_ROGUE_NO_SKILLS, "rogue_surgery_test")
	TEST_ASSERT(!probe.rogue_skilled(novice) == (probe.rogue_skill_min > 0), "The least skill does not gate the step")
	TEST_ASSERT(probe.rogue_speed(arm, make_surgeon(ROGUE_RANK_LEGENDARY), scalpel) <= probe.rogue_speed(arm, make_surgeon(ROGUE_RANK_NOVICE), scalpel), "A legendary surgeon is slower than a novice")

/// Success does the step, a critical one its own besides; failure leaves a dirty surgical injury at the site, a critical one
/// its own besides; a body of TG's takes no injury.
/datum/unit_test/rogue_surgery/outcome

/datum/unit_test/rogue_surgery/outcome/Run()
	var/mob/living/carbon/human/patient = make_patient()
	var/mob/living/carbon/human/surgeon = make_surgeon()
	var/obj/item/rogueweapon/surgery/scalpel/scalpel = allocate(__IMPLIED_TYPE__)
	var/obj/item/bodypart/arm = patient.get_bodypart(BODY_ZONE_L_ARM)
	var/datum/surgery_operation/limb/rogue/rogue_test_probe/probe = allocate(__IMPLIED_TYPE__)
	UNLINT(probe.success(arm, surgeon, scalpel, list(ROGUE_OPERATION_ROLL = ROGUE_DICE_SUCCESS)))
	TEST_ASSERT_EQUAL(probe.effects, 1, "A won step did nothing")
	TEST_ASSERT_EQUAL(probe.crit_successes, 0, "A plain success was critical")
	UNLINT(probe.success(arm, surgeon, scalpel, list(ROGUE_OPERATION_ROLL = ROGUE_DICE_CRIT_SUCCESS)))
	TEST_ASSERT_EQUAL(probe.effects, 2, "A critically won step did nothing")
	TEST_ASSERT_EQUAL(probe.crit_successes, 1, "A critical success did nothing of its own")
	TEST_ASSERT(!length(surgical_injuries(arm)), "A won step left an injury")
	var/brute = arm.brute_dam
	var/list/failed = list(ROGUE_OPERATION_ROLL = ROGUE_DICE_FAILURE)
	UNLINT(probe.failure(arm, surgeon, scalpel, failed))
	TEST_ASSERT(failed[ROGUE_OPERATION_FAILED], "A failed step is not known as failed")
	TEST_ASSERT_EQUAL(probe.failure_effects, 1, "A failed step did not do its own failure")
	TEST_ASSERT_EQUAL(probe.crit_failures, 0, "A plain failure was critical")
	var/list/injuries = surgical_injuries(arm)
	TEST_ASSERT_EQUAL(length(injuries), 1, "A failed step left [length(injuries)] surgical injuries, not one")
	var/datum/rogue_injury/cut = injuries[1]
	TEST_ASSERT(cut.kind & ROGUE_INJURY_SLASH, "A failed cut is no cut")
	TEST_ASSERT(cut.germ_level > 0, "A failed step left a clean injury")
	TEST_ASSERT(arm.brute_dam > brute, "A failed step did not hurt the limb")
	UNLINT(probe.failure(arm, surgeon, scalpel, list(ROGUE_OPERATION_ROLL = ROGUE_DICE_CRIT_FAILURE)))
	TEST_ASSERT_EQUAL(probe.crit_failures, 1, "A critical failure did nothing of its own")
	TEST_ASSERT_EQUAL(length(surgical_injuries(arm)), 2, "A critical failure left no injury of its own")
	var/mob/living/carbon/human/consistent/townie = allocate(__IMPLIED_TYPE__)
	var/obj/item/bodypart/townie_arm = townie.get_bodypart(BODY_ZONE_L_ARM)
	UNLINT(probe.failure(townie_arm, surgeon, scalpel, list(ROGUE_OPERATION_ROLL = ROGUE_DICE_FAILURE)))
	TEST_ASSERT(!length(townie_arm.rogue_injuries), "A body of TG's took an injury from a failed step")

/// The incision is a surgical injury that opens the site; retracting opens the skin; searing closes the site and its incision.
/datum/unit_test/rogue_surgery/incision

/datum/unit_test/rogue_surgery/incision/Run()
	var/mob/living/carbon/human/patient = make_patient()
	var/mob/living/carbon/human/surgeon = make_surgeon()
	var/obj/item/rogueweapon/surgery/scalpel/scalpel = allocate(__IMPLIED_TYPE__)
	var/obj/item/rogueweapon/surgery/retractor/retractor = allocate(__IMPLIED_TYPE__)
	var/obj/item/rogueweapon/surgery/cautery/cautery = allocate(__IMPLIED_TYPE__)
	var/obj/item/bodypart/arm = patient.get_bodypart(BODY_ZONE_L_ARM)
	var/datum/surgery_operation/incise = step_of("/datum/surgery_operation/limb/rogue/incise")
	var/datum/surgery_operation/retract = step_of("/datum/surgery_operation/limb/rogue/retract")
	var/datum/surgery_operation/cauterize = step_of("/datum/surgery_operation/limb/rogue/cauterize")
	TEST_ASSERT(incise && retract && cauterize, "The incision, retracting or searing step is missing")
	UNLINT(incise.success(arm, surgeon, scalpel, list(ROGUE_OPERATION_ROLL = ROGUE_DICE_SUCCESS)))
	TEST_ASSERT(LIMB_HAS_SURGERY_STATE(arm, SURGERY_SKIN_CUT), "An incision did not cut the skin")
	var/list/incisions = arm.rogue_open_incisions()
	TEST_ASSERT(length(incisions), "An incision left no surgical injury")
	var/datum/rogue_injury/incision = incisions[1]
	TEST_ASSERT(incision.kind & ROGUE_INJURY_SLASH, "An incision is no cut")
	TEST_ASSERT_NULL(arm.get_wound_type(/datum/wound/rogue/incision), "An incision is still a wound of TG's")
	UNLINT(retract.success(arm, surgeon, retractor, list(ROGUE_OPERATION_ROLL = ROGUE_DICE_SUCCESS)))
	TEST_ASSERT(LIMB_HAS_SURGERY_STATE(arm, SURGERY_SKIN_OPEN), "Retracting did not open the skin")
	TEST_ASSERT(length(arm.rogue_open_incisions()), "Retracting closed the incision")
	cautery.rogue_heat(10 SECONDS)
	var/burn = arm.burn_dam
	UNLINT(cauterize.success(arm, surgeon, cautery, list(ROGUE_OPERATION_ROLL = ROGUE_DICE_SUCCESS)))
	TEST_ASSERT(!LIMB_HAS_ANY_SURGERY_STATE(arm, ALL_SURGERY_STATES_UNSET_ON_CLOSE), "Searing did not close the site")
	TEST_ASSERT(!length(arm.rogue_open_incisions()), "Searing left the incision open")
	TEST_ASSERT(arm.burn_dam > burn, "Searing did not burn")

/// Searing closes a torn artery, not a broken bone, and sears a stump.
/datum/unit_test/rogue_surgery/searing

/datum/unit_test/rogue_surgery/searing/Run()
	var/mob/living/carbon/human/patient = make_patient()
	var/mob/living/carbon/human/surgeon = make_surgeon()
	var/obj/item/rogueweapon/surgery/cautery/cautery = allocate(__IMPLIED_TYPE__)
	cautery.rogue_heat(10 SECONDS)
	var/obj/item/bodypart/arm = patient.get_bodypart(BODY_ZONE_L_ARM)
	var/datum/surgery_operation/cauterize = step_of("/datum/surgery_operation/limb/rogue/cauterize")
	TEST_ASSERT(cauterize, "There is no searing step")
	var/datum/wound/rogue/artery/artery = patient.cause_wound_of_type_and_severity(WOUND_SLASH, arm, WOUND_SEVERITY_CRITICAL)
	TEST_ASSERT(istype(artery), "A critical cut did not tear the artery")
	UNLINT(cauterize.success(arm, surgeon, cautery, list(ROGUE_OPERATION_ROLL = ROGUE_DICE_SUCCESS)))
	TEST_ASSERT(QDELETED(artery) || !artery.rogue_cauterizable(), "Searing did not close the artery")
	var/datum/wound/rogue/fracture/fracture = arm.rogue_add_wound(/datum/wound/rogue/fracture, TRUE)
	TEST_ASSERT(fracture && !fracture.rogue_cauterizable(), "A broken bone can be seared")
	patient.rogue_add_stump()
	var/datum/wound/rogue_stump/stump = locate() in patient.all_wounds
	TEST_ASSERT(stump, "Could not leave a stump")
	var/integrity = stump.integrity
	UNLINT(cauterize.success(patient.get_bodypart(BODY_ZONE_CHEST), surgeon, cautery, list(ROGUE_OPERATION_ROLL = ROGUE_DICE_SUCCESS)))
	TEST_ASSERT(QDELETED(stump) || stump.integrity < integrity, "Searing the chest did not sear the stump")

/// Bones are crits of VR1: a dislocation is put back, a broken bone is set.
/datum/unit_test/rogue_surgery/bones

/datum/unit_test/rogue_surgery/bones/Run()
	var/mob/living/carbon/human/patient = make_patient()
	var/mob/living/carbon/human/surgeon = make_surgeon()
	var/obj/item/rogueweapon/surgery/bonesetter/bonesetter = allocate(__IMPLIED_TYPE__)
	var/datum/surgery_operation/relocate = step_of("/datum/surgery_operation/limb/rogue/relocate")
	var/datum/surgery_operation/set_bone = step_of("/datum/surgery_operation/limb/rogue/set_bone")
	TEST_ASSERT(relocate && set_bone, "The relocating or bone setting step is missing")
	var/obj/item/bodypart/arm = patient.get_bodypart(BODY_ZONE_L_ARM)
	var/datum/wound/rogue/dislocation/dislocation = arm.rogue_add_wound(/datum/wound/rogue/dislocation, TRUE)
	TEST_ASSERT(dislocation, "Could not dislocate the arm")
	TEST_ASSERT_NULL(arm.get_wound_type(/datum/wound/blunt/bone), "A dislocated medieval arm has a wound of TG's")
	UNLINT(relocate.success(arm, surgeon, bonesetter, list(ROGUE_OPERATION_ROLL = ROGUE_DICE_SUCCESS)))
	TEST_ASSERT(QDELETED(dislocation) || !dislocation.rogue_settable(), "Relocating left the arm dislocated")
	var/obj/item/bodypart/leg = patient.get_bodypart(BODY_ZONE_L_LEG)
	var/datum/wound/rogue/fracture/fracture = leg.rogue_add_wound(/datum/wound/rogue/fracture, TRUE)
	TEST_ASSERT(fracture, "Could not break the leg")
	TEST_ASSERT(fracture.rogue_settable(), "A broken leg cannot be set")
	UNLINT(set_bone.success(leg, surgeon, bonesetter, list(ROGUE_OPERATION_ROLL = ROGUE_DICE_SUCCESS)))
	TEST_ASSERT(QDELETED(fracture) || !fracture.rogue_settable(), "Setting did not set the bone")

/// Sawn, an arm is cut off and leaves a stump; a wooden prosthetic goes on in its place, a real limb that comes off as the
/// prosthetic again. A severed leg put back must be sewn on.
/datum/unit_test/rogue_surgery/limbs

/datum/unit_test/rogue_surgery/limbs/Run()
	var/mob/living/carbon/human/patient = make_patient()
	var/mob/living/carbon/human/surgeon = make_surgeon()
	var/obj/item/rogueweapon/surgery/saw/saw = allocate(__IMPLIED_TYPE__)
	var/datum/surgery_operation/saw_bone = step_of("/datum/surgery_operation/limb/rogue/saw")
	var/datum/surgery_operation/amputate = step_of("/datum/surgery_operation/limb/rogue/amputate")
	TEST_ASSERT(saw_bone && amputate, "The sawing or amputating step is missing")
	var/obj/item/bodypart/arm = patient.get_bodypart(BODY_ZONE_L_ARM)
	UNLINT(saw_bone.success(arm, surgeon, saw, list(ROGUE_OPERATION_ROLL = ROGUE_DICE_SUCCESS)))
	TEST_ASSERT(LIMB_HAS_SURGERY_STATE(arm, SURGERY_BONE_SAWED) || arm.rogue_has_wound(/datum/wound/rogue/fracture), "Sawing did not cut the bone")
	UNLINT(amputate.success(arm, surgeon, saw, list(ROGUE_OPERATION_ROLL = ROGUE_DICE_SUCCESS)))
	TEST_ASSERT_NULL(patient.get_bodypart(BODY_ZONE_L_ARM), "The amputated arm is still attached")
	var/obj/item/bodypart/stump_part = patient.get_bodypart(BODY_ZONE_L_ARM, TRUE)
	TEST_ASSERT(stump_part && IS_STUMP(stump_part), "The amputated arm left no stump to put a limb on")
	var/obj/item/bodypart/l_arm/prosthetic/woodleft/kit = allocate(__IMPLIED_TYPE__)
	TEST_ASSERT_EQUAL(kit.rogue_prosthetic_zone(), BODY_ZONE_L_ARM, "The wooden left arm is no left arm")
	var/obj/item/bodypart/wooden = rogue_attach_part(kit, patient)
	TEST_ASSERT(wooden, "The wooden arm did not go on")
	TEST_ASSERT_EQUAL(patient.get_bodypart(BODY_ZONE_L_ARM), wooden, "The wooden arm is not the patient's arm")
	TEST_ASSERT(istype(wooden, /obj/item/bodypart/arm/left/ghetto/rogue_prosthetic), "The wooden arm is no peg arm")
	TEST_ASSERT_EQUAL(kit.loc, wooden, "The prosthetic is not kept in the limb it made")
	TEST_ASSERT_EQUAL(wooden.max_damage, rogue_value("surgery_prosthetic_wood_left_arm_damage"), "The wooden left arm is not as tough as Ratwood's")
	TEST_ASSERT(!(wooden.biological_state & BIO_FLESH), "The wooden arm is of flesh")
	TEST_ASSERT_NULL(wooden.get_wound_type(/datum/wound/rogue/replantation), "A wooden arm needs sewing on")
	wooden.drop_limb()
	wooden.rogue_revert_prosthetic()
	TEST_ASSERT(QDELETED(wooden), "The wooden arm stayed a limb after it came off")
	TEST_ASSERT(isturf(kit.loc), "The prosthetic did not come back when the arm came off")
	var/obj/item/bodypart/leg = patient.get_bodypart(BODY_ZONE_L_LEG)
	TEST_ASSERT(patient.rogue_dismember(leg, saw, surgeon, "l_leg"), "Could not sever the leg")
	var/datum/wound/rogue_stump/stump = locate() in patient.all_wounds
	TEST_ASSERT(stump, "The severed leg left no bleeding stump")
	var/obj/item/bodypart/put_back = rogue_attach_part(leg, patient)
	TEST_ASSERT_EQUAL(put_back, leg, "The severed leg did not go back on")
	TEST_ASSERT(QDELETED(stump), "The leg put back left its stump bleeding")
	var/datum/wound/rogue/replantation/replantation = leg.get_wound_type(/datum/wound/rogue/replantation)
	TEST_ASSERT(replantation, "A leg put back needs no sewing on")
	TEST_ASSERT(HAS_TRAIT(leg, TRAIT_PARALYSIS), "A leg put back serves before it is sewn on")
	TEST_ASSERT(replantation.rogue_sew_threshold() > 0, "A leg put back cannot be sewn on")
	replantation.rogue_sew_done()
	TEST_ASSERT(!HAS_TRAIT(leg, TRAIT_PARALYSIS), "A leg sewn on does not serve")

/// Bloodletting: a vein of an arm is cut and bleeds, and the bad blood forced out takes toxins with it.
/datum/unit_test/rogue_surgery/bloodletting

/datum/unit_test/rogue_surgery/bloodletting/Run()
	var/mob/living/carbon/human/patient = make_patient()
	var/mob/living/carbon/human/surgeon = make_surgeon(ROGUE_RANK_EXPERT)
	var/obj/item/rogueweapon/surgery/scalpel/scalpel = allocate(__IMPLIED_TYPE__)
	var/datum/surgery_operation/cut_vein = step_of("/datum/surgery_operation/limb/rogue/cut_vein")
	var/datum/surgery_operation/bloodlet = step_of("/datum/surgery_operation/limb/rogue/bloodlet")
	TEST_ASSERT(cut_vein && bloodlet, "The vein cutting or bloodletting step is missing")
	var/obj/item/bodypart/arm = patient.get_bodypart(BODY_ZONE_R_ARM)
	var/bleeding = arm.rogue_limb_bleed_rate()
	UNLINT(cut_vein.success(arm, surgeon, scalpel, list(ROGUE_OPERATION_ROLL = ROGUE_DICE_SUCCESS)))
	TEST_ASSERT(arm.rogue_limb_bleed_rate() > bleeding, "A cut vein does not bleed")
	patient.adjust_tox_loss(40)
	var/toxins = patient.get_tox_loss()
	var/blood = patient.get_blood_volume()
	UNLINT(bloodlet.success(arm, surgeon, IMPLEMENT_HAND, list(ROGUE_OPERATION_ROLL = ROGUE_DICE_SUCCESS)))
	TEST_ASSERT(patient.get_tox_loss() < toxins, "Bloodletting drew no toxins out")
	TEST_ASSERT(patient.get_blood_volume() < blood, "Bloodletting let no blood out")

/// Mouth to mouth gives breath.
/datum/unit_test/rogue_surgery/breath

/datum/unit_test/rogue_surgery/breath/Run()
	var/mob/living/carbon/human/patient = make_patient()
	var/mob/living/carbon/human/surgeon = make_surgeon()
	var/datum/surgery_operation/breathe = step_of("/datum/surgery_operation/limb/rogue/mouth_to_mouth")
	TEST_ASSERT(breathe, "There is no mouth to mouth step")
	patient.adjust_oxy_loss(50)
	var/oxygen = patient.get_oxy_loss()
	UNLINT(breathe.success(patient.get_bodypart(BODY_ZONE_HEAD), surgeon, IMPLEMENT_HAND, list(ROGUE_OPERATION_ROLL = ROGUE_DICE_SUCCESS)))
	TEST_ASSERT(patient.get_oxy_loss() < oxygen, "A breath did not ease the choking")

/// The artificer's contraptions become Ratwood's limb of their metal where the porter brings it.
/datum/unit_test/rogue_surgery/contraptions

/datum/unit_test/rogue_surgery/contraptions/Run()
	TEST_ASSERT_EQUAL(rogue_ratwood_prosthetic_path(ROGUE_PROSTHETIC_BRONZE, BODY_ZONE_R_ARM), "/obj/item/bodypart/r_arm/prosthetic/bronzeright", "The bronze right arm is not Ratwood's")
	TEST_ASSERT(text2path(rogue_ratwood_prosthetic_path(ROGUE_PROSTHETIC_BRONZE, BODY_ZONE_R_ARM)), "The porter brings no bronze right arm")
	TEST_ASSERT_EQUAL(rogue_prosthetic_material_of(/obj/item/bodypart/r_arm/prosthetic/bronzeright), ROGUE_PROSTHETIC_BRONZE, "The bronze right arm is not of bronze")
	TEST_ASSERT_EQUAL(rogue_prosthetic_material_of(/obj/item/bodypart/r_leg/prosthetic), ROGUE_PROSTHETIC_WOOD, "The wooden leg is not of wood")
	var/obj/item/contraption/ironprosthetic/iron = allocate(__IMPLIED_TYPE__)
	TEST_ASSERT_NULL(iron.rogue_prosthetic_zone(), "An iron prosthetic not yet shaped replaces a limb")
	iron.rogue_limb_zone = BODY_ZONE_R_LEG
	TEST_ASSERT_EQUAL(iron.rogue_prosthetic_zone(), BODY_ZONE_R_LEG, "A shaped iron leg replaces no leg")
	TEST_ASSERT_EQUAL(rogue_prosthetic_limb_type(iron.rogue_prosthetic_zone(), iron.rogue_prosthetic_material()), /obj/item/bodypart/leg/right/robot/surplus/rogue_prosthetic, "An iron leg is no metal leg")

#undef TEST_ASSERT
#undef TEST_ASSERT_EQUAL
#endif
