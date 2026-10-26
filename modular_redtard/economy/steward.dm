/**
 * Nerve master (Ratwood code/modules/roguetown/roguemachine/steward/steward.dm): the Steward's desk of the treasury. The steward's
 * key (or the lord's master key) locks it. Open, it shows the Crown's Purse and its ledger, takes coins into the Purse and pays the
 * Purse out in coin, sets the wage of every role and the Crown's levies, grants and fines the subjects' accounts, holds back a
 * subject's wages, and runs the stockpile: prices, limits, what the Crown buys and sells, shipments abroad.
 * Ratwood's trade regions, loans, decrees, poll tax and crown imports are not ported.
 */
/obj/structure/roguemachine/steward
	var/locked = FALSE
	/// Lockid of the key that locks it; the lord's master key works too.
	var/keycontrol = "steward"
	/// Roles never paid a wage, left out of the wage list (Ratwood excluded_jobs).
	var/static/list/unpaid_jobs = list(JOB_ROCKHILL_WRETCH, JOB_ROCKHILL_VAGABOND, JOB_ROCKHILL_ADVENTURER)

/obj/structure/roguemachine/steward/update_icon_state()
	icon_state = locked ? "steward_machine_off" : "steward_machine"
	return ..()

/obj/structure/roguemachine/steward/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.combat_mode)
		return NONE
	if(istype(tool, /obj/item/roguekey) || istype(tool, /obj/item/storage/keyring))
		if(!rockhill_key_fits(tool, keycontrol, TRUE))
			to_chat(user, span_warning("Wrong key."))
			return ITEM_INTERACT_BLOCKING
		locked = !locked
		playsound(src, ROGUE_SOUND_BEEP, 100, FALSE, -1)
		update_appearance()
		if(locked)
			SStgui.close_uis(src)
		return ITEM_INTERACT_SUCCESS
	if(istype(tool, /obj/item/roguecoin))
		if(!rogue_coin_accepted(tool))
			return ITEM_INTERACT_BLOCKING
		var/value = tool.get_real_price()
		qdel(tool)
		SSrogue_treasury.mint(SSrogue_treasury.crown_purse, value, "NERVE MASTER deposit")
		playsound(src, ROGUE_SOUND_COIN_INSERT, 100, FALSE, -1)
		SStgui.update_uis(src)
		return ITEM_INTERACT_SUCCESS
	return NONE

/obj/structure/roguemachine/steward/interact(mob/user)
	if(!ishuman(user))
		return FALSE
	if(locked)
		to_chat(user, span_warning("It's locked."))
		return TRUE
	return ..()

/obj/structure/roguemachine/steward/ui_interact(mob/user, datum/tgui/ui)
	if(locked)
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RogueStewardry", name)
		ui.open()

/obj/structure/roguemachine/steward/ui_data(mob/user)
	var/datum/controller/subsystem/rogue_treasury/treasury = SSrogue_treasury
	var/list/data = list()
	data["purse"] = treasury.crown_purse?.account_balance || 0
	data["floor"] = treasury.stockpile_purchase_floor
	data["ledger"] = rogue_ledger(treasury.crown_purse)
	data["totals"] = list(
		"rural_tax" = treasury.total_rural_tax,
		"tariff" = treasury.total_tariff,
		"wages" = treasury.total_wages,
		"export" = treasury.total_export,
		"import" = treasury.total_import,
		"trade" = treasury.economic_output,
	)
	var/list/levies = list()
	for(var/levy in treasury.tax_rates)
		levies += list(list("name" = levy, "percent" = round(treasury.tax_rates[levy] * 100, 1)))
	data["levies"] = levies
	data["levy_locked"] = treasury.levy_changed_dawn == GLOB.rockhill_dawns
	var/list/wages = list()
	for(var/datum/job/job as anything in SSjob.all_occupations)
		if(!istype(job, /datum/job/roguetown) || (job.title in unpaid_jobs))
			continue
		wages += list(list("title" = job.title, "wage" = treasury.daily_payments[job.title] || 0))
	data["wages"] = wages
	var/list/accounts = list()
	for(var/datum/bank_account/rogue/account as anything in treasury.accounts)
		accounts += list(list(
			"ref" = REF(account),
			"holder" = account.account_holder,
			"job" = account.job_title(),
			"balance" = account.account_balance,
			"estate" = account.estate_income,
			"suspended" = account.wages_suspended,
			"fined" = !!treasury.fined_today[account],
		))
	data["accounts"] = accounts
	var/list/stocks = list()
	for(var/datum/roguestock/stock as anything in treasury.stockpile_datums)
		stocks += list(stock.ui_entry())
	data["stocks"] = stocks
	return data

