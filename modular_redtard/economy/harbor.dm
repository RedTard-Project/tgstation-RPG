/**
 * The ship fulfillment crate (Ratwood merchant/trade/fulfillment_crate.dm and the harbor tab of merchant/_goldface.dm): the
 * harbor of the realm. Anyone with a NERVELOCK account deposits goods that docked ships demand and is paid to the account, less
 * the Crown's export duty and the merchant's middleman cut. The merchant and the shophand hail ships into port, send them away,
 * buy the cargo the ships sell with coins inserted into the crate (paying the Crown's import tariff), set the middleman cut and
 * may stop paying the Crown's duties here. Ratwood's kinship, favor, victualling, kegs, handcarts and the trading company's
 * seal are not ported.
 */
/obj/structure/roguemachine/ship_fulfillment
	/// Roles that run the harbor (Ratwood profit_id).
	var/list/profit_jobs = list(JOB_ROCKHILL_MERCHANT, JOB_ROCKHILL_SHOPHAND)
	/// The merchant stopped paying the Crown's export duty and import tariff here (Ratwood duty_suspended).
	var/duty_dodged = FALSE
	/// Crown duties paid and dodged here, for the merchant's audit.
	var/duty_collected = 0
	var/duty_evaded = 0

/obj/structure/roguemachine/ship_fulfillment/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/structure/roguemachine/ship_fulfillment/update_overlays()
	. = ..()
	set_light(1, 1, "#c8a060")
	. += mutable_appearance(icon, "vendor-merch")

/obj/structure/roguemachine/ship_fulfillment/examine(mob/user)
	. = ..()
	. += span_info("Use a good on the crate to sell it to a docked ship that wants it, right click to sell everything at my feet. A NERVELOCK account is needed.")
	var/buying = 0
	for(var/datum/rogue_trade_ship/ship as anything in SSrogue_trade.docked_ships())
		for(var/list/line as anything in ship.demands)
			if(line[ROGUE_LINE_DONE] < line[ROGUE_LINE_TARGET])
				buying++
				break
	if(buying)
		. += span_info("[buying] vessel\s at the pier seek[buying == 1 ? "s" : ""] goods. Look into the crate for the manifest.")
	else
		. += span_info("No vessels currently buying.")

/// The merchant and the shophand work the harbor (Ratwood can_manage()).
/obj/structure/roguemachine/ship_fulfillment/proc/can_manage(mob/user)
	return ishuman(user) && (user.mind?.assigned_role?.title in profit_jobs)

/obj/structure/roguemachine/ship_fulfillment/interact(mob/user)
	if(!ishuman(user))
		return FALSE
	if(can_manage(user))
		SSrogue_trade.touch_merchant_activity()
	playsound(src, ROGUE_SOUND_GOLD_MENU, 100, FALSE, -1)
	return ..()

/obj/structure/roguemachine/ship_fulfillment/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.combat_mode)
		return NONE
	if(istype(tool, /obj/item/roguecoin))
		take_coins(tool, user)
		return ITEM_INTERACT_SUCCESS
	deposit(tool, user)
	SStgui.update_uis(src)
	return ITEM_INTERACT_SUCCESS

/// Right click sells everything at the seller's feet to the ships, paid in one sum (Ratwood attack_right()).
/obj/structure/roguemachine/ship_fulfillment/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || !ishuman(user))
		return
	if(!SSrogue_treasury.get_account(user))
		refuse("No account found for [user]. Submit your fingers to a Nervelock for inspection.")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	var/list/tally = list("producer" = 0, "gross" = 0, "duty" = 0, "cut" = 0, "quality" = 0, "lines" = list())
	for(var/obj/item/thing in get_turf(user))
		if(!istype(thing, /obj/item/roguecoin))
			deposit(thing, user, tally)
	flush_tally(tally, user)
	say("Bulk fulfillment in progress...")
	playsound(src, ROGUE_SOUND_HISS, 100, FALSE, -1)
	playsound(src, ROGUE_SOUND_FLUSH, 100, FALSE, -1)
	SStgui.update_uis(src)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/**
 * Sells an item to the first docked ship whose demand line takes it (Ratwood attempt_deposit()): a stack sells as many units as
 * the line still wants, the price follows the item's quality. With a tally (bulk selling) the payout waits for flush_tally().
 * Returns TRUE when something was sold.
 */
