/// Classes of the poll tax in the order the Steward lists them, with their names (Ratwood get_poll_tax_category_pretty_name()).
GLOBAL_LIST_INIT(rogue_poll_classes, list(
	ROGUE_POLL_NOBLE = "Noble",
	ROGUE_POLL_CLERGY = "Clergy",
	ROGUE_POLL_INQUISITION = "Inquisition",
	ROGUE_POLL_COURTIER = "Courtier",
	ROGUE_POLL_GARRISON = "Garrison",
	ROGUE_POLL_GUILDS = "Guilds",
	ROGUE_POLL_MERCHANT = "Merchant",
	ROGUE_POLL_BURGHER = "Burgher",
	ROGUE_POLL_ADVENTURER = "Adventurer",
	ROGUE_POLL_MERCENARY = "Mercenary",
	ROGUE_POLL_PEASANT = "Peasant",
))

/// The class each Rockhill role pays the poll tax as (Ratwood get_poll_tax_category() over the position lists of jobs.dm).
GLOBAL_LIST_INIT(rogue_poll_class_by_role, list(
	JOB_ROCKHILL_GRAND_DUKE = ROGUE_POLL_NOBLE,
	JOB_ROCKHILL_BARON = ROGUE_POLL_NOBLE,
	JOB_ROCKHILL_PRINCE = ROGUE_POLL_NOBLE,
	JOB_ROCKHILL_HAND = ROGUE_POLL_NOBLE,
	JOB_ROCKHILL_KNIGHT_CAPTAIN = ROGUE_POLL_NOBLE,
	JOB_ROCKHILL_MARSHAL = ROGUE_POLL_NOBLE,
	JOB_ROCKHILL_COUNCILLOR = ROGUE_POLL_NOBLE,
	JOB_ROCKHILL_STEWARD = ROGUE_POLL_NOBLE,
	JOB_ROCKHILL_CLERK = ROGUE_POLL_NOBLE,
	JOB_ROCKHILL_KNIGHT = ROGUE_POLL_NOBLE,
	JOB_ROCKHILL_INQUISITOR = ROGUE_POLL_INQUISITION,
	JOB_ROCKHILL_ORTHODOXIST = ROGUE_POLL_INQUISITION,
	JOB_ROCKHILL_ABSOLVER = ROGUE_POLL_INQUISITION,
	JOB_ROCKHILL_BISHOP = ROGUE_POLL_CLERGY,
	JOB_ROCKHILL_ACOLYTE = ROGUE_POLL_CLERGY,
	JOB_ROCKHILL_KEEPER = ROGUE_POLL_CLERGY,
	JOB_ROCKHILL_TEMPLAR = ROGUE_POLL_CLERGY,
	JOB_ROCKHILL_DRUID = ROGUE_POLL_CLERGY,
	JOB_ROCKHILL_MARTYR = ROGUE_POLL_CLERGY,
	JOB_ROCKHILL_CHURCHLING = ROGUE_POLL_CLERGY,
	JOB_ROCKHILL_COURT_MAGICIAN = ROGUE_POLL_COURTIER,
	JOB_ROCKHILL_MAGICIANS_ASSOCIATE = ROGUE_POLL_COURTIER,
	JOB_ROCKHILL_HEAD_PHYSICIAN = ROGUE_POLL_COURTIER,
	JOB_ROCKHILL_APOTHECARY = ROGUE_POLL_COURTIER,
	JOB_ROCKHILL_JESTER = ROGUE_POLL_COURTIER,
	JOB_ROCKHILL_SENESCHAL = ROGUE_POLL_COURTIER,
	JOB_ROCKHILL_SERVANT = ROGUE_POLL_COURTIER,
	JOB_ROCKHILL_COURT_CHAPLAIN = ROGUE_POLL_COURTIER,
	JOB_ROCKHILL_COURT_AGENT = ROGUE_POLL_COURTIER,
	JOB_ROCKHILL_CITY_GUARD = ROGUE_POLL_GARRISON,
	JOB_ROCKHILL_ROOKIE = ROGUE_POLL_GARRISON,
	JOB_ROCKHILL_FOREST_WARDEN = ROGUE_POLL_GARRISON,
	JOB_ROCKHILL_SERGEANT = ROGUE_POLL_GARRISON,
	JOB_ROCKHILL_RETAINER = ROGUE_POLL_GARRISON,
	JOB_ROCKHILL_VETERAN = ROGUE_POLL_GARRISON,
	JOB_ROCKHILL_MAN_AT_ARMS = ROGUE_POLL_GARRISON,
	JOB_ROCKHILL_SQUIRE = ROGUE_POLL_GARRISON,
	JOB_ROCKHILL_VANGUARD = ROGUE_POLL_GARRISON,
	JOB_ROCKHILL_DUNGEONEER = ROGUE_POLL_GARRISON,
	JOB_ROCKHILL_MASTER_WARDEN = ROGUE_POLL_GARRISON,
	JOB_ROCKHILL_WATCH_CAPTAIN = ROGUE_POLL_GARRISON,
	JOB_ROCKHILL_GUILDMASTER = ROGUE_POLL_GUILDS,
	JOB_ROCKHILL_GUILDSMAN = ROGUE_POLL_GUILDS,
	JOB_ROCKHILL_TAILOR = ROGUE_POLL_GUILDS,
	JOB_ROCKHILL_MERCHANT = ROGUE_POLL_MERCHANT,
	JOB_ROCKHILL_SHOPHAND = ROGUE_POLL_MERCHANT,
	JOB_ROCKHILL_INNKEEPER = ROGUE_POLL_BURGHER,
	JOB_ROCKHILL_BATHMASTER = ROGUE_POLL_BURGHER,
	JOB_ROCKHILL_MERCENARY = ROGUE_POLL_MERCENARY,
	JOB_ROCKHILL_ADVENTURER = ROGUE_POLL_ADVENTURER,
	JOB_ROCKHILL_ENSLAVED_ADVENTURER = ROGUE_POLL_ADVENTURER,
	JOB_ROCKHILL_SOILSON = ROGUE_POLL_PEASANT,
	JOB_ROCKHILL_MANOR_COOK = ROGUE_POLL_PEASANT,
	JOB_ROCKHILL_LUNATIC = ROGUE_POLL_PEASANT,
	JOB_ROCKHILL_TOWNER = ROGUE_POLL_PEASANT,
	JOB_ROCKHILL_TAPSTER = ROGUE_POLL_PEASANT,
	JOB_ROCKHILL_BATHHOUSE_ATTENDANT = ROGUE_POLL_PEASANT,
	JOB_ROCKHILL_SLAVE = ROGUE_POLL_PEASANT,
	JOB_ROCKHILL_PRISONER_TOWN = ROGUE_POLL_PEASANT,
	JOB_ROCKHILL_REFUGEE = ROGUE_POLL_PEASANT,
	JOB_ROCKHILL_VAGABOND = ROGUE_POLL_PEASANT,
	JOB_ROCKHILL_GUILD_APPRENTICE = ROGUE_POLL_PEASANT,
))

