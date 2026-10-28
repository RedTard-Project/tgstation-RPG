/**
 * A NERVELOCK account of Ratwood's treasury (code/modules/banking/fund_api.dm, /datum/fund): a TG bank account kept off TG's
 * station economy (no paychecks, no ID cards, not in SSeconomy), owned by a subject's mind. The funds of the realm's institutions
 * (the Crown's Purse, the Church, the merchants' company, the bathhouse, the tavern) are ones too, with a fund id and no owner.
 * Money moves with TG's adjust_money() and transfer_money(), whose history is the account's ledger.
 */
/datum/bank_account/rogue
	add_to_accounts = FALSE
	/// Mind of the subject the account belongs to; a fund has none.
	var/datum/weakref/owner_mind
	/// The Steward withholds this subject's wages (Ratwood wages_suspended).
	var/wages_suspended = FALSE
	/// Mammons the estate pays this subject every dawn (Ratwood noble_incomes).
	var/estate_income = 0
	/// Poll tax the subject still owes the Crown from past dawns (Ratwood poll_tax_owed).
	var/poll_owed = 0
	/// Dawns in a row the subject has fallen short of the poll tax (Ratwood poll_tax_debt_days).
	var/poll_overdue_days = 0
	/// Dawns of poll tax the subject has paid ahead (Ratwood poll_tax_advance_days).
	var/poll_advance_days = 0
	/// Institution this fund belongs to (ROGUE_FUND_*); null for a subject's account (Ratwood get_fund_id()).
	var/fund_id
	/// How proclamations name the institution (Ratwood indenture_faction_label()).
	var/fund_label
	/// Under whose grace the institution lends (Ratwood indenture_grace_phrase()).
	var/fund_grace = "By grace of the Crown"

/datum/bank_account/rogue/New(newname, job, modifier = 1, player_account = FALSE)
	return ..(newname, job, modifier, FALSE)

/// The living body of the account's owner, if there is one.
/datum/bank_account/rogue/proc/owner()
	var/datum/mind/mind = owner_mind?.resolve()
	return isliving(mind?.current) ? mind.current : null

/// Job title the account is paid by.
/datum/bank_account/rogue/proc/job_title()
	var/datum/mind/mind = owner_mind?.resolve()
	return mind?.assigned_role?.title || account_job?.title

/// TG's account messages go to the owner as the NERVELOCK speaking to them (Ratwood send_ooc_note()).
/datum/bank_account/rogue/bank_card_talk(message, force)
	var/mob/living/owner = owner()
	if(!message || !owner || (owner.stat == DEAD && !force))
		return
	to_chat(owner, span_boldnotice("NERVELOCK: [message]"))

/// The account's ledger for a window, newest first: TG's transaction history (the last twenty entries).
/proc/rogue_ledger(datum/bank_account/account)
	var/list/ledger = list()
	for(var/i in LAZYLEN(account?.transaction_history) to 1 step -1)
		var/list/entry = account.transaction_history[i]
		ledger += list(list("amount" = entry["adjusted_money"], "reason" = entry["reason"]))
	return ledger

/// The Crown's Purse, the treasury of the realm (Ratwood discretionary_fund).
/datum/bank_account/rogue/crown
	account_holder = "Crown's Purse"
	fund_id = ROGUE_FUND_CROWN
	fund_label = "the Stewardry"

/datum/bank_account/rogue/crown/bank_card_talk(message, force)
	return

/// The coffers of an institution of the realm other than the Crown (Ratwood /datum/fund/church and the others).
/datum/bank_account/rogue/fund

/datum/bank_account/rogue/fund/bank_card_talk(message, force)
	return

/// Mammons the institution holds at round start (Ratwood CHURCH_FUND_SEED and the others).
/datum/bank_account/rogue/fund/proc/founding_endowment()
	return 0

/datum/bank_account/rogue/fund/church
	account_holder = "Church Fund"
	fund_id = ROGUE_FUND_CHURCH
	fund_label = "the Church"
	fund_grace = "By grace of Astrata"

/datum/bank_account/rogue/fund/church/founding_endowment()
	return ROGUE_CHURCH_FUND_SEED

/datum/bank_account/rogue/fund/merchant
	account_holder = "Merchant Fund"
	fund_id = ROGUE_FUND_MERCHANT
	fund_label = "the Merchant Guild"
	fund_grace = "By grace of Malum"

/datum/bank_account/rogue/fund/merchant/founding_endowment()
	return ROGUE_MERCHANT_FUND_SEED

/datum/bank_account/rogue/fund/bathhouse
	account_holder = "Bathhouse Fund"
	fund_id = ROGUE_FUND_BATHHOUSE
	fund_label = "the Bathhouse"
	fund_grace = "By grace of Eora"

/datum/bank_account/rogue/fund/bathhouse/founding_endowment()
	return ROGUE_BATHHOUSE_FUND_SEED

/datum/bank_account/rogue/fund/tavern
	account_holder = "Tavern Earnings"
	fund_id = ROGUE_FUND_TAVERN
	fund_label = "the Tavern"

/datum/bank_account/rogue/fund/tavern/founding_endowment()
	return ROGUE_TAVERN_FUND_SEED

/datum/mind
	/// The subject's NERVELOCK account, opened at a NERVELOCK or on arrival in a role that keeps one.
	var/datum/bank_account/rogue/rogue_account
