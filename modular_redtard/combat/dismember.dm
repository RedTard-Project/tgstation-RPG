GLOBAL_LIST_INIT(rogue_dismember_sounds, list('modular_redtard/rockhill/sound/combat/dismemberment/dismem (1).ogg', 'modular_redtard/rockhill/sound/combat/dismemberment/dismem (2).ogg', 'modular_redtard/rockhill/sound/combat/dismemberment/dismem (3).ogg', 'modular_redtard/rockhill/sound/combat/dismemberment/dismem (5).ogg', 'modular_redtard/rockhill/sound/combat/dismemberment/dismem (6).ogg'))
GLOBAL_LIST_INIT(rogue_extremity_zones, list("l_hand", "r_hand", "l_foot", "r_foot"))
GLOBAL_LIST_INIT(rogue_disembowel_slots, list(ORGAN_SLOT_STOMACH, ORGAN_SLOT_APPENDIX))

/obj/item/proc/rogue_dismember_chance(obj/item/bodypart/limb, mob/living/attacker, datum/intent/intent, damage, zone)
	if(!intent?.get_sharpness() || !limb.can_dismember(src))
		return 0
	var/force = damage
	var/pristine = TRUE
	if(max_blade_int)
		var/edge = blade_int / initial(max_blade_int)
		if(edge <= ROGUE_DISMEMBER_DULL_SHARE)
			return 0
		force *= edge
		pristine = edge >= ROGUE_DISMEMBER_PRISTINE_SHARE
	if(attacker?.rogue_rmb_is(/datum/rogue_rmb_intent/weak))
		return 0
	if(attacker?.rogue_rmb_is(/datum/rogue_rmb_intent/strong))
		force *= ROGUE_DISMEMBER_STRONG_FACTOR
	switch(intent.blade_class)
		if(BCLASS_CHOP)
			force *= ROGUE_DISMEMBER_CHOP_FACTOR
		if(BCLASS_CUT)
			if(!pristine && limb.get_damage() < limb.max_damage * ROGUE_DISMEMBER_DULL_CUT_SHARE)
				return 0
		else
			return 0
	return limb.rogue_sever_chance(force, zone)

/obj/item/bodypart/proc/rogue_sever_chance(force, zone)
	if(force < ROGUE_DISMEMBER_MIN_FORCE)
		return 0
	var/share = get_damage() / max_damage
	var/chance = force * share
	var/easy = owner && HAS_TRAIT(owner, TRAIT_EASYDISMEMBER)
	if(share <= ROGUE_DISMEMBER_DAMAGE_SHARE && !easy)
		return 0
	if(owner && HAS_TRAIT(owner, TRAIT_EASYDECAPITATION) && zone == "neck")
		return chance * ROGUE_DISMEMBER_EASY_FACTOR
	if(owner && HAS_TRAIT(owner, TRAIT_HARDDISMEMBER))
		return min(chance, ROGUE_DISMEMBER_HARD_CAP)
	return easy ? chance * ROGUE_DISMEMBER_EASY_FACTOR : chance

/mob/living/proc/rogue_try_dismember(obj/item/weapon, datum/intent/intent, mob/living/attacker, zone, damage)
	return FALSE

/mob/living/carbon/rogue_try_dismember(obj/item/weapon, datum/intent/intent, mob/living/attacker, zone, damage)
	if(!weapon || HAS_TRAIT(src, TRAIT_GODMODE) || HAS_TRAIT(src, TRAIT_NODISMEMBER))
		return FALSE
	var/obj/item/bodypart/limb = get_bodypart(rogue_zone_target(zone))
	if(!limb || !prob(weapon.rogue_dismember_chance(limb, attacker, intent, damage, zone)))
		return FALSE
	return rogue_dismember(limb, weapon, attacker, zone)

