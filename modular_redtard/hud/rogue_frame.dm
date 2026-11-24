/// The frame of the rogue HUD (owner's requests of 2026-11-24): Roguetown's frame around the field, plain darkness around
/// it and the buttons on that darkness — the left column in the middle of the darkness left of the field, the bottom row
/// on the bottom edge of the window, none of them over the field.
///
/// BYOND fits the whole screen (the view and the borders that screen objects add to it) into the map control and leaves
/// blank bars where their shapes differ. Nothing can be drawn on those bars (DM reference, screen_loc: "letterboxing ...
/// is not considered usable space"), so the buttons could not reach the window's edges: a wide window had a bar left of
/// the left column, a tall one a bar under the bottom row. The darkness makes the bars part of the screen: border rows and
/// columns of black tiles, as many as give the screen the shape of the control. The bottom row then lies on the control's
/// bottom edge and the left column stands in the middle of the black space left of the field, while the field keeps its
/// view and stays in the middle. The tiles are the black of the bars, so no edge shows between them.
///
/// The planes of the world are drawn on borders too (they are screen objects, not the map BYOND clips to the view), and a
/// ring of the map one tile wide is known to the client beyond the view: every border tile is covered by an opaque piece
/// that takes the mouse, or the game would show around the field and answer to the pointer there.

/// A map control smaller than this in either direction is not laid out for.
#define ROGUE_FRAME_MIN_CONTROL 200
/// Part of a tile the screen may hang over the control before another row or column is counted: a few pixels of blank
/// bar are not worth a row.
#define ROGUE_FRAME_OVERHANG 0.03
/// Most border columns on one side of the field, and most border rows above it or between it and the bottom row.
#define ROGUE_FRAME_MAX_COLUMNS 24
#define ROGUE_FRAME_MAX_ROWS 16
/// Tiles each way of the field the picture of the field's frame is drawn for.
#define ROGUE_FIELD_FRAME_TILES 15

/// Whether the darkness follows the size of the map window. Off, the screen is the field with the left column and the
/// bottom row and nothing more, whatever the window.
/datum/config_entry/flag/rogue_hud_frame
	default = TRUE

/client
	/// The map control of this client reports its size when the player resizes it (request_frame() asked it to).
	var/rogue_frame_hooked = FALSE

/atom/movable/screen
	/// Where the rogue HUD's layout has this element before the frame moves it (frame_loc()).
	var/rogue_frame_base

/datum/hud/rogue
	/// Border columns left of the field (the left column is one of them) and right of it.
	var/frame_left = 1
	var/frame_right = 0
	/// Border rows above the field, and rows between the field and the bottom row.
	var/frame_top = 0
	var/frame_gap = 0
	/// Pixels of an icon the left column stands right of the screen's left edge, to be in the middle of the black space.
	var/frame_left_shift = 0
	/// The size of the view the frame is laid out for, "15x15".
	var/frame_field
	/// The elements have been moved to their places in the frame at least once.
	var/frame_applied = FALSE

/// Roguetown's frame around the field: the picture Azure Peak and Vibelin draw with the back of their HUD, without the
/// stone panel beside it. It lies over the outermost ten pixels of the field, as it does there.
/atom/movable/screen/rogue/field_frame
	name = ""
	icon = ROGUE_HUD_ICON_FRAME
	icon_state = "frame"
	screen_loc = rogueui_field_frame
	layer = ROGUE_HUD_LAYER - 2
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/// The picture is drawn for a field of ROGUE_FIELD_FRAME_TILES tiles each way; over a field of another size it is
/// stretched, its lower left corner staying in the field's.
/atom/movable/screen/rogue/field_frame/proc/fit_field(columns, rows)
	var/across = columns / ROGUE_FIELD_FRAME_TILES
	var/up = rows / ROGUE_FIELD_FRAME_TILES
	var/half_width = ROGUE_FIELD_FRAME_TILES * ICON_SIZE_X / 2
	var/half_height = ROGUE_FIELD_FRAME_TILES * ICON_SIZE_Y / 2
	transform = matrix(across, 0, (across - 1) * half_width, 0, up, (up - 1) * half_height)

/// A piece of the darkness around the field: opaque black tiles on the borders of the screen.
/atom/movable/screen/rogue/darkness
	name = ""
	icon = ROGUE_HUD_ICON_STRIP
	icon_state = "fill"
	layer = ROGUE_HUD_LAYER - 1
	mouse_opacity = MOUSE_OPACITY_OPAQUE

/atom/movable/screen/rogue/darkness/left
	screen_loc = rogueui_dark_left

/atom/movable/screen/rogue/darkness/bottom
	screen_loc = rogueui_dark_bottom

