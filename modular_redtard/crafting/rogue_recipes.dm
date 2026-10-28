/// Ratwood's crafting recipes (code/modules/roguetown/roguecrafting; datums/components/crafting of Ratwood) in TG's crafting
/// menu (PersonalCrafting), opened by the craft button of the medieval HUD. tools/port_rockhill.py writes the recipes into
/// crafting/ported/craft_recipes.dm: Ratwood's, then Azure Peak's that Ratwood lacks. Ratwood and Azure share the old
/// Roguetown menu (a list of skills, then of recipes, built by checking every recipe against the surroundings on each
/// click); TG's sends the recipes once and filters them in the window, so it stays.
///
/// A recipe is crafted as in Ratwood: one-second tries, each succeeding by skill, difficulty and intelligence (a recipe two
/// ranks above the crafter never does), structures built in front of the crafter, or on its own tile, or against a wall,
/// and craft experience for the skill on success.

/// Ratwood's tries per craft (construct_item(): 100 one-second do_afters).
#define ROGUE_CRAFT_TRIES 100

/datum/crafting_recipe/roguetown
	abstract_type = /datum/crafting_recipe/roguetown
	category = "Other"
	// Ratwood checks the tile the thing is built on, not the crafter's.
	crafting_flags = NONE
	time = 1 SECONDS
	/// The skill of the craft (Ratwood skillcraft); null crafts at once, by anyone.
	var/rogue_skill = /datum/attribute/skill/craft/crafting
	/// Ratwood craftdiff: every step takes a quarter of the chance away.
	var/rogue_difficulty = 1
	/// Further results beside result (Ratwood's result lists).
	var/list/rogue_results
	/// A structure that has to stand on the tile built on (Ratwood structurecraft).
	var/rogue_structure
	/// Ratwood req_table, ontile, wallcraft, buildsame, ignoredensity.
	var/rogue_on_table = FALSE
	var/rogue_on_tile = FALSE
	var/rogue_on_wall = FALSE
	var/rogue_build_same = FALSE
	var/rogue_ignore_density = FALSE
	var/rogue_verb = "crafts"
	var/rogue_verb_simple = "craft"
	var/rogue_sound
	/// Experience of a success instead of Ratwood's intelligence × 2 + difficulty × 10; -1 keeps that.
	var/rogue_xp = -1
	/// The crafter picks one of the four diagonals for the result (Ratwood diagonal: railing corners).
	var/rogue_diagonal = FALSE
	/// Ratwood required_tech_node: the recipe stays hidden until this node is unlocked (crafting/tech_nodes.dm).
	var/rogue_tech_node

/// Ratwood TurfCheck(): a recipe's own rule for the tile it is built on (crafting/recipe_rules.dm).
/datum/crafting_recipe/roguetown/proc/rogue_turf_check(mob/living/user, turf/target)
	return TRUE

/// Where the result goes (Ratwood construct_item()): the tile in front, or the crafter's own when the front is not open or
/// the recipe is built on its tile; a wall thing needs a wall in front. Returns a turf, or TG's failure text.
/datum/crafting_recipe/roguetown/proc/rogue_target(mob/living/user)
	var/turf/target = get_step(user, user.dir)
	if(isopenturf(target) && rogue_on_wall)
		return ", it has to be made against a wall!"
	if(!isopenturf(target) || rogue_on_tile)
		target = get_turf(user)
	if(rogue_on_table && !(locate(/obj/structure/table) in target))
		return ", it has to be made on a table!"
	if(rogue_structure && !(locate(rogue_structure) in target))
		var/atom/structure = rogue_structure
		return ", it needs \a [initial(structure.name)]!"
	if(ispath(result, /obj/structure) || ispath(result, /obj/machinery))
		for(var/obj/structure/thing in target)
			if(rogue_build_same && istype(thing, result))
				if(thing.dir == user.dir)
					return ", something is in the way!"
				continue
			if(rogue_structure && istype(thing, rogue_structure))
				continue
			if(thing.density && !rogue_ignore_density)
				return ", something is in the way!"
		for(var/obj/machinery/machine in target)
			if(machine.density)
				return ", something is in the way!"
	return target

/// Ratwood's chance of one try, in percent.
/datum/crafting_recipe/roguetown/proc/rogue_chance(mob/living/user)
	var/chance = 100
	if(rogue_skill)
		var/rank = user.mind ? user.rogue_learned_rank(rogue_skill) : 0
		if(rogue_difficulty - rank >= 2)
			return 0
		chance = 25 - 25 * rogue_difficulty + 25 * rank
	var/intelligence = user.rogue_stat(ROGUE_STAT_INTELLIGENCE)
	if(intelligence > 10)
		chance += (intelligence - 10) * 2
		if(HAS_TRAIT(user, TRAIT_METICULOUS))
			chance += (intelligence - 10) * 2
	return clamp(chance, 0, 99)

