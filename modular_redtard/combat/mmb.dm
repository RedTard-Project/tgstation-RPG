/mob/living/carbon/human/var/rogue_mmb_intent = ROGUE_MMB_NONE
/mob/living/carbon/human/var/rogue_offbalance_until = 0

/mob/living/carbon/human/proc/rogue_select_mmb(intent)
	rogue_mmb_intent = rogue_mmb_intent == intent ? ROGUE_MMB_NONE : intent
	playsound_local(src, 'sound/machines/click.ogg', 50, FALSE)
	SEND_SIGNAL(src, COMSIG_MOB_ROGUE_MMB_CHANGED)

/mob/living/carbon/human/proc/rogue_offbalanced(do_message = TRUE)
	if(world.time >= rogue_offbalance_until)
		return FALSE
	if(do_message)
		to_chat(src, span_warning("I haven't regained my balance yet."))
	return TRUE

/mob/living/carbon/human/proc/rogue_off_balance(duration)
	rogue_offbalance_until = max(rogue_offbalance_until, world.time + duration)

/datum/element/rogue_mmb
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

/datum/element/rogue_mmb/Attach(datum/target)
	. = ..()
	if(!ishuman(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_MOB_MIDDLECLICKON, PROC_REF(on_middle_click))

/datum/element/rogue_mmb/Detach(datum/source)
	UnregisterSignal(source, COMSIG_MOB_MIDDLECLICKON)
	return ..()

/datum/element/rogue_mmb/proc/on_middle_click(mob/living/carbon/human/source, atom/target, params)
	SIGNAL_HANDLER
	if(source.rogue_mmb_intent == ROGUE_MMB_NONE || source.incapacitated || !source.client || world.time < source.next_move)
		return NONE
	switch(source.rogue_mmb_intent)
		if(ROGUE_MMB_KICK)
			INVOKE_ASYNC(source, TYPE_PROC_REF(/mob/living/carbon/human, rogue_try_kick), target)
		if(ROGUE_MMB_JUMP)
			INVOKE_ASYNC(source, TYPE_PROC_REF(/mob/living/carbon/human, rogue_try_jump), target)
		if(ROGUE_MMB_BITE)
			INVOKE_ASYNC(source, TYPE_PROC_REF(/mob/living/carbon/human, rogue_try_bite), target)
		if(ROGUE_MMB_STEAL)
			INVOKE_ASYNC(source, TYPE_PROC_REF(/mob/living/carbon/human, rogue_try_steal), target)
	return COMSIG_MOB_CANCEL_CLICKON

/mob/living/carbon/human/proc/rogue_try_kick(atom/target)
	if(num_legs < ROGUE_KICK_LEGS || target == src || !target.Adjacent(src) || rogue_offbalanced())
		return FALSE
	changeNext_move(CLICK_CD_MELEE)
	face_atom(target)
	rogue_mark_in_combat()
	playsound(src, 'sound/items/weapons/punchmiss.ogg', 100, FALSE, -1)
	do_attack_animation(target, ATTACK_EFFECT_KICK)
	rogue_off_balance(ROGUE_KICK_OFFBALANCE)
	if(!isliving(target))
		target.rogue_onkick(src)
		return TRUE
	var/mob/living/victim = target
	sleep(ROGUE_KICK_SWING)
	if(QDELETED(src) || QDELETED(victim) || !victim.Adjacent(src) || incapacitated)
		return FALSE
	if(victim.check_block(src, ROGUE_KICK_DAMAGE, "the kick", UNARMED_ATTACK, 0, BRUTE))
		return FALSE
	var/strength = rogue_stat(ROGUE_STAT_STRENGTH)
	var/damage = ROGUE_KICK_DAMAGE * rogue_formula_value(ROGUE_FORMULA_STRENGTH_FACTOR, list("strength" = strength, "min_strength" = 0))
	victim.apply_damage(damage, BRUTE, pick(BODY_ZONE_CHEST, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
	victim.visible_message(span_danger("[src] kicks [victim]!"), span_userdanger("[src] kicks me!"), ignored_mobs = src)
	to_chat(src, span_danger("I kick [victim]!"))
	playsound(victim, 'sound/effects/hit_kick.ogg', 100, TRUE, -1)
	log_combat(src, victim, "kicked")
	if(!victim.anchored && victim.body_position == STANDING_UP && prob(strength * ROGUE_KICK_SHOVE_PER_STRENGTH))
		var/turf/away = get_step(victim, get_dir(src, victim))
		if(away && !away.is_blocked_turf(TRUE))
			victim.throw_at(away, 1, 1, src, spin = FALSE)
	return TRUE

/atom/proc/rogue_onkick(mob/living/carbon/human/kicker)
	return

/obj/item/rogue_onkick(mob/living/carbon/human/kicker)
	if(anchored || w_class >= WEIGHT_CLASS_HUGE || locate(/obj/structure/table) in loc)
		return
	throw_at(get_ranged_target_turf(src, get_dir(kicker, src), ROGUE_KICK_ITEM_RANGE), ROGUE_KICK_ITEM_RANGE, 2, kicker, FALSE)

/obj/structure/mineral_door/rockhill/rogue_onkick(mob/living/carbon/human/kicker)
	kick(kicker)

/obj/structure/chair/wood/rockhill/rogue_onkick(mob/living/carbon/human/kicker)
	knock_over()

/obj/structure/lever/rogue_onkick(mob/living/carbon/human/kicker)
	kicker.visible_message(span_warning("[kicker] kicks the lever!"))
	playsound(src, 'modular_redtard/rockhill/sound/combat/hits/blunt/woodblunt (1).ogg', 100)
	if(!prob(kicker.rogue_stat(ROGUE_STAT_STRENGTH) * ROGUE_KICK_LEVER_PER_STRENGTH))
		return
	kicker.log_message("kicked the lever with redstone id \"[redstone_id]\"", LOG_GAME)
	toggled = !toggled
	icon_state = "[copytext(icon_state, 1, -1)][toggled]"
	playsound(src, 'modular_redtard/rockhill/sound/foley/lever.ogg', 100, extrarange = 3)
	send_redstone(kicker)

/obj/structure/lever/hidden/rogue_onkick(mob/living/carbon/human/kicker)
	return

/mob/living/carbon/human/proc/rogue_try_jump(atom/target)
	var/turf/destination = get_turf(target)
	if(!destination || destination == loc || destination.z != z)
		return FALSE
	if(num_legs < ROGUE_KICK_LEGS || pulledby || buckled || body_position != STANDING_UP || rogue_offbalanced())
		if(pulledby)
			to_chat(src, span_warning("I'm unable to jump while grabbed."))
		return FALSE
	if(istype(loc, /turf/open/water))
		to_chat(src, span_warning("I can't jump while floating."))
		return FALSE
	var/running = move_intent == MOVE_INTENT_RUN
	var/range = running ? ROGUE_JUMP_RUN_RANGE : ROGUE_JUMP_WALK_RANGE
	changeNext_move(CLICK_CD_MELEE)
	face_atom(destination)
	adjust_stamina_loss(running ? ROGUE_JUMP_RUN_STAMINA : ROGUE_JUMP_WALK_STAMINA)
	rogue_off_balance(running ? ROGUE_JUMP_RUN_OFFBALANCE : ROGUE_JUMP_WALK_OFFBALANCE)
	visible_message(span_notice("[src] [running ? "leaps" : "jumps"]!"))
	throw_at(destination, min(get_dist(src, destination), range), 1, src, spin = FALSE)
	return TRUE

/mob/living/carbon/human/proc/rogue_try_bite(atom/target)
	var/obj/item/rogue_bite/held_bite = wear_mouth
	if(istype(held_bite))
		return rogue_bite_chew(held_bite)
	if(!isliving(target) || target == src || !target.Adjacent(src))
		return FALSE
	if(is_mouth_covered())
		to_chat(src, span_warning("My mouth is covered."))
		return FALSE
	if(wear_mouth)
		to_chat(src, span_warning("My mouth has something in it."))
		return FALSE
	if(HAS_TRAIT(src, TRAIT_PACIFISM))
		to_chat(src, span_warning("I don't want to harm [target]!"))
		return FALSE
	var/mob/living/victim = target
	changeNext_move(CLICK_CD_MELEE)
	face_atom(victim)
	rogue_mark_in_combat()
	rogue_reveal_sneak()
	do_attack_animation(victim, ATTACK_EFFECT_BITE)
	if(victim.check_block(src, ROGUE_BITE_DAMAGE, "the bite", UNARMED_ATTACK, 0, BRUTE))
		return FALSE
	if(!iscarbon(victim))
		victim.apply_damage(ROGUE_BITE_DAMAGE, BRUTE, zone_selected, sharpness = SHARP_POINTY)
		victim.visible_message(span_danger("[src] bites [victim]!"), span_userdanger("[src] bites me!"), ignored_mobs = src)
		to_chat(src, span_danger("I bite [victim]!"))
		playsound(victim, 'sound/items/weapons/bite.ogg', 50, TRUE, -1)
		log_combat(src, victim, "bit")
		return TRUE
	var/mob/living/carbon/bitten = victim
	var/zone = rogue_precise_zone()
	var/obj/item/bodypart/limb = bitten.get_bodypart(rogue_zone_target(zone))
	if(!limb)
		to_chat(src, span_warning("Nothing to bite."))
		return FALSE
	var/strong = HAS_TRAIT(src, TRAIT_STRONGBITE)
	if(strong || LAZYLEN(limb.wounds))
		bitten.apply_damage(rogue_formula_value(ROGUE_FORMULA_BITE_DAMAGE, list("strength" = rogue_stat(ROGUE_STAT_STRENGTH), "strong_bite" = strong)), BRUTE, limb.body_zone, sharpness = SHARP_POINTY)
		playsound(bitten, pick('modular_redtard/rockhill/sound/combat/hits/bladed/smallslash (1).ogg', 'modular_redtard/rockhill/sound/combat/hits/bladed/smallslash (2).ogg', 'modular_redtard/rockhill/sound/combat/hits/bladed/smallslash (3).ogg'), 100, TRUE, -1)
	playsound(bitten, 'sound/items/weapons/bite.ogg', 50, TRUE, -1)
	var/part = rogue_zone_name(zone)
	bitten.visible_message(span_danger("[src] bites [bitten]'s [part]!"), span_userdanger("[src] bites my [part]!"), ignored_mobs = src)
	to_chat(src, span_danger("I bite [bitten]'s [part]!"))
	log_combat(src, bitten, "bit")
	var/obj/item/rogue_bite/new_bite = new(src, src, bitten, zone)
	if(!equip_to_slot_if_possible(new_bite, ITEM_SLOT_ROGUE_MOUTH, disable_warning = TRUE))
		qdel(new_bite)
	return TRUE

/mob/living/carbon/human/proc/rogue_bite_chew(obj/item/rogue_bite/held_bite)
	var/mob/living/carbon/bitten = held_bite.bitten
	if(QDELETED(bitten) || !bitten.Adjacent(src) || incapacitated)
		qdel(held_bite)
		return FALSE
	if(world.time < next_move)
		return FALSE
	changeNext_move(CLICK_CD_GRABBING)
	rogue_mark_in_combat()
	rogue_reveal_sneak()
	var/damage = rogue_unarmed_damage() * (HAS_TRAIT(src, TRAIT_STRONGBITE) ? ROGUE_BITE_STRONG_FACTOR : 1)
	do_attack_animation(bitten, ATTACK_EFFECT_BITE)
	bitten.apply_damage(damage, BRUTE, rogue_zone_target(held_bite.zone), sharpness = SHARP_POINTY)
	playsound(bitten, pick('modular_redtard/rockhill/sound/combat/hits/bladed/smallslash (1).ogg', 'modular_redtard/rockhill/sound/combat/hits/bladed/smallslash (2).ogg', 'modular_redtard/rockhill/sound/combat/hits/bladed/smallslash (3).ogg'), 100, FALSE, -1)
	var/part = rogue_zone_name(held_bite.zone)
	bitten.visible_message(span_danger("[src] bites [bitten]'s [part]!"), span_userdanger("[src] bites my [part]!"), span_hear("I hear a sickening sound of chewing!"), COMBAT_MESSAGE_RANGE, src)
	to_chat(src, span_danger("I bite [bitten]'s [part]."))
	log_combat(src, bitten, "chewed the [part] of")
	return TRUE

/obj/item/rogue_bite
	name = "bite"
	desc = "Teeth sunk into someone."
	icon = ROGUE_HUD_ICON_GRABS
	icon_state = "bite"
	item_flags = ABSTRACT | DROPDEL
	slot_flags = ITEM_SLOT_ROGUE_MOUTH
	w_class = WEIGHT_CLASS_HUGE
	var/mob/living/carbon/human/biter
	var/mob/living/carbon/bitten
	var/zone

/obj/item/rogue_bite/Initialize(mapload, mob/living/carbon/human/new_biter, mob/living/carbon/new_bitten, bite_zone)
	. = ..()
	if(!istype(new_biter) || !istype(new_bitten))
		return INITIALIZE_HINT_QDEL
	biter = new_biter
	bitten = new_bitten
	zone = bite_zone
	name = "[bitten.name]'s [rogue_zone_name(zone)]"
	ADD_TRAIT(src, TRAIT_NO_STORAGE_INSERT, TRAIT_GENERIC)
	RegisterSignal(bitten, COMSIG_QDELETING, PROC_REF(release))
	RegisterSignals(bitten, list(COMSIG_MOVABLE_MOVED), PROC_REF(check_reach))
	RegisterSignals(biter, list(COMSIG_MOVABLE_MOVED, COMSIG_MOB_STATCHANGE), PROC_REF(check_reach))

/obj/item/rogue_bite/Destroy()
	if(bitten)
		UnregisterSignal(bitten, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
	if(biter)
		UnregisterSignal(biter, list(COMSIG_MOVABLE_MOVED, COMSIG_MOB_STATCHANGE))
	biter = null
	bitten = null
	return ..()

/obj/item/rogue_bite/proc/release(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/obj/item/rogue_bite/proc/check_reach(datum/source)
	SIGNAL_HANDLER
	if(QDELETED(biter) || QDELETED(bitten) || biter.stat != STABLE || !biter.Adjacent(bitten))
		qdel(src)

/obj/item/rogue_bite/attack_hand(mob/user, list/modifiers)
	if(user != biter)
		return ..()
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		qdel(src)
		return TRUE
	if(text2num(LAZYACCESS(modifiers, ICON_Y)) >= ROGUE_BITE_CHEW_LINE)
		biter.rogue_bite_chew(src)
	else
		to_chat(user, span_warning("I can't drink from [bitten]."))
	return TRUE

/mob/living/carbon/human/proc/rogue_steal_targets(mob/living/carbon/human/victim, zone)
	switch(zone)
		if(BODY_ZONE_CHEST)
			return list(victim.get_item_by_slot(ITEM_SLOT_ROGUE_CLOAK))
		if(BODY_ZONE_L_ARM)
			return list(victim.back)
		if(BODY_ZONE_R_ARM)
			return list(victim.wear_backr)
		if(ROGUE_ZONE_NECK)
			return list(victim.get_item_by_slot(ITEM_SLOT_NECK))
		if(BODY_ZONE_PRECISE_GROIN)
			return list(victim.belt)
		if(BODY_ZONE_L_LEG)
			return list(victim.l_store)
		if(BODY_ZONE_R_LEG)
			return list(victim.r_store)
		if(BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND)
			return list(victim.get_item_by_slot(ITEM_SLOT_ROGUE_RING))
	return list()

/mob/living/carbon/human/proc/rogue_try_steal(atom/target)
	if(!ishuman(target) || target == src)
		return FALSE
	var/mob/living/carbon/human/victim = target
	var/zone = rogue_zone_precise || zone_selected
	if(get_dist(src, victim) > 1)
		to_chat(src, span_warning("[victim] is too far away."))
		return FALSE
	if(get_active_held_item())
		to_chat(src, span_warning("I can't pickpocket while my hand is full!"))
		return FALSE
	if(victim.combat_mode)
		to_chat(src, span_warning("[victim] is alert. I can't pickpocket them like this."))
		return FALSE
	to_chat(src, span_notice("I try to steal from [victim]..."))
	if(!do_after(src, ROGUE_STEAL_TIME, target = victim, progress = FALSE))
		return FALSE
	if(get_dist(src, victim) > 1 || get_active_held_item() || victim.combat_mode)
		return FALSE
	rogue_reveal_sneak()
	var/unaware = victim.stat != STABLE || victim.is_blind() || victim.body_position != STANDING_UP
	if(!unaware && !(get_dir(victim, src) & REVERSE_DIR(victim.dir)))
		to_chat(src, span_warning("They can see me!"))
		changeNext_move(CLICK_CD_MELEE)
		return FALSE
	var/rank = rogue_skill_rank(/datum/attribute/skill/misc/stealing)
	var/thief_score = roll("[rank + 1]d6") + round((rogue_stat(ROGUE_STAT_FORTUNE) - ROGUE_ATTRIBUTE_MIDDLING) / 3)
	var/perception = victim.rogue_stat(ROGUE_STAT_PERCEPTION)
	var/victim_score = unaware ? round(perception * ROGUE_STEAL_UNAWARE_FACTOR) : perception + round((victim.rogue_stat(ROGUE_STAT_SPEED) - ROGUE_ATTRIBUTE_MIDDLING) / 3)
	var/margin = thief_score - victim_score
	if(margin < 0)
		log_combat(src, victim, "attempted to pickpocket")
		if(margin < ROGUE_STEAL_FUMBLE)
			visible_message(span_danger("[src] is caught rummaging through [victim]'s belongings!"))
			victim.balloon_alert(victim, "thief!")
			to_chat(victim, span_danger("[src] tried to rob me!"))
		else
			to_chat(src, span_warning("I can't get at it without being noticed. Best stop here."))
			to_chat(victim, span_danger("Someone's fumbling at my belongings!"))
		changeNext_move(CLICK_CD_MELEE)
		return FALSE
	var/list/found = rogue_steal_targets(victim, zone) - null
	if(!length(found))
		to_chat(src, span_warning("I didn't find anything there. Perhaps I should look elsewhere."))
		changeNext_move(CLICK_CD_MELEE)
		return FALSE
	var/obj/item/loot = pick(found)
	if(zone == BODY_ZONE_PRECISE_L_HAND || zone == BODY_ZONE_PRECISE_R_HAND)
		if(!prob(clamp(ROGUE_STEAL_RING_BASE + rank * ROGUE_STEAL_RING_PER_RANK, ROGUE_STEAL_RING_MIN, ROGUE_STEAL_RING_MAX)))
			to_chat(src, span_warning("I can't work [loot] loose without them noticing."))
			return FALSE
	if(!victim.temporarilyRemoveItemFromInventory(loot))
		return FALSE
	put_in_active_hand(loot) || loot.forceMove(drop_location())
	to_chat(src, span_green("I stole [loot]!"))
	log_combat(src, victim, "pickpocketed [loot] from")
	rogue_adjust_experience(/datum/attribute/skill/misc/stealing, rogue_stat(ROGUE_STAT_INTELLIGENCE))
	return TRUE

/atom/movable/screen/rogue/quad_intents
	name = "mmb intents"
	icon_state = "mmbintents0"
	screen_loc = rogueui_quad
	layer = ROGUE_HUD_LAYER
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/rogue/quad_intents/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	var/mob/owner = hud_owner?.mymob
	if(owner)
		RegisterSignal(owner, COMSIG_MOB_ROGUE_MMB_CHANGED, PROC_REF(refresh))

/atom/movable/screen/rogue/quad_intents/proc/refresh()
	SIGNAL_HANDLER
	var/mob/living/carbon/human/owner = get_mob()
	icon_state = "mmbintents[ishuman(owner) ? owner.rogue_mmb_intent : ROGUE_MMB_NONE]"

/atom/movable/screen/rogue/quad_intents/Click(location, control, params)
	var/mob/living/carbon/human/owner = get_mob()
	if(usr != owner || !ishuman(owner))
		return
	var/icon_y = text2num(params2list(params)["icon-y"])
	if(icon_y <= ROGUE_QUAD_STEAL_TOP)
		owner.rogue_select_mmb(ROGUE_MMB_STEAL)
	else if(icon_y <= ROGUE_QUAD_KICK_TOP)
		owner.rogue_select_mmb(ROGUE_MMB_KICK)
	else if(icon_y <= ROGUE_QUAD_JUMP_TOP)
		owner.rogue_select_mmb(ROGUE_MMB_JUMP)
	else
		owner.rogue_select_mmb(ROGUE_MMB_BITE)
