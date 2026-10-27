/// Vibelin's chat dictionary (localization/code/chat/chat_asset.dm): the strings files turned into one JSON asset that the
/// chat panel fetches and applies to every message it receives, so the server keeps sending English and pays nothing.
/// It goes through SSassets like any browser asset, so it works with the BYOND transport and a CDN webroot alike.
/// descriptions.txt, traits.txt and the chargen files are not in it: their keys are types and they resolve on the server.

/// Noun cases in the order a strings line lists them.
GLOBAL_LIST_INIT(rogue_noun_cases, list("nom", "gen", "dat", "acc", "ins", "pre"))

/datum/asset/json/rogue_chat_localization
	name = "rogue_chat_localization"

/datum/asset/json/rogue_chat_localization/generate()
	// items.txt first so nouns.txt wins a collision: it is the closed set of body parts parse_zone() returns, and
	// "chest" is a body part far more often than a container. The module_*.txt files are the module's own lines,
	// kept apart from the copies of Vibelin's files.
	var/list/nouns = rogue_strings_nouns("items.txt")
	nouns |= rogue_strings_nouns("module_items.txt")
	nouns |= rogue_strings_nouns("nouns.txt")
	nouns |= rogue_strings_nouns("module_nouns.txt")
	// Names of roles, classes, migrant waves and calendar events (titles.dm): declined where a pattern asks for a case.
	nouns |= rogue_strings_nouns("module_titles.txt")
	var/list/fragments = rogue_strings_table("fragments.txt")
	for(var/filename in list("speech.txt", "medical.txt", "world.txt", "status.txt", "module_fragments.txt"))
		fragments |= rogue_strings_table(filename)
	var/list/patterns = list()
	// The module's patterns first: they are narrower than Vibelin's general ones.
	for(var/filename in list("module_patterns.txt", "patterns.txt"))
		for(var/list/pair as anything in rogue_strings_pairs(filename))
			patterns += list(list("re" = pair[1], "ru" = pair[2]))
	return list(
		"version" = 1,
		"nouns" = nouns,
		// Apart from nouns on purpose: the panel may split a captured name on these and on nothing else.
		"honorifics" = rogue_strings_nouns("honorifics.txt"),
		"fragments" = fragments,
		// In file order: the first pattern that matches wins.
		"patterns" = patterns,
	)

/// A strings file as list(key, value) pairs, comments and blank lines left out. A missing file or a bad line is reported
/// and skipped, so a broken translation never stops the round from starting.
/proc/rogue_strings_pairs(filename)
	. = list()
	var/path = "[ROGUE_LOCALIZATION_STRINGS]/[filename]"
	if(!fexists(path))
		stack_trace("Localization: missing strings file [path]")
		return
	var/line_number = 0
	for(var/raw_line in splittext(file2text(path), "\n"))
		line_number++
		var/line = trim(raw_line)
		if(!length(line) || copytext(line, 1, 2) == "#")
			continue
		var/split_at = findtext(line, ROGUE_LOCALIZATION_SEPARATOR)
		if(!split_at)
			stack_trace("Localization: [filename]:[line_number] has no \"[ROGUE_LOCALIZATION_SEPARATOR]\", skipped")
			continue
		var/key = trim(copytext(line, 1, split_at))
		var/value = trim(copytext(line, split_at + length(ROGUE_LOCALIZATION_SEPARATOR)))
		if(!length(key) || !length(value))
			continue
		// The format's only escape: a line break, which a line-based record cannot hold.
		. += list(list(replacetext(key, "\\n", "\n"), replacetext(value, "\\n", "\n")))

/proc/rogue_strings_table(filename)
	. = list()
	for(var/list/pair as anything in rogue_strings_pairs(filename))
		.[pair[1]] = pair[2]

/// Nouns: "key = nom|gen|dat|acc|ins|pre", an empty form left out.
/proc/rogue_strings_nouns(filename)
	. = list()
	var/expected = length(GLOB.rogue_noun_cases)
	for(var/list/pair as anything in rogue_strings_pairs(filename))
		var/list/forms = splittext(pair[2], "|")
		if(length(forms) != expected)
			stack_trace("Localization: [filename] \"[pair[1]]\" lists [length(forms)] forms, expected [expected]")
			continue
		var/list/cases = list()
		for(var/index in 1 to expected)
			var/form = trim(forms[index])
			if(length(form))
				cases[GLOB.rogue_noun_cases[index]] = form
		if(length(cases))
			.[pair[1]] = cases
