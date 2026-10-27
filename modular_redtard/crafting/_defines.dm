// Ratwood item quality tiers (code/__DEFINES/item_quality.dm): ingots carry the smelting tier, forged goods the forging tier.
#define ROGUE_QUALITY_RUINED -1
#define ROGUE_QUALITY_AWFUL 0
#define ROGUE_QUALITY_CRUDE 1
#define ROGUE_QUALITY_ROUGH 2
#define ROGUE_QUALITY_STANDARD 3
#define ROGUE_QUALITY_FINE 4
#define ROGUE_QUALITY_FLAWLESS 5
#define ROGUE_QUALITY_MASTERWORK 6

// Ratwood smelting quality (SMELTERY_LEVEL_*): what a smelter stamps on the ingot, the same scale as the item quality.
#define ROGUE_SMELT_SPOIL 1
#define ROGUE_SMELT_EXCELLENT 6

// Ratwood skill ranks (SKILL_LEVEL_*) as the module's ranks (ROGUE_SKILL_RANK, 0-6).
#define ROGUE_RANK_NONE 0
#define ROGUE_RANK_NOVICE 1
#define ROGUE_RANK_APPRENTICE 2
#define ROGUE_RANK_JOURNEYMAN 3
#define ROGUE_RANK_EXPERT 4
#define ROGUE_RANK_MASTER 5
#define ROGUE_RANK_LEGENDARY 6

// Stages of a bar on the anvil (Ratwood FORGING_STAGE_*): being worked, or finished and waiting for the quench.
#define ROGUE_FORGING_ACTIVE 1
#define ROGUE_FORGING_COMPLETE 2

/// Seconds a bar stays hot after the forge or the smelter (Ratwood forge heat_time, smelter tongs).
#define ROGUE_BAR_HEAT_TIME (20 SECONDS)

#define ROGUE_SMITH_SOUNDS list('modular_redtard/rockhill/sound/items/bsmith1.ogg', 'modular_redtard/rockhill/sound/items/bsmith2.ogg', 'modular_redtard/rockhill/sound/items/bsmith3.ogg', 'modular_redtard/rockhill/sound/items/bsmith4.ogg')
#define ROGUE_SMITH_FAIL_SOUND 'modular_redtard/rockhill/sound/items/bsmithfail.ogg'
#define ROGUE_SEW_SOUND 'modular_redtard/rockhill/sound/foley/sewflesh.ogg'

/// A sleeping mob counts as asleep for the dream bank (Ratwood is_considered_sleeping()).
#define ROGUE_IS_DREAMING(mob) (mob.IsSleeping())
