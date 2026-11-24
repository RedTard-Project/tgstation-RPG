#ifdef UNIT_TESTS
#define TEST_ASSERT(assertion, reason) if (!(assertion)) { return Fail("Assertion failed: [reason || "No reason"]", __FILE__, __LINE__) }
#define TEST_ASSERT_EQUAL(a, b, message) do { \
	var/lhs = ##a; \
	var/rhs = ##b; \
	if (lhs != rhs) { \
		return Fail("Expected [isnull(lhs) ? "null" : lhs] to be equal to [isnull(rhs) ? "null" : rhs].[message ? " [message]" : ""]", __FILE__, __LINE__); \
	} \
} while (FALSE)

/// Vibelin's crits (combat/wounds.dm, combat/wounds/, combat/crits.dm) and the healing that still stands on them (leeches,
/// soaked cloth, sleep). The test map is not a medieval one, so the patient is given the blood element by hand, as a
/// medieval map gives it to every human.
/datum/unit_test/rogue_wounds
	abstract_type = /datum/unit_test/rogue_wounds

/datum/unit_test/rogue_wounds/proc/make_patient()
	var/mob/living/carbon/human/consistent/patient = allocate(__IMPLIED_TYPE__)
	patient.AddElement(/datum/element/rogue_blood)
	return patient

/// The kind of a blow, as the damage tells it.
/datum/unit_test/rogue_wounds/blow_class

/datum/unit_test/rogue_wounds/blow_class/Run()
	TEST_ASSERT_EQUAL(rogue_wound_blow_class(WOUND_PIERCE, null, null), BCLASS_BITE, "A pointed hit of no weapon and no direction is not a bite")
	TEST_ASSERT_EQUAL(rogue_wound_blow_class(WOUND_PIERCE, NORTH, null), BCLASS_CUT, "A creature's bite is not of the slash kind")
	TEST_ASSERT_EQUAL(rogue_wound_blow_class(WOUND_BLUNT, NORTH, null), BCLASS_BLUNT, "A blow of no weapon is not blunt")
	TEST_ASSERT_NULL(rogue_wound_blow_class(WOUND_BURN, null, null), "A burn is taken for a blow")
	var/obj/item/knife/kitchen/knife = allocate(__IMPLIED_TYPE__)
	knife.rogue_current_bclass = BCLASS_CHOP
	TEST_ASSERT_EQUAL(rogue_wound_blow_class(WOUND_SLASH, NORTH, knife), BCLASS_CHOP, "A chop is not told by the intent it was struck with")
	TEST_ASSERT_EQUAL(rogue_wound_blow_class(WOUND_PIERCE, NORTH, knife), BCLASS_STAB, "A thrust TG saw as a stab kept the cut of the hand's intent")
	TEST_ASSERT_EQUAL(rogue_wound_blow_class(WOUND_BLUNT, NORTH, knife), BCLASS_CHOP, "A chop on a mangled limb lost its kind")

/// On a medieval body TG rolls no wounds: cuts, stabs, blows and burns leave none.
/datum/unit_test/rogue_wounds/no_tg_wounds

/datum/unit_test/rogue_wounds/no_tg_wounds/Run()
	var/mob/living/carbon/human/patient = make_patient()
	var/obj/item/bodypart/arm = patient.get_bodypart(BODY_ZONE_L_ARM)
	patient.apply_damage(15, BRUTE, arm, wound_bonus = 100, sharpness = SHARP_EDGED)
	patient.apply_damage(15, BRUTE, arm, wound_bonus = 100, sharpness = SHARP_POINTY)
	patient.apply_damage(15, BRUTE, arm, wound_bonus = 100)
	patient.apply_damage(15, BURN, arm, wound_bonus = 100)
	TEST_ASSERT_EQUAL(length(arm.wounds), 0, "A blow rolled a TG wound on a medieval body")

/// A TG wound asked for on a medieval body becomes the crit of its kind: a broken bone numbs and slows, a dislocation slows,
/// a critical cut tears the artery and bleeds; force_wound_upwards() is turned too.
/datum/unit_test/rogue_wounds/tg_translation

