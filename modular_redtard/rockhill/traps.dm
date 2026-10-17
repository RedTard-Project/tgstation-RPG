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
