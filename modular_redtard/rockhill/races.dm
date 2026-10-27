/// How Ratwood's races speak, sound and see, on TG's mechanisms; the porter writes the data (ported/races.dm).
/// Languages: Ratwood's orcish and elvish as TG languages, given through the species' language holders and spoken with
/// the race's tongue. Voices: Ratwood's voicepacks as the tongue's emote_sounds by sex, as TG voices its lizards; the
/// voice sounds TG has no emote for (pain, rage, the cry of a burning man) are Ratwood's emotes ported as voice emotes.
/// Sight: Ratwood's TRAIT_DARKVISION as TG's lighting cutoff, and the races' eyes as TG eyes.

/// A race's tongue: its voice (emote_sounds) and its own languages on top of what a human tongue speaks.
/obj/item/organ/tongue/rogue_race
	/// The race's own languages, which a human tongue cannot speak.
	var/list/rogue_languages

/obj/item/organ/tongue/rogue_race/get_possible_languages()
	return ..() | rogue_languages

/// Ratwood's voice sounds without a TG emote. They sound in the voice of the body's race and, as most of Ratwood's, say
/// nothing (nomsg); a race without a voice for one makes no sound.
/datum/emote/living/rogue_vocal
	abstract_type = /datum/emote/living/rogue_vocal
	emote_type = EMOTE_AUDIBLE
	mob_type_blacklist_typecache = list(/mob/living/brain)
	vary = TRUE

/datum/emote/living/rogue_vocal/run_emote(mob/living/user, params, type_override, intentional)
	if(message)
		return ..()
	var/sound = get_sound(user)
	if(!sound || !should_play_sound(user, intentional))
		return FALSE
	playsound(user, sound, sound_volume, vary)
	return TRUE

/// Ratwood's TRAIT_DARKVISION (its LIGHTING_PLANE_ALPHA_DARKVISION): the dark lets as much through as TG's true night
/// vision.
/mob/living/restore_initial_sight()
	. = ..()
	if(HAS_TRAIT(src, TRAIT_DARKVISION))
		lighting_cutoff = max(lighting_cutoff, LIGHTING_CUTOFF_HIGH)

/mob/living/register_init_signals()
	. = ..()
	RegisterSignals(src, list(SIGNAL_ADDTRAIT(TRAIT_DARKVISION), SIGNAL_REMOVETRAIT(TRAIT_DARKVISION)), PROC_REF(update_sight))

/// Ratwood's wild goblin eyes burn whoever is not a goblin.
/obj/item/organ/eyes/night_vision/rogue_wild_goblin/on_life(seconds_per_tick)
	. = ..()
	if(!owner || is_species(owner, /datum/species/rogue_goblinp) || !SPT_PROB(5, seconds_per_tick))
		return
	owner.adjust_tox_loss(5)
	apply_organ_damage(5)
	owner.set_eye_blur_if_lower(6 SECONDS)
	if(prob(50))
		to_chat(owner, span_warning("My eyes burn and my body aches."))
