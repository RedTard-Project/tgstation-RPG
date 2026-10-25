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
	grabber.AddElement(/datum/element/rogue_combat_bus)
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

/datum/unit_test/rogue_strike

/datum/unit_test/rogue_strike/Run()
	var/mob/living/carbon/human/consistent/attacker = allocate(__IMPLIED_TYPE__)
	var/mob/living/carbon/human/consistent/victim = allocate(__IMPLIED_TYPE__)
	var/obj/item/knife/kitchen/knife = allocate(__IMPLIED_TYPE__)
	attacker.AddElement(/datum/element/rogue_combat_bus)
	attacker.put_in_active_hand(knife)
	attacker.zone_selected = BODY_ZONE_CHEST
	TEST_ASSERT(istype(attacker.rogue_strike_intent(knife), /datum/intent/rogue_fallback/cut), "An edged item without intents did not get the cut fallback")
	knife.max_blade_int = 100
	knife.blade_int = 100
	attacker.next_move = 0
	knife.melee_attack_chain(attacker, victim)
	TEST_ASSERT(victim.get_brute_loss() > 0, "The strike pipeline did no damage")
	TEST_ASSERT(attacker.next_move > world.time, "The strike did not set a click delay")
	TEST_ASSERT(knife.blade_int < 100, "An edged blow did not wear the blade")
	var/obj/item/natural/whetstone/stone = allocate(__IMPLIED_TYPE__)
	TEST_ASSERT(stone.sharpening_factor > 0, "The whetstone lost its sharpening factor")
	knife.blade_int = 50
	knife.rogue_sharpen(stone, attacker)
	TEST_ASSERT(knife.blade_int > 50, "Sharpening did not restore the edge")
	var/brute_after_knife = victim.get_brute_loss()
	attacker.dropItemToGround(knife)
	attacker.combat_mode = TRUE
	TEST_ASSERT(attacker.rogue_select_intent(4), "Could not pick the punch intent")
	attacker.next_move = 0
	TEST_ASSERT(attacker.rogue_strike(victim, null, attacker.rogue_active_intent()), "A punch did not go through")
	TEST_ASSERT(victim.get_brute_loss() > brute_after_knife, "A punch did no damage")

/datum/unit_test/rogue_guard

/datum/unit_test/rogue_guard/Run()
	var/mob/living/carbon/human/consistent/attacker = allocate(__IMPLIED_TYPE__)
	var/mob/living/carbon/human/consistent/defender = allocate(__IMPLIED_TYPE__)
	attacker.AddElement(/datum/element/rogue_combat_bus)
	defender.AddElement(/datum/element/rogue_combat_bus)
	var/obj/item/knife/kitchen/knife = allocate(__IMPLIED_TYPE__)
	var/obj/item/knife/kitchen/guard_knife = allocate(__IMPLIED_TYPE__)
	attacker.put_in_active_hand(knife)
	defender.put_in_active_hand(guard_knife)
	defender.set_move_intent(MOVE_INTENT_WALK)
	TEST_ASSERT(defender.rogue_try_guard(), "Could not raise a guard with a weapon in hand")
	attacker.next_move = 0
	attacker.rogue_strike(defender, knife, attacker.rogue_strike_intent(knife))
	TEST_ASSERT_EQUAL(defender.get_brute_loss(), 0, "A guarded fighter was hurt")
	TEST_ASSERT(attacker.has_status_effect(/datum/status_effect/rogue/exposed), "The riposted attacker is not exposed")
	TEST_ASSERT(!defender.has_status_effect(/datum/status_effect/rogue/guard), "The guard stayed up after a riposte")
	TEST_ASSERT(defender.has_status_effect(/datum/status_effect/rogue/guard_cooldown), "Guarding again is not on cooldown")

/datum/unit_test/rogue_bait

