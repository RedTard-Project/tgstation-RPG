/obj/item/rogueweapon/shield
	special = /datum/special_intent/limbguard
	var/coverage = 0
	COOLDOWN_DECLARE(rogue_shield_bang)

/obj/item/rogueweapon/shield/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	. = ..()
	if(. || (attack_type != PROJECTILE_ATTACK && attack_type != THROWN_PROJECTILE_ATTACK))
		return
	var/mob/living/attacker
	if(isprojectile(hitby))
		var/obj/projectile/shot = hitby
		attacker = shot.firer
	else
		attacker = hitby.throwing?.get_thrower()
	if(!isliving(attacker) || !owner.rogue_sees(attacker) || (integrity_failure && get_integrity_percentage() <= integrity_failure))
		return FALSE
	if(!owner.rogue_shield_raised(src) && !prob(coverage))
		return FALSE
	owner.visible_message(span_danger("[owner] expertly blocks [hitby] with [src]!"))
	if(length(parrysound))
		playsound(owner, pick(parrysound), 100, TRUE)
	take_damage(floor(damage / ROGUE_SHIELD_BLOCK_WEAR_DIVISOR), BRUTE, "", FALSE)
	return TRUE

/obj/item/rogueweapon/shield/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(src != user.get_inactive_held_item() || !istype(tool, /obj/item/rogueweapon) || istype(tool, /obj/item/rogueweapon/shield))
		return ..()
	if(COOLDOWN_FINISHED(src, rogue_shield_bang))
		user.visible_message(span_danger("[user] bangs [src] with [tool]!"))
		playsound(user, 'modular_redtard/rockhill/sound/combat/shieldbang.ogg', 50, TRUE)
		COOLDOWN_START(src, rogue_shield_bang, ROGUE_SHIELD_BANG_COOLDOWN)
	return ITEM_INTERACT_SUCCESS

/mob/living/carbon/human/proc/rogue_shield_raised(obj/item/shield)
	if(get_active_held_item() != shield)
		return FALSE
	var/datum/intent/intent = rogue_strike_intent(shield)
	return intent?.tshield && rogue_charge_full(intent)

/datum/status_effect/rogue/limbguard
	id = "rogue_limbguard"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/rogue/limbguard
	var/zone
	var/obj/item/shield
	var/active = FALSE
	var/cooldown = 0
	var/mutable_appearance/guard_overlay

/datum/status_effect/rogue/limbguard/on_creation(mob/living/new_owner, guard_zone, obj/item/guard_shield, guard_cooldown)
	zone = guard_zone
	shield = guard_shield
	cooldown = guard_cooldown
	return ..(new_owner)

/datum/status_effect/rogue/limbguard/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_ROGUE_STRIKE_INCOMING, PROC_REF(on_incoming))
	RegisterSignal(owner, COMSIG_ROGUE_STRIKE_SWING, PROC_REF(on_swing))
	RegisterSignal(owner, COMSIG_ROGUE_MANOEUVRE, PROC_REF(on_manoeuvre))
	RegisterSignal(owner, COMSIG_ATOM_PRE_BULLET_ACT, PROC_REF(on_shot))
	RegisterSignal(shield, COMSIG_QDELETING, PROC_REF(on_shield_deleted))
	playsound(owner, 'modular_redtard/rockhill/sound/combat/limbguard.ogg', 100, TRUE)
	set_overlay("eff_guard", 100)
	addtimer(CALLBACK(src, PROC_REF(activate)), ROGUE_LIMBGUARD_START, TIMER_DELETE_ME)

/datum/status_effect/rogue/limbguard/on_remove()
	UnregisterSignal(owner, list(COMSIG_ROGUE_STRIKE_INCOMING, COMSIG_ROGUE_STRIKE_SWING, COMSIG_ROGUE_MANOEUVRE, COMSIG_ATOM_PRE_BULLET_ACT))
	if(shield)
		UnregisterSignal(shield, COMSIG_QDELETING)
	set_overlay(null)
	shield = null
	if(cooldown > 0)
		owner.apply_status_effect(/datum/status_effect/rogue/special_cooldown, cooldown)
	owner.apply_status_effect(/datum/status_effect/rogue/guard_cooldown, max(ROGUE_GUARD_COOLDOWN - owner.rogue_tempo_bonus("rmb_cooldown"), 1))
	return ..()

