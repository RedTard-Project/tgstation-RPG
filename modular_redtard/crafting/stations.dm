#define TANNING_STAKE_SOUND 'modular_redtard/rockhill/sound/foley/woodclimb.ogg'
#define TANNING_SCRAPE_SOUNDS list('modular_redtard/rockhill/sound/items/book_open.ogg', 'modular_redtard/rockhill/sound/items/book_page.ogg')
#define TANNING_ESSENCE_SOUND 'modular_redtard/rockhill/sound/items/gem.ogg'

/// Ratwood drying rack (roguejobs/tailor/tanning.dm): a raw hide is hung on it and scraped with a cutting edge into
/// cured leather - more pieces and a chance of an essence of wilderness with skincrafting. A wooden stake frees it to move.
/obj/machinery/tanningrack
	max_integrity = 200
	interaction_flags_atom = NONE
	/// The hide hung on the rack.
	var/obj/item/natural/hide/hung_hide

/obj/machinery/tanningrack/Destroy()
	if(hung_hide)
		hung_hide.forceMove(drop_location())
	return ..()

/obj/machinery/tanningrack/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == hung_hide)
		hung_hide = null
		update_appearance(UPDATE_OVERLAYS)

/obj/machinery/tanningrack/examine(mob/user)
	. = ..()
	if(hung_hide)
		. += span_warning("There is a piece of hide ready to be worked. I might need a knife for this.")
	if(!anchored)
		. += span_warning("It is un-anchored and able to be moved.")

/obj/machinery/tanningrack/update_overlays()
	. = ..()
	if(!hung_hide)
		return
	var/mutable_appearance/shown = new(hung_hide)
	shown.plane = FLOAT_PLANE
	shown.layer = FLOAT_LAYER
	shown.pixel_w = 0
	shown.pixel_z = 0
	. += shown

/obj/machinery/tanningrack/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(. || !hung_hide)
		return
	var/obj/item/taken = hung_hide
	taken.forceMove(drop_location())
	user.put_in_active_hand(taken)
	return TRUE

/obj/machinery/tanningrack/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/natural/hide) && !istype(tool, /obj/item/natural/hide/cured))
		if(hung_hide)
			to_chat(user, span_warning("The rack is already occupied!"))
			return ITEM_INTERACT_BLOCKING
		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING
		hung_hide = tool
		update_appearance(UPDATE_OVERLAYS)
		return ITEM_INTERACT_SUCCESS
	if(istype(tool, /obj/item/grown/log/tree/stake))
		set_anchored(!anchored)
		to_chat(user, span_warning((anchored ? "You anchor [src]." : "The [src] can now be moved.")))
		playsound(src, TANNING_STAKE_SOUND, 100, TRUE)
		return ITEM_INTERACT_SUCCESS
	if(hung_hide && (tool.get_sharpness() & SHARP_EDGED))
		if(!anchored)
			to_chat(user, span_warning("I need to anchor this down with a wooden stake before I can work this hide."))
			return ITEM_INTERACT_BLOCKING
		INVOKE_ASYNC(src, PROC_REF(scrape), user)
		return ITEM_INTERACT_SUCCESS
	return ..()

