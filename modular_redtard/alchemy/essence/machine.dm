// Vibelin's essence machine (essence_machines/_essence_machine.dm): a machine with a store of essences in a network of
// ethereal links. Here every essence machine ticks in SSobj, since SSmachines does not tick on medieval maps (Vibelin's
// splitter, divider, reservoir and extractor ticked in SSmachines); a machine that has nothing to do each tick does not
// tick. Machines are not powered. They are built from the crafting menu (essence/recipes.dm), never mapped.

/// Visual timings of essence in flight (not balance): a second at least, three at most, 0.3 s a tile.
#define ESSENCE_ORB_MIN_TIME (1 SECONDS)
#define ESSENCE_ORB_MAX_TIME (3 SECONDS)
#define ESSENCE_ORB_TILE_TIME (0.3 SECONDS)

/obj/machinery/essence
	icon = 'modular_redtard/alchemy/essence/icons/splitter.dmi'
	density = TRUE
	anchored = TRUE
	use_power = NO_POWER_USE
	subsystem_type = /datum/controller/subsystem/processing/obj
	processing_flags = NONE
	interaction_flags_atom = NONE
	/// The cluster of linked machines, null when alone.
	var/datum/essence_network/network
	/// Every link touching it, in or out.
	var/list/links = list()
	var/datum/essence_storage/storage
	/// Vibelin's order of processing (kept for the generator's data and the gnome's choices; SSobj has no order).
	var/network_priority = 5
	/// Whether other machines may draw a link into it, and it may draw one out.
	var/accepts_input = TRUE
	var/accepts_output = TRUE

/obj/machinery/essence/Initialize(mapload)
	. = ..()
	storage = new(src, storage_capacity(), storage_types())

/obj/machinery/essence/Destroy()
	essence_disconnect_machine(src)
	QDEL_NULL(storage)
	links = list()
	return ..()

/// How many units and kinds its store holds (each machine its own alch_ess_* numbers).
/obj/machinery/essence/proc/storage_capacity()
	return 0

/obj/machinery/essence/proc/storage_types()
	return 0

/obj/machinery/essence/proc/get_storage()
	RETURN_TYPE(/datum/essence_storage)
	return storage

/// Where its essence is seen to come from and go to: itself (the cauldron's node: the cauldron).
/obj/machinery/essence/proc/essence_anchor()
	return src

/// What it would take in now, list(essence type or parent = units); an empty list takes nothing (Vibelin).
/obj/machinery/essence/proc/build_allowed_types()
	var/room = storage.space()
	if(room <= 0)
		return list()
	return list(/datum/thaumaturgical_essence = room)

/// What it would take in now, from the network's cache when it is in one.
/obj/machinery/essence/proc/allowed_types()
	return network ? network.get_allowed_types(src) : build_allowed_types()

/obj/machinery/essence/proc/accepts_essence(essence_type)
	return is_path_in_list(essence_type, allowed_types())

/// How many units of an essence it would take in now.
/obj/machinery/essence/proc/get_allowed_amount(essence_type)
	var/list/allowed = allowed_types()
	for(var/allowed_type in allowed)
		if(ispath(essence_type, allowed_type))
			return allowed[allowed_type]
	return 0

/obj/machinery/essence/proc/on_storage_changed(essence_type, amount, added)
	network?.invalidate_cache()
	update_appearance()

/obj/machinery/essence/proc/can_link_to(obj/machinery/essence/target)
	return accepts_output && target.accepts_input

/// A link touching it was drawn or cut.
/obj/machinery/essence/proc/on_link_changed()
	update_appearance(UPDATE_OVERLAYS)

/// Pushes out, one kind a link a tick, the essences it has no use for (Vibelin push_surplus_to_linked()).
/obj/machinery/essence/proc/push_surplus_to_linked(datum/essence_storage/from_storage)
	if(!from_storage || !length(from_storage.contents) || !length(links))
		return
	var/list/wanted = build_allowed_types()
	for(var/essence_type in from_storage.snapshot())
		if(is_path_in_list(essence_type, wanted))
			continue
		for(var/datum/essence_link/link as anything in links)
			if(!link.active || link.source != src)
				continue
			var/obj/machinery/essence/sink = link.sink
			if(QDELETED(sink) || !sink.accepts_essence(essence_type))
				continue
			if(from_storage.transfer_to(sink.get_storage(), essence_type, link.bandwidth) > 0)
				break