/datum/unit_test/rogue_wounds/tg_translation/Run()
	var/mob/living/carbon/human/patient = make_patient()
	var/obj/item/bodypart/arm = patient.get_bodypart(BODY_ZONE_L_ARM)
	var/datum/wound/rogue/fracture/fracture = patient.cause_wound_of_type_and_severity(WOUND_BLUNT, arm, WOUND_SEVERITY_SEVERE)
	TEST_ASSERT(istype(fracture), "A severe blunt wound did not break the bone")
	TEST_ASSERT_NULL(arm.get_wound_type(/datum/wound/blunt/bone), "A severe blunt wound was still TG's")
	TEST_ASSERT(HAS_TRAIT(arm, TRAIT_PARALYSIS), "A broken arm is not numbed")
	TEST_ASSERT(arm.rogue_brittle(), "A broken arm is not brittle")
	TEST_ASSERT(fracture.rogue_bleed() > 0, "A fresh break does not bleed")
	var/obj/item/bodypart/leg = patient.get_bodypart(BODY_ZONE_R_LEG)
	var/datum/wound/rogue/dislocation/dislocation = patient.cause_wound_of_type_and_severity(WOUND_BLUNT, leg, WOUND_SEVERITY_MODERATE)
	TEST_ASSERT(istype(dislocation), "A moderate blunt wound on a leg did not put it out of joint")
	TEST_ASSERT(patient.has_movespeed_modifier(/datum/movespeed_modifier/rogue_fracture), "A leg out of joint does not slow one")
	var/obj/item/bodypart/other_arm = patient.get_bodypart(BODY_ZONE_R_ARM)
	other_arm.force_wound_upwards(/datum/wound/blunt/bone/severe)
	TEST_ASSERT(other_arm.rogue_has_wound(/datum/wound/rogue/fracture), "force_wound_upwards() did not break the bone as a crit")
	TEST_ASSERT_NULL(other_arm.get_wound_type(/datum/wound/blunt/bone), "force_wound_upwards() left TG's wound")
	var/obj/item/bodypart/left_leg = patient.get_bodypart(BODY_ZONE_L_LEG)
	var/datum/wound/rogue/artery/artery = patient.cause_wound_of_type_and_severity(WOUND_SLASH, left_leg, WOUND_SEVERITY_CRITICAL)
	TEST_ASSERT(istype(artery), "A critical cut did not tear the artery")
	TEST_ASSERT(left_leg.rogue_artery_torn(), "The torn artery is whole")
	TEST_ASSERT(artery.rogue_bleed() > 0, "A torn artery does not bleed")
	TEST_ASSERT_EQUAL(artery.blood_flow, 0, "A crit bleeds by TG's flow")

/// A crit mends by its health and closes; a set bone bleeds less and mends; a dislocation set back is gone; a leg mended no
/// longer slows one.
/datum/unit_test/rogue_wounds/mending

/datum/unit_test/rogue_wounds/mending/Run()
	var/mob/living/carbon/human/patient = make_patient()
	var/obj/item/bodypart/leg = patient.get_bodypart(BODY_ZONE_L_LEG)
	var/datum/wound/rogue/fracture/fracture = leg.rogue_add_wound(/datum/wound/rogue/fracture)
	TEST_ASSERT(fracture, "Could not break the leg")
	TEST_ASSERT(fracture.rogue_settable(), "A fresh break cannot be set")
	var/health = fracture.whp
	TEST_ASSERT(fracture.rogue_set_bone(), "Could not set the bone")
	TEST_ASSERT(fracture.bone_set && !fracture.rogue_settable(), "A set bone can be set again")
	TEST_ASSERT(fracture.whp < health, "Setting the bone did not mend it")
	TEST_ASSERT(fracture.passive_healing > 0, "A set bone does not mend by itself")
	fracture.rogue_heal_wound(fracture.whp)
	TEST_ASSERT(QDELETED(fracture), "A break mended whole did not close")
	TEST_ASSERT(!leg.rogue_brittle(), "A mended leg stays brittle")
	TEST_ASSERT(!patient.has_movespeed_modifier(/datum/movespeed_modifier/rogue_fracture), "A mended leg still slows one")
	var/obj/item/bodypart/arm = patient.get_bodypart(BODY_ZONE_L_ARM)
	var/datum/wound/rogue/dislocation/dislocation = arm.rogue_add_wound(/datum/wound/rogue/dislocation)
	TEST_ASSERT(dislocation, "Could not put the arm out of joint")
	TEST_ASSERT(dislocation.rogue_set_bone() && QDELETED(dislocation), "A dislocation set back in place stayed")

/// A needle sews a torn artery stitch by stitch: sewn, the artery is whole and the wound bleeds only its sewn trickle.
/datum/unit_test/rogue_wounds/sewing

