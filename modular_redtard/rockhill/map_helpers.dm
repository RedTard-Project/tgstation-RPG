GLOBAL_LIST_INIT(rockhill_secret_open_words, list("open", "pass", "part", "break", "reveal", "unbar", "gape", "extend", "widen", "unfold", "rise"))
GLOBAL_LIST_INIT(rockhill_secret_magic_words, list("sesame", "abyss", "fire", "wind", "earth", "shadow", "night", "oblivion", "void", "time", "dead", "decay", "gods", "ancient", "twisted", "corrupt", "secrets", "lore", "text", "ritual", "sacrifice", "deal", "pact", "bargain", "dream", "nightmare", "vision", "hunger", "lust", "necra", "noc", "psydon"))

/obj/effect/mapping_helpers/access
	name = "access helper parent"
	icon_state = "airlock_locked_helper"
	layer = DOOR_HELPER_LAYER
	late = TRUE

/obj/effect/mapping_helpers/access/LateInitialize()
	var/static/list/valid = list(/obj/structure/mineral_door, /obj/structure/closet)
	for(var/target_type in valid)
		var/obj/found = locate(target_type) in loc
		if(found)
			payload(found)
			qdel(src)
			return
	log_mapping("[src] failed to find a target at [AREACOORD(src)]")
	qdel(src)

/obj/effect/mapping_helpers/access/proc/payload(obj/target)
	return

/obj/effect/mapping_helpers/access/locker
	name = "access lock helper"

/obj/effect/mapping_helpers/access/locker/payload(obj/target)
	if(istype(target, /obj/structure/mineral_door/rockhill))
		var/obj/structure/mineral_door/rockhill/door = target
		door.locked = TRUE
	else if(istype(target, /obj/structure/closet))
		var/obj/structure/closet/closet = target
		closet.locked = TRUE
		closet.update_appearance()

/obj/effect/mapping_helpers/floor_clothing_equipper
	name = "floor clothes equipper (PLACE ITEMS ON FLOOR)"
	icon_state = "corpsehuman"
	late = TRUE

/obj/effect/mapping_helpers/floor_clothing_equipper/LateInitialize()
	var/mob/living/carbon/human/located = locate(/mob/living/carbon/human) in loc
	if(located)
		for(var/obj/item/clothing/clothing in loc)
			located.equip_to_appropriate_slot(clothing)
		for(var/obj/item/rogueweapon/weapon in loc)
			located.put_in_hands(weapon)
	qdel(src)

/obj/effect/mapping_helpers/secret_door_creator
	name = "Secret door creator: Turns the given wall into a hidden door with a random password."
	icon_state = "trapdoor"
	var/redstone_id
	var/door_type = /obj/structure/mineral_door/rockhill/secret
	var/override_floor = TRUE
	var/floor_turf = /turf/open/floor/rogue/blocks

/obj/effect/mapping_helpers/secret_door_creator/Initialize(mapload)
	var/turf/closed/wall = loc
	if(isclosedturf(wall))
		var/obj/structure/mineral_door/rockhill/secret/door = new door_type(wall)
		door.disguise_as(wall, redstone_id)
		if(override_floor && ispath(floor_turf, /turf/open))
			wall.ChangeTurf(floor_turf)
		else
			wall.ScrapeAway()
	return ..()

/obj/structure/mineral_door/rockhill/secret
	name = "wall"
	desc = "A wall of smooth unyielding stone."
	icon = 'modular_redtard/rockhill/icons/smooth/stone_wall.dmi'
	icon_state = "stone_wall-0"
	layer = ABOVE_MOB_LAYER
	max_integrity = 9999
	damage_deflection = 30
	openSound = null
	closeSound = null
	locked = TRUE
	masterkey = FALSE
	var/redstone_id
	var/open_phrase
	var/hearing_range = ROCKHILL_SECRET_DOOR_RANGE

/obj/structure/mineral_door/rockhill/secret/Initialize(mapload)
	. = ..()
	open_phrase = "[pick(GLOB.rockhill_secret_open_words)] [pick(GLOB.rockhill_secret_magic_words)]"
	become_hearing_sensitive()
	if(redstone_id)
		LAZYADDASSOCLIST(GLOB.rockhill_redstone, redstone_id, src)

/obj/structure/mineral_door/rockhill/secret/Destroy()
	if(redstone_id)
		LAZYREMOVEASSOC(GLOB.rockhill_redstone, redstone_id, src)
	return ..()

/obj/structure/mineral_door/rockhill/secret/proc/disguise_as(turf/closed/wall, new_redstone_id)
	name = wall.name
	desc = wall.desc
	icon = wall.icon
	base_state = wall.icon_state
	base_icon_state = wall.base_icon_state
	if(wall.smoothing_flags & SMOOTH_BITMASK)
		smoothing_flags = wall.smoothing_flags
		smoothing_groups = wall.smoothing_groups
		canSmoothWith = wall.canSmoothWith
		QUEUE_SMOOTH(src)
	if(new_redstone_id && !redstone_id)
		redstone_id = new_redstone_id
		LAZYADDASSOCLIST(GLOB.rockhill_redstone, redstone_id, src)
	update_appearance()

