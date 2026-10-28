// Ratwood artificer table (roguejobs/artificer/artificer_table.dm, artificer_recipes/artificer_recipes.dm): a plank, a bar,
// ore or a satchel is set on the table and a hammer picks what to make from it, then works it. Each strike takes hammer work
// off the current stage (more with engineering); a finished stage wants the next material, if the recipe has more; once
// nothing is left the next strike makes the thing. Below the recipe's skill level a strike may ruin the material.
// The recipes are Ratwood data (/datum/artificer_recipe under Ratwood's paths) that the porter is to write, as it writes the
// anvil's; until it does the table has nothing to make.

/// Ratwood: below the recipe's level a strike may ruin the material, less likely per rank and by 1% with good luck.
/// Numbers of config/redtard/mechanics/values.txt (section "Crafting").
#define ARTIFICER_FAIL_BASE rogue_value("artificer_fail_chance")
#define ARTIFICER_FAIL_PER_RANK rogue_value("artificer_fail_per_rank")
/// Ratwood experience: intelligence × level × this for a made thing, intelligence × level for a ruined material.
#define ARTIFICER_XP_PER_LEVEL rogue_value("artificer_xp_per_level")
#define ARTIFICER_HAMMER_SOUNDS list('modular_redtard/crafting/sound/fence_hit1.ogg', 'modular_redtard/crafting/sound/fence_hit2.ogg', 'modular_redtard/crafting/sound/fence_hit3.ogg')
#define ARTIFICER_STAGE_SOUND 'modular_redtard/crafting/sound/metal_sheet.ogg'
#define ARTIFICER_RUIN_SOUND 'modular_redtard/rockhill/sound/combat/hits/onwood/destroyfurniture.ogg'
#define ARTIFICER_SAW_SOUND 'modular_redtard/crafting/sound/wood_saw.ogg'

/// Ratwood artificer recipe. created_item is a type or a list of types; additional_items are added one per finished stage,
/// in any order (picked at random, as in Ratwood).
/datum/artificer_recipe
	var/name
	/// Ratwood i_type: the first list of the choice.
	var/i_type
	var/obj/item/required_item
	var/created_item
	var/list/additional_items = list()
	/// Hammer work per stage (Ratwood hammers_per_item).
	var/hammers_per_item = 0
	/// Ratwood skill_level: the rank the recipe is meant for, and the experience it gives.
	var/skill_level = 0
	var/appro_skill = /datum/attribute/skill/craft/engineering

GLOBAL_LIST_INIT(rogue_artificer_recipes, init_rogue_artificer_recipes())

/proc/init_rogue_artificer_recipes()
	. = list()
	for(var/datum/artificer_recipe/recipe_type as anything in subtypesof(/datum/artificer_recipe))
		if(initial(recipe_type.name) && initial(recipe_type.required_item) && initial(recipe_type.created_item))
			. += new recipe_type

/// The progress of one recipe on the table (Ratwood's own copy of the recipe on the material).
/datum/artificer_work
	var/datum/artificer_recipe/recipe
	var/hammers_left = 0
	var/list/remaining
	var/obj/item/needed_item
	/// The current stage is hammered out (Ratwood hammered).
	var/hammered = FALSE
	/// Everything is in; the next strike makes the thing (Ratwood progress 100).
	var/done = FALSE

/datum/artificer_work/New(datum/artificer_recipe/chosen)
	recipe = chosen
	hammers_left = chosen.hammers_per_item
	remaining = chosen.additional_items.Copy()

/datum/artificer_work/Destroy(force)
	recipe = null
	return ..()

/// Ratwood hammer work per strike by rank: half for novices, one for apprentices and journeymen, two for experts and
/// masters, three for legends.
/datum/artificer_work/proc/hammer_power(rank)
	switch(rank)
		if(ROGUE_RANK_NONE to ROGUE_RANK_NOVICE)
			return 0.5
		if(ROGUE_RANK_APPRENTICE to ROGUE_RANK_JOURNEYMAN)
			return 1
		if(ROGUE_RANK_EXPERT to ROGUE_RANK_MASTER)
			return 2
	return 3

