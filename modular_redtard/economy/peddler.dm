/**
 * PEDDLER (Ratwood code/modules/roguetown/roguemachine/vendor.dm): a stall its keeper stocks. The keeper's key opens it: wares go
 * in (thirty at most, nothing bulkier than bulky), each kind gets a name and a price, takings come out as coins. Locked, it
 * sells: customers insert coins and buy, the price goes to the keeper's takings, change comes back. Now and then it calls out
 * a ware. The inn and bathhouse stalls start stocked with room and locker keys, as in Ratwood.
 */
/obj/structure/roguemachine/vendor
	/// Lockid of the key that opens the stall (map edit).
	var/keycontrol = "merchant"
	var/locked = TRUE
	/// Wares: item -> list("NAME" = shown name, "PRICE" = mammons) (Ratwood held_items).
	var/list/held_items = list()
	/// Takings of sales waiting for the keeper (Ratwood wgain).
	var/profits = 0
	var/max_items = 30
	/// Calls out a ware every minute or two (Ratwood will_hawk).
	var/will_hawk = TRUE
	/// Wares the stall starts with: path text -> price; paths not ported yet are skipped.
	var/list/starting_stock

/obj/structure/roguemachine/vendor/Initialize(mapload)
	. = ..()
	for(var/path_text in starting_stock)
		var/ware_type = text2path(path_text)
		if(!ispath(ware_type, /obj/item))
			continue
		var/obj/item/ware = new ware_type(src)
		held_items[ware] = list("NAME" = ware.name, "PRICE" = starting_stock[path_text])
	update_appearance()
	if(will_hawk)
		addtimer(CALLBACK(src, PROC_REF(hawk)), rand(1 MINUTES, 2 MINUTES), TIMER_DELETE_ME)

/obj/structure/roguemachine/vendor/Destroy()
	for(var/obj/item/ware as anything in held_items.Copy())
		ware.forceMove(drop_location())
	held_items.Cut()
	if(profits > 0)
		rogue_coins_out(profits, null, null, src)
		profits = 0
	return ..()

/obj/structure/roguemachine/vendor/Exited(atom/movable/gone, direction)
	. = ..()
	if(held_items[gone])
		held_items -= gone
		update_appearance()

/obj/structure/roguemachine/vendor/update_icon_state()
	icon_state = locked ? "streetvendor1" : "streetvendor0"
	return ..()

/obj/structure/roguemachine/vendor/update_overlays()
	. = ..()
	var/lit = locked && length(held_items)
	set_light(lit ? 1 : 0, 1, "#1b7bf1")
	if(lit)
		. += mutable_appearance(icon, "vendor-gen")

/obj/structure/roguemachine/vendor/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.combat_mode)
		return NONE
	if(istype(tool, /obj/item/roguecoin))
		take_coins(tool, user)
		ui_interact(user)
		return ITEM_INTERACT_SUCCESS
	if((istype(tool, /obj/item/roguekey) || istype(tool, /obj/item/storage/keyring)) && rockhill_key_fits(tool, keycontrol))
		locked = !locked
		playsound(src, ROGUE_SOUND_BEEP, 100, FALSE, -1)
		update_appearance()
		SStgui.update_uis(src)
		return ITEM_INTERACT_SUCCESS
	if(locked)
		if(istype(tool, /obj/item/roguekey) || istype(tool, /obj/item/storage/keyring))
			to_chat(user, span_warning("Wrong key."))
			return ITEM_INTERACT_BLOCKING
		return NONE
	insert(tool, user)
	return ITEM_INTERACT_SUCCESS

/// Puts a ware in the open stall; a ware named like one already there takes its price (Ratwood insert()).
/obj/structure/roguemachine/vendor/proc/insert(obj/item/ware, mob/user)
	if(ware.w_class > WEIGHT_CLASS_BULKY)
		to_chat(user, span_warning("[ware] does not fit."))
		return FALSE
	if(length(held_items) >= max_items)
		to_chat(user, span_warning("Full."))
		return FALSE
	if(!user.transferItemToLoc(ware, src))
		return FALSE
	var/price = 0
	for(var/obj/item/other as anything in held_items)
		if(other.name == ware.name)
			price = held_items[other]["PRICE"]
			break
	held_items[ware] = list("NAME" = ware.name, "PRICE" = price)
	playsound(src, ROGUE_SOUND_MACHINE_VOMIT, 100, TRUE, -1)
	update_appearance()
	ui_interact(user)
	return TRUE

/// Wares of one kind: same type, same shown name (Ratwood get_group_items()).
/obj/structure/roguemachine/vendor/proc/group_items(key)
	var/list/matches = list()
	for(var/obj/item/ware as anything in held_items)
		if("[ware.type]_[held_items[ware]["NAME"]]" == key)
			matches += ware
	return matches

