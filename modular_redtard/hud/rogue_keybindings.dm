/// Medieval controls laid out as Ratwood has them by default (code/datums/keybinding of Ratwood): intents on 1-4, stances on
/// Shift+1-6 and N, middle-click intents on H J K L, guard on G, combat mode on C and parry or dodge on Shift+C, hands on
/// Q and E, drop on Z, resist on X, lie down on V, fixed gaze on F, look up on Shift+F, run held on Alt, standing still on
/// Ctrl, the bags on the back on Shift+Q and Shift+E, the hips on Alt+Q and Alt+E, the belt on Shift+B, action buttons on
/// Alt+1-9. They work only with the medieval HUD; the TG bindings that share their keys stand down there (bottom of the file).
/datum/keybinding/rogue
	category = CATEGORY_ROGUE
	weight = WEIGHT_MOB
	hotkey_keys = list(UNBOUND_KEY)

/datum/keybinding/rogue/can_use(client/user)
	return rogue_layout_active(user)

/datum/keybinding/rogue/intent
	var/slot = 1

/datum/keybinding/rogue/intent/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/owner = user.mob
	owner.rogue_select_intent(slot)
	return TRUE

/datum/keybinding/rogue/intent/first
	name = "rogue_intent_1"
	hotkey_keys = list("1")
	full_name = "Intent 1"
	description = "Pick the first intent of the active hand, weapon or fist (top left cell)"
	keybind_signal = COMSIG_KB_ROGUE_INTENT_1_DOWN
	slot = 1

/datum/keybinding/rogue/intent/second
	name = "rogue_intent_2"
	hotkey_keys = list("2")
	full_name = "Intent 2"
	description = "Pick the second intent of the active hand (top right cell)"
	keybind_signal = COMSIG_KB_ROGUE_INTENT_2_DOWN
	slot = 2

/datum/keybinding/rogue/intent/third
	name = "rogue_intent_3"
	hotkey_keys = list("3")
	full_name = "Intent 3"
	description = "Pick the third intent of the active hand (bottom left cell)"
	keybind_signal = COMSIG_KB_ROGUE_INTENT_3_DOWN
	slot = 3

/datum/keybinding/rogue/intent/fourth
	name = "rogue_intent_4"
	hotkey_keys = list("4")
	full_name = "Intent 4"
	description = "Pick the fourth intent of the active hand (bottom right cell)"
	keybind_signal = COMSIG_KB_ROGUE_INTENT_4_DOWN
	slot = 4

/datum/keybinding/rogue/alt_intent
	var/intent_type

/datum/keybinding/rogue/alt_intent/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/owner = user.mob
	owner.rogue_select_rmb_intent(intent_type)
	return TRUE

/datum/keybinding/rogue/alt_intent/strong
	name = "rogue_alt_strong"
	hotkey_keys = list("Shift3")
	full_name = "Alt intent: strong"
	description = "Pick the strong alt intent"
	keybind_signal = COMSIG_KB_ROGUE_ALT_STRONG_DOWN
	intent_type = /datum/rogue_rmb_intent/strong

/datum/keybinding/rogue/alt_intent/swift
	name = "rogue_alt_swift"
	hotkey_keys = list("Shift4")
	full_name = "Alt intent: swift"
	description = "Pick the swift alt intent"
	keybind_signal = COMSIG_KB_ROGUE_ALT_SWIFT_DOWN
	intent_type = /datum/rogue_rmb_intent/swift

/datum/keybinding/rogue/alt_intent/aimed
	name = "rogue_alt_aimed"
	hotkey_keys = list("Shift2")
	full_name = "Alt intent: aimed"
	description = "Pick the aimed alt intent"
	keybind_signal = COMSIG_KB_ROGUE_ALT_AIMED_DOWN
	intent_type = /datum/rogue_rmb_intent/aimed

/datum/keybinding/rogue/alt_intent/feint
	name = "rogue_alt_feint"
	hotkey_keys = list("Shift1")
	full_name = "Alt intent: feint"
	description = "Pick the feint alt intent"
	keybind_signal = COMSIG_KB_ROGUE_ALT_FEINT_DOWN
	intent_type = /datum/rogue_rmb_intent/feint

