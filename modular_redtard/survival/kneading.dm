// Ratwood dishes written by hand in attackby() (modular/Neu_Food/code/raw/raw_dough.dm, raw_pies.dm, raw_meat.dm,
// raw_deep_fried.dm, others/dairy.dm, others/fat.dm, NeuFood.dm): kneading dough, pies, handpies, nitzels for the fryer, butter
// and fresh cheese. One-step changes of a food are combos below; dishes built step by step are slapcraft recipes
// (survival/recipes.dm) with Ratwood's step sprites.

/// Ratwood attackby() of one food: on a table, a tool or an ingredient in the hand turns the food into another - dough and
/// butter into butterdough, a rolling pin into flatdough, a knife into crackers. The most specific combo of a food wins.
/datum/rogue_food_combo
	/// The food worked on, with its subtypes.
	var/base
	/// What the hand holds, with subtypes; or any sharp edge (sharp_tool).
	var/tool
	var/sharp_tool = FALSE
	var/result
	var/result_count = 1
	/// Ratwood short_cooktime or long_cooktime, before the cook's skill.
	var/time = ROGUE_COOK_SHORT
	var/sound = 'modular_redtard/survival/sound/kneading.ogg'
	var/message
	/// The tool stays (a rolling pin, a knife); an ingredient is used up.
	var/keep_tool = FALSE
	/// Only raw food takes it, what still cooks into something (Ratwood tenderizes raw meat, not a fried steak).
	var/raw_only = FALSE
	/// Done on a table (most of them).
	var/needs_table = TRUE

/datum/rogue_food_combo/proc/fits(obj/item/reagent_containers/food/food, obj/item/held)
	if(!istype(food, base))
		return FALSE
	if(raw_only && !food.cooked_type && !food.fried_type)
		return FALSE
	return sharp_tool ? !!held.get_sharpness() : istype(held, tool)

/datum/rogue_food_combo/proc/perform(mob/living/user, obj/item/reagent_containers/food/food, obj/item/held)
	if(needs_table && !(isturf(food.loc) && (locate(/obj/structure/table) in food.loc)))
		to_chat(user, span_warning("I need to put [food] on a table to work it."))
		return ITEM_INTERACT_BLOCKING
	if(message)
		to_chat(user, span_notice(message))
	if(sound)
		playsound(food, sound, 100, TRUE, -1)
	if(!do_after(user, time / rogue_cook_divisor(user), target = food) || QDELETED(food) || QDELETED(held))
		return ITEM_INTERACT_BLOCKING
	user.rogue_cooking_experience()
	var/turf/spot = get_turf(food)
	for(var/i in 1 to result_count)
		new result(spot)
	if(!keep_tool)
		qdel(held)
	qdel(food)
	return ITEM_INTERACT_SUCCESS

GLOBAL_LIST_INIT(rogue_food_combos, init_rogue_food_combos())

/proc/init_rogue_food_combos()
	. = list()
	for(var/combo_type in subtypesof(/datum/rogue_food_combo))
		var/datum/rogue_food_combo/combo = new combo_type
		if(combo.base && combo.result && (combo.tool || combo.sharp_tool))
			. += combo

/// The combo for this food and what the hand holds; of several, the one for the most specific food.
/proc/rogue_food_combo_for(obj/item/reagent_containers/food/food, obj/item/held)
	var/datum/rogue_food_combo/best
	for(var/datum/rogue_food_combo/combo as anything in GLOB.rogue_food_combos)
		if(!combo.fits(food, held))
			continue
		if(!best || ispath(combo.base, best.base))
			best = combo
	return best

/obj/item/reagent_containers/food/proc/rogue_combo_interaction(mob/living/user, obj/item/tool)
	if(rotten || (tool.item_flags & ABSTRACT))
		return NONE
	var/datum/rogue_food_combo/combo = rogue_food_combo_for(src, tool)
	if(!combo)
		return NONE
	return combo.perform(user, src, tool)

// Dough (raw_dough.dm).

/datum/rogue_food_combo/dough_base
	base = /obj/item/reagent_containers/food/snacks/rogue/dough_base
	tool = /obj/item/reagent_containers/powder/flour
	result = /obj/item/reagent_containers/food/snacks/rogue/dough
	message = "Kneading in more powder..."

