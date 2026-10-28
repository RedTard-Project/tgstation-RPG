ADMIN_VERB(rogue_mechanics_panel, R_DEBUG, "Rogue Mechanics", "Formulas and numbers read from config/redtard_private/mechanics, then config/redtard/mechanics.", ADMIN_CATEGORY_ROGUE)
	var/datum/rogue_mechanics_panel/panel = new
	panel.ui_interact(user.mob)
	BLACKBOX_LOG_ADMIN_VERB("Rogue Mechanics")

ADMIN_VERB(rogue_armor_compare, R_DEBUG, "View Armor Comparison", "Browse and compare every rogue armor datum.", ADMIN_CATEGORY_ROGUE)
	var/datum/rogue_armor_compare/menu = new
	menu.ui_interact(user.mob)
	BLACKBOX_LOG_ADMIN_VERB("View Armor Comparison")

/datum/rogue_mechanics_panel

/datum/rogue_mechanics_panel/ui_state(mob/user)
	return ADMIN_STATE(R_DEBUG)

/datum/rogue_mechanics_panel/ui_close(mob/user)
	qdel(src)

/datum/rogue_mechanics_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RogueMechanics", "Rogue Mechanics")
		ui.open()

/datum/rogue_mechanics_panel/ui_data(mob/user)
	var/datum/rogue_mechanics/mechanics = rogue_mechanics()
	var/list/formula_data = list()
	for(var/id in mechanics.formulas)
		var/datum/rogue_formula/formula = mechanics.formulas[id]
		formula_data += list(list(
			"id" = id,
			"desc" = formula.desc,
			"text" = formula.text,
			"default" = formula.default_text,
			"inputs" = formula.known_inputs,
			"error" = formula.error,
			"value" = formula.is_value,
		))
	var/list/category_data = list()
	for(var/name in mechanics.categories)
		var/datum/rogue_mechanics_category/category = mechanics.categories[name]
		var/list/table = mechanics.tables[name]
		var/list/field_names = list()
		for(var/field in category.fields)
			field_names += field
		category_data += list(list(
			"name" = name,
			"file" = category.file,
			"desc" = category.desc,
			"entries" = length(table),
			"fields" = field_names,
		))
	return list(
		"directory" = mechanics.has_private_directory() ? "[mechanics.private_directory()] (then [mechanics.directory()])" : mechanics.directory(),
		"export_directory" = ROGUE_MECHANICS_EXPORT_DIR,
		"loaded_ago" = DisplayTimeText(world.time - mechanics.loaded_at),
		"problems" = mechanics.problems,
		"formulas" = formula_data,
		"categories" = category_data,
		"can_save" = check_rights_for(user.client, R_SERVER),
	)

/datum/rogue_mechanics_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = ui.user
	var/datum/rogue_mechanics/mechanics = rogue_mechanics()
	switch(action)
		if("reload")
			var/changed = mechanics.reload()
			message_admins("[key_name_admin(user)] reloaded the rogue mechanics config ([changed] items updated, [length(mechanics.problems)] problems).")
			log_admin("[key_name(user)] reloaded the rogue mechanics config.")
			return TRUE
		if("export")
			var/list/written = mechanics.export(ROGUE_MECHANICS_EXPORT_DIR)
			to_chat(user, span_notice("Wrote [jointext(written, ", ")] to [ROGUE_MECHANICS_EXPORT_DIR]."))
			log_admin("[key_name(user)] exported the rogue mechanics values.")
			return TRUE
		if("set_formula")
			var/datum/rogue_formula/formula = mechanics.formulas[params["id"]]
			if(!formula)
				return
			var/old_text = formula.text
			var/failure = formula.set_text("[params["text"]]")
			if(failure)
				formula.error = failure
				to_chat(user, span_warning("[formula.id] did not change: [failure]"))
				return TRUE
			message_admins("[key_name_admin(user)] set the rogue formula [formula.id] to: [formula.text]")
			log_admin("[key_name(user)] set the rogue formula [formula.id] from [old_text] to [formula.text]")
			return TRUE
		if("reset_formula")
			var/datum/rogue_formula/formula = mechanics.formulas[params["id"]]
			if(!formula)
				return
			formula.reset()
			log_admin("[key_name(user)] reset the rogue formula [formula.id].")
			return TRUE
		if("try_formula")
			var/datum/rogue_formula/formula = mechanics.formulas[params["id"]]
			var/list/values = params["values"]
			if(!formula || !islist(values))
				return
			var/list/numbers = list()
			for(var/name in values)
				numbers[name] = text2num("[values[name]]") || 0
			to_chat(user, span_notice("[formula.id] = [formula.evaluate(numbers)] for [json_encode(numbers)]"))
			return TRUE
		if("save_formulas")
			if(!check_rights(R_SERVER))
				return
			var/stamp = "# Saved from the Rogue Mechanics panel by [user.ckey] at [time2text(world.realtime, "YYYY-MM-DD hh:mm")]."
			var/save_to = mechanics.save_path(ROGUE_MECHANICS_FORMULAS_FILE)
			rustg_file_write(jointext(mechanics.formula_lines(FALSE, stamp), "\n"), save_to)
			for(var/file_name in rogue_value_files())
				rustg_file_write(jointext(mechanics.formula_lines(TRUE, stamp, file_name), "\n"), mechanics.save_path("[ROGUE_MECHANICS_VALUES_DIR]/[file_name]"))
			var/values_to = mechanics.save_path(ROGUE_MECHANICS_VALUES_DIR)
			message_admins("[key_name_admin(user)] saved the rogue formulas to [save_to] and the values to [values_to].")
			log_admin("[key_name(user)] saved the rogue formulas to the config.")
			return TRUE
		if("armor_compare")
			var/datum/rogue_armor_compare/menu = new
			menu.ui_interact(user)
			return TRUE
