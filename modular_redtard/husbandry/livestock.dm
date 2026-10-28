/// Ratwood husbandry (code/modules/mob/living/simple_animal/simple_animal.dm, rogue/rogueanimals.dm, rogue/farm/*.dm,
/// rogue/game/saiga.dm, friendly/farm_animals.dm, modular/Creechers/code/trufflepig.dm) on TG's mechanisms: a beast that eats
/// has a food meter that empties as it lives and fills as it grazes or is fed, a fed mother gives birth when a father is near,
/// the young grow up, hens lay and fertile eggs hatch, beasts are tamed by hand-feeding and then obey their friends.
///
/// The meter and its chores run on the beast's Life (SSmobs), so, as in Ratwood (no Life while its AI is off), a beast far from
/// every player neither hungers nor breeds (ai/sleep.dm). What the meter, the mother, the hen and the young do with their legs -
/// walking to held-out food, to the father, to a nest - is one more root of the beast's behavior tree (/datum/bt_node/subtree/rogue_chores).
/mob/living/basic/rockhill
	/// Ratwood tame_chance: the chance a hand-feeding tames the beast, and what every failed one adds (bonus_tame_chance).
	var/rogue_tame_chance = 0
	var/rogue_tame_bonus = 0
	/// Ratwood tame: the beast comes tamed, with no owner yet.
	var/rogue_start_tame = FALSE
	/// Ratwood childtype: the young a mother gives birth to, by weight.
	var/list/rogue_childtype
	/// Ratwood animal_species: the father a mother breeds with (his subtypes too).
	var/rogue_partner_type
	/// Ratwood adult_growth: what the young grows into.
	var/rogue_adult_type
	/// Ratwood breedcd: how often a mother may give birth.
	var/rogue_breed_cooldown = 5 MINUTES
	/// Ratwood egg_type: what a hen lays; eggsFertile: whether her eggs may hatch.
	var/rogue_egg_type
	var/rogue_eggs_fertile = TRUE
	/// Lays in a nest out of what she eats (Ratwood rogue chicken); otherwise a hen lays from the store a feeding gives (Ratwood
	/// friendly chicken).
	var/rogue_lays_in_nest = FALSE
	/// How much of its growing up the young does a second (100 - grown).
	var/rogue_growth_rate = ROGUE_YOUNG_GROWTH
	/// Eats weepvines (Ratwood saiga and goat find_food(), goat Life()).
	var/rogue_eats_vines = FALSE
	/// A taunt is a challenge it answers by charging (Ratwood taunted(): bull, billy goat, saiga buck, swine).
	var/rogue_taunt_angers = FALSE
	/// Whoever tamed it last (Ratwood owner), named when the beast is examined.
	var/datum/weakref/rogue_owner

/// Living livestock (breeding beasts and their young), for the farm animal cap.
GLOBAL_LIST_EMPTY(rogue_livestock)
/// Living hens, for the chicken cap on fertile eggs.
GLOBAL_LIST_EMPTY(rogue_hens)

/mob/living/basic/rockhill/Initialize(mapload)
	. = ..()
	if(rogue_husbandry_enabled())
		RegisterSignal(src, COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZE, PROC_REF(rogue_husbandry_setup))