/datum/rogue_food_combo/butterdough
	base = /obj/item/reagent_containers/food/snacks/rogue/dough
	tool = /obj/item/reagent_containers/food/snacks/butterslice
	result = /obj/item/reagent_containers/food/snacks/rogue/butterdough
	time = ROGUE_COOK_LONG
	sound = 'modular_redtard/survival/sound/kneading_alt.ogg'
	message = "Kneading butter into the dough..."

/datum/rogue_food_combo/flatdough
	base = /obj/item/reagent_containers/food/snacks/rogue/dough
	tool = /obj/item/kitchen/rollingpin
	result = /obj/item/reagent_containers/food/snacks/rogue/flatdough
	time = ROGUE_COOK_LONG
	sound = 'modular_redtard/survival/sound/rollingpin.ogg'
	message = "Rolling the dough flat and thin..."
	keep_tool = TRUE

/datum/rogue_food_combo/combine_dough
	base = /obj/item/reagent_containers/food/snacks/rogue/doughslice
	tool = /obj/item/reagent_containers/food/snacks/rogue/doughslice
	result = /obj/item/reagent_containers/food/snacks/rogue/dough
	message = "Combining dough..."

/datum/rogue_food_combo/hardtack
	base = /obj/item/reagent_containers/food/snacks/rogue/flatdough
	sharp_tool = TRUE
	result = /obj/item/reagent_containers/food/snacks/rogue/foodbase/hardtack_raw
	result_count = 2
	time = ROGUE_COOK_LONG
	sound = 'modular_redtard/survival/sound/rollingpin.ogg'
	message = "Scoring lines into the flatdough..."
	keep_tool = TRUE

/datum/rogue_food_combo/piedough
	base = /obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	tool = /obj/item/kitchen/rollingpin
	result = /obj/item/reagent_containers/food/snacks/rogue/piedough
	sound = 'modular_redtard/survival/sound/rollingpin.ogg'
	message = "Flattening the butterdough..."
	keep_tool = TRUE

// Meat for the fryer (raw_meat.dm) and sausages (fat.dm).

/datum/rogue_food_combo/nitzel
	base = /obj/item/reagent_containers/food/snacks/rogue/meat
	tool = /obj/item/kitchen/rollingpin
	result = /obj/item/reagent_containers/food/snacks/rogue/foodbase/nitzel
	time = ROGUE_COOK_LONG
	sound = 'modular_redtard/survival/sound/rollingpin.ogg'
	message = "Tenderizing the meat into a nitzel..."
	keep_tool = TRUE
	raw_only = TRUE

/datum/rogue_food_combo/nitzel/schnitzel
	base = /obj/item/reagent_containers/food/snacks/rogue/meat/spider
	result = /obj/item/reagent_containers/food/snacks/rogue/foodbase/schnitzel
	message = "Tenderizing the spidermeat into a schnitzel..."

/datum/rogue_food_combo/nitzel/chickentender
	base = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet
	result = /obj/item/reagent_containers/food/snacks/rogue/foodbase/chickentender
	message = "Tenderizing the bird meat..."

/datum/rogue_food_combo/nitzel/wienernitzel
	base = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage
	result = /obj/item/reagent_containers/food/snacks/rogue/foodbase/wienernitzel
	message = "Tenderizing the sausage..."

/datum/rogue_food_combo/sausage
	base = /obj/item/reagent_containers/food/snacks/fat
	tool = /obj/item/reagent_containers/food/snacks/rogue/meat/mince
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage
	time = ROGUE_COOK_LONG
	sound = 'modular_redtard/survival/sound/food_drop.ogg'
	message = "Stuffing a wiener..."

/datum/rogue_food_combo/squires_delight
	base = /obj/item/reagent_containers/food/snacks/butter
	tool = /obj/item/reagent_containers/food/snacks/egg
	result = /obj/item/reagent_containers/food/snacks/rogue/foodbase/squires_delight
	sound = 'modular_redtard/survival/sound/eggbreak.ogg'
	message = "Cracking an egg over the butter..."
	needs_table = FALSE

// Flour and water (NeuFood.dm powder/flour wet()).

/obj/item/reagent_containers/powder/flour
	/// Water is in; a hand kneads it into unfinished dough.
	var/water_added = FALSE