/datum/unit_test/rogue_bait/Run()
	var/mob/living/carbon/human/consistent/baiter = allocate(__IMPLIED_TYPE__)
	var/mob/living/carbon/human/consistent/victim = allocate(__IMPLIED_TYPE__)
	baiter.zone_selected = BODY_ZONE_R_ARM
	baiter.rogue_zone_precise = "r_arm"
	victim.zone_selected = BODY_ZONE_R_ARM
	victim.rogue_zone_precise = "r_arm"
	TEST_ASSERT(baiter.rogue_bait(victim), "Matching zones did not bait")
	TEST_ASSERT(victim.has_status_effect(/datum/status_effect/rogue/exposed), "A baited fighter is not exposed")
	TEST_ASSERT(!baiter.rogue_bait(victim), "Baiting again ignored the cooldown")

/datum/unit_test/rogue_special

/datum/unit_test/rogue_special/Run()
	var/mob/living/carbon/human/consistent/attacker = allocate(__IMPLIED_TYPE__)
	var/obj/item/knife/kitchen/knife = allocate(__IMPLIED_TYPE__)
	knife.special = /datum/special_intent/piercing_lunge
	knife.associated_skill = /datum/attribute/skill/combat/knives
	attacker.put_in_active_hand(knife)
	TEST_ASSERT(!attacker.rogue_use_special(get_step(attacker, attacker.dir)), "A special worked without the needed skill")
	attacker.rogue_set_skill(/datum/attribute/skill/combat/knives, ROGUE_SPECIAL_RANK * ROGUE_SKILL_PER_RANK)
	TEST_ASSERT(attacker.rogue_use_special(get_step(attacker, attacker.dir)), "A skilled fighter could not use the weapon special")
	TEST_ASSERT(attacker.has_status_effect(/datum/status_effect/rogue/special_cooldown), "The special did not go on cooldown")
	TEST_ASSERT(!attacker.rogue_use_special(get_step(attacker, attacker.dir)), "The special ignored its cooldown")

/datum/unit_test/rogue_cleave

/datum/unit_test/rogue_cleave/Run()
	var/mob/living/carbon/human/consistent/attacker = allocate(__IMPLIED_TYPE__)
	var/mob/living/carbon/human/consistent/victim = allocate(__IMPLIED_TYPE__)
	var/mob/living/carbon/human/consistent/bystander = allocate(__IMPLIED_TYPE__)
	var/obj/item/knife/kitchen/knife = allocate(__IMPLIED_TYPE__)
	attacker.put_in_active_hand(knife)
	attacker.setDir(NORTH)
	victim.forceMove(get_step(attacker, NORTH))
	bystander.forceMove(get_step(victim, EAST))
	attacker.zone_selected = BODY_ZONE_CHEST
	var/datum/intent/cut = rogue_intent(/datum/intent/rogue_fallback/cut)
	cut.cleave = /datum/cleave_pattern/adjacent
	attacker.next_move = 0
	attacker.rogue_strike(victim, knife, cut)
	cut.cleave = null
	TEST_ASSERT(victim.get_brute_loss() > 0, "The main target was not hit")
	TEST_ASSERT(bystander.get_brute_loss() > 0, "The cleave did not reach the target beside")

/datum/unit_test/rogue_fist_special

/datum/unit_test/rogue_fist_special/Run()
	var/mob/living/carbon/human/consistent/fighter = allocate(__IMPLIED_TYPE__)
	TEST_ASSERT(!fighter.rogue_use_special(get_step(fighter, fighter.dir)), "An unskilled brawler used the fist special")
	fighter.rogue_set_skill(/datum/attribute/skill/combat/unarmed, ROGUE_SPECIAL_RANK * ROGUE_SKILL_PER_RANK)
	TEST_ASSERT(fighter.rogue_use_special(get_step(fighter, fighter.dir)), "A skilled brawler could not use the fist special")
	TEST_ASSERT(istype(fighter.rogue_unarmed_special, /datum/special_intent/upper_cut), "Bare hands did not use the upper cut")

/datum/unit_test/rogue_tempo

