// Vibelin's (Vanderlin's) brewing on Ratwood's apparatus (crafting/alchemy/cauldron.dm, cauldron_recipes.dm,
// reagent_containers/mortar.dm, grind_recipes.dm, game/objects/items.dm examine()): the cauldron brews a potion from the
// essences poured into it with a vial or fed to it through its node in the essence network (alchemy/essence/), as many
// batches as the essences give, by the recipe the alchemist chose; a recipe keeps Ratwood's rank of Alchemy. The mortar grinds
// a whole batch of things at once. A thing the essence splitter takes smells of its essences.
// The recipes are data: Vibelin's cauldron recipes and the mortar recipes of Vibelin and Azure Peak are written by
// tools/port_vibelin_alchemy.py (alchemy/vibelin/), Ratwood's mortar recipes by the Rockhill porter (alchemy/ported/alchemy.dm).
// Everything here is Ratwood's and Vibelin's types, met only on medieval maps; the smell of a thing shows only there.
// Fixes on Vibelin: a recipe that needs no essence never matches (Vibelin would brew 999 batches of it from an empty
// cauldron); a chosen recipe waits for all its essences before it boils, and the node feeds the cauldron only what the
// recipe takes (the rest is pushed back out); the mortar's bonus by rank works (Vibelin compares the learning boon with a
// rank and never gives it).

#define ALCH_BREW_BUBBLE_SOUND 'sound/effects/bubbles/bubbles.ogg'
#define ALCH_BREW_DONE_SOUND 'modular_redtard/rockhill/sound/misc/smelter_fin.ogg'
#define ALCH_BREW_GRIND_SOUND 'modular_redtard/rockhill/sound/foley/mortarpestle.ogg'
#define ALCH_BREW_CLEAR "Clear Recipe"

/// The numbers of brewing (alch_brew_* and the older names in the mechanics values, alchemy.txt), read once and again only
/// when the mechanics revision moves (as survival/sleep.dm): the cauldron and the still read them every tick.
/proc/rogue_brew_numbers()
	RETURN_TYPE(/datum/rogue_brew_numbers)
	var/static/datum/rogue_brew_numbers/numbers
	if(!numbers)
		numbers = new
	if(numbers.revision != rogue_mechanics_revision())
		numbers.read()
	return numbers

/datum/rogue_brew_numbers
	var/revision = -1
	// The cauldron.
	var/brew_ticks
	var/water
	var/essence_types
	var/xp_per_int
	var/bubble_chance
	// The mortar.
	var/mortar_load
	var/grind_time
	var/grind_time_per_load
	var/juice_time
	var/juice_time_per_load
	var/unload_time_per_load
	var/grind_slow_cap
	var/grind_xp_per_int
	/// The mortar's bonus to the chance of a bonus output, by learned rank of Alchemy (index rank + 1).
	var/list/grind_bonus
	// The smell of a thing.
	var/smell_intense
	var/smell_strong
	var/smell_slight
	var/sniff_intense_keen
	var/sniff_strong_keen
	var/sniff_slight_keen
	// The still.
	var/still_rate

/datum/rogue_brew_numbers/proc/read()
	revision = rogue_mechanics_revision()
	brew_ticks = rogue_value("alch_brew_ticks")
	water = rogue_value("alch_brew_water")
	essence_types = rogue_value("alch_brew_essence_types")
	xp_per_int = rogue_value("alch_brew_xp_per_int")
	bubble_chance = rogue_value("cauldron_bubble_chance")
	mortar_load = rogue_value("alch_brew_mortar_load")
	grind_time = rogue_value("alch_brew_grind_time")
	grind_time_per_load = rogue_value("alch_brew_grind_time_per_load")
	juice_time = rogue_value("alch_brew_juice_time")
	juice_time_per_load = rogue_value("alch_brew_juice_time_per_load")
	unload_time_per_load = rogue_value("alch_brew_unload_time_per_load")
	grind_slow_cap = rogue_value("alch_brew_grind_slow_cap")
	grind_xp_per_int = rogue_value("alch_brew_grind_xp_per_int")
	var/journeyman = rogue_value("alch_brew_grind_bonus_journeyman")
	grind_bonus = list(1, 1, 1, journeyman, rogue_value("alch_brew_grind_bonus_expert"), rogue_value("alch_brew_grind_bonus_master"), rogue_value("alch_brew_grind_bonus_legendary"))
	smell_intense = rogue_value("alch_brew_smell_intense")
	smell_strong = rogue_value("alch_brew_smell_strong")
	smell_slight = rogue_value("alch_brew_smell_slight")
	sniff_intense_keen = rogue_value("sniff_major_keen")
	sniff_strong_keen = rogue_value("sniff_med_keen")
	sniff_slight_keen = rogue_value("sniff_minor_keen")
	still_rate = rogue_value("alch_brew_still_rate")

