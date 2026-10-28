/// Russian names under the cursor, on the map and in the inventory alike, each player in their own language. TG lets the
/// mob that hovers rename what it sees in the screentip (COMSIG_MOB_REQUESTING_SCREENTIP_NAME_FROM_USER, the way
/// prosopagnosia hides faces), so every mob a player enters asks this datum, and a reader of Russian gets the name
/// examine shows (translate.dm, rogue_russian_name()). The item tooltip of the inventory gets the same name and the
/// Russian description.
/datum/rogue_screentip_names

/datum/rogue_screentip_names/New()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_LOGGED_IN, PROC_REF(on_mob_logged_in))

/datum/rogue_screentip_names/proc/on_mob_logged_in(datum/source, mob/entered)
	SIGNAL_HANDLER
	follow(entered)

/// Lets the mob ask for its player's names; asking again for a mob that already asks changes nothing.
/datum/rogue_screentip_names/proc/follow(mob/user)
	if(QDELETED(user))
		return
	user.mob_flags |= MOB_HAS_SCREENTIPS_NAME_OVERRIDE
	RegisterSignal(user, COMSIG_MOB_REQUESTING_SCREENTIP_NAME_FROM_USER, PROC_REF(on_screentip_name), override = TRUE)

/datum/rogue_screentip_names/proc/on_screentip_name(mob/source, list/returned_name, obj/item/held_item, atom/hovered)
	SIGNAL_HANDLER
	if(!source.client || !rogue_ui_russian(source.client))
		return NONE
	var/russian = rogue_russian_name(hovered)
	if(!russian)
		return NONE
	returned_name[1] = russian
	return SCREENTIP_NAME_SET

GLOBAL_DATUM_INIT(rogue_screentip_names, /datum/rogue_screentip_names, new)

/// TG's tooltip of an item in the inventory: the title and the description in Russian for a reader of Russian, the
/// force line as TG writes it. Anything without a Russian name or description keeps TG's tooltip.
/obj/item/openTip(location, control, params, user)
	var/mob/viewer = user
	if(!istype(viewer) || !viewer.client || !rogue_ui_russian(viewer.client))
		return ..()
	var/russian_name = rogue_russian_name(src)
	var/russian_desc = rogue_russian_description(src)
	if(!russian_name && !russian_desc)
		return ..()
	if(last_force_string_check != force && !(item_flags & FORCE_STRING_OVERRIDE))
		set_force_string()
	var/force_line = (force || (item_flags & FORCE_STRING_OVERRIDE)) ? "<b>Force:</b> [force_string]" : ""
	openToolTip(user, src, params, title = russian_name || name, content = "[russian_desc || desc]<br>[force_line]", theme = "")
