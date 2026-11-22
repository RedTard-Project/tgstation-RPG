/// B15: pillories, nooses and gallows (Azure Peak modular pillory.dm, gallows.dm), and people on the meathook (Ratwood
/// roguetown/meathook.dm; beasts are hung there by husbandry/butchering.dm).
///
/// Pillory. Someone dragged onto it is put in; a right click latches it over their head and hands, and a town key (the
/// dungeon's, the garrison's, the walls', the church's, the inquisition's, the manor's, or the lord's master key) locks it
/// once latched. Unlatched, one inside slips out; latched, they struggle a long while to force the latch; locked, they are
/// stuck unless strong enough to break it open. Things thrown at it hit the one inside.
///
/// Noose and gallows. Someone dragged onto it has the noose tied over their neck (at once on oneself); hanging, they choke
/// unless a chair is under their feet; a dead body hangs until its battered head comes off. Struggling free takes very long.
///
/// Meathook. A person or a body in tow is hung on it as a beast is, head down, and taken down the same way.

/obj/structure/pillory
	can_buckle = TRUE
	max_buckled_mobs = 1
	buckle_lying = 0
	buckle_prevents_pull = TRUE
	anchored = TRUE
	/// Latched shut over the head and hands of the one inside.
	var/rogue_latched = FALSE
	/// Locked with a key; it must be latched first.
	var/rogue_locked = FALSE
	/// The keys that lock it (Azure Peak /obj/structure/pillory/town).
	var/list/rogue_lockids = list("dungeon", "garrison", "walls", "church", "inquisition", "manor")
	/// Its sprite when empty; the one with someone inside is "<base>-over".
	var/rogue_base_icon

/obj/structure/pillory/Initialize(mapload)
	. = ..()
	rogue_base_icon = icon_state

/obj/structure/pillory/examine(mob/user)
	. = ..()
	. += span_notice("It is [rogue_latched ? "latched" : "unlatched"] and [rogue_locked ? "locked" : "unlocked"].")
	. += span_info("Right click it to latch it over whoever is inside; a key of the town locks it once latched.")

/obj/structure/pillory/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	if(rogue_locked)
		to_chat(user, span_warning("Unlock it first!"))
		return FALSE
	if(!ishuman(M))
		to_chat(user, span_warning("It doesn't look like [M.p_they()] can fit into this properly!"))
		return FALSE
	return ..(M, user, FALSE)

/// It stands in the way of all but the one put in: they are set on its spot first.
/obj/structure/pillory/buckle_mob(mob/living/M, force = FALSE, check_loc = TRUE, buckle_mob_flags = NONE)
	if(!anchored || rogue_locked || !ishuman(M) || !is_buckle_possible(M, force, FALSE))
		return FALSE
	if(M.loc != loc)
		M.forceMove(loc)
	return ..(M, force, FALSE, buckle_mob_flags)

/obj/structure/pillory/post_buckle_mob(mob/living/M)
	. = ..()
	icon_state = "[rogue_base_icon]-over"

/obj/structure/pillory/post_unbuckle_mob(mob/living/M)
	. = ..()
	icon_state = rogue_base_icon

/obj/structure/pillory/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || !isliving(user))
		return
	if(!has_buckled_mobs())
		to_chat(user, span_warning("What's the point of latching it with nobody inside?"))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(user in buckled_mobs)
		to_chat(user, span_warning("I can't reach the latch!"))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(rogue_locked)
		to_chat(user, span_warning("Unlock it first!"))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	user.changeNext_move(CLICK_CD_MELEE)
	rogue_latched = !rogue_latched
	user.visible_message(span_warning("[user] [rogue_latched ? "latches" : "unlatches"] [src]."), span_notice("I [rogue_latched ? "latch" : "unlatch"] [src]."))
	playsound(src, 'modular_redtard/rockhill/sound/doors/lock.ogg', 100)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/pillory/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/roguekey) && !istype(tool, /obj/item/storage/keyring))
		return ..()
	if(user in buckled_mobs)
		to_chat(user, span_warning("I can't reach the lock!"))
		return ITEM_INTERACT_BLOCKING
	if(!rogue_latched)
		to_chat(user, span_warning("It's not latched shut!"))
		return ITEM_INTERACT_BLOCKING
	for(var/lock_id in rogue_lockids)
		if(rockhill_key_fits(tool, lock_id, TRUE))
			user.changeNext_move(CLICK_CD_MELEE)
			rogue_locked = !rogue_locked
			user.visible_message(span_warning("[user] [rogue_locked ? "locks" : "unlocks"] [src]."), span_notice("I [rogue_locked ? "lock" : "unlock"] [src]."))
			playsound(src, 'modular_redtard/rockhill/sound/doors/lock.ogg', 100)
			return ITEM_INTERACT_SUCCESS
	to_chat(user, span_warning("Wrong key."))
	playsound(src, 'modular_redtard/rockhill/sound/doors/lockrattle.ogg', 100)
	return ITEM_INTERACT_BLOCKING

