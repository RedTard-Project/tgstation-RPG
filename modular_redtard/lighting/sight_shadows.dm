/datum/config_entry/flag/rogue_sight_shadows
	default = TRUE

/datum/config_entry/number/rogue_sight_shadow_alpha
	default = ROGUE_SIGHT_ALPHA
	integer = TRUE
	min_val = 0
	max_val = 255

/proc/rogue_sight_shadows_enabled()
	return CONFIG_GET(flag/rogue_sight_shadows) && SSmapping.current_map?.map_era == MAP_ERA_MEDIEVAL

/proc/rogue_sight_triangle(ax, ay, bx, by, cx, cy)
	var/px1 = ax * ICON_SIZE_X - ROGUE_SIGHT_HALF_TILE
	var/py1 = ay * ICON_SIZE_Y - ROGUE_SIGHT_HALF_TILE
	var/a = (bx * ICON_SIZE_X - ROGUE_SIGHT_HALF_TILE - px1) / ICON_SIZE_X
	var/d = (by * ICON_SIZE_Y - ROGUE_SIGHT_HALF_TILE - py1) / ICON_SIZE_Y
	var/b = (cx * ICON_SIZE_X - ROGUE_SIGHT_HALF_TILE - px1) / ICON_SIZE_X
	var/e = (cy * ICON_SIZE_Y - ROGUE_SIGHT_HALF_TILE - py1) / ICON_SIZE_Y
	var/mutable_appearance/triangle = mutable_appearance(ROGUE_SIGHT_ICON, ROGUE_SIGHT_STATE)
	triangle.transform = matrix(a, b, px1 + ROGUE_SIGHT_HALF_TILE * (a + b), d, e, py1 + ROGUE_SIGHT_HALF_TILE * (d + e))
	return triangle

GLOBAL_LIST_EMPTY(rogue_sight_quads)

/proc/rogue_sight_quad(list/into, x1, y1, x2, y2)
	var/key = "[x1],[y1],[x2],[y2]"
	var/list/cached = GLOB.rogue_sight_quads[key]
	if(!cached)
		cached = rogue_sight_make_quad(x1, y1, x2, y2)
		GLOB.rogue_sight_quads[key] = cached
	into += cached

/proc/rogue_sight_make_quad(x1, y1, x2, y2)
	var/d1x = x1 - ROGUE_SIGHT_EYE
	var/d1y = y1 - ROGUE_SIGHT_EYE
	var/d2x = x2 - ROGUE_SIGHT_EYE
	var/d2y = y2 - ROGUE_SIGHT_EYE
	var/l1 = sqrt(d1x * d1x + d1y * d1y)
	var/l2 = sqrt(d2x * d2x + d2y * d2y)
	var/f1x = x1 + d1x / l1 * ROGUE_SIGHT_REACH
	var/f1y = y1 + d1y / l1 * ROGUE_SIGHT_REACH
	var/f2x = x2 + d2x / l2 * ROGUE_SIGHT_REACH
	var/f2y = y2 + d2y / l2 * ROGUE_SIGHT_REACH
	return list(rogue_sight_triangle(x1, y1, x2, y2, f2x, f2y), rogue_sight_triangle(x1, y1, f2x, f2y, f1x, f1y))

