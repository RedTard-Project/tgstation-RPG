/datum/config_entry/string/rogue_lighting_carrier
	default = ROGUE_LIGHT_CARRIER_QUARTER

/datum/config_entry/string/rogue_lighting_backend
	default = ROGUE_LIGHT_BACKEND_NATIVE

/datum/config_entry/string/rogue_lighting_library
	default = "rogue_light"
	protection = CONFIG_ENTRY_LOCKED

/datum/controller/configuration/Load(_directory)
	. = ..()
	if(IsAdminAdvancedProcCall())
		return
	if(fexists("[directory]/[ROGUE_LIGHT_CONFIG_FILE]"))
		LoadEntries(ROGUE_LIGHT_CONFIG_FILE)