/obj/structure/roguemachine/ship_fulfillment/proc/deposit(obj/item/thing, mob/living/user, list/tally)
	var/datum/bank_account/rogue/account = SSrogue_treasury.get_account(user)
	if(!account)
		if(!tally)
			refuse("No account found for [user]. Submit your fingers to a Nervelock for inspection.")
		return FALSE
	var/datum/rogue_trade_good/good = SSrogue_trade.good_for(thing)
	if(!good)
		if(!tally)
			to_chat(user, span_warning("[thing] is not something a foreign vessel would buy in bulk."))
		return FALSE
	var/list/match = SSrogue_trade.find_demand(good)
	if(!match)
		if(!tally)
			to_chat(user, span_warning("No vessel here is buying [thing]."))
		return FALSE
	var/datum/rogue_trade_ship/ship = match[1]
	var/list/line = match[2]
	var/units = 1
	var/obj/item/stack/pile = isstack(thing) ? thing : null
	if(pile)
		units = min(pile.get_amount(), line[ROGUE_LINE_TARGET] - line[ROGUE_LINE_DONE])
	if(units <= 0)
		return FALSE
	var/unit_price = round(line[ROGUE_LINE_PRICE] * rogue_quality_price_mult(thing.rogue_quality))
	var/quality_delta = (unit_price - line[ROGUE_LINE_PRICE]) * units
	if(!tally && thing.rogue_has_notable_quality())
		var/remark = rogue_harbor_quality_remark(thing.rogue_quality)
		if(remark)
			say(remark)
	line[ROGUE_LINE_DONE] += units
	if(pile && units < pile.get_amount())
		pile.use(units)
	else
		qdel(thing)
	settle(unit_price * units, user, account, ship, good.name, units, tally, quality_delta)
	return TRUE

/// Where the merchant's middleman cut goes: the merchant's fund, or the merchant's own account without one.
/obj/structure/roguemachine/ship_fulfillment/proc/middleman_account()
#ifdef ROGUE_FUND_MERCHANT
	var/datum/bank_account/fund = SSrogue_treasury.get_fund(ROGUE_FUND_MERCHANT)
	if(fund)
		return fund
#endif
	for(var/datum/bank_account/rogue/account as anything in SSrogue_treasury.accounts)
		if(account.job_title() == JOB_ROCKHILL_MERCHANT && account.owner())
			return account
	return null

/**
 * Pays a ship sale (Ratwood settle_payout()): the Crown's export duty on the sale and on the merchant's cut goes to the Crown's
 * Purse, the cut less its duty to the merchant, the rest to the seller. Money from abroad is new to the realm.
 */
