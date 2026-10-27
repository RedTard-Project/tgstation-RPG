/// The truffle pig (Ratwood modular/Creechers/code/trufflepig.dm). A dirt tile in the woods (/area/rogue/outdoors/woods) with no
/// structure on it hides truffles with a 4% chance. Patting the pig (an empty hand, out of combat) makes it snuffle about for two
/// seconds and then show every truffle spot within 5 tiles; every pat wears its patience, and after 10 it sulks until it gets
/// truffles (fed by hand or found on the ground; a potato takes 2 off). A shovel scooping such a tile digs the truffles up in 3
/// seconds. Ratwood rolls every dirt tile when the map loads; here a tile is rolled the first time a pig smells it or a shovel
/// tries it, with the same odds. Ratwood's toxic mushrooms under dirt never appear there (its roll sets them FALSE) and are not ported.

#define ROGUE_PIG_SOUNDS list('modular_redtard/husbandry/sound/pig1.ogg', 'modular_redtard/husbandry/sound/pig2.ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/trufflepig
	/// Ratwood hangry_meter: every pat makes it surlier; past ROGUE_PIG_HANGRY_MAX it sulks until it gets truffles.
	var/rogue_hangry = 0
	COOLDOWN_DECLARE(rogue_sniff_cooldown)

/mob/living/simple_animal/hostile/retaliate/rogue/trufflepig/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_MOB_ATE, PROC_REF(rogue_on_ate))

/// Truffles put it in a good mood again, from a hand or off the ground (Ratwood attackby(), Life()).
/mob/living/simple_animal/hostile/retaliate/rogue/trufflepig/proc/rogue_on_ate(datum/source, atom/eaten, mob/living/feeder)
	SIGNAL_HANDLER
	if(!istype(eaten, /obj/item/reagent_containers/food/snacks/rogue/truffles))
		return
	rogue_hangry = 0
	if(feeder)
		visible_message(span_notice("The pig munches the truffles, looking happy."))
	else
		visible_message(span_notice("The pig devours the vulnerable truffles!"))

/mob/living/simple_animal/hostile/retaliate/rogue/trufflepig/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(stat != STABLE || !istype(user))
		return
	rogue_hangry++
	if(rogue_hangry > ROGUE_PIG_HANGRY_MAX)
		to_chat(user, span_notice("The pig squeals in anger. Its sulking and refusing to work until it gets delicious truffles."))
		playsound(src, 'modular_redtard/husbandry/sound/pig2.ogg', 100, TRUE, -1)
		return
	if(!user.combat_mode)
		rogue_sniff()

/// A potato only takes the edge off its sulk (Ratwood attackby()).
/mob/living/simple_animal/hostile/retaliate/rogue/trufflepig/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/reagent_containers/food/snacks/grown/potato/rogue) || stat != STABLE || user.combat_mode)
		return ..()
	if(rogue_hangry > ROGUE_PIG_POTATO_RELIEF)
		rogue_hangry -= ROGUE_PIG_POTATO_RELIEF
		visible_message(span_notice("The pig munches the potato, looking partially satisfied."))
	else
		visible_message(span_notice("The pig munches the potato, completely indifferent."))
	playsound(src, 'modular_redtard/husbandry/sound/eat.ogg', rand(30, 60), TRUE)
	qdel(tool)
	return ITEM_INTERACT_SUCCESS

/// Two snuffling steps a second apart, then the find (Ratwood attack_hand() with its sleep(10)s on timers).
/mob/living/simple_animal/hostile/retaliate/rogue/trufflepig/proc/rogue_sniff()
	if(!COOLDOWN_FINISHED(src, rogue_sniff_cooldown))
		return
	COOLDOWN_START(src, rogue_sniff_cooldown, 2 SECONDS)
	playsound(src, pick(ROGUE_PIG_SOUNDS), 100, TRUE, -1)
	rogue_sniff_step()
	addtimer(CALLBACK(src, PROC_REF(rogue_sniff_step)), 1 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(rogue_sniff_out)), 2 SECONDS)

/mob/living/simple_animal/hostile/retaliate/rogue/trufflepig/proc/rogue_sniff_step()
	if(stat != STABLE)
		return
	step(src, pick(GLOB.cardinals))
	playsound(src, 'modular_redtard/husbandry/sound/sniff.ogg', 60, FALSE)

/mob/living/simple_animal/hostile/retaliate/rogue/trufflepig/proc/rogue_sniff_out()
	if(stat != STABLE)
		return
	setDir(pick(GLOB.cardinals))
	playsound(src, pick(ROGUE_PIG_SOUNDS), 100, TRUE, -1)
	rogue_truffle_search(get_turf(src), ROGUE_TRUFFLE_SNIFF_RANGE)

/// Dirt tiles already rolled for truffles: TRUE while they still hide some.
GLOBAL_LIST_EMPTY(rogue_truffle_spots)

/// Whether this dirt hides truffles; rolled the first time anyone asks (Ratwood dirt Initialize()).
/proc/rogue_has_truffles(turf/open/floor/rogue/dirt/spot)
	if(!istype(spot))
		return FALSE
	if(isnull(GLOB.rogue_truffle_spots[spot]))
		GLOB.rogue_truffle_spots[spot] = istype(spot.loc, /area/rogue/outdoors/woods) && !(locate(/obj/structure) in spot) && !(locate(/obj/machinery) in spot) && prob(ROGUE_TRUFFLE_CHANCE)
	return GLOB.rogue_truffle_spots[spot]

/// Marks every truffle spot around for a moment (Ratwood trufflesearch()).
/proc/rogue_truffle_search(turf/center, range)
	for(var/turf/open/floor/rogue/dirt/spot in range(range, center))
		if(!rogue_has_truffles(spot))
			continue
		var/obj/effect/temp_visual/rogue_truffle_scent/old = locate() in spot
		if(old)
			qdel(old)
		new /obj/effect/temp_visual/rogue_truffle_scent(spot)

/// Ratwood truffle_overlay: a wide glow over the spot, above the dark.
/obj/effect/temp_visual/rogue_truffle_scent
	icon = 'modular_redtard/husbandry/icons/trufflesniff.dmi'
	icon_state = "foundsome"
	plane = ABOVE_LIGHTING_PLANE
	appearance_flags = NONE
	duration = 3.5 SECONDS
	randomdir = FALSE
	pixel_x = -224
	pixel_y = -224

/// A shovel scooping dirt that hides truffles digs them up (Ratwood dirt attackby()).
/turf/open/floor/rogue/dirt/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/rogueweapon/shovel) || !rogue_has_truffles(src))
		return ..()
	playsound(src, 'modular_redtard/husbandry/sound/dig_shovel.ogg', 70, TRUE)
	if(!istype(user.rogue_active_intent(), /datum/intent/shovelscoop))
		return ..()
	if(!do_after(user, ROGUE_TRUFFLE_DIG_TIME, target = src) || !rogue_has_truffles(src))
		return ITEM_INTERACT_BLOCKING
	GLOB.rogue_truffle_spots[src] = FALSE
	new /obj/item/reagent_containers/food/snacks/rogue/truffles(src)
	return ITEM_INTERACT_SUCCESS

#undef ROGUE_PIG_SOUNDS