/// Ratwood advance().
/datum/artificer_work/proc/advance(mob/living/user, rank)
	if(done)
		return
	if(hammers_left <= 0)
		hammered = TRUE
		user.visible_message(span_warning("[user] hammers the contraption."))
		if(length(remaining))
			needed_item = pick(remaining)
			remaining -= needed_item
		if(needed_item)
			to_chat(user, span_info("Now it's time to add \a [initial(needed_item.name)]."))
			return
	if(!needed_item && hammered)
		done = TRUE
		return
	if(!hammered && hammers_left > 0)
		hammers_left = max(0, hammers_left - hammer_power(rank))
		user.visible_message(span_warning("[user] hammers the contraption."))

/// Ratwood item_added(): the material goes in and the next stage wants hammering.
/datum/artificer_work/proc/item_added(mob/living/user)
	user.visible_message(span_info("[user] adds [initial(needed_item.name)]."))
	needed_item = null
	hammers_left = recipe.hammers_per_item
	hammered = FALSE

/obj/machinery/artificer_table
	interaction_flags_atom = NONE
	/// The plank, bar, ore or satchel on the table (Ratwood material).
	var/obj/item/material
	var/datum/artificer_work/work

/obj/machinery/artificer_table/Destroy()
	material?.forceMove(drop_location())
	QDEL_NULL(work)
	return ..()

/obj/machinery/artificer_table/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone != material)
		return
	material = null
	QDEL_NULL(work)
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/artificer_table/examine(mob/user)
	. = ..()
	if(!material)
		. += span_info("Set a plank, a bar, ore or a satchel on it, then strike it with a hammer to choose what to make.")
		return
	. += span_warning("There's \a [material] ready to be worked.")
	if(work?.needed_item)
		. += span_notice("It needs \a [initial(work.needed_item.name)] to continue.")
	else if(work)
		. += span_notice("It is being made into [work.recipe.name].")

/obj/machinery/artificer_table/update_overlays()
	. = ..()
	if(!material)
		return
	var/mutable_appearance/shown = new(material)
	shown.plane = FLOAT_PLANE
	shown.layer = FLOAT_LAYER
	shown.pixel_w = 0
	shown.pixel_z = 6
	shown.transform = matrix() * 0.8
	. += shown

/// Ratwood attackby(): what may be set on the table.
/obj/machinery/artificer_table/proc/is_material(obj/item/thing)
	return istype(thing, /obj/item/natural/wood/plank) || istype(thing, /obj/item/ingot) || istype(thing, /obj/item/rogueore) || istype(thing, /obj/item/storage/backpack/rogue/satchel)

/obj/machinery/artificer_table/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/rogueweapon/hammer))
		return hammer_interaction(user)
	if(!material && is_material(tool))
		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING
		material = tool
		update_appearance(UPDATE_OVERLAYS)
		return ITEM_INTERACT_SUCCESS
	if(work?.hammered && work.needed_item && istype(tool, work.needed_item))
		if(istype(tool, /obj/item/natural/wood/plank))
			playsound(src, ARTIFICER_SAW_SOUND, 100, TRUE)
		work.item_added(user)
		qdel(tool)
		return ITEM_INTERACT_SUCCESS
	return ..()

/obj/machinery/artificer_table/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(. || !material)
		return
	var/obj/item/taken = material
	taken.forceMove(drop_location())
	user.put_in_active_hand(taken)
	return TRUE

/obj/machinery/artificer_table/proc/hammer_interaction(mob/living/user)
	user.changeNext_move(CLICK_CD_RAPID)
	if(!material)
		return ITEM_INTERACT_BLOCKING
	if(DOING_INTERACTION_WITH_TARGET(user, src))
		return ITEM_INTERACT_BLOCKING
	if(work)
		strike(user)
	else
		INVOKE_ASYNC(src, PROC_REF(start_work), user)
	return ITEM_INTERACT_SUCCESS