/obj/structure/roguemachine/ship_fulfillment/proc/settle(gross, mob/living/user, datum/bank_account/rogue/account, datum/rogue_trade_ship/ship, good_name, units, list/tally, quality_delta)
	if(gross <= 0)
		return
	var/datum/bank_account/middleman = middleman_account()
	var/cut = middleman ? gross * SSrogue_trade.middleman_cut / 100 : 0
	var/duty_rate = SSrogue_treasury.get_tax_rate(ROGUE_TAX_EXPORT)
	var/duty_on_gross = round(gross * duty_rate)
	var/duty_on_cut = round(cut * duty_rate)
	var/duty = 0
	if(duty_dodged)
		duty_evaded += duty_on_gross + duty_on_cut
		duty_on_gross = 0
		duty_on_cut = 0
	else
		duty = duty_on_gross + duty_on_cut
		if(SSrogue_treasury.mint(SSrogue_treasury.crown_purse, duty, "[ROGUE_TAX_EXPORT] (ship fulfillment)"))
			duty_collected += duty
			SSrogue_trade.total_export_duty += duty
	var/merchant_net = round(cut) - duty_on_cut
	if(merchant_net > 0)
		SSrogue_treasury.mint(middleman, merchant_net, "Merchant's levy: [units] [good_name] -> [ship.name]")
	var/producer = max(0, gross - duty_on_gross - round(cut))
	ship.traded += gross
	SSrogue_trade.total_ship_sales += gross
	playsound(src, ROGUE_SOUND_HISS, 70, TRUE, -1)
	if(tally)
		tally["producer"] += producer
		tally["gross"] += gross
		tally["duty"] += duty
		tally["cut"] += max(0, merchant_net)
		tally["quality"] += quality_delta
		var/key = "[units] [good_name] -> [ship.name]"
		var/list/lines = tally["lines"]
		lines += key
		return
	if(producer > 0 && SSrogue_treasury.mint(account, producer, "[units] [good_name] for [ship.name]: gross [gross]m, Crown [duty]m, Merchant [max(0, merchant_net)]m[quality_delta ? ", quality [quality_delta > 0 ? "+" : ""][quality_delta]m" : ""]"))
		account.bank_card_talk("You received [producer]m. ([units] [good_name] for [ship.name])")

/// Pays the whole of a bulk sale at once (Ratwood flush_tally()).
/obj/structure/roguemachine/ship_fulfillment/proc/flush_tally(list/tally, mob/living/user)
	var/datum/bank_account/rogue/account = SSrogue_treasury.get_account(user)
	if(!account || tally["producer"] <= 0)
		if(!length(tally["lines"]))
			to_chat(user, span_warning("No vessel here is buying anything at my feet."))
		return
	var/quality = tally["quality"]
	if(SSrogue_treasury.mint(account, tally["producer"], "[english_list(tally["lines"])]: gross [tally["gross"]]m, Crown [tally["duty"]]m, Merchant [tally["cut"]]m[quality ? ", quality [quality > 0 ? "+" : ""][quality]m" : ""]"))
		account.bank_card_talk("You received [tally["producer"]]m. (bulk sale to the ships)")
	if(quality)
		var/remark = rogue_harbor_quality_remark(quality > 0 ? ROGUE_QUALITY_MASTERWORK : ROGUE_QUALITY_CRUDE)
		if(remark)
			say(remark)

/**
 * The merchant buys cargo a docked ship sells (Ratwood bulk_buy of the GOLDFACE): paid from the coins in the crate, with the
 * Crown's import tariff unless the merchant dodges it; the goods come out at the crate.
 */
/obj/structure/roguemachine/ship_fulfillment/proc/buy_cargo(datum/rogue_trade_ship/ship, good_id, qty, mob/living/user)
	if(!ship || ship.state != ROGUE_SHIP_DOCKED)
		to_chat(user, span_warning("That vessel is no longer at the pier."))
		return FALSE
	var/list/line
	for(var/list/supply as anything in ship.supplies)
		var/datum/rogue_trade_good/good = supply[ROGUE_LINE_GOOD]
		if(good.id == good_id)
			line = supply
			break
	if(!line)
		to_chat(user, span_warning("That cargo is no longer on offer."))
		return FALSE
	qty = min(round(qty), line[ROGUE_LINE_TARGET] - line[ROGUE_LINE_DONE], rogue_value("trade_bulk_buy_max"))
	if(qty < 1)
		to_chat(user, span_warning("That cargo is sold out."))
		return FALSE
	var/datum/rogue_trade_good/good = line[ROGUE_LINE_GOOD]
	var/gross = line[ROGUE_LINE_PRICE] * qty
	var/tariff = round(SSrogue_treasury.get_tax_rate(ROGUE_TAX_IMPORT) * gross)
	var/total = gross + (duty_dodged ? 0 : tariff)
	if(budget < total)
		say("Not enough!")
		return FALSE
	budget -= total
	line[ROGUE_LINE_DONE] += qty
	if(duty_dodged)
		duty_evaded += tariff
	else if(SSrogue_treasury.mint(SSrogue_treasury.crown_purse, tariff, "[ROGUE_TAX_IMPORT] (bulk import: [good.name] x[qty])"))
		duty_collected += tariff
		SSrogue_treasury.total_tariff += tariff
	ship.traded += gross
	SSrogue_trade.total_ship_purchases += total
	var/turf/spot = drop_location()
	var/cargo_type = good.item_type
	for(var/i in 1 to qty)
		new cargo_type(spot)
	playsound(src, ROGUE_SOUND_GOLD_MISC, 70, FALSE, -1)
	to_chat(user, span_notice("You buy [qty] [good.name] from [ship.name] for [total]m[!duty_dodged && tariff ? " (incl. [tariff]m Crown duty)" : ""]."))
	return TRUE

