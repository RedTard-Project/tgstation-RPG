// Stage 2: survival and daily life. Cross-file defines of the survival module.

/// Ratwood screen alerts of food buffs and fire rest (icons/mob/screen_alert.dmi: foodbuff, campfire, fireplace).
#define ROGUE_SURVIVAL_ALERTS 'modular_redtard/survival/icons/alerts.dmi'

/// Ratwood get_cooktime_divisor() (modular/Neu_Food/cooking_helpers.dm): how many times faster a cook of each cooking rank (0-6) works.
#define ROGUE_COOK_DIVISORS list(0.75, 1, 1.5, 2, 2.5, 3, 3.5)
/// The burnt result of Ratwood cooking (heating_act() without a fitting result, burned food).
#define ROGUE_BURNT_FOOD /obj/item/reagent_containers/food/snacks/badrecipe

/// Ratwood stress points to TG mood points (a stress event of -1 is a mood event of +2).
#define ROGUE_STRESS_TO_MOOD 2
/// Ratwood nausea to TG disgust (100 nausea, a raw bite, makes Ratwood vomit; 40 disgust is TG's "gross" and a bit more).
#define ROGUE_NAUSEA_TO_DISGUST 0.4

/// Body heat the Ratwood fires give per heat level of the floor and Life tick (species.dm handle_environment(): heat * 4).
#define ROGUE_FLOOR_WARMTH_PER_HEAT 4
/// Ratwood floor heat is capped at 5 (floor.dm set_heat()).
#define ROGUE_FLOOR_HEAT_MAX 5
/// Body heat of warming the hands at a campfire, fireplace or hearth (Ratwood +75), up to normal.
#define ROGUE_HAND_WARMTH 75
/// Body heat of warming the hands at a brazier (Ratwood firebowl attack_right(): +10).
#define ROGUE_BRAZIER_WARMTH 10
/// The rest by a fire warms a body this much colder than normal (Ratwood: under 300 K)...
#define ROGUE_FIRE_REST_COLD 10
/// ...by this much a second (Ratwood campfire_stamina: +5).
#define ROGUE_FIRE_REST_WARMTH 5

// Ratwood traits the survival mechanics check; the porter writes only the traits its roles use, so define the missing ones.
#ifndef TRAIT_NASTY_EATER
#define TRAIT_NASTY_EATER "Inhumen Digestion"
#endif
#ifndef TRAIT_ORGAN_EATER
#define TRAIT_ORGAN_EATER "Blessing of Graggar"
#endif
#ifndef TRAIT_WILD_EATER
#define TRAIT_WILD_EATER "Beastly Digestion"
#endif
#ifndef TRAIT_RAW_EATER
#define TRAIT_RAW_EATER "Raw Diet"
#endif
#ifndef TRAIT_ROT_EATER
#define TRAIT_ROT_EATER "Blessing of Pestra"
#endif
#ifndef TRAIT_NOSLEEP
#define TRAIT_NOSLEEP "Fatal Insomnia"
#endif
#ifndef TRAIT_FASTSLEEP
#define TRAIT_FASTSLEEP "Fast Sleeper"
#endif
#ifndef TRAIT_BETTER_SLEEP
#define TRAIT_BETTER_SLEEP "Better Sleep"
#endif
