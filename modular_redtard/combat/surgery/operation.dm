/// The module's surgery on TG's operations (code/modules/surgery/operations/), rolled Vibelin's way
/// (operations/_surgery_operation.dm get_roll_requirement(), try_perform()): each step of Ratwood's and of Vibelin's is an
/// operation of TG, done through TG's machinery - the radial menu, the do_after, the surgical states of the limb. A medieval
/// body may be operated on without drapes, out of combat, standing or lying, and offers the module's operations only (the
/// rogue_surgery element). A step needs its least skill of Medicine (rogue_skill_min, a skill value: ten to a rank). Its roll
/// is 3d20 against a requirement: the step's own, raised by the surgeon's skill over the step's median, by a good implement and
/// a good place (a bed, a table; the floor and standing are worse), and by a better surgeon watching a weak one; a roll far
/// under it is a critical success, far over it a critical failure. Its time is the implement's, the place's and the skill's.
/// A strong right-hand intent fails a step done with a tool on purpose, and a step done by hand fails unless the weak one is
/// taken, as at Ratwood. A failed step cuts or bruises the site with a surgical injury and dirties it (germs: combat/injuries/),
/// a critical failure worse; a step done teaches Medicine through dreams, by intelligence and the step's least skill, a failed
/// one a share of it. The steps themselves are in combat/surgery/steps.dm and steps_vibelin.dm, the teeth in combat/teeth.dm.
///
/// How a step is written (the contract of block VR2): a subtype of /datum/surgery_operation/limb/rogue or
/// /datum/surgery_operation/basic/rogue; its numbers read in rogue_read_numbers() (. = ..() first, then rogue_dice_requirement,
/// rogue_skill_min, rogue_skill_median and anything else of its own, each by rogue_value()); its implements in
/// rogue_implements() (implement to quality, Vibelin's implements: 1 for the intended one, more for a worse one) or Ratwood's
/// rogue_chances() (implement to chance in percent); its time in rogue_time(); its effect in rogue_effect(), its failure's own
/// effect in rogue_failure_effect(), and the critical ones in rogue_on_crit_success() and rogue_on_crit_failure(). A step on
/// another base of TG's (organ manipulation) wires the same procs itself: get_tool_quality() to rogue_tool_quality(),
/// snowflake_check_availability() to rogue_skilled(), get_time_modifiers() to rogue_speed(), pre_preop() to rogue_roll(),
/// on_success() to rogue_succeed() and on_failure() to rogue_fail().

/// A step can be made quicker than this share of its time, no quicker.
#define ROGUE_SURGERY_SPEED_MIN rogue_value("surgery_speed_min")

/datum/surgery_operation
	/// One of the module's operations (combat/surgery/): a medieval body offers these and only these (rogue_surgery element).
	var/rogue_medieval = FALSE
	/// Ratwood accept_any_item: any item in hand will do, at the quality of ROGUE_IMPLEMENT_ANY (1 if not listed), when none of
	/// the implements is.
	var/rogue_any_item = FALSE
	/// Vibelin skill_used: the skill the step is rolled with and teaches.
	var/rogue_skill_used = /datum/attribute/skill/misc/medicine
	/// Vibelin dice_requirement: what the 3d20 must not exceed, before the surgeon, the implement, the place and an overseer.
	var/rogue_dice_requirement = 0
	/// Vibelin skill_min: the least skill value (ten to a rank) the step needs, and the margin of its critical rolls.
	var/rogue_skill_min = 0
	/// Vibelin skill_median: the skill value above which the step gets easier and quicker, below which harder and slower.
	var/rogue_skill_median = 0
	/// The revision of the mechanics numbers (rogue_mechanics_revision()) the step's numbers were read at.
	var/rogue_numbers_revision = -1

/datum/surgery_operation/New()
	. = ..()
	if(rogue_medieval)
		rogue_refresh_numbers()

/// Reads the step's numbers again when the mechanics numbers changed since (a reload, the Rogue Mechanics panel).
/datum/surgery_operation/proc/rogue_refresh_numbers()
	var/revision = rogue_mechanics_revision()
	if(rogue_numbers_revision == revision)
		return
	rogue_numbers_revision = revision
	rogue_read_numbers()

