/**
 * A loan of the realm (Ratwood code/modules/banking/loan.dm, port of Azure Peak's economy): an institution's fund lends a subject
 * (a personal loan) or another institution (an indenture) a principal at simple interest per dawn. Interest accrues each dawn
 * up to the full term; at the dawn it falls due the debt is drawn from the borrower, and what cannot be paid is a default: the
 * borrower's whole balance is seized and a subject is marked a defaulter until the debt is settled.
 */
/datum/rogue_loan
	/// Who owes: the subject's name, or the borrowing institution's.
	var/debtor_name
	/// The subject's account, for a personal loan.
	var/datum/bank_account/rogue/debtor_account
	/// The borrowing institution's fund, for an indenture.
	var/datum/bank_account/rogue/borrower_fund
	/// The lending institution's fund.
	var/datum/bank_account/rogue/lender
	var/principal = 0
	/// Simple interest per dawn, as a share of the principal.
	var/rate = 0
	var/days_total = 1
	var/issued_dawn = 0
	var/due_dawn = 0
	/// Principal and the interest of the full term.
	var/total_due = 0
	var/repaid = 0
	var/defaulted = FALSE
	/// Who signed the writ for the lender.
	var/issuer_name

/datum/rogue_loan/New(datum/bank_account/rogue/lender, principal, days_total, rate, issuer_name, datum/bank_account/rogue/debtor_account, datum/bank_account/rogue/borrower_fund)
	. = ..()
	src.lender = lender
	src.principal = principal
	src.days_total = days_total
	src.rate = rate
	src.issuer_name = issuer_name
	src.debtor_account = debtor_account
	src.borrower_fund = borrower_fund
	debtor_name = borrower_fund ? borrower_fund.fund_label : debtor_account?.account_holder
	issued_dawn = ROGUE_TREASURY_DAY
	due_dawn = issued_dawn + days_total
	total_due = rogue_loan_total(principal, rate, days_total)

/// Principal and simple interest over a term (Ratwood compute_total_due()).
/proc/rogue_loan_total(principal, rate, days)
	return floor(principal * (1 + rate * max(1, days)))

/// What is owed now: the principal and the interest of the dawns passed, at least one, at most the term, less what was repaid (Ratwood get_remaining_due()).
/datum/rogue_loan/proc/remaining_due()
	var/elapsed = max(1, ROGUE_TREASURY_DAY - issued_dawn)
	var/owed = min(principal + floor(principal * rate * elapsed), total_due)
	return max(owed - repaid, 0)

/datum/rogue_loan/proc/days_until_due()
	return max(due_dawn - ROGUE_TREASURY_DAY, 0)

/// The mark a defaulter bears, by lender (Ratwood get_faction_debtor_trait()).
/datum/rogue_loan/proc/debtor_trait()
	switch(lender?.fund_id)
		if(ROGUE_FUND_CHURCH)
			return TRAIT_DEBTOR_CHURCH
		if(ROGUE_FUND_MERCHANT)
			return TRAIT_DEBTOR_MERCHANT
		if(ROGUE_FUND_BATHHOUSE)
			return TRAIT_DEBTOR_BATHHOUSE
	return TRAIT_DEBTOR_CROWN

/// The loan for a window.
/datum/rogue_loan/proc/ui_entry()
	return list(
		"ref" = REF(src),
		"debtor" = debtor_name,
		"lender" = lender?.fund_label,
		"lender_id" = lender?.fund_id,
		"borrower_id" = borrower_fund?.fund_id,
		"principal" = principal,
		"interest" = round(rate * 100),
		"due_day" = due_dawn,
		"days_left" = days_until_due(),
		"remaining" = remaining_due(),
		"defaulted" = defaulted,
	)

/datum/controller/subsystem/rogue_treasury
	/// Every outstanding loan and indenture (Ratwood loans).
	var/list/datum/rogue_loan/loans = list()
	var/loans_issued = 0
	var/loans_defaulted = 0

