/// Field medicine on medieval maps, on Vibelin's model of the body (block VR1): a needle sews first a torn artery, then the
/// crits that can be sewn, then the injuries of the limb (Vibelin game/objects/items/needle.dm sew_wounds()); cloth and
/// bandages bind a limb, soak up the blood under them until it soaks through, and what the cloth is soaked in seeps into the
/// body (Vibelin bodypart_wounds.dm try_bandage(), try_bandage_expire(), organ_processing/heart.dm). The module's own soaking
/// of a cloth in a potion or blessed water (Ratwood clothfibersthorn.dm) stays: such a cloth heals the limb it binds, and those
/// medicines never seep in as well, so nothing heals twice. Ratwood's bandage shows on the body (human/update_icons.dm).
/// The crits mend by potions, soups, miracles and sleep (rogue_heal_wounds(), Vibelin heal_wounds()); the injuries mend by
/// what heals the limb's damage. TG's wounds that still come to a medieval body (from admins, smites) keep Ratwood's
/// stitching and the sewn tail of the module as before.

/// The sheets of Ratwood's body damage, with the bandage of each limb ("<zone>_b", Ratwood icons/roguetown/mob/bodies/dam/).
#define ROGUE_BANDAGE_SHEET_MALE 'modular_redtard/icons/mob/dam_male.dmi'
#define ROGUE_BANDAGE_SHEET_FEMALE 'modular_redtard/icons/mob/dam_female.dmi'
/// The series of the sewn tails: a limb may carry any number of them.
#define ROGUE_WOUND_SERIES_SEWN "rogue_wound_series_sewn"
/// Ratwood's aqua vitae, which comes with its drinks (block 1, alcohol): the cloth soaks it once the reagent exists.
#define ROGUE_AQUA_VITAE_PATH "/datum/reagent/consumable/ethanol/aqua_vitae"
/// Every kind of injury, for flagging all of a limb's injuries at once.
#define ROGUE_INJURY_ALL (ROGUE_INJURY_BRUTE|ROGUE_INJURY_FIRE)

/// The numbers of treatment read every Life tick of every body (a soaked bandage, a tourniquet, a leech), read once and again
/// only when the mechanics numbers change (survival/sleep.dm read_numbers()).
/proc/rogue_treatment_numbers()
	var/static/list/numbers
	var/static/revision = -1
	if(numbers && revision == rogue_mechanics_revision())
		return numbers
	revision = rogue_mechanics_revision()
	numbers = list(
		"soak_spend" = rogue_value("soak_spend"),
		"tourniquet_ischemia_delay" = rogue_value("tourniquet_ischemia_delay"),
		"tourniquet_necrosis_delay" = rogue_value("tourniquet_necrosis_delay"),
		"tourniquet_pain_chance" = rogue_value("tourniquet_pain_chance"),
		"tourniquet_pain_min" = rogue_value("tourniquet_pain_min"),
		"tourniquet_pain_max" = rogue_value("tourniquet_pain_max"),
		"tourniquet_message_chance" = rogue_value("tourniquet_message_chance"),
		"tourniquet_message_pain" = rogue_value("tourniquet_message_pain"),
		"leech_digest" = rogue_value("leech_digest"),
		"leech_open_wound_factor" = rogue_value("leech_open_wound_factor"),
		"leech_immune_factor" = rogue_value("leech_immune_factor"),
		"cheele_blood_cap" = rogue_value("cheele_blood_cap"),
		"abyssoid_pray_chance" = rogue_value("abyssoid_pray_chance"),
	)
	return numbers

// ---------------------------------------------------------------------------------------------------------------------------
// TG's wounds sewn stitch by stitch (Ratwood), the fallback for wounds that are not Vibelin's crits.

/datum/wound
	/// Ratwood sew_progress: how far the stitches have got.
	var/rogue_sew_progress = 0
	/// Blood per second the stitches already hold back (Ratwood lowers bleed_rate with every stitch); the blood of the body
	/// counts it against the wound's bleeding.
	var/rogue_stitched = 0

/// How far the stitches must get to sew this wound (Ratwood sew_threshold); 0 when Ratwood's stitching cannot sew it.
/datum/wound/proc/rogue_sew_threshold()
	return 0

/datum/wound/slash/flesh/rogue_sew_threshold()
	return rogue_cut_sew_threshold()

/datum/wound/pierce/bleed/rogue_sew_threshold()
	return rogue_cut_sew_threshold()

/// A cut or a stab: a small one sews quickly, an opened artery takes long (Ratwood slash 25 and 50, artery 100).
/datum/wound/proc/rogue_cut_sew_threshold()
	if(severity >= WOUND_SEVERITY_CRITICAL)
		return rogue_value("sew_threshold_artery")
	return severity >= WOUND_SEVERITY_SEVERE ? rogue_value("sew_threshold_severe") : rogue_value("sew_threshold_moderate")

/// The wound is sewn shut (Ratwood sew_wound()): a cut or a stab of TG becomes its sewn tail, which still bleeds and hurts a
/// little until it has healed, and leaves the cut's scar then.
/datum/wound/proc/rogue_sew_done()
	var/datum/wound/rogue/sewn/sewn = new
	sewn.rogue_sew_from(src)
	replace_wound(sewn)
	if(!QDELETED(sewn) && sewn.limb)
		sewn.rogue_set_bleed(sewn.rogue_sewn_bleed / ROGUE_LIFE_TICK)

/// A stitch holds blood back (Ratwood: each stitch lowers bleed_rate by half the doctor's Medicine, hold a second's).
/datum/wound/proc/rogue_stitch(hold)
	rogue_stitched += hold

/// A crit's bleeding is its own (bleed_rate, combat/wounds.dm): the stitch holds it back there.
/datum/wound/rogue/rogue_stitch(hold)
	rogue_set_bleed(rogue_bleed() - hold)

/// Blood per second this wound still loses, stitches counted.
/datum/wound/proc/rogue_bleeding_left()
	return max(blood_flow - rogue_stitched, 0)

/datum/wound/rogue/rogue_bleeding_left()
	return rogue_bleed()

/// Vibelin on_bodypart_gain(): "new bleeding wounds always expire bandages" - a crit that bleeds soaks through the bandage on
/// its limb (rogue_bandage_expire()). TG's cuts and stabs count only from critical up, an opened artery.
/datum/wound/proc/rogue_soaks_bandage()
	var/datum/wound/rogue/crit = src
	return istype(crit) && crit.rogue_bleed() > 0

/datum/wound/slash/flesh/rogue_soaks_bandage()
	return severity >= WOUND_SEVERITY_CRITICAL