/datum/unit_test/rogue_wounds/sewing/Run()
	var/mob/living/carbon/human/patient = make_patient()
	var/mob/living/carbon/human/doctor = allocate(/mob/living/carbon/human/consistent)
	var/obj/item/bodypart/arm = patient.get_bodypart(BODY_ZONE_L_ARM)
	var/datum/wound/rogue/artery/artery = patient.cause_wound_of_type_and_severity(WOUND_SLASH, arm, WOUND_SEVERITY_CRITICAL)
	TEST_ASSERT(istype(artery), "A critical cut did not tear the artery")
	TEST_ASSERT(artery.rogue_sewable(), "A torn artery cannot be sewn")
	var/stitches = 0
	while(!artery.rogue_is_sewn() && stitches < 100)
		artery.rogue_sew_step(doctor, null)
		stitches++
	TEST_ASSERT(artery.rogue_is_sewn(), "The artery was never sewn")
	TEST_ASSERT(!artery.rogue_sewable(), "A sewn artery can be sewn again")
	TEST_ASSERT(!arm.rogue_artery_torn(), "The sewn artery is still torn")
	TEST_ASSERT_EQUAL(artery.rogue_bleed(), artery.sewn_bleed_rate, "A sewn artery does not bleed its sewn trickle")

/// The crit roll: a crushing blunt blow on a beaten, brittle limb breaks it (brittle skips the damage share a break asks,
/// whatever the numbers); a blow of no damage deals no crit.
/datum/unit_test/rogue_wounds/crit_roll

/datum/unit_test/rogue_wounds/crit_roll/Run()
	var/mob/living/carbon/human/patient = make_patient()
	var/obj/item/bodypart/arm = patient.get_bodypart(BODY_ZONE_L_ARM)
	arm.receive_damage(arm.max_damage * 0.95, wound_bonus = CANT_WOUND)
	TEST_ASSERT(arm.rogue_crit_paralysis(10 SECONDS), "Could not numb the arm")
	TEST_ASSERT(arm.rogue_brittle(), "A numbed arm is not brittle")
	TEST_ASSERT(patient.rogue_try_crit(BCLASS_BLUNT, 1000, null, BODY_ZONE_L_ARM), "A crushing blow on a beaten arm dealt no crit")
	TEST_ASSERT(arm.rogue_has_wound(/datum/wound/rogue/fracture), "A crushing blow on a beaten arm did not break it")
	TEST_ASSERT(!patient.rogue_try_crit(BCLASS_BLUNT, 0, null, BODY_ZONE_L_ARM), "A blow of no damage dealt a crit")

/// Pain relief eases a crit's pain by half of what it is told, never below its sewn pain.
/datum/unit_test/rogue_wounds/pain_eased

/datum/unit_test/rogue_wounds/pain_eased/Run()
	var/mob/living/carbon/human/patient = make_patient()
	var/obj/item/bodypart/arm = patient.get_bodypart(BODY_ZONE_L_ARM)
	var/datum/wound/rogue/fracture/fracture = arm.rogue_add_wound(/datum/wound/rogue/fracture)
	TEST_ASSERT(fracture, "Could not break the arm")
	var/pain = fracture.rogue_pain()
	TEST_ASSERT(pain > 0, "A broken bone does not hurt")
	fracture.rogue_ease_pain(2)
	TEST_ASSERT_EQUAL(fracture.rogue_pain(), max(pain - 1, fracture.sewn_woundpain), "Easing 2 of a broken bone's pain did not ease 1")

/// The bandage shows on the body and comes off with the cloth.
/datum/unit_test/rogue_wounds/bandage

/datum/unit_test/rogue_wounds/bandage/Run()
	var/mob/living/carbon/human/patient = make_patient()
	var/obj/item/bodypart/arm = patient.get_bodypart(BODY_ZONE_L_ARM)
	var/obj/item/natural/cloth/cloth = allocate(__IMPLIED_TYPE__)
	cloth.forceMove(arm)
	arm.rogue_bandage = cloth
	var/drawn = FALSE
	for(var/mutable_appearance/overlay as anything in arm.get_bodypart_damage_state())
		if(overlay.icon_state == "l_arm_b")
			drawn = TRUE
	TEST_ASSERT(drawn, "The bandage is not drawn on the arm")
	cloth.forceMove(get_turf(patient))
	TEST_ASSERT_NULL(arm.rogue_bandage, "The bandage taken off is still on the arm")

/// Sleep mends the crits of a limb that does not bleed.
/datum/unit_test/rogue_wounds/sleep

