/datum/config_entry/string/rogue_lighting_carrier
	default = ROGUE_LIGHT_CARRIER_QUARTER

/datum/config_entry/string/rogue_lighting_backend
	default = ROGUE_LIGHT_BACKEND_NATIVE

/datum/config_entry/string/rogue_lighting_library
	default = "rogue_light"
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/flag/rogue_lighting_palette
	default = TRUE

/datum/config_entry/number/rogue_lighting_tick_budget
	default = ROGUE_LIGHT_TICK_BUDGET
	min_val = 5
	max_val = 100

/datum/config_entry/number/rogue_lower_level_shade
	default = ROGUE_LOWER_LEVEL_SHADE
	min_val = 0.5
	max_val = 1

/datum/config_entry/number/rogue_darkness_floor
	default = ROGUE_DARKNESS_FLOOR
	min_val = 0
	max_val = LIGHTING_CUTOFF_MEDIUM

/datum/controller/configuration/Load(_directory)
	. = ..()
	if(IsAdminAdvancedProcCall())
		return
	if(fexists("[directory]/[ROGUE_LIGHT_CONFIG_FILE]"))
		LoadEntries(ROGUE_LIGHT_CONFIG_FILE)
