/// The portable bombard by Ratwood (rogueweapons/stationary/: bombard.dm, bombard_objects.dm, bombard_projectiles.dm,
/// _bombard_helpers.dm). Azure Peak has no bombards. The bombard is crafted from its frame and barrel (the ported recipe)
/// and works like this:
/// - only outdoors; only a Fusilier (TRAIT_FUSILIER) can aim it or read its dials, anyone can fill, ram and pack it up;
/// - the palantir finds the "leyline intersection point" of a spot in sight: its coordinates shifted by a secret offset of
///   the round, so only a palantir gives them; the Fusilier sets the bombard's X-LIP, Y-LIP and level to them and may dial
///   up to bombard_dial_max tiles off; the farther the target, the more the shell may stray (a tile per
///   bombard_offset_per_tiles); the target must be under the open sky, at least bombard_min_range and at most
///   bombard_max_range away;
/// - smokepowder from a flask, then the powder ram (bombard_sponge), then a charge: the bombard fires, the shell whistles
///   overhead and lands; every shot needs powder and ramming again and the dials are cleared;
/// - the charges: HE blows up a wide area; FLR flashes and blinds all around; INC (lit first with a flame, which must be quick
///   or it goes off in hand) sets a wide area alight, unlit only a little; SMK lays smoke; FLK bursts into shrapnel above,
///   then blasts; SOL does nothing but land.
/// The heavy bombard, the poison, emberwine, custom and cluster charges were not brought by the porter.
#define ROGUE_BOMBARD_SOUND_FIRE 'modular_redtard/combat/sound/bombard/mortar_fire.ogg'
#define ROGUE_BOMBARD_SOUND_WHISTLE 'modular_redtard/combat/sound/bombard/mortar_long_whistle.ogg'
#define ROGUE_BOMBARD_SOUND_RELOAD 'modular_redtard/combat/sound/bombard/mortar_reload.ogg'
#define ROGUE_BOMBARD_SOUND_DIAL 'modular_redtard/rockhill/sound/combat/shieldraise.ogg'
#define ROGUE_BOMBARD_SOUND_POUR 'modular_redtard/combat/sound/firearms/pour_powder.ogg'
#define ROGUE_BOMBARD_SOUND_RAM 'modular_redtard/combat/sound/firearms/ramrod.ogg'
#define ROGUE_BOMBARD_SOUND_LIT 'modular_redtard/rockhill/sound/items/firelight.ogg'
#define ROGUE_BOMBARD_SOUND_SNUFF 'modular_redtard/rockhill/sound/items/firesnuff.ogg'
/// Ratwood GLOB.obfs_x/obfs_y: the secret shift of the leyline coordinates, a number between -2500 and 2500.
#define ROGUE_BOMBARD_OBFUSCATION 2500

GLOBAL_VAR_INIT(rogue_bombard_shift_x, rand(-ROGUE_BOMBARD_OBFUSCATION, ROGUE_BOMBARD_OBFUSCATION))
GLOBAL_VAR_INIT(rogue_bombard_shift_y, rand(-ROGUE_BOMBARD_OBFUSCATION, ROGUE_BOMBARD_OBFUSCATION))

/// Ratwood loud_message(): a line to everyone on the level within the distance.
/proc/rogue_loud_message(turf/origin, message, distance)
	if(!origin)
		return
	for(var/mob/listener as anything in GLOB.player_list)
		var/turf/where = get_turf(listener)
		if(where && where.z == origin.z && get_dist(where, origin) <= distance)
			to_chat(listener, span_warning("[message]."))

/// The palantir (Ratwood /obj/item/rogueweapon/palantir): a Fusilier finds the leyline point of a spot in sight.
/obj/item/rogueweapon/palantir
	name = "palantir"
	desc = "An arcyne compass, runed and imbued with energy. That is, of course, to say that this is able to detect leyline intersection points. Or LIPs, for short. An incredibly expensive device, likely pried from one of the Queen's own magicians."
	icon = 'modular_redtard/rockhill/icons/roguetown/weapons/stationary/bombard.dmi'
	icon_state = "compass"
	slot_flags = ITEM_SLOT_BELT
	worn_icon = 'modular_redtard/rockhill/icons/blank_worn.dmi'
	worn_icon_state = null
	w_class = WEIGHT_CLASS_SMALL
	var/last_x = "UNKNOWN"
	var/last_y = "UNKNOWN"
	var/last_z = "UNKNOWN"
	var/busy = FALSE

