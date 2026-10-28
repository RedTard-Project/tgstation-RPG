GLOBAL_LIST_INIT(rogue_default_parry_sounds, list('modular_redtard/rockhill/sound/combat/parry/parrygen.ogg'))
GLOBAL_LIST_INIT(rogue_bind_catches, list(
	"head" = list("skull", "nose", "ears", "r_eye", "l_eye", BODY_ZONE_PRECISE_EYES, "mouth"),
	"skull" = list("skull", "nose", "ears", "r_eye", "l_eye", BODY_ZONE_PRECISE_EYES, "mouth"),
	"nose" = list("skull", "nose", "ears", "r_eye", "l_eye", BODY_ZONE_PRECISE_EYES, "mouth"),
	"ears" = list("skull", "nose", "ears", "r_eye", "l_eye", BODY_ZONE_PRECISE_EYES, "mouth"),
	"r_eye" = list("skull", "nose", "ears", "r_eye", "l_eye", BODY_ZONE_PRECISE_EYES, "mouth"),
	"l_eye" = list("skull", "nose", "ears", "r_eye", "l_eye", BODY_ZONE_PRECISE_EYES, "mouth"),
	BODY_ZONE_PRECISE_EYES = list("skull", "nose", "ears", "r_eye", "l_eye", BODY_ZONE_PRECISE_EYES, "mouth"),
	"mouth" = list("skull", "nose", "ears", "r_eye", "l_eye", BODY_ZONE_PRECISE_EYES, "mouth"),
	"l_arm" = list("l_hand"),
	"l_hand" = list("l_hand"),
	"r_arm" = list("r_hand"),
	"r_hand" = list("r_hand"),
	"l_leg" = list("l_foot"),
	"l_foot" = list("l_foot"),
	"r_leg" = list("r_foot"),
	"r_foot" = list("r_foot"),
	"chest" = list("stomach", "groin"),
	"stomach" = list("stomach", "groin"),
	"groin" = list("stomach", "groin"),
	"neck" = list("neck"),
))

/proc/rogue_can_train(mob/living/learner, skill_type, teacher_rank)
	if(!learner?.mind || !skill_type)
		return FALSE
	return teacher_rank > learner.rogue_skill_rank(skill_type)

/proc/rogue_combat_xp(mob/living/learner, skill_type, factor = 1)
	if(!learner?.mind || !ispath(skill_type, /datum/attribute/skill/combat))
		return
	learner.rogue_adjust_experience(skill_type, max(round(learner.rogue_stat(ROGUE_STAT_INTELLIGENCE) * ROGUE_XP_PER_INT * factor), 0))

/proc/rogue_weapon_defense_value(skill_rank, defense)
	return rogue_formula_value(ROGUE_FORMULA_WEAPON_DEFENSE, list("skill" = skill_rank, "defense" = defense))

/mob/living
	var/rogue_dodge_fatigue = 0
	var/rogue_dodge_cooldown = 0

/mob/living/proc/rogue_change_dodge_fatigue(amount, soft_cap = FALSE)
	if(amount < 0)
		rogue_dodge_fatigue = clamp(rogue_dodge_fatigue + amount, ROGUE_DODGE_FATIGUE_FLOOR, ROGUE_DODGE_FATIGUE_CEIL)
		return
	var/raised = rogue_dodge_fatigue + amount
	if(soft_cap && rogue_dodge_fatigue < ROGUE_DODGE_FATIGUE_SOFT_CAP && raised > ROGUE_DODGE_FATIGUE_SOFT_CAP)
		raised = ROGUE_DODGE_FATIGUE_SOFT_CAP
	rogue_dodge_fatigue = clamp(raised, ROGUE_DODGE_FATIGUE_FLOOR, ROGUE_DODGE_FATIGUE_CEIL)

