// Vibelin's essence combiner (essence_machines/essence_combiner.dm): fuses essences into compounds by the mixes of
// /datum/essence_combination (alchemy/vibelin/essence_combinations.dm). Three modes: generic (any mix that fits, by hand),
// manual (one locked mix, runs by itself) and automatic (the mix the network wants most, runs by itself). Run by hand,
// a mix needs its skill_required in Alchemy and teaches; run by itself, it needs none (Vibelin).

/obj/machinery/essence/combiner
	name = "essence combiner"
	desc = "Fuses multiple alchemical essences into a unified compound."
	icon_state = "splitter"
	network_priority = 4
	processing_flags = START_PROCESSING_ON_INIT
	/// The product, kept apart from the raw essences.
	var/datum/essence_storage/output_storage
	var/combining = FALSE
	var/mode = ROGUE_COMBINER_GENERIC
	/// The locked mix of the manual mode (a type).
	var/manual_recipe_path

/obj/machinery/essence/combiner/storage_capacity()
	return rogue_essence_numbers().combiner_capacity

/obj/machinery/essence/combiner/storage_types()
	return rogue_essence_numbers().combiner_types

/obj/machinery/essence/combiner/Initialize(mapload)
	. = ..()
	var/datum/rogue_essence_numbers/numbers = rogue_essence_numbers()
	output_storage = new(src, numbers.combiner_output_capacity, numbers.combiner_output_types)

/obj/machinery/essence/combiner/Destroy()
	QDEL_NULL(output_storage)
	return ..()

/obj/machinery/essence/combiner/process(seconds_per_tick)
	pull_from_linked(storage)
	push_to_linked(output_storage)

/// The raw store pushes only what no mix can use; the product store pushes everything (Vibelin).
/obj/machinery/essence/combiner/push_to_linked(datum/essence_storage/from_storage)
	if(from_storage == storage)
		push_surplus_to_linked(from_storage)
		return
	return ..()

/obj/machinery/essence/combiner/build_allowed_types()
	var/room = storage.space()
	if(room <= 0)
		return list()
	var/list/combinations = rogue_essence_combinations()
	var/list/result = list()
	switch(mode)
		if(ROGUE_COMBINER_MANUAL)
			var/datum/essence_combination/recipe = combinations[manual_recipe_path]
			if(!recipe)
				return list()
			for(var/essence_type in recipe.inputs)
				result[essence_type] = room
		if(ROGUE_COMBINER_AUTO)
			var/datum/essence_combination/best = most_wanted_combination()
			if(!best)
				return list()
			// One batch of the mix the network wants most, less what is already in.
			for(var/essence_type in best.inputs)
				var/need = best.inputs[essence_type] - storage.get(essence_type)
				if(need > 0)
					result[essence_type] = need
		else
			for(var/combination_type in combinations)
				var/datum/essence_combination/recipe = combinations[combination_type]
				for(var/essence_type in recipe.inputs)
					result[essence_type] = room
	return result

/// The mix whose product the rest of the network wants most, among those that fit available (any when null).
/obj/machinery/essence/combiner/proc/most_wanted_combination(list/available)
	var/list/demand = network ? network.get_demand(list(/obj/machinery/essence/reservoir, type)) : list()
	var/list/combinations = rogue_essence_combinations()
	var/datum/essence_combination/best
	var/best_score = 0
	for(var/combination_type in combinations)
		var/datum/essence_combination/recipe = combinations[combination_type]
		if(available && !recipe.fits(available))
			continue
		var/score = demand[recipe.output_type] || 0
		if(score > best_score)
			best = recipe
			best_score = score
	return best

/// The next mix to run on available (Vibelin find_matching_combination()).
/obj/machinery/essence/combiner/proc/find_matching_combination(list/available)
	var/list/combinations = rogue_essence_combinations()
	switch(mode)
		if(ROGUE_COMBINER_MANUAL)
			var/datum/essence_combination/recipe = combinations[manual_recipe_path]
			return recipe?.fits(available) ? recipe : null
		if(ROGUE_COMBINER_AUTO)
			return most_wanted_combination(available)
	for(var/combination_type in combinations)
		var/datum/essence_combination/recipe = combinations[combination_type]
		if(recipe.fits(available))
			return recipe
	return null

/obj/machinery/essence/combiner/on_storage_changed(essence_type, amount, added)
	. = ..()
	if(added && !combining && mode != ROGUE_COMBINER_GENERIC)
		attempt_combination(null)

/obj/machinery/essence/combiner/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(combining)
		to_chat(user, span_warning("A combination is already in progress."))
		return TRUE
	attempt_combination(user)
	return TRUE