/obj/item/rogueweapon/palantir/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_FUSILIER))
		. += span_notice("Last X-LIP recorded: [last_x]. Last Y-LIP recorded: [last_y]. Last Z-LIP recorded: [last_z].")
	else
		. += span_info("As expected, you've no understanding of the smaller details. Someone trained with smokepowder might know...")

/obj/item/rogueweapon/palantir/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	return interact_with_atom(interacting_with, user, modifiers)

/obj/item/rogueweapon/palantir/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!HAS_TRAIT(user, TRAIT_FUSILIER))
		to_chat(user, span_warning("This device is beyond my understanding..."))
		return ITEM_INTERACT_BLOCKING
	var/turf/spot = get_turf(interacting_with)
	if(!spot || busy)
		return ITEM_INTERACT_BLOCKING
	INVOKE_ASYNC(src, PROC_REF(measure), user, spot)
	return ITEM_INTERACT_SUCCESS

/obj/item/rogueweapon/palantir/proc/measure(mob/living/user, turf/spot)
	busy = TRUE
	to_chat(user, span_notice("Calculating leyline intersection point. Stand still."))
	rogue_loud_message(get_turf(user), "A palantir's loud whine can be heard", rogue_value("bombard_palantir_hearing"))
	var/done = do_after(user, rogue_value("bombard_palantir_time"), target = src)
	busy = FALSE
	if(!done)
		to_chat(user, span_warning("I must remain still!"))
		return
	last_x = spot.x + GLOB.rogue_bombard_shift_x
	last_y = spot.y + GLOB.rogue_bombard_shift_y
	last_z = spot.z
	to_chat(user, span_notice("INTERSECTION POINT OF TARGET: X-LIP [last_x], Y-LIP [last_y], Z-LIP [last_z]."))

/obj/structure/bombard
	anchored = TRUE
	var/xinput = 0
	var/yinput = 0
	var/xdial = 0
	var/ydial = 0
	var/zdial = 0
	var/xoffset = 0
	var/yoffset = 0
	var/firing = FALSE
	var/busy = FALSE
	var/powder = FALSE
	var/rammed = FALSE

/obj/structure/bombard/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_FUSILIER))
		. += span_notice("X-LIP dial: [xinput ? xinput + GLOB.rogue_bombard_shift_x : 0]. Y-LIP dial: [yinput ? yinput + GLOB.rogue_bombard_shift_y : 0]. Adjustment: [xdial], [ydial]. Elevation: [zdial].")
	else
		. += span_info("As expected, you've no understanding of the smaller details. Someone trained with smokepowder might know...")
	. += span_info("It is [powder ? "filled with smokepowder" : "empty of powder"][rammed ? " and rammed" : ""].")
	. += span_info("It can be packed up into its frame and barrel.")

/obj/structure/bombard/proc/outdoors(mob/user)
	var/area/here = get_area(src)
	if(here?.outdoors)
		return TRUE
	to_chat(user, span_warning("I refrain from using [src] while indoors."))
	return FALSE

/obj/structure/bombard/proc/clear_aim()
	xinput = 0
	yinput = 0
	xdial = 0
	ydial = 0
	zdial = 0
	xoffset = 0
	yoffset = 0

/obj/structure/bombard/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(busy)
		to_chat(user, span_warning("Someone else is currently using [src]."))
		return TRUE
	if(firing)
		to_chat(user, span_warning("[src]'s barrel is still steaming hot. Wait a few seconds."))
		return TRUE
	INVOKE_ASYNC(src, PROC_REF(operate), user)
	return TRUE

/// Ratwood attack_hand() and MiddleClick(): a Fusilier sets the target or the dials or clears them; anyone may pack it up.
/obj/structure/bombard/proc/operate(mob/living/user)
	var/list/choices = list("Pack up", "Cancel")
	if(HAS_TRAIT(user, TRAIT_FUSILIER))
		choices = list("Target", "Dial", "Clear target", "Pack up", "Cancel")
	var/choice = tgui_alert(user, "What will I do with [src]?", name, choices)
	if(QDELETED(src) || !user.Adjacent(src) || busy || firing)
		return
	switch(choice)
		if("Target")
			if(outdoors(user))
				set_target(user)
		if("Dial")
			if(outdoors(user))
				set_dial(user)
		if("Clear target")
			clear_aim()
			to_chat(user, span_notice("I clear [src]'s dials."))
		if("Pack up")
			pack_up(user)

