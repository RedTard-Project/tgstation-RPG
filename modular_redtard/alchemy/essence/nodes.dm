// Vibelin's essence nodes (essence_machines/essence_nodes.dm, node_jar.dm, node_harvester.dm): weak points of the land
// that hold one essence and slowly refill. A vial draws from a node; a containment jar lifts the node whole, to set it
// down elsewhere or into a harvester, which draws it out into the network and refills it faster. A node carried bare
// in hand slows and tires its bearer; in a jar it only tires, and less.
// Fixes on Vibelin: the node's essence is a type everywhere (Vibelin read .type off a type); the bare node's slowdown
// is lifted when it leaves the hand; the gnome's hat chance and the research of costs read as Vibelin meant.

GLOBAL_LIST_EMPTY(essence_nodes)

/obj/structure/essence_node
	name = "essence node"
	desc = "A weakened point in the environment that allows access to alchemical essence. It pulses with inner energy."
	icon = ROGUE_ESSENCE_ALCHEMY_ICON
	icon_state = "node"
	base_icon_state = "node"
	density = FALSE
	anchored = TRUE
	alpha = 150
	/// Its essence (a type); a random basic one when unset (any but the second compounds when rare).
	var/essence_type
	/// 0 common, 1 rare.
	var/tier = 0
	var/max_essence = 0
	var/current_essence = 0
	/// Units it refills a minute.
	var/recharge_rate = 0
	var/last_recharge = 0

/obj/structure/essence_node/Initialize(mapload)
	. = ..()
	var/datum/rogue_essence_numbers/numbers = rogue_essence_numbers()
	if(!tier && prob(numbers.node_rare_chance))
		tier = 1
	if(!essence_type)
		essence_type = pick_random_essence_type()
	if(tier)
		max_essence = rand(numbers.node_rare_capacity_min, numbers.node_rare_capacity_max)
		recharge_rate = rand(numbers.node_rare_recharge_min, numbers.node_rare_recharge_max)
		modify_max_integrity(numbers.node_rare_integrity)
	else
		max_essence = rand(numbers.node_capacity_min, numbers.node_capacity_max)
		recharge_rate = rand(numbers.node_recharge_min, numbers.node_recharge_max)
		modify_max_integrity(numbers.node_integrity)
	current_essence = min(max_essence, round(max_essence * rand(round(numbers.node_fill_min * 100), round(numbers.node_fill_max * 100)) / 100))
	last_recharge = world.time
	update_appearance(UPDATE_ICON)
	START_PROCESSING(SSobj, src)
	GLOB.essence_nodes += src

/obj/structure/essence_node/Destroy()
	STOP_PROCESSING(SSobj, src)
	GLOB.essence_nodes -= src
	return ..()

/obj/structure/essence_node/update_icon_state()
	. = ..()
	var/datum/thaumaturgical_essence/essence = essence_type
	color = essence ? initial(essence.color) : null

/obj/structure/essence_node/update_overlays()
	. = ..()
	. += emissive_appearance(icon, icon_state, src, alpha = src.alpha)

/obj/structure/essence_node/proc/pick_random_essence_type()
	var/list/choices = list()
	for(var/datum/thaumaturgical_essence/essence as anything in subtypesof(/datum/thaumaturgical_essence))
		var/essence_tier = initial(essence.tier)
		if(tier ? essence_tier != 2 : !essence_tier)
			choices += essence
	return length(choices) ? pick(choices) : null

/obj/structure/essence_node/process(seconds_per_tick)
	var/datum/rogue_essence_numbers/numbers = rogue_essence_numbers()
	if(current_essence < max_essence && world.time >= last_recharge + numbers.node_recharge_time)
		current_essence = min(max_essence, current_essence + recharge_rate)
		last_recharge = world.time

/obj/structure/essence_node/proc/can_harvest()
	return current_essence > 0

/obj/structure/essence_node/proc/harvest_essence(amount)
	. = min(current_essence, amount)
	current_essence -= .

