/// Descriptions in Russian (Vibelin's descriptions.dm): keyed by type rather than by the English text, so a reworded
/// English desc never silently loses its translation, and resolved on the server for the player who examines.
/// strings/descriptions.txt holds Vibelin's entries (Vanderlin's types) and the ones the module's generator found for
/// this build's types; a type this build does not have is dropped without a word.

/// Russian descriptions by type, read on the first examine.
GLOBAL_LIST(rogue_examine_descriptions)

/proc/rogue_examine_description(type)
	if(isnull(GLOB.rogue_examine_descriptions))
		GLOB.rogue_examine_descriptions = list()
		for(var/list/pair as anything in rogue_strings_pairs("descriptions.txt"))
			var/path = text2path(pair[1])
			if(path)
				GLOB.rogue_examine_descriptions[path] = pair[2]
	return GLOB.rogue_examine_descriptions[type]

/// TG puts the description in as "<i>[desc]</i>"; a Russian player gets its translation in its place, unless the desc
/// was changed in the round (an engraving, a label), which only the English can say.
/atom/examine(mob/user)
	. = ..()
	if(!desc || desc != initial(desc) || !rogue_ui_russian(user?.client))
		return
	var/russian = rogue_examine_description(type)
	if(!russian)
		return
	var/list/lines = .
	var/index = lines.Find("<i>[desc]</i>")
	if(index)
		lines[index] = "<i>[russian]</i>"
