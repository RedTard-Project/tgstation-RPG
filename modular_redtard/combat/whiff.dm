/// Clicking an open tile in combat mode (Ratwood ClickOn): a creature standing there is struck as if clicked itself, so a
/// moving target can be hit by aiming at its tile; an empty tile within reach is a swing at the air with its own delay,
/// woosh and stamina cost. Intents without an attack animation (noaa: digging, scooping and the like) keep the TG tile click.
/mob/living/carbon/human/proc/rogue_tile_click(turf/open/tile, list/modifiers)
	if(!combat_mode || !istype(tile) || throw_mode || incapacitated || world.time < next_move || HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		return NONE
	var/obj/item/weapon = get_active_held_item()
	if(weapon && !length(weapon.rogue_intents()))
		return NONE
	var/datum/intent/intent = rogue_strike_intent(weapon)
	if(!intent || intent.noaa || intent.tranged || intent.no_attack)
		return NONE
	if(!weapon)
		var/datum/intent/unarmed/fist = intent
		if(!istype(fist) || fist.unarmed_action != ROGUE_UNARMED_HARM)
			return NONE
	var/reach = weapon ? weapon.reach : 1
	if(get_dist(src, tile) > reach || !(tile in view(reach, src)))
		return NONE
	for(var/mob/living/victim in tile)
		if(victim == src || victim.invisibility > see_invisible || !victim.IsReachableBy(src, reach))
			continue
		INVOKE_ASYNC(src, PROC_REF(rogue_strike_tile_victim), victim, weapon, modifiers)
		return COMSIG_MOB_CANCEL_CLICKON
	for(var/obj/thing in tile)
		if(!iseffect(thing))
			return NONE
	face_atom(tile)
	changeNext_move(max(round(intent.clickcd * rogue_rmb_factor("click_factor")), ROGUE_STRIKE_MIN_CLICK))
	do_attack_animation(tile, weapon ? null : ATTACK_EFFECT_PUNCH, weapon)
	rogue_swung()
	playsound(get_turf(src), intent.miss_sound || rogue_swing_sound(weapon, intent), 100, FALSE)
	if(intent.misscost)
		adjust_stamina_loss(intent.misscost)
	if(intent.miss_text)
		visible_message(span_warning("[src] [intent.miss_text_others || intent.miss_text]!"), span_warning("I [intent.miss_text]!"))
	return COMSIG_MOB_CANCEL_CLICKON

/mob/living/carbon/human/proc/rogue_strike_tile_victim(mob/living/victim, obj/item/weapon, list/modifiers)
	face_atom(victim)
	if(weapon)
		weapon.melee_attack_chain(src, victim, modifiers)
	else
		UnarmedAttack(victim, TRUE, modifiers)
