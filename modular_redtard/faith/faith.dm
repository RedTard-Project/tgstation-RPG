/// Faith on medieval maps (Ratwood code/datums/gods/_patron.dm, Vibelin's can_pray()): the patrons of heritage/ hear prayers
/// and judge them, lend their clergy devotion (devotion.dm) and miracles (miracle.dm). A patron hears a prayer only from a
/// church of the Ten, within sight of one of its idols or crosses, or through one of its holy symbols worn or held
/// (Vibelin). The prayer to a patron is the "pray" emote; TG's Pray verb is left as it is, the way to call the admins on
/// every map. Modern maps keep TG's chaplain.
/proc/rogue_faith_enabled()
	return SSmapping.current_map?.map_era == MAP_ERA_MEDIEVAL

#define ROGUE_TEN_SYMBOLS \
	/obj/item/clothing/neck/roguetown/psicross, \
	/obj/item/clothing/neck/roguetown/psicross/g, \
	/obj/item/clothing/neck/roguetown/psicross/silver, \
	/obj/item/clothing/neck/roguetown/psicross/wood, \
	/obj/item/clothing/neck/roguetown/psicross/ten, \
	/obj/item/clothing/neck/roguetown/psicross/undivided, \
	/obj/item/clothing/neck/roguetown/psicross/silver/undivided
#define ROGUE_TEN_IDOLS \
	/obj/structure/fluff/psycross, \
	/obj/structure/fluff/psycross/copper, \
	/obj/structure/fluff/psycross/crafted
#define ROGUE_INHUMEN_SYMBOLS \
	/obj/item/clothing/neck/roguetown/psicross/inhumen, \
	/obj/item/clothing/neck/roguetown/psicross/inhumen/ancient, \
	/obj/item/clothing/neck/roguetown/psicross/inhumen/g
#define ROGUE_PROFANITY "cock", "dick", "fuck", "shit", "pussy", "cuck", "cunt", "asshole", "pintle"

/datum/patron
	/// Holy symbols, exact types, that carry a prayer to this patron worn or held (Vibelin associated_objects[PATRON_AMULET]).
	var/list/rogue_faith_symbols
	/// Idols and crosses, exact types, that carry a prayer to this patron within sight (Vibelin associated_objects[PATRON_STRUCTURE]).
	var/list/rogue_faith_idols
	/// A church carries the prayer without a symbol (Vibelin church_prayer).
	var/rogue_faith_church = FALSE
	/// Its holy light burns the undead instead of mending them (Ratwood undead_hater).
	var/rogue_faith_undead_hater = TRUE
	/// Words that offend it in a prayer and bring down its fire (Ratwood profane_words).
	var/list/rogue_faith_profanity = list("zizo", "matthios", "graggar", "baotha", ROGUE_PROFANITY)

/datum/patron/divine
	rogue_faith_symbols = list(ROGUE_TEN_SYMBOLS)
	rogue_faith_idols = list(ROGUE_TEN_IDOLS)
	rogue_faith_church = TRUE

/datum/patron/divine/abyssor
	rogue_faith_symbols = list(
		ROGUE_TEN_SYMBOLS,
		/obj/item/clothing/neck/roguetown/psicross/abyssor,
		/obj/item/clothing/neck/roguetown/psicross/pearl,
		/obj/item/clothing/neck/roguetown/psicross/bpearl,
		/obj/item/clothing/neck/roguetown/psicross/shell,
		/obj/item/clothing/neck/roguetown/psicross/shell/bracelet,
		)
	rogue_faith_idols = list(ROGUE_TEN_IDOLS, /obj/structure/fluff/statue/abyssor, /obj/structure/fluff/statue/abyssor/dolomite)

/datum/patron/divine/astrata
	rogue_faith_symbols = list(ROGUE_TEN_SYMBOLS, /obj/item/clothing/neck/roguetown/psicross/astrata, /obj/item/clothing/neck/roguetown/psicross/silver/astrata/oathmarked)
	rogue_faith_idols = list(ROGUE_TEN_IDOLS, /obj/structure/fluff/statue/astrata, /obj/structure/fluff/statue/astrata/gold)

/datum/patron/divine/dendor
	rogue_faith_symbols = list(ROGUE_TEN_SYMBOLS, /obj/item/clothing/neck/roguetown/psicross/dendor)

/datum/patron/divine/eora
	rogue_faith_symbols = list(ROGUE_TEN_SYMBOLS, /obj/item/clothing/neck/roguetown/psicross/eora)
	rogue_faith_idols = list(ROGUE_TEN_IDOLS, /obj/structure/fluff/statue/eora)

