// Ratwood potter's wheel (roguejobs/ceramicist/potterWheel.dm): kneaded clay (or refined, for porcelain) is set on the wheel,
// a recipe is picked from a radial menu, and right-click spins it. After each of the first spins the clay dries out and wants
// a little water; up to an expert the clay may collapse; the last spin shapes the piece, with a pottery quality by skill.
// Azure Peak's wheel is only a station for its crafting recipes, which keep working here (the wheel stays the same type).

// Numbers of config/redtard/mechanics/values.txt (section "Crafting").
#define WHEEL_WATER rogue_value("wheel_water")
#define WHEEL_REWETS_KNEADED rogue_value("wheel_rewets_kneaded")
#define WHEEL_REWETS_REFINED rogue_value("wheel_rewets_refined")
/// Ratwood spin time: the recipe's time split between its spins, slower per rank below journeyman.
#define WHEEL_MIN_SPIN rogue_value("wheel_min_spin")
#define WHEEL_SPIN_PER_RANK rogue_value("wheel_spin_per_rank")
/// Ratwood experience: the ruin experience for a collapse; for a piece intelligence (at least the ruin experience) plus a share per rank of difficulty.
#define WHEEL_RUIN_XP rogue_value("wheel_ruin_xp")
#define WHEEL_XP_PER_DIFFICULTY rogue_value("wheel_xp_per_difficulty")
#define WHEEL_SPIN_SOUND 'modular_redtard/rockhill/sound/foley/grindblade.ogg'
#define WHEEL_RUIN_SOUND 'modular_redtard/crafting/sound/kneading.ogg'
#define WHEEL_WET_SOUND 'modular_redtard/crafting/sound/splishy.ogg'

/// Ratwood calculate_pottery_quality_score() (crafting.dm): pottery tier of a crafted piece by skill rank. Each row lists
/// list(highest roll of 1-100, tier) in order; a roll above them all gives the row's last number.
GLOBAL_LIST_INIT(rogue_pottery_craft_odds, list(
	list(0),
	list(list(25, 1), 0),
	list(list(20, 2), list(65, 1), 0),
	list(list(15, 3), list(55, 2), list(80, 1), 0),
	list(list(15, 4), list(50, 3), list(80, 2), list(95, 1), 0),
	list(list(20, 5), list(50, 4), list(80, 3), list(95, 2), 1),
	list(list(40, 5), list(70, 4), list(90, 3), 2),
))

/// Ratwood calculate_pottery_quality() of the wheel: harsher below expert than crafted pottery.
GLOBAL_LIST_INIT(rogue_pottery_wheel_odds, list(
	list(0),
	list(list(25, 1), 0),
	list(list(10, 2), list(50, 1), 0),
	list(list(10, 3), list(35, 2), list(65, 1), 0),
	list(list(15, 4), list(50, 3), list(80, 2), list(95, 1), 0),
	list(list(20, 5), list(50, 4), list(80, 3), list(95, 2), 1),
	list(list(40, 5), list(70, 4), list(90, 3), 2),
))

/// Ratwood ruin chance while spinning, by rank; masters and legends never collapse the clay.
GLOBAL_LIST_INIT(rogue_pottery_ruin_chance, list(50, 30, 20, 10, 5))

/// Rolls a tier from a table of odds by skill rank (see rogue_pottery_craft_odds).
/proc/rogue_roll_tier(list/odds, rank)
	var/list/row = odds[clamp(rank, ROGUE_RANK_NONE, ROGUE_RANK_LEGENDARY) + 1]
	var/roll = rand(1, 100)
	for(var/entry in row)
		if(!islist(entry))
			return entry
		var/list/threshold = entry
		if(roll <= threshold[1])
			return threshold[2]
	return 0

