/// Ratwood slapcraft recipe (code/controllers/subsystem/rogue/cooking/cooking_recipes.dm, /datum/food_recipe): start with the
/// base item on a table and add the ingredients in order, items or reagents from a container; the result appears, or the base
/// becomes ready to be cooked into it (needs_cooking). The recipes themselves are ported (survival/ported/food.dm).
/datum/rogue_food_recipe
	var/name = "Generic Recipe"
	/// What the recipe starts with (exact type).
	var/base_item
	/// Item types and reagent = amount, in order.
	var/list/ingredients = list()
	var/result_type
	/// The finished dish still has to be cooked (pan, fire or oven).
	var/needs_cooking = FALSE
	/// Time of each step before the cook's skill.
	var/time_per_step = 2 SECONDS

/// What to add at a step, for messages.
/datum/rogue_food_recipe/proc/step_name(step)
	var/requirement = ingredients[step]
	if(ispath(requirement, /datum/reagent))
		var/datum/reagent/reagent = requirement
		return "[ingredients[requirement]] units of [initial(reagent.name)]"
	var/atom/thing = requirement
	return initial(thing.name)

/// Ratwood SScooking.recipe_index: base type to the recipes that start with it.
GLOBAL_LIST_INIT(rogue_food_recipes, init_rogue_food_recipes())

/proc/init_rogue_food_recipes()
	var/list/index = list()
	for(var/recipe_type in subtypesof(/datum/rogue_food_recipe))
		var/datum/rogue_food_recipe/recipe = new recipe_type
		if(!recipe.base_item || !recipe.result_type || !length(recipe.ingredients))
			continue
		LAZYADDASSOCLIST(index, recipe.base_item, recipe)
	return index

/// Ratwood SScooking.get_recipe(): the recipe of this base whose first step the ingredient fits.
/proc/rogue_food_recipe_for(obj/item/base, obj/item/ingredient)
	for(var/datum/rogue_food_recipe/recipe as anything in GLOB.rogue_food_recipes[base.type])
		var/first = recipe.ingredients[1]
		if(ispath(first, /datum/reagent))
			if(ingredient.reagents?.has_reagent(first, recipe.ingredients[first]))
				return recipe
		else if(istype(ingredient, first))
			return recipe
	return null