/// Calls out a ware for sale, with a plural when there are more of it (Ratwood process()).
/obj/structure/roguemachine/vendor/proc/hawk()
	if(QDELETED(src))
		return
	if(length(held_items))
		var/obj/item/ware = pick(held_items)
		var/ware_name = capitalize(held_items[ware]["NAME"])
		if(copytext(ware_name, -1) != "s")
			for(var/obj/item/other as anything in held_items)
				if(other != ware && other.type == ware.type && held_items[other]["NAME"] == held_items[ware]["NAME"])
					ware_name += "s"
					break
		say("[ware_name] for sale! [held_items[ware]["PRICE"]] mammons!")
	addtimer(CALLBACK(src, PROC_REF(hawk)), rand(1 MINUTES, 2 MINUTES), TIMER_DELETE_ME)

/obj/structure/roguemachine/vendor/interact(mob/user)
	if(!ishuman(user))
		return FALSE
	playsound(src, ROGUE_SOUND_BEEP, 100, FALSE, -1)
	return ..()

/obj/structure/roguemachine/vendor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RoguePeddler", name)
		ui.open()

/obj/structure/roguemachine/vendor/ui_data(mob/user)
	var/list/data = list()
	data["locked"] = locked
	data["budget"] = budget
	data["profits"] = profits
	var/list/groups = list()
	for(var/obj/item/ware as anything in held_items)
		var/ware_name = held_items[ware]["NAME"]
		var/key = "[ware.type]_[ware_name]"
		if(groups[key])
			groups[key]["count"]++
			continue
		groups[key] = list("key" = key, "name" = ware_name, "price" = held_items[ware]["PRICE"], "count" = 1)
	var/list/wares = list()
	for(var/key in groups)
		wares += list(groups[key])
	data["wares"] = wares
	return data

/obj/structure/roguemachine/vendor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/living/user = ui.user
	switch(action)
		if("change")
			if(locked)
				return_change(user)
			return TRUE
		if("withdraw_profits")
			if(!locked && profits > 0)
				profits -= rogue_coins_out(profits, user, null, src)
			return TRUE
	var/list/matches = group_items(params["key"])
	if(!length(matches))
		return TRUE
	var/obj/item/ware = matches[1]
	switch(action)
		if("buy")
			if(!locked)
				return TRUE
			var/price = held_items[ware]["PRICE"] || 0
			if(price > budget)
				say("NO MONEY NO HONEY!")
				return TRUE
			budget -= price
			profits += price
			held_items -= ware
			ware.forceMove(drop_location())
			user.put_in_hands(ware)
			playsound(src, ROGUE_SOUND_MACHINE_VOMIT, 100, TRUE, -1)
		if("retrieve")
			if(locked)
				return TRUE
			held_items -= ware
			ware.forceMove(drop_location())
			user.put_in_hands(ware)
		if("setname")
			if(locked)
				return TRUE
			var/new_name = tgui_input_text(user, "SET A NEW NAME FOR THIS PRODUCT", name, held_items[ware]["NAME"], max_length = MAX_NAME_LEN)
			if(!new_name || locked || QDELETED(src) || !user.can_perform_action(src))
				return TRUE
			for(var/obj/item/same as anything in matches)
				if(held_items[same])
					held_items[same]["NAME"] = new_name
		if("setprice")
			if(locked)
				return TRUE
			var/new_price = tgui_input_number(user, "SET A NEW PRICE FOR THIS PRODUCT", name, held_items[ware]["PRICE"], max_value = ROGUE_TRANSFER_MAX, min_value = 0)
			if(isnull(new_price) || locked || QDELETED(src) || !user.can_perform_action(src))
				return TRUE
			for(var/obj/item/same as anything in matches)
				if(held_items[same])
					held_items[same]["PRICE"] = round(new_price)
	update_appearance()
	return TRUE

/obj/structure/roguemachine/vendor/innrockhill
	keycontrol = "tavern"
	will_hawk = FALSE
	starting_stock = list(
		"/obj/item/roguekey/roomi" = 20,
		"/obj/item/roguekey/roomii" = 20,
		"/obj/item/roguekey/roomiii" = 20,
		"/obj/item/roguekey/roomiv" = 20,
		"/obj/item/roguekey/roomv" = 20,
		"/obj/item/roguekey/roomvi" = 20,
		"/obj/item/roguekey/roomvii" = 20,
		"/obj/item/roguekey/roomviii" = 20,
		"/obj/item/roguekey/roomix" = 20,
		"/obj/item/roguekey/roomx" = 20,
		"/obj/item/storage/keyring/innfancyi" = 100,
		"/obj/item/storage/keyring/innfancyii" = 100,
		"/obj/item/storage/keyring/innfancyiii" = 100,
	)

/obj/structure/roguemachine/vendor/bathhouse
	keycontrol = "nightmaiden"

/obj/structure/roguemachine/vendor/bathhouse/locker
	will_hawk = FALSE
	starting_stock = list(
		"/obj/item/roguekey/bathlocker1" = 5,
		"/obj/item/roguekey/bathlocker2" = 5,
		"/obj/item/roguekey/bathlocker3" = 5,
		"/obj/item/roguekey/bathlocker4" = 5,
		"/obj/item/roguekey/bathlocker5" = 5,
		"/obj/item/roguekey/bathlocker6" = 5,
	)
