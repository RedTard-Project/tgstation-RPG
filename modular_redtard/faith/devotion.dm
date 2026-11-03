/// Ratwood's devotion (controllers/subsystem/rogue/miscprocs.dm /datum/devotion): the favour of a devotee's patron that pays
/// for miracles. Prayer fills it ("Give Prayer"), the ordained regain it slowly by themselves, faster the better they are at
/// miracles (the Miracles skill makes it up to twice as fast). Progression climbs with it through Ratwood's tiers; in Ratwood
/// a new tier unlocks the patron's miracles, here the miracles wait in the basket (miracle.dm) until the owner gives them
/// out, so a tier only tells the devotee how far they have come.
/datum/rogue_devotion
	var/mob/living/carbon/human/holder
	/// Devotion held (Ratwood devotion).
	var/devotion = 0
	/// Most devotion held at once (Ratwood max_devotion).
	var/max_devotion = 0
	/// Ratwood progression, the experience of the tiers.
	var/progression = 0
	var/max_progression = 0
	/// The tier reached (ROGUE_MIRACLE_TIER_*).
	var/level = ROGUE_MIRACLE_TIER_0
	/// Devotion and progression regained every faith_regen_interval (Ratwood passive_devotion_gain).
	var/passive_gain = 0
	var/praying = FALSE
	var/datum/action/rogue_devotion_prayer/prayer_action

/datum/rogue_devotion/New(mob/living/carbon/human/new_holder)
	. = ..()
	holder = new_holder
	holder.rogue_devotion = src
	max_devotion = rogue_value("faith_devotion_tier1")
	max_progression = rogue_value("faith_devotion_tier4")
	prayer_action = new(src)
	prayer_action.Grant(holder)
	RegisterSignal(holder, COMSIG_QDELETING, PROC_REF(on_holder_deleted))
	RegisterSignal(holder, COMSIG_MOB_GET_STATUS_TAB_ITEMS, PROC_REF(on_status_tab))

/datum/rogue_devotion/Destroy(force)
	STOP_PROCESSING(SSprocessing, src)
	QDEL_NULL(prayer_action)
	if(holder)
		UnregisterSignal(holder, list(COMSIG_QDELETING, COMSIG_MOB_GET_STATUS_TAB_ITEMS))
		holder.rogue_devotion = null
		holder = null
	return ..()

