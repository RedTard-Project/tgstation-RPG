/obj/structure/trap/curse/trap_effect(mob/living/victim)
	to_chat(victim, span_danger("<B>A cruel joke has been played on you!</B>"))
	playsound(src, 'sound/effects/magic/curse.ogg', 60, TRUE)
	victim.add_mood_event("rockhill_fool", /datum/mood_event/rockhill_fool)

/datum/mood_event/rockhill_fool
	description = "I've been made a fool of."
	mood_change = -2
	timeout = 10 MINUTES

/obj/structure/trap/flame/trap_effect(mob/living/victim)
	to_chat(victim, span_danger("The ground suddenly erupts in flame!"))
	victim.adjust_fire_stacks(5)
	victim.ignite_mob()

/obj/structure/trap/shock/trap_effect(mob/living/victim)
	victim.electrocute_act(30, src, flags = SHOCK_NOGLOVES)
	victim.Paralyze(5 SECONDS)

/obj/structure/trap/bomb/trap_effect(mob/living/victim)
	explosion(src, light_impact_range = 1, flame_range = 2, smoke = TRUE, explosion_cause = src)

/obj/structure/trap/rock_fall/trap_effect(mob/living/victim)
	to_chat(victim, span_danger("<B>The ground above you shakes violently!</B>"))
	victim.apply_damage(ROCKHILL_TRAP_DAMAGE, BRUTE, BODY_ZONE_HEAD, victim.run_armor_check(BODY_ZONE_HEAD, MELEE))
	playsound(src, 'modular_redtard/rockhill/sound/foley/smash_rock.ogg', 70, TRUE)
	victim.set_eye_blur_if_lower(10 SECONDS)
	var/obj/structure/flora/rock/giant_rock = new(get_turf(src))
	QDEL_IN(giant_rock, 10 SECONDS)

/obj/structure/trap/saw_blades/trap_effect(mob/living/victim)
	to_chat(victim, span_danger("<B>A whirling blade erupts from beneath your feet!</B>"))
	var/zone = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	victim.apply_damage(ROCKHILL_TRAP_DAMAGE, BRUTE, zone, victim.run_armor_check(zone, MELEE))
	playsound(src, 'sound/items/weapons/bladeslice.ogg', 70, TRUE)
	var/obj/structure/sawblade_trap/saw = new(get_turf(src))
	last_trigger = 0
	QDEL_IN(saw, 10 SECONDS)

/obj/structure/trap/water/trap_effect(mob/living/victim)
	to_chat(victim, span_danger("<B>You are doused and knocked off your feet by a torrent of water!</B>"))
	victim.extinguish_mob()
	for(var/obj/item/carried in victim.get_all_contents())
		carried.extinguish()
	playsound(src, 'modular_redtard/rockhill/sound/foley/water_land2.ogg', 70, TRUE)
	victim.Paralyze(1 SECONDS)

/obj/structure/trap/wall_projectile
	var/turf/closed/home_wall
	var/fired = /obj/projectile/bullet/arrow

/obj/structure/trap/wall_projectile/frostbolt
	fired = /obj/projectile/temp/cryo

/obj/structure/trap/wall_projectile/acidsplash
	fired = /obj/projectile/neurotoxin

/obj/structure/trap/wall_projectile/Initialize(mapload)
	. = ..()
	for(var/distance in 1 to ROCKHILL_TRAP_WALL_RANGE)
		var/turf/location = get_ranged_target_turf(src, dir, distance)
		if(isclosedturf(location))
			home_wall = location
			break
	if(!home_wall)
		return INITIALIZE_HINT_QDEL

/obj/structure/trap/wall_projectile/Destroy()
	home_wall = null
	return ..()

/obj/structure/trap/wall_projectile/trap_effect(mob/living/victim)
	if(!home_wall)
		return
	var/obj/projectile/surprise = new fired(get_step_towards(home_wall, src))
	surprise.aim_projectile(victim, home_wall)
	INVOKE_ASYNC(surprise, TYPE_PROC_REF(/obj/projectile, fire))
	to_chat(victim, span_danger("\The [surprise] erupts from a hidden slit in \the [home_wall]!"))

/obj/structure/trap
	var/rockhill_armed = TRUE

/obj/structure/trap/on_entered(datum/source, atom/movable/victim)
	SIGNAL_HANDLER
	if(!rockhill_armed || HAS_TRAIT(victim, TRAIT_LIGHT_STEP))
		return
	return ..()

