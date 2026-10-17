/obj/item
	var/rogue_grid_width = 0
	var/rogue_grid_height = 0
	var/rogue_storage_type

/obj/item/Initialize(mapload)
	. = ..()
	if(rogue_storage_type && !atom_storage)
		create_storage(storage_type = rogue_storage_type)

/obj/item/proc/rogue_grid_footprint()
	var/width = rogue_grid_width > 0 ? round(rogue_grid_width / ICON_SIZE_X) : w_class
	var/height = rogue_grid_height > 0 ? round(rogue_grid_height / ICON_SIZE_Y) : w_class
	return list(max(1, width), max(1, height))

/proc/rogue_grid_frame(width, height)
	var/static/list/frames = list()
	var/key = "[width]x[height]"
	if(frames[key])
		return frames[key]
	var/pixel_width = width * ICON_SIZE_X
	var/pixel_height = height * ICON_SIZE_Y
	var/far_x = 1 + pixel_width - ICON_SIZE_X
	var/far_y = 1 + pixel_height - ICON_SIZE_Y
	var/icon/frame = icon(ROGUE_GRID_ICON, "blank")
	frame.Scale(pixel_width, pixel_height)
	var/icon/piece = icon(ROGUE_GRID_ICON, "block_under")
	piece.Scale(pixel_width, pixel_height)
	frame.Blend(piece, ICON_OVERLAY)
	for(var/list/edge as anything in list(list("down", 1), list("up", far_y)))
		piece = icon(ROGUE_GRID_ICON, edge[1])
		piece.Scale(pixel_width, ICON_SIZE_Y)
		frame.Blend(piece, ICON_OVERLAY, 1, edge[2])
	for(var/list/edge as anything in list(list("left", 1), list("right", far_x)))
		piece = icon(ROGUE_GRID_ICON, edge[1])
		piece.Scale(ICON_SIZE_X, pixel_height)
		frame.Blend(piece, ICON_OVERLAY, edge[2], 1)
	frame.Blend(icon(ROGUE_GRID_ICON, "corner_left_down"), ICON_OVERLAY, 1, 1)
	frame.Blend(icon(ROGUE_GRID_ICON, "corner_right_down"), ICON_OVERLAY, far_x, 1)
	frame.Blend(icon(ROGUE_GRID_ICON, "corner_left_up"), ICON_OVERLAY, 1, far_y)
	frame.Blend(icon(ROGUE_GRID_ICON, "corner_right_up"), ICON_OVERLAY, far_x, far_y)
	var/mutable_appearance/look = mutable_appearance(fcopy_rsc(frame))
	look.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	look.transform = matrix().Translate(-(pixel_width - ICON_SIZE_X) / 2, -(pixel_height - ICON_SIZE_Y) / 2)
	frames[key] = look
	return look

/datum/storage/rogue_grid
	storage_type = /datum/storage_interface/rogue_grid
	max_slots = INFINITY
	max_total_storage = INFINITY
	var/rogue_not_while_equipped = FALSE
	var/list/rogue_spots
	var/list/rogue_cells
	var/list/rogue_frames
	var/list/rogue_target

/datum/storage/rogue_grid/New(atom/parent, max_slots, max_specific_storage, max_total_storage, rustle_sound, remove_rustle_sound)
	. = ..()
	src.max_slots = min(src.max_slots, screen_max_columns * screen_max_rows)
	for(var/obj/item/thing in real_location)
		rogue_place(thing)

/datum/storage/rogue_grid/Destroy()
	for(var/obj/item/thing as anything in rogue_frames)
		thing.underlays -= rogue_frames[thing]
	rogue_spots = null
	rogue_cells = null
	rogue_frames = null
	return ..()

/datum/storage/rogue_grid/can_insert(obj/item/to_insert, mob/user, messages = TRUE, force = STORAGE_NOT_LOCKED)
	. = ..()
	if(!. || rogue_find_spot(to_insert, rogue_target))
		return
	if(messages && user && !silent_for_user)
		user.balloon_alert(user, "no room!")
	return FALSE

