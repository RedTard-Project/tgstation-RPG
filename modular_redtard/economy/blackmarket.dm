/**
 * The forest COPPERFACE (Ratwood code/modules/roguetown/roguemachine/blackmarket.dm): an outlaw's import machine in the ruins near
 * the bandit exit. Coins go in, packs of goods of its contraband catalog come out at the buyer's feet, no tariff and no lock.
 * It shares the GOLDFACE window (RogueGoldface) and the merchant's packs (economy/supply_packs.dm).
 */
/obj/structure/roguemachine/blackmarket
	/// Pack categories it sells (Ratwood categories and categories_gamer).
	var/list/categories = list(
		"General Labour",
		"Beverages",
		"Health and Hygiene",
		"Self Defense",
		"Diplomacy and Persuasion",
		"Exotic Import",
	)

/obj/structure/roguemachine/blackmarket/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/structure/roguemachine/blackmarket/update_overlays()
	. = ..()
	set_light(1, 1, "#1b7bf1")
	. += mutable_appearance(icon, "vendor-merch")

/obj/structure/roguemachine/blackmarket/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.combat_mode || !istype(tool, /obj/item/roguecoin))
		return NONE
	take_coins(tool, user)
	playsound(src, ROGUE_SOUND_MACHINE_VOMIT, 100, TRUE, -1)
	ui_interact(user)
	return ITEM_INTERACT_SUCCESS

/obj/structure/roguemachine/blackmarket/interact(mob/user)
	if(!ishuman(user))
		return FALSE
	return ..()

/obj/structure/roguemachine/blackmarket/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		playsound(src, ROGUE_SOUND_GOLD_MENU, 100, FALSE, -1)
		ui = new(user, src, "RogueGoldface", name)
		ui.open()

/obj/structure/roguemachine/blackmarket/proc/sells(datum/rogue_supply_pack/pack)
	return pack && (pack.group in categories)

/obj/structure/roguemachine/blackmarket/ui_static_data(mob/user)
	var/list/data = list()
	data["motto"] = "COPPERFACE - What's Yours."
	data["categories"] = categories
	data["is_public"] = FALSE
	var/list/packs = list()
	for(var/pack_type in GLOB.rogue_supply_packs)
		var/datum/rogue_supply_pack/pack = GLOB.rogue_supply_packs[pack_type]
		if(!sells(pack))
			continue
		packs += list(list(
			"ref" = "[pack_type]",
			"name" = pack.name,
			"category" = pack.group,
			"qty" = pack.no_name_quantity ? 1 : length(pack.contains),
			"cost" = pack.cost,
			"base" = pack.cost,
		))
	data["packs"] = packs
	return data

/obj/structure/roguemachine/blackmarket/ui_data(mob/user)
	return list(
		"budget" = budget,
		"tariff_rate" = 0,
		"dodging" = FALSE,
		"proprietor" = FALSE,
		"tariff_paid" = 0,
		"tariff_dodged" = 0,
	)

/obj/structure/roguemachine/blackmarket/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/living/user = ui.user
	switch(action)
		if("change")
			return_change(user)
			return TRUE
		if("buy")
			var/datum/rogue_supply_pack/pack = GLOB.rogue_supply_packs[text2path(params["ref"])]
			if(!sells(pack))
				return TRUE
			if(budget < pack.cost)
				say("Not enough!")
				return TRUE
			budget -= pack.cost
			var/turf/spot = get_turf(user)
			for(var/ware_type in pack.contains)
				new ware_type(spot)
			playsound(src, ROGUE_SOUND_GOLD_MISC, 70, FALSE, -1)
			return TRUE
