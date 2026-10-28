/// How Ratwood's creatures fight with more than their teeth, on TG's behavior trees: a creature that shoots keeps its distance
/// and shoots (Ratwood basic_ranged_attack_subtree and spacing/ranged: skeleton archers, deep one spitters and devouts, imps,
/// infernal watchers, the fiend) or closes in to strike and shoots only from afar (the colossus, the mire lurker); a creature
/// with special abilities (pve/abilities.dm, pve/minotaur.dm) uses the one the moment calls for before every blow.
///
/// The fight is TG's simple_hostile_combat / simple_retaliate_combat (a parallel of the fight and the search for a foe) with a
/// selector of ability, blow and shot instead of the blow alone, and a mover that keeps the shooter's distance (TG
/// maintain_distance, walking in when it lost sight of the foe) instead of TG's walk to the foe. The ranged attack itself is
/// TG's ranged_attacks component on the creature, fed with the projectiles of pve/projectiles.dm.
///
/// Such creatures get the rogue_beast mind of ai/vibelin_beasts.dm; this file gives it the fight and the spiders' cocoons,
/// nests and webs (rogue_pve_urgent_roots(), rogue_pve_idle_roots()). Minds sleep as before (ai/sleep.dm): nothing here runs
/// without a player near.

/mob/living/basic/rockhill
	/// Ratwood projectiletype: what it shoots; null - it does not shoot.
	var/rogue_pve_shot
	/// Ratwood allowed_projectile_types: it shoots one of these, picked for every shot (overrides rogue_pve_shot).
	var/list/rogue_pve_shots
	/// Ratwood projectilesound.
	var/rogue_pve_shot_sound
	/// Name of the value of mechanics/values.dm with the time between its shots (Ratwood ranged_cooldown_time).
	var/rogue_pve_shot_cooldown
	/// ROGUE_PVE_SHOOTER keeps its distance and only shoots; ROGUE_PVE_SKIRMISHER walks up to strike and shoots from afar.
	var/rogue_pve_shot_style = ROGUE_PVE_SHOOTER
	/// The distance a shooter keeps (Ratwood retreat_distance/minimum_distance, spacing/ranged 3-6).
	var/rogue_pve_keep_min = 3
	var/rogue_pve_keep_max = 6
	/// Its special abilities (/datum/action/cooldown/mob_cooldown subtypes with rogue_ai_wants()); granted at spawn, so a
	/// player in its body has them too (Ratwood: "players get a spell").
	var/list/rogue_pve_ability_types
	/// The abilities it was granted.
	var/list/rogue_pve_abilities
	/// Something happens when its blow lands (rogue_pve_blow_landed(): the behemoth's throw, the hell hound's fire).
	var/rogue_pve_blow_effects = FALSE
	/// Walks through webs (Ratwood TRAIT_WEBWALK of the spiders' kin).
	var/rogue_pve_webwalker = FALSE

/mob/living/basic/rockhill/Initialize(mapload)
	. = ..()
	if(rogue_pve_webwalker)
		ADD_TRAIT(src, TRAIT_WEBWALK, ROGUE_PVE_TRAIT)
		ADD_TRAIT(src, TRAIT_WEB_SURFER, ROGUE_PVE_TRAIT)
	if(rogue_pve_shoots())
		AddComponent(/datum/component/ranged_attacks, \
			projectile_type = rogue_pve_shot || rogue_pve_shots[1], \
			projectile_sound = rogue_pve_shot_sound || 'sound/effects/magic/fireball.ogg', \
			cooldown_time = rogue_pve_shot_cooldown ? rogue_value(rogue_pve_shot_cooldown) : 3 SECONDS)
		if(length(rogue_pve_shots))
			RegisterSignal(src, COMSIG_BASICMOB_PRE_ATTACK_RANGED, PROC_REF(rogue_pve_pick_shot))
		ai_controller?.set_blackboard_key(BB_RANGED_SKIRMISH_MIN_DISTANCE, rogue_pve_keep_min)
		ai_controller?.set_blackboard_key(BB_RANGED_SKIRMISH_MAX_DISTANCE, rogue_pve_keep_max)
	for(var/ability_type in rogue_pve_ability_types)
		var/datum/action/cooldown/mob_cooldown/ability = new ability_type(src)
		ability.Grant(src)
		LAZYADD(rogue_pve_abilities, ability)
	if(rogue_pve_blow_effects)
		RegisterSignal(src, COMSIG_HOSTILE_POST_ATTACKINGTARGET, PROC_REF(rogue_pve_on_blow))

