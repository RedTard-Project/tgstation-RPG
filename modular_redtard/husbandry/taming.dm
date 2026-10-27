/// Taming (Ratwood simple_animal.dm attackby() and tamed(), rogue/rogueanimals.dm tamed(), CanAttack(), beckoned(), shood(),
/// taunted(); intents.dm rmb_ranged() of shove, grab and punch) on TG's tameable, befriend() and pet commands.
///
/// A beast is tamed by hand-feeding it what it eats (TG's tameable on COMSIG_MOB_ATE): Ratwood's tame_chance, plus
/// bonus_tame_chance after every failed try. The tamer becomes the beast's friend (TG befriend()): an ally its targeting never
/// picks, so a tamed beast does not attack its friends. Someone else may tame it again and become a friend too (Ratwood moves the
/// owner; the last tamer is named on examine). Tamed, it stops hunting (Ratwood aggressive = 0) and obeys its friends: TG's pet
/// commands (Stay, Loose, Follow, Attack - by speech or the radial menu on Shift over the beast) and Ratwood's gestures with an
/// empty hand from afar - beckon (grab) calls it over, shoo (shove) sets it on everyone around but its friends.

/// TG's taming by hand-feeding with Ratwood's temper: a beast with someone to fight calms down and takes to the feeder only
/// now and then (retaliate/rogue tamed()), otherwise the feeding is wasted.
/datum/component/tameable/rogue

/datum/component/tameable/rogue/on_tame(atom/source, mob/living/tamer, obj/item/food, inform_tamer = FALSE)
	SIGNAL_HANDLER
	var/mob/living/basic/rockhill/beast = parent
	if(istype(beast) && beast.rogue_is_angry())
		if(!prob(ROGUE_TAME_ANGRY_CHANCE))
			return
		beast.rogue_calm_down()
	return ..()

/// Ratwood tamed(): the beast stops hunting, lets itself be led on a rope, and from now on minds the commands of its friends.
/mob/living/basic/rockhill/tamed(mob/living/tamer, obj/item/food)
	. = ..()
	if(tamer)
		rogue_owner = WEAKREF(tamer)
		visible_message(span_notice("[src] lowers [p_their()] head to [tamer]."))
	if(!ai_controller || GetComponent(/datum/component/obeys_commands))
		return
	rogue_aggressive = FALSE
	ai_controller.ai_traits |= STOP_MOVING_WHEN_PULLED
	ai_controller.set_blackboard_key(BB_TAMED, TRUE)
	ai_controller.set_blackboard_key(BB_PET_TARGETING_STRATEGY, /datum/targeting_strategy/basic/not_friends)
	if(rogue_hunts && istype(ai_controller, /datum/ai_controller/basic_controller/simple/rogue_beast))
		rogue_hunts = FALSE
		var/had_chores = !!(locate(/datum/bt_node/subtree/rogue_chores) in ai_controller.behavior_nodes)
		ai_controller.cancel_current_plan()
		ai_controller.replace_behavior_nodes(rogue_beast_roots())
		if(had_chores)
			rogue_ensure_chores()
	rogue_ensure_pet_slot()
	var/static/list/pet_commands = list(
		/datum/pet_command/idle,
		/datum/pet_command/free,
		/datum/pet_command/follow,
		/datum/pet_command/attack,
	)
	AddComponent(/datum/component/obeys_commands, pet_commands)

/mob/living/basic/rockhill/examine(mob/user)
	. = ..()
	if(!HAS_TRAIT(src, TRAIT_TAMED))
		return
	. += span_notice("This animal appears to be tamed.")
	var/mob/owner = rogue_owner?.resolve()
	if(owner)
		. += span_notice("It is tamed to [owner.name].")

/// Ratwood gestures at a beast (combat/gestures.dm): a tamed one comes when beckoned and, shooed, sets upon everyone around but
/// its friends; some beasts take a taunt as a challenge.
/mob/living/basic/rockhill/proc/rogue_on_gesture(datum/source, mob/living/gesturer, gesture)
	SIGNAL_HANDLER
	if(stat != CONSCIOUS)
		return
	switch(gesture)
		if(ROGUE_GESTURE_BECKON)
			if(HAS_TRAIT(src, TRAIT_TAMED))
				rogue_seek(BB_ROGUE_LURE_TARGET, gesturer, ROGUE_LURE_TIME)
		if(ROGUE_GESTURE_SHOO)
			if(HAS_TRAIT(src, TRAIT_TAMED))
				rogue_set_upon_everyone()
		if(ROGUE_GESTURE_TAUNT)
			if(rogue_taunt_angers && !has_ally(gesturer))
				rogue_set_upon(gesturer)

/// Ratwood Retaliate() of a shooed tamed beast: everyone in sight not of its kind and not its friend becomes its enemy.
/mob/living/basic/rockhill/proc/rogue_set_upon_everyone()
	for(var/mob/living/bystander in hearers(ROGUE_SHOO_RANGE, src))
		if(bystander == src || bystander.stat == DEAD || faction_check_atom(bystander))
			continue
		rogue_set_upon(bystander)

/// A young beast grows up only on the ground and not in the middle of a fight (Ratwood rogue Life(): adult_growth, no enemies).
/mob/living/basic/rockhill/proc/rogue_can_grow()
	return isturf(loc) && stat == CONSCIOUS && !rogue_is_angry()

/// Grown up (TG's growth_and_differentiation): a tamed young makes a tamed adult that keeps its friends (Ratwood: tame = TRUE).
/mob/living/basic/rockhill/proc/rogue_on_grown(datum/source, mob/living/basic/rockhill/adult)
	SIGNAL_HANDLER
	if(!istype(adult) || !HAS_TRAIT(src, TRAIT_TAMED))
		return
	adult.tamed(rogue_owner?.resolve())
	for(var/mob/living/friend in ai_controller?.blackboard[BB_FRIENDS_LIST])
		INVOKE_ASYNC(adult, TYPE_PROC_REF(/mob/living, befriend), friend)
