/// Rows of one page of the panel. The interface holds only the page it shows: the registry is thousands of values, and
/// every one of them sent and drawn at once is what made the window unusable.
#define ROGUE_MECHANICS_PANEL_PAGE 40
/// A first word that leads more ids of a group than this is split into prefixes of two words.
#define ROGUE_MECHANICS_PANEL_SPLIT 80
/// Groups of the panel that are not a value file: the formulas, and every formula and value at once (for a search).
#define ROGUE_MECHANICS_PANEL_FORMULAS "formulas"
#define ROGUE_MECHANICS_PANEL_ALL "all"
/// Longest search text or prefix the panel takes from a client.
#define ROGUE_MECHANICS_PANEL_TEXT_MAX 64

ADMIN_VERB(rogue_mechanics_panel, R_DEBUG, "Rogue Mechanics", "Formulas and numbers read from config/redtard_private/mechanics, then config/redtard/mechanics.", ADMIN_CATEGORY_ROGUE)
	var/datum/rogue_mechanics_panel/panel = new
	panel.ui_interact(user.mob)
	BLACKBOX_LOG_ADMIN_VERB("Rogue Mechanics")

ADMIN_VERB(rogue_armor_compare, R_DEBUG, "View Armor Comparison", "Browse and compare every rogue armor datum.", ADMIN_CATEGORY_ROGUE)
	var/datum/rogue_armor_compare/menu = new
	menu.ui_interact(user.mob)
	BLACKBOX_LOG_ADMIN_VERB("View Armor Comparison")

/// One admin's window on the registry. It lists one group at a time (the formulas or one value file), narrowed by a
/// prefix, a search and "changed only", a page at a time; the window is sent again only when the admin acts.
/datum/rogue_mechanics_panel
	/// What is listed: ROGUE_MECHANICS_PANEL_FORMULAS, ROGUE_MECHANICS_PANEL_ALL or the name of a value file.
	var/group = ROGUE_MECHANICS_PANEL_FORMULAS
	/// Narrows the group to the ids that start with this word (the part before the first underscore); "" for none.
	var/prefix = ""
	/// Narrows it to the entries whose id or description holds this text; "" for none.
	var/search = ""
	/// Lists only the entries changed from their default (or failing to compile).
	var/changed_only = FALSE
	/// Page of the narrowed list, from 1.
	var/page = 1

/datum/rogue_mechanics_panel/ui_state(mob/user)
	return ADMIN_STATE(R_DEBUG)

/datum/rogue_mechanics_panel/ui_close(mob/user)
	qdel(src)

/datum/rogue_mechanics_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RogueMechanics", "Rogue Mechanics")
		// The registry changes only when an admin acts or reloads it: there is nothing to push between actions.
		ui.set_autoupdate(FALSE)
		ui.open()

/// Group of the panel a formula or a value belongs to.
/datum/rogue_mechanics_panel/proc/group_of(datum/rogue_formula/formula)
	if(!formula.is_value)
		return ROGUE_MECHANICS_PANEL_FORMULAS
	return formula.source_file || ROGUE_MECHANICS_TYPE_VALUES_FILE

/// The first words of an id, up to its words-th underscore: the sub-group of a value file.
/datum/rogue_mechanics_panel/proc/prefix_of(id, words = 1)
	var/split_at = 0
	for(var/word in 1 to words)
		split_at = findtext(id, "_", split_at + 1)
		if(!split_at)
			return id
	return copytext(id, 1, split_at)

/// A search text or a prefix from the client, cut to size; "" for anything that is not text.
/datum/rogue_mechanics_panel/proc/panel_text(value)
	if(!istext(value))
		return ""
	return LOWER_TEXT(trim(copytext_char(value, 1, ROGUE_MECHANICS_PANEL_TEXT_MAX + 1)))

/// What does not change while the window is open: the groups with their sizes and the tables. The ids are compiled into the
/// build, so a reload changes only the tables; ui_act() sends this again after one.
/datum/rogue_mechanics_panel/ui_static_data(mob/user)
	var/datum/rogue_mechanics/mechanics = rogue_mechanics()
	var/list/counts = list()
	for(var/id in mechanics.formulas)
		counts[group_of(mechanics.formulas[id])] += 1
	var/list/group_data = list(
		list("id" = ROGUE_MECHANICS_PANEL_FORMULAS, "name" = "Formulas", "entries" = counts[ROGUE_MECHANICS_PANEL_FORMULAS] || 0),
		list("id" = ROGUE_MECHANICS_PANEL_ALL, "name" = "Everything", "entries" = length(mechanics.formulas)),
	)
	for(var/file_name in rogue_value_files())
		group_data += list(list("id" = file_name, "name" = replacetext(file_name, ".txt", ""), "entries" = counts[file_name] || 0))
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
		"groups" = group_data,
		"categories" = category_data,
	)

