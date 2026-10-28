#ifdef UNIT_TESTS
// The same text as code/modules/unit_tests/_unit_tests.dm, which undefines it after its own files.
#define TEST_ASSERT_EQUAL(a, b, message) do { \
	var/lhs = ##a; \
	var/rhs = ##b; \
	if (lhs != rhs) { \
		return Fail("Expected [isnull(lhs) ? "null" : lhs] to be equal to [isnull(rhs) ? "null" : rhs].[message ? " [message]" : ""]", __FILE__, __LINE__); \
	} \
} while (FALSE)

/// The translation's strings against this build (Vibelin's modular_chargen_sheet and modular_trait_sheet in
/// modular_abel/tests/_tests.dm, plus the module's own files of the server's engine, translate.dm). A key that can
/// never be found fails; a line Vibelin has for content this build has not ported yet is only noted.

/// Capturing groups of a pattern, so a template cannot ask for a $N its pattern never captures.
/proc/rogue_count_capture_groups(pattern)
	var/groups = 0
	var/total = length_char(pattern)
	var/position = 1
	while(position <= total)
		var/char = copytext_char(pattern, position, position + 1)
		if(char == "\\")
			position += 2
			continue
		if(char == "(" && copytext_char(pattern, position + 1, position + 2) != "?")
			groups++
		position++
	return groups

/// chargen.txt: every key is a species, faith, patron or culture of this build, a field is one the patron card shows
/// and only on a patron, a name line has its " | ".
/datum/unit_test/rogue_chargen_sheet

/datum/unit_test/rogue_chargen_sheet/Run()
	var/list/pairs = rogue_strings_pairs("chargen.txt")
	if(!length(pairs))
		TEST_FAIL("chargen.txt produced no entries; the file is missing or every line was skipped")
		return
	var/list/unported = list()
	for(var/list/pair as anything in pairs)
		var/key = pair[1]
		var/field_at = findtext(key, ":")
		var/path_text = field_at ? copytext(key, 1, field_at) : key
		var/path = rogue_chargen_path(path_text)
		if(!ispath(path))
			if(findtext(path_text, "/datum/species/") == 1)
				unported |= path_text
			else
				TEST_FAIL("\"[path_text]\" is not a type; the line is dead and the menu keeps its English")
			continue
		if(!ispath(path, /datum/species) && !ispath(path, /datum/faith) && !ispath(path, /datum/patron) && !ispath(path, /datum/culture))
			TEST_FAIL("[path] is not a species, faith, patron or culture, so the menu never looks it up")
			continue
		if(field_at)
			var/field = copytext(key, field_at + 1)
			if(!(field in GLOB.rogue_chargen_patron_fields))
				TEST_FAIL("\"[key]\" uses the field \"[field]\", which the patron card does not show")
			else if(!ispath(path, /datum/patron))
				TEST_FAIL("\"[key]\" sets a patron field on [path], which is not a patron")
			continue
		if(!findtext(pair[2], " | "))
			TEST_FAIL("\"[key]\" has no \" | \" between its name and description")
	if(length(unported))
		TEST_NOTICE(src, "[length(unported)] races of Vibelin in chargen.txt are not ported to this build yet: [jointext(unported, ", ")]")
	rogue_chargen_load()
	if(!length(GLOB.rogue_chargen_entries))
		TEST_FAIL("no chargen entries loaded, so every species, faith and culture falls back to English")
	var/list/untranslated = list()
	for(var/path in GLOB.rogue_faiths + GLOB.rogue_patrons + GLOB.rogue_cultures)
		if(!GLOB.rogue_chargen_entries[path])
			untranslated += "[path]"
	if(length(untranslated))
		TEST_NOTICE(src, "[length(untranslated)] faiths, patrons and cultures have no line in chargen.txt (the Chargen Sheet: Missing Keys verb lists them): [jointext(untranslated, ", ")]")

/// traits.txt: a trait line names a trait of the sheet and has its " | ", the Russian keeps the colour of the English
/// line, every trait of the sheet has a line.
/datum/unit_test/rogue_trait_sheet

/datum/unit_test/rogue_trait_sheet/Run()
	var/list/pairs = rogue_strings_pairs("traits.txt")
	if(!length(pairs))
		TEST_FAIL("traits.txt produced no entries; the file is missing or every line was skipped")
		return
	var/list/foreign = list()
	for(var/list/pair as anything in pairs)
		var/key = pair[1]
		if(copytext(key, 1, 2) == "/")
			var/path = text2path(key)
			if(!ispath(path))
				foreign += key
			else if(!ispath(path, /datum/quirk) && !ispath(path, /datum/language))
				TEST_FAIL("[path] is neither a quirk nor a language, so the sheet never looks it up")
			continue
		if(!findtext(pair[2], " | "))
			TEST_FAIL("trait \"[key]\" has no \" | \" between its name and description")
		else if(!(key in GLOB.rogue_trait_descriptions))
			foreign += key
	if(length(foreign))
		TEST_NOTICE(src, "[length(foreign)] lines of traits.txt are Vibelin's traits, quirks and languages this build does not have")
	var/list/untranslated = list()
	for(var/trait in GLOB.rogue_trait_descriptions)
		var/list/entry = rogue_trait_sheet_entry(trait)
		if(!islist(entry))
			untranslated += trait
			continue
		if(findtext(GLOB.rogue_trait_descriptions[trait], "<span class=") == 1 && findtext(entry[2], "<span class=") != 1)
			TEST_FAIL("the Russian line of \"[trait]\" lost the colour of the English one")
	if(length(untranslated))
		TEST_NOTICE(src, "[length(untranslated)] traits of the sheet have no Russian line: [jointext(untranslated, ", ")]")