/datum/status_effect/rogue/limbguard/proc/activate()
	active = TRUE
	set_overlay("eff_guard_[zone]", 255)

/datum/status_effect/rogue/limbguard/proc/set_overlay(state, alpha)
	if(guard_overlay)
		owner.cut_overlay(guard_overlay)
		guard_overlay = null
	if(!state)
		return
	guard_overlay = mutable_appearance(ROGUE_MOB_EFFECTS_ICON, state, ABOVE_ALL_MOB_LAYER, alpha = alpha)
	switch(zone)
		if(BODY_ZONE_L_ARM)
			guard_overlay.pixel_w = 9
		if(BODY_ZONE_R_ARM)
			guard_overlay.pixel_w = -9
		if(BODY_ZONE_HEAD)
			guard_overlay.pixel_z = 17
		if(BODY_ZONE_L_LEG)
			guard_overlay.pixel_w = 6
			guard_overlay.pixel_z = -9
		if(BODY_ZONE_R_LEG)
			guard_overlay.pixel_w = -6
			guard_overlay.pixel_z = -9
	owner.add_overlay(guard_overlay)

/datum/status_effect/rogue/limbguard/tick(seconds_between_ticks)
	if(!owner.combat_mode || !owner.is_holding(shield) || owner.get_stamina_loss() + ROGUE_LIMBGUARD_DRAIN >= owner.max_stamina)
		qdel(src)
		return
	owner.adjust_stamina_loss(ROGUE_LIMBGUARD_DRAIN)