/datum/storage/rogue_grid/handle_enter(datum/source, obj/item/arrived)
	SIGNAL_HANDLER
	if(istype(arrived))
		rogue_place(arrived, rogue_target)
	rogue_target = null
	return ..()

/datum/storage/rogue_grid/item_init(datum/source, obj/item/inited)
	SIGNAL_HANDLER
	if(istype(inited))
		rogue_place(inited)
	return ..()

/datum/storage/rogue_grid/handle_exit(datum/source, obj/item/gone)
	SIGNAL_HANDLER
	rogue_unplace(gone)
	return ..()

/datum/storage/rogue_grid/mousedrop_receive(atom/dropped_onto, atom/movable/target, mob/user, params)
	SIGNAL_HANDLER
	return

/datum/storage/rogue_grid/contents_changed_w_class(datum/source, obj/item/changed, old_w_class, new_w_class)
	SIGNAL_HANDLER
	. = ..()
	if(changed.loc != real_location)
		return
	rogue_unplace(changed)
	rogue_place(changed)
	refresh_views()

/datum/storage/rogue_grid/open_storage(mob/living/to_show)
	if(rogue_not_while_equipped && ishuman(to_show) && parent.loc == to_show)
		var/mob/living/carbon/human/wearer = to_show
		if(parent == wearer.back || parent == wearer.wear_backr)
			if(!wearer.get_active_held_item())
				wearer.putItemFromInventoryInHandIfPossible(parent, wearer.active_hand_index)
			return FALSE
	return ..()

/datum/storage/rogue_grid/proc/rogue_spot_free(x, y, width, height, obj/item/thing)
	if(x < 0 || y < 0 || x + width > screen_max_columns || y + height > screen_max_rows)
		return FALSE
	for(var/cell_x in x to x + width - 1)
		for(var/cell_y in y to y + height - 1)
			var/obj/item/occupant = LAZYACCESS(rogue_cells, "[cell_x],[cell_y]")
			if(occupant && occupant != thing)
				return FALSE
	return TRUE

/datum/storage/rogue_grid/proc/rogue_find_spot(obj/item/thing, list/target)
	var/list/footprint = thing.rogue_grid_footprint()
	var/list/footprints = list(footprint)
	if(footprint[1] != footprint[2])
		footprints += list(list(footprint[2], footprint[1]))
	for(var/list/size as anything in footprints)
		if(target)
			if(rogue_spot_free(target[1], target[2], size[1], size[2], thing))
				return list(target[1], target[2], size[1], size[2])
			continue
		for(var/y in screen_max_rows - size[2] to 0 step -1)
			for(var/x in 0 to screen_max_columns - size[1])
				if(rogue_spot_free(x, y, size[1], size[2], thing))
					return list(x, y, size[1], size[2])
	return null

/datum/storage/rogue_grid/proc/rogue_spot_cells(list/spot)
	. = list()
	for(var/cell_x in spot[1] to spot[1] + spot[3] - 1)
		for(var/cell_y in spot[2] to spot[2] + spot[4] - 1)
			. += "[cell_x],[cell_y]"

/datum/storage/rogue_grid/proc/rogue_place(obj/item/thing, list/target)
	if(LAZYACCESS(rogue_spots, thing))
		return
	var/list/spot = (target && rogue_find_spot(thing, target)) || rogue_find_spot(thing)
	if(spot)
		for(var/cell in rogue_spot_cells(spot))
			LAZYSET(rogue_cells, cell, thing)
	else
		var/list/footprint = thing.rogue_grid_footprint()
		spot = list(0, max(0, screen_max_rows - footprint[2]), footprint[1], footprint[2])
	LAZYSET(rogue_spots, thing, spot)
	var/mutable_appearance/frame = rogue_grid_frame(spot[3], spot[4])
	thing.underlays += frame
	LAZYSET(rogue_frames, thing, frame)