/// The server's engine: its own files and the chat's patterns compile in BYOND's regex, every template asks for a
/// capture its pattern has, the titles are all in six cases and cover the roles, classes, waves and events of the code.
/datum/unit_test/rogue_localization_strings

/datum/unit_test/rogue_localization_strings/Run()
	var/static/list/valid_cases = list("nom", "gen", "dat", "acc", "ins", "pre")
	var/regex/token = regex(@"\$(\d+)(?:\|([a-z]+)(\?)?)?", "g")
	for(var/datum/rogue_dictionary/dictionary as anything in list(rogue_maptext_dictionary(), rogue_composite_dictionary()))
		for(var/rejected in dictionary.rejected)
			TEST_FAIL("the pattern [rejected] does not compile in BYOND's regex, so the server skips it")
		if(!length(dictionary.fragments) || !length(dictionary.patterns))
			TEST_FAIL("a dictionary of the server came back without fragments or patterns; a strings file is missing")
	for(var/filename in list("module_maptext.txt", "module_composites.txt"))
		for(var/list/pair as anything in rogue_strings_pairs(filename))
			if(copytext(pair[1], 1, 2) != ROGUE_LOCALIZATION_PATTERN_MARK)
				if(pair[1] == pair[2])
					TEST_FAIL("[filename]: \"[pair[1]]\" maps to itself")
				continue
			var/groups = rogue_count_capture_groups(pair[1])
			var/position = 1
			while(token.Find(pair[2], position))
				position = token.next
				var/index = text2num(token.group[1])
				var/case_key = token.group[2]
				if(index > groups)
					TEST_FAIL("[filename]: \"[pair[2]]\" uses $[index], but \"[pair[1]]\" captures [groups]")
				if(case_key && !(case_key in valid_cases))
					TEST_FAIL("[filename]: \"[pair[2]]\" asks for the case \"[case_key]\"")
				if(token.group[3] && filename != "module_composites.txt")
					TEST_FAIL("[filename]: \"[pair[2]]\" uses $N|case?, which only module_composites.txt knows")

	var/list/title_pairs = rogue_strings_pairs("module_titles.txt")
	var/list/titles = rogue_strings_nouns("module_titles.txt")
	if(length(titles) != length(title_pairs))
		TEST_FAIL("module_titles.txt has [length(title_pairs)] lines but [length(titles)] full names: a line lacks one of its six cases")
	var/list/in_code = list()
	for(var/datum/job/roguetown/job as anything in subtypesof(/datum/job/roguetown))
		in_code += initial(job.title)
	for(var/datum/rockhill_advclass/advclass as anything in subtypesof(/datum/rockhill_advclass))
		in_code += initial(advclass.name)
	for(var/datum/rogue_migrant_wave/wave as anything in subtypesof(/datum/rogue_migrant_wave))
		if(initial(wave.abstract_type) != wave)
			in_code += initial(wave.name)
	for(var/datum/rogue_migrant_role/role as anything in subtypesof(/datum/rogue_migrant_role))
		if(initial(role.abstract_type) != role)
			in_code += initial(role.name)
	rockhill_load_calendar_events()
	for(var/datum/rockhill_calendar_event/event as anything in GLOB.rockhill_calendar_events)
		in_code += event.title
	var/list/untitled = list()
	for(var/title in in_code)
		if(length(title) && !titles[title])
			untitled |= title
	if(length(untitled))
		TEST_NOTICE(src, "[length(untitled)] names of roles, classes, waves and events have no Russian in module_titles.txt: [jointext(untitled, ", ")]")

	// The engine itself: an exact line, a pattern declining its capture, a composed name and the strict refusal.
	TEST_ASSERT_EQUAL(rogue_maptext_dictionary().translate("interrupted!"), "прервано!", "an exact maptext line was not taken")
	TEST_ASSERT_EQUAL(rogue_maptext_dictionary().translate_markup("<i>I can't tell...</i>"), "<i>не разобрать...</i>", "a maptext line inside tags was not taken")
	TEST_ASSERT_EQUAL(rogue_translate_name("masterwork longsword"), "длинный меч мастерской работы", "a quality prefix was not moved behind the name")
	TEST_ASSERT_NULL(rogue_translate_name("masterwork qwertyuiop"), "a composed name with an unknown head came out half English")

#undef TEST_ASSERT_EQUAL
#endif
