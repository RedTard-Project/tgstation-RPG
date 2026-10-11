// Layout of the rogue HUD, ported value-for-value from Azure Peak's code/_onclick/hud/_defines.dm.
// The HUD lives in the five columns to the left of the map (WEST-5 .. WEST-1); BYOND widens the map to show them.
// Unlike Azure there is no frame around the map, and the inventory is a bare block in the bottom-left corner that folds away like TG's.

/// Screen objects the rogue human HUD registers: Azure's element inventory, the panel, the inventory toggle, TG's palette and screentip (see README)
#define ROGUE_HUD_MAX_SCREEN_OBJECTS 59
/// Of those, the ones on screen in the standard view with the inventory folded; placeholders for unported overlays stay off screen
#define ROGUE_HUD_MAX_SHOWN_OBJECTS 34

/// Text shown by elements whose mechanic is not ported yet
#define ROGUE_HUD_STUB_TEXT "не реализовано"

// Sprites
#define ROGUE_HUD_ICON 'modular_redtard/icons/mob/roguehud.dmi'
#define ROGUE_HUD_ICON_64 'modular_redtard/icons/mob/roguehud64.dmi'
#define ROGUE_HUD_ICON_BACK 'modular_redtard/icons/mob/roguehudback2.dmi'
/// The top 8 rows of Azure's left panel, cut out of roguehudback2.dmi by tools/dmi_crop.py
#define ROGUE_HUD_ICON_PANEL 'modular_redtard/icons/mob/roguehud_panel.dmi'
#define ROGUE_HUD_ICON_INTENT_BASE 'modular_redtard/icons/mob/rogueintentbase.dmi'
#define ROGUE_HUD_ICON_INTENTS 'modular_redtard/icons/mob/rogueintents.dmi'
#define ROGUE_HUD_ICON_HEAT 'modular_redtard/icons/mob/rogueheat.dmi'
#define ROGUE_HUD_ICON_FEINT 'modular_redtard/icons/mob/roguefeint.dmi'
#define ROGUE_HUD_ICON_ADVSETUP 'modular_redtard/icons/mob/advsetup.dmi'
#define ROGUE_HUD_ICON_VISION_CONE 'modular_redtard/icons/mob/vision_cone.dmi'
#define ROGUE_HUD_ICON_GRAIN 'modular_redtard/icons/hud/grain.dmi'
#define ROGUE_HUD_ICON_READ 'modular_redtard/icons/hud/read.dmi'

// Layers. Azure draws the HUD at HUD_LAYER 24 / ABOVE_HUD_LAYER 25 on its HUD plane; the same numbers are kept on TG's HUD_PLANE.
#define ROGUE_HUD_LAYER 24
#define ROGUE_ABOVE_HUD_LAYER 25
/// Azure's BACKHUD_LAYER sits above every fullscreen overlay (flash, blind, crit, curse); TG numbers those 1..6
#define ROGUE_BACKHUD_LAYER (CURSE_LAYER + 0.1)
/// Azure's scannies overlay sits above the back HUD on the fullscreen plane
#define ROGUE_SCANNIES_LAYER (CURSE_LAYER + 0.2)

// Screen locations (Azure: rogueui_*)
#define rogueui_backhudl "WEST-5:0,SOUTH:0"
/// The top of Azure's panel, rows SOUTH+7 and up; the inventory rows below it have no background
#define rogueui_panel "WEST-5,SOUTH+7"