/mob/living/basic/rockhill/Destroy()
	QDEL_LAZYLIST(rogue_pve_abilities)
	return ..()

/mob/living/basic/rockhill/proc/rogue_pve_shoots()
	return rogue_pve_shot || length(rogue_pve_shots)

/// The rogue_beast mind (ai/vibelin_beasts.dm) is needed for a fight with shots or abilities, and for a spider's life.
/mob/living/basic/rockhill/proc/rogue_pve_needs_mind()
	return rogue_pve_shoots() || length(rogue_pve_ability_types) || rogue_pve_has_chores()

/// The spider's pastimes of pve/spiders.dm: wrapping the fallen, living in a nest, spinning webs.
/mob/living/basic/rockhill/proc/rogue_pve_has_chores()
	return FALSE

/// Ratwood deep one devout Shoot(): another of its projectiles for every shot.
/mob/living/basic/rockhill/proc/rogue_pve_pick_shot(datum/source, atom/target, modifiers)
	SIGNAL_HANDLER
	var/datum/component/ranged_attacks/shooting = GetComponent(/datum/component/ranged_attacks)
	if(shooting)
		shooting.projectile_type = pick(rogue_pve_shots)

/mob/living/basic/rockhill/proc/rogue_pve_on_blow(datum/source, atom/target, result)
	SIGNAL_HANDLER
	if(result && isliving(target) && stat != DEAD)
		rogue_pve_blow_landed(target)

/// Called when the creature's blow lands on someone (rogue_pve_blow_effects).
/mob/living/basic/rockhill/proc/rogue_pve_blow_landed(mob/living/target)
	return

/// Called while the creature fights, before it picks an ability (the minotaur's rage grows here).
/mob/living/basic/rockhill/proc/rogue_pve_fight_tick(atom/target)
	return

/// The watcher of the creature's pastimes: hunters look for prey, the others for whoever hurt them.
/mob/living/basic/rockhill/proc/rogue_pve_watcher(hunts)
	return hunts ? /datum/bt_node/ai_behavior/acquire_target/update_combat_targets : /datum/bt_node/ai_behavior/acquire_target/target_from_retaliate_list

/// Roots of the mind that come before the pastimes of its way of life (pve/spiders.dm: wrapping the fallen into cocoons).
/mob/living/basic/rockhill/proc/rogue_pve_urgent_roots(hunts)
	return list()

/// Roots of the mind that come after the pastimes of its way of life (pve/spiders.dm: the nest, the webs).
/mob/living/basic/rockhill/proc/rogue_pve_idle_roots(hunts)
	return list()

