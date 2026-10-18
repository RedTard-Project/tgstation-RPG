GLOBAL_LIST_INIT(rogue_default_parry_sounds, list('modular_redtard/rockhill/sound/combat/parry/parrygen.ogg'))

/proc/rogue_can_train(mob/living/learner, skill_type, teacher_rank)
	if(!learner?.mind || !skill_type)
		return FALSE
	return teacher_rank > learner.rogue_skill_rank(skill_type)

/proc/rogue_combat_xp(mob/living/learner, skill_type, factor = 1)
	if(!learner?.mind || !ispath(skill_type, /datum/attribute/skill/combat))
		return
	learner.rogue_adjust_experience(skill_type, max(round(learner.rogue_stat(ROGUE_STAT_INTELLIGENCE) * ROGUE_XP_PER_INT * factor), 0))

/mob/living/proc/rogue_can_defend(mob/living/attacker)
	if(stat != STABLE || !combat_mode || attacker == src)
		return FALSE
	if(HAS_TRAIT(src, TRAIT_INCAPACITATED) || HAS_TRAIT(src, TRAIT_IMMOBILIZED))
		return FALSE
	return is_source_facing_target(src, attacker) || get_dist(src, attacker) == 0

/mob/living/proc/rogue_spend_defense_stamina(amount, failure_text)
	if(get_stamina_loss() + amount >= max_stamina)
		to_chat(src, span_warning(failure_text))
		return FALSE
	adjust_stamina_loss(amount)
	return TRUE

/mob/living/carbon/human/proc/rogue_unarmed_defense()
	var/obj/item/wrists = get_item_by_slot(ITEM_SLOT_ROGUE_WRISTS)
	var/obj/item/gloves_worn = get_item_by_slot(ITEM_SLOT_GLOVES)
	var/equipped = (istype(wrists, /obj/item/clothing) && wrists.name) || istype(gloves_worn, /obj/item/clothing/gloves)
	var/wdef = (equipped && HAS_TRAIT(src, TRAIT_CIVILIZEDBARBARIAN)) ? UNARMED_BASE_WDEF_EQUIPPED : UNARMED_BASE_WDEF_BARE
	return rogue_skill_rank(/datum/attribute/skill/combat/unarmed) * PARRY_PER_SKILL_LEVEL + wdef * PARRY_PER_WDEF_POINT

