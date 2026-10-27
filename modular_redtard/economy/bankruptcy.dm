// The Crown's solvency (Ratwood code/modules/banking/bankruptcy.dm): solvent, in arrears, sequestered. At dawn, before the
// payroll, the Crown checks the Purse can meet the day's wages. The first shortfall makes the Burghers advance the money (the
// Crown falls into arrears); a second dawn short, or a shortfall after an emergency loan from the trading company, puts the
// realm under sequestration: the Purse is reset to an operating reserve, wages stop, every charter but the Golden Bull is
// suspended, the stockpile ships more abroad. Every debt is repaid out of the Purse's income; when it is paid the realm recovers.

/datum/controller/subsystem/rogue_treasury
	/// ROGUE_TREASURY_SOLVENT, _ARREARS or _SEQUESTERED (Ratwood treasury_state).
	var/treasury_state = ROGUE_TREASURY_SOLVENT
	/// Mammons the Crown owes the trading company and the Burghers, repaid from the Purse's income (Ratwood treasury_debt).
	var/treasury_debt = 0
	var/bankruptcy_count = 0
	/// Charters the ruler may still restore at once after a sequestration (Ratwood bankruptcy_concession_picks).
	var/concession_picks = 0
	/// An emergency loan of the trading company spent the Burghers' grace: the next shortfall is a sequestration (Ratwood atc_loan_arrears_consumed).
	var/ftc_grace_spent = FALSE
	var/ftc_loans_drawn = 0

/// Name of a solvency state (Ratwood bankruptcy_state_label()).
/proc/rogue_treasury_state_label(state)
	switch(state)
		if(ROGUE_TREASURY_ARREARS)
			return "In Arrears"
		if(ROGUE_TREASURY_SEQUESTERED)
			return "Sequestered"
	return "Solvent"

/// Dawn, before the payroll: can the Purse pay the day's wages? (Ratwood evaluate_payroll_solvency()).
/datum/controller/subsystem/rogue_treasury/proc/evaluate_solvency()
	var/projected = expected_wage_outlay()
	if(projected <= 0 || crown_purse.has_money(projected))
		return
	switch(treasury_state)
		if(ROGUE_TREASURY_SOLVENT)
			if(ftc_grace_spent)
				enter_sequestration()
			else
				enter_arrears(projected)
		if(ROGUE_TREASURY_ARREARS)
			enter_sequestration()

/// The Burghers advance the day's wages, interest-free, as a debt (Ratwood enter_arrears()).
/datum/controller/subsystem/rogue_treasury/proc/enter_arrears(projected)
	if(treasury_state != ROGUE_TREASURY_SOLVENT)
		return FALSE
	var/advance = round(max(ROGUE_ARREARS_ADVANCE, projected - crown_purse.account_balance))
	treasury_state = ROGUE_TREASURY_ARREARS
	treasury_debt += advance
	// Straight into the Purse, not through mint(), or the advance would go to the debt it just created.
	crown_purse.adjust_money(advance, "Arrears advance from the Ferentian Trading Company")
	priority_announce("The Crown's coffers ran dry at payroll. The Burghers of Ferentia, by their standing pledge, advance [advance]m at no interest to cover the day's wages. Should the Crown fail again on the morrow, the realm enters sequestration.", "THE BURGHERS LEND", 'modular_redtard/rockhill/sound/misc/royal_decree2.ogg')
	log_game("TREASURY: the Crown fell into arrears, [advance]m advanced")
	return TRUE

/// The trading company takes over the realm's revenue until its debt is paid (Ratwood enter_bankruptcy()).
/datum/controller/subsystem/rogue_treasury/proc/enter_sequestration()
	if(treasury_state == ROGUE_TREASURY_SEQUESTERED)
		return FALSE
	bankruptcy_count++
	var/reserve = round(ROGUE_SEQUESTRATION_FLOOR)
	var/balance = crown_purse.account_balance
	if(balance > reserve)
		crown_purse.adjust_money(reserve - balance, "Sequestration: residual purse forfeit")
	else if(balance < reserve)
		crown_purse.adjust_money(reserve - balance, "Sequestration: operating reserve from the Ferentian Trading Company")
	// Arrears roll into the sequestration debt: failing harder does not wipe the smaller debt.
	var/new_debt = round(ROGUE_SEQUESTRATION_DEBT)
	treasury_debt += new_debt
	treasury_state = ROGUE_TREASURY_SEQUESTERED
	suspend_charters_for_sequestration()
	autoexport_share = ROGUE_SEQUESTRATION_EXPORT_SHARE
	tell_wage_earners(span_danger("My wages have been suspended after the Crown's sequestration. They will resume when the realm recovers."))
	priority_announce("Following seizure of [rogue_ftc_seizure_blurb()] against the Crown's outstanding obligations, the Ferentian Trading Company - most blessed, most devout servant of Malum the Worker and Abyssor the Dreamer - has graciously advanced an interest-free reserve of [reserve]m in exchange for a debt of [new_debt]m to the Company. Until the debt is repaid in full, the Company holds the sequestered revenues of the realm and farms the customs and salt tolls in perpetuity; the stockpile and trade-engine pass to its hand, that the orderly operation of commerce may be assured for the common weal. Salaries stand suspended; all Charters but the Golden Bull are dissolved.", "SEQUESTRATION DECLARED", 'modular_redtard/rockhill/sound/misc/royal_decree.ogg')
	log_game("TREASURY: the realm entered sequestration, debt [treasury_debt]m")
	message_admins("The Crown entered sequestration (bankruptcy), debt [treasury_debt]m.")
	return TRUE

