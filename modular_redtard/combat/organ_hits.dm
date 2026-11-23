/// Vibelin's blows to the organs and the efficiency of organs and limbs (modules/surgery/bodyparts/_bodyparts.dm
/// damage_internal_organs(), update_limb_efficiency(); datums/wounds/_wound.dm; organs/_organ.dm get_shock()) on medieval
/// bodies (TRAIT_ROGUE_WOUNDS, given by the blood element on medieval maps):
/// - a blow that lands (the strike, a special) may reach an organ of the part it hit: only once the part is hurt enough and
///   the blow is hard enough, more likely the harder it is, stabs and blunt blows more than cuts, burns least; the organ is
///   picked by its size (the liver most, the eyes least), takes part of the blow, and hurts when it took much;
/// - a damaged organ hurts its part as long as it is damaged (a failing one the most), which the shock of combat/pain.dm counts;
/// - an organ works as well as it is whole (rogue_organ_efficiency(): TG's organ damage, none when failing);
/// - a crit on an arm slows what that hand does, a crit on a leg makes it limp: Vibelin's interaction_efficiency_penalty and
///   limp_slowdown, which Vibelin declares and never reads, are TG's own fields of a wound, and TG's machinery runs them
///   (the actionspeed of the active hand, /datum/status_effect/limp); the crits take their numbers here.
/// The limb's efficiency itself is the crits' (combat/wounds.dm rogue_update_limb_efficiency()); the jaw's is combat/teeth.dm.
/// Modern maps and bodies without the trait keep TG's organs alone.

/// The numbers of the organs, read once for every blow and Life tick and again only when the mechanics numbers change.
/datum/rogue_organ_numbers
	var/revision = -1
	/// Vibelin organ_damage_requirement = max_damage * 0.2: the share of its most damage the part must have taken before.
	var/hit_required_share
	/// Vibelin ORGAN_MINIMUM_DAMAGE: the blow an organ is reached by at least, and the scale of the chance.
	var/hit_minimum
	/// What the least blow is multiplied by for stabs and blunt blows (they reach organs easier), and for burns (harder).
	var/hit_minimum_pierce_blunt
	var/hit_minimum_burn
	/// Vibelin MAX_CONSIDERED_ORGAN_DAMAGE_ROLL: the most of a blow counted.
	var/hit_damage_cap
	/// Vibelin organ_hit_chance = 30 * damage / minimum: the chance in percent of a blow of the least damage.
	var/hit_chance_factor
	/// Vibelin internal_damage_modifier and internal_damage_reduction: what of the blow the organ takes.
	var/hit_damage_factor
	var/hit_damage_reduction
	/// Vibelin: an organ that took this much of a blow hurts at once, with a pain of this power.
	var/hit_pain_damage
	var/hit_pain_min
	var/hit_pain_max
	/// Vibelin organ_volume * 10 by organ slot: how likely each organ is to be the one reached (0: never).
	var/list/hit_weights
	/// Vibelin pain_multiplier by organ slot: what of its damage an organ hurts.
	var/list/pain_factors

/// Vibelin's organs by TG's organ slot: the key of their numbers.
/datum/rogue_organ_numbers/proc/organ_keys()
	var/static/list/keys = list(
		ORGAN_SLOT_BRAIN = "brain",
		ORGAN_SLOT_HEART = "heart",
		ORGAN_SLOT_LUNGS = "lungs",
		ORGAN_SLOT_LIVER = "liver",
		ORGAN_SLOT_STOMACH = "stomach",
		ORGAN_SLOT_APPENDIX = "appendix",
		ORGAN_SLOT_EYES = "eyes",
		ORGAN_SLOT_EARS = "ears",
		ORGAN_SLOT_TONGUE = "tongue",
	)
	return keys

/datum/rogue_organ_numbers/proc/read()
	hit_required_share = rogue_value("organ_hit_required_share")
	hit_minimum = rogue_value("organ_hit_minimum")
	hit_minimum_pierce_blunt = rogue_value("organ_hit_minimum_pierce_blunt")
	hit_minimum_burn = rogue_value("organ_hit_minimum_burn")
	hit_damage_cap = rogue_value("organ_hit_damage_cap")
	hit_chance_factor = rogue_value("organ_hit_chance_factor")
	hit_damage_factor = rogue_value("organ_hit_damage_factor")
	hit_damage_reduction = rogue_value("organ_hit_damage_reduction")
	hit_pain_damage = rogue_value("organ_hit_pain_damage")
	hit_pain_min = rogue_value("organ_hit_pain_min")
	hit_pain_max = rogue_value("organ_hit_pain_max")
	hit_weights = list()
	pain_factors = list()
	var/list/keys = organ_keys()
	for(var/slot in keys)
		hit_weights[slot] = rogue_value("organ_hit_weight_[keys[slot]]")
		pain_factors[slot] = rogue_value("organ_pain_[keys[slot]]")
	revision = rogue_mechanics_revision()

/// The organ numbers, fresh for the current revision of the mechanics numbers.
/proc/rogue_organ_numbers()
	var/static/datum/rogue_organ_numbers/numbers
	if(!numbers)
		numbers = new
	if(numbers.revision != rogue_mechanics_revision())
		numbers.read()
	return numbers

// --- Blows to the organs.

/// The strike's blow to the organs under the part it hit (strike.dm, specials.dm, before the crit): see the carbon's.
/mob/living/proc/rogue_strike_organs(bclass, damage, mob/living/attacker, zone)
	return FALSE

