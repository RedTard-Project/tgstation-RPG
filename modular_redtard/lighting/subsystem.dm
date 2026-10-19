GLOBAL_DATUM_INIT(rogue_light_sentinel, /datum/rogue_light_sentinel, new)

SUBSYSTEM_DEF(rogue_light)
	name = "Rogue Lighting"
	dependencies = list(
		/datum/controller/subsystem/lighting,
	)
	wait = 1
	ss_flags = SS_TICKER
	var/modes_resolved = FALSE
	var/carrier_mode = ROGUE_LIGHT_CARRIER_OBJECT
	var/want_native = FALSE
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
	var/fn_lum
	var/list/pending = list()
	var/list/tents = list()
	var/list/tents_by_z = list()
	var/list/templates = list()
	var/list/source_by_id = list()
	var/list/free_ids = list()
	var/list/status = list()
	var/mutable_appearance/dark_appearance
	var/tent_count = 0
	var/applied_records = 0

/datum/controller/subsystem/rogue_light/stat_entry(msg)
	msg = "\n  [carrier_mode]|[native ? ROGUE_LIGHT_BACKEND_NATIVE : ROGUE_LIGHT_BACKEND_DM]|Tents:[tent_count]"
	if(native_ready && length(status) >= ROGUE_LIGHT_STATUS_SIZE)
		msg += "|Queue:[length(pending)]|Jobs:[status[ROGUE_LIGHT_STATUS_JOBS]]|Sources:[status[ROGUE_LIGHT_STATUS_SOURCES]]|Job:[status[ROGUE_LIGHT_STATUS_LAST_JOB_US]]us|Worker:[status[ROGUE_LIGHT_STATUS_TOTAL_JOB_MS]]ms|Applied:[applied_records]"
	return ..()

/datum/controller/subsystem/rogue_light/Initialize()
	if(native_ready)
		var/wait_started = REALTIMEOFDAY
		var/applied_before = applied_records
		drain()
		poll_status()
		log_world("Rogue lighting: [carrier_mode], library [length(status) >= ROGUE_LIGHT_STATUS_SIZE ? status[ROGUE_LIGHT_STATUS_TOTAL_JOB_MS] : "?"] ms, drew [applied_records - applied_before] changes, [(REALTIMEOFDAY - wait_started) / 10] s in all")
	if(carrier_mode == ROGUE_LIGHT_CARRIER_OBJECT && !native_ready)
		can_fire = FALSE
		return SS_INIT_NO_NEED
	return SS_INIT_SUCCESS

/datum/controller/subsystem/rogue_light/fire(resumed)
	if(!native_ready)
		return
	submit()
	if(!apply_results(FALSE))
		return
	poll_status()

/datum/controller/subsystem/rogue_light/proc/drain()
	submit()
	var/deadline = REALTIMEOFDAY + ROGUE_LIGHT_INIT_TIMEOUT
	UNTIL(native_idle() || REALTIMEOFDAY > deadline)
	apply_results(TRUE)

/datum/controller/subsystem/rogue_light/proc/resolve_modes()
	if(modes_resolved || !SSmapping.current_map)
		return
	modes_resolved = TRUE
	dark_appearance = mutable_appearance(LIGHTING_ICON, "lighting_dark", plane = LIGHTING_PLANE, offset_const = 0)
	GLOB.rogue_light_sentinel.appearance = dark_appearance
	if(!rogue_light_map_enabled())
		return
	var/requested = lowertext(CONFIG_GET(string/rogue_lighting_carrier))
	if(requested in list(ROGUE_LIGHT_CARRIER_OBJECT, ROGUE_LIGHT_CARRIER_UNDERLAY, ROGUE_LIGHT_CARRIER_TENT))
		carrier_mode = requested
	else
		log_config("Unknown ROGUE_LIGHTING_CARRIER [requested], using [ROGUE_LIGHT_CARRIER_OBJECT].")
	want_native = lowertext(CONFIG_GET(string/rogue_lighting_backend)) == ROGUE_LIGHT_BACKEND_NATIVE
	if(carrier_mode == ROGUE_LIGHT_CARRIER_TENT && !want_native)
		log_config("ROGUE_LIGHTING_CARRIER tent needs ROGUE_LIGHTING_BACKEND native, using [ROGUE_LIGHT_CARRIER_OBJECT].")
		carrier_mode = ROGUE_LIGHT_CARRIER_OBJECT