/// Ordained roles of the Church (Ratwood GLOB.church_positions): the Concordat shields them, the Church will not lend to them.
GLOBAL_LIST_INIT(rogue_church_roles, list(
	JOB_ROCKHILL_BISHOP,
	JOB_ROCKHILL_ACOLYTE,
	JOB_ROCKHILL_KEEPER,
	JOB_ROCKHILL_TEMPLAR,
	JOB_ROCKHILL_DRUID,
	JOB_ROCKHILL_MARTYR,
))

/// The Holy Otavan Inquisition (Ratwood GLOB.inquisition_positions): the Otavan Accords shield them.
GLOBAL_LIST_INIT(rogue_inquisition_roles, list(
	JOB_ROCKHILL_INQUISITOR,
	JOB_ROCKHILL_ORTHODOXIST,
	JOB_ROCKHILL_ABSOLVER,
))

/// The poll class a role pays as, or null.
/proc/rogue_role_poll_class(title)
	return title ? GLOB.rogue_poll_class_by_role[title] : null

/// The Crown's officers, who know the realm's defaulters and paupers by sight: nobles, courtiers and the garrison.
/proc/rogue_crown_officer(mob/living/viewer)
	return rogue_role_poll_class(viewer?.mind?.assigned_role?.title) in list(ROGUE_POLL_NOBLE, ROGUE_POLL_COURTIER, ROGUE_POLL_GARRISON)