/// Ratwood apply_pottery_quality_to_item(): a crafted piece of pottery takes a tier; fine and better are named so, and from
/// flawless on it shines like a polished masterwork.
/obj/item/proc/rogue_apply_pottery_quality(tier)
	rogue_quality = ROGUE_POTTERY_QUALITY(tier)
	if(tier >= ROGUE_POTTERY_NAMED_TIER)
		name = "[rogue_quality_prefix(rogue_quality)] [initial(name)]"
	if(tier >= ROGUE_POTTERY_SHINE_TIER)
		rogue_shine()

// Ratwood kiln firing (ceramicist/clay.dm cooking(), heating_act(); cook/tools/oven.dm process()): a raw clay piece put in a
// burning oven fires into its cooked_type, and the fired piece takes the pottery tier the wheel or the crafting gave the raw
// clay. Fired pottery left in the oven long after cracks from the heat. The heat is TG baking (/datum/component/bakeable), as
// for bread: the oven bakes at half speed, faster with the cooking skill of whoever last used it (survival/cooking.dm).

/// Ratwood cooktime of clay: 30 seconds, a minute for refined clay, 45 seconds for porcelain.
#define KILN_FIRE_TIME rogue_value("clay_fire_time")
#define KILN_FIRE_TIME_REFINED rogue_value("clay_fire_time_refined")
#define KILN_FIRE_TIME_PORCELAIN rogue_value("clay_fire_time_porcelain")
/// Ratwood: fired pottery may crack a minute after its firing, at a chance every oven tick of two seconds.
#define KILN_CRACK_DELAY rogue_value("clay_crack_delay")
#define KILN_CRACK_CHANCE rogue_value("clay_crack_chance")
#define KILN_TICK 2
#define KILN_CRACK_SOUND /datum/sound_effect/shatter

/obj/item
	/// When the item came out of a kiln (Ratwood pottery_baked_at): left in a burning oven long after, it cracks.
	var/rogue_fired_at

/obj/item/natural/clay/Initialize(mapload)
	. = ..()
	if(!cooked_type || !rogue_survival_enabled())
		return
	var/fire_time = rogue_fire_time()
	if(fire_time <= 0)
		return
	AddComponent(/datum/component/bakeable, cooked_type, fire_time, TRUE)
	RegisterSignal(src, COMSIG_ITEM_BAKED, PROC_REF(on_fired))

/// Deciseconds of baking that fire this clay (Ratwood cooktime); 0 - an oven does nothing to it.
/obj/item/natural/clay/proc/rogue_fire_time()
	return KILN_FIRE_TIME

/obj/item/natural/clay/refined/rogue_fire_time()
	return KILN_FIRE_TIME_REFINED

/obj/item/natural/clay/porcelain/rogue_fire_time()
	return KILN_FIRE_TIME_PORCELAIN

/// Ratwood's glass batch keeps cooktime 0: it goes to a smelter, not to an oven.
/obj/item/natural/clay/glassbatch/rogue_fire_time()
	return 0

/// Ratwood heating_act() in an oven: the fired piece takes the pottery tier of the raw clay (crude when nobody shaped it).
/obj/item/natural/clay/proc/on_fired(datum/source, obj/item/fired)
	SIGNAL_HANDLER
	if(!isitem(fired))
		return
	var/tier = isnull(rogue_quality) ? 0 : clamp(rogue_quality - ROGUE_QUALITY_CRUDE, 0, ROGUE_QUALITY_MASTERWORK - ROGUE_QUALITY_CRUDE)
	fired.rogue_apply_pottery_quality(tier)
	fired.rogue_fired_at = world.time

/// Ratwood oven process(): fired pottery left in the burning oven past its time cracks from the heat and shatters.
/obj/machinery/light/rogue/oven/proc/rogue_crack_pottery(obj/item/fired, seconds_per_tick)
	if(!fired.rogue_fired_at || world.time < fired.rogue_fired_at + KILN_CRACK_DELAY)
		return FALSE
	if(!SPT_PROB(KILN_CRACK_CHANCE, seconds_per_tick / KILN_TICK))
		return FALSE
	visible_message(span_warning("[fired] starts to crack from the prolonged heat and shatters!"))
	playsound(src, KILN_CRACK_SOUND, 75, TRUE)
	qdel(fired)
	return TRUE