/datum/storage/rogue_grid/proc/rogue_unplace(obj/item/thing)
	var/list/spot = LAZYACCESS(rogue_spots, thing)
	if(!spot)
		return
	for(var/cell in rogue_spot_cells(spot))
		if(LAZYACCESS(rogue_cells, cell) == thing)
			LAZYREMOVE(rogue_cells, cell)
	LAZYREMOVE(rogue_spots, thing)
	thing.underlays -= LAZYACCESS(rogue_frames, thing)
	LAZYREMOVE(rogue_frames, thing)

/datum/storage/rogue_grid/proc/rogue_move(obj/item/thing, list/target)
	var/list/spot = rogue_find_spot(thing, target)
	if(!spot)
		return FALSE
	rogue_unplace(thing)
	rogue_place(thing, target)
	refresh_views()
	return TRUE

/datum/storage_interface/rogue_grid
	var/atom/movable/screen/rogue_grid_hover/hover

/datum/storage_interface/rogue_grid/New(ui_style, datum/storage/parent_storage, mob/user)
	. = ..()
	QDEL_NULL(cells)
	var/atom/movable/screen/storage/cell/rogue_grid/grid_cells = new(null, user.hud_used, parent_storage)
	hover = new(null, user.hud_used)
	grid_cells.hover = hover
	cells = grid_cells
	for(var/atom/movable/screen/storage/hidden as anything in list(corner_top_left, corner_top_right, corner_bottom_left, corner_bottom_right, rowjoin_left, rowjoin_right))
		hidden.invisibility = INVISIBILITY_ABSTRACT

/datum/storage_interface/rogue_grid/Destroy(force)
	QDEL_NULL(hover)
	return ..()

/datum/storage_interface/rogue_grid/list_ui_elements(initializing = FALSE)
	. = ..()
	if(!initializing && hover)
		. += hover

/datum/storage_interface/rogue_grid/update_position(screen_start_x, screen_pixel_x, screen_start_y, screen_pixel_y, columns, rows, mob/user_looking, atom/real_location, list/datum/numbered_display/numbered_contents)
	return ..(screen_start_x, screen_pixel_x, screen_start_y, screen_pixel_y, parent_storage.screen_max_columns, parent_storage.screen_max_rows, user_looking, real_location, numbered_contents)

/datum/storage_interface/rogue_grid/add_items(screen_start_x, screen_pixel_x, screen_start_y, screen_pixel_y, columns, rows, mob/user_looking, atom/real_location, list/datum/numbered_display/numbered_contents)
	var/atom/movable/screen/storage/cell/rogue_grid/grid_cells = cells
	grid_cells.origin_x = screen_start_x * ICON_SIZE_X + screen_pixel_x
	grid_cells.origin_y = screen_start_y * ICON_SIZE_Y + screen_pixel_y
	var/datum/storage/rogue_grid/grid = parent_storage
	var/turf/our_turf = get_turf(real_location)
	for(var/obj/item/item in real_location)
		var/list/spot = LAZYACCESS(grid.rogue_spots, item)
		if(!spot)
			continue
		item.mouse_opacity = MOUSE_OPACITY_OPAQUE
		var/item_x = grid_cells.origin_x + spot[1] * ICON_SIZE_X + (spot[3] - 1) * ICON_SIZE_X / 2 + item.base_pixel_x
		var/item_y = grid_cells.origin_y + spot[2] * ICON_SIZE_Y + (spot[4] - 1) * ICON_SIZE_Y / 2 + item.base_pixel_y
		item.screen_loc = offset_to_screen_loc(item_x, item_y)
		SET_PLANE(item, ABOVE_HUD_PLANE, our_turf)

