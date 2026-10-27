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

/// Price of buying the good in from afar when the stockpile has none: Ratwood's direct import with the carriers' 50% margin.
/datum/roguestock/proc/import_price()
	return max(1, round(withdraw_price * 1.5))

/datum/roguestock/proc/ui_entry()
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
		"import_price" = import_price(),
		"withdraw_disabled" = withdraw_disabled,
		"accept_enabled" = accept_toggle_enabled,
		"autoexport_disabled" = autoexport_disabled,
	)