/// The step's numbers: a step of its own calls . = ..() first and sets its own after (rogue_value() of its names).
/datum/surgery_operation/proc/rogue_read_numbers()
	rogue_dice_requirement = rogue_value("surgery_dice_requirement")
	rogue_skill_min = rogue_value("surgery_skill_min")
	rogue_skill_median = rogue_value("surgery_skill_median")

/// Vibelin implements: each tool behaviour, type path, ROGUE_IMPLEMENT_SHARP, ROGUE_IMPLEMENT_HOT, ROGUE_IMPLEMENT_ANY or
/// IMPLEMENT_HAND the step takes, in order (the first the tool answers to counts), to its quality: 1 for the intended one, more
/// for a worse one (slower, and a lower requirement). By default Ratwood's chances, each made a quality (100 / chance).
/datum/surgery_operation/proc/rogue_implements()
	var/list/chances = rogue_chances()
	if(!length(chances))
		return chances
	var/list/qualities = list()
	for(var/implement in chances)
		var/chance = chances[implement]
		qualities[implement] = chance > 0 ? 100 / chance : 0
	return qualities

/// Ratwood implements: each implement of the step to its chance in percent (100 for the intended one). A step written Vibelin's
/// way gives rogue_implements() instead.
/datum/surgery_operation/proc/rogue_chances()
	return list()

/// Ratwood time: the deciseconds of the step for an average surgeon with the intended tool.
/datum/surgery_operation/proc/rogue_time()
	return time

/// Ratwood tool_check(): the first implement the tool answers to - its type, its tool behaviour, an edge or a point, heat enough
/// to burn - or the bare hand; any item for a step that takes any. Null for none.
/datum/surgery_operation/proc/rogue_implement(tool)
	var/list/implements = rogue_implements()
	if(!isitem(tool))
		return (tool == IMPLEMENT_HAND && (IMPLEMENT_HAND in implements)) ? IMPLEMENT_HAND : null
	var/obj/item/realtool = tool
	for(var/implement in implements)
		if(ispath(implement))
			if(istype(realtool, implement))
				return implement
			continue
		if(implement == IMPLEMENT_HAND || implement == ROGUE_IMPLEMENT_ANY)
			continue
		if(implement == ROGUE_IMPLEMENT_SHARP)
			if(realtool.get_sharpness())
				return implement
			continue
		if(implement == ROGUE_IMPLEMENT_HOT)
			if(realtool.get_temperature() >= FIRE_MINIMUM_TEMPERATURE_TO_EXIST)
				return implement
			continue
		if(realtool.tool_behaviour && realtool.tool_behaviour == implement)
			return implement
	return (rogue_any_item || (ROGUE_IMPLEMENT_ANY in implements)) ? ROGUE_IMPLEMENT_ANY : null

/// The implement's quality (rogue_implements()); 0 for none. Any item is the intended tool unless the step lists it.
/datum/surgery_operation/proc/rogue_implement_quality(implement)
	if(!implement)
		return 0
	var/list/implements = rogue_implements()
	if(implement == ROGUE_IMPLEMENT_ANY && !(ROGUE_IMPLEMENT_ANY in implements))
		return 1
	return implements[implement] || 0

/// Vibelin get_tool_quality(): the implement's quality times the tool's own speed; 0 for a tool the step does not take, so
/// that TG offers the step to whatever it takes and to nothing else.
/datum/surgery_operation/proc/rogue_tool_quality(tool)
	var/quality = rogue_implement_quality(rogue_implement(tool))
	if(quality > 0 && isitem(tool))
		var/obj/item/realtool = tool
		quality *= realtool.toolspeed
	return max(quality, 0)

/// The surgeon's skill value in the step's skill (0 without one).
/datum/surgery_operation/proc/rogue_surgery_skill(mob/living/surgeon)
	if(!rogue_skill_used || !surgeon)
		return 0
	return ROGUE_NULLTOZERO(surgeon.rogue_skill(rogue_skill_used))

/// Ratwood validate_user(): the surgeon has the least skill the step needs (Vibelin fails such a step for "lack of skill";
/// the module, as Ratwood, does not offer it).
/datum/surgery_operation/proc/rogue_skilled(mob/living/surgeon)
	rogue_refresh_numbers()
	return rogue_skill_min <= 0 || rogue_surgery_skill(surgeon) >= rogue_skill_min