/// A cauldron recipe (Vibelin /datum/alch_cauldron_recipe): the essences one batch takes, list(essence = units), and what a
/// batch makes; the Alchemy it takes is Ratwood's (the generator writes the rank of Ratwood's recipe of the same reagent).
/datum/alch_cauldron_recipe
	abstract_type = /datum/alch_cauldron_recipe
	var/category = "Potions"
	var/recipe_name = ""
	/// What the cauldron smells of when the brew is done.
	var/smells_like = "nothing"
	/// Least learned rank of Alchemy that brews it (Ratwood Apprentice); below it the brew turns to slurry.
	var/skill_required = ROGUE_RANK_APPRENTICE
	/// Reagents a batch leaves in the cauldron, list(path = units); items a batch leaves beside it, list(path = count).
	var/list/output_reagents = list()
	var/list/output_items
	var/list/required_essences = list()

/// Whether the essences, list(essence = units), are this recipe's and enough for a batch: nothing missing, nothing else.
/datum/alch_cauldron_recipe/proc/matches_essences(list/available)
	if(!length(required_essences))
		return FALSE
	for(var/essence_type in required_essences)
		if((available[essence_type] || 0) < required_essences[essence_type])
			return FALSE
	for(var/essence_type in available)
		if(!(essence_type in required_essences))
			return FALSE
	return TRUE

/// How many batches the essences give (Vibelin calculate_max_batches()); 0 when they do not match.
/datum/alch_cauldron_recipe/proc/batches_in(list/available)
	if(!matches_essences(available))
		return 0
	var/least = INFINITY
	for(var/essence_type in required_essences)
		var/per_batch = required_essences[essence_type]
		if(per_batch > 0)
			least = min(least, floor(available[essence_type] / per_batch))
	return least == INFINITY ? 0 : least

/// A mortar recipe (Ratwood /datum/alch_grind_recipe): what grinds so and what that gives, always and by chance.
/datum/alch_grind_recipe
	abstract_type = /datum/alch_grind_recipe
	var/name = "generic grind recipe"
	/// Only the very type grinds so; FALSE - its subtypes too.
	var/picky = TRUE
	var/obj/item/valid_input
	/// Items it always gives, list(path = count), and may give, list(path = percent).
	var/list/valid_outputs = list()
	var/list/bonus_chance_outputs = list()

/// The chance of a bonus output.
/datum/alch_grind_recipe/proc/get_bonus_output_chance(output_path, mob/living/user, base_chance)
	return base_chance

/// Ratwood's natural bone gives bone meal more often to a better alchemist.
/datum/alch_grind_recipe/natural_bone/get_bonus_output_chance(output_path, mob/living/user, base_chance)
	if(output_path != /obj/item/alch/bonemeal || !user)
		return base_chance
	return user.rogue_learned_rank(ROGUE_ALCHEMY_SKILL) <= ROGUE_RANK_APPRENTICE ? rogue_value("grind_bonemeal_chance_low") : rogue_value("grind_bonemeal_chance_high")

/// The recipes of each kind, one of each, by type.
GLOBAL_LIST_INIT(alch_cauldron_recipes, rogue_alchemy_recipes(/datum/alch_cauldron_recipe))
GLOBAL_LIST_INIT(alch_grind_recipes, rogue_alchemy_recipes(/datum/alch_grind_recipe))

/proc/rogue_alchemy_recipes(root)
	. = list()
	for(var/recipe_type in valid_subtypesof(root))
		.[recipe_type] = new recipe_type

/// The mortar recipe that grinds the item (Ratwood find_recipe()), or null.
/proc/rogue_grind_recipe(obj/item/ground)
	for(var/recipe_type in GLOB.alch_grind_recipes)
		var/datum/alch_grind_recipe/recipe = GLOB.alch_grind_recipes[recipe_type]
		if(recipe.picky ? ground.type == recipe.valid_input : istype(ground, recipe.valid_input))
			return recipe

// The smell of a thing (Vibelin /obj/item/examine()): what the essence splitter would make of it, each essence by how much of
// it there is - the more, the easier to smell (Ratwood's steps: Novice, Apprentice, then Journeyman and Expert of Alchemy, or
// a keen nose and mind for the first three). A legendary herb finder knows the essences by name and amount.

/obj/item/examine(mob/user)
	. = ..()
	if(!isliving(user) || !user.mind || !rogue_survival_enabled())
		return
	var/datum/natural_precursor/precursor = get_precursor_data(src)
	if(precursor)
		. += rogue_essence_smell(precursor, user)

/proc/rogue_essence_smell(datum/natural_precursor/precursor, mob/living/sniffer)
	. = list()
	var/datum/rogue_brew_numbers/numbers = rogue_brew_numbers()
	var/rank = sniffer.rogue_learned_rank(ROGUE_ALCHEMY_SKILL)
	var/keen = floor((sniffer.rogue_stat(ROGUE_STAT_PERCEPTION) + sniffer.rogue_stat(ROGUE_STAT_INTELLIGENCE)) / 2)
	var/knows = HAS_TRAIT(sniffer, TRAIT_LEGENDARY_ALCHEMIST)
	for(var/essence_type in precursor.essence_yields)
		var/datum/thaumaturgical_essence/essence = essence_type
		var/amount = precursor.essence_yields[essence_type]
		if(amount <= 0)
			continue
		if(knows)
			. += span_notice("Yields [amount] [initial(essence.name)] when split.")
			continue
		var/strength = "faintly"
		var/smelt = rank >= ROGUE_RANK_EXPERT
		if(amount >= numbers.smell_intense)
			strength = "intensely"
			smelt = rank >= ROGUE_RANK_NOVICE || keen >= numbers.sniff_intense_keen
		else if(amount >= numbers.smell_strong)
			strength = "strongly"
			smelt = rank >= ROGUE_RANK_APPRENTICE || keen >= numbers.sniff_strong_keen
		else if(amount >= numbers.smell_slight)
			strength = "slightly"
			smelt = rank >= ROGUE_RANK_JOURNEYMAN || keen >= numbers.sniff_slight_keen
		if(smelt)
			. += span_notice("Smells [strength] of [initial(essence.smells_like)].")

