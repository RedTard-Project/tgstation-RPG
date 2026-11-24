// Vibelin's thaumic research (essence_machines/research_matrix/): one tree of research for the whole round, unlocked by
// feeding essences into the Alchemical Engine (the research matrix). Its nodes (essence/research_nodes.dm) speed up and
// widen the splitter, the extractor and the combiner, quicken the infuser, open the reservoir's void and the breeding
// tube. Vibelin's window drew the tree on painted pictures; here it is drawn by hand, in the same places.
// Fix on Vibelin: the cost reduction of Improved Essence Handling is read as a reduction (Vibelin compared a type with
// istype(), so it never applied).

/// The round's research (Vibelin GLOB.thaumic_research), made on first use.
/proc/rogue_thaumic_research()
	RETURN_TYPE(/datum/thaumic_research_network)
	var/static/datum/thaumic_research_network/research
	if(!research)
		research = new
	return research

/datum/thaumic_research_network
	/// Types of the nodes unlocked, Fundamental Thaumaturgy from the start.
	var/list/unlocked_research = list()
	/// One of each node, by type.
	var/list/research_nodes = list()
	/// The mechanics revision the nodes' bonuses were read at.
	var/numbers_revision = -1

/datum/thaumic_research_network/New()
	. = ..()
	unlocked_research += /datum/thaumic_research_node/basic_understanding
	for(var/node_type in subtypesof(/datum/thaumic_research_node))
		var/datum/thaumic_research_node/node = node_type
		if(initial(node.abstract_type) == node_type)
			continue
		research_nodes[node_type] = new node_type

/datum/thaumic_research_network/proc/read_bonuses()
	for(var/node_type in research_nodes)
		var/datum/thaumic_research_node/node = research_nodes[node_type]
		node.bonus_value = node.read_bonus()
	numbers_revision = rogue_mechanics_revision()

/datum/thaumic_research_network/proc/has_research(research_type)
	return research_type in unlocked_research

/datum/thaumic_research_network/proc/unlock_research(research_type)
	if(research_type in unlocked_research)
		return FALSE
	unlocked_research += research_type
	return TRUE

/// The bonus of a line of research (Vibelin get_research_bonus()): 1 + the sum of the additive nodes unlocked; for a line
/// of cost reduction, the product of (1 - each), never under a twentieth; a special node's value outright.
/datum/thaumic_research_network/proc/get_research_bonus(bonus_category_path)
	if(numbers_revision != rogue_mechanics_revision())
		read_bonuses()
	var/total_additive = 0
	var/total_multiplicative = 1
	var/special_bonus = 0
	var/reduction = FALSE
	for(var/research_type in unlocked_research)
		var/datum/thaumic_research_node/node = research_nodes[research_type]
		if(!istype(node, bonus_category_path))
			continue
		switch(node.bonus_type)
			if("additive")
				total_additive += node.bonus_value
			if("multiplicative")
				total_multiplicative *= (1 - node.bonus_value)
				reduction = TRUE
			if("special")
				special_bonus = node.bonus_value
	if(special_bonus > 0)
		return special_bonus
	if(reduction || ispath(bonus_category_path, /datum/thaumic_research_node/gnome_efficency))
		return max(total_multiplicative, 0.05)
	return 1 + total_additive

/datum/thaumic_research_network/proc/get_available_research()
	. = list()
	for(var/node_type in research_nodes)
		if(node_type in unlocked_research)
			continue
		var/datum/thaumic_research_node/node = research_nodes[node_type]
		var/open = TRUE
		for(var/prerequisite in node.prerequisites)
			if(!(prerequisite in unlocked_research))
				open = FALSE
				break
		if(open)
			. += node_type

/datum/thaumic_research_network/proc/can_research(node_type)
	return node_type in get_available_research()

/// A node of the research tree (Vibelin /datum/thaumic_research_node). Its bonus, a balance number, is read by
/// read_bonus() from the mechanics values (alch_ess_rs_*); the costs in essences are the data of the node, as recipes.
/datum/thaumic_research_node
	var/name = "Unknown Research"
	var/desc = "A mysterious field of study."
	var/icon_state = "essence"
	var/list/required_essences = list()
	var/list/prerequisites = list()
	/// Where it is drawn in the window.
	var/node_x = 0
	var/node_y = 0
	var/bonus_value = 0
	/// "additive", "multiplicative" (a cost reduction) or "special".
	var/bonus_type = "additive"

/datum/thaumic_research_node/proc/read_bonus()
	return 0