/// Pushes its essences out through every outbound link, one kind a link a tick (Vibelin push_to_linked()).
/obj/machinery/essence/proc/push_to_linked(datum/essence_storage/from_storage)
	if(!from_storage || !length(from_storage.contents))
		return
	for(var/datum/essence_link/link as anything in links)
		if(!link.active || link.source != src)
			continue
		var/obj/machinery/essence/sink = link.sink
		if(QDELETED(sink) || !sink.get_storage())
			continue
		for(var/essence_type in from_storage.snapshot())
			var/deficit = sink.get_allowed_amount(essence_type)
			if(deficit <= 0)
				continue
			if(from_storage.transfer_to(sink.get_storage(), essence_type, min(link.bandwidth, deficit)) > 0)
				break

/// Pulls what it wants through every inbound link, one kind a link a tick (Vibelin pull_from_linked()).
/obj/machinery/essence/proc/pull_from_linked(datum/essence_storage/into_storage)
	for(var/datum/essence_link/link as anything in links)
		if(!link.active || link.sink != src)
			continue
		var/obj/machinery/essence/source = link.source
		if(QDELETED(source))
			continue
		var/datum/essence_storage/source_store = source.get_storage()
		if(!source_store)
			continue
		for(var/essence_type in source_store.snapshot())
			var/deficit = get_allowed_amount(essence_type)
			if(deficit <= 0)
				continue
			if(source_store.transfer_to(into_storage, essence_type, min(link.bandwidth, deficit)) > 0)
				break

/obj/machinery/essence/examine(mob/user)
	. = ..()
	. += essence_examine(user)

/// What an alchemist reads off it (Vibelin get_mechanics_examine()).
/obj/machinery/essence/proc/essence_examine(mob/user)
	. = list()
	. += span_notice("Storage: [storage.total()]/[storage.max_total] ligulae ([storage.type_count()]/[storage.max_types] types)")
	. += rogue_essence_store_lines(storage, user)
	var/inbound = 0
	var/outbound = 0
	for(var/datum/essence_link/link as anything in links)
		if(link.sink == src)
			inbound++
		if(link.source == src)
			outbound++
	if(inbound || outbound)
		. += span_notice("Ethereal links: [inbound] inbound, [outbound] outbound")
	if(network)
		. += span_notice("Network: [length(network.machines)] connected machine\s")

/// The lines of a store's contents, each essence by name or by smell.
/proc/rogue_essence_store_lines(datum/essence_storage/store, mob/user)
	. = list()
	if(!length(store?.contents))
		. += span_notice("  (empty)")
		return
	for(var/essence_type in store.contents)
		. += span_notice("  - [rogue_essence_label(essence_type, user)]: [store.contents[essence_type]] ligulae")

/obj/machinery/essence/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/essence_vial))
		handle_vial(tool, user)
		return ITEM_INTERACT_SUCCESS
	return NONE

/// Right click with the pestran connector: the links of the machine.
/obj/machinery/essence/item_interaction_secondary(mob/living/user, obj/item/tool, list/modifiers)
	if(user.combat_mode || !istype(tool, /obj/item/essence_connector))
		return NONE
	INVOKE_ASYNC(src, PROC_REF(show_link_menu), user)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/essence/proc/link_menu_reachable(mob/user)
	var/atom/anchor = essence_anchor()
	return anchor?.IsReachableBy(user)

