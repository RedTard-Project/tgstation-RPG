/// The pool of an item or a structure (Vibelin /atom/movable var mana_pool, has_initial_mana_pool): a component, so things
/// without mana pay nothing. rogue_mana_of() adds it the first time a thing's pool is asked for, when the thing's type names
/// one (rogue_mana_pool_type()); a person keeps their own var instead (magic/mana.dm).
/datum/component/rogue_mana_pool
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/datum/rogue_mana/pool

/datum/component/rogue_mana_pool/Initialize(pool_type = /datum/rogue_mana)
	if(!ismovable(parent) || !ispath(pool_type, /datum/rogue_mana))
		return COMPONENT_INCOMPATIBLE
	pool = new pool_type(parent)

/datum/component/rogue_mana_pool/Destroy(force)
	QDEL_NULL(pool)
	return ..()

/datum/component/rogue_mana_pool/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/component/rogue_mana_pool/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ATOM_EXAMINE)

/// One who knows the arcyne reads how full it is; anyone else only sees whether it glows.
/datum/component/rogue_mana_pool/proc/on_examine(atom/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(!pool)
		return
	if(isliving(user))
		var/mob/living/viewer = user
		if(HAS_TRAIT(viewer, TRAIT_ARCYNE) || viewer.rogue_magic_rank(/datum/attribute/skill/magic/arcane) > 0)
			examine_list += span_info("It holds [round(pool.amount)]/[round(pool.capacity)] mana.")
			if(pool.attunement)
				var/obj/item/gem = pool.attunement
				examine_list += span_info("It is attuned to [initial(gem.name)].")
			return
	examine_list += span_info((pool.amount > 0 ? "It glows faintly." : "It looks dull."))

/// The person drawing mana out of a pool held in their hand (Vibelin mana_battery attack_self()): how much, up to what it
/// holds; it may pass the person's soft cap, and what is past it bleeds away again.
/proc/rogue_mana_draw_by_hand(obj/item/source, mob/living/carbon/human/user)
	var/datum/rogue_mana/from = rogue_mana_of(source)
	var/datum/rogue_mana/into = ishuman(user) ? user.rogue_get_mana() : null
	if(!from || !into || !user.is_holding(source))
		return FALSE
	if(from.amount <= 0)
		to_chat(user, span_warning("[source] holds no mana."))
		return TRUE
	var/wanted = tgui_input_number(user, "How much mana to draw from [source]? Soft cap (past it mana bleeds away): [round(into.softcap())].", "Draw Mana", round(min(from.amount, max(into.softcap() - into.amount, 0))), round(from.amount), 0)
	if(!wanted || QDELETED(user) || QDELETED(source) || QDELETED(from) || QDELETED(into) || !user.is_holding(source))
		return TRUE
	var/moved = from.transfer_to(into, wanted)
	to_chat(user, span_notice("I draw [round(moved)] mana from [source]."))
	return TRUE

/// The person sending their own mana into a pool held in their hand (Vibelin mana_battery attack_hand_secondary()).
/proc/rogue_mana_send_by_hand(obj/item/source, mob/living/carbon/human/user)
	var/datum/rogue_mana/into = rogue_mana_of(source)
	var/datum/rogue_mana/from = ishuman(user) ? user.rogue_get_mana() : null
	if(!from || !into || !user.is_holding(source))
		return FALSE
	var/room = into.capacity - into.amount
	if(room <= 0)
		to_chat(user, span_warning("[source] is full."))
		return TRUE
	var/wanted = tgui_input_number(user, "How much mana to send into [source]? It holds [round(into.amount)]/[round(into.capacity)].", "Send Mana", round(min(room, from.amount)), round(min(room, from.amount)), 0)
	if(!wanted || QDELETED(user) || QDELETED(source) || QDELETED(from) || QDELETED(into) || !user.is_holding(source))
		return TRUE
	var/moved = from.transfer_to(into, wanted)
	to_chat(user, span_notice("I send [round(moved)] mana into [source]."))
	return TRUE

// ---------------------------------------------------------------------------------------------------------------------------
// The mana fountain (Ratwood's /obj/structure/well/fountain/mana, five on Rockhill; Vibelin structures/mage_structures.dm).

/// Vibelin /datum/mana_pool/mana_fountain: a big pool that slowly fills by itself; every mouthful drunk from the fountain
/// (survival/thirst.dm) is liquid mana taken out of it.
/datum/rogue_mana/fountain

/datum/rogue_mana/fountain/setup()
	capacity = rogue_value("magic_fountain_capacity")
	base_softcap = capacity
	regen = rogue_value("magic_fountain_regen")
	amount = min(rogue_value("magic_fountain_start"), capacity)

/obj/structure/well/fountain/mana/rogue_mana_pool_type()
	return /datum/rogue_mana/fountain

/// The mana a mouthful of the fountain is: what the drinker's pool gets and the fountain's pool loses.
/obj/structure/well/fountain/mana/proc/rogue_mouthful_mana()
	return rogue_value("drink_mana_sip") * rogue_value("magic_liquid_mana_per_unit")

/// Liquid mana (Vibelin's weak mana potion of the fountain): swallowed, it goes into the drinker's pool, up to the soft
/// cap; it gives nothing else. Alchemy may brew it too.
/datum/reagent/rogue_liquid_mana
	name = "liquid mana"
	description = "Mana dissolved in water. It tingles going down."
	color = "#3a6cd8"
	taste_description = "tingling"

/datum/reagent/rogue_liquid_mana/expose_mob(mob/living/exposed_mob, methods = TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	if(!(methods & INGEST) || !ishuman(exposed_mob) || reac_volume <= 0)
		return
	var/mob/living/carbon/human/drinker = exposed_mob
	drinker.rogue_restore_mana(reac_volume * rogue_value("magic_liquid_mana_per_unit"))
