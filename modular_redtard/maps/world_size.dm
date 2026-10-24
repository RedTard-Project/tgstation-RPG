/datum/map_config/var/list/world_size

/datum/map_config/LoadConfig(filename, error_if_missing)
	. = ..()
	if(!.)
		return .
	var/list/map_json = json_decode(file2text(file(filename)))
	var/list/size = map_json?["world_size"]
	if(islist(size) && length(size) == 2 && isnum(size[1]) && isnum(size[2]))
		world_size = size.Copy()
	return .

/datum/controller/subsystem/mapping/loadWorld()
	if(length(current_map?.world_size) == 2)
		if(current_map.world_size[1] > world.maxx)
			world.increase_max_x(current_map.world_size[1])
		if(current_map.world_size[2] > world.maxy)
			world.increase_max_y(current_map.world_size[2])
	return ..()