/obj/machinery/essence/proc/show_link_menu(mob/user)
	var/list/options = list()
	var/inbound = 0
	var/outbound = 0
	for(var/datum/essence_link/link as anything in links)
		if(link.sink == src)
			inbound++
		if(link.source == src)
			outbound++
	if(outbound)
		options["View outbound links ([outbound])"] = "out"
	if(inbound)
		options["View inbound links ([inbound])"] = "in"
	if(length(links))
		options["Remove all links"] = "clear"
	if(!length(options))
		to_chat(user, span_info("[essence_anchor()] has no ethereal links."))
		return
	var/choice = tgui_input_list(user, "Link management", "Essence Links", options)
	if(!choice || QDELETED(src) || !link_menu_reachable(user))
		return
	switch(options[choice])
		if("out")
			show_link_list(user, "outbound", TRUE)
		if("in")
			show_link_list(user, "inbound", FALSE)
		if("clear")
			for(var/datum/essence_link/link as anything in links.Copy())
				essence_remove_link(link)
			to_chat(user, span_info("All links removed from [essence_anchor()]."))

/obj/machinery/essence/proc/show_link_list(mob/user, label, outbound)
	var/list/display = list()
	for(var/datum/essence_link/link as anything in links)
		if((link.source == src) != outbound)
			continue
		var/obj/machinery/essence/other = outbound ? link.sink : link.source
		if(QDELETED(other))
			continue
		var/atom/anchor = other.essence_anchor()
		display["[anchor?.name || other.name] at ([anchor?.x],[anchor?.y])"] = link
	if(!length(display))
		to_chat(user, span_info("No valid [label] links."))
		return
	var/choice = tgui_input_list(user, "Select a [label] link to remove", "Links", display)
	if(!choice || QDELETED(src) || !link_menu_reachable(user))
		return
	essence_remove_link(display[choice])
	to_chat(user, span_info("Link removed."))

/// A vial with essence pours into it; an empty vial draws one essence out (Vibelin handle_vial()).
/obj/machinery/essence/proc/handle_vial(obj/item/essence_vial/vial, mob/user)
	if(!vial.contained_essence || vial.essence_amount <= 0)
		INVOKE_ASYNC(src, PROC_REF(extract_to_vial), vial, user)
		return
	if(!accepts_essence(vial.contained_essence))
		to_chat(user, span_warning("This machine cannot accept that essence right now."))
		return
	var/moved = storage.add(vial.contained_essence, vial.essence_amount)
	if(moved > 0)
		vial.take_essence(moved)
		to_chat(user, span_info("You pour [moved] ligulae into [src]."))

/obj/machinery/essence/proc/extract_to_vial(obj/item/essence_vial/vial, mob/user)
	if(!length(storage.contents))
		to_chat(user, span_warning("[src] is empty."))
		return
	var/list/radial = list()
	var/list/by_label = list()
	for(var/essence_type in storage.contents)
		var/datum/thaumaturgical_essence/essence = essence_type
		var/label = "[rogue_essence_label(essence_type, user, "Essence of")] ([storage.contents[essence_type]] ligulae)"
		var/image/shown = image(icon = ROGUE_ESSENCE_ALCHEMY_ICON, icon_state = "essence")
		shown.color = initial(essence.color)
		var/datum/radial_menu_choice/choice = new
		choice.image = shown
		choice.name = label
		radial[label] = choice
		by_label[label] = essence_type
	var/picked = show_radial_menu(user, src, radial, custom_check = CALLBACK(src, PROC_REF(check_vial_menu_valid), user, vial), require_near = TRUE)
	if(!picked || !by_label[picked])
		return
	var/chosen = by_label[picked]
	var/to_take = min(storage.get(chosen), vial.max_essence, vial.extract_amount)
	if(to_take <= 0)
		to_chat(user, span_warning("Cannot extract with current vial settings."))
		return
	var/extracted = storage.remove(chosen, to_take)
	if(extracted > 0)
		vial.fill_essence(chosen, extracted)
		to_chat(user, span_info("You extract [extracted] ligulae from [src]."))

/obj/machinery/essence/proc/check_vial_menu_valid(mob/user, obj/item/essence_vial/vial)
	return user && vial && (vial in user.contents) && (!vial.contained_essence || vial.essence_amount <= 0)

