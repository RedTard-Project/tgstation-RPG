// Ratwood chimeric tech (controllers/subsystem/rogue/heart_tech_subsystem.dm, roguemachine/heartbeast/research_subsystem/
// heart_tech_node.dm): Pestra's heart beast learns tech nodes, and a recipe node unlocks the crafting recipes that name it
// (required_tech_node) for the rest of the round. The heart beast is not ported, so in play nothing unlocks a node yet: an
// admin can (Rogue Systems: Unlock Tech Node), and a port of the beast is to call rogue_unlock_tech_node().

/// Unlocked node ids (Ratwood string_id) to TRUE.
GLOBAL_LIST_EMPTY(rogue_unlocked_tech_nodes)

/// Ratwood names of its recipe nodes; BASIC_ORGANS has no node in Ratwood (its organ recipes never unlock there).
GLOBAL_LIST_INIT(rogue_tech_node_names, list(
	"LUX_FILTRATION" = "Impure lux filtration",
	"FLESH_DECOYS" = "Meat decoys",
	"VISCERA_DECOYS" = "Visceral decoys",
	"BLACK_ROSE" = "Black Rose Synthesis",
))

/// No node, or an unlocked one (Ratwood tech_unlocked).
/proc/rogue_tech_unlocked(node)
	return !node || GLOB.rogue_unlocked_tech_nodes[node]

/// Ratwood unlock_node() and update_recipes_for_tech(): the recipes behind the node show in the crafting menu from now on.
/proc/rogue_unlock_tech_node(node)
	if(!node || GLOB.rogue_unlocked_tech_nodes[node])
		return FALSE
	GLOB.rogue_unlocked_tech_nodes[node] = TRUE
	return TRUE

ADMIN_VERB(rogue_admin_unlock_tech_node, R_ADMIN, "Unlock Tech Node", "Unlock a heart beast tech node, and the crafting recipes behind it, for the round.", ADMIN_CATEGORY_ROGUE)
	var/list/locked = list()
	for(var/datum/crafting_recipe/roguetown/recipe in GLOB.crafting_recipes)
		var/node = recipe.rogue_tech_node
		if(node && !rogue_tech_unlocked(node))
			locked["[GLOB.rogue_tech_node_names[node] || node] ([node])"] = node
	if(!length(locked))
		to_chat(user, span_notice("No crafting recipe waits for a tech node."), confidential = TRUE)
		return
	var/choice = tgui_input_list(user, "Which node? The crafting menu shows its recipes once reopened.", "Unlock Tech Node", locked)
	if(!choice || !rogue_unlock_tech_node(locked[choice]))
		return
	message_admins("[key_name_admin(user)] unlocked the tech node [choice].")
	log_admin("[key_name(user)] unlocked the tech node [choice].")
	BLACKBOX_LOG_ADMIN_VERB("Unlock Tech Node")