/// Azure Peak user_unbuckle_mob(): who is inside breaks it open if strong enough, forces an unlocked latch after a long
/// struggle, or is stuck while it is locked; who is outside needs it unlocked and unlatches it by pulling them free.
/obj/structure/pillory/user_unbuckle_mob(mob/living/buckled_mob, mob/user)
	if(!rogue_latched)
		return ..()
	if(buckled_mob == user)
		if(buckled_mob.rogue_stat(ROGUE_STAT_STRENGTH) >= rogue_value("pillory_break_strength"))
			if(!do_after(user, rogue_value("pillory_break_time"), src))
				return null
			user.visible_message(span_warning("[user] breaks [src] open!"))
			rogue_locked = FALSE
			rogue_latched = FALSE
			return ..()
		if(rogue_locked)
			to_chat(user, span_warning("It's locked! I can't free myself!"))
			return null
		user.visible_message(span_warning("[user] struggles in [src], trying to get the latch off!"))
		if(!do_after(user, rogue_value("pillory_unlatch_time"), src))
			return null
		user.visible_message(span_warning("[user] forces [src]'s latch open!"))
		rogue_latched = FALSE
		return ..()
	if(rogue_locked)
		to_chat(user, span_warning("[src] is locked! I'll need a key to unlatch it."))
		return null
	rogue_latched = FALSE
	return ..()

