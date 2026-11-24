/// Vibelin's crits (modules/surgery/bodyparts/bodypart_wounds.dm try_crit(), the chest's and the head's) on Azure Peak's
/// strike: every kind of crit of combat/wounds/ that may land on the struck zone rolls its own chance (get_crit_prob(): the
/// limb's damage share and the blow's damage, a strong or aimed blow and a brittle limb counting more where the kind takes
/// them), and one of those that came up opens. A blow to the head may knock one out instead (30 seconds, the owner's
/// number), a blow to the groin may stun. Azure Peak's critical resistance holds off a crit or a knockout, a weak blow deals
/// none, a bloody blow may spray the blood of the struck behind it, and the weapon may stick (combat/stuck_weapon.dm).

GLOBAL_LIST_INIT(rogue_fracture_classes, list(BCLASS_BLUNT, BCLASS_SMASH, BCLASS_CHOP, BCLASS_PICK, BCLASS_PUNCH))
GLOBAL_LIST_INIT(rogue_artery_classes, list(BCLASS_CUT, BCLASS_CHOP, BCLASS_STAB, BCLASS_PICK, BCLASS_BITE, BCLASS_PIERCE))
GLOBAL_LIST_INIT(rogue_artery_strong_classes, list(BCLASS_CHOP, BCLASS_PICK))
/// Vibelin ARTERY_HEART_BCLASSES: the blows that reach the aorta through whole ribs.
GLOBAL_LIST_INIT(rogue_artery_heart_classes, list(BCLASS_PICK, BCLASS_PIERCE))
GLOBAL_LIST_INIT(rogue_stab_classes, list(BCLASS_STAB, BCLASS_PICK, BCLASS_PIERCE))
GLOBAL_LIST_INIT(rogue_head_zones, list("head", "skull", "nose", "ears", "r_eye", "l_eye", BODY_ZONE_PRECISE_EYES, "mouth", "neck"))
GLOBAL_LIST_INIT(rogue_eye_zones, list("r_eye", "l_eye", BODY_ZONE_PRECISE_EYES))
/// Vibelin's knockout zones of the head (nose, ears, skull, eyes) and Azure Peak's head.
GLOBAL_LIST_INIT(rogue_knockout_zones, list("head", "skull", "nose", "ears", "r_eye", "l_eye", BODY_ZONE_PRECISE_EYES))
/// Vibelin NO_KNOCKOUT_BCLASSES.
GLOBAL_LIST_INIT(rogue_no_knockout_classes, list(BCLASS_CHOP, BCLASS_PICK))
/// Vibelin CBT_BCLASSES: the blows that may stun through the groin.
GLOBAL_LIST_INIT(rogue_cbt_classes, list(BCLASS_BLUNT, BCLASS_SMASH, BCLASS_CHOP, BCLASS_PICK, BCLASS_PUNCH, BCLASS_TWIST))
GLOBAL_LIST_INIT(rogue_chest_zones, list("chest", "stomach", "groin"))
/// Azure Peak splatter_bclasses: the blows that may spray the blood of the struck behind them.
GLOBAL_LIST_INIT(rogue_splatter_classes, list(BCLASS_CUT, BCLASS_CHOP, BCLASS_STAB, BCLASS_PICK, BCLASS_PIERCE, BCLASS_BLUNT, BCLASS_SMASH))

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

/// The crit formula of the module (ROGUE_FORMULA_CRIT_CHANCE): Vibelin's knockout chance of the head.
/mob/living/proc/rogue_crit_chance(share, damage, divisor, bonus)
	return rogue_formula_value(ROGUE_FORMULA_CRIT_CHANCE, list("limb_damage" = share, "damage" = damage, "divisor" = divisor, "bonus" = bonus))

/// One of each kind of crit a blow may deal (Vibelin GLOB.primordial_wounds), to ask for its chance; built again when the
/// mechanics numbers change.
/proc/rogue_crit_primordials()
	var/static/list/primordials
	var/static/revision = -1
	if(primordials && revision == rogue_mechanics_revision())
		return primordials
	QDEL_LIST(primordials)
	primordials = list()
	for(var/datum/wound/rogue/path as anything in subtypesof(/datum/wound/rogue))
		if(initial(path.abstract_type) == path || !initial(path.can_roll))
			continue
		primordials += new path
	revision = rogue_mechanics_revision()
	return primordials

/mob/living/proc/rogue_try_crit(blade_class, damage, mob/living/attacker, zone)
	return FALSE

/// The strike's crit (strike.dm, specials.dm): a weak blow deals none; a bloody one may spray the blood of the struck behind
/// it, crit or not; then the struck limb rolls its crits.
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
	return limb.rogue_try_crit(blade_class, damage, attacker, zone || limb.body_zone)