/obj/item/reagent_containers/powder/flour/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(water_added || !istype(tool, /obj/item/reagent_containers) || !tool.is_open_container())
		return ..()
	if(isturf(loc) && !(locate(/obj/structure/table) in loc))
		to_chat(user, span_notice("Need a table..."))
		return ITEM_INTERACT_BLOCKING
	if(!tool.reagents.has_reagent(/datum/reagent/water, ROGUE_FLOUR_WATER))
		to_chat(user, span_notice("Needs more water to work it."))
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice("Adding water, now it's time to knead it..."))
	playsound(src, 'modular_redtard/survival/sound/splishy.ogg', 100, TRUE, -1)
	if(!do_after(user, ROGUE_COOK_SHORT / rogue_cook_divisor(user), target = src) || water_added)
		return ITEM_INTERACT_BLOCKING
	if(!tool.reagents.has_reagent(/datum/reagent/water, ROGUE_FLOUR_WATER))
		return ITEM_INTERACT_BLOCKING
	tool.reagents.remove_reagent(/datum/reagent/water, ROGUE_FLOUR_WATER)
	user.rogue_cooking_experience()
	water_added = TRUE
	name = "wet flour"
	desc = "Destined for greatness, at your hands."
	add_atom_colour("#d9d0cb", FIXED_COLOUR_PRIORITY)
	return ITEM_INTERACT_SUCCESS

/// Ratwood flour attack_hand(): wet flour is kneaded into unfinished dough instead of picked up.
/obj/item/reagent_containers/powder/flour/attack_hand(mob/user, list/modifiers)
	if(!water_added || !isliving(user))
		return ..()
	INVOKE_ASYNC(src, PROC_REF(knead), user)
	return TRUE

/obj/item/reagent_containers/powder/flour/proc/knead(mob/living/user)
	playsound(src, 'modular_redtard/survival/sound/kneading_alt.ogg', 90, TRUE, -1)
	if(!do_after(user, ROGUE_COOK_SHORT / rogue_cook_divisor(user), target = src) || QDELETED(src))
		return
	user.rogue_cooking_experience()
	new /obj/item/reagent_containers/food/snacks/rogue/dough_base(drop_location())
	qdel(src)

/obj/item/reagent_containers/powder/flour/examine(mob/user)
	. = ..()
	if(water_added)
		. += span_smallnotice("Knead it by hand into dough.")
	else
		. += span_smallnotice("Add ten units of water on a table to make dough.")

// Butter and cheese (dairy.dm): salt turns milk salted in a vessel; a spoon churns salted milk into butter in a bucket or a
// pot, a cloth strains it into fresh cheese.

/obj/item/reagent_containers/glass/proc/salt_milk(mob/living/user, obj/item/salt)
	if(!reagents.has_reagent(/datum/reagent/consumable/milk, ROGUE_MILK_PER_SALT))
		to_chat(user, span_warning("Not enough milk."))
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice("Adding salt to the milk."))
	playsound(src, pick('modular_redtard/survival/sound/waterwash1.ogg', 'modular_redtard/survival/sound/waterwash2.ogg'), 100, FALSE)
	if(!do_after(user, ROGUE_COOK_SHORT / rogue_cook_divisor(user), target = src) || QDELETED(salt))
		return ITEM_INTERACT_BLOCKING
	if(!reagents.has_reagent(/datum/reagent/consumable/milk, ROGUE_MILK_PER_SALT))
		return ITEM_INTERACT_BLOCKING
	user.rogue_cooking_experience()
	reagents.remove_reagent(/datum/reagent/consumable/milk, ROGUE_MILK_PER_SALT)
	reagents.add_reagent(/datum/reagent/consumable/milk/salted, ROGUE_MILK_PER_SALT, reagtemp = reagents.chem_temp)
	qdel(salt)
	return ITEM_INTERACT_SUCCESS

/obj/item/reagent_containers/glass/bucket/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/kitchen/spoon) && reagents.has_reagent(/datum/reagent/consumable/milk/salted))
		return churn_butter(user)
	if(istype(tool, /obj/item/natural/cloth) && reagents.has_reagent(/datum/reagent/consumable/milk/salted))
		return strain_cheese(user)
	return ..()