/datum/keybinding/rogue/alt_intent/defend
	name = "rogue_alt_defend"
	hotkey_keys = list("Shift5")
	full_name = "Alt intent: defend"
	description = "Pick the defend alt intent"
	keybind_signal = COMSIG_KB_ROGUE_ALT_DEFEND_DOWN
	intent_type = /datum/rogue_rmb_intent/defend

/datum/keybinding/rogue/alt_intent/weak
	name = "rogue_alt_weak"
	hotkey_keys = list("Shift6")
	full_name = "Alt intent: weak"
	description = "Pick the weak alt intent"
	keybind_signal = COMSIG_KB_ROGUE_ALT_WEAK_DOWN
	intent_type = /datum/rogue_rmb_intent/weak

/datum/keybinding/rogue/middle_intent
	var/middle_intent = ROGUE_MMB_NONE

/datum/keybinding/rogue/middle_intent/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/owner = user.mob
	owner.rogue_select_mmb(middle_intent)
	return TRUE

/datum/keybinding/rogue/middle_intent/kick
	name = "rogue_mmb_kick"
	hotkey_keys = list("K")
	full_name = "Middle intent: kick"
	description = "Turn the kick middle-click intent on or off"
	keybind_signal = COMSIG_KB_ROGUE_MMB_KICK_DOWN
	middle_intent = ROGUE_MMB_KICK

/datum/keybinding/rogue/middle_intent/jump
	name = "rogue_mmb_jump"
	hotkey_keys = list("J")
	full_name = "Middle intent: jump"
	description = "Turn the jump middle-click intent on or off"
	keybind_signal = COMSIG_KB_ROGUE_MMB_JUMP_DOWN
	middle_intent = ROGUE_MMB_JUMP

/datum/keybinding/rogue/middle_intent/bite
	name = "rogue_mmb_bite"
	hotkey_keys = list("H")
	full_name = "Middle intent: bite"
	description = "Turn the bite middle-click intent on or off"
	keybind_signal = COMSIG_KB_ROGUE_MMB_BITE_DOWN
	middle_intent = ROGUE_MMB_BITE

/datum/keybinding/rogue/middle_intent/special
	name = "rogue_mmb_special"
	// Unbound: L looks up, as in TG; the special is picked on the HUD's middle-click quad and used with the middle button.
	hotkey_keys = list(UNBOUND_KEY)
	full_name = "Middle intent: special"
	description = "Turn the special middle-click intent on or off: middle click uses the held weapon's special attack"
	keybind_signal = COMSIG_KB_ROGUE_MMB_SPECIAL_DOWN
	middle_intent = ROGUE_MMB_SPECIAL

/datum/keybinding/rogue/defense
	name = "rogue_defense"
	hotkey_keys = list("ShiftC")
	full_name = "Parry or dodge"
	description = "Switch between parrying and dodging incoming blows"
	keybind_signal = COMSIG_KB_ROGUE_DEFENSE_DOWN

/datum/keybinding/rogue/defense/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/owner = user.mob
	owner.rogue_toggle_def_intent()
	return TRUE

/datum/keybinding/rogue/sneak
	name = "rogue_sneak"
	full_name = "Sneak"
	description = "Start or stop sneaking"
	keybind_signal = COMSIG_KB_ROGUE_SNEAK_DOWN

/datum/keybinding/rogue/sneak/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/owner = user.mob
	owner.rogue_toggle_sneak()
	return TRUE

/datum/keybinding/rogue/eyes
	name = "rogue_eyes"
	full_name = "Close or open eyes"
	description = "Close or open your eyes"
	keybind_signal = COMSIG_KB_ROGUE_EYES_DOWN

/datum/keybinding/rogue/eyes/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/owner = user.mob
	owner.playsound_local(owner, 'sound/machines/click.ogg', 50, FALSE)
	owner.rogue_set_eyes_closed(!owner.rogue_eyes_closed)
	return TRUE

/datum/keybinding/rogue/fixed_eye
	name = "rogue_fixed_eye"
	hotkey_keys = list("F")
	full_name = "Fixed gaze"
	description = "Keep facing the same way while you walk, or stop doing so"
	keybind_signal = COMSIG_KB_ROGUE_FIXED_EYE_DOWN

/datum/keybinding/rogue/fixed_eye/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/owner = user.mob
	owner.playsound_local(owner, 'sound/machines/click.ogg', 50, FALSE)
	owner.rogue_toggle_fixed_eye()
	return TRUE

