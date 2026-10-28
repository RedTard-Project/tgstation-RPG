/// Vibelin's chat engine (modular_redtard/tgui/rogue_panel/localization/translate.ts) on the server, for the text the chat
/// panel never sees: maptext over the map (balloon alerts, area titles, maptext.dm) and the names and descriptions the
/// game composes during the round (examine, screentips, item tooltips). Same strings and same rules: an exact line first,
/// then the patterns in file order, $N|case declining capture N from the noun table and from the cases players wrote for
/// their characters; no match leaves the English. Unlike the panel, a dictionary here is strict: a pattern that would
/// leave part of the text in English does not take it (/datum/rogue_dictionary/var/strict). In a strings file read here
/// a key that starts with "^" is a pattern, so one file can hold both (module_maptext.txt, module_composites.txt).

/// The noun tables, read once: the names of things (items.txt, module_items.txt) and the rest (nouns.txt,
/// module_nouns.txt, module_titles.txt), a later file winning a collision as in the chat dictionary.
GLOBAL_LIST(rogue_noun_items)
GLOBAL_LIST(rogue_noun_others)
GLOBAL_LIST(rogue_noun_honorifics)
/// The honorifics, longest first, so "Lady Herald" is tried before "Lady".
GLOBAL_LIST(rogue_noun_honorific_titles)
/// Every dictionary made, so that a new character's cases clear what they have cached.
GLOBAL_LIST_EMPTY(rogue_dictionaries)
GLOBAL_DATUM(rogue_maptext_dictionary, /datum/rogue_dictionary)
GLOBAL_DATUM(rogue_composite_dictionary, /datum/rogue_dictionary)

/proc/rogue_load_noun_tables()
	if(!isnull(GLOB.rogue_noun_items))
		return
	GLOB.rogue_noun_items = rogue_merge_nouns(list("items.txt", "module_items.txt"))
	GLOB.rogue_noun_others = rogue_merge_nouns(list("nouns.txt", "module_nouns.txt", "module_titles.txt"))
	GLOB.rogue_noun_honorifics = rogue_strings_nouns("honorifics.txt")
	var/list/titles = list()
	for(var/title in GLOB.rogue_noun_honorifics)
		titles += title
	GLOB.rogue_noun_honorific_titles = sortTim(titles, GLOBAL_PROC_REF(cmp_rogue_longer_first))

/proc/rogue_merge_nouns(list/filenames)
	. = list()
	for(var/filename in filenames)
		var/list/table = rogue_strings_nouns(filename)
		for(var/key in table)
			.[key] = table[key]

/proc/cmp_rogue_longer_first(a, b)
	return length(b) - length(a)

/proc/rogue_noun_lookup(value, items_first)
	var/list/first = items_first ? GLOB.rogue_noun_items : GLOB.rogue_noun_others
	var/list/second = items_first ? GLOB.rogue_noun_others : GLOB.rogue_noun_items
	return first[value] || second[value] || GLOB.rogue_chat_declensions[value]

/// The cases of a noun or of a character's name, or null. items_first: a thing's own name looks among the names of
/// things before the body parts and places; the chat's order is the other way round ("chest" is a body part there).
/proc/rogue_noun_forms(value, items_first = FALSE)
	if(!length(value))
		return null
	rogue_load_noun_tables()
	. = rogue_noun_lookup(value, items_first)
	if(.)
		return
	// DM writes things bare and through \a and \the alike; Russian has no articles.
	var/static/regex/article = regex(@"^(?:the|an|a)\s+", "i")
	var/bare = article.Replace(value, "")
	if(!length(bare))
		return null
	. = rogue_noun_lookup(bare, items_first)
	if(!.)
		. = rogue_noun_lookup(LOWER_TEXT(copytext_char(bare, 1, 2)) + copytext_char(bare, 2), items_first)

/// "Lady Herald Vicente": the title comes from the job, the name from the player, so the title declines from the
/// honorifics and the rest on its own. Only an honorific may be split off, so a thing's name is never cut in half.
/proc/rogue_decline_titled(value, case_key)
	rogue_load_noun_tables()
	for(var/title in GLOB.rogue_noun_honorific_titles)
		var/prefix_length = length(title) + 1
		if(length(value) <= prefix_length || copytext(value, 1, prefix_length + 1) != "[title] ")
			continue
		var/rest = copytext(value, prefix_length + 1)
		var/list/title_cases = GLOB.rogue_noun_honorifics[title]
		var/list/rest_cases = rogue_noun_lookup(rest, FALSE)
		return "[title_cases[case_key] || title] [rest_cases?[case_key] || rest]"
	return null

/// A capture in a case, or null when nothing knows it.
/proc/rogue_decline(value, case_key, items_first = FALSE)
	var/list/cases = rogue_noun_forms(value, items_first)
	if(cases)
		return cases[case_key]
	return rogue_decline_titled(value, case_key)