/obj/structure/pillory/hitby(atom/movable/hitting_atom, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	if(!has_buckled_mobs())
		return ..()
	var/mob/living/victim = pick(buckled_mobs)
	return hitting_atom.throw_impact(victim, throwingdatum)

// --- Noose and gallows ---

/obj/structure/noose
	can_buckle = TRUE
	max_buckled_mobs = 1
	buckle_lying = 0
	buckle_prevents_pull = TRUE
	anchored = TRUE

/obj/structure/noose/Destroy()
	STOP_PROCESSING(SSobj, src)
	for(var/mob/living/hung as anything in buckled_mobs)
		hung.visible_message(span_danger("[hung] falls over and hits the ground!"), span_userdanger("I fall over and hit the ground!"))
		hung.adjust_brute_loss(rogue_value("noose_fall_damage"))
		hung.Knockdown(rogue_value("noose_fall_knockdown"))
	return ..()

/obj/structure/noose/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	if(!iscarbon(M) || !isliving(user) || !user.Adjacent(src) || user.incapacitated)
		return FALSE
	if(!M.get_bodypart(BODY_ZONE_HEAD))
		to_chat(user, span_warning("[M] has no head!"))
		return FALSE
	M.visible_message(span_danger("[user] attempts to tie [src] over [M]'s neck!"))
	if((user != M && !do_after(user, rogue_value("noose_tie_time"), M)) || !buckle_mob(M, check_loc = FALSE))
		user.visible_message(span_warning("[user] fails to tie [src] over [M]'s neck!"), span_warning("I fail to tie [src] over [M]'s neck!"))
		return FALSE
	user.visible_message(span_warning("[user] ties [src] over [M]'s neck!"))
	if(user == M)
		to_chat(M, span_userdanger("I tie [src] over my neck!"))
	else
		to_chat(M, span_userdanger("[user] ties [src] over my neck!"))
	playsound(src, 'modular_redtard/combat/sound/bindings/noosed.ogg', 50, TRUE, -1)
	return TRUE

/obj/structure/noose/post_buckle_mob(mob/living/M)
	. = ..()
	START_PROCESSING(SSobj, src)
	M.add_offsets("rogue_noose", y_add = 10)

/obj/structure/noose/post_unbuckle_mob(mob/living/M)
	. = ..()
	if(!has_buckled_mobs())
		STOP_PROCESSING(SSobj, src)
	M.remove_offsets("rogue_noose")

/// Azure Peak: struggling out of the noose takes very long, less for the strong.
/obj/structure/noose/user_unbuckle_mob(mob/living/buckled_mob, mob/user)
	if(buckled_mob != user)
		return ..()
	var/strong = buckled_mob.rogue_stat(ROGUE_STAT_STRENGTH) > rogue_value("noose_strong_strength")
	user.visible_message(span_warning("[user] struggles against [src]!"), span_notice("I struggle to free myself from [src]..."))
	if(!do_after(user, rogue_value(strong ? "noose_struggle_time_strong" : "noose_struggle_time"), src))
		return null
	return ..()

/obj/structure/noose/process(seconds_per_tick)
	if(!has_buckled_mobs())
		return PROCESS_KILL
	for(var/mob/living/hung as anything in buckled_mobs)
		var/obj/item/bodypart/head = hung.get_bodypart(BODY_ZONE_HEAD)
		if(!head)
			hung.visible_message(span_danger("[hung] drops from [src]!"))
			unbuckle_mob(hung, force = TRUE)
			hung.Knockdown(rogue_value("noose_drop_knockdown"))
			continue
		if(hung.stat == DEAD)
			if(prob(rogue_value("noose_behead_chance")) && head.brute_dam >= rogue_value("noose_behead_damage"))
				head.dismember()
			continue
		// A chair under the feet: kick it away and they hang.
		if(locate(/obj/structure/chair) in loc)
			continue
		if(!HAS_TRAIT(hung, TRAIT_NOBREATH))
			hung.adjust_oxy_loss(rogue_value("noose_choke_damage"))
			if(prob(rogue_value("noose_gasp_chance")))
				hung.emote("gasp")
		playsound(hung, 'modular_redtard/rockhill/sound/foley/noose_idle.ogg', 30, TRUE, -3)

// --- Meathook: people and bodies ---

/// Ratwood attack_hand(): a person or a body in tow is hung on the hook as a beast is (husbandry/butchering.dm rogue_hang()).
/obj/structure/meathook/attack_hand(mob/user, list/modifiers)
	if(!isliving(user) || has_buckled_mobs() || !ishuman(user.pulling) || !rogue_combat_enabled())
		return ..()
	INVOKE_ASYNC(src, PROC_REF(rogue_hang), user, user.pulling)
	return TRUE

/obj/structure/meathook/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/hand_item/rogue_grab) || has_buckled_mobs() || !ishuman(user.pulling) || !rogue_combat_enabled())
		return ..()
	INVOKE_ASYNC(src, PROC_REF(rogue_hang), user, user.pulling)
	return ITEM_INTERACT_SUCCESS

/// Ratwood: a person hangs head down (turned half round, a beast a quarter) and screams.
/obj/structure/meathook/post_buckle_mob(mob/living/hung)
	. = ..()
	if(!ishuman(hung))
		return
	var/matrix/head_down = matrix(hung.transform)
	head_down.Turn(90)
	animate(hung, transform = head_down, time = 0.3 SECONDS)
	if(hung.stat != DEAD)
		INVOKE_ASYNC(hung, TYPE_PROC_REF(/mob, emote), "scream")

/obj/structure/meathook/post_unbuckle_mob(mob/living/hung)
	. = ..()
	if(!ishuman(hung))
		return
	var/matrix/upright = matrix(hung.transform)
	upright.Turn(-90)
	animate(hung, transform = upright, time = 0.3 SECONDS)
	if(hung.stat != DEAD)
		INVOKE_ASYNC(hung, TYPE_PROC_REF(/mob, emote), "scream")