/atom/movable/screen/storage/cell/rogue_grid
	icon = ROGUE_GRID_ICON
	icon_state = "background"
	alpha = 180
	var/origin_x = 0
	var/origin_y = 0
	var/atom/movable/screen/rogue_grid_hover/hover

/atom/movable/screen/storage/cell/rogue_grid/Destroy()
	hover = null
	return ..()

/atom/movable/screen/storage/cell/rogue_grid/proc/cell_at(params)
	var/screen_loc = LAZYACCESS(params2list(params), SCREEN_LOC)
	if(!screen_loc || !usr?.client)
		return null
	var/list/offset = screen_loc_to_offset(screen_loc, usr.client.view)
	return list(floor((offset[1] - 1 - origin_x) / ICON_SIZE_X), floor((offset[2] - 1 - origin_y) / ICON_SIZE_Y))

/atom/movable/screen/storage/cell/rogue_grid/Click(location, control, params)
	var/datum/storage/rogue_grid/grid = master_ref?.resolve()
	if(istype(grid))
		grid.rogue_target = cell_at(params)
	. = ..()
	if(istype(grid))
		grid.rogue_target = null
	update_hover(params)

/atom/movable/screen/storage/cell/rogue_grid/mouse_drop_receive(atom/target, mob/living/user, params)
	var/datum/storage/rogue_grid/grid = master_ref?.resolve()
	if(!istype(grid) || !istype(user) || grid != user.active_storage || !isitem(target))
		return
	if(!user.can_perform_action(grid.parent, FORBID_TELEKINESIS_REACH))
		return
	var/list/cell = cell_at(params)
	if(!cell)
		return
	if(target.loc == grid.real_location)
		grid.rogue_move(target, cell)
		return
	if(!user.is_holding(target))
		return
	grid.rogue_target = cell
	grid.attempt_insert(target, user)
	grid.rogue_target = null

/atom/movable/screen/storage/cell/rogue_grid/MouseEntered(location, control, params)
	. = ..()
	update_hover(params)

/atom/movable/screen/storage/cell/rogue_grid/MouseMove(location, control, params)
	update_hover(params)

/atom/movable/screen/storage/cell/rogue_grid/MouseExited(location, control, params)
	. = ..()
	if(hover)
		hover.invisibility = INVISIBILITY_ABSTRACT

/atom/movable/screen/storage/cell/rogue_grid/proc/update_hover(params)
	if(!hover)
		return
	hover.invisibility = INVISIBILITY_ABSTRACT
	var/datum/storage/rogue_grid/grid = master_ref?.resolve()
	var/mob/user = usr
	if(!istype(grid) || !istype(user) || user.active_storage != grid)
		return
	var/obj/item/held = user.get_active_held_item()
	var/list/cell = cell_at(params)
	if(!held || !cell)
		return
	grid.rogue_target = cell
	var/fits = grid.can_insert(held, user, messages = FALSE)
	grid.rogue_target = null
	var/list/footprint = (fits && grid.rogue_find_spot(held, cell)) || held.rogue_grid_footprint()
	var/width = fits ? footprint[3] : footprint[1]
	var/height = fits ? footprint[4] : footprint[2]
	hover.color = fits ? ROGUE_GRID_FITS_COLOR : ROGUE_GRID_BLOCKED_COLOR
	hover.transform = matrix(width, 0, (width - 1) * ICON_SIZE_X / 2, 0, height, (height - 1) * ICON_SIZE_Y / 2)
	hover.screen_loc = offset_to_screen_loc(origin_x + cell[1] * ICON_SIZE_X, origin_y + cell[2] * ICON_SIZE_Y)
	hover.invisibility = 0

/atom/movable/screen/rogue_grid_hover
	icon = ROGUE_GRID_ICON
	icon_state = "white"
	plane = ABOVE_HUD_PLANE
	alpha = 96
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = INVISIBILITY_ABSTRACT
	hud_group_key = HUD_GROUP_STORAGE
