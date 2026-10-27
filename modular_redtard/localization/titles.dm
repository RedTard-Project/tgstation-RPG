/// Names of Rockhill's roles, classes, migrant waves and migrant roles and calendar events in Russian
/// (strings/module_titles.txt, six cases by the English name). The chat panel declines them like nouns, since the file
/// is in its dictionary (dictionary.dm); the windows that list them get them in the reader's language here, after the
/// window's own data is built, so the keys the window acts on (types, refs) are left as they are.

/// Title -> its cases, read on first use.
GLOBAL_LIST(rogue_titles)

/// A title in Russian in a case, or the English when the file has none.
/proc/rogue_title(english, case_key = "nom")
	if(!length(english))
		return english
	if(isnull(GLOB.rogue_titles))
		GLOB.rogue_titles = rogue_strings_nouns("module_titles.txt")
	var/list/cases = GLOB.rogue_titles[english]
	return cases?[case_key] || english

/// The class choice (rockhill/advclasses.dm): the role's title and the classes' names.
/datum/rockhill_class_select/ui_data(mob/user)
	. = ..()
	if(!user?.client || !rogue_ui_russian(user.client))
		return
	var/list/data = .
	data["job"] = rogue_title(data["job"])
	for(var/list/advclass as anything in data["classes"])
		advclass["name"] = rogue_title(advclass["name"])

/// The migrant panel (migrants/migrants.dm): the waves, their roles and the roles' classes.
/datum/rogue_migrant_pref/ui_data(mob/user)
	. = ..()
	if(!user?.client || !rogue_ui_russian(user.client))
		return
	var/list/data = .
	for(var/key in list("forming", "waves"))
		for(var/list/wave as anything in data[key])
			wave["name"] = rogue_title(wave["name"])
			for(var/list/role as anything in wave["roles"])
				role["name"] = rogue_title(role["name"])
				var/list/classes = role["classes"]
				for(var/index in 1 to length(classes))
					classes[index] = rogue_title(classes[index])

/// The calendar (rockhill/calendar.dm): the names of the month's events.
/datum/rockhill_calendar_ui/ui_data(mob/user)
	. = ..()
	if(!user?.client || !rogue_ui_russian(user.client))
		return
	var/list/data = .
	for(var/list/event as anything in data["events"])
		event["title"] = rogue_title(event["title"])