/datum/thaumic_research_node/basic_understanding
	name = "Fundamental Thaumaturgy"
	desc = "The foundational principles of essence manipulation and magical theory. Understanding the basic flow of arcane energies is essential before attempting more complex workings."
	node_x = 140
	node_y = 340

/// The research that opens a machine (Vibelin thaumic_research_node/machines).
/datum/thaumic_research_node/machines
	abstract_type = /datum/thaumic_research_node/machines
	var/machine_path

/obj/machinery/essence/research_matrix
	name = "Alchemical Engine"
	desc = "A black iconosphere radiating alchemic heat. It hums expectantly."
	icon = ROGUE_ESSENCE_ALCHEMY_ICON
	icon_state = "placeholder"
	network_priority = 5
	var/datum/thaumic_research_node/selected_research
	/// Who chose the research: they learn when it completes.
	var/datum/weakref/current_user

/obj/machinery/essence/research_matrix/storage_capacity()
	return INFINITY

/obj/machinery/essence/research_matrix/storage_types()
	return rogue_essence_numbers().matrix_types

/obj/machinery/essence/research_matrix/Destroy()
	selected_research = null
	current_user = null
	return ..()

/obj/machinery/essence/research_matrix/build_allowed_types()
	if(!selected_research)
		return list()
	var/list/result = list()
	for(var/essence_type in selected_research.required_essences)
		var/deficit = selected_research.required_essences[essence_type] - storage.get(essence_type)
		if(deficit > 0)
			result[essence_type] = deficit
	return result

/obj/machinery/essence/research_matrix/push_to_linked(datum/essence_storage/from_storage)
	push_surplus_to_linked(from_storage)

/obj/machinery/essence/research_matrix/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	current_user = WEAKREF(user)
	open_research_interface(user)
	return TRUE

/// A vial pours in only what the chosen research still needs (Vibelin).
/obj/machinery/essence/research_matrix/handle_vial(obj/item/essence_vial/vial, mob/user)
	if(!vial.contained_essence || vial.essence_amount <= 0)
		to_chat(user, span_warning("The vial is empty."))
		return
	if(!selected_research)
		to_chat(user, span_warning("No research selected."))
		return
	var/deficit = get_allowed_amount(vial.contained_essence)
	if(deficit <= 0)
		to_chat(user, span_warning("This essence is not needed for the current research."))
		return
	var/poured = storage.add(vial.contained_essence, min(vial.essence_amount, deficit))
	if(poured > 0)
		vial.take_essence(poured)
		to_chat(user, span_info("You pour [poured] units into the engine."))
	current_user = WEAKREF(user)

/obj/machinery/essence/research_matrix/on_storage_changed(essence_type, amount, added)
	. = ..()
	if(added)
		check_completion()

/obj/machinery/essence/research_matrix/proc/check_completion()
	if(!selected_research)
		return
	for(var/essence_type in selected_research.required_essences)
		if(storage.get(essence_type) < selected_research.required_essences[essence_type])
			return
	complete_research()

/obj/machinery/essence/research_matrix/proc/complete_research()
	var/datum/thaumic_research_node/done = selected_research
	selected_research = null
	for(var/essence_type in done.required_essences)
		storage.remove(essence_type, done.required_essences[essence_type])
	rogue_thaumic_research().unlock_research(done.type)
	network?.invalidate_cache()
	visible_message(span_notice("[src] hums and rumbles with satisfied alchemic energy!"))
	var/mob/living/user = current_user?.resolve()
	if(istype(user))
		user.rogue_adjust_experience(ROGUE_ALCHEMY_SKILL, rogue_essence_numbers().research_xp)
		if(IsReachableBy(user))
			addtimer(CALLBACK(src, PROC_REF(open_research_interface), user), 1)

/obj/machinery/essence/research_matrix/proc/select_research(mob/user, node_type)
	var/datum/thaumic_research_network/research = rogue_thaumic_research()
	if(research.has_research(node_type))
		to_chat(user, span_warning("Already researched."))
		return
	if(!research.can_research(node_type))
		to_chat(user, span_warning("Prerequisites not met."))
		return
	selected_research = research.research_nodes[node_type]
	current_user = WEAKREF(user)
	network?.invalidate_cache()
	// What the old research needed and the new one does not goes back out (Vibelin).
	push_surplus_to_linked(storage)
	to_chat(user, span_info("Selected: [selected_research.name]"))
	check_completion()

/obj/machinery/essence/research_matrix/Topic(href, list/href_list)
	. = ..()
	if(. || href_list["action"] != "select_research")
		return
	var/mob/user = usr
	if(!istype(user) || !IsReachableBy(user))
		return
	var/node_type = text2path(href_list["node"])
	if(!ispath(node_type, /datum/thaumic_research_node))
		return
	select_research(user, node_type)
	open_research_interface(user)

