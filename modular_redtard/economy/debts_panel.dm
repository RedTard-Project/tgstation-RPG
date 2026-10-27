/obj/structure/roguemachine/atm
	/// The window of debts and dues a right click on this NERVELOCK opens.
	var/datum/rogue_debts_panel/debts_panel

/obj/structure/roguemachine/atm/Destroy()
	QDEL_NULL(debts_panel)
	return ..()

/// A right click on a NERVELOCK opens the subject's debts and dues: their loan and the poll tax (Ratwood MeisterPanel, Loans and Poll Tax tabs).
/obj/structure/roguemachine/atm/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || !ishuman(user) || !rogue_economy_enabled())
		return
	if(HAS_TRAIT(user, TRAIT_OUTLAW))
		to_chat(user, span_warning("The machine rejects you, sensing your status as an outlaw in these lands."))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!SSrogue_treasury.get_account(user))
		refuse("No account found. Submit your fingers for inspection.")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!debts_panel)
		debts_panel = new(src)
	debts_panel.ui_interact(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/**
 * Debts and dues at a NERVELOCK: the subject's personal loan, which they may repay early from their account, and their poll
 * tax, which they may pay days ahead (Ratwood atm_tgui.dm handle_repay_loan(), handle_advance_poll_tax()).
 */
/datum/rogue_debts_panel
	var/obj/structure/roguemachine/atm/machine

/datum/rogue_debts_panel/New(obj/structure/roguemachine/atm/machine)
	. = ..()
	src.machine = machine

/datum/rogue_debts_panel/Destroy()
	SStgui.close_uis(src)
	machine = null
	return ..()

/datum/rogue_debts_panel/ui_host(mob/user)
	return machine

/datum/rogue_debts_panel/ui_state(mob/user)
	return GLOB.human_adjacent_state

/datum/rogue_debts_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RogueDebts", "NERVELOCK")
		ui.open()

/datum/rogue_debts_panel/ui_data(mob/user)
	var/datum/controller/subsystem/rogue_treasury/treasury = SSrogue_treasury
	var/datum/bank_account/rogue/account = treasury.get_account(user)
	var/list/data = list()
	data["holder"] = account?.account_holder
	data["balance"] = account?.account_balance || 0
	data["day"] = ROGUE_TREASURY_DAY
	var/datum/rogue_loan/loan = treasury.loan_for(account)
	data["loan"] = loan?.ui_entry()
	var/class_id = treasury.poll_class(user)
	data["poll"] = list(
		"class" = class_id ? GLOB.rogue_poll_classes[class_id] : null,
		"rate" = treasury.poll_rate_for(user, class_id),
		"exempt" = class_id && treasury.poll_charter_exempt(user, class_id),
		"owed" = account?.poll_owed || 0,
		"overdue" = account?.poll_overdue_days || 0,
		"advance" = account?.poll_advance_days || 0,
		"advance_max" = ROGUE_POLL_ADVANCE_MAX,
		"fallback" = ROGUE_POLL_ADVANCE_FALLBACK,
		"opened" = world.time - SSticker.round_start_time >= ROGUE_POLL_ADVANCE_LOCKOUT,
	)
	return data

/datum/rogue_debts_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/user = ui.user
	var/datum/controller/subsystem/rogue_treasury/treasury = SSrogue_treasury
	if(!istype(user) || HAS_TRAIT(user, TRAIT_OUTLAW))
		return TRUE
	switch(action)
		if("repay")
			var/datum/rogue_loan/loan = treasury.loan_for(treasury.get_account(user))
			if(!loan)
				machine.say("No active loan on record.")
				return TRUE
			var/paid = treasury.repay_loan(loan, text2num("[params["amount"]]"))
			if(!paid)
				machine.refuse("Nothing to repay with.")
				return TRUE
			playsound(machine, ROGUE_SOUND_COIN_INSERT, 100, FALSE, -1)
			machine.say(loan in treasury.loans ? "[paid]m transferred. [loan.remaining_due()]m remains." : "Loan repaid in full. [paid]m transferred.")
		if("advance")
			if(treasury.pay_poll_advance(user, text2num("[params["days"]]")))
				playsound(machine, ROGUE_SOUND_COIN_INSERT, 100, FALSE, -1)
			else
				playsound(machine, ROGUE_SOUND_MACHINE_NO, 100, FALSE, -1)
	return TRUE
