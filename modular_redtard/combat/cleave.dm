GLOBAL_LIST_EMPTY(rogue_cleave_patterns)

/proc/rogue_cleave_pattern(pattern_type)
	if(!ispath(pattern_type, /datum/cleave_pattern))
		return null
	if(!GLOB.rogue_cleave_patterns[pattern_type])
		GLOB.rogue_cleave_patterns[pattern_type] = new pattern_type
	return GLOB.rogue_cleave_patterns[pattern_type]

/datum/intent
	var/cleave

/datum/cleave_pattern
	var/list/tile_offsets = list()
	var/list/diagonal_offsets
	var/max_targets = 1
	var/respect_dir = TRUE
	var/user_relative = FALSE
	var/desc = "Cleaves into nearby targets."

/datum/cleave_pattern/proc/value_key()
	return "cleave_[replacetext(copytext("[type]", length("/datum/cleave_pattern/") + 1), "/", "_")]_max_targets"

/datum/cleave_pattern/proc/target_limit()
	return rogue_value_or(value_key(), max_targets)

/datum/cleave_pattern/proc/facing_dir(mob/living/user, turf/origin)
	var/turf/user_turf = get_turf(user)
	var/rel_x = origin.x - user_turf.x
	var/rel_y = origin.y - user_turf.y
	if(rel_x && rel_y)
		return (rel_x > 0 ? EAST : WEST) | (rel_y > 0 ? NORTH : SOUTH)
	return user.dir

/datum/cleave_pattern/proc/rotate_offset(dx, dy, dir)
	switch(dir)
		if(SOUTH)
			return list(-dx, -dy)
		if(WEST)
			return list(-dy, dx)
		if(EAST)
			return list(dy, -dx)
		if(NORTHEAST)
			return list(dx + dy, -dx + dy)
		if(NORTHWEST)
			return list(dx - dy, dx + dy)
		if(SOUTHEAST)
			return list(-dx + dy, -dx - dy)
		if(SOUTHWEST)
			return list(-dx - dy, dx - dy)
	return list(dx, dy)

/datum/cleave_pattern/proc/cleave_turfs(mob/living/user, turf/origin)
	. = list()
	if(!origin || !user)
		return
	var/use_dir = facing_dir(user, origin)
	var/turf/base_turf = user_relative ? get_turf(user) : origin
	var/diagonal = use_dir & (use_dir - 1)
	var/list/offsets = (diagonal && diagonal_offsets) ? diagonal_offsets : tile_offsets
	var/rotate_dir = use_dir
	if(diagonal && diagonal_offsets)
		switch(use_dir)
			if(NORTHEAST)
				rotate_dir = NORTH
			if(NORTHWEST)
				rotate_dir = WEST
			if(SOUTHEAST)
				rotate_dir = EAST
			if(SOUTHWEST)
				rotate_dir = SOUTH
	for(var/list/offset in offsets)
		var/list/rotated = respect_dir ? rotate_offset(offset[1], offset[2], rotate_dir) : offset
		var/turf/candidate = locate(base_turf.x + rotated[1], base_turf.y + rotated[2], base_turf.z)
		if(candidate && !candidate.density)
			. += candidate

/datum/cleave_pattern/adjacent
	tile_offsets = list(list(-1, 0), list(1, 0))
	desc = "Cleaves into an adjacent target."

/datum/cleave_pattern/forward_cleave
	tile_offsets = list(list(0, 1))
	desc = "Cleaves forward into a second target."

/datum/cleave_pattern/wide_sweep
	tile_offsets = list(list(-1, 0), list(1, 0), list(0, -1), list(0, 1))
	max_targets = 2
	desc = "Sweeps wide, cleaving up to two nearby targets."

/datum/cleave_pattern/horizontal_sweep
	tile_offsets = list(list(-1, 0), list(0, 0), list(1, 0))
	diagonal_offsets = list(list(-1, 0), list(0, 0), list(0, -1))
	max_targets = 2
	desc = "Sweeps horizontally, cleaving up to two additional targets."

/datum/cleave_pattern/frontal_arc
	tile_offsets = list(list(-1, 0), list(1, 0), list(-1, 1), list(0, 1), list(1, 1))
	diagonal_offsets = list(list(-1, 1), list(0, 1), list(1, 0), list(1, -1))
	user_relative = TRUE
	max_targets = 4
	desc = "Sweeps in a massive arc, hitting up to four targets to the sides and ahead."

/datum/cleave_pattern/lance
	tile_offsets = list(list(0, 1), list(0, 2))
	desc = "Lances forward, skewering a target three tiles ahead and anyone behind them."

/datum/cleave_pattern/frontal_t
	tile_offsets = list(list(-1, 1), list(0, 1), list(1, 1), list(0, 2))
	user_relative = TRUE
	max_targets = 2
	desc = "Cleaves in a T-shaped pattern directly ahead."

/obj/effect/temp_visual/dir_setting/rogue_cleave
	icon = ROGUE_SPECIAL_FX_ICON
	icon_state = "cut"
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_GAME_PLANE
	duration = 5

/mob/living/carbon/human/proc/rogue_cleave(datum/rogue_strike/strike)
	var/datum/cleave_pattern/pattern = rogue_cleave_pattern(strike.intent?.cleave)
	var/turf/origin = get_turf(strike.target)
	if(!pattern || !origin || QDELETED(strike.weapon))
		return
	var/list/area = pattern.cleave_turfs(src, origin)
	var/resolved_dir = pattern.facing_dir(src, origin)
	for(var/turf/marked as anything in area | list(origin))
		new /obj/effect/temp_visual/dir_setting/rogue_cleave(marked, resolved_dir)
	var/list/living_targets = list()
	var/list/dead_targets = list()
	for(var/turf/marked as anything in area)
		for(var/mob/living/victim in marked)
			if(victim == strike.target || victim == src)
				continue
			if(victim.stat == DEAD)
				dead_targets += victim
			else
				living_targets += victim
	var/limit = pattern.target_limit()
	var/hits = 0
	for(var/mob/living/victim as anything in living_targets + dead_targets)
		if(limit && hits >= limit)
			break
		var/datum/rogue_strike/cleave = new(src, victim, strike.weapon, strike.intent, ROGUE_STRIKE_CLEAVE, list())
		if(cleave.incoming() & ROGUE_STRIKE_CANCEL)
			qdel(cleave)
			continue
		if(victim.check_block(strike.weapon, strike.damage, "\the [strike.weapon]", MELEE_ATTACK, strike.weapon.armour_penetration, strike.weapon.damtype))
			qdel(cleave)
			continue
		cleave.zone = rogue_strike_zone(victim, strike.weapon, strike.intent)
		cleave.damage = strike.damage
		victim.rogue_take_strike(cleave)
		hits++
		qdel(cleave)
	if(hits && strike.weapon.max_blade_int && strike.intent.get_sharpness())
		strike.weapon.rogue_dull(ROGUE_BLADE_HIT_WEAR * ROGUE_CLEAVE_WEAR_FACTOR * hits, src)