/// Vibelin get_location_modifier(): what the place does to the time and the roll - lower is better. A patient standing, or
/// lying on a bed, a table or the floor (the best of what the turf holds).
/datum/surgery_operation/proc/rogue_place_modifier(atom/movable/operating_on)
	var/mob/living/patient = get_patient(operating_on)
	if(patient && !IS_LYING_OR_CANNOT_LIE(patient))
		return rogue_value("surgery_place_standing")
	var/turf/spot = get_turf(patient || operating_on)
	var/modifier = rogue_value("surgery_place_floor")
	if(!spot)
		return modifier
	if(locate(/obj/structure/bed) in spot)
		modifier = min(modifier, rogue_value("surgery_place_bed"))
	if(locate(/obj/structure/table) in spot)
		modifier = min(modifier, rogue_value("surgery_place_table"))
	return modifier

/// Vibelin get_skill_modifier(): every point of skill under the step's median makes it slower, every point over it quicker.
/// (Vibelin makes both quicker; the module reads it as its comments mean it.)
/datum/surgery_operation/proc/rogue_skill_speed(mob/living/surgeon)
	var/difference = rogue_skill_median - rogue_surgery_skill(surgeon)
	if(difference > 0)
		return 1 + difference * rogue_value("surgery_skill_slow")
	if(difference < 0)
		return max(1 + difference * rogue_value("surgery_skill_fast"), 0)
	return 1

/// Vibelin get_time_modifiers(): the tool's quality, times the place, times the skill. The step's time is taken from the values
/// first. Kept under TG's threshold, so that TG's own roll never fails a step: the module's roll does (rogue_roll()).
/datum/surgery_operation/proc/rogue_speed(atom/movable/operating_on, mob/living/surgeon, tool)
	rogue_refresh_numbers()
	time = rogue_time()
	var/speed = rogue_tool_quality(tool) || 1
	if(!HAS_TRAIT(surgeon, TRAIT_IGNORE_SURGERY_MODIFIERS))
		speed *= rogue_place_modifier(operating_on)
		speed *= rogue_skill_speed(surgeon)
	return clamp(round(speed, 0.01), ROGUE_SURGERY_SPEED_MIN, SURGERY_MODIFIER_FAILURE_THRESHOLD)

/// Vibelin get_overseer_bonus(): a surgeon under the step's median is steadied by the best one in sight - awake, of the step's
/// median or more and better than the surgeon, not the patient - by how far over the median that one is. 0 for none.
/datum/surgery_operation/proc/rogue_overseer_bonus(mob/living/surgeon, mob/living/patient)
	var/own_skill = rogue_surgery_skill(surgeon)
	if(!surgeon || own_skill >= rogue_skill_median)
		return 0
	var/best = 0
	var/per_point = rogue_value("surgery_overseer_per_skill")
	for(var/mob/living/carbon/human/nearby in oview(rogue_value("surgery_overseer_range"), surgeon))
		if(nearby == patient || nearby.stat != STABLE)
			continue
		var/their_skill = rogue_surgery_skill(nearby)
		if(their_skill < rogue_skill_median || their_skill <= own_skill)
			continue
		best = max(best, (their_skill - rogue_skill_median) * per_point)
	return best

/// Vibelin get_roll_requirement() before its bounds: the step's requirement, plus the surgeon's skill over the median, plus a
/// good implement and a good place (less for worse ones), plus an overseer's bonus (rogue_overseer_bonus()).
/datum/surgery_operation/proc/rogue_requirement_raw(atom/movable/operating_on, mob/living/surgeon, tool, overseer = 0)
	rogue_refresh_numbers()
	var/requirement = rogue_dice_requirement
	if(rogue_skill_used)
		requirement += (rogue_surgery_skill(surgeon) - rogue_skill_median) * rogue_value("surgery_roll_skill")
	requirement += (1 - (rogue_tool_quality(tool) || 1)) * rogue_value("surgery_roll_tool")
	requirement += (1 - rogue_place_modifier(operating_on)) * rogue_value("surgery_roll_place")
	if(overseer > 0)
		requirement += overseer * rogue_value("surgery_roll_overseer")
	return requirement

