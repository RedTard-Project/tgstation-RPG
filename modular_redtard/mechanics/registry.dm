GLOBAL_DATUM(rogue_mechanics, /datum/rogue_mechanics)

/proc/rogue_mechanics()
	if(!GLOB.rogue_mechanics)
		GLOB.rogue_mechanics = new
	return GLOB.rogue_mechanics

/proc/rogue_formula_value(id, list/values)
	var/datum/rogue_formula/formula = rogue_mechanics().formulas[id]
	if(!formula)
		CRASH("Unknown rogue formula [id]")
	return formula.evaluate(values)

/datum/rogue_mechanics
	var/list/categories = list()
	var/list/tables = list()
	var/list/formulas = list()
	var/list/problems = list()
	var/loaded_at

/datum/rogue_mechanics/New()
	for(var/category_type in subtypesof(/datum/rogue_mechanics_category))
		var/datum/rogue_mechanics_category/category = new category_type
		categories[category.name] = category
	for(var/id in GLOB.rogue_formula_definitions)
		var/list/definition = GLOB.rogue_formula_definitions[id]
		formulas[id] = new /datum/rogue_formula(id, definition[1], definition[2], definition[3])
	load()

/datum/rogue_mechanics/proc/directory()
	return "[config?.directory || "config"]/[ROGUE_MECHANICS_SUBDIR]"

/datum/rogue_mechanics/proc/load()
	problems = list()
	tables = list()
	for(var/name in categories)
		var/datum/rogue_mechanics_category/category = categories[name]
		tables[name] = read_category(category)
	read_formulas()
	loaded_at = world.time
	for(var/problem in problems)
		log_config("Rogue mechanics: [problem]")

/datum/rogue_mechanics/proc/read_lines(file_name)
	var/path = "[directory()]/[file_name]"
	if(!fexists(path))
		return null
	return splittext(replacetext(file2text(path), ascii2text(ROGUE_MECHANICS_CARRIAGE_RETURN), ""), "\n")

/datum/rogue_mechanics/proc/read_category(datum/rogue_mechanics_category/category)
	var/list/table = list()
	var/list/lines = read_lines(category.file)
	if(isnull(lines))
		return table
	var/list/current
	var/current_id
	for(var/line_number in 1 to length(lines))
		var/line = trim(lines[line_number])
		if(!length(line) || line[1] == ROGUE_MECHANICS_COMMENT)
			continue
		var/where = "[category.file]:[line_number]"
		if(line[1] == "\[")
			current = null
			current_id = trim(copytext(line, 2, findtext(line, "]")))
			var/path = category.path_of(current_id)
			if(!path)
				problems += "[where]: no [category.root]/[current_id]"
				continue
			current = table[path]
			if(!current)
				current = list()
				table[path] = current
			continue
		var/split_at = findtext(line, "=")
		if(!split_at)
			problems += "[where]: expected \"field = value\""
			continue
		if(isnull(current))
			continue
		var/field = lowertext(trim(copytext(line, 1, split_at)))
		var/list/spec = category.fields[field]
		if(!spec)
			problems += "[where]: [current_id] has no field \"[field]\" (fields: [jointext(category.fields, ", ")])"
			continue
		var/parsed = rogue_mechanics_parse(trim(copytext(line, split_at + 1)), spec[ROGUE_FIELD_KIND])
		if(istext(parsed))
			problems += "[where]: [current_id].[field]: [parsed]"
			continue
		var/list/wrapped = parsed
		current[field] = wrapped[1]
	return table

/datum/rogue_mechanics/proc/read_formulas()
	for(var/id in formulas)
		var/datum/rogue_formula/formula = formulas[id]
		formula.reset()
	var/list/lines = read_lines(ROGUE_MECHANICS_FORMULAS_FILE)
	if(isnull(lines))
		return
	for(var/line_number in 1 to length(lines))
		var/line = trim(lines[line_number])
		if(!length(line) || line[1] == ROGUE_MECHANICS_COMMENT)
			continue
		var/where = "[ROGUE_MECHANICS_FORMULAS_FILE]:[line_number]"
		var/split_at = findtext(line, "=")
		if(!split_at)
			problems += "[where]: expected \"name = expression\""
			continue
		var/id = lowertext(trim(copytext(line, 1, split_at)))
		var/datum/rogue_formula/formula = formulas[id]
		if(!formula)
			problems += "[where]: no formula \"[id]\" (formulas: [jointext(formulas, ", ")])"
			continue
		var/failure = formula.set_text(trim(copytext(line, split_at + 1)))
		if(failure)
			formula.error = failure
			problems += "[where]: [id] kept its default: [failure]"

/datum/rogue_mechanics/proc/values_for(category_name, path)
	var/list/table = tables[category_name]
	return table ? table[path] : null

/datum/rogue_mechanics/proc/apply_to(category_name, datum/target)
	var/list/values = values_for(category_name, target.type)
	if(!values)
		return
	var/datum/rogue_mechanics_category/category = categories[category_name]
	category.apply(target, values)

/datum/rogue_mechanics/proc/reload()
	load()
	for(var/path in GLOB.rogue_armor_cache)
		apply_to("armor", GLOB.rogue_armor_cache[path])
	for(var/path in GLOB.rogue_intents)
		apply_to("intents", GLOB.rogue_intents[path])
	var/list/item_table = tables["items"]
	var/changed = 0
	if(length(item_table))
		for(var/obj/item/thing in world)
			if(item_table[thing.type])
				apply_to("items", thing)
				changed++
			CHECK_TICK
	return changed

/datum/rogue_mechanics/proc/export(target_directory)
	var/list/written = list()
	for(var/name in categories)
		var/datum/rogue_mechanics_category/category = categories[name]
		var/list/lines = list("# [category.desc]", "# Fields: [jointext(category.fields, ", ")]", "")
		for(var/path in category.exported_types())
			var/datum/sample = rogue_mechanics_is_item_path(path) ? new path(null) : new path
			lines += "\[[category.id_of(path)]\]"
			for(var/field in category.fields)
				if(category.has_field(sample, field))
					lines += "[field] = [category.field_text(sample, field)]"
			lines += ""
			qdel(sample)
			CHECK_TICK
		rustg_file_write(jointext(lines, "\n"), "[target_directory]/[category.file]")
		written += category.file
	var/list/formula_lines = list("# Formulas: name = expression. Functions: [jointext(GLOB.rogue_formula_functions, ", ")]. Operators: + - * / % ^ < <= > >= == != and or not.", "")
	for(var/id in formulas)
		var/datum/rogue_formula/formula = formulas[id]
		formula_lines += "# [formula.desc] Inputs: [jointext(formula.known_inputs, ", ")]."
		formula_lines += "[id] = [formula.text]"
		formula_lines += ""
	rustg_file_write(jointext(formula_lines, "\n"), "[target_directory]/[ROGUE_MECHANICS_FORMULAS_FILE]")
	written += ROGUE_MECHANICS_FORMULAS_FILE
	return written

/proc/rogue_mechanics_is_item_path(path)
	return ispath(path, /obj/item)
