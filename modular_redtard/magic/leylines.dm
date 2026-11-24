/// Vibelin's leylines (datums/mana/leylines/): lines of latent mana across a level, each a big pool that fills slowly by
/// itself. A pool that draws on the leylines (a magic user, a focus, a pylon) takes from every line within reach. The lines
/// of a level are made the first time anything asks for them (rogue_leylines_on_z()), not while the world loads: making
/// them is only arithmetic, no objects. They are drawn - one invisible segment per tile, seen only with the leyline sight
/// (rogue_set_leyline_sight(): the shimmering lens, a spell) and by ghosts - the first time someone with that sight is on
/// the level, in the background (CHECK_TICK).

/// "[z]" = list of the leylines of that level, made on the first ask (empty on a level that has none).
GLOBAL_LIST_EMPTY(rogue_leylines)

/// The leylines of a level: the station levels of a medieval map have them (Vibelin ZTRAIT_LEYLINES), others none.
/proc/rogue_leylines_on_z(z)
	RETURN_TYPE(/list)
	if(!z)
		return list()
	var/key = "[z]"
	var/list/lines = GLOB.rogue_leylines[key]
	if(lines)
		return lines
	lines = list()
	GLOB.rogue_leylines[key] = lines
	if(!rogue_magic_enabled() || !is_station_level(z))
		return lines
	var/count = rogue_leyline_count()
	for(var/i in 1 to count)
		lines += new /datum/rogue_mana/leyline(null, z)
	// The pools that were waiting for a source on this level look again.
	for(var/datum/rogue_mana/waiting as anything in GLOB.rogue_mana_sourced_pools)
		var/turf/at = get_turf(waiting.holder)
		if(at?.z == z)
			waiting.recheck_sources()
	return lines

/// Vibelin get_initial_leyline_amount(): how many lines a level gets, by weight.
/proc/rogue_leyline_count()
	var/list/weights = list()
	for(var/i in 1 to 4)
		weights["[rogue_value("magic_leyline_count_[i]")]"] = round(rogue_value("magic_leyline_count_weight_[i]"))
	return text2num(pick_weight(weights)) || 0

/// The leylines within range of a turf, each with its distance in tiles: list(leyline = distance).
/proc/rogue_leylines_near(turf/here, range)
	RETURN_TYPE(/list)
	. = list()
	if(!here)
		return
	for(var/datum/rogue_mana/leyline/line as anything in rogue_leylines_on_z(here.z))
		if(line.capacity <= 0)
			continue
		var/distance = line.distance_to(here.x, here.y)
		if(distance <= range)
			.[line] = distance

/// Pools that draw on leylines or pylons by themselves and are not people: they look again when a source appears.
GLOBAL_LIST_EMPTY(rogue_mana_sourced_pools)

/// Vibelin /datum/mana_pool/leyline: a line from one edge of the level to the other, its capacity, refill and rate
/// scaled by an intensity picked by weight; it starts full.
/datum/rogue_mana/leyline
	var/z_level
	var/start_x
	var/start_y
	var/end_x
	var/end_y
	/// Vibelin leyline_intensity name, shown to admins.
	var/intensity
	var/beam_color
	var/drawn = FALSE

/datum/rogue_mana/leyline/New(atom/movable/new_holder, z_level)
	src.z_level = z_level
	return ..(null)

/datum/rogue_mana/leyline/setup()
	var/static/list/intensities = list("none", "minimal", "extremely_low", "low", "below_average", "average", "above_average", "high", "extreme")
	var/list/weights = list()
	for(var/level in intensities)
		weights[level] = round(rogue_value("magic_leyline_[level]_weight"))
	intensity = pick_weight(weights) || "low"
	var/mult = rogue_value("magic_leyline_[intensity]_mult")
	capacity = rogue_value("magic_leyline_capacity") * mult
	base_softcap = capacity
	regen = rogue_value("magic_leyline_regen") * mult
	donation_rate = rogue_value("magic_leyline_donation") * mult
	amount = capacity
	// Vibelin's colours of the forms (GLOB.form_colors).
	beam_color = pick("#ff6a00", "#3aa0ff", "#7ad84a", "#b07a3a", "#c9f2ff", "#8a2be2", "#ffe066", "#e0e0e0")
	pick_ends()

