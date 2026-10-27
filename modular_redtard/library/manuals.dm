/// Ratwood's profession manuals (code/modules/crafting/recipe_books/recipe_book.dm, recipe_books_list.dm) on the porter's
/// stubs. Using a manual opens a TGUI window (RogueRecipeBook) in place of Ratwood's HTML one: its sections, a search and
/// the chosen recipe with what it makes, what it takes, where it is made, the skill it wants and its worth. The recipes are
/// the module's own: Ratwood's crafting recipes in TG's crafting menu (crafting/rogue_recipes.dm), the anvil's
/// (crafting/forging.dm) and the pottery wheel's (crafting/pottery.dm). Ratwood's alchemy grinding and cauldron recipes,
/// rune rituals and the mage's chapters are not in the port, so the manuals listing them show the rest.
/obj/item/recipe_book
	/// Ratwood types: a type that is a recipe itself shows only itself, any other shows the recipes under it.
	var/list/rogue_recipe_types = list()
	/// Shows the pottery wheel's shapes too (the handbook entries of Ratwood's potter's book).
	var/rogue_wheel_recipes = FALSE

/obj/item/recipe_book/leatherworking
	rogue_recipe_types = list(
		/datum/crafting_recipe/roguetown/tallow,
		/datum/crafting_recipe/roguetown/leather,
	)

/obj/item/recipe_book/sewing
	rogue_recipe_types = list(
		/datum/crafting_recipe/roguetown/survival/cloth,
		/datum/crafting_recipe/roguetown/sewing,
	)

/obj/item/recipe_book/blacksmithing
	rogue_recipe_types = list(/datum/anvil_recipe)

/obj/item/recipe_book/engineering
	rogue_recipe_types = list(/datum/crafting_recipe/roguetown/engineering)

/// Ratwood lists the structures, the turfs and then each turf family again; the families are all under the turfs.
/obj/item/recipe_book/builder
	rogue_recipe_types = list(
		/datum/crafting_recipe/roguetown/structure,
		/datum/crafting_recipe/roguetown/turfs,
	)

/obj/item/recipe_book/ceramics
	rogue_recipe_types = list(
		/datum/crafting_recipe/roguetown/structure/ceramicswheel,
		/datum/crafting_recipe/roguetown/ceramics,
	)
	rogue_wheel_recipes = TRUE

/obj/item/recipe_book/survival
	rogue_recipe_types = list(
		/datum/crafting_recipe/roguetown/survival,
		/datum/crafting_recipe/roguetown/tallow,
	)

/obj/item/recipe_book/alchemy
	rogue_recipe_types = list(
		/datum/crafting_recipe/roguetown/structure/alch,
		/datum/crafting_recipe/roguetown/structure/cauldronalchemy,
		/datum/crafting_recipe/roguetown/survival/mortar,
		/datum/crafting_recipe/roguetown/survival/pestle,
		/datum/crafting_recipe/roguetown/alchemy,
	)

/obj/item/recipe_book/magic
	rogue_recipe_types = list(/datum/crafting_recipe/roguetown/arcana)

/obj/item/recipe_book/examine(mob/user)
	. = ..()
	. += span_info("Use it to read its recipes.")

