GLOBAL_LIST_INIT(rogue_fracture_classes, list(BCLASS_BLUNT, BCLASS_SMASH, BCLASS_CHOP, BCLASS_PUNCH))
GLOBAL_LIST_INIT(rogue_artery_classes, list(BCLASS_CUT, BCLASS_CHOP, BCLASS_STAB, BCLASS_PICK, BCLASS_BITE, BCLASS_PIERCE))
GLOBAL_LIST_INIT(rogue_artery_strong_classes, list(BCLASS_CHOP, BCLASS_PICK))
GLOBAL_LIST_INIT(rogue_artery_heart_classes, list(BCLASS_PICK, BCLASS_PIERCE))
GLOBAL_LIST_INIT(rogue_stab_classes, list(BCLASS_STAB, BCLASS_PICK, BCLASS_PIERCE))
GLOBAL_LIST_INIT(rogue_head_zones, list("head", "skull", "nose", "ears", "r_eye", "l_eye", BODY_ZONE_PRECISE_EYES, "mouth", "neck"))
GLOBAL_LIST_INIT(rogue_eye_zones, list("r_eye", "l_eye", BODY_ZONE_PRECISE_EYES))
GLOBAL_LIST_INIT(rogue_knockout_zones, list("head", "skull"))
GLOBAL_LIST_INIT(rogue_chest_zones, list("chest", "stomach", "groin"))

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
	var/share = limb.get_damage() / limb.max_damage
	if(share <= ROGUE_CRIT_LIMB_THRESHOLD)
		return FALSE
	if(attacker?.rogue_goodluck(2))
		damage += ROGUE_CRIT_LUCK_BONUS
	var/strong = attacker?.rogue_rmb_is(/datum/rogue_rmb_intent/strong)
	var/aimed = attacker?.rogue_rmb_is(/datum/rogue_rmb_intent/aimed)
	var/list/attempts = list()
	var/knockout = FALSE
	if(zone in GLOB.rogue_head_zones)
		if(blade_class in GLOB.rogue_fracture_classes)
			var/chance = rogue_crit_chance(share, damage, ROGUE_CRIT_DAMAGE_DIVISOR, strong)
			if(stat == STABLE && (zone in GLOB.rogue_knockout_zones) && blade_class != BCLASS_CHOP && prob(chance))
				knockout = TRUE
			if(prob(chance))
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
		if((blade_class in GLOB.rogue_fracture_classes) && zone != "stomach" && prob(rogue_crit_chance(share, damage, ROGUE_CRIT_DAMAGE_DIVISOR, strong)))
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
		if(blade_class == BCLASS_TWIST && prob(rogue_crit_chance(share, damage, ROGUE_CRIT_DAMAGE_DIVISOR, strong)))
			attempts += list(list(WOUND_BLUNT, WOUND_SEVERITY_MODERATE, null))
		if((blade_class in GLOB.rogue_fracture_classes) && prob(rogue_crit_chance(share, damage, ROGUE_CRIT_DAMAGE_DIVISOR, strong)))
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
			log_combat(attacker, src, "critically struck", null, "(ZONE: [zone]) (CLASS: [blade_class])")
			return TRUE
	return knockout

/mob/living/carbon/proc/rogue_apply_crit(obj/item/bodypart/limb, wounding_type, severity, special, mob/living/attacker)
	. = FALSE
	if(wounding_type && cause_wound_of_type_and_severity(wounding_type, limb, severity, severity, wound_source = ROGUE_CRIT_WOUND_SOURCE))
		. = TRUE
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
