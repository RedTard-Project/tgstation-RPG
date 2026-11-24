/// Magic items (block ВМ1, ВМ1в): tomes with charges (books.dm), binding a tome (spellcraft.dm), scrolls, spellstones and
/// wands (spell_items.dm), items that bind magic (antimagic.dm). Numbers: magic_items.txt.

/// Vibelin's tomes: icons/roguetown/items/books.dmi and wands.dmi, copied under their own names.
#define ROGUE_TOMES_ICON 'modular_redtard/magic/icons/books.dmi'
#define ROGUE_WANDS_ICON 'modular_redtard/magic/icons/wands.dmi'
/// The port's held sprites of a tome (one sprite for every cover, as the port's own tomes).
#define ROGUE_TOMES_LEFTHAND 'modular_redtard/rockhill/icons/baked/roguetown/items/books_lefthand.dmi'
#define ROGUE_TOMES_RIGHTHAND 'modular_redtard/rockhill/icons/baked/roguetown/items/books_righthand.dmi'
#define ROGUE_TOME_OPEN_SOUND 'modular_redtard/rockhill/sound/items/book_open.ogg'
#define ROGUE_TOME_CLOSE_SOUND 'modular_redtard/rockhill/sound/items/book_close.ogg'
#define ROGUE_TOME_PAGE_SOUND 'modular_redtard/rockhill/sound/items/book_page.ogg'

/// Vibelin's ladder of tomes, worst to best (spellbooks/*.dm): the key of a tome's numbers, magic_book_<tier>_*.
#define ROGUE_TOME_TIER_HORRIBLE "horrible"
#define ROGUE_TOME_TIER_MID "mid"
#define ROGUE_TOME_TIER_APPRENTICE "apprentice"
#define ROGUE_TOME_TIER_ADEPT "adept"
#define ROGUE_TOME_TIER_EXPERT "expert"
#define ROGUE_TOME_TIER_MASTER "master"
#define ROGUE_TOME_TIER_LEGENDARY "legendary"

/// Vibelin SPELLOBJECT_* (__DEFINES/magic.dm): how a scroll, spellstone or wand casts what it holds.
/// Point and click to cast the first spell held, instead of giving the spells while held.
#define ROGUE_SPELLOBJECT_HIJACK_CLICK (1<<0)
/// A failed aim strikes someone at random, and the names of the spells held are hidden.
#define ROGUE_SPELLOBJECT_CHAOTIC (1<<1)
/// Gone once its last charge is spent.
#define ROGUE_SPELLOBJECT_CONSUMABLE (1<<2)
/// The buttons of the spells held show on the item.
#define ROGUE_SPELLOBJECT_VISUAL (1<<3)
/// Never misses: no aiming roll.
#define ROGUE_SPELLOBJECT_STABLE (1<<4)

/// The source of the spell block an item puts on its wearer (Ratwood's mana binding collar and gloves).
#define ROGUE_ANTIMAGIC_ITEM_TRAIT "rogue_antimagic_item"
