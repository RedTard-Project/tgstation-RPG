/// Ratwood's random painting (code/game/objects/structures/artstuff.dm): a mapped spot that hangs a random archived
/// player painting, each at most once a round, and goes away when none are left. Ratwood's archive is its own painting
/// subsystem; here it is the library's archive (library/paintings.dm: TG's persistent paintings with its tag), so
/// the paintings of the modern maps never hang here.

/// The archived paintings no spot has hung yet this round, in random order.
GLOBAL_LIST(rockhill_unhung_paintings)

/obj/item/canvas/random_painting
	anchored = TRUE

/obj/item/canvas/random_painting/Initialize(mapload)
	var/mapped_pixel_x = pixel_x
	var/mapped_pixel_y = pixel_y
	. = ..()
	// An item mapped without a pixel offset gets jittered.
	pixel_x = mapped_pixel_x
	pixel_y = mapped_pixel_y
	return INITIALIZE_HINT_LATELOAD

/obj/item/canvas/random_painting/LateInitialize()
	if(isnull(GLOB.rockhill_unhung_paintings))
		GLOB.rockhill_unhung_paintings = shuffle(rogue_archived_paintings())
	var/datum/painting/painting = pop(GLOB.rockhill_unhung_paintings)
	if(!painting)
		qdel(src)
		return
	icon = painting.get_icon()
	icon_state = null
	name = painting.title ? "painting of [painting.title]" : "painting"
	desc = painting.creator_name ? "A painting by [painting.creator_name]." : "A painting."