/// Once every Initialize() of the beast is done (the AI minds of ai/ add the beast's eating after the module's own), gives it
/// what it has of Ratwood husbandry.
/mob/living/basic/rockhill/proc/rogue_husbandry_setup(datum/source)
	SIGNAL_HANDLER
	UnregisterSignal(src, COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZE)
	if(stat == DEAD)
		return
	if(length(rogue_food_types))
		if(!HAS_TRAIT(src, TRAIT_MOB_EATER))
			AddElement(/datum/element/basic_eating, food_types = rogue_food_types)
		AddComponent(/datum/component/rogue_livestock)
	if(rogue_tame_chance > 0)
		AddComponent(/datum/component/tameable/rogue, tame_chance = rogue_tame_chance, bonus_tame_chance = rogue_tame_bonus, unique = FALSE)
	if(rogue_can_saddle && !rogue_adult_type)
		AddComponent(/datum/component/rogue_mount)
	if(rogue_milk_type && gender == FEMALE && !rogue_adult_type)
		AddComponent(/datum/component/udder/rogue, /obj/item/udder/rogue, null, null, rogue_milk_type)
	if(rogue_is_father())
		ADD_TRAIT(src, TRAIT_MOB_BREEDER, ROGUE_HUSBANDRY_TRAIT)
	if(rogue_adult_type)
		AddComponent(/datum/component/growth_and_differentiation, \
			growth_time = null, \
			growth_path = rogue_adult_type, \
			growth_probability = 100, \
			lower_growth_value = rogue_growth_rate, \
			upper_growth_value = rogue_growth_rate, \
			optional_checks = CALLBACK(src, PROC_REF(rogue_can_grow)))
		RegisterSignal(src, COMSIG_MOB_CHANGED_TYPE, PROC_REF(rogue_on_grown))
	if(rogue_is_livestock())
		GLOB.rogue_livestock += src
	RegisterSignal(src, COMSIG_LIVING_ROGUE_GESTURE, PROC_REF(rogue_on_gesture))
	if(rogue_start_tame)
		tamed(null)

/mob/living/basic/rockhill/Destroy()
	GLOB.rogue_livestock -= src
	GLOB.rogue_hens -= src
	rogue_owner = null
	return ..()

/// Counts towards the farm animal cap: a mother, a father, or their young (chicks are hens to be, kept by the chicken cap).
/mob/living/basic/rockhill/proc/rogue_is_livestock()
	if(rogue_is_mother() || HAS_TRAIT(src, TRAIT_MOB_BREEDER))
		return TRUE
	var/mob/living/basic/rockhill/adult = rogue_adult_type
	return adult && !initial(adult.rogue_egg_type)

/// Living livestock on the map (Ratwood GLOB.farm_animals).
/proc/rogue_livestock_count()
	. = 0
	for(var/mob/living/beast as anything in GLOB.rogue_livestock)
		if(beast.stat != DEAD)
			.++

/// Tamed and someone's: it has a friend (TG befriend()) to keep it.
/mob/living/basic/rockhill/proc/rogue_is_kept()
	return HAS_TRAIT(src, TRAIT_TAMED) && length(ai_controller?.blackboard[BB_FRIENDS_LIST])

/// Has someone to fight or flee: a target or anyone it holds a grudge against (Ratwood enemies).
/mob/living/basic/rockhill/proc/rogue_is_angry()
	if(!ai_controller)
		return FALSE
	return ai_controller.blackboard_key_exists(BB_CURRENT_TARGET) || length(ai_controller.blackboard[BB_BASIC_MOB_RETALIATE_LIST])

/// Forgets whoever it was angry with (Ratwood clear_enemies(), LoseTarget()).
/mob/living/basic/rockhill/proc/rogue_calm_down()
	if(!ai_controller)
		return
	ai_controller.clear_blackboard_key(BB_CURRENT_TARGET)
	ai_controller.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
	visible_message(span_notice("[src] calms down."))

/// Sets the beast on someone, as if they had hurt it (Ratwood GiveTarget(), Retaliate()); its mind decides whether it fights or runs.
/mob/living/basic/rockhill/proc/rogue_set_upon(mob/living/target)
	if(!ai_controller || target == src)
		return
	ai_controller.insert_blackboard_key_lazylist(BB_BASIC_MOB_RETALIATE_LIST, target)

/// Sends the beast walking to something for a while (key: BB_ROGUE_LURE_TARGET, BB_ROGUE_NEST_TARGET, BB_BABIES_TARGET), unless it
/// is busy fighting (Ratwood: Goto() and return_action() after a timer, unless stop_automated_movement).
/mob/living/basic/rockhill/proc/rogue_seek(key, atom/target, duration)
	if(!ai_controller || QDELETED(target) || ai_controller.blackboard_key_exists(BB_CURRENT_TARGET))
		return FALSE
	rogue_ensure_chores()
	ai_controller.set_blackboard_key(key, target)
	addtimer(CALLBACK(src, PROC_REF(rogue_drop_chore), key, WEAKREF(target)), duration, TIMER_UNIQUE | TIMER_OVERRIDE)
	return TRUE