/datum/unit_test/rogue_wounds/sleep/Run()
	var/mob/living/carbon/human/patient = make_patient()
	var/obj/item/bodypart/arm = patient.get_bodypart(BODY_ZONE_L_ARM)
	var/datum/wound/rogue/dislocation/dislocation = arm.rogue_add_wound(/datum/wound/rogue/dislocation)
	TEST_ASSERT(dislocation, "Could not put the arm out of joint")
	var/health = dislocation.whp
	var/datum/component/rogue_sleeper/sleeper = patient.AddComponent(/datum/component/rogue_sleeper)
	sleeper.sleep_heal(patient, SSMOBS_DT)
	TEST_ASSERT(QDELETED(dislocation) || dislocation.whp < health, "Sleep did not mend the dislocation")

/// A leech draws toxins out and drinks blood until it is full, then drops off.
/datum/unit_test/rogue_wounds/leech

/datum/unit_test/rogue_wounds/leech/Run()
	var/mob/living/carbon/human/patient = make_patient()
	var/obj/item/bodypart/arm = patient.get_bodypart(BODY_ZONE_L_ARM)
	var/obj/item/natural/worms/leech/leech = allocate(__IMPLIED_TYPE__)
	leech.forceMove(arm)
	leech.rogue_latch(arm)
	TEST_ASSERT(leech in arm.rogue_leeches, "The leech did not take hold of the arm")
	patient.adjust_tox_loss(10)
	var/blood = patient.get_blood_volume()
	var/toxins = patient.get_tox_loss()
	leech.rogue_leech_tick(patient, 1)
	TEST_ASSERT(patient.get_blood_volume() < blood, "The leech drank no blood")
	TEST_ASSERT(patient.get_tox_loss() < toxins, "The leech drew no toxins out")
	TEST_ASSERT(leech.rogue_blood > 0, "The leech kept none of the blood")
	leech.rogue_blood = leech.rogue_blood_max
	leech.rogue_leech_tick(patient, 1)
	TEST_ASSERT(leech.loc != arm && !(leech in arm.rogue_leeches), "A full leech did not drop off")
	TEST_ASSERT_NULL(leech.rogue_limb, "A leech that dropped off still holds the arm")

/// Cloth soaks in Ratwood's medicines; aqua vitae as soon as the drink exists.
/datum/unit_test/rogue_wounds/soakings

/datum/unit_test/rogue_wounds/soakings/Run()
	var/list/soakings = rogue_soak_medicines()
	TEST_ASSERT(soakings[/datum/reagent/medicine/healthpot], "Cloth cannot be soaked in a health potion")
	TEST_ASSERT(soakings[/datum/reagent/water/blessed], "Cloth cannot be soaked in blessed water")
	var/aqua_vitae = text2path("/datum/reagent/consumable/ethanol/aqua_vitae")
	TEST_ASSERT(!aqua_vitae || soakings[aqua_vitae], "Aqua vitae exists, but cloth cannot be soaked in it")

/// A limb attached again keeps its crit without opening it twice: the pain of the break does not land again, the arm is
/// numb and brittle again.
/datum/unit_test/rogue_wounds/reattached_crit

/datum/unit_test/rogue_wounds/reattached_crit/Run()
	var/mob/living/carbon/human/patient = make_patient()
	var/obj/item/bodypart/arm = patient.get_bodypart(BODY_ZONE_L_ARM)
	var/datum/wound/rogue/fracture/fracture = arm.rogue_add_wound(/datum/wound/rogue/fracture)
	TEST_ASSERT(fracture, "Could not break the arm")
	arm.rogue_end_crit_paralysis()
	var/pain = arm.rogue_pain_dam
	arm.drop_limb()
	TEST_ASSERT(!arm.rogue_brittle(), "A limb off the body stays brittle by its break")
	TEST_ASSERT(arm.try_attach_limb(patient), "Could not attach the arm again")
	TEST_ASSERT(!QDELETED(fracture) && (fracture in arm.wounds), "The break did not come back with the arm")
	TEST_ASSERT(arm.rogue_pain_dam <= pain, "The break opened again on the arm attached again: its pain landed twice")
	TEST_ASSERT(arm.bodypart_disabled, "The broken arm attached again is not numb")
	TEST_ASSERT(arm.rogue_brittle(), "The broken arm attached again is not brittle")

#undef TEST_ASSERT
#undef TEST_ASSERT_EQUAL
#endif