/// Severs a limb (the chest is disembowelled). What it did goes on the line of the strike that did it, as a note
/// (combat/chat.dm), or on a line of its own outside a strike.
/mob/living/carbon/proc/rogue_dismember(obj/item/bodypart/limb, obj/item/weapon, mob/living/attacker, zone)
	if(limb.body_zone == BODY_ZONE_CHEST)
		return rogue_disembowel(attacker)
	var/head = limb.body_zone == BODY_ZONE_HEAD
	if(head)
		if(zone != "neck")
			return FALSE
		if(!HAS_TRAIT(src, TRAIT_CRITICAL_WEAKNESS) && !HAS_TRAIT(src, TRAIT_EASYDISMEMBER) && body_position != LYING_DOWN && !buckled)
			return FALSE
	else
		if(mind && (zone in GLOB.rogue_extremity_zones))
			return FALSE
		if(ishuman(src))
			var/mob/living/carbon/human/armored = src
			if(armored.rogue_armor_tier(limb.body_zone, ROGUE_ARMOR_SLASH) > 0)
				to_chat(src, span_warning("My armour just saved me from losing my [limb.plaintext_zone]!"))
				return FALSE
	if(rogue_resist_crit())
		rogue_strike_note(span_danger("Critical resistance! [src]'s [limb.plaintext_zone] hangs on by a thread!"))
		return FALSE
	// Written before the cut: a headless body is no longer known by its face.
	var/severed_text = head ? "<B>\The [src] is [pick("BRUTALLY", "VIOLENTLY", "BLOODILY", "MESSILY")] DECAPITATED!</B>" : "<B>The [limb.plaintext_zone] is [pick("torn off", "sundered", "severed", "separated", "unsewn")]!</B>"
	if(!limb.dismember(BRUTE, TRUE, WOUND_SLASH))
		return FALSE
	playsound(src, pick(GLOB.rogue_dismember_sounds), 80, TRUE)
	rogue_strike_note(span_danger(severed_text))
	weapon?.add_mob_blood(src)
	rogue_add_stump()
	if(!head && ishuman(src))
		INVOKE_ASYNC(src, TYPE_PROC_REF(/mob/living/carbon/human, rogue_delimb_pain))
	log_combat(attacker, src, "dismembered", weapon, "(ZONE: [zone])")
	return TRUE

/// Ratwood leaves a stump wound on the chest for each severed limb (/datum/wound/dismemberment): it bleeds and hurts until
/// it is seared shut. Several stumps are one wound that bleeds and hurts for each.
/mob/living/carbon/proc/rogue_add_stump()
	var/obj/item/bodypart/chest/chest = get_bodypart(BODY_ZONE_CHEST)
	if(!chest || !(chest.biological_state & BIO_FLESH))
		return
	var/datum/wound/rogue_stump/stump = locate() in chest.wounds
	if(!stump)
		stump = new
		if(!stump.apply_wound(chest, silent = TRUE, wound_source = "dismemberment"))
			return
	stump.add_stump()

/datum/wound_pregen_data/rogue_stump
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue_stump
	can_be_randomly_generated = FALSE
	required_limb_biostate = BIO_FLESH
	required_wounding_type = WOUND_ALL
	wound_series = ROGUE_WOUND_SERIES_STUMP
	viable_zones = list(BODY_ZONE_CHEST)

/// The stumps of severed limbs (Ratwood /datum/wound/dismemberment): they bleed without clotting and hurt; something hot
/// sears them shut, a little each time (Ratwood cauterize_wound() heals its whp), and a grasp or a miracle stems them.
/datum/wound/rogue_stump
	name = "Bleeding Stump"
	undiagnosed_name = "Stump"
	desc = "The stump of a severed limb bleeds freely and will not clot."
	treat_text = "Sear the stump shut with something hot."
	treat_text_short = "Sear it with heat"
	examine_desc = "bleeds from a severed stump"
	occur_text = "is left a bleeding stump"
	severity = WOUND_SEVERITY_CRITICAL
	can_scar = FALSE
	already_scarred = TRUE
	wound_flags = CAN_BE_GRASPED
	treatable_tools = list(TOOL_CAUTERY)
	scar_keyword = "dismember"
	/// Limbs severed from this chest.
	var/stumps = 0
	/// Stumps a needle has sewn (combat/medicine.dm): they bleed and hurt little.
	var/sewn = 0
	/// What searing still has to close (Ratwood whp, for each stump).
	var/integrity = 0

/datum/wound/rogue_stump/proc/add_stump()
	stumps++
	integrity += ROGUE_STUMP_INTEGRITY
	adjust_blood_flow(ROGUE_STUMP_BLEED)

