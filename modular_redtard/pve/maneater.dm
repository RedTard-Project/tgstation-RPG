/// B12b: Ratwood's maneater (game/objects/structures/maneater.dm). The tall grass hides a mouth: whoever walks into it unawares
/// (not sneaking, not a native of the vale walking - a running native is caught too) is seized and held, and chewed every
/// few seconds, harder each time; a chewed limb may come off and be eaten. The fallen are spat out - a body without a mind
/// is swallowed whole. Limbs, organs and meat dropped into it are eaten too. A fed maneater spits out a seed now and then;
/// planted in grass or dirt, away from other maneaters, it grows into a juvenile that eats only what is dropped into it and,
/// after three growths, becomes a maneater that spares its planter. Beaten down far enough, it dies and spits out what it ate.
/// One held breaks free by struggling, better the stronger they are and the longer they try; others can pull them free.

/obj/structure/flora/roguegrass/maneater/real
	can_buckle = TRUE
	max_buckled_mobs = 1
	buckle_lying = 0
	buckle_prevents_pull = TRUE
	/// When it last woke (0: it lies hidden).
	var/rogue_aggroed = 0
	/// When it last ate, or seized someone.
	var/rogue_last_eat = 0
	/// What it has eaten towards its next seed.
	var/rogue_nutrition = 0
	/// Name of the value of pve.txt: the nutrition a seed takes.
	var/rogue_seed_value = "pve_maneater_seed_nutrition"
	/// It was beaten down and is dead.
	var/rogue_dead = FALSE
	/// Who planted it: it spares them.
	var/datum/weakref/rogue_planter

/obj/structure/flora/roguegrass/maneater/real/Initialize(mapload)
	. = ..()
	if(!rogue_combat_enabled())
		return
	integrity_failure = rogue_value("pve_maneater_break_fraction")
	var/static/list/loc_connections = list(COMSIG_ATOM_ENTERED = PROC_REF(rogue_on_entered))
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/flora/roguegrass/maneater/real/Destroy()
	STOP_PROCESSING(SSobj, src)
	rogue_spit_all()
	return ..()

