/// Ratwood/Azure Peak dreams (datums/sleep_adv): craft experience above Apprentice waits for sleep. Off - it lands at once.
/datum/config_entry/flag/rogue_sleep_xp
	default = TRUE

/// Multiplier on every experience the production stations give (Ratwood add_sleep_experience amounts).
/datum/config_entry/number/rogue_craft_xp_multiplier
	default = 1
	min_val = 0
	max_val = 100

/// Seconds of sleep per dream (Ratwood human/Life(): one dream cycle every 35 seconds of sleep while tired).
/datum/config_entry/number/rogue_dream_cycle
	default = 35
	integer = TRUE
	min_val = 5
	max_val = 600
