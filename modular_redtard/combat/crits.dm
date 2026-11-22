GLOBAL_LIST_INIT(rogue_fracture_classes, list(BCLASS_BLUNT, BCLASS_SMASH, BCLASS_CHOP, BCLASS_PUNCH))
GLOBAL_LIST_INIT(rogue_artery_classes, list(BCLASS_CUT, BCLASS_CHOP, BCLASS_STAB, BCLASS_PICK, BCLASS_BITE, BCLASS_PIERCE))
GLOBAL_LIST_INIT(rogue_artery_strong_classes, list(BCLASS_CHOP, BCLASS_PICK))
GLOBAL_LIST_INIT(rogue_artery_heart_classes, list(BCLASS_PICK, BCLASS_PIERCE))
GLOBAL_LIST_INIT(rogue_stab_classes, list(BCLASS_STAB, BCLASS_PICK, BCLASS_PIERCE))
GLOBAL_LIST_INIT(rogue_head_zones, list("head", "skull", "nose", "ears", "r_eye", "l_eye", BODY_ZONE_PRECISE_EYES, "mouth", "neck"))
GLOBAL_LIST_INIT(rogue_eye_zones, list("r_eye", "l_eye", BODY_ZONE_PRECISE_EYES))
GLOBAL_LIST_INIT(rogue_knockout_zones, list("head", "skull"))
GLOBAL_LIST_INIT(rogue_chest_zones, list("chest", "stomach", "groin"))
/// Azure Peak splatter_bclasses: the blows that may spray the blood of the struck behind them.
GLOBAL_LIST_INIT(rogue_splatter_classes, list(BCLASS_CUT, BCLASS_CHOP, BCLASS_STAB, BCLASS_PICK, BCLASS_PIERCE, BCLASS_BLUNT, BCLASS_SMASH))

/// Azure Peak TRAIT_BRITTLE of a limb, while the paralysis of a fracture lasts: its next crit breaks bone more easily.
#define ROGUE_TRAIT_BRITTLE "rogue_brittle"
#define ROGUE_CRIT_PARALYSIS_SOURCE "rogue_crit_paralysis"

/proc/rogue_bclass_sharpness(blade_class)
	switch(blade_class)
		if(BCLASS_CUT, BCLASS_CHOP, BCLASS_LASHING)
			return SHARP_EDGED
		if(BCLASS_STAB, BCLASS_PICK, BCLASS_PIERCE, BCLASS_BITE)
			return SHARP_POINTY
	return NONE

/datum/status_effect/rogue/crit_resistance
	id = "rogue_crit_resistance"
	var/stacks = 1

/datum/status_effect/rogue/crit_resistance/on_creation(mob/living/new_owner, set_duration)
	base_duration = ROGUE_CRIT_RESIST_COOLDOWN
	return ..()

/mob/living/proc/rogue_resist_crit()
	if(!HAS_TRAIT(src, TRAIT_CRITICAL_RESISTANCE))
		return FALSE
	var/datum/status_effect/rogue/crit_resistance/resistance = has_status_effect(/datum/status_effect/rogue/crit_resistance)
	if(!resistance)
		apply_status_effect(/datum/status_effect/rogue/crit_resistance)
		return TRUE
	resistance.stacks++
	if(stat != STABLE)
		return FALSE
	return resistance.stacks <= (mind ? ROGUE_CRIT_RESIST_STACKS : ROGUE_CRIT_RESIST_STACKS_NPC)

/mob/living/proc/rogue_crit_chance(share, damage, divisor, bonus)
	return rogue_formula_value(ROGUE_FORMULA_CRIT_CHANCE, list("limb_damage" = share, "damage" = damage, "divisor" = divisor, "bonus" = bonus))

/mob/living/proc/rogue_try_crit(blade_class, damage, mob/living/attacker, zone)
	return FALSE