/datum/wound/pierce/bleed/rogue_soaks_bandage()
	return severity >= WOUND_SEVERITY_CRITICAL

/datum/wound/rogue_stump/rogue_soaks_bandage()
	return TRUE

/// What the wound mends a Life tick of sleep, times the quality of the bed (Ratwood sleep_healing: 1 for most wounds).
/datum/wound/proc/rogue_sleep_healing()
	return rogue_value("wound_sleep_healing")

/// An opened artery mends slowly in sleep (Ratwood artery sleep_healing 0.5).
/datum/wound/slash/flesh/rogue_sleep_healing()
	return severity >= WOUND_SEVERITY_CRITICAL ? rogue_value("artery_sleep_healing") : ..()

/datum/wound/pierce/bleed/rogue_sleep_healing()
	return severity >= WOUND_SEVERITY_CRITICAL ? rogue_value("artery_sleep_healing") : ..()

/// A broken bone does not mend in sleep until it is set (Ratwood fracture sleep_healing 0); a dislocation does.
/datum/wound/blunt/bone/rogue_sleep_healing()
	return severity >= WOUND_SEVERITY_SEVERE ? rogue_value("fracture_sleep_healing") : ..()

/datum/wound/cranial_fissure/rogue_sleep_healing()
	return rogue_value("fracture_sleep_healing")

/// A stump is only seared shut (Ratwood dismemberment sleep_healing 0).
/datum/wound/rogue_stump/rogue_sleep_healing()
	return rogue_value("stump_sleep_healing")

/datum/wound/rogue_stump/rogue_sew_threshold()
	return sewn < stumps ? rogue_value("sew_threshold_stump") : 0

/// A sewn stump bleeds and hurts little (Ratwood sewn_bleed_rate 0.25, sewn_woundpain 20); searing still closes it.
/datum/wound/rogue_stump/rogue_sew_done()
	sewn++
	rogue_sew_progress = 0
	rogue_stitched = 0
	adjust_blood_flow(ROGUE_STUMP_SEWN_BLEED - ROGUE_STUMP_BLEED)

/// The sewn tail of a cut or a stab of TG (Ratwood sew_wound()): the wound stays, sewn, with the little bleeding and pain of
/// its sewn state and no more than its sewn health to mend (sewn_bleed_rate, sewn_woundpain, sewn_whp), mends a little each
/// Life tick by itself, in sleep and under medicine. Healed, it leaves the scar the cut would have left. It counts on
/// Vibelin's crit fields (combat/wounds.dm): whp, woundpain, passive_healing.
/datum/wound/rogue/sewn
	name = "sewn wound"
	desc = "A sewn wound, still tender, slowly knitting."
	treat_text = "Let it heal; rest and medicine speed it."
	treat_text_short = "Let it heal"
	examine_desc = "has a sewn wound"
	/// The blood of a Life tick it still loses (Ratwood's numbers), set once it is on the limb.
	var/rogue_sewn_bleed = 0

/// Takes over from the wound being sewn: its name, size and scar, and the sewn state of its kind (Ratwood's slashes,
/// punctures and arteries).
/datum/wound/rogue/sewn/proc/rogue_sew_from(datum/wound/old)
	name = "sewn [LOWER_TEXT(old.name)]"
	severity = old.severity
	can_scar = old.can_scar
	scar_keyword = old.scar_keyword
	default_scar_file = old.default_scar_file
	var/stab = istype(old, /datum/wound/pierce)
	var/most
	if(old.severity >= WOUND_SEVERITY_CRITICAL)
		most = rogue_value("sewn_artery_health")
		rogue_sewn_bleed = rogue_value("sewn_artery_bleed")
		woundpain = rogue_value("sewn_artery_pain")
	else if(old.severity >= WOUND_SEVERITY_SEVERE)
		most = stab ? rogue_value("sewn_stab_severe_health") : rogue_value("sewn_cut_severe_health")
		rogue_sewn_bleed = stab ? rogue_value("sewn_stab_severe_bleed") : rogue_value("sewn_cut_severe_bleed")
		woundpain = rogue_value("sewn_cut_pain")
	else
		most = stab ? rogue_value("sewn_stab_moderate_health") : rogue_value("sewn_cut_moderate_health")
		rogue_sewn_bleed = stab ? rogue_value("sewn_stab_moderate_bleed") : rogue_value("sewn_cut_moderate_bleed")
		woundpain = rogue_value("sewn_cut_pain")
	var/left = isnull(old.rogue_health) ? old.rogue_health_max() : old.rogue_health
	whp = left > 0 ? min(left, most) : most
	passive_healing = rogue_value("sewn_passive_healing")
	damage_multiplier_penalty = 1

/// A sewn tail is already closed: it does not soak through a bandage.
/datum/wound/rogue/sewn/rogue_soaks_bandage()
	return FALSE

/// Any number of sewn tails on a limb, beside the wounds of every series (the cut that is sewn is already gone).
/datum/wound_pregen_data/rogue_sewn
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/sewn
	can_be_randomly_generated = FALSE
	compete_for_wounding = FALSE
	duplicates_allowed = TRUE
	required_limb_biostate = BIO_FLESH
	required_wounding_type = WOUND_ALL
	wound_series = ROGUE_WOUND_SERIES_SEWN

/datum/wound_pregen_data/rogue_sewn/can_be_applied_to(obj/item/bodypart/limb, suggested_wounding_type = required_wounding_type, datum/wound/old_wound, random_roll = FALSE, duplicates_allowed = src.duplicates_allowed, care_about_existing_wounds = TRUE)
	return ..(limb, suggested_wounding_type, old_wound, random_roll, TRUE, FALSE)

// ---------------------------------------------------------------------------------------------------------------------------
// Mending: the health of TG's wounds (Ratwood whp); Vibelin's crits keep theirs in whp (combat/wounds.dm).

/datum/wound
	/// Ratwood whp of a wound of TG: what is left to mend before it closes; null until it is first mended.
	var/rogue_health

/// What mending this wound of TG takes before it closes (Ratwood whp by its kind and size); 0 when mending does not close it.
/datum/wound/proc/rogue_health_max()
	return 0

/datum/wound/slash/flesh/rogue_health_max()
	return rogue_cut_health(rogue_value("wound_health_cut_moderate"), rogue_value("wound_health_cut_severe"))

/datum/wound/pierce/bleed/rogue_health_max()
	return rogue_cut_health(rogue_value("wound_health_stab_moderate"), rogue_value("wound_health_stab_severe"))

/// A cut or a stab by its size; a critical one is an opened artery.
/datum/wound/proc/rogue_cut_health(moderate, severe)
	if(severity >= WOUND_SEVERITY_CRITICAL)
		return rogue_value("wound_health_artery")
	return severity >= WOUND_SEVERITY_SEVERE ? severe : moderate