/proc/rogue_sight_shadow_overlays(turf/eye, range = ROGUE_SIGHT_RANGE)
	. = list()
	var/size = range * 2 + 1
	var/min_x = eye.x - range
	var/min_y = eye.y - range
	var/list/opaque = new /list(size * size)
	var/list/row_low = new /list(size)
	var/list/row_high = new /list(size)
	var/list/column_low = new /list(size)
	var/list/column_high = new /list(size)
	var/found = FALSE
	for(var/turf/spot as anything in block(max(min_x, 1), max(min_y, 1), eye.z, min(eye.x + range, world.maxx), min(eye.y + range, world.maxy), eye.z))
		if(spot.directional_opacity != ALL_CARDINALS || spot == eye)
			continue
		var/row = spot.y - min_y
		var/column = spot.x - min_x
		opaque[row * size + column + 1] = TRUE
		found = TRUE
		if(isnull(row_low[row + 1]) || column < row_low[row + 1])
			row_low[row + 1] = column
		if(isnull(row_high[row + 1]) || column > row_high[row + 1])
			row_high[row + 1] = column
		if(isnull(column_low[column + 1]) || row < column_low[column + 1])
			column_low[column + 1] = row
		if(isnull(column_high[column + 1]) || row > column_high[column + 1])
			column_high[column + 1] = row
	if(!found)
		return
	for(var/row in 0 to size - 1)
		if(isnull(row_low[row + 1]))
			continue
		var/dy = row - range
		var/run_north = null
		var/run_south = null
		for(var/column in row_low[row + 1] to row_high[row + 1] + 1)
			var/here = column < size && opaque[row * size + column + 1]
			var/north = here && dy >= 0 && !(row + 1 < size && opaque[(row + 1) * size + column + 1])
			var/south = here && dy <= 0 && !(row > 0 && opaque[(row - 1) * size + column + 1])
			if(north && isnull(run_north))
				run_north = column
			else if(!north && !isnull(run_north))
				rogue_sight_quad(., run_north - range, dy + 1, column - range, dy + 1)
				run_north = null
			if(south && isnull(run_south))
				run_south = column
			else if(!south && !isnull(run_south))
				rogue_sight_quad(., column - range, dy, run_south - range, dy)
				run_south = null
		if(length(.) >= ROGUE_SIGHT_MAX_TRIANGLES)
			return
	for(var/column in 0 to size - 1)
		if(isnull(column_low[column + 1]))
			continue
		var/dx = column - range
		var/run_east = null
		var/run_west = null
		for(var/row in column_low[column + 1] to column_high[column + 1] + 1)
			var/here = row < size && opaque[row * size + column + 1]
			var/east = here && dx >= 0 && !(column + 1 < size && opaque[row * size + column + 2])
			var/west = here && dx <= 0 && !(column > 0 && opaque[row * size + column])
			if(east && isnull(run_east))
				run_east = row
			else if(!east && !isnull(run_east))
				rogue_sight_quad(., dx + 1, row - range, dx + 1, run_east - range)
				run_east = null
			if(west && isnull(run_west))
				run_west = row
			else if(!west && !isnull(run_west))
				rogue_sight_quad(., dx, run_west - range, dx, row - range)
				run_west = null
		if(length(.) >= ROGUE_SIGHT_MAX_TRIANGLES)
			return

/datum/component/rogue_sight_shadows
	var/image/shadows
	var/client/shown_to
	var/turf/last_turf
	var/list/last_overlays
	var/refresh_timer

/datum/component/rogue_sight_shadows/Initialize()
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/rogue_sight_shadows/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOB_CLIENT_LOGIN, PROC_REF(on_login))
	RegisterSignal(parent, COMSIG_MOB_LOGOUT, PROC_REF(on_logout))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	var/mob/viewer = parent
	if(viewer.client)
		show(viewer.client)

/datum/component/rogue_sight_shadows/UnregisterFromParent()
	hide()
	UnregisterSignal(parent, list(COMSIG_MOB_CLIENT_LOGIN, COMSIG_MOB_LOGOUT, COMSIG_MOVABLE_MOVED))

/datum/component/rogue_sight_shadows/Destroy()
	hide()
	shadows = null
	return ..()

/datum/component/rogue_sight_shadows/proc/on_login(datum/source, client/new_client)
	SIGNAL_HANDLER
	show(new_client)

/datum/component/rogue_sight_shadows/proc/on_logout(datum/source)
	SIGNAL_HANDLER
	hide()

/datum/component/rogue_sight_shadows/proc/on_moved(datum/source)
	SIGNAL_HANDLER
	if(shown_to)
		rebuild()

/datum/component/rogue_sight_shadows/proc/show(client/new_client)
	if(!new_client || shown_to == new_client)
		return
	hide()
	if(!shadows)
		shadows = image(loc = parent)
		shadows.alpha = CONFIG_GET(number/rogue_sight_shadow_alpha)
		shadows.appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM | KEEP_APART | (shadows.alpha < 255 ? KEEP_TOGETHER : NONE)
		shadows.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	shown_to = new_client
	new_client.images += shadows
	rebuild(TRUE)
	refresh_timer = addtimer(CALLBACK(src, PROC_REF(rebuild), TRUE), ROGUE_SIGHT_REFRESH, TIMER_STOPPABLE | TIMER_LOOP | TIMER_DELETE_ME)

/datum/component/rogue_sight_shadows/proc/hide()
	deltimer(refresh_timer)
	refresh_timer = null
	last_turf = null
	last_overlays = null
	if(shown_to)
		shown_to.images -= shadows
	shown_to = null

/datum/component/rogue_sight_shadows/proc/rebuild(force = FALSE)
	var/turf/eye = get_turf(parent)
	if(!eye)
		shadows.overlays.Cut()
		last_turf = null
		last_overlays = null
		return
	if(!force && eye == last_turf)
		return
	last_turf = eye
	SET_PLANE_EXPLICIT(shadows, ABOVE_LIGHTING_PLANE, eye)
	var/list/made = rogue_sight_shadow_overlays(eye)
	if(made ~= last_overlays)
		return
	last_overlays = made
	shadows.overlays = made
