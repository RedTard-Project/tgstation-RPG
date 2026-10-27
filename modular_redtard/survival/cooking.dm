/// Ratwood cookonme (code/game/objects/lighting/_base_roguelight.dm): food can be roasted over this fire while it burns.
/obj/machinery/light/rogue/var/cookonme = FALSE

/obj/machinery/light/rogue/campfire
	cookonme = TRUE

/obj/machinery/light/rogue/firebowl
	cookonme = TRUE

/obj/machinery/light/rogue/firebowl/standing
	cookonme = FALSE

/obj/machinery/light/rogue/hearth
	cookonme = TRUE

/// Ratwood roasting over an open fire (_base_roguelight.dm attackby()): food in the hand and something to skewer it with in the
/// other, six turns of three seconds (faster with cooking skill), each a quarter of the food's cook time. Without cooking skill
/// the first turn burns it a third of the time (a hundredth with any skill). The heat is TG grilling.
/obj/machinery/light/rogue/proc/roast_over(mob/living/user, obj/item/reagent_containers/food/food)
	if(!food.can_spit_roast())
		to_chat(user, span_warning("I wouldn't be able to cook this over the fire..."))
		return ITEM_INTERACT_BLOCKING
	if(!user.is_holding(food) || !has_skewer(user.get_inactive_held_item()))
		return NONE
	var/datum/component/grillable/grill = food.GetComponent(/datum/component/grillable)
	if(!grill || !food.cooktime)
		to_chat(user, span_warning("[food] won't cook any further."))
		return ITEM_INTERACT_BLOCKING
	var/divisor = rogue_cook_divisor(user)
	var/spoil_chance = user.rogue_skill_rank(/datum/attribute/skill/craft/cooking) ? 1 : 33
	var/rolled = FALSE
	user.visible_message(span_notice("[user] starts to cook [food] over [src]."))
	for(var/i in 1 to 6)
		if(!do_after(user, 3 SECONDS / divisor, target = src) || !lit || QDELETED(food) || !user.is_holding(food))
			break
		if(!rolled)
			rolled = TRUE
			if(prob(spoil_chance))
				user.visible_message(span_warning("[user] burns [food]."))
				qdel(food)
				user.put_in_hands(new ROGUE_BURNT_FOOD(drop_location()))
				break
		SEND_SIGNAL(food, COMSIG_ITEM_GRILL_PROCESS, src, food.cooktime / 40)
		if(QDELETED(food))
			var/obj/item/cooked = food.cooked_into?.resolve()
			if(cooked)
				user.put_in_hands(cooked)
			break
	return ITEM_INTERACT_SUCCESS

/// Ratwood wants an item with a stabbing intent in the other hand to hold the food over the flames.
/obj/machinery/light/rogue/proc/has_skewer(obj/item/held)
	if(!held)
		return FALSE
	for(var/intent_type in held.rogue_intents())
		var/datum/intent/intent = rogue_intent(intent_type)
		if(intent?.blade_class == BCLASS_STAB)
			return TRUE
	return FALSE

/obj/machinery/light/rogue/campfire/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(cookonme && lit && istype(tool, /obj/item/reagent_containers/food))
		. = roast_over(user, tool)
		if(.)
			return .
	return ..()

/obj/machinery/light/rogue/firebowl/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(cookonme && lit && istype(tool, /obj/item/reagent_containers/food))
		. = roast_over(user, tool)
		if(.)
			return .
	return ..()

/// Ratwood hearth (code/game/objects/lighting/rogue_fires.dm): a pan or a pot sits on it; food fries in the pan while the hearth
/// burns (TG grilling, sped up by the skill of whoever put the food in), a pot heats what is in it. Right click fans the
/// flames for extra cooking.
/obj/machinery/light/rogue/hearth
	/// The pan or pot on the hearth.
	var/obj/item/attachment
	/// What fries in the pan.
	var/obj/item/reagent_containers/food/food
	/// Whose skill speeds the cooking (Ratwood lastuser).
	var/datum/weakref/cook
	/// Bubbling of a boiling pot (Ratwood boilloop), made when first needed.
	var/datum/looping_sound/boiling/boilloop