/mob/living/proc/rogue_change_dodge_cooldown(amount)
	rogue_dodge_cooldown = clamp(rogue_dodge_cooldown + amount, 0, ROGUE_DODGE_DELAY)
	SEND_SIGNAL(src, COMSIG_MOB_ROGUE_DEFENSE_CHANGED)

/mob/living/proc/rogue_left_combat_mode()
	addtimer(CALLBACK(src, PROC_REF(rogue_rest_defense)), ROGUE_DODGE_RESET_TIME, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_DELETE_ME)
	addtimer(CALLBACK(src, PROC_REF(rogue_clear_tempo)), ROGUE_TEMPO_CLEAR_DELAY, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_DELETE_ME)

/mob/living/proc/rogue_rest_defense()
	if(combat_mode)
		return
	rogue_dodge_cooldown = 0
	rogue_dodge_fatigue = 0
	rogue_bait_stacks = 0
	SEND_SIGNAL(src, COMSIG_MOB_ROGUE_DEFENSE_CHANGED)

/mob/living/proc/rogue_sees(mob/living/attacker)
	if(attacker == src || get_dist(src, attacker) == 0)
		return TRUE
	if(HAS_TRAIT(src, TRAIT_FOV_APPLIED))
		return in_fov(attacker)
	return is_source_facing_target(src, attacker)

/mob/living/proc/rogue_can_defend(mob/living/attacker)
	if(stat != STABLE || !combat_mode || attacker == src)
		return FALSE
	if(HAS_TRAIT(src, TRAIT_INCAPACITATED) || HAS_TRAIT(src, TRAIT_IMMOBILIZED))
		return FALSE
	return TRUE

/mob/living/proc/rogue_spend_defense_stamina(amount, failure_text)
	if(get_stamina_loss() + amount >= max_stamina)
		to_chat(src, span_warning(failure_text))
		return FALSE
	adjust_stamina_loss(amount)
	return TRUE

/mob/living/carbon/human/proc/rogue_unarmed_gear()
	var/obj/item/clothing/wrists = get_item_by_slot(ITEM_SLOT_ROGUE_WRISTS)
	if(istype(wrists))
		return wrists
	var/obj/item/clothing/gloves/gloves_worn = get_item_by_slot(ITEM_SLOT_GLOVES)
	return istype(gloves_worn) ? gloves_worn : null

/mob/living/carbon/human/proc/rogue_unarmed_defense()
	var/wdef = (rogue_unarmed_gear() && HAS_TRAIT(src, TRAIT_CIVILIZEDBARBARIAN)) ? UNARMED_BASE_WDEF_EQUIPPED : UNARMED_BASE_WDEF_BARE
	return rogue_weapon_defense_value(rogue_skill_rank(/datum/attribute/skill/combat/unarmed), wdef)