/// The walk is over: the key still names the same target, so the beast gave up on it.
/mob/living/basic/rockhill/proc/rogue_drop_chore(key, datum/weakref/target_ref)
	if(ai_controller && ai_controller.blackboard[key] == target_ref?.resolve())
		ai_controller.clear_blackboard_key(key)

/// Puts a root into the beast's mind after the roots nothing may come before: breaking free and, for chores, running away when
/// hurt (rogue_beast_roots() of ai/vibelin_beasts.dm). A mind from one of TG's trees (a single root) gets it in front.
/mob/living/basic/rockhill/proc/rogue_add_mind_root(entry, before_fleeing = FALSE)
	var/datum/ai_controller/mind = ai_controller
	if(!istype(mind) || !length(mind.behavior_nodes))
		return
	var/position = 1
	for(var/index in 1 to length(mind.behavior_nodes))
		var/datum/bt_node/root = mind.behavior_nodes[index]
		if(istype(root, /datum/bt_node/subtree/escape_captivity) || (!before_fleeing && istype(root, /datum/bt_node/subtree/run_away_from_target)))
			position = index + 1
	var/datum/bt_node/node = mind.get_or_build_node(entry)
	if(isnull(node))
		return
	mind.behavior_nodes.Insert(position, node)
	mind.finalize_tree()
	mind.cancel_current_plan()

/// The beast's walks for its chores (food held out, a beckon, the father, a nest) are part of its mind.
/mob/living/basic/rockhill/proc/rogue_ensure_chores()
	if(!ai_controller || (locate(/datum/bt_node/subtree/rogue_chores) in ai_controller.behavior_nodes))
		return
	rogue_add_mind_root(/datum/bt_node/subtree/rogue_chores)

/// The slot TG's pet commands put their behavior into (SUBPLAN_ID_PET_COMMAND), as in TG's tamable trees: after breaking free,
/// before everything else.
/mob/living/basic/rockhill/proc/rogue_ensure_pet_slot()
	if(!ai_controller || LAZYACCESS(ai_controller.override_slots, SUBPLAN_ID_PET_COMMAND))
		return
	rogue_add_mind_root(list(BT_DESC_TYPE = /datum/bt_node/subtree, BT_DESC_OVERRIDE_ID = SUBPLAN_ID_PET_COMMAND), before_fleeing = TRUE)

/// The beast's chores, while it has no one to fight: walk to a lure (held-out food, a beckon), to the father, to a nest.
/datum/bt_node/subtree/rogue_chores

/datum/bt_node/subtree/rogue_chores/New()
	behavior_nodes = list(
		BT_DESC_TYPE = /datum/bt_node/decorator/bb_key_set,
		"key" = BB_CURRENT_TARGET,
		"invert" = TRUE,
		"observer_abort" = BT_ABORT_SELF,
		BT_DESC_CHILDREN = list(list(
			BT_DESC_TYPE = /datum/bt_node/composite/selector,
			BT_DESC_CHILDREN = list(
				rogue_chore_walk(BB_ROGUE_LURE_TARGET, 1),
				list(BT_DESC_TYPE = /datum/bt_node/subtree/make_babies),
				rogue_chore_walk(BB_ROGUE_NEST_TARGET, 0),
			),
		)),
	)
	return ..()

/// A walk to what the key names, taking over from the beast's pastime the moment the key is set, done on arrival.
/proc/rogue_chore_walk(key, distance)
	return list(
		BT_DESC_TYPE = /datum/bt_node/decorator/bb_key_set,
		"key" = key,
		"observer_abort" = BT_ABORT_BOTH,
		BT_DESC_CHILDREN = list(list(
			BT_DESC_TYPE = /datum/bt_node/composite/sequence,
			BT_DESC_CHILDREN = list(
				list(BT_DESC_TYPE = /datum/bt_node/ai_behavior/move_to_target, "target_key" = key, "required_dist" = distance),
				list(BT_DESC_TYPE = /datum/bt_node/ai_behavior/clear_key, "key" = key),
			),
		)),
	)