/obj/structure/roguemachine/steward/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(. || locked)
		return
	var/mob/living/user = ui.user
	var/datum/controller/subsystem/rogue_treasury/treasury = SSrogue_treasury
	switch(action)
		if("withdraw")
			var/amount = tgui_input_number(user, "Pay how many mammons out of the Crown's Purse?", name, 0, min(treasury.crown_purse.account_balance, ROGUE_TRANSFER_MAX), 0)
			if(!amount || !still_usable(user) || !treasury.burn(treasury.crown_purse, amount, "Withdrawn by [user.real_name]"))
				return TRUE
			rogue_coins_out(amount, user, null, src)
			log_game("TREASURY: [key_name(user)] withdrew [amount]m from the Crown's Purse")
		if("set_floor")
			var/floor = tgui_input_number(user, "The Crown buys nothing at the stockpile while the Purse holds less than:", name, treasury.stockpile_purchase_floor, ROGUE_TRANSFER_MAX, 0)
			if(!isnull(floor) && still_usable(user))
				treasury.stockpile_purchase_floor = floor
		if("set_levy")
			var/levy = params["name"]
			if(!(levy in treasury.tax_rates))
				return TRUE
			var/percent = tgui_input_number(user, "New [levy], in percent:", name, round(treasury.tax_rates[levy] * 100, 1), 100, 0)
			if(!isnull(percent) && still_usable(user))
				treasury.set_tax_rate(levy, percent, user)
		if("set_wage")
			var/title = params["title"]
			var/datum/job/roguetown/job = SSjob.get_job(title)
			if(!istype(job))
				return TRUE
			var/wage = tgui_input_number(user, "Daily wage of the [title]:", name, treasury.daily_payments[title] || 0, 500, 0)
			if(isnull(wage) || !still_usable(user))
				return TRUE
			if(wage)
				treasury.daily_payments[title] = wage
			else
				treasury.daily_payments -= title
	if(action in list("grant", "fine", "toggle_wages"))
		var/datum/bank_account/rogue/account = locate(params["ref"]) in treasury.accounts
		if(!account)
			return TRUE
		switch(action)
			if("grant")
				var/amount = tgui_input_number(user, "Grant [account.account_holder] how many mammons from the Crown's Purse?", name, 0, min(treasury.crown_purse.account_balance, ROGUE_TRANSFER_MAX), 0)
				if(amount && still_usable(user))
					treasury.give_money(account, amount, "Crown's grant")
			if("fine")
				var/amount = tgui_input_number(user, "Fine [account.account_holder] how many mammons?", name, 0, account.account_balance, 0)
				if(!amount || !still_usable(user))
					return TRUE
				var/reason = tgui_input_text(user, "For what?", name, "Fine", max_length = MAX_NAME_LEN)
				if(!still_usable(user))
					return TRUE
				if(!treasury.fine(account, amount, reason || "Fine"))
					to_chat(user, span_warning("[account.account_holder] has already been fined today, or has nothing to take."))
			if("toggle_wages")
				account.wages_suspended = !account.wages_suspended
	if(action in list("stock_payout", "stock_withdraw", "stock_limit", "stock_accept", "stock_lock", "stock_autoexport", "stock_export"))
		var/datum/roguestock/stock = locate(params["ref"]) in treasury.stockpile_datums
		if(!stock)
			return TRUE
		switch(action)
			if("stock_payout")
				var/price = tgui_input_number(user, "The Crown pays sellers of [stock.name]:", name, stock.payout_price, ROGUE_TRANSFER_MAX, 0)
				if(!isnull(price) && still_usable(user))
					stock.payout_price = price
			if("stock_withdraw")
				var/price = tgui_input_number(user, "The stockpile sells [stock.name] for:", name, stock.withdraw_price, ROGUE_TRANSFER_MAX, 1)
				if(!isnull(price) && still_usable(user))
					stock.withdraw_price = max(1, price)
			if("stock_limit")
				var/limit = tgui_input_number(user, "The stockpile keeps at most this much [stock.name]:", name, stock.stockpile_limit, 500, 1)
				if(!isnull(limit) && still_usable(user))
					stock.stockpile_limit = max(1, limit)
			if("stock_accept")
				stock.accept_toggle_enabled = !stock.accept_toggle_enabled
			if("stock_lock")
				stock.withdraw_disabled = !stock.withdraw_disabled
			if("stock_autoexport")
				stock.autoexport_disabled = !stock.autoexport_disabled
			if("stock_export")
				var/revenue = treasury.export_stock(stock, stock.importexport_amt)
				if(revenue)
					say("Exported [stock.name] for [revenue] mammons.")
	return TRUE

/// The desk is still open and within reach after a prompt.
/obj/structure/roguemachine/steward/proc/still_usable(mob/living/user)
	return !locked && !QDELETED(src) && user.can_perform_action(src)