/obj/machinery/essence/research_matrix/essence_examine(mob/user)
	. = ..()
	. += span_notice("Unlocked research nodes: [length(rogue_thaumic_research().unlocked_research)]")
	if(selected_research)
		. += span_notice("Selected: [selected_research.name]")
		for(var/essence_type in selected_research.required_essences)
			. += span_notice("  [rogue_essence_label(essence_type, user, "Essence of")]: [storage.get(essence_type)]/[selected_research.required_essences[essence_type]]")

/// The research window (Vibelin research_html.dm): the tree in Vibelin's places, lines from each node to what it needs;
/// known nodes gold, open ones blue, the chosen one green, closed ones grey. A click on an open node chooses it.
/obj/machinery/essence/research_matrix/proc/open_research_interface(mob/user)
	if(!user?.client)
		return
	var/datum/thaumic_research_network/research = rogue_thaumic_research()
	var/list/available = research.get_available_research()
	var/max_x = 0
	var/max_y = 0
	for(var/node_type in research.research_nodes)
		var/datum/thaumic_research_node/node = research.research_nodes[node_type]
		max_x = max(max_x, node.node_x)
		max_y = max(max_y, node.node_y)
	var/list/lines = list()
	var/list/nodes = list()
	for(var/node_type in research.research_nodes)
		var/datum/thaumic_research_node/node = research.research_nodes[node_type]
		for(var/prerequisite in node.prerequisites)
			var/datum/thaumic_research_node/before = research.research_nodes[prerequisite]
			if(before)
				lines += "<line x1='[before.node_x + 20]' y1='[before.node_y + 20]' x2='[node.node_x + 20]' y2='[node.node_y + 20]' stroke='#665577' stroke-width='2'/>"
		var/state = "closed"
		if(research.has_research(node_type))
			state = "known"
		else if(selected_research?.type == node_type)
			state = "chosen"
		else if(node_type in available)
			state = "open"
		var/list/costs = list()
		for(var/essence_type in node.required_essences)
			costs += "[rogue_essence_label(essence_type, user, "Essence of")]: [node.required_essences[essence_type]]"
		var/tip = html_encode("[node.name]\n[node.desc][length(costs) ? "\n\n[jointext(costs, "\n")]" : ""]")
		var/label = html_encode(node.name)
		if(state == "open")
			nodes += "<a class='node [state]' style='left:[node.node_x]px;top:[node.node_y]px' title='[tip]' href='byond://?src=[REF(src)];action=select_research;node=[node_type]'></a><div class='label' style='left:[node.node_x - 30]px;top:[node.node_y + 42]px'>[label]</div>"
		else
			nodes += "<div class='node [state]' style='left:[node.node_x]px;top:[node.node_y]px' title='[tip]'></div><div class='label' style='left:[node.node_x - 30]px;top:[node.node_y + 42]px'>[label]</div>"
	var/list/header = list("<p>Unlocked: [length(research.unlocked_research)]/[length(research.research_nodes)]. ")
	if(selected_research)
		var/list/progress = list()
		for(var/essence_type in selected_research.required_essences)
			progress += "[rogue_essence_label(essence_type, user, "Essence of")] [storage.get(essence_type)]/[selected_research.required_essences[essence_type]]"
		header += "Researching <b>[html_encode(selected_research.name)]</b>: [html_encode(jointext(progress, ", "))].</p>"
	else
		header += "Choose an open node.</p>"
	var/width = max_x + 120
	var/height = max_y + 100
	var/html = {"<style>
body{background:#14101a;color:#d8cfe6;font-family:Georgia,serif}
.tree{position:relative;width:[width]px;height:[height]px}
.tree svg{position:absolute;left:0;top:0}
.node{position:absolute;width:40px;height:40px;border-radius:50%;border:2px solid #444;background:#2a2433;display:block}
.node.known{background:#a8862a;border-color:#f2d36b}
.node.open{background:#2c4f7a;border-color:#8fc2ff}
.node.chosen{background:#2f6b3a;border-color:#9be3a6}
.label{position:absolute;width:100px;text-align:center;font-size:10px}
</style>[jointext(header, "")]<div class='tree'><svg width='[width]' height='[height]'>[jointext(lines, "")]</svg>[jointext(nodes, "")]</div>"}
	var/datum/browser/popup = new(user, "rogue_thaumic_research", name, min(width + 40, 1000), min(height + 120, 800))
	popup.set_content(html)
	popup.open()
