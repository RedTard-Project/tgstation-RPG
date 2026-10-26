#define QUENCH_SOUNDS list('modular_redtard/rockhill/sound/items/quench_barrel1.ogg', 'modular_redtard/rockhill/sound/items/quench_barrel2.ogg')
/// Water a quench takes from a bin (Ratwood roguebin attackby()).
#define QUENCH_WATER 5

/// Ratwood tongs (roguejobs/blacksmith/tools.dm): carry one bar from the smelter to the forge, the anvil and the water bin.
/// A bar is hot for ROGUE_BAR_HEAT_TIME after the forge or a lit smelter; the sprite shows the bar and its glow
/// (Ratwood "<tongs>i0"/"<tongs>i1" states).
/obj/item/rogueweapon/tongs
	/// The bar or piece in the jaws (Ratwood hingot).
	var/obj/item/held_bar
	/// world.time the held bar cools at (Ratwood hott).
	var/hot_until = 0
	var/cool_timer
	/// Integrity lost per heating; stone tongs crumble in the forge (Ratwood forge attackby()).
	var/heat_wear = 0

/obj/item/rogueweapon/tongs/Destroy()
	if(held_bar)
		held_bar.forceMove(drop_location())
	deltimer(cool_timer)
	return ..()

/obj/item/rogueweapon/tongs/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone != held_bar)
		return
	held_bar = null
	cool()

/obj/item/rogueweapon/tongs/examine(mob/user)
	. = ..()
	if(held_bar)
		. += span_info("It holds \a [held_bar].")
	if(is_hot())
		. += span_warning("The tip is hot to the touch.")

/obj/item/rogueweapon/tongs/update_icon_state()
	. = ..()
	var/base = initial(icon_state)
	var/held_state = "[base]i[is_hot() ? 1 : 0]"
	icon_state = held_bar && icon_exists(icon, held_state) ? held_state : base

/obj/item/rogueweapon/tongs/get_temperature()
	return is_hot() ? FIRE_MINIMUM_TEMPERATURE_TO_SPREAD : ..()

/obj/item/rogueweapon/tongs/proc/is_hot()
	return held_bar && hot_until > world.time

/obj/item/rogueweapon/tongs/proc/grab_bar(obj/item/bar, hot = FALSE, heat_left = ROGUE_BAR_HEAT_TIME)
	bar.forceMove(src)
	held_bar = bar
	if(hot && heat_left > 0)
		heat(heat_left)
	else
		update_appearance(UPDATE_ICON_STATE)

/// Lets go of the bar; it stays in the jaws until the caller moves it.
/obj/item/rogueweapon/tongs/proc/release_bar()
	. = held_bar
	held_bar = null
	cool()

/obj/item/rogueweapon/tongs/proc/heat(duration = ROGUE_BAR_HEAT_TIME)
	hot_until = world.time + duration
	deltimer(cool_timer)
	cool_timer = addtimer(CALLBACK(src, PROC_REF(cool)), duration, TIMER_STOPPABLE | TIMER_DELETE_ME)
	update_appearance(UPDATE_ICON_STATE)

/obj/item/rogueweapon/tongs/proc/cool()
	hot_until = 0
	deltimer(cool_timer)
	cool_timer = null
	update_appearance(UPDATE_ICON_STATE)

/obj/item/rogueweapon/tongs/proc/heat_left()
	return max(hot_until - world.time, 0)

/obj/item/rogueweapon/tongs/attack_self(mob/user, modifiers)
	if(!held_bar || !isturf(user.loc))
		return ..()
	held_bar.forceMove(user.loc)
	return TRUE

/obj/item/rogueweapon/tongs/dropped(mob/user, silent)
	. = ..()
	if(held_bar)
		held_bar.forceMove(drop_location())

/// Picks a bar up off the floor or a table (Ratwood ingot attackby()) and quenches finished work (Ratwood roguebin attackby()).
/obj/item/rogueweapon/tongs/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(user.combat_mode)
		return NONE
	if(held_bar && rogue_water_source(interacting_with))
		quench(interacting_with, user)
		return ITEM_INTERACT_SUCCESS
	if(!held_bar && istype(interacting_with, /obj/item/ingot) && isturf(interacting_with.loc))
		grab_bar(interacting_with)
		return ITEM_INTERACT_SUCCESS
	return NONE

/obj/item/rogueweapon/tongs/proc/quench(atom/water, mob/living/user)
	var/datum/component/rogue_forging/forging = held_bar.GetComponent(/datum/component/rogue_forging)
	if(forging?.stage != ROGUE_FORGING_COMPLETE)
		to_chat(user, span_warning("This item isn't finished yet, it requires more work."))
		return
	if(!is_hot())
		to_chat(user, span_warning("The ingot must be hot to temper the metal."))
		return
	if(!rogue_take_quench_water(water))
		to_chat(user, span_warning("Need more water to quench in."))
		return
	playsound(water, pick(QUENCH_SOUNDS), 100, FALSE)
	var/obj/item/work = release_bar()
	work.forceMove(get_turf(water))
	forging.create_goods(get_turf(water), user)

/// Ratwood quenches in a wood bin of water; a mapped water bin without reagents counts as full, and so does open water.
/proc/rogue_water_source(atom/target)
	if(istype(target, /turf/open/water))
		return TRUE
	if(!istype(target, /obj/item/roguebin) || istype(target, /obj/item/roguebin/trash))
		return FALSE
	return target.reagents ? target.reagents.has_reagent(/datum/reagent/water) : istype(target, /obj/item/roguebin/water)

/proc/rogue_take_quench_water(atom/water)
	if(!water.reagents)
		return TRUE
	if(!water.reagents.has_reagent(/datum/reagent/water, QUENCH_WATER))
		return FALSE
	water.reagents.remove_reagent(/datum/reagent/water, QUENCH_WATER)
	return TRUE

#undef QUENCH_SOUNDS
#undef QUENCH_WATER
