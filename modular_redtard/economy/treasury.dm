/// Ratwood's Crown fiscal officers (has_fiscal_authority()): they run the stockpile and the nerve master.
/proc/rogue_fiscal_authority(mob/user)
	return user?.mind?.assigned_role?.title in list(JOB_ROCKHILL_STEWARD, JOB_ROCKHILL_CLERK, JOB_ROCKHILL_GRAND_DUKE)

/**
 * The treasury of the realm on medieval maps (Ratwood code/controllers/subsystem/rogue/treasury.dm, SStreasury), cut down to the
 * money loop: the Crown's Purse, the NERVELOCK accounts of the subjects, the Crown's levies, the dawn payouts (rural tax, estate
 * incomes, wages the Steward sets) and the stockpile, which the Crown fills from afar and ships abroad every treasury tick.
 * Ratwood's loans, funds of the guilds and church, poll tax, decrees, bankruptcy and trade regions are not ported.
 */
SUBSYSTEM_DEF(rogue_treasury)
	name = "Treasury"
	wait = ROGUE_TREASURY_TICK
	runlevels = RUNLEVEL_GAME
	dependencies = list(
		/datum/controller/subsystem/mapping,
	)
	/// The treasury of the realm (Ratwood discretionary_fund).
	var/datum/bank_account/rogue/crown/crown_purse
	/// Every NERVELOCK account opened this round.
	var/list/datum/bank_account/rogue/accounts = list()
	/// Levy name -> rate (Ratwood tax_rates).
	var/list/tax_rates = list(ROGUE_TAX_IMPORT = 0.15)
	/// The dawn the Steward last changed a levy; levies change once a day (Ratwood levy_rates_changed_day).
	var/levy_changed_dawn = -1
	/// Job title -> mammons paid at every dawn from the Crown's Purse (Ratwood daily_payments of the nerve master).
	var/list/daily_payments = list()
	/// Subjects fined since dawn; each may be fined once a day (Ratwood fined_today_names).
	var/list/fined_today = list()
	/// Every good of the stockpile.
	var/list/datum/roguestock/stockpile_datums = list()
	/// Below this the Crown buys nothing at the stockpile (Ratwood stockpile_purchase_floor).
	var/stockpile_purchase_floor = 1000
	/// Mammons of goods the realm traded through the stockpile (Ratwood economic_output).
	var/economic_output = 0
	var/total_export = 0
	var/total_import = 0
	var/total_rural_tax = 0
	var/total_wages = 0
	var/total_tariff = 0
	/// The Purse has had its share for the players present at round start.
	var/seeded_players = FALSE

/datum/controller/subsystem/rogue_treasury/Initialize()
	if(!rogue_economy_enabled())
		can_fire = FALSE
		return SS_INIT_NO_NEED
	stockpile_purchase_floor = CONFIG_GET(number/rogue_stockpile_floor)
	tax_rates[ROGUE_TAX_IMPORT] = CONFIG_GET(number/rogue_import_tariff) / 100
	crown_purse = new("Crown's Purse")
	mint(crown_purse, CONFIG_GET(number/rogue_crown_purse) + rand(500, 1500), "Treasury of the realm")
	for(var/datum/roguestock/stock_type as anything in subtypesof(/datum/roguestock/stockpile))
		if(initial(stock_type.item_type))
			stockpile_datums += new stock_type
	setup_default_payments()
	RegisterSignal(SSdcs, COMSIG_GLOB_ROCKHILL_TIME_OF_DAY, PROC_REF(on_time_of_day))
	return SS_INIT_SUCCESS

/datum/controller/subsystem/rogue_treasury/stat_entry(msg)
	msg = "Purse: [crown_purse?.account_balance || 0]m, accounts: [length(accounts)]"
	return ..()

/datum/controller/subsystem/rogue_treasury/fire(resumed)
	if(!seeded_players)
		seeded_players = TRUE
		mint(crown_purse, length(GLOB.alive_player_list) * CONFIG_GET(number/rogue_crown_purse_per_player), "Treasury of the realm")
	passive_import()
	auto_export()

/// Ratwood's Rockhill wages (setup_default_payments() of the nerve master), mammons per dawn.
/datum/controller/subsystem/rogue_treasury/proc/setup_default_payments()
	daily_payments = list(
		JOB_ROCKHILL_KNIGHT_CAPTAIN = 40,
		JOB_ROCKHILL_KNIGHT = 40,
		JOB_ROCKHILL_MAN_AT_ARMS = 30,
		JOB_ROCKHILL_FOREST_WARDEN = 20,
		JOB_ROCKHILL_DUNGEONEER = 25,
		JOB_ROCKHILL_WATCH_CAPTAIN = 35,
		JOB_ROCKHILL_MASTER_WARDEN = 35,
		JOB_ROCKHILL_SERGEANT = 40,
		JOB_ROCKHILL_CITY_GUARD = 30,
		JOB_ROCKHILL_VANGUARD = 10,
		JOB_ROCKHILL_ROOKIE = 15,
		JOB_ROCKHILL_VETERAN = 20,
		JOB_ROCKHILL_SQUIRE = 10,
		JOB_ROCKHILL_HEAD_PHYSICIAN = 40,
		JOB_ROCKHILL_APOTHECARY = 15,
		JOB_ROCKHILL_COURT_MAGICIAN = 40,
		JOB_ROCKHILL_COURT_CHAPLAIN = 30,
		JOB_ROCKHILL_SENESCHAL = 40,
		JOB_ROCKHILL_SERVANT = 20,
		JOB_ROCKHILL_ARCHIVIST = 10,
		JOB_ROCKHILL_MAGICIANS_ASSOCIATE = 10,
		JOB_ROCKHILL_JESTER = 6,
	)

