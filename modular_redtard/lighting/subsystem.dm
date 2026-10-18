SUBSYSTEM_DEF(rogue_light)
	name = "Rogue Lighting"
	dependencies = list(
		/datum/controller/subsystem/lighting,
	)
	wait = 1
	ss_flags = SS_TICKER
	var/carrier_mode = ROGUE_LIGHT_CARRIER_OBJECT
	var/native = FALSE
	var/native_ready = FALSE
	var/native_failures = 0
	var/rebuilding = FALSE
	var/library
	var/fn_init
	var/fn_zlevel
	var/fn_submit
	var/fn_collect
	var/fn_status
	var/list/pending = list()
	var/list/looks = list()
	var/list/look_lums = list()
	var/list/key_carriers = list()
	var/list/look_carriers = list()
	var/list/idle_carriers = list()
	var/list/source_by_id = list()
	var/list/free_ids = list()
	var/list/status = list()
	var/mutable_appearance/dark_appearance
	var/carrier_count = 0
	var/applied_records = 0
	var/next_prune = 0

/datum/controller/subsystem/rogue_light/stat_entry(msg)
	msg = "\n  [carrier_mode]|[native ? ROGUE_LIGHT_BACKEND_NATIVE : ROGUE_LIGHT_BACKEND_DM]|Carriers:[carrier_count]|Idle:[length(idle_carriers)]"
	if(native_ready && length(status) >= ROGUE_LIGHT_STATUS_SIZE)
		msg += "|Queue:[length(pending)]|Jobs:[status[ROGUE_LIGHT_STATUS_JOBS]]|Sources:[status[ROGUE_LIGHT_STATUS_SOURCES]]|Looks:[status[ROGUE_LIGHT_STATUS_LOOKS]]|Job:[status[ROGUE_LIGHT_STATUS_LAST_JOB_US]]us|Applied:[applied_records]"
	return ..()

/datum/controller/subsystem/rogue_light/Initialize()
	if(native_ready)
		submit()
		var/deadline = REALTIMEOFDAY + ROGUE_LIGHT_INIT_TIMEOUT
		UNTIL(native_idle() || REALTIMEOFDAY > deadline)
		apply_results(TRUE)
	RegisterSignal(SSdcs, COMSIG_GLOB_NEW_Z, PROC_REF(on_new_z))
	if(carrier_mode == ROGUE_LIGHT_CARRIER_OBJECT && !native_ready)
		can_fire = FALSE
		return SS_INIT_NO_NEED
	return SS_INIT_SUCCESS

/datum/controller/subsystem/rogue_light/fire(resumed)
	if(native_ready)
		submit()
		if(!apply_results(FALSE))
			return
		poll_status()
	if(world.time >= next_prune && length(idle_carriers))
		prune()

/datum/controller/subsystem/rogue_light/proc/configure()
	carrier_mode = ROGUE_LIGHT_CARRIER_OBJECT
	native = FALSE
	native_ready = FALSE
	dark_appearance = mutable_appearance(LIGHTING_ICON, "lighting_dark", plane = LIGHTING_PLANE)
	if(!rogue_light_map_enabled())
		return
	var/requested = lowertext(CONFIG_GET(string/rogue_lighting_carrier))
	if(requested in list(ROGUE_LIGHT_CARRIER_OBJECT, ROGUE_LIGHT_CARRIER_UNDERLAY, ROGUE_LIGHT_CARRIER_SHARED))
		carrier_mode = requested
	else
		log_config("Unknown ROGUE_LIGHTING_CARRIER [requested], using [ROGUE_LIGHT_CARRIER_OBJECT].")
	if(lowertext(CONFIG_GET(string/rogue_lighting_backend)) == ROGUE_LIGHT_BACKEND_NATIVE)
		native = start_native(TRUE)

/datum/controller/subsystem/rogue_light/proc/uses_cells()
	return carrier_mode != ROGUE_LIGHT_CARRIER_OBJECT

