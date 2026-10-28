GLOBAL_LIST_INIT(rockhill_vein_drops, list(
	ROCKHILL_VEIN_SALT = list(/obj/item/reagent_containers/powder/salt, /obj/item/natural/rock/salt),
	ROCKHILL_VEIN_IRON = list(/obj/item/rogueore/iron, /obj/item/natural/rock/iron),
	ROCKHILL_VEIN_COPPER = list(/obj/item/rogueore/copper, null),
	ROCKHILL_VEIN_TIN = list(/obj/item/rogueore/tin, null),
	ROCKHILL_VEIN_COAL = list(/obj/item/rogueore/coal, /obj/item/natural/rock/coal),
	ROCKHILL_VEIN_GOLD = list(/obj/item/rogueore/gold, null),
	ROCKHILL_VEIN_SILVER = list(/obj/item/rogueore/silver, /obj/item/natural/rock/silver),
	ROCKHILL_VEIN_CINNABAR = list(/obj/item/rogueore/cinnabar, null),
	ROCKHILL_VEIN_GEM = list(/obj/item/roguegem/random, /obj/item/natural/rock/gem),
	ROCKHILL_VEIN_MOTE = list(null, null),
))

GLOBAL_LIST_INIT(rockhill_random_veins, rockhill_init_random_veins())

/proc/rockhill_init_random_veins()
	var/list/common = list(ROCKHILL_VEIN_SALT = 5, ROCKHILL_VEIN_IRON = 15, ROCKHILL_VEIN_COPPER = 10, ROCKHILL_VEIN_COAL = 25)
	var/list/med = list(ROCKHILL_VEIN_SALT = 5, ROCKHILL_VEIN_GOLD = 3, ROCKHILL_VEIN_SILVER = 2, ROCKHILL_VEIN_IRON = 33, ROCKHILL_VEIN_MOTE = 15, ROCKHILL_VEIN_CINNABAR = 15, ROCKHILL_VEIN_COPPER = 15, ROCKHILL_VEIN_TIN = 10, ROCKHILL_VEIN_COAL = 14, ROCKHILL_VEIN_GEM = 1)
	var/list/high = list(ROCKHILL_VEIN_MOTE = 15, ROCKHILL_VEIN_CINNABAR = 15, ROCKHILL_VEIN_SALT = 5, ROCKHILL_VEIN_GOLD = 9, ROCKHILL_VEIN_SILVER = 5, ROCKHILL_VEIN_IRON = 33, ROCKHILL_VEIN_COPPER = 20, ROCKHILL_VEIN_TIN = 12, ROCKHILL_VEIN_COAL = 19, ROCKHILL_VEIN_GEM = 3)
	return list(
		/turf/closed/mineral/random/rogue = list(23, common),
		/turf/closed/mineral/random/rogue/boglava = list(23, common),
		/turf/closed/mineral/random/rogue/ironcoal = list(23, common),
		/turf/closed/mineral/random/rogue/med = list(10, med),
		/turf/closed/mineral/random/rogue/high = list(33, high),
		/turf/closed/mineral/random/rogue/coppertin/med = list(10, list(ROCKHILL_VEIN_GOLD = 3, ROCKHILL_VEIN_SILVER = 2, ROCKHILL_VEIN_COPPER = 33, ROCKHILL_VEIN_TIN = 12, ROCKHILL_VEIN_GEM = 1)),
		/turf/closed/mineral/random/rogue/ironcoal/med = list(10, list(ROCKHILL_VEIN_SALT = 5, ROCKHILL_VEIN_GOLD = 3, ROCKHILL_VEIN_SILVER = 2, ROCKHILL_VEIN_IRON = 33, ROCKHILL_VEIN_COAL = 14, ROCKHILL_VEIN_GEM = 1)),
		/turf/closed/mineral/random/rogue/boglava/med = list(20, list(ROCKHILL_VEIN_CINNABAR = 20, ROCKHILL_VEIN_GOLD = 10, ROCKHILL_VEIN_SILVER = 5, ROCKHILL_VEIN_IRON = 33, ROCKHILL_VEIN_COAL = 14, ROCKHILL_VEIN_GEM = 3)),
		/turf/closed/mineral/random/rogue/boglava/high = list(45, list(ROCKHILL_VEIN_CINNABAR = 20, ROCKHILL_VEIN_GOLD = 15, ROCKHILL_VEIN_SILVER = 10, ROCKHILL_VEIN_IRON = 33, ROCKHILL_VEIN_COAL = 19, ROCKHILL_VEIN_GEM = 6)),
	)

/turf/closed/rockhill
	var/rockhill_rock = FALSE
	var/rockhill_minable = FALSE
	var/rockhill_vein

/turf/closed/mineral/rogue
	rockhill_rock = TRUE
	rockhill_minable = TRUE

/turf/closed/mineral/random/rogue
	rockhill_rock = TRUE
	rockhill_minable = TRUE

/turf/closed/mineral/rogue/bedrock
	rockhill_minable = FALSE

/turf/closed/mineral/rogue/salt
	rockhill_vein = ROCKHILL_VEIN_SALT

/turf/closed/mineral/rogue/coal
	rockhill_vein = ROCKHILL_VEIN_COAL

/turf/closed/mineral/rogue/gold
	rockhill_vein = ROCKHILL_VEIN_GOLD

