// Ratwood's potions, poisons and blessed water (alchemy/). Each reagent keeps its own effects as Ratwood's data on its type
// (rogue_* vars, per Ratwood tick); what the reagents share is a mechanics value (config/redtard/mechanics/values/alchemy.txt).

/// Least units in the blood for a potion's healing or an antidote's cleansing to work (Ratwood volume > 0.99).
#define ROGUE_POTION_MIN_VOLUME rogue_value("potion_min_volume")
/// Least units in the blood for a poison to work (Ratwood volume > 0.09).
#define ROGUE_POISON_MIN_VOLUME rogue_value("poison_min_volume")

/// The temperature potion: how long a sip keeps the body's heat in bounds, the bounds, and the step a second.
#define ROGUE_TEMPERATURE_POTION_TIME rogue_value("temperature_potion_time")
#define ROGUE_TEMPERATURE_POTION_MAX rogue_value("temperature_potion_max")
#define ROGUE_TEMPERATURE_POTION_MIN rogue_value("temperature_potion_min")
#define ROGUE_TEMPERATURE_POTION_STEP rogue_value("temperature_potion_step")
/// How long the fire resistance potion keeps fire off.
#define ROGUE_FIRE_RESIST_TIME rogue_value("fire_resist_time")

/// The Alchemy skill, which brewing and grinding answer to and teach.
#define ROGUE_ALCHEMY_SKILL /datum/attribute/skill/craft/alchemy

// ---------------------------------------------------------------------------------------------------------------------------
// Vibelin's reagents (alchemy/potions.dm, medicines.dm, poisons.dm, toxins.dm, buffs.dm): the behaviour of a type is what the
// engine of /datum/reagent (potions.dm) does from the channels and effects it names; the number of each is alch_rg_<key>_<channel>
// (rogue_rg(), a number read once for each revision of the mechanics numbers), its rate of metabolism alch_rg_rate_<class>.

/// Vibelin's chemical effects the medicine set (combat/_medical_defines.dm) has no key for; the readers of the new ones (organs,
/// energy, movement, size) are the medicine's and the body's (the builder's line in the report of ВА1а).
#define ROGUE_CE_STIMULANT "stimulant"
#define ROGUE_CE_BRAIN_REGEN "brainfix"
#define ROGUE_CE_ENERGETIC "energetic"
#define ROGUE_CE_SHRINKING "shrink"
#define ROGUE_CE_ENLARGING "enlarging"
#define ROGUE_CE_BOUNCY "bouncy"

/// What a reagent does every tick it is in the blood (a channel is a bit of /datum/reagent/rogue_channels, its number the
/// units of that kind added to the body each Vibelin tick: damage and sickness added, so a heal is a minus; blood, wounds,
/// energy and mana are given, so a plus).
#define ROGUE_RG_BRUTE (1<<0)
#define ROGUE_RG_BURN (1<<1)
#define ROGUE_RG_TOX (1<<2)
#define ROGUE_RG_OXY (1<<3)
#define ROGUE_RG_BRAIN (1<<4)
#define ROGUE_RG_EYES (1<<5)
#define ROGUE_RG_LUNGS (1<<6)
#define ROGUE_RG_HEART (1<<7)
#define ROGUE_RG_STAMINA (1<<8)
#define ROGUE_RG_WOUNDS (1<<9)
#define ROGUE_RG_BLOOD (1<<10)
#define ROGUE_RG_ENERGY (1<<11)
#define ROGUE_RG_MANA (1<<12)
#define ROGUE_RG_NAUSEA (1<<13)
#define ROGUE_RG_DIZZY (1<<14)
#define ROGUE_RG_JITTER (1<<15)
#define ROGUE_RG_CONFUSION (1<<16)
#define ROGUE_RG_DROWSY (1<<17)
#define ROGUE_RG_BLUR (1<<18)
/// The channels of damage, the ones a cure lowers: their numbers are taken as minus their size (rogue_minus_channels).
#define ROGUE_RG_HEALS (ROGUE_RG_BRUTE|ROGUE_RG_BURN|ROGUE_RG_TOX|ROGUE_RG_OXY|ROGUE_RG_BRAIN|ROGUE_RG_EYES|ROGUE_RG_LUNGS|ROGUE_RG_HEART|ROGUE_RG_STAMINA)

/// The chemical effects a reagent keeps while it is in the body (/datum/reagent/rogue_effects).
#define ROGUE_CEF_PAINKILLER (1<<0)
#define ROGUE_CEF_ANTIBIOTIC (1<<1)
#define ROGUE_CEF_STABLE (1<<2)
#define ROGUE_CEF_PULSE (1<<3)
#define ROGUE_CEF_BLOODRESTORE (1<<4)
#define ROGUE_CEF_OXYGENATED (1<<5)
#define ROGUE_CEF_ORGAN_REGEN (1<<6)
#define ROGUE_CEF_BRAIN_REGEN (1<<7)
#define ROGUE_CEF_ENERGETIC (1<<8)
#define ROGUE_CEF_STIMULANT (1<<9)
#define ROGUE_CEF_SHRINKING (1<<10)
#define ROGUE_CEF_ENLARGING (1<<11)
#define ROGUE_CEF_BOUNCY (1<<12)

/// The volume a reagent's channels wait for (/datum/reagent/rogue_gate): none, a potion's, a poison's.
#define ROGUE_GATE_NONE 0
#define ROGUE_GATE_POTION 1
#define ROGUE_GATE_POISON 2

/// What a reagent does to the limb a bandage lets it into (/datum/reagent/rogue_absorbs, rogue_bodypart_absorb()).
#define ROGUE_ABS_BRUTE (1<<0)
#define ROGUE_ABS_BURN (1<<1)
#define ROGUE_ABS_INJURY_HEAL (1<<2)
#define ROGUE_ABS_INJURY_GERMS (1<<3)
#define ROGUE_ABS_LIMB_GERMS (1<<4)
#define ROGUE_ABS_SALVE (1<<5)
#define ROGUE_ABS_DISINFECT (1<<6)
/// With these it works on the injuries of burns only.
#define ROGUE_ABS_FIRE_ONLY (1<<7)
/// With these the reagent goes into the body besides (Vibelin on_bodypart_absorb() returned TRUE).
#define ROGUE_ABS_ENTERS (1<<8)

/// Every kind of injury (combat/_medical_defines.dm ROGUE_INJURY_*).
#define ROGUE_INJURY_ANY (ROGUE_INJURY_BLUNT|ROGUE_INJURY_SLASH|ROGUE_INJURY_PUNCTURE|ROGUE_INJURY_BITE|ROGUE_INJURY_LASH|ROGUE_INJURY_BURN|ROGUE_INJURY_INTENSE_BURN|ROGUE_INJURY_INTERNAL|ROGUE_INJURY_DIVINE)

/// Vibelin species a poison picks its victims from (Vibelin SPECIES_CANNIBAL_MEN, SPECIES_CANNIBALISM_KOBOLD, ALL_RACES_LIST).
#define ROGUE_POOL_ALL 0
#define ROGUE_POOL_MEN 1
#define ROGUE_POOL_KOBOLD 2
