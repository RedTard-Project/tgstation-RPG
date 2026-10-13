/obj/item
	var/lockid
	var/picklvl = 0

/obj/item/roguekey
	var/master_key = FALSE

/obj/item/roguekey/lord
	master_key = TRUE

/obj/item/storage/keyring
	var/list/rockhill_keys

/obj/item/storage/keyring/Initialize(mapload)
	. = ..()
	atom_storage.set_holdable(list(/obj/item/roguekey))
	atom_storage.max_slots = 20
	atom_storage.max_total_storage = 20
	atom_storage.max_specific_storage = WEIGHT_CLASS_SMALL
	update_appearance(UPDATE_ICON_STATE)

/obj/item/storage/keyring/PopulateContents()
	for(var/key_type in rockhill_keys)
		new key_type(src)

/obj/item/storage/keyring/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	update_appearance(UPDATE_ICON_STATE)

/obj/item/storage/keyring/Exited(atom/movable/gone, direction)
	. = ..()
	update_appearance(UPDATE_ICON_STATE)

/obj/item/storage/keyring/update_icon_state()
	icon_state = "keyring[min(length(contents), 5)]"
	return ..()

/proc/rockhill_key_fits(obj/item/key, lockid, masterkey)
	if(istype(key, /obj/item/roguekey))
		var/obj/item/roguekey/door_key = key
		return (lockid && door_key.lockid == lockid) || (masterkey && door_key.master_key)
	if(istype(key, /obj/item/storage/keyring))
		for(var/obj/item/ring_key in key)
			if(rockhill_key_fits(ring_key, lockid, masterkey))
				return TRUE
	return FALSE

/proc/rockhill_find_key(mob/user, lockid, masterkey)
	var/obj/item/held = user.get_active_held_item()
	if(held && rockhill_key_fits(held, lockid, masterkey))
		return held
	for(var/obj/item/worn in user.get_equipped_items(INCLUDE_POCKETS))
		if(rockhill_key_fits(worn, lockid, masterkey))
			return worn
		for(var/obj/item/inner in worn)
			if(rockhill_key_fits(inner, lockid, masterkey))
				return inner
	return null

/proc/rockhill_pick_lock(mob/living/user, obj/item/lockpick, atom/lock_holder, lockdifficulty, lock_strength)
	if(lockdifficulty > 2 && lockpick.picklvl < 1)
		to_chat(user, span_warning("My lockpick is too poor to handle this lock."))
		return FALSE
	var/chance = clamp(35 * lockpick.picklvl, 1, 95)
	var/delay = 7 SECONDS
	if(lockdifficulty > 1)
		delay += lockdifficulty SECONDS
		chance /= lockdifficulty * 0.75
	var/progress = 0
	while(progress < lock_strength && !QDELETED(lockpick))
		if(!do_after(user, delay, lock_holder))
			return FALSE
		if(prob(chance))
			progress += 10
			playsound(lock_holder, pick('modular_redtard/rockhill/sound/doors/pickgood1.ogg', 'modular_redtard/rockhill/sound/doors/pickgood2.ogg'), 5, TRUE)
			to_chat(user, span_warning("Click..."))
			continue
		playsound(lock_holder, 'modular_redtard/rockhill/sound/doors/pickbad.ogg', 40, TRUE)
		to_chat(user, span_warning("Clack."))
		lockpick.take_damage(1, BRUTE, MELEE)
	if(progress < lock_strength)
		return FALSE
	to_chat(user, span_notice("The locking mechanism gives."))
	user.log_message("lockpicked [lock_holder].", LOG_ATTACK)
	return TRUE
