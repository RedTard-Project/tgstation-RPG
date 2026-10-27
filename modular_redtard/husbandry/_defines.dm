// Stage 4: husbandry and taming. Cross-file defines of the husbandry module.

/// Ratwood's food meter of a beast (simple_animal.dm food): full at 100, looks for food at 50 and below.
#define ROGUE_BEAST_FOOD_MAX 100
#define ROGUE_BEAST_HUNGRY 50
/// What one meal or one hand-feeding fills (Ratwood +30).
#define ROGUE_BEAST_MEAL 30
/// Ratwood drains the meter and fills production by one point a Life (2 seconds).
#define ROGUE_BEAST_FOOD_PER_SECOND 0.5
#define ROGUE_BEAST_PRODUCTION_MAX 100
/// Hand-feeding heals (Ratwood adjustHealth(-rand(10, 20))).
#define ROGUE_FEED_HEAL_MIN 10
#define ROGUE_FEED_HEAL_MAX 20
/// Starvation (not in Ratwood): a kept beast with an empty meter this long starts losing this share of its health a second.
#define ROGUE_BEAST_STARVE_DELAY (10 MINUTES)
#define ROGUE_BEAST_STARVE_DAMAGE 0.005

/// A mother needs this much in her to give birth (Ratwood make_babies(): food < 10).
#define ROGUE_BREED_FOOD 10
/// Young of hers within this many tiles that stop her giving birth again, and how many (Ratwood: view(7), 3).
#define ROGUE_BREED_RANGE 7
#define ROGUE_BREED_MAX_YOUNG 3
/// How long a mother keeps trying to reach the father before she gives up until her next season.
#define ROGUE_BREED_SEEK_TIME (30 SECONDS)
/// Growth of the young a second: Ratwood 0.5 a Life (2 seconds) to 100; the chick rand(1, 2) a Life.
#define ROGUE_YOUNG_GROWTH 0.25
#define ROGUE_CHICK_GROWTH 0.75

/// What laying an egg costs a hen, and what she must have over (Ratwood chicken Life(): production > 29, -30).
#define ROGUE_EGG_PRODUCTION 30
/// Chance an egg is fertile: a nesting hen (Ratwood rogue chicken) and a fed one (Ratwood friendly chicken).
#define ROGUE_EGG_FERTILE_CHANCE 50
#define ROGUE_FED_EGG_FERTILE_CHANCE 25
/// How far a hen looks for a nest or nesting stuff (Ratwood oview() at its world.view, 15x15).
#define ROGUE_NEST_SIGHT 7
/// No fertile eggs while this many chickens live (Ratwood MAX_CHICKENS).
#define ROGUE_MAX_CHICKENS 50
/// A fed hen lays from a store of eggs: 1-4 a meal, at most 8 (Ratwood friendly chicken attackby()).
#define ROGUE_FED_EGGS_MAX 8
/// A fertile egg grows rand(1, 2) every 2 seconds to 100 (Ratwood egg process()); TG's fertile_egg multiplies by the tick's seconds.
#define ROGUE_EGG_HATCH_GROWTH 200

/// How long held-out food or a beckon draws a beast, and how long a hen walks to a nest or nesting stuff (Ratwood return_action timers).
#define ROGUE_LURE_TIME (3 SECONDS)
#define ROGUE_NEST_SEEK_TIME (15 SECONDS)
/// Tiles a shooed tamed beast looks for someone to set upon (Ratwood retaliate/rogue vision_range).
#define ROGUE_SHOO_RANGE 5
/// Taming an angry beast: it calms down and takes to the feeder with this chance, else it stays wild (Ratwood retaliate/rogue tamed()).
#define ROGUE_TAME_ANGRY_CHANCE 23

/// Truffles under dirt in the woods (Ratwood trufflepig.dm): chance a dirt tile hides them, how far the pig smells, the pig's
/// patience before it sulks, what a potato takes off it, and the digging.
#define ROGUE_TRUFFLE_CHANCE 4
#define ROGUE_TRUFFLE_SNIFF_RANGE 5
#define ROGUE_PIG_HANGRY_MAX 9
#define ROGUE_PIG_POTATO_RELIEF 2
#define ROGUE_TRUFFLE_DIG_TIME (3 SECONDS)

/// Where a lured beast walks (held-out food, a beckon), and the nest or nesting stuff a hen walks to.
#define BB_ROGUE_LURE_TARGET "rogue_lure_target"
#define BB_ROGUE_NEST_TARGET "rogue_nest_target"

/// Source of the traits the husbandry module gives.
#define ROGUE_HUSBANDRY_TRAIT "rogue_husbandry"