/datum/keybinding/rogue/look_around
	name = "rogue_look_around"
	full_name = "Look around"
	description = "Search your surroundings for hidden people and traps"
	keybind_signal = COMSIG_KB_ROGUE_LOOK_AROUND_DOWN

/datum/keybinding/rogue/look_around/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/owner = user.mob
	INVOKE_ASYNC(owner, TYPE_PROC_REF(/mob/living, rogue_look_around))
	return TRUE

/datum/keybinding/rogue/give
	name = "rogue_give"
	hotkey_keys = list("G")
	full_name = "Guard, or give and take"
	description = "In combat mode take a guard stance (Ratwood's guard: the next blow is defended against); out of it offer what you hold, or take what is offered to you with an empty hand"
	keybind_signal = COMSIG_KB_ROGUE_GIVE_DOWN

/datum/keybinding/rogue/give/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/owner = user.mob
	if(owner.combat_mode)
		owner.rogue_try_guard()
	else if(owner.get_active_held_item())
		owner.give()
	else
		owner.rogue_take_offered()
	return TRUE

/datum/keybinding/rogue/compliance
	name = "rogue_compliance"
	full_name = "Compliance"
	description = "Stop or start resisting grabs and tackles"
	keybind_signal = COMSIG_KB_ROGUE_COMPLIANCE_DOWN

/datum/keybinding/rogue/compliance/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/owner = user.mob
	owner.rogue_toggle_compliance()
	return TRUE

/datum/keybinding/rogue/attributes
	name = "rogue_attributes"
	full_name = "Attributes"
	description = "Open the window with your stats and skills"
	keybind_signal = COMSIG_KB_ROGUE_ATTRIBUTES_DOWN

/datum/keybinding/rogue/attributes/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/owner = user.mob
	owner.rogue_open_attributes(owner)
	return TRUE

/datum/keybinding/rogue/hud_group
	var/group_key

/datum/keybinding/rogue/hud_group/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/datum/hud/rogue/hud = user.mob.hud_used
	hud.toggle_group(group_key, user.mob)
	return TRUE

/datum/keybinding/rogue/hud_group/panel
	name = "rogue_panel"
	full_name = "Fold the left panel"
	description = "Fold or unfold the left panel of the HUD"
	keybind_signal = COMSIG_KB_ROGUE_PANEL_DOWN
	group_key = HUD_GROUP_ROGUE_PANEL

/datum/keybinding/rogue/hud_group/doll
	name = "rogue_doll"
	full_name = "Hide the gargoyle"
	description = "Show or hide the body zone gargoyle"
	keybind_signal = COMSIG_KB_ROGUE_DOLL_DOWN
	group_key = HUD_GROUP_ROGUE_DOLL

/datum/keybinding/rogue/inventory
	name = "rogue_inventory"
	full_name = "Fold the inventory"
	description = "Fold or unfold the inventory slots"
	keybind_signal = COMSIG_KB_ROGUE_INVENTORY_DOWN

/datum/keybinding/rogue/inventory/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/datum/hud/rogue/hud = user.mob.hud_used
	hud.toggle_inventory(user.mob)
	return TRUE

/datum/keybinding/rogue/alt_grip
	name = "rogue_alt_grip"
	hotkey_keys = list("B")
	full_name = "Alt Grip"
	description = "Shift the held weapon into its next alternate grip, such as halfsword or mordhau, and back"
	keybind_signal = COMSIG_KB_ROGUE_ALT_GRIP_DOWN

/datum/keybinding/rogue/alt_grip/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/owner = user.mob
	var/obj/item/held = owner.get_active_held_item()
	if(!length(held?.alt_grips))
		return FALSE
	held.rogue_cycle_alt_grip(owner)
	return TRUE

/datum/keybinding/rogue/alt_intent_cycle
	name = "rogue_alt_cycle"
	full_name = "Cycle alt intent"
	description = "Switch to the next alt intent"
	keybind_signal = COMSIG_KB_ROGUE_ALT_CYCLE_DOWN
	hotkey_keys = list("N")

/datum/keybinding/rogue/alt_intent_cycle/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/owner = user.mob
	owner.rogue_cycle_rmb_intent()
	return TRUE

/datum/keybinding/rogue/combat_mode
	name = "rogue_combat_mode"
	full_name = "Combat mode"
	description = "Raise or lower your guard"
	keybind_signal = COMSIG_KB_ROGUE_COMBAT_MODE_DOWN
	hotkey_keys = list("C")