/obj/structure/trap/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(. || !rogue_combat_enabled() || !iscarbon(user) || !isturf(loc))
		return
	var/action = rockhill_armed ? "disarm" : "arm"
	var/crafting = user.rogue_skill_rank(/datum/attribute/skill/craft/crafting)
	if(crafting < ROCKHILL_TRAP_MIN_CRAFTING)
		to_chat(user, span_notice("I don't know how to [action] [src]."))
		return TRUE
	var/work_time = rogue_formula_value(rockhill_armed ? ROGUE_FORMULA_TRAP_DISARM_TIME : ROGUE_FORMULA_TRAP_SET_TIME, list("crafting" = crafting))
	user.visible_message(span_notice("[user] begins to [action] [src]."), span_notice("I start to [action] [src]."))
	if(!do_after(user, work_time, target = src))
		return TRUE
	rockhill_armed = !rockhill_armed
	animate(src, alpha = rockhill_armed ? initial(alpha) : ROCKHILL_TRAP_DISARMED_ALPHA, time = ROCKHILL_TRAP_FADE)
	user.visible_message(span_notice("[user] [action]s [src]."), span_notice("I [action] [src]."))
	user.log_message("[action]ed [src] at [AREACOORD(src)]", LOG_GAME)
	return TRUE

/obj/item/restraints/legcuffs/beartrap/armed/attack_self(mob/living/user)
	if(!ishuman(user) || IS_UNCONSCIOUS_OR_CRIT(user) || HAS_TRAIT(user, TRAIT_HANDS_BLOCKED) || DOING_INTERACTION(user, src))
		return
	var/list/inputs = list("strength" = user.rogue_stat(ROGUE_STAT_STRENGTH), "crafting" = user.rogue_skill_rank(/datum/attribute/skill/craft/crafting))
	if(!do_after(user, rogue_formula_value(ROGUE_FORMULA_MANTRAP_SET_TIME, inputs), target = user))
		return
	if(!prob(rogue_formula_value(ROGUE_FORMULA_MANTRAP_SET_CHANCE, inputs)))
		user.visible_message(span_warning("[user] couldn't get the shoddy [name] [armed ? "shut close" : "to open up"]!"))
		return
	armed = !armed
	playsound(src, 'sound/items/weapons/handcuffs.ogg', 30, TRUE, -3)
	update_appearance()
	to_chat(user, span_notice("[src] is now [armed ? "armed" : "disarmed"]."))

/obj/item/restraints/legcuffs/beartrap/armed/attempt_pickup(mob/living/user, skip_grav = FALSE)
	if(!armed || !isturf(loc) || !iscarbon(user))
		return ..()
	var/hand_zone = user.held_index_to_dir(user.active_hand_index) == "r" ? BODY_ZONE_PRECISE_R_HAND : BODY_ZONE_PRECISE_L_HAND
	if(user.rogue_badluck(ROCKHILL_MANTRAP_BADLUCK))
		spring_trap(user, ignore_movetypes = TRUE, def_zone = hand_zone)
		return TRUE
	user.visible_message(span_notice("[user] starts to disarm [src]."), span_notice("I start to disarm [src]."))
	var/work_time = rogue_formula_value(ROGUE_FORMULA_MANTRAP_DISARM_TIME, list("crafting" = user.rogue_skill_rank(/datum/attribute/skill/craft/crafting)))
	if(!do_after(user, work_time, target = src))
		if(armed)
			spring_trap(user, ignore_movetypes = TRUE, def_zone = hand_zone)
		return TRUE
	if(!armed)
		return TRUE
	armed = FALSE
	anchored = FALSE
	animate(src, alpha = 255, time = ROCKHILL_TRAP_FADE)
	update_appearance()
	user.visible_message(span_notice("[user] disarms [src]."), span_notice("I disarm [src]."))
	return TRUE

/obj/item/restraints/legcuffs/beartrap/armed/close_trap()
	. = ..()
	anchored = FALSE
	alpha = 255

/obj/item/restraints/legcuffs/beartrap/armed/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!armed || !isturf(loc))
		return ..()
	if(istype(tool, /obj/item/natural/dirtclod))
		if(!user.temporarilyRemoveItemFromInventory(tool))
			return ITEM_INTERACT_BLOCKING
		qdel(tool)
		alpha = max(ROCKHILL_MANTRAP_HIDDEN_ALPHA - user.rogue_skill_rank(/datum/attribute/skill/craft/crafting) * ROCKHILL_MANTRAP_HIDDEN_PER_CRAFTING, 0)
		to_chat(user, span_notice("I hide [src] under the dirt."))
		return ITEM_INTERACT_SUCCESS
	if(tool.force)
		user.visible_message(span_warning("[user] triggers [src] with [tool]."), span_danger("I trigger [src] with [tool]!"))
		tool.take_damage(ROCKHILL_MANTRAP_TOOL_DAMAGE, BRUTE, MELEE)
		close_trap()
		return ITEM_INTERACT_SUCCESS
	return ..()
