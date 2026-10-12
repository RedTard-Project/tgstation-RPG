/mob/living/carbon/human
	var/received_resident_key = FALSE

/obj/structure/mineral_door/rockhill
	name = "door"
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/doors.dmi'
	icon_state = "woodhandle"
	max_integrity = 1000
	integrity_failure = 0.5
	sheetType = /obj/item/stack/sheet/mineral/wood
	sheetAmount = 5
	openSound = 'modular_redtard/rockhill/sound/doors/creak.ogg'
	closeSound = 'modular_redtard/rockhill/sound/doors/shut.ogg'
	var/locksound = 'modular_redtard/rockhill/sound/doors/woodlock.ogg'
	var/unlocksound = 'modular_redtard/rockhill/sound/doors/woodlock.ogg'
	var/rattlesound = 'modular_redtard/rockhill/sound/doors/lockrattle.ogg'
	var/base_state
	var/over_state
	var/windowed = FALSE
	var/keylock = FALSE
	var/locked = FALSE
	var/lockid
	var/lockdifficulty = 1
	var/lock_strength = 100
	var/masterkey = TRUE
	var/swing_closed = TRUE
	var/kickthresh = 15
	var/repairable = FALSE
	var/repair_cost_first
	var/repair_cost_second
	var/repair_state = 0
	var/grant_resident_key = FALSE
	var/resident_key_amount = 1
	var/resident_key_type = /obj/item/roguekey
	var/resident_role
	var/list/resident_advclass
	var/relock = FALSE
	var/last_bump = 0

/obj/structure/mineral_door/rockhill/Initialize(mapload)
	. = ..()
	if(!base_state)
		base_state = icon_state
	if(grant_resident_key && !lockid)
		lockid = "resident_[REF(src)]"
	if(over_state)
		add_overlay(mutable_appearance(icon, over_state, ABOVE_MOB_LAYER))
	if(door_opened)
		set_density(FALSE)
		set_opacity(FALSE)
		layer = OPEN_DOOR_LAYER
	else
		set_opacity(closed_opacity())
	update_appearance()

/obj/structure/mineral_door/rockhill/update_icon_state()
	. = ..()
	icon_state = broken ? "[base_state]br" : "[base_state][door_opened ? "open" : ""]"

/obj/structure/mineral_door/rockhill/examine(mob/user)
	. = ..()
	if(repairable && repair_cost_first && (broken || atom_integrity < max_integrity))
		var/obj/item/material = (broken && repair_state) ? repair_cost_second : repair_cost_first
		. += span_notice("[initial(material.name)] can be used to repair it.")

/obj/structure/mineral_door/rockhill/proc/closed_opacity()
	return !windowed

/obj/structure/mineral_door/rockhill/Open()
	isSwitchingStates = TRUE
	playsound(src, openSound, 100, TRUE)
	set_opacity(FALSE)
	flick("[base_state]opening", src)
	sleep(0.2 SECONDS)
	set_density(FALSE)
	door_opened = TRUE
	layer = OPEN_DOOR_LAYER
	air_update_turf(TRUE, FALSE)
	update_appearance()
	isSwitchingStates = FALSE
	if(close_delay != -1)
		addtimer(CALLBACK(src, PROC_REF(Close)), close_delay)

/obj/structure/mineral_door/rockhill/Close()
	if(isSwitchingStates || !door_opened)
		return
	for(var/mob/living/blocker in get_turf(src))
		return
	isSwitchingStates = TRUE
	playsound(src, closeSound, 100, TRUE)
	flick("[base_state]closing", src)
	sleep(0.2 SECONDS)
	set_density(TRUE)
	set_opacity(closed_opacity())
	door_opened = FALSE
	layer = initial(layer)
	air_update_turf(TRUE, TRUE)
	update_appearance()
	isSwitchingStates = FALSE
	if(relock)
		relock = FALSE
		locked = TRUE
		playsound(src, locksound, 100)

