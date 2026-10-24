/datum/rogue_armor/New()
	. = ..()
	rogue_mechanics().apply_to("armor", src)

/datum/intent/New()
	. = ..()
	rogue_mechanics().apply_to("intents", src)

/obj/item/Initialize(mapload)
	rogue_mechanics().apply_to("items", src)
	return ..()
