/// The miracles of Malum that the basket (miracle.dm) did not have yet: Vigorous Exchange, Heat Metal, Hammerfall and the Crafter's
/// Covenant (Ratwood code/modules/spells/roguetown/acolyte/malum.dm; Azure Peak has them in a form of its own). Malum's fire is
/// Ignition (light.dm). The numbers are in faith.txt, the ones of a cast by miracle_<value_key>_*.

#define ROGUE_MALUM_ICON 'modular_redtard/faith/icons/malummiracles.dmi'

/// Malum's flame colours his words (Ratwood show_visible_message()): the message of a rite of the smith, in yellow.
/proc/rogue_malum_message(mob/speaker, text, selftext)
	speaker.visible_message("<font color='yellow'>[text]</font>", selftext ? "<font color='yellow'>[selftext]</font>" : null)

/// Ratwood vigorousexchange "Vigorous Exchange" (T1 of Malum): the devotee's own energy is refreshed; given to another, the
/// same amount twice over is taken from the caster's own and handed over, if the caster has it to give.
/datum/action/cooldown/spell/pointed/rogue_miracle/vigorous_exchange
	name = "Vigorous Exchange"
	desc = "Restores the target's energy, twice as much if it is someone else, from my own."
	button_icon = ROGUE_MALUM_ICON
	button_icon_state = "vigorous_exchange"
	sound = 'sound/items/tools/welder.ogg'
	invocation = "Through flame and ash, let vigor rise, by Malum's hand, let strength reprise!"
	invocation_type = INVOCATION_SHOUT
	value_key = "vigorous_exchange"
	miracle_tier = ROGUE_MIRACLE_TIER_1
	needs_holy_symbol = TRUE
	miracle_forks = "Ratwood, Azure Peak"
	miracle_gods = "Malum T1"

