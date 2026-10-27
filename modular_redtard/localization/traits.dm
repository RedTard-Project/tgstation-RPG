/// The character sheet in Russian (Vibelin's trait_sheet.dm): strings/traits.txt, keyed by what a thing is in code, not
/// by its English, and resolved on the server.
///   <trait name> = <Russian name> | <Russian description>     (the text a TRAIT_* define expands to)
///   /datum/language/... = <Russian name>
///   /datum/quirk/... = <Russian description>                  (no quirks on medieval maps, kept for completeness)

/// Trait name -> list(Russian name, Russian description); language and quirk types -> Russian text.
GLOBAL_LIST(rogue_trait_sheet)

/proc/rogue_trait_sheet_entry(key)
	if(isnull(GLOB.rogue_trait_sheet))
		GLOB.rogue_trait_sheet = list()
		for(var/list/pair as anything in rogue_strings_pairs("traits.txt"))
			var/key_text = pair[1]
			if(copytext(key_text, 1, 2) == "/")
				var/path = text2path(key_text)
				if(path)
					GLOB.rogue_trait_sheet[path] = pair[2]
				continue
			var/split_at = findtext(pair[2], " | ")
			if(split_at)
				GLOB.rogue_trait_sheet[key_text] = list(copytext(pair[2], 1, split_at), rogue_trait_span(key_text, copytext(pair[2], split_at + 3)))
	return GLOB.rogue_trait_sheet[key]

/// The Russian description in the span the English one is written in (rockhill/ported/_traits.dm: span_info,
/// span_warning, span_greentext...), so "My traits" colours a trait alike in both languages.
/proc/rogue_trait_span(trait, text)
	var/english = GLOB.rogue_trait_descriptions[trait]
	var/static/regex/opening = regex(@"^<span class='([^']+)'>")
	if(!istext(english) || !opening.Find(english))
		return text
	return "<span class='[opening.group[1]]'>[text]</span>"
