// Vibelin's essence splitter (essence_machines/essence_splitter.dm) and extractor (extractor.dm): both turn items with a
// precursor (get_precursor_data()) into essences and push them out through their links. The splitter takes a batch of
// items at once and splits them after a while; the extractor drips ten times as much from one item over a long while.
// Fix on Vibelin: the splitter's sixth efficiency research now wins over the fifth (Vibelin checked the fifth first).

/obj/machinery/essence/splitter
	name = "essence splitter"
	desc = "A rather mundane machine used to extract alchemical essences from natural materials. Can process multiple items at once for efficiency."
	icon_state = "splitter"
	accepts_input = FALSE
	network_priority = 3
	processing_flags = START_PROCESSING_ON_INIT
	var/list/current_items = list()
	var/max_items = 0
	var/processing = FALSE

/obj/machinery/essence/splitter/storage_capacity()
	return rogue_essence_numbers().splitter_capacity

/obj/machinery/essence/splitter/storage_types()
	return rogue_essence_numbers().splitter_types

/obj/machinery/essence/splitter/Initialize(mapload)
	. = ..()
	read_research()

/obj/machinery/essence/splitter/Destroy()
	drop_items()
	return ..()

/obj/machinery/essence/splitter/Exited(atom/movable/gone, direction)
	. = ..()
	current_items -= gone

/// The research of Multiplied Division and Infinite Fragmentation widen it (Vibelin, read on every use).
/obj/machinery/essence/splitter/proc/read_research()
	var/datum/rogue_essence_numbers/numbers = rogue_essence_numbers()
	var/datum/thaumic_research_network/research = rogue_thaumic_research()
	max_items = numbers.splitter_items
	storage.max_total = numbers.splitter_capacity
	if(research.has_research(/datum/thaumic_research_node/splitter_efficiency/six))
		max_items = numbers.splitter_items_6
		storage.max_total = numbers.splitter_capacity_6
	else if(research.has_research(/datum/thaumic_research_node/splitter_efficiency/five))
		max_items = numbers.splitter_items_5
		storage.max_total = numbers.splitter_capacity_5

/obj/machinery/essence/splitter/process(seconds_per_tick)
	if(!processing)
		push_to_linked(storage)

/obj/machinery/essence/splitter/build_allowed_types()
	return list()

/obj/machinery/essence/splitter/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/essence_vial) || istype(tool, /obj/item/essence_connector))
		return ..()
	read_research()
	if(processing)
		to_chat(user, span_warning("The splitter is currently processing."))
		return ITEM_INTERACT_BLOCKING
	if(!get_precursor_data(tool))
		to_chat(user, span_warning("[tool] cannot be processed by the essence splitter."))
		return ITEM_INTERACT_BLOCKING
	if(length(current_items) >= max_items)
		to_chat(user, span_warning("The splitter is full. Maximum [max_items] items can be processed at once."))
		return ITEM_INTERACT_BLOCKING
	if(!user.transferItemToLoc(tool, src))
		to_chat(user, span_warning("[tool] is stuck to your hand!"))
		return ITEM_INTERACT_BLOCKING
	current_items += tool
	to_chat(user, span_info("You place [tool] into the essence splitter. ([length(current_items)]/[max_items] slots used)"))
	return ITEM_INTERACT_SUCCESS

/obj/machinery/essence/splitter/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(processing)
		to_chat(user, span_warning("The splitter is currently processing."))
		return TRUE
	begin_bulk_splitting(user)
	return TRUE

/obj/machinery/essence/splitter/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(processing)
		to_chat(user, span_warning("The splitter is currently processing."))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	drop_items()
	to_chat(user, span_info("You remove all items from the splitter."))
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/essence/splitter/proc/drop_items()
	var/turf/here = drop_location()
	for(var/obj/item/thing as anything in current_items.Copy())
		thing.forceMove(here)
	current_items = list()

/// What the loaded items split into with the research of Essence Division, list(essence = units).
/obj/machinery/essence/splitter/proc/batch_yields()
	var/efficiency = rogue_thaumic_research().get_research_bonus(/datum/thaumic_research_node/splitter_efficiency)
	var/list/yields = list()
	for(var/obj/item/thing as anything in current_items)
		var/datum/natural_precursor/precursor = get_precursor_data(thing)
		if(!precursor)
			continue
		for(var/essence_type in precursor.essence_yields)
			yields[essence_type] = (yields[essence_type] || 0) + round(precursor.essence_yields[essence_type] * efficiency, 1)
	return yields

/obj/machinery/essence/splitter/proc/begin_bulk_splitting(mob/living/user)
	if(!length(current_items))
		return
	var/list/yields = batch_yields()
	var/total = 0
	for(var/essence_type in yields)
		total += yields[essence_type]
	if(storage.space() < total)
		to_chat(user, span_warning("The splitter doesn't have enough storage space for this bulk operation."))
		return
	processing = TRUE
	user.visible_message(span_info("[user] activates the essence splitter."))
	update_appearance(UPDATE_OVERLAYS)
	var/datum/rogue_essence_numbers/numbers = rogue_essence_numbers()
	var/speed = rogue_thaumic_research().get_research_bonus(/datum/thaumic_research_node/splitter_speed)
	var/process_time = (numbers.splitter_time + length(current_items) * numbers.splitter_time_item) / speed
	addtimer(CALLBACK(src, PROC_REF(finish_bulk_splitting), WEAKREF(user)), process_time)

