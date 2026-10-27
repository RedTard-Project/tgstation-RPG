// Coin pouches filled the way Ratwood fills them (code/modules/clothing/rogueclothes/storage/pouch.dm), through TG's
// PopulateContents(); piles of one kind merge in the pouch as TG stacks do.

/obj/item/storage/belt/rogue/pouch/coins/poor/PopulateContents()
	new /obj/item/roguecoin/copper/pile(src)
	if(prob(50))
		new /obj/item/roguecoin/copper/pile(src)

/obj/item/storage/belt/rogue/pouch/coins/mid/PopulateContents()
	new /obj/item/roguecoin/silver/pile(src)
	new /obj/item/roguecoin/copper/pile(src)

/obj/item/storage/belt/rogue/pouch/coins/rich/PopulateContents()
	new /obj/item/roguecoin/silver/pile(src)
	if(prob(50))
		new /obj/item/roguecoin/silver/pile(src)
	new /obj/item/roguecoin/gold/pile(src)
	if(prob(50))
		new /obj/item/roguecoin/gold/pile(src)

/obj/item/storage/belt/rogue/pouch/coins/veryrich/PopulateContents()
	new /obj/item/roguecoin/gold/pile(src)
	new /obj/item/roguecoin/gold/pile(src)
	if(prob(50))
		new /obj/item/roguecoin/gold/pile(src)

/// A virtue's purse of zenarii.
/obj/item/storage/belt/rogue/pouch/coins/virtuepouch/PopulateContents()
	new /obj/item/roguecoin/gold/virtuepile(src)

/// The pouch of twenty mammons in silver handed to those who were ready when the round began.
/obj/item/storage/belt/rogue/pouch/coins/readyuppouch/PopulateContents()
	new /obj/item/roguecoin/silver/pile/readyuppile(src)

/// A pouch of dungeon psila.
/obj/item/storage/belt/rogue/pouch/coins/gilbranze/PopulateContents()
	new /obj/item/roguecoin/gilbranze/pile(src)
