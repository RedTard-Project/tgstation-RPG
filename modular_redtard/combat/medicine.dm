/// Ratwood's field medicine on medieval maps: a needle sews wounds stitch by stitch (rogueitems/needle.dm sew(), with the
/// Medicine skill), cloth and bandages bind a limb (natural/clothfibersthorn.dm bandage(), bodypart_wounds.dm
/// get_bleed_rate(), process_bandage()). The stitches and the bandage act on the bleeding as Ratwood counts it
/// (combat/blood.dm rogue_bleed_rate()).

/datum/wound
	/// Ratwood sew_progress: how far the stitches have got.
	var/rogue_sew_progress = 0
	/// Blood per second the stitches already hold back (Ratwood lowers bleed_rate with every stitch).
	var/rogue_stitched = 0

/// How far the stitches must get to sew this wound (Ratwood sew_threshold); 0 when a needle cannot sew it.
/datum/wound/proc/rogue_sew_threshold()
	return 0

/datum/wound/slash/flesh/rogue_sew_threshold()
	return rogue_cut_sew_threshold()

/datum/wound/pierce/bleed/rogue_sew_threshold()
	return rogue_cut_sew_threshold()

/// A cut or a stab: a small one sews quickly, an opened artery takes long (Ratwood slash 25 and 50, artery 100).
/datum/wound/proc/rogue_cut_sew_threshold()
	if(severity >= WOUND_SEVERITY_CRITICAL)
		return ROGUE_SEW_THRESHOLD_ARTERY
	return severity >= WOUND_SEVERITY_SEVERE ? ROGUE_SEW_THRESHOLD_SEVERE : ROGUE_SEW_THRESHOLD_MODERATE

/// The wound is sewn shut: a cut or a stab of TG closes (and scars, as TG's do).
/datum/wound/proc/rogue_sew_done()
	qdel(src)

/// Blood per second this wound still loses, stitches counted.
/datum/wound/proc/rogue_bleeding_left()
	return blood_flow + rogue_bleed_delta()

/datum/wound/rogue_stump/rogue_sew_threshold()
	return sewn < stumps ? ROGUE_SEW_THRESHOLD_STUMP : 0

/// A sewn stump bleeds and hurts little (Ratwood sewn_bleed_rate 0.25, sewn_woundpain 20); searing still closes it.
/datum/wound/rogue_stump/rogue_sew_done()
	sewn++
	rogue_sew_progress = 0
	rogue_stitched = 0
	adjust_blood_flow(ROGUE_STUMP_SEWN_BLEED - ROGUE_STUMP_BLEED)

/// The wounds of this limb a needle can sew.
/obj/item/bodypart/proc/rogue_sewable_wounds()
	. = list()
	for(var/datum/wound/wound as anything in wounds)
		if(wound.rogue_sew_threshold())
			. += wound

