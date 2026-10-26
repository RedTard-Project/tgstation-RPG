/// What the item melts into in a smelter (Ratwood smeltresult); the porter carries it over from Ratwood.
/obj/item/var/smeltresult
/// The skill that repairs the item with a hammer (Ratwood anvilrepair).
/obj/item/var/anvilrepair
/// The item mends with a needle or a sewing kit (Ratwood sewrepair).
/obj/item/var/sewrepair = FALSE
/// Quality tier stamped by the smelter or the anvil, ROGUE_QUALITY_*; null - no quality (Ratwood item_quality, has_item_quality).
/obj/item/var/rogue_quality
/// Repaired by an unskilled hand: it holds only 60% until a craftsman finishes it (Ratwood shoddy_repair).
/obj/item/var/shoddy_repair = FALSE

/// Ratwood declares coverage on the Daemonslayer itself (rogueweapons/melee/swords/greatswords.dm); the anvil recipe ports
/// the sword and the porter carries the number. Declared on the berserker sword parent because ported/items.dm sets it
/// before this file is included. Only shields read coverage in the module (combat/shields.dm).
/obj/item/rogueweapon/sword/long/exe/berserk
	var/coverage = 0

/// Ratwood ITEM_QUALITY_PREFIX_*.
/proc/rogue_quality_prefix(quality)
	switch(quality)
		if(ROGUE_QUALITY_RUINED)
			return "ruined"
		if(ROGUE_QUALITY_AWFUL)
			return "awful"
		if(ROGUE_QUALITY_CRUDE)
			return "crude"
		if(ROGUE_QUALITY_ROUGH)
			return "rough"
		if(ROGUE_QUALITY_FINE)
			return "fine"
		if(ROGUE_QUALITY_FLAWLESS)
			return "flawless"
		if(ROGUE_QUALITY_MASTERWORK)
			return "masterwork"
	return null

/obj/item/examine(mob/user)
	. = ..()
	if(shoddy_repair)
		. += span_warning("This item has been field-repaired and needs to be fixed by a proper craftsman.")
	if((anvilrepair || sewrepair) && isliving(user))
		var/mob/living/reader = user
		if(reader.rogue_stat(ROGUE_STAT_INTELLIGENCE) < 9)
			return
		var/list/ways = list()
		if(anvilrepair)
			var/datum/attribute/skill/skill = GET_ROGUE_ATTRIBUTE(anvilrepair)
			ways += "<b>[skill?.name]</b> and a hammer"
		if(sewrepair)
			ways += "<b>Sewing</b> and a needle"
		. += span_info("This object can be repaired using [english_list(ways, and_text = " or ")].")

/// Ratwood ingot quality (miner/rogueores.dm apply_smelt_quality()): the smelter's tier becomes the bar's prefix.
/obj/item/ingot/Initialize(mapload, smelt_quality)
	. = ..()
	if(smelt_quality)
		rogue_set_ingot_quality(smelt_quality)

/obj/item/ingot/proc/rogue_set_ingot_quality(quality)
	rogue_quality = quality
	var/prefix = rogue_quality_prefix(quality)
	name = prefix ? "[prefix] [initial(name)]" : initial(name)
	switch(quality)
		if(ROGUE_QUALITY_AWFUL)
			desc = "[initial(desc)] It is practically scrap."
		if(ROGUE_QUALITY_CRUDE)
			desc = "[initial(desc)] It is of dubious quality."
		if(ROGUE_QUALITY_FINE)
			desc = "[initial(desc)] It is of notable quality."
		if(ROGUE_QUALITY_FLAWLESS)
			desc = "[initial(desc)] It is of remarkable quality. Fit for ambitious endeavours."
		if(ROGUE_QUALITY_MASTERWORK)
			desc = "[initial(desc)] It is of exquisite quality. It [pick("yearns", "begs", "demands")] to be turned into a masterwork."
		else
			desc = initial(desc)

/// A bar's quality for the anvil: mapped ingots without a smelter's stamp are standard.
/obj/item/proc/rogue_material_quality()
	return isnull(rogue_quality) ? ROGUE_QUALITY_STANDARD : rogue_quality

/obj/item/ingot/examine(mob/user)
	. = ..()
	var/datum/component/rogue_forging/forging = GetComponent(/datum/component/rogue_forging)
	if(forging?.recipe)
		. += span_warning("It is currently being worked on to become [forging.recipe.name].")
