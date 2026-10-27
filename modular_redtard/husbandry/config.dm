/// Multiplier on how fast a beast's food meter empties (Ratwood: one point every 2 seconds); 0 - beasts never get hungry.
/datum/config_entry/number/rogue_beast_hunger_rate
	default = 1
	integer = FALSE
	min_val = 0
	max_val = 10

/// Whether a kept beast (tamed, with a friend) left with an empty food meter for ROGUE_BEAST_STARVE_DELAY wastes away (not in
/// Ratwood). Off - it only stays hungry and does not breed or lay.
/datum/config_entry/flag/rogue_beast_starvation
	default = TRUE

/// No beast gives birth while this many livestock (breeding beasts and their young) live (Ratwood MAX_FARM_ANIMALS).
/datum/config_entry/number/rogue_farm_animal_cap
	default = 20
	integer = TRUE
	min_val = 0
	max_val = 500

/// Whether the Ratwood husbandry runs: on medieval maps, as the rest of the rogue mechanics.
/proc/rogue_husbandry_enabled()
	return rogue_combat_enabled()
