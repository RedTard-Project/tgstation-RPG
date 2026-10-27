/// Azure Peak's rules for joining a medieval round (Azure new_player_panel.dm, jobs/_job.dm, admin/patreon.dm): a
/// character needs a description (flavor text) and OOC notes of some length before readying up; whoever readied up
/// before the round gets the ready bonus (a pouch of coins, a hearty breakfast; Azure's triumph is not ported); the
/// server's patrons skip the queue of a full server.

/datum/config_entry/number/rogue_minimum_flavor_text
	default = 200
	integer = TRUE
	min_val = 0

/datum/config_entry/number/rogue_minimum_ooc_notes
	default = 5
	integer = TRUE
	min_val = 0

/// The server's patrons by ckey, one ROGUE_PATRON line each (Azure reads them from its Patreon export).
/datum/config_entry/str_list/rogue_patron
	lowercase = TRUE

/proc/rogue_is_patron(ckey)
	if(!ckey)
		return FALSE
	for(var/entry in CONFIG_GET(str_list/rogue_patron))
		if(ckey(entry) == ckey)
			return TRUE
	return FALSE

/// The character as others read it when they examine closer (Azure's flavor text).
/datum/preference/text/rogue_flavor_text
	savefile_key = "rogue_flavor_text"
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	maximum_value_length = 4096
	should_update_preview = FALSE

/datum/preference/text/rogue_flavor_text/is_accessible(datum/preferences/preferences)
	return ..() && rogue_lobby_enabled()

/datum/preference/text/rogue_flavor_text/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.rogue_flavor_text = value

/// What the player wants others to know out of character (Azure's OOC notes).
/datum/preference/text/rogue_ooc_notes
	savefile_key = "rogue_ooc_notes"
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	maximum_value_length = 1024
	should_update_preview = FALSE

/datum/preference/text/rogue_ooc_notes/is_accessible(datum/preferences/preferences)
	return ..() && rogue_lobby_enabled()

/datum/preference/text/rogue_ooc_notes/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.rogue_ooc_notes = value

/mob/living/carbon/human
	var/rogue_flavor_text
	var/rogue_ooc_notes
	/// The pouch of the ready bonus waits for the class, whose outfit replaces everything worn.
	var/rogue_ready_pouch_pending = FALSE

/mob/living/carbon/human/examine(mob/user)
	. = ..()
	if(rogue_flavor_text || rogue_ooc_notes)
		. += span_notice("<i>You can examine [p_them()] closer to read more about [p_them()].</i>")

/mob/living/carbon/human/examine_more(mob/user)
	. = ..()
	if(rogue_flavor_text)
		. += span_notice(rogue_flavor_text)
	if(rogue_ooc_notes)
		. += span_notice("<b>OOC notes:</b> [rogue_ooc_notes]")

/// Why the player may not ready up yet: the character's description and OOC notes are too short.
/datum/lobby_menu/rogue/proc/rogue_ready_blocked(mob/dead/new_player/player)
	var/datum/preferences/prefs = client.prefs
	var/flavor_needed = CONFIG_GET(number/rogue_minimum_flavor_text)
	if(length(prefs.read_preference(/datum/preference/text/rogue_flavor_text)) < flavor_needed)
		to_chat(player, span_boldwarning("You need a minimum of [flavor_needed] characters in your flavor text in order to play."))
		return TRUE
	if(length(prefs.read_preference(/datum/preference/text/rogue_ooc_notes)) < CONFIG_GET(number/rogue_minimum_ooc_notes))
		to_chat(player, span_boldwarning("You need at least a few words in your OOC notes in order to play."))
		return TRUE
	return FALSE

/// Patrons go to the late join menu even when the server is full and others queue (Azure IsPatreon).
/datum/lobby_menu/rogue/proc/rogue_patron_join(mob/dead/new_player/player)
	if(!rogue_is_patron(player.ckey) || !SSticker?.IsRoundInProgress())
		return FALSE
	SSticker.queued_players -= player
	player.auto_deadmin_on_ready_or_latejoin()
	GLOB.latejoin_menu.ui_interact(player)
	return TRUE

/// The late join menu lets patrons pick a job however full the server is.
/datum/latejoin_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/dead/new_player/owner = ui?.user
	if(action != "select_job" || !istype(owner) || !owner.client || owner.client.interviewee || !rogue_lobby_enabled() || !rogue_is_patron(owner.ckey))
		return ..()
	if(!SSticker?.IsRoundInProgress() || SSlag_switch.measures[DISABLE_NON_OBSJOBS])
		return ..()
	var/job = params["job"]
	if(job == "Random")
		job = get_random_job(owner)
		if(!job)
			return TRUE
	owner.AttemptLateSpawn(job)
	return TRUE

/// The ready bonus of those who readied up before the round (Azure's _job.dm: a stashed pouch of coins, full belly,
/// the good meal); a late joiner does not get it.
/datum/job/roguetown/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	var/mob/living/carbon/human/human = spawned
	if(!istype(human) || !player_client || !rogue_lobby_enabled() || human.mind?.late_joiner)
		return
	human.set_nutrition(NUTRITION_LEVEL_FULL)
	human.apply_status_effect(/datum/status_effect/rogue/good_meal)
	to_chat(human, span_notice("Rising early, you made sure to pack a pouch of coins and eat a hearty breakfast before starting your day."))
	human.rogue_ready_pouch_pending = TRUE
	if(!HAS_TRAIT_FROM(human, TRAIT_IMMOBILIZED, ROCKHILL_ADVCLASS_TRAIT))
		human.rogue_give_ready_pouch()

/datum/rockhill_advclass/apply(mob/living/carbon/human/human)
	. = ..()
	if(human.rogue_ready_pouch_pending)
		human.rogue_give_ready_pouch()

/// Azure's ready-up pouch: twenty mammons in silver.
/mob/living/carbon/human/proc/rogue_give_ready_pouch()
	rogue_ready_pouch_pending = FALSE
	var/obj/item/pouch = new /obj/item/storage/belt/rogue/pouch/coins/readyuppouch(drop_location())
	if(!equip_in_one_of_slots(pouch, list(LOCATION_BACKPACK, LOCATION_HANDS), qdel_on_fail = FALSE))
		to_chat(src, span_notice("Your pouch of coins is at your feet."))

/// Azure's good meal: a hearty breakfast is a point of constitution for half an hour.
/datum/status_effect/rogue/good_meal
	id = "rogue_good_meal"
	base_duration = 30 MINUTES

/datum/status_effect/rogue/good_meal/on_apply()
	. = ..()
	var/datum/attribute_holder/holder = owner.attributes
	if(istype(holder))
		holder.add_attribute_modifier(/datum/attribute_modifier/rogue_good_meal)

/datum/status_effect/rogue/good_meal/on_remove()
	var/datum/attribute_holder/holder = owner.attributes
	if(istype(holder))
		holder.remove_attribute_modifier(/datum/attribute_modifier/rogue_good_meal)
	return ..()

/datum/attribute_modifier/rogue_good_meal
	attribute_list = list(
		ROGUE_STAT_CONSTITUTION = 1,
	)