/obj/machinery/light/rogue/hearth/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(boilloop)
	clear_heat()
	var/atom/spot = drop_location()
	food?.forceMove(spot)
	attachment?.forceMove(spot)
	food = null
	attachment = null
	return ..()

/obj/machinery/light/rogue/hearth/ignite(silent = FALSE)
	. = ..()
	if(.)
		spread_heat()
		START_PROCESSING(SSobj, src)
		if(food)
			SEND_SIGNAL(food, COMSIG_ITEM_GRILL_TURNED_ON)
			update_appearance(UPDATE_OVERLAYS)

/obj/machinery/light/rogue/hearth/burn_out(silent = FALSE)
	. = ..()
	if(.)
		clear_heat()
		STOP_PROCESSING(SSobj, src)
		update_boiling()
		if(food)
			SEND_SIGNAL(food, COMSIG_ITEM_GRILL_TURNED_OFF)
			update_appearance(UPDATE_OVERLAYS)

/obj/machinery/light/rogue/hearth/process(seconds_per_tick)
	if(!lit)
		return PROCESS_KILL
	cook_tick(seconds_per_tick, rogue_cook_divisor(cook?.resolve()))

/// Ratwood try_cook(): one round of heat for the pan or the pot. What the food fries into stays in the pan.
/obj/machinery/light/rogue/hearth/proc/cook_tick(seconds, divisor)
	if(istype(attachment, /obj/item/cooking/pan) && food)
		var/obj/item/reagent_containers/food/frying = food
		SEND_SIGNAL(frying, COMSIG_ITEM_GRILL_PROCESS, src, HAS_TRAIT(frying, TRAIT_GRILLABLE) ? seconds * divisor : seconds)
		if(QDELETED(frying))
			var/obj/item/reagent_containers/food/fried = frying.cooked_into?.resolve()
			if(istype(fried) && fried.loc == src)
				put_in_pan(fried)
	else if(istype(attachment, /obj/item/reagent_containers/glass/bucket/pot) && attachment.reagents)
		attachment.reagents.expose_temperature(ROGUE_HEARTH_HEAT, ROGUE_HEARTH_HEAT_COEFF * seconds / ROGUE_REAGENT_TICK)
		update_boiling()

/obj/machinery/light/rogue/hearth/update_overlays()
	. = ..()
	for(var/obj/item/shown as anything in list(attachment, food))
		if(!shown)
			continue
		var/mutable_appearance/look = new(shown)
		look.pixel_x = 0
		look.pixel_y = 0
		look.layer = FLOAT_LAYER
		look.plane = FLOAT_PLANE
		. += look

/obj/machinery/light/rogue/hearth/examine(mob/user)
	. = ..()
	if(!attachment)
		return
	if(istype(attachment, /obj/item/cooking/pan))
		. += food ? "There's \a [attachment] on it with \a [food] in it." : "There's \a [attachment] on it."
	else if(istype(attachment, /obj/item/reagent_containers/glass/bucket/pot))
		var/boiling = attachment.reagents?.chem_temp > ROGUE_STEW_TEMPERATURE
		. += "There's \a [attachment] on it[boiling ? ", it is boiling" : ". It is not boiling"]."
	else
		. += "There's \a [attachment] on it."
	. += span_notice("Right click to start fanning the flame and make it cook faster.")