/// The creature's fight: TG's own for a plain fighter, else TG's with abilities, shots and the shooter's distance.
/mob/living/basic/rockhill/proc/rogue_pve_combat(hunts)
	if(!rogue_pve_shoots() && !length(rogue_pve_ability_types))
		return hunts ? /datum/bt_node/subtree/simple_hostile_combat : /datum/bt_node/subtree/simple_retaliate_combat
	var/shooter = rogue_pve_shoots() && rogue_pve_shot_style == ROGUE_PVE_SHOOTER
	var/list/actions = list()
	if(length(rogue_pve_ability_types))
		actions += list(list(
			BT_DESC_TYPE = /datum/bt_node/ai_behavior/rogue_pve_ability,
			"target_key" = BB_CURRENT_TARGET,
		))
	if(!shooter)
		actions += list(list(
			BT_DESC_TYPE = /datum/bt_node/ai_behavior/basic_melee_attack,
			"target_key" = BB_CURRENT_TARGET,
			"targeting_strategy" = BB_TARGETING_STRATEGY,
			"hiding_location_key" = BB_CURRENT_TARGET_HIDING_LOCATION,
		))
	if(rogue_pve_shoots())
		actions += list(list(
			BT_DESC_TYPE = /datum/bt_node/ai_behavior/basic_ranged_attack/rogue_pve,
			"target_key" = BB_CURRENT_TARGET,
			"targeting_strategy" = BB_TARGETING_STRATEGY,
			"hiding_location_key" = BB_CURRENT_TARGET_HIDING_LOCATION,
			"min_range" = (shooter ? 0 : 2),
		))
	var/list/movement
	if(shooter)
		movement = list(
			BT_DESC_TYPE = /datum/bt_node/ai_behavior/maintain_distance/rogue_pve,
			"target_key" = BB_CURRENT_TARGET,
		)
	else
		movement = list(
			BT_DESC_TYPE = /datum/bt_node/ai_behavior/move_to_target,
			"target_key" = BB_CURRENT_TARGET,
			"required_dist" = 1,
			"finish_on_arrival" = FALSE,
		)
	var/list/fight = list(
		BT_DESC_TYPE = /datum/bt_node/composite/parallel,
		"failure_policy" = BT_PARALLEL_FAILURE_ANY,
		"success_policy" = BT_PARALLEL_SUCCESS_CHILD_ONE,
		"repeat_secondary" = TRUE,
		"finish_on_primary" = TRUE,
		BT_DESC_CHILDREN = list(
			list(
				BT_DESC_TYPE = /datum/bt_node/composite/subplan,
				"success_policy" = BT_SUBPLAN_LOOP_ON_SUCCESS,
				"failure_policy" = BT_SUBPLAN_LOOP_ON_FAILURE,
				BT_DESC_CHILDREN = list(list(
					BT_DESC_TYPE = /datum/bt_node/composite/selector,
					BT_DESC_CHILDREN = actions,
				)),
			),
			movement,
		),
	)
	return list(
		BT_DESC_TYPE = /datum/bt_node/composite/parallel,
		"failure_policy" = BT_PARALLEL_FAILURE_CHILD_ONE,
		"success_policy" = BT_PARALLEL_SUCCESS_CHILD_ONE,
		"repeat_secondary" = TRUE,
		"repeat_secondary_delay" = BASIC_MOB_FIND_TARGET_RATE,
		"finish_on_primary" = TRUE,
		BT_DESC_CHILDREN = list(
			list(
				BT_DESC_TYPE = /datum/bt_node/composite/selector,
				BT_DESC_CHILDREN = list(
					list(
						BT_DESC_TYPE = /datum/bt_node/decorator/bb_key_set,
						"key" = BB_CURRENT_TARGET,
						"observer_abort" = BT_ABORT_BOTH,
						BT_DESC_CHILDREN = list(fight),
					),
					list(BT_DESC_TYPE = /datum/bt_node/subtree/random_walk),
				),
			),
			list(
				BT_DESC_TYPE = rogue_pve_watcher(hunts),
				"target_key" = BB_CURRENT_TARGET,
				"targeting_strategy" = BB_TARGETING_STRATEGY,
				"hiding_location_key" = BB_CURRENT_TARGET_HIDING_LOCATION,
			),
		),
	)

/// Uses one of the creature's special abilities that is ready and that the moment calls for (its rogue_ai_wants()), as
/// Ratwood's monsters do between their blows (MoveToTarget() with a cooldown per ability).
/datum/bt_node/ai_behavior/rogue_pve_ability
	var/target_key
	/// The ability being used.
	var/datum/action/cooldown/mob_cooldown/using

/datum/bt_node/ai_behavior/rogue_pve_ability/perform(seconds_per_tick, datum/ai_controller/controller)
	var/async_flags = handle_async()
	if(async_flags)
		return async_flags
	var/mob/living/basic/rockhill/beast = controller.pawn
	var/atom/target = controller.blackboard[target_key]
	if(!istype(beast) || QDELETED(target))
		return AI_BEHAVIOR_INSTANT | AI_BEHAVIOR_FAILED
	beast.rogue_pve_fight_tick(target)
	using = null
	for(var/datum/action/cooldown/mob_cooldown/ability as anything in beast.rogue_pve_abilities)
		if(ability.IsAvailable() && ability.rogue_ai_wants(beast, target))
			using = ability
			break
	if(!using)
		return AI_BEHAVIOR_INSTANT | AI_BEHAVIOR_FAILED
	beast.face_atom(target)
	return start_async()

/datum/bt_node/ai_behavior/rogue_pve_ability/perform_async(datum/ai_controller/controller)
	var/datum/action/cooldown/mob_cooldown/ability = using
	var/atom/target = controller.blackboard[target_key]
	var/result = !QDELETED(ability) && !QDELETED(target) && ability.Trigger(target = target)
	if(!async_still_valid())
		return
	finish_async(result ? AI_BEHAVIOR_SUCCEEDED : AI_BEHAVIOR_FAILED)

/datum/bt_node/ai_behavior/rogue_pve_ability/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	using = null