/mob/living/carbon/human/proc/rogue_attempt_parry(mob/living/attacker, obj/item/attacker_weapon, datum/intent/attack_intent)
	if(world.time < rogue_last_parry + ROGUE_PARRY_DELAY)
		return FALSE
	if(attack_intent && !attack_intent.canparry)
		return FALSE
	if(pulledby || pulling)
		return FALSE
	rogue_last_parry = world.time
	var/prob2defend = 0
	var/obj/item/mainhand = get_active_held_item()
	var/obj/item/offhand = get_inactive_held_item()
	var/mainhand_defense = mainhand?.can_parry ? rogue_weapon_rank(mainhand) * PARRY_PER_SKILL_LEVEL + mainhand.rogue_wdefense() * PARRY_PER_WDEF_POINT : 0
	var/offhand_defense = offhand?.can_parry ? rogue_weapon_rank(offhand) * PARRY_PER_SKILL_LEVEL + offhand.rogue_wdefense() * PARRY_PER_WDEF_POINT : 0
	var/obj/item/used_weapon = mainhand_defense >= offhand_defense ? mainhand : offhand
	var/highest_defense = max(mainhand_defense, offhand_defense)
	var/unarmed_defense = rogue_unarmed_defense()
	var/unarmed_fallback = !used_weapon || used_weapon.associated_skill == /datum/attribute/skill/combat/unarmed
	var/weapon_parry = highest_defense > 0 && (!unarmed_fallback || highest_defense >= unarmed_defense)
	var/defender_skill_type = weapon_parry ? used_weapon.associated_skill : /datum/attribute/skill/combat/unarmed
	prob2defend += weapon_parry ? highest_defense : unarmed_defense
	if(move_intent == MOVE_INTENT_RUN)
		prob2defend -= ROGUE_PARRY_RUNNING_PENALTY
	if(weapon_parry && used_weapon.wbalance == WBALANCE_SWIFT && mainhand && !offhand && rogue_highest_armor_class() <= ARMOR_CLASS_LIGHT)
		prob2defend += ROGUE_PARRY_SWIFT_BONUS
	var/attacker_skill_type = attacker_weapon ? attacker.rogue_weapon_skill(attacker_weapon) : /datum/attribute/skill/combat/unarmed
	var/attacker_rank = attacker_skill_type ? attacker.rogue_skill_rank(attacker_skill_type) : 0
	prob2defend -= attacker_rank * PARRY_PER_SKILL_LEVEL
	var/attacker_speed = attacker.rogue_stat(ROGUE_STAT_SPEED)
	var/defender_speed = rogue_stat(ROGUE_STAT_SPEED)
	if(attacker_speed > defender_speed && (!attacker_weapon || attacker_weapon.wbalance == WBALANCE_SWIFT))
		var/swift = (attacker_speed - defender_speed) * 10
		swift -= max(0, (rogue_stat(ROGUE_STAT_PERCEPTION) - attacker.rogue_stat(ROGUE_STAT_PERCEPTION)) * (attacker_weapon ? 5 : 10))
		swift -= max(0, (rogue_stat(ROGUE_STAT_INTELLIGENCE) - attacker.rogue_stat(ROGUE_STAT_INTELLIGENCE)) * 3)
		prob2defend -= clamp(swift, 0, 30)
	if(body_position == LYING_DOWN)
		prob2defend *= ROGUE_PARRY_PRONE_FACTOR
	if(HAS_TRAIT(src, TRAIT_DUALWIELDER) && mainhand && offhand && mainhand.associated_skill == offhand.associated_skill)
		prob2defend -= 5
	prob2defend = clamp(prob2defend, ROGUE_PARRY_MIN, ROGUE_PARRY_MAX)
	var/drained = BASE_PARRY_STAMINA_DRAIN
	var/untrained = !rogue_armor_trained()
	if(untrained)
		prob2defend = min(prob2defend, ROGUE_PARRY_MAX_UNTRAINED)
		drained += ROGUE_PARRY_UNTRAINED_DRAIN
	if(!prob(prob2defend))
		return FALSE
	if(!rogue_spend_defense_stamina(drained, "I'm too tired to parry!"))
		return FALSE
	var/list/sounds = (weapon_parry && length(used_weapon.parrysound)) ? used_weapon.parrysound : GLOB.rogue_default_parry_sounds
	playsound(get_turf(src), pick(sounds), 100, FALSE)
	var/message = "<b>[src]</b> parries [attacker][weapon_parry ? " with [used_weapon]" : ""]![untrained ? " Untrained Armor Penalty!" : ""]"
	visible_message(span_warning(message), span_boldwarning(message), COMBAT_MESSAGE_RANGE, list(attacker))
	to_chat(attacker, span_boldwarning(message))
	log_combat(src, attacker, "parried")
	if(weapon_parry)
		used_weapon.take_damage(ROGUE_PARRY_INTEGRITY_DAMAGE, BRUTE, "", FALSE)
	if(body_position != LYING_DOWN && !isanimal_or_basicmob(attacker))
		var/factor = attacker.mind ? 1 : ROGUE_XP_NPC_FACTOR
		if(rogue_can_train(src, defender_skill_type, attacker_rank))
			rogue_combat_xp(src, defender_skill_type, factor)
		if(attacker_skill_type && rogue_can_train(attacker, attacker_skill_type, rogue_skill_rank(defender_skill_type)))
			rogue_combat_xp(attacker, attacker_skill_type, factor)
	return TRUE