/obj/structure/flora/roguegrass/maneater/real/proc/rogue_on_entered(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER
	if(arrived != src)
		INVOKE_ASYNC(src, PROC_REF(rogue_crossed), arrived)

/// Ratwood Crossed(): it wakes, eats what it can eat and seizes whoever it can seize.
/obj/structure/flora/roguegrass/maneater/real/proc/rogue_crossed(atom/movable/arrived)
	if(rogue_dead || QDELETED(arrived) || arrived.loc != loc)
		return
	var/mob/living/walker = arrived
	if(istype(walker) && HAS_TRAIT(walker, TRAIT_LOCAL_KNOWLEDGE) && walker.move_intent != MOVE_INTENT_RUN)
		return
	if(world.time <= rogue_last_eat + rogue_value("pve_maneater_eat_cooldown") || has_buckled_mobs())
		return
	rogue_wake()
	if(!istype(walker))
		rogue_try_eat(arrived)
		return
	if(walker == rogue_planter?.resolve() || !rogue_seizes(walker))
		return
	if(!buckle_mob(walker, TRUE, FALSE))
		return
	rogue_last_eat = world.time
	visible_message(span_userdanger("[src] begins to gnaw on [walker]!"))
	addtimer(CALLBACK(src, PROC_REF(rogue_chew), WEAKREF(walker), 1), rogue_value("pve_maneater_chew_time"), TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_DELETE_ME)

/// Ratwood ambushable(): an awake person, not sneaking; the vale's own monsters walk past.
/obj/structure/flora/roguegrass/maneater/real/proc/rogue_seizes(mob/living/walker)
	var/mob/living/carbon/human/person = walker
	if(!istype(person) || !person.mind || person.stat != STABLE)
		return FALSE
	return !person.rogue_sneaking

/// Ratwood eatablez: limbs, organs and meat.
/obj/structure/flora/roguegrass/maneater/real/proc/rogue_try_eat(atom/movable/morsel)
	if(!isitem(morsel) || !is_type_in_list(morsel, list(/obj/item/bodypart, /obj/item/organ, /obj/item/reagent_containers/food/snacks/rogue/meat)))
		return FALSE
	rogue_last_eat = world.time
	playsound(src, 'modular_redtard/survival/sound/eat.ogg', rand(30, 60), TRUE)
	morsel.forceMove(src)
	rogue_feed(rogue_value("pve_maneater_food_item"))
	return TRUE

/obj/structure/flora/roguegrass/maneater/real/proc/rogue_feed(amount)
	rogue_nutrition += amount
	if(rogue_nutrition < rogue_value(rogue_seed_value))
		return
	rogue_nutrition = 0
	rogue_spit_seed()

/// Ratwood begin_eat(): a chew every few seconds, each one more likely than the last to take off the limb it bites.
/obj/structure/flora/roguegrass/maneater/real/proc/rogue_chew(datum/weakref/victim_ref, chew_factor)
	var/mob/living/victim = victim_ref?.resolve()
	if(!victim || rogue_dead || victim.loc != loc || victim.buckled != src)
		return
	visible_message(span_warning("[src] chews on [victim]!"))
	playsound(src, 'modular_redtard/survival/sound/eat.ogg', rand(30, 60), TRUE)
	var/mob/living/carbon/body = victim
	if(!istype(body))
		victim.adjust_brute_loss(rogue_value("pve_maneater_chew_damage"))
	else
		var/obj/item/bodypart/limb = body.get_bodypart(pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
		playsound(src, pick('modular_redtard/pve/sound/plant_attack1.ogg', 'modular_redtard/pve/sound/plant_attack2.ogg', 'modular_redtard/pve/sound/plant_attack3.ogg', 'modular_redtard/pve/sound/plant_attack4.ogg'), 100, FALSE, -1)
		if(limb && prob(chew_factor * rogue_value("pve_maneater_limb_chance")) && limb.dismember())
			limb.forceMove(src)
			rogue_feed(rogue_value("pve_maneater_food_limb"))
			if(!body.mind)
				rogue_swallow(body)
				return
			rogue_spit_out(body)
		else
			rogue_pve_strike(null, body, rogue_value("pve_maneater_chew_damage"), limb?.body_zone, SHARP_EDGED)
	if(QDELETED(victim) || victim.buckled != src)
		return
	if(victim.stat >= HARD_CRIT || HAS_TRAIT(victim, TRAIT_KNOCKEDOUT))
		if(!victim.mind)
			rogue_swallow(victim)
			return
		rogue_spit_out(victim)
		return
	rogue_last_eat = world.time
	addtimer(CALLBACK(src, PROC_REF(rogue_chew), victim_ref, chew_factor * 2), rogue_value("pve_maneater_chew_time"), TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_DELETE_ME)

/// A body without a mind is eaten whole.
/obj/structure/flora/roguegrass/maneater/real/proc/rogue_swallow(mob/living/victim)
	unbuckle_mob(victim, force = TRUE)
	rogue_feed(rogue_value("pve_maneater_food_body"))
	victim.gib(DROP_ALL_REMAINS)

/obj/structure/flora/roguegrass/maneater/real/proc/rogue_spit_out(mob/living/victim)
	visible_message(span_danger("[src] spits out [victim]!"))
	unbuckle_mob(victim, force = TRUE)
	playsound(src, 'modular_redtard/pve/sound/maneaterspit.ogg', 100)

/// Ratwood obj_break() and Destroy(): what it ate flies out around it.
/obj/structure/flora/roguegrass/maneater/real/proc/rogue_spit_all()
	if(has_buckled_mobs())
		unbuckle_all_mobs(force = TRUE)
	for(var/obj/item/eaten in src)
		eaten.forceMove(get_ranged_target_turf(src, pick(GLOB.alldirs), 1))
		playsound(src, 'modular_redtard/pve/sound/maneaterspit.ogg', 100)

/obj/structure/flora/roguegrass/maneater/real/proc/rogue_spit_seed()
	visible_message(span_warning("[src] spits out a seed!"))
	var/obj/item/maneaterseed/seed = new(get_turf(src))
	seed.throw_at(get_ranged_target_turf(src, pick(GLOB.alldirs), rand(1, 3)), 3, 2)
	playsound(src, 'modular_redtard/pve/sound/maneaterspit.ogg', 100)

/obj/structure/flora/roguegrass/maneater/real/proc/rogue_wake()
	if(!rogue_aggroed)
		START_PROCESSING(SSobj, src)
	rogue_aggroed = world.time
	rogue_update_look()

/// Ratwood update_icon(): grass while it hides, the maneater awake, its remains once dead.
/obj/structure/flora/roguegrass/maneater/real/proc/rogue_update_look()
	if(rogue_dead)
		name = "MANEATER"
		desc = "This cunning creature is thankfully defeated."
		icon_state = "maneater-dead"
	else if(rogue_aggroed)
		name = "MANEATER"
		icon_state = "maneater"
	else
		name = initial(name)
		icon_state = "maneater-hidden"

/// Ratwood process(): back into hiding half a minute after it last woke, with no one in its jaws.
/obj/structure/flora/roguegrass/maneater/real/process(seconds_per_tick)
	if(rogue_dead)
		return PROCESS_KILL
	if(world.time > rogue_aggroed + rogue_value("pve_maneater_hide_time") && !has_buckled_mobs())
		rogue_aggroed = 0
		rogue_update_look()
		return PROCESS_KILL

/obj/structure/flora/roguegrass/maneater/real/atom_break(damage_flag)
	. = ..()
	if(rogue_dead || !rogue_combat_enabled())
		return
	rogue_dead = TRUE
	STOP_PROCESSING(SSobj, src)
	rogue_spit_all()
	rogue_update_look()

/obj/structure/flora/roguegrass/maneater/real/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(!rogue_dead && rogue_combat_enabled())
		rogue_wake()

/obj/structure/flora/roguegrass/maneater/real/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	return FALSE

/// Ratwood user_unbuckle_mob(): each try takes a moment and frees with a chance of twice the strength (a juvenile's grip is
/// weaker: twice that again); every failed try makes the next better.
/obj/structure/flora/roguegrass/maneater/real/user_unbuckle_mob(mob/living/buckled_mob, mob/living/user)
	if(!isliving(user))
		return null
	if(rogue_dead)
		return ..()
	if(user == buckled_mob)
		user.visible_message(span_warning("[user] tries to break free of [src]!"))
	else
		user.visible_message(span_warning("[user] tries to pull [buckled_mob] free of [src]!"))
	var/break_factor = 1
	while(buckled_mob.buckled == src)
		if(!do_after(user, rogue_value("pve_maneater_struggle_time"), src))
			user.visible_message(span_warning("[buckled_mob] stops struggling!"))
			return null
		var/chance = clamp(user.rogue_stat(ROGUE_STAT_STRENGTH) * rogue_value("pve_maneater_free_per_strength") * break_factor * rogue_grip_factor(), 1, 99)
		if(prob(chance))
			return ..()
		break_factor *= rogue_value("pve_maneater_free_growth")
	return null

/// How much easier it is to break its grip than an adult's.
/obj/structure/flora/roguegrass/maneater/real/proc/rogue_grip_factor()
	return 1

// --- The juvenile ---

/obj/structure/flora/roguegrass/maneater/real/juvenile
	rogue_seed_value = "pve_maneater_juvenile_seed_nutrition"
	var/rogue_growth_stage = 1

/obj/structure/flora/roguegrass/maneater/real/juvenile/Initialize(mapload)
	. = ..()
	if(!rogue_combat_enabled())
		return
	transform = transform.Scale(0.75, 0.75)
	addtimer(CALLBACK(src, PROC_REF(rogue_grow)), rogue_value("pve_maneater_growth_time"), TIMER_DELETE_ME)

/// Ratwood juvenile Crossed(): it only eats what is dropped into it.
/obj/structure/flora/roguegrass/maneater/real/juvenile/rogue_crossed(atom/movable/arrived)
	if(rogue_dead || QDELETED(arrived) || arrived.loc != loc || isliving(arrived))
		return
	if(world.time <= rogue_last_eat + rogue_value("pve_maneater_juvenile_eat_cooldown"))
		return
	rogue_try_eat(arrived)

/obj/structure/flora/roguegrass/maneater/real/juvenile/rogue_grip_factor()
	return 2

/obj/structure/flora/roguegrass/maneater/real/juvenile/rogue_update_look()
	. = ..()
	name = "juvenile [name]"

/// Ratwood try_grow(): three growths, then the grown maneater takes its place.
/obj/structure/flora/roguegrass/maneater/real/juvenile/proc/rogue_grow()
	if(rogue_dead || QDELETED(src))
		return
	if(rogue_growth_stage < 3)
		rogue_growth_stage++
		transform = transform.Scale(1.1, 1.1)
		visible_message(span_warning("[src] grows bigger!"))
		playsound(src, pick('modular_redtard/pve/sound/plant_attack1.ogg', 'modular_redtard/pve/sound/plant_attack2.ogg', 'modular_redtard/pve/sound/plant_attack3.ogg', 'modular_redtard/pve/sound/plant_attack4.ogg'), 100, FALSE, -1)
		addtimer(CALLBACK(src, PROC_REF(rogue_grow)), rogue_value("pve_maneater_growth_time"), TIMER_DELETE_ME)
		return
	visible_message(span_danger("[src] reaches full maturity!"))
	var/obj/structure/flora/roguegrass/maneater/real/grown = new(get_turf(src))
	grown.rogue_planter = rogue_planter
	qdel(src)

// --- The seed ---

/// Ratwood maneaterseed afterattack(): planted in grass or dirt, with no other maneater within two steps and no paving on the
/// spot, it grows into a juvenile that spares its planter.
/obj/item/maneaterseed/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/turf/spot = get_turf(interacting_with)
	if(!rogue_combat_enabled() || !(istype(spot, /turf/open/floor/rogue/dirt) || istype(spot, /turf/open/floor/rogue/grass)))
		return ..()
	for(var/turf/near in range(2, spot))
		if(locate(/obj/structure/flora/roguegrass/maneater) in near)
			to_chat(user, span_warning("The maneater plants need more space between them to grow."))
			return ITEM_INTERACT_BLOCKING
	if(locate(/obj/effect/decal) in spot)
		to_chat(user, span_warning("The ground is too uneven to plant a maneater seed here."))
		return ITEM_INTERACT_BLOCKING
	INVOKE_ASYNC(src, PROC_REF(rogue_plant), spot, user)
	return ITEM_INTERACT_SUCCESS

/obj/item/maneaterseed/proc/rogue_plant(turf/spot, mob/living/user)
	user.visible_message(span_notice("[user] begins planting a maneater seed."), span_notice("I begin planting the maneater seed."))
	if(!do_after(user, rogue_value("pve_maneater_plant_time"), spot) || QDELETED(src))
		return
	if(locate(/obj/structure/flora/roguegrass/maneater) in range(2, spot))
		return
	var/obj/structure/flora/roguegrass/maneater/real/juvenile/sprout = new(spot)
	sprout.rogue_planter = WEAKREF(user)
	user.visible_message(span_notice("[user] plants a maneater seed."), span_notice("I plant the maneater seed."))
	message_admins("[ADMIN_LOOKUPFLW(user)] plants a maneater seed at [ADMIN_VERBOSEJMP(spot)]")
	qdel(src)