/// Sets the target from a palantir's reading (Ratwood "Target").
/obj/structure/bombard/proc/set_target(mob/living/user)
	var/lip_x = tgui_input_number(user, "Set X-LIP of strike.", name, 0, ROGUE_BOMBARD_OBFUSCATION * 2 + world.maxx, -ROGUE_BOMBARD_OBFUSCATION * 2)
	if(isnull(lip_x))
		return
	var/lip_y = tgui_input_number(user, "Set Y-LIP of strike.", name, 0, ROGUE_BOMBARD_OBFUSCATION * 2 + world.maxy, -ROGUE_BOMBARD_OBFUSCATION * 2)
	if(isnull(lip_y))
		return
	var/lip_z = tgui_input_number(user, "Set Z-LIP elevation of strike.", name, z, world.maxz, 1)
	if(isnull(lip_z) || QDELETED(src) || busy || !user.Adjacent(src))
		return
	var/target_x = lip_x - GLOB.rogue_bombard_shift_x
	var/target_y = lip_y - GLOB.rogue_bombard_shift_y
	var/turf/target = locate(target_x + xdial, target_y + ydial, lip_z)
	if(!check_target(user, target))
		return
	user.visible_message(span_notice("[user] starts adjusting [src]'s firing angle and distance."), span_notice("I start adjusting [src]'s firing angle and distance to match the new target's location."))
	busy = TRUE
	var/done = do_after(user, rogue_value("bombard_aim_time"), target = src)
	busy = FALSE
	if(!done || QDELETED(src))
		return
	playsound(src, ROGUE_BOMBARD_SOUND_DIAL, 25, TRUE)
	xinput = target_x
	yinput = target_y
	zdial = lip_z
	var/per_tiles = max(rogue_value("bombard_offset_per_tiles"), 1)
	var/stray_x = round(abs((xinput + xdial) - x) / per_tiles)
	var/stray_y = round(abs((yinput + ydial) - y) / per_tiles)
	xoffset = rand(-stray_x, stray_x)
	yoffset = rand(-stray_y, stray_y)
	user.visible_message(span_notice("[user] finishes adjusting [src]'s firing angle and distance."), span_notice("I finish adjusting [src]."))

/// Dials the shot a few tiles off the target (Ratwood "Dial").
/obj/structure/bombard/proc/set_dial(mob/living/user)
	if(!zdial)
		to_chat(user, span_warning("I've not set the target of [src] yet!"))
		return
	var/most = rogue_value("bombard_dial_max")
	var/dial_x = tgui_input_number(user, "Set X-LIP adjustment from -[most] to [most].", name, xdial, most, -most)
	if(isnull(dial_x))
		return
	var/dial_y = tgui_input_number(user, "Set Y-LIP adjustment from -[most] to [most].", name, ydial, most, -most)
	if(isnull(dial_y) || QDELETED(src) || busy || !user.Adjacent(src))
		return
	if(!check_target(user, locate(xinput + dial_x, yinput + dial_y, zdial)))
		return
	user.visible_message(span_notice("[user] starts dialing [src]'s firing angle and distance."), span_notice("I start dialing [src]."))
	busy = TRUE
	var/done = do_after(user, rogue_value("bombard_dial_time"), target = src)
	busy = FALSE
	if(!done || QDELETED(src))
		return
	xdial = dial_x
	ydial = dial_y
	user.visible_message(span_notice("[user] finishes dialing [src]."), span_notice("I finish dialing [src]."))

