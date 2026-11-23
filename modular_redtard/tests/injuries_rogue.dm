#ifdef UNIT_TESTS
#define TEST_ASSERT(assertion, reason) if (!(assertion)) { return Fail("Assertion failed: [reason || "No reason"]", __FILE__, __LINE__) }
#define TEST_ASSERT_EQUAL(a, b, message) do { \
	var/lhs = ##a; \
	var/rhs = ##b; \
	if (lhs != rhs) { \
		return Fail("Expected [isnull(lhs) ? "null" : lhs] to be equal to [isnull(rhs) ? "null" : rhs].[message ? " [message]" : ""]", __FILE__, __LINE__); \
	} \
} while (FALSE)

/// Vibelin's injuries and germs (combat/injuries/). The test map is not a medieval one, so the patient is given the blood
/// element by hand, as a medieval map gives it to every human. The checks hold whatever the numbers are (open files: 10).
/datum/unit_test/rogue_injuries
	abstract_type = /datum/unit_test/rogue_injuries

/datum/unit_test/rogue_injuries/proc/make_patient()
	var/mob/living/carbon/human/consistent/patient = allocate(__IMPLIED_TYPE__)
	patient.AddElement(/datum/element/rogue_blood)
	return patient

/// Damage of the limb's injuries of blows (or of burns).
/datum/unit_test/rogue_injuries/proc/injury_damage(obj/item/bodypart/limb, fire)
	. = 0
	for(var/datum/rogue_injury/injury as anything in limb.rogue_injuries)
		if(!injury.is_fire() == !fire)
			. += injury.damage

/// Every type a blow can open has its numbers: its stages are read and named.
/datum/unit_test/rogue_injuries/types

/datum/unit_test/rogue_injuries/types/Run()
	for(var/kind in list(ROGUE_INJURY_BLUNT, ROGUE_INJURY_SLASH, ROGUE_INJURY_PUNCTURE, ROGUE_INJURY_BITE, ROGUE_INJURY_LASH, ROGUE_INJURY_BURN, ROGUE_INJURY_INTENSE_BURN, ROGUE_INJURY_INTERNAL, ROGUE_INJURY_DIVINE))
		for(var/mechanical in list(FALSE, TRUE))
			var/list/steps = rogue_injury_pick_list(kind, mechanical)
			TEST_ASSERT(length(steps), "No injury of kind [kind] for [mechanical ? "a prosthesis" : "flesh"]")
			for(var/path in steps)
				var/datum/rogue_injury/injury = new path(1)
				var/fire_match = (kind & ROGUE_INJURY_FIRE) && (injury.kind & ROGUE_INJURY_FIRE)
				TEST_ASSERT((injury.kind & kind) || fire_match, "[path] is not of the kind it is picked for")
				TEST_ASSERT(!injury.mechanical == !mechanical, "[path] is picked for the wrong body")
				TEST_ASSERT(length(injury.stage_damage) && length(injury.stage_damage) == length(injury.stage_names), "[path] has no numbers for its stages")
				TEST_ASSERT(injury.desc in injury.stage_names, "[path] has no stage name")
				qdel(injury)
	TEST_ASSERT_EQUAL(rogue_injury_kind_for_bclass(BCLASS_CHOP), ROGUE_INJURY_SLASH, "A chop does not cut")
	TEST_ASSERT_EQUAL(rogue_injury_kind_for_bclass(BCLASS_PICK), ROGUE_INJURY_PUNCTURE, "A pick does not puncture")
	TEST_ASSERT_EQUAL(rogue_injury_kind_for_bclass(BCLASS_SMASH), ROGUE_INJURY_BLUNT, "A smash does not bruise")

/// TG's damage of a limb is the truth and the injuries follow it: a cut opens a cut, a burn a burn, healing mends them, and a
/// full heal leaves none.
/datum/unit_test/rogue_injuries/mirror

/datum/unit_test/rogue_injuries/mirror/Run()
	var/mob/living/carbon/human/patient = make_patient()
	var/obj/item/bodypart/arm = patient.get_bodypart(BODY_ZONE_L_ARM)
	patient.apply_damage(20, BRUTE, arm, sharpness = SHARP_EDGED)
	TEST_ASSERT(length(arm.rogue_injuries), "A cut opened no injury")
	var/datum/rogue_injury/cut = arm.rogue_injuries[1]
	TEST_ASSERT(cut.kind & ROGUE_INJURY_SLASH, "A cut opened an injury of another kind")
	TEST_ASSERT(abs(injury_damage(arm, FALSE) - arm.brute_dam) < 0.5, "The injuries do not match the limb's brute damage")
	patient.apply_damage(10, BURN, arm)
	TEST_ASSERT(abs(injury_damage(arm, TRUE) - arm.burn_dam) < 0.5, "The burns do not match the limb's burn damage")
	arm.heal_damage(5, 5)
	TEST_ASSERT(abs(injury_damage(arm, FALSE) - arm.brute_dam) < 0.5, "Healing the limb did not mend its injuries")
	TEST_ASSERT(abs(injury_damage(arm, TRUE) - arm.burn_dam) < 0.5, "Healing the limb did not mend its burns")
	patient.fully_heal(HEAL_ALL)
	TEST_ASSERT(!length(arm.rogue_injuries), "A full heal left injuries")
	var/mob/living/carbon/human/consistent/plain = allocate(__IMPLIED_TYPE__)
	var/obj/item/bodypart/plain_chest = plain.get_bodypart(BODY_ZONE_CHEST)
	plain.apply_damage(20, BRUTE, plain_chest, sharpness = SHARP_EDGED)
	TEST_ASSERT(!length(plain_chest.rogue_injuries), "A body of a modern map took injuries")

