// Vibelin's (Vanderlin's) distillation (reagents/chemistry/recipes/distillation/_base.dm, structures/seperator.dm): the
// alembic is TG's distillation apparatus (/obj/structure/chem_separator: a burner on a fuel flask, the flask to distil, the
// flask that takes the distillate) with Vibelin's recipes on top. Each tick, before TG's own distillation, a reagent of the
// flask that has a distillation recipe, once the flask is hot enough for it and holds the reagents the recipe asks for, is
// turned at alch_brew_still_rate units a second into the recipe's results in the receiving flask; what has no recipe boils
// off as TG's apparatus boils it. The recipes are data written by tools/port_vibelin_alchemy.py (alchemy/vibelin/).
// The alembic is built from the crafting menu on medieval maps only; TG's apparatus is untouched.

/// A distillation recipe (Vibelin /datum/distillation_recipe): distilled_reagent, boiled at required_temp or hotter with
/// required_reagents in the flask (spent with it when consume_reagents), gives results, list(reagent = units per unit).
/datum/distillation_recipe
	abstract_type = /datum/distillation_recipe
	var/name
	var/id
	var/distilled_reagent
	var/list/required_reagents = list()
	var/consume_reagents = FALSE
	var/list/results = list()
	var/required_temp = T0C + 100
	/// Said and played once a run, when the recipe first gives (a sound file, or Vibelin's "bubbles").
	var/distill_message
	var/distill_sound

/// What else a recipe does as it gives (Vibelin on_distill()).
/datum/distillation_recipe/proc/on_distill(datum/reagents/holder, datum/reagents/output, distilled_amount)
	return

/// Whether the flask holds what the recipe asks for besides the distilled reagent, hot enough.
/datum/distillation_recipe/proc/fits(datum/reagents/mixture)
	if(mixture.chem_temp < required_temp)
		return FALSE
	for(var/reagent_type in required_reagents)
		if(mixture.get_reagent_amount(reagent_type) < required_reagents[reagent_type])
			return FALSE
	return TRUE

/// The recipes by the reagent they distil, list(reagent type = list(recipe, ...)) (Vibelin setup_distillation_recipes()).
/proc/rogue_distillation_recipes()
	var/static/list/recipes
	if(!recipes)
		recipes = list()
		for(var/recipe_type in valid_subtypesof(/datum/distillation_recipe))
			var/datum/distillation_recipe/recipe = new recipe_type
			if(!recipe.distilled_reagent)
				qdel(recipe)
				continue
			LAZYADDASSOCLIST(recipes, recipe.distilled_reagent, recipe)
	return recipes

/// The recipe a reagent of the flask distils by now, or null (Vibelin find_distillation_recipe()).
/proc/rogue_distillation_recipe(datum/reagent/distilled, datum/reagents/mixture)
	var/list/recipes = rogue_distillation_recipes()
	for(var/datum/distillation_recipe/recipe as anything in recipes[distilled.type])
		if(recipe.fits(mixture))
			return recipe

/obj/structure/chem_separator/rogue
	name = "alembic"
	desc = "A device for separating liquids from each other through distillation."
	/// The recipe that gave last, for its message to be said once a run.
	var/datum/distillation_recipe/rogue_announced

/obj/structure/chem_separator/rogue/process(seconds_per_tick)
	if(rogue_medieval_map())
		rogue_distill(seconds_per_tick)
	return ..()

/// Vibelin's recipes on the boiling flask: one reagent a tick, at the still's rate, into the receiving flask.
/obj/structure/chem_separator/rogue/proc/rogue_distill(seconds_per_tick)
	if(!reagents.total_volume || QDELETED(distilled_container))
		rogue_announced = null
		return
	var/datum/reagents/output = distilled_container.reagents
	if(output.holder_full())
		return
	for(var/datum/reagent/distilled as anything in reagents.reagent_list)
		var/datum/distillation_recipe/recipe = rogue_distillation_recipe(distilled, reagents)
		if(!recipe)
			continue
		var/amount = min(rogue_brew_numbers().still_rate * seconds_per_tick, distilled.volume)
		if(amount <= 0)
			continue
		var/distilled_type = distilled.type
		reagents.remove_reagent(distilled_type, amount)
		if(recipe.consume_reagents)
			for(var/reagent_type in recipe.required_reagents)
				reagents.remove_reagent(reagent_type, recipe.required_reagents[reagent_type] * amount / max(rogue_brew_numbers().still_rate, 1))
		var/list/made = list()
		for(var/result_type in recipe.results)
			made[result_type] = recipe.results[result_type] * amount
		output.add_reagent_list(made)
		recipe.on_distill(reagents, output, amount)
		if(rogue_announced != recipe)
			rogue_announced = recipe
			if(recipe.distill_message)
				visible_message(span_notice(recipe.distill_message))
			if(recipe.distill_sound)
				playsound(src, isfile(recipe.distill_sound) ? recipe.distill_sound : 'sound/effects/bubbles/bubbles.ogg', 50, TRUE)
		return

/datum/crafting_recipe/roguetown/alchemy/alembic
	name = "alembic"
	result = /obj/structure/chem_separator/rogue
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/glass = 1)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_difficulty = 1
