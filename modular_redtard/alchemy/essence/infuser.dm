// Vibelin's essence infuser (essence_machines/essence_infuser.dm): an item set on it and soaked in the essences of an
// infusion (/datum/infusion_recipe, alchemy/vibelin/infusion_recipes.dm) becomes another: glass from stone, thaumic iron,
// mana crystals, the combat flask, the advanced node jar. It pulls the essences it lacks from its links while it waits.
// Added to Vibelin: a right click takes the item back off; an item that holds mana passes its mana to what it becomes
// (rogue_mana_of() and transfer_to(), block VM1), as Vibelin's jar passes its node on.

/obj/machinery/essence/infuser
	name = "essence infuser"
	desc = "Saturates a placed item with alchemical essences to transform it."
	icon_state = "splitter"
	network_priority = 4
	var/obj/item/infusion_target
	var/datum/infusion_recipe/current_recipe
	var/infusing = FALSE
	var/infusion_timer
	var/spark_timer

/obj/machinery/essence/infuser/storage_capacity()
	return rogue_essence_numbers().infuser_capacity

/obj/machinery/essence/infuser/storage_types()
	return rogue_essence_numbers().infuser_types

/obj/machinery/essence/infuser/Destroy()
	stop_infusion()
	infusion_target?.forceMove(drop_location())
	infusion_target = null
	current_recipe = null
	return ..()

/obj/machinery/essence/infuser/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone != infusion_target)
		return
	infusion_target = null
	stop_infusion()
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/essence/infuser/proc/stop_infusion()
	if(infusion_timer)
		deltimer(infusion_timer)
		infusion_timer = null
	if(spark_timer)
		deltimer(spark_timer)
		spark_timer = null
	infusing = FALSE
	end_processing()

/obj/machinery/essence/infuser/build_allowed_types()
	if(!current_recipe || infusing)
		return list()
	var/list/result = list()
	for(var/essence_type in current_recipe.required_essences)
		var/deficit = current_recipe.required_essences[essence_type] - storage.get(essence_type)
		if(deficit > 0)
			result[essence_type] = deficit
	return result

/obj/machinery/essence/infuser/push_to_linked(datum/essence_storage/from_storage)
	push_surplus_to_linked(from_storage)

/// Ticks only while it waits for essences.
/obj/machinery/essence/infuser/process(seconds_per_tick)
	pull_from_linked(storage)
	if(recipe_ready())
		return PROCESS_KILL

/obj/machinery/essence/infuser/on_storage_changed(essence_type, amount, added)
	. = ..()
	if(added && !infusing && recipe_ready())
		end_processing()

/obj/machinery/essence/infuser/proc/recipe_ready()
	if(!current_recipe || !infusion_target)
		return FALSE
	for(var/essence_type in current_recipe.required_essences)
		if(storage.get(essence_type) < current_recipe.required_essences[essence_type])
			return FALSE
	return TRUE

/obj/machinery/essence/infuser/proc/wait_for_essences()
	if(current_recipe && infusion_target && !infusing && !recipe_ready())
		begin_processing()

/obj/machinery/essence/infuser/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/essence_vial) || istype(tool, /obj/item/essence_connector))
		return ..()
	if(infusion_target || infusing)
		return NONE
	if(!length(rogue_infusions_for(tool)))
		to_chat(user, span_warning("[tool] cannot be infused."))
		return ITEM_INTERACT_BLOCKING
	if(!user.transferItemToLoc(tool, src))
		return ITEM_INTERACT_BLOCKING
	infusion_target = tool
	to_chat(user, span_info("You place [tool] on [src]."))
	if(current_recipe && !istype(tool, current_recipe.target_type))
		clear_recipe()
	wait_for_essences()
	update_appearance(UPDATE_OVERLAYS)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/essence/infuser/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(infusing)
		to_chat(user, span_warning("[src] is currently infusing."))
		return TRUE
	if(!infusion_target)
		to_chat(user, span_info("Place an item on [src] first."))
		return TRUE
	if(!current_recipe)
		INVOKE_ASYNC(src, PROC_REF(show_recipe_selection), user)
		return TRUE
	if(!recipe_ready())
		show_recipe_progress(user)
		return TRUE
	begin_infusion(user)
	return TRUE

