/// Charge cursors of Ratwood's mousecharge, one per 5% of the charge.
GLOBAL_LIST_INIT(rogue_charge_cursors, list(
	'modular_redtard/rockhill/icons/effects/mousemice/swang/0.dmi',
	'modular_redtard/rockhill/icons/effects/mousemice/swang/5.dmi',
	'modular_redtard/rockhill/icons/effects/mousemice/swang/10.dmi',
	'modular_redtard/rockhill/icons/effects/mousemice/swang/15.dmi',
	'modular_redtard/rockhill/icons/effects/mousemice/swang/20.dmi',
	'modular_redtard/rockhill/icons/effects/mousemice/swang/25.dmi',
	'modular_redtard/rockhill/icons/effects/mousemice/swang/30.dmi',
	'modular_redtard/rockhill/icons/effects/mousemice/swang/35.dmi',
	'modular_redtard/rockhill/icons/effects/mousemice/swang/40.dmi',
	'modular_redtard/rockhill/icons/effects/mousemice/swang/45.dmi',
	'modular_redtard/rockhill/icons/effects/mousemice/swang/50.dmi',
	'modular_redtard/rockhill/icons/effects/mousemice/swang/55.dmi',
	'modular_redtard/rockhill/icons/effects/mousemice/swang/60.dmi',
	'modular_redtard/rockhill/icons/effects/mousemice/swang/65.dmi',
	'modular_redtard/rockhill/icons/effects/mousemice/swang/70.dmi',
	'modular_redtard/rockhill/icons/effects/mousemice/swang/75.dmi',
	'modular_redtard/rockhill/icons/effects/mousemice/swang/80.dmi',
	'modular_redtard/rockhill/icons/effects/mousemice/swang/85.dmi',
	'modular_redtard/rockhill/icons/effects/mousemice/swang/90.dmi',
	'modular_redtard/rockhill/icons/effects/mousemice/swang/95.dmi',
	'modular_redtard/rockhill/icons/effects/mousemice/swang/100.dmi',
))

/// A blow being charged with the mouse held down (Ratwood mousecharge, Azure Peak charge): the cursor fills up, the intent's warning hangs
/// over the attacker, the attacker slows down, a held full charge drains stamina, and an intent with movement_interrupt is lost on a step.
/datum/component/rogue_charge
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/datum/intent/intent
	/// Deciseconds to the full charge: the intent's, or the draw of a launcher by the fighter's skill and stats (Ratwood get_chargetime()).
	var/goal = 1
	var/started = 0
	var/released = 0
	var/full = FALSE
	var/mutable_appearance/marker

/datum/component/rogue_charge/Initialize(datum/intent/intent, obj/item/held)
	if(!ishuman(parent) || !intent?.chargetime)
		return COMPONENT_INCOMPATIBLE
	src.intent = intent
	goal = max(intent.rogue_chargetime(parent, held), 0.1)
	started = world.time
	var/mob/living/carbon/human/charger = parent
	if(intent.charging_slowdown)
		charger.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/rogue_charging, multiplicative_slowdown = intent.charging_slowdown)
	set_marker(intent.warnie ? intent.warnie : "eff_aimed_charge", !!intent.warnie)
	if(intent.tshield)
		charger.visible_message(span_warning("[charger] raises [charger.get_active_held_item()]!"))
		playsound(charger, 'modular_redtard/rockhill/sound/combat/shieldraise.ogg', 100, FALSE)
	charger.rogue_set_cursor(GLOB.rogue_charge_cursors[1])
	START_PROCESSING(SSfastprocess, src)

/datum/component/rogue_charge/RegisterWithParent()
	if(intent.movement_interrupt)
		RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignals(parent, list(COMSIG_MOB_SWAP_HANDS, COMSIG_LIVING_SET_BODY_POSITION), PROC_REF(on_disrupted))

/datum/component/rogue_charge/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_MOVABLE_MOVED, COMSIG_MOB_SWAP_HANDS, COMSIG_LIVING_SET_BODY_POSITION))

/datum/component/rogue_charge/Destroy(force)
	STOP_PROCESSING(SSfastprocess, src)
	var/mob/living/carbon/human/charger = parent
	if(istype(charger))
		charger.remove_movespeed_modifier(/datum/movespeed_modifier/rogue_charging)
		if(marker)
			charger.cut_overlay(marker)
		charger.update_mouse_pointer()
	marker = null
	intent = null
	return ..()

/datum/component/rogue_charge/proc/set_marker(state, from_effects)
	var/mob/living/carbon/human/charger = parent
	if(marker)
		charger.cut_overlay(marker)
	marker = mutable_appearance(from_effects ? ROGUE_EFFECTS_ICON : ROGUE_MOB_EFFECTS_ICON, state, ABOVE_ALL_MOB_LAYER)
	if(from_effects)
		marker.pixel_z = 16
	charger.add_overlay(marker)

/datum/component/rogue_charge/proc/progress()
	return min(((released || world.time) - started) / goal, 1)

