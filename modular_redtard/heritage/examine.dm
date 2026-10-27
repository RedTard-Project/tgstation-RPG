/// Where a character comes from, on examine (Vibelin's human examine): plain to observers, to the character and to
/// those of the same culture; everyone else cannot tell. In the reader's language, the culture named as chargen.txt
/// names it.
/mob/living/carbon/human/examine(mob/user)
	. = ..()
	if(!rogue_culture || !rogue_lobby_enabled())
		return
	var/russian = rogue_ui_russian(user?.client)
	var/self = (user == src)
	var/mob/living/carbon/human/viewer = user
	var/knows = self || isobserver(user) || (istype(viewer) && viewer.rogue_culture?.type == rogue_culture.type)
	if(knows && !istype(rogue_culture, /datum/culture/universal/ambiguous))
		if(russian)
			. += "Родом: [rogue_chargen_name(TRUE, rogue_culture.type, rogue_culture.name)]."
		else
			. += "[self ? "I am" : "I believe [p_theyre()]"] from [rogue_culture.examined_string()]."
	else if(!self)
		. += russian ? "Откуда родом — не понять." : "[p_They()] could be from anywhere."