/obj/structure/essence_node/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/essence_vial))
		harvest_into_vial(tool, user)
		return ITEM_INTERACT_SUCCESS
	if(istype(tool, /obj/item/essence_node_jar))
		INVOKE_ASYNC(src, PROC_REF(lift_into_jar), tool, user)
		return ITEM_INTERACT_SUCCESS
	return NONE

/obj/structure/essence_node/proc/harvest_into_vial(obj/item/essence_vial/vial, mob/user)
	if(!can_harvest())
		to_chat(user, span_warning("The node has no essence to harvest."))
		return
	if(!vial.can_hold_essence())
		to_chat(user, span_warning("The vial is already full."))
		return
	if(vial.contained_essence && vial.essence_amount > 0 && vial.contained_essence != essence_type)
		to_chat(user, span_warning("The vial contains a different type of essence."))
		return
	var/datum/rogue_essence_numbers/numbers = rogue_essence_numbers()
	var/harvested = harvest_essence(min(vial.get_available_space(), rand(numbers.node_harvest_min, numbers.node_harvest_max)))
	if(harvested <= 0)
		return
	vial.fill_essence(essence_type, harvested)
	to_chat(user, span_info("You harvest [harvested] units of [rogue_essence_label(essence_type, user)] from the node."))

/obj/structure/essence_node/proc/lift_into_jar(obj/item/essence_node_jar/jar, mob/user)
	if(jar.contained_node)
		to_chat(user, span_warning("The jar already contains a node."))
		return
	if(tier > jar.max_tier)
		to_chat(user, span_warning("This jar cannot contain such a powerful node."))
		return
	if(!do_after(user, rogue_essence_numbers().node_extract_time, src))
		return
	if(QDELETED(src) || jar.contained_node)
		return
	var/obj/item/essence_node_portable/portable = new(jar)
	portable.take_node(src)
	jar.contained_node = portable
	jar.update_appearance(UPDATE_OVERLAYS)
	to_chat(user, span_info("You carefully extract the essence node and place it in [jar]. The node of [rogue_essence_label(essence_type, user)] is now safely contained."))
	qdel(src)

/obj/structure/essence_node/examine(mob/user)
	. = ..()
	. += span_notice("This node generates [rogue_essence_label(essence_type, user)].")
	. += span_notice("Essence: [current_essence]/[max_essence] units")
	. += span_notice("Tier: [tier] ([tier ? "Rare" : "Common"])")
	. += span_notice("Recharge Rate: [recharge_rate] essence per minute")
	. += span_notice("Can be harvested with vials or extracted with a containment jar.")

/obj/structure/essence_node/rare
	desc = "A pulsating blister that oozes with concentrated essence. These rare nodes contain immense power."
	tier = 1

/obj/structure/essence_node/fire
	essence_type = /datum/thaumaturgical_essence/fire

/obj/structure/essence_node/water
	essence_type = /datum/thaumaturgical_essence/water

/obj/structure/essence_node/earth
	essence_type = /datum/thaumaturgical_essence/earth

/obj/structure/essence_node/air
	essence_type = /datum/thaumaturgical_essence/air

/obj/structure/essence_node/life
	essence_type = /datum/thaumaturgical_essence/life

/// A node lifted whole (Vibelin essence_node_portable): it refills slower and weighs on whoever holds it bare.
/obj/item/essence_node_portable
	name = "essence node"
	desc = "A large amount of essence still wrapped within its environmental shell. It still beats with alchemical energy."
	icon = ROGUE_ESSENCE_ALCHEMY_ICON
	icon_state = "essence"
	w_class = WEIGHT_CLASS_BULKY
	var/essence_type
	var/tier = 0
	var/max_essence = 0
	var/current_essence = 0
	var/recharge_rate = 0
	var/last_recharge = 0
	var/last_drain = 0
	/// Whom its weight slows now.
	var/datum/weakref/slowed

/obj/item/essence_node_portable/Initialize(mapload)
	. = ..()
	last_recharge = world.time
	last_drain = world.time
	START_PROCESSING(SSobj, src)

/obj/item/essence_node_portable/Destroy()
	STOP_PROCESSING(SSobj, src)
	lift_slowdown()
	return ..()

