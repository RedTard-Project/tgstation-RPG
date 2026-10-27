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
		visible_message(span_danger("Critical resistance! [src]'s [limb.plaintext_zone] hangs on by a thread!"))
		return FALSE
	var/limb_name = limb.plaintext_zone
	if(!limb.dismember(BRUTE, TRUE, WOUND_SLASH))
		return FALSE
	playsound(src, pick(GLOB.rogue_dismember_sounds), 80, TRUE)
	if(head)
		visible_message(span_danger("<B>[src] is [pick("BRUTALLY", "VIOLENTLY", "BLOODILY", "MESSILY")] DECAPITATED!</B>"))
	else
		visible_message(span_danger("<B>The [limb_name] is [pick("torn off", "sundered", "severed", "separated", "unsewn")]!</B>"))
	weapon?.add_mob_blood(src)
	log_combat(attacker, src, "dismembered", weapon, "(ZONE: [zone])")
	return TRUE

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
	cause_wound_of_type_and_severity(WOUND_SLASH, chest, WOUND_SEVERITY_CRITICAL, WOUND_SEVERITY_CRITICAL, wound_source = "disembowelment")
	if(isturf(spill) && can_bleed())
		add_splatter_floor(spill)
	playsound(src, 'modular_redtard/rockhill/sound/combat/crit2.ogg', 100, TRUE)
	visible_message(span_userdanger("[src] spills [p_their()] [pick("organs", "entrails")]!"))
	INVOKE_ASYNC(src, TYPE_PROC_REF(/mob, emote), "scream")
	rogue_slowdown(ROGUE_DISEMBOWEL_SLOW)
	shake_camera(src, 2, 2)
	log_combat(attacker, src, "disembowelled")
	return TRUE