/datum/wound/blunt/bone/rogue_health_max()
	return limb?.body_zone == BODY_ZONE_HEAD && severity >= WOUND_SEVERITY_SEVERE ? rogue_value("wound_health_skull") : rogue_value("wound_health_bone")

/datum/wound/cranial_fissure/rogue_health_max()
	return rogue_value("wound_health_skull")

/datum/wound/burn/flesh/rogue_health_max()
	if(severity >= WOUND_SEVERITY_CRITICAL)
		return rogue_value("wound_health_burn_critical")
	return severity >= WOUND_SEVERITY_SEVERE ? rogue_value("wound_health_burn_severe") : rogue_value("wound_health_burn_moderate")

/// Ratwood heal_wound(): mends the wound by the amount and eases its pain by half of it (combat/pain.dm); with nothing left to
/// mend it closes (a cut, a stab, a burn or a broken bone of TG is gone, and scars as TG's do). Returns what it took of the
/// amount. Vibelin's crits mend their own way (combat/wounds.dm).
/datum/wound/proc/rogue_heal_wound(amount)
	var/most = rogue_health_max()
	if(!most || amount <= 0)
		return 0
	if(isnull(rogue_health))
		rogue_health = most
	var/healed = min(rogue_health, amount)
	rogue_health -= healed
	rogue_ease_pain(amount)
	if(rogue_health <= 0)
		qdel(src)
	return healed

/// A stump mends by the searing it still needs (integrity): Ratwood's potions heal a stump's whp as the searing does.
/datum/wound/rogue_stump/rogue_heal_wound(amount)
	if(amount <= 0 || integrity <= 0)
		return 0
	var/healed = min(integrity, amount)
	integrity -= healed
	if(victim)
		victim.rogue_pain_hud_dirty = TRUE
	if(integrity <= 0)
		to_chat(victim, span_green("My [stumps > 1 ? "stumps close" : "stump closes"]."))
		qdel(src)
	return healed

/// Vibelin heal_wounds(): mends the wounds one after another, each taking what it needs of the amount and passing the rest on.
/// TRUE when any of them mended.
/proc/rogue_mend_wounds(list/wounds, amount)
	. = FALSE
	for(var/datum/wound/wound as anything in LAZYCOPY(wounds))
		if(amount <= 0)
			break
		if(QDELETED(wound))
			continue
		var/healed = wound.rogue_heal_wound(amount)
		if(healed)
			amount -= healed
			. = TRUE

/// Vibelin heal_wounds() (living_wounds.dm): potions, soups, miracles and sleep mend the crits by their health. The injuries are
/// the limb's damage, and mend by what heals the damage (each of these also heals brute and burn, combat/injuries/), so they
/// are not mended here a second time.
/mob/living/carbon/proc/rogue_heal_wounds(amount)
	return rogue_mend_wounds(all_wounds, amount)

/obj/item/bodypart/proc/rogue_heal_wounds(amount)
	return rogue_mend_wounds(wounds, amount)

// ---------------------------------------------------------------------------------------------------------------------------
// The needle (Vibelin sew_wounds()).

/// The wounds of this limb a needle can sew, a torn artery first (Vibelin: "First try to fix arteries"): Vibelin's crits that
/// can be sewn (combat/wounds.dm rogue_sewable()) and TG's wounds Ratwood's stitching sews.
/obj/item/bodypart/proc/rogue_sewable_wounds()
	. = list()
	var/list/arteries = list()
	for(var/datum/wound/wound as anything in wounds)
		var/datum/wound/rogue/crit = wound
		if(!wound.rogue_sew_threshold() && !(istype(crit) && crit.rogue_sewable()))
			continue
		if(istype(wound, /datum/wound/rogue/artery))
			arteries += wound
		else
			. += wound
	. = arteries + .

/// One thread of the needle spent; FALSE when it has none left.
/obj/item/needle/proc/rogue_use_thread()
	if(infinite)
		return TRUE
	if(stringamt < 1)
		return FALSE
	stringamt--
	update_appearance(UPDATE_OVERLAYS)
	return TRUE

/// Vibelin sew_wounds(): on the limb aimed at, through what does not cover it, never under a bandage. A torn artery is sewn
/// first, then a crit chosen among those that can be sewn (stitch after stitch until it is sewn, combat/wounds.dm
/// rogue_sew_step()); with none, the injuries of the limb that can be sewn are stitched one after another, each by a part
/// of its damage, until one is stitched shut down to the size it heals from by itself. A doctor with good perception and
/// skill stitches faster.
/obj/item/needle/proc/rogue_sew(mob/living/carbon/patient, mob/living/user)
	var/obj/item/bodypart/limb = patient.get_bodypart(check_zone(user.zone_selected))
	if(!limb)
		to_chat(user, span_warning("That limb is missing."))
		return FALSE
	if(!infinite && stringamt < 1)
		to_chat(user, span_warning("The needle has no thread left!"))
		return FALSE
	if(!patient.try_inject(user, limb.body_zone, INJECT_TRY_SHOW_ERROR_MESSAGE))
		return FALSE
	if(limb.rogue_bandage)
		to_chat(user, span_warning("There is a bandage in the way."))
		return FALSE
	var/list/sewable = limb.rogue_sewable_wounds()
	if(length(sewable))
		var/datum/wound/target = sewable[1]
		if(length(sewable) > 1 && !istype(target, /datum/wound/rogue/artery))
			var/list/choices = list()
			for(var/datum/wound/wound as anything in sewable)
				choices[avoid_assoc_duplicate_keys(capitalize(wound.name), choices)] = wound
			target = choices[tgui_input_list(user, "Which critical wound?", "[src]", choices)]
			if(QDELETED(target) || QDELETED(src) || target.limb != limb)
				return FALSE
		if(target.rogue_sew_threshold())
			return rogue_stitch_wound(target, patient, user)
		return rogue_sew_crit(target, patient, user)
	return rogue_sew_injuries(limb, patient, user)

