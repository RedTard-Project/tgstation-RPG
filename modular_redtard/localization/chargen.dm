/// Character setup in Russian (Vibelin's chargen_sheet.dm): species, faiths, patrons and cultures, keyed by type and
/// resolved on the server, so the window gets its texts already in the player's language.
///   strings/chargen.txt        /type/path = <name> | <description>    and    /type/path:field = <text>
///   strings/chargen_terms.txt  <English term> = <Russian term>         (languages, ancestry wordings, ages, tags)
/// A missing or empty entry keeps the English, so a partly translated file is a valid state.

GLOBAL_LIST_EMPTY(rogue_chargen_entries)
GLOBAL_LIST_EMPTY(rogue_chargen_fields)
GLOBAL_LIST_EMPTY(rogue_chargen_terms)
/// Vibelin's type paths, as text, that live under another path here: its dark elf is Ratwood's. Its other races are
/// /datum/species/vib_<id> (GLOB.rogue_vibelin_species, made by the races' port).
GLOBAL_LIST_INIT(rogue_chargen_aliases, list(
	"/datum/species/elf/dark" = /datum/species/rogue_drow,
))
GLOBAL_VAR_INIT(rogue_chargen_loaded, FALSE)

/proc/rogue_chargen_path(key)
	return GLOB.rogue_chargen_aliases[key] || GLOB.rogue_vibelin_species[key] || text2path(key)

/proc/rogue_chargen_load()
	if(GLOB.rogue_chargen_loaded)
		return
	GLOB.rogue_chargen_loaded = TRUE
	for(var/list/pair as anything in rogue_strings_pairs("chargen.txt"))
		var/key = pair[1]
		var/field_at = findtext(key, ":")
		var/path = rogue_chargen_path(field_at ? copytext(key, 1, field_at) : key)
		if(!ispath(path))
			continue
		if(field_at)
			GLOB.rogue_chargen_fields["[path]:[copytext(key, field_at + 1)]"] = pair[2]
			continue
		var/split_at = findtext(pair[2], " | ")
		if(split_at)
			GLOB.rogue_chargen_entries[path] = list(copytext(pair[2], 1, split_at), copytext(pair[2], split_at + 3))
	for(var/list/pair as anything in rogue_strings_pairs("chargen_terms.txt"))
		GLOB.rogue_chargen_terms[pair[1]] = pair[2]

/// The name of a species, faith, patron or culture for a reader of Russian (ru) or English.
/proc/rogue_chargen_name(ru, path, fallback)
	if(!ru)
		return fallback
	rogue_chargen_load()
	var/list/entry = GLOB.rogue_chargen_entries[path]
	return length(entry?[1]) ? entry[1] : fallback

/proc/rogue_chargen_desc(ru, path, fallback)
	if(!ru)
		return fallback
	rogue_chargen_load()
	var/list/entry = GLOB.rogue_chargen_entries[path]
	return length(entry?[2]) ? entry[2] : fallback

/// A patron's domain, boons, sins, flaws or worshippers.
/proc/rogue_chargen_field(ru, path, field, fallback)
	if(!ru)
		return fallback
	rogue_chargen_load()
	var/translated = GLOB.rogue_chargen_fields["[path]:[field]"]
	return length(translated) ? translated : fallback

/proc/rogue_chargen_term(ru, term)
	if(!ru)
		return term
	rogue_chargen_load()
	return GLOB.rogue_chargen_terms["[term]"] || term

/// A compound name of Vibelin's colour lists ("black - oil", "sun - amber"): each part by chargen_terms.txt, joined by a
/// dash.
/proc/rogue_chargen_compound(ru, text)
	if(!ru || !findtext(text, " - "))
		return rogue_chargen_term(ru, text)
	var/list/parts = list()
	for(var/part in splittext(text, " - "))
		parts += rogue_chargen_term(ru, part)
	return jointext(parts, " — ")

/// A sentence of chargen_terms.txt by its key, %TERM% filled in.
/proc/rogue_chargen_line(ru, key, fallback, term)
	. = fallback
	if(ru)
		rogue_chargen_load()
		var/translated = GLOB.rogue_chargen_terms["[key]"]
		if(length(translated))
			. = translated
	if(!isnull(term))
		. = replacetext(., "%TERM%", "[term]")