/// Ratwood: 12 seconds less 1.5 per skincrafting rank, 1 to rank + 1 pieces (at most 6).
/obj/machinery/tanningrack/proc/scrape(mob/living/user)
	if(DOING_INTERACTION_WITH_TARGET(user, src))
		return
	var/rank = user.rogue_skill_rank(/datum/attribute/skill/craft/tanning)
	to_chat(user, span_warning("I begin scraping the hide's skin..."))
	if(!do_after(user, 12 SECONDS - rank * 1.5 SECONDS, target = src) || !hung_hide)
		return
	playsound(src, pick(TANNING_SCRAPE_SOUNDS), 100, FALSE)
	QDEL_NULL(hung_hide)
	update_appearance(UPDATE_OVERLAYS)
	user.rogue_craft_experience(/datum/attribute/skill/craft/tanning, user.rogue_stat(ROGUE_STAT_INTELLIGENCE) * 2)
	var/static/list/essence_by_rank = list(1, 2, 3, 6, 8, 10)
	var/essence_chance = rank ? essence_by_rank[rank] : 1
	var/turf/here = get_turf(user)
	var/blessed = FALSE
	for(var/piece in 1 to rand(1, min(rank + 1, 6)))
		if(prob(essence_chance + (user.rogue_goodluck(2) ? 1 : 0)))
			new /obj/item/natural/cured/essence(here)
			if(!blessed)
				blessed = TRUE
				to_chat(user, span_warning("Dendor provides..."))
				playsound(src, TANNING_ESSENCE_SOUND, 100, FALSE)
		new /obj/item/natural/hide/cured(here)

/// Ratwood loom (roguejobs/tailor/loom.dm): fibers are strung on (up to 50), a hand weaves cloth from two of them
/// (one for an efficient weaver), 2 seconds less 0.2 per sewing rank; right click takes a strand back.
/obj/machinery/loom
	max_integrity = 200
	interaction_flags_atom = NONE
	var/storedfiber = 0
	var/maxfiber = 50

/obj/machinery/loom/examine(mob/user)
	. = ..()
	. += span_notice("There are [storedfiber] strands of fiber strung on [src].")

/obj/machinery/loom/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/natural/bundle/fibers))
		var/strands = istype(tool, /obj/item/natural/bundle/fibers/full) ? 6 : 2
		var/strung = min(strands, maxfiber - storedfiber)
		if(strung <= 0)
			to_chat(user, "You can't add any more fiber.")
			return ITEM_INTERACT_BLOCKING
		storedfiber += strung
		to_chat(user, "You string some fiber onto [src].")
		qdel(tool)
		for(var/leftover in 1 to strands - strung)
			new /obj/item/natural/fibers(drop_location())
		return ITEM_INTERACT_SUCCESS
	if(istype(tool, /obj/item/natural/fibers))
		if(storedfiber >= maxfiber)
			to_chat(user, "You can't add any more fiber.")
			return ITEM_INTERACT_BLOCKING
		storedfiber++
		to_chat(user, "You string a fiber onto [src].")
		qdel(tool)
		return ITEM_INTERACT_SUCCESS
	return ..()

/obj/machinery/loom/attack_hand_secondary(mob/living/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || user.stat != STABLE)
		return
	if(storedfiber <= 0)
		to_chat(user, "There's nothing to take from [src].")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	to_chat(user, "You remove a strand from [src].")
	storedfiber--
	user.put_in_hands(new /obj/item/natural/fibers(drop_location()))
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/loom/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(. || user.stat != STABLE)
		return
	INVOKE_ASYNC(src, PROC_REF(weave), user)
	return TRUE

/obj/machinery/loom/proc/weave(mob/living/user)
	if(DOING_INTERACTION_WITH_TARGET(user, src))
		return
	var/required = HAS_TRAIT(user, TRAIT_EFFICIENT_WEAVER) ? 1 : 2
	if(storedfiber < required)
		to_chat(user, "You don't have enough fiber to do this.")
		return
	to_chat(user, "You start weaving some cloth[required == 1 ? " with practiced hands" : ""]...")
	while(storedfiber >= required)
		var/rank = user.rogue_skill_rank(/datum/attribute/skill/craft/sewing)
		if(!do_after(user, 2 SECONDS - rank * 0.2 SECONDS, target = src) || storedfiber < required)
			return
		storedfiber -= required
		new /obj/item/natural/cloth(drop_location())
		user.rogue_craft_experience(/datum/attribute/skill/craft/sewing, user.rogue_stat(ROGUE_STAT_INTELLIGENCE) * 0.5)

#undef TANNING_STAKE_SOUND
#undef TANNING_SCRAPE_SOUNDS
#undef TANNING_ESSENCE_SOUND