/mob/living/carbon/rogue_try_crit(blade_class, damage, mob/living/attacker, zone)
	if(!blade_class || damage <= 0 || HAS_TRAIT(src, TRAIT_GODMODE))
		return FALSE
	if(attacker?.rogue_rmb_is(/datum/rogue_rmb_intent/weak))
		return FALSE
	var/obj/item/bodypart/limb = get_bodypart(rogue_zone_target(zone)) || get_bodypart(BODY_ZONE_CHEST)
	if(!limb)
		return FALSE
	// Azure Peak bodypart_attacked_by(): a bloody blow may spray the blood of the struck behind them, crit or not.
	if(attacker && attacker != src && (blade_class in GLOB.rogue_splatter_classes) && prob(damage * rogue_value("crit_blood_spray_per_damage")))
		spray_blood(get_dir(attacker, src))
	var/share = limb.get_damage() / limb.max_damage
	if(share <= ROGUE_CRIT_LIMB_THRESHOLD)
		return FALSE
	if(attacker?.rogue_goodluck(2))
		damage += ROGUE_CRIT_LUCK_BONUS
	var/strong = attacker?.rogue_rmb_is(/datum/rogue_rmb_intent/strong)
	var/aimed = attacker?.rogue_rmb_is(/datum/rogue_rmb_intent/aimed)
	var/list/attempts = list()
	var/knockout = FALSE
	// Azure Peak: a limb already broken (or still numb from a break) breaks again more easily.
	var/brittle = limb.rogue_brittle()
	if(zone in GLOB.rogue_head_zones)
		if(blade_class in GLOB.rogue_fracture_classes)
			var/chance = rogue_crit_chance(share, damage, ROGUE_CRIT_DAMAGE_DIVISOR, strong)
			if(stat == STABLE && (zone in GLOB.rogue_knockout_zones) && blade_class != BCLASS_CHOP && prob(chance))
				knockout = TRUE
			if(prob(chance + (brittle ? rogue_value("crit_brittle_bonus_head") : 0)))
				attempts += list(list(WOUND_BLUNT, limb.get_wound_type(/datum/wound/blunt/bone) ? WOUND_SEVERITY_CRITICAL : WOUND_SEVERITY_SEVERE, zone == "skull" ? ROGUE_CRIT_BRAIN : null))
		if(blade_class in GLOB.rogue_artery_classes)
			var/chance = rogue_crit_chance(share, damage, ROGUE_CRIT_DAMAGE_DIVISOR, blade_class == BCLASS_CHOP ? strong : aimed)
			if(prob(chance))
				attempts += list(list((blade_class in GLOB.rogue_stab_classes) ? WOUND_PIERCE : WOUND_SLASH, WOUND_SEVERITY_CRITICAL, zone == "neck" ? ROGUE_CRIT_THROAT : null))
				if(blade_class in GLOB.rogue_stab_classes)
					if(zone in GLOB.rogue_eye_zones)
						attempts += list(list(null, null, ROGUE_CRIT_EYES))
					else if(zone == "ears")
						attempts += list(list(null, null, ROGUE_CRIT_EARS))
					else if(zone == "mouth")
						attempts += list(list(null, null, ROGUE_CRIT_TONGUE))
					else if(zone == "nose")
						attempts += list(list(null, null, ROGUE_CRIT_NOSE))
					else if(zone in GLOB.rogue_knockout_zones)
						attempts += list(list(null, null, ROGUE_CRIT_BRAIN))
	else if(zone in GLOB.rogue_chest_zones)
		if((blade_class in GLOB.rogue_fracture_classes) && zone != "stomach" && prob(rogue_crit_chance(share, damage, ROGUE_CRIT_DAMAGE_DIVISOR, strong) + (brittle ? rogue_value("crit_brittle_bonus") : 0)))
			attempts += list(list(WOUND_BLUNT, share >= ROGUE_CRIT_SEVERE_SHARE ? WOUND_SEVERITY_CRITICAL : WOUND_SEVERITY_SEVERE, null))
		if((blade_class in GLOB.rogue_fracture_classes) && zone == "groin" && prob(damage))
			Stun(ROGUE_CRIT_GROIN_STUN)
		if(blade_class in GLOB.rogue_artery_classes)
			var/chance = rogue_crit_chance(share, damage, ROGUE_CRIT_CHEST_DIVISOR, (blade_class in GLOB.rogue_artery_strong_classes) ? strong : aimed)
			if(prob(chance))
				if(zone == "stomach")
					attempts += list(list(null, null, ROGUE_CRIT_DISEMBOWEL))
				var/heart = limb.get_wound_type(/datum/wound/blunt/bone) || (blade_class in GLOB.rogue_artery_heart_classes) || HAS_TRAIT(src, TRAIT_CRITICAL_WEAKNESS)
				attempts += list(list((blade_class in GLOB.rogue_stab_classes) ? WOUND_PIERCE : WOUND_SLASH, WOUND_SEVERITY_CRITICAL, heart ? ROGUE_CRIT_HEART : null))
		if(blade_class == BCLASS_LASHING && HAS_TRAIT(src, TRAIT_CRITICAL_WEAKNESS) && prob(rogue_crit_chance(share, damage, ROGUE_CRIT_CHEST_DIVISOR, strong)))
			attempts += list(list(WOUND_SLASH, WOUND_SEVERITY_CRITICAL, null))
	else
		// Azure Peak: twisting a brittle limb breaks it instead of putting it out of joint.
		if(blade_class == BCLASS_TWIST && prob(rogue_crit_chance(share, damage, ROGUE_CRIT_DAMAGE_DIVISOR, strong)))
			attempts += list(list(WOUND_BLUNT, brittle ? WOUND_SEVERITY_SEVERE : WOUND_SEVERITY_MODERATE, null))
		if((blade_class in GLOB.rogue_fracture_classes) && prob(rogue_crit_chance(share, damage, ROGUE_CRIT_DAMAGE_DIVISOR, strong) + (brittle ? rogue_value("crit_brittle_bonus") : 0)))
			attempts += list(list(WOUND_BLUNT, share >= ROGUE_CRIT_SEVERE_SHARE ? WOUND_SEVERITY_CRITICAL : WOUND_SEVERITY_MODERATE, null))
		if((blade_class in GLOB.rogue_artery_classes) && prob(rogue_crit_chance(share, damage, ROGUE_CRIT_DAMAGE_DIVISOR, (blade_class in GLOB.rogue_artery_strong_classes) ? strong : aimed)))
			attempts += list(list((blade_class in GLOB.rogue_stab_classes) ? WOUND_PIERCE : WOUND_SLASH, WOUND_SEVERITY_CRITICAL, null))
		if(blade_class == BCLASS_LASHING && HAS_TRAIT(src, TRAIT_CRITICAL_WEAKNESS))
			attempts += list(list(WOUND_SLASH, WOUND_SEVERITY_CRITICAL, null))
	if(blade_class == BCLASS_BURN && prob(rogue_crit_chance(share, damage, ROGUE_CRIT_DAMAGE_DIVISOR, FALSE)))
		attempts += list(list(WOUND_BURN, WOUND_SEVERITY_CRITICAL, null))
	if(!length(attempts) && !knockout)
		return FALSE
	if(rogue_resist_crit())
		rogue_strike_note(span_crit("Critical resistance! [src] resists a [knockout ? "knockout" : "wound"]!"))
		return TRUE
	if(knockout)
		var/from_behind = attacker && dir == get_dir(attacker, src)
		rogue_strike_note(rogue_crit_text("[src] is knocked out[from_behind ? " FROM BEHIND" : ""]!"))
		Unconscious(ROGUE_CRIT_KNOCKOUT + (from_behind ? ROGUE_CRIT_KNOCKOUT_BEHIND : 0))
	for(var/list/attempt as anything in shuffle(attempts))
		if(rogue_apply_crit(limb, attempt[1], attempt[2], attempt[3], attacker))
			playsound(src, 'modular_redtard/rockhill/sound/combat/crit.ogg', 100, TRUE)
			// Azure Peak: the crit breaks the struck (paincrit); a burn's shakes the one who dealt it instead.
			if(blade_class == BCLASS_BURN)
				if(attacker && attacker != src)
					shake_camera(attacker, 2, 2)
			else
				INVOKE_ASYNC(src, TYPE_PROC_REF(/mob, emote), "paincrit", NONE, null, FALSE, FALSE, TRUE)
			log_combat(attacker, src, "critically struck", null, "(ZONE: [zone]) (CLASS: [blade_class])")
			// K2d1: the weapon may stick in the part (combat/stuck_weapon.dm).
			rogue_mark_stick(blade_class, attempt, attacker)
			return TRUE
	return knockout