/// A piece only a window wider or taller than the least screen has; hidden until fit_frame() gives it a place.
/atom/movable/screen/rogue/darkness/spare
	screen_loc = "CENTER"
	invisibility = INVISIBILITY_ABSTRACT

/datum/hud/rogue/initialize_screen_objects()
	. = ..()
	add_screen_object(/atom/movable/screen/rogue/field_frame, HUD_ROGUE_FIELD_FRAME, HUD_GROUP_ROGUE_PANEL)
	add_screen_object(/atom/movable/screen/rogue/darkness/left, HUD_ROGUE_DARK_LEFT, HUD_GROUP_ROGUE_PANEL)
	add_screen_object(/atom/movable/screen/rogue/darkness/bottom, HUD_ROGUE_DARK_BOTTOM, HUD_GROUP_ROGUE_PANEL)
	add_screen_object(/atom/movable/screen/rogue/darkness/spare, HUD_ROGUE_DARK_RIGHT, HUD_GROUP_ROGUE_PANEL)
	add_screen_object(/atom/movable/screen/rogue/darkness/spare, HUD_ROGUE_DARK_TOP, HUD_GROUP_ROGUE_PANEL)

/datum/hud/rogue/show_hud(version = 0, mob/viewmob)
	. = ..()
	if(!.)
		return
	apply_frame()
	request_frame()

/// TG makes the hand boxes anew when the number of hands changes: the new ones stand where the layout has them.
/datum/hud/rogue/build_hand_slots(update_hud = FALSE)
	. = ..()
	if(frame_applied)
		apply_frame()

/// TG tells the HUD of a changed view (a scope, the widescreen preference): the frame is laid out for the new field.
/datum/hud/rogue/on_viewdata_update(datum/source, view)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(request_frame))

/// Asks the client for the size of its map control and lays the HUD out for it. The first call also has the control
/// report every later resize by the player (.rogue-frame); TG's own fitting of the viewport changes the control through
/// winset(), which sends no such report, so it asks again itself (below).
/datum/hud/rogue/proc/request_frame()
	set waitfor = FALSE
	var/client/viewer = mymob?.client
	if(!viewer)
		return
	if(!CONFIG_GET(flag/rogue_hud_frame))
		fit_frame()
		return
	if(!viewer.rogue_frame_hooked)
		viewer.rogue_frame_hooked = TRUE
		winset(viewer, SKIN_MAPWINDOW_MAP, "on-size=\".rogue-frame \[\[width]] \[\[height]]\"")
	var/size = winget(viewer, SKIN_MAPWINDOW_MAP, "size")
	if(QDELETED(src) || mymob?.client != viewer)
		return
	var/list/parts = splittext("[size]", "x")
	if(length(parts) == 2)
		fit_frame(text2num(parts[1]), text2num(parts[2]))

GAME_VERB_NATIVE(/client, rogue_frame_resized, ".rogue-frame", null, width as num, height as num)
	var/datum/hud/rogue/frame_hud = mob?.hud_used
	if(istype(frame_hud))
		frame_hud.fit_frame(width, height)

/// The body of TG's Fit Viewport verb (the player's own, and the automatic one): it moves the splitter by winset(), and
/// the map control does not report such a change.
/client/__gvb_fit_viewport(list/structured_args)
	. = ..()
	var/datum/hud/rogue/frame_hud = mob?.hud_used
	if(istype(frame_hud))
		frame_hud.request_frame()

/// Sizes the darkness to a map control of width by height pixels and lays the HUD out in it; without a size, or with the
/// frame switched off, the screen is the least one.
/datum/hud/rogue/proc/fit_frame(width, height)
	var/client/viewer = mymob?.client
	if(!viewer)
		return
	var/list/view_size = getviewsize(viewer.view)
	var/field = "[view_size[1]]x[view_size[2]]"
	var/left = 1
	var/right = 0
	var/top = 0
	var/gap = 0
	var/shift = 0
	if(CONFIG_GET(flag/rogue_hud_frame) && isnum(width) && isnum(height) && width >= ROGUE_FRAME_MIN_CONTROL && height >= ROGUE_FRAME_MIN_CONTROL)
		// The least screen: the field, the left column and the bottom row.
		var/least_columns = view_size[1] + 1
		var/least_rows = view_size[2] + 1
		// As few rows as leave the screen no wider than the control: its height then fills the control, and the bottom
		// row lies on the control's bottom edge.
		var/rows = max(least_rows, CEILING(least_columns * height / width - ROGUE_FRAME_OVERHANG, 1))
		var/tile = height / rows
		var/columns = max(least_columns, FLOOR(width / tile + ROGUE_FRAME_OVERHANG, 1))
		// The border columns go to both sides of the field, the odd one to the left, where the column of elements is.
		var/spare = columns - view_size[1]
		left = min(CEILING(spare / 2, 1), ROGUE_FRAME_MAX_COLUMNS)
		right = min(FLOOR(spare / 2, 1), ROGUE_FRAME_MAX_COLUMNS)
		var/extra_rows = min(rows - least_rows, ROGUE_FRAME_MAX_ROWS * 2)
		top = FLOOR(extra_rows / 2, 1)
		gap = extra_rows - top
		// The left column in the middle of all that is black left of the field: the border columns and the blank sliver
		// BYOND leaves beside the screen.
		var/sliver = max(0, width - (view_size[1] + left + right) * tile) / 2
		shift = max(0, round(((left - 1) * tile - sliver) / 2 / tile * ICON_SIZE_X))
	if(frame_applied && field == frame_field && left == frame_left && right == frame_right && top == frame_top && gap == frame_gap && shift == frame_left_shift)
		return
	frame_left = left
	frame_right = right
	frame_top = top
	frame_gap = gap
	frame_left_shift = shift
	apply_frame()