/obj/machinery/light/rogue/hearth/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!attachment && (istype(tool, /obj/item/cooking/pan) || istype(tool, /obj/item/reagent_containers/glass/bucket/pot)))
		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING
		attachment = tool
		playsound(src, 'modular_redtard/survival/sound/shovel_drop.ogg', 40, TRUE, -1)
		update_appearance(UPDATE_OVERLAYS)
		return ITEM_INTERACT_SUCCESS
	if(istype(attachment, /obj/item/reagent_containers/glass/bucket/pot) && istype(tool, /obj/item/reagent_containers/glass/bowl))
		to_chat(user, span_notice("Remove the pot from the hearth first."))
		return ITEM_INTERACT_BLOCKING
	if(istype(attachment, /obj/item/reagent_containers/glass/bucket/pot))
		. = pot_interaction(user, tool)
		if(.)
			return .
	if(istype(attachment, /obj/item/cooking/pan) && !food && istype(tool, /obj/item/reagent_containers/food))
		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING
		put_in_pan(tool, user)
		return ITEM_INTERACT_SUCCESS
	if(cookonme && lit && istype(tool, /obj/item/reagent_containers/food))
		. = roast_over(user, tool)
		if(.)
			return .
	return ..()

/// Food goes into the pan: by a cook (whose skill speeds the frying) or as what the last food fried into.
/obj/machinery/light/rogue/hearth/proc/put_in_pan(obj/item/reagent_containers/food/new_food, mob/living/user)
	food = new_food
	if(user)
		cook = WEAKREF(user)
		SEND_SIGNAL(food, COMSIG_ITEM_GRILL_PLACED, user)
		playsound(src, 'modular_redtard/survival/sound/frying.ogg', 80, FALSE, 5)
	if(lit)
		SEND_SIGNAL(food, COMSIG_ITEM_GRILL_TURNED_ON)
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/light/rogue/hearth/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == food)
		SEND_SIGNAL(food, COMSIG_ITEM_GRILL_TURNED_OFF)
		food = null
		update_appearance(UPDATE_OVERLAYS)
	else if(gone == attachment)
		attachment = null
		update_boiling()
		update_appearance(UPDATE_OVERLAYS)

/// Ratwood hearth attack_hand(): take the food out of the pan, then the pan or the pot; with nothing on it, warm the hands.
/obj/machinery/light/rogue/hearth/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	var/obj/item/taken = food || attachment
	if(taken)
		if(!user.put_in_active_hand(taken))
			taken.forceMove(drop_location())
		return TRUE
	if(lit)
		INVOKE_ASYNC(src, PROC_REF(warm_hands), user, 1.5 SECONDS, ROGUE_HAND_WARMTH)
		return TRUE