/mob/living/carbon/proc/rogue_apply_crit(obj/item/bodypart/limb, wounding_type, severity, special, mob/living/attacker)
	. = FALSE
	if(wounding_type && cause_wound_of_type_and_severity(wounding_type, limb, severity, severity, wound_source = ROGUE_CRIT_WOUND_SOURCE))
		. = TRUE
		if(wounding_type == WOUND_BLUNT && severity >= WOUND_SEVERITY_SEVERE)
			rogue_fracture_gained(limb)
	if((wounding_type == WOUND_SLASH || wounding_type == WOUND_PIERCE) && severity >= WOUND_SEVERITY_CRITICAL)
		rogue_open_artery(limb, special)
	switch(special)
		if(ROGUE_CRIT_BRAIN)
			adjust_organ_loss(ORGAN_SLOT_BRAIN, ROGUE_CRIT_BRAIN_DAMAGE)
			. = TRUE
		if(ROGUE_CRIT_EYES)
			var/obj/item/organ/eyes/eyes = get_organ_slot(ORGAN_SLOT_EYES)
			if(eyes)
				eyes.apply_organ_damage(ROGUE_CRIT_EYE_DAMAGE)
				rogue_strike_note(rogue_crit_text(pick("The eye is poked!", "The eye is gouged!", "The eye is destroyed!")))
				. = TRUE
		if(ROGUE_CRIT_EARS)
			var/obj/item/organ/ears/ears = get_organ_slot(ORGAN_SLOT_EARS)
			if(ears)
				ears.apply_organ_damage(ROGUE_CRIT_EAR_DAMAGE)
				rogue_strike_note(rogue_crit_text(pick("The eardrums are gored!", "The eardrums are ruptured!")))
				. = TRUE
		if(ROGUE_CRIT_TONGUE)
			var/obj/item/organ/tongue/tongue = get_organ_slot(ORGAN_SLOT_TONGUE)
			if(tongue)
				tongue.apply_organ_damage(ROGUE_CRIT_TONGUE_DAMAGE)
				rogue_strike_note(rogue_crit_text("The tongue is cut!"))
				. = TRUE
		if(ROGUE_CRIT_NOSE)
			ADD_TRAIT(src, TRAIT_DISFIGURED, ROGUE_CRIT_SOURCE)
			rogue_strike_note(rogue_crit_text(pick("The nose is mangled beyond recognition!", "The nose is destroyed!")))
			. = TRUE
		if(ROGUE_CRIT_THROAT)
			losebreath += ROGUE_CRIT_THROAT_BREATH
			rogue_strike_note(rogue_crit_text("Blood sprays from [src]'s throat!"))
			. = TRUE
		if(ROGUE_CRIT_HEART)
			adjust_organ_loss(ORGAN_SLOT_HEART, ROGUE_CRIT_HEART_DAMAGE)
			. = TRUE
		if(ROGUE_CRIT_DISEMBOWEL)
			. = rogue_disembowel(attacker)