/datum/component/rogue_charge/process(seconds_per_tick)
	var/mob/living/carbon/human/charger = parent
	if(released)
		return PROCESS_KILL
	if(!full)
		var/share = progress()
		if(share < 1)
			charger.rogue_set_cursor(GLOB.rogue_charge_cursors[floor(share * 20) + 1])
			return
		full = TRUE
		if(!intent.warnie)
			set_marker("eff_aimed_full", FALSE)
		charger.rogue_set_cursor(ROGUE_CURSOR_CHARGED)
		charger.playsound_local(charger, 'sound/machines/click.ogg', 50, FALSE)
		return
	if(!intent.chargedrain)
		return
	var/drain = intent.chargedrain * seconds_per_tick * ROGUE_CHARGE_DRAIN_TICKS_PER_SECOND
	if(charger.get_stamina_loss() + drain >= charger.max_stamina)
		to_chat(charger, span_warning("I can't hold it any longer!"))
		charger.changeNext_move(CLICK_CD_MELEE)
		qdel(src)
		return PROCESS_KILL
	charger.adjust_stamina_loss(drain)

/datum/component/rogue_charge/proc/release()
	released = world.time
	STOP_PROCESSING(SSfastprocess, src)
	var/mob/living/carbon/human/charger = parent
	charger.remove_movespeed_modifier(/datum/movespeed_modifier/rogue_charging)
	if(marker)
		charger.cut_overlay(marker)
		marker = null
	charger.update_mouse_pointer()

/datum/component/rogue_charge/proc/on_moved(mob/living/carbon/human/source)
	SIGNAL_HANDLER
	if(released)
		return
	to_chat(source, span_warning("I lost my concentration!"))
	source.changeNext_move(CLICK_CD_MELEE)
	qdel(src)

/datum/component/rogue_charge/proc/on_disrupted(mob/living/carbon/human/source)
	SIGNAL_HANDLER
	if(!released)
		qdel(src)

/datum/movespeed_modifier/rogue_charging
	variable = TRUE

/mob/living/carbon/human/proc/rogue_start_charge(datum/intent/intent, obj/item/held)
	qdel(GetComponent(/datum/component/rogue_charge))
	AddComponent(/datum/component/rogue_charge, intent, held)

/mob/living/carbon/human/proc/rogue_release_charge()
	var/datum/component/rogue_charge/charge = GetComponent(/datum/component/rogue_charge)
	if(charge && !charge.released)
		charge.release()

/// Share of the charge a blow gets (1 for intents without a charge). An intent with no_early_release returns -1 when let go early:
/// the blow is cancelled instead of landing weaker (Ratwood).
/mob/living/carbon/human/proc/rogue_take_charge(datum/intent/intent)
	if(!intent?.chargetime)
		return 1
	var/datum/component/rogue_charge/charge = GetComponent(/datum/component/rogue_charge)
	if(!charge || charge.intent != intent)
		qdel(charge)
		if(!client)
			return 1
		return intent.no_early_release ? -1 : 0
	. = charge.progress()
	qdel(charge)
	if(. < 1 && intent.no_early_release)
		return -1

/mob/living/proc/rogue_charge_full(datum/intent/intent)
	return FALSE

/mob/living/carbon/human/rogue_charge_full(datum/intent/intent)
	var/datum/component/rogue_charge/charge = GetComponent(/datum/component/rogue_charge)
	return charge && !charge.released && (!intent || charge.intent == intent) && charge.progress() >= 1

/// Drawing a bow or sling leaves no hand free to parry or dodge (Ratwood checkdefense); a raised shield is not that.
/mob/living/proc/rogue_charging_ranged()
	return FALSE

/mob/living/carbon/human/rogue_charging_ranged()
	var/datum/component/rogue_charge/charge = GetComponent(/datum/component/rogue_charge)
	return charge && !charge.released && charge.intent.tranged && !charge.intent.tshield

/datum/element/rogue_combat/proc/on_mouse_down(client/source, atom/object, location, control, params)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/fighter = source.mob
	if(!ishuman(fighter) || istype(object, /atom/movable/screen) || fighter.stat != STABLE)
		return
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, SHIFT_CLICK) || LAZYACCESS(modifiers, CTRL_CLICK) || LAZYACCESS(modifiers, ALT_CLICK))
		return
	fighter.rogue_hold_facing(TRUE)
	if(LAZYACCESS(modifiers, MIDDLE_CLICK))
		fighter.rogue_set_cursor(fighter.rogue_mmb_cursor())
		return
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		fighter.rogue_set_cursor(fighter.combat_mode && fighter.rogue_rmb_intent?.has_action ? ROGUE_CURSOR_ATTACK : ROGUE_CURSOR_LOOKING)
		return
	var/obj/item/held = fighter.get_active_held_item()
	// A bow, crossbow or sling is drawn in or out of combat mode (Ratwood), but not by a click on one's own gear (a quiver).
	if(istype(held, /obj/item/gun/ballistic/rogue_launcher))
		var/datum/intent/shot = fighter.rogue_strike_intent(held)
		if(shot?.tranged)
			if(shot.chargetime > 0 && fighter.throw_mode == THROW_MODE_DISABLED && get(object, /mob) != fighter && shot.rogue_can_charge(fighter, held))
				fighter.rogue_start_charge(shot, held)
				shot.rogue_prewarning(fighter, held)
			return
	if(!fighter.combat_mode)
		return
	var/datum/intent/intent = fighter.rogue_strike_intent(held)
	if(intent?.chargetime > 0 && fighter.throw_mode == THROW_MODE_DISABLED)
		fighter.rogue_start_charge(intent, held)
	else
		fighter.rogue_set_cursor(ROGUE_CURSOR_ATTACK)

/datum/element/rogue_combat/proc/on_mouse_up(client/source, atom/object, location, control, params)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/fighter = source.mob
	if(!ishuman(fighter))
		return
	fighter.rogue_hold_facing(FALSE)
	fighter.rogue_release_charge()
	fighter.update_mouse_pointer()
