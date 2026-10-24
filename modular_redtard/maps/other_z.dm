#define OTHER_Z_MARGIN 20

/datum/map_config/var/list/other_z

/datum/map_config/LoadConfig(filename, error_if_missing)
	. = ..()
	if(!.)
		return .
	var/list/map_json = json_decode(file2text(file(filename)))
	var/list/levels = map_json?["other_z"]
	if(islist(levels))
		other_z = levels.Copy()
	return .

/datum/other_z_stack
	var/start_z
	var/cursor_x = 1
	var/cursor_y = 1
	var/shelf_height = 0

/datum/other_z_stack/proc/place(width, height)
	if(cursor_x + width - 1 > world.maxx)
		cursor_x = 1
		cursor_y += shelf_height + OTHER_Z_MARGIN
		shelf_height = 0
	if(cursor_y + height - 1 > world.maxy || cursor_x + width - 1 > world.maxx)
		return null
	. = list(cursor_x, cursor_y)
	cursor_x += width + OTHER_Z_MARGIN
	shelf_height = max(shelf_height, height)

/datum/controller/subsystem/mapping/loadWorld()
	. = ..()
	load_other_z()

/datum/controller/subsystem/mapping/proc/load_other_z()
	var/list/stacks = list()
	for(var/list/entry as anything in current_map?.other_z)
		var/map_path = "_maps/[entry["map_path"]]/[entry["map_file"]]"
		var/datum/parsed_map/parsed = fexists(map_path) ? new(file(map_path)) : null
		var/list/bounds = parsed?.bounds
		if(!bounds)
			stack_trace("Other z-level map [map_path] is missing or does not parse")
			continue
		var/list/traits = entry["traits"]
		var/width = bounds[MAP_MAXX] - bounds[MAP_MINX] + 1
		var/height = bounds[MAP_MAXY] - bounds[MAP_MINY] + 1
		var/signature = other_z_signature(traits)
		var/datum/other_z_stack/stack
		var/list/spot
		for(var/datum/other_z_stack/candidate as anything in stacks[signature])
			spot = candidate.place(width, height)
			if(spot)
				stack = candidate
				break
		if(!spot)
			stack = new
			stack.start_z = world.maxz + 1
			for(var/index in 1 to length(traits))
				add_new_zlevel("[entry["name"]][index > 1 ? " [index]" : ""]", traits[index])
			LAZYADD(stacks[signature], stack)
			spot = stack.place(width, height)
		if(!spot)
			stack_trace("Other z-level map [map_path] ([width]x[height]) does not fit the world ([world.maxx]x[world.maxy])")
			continue
		if(!parsed.load(spot[1], spot[2], stack.start_z, no_changeturf = TRUE))
			stack_trace("Other z-level map [map_path] failed to load")
			continue
		log_world("Loaded [entry["name"]] at [spot[1]],[spot[2]],[stack.start_z]")

/datum/controller/subsystem/mapping/proc/other_z_signature(list/traits)
	var/list/parts = list()
	for(var/list/level as anything in traits)
		var/list/keys = list()
		for(var/key in level)
			keys += "[key]=[level[key]]"
		parts += jointext(sort_list(keys), ",")
	return "[length(traits)]z|[jointext(parts, "|")]"

#undef OTHER_Z_MARGIN