/// Ratwood's artery wounds (wounds/types/arteries.dm): the critical cut or stab a crit leaves is an opened artery, that
/// of the throat a torn carotid, that of the heart an aortic dissection, and bleeds at Ratwood's rate (combat/blood.dm).
/// Opening it breaks one's stride (on_mob_gain(): paincrit, Slowdown(20), the sight shaken).
/mob/living/carbon/proc/rogue_open_artery(obj/item/bodypart/limb, special)
	var/opened = FALSE
	for(var/datum/wound/wound as anything in limb.wounds)
		if(wound.rogue_artery_opened || istype(wound, /datum/wound/blunt) || !wound.rogue_artery_bleed())
			continue
		wound.rogue_artery_opened = TRUE
		if(special == ROGUE_CRIT_THROAT)
			wound.rogue_artery = ROGUE_ARTERY_THROAT
		else if(special == ROGUE_CRIT_HEART)
			wound.rogue_artery = ROGUE_ARTERY_HEART
		opened = TRUE
	if(!opened)
		return
	rogue_crit_wound_shock()

/// Azure Peak's artery and fracture on_mob_gain(): a long slowdown, the sight shaken, and one with a mind is left critically
/// wounded. The paincrit is the crit's own (rogue_try_crit()).
/mob/living/carbon/proc/rogue_crit_wound_shock()
	rogue_slow_for(rogue_value("crit_wound_slow_time"))
	shake_camera(src, 2, 2)
	if(mind)
		rogue_critwound()

