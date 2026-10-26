#ifdef UNIT_TESTS
#define TEST_ASSERT(assertion, reason) if (!(assertion)) { return Fail("Assertion failed: [reason || "No reason"]", __FILE__, __LINE__) }
#define TEST_ASSERT_EQUAL(a, b, message) do { \
	var/lhs = ##a; \
	var/rhs = ##b; \
	if (lhs != rhs) { \
		return Fail("Expected [isnull(lhs) ? "null" : lhs] to be equal to [isnull(rhs) ? "null" : rhs].[message ? " [message]" : ""]", __FILE__, __LINE__); \
	} \
} while (FALSE)

/datum/unit_test/rogue_hud
	abstract_type = /datum/unit_test/rogue_hud

/datum/unit_test/rogue_hud/proc/make_hud_user()
	var/mob/living/carbon/human/consistent/dummy = allocate(__IMPLIED_TYPE__)
	dummy.set_hud_used(new dummy.hud_type(dummy))
	SEND_SIGNAL(dummy, COMSIG_MOB_HUD_CREATED)
	return dummy

/datum/unit_test/rogue_hud/proc/click_as(mob/user, atom/movable/screen/element, params = "left=1")
	var/old_usr = usr
	usr = user
	element.Click(null, null, params)
	usr = old_usr

/datum/unit_test/rogue_hud/basics

/datum/unit_test/rogue_hud/basics/Run()
	var/mob/living/carbon/human/dummy = make_hud_user()
	var/datum/hud/hud = dummy.hud_used
	if(!HAS_TRAIT(dummy, TRAIT_COMBAT_MODE_LOCK) && isnull(hud.screen_objects[HUD_MOB_INTENTS]))
		TEST_FAIL("[dummy] using [hud.type] does not have an Action Intent.")
	if(hud.needs_health_indicator && isnull(hud.screen_objects[HUD_MOB_HEALTHDOLL]) && isnull(hud.screen_objects[HUD_MOB_HEALTH]))
		TEST_FAIL("[dummy] using [hud.type] does not have a Health Doll or Health HUD.")

/datum/unit_test/rogue_hud/replaces_human_hud

/datum/unit_test/rogue_hud/replaces_human_hud/Run()
	TEST_ASSERT_EQUAL(/mob/living/carbon/human::hud_type, /datum/hud/rogue/human, "Humans do not use the rogue HUD")
	for(var/mob/living/carbon/human/species_type as anything in list(/mob/living/carbon/human/species/lizard, /mob/living/carbon/human/species/monkey))
		TEST_ASSERT_EQUAL(species_type::hud_type, /datum/hud/rogue/human, "[species_type] does not use the rogue HUD")
	var/mob/living/carbon/human/dummy = make_hud_user()
	TEST_ASSERT(istype(dummy.hud_used, /datum/hud/rogue/human), "hud_used is [dummy.hud_used.type], expected /datum/hud/rogue/human")
	for(var/datum/hud/human/tg_hud)
		if(!QDELETED(tg_hud))
			TEST_FAIL("A /datum/hud/human exists for [tg_hud.mymob]")

/datum/unit_test/rogue_hud/layout

