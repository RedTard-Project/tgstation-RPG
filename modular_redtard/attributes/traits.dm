/mob/living/proc/rogue_print_traits()
	var/list/lines = list("*----*")
	var/datum/language_holder/holder = get_language_holder()
	var/list/spoken = list()
	for(var/language_type in holder?.spoken_languages)
		var/datum/language/language = GLOB.language_datum_instances[language_type]
		if(language)
			spoken += span_info("[language.name] - ,[language.key]")
	lines += length(spoken) ? spoken : list(span_warning("I don't know any languages."))
	lines += "*----*"
	var/list/known = list()
	for(var/trait in GLOB.rogue_trait_descriptions)
		if(HAS_TRAIT(src, trait))
			known += "[trait] - [GLOB.rogue_trait_descriptions[trait]]"
	lines += length(known) ? known : list(span_warning("I have no special traits."))
	lines += "*----*"
	to_chat(src, boxed_message(jointext(lines, "\n")))
