GLOBAL_LIST_INIT(rogue_sharpen_sounds, list('modular_redtard/rockhill/sound/items/sharpen_long1.ogg', 'modular_redtard/rockhill/sound/items/sharpen_long2.ogg'))

/obj/item
	var/max_blade_int = 0
	var/blade_int = 0
	var/sharpening_factor = 0
	var/spark_chance = 0

/obj/item/Initialize(mapload)
	. = ..()
	if(max_blade_int)
		blade_int = max_blade_int
	if(sharpening_factor)
		AddElement(/datum/element/rogue_whetstone)

/obj/item/proc/rogue_edge_ratio()
	return max_blade_int ? blade_int / max_blade_int : 1

/obj/item/proc/rogue_dull(amount, mob/living/holder)
	if(!max_blade_int || amount <= 0)
		return FALSE
	var/before = rogue_edge_ratio()
	blade_int = max(blade_int - amount, 0)
	var/after = rogue_edge_ratio()
	if(holder)
		var/noticed = holder.rogue_stat(ROGUE_STAT_INTELLIGENCE) >= ROGUE_ATTRIBUTE_MIDDLING
		if(before > ROGUE_BLADE_DULL_START && after <= ROGUE_BLADE_DULL_START)
			if(noticed)
				to_chat(holder, span_info("The edge chips! [src]'s damage will start to slowly wane, now."))
			playsound(holder, 'modular_redtard/rockhill/sound/combat/sharpness_loss1.ogg', 75, TRUE)
		if(before > ROGUE_BLADE_CHIP_START && after <= ROGUE_BLADE_CHIP_START)
			if(noticed)
				to_chat(holder, span_userdanger("A chunk snapped off! [src]'s damage will decay much quicker now."))
			playsound(holder, 'modular_redtard/rockhill/sound/combat/sharpness_loss2.ogg', 100, TRUE)
	return blade_int > 0

/obj/item/proc/rogue_sharpen(obj/item/stone, mob/living/user, factor = 1)
	playsound(loc, pick(GLOB.rogue_sharpen_sounds), 100, TRUE)
	user.visible_message(span_notice("[user] sharpens [src]!"))
	var/before = rogue_edge_ratio()
	max_blade_int = max(max_blade_int - ROGUE_BLADE_SHARPEN_WEAR, ROGUE_BLADE_MIN_MAX)
	blade_int = min(blade_int + stone.sharpening_factor * factor, max_blade_int)
	var/after = rogue_edge_ratio()
	if(before < ROGUE_BLADE_CHIP_START && after > ROGUE_BLADE_CHIP_START)
		to_chat(user, span_info("The chunks smooth out. The edge regains some smoothness."))
	if(before < ROGUE_BLADE_DULL_START && after > ROGUE_BLADE_DULL_START)
		to_chat(user, span_info("The chips disappear. The edge is now as sharp as ever."))
	if(prob(stone.spark_chance))
		do_sparks(1, TRUE, get_step(user, user.dir))

/obj/item/proc/rogue_edge_text()
	var/ratio = rogue_edge_ratio()
	if(ratio <= ROGUE_BLADE_CHIP_START)
		return "The edge is chipped and blunt."
	if(ratio <= ROGUE_BLADE_DULL_START)
		return "The edge is chipped."
	return "The edge is sharp."

/mob/living/proc/rogue_sharpen_blade(obj/item/blade, obj/item/stone)
	if(!blade.max_blade_int || !stone.sharpening_factor)
		return
	if(blade.blade_int >= blade.max_blade_int)
		to_chat(src, span_info("Fully sharpened."))
		return
	blade.rogue_sharpen(stone, src, ROGUE_BLADE_SHARPEN_FIRST)
	var/strokes = round(blade.max_blade_int / stone.sharpening_factor, 1) + 1
	for(var/stroke in 1 to strokes)
		if(blade.blade_int >= blade.max_blade_int)
			break
		if(!do_after(src, ROGUE_BLADE_SHARPEN_TIME, blade) || QDELETED(stone) || QDELETED(blade))
			return
		blade.rogue_sharpen(stone, src)
	if(blade.blade_int >= blade.max_blade_int)
		to_chat(src, span_info("Fully sharpened."))

/datum/element/rogue_whetstone/proc/on_interact(obj/item/source, mob/living/user, atom/interacting_with, list/modifiers)
	SIGNAL_HANDLER
	var/obj/item/blade = interacting_with
	if(!istype(blade) || !blade.max_blade_int || blade == source)
		return NONE
	INVOKE_ASYNC(user, TYPE_PROC_REF(/mob/living, rogue_sharpen_blade), blade, source)
	return ITEM_INTERACT_SUCCESS
