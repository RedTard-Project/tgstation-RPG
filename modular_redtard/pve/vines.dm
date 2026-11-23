/// B12b: the dryad's vines (Ratwood summons/fae/dryad.dm, the weepvine of events/spacevine.dm) and the mire crawlers that follow a
/// mire lurker (Ratwood/Azure Peak creacher/mirespiders.dm, datums/ai/controllers/mirespider.dm).
///
/// Vines. On a medieval map a weepvine catches the feet of whoever walks into it for a moment, the shorter the stronger they are,
/// and now and then its thorns nick them - always when they run through it. Small critters slip past; the fae, Dendor's blessed
/// and bog walkers are not caught. Dendor's cursed are held twice as long and always cut. A dryad in a fight spreads vines
/// around itself every few seconds and moves fast through them; when it dies, the vines it can see wither.
///
/// Followers. A mire crawler near a mire lurker that has no prey keeps close to it; once there is prey, each hunts for itself.

/obj/structure/vine/Initialize(mapload)
	. = ..()
	if(!rogue_medieval_map())
		return
	var/static/list/loc_connections = list(COMSIG_ATOM_ENTERED = PROC_REF(rogue_pve_on_entered))
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/vine/proc/rogue_pve_on_entered(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER
	if(isliving(arrived))
		rogue_pve_snag(arrived)

/// Ratwood isvineimmune(): vine and plant kin, Dendor's blessed, bog walkers; and the fae, whose dryad grows them.
/proc/rogue_pve_vine_immune(mob/living/walker)
	if(("vines" in walker.faction) || ("plants" in walker.faction))
		return TRUE
	if(HAS_TRAIT(walker, TRAIT_KNEESTINGER_IMMUNITY) || HAS_TRAIT(walker, TRAIT_BOGWALKER))
		return TRUE
	return istype(walker, /mob/living/simple_animal/hostile/retaliate/rogue/fae)

/// Ratwood vine Crossed().
/obj/structure/vine/proc/rogue_pve_snag(mob/living/walker)
	if(walker.stat == DEAD || (walker.movement_type & MOVETYPES_NOT_TOUCHING_GROUND))
		return
	var/cursed = HAS_TRAIT(walker, TRAIT_CURSE_DENDOR)
	if(!cursed && (rogue_pve_vine_immune(walker) || walker.mob_size <= MOB_SIZE_SMALL))
		return
	var/hold = rogue_value(cursed ? "pve_vine_hold_cursed" : "pve_vine_hold") - walker.rogue_stat(ROGUE_STAT_STRENGTH)
	walker.Immobilize(max(1, hold))
	if(cursed || walker.buckled || walker.move_intent == MOVE_INTENT_RUN || prob(rogue_value("pve_vine_cut_chance")))
		walker.adjust_brute_loss(rogue_value("pve_vine_cut_damage"))
		to_chat(walker, span_warning("I nick myself on the thorny vines."))

// --- The dryad ---

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad
	rogue_pve_ability_types = list(/datum/action/cooldown/mob_cooldown/rogue_pve/dryad_vines)

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/Initialize(mapload)
	. = ..()
	if(rogue_medieval_map())
		RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(rogue_pve_on_moved))

/// Ratwood dryad Move(): on vines it moves fast, off them slowly.
/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/proc/rogue_pve_on_moved(datum/source, atom/old_loc, dir, forced, list/old_locs)
	SIGNAL_HANDLER
	if(locate(/obj/structure/vine) in loc)
		add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/rogue_pve_dryad_vines, multiplicative_slowdown = -rogue_value("pve_dryad_vine_haste"))
	else
		remove_movespeed_modifier(/datum/movespeed_modifier/rogue_pve_dryad_vines)

/// Ratwood dryad death(): the vines it can see wither.
/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/death(gibbed)
	. = ..()
	if(!rogue_medieval_map())
		return
	for(var/obj/structure/vine/withered in view(src))
		qdel(withered)
	visible_message(span_boldwarning("Vines near [src] wither as it returns to its plane!"))