/obj/machinery/essence/infuser/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(infusing)
		to_chat(user, span_warning("[src] is currently infusing."))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(infusion_target)
		var/obj/item/taken = infusion_target
		taken.forceMove(drop_location())
		user.put_in_hands(taken)
		to_chat(user, span_info("You take [taken] off [src]."))
	else if(current_recipe)
		clear_recipe(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/essence/infuser/proc/show_recipe_selection(mob/user)
	var/list/options = list()
	for(var/datum/infusion_recipe/recipe as anything in rogue_infusions_for(infusion_target))
		options[recipe.name] = recipe
	if(!length(options))
		to_chat(user, span_warning("No infusion recipes available for [infusion_target]."))
		return
	var/choice = tgui_input_list(user, "Select recipe", "Infusion Recipes", options)
	if(!choice || QDELETED(src) || infusing || !infusion_target || !IsReachableBy(user))
		return
	current_recipe = options[choice]
	network?.invalidate_cache()
	push_surplus_to_linked(storage)
	wait_for_essences()
	to_chat(user, span_info("Recipe selected: [current_recipe.name]"))

/obj/machinery/essence/infuser/proc/clear_recipe(mob/user)
	if(!current_recipe)
		return
	stop_infusion()
	current_recipe = null
	network?.invalidate_cache()
	push_surplus_to_linked(storage)
	update_appearance(UPDATE_OVERLAYS)
	if(user)
		to_chat(user, span_info("Recipe cleared."))

/obj/machinery/essence/infuser/proc/show_recipe_progress(mob/user)
	to_chat(user, span_info("Progress for '[current_recipe.name]':"))
	for(var/essence_type in current_recipe.required_essences)
		to_chat(user, span_info("  [rogue_essence_label(essence_type, user, "Essence of")]: [storage.get(essence_type)]/[current_recipe.required_essences[essence_type]]"))

/obj/machinery/essence/infuser/proc/begin_infusion(mob/living/user)
	infusing = TRUE
	end_processing()
	network?.invalidate_cache()
	var/speed = rogue_thaumic_research().get_research_bonus(/datum/thaumic_research_node/transmutation)
	user.visible_message(span_info("[user] begins the infusion on [infusion_target]."))
	update_appearance(UPDATE_OVERLAYS)
	spark_timer = addtimer(CALLBACK(src, PROC_REF(infusion_spark)), 1 SECONDS, TIMER_LOOP | TIMER_STOPPABLE)
	infusion_timer = addtimer(CALLBACK(src, PROC_REF(complete_infusion)), rogue_essence_numbers().infuser_time / speed, TIMER_STOPPABLE)

/// Sparks now and then while it works (a sight only, not TG's sparks, which light fires).
/obj/machinery/essence/infuser/proc/infusion_spark()
	if(!infusing)
		return
	if(prob(50))
		new /obj/effect/temp_visual/essence_glow/sparks(get_turf(src))

/obj/machinery/essence/infuser/proc/complete_infusion()
	infusion_timer = null
	var/was_infusing = infusing
	stop_infusion()
	if(!was_infusing || !current_recipe || !infusion_target)
		return
	for(var/essence_type in current_recipe.required_essences)
		storage.remove(essence_type, current_recipe.required_essences[essence_type])
	var/obj/item/old_item = infusion_target
	var/atom/new_atom = new current_recipe.result_type(drop_location())
	pass_on_contents(old_item, new_atom)
	infusion_target = null
	qdel(old_item)
	current_recipe = null
	update_appearance(UPDATE_OVERLAYS)
	visible_message(span_notice("[src] chimes as the infusion completes!"))

/// What the infused item carried goes on to what it became: a jar's node (Vibelin), an item's mana (block VM1 pools).
/obj/machinery/essence/infuser/proc/pass_on_contents(obj/item/old_item, atom/new_atom)
	if(istype(old_item, /obj/item/essence_node_jar) && istype(new_atom, /obj/item/essence_node_jar))
		var/obj/item/essence_node_jar/old_jar = old_item
		var/obj/item/essence_node_jar/new_jar = new_atom
		if(old_jar.contained_node && !new_jar.contained_node)
			new_jar.contained_node = old_jar.contained_node
			new_jar.contained_node.forceMove(new_jar)
			old_jar.contained_node = null
			new_jar.update_appearance(UPDATE_OVERLAYS)
	if(!ismovable(new_atom))
		return
	var/datum/rogue_mana/old_pool = rogue_mana_of(old_item)
	var/datum/rogue_mana/new_pool = rogue_mana_of(new_atom)
	if(old_pool && new_pool && old_pool != new_pool && old_pool.amount > 0)
		old_pool.transfer_to(new_pool, old_pool.amount, TRUE)

/obj/machinery/essence/infuser/essence_examine(mob/user)
	. = ..()
	if(infusion_target)
		. += span_notice("Item: [infusion_target]")
	if(current_recipe)
		. += span_notice("Recipe: [current_recipe.name]")
		for(var/essence_type in current_recipe.required_essences)
			. += span_notice("  [rogue_essence_label(essence_type, user, "Essence of")]: [storage.get(essence_type)]/[current_recipe.required_essences[essence_type]]")
	if(infusing)
		. += span_notice("Infusing...")