/datum/unit_test/rogue_hud/layout/Run()
	var/mob/living/carbon/human/dummy = make_hud_user()
	var/datum/hud/hud = dummy.hud_used
	var/icon/hud_icon = 'modular_redtard/icons/mob/roguehud.dmi'
	var/icon/heat_icon = 'modular_redtard/icons/mob/rogueheat.dmi'
	var/no_group = "none"
	var/list/states_missing_in_azure = list(HUD_ROGUE_GIVE)
	var/list/expected = list(
		HUD_ROGUE_PANEL_TOGGLE = list(/atom/movable/screen/rogue/panel_toggle, rogueui_panel_toggle, hud_icon, "template_small", 24, HUD_PLANE, HUD_GROUP_STATIC),
		HUD_HUMAN_TOGGLE_INVENTORY = list(/atom/movable/screen/human/toggle/rogue, rogueui_inventory_toggle, hud_icon, "back", 24, HUD_PLANE, HUD_GROUP_STATIC),
		HUD_ROGUE_GRAIN = list(/atom/movable/screen/rogue/placeholder/grain, "1,1", 'modular_redtard/icons/hud/grain.dmi', "grain", 13, HUD_PLANE, no_group),
		HUD_ROGUE_SCANNIES = list(/atom/movable/screen/rogue/placeholder/scannies, "WEST:16,SOUTH:0", 'modular_redtard/icons/mob/roguehudback2.dmi', "crt", CURSE_LAYER + 0.2, FULLSCREEN_PLANE, no_group),
		HUD_ROGUE_READ = list(/atom/movable/screen/rogue/placeholder/read, "1,1", 'modular_redtard/icons/hud/read.dmi', "", 24, HUD_PLANE, no_group),
		HUD_ROGUE_READ_TEXT_RIGHT = list(/atom/movable/screen/rogue/placeholder/readtext, "5,5", null, "", 24.02, HUD_PLANE, no_group),
		HUD_ROGUE_READ_TEXT_LEFT = list(/atom/movable/screen/rogue/placeholder/readtext, "5,5", null, "", 24.02, HUD_PLANE, no_group),
		HUD_ROGUE_WEAPON_INTENTS = list(/atom/movable/screen/rogue/weapon_intents, rogueui_intents, 'modular_redtard/icons/hud/rogue_intent_grid.dmi', "grid", 24, HUD_PLANE, HUD_GROUP_STATIC),
		HUD_MOB_MOOD = list(/atom/movable/screen/mood/rogue, rogueui_stress, hud_icon, null, 24, HUD_PLANE, HUD_GROUP_STATIC),
		HUD_ROGUE_RMB_BUTTON = list(/atom/movable/screen/rogue/rmb_intent, rogueui_rmb_button, hud_icon, "rmbintent", 24, HUD_PLANE, HUD_GROUP_STATIC),
		HUD_ROGUE_RMB_SLOT(1) = list(/atom/movable/screen/rogue/rmb_choice, "CENTER+1:20,SOUTH:25", hud_icon, "rmbstrong", 24, HUD_PLANE, HUD_GROUP_ROGUE_RMB),
		HUD_ROGUE_RMB_SLOT(2) = list(/atom/movable/screen/rogue/rmb_choice, "CENTER+1:20,SOUTH:45", hud_icon, "rmbswift", 24, HUD_PLANE, HUD_GROUP_ROGUE_RMB),
		HUD_ROGUE_RMB_SLOT(3) = list(/atom/movable/screen/rogue/rmb_choice, "CENTER+1:20,SOUTH:65", hud_icon, "rmbaimed", 24, HUD_PLANE, HUD_GROUP_ROGUE_RMB),
		HUD_ROGUE_RMB_SLOT(4) = list(/atom/movable/screen/rogue/rmb_choice, "CENTER+1:20,SOUTH:85", hud_icon, "rmbfeint", 24, HUD_PLANE, HUD_GROUP_ROGUE_RMB),
		HUD_ROGUE_RMB_SLOT(5) = list(/atom/movable/screen/rogue/rmb_choice, "CENTER+1:20,SOUTH:105", hud_icon, "rmbdef", 24, HUD_PLANE, HUD_GROUP_ROGUE_RMB),
		HUD_ROGUE_RMB_SLOT(6) = list(/atom/movable/screen/rogue/rmb_choice, "CENTER+1:20,SOUTH:125", hud_icon, "rmbweak", 24, HUD_PLANE, HUD_GROUP_ROGUE_RMB),
		HUD_MOB_HEALTH = list(/atom/movable/screen/healths/rogue, rogueui_blood, heat_icon, "dam0", 24, HUD_PLANE, HUD_GROUP_ROGUE_PANEL),
		HUD_ROGUE_QUAD_INTENTS = list(/atom/movable/screen/rogue/quad_intents, rogueui_quad, hud_icon, "mmbintents0", 24, HUD_PLANE, HUD_GROUP_ROGUE_PANEL),
		HUD_ROGUE_DEF_INTENT = list(/atom/movable/screen/rogue/def_intent, rogueui_def, hud_icon, "def2n", 24, HUD_PLANE, HUD_GROUP_ROGUE_PANEL),
		HUD_MOB_INTENTS = list(/atom/movable/screen/combattoggle/rogue, rogueui_cmode, hud_icon, "combat0", 24, HUD_PLANE, HUD_GROUP_ROGUE_PANEL),
		HUD_ROGUE_GIVE = list(/atom/movable/screen/rogue/give, rogueui_give, hud_icon, "take0", 24, HUD_PLANE, HUD_GROUP_ROGUE_PANEL),
		HUD_ROGUE_HEATSTAM_OVERLAY = list(/atom/movable/screen/rogue/heatstam_overlay, rogueui_fat, heat_icon, "heatstamover", 24.1, HUD_PLANE, HUD_GROUP_ROGUE_PANEL),
		HUD_ROGUE_FOV = list(/atom/movable/screen/rogue/placeholder/fov, "1,1", 'modular_redtard/icons/mob/vision_cone.dmi', "combat", FLASH_LAYER - 0.5, FULLSCREEN_PLANE, no_group),
		HUD_ROGUE_FOV_BLOCKER = list(/atom/movable/screen/rogue/placeholder/fov_blocker, "1,1", 'modular_redtard/icons/mob/vision_cone.dmi', "combat_v", 24, FIELD_OF_VISION_BLOCKER_PLANE, no_group),
		HUD_ROGUE_CLICKDELAY_LEFT = list(/atom/movable/screen/rogue/clickdelay/left, rogueui_clickdelay_left, hud_icon, "", 25, HUD_PLANE, HUD_GROUP_STATIC),
		HUD_ROGUE_CLICKDELAY_RIGHT = list(/atom/movable/screen/rogue/clickdelay/right, rogueui_clickdelay_right, hud_icon, "", 25, HUD_PLANE, HUD_GROUP_STATIC),
		HUD_ROGUE_CLICKDELAY_MID = list(/atom/movable/screen/rogue/clickdelay/next_move, rogueui_clickdelay_mid, hud_icon, "", 25, HUD_PLANE, HUD_GROUP_STATIC),
		HUD_ROGUE_DEFDELAY = list(/atom/movable/screen/rogue/defdelay, rogueui_defdelay, hud_icon, "defdelay0", 25, HUD_PLANE, HUD_GROUP_ROGUE_PANEL),
		HUD_KEY_HAND_SLOT(1) = list(/atom/movable/screen/inventory/hand/rogue, rogueui_hand_left, hud_icon, "hand_l", 24, HUD_PLANE, HUD_GROUP_STATIC),
		HUD_KEY_HAND_SLOT(2) = list(/atom/movable/screen/inventory/hand/rogue, rogueui_hand_right, hud_icon, "hand_r", 24, HUD_PLANE, HUD_GROUP_STATIC),
		HUD_ROGUE_RING_SLOT(1) = list(/atom/movable/screen/inventory/rogue/indexed/ring, rogueui_ring1, hud_icon, "ring", 24, HUD_PLANE, HUD_GROUP_TOGGLEABLE_INVENTORY),
		HUD_ROGUE_RING_SLOT(2) = list(/atom/movable/screen/inventory/rogue/indexed/ring, rogueui_ring2, hud_icon, "ring", 24, HUD_PLANE, HUD_GROUP_TOGGLEABLE_INVENTORY),
		HUD_ROGUE_RING_SLOT(3) = list(/atom/movable/screen/inventory/rogue/indexed/ring, rogueui_ring3, hud_icon, "ring", 24, HUD_PLANE, HUD_GROUP_TOGGLEABLE_INVENTORY),
		HUD_ROGUE_RING_SLOT(4) = list(/atom/movable/screen/inventory/rogue/indexed/ring, rogueui_ring4, hud_icon, "ring", 24, HUD_PLANE, HUD_GROUP_TOGGLEABLE_INVENTORY),
		HUD_KEY_ITEM_SLOT(ITEM_SLOT_ROGUE_WRISTS) = list(/atom/movable/screen/inventory/rogue, rogueui_wrists, hud_icon, "wrist", 24, HUD_PLANE, HUD_GROUP_TOGGLEABLE_INVENTORY),
		HUD_KEY_ITEM_SLOT(ITEM_SLOT_MASK) = list(/atom/movable/screen/inventory/rogue, rogueui_mask, hud_icon, "mask", 24, HUD_PLANE, HUD_GROUP_TOGGLEABLE_INVENTORY),
		HUD_KEY_ITEM_SLOT(ITEM_SLOT_NECK) = list(/atom/movable/screen/inventory/rogue, rogueui_neck, hud_icon, "neck", 24, HUD_PLANE, HUD_GROUP_TOGGLEABLE_INVENTORY),
		HUD_KEY_ITEM_SLOT(ITEM_SLOT_BACK) = list(/atom/movable/screen/inventory/rogue, rogueui_backl, hud_icon, "back", 24, HUD_PLANE, HUD_GROUP_TOGGLEABLE_INVENTORY),
		HUD_ROGUE_BACKR = list(/atom/movable/screen/inventory/rogue/indexed, rogueui_backr, hud_icon, "back", 24, HUD_PLANE, HUD_GROUP_TOGGLEABLE_INVENTORY),
		HUD_KEY_ITEM_SLOT(ITEM_SLOT_GLOVES) = list(/atom/movable/screen/inventory/rogue, rogueui_gloves, hud_icon, "gloves", 24, HUD_PLANE, HUD_GROUP_TOGGLEABLE_INVENTORY),
		HUD_KEY_ITEM_SLOT(ITEM_SLOT_HEAD) = list(/atom/movable/screen/inventory/rogue, rogueui_head, hud_icon, "head", 24, HUD_PLANE, HUD_GROUP_TOGGLEABLE_INVENTORY),
		HUD_KEY_ITEM_SLOT(ITEM_SLOT_FEET) = list(/atom/movable/screen/inventory/rogue, rogueui_shoes, hud_icon, "shoes", 24, HUD_PLANE, HUD_GROUP_TOGGLEABLE_INVENTORY),
		HUD_KEY_ITEM_SLOT(ITEM_SLOT_BELT) = list(/atom/movable/screen/inventory/rogue, rogueui_belt, hud_icon, "belt", 24, HUD_PLANE, HUD_GROUP_TOGGLEABLE_INVENTORY),
		HUD_KEY_ITEM_SLOT(ITEM_SLOT_RPOCKET) = list(/atom/movable/screen/inventory/rogue, rogueui_beltr, hud_icon, "hip", 24, HUD_PLANE, HUD_GROUP_TOGGLEABLE_INVENTORY),
		HUD_KEY_ITEM_SLOT(ITEM_SLOT_LPOCKET) = list(/atom/movable/screen/inventory/rogue, rogueui_beltl, hud_icon, "hip", 24, HUD_PLANE, HUD_GROUP_TOGGLEABLE_INVENTORY),
		HUD_KEY_ITEM_SLOT(ITEM_SLOT_ROGUE_SHIRT) = list(/atom/movable/screen/inventory/rogue, rogueui_shirt, hud_icon, "shirt", 24, HUD_PLANE, HUD_GROUP_TOGGLEABLE_INVENTORY),
		HUD_KEY_ITEM_SLOT(ITEM_SLOT_ICLOTHING) = list(/atom/movable/screen/inventory/rogue, rogueui_pants, hud_icon, "pants", 24, HUD_PLANE, HUD_GROUP_TOGGLEABLE_INVENTORY),
		HUD_KEY_ITEM_SLOT(ITEM_SLOT_OCLOTHING) = list(/atom/movable/screen/inventory/rogue, rogueui_armor, hud_icon, "armor", 24, HUD_PLANE, HUD_GROUP_TOGGLEABLE_INVENTORY),
		HUD_KEY_ITEM_SLOT(ITEM_SLOT_ROGUE_CLOAK) = list(/atom/movable/screen/inventory/rogue, rogueui_cloak, hud_icon, "cloak", 24, HUD_PLANE, HUD_GROUP_TOGGLEABLE_INVENTORY),
		HUD_KEY_ITEM_SLOT(ITEM_SLOT_ROGUE_MOUTH) = list(/atom/movable/screen/inventory/rogue, rogueui_mouth, hud_icon, "mouth", 24, HUD_PLANE, HUD_GROUP_TOGGLEABLE_INVENTORY),
		HUD_MOB_DROP = list(/atom/movable/screen/drop/rogue, rogueui_drop, hud_icon, "act_drop", 24, HUD_PLANE, HUD_GROUP_ROGUE_PANEL),
		HUD_MOB_THROW = list(/atom/movable/screen/throw_catch/rogue, rogueui_throw, hud_icon, "catch0", 24, HUD_PLANE, HUD_GROUP_ROGUE_PANEL),
		HUD_ROGUE_STAND_UP = list(/atom/movable/screen/rogue/stand_up, rogueui_stance, hud_icon, "act_rest_up", 24, HUD_PLANE, HUD_GROUP_ROGUE_PANEL),
		HUD_MOB_REST = list(/atom/movable/screen/rest/rogue, rogueui_stance, hud_icon, "act_rest_down", 24, HUD_PLANE, HUD_GROUP_ROGUE_PANEL),
		HUD_ROGUE_SKILLS = list(/atom/movable/screen/rogue/skills, rogueui_skills, hud_icon, "skills", 24, HUD_PLANE, HUD_GROUP_ROGUE_PANEL),
		HUD_MOB_CRAFTING_MENU = list(/atom/movable/screen/craft/rogue, rogueui_craft, hud_icon, "craft", 24, HUD_PLANE, HUD_GROUP_ROGUE_PANEL),
		HUD_ROGUE_SNEAK = list(/atom/movable/screen/rogue/sneak, rogueui_moves, hud_icon, "sneak0", 24, HUD_PLANE, HUD_GROUP_ROGUE_PANEL),
		HUD_MOB_MOVE_INTENT = list(/atom/movable/screen/mov_intent/rogue, rogueui_moves, hud_icon, null, 24, HUD_PLANE, HUD_GROUP_ROGUE_PANEL),
		HUD_ROGUE_EYE = list(/atom/movable/screen/rogue/eye, rogueui_eye, hud_icon, "eye", 24, HUD_PLANE, HUD_GROUP_ROGUE_PANEL),
		HUD_ROGUE_ADVSETUP = list(/atom/movable/screen/rogue/advsetup, "CENTER-1,CENTER-1:16", null, "", 24, HUD_PLANE, no_group),
		HUD_MOB_ZONE_SELECTOR = list(/atom/movable/screen/zone_sel/rogue, rogueui_targetdoll, 'modular_redtard/icons/mob/roguehud64.dmi', null, 24, HUD_PLANE, HUD_GROUP_ROGUE_DOLL),
		HUD_ROGUE_DOLL_BACK = list(/atom/movable/screen/rogue/doll_back, rogueui_doll_back, 'modular_redtard/icons/hud/rogue_doll_back.dmi', "doll_back", 23, HUD_PLANE, HUD_GROUP_ROGUE_DOLL),
		HUD_ROGUE_DOLL_TOGGLE = list(/atom/movable/screen/rogue/panel_toggle/doll, rogueui_doll_toggle, hud_icon, "template_small", 24, HUD_PLANE, HUD_GROUP_STATIC),
		HUD_ROGUE_PANEL_STRIP = list(/atom/movable/screen/rogue/panel_strip, rogueui_panel_strip, 'modular_redtard/icons/hud/rogue_panel.dmi', "strip", 23, HUD_PLANE, HUD_GROUP_ROGUE_PANEL),
		HUD_ROGUE_BUILD = list(/atom/movable/screen/rogue/build, rogueui_build, 'modular_redtard/icons/hud/rogue_panel.dmi', "build", 24, HUD_PLANE, HUD_GROUP_ROGUE_PANEL),
		HUD_MOB_STAMINA = list(/atom/movable/screen/stamina/rogue, rogueui_fat, heat_icon, "stam100", 24, HUD_PLANE, HUD_GROUP_ROGUE_PANEL),
		HUD_ROGUE_ENERGY = list(/atom/movable/screen/rogue/energy, rogueui_fat, heat_icon, "energy100", 24, HUD_PLANE, HUD_GROUP_ROGUE_PANEL),
		HUD_ROGUE_FEINT = list(/atom/movable/screen/rogue/feint, rogueui_feint, 'modular_redtard/icons/mob/roguefeint.dmi', "feintbar100", 24.1, HUD_PLANE, HUD_GROUP_ROGUE_PANEL),
	)
	for(var/hud_key in expected)
		var/list/row = expected[hud_key]
		var/atom/movable/screen/element = hud.screen_objects[hud_key]
		if(!istype(element, row[1]))
			TEST_FAIL("[hud_key]: expected [row[1]], got [element ? element.type : "nothing"]")
			continue
		if(element.screen_loc != row[2])
			TEST_FAIL("[hud_key]: screen_loc is [element.screen_loc], Azure has [row[2]]")
		if(element.icon != row[3])
			TEST_FAIL("[hud_key]: icon is [element.icon], expected [row[3]]")
		if(!isnull(row[4]) && "[element.icon_state]" != row[4])
			TEST_FAIL("[hud_key]: icon_state is [element.icon_state], expected [row[4]]")
		var/state_exists = !element.icon || !element.icon_state || icon_exists(element.icon, element.icon_state)
		if(state_exists == (hud_key in states_missing_in_azure))
			TEST_FAIL("[hud_key]: icon_state [element.icon_state] [state_exists ? "now exists in" : "is missing from"] [element.icon]; update states_missing_in_azure and the README")
		if(element.layer != row[5])
			TEST_FAIL("[hud_key]: layer is [element.layer], expected [row[5]]")
		if(element.plane != row[6])
			TEST_FAIL("[hud_key]: plane is [element.plane], expected [row[6]]")
		var/expected_group = row[7] == no_group ? null : row[7]
		if(element.hud_group_key != expected_group)
			TEST_FAIL("[hud_key]: group is [element.hud_group_key], expected [expected_group]")
	for(var/hud_key in hud.screen_objects)
		if(hud_key in expected)
			continue
		if(hud_key in list(HUD_MOB_TOGGLE_PALETTE, HUD_MOB_PALETTE_UP, HUD_MOB_PALETTE_DOWN, HUD_MOB_SCREENTIP))
			continue
		TEST_FAIL("Unexpected element [hud_key] ([hud.screen_objects[hud_key].type]) on the rogue HUD")

