/// The area music slot of rockhill/area_sounds.dm (ROCKHILL_SOUND_MUSIC there): its define comes later in the include
/// order than the combat files, so the slot is named here again. Combat music takes that slot over.
#define ROGUE_CMODE_MUSIC_SLOT "music"
#define ROGUE_CMODE_MUSIC_DEFAULT_NAME "Default"
#define ROGUE_CMODE_MUSIC_VOLUME rogue_value("cmode_music_volume")
/// The channel slot (rockhill_sound_channel()) of a track heard in the character menu.
#define ROGUE_CMODE_MUSIC_PREVIEW_SLOT "cmode_preview"
/// The preview's volume when the area music is muted.
#define ROGUE_CMODE_MUSIC_PREVIEW_VOLUME 50

/// Ratwood's combat music (mob_helpers.dm toggle_cmode(), SSdroning.play_combat_music()): on medieval maps someone in
/// combat mode hears their combat track in place of the area music, and the area music comes back when they leave it.
/// The track is the one picked in the character menu (the rogue_combat_music preference, charsetup/combat_music.dm;
/// Ratwood's combat_music preference) or for this life with the Combat Mode Music verb, else the subclass's, else the
/// job's (Ratwood's cmode_music, combat/ported_music.dm), else the towner's. It plays on the area music's channel at its
/// volume preference times cmode_music_volume, loops, and keeps playing across areas; a deaf or dead person hears none.
/// The tracks are read from disk when played, like the area music (combat/sound/music/, kept in git as on Ratwood;
/// tools/port_combat_music.py re-ports it); a track the server lacks is skipped for the next choice.
/mob/living/carbon/human
	/// The picked tracks (Ratwood cmode_music_override); none means the role's.
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

/// A track by its name, or null.
/proc/rogue_combat_music_track(track_name)
	var/list/tracks = rogue_combat_music_tracks()
	return istext(track_name) ? tracks[track_name] : null

/// What one may pick: "Default" (the role's), then every track by name.
/proc/rogue_combat_music_choices()
	. = list(ROGUE_CMODE_MUSIC_DEFAULT_NAME)
	for(var/track_name in rogue_combat_music_tracks())
		. += track_name

/// Picks a track by name for this person; "Default" or a name no track has leaves the role's.
/mob/living/carbon/human/proc/rogue_set_combat_music(track_name)
	var/datum/rogue_combat_music/track = rogue_combat_music_track(track_name)
	rogue_cmode_music_override = track?.musicpath
	rogue_cmode_music_override_name = track?.name

/// Plays a track once to this player, as Ratwood's picker lets one listen (pick_combat_music_with_listen()), at the area
/// music's volume; FALSE when the server lacks it.
/client/proc/rogue_preview_combat_music(track_name)
	var/datum/rogue_combat_music/track = rogue_combat_music_track(track_name)
	var/list/files = rockhill_existing_sounds(track?.musicpath)
	if(!files)
		return FALSE
	var/volume = prefs?.read_preference(/datum/preference/numeric/volume/sound_ship_ambience_volume) || ROGUE_CMODE_MUSIC_PREVIEW_VOLUME
	var/sound/preview = sound(pick(files), repeat = FALSE, wait = 0, channel = rockhill_sound_channel(ROGUE_CMODE_MUSIC_PREVIEW_SLOT), volume = volume)
	preview.status = SOUND_STREAM
	SEND_SOUND(src, preview)
	return TRUE

/client/proc/rogue_stop_combat_music_preview()
	SEND_SOUND(src, sound(null, channel = rockhill_sound_channel(ROGUE_CMODE_MUSIC_PREVIEW_SLOT)))

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
	var/picked = tgui_input_list(fighter, "Choose the track I hear in combat mode for this life; the character menu keeps it for good. Default is the one of my role.", "Combat Music", rogue_combat_music_choices(), fighter.rogue_cmode_music_override_name || ROGUE_CMODE_MUSIC_DEFAULT_NAME)
	if(isnull(picked) || QDELETED(fighter) || mob != fighter)
		return
	fighter.rogue_set_combat_music(picked)
	var/datum/rogue_combat_music/track = rogue_combat_music_track(picked)
	to_chat(src, span_notice("Selected track: <b>[picked]</b>."))
	if(track?.desc)
		to_chat(src, "<i>[track.desc]</i>")
	if(track?.credits)
		to_chat(src, span_info("Song name: <b>[track.credits]</b>"))
	fighter.rockhill_refresh_area_sounds()

#undef ROGUE_CMODE_MUSIC_SLOT
#undef ROGUE_CMODE_MUSIC_DEFAULT_NAME
#undef ROGUE_CMODE_MUSIC_VOLUME
#undef ROGUE_CMODE_MUSIC_PREVIEW_SLOT
#undef ROGUE_CMODE_MUSIC_PREVIEW_VOLUME