/// The target is on the map, on this map's levels, under the open sky and within reach (Ratwood's checks).
/obj/structure/bombard/proc/check_target(mob/living/user, turf/target)
	if(!isturf(target) || !is_valid_z_level(get_turf(src), target))
		to_chat(user, span_warning("I cannot aim at this target, it is outside of my reach."))
		return FALSE
	var/distance = get_dist(src, target)
	if(distance < rogue_value("bombard_min_range"))
		to_chat(user, span_warning("I cannot aim at this target, it is too close to [src]."))
		return FALSE
	if(distance > rogue_value("bombard_max_range"))
		to_chat(user, span_warning("This target is too far away for a light bombard!"))
		return FALSE
	var/area/target_area = get_area(target)
	if(!target_area?.outdoors)
		to_chat(user, span_warning("This location has a ceiling! I cannot aim directly at it! Adjust!"))
		return FALSE
	return TRUE

/obj/structure/bombard/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	var/is_powder = istype(tool, /obj/item/powderflask)
	var/is_ram = istype(tool, /obj/item/rogueweapon/woodstaff/quarterstaff/bombard_sponge)
	var/is_charge = istype(tool, /obj/item/cannonball)
	if(!is_powder && !is_ram && !is_charge)
		return ..()
	if(!outdoors(user))
		return ITEM_INTERACT_BLOCKING
	if(busy)
		to_chat(user, span_warning("Someone else is currently using [src]."))
		return ITEM_INTERACT_BLOCKING
	if(is_powder)
		INVOKE_ASYNC(src, PROC_REF(fill), user)
		return ITEM_INTERACT_SUCCESS
	if(!powder)
		to_chat(user, span_danger("[src] is not filled with smokepowder!"))
		return ITEM_INTERACT_BLOCKING
	if(is_ram)
		INVOKE_ASYNC(src, PROC_REF(ram), user)
		return ITEM_INTERACT_SUCCESS
	if(!rammed)
		to_chat(user, span_danger("[src] has not yet been packed properly with a ram!"))
		return ITEM_INTERACT_BLOCKING
	if(firing)
		to_chat(user, span_warning("[src]'s barrel is still steaming hot."))
		return ITEM_INTERACT_BLOCKING
	if(!xinput && !yinput)
		to_chat(user, span_warning("[src] needs to be aimed first."))
		return ITEM_INTERACT_BLOCKING
	INVOKE_ASYNC(src, PROC_REF(load_and_fire), user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/structure/bombard/proc/fill(mob/living/user)
	if(powder)
		to_chat(user, span_notice("[src] is already filled with smokepowder!"))
		return
	user.visible_message(span_notice("[user] begins filling [src] with smokepowder."))
	playsound(src, ROGUE_BOMBARD_SOUND_POUR, 80, TRUE)
	busy = TRUE
	var/done = do_after(user, rogue_value("bombard_powder_time"), target = src)
	busy = FALSE
	if(done && !QDELETED(src))
		powder = TRUE
		user.visible_message(span_notice("[user] fills [src] with smokepowder."))

/obj/structure/bombard/proc/ram(mob/living/user)
	if(rammed)
		to_chat(user, span_notice("[src] is already packed properly with smokepowder!"))
		return
	user.visible_message(span_notice("[user] begins packing [src] with smokepowder."))
	playsound(src, ROGUE_BOMBARD_SOUND_RAM, 80, TRUE)
	busy = TRUE
	var/done = do_after(user, rogue_value("bombard_ram_time"), target = src)
	busy = FALSE
	if(done && !QDELETED(src) && powder)
		rammed = TRUE
		user.visible_message(span_notice("[user] has finished packing [src] with smokepowder."))

/// Loads the charge, and the bombard fires at its target (Ratwood attackby() with a cannonball).
/obj/structure/bombard/proc/load_and_fire(mob/living/user, obj/item/cannonball/charge)
	var/turf/target = locate(xinput + xdial + xoffset, yinput + ydial + yoffset, zdial)
	if(!isturf(target))
		to_chat(user, span_warning("I cannot fire [src] at this location."))
		return
	user.visible_message(span_notice("[user] starts loading \a [charge] into [src]."), span_notice("I start loading \a [charge] into [src]."))
	playsound(src, ROGUE_BOMBARD_SOUND_RELOAD, 50, TRUE)
	busy = TRUE
	var/done = do_after(user, rogue_value("bombard_load_time"), target = src)
	busy = FALSE
	if(!done || QDELETED(src) || QDELETED(charge) || firing || !rammed || !user.is_holding(charge))
		return
	if(!user.transferItemToLoc(charge, src))
		return
	user.visible_message(span_notice("[user] loads \a [charge] into [src]."), span_notice("I load \a [charge] into [src]."))
	visible_message(span_danger("[src] fires!"))
	playsound(src, ROGUE_BOMBARD_SOUND_FIRE, 50, TRUE, rogue_value("bombard_fire_hearing"))
	rogue_loud_message(get_turf(src), "The sound of a cannon firing can be heard", rogue_value("bombard_fire_hearing"))
	for(var/mob/living/witness in range(rogue_value("bombard_shake_range"), src))
		shake_camera(witness, 3, 1)
	firing = TRUE
	var/message = "[key_name(user)] fired a bombard ([charge]) at [AREACOORD(target)]."
	message_admins(message)
	log_game(message)
	clear_aim()
	powder = FALSE
	rammed = FALSE
	addtimer(CALLBACK(src, PROC_REF(shell_apex), charge, target), rogue_value("bombard_travel_time"))

/// The shell whistles overhead (Ratwood shell_apex()).
/obj/structure/bombard/proc/shell_apex(obj/item/cannonball/charge, turf/target)
	if(QDELETED(charge))
		firing = FALSE
		return
	playsound(target, ROGUE_BOMBARD_SOUND_WHISTLE, 80, TRUE)
	rogue_loud_message(target, "The whistle of a bombard shell can be heard above", rogue_value("bombard_whistle_hearing"))
	addtimer(CALLBACK(src, PROC_REF(shell_impact), charge, target), rogue_value("bombard_fall_time"))

/obj/structure/bombard/proc/shell_impact(obj/item/cannonball/charge, turf/target)
	firing = FALSE
	if(QDELETED(charge))
		return
	charge.rogue_detonate(target)
	qdel(charge)

/obj/structure/bombard/proc/pack_up(mob/living/user)
	clear_aim()
	powder = FALSE
	rammed = FALSE
	playsound(src, ROGUE_BOMBARD_SOUND_DIAL, 25, TRUE)
	user.visible_message(span_notice("[user] starts to tear down [src]."), span_notice("I start tearing down [src]."))
	busy = TRUE
	var/done = do_after(user, rogue_value("bombard_pack_time"), target = src)
	busy = FALSE
	if(!done || QDELETED(src) || firing)
		return
	user.visible_message(span_notice("[user] tears down [src]."), span_notice("I tear down [src]."))
	playsound(src, ROGUE_BOMBARD_SOUND_DIAL, 25, TRUE)
	var/turf/spot = get_turf(src)
	new /obj/item/bombard_frame(spot)
	new /obj/item/bombard_barrel(spot)
	qdel(src)

/obj/structure/bombard/ex_act(severity, target)
	return FALSE

// Charges (Ratwood bombard_projectiles.dm).

/// The shell lands: a solid shot only lands (Ratwood detonate()).
/obj/item/cannonball/proc/rogue_detonate(turf/target)
	rogue_loud_message(target, "An explosion echoes in the ears of those who hear it", rogue_value("bombard_impact_hearing"))
	forceMove(target)

/obj/item/cannonball/explosive/rogue_detonate(turf/target)
	..()
	explosion(target, devastation_range = rogue_value("bombard_he_devastation_range"), heavy_impact_range = rogue_value("bombard_he_heavy_range"), light_impact_range = rogue_value("bombard_he_light_range"), flame_range = rogue_value("bombard_he_flame_range"), explosion_cause = src)

/// Flashes and blinds everyone around (Ratwood flare).
/obj/item/cannonball/flare/rogue_detonate(turf/target)
	..()
	for(var/mob/living/carbon/human/witness in range(rogue_value("bombard_flare_range"), target))
		witness.flash_act()
		witness.adjust_temp_blindness(rogue_value("bombard_flare_blind_time"))
	explosion(target, flash_range = rogue_value("bombard_flare_flash_range"), explosion_cause = src)

/obj/item/cannonball/smoke/rogue_detonate(turf/target)
	..()
	do_smoke(rogue_value("bombard_smoke_range"), null, target)
	explosion(target, flash_range = rogue_value("bombard_smoke_flash_range"), explosion_cause = src)

/// Bursts into shrapnel above, then blasts a moment later (Ratwood canister).
/obj/item/cannonball/canister/rogue_detonate(turf/target)
	..()
	var/shards = rogue_value("bombard_canister_shards")
	for(var/i in 1 to shards)
		var/obj/projectile/bullet/rogue_canister_shrap/shard = new(target)
		shard.fire(i * 360 / shards + rand(-5, 5))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(explosion), target, 0, 0, rogue_value("bombard_canister_light_range"), null, rogue_value("bombard_canister_flash_range")), rogue_value("bombard_canister_delay"))