// The cauldron (Ratwood's /obj/machinery/light/rogue/cauldron with Vibelin's /obj/machinery/light/fueled/cauldron): a fire under
// a pot of rogue_volume units (rockhill/fires.dm). The alchemist chooses a recipe (a click with an empty hand), pours its
// essences in with vials or links the cauldron's node to the essence network (alchemy/essence/cauldron_node.dm), which then
// feeds it what the recipe still lacks. While it burns and holds the water a brew needs, the essences boil for alch_brew_ticks;
// then they become as many batches of the recipe as they give (with no recipe chosen, of the first recipe they match), the
// water is spent and the potion is left in the cauldron, to be drawn out with a vessel. Below the recipe's Alchemy the brew is
// slurry. Auto-repeat (alt-click) brews again as soon as the essences are in; without it the cauldron waits for a hand.

/obj/machinery/light/rogue/cauldron
	/// The essences in it, list(essence type = units) (Vibelin), no more than alch_brew_essence_types kinds.
	var/list/essence_contents = list()
	/// The recipe chosen (one of GLOB.alch_cauldron_recipes), what the node asks the network for.
	var/datum/alch_cauldron_recipe/selected_recipe
	var/auto_repeat = FALSE
	var/rogue_volume = 500
	/// Ticks of ROGUE_REAGENT_TICK seconds the brew has boiled.
	var/rogue_brewing = 0
	/// A brew is done and, without auto-repeat, the cauldron waits for a hand before it boils again (Vibelin brewing = 21).
	var/rogue_brew_done = FALSE
	/// Who chose the recipe or poured the last essence: the brew answers to their Alchemy and teaches them (Ratwood lastuser).
	var/datum/weakref/rogue_brewer

/obj/machinery/light/rogue/cauldron/Initialize(mapload)
	create_reagents(rogue_volume, DRAINABLE | AMOUNT_VISIBLE | REFILLABLE)
	RegisterSignal(reagents, COMSIG_REAGENTS_HOLDER_UPDATED, PROC_REF(on_reagents_changed))
	return ..()

/obj/machinery/light/rogue/cauldron/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(reagents?.total_volume)
		chem_splash(get_turf(src), null, 2, list(reagents))
	selected_recipe = null
	rogue_brewer = null
	essence_contents = list()
	return ..()

/obj/machinery/light/rogue/cauldron/ignite(silent = FALSE)
	. = ..()
	if(.)
		rogue_wake()

/// Ratwood's burn_out(): the brew stops and starts over when lit again.
/obj/machinery/light/rogue/cauldron/burn_out(silent = FALSE)
	. = ..()
	if(.)
		rogue_brewing = 0
		update_appearance(UPDATE_OVERLAYS)

/// The essences in the cauldron changed by a hand or a brew: the network forgets what it cached of the node's demand (built
/// from essence_contents), so it feeds the cauldron again (review of block VA1).
/obj/machinery/light/rogue/cauldron/proc/rogue_essences_changed()
	if(!QDELETED(essence_node))
		essence_node.network?.invalidate_cache()

/// Puts the cauldron to work if it has something to work on.
/obj/machinery/light/rogue/cauldron/proc/rogue_wake()
	if(lit && (selected_recipe || length(essence_contents)))
		START_PROCESSING(SSobj, src)

/obj/machinery/light/rogue/cauldron/process(seconds_per_tick)
	if(!lit || (!selected_recipe && !length(essence_contents)))
		return PROCESS_KILL
	var/datum/rogue_brew_numbers/numbers = rogue_brew_numbers()
	rogue_drain_from_node(numbers)
	if(rogue_brew_done && !auto_repeat)
		return
	if(!length(essence_contents))
		return
	if(selected_recipe && !rogue_has_required_essences())
		return
	if(!reagents.has_reagent(/datum/reagent/water, numbers.water))
		return
	var/was_boiling = rogue_brewing > 0
	rogue_brewing += seconds_per_tick / ROGUE_REAGENT_TICK
	if(!was_boiling)
		update_appearance(UPDATE_OVERLAYS)
	if(prob(numbers.bubble_chance * seconds_per_tick / ROGUE_REAGENT_TICK))
		playsound(src, ALCH_BREW_BUBBLE_SOUND, 100, FALSE)
	if(rogue_brewing >= numbers.brew_ticks)
		rogue_finish_brew()

/// Whether the chosen recipe has the essences of one batch in the cauldron (Vibelin has_required_essences()).
/obj/machinery/light/rogue/cauldron/proc/rogue_has_required_essences()
	if(!selected_recipe)
		return FALSE
	for(var/essence_type in selected_recipe.required_essences)
		if((essence_contents[essence_type] || 0) < selected_recipe.required_essences[essence_type])
			return FALSE
	return TRUE