#undef KILN_FIRE_TIME
#undef KILN_FIRE_TIME_REFINED
#undef KILN_FIRE_TIME_PORCELAIN
#undef KILN_CRACK_DELAY
#undef KILN_CRACK_CHANCE
#undef KILN_TICK
#undef KILN_CRACK_SOUND

/// Ratwood /datum/pottery_wheel_recipe. Ratwood's vases, teaware, statues, the jar helmet and all the porcelain shape into
/// items the port does not have yet, so only the brick, the canister and the bottle are here.
/datum/pottery_wheel_recipe
	var/name = "wheel recipe"
	/// Ratwood craftdiff: the rank the potter needs.
	var/craftdiff = ROGUE_RANK_NONE
	/// Spinning time of the whole piece (Ratwood base_time).
	var/base_time = 4 SECONDS
	var/obj/item/result_type
	var/result_count = 1
	var/required_clay_type = /obj/item/natural/clay/kneaded
	/// Ratwood spins_required: only splits the time (basic kneaded clay takes two).
	var/spins_required = 2

/datum/pottery_wheel_recipe/basic/brick
	name = "clay brick x2"
	base_time = 3 SECONDS
	result_type = /obj/item/natural/clay/claybrick
	result_count = 2

/datum/pottery_wheel_recipe/basic/cup
	name = "clay canister"
	base_time = 3 SECONDS
	result_type = /obj/item/natural/clay/claycup

/datum/pottery_wheel_recipe/basic/bottle
	name = "clay bottle"
	base_time = 3.5 SECONDS
	result_type = /obj/item/natural/clay/claybottle

GLOBAL_LIST_INIT(rogue_pottery_wheel_recipes, init_rogue_pottery_wheel_recipes())

/proc/init_rogue_pottery_wheel_recipes()
	. = list()
	for(var/datum/pottery_wheel_recipe/recipe_type as anything in subtypesof(/datum/pottery_wheel_recipe))
		if(initial(recipe_type.result_type))
			. += new recipe_type

/datum/pottery_wheel_recipe/proc/valid_for_clay(obj/item/natural/clay/clay)
	return istype(clay, required_clay_type)

/obj/structure/fluff/ceramicswheel
	max_integrity = 150
	interaction_flags_atom = NONE
	/// The clay on the wheel (Ratwood loaded_clay).
	var/obj/item/natural/clay/loaded_clay
	var/datum/pottery_wheel_recipe/selected_recipe
	var/spin_progress = 0
	/// The clay has dried out and wants water before the next spin.
	var/needs_rewet = FALSE

/obj/structure/fluff/ceramicswheel/Destroy()
	loaded_clay?.forceMove(drop_location())
	selected_recipe = null
	return ..()

/obj/structure/fluff/ceramicswheel/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone != loaded_clay)
		return
	loaded_clay = null
	reset_shaping()
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/fluff/ceramicswheel/examine(mob/user)
	. = ..()
	if(!loaded_clay)
		. += span_info("Set kneaded clay on it, then right-click with an empty hand to shape it.")
		return
	. += span_info("\A [loaded_clay] sits on the wheel.")
	if(selected_recipe)
		. += span_info("It is being shaped into [selected_recipe.name].")
	if(needs_rewet)
		. += span_warning("The clay is drying out and needs water.")

/obj/structure/fluff/ceramicswheel/update_overlays()
	. = ..()
	if(!loaded_clay)
		return
	var/mutable_appearance/clay = mutable_appearance(loaded_clay.icon, loaded_clay.icon_state)
	clay.transform = matrix() * 0.8
	clay.pixel_z = 2
	. += clay

/obj/structure/fluff/ceramicswheel/proc/reset_shaping()
	selected_recipe = null
	spin_progress = 0
	needs_rewet = FALSE