/// Clears what every dictionary has cached: a character's cases arrived, and a name declined before is declined now.
/proc/rogue_dictionaries_forget()
	for(var/datum/rogue_dictionary/dictionary as anything in GLOB.rogue_dictionaries)
		dictionary.cache.Cut()

/// One set of strings files as the engine reads them.
/datum/rogue_dictionary
	/// Text -> its Russian, matched whole; the first file to give a line wins.
	var/list/fragments = list()
	/// list(regex, template), tried in order.
	var/list/patterns = list()
	/// Patterns BYOND's regex refused, for the unit test.
	var/list/rejected = list()
	/// Text this dictionary was asked about -> its Russian, or "" for none.
	var/list/cache = list()
	/// A pattern whose $N|case capture nothing knows does not take the text (the panel would print the capture in
	/// English), so a line on the map or a name never comes out half English; for maptext an English $N capture too.
	var/strict = FALSE
	/// Names and descriptions of things (module_composites.txt): captures decline as things' names first, a name may
	/// hold a composed name, and an English $N capture (a character, a date) is welcome.
	var/names = FALSE

/datum/rogue_dictionary/New(list/filenames, strict = FALSE, names = FALSE)
	. = ..()
	src.strict = strict || names
	src.names = names
	GLOB.rogue_dictionaries += src
	for(var/filename in filenames)
		for(var/list/pair as anything in rogue_strings_pairs(filename))
			if(copytext(pair[1], 1, 2) == ROGUE_LOCALIZATION_PATTERN_MARK)
				add_pattern(pair[1], pair[2])
			else if(isnull(fragments[pair[1]]))
				fragments[pair[1]] = pair[2]
	if(length(rejected))
		stack_trace("Localization: [length(rejected)] patterns do not compile on the server and are skipped, the first: [rejected[1]]")

/datum/rogue_dictionary/proc/add_pattern(source, template)
	var/regex/compiled
	try
		compiled = regex(source)
	catch(var/exception/error)
		rejected += "[source] ([error])"
		return
	if(!compiled)
		rejected += source
		return
	patterns += list(list(compiled, template))

/// The Russian of a text, or null; whitespace at its edges is kept as it was.
/datum/rogue_dictionary/proc/translate(text)
	if(!istext(text) || !length(text))
		return null
	var/cached = cache[text]
	if(!isnull(cached))
		return cached || null
	if(length(cache) >= ROGUE_TRANSLATE_CACHE_LIMIT)
		cache.Cut()
	var/result
	var/core = trimtext(text)
	if(length(core))
		var/russian = translate_core(core, 0)
		if(!isnull(russian))
			var/static/regex/leading = regex(@"^\s+")
			var/static/regex/trailing = regex(@"\s+$")
			var/before = leading.Find(text) ? leading.match : ""
			var/after = trailing.Find(text) ? trailing.match : ""
			result = "[before][russian][after]"
	cache[text] = result || ""
	return result

/// Text that may carry markup (<font>, <i>): each run between the tags on its own, as the panel goes node by node.
/datum/rogue_dictionary/proc/translate_markup(text)
	if(!findtext(text, "<"))
		return translate(text) || text
	var/static/regex/tag = regex(@"<[^>]*>", "g")
	var/list/parts = list()
	var/position = 1
	var/changed = FALSE
	while(tag.Find(text, position))
		var/run = copytext(text, position, tag.index)
		var/tag_text = tag.match
		position = tag.next
		var/russian = translate(run)
		if(russian)
			changed = TRUE
		parts += russian || run
		parts += tag_text
	var/rest = copytext(text, position)
	var/rest_russian = translate(rest)
	if(rest_russian)
		changed = TRUE
	parts += rest_russian || rest
	return changed ? jointext(parts, "") : text

/// The Russian of a whole trimmed text, or null when no line takes it.
/datum/rogue_dictionary/proc/translate_core(core, depth)
	var/exact = fragments[core]
	if(!isnull(exact))
		return exact
	for(var/list/pattern as anything in patterns)
		var/regex/compiled = pattern[1]
		if(!compiled.Find(core))
			continue
		var/list/captures = compiled.group?.Copy()
		var/expanded = expand(pattern[2], captures, depth)
		if(!isnull(expanded))
			return expanded
	return null

/// The template with its $N, $N|case and $N|case? filled from the captures; null when a strict dictionary cannot fill
/// it whole.
/datum/rogue_dictionary/proc/expand(template, list/captures, depth)
	var/static/regex/token = regex(@"\$(\d+)(?:\|(nom|gen|dat|acc|ins|pre)(\?)?)?", "g")
	var/static/regex/latin = regex(@"[A-Za-z]")
	var/list/parts = list()
	var/position = 1
	while(token.Find(template, position))
		// Everything the token says is read before declining: a name inside a name runs this proc again.
		parts += copytext(template, position, token.index)
		position = token.next
		var/whole = token.match
		var/index = text2num(token.group[1])
		var/case_key = token.group[2]
		var/optional = !isnull(token.group[3])
		var/captured = (index >= 1 && index <= length(captures)) ? captures[index] : null
		if(isnull(captured))
			parts += whole
			continue
		if(!case_key)
			if(strict && !names && latin.Find(captured))
				return null
			parts += captured
			continue
		var/declined = decline(captured, case_key, depth)
		if(isnull(declined))
			if(strict && !optional)
				return null
			declined = captured
		parts += declined
	parts += copytext(template, position)
	return jointext(parts, "")

