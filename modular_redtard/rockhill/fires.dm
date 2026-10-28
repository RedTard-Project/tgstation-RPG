/obj/item/var/firefuel = 0

GLOBAL_LIST_EMPTY(rockhill_lit_fires)

/obj/machinery/light/rogue
	var/base_state
	var/fueluse = 0
	var/no_refuel = FALSE
	var/crossfire = TRUE
	var/status = LIGHT_OK
	var/lit = FALSE
	var/burn_started = 0
	var/burn_timer

/obj/machinery/light/rogue/Initialize(mapload)
	. = ..()
	if(fueluse > 0)
		fueluse -= round(rand(fueluse * ROCKHILL_FIRE_SPENT_MIN, fueluse * ROCKHILL_FIRE_SPENT_MAX))
	if(crossfire)
		var/static/list/loc_connections = list(COMSIG_ATOM_ENTERED = PROC_REF(on_entered))
		AddElement(/datum/element/connect_loc, loc_connections)
	if(status != LIGHT_OK || !ignite(silent = TRUE))
		set_light_on(FALSE)
		update_appearance(UPDATE_ICON_STATE)

/obj/machinery/light/rogue/Destroy()
	deltimer(burn_timer)
	GLOB.rockhill_lit_fires -= src
	return ..()

/obj/machinery/light/rogue/proc/endless()
	return initial(fueluse) <= 0

/obj/machinery/light/rogue/proc/fuel_left()
	if(endless())
		return INFINITY
	if(lit)
		return max(fueluse - (world.time - burn_started), 0)
	return fueluse

/obj/machinery/light/rogue/proc/shows_fuel()
	return !endless()

/obj/machinery/light/rogue/proc/can_ignite()
	return !lit && fuel_left() > 0

/obj/machinery/light/rogue/proc/ignite(silent = FALSE)
	if(!can_ignite())
		return FALSE
	lit = TRUE
	burn_started = world.time
	GLOB.rockhill_lit_fires += src
	set_light_on(TRUE)
	update_appearance(UPDATE_ICON_STATE)
	schedule_burn_out()
	if(!silent)
		playsound(src, ROCKHILL_FIRE_LIGHT_SOUND, 100, TRUE)
	return TRUE

/obj/machinery/light/rogue/proc/schedule_burn_out()
	deltimer(burn_timer)
	burn_timer = null
	var/left = fuel_left()
	if(left != INFINITY)
		burn_timer = addtimer(CALLBACK(src, PROC_REF(burn_out)), left, TIMER_STOPPABLE | TIMER_DELETE_ME)

/obj/machinery/light/rogue/proc/burn_out(silent = FALSE)
	if(!lit)
		return FALSE
	if(!endless())
		fueluse = fuel_left()
	lit = FALSE
	GLOB.rockhill_lit_fires -= src
	deltimer(burn_timer)
	burn_timer = null
	set_light_on(FALSE)
	update_appearance(UPDATE_ICON_STATE)
	if(!silent)
		playsound(src, ROCKHILL_FIRE_SNUFF_SOUND, 100, TRUE)
	return TRUE

/obj/machinery/light/rogue/proc/snuff(mob/user)
	if(!burn_out())
		return FALSE
	user?.visible_message(span_warning("[user] snuffs [src]."))
	return TRUE

/obj/machinery/light/rogue/proc/add_fuel(amount)
	var/left = fuel_left()
	if(lit)
		fueluse = min(left + amount, initial(fueluse))
		burn_started = world.time
		schedule_burn_out()
	else
		fueluse = min(left + amount, initial(fueluse))

/obj/machinery/light/rogue/update_icon_state()
	. = ..()
	if(base_state)
		set_fire_state("[base_state][lit ? 1 : 0]")

/obj/machinery/light/rogue/proc/set_fire_state(state)
	if(icon_exists(icon, state))
		icon_state = state

/obj/machinery/light/rogue/examine(mob/user)
	. = ..()
	if(!shows_fuel() || !user.Adjacent(src))
		return
	var/left = fuel_left()
	if(left <= 0)
		. += span_warning("The fire is burned out and hungry...")
		return
	var/minutes = round(left / (1 MINUTES))
	. += span_info("The fire will last for [minutes <= 1 ? "less than a minute" : "[minutes] minutes"].")