/obj/structure/fluff/ceramicswheel/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(loaded_clay && istype(tool, /obj/item/reagent_containers))
		if(!selected_recipe || !needs_rewet)
			to_chat(user, span_warning("The clay does not need more water yet."))
			return ITEM_INTERACT_BLOCKING
		if(!tool.reagents?.has_reagent(/datum/reagent/water, WHEEL_WATER))
			to_chat(user, span_warning("Needs more water to keep shaping."))
			return ITEM_INTERACT_BLOCKING
		tool.reagents.remove_reagent(/datum/reagent/water, WHEEL_WATER)
		to_chat(user, span_notice("I moisten the clay on the wheel."))
		playsound(src, WHEEL_WET_SOUND, 80, TRUE, -1)
		needs_rewet = FALSE
		return ITEM_INTERACT_SUCCESS
	if(istype(tool, /obj/item/natural/clay))
		if(loaded_clay)
			to_chat(user, span_warning("There is already clay on the wheel."))
			return ITEM_INTERACT_BLOCKING
		if(tool.type == /obj/item/natural/clay)
			to_chat(user, span_warning("This is too rough for wheel work. I need kneaded clay first."))
			return ITEM_INTERACT_BLOCKING
		if(!istype(tool, /obj/item/natural/clay/kneaded) && !istype(tool, /obj/item/natural/clay/refined))
			to_chat(user, span_warning("Only kneaded or refined clay can be worked on the wheel."))
			return ITEM_INTERACT_BLOCKING
		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING
		loaded_clay = tool
		reset_shaping()
		to_chat(user, span_notice("I place [tool] on the wheel."))
		update_appearance(UPDATE_OVERLAYS)
		return ITEM_INTERACT_SUCCESS
	return ..()

/obj/structure/fluff/ceramicswheel/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(. || !loaded_clay)
		return
	if(selected_recipe)
		to_chat(user, span_warning("I can't remove the clay while I'm in the middle of shaping it!"))
		return TRUE
	var/obj/item/taken = loaded_clay
	taken.forceMove(drop_location())
	user.put_in_hands(taken)
	to_chat(user, span_notice("I take [taken] off the wheel."))
	return TRUE