/// Every charter but the Golden Bull is suspended; these are not policy, so they bypass cooldowns and daily limits (Ratwood suspend_charters_for_bankruptcy()).
/datum/controller/subsystem/rogue_treasury/proc/suspend_charters_for_sequestration()
	for(var/id in decrees)
		var/datum/rogue_decree/decree = decrees[id]
		if(decree.id == ROGUE_DECREE_GOLDEN_BULL)
			continue
		if(decree.active)
			decree.active = FALSE
			decree.cooldown_expires = 0
			decree.on_revoke()
		decree.bankruptcy_suspended = TRUE

/// The Purse's income first pays the Crown's debt; under sequestration only what lifts it above the operating reserve (Ratwood skim_for_treasury_debt()).
/datum/controller/subsystem/rogue_treasury/proc/skim_for_treasury_debt(amount)
	if(treasury_debt <= 0 || amount <= 0)
		return
	var/reserve = treasury_state == ROGUE_TREASURY_SEQUESTERED ? ROGUE_SEQUESTRATION_FLOOR : 0
	var/headroom = max(0, reserve - (crown_purse.account_balance - amount))
	var/skim = round(min(max(0, amount - headroom), treasury_debt))
	if(skim <= 0)
		return
	var/reason = "FTC loan repayment"
	if(treasury_state == ROGUE_TREASURY_SEQUESTERED)
		reason = "Sequestration debt - Ferentian Trading Company"
	else if(treasury_state == ROGUE_TREASURY_ARREARS)
		reason = "Arrears repayment - Burghers of Rotwood Vale"
	crown_purse.adjust_money(-skim, reason)
	treasury_debt -= skim
	if(treasury_debt <= 0)
		treasury_debt = 0
		clear_treasury_debt_state()

/// The Crown's debt is paid: out of arrears or sequestration, or the trading company's grace is restored (Ratwood clear_treasury_debt_state()).
/datum/controller/subsystem/rogue_treasury/proc/clear_treasury_debt_state()
	switch(treasury_state)
		if(ROGUE_TREASURY_SOLVENT)
			if(ftc_grace_spent)
				ftc_grace_spent = FALSE
				priority_announce("The Crown's debt to the Ferentian Trading Company is settled. The Burghers' grace stands restored.", "FTC LOAN SETTLED", 'modular_redtard/rockhill/sound/misc/royal_decree2.ogg')
		if(ROGUE_TREASURY_ARREARS)
			treasury_state = ROGUE_TREASURY_SOLVENT
			ftc_grace_spent = FALSE
			priority_announce("The Crown has settled its arrears with the Burghers. The realm is solvent once more.", "THE BURGHERS PAID", 'modular_redtard/rockhill/sound/misc/royal_decree2.ogg')
		if(ROGUE_TREASURY_SEQUESTERED)
			exit_sequestration()

/// The trading company releases the realm: working capital, wages, the stockpile, and the ruler's concessions (Ratwood exit_bankruptcy()).
/datum/controller/subsystem/rogue_treasury/proc/exit_sequestration()
	if(treasury_state != ROGUE_TREASURY_SEQUESTERED)
		return
	treasury_state = ROGUE_TREASURY_SOLVENT
	var/recovery = round(ROGUE_RECOVERY_PURSE)
	if(crown_purse.account_balance < recovery)
		crown_purse.adjust_money(recovery - crown_purse.account_balance, "Sequestration lifted: working capital")
	autoexport_share = ROGUE_AUTOEXPORT_SHARE
	concession_picks = round(ROGUE_CONCESSION_PICKS)
	ftc_grace_spent = FALSE
	treasury_debt = 0
	tell_wage_earners(span_notice("My wages have been reinstated as the Crown's sequestration lifts."))
	priority_announce("The Ferentian Trading Company releases the Crown's commerce. Wages resume on the morrow. The Lord may, by ancient prerogative, restore up to [concession_picks] of the suspended Charters at once; all others must wait the customary span between proclamations.", "SEQUESTRATION LIFTED", 'modular_redtard/rockhill/sound/misc/royal_decree.ogg')
	log_game("TREASURY: sequestration lifted")