/// The crafter's experience of a success (Ratwood: intelligence × 2, and difficulty × 10 more for a hard recipe).
/datum/crafting_recipe/roguetown/proc/rogue_experience(mob/living/user)
	if(rogue_xp >= 0)
		return rogue_xp
	return user.rogue_stat(ROGUE_STAT_INTELLIGENCE) * 2 + max(rogue_difficulty, 0) * 10

/// Ratwood's crafting for its recipes: the tile, then tries until one succeeds; TG's checks of what is at hand stay.
/datum/component/personal_crafting/construct_item(atom/crafter, datum/crafting_recipe/recipe)
	var/datum/crafting_recipe/roguetown/rogue = recipe
	if(!istype(rogue) || !isliving(crafter))
		return ..()
	var/mob/living/user = crafter
	if(!rogue_tech_unlocked(rogue.rogue_tech_node))
		return ", I don't know how to make this yet!"
	var/turf/target = rogue.rogue_target(user)
	if(istext(target))
		return target
	if(!rogue.rogue_turf_check(user, target))
		return ", I can't craft here!"
	var/fail_message = perform_all_checks(user, recipe, get_surroundings(user, recipe.blacklist))
	if(fail_message)
		return fail_message
	var/chance = rogue.rogue_chance(user)
	if(!chance)
		return ", it is beyond my skill!"
	var/build_dir
	if(rogue.rogue_diagonal)
		build_dir = rogue_pick_diagonal(user)
		if(!build_dir)
			return "."
	if(rogue.rogue_sound)
		playsound(target, rogue.rogue_sound, 100, TRUE)
	for(var/try_number in 1 to ROGUE_CRAFT_TRIES)
		if(!do_after(user, 1 SECONDS, target = user))
			return "."
		target = rogue.rogue_target(user)
		if(istext(target))
			return target
		fail_message = perform_all_checks(user, recipe, get_surroundings(user, recipe.blacklist), check_tools_last = TRUE)
		if(fail_message)
			return fail_message
		if(prob(chance))
			return rogue_make(user, rogue, target, build_dir)
		to_chat(user, span_danger("I've failed to craft \the [recipe.name]."))
	return "."

/// Ratwood SelectDiagDirection(): one of the four diagonals, or null if the crafter declines.
/proc/rogue_pick_diagonal(mob/user)
	var/static/list/diagonals = list("NORTHWEST" = NORTHWEST, "SOUTHWEST" = SOUTHWEST, "SOUTHEAST" = SOUTHEAST, "NORTHEAST" = NORTHEAST)
	var/choice = tgui_input_list(user, "Please select a direction.", "Direction", diagonals)
	return choice ? diagonals[choice] : null

/// Makes the recipe's result from what is at hand (the end of TG's construct_item(), on Ratwood's tile), facing the crafter's
/// way or the diagonal picked for it.
/datum/component/personal_crafting/proc/rogue_make(mob/living/user, datum/crafting_recipe/roguetown/recipe, turf/target, build_dir)
	var/list/stuff_to_use = get_used_reqs(recipe, user)
	var/datum/reagents/holder = locate() in stuff_to_use
	if(holder)
		stuff_to_use -= holder
		qdel(holder)
	var/atom/result
	var/list/made = list()
	var/list/result_types = list(recipe.result)
	if(LAZYLEN(recipe.rogue_results))
		result_types += recipe.rogue_results
	for(var/result_type in result_types)
		var/atom/thing
		if(ispath(result_type, /turf))
			thing = target.place_on_top(result_type)
		else if(ispath(result_type, /obj/item))
			thing = new result_type(get_turf(user))
		else
			thing = new result_type(target)
		if(!thing)
			continue
		thing.setDir(build_dir || user.dir)
		if(isitem(thing))
			recipe.rogue_apply_quality(thing, user)
		made += thing
		result ||= thing
	if(!result)
		return ", unknown error!"
	result.on_craft_completion(stuff_to_use, recipe, user)
	for(var/atom/movable/component as anything in stuff_to_use)
		if(component.loc != result || isturf(result))
			qdel(component)
	for(var/obj/item/extra in made - result)
		user.put_in_hands(extra)
	user.visible_message(span_notice("[user] [recipe.rogue_verb] \a [recipe.name]!"), span_notice("I [recipe.rogue_verb_simple] \a [recipe.name]!"))
	user.log_message("crafted [recipe.name] ([recipe.type])", LOG_GAME)
	if(recipe.rogue_skill)
		user.rogue_craft_experience(recipe.rogue_skill, recipe.rogue_experience(user))
	return result