/datum/controller/subsystem/rogue_light/proc/load_library()
	if(library)
		return TRUE
	var/name = CONFIG_GET(string/rogue_lighting_library)
	var/path = rogue_light_library_path(name)
	if(!path)
		log_world("Rogue lighting: no [name] library next to the world, the DM backend stays in charge.")
		return FALSE
	try
		var/abi = call_ext(path, "byond:rlight_abi")()
		if(abi != ROGUE_LIGHT_ABI)
			log_world("Rogue lighting: [path] speaks ABI [abi], [ROGUE_LIGHT_ABI] is needed.")
			return FALSE
		fn_init = load_ext(path, "byond:rlight_init")
		fn_zlevel = load_ext(path, "byond:rlight_zlevel")
		fn_submit = load_ext(path, "byond:rlight_submit")
		fn_collect = load_ext(path, "byond:rlight_collect")
		fn_status = load_ext(path, "byond:rlight_status")
	catch(var/exception/error)
		log_world("Rogue lighting: [path] could not be loaded: [error]")
		return FALSE
	library = path
	return TRUE

/datum/controller/subsystem/rogue_light/proc/start_native(from_areas)
	native_ready = FALSE
	if(!load_library())
		return FALSE
	var/result
	try
		result = call_ext(fn_init)(world.maxx, world.maxy, world.maxz, SSmapping.max_plane_offset)
	catch(var/exception/error)
		log_world("Rogue lighting: [library] failed to start: [error]")
		return FALSE
	if(result != 1)
		log_world("Rogue lighting: [library] refused to start ([result]).")
		return FALSE
	looks.Cut()
	look_lums.Cut()
	look_carriers.Cut()
	pending.Cut()
	for(var/z in 1 to world.maxz)
		if(!upload_zlevel(z, from_areas))
			return FALSE
		CHECK_TICK
	native_ready = TRUE
	return TRUE

/datum/controller/subsystem/rogue_light/proc/upload_zlevel(z, from_areas)
	var/list/flags = new /list(world.maxx * world.maxy)
	var/index = 0
	for(var/turf/level_turf as anything in Z_TURFS(z))
		flags[++index] = rogue_light_turf_flags(level_turf, from_areas)
	var/list/links = length(SSmapping.multiz_levels) >= z ? SSmapping.multiz_levels[z] : null
	var/up = links ? !!links[Z_LEVEL_UP] : FALSE
	var/down = links ? !!links[Z_LEVEL_DOWN] : FALSE
	try
		if(call_ext(fn_zlevel)(z, world.maxx, world.maxy, up, down, GET_LOWEST_STACK_OFFSET(z), flags) == 1)
			return TRUE
	catch(var/exception/error)
		log_world("Rogue lighting: z-level [z] upload failed: [error]")
		return FALSE
	log_world("Rogue lighting: z-level [z] upload was refused.")
	return FALSE

/datum/controller/subsystem/rogue_light/proc/on_new_z(datum/source, datum/space_level/level)
	SIGNAL_HANDLER
	if(native_ready && !upload_zlevel(level.z_value, FALSE))
		native_failed("new z-level [level.z_value]")

/datum/controller/subsystem/rogue_light/proc/native_idle()
	poll_status()
	return !native_ready || (length(status) >= ROGUE_LIGHT_STATUS_SIZE && !status[ROGUE_LIGHT_STATUS_JOBS])

/datum/controller/subsystem/rogue_light/proc/poll_status()
	var/list/result
	try
		result = call_ext(fn_status)()
	catch(var/exception/error)
		native_failed("status: [error]")
		return
	if(length(result) < ROGUE_LIGHT_STATUS_SIZE)
		return
	status = result
	if(result[ROGUE_LIGHT_STATUS_FAILED])
		native_failed("worker panic")

/datum/controller/subsystem/rogue_light/proc/native_failed(reason)
	native_ready = FALSE
	native_failures++
	log_world("Rogue lighting: native backend failed ([reason]).")
	message_admins("Rogue lighting: the native backend failed ([reason]), [native_failures >= 3 ? "falling back to DM lighting" : "rebuilding it"].")
	INVOKE_ASYNC(src, PROC_REF(set_backend), native_failures >= 3 ? ROGUE_LIGHT_BACKEND_DM : ROGUE_LIGHT_BACKEND_NATIVE)