/datum/rogue_devotion/proc/on_holder_deleted(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/rogue_devotion/proc/on_status_tab(mob/living/source, list/items)
	SIGNAL_HANDLER
	items += "Devotion: [round(devotion)]/[max_devotion]"

/// Ratwood grant_miracles() without the miracles: tier - where progression starts; passive - devotion regained every regen
/// interval; limit - the cap of devotion and progression (null: Ratwood's default, devotion up to tier 1 and progression
/// up to tier 4); start_maxed - full from the start, with a devotion cap of tier 4 whatever the limit.
/datum/rogue_devotion/proc/setup(tier = ROGUE_MIRACLE_TIER_0, passive = 0, limit, start_maxed = FALSE)
	level = tier
	max_devotion = limit || rogue_value("faith_devotion_tier1")
	max_progression = limit || rogue_value("faith_devotion_tier4")
	progression = min(rogue_devotion_tier_requirement(tier), max_progression)
	devotion = 0
	passive_gain = passive
	if(passive_gain)
		START_PROCESSING(SSprocessing, src)
	else
		STOP_PROCESSING(SSprocessing, src)
	if(start_maxed)
		max_devotion = rogue_value("faith_devotion_tier4")
		devotion = max_devotion
		progression = max_progression
		return
	var/start = rogue_value("faith_start_devotion")
	adjust(start, start, silent = TRUE)

/datum/rogue_devotion/process(seconds_per_tick)
	if(!passive_gain || QDELETED(holder))
		return PROCESS_KILL
	var/gain = passive_gain * skill_multiplier() * (seconds_per_tick SECONDS) / rogue_value("faith_regen_interval")
	adjust(gain, gain, silent = TRUE)

/// The Miracles skill quickens prayer and regain: x1 untrained, x2 legendary (Ratwood 1 + holy / SKILL_LEVEL_LEGENDARY).
/datum/rogue_devotion/proc/skill_multiplier()
	return 1 + holder.rogue_skill_rank(/datum/attribute/skill/magic/holy) / ROGUE_SKILL_RANK_MAX

/// Ratwood update_devotion(): devotion within its limit; progression up to the next tiers.
/datum/rogue_devotion/proc/adjust(devotion_change, progression_change = 0, silent = FALSE)
	devotion = clamp(devotion + devotion_change, 0, max_devotion)
	if(devotion_change > 0 && devotion >= max_devotion && !silent)
		to_chat(holder, span_warning("I have reached the limit of my devotion..."))
	if(progression_change <= 0)
		return
	progression = clamp(progression + progression_change, 0, max_progression)
	var/reached = level
	while(reached < ROGUE_MIRACLE_TIER_4 && progression >= rogue_devotion_tier_requirement(reached + 1))
		reached++
	if(reached == level)
		return
	level = reached
	if(!silent)
		to_chat(holder, span_boldnotice("My devotion deepens: I have reached tier [level] of my faith."))

/// Ratwood clericpray() "Give Prayer": kneeling in prayer, the devotee regains devotion every few seconds, more with the
/// Miracles skill, until the limit, a move, or the end of the prayer. The patron must hear it (faith.dm); a witch draws
/// on the old ways instead.
/datum/rogue_devotion/proc/pray()
	if(praying || QDELETED(holder))
		return
	var/mob/living/carbon/human/devotee = holder
	var/datum/patron/patron = devotee.rogue_patron
	if(!rogue_faith_enabled() || !patron)
		to_chat(devotee, span_warning("My prayers go unheard here."))
		return
	if(HAS_TRAIT(devotee, TRAIT_WITCH))
		to_chat(devotee, span_warning("What need have I to pray? I draw my power from the old ways, whether my patron likes it or not."))
		return
	if(!patron.rogue_hears(devotee))
		to_chat(devotee, span_danger(patron.prayer_fail || "My prayers go unheard here."))
		return
	if(devotion >= max_devotion)
		to_chat(devotee, span_warning("I have reached the limit of my devotion..."))
		return
	praying = TRUE
	devotee.visible_message(span_notice("[devotee] kneels [devotee.p_their()] head in prayer to the Gods."), span_notice("I kneel my head in prayer to [patron.display_title()]."))
	var/gained = 0
	for(var/cycle in 1 to rogue_value("faith_prayer_cycles"))
		if(devotion >= max_devotion)
			break
		if(!do_after(devotee, rogue_value("faith_prayer_cycle"), target = devotee, interaction_key = "rogue_prayer"))
			break
		var/amount = round(rogue_value("faith_prayer_devotion") * skill_multiplier())
		var/before = devotion
		adjust(amount, amount)
		gained += devotion - before
	praying = FALSE
	if(QDELETED(devotee))
		return
	devotee.visible_message(span_notice("[devotee] concludes [devotee.p_their()] prayer."), span_notice("I conclude my prayer."))
	to_chat(devotee, "<font color='purple'>I gained [gained] devotion!</font>")

/// The progression a tier needs (Ratwood CLERIC_REQ_*).
/proc/rogue_devotion_tier_requirement(tier)
	switch(tier)
		if(ROGUE_MIRACLE_TIER_1)
			return rogue_value("faith_devotion_tier1")
		if(ROGUE_MIRACLE_TIER_2)
			return rogue_value("faith_devotion_tier2")
		if(ROGUE_MIRACLE_TIER_3)
			return rogue_value("faith_devotion_tier3")
		if(ROGUE_MIRACLE_TIER_4)
			return rogue_value("faith_devotion_tier4")
	return 0

/mob/living/carbon/human
	/// The devotion of a devotee of the gods (devotion.dm); null for everyone else.
	var/datum/rogue_devotion/rogue_devotion

/// The devotion of the human, made if they have none.
/mob/living/carbon/human/proc/rogue_get_devotion()
	return rogue_devotion || new /datum/rogue_devotion(src)

/// The prayer button of a devotee (Ratwood's "Give Prayer" verb of the Cleric tab).
/datum/action/rogue_devotion_prayer
	name = "Give Prayer"
	desc = "Kneel in prayer to regain devotion. My patron must hear me: in a church, near one of its idols, or with its holy symbol."
	button_icon = ROGUE_MIRACLES_PSYDON_ICON
	button_icon_state = "PRAYER"
	background_icon = ROGUE_MIRACLES_ICON
	background_icon_state = "spell0"
	check_flags = AB_CHECK_CONSCIOUS

/datum/action/rogue_devotion_prayer/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return
	var/datum/rogue_devotion/devotion = target
	INVOKE_ASYNC(devotion, TYPE_PROC_REF(/datum/rogue_devotion, pray))

/// Ratwood's devotion of the clergy and the other devout roles (grant_miracles() and reset_clergy_devotion() in their
/// outfits), keyed by the outfit that dresses them here: start tier, the faith_regen_* value of their regain, the
/// faith_devotion_tier* value that caps them (null: Ratwood's default) and whether they start full. Where Ratwood asks the
/// player to choose and grants differently, the first choice is taken. No miracles come with it.
GLOBAL_LIST_INIT(rogue_role_devotion, list(
	/datum/outfit/job/roguetown/priest = list(ROGUE_MIRACLE_TIER_4, "faith_regen_major", "faith_devotion_tier4", TRUE),
	/datum/outfit/job/roguetown/monk = list(ROGUE_MIRACLE_TIER_4, "faith_regen_major", "faith_devotion_tier4", TRUE),
	/datum/outfit/job/roguetown/druid = list(ROGUE_MIRACLE_TIER_4, "faith_regen_major", "faith_devotion_tier4", TRUE),
	/datum/outfit/job/roguetown/keeper = list(ROGUE_MIRACLE_TIER_4, "faith_regen_major", null, TRUE),
	/datum/outfit/job/roguetown/templar = list(ROGUE_MIRACLE_TIER_2, "faith_regen_minor", "faith_devotion_tier2", FALSE),
	/datum/outfit/job/roguetown/chaplain = list(ROGUE_MIRACLE_TIER_1, "faith_regen_minor", "faith_devotion_tier1", FALSE),
	/datum/outfit/job/roguetown/absolver = list(ROGUE_MIRACLE_TIER_4, "faith_regen_absolver", null, TRUE),
	/datum/outfit/job/roguetown/rockhill_class/churchling = list(ROGUE_MIRACLE_TIER_2, "faith_regen_devotee", "faith_devotion_tier2", FALSE),
	/datum/outfit/job/roguetown/rockhill_class/churchling/neophyte = list(ROGUE_MIRACLE_TIER_1, "faith_regen_devotee", "faith_devotion_tier1", FALSE),
	/datum/outfit/job/roguetown/rockhill_class/cleric = list(ROGUE_MIRACLE_TIER_1, "faith_regen_devotee", "faith_devotion_tier1", FALSE),
	/datum/outfit/job/roguetown/rockhill_class/cleric/paladin = list(ROGUE_MIRACLE_TIER_1, "faith_regen_weak", "faith_devotion_tier1", FALSE),
	/datum/outfit/job/roguetown/rockhill_class/cleric/cantor = list(ROGUE_MIRACLE_TIER_2, "faith_regen_minor", "faith_devotion_tier2", FALSE),
	/datum/outfit/job/roguetown/rockhill_class/cleric/missionary = list(ROGUE_MIRACLE_TIER_4, "faith_regen_major", "faith_devotion_tier3", FALSE),
	/datum/outfit/job/roguetown/rockhill_class/cleric/stigmata = list(ROGUE_MIRACLE_TIER_4, "faith_regen_stigmata", null, TRUE),
	/datum/outfit/job/roguetown/rockhill_class/foreigner/gronn = list(ROGUE_MIRACLE_TIER_2, "faith_regen_minor", "faith_devotion_tier2", FALSE),
	/datum/outfit/job/roguetown/rockhill_class/foreigner/refugee = list(ROGUE_MIRACLE_TIER_4, "faith_regen_major", null, TRUE),
	/datum/outfit/job/roguetown/rockhill_class/foreigner/dunewell = list(ROGUE_MIRACLE_TIER_2, "faith_regen_devotee", "faith_devotion_tier1", FALSE),
	/datum/outfit/job/roguetown/rockhill_class/heartfelt/retinue/prior = list(ROGUE_MIRACLE_TIER_4, "faith_regen_major", null, TRUE),
	/datum/outfit/job/roguetown/rockhill_class/kj_chaplain = list(ROGUE_MIRACLE_TIER_4, "faith_regen_major", "faith_devotion_tier3", FALSE),
	/datum/outfit/job/roguetown/rockhill_class/kj_chaplain_stigmata = list(ROGUE_MIRACLE_TIER_4, "faith_regen_stigmata", null, TRUE),
	/datum/outfit/job/roguetown/rockhill_class/witch = list(ROGUE_MIRACLE_TIER_2, "faith_regen_witch", "faith_devotion_tier2", FALSE),
	/datum/outfit/job/roguetown/rockhill_class/vagabond_excommunicated = list(ROGUE_MIRACLE_TIER_1, "faith_regen_minor", null, FALSE),
	/datum/outfit/job/roguetown/rockhill_class/wretch/antipope = list(ROGUE_MIRACLE_TIER_4, "faith_regen_major", null, TRUE),
	/datum/outfit/job/roguetown/rockhill_class/wretch/herald_of_progress = list(ROGUE_MIRACLE_TIER_3, "faith_regen_minor", null, TRUE),
	/datum/outfit/job/roguetown/rockhill_class/wretch/heretic = list(ROGUE_MIRACLE_TIER_4, "faith_regen_minor", null, TRUE),
	/datum/outfit/job/roguetown/rockhill_class/wretch/heretic/spy = list(ROGUE_MIRACLE_TIER_4, "faith_regen_minor", null, TRUE),
	/datum/outfit/job/roguetown/rockhill_class/wretch/heretic/monk = list(ROGUE_MIRACLE_TIER_1, "faith_regen_minor", "faith_devotion_tier1", TRUE),
	/datum/outfit/job/roguetown/rockhill_class/wretch/lunacyembracer = list(ROGUE_MIRACLE_TIER_3, "faith_regen_major", null, FALSE),
	/datum/outfit/job/roguetown/rockhill_class/wretch/wretchedtoiler = list(ROGUE_MIRACLE_TIER_2, "faith_regen_devotee", "faith_devotion_tier2", FALSE),
	/datum/outfit/job/roguetown/rockhill_class/psydoniantemplar = list(ROGUE_MIRACLE_TIER_2, "faith_regen_minor", "faith_devotion_tier2", FALSE),
	/datum/outfit/job/roguetown/rockhill_class/disciple = list(ROGUE_MIRACLE_TIER_2, "faith_regen_minor", "faith_devotion_tier2", FALSE),
	/datum/outfit/job/roguetown/rockhill_class/arbalist = list(ROGUE_MIRACLE_TIER_2, "faith_regen_weak", "faith_devotion_tier1", FALSE),
	/datum/outfit/job/roguetown/rockhill_class/confessor = list(ROGUE_MIRACLE_TIER_2, "faith_regen_weak", "faith_devotion_tier1", FALSE),
	/datum/outfit/job/roguetown/rockhill_class/psyaltrist = list(ROGUE_MIRACLE_TIER_2, "faith_regen_minor", "faith_devotion_tier2", FALSE),
	/datum/outfit/job/roguetown/rockhill_class/sojourner = list(ROGUE_MIRACLE_TIER_2, "faith_regen_weak", "faith_devotion_tier1", FALSE),
	/datum/outfit/job/roguetown/rockhill_class/puritan/arbiter = list(ROGUE_MIRACLE_TIER_2, "faith_regen_major", "faith_devotion_tier3", FALSE),
	/datum/outfit/job/roguetown/rockhill_class/puritan/inspector = list(ROGUE_MIRACLE_TIER_2, "faith_regen_minor", "faith_devotion_tier2", FALSE),
	/datum/outfit/job/roguetown/rockhill_class/puritan/ordinator = list(ROGUE_MIRACLE_TIER_2, "faith_regen_minor", "faith_devotion_tier2", FALSE),
	/datum/outfit/job/roguetown/rockhill_class/mercenary/atgervi = list(ROGUE_MIRACLE_TIER_2, "faith_regen_weak", "faith_devotion_tier2", FALSE),
	/datum/outfit/job/roguetown/rockhill_class/mercenary/atgervi/shaman = list(ROGUE_MIRACLE_TIER_2, "faith_regen_weak", "faith_devotion_tier1", FALSE),
	/datum/outfit/job/roguetown/rockhill_class/mercenary/warscholar/vizier = list(ROGUE_MIRACLE_TIER_4, "faith_regen_major", null, TRUE),
	))

/// The devotion an outfit of a devout role brings (GLOB.rogue_role_devotion), set anew if the devotee had some.
/proc/rogue_grant_role_devotion(mob/living/carbon/human/devotee, outfit_type)
	var/list/entry = GLOB.rogue_role_devotion[outfit_type]
	if(!entry || !istype(devotee))
		return FALSE
	var/datum/rogue_devotion/devotion = devotee.rogue_get_devotion()
	devotion.setup(entry[1], rogue_value(entry[2]), entry[3] ? rogue_value(entry[3]) : null, entry[4])
	return TRUE

/// The devout roles get their devotion, and the interrogators Test Faith (confession.dm), with their clothes, as Ratwood
/// grants them in the outfit's pre_equip().
/datum/outfit/job/roguetown/equip(mob/living/carbon/human/user, visuals_only = FALSE)
	. = ..()
	if(visuals_only || !rogue_faith_enabled() || !istype(user))
		return
	rogue_grant_role_devotion(user, type)
	rogue_grant_interrogation(user, type)
