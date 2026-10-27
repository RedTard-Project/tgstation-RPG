#define ITEM_SLOT_ROGUE_SHIRT (1<<19)
#define ITEM_SLOT_ROGUE_CLOAK (1<<20)
#define ITEM_SLOT_ROGUE_WRISTS (1<<21)
#define ITEM_SLOT_ROGUE_RING (1<<22)
#define ITEM_SLOT_ROGUE_MOUTH (1<<23)
#define ITEM_SLOTS_ROGUE (ITEM_SLOT_ROGUE_SHIRT|ITEM_SLOT_ROGUE_CLOAK|ITEM_SLOT_ROGUE_WRISTS|ITEM_SLOT_ROGUE_RING|ITEM_SLOT_ROGUE_MOUTH)
#define ROGUE_SLOT_LIST list(ITEM_SLOT_ROGUE_SHIRT, ITEM_SLOT_ROGUE_CLOAK, ITEM_SLOT_ROGUE_WRISTS, ITEM_SLOT_ROGUE_RING, ITEM_SLOT_ROGUE_MOUTH)
#define ROGUE_RING_SLOTS 4
#define ROGUE_RING_ID(index) "ring[index]"
#define HUD_ROGUE_RING_SLOT(index) ROGUE_RING_ID(index)
#define ROGUE_BACK_RIGHT 2
#define HUD_ROGUE_BACKR "backr"

#define ROGUE_FEMALE_SUFFIX "_f"

/// Frame size of the baked held, back and hip sheets (rockhill/icons/baked).
#define ROGUE_BAKED_SIZE 64
#define ROGUE_OVERLAY_HANDS_BEHIND "hands_behind"
#define ROGUE_OVERLAY_BACK_LEFT "backl"
#define ROGUE_OVERLAY_HIP_LEFT "hipl"
#define ROGUE_OVERLAY_HIP_RIGHT "hipr"
#define ROGUE_OVERLAY_SLEEVES_SUIT "suit_sleeves"
#define ROGUE_OVERLAY_SLEEVES_GLOVES "gloves_sleeves"
#define ROGUE_OVERLAY_SLEEVES_UNIFORM "uniform_sleeves"
#define ROGUE_OVERLAY_SLEEVES_SHOES "shoes_sleeves"

#define STRIPPABLE_ITEM_ROGUE_SHIRT "shirt"
#define STRIPPABLE_ITEM_ROGUE_CLOAK "cloak"
#define STRIPPABLE_ITEM_ROGUE_WRISTS "wrists"
#define STRIPPABLE_ITEM_ROGUE_MOUTH "mouth"
#define STRIPPABLE_ITEM_ROGUE_BACKR HUD_ROGUE_BACKR
#define STRIPPABLE_ITEM_ROGUE_RING(index) ROGUE_RING_ID(index)

#define ROGUE_SHIRT_LAYER (UNIFORM_LAYER - 0.5)
#define ROGUE_RING_LAYER (GLOVES_LAYER + 0.5)
#define ROGUE_WRISTS_LAYER (GLOVES_LAYER + 0.75)
#define ROGUE_CLOAK_LAYER (NECK_LAYER - 0.25)
#define ROGUE_TABARD_LAYER (SUIT_LAYER - 0.5)
#define ROGUE_UNDER_CLOAK_LAYER (BELT_LAYER - 0.1)
#define ROGUE_SHIRT_SLEEVE_LAYER (BELT_LAYER - 0.2)
#define ROGUE_WRISTS_SLEEVE_LAYER (BELT_LAYER - 0.3)
#define ROGUE_ARMOR_SLEEVE_LAYER (BELT_LAYER - 0.4)
#define ROGUE_GLOVES_SLEEVE_LAYER (BELT_LAYER - 0.5)
#define ROGUE_LEG_SLEEVE_LAYER (SHOES_LAYER - 0.2)
#define ROGUE_SHOES_SLEEVE_LAYER (SHOES_LAYER - 0.3)
#define ROGUE_MOUTH_LAYER (FACEMASK_LAYER - 0.5)
#define ROGUE_BACKR_LAYER (BACK_LAYER + 0.5)

/// One sheet for Ratwood's goblin, orc and dark elf bodies, their ears, tusks and the hairstyles of Ratwood's NPCs
/// (rockhill/species.dm; the porter makes it).
#define ROGUE_BODIES_ICON 'modular_redtard/rockhill/icons/bodies.dmi'
/// Offset keys of the module's own worn layers beside TG's OFFSET_*: Ratwood shifts them by species and sex as well.
#define ROGUE_OFFSET_SHIRT "rogue_shirt"
#define ROGUE_OFFSET_CLOAK "rogue_cloak"
#define ROGUE_OFFSET_WRISTS "rogue_wrists"
#define ROGUE_OFFSET_MOUTH "rogue_mouth"
#define ROGUE_OFFSET_RING "rogue_ring"
/// A goblin's body: worn things show only as the goblin's own armor and helmet (rockhill/species.dm).
#define TRAIT_ROGUE_GOBLIN_BODY "rogue_goblin_body"

/// Percent chance per step that something which can be spat out slips out of the mouth (clothing/mouth.dm).
#define ROGUE_MOUTH_SLIP_CHANCE rogue_value("mouth_slip_chance")
/// Ratwood burns a smoke down by one every object tick of two seconds (clothing/smoking.dm).
#define ROGUE_SMOKE_TICK_SECONDS 2
