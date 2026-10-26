/datum/config_entry/flag/rogue_sight_shadows
	default = FALSE

/datum/config_entry/number/rogue_sight_shadow_alpha
	default = ROGUE_SIGHT_ALPHA
	integer = TRUE
	min_val = 0
	max_val = 255

/datum/config_entry/number/rogue_sight_clear
	default = ROGUE_SIGHT_CLEAR
	integer = TRUE
	min_val = 0
	max_val = ROGUE_SIGHT_RANGE

GLOBAL_LIST_EMPTY(rogue_sight_quads)
GLOBAL_LIST_EMPTY(rogue_sight_viewers)

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

/proc/rogue_sight_triangles(list/points)
	. = list()
	for(var/at in 1 to length(points) step 6)
		. += rogue_sight_triangle(points[at], points[at + 1], points[at + 2], points[at + 3], points[at + 4], points[at + 5])

/proc/rogue_sight_band(list/into, ax, ay, bx, by)
	var/adx = ax - ROGUE_SIGHT_EYE
	var/ady = ay - ROGUE_SIGHT_EYE
	var/bdx = bx - ROGUE_SIGHT_EYE
	var/bdy = by - ROGUE_SIGHT_EYE
	var/a_length = sqrt(adx * adx + ady * ady)
	var/b_length = sqrt(bdx * bdx + bdy * bdy)
	var/afx = ax + adx / a_length * ROGUE_SIGHT_REACH
	var/afy = ay + ady / a_length * ROGUE_SIGHT_REACH
	var/bfx = bx + bdx / b_length * ROGUE_SIGHT_REACH
	var/bfy = by + bdy / b_length * ROGUE_SIGHT_REACH
	into.Add(ax, ay, bx, by, bfx, bfy, ax, ay, bfx, bfy, afx, afy)

/proc/rogue_sight_exit(tx, ty, low, high)
	var/dx = tx - ROGUE_SIGHT_EYE
	var/dy = ty - ROGUE_SIGHT_EYE
	var/best = ROGUE_SIGHT_REACH
	if(dx > 0)
		best = min(best, (high - ROGUE_SIGHT_EYE) / dx)
	else if(dx < 0)
		best = min(best, (low - ROGUE_SIGHT_EYE) / dx)
	if(dy > 0)
		best = min(best, (high - ROGUE_SIGHT_EYE) / dy)
	else if(dy < 0)
		best = min(best, (low - ROGUE_SIGHT_EYE) / dy)
	return list(ROGUE_SIGHT_EYE + dx * best, ROGUE_SIGHT_EYE + dy * best)

/proc/rogue_sight_quad_points(x1, y1, x2, y2, clear, inside)
	. = list()
	if(!inside)
		rogue_sight_band(., x1, y1, x2, y2)
		return
	var/low = -clear
	var/high = clear + 1
	var/fx = x1 - ROGUE_SIGHT_EYE
	var/fy = y1 - ROGUE_SIGHT_EYE
	var/sx = x2 - ROGUE_SIGHT_EYE
	var/sy = y2 - ROGUE_SIGHT_EYE
	var/turn = fx * sy - fy * sx
	var/list/boundary = list(rogue_sight_exit(x1, y1, low, high))
	var/list/between = list()
	for(var/list/corner as anything in list(list(low, low), list(high, low), list(high, high), list(low, high)))
		var/cx = corner[1] - ROGUE_SIGHT_EYE
		var/cy = corner[2] - ROGUE_SIGHT_EYE
		var/first_side = fx * cy - fy * cx
		if(first_side * turn <= 0 || (cx * sy - cy * sx) * turn <= 0)
			continue
		between[corner] = abs(arctan(fx * cx + fy * cy, first_side))
	sortTim(between, GLOBAL_PROC_REF(cmp_numeric_asc), associative = TRUE)
	for(var/corner in between)
		boundary += list(corner)
	boundary += list(rogue_sight_exit(x2, y2, low, high))
	for(var/at in 1 to length(boundary) - 1)
		var/list/near = boundary[at]
		var/list/next = boundary[at + 1]
		rogue_sight_band(., near[1], near[2], next[1], next[2])

/proc/rogue_sight_segment(list/into, horizontal, low, high, line, clear)
	var/crosses = clear > 0 && line > -clear && line < clear + 1
	var/list/cuts = crosses ? list(low, clamp(-clear, low, high), clamp(clear + 1, low, high), high) : list(low, high)
	for(var/piece in 1 to length(cuts) - 1)
		var/start = cuts[piece]
		var/finish = cuts[piece + 1]
		if(finish <= start)
			continue
		var/inside = crosses && piece == 2
		var/key = horizontal ? "[start],[line],[finish],[line],[clear],[inside]" : "[line],[start],[line],[finish],[clear],[inside]"
		var/list/cached = GLOB.rogue_sight_quads[key]
		if(!cached)
			cached = horizontal ? rogue_sight_triangles(rogue_sight_quad_points(start, line, finish, line, clear, inside)) : rogue_sight_triangles(rogue_sight_quad_points(line, start, line, finish, clear, inside))
			GLOB.rogue_sight_quads[key] = cached
		into += cached

/proc/rogue_sight_shadow_overlays(turf/eye, range = ROGUE_SIGHT_RANGE, clear = 0)
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
				rogue_sight_segment(., TRUE, run_north - range, column - range, dy + 1, clear)
				run_north = null
			if(south && isnull(run_south))
				run_south = column
			else if(!south && !isnull(run_south))
				rogue_sight_segment(., TRUE, run_south - range, column - range, dy, clear)
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
				rogue_sight_segment(., FALSE, run_east - range, row - range, dx + 1, clear)
				run_east = null
			if(west && isnull(run_west))
				run_west = row
			else if(!west && !isnull(run_west))
				rogue_sight_segment(., FALSE, run_west - range, row - range, dx, clear)
				run_west = null
		if(length(.) >= ROGUE_SIGHT_MAX_TRIANGLES)
			return

