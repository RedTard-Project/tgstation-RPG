// The Crown's stockpile machines (Ratwood code/modules/roguetown/roguemachine/stockpile/stockpile.dm, withdraw_tab.dm and
// withdraw.dm): the stockpile buys goods from subjects for the Crown and pays into their NERVELOCK account; both it and the
// vomitorium sell the stock for inserted coins, or import a good the stockpile lacks at the carriers' price.

/obj/structure/roguemachine/stockpile/examine(mob/user)
	. = ..()
	. += span_info("Use a good on it to sell it to the Crown, right click to sell everything at its foot and mine.")

/obj/structure/roguemachine/withdraw/examine(mob/user)
	. = ..()
	. += span_info("Insert mammons, then buy goods from the Crown's stockpile. It does not buy goods.")

/obj/structure/roguemachine/stockpile/interact(mob/user)
	if(!ishuman(user))
		return FALSE
	playsound(src, ROGUE_SOUND_KEYBOARD, 100, FALSE, -1)
	return ..()

/obj/structure/roguemachine/withdraw/interact(mob/user)
	if(!ishuman(user))
		return FALSE
	playsound(src, ROGUE_SOUND_KEYBOARD, 100, FALSE, -1)
	return ..()

/obj/structure/roguemachine/stockpile/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.combat_mode)
		return NONE
	if(istype(tool, /obj/item/roguecoin))
		take_coins(tool, user)
		return ITEM_INTERACT_SUCCESS
	sell_to_crown(tool, user)
	return ITEM_INTERACT_SUCCESS

/obj/structure/roguemachine/withdraw/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.combat_mode || !istype(tool, /obj/item/roguecoin))
		return NONE
	take_coins(tool, user)
	return ITEM_INTERACT_SUCCESS

/// Right click sells everything lying under the machine and under the seller (Ratwood attack_right(), bulk selling).
/obj/structure/roguemachine/stockpile/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || !ishuman(user))
		return
	if(!SSrogue_treasury.get_account(user))
		refuse("No account found for [user]. Submit your fingers to a Nervelock for inspection.")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	var/sold = 0
	var/list/spots = list(get_turf(src))
	spots |= get_turf(user)
	for(var/turf/spot as anything in spots)
		for(var/obj/item/thing in spot)
			if(!istype(thing, /obj/item/roguecoin) && sell_to_crown(thing, user, quietly = TRUE))
				sold++
	say(sold ? "Bulk selling in progress..." : "Nothing here is accepted.")
	playsound(src, ROGUE_SOUND_HISS, 100, FALSE, -1)
	if(sold)
		playsound(src, ROGUE_SOUND_FLUSH, 100, FALSE, -1)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/**
 * Sells an item to the Crown (Ratwood attemptsell()): the good goes into the stockpile and its payout from the Crown's Purse
 * into the seller's account. A stack sells every unit. Refused when the seller has no account, the Crown does not want the good,
 * the Purse is below the Steward's floor, or the stockpile is full and may not ship the surplus abroad; a full stockpile that may
 * ship it sends the good abroad at once. Returns TRUE when sold.
 */
/obj/structure/roguemachine/stockpile/proc/sell_to_crown(obj/item/thing, mob/living/seller, quietly = FALSE)
	var/datum/bank_account/rogue/account = SSrogue_treasury.get_account(seller)
	if(!account)
		if(!quietly)
			refuse("No account found for [seller]. Submit your fingers to a Nervelock for inspection.")
		return FALSE
	var/datum/roguestock/stock = SSrogue_treasury.stock_for(thing)
	if(!stock)
		if(!quietly)
			refuse("[thing.name] is not accepted here.")
		return FALSE
	if(!stock.accept_toggle_enabled)
		if(!quietly)
			refuse("The Crown has no interest in [stock.name] at this time.")
		return FALSE
	var/datum/bank_account/rogue/crown/purse = SSrogue_treasury.crown_purse
	if(purse.account_balance < SSrogue_treasury.stockpile_purchase_floor)
		if(!quietly)
			refuse("The Crown's ledger is thin. No purchases today.")
		return FALSE
	var/units = 1
	if(isstack(thing))
		var/obj/item/stack/pile = thing
		units = max(1, pile.get_amount())
	var/full = stock.stockpile_amount + units > stock.stockpile_limit
	if(full && stock.autoexport_disabled)
		if(!quietly)
			refuse("The Crown's [stock.name] stockpile is full, take it elsewhere.")
		return FALSE
	var/payout = stock.payout_price * units
	if(!purse.has_money(payout))
		if(!quietly)
			refuse("The Crown cannot afford it.")
		return FALSE
	var/value = thing.get_real_price()
	var/withdrawn = thing.stockpile_withdrawn
	qdel(thing)
	stock.stockpile_amount += units
	if(full)
		SSrogue_treasury.export_stock(stock, stock.stockpile_amount - stock.stockpile_limit)
	if(!withdrawn)
		SSrogue_treasury.economic_output += value
	SSrogue_treasury.give_money(account, payout, "+[payout] from [stock.name] bounty")
	if(!quietly)
		say(full ? "Crown's [stock.name] stockpile is full - shipped abroad on your behalf." : "[stock.name] has been stockpiled.")
		playsound(src, ROGUE_SOUND_HISS, 100, FALSE, -1)
	SStgui.update_uis(src)
	return TRUE