// Money. Mint creates mammons (coins melted into an account, taxes, estates), burn destroys them (coins paid out, imports),
// transfer moves them between accounts; all go through TG's adjust_money()/transfer_money() and their ledger.

/datum/controller/subsystem/rogue_treasury/proc/mint(datum/bank_account/account, amount, reason)
	amount = min(round(amount), ROGUE_TRANSFER_MAX)
	if(!account || amount <= 0)
		return FALSE
	return account.adjust_money(amount, reason)

/datum/controller/subsystem/rogue_treasury/proc/burn(datum/bank_account/account, amount, reason)
	amount = round(amount)
	if(!account || amount <= 0)
		return FALSE
	return account.adjust_money(-amount, reason)

/datum/controller/subsystem/rogue_treasury/proc/transfer(datum/bank_account/payer, datum/bank_account/payee, amount, reason)
	amount = min(round(amount), ROGUE_TRANSFER_MAX)
	if(!payer || !payee || amount <= 0)
		return FALSE
	return payee.transfer_money(payer, amount, reason)

/datum/controller/subsystem/rogue_treasury/proc/get_account(mob/target)
	return target?.mind?.rogue_account

/datum/controller/subsystem/rogue_treasury/proc/get_balance(mob/target)
	var/datum/bank_account/rogue/account = get_account(target)
	return account ? account.account_balance : 0

/datum/controller/subsystem/rogue_treasury/proc/get_tax_rate(levy)
	return tax_rates[levy] || 0

/**
 * Opens the subject's NERVELOCK account (Ratwood create_bank_account()), with an endowment and an estate income if the role has
 * them; the estate pays at once, with Ratwood's starter bonus. Returns the account, or the one the subject already has.
 */
/datum/controller/subsystem/rogue_treasury/proc/open_account(mob/living/carbon/human/owner, deposit = 0, estate = 0)
	var/datum/mind/mind = owner?.mind
	if(!mind || !crown_purse)
		return null
	if(mind.rogue_account)
		return mind.rogue_account
	var/datum/bank_account/rogue/account = new(owner.real_name, mind.assigned_role)
	account.owner_mind = WEAKREF(mind)
	mind.rogue_account = account
	accounts += account
	if(deposit > 0)
		mint(account, deposit, "Initial endowment")
	if(estate > 0)
		account.estate_income = estate
		grant_estate_income(account, starter = TRUE)
	return account

/// Ratwood grant_estate_income(): the estate (the trading company, for a merchant) pays its holder; outlaws get nothing.
/datum/controller/subsystem/rogue_treasury/proc/grant_estate_income(datum/bank_account/rogue/account, starter = FALSE)
	var/mob/living/owner = account.owner()
	if(!account.estate_income || (owner && HAS_TRAIT(owner, TRAIT_OUTLAW)))
		return FALSE
	var/source = account.job_title() == JOB_ROCKHILL_MERCHANT ? "Ferentian Trading Company" : "Noble Estate"
	var/payout = account.estate_income + (starter ? ROGUE_ESTATE_STARTER_BONUS : 0)
	if(!mint(account, payout, source))
		return FALSE
	account.bank_card_talk("You received [payout]m. ([source])")
	return TRUE

/// Ratwood give_money_account(): the Crown pays a subject from the Purse.
/datum/controller/subsystem/rogue_treasury/proc/give_money(datum/bank_account/rogue/account, amount, reason)
	if(!account || !transfer(crown_purse, account, amount, reason))
		return FALSE
	account.bank_card_talk("You received [amount]m. ([reason])")
	log_game("CROWN GRANT: [key_name(usr)] granted [amount]m to [account.account_holder] via [reason]")
	return TRUE

/// Ratwood's fine: the Crown takes up to the subject's whole balance into the Purse, once a day per subject.
/datum/controller/subsystem/rogue_treasury/proc/fine(datum/bank_account/rogue/account, amount, reason)
	if(!account || amount <= 0)
		return FALSE
	if(fined_today[account])
		return FALSE
	amount = min(amount, account.account_balance)
	if(!transfer(account, crown_purse, amount, "Fine ([reason])"))
		return FALSE
	fined_today[account] = TRUE
	account.bank_card_talk("You were fined [amount]m. ([reason])")
	log_game("FINE: [key_name(usr)] fined [account.account_holder] [amount]m via [reason]")
	return TRUE

