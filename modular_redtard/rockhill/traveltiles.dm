GLOBAL_LIST_EMPTY(rockhill_traveltiles)

/obj/structure/rockhill/traveltile
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/aportalid
	var/aportalgoesto
	var/required_trait
	var/list/required_jobs
	var/travel_time
	var/travel_message
	var/travel_deny_message
	var/travel_access_hint
	var/watchable

/obj/structure/rockhill/traveltile/Initialize(mapload)
	. = ..()
	GLOB.rockhill_traveltiles += src
	var/static/list/loc_connections = list(COMSIG_ATOM_ENTERED = PROC_REF(on_entered))
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/rockhill/traveltile/Destroy()
	GLOB.rockhill_traveltiles -= src
	return ..()

/obj/structure/rockhill/traveltile/examine(mob/user)
	. = ..()
	if(travel_access_hint && has_access(user))
		. += span_info(travel_access_hint)

/obj/structure/rockhill/traveltile/proc/partner()
	if(!aportalgoesto)
		return null
	for(var/obj/structure/rockhill/traveltile/candidate as anything in shuffle(GLOB.rockhill_traveltiles))
		if(candidate != src && candidate.aportalid == aportalgoesto)
			return candidate
	return null

/obj/structure/rockhill/traveltile/proc/has_access(mob/user)
	if(!required_trait && !length(required_jobs))
		return TRUE
	if(length(required_jobs) && (user.mind?.assigned_role?.title in required_jobs))
		return TRUE
	return required_trait && HAS_MIND_TRAIT(user, required_trait)

/obj/structure/rockhill/traveltile/proc/on_entered(datum/source, atom/movable/arrived)
	SIGNAL_HANDLER
	if(isliving(arrived) && aportalgoesto)
		INVOKE_ASYNC(src, PROC_REF(try_travel), arrived)

/obj/structure/rockhill/traveltile/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(. || !isliving(user) || !aportalgoesto)
		return
	INVOKE_ASYNC(src, PROC_REF(try_travel), user)
	return TRUE

/obj/structure/rockhill/traveltile/attack_ghost(mob/dead/observer/user)
	var/obj/structure/rockhill/traveltile/destination = partner()
	if(!destination)
		if(aportalgoesto)
			to_chat(user, span_bold("It is a dead end."))
		return ..()
	user.abstract_move(get_turf(destination))
	return TRUE

/obj/structure/rockhill/traveltile/proc/try_travel(mob/living/traveler)
	var/obj/structure/rockhill/traveltile/destination = partner()
	if(!destination)
		to_chat(traveler, span_bold("It is a dead end."))
		return
	if(!traveler.client || traveler.client.inactivity > 3 || TIMER_COOLDOWN_RUNNING(traveler, COOLDOWN_ROCKHILL_TRAVEL) || DOING_INTERACTION_WITH_TARGET(traveler, src))
		return
	if(!has_access(traveler))
		to_chat(traveler, span_bold(travel_deny_message))
		return
	if(traveler.pulledby)
		return
	to_chat(traveler, span_bold(travel_message))
	if(!do_after(traveler, travel_time, target = src, timed_action_flags = IGNORE_HELD_ITEM))
		return
	if(traveler.pulledby)
		to_chat(traveler, span_warning("I can't go, something's holding onto me."))
		return
	perform_travel(destination, traveler)

/obj/structure/rockhill/traveltile/proc/perform_travel(obj/structure/rockhill/traveltile/destination, mob/living/traveler)
	if(watchable && !HAS_TRAIT(traveler, TRAIT_RESTRAINED))
		for(var/mob/living/carbon/human/witness in hearers(6, src))
			if(witness == traveler || witness.stat != STABLE || HAS_TRAIT(witness, TRAIT_KNOCKEDOUT) || witness.is_blind() || (required_trait && HAS_MIND_TRAIT(witness, required_trait)))
				continue
			to_chat(witness, span_bold("I watch [traveler] go through a well-hidden entrance."))
			if(traveler.move_intent != MOVE_INTENT_WALK)
				to_chat(traveler, span_bold("[witness] watches me pass through the entrance."))
			if(required_trait)
				ADD_TRAIT(witness, required_trait, TRAIT_GENERIC)
	var/atom/movable/pulled = traveler.pulling
	TIMER_COOLDOWN_START(traveler, COOLDOWN_ROCKHILL_TRAVEL, 15 SECONDS)
	if(pulled)
		TIMER_COOLDOWN_START(pulled, COOLDOWN_ROCKHILL_TRAVEL, 15 SECONDS)
		pulled.forceMove(destination.loc)
	traveler.forceMove(destination.loc)
	if(pulled)
		traveler.start_pulling(pulled, supress_message = TRUE)

/obj/structure/rockhill/traveltile/examine_more(mob/user)
	. = ..()
	if(aportalgoesto)
		. += span_info("Alt-right-click to peer through to the other side.")

/obj/structure/rockhill/traveltile/click_alt_secondary(mob/living/user)
	if(!isliving(user) || !user.client || !aportalgoesto)
		return NONE
	if(user.client.eye != user)
		stop_peeking(user)
		return CLICK_ACTION_SUCCESS
	if(!has_access(user))
		return CLICK_ACTION_BLOCKING
	var/obj/structure/rockhill/traveltile/destination = partner()
	if(!destination)
		to_chat(user, span_bold("It is a dead end."))
		return CLICK_ACTION_BLOCKING
	if(user.move_intent != MOVE_INTENT_WALK)
		user.visible_message(span_info("[user] peers through [src]."))
	if(!do_after(user, ROCKHILL_PEEK_TIME, target = src))
		return CLICK_ACTION_BLOCKING
	user.reset_perspective(get_turf(destination))
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(stop_peeking), override = TRUE)
	return CLICK_ACTION_SUCCESS

/obj/structure/rockhill/traveltile/proc/stop_peeking(mob/living/user)
	SIGNAL_HANDLER
	UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
	user.reset_perspective()
