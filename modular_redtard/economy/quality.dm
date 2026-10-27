// Price by quality (Ratwood code/__DEFINES/item_quality.dm, roguestock/_roguestock.dm get_quality_settlement() and
// roguemachine/quality_flavor.dm): the crafting tier of an item (rogue_quality, crafting/) moves what it is worth and what the
// stockpile and the ships pay for it. Included after crafting/_defines.dm for the ROGUE_QUALITY_* tiers.

/// What a quality tier does to the price (Ratwood ITEM_QUALITY_MULT()); no quality or standard is the plain price.
/proc/rogue_quality_price_mult(quality)
	switch(quality)
		if(ROGUE_QUALITY_RUINED)
			return rogue_value("trade_quality_ruined")
		if(ROGUE_QUALITY_AWFUL)
			return rogue_value("trade_quality_awful")
		if(ROGUE_QUALITY_CRUDE)
			return rogue_value("trade_quality_crude")
		if(ROGUE_QUALITY_ROUGH)
			return rogue_value("trade_quality_rough")
		if(ROGUE_QUALITY_FINE)
			return rogue_value("trade_quality_fine")
		if(ROGUE_QUALITY_FLAWLESS)
			return rogue_value("trade_quality_flawless")
		if(ROGUE_QUALITY_MASTERWORK)
			return rogue_value("trade_quality_masterwork")
	return 1

/// The item's quality is not the plain one, for the machines' remarks.
/obj/item/proc/rogue_has_notable_quality()
	return !isnull(rogue_quality) && rogue_quality != ROGUE_QUALITY_STANDARD

/// The stockpile's remark on goods below or above standard (Ratwood quality_delta_flavor()).
/proc/rogue_stockpile_quality_remark(quality)
	if(isnull(quality) || quality == ROGUE_QUALITY_STANDARD)
		return null
	if(quality < ROGUE_QUALITY_STANDARD)
		return pick(
			"Your goods are shoddier than that ancient Naledi Merchant.",
			"My liege, I'll have to hire three smiths to remake that.",
			"I'd write a complaint tablet about you.",
			"Bold of you to think this machine does not have a touchstone in it.",
			"The quality of your goods could fell kingdoms."
		)
	return pick(
		"Fine work, my liege!",
		"Tis the finest goods I have seen in this land!",
		"Ah! Fineries suitable for a King!",
		"I have scratched the goods and confirm it is of the highest quality",
		"MORE!"
	)

/// The harbor's remark on cargo below or above standard (Ratwood navigator_quality_jab()).
/proc/rogue_harbor_quality_remark(quality)
	if(isnull(quality) || quality == ROGUE_QUALITY_STANDARD)
		return null
	if(quality < ROGUE_QUALITY_STANDARD)
		return pick(
			"This is not even worth lifting the balloon for",
			"This besmirches the honor of the Company.",
			"Such goods are beneath the dignity of Malum",
			"This is not even worth its weight",
			"FACTOR! WHAT IS THIS!"
		)
	return pick(
		"Mermaids are leaping out of the water for this cargo!",
		"Surely, Psydon will return to observe the quality of your cargo.",
		"The Captain is most pleased.",
		"Tis was worth the crossing of half the world.",
		"The Company appreciates your efforts."
	)
