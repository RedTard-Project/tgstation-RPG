/datum/rogue_strike
	var/mob/living/attacker
	var/mob/living/target
	var/obj/item/weapon
	var/datum/intent/intent
	var/kind = ROGUE_STRIKE_MELEE
	var/list/attack_modifiers
	var/zone
	var/damage = 0
	var/damage_done = 0
	var/defended = FALSE
	var/paired = FALSE

/datum/rogue_strike/New(mob/living/attacker, mob/living/target, obj/item/weapon, datum/intent/intent, kind = ROGUE_STRIKE_MELEE, list/attack_modifiers)
	src.attacker = attacker
	src.target = target
	src.weapon = weapon
	src.intent = intent
	src.kind = kind
	src.attack_modifiers = attack_modifiers

/datum/rogue_strike/Destroy(force)
	attacker = null
	target = null
	weapon = null
	intent = null
	attack_modifiers = null
	return ..()

/datum/rogue_strike/proc/incoming()
	return SEND_SIGNAL(target, COMSIG_ROGUE_STRIKE_INCOMING, src)

/datum/element/rogue_combat
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

/datum/element/rogue_combat/Attach(datum/target)
	. = ..()
	if(!ishuman(target))
		return ELEMENT_INCOMPATIBLE
	var/mob/living/carbon/human/fighter = target
	RegisterSignal(fighter, COMSIG_USER_PRE_ITEM_ATTACK, PROC_REF(on_pre_item_attack))
	RegisterSignal(fighter, COMSIG_LIVING_CHECK_BLOCK, PROC_REF(on_check_block))
	RegisterSignal(fighter, COMSIG_MOB_APPLY_DAMAGE_MODIFIERS, PROC_REF(on_damage_modifiers))
	RegisterSignal(fighter, COMSIG_MOB_CLICKON, PROC_REF(on_click))
	RegisterSignal(fighter, COMSIG_MOB_MIDDLECLICKON, PROC_REF(on_middle_click))
	RegisterSignal(fighter, COMSIG_LIVING_START_PULL, PROC_REF(on_start_pull))
	RegisterSignal(fighter, COMSIG_ATOM_NO_LONGER_PULLING, PROC_REF(on_stop_pull))
	RegisterSignal(fighter, COMSIG_MOVABLE_SET_GRAB_STATE, PROC_REF(on_grab_state))
	RegisterSignal(fighter, COMSIG_MOB_SWAP_HANDS, PROC_REF(on_swap_hands))
	RegisterSignal(fighter, COMSIG_ATOM_BULLET_ACT, PROC_REF(on_shot))
	RegisterSignal(fighter, COMSIG_LIVING_SET_BODY_POSITION, PROC_REF(on_body_position))
	RegisterSignal(fighter, COMSIG_MOB_CLIENT_LOGIN, PROC_REF(on_client_login))
	RegisterSignal(fighter, COMSIG_MOB_LOGOUT, PROC_REF(on_logout))
	RegisterSignal(fighter, COMSIG_COMBAT_MODE_TOGGLED, PROC_REF(on_combat_mode))
	RegisterSignal(fighter, COMSIG_ATOM_PREHITBY, PROC_REF(on_pre_hitby))
	RegisterSignal(fighter, COMSIG_MOB_EQUIPPED_ITEM, PROC_REF(on_gear_equipped))
	RegisterSignal(fighter, COMSIG_MOB_UNEQUIPPED_ITEM, PROC_REF(on_gear_unequipped))
	RegisterSignals(fighter, list(COMSIG_CARBON_GAIN_ORGAN, COMSIG_CARBON_LOSE_ORGAN), PROC_REF(on_organ_change))
	if(fighter.client)
		on_client_login(fighter, fighter.client)
	fighter.rogue_enable_cursors(TRUE)

/datum/element/rogue_combat/Detach(mob/living/carbon/human/source)
	UnregisterSignal(source, list(
		COMSIG_USER_PRE_ITEM_ATTACK,
		COMSIG_LIVING_CHECK_BLOCK,
		COMSIG_MOB_APPLY_DAMAGE_MODIFIERS,
		COMSIG_MOB_CLICKON,
		COMSIG_MOB_MIDDLECLICKON,
		COMSIG_LIVING_START_PULL,
		COMSIG_ATOM_NO_LONGER_PULLING,
		COMSIG_MOVABLE_SET_GRAB_STATE,
		COMSIG_MOB_SWAP_HANDS,
		COMSIG_ATOM_BULLET_ACT,
		COMSIG_LIVING_SET_BODY_POSITION,
		COMSIG_MOB_CLIENT_LOGIN,
		COMSIG_MOB_LOGOUT,
		COMSIG_COMBAT_MODE_TOGGLED,
		COMSIG_ATOM_PREHITBY,
		COMSIG_MOB_EQUIPPED_ITEM,
		COMSIG_MOB_UNEQUIPPED_ITEM,
		COMSIG_CARBON_GAIN_ORGAN,
		COMSIG_CARBON_LOSE_ORGAN,
		COMSIG_MOVABLE_MOVED,
	))
	if(source.canon_client)
		UnregisterSignal(source.canon_client, list(COMSIG_CLIENT_MOUSEDOWN, COMSIG_CLIENT_MOUSEUP))
	source.rogue_enable_cursors(FALSE)
	return ..()

