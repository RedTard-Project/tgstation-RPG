// Ratwood data the porter writes (tools/port_rockhill.py) for systems that do not declare it themselves yet: the data
// only, read by the module's systems as they come to it.

/// Ratwood's parts of the face (code/__DEFINES/inventory.dm MOUTH, NOSE, EARS, RIGHT_EYE, LEFT_EYE, HAIR). TG has no body
/// part flags for them, so the porter folds them into HEAD of body_parts_covered; rogue_face_coverage keeps which of them
/// an item covers, for what uncovers the face (a raised visor, clothing/adjustable.dm).
#define ROGUE_FACE_MOUTH (1<<0)
#define ROGUE_FACE_NOSE (1<<1)
#define ROGUE_FACE_EARS (1<<2)
#define ROGUE_FACE_RIGHT_EYE (1<<3)
#define ROGUE_FACE_LEFT_EYE (1<<4)
#define ROGUE_FACE_HAIR (1<<5)
#define ROGUE_FACE_EYES (ROGUE_FACE_RIGHT_EYE | ROGUE_FACE_LEFT_EYE)
/// Ratwood FACE: mouth, nose, eyes and ears.
#define ROGUE_FACE_ALL (ROGUE_FACE_MOUTH | ROGUE_FACE_NOSE | ROGUE_FACE_EYES | ROGUE_FACE_EARS)

/obj/item
	/// ROGUE_FACE_* the item covers (Ratwood body_parts_covered); NONE - nothing of the face.
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