/// Azure Peak's fracture (wounds/types/fractures.dm), on the bone a crit broke: the limb gives out for a while and stays
/// brittle so long, the break bleeds hard but clots fast, and a broken leg, skull or neck slows one's steps until it heals.
/// A cracked skull knocks one out briefly instead of numbing the head.
/mob/living/carbon/proc/rogue_fracture_gained(obj/item/bodypart/limb)
	var/datum/wound/blunt/bone/fracture = limb.get_wound_type(/datum/wound/blunt/bone)
	if(!fracture || fracture.severity < WOUND_SEVERITY_SEVERE)
		return
	fracture.rogue_fracture_at = world.time
	if(limb.body_zone == BODY_ZONE_HEAD)
		rogue_strike_note(rogue_crit_text("The skull cracks!"))
		Unconscious(rogue_value("crit_skull_knockout"))
	else if(!HAS_TRAIT(limb, ROGUE_TRAIT_BRITTLE))
		ADD_TRAIT(limb, TRAIT_PARALYSIS, ROGUE_CRIT_PARALYSIS_SOURCE)
		ADD_TRAIT(limb, ROGUE_TRAIT_BRITTLE, ROGUE_CRIT_PARALYSIS_SOURCE)
		addtimer(CALLBACK(limb, TYPE_PROC_REF(/obj/item/bodypart, rogue_end_crit_paralysis)), rogue_value("crit_fracture_paralysis"))
	rogue_update_fracture_slowdown()
	rogue_crit_wound_shock()

/// The limb a fracture numbed comes back (Azure Peak remove_crit_paralysis()).
/obj/item/bodypart/proc/rogue_end_crit_paralysis()
	REMOVE_TRAIT(src, TRAIT_PARALYSIS, ROGUE_CRIT_PARALYSIS_SOURCE)
	REMOVE_TRAIT(src, ROGUE_TRAIT_BRITTLE, ROGUE_CRIT_PARALYSIS_SOURCE)

/// Azure Peak TRAIT_BRITTLE: the limb is broken, or still numb from a break.
/obj/item/bodypart/proc/rogue_brittle()
	if(HAS_TRAIT(src, ROGUE_TRAIT_BRITTLE))
		return TRUE
	var/datum/wound/blunt/bone/bone = get_wound_type(/datum/wound/blunt/bone)
	return bone && bone.severity >= WOUND_SEVERITY_SEVERE

/// Azure Peak FRACTURED_ADD_SLOWDOWN: each broken leg and a broken head (skull or neck) slow one's steps until they heal.
/mob/living/carbon/proc/rogue_update_fracture_slowdown()
	var/broken = 0
	for(var/obj/item/bodypart/limb as anything in bodyparts)
		if(limb.body_zone != BODY_ZONE_L_LEG && limb.body_zone != BODY_ZONE_R_LEG && limb.body_zone != BODY_ZONE_HEAD)
			continue
		var/datum/wound/blunt/bone/bone = limb.get_wound_type(/datum/wound/blunt/bone)
		if(bone && bone.severity >= WOUND_SEVERITY_SEVERE)
			broken++
	if(broken)
		add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/rogue_fracture, multiplicative_slowdown = broken * rogue_value("crit_fracture_slowdown"))
	else
		remove_movespeed_modifier(/datum/movespeed_modifier/rogue_fracture)

/datum/movespeed_modifier/rogue_fracture
	variable = TRUE

/datum/wound
	/// When a crit broke this bone (Azure Peak's fracture bleeding counts from then); 0 for a bone not broken by a crit.
	var/rogue_fracture_at = 0

/// Azure Peak's fracture bleeds hard, then clots fast down to a trickle: counted from when the crit broke it, a Life tick's
/// numbers turned to a second's.
/datum/wound/blunt/bone/rogue_artery_bleed()
	if(!rogue_fracture_at || severity < WOUND_SEVERITY_SEVERE)
		return 0
	var/ticks = (world.time - rogue_fracture_at) / (ROGUE_LIFE_TICK SECONDS)
	return max(rogue_value("crit_fracture_bleed") - rogue_value("crit_fracture_clot") * ticks, rogue_value("crit_fracture_clot_floor")) / ROGUE_LIFE_TICK

#undef ROGUE_TRAIT_BRITTLE
#undef ROGUE_CRIT_PARALYSIS_SOURCE
