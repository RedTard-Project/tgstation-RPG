/// What Ratwood's crafting reaches on medieval maps: what is held or lies around makes a thing, and a tool works from the
/// hands, the ground around, the belt or a hip. TG counts every worn thing as an ingredient (range() holds the crafter's own
/// contents) and every tool in any bag the crafter carries (get_surroundings()).

/// Worn things are no ingredients: of the crafter's own contents only what is held stays.
/datum/component/personal_crafting/get_environment(atom/a, list/blacklist = null, radius_range = 1)
	. = ..()
	if(!ismob(a) || !rogue_combat_enabled())
		return
	var/mob/crafter = a
	for(var/obj/item/worn in crafter.contents)
		if(!(worn in crafter.held_items))
			. -= worn

/// Tools come from the hands and the ground around (get_environment()) and from what hangs on the belt and the hips, none
/// from a bag. The keys are TG's CONTENTS_TOOL_BEHAVIOUR and CONTENTS_POSSIBLE_TOOLS, undefined after _crafting.dm.
/datum/component/personal_crafting/get_surroundings(atom/source, list/blacklist = null)
	. = ..()
	if(!ismob(source) || !rogue_combat_enabled())
		return
	var/mob/crafter = source
	var/list/tools = list()
	for(var/obj/item/item in get_environment(source, blacklist))
		tools += item
	for(var/slot in list(ITEM_SLOT_BELT, ITEM_SLOT_LPOCKET, ITEM_SLOT_RPOCKET))
		var/obj/item/hung = crafter.get_item_by_slot(slot)
		if(hung)
			tools |= hung
	var/list/behaviours = list()
	for(var/obj/item/tool as anything in tools)
		if(tool.tool_behaviour && behaviours[tool.tool_behaviour] < tool.toolspeed)
			behaviours[tool.tool_behaviour] = tool.toolspeed
	.["tool_behaviour"] = behaviours
	.["tool_instances"] = tools

/// The recipe card tells how hard a recipe of Ratwood's is and the crafter's chance of each try (rogue_chance()): a failed try
/// is no failed craft, the crafter tries again each second until it works or they stop.
/datum/component/personal_crafting/ui_static_data(mob/user)
	. = ..()
	if(!isliving(user) || !rogue_combat_enabled())
		return
	for(var/list/entry as anything in .["recipes"])
		var/datum/crafting_recipe/roguetown/recipe = locate(entry["ref"])
		if(!istype(recipe))
			continue
		var/note = recipe.rogue_chance_note(user)
		if(note)
			entry["desc"] = "[entry["desc"]] [note]"

/// "(Sewing, difficulty 1: 25% a try.)" for the recipe card, or null when no skill decides the recipe.
/datum/crafting_recipe/roguetown/proc/rogue_chance_note(mob/living/user)
	if(!rogue_skill)
		return null
	var/datum/attribute/skill/skill = rogue_skill
	var/chance = rogue_chance(user)
	if(!chance)
		return "([initial(skill.name)], difficulty [rogue_difficulty]: beyond my skill.)"
	return "([initial(skill.name)], difficulty [rogue_difficulty]: [chance]% a try, and I keep trying until it works or I stop.)"
