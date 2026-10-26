#define SMELTER_SOUND 'modular_redtard/rockhill/sound/misc/smelter_sound.ogg'
#define SMELTER_DONE_SOUND 'modular_redtard/rockhill/sound/misc/smelter_fin.ogg'

/// Ratwood smelters (roguejobs/blacksmith/smelter.dm): ore and scrap go in, and after smelting_ticks of fire (2 seconds each,
/// SSobj instead of Ratwood's SSmachines) they are bars of the quality the smelter's skill gave each piece on the way in.
/obj/machinery/light/rogue/smelter
	/// What is inside, item to its smelting quality (Ratwood contained_items).
	var/list/contained = list()
	var/max_contained = 1
	var/smelting_progress = 0
	var/smelting_ticks = 20
	/// The smelt is running; the result cannot be taken out before it ends (Ratwood actively_smelting).
	var/smelting = FALSE

/obj/machinery/light/rogue/smelter/bronze
	max_contained = 4
	smelting_ticks = 40

/obj/machinery/light/rogue/smelter/great
	max_contained = 4
	smelting_ticks = 30

/obj/machinery/light/rogue/smelter/hiron
	max_contained = 6
	smelting_ticks = 45

/obj/machinery/light/rogue/smelter/Destroy()
	STOP_PROCESSING(SSobj, src)
	for(var/obj/item/inside as anything in contained)
		inside.forceMove(drop_location())
	contained.Cut()
	return ..()

/obj/machinery/light/rogue/smelter/Exited(atom/movable/gone, direction)
	. = ..()
	contained -= gone

/obj/machinery/light/rogue/smelter/examine(mob/user)
	. = ..()
	. += span_info("It can hold up to [max_contained] ores at a time.")
	. += span_info("Left click to insert an item. If it is a fuel item, a prompt will show on whether you want to fuel or smelt it. Right click on the furnace to put an item inside for smelting only.")
	if(length(contained))
		. += span_notice("Peeking inside, you can see:")
		for(var/obj/item/inside as anything in contained)
			. += span_info("- [inside]")

/obj/machinery/light/rogue/smelter/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/rogueweapon/tongs))
		return tongs_interaction(user, tool)
	if(istype(tool, /obj/item/rogueweapon/hammer))
		to_chat(user, span_warning("\The [tool] should be used at an anvil, not \the [src]!"))
		return ITEM_INTERACT_BLOCKING
	if(tool.firefuel && !no_refuel && !endless())
		var/fueled = try_refuel(user, tool)
		if(fueled == ITEM_INTERACT_SUCCESS || QDELETED(tool) || !tool.smeltresult)
			return fueled
	if(tool.smeltresult)
		add_item(tool, user)
		return ITEM_INTERACT_SUCCESS
	. = ..()
	if(!. && !tool.get_temperature())
		to_chat(user, span_warning("\The [tool] cannot be smelted."))
		return ITEM_INTERACT_BLOCKING

/// Ratwood attack_right(): smelting only, never fuel.
/obj/machinery/light/rogue/smelter/item_interaction_secondary(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/rogueweapon/tongs))
		return tongs_interaction(user, tool)
	if(tool.smeltresult)
		add_item(tool, user)
		return ITEM_INTERACT_SUCCESS
	return ..()

/obj/machinery/light/rogue/smelter/proc/tongs_interaction(mob/living/user, obj/item/rogueweapon/tongs/tongs)
	if(tongs.held_bar)
		if(length(contained) >= max_contained)
			to_chat(user, span_warning("\The [src] is already full!"))
			return ITEM_INTERACT_BLOCKING
		var/obj/item/bar = tongs.held_bar
		tongs.release_bar()
		add_item(bar, user)
		return ITEM_INTERACT_SUCCESS
	if(smelting)
		to_chat(user, span_warning("\The [src] is currently smelting. Wait for it to finish, or douse it with water to retrieve items from it."))
		return ITEM_INTERACT_BLOCKING
	if(!length(contained))
		to_chat(user, span_warning("Nothing to retrieve from inside."))
		return ITEM_INTERACT_BLOCKING
	var/obj/item/taken = contained[length(contained)]
	contained -= taken
	tongs.grab_bar(taken, lit)
	// Ratwood rewards taking out what the fire made, not burnt fuel or raw ore.
	if(istype(taken, /obj/item/ingot))
		user.rogue_craft_experience(/datum/attribute/skill/craft/smelting, user.rogue_stat(ROGUE_STAT_INTELLIGENCE) * 2)
	user.visible_message(span_info("[user] retrieves \the [taken] from \the [src]."), span_info("You retrieve \the [taken] from \the [src]."))
	return ITEM_INTERACT_SUCCESS

/// Bars only come out with tongs while the fire burns (Ratwood: no experience from bare-handed retrieval).
/obj/machinery/light/rogue/smelter/attack_hand(mob/living/user, list/modifiers)
	if(lit && length(contained))
		to_chat(user, span_warning("It's too hot to retrieve bars with your hands."))
		return TRUE
	if(length(contained))
		var/obj/item/taken = contained[length(contained)]
		contained -= taken
		taken.forceMove(drop_location())
		user.put_in_active_hand(taken)
		user.visible_message(span_info("[user] retrieves \the [taken] from \the [src]."))
		return TRUE
	return ..()