/mob/living/carbon/human/proc/rogue_try_bind(obj/item/used_weapon, mob/living/attacker, obj/item/attacker_weapon, vulnerable = FALSE)
	if(!used_weapon || !attacker_weapon || used_weapon.associated_skill == /datum/attribute/skill/combat/unarmed)
		return FALSE
	if(rogue_weapon_rank(used_weapon) < ROGUE_BIND_RANK || has_status_effect(/datum/status_effect/rogue/bind_cooldown) || has_status_effect(/datum/status_effect/rogue/bind))
		return FALSE
	if(attacker.rogue_tempo_reaches("unbindable"))
		return FALSE
	var/our_zone = rogue_precise_zone()
	var/their_zone = attacker.rogue_precise_zone()
	var/list/catches = GLOB.rogue_bind_catches[our_zone]
	var/matched = (their_zone in catches) || (!attacker.mind && GLOB.rogue_major_zones[our_zone] == GLOB.rogue_major_zones[their_zone])
	if(!matched)
		return FALSE
	if(our_zone == BODY_ZONE_CHEST && their_zone == BODY_ZONE_CHEST && !prob(ROGUE_BIND_CHEST_CHANCE))
		return FALSE
	apply_status_effect(/datum/status_effect/rogue/bind)
	apply_status_effect(/datum/status_effect/rogue/bind_cooldown)
	attacker.Immobilize(ROGUE_BIND_ATTACKER_HOLD)
	attacker.rogue_delay_action(ROGUE_BIND_ATTACKER_CLICK)
	attacker.rogue_last_parry = world.time
	attacker_weapon.take_damage(attacker_weapon.get_sharpness() ? ROGUE_PARRY_INTEGRITY_DAMAGE : ROGUE_UNARMED_PARRY_WEAR, BRUTE, "", FALSE)
	attacker_weapon.rogue_dull(ROGUE_BLADE_PARRY_WEAR, attacker)
	if(vulnerable)
		used_weapon.take_damage(ROGUE_UNARMED_PARRY_WEAR * ROGUE_BIND_VULNERABLE_WEAR, BRUTE, "", FALSE)
		used_weapon.rogue_dull(ROGUE_BLADE_PARRY_WEAR * ROGUE_BIND_VULNERABLE_WEAR, src)
	do_sparks(4, FALSE, get_turf(src))
	playsound(src, pick(length(used_weapon.parrysound) ? used_weapon.parrysound : GLOB.rogue_default_parry_sounds), 100, TRUE, 2)
	visible_message(span_notice("[src] binds [p_their()] weapon with [attacker]'s! [p_They()] saw that attack coming!"))
	log_combat(src, attacker, "bound the weapon of")
	return TRUE