/// Ratwood choose_recipe(): a kind, then a creation from what can be made of the material.
/obj/machinery/artificer_table/proc/start_work(mob/living/user)
	var/obj/item/start = material
	var/list/kinds = list()
	for(var/datum/artificer_recipe/recipe as anything in GLOB.rogue_artificer_recipes)
		if(istype(start, recipe.required_item))
			kinds |= recipe.i_type || "General"
	if(!length(kinds))
		to_chat(user, span_warning("There is nothing I know to make from [start]."))
		return
	var/kind = tgui_input_list(user, "Choose a type", "Artificer", sort_list(kinds))
	if(!kind || material != start || work)
		return
	var/list/by_name = list()
	for(var/datum/artificer_recipe/recipe as anything in GLOB.rogue_artificer_recipes)
		if((recipe.i_type || "General") == kind && istype(start, recipe.required_item))
			by_name[recipe.name] = recipe
	var/choice = tgui_input_list(user, "Choose A Creation", "Artificer", sort_list(by_name.Copy()))
	if(!choice || material != start || work || !user.Adjacent(src))
		return
	work = new(by_name[choice])
	var/obj/item/rogueweapon/hammer/hammer = user.get_active_held_item()
	if(istype(hammer))
		strike(user)

/// Ratwood hammer attackby() with a recipe chosen: a finished piece is made, a stage is worked, or clumsy hands ruin it.
/obj/machinery/artificer_table/proc/strike(mob/living/user)
	if(work.hammered || work.done)
		playsound(src, ARTIFICER_STAGE_SOUND, 100, TRUE)
		shake_camera(user, 1, 1)
	do_sparks(1, TRUE, src)
	var/rank = user.rogue_skill_rank(work.recipe.appro_skill)
	if(work.done)
		finish(user)
		return
	if(rank < work.recipe.skill_level && prob(max(0, ARTIFICER_FAIL_BASE - (user.rogue_goodluck(2) ? 1 : 0) - rank * ARTIFICER_FAIL_PER_RANK)))
		to_chat(user, span_warning("Ah yes, my incompetence bears fruit."))
		playsound(src, ARTIFICER_RUIN_SOUND, 100, FALSE)
		user.rogue_craft_experience(work.recipe.appro_skill, user.rogue_stat(ROGUE_STAT_INTELLIGENCE) * work.recipe.skill_level)
		QDEL_NULL(material)
		return
	if(!work.hammered)
		playsound(src, pick(ARTIFICER_HAMMER_SOUNDS), 100, FALSE)
		work.advance(user, rank)

/obj/machinery/artificer_table/proc/finish(mob/living/user)
	var/datum/artificer_recipe/recipe = work.recipe
	var/list/made = islist(recipe.created_item) ? recipe.created_item : list(recipe.created_item)
	var/turf/here = get_turf(src)
	for(var/thing_type in made)
		new thing_type(here)
	var/obj/item/first = made[1]
	user.visible_message(span_info("[user] creates \a [initial(first.name)]."))
	user.log_message("crafted [english_list(made)] at [src] ([recipe.type])", LOG_GAME)
	user.rogue_craft_experience(recipe.appro_skill, user.rogue_stat(ROGUE_STAT_INTELLIGENCE) * recipe.skill_level * ARTIFICER_XP_PER_LEVEL)
	QDEL_NULL(material)

#undef ARTIFICER_FAIL_BASE
#undef ARTIFICER_FAIL_PER_RANK
#undef ARTIFICER_XP_PER_LEVEL
#undef ARTIFICER_HAMMER_SOUNDS
#undef ARTIFICER_STAGE_SOUND
#undef ARTIFICER_RUIN_SOUND
#undef ARTIFICER_SAW_SOUND