/// Vibelin bodypart_attacked_by(): a blow that landed on a medieval body may reach an organ of the part; a stab to an eye
/// does not (the eye's own crit is that). Returns TRUE when an organ was hurt.
/mob/living/carbon/rogue_strike_organs(bclass, damage, mob/living/attacker, zone)
	if(!bclass || damage <= 0 || !HAS_TRAIT(src, TRAIT_ROGUE_WOUNDS) || HAS_TRAIT(src, TRAIT_GODMODE))
		return FALSE
	var/obj/item/bodypart/limb = get_bodypart(rogue_zone_target(zone)) || get_bodypart(BODY_ZONE_CHEST)
	if(!limb)
		return FALSE
	var/kind = rogue_injury_kind_for_bclass(bclass)
	if((kind & ROGUE_INJURY_PUNCTURE) && (zone == "r_eye" || zone == "l_eye" || zone == BODY_ZONE_PRECISE_EYES))
		return FALSE
	return limb.rogue_damage_organs(kind, damage)

/// Vibelin damage_internal_organs(): a blow of this injury kind and damage, already taken, may hurt an organ of the part. The
/// part must have been hurt enough before it and the blow be hard enough (its crits count more of the blow); then it rolls,
/// and an organ picked by size takes its share. Forced, it skips the thresholds and the roll. Returns TRUE when it did.
/obj/item/bodypart/proc/rogue_damage_organs(kind, damage, forced = FALSE)
	if(!owner || damage <= 0)
		return FALSE
	var/datum/rogue_organ_numbers/numbers = rogue_organ_numbers()
	var/list/candidates = list()
	for(var/obj/item/organ/organ as anything in owner.get_organs_for_zone(body_zone, TRUE))
		if(organ.damage >= organ.maxHealth)
			continue
		var/weight = numbers.hit_weights[organ.slot]
		if(weight > 0)
			candidates[organ] = weight
	if(!length(candidates))
		return FALSE
	var/minimum = numbers.hit_minimum
	if(kind & (ROGUE_INJURY_PUNCTURE|ROGUE_INJURY_BLUNT))
		minimum *= numbers.hit_minimum_pierce_blunt
	else if(kind & ROGUE_INJURY_FIRE)
		minimum *= numbers.hit_minimum_burn
	var/amount = damage
	for(var/datum/wound/rogue/crit in wounds)
		amount += crit.organ_damage_increase
	amount = min(numbers.hit_damage_cap, CEILING(amount, 1))
	minimum = max(CEILING(minimum, 1), 1)
	if(!forced)
		// The damage the part had before this blow (Vibelin counts it before the injury of the blow opens).
		var/before = max(get_damage() - damage, 0)
		if(before < CEILING(max_damage * numbers.hit_required_share, 1) || amount < minimum)
			return FALSE
		if(!prob(clamp(CEILING(numbers.hit_chance_factor * amount / minimum, 1), 0, 100)))
			return FALSE
	var/obj/item/organ/struck = pick_weight(candidates)
	var/dealt = max(0, CEILING(amount * numbers.hit_damage_factor - numbers.hit_damage_reduction, 1))
	if(dealt >= 1)
		struck.apply_organ_damage(dealt)
	if(dealt >= numbers.hit_pain_damage)
		owner.rogue_custom_pain("<b>MY [uppertext(struck.name)] HURTS!</b>", rand(numbers.hit_pain_min, numbers.hit_pain_max), FALSE, src, TRUE)
	return TRUE

// --- What damaged organs hurt.

/// Vibelin organ get_shock() over the organs of the part: each hurts by its damage times its share, a failing one by all its
/// health; organs of other kinds than Vibelin's hurt nothing. Painkillers are the part's to count (rogue_get_shock()).
/obj/item/bodypart/proc/rogue_organ_pain()
	. = 0
	// Vibelin's organs lie in the head and the chest only: the other parts skip the walk over the body's organs.
	if(!owner || (body_zone != BODY_ZONE_HEAD && body_zone != BODY_ZONE_CHEST))
		return
	var/datum/rogue_organ_numbers/numbers = rogue_organ_numbers()
	for(var/obj/item/organ/organ as anything in owner.organs)
		var/failing = organ.organ_flags & ORGAN_FAILING
		if(organ.damage <= 0 && !failing)
			continue
		var/factor = numbers.pain_factors[organ.slot]
		if(!factor || deprecise_zone(organ.zone) != body_zone)
			continue
		. += (failing ? organ.maxHealth : organ.damage) * factor
	return max(FLOOR(., DAMAGE_PRECISION), 0)

// --- How well an organ works.

/// How well the organ works, 0 to 1 (Vibelin get_slot_efficiency() as the contract has it: TG's damage of the organ); none
/// when it fails.
/obj/item/organ/proc/rogue_organ_efficiency()
	if((organ_flags & ORGAN_FAILING) || maxHealth <= 0)
		return 0
	return clamp(1 - damage / maxHealth, 0, 1)

/// How well the body's organ of the slot works (Vibelin getorganslotefficiency()): none without one.
/mob/living/carbon/proc/rogue_organ_slot_efficiency(slot)
	var/obj/item/organ/organ = get_organ_slot(slot)
	return organ ? organ.rogue_organ_efficiency() : 0

// --- Slow hands and limping of the crits.

/// Vibelin interaction_efficiency_penalty and limp_slowdown of the crits, on TG's fields of the wound: TG slows the actions of
/// the hand whose arm holds the crit while that hand is active, and makes a leg with one limp now and then a step
/// (/datum/status_effect/limp, by limp_chance). Read with the crit's other numbers, before TG puts it on the limb.
/datum/wound/rogue/rogue_load_numbers()
	. = ..()
	interaction_efficiency_penalty = rogue_number("interaction_penalty")
	limp_slowdown = rogue_number("limp_slowdown")
	limp_chance = rogue_number("limp_chance")
