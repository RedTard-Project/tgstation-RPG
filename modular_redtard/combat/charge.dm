/mob/living/carbon/human
	var/rogue_charge_started = 0
	var/rogue_charge_released = 0
	var/mutable_appearance/rogue_charge_overlay

/mob/living/carbon/human/proc/rogue_start_charge(datum/intent/intent)
	rogue_charge_started = world.time
	rogue_charge_released = 0
	rogue_set_charge_overlay("eff_aimed_charge")
	if(intent.tshield)
		visible_message(span_warning("[src] raises [get_active_held_item()]!"))
		playsound(src, 'modular_redtard/rockhill/sound/combat/shieldraise.ogg', 100, FALSE)
	addtimer(CALLBACK(src, PROC_REF(rogue_charge_full), rogue_charge_started), intent.chargetime, TIMER_DELETE_ME)

/mob/living/carbon/human/proc/rogue_charge_full(started)
	if(rogue_charge_started != started || rogue_charge_released)
		return
	rogue_set_charge_overlay("eff_aimed_full")
	playsound_local(src, 'sound/machines/click.ogg', 50, FALSE)

/mob/living/carbon/human/proc/rogue_release_charge()
	if(!rogue_charge_started || rogue_charge_released)
		return
	rogue_charge_released = world.time
	rogue_set_charge_overlay(null)

/mob/living/carbon/human/proc/rogue_set_charge_overlay(state)
	if(rogue_charge_overlay)
		cut_overlay(rogue_charge_overlay)
		rogue_charge_overlay = null
	if(state)
		rogue_charge_overlay = mutable_appearance(ROGUE_MOB_EFFECTS_ICON, state, ABOVE_ALL_MOB_LAYER)
		add_overlay(rogue_charge_overlay)

/mob/living/carbon/human/proc/rogue_take_charge(datum/intent/intent)
	if(!intent?.chargetime)
		return 1
	if(!rogue_charge_started)
		return 0
	var/finished = rogue_charge_released || world.time
	. = min((finished - rogue_charge_started) / intent.chargetime, 1)
	rogue_charge_started = 0
	rogue_charge_released = 0
	rogue_set_charge_overlay(null)

/datum/element/rogue_combat/proc/on_mouse_down(client/source, atom/object, location, control, params)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/fighter = source.mob
	if(!ishuman(fighter) || !fighter.combat_mode || istype(object, /atom/movable/screen))
		return
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, RIGHT_CLICK) || LAZYACCESS(modifiers, MIDDLE_CLICK) || LAZYACCESS(modifiers, SHIFT_CLICK) || LAZYACCESS(modifiers, CTRL_CLICK) || LAZYACCESS(modifiers, ALT_CLICK))
		return
	var/datum/intent/intent = fighter.rogue_strike_intent(fighter.get_active_held_item())
	if(intent?.chargetime > 0)
		fighter.rogue_start_charge(intent)

/datum/element/rogue_combat/proc/on_mouse_up(client/source, atom/object, location, control, params)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/fighter = source.mob
	if(ishuman(fighter))
		fighter.rogue_release_charge()
