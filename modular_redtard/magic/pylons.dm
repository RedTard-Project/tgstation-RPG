/// Vibelin's mana pylons (structures/mana_pylon.dm, the ley linker of items/mageitems.dm): a crystalline pylon holds a pool
/// that fills from the leylines near it; a ley linker binds it to another pylon, which it then keeps feeding (keeping the
/// reserve set with Alt-click), shown as a beam seen with the leyline sight. A gem attunes it: an attuned pylon feeds only
/// foci of the same gem and is drained by hand only by one carrying such a pool. A right click with an empty hand drains
/// it into the focus in hand or into oneself. Built by a craft recipe of the module (Vibelin builds it from a blueprint).

/// Every mana pylon there is (the sources the pools near them look for).
GLOBAL_LIST_EMPTY(rogue_mana_pylons)

/// The pylons within range of a turf that a pool of this attunement may draw on.
/proc/rogue_pylons_near(turf/here, range, attunement)
	RETURN_TYPE(/list)
	. = list()
	if(!here)
		return
	for(var/obj/structure/rogue_mana_pylon/pylon as anything in GLOB.rogue_mana_pylons)
		if(pylon.z != here.z || get_dist(here, pylon) > range)
			continue
		var/datum/rogue_mana/pool = rogue_mana_of(pylon)
		if(!pool || (pool.attunement && pool.attunement != attunement))
			continue
		. += pylon

/// Vibelin /datum/mana_pool/mana_pylon: starts empty and fills from the leylines; gives fast.
/datum/rogue_mana/pylon

/datum/rogue_mana/pylon/setup()
	capacity = rogue_value("magic_pylon_capacity")
	base_softcap = capacity
	donation_rate = rogue_value("magic_pylon_donation")
	rogue_mana_sources = ROGUE_MANA_LEYLINES

/obj/structure/rogue_mana_pylon
	name = "mana pylon"
	desc = "A crystalline pylon that channels and focuses mana."
	icon = 'modular_redtard/magic/icons/mana_pylon.dmi'
	icon_state = "pylon"
	density = TRUE
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	light_color = COLOR_CYAN
	var/obj/structure/rogue_mana_pylon/linked_pylon
	var/datum/beam/link_beam

/obj/structure/rogue_mana_pylon/Initialize(mapload)
	. = ..()
	GLOB.rogue_mana_pylons += src
	set_light(1.4, 1.4, COLOR_CYAN)
	update_appearance(UPDATE_OVERLAYS)
	if(rogue_magic_enabled())
		rogue_mana_of(src)
		rogue_wake_sourced_pools()

/obj/structure/rogue_mana_pylon/Destroy()
	if(linked_pylon)
		unlink_pylon()
	GLOB.rogue_mana_pylons -= src
	rogue_wake_sourced_pools()
	return ..()

/obj/structure/rogue_mana_pylon/rogue_mana_pool_type()
	return /datum/rogue_mana/pylon

/// The foci near this pylon look again whether it is in their reach (it was built, lost or attuned).
/obj/structure/rogue_mana_pylon/proc/rogue_wake_sourced_pools()
	for(var/datum/rogue_mana/waiting as anything in GLOB.rogue_mana_sourced_pools)
		if(!(waiting.rogue_mana_sources & ROGUE_MANA_PYLONS))
			continue
		var/turf/at = get_turf(waiting.holder)
		if(at?.z == z)
			waiting.recheck_sources()

/obj/structure/rogue_mana_pylon/update_overlays()
	. = ..()
	var/mutable_appearance/glow = mutable_appearance(icon, "pylon-glow")
	var/datum/component/rogue_mana_pool/held = GetComponent(/datum/component/rogue_mana_pool)
	if(held?.pool?.attunement)
		var/obj/item/gem = held.pool.attunement
		glow.color = initial(gem.color) || COLOR_CYAN
	. += glow

