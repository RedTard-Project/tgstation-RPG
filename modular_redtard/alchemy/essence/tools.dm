// Vibelin's essence vials (crafting/alchemy/essences.dm) and the pestran connector (crafting/alchemy/essence_connector.dm):
// a vial carries one essence between a machine, a node and the cauldron; the connector draws ethereal links between
// machines and, used in hand, points to the nearest essence node.

/obj/item/essence_vial
	name = "essence vial"
	desc = "A small crystalline vial designed to hold alchemical essences."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/glass_reagent_container.dmi'
	icon_state = "essence_vial"
	w_class = WEIGHT_CLASS_TINY
	var/essence_fill = "essence_liquid"
	/// The essence held (a type) and how many units.
	var/contained_essence
	var/essence_amount = 0
	var/max_essence = 0
	/// What a use draws out of a machine, set in hand in steps of increments.
	var/extract_amount = 0
	var/increments = 0

/obj/item/essence_vial/Initialize(mapload)
	. = ..()
	read_capacity()
	extract_amount = max_essence
	update_appearance(UPDATE_OVERLAYS)

/obj/item/essence_vial/proc/read_capacity()
	var/datum/rogue_essence_numbers/numbers = rogue_essence_numbers()
	max_essence = numbers.vial_capacity
	increments = numbers.vial_step

/// The combat flask (Vibelin essence_vial/combat): a larger flask, made in the infuser.
/obj/item/essence_vial/combat
	name = "combat flask"
	desc = "A larger crystalline flask designed to hold large amounts of essences."
	icon_state = "clear_bottle4"
	essence_fill = "combat_essence_fill"

/obj/item/essence_vial/combat/read_capacity()
	var/datum/rogue_essence_numbers/numbers = rogue_essence_numbers()
	max_essence = numbers.flask_capacity
	increments = numbers.flask_step

/// Steps what a use draws out (Vibelin attack_self()): up by increments, then back to one.
/obj/item/essence_vial/attack_self(mob/user, list/modifiers)
	if(extract_amount >= max_essence)
		extract_amount = 1
	else
		if(extract_amount == 1 && increments > 1)
			extract_amount = 0
		extract_amount = min(extract_amount + increments, max_essence)
	to_chat(user, span_info("You adjust the vial to extract [extract_amount] unit\s of essence."))
	return TRUE

/obj/item/essence_vial/attack_self_secondary(mob/user, list/modifiers)
	if(extract_amount != max_essence)
		extract_amount = max_essence
		to_chat(user, span_info("You adjust the vial to extract [extract_amount] unit\s of essence."))
	return TRUE

/obj/item/essence_vial/update_overlays()
	. = ..()
	if(!contained_essence || essence_amount <= 0)
		return
	var/datum/thaumaturgical_essence/essence = contained_essence
	var/used_alpha = min(255, 100 + essence_amount * 15)
	var/mutable_appearance/fill = mutable_appearance(icon, essence_fill, alpha = used_alpha)
	fill.color = initial(essence.color)
	. += fill
	. += emissive_appearance(icon, essence_fill, src, alpha = used_alpha)

/obj/item/essence_vial/examine(mob/user)
	. = ..()
	if(contained_essence && essence_amount > 0)
		var/datum/thaumaturgical_essence/essence = contained_essence
		if(HAS_TRAIT(user, TRAIT_LEGENDARY_ALCHEMIST))
			. += span_notice("Contains [essence_amount] units of [initial(essence.name)].")
			. += span_notice("It smells of [initial(essence.smells_like)].")
		else
			. += span_notice("Contains [essence_amount] units of essence smelling of [initial(essence.smells_like)].")
	else
		. += span_notice("It appears to be empty.")
	. += span_notice("Set to extract [extract_amount] unit\s when used. Use in hand to adjust.")

/obj/item/essence_vial/proc/can_hold_essence()
	return essence_amount < max_essence

/obj/item/essence_vial/proc/get_available_space()
	return max(0, max_essence - essence_amount)

/// Fills it with units of an essence (the vial must be empty or hold the same one); returns what went in.
/obj/item/essence_vial/proc/fill_essence(essence_type, amount)
	if(contained_essence && contained_essence != essence_type && essence_amount > 0)
		return 0
	var/actual = min(amount, get_available_space())
	if(actual <= 0)
		return 0
	contained_essence = essence_type
	essence_amount += actual
	update_appearance(UPDATE_OVERLAYS)
	return actual

/// Takes units out of it, empty once nothing is left.
/obj/item/essence_vial/proc/take_essence(amount)
	essence_amount = max(0, essence_amount - amount)
	if(essence_amount <= 0)
		contained_essence = null
	update_appearance(UPDATE_OVERLAYS)

/// The machine an atom stands for when a connector or a vial is used on it: a machine itself, or the cauldron's node.
/proc/rogue_essence_machine_of(atom/target)
	if(istype(target, /obj/machinery/essence))
		return target
	if(istype(target, /obj/machinery/light/rogue/cauldron))
		var/obj/machinery/light/rogue/cauldron/cauldron = target
		return cauldron.rogue_essence_node()
	return null