/// How many batches of a recipe the cauldron could take in at most, by what its node holds (Vibelin
/// calculate_max_possible_batches()): each essence of the recipe gets an equal share of the node's room. Read by the node.
/obj/machinery/light/rogue/cauldron/proc/calculate_max_possible_batches(datum/alch_cauldron_recipe/recipe)
	if(!recipe || !length(recipe.required_essences))
		return 0
	var/type_cap = rogue_essence_numbers().cauldron_node_capacity / length(recipe.required_essences)
	var/least = INFINITY
	for(var/essence_type in recipe.required_essences)
		var/per_batch = recipe.required_essences[essence_type]
		if(per_batch > 0)
			least = min(least, floor(type_cap / per_batch))
	return least == INFINITY ? 0 : max(least, 1)

/// Takes in what reached the node (Vibelin drain_from_node()): with a recipe, only its essences and no more than its batches
/// need; without one, everything there is room for. What is left in the node is pushed back out to the network.
/obj/machinery/light/rogue/cauldron/proc/rogue_drain_from_node(datum/rogue_brew_numbers/numbers)
	var/obj/machinery/essence/cauldron_node/node = essence_node
	if(QDELETED(node))
		return
	var/datum/essence_storage/store = node.storage
	if(!length(store?.contents))
		return
	var/max_batches = selected_recipe ? calculate_max_possible_batches(selected_recipe) : 0
	var/changed = FALSE
	for(var/essence_type in store.contents.Copy())
		if(selected_recipe && !(essence_type in selected_recipe.required_essences))
			continue
		if(!essence_contents[essence_type] && length(essence_contents) >= numbers.essence_types)
			continue
		var/to_drain = store.get(essence_type)
		if(max_batches > 0)
			to_drain = min(to_drain, max(0, selected_recipe.required_essences[essence_type] * max_batches - (essence_contents[essence_type] || 0)))
		if(to_drain <= 0)
			continue
		var/drained = store.remove(essence_type, to_drain)
		if(drained > 0)
			essence_contents[essence_type] += drained
			changed = TRUE
	if(length(store.contents))
		node.push_to_linked(store)
	if(changed)
		update_appearance(UPDATE_OVERLAYS)

/// The brew is done: the chosen recipe, or else the first that the essences match, takes them all for as many batches as they
/// give, if there is an alchemist to guide it (Ratwood); below its Alchemy the brew is slurry.
/obj/machinery/light/rogue/cauldron/proc/rogue_finish_brew()
	rogue_brewing = 0
	var/datum/alch_cauldron_recipe/recipe
	var/batches = 0
	if(selected_recipe)
		batches = selected_recipe.batches_in(essence_contents)
		if(batches)
			recipe = selected_recipe
	if(!recipe)
		for(var/recipe_type in GLOB.alch_cauldron_recipes)
			var/datum/alch_cauldron_recipe/candidate = GLOB.alch_cauldron_recipes[recipe_type]
			batches = candidate.batches_in(essence_contents)
			if(batches)
				recipe = candidate
				break
	if(!recipe)
		essence_contents = list()
		rogue_essences_changed()
		visible_message(span_info("The essences in [src] fail to combine properly..."))
		playsound(src, ALCH_BREW_DONE_SOUND, 30, FALSE)
		update_appearance(UPDATE_OVERLAYS)
		return
	var/mob/living/brewer = rogue_brewer?.resolve()
	if(!brewer)
		rogue_brew_done = TRUE
		auto_repeat = FALSE
		visible_message(span_info("[src] can't brew anything without an alchemist to guide it."))
		update_appearance(UPDATE_OVERLAYS)
		return
	var/datum/rogue_brew_numbers/numbers = rogue_brew_numbers()
	essence_contents = list()
	rogue_essences_changed()
	rogue_brew_done = !auto_repeat
	var/water = reagents.get_reagent_amount(/datum/reagent/water)
	reagents.remove_reagent(/datum/reagent/water, water)
	var/experience = brewer.rogue_stat(ROGUE_STAT_INTELLIGENCE) * numbers.xp_per_int * batches
	if(recipe.skill_required > brewer.rogue_learned_rank(ROGUE_ALCHEMY_SKILL))
		visible_message(span_warning("The essences in [src] meld together into a disgusting mess! Perhaps a more skilled alchemist is needed for this recipe."))
		reagents.add_reagent(/datum/reagent/yuck, water)
		brewer.rogue_adjust_experience(ROGUE_ALCHEMY_SKILL, experience)
		playsound(src, ALCH_BREW_DONE_SOUND, 30, FALSE)
		update_appearance(UPDATE_OVERLAYS)
		return
	if(length(recipe.output_reagents))
		var/list/made = list()
		for(var/reagent_type in recipe.output_reagents)
			made[reagent_type] = recipe.output_reagents[reagent_type] * batches
		reagents.add_reagent_list(made)
	var/turf/here = get_turf(src)
	for(var/item_type in recipe.output_items)
		var/count = recipe.output_items[item_type]
		for(var/i in 1 to (isnum(count) ? count : 1) * batches)
			new item_type(here)
	if(batches > 1)
		visible_message(span_info("[src] finishes boiling [batches] batches with a strong [recipe.smells_like] smell."))
	else
		visible_message(span_info("[src] finishes boiling with a faint [recipe.smells_like] smell."))
	brewer.log_message("brewed [batches] batches of [recipe.type] in [src] (REAGENTS: [english_list(recipe.output_reagents, "none")]) (ITEMS: [english_list(recipe.output_items, "none")])", LOG_GAME)
	brewer.rogue_adjust_experience(ROGUE_ALCHEMY_SKILL, experience)
	playsound(src, ALCH_BREW_BUBBLE_SOUND, 100, TRUE)
	playsound(src, ALCH_BREW_DONE_SOUND, 30, FALSE)
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/light/rogue/cauldron/update_overlays()
	. = ..()
	if(!reagents?.total_volume)
		return
	var/mutable_appearance/filling = mutable_appearance(icon, rogue_brewing > 0 ? "cauldron_boiling" : "cauldron_full")
	filling.color = length(essence_contents) ? rogue_essence_mix_color(essence_contents) : mix_color_from_reagents(reagents.reagent_list)
	. += filling