/// A subject's personal loan; a subject holds one at a time (Ratwood get_loan_for()).
/datum/controller/subsystem/rogue_treasury/proc/loan_for(datum/bank_account/rogue/account)
	if(!account)
		return null
	for(var/datum/rogue_loan/loan as anything in loans)
		if(loan.debtor_account == account)
			return loan
	return null

/// The indenture an institution owes; it holds one at a time.
/datum/controller/subsystem/rogue_treasury/proc/indenture_of(datum/bank_account/rogue/fund)
	if(!fund)
		return null
	for(var/datum/rogue_loan/loan as anything in loans)
		if(loan.borrower_fund == fund)
			return loan
	return null

/// Principal an institution has lent and not yet had back (Ratwood get_outstanding_principal_from_fund()).
/datum/controller/subsystem/rogue_treasury/proc/outstanding_principal(datum/bank_account/rogue/fund)
	. = 0
	for(var/datum/rogue_loan/loan as anything in loans)
		if(loan.lender == fund)
			. += max(0, loan.principal - loan.repaid)

/// The borrower signs: the principal moves and the loan is booked. Returns the loan.
/datum/controller/subsystem/rogue_treasury/proc/issue_loan(datum/bank_account/rogue/lender, principal, days, rate, issuer_name, datum/bank_account/rogue/debtor_account, datum/bank_account/rogue/borrower_fund)
	var/datum/bank_account/rogue/borrower = borrower_fund || debtor_account
	if(!transfer(lender, borrower, principal, borrower_fund ? "Indenture principal" : "Loan principal"))
		return null
	var/datum/rogue_loan/loan = new(lender, principal, days, rate, issuer_name, debtor_account, borrower_fund)
	loans += loan
	loans_issued++
	return loan

/// Pays up to an amount of a loan from its borrower's balance (Ratwood repay_loan(), repay_indenture()). Returns the mammons paid.
/datum/controller/subsystem/rogue_treasury/proc/repay_loan(datum/rogue_loan/loan, amount)
	var/datum/bank_account/rogue/borrower = loan?.borrower_fund || loan?.debtor_account
	if(!borrower || !loan.lender)
		return 0
	amount = min(round(amount), loan.remaining_due(), borrower.account_balance)
	if(amount <= 0)
		return 0
	var/reason = loan.borrower_fund ? "Indenture repayment" : "Loan repayment"
	if(!transfer(borrower, loan.lender, amount, loan.defaulted ? "Default debt settlement" : reason))
		return 0
	loan.repaid += amount
	if(loan.remaining_due() <= 0)
		settle_loan(loan)
	return amount

/// A loan is paid in full or written off: the defaulter's mark is lifted.
/datum/controller/subsystem/rogue_treasury/proc/settle_loan(datum/rogue_loan/loan)
	loans -= loan
	var/mob/living/debtor = loan.debtor_account?.owner()
	if(!loan.defaulted || !debtor)
		return
	REMOVE_TRAIT(debtor, TRAIT_DEBTOR, ROGUE_TREASURY_TRAIT)
	REMOVE_TRAIT(debtor, loan.debtor_trait(), ROGUE_TREASURY_TRAIT)
	refresh_marks(debtor)
	to_chat(debtor, span_notice("The stigma of default is lifted. Your debt to [loan.lender.fund_label] is paid in full."))

/// The Steward writes off a debt owed to the Crown and lifts the mark (Ratwood clearloandebtor).
/datum/controller/subsystem/rogue_treasury/proc/forgive_loan(datum/rogue_loan/loan, mob/user)
	if(!(loan in loans) || loan.lender != crown_purse)
		return FALSE
	var/written_off = loan.remaining_due()
	settle_loan(loan)
	loan.debtor_account?.bank_card_talk("The Crown has forgiven your debt of [written_off]m.")
	log_game("DEBT FORGIVEN: [key_name(user)] wrote off [written_off]m owed by [loan.debtor_name] to the Crown")
	return TRUE