/obj/machinery/light/rogue/fire_act(exposed_temperature, exposed_volume)
	ignite()

/obj/machinery/light/rogue/extinguish()
	. = ..()
	if(burn_out())
		new /obj/effect/temp_visual/small_smoke(loc)

/obj/machinery/light/rogue/proc/on_entered(datum/source, atom/movable/arrived)
	SIGNAL_HANDLER
	if(!lit || !isliving(arrived))
		return
	var/mob/living/victim = arrived
	victim.adjust_fire_stacks(ROCKHILL_FIRE_CROSS_STACKS)
	victim.ignite_mob()

/obj/machinery/light/rogue/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/flashlight/flare))
		var/obj/item/flashlight/flare/flare = tool
		if(lit && !flare.light_on)
			if(flare.ignition(user) == ROCKHILL_FLARE_IGNITED)
				user.visible_message(span_info("[user] lights [flare] in [src]."))
			return ITEM_INTERACT_SUCCESS
	if(!lit && tool.get_temperature())
		if(ignite())
			user.visible_message(span_info("[user] lights [src]."))
		else
			balloon_alert(user, "won't light!")
		return ITEM_INTERACT_SUCCESS
	if(lit && istype(tool, /obj/item/natural/dirtclod))
		if(!user.temporarilyRemoveItemFromInventory(tool))
			return ITEM_INTERACT_BLOCKING
		qdel(tool)
		snuff(user)
		return ITEM_INTERACT_SUCCESS
	if(tool.firefuel && !no_refuel && !endless())
		return try_refuel(user, tool)
	return ..()

/obj/machinery/light/rogue/proc/try_refuel(mob/living/user, obj/item/fuel)
	if(fuel_left() > initial(fueluse) - ROCKHILL_FIRE_FULL_MARGIN)
		balloon_alert(user, "fully fueled")
		return ITEM_INTERACT_BLOCKING
	if(tgui_alert(user, "Fuel [src] with [fuel]?", "Fuel", list("Yes", "No")) != "Yes")
		return ITEM_INTERACT_BLOCKING
	if(QDELETED(fuel) || user.get_active_held_item() != fuel || !user.Adjacent(src))
		return ITEM_INTERACT_BLOCKING
	if(!user.temporarilyRemoveItemFromInventory(fuel))
		return ITEM_INTERACT_BLOCKING
	user.visible_message(span_warning("[user] feeds [fuel] to [src]."))
	add_fuel(fuel.firefuel)
	qdel(fuel)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/light/rogue/candle/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(. || !lit)
		return
	return snuff(user)

/obj/machinery/light/rogue/chand/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(. || !lit)
		return
	return snuff(user)

/obj/machinery/light/rogue/campfire/attack_hand_secondary(mob/living/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || !lit || !user.can_perform_action(src))
		return
	snuff(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/light/rogue/campfire/rogue_onkick(mob/living/carbon/human/kicker)
	if(lit)
		snuff(kicker)

/obj/machinery/light/rogue/firebowl/standing
	var/knocked_over = FALSE

/obj/machinery/light/rogue/firebowl/standing/can_ignite()
	return !knocked_over && ..()

/obj/machinery/light/rogue/firebowl/standing/update_icon_state()
	. = ..()
	if(knocked_over)
		set_fire_state("[base_state]over")

/obj/machinery/light/rogue/firebowl/standing/rogue_onkick(mob/living/carbon/human/kicker)
	playsound(src, ROCKHILL_FIRE_KICK_SOUND, 100, TRUE)
	if(knocked_over || !prob(kicker.rogue_stat(ROGUE_STAT_STRENGTH) * ROCKHILL_FIRE_TOPPLE_PER_STRENGTH))
		kicker.visible_message(span_warning("[kicker] kicks [src]!"))
		return
	kicker.visible_message(span_warning("[kicker] kicks over [src]!"))
	knocked_over = TRUE
	if(!burn_out())
		update_appearance(UPDATE_ICON_STATE)

/obj/machinery/light/rogue/firebowl/standing/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(. || !knocked_over)
		return
	user.visible_message(span_notice("[user] starts to pick up [src]..."))
	if(!do_after(user, ROCKHILL_FIRE_RAISE_TIME, target = src) || !knocked_over)
		return TRUE
	knocked_over = FALSE
	update_appearance(UPDATE_ICON_STATE)
	return TRUE

/obj/machinery/light/rogue/torchholder
	var/obj/item/flashlight/flare/torch/torch
	var/torch_off_state = "torchwall0"

/obj/machinery/light/rogue/torchholder/Initialize(mapload)
	torch = new(src)
	return ..()

/obj/machinery/light/rogue/torchholder/Destroy()
	QDEL_NULL(torch)
	return ..()

/obj/machinery/light/rogue/torchholder/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone != torch)
		return
	burn_out(silent = TRUE)
	torch = null
	update_appearance(UPDATE_ICON_STATE)