/// Ratwood's food meter and what hangs on it: hunger and grazing, starvation of the tamed, a mother's season, a hen's eggs.
/datum/component/rogue_livestock
	/// Ratwood food: 0 empty, ROGUE_BEAST_FOOD_MAX full.
	var/food = 0
	/// Ratwood production: grows while the beast has food in it; a nesting hen lays from it.
	var/production = 0
	/// How long the meter has been empty (deciseconds).
	var/starved_for = 0
	/// Wasting away.
	var/starving = FALSE
	/// When a mother next looks for a father (Ratwood next_scan_time; 0 - her first season has not started).
	var/next_breed_scan = 0

/datum/component/rogue_livestock/Initialize()
	if(!istype(parent, /mob/living/basic/rockhill))
		return COMPONENT_INCOMPATIBLE
	var/mob/living/basic/rockhill/beast = parent
	if(beast.rogue_is_mother())
		beast.AddComponent(/datum/component/breed, \
			can_breed_with = typecacheof(beast.rogue_partner_type), \
			breed_timer = beast.rogue_breed_cooldown, \
			baby_paths = beast.rogue_childtype, \
			post_birth = CALLBACK(src, PROC_REF(on_birth)))
		beast.rogue_ensure_chores()
	if(beast.rogue_egg_type)
		GLOB.rogue_hens += beast
		if(beast.rogue_lays_in_nest)
			beast.rogue_ensure_chores()
		else
			beast.AddComponent(/datum/component/egg_layer, beast.rogue_egg_type, list(), list(), EGG_LAYING_MESSAGES, 0, 0, ROGUE_FED_EGGS_MAX, CALLBACK(src, PROC_REF(on_fed_egg_laid)))

/datum/component/rogue_livestock/RegisterWithParent()
	RegisterSignal(parent, COMSIG_LIVING_LIFE, PROC_REF(on_life))
	RegisterSignal(parent, COMSIG_MOB_ATE, PROC_REF(on_ate))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ATOM_RANGED_ITEM_INTERACTION_SECONDARY, PROC_REF(on_food_held_out))

/datum/component/rogue_livestock/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_LIVING_LIFE, COMSIG_MOB_ATE, COMSIG_ATOM_EXAMINE, COMSIG_ATOM_RANGED_ITEM_INTERACTION_SECONDARY))

/// Ratwood simple_animal Life(): the meter empties a point every 2 seconds and production grows as long as there is food in it.
/datum/component/rogue_livestock/proc/on_life(mob/living/basic/rockhill/beast, seconds_per_tick)
	SIGNAL_HANDLER
	if(beast.stat != STABLE)
		return
	var/drain = ROGUE_BEAST_FOOD_PER_SECOND * seconds_per_tick * CONFIG_GET(number/rogue_beast_hunger_rate)
	if(food > 0)
		food = max(food - drain, 0)
		production = min(production + ROGUE_BEAST_FOOD_PER_SECOND * seconds_per_tick, ROGUE_BEAST_PRODUCTION_MAX)
		starved_for = 0
		starving = FALSE
		digest(beast, seconds_per_tick)
	else if(drain > 0)
		starve(beast, seconds_per_tick)
	if(QDELETED(beast) || beast.stat != STABLE)
		return
	if(beast.rogue_eats_vines && food <= ROGUE_BEAST_HUNGRY)
		graze_vines(beast)
	if(beast.rogue_is_mother())
		try_breed(beast)
	if(beast.rogue_egg_type && beast.rogue_lays_in_nest)
		try_nest(beast)