/datum/keybinding/rogue/combat_mode/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/owner = user.mob
	owner.set_combat_mode(!owner.combat_mode, FALSE)
	return TRUE

/datum/keybinding/rogue/run
	name = "rogue_run"
	full_name = "Run (hold)"
	description = "Switch between walking and running while held"
	keybind_signal = COMSIG_KB_ROGUE_RUN_DOWN
	hotkey_keys = list("Alt")

/datum/keybinding/rogue/run/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/owner = user.mob
	owner.toggle_move_intent()
	return TRUE

/datum/keybinding/rogue/run/up(client/user, turf/target)
	. = ..()
	var/mob/living/carbon/human/owner = user.mob
	owner.toggle_move_intent()
	return TRUE

/datum/keybinding/rogue/look_up
	name = "rogue_look_up"
	full_name = "Look up (hold)"
	description = "Look up while held; Lock looking up or down keeps it"
	keybind_signal = COMSIG_KB_ROGUE_LOOK_UP_DOWN
	hotkey_keys = list("ShiftF")

/datum/keybinding/rogue/look_up/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/owner = user.mob
	owner.look_up()
	return TRUE

/datum/keybinding/rogue/look_up/up(client/user, turf/target)
	. = ..()
	var/mob/living/carbon/human/owner = user.mob
	if(!owner.rogue_look_locked)
		owner.end_look()
	return TRUE

/datum/keybinding/rogue/rest
	name = "rogue_rest"
	full_name = "Lie down or stand up"
	description = "Lie down, or get up again"
	keybind_signal = COMSIG_KB_ROGUE_REST_DOWN
	hotkey_keys = list("V")

/datum/keybinding/rogue/rest/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/owner = user.mob
	owner.toggle_resting()
	return TRUE

/datum/keybinding/rogue/yield
	name = "rogue_yield"
	full_name = "Yield"
	description = "Give up the fight: drop what you hold and concede"
	keybind_signal = COMSIG_KB_ROGUE_YIELD_DOWN
	hotkey_keys = list("ShiftX")

/datum/keybinding/rogue/yield/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/owner = user.mob
	INVOKE_ASYNC(owner, TYPE_PROC_REF(/mob/living, rogue_yield))
	return TRUE

/datum/keybinding/rogue/stop_pulling
	name = "rogue_stop_pulling"
	full_name = "Stop pulling"
	description = "Let go of what you are pulling"
	keybind_signal = COMSIG_KB_ROGUE_STOP_PULLING_DOWN
	hotkey_keys = list("Z")

/datum/keybinding/rogue/stop_pulling/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/owner = user.mob
	if(!owner.pulling)
		return FALSE
	owner.stop_pulling()
	return TRUE

/datum/keybinding/rogue/hand
	var/hand_index = LEFT_HANDS

/datum/keybinding/rogue/hand/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	user.mob.activate_hand(hand_index)
	return TRUE

/datum/keybinding/rogue/hand/left
	name = "rogue_hand_left"
	hotkey_keys = list("Q")
	full_name = "Left hand"
	description = "Use your left hand"
	keybind_signal = COMSIG_KB_ROGUE_HAND_LEFT_DOWN
	hand_index = LEFT_HANDS

/datum/keybinding/rogue/hand/right
	name = "rogue_hand_right"
	hotkey_keys = list("E")
	full_name = "Right hand"
	description = "Use your right hand"
	keybind_signal = COMSIG_KB_ROGUE_HAND_RIGHT_DOWN
	hand_index = RIGHT_HANDS

/datum/keybinding/rogue/drop
	name = "rogue_drop"
	hotkey_keys = list("Z")
	full_name = "Drop"
	description = "Drop what you hold in the active hand"
	keybind_signal = COMSIG_KB_ROGUE_DROP_DOWN

/datum/keybinding/rogue/drop/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/owner = user.mob
	var/obj/item/held = owner.get_active_held_item()
	if(!held)
		return FALSE
	owner.dropItemToGround(held)
	return TRUE

/datum/keybinding/rogue/resist
	name = "rogue_resist"
	hotkey_keys = list("X")
	full_name = "Resist"
	description = "Break free of a grab, restraints or fire"
	keybind_signal = COMSIG_KB_ROGUE_RESIST_DOWN

