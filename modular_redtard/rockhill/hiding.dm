/datum/component/rockhill_hiding_spot
	var/datum/weakref/hider
	var/hide_time = 5 SECONDS

/datum/component/rockhill_hiding_spot/Initialize()
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/rockhill_hiding_spot/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_ATTACK_HAND, PROC_REF(on_attack_hand))
	RegisterSignal(parent, COMSIG_ATOM_RELAYMOVE, PROC_REF(on_relaymove))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ATOM_EXITED, PROC_REF(on_exited))
	RegisterSignal(parent, COMSIG_QDELETING, PROC_REF(on_parent_deleting))

/datum/component/rockhill_hiding_spot/UnregisterFromParent()
	var/mob/living/current = hider?.resolve()
	if(current)
		release(current)
	UnregisterSignal(parent, list(COMSIG_ATOM_ATTACK_HAND, COMSIG_ATOM_RELAYMOVE, COMSIG_ATOM_EXAMINE, COMSIG_ATOM_EXITED, COMSIG_QDELETING))

/datum/component/rockhill_hiding_spot/proc/on_attack_hand(datum/source, mob/living/user, list/modifiers)
	SIGNAL_HANDLER
	if(!isliving(user))
		return
	if(user.loc == parent)
		release(user)
		return COMPONENT_CANCEL_ATTACK_CHAIN
	if(user.move_intent != MOVE_INTENT_WALK || user.combat_mode || user.pulling || user.buckled)
		return
	if(hider?.resolve())
		to_chat(user, span_warning("Someone is already hiding under [parent]!"))
		return COMPONENT_CANCEL_ATTACK_CHAIN
	INVOKE_ASYNC(src, PROC_REF(hide), user)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/component/rockhill_hiding_spot/proc/hide(mob/living/user)
	if(!do_after(user, hide_time, parent) || hider?.resolve() || user.pulling || user.buckled)
		return
	hider = WEAKREF(user)
	user.forceMove(parent)
	to_chat(user, span_warning("I hide under [parent]!"))

/datum/component/rockhill_hiding_spot/proc/release(mob/living/current)
	hider = null
	var/turf/exit_turf = get_turf(parent)
	if(!exit_turf || current.loc != parent)
		return
	current.forceMove(exit_turf)
	to_chat(current, span_warning("I come out from under [parent]!"))

/datum/component/rockhill_hiding_spot/proc/on_relaymove(datum/source, mob/living/user, direction)
	SIGNAL_HANDLER
	if(user != hider?.resolve())
		return
	release(user)
	return COMSIG_BLOCK_RELAYMOVE

/datum/component/rockhill_hiding_spot/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(!isliving(user) || user.loc == parent || get_dist(user, parent) > 1)
		return
	var/mob/living/current = hider?.resolve()
	if(!current)
		examine_list += span_notice("I could hide under it: switch to walking, then click it.")
		return
	release(current)
	examine_list += span_warning("Someone was hiding under it!")

/datum/component/rockhill_hiding_spot/proc/on_exited(datum/source, atom/movable/gone, direction)
	SIGNAL_HANDLER
	if(gone == hider?.resolve())
		hider = null

/datum/component/rockhill_hiding_spot/proc/on_parent_deleting(datum/source)
	SIGNAL_HANDLER
	var/mob/living/current = hider?.resolve()
	if(current)
		release(current)