/datum/wound/rogue_stump/adjust_blood_flow(adjust_by, minimum = 0)
	. = ..()
	if(blood_flow <= 0 && !QDELETED(src))
		to_chat(victim, span_green("My [stumps > 1 ? "stumps stop" : "stump stops"] bleeding."))
		qdel(src)

/datum/wound/rogue_stump/get_wound_description(mob/user)
	if(sewn >= stumps)
		return span_warning("[victim.p_Their()] [stumps > 1 ? "stumps are" : "stump is"] sewn shut.")
	return span_bolddanger("[victim.p_Their()] [stumps > 1 ? "stumps bleed" : "stump bleeds"] freely!")

/datum/wound/rogue_stump/get_self_check_description(self_aware)
	if(sewn >= stumps)
		return span_warning("It has [stumps > 1 ? "the sewn stumps of severed limbs" : "the sewn stump of a severed limb"].")
	return span_boldwarning("It's bleeding from [stumps > 1 ? "the stumps of severed limbs" : "the stump of a severed limb"]!!")

/datum/wound/rogue_stump/check_grab_treatments(obj/item/tool, mob/user)
	return tool.get_temperature() >= FIRE_MINIMUM_TEMPERATURE_TO_EXIST

/datum/wound/rogue_stump/treat(obj/item/tool, mob/user)
	var/self = user == victim
	var/whose = self ? "[victim.p_their()]" : "[victim]'s"
	user.visible_message(span_danger("[user] begins searing [whose] stump with [tool]..."), span_warning("I begin searing [self ? "my" : "[victim]'s"] stump with [tool]..."))
	if(!do_after(user, ROGUE_STUMP_CAUTERY_TIME * (self ? ROGUE_STUMP_CAUTERY_SELF : 1), target = victim, extra_checks = CALLBACK(src, PROC_REF(still_exists))))
		return
	playsound(victim, 'sound/items/handling/surgery/cautery2.ogg', 75, TRUE)
	victim.apply_damage(ROGUE_STUMP_CAUTERY_BURN, BURN, limb, wound_bonus = CANT_WOUND)
	INVOKE_ASYNC(victim, TYPE_PROC_REF(/mob, emote), "painscream")
	integrity -= ROGUE_STUMP_CAUTERY
	if(integrity > 0)
		user.visible_message(span_warning("[user] sears [whose] stump, but it still bleeds."), span_warning("I sear the stump, but it still bleeds."))
		return
	user.visible_message(span_green("[user] sears [whose] stump shut."), span_green("I sear the stump shut."))
	qdel(src)

/mob/living/carbon/proc/rogue_disembowel(mob/living/attacker)
	var/obj/item/bodypart/chest/chest = get_bodypart(BODY_ZONE_CHEST)
	if(!chest || HAS_TRAIT(src, TRAIT_GODMODE) || HAS_TRAIT(src, TRAIT_NODISMEMBER))
		return FALSE
	var/turf/spill = drop_location()
	for(var/obj/item/organ/organ as anything in organs)
		if(organ.slot in GLOB.rogue_disembowel_slots)
			organ.Remove(src)
			organ.forceMove(spill)
	if(chest.cavity_item)
		chest.cavity_item.forceMove(spill)
		chest.cavity_item = null
	// Ratwood's disembowelment is a critical wound: "Critical hit!", then the wound it leaves.
	rogue_strike_note(rogue_crit_text("[src] spills [p_their()] [pick("organs", "entrails")]!"))
	cause_wound_of_type_and_severity(WOUND_SLASH, chest, WOUND_SEVERITY_CRITICAL, WOUND_SEVERITY_CRITICAL, wound_source = "disembowelment")
	if(isturf(spill) && can_bleed())
		add_splatter_floor(spill)
	playsound(src, 'modular_redtard/rockhill/sound/combat/crit2.ogg', 100, TRUE)
	INVOKE_ASYNC(src, TYPE_PROC_REF(/mob, emote), "scream")
	rogue_slowdown(ROGUE_DISEMBOWEL_SLOW)
	shake_camera(src, 2, 2)
	log_combat(attacker, src, "disembowelled")
	return TRUE