/datum/patron/divine/malum
	rogue_faith_symbols = list(ROGUE_TEN_SYMBOLS, /obj/item/clothing/neck/roguetown/psicross/malum, /obj/item/clothing/neck/roguetown/psicross/malum/secret)

/datum/patron/divine/necra
	rogue_faith_symbols = list(ROGUE_TEN_SYMBOLS, /obj/item/clothing/neck/roguetown/psicross/necra)
	rogue_faith_idols = list(ROGUE_TEN_IDOLS, /obj/structure/fluff/psycross/crafted/necra)

/datum/patron/divine/noc
	rogue_faith_symbols = list(ROGUE_TEN_SYMBOLS, /obj/item/clothing/neck/roguetown/psicross/noc)
	rogue_faith_idols = list(ROGUE_TEN_IDOLS, /obj/structure/fluff/statue/noc)

/datum/patron/divine/pestra
	rogue_faith_symbols = list(ROGUE_TEN_SYMBOLS, /obj/item/clothing/neck/roguetown/psicross/pestra)

/datum/patron/divine/ravox
	rogue_faith_symbols = list(ROGUE_TEN_SYMBOLS, /obj/item/clothing/neck/roguetown/psicross/ravox)

/datum/patron/psydon
	rogue_faith_symbols = list(
		/obj/item/clothing/neck/roguetown/psicross,
		/obj/item/clothing/neck/roguetown/psicross/g,
		/obj/item/clothing/neck/roguetown/psicross/silver,
		/obj/item/clothing/neck/roguetown/psicross/wood,
		/obj/item/clothing/neck/roguetown/psicross/reform,
		/obj/item/clothing/neck/roguetown/psicross/weeping,
		/obj/item/clothing/neck/roguetown/psicross/decrepit,
		/obj/item/clothing/neck/roguetown/psicross/naledi,
		)
	rogue_faith_idols = list(
		/obj/structure/fluff/psycross/psycrucifix,
		/obj/structure/fluff/psycross/psycrucifix/silver,
		/obj/structure/fluff/psycross/psycrucifix/stone,
		/obj/structure/fluff/statue/psy,
		)

/datum/patron/inhumen
	rogue_faith_symbols = list(ROGUE_INHUMEN_SYMBOLS)
	rogue_faith_undead_hater = FALSE
	rogue_faith_profanity = list(ROGUE_PROFANITY)

/datum/patron/inhumen/baotha
	rogue_faith_idols = list(/obj/structure/fluff/psycross/baotha, /obj/structure/fluff/psycross/baotha/decorated)

/datum/patron/inhumen/graggar
	rogue_faith_idols = list(/obj/structure/fluff/psycross/graggar, /obj/structure/fluff/psycross/graggar/decorated)

/datum/patron/inhumen/graggar_zizo
	rogue_faith_idols = list(
		/obj/structure/fluff/psycross/graggar,
		/obj/structure/fluff/psycross/graggar/decorated,
		/obj/structure/fluff/psycross/zizocross,
		/obj/structure/fluff/psycross/zizocross/golden,
		/obj/structure/fluff/psycross/zizocross/stone,
		)

/datum/patron/inhumen/matthios
	rogue_faith_idols = list(/obj/structure/fluff/psycross/matthios, /obj/structure/fluff/psycross/matthios/decorated, /obj/structure/fluff/statue/evil)

/datum/patron/inhumen/zizo
	rogue_faith_idols = list(
		/obj/structure/fluff/psycross/zizocross,
		/obj/structure/fluff/psycross/zizocross/golden,
		/obj/structure/fluff/psycross/zizocross/stone,
		/obj/structure/fluff/statue/femalestatue/zizo,
		)

/// Vibelin can_pray(): the follower is in a church of this patron, near one of its idols, or wears or holds its symbol.
/datum/patron/proc/rogue_hears(mob/living/carbon/human/follower)
	if(rogue_faith_church && istype(get_area(follower), /area/rogue/indoors/town/church))
		return TRUE
	if(rogue_holds_symbol(follower))
		return TRUE
	if(!length(rogue_faith_idols))
		return FALSE
	for(var/obj/structure/idol in view(rogue_value("faith_idol_range"), get_turf(follower)))
		if(idol.type in rogue_faith_idols)
			return TRUE
	return FALSE

/// One of this patron's holy symbols is worn or held (not in a pocket).
/datum/patron/proc/rogue_holds_symbol(mob/living/carbon/human/follower)
	if(!length(rogue_faith_symbols))
		return FALSE
	for(var/obj/item/worn as anything in follower.get_equipped_items(INCLUDE_HELD))
		if(worn.type in rogue_faith_symbols)
			return TRUE
	return FALSE

