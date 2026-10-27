/// Ratwood's combat music preference (preferences.dm combat_music, preferences_savefile.dm _load_combat_music()): the
/// track a medieval character hears in combat mode, picked in the character menu and given to the human at spawn
/// (combat/music.dm). "Default" leaves the role's track; the Combat Mode Music verb still changes it for one life.
/datum/preference/choiced/rogue_combat_music
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "rogue_combat_music"
	should_update_preview = FALSE
	can_randomize = FALSE

/datum/preference/choiced/rogue_combat_music/is_accessible(datum/preferences/preferences)
	return ..() && rogue_lobby_enabled()

/datum/preference/choiced/rogue_combat_music/init_possible_values()
	return rogue_combat_music_choices()

/datum/preference/choiced/rogue_combat_music/create_default_value()
	var/list/choices = get_choices()
	return choices[1]

/datum/preference/choiced/rogue_combat_music/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(rogue_lobby_enabled())
		target.rogue_set_combat_music(value)

/// The tracks as the menu lists them (Ratwood's picker shows the name, then the description and the song): whether the
/// server has the files, so the menu can offer to listen.
/proc/rogue_charsetup_combat_music_catalog()
	var/static/list/catalog
	if(catalog)
		return catalog
	catalog = list()
	var/list/tracks = rogue_combat_music_tracks()
	for(var/track_name in tracks)
		var/datum/rogue_combat_music/track = tracks[track_name]
		catalog += list(list(
			"name" = track.name,
			"desc" = track.desc,
			"credits" = track.credits,
			"playable" = !!rockhill_existing_sounds(track.musicpath),
		))
	return catalog

/// Ratwood's "listen" in its picker: the track once (the catalog's playable tells the window which tracks the server
/// has), or silence.
/datum/rogue_charsetup/proc/preview_combat_music(mob/user, track_name)
	if(istext(track_name))
		user.client?.rogue_preview_combat_music(track_name)
	return FALSE

/datum/rogue_charsetup/proc/stop_combat_music_preview(mob/user)
	user?.client?.rogue_stop_combat_music_preview()
	return FALSE