/obj/machinery/light/rogue/cauldron/proc/on_reagents_changed(datum/reagents/holder)
	SIGNAL_HANDLER
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/light/rogue/cauldron/examine(mob/user)
	. = ..()
	if(selected_recipe)
		. += span_info("Recipe selected: [selected_recipe.recipe_name].")
		. += span_info((auto_repeat ? "Auto-repeat is on: it brews again as soon as the essences are in." : "Auto-repeat is off. Alt-click it to turn it on."))
		. += span_notice("Required essences:")
		for(var/essence_type in selected_recipe.required_essences)
			. += span_notice(" - [rogue_essence_label(essence_type, user)]: [essence_contents[essence_type] || 0]/[selected_recipe.required_essences[essence_type]]")
	else
		. += span_notice("No recipe selected. Click it with an empty hand to choose one.")
	for(var/essence_type in essence_contents)
		if(!selected_recipe || !(essence_type in selected_recipe.required_essences))
			. += span_notice("It holds [essence_contents[essence_type]] of [rogue_essence_label(essence_type, user, "an essence smelling of")].")
	if(!QDELETED(essence_node) && length(essence_node.links))
		. += span_notice("Essence links: [length(essence_node.links)] connected.")
	. += span_notice("Pour essences in with a vial; right-click it with a vial to draw one out, with a pestran connector to see its links.")

/// Vibelin's recipe menu: a click with an empty hand chooses the recipe, among those the alchemist's rank brews.
/obj/machinery/light/rogue/cauldron/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	INVOKE_ASYNC(src, PROC_REF(rogue_recipe_menu), user)
	return TRUE

/obj/machinery/light/rogue/cauldron/proc/rogue_recipe_menu(mob/living/user)
	var/rank = user.rogue_learned_rank(ROGUE_ALCHEMY_SKILL)
	var/list/recipes = list()
	for(var/recipe_type in GLOB.alch_cauldron_recipes)
		var/datum/alch_cauldron_recipe/recipe = GLOB.alch_cauldron_recipes[recipe_type]
		if(recipe.skill_required > rank)
			continue
		var/label = recipe.recipe_name || "[recipe_type]"
		if(recipes[label])
			label = "[label] ([recipe.category])"
		recipes[label] = recipe
	var/list/labels = list()
	for(var/label in recipes)
		labels += label
	labels = list(ALCH_BREW_CLEAR) + sort_list(labels)
	var/choice = tgui_input_list(user, "Select a recipe for the cauldron", "Cauldron Recipe", labels, selected_recipe?.recipe_name)
	if(!choice || QDELETED(src) || !user.can_perform_action(src))
		return
	if(choice == ALCH_BREW_CLEAR)
		selected_recipe = null
		auto_repeat = FALSE
		rogue_recipe_changed()
		to_chat(user, span_info("Recipe cleared."))
		return
	var/datum/alch_cauldron_recipe/chosen = recipes[choice]
	if(!chosen)
		return
	selected_recipe = chosen
	rogue_brewer = WEAKREF(user)
	rogue_recipe_changed()
	to_chat(user, span_info("Recipe set to: [chosen.recipe_name]."))
	to_chat(user, span_notice("Alt-click the cauldron to turn auto-repeat on."))
	rogue_wake()

/// A new recipe (Vibelin on_recipe_changed()): the brew starts over; essences it has no use for go back to the node, which
/// pushes them out to the network, when the cauldron is linked to one.
/obj/machinery/light/rogue/cauldron/proc/rogue_recipe_changed()
	rogue_brewing = 0
	rogue_brew_done = FALSE
	var/obj/machinery/essence/cauldron_node/node = essence_node
	if(!QDELETED(node) && length(node.links))
		for(var/essence_type in essence_contents.Copy())
			if(selected_recipe && (essence_type in selected_recipe.required_essences))
				continue
			var/moved = node.storage.add(essence_type, essence_contents[essence_type])
			essence_contents[essence_type] -= moved
			if(essence_contents[essence_type] <= 0)
				essence_contents -= essence_type
		node.network?.invalidate_cache()
		node.push_surplus_to_linked(node.storage)
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/light/rogue/cauldron/click_alt(mob/user)
	if(!selected_recipe)
		to_chat(user, span_warning("I must select a recipe first."))
		return CLICK_ACTION_BLOCKING
	auto_repeat = !auto_repeat
	if(auto_repeat)
		rogue_brew_done = FALSE
		rogue_wake()
		to_chat(user, span_info("Auto-repeat on: [src] will brew [selected_recipe.recipe_name] whenever the essences are in."))
	else
		to_chat(user, span_info("Auto-repeat off."))
	return CLICK_ACTION_SUCCESS

