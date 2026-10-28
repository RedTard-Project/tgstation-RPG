// Ratwood data the porter writes (tools/port_rockhill.py) for systems that do not declare it themselves yet: the data
// only, read by the module's systems as they come to it.

/obj/item
	/// ROGUE_FACE_* (clothing/_defines.dm) the item covers (Ratwood body_parts_covered); NONE - nothing of the face.
	var/rogue_face_coverage = NONE

/obj/item/natural/clay
	/// What a kiln fires this raw piece into (Ratwood cooked_type, ceramicist/clay.dm); null - it only burns to ash.
	var/cooked_type

/datum/anvil_recipe
	/// Ratwood skip_quality: the thing takes the lowest quality of the bars put in, not the quality of the smithing.
	var/skip_quality = FALSE

/datum/crafting_recipe/roguetown
	/// Ratwood skip_quality: the result keeps the lowest quality of what it is made of instead of a quality by the
	/// crafter's skill (Azure Peak's plumed helmets: the helmet stays as it was forged).
	var/rogue_skip_quality = FALSE