/// Vibelin do_sewing_step(): a stitch at a time, a thread a stitch, until the crit is sewn (combat/wounds.dm
/// rogue_sew_step(): the stitch, its progress and its lesson).
/obj/item/needle/proc/rogue_sew_crit(datum/wound/rogue/crit, mob/living/carbon/patient, mob/living/user)
	var/obj/item/bodypart/limb = crit.limb
	while(!QDELETED(crit) && crit.limb == limb && crit.rogue_sewable())
		if(QDELETED(src) || !user.is_holding(src))
			return FALSE
		if(!infinite && stringamt < 1)
			to_chat(user, span_warning("The needle has no thread left!"))
			return FALSE
		playsound(patient, 'modular_redtard/rockhill/sound/foley/sewflesh.ogg', 100, TRUE, -2)
		if(!do_after(user, rogue_value("sew_crit_time"), target = patient))
			to_chat(user, span_warning("I must stand still!"))
			return FALSE
		if(QDELETED(crit) || crit.limb != limb || !crit.rogue_sewable())
			return FALSE
		log_combat(user, patient, "sewed a wound", src)
		var/done = crit.rogue_sew_step(user, src)
		rogue_use_thread()
		if(done)
			return TRUE
	return FALSE

/// Vibelin sew_wounds(), its injuries: each stitch closes a part of the injury's damage, never below the size it heals
/// from by itself (Vibelin autoheal_cutoff; a surgical incision has none); stitched down to it, the injury is sutured and
/// stops bleeding. A sutured incision closes the site of the operation with it.
/obj/item/needle/proc/rogue_sew_injuries(obj/item/bodypart/limb, mob/living/carbon/patient, mob/living/user)
	var/perception = 1 - rogue_value("sew_perception_per_point") * (user.rogue_stat(ROGUE_STAT_PERCEPTION) - ROGUE_ATTRIBUTE_MIDDLING)
	var/skill = 1 - rogue_value("sew_skill_factor") * (user.rogue_skill(/datum/attribute/skill/misc/medicine) - ROGUE_SKILL_LEVEL_JOURNEYMAN) / max(ROGUE_SKILL_MAX - ROGUE_SKILL_LEVEL_JOURNEYMAN, 1)
	var/speed = max(perception * skill, rogue_value("sew_time_min_factor"))
	var/sewed = FALSE
	for(var/datum/rogue_injury/injury as anything in LAZYCOPY(limb.rogue_injuries))
		if(QDELETED(injury) || !(injury.kind & ROGUE_INJURY_SEWABLE) || (injury.injury_flags & ROGUE_INJ_SUTURED))
			continue
		var/size = rogue_injury_size(injury)
		var/time = (rogue_value("sew_injury_time") + min(size * rogue_value("sew_injury_time_per_damage"), rogue_value("sew_injury_time_extra_max"))) * speed
		playsound(patient, 'modular_redtard/rockhill/sound/foley/sewflesh.ogg', 65, FALSE)
		if(!do_after(user, time, target = patient))
			to_chat(user, span_warning("I must stand still!"))
			return sewed
		if(QDELETED(injury) || injury.limb != limb || limb.owner != patient)
			return sewed
		if(!rogue_use_thread())
			to_chat(user, span_warning("The needle has no thread left!"))
			return sewed
		user.rogue_craft_experience(/datum/attribute/skill/misc/medicine, user.rogue_stat(ROGUE_STAT_INTELLIGENCE) * rogue_value("sew_injury_xp"))
		sewed = TRUE
		var/desc = injury.get_desc()
		var/cutoff = rogue_injury_autoheal_cutoff(injury)
		var/surgical = injury.injury_flags & ROGUE_INJ_SURGICAL
		// The cutoff is of one injury, the damage of all the merged ones (review VR2r, finding 13).
		var/heal = min(rogue_value("sew_injury_heal"), injury.damage - cutoff * injury.amount)
		if(heal > 0)
			injury.heal_damage(heal)
		if(!QDELETED(injury) && rogue_injury_size(injury) > cutoff)
			user.visible_message(span_green("<b>[user]</b> partially stitches \a [desc] on <b>[patient]</b>'s [limb.plaintext_zone] with \the [src]."), span_green("I partially stitch \a [desc] on \the [limb.plaintext_zone] with \the [src]."))
			continue
		user.visible_message(span_green("<b>[user]</b> stitches \a [desc] shut on <b>[patient]</b>'s [limb.plaintext_zone] with \the [src]."), span_green("I stitch \a [desc] shut on \the [limb.plaintext_zone] with \the [src]."))
		if(!QDELETED(injury))
			injury.injury_flags |= ROGUE_INJ_SUTURED
		log_combat(user, patient, "sewed", src)
		if(surgical)
			limb.rogue_close_surgical_site()
		break
	if(!sewed)
		to_chat(user, span_warning("There aren't any wounds or injuries left to be sewn."))
	return sewed

/// Ratwood's sew() for TG's wounds and the module's surgical crits: every two seconds a stitch, which holds back half the
/// doctor's Medicine of blood (at least 1, per Life tick) and gets the stitches (Medicine + 1) * 5 further; when they reach
/// the wound's threshold it is sewn and the needle spends a thread. The doctor learns a little with each stitch and more on
/// finishing, by intelligence.
/obj/item/needle/proc/rogue_stitch_wound(datum/wound/target, mob/living/carbon/patient, mob/living/user)
	var/obj/item/bodypart/limb = target.limb
	var/rank = user.rogue_skill_rank(/datum/attribute/skill/misc/medicine)
	var/step = (rank + 1) * rogue_value("sew_step_per_rank")
	var/hold = max(rank * rogue_value("sew_hold_per_rank"), rogue_value("sew_hold_min")) / ROGUE_LIFE_TICK
	var/informed = FALSE
	while(!QDELETED(target) && target.limb == limb && !QDELETED(src) && user.is_holding(src))
		if(!infinite && stringamt < 1)
			to_chat(user, span_warning("The needle has no thread left!"))
			return FALSE
		var/threshold = target.rogue_sew_threshold()
		if(!threshold)
			return FALSE
		if(!do_after(user, rogue_value("sew_stitch_time"), target = patient))
			return FALSE
		if(QDELETED(target) || target.limb != limb)
			return FALSE
		user.rogue_craft_experience(/datum/attribute/skill/misc/medicine, user.rogue_stat(ROGUE_STAT_INTELLIGENCE) * rogue_value("sew_xp_step"))
		playsound(patient, 'modular_redtard/rockhill/sound/foley/sewflesh.ogg', 100, TRUE, -2)
		target.rogue_sew_progress = min(target.rogue_sew_progress + step, threshold)
		target.rogue_stitch(hold)
		if(!informed && target.rogue_bleeding_left() <= 0)
			informed = TRUE
			patient.visible_message(span_green("One last drop of blood trickles from the [target.name] on [patient]'s [limb.plaintext_zone] before it closes."), span_green("The throbbing warmth coming out of the [target.name] soothes and stops. It no longer bleeds."))
		if(target.rogue_sew_progress < threshold)
			continue
		user.rogue_craft_experience(/datum/attribute/skill/misc/medicine, user.rogue_stat(ROGUE_STAT_INTELLIGENCE) * rogue_value("sew_xp_finish") * threshold / rogue_value("sew_xp_normalizer"))
		rogue_use_thread()
		if(patient == user)
			user.visible_message(span_notice("[user] sews \a [target.name] on [user.p_them()]self."), span_notice("I stitch \a [target.name] on my [limb.plaintext_zone]."))
		else
			user.visible_message(span_notice("[user] sews \a [target.name] on [patient]'s [limb.plaintext_zone]."), span_notice("I stitch \a [target.name] on [patient]'s [limb.plaintext_zone]."))
		log_combat(user, patient, "sewed", src)
		target.rogue_sew_done()
		return TRUE
	return FALSE