/// A new day: the Crown collects the rural tax, estates and wages are paid (Ratwood's dawn in code/__HELPERS/time.dm).
/datum/controller/subsystem/rogue_treasury/proc/on_time_of_day(datum/source, datum/rockhill_clock_step/phase/old_phase, datum/rockhill_clock_step/phase/new_phase)
	SIGNAL_HANDLER
	if(new_phase?.name != ROCKHILL_DAWN || !crown_purse)
		return
	fined_today.Cut()
	var/rural_tax = CONFIG_GET(number/rogue_rural_tax)
	if(mint(crown_purse, rural_tax, "Rural Tax Collection"))
		total_rural_tax += rural_tax
	for(var/datum/bank_account/rogue/account as anything in accounts)
		grant_estate_income(account)
	pay_wages()

/// Ratwood distribute_daily_payments(): every subject whose role has a wage is paid from the Purse while it has the money.
/datum/controller/subsystem/rogue_treasury/proc/pay_wages()
	for(var/datum/bank_account/rogue/account as anything in accounts)
		var/wage = daily_payments[account.job_title()]
		if(!wage || account.wages_suspended || !account.owner())
			continue
		if(!crown_purse.has_money(wage))
			account.bank_card_talk("The Crown's Purse cannot pay your wage today.")
			continue
		if(transfer(crown_purse, account, wage, "Daily Wage"))
			total_wages += wage
			account.bank_card_talk("You received [wage]m. (Daily Wage)")

/// The stockpile good this item is sold as: its exact good first, then any good it is a kind of (Ratwood's list order).
/datum/controller/subsystem/rogue_treasury/proc/stock_for(obj/item/thing)
	for(var/datum/roguestock/stock as anything in stockpile_datums)
		if(thing.type == stock.item_type)
			return stock.accepts(thing) ? stock : null
	for(var/datum/roguestock/stock as anything in stockpile_datums)
		if(stock.accepts(thing))
			return stock
	return null

/// Ratwood's passive import: the Crown buys goods in from afar up to the stockpile's limit while the Purse can pay.
/datum/controller/subsystem/rogue_treasury/proc/passive_import()
	for(var/datum/roguestock/stock as anything in stockpile_datums)
		var/units = min(stock.passive_generation, stock.stockpile_limit - stock.stockpile_amount)
		if(units <= 0)
			continue
		var/cost = units * stock.generation_price
		if(crown_purse.account_balance - cost < stockpile_purchase_floor)
			continue
		if(burn(crown_purse, cost, "Imported [units] [stock.name]"))
			stock.stockpile_amount += units
			total_import += cost

/// Ratwood auto_export(): a good kept above 60% of its limit ships a load abroad; the Crown's Purse takes the price.
/datum/controller/subsystem/rogue_treasury/proc/auto_export()
	for(var/datum/roguestock/stock as anything in stockpile_datums)
		if(stock.autoexport_disabled || stock.importexport_amt <= 0)
			continue
		if(stock.stockpile_amount <= ROGUE_AUTOEXPORT_SHARE * stock.stockpile_limit || stock.stockpile_amount < stock.importexport_amt)
			continue
		export_stock(stock, stock.importexport_amt)

/// Ships units of a good abroad at its export price into the Crown's Purse (Ratwood do_export()).
/datum/controller/subsystem/rogue_treasury/proc/export_stock(datum/roguestock/stock, units)
	units = min(units, stock.stockpile_amount)
	if(units <= 0)
		return 0
	var/revenue = units * stock.export_price
	stock.stockpile_amount -= units
	mint(crown_purse, revenue, "Exported [units] [stock.name]")
	total_export += revenue
	economic_output += revenue
	return revenue

/// Changes a levy, once a day, and proclaims it (Ratwood apply_rate_adjustments()).
/datum/controller/subsystem/rogue_treasury/proc/set_tax_rate(levy, percent, mob/user)
	if(!(levy in tax_rates))
		return FALSE
	if(levy_changed_dawn == GLOB.rockhill_dawns)
		to_chat(user, span_warning("Crown levies have already been adjusted today - come back tomorrow."))
		return FALSE
	var/old_percent = round(tax_rates[levy] * 100)
	percent = clamp(round(percent), 0, 100)
	if(percent == old_percent)
		return FALSE
	tax_rates[levy] = percent / 100
	levy_changed_dawn = GLOB.rockhill_dawns
	var/raised = percent > old_percent
	priority_announce("The [levy] has been [raised ? "raised" : "reduced"] from [old_percent]% to [percent]%.", raised ? "The Crown Demands More" : "The Crown Is Generous", pick('modular_redtard/rockhill/sound/misc/royal_decree.ogg', 'modular_redtard/rockhill/sound/misc/royal_decree2.ogg'))
	log_game("TAX RATES: [key_name(user)] changed the [levy] from [old_percent]% to [percent]%")
	return TRUE
