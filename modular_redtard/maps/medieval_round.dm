#define ROGUE_ROUND_CONTINUE "Continue Playing"
#define ROGUE_ROUND_END "End Round"
#define ROGUE_ROUND_EXTEND_COOLDOWN (1 MINUTES)
#define ROGUE_ROUND_EXTEND_LIMIT 3

/datum/config_entry/number/rogue_round_minutes
	default = 165
	integer = TRUE
	min_val = 10

/datum/config_entry/number/rogue_round_extension_minutes
	default = 30
	integer = TRUE
	min_val = 1

/datum/config_entry/number/rogue_round_end_minutes
	default = 15
	integer = TRUE
	min_val = 1

GLOBAL_VAR(rogue_round_vote_at)
GLOBAL_VAR_INIT(rogue_round_ends_at, 0)
GLOBAL_VAR_INIT(rogue_round_extended_at, 0)

/proc/rogue_round_rules()
	return SSmapping.current_map?.map_era == MAP_ERA_MEDIEVAL

/proc/rogue_round_extension()
	return CONFIG_GET(number/rogue_round_extension_minutes) MINUTES

/datum/controller/subsystem/ticker/check_finished()
	. = ..()
	if(. || !setup_done || !rogue_round_rules())
		return
	if(GLOB.rogue_round_ends_at)
		return world.time >= GLOB.rogue_round_ends_at
	if(isnull(GLOB.rogue_round_vote_at))
		GLOB.rogue_round_vote_at = round_start_time + CONFIG_GET(number/rogue_round_minutes) MINUTES
	if(world.time < GLOB.rogue_round_vote_at || SSvote.current_vote)
		return FALSE
	SSvote.initiate_vote(/datum/vote/rogue_endround, pick("Zlod", "Sun King", "Gaia", "Moon Queen", "Aeon", "Gemini", "Aries"), forced = TRUE)
	return FALSE

/datum/vote/rogue_endround
	name = "End Round"
	default_message = "Vote to end the current story."
	winner_method = VOTE_WINNER_METHOD_SIMPLE
	default_choices = list(
		ROGUE_ROUND_CONTINUE,
		ROGUE_ROUND_END,
	)

/datum/vote/rogue_endround/can_be_initiated(forced = FALSE)
	. = ..()
	if(. != VOTE_AVAILABLE)
		return
	if(!rogue_round_rules())
		return "This vote only exists on medieval maps."
	if(GLOB.rogue_round_ends_at)
		return "The round is already ending."
	if(!forced)
		return "Only admins can start this vote."

/datum/vote/rogue_endround/get_vote_result(list/non_voters)
	var/total = 0
	for(var/option in choices)
		total += choices[option]
	if(!total)
		choices[ROGUE_ROUND_CONTINUE] = 1
	return ..()

/datum/vote/rogue_endround/finalize_vote(winning_option)
	if(winning_option != ROGUE_ROUND_END)
		log_game("Round end vote: continue playing.")
		GLOB.rogue_round_vote_at = world.time + rogue_round_extension()
		return
	log_game("Round end vote: the round ends in [CONFIG_GET(number/rogue_round_end_minutes)] minutes.")
	GLOB.rogue_round_ends_at = world.time + CONFIG_GET(number/rogue_round_end_minutes) MINUTES
	to_chat(world, span_boldannounce("The story is drawing to a close. The round ends in [CONFIG_GET(number/rogue_round_end_minutes)] minutes."))

/mob/get_status_tab_items()
	. = ..()
	if(!rogue_round_rules() || !SSticker.HasRoundStarted())
		return
	if(GLOB.rogue_round_ends_at)
		. += "Round ends in: [DisplayTimeText(max(0, GLOB.rogue_round_ends_at - world.time), 1)]"
	else if(GLOB.rogue_round_vote_at)
		. += "End round vote in: [DisplayTimeText(max(0, GLOB.rogue_round_vote_at - world.time), 60)]"

ADMIN_VERB(rogue_extend_round, R_ADMIN, "Extend Round", "Push the end round vote, or the end itself, back by the extension time.", ADMIN_CATEGORY_ROGUE)
	if(!rogue_round_rules())
		to_chat(user, span_warning("This map ends rounds the TG way."))
		return
	var/extension = rogue_round_extension()
	if(tgui_alert(user, "Push the end of the round back by [DisplayTimeText(extension)]?", "Extend Round", list("Yes", "Cancel")) != "Yes")
		return
	if(world.time < GLOB.rogue_round_extended_at + ROGUE_ROUND_EXTEND_COOLDOWN)
		to_chat(user, span_notice("Someone extended the round a moment ago. Wait a minute."))
		return
	var/target = GLOB.rogue_round_ends_at || GLOB.rogue_round_vote_at || (SSticker.round_start_time + CONFIG_GET(number/rogue_round_minutes) MINUTES)
	if(target - world.time > ROGUE_ROUND_EXTEND_LIMIT * extension)
		to_chat(user, span_notice("The round end is already more than [ROGUE_ROUND_EXTEND_LIMIT] extensions away."))
		return
	if(GLOB.rogue_round_ends_at)
		GLOB.rogue_round_ends_at += extension
	else
		GLOB.rogue_round_vote_at = target + extension
	GLOB.rogue_round_extended_at = world.time
	message_admins("[key_name_admin(user)] extended the round by [DisplayTimeText(extension)].")
	log_admin("[key_name(user)] extended the round by [DisplayTimeText(extension)].")
	BLACKBOX_LOG_ADMIN_VERB("Extend Round")

ADMIN_VERB(rogue_end_round_vote, R_ADMIN, "End Round Vote", "Start the end round vote right now.", ADMIN_CATEGORY_ROGUE)
	if(!rogue_round_rules() || !SSticker.HasRoundStarted())
		to_chat(user, span_warning("There is no medieval round to end."))
		return
	if(!SSvote.initiate_vote(/datum/vote/rogue_endround, user.key, user.mob, forced = TRUE))
		to_chat(user, span_warning("The vote could not start."))
		return
	message_admins("[key_name_admin(user)] started the end round vote.")
	log_admin("[key_name(user)] started the end round vote.")
	BLACKBOX_LOG_ADMIN_VERB("End Round Vote")

#undef ROGUE_ROUND_CONTINUE
#undef ROGUE_ROUND_END
#undef ROGUE_ROUND_EXTEND_COOLDOWN
#undef ROGUE_ROUND_EXTEND_LIMIT