/// Vibelin get_roll_requirement(): the requirement, whole, between the least and the most the dice can show.
/datum/surgery_operation/proc/rogue_roll_requirement(atom/movable/operating_on, mob/living/surgeon, tool, overseer = 0)
	var/dice = rogue_value("surgery_dice_count")
	return FLOOR(clamp(rogue_requirement_raw(operating_on, surgeon, tool, overseer), dice, dice * rogue_value("surgery_dice_sides")), 1)

/// Vibelin crit = skill_min: how far under the requirement a roll is a critical success, and over it a critical failure; no
/// less than a least margin, so that a step anyone may do is not always critical.
/datum/surgery_operation/proc/rogue_crit_margin()
	return max(rogue_skill_min, rogue_value("surgery_crit_margin_least"))

/// A strong right-hand intent fails a step on purpose, with a tool or by hand: Azure Peak and Twilight Axis
/// (carbon_defense.dm:272), not Ratwood's hand that failed unless the weak one was taken (review VR2r, finding 4).
/datum/surgery_operation/proc/rogue_tries_to_fail(mob/living/surgeon, tool)
	return surgeon.rogue_rmb_is(/datum/rogue_rmb_intent/strong)

/// The contract's roll (Vibelin try_perform()): 3d20 of the surgeon (rogue_diceroll()) against the step's requirement, made as
/// the step starts and again before every turn of a looping step. Returns ROGUE_DICE_*; keeps the result
/// (ROGUE_OPERATION_ROLL) and the requirement (ROGUE_OPERATION_REQUIREMENT) in the operation's arguments. A step failed on
/// purpose (TG's intent or Ratwood's, ROGUE_OPERATION_ON_PURPOSE) is not rolled. A step that loses the roll fails when its
/// time is up (TG's OPERATION_FORCE_FAIL), one that wins it succeeds.
/datum/surgery_operation/proc/rogue_roll(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	rogue_refresh_numbers()
	if(isnull(operation_args[ROGUE_OPERATION_ON_PURPOSE]))
		operation_args[ROGUE_OPERATION_ON_PURPOSE] = operation_args[OPERATION_FORCE_FAIL] || rogue_tries_to_fail(surgeon, tool)
	if(operation_args[ROGUE_OPERATION_ON_PURPOSE])
		operation_args[ROGUE_OPERATION_ROLL] = ROGUE_DICE_FAILURE
		operation_args[ROGUE_OPERATION_REQUIREMENT] = null
		operation_args[OPERATION_FORCE_FAIL] = TRUE
		return ROGUE_DICE_FAILURE
	var/overseer = rogue_overseer_bonus(surgeon, get_patient(operating_on))
	if(overseer > 0)
		to_chat(surgeon, span_notice("I feel more confident with an experienced eye watching over me."))
	var/requirement = rogue_roll_requirement(operating_on, surgeon, tool, overseer)
	var/result = surgeon.rogue_diceroll(requirement, rogue_crit_margin(), rogue_value("surgery_dice_count"), rogue_value("surgery_dice_sides"))
	operation_args[ROGUE_OPERATION_ROLL] = result
	operation_args[ROGUE_OPERATION_REQUIREMENT] = requirement
	operation_args[OPERATION_FORCE_FAIL] = result <= ROGUE_DICE_FAILURE
	return result

/// A looping step is rolled again for its next turn.
/datum/surgery_operation/proc/rogue_next_roll(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	if(operation_flags & OPERATION_LOOPING)
		rogue_roll(operating_on, surgeon, tool, operation_args)

/// Vibelin display_roll(): the surgeon is told what the roll was, and against what.
/datum/surgery_operation/proc/rogue_show_roll(mob/living/surgeon, list/operation_args)
	if(!surgeon?.client)
		return
	var/result = operation_args[ROGUE_OPERATION_ROLL]
	if(isnull(result))
		return
	if(operation_args[ROGUE_OPERATION_ON_PURPOSE])
		to_chat(surgeon, span_warning("INTENTIONAL FAILURE"))
		return
	var/label
	switch(result)
		if(ROGUE_DICE_CRIT_SUCCESS)
			label = "CRITICAL SUCCESS"
		if(ROGUE_DICE_SUCCESS)
			label = "SUCCESS"
		if(ROGUE_DICE_CRIT_FAILURE)
			label = "CRITICAL FAILURE"
		else
			label = "FAILURE"
	var/requirement = operation_args[ROGUE_OPERATION_REQUIREMENT]
	var/message = isnull(requirement) ? label : "[label] (requirement was [requirement]/[rogue_value("surgery_dice_count") * rogue_value("surgery_dice_sides")])"
	if(result >= ROGUE_DICE_SUCCESS)
		to_chat(surgeon, span_notice(message))
	else
		to_chat(surgeon, span_warning(message))

/// The limb the step is done on: the limb itself, an organ's limb, or a body's limb of the step's zone (the chest by default).
/datum/surgery_operation/proc/rogue_operated_limb(atom/movable/operating_on)
	if(isbodypart(operating_on))
		return operating_on
	if(isorgan(operating_on))
		var/obj/item/organ/organ = operating_on
		return organ.bodypart_owner
	if(iscarbon(operating_on))
		var/mob/living/carbon/body = operating_on
		return body.get_bodypart(BODY_ZONE_CHEST)
	return null

/// What a failed step leaves at the site (the contract): the injury's kind by the implement - a cut by an edge or a point, a
/// burn by heat, a bruise by anything else or the bare hand; null for a step whose failure leaves none.
/datum/surgery_operation/proc/rogue_fail_kind(tool)
	if(!isitem(tool))
		return ROGUE_INJURY_BLUNT
	var/obj/item/realtool = tool
	if(realtool.get_temperature() >= FIRE_MINIMUM_TEMPERATURE_TO_EXIST)
		return ROGUE_INJURY_BURN
	if(realtool.get_sharpness() || realtool.tool_behaviour == TOOL_SCALPEL || realtool.tool_behaviour == TOOL_SAW || realtool.tool_behaviour == ROGUE_TOOL_IMPROVISED_SCALPEL)
		return ROGUE_INJURY_SLASH
	return ROGUE_INJURY_BLUNT

/// A failed step dirties the site (the contract, in place of Ratwood's bad humours): a surgical injury of the failure's kind
/// with germs in it, worse for a critical failure. Only on a medieval body (TRAIT_ROGUE_WOUNDS). Returns the injury, or null.
/datum/surgery_operation/proc/rogue_fail_injury(atom/movable/operating_on, tool, critical = FALSE)
	var/kind = rogue_fail_kind(tool)
	if(!kind)
		return null
	var/obj/item/bodypart/limb = rogue_operated_limb(operating_on)
	if(!limb?.owner || !HAS_TRAIT(limb.owner, TRAIT_ROGUE_WOUNDS))
		return null
	var/damage = critical ? rogue_value("surgery_crit_fail_damage") : rogue_value("surgery_fail_damage")
	// Only a cut is a surgical injury, sewn shut with the site; a bruise or a burn of a failure is a plain one, which heals
	// and is treated as any other and does not hold the site open (review VR2r, finding 3).
	var/datum/rogue_injury/injury = limb.rogue_create_injury(kind, damage, !!(kind & ROGUE_INJURY_SEWABLE))
	injury?.adjust_germ_level(critical ? rogue_value("surgery_crit_fail_germs") : rogue_value("surgery_fail_germs"))
	return injury

/// Vibelin on_crit_success(): what a critical success does beside the step's effect. Nothing by default.
/datum/surgery_operation/proc/rogue_on_crit_success(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	return

/// Vibelin on_crit_failure(): what a critical failure does beside the failure. Nothing by default: the failure's injury is
/// already a worse one (rogue_fail_injury()).
/datum/surgery_operation/proc/rogue_on_crit_failure(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	return

/// Vibelin success(): after the step's effect, the roll is shown, a critical success does its own, Medicine is learnt, and a
/// looping step is rolled again.
/datum/surgery_operation/proc/rogue_succeed(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	rogue_show_roll(surgeon, operation_args)
	if(operation_args[ROGUE_OPERATION_ROLL] == ROGUE_DICE_CRIT_SUCCESS)
		rogue_on_crit_success(operating_on, surgeon, tool, operation_args)
	rogue_learn(surgeon)
	rogue_next_roll(operating_on, surgeon, tool, operation_args)

/// Vibelin failure(): the surgeon screws up; the site takes an injury with germs, a critical failure does its own, a failure
/// not on purpose teaches a share of Medicine, and a looping step is rolled again.
/datum/surgery_operation/proc/rogue_fail(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	operation_args[ROGUE_OPERATION_FAILED] = TRUE
	var/on_purpose = operation_args[ROGUE_OPERATION_ON_PURPOSE]
	var/critical = operation_args[ROGUE_OPERATION_ROLL] == ROGUE_DICE_CRIT_FAILURE
	var/mob/living/patient = get_patient(operating_on)
	var/messed = on_purpose ? " Intentionally." : (critical ? " Badly." : "")
	display_results(surgeon, patient, span_warning("I screw up![messed]"), span_warning("[surgeon] screws up!"), span_notice("[surgeon] finishes."), TRUE)
	rogue_show_roll(surgeon, operation_args)
	rogue_fail_injury(operating_on, tool, critical)
	if(critical)
		rogue_on_crit_failure(operating_on, surgeon, tool, operation_args)
	if(!on_purpose)
		rogue_learn(surgeon, TRUE)
	rogue_next_roll(operating_on, surgeon, tool, operation_args)

/// Vibelin success() and failure(): a step teaches Medicine through dreams, by intelligence and the step's least skill; a
/// failed one a share of it.
/datum/surgery_operation/proc/rogue_learn(mob/living/surgeon, failed = FALSE)
	if(!ishuman(surgeon) || !rogue_skill_used)
		return
	var/difficulty = max(rogue_skill_min * rogue_value("surgery_learn_difficulty"), rogue_value("surgery_learn_difficulty_least"))
	var/amount = max(surgeon.rogue_stat(ROGUE_STAT_INTELLIGENCE), 1) * rogue_value("surgery_learn_per_intelligence") * difficulty
	if(failed)
		amount *= rogue_value("surgery_learn_failure")
	if(amount > 0)
		surgeon.rogue_craft_experience(rogue_skill_used, amount)

/// The operations a medieval body offers: the module's (rogue_medieval).
/proc/rogue_surgery_operations()
	var/static/list/operations
	if(isnull(operations))
		operations = list()
		for(var/operation_type in GLOB.operations.operations_by_typepath)
			var/datum/surgery_operation/operation = GLOB.operations.operations_by_typepath[operation_type]
			if(operation.rogue_medieval)
				operations += operation_type
	return operations

/// A step done on a limb of the body: the base of the module's limb operations (combat/surgery/steps.dm, steps_vibelin.dm).
/// Locked, so that TG's bodies never offer it; a medieval body offers it through the rogue_surgery element. Done standing or
/// lying, on oneself too, as at Ratwood.
/datum/surgery_operation/limb/rogue
	abstract_type = /datum/surgery_operation/limb/rogue
	operation_flags = OPERATION_LOCKED | OPERATION_NO_WIKI | OPERATION_SELF_OPERABLE | OPERATION_STANDING_ALLOWED
	rogue_medieval = TRUE
	/// Ratwood requires_bodypart_type BODYPART_ORGANIC (and SURGERY_BLOODY): the step is done on a limb of flesh only.
	var/rogue_flesh_only = TRUE
	/// Ratwood possible_locs, as TG's limbs: the zones of the step; null for every zone.
	var/list/rogue_zones

/datum/surgery_operation/limb/rogue/get_tool_quality(tool = IMPLEMENT_HAND)
	return rogue_tool_quality(tool)

/datum/surgery_operation/limb/rogue/state_check(obj/item/bodypart/limb)
	if(rogue_flesh_only && !(limb.biological_state & BIO_FLESH))
		return FALSE
	if(rogue_zones && !(limb.body_zone in rogue_zones))
		return FALSE
	return TRUE

/datum/surgery_operation/limb/rogue/snowflake_check_availability(obj/item/bodypart/limb, mob/living/surgeon, tool, operated_zone)
	return rogue_skilled(surgeon)

/datum/surgery_operation/limb/rogue/get_time_modifiers(obj/item/bodypart/limb, mob/living/surgeon, tool)
	return rogue_speed(limb, surgeon, tool)

/datum/surgery_operation/limb/rogue/pre_preop(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	if(!..())
		return FALSE
	rogue_roll(limb, surgeon, tool, operation_args)
	return TRUE

/datum/surgery_operation/limb/rogue/on_success(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	rogue_effect(limb, surgeon, tool, operation_args)
	rogue_succeed(limb, surgeon, tool, operation_args)

/datum/surgery_operation/limb/rogue/on_failure(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	rogue_failure_effect(limb, surgeon, tool, operation_args)
	rogue_fail(limb, surgeon, tool, operation_args)

/// Ratwood success(), Vibelin on_success(): what the step does once it is done.
/datum/surgery_operation/limb/rogue/proc/rogue_effect(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	return

/// Vibelin on_failure() of a step: what its failure does beside the injury every failure leaves (rogue_fail()).
/datum/surgery_operation/limb/rogue/proc/rogue_failure_effect(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	return

/// A step done on a body by its zone (Vibelin's basic operations: a zone of a carbon, or a mob without limbs): the base of the
/// module's basic operations (steps_vibelin.dm; the teeth of combat/teeth.dm are limb steps on the head, since TG finds no
/// part by the mouth's zone). Locked and offered as the limb steps are.
/datum/surgery_operation/basic/rogue
	abstract_type = /datum/surgery_operation/basic/rogue
	operation_flags = OPERATION_LOCKED | OPERATION_NO_WIKI | OPERATION_SELF_OPERABLE | OPERATION_STANDING_ALLOWED
	rogue_medieval = TRUE

/datum/surgery_operation/basic/rogue/get_tool_quality(tool = IMPLEMENT_HAND)
	return rogue_tool_quality(tool)

/datum/surgery_operation/basic/rogue/snowflake_check_availability(mob/living/patient, mob/living/surgeon, tool, operated_zone)
	return rogue_skilled(surgeon)

/datum/surgery_operation/basic/rogue/get_time_modifiers(mob/living/patient, mob/living/surgeon, tool)
	return rogue_speed(patient, surgeon, tool)

/datum/surgery_operation/basic/rogue/pre_preop(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	if(!..())
		return FALSE
	rogue_roll(patient, surgeon, tool, operation_args)
	return TRUE

/datum/surgery_operation/basic/rogue/on_success(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	rogue_effect(patient, surgeon, tool, operation_args)
	rogue_succeed(patient, surgeon, tool, operation_args)

/datum/surgery_operation/basic/rogue/on_failure(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	rogue_failure_effect(patient, surgeon, tool, operation_args)
	rogue_fail(patient, surgeon, tool, operation_args)

/// The limb of the step's zone, for a body with limbs.
/datum/surgery_operation/basic/rogue/rogue_operated_limb(atom/movable/operating_on)
	if(iscarbon(operating_on))
		var/mob/living/carbon/body = operating_on
		return body.get_bodypart(target_zone)
	return ..()

/// Vibelin on_success(): what the step does once it is done.
/datum/surgery_operation/basic/rogue/proc/rogue_effect(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	return

/// Vibelin on_failure() of a step: what its failure does beside the injury every failure leaves (rogue_fail()).
/datum/surgery_operation/basic/rogue/proc/rogue_failure_effect(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	return

/// A medieval body is operated on as at Ratwood: without drapes (TG's free operation, every limb ready), and with the module's
/// operations in place of TG's.
/datum/element/rogue_surgery

/datum/element/rogue_surgery/Attach(datum/target)
	. = ..()
	if(!iscarbon(target))
		return ELEMENT_INCOMPATIBLE
	target.AddComponentFrom(ROGUE_SURGERY_SOURCE, /datum/component/free_operation)
	RegisterSignal(target, COMSIG_ATOM_BEING_OPERATED_ON, PROC_REF(on_operated_on))

/datum/element/rogue_surgery/Detach(datum/source, ...)
	UnregisterSignal(source, COMSIG_ATOM_BEING_OPERATED_ON)
	source.RemoveComponentSource(ROGUE_SURGERY_SOURCE, /datum/component/free_operation)
	return ..()

/// The module's operations, and only those, are offered on the body.
/datum/element/rogue_surgery/proc/on_operated_on(mob/living/carbon/source, mob/living/surgeon, list/possible_operations)
	SIGNAL_HANDLER
	possible_operations.Cut()
	possible_operations += rogue_surgery_operations()

/mob/living/carbon/human/Initialize(mapload)
	. = ..()
	if(rogue_combat_enabled())
		AddElement(/datum/element/rogue_surgery)

#undef ROGUE_SURGERY_SPEED_MIN