/obj/structure/mineral_door/rockhill/Bumped(atom/movable/bumper)
	if(door_opened || broken || !ismob(bumper) || world.time < last_bump + 2 SECONDS)
		return
	last_bump = world.time
	var/mob/user = bumper
	if(HAS_TRAIT(user, TRAIT_BASHDOORS))
		if(locked)
			user.visible_message(span_warning("[user] bashes into [src]!"))
			take_damage(200, BRUTE, MELEE)
		else
			user.visible_message(span_warning("[user] smashes through [src]!"))
			INVOKE_ASYNC(src, PROC_REF(Open))
		return
	if(locked)
		var/obj/item/held = user.get_active_held_item()
		if(!held || !rockhill_key_fits(held, lockid, masterkey))
			rattle()
			return
		toggle_lock(user)
		relock = TRUE
	. = ..()
	if(swing_closed && door_opened)
		addtimer(CALLBACK(src, PROC_REF(Close)), 2.5 SECONDS)

/obj/structure/mineral_door/rockhill/attack_hand(mob/living/user, list/modifiers)
	if(broken || isSwitchingStates)
		return TRUE
	if(can_claim(user))
		INVOKE_ASYNC(src, PROC_REF(claim_home), user)
		return TRUE
	if(locked)
		if(isliving(user) && user.move_intent == MOVE_INTENT_WALK)
			to_chat(user, span_warning("This door is locked."))
		else
			knock(user)
		return TRUE
	return ..()

/obj/structure/mineral_door/rockhill/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(isliving(user))
		var/mob/living/living_user = user
		if(living_user.combat_mode)
			kick(living_user)
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	secondary_use(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/mineral_door/rockhill/proc/secondary_use(mob/user)
	var/obj/item/key = rockhill_find_key(user, lockid, masterkey)
	if(key)
		use_key(user, key)
	else if(keylock)
		to_chat(user, span_warning("I don't have the right key for this door."))

/obj/structure/mineral_door/rockhill/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/roguekey) || istype(tool, /obj/item/storage/keyring))
		use_key(user, tool)
		return ITEM_INTERACT_SUCCESS
	if(tool.picklvl)
		INVOKE_ASYNC(src, PROC_REF(pick_lock), user, tool)
		return ITEM_INTERACT_SUCCESS
	if(repairable && (istype(tool, repair_cost_first) || istype(tool, repair_cost_second)))
		INVOKE_ASYNC(src, PROC_REF(repair), user, tool)
		return ITEM_INTERACT_SUCCESS
	return ..()

/obj/structure/mineral_door/rockhill/pickaxe_door(mob/living/user, obj/item/tool)
	return FALSE

/obj/structure/mineral_door/rockhill/atom_break(damage_flag)
	. = ..()
	if(broken)
		return
	broken = TRUE
	set_density(FALSE)
	set_opacity(FALSE)
	update_appearance()

/obj/structure/mineral_door/rockhill/proc/use_key(mob/user, obj/item/key)
	if(door_opened || isSwitchingStates)
		return
	if(!keylock)
		to_chat(user, span_warning("[src] has no lock."))
		return
	if(!rockhill_key_fits(key, lockid, masterkey))
		to_chat(user, span_warning("This is not the key to [src]."))
		rattle()
		return
	toggle_lock(user)

/obj/structure/mineral_door/rockhill/proc/toggle_lock(mob/user)
	if(isSwitchingStates || door_opened)
		return
	locked = !locked
	playsound(src, locked ? locksound : unlocksound, 100)
	user?.visible_message(span_warning("[user] [locked ? "locks" : "unlocks"] [src]."), span_notice("I [locked ? "lock" : "unlock"] [src]."))

