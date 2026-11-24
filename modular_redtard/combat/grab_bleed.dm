/// B15: a grip by someone else stems the bleeding of the part it holds (Azure Peak bleed_suppressing of /obj/item/grabbing,
/// bodypart_wounds.dm; Vibelin get_bleed_multiplier() has the same): a loose grip by half, a tight one more, and grips on one
/// part multiply. The tourniquet, clamped vessels and one's own grasp stay in rogue_bleed_factor() of combat/blood.dm. This
/// file comes after blood.dm, so that its definition of rogue_bleed_factor() is the one that runs and calls blood.dm's.
/obj/item/bodypart/rogue_bleed_factor(datum/rogue_physiology_numbers/numbers = rogue_physiology())
	. = ..()
	for(var/obj/item/hand_item/rogue_grab/grip as anything in rogue_grips)
		. *= grip.bleed_suppression()