/obj/machinery/light/rogue/torchholder/endless()
	return FALSE

/obj/machinery/light/rogue/torchholder/fuel_left()
	if(!torch)
		return 0
	if(lit)
		return max(torch.fuel - (world.time - burn_started), 0)
	return torch.fuel

/obj/machinery/light/rogue/torchholder/burn_out(silent = FALSE)
	if(lit && torch)
		torch.fuel = fuel_left()
		burn_started = world.time
	return ..()

/obj/machinery/light/rogue/torchholder/shows_fuel()
	return !!torch

/obj/machinery/light/rogue/torchholder/add_fuel(amount)
	return

/obj/machinery/light/rogue/torchholder/update_icon_state()
	. = ..()
	if(!torch)
		set_fire_state(base_state)
	else if(!lit)
		set_fire_state(torch_off_state)

/obj/machinery/light/rogue/torchholder/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(. || !torch)
		return
	var/was_lit = lit
	var/obj/item/flashlight/flare/torch/taken = torch
	burn_out(silent = TRUE)
	if(!user.put_in_hands(taken))
		taken.forceMove(drop_location())
	if(was_lit)
		taken.ignition()
	playsound(src, ROCKHILL_TORCH_TAKE_SOUND, 70, TRUE)
	return TRUE

/obj/machinery/light/rogue/torchholder/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/flashlight/flare/torch))
		return ..()
	var/obj/item/flashlight/flare/torch/held = tool
	if(torch)
		if(held.light_on && !lit)
			if(ignite())
				user.visible_message(span_info("[user] lights [src]."))
			else
				balloon_alert(user, "burned out!")
			return ITEM_INTERACT_SUCCESS
		if(!held.light_on && lit && held.ignition(user) == ROCKHILL_FLARE_IGNITED)
			user.visible_message(span_info("[user] lights [held] in [src]."))
		return ITEM_INTERACT_SUCCESS
	var/was_lit = held.light_on
	if(!user.transferItemToLoc(held, src))
		return ITEM_INTERACT_BLOCKING
	if(was_lit)
		held.turn_off()
		STOP_PROCESSING(SSobj, held)
	torch = held
	if(!was_lit || !ignite(silent = TRUE))
		update_appearance(UPDATE_ICON_STATE)
	playsound(src, ROCKHILL_TORCH_PUT_SOUND, 70, TRUE)
	return ITEM_INTERACT_SUCCESS

/// Ratwood's torch (flashlight.dm): a flame lights it - a fire, a lit torch, a spark (fire_act()) - and using it in hand
/// only snuffs a lit one. TG's flare lights itself in hand and never goes out from it.
/obj/item/flashlight/flare/torch/attack_self(mob/user)
	if(!rogue_combat_enabled())
		return ..()
	if(!fuel)
		to_chat(user, span_warning("[src] doesn't have any pitch left!"))
		return
	if(!light_on)
		to_chat(user, span_warning("I need a flame to light [src]."))
		return
	turn_off()
	playsound(src, 'modular_redtard/rockhill/sound/items/firesnuff.ogg', 100, TRUE)
	user.visible_message(span_notice("[user] snuffs out [src]."), span_notice("I snuff out [src]."))

/// Anything hot lights an unlit torch: a lit torch held to it, as Ratwood's lit torch sets what it touches alight.
/obj/item/flashlight/flare/torch/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!rogue_combat_enabled() || light_on || !tool.get_temperature())
		return ..()
	if(ignition(user) == ROCKHILL_FLARE_IGNITED)
		playsound(src, 'modular_redtard/rockhill/sound/items/firelight.ogg', 100, TRUE)
		user.visible_message(span_info("[user] lights [src] with [tool]."))
	return ITEM_INTERACT_SUCCESS