/datum/unit_test/rogue_hud/tg_keys

/datum/unit_test/rogue_hud/tg_keys/Run()
	var/mob/living/carbon/human/dummy = make_hud_user()
	var/datum/hud/hud = dummy.hud_used
	var/list/typed_keys = list(
		HUD_MOB_INTENTS = /atom/movable/screen/combattoggle,
		HUD_MOB_HEALTH = /atom/movable/screen/healths,
		HUD_MOB_STAMINA = /atom/movable/screen/stamina,
		HUD_MOB_ZONE_SELECTOR = /atom/movable/screen/zone_sel,
		HUD_MOB_MOOD = /atom/movable/screen/mood,
		HUD_MOB_THROW = /atom/movable/screen/throw_catch,
		HUD_MOB_REST = /atom/movable/screen/rest,
		HUD_MOB_MOVE_INTENT = /atom/movable/screen/mov_intent,
		HUD_MOB_DROP = /atom/movable/screen/drop,
		HUD_MOB_CRAFTING_MENU = /atom/movable/screen/craft,
		HUD_KEY_HAND_SLOT(1) = /atom/movable/screen/inventory/hand,
		HUD_KEY_HAND_SLOT(2) = /atom/movable/screen/inventory/hand,
		HUD_HUMAN_TOGGLE_INVENTORY = /atom/movable/screen/human/toggle,
	)
	for(var/hud_key in typed_keys)
		TEST_ASSERT(istype(hud.screen_objects[hud_key], typed_keys[hud_key]), "[hud_key] is not a [typed_keys[hud_key]]")
	var/list/dropped_keys = list(HUD_MOB_HUNGER, HUD_MOB_HEALTHDOLL, HUD_MOB_SPACESUIT, HUD_MOB_SLEEP, HUD_MOB_PULL, HUD_MOB_RESIST, HUD_MOB_LANGUAGE_MENU, HUD_MOB_NAVIGATE_MENU, HUD_MOB_AREA_CREATOR, HUD_MOB_FLOOR_CHANGER, HUD_MOB_MEMORIES, HUD_MOB_SWAPHAND_2)
	for(var/hud_key in dropped_keys)
		TEST_ASSERT_NULL(hud.screen_objects[hud_key], "[hud_key] is not part of Azure's HUD")
	var/atom/movable/screen/craft = hud.screen_objects[HUD_MOB_CRAFTING_MENU]
	TEST_ASSERT(craft.rogue_has_click_listener(), "Personal crafting did not take over the rogue craft button")
	TEST_ASSERT_EQUAL(hud.add_screen_object(/atom/movable/screen/mood, HUD_MOB_MOOD, HUD_GROUP_INFO), hud.screen_objects[HUD_MOB_MOOD], "Adding TG's mood element replaced the rogue one")
	hud.remove_screen_object(HUD_MOB_CRAFTING_MENU, FALSE)
	var/atom/movable/screen/readded = hud.add_screen_object(/atom/movable/screen/craft, HUD_MOB_CRAFTING_MENU, HUD_GROUP_STATIC, hud.ui_style, ui_human_crafting)
	TEST_ASSERT(istype(readded, /atom/movable/screen/craft/rogue), "Re-adding the crafting button made [readded.type]")
	TEST_ASSERT_EQUAL(readded.screen_loc, rogueui_craft, "Re-added crafting button left its place")

