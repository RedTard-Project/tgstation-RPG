/// What Vibelin's beasts do besides fighting (Vibelin code/datums/ai/controllers: volf, saiga, gote, pig, frog, bat,
/// troll, spider, mole, big_rat, bear, mimic, headless), on TG's behavior trees for the Ratwood beasts of
/// rockhill/ported/mobs.dm: hunters eat the dead after a fight (find_dead_bodies, eat_dead_body), herd beasts graze on
/// what they eat (find_food, Ratwood's food_type) and fight back or run when attacked, small prey runs from whatever
/// comes near, the frog swims, the bog troll lies in wait (no_target_hide) and springs out on whoever comes close.
/// Every pastime gives way the moment the beast has someone to fight.
///
/// Not ported: Vibelin's hunger meter (a meal sates for ROGUE_BEAST_MEAL_COOLDOWN instead), breeding, taming and pet
/// commands, spider nests and webs, the mirespider's cocoons, ranged attacks and the special abilities (troll throws and
/// slams, fiend, behemoth, colossus, glimmerwing, dryad), the minotaur's rage, the truffle pig's sniffing.

/// A hunter eats the dead; herd beasts graze and fight back; shy ones graze and run when attacked; prey runs from all.
#define ROGUE_BEAST_HUNTER "hunter"
#define ROGUE_BEAST_HERD "herd"
#define ROGUE_BEAST_SHY "shy"
#define ROGUE_BEAST_PREY "prey"
#define ROGUE_BEAST_SWIMMER "swimmer"
#define ROGUE_BEAST_AMBUSHER "ambusher"

#define BB_ROGUE_BEAST_CORPSE "rogue_beast_corpse"
#define BB_ROGUE_BEAST_NEXT_MEAL "rogue_beast_next_meal"
/// How long a meal sates a hunter (Vibelin's hunger refills over time).
#define ROGUE_BEAST_MEAL_COOLDOWN (3 MINUTES)
/// How long a beast tears at a corpse for every limb (Vibelin's do_after).
#define ROGUE_BEAST_BITE_TIME (10 SECONDS)

/mob/living/basic/rockhill
	/// Vibelin's way of life for the beast (ROGUE_BEAST_*); null keeps TG's plain fighting mind.
	var/rogue_beast_kind
	/// It hunts on sight rather than fighting back (Ratwood's /hostile/rogue, or aggressive).
	var/rogue_hunts = FALSE
	/// What it grazes on (Ratwood food_type).
	var/list/rogue_food_types
	/// The bog troll's hiding: its sprite lying in wait, and the flicks of going under and springing out.
	var/rogue_hide_state
	var/rogue_hiding_flick
	var/rogue_ambush_flick

/// A pastime the beast keeps up while it has no one to fight (grazing, swimming, lying in wait, a meal): a watcher looks
/// for a fight the whole time, and the pastime gives way the moment it finds one.
/proc/rogue_beast_pastime(list/pastime, watcher, list/secondaries, vision_range)
	var/list/children = list(pastime)
	if(secondaries)
		children += secondaries
	var/list/watch = list(
		BT_DESC_TYPE = watcher,
		"target_key" = BB_BASIC_MOB_CURRENT_TARGET,
		"targeting_strategy" = BB_TARGETING_STRATEGY,
		"hiding_location_key" = BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION,
	)
	if(vision_range)
		watch["vision_range"] = vision_range
	children += list(watch)
	return list(
		BT_DESC_TYPE = /datum/bt_node/decorator/bb_key_set,
		"key" = BB_BASIC_MOB_CURRENT_TARGET,
		"invert" = TRUE,
		"observer_abort" = BT_ABORT_BOTH,
		BT_DESC_CHILDREN = list(list(
			BT_DESC_TYPE = /datum/bt_node/composite/parallel,
			"finish_on_primary" = TRUE,
			"repeat_secondary" = TRUE,
			"repeat_secondary_delay" = 1 SECONDS,
			BT_DESC_CHILDREN = children,
		)),
	)

/// Vibelin's find_dead_bodies and eat_dead_body: a sated hunter goes for a body it sees and tears it apart limb by limb.
/datum/bt_node/subtree/rogue_eat_corpse
	/// What looks for a fight meanwhile: hunters look for prey, others for whoever hurt them.
	var/watcher = /datum/bt_node/ai_behavior/acquire_target/update_combat_targets