/// An injury opened or mended by itself moves the limb's damage with it.
/datum/unit_test/rogue_injuries/own_change

/datum/unit_test/rogue_injuries/own_change/Run()
	var/mob/living/carbon/human/patient = make_patient()
	var/obj/item/bodypart/arm = patient.get_bodypart(BODY_ZONE_R_ARM)
	var/datum/rogue_injury/stab = arm.rogue_create_injury(ROGUE_INJURY_PUNCTURE, 10)
	TEST_ASSERT(stab, "No puncture was opened")
	TEST_ASSERT(abs(arm.brute_dam - 10) < 0.01, "Opening an injury did not damage the limb")
	TEST_ASSERT_EQUAL(length(arm.rogue_injuries), 1, "The limb's own change was mirrored into a second injury")
	TEST_ASSERT_EQUAL(stab.heal_damage(4), 0, "A small mend left something over")
	TEST_ASSERT(abs(arm.brute_dam - 6) < 0.01, "Mending an injury did not mend the limb")
	TEST_ASSERT(abs(stab.damage - 6) < 0.01, "The injury did not mend")

/// Stitches and a bandage stop an injury's bleeding; a bandage can be looked past.
/datum/unit_test/rogue_injuries/treatment

/datum/unit_test/rogue_injuries/treatment/Run()
	var/mob/living/carbon/human/patient = make_patient()
	var/obj/item/bodypart/leg = patient.get_bodypart(BODY_ZONE_L_LEG)
	leg.rogue_create_injury(ROGUE_INJURY_SLASH, 30)
	TEST_ASSERT(leg.rogue_injury_bleed() > 0, "A deep cut does not bleed")
	TEST_ASSERT(leg.rogue_injury_pain() > 0, "A deep cut does not hurt")
	TEST_ASSERT(leg.rogue_flag_injuries(ROGUE_INJURY_SEWABLE, ROGUE_INJ_SUTURED), "No cut was sutured")
	TEST_ASSERT_EQUAL(leg.rogue_injury_bleed(TRUE), 0, "A sutured cut bleeds")
	leg.rogue_flag_injuries(ROGUE_INJURY_SEWABLE, ROGUE_INJ_SUTURED, FALSE)
	leg.rogue_flag_injuries(ROGUE_INJURY_SEWABLE, ROGUE_INJ_BANDAGED)
	TEST_ASSERT_EQUAL(leg.rogue_injury_bleed(), 0, "A bandaged cut bleeds")
	TEST_ASSERT(leg.rogue_injury_bleed(TRUE) > 0, "Looking past the bandage the cut does not bleed")
	var/datum/rogue_injury/cut = leg.rogue_injuries[1]
	cut.adjust_germ_level(5)
	leg.rogue_flag_injuries(ROGUE_INJURY_SEWABLE, ROGUE_INJ_DISINFECTED)
	TEST_ASSERT(cut.is_disinfected(), "A disinfecting soak left germs")
	TEST_ASSERT(length(leg.rogue_injury_examine(patient)), "The cut is not told at examine")

/// Germs of the third level take a living limb with gangrene: it rots; a full heal wipes the germs.
/datum/unit_test/rogue_injuries/gangrene

/datum/unit_test/rogue_injuries/gangrene/Run()
	var/mob/living/carbon/human/patient = make_patient()
	var/obj/item/bodypart/leg = patient.get_bodypart(BODY_ZONE_R_LEG)
	leg.rogue_adjust_germs(rogue_value("germ_infection_three"))
	TEST_ASSERT(leg.rogue_rotted, "Germs of the third level did not rot a living limb")
	patient.rogue_remove_rot()
	patient.fully_heal(HEAL_ALL)
	TEST_ASSERT_EQUAL(leg.rogue_germ_level, 0, "A full heal left the germs")

#undef TEST_ASSERT
#undef TEST_ASSERT_EQUAL
#endif
