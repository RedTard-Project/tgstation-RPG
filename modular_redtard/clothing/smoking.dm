/// Ratwood's smokes (cigs_lighters.dm) on the ported zigs, cheroots and pipes: lit by any flame (a lighter, a torch, a burning
/// item), one burns for smoketime Ratwood ticks of two seconds, glowing, and gives its reagents to whoever holds it in the
/// mouth, spread over the whole burn. A burnt-out zig is gone; a pipe is left empty until stuffed with a leaf again.
/obj/item/clothing/mask/cigarette
	heat = 1000
	light_system = OVERLAY_LIGHT
	light_range = 1
	light_power = 0.6
	light_color = "#f5a885"
	light_on = FALSE
	var/lit = FALSE
	var/icon_on = "cigon"
	var/icon_off = "cigoff"
	/// Ratwood ticks of two seconds the smoke lasts.
	var/smoketime = 180
	var/chem_volume = 30
	var/list/list_reagents = list(/datum/reagent/drug/nicotine = 15)

/obj/item/clothing/mask/cigarette/Initialize(mapload)
	. = ..()
	create_reagents(chem_volume, INJECTABLE | NO_REACT)
	if(length(list_reagents))
		reagents.add_reagent_list(list_reagents)

/obj/item/clothing/mask/cigarette/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/clothing/mask/cigarette/get_temperature()
	return lit ? heat : 0

/obj/item/clothing/mask/cigarette/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(lit || smoketime <= 0)
		return ..()
	var/lighting_text = tool.ignition_effect(src, user)
	if(!lighting_text)
		return ..()
	rogue_light(lighting_text)
	return ITEM_INTERACT_SUCCESS

/obj/item/clothing/mask/cigarette/fire_act(exposed_temperature, exposed_volume)
	rogue_light()
	return ..()

/obj/item/clothing/mask/cigarette/extinguish()
	. = ..()
	rogue_unlight(span_notice("[src] goes out."))

/obj/item/clothing/mask/cigarette/attack_self(mob/user, modifiers)
	if(lit)
		user.visible_message(span_notice("[user] puts out [src]."), span_notice("I put out [src]."))
		rogue_unlight()
		return TRUE
	return ..()

/obj/item/clothing/mask/cigarette/proc/rogue_light(flavor_text)
	if(lit || smoketime <= 0)
		return
	lit = TRUE
	reagents.flags &= ~NO_REACT
	reagents.handle_reactions()
	set_light_on(TRUE)
	rogue_smoke_look()
	if(flavor_text)
		visible_message(flavor_text)
	START_PROCESSING(SSobj, src)

/obj/item/clothing/mask/cigarette/proc/rogue_unlight(message)
	if(!lit)
		return
	lit = FALSE
	reagents.flags |= NO_REACT
	set_light_on(FALSE)
	STOP_PROCESSING(SSobj, src)
	rogue_smoke_look()
	if(message && ismob(loc))
		to_chat(loc, message)

/obj/item/clothing/mask/cigarette/proc/rogue_smoke_look()
	icon_state = lit ? icon_on : icon_off
	worn_icon_state = icon_state
	update_slot_icon()

/obj/item/clothing/mask/cigarette/process(seconds_per_tick)
	var/ticks = seconds_per_tick / ROGUE_SMOKE_TICK_SECONDS
	var/mob/living/carbon/human/smoker = loc
	if(reagents.total_volume)
		var/puff = reagents.total_volume * min(ticks / max(smoketime, ticks), 1)
		if(istype(smoker) && smoker.wear_mouth == src)
			reagents.trans_to(smoker, puff, methods = INHALE)
		else
			reagents.remove_all(puff)
	smoketime -= ticks
	if(smoketime > 0)
		return
	smoketime = 0
	rogue_burnt_out()

/// A zig burns away; a pipe is left empty.
/obj/item/clothing/mask/cigarette/proc/rogue_burnt_out()
	if(ismob(loc))
		to_chat(loc, span_notice("[src] burns out."))
	qdel(src)

/obj/item/clothing/mask/cigarette/pipe
	smoketime = 120
	chem_volume = 100
	list_reagents = null

/obj/item/clothing/mask/cigarette/pipe/rogue_burnt_out()
	rogue_unlight(span_notice("[src] goes out."))
	name = "empty [initial(name)]"

/// Stuffing a burnt-out pipe with a leaf (Ratwood packs it with dried pipeweed): the leaf's own reagents go in.
/obj/item/clothing/mask/cigarette/pipe/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(smoketime > 0 || !istype(tool, /obj/item/reagent_containers/food/snacks/grown))
		return ..()
	to_chat(user, span_notice("I stuff [tool] into [src]."))
	tool.reagents?.trans_to(src, tool.reagents.total_volume)
	smoketime = initial(smoketime)
	name = initial(name)
	qdel(tool)
	return ITEM_INTERACT_SUCCESS