/obj/machinery/essence/splitter/proc/finish_bulk_splitting(datum/weakref/user_ref)
	if(!processing)
		return
	flick_overlay_view(mutable_appearance(icon, "split", ABOVE_MOB_LAYER), 1.2 SECONDS)
	var/list/yields = batch_yields()
	var/items_split = 0
	for(var/obj/item/thing as anything in current_items.Copy())
		if(get_precursor_data(thing))
			items_split++
		qdel(thing)
	current_items = list()
	for(var/essence_type in yields)
		storage.add(essence_type, yields[essence_type])
	processing = FALSE
	network?.invalidate_cache()
	update_appearance(UPDATE_OVERLAYS)
	visible_message(span_info("The essence splitter sparks."))
	var/mob/living/user = user_ref?.resolve()
	if(istype(user))
		user.rogue_adjust_experience(ROGUE_ALCHEMY_SKILL, user.rogue_stat(ROGUE_STAT_INTELLIGENCE) * items_split * rogue_essence_numbers().splitter_xp_share)

/obj/machinery/essence/splitter/examine(mob/user)
	. = ..()
	. += span_notice("Processing slots: [length(current_items)]/[max_items] used")

/obj/machinery/essence/extractor
	name = "essence extractor"
	desc = "A slow but efficient machine that draws alchemical essences from a material over time, yielding far more than a standard splitter."
	icon_state = "extractor"
	accepts_input = FALSE
	network_priority = 3
	processing_flags = START_PROCESSING_ON_INIT
	var/obj/item/current_item
	var/processing = FALSE
	/// What drips each tick, list(essence = units), and how many ticks are left.
	var/list/tick_yields = list()
	var/ticks_remaining = 0
	/// When the next drip falls: Vibelin's 45 seconds over 15 ticks, quicker with the research of Swift Division.
	var/tick_interval = 0
	var/next_tick = 0

/obj/machinery/essence/extractor/storage_capacity()
	return rogue_essence_numbers().extractor_capacity

/obj/machinery/essence/extractor/storage_types()
	return rogue_essence_numbers().extractor_types

/obj/machinery/essence/extractor/Destroy()
	current_item?.forceMove(drop_location())
	current_item = null
	tick_yields = null
	return ..()

/obj/machinery/essence/extractor/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == current_item)
		current_item = null
		processing = FALSE
		tick_yields = list()
		ticks_remaining = 0

/obj/machinery/essence/extractor/build_allowed_types()
	return list()

/obj/machinery/essence/extractor/process(seconds_per_tick)
	push_to_linked(storage)
	if(!processing || world.time < next_tick)
		return
	if(ticks_remaining <= 0)
		finish_extraction()
		return
	next_tick = world.time + tick_interval
	for(var/essence_type in tick_yields)
		storage.add(essence_type, tick_yields[essence_type])
	ticks_remaining--

/obj/machinery/essence/extractor/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/essence_vial) || istype(tool, /obj/item/essence_connector))
		return ..()
	if(processing)
		to_chat(user, span_warning("The extractor is already processing an item."))
		return ITEM_INTERACT_BLOCKING
	if(current_item)
		to_chat(user, span_warning("The extractor already has an item loaded. Right-click to remove it."))
		return ITEM_INTERACT_BLOCKING
	if(!get_precursor_data(tool))
		to_chat(user, span_warning("[tool] cannot be processed by the essence extractor."))
		return ITEM_INTERACT_BLOCKING
	if(!user.transferItemToLoc(tool, src))
		to_chat(user, span_warning("[tool] is stuck to your hand!"))
		return ITEM_INTERACT_BLOCKING
	current_item = tool
	to_chat(user, span_info("You load [tool] into the essence extractor."))
	return ITEM_INTERACT_SUCCESS

/obj/machinery/essence/extractor/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(processing)
		to_chat(user, span_warning("The extractor is currently processing."))
		return TRUE
	if(!current_item)
		to_chat(user, span_warning("There's nothing loaded in the extractor."))
		return TRUE
	begin_extraction(user)
	return TRUE

/obj/machinery/essence/extractor/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(processing)
		to_chat(user, span_warning("The extractor is currently processing."))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(current_item)
		current_item.forceMove(drop_location())
		to_chat(user, span_info("You remove the item from the extractor."))
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/essence/extractor/proc/begin_extraction(mob/user)
	var/datum/natural_precursor/precursor = get_precursor_data(current_item)
	if(!precursor)
		to_chat(user, span_warning("Something went wrong reading the item's data."))
		return
	var/datum/rogue_essence_numbers/numbers = rogue_essence_numbers()
	var/datum/thaumic_research_network/research = rogue_thaumic_research()
	var/efficiency = research.get_research_bonus(/datum/thaumic_research_node/splitter_efficiency)
	var/speed = research.get_research_bonus(/datum/thaumic_research_node/splitter_speed)
	var/ticks = max(1, numbers.extractor_ticks)
	tick_interval = numbers.extractor_time / ticks / speed
	ticks_remaining = ticks
	next_tick = world.time + tick_interval
	tick_yields = list()
	for(var/essence_type in precursor.essence_yields)
		tick_yields[essence_type] = round(precursor.essence_yields[essence_type] * numbers.extractor_yield * efficiency / ticks, 0.1)
	processing = TRUE
	user.visible_message(span_info("[user] activates the essence extractor."))
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/essence/extractor/proc/finish_extraction()
	var/obj/item/used = current_item
	processing = FALSE
	tick_yields = list()
	ticks_remaining = 0
	current_item = null
	qdel(used)
	network?.invalidate_cache()
	visible_message(span_info("The essence extractor hums quietly as it finishes."))
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/essence/extractor/examine(mob/user)
	. = ..()
	if(!current_item)
		. += span_notice("No item loaded.")
		return
	. += span_notice("Loaded: [current_item]")
	if(processing)
		. += span_notice("Extracting... [ticks_remaining] ticks remaining.")