/obj/structure/rogue_mana_pylon/examine(mob/user)
	. = ..()
	if(linked_pylon)
		. += span_notice("It is bound to another pylon[linked_pylon.z != z ? ", carrying mana up or down" : ""].")

/// Vibelin attackby(): an attuned gem attunes the pylon.
/obj/structure/rogue_mana_pylon/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/roguegem) || !rogue_magic_enabled())
		return ..()
	var/datum/rogue_mana/pool = rogue_mana_of(src)
	if(!pool)
		return ..()
	user.visible_message(span_notice("[user] starts to attune [src]."), span_notice("I start to attune [src] to [tool]."))
	if(!do_after(user, rogue_value("magic_pylon_attune_time"), src) || QDELETED(pool))
		return ITEM_INTERACT_BLOCKING
	pool.attunement = tool.type
	update_appearance(UPDATE_OVERLAYS)
	rogue_wake_sourced_pools()
	return ITEM_INTERACT_SUCCESS

/// Vibelin AltClick(): the reserve the pylon keeps when it feeds its link.
/obj/structure/rogue_mana_pylon/click_alt(mob/user)
	var/datum/rogue_mana/pool = rogue_mana_of(src)
	if(!pool || !user.client)
		return CLICK_ACTION_BLOCKING
	var/reserve = tgui_input_number(user, "The least mana this pylon keeps when it feeds its link (now [round(pool.link_reserve)]):", "Pylon Reserve", round(pool.link_reserve), round(pool.capacity), 0)
	if(isnull(reserve) || QDELETED(pool))
		return CLICK_ACTION_BLOCKING
	pool.link_reserve = max(reserve, 0)
	pool.update_processing()
	balloon_alert(user, "reserve set: [round(pool.link_reserve)]")
	return CLICK_ACTION_SUCCESS

