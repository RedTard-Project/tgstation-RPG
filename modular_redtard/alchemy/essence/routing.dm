// Vibelin's essence divider (essence_machines/divider.dm) and reservoir (essence_resevoir.dm): the divider shares what
// comes in evenly among its outputs that have room; the reservoir holds a great deal, may filter what it takes in and,
// with the research of Temporal Decay, void what it holds.

/obj/machinery/essence/divider
	name = "essence divider"
	desc = "Splits incoming essence evenly across all connected outputs, skipping any that are full."
	icon_state = "divider"
	network_priority = 4
	processing_flags = START_PROCESSING_ON_INIT

/obj/machinery/essence/divider/storage_capacity()
	return rogue_essence_numbers().divider_capacity

/obj/machinery/essence/divider/storage_types()
	return rogue_essence_numbers().divider_types

/obj/machinery/essence/divider/process(seconds_per_tick)
	if(!length(storage.contents))
		return
	var/list/outputs = list()
	for(var/datum/essence_link/link as anything in links)
		if(link.active && link.source == src && !QDELETED(link.sink))
			outputs += link
	if(!length(outputs))
		return
	// The amounts are frozen before anything moves (Vibelin).
	var/list/frozen = storage.snapshot()
	for(var/essence_type in frozen)
		var/total = frozen[essence_type]
		if(total <= 0)
			continue
		var/list/eligible = list()
		for(var/datum/essence_link/link as anything in outputs)
			if(link.sink.accepts_essence(essence_type) && link.sink.get_storage().space() > 0)
				eligible += link
		if(!length(eligible))
			continue
		var/share = round(total / length(eligible), 0.1)
		var/remainder = total
		for(var/i in 1 to length(eligible))
			var/datum/essence_link/link = eligible[i]
			var/to_send = min(i == length(eligible) ? remainder : share, link.bandwidth)
			if(to_send <= 0)
				continue
			remainder -= storage.transfer_to(link.sink.get_storage(), essence_type, to_send)
	network?.invalidate_cache()

/obj/machinery/essence/divider/examine(mob/user)
	. = ..()
	var/output_count = 0
	for(var/datum/essence_link/link as anything in links)
		if(link.active && link.source == src)
			output_count++
	. += span_notice("Splitting across [output_count] active output\s.")

/obj/machinery/essence/reservoir
	name = "essence reservoir"
	desc = "A large glass sphere for storing massive quantities of alchemical essences."
	icon = ROGUE_ESSENCE_ALCHEMY_ICON
	icon_state = "essence_tank"
	network_priority = 2
	processing_flags = START_PROCESSING_ON_INIT
	/// The kinds the filter lets in (types); with the filter on and none listed, everything comes in.
	var/list/allowed_essence_types = list()
	var/filter_mode = FALSE
	var/void_mode = FALSE
	/// Units voided a tick.
	var/void_rate = 0

/obj/machinery/essence/reservoir/storage_capacity()
	return rogue_essence_numbers().reservoir_capacity

/obj/machinery/essence/reservoir/storage_types()
	return rogue_essence_numbers().reservoir_types

/obj/machinery/essence/reservoir/Initialize(mapload)
	. = ..()
	void_rate = rogue_essence_numbers().reservoir_void_rate

/obj/machinery/essence/reservoir/process(seconds_per_tick)
	if(void_mode && storage.total() > 0 && rogue_thaumic_research().has_research(/datum/thaumic_research_node/resevoir_decay))
		void_essences()
	push_to_linked(storage)

/obj/machinery/essence/reservoir/proc/void_essences()
	var/step = max(1, rogue_essence_numbers().reservoir_void_step)
	var/remaining = void_rate
	var/list/kinds = storage.contents.Copy()
	while(remaining > 0 && length(kinds))
		var/essence_type = pick(kinds)
		var/available = storage.get(essence_type)
		if(available <= 0)
			kinds -= essence_type
			continue
		var/to_void = min(available, remaining, rand(1, step))
		storage.remove(essence_type, to_void)
		remaining -= to_void
		if(storage.get(essence_type) <= 0)
			kinds -= essence_type
	new /obj/effect/temp_visual/essence_glow/void(get_turf(src))

/obj/machinery/essence/reservoir/build_allowed_types()
	if(!filter_mode || !length(allowed_essence_types))
		return ..()
	var/room = storage.space()
	if(room <= 0)
		return list()
	var/list/allowed = list()
	for(var/essence_type in allowed_essence_types)
		allowed[essence_type] = room
	return allowed

/obj/machinery/essence/reservoir/update_overlays()
	. = ..()
	if(!storage?.max_total)
		return
	var/essence_percent = storage.total() / storage.max_total
	if(!essence_percent)
		return
	var/level = clamp(CEILING(essence_percent * 5, 1), 1, 5)
	var/mutable_appearance/liquid = mutable_appearance(icon, "liquid_[level]")
	liquid.color = rogue_essence_mix_color(storage.contents)
	. += liquid
	. += emissive_appearance(icon, "liquid_[level]", src, alpha = src.alpha)

/obj/machinery/essence/reservoir/examine(mob/user)
	. = ..()
	if(filter_mode)
		. += span_notice("Filter Mode: ACTIVE")
		. += span_notice("Allowed types: [length(allowed_essence_types) || "all (empty whitelist)"]")
	else
		. += span_notice("Filter Mode: DISABLED")
	if(void_mode)
		. += span_warning("Void Mode: ACTIVE, destroying [void_rate] units per cycle.")