/// Vibelin try_crit() of the limb: the crits that may land on the zone each roll; one of those that came up opens. The head
/// may be knocked out instead, the groin stunned. Returns the crit opened, TRUE for a knockout or a crit resisted, FALSE.
/obj/item/bodypart/proc/rogue_try_crit(bclass, damage, mob/living/attacker, zone)
	var/mob/living/carbon/struck = owner
	if(!struck || !bclass || damage <= 0 || HAS_TRAIT(struck, TRAIT_GODMODE))
		return FALSE
	zone ||= body_zone
	if(attacker?.rogue_goodluck(2))
		damage += ROGUE_CRIT_LUCK_BONUS
	var/share = get_damage() / max_damage
	// Vibelin chest try_crit(): a blow to the groin may stun, twice as likely from a nutcracker.
	if(zone == BODY_ZONE_PRECISE_GROIN && (bclass in GLOB.rogue_cbt_classes))
		var/factor = (attacker && HAS_TRAIT(attacker, TRAIT_NUTCRACKER)) ? rogue_value("wound_cbt_nutcracker") : 1
		if(prob(damage * factor))
			INVOKE_ASYNC(struck, TYPE_PROC_REF(/mob, emote), "scream", NONE, null, FALSE, FALSE, TRUE)
			struck.Stun(ROGUE_CRIT_GROIN_STUN)
	var/knockout = FALSE
	// Vibelin head try_crit(): a blow of the breaking kind to the head may knock one out instead of a crit.
	if(body_zone == BODY_ZONE_HEAD && struck.stat == STABLE && (zone in GLOB.rogue_knockout_zones) && (bclass in GLOB.rogue_fracture_classes) && !(bclass in GLOB.rogue_no_knockout_classes))
		var/counted = damage
		if(rogue_brittle())
			counted += rogue_value("wound_knockout_brittle")
		if(attacker?.rogue_rmb_is(/datum/rogue_rmb_intent/strong))
			counted += rogue_value("wound_knockout_strong")
		var/chance = struck.rogue_crit_chance(share, counted, rogue_value("wound_knockout_divisor"), 0)
		if(HAS_TRAIT(struck, TRAIT_CRITICAL_RESISTANCE))
			chance -= rogue_value("wound_base_resistance_malus")
		knockout = prob(chance)
	var/list/candidates = list()
	if(!knockout)
		for(var/datum/wound/rogue/primordial as anything in rogue_crit_primordials())
			if(!primordial.rogue_can_apply(src, zone, bclass))
				continue
			if(prob(primordial.get_crit_prob(bclass, damage, share, attacker, src)))
				candidates += primordial.type
	if(!knockout && !length(candidates))
		return FALSE
	if(struck.rogue_resist_crit())
		struck.rogue_strike_note(span_crit("Critical resistance! [struck] resists a [knockout ? "knockout" : "wound"]!"))
		return TRUE
	if(knockout)
		var/from_behind = attacker && struck.dir == get_dir(attacker, struck)
		struck.rogue_strike_note(rogue_crit_text("[struck] is knocked out[from_behind ? " FROM BEHIND" : ""]!"))
		struck.Unconscious(ROGUE_CRIT_KNOCKOUT + (from_behind ? ROGUE_CRIT_KNOCKOUT_BEHIND : 0))
		log_combat(attacker, struck, "knocked out", null, "(ZONE: [zone]) (CLASS: [bclass])")
		return TRUE
	for(var/path in shuffle(candidates))
		var/datum/wound/rogue/crit = rogue_add_wound(path, FALSE, TRUE)
		if(!crit)
			continue
		// Azure Peak: a burn's crit shakes the one who dealt it.
		if(bclass == BCLASS_BURN && attacker && attacker != struck)
			shake_camera(attacker, 2, 2)
		log_combat(attacker, struck, "critically struck", null, "(ZONE: [zone]) (CLASS: [bclass]) (WOUND: [crit.name])")
		// K2d1: the weapon may stick in the part (combat/stuck_weapon.dm).
		struck.rogue_mark_stick(bclass, crit.rogue_stick_attempt(bclass), attacker)
		return crit
	return FALSE

/// What combat/stuck_weapon.dm reads of a crit for the chance its weapon sticks: list(TG wounding kind, TG severity, organ crit).
/datum/wound/rogue/proc/rogue_stick_attempt(bclass)
	return list(null, null, null)

/datum/wound/rogue/artery/rogue_stick_attempt(bclass)
	return list(rogue_bclass_to_wound(bclass), WOUND_SEVERITY_CRITICAL, null)

/datum/wound/rogue/facial/ears/rogue_stick_attempt(bclass)
	return list(null, null, ROGUE_CRIT_EARS)

/datum/wound/rogue/facial/eyes/rogue_stick_attempt(bclass)
	return list(null, null, ROGUE_CRIT_EYES)

/datum/wound/rogue/fracture/head/brain/rogue_stick_attempt(bclass)
	return list(null, null, ROGUE_CRIT_BRAIN)

/// A crit dealt by its TG kind and severity (combat/stuck_weapon.dm twist): on a medieval body the crit of rogue_tg_crit_type()
/// opens at once, told as a crit; a disembowelment spills the guts (combat/dismember.dm); elsewhere TG's wound.
/mob/living/carbon/proc/rogue_apply_crit(obj/item/bodypart/limb, wounding_type, severity, special, mob/living/attacker)
	if(special == ROGUE_CRIT_DISEMBOWEL)
		return rogue_disembowel(attacker)
	if(!limb || !wounding_type)
		return FALSE
	if(!HAS_TRAIT(src, TRAIT_ROGUE_WOUNDS))
		return !!cause_wound_of_type_and_severity(wounding_type, limb, severity, severity, wound_source = ROGUE_CRIT_WOUND_SOURCE)
	var/crit_type = limb.rogue_tg_crit_type(wounding_type, severity, ROGUE_CRIT_WOUND_SOURCE)
	if(!crit_type)
		return FALSE
	var/datum/wound/rogue/crit = new crit_type
	crit.rogue_forced = TRUE
	return !!limb.rogue_add_wound(crit, FALSE, TRUE)

/// Azure Peak's on_mob_gain() of a crit: a long slowdown, the sight shaken, and one with a mind is left critically wounded.
/// The emote is the crit's own (gain_emote).
/mob/living/carbon/proc/rogue_crit_wound_shock()
	rogue_slow_for(rogue_value("crit_wound_slow_time"))
	shake_camera(src, 2, 2)
	if(mind)
		rogue_critwound()