/// Loans that fall due at dawn are drawn from their borrowers; those that cannot pay default (Ratwood tick_loans(), tick_indenture()).
/datum/controller/subsystem/rogue_treasury/proc/tick_loans()
	for(var/datum/rogue_loan/loan as anything in loans.Copy())
		if(!loan.lender || (!loan.borrower_fund && !loan.debtor_account?.owner_mind?.resolve()))
			log_game("LOAN PRUNED: [loan.debtor_name] - the borrower is gone, loan orphaned.")
			loans -= loan
			continue
		if(ROGUE_TREASURY_DAY < loan.due_dawn)
			continue
		var/datum/bank_account/rogue/borrower = loan.borrower_fund || loan.debtor_account
		var/outstanding = loan.remaining_due()
		if(outstanding <= 0)
			settle_loan(loan)
			continue
		if(borrower.has_money(outstanding))
			var/was_defaulted = loan.defaulted
			if(repay_loan(loan, outstanding))
				if(!loan.borrower_fund && !was_defaulted)
					borrower.bank_card_talk("Your loan of [loan.principal]m has been repaid in full ([outstanding]m drawn from your account).")
				continue
		if(!loan.defaulted)
			default_loan(loan, borrower)

/// The loan came due and cannot be paid: the borrower's whole balance is seized, a subject is marked a defaulter, an institution's default is proclaimed.
/datum/controller/subsystem/rogue_treasury/proc/default_loan(datum/rogue_loan/loan, datum/bank_account/rogue/borrower)
	loan.defaulted = TRUE
	loans_defaulted++
	var/seized = borrower.account_balance
	if(seized > 0 && transfer(borrower, loan.lender, seized, loan.borrower_fund ? "Indenture default seizure" : "Loan default seizure"))
		loan.repaid += seized
	else
		seized = 0
	var/still_owed = loan.remaining_due()
	if(loan.borrower_fund)
		announce_indenture_default(loan, seized, still_owed)
		message_admins("INDENTURE DEFAULT: [loan.debtor_name] defaulted on [loan.principal]m owed to [loan.lender.fund_label]. [seized]m seized, [still_owed]m remaining.")
		return
	var/mob/living/debtor = loan.debtor_account.owner()
	if(debtor)
		ADD_TRAIT(debtor, TRAIT_DEBTOR, ROGUE_TREASURY_TRAIT)
		ADD_TRAIT(debtor, loan.debtor_trait(), ROGUE_TREASURY_TRAIT)
		watch_marks(debtor)
		to_chat(debtor, span_userdanger("MEISTER: Your loan of [loan.principal]m has come due and you cannot pay. [seized]m was seized; [still_owed]m remains owed to [loan.lender.fund_label]. You are marked a defaulter until the debt is settled."))
	log_game("LOAN DEFAULT: [loan.debtor_name] defaulted on a [loan.principal]m loan from [loan.lender.fund_label]. [seized]m seized, [still_owed]m remaining.")

/// The realm hears that an indenture was sealed (Ratwood announce_indenture_acceptance()).
/datum/controller/subsystem/rogue_treasury/proc/announce_indenture(datum/rogue_loan/loan, mob/living/accepter)
	var/job_label = accepter.mind?.assigned_role ? "[accepter.real_name], the [accepter.mind.assigned_role.title]" : accepter.real_name
	priority_announce("[loan.lender.fund_grace], [loan.lender.fund_label] has extended a most generous loan of [loan.principal]m at [round(loan.rate * 100)]% per dae over [loan.days_total] dae, accepted by [job_label] on behalf of [loan.debtor_name].", "Writ of Indenture", ROGUE_SOUND_DECREE)

/// The realm hears that an institution failed its indenture (Ratwood announce_indenture_default()).
/datum/controller/subsystem/rogue_treasury/proc/announce_indenture_default(datum/rogue_loan/loan, seized, still_owed)
	var/text
	switch(loan.lender.fund_id)
		if(ROGUE_FUND_CHURCH)
			text = "The Church has called its loan to [loan.debtor_name] and finds the coffers wanting. Astrata's generosity has been squandered."
		if(ROGUE_FUND_MERCHANT)
			text = "The Merchant Guild has called its loan to [loan.debtor_name] and finds the coffers wanting. The Burghers are outraged. There is no wealth without trust, and no realm without wealth."
		if(ROGUE_FUND_BATHHOUSE)
			text = "The Bathhouse has called its loan to [loan.debtor_name] and finds the coffers wanting. Her generosity abused! Her love disgraced! To lend from the bathhouse is one shame, to not pay back, a greater one."
		else
			text = "The Stewardry has called its loan to [loan.debtor_name] and finds the coffers wanting. The Crown is owed its due, and shall make known its prerogative."
	priority_announce("[text] [seized]m forfeit, [still_owed]m unsettled.", "Indenture Defaulted", ROGUE_SOUND_DECREE)