/// Takes the essence and the state of a node of the land.
/obj/item/essence_node_portable/proc/take_node(obj/structure/essence_node/node)
	essence_type = node.essence_type
	tier = node.tier
	max_essence = node.max_essence
	current_essence = node.current_essence
	recharge_rate = node.recharge_rate
	update_appearance(UPDATE_ICON_STATE)

/// Gives its essence and state to a node of the land.
/obj/item/essence_node_portable/proc/give_node(obj/structure/essence_node/node)
	node.essence_type = essence_type
	node.tier = tier
	node.max_essence = max_essence
	node.current_essence = current_essence
	node.recharge_rate = recharge_rate
	node.update_appearance(UPDATE_ICON)

/obj/item/essence_node_portable/update_icon_state()
	. = ..()
	var/datum/thaumaturgical_essence/essence = essence_type
	color = essence ? initial(essence.color) : null

/obj/item/essence_node_portable/process(seconds_per_tick)
	var/datum/rogue_essence_numbers/numbers = rogue_essence_numbers()
	// In a harvester it refills by the harvester's rule.
	if(istype(loc, /obj/machinery/essence/harvester))
		return
	if(current_essence < max_essence && world.time >= last_recharge + numbers.node_recharge_time)
		current_essence = min(max_essence, current_essence + max(1, round(recharge_rate * numbers.node_portable_recharge)))
		last_recharge = world.time
	var/mob/living/holder = loc
	if(!istype(holder) || !(src in holder.held_items))
		lift_slowdown()
		return
	if(!slowed)
		slowed = WEAKREF(holder)
		holder.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/rogue_essence_node, multiplicative_slowdown = tier ? numbers.node_rare_carry_slowdown : numbers.node_carry_slowdown)
	if(world.time >= last_drain + numbers.node_carry_drain_time)
		last_drain = world.time
		rogue_essence_tire(holder, tier ? numbers.node_rare_carry_drain : numbers.node_carry_drain, "Carrying the essence node is exhausting you!")

/obj/item/essence_node_portable/proc/lift_slowdown()
	var/mob/living/holder = slowed?.resolve()
	slowed = null
	holder?.remove_movespeed_modifier(/datum/movespeed_modifier/rogue_essence_node)

/obj/item/essence_node_portable/dropped(mob/user, silent)
	. = ..()
	lift_slowdown()

/obj/item/essence_node_portable/pickup(mob/user)
	. = ..()
	to_chat(user, span_warning("The essence node feels heavy and drains your energy as you carry it."))

/datum/movespeed_modifier/rogue_essence_node
	variable = TRUE

/// An essence node's burden: energy (the module's stamina bar) spent; told once the bearer runs low.
/proc/rogue_essence_tire(mob/living/holder, amount, warning)
	if(!ishuman(holder) || amount <= 0)
		return
	var/mob/living/carbon/human/bearer = holder
	bearer.rogue_energy_add(-amount)
	if(warning && bearer.rogue_max_energy && bearer.rogue_energy <= bearer.rogue_max_energy / 5)
		to_chat(bearer, span_warning(warning))

/// The containment jar (Vibelin essence_node_jar): lifts a node of its tier or lower, sets it down on a free tile or into
/// a harvester; held with a node, it tires its bearer a little.
/obj/item/essence_node_jar
	name = "essence node containment jar"
	desc = "A specially crafted container designed to safely extract and transport essence nodes. The jar neutralizes most of the node's burden while carried."
	icon = ROGUE_ESSENCE_ALCHEMY_ICON
	icon_state = "node_jar"
	w_class = WEIGHT_CLASS_NORMAL
	var/obj/item/essence_node_portable/contained_node
	var/max_tier = 0
	var/last_drain = 0

/obj/item/essence_node_jar/Initialize(mapload)
	. = ..()
	last_drain = world.time
	START_PROCESSING(SSobj, src)

/obj/item/essence_node_jar/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(contained_node)
	return ..()

/obj/item/essence_node_jar/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == contained_node)
		contained_node = null
		update_appearance(UPDATE_OVERLAYS)

