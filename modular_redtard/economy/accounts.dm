/**
 * A NERVELOCK account of Ratwood's treasury (code/modules/banking/fund_api.dm, /datum/fund): a TG bank account kept off TG's
 * station economy (no paychecks, no ID cards, not in SSeconomy), owned by a subject's mind; the Crown's Purse is one too.
 * Money moves with TG's adjust_money() and transfer_money(), whose history is the account's ledger.
 */
/datum/bank_account/rogue
	add_to_accounts = FALSE
	/// Mind of the subject the account belongs to; the Crown's Purse has none.
	var/datum/weakref/owner_mind
	/// The Steward withholds this subject's wages (Ratwood wages_suspended).
	var/wages_suspended = FALSE
	/// Mammons the estate pays this subject every dawn (Ratwood noble_incomes).
	var/estate_income = 0

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

/datum/bank_account/rogue/crown/bank_card_talk(message, force)
	return

/datum/mind
	/// The subject's NERVELOCK account, opened at a NERVELOCK or on arrival in a role that keeps one.
	var/datum/bank_account/rogue/rogue_account