/// Puts the frame of the field, the darkness and the elements of the left column and the bottom row where the frame has
/// them.
/datum/hud/rogue/proc/apply_frame()
	frame_applied = TRUE
	var/client/viewer = mymob?.client
	if(viewer)
		var/list/view_size = getviewsize(viewer.view)
		frame_field = "[view_size[1]]x[view_size[2]]"
		var/atom/movable/screen/rogue/field_frame/field_frame = screen_objects[HUD_ROGUE_FIELD_FRAME]
		field_frame?.fit_field(view_size[1], view_size[2])
	var/south_edge = "SOUTH-[frame_gap + 1]"
	var/north_edge = frame_top ? "NORTH+[frame_top]" : "NORTH"
	// Left of the field and under it; in a window wider or taller than the least screen, right of it and above it too.
	place_darkness(HUD_ROGUE_DARK_LEFT, "WEST-[frame_left],[south_edge] to WEST-1,[north_edge]")
	place_darkness(HUD_ROGUE_DARK_BOTTOM, "WEST,[south_edge] to EAST,SOUTH-1")
	place_darkness(HUD_ROGUE_DARK_RIGHT, frame_right ? "EAST+1,[south_edge] to EAST+[frame_right],[north_edge]" : null)
	place_darkness(HUD_ROGUE_DARK_TOP, frame_top ? "WEST,NORTH+1 to EAST,[north_edge]" : null)
	for(var/hud_key in screen_objects)
		var/atom/movable/screen/piece = screen_objects[hud_key]
		if(!istype(piece) || istype(piece, /atom/movable/screen/rogue/darkness))
			continue
		if(isnull(piece.rogue_frame_base))
			// FALSE: not an element of the left column or of the bottom row. The frame never moves it, whatever else
			// changes its place later (TG moves its palette buttons, for one).
			var/layout_place = piece.screen_loc
			piece.rogue_frame_base = (istext(layout_place) && !findtext(layout_place, " to ") && frame_loc(layout_place)) ? layout_place : FALSE
		if(piece.rogue_frame_base)
			piece.screen_loc = frame_loc(piece.rogue_frame_base)

/datum/hud/rogue/proc/place_darkness(hud_key, place)
	var/atom/movable/screen/piece = screen_objects[hud_key]
	if(!piece)
		return
	piece.screen_loc = place || "CENTER"
	piece.invisibility = place ? INVISIBILITY_NONE : INVISIBILITY_ABSTRACT

/// The place in the frame of an element the layout has at `base`: one in the left column (its x is WEST-1) goes to the
/// middle of the black space left of the field, one in the bottom row (its y is SOUTH-1) to the screen's bottom row.
/// Null for anything else: the frame leaves it alone.
/datum/hud/rogue/proc/frame_loc(base)
	var/static/regex/column = regex(@"^WEST-1(?::(-?\d+))?,")
	var/static/regex/bottom = regex(@",SOUTH-1(?::(-?\d+))?$")
	var/place = base
	var/moved = FALSE
	if(column.Find(place))
		var/pixels = text2num(column.group[1] || "0") + frame_left_shift
		place = "WEST-[frame_left][pixels ? ":[pixels]" : ""]," + copytext(place, length(column.match) + 1)
		moved = TRUE
	if(bottom.Find(place))
		var/pixels = bottom.group[1]
		place = copytext(place, 1, bottom.index) + ",SOUTH-[frame_gap + 1][pixels ? ":[pixels]" : ""]"
		moved = TRUE
	return moved ? place : null

#undef ROGUE_FRAME_MIN_CONTROL
#undef ROGUE_FRAME_OVERHANG
#undef ROGUE_FRAME_MAX_COLUMNS
#undef ROGUE_FRAME_MAX_ROWS
#undef ROGUE_FIELD_FRAME_TILES
