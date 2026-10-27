/// Azure Peak's right-click gestures with an empty hand at someone out of reach (rmb_ranged of the fist intents): touch
/// waves, shove shoos, grab beckons, punch taunts. The sign floats over the gesturer for them and for the one it is meant
/// for; the target hears of it through COMSIG_LIVING_ROGUE_GESTURE, so a mob's mind can answer a beckon or a shoo.
/datum/intent/unarmed/proc/rogue_gesture(mob/living/carbon/human/user, mob/living/target)
	return FALSE

/datum/intent/unarmed/help/rogue_gesture(mob/living/carbon/human/user, mob/living/target)
	user.rogue_sign(target, ROGUE_GESTURE_WAVE, "wavefriendly", span_green("[user] waves friendly at [target]."), span_green("I wave friendly at [target]."))
	return TRUE

/datum/intent/unarmed/shove/rogue_gesture(mob/living/carbon/human/user, mob/living/target)
	user.rogue_sign(target, ROGUE_GESTURE_SHOO, "dismiss", span_blue("[user] shoos [target] away."), span_blue("I shoo [target] away."))
	return TRUE

/datum/intent/unarmed/grab/rogue_gesture(mob/living/carbon/human/user, mob/living/target)
	user.rogue_sign(target, ROGUE_GESTURE_BECKON, "beckon", span_notice("[user] beckons [target] to come closer."), span_notice("I beckon [target] to come closer."))
	return TRUE

/// A pacifist berates instead; someone at the end of their nerves flips them off.
/datum/intent/unarmed/punch/rogue_gesture(mob/living/carbon/human/user, mob/living/target)
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		user.rogue_sign(target, ROGUE_GESTURE_TAUNT, "thumbsdown", span_warning("[user] berates [target] disapprovingly!"), offset = 24)
	else if(user.mob_mood && user.mob_mood.sanity_level >= SANITY_LEVEL_DISTURBED)
		user.rogue_sign(target, ROGUE_GESTURE_TAUNT, "midfinger", span_warning("[user] flips [target] off!"), offset = 23)
	else
		user.rogue_sign(target, ROGUE_GESTURE_TAUNT, "taunt", span_warning("[user] taunts [target]!"), offset = 21)
	return TRUE

/mob/living/carbon/human/proc/rogue_sign(mob/living/target, gesture, icon_state, seen_text, self_text, offset = 20)
	visible_message(seen_text, self_text || seen_text, ignored_mobs = list(target))
	to_chat(target, seen_text)
	var/list/viewers = list()
	for(var/mob/watcher in list(src, target))
		if(watcher.client)
			viewers += watcher.client
	if(length(viewers))
		var/image/sign = image(ROGUE_GESTURE_ICON, src, icon_state, ABOVE_ALL_MOB_LAYER)
		SET_PLANE_EXPLICIT(sign, BALLOON_CHAT_PLANE, src)
		sign.appearance_flags = RESET_ALPHA | RESET_COLOR | RESET_TRANSFORM | KEEP_APART
		sign.pixel_z = offset
		animate(sign, pixel_z = offset + ROGUE_GESTURE_RISE, alpha = 0, time = ROGUE_GESTURE_TIME, easing = CUBIC_EASING | EASE_IN)
		flick_overlay_global(sign, viewers, ROGUE_GESTURE_TIME)
	changeNext_move(CLICK_CD_MELEE)
	SEND_SIGNAL(target, COMSIG_LIVING_ROGUE_GESTURE, src, gesture)

/// Right click with an empty hand at someone out of reach, outside a stance's action.
/mob/living/carbon/human/proc/rogue_try_gesture(atom/target)
	if(stat != STABLE || get_active_held_item() || !isliving(target) || target == src || target.Adjacent(src))
		return FALSE
	var/datum/intent/unarmed/fist = rogue_active_intent()
	if(!istype(fist))
		return FALSE
	face_atom(target)
	return fist.rogue_gesture(src, target)