/obj/projectile/bullet/rogue_canister_shrap
	name = "canister shrapnel"
	sharpness = SHARP_POINTY
	pass_flags = PASSTABLE | PASSGRILLE
	wound_bonus = 0
	hitsound = 'modular_redtard/rockhill/sound/combat/hits/hi_arrow2.ogg'

/obj/projectile/bullet/rogue_canister_shrap/Initialize(mapload)
	damage = rogue_value("bombard_canister_damage")
	range = rogue_value("bombard_canister_shard_range")
	armour_penetration = ROGUE_PEN_MEDIUM
	return ..()

/// The incendiary charge must be lit before it is fired; lit, it burns down and goes off where it is (Ratwood incendiary).
/obj/item/cannonball/incendiary
	var/rogue_primed = FALSE
	var/rogue_fuse_timer

/obj/item/cannonball/incendiary/Destroy()
	if(rogue_fuse_timer)
		deltimer(rogue_fuse_timer)
		rogue_fuse_timer = null
	return ..()

/obj/item/cannonball/incendiary/examine(mob/user)
	. = ..()
	if(rogue_primed)
		. += span_danger("It is lit! Fire it, quick!")

/obj/item/cannonball/incendiary/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!rogue_primed && tool.get_temperature())
		rogue_light()
		return ITEM_INTERACT_SUCCESS
	return ..()

