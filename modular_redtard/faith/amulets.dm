/// The holy symbols (Ratwood clothing/rogueclothes/neck.dm psicross, the porter's 29 amulets): worn or held, one carries the
/// prayers of the faithful to the patrons it belongs to (faith.dm) and lets miracles that need a holy symbol be called
/// (miracle.dm). Used in hand, it is prayed with: Give Prayer for a devotee, a whispered prayer for anyone else.

/obj/item/clothing/neck/roguetown/psicross/examine(mob/user)
	. = ..()
	if(!rogue_faith_enabled())
		return
	var/list/patrons = rogue_symbol_patrons(type)
	if(length(patrons))
		. += span_info("A holy symbol of [english_list(patrons)]. Worn or held, it carries a prayer to them.")

/obj/item/clothing/neck/roguetown/psicross/attack_self(mob/user, modifiers)
	var/mob/living/carbon/human/believer = user
	if(!rogue_faith_enabled() || !istype(believer) || !believer.rogue_patron)
		return ..()
	if(believer.rogue_devotion)
		INVOKE_ASYNC(believer.rogue_devotion, TYPE_PROC_REF(/datum/rogue_devotion, pray))
	else
		INVOKE_ASYNC(believer, TYPE_PROC_REF(/mob/living/carbon/human, rogue_pray))
	return TRUE

/// The names of the patrons whose prayers a symbol of this type carries.
/proc/rogue_symbol_patrons(symbol_type)
	var/static/list/names_by_type = list()
	if(names_by_type[symbol_type])
		return names_by_type[symbol_type]
	var/list/names = list()
	for(var/path in GLOB.rogue_patrons)
		var/datum/patron/patron = GLOB.rogue_patrons[path]
		if(!patron.rogue_hidden && length(patron.rogue_faith_symbols) && (symbol_type in patron.rogue_faith_symbols))
			names |= patron.display_title()
	names_by_type[symbol_type] = names
	return names
