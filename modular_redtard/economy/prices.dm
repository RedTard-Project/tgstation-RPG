/// Money and trade run on medieval maps only; modern maps keep TG's credits.
/proc/rogue_economy_enabled()
	return SSmapping.current_map?.map_era == MAP_ERA_MEDIEVAL

/atom/movable
	/// What the thing is worth in mammons (Ratwood sellprice, code/modules/cargo/exports.dm); the porter carries it over from Ratwood.
	var/sellprice = 0
	/// The worth is exact; otherwise it drifts by up to 13% the first time the thing is priced (Ratwood static_price).
	var/static_price = FALSE

/obj/item
	/// Anyone can tell what this is worth, not only an appraiser (Ratwood simpleton_price: coins).
	var/simpleton_price = FALSE
	/// Bought from the Crown's stockpile, so selling it back adds nothing to the Crown's trade tally (Ratwood stockpile_withdrawn).
	var/stockpile_withdrawn = FALSE

/// Ratwood randomize_price(): a thing not priced exactly is worth up to 13% more or less, settled when it is first priced.
/atom/movable/proc/randomize_price()
	if(sellprice && !static_price)
		var/spread = max(round(sellprice * 0.13, 1), 1)
		sellprice = max(rand(sellprice - spread, sellprice + spread), 1)
	return sellprice

/// What the thing fetches in mammons (Ratwood get_real_price()).
/atom/movable/proc/get_real_price()
	if(sellprice == initial(sellprice))
		randomize_price()
	return sellprice

/// The worth of the thing with everything inside it, for appraisal (Ratwood appraise_price()).
/atom/movable/proc/appraise_price()
	. = get_real_price()
	for(var/obj/item/inside in src)
		. += inside.appraise_price()

/// Ratwood's value line on examine (code/game/objects/examine.dm): an appraiser (Skilled Appraiser) and ghosts see the worth,
/// a poor appraiser a guess within a quarter, others "Unknown"; coins show their worth to anyone. Things worth nothing say nothing.
/obj/item/examine(mob/user)
	. = ..()
	if(!rogue_economy_enabled())
		return
	var/value = appraise_price()
	if(value <= 0)
		return
	if(simpleton_price || isobserver(user) || HAS_TRAIT(user, TRAIT_SEEPRICES))
		. += span_info("Value: [value] mammon.")
	else if(HAS_TRAIT(user, TRAIT_SEEPRICES_SHITTY))
		var/fumble = ((value * 7919 + (text2num(GLOB.round_id) || 0)) % 51 - 25) / 100
		. += span_info("Value: ~[max(1, round(value * (1 + fumble)))] mammon (uncertain).")
	else
		. += span_info("Value: Unknown.")
