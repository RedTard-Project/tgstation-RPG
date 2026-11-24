// Vibelin's homunculus breeding tube (essence_machines/essence_testtube.dm): with the research of Life Synthesis it takes
// in life essence and grows a gnome homunculus, tamed to whoever started it. The gnome itself (Vibelin
// gnome_homunculus with its pet commands) is not in the module yet: rogue_make_homunculus() makes nothing, and the tube
// says so and keeps its essence, until the creature is ported and that proc is given a body.

/// Makes a homunculus on a tile, tamed to its maker; returns it, or null while the module has none.
/proc/rogue_make_homunculus(turf/where, mob/living/maker, hatless = FALSE)
	return null

/obj/machinery/essence/test_tube
	name = "homunculus breeding tube"
	desc = "A large glass tank for cultivating gnome homunculi from life essence."
	icon_state = "essence_tank"
	network_priority = 5
	accepts_output = FALSE
	processing_flags = START_PROCESSING_ON_INIT
	var/growing = FALSE

/obj/machinery/essence/test_tube/storage_capacity()
	return rogue_essence_numbers().tube_capacity

/obj/machinery/essence/test_tube/storage_types()
	return 1

/obj/machinery/essence/test_tube/build_allowed_types()
	if(!rogue_thaumic_research().has_research(/datum/thaumic_research_node/machines/gnomes))
		return list()
	var/room = storage.space()
	if(room <= 0)
		return list()
	return list(/datum/thaumaturgical_essence/life = room)

/obj/machinery/essence/test_tube/process(seconds_per_tick)
	pull_from_linked(storage)

/// The life essence a homunculus takes, less with the research of essence handling.
/obj/machinery/essence/test_tube/proc/required_life()
	return round(rogue_essence_numbers().tube_life * rogue_thaumic_research().get_research_bonus(/datum/thaumic_research_node/gnome_efficency), 1)

/obj/machinery/essence/test_tube/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!rogue_thaumic_research().has_research(/datum/thaumic_research_node/machines/gnomes))
		to_chat(user, span_warning("You have no idea how this works."))
		return TRUE
	if(growing)
		to_chat(user, span_notice("A gnome is already developing. Please wait."))
		return TRUE
	var/required = required_life()
	if(!storage.has(/datum/thaumaturgical_essence/life, required))
		to_chat(user, span_warning("Requires at least [required] units of life essence."))
		return TRUE
	begin_growth(user)
	return TRUE

/obj/machinery/essence/test_tube/proc/begin_growth(mob/living/user)
	growing = TRUE
	var/speed = rogue_thaumic_research().get_research_bonus(/datum/thaumic_research_node/gnome_speed)
	// Vibelin multiplies the time by its speed research, so the research slows it; kept as Vibelin has it.
	var/grow_time = rogue_essence_numbers().tube_time * speed
	to_chat(user, span_info("You activate the breeding process."))
	addtimer(CALLBACK(src, PROC_REF(growth_feedback)), grow_time * 0.33)
	addtimer(CALLBACK(src, PROC_REF(growth_feedback)), grow_time * 0.66)
	addtimer(CALLBACK(src, PROC_REF(create_gnome), WEAKREF(user)), grow_time)
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/essence/test_tube/proc/growth_feedback()
	if(growing)
		visible_message(span_notice("[src] bubbles and churns as the homunculus develops."))

/obj/machinery/essence/test_tube/proc/create_gnome(datum/weakref/user_ref)
	growing = FALSE
	update_appearance(UPDATE_OVERLAYS)
	var/mob/living/user = user_ref?.resolve()
	var/required = required_life()
	if(!storage.has(/datum/thaumaturgical_essence/life, required))
		if(user)
			to_chat(user, span_warning("Insufficient life essence, the process fails!"))
		return
	var/hatless = prob(100 * rogue_thaumic_research().get_research_bonus(/datum/thaumic_research_node/gnome_hat_chance)) && rogue_thaumic_research().has_research(/datum/thaumic_research_node/gnome_hat_chance)
	var/mob/living/gnome = rogue_make_homunculus(get_turf(src), user, hatless)
	if(!gnome)
		visible_message(span_warning("The essence in [src] swirls, but takes no shape."))
		return
	storage.remove(/datum/thaumaturgical_essence/life, required)
	visible_message(span_info("[src] glows brilliantly as the homunculus reaches maturity!"))
	if(user)
		to_chat(user, span_boldnotice("Your gnome homunculus has been created!"))

/obj/machinery/essence/test_tube/essence_examine(mob/user)
	. = ..()
	var/required = required_life()
	. += span_notice("Breeding requirement: [required] life essence")
	if(growing)
		. += span_boldnotice("A gnome homunculus is currently developing!")
	else if(storage.has(/datum/thaumaturgical_essence/life, required))
		. += span_info("Ready to begin breeding.")
	else
		. += span_warning("Insufficient life essence to breed.")

/obj/machinery/essence/test_tube/update_overlays()
	. = ..()
	if(!storage)
		return
	var/fill = storage.total() / 100
	if(!fill)
		return
	var/level = clamp(CEILING(fill * 4, 1), 1, 4)
	var/mutable_appearance/liquid = mutable_appearance(icon, "tank_[level]")
	liquid.color = rogue_essence_mix_color(storage.contents)
	. += liquid
	. += emissive_appearance(icon, "tank_[level]", src, alpha = src.alpha)