/obj/item/essence_node_jar/proc/drain_amount()
	return rogue_essence_numbers().jar_drain

/obj/item/essence_node_jar/process(seconds_per_tick)
	if(!contained_node)
		return
	var/mob/living/holder = loc
	if(!istype(holder) || !(src in holder.held_items))
		return
	if(world.time < last_drain + rogue_essence_numbers().jar_drain_time)
		return
	last_drain = world.time
	rogue_essence_tire(holder, drain_amount() * (contained_node.tier + 1), contained_node.tier >= 1 ? "The contained essence node creates a slight burden." : null)

/obj/item/essence_node_jar/update_overlays()
	. = ..()
	if(!contained_node)
		return
	var/mutable_appearance/node = mutable_appearance(contained_node.icon, contained_node.icon_state, layer = layer - 0.1)
	node.color = contained_node.color
	. += node
	. += emissive_appearance(contained_node.icon, contained_node.icon_state, src, alpha = contained_node.alpha)

/// Used on a tile with a node inside: sets the node down there (Vibelin interact_with_atom()).
/obj/item/essence_node_jar/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!contained_node || !isturf(interacting_with))
		return NONE
	var/turf/deploy_turf = get_turf(interacting_with)
	if(!deploy_turf || (locate(/obj/machinery/essence/harvester) in deploy_turf))
		return NONE
	if(deploy_turf.density)
		to_chat(user, span_warning("You cannot deploy the node here - the ground is not suitable."))
		return ITEM_INTERACT_BLOCKING
	if(locate(/obj/structure/essence_node) in deploy_turf)
		to_chat(user, span_warning("There's already an essence node here."))
		return ITEM_INTERACT_BLOCKING
	INVOKE_ASYNC(src, PROC_REF(deploy_node), deploy_turf, user)
	return ITEM_INTERACT_SUCCESS

/obj/item/essence_node_jar/proc/deploy_node(turf/deploy_turf, mob/user)
	if(!do_after(user, rogue_essence_numbers().jar_deploy_time, deploy_turf))
		return
	if(!contained_node || deploy_turf.density || (locate(/obj/structure/essence_node) in deploy_turf))
		return
	var/obj/item/essence_node_portable/portable = contained_node
	var/obj/structure/essence_node/deployed = new(deploy_turf)
	portable.give_node(deployed)
	to_chat(user, span_info("You carefully deploy the node from the jar. The node of [rogue_essence_label(deployed.essence_type, user)] is now active."))
	qdel(portable)

/obj/item/essence_node_jar/examine(mob/user)
	. = ..()
	. += span_notice("Maximum node tier: [max_tier]")
	. += span_notice("Use on essence node structures to extract them for transport.")
	. += span_notice("Use on the ground to deploy a contained node there.")
	if(contained_node)
		. += span_info("Contains: a node of [rogue_essence_label(contained_node.essence_type, user)], Tier [contained_node.tier]")
		. += span_info("Node essence: [contained_node.current_essence]/[contained_node.max_essence] units")
		. += span_notice("The contained node still creates a slight burden when carried.")
	else
		. += span_notice("Empty. Use with an essence node structure to extract and contain it.")

/obj/item/essence_node_jar/advanced
	name = "advanced essence node containment jar"
	desc = "A masterwork containment vessel capable of safely transporting even the most powerful essence nodes. Advanced stabilization reduces carrying burden significantly."
	max_tier = 1

/obj/item/essence_node_jar/advanced/drain_amount()
	return rogue_essence_numbers().jar_advanced_drain

/// The essence harvester (Vibelin node_harvester.dm): a node set into it refills faster and is drawn out into the network.
/obj/machinery/essence/harvester
	name = "essence harvester"
	desc = "A mechanical solution to large-scale essence extraction. Install an essence node to begin leeching alchemical energy from the land."
	icon_state = "splitter"
	network_priority = 1
	processing_flags = START_PROCESSING_ON_INIT
	var/obj/item/essence_node_portable/installed_node

