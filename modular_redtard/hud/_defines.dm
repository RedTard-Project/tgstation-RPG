#define ROGUE_HUD_MAX_SCREEN_OBJECTS 72
#define ROGUE_HUD_MAX_SHOWN_OBJECTS 38

#define ROGUE_HUD_STUB_TEXT "не реализовано"

#define ROGUE_HUD_ICON 'modular_redtard/icons/mob/roguehud.dmi'
#define ROGUE_HUD_ICON_64 'modular_redtard/icons/mob/roguehud64.dmi'
#define ROGUE_HUD_ICON_BACK 'modular_redtard/icons/mob/roguehudback2.dmi'
#define ROGUE_HUD_ICON_PANEL 'modular_redtard/icons/mob/roguehud_panel.dmi'
#define ROGUE_HUD_ICON_STRIP 'modular_redtard/icons/hud/rogue_panel.dmi'
#define ROGUE_HUD_ICON_DOLL_BACK 'modular_redtard/icons/hud/rogue_doll_back.dmi'
#define ROGUE_HUD_ICON_INTENT_GRID 'modular_redtard/icons/hud/rogue_intent_grid.dmi'
#define ROGUE_HUD_ICON_INTENTS 'modular_redtard/icons/mob/rogueintents.dmi'
#define ROGUE_HUD_ICON_HEAT 'modular_redtard/icons/mob/rogueheat.dmi'
#define ROGUE_HUD_ICON_FEINT 'modular_redtard/icons/mob/roguefeint.dmi'
#define ROGUE_HUD_ICON_ADVSETUP 'modular_redtard/icons/mob/advsetup.dmi'
#define ROGUE_HUD_ICON_VISION_CONE 'modular_redtard/icons/mob/vision_cone.dmi'
#define ROGUE_HUD_ICON_GRAIN 'modular_redtard/icons/hud/grain.dmi'
#define ROGUE_HUD_ICON_READ 'modular_redtard/icons/hud/read.dmi'

#define ROGUE_HUD_LAYER 24
#define ROGUE_ABOVE_HUD_LAYER 25
#define ROGUE_BACKHUD_LAYER (CURSE_LAYER + 0.1)
#define ROGUE_SCANNIES_LAYER (CURSE_LAYER + 0.2)

#define rogueui_backhudl "WEST:16,SOUTH:0"
#define rogueui_panel_strip "WEST,SOUTH to WEST,NORTH"
#define rogueui_panel_toggle "WEST:2,SOUTH"
#define rogueui_panel_width 36

#define rogueui_inventory_toggle "WEST+1:8,SOUTH"
#define rogueui_mask "WEST+1:8,SOUTH+5"
#define rogueui_head "WEST+2:8,SOUTH+5"
#define rogueui_mouth "WEST+3:8,SOUTH+5"
#define rogueui_backr "WEST+1:8,SOUTH+4"
#define rogueui_cloak "WEST+2:8,SOUTH+4"
#define rogueui_backl "WEST+3:8,SOUTH+4"
#define rogueui_neck "WEST+1:8,SOUTH+3"
#define rogueui_armor "WEST+2:8,SOUTH+3"
#define rogueui_wrists "WEST+3:8,SOUTH+3"
#define rogueui_ring1 "WEST+1,SOUTH+2:8"
#define rogueui_ring2 "WEST+1:16,SOUTH+2:8"
#define rogueui_ring3 "WEST+1,SOUTH+2:-8"
#define rogueui_ring4 "WEST+1:16,SOUTH+2:-8"
#define rogueui_shirt "WEST+2:8,SOUTH+2"
#define rogueui_gloves "WEST+3:8,SOUTH+2"
#define rogueui_beltr "WEST+1:8,SOUTH+1"
#define rogueui_belt "WEST+2:8,SOUTH+1"
#define rogueui_beltl "WEST+3:8,SOUTH+1"
#define rogueui_pants "WEST+2:8,SOUTH"
#define rogueui_shoes "WEST+3:8,SOUTH"

#define rogueui_stress "WEST:2,NORTH-1"
#define rogueui_blood "WEST:7,NORTH-2:15"
#define rogueui_fat "WEST:5,NORTH-4:13"
#define rogueui_craft "WEST:2,NORTH-5:11"
#define rogueui_skills "WEST:2,NORTH-5:11"
#define rogueui_build "WEST,NORTH-6:9"
#define rogueui_def "WEST:2,NORTH-7:23"
#define rogueui_cmode "WEST:2,NORTH-8:21"
#define rogueui_drop "WEST:2,NORTH-9:19"
#define rogueui_throw "WEST:2,NORTH-9:19"
#define rogueui_give "WEST:2,NORTH-9:19"
#define rogueui_eye "WEST:2,NORTH-10:17"
#define rogueui_moves "WEST:2,NORTH-11:15"
#define rogueui_quad "WEST:2,NORTH-12:13"
#define rogueui_stance "WEST:2,NORTH-13:11"