/datum/controller/subsystem/rogue_treasury
	/// Poll class -> mammons a head pays at every dawn; below zero the Crown pays that much as a subsidy (Ratwood poll_tax_rates).
	var/list/poll_tax_rates = list()
	/// The dawn the poll tax was last changed; it changes once a day (Ratwood poll_rates_changed_day).
	var/poll_changed_dawn = -1

/datum/controller/subsystem/rogue_treasury/proc/setup_poll_tax()
	for(var/poll_class in GLOB.rogue_poll_classes)
		poll_tax_rates[poll_class] = 0

/**
 * The class a subject pays the poll tax as, or null for the untaxed: outlaws, the Crown's pensioners and roles in no class
 * (Ratwood get_poll_tax_category()). Noble blood, the Church's benefactors and residents count whatever their role.
 */
/datum/controller/subsystem/rogue_treasury/proc/poll_class(mob/living/subject)
	if(!subject || HAS_TRAIT(subject, TRAIT_OUTLAW) || HAS_TRAIT(subject, TRAIT_ROYAL_SUBSIDY))
		return null
	var/role_class = rogue_role_poll_class(subject.mind?.assigned_role?.title)
	if(role_class == ROGUE_POLL_NOBLE || HAS_TRAIT(subject, TRAIT_NOBLE))
		return ROGUE_POLL_NOBLE
	if(role_class == ROGUE_POLL_INQUISITION)
		return role_class
	if(role_class == ROGUE_POLL_CLERGY || HAS_TRAIT(subject, TRAIT_AGENT_CHURCH))
		return ROGUE_POLL_CLERGY
	if(role_class in list(ROGUE_POLL_COURTIER, ROGUE_POLL_GARRISON, ROGUE_POLL_GUILDS, ROGUE_POLL_MERCHANT, ROGUE_POLL_BURGHER))
		return role_class
	if(HAS_TRAIT(subject, TRAIT_RESIDENT))
		return ROGUE_POLL_BURGHER
	return role_class

/// A charter frees the subject's class from the poll tax: the Great Writ titled nobles, the Concordat the clergy, the Otavan Accords the Inquisition (Ratwood is_poll_tax_charter_exempt()).
/datum/controller/subsystem/rogue_treasury/proc/poll_charter_exempt(mob/living/subject, poll_class)
	switch(poll_class)
		if(ROGUE_POLL_NOBLE)
			return decree_active(ROGUE_DECREE_GREAT_WRIT) && rogue_titled_noble(subject)
		if(ROGUE_POLL_CLERGY)
			return decree_active(ROGUE_DECREE_CONCORDAT)
		if(ROGUE_POLL_INQUISITION)
			return decree_active(ROGUE_DECREE_OTAVAN_ACCORDS)
	return FALSE

/// What the subject pays each dawn; below zero, what the Crown pays them. Exemptions spare only the tax, not a subsidy (Ratwood get_poll_tax_rate_for()).
/datum/controller/subsystem/rogue_treasury/proc/poll_rate_for(mob/living/subject, poll_class)
	if(!poll_class)
		return 0
	var/rate = poll_tax_rates[poll_class] || 0
	if(rate > 0 && poll_charter_exempt(subject, poll_class))
		return 0
	for(var/id in decrees)
		var/datum/rogue_decree/decree = decrees[id]
		if(decree.active)
			rate = decree.poll_cap(subject, poll_class, rate)
	return rate

/// Heads and the poll tax flow of each class for the Steward (Ratwood get_poll_tax_projection()).
/datum/controller/subsystem/rogue_treasury/proc/poll_projection()
	var/list/heads = list()
	var/list/taxable = list()
	for(var/datum/bank_account/rogue/account as anything in accounts)
		var/mob/living/owner = account.owner()
		if(!owner || owner.stat == DEAD)
			continue
		var/class_id = poll_class(owner)
		if(!class_id)
			continue
		heads[class_id] = (heads[class_id] || 0) + 1
		if(!poll_charter_exempt(owner, class_id))
			taxable[class_id] = (taxable[class_id] || 0) + 1
	var/list/classes = list()
	var/income = 0
	var/subsidy = 0
	for(var/class_id in GLOB.rogue_poll_classes)
		var/rate = poll_tax_rates[class_id] || 0
		var/flow = rate > 0 ? rate * (taxable[class_id] || 0) : rate * (heads[class_id] || 0)
		if(flow > 0)
			income += flow
		else
			subsidy -= flow
		classes += list(list(
			"id" = class_id,
			"name" = GLOB.rogue_poll_classes[class_id],
			"rate" = rate,
			"heads" = heads[class_id] || 0,
			"taxable" = taxable[class_id] || 0,
			"flow" = flow,
		))
	return list("classes" = classes, "income" = income, "subsidy" = subsidy)