/obj/item/reagent_containers/glass/bucket/proc/churn_butter(mob/living/user)
	if(!reagents.has_reagent(/datum/reagent/consumable/milk/salted, ROGUE_MILK_PER_BUTTER))
		to_chat(user, span_warning("Not enough salted milk."))
		return ITEM_INTERACT_BLOCKING
	user.visible_message(span_info("[user] churns butter..."), span_info("I churn butter..."))
	playsound(src, 'modular_redtard/survival/sound/churn.ogg', 100, TRUE, -1)
	if(!do_after(user, ROGUE_COOK_LONG / rogue_cook_divisor(user), target = src))
		return ITEM_INTERACT_BLOCKING
	if(!reagents.has_reagent(/datum/reagent/consumable/milk/salted, ROGUE_MILK_PER_BUTTER))
		return ITEM_INTERACT_BLOCKING
	user.rogue_cooking_experience()
	reagents.remove_reagent(/datum/reagent/consumable/milk/salted, ROGUE_MILK_PER_BUTTER)
	new /obj/item/reagent_containers/food/snacks/butter(drop_location())
	return ITEM_INTERACT_SUCCESS

/obj/item/reagent_containers/glass/bucket/proc/strain_cheese(mob/living/user)
	if(!reagents.has_reagent(/datum/reagent/consumable/milk/salted, ROGUE_MILK_PER_CHEESE))
		to_chat(user, span_warning("Not enough salted milk."))
		return ITEM_INTERACT_BLOCKING
	user.visible_message(span_info("[user] strains fresh cheese..."), span_info("I strain fresh cheese..."))
	playsound(src, pick('modular_redtard/survival/sound/waterwash1.ogg', 'modular_redtard/survival/sound/waterwash2.ogg'), 100, FALSE)
	if(!do_after(user, ROGUE_COOK_LONG / rogue_cook_divisor(user), target = src))
		return ITEM_INTERACT_BLOCKING
	if(!reagents.has_reagent(/datum/reagent/consumable/milk/salted, ROGUE_MILK_PER_CHEESE))
		return ITEM_INTERACT_BLOCKING
	user.rogue_cooking_experience()
	reagents.remove_reagent(/datum/reagent/consumable/milk/salted, ROGUE_MILK_PER_CHEESE)
	new /obj/item/reagent_containers/food/snacks/rogue/cheese(drop_location())
	return ITEM_INTERACT_SUCCESS

// Step-by-step dishes as slapcraft recipes (raw_pies.dm, raw_deep_fried.dm, piedough prepare_handpie()).

/// Ratwood big pies: a pie bottom (piedough baked in the oven) takes three servings of one filling and a piedough roof, then
/// bakes into the pie.
/datum/rogue_food_recipe/pie
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/piebottom
	needs_cooking = TRUE
	overlay_icon = 'modular_redtard/survival/icons/raw_pies.dmi'

/datum/rogue_food_recipe/pie/meat
	name = "Meat Pie"
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef, /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef, /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef, /obj/item/reagent_containers/food/snacks/rogue/piedough)
	step_overlays = list("fill_meat1", "fill_meat2", "fill_meat3", "meatpie_raw")
	result_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat
	started_name = "unfinished meat pie"
	ready_name = "uncooked meat pie"
	ready_smell = "meat pie"

/datum/rogue_food_recipe/pie/fish
	name = "Fish Pie"
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish, /obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish, /obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish, /obj/item/reagent_containers/food/snacks/rogue/piedough)
	step_overlays = list("fill_fish1", "fill_fish2", "fill_fish3", "fishpie_raw")
	result_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat/fish
	started_name = "unfinished fish pie"
	ready_name = "uncooked fish pie"
	ready_smell = "fish pie"

/datum/rogue_food_recipe/pie/apple
	name = "Apple Pie"
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/apple, /obj/item/reagent_containers/food/snacks/grown/apple, /obj/item/reagent_containers/food/snacks/grown/apple, /obj/item/reagent_containers/food/snacks/rogue/piedough)
	step_overlays = list("fill_apple1", "fill_apple2", "fill_apple3", "pieuncooked")
	result_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/apple
	started_name = "unfinished apple pie"
	ready_name = "uncooked apple pie"
	ready_smell = "apple pie"

/// Jacksberries and their poisoned look-alikes make pies that look the same.
/datum/rogue_food_recipe/pie/berry
	name = "Berry Pie"
	exact_types = TRUE
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue, /obj/item/reagent_containers/food/snacks/grown/berries/rogue, /obj/item/reagent_containers/food/snacks/grown/berries/rogue, /obj/item/reagent_containers/food/snacks/rogue/piedough)
	step_overlays = list("fill_berry1", "fill_berry2", "fill_berry3", "pieuncooked")
	result_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/berry
	started_name = "unfinished berrypie"
	ready_name = "uncooked berry pie"
	ready_smell = "berry pie"