/// Headgear and masks change the field of view (combat/fov.dm); something that can slip out of the mouth starts the
/// per-step check while it is there (clothing/mouth.dm).
/datum/element/rogue_combat/proc/on_gear_equipped(mob/living/carbon/human/source, obj/item/worn, slot)
	SIGNAL_HANDLER
	var/obj/item/clothing/garment = worn
	if(istype(garment) && garment.block2add)
		source.rogue_update_fov()
	if((slot & ITEM_SLOT_ROGUE_MOUTH) && worn.spitoutmouth)
		RegisterSignal(source, COMSIG_MOVABLE_MOVED, PROC_REF(on_mouth_step), override = TRUE)

/// The item being taken off still sits in its slot while this runs.
/datum/element/rogue_combat/proc/on_gear_unequipped(mob/living/carbon/human/source, obj/item/worn)
	SIGNAL_HANDLER
	var/obj/item/clothing/garment = worn
	if(istype(garment) && garment.block2add)
		source.rogue_update_fov(garment)
	if(worn == source.wear_mouth)
		UnregisterSignal(source, COMSIG_MOVABLE_MOVED)

/datum/element/rogue_combat/proc/on_swap_hands(mob/living/carbon/human/source)
	SIGNAL_HANDLER
	SEND_SIGNAL(source, COMSIG_ROGUE_MANOEUVRE, ROGUE_MANOEUVRE_SWAP_HANDS)

/datum/element/rogue_combat/proc/on_shot(mob/living/carbon/human/source, obj/projectile/shot)
	SIGNAL_HANDLER
	SEND_SIGNAL(source, COMSIG_ROGUE_MANOEUVRE, ROGUE_MANOEUVRE_SHOT)

/datum/element/rogue_combat/proc/on_body_position(mob/living/carbon/human/source, new_position, old_position)
	SIGNAL_HANDLER
	if(new_position == LYING_DOWN)
		SEND_SIGNAL(source, COMSIG_ROGUE_MANOEUVRE, ROGUE_MANOEUVRE_FALL)
		if(!source.resting)
			source.rogue_spit_out()

/datum/element/rogue_combat/proc/on_combat_mode(mob/living/carbon/human/source)
	SIGNAL_HANDLER
	if(!source.combat_mode)
		source.rogue_left_combat_mode()

/datum/element/rogue_combat/proc/on_client_login(mob/living/carbon/human/source, client/new_client)
	SIGNAL_HANDLER
	RegisterSignal(new_client, COMSIG_CLIENT_MOUSEDOWN, PROC_REF(on_mouse_down), override = TRUE)
	RegisterSignal(new_client, COMSIG_CLIENT_MOUSEUP, PROC_REF(on_mouse_up), override = TRUE)

/datum/element/rogue_combat/proc/on_logout(mob/living/carbon/human/source)
	SIGNAL_HANDLER
	if(source.canon_client)
		UnregisterSignal(source.canon_client, list(COMSIG_CLIENT_MOUSEDOWN, COMSIG_CLIENT_MOUSEUP))

/datum/element/rogue_weapon
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

/datum/element/rogue_weapon/Attach(datum/target)
	. = ..()
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_ITEM_ATTACK, PROC_REF(on_attack))
	RegisterSignal(target, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equipped))
	RegisterSignal(target, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(target, COMSIG_ITEM_ATTACK_SELF_SECONDARY, PROC_REF(on_attack_self_secondary))
	RegisterSignal(target, COMSIG_ITEM_DROPPED, PROC_REF(on_dropped))

/datum/element/rogue_weapon/Detach(datum/source)
	UnregisterSignal(source, list(COMSIG_ITEM_ATTACK, COMSIG_ITEM_EQUIPPED, COMSIG_ATOM_EXAMINE, COMSIG_ITEM_ATTACK_SELF_SECONDARY, COMSIG_ITEM_DROPPED))
	return ..()

/datum/element/rogue_whetstone
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

/datum/element/rogue_whetstone/Attach(datum/target)
	. = ..()
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_ITEM_INTERACTING_WITH_ATOM, PROC_REF(on_interact))

/datum/element/rogue_whetstone/Detach(datum/source)
	UnregisterSignal(source, COMSIG_ITEM_INTERACTING_WITH_ATOM)
	return ..()