/datum/status_effect/rogue/limbguard/proc/on_shield_deleted(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/status_effect/rogue/limbguard/proc/guards(mob/living/attacker)
	return active && GLOB.rogue_major_zones[attacker.rogue_precise_zone()] == zone

/datum/status_effect/rogue/limbguard/proc/on_incoming(mob/living/carbon/human/source, datum/rogue_strike/strike)
	SIGNAL_HANDLER
	if(!ishuman(strike.attacker) || !guards(strike.attacker))
		return NONE
	switch(strike.kind)
		if(ROGUE_STRIKE_MELEE, ROGUE_STRIKE_CLEAVE)
			INVOKE_ASYNC(src, PROC_REF(counter_strike), strike.attacker, strike.weapon)
			return ROGUE_STRIKE_CANCEL
		if(ROGUE_STRIKE_BITE)
			INVOKE_ASYNC(src, PROC_REF(counter_bite), strike.attacker)
			return ROGUE_STRIKE_CANCEL
	return NONE

/datum/status_effect/rogue/limbguard/proc/on_swing(mob/living/carbon/human/source, datum/rogue_strike/strike)
	SIGNAL_HANDLER
	if(strike.weapon == shield)
		qdel(src)
	return NONE

/datum/status_effect/rogue/limbguard/proc/on_manoeuvre(mob/living/carbon/human/source, kind)
	SIGNAL_HANDLER
	if(kind == ROGUE_MANOEUVRE_KICK || kind == ROGUE_MANOEUVRE_JUMP || kind == ROGUE_MANOEUVRE_SPECIAL)
		qdel(src)

/datum/status_effect/rogue/limbguard/proc/on_shot(mob/living/carbon/human/source, obj/projectile/shot, def_zone, piercing_hit)
	SIGNAL_HANDLER
	if(!active || GLOB.rogue_major_zones[def_zone] != zone)
		return NONE
	do_sparks(2, TRUE, get_turf(source))
	source.visible_message(span_warning("[source] blocks \the [shot]!"))
	return COMPONENT_BULLET_BLOCKED

/datum/status_effect/rogue/limbguard/proc/punish(mob/living/carbon/human/attacker)
	attacker.Immobilize(ROGUE_LIMBGUARD_IMMOBILIZE)
	attacker.rogue_delay_action(ROGUE_LIMBGUARD_CLICK)
	attacker.apply_status_effect(/datum/status_effect/rogue/exposed, ROGUE_LIMBGUARD_EXPOSED)
	attacker.remove_status_effect(/datum/status_effect/rogue/limbguard)
	attacker.adjust_stamina_loss(attacker.max_stamina / 3)
	attacker.rogue_energy_add(-attacker.rogue_max_energy / 5)
	if(attacker.mind)
		var/mob/living/carbon/human/guardian = owner
		guardian.adjust_stamina_loss(-guardian.max_stamina / 3)
		guardian.rogue_energy_add(guardian.rogue_max_energy / 5)
	playsound(owner, 'modular_redtard/rockhill/sound/combat/limbguard_struck.ogg', 100, TRUE)
	log_combat(owner, attacker, "caught with a limb guard")

/datum/status_effect/rogue/limbguard/proc/counter_strike(mob/living/carbon/human/attacker, obj/item/weapon)
	var/mob/living/carbon/human/guardian = owner
	if(!weapon)
		var/obj/item/clothing/gloves/gloves_worn = attacker.get_item_by_slot(ITEM_SLOT_GLOVES)
		if(istype(gloves_worn) && !(gloves_worn.integrity_failure && gloves_worn.get_integrity_percentage() <= gloves_worn.integrity_failure))
			gloves_worn.take_damage(ROGUE_LIMBGUARD_GLOVE_DAMAGE, BRUTE, "", FALSE)
		else
			var/obj/item/bodypart/arm = attacker.get_active_hand()
			if(arm)
				attacker.cause_wound_of_type_and_severity(WOUND_BLUNT, arm, WOUND_SEVERITY_SEVERE, WOUND_SEVERITY_SEVERE, wound_source = "limb guard")
				guardian.visible_message(span_userdanger("Critical hit! [guardian] catches [attacker]'s bare-handed strike and SNAPS [attacker.p_their()] [arm.plaintext_zone]!"))
		guardian.rogue_riposte(attacker)
		playsound(guardian, 'modular_redtard/rockhill/sound/combat/limbguard_struck.ogg', 100, TRUE)
		qdel(src)
		return
	punish(attacker)
	guardian.visible_message(span_boldwarning("[guardian] anticipated the strike, disarming [attacker] in a decisive guard!"))
	do_sparks(1, TRUE, get_step(guardian, guardian.dir))
	if(!QDELETED(weapon) && attacker.is_holding(weapon))
		attacker.rogue_disarmed(weapon)
		var/wear = weapon.max_blade_int && weapon.rogue_dull(ROGUE_LIMBGUARD_EDGE_LOSS, attacker) ? ROGUE_LIMBGUARD_INTEGRITY_LOSS / 2 : ROGUE_LIMBGUARD_INTEGRITY_LOSS
		weapon.take_damage(min(wear, max(weapon.get_integrity() - ROGUE_LIMBGUARD_INTEGRITY_FLOOR, 0)), BRUTE, "", FALSE)
	qdel(src)

/datum/status_effect/rogue/limbguard/proc/counter_bite(mob/living/carbon/human/biter)
	punish(biter)
	owner.visible_message(span_userdanger("Critical hit! [owner] deftly counters [biter]'s bite with a THUNDEROUS bash, SHATTERING [biter.p_their()] jaw!"))
	var/obj/item/bodypart/head = biter.get_bodypart(BODY_ZONE_HEAD)
	if(head)
		biter.cause_wound_of_type_and_severity(WOUND_BLUNT, head, WOUND_SEVERITY_SEVERE, WOUND_SEVERITY_SEVERE, wound_source = "limb guard")
	do_sparks(1, TRUE, get_step(owner, owner.dir))
	qdel(src)

/atom/movable/screen/alert/status_effect/rogue/limbguard
	name = "Limb Guard"
	desc = "I have focused my attention to guarding one limb. I shall deflect projectiles and blows to that limb with ease."
	icon_state = "limbguard"