/datum/bt_node/subtree/rogue_eat_corpse/New()
	behavior_nodes = list(
		BT_DESC_TYPE = /datum/bt_node/decorator/cooldown,
		"cooldown_key" = BB_ROGUE_BEAST_NEXT_MEAL,
		"cooldown_duration" = ROGUE_BEAST_MEAL_COOLDOWN,
		BT_DESC_CHILDREN = list(rogue_beast_pastime(list(
			BT_DESC_TYPE = /datum/bt_node/composite/sequence,
			BT_DESC_CHILDREN = list(
				list(
					BT_DESC_TYPE = /datum/bt_node/ai_behavior/acquire_target,
					"target_key" = BB_ROGUE_BEAST_CORPSE,
					"targeting_strategy" = /datum/targeting_strategy/dead_mob/not_pulled,
					"target_source" = /datum/target_source/oview_living,
					"vision_range" = 9,
				),
				list(
					BT_DESC_TYPE = /datum/bt_node/ai_behavior/move_to_target,
					"target_key" = BB_ROGUE_BEAST_CORPSE,
					"required_dist" = 1,
				),
				list(
					BT_DESC_TYPE = /datum/bt_node/ai_behavior/rogue_eat_corpse,
					"target_key" = BB_ROGUE_BEAST_CORPSE,
				),
			),
		), watcher)),
	)
	return ..()

/datum/bt_node/subtree/rogue_eat_corpse/retaliate
	watcher = /datum/bt_node/ai_behavior/acquire_target/target_from_retaliate_list

/// Vibelin's find_food for herd beasts: wanders and eats what it eats when it comes across it (TG's find_food and
/// move_to_and_eat, as TG's cows graze).
/datum/bt_node/subtree/rogue_graze
	var/watcher = /datum/bt_node/ai_behavior/acquire_target/target_from_retaliate_list

/datum/bt_node/subtree/rogue_graze/New()
	behavior_nodes = rogue_beast_pastime(list(
		BT_DESC_TYPE = /datum/bt_node/composite/subplan,
		"success_policy" = BT_SUBPLAN_LOOP_ON_SUCCESS,
		"failure_policy" = BT_SUBPLAN_LOOP_ON_FAILURE,
		BT_DESC_CHILDREN = list(list(
			BT_DESC_TYPE = /datum/bt_node/composite/selector,
			BT_DESC_CHILDREN = list(
				list(BT_DESC_TYPE = /datum/bt_node/subtree/move_to_and_eat),
				list(BT_DESC_TYPE = /datum/bt_node/subtree/random_walk),
			),
		)),
	), watcher, list(list(BT_DESC_TYPE = /datum/bt_node/subtree/find_food)))
	return ..()

/datum/bt_node/subtree/rogue_graze/shy
	watcher = /datum/bt_node/ai_behavior/acquire_target/target_from_retaliate_list/nearest

/datum/bt_node/subtree/rogue_graze/hunting
	watcher = /datum/bt_node/ai_behavior/acquire_target/update_combat_targets

/// Vibelin's go_for_swim: the frog paddles about until something comes near.
/datum/bt_node/subtree/rogue_swim

/datum/bt_node/subtree/rogue_swim/New()
	behavior_nodes = rogue_beast_pastime(list(BT_DESC_TYPE = /datum/bt_node/subtree/go_for_swim), /datum/bt_node/ai_behavior/acquire_target/update_combat_targets/nearest)
	return ..()

/// Vibelin's no_target_hide: the bog troll sinks into hiding and springs out on whoever comes within a few steps.
/datum/bt_node/subtree/rogue_lie_in_wait

/datum/bt_node/subtree/rogue_lie_in_wait/New()
	behavior_nodes = rogue_beast_pastime(list(BT_DESC_TYPE = /datum/bt_node/ai_behavior/rogue_lie_in_wait), /datum/bt_node/ai_behavior/acquire_target/update_combat_targets, vision_range = 3)
	return ..()

/// Tears at the corpse: a limb for every ROGUE_BEAST_BITE_TIME, the body gone at the end (Vibelin eat_dead_body).
/datum/bt_node/ai_behavior/rogue_eat_corpse
	time_between_perform = ROGUE_BEAST_BITE_TIME
	var/target_key
	/// The first round only starts the meal: the first limb comes off a bite time later.
	var/started = FALSE

/datum/bt_node/ai_behavior/rogue_eat_corpse/setup(datum/ai_controller/controller)
	var/mob/living/corpse = controller.blackboard[target_key]
	started = FALSE
	return isliving(corpse) && !QDELETED(corpse) && corpse.stat == DEAD

/datum/bt_node/ai_behavior/rogue_eat_corpse/perform(seconds_per_tick, datum/ai_controller/controller)
	var/mob/living/beast = controller.pawn
	var/mob/living/corpse = controller.blackboard[target_key]
	if(QDELETED(corpse))
		return AI_BEHAVIOR_SUCCEEDED
	if(corpse.stat != DEAD || !beast.Adjacent(corpse))
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED
	beast.face_atom(corpse)
	if(!started)
		started = TRUE
		beast.visible_message(span_danger("[beast] starts to rip apart [corpse]!"))
		return AI_BEHAVIOR_DELAY
	if(beast.attack_sound)
		playsound(beast, beast.attack_sound, 100, TRUE, -1)
	if(rogue_bite_off(corpse))
		return AI_BEHAVIOR_DELAY
	return AI_BEHAVIOR_SUCCEEDED