/// How big one of the injury's wounds is (Vibelin damage_per_injury()).
/proc/rogue_injury_size(datum/rogue_injury/injury)
	return injury.amount > 0 ? injury.damage / injury.amount : injury.damage

/// The size below which the injury heals by itself (Vibelin autoheal_cutoff); a surgical incision has none.
/proc/rogue_injury_autoheal_cutoff(datum/rogue_injury/injury)
	if(injury.injury_flags & ROGUE_INJ_SURGICAL)
		return 0
	return injury.autoheal_cutoff || 0

// ---------------------------------------------------------------------------------------------------------------------------
// Cloth and bandages (Vibelin natural/cloth.dm, bodypart_wounds.dm; Ratwood's soaking).

/obj/item/natural/cloth
	/// Deciseconds bandaging with it takes, before the Medicine skill shortens it (Vibelin bandage_speed).
	var/rogue_bandage_time = 7 SECONDS
	/// Blood it soaks up as a bandage before it is soaked through (Vibelin bandage_health).
	var/rogue_bandage_capacity = 150
	/// What it can still soak up; null until it is first used.
	var/rogue_bandage_left
	/// Soaked through with blood: as a bandage it no longer helps, until it is washed.
	var/rogue_soaked = FALSE
	/// Soaked in a potion or blessed water (rogue_soak_medicines): what it heals each Ratwood tick as a bandage (Ratwood
	/// medicine_quality), and what of it is left (medicine_amount), spent soak_spend a tick.
	var/rogue_medicine_quality = 0
	var/rogue_medicine_left = 0
	/// What it was soaked in, for its look.
	var/datum/reagent/rogue_medicine
	/// The tick the medicine last healed, so that it heals once a tick whoever asks.
	var/rogue_medicine_ticked_at = -1

/// Ratwood's bandage: faster to put on, and soaks up twice as much.
/obj/item/natural/cloth/bandage
	rogue_bandage_time = 4 SECONDS
	rogue_bandage_capacity = 300

/// Vibelin cloth Initialize(): on medieval maps a cloth holds a little of what it is soaked in, which a bandage
/// lets seep into the limb it binds.
/obj/item/natural/cloth/Initialize(mapload)
	. = ..()
	if(rogue_combat_enabled() && !reagents)
		create_reagents(rogue_value("bandage_reagent_volume"), TRANSPARENT)

/obj/item/natural/cloth/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!rogue_combat_enabled())
		return ..()
	if(ishuman(interacting_with))
		INVOKE_ASYNC(src, PROC_REF(rogue_bandage), interacting_with, user)
		return ITEM_INTERACT_SUCCESS
	if(isobj(interacting_with) && rogue_can_soak_from(interacting_with, user))
		INVOKE_ASYNC(src, PROC_REF(rogue_soak_from), interacting_with, user)
		return ITEM_INTERACT_SUCCESS
	return ..()

/// A vessel used on the cloth soaks it, as the cloth used on the vessel does (Vibelin soak_cloth()).
/obj/item/natural/cloth/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!rogue_combat_enabled() || !rogue_can_soak_from(tool, user))
		return ..()
	INVOKE_ASYNC(src, PROC_REF(rogue_soak_from), tool, user)
	return ITEM_INTERACT_SUCCESS

/// Ratwood's wash_act(): washed, the cloth soaks up as much as new, and what it was soaked in is washed out.
/obj/item/natural/cloth/wash(clean_types)
	. = ..()
	rogue_soaked = FALSE
	rogue_bandage_left = rogue_bandage_capacity
	rogue_clear_medicine()
	if(reagents?.total_volume)
		reagents.clear_reagents()
		update_appearance(UPDATE_OVERLAYS)

/// Ratwood's soakings (clothfibersthorn.dm attackby()), in its order: reagent type -> list(what a cloth soaked in it heals a
/// Ratwood tick under a bandage, how long it lasts, Ratwood's word for it). A health potion heals quickly, aqua vitae slowly but
/// long, blessed water slowly and only on a bandage. Aqua vitae is Ratwood's drink (ROGUE_AQUA_VITAE_PATH): its soaking turns on
/// by itself once the reagent exists. Made anew on each use, so the numbers follow the values the admins change.
/proc/rogue_soak_medicines()
	. = list(
		/datum/reagent/medicine/healthpot = list(rogue_value("soak_lyfeblood_quality"), rogue_value("soak_lyfeblood_amount"), "lyfeblood"),
		/datum/reagent/medicine/stronghealth = list(rogue_value("soak_strong_lyfeblood_quality"), rogue_value("soak_strong_lyfeblood_amount"), "strong lyfeblood"),
	)
	var/aqua_vitae = text2path(ROGUE_AQUA_VITAE_PATH)
	if(aqua_vitae)
		.[aqua_vitae] = list(rogue_value("soak_aqua_vitae_quality"), rogue_value("soak_aqua_vitae_amount"), "aqua vitae")
	.[/datum/reagent/water/blessed] = list(rogue_value("soak_blessed_water_quality"), rogue_value("soak_blessed_water_amount"), "blessed water")

/// The reagents of Ratwood's soakings: they heal through the module's soaking and never seep in from a bandage (one cure, not
/// two).
/proc/rogue_soak_medicine_kinds()
	var/static/list/kinds
	if(!kinds)
		kinds = list(/datum/reagent/medicine/healthpot = TRUE, /datum/reagent/medicine/stronghealth = TRUE, /datum/reagent/water/blessed = TRUE)
		var/aqua_vitae = text2path(ROGUE_AQUA_VITAE_PATH)
		if(aqua_vitae)
			kinds[aqua_vitae] = TRUE
	return kinds

/// The medicine of Ratwood's soakings this vessel holds enough of, if any.
/obj/item/natural/cloth/proc/rogue_soak_medicine_in(obj/item/vessel)
	if(!vessel.reagents)
		return null
	var/units = rogue_value("soak_units")
	for(var/datum/reagent/kind as anything in rogue_soak_medicine_kinds())
		if(vessel.reagents.has_reagent(kind, units))
			return kind
	return null

