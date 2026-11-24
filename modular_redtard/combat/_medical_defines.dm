// Medical model defines (block VR1, Vibelin base). Shared by injuries, crits,
// physiology and treatment. Names are fixed by the block contract: do not rename.
// Only states and identifiers live here, never balance numbers (those go through
// rogue_value()). No #undef: other files of the module read these.

// ~injury kinds (bit flags, one per /datum/rogue_injury subtype family)
#define ROGUE_INJURY_BLUNT (1<<0)
#define ROGUE_INJURY_SLASH (1<<1)
#define ROGUE_INJURY_PUNCTURE (1<<2)
#define ROGUE_INJURY_BITE (1<<3)
#define ROGUE_INJURY_LASH (1<<4)
#define ROGUE_INJURY_BURN (1<<5)
#define ROGUE_INJURY_INTENSE_BURN (1<<6)
#define ROGUE_INJURY_INTERNAL (1<<7)
#define ROGUE_INJURY_DIVINE (1<<8)

/// Injury kinds a needle can sew shut.
#define ROGUE_INJURY_SEWABLE (ROGUE_INJURY_SLASH|ROGUE_INJURY_PUNCTURE|ROGUE_INJURY_BITE|ROGUE_INJURY_LASH)
/// Injury kinds counted as burn damage.
#define ROGUE_INJURY_FIRE (ROGUE_INJURY_BURN|ROGUE_INJURY_INTENSE_BURN)
/// Injury kinds counted as brute damage.
#define ROGUE_INJURY_BRUTE (ROGUE_INJURY_SEWABLE|ROGUE_INJURY_BLUNT|ROGUE_INJURY_INTERNAL|ROGUE_INJURY_DIVINE)

// ~injury treatment flags (/datum/rogue_injury/var/injury_flags)
/// Bandaged: does not bleed while the bandage holds.
#define ROGUE_INJ_BANDAGED (1<<0)
/// Sutured: does not bleed.
#define ROGUE_INJ_SUTURED (1<<1)
/// Salved: infection does not progress.
#define ROGUE_INJ_SALVED (1<<2)
/// Clamped: does not bleed.
#define ROGUE_INJ_CLAMPED (1<<3)
/// Disinfected: germs wiped and do not progress.
#define ROGUE_INJ_DISINFECTED (1<<4)
/// Retracted: gives surgical access.
#define ROGUE_INJ_RETRACTED (1<<5)
/// Surgical incision: never autoheals.
#define ROGUE_INJ_SURGICAL (1<<6)

// ~chemical effects (keys of /mob/living/var/list/rogue_chem_effects)
#define ROGUE_CE_PAINKILLER "painkiller"
#define ROGUE_CE_ANTIBIOTIC "antibiotic"
#define ROGUE_CE_STABLE "stable"
#define ROGUE_CE_PULSE "pulse"
#define ROGUE_CE_BLOODRESTORE "bloodrestore"
#define ROGUE_CE_OXYGENATED "oxygen"
#define ROGUE_CE_TOXIN "toxins"
#define ROGUE_CE_ANTITOX "antitox"
#define ROGUE_CE_ORGAN_REGEN "organ_regen"

// ~pulse states (/mob/living/carbon/var/rogue_pulse), states and not balance numbers
#define ROGUE_PULSE_NONE 0
#define ROGUE_PULSE_SLOW 1
#define ROGUE_PULSE_NORM 2
#define ROGUE_PULSE_FAST 3
#define ROGUE_PULSE_FASTER 4
#define ROGUE_PULSE_THREADY 5

/// applied_items slot of a bodypart for a splint (TG has LIMB_ITEM_GAUZE and LIMB_ITEM_TOURNIQUET).
#define ROGUE_LIMB_ITEM_SPLINT "rogue_splint"