/// TG's make_action, but a structure stays where Ratwood built it instead of moving under the crafter.
/datum/component/personal_crafting/make_action(datum/crafting_recipe/recipe, mob/user)
	if(!istype(recipe, /datum/crafting_recipe/roguetown))
		return ..()
	var/atom/result = construct_item(user, recipe)
	if(istext(result))
		if(result != ".")
			to_chat(user, span_warning("Construction failed[result]"))
		return FALSE
	if(isitem(result))
		user.put_in_hands(result)
	user.investigate_log("crafted [recipe]", INVESTIGATE_CRAFTING)
	return TRUE

/// Medieval maps show Ratwood's recipes and no others, without those behind a locked tech node; every other map keeps TG's.
/datum/component/personal_crafting/get_visible_recipes(mob/user)
	var/medieval = rogue_combat_enabled()
	. = list()
	for(var/datum/crafting_recipe/recipe as anything in ..())
		if(istype(recipe, /datum/crafting_recipe/roguetown) != medieval)
			continue
		var/datum/crafting_recipe/roguetown/rogue = recipe
		if(medieval && !rogue_tech_unlocked(rogue.rogue_tech_node))
			continue
		. += recipe

/// Ratwood has_item_quality: crafted things of these kinds take a quality tier by the crafter's skill (apply_quality()).
/obj/item/var/rogue_has_quality = FALSE

/obj/item/rogueweapon
	rogue_has_quality = TRUE

/obj/item/clothing
	rogue_has_quality = TRUE

/obj/item/gun/ballistic/revolver/grenadelauncher/bow
	rogue_has_quality = TRUE

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	rogue_has_quality = TRUE

/obj/item/carvedgem
	rogue_has_quality = TRUE

/obj/item/ingot
	rogue_has_quality = TRUE

/// Ratwood apply_quality() odds by the crafter's rank, in the form of rogue_pottery_craft_odds (pottery.dm): mostly crude
/// or rough below journeyman, standard at journeyman, fine to masterwork from expert on.
GLOBAL_LIST_INIT(rogue_craft_quality_odds, list(
	list(list(60, ROGUE_QUALITY_CRUDE), list(95, ROGUE_QUALITY_ROUGH), ROGUE_QUALITY_STANDARD),
	list(list(60, ROGUE_QUALITY_CRUDE), list(95, ROGUE_QUALITY_ROUGH), ROGUE_QUALITY_STANDARD),
	list(list(20, ROGUE_QUALITY_CRUDE), list(75, ROGUE_QUALITY_ROUGH), ROGUE_QUALITY_STANDARD),
	list(ROGUE_QUALITY_STANDARD),
	list(list(70, ROGUE_QUALITY_FINE), list(95, ROGUE_QUALITY_FLAWLESS), ROGUE_QUALITY_MASTERWORK),
	list(list(30, ROGUE_QUALITY_FINE), list(80, ROGUE_QUALITY_FLAWLESS), ROGUE_QUALITY_MASTERWORK),
	list(list(40, ROGUE_QUALITY_FLAWLESS), ROGUE_QUALITY_MASTERWORK),
))

/// Ratwood construct_item() quality: pottery (the ceramics skill) takes a pottery tier, and things with an item quality a
/// tier by the crafter's rank. Ratwood's skip_quality recipes (the lowest input quality instead) are not carried by the porter.
/datum/crafting_recipe/roguetown/proc/rogue_apply_quality(obj/item/made, mob/living/user)
	var/rank = rogue_skill ? user.rogue_learned_rank(rogue_skill) : ROGUE_RANK_NONE
	if(rogue_skill == /datum/attribute/skill/craft/ceramics)
		made.rogue_apply_pottery_quality(rogue_roll_tier(GLOB.rogue_pottery_craft_odds, rank))
	if(made.rogue_has_quality)
		made.rogue_apply_craft_quality(rogue_roll_tier(GLOB.rogue_craft_quality_odds, rank))

/// Ratwood apply_quality(): the tier and its name prefix (none for standard).
/obj/item/proc/rogue_apply_craft_quality(tier)
	rogue_quality = tier
	var/prefix = rogue_quality_prefix(tier)
	if(prefix)
		name = "[prefix] [name]"

#undef ROGUE_CRAFT_TRIES