/// Tells every subject the Crown pays a wage.
/datum/controller/subsystem/rogue_treasury/proc/tell_wage_earners(message)
	for(var/datum/bank_account/rogue/account as anything in accounts)
		var/mob/living/owner = account.owner()
		if(owner && daily_payments[account.job_title()])
			to_chat(owner, message)

/// Why the trading company will not lend to the Crown now, or null (Ratwood atc_loan_blocker_reason()).
/datum/controller/subsystem/rogue_treasury/proc/ftc_loan_blocker()
	if(treasury_state == ROGUE_TREASURY_SEQUESTERED)
		return "The Company administers commerce. No further loans until sequestration lifts."
	if(ROGUE_TREASURY_DAY >= ROGUE_FTC_LOAN_CLOSED_DAY)
		return "The Guilds clerk is out of office. The loan window has closed for the week."
	if(ftc_grace_spent)
		return "A prior advance stands unpaid. The Company refuses a second loan until the first is settled."
	return null

/**
 * The Crown borrows from the trading company at a quarter's interest (Ratwood take_atc_loan()): a debt repaid from the Purse's
 * income, and the Burghers' grace is spent, so the next payroll the Purse cannot meet is a sequestration.
 */
/datum/controller/subsystem/rogue_treasury/proc/take_ftc_loan(amount, mob/applicant)
	var/blocker = ftc_loan_blocker()
	if(blocker)
		to_chat(applicant, span_warning("Loan refused: [blocker]"))
		return FALSE
	amount = clamp(round(amount), ROGUE_FTC_LOAN_MIN, ROGUE_FTC_LOAN_MAX)
	var/debt = round(amount * (1 + ROGUE_FTC_LOAN_INTEREST))
	treasury_debt += debt
	ftc_loans_drawn++
	ftc_grace_spent = TRUE
	// Straight into the Purse, not through mint(), or the principal would go to the debt it just created.
	crown_purse.adjust_money(amount, "FTC emergency loan (principal)")
	priority_announce("The Crown takes an advance of [amount]m from the Ferentian Trading Company at the customary one-quarter interest, registering a debt of [debt]m. The arrears grace stands forfeit; should the Crown miss its next payroll, the realm enters sequestration without warning.", "THE CROWN BORROWS", 'modular_redtard/rockhill/sound/misc/royal_decree.ogg')
	log_game("FTC LOAN: [key_name(applicant)] drew [amount]m principal from the Ferentian Trading Company; debt of [debt]m registered")
	return TRUE

/// Treasures of the Crown the trading company carts off at a sequestration (Ratwood GLOB.atc_seizure_inventory).
GLOBAL_LIST_INIT(rogue_ftc_seizures, list(
	"the Lord's gilded bathing-tub",
	"a brace of falcons from the royal mews",
	"an illuminated psyalter bound in shagreen",
	"the great Otavan tapestry depicting the Hunt of the Boar",
	"two gilded saltcellars in the Etruscan fashion",
	"three sealed coffers of the Crown's pearls",
	"the household reliquary (less the relic)",
	"a Naledian astrolabe with three missing pins",
	"the Steward's reserve of saffron and cinnamon",
	"an ivory chess-set, six pieces short",
	"a brocaded canopy bed, taken down with great difficulty",
	"the chapel's spare gilt candelabrum",
	"the last Marshal's silver-mounted hunting-horn",
	"a portrait of a long-forgotten ancestor, slashed by a disgruntled debtor",
	"the Court Cupbearer's pewter inventory and the keys to it",
	"a jewel-encrusted bathtub of indecent proportion",
	"twelve casks of Bleakcoast firewine, marked for the Midwinter feast",
	"a Kazengun lacquered wardrobe of indeterminate vintage",
	"an Etruscan illuminated bestiary, water-damaged",
	"a clutch of Heartfelt clockwork toys, ticking faintly",
	"the menagerie's pet civet, of doubtful temperament",
	"the great clock of the Crown, dismantled in three carts",
	"twelve hundred yards of Naledian silk, the Crown's spare livery",
	"the Crown's reserve of Saltwick anchovies, packed in oil",
	"the Crown's emergency Kingsfield cheese reserve",
	"two white stag heads, taxidermied from the last royal hunt",
	"a crate of unknown white liquid of uncertain provenance, labeled 'CROWN ONLY - Not for Consumption'",
	"a sealed crate marked PROPERTY OF THE LATE STEWARD",
))

/// Two or three of the Crown's treasures, listed for the proclamation (Ratwood atc_seizure_blurb()).
/proc/rogue_ftc_seizure_blurb()
	var/list/pool = GLOB.rogue_ftc_seizures.Copy()
	var/list/picks = list()
	for(var/i in 1 to rand(2, 3))
		picks += pick_n_take(pool)
	if(length(picks) == 2)
		return "[picks[1]]; and [picks[2]]"
	return "[picks[1]]; [picks[2]]; and [picks[3]]"