/// The cloth can soak from this: a medicine of Ratwood's soakings, or any open vessel with something in it while the cloth has
/// room (Vibelin soak_cloth()).
/obj/item/natural/cloth/proc/rogue_can_soak_from(obj/vessel, mob/living/user)
	if(!vessel.reagents)
		return FALSE
	if(isitem(vessel) && rogue_soak_medicine_in(vessel))
		if(rogue_medicine_left > 0)
			to_chat(user, span_warning("[src] is already soaked."))
		return TRUE
	if(!reagents || !vessel.is_open_container() || !vessel.reagents.total_volume)
		return FALSE
	if(reagents.total_volume >= reagents.maximum_volume)
		to_chat(user, span_warning("[src] is already soaked."))
		return FALSE
	return TRUE

/// Soaks the cloth: in a medicine of Ratwood's soakings the module's way (the medicine is used up into the cloth's healing),
/// otherwise with what the vessel holds, as much as the cloth takes.
/obj/item/natural/cloth/proc/rogue_soak_from(obj/vessel, mob/living/user)
	var/datum/reagent/medicine = isitem(vessel) ? rogue_soak_medicine_in(vessel) : null
	if(medicine)
		if(rogue_medicine_left <= 0)
			rogue_soak_in(vessel, medicine, user)
		return
	if(!do_after(user, rogue_value("soak_time"), target = src) || QDELETED(vessel) || !vessel.reagents?.total_volume || !reagents)
		return
	vessel.reagents.trans_to(src, reagents.maximum_volume - reagents.total_volume, transferred_by = user)
	user.visible_message(span_small("[user] soaks \the [src] in \the [vessel]."), span_small("I soak \the [src] in \the [vessel]."), vision_distance = 2)
	update_appearance(UPDATE_OVERLAYS)

/obj/item/natural/cloth/proc/rogue_soak_in(obj/item/vessel, datum/reagent/medicine, mob/living/user)
	var/list/soakings = rogue_soak_medicines()
	var/list/data = soakings[medicine]
	if(!data)
		return
	var/units = rogue_value("soak_units")
	to_chat(user, span_notice("Soaking [src] in [data[3]]..."))
	if(!do_after(user, rogue_value("soak_time"), target = src) || rogue_medicine_left > 0 || !vessel.reagents?.has_reagent(medicine, units))
		return
	vessel.reagents.remove_reagent(medicine, units)
	rogue_medicine = medicine
	rogue_medicine_quality = data[1]
	rogue_medicine_left = data[2]
	update_appearance(UPDATE_OVERLAYS)

/// The medicine is spent or washed out.
/obj/item/natural/cloth/proc/rogue_clear_medicine()
	if(!rogue_medicine)
		return
	rogue_medicine = null
	rogue_medicine_quality = 0
	rogue_medicine_left = 0
	update_appearance(UPDATE_OVERLAYS)

/// Ratwood's process_bandage(): a clean bandage soaked in medicine mends the crits it binds and heals the limb a little each
/// tick (which mends its injuries), until the medicine is spent. Once a tick, however many ask.
/obj/item/natural/cloth/proc/rogue_medicine_tick(obj/item/bodypart/limb, ticks)
	if(!rogue_medicine_quality || rogue_soaked || rogue_medicine_ticked_at == world.time)
		return
	rogue_medicine_ticked_at = world.time
	var/amount = rogue_medicine_quality * ticks
	limb.rogue_heal_wounds(amount)
	if(limb.brute_dam || limb.burn_dam)
		limb.heal_damage(amount, amount)
	var/list/numbers = rogue_treatment_numbers()
	rogue_medicine_left -= numbers["soak_spend"] * ticks
	if(rogue_medicine_left <= 0)
		rogue_clear_medicine()

/// Vibelin heart.dm: what the cloth is soaked in seeps from the bandage into the body, each reagent by its rate of metabolism
/// a Life tick; blood does not, nor the medicines of Ratwood's soakings, which heal through the soaking instead.
/obj/item/natural/cloth/proc/rogue_seep_tick(obj/item/bodypart/limb, ticks)
	var/mob/living/carbon/body = limb.owner
	if(!reagents?.total_volume || !body?.reagents)
		return
	var/list/soakings = rogue_soak_medicine_kinds()
	for(var/datum/reagent/reagent as anything in reagents.reagent_list.Copy())
		if(istype(reagent, /datum/reagent/blood) || soakings[reagent.type])
			continue
		// metabolization_rate is units a second (TG; the alchemy's rogue_set_rates()), ticks are Vibelin's of ROGUE_LIFE_TICK.
		var/amount = round(min(reagent.volume, reagent.metabolization_rate * ticks * ROGUE_LIFE_TICK), CHEMICAL_QUANTISATION_LEVEL)
		if(amount > 0)
			// The reagent does to the limb what it does under a bandage (alchemy/potions.dm), then goes into the body, or is spent.
			if(reagent.rogue_bodypart_absorb(body, limb, amount))
				reagents.trans_to(body, amount, target_id = reagent.type, show_message = FALSE)
			else
				reagents.remove_reagent(reagent.type, amount)
	update_appearance(UPDATE_OVERLAYS)

/obj/item/natural/cloth/update_overlays()
	. = ..()
	if(!icon_exists(icon, "[icon_state]_soaked"))
		return
	var/soaked_color
	if(rogue_medicine)
		soaked_color = initial(rogue_medicine.color)
	else if(reagents?.total_volume)
		soaked_color = mix_color_from_reagents(reagents.reagent_list)
	if(!soaked_color)
		return
	var/mutable_appearance/soaked = mutable_appearance(icon, "[icon_state]_soaked")
	soaked.color = soaked_color
	. += soaked

/obj/item/natural/cloth/examine(mob/user)
	. = ..()
	if(!rogue_combat_enabled())
		return
	if(rogue_soaked)
		. += span_warning("It is soaked through with blood.")
	else if(!isnull(rogue_bandage_left) && rogue_bandage_capacity > 0 && rogue_bandage_left < rogue_bandage_capacity)
		. += span_notice("It is [round(100 * (rogue_bandage_capacity - rogue_bandage_left) / rogue_bandage_capacity)]% soaked in blood.")
	if(rogue_medicine)
		var/list/soakings = rogue_soak_medicines()
		var/list/data = soakings[rogue_medicine]
		if(data)
			. += span_notice("It has been soaked in [data[3]].")
	else if(reagents?.total_volume)
		. += span_notice("It is damp with something.")

