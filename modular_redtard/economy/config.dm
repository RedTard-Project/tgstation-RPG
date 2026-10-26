/// Base of the Crown's Purse at round start; Ratwood adds 500-1500 and a sum per player (STOCKPILE_CROWN_PURCHASE_FLOOR_DEFAULT).
/datum/config_entry/number/rogue_crown_purse
	default = 1000
	integer = TRUE
	min_val = 0

/// Mammons the Crown's Purse gets per player at round start (Ratwood CROWN_PURSE_SEED_PER_PLAYER).
/datum/config_entry/number/rogue_crown_purse_per_player
	default = 35
	integer = TRUE
	min_val = 0

/// Below this the Crown buys nothing at the stockpile (Ratwood stockpile_purchase_floor); the Steward may change it in the round.
/datum/config_entry/number/rogue_stockpile_floor
	default = 1000
	integer = TRUE
	min_val = 0

/// Rural tax the Crown's Purse collects every dawn (Ratwood RURAL_TAX).
/datum/config_entry/number/rogue_rural_tax
	default = 100
	integer = TRUE
	min_val = 0

/// Import tariff on GOLDFACE purchases, percent (Ratwood TAX_CATEGORY_IMPORT_TARIFF); the Steward may change it once a day.
/datum/config_entry/number/rogue_import_tariff
	default = 15
	integer = TRUE
	min_val = 0
	max_val = 100