/datum/rogue_dictionary/proc/decline(value, case_key, depth)
	. = rogue_decline(value, case_key, names)
	// A composed name inside a composed name: "masterwork iron sword".
	if(isnull(.) && names && case_key == "nom" && depth < ROGUE_TRANSLATE_DEPTH)
		. = translate_core(trimtext(value), depth + 1)

/// Balloon alerts and area titles: module_maptext.txt, then the chat's own fragments and patterns, strictly: a chat
/// pattern that would leave part of a line in English ("В the box пусто!") leaves all of it.
/proc/rogue_maptext_dictionary()
	if(!GLOB.rogue_maptext_dictionary)
		GLOB.rogue_maptext_dictionary = new /datum/rogue_dictionary(list(
			"module_maptext.txt",
			"fragments.txt", "speech.txt", "medical.txt", "world.txt", "status.txt", "module_fragments.txt",
			"module_patterns.txt", "patterns.txt",
		), TRUE)
	return GLOB.rogue_maptext_dictionary

/// Names and descriptions the game composes in the round: module_composites.txt alone.
/proc/rogue_composite_dictionary()
	if(!GLOB.rogue_composite_dictionary)
		GLOB.rogue_composite_dictionary = new /datum/rogue_dictionary(list("module_composites.txt"), TRUE, TRUE)
	return GLOB.rogue_composite_dictionary

/// Maptext (a balloon alert, an area title) in the reader's language: the English for a reader of English or for text
/// no line takes.
/proc/rogue_maptext(text, client/reader)
	if(!istext(text) || !length(text) || !reader || !rogue_ui_russian(reader))
		return text
	return rogue_maptext_dictionary().translate_markup(text)

/// A name without BYOND's \proper and \improper.
/proc/rogue_plain_name(name)
	return trimtext(replacetext(replacetext("[name]", "\proper", ""), "\improper", ""))

/// The Russian of an English name, or null: the name dictionary (items.txt, module_items.txt) whole, then, for a
/// thing, the names the game composes (module_composites.txt) and a trailing "(label)" kept as written after a
/// translated head.
/proc/rogue_translate_name(english, composites = TRUE)
	english = rogue_plain_name(english)
	if(!length(english))
		return null
	. = rogue_examine_russian_name(english)
	if(.)
		return
	var/static/regex/article = regex(@"^(?:the|an|a|some) ", "i")
	var/bare = article.Replace(english, "")
	if(bare != english)
		. = rogue_examine_russian_name(bare)
		if(.)
			return
	if(!composites || !length(bare))
		return null
	. = rogue_composite_dictionary().translate(bare)
	if(.)
		return
	var/static/regex/label = regex(@"^(.+?) (\([^()]*\))$")
	if(label.Find(bare))
		var/head_english = label.group[1]
		var/label_text = label.group[2]
		var/head = rogue_translate_name(head_english)
		if(head)
			return "[head] [label_text]"
	return null

/// The name a reader of Russian sees for a thing, or null to show its own. A name a player gave (a pen, a character's
/// name) is never translated, a creature only by the name it was made with, a screen element (the HUD) not at all;
/// a turf only by the dictionary, since a composed name is a thing's ("rough stone ground" is no rough work).
/proc/rogue_russian_name(atom/thing)
	if(!thing?.name || istype(thing, /atom/movable/screen) || HAS_TRAIT(thing, TRAIT_WAS_RENAMED))
		return null
	if(ismob(thing))
		if(iscarbon(thing) || thing.name != initial(thing.name))
			return null
		return rogue_translate_name(thing.name, FALSE)
	return rogue_translate_name(thing.name, !isturf(thing))

/// The description a reader of Russian sees for a thing, or null to show its own: by type (descriptions.txt) while
/// it is the type's own, the type's with a sentence after it (an ingot's quality) in two halves, and a description the
/// game composed (module_composites.txt). A description a player wrote stays as written.
/proc/rogue_russian_description(atom/thing)
	var/desc = thing?.desc
	if(!desc)
		return null
	var/base = initial(thing.desc)
	if(desc == base)
		return rogue_examine_description(thing.type)
	if(HAS_TRAIT(thing, TRAIT_WAS_RENAMED))
		return null
	if(base && length(desc) > length(base) && findtextEx(desc, base) == 1)
		var/base_russian = rogue_examine_description(thing.type)
		if(!base_russian)
			return null
		var/rest_russian = rogue_composite_dictionary().translate(copytext(desc, length(base) + 1))
		return rest_russian ? "[base_russian][rest_russian]" : null
	return rogue_composite_dictionary().translate(desc)