/// Ratwood's sew(): every two seconds a stitch, which holds back half the doctor's Medicine of blood (at least 1, per
/// Life tick) and gets the stitches (Medicine + 1) * 5 further; when they reach the wound's threshold it is sewn and the
/// needle spends a thread. The doctor learns a little with each stitch and more on finishing, by intelligence.
/obj/item/needle/proc/rogue_sew(mob/living/carbon/patient, mob/living/user)
	var/obj/item/bodypart/limb = patient.get_bodypart(check_zone(user.zone_selected))
	if(!limb)
		to_chat(user, span_warning("That limb is missing."))
		return
	var/list/sewable = limb.rogue_sewable_wounds()
	if(!length(sewable))
		to_chat(user, span_warning("There aren't any wounds to be sewn."))
		return
	var/datum/wound/target = sewable[1]
	if(length(sewable) > 1)
		var/list/choices = list()
		for(var/datum/wound/wound as anything in sewable)
			choices[avoid_assoc_duplicate_keys(capitalize(wound.name), choices)] = wound
		target = choices[tgui_input_list(user, "Which wound?", "[src]", choices)]
		if(!target)
			return
	var/rank = user.rogue_skill_rank(/datum/attribute/skill/misc/medicine)
	var/step = (rank + 1) * ROGUE_SEW_STEP_PER_RANK
	var/hold = max(rank * ROGUE_SEW_HOLD_PER_RANK, ROGUE_SEW_HOLD_MIN) / ROGUE_LIFE_TICK
	var/informed = FALSE
	while(!QDELETED(target) && target.limb == limb && !QDELETED(src) && user.is_holding(src))
		if(!infinite && stringamt < 1)
			to_chat(user, span_warning("The needle has no thread left!"))
			return
		var/threshold = target.rogue_sew_threshold()
		if(!threshold)
			return
		if(!do_after(user, ROGUE_SEW_STITCH_TIME, target = patient))
			return
		if(QDELETED(target) || target.limb != limb)
			return
		user.rogue_craft_experience(/datum/attribute/skill/misc/medicine, user.rogue_stat(ROGUE_STAT_INTELLIGENCE) * ROGUE_SEW_XP_STEP)
		playsound(patient, 'modular_redtard/rockhill/sound/foley/sewflesh.ogg', 100, TRUE, -2)
		target.rogue_sew_progress = min(target.rogue_sew_progress + step, threshold)
		target.rogue_stitched += hold
		if(!informed && target.rogue_bleeding_left() <= 0)
			informed = TRUE
			patient.visible_message(span_green("One last drop of blood trickles from the [target.name] on [patient]'s [limb.plaintext_zone] before it closes."), span_green("The throbbing warmth coming out of the [target.name] soothes and stops. It no longer bleeds."))
		if(target.rogue_sew_progress < threshold)
			continue
		user.rogue_craft_experience(/datum/attribute/skill/misc/medicine, user.rogue_stat(ROGUE_STAT_INTELLIGENCE) * ROGUE_SEW_XP_FINISH * threshold / ROGUE_SEW_XP_NORMALIZER)
		if(!infinite)
			stringamt--
			update_appearance(UPDATE_OVERLAYS)
		if(patient == user)
			user.visible_message(span_notice("[user] sews \a [target.name] on [user.p_them()]self."), span_notice("I stitch \a [target.name] on my [limb.plaintext_zone]."))
		else
			user.visible_message(span_notice("[user] sews \a [target.name] on [patient]'s [limb.plaintext_zone]."), span_notice("I stitch \a [target.name] on [patient]'s [limb.plaintext_zone]."))
		log_combat(user, patient, "sewed", src)
		target.rogue_sew_done()
		return

/obj/item/natural/cloth
	/// Share of a limb's bleeding left under this cloth as a bandage (Ratwood bandage_effectiveness).
	var/rogue_bandage_effectiveness = 0.5
	/// Deciseconds bandaging with it takes, before the Medicine skill shortens it (Ratwood bandage_speed).
	var/rogue_bandage_time = 7 SECONDS
	/// Blood it soaks up before it is soaked through (Ratwood bandage_health).
	var/rogue_bandage_capacity = 150
	/// What it can still soak up; null until it is first used.
	var/rogue_bandage_left
	/// Soaked through with blood: as a bandage it no longer helps, until it is washed.
	var/rogue_soaked = FALSE

/// Ratwood's bandage: faster to put on, and soaks up twice as much.
/obj/item/natural/cloth/bandage
	rogue_bandage_time = 4 SECONDS
	rogue_bandage_capacity = 300

/obj/item/natural/cloth/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!ishuman(interacting_with) || !rogue_combat_enabled())
		return ..()
	INVOKE_ASYNC(src, PROC_REF(rogue_bandage), interacting_with, user)
	return ITEM_INTERACT_SUCCESS

/// Ratwood's wash_act(): washed, the cloth soaks up as much as new.
/obj/item/natural/cloth/wash(clean_types)
	. = ..()
	rogue_soaked = FALSE
	rogue_bandage_left = rogue_bandage_capacity

