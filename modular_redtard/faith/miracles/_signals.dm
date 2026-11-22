/// Signals of the miracles. A file of its own with an underscore, included before the miracles that send and hear them: the
/// defines of a file without one must be undone at its end (define_sanity), and these are used in several.

/// Sent to a body when the aura of a healing miracle mends it (healing.dm), before the mending: (amount, the status effect).
/// Eora's Heartweave carries a share of it to the other half of the bond.
#define COMSIG_LIVING_MIRACLE_HEAL_APPLY "living_miracle_heal_apply"