/datum/rogue_food_recipe/pie/berry/poison
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison, /obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison, /obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison, /obj/item/reagent_containers/food/snacks/rogue/piedough)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/poison

/// Ratwood pot pie: any three of cheese, potato, egg and fatty meat.
/datum/rogue_food_recipe/pie/pot
	name = "Pot Pie"
	step_overlays = list("fill_pot1", "fill_pot2", "fill_pot3", "pieuncooked")
	result_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/pot
	started_name = "unfinished pot pie"
	ready_name = "uncooked pot pie"
	ready_smell = "pot pie"

/datum/rogue_food_recipe/pie/pot/New()
	. = ..()
	var/list/filling = list(
		/obj/item/reagent_containers/food/snacks/rogue/cheddarwedge,
		/obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced,
		/obj/item/reagent_containers/food/snacks/rogue/cheese,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/rogue/meat/bacon,
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/poultry,
		/obj/item/reagent_containers/food/snacks/fat,
	)
	ingredients = list(filling, filling, filling, /obj/item/reagent_containers/food/snacks/rogue/piedough)

/// Ratwood crab pie: crab meat first; shredded cabbage may stand in for the rest of the crab.
/datum/rogue_food_recipe/pie/crab
	name = "Crab Pie"
	step_overlays = list("fill_crab1", "fill_crab2", "fill_crab3", "pieuncooked")
	result_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/crab
	started_name = "unfinished crab pie"
	ready_name = "uncooked crab pie"
	ready_smell = "crab pie"

/datum/rogue_food_recipe/pie/crab/New()
	. = ..()
	var/list/filling = list(/obj/item/reagent_containers/food/snacks/rogue/meat/crab, /obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced)
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/meat/crab, filling, filling, /obj/item/reagent_containers/food/snacks/rogue/piedough)

/// Ratwood prepare_handpie(): piedough wrapped around minced fish or meat.
/datum/rogue_food_recipe/handpie_fish
	name = "Fish Handpie"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/piedough
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/fish

/datum/rogue_food_recipe/handpie_meat
	name = "Meat Handpie"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/piedough
	exact_types = TRUE
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/meat

/datum/rogue_food_recipe/handpie_meat/New()
	. = ..()
	ingredients = list(list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince,
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef,
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/poultry,
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/spider,
	))

/// Ratwood nitzels (raw_deep_fried.dm): tenderized meat takes an egg, then toastcrumbs, and is deep fried in tallow.
/datum/rogue_food_recipe/nitzel
	name = "Nitzel"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/nitzel
	ingredients = list(/obj/item/reagent_containers/food/snacks/egg, /obj/item/reagent_containers/food/snacks/rogue/toastcrumbs)
	step_icon_states = list("nitzel_step2", "nitzel_step3")
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/nitzel
	needs_cooking = TRUE
	deep_fry = TRUE
	started_name = "nitzel with egg"
	ready_name = "nitzel with toastcrumbs"

/datum/rogue_food_recipe/nitzel/schnitzel
	name = "Schnitzel"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/schnitzel
	step_icon_states = list("schnitzel_step2", "schnitzel_step3")
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/nitzel/schnitzel
	started_name = "schnitzel with egg"
	ready_name = "schnitzel with toastcrumbs"

/datum/rogue_food_recipe/nitzel/chickentender
	name = "Tender Frybird"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/chickentender
	step_icon_states = list("chickentender_step2", "chickentender_step3")
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/chickentender
	started_name = "tender frybird with egg"
	ready_name = "tender frybird with toastcrumbs"

/datum/rogue_food_recipe/nitzel/wiener
	name = "Wiener Nitzel"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/wienernitzel
	step_icon_states = list("wienernitzel_step2", "wienernitzel_step3")
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/nitzel/wiener
	started_name = "wiener nitzel with egg"
	ready_name = "wiener nitzel with toastcrumbs"

/datum/rogue_food_recipe/nitzel/squires_delight
	name = "Squire's Delight"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/squires_delight
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/toastcrumbs)
	step_icon_states = list("squiresdelight_step2")
	result_type = /obj/item/reagent_containers/food/snacks/squiresdelight
	started_name = null
	ready_name = "squire's delight with toastcrumbs"
