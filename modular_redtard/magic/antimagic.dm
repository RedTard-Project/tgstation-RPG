/// Items that bind magic (Ratwood mageitems.dm and magic_items/superior_items/nomagic.dm, Vibelin mageitems.dm:418): worn,
/// the mana binding collar and gloves lock the wearer's mana away - no spell of theirs is cast (TRAIT_SPELLCOCKBLOCK,
/// Vibelin TRAIT_SPELLBLOCK) - and the wearer cannot take them off alone: the gloves not at all, the collar after a long
/// struggle; another may strip them. Vibelin's own gloves also turn spells aside (TG anti-magic in the gloves slot).
/// Medieval maps only: on modern maps they are plain clothes.

/datum/component/rogue_mana_binding
	/// The worn slots that bind (the item's own slot_flags).
	var/binding_slots = NONE
	/// The key of how long the wearer struggles to take it off alone (magic_antimagic_<key>_self_remove); 0 is never.
	var/remove_key
	var/mob/living/wearer
	/// The wearer is taking it off now.
	var/struggling = FALSE

/datum/component/rogue_mana_binding/Initialize(remove_key)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	var/obj/item/item = parent
	binding_slots = item.slot_flags
	src.remove_key = remove_key

/datum/component/rogue_mana_binding/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equipped))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_dropped))
	RegisterSignal(parent, COMSIG_ITEM_PRE_UNEQUIP, PROC_REF(on_pre_unequip))

/datum/component/rogue_mana_binding/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED, COMSIG_ITEM_PRE_UNEQUIP))
	release()

/datum/component/rogue_mana_binding/Destroy(force)
	release()
	return ..()

/datum/component/rogue_mana_binding/proc/on_equipped(obj/item/source, mob/equipper, slot)
	SIGNAL_HANDLER
	if(!(slot & binding_slots) || !isliving(equipper) || !rogue_magic_enabled())
		release()
		return
	wearer = equipper
	ADD_TRAIT(wearer, TRAIT_SPELLCOCKBLOCK, ROGUE_ANTIMAGIC_ITEM_TRAIT)
	to_chat(wearer, span_notice("I feel a draining sensation as my mana is locked away..."))

/datum/component/rogue_mana_binding/proc/on_dropped(obj/item/source, mob/user)
	SIGNAL_HANDLER
	release()

/datum/component/rogue_mana_binding/proc/release()
	if(!wearer)
		return
	var/mob/living/old_wearer = wearer
	wearer = null
	struggling = FALSE
	// Another binding item may still be worn.
	for(var/obj/item/worn as anything in old_wearer.get_equipped_items())
		if(worn == parent)
			continue
		var/datum/component/rogue_mana_binding/other = worn.GetComponent(/datum/component/rogue_mana_binding)
		if(other?.wearer == old_wearer)
			return
	REMOVE_TRAIT(old_wearer, TRAIT_SPELLCOCKBLOCK, ROGUE_ANTIMAGIC_ITEM_TRAIT)

/// Ratwood allow_self_unequip = FALSE and the collar's unequip_delay_self: the wearer's own hands do not take it off at once.
/datum/component/rogue_mana_binding/proc/on_pre_unequip(obj/item/source, force, atom/newloc, no_move, invdrop, silent)
	SIGNAL_HANDLER
	if(force || !wearer || usr != wearer || struggling)
		return NONE
	var/delay = remove_key ? rogue_value("magic_antimagic_[remove_key]_self_remove") : 0
	if(delay <= 0)
		to_chat(wearer, span_warning("[source] will not come off by my own hand!"))
		return COMPONENT_ITEM_BLOCK_UNEQUIP
	INVOKE_ASYNC(src, PROC_REF(struggle_off), delay)
	return COMPONENT_ITEM_BLOCK_UNEQUIP

/datum/component/rogue_mana_binding/proc/struggle_off(delay)
	var/mob/living/struggler = wearer
	var/obj/item/item = parent
	struggling = TRUE
	struggler.visible_message(span_notice("[struggler] struggles with [item]."), span_notice("I struggle to work [item] loose..."))
	if(!do_after(struggler, delay, target = struggler) || wearer != struggler)
		struggling = FALSE
		return
	struggler.dropItemToGround(item)

/obj/item/clothing/neck/roguetown/collar/leather/nomagic/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/rogue_mana_binding, "collar")

/obj/item/clothing/gloves/roguetown/nomagic/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/rogue_mana_binding, "gloves")

/obj/item/clothing/gloves/roguetown/vibelin/nomagic/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/rogue_mana_binding, "gloves")
	if(rogue_magic_enabled())
		AddComponent(/datum/component/anti_magic, MAGIC_RESISTANCE, INFINITY, ITEM_SLOT_GLOVES)