/mob/living/carbon/human/proc/rogue_attempt_parry(mob/living/attacker, obj/item/attacker_weapon, datum/intent/attack_intent)
	if(!rogue_sees(attacker) && !rogue_tempo_reaches("blind_defense"))
		return FALSE
	var/riposting = rogue_rmb_is(/datum/rogue_rmb_intent/defend)
	var/paired = attacker.rogue_dual_paired
	if(world.time < rogue_last_parry + ROGUE_PARRY_DELAY - rogue_tempo_bonus("parry_delay") && !riposting && !paired)
		return FALSE
	if(attack_intent && !attack_intent.canparry)
		return FALSE
	if(pulledby || pulling || HAS_TRAIT(src, TRAIT_CHUNKYFINGERS))
		return FALSE
	if(!paired)
		rogue_last_parry = world.time
	rogue_mark_in_combat()
	SEND_SIGNAL(src, COMSIG_MOB_ROGUE_DEFENSE_CHANGED)
	var/obj/item/mainhand = get_active_held_item()
	var/obj/item/offhand = get_inactive_held_item()
	var/mainhand_defense = mainhand?.can_parry ? rogue_weapon_defense_value(rogue_weapon_rank(mainhand), mainhand.rogue_wdefense()) : 0
	var/offhand_defense = offhand?.can_parry ? rogue_weapon_defense_value(rogue_weapon_rank(offhand), offhand.rogue_wdefense()) : 0
	var/obj/item/used_weapon = mainhand_defense >= offhand_defense ? mainhand : offhand
	var/highest_defense = max(mainhand_defense, offhand_defense)
	var/unarmed_defense = rogue_unarmed_defense()
	var/unarmed_fallback = !used_weapon || used_weapon.associated_skill == /datum/attribute/skill/combat/unarmed
	var/weapon_parry = highest_defense > 0 && (!unarmed_fallback || highest_defense >= unarmed_defense)
	var/defender_skill_type = weapon_parry ? used_weapon.associated_skill : /datum/attribute/skill/combat/unarmed
	var/attacker_skill_type = attacker_weapon ? attacker.rogue_weapon_skill(attacker_weapon) : /datum/attribute/skill/combat/unarmed
	var/attacker_rank = attacker_skill_type ? attacker.rogue_skill_rank(attacker_skill_type) : 0
	if(weapon_parry && !unarmed_fallback && attacker.mind && rogue_try_bind(used_weapon, attacker, attacker_weapon))
		return TRUE
	var/attacker_zone = attacker.rogue_precise_zone()
	var/zone_cap = ROGUE_SWIFT_CAP_UNARMED
	if(attacker_weapon && mind)
		zone_cap = attacker_zone == BODY_ZONE_CHEST ? ROGUE_SWIFT_CAP_CHEST : (GLOB.rogue_major_zones[attacker_zone] == attacker_zone ? ROGUE_SWIFT_CAP_LIMB : ROGUE_SWIFT_CAP_PRECISE)
	var/speed_pressure = rogue_formula_value(ROGUE_FORMULA_SPEED_PRESSURE, list(
		"swift_attack" = !attacker_weapon || attacker_weapon.wbalance == WBALANCE_SWIFT,
		"attacker_armed" = !!attacker_weapon,
		"attacker_speed" = attacker.rogue_stat(ROGUE_STAT_SPEED),
		"defender_speed" = rogue_stat(ROGUE_STAT_SPEED),
		"attacker_perception" = attacker.rogue_stat(ROGUE_STAT_PERCEPTION),
		"defender_perception" = rogue_stat(ROGUE_STAT_PERCEPTION),
		"attacker_intelligence" = attacker.rogue_stat(ROGUE_STAT_INTELLIGENCE),
		"defender_intelligence" = rogue_stat(ROGUE_STAT_INTELLIGENCE),
		"cap" = zone_cap,
	))
	var/untrained = !rogue_armor_trained()
	var/prob2defend = rogue_formula_value(ROGUE_FORMULA_PARRY_CHANCE, list(
		"defense" = weapon_parry ? highest_defense : unarmed_defense,
		"attacker_skill" = attacker_rank,
		"running" = move_intent == MOVE_INTENT_RUN,
		"swift_guard" = weapon_parry && used_weapon.wbalance == WBALANCE_SWIFT && mainhand && !offhand && rogue_highest_armor_class() <= ARMOR_CLASS_LIGHT,
		"speed_pressure" = speed_pressure,
		"prone" = body_position == LYING_DOWN,
		"dual_wield" = HAS_TRAIT(src, TRAIT_DUALWIELDER) && rogue_can_dual_wield(mainhand, offhand),
		"untrained_armor" = untrained,
		"bound" = !!has_status_effect(/datum/status_effect/rogue/bind),
	))
	prob2defend -= rogue_swing_defense_penalty()
	var/drained = BASE_PARRY_STAMINA_DRAIN
	if(untrained)
		drained += ROGUE_PARRY_UNTRAINED_DRAIN
	if(!prob(prob2defend))
		return FALSE
	var/strength_gap = attacker.rogue_stat(ROGUE_STAT_STRENGTH) - rogue_stat(ROGUE_STAT_STRENGTH)
	if(attacker_weapon?.wbalance == WBALANCE_HEAVY && strength_gap > 0 && !has_status_effect(/datum/status_effect/rogue/bind))
		drained += strength_gap * ROGUE_PARRY_HEAVY_DRAIN
	if(!rogue_spend_defense_stamina(max(drained - rogue_tempo_bonus("parry_stamina"), 0), "I'm too tired to parry!"))
		return FALSE
	var/list/sounds = (weapon_parry && length(used_weapon.parrysound)) ? used_weapon.parrysound : GLOB.rogue_default_parry_sounds
	playsound(get_turf(src), pick(sounds), 100, FALSE)
	var/strong_attack = attacker.rogue_rmb_is(/datum/rogue_rmb_intent/strong)
	var/message = "<b>[src]</b> [riposting ? "[pick("expertly", "deftly")] parries" : "parries"] [attacker][strong_attack ? "'s [pick("hefty", "strong")] attack" : ""][weapon_parry ? " with [used_weapon]" : ""]![untrained ? " Untrained Armor Penalty!" : ""]"
	visible_message(span_warning(message), span_boldwarning(message), null, COMBAT_MESSAGE_RANGE, list(attacker))
	to_chat(attacker, span_boldwarning(message))
	log_combat(src, attacker, "parried")
	if(attack_intent?.sharpness_penalty)
		attacker_weapon?.rogue_dull(attack_intent.sharpness_penalty, attacker)
	if(weapon_parry)
		used_weapon.take_damage((ROGUE_PARRY_INTEGRITY_DAMAGE + (strong_attack ? ROGUE_STRONG_INTEGRITY_WEAR : 0)) * rogue_tempo_factor("parry_wear"), BRUTE, "", FALSE)
		if(used_weapon.get_sharpness())
			used_weapon.rogue_dull(ROGUE_BLADE_PARRY_WEAR + (strong_attack ? ROGUE_BLADE_STRONG_WEAR : 0), src)
	else
		rogue_unarmed_gear()?.take_damage(ROGUE_UNARMED_PARRY_WEAR, BRUTE, "", FALSE)
	if(mind)
		rogue_change_dodge_cooldown(-ROGUE_DEFENSE_RECOVERY)
		rogue_change_dodge_fatigue(ROGUE_DEFENSE_RECOVERY)
	if(body_position != LYING_DOWN && !isanimal_or_basicmob(attacker))
		var/factor = attacker.mind ? 1 : ROGUE_XP_NPC_FACTOR
		if(rogue_can_train(src, defender_skill_type, attacker_rank))
			rogue_combat_xp(src, defender_skill_type, factor)
		if(attacker_skill_type && rogue_can_train(attacker, attacker_skill_type, rogue_skill_rank(defender_skill_type)))
			rogue_combat_xp(attacker, attacker_skill_type, factor)
	return TRUE