/// Ratwood hear_prayer(): a prayer too short is not heard, an insult brings down the patron's fire, a prayer that names the
/// patron pleases it; prayers close together count as one. TRUE if the prayer was heard and did not offend.
/datum/patron/proc/rogue_judge_prayer(mob/living/carbon/human/follower, prayer)
	if(length(prayer) < rogue_value("faith_prayer_min_length"))
		to_chat(follower, span_warning("My prayer is too weak to be considered!"))
		return FALSE
	var/lowered = LOWER_TEXT(prayer)
	for(var/profanity in rogue_faith_profanity)
		if(findtext(lowered, profanity))
			rogue_punish_prayer(follower)
			return FALSE
	var/last_prayer = follower.rogue_last_prayer
	follower.rogue_last_prayer = world.time
	if(last_prayer && world.time < last_prayer + rogue_value("faith_prayer_interval"))
		return FALSE
	if(findtext(lowered, LOWER_TEXT(name)))
		rogue_reward_prayer(follower)
	return TRUE

/// Ratwood punish_prayer(): the offended patron sets the follower alight.
/datum/patron/proc/rogue_punish_prayer(mob/living/carbon/human/follower)
	follower.adjust_fire_stacks(rogue_value("faith_smite_fire_stacks"))
	follower.ignite_mob()
	follower.add_mood_event("rogue_prayer", /datum/mood_event/rogue_smitten)
	to_chat(follower, span_userdanger("[display_title()] is offended by my words!"))

/// Ratwood reward_prayer(): a prayer that calls the patron by name comforts the follower.
/datum/patron/proc/rogue_reward_prayer(mob/living/carbon/human/follower)
	follower.playsound_local(follower, 'modular_redtard/faith/sound/bless.ogg', 100, FALSE)
	follower.add_mood_event("rogue_prayer", /datum/mood_event/rogue_heard_prayer)

/mob/living/carbon/human
	/// When this follower's last prayer reached their patron (Ratwood mob_timers[MT_PSYPRAY]).
	var/rogue_last_prayer = 0

/datum/mood_event/rogue_heard_prayer
	description = "My god heard my prayer."
	mood_change = 2
	timeout = 5 MINUTES

/datum/mood_event/rogue_smitten
	description = "I have angered my god!"
	mood_change = -4
	timeout = 10 MINUTES

/// The prayer to one's patron (Ratwood's and Vibelin's pray emote): whispered, judged by the patron if it hears it, and read
/// by the admins like TG's Pray. Medieval maps only; without a patron it is a plain emote.
/datum/emote/living/carbon/human/rogue_pray
	key = "pray"
	key_third_person = "prays"
	message = "prays something."
	cooldown = 2 SECONDS

/datum/emote/living/carbon/human/rogue_pray/can_run_emote(mob/user, status_check = TRUE, intentional = FALSE, params)
	return rogue_faith_enabled() && ..()

/datum/emote/living/carbon/human/rogue_pray/run_emote(mob/user, params, type_override, intentional)
	var/mob/living/carbon/human/follower = user
	if(!intentional || !istype(follower) || !follower.rogue_patron)
		return ..()
	INVOKE_ASYNC(follower, TYPE_PROC_REF(/mob/living/carbon/human, rogue_pray))

/mob/living/carbon/human/proc/rogue_pray()
	var/datum/patron/patron = rogue_patron
	if(!patron)
		return
	var/heard = patron.rogue_hears(src)
	if(!heard)
		to_chat(src, span_danger(patron.prayer_fail || "My prayers go unheard here."))
	var/prayer = tgui_input_text(src, "Whisper your prayer:", "Prayer", max_length = MAX_MESSAGE_LEN, encode = FALSE)
	if(!prayer || QDELETED(src) || stat == DEAD)
		return
	whisper(prayer)
	var/shown_prayer = sanitize(prayer)
	log_prayer("[key]/([real_name]) (follower of [patron.name]): [shown_prayer]")
	var/admin_message = span_adminnotice("<b><font color=purple>PRAYER (to [patron.name]): </font>[ADMIN_FULLMONTY(src)] [ADMIN_SC(src)]:</b> [span_linkify(shown_prayer)]")
	for(var/client/admin as anything in GLOB.admins)
		if(get_chat_toggles(admin) & CHAT_PRAYER)
			to_chat(admin, admin_message, type = MESSAGE_TYPE_PRAYER, confidential = TRUE)
	if(heard)
		patron.rogue_judge_prayer(src, prayer)

#undef ROGUE_TEN_SYMBOLS
#undef ROGUE_TEN_IDOLS
#undef ROGUE_INHUMEN_SYMBOLS
#undef ROGUE_PROFANITY