/// Vibelin bandage(): on the limb aimed at, through what does not cover it thickly; the Medicine skill makes it 15% faster a
/// rank, and one who bandages oneself may walk meanwhile.
/obj/item/natural/cloth/proc/rogue_bandage(mob/living/carbon/human/patient, mob/living/user)
	var/obj/item/bodypart/limb = patient.get_bodypart(check_zone(user.zone_selected))
	if(!limb)
		return
	if(limb.rogue_bandage)
		to_chat(user, span_warning("There is already a bandage."))
		return
	if(!patient.try_inject(user, limb.body_zone, INJECT_TRY_SHOW_ERROR_MESSAGE))
		return
	var/time = rogue_bandage_time * max(1 - user.rogue_skill_rank(/datum/attribute/skill/misc/medicine) * rogue_value("bandage_time_per_rank"), 0)
	playsound(patient, 'modular_redtard/rockhill/sound/foley/bandage.ogg', 100, FALSE)
	if(!do_after(user, time, target = patient, timed_action_flags = patient == user ? IGNORE_USER_LOC_CHANGE : NONE))
		return
	if(QDELETED(limb) || limb.owner != patient || limb.rogue_bandage || !user.transferItemToLoc(src, limb))
		return
	limb.rogue_apply_bandage(src)
	playsound(patient, 'modular_redtard/rockhill/sound/foley/bandage.ogg', 100, FALSE)
	if(patient == user)
		user.visible_message(span_notice("[user] bandages [user.p_their()] [limb.plaintext_zone]."), span_notice("I bandage my [limb.plaintext_zone]."))
	else
		user.visible_message(span_notice("[user] bandages [patient]'s [limb.plaintext_zone]."), span_notice("I bandage [patient]'s [limb.plaintext_zone]."))

/// Vibelin bandage_expire(): the blood soaks through the bandage, which helps no more until it is washed. A full bandage, or
/// a new crit that bleeds under it (the blood element, combat/blood.dm), does it.
/obj/item/natural/cloth/proc/rogue_soak_through(obj/item/bodypart/limb)
	if(limb?.rogue_bandage == src)
		limb.rogue_bandage_expire()
		return
	rogue_mark_soaked(limb)

/// The cloth is soaked through: the blood shows on it, and the one it binds feels it.
/obj/item/natural/cloth/proc/rogue_mark_soaked(obj/item/bodypart/limb, silent = FALSE)
	if(rogue_soaked)
		return
	rogue_soaked = TRUE
	rogue_bandage_left = 0
	var/mob/living/carbon/owner = limb?.owner
	if(!owner)
		return
	add_mob_blood(owner)
	if(!silent && owner.stat != DEAD)
		owner.visible_message(span_warning("Blood soaks through the bandage on [owner]'s [limb.plaintext_zone]."), span_warning("Blood soaks through the bandage on my [limb.plaintext_zone]."), vision_distance = 3)

// ---------------------------------------------------------------------------------------------------------------------------
// The bandage on the limb.

/obj/item/bodypart
	/// The cloth binding this limb (Vibelin bodypart bandage).
	var/obj/item/natural/cloth/rogue_bandage
	/// Blood the bandage still soaks up before it soaks through (Vibelin bandage_health, kept on the limb while it binds it).
	var/rogue_bandage_health = 0
	/// The tick the bandage last soaked up the limb's blood, so that it soaks once a tick whoever asks.
	var/rogue_bandage_soaked_at = -1

/// Vibelin try_bandage(): the cloth binds the limb; its injuries are bandaged (they bleed no more and count as treated) while
/// it holds; a cloth already soaked through holds nothing.
/obj/item/bodypart/proc/rogue_apply_bandage(obj/item/natural/cloth/cloth)
	if(rogue_bandage || QDELETED(cloth))
		return FALSE
	if(cloth.loc != src)
		cloth.forceMove(src)
	rogue_bandage = cloth
	if(cloth.rogue_soaked)
		rogue_bandage_health = 0
	else
		rogue_bandage_health = isnull(cloth.rogue_bandage_left) ? cloth.rogue_bandage_capacity : cloth.rogue_bandage_left
	if(rogue_bandage_health > 0)
		rogue_flag_injuries(ROGUE_INJURY_ALL, ROGUE_INJ_BANDAGED, TRUE)
	else
		rogue_bandage_expire(silent = TRUE)
	owner?.update_damage_overlays()
	return TRUE

/// The bandage holds: it is on and not soaked through. Under it the limb's bandaged injuries and its crits bleed no more
/// (Vibelin get_bleed_rate()).
/obj/item/bodypart/proc/rogue_bandage_holds()
	return rogue_bandage && rogue_bandage_health > 0

/// Vibelin bandage_expire(): soaked through, the bandage holds no more and the injuries under it bleed again.
/obj/item/bodypart/proc/rogue_bandage_expire(silent = FALSE)
	if(!rogue_bandage)
		return
	rogue_bandage_health = 0
	rogue_flag_injuries(ROGUE_INJURY_ALL, ROGUE_INJ_BANDAGED, FALSE)
	rogue_bandage.rogue_mark_soaked(src, silent)

/// The bandage soaks up this much blood (Vibelin try_bandage_expire()); full, it soaks through.
/obj/item/bodypart/proc/rogue_bandage_soak(amount)
	if(!rogue_bandage_holds() || amount <= 0)
		return
	rogue_bandage_health = max(rogue_bandage_health - amount, 0)
	if(rogue_bandage_health <= 0)
		rogue_bandage_expire()

/// Blood a second that runs into the bandage (Vibelin get_bandaged_bleed_rate()): the bandaged injuries as they would bleed
/// unbound, the crits and TG's wounds; nothing under a tourniquet.
/obj/item/bodypart/proc/rogue_bandaged_bleed()
	. = 0
	if(rogue_tourniqueted())
		return
	for(var/datum/rogue_injury/injury as anything in rogue_injuries)
		if(injury.injury_flags & ROGUE_INJ_BANDAGED)
			. += injury.get_bleed_rate(TRUE)
	for(var/datum/wound/wound as anything in wounds)
		var/datum/wound/rogue/crit = wound
		. += istype(crit) ? crit.rogue_bleed() : wound.blood_flow