/obj/structure/mineral_door/rockhill/secret/update_icon_state()
	. = ..()
	icon_state = (smoothing_flags & SMOOTH_BITMASK) && !isnull(smoothing_junction) ? "[base_icon_state]-[smoothing_junction]" : base_state

/obj/structure/mineral_door/rockhill/secret/Hear(atom/movable/speaker, message_language, raw_message, radio_freq, radio_freq_name, radio_freq_color, list/spans, list/message_mods = list(), message_range = 0)
	. = ..()
	if(speaker == src || broken || radio_freq || !ishuman(speaker) || get_dist(speaker, src) > hearing_range)
		return
	var/static/list/punctuation = list("," = "", "." = "", "!" = "", "?" = "", ":" = "", ";" = "", "*" = "", "\"" = "", "\n" = "", "\t" = "")
	var/heard = raw_message
	for(var/mark in punctuation)
		heard = replacetext(heard, mark, "")
	if(findtext(heard, open_phrase))
		INVOKE_ASYNC(src, PROC_REF(toggle_secret))

/obj/structure/mineral_door/rockhill/secret/proc/redstone_triggered(mob/user)
	toggle_secret()

/obj/structure/mineral_door/rockhill/secret/proc/toggle_secret()
	if(isSwitchingStates || broken)
		return
	if(door_opened)
		Close()
	else
		Open()

/obj/structure/mineral_door/rockhill/secret/Open()
	isSwitchingStates = TRUE
	set_opacity(FALSE)
	animate(src, pixel_x = base_pixel_x + ROCKHILL_SECRET_DOOR_SHIFT, alpha = ROCKHILL_SECRET_DOOR_OPEN_ALPHA, time = ROCKHILL_SECRET_DOOR_SLIDE)
	sleep(ROCKHILL_SECRET_DOOR_SLIDE)
	set_density(FALSE)
	door_opened = TRUE
	layer = OPEN_DOOR_LAYER
	air_update_turf(TRUE, FALSE)
	isSwitchingStates = FALSE

/obj/structure/mineral_door/rockhill/secret/Close()
	if(isSwitchingStates || !door_opened)
		return
	for(var/mob/living/blocker in loc)
		return
	isSwitchingStates = TRUE
	animate(src, pixel_x = base_pixel_x, alpha = 255, time = ROCKHILL_SECRET_DOOR_SLIDE)
	sleep(ROCKHILL_SECRET_DOOR_SLIDE)
	set_density(TRUE)
	set_opacity(TRUE)
	door_opened = FALSE
	layer = initial(layer)
	air_update_turf(TRUE, TRUE)
	isSwitchingStates = FALSE

/obj/structure/mineral_door/rockhill/secret/attack_hand(mob/living/user, list/modifiers)
	if(door_opened)
		INVOKE_ASYNC(src, PROC_REF(Close))
		return TRUE
	user.changeNext_move(CLICK_CD_MELEE)
	to_chat(user, span_notice("I push the wall, but nothing happens."))
	return TRUE

/obj/structure/mineral_door/rockhill/secret/Bumped(atom/movable/bumper)
	return

/obj/structure/mineral_door/rockhill/secret/secondary_use(mob/user)
	return

/obj/structure/mineral_door/rockhill/secret/kick(mob/living/user)
	return

/obj/effect/waterfall
	name = "waterfall"
	icon = 'modular_redtard/rockhill/icons/effects/waterfall.dmi'
	icon_state = "waterfall_temp"
	pixel_y = 32
	anchored = TRUE
	var/water_color = ROCKHILL_WATER_COLOR

/obj/effect/waterfall/Initialize(mapload)
	. = ..()
	if(istransparentturf(loc))
		return
	color = water_color
	var/obj/effect/abstract/particle_holder/mist = new(src, /particles/mist/waterfall)
	mist.particles.color = water_color
	mist.alpha = ROCKHILL_WATERFALL_MIST_ALPHA

/obj/effect/waterfall/acid
	water_color = ROCKHILL_ACID_COLOR

/particles/mist
	icon = 'modular_redtard/rockhill/icons/effects/particles/smoke.dmi'
	icon_state = list("steam_1" = 1, "steam_2" = 1, "steam_3" = 1)
	count = 500
	spawning = 4
	lifespan = 5 SECONDS
	fade = 1 SECONDS
	fadein = 1 SECONDS
	velocity = generator(GEN_BOX, list(-0.5, -0.25, 0), list(0.5, 0.25, 0), NORMAL_RAND)
	position = generator(GEN_BOX, list(-20, -16), list(20, -2), UNIFORM_RAND)
	friction = 0.2
	grow = 0.0015

/particles/mist/waterfall
	count = 75
	lifespan = generator(GEN_NUM, 2 SECONDS, 3 SECONDS)
	position = generator(GEN_BOX, list(-20, 4), list(20, 10), UNIFORM_RAND)
