/// The languages and traits of the character, in the reader's language (localization/traits.dm).
/mob/living/proc/rogue_print_traits()
	var/russian = rogue_ui_russian(client)
	var/list/lines = list("*----*")
	var/datum/language_holder/holder = get_language_holder()
	var/list/spoken = list()
	for(var/language_type in holder?.spoken_languages)
		var/datum/language/language = GLOB.language_datum_instances[language_type]
		if(language)
			var/language_name = (russian && rogue_trait_sheet_entry(language_type)) || language.name
			spoken += span_info("[language_name] - ,[language.key]")
	lines += length(spoken) ? spoken : list(span_warning(russian ? "Я не знаю ни одного языка." : "I don't know any languages."))
	lines += "*----*"
	var/list/known = list()
	for(var/trait in GLOB.rogue_trait_descriptions)
		if(HAS_TRAIT(src, trait))
			var/list/translated = russian ? rogue_trait_sheet_entry(trait) : null
			known += islist(translated) ? "[translated[1]] - [translated[2]]" : "[trait] - [GLOB.rogue_trait_descriptions[trait]]"
	lines += length(known) ? known : list(span_warning(russian ? "У меня нет особых черт." : "I have no special traits."))
	lines += "*----*"
	to_chat(src, boxed_message(jointext(lines, "\n")))