#define rogueui_hand_left "CENTER-1:16,SOUTH"
#define rogueui_hand_right "CENTER:16,SOUTH"
#define rogueui_clickdelay_left "CENTER-1:16,SOUTH"
#define rogueui_clickdelay_right "CENTER:16,SOUTH"
#define rogueui_clickdelay_mid "CENTER,SOUTH"
#define rogueui_intents "CENTER-3:12,SOUTH"
#define rogueui_rmb_button "CENTER+1:20,SOUTH"
#define rogueui_rmb_menu_base 25
#define rogueui_rmb_menu_step 20
#define rogueui_feint "WEST:2,NORTH"
#define rogueui_defdelay "WEST:2,NORTH"

#define rogueui_targetdoll "EAST-1,NORTH-1"
#define rogueui_doll_back "EAST-1,NORTH-1"
#define rogueui_doll_toggle "EAST:-2,NORTH-2"
#define rogueui_alert_drop 72
#define rogueui_fov_blocker "SOUTH,WEST"
#define rogueui_advsetup "CENTER-1,CENTER-1:16"

#define rogueui_screen_origin "1,1"
#define rogueui_readtext "5,5"

#define rogueui_ring_position(index) (index == 1 ? rogueui_ring1 : (index == 2 ? rogueui_ring2 : (index == 3 ? rogueui_ring3 : rogueui_ring4)))
#define rogueui_hand_position(index) (index == 1 ? rogueui_hand_left : (index == 2 ? rogueui_hand_right : null))

#define HUD_ROGUE_PANEL_TOGGLE "rogue_panel_toggle"
#define HUD_ROGUE_PANEL_STRIP "rogue_panel_strip"
#define HUD_ROGUE_BUILD "rogue_build"
#define HUD_ROGUE_DOLL_TOGGLE "rogue_doll_toggle"
#define HUD_ROGUE_DOLL_BACK "rogue_doll_back"
#define HUD_GROUP_ROGUE_PANEL (SCREEN_GROUP_AMT + 1)
#define HUD_GROUP_ROGUE_DOLL (SCREEN_GROUP_AMT + 2)
#define HUD_GROUP_ROGUE_RMB (SCREEN_GROUP_AMT + 3)
#define HUD_ROGUE_GRAIN "rogue_grain"
#define HUD_ROGUE_SCANNIES "rogue_scannies"
#define HUD_ROGUE_READ "rogue_read"
#define HUD_ROGUE_READ_TEXT_LEFT "rogue_read_text_left"
#define HUD_ROGUE_READ_TEXT_RIGHT "rogue_read_text_right"
#define HUD_ROGUE_WEAPON_INTENTS "rogue_weapon_intents"
#define HUD_ROGUE_RMB_SLOT(index) "rogue_rmb_[index]"
#define HUD_ROGUE_RMB_BUTTON "rogue_rmb_button"
#define HUD_ROGUE_QUAD_INTENTS "rogue_quad_intents"
#define HUD_ROGUE_DEF_INTENT "rogue_def_intent"
#define HUD_ROGUE_GIVE "rogue_give"
#define HUD_ROGUE_HEATSTAM_OVERLAY "rogue_heatstam_overlay"
#define HUD_ROGUE_FOV "rogue_fov"
#define HUD_ROGUE_FOV_BLOCKER "rogue_fov_blocker"
#define HUD_ROGUE_CLICKDELAY_LEFT "rogue_clickdelay_left"
#define HUD_ROGUE_CLICKDELAY_RIGHT "rogue_clickdelay_right"
#define HUD_ROGUE_CLICKDELAY_MID "rogue_clickdelay_mid"
#define HUD_ROGUE_DEFDELAY "rogue_defdelay"
#define HUD_ROGUE_STAND_UP "rogue_stand_up"
#define HUD_ROGUE_SKILLS "rogue_skills"
#define HUD_ROGUE_SNEAK "rogue_sneak"
#define HUD_ROGUE_EYE "rogue_eye"
#define HUD_ROGUE_ADVSETUP "rogue_advsetup"
#define HUD_ROGUE_ENERGY "rogue_energy"
#define HUD_ROGUE_FEINT "rogue_feint"

#define COMSIG_MOB_ROGUE_HUD_INTENT_CLICK "mob_rogue_hud_intent_click"
	#define COMPONENT_ROGUE_INTENT_HANDLED (1<<0)

