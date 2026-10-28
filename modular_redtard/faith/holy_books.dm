/// The holy books (Ratwood rogueitems/books.dm bibble, psy and zizo; the verses are Azure Peak's strings/): an open holy book
/// is read aloud - a verse from the part the reader picks - instead of page by page, and the Bishop blesses with the Verses
/// and Acts of the Ten on the bless intent: a point of Fortune for a while and a soothing presence. The Lexicon of Zizo has
/// no verses in any source, so it stays a plain book.

/obj/item/book/rogue/bibble
	/// The parts a reader picks from, and the file of each part's verses in ROGUE_FAITH_STRINGS_DIR.
	var/list/verse_parts = list("The Unsundered" = "visage.txt", "The Ruin" = "decanomicon.txt", "The Dawn" = "newdawn.txt")
	/// The Bishop blesses with it (Ratwood: only the Verses and Acts of the Ten).
	var/blesses = TRUE

/obj/item/book/rogue/bibble/psy
	verse_parts = list("PSALMS" = "psysect1.txt", "GENESIS" = "psysect2.txt", "INVOCATIONS" = "psysect3.txt")
	blesses = FALSE

/obj/item/book/rogue/bibble/zizo
	verse_parts = null
	blesses = FALSE

/obj/item/book/rogue/bibble/attack_self(mob/user, modifiers)
	if(!open || !length(verse_parts) || !rogue_faith_enabled())
		return ..()
	if(rogue_can_read(user))
		INVOKE_ASYNC(src, PROC_REF(read_verse), user)
	return TRUE

/// Ratwood bibble/read(): the reader picks a part and speaks one of its verses.
/obj/item/book/rogue/bibble/proc/read_verse(mob/living/user)
	var/part = tgui_input_list(user, "Which part shall I read from?", name, verse_parts)
	if(!part || !open || !user.is_holding(src))
		return
	var/verse = rogue_holy_verse(verse_parts[part])
	if(verse)
		user.say(verse, forced = "holy book")

/obj/item/book/rogue/bibble/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!blesses || !isliving(interacting_with) || !rogue_faith_enabled() || !istype(user.rogue_active_intent(), /datum/intent/bless))
		return NONE
	if(!istype(user.mind?.assigned_role, /datum/job/roguetown/priest))
		return NONE
	if(!user.can_read(src))
		to_chat(user, span_warning("I don't understand these scribbly black lines."))
		return ITEM_INTERACT_BLOCKING
	var/mob/living/blessed = interacting_with
	blessed.apply_status_effect(/datum/status_effect/rogue_holy_blessing)
	blessed.add_mood_event("rogue_blessed", /datum/mood_event/rogue_blessed)
	user.visible_message(span_notice("[user] blesses [blessed]."))
	playsound(user, 'modular_redtard/faith/sound/bless.ogg', 100, FALSE)
	return ITEM_INTERACT_SUCCESS

/// A random verse of a file of verses, read once a round.
/proc/rogue_holy_verse(file_name)
	var/static/list/verses_by_file = list()
	var/list/verses = verses_by_file[file_name]
	if(isnull(verses))
		var/path = "[ROGUE_FAITH_STRINGS_DIR][file_name]"
		verses = fexists(path) ? world.file2list(path) : list()
		verses -= ""
		verses_by_file[file_name] = verses
	return length(verses) ? pick(verses) : null

/// Azure Peak buff/blessed: a point of Fortune for a while.
/datum/status_effect/rogue_holy_blessing
	id = "rogue_holy_blessing"
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null

/datum/status_effect/rogue_holy_blessing/on_creation(mob/living/new_owner)
	duration = rogue_value("faith_blessed_duration")
	return ..()

/datum/status_effect/rogue_holy_blessing/refresh(effect)
	duration = rogue_value("faith_blessed_duration")

/datum/status_effect/rogue_holy_blessing/on_apply()
	var/datum/attribute_holder/holder = owner.attributes
	if(istype(holder))
		holder.set_variable_attribute_modifier(id, list(ROGUE_STAT_FORTUNE = rogue_value("faith_blessed_fortune")))
	return TRUE

/datum/status_effect/rogue_holy_blessing/on_remove()
	var/datum/attribute_holder/holder = owner.attributes
	if(istype(holder))
		holder.remove_attribute_modifier(id)

/// Ratwood stressevent/blessed.
/datum/mood_event/rogue_blessed
	description = "I feel a soothing presence."
	mood_change = 2
	timeout = 60 MINUTES