// Inventory: a bare 3x6 block of boxes in the bottom-left corner, opened by the bag in the corner itself and growing
// right and up. Azure's body-shaped arrangement (head on top, feet at the bottom) is kept, one column left and one
// row down from Azure's place (Azure: columns WEST-4..WEST-2, rows SOUTH+1..SOUTH+6, see README).
#define rogueui_inventory_toggle "WEST-5,SOUTH"
#define rogueui_mask "WEST-5,SOUTH+5"
#define rogueui_head "WEST-4,SOUTH+5"
#define rogueui_mouth "WEST-3,SOUTH+5"
#define rogueui_backr "WEST-5,SOUTH+4"
#define rogueui_cloak "WEST-4,SOUTH+4"
#define rogueui_backl "WEST-3,SOUTH+4"
#define rogueui_neck "WEST-5,SOUTH+3"
#define rogueui_armor "WEST-4,SOUTH+3"
#define rogueui_wrists "WEST-3,SOUTH+3"
#define rogueui_ringr "WEST-5,SOUTH+2"
#define rogueui_shirt "WEST-4,SOUTH+2"
#define rogueui_gloves "WEST-3,SOUTH+2"
#define rogueui_beltr "WEST-5,SOUTH+1"
#define rogueui_belt "WEST-4,SOUTH+1"
#define rogueui_beltl "WEST-3,SOUTH+1"
#define rogueui_pants "WEST-4,SOUTH"
#define rogueui_shoes "WEST-3,SOUTH"

#define rogueui_drop "WEST-1:-16,SOUTH+7"
#define rogueui_throw "WEST-1:-16,SOUTH+7"
#define rogueui_give "WEST-1:-16,SOUTH+7"
#define rogueui_quad "WEST-4:-16,SOUTH+7"
#define rogueui_stance "WEST-4,CENTER+2"
#define rogueui_moves "WEST-3,CENTER+2"
#define rogueui_eye "WEST-2,CENTER+3"
#define rogueui_advsetup "CENTER-1,CENTER-1:16"
#define rogueui_craft "WEST-4,CENTER+3"
#define rogueui_skills "WEST-4,CENTER+3"
#define rogueui_targetdoll "WEST-3:-16,CENTER+4:6"
#define rogueui_intents "WEST-5:-16,SOUTH+8"
#define rogueui_stress "WEST-3,CENTER+3"
#define rogueui_fat "WEST-1,CENTER+2"
#define rogueui_blood "WEST-1:6,CENTER+4:17"
#define rogueui_feint "WEST-1:-6,SOUTH+10:15"
#define rogueui_cmode "WEST-1:-16,CENTER+1"
#define rogueui_def "WEST-2,NORTH-5"
#define rogueui_rmbintents "WEST-4:-16,CENTER+1"

// Azure sets these four inline in /datum/hud/human/New
#define rogueui_clickdelay_left "WEST-3:-16,SOUTH+7"
#define rogueui_clickdelay_right "WEST-2:-16,SOUTH+7"
#define rogueui_clickdelay_mid "WEST-3:0,SOUTH+7"
#define rogueui_defdelay "WEST-1:-5,SOUTH+10:15"

// Azure's full-screen and reading overlays keep their own fixed locations
#define rogueui_screen_origin "1,1"
#define rogueui_readtext "5,5"

/// Azure's ui_acti_alt: where the weapon intents move when the HUD is reduced (F12)
#define rogueui_intents_alt "EAST-1:28,SOUTH:5"

/// Azure's ui_hand_position(): hand 1 is the left hand, hand 2 the right; further hands have no slot
#define rogueui_hand_position(index) (index == 1 ? "WEST-3:-16,SOUTH+7" : (index == 2 ? "WEST-2:-16,SOUTH+7" : null))

// HUD keys for elements TG has no key for. Elements with a TG equivalent use TG's HUD_MOB_* / HUD_KEY_* keys.
#define HUD_ROGUE_PANEL "rogue_panel"
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
/// Azure inventory slots that have no TG item slot yet
#define HUD_ROGUE_SLOT_STUB(slot_name) "rogue_slot_stub:[slot_name]"

/// Sent to the mob when its rogue weapon-intent widget is clicked: (index, list/modifiers). Return COMPONENT_ROGUE_INTENT_HANDLED if the click was consumed.
#define COMSIG_MOB_ROGUE_HUD_INTENT_CLICK "mob_rogue_hud_intent_click"
	#define COMPONENT_ROGUE_INTENT_HANDLED (1<<0)