/// Bites off a limb, the head last; a body with none left, or a beast's carcass, is torn to pieces. TRUE while
/// something is left to eat.
/datum/bt_node/ai_behavior/rogue_eat_corpse/proc/rogue_bite_off(mob/living/corpse)
	var/mob/living/carbon/body = corpse
	if(iscarbon(body))
		for(var/zone in list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_HEAD))
			var/obj/item/bodypart/limb = body.get_bodypart(zone)
			if(limb?.dismember())
				return TRUE
	corpse.gib(DROP_ALL_REMAINS)
	return FALSE

/datum/bt_node/ai_behavior/rogue_eat_corpse/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	controller.clear_blackboard_key(target_key)

/// Lies in wait, hidden, until the watcher finds someone: then springs out.
/datum/bt_node/ai_behavior/rogue_lie_in_wait
	time_between_perform = 2 SECONDS

/datum/bt_node/ai_behavior/rogue_lie_in_wait/setup(datum/ai_controller/controller)
	var/mob/living/basic/rockhill/beast = controller.pawn
	if(!istype(beast) || !beast.rogue_hide_state)
		return FALSE
	beast.rogue_hide()
	return TRUE

/datum/bt_node/ai_behavior/rogue_lie_in_wait/perform(seconds_per_tick, datum/ai_controller/controller)
	return AI_BEHAVIOR_DELAY

/datum/bt_node/ai_behavior/rogue_lie_in_wait/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	var/mob/living/basic/rockhill/beast = controller.pawn
	if(istype(beast))
		beast.rogue_ambush()

/mob/living/basic/rockhill/proc/rogue_hide()
	if(rogue_hiding_flick)
		flick(rogue_hiding_flick, src)
	icon_state = rogue_hide_state

/mob/living/basic/rockhill/proc/rogue_ambush()
	if(icon_state != rogue_hide_state || stat == DEAD)
		return
	if(rogue_ambush_flick)
		flick(rogue_ambush_flick, src)
	icon_state = icon_living

/// TG's fighting minds with Vibelin's pastimes in front, picked for the beast (rogue_beast_roots()).
/datum/ai_controller/basic_controller/simple/rogue_beast
	behavior_tree_json = null
	behavior_nodes = list(
		/datum/bt_node/subtree/escape_captivity,
		/datum/bt_node/subtree/simple_retaliate_combat,
	)

/datum/ai_controller/basic_controller/simple/rogue_beast/New(atom/new_pawn)
	var/mob/living/basic/rockhill/beast = new_pawn
	if(istype(beast))
		behavior_nodes = beast.rogue_beast_roots()
	return ..()

/// A beast with a way of life gets the mind that has it; what it eats goes to TG's eating and grazing, and Ratwood's
/// retreat_health to TG's fleeing when hurt.
/mob/living/basic/rockhill/Initialize(mapload)
	if(rogue_beast_kind)
		rogue_hunts = rogue_aggressive || (ai_controller in list(/datum/ai_controller/basic_controller/simple/simple_hostile, /datum/ai_controller/basic_controller/simple/rogue_hostile_fleeing))
		ai_controller = /datum/ai_controller/basic_controller/simple/rogue_beast
	. = ..()
	if(!istype(ai_controller, /datum/ai_controller/basic_controller/simple/rogue_beast))
		return
	if(rogue_retreat_health > 0)
		AddElement(/datum/element/ai_flee_while_injured, max(ROGUE_BEAST_FLEE_STOP, rogue_retreat_health), rogue_retreat_health)
	if(length(rogue_food_types))
		AddElement(/datum/element/basic_eating, food_types = rogue_food_types)
		ai_controller.set_blackboard_key(BB_BASIC_FOODS, typecacheof(rogue_food_types))