/datum/unit_test/rogue_hud/all_clicks

/datum/unit_test/rogue_hud/all_clicks/Run()
	var/mob/living/carbon/human/dummy = make_hud_user()
	var/datum/hud/hud = dummy.hud_used
	for(var/hud_key in hud.screen_objects.Copy())
		var/atom/movable/screen/element = hud.screen_objects[hud_key]
		if(QDELETED(element) || isnull(element.hud_group_key) || element.mouse_opacity == MOUSE_OPACITY_TRANSPARENT)
			continue
		for(var/params in list("left=1;icon-x=20;icon-y=20", "right=1;icon-x=20;icon-y=20", "middle=1;icon-x=20;icon-y=20"))
			dummy.next_move = 0
			click_as(dummy, element, params)
	dummy.set_combat_mode(FALSE)
	dummy.set_resting(FALSE, instant = TRUE)

/datum/unit_test/rogue_hud/intents

/datum/unit_test/rogue_hud/intents/Run()
	var/mob/living/carbon/human/dummy = make_hud_user()
	var/datum/hud/hud = dummy.hud_used
	var/atom/movable/screen/rogue/weapon_intents/intents = hud.screen_objects[HUD_ROGUE_WEAPON_INTENTS]
	var/datum/rogue_hud_intent_probe/probe = new
	probe.RegisterSignal(dummy, COMSIG_MOB_ROGUE_HUD_INTENT_CLICK, TYPE_PROC_REF(/datum/rogue_hud_intent_probe, on_intent_click))
	var/list/cells = list("icon-x=16;icon-y=24" = 1, "icon-x=48;icon-y=24" = 2, "icon-x=16;icon-y=8" = 3, "icon-x=48;icon-y=8" = 4)
	for(var/cell in cells)
		click_as(dummy, intents, "left=1;[cell]")
		TEST_ASSERT_EQUAL(probe.last_index, cells[cell], "Clicking [cell] picked the wrong intent")
	probe.UnregisterSignal(dummy, COMSIG_MOB_ROGUE_HUD_INTENT_CLICK)
	qdel(probe)
	click_as(dummy, intents, "left=1;icon-x=16;icon-y=24")

	var/datum/hud/rogue/rogue_hud = hud
	var/atom/movable/screen/rogue/rmb_intent/alt_button = hud.screen_objects[HUD_ROGUE_RMB_BUTTON]
	var/atom/movable/screen/rogue/rmb_choice/strong = hud.screen_objects[HUD_ROGUE_RMB_SLOT(1)]
	TEST_ASSERT(!rogue_hud.group_shown(HUD_GROUP_ROGUE_RMB), "The alt intent list starts open")
	click_as(dummy, alt_button)
	TEST_ASSERT(rogue_hud.group_shown(HUD_GROUP_ROGUE_RMB), "The alt intent button did not open the list")
	click_as(dummy, strong)
	TEST_ASSERT(dummy.rogue_rmb_is(/datum/rogue_rmb_intent/strong), "Clicking the strong button did not pick it")
	TEST_ASSERT(!rogue_hud.group_shown(HUD_GROUP_ROGUE_RMB), "Picking an alt intent did not close the list")
	TEST_ASSERT_EQUAL(length(strong.overlays), 1, "The picked alt intent is not highlighted")
	TEST_ASSERT_EQUAL(length(alt_button.overlays), 1, "The alt intent button does not show the picked intent")
	click_as(dummy, strong)
	TEST_ASSERT_NULL(dummy.rogue_rmb_intent, "Clicking the picked alt intent again did not clear it")
	TEST_ASSERT_EQUAL(length(strong.overlays), 0, "The cleared alt intent stayed highlighted")

	var/atom/movable/screen/combattoggle/rogue/combat = hud.screen_objects[HUD_MOB_INTENTS]
	TEST_ASSERT(!dummy.combat_mode, "Dummy starts in combat mode")
	click_as(dummy, combat)
	TEST_ASSERT(dummy.combat_mode, "The combat button did not turn combat mode on")
	TEST_ASSERT_EQUAL(combat.icon_state, "combat1", "The combat button did not show combat mode")
	click_as(dummy, combat)
	TEST_ASSERT(!dummy.combat_mode, "The combat button did not turn combat mode off")
	TEST_ASSERT_EQUAL(combat.icon_state, "combat0", "The combat button did not show combat mode off")