/datum/keybinding/rogue/resist/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/owner = user.mob
	owner.resist()
	return TRUE

/datum/keybinding/rogue/hold_still
	name = "rogue_hold_still"
	hotkey_keys = list("Ctrl")
	full_name = "Hold still (hold)"
	description = "Stay in place while held: the movement keys only turn you"
	keybind_signal = COMSIG_KB_ROGUE_HOLD_STILL_DOWN

/datum/keybinding/rogue/hold_still/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	user.movement_locked = TRUE

/datum/keybinding/rogue/hold_still/up(client/user, turf/target)
	. = ..()
	user.movement_locked = FALSE

/// Ratwood's quick equipment: puts what you hold into the thing worn in a slot (a bag, a pouch, a belt), or into the empty
/// slot itself, and with an empty hand takes the last thing back out (TG's smart_equip_targeted).
/datum/keybinding/rogue/quick_equip
	keybind_signal = COMSIG_KB_ROGUE_QUICK_EQUIP_DOWN
	var/slot = ITEM_SLOT_BELT
	/// Which of the slot's cells, for the back that has two.
	var/slot_index = 1
	var/slot_name = "belt"

/datum/keybinding/rogue/quick_equip/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/owner = user.mob
	if(slot_index == ROGUE_BACK_RIGHT)
		owner.rogue_smart_equip_backr()
	else
		owner.smart_equip_targeted(slot, slot_name)
	return TRUE

/datum/keybinding/rogue/quick_equip/belt
	name = "rogue_quick_belt"
	hotkey_keys = list("ShiftB")
	full_name = "Quick equip belt"
	description = "Put what you hold on your belt, or take the last thing off it"

/// The cells are laid out as Ratwood's: the second back cell and the right hip on the left of the screen.
/datum/keybinding/rogue/quick_equip/back_left
	name = "rogue_quick_back_left"
	hotkey_keys = list("ShiftQ")
	full_name = "Bag on the back, left"
	description = "Put what you hold into the bag in the left back cell, or take the last thing out"
	slot = ITEM_SLOT_BACK
	slot_index = ROGUE_BACK_RIGHT
	slot_name = "bag"

/datum/keybinding/rogue/quick_equip/back_right
	name = "rogue_quick_back_right"
	hotkey_keys = list("ShiftE")
	full_name = "Bag on the back, right"
	description = "Put what you hold into the bag in the right back cell, or take the last thing out"
	slot = ITEM_SLOT_BACK
	slot_name = "bag"

/datum/keybinding/rogue/quick_equip/hip_left
	name = "rogue_quick_hip_left"
	hotkey_keys = list("AltQ")
	full_name = "Hip, left"
	description = "Put what you hold on the left hip cell, or into the pouch there, or take the last thing back"
	slot = ITEM_SLOT_RPOCKET
	slot_name = "hip"

/datum/keybinding/rogue/quick_equip/hip_right
	name = "rogue_quick_hip_right"
	hotkey_keys = list("AltE")
	full_name = "Hip, right"
	description = "Put what you hold on the right hip cell, or into the pouch there, or take the last thing back"
	slot = ITEM_SLOT_LPOCKET
	slot_name = "hip"

/// TG's smart_equip_targeted for the second back cell, which is not a TG slot.
/mob/living/carbon/human/proc/rogue_smart_equip_backr()
	if(incapacitated)
		return
	var/obj/item/thing = get_active_held_item()
	if(!wear_backr)
		if(!thing)
			to_chat(src, span_warning("You have no bag to take something out of!"))
			return
		if(thing.slot_flags & ITEM_SLOT_BACK)
			equip_to_rogue_cell(thing, ITEM_SLOT_BACK, ROGUE_BACK_RIGHT)
		return
	var/datum/storage/storage = wear_backr.atom_storage
	if(!storage)
		if(!thing)
			wear_backr.attack_hand(src)
		else
			to_chat(src, span_warning("You can't fit [thing] into your [wear_backr.name]!"))
		return
	if(!storage.supports_smart_equip)
		return
	if(storage.locked)
		to_chat(src, span_warning("\The [wear_backr] is locked!"))
		return
	if(thing)
		if(!storage.attempt_insert(thing, src))
			to_chat(src, span_warning("You can't fit [thing] into your [wear_backr.name]!"))
		return
	if(!length(storage.real_location.contents))
		to_chat(src, span_warning("There's nothing in your [wear_backr.name] to take out!"))
		return
	var/obj/item/stored = storage.real_location.contents[length(storage.real_location.contents)]
	if(stored && !stored.on_found(src))
		stored.attack_hand(src)

