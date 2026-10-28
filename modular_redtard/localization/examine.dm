/// Descriptions in Russian (Vibelin's descriptions.dm): keyed by type rather than by the English text, so a reworded
/// English desc never silently loses its translation, and resolved on the server for the player who examines.
/// strings/descriptions.txt holds Vibelin's entries (Vanderlin's types) and the ones the module's generator found for
/// this build's types; a type this build does not have is dropped without a word. What the game composes in the round
/// (a quality prefix, an ingot's quality sentence, a manuscript) goes through translate.dm.

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

/// Object names in Russian, nominative, by English name: the chat's noun dictionary (strings/items.txt and
/// module_items.txt), which declines the same names in chat lines. Read on the first examine.
GLOBAL_LIST(rogue_examine_names)

/proc/rogue_examine_russian_name(english)
	if(isnull(GLOB.rogue_examine_names))
		GLOB.rogue_examine_names = list()
		for(var/filename in list("items.txt", "module_items.txt"))
			var/list/nouns = rogue_strings_nouns(filename)
			for(var/key in nouns)
				var/list/cases = nouns[key]
				if(cases["nom"])
					GLOB.rogue_examine_names[LOWER_TEXT(key)] = cases["nom"]
	return GLOB.rogue_examine_names[LOWER_TEXT(english)]

/// The examine title ("That's a longsword.") names the object in Russian for a Russian player, without the article
/// (rogue_russian_name(): not a name a player gave it). "That's" itself the chat translates. TG's blood decal puts
/// "[blood]-stained" before the name, and a Russian adjective would have to agree with a noun it never sees, so the
/// stain goes after the name, as Vibelin does (description_composites.dm): "длинный меч в крови".
/obj/get_examine_name(mob/user)
	. = ..()
	if(!user?.client || !rogue_ui_russian(user.client))
		return
	var/russian = rogue_russian_name(src)
	if(!russian)
		return
	. = replacetextEx(., rogue_plain_name(name), russian)
	var/static/regex/article = regex(@"^(?:a pair of|an?|the|some) ", "i")
	. = article.Replace(., "")
	var/static/regex/stained = regex(@"^(\S+)-stained (.+)$")
	if(stained.Find(.))
		var/stain = stained.group[1]
		. = "[stained.group[2]] [stain == "blood" ? "в крови" : "в пятнах"]"

/// A creature's examine title by the name it was made with ("This is wolf."); characters keep their names.
/mob/living/get_examine_name(mob/user)
	. = ..()
	if(. != name || !user?.client || !rogue_ui_russian(user.client))
		return
	var/russian = rogue_russian_name(src)
	if(russian)
		. = russian

/// TG puts the description in as "<i>[desc]</i>"; a Russian player gets its translation in its place
/// (rogue_russian_description(): by type, or composed in the round), unless a player wrote it (an engraving, a pen).
/atom/examine(mob/user)
	. = ..()
	if(!desc || !user?.client || !rogue_ui_russian(user.client))
		return
	var/russian = rogue_russian_description(src)
	if(!russian)
		return
	var/list/lines = .
	var/index = lines.Find("<i>[desc]</i>")
	if(index)
		lines[index] = "<i>[russian]</i>"