/obj/structure/mineral_door/rockhill/proc/rattle()
	playsound(src, rattlesound, 100)
	var/start_x = pixel_x
	animate(src, pixel_x = start_x + 1, time = 0.5)
	animate(pixel_x = start_x - 1, time = 0.5)
	animate(pixel_x = start_x, time = 0.5)

/obj/structure/mineral_door/rockhill/proc/knock(mob/user)
	if(world.time < last_bump + 2 SECONDS)
		return
	last_bump = world.time
	playsound(src, 'modular_redtard/rockhill/sound/doors/knocking.ogg', 100)
	user.visible_message(span_warning("[user] knocks on [src]."), span_notice("I knock on [src]."))

/obj/structure/mineral_door/rockhill/proc/kick(mob/living/user)
	if(broken || isSwitchingStates)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src)
	playsound(src, 'modular_redtard/rockhill/sound/doors/woodimpact.ogg', 100)
	if(door_opened)
		user.visible_message(span_warning("[user] kicks [src] shut!"), span_notice("I kick [src] shut!"))
		INVOKE_ASYNC(src, PROC_REF(Close))
		return
	var/strength = ROCKHILL_BASE_STRENGTH
	if(locked)
		if(strength >= initial(kickthresh))
			kickthresh--
		if(strength < initial(kickthresh) || !(prob(strength * 0.5) || kickthresh <= 0))
			user.visible_message(span_warning("[user] kicks [src]!"), span_notice("I kick [src]!"))
			rattle()
			return
		locked = FALSE
		relock = FALSE
	user.visible_message(span_warning("[user] kicks open [src]!"), span_notice("I kick open [src]!"))
	INVOKE_ASYNC(src, PROC_REF(Open))

/obj/structure/mineral_door/rockhill/proc/repair(mob/living/user, obj/item/material)
	var/needed = (broken && repair_state) ? repair_cost_second : repair_cost_first
	if(!istype(material, needed))
		var/obj/item/wanted = needed
		to_chat(user, span_warning("I need [initial(wanted.name)] for this."))
		return
	if(!broken && atom_integrity >= max_integrity)
		return
	user.visible_message(span_notice("[user] starts repairing [src]."), span_notice("I start repairing [src]."))
	playsound(src, 'modular_redtard/rockhill/sound/doors/woodsaw.ogg', 100, TRUE)
	if(!do_after(user, 30 SECONDS, src))
		return
	qdel(material)
	playsound(src, 'modular_redtard/rockhill/sound/doors/woodsaw.ogg', 100, TRUE)
	if(!broken)
		repair_damage(max_integrity / 2)
		user.visible_message(span_notice("[user] repairs [src]."), span_notice("I repair [src]."))
		return
	if(!repair_state)
		repair_state = 1
		var/obj/item/second = repair_cost_second
		to_chat(user, span_notice("An additional [initial(second.name)] is needed to finish the job."))
		return
	repair_state = 0
	broken = FALSE
	door_opened = FALSE
	layer = initial(layer)
	repair_damage(max_integrity)
	set_density(TRUE)
	set_opacity(closed_opacity())
	update_appearance()
	user.visible_message(span_notice("[user] repairs [src]."), span_notice("I repair [src]."))

/obj/structure/mineral_door/rockhill/proc/pick_lock(mob/living/user, obj/item/lockpick)
	if(door_opened || isSwitchingStates || !keylock || broken)
		return
	if(rockhill_pick_lock(user, lockpick, src, lockdifficulty, lock_strength))
		toggle_lock(user)

/obj/structure/mineral_door/rockhill/proc/can_claim(mob/living/carbon/human/user)
	if(!grant_resident_key || !lockid || !ishuman(user) || user.received_resident_key)
		return FALSE
	var/datum/job/roguetown/job = SSjob.name_occupations[user.job]
	if(resident_role && job?.type != resident_role)
		return FALSE
	if(resident_advclass && !(istype(job) && (job.rockhill_advclass in resident_advclass)))
		return FALSE
	return TRUE

