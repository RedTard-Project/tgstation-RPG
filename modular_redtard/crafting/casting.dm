// Ratwood casting (roguejobs/blacksmith/casting.dm, anvil_recipes/blades.dm, lighting/rogue_fires.dm): iron or steel bars melt
// in a clay crucible set on a hearth, the molten metal is poured through a sprue and funnel into a steel mold, and after two
// minutes the mold gives a cast blade. A blade is laid on the anvil in place of a bar for the recipes that name it
// (req_blade): no heat is needed, one bar fewer is added, and the work is finished on the anvil without a quench.

/// Bars a crucible holds (Ratwood max_ingots).
#define CRUCIBLE_MAX_INGOTS 5
/// Heat at which the metal is molten (Ratwood heat_capacity).
#define CRUCIBLE_HEAT_FULL 100
/// Ratwood heat_rate and cool_rate: 10 and 5 per two-second hearth tick.
#define CRUCIBLE_HEAT_PER_SECOND 5
#define CRUCIBLE_COOL_PER_SECOND 2.5
/// Every fourth bar of a metal put in counts twice (Ratwood duplication_threshold).
#define CRUCIBLE_BONUS_EVERY 4
/// Time to set a bar into the crucible on the hearth (Ratwood hearth attackby()).
#define CRUCIBLE_ADD_TIME (1 SECONDS)
#define CRUCIBLE_PLACE_SOUND 'modular_redtard/survival/sound/shovel_drop.ogg'
#define CRUCIBLE_MOLTEN_SOUND 'modular_redtard/rockhill/sound/items/firelight.ogg'
/// Ratwood pour do_after and cooling_time (120 one-second ticks).
#define MOLD_POUR_TIME (3 SECONDS)
#define MOLD_COOLING_TIME (2 MINUTES)
/// Ratwood overlay_color of iron blades.
#define BLADE_IRON_COLOR "#808080"

/// Ratwood cast blades (anvil_recipes/blades.dm): what a mold makes; laid on the anvil in place of the recipe's bar.
/obj/item/blade
	parent_type = /obj/item/rockhill
	name = "blade"
	desc = "A cast blade waiting to be finished."
	icon = 'modular_redtard/rockhill/icons/roguetown/items/anvil_casting.dmi'
	icon_state = "blade_sword"
	w_class = WEIGHT_CLASS_NORMAL
	/// Ratwood quality: cast metal is always poor (SMELTERY_LEVEL_POOR).
	rogue_quality = ROGUE_QUALITY_ROUGH

/obj/item/blade/iron_axe
	name = "iron axe blade"
	icon_state = "blade_axe"
	color = BLADE_IRON_COLOR

/obj/item/blade/iron_mace
	name = "iron mace head"
	icon_state = "blade_mace"
	color = BLADE_IRON_COLOR

/obj/item/blade/iron_sword
	name = "iron sword blade"
	icon_state = "blade_sword"
	color = BLADE_IRON_COLOR

/obj/item/blade/iron_knife
	name = "iron knife blade"
	icon_state = "blade_knife"
	color = BLADE_IRON_COLOR

/obj/item/blade/iron_polearm
	name = "iron polearm blade"
	icon_state = "blade_polearm"
	color = BLADE_IRON_COLOR

/obj/item/blade/iron_plate
	name = "iron plate"
	desc = "A cast plate waiting to be finished."
	icon_state = "blade_plate"
	color = BLADE_IRON_COLOR

/obj/item/blade/steel_axe
	name = "steel axe blade"
	icon_state = "blade_axe"

/obj/item/blade/steel_mace
	name = "steel mace head"
	icon_state = "blade_mace"

/obj/item/blade/steel_sword
	name = "steel sword blade"
	icon_state = "blade_sword"

/obj/item/blade/steel_knife
	name = "steel knife blade"
	icon_state = "blade_knife"

/obj/item/blade/steel_polearm
	name = "steel polearm blade"
	icon_state = "blade_polearm"

/obj/item/blade/steel_plate
	name = "steel plate"
	desc = "A cast plate waiting to be finished."
	icon_state = "blade_plate"

/// Ratwood crucible: up to five iron or steel bars, set in on a hearth; a burning hearth melts them in twenty seconds, an
/// unlit one lets them set again. Carried off the hearth, the metal stays molten as in Ratwood.
/obj/item/reagent_containers/glass/crucible
	/// Bars of molten metal by bar type (Ratwood ingots).
	var/list/ingots = list()
	/// Bars of each metal put in so far, for the fourth-bar bonus (Ratwood ingots_added_total).
	var/list/ingots_added = list()
	/// 0 to CRUCIBLE_HEAT_FULL (Ratwood heat_progress).
	var/heat_progress = 0
	/// The metal is molten and can be poured.
	var/hot = FALSE