/datum/controller/subsystem/rogue_light/proc/configure()
	resolve_modes()
	if(want_native)
		native = start_native(TRUE)
	if(!native && carrier_mode == ROGUE_LIGHT_CARRIER_TENT)
		log_world("Rogue lighting: tents need the library, falling back to [ROGUE_LIGHT_CARRIER_OBJECT].")
		for(var/turf/lit as anything in static_turfs())
			if(lit.lighting_object == GLOB.rogue_light_sentinel)
				lit.lighting_object = null
		carrier_mode = ROGUE_LIGHT_CARRIER_OBJECT

/datum/controller/subsystem/rogue_light/proc/uses_cells()
	if(!modes_resolved)
		resolve_modes()
	return carrier_mode == ROGUE_LIGHT_CARRIER_UNDERLAY

/datum/controller/subsystem/rogue_light/proc/uses_tents()
	if(!modes_resolved)
		resolve_modes()
	return carrier_mode == ROGUE_LIGHT_CARRIER_TENT

/datum/controller/subsystem/rogue_light/proc/output_mode()
	return carrier_mode == ROGUE_LIGHT_CARRIER_TENT ? ROGUE_LIGHT_MODE_TENTS : ROGUE_LIGHT_MODE_LOOKS

/datum/controller/subsystem/rogue_light/proc/light_template(z)
	if(length(templates) < z)
		templates.len = z
	var/mutable_appearance/template = templates[z]
	if(template)
		return template
	template = new
	template.icon = LIGHTING_ICON
	template.icon_state = null
	template.layer = z * 0.01
	template.plane = LIGHTING_PLANE
	if(SSmapping.max_plane_offset)
		template.plane = LIGHTING_PLANE - (PLANE_RANGE * GET_Z_PLANE_OFFSET(z))
	template.appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
	template.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	template.invisibility = INVISIBILITY_LIGHTING
	templates[z] = template
	return template

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
		fn_lum = load_ext(path, "byond:rlight_lum")
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
	pending.Cut()
	for(var/z in static_zlevels())
		if(!upload_zlevel(z, from_areas))
			return FALSE
		CHECK_TICK
	pending.Add(ROGUE_LIGHT_CMD_MODE, output_mode())
	index_tents()
	native_ready = TRUE
	return TRUE

/datum/controller/subsystem/rogue_light/proc/static_zlevels()
	var/list/levels = list()
	for(var/area/lit_area as anything in GLOB.areas)
		if(!lit_area.static_lighting)
			continue
		for(var/z in 1 to lit_area.get_highest_zlevel())
			if(!(z in levels) && length(lit_area.get_turfs_by_zlevel(z)))
				levels += z
	return sortTim(levels, GLOBAL_PROC_REF(cmp_numeric_asc))

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
		native_failed("worker failure")

/datum/controller/subsystem/rogue_light/proc/native_failed(reason)
	native_ready = FALSE
	native_failures++
	log_world("Rogue lighting: native backend failed ([reason]).")
	message_admins("Rogue lighting: the native backend failed ([reason]), [native_failures >= 3 ? "falling back to DM lighting" : "rebuilding it"].")
	INVOKE_ASYNC(src, PROC_REF(set_backend), native_failures >= 3 ? ROGUE_LIGHT_BACKEND_DM : ROGUE_LIGHT_BACKEND_NATIVE)

/datum/controller/subsystem/rogue_light/proc/turf_changed(turf/target, reapply = FALSE)
	if(native_ready && !rebuilding)
		pending.Add(ROGUE_LIGHT_CMD_TURF, target.x, target.y, target.z, rogue_light_turf_flags(target) | (reapply ? ROGUE_LIGHT_TURF_REAPPLY : NONE))

