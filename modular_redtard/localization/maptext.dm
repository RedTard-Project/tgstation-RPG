/// Maptext over the map, which the chat panel never sees: the server translates it for each viewer by the panel's own
/// strings (translate.dm, module_maptext.txt first). Each balloon alert and each area title is made for one viewer, so
/// each gets it in their language, and the English stays where no line takes the text.

/// TG makes one image per viewer here; the text is turned into the viewer's language before it is measured and drawn.
/// With runechat off TG prints the alert in the chat instead, where it arrives already translated.
/atom/balloon_alert_perform(mob/viewer, text)
	return ..(viewer, rogue_maptext(text, viewer?.client))

/// The area title of Rockhill (rockhill/area_sounds.dm, rockhill_enter_area()) is maptext on the screen, made just before
/// it is shown here: a reader of Russian gets the title of the area they entered in Russian.
/mob/living/rockhill_flash_screen(atom/movable/screen/shown, fade_in, shown_for)
	if(client && istype(shown, /atom/movable/screen/rockhill_area_title) && rogue_ui_russian(client))
		var/area/rogue/here = get_area(src)
		var/english = istype(here) ? here.rockhill_area_text : null
		var/russian = english && rogue_area_title(english)
		if(russian)
			shown.maptext = replacetextEx(shown.maptext, ">[english]<", ">[russian]<")
	return ..()

/// An area title in Russian, or null: module_maptext.txt and the chat's lines, then the places of module_nouns.txt.
/proc/rogue_area_title(english)
	. = rogue_maptext_dictionary().translate(english)
	if(.)
		return
	var/list/cases = rogue_noun_forms(english)
	return cases?["nom"]