#define CATEGORY_ROGUE "ROGUE"
#define COMSIG_KB_ROGUE_INTENT_1_DOWN "keybinding_rogue_intent_1_down"
#define COMSIG_KB_ROGUE_INTENT_2_DOWN "keybinding_rogue_intent_2_down"
#define COMSIG_KB_ROGUE_INTENT_3_DOWN "keybinding_rogue_intent_3_down"
#define COMSIG_KB_ROGUE_INTENT_4_DOWN "keybinding_rogue_intent_4_down"
#define COMSIG_KB_ROGUE_ALT_STRONG_DOWN "keybinding_rogue_alt_strong_down"
#define COMSIG_KB_ROGUE_ALT_SWIFT_DOWN "keybinding_rogue_alt_swift_down"
#define COMSIG_KB_ROGUE_ALT_AIMED_DOWN "keybinding_rogue_alt_aimed_down"
#define COMSIG_KB_ROGUE_ALT_FEINT_DOWN "keybinding_rogue_alt_feint_down"
#define COMSIG_KB_ROGUE_ALT_DEFEND_DOWN "keybinding_rogue_alt_defend_down"
#define COMSIG_KB_ROGUE_ALT_WEAK_DOWN "keybinding_rogue_alt_weak_down"
#define COMSIG_KB_ROGUE_MMB_KICK_DOWN "keybinding_rogue_mmb_kick_down"
#define COMSIG_KB_ROGUE_MMB_JUMP_DOWN "keybinding_rogue_mmb_jump_down"
#define COMSIG_KB_ROGUE_MMB_BITE_DOWN "keybinding_rogue_mmb_bite_down"
#define COMSIG_KB_ROGUE_MMB_SPECIAL_DOWN "keybinding_rogue_mmb_special_down"
#define COMSIG_KB_ROGUE_DEFENSE_DOWN "keybinding_rogue_defense_down"
#define COMSIG_KB_ROGUE_SNEAK_DOWN "keybinding_rogue_sneak_down"
#define COMSIG_KB_ROGUE_EYES_DOWN "keybinding_rogue_eyes_down"
#define COMSIG_KB_ROGUE_FIXED_EYE_DOWN "keybinding_rogue_fixed_eye_down"
#define COMSIG_KB_ROGUE_LOOK_AROUND_DOWN "keybinding_rogue_look_around_down"
#define COMSIG_KB_ROGUE_GIVE_DOWN "keybinding_rogue_give_down"
#define COMSIG_KB_ROGUE_COMPLIANCE_DOWN "keybinding_rogue_compliance_down"
#define COMSIG_KB_ROGUE_ALT_GRIP_DOWN "keybinding_rogue_alt_grip_down"
#define COMSIG_KB_ROGUE_ALT_CYCLE_DOWN "keybinding_rogue_alt_cycle_down"
#define COMSIG_KB_ROGUE_COMBAT_MODE_DOWN "keybinding_rogue_combat_mode_down"
#define COMSIG_KB_ROGUE_RUN_DOWN "keybinding_rogue_run_down"
#define COMSIG_KB_ROGUE_LOOK_UP_DOWN "keybinding_rogue_look_up_down"
#define COMSIG_KB_ROGUE_REST_DOWN "keybinding_rogue_rest_down"
#define COMSIG_KB_ROGUE_YIELD_DOWN "keybinding_rogue_yield_down"
#define COMSIG_KB_ROGUE_STOP_PULLING_DOWN "keybinding_rogue_stop_pulling_down"
#define COMSIG_KB_ROGUE_ATTRIBUTES_DOWN "keybinding_rogue_attributes_down"
#define COMSIG_KB_ROGUE_PANEL_DOWN "keybinding_rogue_panel_down"
#define COMSIG_KB_ROGUE_DOLL_DOWN "keybinding_rogue_doll_down"
#define COMSIG_KB_ROGUE_INVENTORY_DOWN "keybinding_rogue_inventory_down"
#define COMSIG_KB_ROGUE_HAND_LEFT_DOWN "keybinding_rogue_hand_left_down"
#define COMSIG_KB_ROGUE_HAND_RIGHT_DOWN "keybinding_rogue_hand_right_down"
#define COMSIG_KB_ROGUE_DROP_DOWN "keybinding_rogue_drop_down"
#define COMSIG_KB_ROGUE_RESIST_DOWN "keybinding_rogue_resist_down"
#define COMSIG_KB_ROGUE_HOLD_STILL_DOWN "keybinding_rogue_hold_still_down"
#define COMSIG_KB_ROGUE_QUICK_EQUIP_DOWN "keybinding_rogue_quick_equip_down"
#define COMSIG_KB_ROGUE_ACTION_DOWN "keybinding_rogue_action_down"
#define ROGUE_HUD_ICON_GRABS 'modular_redtard/icons/mob/roguehudgrabs.dmi'