/// Ratwood's bandage(): on the limb aimed at, through what does not cover it thickly; the Medicine skill makes it 15% faster
/// a rank, and one who bandages oneself may walk meanwhile.
/obj/item/natural/cloth/proc/rogue_bandage(mob/living/carbon/human/patient, mob/living/user)
	var/obj/item/bodypart/limb = patient.get_bodypart(check_zone(user.zone_selected))
	if(!limb)
		return
	if(limb.rogue_bandage)
		to_chat(user, span_warning("There is already a bandage."))
		return
	if(!patient.try_inject(user, limb.body_zone, INJECT_TRY_SHOW_ERROR_MESSAGE))
		return
	var/time = rogue_bandage_time * max(1 - user.rogue_skill_rank(/datum/attribute/skill/misc/medicine) * ROGUE_BANDAGE_TIME_PER_RANK, 0)
	playsound(patient, 'modular_redtard/rockhill/sound/foley/bandage.ogg', 100, FALSE)
	if(!do_after(user, time, target = patient, timed_action_flags = patient == user ? IGNORE_USER_LOC_CHANGE : NONE))
		return
	if(QDELETED(limb) || limb.owner != patient || limb.rogue_bandage || !user.transferItemToLoc(src, limb))
		return
	limb.rogue_bandage = src
	playsound(patient, 'modular_redtard/rockhill/sound/foley/bandage.ogg', 100, FALSE)
	if(patient == user)
		user.visible_message(span_notice("[user] bandages [user.p_their()] [limb.plaintext_zone]."), span_notice("I bandage my [limb.plaintext_zone]."))
	else
		user.visible_message(span_notice("[user] bandages [patient]'s [limb.plaintext_zone]."), span_notice("I bandage [patient]'s [limb.plaintext_zone]."))

/// The cloth soaks up blood; when it can take no more, the blood soaks through (Ratwood bandage_expire()).
/obj/item/natural/cloth/proc/rogue_soak(amount, obj/item/bodypart/limb)
	if(isnull(rogue_bandage_left))
		rogue_bandage_left = rogue_bandage_capacity
	rogue_bandage_left -= amount
	if(rogue_bandage_left > 0 || rogue_soaked)
		return
	rogue_soaked = TRUE
	var/mob/living/carbon/owner = limb.owner
	if(!owner)
		return
	add_mob_blood(owner)
	if(owner.stat != DEAD)
		owner.visible_message(span_warning("Blood soaks through the bandage on [owner]'s [limb.plaintext_zone]."), span_warning("Blood soaks through the bandage on my [limb.plaintext_zone]."), vision_distance = 3)

/obj/item/bodypart
	/// The cloth binding this limb (Ratwood bodypart bandage).
	var/obj/item/natural/cloth/rogue_bandage

/// Ratwood's get_bleed_rate() under a bandage: the bleeding soaks into a clean bandage, which holds back its share, and
/// what little is left (no more than 1 a Life tick) stops. A soaked bandage helps no more.
/obj/item/bodypart/proc/rogue_bandaged_rate(rate, ticks)
	if(rogue_bandage.rogue_soaked)
		return rate
	if(ticks)
		rogue_bandage.rogue_soak(rate * ROGUE_LIFE_TICK * ticks, src)
	rate *= rogue_bandage.rogue_bandage_effectiveness
	return rate * ROGUE_LIFE_TICK <= ROGUE_BANDAGE_STOP ? 0 : rate

/obj/item/bodypart/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == rogue_bandage)
		rogue_bandage = null

/// Bandaged limbs, as Ratwood's examine shows them, with a link to take the bandage off.
/mob/living/carbon/human/examine(mob/user)
	. = ..()
	if(!rogue_combat_enabled())
		return
	for(var/obj/item/bodypart/limb as anything in bodyparts)
		var/obj/item/natural/cloth/cloth = limb.rogue_bandage
		if(cloth)
			. += span_notice("[p_Their()] [limb.plaintext_zone] is bandaged with [cloth.rogue_soaked ? "a blood-soaked [cloth.name]" : "\a [cloth]"]. <a href='byond://?src=[REF(src)];rogue_unbandage=[REF(limb)]'>Remove</a>")

/mob/living/carbon/human/Topic(href, href_list)
	if(href_list["rogue_unbandage"])
		var/obj/item/bodypart/limb = locate(href_list["rogue_unbandage"]) in bodyparts
		if(limb?.rogue_bandage && isliving(usr))
			INVOKE_ASYNC(src, PROC_REF(rogue_unbandage), usr, limb)
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
	if(!do_after(user, ROGUE_UNBANDAGE_TIME * max(1 - user.rogue_skill_rank(/datum/attribute/skill/misc/medicine) * ROGUE_BANDAGE_TIME_PER_RANK, 0), target = src))
		return
	if(QDELETED(cloth) || QDELETED(limb) || limb.rogue_bandage != cloth)
		return
	cloth.forceMove(drop_location())
	user.put_in_hands(cloth)
