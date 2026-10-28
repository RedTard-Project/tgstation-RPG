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

/// Ratwood's generic human voice (its male and female voicepacks; ported/races.dm GLOB.rogue_human_voices) for a body with
/// a plain human tongue on medieval maps: TG's emotes of such a body sound as Ratwood's humans, as a tongue's voice does.
/datum/element/rogue_human_voice
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

/datum/element/rogue_human_voice/Attach(datum/target)
	. = ..()
	if(!ishuman(target))
		return ELEMENT_INCOMPATIBLE
	for(var/key in GLOB.rogue_human_voices)
		RegisterSignal(target, COMSIG_MOB_EMOTE_SOUND(key), PROC_REF(voice))

/datum/element/rogue_human_voice/Detach(datum/source, ...)
	for(var/key in GLOB.rogue_human_voices)
		UnregisterSignal(source, COMSIG_MOB_EMOTE_SOUND(key))
	return ..()

/datum/element/rogue_human_voice/proc/voice(mob/living/carbon/human/source, key, list/sounds)
	SIGNAL_HANDLER
	var/sound = get_emote_sound_from_list(GLOB.rogue_human_voices[key], source)
	if(sound)
		sounds[sound] = EMOTE_SOUND_TONGUE

/// The species' tongue is a plain human one, without a voice of its own.
/datum/species/proc/rogue_has_plain_voice()
	return mutanttongue == /obj/item/organ/tongue

/datum/species/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load, regenerate_icons = TRUE, replace_missing = TRUE)
	. = ..()
	if(rogue_combat_enabled() && rogue_has_plain_voice())
		human_who_gained_species.AddElement(/datum/element/rogue_human_voice)

/datum/species/on_species_loss(mob/living/carbon/human/human, datum/species/new_species, pref_load)
	human.RemoveElement(/datum/element/rogue_human_voice)
	return ..()