/// The beast's mind, highest priority first: break free, run when badly hurt, its pastime, then fighting as it fights
/// (hunting, fighting back, or running from whoever hurt it or from anything near).
/mob/living/basic/rockhill/proc/rogue_beast_roots()
	var/hunts = rogue_hunts
	. = list(/datum/bt_node/subtree/escape_captivity)
	if(rogue_retreat_health > 0)
		. += /datum/bt_node/subtree/run_away_from_target
	switch(rogue_beast_kind)
		if(ROGUE_BEAST_HUNTER)
			. += hunts ? /datum/bt_node/subtree/rogue_eat_corpse : /datum/bt_node/subtree/rogue_eat_corpse/retaliate
		if(ROGUE_BEAST_AMBUSHER)
			. += /datum/bt_node/subtree/rogue_eat_corpse
			. += /datum/bt_node/subtree/rogue_lie_in_wait
			hunts = TRUE
		if(ROGUE_BEAST_HERD)
			. += hunts ? /datum/bt_node/subtree/rogue_graze/hunting : /datum/bt_node/subtree/rogue_graze
		if(ROGUE_BEAST_SHY)
			. += /datum/bt_node/subtree/rogue_graze/shy
			return . + /datum/bt_node/subtree/simple_skittish_combat
		if(ROGUE_BEAST_SWIMMER)
			. += /datum/bt_node/subtree/rogue_swim
			return . + /datum/bt_node/subtree/simple_fearful_combat
		if(ROGUE_BEAST_PREY)
			return . + /datum/bt_node/subtree/simple_fearful_combat
	. += hunts ? /datum/bt_node/subtree/simple_hostile_combat : /datum/bt_node/subtree/simple_retaliate_combat

/// The Ratwood beasts by Vibelin's kin of theirs.
/mob/living/simple_animal/hostile/retaliate/rogue/wolf
	rogue_beast_kind = ROGUE_BEAST_HUNTER

/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead
	rogue_beast_kind = ROGUE_BEAST_HUNTER

/mob/living/simple_animal/hostile/retaliate/rogue/bigrat
	rogue_beast_kind = ROGUE_BEAST_HUNTER

/mob/living/simple_animal/hostile/retaliate/rogue/mole
	rogue_beast_kind = ROGUE_BEAST_HUNTER

/mob/living/simple_animal/hostile/retaliate/rogue/spider
	rogue_beast_kind = ROGUE_BEAST_HUNTER

/mob/living/simple_animal/hostile/retaliate/rogue/mirespider
	rogue_beast_kind = ROGUE_BEAST_HUNTER

/mob/living/simple_animal/hostile/retaliate/rogue/direbear
	rogue_beast_kind = ROGUE_BEAST_HUNTER

/mob/living/simple_animal/hostile/retaliate/rogue/mimic
	rogue_beast_kind = ROGUE_BEAST_HUNTER

/mob/living/simple_animal/hostile/retaliate/rogue/headless
	rogue_beast_kind = ROGUE_BEAST_HUNTER

/mob/living/simple_animal/hostile/retaliate/rogue/troll
	rogue_beast_kind = ROGUE_BEAST_HUNTER

/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog
	rogue_beast_kind = ROGUE_BEAST_AMBUSHER
	rogue_hide_state = "troll_hide"
	rogue_hiding_flick = "troll_hiding"
	rogue_ambush_flick = "troll_ambush"

/mob/living/simple_animal/hostile/retaliate/rogue/saiga
	rogue_beast_kind = ROGUE_BEAST_SHY

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck
	rogue_beast_kind = ROGUE_BEAST_HERD

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/undead
	rogue_beast_kind = null

/mob/living/simple_animal/hostile/retaliate/rogue/goat
	rogue_beast_kind = ROGUE_BEAST_HERD

/mob/living/simple_animal/hostile/retaliate/rogue/goatmale
	rogue_beast_kind = ROGUE_BEAST_HERD

/mob/living/simple_animal/hostile/retaliate/rogue/swine
	rogue_beast_kind = ROGUE_BEAST_HERD

/mob/living/simple_animal/hostile/retaliate/rogue/trufflepig
	rogue_beast_kind = ROGUE_BEAST_HERD

/mob/living/simple_animal/hostile/retaliate/rogue/bull
	rogue_beast_kind = ROGUE_BEAST_HERD

/mob/living/simple_animal/hostile/retaliate/rogue/cow
	rogue_beast_kind = ROGUE_BEAST_SHY

/mob/living/simple_animal/hostile/retaliate/rogue/chicken
	rogue_beast_kind = ROGUE_BEAST_SHY

/mob/living/simple_animal/chicken
	rogue_beast_kind = ROGUE_BEAST_SHY

/mob/living/simple_animal/hostile/retaliate/bat
	rogue_beast_kind = ROGUE_BEAST_SHY

/mob/living/simple_animal/hostile/retaliate/frog
	rogue_beast_kind = ROGUE_BEAST_SWIMMER

#undef ROGUE_BEAST_HUNTER
#undef ROGUE_BEAST_HERD
#undef ROGUE_BEAST_SHY
#undef ROGUE_BEAST_PREY
#undef ROGUE_BEAST_SWIMMER
#undef ROGUE_BEAST_AMBUSHER
#undef BB_ROGUE_BEAST_CORPSE
#undef BB_ROGUE_BEAST_NEXT_MEAL
#undef ROGUE_BEAST_MEAL_COOLDOWN
#undef ROGUE_BEAST_BITE_TIME