/datum/controller/subsystem/rogue_light/proc/turf_changed(turf/target)
	if(native_ready && !rebuilding)
		pending.Add(ROGUE_LIGHT_CMD_TURF, target.x, target.y, target.z, rogue_light_turf_flags(target))

/datum/controller/subsystem/rogue_light/proc/light_set(datum/light_source/light)
	var/turf/source = light.source_turf
	if(!native_ready || !isturf(source))
		return
	var/id = light.rogue_light_id
	if(!id)
		id = length(free_ids) ? pop(free_ids) : length(source_by_id) + 1
		if(id > length(source_by_id))
			source_by_id.len = id
		source_by_id[id] = light
		light.rogue_light_id = id
	pending.Add(ROGUE_LIGHT_CMD_SET, id, source.x, source.y, source.z, light.light_range, light.light_power, light.lum_r, light.lum_g, light.lum_b, light.light_dir, light.light_angle, light.light_height, light.offset_x, light.offset_y, light.visual_offset)

/datum/controller/subsystem/rogue_light/proc/light_remove(datum/light_source/light)
	var/id = light.rogue_light_id
	if(!id)
		return
	light.rogue_light_id = 0
	source_by_id[id] = null
	free_ids += id
	if(native_ready)
		pending.Add(ROGUE_LIGHT_CMD_DEL, id)

/datum/controller/subsystem/rogue_light/proc/submit()
	if(!length(pending))
		return
	var/list/batch = pending
	pending = list()
	try
		call_ext(fn_submit)(batch)
	catch(var/exception/error)
		native_failed("submit: [error]")

/datum/controller/subsystem/rogue_light/proc/apply_results(init_tick_checks)
	while(native_ready)
		var/list/batch
		try
			batch = call_ext(fn_collect)(ROGUE_LIGHT_COLLECT_CHUNK)
		catch(var/exception/error)
			native_failed("collect: [error]")
			return TRUE
		var/batch_length = length(batch)
		if(!batch_length)
			return TRUE
		var/index = 1
		while(index <= batch_length)
			var/record = batch[index]
			if(record == ROGUE_LIGHT_RECORD_LOOK)
				define_look(batch, index)
				index += ROGUE_LIGHT_LOOK_SIZE
			else if(record == ROGUE_LIGHT_RECORD_CHANGE)
				var/turf/lit = locate(batch[index + 1], batch[index + 2], batch[index + 3])
				lit?.lighting_object?.rogue_show_look(batch[index + 4])
				index += ROGUE_LIGHT_CHANGE_SIZE
			else
				native_failed("bad record [record]")
				return TRUE
		applied_records += batch_length
		if(init_tick_checks)
			CHECK_TICK
		else if(MC_TICK_CHECK)
			return FALSE
	return TRUE

/datum/controller/subsystem/rogue_light/proc/define_look(list/batch, index)
	var/look = batch[index + 1]
	if(look > length(looks))
		looks.len = look
		look_lums.len = look
	var/base = index + 1
	looks[look] = ROGUE_LIGHT_MATRIX(batch[base + 1], batch[base + 2], batch[base + 3], batch[base + 4], batch[base + 5], batch[base + 6], batch[base + 7], batch[base + 8], batch[base + 9], batch[base + 10], batch[base + 11], batch[base + 12])
	var/total = 0
	for(var/offset in 1 to ROGUE_LIGHT_LOOK_VALUES)
		total += batch[base + offset]
	look_lums[look] = total / ROGUE_LIGHT_LOOK_VALUES

/datum/controller/subsystem/rogue_light/proc/zlevel_list(list/holder, z)
	if(length(holder) < z)
		holder.len = z
	var/list/level = holder[z]
	if(!level)
		level = list()
		holder[z] = level
	return level