/obj/item/reagent_containers/glass/crucible/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/reagent_containers/glass/crucible/examine(mob/user)
	. = ..()
	if(!length(ingots))
		. += span_info("It's empty. Set it on a hearth and add iron or steel bars to melt them.")
		return
	. += span_info("It contains:")
	for(var/obj/item/ingot/metal as anything in ingots)
		var/count = ingots[metal]
		. += span_info("- [count] [initial(metal.name)][count > 1 ? "s" : ""]")
	if(hot)
		. += span_warning("It's glowing hot with molten metal!")
	else if(heat_progress > 0)
		. += span_info("It's [round(heat_progress)]% heated.")
	else
		. += span_warning("The metal has solidified.")

/obj/item/reagent_containers/glass/crucible/update_icon_state()
	. = ..()
	icon_state = (hot && length(ingots)) ? "crucible_full" : initial(icon_state)

/// Ratwood hearth attackby(): the crucible sits on a hearth like a pan or a pot.
/obj/item/reagent_containers/glass/crucible/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!istype(interacting_with, /obj/machinery/light/rogue/hearth) || user.combat_mode)
		return ..()
	var/obj/machinery/light/rogue/hearth/hearth = interacting_with
	if(hearth.attachment)
		to_chat(user, span_warning("There is already something on [hearth]."))
		return ITEM_INTERACT_BLOCKING
	if(!user.transferItemToLoc(src, hearth))
		return ITEM_INTERACT_BLOCKING
	hearth.attachment = src
	playsound(hearth, CRUCIBLE_PLACE_SOUND, 40, TRUE, -1)
	hearth.update_appearance(UPDATE_OVERLAYS)
	START_PROCESSING(SSobj, src)
	return ITEM_INTERACT_SUCCESS

/// Ratwood hearth try_cook() for a crucible: a burning hearth heats the bars, an unlit one lets them cool.
/obj/item/reagent_containers/glass/crucible/process(seconds_per_tick)
	var/obj/machinery/light/rogue/hearth/hearth = loc
	if(!istype(hearth) || hearth.attachment != src)
		return PROCESS_KILL
	if(!hearth.lit)
		cool_down(CRUCIBLE_COOL_PER_SECOND * seconds_per_tick)
	else if(total_ingots())
		heat_up(CRUCIBLE_HEAT_PER_SECOND * seconds_per_tick)

/obj/item/reagent_containers/glass/crucible/proc/heat_up(amount)
	heat_progress = min(heat_progress + amount, CRUCIBLE_HEAT_FULL)
	if(hot || heat_progress < CRUCIBLE_HEAT_FULL || !length(ingots))
		return
	hot = TRUE
	playsound(loc, CRUCIBLE_MOLTEN_SOUND, 50, TRUE)
	update_appearance(UPDATE_ICON_STATE)

/obj/item/reagent_containers/glass/crucible/proc/cool_down(amount)
	heat_progress = max(heat_progress - amount, 0)
	if(hot && heat_progress < CRUCIBLE_HEAT_FULL)
		hot = FALSE
		update_appearance(UPDATE_ICON_STATE)

/obj/item/reagent_containers/glass/crucible/proc/total_ingots()
	. = 0
	for(var/metal in ingots)
		. += ingots[metal]

/// The metal a bar melts as in a crucible: Ratwood takes only iron and steel.
/obj/item/reagent_containers/glass/crucible/proc/castable_metal(obj/item/ingot/bar)
	if(istype(bar, /obj/item/ingot/iron))
		return /obj/item/ingot/iron
	if(istype(bar, /obj/item/ingot/steel))
		return /obj/item/ingot/steel
	return null