/turf/closed/mineral/rogue/silver
	rockhill_vein = ROCKHILL_VEIN_SILVER

/turf/closed/mineral/rogue/cinnabar
	rockhill_vein = ROCKHILL_VEIN_CINNABAR

/turf/closed/mineral/rogue/gem
	rockhill_vein = ROCKHILL_VEIN_GEM

/turf/closed/mineral/rogue/elementalmote
	rockhill_vein = ROCKHILL_VEIN_MOTE

/proc/rockhill_is_pick(obj/item/tool)
	return istype(tool, /obj/item/rogueweapon/pick) || tool.tool_behaviour == TOOL_MINING

/turf/closed/rockhill/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!rockhill_rock || !rockhill_is_pick(tool))
		return ..()
	if(!rockhill_minable)
		to_chat(user, span_warning("TOO HARD!"))
		return ITEM_INTERACT_BLOCKING
	rockhill_mine(user, tool)
	return ITEM_INTERACT_SUCCESS

/turf/closed/rockhill/proc/rockhill_mine(mob/living/user, obj/item/tool)
	if(user.body_position != STANDING_UP)
		to_chat(user, span_warning("I need to stand up to get a proper swing."))
		return
	if(DOING_INTERACTION_WITH_TARGET(user, src))
		return
	var/swings = max(rogue_formula_value(ROGUE_FORMULA_MINING_SWINGS, list(
		"integrity" = ROCKHILL_ROCK_INTEGRITY,
		"force" = tool.force,
		"mining" = user.rogue_skill_rank(/datum/attribute/skill/labor/mining),
	)), 1)
	user.visible_message(span_notice("[user] starts mining [src]."), span_notice("I start mining [src]."))
	for(var/swing in 1 to swings)
		if(ishuman(user))
			var/mob/living/carbon/human/miner = user
			if(miner.rogue_energy <= 0)
				to_chat(user, span_warning("I'm too tired to keep mining."))
				return
		if(!do_after(user, ROCKHILL_MINE_SWING_TIME, target = src))
			return
		if(!istype(src, /turf/closed/rockhill) || !rockhill_minable || QDELETED(tool) || user.get_active_held_item() != tool)
			return
		user.do_attack_animation(src)
		playsound(src, pick(ROCKHILL_MINE_SOUNDS), 70, TRUE)
		shake_camera(user, 1, 1)
		user.adjust_stamina_loss(ROCKHILL_MINE_STAMINA)
		user.rogue_adjust_experience(/datum/attribute/skill/labor/mining, max(round(user.rogue_stat(ROGUE_STAT_INTELLIGENCE) * ROCKHILL_MINE_XP_PER_INT), 1), silent = TRUE)
	rockhill_drill(user)

/turf/closed/rockhill/proc/rockhill_roll_vein()
	if(rockhill_vein)
		return rockhill_vein
	var/list/spec = GLOB.rockhill_random_veins[type]
	if(!spec || !prob(spec[1]))
		return null
	return pick_weight(spec[2])

/turf/closed/rockhill/proc/rockhill_drill(mob/living/user)
	new /obj/item/natural/stone(src)
	if(prob(ROCKHILL_MINE_EXTRA_STONE_CHANCE))
		new /obj/item/natural/stone(src)
	var/vein = rockhill_roll_vein()
	var/list/drops = vein ? GLOB.rockhill_vein_drops[vein] : null
	if(drops)
		var/ore_type = drops[1]
		var/rock_type = drops[2]
		if(ore_type && prob(ROCKHILL_MINE_ORE_CHANCE))
			new ore_type(src)
		if(rock_type)
			new rock_type(src)
			if(prob(ROCKHILL_MINE_EXTRA_ROCK_CHANCE))
				new rock_type(src)
	else if(user?.rogue_goodluck(ROCKHILL_MINE_LUCK_MULTIPLIER))
		var/bonus_type = pick_weight(list(/obj/item/natural/rock/salt = 2, /obj/item/natural/rock/iron = 1, /obj/item/natural/rock/coal = 2))
		new bonus_type(src)
	user?.log_message("mined [src] at [AREACOORD(src)]", LOG_GAME)
	ChangeTurf(ROCKHILL_MINED_FLOOR)

/obj/structure/roguerock
	max_integrity = 50

/obj/structure/roguerock/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/climbable, climb_time = ROCKHILL_BOULDER_CLIMB_TIME, climb_stun = 0)

/obj/structure/roguerock/atom_deconstruct(disassembled = TRUE)
	new /obj/item/natural/stone(drop_location())

/// Ratwood's random gem (rogueitems/gems.dm): becomes one gem by weight, or now and then a riddle of steel or silver ore.
/obj/item/roguegem/random/Initialize(mapload)
	..()
	var/static/list/gems = list(
		/obj/item/roguegem/ruby = 5,
		/obj/item/roguegem/green = 15,
		/obj/item/roguegem/blue = 10,
		/obj/item/roguegem/yellow = 20,
		/obj/item/roguegem/violet = 10,
		/obj/item/roguegem/diamond = 5,
		/obj/item/riddleofsteel = 1,
		/obj/item/rogueore/silver = 3,
		/obj/item/roguegem/blood_diamond = 1,
	)
	var/gem_type = pick_weight(gems)
	new gem_type(loc)
	return INITIALIZE_HINT_QDEL
