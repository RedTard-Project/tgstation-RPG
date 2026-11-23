/// Vibelin's torn arteries (code/datums/wounds/arteries.dm and the artery organs, modules/surgery/organs/internal/artery/) as a
/// crit of combat/wounds.dm that stays on the limb until the artery is mended, with Azure Peak's artery wound on top
/// (datums/wounds/types/arteries.dm: its health, pain, sewing and sewn state). An artery is torn only through a cut that
/// still bleeds; a tear takes a share of the artery's health and a second one past it dissects it, and the torn artery
/// bleeds by how much of it is torn (the pulse is the blood tick's, combat/blood.dm). The carotid and the aorta are torn
/// through at once and kill the critically weak. Sewing it (combat/medicine.dm) or searing it mends the artery and leaves
/// the sewn wound; mending it whole by other means (potions, miracles) mends the artery too.

/obj/item/bodypart
	/// Vibelin artery health of the limb's own arteries (not the carotid nor the aorta, which are torn through at once); null
	/// while whole.
	var/rogue_artery_health

/// The health of a whole artery of a limb.
/obj/item/bodypart/proc/rogue_artery_max()
	return rogue_value("wound_artery_health")

/// Vibelin artery is_bruised(): the limb's artery is torn.
/obj/item/bodypart/proc/rogue_artery_torn()
	return !isnull(rogue_artery_health) && rogue_artery_health < rogue_artery_max()

/// How much of the limb's artery is torn, 0 to 1 (Vibelin damage / maxHealth).
/obj/item/bodypart/proc/rogue_artery_share()
	if(isnull(rogue_artery_health))
		return 0
	var/most = rogue_artery_max()
	return most > 0 ? clamp(1 - rogue_artery_health / most, 0, 1) : 0

/// Vibelin tear() and dissect(): a tear takes its share of the artery's health; a dissection, or a tear of an artery left with
/// no more than that share, tears it through.
/obj/item/bodypart/proc/rogue_tear_artery(dissect = FALSE)
	var/most = rogue_artery_max()
	var/health = isnull(rogue_artery_health) ? most : rogue_artery_health
	var/share = rogue_value(body_zone == BODY_ZONE_CHEST ? "wound_artery_tear_share_chest" : "wound_artery_tear_share")
	if(dissect || health <= most * share)
		rogue_artery_health = 0
	else
		rogue_artery_health = max(health - most * share, 0)

/// Vibelin mend(): the limb's artery is whole again.
/obj/item/bodypart/proc/rogue_mend_artery()
	rogue_artery_health = null

/// Vibelin /datum/wound/artery: the limb's arteries torn through a bleeding cut.
/datum/wound/rogue/artery
	name = "torn artery"
	rogue_key = "artery"
	severity = WOUND_SEVERITY_SEVERE
	crit_message = list(
		"Blood sprays from %VICTIM's %BODYPART!",
		"Blood rushes from %VICTIM's %BODYPART!",
		"Blood bursts from %VICTIM's %BODYPART with a great force!",
	)
	sound_effect = 'sound/effects/wounds/blood3.ogg'
	critical = TRUE
	can_roll = TRUE
	strong_intent_bonus = TRUE
	aimed_intent_bonus = TRUE
	required_organic = TRUE
	can_sew = TRUE
	can_cauterize = TRUE
	rogue_sewn_clots = FALSE
	gain_emote = "paincrit"
	rogue_chat_span = "artery"
	associated_bclasses = list(BCLASS_CUT, BCLASS_CHOP, BCLASS_STAB, BCLASS_PICK, BCLASS_BITE, BCLASS_PIERCE)
	viable_zones = list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_MOUTH, "stomach", BODY_ZONE_PRECISE_GROIN, BODY_ZONE_CHEST, BODY_ZONE_HEAD)
	/// The artery is torn through at once and bleeds on its own, not by the limb's artery (the carotid, the aorta).
	var/rogue_own_artery = FALSE

/// Vibelin: only through a cut that still bleeds (a TG wound turned into it cuts the limb itself, rogue_tg_wound()).
/datum/wound/rogue/artery/rogue_can_apply(obj/item/bodypart/limb, zone, bclass)
	return ..() && (rogue_forced || limb.rogue_open_cut())

/// Vibelin apply_to_bodypart(): the artery tears (through, for a critical one) as the crit goes on, so the blood element
/// already sees it bleed when TG tells of the new wound (the bandage soaks through); it is as it was if the crit does not take.
/datum/wound/rogue/artery/apply_wound(obj/item/bodypart/limb, silent = FALSE, datum/wound/old_wound = null, smited = FALSE, attack_direction = null, wound_source = "Unknown", replacing = FALSE)
	var/was = limb?.rogue_artery_health
	if(limb && !rogue_own_artery)
		limb.rogue_tear_artery(severity >= WOUND_SEVERITY_CRITICAL)
	. = ..()
	if(limb && !rogue_own_artery && (QDELETED(src) || src.limb != limb))
		limb.rogue_artery_health = was

