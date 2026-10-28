// Ratwood's potions, poisons and blessed water (alchemy/). Each reagent keeps its own effects as Ratwood's data on its type
// (rogue_* vars, per Ratwood tick); what the reagents share is a mechanics value (config/redtard/mechanics/values/alchemy.txt).

/// Units of a health potion over which the body sheds the excess, and how much a Ratwood tick (no overhealing).
#define ROGUE_POTION_OVERHEAL_VOLUME rogue_value("potion_overheal_volume")
#define ROGUE_POTION_OVERHEAL_SHED rogue_value("potion_overheal_shed")
/// Least units in the blood for a potion's healing or an antidote's cleansing to work (Ratwood volume > 0.99).
#define ROGUE_POTION_MIN_VOLUME rogue_value("potion_min_volume")
/// Least units in the blood for a poison to work (Ratwood volume > 0.09).
#define ROGUE_POISON_MIN_VOLUME rogue_value("poison_min_volume")
/// Units of a stamina poison over which the body sheds the excess, and how much a Ratwood tick.
#define ROGUE_STAMINA_POISON_CAP rogue_value("stamina_poison_cap")
#define ROGUE_STAMINA_POISON_SHED rogue_value("stamina_poison_shed")

/// Buff potions: the stat they give while in the blood, how long it lingers after the last of it, what of another buff potion
/// a Ratwood tick purges, and the overdose.
#define ROGUE_BUFF_POTION_STAT rogue_value("buff_potion_stat")
#define ROGUE_BUFF_POTION_LINGER rogue_value("buff_potion_linger")
#define ROGUE_BUFF_POTION_PURGE rogue_value("buff_potion_purge")
#define ROGUE_BUFF_POTION_OVERDOSE rogue_value("buff_potion_overdose")
#define ROGUE_BUFF_OVERDOSE_TOXIN rogue_value("buff_overdose_toxin")
#define ROGUE_BUFF_OVERDOSE_JITTER rogue_value("buff_overdose_jitter")
/// The temperature potion: how long a sip keeps the body's heat in bounds, the bounds, and the step a second.
#define ROGUE_TEMPERATURE_POTION_TIME rogue_value("temperature_potion_time")
#define ROGUE_TEMPERATURE_POTION_MAX rogue_value("temperature_potion_max")
#define ROGUE_TEMPERATURE_POTION_MIN rogue_value("temperature_potion_min")
#define ROGUE_TEMPERATURE_POTION_STEP rogue_value("temperature_potion_step")
/// How long the fire resistance potion keeps fire off.
#define ROGUE_FIRE_RESIST_TIME rogue_value("fire_resist_time")

/// The Alchemy skill, which brewing and grinding answer to and teach.
#define ROGUE_ALCHEMY_SKILL /datum/attribute/skill/craft/alchemy
/// The cauldron (alchemy/brewing.dm): how long a brew boils, the points of an ingredient's leanings, what a recipe needs, how
/// often it bubbles aloud, what a brew teaches.
#define ROGUE_CAULDRON_BREW_TICKS rogue_value("cauldron_brew_ticks")
#define ROGUE_CAULDRON_MAJOR_POINTS rogue_value("cauldron_major_points")
#define ROGUE_CAULDRON_MED_POINTS rogue_value("cauldron_med_points")
#define ROGUE_CAULDRON_MINOR_POINTS rogue_value("cauldron_minor_points")
#define ROGUE_CAULDRON_MIN_POINTS rogue_value("cauldron_min_points")
#define ROGUE_CAULDRON_BUBBLE_CHANCE rogue_value("cauldron_bubble_chance")
#define ROGUE_CAULDRON_XP_PER_INT rogue_value("cauldron_xp_per_int")
#define ROGUE_CAULDRON_BUBBLE_SOUND 'sound/effects/bubbles/bubbles.ogg'
#define ROGUE_CAULDRON_DONE_SOUND 'modular_redtard/rockhill/sound/misc/smelter_fin.ogg'
/// The mortar: how long grinding takes and what it teaches, Dendor's blessing of tree sap seeds, natural bone's bone meal.
#define ROGUE_GRIND_TIME rogue_value("grind_time")
#define ROGUE_GRIND_XP_PER_INT rogue_value("grind_xp_per_int")
#define ROGUE_SEED_BLESSING_WATER rogue_value("seed_blessing_water")
#define ROGUE_SEED_BLESSING_XP rogue_value("seed_blessing_xp")
#define ROGUE_GRIND_BONEMEAL_CHANCE_LOW rogue_value("grind_bonemeal_chance_low")
#define ROGUE_GRIND_BONEMEAL_CHANCE_HIGH rogue_value("grind_bonemeal_chance_high")
#define ROGUE_GRIND_SOUND 'modular_redtard/rockhill/sound/foley/mortarpestle.ogg'
/// Perception and intelligence (their mean) at which one smells an ingredient's leanings without Alchemy.
#define ROGUE_SNIFF_MAJOR_KEEN rogue_value("sniff_major_keen")
#define ROGUE_SNIFF_MED_KEEN rogue_value("sniff_med_keen")
#define ROGUE_SNIFF_MINOR_KEEN rogue_value("sniff_minor_keen")