/datum/controller/subsystem/rogue_light/proc/carrier_for_corners(z, datum/lighting_corner/red, datum/lighting_corner/green, datum/lighting_corner/blue, datum/lighting_corner/alpha)
	var/key = "[ROGUE_LIGHT_PACK(red)]|[ROGUE_LIGHT_PACK(green)]|[ROGUE_LIGHT_PACK(blue)]|[ROGUE_LIGHT_PACK(alpha)]"
	var/list/by_key = zlevel_list(key_carriers, z)
	var/atom/movable/rogue_light_carrier/found = by_key[key]
	if(found)
		return found
	var/lum = (red.cache_r + red.cache_g + red.cache_b + green.cache_r + green.cache_g + green.cache_b + blue.cache_r + blue.cache_g + blue.cache_b + alpha.cache_r + alpha.cache_g + alpha.cache_b) / ROGUE_LIGHT_LOOK_VALUES
	found = new(null, key, z, ROGUE_LIGHT_MATRIX(red.cache_r, red.cache_g, red.cache_b, green.cache_r, green.cache_g, green.cache_b, blue.cache_r, blue.cache_g, blue.cache_b, alpha.cache_r, alpha.cache_g, alpha.cache_b), lum)
	by_key[key] = found
	carrier_count++
	return found

/datum/controller/subsystem/rogue_light/proc/carrier_for_look(z, look)
	if(!look || look > length(looks) || !looks[look])
		return null
	var/list/by_look = zlevel_list(look_carriers, z)
	if(length(by_look) < look)
		by_look.len = look
	var/atom/movable/rogue_light_carrier/found = by_look[look]
	if(found)
		return found
	found = new(null, look, z, looks[look], look_lums[look])
	by_look[look] = found
	carrier_count++
	return found

/datum/controller/subsystem/rogue_light/proc/forget_carrier(atom/movable/rogue_light_carrier/carrier)
	idle_carriers -= carrier
	carrier_count--
	var/z = carrier.z_level
	var/look = carrier.look
	if(istext(look))
		var/list/by_key = length(key_carriers) >= z ? key_carriers[z] : null
		if(by_key?[look] == carrier)
			by_key -= look
		return
	var/list/by_look = length(look_carriers) >= z ? look_carriers[z] : null
	if(length(by_look) >= look && by_look[look] == carrier)
		by_look[look] = null

/datum/controller/subsystem/rogue_light/proc/attach(turf/lit, atom/movable/rogue_light_carrier/carrier)
	if(carrier_mode == ROGUE_LIGHT_CARRIER_SHARED)
		lit.vis_contents += carrier
	else
		lit.underlays += carrier

/datum/controller/subsystem/rogue_light/proc/detach(turf/lit, atom/movable/rogue_light_carrier/carrier)
	if(carrier_mode == ROGUE_LIGHT_CARRIER_SHARED)
		lit.vis_contents -= carrier
	else
		lit.underlays -= carrier

/datum/controller/subsystem/rogue_light/proc/reattach(turf/lit, atom/movable/rogue_light_carrier/carrier)
	if(carrier_mode == ROGUE_LIGHT_CARRIER_SHARED)
		if(!(carrier in lit.vis_contents))
			lit.vis_contents += carrier
		return
	lit.underlays -= carrier
	lit.underlays += carrier

/datum/controller/subsystem/rogue_light/proc/prune()
	next_prune = world.time + ROGUE_LIGHT_PRUNE_INTERVAL
	var/deadline = world.time - ROGUE_LIGHT_IDLE_TIME
	for(var/atom/movable/rogue_light_carrier/carrier as anything in idle_carriers)
		if(carrier.users <= 0 && carrier.idle_since <= deadline)
			qdel(carrier)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/rogue_light/proc/static_turfs()
	. = list()
	for(var/area/lit_area as anything in GLOB.areas)
		if(!lit_area.static_lighting)
			continue
		for(var/list/zlevel_turfs as anything in lit_area.get_zlevel_turf_lists())
			for(var/turf/lit as anything in zlevel_turfs)
				if(!lit.space_lit)
					. += lit

/datum/controller/subsystem/rogue_light/proc/set_carrier_mode(new_mode)
	if(new_mode == carrier_mode)
		return
	var/list/turfs = static_turfs()
	rebuilding = TRUE
	for(var/turf/lit as anything in turfs)
		lit.lighting_clear_overlay()
		CHECK_TICK
	carrier_mode = new_mode
	for(var/turf/lit as anything in turfs)
		lit.lighting_build_overlay()
		CHECK_TICK
	rebuilding = FALSE
	can_fire = TRUE
	if(native_ready)
		pending += ROGUE_LIGHT_CMD_RESEND

