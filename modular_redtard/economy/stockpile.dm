/**
 * One good of the Crown's stockpile (Ratwood code/modules/roguetown/roguestock/_roguestock.dm): how many are held, what the
 * Crown pays a seller (payout), what a buyer pays at the vomitorium (withdraw), what it fetches abroad (export). The entries are
 * Ratwood's, ported with their goods (economy/ported/stockpile.dm); prices come from the good's trade price the way Ratwood's
 * pricing engine sets them without market swings, or from the entry's own prices for goods without one.
 */
/datum/roguestock
	var/name = ""
	var/desc = ""
	/// The good itself; its subtypes count too.
	var/obj/item/item_type
	/// Tab of the stockpile window.
	var/category = "Raw Materials"
	/// Trade price of the good (Ratwood /datum/trade_good base_price × global_price_mod); sets the three prices below.
	var/base_price
	var/payout_price = 1
	var/withdraw_price = 1
	var/export_price = 1
	var/stockpile_amount = 0
	var/stockpile_limit = 100
	/// Units shipped in one export (Ratwood importexport_amt).
	var/importexport_amt = 10
	/// Units the Crown buys in from afar every treasury tick while below the limit, and the price of each (Ratwood passive import).
	var/passive_generation = 0
	var/generation_price = 1
	/// The Crown buys this good from sellers (the Steward's toggle).
	var/accept_toggle_enabled = TRUE
	/// Only the Crown's officers may withdraw it.
	var/withdraw_disabled = FALSE
	var/import_only = FALSE
	var/export_only = FALSE
	/// The Crown keeps the surplus instead of shipping it abroad.
	var/autoexport_disabled = FALSE
	/// The trade good this entry stocks (Ratwood trade_good_id), linked by the trade subsystem; regions import it.
	var/datum/rogue_trade_good/trade_good

/datum/roguestock/New()
	. = ..()
	if(base_price)
		set_prices(base_price)
	else
		export_price = payout_price

/// Ratwood compute_auto_prices(): the stockpile sells at the trade price and pays a seller below what export fetches.
/datum/roguestock/proc/set_prices(unit)
	var/export_ref = max(1, round(unit * (1 - ROGUE_TRADE_SPREAD)))
	payout_price = max(1, min(round(export_ref * (1 - ROGUE_TRADE_SPREAD)), export_ref - 1))
	withdraw_price = max(1, round(unit))
	export_price = export_ref

/// The stockpile takes this item for this good (Ratwood check_item()).
/datum/roguestock/proc/accepts(obj/item/thing)
	return !import_only && istype(thing, item_type)

/**
 * What the Crown pays a seller for units of this good of the item's quality (Ratwood get_quality_settlement()): the price moves
 * by the quality tier, and the seller bears a further share of the difference from standard, which the Crown's Purse gains on
 * shoddy goods and adds on fine ones. Returns list("payout" =, "crown_delta" =, "baseline" =).
 */
/datum/roguestock/proc/quality_settlement(obj/item/thing, units = 1)
	var/baseline = payout_price * units
	var/list/settlement = list("payout" = baseline, "crown_delta" = 0, "baseline" = baseline)
	if(isnull(thing.rogue_quality))
		return settlement
	var/q_mult = rogue_quality_price_mult(thing.rogue_quality)
	if(q_mult == 1)
		return settlement
	var/share = rogue_value("trade_quality_seller_share")
	var/loss = baseline - baseline * q_mult
	settlement["payout"] = max(1, round(baseline * q_mult - loss * share))
	settlement["crown_delta"] = round(-loss * (1 - share))
	return settlement

/**
 * Price of buying the good in from afar when the stockpile has none (Ratwood get_direct_import_quote()): the cheapest region
 * that produces it today, with the carriers' margin. Returns list("region" =, "unit_cost" =, "price" =), or null when no
 * region produces it.
 */
/datum/roguestock/proc/import_quote()
	var/list/quote = SSrogue_trade.import_quote(trade_good)
	if(quote)
		quote["price"] = max(1, round(quote["unit_cost"] * (100 + rogue_value("trade_import_margin")) / 100))
	return quote

/datum/roguestock/proc/import_price()
	var/list/quote = import_quote()
	return quote ? quote["price"] : 0

/datum/roguestock/proc/ui_entry()
	var/list/quote = import_quote()
	var/datum/rogue_trade_region/import_region = quote ? quote["region"] : null
	return list(
		"ref" = REF(src),
		"name" = name,
		"desc" = desc,
		"category" = category,
		"amount" = stockpile_amount,
		"limit" = stockpile_limit,
		"withdraw_price" = withdraw_price,
		"payout_price" = payout_price,
		"export_price" = export_price,
		"import_price" = quote ? quote["price"] : 0,
		"import_region" = import_region?.name,
		"withdraw_disabled" = withdraw_disabled,
		"accept_enabled" = accept_toggle_enabled,
		"autoexport_disabled" = autoexport_disabled,
	)
