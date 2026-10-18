GLOBAL_LIST_EMPTY(rockhill_sound_channels)
GLOBAL_LIST_EMPTY(rockhill_sound_exists)

/proc/rockhill_sound_channel(slot)
	if(!GLOB.rockhill_sound_channels[slot])
		GLOB.rockhill_sound_channels[slot] = SSsounds.reserve_sound_channel()
	return GLOB.rockhill_sound_channels[slot]

/proc/rockhill_existing_sounds(list/files)
	if(!length(files))
		return null
	var/list/found = list()
	for(var/path in files)
		if(isnull(GLOB.rockhill_sound_exists[path]))
			GLOB.rockhill_sound_exists[path] = fexists(path)
		if(GLOB.rockhill_sound_exists[path])
			found += path
	return length(found) ? found : null

/area/rogue
	var/rockhill_music_enabled = TRUE
	var/rockhill_loops_enabled = TRUE
	var/list/rockhill_music
	var/list/rockhill_music_dawn
	var/list/rockhill_music_dusk
	var/list/rockhill_music_night
	var/list/rockhill_loop_day
	var/list/rockhill_loop_night
	var/list/rockhill_oneshot_day
	var/list/rockhill_oneshot_night
	var/rockhill_area_text

/area/rogue/proc/rockhill_music_now()
	if(!rockhill_music_enabled)
		return null
	switch(GLOB.rockhill_time_of_day)
		if(ROCKHILL_DAWN)
			return rockhill_existing_sounds(rockhill_music_dawn || rockhill_music)
		if(ROCKHILL_DUSK)
			return rockhill_existing_sounds(rockhill_music_dusk || rockhill_music)
		if(ROCKHILL_NIGHT)
			return rockhill_existing_sounds(rockhill_music_night || rockhill_music)
	return rockhill_existing_sounds(rockhill_music)

/area/rogue/proc/rockhill_loop_now()
	if(!rockhill_loops_enabled)
		return null
	return rockhill_existing_sounds(GLOB.rockhill_time_of_day == ROCKHILL_NIGHT ? rockhill_loop_night : rockhill_loop_day)

/area/rogue/proc/rockhill_refresh_oneshots()
	ambientsounds = rockhill_existing_sounds(GLOB.rockhill_time_of_day == ROCKHILL_NIGHT ? rockhill_oneshot_night : rockhill_oneshot_day)

/area/rogue/Entered(atom/movable/arrived, area/old_area)
	. = ..()
	var/mob/living/visitor = arrived
	if(rockhill_area_text && istype(visitor) && visitor.client && visitor.mind && visitor.stat != DEAD)
		visitor.rockhill_enter_area(src)

/mob/living/proc/rockhill_enter_area(area/rogue/entered)
	to_chat(src, span_info("You enter [entered.name]."))
	if(entered.rockhill_area_text in mind.rockhill_areas_seen)
		return
	LAZYADD(mind.rockhill_areas_seen, entered.rockhill_area_text)
	var/atom/movable/screen/rockhill_area_title/title = new
	title.maptext = MAPTEXT("<span style='vertical-align:top; text-align:center; color: #820000; font-size: 300%; text-shadow: 1px 1px 2px black, 0 0 1em black, 0 0 0.2em black;'>[entered.rockhill_area_text]</span>")
	playsound_local(src, 'modular_redtard/rockhill/sound/misc/area.ogg', 100, FALSE)
	rockhill_flash_screen(title, 1 SECONDS, 3.5 SECONDS)

/datum/mind
	var/list/rockhill_areas_seen

/atom/movable/screen/rockhill_area_title
	icon = null
	screen_loc = "5,5"
	plane = HUD_PLANE
	alpha = 0
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	maptext_width = 205
	maptext_height = 209
	maptext_x = 12
	maptext_y = 64

/client
	var/list/rockhill_area_sounds

/mob/refresh_looping_ambience()
	. = ..()
	rockhill_refresh_area_sounds()

/mob/proc/rockhill_refresh_area_sounds()
	if(!client)
		return
	var/area/rogue/here = get_area(src)
	var/listening = istype(here) && isliving(src) && stat != DEAD && !HAS_TRAIT(src, TRAIT_DEAF)
	client.rockhill_play_area_sound(ROCKHILL_SOUND_MUSIC, listening ? here.rockhill_music_now() : null, client.prefs.read_preference(/datum/preference/numeric/volume/sound_ship_ambience_volume))
	client.rockhill_play_area_sound(ROCKHILL_SOUND_LOOP, listening ? here.rockhill_loop_now() : null, client.prefs.read_preference(/datum/preference/numeric/volume/sound_ambience_volume))

/client/proc/rockhill_play_area_sound(slot, list/options, volume)
	var/list/playing = LAZYACCESS(rockhill_area_sounds, slot)
	var/current = LAZYACCESS(playing, 1)
	var/new_file = (current && (current in options)) ? current : (length(options) ? pick(options) : null)
	if(!volume)
		new_file = null
	if(new_file == current && LAZYACCESS(playing, 2) == volume)
		return
	LAZYSET(rockhill_area_sounds, slot, list(new_file, volume))
	var/channel = rockhill_sound_channel(slot)
	if(!new_file)
		SEND_SOUND(src, sound(null, channel = channel))
		return
	var/sound/loop = sound(new_file, repeat = TRUE, wait = 0, channel = channel, volume = volume)
	if(new_file == current)
		loop.status = SOUND_UPDATE
	SEND_SOUND(src, loop)

/proc/rockhill_refresh_all_area_sounds()
	for(var/area/rogue/area in GLOB.areas)
		area.rockhill_refresh_oneshots()
	for(var/client/listener as anything in GLOB.clients)
		listener.mob?.rockhill_refresh_area_sounds()
