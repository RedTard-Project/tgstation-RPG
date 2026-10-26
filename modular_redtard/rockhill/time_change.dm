GLOBAL_VAR_INIT(rockhill_dawns, 0)
GLOBAL_LIST_INIT(rockhill_day_ordinals, list("FIRST", "SECOND", "THIRD", "FOURTH", "FIFTH", "SIXTH", "SEVENTH"))

/datum/mind
	var/rockhill_dawn_seen = 0

/atom/movable/screen/rockhill_dawn_text
	icon = null
	screen_loc = "5,5"
	plane = HUD_PLANE
	alpha = 0
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	maptext_width = 205
	maptext_height = 209
	maptext_x = 12
	maptext_y = -120

/atom/movable/screen/rockhill_daynight
	icon = 'modular_redtard/rockhill/icons/time.dmi'
	screen_loc = "EAST-2:-14,CENTER-6:16"
	alpha = 0
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/mob/living/Login()
	. = ..()
	if(. && GLOB.rockhill_time_of_day)
		rockhill_time_change()

/mob/living/proc/rockhill_time_change()
	if(!client || !mind || !GLOB.rockhill_time_of_day)
		return
	switch(GLOB.rockhill_time_of_day)
		if(ROCKHILL_DAWN)
			rockhill_show_dawn()
		if(ROCKHILL_DAY)
			playsound_local(src, 'modular_redtard/rockhill/sound/misc/midday.ogg', 100, FALSE)
		if(ROCKHILL_NIGHT)
			playsound_local(src, 'modular_redtard/rockhill/sound/misc/nightfall.ogg', 100, FALSE)
	var/atom/movable/screen/rockhill_daynight/sun = new
	sun.icon_state = GLOB.rockhill_time_of_day
	rockhill_flash_screen(sun, 2 SECONDS, 3 SECONDS)

/mob/living/proc/rockhill_show_dawn()
	if(!GLOB.rockhill_days_passed || mind.rockhill_dawn_seen == GLOB.rockhill_dawns)
		return
	mind.rockhill_dawn_seen = GLOB.rockhill_dawns
	var/list/feasts = list()
	for(var/datum/rockhill_calendar_event/event as anything in rockhill_events_today())
		feasts += event.title
	var/atom/movable/screen/rockhill_dawn_text/splash = new
	splash.maptext = MAPTEXT("<span style='vertical-align:top; text-align:center; color: #7c5b10; font-size: 150%; text-shadow: 1px 1px 2px black, 0 0 1em black, 0 0 0.2em black;'>DAWN OF THE [GLOB.rockhill_day_ordinals[GLOB.rockhill_days_passed]] DAE<br>[rockhill_day_name()]<br>[uppertext(rockhill_date_short())][length(feasts) ? "<br>- [uppertext(jointext(feasts, " & "))] -" : ""]</span>")
	playsound_local(src, 'modular_redtard/rockhill/sound/misc/newday.ogg', 60, FALSE)
	rockhill_flash_screen(splash, 1 SECONDS, 3.5 SECONDS)
	if(length(GLOB.rockhill_time_tips))
		to_chat(src, span_notice("<b>[pick(GLOB.rockhill_time_tips)]</b>"))

/mob/living/proc/rockhill_flash_screen(atom/movable/screen/shown, fade_in, shown_for)
	client.screen += shown
	animate(shown, alpha = 255, time = fade_in, easing = EASE_IN)
	addtimer(CALLBACK(src, PROC_REF(rockhill_fade_screen), shown, client), shown_for)

/mob/living/proc/rockhill_fade_screen(atom/movable/screen/shown, client/viewer)
	animate(shown, alpha = 0, time = 1 SECONDS, easing = EASE_OUT)
	addtimer(CALLBACK(src, PROC_REF(rockhill_drop_screen), shown, viewer), 1 SECONDS)

/mob/living/proc/rockhill_drop_screen(atom/movable/screen/shown, client/viewer)
	if(viewer)
		viewer.screen -= shown
	qdel(shown)