/// Ratwood add_ingot(): a bar goes in; every fourth bar of a metal counts twice, and what does not fit falls out as a bar.
/obj/item/reagent_containers/glass/crucible/proc/add_ingot(obj/item/ingot/bar, mob/living/user)
	var/metal = castable_metal(bar)
	if(!metal)
		to_chat(user, span_warning("Only iron and steel can be cast."))
		return FALSE
	if(hot)
		to_chat(user, span_warning("The crucible is too hot to add ingots! Wait for it to cool down."))
		return FALSE
	if(total_ingots() >= CRUCIBLE_MAX_INGOTS)
		to_chat(user, span_warning("The crucible is full."))
		return FALSE
	user.visible_message(span_info("[user] places an ingot into the crucible."))
	if(!do_after(user, CRUCIBLE_ADD_TIME, target = isturf(loc) ? src : loc) || QDELETED(bar) || !user.is_holding(bar))
		return FALSE
	if(hot || total_ingots() >= CRUCIBLE_MAX_INGOTS)
		return FALSE
	qdel(bar)
	ingots_added[metal] += 1
	var/adding = 1
	var/bonus = FALSE
	if(ingots_added[metal] % CRUCIBLE_BONUS_EVERY == 0)
		ingots_added[metal] = 0
		bonus = TRUE
		adding = 2
	var/fits = min(adding, CRUCIBLE_MAX_INGOTS - total_ingots())
	ingots[metal] += fits
	for(var/overflow in 1 to adding - fits)
		var/obj/item/ingot/spilled = new metal(drop_location())
		to_chat(user, span_notice("The crucible overflows! An extra [spilled.name] falls to the ground."))
	if(bonus)
		to_chat(user, span_notice((fits == 2 ? "As you add the ingot, it seems to multiply in the crucible!" : "The ingot starts to multiply but the crucible is almost full!")))
	else
		to_chat(user, span_info("You add the ingot to the crucible."))
	heat_progress = 0
	update_appearance(UPDATE_ICON_STATE)
	return TRUE

/// The metal there is most of (Ratwood get_primary_metal()).
/obj/item/reagent_containers/glass/crucible/proc/primary_metal()
	var/most = 0
	for(var/metal in ingots)
		if(ingots[metal] > most)
			most = ingots[metal]
			. = metal

/// One bar's worth of the primary metal is poured out; an empty crucible goes cold (Ratwood mold attackby()).
/obj/item/reagent_containers/glass/crucible/proc/pour_metal()
	. = primary_metal()
	if(!.)
		return null
	ingots[.] -= 1
	if(ingots[.] <= 0)
		ingots -= .
	if(!total_ingots())
		heat_progress = 0
		hot = FALSE
	update_appearance(UPDATE_ICON_STATE)

/// Ratwood hearth attackby() with a crucible on it: bars are set into the crucible on the hearth.
/obj/item/ingot/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/obj/machinery/light/rogue/hearth/hearth = interacting_with
	if(!istype(hearth) || user.combat_mode)
		return ..()
	var/obj/item/reagent_containers/glass/crucible/crucible = hearth.attachment
	if(!istype(crucible))
		return ..()
	if(DOING_INTERACTION_WITH_TARGET(user, hearth))
		return ITEM_INTERACT_BLOCKING
	INVOKE_ASYNC(crucible, TYPE_PROC_REF(/obj/item/reagent_containers/glass/crucible, add_ingot), src, user)
	return ITEM_INTERACT_SUCCESS

/// Ratwood steel molds: a sprue and funnel goes on, a molten crucible pours one bar in, and the cast cools for two minutes.
/obj/item/mold
	/// What each metal casts into in this mold (Ratwood metal_to_blade); an unknown metal casts as iron.
	var/list/metal_to_blade = list(/obj/item/ingot/iron = /obj/item/blade/iron_sword)
	var/obj/item/sprue_funnel/attached_sprue
	var/pouring = FALSE
	/// The metal cooling inside (Ratwood cooling_metal_type); set while the cast solidifies.
	var/cooling_metal
	var/cool_timer

/obj/item/mold/axe
	metal_to_blade = list(/obj/item/ingot/iron = /obj/item/blade/iron_axe, /obj/item/ingot/steel = /obj/item/blade/steel_axe)

/obj/item/mold/sword
	metal_to_blade = list(/obj/item/ingot/iron = /obj/item/blade/iron_sword, /obj/item/ingot/steel = /obj/item/blade/steel_sword)

/obj/item/mold/knife
	metal_to_blade = list(/obj/item/ingot/iron = /obj/item/blade/iron_knife, /obj/item/ingot/steel = /obj/item/blade/steel_knife)

/obj/item/mold/mace
	metal_to_blade = list(/obj/item/ingot/iron = /obj/item/blade/iron_mace, /obj/item/ingot/steel = /obj/item/blade/steel_mace)

/obj/item/mold/polearm
	metal_to_blade = list(/obj/item/ingot/iron = /obj/item/blade/iron_polearm, /obj/item/ingot/steel = /obj/item/blade/steel_polearm)

/obj/item/mold/plate
	metal_to_blade = list(/obj/item/ingot/iron = /obj/item/blade/iron_plate, /obj/item/ingot/steel = /obj/item/blade/steel_plate)