/obj/machinery/essence/reservoir/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	INVOKE_ASYNC(src, PROC_REF(show_filter_menu), user)
	return TRUE

/// A vial pours in only what the filter lets in; drawing out is always allowed (Vibelin).
/obj/machinery/essence/reservoir/handle_vial(obj/item/essence_vial/vial, mob/user)
	if(vial.contained_essence && vial.essence_amount > 0 && !is_essence_allowed(vial.contained_essence))
		to_chat(user, span_warning("This reservoir's filter does not allow [rogue_essence_label(vial.contained_essence, user, "essence of")]."))
		return
	return ..()

/obj/machinery/essence/reservoir/proc/is_essence_allowed(essence_type)
	return !filter_mode || !length(allowed_essence_types) || (essence_type in allowed_essence_types)

/obj/machinery/essence/reservoir/proc/show_filter_menu(mob/user)
	var/decay_known = rogue_thaumic_research().has_research(/datum/thaumic_research_node/resevoir_decay)
	var/list/options = list()
	options["Toggle Filter Mode ([filter_mode ? "ON" : "OFF"])"] = "toggle_filter"
	if(decay_known)
		options["Toggle Void Mode ([void_mode ? "ON" : "OFF"])"] = "toggle_void"
		if(void_mode)
			options["Adjust Void Rate ([void_rate]/cycle)"] = "adjust_void"
	options["Add Essence Type to Filter"] = "add"
	if(length(allowed_essence_types))
		options["Remove Essence Type from Filter"] = "remove"
		options["Clear All Filters"] = "clear"
	options["View Current Filters"] = "view"
	var/choice = tgui_input_list(user, "Essence Filter Configuration", "Filter Menu", options)
	if(!choice || QDELETED(src) || !IsReachableBy(user))
		return
	switch(options[choice])
		if("toggle_filter")
			filter_mode = !filter_mode
			to_chat(user, span_info("Filter mode [filter_mode ? "enabled" : "disabled"]."))
		if("toggle_void")
			if(!decay_known)
				return
			void_mode = !void_mode
			if(void_mode)
				to_chat(user, span_warning("Void mode enabled. Essences will be destroyed at [void_rate] units per cycle!"))
			else
				to_chat(user, span_info("Void mode disabled."))
		if("adjust_void")
			var/most = rogue_essence_numbers().reservoir_void_max
			var/new_rate = tgui_input_number(user, "Set void rate (units destroyed per cycle):", "Void Rate", void_rate, most, 1)
			if(isnull(new_rate) || QDELETED(src))
				return
			void_rate = clamp(new_rate, 1, most)
			to_chat(user, span_info("Void rate set to [void_rate] units per cycle."))
		if("add")
			// What it holds, and every basic essence (Vibelin offered five of them).
			var/list/candidates = list()
			for(var/essence_type in storage.contents)
				candidates[rogue_essence_label(essence_type, user, "Essence of")] = essence_type
			for(var/essence_type in subtypesof(/datum/thaumaturgical_essence))
				var/datum/thaumaturgical_essence/essence = essence_type
				if(!initial(essence.tier))
					candidates[rogue_essence_label(essence_type, user, "Essence of")] = essence_type
			var/selected = tgui_input_list(user, "Select essence type to add:", "Add Filter", candidates)
			if(!selected || QDELETED(src) || !IsReachableBy(user))
				return
			allowed_essence_types |= candidates[selected]
			to_chat(user, span_info("[selected] added to filter."))
		if("remove")
			var/list/filters = list()
			for(var/essence_type in allowed_essence_types)
				filters[rogue_essence_label(essence_type, user, "Essence of")] = essence_type
			var/selected = tgui_input_list(user, "Select essence type to remove:", "Remove Filter", filters)
			if(!selected || QDELETED(src) || !IsReachableBy(user))
				return
			allowed_essence_types -= filters[selected]
			to_chat(user, span_info("[selected] removed from filter."))
		if("clear")
			allowed_essence_types.Cut()
			to_chat(user, span_info("All essence filters cleared."))
		if("view")
			if(!length(allowed_essence_types))
				to_chat(user, span_info("No filters configured — accepting all essence types."))
				return
			to_chat(user, span_info("Allowed essence types:"))
			for(var/essence_type in allowed_essence_types)
				to_chat(user, span_info("  - [rogue_essence_label(essence_type, user, "Essence of")]"))
	network?.invalidate_cache()

/// Filled reservoirs for admins and maps (Vibelin reservoir/filled): essence_list, list(essence = units).
/obj/machinery/essence/reservoir/filled
	var/list/essence_list = list()

/obj/machinery/essence/reservoir/filled/Initialize(mapload)
	. = ..()
	for(var/essence_type in essence_list)
		storage.add(essence_type, essence_list[essence_type])

/obj/machinery/essence/reservoir/filled/life
	essence_list = list(/datum/thaumaturgical_essence/life = 1000)

/obj/machinery/essence/reservoir/filled/order
	essence_list = list(/datum/thaumaturgical_essence/order = 1000)

/obj/machinery/essence/reservoir/filled/magic
	essence_list = list(/datum/thaumaturgical_essence/magic = 1000)

/obj/machinery/essence/reservoir/filled/motion
	essence_list = list(/datum/thaumaturgical_essence/motion = 1000)
