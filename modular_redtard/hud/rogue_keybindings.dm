/// Medieval controls laid out as Twilight Axis has them (code/datums/keybinding of Twilight): intents on 1-4, stances on
/// Shift+1-6 and N, middle-click intents on G H J K L, combat mode on C, fixed gaze on F, run held on Alt. They work only
/// with the medieval HUD; the TG bindings that share their keys stand down there (bottom of the file).
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
	owner.rogue_toggle_rmb_intent(intent_type)
	return TRUE

/datum/keybinding/rogue/alt_intent/strong
	name = "rogue_alt_strong"
	hotkey_keys = list("Shift3")
	full_name = "Alt intent: strong"
	description = "Turn the strong alt intent on or off"
	keybind_signal = COMSIG_KB_ROGUE_ALT_STRONG_DOWN
	intent_type = /datum/rogue_rmb_intent/strong

/datum/keybinding/rogue/alt_intent/swift
	name = "rogue_alt_swift"
	hotkey_keys = list("Shift4")
	full_name = "Alt intent: swift"
	description = "Turn the swift alt intent on or off"
	keybind_signal = COMSIG_KB_ROGUE_ALT_SWIFT_DOWN
	intent_type = /datum/rogue_rmb_intent/swift

/datum/keybinding/rogue/alt_intent/aimed
	name = "rogue_alt_aimed"
	hotkey_keys = list("Shift2")
	full_name = "Alt intent: aimed"
	description = "Turn the aimed alt intent on or off"
	keybind_signal = COMSIG_KB_ROGUE_ALT_AIMED_DOWN
	intent_type = /datum/rogue_rmb_intent/aimed

/datum/keybinding/rogue/alt_intent/feint
	name = "rogue_alt_feint"
	hotkey_keys = list("Shift1")
	full_name = "Alt intent: feint"
	description = "Turn the feint alt intent on or off"
	keybind_signal = COMSIG_KB_ROGUE_ALT_FEINT_DOWN
	intent_type = /datum/rogue_rmb_intent/feint

/datum/keybinding/rogue/alt_intent/defend
	name = "rogue_alt_defend"
	hotkey_keys = list("Shift5")
	full_name = "Alt intent: defend"
	description = "Turn the defend alt intent on or off"
	keybind_signal = COMSIG_KB_ROGUE_ALT_DEFEND_DOWN
	intent_type = /datum/rogue_rmb_intent/defend

/datum/keybinding/rogue/alt_intent/weak
	name = "rogue_alt_weak"
	hotkey_keys = list("Shift6")
	full_name = "Alt intent: weak"
	description = "Turn the weak alt intent on or off"
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
	hotkey_keys = list("L")
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
	full_name = "Give or take"
	description = "Offer what you hold, or take what is offered to you with an empty hand"
	keybind_signal = COMSIG_KB_ROGUE_GIVE_DOWN

/datum/keybinding/rogue/give/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/owner = user.mob
	if(owner.get_active_held_item())
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

/datum/keybinding/living/look_up/can_use(client/user)
	return !rogue_layout_active(user) && ..()

/datum/keybinding/mob/stop_pulling/can_use(client/user)
	return !rogue_layout_active(user) && ..()

/datum/keybinding/mob/prevent_movement/can_use(client/user)
	return !rogue_layout_active(user) && ..()