/// Describes a change of a class's poll rate for the proclamation (Ratwood describe_rate_change()).
/datum/controller/subsystem/rogue_treasury/proc/describe_poll_change(old_rate, new_rate)
	if(old_rate == 0 && new_rate < 0)
		return "subsidy set at [-new_rate]m/day"
	if(old_rate < 0 && new_rate == 0)
		return "subsidy ended"
	if(old_rate < 0 && new_rate > 0)
		return "subsidy replaced by a [new_rate]m/day tax"
	if(old_rate > 0 && new_rate < 0)
		return "tax replaced by a [-new_rate]m/day subsidy"
	if(old_rate < 0 && new_rate < 0)
		return "subsidy [-new_rate > -old_rate ? "increased" : "reduced"] from [-old_rate]m/day to [-new_rate]m/day"
	return "tax [new_rate > old_rate ? "raised" : "reduced"] from [old_rate]m/day to [new_rate]m/day"

/**
 * Sets the poll tax of several classes at once, once a day, and proclaims it (Ratwood apply_poll_rate_adjustments()). Rates run
 * from the largest subsidy to the largest tax; the Magna Carta forbids any tax while it stands. Returns whether anything changed.
 */
/datum/controller/subsystem/rogue_treasury/proc/set_poll_rates(list/new_rates, mob/user)
	if(poll_changed_dawn == ROGUE_TREASURY_DAY)
		to_chat(user, span_warning("Poll tax rates have already been adjusted today - come back tomorrow."))
		return FALSE
	var/carta = decree_active(ROGUE_DECREE_MAGNA_CARTA)
	var/list/lines = list()
	var/tyrannical = FALSE
	for(var/class_id in new_rates)
		if(!(class_id in poll_tax_rates))
			continue
		var/rate = text2num("[new_rates[class_id]]")
		if(isnull(rate))
			continue
		rate = clamp(round(rate), -ROGUE_POLL_MAX_SUBSIDY, ROGUE_POLL_MAX_RATE)
		if(carta && rate > 0)
			to_chat(user, span_warning("The Magna Carta stands: the Crown may tax no head while it is in force."))
			continue
		var/old_rate = poll_tax_rates[class_id] || 0
		if(rate == old_rate)
			continue
		poll_tax_rates[class_id] = rate
		if(rate > old_rate && rate > 0)
			tyrannical = TRUE
		lines += "[GLOB.rogue_poll_classes[class_id]] poll [describe_poll_change(old_rate, rate)]."
	if(!length(lines))
		return FALSE
	poll_changed_dawn = ROGUE_TREASURY_DAY
	priority_announce(jointext(lines, " "), tyrannical ? "The Tyrannical Lord Dictates" : "The Generous Lord Decrees", ROGUE_SOUND_DECREE)
	log_game("POLL TAX RATES: [key_name(user)] changed poll tax rates - [jointext(lines, " | ")]")
	return TRUE

/// Collects the poll tax, or pays the subsidy, of every subject at dawn; what a subject cannot pay they owe (Ratwood tick_poll_tax()).
/datum/controller/subsystem/rogue_treasury/proc/tick_poll_tax()
	for(var/datum/bank_account/rogue/account as anything in accounts)
		var/mob/living/owner = account.owner()
		if(!owner || owner.stat == DEAD)
			continue
		var/class_id = poll_class(owner)
		var/rate = poll_rate_for(owner, class_id)
		if(!rate)
			continue
		var/class_name = GLOB.rogue_poll_classes[class_id]
		if(rate < 0)
			if(transfer(crown_purse, account, -rate, "Poll Subsidy ([class_name])"))
				total_poll_subsidy += -rate
				to_chat(owner, span_notice("<b>POLL SUBSIDY:</b> [-rate]m granted by the Crown."))
			continue
		if(account.poll_advance_days > 0)
			account.poll_advance_days--
			to_chat(owner, span_notice("<b>POLL TAX:</b> Covered by advance. [account.poll_advance_days] day\s remaining."))
			continue
		var/owed = rate + account.poll_owed
		var/paid = min(owed, account.account_balance)
		if(paid > 0 && transfer(account, crown_purse, paid, "Poll Tax ([class_name])"))
			owed -= paid
			total_poll_tax += paid
			to_chat(owner, span_notice("<b>POLL TAX:</b> [paid]m collected."))
		if(owed <= 0)
			clear_poll_arrears(account)
			continue
		account.poll_owed = owed
		account.poll_overdue_days++
		to_chat(owner, span_danger("<b>POLL TAX:</b> You owe the Crown [owed]m. [account.poll_overdue_days] day\s overdue."))
		if(account.poll_overdue_days >= ROGUE_POLL_ARREARS_DAYS && !HAS_TRAIT(owner, TRAIT_ARREARS))
			ADD_TRAIT(owner, TRAIT_ARREARS, ROGUE_TREASURY_TRAIT)
			watch_marks(owner)

