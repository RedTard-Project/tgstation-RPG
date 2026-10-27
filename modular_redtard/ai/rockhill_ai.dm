/// Minds for the Ratwood beasts and monsters the porter brings over (rockhill/ported/mobs.dm), on TG's behavior-tree AI with
/// Vibelin's idea on top: a beast fights with its own intents, so every blow is a bite, claw or hack with that intent's
/// edge, piercing and sound, and armor answers it as it answers a weapon (Vibelin basic_melee_attack picks an intent per
/// blow from the mob's list).
///
/// The mind follows Ratwood's class of the creature: /hostile/rogue hunts whatever it sees, /hostile/retaliate fights
/// back when attacked and hunts if Ratwood marks it aggressive, pets and small critters run when attacked. A beast with
/// Ratwood's retreat_health runs off when that hurt and comes back once it has healed past it.
/mob/living/basic/rockhill
	/// Ratwood base_intents: the natural attacks one is picked from for every blow.
	var/list/rogue_mob_intents
	/// Ratwood aggressive: a retaliating beast that also hunts on sight.
	var/rogue_aggressive = FALSE
	/// Ratwood retreat_health: the share of health below which it flees.
	var/rogue_retreat_health = 0
	/// Tier of armor the current blow goes through (the intent's penfactor), read by rogue_attack_penetration().
	var/rogue_attack_pen = ROGUE_PEN_NONE

/mob/living/simple_animal/hostile/rogue
	ai_controller = /datum/ai_controller/basic_controller/simple/simple_hostile

/mob/living/simple_animal/hostile/retaliate
	ai_controller = /datum/ai_controller/basic_controller/simple/simple_retaliate

/mob/living/simple_animal/pet
	ai_controller = /datum/ai_controller/basic_controller/simple/simple_skittish

/mob/living/simple_animal/butterfly
	ai_controller = /datum/ai_controller/basic_controller/simple/simple_skittish

/mob/living/simple_animal/chicken
	ai_controller = /datum/ai_controller/basic_controller/simple/simple_skittish

/// TG's hunting and retaliating minds with TG's run-away subtree in front: the trees tick their roots in order, so a beast
/// that ai_flee_while_injured marks as fleeing runs from its target, and fights otherwise. Only beasts with Ratwood's
/// retreat_health get these: without the element nothing ever tells the subtree to stop.
/datum/ai_controller/basic_controller/simple/rogue_hostile_fleeing
	behavior_tree_json = null
	behavior_nodes = list(
		/datum/bt_node/subtree/escape_captivity,
		/datum/bt_node/subtree/run_away_from_target,
		/datum/bt_node/subtree/simple_hostile_combat,
	)

/datum/ai_controller/basic_controller/simple/rogue_retaliate_fleeing
	behavior_tree_json = null
	behavior_nodes = list(
		/datum/bt_node/subtree/escape_captivity,
		/datum/bt_node/subtree/run_away_from_target,
		/datum/bt_node/subtree/simple_retaliate_combat,
	)
	ai_traits = DEFAULT_AI_FLAGS | STOP_MOVING_WHEN_PULLED

/mob/living/basic/rockhill/Initialize(mapload)
	if(rogue_aggressive && ai_controller == /datum/ai_controller/basic_controller/simple/simple_retaliate)
		ai_controller = /datum/ai_controller/basic_controller/simple/simple_hostile
	if(rogue_retreat_health > 0)
		switch(ai_controller)
			if(/datum/ai_controller/basic_controller/simple/simple_hostile)
				ai_controller = /datum/ai_controller/basic_controller/simple/rogue_hostile_fleeing
			if(/datum/ai_controller/basic_controller/simple/simple_retaliate)
				ai_controller = /datum/ai_controller/basic_controller/simple/rogue_retaliate_fleeing
	. = ..()
	if(!ai_controller)
		return
	AddElement(/datum/element/ai_retaliate)
	if(istype(ai_controller, /datum/ai_controller/basic_controller/simple/rogue_hostile_fleeing) || istype(ai_controller, /datum/ai_controller/basic_controller/simple/rogue_retaliate_fleeing))
		AddElement(/datum/element/ai_flee_while_injured, max(ROGUE_BEAST_FLEE_STOP, rogue_retreat_health), rogue_retreat_health)

/mob/living/basic/rockhill/early_melee_attack(atom/target, list/modifiers, ignore_cooldown = FALSE)
	. = ..()
	if(. == BASIC_MOB_CONTINUE_ATTACK_CHAIN)
		rogue_ready_intent()

/// Takes up one of the beast's intents for the coming blow: its edge or point, how far it bites through armor, its sound.
/mob/living/basic/rockhill/proc/rogue_ready_intent()
	if(!length(rogue_mob_intents))
		return
	var/datum/intent/intent = rogue_intent(pick(rogue_mob_intents))
	if(!intent)
		return
	sharpness = rogue_armor_sharpness(intent.item_d_type)
	rogue_attack_pen = intent.penfactor
	if(length(intent.hitsound))
		attack_sound = pick(intent.hitsound)

/// The TG sharpness that makes armor take a blow of this damage kind (the reverse of rogue_damage_armor_type()).
/proc/rogue_armor_sharpness(armor_type)
	switch(armor_type)
		if(ROGUE_ARMOR_SLASH)
			return SHARP_EDGED
		if(ROGUE_ARMOR_STAB, ROGUE_ARMOR_PIERCING)
			return SHARP_POINTY
	return NONE