/// Whether a creature's mind uses this ability on the target now. TG's own abilities are not used by these minds.
/datum/action/cooldown/mob_cooldown/proc/rogue_ai_wants(mob/living/basic/rockhill/beast, atom/target)
	return FALSE

/// TG's shot with Ratwood's check_friendly_fire, and a skirmisher strikes rather than shoots up close.
/datum/bt_node/ai_behavior/basic_ranged_attack/rogue_pve
	avoid_friendly_fire = TRUE
	max_range = ROGUE_PVE_SIGHT
	/// Below this distance it does not shoot.
	var/min_range = 0

/datum/bt_node/ai_behavior/basic_ranged_attack/rogue_pve/perform(seconds_per_tick, datum/ai_controller/controller)
	var/atom/target = controller.blackboard[target_key]
	if(min_range && !QDELETED(target) && get_dist(controller.pawn, target) < min_range)
		return AI_BEHAVIOR_INSTANT | AI_BEHAVIOR_FAILED
	return ..()

/// TG's maintain_distance that does not give up when the foe is out of sight: the shooter walks in until it sees it again
/// (Ratwood spacing/ranged need_los: "simple ranged mobs will seek out their targets").
/datum/bt_node/ai_behavior/maintain_distance/rogue_pve

/datum/bt_node/ai_behavior/maintain_distance/rogue_pve/setup(datum/ai_controller/controller)
	if(!isliving(controller.blackboard[target_key]))
		return FALSE
	RegisterSignal(controller.pawn, COMSIG_MOB_AI_MOVEMENT_FAILED, PROC_REF(on_movement_failed))
	return TRUE

/datum/bt_node/ai_behavior/maintain_distance/rogue_pve/perform(seconds_per_tick, datum/ai_controller/controller)
	var/atom/target = controller.blackboard[target_key]
	if(!movement_failed && !QDELETED(target) && !can_see(controller.pawn, target, ROGUE_PVE_SIGHT))
		controller.change_ai_movement_type(initial(controller.ai_movement))
		controller.ai_movement.start_moving_towards(controller, target, 1)
		return AI_BEHAVIOR_INSTANT
	return ..()

/// A creature's special hits someone: damage on a body part through the victim's armor, as a blow of this edge and armor
/// piercing (the module's armor reads a creature's rogue_attack_pen, rogue_attack_penetration()). Not armored: the damage
/// goes straight to the body, as Ratwood's and Vibelin's throws and stomps deal it (adjustBruteLoss()).
/proc/rogue_pve_strike(mob/living/attacker, mob/living/victim, damage, zone, sharpness = NONE, pen = ROGUE_PEN_NONE, damagetype = BRUTE, armored = TRUE)
	if(QDELETED(victim) || damage <= 0)
		return 0
	zone = zone || victim.get_random_valid_zone()
	if(!armored)
		return victim.apply_damage(damage, damagetype, zone, sharpness = sharpness, attack_direction = attacker ? get_dir(attacker, victim) : null)
	var/mob/living/basic/rockhill/beast = istype(attacker, /mob/living/basic/rockhill) ? attacker : null
	var/old_pen = beast?.rogue_attack_pen
	if(beast)
		beast.rogue_attack_pen = pen
	. = victim.apply_damage(damage, damagetype, zone, victim.run_armor_check(zone, MELEE, silent = TRUE), sharpness = sharpness, attack_direction = attacker ? get_dir(attacker, victim) : null, attacking_item = attacker)
	if(beast)
		beast.rogue_attack_pen = old_pen

/// Someone the creature's special should hurt: alive, not the creature, not of its kind.
/proc/rogue_pve_is_foe(mob/living/attacker, mob/living/other)
	if(!isliving(other) || other == attacker || other.stat == DEAD)
		return FALSE
	return !attacker || !attacker.faction_check_atom(other)

/// A mark on a tile where a creature's special is about to land (Ratwood's markers, the module's telegraph sprite).
/obj/effect/temp_visual/rogue_pve_mark
	icon = ROGUE_PVE_MARK_ICON
	icon_state = "warning"
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_GAME_PLANE
	randomdir = FALSE
	duration = 1 SECONDS

/obj/effect/temp_visual/rogue_pve_mark/Initialize(mapload, set_duration)
	if(set_duration)
		duration = set_duration
	return ..()

/// The flash of a special landing on a tile.
/obj/effect/temp_visual/rogue_pve_mark/strike
	icon = ROGUE_PVE_STRIKE_ICON
	icon_state = "strike"
	duration = 0.5 SECONDS