/obj/machinery/essence/harvester/storage_capacity()
	return rogue_essence_numbers().harvester_capacity

/obj/machinery/essence/harvester/storage_types()
	return rogue_essence_numbers().harvester_types

/obj/machinery/essence/harvester/Destroy()
	installed_node?.forceMove(drop_location())
	installed_node = null
	return ..()

/obj/machinery/essence/harvester/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == installed_node)
		installed_node = null
		update_appearance(UPDATE_OVERLAYS)

/obj/machinery/essence/harvester/build_allowed_types()
	return list()

/obj/machinery/essence/harvester/process(seconds_per_tick)
	if(installed_node)
		var/datum/rogue_essence_numbers/numbers = rogue_essence_numbers()
		if(installed_node.current_essence < installed_node.max_essence && world.time >= installed_node.last_recharge + numbers.node_recharge_time)
			installed_node.current_essence = min(installed_node.max_essence, installed_node.current_essence + round(installed_node.recharge_rate * numbers.harvester_recharge))
			installed_node.last_recharge = world.time
		if(installed_node.current_essence > 0)
			var/added = storage.add(installed_node.essence_type, min(installed_node.current_essence, numbers.harvester_rate))
			if(added > 0)
				installed_node.current_essence -= added
				new /obj/effect/temp_visual/essence_glow(get_turf(src))
	push_to_linked(storage)

/obj/machinery/essence/harvester/essence_examine(mob/user)
	. = ..()
	var/datum/rogue_essence_numbers/numbers = rogue_essence_numbers()
	. += span_notice("Harvest rate: [numbers.harvester_rate] units/tick")
	. += span_notice("Node recharge bonus: +[round((numbers.harvester_recharge - 1) * 100)]%")
	if(installed_node)
		. += span_notice("Node: [rogue_essence_label(installed_node.essence_type, user)] — Tier [installed_node.tier]")
		. += span_notice("Node charge: [installed_node.current_essence]/[installed_node.max_essence]")
		. += span_notice("Effective recharge: [round(installed_node.recharge_rate * numbers.harvester_recharge)] units/min")
	else
		. += span_warning("No node installed. Use a node jar to insert one.")

/obj/machinery/essence/harvester/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	var/list/lines = essence_examine(user)
	lines += span_info("Use a node jar on the harvester to install or remove a node.")
	to_chat(user, jointext(lines, "\n"))
	return TRUE

/obj/machinery/essence/harvester/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/essence_node_jar))
		INVOKE_ASYNC(src, PROC_REF(handle_node_jar), tool, user)
		return ITEM_INTERACT_SUCCESS
	return ..()

/obj/machinery/essence/harvester/proc/handle_node_jar(obj/item/essence_node_jar/jar, mob/user)
	var/install_time = rogue_essence_numbers().harvester_install_time
	if(jar.contained_node)
		if(installed_node)
			to_chat(user, span_warning("A node is already installed."))
			return
		if(!do_after(user, install_time, src) || !jar.contained_node || installed_node)
			return
		var/obj/item/essence_node_portable/node = jar.contained_node
		node.forceMove(src)
		installed_node = node
		to_chat(user, span_info("You install the node. It will extract [rogue_essence_label(node.essence_type, user)]."))
	else
		if(!installed_node)
			to_chat(user, span_warning("No node to remove."))
			return
		if(!do_after(user, install_time, src) || !installed_node || jar.contained_node)
			return
		var/obj/item/essence_node_portable/node = installed_node
		node.forceMove(jar)
		jar.contained_node = node
		jar.update_appearance(UPDATE_OVERLAYS)
		to_chat(user, span_info("You remove the node into the jar."))
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/essence/harvester/update_overlays()
	. = ..()
	if(!installed_node)
		return
	var/mutable_appearance/node = mutable_appearance(installed_node.icon, installed_node.icon_state, layer = layer + 0.1)
	node.color = installed_node.color
	node.pixel_y = 12
	. += node
	var/mutable_appearance/glow = emissive_appearance(installed_node.icon, installed_node.icon_state, src, alpha = node.alpha)
	glow.pixel_y = 12
	. += glow