/mob/living/carbon/human/proc/rogue_dodge_turf(mob/living/attacker)
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
	if(world.time < rogue_last_dodge + ROGUE_DODGE_DELAY)
		return FALSE
	if(attack_intent && !attack_intent.candodge)
		return FALSE
	if(pulledby || pulling || loc == attacker.loc)
		return FALSE
	rogue_last_dodge = world.time
	var/turf/dodge_turf = rogue_dodge_turf(attacker)
	if(!dodge_turf)
		to_chat(src, span_boldwarning("There's nowhere to dodge to!"))
		return FALSE
	if(!rogue_armor_trained() || legcuffed)
		Knockdown(1)
		drop_all_held_items()
		to_chat(src, span_warning("I can't dodge in such unfitting armor! I'm knocked down!"))
		return FALSE
	var/defender_speed = rogue_stat(ROGUE_STAT_SPEED)
	var/attacker_speed = attacker.rogue_stat(ROGUE_STAT_SPEED)
	var/prob2defend = ROGUE_DODGE_BASE + defender_speed * ROGUE_DODGE_PER_SPEED - attacker_speed * ROGUE_DODGE_PER_SPEED
	var/attacker_rank = 0
	if(attacker_weapon)
		if(attacker_weapon.wbalance == WBALANCE_SWIFT && attacker_speed > defender_speed)
			prob2defend -= (attacker_speed - defender_speed) * 10
		if(attacker_weapon.wbalance == WBALANCE_HEAVY && defender_speed > attacker_speed)
			prob2defend += (defender_speed - attacker_speed) * 10
		var/attacker_skill = attacker.rogue_weapon_skill(attacker_weapon)
		if(attacker_skill)
			attacker_rank = attacker.rogue_skill_rank(attacker_skill)
			prob2defend -= attacker_rank * ROGUE_DODGE_PER_SKILL
			prob2defend += rogue_skill_rank(attacker_skill) * ROGUE_DODGE_PER_SKILL
		else
			prob2defend += ROGUE_DODGE_IMPROVISED_BONUS
	else
		attacker_rank = attacker.rogue_skill_rank(/datum/attribute/skill/combat/unarmed)
		prob2defend -= attacker_rank * ROGUE_DODGE_PER_SKILL
		prob2defend += rogue_skill_rank(/datum/attribute/skill/combat/unarmed) * ROGUE_DODGE_PER_SKILL
		if(attacker_speed > defender_speed)
			prob2defend -= (attacker_speed - defender_speed) * 10
	if(body_position == LYING_DOWN)
		prob2defend *= ROGUE_DODGE_PRONE_FACTOR
	else if(mind && rogue_dodge_expert() && defender_speed > ROGUE_ATTRIBUTE_MIDDLING - 1)
		prob2defend = ROGUE_DODGE_EXPERT_CAP
	if(HAS_TRAIT(src, TRAIT_DUALWIELDER) && get_active_held_item() && get_inactive_held_item())
		prob2defend -= 5
	prob2defend = clamp(prob2defend, ROGUE_DODGE_MIN, ROGUE_DODGE_MAX)
	if(!prob(prob2defend))
		return FALSE
	var/drained = ROGUE_DODGE_STAMINA_DRAIN
	var/obj/item/mainhand = get_active_held_item()
	if(attacker_weapon && mainhand)
		drained += (attacker_rank - rogue_weapon_rank(mainhand)) * 2
	if(defender_speed < attacker_speed && (!mainhand || mainhand.wbalance != WBALANCE_HEAVY))
		drained += attacker_speed - defender_speed
	if(!attacker.mind)
		drained = ROGUE_DODGE_MIN_DRAIN
	if(!rogue_spend_defense_stamina(max(drained, ROGUE_DODGE_MIN_DRAIN), "I'm too tired to dodge!"))
		return FALSE
	playsound(src, 'modular_redtard/rockhill/sound/combat/dodge.ogg', 100, FALSE)
	throw_at(dodge_turf, 1, 2, src, FALSE)
	visible_message(span_warning("<b>[src]</b> dodges [attacker]'s attack!"))
	log_combat(src, attacker, "dodged against")
	return TRUE

/datum/element/rogue_defender
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

/datum/element/rogue_defender/Attach(datum/target)
	. = ..()
	if(!ishuman(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_LIVING_CHECK_BLOCK, PROC_REF(on_check_block))

/datum/element/rogue_defender/Detach(datum/source)
	UnregisterSignal(source, COMSIG_LIVING_CHECK_BLOCK)
	return ..()

/datum/element/rogue_defender/proc/on_check_block(mob/living/carbon/human/source, atom/movable/hitby, damage, attack_text, attack_type, armour_penetration, damage_type, attack_flag)
	SIGNAL_HANDLER
	if(attack_type != MELEE_ATTACK && attack_type != UNARMED_ATTACK)
		return NONE
	var/mob/living/attacker = isliving(hitby) ? hitby : get(hitby, /mob/living)
	if(!isliving(attacker) || !source.rogue_can_defend(attacker))
		return NONE
	var/obj/item/attacker_weapon = isitem(hitby) ? hitby : null
	var/datum/intent/attack_intent = attacker_weapon ? attacker.rogue_hand_intent(attacker.get_held_index_of_item(attacker_weapon)) : null
	var/defended = source.rogue_def_intent == ROGUE_INTENT_DODGE ? source.rogue_attempt_dodge(attacker, attacker_weapon, attack_intent) : source.rogue_attempt_parry(attacker, attacker_weapon, attack_intent)
	if(!defended)
		return NONE
	if(attack_intent?.misscost)
		attacker.adjust_stamina_loss(attack_intent.misscost)
	return SUCCESSFUL_BLOCK
