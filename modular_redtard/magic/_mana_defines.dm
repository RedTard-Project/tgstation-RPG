// Mana (block VM1a): the pools of people, items, structures and leylines (magic/mana.dm, mana_pools.dm, batteries.dm,
// leylines.dm, pylons.dm, overload.dm). Kept in a file of its own so the other VM1 files can use them; nothing here is
// undefined again.

/// What a pool draws on by itself (/datum/rogue_mana var rogue_mana_sources; Vibelin intrinsic_recharge_sources):
/// the leylines it stands near (Vibelin MANA_ALL_LEYLINES).
#define ROGUE_MANA_LEYLINES (1<<0)
/// The mana pylons it stands near (Vibelin MANA_ALL_PYLONS).
#define ROGUE_MANA_PYLONS (1<<1)

/// How invisible leylines and pylon links are, and the sight that shows them (Vibelin INVISIBILITY_LEYLINES and
/// SEE_INVISIBLE_LEYLINES): just past what the living see, below ghosts.
#define ROGUE_INVISIBILITY_LEYLINES 26
#define ROGUE_SEE_INVISIBLE_LEYLINES 26

/// Seeing the leylines (Vibelin TRAIT_SEE_LEYLINES): given by /mob/living/proc/rogue_set_leyline_sight().
#define TRAIT_ROGUE_SEE_LEYLINES "rogue_see_leylines"

/// A pool's mana changed, sent on what holds it: (datum/rogue_mana/pool, amount after the change). A person's pool also
/// sends COMSIG_MOB_ROGUE_MANA_CHANGED (magic/_defines.dm), as before.
#define COMSIG_ROGUE_MANA_POOL_CHANGED "rogue_mana_pool_changed"

/// The source of the leyline sight a shimmering lens gives.
#define ROGUE_LEYLINE_LENS_TRAIT "rogue_leyline_lens"

/// The icon of crystals and the Mana Star (Vibelin icons/obj/crystals.dmi, already carried by the Vibelin items).
#define ROGUE_MANA_CRYSTAL_ICON 'modular_redtard/items_vibelin/icons/icons/obj/crystals.dmi'
