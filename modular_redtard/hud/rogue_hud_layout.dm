#define ROGUE_HUD_MAX_SCREEN_OBJECTS 62
#define ROGUE_HUD_MAX_SHOWN_OBJECTS 34

#define ROGUE_HUD_STUB_TEXT "не реализовано"

#define ROGUE_HUD_ICON 'modular_redtard/icons/mob/roguehud.dmi'
#define ROGUE_HUD_ICON_64 'modular_redtard/icons/mob/roguehud64.dmi'
#define ROGUE_HUD_ICON_BACK 'modular_redtard/icons/mob/roguehudback2.dmi'
#define ROGUE_HUD_ICON_PANEL 'modular_redtard/icons/mob/roguehud_panel.dmi'
#define ROGUE_HUD_ICON_INTENT_BASE 'modular_redtard/icons/mob/rogueintentbase.dmi'
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
#define rogueui_panel_toggle "WEST:16,NORTH"

#define rogueui_inventory_toggle "WEST:16,SOUTH"
#define rogueui_mask "WEST:16,SOUTH+5"
#define rogueui_head "WEST+1:16,SOUTH+5"
#define rogueui_mouth "WEST+2:16,SOUTH+5"
#define rogueui_backr "WEST:16,SOUTH+4"
#define rogueui_cloak "WEST+1:16,SOUTH+4"
#define rogueui_backl "WEST+2:16,SOUTH+4"
#define rogueui_neck "WEST:16,SOUTH+3"
#define rogueui_armor "WEST+1:16,SOUTH+3"
#define rogueui_wrists "WEST+2:16,SOUTH+3"
#define rogueui_ring1 "WEST:8,SOUTH+2:8"
#define rogueui_ring2 "WEST:24,SOUTH+2:8"
#define rogueui_ring3 "WEST:8,SOUTH+2:-8"
#define rogueui_ring4 "WEST:24,SOUTH+2:-8"
#define rogueui_shirt "WEST+1:16,SOUTH+2"
#define rogueui_gloves "WEST+2:16,SOUTH+2"
#define rogueui_beltr "WEST:16,SOUTH+1"
#define rogueui_belt "WEST+1:16,SOUTH+1"
#define rogueui_beltl "WEST+2:16,SOUTH+1"
#define rogueui_pants "WEST+1:16,SOUTH"
#define rogueui_shoes "WEST+2:16,SOUTH"

#define rogueui_drop "WEST+4,SOUTH+7"
#define rogueui_throw "WEST+4,SOUTH+7"
#define rogueui_give "WEST+4,SOUTH+7"
#define rogueui_quad "WEST+1,SOUTH+7"
#define rogueui_stance "WEST+1:16,CENTER+2"
#define rogueui_moves "WEST+2:16,CENTER+2"
#define rogueui_eye "WEST+3:16,CENTER+3"
#define rogueui_advsetup "CENTER-1,CENTER-1:16"
#define rogueui_craft "WEST+1:16,CENTER+3"
#define rogueui_skills "WEST+1:16,CENTER+3"
#define rogueui_targetdoll "WEST+2,CENTER+4:6"
#define rogueui_intents "WEST,SOUTH+8"
#define rogueui_stress "WEST+2:16,CENTER+3"
#define rogueui_fat "WEST+4:16,CENTER+2"
#define rogueui_blood "WEST+4:22,CENTER+4:17"
#define rogueui_feint "WEST+4:10,SOUTH+10:15"
#define rogueui_cmode "WEST+4,CENTER+1"
#define rogueui_def "WEST+3:16,NORTH-5"
#define rogueui_rmbintents "WEST+1,CENTER+1"

#define rogueui_clickdelay_left "WEST+2,SOUTH+7"
#define rogueui_clickdelay_right "WEST+3,SOUTH+7"
#define rogueui_clickdelay_mid "WEST+2:16,SOUTH+7"
#define rogueui_defdelay "WEST+4:11,SOUTH+10:15"

#define rogueui_screen_origin "1,1"
#define rogueui_readtext "5,5"

#define rogueui_intents_alt "EAST-1:28,SOUTH:5"

#define rogueui_ring_position(index) (index == 1 ? rogueui_ring1 : (index == 2 ? rogueui_ring2 : (index == 3 ? rogueui_ring3 : rogueui_ring4)))
#define rogueui_hand_position(index) (index == 1 ? "WEST+2,SOUTH+7" : (index == 2 ? "WEST+3,SOUTH+7" : null))

#define HUD_ROGUE_PANEL_TOGGLE "rogue_panel_toggle"
#define HUD_GROUP_ROGUE_PANEL (SCREEN_GROUP_AMT + 1)
#define HUD_ROGUE_GRAIN "rogue_grain"
#define HUD_ROGUE_SCANNIES "rogue_scannies"
#define HUD_ROGUE_READ "rogue_read"
#define HUD_ROGUE_READ_TEXT_LEFT "rogue_read_text_left"
#define HUD_ROGUE_READ_TEXT_RIGHT "rogue_read_text_right"
#define HUD_ROGUE_WEAPON_INTENTS "rogue_weapon_intents"
#define HUD_ROGUE_RMB_INTENT "rogue_rmb_intent"
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
