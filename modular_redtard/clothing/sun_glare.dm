/// Sun glare (Ratwood species.dm handle_environment(), debuff.dm sun_blinded): eyes made for the dark (TRAIT_LIGHT_SENSITIVITY) under
/// the open sky by day sour the mood, and unless a hood or a helmet that closes the back (block2add) shades them, they are blinded:
/// a dusty haze over the screen, less perception and a view closed on both sides (combat/fov.dm). Time of day and the sky are
/// Rockhill's (rockhill/daynight.dm, the sunlit subareas of rockhill/sunlight.dm). Unlike Ratwood, clouds (rain, snow, fog, a
/// thunderstorm; rockhill/weather.dm) hide the sun.
GLOBAL_LIST_INIT(rogue_sun_hiding_weathers, typecacheof(list(
	/datum/weather/particle/rockhill/rain_gentle,
	/datum/weather/particle/rockhill/rain_storm,
	/datum/weather/particle/rockhill/snow_gentle,
	/datum/weather/particle/rockhill/snow_storm,
	/datum/weather/particle/rockhill/fog,
	/datum/weather/particle/rockhill/dry_thunderstorm,
)))

/// Under the open sky in daylight with no clouds (Ratwood GLOB.tod == "day" on an outdoor turf).
/mob/living/carbon/human/proc/rogue_under_sun()
	if(GLOB.rockhill_time_of_day != ROCKHILL_DAY)
		return FALSE
	var/area/rogue/here = get_area(src)
	if(!istype(here) || !here.rockhill_sunlit)
		return FALSE
	var/datum/weather/sky = SSrockhill_weather.active_weather()
	return !is_type_in_typecache(sky, GLOB.rogue_sun_hiding_weathers)

/// The headgear shades the eyes: it closes the back of the view (Ratwood head.block2add & FOV_BEHIND).
/mob/living/carbon/human/proc/rogue_eyes_shaded()
	var/obj/item/clothing/hat = head
	return istype(hat) && (hat.block2add & ROGUE_FOV_BEHIND)

/// The sun is in light-sensitive eyes right now.
/mob/living/carbon/human/proc/rogue_sun_glares()
	return stat != DEAD && HAS_TRAIT(src, TRAIT_LIGHT_SENSITIVITY) && rogue_under_sun() && !rogue_eyes_shaded()

/// Ratwood checks the sky every life tick in the species' handle_environment(); the glare then ends by itself (its tick).
/mob/living/carbon/human/handle_environment(datum/gas_mixture/environment, seconds_per_tick)
	. = ..()
	if(!HAS_TRAIT(src, TRAIT_LIGHT_SENSITIVITY) || stat == DEAD || !rogue_under_sun())
		return
	add_mood_event("rogue_sunlit", /datum/mood_event/rogue_sunlit)
	if(!rogue_eyes_shaded())
		apply_status_effect(/datum/status_effect/rogue/sun_blinded)

/datum/status_effect/rogue/sun_blinded
	id = "rogue_sun_blinded"
	alert_type = /atom/movable/screen/alert/status_effect/rogue/sun_blinded
	tick_interval = ROGUE_SUN_GLARE_TICK

/// The trait goes on first: the effect joins the owner's list only after on_apply(), and the view is recounted here.
/datum/status_effect/rogue/sun_blinded/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_ROGUE_SUN_BLINDED, id)
	owner.overlay_fullscreen(id, /atom/movable/screen/fullscreen/rogue_sun_glare)
	owner.attributes?.set_variable_attribute_modifier(id, list(ROGUE_STAT_PERCEPTION = -ROGUE_SUN_BLIND_PERCEPTION))
	rogue_refresh_view()

/datum/status_effect/rogue/sun_blinded/on_remove()
	REMOVE_TRAIT(owner, TRAIT_ROGUE_SUN_BLINDED, id)
	owner.clear_fullscreen(id)
	owner.attributes?.remove_attribute_modifier(id)
	rogue_refresh_view()
	return ..()

/datum/status_effect/rogue/sun_blinded/tick(seconds_between_ticks)
	var/mob/living/carbon/human/eyes = owner
	if(!istype(eyes) || !eyes.rogue_sun_glares())
		qdel(src)

/datum/status_effect/rogue/sun_blinded/proc/rogue_refresh_view()
	var/mob/living/carbon/human/eyes = owner
	if(istype(eyes) && rogue_combat_enabled())
		eyes.rogue_update_fov()

/atom/movable/screen/alert/status_effect/rogue/sun_blinded
	name = "Sun Blinded"
	desc = "The light smites my eyes!"
	icon_state = "debuff"

/// Ratwood dustoverlay_light: a sunlit haze of dust over the whole view.
/atom/movable/screen/fullscreen/rogue_sun_glare
	icon = ROGUE_SUN_GLARE_ICON
	icon_state = "smok"
	layer = CRIT_LAYER
	color = "#C3b091"
	alpha = 90

/datum/mood_event/rogue_sunlit
	description = "IT'S TOO BRIGHT!"
	mood_change = ROGUE_SUNLIT_MOOD
	timeout = ROGUE_SUNLIT_MOOD_TIME
