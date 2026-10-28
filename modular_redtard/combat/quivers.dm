#define ROGUE_QUIVER_TIME rogue_value("launcher_quiver_time")

/// Ratwood's quivers, javelin bags and pouches (modular_azurepeak quiver.dm; the porter grafts /obj/item/quiver onto this and
/// carries max_storage and what each one is filled with). It holds up to max_storage rounds of its kind. A bow (a sling for
/// the pouch) clicked on it nocks the first round that fits, crossbows are loaded by hand; the right button takes the last
/// round into the hand; used in hand it is emptied round by round onto the floor; clicked on the floor it gathers the
/// rounds lying there.
/obj/item/rogue_quiver
	name = "quiver"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/weapons/ammo.dmi'
	icon_state = "quiver0"
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FIRE_PROOF
	/// How many rounds it holds (Ratwood max_storage).
	var/max_storage = 20
	/// What it is filled with when made (Ratwood Initialize()), max_storage of them.
	var/rogue_quiver_fill
	/// What it holds, and the kind among those it does not.
	var/rogue_quiver_holds = /obj/item/ammo_casing/caseless/rogue
	var/rogue_quiver_refuses = /obj/item/ammo_casing/caseless/rogue/javelin
	/// The launcher that nocks straight from it.
	var/rogue_quiver_nocks = /obj/item/gun/ballistic/rogue_launcher/bow
	/// Sprite name of the full and empty states ("quiver" -> quiver1, quiver0); none keeps the sprite.
	var/rogue_quiver_state = "quiver"

/obj/item/rogue_quiver/Initialize(mapload)
	. = ..()
	if(ispath(rogue_quiver_fill))
		for(var/i in 1 to max_storage)
			new rogue_quiver_fill(src)
	update_appearance()

/obj/item/rogue_quiver/Destroy()
	for(var/atom/movable/round as anything in contents)
		qdel(round)
	return ..()

/obj/item/rogue_quiver/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	update_appearance()

/obj/item/rogue_quiver/Exited(atom/movable/gone, direction)
	. = ..()
	if(!QDELETED(src))
		update_appearance()

/obj/item/rogue_quiver/update_icon_state()
	. = ..()
	if(rogue_quiver_state)
		icon_state = "[rogue_quiver_state][length(contents) ? 1 : 0]"

/obj/item/rogue_quiver/examine(mob/user)
	. = ..()
	if(length(contents))
		. += span_notice("[length(contents)] inside.")
	. += span_notice("Click on the ground to pick up ammos on the floor.")

/obj/item/rogue_quiver/proc/rogue_holds(atom/movable/thing)
	return istype(thing, rogue_quiver_holds) && !(rogue_quiver_refuses && istype(thing, rogue_quiver_refuses))

/obj/item/rogue_quiver/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(rogue_quiver_refuses && istype(tool, rogue_quiver_refuses))
		to_chat(user, span_warning("Javelins are too big to fit in a quiver, silly!"))
		return ITEM_INTERACT_BLOCKING
	if(rogue_holds(tool))
		if(length(contents) >= max_storage)
			to_chat(user, span_warning("Full!"))
			return ITEM_INTERACT_BLOCKING
		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING
		return ITEM_INTERACT_SUCCESS
	if(rogue_quiver_nocks && istype(tool, rogue_quiver_nocks))
		rogue_nock(tool, user)
		return ITEM_INTERACT_SUCCESS
	return NONE

/// Nocks the first round that fits the empty launcher (Ratwood: the quiver loads the bow itself).
/obj/item/rogue_quiver/proc/rogue_nock(obj/item/gun/ballistic/launcher, mob/living/user)
	if(launcher.chambered || !launcher.magazine)
		return
	for(var/obj/item/ammo_casing/round in contents)
		if(!launcher.magazine.is_compatible_round(round))
			continue
		if(launcher.load_gun(round, user) && HAS_TRAIT(user, TRAIT_COMBAT_AWARE))
			user.balloon_alert(user, "[length(contents)] left...")
		return

/obj/item/rogue_quiver/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || !length(contents))
		return
	var/obj/item/round = contents[length(contents)]
	round.forceMove(user.drop_location())
	user.put_in_hands(round)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/rogue_quiver/attack_self(mob/user, modifiers)
	. = ..()
	if(. || !length(contents))
		return
	INVOKE_ASYNC(src, PROC_REF(rogue_empty), user)
	return TRUE

/obj/item/rogue_quiver/proc/rogue_empty(mob/living/user)
	to_chat(user, span_warning("I begin to take out the arrows from [src], one by one..."))
	for(var/obj/item/round in contents)
		if(!do_after(user, ROGUE_QUIVER_TIME, target = src))
			return
		if(round.loc == src)
			round.forceMove(user.drop_location())

/obj/item/rogue_quiver/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/turf/spot = isturf(interacting_with) ? interacting_with : null
	if(!spot && rogue_holds(interacting_with) && isturf(interacting_with.loc))
		spot = interacting_with.loc
	if(!spot)
		return NONE
	if(length(contents) >= max_storage)
		to_chat(user, span_warning("My [name] is full!"))
		return ITEM_INTERACT_BLOCKING
	INVOKE_ASYNC(src, PROC_REF(rogue_gather), spot, user)
	return ITEM_INTERACT_SUCCESS

/obj/item/rogue_quiver/proc/rogue_gather(turf/spot, mob/living/user)
	to_chat(user, span_notice("I begin to gather the ammunition..."))
	for(var/obj/item/round in spot)
		if(!rogue_holds(round))
			continue
		if(length(contents) >= max_storage || !do_after(user, ROGUE_QUIVER_TIME, target = spot))
			return
		if(!QDELETED(round) && round.loc == spot)
			round.forceMove(src)

// What each kind of Ratwood's quivers holds (quiver.dm, firearm_ammo.dm).

/obj/item/quiver/javelin
	rogue_quiver_holds = /obj/item/ammo_casing/caseless/rogue/javelin
	rogue_quiver_refuses = null
	rogue_quiver_nocks = null
	rogue_quiver_state = "javelinbag"

/obj/item/quiver/sling
	rogue_quiver_holds = /obj/item/ammo_casing/caseless/rogue/sling_bullet
	rogue_quiver_refuses = null
	rogue_quiver_nocks = /obj/item/gun/ballistic/rogue_launcher/sling
	rogue_quiver_state = null

/obj/item/quiver/bullet
	rogue_quiver_holds = /obj/item/ammo_casing/caseless/bullet
	rogue_quiver_refuses = null
	rogue_quiver_nocks = null
	rogue_quiver_state = null

/obj/item/quiver/zigs
	rogue_quiver_holds = /obj/item/clothing/mask/cigarette/rollie
	rogue_quiver_refuses = null
	rogue_quiver_nocks = null
	rogue_quiver_state = null

#undef ROGUE_QUIVER_TIME
