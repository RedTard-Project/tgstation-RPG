/// Magic (block M1, Б49): Vibelin's magic on TG's spells. Mana pays for spells (mana.dm), techniques and forms decide which
/// spells one may learn (mastery.dm), the spells themselves are /datum/action/cooldown/spell/rogue (spell.dm, projectile.dm)
/// filled in by the basket of block M2. Medieval maps only (rogue_magic_enabled()).

/// What a spell is paid with (Vibelin spell_type: SPELL_MANA, SPELL_STAMINA; the miracles pay devotion in faith/).
#define ROGUE_SPELL_COST_NONE 0
#define ROGUE_SPELL_COST_MANA 1
#define ROGUE_SPELL_COST_STAMINA 2

/// Vibelin's techniques (what a spell does) and forms (what it is made of): __DEFINES/magic.dm TECHNIQUE_*, FORM_*. The text is
/// what the spellbook shows and what the mastery lists are keyed by.
#define ROGUE_TECHNIQUE_DESTRUCTION "Destruction"
#define ROGUE_TECHNIQUE_CREATION "Creation"
#define ROGUE_TECHNIQUE_SUMMONING "Summoning"
#define ROGUE_TECHNIQUE_RESTORATION "Restoration"
#define ROGUE_TECHNIQUE_ALTERATION "Alteration"
#define ROGUE_TECHNIQUE_ILLUSION "Illusion"
#define ROGUE_TECHNIQUE_IMBUE "Imbue"

#define ROGUE_FORM_ARCANE "Arcyne"
#define ROGUE_FORM_FIRE "Pyromancy"
#define ROGUE_FORM_WATER "Hydromancy"
#define ROGUE_FORM_ICE "Cryomancy"
#define ROGUE_FORM_EARTH "Geomancy"
#define ROGUE_FORM_AIR "Aeromancy"
#define ROGUE_FORM_LIGHTNING "Astrapomancy"
#define ROGUE_FORM_LIFE "Vitamancy"
#define ROGUE_FORM_DEATH "Necromancy"
#define ROGUE_FORM_BLOOD "Hemomancy"

/// Mastery rank names by the level of a track (Vibelin MASTERY_RANK_*): a track at this level or more has this name.
#define ROGUE_MASTERY_RANK_NOVICE 0
#define ROGUE_MASTERY_RANK_ADEPT 2
#define ROGUE_MASTERY_RANK_EXPERT 4
#define ROGUE_MASTERY_RANK_MASTER 6

/// What Vibelin's spell_requirements have and TG's lack (rogue_requirements of a spell).
#define ROGUE_SPELL_REQUIRES_NO_MOVE (1<<0)
#define ROGUE_SPELL_CASTABLE_WHILE_MOUNTED (1<<1)

/// Ratwood's spell implements (spell_implements/_spell_implement.dm IMPLEMENT_TIER_*): a staff or tome held while casting.
#define ROGUE_IMPLEMENT_NONE 0
#define ROGUE_IMPLEMENT_LESSER 1
#define ROGUE_IMPLEMENT_GREATER 2
#define ROGUE_IMPLEMENT_GRAND 3

/// Icons: Vibelin's spell buttons and backgrounds (icons/mob/actions/roguespells.dmi), its mana orb (icons/mob/rogueheat.dmi
/// manaover, mana10-mana120) and charge cursors (icons/effects/mousemice/charge/).
#define ROGUE_SPELLS_ICON 'modular_redtard/magic/icons/roguespells.dmi'
#define ROGUE_MANA_ICON 'modular_redtard/magic/icons/mana.dmi'
#define ROGUE_SPELL_CHARGING_CURSOR 'modular_redtard/magic/icons/spell_charging.dmi'
#define ROGUE_SPELL_CHARGED_CURSOR 'modular_redtard/magic/icons/spell_charged.dmi'
#define ROGUE_SPELL_CHARGE_SOUND 'modular_redtard/combat/sound/magic/charging.ogg'
#define ROGUE_SPELL_CAST_SOUND 'modular_redtard/combat/sound/magic/whiteflame.ogg'

/// Where the mana orb sits on the medieval HUD: right of the stamina orb (rogueui_fat), which stands in the left column
/// beside the field; the orb itself is over the field's first tiles. To be checked in game.
#define rogueui_mana "WEST-1:-22,NORTH-5:30"

/// Mana changed on a mob: (amount after the change).
#define COMSIG_MOB_ROGUE_MANA_CHANGED "mob_rogue_mana_changed"
/// The Shift+G key (Vibelin, Twilight Axis toggle_arc_mode).
#define COMSIG_KB_ROGUE_SPELL_ALT_MODE_DOWN "keybinding_rogue_spell_alt_mode_down"

/// The source of what magic gives a mob. A magic user is one with Ratwood's TRAIT_ARCYNE (Arcyne Training, given by the
/// mage classes): their mana refills by itself, as Vibelin's magic_user draws on the leylines (MANA_ALL_LEYLINES). No spell
/// is cast under Ratwood's TRAIT_SPELLCOCKBLOCK (Bewitched; Vibelin TRAIT_SPELLBLOCK). Both come from rockhill/ported/_traits.dm.
#define ROGUE_MAGIC_TRAIT "rogue_magic"

/// The filter of a caster while a spell charges.
#define ROGUE_SPELL_CHARGE_FILTER "rogue_spell_charge"
/// The filter of a staff or tome attuned to the last spell cast through it (Ratwood IMPLEMENT_GLOW_FILTER).
#define ROGUE_IMPLEMENT_GLOW_FILTER "rogue_implement_attunement"