// The stock window, shared by the stockpile and the vomitorium.

/obj/structure/roguemachine/stockpile/ui_interact(mob/user, datum/tgui/ui)
	rogue_stock_ui(user, ui)

/obj/structure/roguemachine/withdraw/ui_interact(mob/user, datum/tgui/ui)
	rogue_stock_ui(user, ui)

/obj/structure/roguemachine/stockpile/ui_data(mob/user)
	return rogue_stock_data(user, TRUE)

/obj/structure/roguemachine/withdraw/ui_data(mob/user)
	return rogue_stock_data(user, FALSE)

/obj/structure/roguemachine/stockpile/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(!.)
		return rogue_stock_act(action, params, ui.user)

/obj/structure/roguemachine/withdraw/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(!.)
		return rogue_stock_act(action, params, ui.user)

/obj/structure/roguemachine/proc/rogue_stock_ui(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RogueStockpile", name)
		ui.open()

/obj/structure/roguemachine/proc/rogue_stock_data(mob/user, buys)
	var/list/data = list()
	data["buys"] = buys
	data["budget"] = budget
	data["fiscal"] = rogue_fiscal_authority(user)
	data["has_account"] = !!SSrogue_treasury.get_account(user)
	data["below_floor"] = SSrogue_treasury.crown_purse?.account_balance < SSrogue_treasury.stockpile_purchase_floor
	var/list/stocks = list()
	for(var/datum/roguestock/stock as anything in SSrogue_treasury.stockpile_datums)
		stocks += list(stock.ui_entry())
	data["stocks"] = stocks
	return data

/obj/structure/roguemachine/proc/rogue_stock_act(action, list/params, mob/user)
	switch(action)
		if("refund")
			return_change(user)
			return TRUE
		if("withdraw", "import")
			var/datum/roguestock/stock = locate(params["ref"]) in SSrogue_treasury.stockpile_datums
			if(stock)
				buy_stock(stock, user, action == "import")
			return TRUE

/**
 * Buys one unit of a good with the budget (Ratwood do_withdraw() and do_direct_import()). From the stockpile the price goes to the
 * Crown's Purse; a good the stockpile lacks is imported at the carriers' price, which leaves the realm.
 */
/obj/structure/roguemachine/proc/buy_stock(datum/roguestock/stock, mob/user, import = FALSE)
	if(!ishuman(user) || !user.Adjacent(src))
		return FALSE
	if(stock.withdraw_disabled && !rogue_fiscal_authority(user))
		refuse("Not available.")
		return FALSE
	if(!import && stock.stockpile_amount <= 0)
		refuse("Insufficient stock.")
		return FALSE
	var/price = import ? stock.import_price() : stock.withdraw_price
	if(price > budget)
		refuse("Insufficient mammon.")
		return FALSE
	budget -= price
	if(import)
		SSrogue_treasury.total_import += price
	else
		stock.stockpile_amount--
		SSrogue_treasury.mint(SSrogue_treasury.crown_purse, price, "Stockpile Withdraw: [stock.name]")
	var/obj/item/bought = new stock.item_type(drop_location())
	bought.stockpile_withdrawn = TRUE
	user.put_in_hands(bought)
	if(istype(src, /obj/structure/roguemachine/withdraw))
		flick("submit_anim", src)
	playsound(src, ROGUE_SOUND_HISS, 100, FALSE, -1)
	SStgui.update_uis(src)
	return TRUE