/datum/movespeed_modifier/rogue_pve_dryad_vines
	variable = TRUE

/// Ratwood dryad vine() and create_vines: vines spread out around the dryad wherever there are none yet.
/datum/action/cooldown/mob_cooldown/rogue_pve/dryad_vines
	name = "Spawn Vines"
	desc = "Spread vines around yourself that catch whoever walks through them."
	cooldown_value = "pve_dryad_vines_cooldown"

/datum/action/cooldown/mob_cooldown/rogue_pve/dryad_vines/rogue_ai_wants(mob/living/basic/rockhill/beast, atom/target)
	return isliving(target) && get_dist(owner, target) <= rogue_value("pve_dryad_vines_reach")

/datum/action/cooldown/mob_cooldown/rogue_pve/dryad_vines/Activate(atom/target)
	var/turf/center = get_turf(owner)
	if(!center)
		return FALSE
	owner.visible_message(span_boldwarning("Vines spread out from [owner]!"))
	for(var/turf/open/spot in RANGE_TURFS(rogue_value("pve_dryad_vines_radius"), center))
		if(!(locate(/obj/structure/vine) in spot))
			new /obj/structure/vine(spot)
	StartCooldown()
	return TRUE

// --- Mire crawlers following a lurker ---

/// Ratwood find_lurker_to_follow() and being_a_minion/mirespider: with no prey of their own, crawlers keep close to a lurker
/// that has none either.
/mob/living/simple_animal/hostile/retaliate/rogue/mirespider/rogue_pve_idle_roots(hunts)
	. = ..()
	. += list(rogue_beast_pastime(list(
		BT_DESC_TYPE = /datum/bt_node/composite/sequence,
		BT_DESC_CHILDREN = list(
			list(BT_DESC_TYPE = /datum/bt_node/ai_behavior/rogue_pve_find_lurker, "target_key" = BB_ROGUE_PVE_LURKER),
			list(BT_DESC_TYPE = /datum/bt_node/ai_behavior/move_to_target, "target_key" = BB_ROGUE_PVE_LURKER, "required_dist" = 2),
			list(BT_DESC_TYPE = /datum/bt_node/ai_behavior/wait, "duration" = 2 SECONDS),
		),
	), rogue_pve_watcher(hunts)))

/// Looks for a lurker to follow: the one it follows while that still leads, else one within sight.
/datum/bt_node/ai_behavior/rogue_pve_find_lurker
	time_between_perform = 5 SECONDS
	var/target_key

/datum/bt_node/ai_behavior/rogue_pve_find_lurker/perform(seconds_per_tick, datum/ai_controller/controller)
	var/mob/living/crawler = controller.pawn
	if(!isturf(crawler.loc))
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED
	if(rogue_pve_leads(crawler, controller.blackboard[target_key]))
		return AI_BEHAVIOR_INSTANT | AI_BEHAVIOR_SUCCEEDED
	controller.clear_blackboard_key(target_key)
	for(var/mob/living/simple_animal/hostile/rogue/mirespider_lurker/lurker in oview(rogue_value("pve_lurker_follow_find_range"), crawler))
		if(rogue_pve_leads(crawler, lurker))
			controller.set_blackboard_key(target_key, lurker)
			return AI_BEHAVIOR_INSTANT | AI_BEHAVIOR_SUCCEEDED
	return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED

/// Ratwood: a lurker leads while it lives, is near enough and has no prey.
/proc/rogue_pve_leads(mob/living/crawler, mob/living/lurker)
	if(!istype(lurker, /mob/living/simple_animal/hostile/rogue/mirespider_lurker) || QDELETED(lurker) || lurker.stat == DEAD)
		return FALSE
	if(lurker.z != crawler.z || get_dist(crawler, lurker) > rogue_value("pve_lurker_follow_range"))
		return FALSE
	return !lurker.ai_controller?.blackboard[BB_CURRENT_TARGET]
