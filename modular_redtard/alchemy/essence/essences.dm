// Vibelin's (Vanderlin's) thaumaturgical essences (crafting/alchemy/essences.dm, essence_combinations.dm, precursors.dm,
// infusion_recipes.dm): the bases of the essences, the combiner's mixes, what the splitter splits an item into and the
// infuser's recipes. The values of every subtype are written by tools/port_vibelin_alchemy.py into alchemy/vibelin/
// (BASES in the script names these bases and their vars); this file declares the bases and every proc.

/// An essence (Vibelin /datum/thaumaturgical_essence): tier 0 basic, 1 the first compound, 2 the second.
/datum/thaumaturgical_essence
	var/name = "essence"
	var/desc = "A concentrated magical essence."
	var/tier = 0
	var/color = "#FFFFFF"
	var/icon_state = "essence_basic"
	/// What an alchemist who cannot tell essences apart smells of it.
	var/smells_like = "magic"
	/// The school of magic the essence is tied to (Vibelin /datum/attunement). The module's magic has no attunements yet
	/// (block VM2), so the generator leaves it unset; it is kept for the essence gauntlet and the enchantment altar.
	var/attunement

/// What an alchemist calls an essence: its name to a legendary herb finder, its smell to anyone else (Vibelin's labels).
/proc/rogue_essence_label(essence_type, mob/user, prefix = "essence smelling of")
	if(!ispath(essence_type, /datum/thaumaturgical_essence))
		return "nothing"
	var/datum/thaumaturgical_essence/essence = essence_type
	if(user && HAS_TRAIT(user, TRAIT_LEGENDARY_ALCHEMIST))
		return initial(essence.name)
	return "[prefix] [initial(essence.smells_like)]"

/// A mix of the combiner (Vibelin /datum/essence_combination): inputs, list(essence = units), give output_amount units
/// of output_type. The combiner run by hand needs skill_required in Alchemy; run by itself it needs none (Vibelin).
/datum/essence_combination
	abstract_type = /datum/essence_combination
	var/category = "Essence Combination"
	var/name = "essence combination"
	var/list/inputs = list()
	var/output_type
	var/output_amount = 1
	var/skill_required = ROGUE_RANK_NOVICE

/// Whether available, list(essence = units), holds the inputs of one batch.
/datum/essence_combination/proc/fits(list/available)
	for(var/essence_type in inputs)
		if((available[essence_type] || 0) < inputs[essence_type])
			return FALSE
	return TRUE

/// One of each mix, by type (Vibelin makes and deletes a new one for every look).
/proc/rogue_essence_combinations()
	var/static/list/combinations
	if(!combinations)
		combinations = list()
		for(var/combination_type in subtypesof(/datum/essence_combination))
			var/datum/essence_combination/combination = combination_type
			if(initial(combination.abstract_type) == combination_type)
				continue
			combinations[combination_type] = new combination_type
	return combinations

/// What the splitter and the extractor make of an item (Vibelin /datum/natural_precursor): essence_yields,
/// list(essence = units), for every type in init_types.
/datum/natural_precursor
	abstract_type = /datum/natural_precursor
	var/category = "Precursor"
	var/name = "precursor"
	var/list/essence_yields = list()
	var/list/init_types = list()

/// The precursors by item type (Vibelin natural_precursor_registry); the very type only, as Vibelin.
/proc/rogue_natural_precursors()
	var/static/list/registry
	if(!registry)
		registry = list()
		for(var/precursor_type in subtypesof(/datum/natural_precursor))
			var/datum/natural_precursor/precursor = precursor_type
			if(initial(precursor.abstract_type) == precursor_type)
				continue
			precursor = new precursor_type
			for(var/item_type in precursor.init_types)
				registry[item_type] = precursor
	return registry

/// The precursor of an item, or FALSE (Vibelin get_precursor_data()): what the splitter splits it into and what the
/// cauldron's alchemist smells of it.
/proc/get_precursor_data(obj/item/thing)
	if(!thing)
		return FALSE
	var/list/registry = rogue_natural_precursors()
	return registry[thing.type] || FALSE

/// A recipe of the infuser (Vibelin /datum/infusion_recipe): an item of target_type, soaked in required_essences,
/// list(essence = units), becomes a result_type. infusion_time is the infuser's (alch_ess_infuser_time), not the recipe's.
/datum/infusion_recipe
	abstract_type = /datum/infusion_recipe
	var/category = "Infusions"
	var/name = "infusion recipe"
	var/target_type
	var/list/required_essences = list()
	var/result_type

/// One of each infusion, by type.
/proc/rogue_infusion_recipes()
	var/static/list/recipes
	if(!recipes)
		recipes = list()
		for(var/recipe_type in subtypesof(/datum/infusion_recipe))
			var/datum/infusion_recipe/recipe = recipe_type
			if(initial(recipe.abstract_type) == recipe_type)
				continue
			recipes[recipe_type] = new recipe_type
	return recipes

/// Every infusion an item can take.
/proc/rogue_infusions_for(obj/item/thing)
	. = list()
	if(!thing)
		return
	var/list/recipes = rogue_infusion_recipes()
	for(var/recipe_type in recipes)
		var/datum/infusion_recipe/recipe = recipes[recipe_type]
		if(recipe.target_type && istype(thing, recipe.target_type))
			. += recipe

/// The weighted colour of a mix of essences (Vibelin calculate_mixture_color()): each essence weighs units × (tier + 1).
/proc/rogue_essence_mix_color(list/contents, fallback = "#4A90E2")
	if(!length(contents))
		return fallback
	var/total_weight = 0
	var/red = 0
	var/green = 0
	var/blue = 0
	for(var/essence_type in contents)
		var/datum/thaumaturgical_essence/essence = essence_type
		var/weight = contents[essence_type] * (initial(essence.tier) + 1)
		var/list/rgb = rgb2num(initial(essence.color))
		total_weight += weight
		red += rgb[1] * weight
		green += rgb[2] * weight
		blue += rgb[3] * weight
	if(!total_weight)
		return fallback
	return rgb(floor(red / total_weight), floor(green / total_weight), floor(blue / total_weight))