/datum/unit_test/rogue_hud/fist_intents

/datum/unit_test/rogue_hud/fist_intents/Run()
	var/mob/living/carbon/human/dummy = make_hud_user()
	var/list/fists = dummy.rogue_hand_intents()
	TEST_ASSERT_EQUAL(length(fists), 4, "An empty hand should offer Ratwood's four fist intents")
	var/list/buttons = list("intouch", "inshove", "ingrab", "inpunch")
	for(var/slot in 1 to length(buttons))
		var/datum/intent/fist = rogue_intent(fists[slot])
		TEST_ASSERT_EQUAL(fist.icon_state, buttons[slot], "Fist intent [slot]")
		TEST_ASSERT(icon_exists(fist.icon, fist.icon_state), "[fist.name] has no labelled button in [fist.icon]")
	var/atom/movable/screen/rogue/weapon_intents/intents = dummy.hud_used.screen_objects[HUD_ROGUE_WEAPON_INTENTS]
	intents.update_appearance(UPDATE_OVERLAYS)
	TEST_ASSERT_EQUAL(length(intents.overlays), 5, "The intent panel should draw four fist buttons and the selection")

	var/mob/living/carbon/human/target = allocate(/mob/living/carbon/human/consistent)
	ADD_TRAIT(dummy, TRAIT_PERFECT_ATTACKER, TRAIT_SOURCE_UNIT_TESTS)
	dummy.set_combat_mode(TRUE)
	TEST_ASSERT(dummy.rogue_select_intent(1), "Could not pick touch")
	dummy.UnarmedAttack(target, TRUE, list())
	TEST_ASSERT_EQUAL(target.get_brute_loss(), 0, "Touch hurt the target in combat mode")
	TEST_ASSERT(dummy.combat_mode, "Touch left combat mode switched off")

	dummy.set_combat_mode(FALSE)
	TEST_ASSERT(dummy.rogue_select_intent(4), "Could not pick punch")
	dummy.UnarmedAttack(target, TRUE, list())
	TEST_ASSERT_EQUAL(target.get_brute_loss(), 0, "Punch hurt the target outside combat mode; combat mode decides whether one strikes")
	dummy.set_combat_mode(TRUE)
	dummy.UnarmedAttack(target, TRUE, list())
	TEST_ASSERT(target.get_brute_loss() > 0, "Punch did not hurt the target in combat mode")
	dummy.set_combat_mode(FALSE)

	TEST_ASSERT(dummy.rogue_select_intent(3), "Could not pick grab")
	dummy.UnarmedAttack(target, TRUE, list())
	TEST_ASSERT_EQUAL(dummy.pulling, target, "Grab did not take hold of the target")
	dummy.stop_pulling()

	var/obj/item/toy/plush/held = allocate(__IMPLIED_TYPE__)
	dummy.put_in_active_hand(held)
	TEST_ASSERT_NULL(dummy.rogue_active_intent(), "An item without rogue intents still uses the fist intents")
	dummy.dropItemToGround(held)
	TEST_ASSERT(istype(dummy.rogue_active_intent(), /datum/intent/unarmed/grab), "The fist intent was not kept apart from the item")

