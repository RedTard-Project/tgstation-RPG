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