/datum/controller/subsystem/rogue_light/proc/set_backend(new_backend)
	var/list/lights = list()
	for(var/datum/light_source/light)
		lights += light
	for(var/datum/light_source/light as anything in lights)
		light.remove_lum()
	native = FALSE
	native_ready = FALSE
	pending.Cut()
	source_by_id.Cut()
	free_ids.Cut()
	for(var/turf/lit as anything in static_turfs())
		lit.lighting_object?.rogue_show_look(ROGUE_LIGHT_DARK)
		CHECK_TICK
	if(new_backend == ROGUE_LIGHT_BACKEND_NATIVE)
		native = start_native(FALSE)
		if(!native)
			message_admins("Rogue lighting: the native backend did not start, DM lighting stays in charge.")
	if(native)
		native_failures = 0
	can_fire = TRUE
	for(var/datum/light_source/light as anything in lights)
		if(!QDELETED(light))
			light.force_update()

/proc/rogue_light_map_enabled()
	return SSmapping.current_map?.map_era == MAP_ERA_MEDIEVAL

/proc/rogue_light_library_path(name)
	if(world.system_type == UNIX)
		return fexists("./lib[name].so") ? "./lib[name].so" : null
	return fexists("[name].dll") ? name : null

/proc/rogue_light_turf_flags(turf/target, from_areas = FALSE)
	. = NONE
	if(target.directional_opacity == ALL_CARDINALS)
		. |= ROGUE_LIGHT_TURF_FULL_OPAQUE
	if(target.directional_opacity)
		. |= ROGUE_LIGHT_TURF_ANY_OPAQUE
	if(istransparentturf(target))
		. |= ROGUE_LIGHT_TURF_TRANSPARENT
	if(from_areas)
		var/area/target_area = target.loc
		if(target_area.static_lighting && !target.space_lit)
			. |= ROGUE_LIGHT_TURF_STATIC
	else if(target.lighting_object)
		. |= ROGUE_LIGHT_TURF_STATIC

ADMIN_VERB(rogue_lighting_panel, R_DEBUG, "Rogue Lighting", "Switch the lighting carrier or backend to compare them in one round.", ADMIN_CATEGORY_DEBUG)
	if(!rogue_light_map_enabled())
		to_chat(user, span_warning("This map keeps the stock lighting."))
		return
	var/list/choices = list(
		"Carrier: [ROGUE_LIGHT_CARRIER_OBJECT]" = list(ROGUE_LIGHT_CARRIER_OBJECT, null),
		"Carrier: [ROGUE_LIGHT_CARRIER_UNDERLAY]" = list(ROGUE_LIGHT_CARRIER_UNDERLAY, null),
		"Carrier: [ROGUE_LIGHT_CARRIER_SHARED]" = list(ROGUE_LIGHT_CARRIER_SHARED, null),
		"Backend: [ROGUE_LIGHT_BACKEND_DM]" = list(null, ROGUE_LIGHT_BACKEND_DM),
		"Backend: [ROGUE_LIGHT_BACKEND_NATIVE]" = list(null, ROGUE_LIGHT_BACKEND_NATIVE),
	)
	var/current = "[SSrogue_light.carrier_mode], [SSrogue_light.native ? ROGUE_LIGHT_BACKEND_NATIVE : ROGUE_LIGHT_BACKEND_DM]"
	var/choice = tgui_input_list(user, "Now: [current]. Switching rebuilds lighting on every lit turf.", "Rogue Lighting", choices)
	if(!choice || !SSlighting.initialized)
		return
	var/list/picked = choices[choice]
	if(picked[1])
		SSrogue_light.set_carrier_mode(picked[1])
	else
		SSrogue_light.set_backend(picked[2])
	message_admins("[key_name_admin(user)] switched rogue lighting to [choice].")
	log_admin("[key_name(user)] switched rogue lighting to [choice].")
	BLACKBOX_LOG_ADMIN_VERB("Rogue Lighting")