/mob/living/carbon/human/proc/rogue_dodge_turf(mob/living/attacker)
	if(rogue_fixed_eye)
		var/turf/behind = get_step(src, REVERSE_DIR(dir))
		if(behind && !behind.is_blocked_turf(TRUE))
			return behind
	var/list/directions
	var/dx = x - attacker.x
	var/dy = y - attacker.y
	if(abs(dx) < abs(dy))
		directions = dy > 0 ? list(NORTH, WEST, EAST) : list(SOUTH, WEST, EAST)
	else
		directions = dx > 0 ? list(EAST, SOUTH, NORTH) : list(WEST, NORTH, SOUTH)
	for(var/direction in shuffle(directions))
		var/turf/candidate = get_step(src, direction)
		if(candidate && !candidate.is_blocked_turf(TRUE))
			return candidate

/mob/living/carbon/human/proc/rogue_attempt_dodge(mob/living/attacker, obj/item/attacker_weapon, datum/intent/attack_intent)
	var/riposting = rogue_rmb_is(/datum/rogue_rmb_intent/defend)
	var/paired = attacker.rogue_dual_paired
	if(world.time < rogue_last_dodge + rogue_dodge_cooldown && !riposting && !paired)
		return FALSE
	if(attack_intent && !attack_intent.candodge)
		return FALSE
	if(pulledby || pulling || loc == attacker.loc)
		return FALSE
	if(!paired)
		rogue_last_dodge = world.time
	rogue_mark_in_combat()
	var/turf/dodge_turf = rogue_dodge_turf(attacker)
	if(!dodge_turf)
		to_chat(src, span_boldwarning("There's nowhere to dodge to!"))
		return FALSE
	if(!rogue_armor_trained() || legcuffed)
		Knockdown(1)
		drop_all_held_items()
		to_chat(src, span_warning("I can't dodge in such unfitting armor! I'm knocked down!"))
		return FALSE
	var/seen = rogue_sees(attacker) || rogue_tempo_reaches("blind_defense")
	if(!seen)
		rogue_change_dodge_cooldown(ROGUE_BLIND_DODGE_PENALTY)
		rogue_change_dodge_fatigue(-ROGUE_BLIND_DODGE_PENALTY)
	var/defender_speed = rogue_stat(ROGUE_STAT_SPEED)
	var/attacker_speed = attacker.rogue_stat(ROGUE_STAT_SPEED)
	var/attacker_skill = attacker_weapon ? attacker.rogue_weapon_skill(attacker_weapon) : /datum/attribute/skill/combat/unarmed
	var/attacker_rank = attacker_skill ? attacker.rogue_skill_rank(attacker_skill) : 0
	var/expert = mind && rogue_dodge_expert() && seen && defender_speed >= ROGUE_ATTRIBUTE_MIDDLING && body_position != LYING_DOWN
	var/prob2defend = rogue_formula_value(ROGUE_FORMULA_DODGE_CHANCE, list(
		"defender_speed" = defender_speed,
		"attacker_speed" = attacker_speed,
		"swift_attack" = !attacker_weapon || attacker_weapon.wbalance == WBALANCE_SWIFT,
		"heavy_attack" = attacker_weapon?.wbalance == WBALANCE_HEAVY,
		"improvised" = attacker_weapon && !attacker_skill,
		"defender_skill" = attacker_skill ? rogue_skill_rank(attacker_skill) : 0,
		"attacker_skill" = attacker_rank,
		"prone" = body_position == LYING_DOWN,
		"dodge_expert" = expert,
		"dual_wield" = HAS_TRAIT(src, TRAIT_DUALWIELDER) && rogue_can_dual_wield(get_active_held_item(), get_inactive_held_item()),
		"base" = attacker.rogue_defense_base(),
		"fatigue" = rogue_dodge_fatigue,
	))
	prob2defend -= rogue_swing_defense_penalty()
	if(!prob(prob2defend))
		return FALSE
	var/drained = ROGUE_DODGE_STAMINA_DRAIN
	var/obj/item/mainhand = get_active_held_item()
	if(attacker_weapon && mainhand)
		drained += (attacker_rank - rogue_weapon_rank(mainhand)) * 2
		if(attacker.rogue_rmb_is(/datum/rogue_rmb_intent/swift) && attacker_weapon.wbalance != WBALANCE_HEAVY && rogue_dodge_cooldown <= ROGUE_SWIFT_DODGE_WINDOW)
			drained += abs(round((ROGUE_DODGE_DELAY - rogue_dodge_cooldown) / 2))
	if(defender_speed < attacker_speed && (!mainhand || mainhand.wbalance != WBALANCE_HEAVY))
		drained += attacker_speed - defender_speed
	if(!attacker.mind)
		drained = ROGUE_DODGE_MIN_DRAIN
	if(!rogue_spend_defense_stamina(max(max(drained, ROGUE_DODGE_MIN_DRAIN) - rogue_tempo_bonus("dodge_stamina"), 0), "I'm too tired to dodge!"))
		return FALSE
	playsound(src, 'modular_redtard/rockhill/sound/combat/dodge.ogg', 100, FALSE)
	throw_at(dodge_turf, 1, 2, src, FALSE)
	visible_message(span_warning("<b>[src]</b> [drained > 0 ? "dodges" : "easily dodges"] [attacker]'s attack!"))
	log_combat(src, attacker, "dodged against")
	rogue_dodge_clip(attacker, attack_intent)
	var/keeps_dodge = rogue_tempo_reaches("dodge_keep") || (rogue_tempo_level() && !prob(ROGUE_TEMPO_DODGE_LOSS_CHANCE))
	if(expert && !keeps_dodge && !(rogue_fixed_eye && rogue_goodluck(ROGUE_DODGE_FIXED_LUCK)))
		var/rank_gap = (mainhand ? rogue_weapon_rank(mainhand) : rogue_skill_rank(/datum/attribute/skill/combat/unarmed)) - attacker_rank
		rogue_change_dodge_cooldown(1)
		rogue_change_dodge_fatigue(-1 + min(rank_gap, 0))
	return TRUE

