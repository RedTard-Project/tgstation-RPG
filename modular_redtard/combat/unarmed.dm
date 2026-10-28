GLOBAL_LIST_INIT(rogue_fist_intents, list(
	/datum/intent/unarmed/help,
	/datum/intent/unarmed/shove,
	/datum/intent/unarmed/grab,
	/datum/intent/unarmed/punch,
))

/datum/intent/unarmed
	unarmed = TRUE
	blade_class = BCLASS_PUNCH
	clickcd = CLICK_CD_MELEE
	var/unarmed_action = ROGUE_UNARMED_HELP

/datum/intent/unarmed/help
	name = "touch"
	desc = "Touch, help up, hug or tend to someone."
	icon_state = "intouch"
	attack_verb = null
	releasedrain = 0
	misscost = 0
	unarmed_action = ROGUE_UNARMED_HELP

/datum/intent/unarmed/shove
	name = "shove"
	desc = "Shove someone away or knock what they hold out of their hands."
	icon_state = "inshove"
	attack_verb = list("shoves", "pushes")
	misscost = 5
	unarmed_action = ROGUE_UNARMED_SHOVE

/datum/intent/unarmed/grab
	name = "grab"
	desc = "Grab someone, then again to hold them tighter. Drags things that are not held in a hand."
	icon_state = "ingrab"
	attack_verb = list("grabs")
	releasedrain = 10
	misscost = 8
	unarmed_action = ROGUE_UNARMED_GRAB

/datum/intent/unarmed/punch
	name = "punch"
	icon_state = "inpunch"
	attack_verb = list("punches", "jabs", "clocks", "strikes")
	misscost = 4
	miss_text = "swing a fist at the air"
	miss_text_others = "swings a fist at the air"
	unarmed_action = ROGUE_UNARMED_HARM

/mob/living/carbon/human/rogue_fist_intents()
	return GLOB.rogue_fist_intents

/mob/living/carbon/human/resolve_unarmed_attack(atom/attack_target, list/modifiers)
	var/datum/intent/unarmed/fist = rogue_active_intent()
	if(!istype(fist) || LAZYACCESS(modifiers, RIGHT_CLICK) || !ISADVANCEDTOOLUSER(src))
		return ..()
	switch(fist.unarmed_action)
		if(ROGUE_UNARMED_GRAB)
			if(isliving(attack_target))
				grab(attack_target)
				changeNext_move(CLICK_CD_MELEE)
				return TRUE
			var/atom/movable/thing = attack_target
			if(ismovable(thing) && !isitem(thing) && !thing.anchored)
				start_pulling(thing)
				return TRUE
			return ..()
		if(ROGUE_UNARMED_SHOVE)
			if(!isliving(attack_target))
				return ..()
			var/mob/living/shoved = attack_target
			if(rogue_combat_enabled() && shoved.check_block(src, 0, "[src]'s shove", UNARMED_ATTACK))
				do_attack_animation(shoved, ATTACK_EFFECT_DISARM)
				to_chat(src, span_warning("My shove at [shoved] was blocked!"))
				changeNext_move(CLICK_CD_MELEE)
				return TRUE
			var/list/shove_modifiers = modifiers ? modifiers.Copy() : list()
			shove_modifiers[RIGHT_CLICK] = TRUE
			if(right_click_attack_chain(attack_target, shove_modifiers))
				return TRUE
			return ..(attack_target, shove_modifiers)
	if(fist.unarmed_action == ROGUE_UNARMED_HARM && combat_mode && isliving(attack_target) && rogue_combat_enabled())
		INVOKE_ASYNC(src, PROC_REF(rogue_strike), attack_target, null, fist)
		return TRUE
	if(fist.unarmed_action != ROGUE_UNARMED_HELP || !combat_mode || !isliving(attack_target))
		return ..()
	combat_mode = FALSE
	. = ..()
	if(!combat_mode)
		combat_mode = TRUE

/// Ratwood's shove (species.dm disarm): it moves its target only on a roll of strength against their constitution;
/// held in place, TG's disarm goes on to stagger them and loosen their grip.
/mob/living/carbon/human/get_shove_flags(mob/living/shover, obj/item/weapon)
	. = ..()
	if(!(. & SHOVE_CAN_MOVE) || weapon || !ishuman(shover) || !rogue_combat_enabled())
		return
	if(!prob(ROGUE_SHOVE_CHANCE + rogue_stat_comparison(shover.rogue_stat(ROGUE_STAT_STRENGTH), rogue_stat(ROGUE_STAT_CONSTITUTION))))
		. &= ~SHOVE_CAN_MOVE

/// Ratwood generic_stat_comparison: the difference counts once it is more than one point.
/proc/rogue_stat_comparison(user_stat, target_stat)
	var/difference = user_stat - target_stat
	return abs(difference) > 1 ? difference * ROGUE_STAT_COMPARE_STEP : 0