/// Ratwood add_item(): the smelter's skill decides each piece's bar quality as it goes in.
/obj/machinery/light/rogue/smelter/proc/add_item(obj/item/smelted, mob/living/user)
	if(length(contained) >= max_contained)
		to_chat(user, span_warning("\The [smelted.name] can be smelted, but \the [src] is full."))
		return FALSE
	if(smelted.loc == user && !user.transferItemToLoc(smelted, src))
		return FALSE
	if(smelted.loc != src)
		smelted.forceMove(src)
	contained[smelted] = smelt_quality(user)
	user.visible_message(span_warning("[user] puts something in \the [src]."))
	smelting_progress = 0
	if(lit)
		START_PROCESSING(SSobj, src)
	return TRUE

/// Ratwood: no skill 10-30, novice 25-30, apprentice 40-50 ... legendary 100-150, divided by 25, plus one; legendary is always excellent.
/obj/machinery/light/rogue/smelter/proc/smelt_quality(mob/living/user)
	if(!istype(user) || !user.mind)
		return ROGUE_SMELT_SPOIL
	var/rank = user.rogue_skill_rank(/datum/attribute/skill/craft/smelting)
	if(rank >= ROGUE_RANK_LEGENDARY)
		return ROGUE_SMELT_EXCELLENT
	return min(ROGUE_SMELT_EXCELLENT, floor(rand(rank * 15 + 10, max(30, rank * 25)) / 25) + 1)

/obj/machinery/light/rogue/smelter/ignite(silent = FALSE)
	. = ..()
	if(. && length(contained))
		START_PROCESSING(SSobj, src)

/obj/machinery/light/rogue/smelter/burn_out(silent = FALSE)
	smelting_progress = 0
	smelting = FALSE
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/machinery/light/rogue/smelter/process(seconds_per_tick)
	if(!lit || !length(contained))
		smelting = FALSE
		return PROCESS_KILL
	if(smelting_progress < smelting_ticks)
		smelting_progress++
		smelting = TRUE
		playsound(src, SMELTER_SOUND, 50, FALSE)
		return
	if(smelting_progress == smelting_ticks)
		smelt()
	return PROCESS_KILL

/// Ratwood handle_smelting(): every piece becomes its smeltresult with its own quality.
/obj/machinery/light/rogue/smelter/proc/smelt()
	var/alloy = alloy_result()
	if(alloy)
		var/mean_quality = ROGUE_SMELT_SPOIL
		var/list/load = contained
		contained = list()
		for(var/obj/item/inside as anything in load)
			mean_quality += load[inside]
		mean_quality = floor(mean_quality / length(load))
		for(var/obj/item/inside as anything in load)
			qdel(inside)
		for(var/i in 1 to alloy_count(alloy))
			var/obj/item/made = new alloy(src, mean_quality)
			contained[made] = mean_quality
	else
		for(var/obj/item/inside as anything in contained.Copy())
			if(!inside.smeltresult)
				continue
			var/quality = contained[inside]
			contained -= inside
			var/obj/item/made = new inside.smeltresult(src, quality)
			contained[made] = quality
			qdel(inside)
	playsound(src, SMELTER_DONE_SOUND, 100, FALSE)
	visible_message(span_notice("\The [src] finished smelting."))
	smelting_progress = smelting_ticks + 1
	smelting = FALSE

/// The alloy this load makes, if any (only the bronze melter and the great furnace alloy).
/obj/machinery/light/rogue/smelter/proc/alloy_result()
	return null

/obj/machinery/light/rogue/smelter/proc/alloy_count(alloy)
	return max_contained

/// Sums Ratwood's alloy weights of a load: list(alloy weight name = total).
/obj/machinery/light/rogue/smelter/proc/alloy_weights()
	. = list("coal" = 0, "iron" = 0, "bronze" = 0, "gilbranze" = 0, "blacksteel" = 0)
	for(var/obj/item/inside as anything in contained)
		switch(inside.smeltresult)
			if(/obj/item/rogueore/coal, /obj/item/rogueore/coal/charcoal)
				.["coal"]++
			if(/obj/item/ingot/iron)
				.["iron"]++
			if(/obj/item/ingot/tin)
				.["bronze"] += 1
			if(/obj/item/ingot/copper)
				.["bronze"] += 2
			if(/obj/item/ingot/aaslag)
				.["gilbranze"] += 3
			if(/obj/item/ingot/gold)
				.["gilbranze"] += 2
			if(/obj/item/ingot/silver)
				.["blacksteel"] += 1
			if(/obj/item/ingot/steel)
				.["blacksteel"] += 2

/// Ratwood bronze melter: three copper and a tin make four bronze bars.
/obj/machinery/light/rogue/smelter/bronze/alloy_result()
	var/list/weights = alloy_weights()
	if(weights["bronze"] == 7)
		return /obj/item/ingot/bronze
	return null

/// Ratwood great furnace: a coal and three iron make four steel, bronze as the melter, three slag and a gold make four
/// gilbranze, three steel and a silver make two blacksteel.
/obj/machinery/light/rogue/smelter/great/alloy_result()
	var/list/weights = alloy_weights()
	if(weights["coal"] == 1 && weights["iron"] == 3)
		return /obj/item/ingot/steel
	if(weights["bronze"] == 7)
		return /obj/item/ingot/bronze
	if(weights["gilbranze"] == 11)
		return /obj/item/ingot/gilbranze
	if(weights["blacksteel"] == 7)
		return /obj/item/ingot/blacksteel
	return null

/obj/machinery/light/rogue/smelter/great/alloy_count(alloy)
	return alloy == /obj/item/ingot/blacksteel ? 2 : 4

#undef SMELTER_SOUND
#undef SMELTER_DONE_SOUND