/// Not in Ratwood: a kept beast its keepers leave hungry long enough wastes away; a wild one, or one born tame that nobody has
/// taken in, only stays hungry.
/datum/component/rogue_livestock/proc/starve(mob/living/basic/rockhill/beast, seconds_per_tick)
	if(!beast.rogue_is_kept() || !CONFIG_GET(flag/rogue_beast_starvation))
		return
	starved_for += seconds_per_tick SECONDS
	if(starved_for < ROGUE_BEAST_STARVE_DELAY)
		return
	if(!starving)
		starving = TRUE
		beast.visible_message(span_warning("[beast] looks starved."))
	beast.adjust_brute_loss(beast.maxHealth * ROGUE_BEAST_STARVE_DAMAGE * seconds_per_tick)

/// Whatever it ate, grazing or from a hand (TG's basic_eating): the meter fills (Ratwood +30), a hand-feeding heals, and the
/// beast looks for food again once the meter is down to hungry.
/datum/component/rogue_livestock/proc/on_ate(mob/living/basic/rockhill/beast, atom/eaten, mob/living/feeder)
	SIGNAL_HANDLER
	fill(beast)
	if(feeder)
		beast.heal_overall_damage(rand(ROGUE_FEED_HEAL_MIN, ROGUE_FEED_HEAL_MAX))
	var/datum/component/egg_layer/layer = beast.GetComponent(/datum/component/egg_layer)
	if(layer && layer.eggs_left < ROGUE_FED_EGGS_MAX)
		layer.eggs_left += rand(1, 4)

/// One meal in the meter; grazing (TG's find_food, gated on BB_NEXT_FOOD_EAT) waits until the beast is hungry again.
/datum/component/rogue_livestock/proc/fill(mob/living/basic/rockhill/beast)
	food = min(food + ROGUE_BEAST_MEAL, ROGUE_BEAST_FOOD_MAX)
	starved_for = 0
	starving = FALSE
	var/rate = ROGUE_BEAST_FOOD_PER_SECOND * CONFIG_GET(number/rogue_beast_hunger_rate)
	var/wait = rate > 0 ? (max(food - ROGUE_BEAST_HUNGRY, 0) / rate) SECONDS : 1 HOURS
	beast.ai_controller?.set_blackboard_key(BB_NEXT_FOOD_EAT, world.time + wait)

/// Ratwood saiga and goat find_food(), goat Life(): a hungry beast eats the weepvine it stands on, or steps onto one beside it.
/datum/component/rogue_livestock/proc/graze_vines(mob/living/basic/rockhill/beast)
	if(!isturf(beast.loc) || beast.pulledby || beast.rogue_is_angry())
		return
	var/obj/structure/vine/vine = locate() in beast.loc
	if(vine)
		qdel(vine)
		fill(beast)
		return
	for(var/direction in shuffle(GLOB.alldirs))
		var/turf/step = get_step(beast, direction)
		if(step && (locate(/obj/structure/vine) in step))
			beast.Move(step, direction)
			return

/datum/component/rogue_livestock/proc/on_examine(mob/living/basic/rockhill/beast, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(beast.stat == DEAD || !beast.rogue_is_kept())
		return
	if(starving)
		examine_list += span_warning("[beast.p_They()] look[beast.p_s()] starved.")
	else if(food < ROGUE_BREED_FOOD)
		examine_list += span_notice("[beast.p_They()] look[beast.p_s()] hungry.")

/// Ratwood food intent rmb_ranged() and food_tempted(): right click at a beast from afar with something it eats, and it comes
/// to you for a moment.
/datum/component/rogue_livestock/proc/on_food_held_out(mob/living/basic/rockhill/beast, mob/living/user, obj/item/tool, list/modifiers)
	SIGNAL_HANDLER
	if(!is_type_in_list(tool, beast.rogue_food_types))
		return NONE
	user.visible_message(span_green("[user] beckons [beast] with [tool]."), span_green("I beckon [beast] with [tool]."))
	user.changeNext_move(CLICK_CD_MELEE)
	if(beast.stat == STABLE)
		beast.rogue_seek(BB_ROGUE_LURE_TARGET, user, ROGUE_LURE_TIME)
	return ITEM_INTERACT_SUCCESS