/// Ratwood hearth attack_right(): fan the flames, every two seconds (faster with skill) one more round of cooking.
/obj/machinery/light/rogue/hearth/attack_hand_secondary(mob/living/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || !lit || !attachment)
		return
	INVOKE_ASYNC(src, PROC_REF(fan_flames), user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/light/rogue/hearth/proc/fan_flames(mob/living/user)
	var/divisor = rogue_cook_divisor(user)
	while(lit && attachment && do_after(user, 2 SECONDS / divisor, target = src))
		to_chat(user, span_info("I fan the flame on [src]."))
		cook_tick(2, divisor)

/// Ratwood hearth onkick(): a kick snuffs it.
/obj/machinery/light/rogue/hearth/rogue_onkick(mob/living/carbon/human/kicker)
	if(lit)
		snuff(kicker)

/// Ratwood oven (code/modules/roguetown/roguejobs/cook/tools/oven.dm): up to five items go in through the top of the sprite and
/// bake while it burns, at half the speed of a pan (sped up by the skill of whoever last used it). The food sits on a TG oven
/// tray inside, so it bakes with TG's /datum/component/bakeable.
/obj/machinery/light/rogue/oven
	var/obj/item/plate/oven_tray/tray
	var/max_food = 5
	var/datum/weakref/cook

/obj/machinery/light/rogue/oven/Initialize(mapload)
	tray = new(src)
	tray.max_items = max_food
	return ..()

/obj/machinery/light/rogue/oven/Destroy()
	STOP_PROCESSING(SSobj, src)
	for(var/obj/item/inside in tray)
		inside.forceMove(drop_location())
	QDEL_NULL(tray)
	return ..()

/// Ratwood oven Crossed() does nothing: walking past it does not set anyone on fire.
/obj/machinery/light/rogue/oven/on_entered(datum/source, atom/movable/arrived)
	SIGNAL_HANDLER
	return

/obj/machinery/light/rogue/oven/ignite(silent = FALSE)
	. = ..()
	if(.)
		START_PROCESSING(SSobj, src)

/obj/machinery/light/rogue/oven/burn_out(silent = FALSE)
	. = ..()
	if(.)
		STOP_PROCESSING(SSobj, src)

/obj/machinery/light/rogue/oven/process(seconds_per_tick)
	if(!lit)
		return PROCESS_KILL
	if(!length(tray?.contents))
		return
	var/divisor = rogue_cook_divisor(cook?.resolve())
	var/burning = FALSE
	var/list/before = tray.contents.Copy()
	for(var/obj/item/baked as anything in before)
		var/result = SEND_SIGNAL(baked, COMSIG_ITEM_OVEN_PROCESS, src, seconds_per_tick * 0.5 * (HAS_TRAIT(baked, TRAIT_BAKEABLE) ? divisor : 1))
		if(result & COMPONENT_BAKING_BAD_RESULT)
			burning = TRUE
	if(burning && SPT_PROB(5, seconds_per_tick))
		visible_message(span_warning("You smell a burnt smell coming from [src]!"))
	if(length(before ^ tray.contents))
		update_food_view()

/// Ratwood oven: a click on the upper part of the sprite puts the item in or takes the last one out.
/obj/machinery/light/rogue/oven/proc/clicked_top(list/modifiers)
	return text2num(LAZYACCESS(modifiers, ICON_Y)) > 14

/obj/machinery/light/rogue/oven/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!clicked_top(modifiers) || (tool.item_flags & ABSTRACT) || HAS_TRAIT(tool, TRAIT_NODROP) || tool.wlength > WLENGTH_NORMAL)
		return ..()
	if(length(tray.contents) >= max_food)
		balloon_alert(user, "it's full!")
		return ITEM_INTERACT_BLOCKING
	if(!user.transferItemToLoc(tool, tray))
		return ITEM_INTERACT_BLOCKING
	tray.AddToPlate(tool)
	cook = WEAKREF(user)
	SEND_SIGNAL(tool, COMSIG_ITEM_OVEN_PLACED_IN, src, user)
	playsound(src, 'modular_redtard/survival/sound/gen_drop.ogg', 50, TRUE)
	user.visible_message(span_warning("[user] puts something in the oven."))
	update_food_view()
	return ITEM_INTERACT_SUCCESS

/obj/machinery/light/rogue/oven/attack_hand(mob/living/user, list/modifiers)
	if(!clicked_top(modifiers) || !length(tray.contents))
		return ..()
	var/obj/item/taken = tray.contents[length(tray.contents)]
	cook = WEAKREF(user)
	if(!user.put_in_active_hand(taken))
		taken.forceMove(drop_location())
	update_food_view()
	return TRUE

/obj/machinery/light/rogue/oven/examine(mob/user)
	. = ..()
	. += span_notice("Put food in through the top; it bakes while the oven burns. [length(tray?.contents)] of [max_food] places are taken.")

/// Ratwood oven update_icon(): what bakes shows small inside, over the dark of the oven.
/obj/machinery/light/rogue/oven/proc/update_food_view()
	underlays.Cut()
	if(!length(tray?.contents))
		return
	if(icon_exists(icon, "oven_under"))
		var/mutable_appearance/inside = mutable_appearance(icon, "oven_under")
		inside.layer = layer + 0.01
		underlays += inside
	var/index = 0
	for(var/obj/item/baked in tray.contents)
		var/mutable_appearance/look = new(baked)
		look.transform = matrix() * 0.5
		look.pixel_x = 0
		look.pixel_y = 0
		look.pixel_w = 0
		look.pixel_z = (index++ * 3) % 7 - 2
		look.plane = plane
		look.layer = layer + 0.02
		underlays += look
