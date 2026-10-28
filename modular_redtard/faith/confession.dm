/// Ratwood's interrogation of faith (Inquisition/puritan.dm faith_test(), confess_sins()): an interrogator holding a restrained
/// victim, with a silver psycross in the other hand and a cross nearby, demands whom the victim prays to; after a while the
/// victim cries out what their patron would have them cry (the patron's confess_lines, heritage/) - or that they are
/// innocent - and the psycross burns away. The Inquisition, the dungeoneer and the monster hunter get it (Ratwood).
/// Ratwood's Reveal Allegiance asks the same of antagonists, who are not ported yet (stage 5).

/// The outfits whose wearers may test faith (Ratwood: faith_test is given in their pre_equip()).
GLOBAL_LIST_INIT(rogue_faith_interrogators, list(
	/datum/outfit/job/roguetown/dungeoneer,
	/datum/outfit/job/roguetown/rockhill_class/confessor,
	/datum/outfit/job/roguetown/rockhill_class/puritan/arbiter,
	/datum/outfit/job/roguetown/rockhill_class/puritan/inspector,
	/datum/outfit/job/roguetown/rockhill_class/puritan/ordinator,
	/datum/outfit/job/roguetown/rockhill_class/sfighter/mhunter,
	))

/// The Test Faith button for an outfit of the interrogators, once.
/proc/rogue_grant_interrogation(mob/living/carbon/human/interrogator, outfit_type)
	if(!(outfit_type in GLOB.rogue_faith_interrogators) || (locate(/datum/action/rogue_faith_test) in interrogator.actions))
		return FALSE
	var/datum/action/rogue_faith_test/test = new(interrogator)
	test.Grant(interrogator)
	return TRUE

/datum/action/rogue_faith_test
	name = "Test Faith"
	desc = "Holding a restrained victim and, in the other hand, a silver psycross, by a cross: they will cry out whom they pray to. The psycross burns away."
	button_icon = ROGUE_MIRACLES_PSYDON_ICON
	button_icon_state = "ABSOLVE"
	background_icon = ROGUE_MIRACLES_ICON
	background_icon_state = "spell0"
	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_HANDS_BLOCKED

/datum/action/rogue_faith_test/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/interrogator = owner
	if(istype(interrogator))
		INVOKE_ASYNC(interrogator, TYPE_PROC_REF(/mob/living/carbon/human, rogue_test_faith))

/// Whom this human holds in their active hand: Ratwood's grab of this module, or TG's aggressive grab.
/mob/living/carbon/human/proc/rogue_held_victim()
	var/obj/item/hand_item/rogue_grab/grab = get_active_held_item()
	if(istype(grab) && ishuman(grab.grabbed))
		return grab.grabbed
	if(ishuman(pulling) && grab_state >= GRAB_AGGRESSIVE)
		return pulling
	return null

/mob/living/carbon/human/proc/rogue_test_faith()
	if(!rogue_faith_enabled())
		return
	var/mob/living/carbon/human/victim = rogue_held_victim()
	if(!victim || victim == src)
		to_chat(src, span_warning("I don't have a victim in my hands!"))
		return
	if(!HAS_TRAIT(victim, TRAIT_RESTRAINED) && !victim.handcuffed)
		to_chat(src, span_warning("My victim needs to be restrained in order to do this!"))
		return
	var/obj/item/clothing/neck/roguetown/psicross/silver/cross = get_inactive_held_item()
	if(!istype(cross))
		to_chat(src, span_warning("I need to be holding a silver psycross to extract this divination!"))
		return
	if(!(locate(/obj/structure/fluff/psycross) in oview(rogue_value("faith_confess_cross_range"), src)))
		to_chat(src, span_warning("I need a large psycross structure nearby to extract this divination!"))
		return
	if(victim.stat != STABLE)
		to_chat(src, span_warning("This one is not in a ready state to be questioned..."))
		return
	var/static/list/faith_lines = list(
		"TO WHOM DO YOU PRAY!?",
		"WHO IS YOUR GOD!?",
		"ARE YOU FAITHFUL!?",
		"WHO IS YOUR SHEPHERD!?",
		)
	visible_message(span_warning("[src] shoves the silver psycross in [victim]'s face!"))
	say(pick(faith_lines), forced = "test of faith")
	victim.emote("scream")
	if(!do_after(src, rogue_value("faith_confess_time"), target = victim) || QDELETED(cross) || get_inactive_held_item() != cross)
		return
	visible_message(span_warning("[src]'s silver psycross abruptly catches flame, burning away in an instant!"))
	qdel(cross)
	victim.rogue_confess()

/// Ratwood confess_sins("patron"): the victim cries out one of their patron's confessions, or their innocence.
/mob/living/carbon/human/proc/rogue_confess()
	var/static/list/innocent_lines = list(
		"I AM NO SINNER!",
		"I'M INNOCENT!",
		"I HAVE NOTHING TO CONFESS!",
		"I AM FAITHFUL!",
		)
	var/list/confessions = rogue_patron?.confess_lines
	say(length(confessions) ? pick(confessions) : pick(innocent_lines), forced = "confession")