/// A vial pours its essence in (Vibelin); the connector links the cauldron's node (alchemy/essence/tools.dm), so it is let be.
/obj/machinery/light/rogue/cauldron/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/essence_connector))
		return NONE
	if(!istype(tool, /obj/item/essence_vial) || user.combat_mode)
		return ..()
	var/obj/item/essence_vial/vial = tool
	if(!vial.contained_essence || vial.essence_amount <= 0)
		to_chat(user, span_warning("The vial is empty."))
		return ITEM_INTERACT_BLOCKING
	var/essence_type = vial.contained_essence
	if(!essence_contents[essence_type] && length(essence_contents) >= rogue_brew_numbers().essence_types)
		to_chat(user, span_warning("[src] cannot hold any more kinds of essence."))
		return ITEM_INTERACT_BLOCKING
	essence_contents[essence_type] += vial.essence_amount
	to_chat(user, span_info("I pour the [rogue_essence_label(essence_type, user)] into [src]."))
	vial.take_essence(vial.essence_amount)
	rogue_essences_changed()
	rogue_brewing = 0
	rogue_brew_done = FALSE
	rogue_brewer = WEAKREF(user)
	playsound(src, ALCH_BREW_BUBBLE_SOUND, 100, TRUE)
	update_appearance(UPDATE_OVERLAYS)
	rogue_wake()
	return ITEM_INTERACT_SUCCESS

/// A right click with the connector shows the node's links (Vibelin); with a vial, draws an essence out into it.
/obj/machinery/light/rogue/cauldron/item_interaction_secondary(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/essence_connector))
		var/obj/machinery/essence/cauldron_node/node = rogue_essence_node()
		if(!node)
			return ITEM_INTERACT_BLOCKING
		INVOKE_ASYNC(node, TYPE_PROC_REF(/obj/machinery/essence, show_link_menu), user)
		return ITEM_INTERACT_SUCCESS
	if(istype(tool, /obj/item/essence_vial) && !user.combat_mode)
		INVOKE_ASYNC(src, PROC_REF(rogue_draw_essence), user, tool)
		return ITEM_INTERACT_SUCCESS
	return ..()

/obj/machinery/light/rogue/cauldron/proc/rogue_draw_essence(mob/living/user, obj/item/essence_vial/vial)
	if(!length(essence_contents))
		to_chat(user, span_warning("There is no essence in [src]."))
		return
	var/list/choices = list()
	for(var/essence_type in essence_contents)
		if(vial.contained_essence && vial.essence_amount > 0 && vial.contained_essence != essence_type)
			continue
		choices["[rogue_essence_label(essence_type, user)] ([essence_contents[essence_type]])"] = essence_type
	if(!length(choices))
		to_chat(user, span_warning("The vial already holds another essence."))
		return
	var/choice = tgui_input_list(user, "Draw which essence?", "Cauldron", choices)
	if(!choice || QDELETED(src) || QDELETED(vial) || !user.is_holding(vial) || !user.can_perform_action(src))
		return
	var/essence_type = choices[choice]
	var/drawn = vial.fill_essence(essence_type, essence_contents[essence_type] || 0)
	if(drawn <= 0)
		to_chat(user, span_warning("The vial is full."))
		return
	essence_contents[essence_type] -= drawn
	if(essence_contents[essence_type] <= 0)
		essence_contents -= essence_type
	rogue_essences_changed()
	rogue_brewing = 0
	to_chat(user, span_info("I draw [drawn] of the [rogue_essence_label(essence_type, user)] from [src]."))
	update_appearance(UPDATE_OVERLAYS)

/// Ratwood's onkick(): a kick spills the cauldron, its essences with it.
/obj/machinery/light/rogue/cauldron/rogue_onkick(mob/living/carbon/human/kicker)
	if(reagents?.total_volume || length(essence_contents))
		if(reagents?.total_volume)
			chem_splash(get_turf(src), null, 2, list(reagents))
		essence_contents = list()
		rogue_essences_changed()
		kicker.visible_message(span_info("[kicker] kicks [src], spilling its contents!"))
	playsound(src, 'modular_redtard/rockhill/sound/items/beartrap2.ogg', 100, FALSE)
	rogue_brewing = 0
	update_appearance(UPDATE_OVERLAYS)

// The mortar (Ratwood /obj/item/reagent_containers/glass/mortar, Vibelin's batches): things put in, up to alch_brew_mortar_load
// of weight, are ground together with a pestle into ingredients by their mortar recipes, or into reagents (a right click with
// the pestle: each juiced if it juices, else ground). The time grows with the weight and falls with Alchemy; a better
// alchemist gets the bonus outputs more often. Vessels still pour in and out.