/obj/structure/mineral_door/rockhill/proc/claim_home(mob/living/carbon/human/user)
	if(tgui_alert(user, "Is this my home?", "Home", list("Yes", "No")) != "Yes" || !can_claim(user))
		return
	var/amount = tgui_alert(user, "Have I got a spare key?", "Home", list("Yes", "No")) == "Yes" ? 2 : resident_key_amount
	if(!can_claim(user))
		return
	for(var/i in 1 to amount)
		var/obj/item/roguekey/key = new resident_key_type(get_turf(user))
		key.lockid = lockid
		user.put_in_hands(key)
	user.received_resident_key = TRUE
	grant_resident_key = FALSE
	name = "[user.real_name] the [user.job]'s house"
	to_chat(user, span_notice(amount > 1 ? "They're just where I left them..." : "It's just where I left it..."))

/obj/structure/mineral_door/rockhill/wood/Initialize(mapload)
	if(icon_state == "woodhandle" && !base_state)
		if(prob(10))
			icon_state = "wcg"
		else if(prob(10))
			icon_state = "wcr"
	return ..()

/obj/structure/mineral_door/rockhill/wood/deadbolt
	openSound = 'modular_redtard/rockhill/sound/doors/shittyopen.ogg'
	closeSound = 'modular_redtard/rockhill/sound/doors/shittyclose.ogg'
	var/lockdir

/obj/structure/mineral_door/rockhill/wood/deadbolt/Initialize(mapload)
	. = ..()
	lockdir = dir

/obj/structure/mineral_door/rockhill/wood/deadbolt/secondary_use(mob/user)
	if(keylock)
		return ..()
	if(get_dir(src, user) != lockdir)
		to_chat(user, span_warning("The deadbolt doesn't toggle from this side."))
	else if(!broken)
		toggle_lock(user)

/obj/structure/mineral_door/rockhill/wood/donjon
	locksound = 'modular_redtard/rockhill/sound/doors/lockmetal.ogg'
	unlocksound = 'modular_redtard/rockhill/sound/doors/lockmetal.ogg'
	rattlesound = 'modular_redtard/rockhill/sound/doors/lockrattlemetal.ogg'
	var/has_viewport = TRUE
	var/viewport_open = FALSE

/obj/structure/mineral_door/rockhill/wood/donjon/closed_opacity()
	return ..() && !viewport_open

/obj/structure/mineral_door/rockhill/wood/donjon/click_alt(mob/user)
	if(!has_viewport || door_opened || isSwitchingStates || broken)
		return NONE
	if(get_dir(src, user) != dir)
		to_chat(user, span_warning("The viewport doesn't toggle from this side."))
		return CLICK_ACTION_BLOCKING
	viewport_open = !viewport_open
	set_opacity(closed_opacity())
	playsound(src, 'modular_redtard/rockhill/sound/doors/windowup.ogg', 100, FALSE)
	to_chat(user, span_info("I slide the viewport [viewport_open ? "open" : "closed"]."))
	return CLICK_ACTION_SUCCESS

/obj/structure/mineral_door/rockhill/wood/donjon/stone
	has_viewport = FALSE

/obj/structure/mineral_door/rockhill/bars
	over_state = "barsopen"
	sheetType = /obj/item/stack/sheet/iron
	openSound = 'modular_redtard/rockhill/sound/doors/ironopen.ogg'
	closeSound = 'modular_redtard/rockhill/sound/doors/ironclose.ogg'
	locksound = 'modular_redtard/rockhill/sound/doors/lock.ogg'
	unlocksound = 'modular_redtard/rockhill/sound/doors/unlock.ogg'
	rattlesound = 'modular_redtard/rockhill/sound/doors/lockrattlemetal.ogg'

/obj/structure/mineral_door/rockhill/bars/kick(mob/living/user)
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src)
	user.visible_message(span_warning("[user] kicks [src]!"), span_notice("I kick [src]!"))