/datum/rogue_hud_intent_probe
	var/last_index

/datum/rogue_hud_intent_probe/proc/on_intent_click(datum/source, index, list/modifiers)
	SIGNAL_HANDLER
	last_index = index
	return COMPONENT_ROGUE_INTENT_HANDLED

/datum/unit_test/rogue_hud/state_mapping

/datum/unit_test/rogue_hud/state_mapping/Run()
	var/mob/living/carbon/human/consistent/dummy = make_hud_user()
	var/datum/hud/hud = dummy.hud_used

	var/atom/movable/screen/zone_sel/rogue/doll = hud.screen_objects[HUD_MOB_ZONE_SELECTOR]
	var/list/zone_clicks = list("icon-x=33;icon-y=34" = BODY_ZONE_CHEST, "icon-x=31;icon-y=49" = BODY_ZONE_PRECISE_EYES, "icon-x=20;icon-y=2" = BODY_ZONE_R_LEG, "icon-x=33;icon-y=43" = BODY_ZONE_PRECISE_MOUTH, "icon-x=18;icon-y=27" = BODY_ZONE_R_ARM)
	for(var/zone_click in zone_clicks)
		click_as(dummy, doll, "left=1;[zone_click]")
		TEST_ASSERT_EQUAL(dummy.zone_selected, zone_clicks[zone_click], "Doll click at [zone_click] picked the wrong zone")

	var/atom/movable/screen/throw_catch/rogue/throw_button = hud.screen_objects[HUD_MOB_THROW]
	dummy.throw_mode_on(THROW_MODE_TOGGLE)
	TEST_ASSERT_EQUAL(throw_button.icon_state, "catch1", "Throw mode with empty hands")
	var/obj/item/toy/plush/held = allocate(__IMPLIED_TYPE__)
	dummy.put_in_active_hand(held)
	TEST_ASSERT_EQUAL(throw_button.icon_state, "throw1", "Throw mode with an item in hand")
	dummy.throw_mode_off(THROW_MODE_TOGGLE)
	TEST_ASSERT_EQUAL(throw_button.icon_state, "throw0", "Throw mode off with an item in hand")

	var/atom/movable/screen/rogue/give/give_button = hud.screen_objects[HUD_ROGUE_GIVE]
	TEST_ASSERT_EQUAL(give_button.icon_state, "give0", "Give button with an item in hand")

	var/atom/movable/screen/mov_intent/rogue/sprint = hud.screen_objects[HUD_MOB_MOVE_INTENT]
	dummy.set_move_intent(MOVE_INTENT_RUN)
	sprint.update_appearance(UPDATE_ICON_STATE)
	TEST_ASSERT_EQUAL(sprint.icon_state, "sprint1", "Running shows sprint")
	dummy.set_move_intent(MOVE_INTENT_WALK)
	sprint.update_appearance(UPDATE_ICON_STATE)
	TEST_ASSERT_EQUAL(sprint.icon_state, "sprint0", "Walking hides sprint")

	var/atom/movable/screen/stamina/rogue/stamina = hud.screen_objects[HUD_MOB_STAMINA]
	var/threshold = dummy.maxHealth - dummy.crit_threshold
	var/list/stamina_steps = list("0" = "stam100", "0.03" = "stam100", "0.06" = "stam95", "0.5" = "stam55", "0.97" = "stam5", "1" = "stam0")
	for(var/fraction in stamina_steps)
		stamina.update_for(dummy, text2num(fraction) * threshold)
		TEST_ASSERT_EQUAL(stamina.icon_state, stamina_steps[fraction], "Stamina at [fraction] of the threshold")

	var/atom/movable/screen/healths/rogue/health = hud.screen_objects[HUD_MOB_HEALTH]
	health.update_for(dummy)
	TEST_ASSERT_EQUAL(health.icon_state, "dam0", "Healthy life indicator")
	dummy.set_blood_volume(BLOOD_VOLUME_NORMAL * 0.7)
	health.update_for(dummy)
	TEST_ASSERT_EQUAL(health.icon_state, "dam30", "Life indicator after losing 30% blood")
	dummy.set_blood_volume(BLOOD_VOLUME_NORMAL)

	var/atom/movable/screen/mood/rogue/mood = hud.screen_objects[HUD_MOB_MOOD]
	TEST_ASSERT_NULL(mood.color, "TG's mood tint stayed on the rogue element")
	var/list/mood_steps = list("1" = "stress4", "4" = "stress", "5" = "mood_idle", "6" = "peace", "9" = "mood_nirvana")
	for(var/level in mood_steps)
		dummy.mob_mood.mood_level = text2num(level)
		dummy.mob_mood.update_mood_icon()
		TEST_ASSERT_EQUAL(mood.icon_state, mood_steps[level], "Mood level [level]")