/obj/item/essence_connector
	name = "pestran connector"
	desc = "A oddly shaped object used to create connections between alchemical apparatus. Something under the metal squirms..."
	icon = ROGUE_ESSENCE_ALCHEMY_ICON
	icon_state = "connector"
	// Vibelin hangs it at the hip with no sprite of its own on the body: it shows its item sprite there.
	worn_icon = ROGUE_ESSENCE_ALCHEMY_ICON
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	COOLDOWN_DECLARE(next_scan)
	var/obj/machinery/essence/source_device
	var/connecting = FALSE

/obj/item/essence_connector/Destroy()
	clear_source()
	return ..()

/obj/item/essence_connector/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/obj/machinery/essence/machine = rogue_essence_machine_of(interacting_with)
	if(!machine)
		if(connecting)
			to_chat(user, span_warning("[interacting_with] is not an essence device."))
			return ITEM_INTERACT_BLOCKING
		return NONE
	if(connecting)
		complete_connection(machine, user)
	else
		start_connection(machine, user)
	return ITEM_INTERACT_SUCCESS

/obj/item/essence_connector/proc/start_connection(obj/machinery/essence/machine, mob/user)
	source_device = machine
	connecting = TRUE
	RegisterSignal(machine, COMSIG_QDELETING, PROC_REF(on_source_deleted))
	var/atom/anchor = machine.essence_anchor()
	anchor?.add_overlay(connection_overlay())
	to_chat(user, span_info("Connection started from [anchor || machine]. Click another device to complete the link, or use in hand to cancel."))

/obj/item/essence_connector/proc/clear_source()
	if(source_device)
		UnregisterSignal(source_device, COMSIG_QDELETING)
		var/atom/anchor = source_device.essence_anchor()
		anchor?.cut_overlay(connection_overlay())
	source_device = null
	connecting = FALSE

/obj/item/essence_connector/proc/on_source_deleted(datum/source)
	SIGNAL_HANDLER
	clear_source()

/obj/item/essence_connector/proc/complete_connection(obj/machinery/essence/target, mob/user)
	var/obj/machinery/essence/from = source_device
	// Cleared first, so no early return leaves it half connected (Vibelin).
	clear_source()
	if(QDELETED(from))
		return
	if(target == from)
		to_chat(user, span_warning("Cannot connect a device to itself."))
		return
	for(var/datum/essence_link/existing as anything in from.links)
		if(existing.source == from && existing.sink == target)
			to_chat(user, span_warning("These devices are already linked in that direction."))
			return
	if(!essence_create_link(from, target, user))
		to_chat(user, span_warning("Could not create link, check that both machines accept connections in that direction."))
		return
	to_chat(user, span_info("Linked [from.essence_anchor()] → [target.essence_anchor()]."))

/obj/item/essence_connector/proc/connection_overlay()
	var/static/mutable_appearance/overlay
	if(!overlay)
		overlay = mutable_appearance('icons/effects/effects.dmi', "purplesparkles", ABOVE_MOB_LAYER)
	return overlay

/// In hand: cancels a link begun, or points to the nearest essence node (Vibelin attack_self()).
/obj/item/essence_connector/attack_self(mob/user, list/modifiers)
	if(connecting)
		clear_source()
		to_chat(user, span_info("Connection cancelled."))
		return TRUE
	if(!COOLDOWN_FINISHED(src, next_scan))
		return TRUE
	COOLDOWN_START(src, next_scan, 2 SECONDS)
	var/obj/structure/essence_node/closest
	var/closest_dist = INFINITY
	for(var/obj/structure/essence_node/node as anything in GLOB.essence_nodes)
		if(!isturf(node.loc) || node.z != user.z)
			continue
		var/distance = get_dist(user, node)
		if(distance < closest_dist)
			closest = node
			closest_dist = distance
	if(!closest)
		to_chat(user, span_warning("No essence nodes detected nearby."))
		return TRUE
	var/datum/hud/user_hud = user.hud_used
	if(!user_hud)
		return TRUE
	var/atom/movable/screen/essence_arrow/arrow = new(null, user_hud)
	switch(closest_dist)
		if(0 to 5)
			arrow.color = COLOR_GREEN
		if(6 to 10)
			arrow.color = COLOR_YELLOW
		if(11 to 15)
			arrow.color = COLOR_ORANGE
		else
			arrow.color = COLOR_RED
	arrow.transform = matrix(dir2angle(get_dir(user, closest)), MATRIX_ROTATE)
	user_hud.add_screen_object(arrow, group_key = HUD_GROUP_INFO, update_screen = TRUE)
	QDEL_IN(arrow, 1.5 SECONDS)
	return TRUE

/// The connector's arrow to the nearest node (Vibelin multitool_arrow).
/atom/movable/screen/essence_arrow
	icon = 'icons/effects/96x96.dmi'
	icon_state = "multitool_arrow"
	pixel_x = -32
	pixel_y = -32
	screen_loc = "CENTER-1,CENTER-1"

/atom/movable/screen/essence_arrow/Destroy()
	var/datum/hud/our_hud = hud
	. = ..() // TG's screen Destroy() takes it out of the hud's groups
	if(!QDELETED(our_hud))
		INVOKE_ASYNC(our_hud, TYPE_PROC_REF(/datum/hud, show_hud), our_hud.hud_version)