/// The artery is mended once its wound is gone, unless the limb itself goes.
/datum/wound/rogue/artery/rogue_on_loss(obj/item/bodypart/old_limb, mob/living/carbon/old_victim, replaced, destroying)
	. = ..()
	if(old_limb && !destroying && !rogue_own_artery)
		old_limb.rogue_mend_artery()

/// Vibelin artery on_life(): unsewn, it bleeds by how much of the artery is torn; sewn, as its sewn state.
/datum/wound/rogue/artery/rogue_bleed()
	if(rogue_is_sewn() || !can_sew)
		return max(bleed_rate, 0)
	if(rogue_own_artery)
		return rogue_number("flow")
	if(!limb)
		return 0
	var/flow_field = "flow"
	switch(limb.body_zone)
		if(BODY_ZONE_HEAD)
			flow_field = "flow_head"
		if(BODY_ZONE_CHEST)
			flow_field = "flow_chest"
	return rogue_number(flow_field) * limb.rogue_artery_share()

/datum/wound/rogue/artery/rogue_set_bleed(rate)
	if(rogue_is_sewn() || !can_sew)
		return ..()

/// The stitches close the artery (Vibelin's operation, here the needle): it is whole, and the wound takes its sewn state.
/datum/wound/rogue/artery/rogue_sew_wound()
	. = ..()
	if(. && limb && !rogue_own_artery)
		limb.rogue_mend_artery()

/// Searing closes the artery as stitches do, and mends the wound a little (Azure Peak can_cauterize).
/datum/wound/rogue/artery/rogue_cauterize(amount)
	if(!can_cauterize)
		return FALSE
	can_cauterize = FALSE
	if(can_sew)
		rogue_sew_wound()
	rogue_heal_wound(isnull(amount) ? rogue_number("cauterize_heal") : amount)
	return TRUE

/datum/wound/rogue/artery/rogue_clotted()
	return FALSE

/datum/wound/rogue/artery/get_bleed_rate_of_change()
	return BLOOD_FLOW_STEADY

/// Vibelin artery/neck_slice: the carotid, torn through; mortal.
/datum/wound/rogue/artery/neck
	name = "torn carotid"
	rogue_key = "artery_neck"
	severity = WOUND_SEVERITY_CRITICAL
	mortal = TRUE
	rogue_own_artery = TRUE
	crit_message = list("Blood sprays from %VICTIM's throat!")
	viable_zones = list("neck")

/// Vibelin artery/heart: the aorta, torn through only past broken ribs or by a piercing blow, and only with a heart; mortal.
/datum/wound/rogue/artery/heart
	name = "aortic dissection"
	rogue_key = "artery_heart"
	severity = WOUND_SEVERITY_CRITICAL
	mortal = TRUE
	rogue_own_artery = TRUE
	crit_message = list("A fountain of blood erupts from %VICTIM!")
	viable_zones = list(BODY_ZONE_CHEST)

/datum/wound/rogue/artery/heart/rogue_can_apply(obj/item/bodypart/limb, zone, bclass)
	if(limb.body_zone != BODY_ZONE_CHEST || !limb.owner?.get_organ_slot(ORGAN_SLOT_HEART))
		return FALSE
	if((limb.biological_state & BIO_BONE) && !limb.rogue_has_wound(/datum/wound/rogue/fracture) && !(bclass in GLOB.rogue_artery_heart_classes))
		return FALSE
	return ..()

/// Vibelin artery/heart tear(): one vomits blood and feels the heart go.
/datum/wound/rogue/artery/heart/rogue_on_gain()
	. = ..()
	if(QDELETED(src) || !victim || victim.stat == DEAD)
		return
	victim.vomit(VOMIT_CATEGORY_BLOOD)
	var/static/list/heartaches = list(
		"OOHHHH MY HEART!",
		"MY HEART! IT HURTS!",
		"I AM DYING!",
		"MY HEART IS TORN!",
		"MY HEART IS BLEEDING!",
	)
	to_chat(victim, span_userdanger(pick(heartaches)))

/datum/wound_pregen_data/rogue_crit/artery
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/artery

/datum/wound_pregen_data/rogue_crit/artery_neck
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/artery/neck

/datum/wound_pregen_data/rogue_crit/artery_heart
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/artery/heart
