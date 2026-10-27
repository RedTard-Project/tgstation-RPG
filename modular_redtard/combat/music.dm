/// The area music slot of rockhill/area_sounds.dm (ROCKHILL_SOUND_MUSIC there): its define comes later in the include
/// order than the combat files, so the slot is named here again. Combat music takes that slot over.
#define ROGUE_CMODE_MUSIC_SLOT "music"
#define ROGUE_CMODE_MUSIC_DEFAULT_NAME "Default"
#define ROGUE_CMODE_MUSIC_VOLUME rogue_value("cmode_music_volume")

/// Ratwood's combat music (mob_helpers.dm toggle_cmode(), SSdroning.play_combat_music()): on medieval maps someone in
/// combat mode hears their combat track in place of the area music, and the area music comes back when they leave it.
/// The track is the one picked with the Combat Mode Music verb, else the subclass's, else the job's (Ratwood's
/// cmode_music, combat/ported_music.dm), else the towner's. It plays on the area music's channel at its volume
/// preference times cmode_music_volume, loops, and keeps playing across areas; a deaf or dead person hears none. The
/// tracks are read from disk when played, like the area music (combat/sound/music/, which tools/port_combat_music.py
/// fills); a track the server lacks is skipped for the next choice.
/mob/living/carbon/human
	/// Tracks picked with the Combat Mode Music verb (Ratwood cmode_music_override); none means the role's.
	var/list/rogue_cmode_music_override
	var/rogue_cmode_music_override_name

/// A track of the Combat Mode Music verb (Ratwood /datum/combat_music); the list is generated in combat/ported_music.dm.
/datum/rogue_combat_music
	var/name
	var/desc
	var/credits
	var/list/musicpath

GLOBAL_LIST_EMPTY(rogue_combat_music_tracks)

/// The selectable tracks by name, built once.
/proc/rogue_combat_music_tracks()
	if(!length(GLOB.rogue_combat_music_tracks))
		for(var/track_type in subtypesof(/datum/rogue_combat_music))
			var/datum/rogue_combat_music/track = new track_type
			GLOB.rogue_combat_music_tracks[track.name] = track
	return GLOB.rogue_combat_music_tracks

/// The tracks of this person's role: the subclass's, else the job's, else the default; only files the server has.
/mob/living/carbon/human/proc/rogue_role_combat_music()
	var/list/found
	if(rockhill_advclass)
		found = rockhill_existing_sounds(GLOB.rogue_cmode_music_roles["[rockhill_advclass.type]"])
	if(!found && mind?.assigned_role)
		found = rockhill_existing_sounds(GLOB.rogue_cmode_music_roles["[mind.assigned_role.type]"])
	return found || rockhill_existing_sounds(GLOB.rogue_cmode_music_default)

/// What plays in this person's music slot now: their combat tracks in combat mode, else null (the area music).
/mob/living/carbon/human/proc/rogue_combat_music_now()
	if(!combat_mode || stat == DEAD || HAS_TRAIT(src, TRAIT_DEAF) || !rogue_combat_enabled())
		return null
	return rockhill_existing_sounds(rogue_cmode_music_override) || rogue_role_combat_music()

/client/rockhill_play_area_sound(slot, list/options, volume)
	if(slot == ROGUE_CMODE_MUSIC_SLOT && ishuman(mob))
		var/mob/living/carbon/human/fighter = mob
		var/list/combat_tracks = fighter.rogue_combat_music_now()
		if(combat_tracks)
			return ..(slot, combat_tracks, min(volume * ROGUE_CMODE_MUSIC_VOLUME, 100))
	return ..()

GAME_VERB_DESC(/client, rogue_combat_music, "Combat Mode Music", "Pick the track this character hears in combat mode.", "OOC")
	var/mob/living/carbon/human/fighter = mob
	if(!istype(fighter) || !rogue_combat_enabled())
		to_chat(src, span_warning("Only a living person in this world has combat music."))
		return
	var/list/choices = list(ROGUE_CMODE_MUSIC_DEFAULT_NAME)
	for(var/track_name in rogue_combat_music_tracks())
		choices += track_name
	var/picked = tgui_input_list(fighter, "Choose the track I hear in combat mode. Default is the one of my role.", "Combat Music", choices, fighter.rogue_cmode_music_override_name || ROGUE_CMODE_MUSIC_DEFAULT_NAME)
	if(isnull(picked) || QDELETED(fighter) || mob != fighter)
		return
	var/datum/rogue_combat_music/track = GLOB.rogue_combat_music_tracks[picked]
	fighter.rogue_cmode_music_override = track?.musicpath
	fighter.rogue_cmode_music_override_name = track?.name
	to_chat(src, span_notice("Selected track: <b>[picked]</b>."))
	if(track?.desc)
		to_chat(src, "<i>[track.desc]</i>")
	if(track?.credits)
		to_chat(src, span_info("Song name: <b>[track.credits]</b>"))
	fighter.rockhill_refresh_area_sounds()

#undef ROGUE_CMODE_MUSIC_SLOT
#undef ROGUE_CMODE_MUSIC_DEFAULT_NAME
#undef ROGUE_CMODE_MUSIC_VOLUME