/datum/unit_test/rogue_hud/many_hands

/datum/unit_test/rogue_hud/many_hands/Run()
	var/mob/living/carbon/human/dummy = make_hud_user()
	var/datum/hud/hud = dummy.hud_used
	dummy.change_number_of_hands(4)
	TEST_ASSERT_NOTNULL(hud.screen_objects[HUD_KEY_HAND_SLOT(4)], "Fourth hand has no slot")
	TEST_ASSERT_NULL(hud.screen_objects[HUD_KEY_HAND_SLOT(4)].screen_loc, "Azure has no place for a fourth hand")
	TEST_ASSERT_EQUAL(hud.screen_objects[HUD_KEY_HAND_SLOT(2)].screen_loc, rogueui_hand_right, "Right hand moved")

/datum/unit_test/rogue_hud/inventory_toggle

/datum/unit_test/rogue_hud/inventory_toggle/Run()
	var/mob/living/carbon/human/dummy = make_hud_user()
	var/datum/hud/hud = dummy.hud_used
	TEST_ASSERT(!hud.inventory_shown, "The inventory starts unfolded")
	var/list/folded = hud.screen_groups[HUD_GROUP_TOGGLEABLE_INVENTORY]
	TEST_ASSERT_EQUAL(length(folded), 20, "The inventory block should hold 20 boxes (four ring cells) and nothing else")
	var/atom/movable/screen/toggle = hud.screen_objects[HUD_HUMAN_TOGGLE_INVENTORY]
	click_as(dummy, toggle)
	TEST_ASSERT(hud.inventory_shown, "The bag button did not unfold the inventory")
	TEST_ASSERT_EQUAL(toggle.icon_state, "back", "The bag button lost its sprite")
	click_as(dummy, toggle)
	TEST_ASSERT(!hud.inventory_shown, "The bag button did not fold the inventory")