/// Holding the connector over it shows its links: blue out, amber in (Vibelin show_link_beams()).
/obj/machinery/essence/proc/show_link_beams()
	var/atom/from = essence_anchor()
	if(!from)
		return
	for(var/datum/essence_link/link as anything in links)
		var/obj/machinery/essence/other = link.source == src ? link.sink : link.source
		if(QDELETED(other))
			continue
		var/atom/target_anchor = other.essence_anchor()
		if(!target_anchor)
			continue
		from.Beam(target_anchor, icon_state = "light_beam", time = 1.5 SECONDS, beam_color = link.source == src ? "#88CCFF" : "#FFAA44")

/obj/machinery/essence/MouseEntered(location, control, params)
	. = ..()
	var/mob/user = usr
	if(istype(user) && istype(user.get_active_held_item(), /obj/item/essence_connector))
		show_link_beams()

/// An orb of essence flying from one machine to another (Vibelin create_essence_flow_effect()).
/proc/rogue_essence_orb(obj/machinery/essence/from, obj/machinery/essence/destination, essence_type)
	var/turf/start = get_turf(from?.essence_anchor())
	var/turf/finish = get_turf(destination?.essence_anchor())
	if(!start || !finish)
		return
	var/travel = clamp(get_dist(start, finish) * ESSENCE_ORB_TILE_TIME, ESSENCE_ORB_MIN_TIME, ESSENCE_ORB_MAX_TIME)
	new /obj/effect/essence_orb(start, finish, essence_type, travel)

/obj/effect/essence_orb
	name = "essence orb"
	desc = "Alchemical essence in transit along a silver thread."
	icon = 'icons/effects/effects.dmi'
	icon_state = "phasein"
	density = FALSE
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_MOB_LAYER
	var/essence_color = "#4A90E2"
	var/travel_time = 2 SECONDS

/obj/effect/essence_orb/Initialize(mapload, turf/destination, essence_type, travel_duration = 2 SECONDS)
	. = ..()
	if(!destination)
		return INITIALIZE_HINT_QDEL
	travel_time = travel_duration
	if(ispath(essence_type, /datum/thaumaturgical_essence))
		var/datum/thaumaturgical_essence/essence = essence_type
		essence_color = initial(essence.color)
	color = essence_color
	var/dx = (destination.x - x) * ICON_SIZE_X
	var/dy = (destination.y - y) * ICON_SIZE_Y
	var/arc = min(sqrt(dx ** 2 + dy ** 2) * 0.3, 16)
	animate(src, pixel_x = dx / 2, pixel_y = dy / 2 + arc, time = travel_time / 2, easing = SINE_EASING)
	animate(pixel_x = dx, pixel_y = dy, time = travel_time / 2, easing = SINE_EASING)
	addtimer(CALLBACK(src, PROC_REF(arrive), destination), travel_time)

/obj/effect/essence_orb/proc/arrive(turf/destination)
	new /obj/effect/temp_visual/essence_sparkle(destination, essence_color)
	qdel(src)

/obj/effect/temp_visual/essence_sparkle
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldsparkles"
	duration = 1 SECONDS
	layer = ABOVE_MOB_LAYER

/obj/effect/temp_visual/essence_sparkle/Initialize(mapload, spark_color = "#4A90E2")
	. = ..()
	color = spark_color

/// The glow of a harvester drawing from its node, and the sparks of a working infuser or a voiding reservoir.
/obj/effect/temp_visual/essence_glow
	icon = 'icons/effects/effects.dmi'
	icon_state = "electricity"
	duration = 2 SECONDS

/obj/effect/temp_visual/essence_glow/sparks
	icon_state = "sparks"
	duration = 1 SECONDS

/obj/effect/temp_visual/essence_glow/void
	icon_state = "quantum_sparks"
	duration = 1 SECONDS

#undef ESSENCE_ORB_MIN_TIME
#undef ESSENCE_ORB_MAX_TIME
#undef ESSENCE_ORB_TILE_TIME