/datum/action/cooldown/spell/pointed/rogue_miracle/vigorous_exchange/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !ishuman(cast_on))
		to_chat(owner, span_warning("Only a man's strength can be given."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/vigorous_exchange/cast(mob/living/carbon/human/cast_on)
	. = ..()
	var/mob/living/carbon/human/caster = owner
	var/refresh = rogue_value("faith_vigorous_energy")
	if(cast_on == caster)
		caster.rogue_energy_add(refresh)
		rogue_malum_message(caster, "As [caster] intones the incantation, vibrant flames swirl around them.", "As I intone the incantation, vibrant flames swirl around me. I feel refreshed.")
		return
	var/gift = refresh * rogue_value("faith_vigorous_other_factor")
	if(caster.rogue_energy <= gift)
		return fail("I do not have the strength to give.")
	caster.rogue_energy_add(-gift)
	cast_on.rogue_energy_add(gift)
	rogue_malum_message(cast_on, "As [caster] intones the incantation, vibrant flames swirl around them, a dance of energy flowing towards [cast_on].", "As [caster] intones the incantation, vibrant flames swirl around them, a dance of energy flowing towards me. I feel refreshed.")

/// The item a smith's spell finds on a creature by the part the caster aims at (Ratwood get_targeted_item()).
/proc/rogue_malum_targeted_item(mob/living/user, mob/living/carbon/target)
	switch(user.zone_selected)
		if(BODY_ZONE_PRECISE_R_HAND)
			return target.held_items[2]
		if(BODY_ZONE_PRECISE_L_HAND)
			return target.held_items[1]
		if(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_EYES)
			return target.get_item_by_slot(ITEM_SLOT_HEAD)
		if(BODY_ZONE_PRECISE_MOUTH)
			return target.get_item_by_slot(ITEM_SLOT_MASK)
		if(BODY_ZONE_CHEST)
			return target.get_item_by_slot(ITEM_SLOT_OCLOTHING) || target.get_item_by_slot(ITEM_SLOT_ROGUE_SHIRT)
		if(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
			return target.get_item_by_slot(ITEM_SLOT_ROGUE_WRISTS)
		if(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_GROIN)
			return target.get_item_by_slot(ITEM_SLOT_ICLOTHING)
		if(BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_R_FOOT)
			return target.get_item_by_slot(ITEM_SLOT_FEET)
	return null

/// What melts in a smelter heats here: an item with a smelting result that is not ash.
/proc/rogue_malum_is_metal(obj/item/thing)
	return thing && thing.smeltresult && thing.smeltresult != /obj/item/ash

/// Ratwood heatmetal "Heat Metal" (T2 of Malum): the incantation melts a single item into an ingot, makes the ingot in a pair of
/// tongs glow, or makes a creature drop the hot metal in its hand or burns the one who wears it.
/datum/action/cooldown/spell/pointed/rogue_miracle/heat_metal
	name = "Heat Metal"
	desc = "Melts a single item into an ingot, heats up an ingot in tongs, makes a creature drop a hot metal weapon or burns whoever wears hot metal armour."
	button_icon = ROGUE_MALUM_ICON
	button_icon_state = "heat_metal"
	sound = 'sound/items/tools/welder.ogg'
	invocation = "With heat I wield, with flame I claim, Let metal serve in Malum's name!"
	invocation_type = INVOCATION_SHOUT
	value_key = "heat_metal"
	miracle_tier = ROGUE_MIRACLE_TIER_2
	needs_holy_symbol = TRUE
	miracle_forks = "Ratwood, Azure Peak"
	miracle_gods = "Malum T2"

/datum/action/cooldown/spell/pointed/rogue_miracle/heat_metal/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !isitem(cast_on) && !iscarbon(cast_on))
		to_chat(owner, span_warning("Only an item or a creature can be heated."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/heat_metal/cast(atom/cast_on)
	. = ..()
	var/mob/living/caster = owner
	if(isitem(cast_on))
		var/obj/item/thing = cast_on
		if(istype(thing, /obj/item/rogueore/coal) || !thing.smeltresult)
			return fail("[thing] will not melt.")
		var/turf/where = get_turf(thing)
		rogue_malum_message(caster, "After [caster]'s incantation, [thing] glows brightly and melts into an ingot.")
		new thing.smeltresult(where)
		do_sparks(1, TRUE, where)
		qdel(thing)
		return
	var/mob/living/carbon/target = cast_on
	var/obj/item/aimed = rogue_malum_targeted_item(caster, target)
	var/tongs = istype(aimed, /obj/item/rogueweapon/tongs)
	if((!tongs && !rogue_malum_is_metal(aimed)) || target.can_block_magic(MAGIC_RESISTANCE_HOLY))
		rogue_malum_message(caster, "After their incantation, [caster] points at [target] but it seems to have no effect.", "After my incantation, I point at [target] but it seems to have no effect.")
		return
	if(tongs)
		var/obj/item/rogueweapon/tongs/pair = aimed
		if(!pair.held_bar)
			return fail("The tongs hold nothing to heat.")
		pair.heat()
		rogue_malum_message(caster, "After [caster]'s incantation, the ingot inside [pair] starts glowing.", "After my incantation, the ingot inside [pair] starts glowing.")
		return
	if(aimed in target.held_items)
		burn_hand(target, aimed, caster)
	else
		burn_worn(target, aimed)

/// A hot weapon in the hand: the hand burns and lets go of it.
/datum/action/cooldown/spell/pointed/rogue_miracle/heat_metal/proc/burn_hand(mob/living/carbon/target, obj/item/aimed, mob/living/caster)
	var/obj/item/bodypart/hand = target.get_bodypart(target.get_held_index_of_item(aimed) % 2 ? BODY_ZONE_L_ARM : BODY_ZONE_R_ARM)
	hand?.receive_damage(burn = rogue_value("faith_heat_metal_hand"))
	target.dropItemToGround(aimed)
	rogue_malum_message(target, "[target]'s [aimed.name] glows brightly, searing their flesh.", "My [aimed.name] glows brightly. It burns!")
	target.emote("painscream")
	playsound(get_turf(target), 'sound/items/tools/welder2.ogg', 100, FALSE, -1)
	do_sparks(1, TRUE, get_turf(target))

/// Hot armour: every limb it covers burns; a hot piece over a shirt that is not metal burns half as much on the chest.
/datum/action/cooldown/spell/pointed/rogue_miracle/heat_metal/proc/burn_worn(mob/living/carbon/target, obj/item/aimed)
	var/obj/item/armour = target.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	var/obj/item/shirt = target.get_item_by_slot(ITEM_SLOT_ROGUE_SHIRT)
	var/damage = rogue_value("faith_heat_metal_worn")
	if(rogue_malum_is_metal(armour) && shirt && !rogue_malum_is_metal(shirt))
		damage /= 2
	// Every metal layer that covers the chest burns it; the rest burn what they cover.
	var/list/hot = list(aimed)
	if(aimed == armour && rogue_malum_is_metal(shirt))
		hot += shirt
	else if(aimed == shirt && rogue_malum_is_metal(armour))
		hot += armour
	for(var/obj/item/piece as anything in hot)
		for(var/obj/item/bodypart/limb as anything in target.bodyparts)
			if(piece.body_parts_covered & limb.body_part)
				limb.receive_damage(burn = damage)
	do_sparks(1, TRUE, get_turf(target))
	rogue_malum_message(target, "[target]'s [aimed.name] glows brightly, searing their flesh.", "My [aimed.name] glows brightly. It burns!")
	playsound(get_turf(target), 'sound/items/tools/welder2.ogg', 100, FALSE, -1)

/// The marks of Hammerfall: a warning of fire on the ground before the hammer comes down.
/obj/effect/temp_visual/rogue_hammerfall
	icon = 'icons/effects/effects.dmi'
	icon_state = "lavastaff_warn"
	duration = 5 SECONDS

/// Ratwood hammerfall "Hammerfall" (T3 of Malum): a hammer of molten fire is hurled at the ground; after a moment the earth
/// trembles, those around the mark are thrown down and the structures, walls and rock at the mark are broken.
/datum/action/cooldown/spell/pointed/rogue_miracle/hammerfall
	name = "Hammerfall"
	desc = "Damages structures in an area while possibly knocking down creatures in the area."
	button_icon = ROGUE_MALUM_ICON
	button_icon_state = "hammerfall"
	sound = 'sound/effects/explosion/explosion_distant.ogg'
	invocation = "By molten might and hammer's weight, in Malum's flame, the earth shall quake!"
	invocation_type = INVOCATION_SHOUT
	value_key = "hammerfall"
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_3
	needs_holy_symbol = TRUE
	miracle_forks = "Ratwood, Azure Peak"
	miracle_gods = "Malum T3"

/datum/action/cooldown/spell/pointed/rogue_miracle/hammerfall/cast(atom/cast_on)
	. = ..()
	var/turf/zone = get_turf(cast_on)
	if(!zone)
		return fail()
	INVOKE_ASYNC(src, PROC_REF(fall), owner, zone)

/datum/action/cooldown/spell/pointed/rogue_miracle/hammerfall/proc/fall(mob/living/caster, turf/zone)
	rogue_malum_message(caster, "[caster] raises their arm, conjuring a hammer wreathed in molten fire. As they hurl it toward the ground, the earth trembles under its impact, shaking its very foundations!", "I raise my arm, conjuring a hammer wreathed in molten fire. As I hurl it toward the ground, the earth trembles under its impact, shaking its very foundations!")
	var/radius = rogue_value("faith_hammerfall_radius")
	var/delay = rogue_value("faith_hammerfall_delay")
	for(var/turf/open/mark in view(radius, zone))
		new /obj/effect/temp_visual/rogue_hammerfall(mark)
	sleep(delay)
	var/damage = rogue_value("faith_hammerfall_damage")
	for(var/mob/living/carbon/shaken in view(rogue_value("faith_hammerfall_quake"), zone))
		shake_camera(shaken, 5, 5)
	for(var/mob/living/carbon/fallen in view(radius, zone))
		fallen.Knockdown(rogue_value("faith_hammerfall_knockdown"))
		to_chat(fallen, span_danger("The ground quakes, making me fall over."))
	for(var/obj/structure/damaged in view(radius, zone))
		damaged.take_damage(damage, BRUTE, MELEE, TRUE)
	for(var/turf/closed/wall/broken in view(radius, zone))
		broken.take_damage(damage, BRUTE, MELEE, TRUE)
	for(var/turf/closed/mineral/rock in view(radius, zone))
		rock.gets_drilled(caster)

/// The worth of what an anvil recipe is made of: the bar and the materials added to it (Ratwood anvil_recipe_prices). Worked
/// out once: the recipe's name and item, and the price.
/proc/rogue_covenant_boons()
	var/static/list/boons
	if(boons)
		return boons
	boons = list()
	for(var/datum/anvil_recipe/recipe as anything in GLOB.rogue_anvil_recipes)
		var/price = 0
		var/bar = recipe.req_bar
		var/obj/item/made = recipe.created_item
		if(bar)
			price += rogue_base_price(bar)
		for(var/material in recipe.additional_items)
			price += rogue_base_price(material)
		if(price <= 0 || !made)
			continue
		boons += list(list(initial(made.name), made, price))
	return boons

/// Ratwood craftercovenant "The Crafter's Covenant" (T4 of Malum): the valuables on a tile are melted down and, after a long
/// prayer, made into one item the smiths know how to make, if the worth was enough, by half of what it would cost. A sacrifice
/// is taken even if it was not enough.
/datum/action/cooldown/spell/pointed/rogue_miracle/crafter_covenant
	name = "The Crafter's Covenant"
	desc = "Melt a pile of valuables and convert them into a single item. The sacrifice is accepted even if it is not valuable enough to make anything."
	button_icon = ROGUE_MALUM_ICON
	button_icon_state = "craftercovenant"
	sound = 'sound/items/tools/welder.ogg'
	invocation = "Coins to ash, flame to form, in Malum's name, let creation be born!"
	invocation_type = INVOCATION_SHOUT
	value_key = "crafter_covenant"
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_4
	needs_holy_symbol = TRUE
	miracle_forks = "Ratwood, Azure Peak"
	miracle_gods = "Malum T4"

/datum/action/cooldown/spell/pointed/rogue_miracle/crafter_covenant/cast(atom/cast_on)
	. = ..()
	var/turf/altar = get_turf(cast_on)
	if(!altar)
		return fail()
	INVOKE_ASYNC(src, PROC_REF(offer), owner, altar)

/datum/action/cooldown/spell/pointed/rogue_miracle/crafter_covenant/proc/offer(mob/living/caster, turf/altar)
	if(!do_after(caster, rogue_value("faith_covenant_prayer"), target = altar))
		to_chat(caster, span_warning("The prayer is broken off, and the flame dies down."))
		refund()
		return
	var/tithe = 0
	for(var/obj/item/sacrifice in altar)
		if(istype(sacrifice, /obj/item/roguecoin))
			var/obj/item/roguecoin/coins = sacrifice
			tithe += coins.get_real_price()
		else if(istype(sacrifice, /obj/item/roguestatue) || istype(sacrifice, /obj/item/clothing/ring) || istype(sacrifice, /obj/item/roguegem))
			tithe += sacrifice.sellprice
		else
			continue
		qdel(sacrifice)
	var/budget = tithe / rogue_value("faith_covenant_tax")
	var/list/choices = list()
	for(var/list/boon as anything in rogue_covenant_boons())
		if(boon[3] > budget)
			continue
		var/label = boon[1]
		if(choices[label])
			label = "[label] ([length(choices) + 1])"
		choices[label] = boon[2]
	if(!length(choices))
		rogue_malum_message(caster, "A wave of heat washes over the pile as [caster] speaks Malum's name. The pile of valuables crumbles into dust.", "A wave of heat washes over the pile as I speak Malum's name. The pile of valuables crumbles into dust. Malum accepted my sacrifice. Yet it seems it was not enough.")
		return
	var/choice = tgui_input_list(caster, "Choose your boon", "Available boons", sort_list(choices))
	if(!choice || !choices[choice])
		return
	var/boon_type = choices[choice]
	new boon_type(altar)
	do_sparks(1, TRUE, altar)
	rogue_malum_message(caster, "A wave of heat washes over the pile as [caster] speaks Malum's name. The pile of valuables crumbles into dust, only for the dust to reform into an item as if reborn from the flames. Malum has accepted the offering.", "A wave of heat washes over the pile as I speak Malum's name. The pile of valuables crumbles into dust, only for the dust to reform into an item as if reborn from the flames. Malum has accepted the offering.")

#undef ROGUE_MALUM_ICON