/// A subject bearing a treasury mark shows it to those who would know it (Ratwood human examine()).
/datum/controller/subsystem/rogue_treasury/proc/watch_marks(mob/living/subject)
	RegisterSignal(subject, COMSIG_ATOM_EXAMINE, PROC_REF(on_marked_examine), override = TRUE) // Re-marking the same subject only refreshes the watch.

/datum/controller/subsystem/rogue_treasury/proc/refresh_marks(mob/living/subject)
	if(!HAS_TRAIT(subject, TRAIT_DEBTOR) && !HAS_TRAIT(subject, TRAIT_ARREARS))
		UnregisterSignal(subject, COMSIG_ATOM_EXAMINE)

/// Defaulters are known to their creditors' people, the Crown's to its officers; paupers in arrears to the Crown's officers.
/datum/controller/subsystem/rogue_treasury/proc/on_marked_examine(mob/living/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(!ishuman(user))
		return
	var/viewer_title = user.mind?.assigned_role?.title
	var/crown_officer = rogue_crown_officer(user)
	if(HAS_TRAIT(source, TRAIT_DEBTOR))
		var/saw_specific = FALSE
		if(HAS_TRAIT(source, TRAIT_DEBTOR_CHURCH) && (viewer_title in GLOB.rogue_church_roles))
			examine_list += span_userdanger("DEFAULT DEBTOR OF THE CHURCH!")
			saw_specific = TRUE
		if(HAS_TRAIT(source, TRAIT_DEBTOR_MERCHANT) && ((viewer_title in list(JOB_ROCKHILL_MERCHANT, JOB_ROCKHILL_SHOPHAND)) || HAS_TRAIT(user, TRAIT_AGENT_MERCHANT)))
			examine_list += span_userdanger("DEFAULT DEBTOR OF THE TRADING COMPANY!")
			saw_specific = TRUE
		if(HAS_TRAIT(source, TRAIT_DEBTOR_BATHHOUSE) && ((viewer_title in list(JOB_ROCKHILL_BATHMASTER, JOB_ROCKHILL_BATHHOUSE_ATTENDANT)) || HAS_TRAIT(user, TRAIT_AGENT_BATHHOUSE)))
			examine_list += span_userdanger("DEFAULT DEBTOR OF THE BATHHOUSE!")
			saw_specific = TRUE
		if(!saw_specific && HAS_TRAIT(source, TRAIT_DEBTOR_CROWN) && crown_officer)
			examine_list += span_userdanger("DEFAULT DEBTOR OF THE CROWN!")
	if(HAS_TRAIT(source, TRAIT_ARREARS) && crown_officer)
		examine_list += span_warning("Destitute..")

/**
 * A loan writ (Ratwood code/modules/banking/loan_contract.dm): drafted at a JAWBANK by the lender's officer, it names the
 * principal, term and interest; whoever holds it may accept the terms in hand, and the coin goes to their NERVELOCK account.
 * An unsigned writ crumbles after a while.
 */
/obj/item/rogue_loan_writ
	name = "Loan Contract"
	desc = "A binding writ from the Nerve Master, bearing the Steward's signature. Any eligible bearer may accept its terms."
	icon = 'modular_redtard/rockhill/icons/roguetown/items/misc.dmi'
	icon_state = "paper_prep"
	w_class = WEIGHT_CLASS_TINY
	force = 0
	throwforce = 0
	resistance_flags = FLAMMABLE
	var/issuer_name
	var/principal = 0
	var/term_days = 1
	var/rate = 0
	var/total_due = 0
	/// Institution that lends.
	var/lender_id = ROGUE_FUND_CROWN

/// Writes the terms on a fresh writ and starts its crumbling.
/obj/item/rogue_loan_writ/proc/draft(lender_id, issuer_name, principal, term_days, rate)
	src.lender_id = lender_id
	src.issuer_name = issuer_name
	src.principal = principal
	src.term_days = term_days
	src.rate = rate
	total_due = rogue_loan_total(principal, rate, term_days)
	QDEL_IN(src, ROGUE_WRIT_LIFETIME)

/obj/item/rogue_loan_writ/proc/lender_label()
	var/datum/bank_account/rogue/lender = SSrogue_treasury.get_fund(lender_id)
	return lender ? lender.fund_label : "an unknown lender"

/obj/item/rogue_loan_writ/examine(mob/user)
	. = ..()
	. += span_info("The contract reads: <i>\"Be it known that the bearer doth receive of [lender_label()] the sum of [principal] mammon, to be repaid in full on the [rogue_ordinal(term_days)] dae after the acceptance of this loan, at the rate of [round(rate * 100)] per centum per dae of simple interest, totaling [total_due] mammon due.\"</i>")
	. += span_info("<i>Signed in the year [ROCKHILL_CALENDAR_EPOCH_YEAR], [issuer_name || "the Nerve Master"].</i>")
	. += span_notice("Use it in hand to accept or decline its terms.")

/obj/item/rogue_loan_writ/attack_self(mob/user, modifiers)
	. = ..()
	if(. || !ishuman(user))
		return
	INVOKE_ASYNC(src, PROC_REF(offer_terms), user)
	return TRUE

/// Why this bearer cannot take the loan, or null (Ratwood attack_self() checks).
/obj/item/rogue_loan_writ/proc/refusal(mob/living/carbon/human/user)
	if(HAS_TRAIT(user, TRAIT_DEBTOR))
		return "I am already marked a defaulter. I cannot take on new debt."
	var/datum/bank_account/rogue/account = SSrogue_treasury.get_account(user)
	if(!account)
		return "I have no Nervelock account to receive these funds. I must open one first."
	if(SSrogue_treasury.loan_for(account))
		return "I already owe a debt. I cannot hold two at once."
	var/datum/bank_account/rogue/lender = SSrogue_treasury.get_fund(lender_id)
	if(!lender)
		return "The writ names no recognised lender. The nervelock cannot honor it."
	if(lender_id == ROGUE_FUND_CHURCH && (user.mind?.assigned_role?.title in GLOB.rogue_church_roles))
		return "The Church prohibits usury to its own. Eora's coin is for the poor and the downtrodden, not the faithful."
	if(!lender.has_money(principal))
		return "[lender.account_holder]'s coffers are too thin to honor this writ."
	return null

/obj/item/rogue_loan_writ/proc/offer_terms(mob/living/carbon/human/user)
	var/reason = refusal(user)
	if(reason)
		to_chat(user, span_warning(reason))
		return
	var/label = lender_label()
	var/choice = tgui_alert(user, "Accept a loan of [principal]m from [label], due in [term_days] day\s at [round(rate * 100)]%/day simple interest? Total due: [total_due]m.", "Loan from [label]", list("Accept", "Decline"))
	if(choice != "Accept")
		to_chat(user, span_notice("I set the contract aside, unsigned."))
		return
	if(QDELETED(src) || QDELETED(user) || !user.is_holding(src))
		return
	reason = refusal(user)
	if(reason)
		to_chat(user, span_warning(reason))
		return
	var/datum/bank_account/rogue/account = SSrogue_treasury.get_account(user)
	var/datum/rogue_loan/loan = SSrogue_treasury.issue_loan(SSrogue_treasury.get_fund(lender_id), principal, term_days, rate, issuer_name, account)
	if(!loan)
		to_chat(user, span_warning("The nervelock refuses the transfer."))
		return
	user.visible_message(span_notice("[user] signs the loan contract and pockets [label]'s coin."), span_notice("I accept the loan of [principal]m from [label], repayable in [term_days] day\s at [round(rate * 100)]%/day. Total due: [total_due]m."))
	playsound(user, ROGUE_SOUND_SEAL, 60, FALSE, -1)
	account.bank_card_talk("Loan of [principal]m received from [label]. [total_due]m will be collected at the dawn of day [loan.due_dawn]. Right-click a NERVELOCK to repay it sooner.")
	log_game("LOAN: [key_name(user)] accepted [principal]m from [label] over [term_days]d at [round(rate * 100)]%/day, writ by [issuer_name]")
	qdel(src)

/**
 * A writ of indenture: a loan between two institutions. Only the borrowing institution's officer may seal it; it is proclaimed
 * when sealed and when defaulted (Ratwood /obj/item/loan_contract/indenture).
 */
/obj/item/rogue_loan_writ/indenture
	name = "Writ of Indenture"
	desc = "A binding indenture between two institutions of Ferentia. Only the named borrower's authorised hand may seal it."
	/// Institution that borrows.
	var/borrower_id

/obj/item/rogue_loan_writ/indenture/examine(mob/user)
	. = ..()
	. += span_warning("This indenture is publicly proclaimed upon acceptance and upon default.")
	var/datum/bank_account/rogue/borrower = SSrogue_treasury.get_fund(borrower_id)
	if(borrower)
		. += span_info("Drawn for: [borrower.fund_label].")

/obj/item/rogue_loan_writ/indenture/refusal(mob/living/carbon/human/user)
	var/datum/controller/subsystem/rogue_treasury/treasury = SSrogue_treasury
	var/datum/bank_account/rogue/lender = treasury.get_fund(lender_id)
	var/datum/bank_account/rogue/borrower = treasury.get_fund(borrower_id)
	if(!lender || !borrower)
		return "The indenture names no recognised parties. The nervelock cannot honor it."
	if(!treasury.fund_can_lend(user, borrower_id))
		return "Only [treasury.fund_authority_label(borrower_id)] may seal an indenture for [borrower.fund_label]."
	if(treasury.indenture_of(borrower))
		return "[borrower.fund_label] already holds an outstanding indenture."
	if(!lender.has_money(principal))
		return "[lender.account_holder]'s coffers are too thin to honor this indenture."
	return null

/obj/item/rogue_loan_writ/indenture/offer_terms(mob/living/carbon/human/user)
	var/reason = refusal(user)
	if(reason)
		to_chat(user, span_warning(reason))
		return
	var/datum/bank_account/rogue/borrower = SSrogue_treasury.get_fund(borrower_id)
	var/choice = tgui_alert(user, "On behalf of [borrower.fund_label], accept an indenture of [principal]m from [lender_label()], due in [term_days] day\s at [round(rate * 100)]%/day? Total due: [total_due]m. THIS WILL BE PUBLICLY PROCLAIMED.", "Writ of Indenture", list("Seal", "Decline"))
	if(choice != "Seal")
		to_chat(user, span_notice("I set the indenture aside, unsealed."))
		return
	if(QDELETED(src) || QDELETED(user) || !user.is_holding(src))
		return
	reason = refusal(user)
	if(reason)
		to_chat(user, span_warning(reason))
		return
	var/datum/rogue_loan/loan = SSrogue_treasury.issue_loan(SSrogue_treasury.get_fund(lender_id), principal, term_days, rate, issuer_name, null, borrower)
	if(!loan)
		to_chat(user, span_warning("The nervelock refuses the transfer."))
		return
	playsound(user, ROGUE_SOUND_SEAL, 60, FALSE, -1)
	SSrogue_treasury.announce_indenture(loan, user)
	log_game("INDENTURE SEALED: [key_name(user)] accepted [principal]m from [lender_label()] on behalf of [borrower.fund_label] over [term_days]d at [round(rate * 100)]%/day.")
	qdel(src)

/// "1st", "2nd", "3rd", "4th"... (Ratwood loan_contract ordinal()).
/proc/rogue_ordinal(number)
	var/suffix = "th"
	var/last_two = number % 100
	if(last_two < 11 || last_two > 13)
		switch(number % 10)
			if(1)
				suffix = "st"
			if(2)
				suffix = "nd"
			if(3)
				suffix = "rd"
	return "[number][suffix]"