/// Money reached a subject behind on the poll tax: the Crown takes what it is owed first.
/datum/controller/subsystem/rogue_treasury/proc/collect_poll_arrears(datum/bank_account/rogue/account)
	var/paid = min(account.poll_owed, account.account_balance)
	if(paid <= 0 || !transfer(account, crown_purse, paid, "Poll Tax arrears"))
		return
	account.poll_owed -= paid
	total_poll_tax += paid
	account.bank_card_talk("[paid]m went to the poll tax you owe the Crown.")
	if(account.poll_owed <= 0)
		clear_poll_arrears(account)

/// Wipes a subject's poll tax debt; days paid ahead stay theirs (Ratwood clear_poll_tax_debt()).
/datum/controller/subsystem/rogue_treasury/proc/clear_poll_arrears(datum/bank_account/rogue/account)
	account.poll_owed = 0
	account.poll_overdue_days = 0
	var/mob/living/owner = account.owner()
	if(owner && HAS_TRAIT_FROM(owner, TRAIT_ARREARS, ROGUE_TREASURY_TRAIT))
		REMOVE_TRAIT(owner, TRAIT_ARREARS, ROGUE_TREASURY_TRAIT)
		refresh_marks(owner)

/**
 * A subject pays days of poll tax ahead at a NERVELOCK (Ratwood poll_tax_pay_advance()): not in the first minutes of the round,
 * not for an exempt or subsidised class, at most a week held. A class with no tax yet pays a fallback rate. Returns success.
 */
/datum/controller/subsystem/rogue_treasury/proc/pay_poll_advance(mob/living/payer, days)
	var/datum/bank_account/rogue/account = get_account(payer)
	days = round(days)
	if(!account || days <= 0)
		return FALSE
	if(world.time - SSticker.round_start_time < ROGUE_POLL_ADVANCE_LOCKOUT)
		to_chat(payer, span_warning("The Crown's ledgers have not yet opened for the day. Try again later."))
		return FALSE
	var/class_id = poll_class(payer)
	if(!class_id)
		to_chat(payer, span_warning("The Crown does not tax your class."))
		return FALSE
	if(poll_charter_exempt(payer, class_id))
		to_chat(payer, span_warning("Your class is exempt from poll tax by decree."))
		return FALSE
	var/rate = poll_rate_for(payer, class_id)
	if(rate < 0)
		to_chat(payer, span_warning("Your class currently receives a Crown subsidy - there is nothing to advance."))
		return FALSE
	if(!rate)
		rate = ROGUE_POLL_ADVANCE_FALLBACK
	var/room = ROGUE_POLL_ADVANCE_MAX - account.poll_advance_days
	if(room <= 0)
		to_chat(payer, span_warning("You already hold the maximum of [ROGUE_POLL_ADVANCE_MAX] days of Poll Tax advance."))
		return FALSE
	days = min(days, room)
	var/cost = rate * days
	if(!account.has_money(cost))
		to_chat(payer, span_warning("Insufficient balance. Need [cost]m for [days] days."))
		return FALSE
	if(!transfer(account, crown_purse, cost, "Poll Tax advance ([days] days)"))
		return FALSE
	total_poll_tax += cost
	account.poll_advance_days += days
	to_chat(payer, span_notice("You have advanced [days] day\s of Poll Tax ([cost]m total). Advance held: [account.poll_advance_days] day\s."))
	log_game("POLL TAX ADVANCE: [key_name(payer)] prepaid [days] days ([cost]m) of poll tax as [class_id]")
	return TRUE