/mob/living/carbon/human/proc/rogue_dodge_clip(mob/living/attacker, datum/intent/attack_intent)
	var/reach = attack_intent ? attack_intent.reach : 1
	var/distance = get_dist(src, attacker)
	if(distance > reach)
		return
	var/obj/item/our_weapon = get_active_held_item()
	var/obj/item/their_weapon = attacker.get_active_held_item()
	if(!our_weapon || !their_weapon)
		return
	var/chance = ROGUE_CLIP_BASE + (our_weapon.wlength - WLENGTH_NORMAL) * ROGUE_CLIP_PER_STEP + max(reach - distance - 1, 0) * ROGUE_CLIP_PER_STEP
	chance += (rogue_stat(ROGUE_STAT_FORTUNE) - attacker.rogue_stat(ROGUE_STAT_FORTUNE)) * ROGUE_CLIP_PER_STEP
	if(!prob(chance))
		return
	var/strong_attack = attacker.rogue_rmb_is(/datum/rogue_rmb_intent/strong)
	our_weapon.take_damage((our_weapon.max_blade_int ? ROGUE_PARRY_INTEGRITY_DAMAGE : ROGUE_UNARMED_PARRY_WEAR) + (strong_attack ? ROGUE_STRONG_INTEGRITY_WEAR : 0), BRUTE, "", FALSE)
	our_weapon.rogue_dull(ROGUE_BLADE_PARRY_WEAR + (strong_attack ? ROGUE_BLADE_STRONG_WEAR : 0), src)
	attacker.visible_message(span_warning("<b>[attacker]</b> clips [src]'s weapon!"))
	playsound(attacker, 'modular_redtard/rockhill/sound/misc/weapon_clip.ogg', 100)