/obj/item/cannonball/incendiary/fire_act(exposed_temperature, exposed_volume)
	rogue_light()
	return ..()

/obj/item/cannonball/incendiary/spark_act()
	rogue_light()

/obj/item/cannonball/incendiary/extinguish()
	. = ..()
	if(!rogue_primed)
		return
	rogue_primed = FALSE
	if(rogue_fuse_timer)
		deltimer(rogue_fuse_timer)
		rogue_fuse_timer = null
	playsound(src, ROGUE_BOMBARD_SOUND_SNUFF, 100)
	icon_state = initial(icon_state)
	update_inhand_icon()

/obj/item/cannonball/incendiary/proc/rogue_light()
	if(rogue_primed)
		return
	rogue_primed = TRUE
	icon_state = "[initial(icon_state)]_active"
	update_inhand_icon()
	playsound(src, ROGUE_BOMBARD_SOUND_LIT, 100)
	rogue_fuse_timer = addtimer(CALLBACK(src, PROC_REF(rogue_burn_out)), rogue_value("bombard_incendiary_fuse"), TIMER_STOPPABLE)

/// Burnt down before it was fired: it goes off where it is.
/obj/item/cannonball/incendiary/proc/rogue_burn_out()
	rogue_fuse_timer = null
	if(istype(loc, /obj/structure/bombard))
		return
	var/turf/spot = get_turf(src)
	if(spot)
		rogue_detonate(spot)
	qdel(src)

/obj/item/cannonball/incendiary/rogue_detonate(turf/target)
	if(rogue_fuse_timer)
		deltimer(rogue_fuse_timer)
		rogue_fuse_timer = null
	..()
	var/flames = rogue_primed ? rogue_value("bombard_incendiary_flame_range") : rogue_value("bombard_incendiary_cold_flame_range")
	explosion(target, light_impact_range = rogue_value("bombard_incendiary_light_range"), flame_range = flames, explosion_cause = src)

#undef ROGUE_BOMBARD_SOUND_FIRE
#undef ROGUE_BOMBARD_SOUND_WHISTLE
#undef ROGUE_BOMBARD_SOUND_RELOAD
#undef ROGUE_BOMBARD_SOUND_DIAL
#undef ROGUE_BOMBARD_SOUND_POUR
#undef ROGUE_BOMBARD_SOUND_RAM
#undef ROGUE_BOMBARD_SOUND_LIT
#undef ROGUE_BOMBARD_SOUND_SNUFF
#undef ROGUE_BOMBARD_OBFUSCATION
