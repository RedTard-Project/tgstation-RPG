/// Ratwood's literacy (mob/living/carbon/human/is_literate(), modules/library/book.dm read(), paperwork/paper.dm read()):
/// on medieval maps a person with a mind reads and writes only with the reading skill learned to Novice. TG's checks stay
/// on top of it (the brain's literacy, the illiterate quirk, light), and every TG reading and writing check follows it:
/// books, paper, the quill, signs. Trying to read a book or a written sheet without it teaches a little of the skill.

/mob/living/carbon/human/is_literate()
	. = ..()
	if(!. || !mind || !rogue_library_enabled() || !istype(attributes))
		return
	return rogue_learned_rank(ROGUE_READING_SKILL) >= ROGUE_RANK_NOVICE

/mob/living/carbon/human/can_read(atom/viewed_atom, reading_check_flags = (READING_CHECK_LITERACY|READING_CHECK_LIGHT), silent = FALSE)
	. = ..()
	if(. || silent || !(reading_check_flags & READING_CHECK_LITERACY) || !rogue_library_enabled() || is_literate())
		return
	rogue_try_reading(viewed_atom)

/// Ratwood: an illiterate reader who tries a book learns a little more than one who tries a written sheet. TG asks again
/// while a reading window stays open, so the experience comes at most once a second.
/mob/living/carbon/human/proc/rogue_try_reading(atom/viewed_atom)
	if(!mind || TIMER_COOLDOWN_RUNNING(src, ROGUE_READING_XP_COOLDOWN))
		return
	var/experience = 0
	if(istype(viewed_atom, /obj/item/book))
		experience = ROGUE_READ_XP_BOOK
	else if(istype(viewed_atom, /obj/item/manuscript))
		experience = ROGUE_READ_XP_PAPER
	else if(istype(viewed_atom, /obj/item/paper))
		var/obj/item/paper/sheet = viewed_atom
		if(sheet.rogue_is_written())
			experience = ROGUE_READ_XP_PAPER
	if(experience <= 0)
		return
	TIMER_COOLDOWN_START(src, ROGUE_READING_XP_COOLDOWN, 1 SECONDS)
	rogue_adjust_experience(ROGUE_READING_SKILL, experience)