/// Ratwood's stone pestle (mortarpestle.dm): TG's pestle with Ratwood's look, so it grinds in this mortar and in TG's as TG's
/// pestle does, while modern maps keep TG's. The porter hands out Ratwood's pestles as this one.
/obj/item/pestle/rogue
	desc = "A small, round-end stone tool oft used by physicians to crush and mix medicine."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/alchemy.dmi'
	icon_state = "pestle"
	custom_materials = null
	rogue_grid_width = 64
	rogue_grid_height = 32

/obj/item/reagent_containers/glass/mortar
	/// What lies in it to be ground (Vibelin's mortar storage, Ratwood to_grind).
	var/list/rogue_grind_batch

/obj/item/reagent_containers/glass/mortar/Exited(atom/movable/gone, direction)
	. = ..()
	LAZYREMOVE(rogue_grind_batch, gone)

/// The weight of what is in it (Vibelin grind_load()).
/obj/item/reagent_containers/glass/mortar/proc/rogue_grind_load()
	. = 0
	for(var/obj/item/ground as anything in rogue_grind_batch)
		. += ground.w_class

/// How much slower than the median an alchemist grinds (Vibelin GENERAL_SKILL_TIME_MULITPLIER, at most alch_brew_grind_slow_cap).
/obj/item/reagent_containers/glass/mortar/proc/rogue_grind_slowness(mob/living/user, datum/rogue_brew_numbers/numbers)
	return min(numbers.grind_slow_cap, ROGUE_ATTRIBUTE_MIDDLING / max(user.rogue_skill(ROGUE_ALCHEMY_SKILL), 1))

/obj/item/reagent_containers/glass/mortar/examine(mob/user)
	. = ..()
	if(length(rogue_grind_batch))
		. += span_info("It contains:")
		for(var/obj/item/ground as anything in rogue_grind_batch)
			. += span_info("[ground.name]")
	. += span_notice("Click it with a pestle to grind what is inside into alchemical ingredients; right-click it with a pestle to grind or juice it. Right-click it with an empty hand to take everything out.")

/obj/item/reagent_containers/glass/mortar/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/pestle))
		INVOKE_ASYNC(src, PROC_REF(rogue_grind), user)
		return ITEM_INTERACT_SUCCESS
	var/datum/alch_grind_recipe/recipe = rogue_grind_recipe(tool)
	if(!recipe && istype(tool, /obj/item/reagent_containers/glass))
		return ..()
	if(!recipe && !length(tool.grind_results()) && !tool.juice_typepath() && !tool.reagents?.total_volume)
		to_chat(user, span_warning("[tool] can't be ground!"))
		return ITEM_INTERACT_BLOCKING
	if(rogue_grind_load() + tool.w_class > rogue_brew_numbers().mortar_load)
		to_chat(user, span_warning("[src] is full!"))
		return ITEM_INTERACT_BLOCKING
	if(!tool.blend_requirements(src, user) || !user.transferItemToLoc(tool, src))
		return ITEM_INTERACT_BLOCKING
	LAZYADD(rogue_grind_batch, tool)
	to_chat(user, span_info("I add [tool] to [src]."))
	return ITEM_INTERACT_SUCCESS

/// Ratwood's MiddleClick() with a pestle, on the whole batch (Vibelin): each thing is juiced, or else ground, into the mortar.
/obj/item/reagent_containers/glass/mortar/item_interaction_secondary(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/pestle))
		return ..()
	if(!length(rogue_grind_batch))
		to_chat(user, span_warning("There's nothing to grind."))
		return ITEM_INTERACT_BLOCKING
	INVOKE_ASYNC(src, PROC_REF(rogue_juice_batch), user)
	return ITEM_INTERACT_SUCCESS

/obj/item/reagent_containers/glass/mortar/proc/rogue_juice_batch(mob/living/user)
	var/datum/rogue_brew_numbers/numbers = rogue_brew_numbers()
	playsound(src, ALCH_BREW_GRIND_SOUND, 100, FALSE)
	if(!do_after(user, (numbers.juice_time + rogue_grind_load() * numbers.juice_time_per_load) * rogue_grind_slowness(user, numbers), target = src))
		return
	var/done = FALSE
	for(var/obj/item/ground as anything in rogue_grind_batch?.Copy())
		if(QDELETED(ground) || ground.loc != src)
			continue
		if(ground.juice(reagents, user) || ground.grind(reagents, user))
			done = TRUE
	if(done)
		to_chat(user, span_notice("I break it all into a fine mash."))
	else
		to_chat(user, span_warning("I don't think that will work!"))