/obj/item/mold/Destroy()
	deltimer(cool_timer)
	attached_sprue?.forceMove(drop_location())
	return ..()

/obj/item/mold/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == attached_sprue)
		attached_sprue = null
		update_appearance(UPDATE_OVERLAYS)

/obj/item/mold/examine(mob/user)
	. = ..()
	if(cooling_metal)
		. += span_info("The metal inside is still cooling.")
	else if(pouring)
		. += span_info("It has a sprue and funnel attached and is currently being poured.")
	else if(attached_sprue)
		. += span_info("It has a sprue and funnel attached, ready for pouring.")
	else
		. += span_info("It needs a sprue and funnel to be used.")

/obj/item/mold/update_overlays()
	. = ..()
	if(!attached_sprue)
		return
	var/mutable_appearance/sprue = mutable_appearance(icon, "sprue")
	sprue.pixel_w = -1
	. += sprue

/obj/item/mold/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/sprue_funnel))
		if(attached_sprue)
			to_chat(user, span_warning("This mold already has a sprue and funnel attached."))
			return ITEM_INTERACT_BLOCKING
		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING
		attached_sprue = tool
		update_appearance(UPDATE_OVERLAYS)
		user.visible_message(span_info("[user] attaches the sprue and funnel to the mold."))
		return ITEM_INTERACT_SUCCESS
	if(istype(tool, /obj/item/reagent_containers/glass/crucible))
		INVOKE_ASYNC(src, PROC_REF(pour), tool, user)
		return ITEM_INTERACT_SUCCESS
	return ..()

/// Ratwood mold attackby() with a crucible: three seconds of pouring, one bar of the primary metal, then the cast cools.
/obj/item/mold/proc/pour(obj/item/reagent_containers/glass/crucible/crucible, mob/living/user)
	if(!attached_sprue)
		to_chat(user, span_warning("This mold needs a sprue and funnel to pour metal into."))
		return
	if(pouring || cooling_metal)
		to_chat(user, span_warning("This mold is already being used."))
		return
	if(!crucible.hot)
		to_chat(user, span_warning("The metal in the crucible isn't hot enough to pour."))
		return
	if(!crucible.total_ingots())
		to_chat(user, span_warning("The crucible is empty."))
		return
	user.visible_message(span_info("[user] begins pouring molten metal into the mold."))
	pouring = TRUE
	var/poured = do_after(user, MOLD_POUR_TIME, target = src)
	pouring = FALSE
	if(!poured || QDELETED(crucible) || !crucible.hot || cooling_metal || !attached_sprue)
		return
	var/metal = crucible.pour_metal()
	if(!metal)
		to_chat(user, span_warning("Couldn't find the appropriate metal in the crucible."))
		return
	cooling_metal = metal
	cool_timer = addtimer(CALLBACK(src, PROC_REF(finish_cooling)), MOLD_COOLING_TIME, TIMER_STOPPABLE | TIMER_DELETE_ME)
	user.visible_message(span_info("[user] pours the molten metal into the mold. It will need time to cool and solidify."))

/// Ratwood finish_cooling(): the blade drops out and the sprue pops off.
/obj/item/mold/proc/finish_cooling()
	var/blade_type = LAZYACCESS(metal_to_blade, cooling_metal) || LAZYACCESS(metal_to_blade, /obj/item/ingot/iron)
	cooling_metal = null
	cool_timer = null
	var/turf/here = get_turf(src)
	if(blade_type)
		new blade_type(here)
	attached_sprue?.forceMove(here)
	visible_message(span_info("The metal in the mold has cooled and solidified. The sprue pops off!"))

/// Ratwood mold attack_hand(): an empty hand takes the sprue off a mold that is not in use.
/obj/item/mold/attack_hand(mob/user, list/modifiers)
	if(!attached_sprue || pouring || cooling_metal)
		return ..()
	var/obj/item/sprue = attached_sprue
	if(!user.put_in_hands(sprue))
		sprue.forceMove(drop_location())
	user.visible_message(span_info("[user] removes the sprue and funnel from the mold."))
	return TRUE

#undef CRUCIBLE_MAX_INGOTS
#undef CRUCIBLE_HEAT_FULL
#undef CRUCIBLE_HEAT_PER_SECOND
#undef CRUCIBLE_COOL_PER_SECOND
#undef CRUCIBLE_BONUS_EVERY
#undef CRUCIBLE_ADD_TIME
#undef CRUCIBLE_PLACE_SOUND
#undef CRUCIBLE_MOLTEN_SOUND
#undef MOLD_POUR_TIME
#undef MOLD_COOLING_TIME
#undef BLADE_IRON_COLOR