/// Vibelin generate_start_and_end(): from one edge to the opposite one, each end anywhere along it.
/datum/rogue_mana/leyline/proc/pick_ends()
	switch(pick(GLOB.cardinals))
		if(NORTH)
			start_y = world.maxy
			end_y = 1
			start_x = rand(1, world.maxx)
			end_x = rand(1, world.maxx)
		if(SOUTH)
			start_y = 1
			end_y = world.maxy
			start_x = rand(1, world.maxx)
			end_x = rand(1, world.maxx)
		if(EAST)
			start_x = 1
			end_x = world.maxx
			start_y = rand(1, world.maxy)
			end_y = rand(1, world.maxy)
		if(WEST)
			start_x = world.maxx
			end_x = 1
			start_y = rand(1, world.maxy)
			end_y = rand(1, world.maxy)

/// How far a tile is from the line, in tiles.
/datum/rogue_mana/leyline/proc/distance_to(x, y)
	var/dx = end_x - start_x
	var/dy = end_y - start_y
	var/length_squared = dx * dx + dy * dy
	var/along = length_squared ? clamp(((x - start_x) * dx + (y - start_y) * dy) / length_squared, 0, 1) : 0
	var/off_x = start_x + along * dx - x
	var/off_y = start_y + along * dy - y
	return sqrt(off_x * off_x + off_y * off_y)

/// Lays the line out in invisible segments, one a tile, as TG's beams are drawn; checks the tick, so it is called async.
/datum/rogue_mana/leyline/proc/draw()
	if(drawn)
		return
	drawn = TRUE
	var/dx = end_x - start_x
	var/dy = end_y - start_y
	var/tiles = CEILING(sqrt(dx * dx + dy * dy), 1)
	if(tiles <= 0)
		return
	// Clockwise from north, as TG beams turn.
	var/angle = 90 - arctan(dx, dy)
	var/matrix/turn = matrix()
	turn.Turn(angle)
	for(var/step in 0 to tiles - 1)
		var/along = (step + 0.5) * ICON_SIZE_X
		var/off_x = sin(angle) * along
		var/off_y = cos(angle) * along
		var/tile_x = round(off_x / ICON_SIZE_X + 0.5)
		var/tile_y = round(off_y / ICON_SIZE_Y + 0.5)
		var/turf/spot = locate(start_x + tile_x, start_y + tile_y, z_level)
		if(spot)
			var/obj/effect/rogue_leyline/segment = new(spot)
			segment.transform = turn
			segment.pixel_x = round(off_x - tile_x * ICON_SIZE_X)
			segment.pixel_y = round(off_y - tile_y * ICON_SIZE_Y)
			segment.color = beam_color
		CHECK_TICK

/// Draws the leylines of a level that are not drawn yet.
/proc/rogue_draw_leylines(z)
	for(var/datum/rogue_mana/leyline/line as anything in rogue_leylines_on_z(z))
		line.draw()

/// One tile of a leyline (Vibelin /obj/effect/ebeam/leyline): seen only with the leyline sight.
/obj/effect/rogue_leyline
	name = "leyline"
	icon = 'icons/effects/beam.dmi'
	icon_state = "blood"
	invisibility = ROGUE_INVISIBILITY_LEYLINES
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = BELOW_OBJ_LAYER
	vis_flags = VIS_HIDE
	alpha = 160

/// A pylon link's beam (Vibelin's medbeam on the leyline plane): seen only with the leyline sight.
/obj/effect/ebeam/rogue_leyline
	invisibility = ROGUE_INVISIBILITY_LEYLINES

// ---------------------------------------------------------------------------------------------------------------------------
// Seeing them.

/// Gives or takes the leyline sight from a source (Vibelin TRAIT_SEE_LEYLINES and SEE_INVISIBLE_LEYLINES).
/mob/living/proc/rogue_set_leyline_sight(source, enabled)
	var/had = HAS_TRAIT(src, TRAIT_ROGUE_SEE_LEYLINES)
	if(enabled)
		ADD_TRAIT(src, TRAIT_ROGUE_SEE_LEYLINES, source)
	else
		REMOVE_TRAIT(src, TRAIT_ROGUE_SEE_LEYLINES, source)
	var/has = HAS_TRAIT(src, TRAIT_ROGUE_SEE_LEYLINES)
	if(has == had)
		return
	if(has)
		AddElement(/datum/element/rogue_leyline_sight)
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(rogue_draw_leylines), z)
	else
		RemoveElement(/datum/element/rogue_leyline_sight)
	update_sight()

/// Keeps the leyline sight through every sight update, and draws the lines of a level the seer comes to.
/datum/element/rogue_leyline_sight

