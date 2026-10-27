/datum/job/roguetown
	// Ratwood roles carry mammons, not TG credits: no TG bank account, paycheck or account number on arrival.
	paycheck = PAYCHECK_ZERO
	paycheck_department = null
	/// The role opens a NERVELOCK account on arrival with this many mammons (Ratwood give_bank_account); null keeps none.
	var/rogue_bank_account
	/// Mammons the role's estate pays every dawn (Ratwood noble_income).
	var/rogue_estate_income = 0

/datum/job/roguetown/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	if(!isnull(rogue_bank_account) && ishuman(spawned))
		SSrogue_treasury.open_account(spawned, rogue_bank_account, rogue_estate_income)