/datum/unit_test/rogue_tempo/Run()
	var/mob/living/carbon/human/consistent/defender = allocate(__IMPLIED_TYPE__)
	ADD_TRAIT(defender, TRAIT_TEMPO, TRAIT_SOURCE_UNIT_TESTS)
	var/list/attackers = list()
	for(var/count in 1 to 4)
		var/mob/living/carbon/human/consistent/attacker = allocate(__IMPLIED_TYPE__)
		attacker.mind_initialize()
		attackers += attacker
	defender.rogue_tempo_hit(attackers[1])
	TEST_ASSERT_EQUAL(defender.rogue_tempo_level(), 0, "One attacker gave tempo")
	defender.rogue_tempo_hit(attackers[2])
	TEST_ASSERT_EQUAL(defender.rogue_tempo_level(), 1, "Two attackers did not give tempo one")
	defender.rogue_tempo_hit(attackers[3])
	defender.rogue_tempo_hit(attackers[4])
	TEST_ASSERT_EQUAL(defender.rogue_tempo_level(), 3, "Four attackers did not give full tempo")
	TEST_ASSERT(HAS_TRAIT(defender, TRAIT_GRABIMMUNE), "Full tempo did not make the fighter hard to grab")
	TEST_ASSERT(defender.rogue_tempo_bonus("parry_stamina") > 0, "Full tempo gave no parry bonus")
	defender.combat_mode = FALSE
	defender.rogue_clear_tempo()
	TEST_ASSERT_EQUAL(defender.rogue_tempo_level(), 0, "Tempo stayed after leaving combat")
	TEST_ASSERT(!HAS_TRAIT(defender, TRAIT_GRABIMMUNE), "Grab immunity stayed after tempo was lost")

/datum/unit_test/rogue_shield

/datum/unit_test/rogue_shield/Run()
	var/mob/living/carbon/human/consistent/archer = allocate(__IMPLIED_TYPE__)
	var/mob/living/carbon/human/consistent/defender = allocate(__IMPLIED_TYPE__)
	var/obj/item/rogueweapon/shield/wood/shield = allocate(__IMPLIED_TYPE__)
	var/obj/projectile/bullet/arrow = allocate(/obj/projectile/bullet)
	arrow.firer = archer
	defender.put_in_active_hand(shield)
	shield.coverage = 100
	TEST_ASSERT(shield.hit_reaction(defender, arrow, "the arrow", 0, 20, PROJECTILE_ATTACK), "A shield with full coverage did not block a seen arrow")
	shield.coverage = 0
	TEST_ASSERT(!shield.hit_reaction(defender, arrow, "the arrow", 0, 20, PROJECTILE_ATTACK), "A shield without coverage blocked an arrow")
	TEST_ASSERT(!shield.hit_reaction(defender, archer, "the punch", 0, 20, UNARMED_ATTACK), "Shield coverage blocked a melee blow")

/datum/unit_test/rogue_limbguard

/datum/unit_test/rogue_limbguard/Run()
	var/mob/living/carbon/human/consistent/attacker = allocate(__IMPLIED_TYPE__)
	var/mob/living/carbon/human/consistent/defender = allocate(__IMPLIED_TYPE__)
	var/obj/item/knife/kitchen/knife = allocate(__IMPLIED_TYPE__)
	var/obj/item/rogueweapon/shield/wood/shield = allocate(__IMPLIED_TYPE__)
	attacker.mind_initialize()
	attacker.put_in_active_hand(knife)
	defender.put_in_active_hand(shield)
	defender.combat_mode = TRUE
	defender.zone_selected = BODY_ZONE_L_ARM
	defender.rogue_zone_precise = "l_arm"
	defender.rogue_set_skill(/datum/attribute/skill/combat/shields, ROGUE_SPECIAL_RANK * ROGUE_SKILL_PER_RANK)
	TEST_ASSERT(defender.rogue_use_special(get_step(defender, defender.dir)), "Could not raise a limb guard")
	var/datum/status_effect/rogue/limbguard/guard = defender.has_status_effect(/datum/status_effect/rogue/limbguard)
	TEST_ASSERT(guard, "The shield special did not raise a limb guard")
	guard.activate()
	attacker.zone_selected = BODY_ZONE_L_ARM
	attacker.rogue_zone_precise = "l_arm"
	attacker.next_move = 0
	attacker.rogue_strike(defender, knife, attacker.rogue_strike_intent(knife))
	TEST_ASSERT_EQUAL(defender.get_brute_loss(), 0, "A blow to the guarded limb landed")
	TEST_ASSERT(!attacker.is_holding(knife), "The limb guard did not disarm the attacker")
	TEST_ASSERT(attacker.has_status_effect(/datum/status_effect/rogue/exposed), "The caught attacker is not exposed")
	TEST_ASSERT(!defender.has_status_effect(/datum/status_effect/rogue/limbguard), "The limb guard stayed up after catching a blow")
	TEST_ASSERT(defender.has_status_effect(/datum/status_effect/rogue/special_cooldown), "The limb guard did not go on cooldown")