/obj/structure/roguemachine/ship_fulfillment/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RogueHarbor", name)
		ui.open()

/obj/structure/roguemachine/ship_fulfillment/ui_data(mob/user)
	var/list/data = list()
	var/manager = can_manage(user)
	data["budget"] = budget
	data["manager"] = manager
	data["has_account"] = !!SSrogue_treasury.get_account(user)
	data["duty_dodged"] = duty_dodged
	data["duty_rate"] = round(SSrogue_treasury.get_tax_rate(ROGUE_TAX_EXPORT) * 100)
	data["tariff_rate"] = round(SSrogue_treasury.get_tax_rate(ROGUE_TAX_IMPORT) * 100)
	data["middleman_cut"] = SSrogue_trade.middleman_cut
	data["duty_collected"] = duty_collected
	data["duty_evaded"] = duty_evaded
	data["hails_left"] = SSrogue_trade.hails_left
	data["dock_spots"] = SSrogue_trade.dock_spots()
	var/list/docked = list()
	for(var/datum/rogue_trade_ship/ship as anything in SSrogue_trade.docked_ships())
		docked += list(ship.ui_entry())
	data["docked"] = docked
	var/list/offshore = list()
	if(manager)
		for(var/datum/rogue_trade_ship/ship as anything in SSrogue_trade.offshore_ships())
			offshore += list(ship.ui_entry())
	data["offshore"] = offshore
	return data

/obj/structure/roguemachine/ship_fulfillment/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/living/user = ui.user
	if(action == "change")
		return_change(user)
		return TRUE
	if(!can_manage(user))
		return TRUE
	SSrogue_trade.touch_merchant_activity()
	switch(action)
		if("hail")
			var/failure = SSrogue_trade.hail(SSrogue_trade.find_ship(text2num("[params["id"]]")), user)
			if(failure)
				to_chat(user, span_warning(failure))
				refuse()
			else
				playsound(src, ROGUE_SOUND_GOLD_MISC, 70, FALSE, -1)
			return TRUE
		if("send_away")
			var/failure = SSrogue_trade.send_away(SSrogue_trade.find_ship(text2num("[params["id"]]")))
			if(failure)
				to_chat(user, span_warning(failure))
				refuse()
			return TRUE
		if("buy")
			buy_cargo(SSrogue_trade.find_ship(text2num("[params["id"]]")), "[params["good"]]", text2num("[params["qty"]]"), user)
			return TRUE
		if("set_cut")
			var/percent = tgui_input_number(user, "Merchant's middleman cut of every ship sale, in percent:", name, SSrogue_trade.middleman_cut, rogue_value("trade_middleman_cut_max"), 0)
			if(isnull(percent) || QDELETED(src) || !can_manage(user))
				return TRUE
			SSrogue_trade.middleman_cut = clamp(round(percent), 0, rogue_value("trade_middleman_cut_max"))
			to_chat(user, span_notice("Merchant's levy set to [SSrogue_trade.middleman_cut]%."))
			return TRUE
		if("toggle_duty")
			duty_dodged = !duty_dodged
			to_chat(user, span_notice("Crown duties now [duty_dodged ? "DODGED" : "PAID"] at this crate."))
			playsound(src, ROGUE_SOUND_GOLD_MISC, 70, FALSE, -1)
			return TRUE