/proc/rogue_sight_opacity_changed(turf/changed)
	for(var/datum/rogue_sight/sight as anything in GLOB.rogue_sight_viewers)
		var/turf/eye = sight.last_turf
		if(eye && eye.z == changed.z && abs(eye.x - changed.x) <= sight.range && abs(eye.y - changed.y) <= sight.range)
			SSrogue_sight.queue(sight)

SUBSYSTEM_DEF(rogue_sight)
	name = "Rogue Sight"
	ss_flags = SS_TICKER | SS_NO_INIT
	wait = 1
	var/list/waiting = list()
	var/alist/quads = alist()
	var/rebuilds = 0
	var/redraws = 0
	var/native_casts = 0
	var/quad_fetches = 0

/datum/controller/subsystem/rogue_sight/stat_entry(msg)
	msg = "Viewers:[length(GLOB.rogue_sight_viewers)]|Rebuilds:[rebuilds]|Redraws:[redraws]|Native:[native_casts]|Quads:[length(quads)]"
	return ..()

/datum/controller/subsystem/rogue_sight/fire(resumed)
	if(!length(waiting))
		return
	if(SSrogue_light.native_ready)
		SSrogue_light.submit()
	while(length(waiting))
		var/datum/rogue_sight/sight = waiting[length(waiting)]
		waiting.len--
		sight.queued = FALSE
		sight.rebuild(TRUE)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/rogue_sight/proc/queue(datum/rogue_sight/sight)
	if(sight.queued)
		return
	sight.queued = TRUE
	waiting += sight

/datum/controller/subsystem/rogue_sight/proc/native_shape(turf/eye, range, clear)
	if(!SSrogue_light.native_ready || !SSrogue_light.fn_shadow)
		return null
	try
		. = call_ext(SSrogue_light.fn_shadow)(eye.x, eye.y, eye.z, range, clear)
	catch(var/exception/error)
		SSrogue_light.native_failed("shadow: [error]")
		return null
	native_casts++

/datum/controller/subsystem/rogue_sight/proc/native_overlays(list/ids)
	. = list()
	for(var/id in ids)
		var/list/cached = quads[id]
		if(!cached)
			var/list/points
			try
				points = call_ext(SSrogue_light.fn_shadow_quad)(id)
			catch(var/exception/error)
				SSrogue_light.native_failed("shadow quad: [error]")
				return
			cached = rogue_sight_triangles(points)
			quads[id] = cached
			quad_fetches++
		. += cached

/datum/rogue_sight
	var/image/shadows
	var/turf/last_turf
	var/list/last_shape
	var/range = ROGUE_SIGHT_RANGE
	var/clear = ROGUE_SIGHT_CLEAR
	var/queued = FALSE

/datum/rogue_sight/New(atom/anchor)
	shadows = image(loc = anchor)
	shadows.alpha = CONFIG_GET(number/rogue_sight_shadow_alpha)
	shadows.appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM | KEEP_APART | (shadows.alpha < 255 ? KEEP_TOGETHER : NONE)
	shadows.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	clear = CONFIG_GET(number/rogue_sight_clear)
	GLOB.rogue_sight_viewers += src

/datum/rogue_sight/Destroy(force)
	GLOB.rogue_sight_viewers -= src
	SSrogue_sight.waiting -= src
	shadows = null
	last_turf = null
	last_shape = null
	return ..()

/datum/rogue_sight/proc/rebuild(force = FALSE)
	var/turf/eye = get_turf(shadows.loc)
	if(!eye)
		shadows.overlays.Cut()
		last_turf = null
		last_shape = null
		return
	if(!force && eye == last_turf)
		return
	if(eye.z != last_turf?.z)
		SET_PLANE_EXPLICIT(shadows, ABOVE_LIGHTING_PLANE, eye)
	last_turf = eye
	SSrogue_sight.rebuilds++
	var/list/shape = SSrogue_sight.native_shape(eye, range, clear)
	if(shape)
		if(shape ~= last_shape)
			return
		last_shape = shape
		shadows.overlays = SSrogue_sight.native_overlays(shape)
		SSrogue_sight.redraws++
		return
	shape = rogue_sight_shadow_overlays(eye, range, clear)
	if(shape ~= last_shape)
		return
	last_shape = shape
	shadows.overlays = shape
	SSrogue_sight.redraws++

/datum/component/rogue_sight_shadows
	var/datum/rogue_sight/sight
	var/client/shown_to

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
	return ..()

/datum/component/rogue_sight_shadows/proc/on_login(datum/source, client/new_client)
	SIGNAL_HANDLER
	show(new_client)

/datum/component/rogue_sight_shadows/proc/on_logout(datum/source)
	SIGNAL_HANDLER
	hide()

/datum/component/rogue_sight_shadows/proc/on_moved(datum/source)
	SIGNAL_HANDLER
	sight?.rebuild()

/datum/component/rogue_sight_shadows/proc/show(client/new_client)
	if(!new_client || shown_to == new_client)
		return
	hide()
	sight = new(parent)
	shown_to = new_client
	new_client.images += sight.shadows
	sight.rebuild(TRUE)

/datum/component/rogue_sight_shadows/proc/hide()
	if(shown_to && sight)
		shown_to.images -= sight.shadows
	shown_to = null
	QDEL_NULL(sight)
