/**
 * A merchant's import pack (Ratwood code/modules/cargo/packsrogue/_pack.dm, /datum/supply_pack/rogue): the GOLDFACE sells it for
 * its cost and hands out what it contains. The packs are Ratwood's, ported with their contents (economy/ported/supply_packs.dm);
 * a pack whose contents are not all ported yet stays in Ratwood. Not TG's /datum/supply_pack: these never reach TG's cargo.
 */
/datum/rogue_supply_pack
	var/name = "Crate"
	/// Category of the GOLDFACE catalog.
	var/group = ""
	var/cost = 700
	var/list/contains
	/// Public SILVERFACEs do not sell it.
	var/not_in_public = FALSE
	/// Shown as one item however many it holds.
	var/no_name_quantity = FALSE
	var/static_cost = FALSE

/// Ratwood's import prices vary by up to a tenth each round.
/datum/rogue_supply_pack/New()
	. = ..()
	var/spread = round(cost * 0.1)
	cost = max(rand(cost - spread, cost + spread), 1)

/// Every pack with something in it, path -> pack, priced once per round (Ratwood SSmerchant.supply_packs).
GLOBAL_LIST_INIT(rogue_supply_packs, init_rogue_supply_packs())

/proc/init_rogue_supply_packs()
	var/list/packs = list()
	for(var/pack_type in subtypesof(/datum/rogue_supply_pack))
		var/datum/rogue_supply_pack/pack = new pack_type
		if(length(pack.contains))
			packs[pack_type] = pack
	return packs
