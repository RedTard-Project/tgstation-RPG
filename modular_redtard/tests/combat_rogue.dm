#ifdef UNIT_TESTS
#define TEST_ASSERT(assertion, reason) if (!(assertion)) { return Fail("Assertion failed: [reason || "No reason"]", __FILE__, __LINE__) }
#define TEST_ASSERT_EQUAL(a, b, message) do { \
	var/lhs = ##a; \
	var/rhs = ##b; \
	if (lhs != rhs) { \
		return Fail("Expected [isnull(lhs) ? "null" : lhs] to be equal to [isnull(rhs) ? "null" : rhs].[message ? " [message]" : ""]", __FILE__, __LINE__); \
	} \
} while (FALSE)

/datum/unit_test/rogue_grab

/datum/unit_test/rogue_grab/Run()
	var/mob/living/carbon/human/consistent/grabber = allocate(__IMPLIED_TYPE__)
	var/mob/living/carbon/human/consistent/victim = allocate(__IMPLIED_TYPE__)
	grabber.AddElement(/datum/element/rogue_grabber)
	victim.apply_status_effect(/datum/status_effect/rogue_compliance)
	grabber.zone_selected = BODY_ZONE_L_ARM
	grabber.rogue_zone_precise = "l_arm"
	grabber.start_pulling(victim)
	var/obj/item/hand_item/rogue_grab/grip = grabber.get_active_held_item()
	TEST_ASSERT(istype(grip), "Pulling someone did not put a grip in the free hand")
	TEST_ASSERT_EQUAL(grip.zone, "l_arm", "The grip did not take the selected part")
	TEST_ASSERT(istype(grabber.rogue_active_intent(), /datum/intent/grab/upgrade), "A passive grip should only offer to tighten it")
	grabber.next_move = 0
	grip.melee_attack_chain(grabber, victim)
	TEST_ASSERT_EQUAL(grabber.grab_state, GRAB_AGGRESSIVE, "Tightening a grip on a compliant target failed")
	var/list/arm_intents = grabber.rogue_hand_intents()
	TEST_ASSERT_EQUAL(length(arm_intents), 3, "An aggressive arm grip should offer move, twist and smash")
	TEST_ASSERT(grabber.rogue_select_intent(2), "Could not pick twist")
	var/brute_before = victim.get_brute_loss()
	grabber.next_move = 0
	grip.melee_attack_chain(grabber, victim)
	TEST_ASSERT(victim.get_brute_loss() > brute_before, "Twisting a held arm did no damage")
	grabber.dropItemToGround(grip)
	TEST_ASSERT_NULL(grabber.pulling, "Letting go of the grip did not stop the pull")

/datum/unit_test/rogue_bite

/datum/unit_test/rogue_bite/Run()
	var/mob/living/carbon/human/consistent/biter = allocate(__IMPLIED_TYPE__)
	var/mob/living/carbon/human/consistent/victim = allocate(__IMPLIED_TYPE__)
	biter.zone_selected = BODY_ZONE_R_ARM
	biter.rogue_zone_precise = "r_arm"
	TEST_ASSERT(biter.rogue_try_bite(victim), "The first bite did not land")
	var/obj/item/rogue_bite/held_bite = biter.wear_mouth
	TEST_ASSERT(istype(held_bite), "The first bite did not keep hold with the teeth")
	TEST_ASSERT_EQUAL(held_bite.bitten, victim, "The bite holds someone else")
	var/brute_before = victim.get_brute_loss()
	biter.next_move = 0
	TEST_ASSERT(biter.rogue_try_bite(victim), "Biting again did not chew")
	TEST_ASSERT(victim.get_brute_loss() > brute_before, "Chewing did no damage")
	qdel(held_bite)
	TEST_ASSERT_NULL(biter.wear_mouth, "The bite stayed in the mouth after letting go")

#undef TEST_ASSERT
#undef TEST_ASSERT_EQUAL
#endif