/obj/item/recipe_book/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RogueRecipeBook", name)
		ui.open()
		playsound(src, ROGUE_BOOK_PAGE_SOUND, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

/obj/item/recipe_book/ui_assets(mob/user)
	. = list(get_asset_datum(/datum/asset/spritesheet_batched/crafting))
	if(rogue_lists_anvil())
		. += get_asset_datum(/datum/asset/spritesheet_batched/rogue_anvil)

/obj/item/recipe_book/ui_static_data(mob/user)
	return list(
		"title" = name,
		"recipes" = rogue_entries(),
	)

/obj/item/recipe_book/proc/rogue_lists_anvil()
	for(var/listed_type in rogue_recipe_types)
		if(ispath(listed_type, /datum/anvil_recipe))
			return TRUE
	return FALSE

/// The manual's recipes for the window (Ratwood generate_html() and each recipe's generate_html()), built once per manual.
/obj/item/recipe_book/proc/rogue_entries()
	var/static/list/entries_by_manual = list()
	if(entries_by_manual[type])
		return entries_by_manual[type]
	// Ratwood's hides_from_books: the anvil's special pieces, made only from relics.
	var/static/list/hidden_recipes = typecacheof(list(
		/datum/anvil_recipe/valuables/anointedberserksword,
		/datum/anvil_recipe/valuables/daemonslayer,
		/datum/anvil_recipe/valuables/dragon,
		/datum/anvil_recipe/valuables/hope,
	))
	var/list/entries = list()
	var/list/listed = list()
	for(var/listed_type in rogue_recipe_types)
		if(ispath(listed_type, /datum/anvil_recipe))
			for(var/datum/anvil_recipe/recipe as anything in GLOB.rogue_anvil_recipes)
				if(!istype(recipe, listed_type) || listed[recipe.type] || hidden_recipes[recipe.type])
					continue
				listed[recipe.type] = TRUE
				entries += list(rogue_anvil_entry(recipe))
			continue
		var/datum/crafting_recipe/roguetown/single = GLOB.crafting_recipes_by_typepath[listed_type] || GLOB.cooking_recipes_by_typepath[listed_type]
		var/list/recipes = single ? list(single) : GLOB.crafting_recipes + GLOB.cooking_recipes
		for(var/datum/crafting_recipe/roguetown/recipe in recipes)
			if(!istype(recipe, listed_type) || listed[recipe.type])
				continue
			listed[recipe.type] = TRUE
			entries += list(rogue_craft_entry(recipe))
	if(rogue_wheel_recipes)
		for(var/datum/pottery_wheel_recipe/recipe as anything in GLOB.rogue_pottery_wheel_recipes)
			entries += list(rogue_wheel_entry(recipe))
	entries_by_manual[type] = entries
	return entries

/// Ratwood /datum/crafting_recipe generate_html(): a recipe of the crafting menu.
/obj/item/recipe_book/proc/rogue_craft_entry(datum/crafting_recipe/roguetown/recipe)
	var/list/made = list(recipe.result)
	if(recipe.rogue_results)
		made += recipe.rogue_results
	var/list/needs = list()
	for(var/path in recipe.reqs)
		needs += rogue_manual_amount(path, recipe.reqs[path])
	var/list/tools = list()
	for(var/behavior in recipe.tool_behaviors)
		tools += "[behavior]"
	for(var/path in recipe.tool_paths)
		tools += rogue_manual_name(path)
	var/list/liquids = list()
	for(var/path in recipe.chem_catalysts)
		liquids += rogue_manual_amount(path, recipe.chem_catalysts[path])
	var/list/place = list()
	if(recipe.rogue_structure)
		place += "at \a [rogue_manual_name(recipe.rogue_structure)]"
	for(var/path in recipe.structures)
		place += "by \a [rogue_manual_name(path)]"
	for(var/path in recipe.machinery)
		place += "by \a [rogue_manual_name(path)]"
	if(recipe.rogue_on_table)
		place += "on a table"
	if(recipe.rogue_on_wall)
		place += "against a wall"
	var/atom/result = recipe.result
	return rogue_manual_entry(
		recipe.type,
		recipe.name,
		recipe.category,
		rogue_crafting_icon(recipe.result),
		recipe.desc || (ispath(result, /atom) ? initial(result.desc) : null),
		rogue_manual_counted(made),
		recipe.rogue_skill,
		recipe.rogue_difficulty,
		needs,
		tools,
		liquids,
		place,
		rogue_manual_price(recipe.result),
	)

/// Ratwood /datum/anvil_recipe generate_html(): a recipe of the anvil.
/obj/item/recipe_book/proc/rogue_anvil_entry(datum/anvil_recipe/recipe)
	var/list/made = list()
	for(var/count in 1 to recipe.createditem_num)
		made += recipe.created_item
	// Ratwood: start with the bar on an anvil, hammer it, then add each material and hammer again.
	var/list/starts = list()
	if(recipe.req_bar)
		starts += rogue_manual_name(recipe.req_bar)
	if(recipe.req_blade)
		starts += rogue_manual_name(recipe.req_blade)
	var/list/needs = list("start with [jointext(starts, " or ")]")
	for(var/path in recipe.additional_items)
		needs += "then add [rogue_manual_name(path)]"
	var/obj/item/created = recipe.created_item
	return rogue_manual_entry(
		recipe.type,
		recipe.name,
		recipe.category,
		"rogue_anvil32x32 [sanitize_css_class_name("[created]")]",
		initial(created.desc),
		rogue_manual_counted(made),
		recipe.appro_skill,
		recipe.craftdiff,
		needs,
		list("a hammer"),
		list(),
		list("on an anvil"),
		rogue_manual_price(created),
	)

/// Ratwood's potter's handbook entries: a shape of the pottery wheel.
/obj/item/recipe_book/proc/rogue_wheel_entry(datum/pottery_wheel_recipe/recipe)
	var/list/made = list()
	for(var/count in 1 to recipe.result_count)
		made += recipe.result_type
	var/obj/item/result = recipe.result_type
	return rogue_manual_entry(
		recipe.type,
		recipe.name,
		"Pottery Wheel",
		rogue_crafting_icon(result),
		initial(result.desc),
		rogue_manual_counted(made),
		/datum/attribute/skill/craft/ceramics,
		recipe.craftdiff,
		list(rogue_manual_name(recipe.required_clay_type), "a little water"),
		list(),
		list(),
		list("on a potter's wheel"),
		rogue_manual_price(result),
	)

/// One recipe of the window. skill_type and rank give the skill line (Ratwood: "For those of ... skills").
/obj/item/recipe_book/proc/rogue_manual_entry(recipe_type, recipe_name, category, icon_class, recipe_desc, list/made, skill_type, rank, list/needs, list/tools, list/liquids, list/place, price)
	var/datum/attribute/skill/skill = skill_type ? GET_ROGUE_ATTRIBUTE(skill_type) : null
	return list(
		"id" = "[recipe_type]",
		"name" = recipe_name,
		"category" = category || "Other",
		"icon" = icon_class,
		"desc" = recipe_desc,
		"makes" = made,
		"skill" = skill?.name,
		"level" = (skill && rank > 0) ? skill.description_from_level(rank * ROGUE_SKILL_PER_RANK) : null,
		"needs" = needs,
		"tools" = tools,
		"liquids" = liquids,
		"place" = place,
		"price" = price,
	)

/// TG's crafting sprite sheet class of a recipe's result, as the crafting menu shows it; null for a result it lacks.
/proc/rogue_crafting_icon(result_type)
	var/static/list/atom_ids
	if(!atom_ids)
		atom_ids = list()
		for(var/index in 1 to length(GLOB.crafting_recipes_datums))
			atom_ids[GLOB.crafting_recipes_datums[index]] = index
	var/atom_id = atom_ids[result_type]
	if(!atom_id)
		return null
	var/datum/asset/spritesheet_batched/sheet = get_asset_datum(/datum/asset/spritesheet_batched/crafting)
	return "[sheet.icon_size_id("a[atom_id]") || "crafting32x32"] a[atom_id]"

/proc/rogue_manual_name(path)
	if(ispath(path, /datum/reagent))
		var/datum/reagent/reagent = path
		return initial(reagent.name)
	if(ispath(path, /atom))
		var/atom/thing = path
		return initial(thing.name)
	return "[path]"

/// "2 iron dust", "10 units of water".
/proc/rogue_manual_amount(path, amount)
	if(ispath(path, /datum/reagent))
		return "[amount] units of [rogue_manual_name(path)]"
	return amount == 1 ? rogue_manual_name(path) : "[amount] [rogue_manual_name(path)]"

/// Things by name with their counts: "2 clay brick", "bronze bar".
/proc/rogue_manual_counted(list/paths)
	var/list/counts = list()
	for(var/path in paths)
		if(path)
			counts[rogue_manual_name(path)] += 1
	. = list()
	for(var/thing_name in counts)
		. += counts[thing_name] > 1 ? "[counts[thing_name]] [thing_name]" : thing_name

/// What a result sells for at normal quality (Ratwood sellprice); 0 when it is worthless for export.
/proc/rogue_manual_price(path)
	if(!ispath(path, /atom/movable))
		return 0
	var/atom/movable/thing = path
	return initial(thing.sellprice)