/// One page of the listed group. Runs only when the admin acts (autoupdate is off), so a pass over the registry is cheap.
/datum/rogue_mechanics_panel/ui_data(mob/user)
	var/datum/rogue_mechanics/mechanics = rogue_mechanics()
	var/everything = group == ROGUE_MECHANICS_PANEL_ALL
	// Ids of the listed group and how many of them each first word leads. "Everything" has hundreds of prefixes and gets none.
	var/list/group_ids = mechanics.formulas
	var/list/word_counts = list()
	if(!everything)
		group_ids = list()
		for(var/id in mechanics.formulas)
			if(group_of(mechanics.formulas[id]) != group)
				continue
			group_ids += id
			word_counts[prefix_of(id)] += 1
	// Prefixes of the whole group, in the order of its file. A first word that leads more ids than ROGUE_MECHANICS_PANEL_SPLIT
	// (all of injuries.txt starts with "injury") is split by the second word.
	var/list/prefix_counts = list()
	var/list/matched = list()
	for(var/id in group_ids)
		var/datum/rogue_formula/formula = mechanics.formulas[id]
		if(!everything)
			var/own_prefix = prefix_of(id)
			if(word_counts[own_prefix] > ROGUE_MECHANICS_PANEL_SPLIT)
				own_prefix = prefix_of(id, 2)
			prefix_counts[own_prefix] += 1
			if(length(prefix) && own_prefix != prefix)
				continue
		if(changed_only && formula.text == formula.default_text && !formula.error)
			continue
		if(length(search) && !findtext(id, search) && !findtext(formula.desc, search))
			continue
		matched += id
	var/pages = max(1, CEILING(length(matched) / ROGUE_MECHANICS_PANEL_PAGE, 1))
	page = clamp(page, 1, pages)
	var/list/entry_data = list()
	var/first = (page - 1) * ROGUE_MECHANICS_PANEL_PAGE + 1
	for(var/index in first to min(length(matched), first + ROGUE_MECHANICS_PANEL_PAGE - 1))
		var/datum/rogue_formula/formula = mechanics.formulas[matched[index]]
		entry_data += list(list(
			"id" = formula.id,
			"desc" = formula.desc,
			"text" = formula.text,
			"default" = formula.default_text,
			// A value has no inputs (known_inputs is null); the panel maps over the list for every entry.
			"inputs" = formula.known_inputs || list(),
			"error" = formula.error,
			"value" = formula.is_value,
			"group" = group_of(formula),
		))
	var/list/prefix_data = list()
	for(var/name in prefix_counts)
		prefix_data += list(list("name" = name, "entries" = prefix_counts[name]))
	return list(
		"loaded_ago" = DisplayTimeText(world.time - mechanics.loaded_at),
		"problems" = mechanics.problems,
		"can_save" = check_rights_for(user.client, R_SERVER),
		"group" = group,
		"prefix" = prefix,
		"search" = search,
		"changed_only" = changed_only,
		"page" = page,
		"pages" = pages,
		"matched" = length(matched),
		"prefixes" = prefix_data,
		"entries" = entry_data,
	)

/datum/rogue_mechanics_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = ui.user
	var/datum/rogue_mechanics/mechanics = rogue_mechanics()
	switch(action)
		if("select_group")
			var/new_group = params["id"]
			if(new_group != ROGUE_MECHANICS_PANEL_FORMULAS && new_group != ROGUE_MECHANICS_PANEL_ALL && !(new_group in rogue_value_files()))
				return
			group = new_group
			prefix = ""
			page = 1
			return TRUE
		if("set_prefix")
			prefix = panel_text(params["prefix"])
			page = 1
			return TRUE
		if("set_search")
			search = panel_text(params["text"])
			page = 1
			return TRUE
		if("toggle_changed")
			changed_only = !changed_only
			page = 1
			return TRUE
		if("set_page")
			var/new_page = text2num("[params["page"]]")
			if(!isnum(new_page))
				return
			// ui_data() clamps it to the pages there are.
			page = max(1, round(new_page))
			return TRUE
		if("refresh")
			return TRUE
		if("reload")
			var/changed = mechanics.reload()
			message_admins("[key_name_admin(user)] reloaded the rogue mechanics config ([changed] items updated, [length(mechanics.problems)] problems).")
			log_admin("[key_name(user)] reloaded the rogue mechanics config.")
			// The tables are read anew: their sizes are static data.
			update_static_data(user, ui)
			return TRUE
		if("export")
			var/list/written = mechanics.export(ROGUE_MECHANICS_EXPORT_DIR)
			to_chat(user, span_notice("Wrote [jointext(written, ", ")] to [ROGUE_MECHANICS_EXPORT_DIR]."))
			log_admin("[key_name(user)] exported the rogue mechanics values.")
			// Nothing of the window changed: no push.
			return
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
			mechanics.revision++
			message_admins("[key_name_admin(user)] set the rogue formula [formula.id] to: [formula.text]")
			log_admin("[key_name(user)] set the rogue formula [formula.id] from [old_text] to [formula.text]")
			return TRUE
		if("reset_formula")
			var/datum/rogue_formula/formula = mechanics.formulas[params["id"]]
			if(!formula)
				return
			formula.reset()
			mechanics.revision++
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
			return
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
			return

#undef ROGUE_MECHANICS_PANEL_PAGE
#undef ROGUE_MECHANICS_PANEL_SPLIT
#undef ROGUE_MECHANICS_PANEL_FORMULAS
#undef ROGUE_MECHANICS_PANEL_ALL
#undef ROGUE_MECHANICS_PANEL_TEXT_MAX
