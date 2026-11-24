// Vibelin's cauldron essence node (crafting/alchemy/cauldron.dm, /obj/machinery/essence/cauldron_node): a machine in
// nullspace that stands for the cauldron in the essence network, so links can feed the cauldron its recipe's essences.
// The cauldron (alchemy/brewing.dm, block VA1v) brews from essence_contents and takes in what reaches the node's store;
// this file gives the cauldron its node (rogue_essence_node(), made on first use) and nothing else of the cauldron.

/obj/machinery/essence/cauldron_node
	name = "cauldron essence node"
	desc = "An internal essence conduit."
	icon = ROGUE_ESSENCE_ALCHEMY_ICON
	icon_state = "cauldron1"
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/obj/machinery/light/rogue/cauldron/owner

/obj/machinery/essence/cauldron_node/Initialize(mapload, obj/machinery/light/rogue/cauldron/parent)
	. = ..()
	owner = parent

/obj/machinery/essence/cauldron_node/Destroy()
	owner = null
	return ..()

/obj/machinery/essence/cauldron_node/storage_capacity()
	return rogue_essence_numbers().cauldron_node_capacity

/obj/machinery/essence/cauldron_node/storage_types()
	return rogue_essence_numbers().cauldron_node_types

/obj/machinery/essence/cauldron_node/essence_anchor()
	return owner

/obj/machinery/essence/cauldron_node/push_to_linked(datum/essence_storage/from_storage)
	push_surplus_to_linked(from_storage)

/// What the chosen recipe still lacks for as many batches as the cauldron can brew, counting what is in the cauldron and
/// what is on its way in the node (Vibelin). No recipe: nothing.
/obj/machinery/essence/cauldron_node/build_allowed_types()
	if(QDELETED(owner))
		return list()
	var/datum/alch_cauldron_recipe/recipe = owner.selected_recipe
	if(!recipe)
		return list()
	var/list/allowed = list()
	var/max_batches = owner.calculate_max_possible_batches(recipe)
	for(var/essence_type in recipe.required_essences)
		var/room = recipe.required_essences[essence_type] * max_batches - (owner.essence_contents[essence_type] || 0) - storage.get(essence_type)
		if(room > 0)
			allowed[essence_type] = room
	return allowed

/obj/machinery/light/rogue/cauldron
	/// Its node in the essence network (block VA1b).
	var/obj/machinery/essence/cauldron_node/essence_node

/// The cauldron's node in the essence network, made on first use (Vibelin makes it with the cauldron).
/obj/machinery/light/rogue/cauldron/proc/rogue_essence_node()
	RETURN_TYPE(/obj/machinery/essence/cauldron_node)
	if(QDELETED(src))
		return null
	if(QDELETED(essence_node))
		essence_node = new(null, src)
	return essence_node

/obj/machinery/light/rogue/cauldron/Destroy()
	QDEL_NULL(essence_node)
	return ..()

/// Holding the connector over the cauldron shows the links of its node (Vibelin).
/obj/machinery/light/rogue/cauldron/MouseEntered(location, control, params)
	. = ..()
	var/mob/user = usr
	if(!istype(user) || !istype(user.get_active_held_item(), /obj/item/essence_connector))
		return
	if(!QDELETED(essence_node) && length(essence_node.links))
		essence_node.show_link_beams()
