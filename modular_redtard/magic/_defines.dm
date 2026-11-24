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
/// The glow and rune of a spell with no colour of its own nor a form's.
#define ROGUE_SPELL_DEFAULT_COLOR "#9932CC"

/// Sent to the caster when a spell asks what modifies it (Vibelin COMSIG_SPELL_REQUEST_MODIFIERS): (list/out). A handler adds
/// entries to out, each list(ROGUE_SPELLMOD_COST = factor, ROGUE_SPELLMOD_CASTSPEED = factor, ROGUE_SPELLMOD_MAGNITUDE = bonus)
/// with ROGUE_SPELLMOD_FORM = a form or ROGUE_SPELLMOD_TECHNIQUE = a technique: the entry applies to spells of that form or
/// technique (get_modifiers(), magic/modifiers.dm). Books, foci and worn items answer it (/datum/component/rogue_spell_modifier).
#define COMSIG_ROGUE_SPELL_REQUEST_MODIFIERS "rogue_spell_request_modifiers"
/// Keys of a modifier entry and of get_modifiers(): the price and the charge time are multiplied and divided by their factors,
/// the magnitude (1 with nothing) gets the bonuses added (Vibelin SPELLMOD_*).
#define ROGUE_SPELLMOD_COST "cost"
#define ROGUE_SPELLMOD_CASTSPEED "castSpeed"
#define ROGUE_SPELLMOD_MAGNITUDE "magnitude"
#define ROGUE_SPELLMOD_FORM "form"
#define ROGUE_SPELLMOD_TECHNIQUE "technique"

/// The hold loop of a charging spell (Azure Peak SSmousecharge, Vibelin SSaction_charge) runs every ROGUE_SPELL_HOLD_TICK.
/// charge_drain is mana every ROGUE_SPELL_CHARGE_DRAIN_TICK of the charge (Vibelin: 0.4 s), hold_drain every
/// ROGUE_SPELL_HOLD_DRAIN_TICK of the hold (Azure Peak: 0.2 s); the loop pays their share of a tick.
#define ROGUE_SPELL_HOLD_TICK (2 DECISECONDS)
#define ROGUE_SPELL_CHARGE_DRAIN_TICK (4 DECISECONDS)
#define ROGUE_SPELL_HOLD_DRAIN_TICK (2 DECISECONDS)
/// Hold warnings (Azure Peak hold_warned): none yet, "Straining", "Unraveling".
#define ROGUE_SPELL_HOLD_CALM 0
#define ROGUE_SPELL_HOLD_STRAINING 1
#define ROGUE_SPELL_HOLD_UNRAVELING 2

/// How bright the flash where a spell bolt strikes is (Vibelin SPELL_IMPACT_*).
#define ROGUE_SPELL_IMPACT_NONE 0
#define ROGUE_SPELL_IMPACT_LOW 1
#define ROGUE_SPELL_IMPACT_MEDIUM 2
#define ROGUE_SPELL_IMPACT_HIGH 3
/// Vibelin's rune under a casting mage, its particles, the wave of a finished cast and the strike flash (icons/effects/spell_cast.dmi).
#define ROGUE_SPELL_CAST_ICON 'modular_redtard/magic/icons/spell_cast.dmi'
/// The filter of a staff or tome attuned to the last spell cast through it (Ratwood IMPLEMENT_GLOW_FILTER).
#define ROGUE_IMPLEMENT_GLOW_FILTER "rogue_implement_attunement"