/datum/unit_test/rogue_dual_wield

/datum/unit_test/rogue_dual_wield/Run()
	var/mob/living/carbon/human/consistent/attacker = allocate(__IMPLIED_TYPE__)
	var/obj/item/knife/kitchen/first = allocate(__IMPLIED_TYPE__)
	var/obj/item/knife/kitchen/second = allocate(__IMPLIED_TYPE__)
	ADD_TRAIT(attacker, TRAIT_DUALWIELDER, TRAIT_SOURCE_UNIT_TESTS)
	attacker.put_in_active_hand(first)
	attacker.put_in_inactive_hand(second)
	TEST_ASSERT(attacker.rogue_can_dual_wield(first, second), "Two knives cannot be dual wielded")
	TEST_ASSERT(!attacker.rogue_dual_wield_step(first), "The first blow already paired")
	TEST_ASSERT_EQUAL(attacker.get_active_held_item(), second, "Dual wielding did not switch to the other weapon")
	attacker.rogue_dual_wield_step(second)
	attacker.rogue_dual_wield_step(first)
	TEST_ASSERT(attacker.rogue_dual_finisher, "Three alternating blows did not arm the paired blow")
	TEST_ASSERT(attacker.rogue_dual_wield_step(second), "The fourth blow was not paired")

/datum/unit_test/rogue_dismember

/datum/unit_test/rogue_dismember/Run()
	var/mob/living/carbon/human/consistent/attacker = allocate(__IMPLIED_TYPE__)
	var/mob/living/carbon/human/consistent/victim = allocate(__IMPLIED_TYPE__)
	var/obj/item/knife/kitchen/knife = allocate(__IMPLIED_TYPE__)
	var/obj/item/bodypart/arm = victim.get_bodypart(BODY_ZONE_L_ARM)
	TEST_ASSERT(victim.rogue_dismember(arm, knife, attacker, "l_arm"), "A bare arm was not severed")
	TEST_ASSERT_NULL(victim.get_bodypart(BODY_ZONE_L_ARM), "The severed arm is still attached")
	TEST_ASSERT(!victim.rogue_dismember(victim.get_bodypart(BODY_ZONE_HEAD), knife, attacker, "neck"), "A standing victim was beheaded")
	TEST_ASSERT(victim.rogue_disembowel(attacker), "Disembowelling failed")
	TEST_ASSERT_NULL(victim.get_organ_slot(ORGAN_SLOT_STOMACH), "The stomach stayed inside")

/datum/unit_test/rogue_beast

/datum/unit_test/rogue_beast/Run()
	var/mob/living/basic/rockhill/beast = allocate(__IMPLIED_TYPE__)
	beast.rogue_defprob = 40
	TEST_ASSERT_EQUAL(beast.rogue_defense_base(), 40, "A creature does not use its defprob as the dodge base")
	for(var/count in 1 to 4)
		beast.rogue_beast_spend_dodge()
	TEST_ASSERT(beast.rogue_winded_until > world.time, "Four dodges did not wind the creature")
	var/mob/living/carbon/human/consistent/attacker = allocate(__IMPLIED_TYPE__)
	TEST_ASSERT(!beast.rogue_beast_dodge(attacker, null), "A winded creature dodged")

#undef TEST_ASSERT
#undef TEST_ASSERT_EQUAL
#endif