/datum/controller/subsystem/rogue_light/proc/turf_lum(turf/target)
	if(!native_ready)
		return 0
	return call_ext(fn_lum)(target.x, target.y, target.z)

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
		var/applied = 0
		while(index <= batch_length)
			var/record = batch[index]
			if(record == ROGUE_LIGHT_RECORD_TENT && index + ROGUE_LIGHT_TENT_SIZE - 1 <= batch_length)
				var/turf/owner = locate(batch[index + 1], batch[index + 2], batch[index + 3])
				if(owner)
					var/owner_z = owner.z
					var/list/by_id = owner_z <= length(tents_by_z) ? tents_by_z[owner_z] : tents_for_z(owner_z)
					var/old_tent = batch[index + 4]
					if(old_tent)
						var/shown = by_id[old_tent]
						if(shown)
							owner.vis_contents -= shown
					var/new_tent = batch[index + 5]
					if(new_tent)
						var/next = by_id[new_tent] || make_tent(by_id, owner_z, new_tent)
						if(old_tent)
							owner.vis_contents += next
						else
							owner.vis_contents |= next
				index += ROGUE_LIGHT_TENT_SIZE
			else if(record == ROGUE_LIGHT_RECORD_LOOK && index + ROGUE_LIGHT_LOOK_SIZE - 1 <= batch_length)
				var/turf/lit = locate(batch[index + 1], batch[index + 2], batch[index + 3])
				lit?.lighting_object?.rogue_show_record(batch, index)
				index += ROGUE_LIGHT_LOOK_SIZE
			else
				native_failed("bad record [record]")
				return TRUE
			applied++
		applied_records += applied
		if(init_tick_checks)
			CHECK_TICK
		else if(MC_TICK_CHECK)
			return FALSE
	return TRUE

/datum/controller/subsystem/rogue_light/proc/tents_for_z(z)
	var/offset = SSmapping.max_plane_offset ? GET_Z_PLANE_OFFSET(z) : 0
	if(length(tents) <= offset)
		tents.len = offset + 1
	var/list/by_id = tents[offset + 1]
	if(!by_id)
		by_id = new /list(ROGUE_LIGHT_TENT_MAX)
		tents[offset + 1] = by_id
	if(length(tents_by_z) < z)
		tents_by_z.len = z
	tents_by_z[z] = by_id
	return by_id

/datum/controller/subsystem/rogue_light/proc/index_tents()
	tents_by_z.Cut()
	for(var/z in 1 to world.maxz)
		tents_for_z(z)

/datum/controller/subsystem/rogue_light/proc/make_tent(list/by_id, z, tent_id)
	var/atom/movable/rogue_light_tent/made = new(null, tent_id, SSmapping.max_plane_offset ? GET_Z_PLANE_OFFSET(z) : 0)
	by_id[tent_id] = made
	tent_count++
	return made

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
	if(new_mode == ROGUE_LIGHT_CARRIER_TENT && !native_ready)
		message_admins("Rogue lighting: tents need the native backend.")
		return
	var/list/turfs = static_turfs()
	if(carrier_mode == ROGUE_LIGHT_CARRIER_TENT)
		clear_tents()
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
		pending.Add(ROGUE_LIGHT_CMD_MODE, output_mode(), ROGUE_LIGHT_CMD_RESEND)

/datum/controller/subsystem/rogue_light/proc/clear_tents()
	for(var/list/by_id as anything in tents)
		if(!by_id)
			continue
		for(var/index in 1 to length(by_id))
			var/atom/movable/rogue_light_tent/shown = by_id[index]
			if(shown)
				for(var/turf/holder as anything in shown.vis_locs)
					holder.vis_contents -= shown
			if(!(index % 4096))
				CHECK_TICK

/datum/controller/subsystem/rogue_light/proc/set_backend(new_backend)
	if(carrier_mode == ROGUE_LIGHT_CARRIER_TENT)
		clear_tents()
		if(new_backend != ROGUE_LIGHT_BACKEND_NATIVE)
			set_carrier_mode(ROGUE_LIGHT_CARRIER_OBJECT)
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
		lit.lighting_object?.rogue_show_dark()
		CHECK_TICK
	if(new_backend == ROGUE_LIGHT_BACKEND_NATIVE)
		native = start_native(FALSE)
		if(!native)
			message_admins("Rogue lighting: the native backend did not start, DM lighting stays in charge.")
			if(carrier_mode == ROGUE_LIGHT_CARRIER_TENT)
				set_carrier_mode(ROGUE_LIGHT_CARRIER_OBJECT)
	if(native)
		native_failures = 0
		if(carrier_mode == ROGUE_LIGHT_CARRIER_TENT)
			pending.Add(ROGUE_LIGHT_CMD_RESEND)
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
		"Carrier: [ROGUE_LIGHT_CARRIER_TENT]" = list(ROGUE_LIGHT_CARRIER_TENT, null),
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