/// The treatment of the limb each Life tick of its body, called by the blood element (combat/blood.dm): the bandage soaks up
/// the blood running into it and lets what it is soaked in seep in, the module's soaked cloth heals, and a tourniquet starves
/// the limb (combat/splints.dm). Nothing to do without a bandage or a tourniquet.
/obj/item/bodypart/proc/rogue_bandage_tick(seconds_per_tick)
	var/tourniquet = rogue_tourniqueted()
	if(!rogue_bandage && !tourniquet)
		return
	if(!owner || owner.stat == DEAD)
		return
	if(tourniquet)
		rogue_tourniquet_tick(seconds_per_tick)
	if(!rogue_bandage)
		return
	var/ticks = seconds_per_tick / ROGUE_LIFE_TICK
	if(rogue_bandage_holds() && rogue_bandage_soaked_at != world.time)
		rogue_bandage_soaked_at = world.time
		rogue_bandage_soak(rogue_bandaged_bleed() * ticks)
	if(!rogue_bandage)
		return
	rogue_bandage.rogue_seep_tick(src, ticks)
	rogue_bandage.rogue_medicine_tick(src, ticks)

/// Ratwood's bandage on the body (human/update_icons.dm): "<zone>_b" of its sheet of body damage in the colour of the cloth,
/// with the bandage of the breast on a woman's chest, drawn where TG draws its gauze (over the limb, under the clothes). Limbs
/// without TG's damage overlays (a goblin's) and parts without a bandage sprite (the head, Ratwood has none) show none.
/obj/item/bodypart/get_bodypart_damage_state()
	. = ..()
	if(!rogue_bandage || !dmg_overlay_type)
		return
	var/mob/living/carbon/human/person = owner
	var/female = istype(person) && person.physique == FEMALE
	var/sheet = female ? ROGUE_BANDAGE_SHEET_FEMALE : ROGUE_BANDAGE_SHEET_MALE
	var/list/states = list("[body_zone]_b")
	if(female && body_zone == BODY_ZONE_CHEST)
		states += "boob_b"
	for(var/state in states)
		if(!icon_exists(sheet, state))
			continue
		var/mutable_appearance/bandage = mutable_appearance(sheet, state, layer = -GAUZE_LAYER)
		bandage.color = rogue_bandage.color
		if(!.)
			. = list()
		. += bandage

/// A bandage or a leech that leaves the limb (taken off, fallen off) is no longer on it; the bandage keeps what it can still
/// soak up, the injuries are no longer bandaged, and it no longer shows.
/obj/item/bodypart/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == rogue_bandage)
		var/obj/item/natural/cloth/cloth = rogue_bandage
		if(!cloth.rogue_soaked)
			cloth.rogue_bandage_left = rogue_bandage_health
		rogue_bandage = null
		rogue_bandage_health = 0
		rogue_flag_injuries(ROGUE_INJURY_ALL, ROGUE_INJ_BANDAGED, FALSE)
		owner?.update_damage_overlays()
	if(LAZYFIND(rogue_leeches, gone))
		LAZYREMOVE(rogue_leeches, gone)
		var/obj/item/natural/worms/leech/leech = gone
		leech.rogue_limb = null

/// Bandaged and splinted limbs and the leeches on them, as Vibelin's examine shows them, with a link to take each off.
/mob/living/carbon/human/examine(mob/user)
	. = ..()
	if(!rogue_combat_enabled())
		return
	for(var/obj/item/bodypart/limb as anything in bodyparts)
		var/obj/item/natural/cloth/cloth = limb.rogue_bandage
		if(cloth)
			. += span_notice("[p_Their()] [limb.plaintext_zone] is bandaged with [limb.rogue_bandage_holds() ? "\a [cloth]" : "a blood-soaked [cloth.name]"]. <a href='byond://?src=[REF(src)];rogue_unbandage=[REF(limb)]'>Remove</a>")
		var/obj/item/splint = LAZYACCESS(limb.applied_items, ROGUE_LIMB_ITEM_SPLINT)
		if(splint)
			. += span_notice("[p_Their()] [limb.plaintext_zone] is splinted with \a [splint]. <a href='byond://?src=[REF(src)];rogue_unsplint=[REF(limb)]'>Remove</a>")
		for(var/obj/item/natural/worms/leech/leech as anything in limb.rogue_leeches)
			. += span_notice("\A [leech] is latched onto [p_their()] [limb.plaintext_zone]. <a href='byond://?src=[REF(src)];rogue_unleech=[REF(leech)]'>Remove</a>")

/mob/living/carbon/human/Topic(href, href_list)
	if(href_list["rogue_unbandage"])
		var/obj/item/bodypart/limb = locate(href_list["rogue_unbandage"]) in bodyparts
		if(limb?.rogue_bandage && isliving(usr))
			INVOKE_ASYNC(src, PROC_REF(rogue_unbandage), usr, limb)
		return
	if(href_list["rogue_unsplint"])
		var/obj/item/bodypart/limb = locate(href_list["rogue_unsplint"]) in bodyparts
		if(limb?.rogue_splinted() && isliving(usr))
			INVOKE_ASYNC(src, PROC_REF(rogue_unsplint), usr, limb)
		return
	if(href_list["rogue_unleech"])
		var/obj/item/natural/worms/leech/leech = locate(href_list["rogue_unleech"])
		if(istype(leech) && leech.rogue_limb?.owner == src && isliving(usr))
			INVOKE_ASYNC(leech, TYPE_PROC_REF(/obj/item/natural/worms/leech, rogue_rip_off), usr)
		return
	return ..()

/// Ratwood's unbandaging (human_topic.dm): five seconds, 15% faster a rank of Medicine; the cloth comes into the hand.
/mob/living/carbon/human/proc/rogue_unbandage(mob/living/user, obj/item/bodypart/limb)
	var/obj/item/natural/cloth/cloth = limb.rogue_bandage
	if(!IsReachableBy(user))
		to_chat(user, span_warning("I need to be closer to remove that!"))
		return
	if(user == src)
		user.visible_message(span_warning("[user] starts unbandaging [user.p_their()] [limb.plaintext_zone]."), span_warning("I start unbandaging my [limb.plaintext_zone]..."))
	else
		user.visible_message(span_warning("[user] starts unbandaging [src]'s [limb.plaintext_zone]."), span_warning("I start unbandaging [src]'s [limb.plaintext_zone]..."))
	if(!do_after(user, rogue_value("unbandage_time") * max(1 - user.rogue_skill_rank(/datum/attribute/skill/misc/medicine) * rogue_value("bandage_time_per_rank"), 0), target = src))
		return
	if(QDELETED(cloth) || QDELETED(limb) || limb.rogue_bandage != cloth)
		return
	cloth.forceMove(drop_location())
	user.put_in_hands(cloth)

#undef ROGUE_BANDAGE_SHEET_MALE
#undef ROGUE_BANDAGE_SHEET_FEMALE
#undef ROGUE_WOUND_SERIES_SEWN
#undef ROGUE_AQUA_VITAE_PATH
#undef ROGUE_INJURY_ALL