/// Vibelin's right click with an empty hand: everything comes out, which takes longer the more there is.
/obj/item/reagent_containers/glass/mortar/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || !length(rogue_grind_batch))
		return
	INVOKE_ASYNC(src, PROC_REF(rogue_empty_batch), user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/reagent_containers/glass/mortar/proc/rogue_empty_batch(mob/living/user)
	if(length(rogue_grind_batch) == 1)
		var/obj/item/single = rogue_grind_batch[1]
		single.forceMove(drop_location())
		if(user.put_in_hands(single))
			to_chat(user, span_notice("I remove [single] from the mortar."))
		else
			to_chat(user, span_warning("My hands are full! I drop [single] on the ground."))
		return
	balloon_alert(user, "removing items...")
	if(!do_after(user, rogue_grind_load() * rogue_brew_numbers().unload_time_per_load, target = src))
		return
	var/turf/spot = get_turf(user)
	for(var/obj/item/ground as anything in rogue_grind_batch?.Copy())
		ground.forceMove(spot)
	balloon_alert(user, "items removed")

/obj/item/reagent_containers/glass/mortar/blended(obj/item/blended_item, grinded)
	LAZYREMOVE(rogue_grind_batch, blended_item)
	return ..()

/// Ratwood's attackby() with a pestle, on the whole batch (Vibelin): every thing in it must have a mortar recipe; each gives its
/// ingredients (ores and bars spark). Tree sap seeds over blessed water give a druid Dendor's blessed seed powder.
/obj/item/reagent_containers/glass/mortar/proc/rogue_grind(mob/living/user)
	if(!length(rogue_grind_batch))
		to_chat(user, span_warning("There's nothing to grind."))
		return
	var/list/seeds = list()
	for(var/obj/item/seeds/treesap/seed in rogue_grind_batch)
		seeds += seed
	if(length(seeds) && reagents.get_reagent_amount(/datum/reagent/water/blessed) >= rogue_value("seed_blessing_water"))
		rogue_bless_seeds(user, seeds)
		return
	var/list/recipes = list()
	for(var/obj/item/ground as anything in rogue_grind_batch)
		var/datum/alch_grind_recipe/recipe = rogue_grind_recipe(ground)
		if(!recipe)
			to_chat(user, span_warning("I don't think [ground] will grind into anything!"))
			return
		recipes[ground] = recipe
	var/datum/rogue_brew_numbers/numbers = rogue_brew_numbers()
	user.visible_message(span_info("[user] begins grinding up the contents of [src]."))
	playsound(src, ALCH_BREW_GRIND_SOUND, 100, FALSE)
	if(!do_after(user, (numbers.grind_time + rogue_grind_load() * numbers.grind_time_per_load) * rogue_grind_slowness(user, numbers), target = src))
		return
	var/bonus_modifier = numbers.grind_bonus[clamp(user.rogue_learned_rank(ROGUE_ALCHEMY_SKILL), ROGUE_RANK_NONE, ROGUE_RANK_LEGENDARY) + 1]
	var/turf/here = get_turf(src)
	var/sparks = FALSE
	var/ground_any = FALSE
	for(var/obj/item/ground as anything in recipes)
		if(QDELETED(ground) || ground.loc != src)
			continue
		var/datum/alch_grind_recipe/recipe = recipes[ground]
		user.log_message("ground [ground] into [english_list(recipe.valid_outputs, "nothing")] with [src]", LOG_GAME)
		for(var/output in recipe.valid_outputs)
			for(var/i in 1 to recipe.valid_outputs[output])
				new output(here)
		for(var/bonus in recipe.bonus_chance_outputs)
			if(prob(recipe.get_bonus_output_chance(bonus, user, recipe.bonus_chance_outputs[bonus]) * bonus_modifier))
				new bonus(here)
		if(istype(ground, /obj/item/rogueore) || istype(ground, /obj/item/ingot))
			sparks = TRUE
		qdel(ground)
		ground_any = TRUE
	if(!ground_any)
		return
	if(sparks)
		do_sparks(1, TRUE, here)
	user.rogue_adjust_experience(ROGUE_ALCHEMY_SKILL, user.rogue_stat(ROGUE_STAT_INTELLIGENCE) * numbers.grind_xp_per_int)

/obj/item/reagent_containers/glass/mortar/proc/rogue_bless_seeds(mob/living/user, list/seeds)
	if(user.rogue_learned_rank(/datum/attribute/skill/magic/druidic) < ROGUE_RANK_NOVICE)
		to_chat(user, span_warning("I lack the druidic knowledge to draw Dendor's blessing from these seeds."))
		return
	user.visible_message(span_info("[user] grinds the seeds into the blessed water, drawing out Dendor's blessing."))
	playsound(src, ALCH_BREW_GRIND_SOUND, 100, FALSE)
	if(!do_after(user, rogue_brew_numbers().grind_time, target = src))
		return
	var/water_each = rogue_value("seed_blessing_water")
	var/blessed = 0
	for(var/obj/item/seeds/treesap/seed as anything in seeds)
		if(reagents.get_reagent_amount(/datum/reagent/water/blessed) < water_each)
			break
		if(QDELETED(seed) || seed.loc != src)
			continue
		reagents.remove_reagent(/datum/reagent/water/blessed, water_each)
		new /obj/item/alch/blessedseedpowder(get_turf(src))
		qdel(seed)
		blessed++
	if(!blessed)
		return
	to_chat(user, span_notice("The seeds absorb Dendor's blessing, forming luminous powder."))
	user.rogue_craft_experience(/datum/attribute/skill/magic/druidic, rogue_value("seed_blessing_xp") * blessed)

#undef ALCH_BREW_BUBBLE_SOUND
#undef ALCH_BREW_DONE_SOUND
#undef ALCH_BREW_GRIND_SOUND
#undef ALCH_BREW_CLEAR