/datum/element/rogue_combat/proc/on_check_block(mob/living/carbon/human/source, atom/movable/hitby, damage, attack_text, attack_type, armour_penetration, damage_type, attack_flag)
	SIGNAL_HANDLER
	if(attack_type != MELEE_ATTACK && attack_type != UNARMED_ATTACK)
		return NONE
	var/mob/living/attacker = isliving(hitby) ? hitby : get(hitby, /mob/living)
	if(!isliving(attacker))
		return NONE
	source.rogue_mark_in_combat()
	attacker.rogue_mark_in_combat()
	if(source.rogue_swing_struck() || source.rogue_charging_ranged())
		return NONE
	if(!source.rogue_can_defend(attacker))
		return NONE
	var/obj/item/attacker_weapon = isitem(hitby) ? hitby : null
	if(!ishuman(attacker) && source.has_status_effect(/datum/status_effect/rogue/guard))
		var/datum/rogue_strike/beast_strike = new(attacker, source, null, null, ROGUE_STRIKE_MELEE)
		var/caught = beast_strike.incoming() & ROGUE_STRIKE_CANCEL
		qdel(beast_strike)
		if(caught)
			return SUCCESSFUL_BLOCK
	var/datum/intent/attack_intent
	if(ishuman(attacker))
		var/mob/living/carbon/human/human_attacker = attacker
		attack_intent = human_attacker.rogue_strike_intent(attacker_weapon)
	if(source.rogue_is_open())
		if(source.has_status_effect(/datum/status_effect/rogue_vulnerable) && attacker.mind && source.rogue_try_bind(source.get_active_held_item(), attacker, attacker_weapon, TRUE))
			source.remove_status_effect(/datum/status_effect/rogue_vulnerable)
			return SUCCESSFUL_BLOCK
		return NONE
	var/defended = source.rogue_def_intent == ROGUE_INTENT_DODGE ? source.rogue_attempt_dodge(attacker, attacker_weapon, attack_intent) : source.rogue_attempt_parry(attacker, attacker_weapon, attack_intent)
	if(!defended)
		return NONE
	if(attack_intent?.misscost)
		attacker.adjust_stamina_loss(attack_intent.misscost)
	return SUCCESSFUL_BLOCK
