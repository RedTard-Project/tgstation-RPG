/// Ratwood stone forge (roguejobs/blacksmith/forge.dm): a lit forge heats the bar in the tongs for heat_time.
/obj/machinery/light/rogue/forge
	/// Deciseconds a bar heated here stays hot; null takes bar_heat_time of config/redtard/mechanics/values/crafting.txt.
	var/heat_time

/obj/machinery/light/rogue/forge/examine(mob/user)
	. = ..()
	. += span_info("Hold a bar in tongs to the lit forge to heat it for the anvil.")

/obj/machinery/light/rogue/forge/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/rogueweapon/tongs) || !lit)
		return ..()
	var/obj/item/rogueweapon/tongs/tongs = tool
	if(!tongs.held_bar)
		return ..()
	tongs.heat(isnull(heat_time) ? ROGUE_BAR_HEAT_TIME : heat_time)
	user.visible_message(span_info("[user] heats the bar."))
	if(tongs.heat_wear)
		tongs.take_damage(tongs.heat_wear, sound_effect = FALSE)
	return ITEM_INTERACT_SUCCESS