/obj/machinery/essence/combiner/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	INVOKE_ASYNC(src, PROC_REF(show_mode_menu), user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/essence/combiner/proc/show_mode_menu(mob/user)
	var/list/choices = list(
		"Generic (try any recipe)" = ROGUE_COMBINER_GENERIC,
		"Manual (locked recipe)" = ROGUE_COMBINER_MANUAL,
		"Automatic (network demand)" = ROGUE_COMBINER_AUTO,
	)
	var/choice = tgui_input_list(user, "Select combiner mode", "Combiner Mode", choices)
	if(!choice || QDELETED(src) || !IsReachableBy(user))
		return
	var/new_mode = choices[choice]
	if(new_mode == ROGUE_COMBINER_MANUAL)
		var/list/recipe_options = list()
		var/list/combinations = rogue_essence_combinations()
		for(var/combination_type in combinations)
			var/datum/essence_combination/recipe = combinations[combination_type]
			recipe_options[recipe.name] = combination_type
		var/recipe_choice = tgui_input_list(user, "Select a recipe to lock to", "Manual Recipe", recipe_options)
		if(!recipe_choice || QDELETED(src) || !IsReachableBy(user))
			return
		manual_recipe_path = recipe_options[recipe_choice]
		mode = ROGUE_COMBINER_MANUAL
		to_chat(user, span_info("Combiner locked to: [recipe_choice]"))
	else
		manual_recipe_path = null
		mode = new_mode
		if(mode == ROGUE_COMBINER_AUTO)
			to_chat(user, span_info("Combiner set to automatic network demand mode."))
		else
			to_chat(user, span_info("Combiner set to generic mode."))
	network?.invalidate_cache()

/// Queues the mixes the raw store holds and starts them; user is null when it runs by itself (Vibelin attempt_combination()
/// and attempt_combination_auto()).
/obj/machinery/essence/combiner/proc/attempt_combination(mob/living/user)
	if(!length(storage.contents))
		if(user)
			to_chat(user, span_warning("No essences loaded."))
		return
	var/datum/rogue_essence_numbers/numbers = rogue_essence_numbers()
	var/efficiency = rogue_thaumic_research().get_research_bonus(/datum/thaumic_research_node/combiner_output)
	var/batch_limit = (user && mode == ROGUE_COMBINER_AUTO) ? 1 : numbers.combiner_batches
	var/rank = user ? user.rogue_learned_rank(ROGUE_ALCHEMY_SKILL) : ROGUE_RANK_LEGENDARY
	var/list/available = storage.snapshot()
	var/list/queued = list()
	var/total_out = 0
	while(length(queued) < batch_limit)
		var/datum/essence_combination/recipe = find_matching_combination(available)
		if(!recipe || rank < recipe.skill_required)
			break
		for(var/essence_type in recipe.inputs)
			available[essence_type] -= recipe.inputs[essence_type]
			if(available[essence_type] <= 0)
				available -= essence_type
		queued += recipe
		total_out += round(recipe.output_amount * efficiency, 1)
	if(!length(queued))
		if(user)
			to_chat(user, span_warning("No valid combinations can be made with current essences."))
		return
	if(output_storage.space() < total_out)
		if(user)
			to_chat(user, span_warning("Not enough output space for [length(queued)] recipe\s."))
		return
	begin_bulk_combination(user, queued)

/obj/machinery/essence/combiner/proc/begin_bulk_combination(mob/living/user, list/recipes)
	combining = TRUE
	if(user)
		user.visible_message(span_info("[user] activates [src] for bulk processing ([length(recipes)] recipe\s)."))
	else
		visible_message(span_info("[src] begins automated combination ([length(recipes)] recipe\s)."))
	update_appearance(UPDATE_OVERLAYS)
	var/datum/rogue_essence_numbers/numbers = rogue_essence_numbers()
	var/speed = rogue_thaumic_research().get_research_bonus(/datum/thaumic_research_node/combiner_speed)
	var/time = (numbers.combiner_time + length(recipes) * numbers.combiner_time_recipe) / speed
	addtimer(CALLBACK(src, PROC_REF(finish_bulk_combination), user ? WEAKREF(user) : null, recipes), time)

/obj/machinery/essence/combiner/proc/finish_bulk_combination(datum/weakref/user_ref, list/recipes)
	var/efficiency = rogue_thaumic_research().get_research_bonus(/datum/thaumic_research_node/combiner_output)
	var/list/report = list()
	var/made = 0
	for(var/datum/essence_combination/recipe as anything in recipes)
		// The store may have lost essences meanwhile (a vial, a link): a mix that no longer fits is skipped.
		if(!recipe.fits(storage.contents))
			continue
		for(var/essence_type in recipe.inputs)
			storage.remove(essence_type, recipe.inputs[essence_type])
		var/out_amount = round(recipe.output_amount * efficiency, 1)
		out_amount = output_storage.add(recipe.output_type, out_amount)
		var/datum/thaumaturgical_essence/output = recipe.output_type
		report[initial(output.name)] = (report[initial(output.name)] || 0) + out_amount
		made++
	combining = FALSE
	network?.invalidate_cache()
	update_appearance(UPDATE_OVERLAYS)
	if(length(report))
		var/list/parts = list()
		for(var/label in report)
			parts += "[label] ([report[label]] units)"
		visible_message(span_info("[src] finishes: [jointext(parts, ", ")]."))
	var/mob/living/user = user_ref?.resolve()
	if(istype(user) && made)
		user.rogue_adjust_experience(ROGUE_ALCHEMY_SKILL, user.rogue_stat(ROGUE_STAT_INTELLIGENCE) * made * rogue_essence_numbers().combiner_xp_share)
	if(mode != ROGUE_COMBINER_GENERIC)
		attempt_combination(null)

/obj/machinery/essence/combiner/examine(mob/user)
	. = ..()
	switch(mode)
		if(ROGUE_COMBINER_MANUAL)
			var/list/combinations = rogue_essence_combinations()
			var/datum/essence_combination/recipe = combinations[manual_recipe_path]
			if(recipe)
				. += span_notice("Mode: Manual: locked to [recipe.name].")
			else
				. += span_warning("Mode: Manual: no recipe selected.")
		if(ROGUE_COMBINER_AUTO)
			. += span_notice("Mode: Automatic: prioritises recipes matching network demand.")
		else
			. += span_notice("Mode: Generic, will attempt any matching recipe.")

/obj/machinery/essence/combiner/essence_examine(mob/user)
	. = ..()
	. += span_notice("=== Output ===")
	. += rogue_essence_store_lines(output_storage, user)
	if(combining)
		. += span_warning("Combination in progress…")