/datum/element/rogue_leyline_sight/Attach(datum/target)
	. = ..()
	if(!ismob(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_MOB_UPDATE_SIGHT, PROC_REF(on_update_sight))
	RegisterSignal(target, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(on_z_changed))

/datum/element/rogue_leyline_sight/Detach(datum/source)
	UnregisterSignal(source, list(COMSIG_MOB_UPDATE_SIGHT, COMSIG_MOVABLE_Z_CHANGED))
	return ..()

/datum/element/rogue_leyline_sight/proc/on_update_sight(mob/source)
	SIGNAL_HANDLER
	if(HAS_TRAIT(source, TRAIT_ROGUE_SEE_LEYLINES) && source.see_invisible < ROGUE_SEE_INVISIBLE_LEYLINES)
		source.set_invis_see(ROGUE_SEE_INVISIBLE_LEYLINES)

/datum/element/rogue_leyline_sight/proc/on_z_changed(atom/movable/source, turf/old_turf, turf/new_turf, same_z_layer)
	SIGNAL_HANDLER
	if(new_turf)
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(rogue_draw_leylines), new_turf.z)

/// Vibelin's shimmering lens (items/mageitems.dm): looked through (use it in hand), it shows the leylines.
/obj/item/clothing/ring/active/shimmeringlens
	var/rogue_looking = FALSE
	var/mob/living/rogue_looker

/obj/item/clothing/ring/active/shimmeringlens/attack_self(mob/user, modifiers)
	. = ..()
	if(. || !rogue_magic_enabled() || !isliving(user))
		return
	if(rogue_looking)
		user.visible_message(span_warning("[user] stops looking through [src]."))
		rogue_stop_looking()
	else
		user.visible_message(span_warning("[user] looks through [src]!"))
		rogue_looking = TRUE
		rogue_looker = user
		rogue_looker.rogue_set_leyline_sight(ROGUE_LEYLINE_LENS_TRAIT, TRUE)
	return TRUE

/obj/item/clothing/ring/active/shimmeringlens/dropped(mob/user, silent)
	. = ..()
	if(rogue_looking)
		rogue_stop_looking()

/obj/item/clothing/ring/active/shimmeringlens/Destroy()
	if(rogue_looking)
		rogue_stop_looking()
	return ..()

/obj/item/clothing/ring/active/shimmeringlens/proc/rogue_stop_looking()
	rogue_looking = FALSE
	if(!QDELETED(rogue_looker))
		rogue_looker.rogue_set_leyline_sight(ROGUE_LEYLINE_LENS_TRAIT, FALSE)
	rogue_looker = null

// ---------------------------------------------------------------------------------------------------------------------------
// Ratwood's leyline circles (/obj/structure/leyline, on Rockhill and from the wilderness generator), as Vibelin's
// (structures/mage_structures.dm): one who knows the arcyne wakes the circle; an awake circle drained by anyone yields a
// leyline shard and sleeps again for a long while; draining may lash out instead. Vibelin's guardian (a leyline lycan)
// that may come out of it is not here: there is no such creature in the module, the lash is the guardian's feedback.

/obj/structure/leyline
	var/rogue_awake = FALSE
	var/rogue_drained_at = 0

/obj/structure/leyline/Initialize(mapload)
	. = ..()
	rogue_drained_at = world.time

/obj/structure/leyline/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(. || !rogue_magic_enabled() || !isliving(user))
		return
	INVOKE_ASYNC(src, PROC_REF(rogue_touch), user)
	return TRUE

/obj/structure/leyline/proc/rogue_touch(mob/living/user)
	if(world.time < rogue_drained_at + rogue_value("magic_leyline_circle_cooldown"))
		to_chat(user, span_notice("The leyline appears to be drained of energy."))
		return
	var/knows = user.rogue_magic_rank(/datum/attribute/skill/magic/arcane) > 0
	if(!rogue_awake)
		if(!knows)
			to_chat(user, span_notice("I wave a hand through the circle of rocks. Nothing happens."))
			return
		to_chat(user, span_notice("I wave a hand through the circle of rocks, and pulse my arcyne magic through it. The leyline activates!"))
		rogue_awake = TRUE
		icon_state = "leylinerupture"
		name = "active leyline"
		desc = "An active tear into the leyline. It gives off plenty of energy."
		return
	if(!do_after(user, rogue_value("magic_leyline_circle_drain_time"), src) || !rogue_awake)
		return
	if(prob(rogue_value("magic_leyline_circle_backlash_chance")))
		to_chat(user, span_danger("I reach out towards the active leyline, and it lashes out at me!"))
		user.electrocute_act(rogue_value("magic_leyline_circle_backlash_shock"), src)
		return
	to_chat(user, span_notice("I reach out towards the active leyline, and it shatters! A large, usable piece of it drops at my feet."))
	new /obj/item/magic/leyline(get_turf(user))
	rogue_awake = FALSE
	icon_state = "inactiveleyline"
	name = "inactive leyline"
	desc = "A curious arrangement of stones."
	rogue_drained_at = world.time