/datum/unit_test/rogue_hud/screen_object_count

/datum/unit_test/rogue_hud/screen_object_count/Run()
	var/mob/living/carbon/human/dummy = make_hud_user()
	var/datum/hud/rogue_hud = dummy.hud_used
	var/datum/hud/human/tg_hud = new(dummy)
	var/tg_count = length(tg_hud.screen_objects)
	var/tg_shown = count_shown(tg_hud)
	qdel(tg_hud)
	var/rogue_count = length(rogue_hud.screen_objects)
	var/rogue_shown = count_shown(rogue_hud)
	TEST_NOTICE(src, "Screen objects, TG human HUD: [tg_count] registered, [tg_shown] on screen in the standard view. Rogue HUD: [rogue_count] registered, [rogue_shown] on screen.")
	TEST_ASSERT(rogue_count <= ROGUE_HUD_MAX_SCREEN_OBJECTS, "Rogue HUD has [rogue_count] screen objects, the documented ceiling is [ROGUE_HUD_MAX_SCREEN_OBJECTS]")
	TEST_ASSERT(rogue_shown <= ROGUE_HUD_MAX_SHOWN_OBJECTS, "Rogue HUD shows [rogue_shown] screen objects, the documented ceiling is [ROGUE_HUD_MAX_SHOWN_OBJECTS]")

/datum/unit_test/rogue_hud/screen_object_count/proc/count_shown(datum/hud/hud)
	. = 0
	for(var/group_key in list(HUD_GROUP_STATIC, HUD_GROUP_HOTKEYS, HUD_GROUP_INFO, HUD_GROUP_SCREEN_OVERLAYS))
		. += length(hud.screen_groups[group_key])
	var/datum/hud/rogue/rogue_hud = hud
	if(istype(rogue_hud))
		for(var/group_key in list(HUD_GROUP_ROGUE_PANEL, HUD_GROUP_ROGUE_DOLL, HUD_GROUP_ROGUE_RMB))
			if(rogue_hud.group_shown(group_key))
				. += length(rogue_hud.screen_groups[group_key])
	if(hud.inventory_shown)
		. += length(hud.screen_groups[HUD_GROUP_TOGGLEABLE_INVENTORY])

#undef TEST_ASSERT
#undef TEST_ASSERT_EQUAL
#endif
