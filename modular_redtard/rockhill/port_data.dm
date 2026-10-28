// Ratwood data the porter writes (tools/port_rockhill.py) for systems that do not declare it themselves yet: the data
// only, read by the module's systems as they come to it.

/obj/item
	/// Ratwood's body_parts_covered as it is: TG's flags and ROGUE_COVER_* (clothing/_defines.dm). Null - what TG's
	/// body_parts_covered says, its HEAD the whole head and its CHEST the chest and the vitals (rogue_coverage_flags(),
	/// combat/armor.dm). The porters write it where TG's flags would say otherwise and on everything that covers part of the head.
	var/rogue_coverage

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
