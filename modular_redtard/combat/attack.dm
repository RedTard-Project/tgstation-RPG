/proc/rogue_strength_factor(obj/item/weapon, mob/living/user)
	var/needed = 0
	if(weapon?.minstr)
		needed = weapon.rogue_wielded ? max(weapon.minstr / 2, 1) : weapon.minstr
	return rogue_formula_value(ROGUE_FORMULA_STRENGTH_FACTOR, list("strength" = user.rogue_stat(ROGUE_STAT_STRENGTH), "min_strength" = needed))

/mob/living/proc/rogue_weapon_skill(obj/item/weapon)
	if(!weapon?.associated_skill)
		return null
	return weapon.associated_skill

/mob/living/proc/rogue_weapon_rank(obj/item/weapon, fallback = /datum/attribute/skill/combat/unarmed)
	var/skill = rogue_weapon_skill(weapon) || (weapon ? null : fallback)
	return skill ? rogue_skill_rank(skill) : 0

/datum/element/rogue_weapon/proc/on_equipped(obj/item/source, mob/equipper, slot)
	SIGNAL_HANDLER
	if(!isliving(equipper) || !(slot & ITEM_SLOT_HANDS))
		return
	var/mob/living/holder = equipper
	source.rogue_apply_intent(holder.rogue_hand_intent(holder.get_held_index_of_item(source)))
	SEND_SIGNAL(holder, COMSIG_MOB_ROGUE_INTENT_CHANGED)

/datum/element/rogue_weapon/proc/on_examine(obj/item/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(source.associated_skill)
		var/datum/attribute/skill/skill = GET_ROGUE_ATTRIBUTE(source.associated_skill)
		if(skill)
			examine_list += span_notice("It is used with the [skill.name] skill.")
	if(source.can_parry)
		examine_list += span_notice("Defense: [source.rogue_wdefense()][source.wdefense_wbonus ? " ([source.wdefense] one-handed, [source.wdefense + source.wdefense_wbonus] wielded)" : ""].")
	if(source.max_blade_int)
		examine_list += span_notice("[source.rogue_edge_text()] Sharpness: [round(source.rogue_edge_ratio() * 100)]%.")
	if(source.minstr)
		examine_list += span_notice("It needs [source.minstr] strength to use properly[length(source.gripped_intents) ? " ([max(source.minstr / 2, 1)] wielded)" : ""].")
	if(length(source.alt_grips) && isliving(user))
		var/list/grip_names = list()
		for(var/grip_type in source.alt_grips)
			var/datum/alt_grip/grip = rogue_alt_grip(grip_type)
			grip_names += grip.describe(source, user)
		examine_list += span_notice("Alternate grips: [jointext(grip_names, ", ")]. Right-click it in hand or press Alt Grip to switch.")
	var/datum/special_intent/weapon_special = source.rogue_special()
	if(weapon_special)
		examine_list += weapon_special.get_examine()

/datum/element/rogue_weapon/proc/on_attack(obj/item/source, mob/living/target, mob/living/user, list/modifiers, list/attack_modifiers)
	SIGNAL_HANDLER
	if(!isliving(user))
		return
	var/datum/intent/intent = user.rogue_hand_intent(user.get_held_index_of_item(source))
	if(!intent)
		return
	if(intent.no_attack)
		return COMPONENT_SKIP_ATTACK
	source.rogue_apply_intent(intent)
	MODIFY_ATTACK_FORCE_MULTIPLIER(attack_modifiers, intent.damfactor * rogue_strength_factor(source, user) * user.rogue_rmb_factor("damage_factor"))
	user.changeNext_move(intent.clickcd * user.rogue_rmb_factor("click_factor"))
	user.rogue_mark_in_combat()
	if(intent.releasedrain)
		user.adjust_stamina_loss(intent.releasedrain * user.rogue_rmb_factor("stamina_factor"))