/// Ratwood attack_right(): an empty hand picks the shape, then spins the wheel.
/obj/structure/fluff/ceramicswheel/attack_hand_secondary(mob/living/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	INVOKE_ASYNC(src, PROC_REF(spin), user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/fluff/ceramicswheel/proc/choose_recipe(mob/living/user)
	var/list/recipe_map = list()
	var/list/choices = list()
	var/datum/attribute/skill/skill = GET_ROGUE_ATTRIBUTE(/datum/attribute/skill/craft/ceramics)
	for(var/datum/pottery_wheel_recipe/recipe as anything in GLOB.rogue_pottery_wheel_recipes)
		if(!recipe.valid_for_clay(loaded_clay))
			continue
		var/label = "[recipe.name] ([skill.description_from_level(recipe.craftdiff * ROGUE_SKILL_PER_RANK)])"
		recipe_map[label] = recipe
		var/obj/item/result = recipe.result_type
		choices[label] = image(icon = initial(result.icon), icon_state = initial(result.icon_state))
	if(!length(recipe_map))
		to_chat(user, span_warning("This clay cannot be shaped into anything useful."))
		return null
	var/choice = show_radial_menu(user, src, choices, require_near = TRUE, tooltips = TRUE)
	return choice ? recipe_map[choice] : null

/// Ratwood attack_right(): one spin of the wheel.
/obj/structure/fluff/ceramicswheel/proc/spin(mob/living/user)
	if(DOING_INTERACTION_WITH_TARGET(user, src))
		return
	if(!loaded_clay)
		to_chat(user, span_warning("I need to place clay on the wheel first."))
		return
	if(needs_rewet)
		to_chat(user, span_warning("The clay is drying out. I should add water before spinning again."))
		return
	if(!selected_recipe)
		var/datum/pottery_wheel_recipe/chosen = choose_recipe(user)
		if(!chosen || !loaded_clay || selected_recipe)
			return
		selected_recipe = chosen
	if(!selected_recipe.valid_for_clay(loaded_clay))
		to_chat(user, span_warning("This clay is no longer suitable for the selected shape."))
		reset_shaping()
		return
	var/rank = user.rogue_skill_rank(/datum/attribute/skill/craft/ceramics)
	if(rank < selected_recipe.craftdiff)
		var/datum/attribute/skill/skill = GET_ROGUE_ATTRIBUTE(/datum/attribute/skill/craft/ceramics)
		to_chat(user, span_warning("I need [skill.description_from_level(selected_recipe.craftdiff * ROGUE_SKILL_PER_RANK)] pottery skill for this."))
		reset_shaping()
		return
	var/spin_time = max(WHEEL_MIN_SPIN, round(selected_recipe.base_time / selected_recipe.spins_required) + (ROGUE_RANK_JOURNEYMAN - rank) * WHEEL_SPIN_PER_RANK)
	to_chat(user, span_notice("I spin the wheel and shape [loaded_clay] ([spin_progress + 1]/[selected_recipe.spins_required])..."))
	playsound(src, WHEEL_SPIN_SOUND, 80, FALSE)
	if(!do_after(user, spin_time, target = src))
		return
	if(!loaded_clay || !selected_recipe?.valid_for_clay(loaded_clay))
		to_chat(user, span_warning("The clay is no longer suitable."))
		reset_shaping()
		return
	// Ratwood: up to an expert, the clay may collapse on the wheel.
	if(rank < length(GLOB.rogue_pottery_ruin_chance) && prob(GLOB.rogue_pottery_ruin_chance[rank + 1]))
		user.visible_message(span_warning("[user] loses control of the clay on the wheel - it collapses!"), span_warning("I lose control of the spinning clay - it collapses and is ruined!"))
		playsound(src, WHEEL_RUIN_SOUND, 80, TRUE)
		QDEL_NULL(loaded_clay)
		update_appearance(UPDATE_OVERLAYS)
		user.rogue_craft_experience(/datum/attribute/skill/craft/ceramics, WHEEL_RUIN_XP)
		return
	spin_progress++
	if(spin_progress <= (istype(loaded_clay, /obj/item/natural/clay/refined) ? WHEEL_REWETS_REFINED : WHEEL_REWETS_KNEADED))
		needs_rewet = TRUE
		to_chat(user, span_notice("The clay needs more water before I can continue ([spin_progress]/[selected_recipe.spins_required])."))
		return
	var/datum/pottery_wheel_recipe/made = selected_recipe
	var/turf/here = get_turf(src)
	for(var/piece in 1 to made.result_count)
		var/obj/item/shaped = new made.result_type(here)
		// Ratwood keeps the tier on the unglazed piece for the kiln to name it.
		shaped.rogue_quality = ROGUE_POTTERY_QUALITY(rogue_roll_tier(GLOB.rogue_pottery_wheel_odds, rank))
	user.visible_message(span_notice("[user] shapes [loaded_clay] into [made.name]."), span_notice("I shape [loaded_clay] into [made.name]."))
	QDEL_NULL(loaded_clay)
	update_appearance(UPDATE_OVERLAYS)
	user.rogue_craft_experience(/datum/attribute/skill/craft/ceramics, max(WHEEL_RUIN_XP, user.rogue_stat(ROGUE_STAT_INTELLIGENCE)) + made.craftdiff * WHEEL_XP_PER_DIFFICULTY)

#undef WHEEL_WATER
#undef WHEEL_REWETS_KNEADED
#undef WHEEL_REWETS_REFINED
#undef WHEEL_MIN_SPIN
#undef WHEEL_SPIN_PER_RANK
#undef WHEEL_RUIN_XP
#undef WHEEL_XP_PER_DIFFICULTY
#undef WHEEL_SPIN_SOUND
#undef WHEEL_RUIN_SOUND
#undef WHEEL_WET_SOUND
