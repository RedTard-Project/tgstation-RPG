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

/// Free hold of a full ranged draw before it trembles, deciseconds, and how much a point of perception from the baseline
/// adds to it (Azure Peak RANGED_HOLD_GRACE, RANGED_HOLD_GRACE_PER_BASELINE, RANGED_HOLD_GRACE_PER_BONUS); deciseconds
/// past the free hold to the worst tremble, and how much more the held draw then drains (RANGED_HOLD_RAMP_WINDOW,
/// RANGED_HOLD_RAMP).
#define ROGUE_HOLD_GRACE rogue_value("ranged_hold_grace")
#define ROGUE_HOLD_GRACE_PER_BASELINE rogue_value("ranged_hold_grace_perception_baseline")
#define ROGUE_HOLD_GRACE_PER_BONUS rogue_value("ranged_hold_grace_per_perception")
#define ROGUE_HOLD_RAMP_WINDOW rogue_value("ranged_hold_ramp_window")
#define ROGUE_HOLD_RAMP rogue_value("ranged_hold_ramp")

/// A blow being charged with the mouse held down (Ratwood mousecharge, Azure Peak charge): the cursor fills up, the intent's warning hangs
/// over the attacker, the attacker slows down, a held full charge drains stamina, and an intent with movement_interrupt is lost on a step.
/// A full ranged draw (rogue_hold_strain) is free to hold for a while (longer with perception); past that it trembles more and
/// more, which strays the shot (combat/launchers.dm) and drains more. A launcher's draw let down without a shot costs stamina.
/datum/component/rogue_charge
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/datum/intent/intent
	/// What is charged: a launcher's draw is paid for when it is let down (Azure Peak on_charge_cancel()).
	var/datum/weakref/held_ref
	/// Deciseconds to the full charge: the intent's, or the draw of a launcher by the fighter's skill (Azure Peak get_chargetime()).
	var/goal = 1
	var/started = 0
	var/released = 0
	var/full = FALSE
	/// When the charge became full, the free hold then, the window of the tremble and how much more it drains, read once.
	var/full_at = 0
	var/hold_grace = 0
	var/hold_window = 0
	var/hold_ramp = 0
	/// The tremble was announced; the cursor's step of the tremble shown.
	var/strained = FALSE
	var/strain_step = 0
	/// The shot or blow took the charge, or the fighter could hold it no longer: nothing is let down.
	var/taken = FALSE
	var/mutable_appearance/marker

/datum/component/rogue_charge/Initialize(datum/intent/intent, obj/item/held)
	if(!ishuman(parent) || !intent?.chargetime)
		return COMPONENT_INCOMPATIBLE
	src.intent = intent
	held_ref = WEAKREF(held)
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
		let_down(charger)
	marker = null
	intent = null
	held_ref = null
	return ..()

/// A launcher's draw cancelled while held, not shot (Azure Peak on_charge_cancel(), pay_letdown_drain()).
/datum/component/rogue_charge/proc/let_down(mob/living/carbon/human/charger)
	var/obj/item/gun/ballistic/rogue_launcher/launcher = held_ref?.resolve()
	if(taken || released || !istype(launcher) || QDELETED(charger) || !charger.client)
		return
	if(!intent?.tranged || charger.get_stamina_loss() >= charger.max_stamina)
		return
	launcher.rogue_pay_letdown_drain(charger, progress())

/// How much the held full draw trembles, 0 to 1 (Azure Peak get_hold_instability()): nothing within the free hold, then
/// more and more over the window.
/datum/component/rogue_charge/proc/hold_instability()
	if(!full || !intent?.rogue_hold_strain || hold_window <= 0)
		return 0
	var/held_for = (released || world.time) - full_at
	return clamp((held_for - hold_grace) / hold_window, 0, 1)

/// The free hold of a full draw: longer with perception (Azure Peak get_hold_grace()); none for a blow.
/datum/component/rogue_charge/proc/read_hold()
	full_at = world.time
	if(!intent.rogue_hold_strain)
		return
	var/mob/living/carbon/human/charger = parent
	hold_grace = max(0, ROGUE_HOLD_GRACE + (charger.rogue_stat(ROGUE_STAT_PERCEPTION) - ROGUE_HOLD_GRACE_PER_BASELINE) * ROGUE_HOLD_GRACE_PER_BONUS)
	hold_window = ROGUE_HOLD_RAMP_WINDOW
	hold_ramp = ROGUE_HOLD_RAMP

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
		read_hold()
		if(!intent.warnie)
			set_marker("eff_aimed_full", FALSE)
		charger.rogue_set_cursor(ROGUE_CURSOR_CHARGED)
		charger.playsound_local(charger, 'sound/machines/click.ogg', 50, FALSE)
		return
	if(world.time - full_at < hold_grace)
		return
	var/instability = hold_instability()
	if(instability > 0)
		show_strain(charger, instability)
	if(!intent.chargedrain)
		return
	var/drain = intent.chargedrain * (1 + instability * hold_ramp) * seconds_per_tick * ROGUE_CHARGE_DRAIN_TICKS_PER_SECOND
	if(charger.get_stamina_loss() + drain >= charger.max_stamina)
		to_chat(charger, span_warning("I can't hold it any longer!"))
		charger.changeNext_move(CLICK_CD_MELEE)
		taken = TRUE
		qdel(src)
		return PROCESS_KILL
	charger.adjust_stamina_loss(drain)

/// The trembling draw: the cursor empties as it trembles more (Azure Peak handle_charge_strain()).
/datum/component/rogue_charge/proc/show_strain(mob/living/carbon/human/charger, instability)
	if(!strained)
		strained = TRUE
		to_chat(charger, span_warning("My arm begins to tremble."))
	var/cursor_step = floor((1 - instability) * (length(GLOB.rogue_charge_cursors) - 1)) + 1
	if(cursor_step == strain_step)
		return
	strain_step = cursor_step
	charger.rogue_set_cursor(GLOB.rogue_charge_cursors[cursor_step])

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
	charge.taken = TRUE
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
	// A readied spell takes the press for its own charge (magic/spell.dm), not the weapon's, all the while it is charged and
	// held (Azure Peak's hold); its right click disarms it, with the cancel penalty if the spell has one.
	if(fighter.rogue_spell_holds_press())
		return
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

#undef ROGUE_HOLD_GRACE
#undef ROGUE_HOLD_GRACE_PER_BASELINE
#undef ROGUE_HOLD_GRACE_PER_BONUS
#undef ROGUE_HOLD_RAMP_WINDOW
#undef ROGUE_HOLD_RAMP