/obj/structure/rogue_mana_pylon/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || !rogue_magic_enabled() || !ishuman(user))
		return
	INVOKE_ASYNC(src, PROC_REF(drain_into), user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/// Vibelin drain_mana(): pull after pull while the drainer keeps at it, into the focus in the active hand or into oneself.
/obj/structure/rogue_mana_pylon/proc/drain_into(mob/living/carbon/human/user)
	var/datum/rogue_mana/pool = rogue_mana_of(src)
	if(!pool)
		return
	if(pool.attunement)
		var/same = FALSE
		for(var/atom/movable/thing as anything in user.get_all_contents())
			var/datum/component/rogue_mana_pool/held = thing.GetComponent(/datum/component/rogue_mana_pool)
			if(held?.pool?.attunement == pool.attunement)
				same = TRUE
				break
		if(!same)
			to_chat(user, span_warning("[src] is attuned to something I do not carry."))
			return
	var/datum/beam/drain_beam = user.Beam(src, icon_state = "drain_life", time = INFINITY)
	while(do_after(user, rogue_value("magic_pylon_drain_time"), src) && !QDELETED(pool))
		var/datum/rogue_mana/into = rogue_mana_of(user.get_active_held_item())
		if(!into?.holder || !into.holder.rogue_mana_cast_source())
			into = user.rogue_get_mana()
		if(!into || !pool.transfer_to(into, rogue_value("magic_pylon_drain"), safe = TRUE))
			break
	qdel(drain_beam)

/// Vibelin link_pylon(): this pylon keeps feeding the other one; across levels there is no beam, the glow turns red.
/obj/structure/rogue_mana_pylon/proc/link_pylon(obj/structure/rogue_mana_pylon/other)
	if(other == src || other.linked_pylon == src)
		return FALSE
	var/datum/rogue_mana/pool = rogue_mana_of(src)
	var/datum/rogue_mana/other_pool = rogue_mana_of(other)
	if(!pool || !other_pool)
		return FALSE
	if(linked_pylon)
		unlink_pylon()
	linked_pylon = other
	RegisterSignal(other, COMSIG_QDELETING, PROC_REF(on_linked_deleted))
	if(other.z == z)
		link_beam = Beam(other, icon_state = "medbeam", time = INFINITY, beam_type = /obj/effect/ebeam/rogue_leyline, override_origin_pixel_y = 32, override_target_pixel_y = 32)
	pool.link_to(other_pool, pool.link_reserve)
	return TRUE

/obj/structure/rogue_mana_pylon/proc/unlink_pylon()
	if(linked_pylon)
		UnregisterSignal(linked_pylon, COMSIG_QDELETING)
	QDEL_NULL(link_beam)
	linked_pylon = null
	var/datum/component/rogue_mana_pool/held = GetComponent(/datum/component/rogue_mana_pool)
	held?.pool?.unlink()

/obj/structure/rogue_mana_pylon/proc/on_linked_deleted(datum/source)
	SIGNAL_HANDLER
	unlink_pylon()

/// Vibelin's ley linker: the first pylon touched is the source, the second the one it feeds; a right click on a pylon
/// breaks its link, anywhere else forgets the source.
/obj/item/rogue_ley_linker
	name = "ley linker"
	desc = "A mystical tool used to bind mana pylons together, allowing mana to flow between them."
	icon = 'modular_redtard/rockhill/icons/roguetown/items/misc.dmi'
	icon_state = "dbrush"
	w_class = WEIGHT_CLASS_SMALL
	/// The source pylon chosen by the first touch; weak, so a pylon broken meanwhile is not held.
	var/datum/weakref/source_ref

/obj/item/rogue_ley_linker/Destroy()
	source_ref = null
	return ..()

/obj/item/rogue_ley_linker/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!istype(interacting_with, /obj/structure/rogue_mana_pylon) || !rogue_magic_enabled())
		return NONE
	var/obj/structure/rogue_mana_pylon/pylon = interacting_with
	var/obj/structure/rogue_mana_pylon/source_pylon = source_ref?.resolve()
	if(QDELETED(source_pylon))
		source_ref = WEAKREF(pylon)
		user.balloon_alert(user, "source set")
		return ITEM_INTERACT_SUCCESS
	if(source_pylon == pylon)
		user.balloon_alert(user, "can't link to itself!")
		return ITEM_INTERACT_BLOCKING
	if(source_pylon.link_pylon(pylon))
		user.balloon_alert(user, "pylons linked!")
	else
		user.balloon_alert(user, "they will not bind!")
	source_ref = null
	return ITEM_INTERACT_SUCCESS

/obj/item/rogue_ley_linker/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	if(!rogue_magic_enabled())
		return NONE
	if(!istype(interacting_with, /obj/structure/rogue_mana_pylon))
		if(source_ref)
			source_ref = null
			user.balloon_alert(user, "source cleared!")
			return ITEM_INTERACT_SUCCESS
		return NONE
	var/obj/structure/rogue_mana_pylon/pylon = interacting_with
	if(!pylon.linked_pylon)
		user.balloon_alert(user, "not linked!")
		return ITEM_INTERACT_BLOCKING
	pylon.unlink_pylon()
	user.balloon_alert(user, "link broken!")
	return ITEM_INTERACT_SUCCESS

/datum/crafting_recipe/roguetown/structure/rogue_mana_pylon
	name = "mana pylon"
	result = /obj/structure/rogue_mana_pylon
	reqs = list(/obj/item/natural/stone = 2, /obj/item/roguegem/amethyst = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_verb = "weaves"
	rogue_verb_simple = "weave"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/rogue_mana_pylon/New()
	. = ..()
	rogue_difficulty = rogue_value("magic_pylon_craft_difficulty")

/datum/crafting_recipe/roguetown/arcana/rogue_ley_linker
	name = "ley linker"
	result = /obj/item/rogue_ley_linker
	reqs = list(/obj/item/grown/log/tree/stick = 1, /obj/item/magic/leyline = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/rogue_ley_linker/New()
	. = ..()
	rogue_difficulty = rogue_value("magic_linker_craft_difficulty")
