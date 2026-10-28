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

/// State of one sleeve or trouser leg (clothing/sleeve_status.dm; Ratwood SLEEVE_*, the porter maps them): whole, torn off, rolled
/// up, or one that can be neither torn nor rolled.
#define ROGUE_SLEEVE_NORMAL 0
#define ROGUE_SLEEVE_TORN 1
#define ROGUE_SLEEVE_ROLLED 2
#define ROGUE_SLEEVE_NOMOD 3
/// Slots whose worn sprite and sleeves follow the arms, and the ones that follow the legs (Ratwood armsindex, legsindex, footindex).
#define ROGUE_SLEEVE_ARM_SLOTS (ITEM_SLOT_OCLOTHING | ITEM_SLOT_GLOVES | ITEM_SLOT_ROGUE_SHIRT | ITEM_SLOT_ROGUE_WRISTS)
#define ROGUE_SLEEVE_LEG_SLOTS (ITEM_SLOT_ICLOTHING | ITEM_SLOT_FEET)
/// Masks that cut one side out of a worn sprite, "<r|l>_<sleevetype>" with "_f" for women (Ratwood helpers/dismemberment.dmi).
#define ROGUE_SLEEVE_MASK_ICON 'modular_redtard/clothing/icons/sleeve_masks.dmi'
/// Percent chance per point of strength that a sleeve tears off (Ratwood STR * 8).
#define ROGUE_SLEEVE_TEAR_PER_STRENGTH rogue_value("sleeve_tear_per_strength")
/// Deciseconds of pulling at a sleeve before it tears or holds.
#define ROGUE_SLEEVE_TEAR_TIME rogue_value("sleeve_tear_time")
#define ROGUE_CLOTH_RIP_SOUND 'modular_redtard/rockhill/sound/foley/cloth_rip.ogg'

/// Ratwood's body parts TG has no flags for (code/__DEFINES/inventory.dm VITALS, MOUTH, NOSE, EARS, RIGHT_EYE, LEFT_EYE, HAIR),
/// above TG's own (CHEST to NECK, 1<<0 to 1<<11). For TG the porters fold them into body_parts_covered (the face and the skull
/// into HEAD, the vitals into CHEST) and keep Ratwood's coverage whole in rogue_coverage (rockhill/port_data.dm), with TG's
/// flags for the parts TG has: what a blow on a precise zone looks for (combat/armor.dm) and what a raised visor bares
/// (clothing/adjustable.dm).
#define ROGUE_COVER_VITALS (1<<12)
#define ROGUE_COVER_MOUTH (1<<13)
#define ROGUE_COVER_NOSE (1<<14)
#define ROGUE_COVER_EARS (1<<15)
#define ROGUE_COVER_RIGHT_EYE (1<<16)
#define ROGUE_COVER_LEFT_EYE (1<<17)
/// Ratwood HAIR, the skull zone.
#define ROGUE_COVER_HAIR (1<<18)
#define ROGUE_COVER_EYES (ROGUE_COVER_RIGHT_EYE | ROGUE_COVER_LEFT_EYE)
/// Ratwood FACE: mouth, nose, eyes and ears.
#define ROGUE_COVER_FACE (ROGUE_COVER_MOUTH | ROGUE_COVER_NOSE | ROGUE_COVER_EYES | ROGUE_COVER_EARS)
/// The parts of the head TG's HEAD stands for along with the head itself.
#define ROGUE_COVER_HEAD_PARTS (ROGUE_COVER_FACE | ROGUE_COVER_HAIR)

/// Sprite suffix of a raised visor, a lowered hood or a pulled-down mask (clothing/adjustable.dm; Ratwood "<icon_state>_t").
#define ROGUE_ADJUSTED_SUFFIX "_t"
/// Slots an adjustable item is adjusted in.
#define ROGUE_ADJUST_SLOTS (ITEM_SLOT_HEAD | ITEM_SLOT_MASK | ITEM_SLOT_NECK)
#define ROGUE_ADJUST_VISOR_SOUND 'modular_redtard/clothing/sound/visor.ogg'
#define ROGUE_ADJUST_CLOAK_SOUND 'modular_redtard/clothing/sound/cloak (3).ogg'
#define ROGUE_ADJUST_MASK_SOUND 'modular_redtard/clothing/sound/rummaging-03.ogg'
#define ROGUE_ADJUST_CHAIN_SOUND 'modular_redtard/clothing/sound/chain_equip.ogg'
#define ROGUE_ADJUST_MANTLE_SOUND 'modular_redtard/clothing/sound/equip_armor_chain.ogg'

/// The sun blinds these eyes now (clothing/sun_glare.dm): combat/fov.dm closes both sides of the view.
#define TRAIT_ROGUE_SUN_BLINDED "rogue_sun_blinded"
#define ROGUE_SUN_GLARE_ICON 'modular_redtard/clothing/icons/sun_glare.dmi'
/// Perception the sun takes from light-sensitive eyes (Ratwood sun_blinded: -5).
#define ROGUE_SUN_BLIND_PERCEPTION rogue_value("sun_blind_perception")
#define ROGUE_SUN_GLARE_TICK (2 SECONDS)
/// Ratwood stressevent/sunlit: +2 stress for a minute, renewed while the sky is overhead.
#define ROGUE_SUNLIT_MOOD (-2 * ROGUE_STRESS_TO_MOOD)
#define ROGUE_SUNLIT_MOOD_TIME (1 MINUTES)
