/// The view of medieval maps, as Vibelin and Azure Peak have it (DEFAULT_VIEW 15x15): a square ROGUE_VIEW_RANGE tiles to each
/// side of the player, whatever the widescreen preference says. On other maps TG's screen stays: widescreen by the
/// preference, else a square.
/datum/config_entry/number/rogue_view_range
	default = 7
	integer = TRUE
	min_val = 3
	max_val = 15

/// TG's size of a client's screen (code/datums/view.dm). Every default view goes through it: the new client, the widescreen
/// preference and setDefault(VIEWPORT_USE_PREF).
/datum/view_data/getScreenSize()
	if(!rogue_medieval_map())
		return ..()
	var/side = CONFIG_GET(number/rogue_view_range) * 2 + 1
	return "[side]x[side]"