/// Ratwood's action keys: Alt+1-9 press the action buttons in the order they stand on the screen.
/datum/keybinding/rogue/action
	keybind_signal = COMSIG_KB_ROGUE_ACTION_DOWN
	var/index = 1

/datum/keybinding/rogue/action/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/list/buttons = user.mob.hud_used?.listed_actions?.actions
	if(length(buttons) < index)
		return FALSE
	var/atom/movable/screen/movable/action_button/button = buttons[index]
	button.linked_action?.Trigger(user.mob)
	return TRUE

/datum/keybinding/rogue/action/one
	name = "rogue_action_1"
	hotkey_keys = list("Alt1")
	full_name = "Action 1"
	description = "Press the first action button"
	index = 1

/datum/keybinding/rogue/action/two
	name = "rogue_action_2"
	hotkey_keys = list("Alt2")
	full_name = "Action 2"
	description = "Press the second action button"
	index = 2

/datum/keybinding/rogue/action/three
	name = "rogue_action_3"
	hotkey_keys = list("Alt3")
	full_name = "Action 3"
	description = "Press the third action button"
	index = 3

/datum/keybinding/rogue/action/four
	name = "rogue_action_4"
	hotkey_keys = list("Alt4")
	full_name = "Action 4"
	description = "Press the fourth action button"
	index = 4

/datum/keybinding/rogue/action/five
	name = "rogue_action_5"
	hotkey_keys = list("Alt5")
	full_name = "Action 5"
	description = "Press the fifth action button"
	index = 5

/datum/keybinding/rogue/action/six
	name = "rogue_action_6"
	hotkey_keys = list("Alt6")
	full_name = "Action 6"
	description = "Press the sixth action button"
	index = 6

/datum/keybinding/rogue/action/seven
	name = "rogue_action_7"
	hotkey_keys = list("Alt7")
	full_name = "Action 7"
	description = "Press the seventh action button"
	index = 7

/datum/keybinding/rogue/action/eight
	name = "rogue_action_8"
	hotkey_keys = list("Alt8")
	full_name = "Action 8"
	description = "Press the eighth action button"
	index = 8

/datum/keybinding/rogue/action/nine
	name = "rogue_action_9"
	hotkey_keys = list("Alt9")
	full_name = "Action 9"
	description = "Press the ninth action button"
	index = 9

/// The medieval layout is in force: a human with the medieval HUD.
/proc/rogue_layout_active(client/user)
	return ishuman(user?.mob) && istype(user.mob.hud_used, /datum/hud/rogue)

/datum/keybinding/living/enable_combat_mode/can_use(client/user)
	return !rogue_layout_active(user) && ..()

/datum/keybinding/living/disable_combat_mode/can_use(client/user)
	return !rogue_layout_active(user) && ..()

/datum/keybinding/living/toggle_combat_mode/can_use(client/user)
	return !rogue_layout_active(user) && ..()

/datum/keybinding/living/toggle_move_intent/can_use(client/user)
	return !rogue_layout_active(user) && ..()

/datum/keybinding/living/give/can_use(client/user)
	return !rogue_layout_active(user) && ..()

/datum/keybinding/mob/stop_pulling/can_use(client/user)
	return !rogue_layout_active(user) && ..()

/datum/keybinding/mob/prevent_movement/can_use(client/user)
	return !rogue_layout_active(user) && ..()

/datum/keybinding/dextrous/drop_item/can_use(client/user)
	return !rogue_layout_active(user) && ..()

/datum/keybinding/dextrous/activate_inhand/can_use(client/user)
	return !rogue_layout_active(user) && ..()

/datum/keybinding/dextrous/swap_hands/can_use(client/user)
	return !rogue_layout_active(user) && ..()

/datum/keybinding/human/quick_equip/can_use(client/user)
	return !rogue_layout_active(user) && ..()

/datum/keybinding/human/quick_equip_belt/can_use(client/user)
	return !rogue_layout_active(user) && ..()

/datum/keybinding/living/resist/can_use(client/user)
	return !rogue_layout_active(user) && ..()

/datum/keybinding/living/rest/can_use(client/user)
	return !rogue_layout_active(user) && ..()
