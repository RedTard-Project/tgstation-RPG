/// Spiders: Ratwood's webs (modular/Mapping/icons/Mapping_aides.dm) and the mire spiders' cocoons (datums/ai/controllers/
/// mirespider.dm, Azure's spider_cocoon.dm), Vibelin's spider nests (honeyspider.dm, enter_exit_home) and webs left behind.
///
/// Webs. On a medieval map TG's sticky web (603 of them on the Rockhill maps, where Ratwood had its own) looks and holds like
/// Ratwood's: its sprite, it blocks sight, half the time it holds whoever walks into it for a moment (not those who walk webs:
/// spiders, dark elves), 30% of shots pass through it. Scissors on the snip intent cut a web into silk, faster for a better
/// sewer; a torn web may leave silk. The ported decorative web of Ratwood (stickyweb/solo) holds the same way. The mire lurker's
/// web globs leave thin mire webs that hold a quarter of the time and let most shots through. Beespiders spin webs around
/// themselves now and then (Vibelin's spiders leave webs behind), but no more than a few in a spot.
///
/// Cocoons. The mire lurker and the aragn wrap whoever falls near them (down, not dead) into a cocoon; inside it the wounds
/// slowly close and blood comes back, as Ratwood's cocoon keeps a captive alive. A minute of struggling breaks it, as does
/// tearing or burning it from outside.
///
/// Nests. Beespiders live in nests: at round start a colony on the map weaves one where there is none near; a spider idle
/// near its nest goes in now and then and comes out again. Whoever comes close or strikes the nest sends the spiders inside
/// swarming out at them. Spiders inside slowly fill the nest with honey (Ratwood's spiders make honey when idle), which can be
/// taken out by hand, with the same risk.

/mob/living/basic/rockhill
	/// Ratwood mire spiders: wraps the fallen into cocoons.
	var/rogue_pve_cocoons = FALSE
	/// Vibelin beespiders: spins webs around itself.
	var/rogue_pve_spins_webs = FALSE
	/// Vibelin beespiders: lives in a spider nest.
	var/rogue_pve_nests = FALSE

/mob/living/basic/rockhill/Initialize(mapload)
	. = ..()
	if(rogue_pve_nests && ai_controller)
		addtimer(CALLBACK(src, PROC_REF(rogue_pve_settle), mapload), 1 SECONDS)

/mob/living/basic/rockhill/rogue_pve_has_chores()
	return ..() || rogue_pve_cocoons || rogue_pve_spins_webs || rogue_pve_nests

/mob/living/basic/rockhill/rogue_pve_urgent_roots(hunts)
	. = ..()
	if(rogue_pve_cocoons)
		. += list(rogue_beast_pastime(list(
			BT_DESC_TYPE = /datum/bt_node/decorator/cooldown,
			"cooldown_key" = BB_ROGUE_PVE_NEXT_COCOON,
			"cooldown_duration" = 5 SECONDS,
			"lock_on_succeed" = FALSE,
			BT_DESC_CHILDREN = list(list(
				BT_DESC_TYPE = /datum/bt_node/composite/sequence,
				BT_DESC_CHILDREN = list(
					list(BT_DESC_TYPE = /datum/bt_node/ai_behavior/rogue_pve_find_cocoon, "target_key" = BB_ROGUE_PVE_COCOON),
					list(BT_DESC_TYPE = /datum/bt_node/ai_behavior/move_to_target, "target_key" = BB_ROGUE_PVE_COCOON, "required_dist" = 1),
					list(BT_DESC_TYPE = /datum/bt_node/ai_behavior/rogue_pve_wrap, "target_key" = BB_ROGUE_PVE_COCOON),
				),
			)),
		), rogue_pve_watcher(hunts)))

/mob/living/basic/rockhill/rogue_pve_idle_roots(hunts)
	. = ..()
	if(rogue_pve_nests)
		. += list(rogue_beast_pastime(list(
			BT_DESC_TYPE = /datum/bt_node/ai_behavior/rogue_pve_keep_home,
			"home_key" = BB_ROGUE_PVE_HOME,
		), rogue_pve_watcher(hunts)))
	if(rogue_pve_spins_webs)
		. += list(rogue_beast_pastime(list(
			BT_DESC_TYPE = /datum/bt_node/decorator/cooldown,
			"cooldown_key" = BB_ROGUE_PVE_NEXT_WEB,
			"cooldown_duration" = ROGUE_PVE_WEB_INTERVAL,
			"lock_on_succeed" = FALSE,
			BT_DESC_CHILDREN = list(list(
				BT_DESC_TYPE = /datum/bt_node/composite/sequence,
				BT_DESC_CHILDREN = list(
					list(BT_DESC_TYPE = /datum/bt_node/ai_behavior/rogue_pve_find_web_spot, "target_key" = BB_ROGUE_PVE_WEB_SPOT),
					list(BT_DESC_TYPE = /datum/bt_node/ai_behavior/move_to_target, "target_key" = BB_ROGUE_PVE_WEB_SPOT, "required_dist" = 0),
					list(BT_DESC_TYPE = /datum/bt_node/ai_behavior/rogue_pve_spin_web, "target_key" = BB_ROGUE_PVE_WEB_SPOT),
				),
			)),
		), rogue_pve_watcher(hunts)))

// --- Webs ---

/obj/structure/spider/stickyweb
	/// Looks and holds like Ratwood's web (a medieval map).
	var/rogue_pve_ratwood = FALSE
	/// Name of the value of config/redtard/mechanics/values.txt: percent chance it holds whoever walks in.
	var/rogue_pve_stuck_value = "pve_web_stuck_chance"
	/// Name of the value of config/redtard/mechanics/values.txt: percent chance a shot passes through it.
	var/rogue_pve_pass_value = "pve_web_projectile_pass"
	/// A torn web may leave silk (Ratwood static_debris).
	var/rogue_pve_silk = TRUE

/obj/structure/spider/stickyweb/Initialize(mapload)
	if(rogue_pve_wants_ratwood())
		rogue_pve_ratwood = TRUE
		rogue_pve_reskin()
	. = ..()
	if(rogue_pve_ratwood)
		RegisterSignal(src, COMSIG_MOVABLE_CROSS, PROC_REF(rogue_pve_on_cross))

/// TG's own web elsewhere and its other kinds (sealed, genetic...) stay as they are.
/obj/structure/spider/stickyweb/proc/rogue_pve_wants_ratwood()
	return type == /obj/structure/spider/stickyweb && rogue_combat_enabled()

/// Ratwood's web: its sprite in a random look and turn, no smoothing, a see-through tint that still blocks sight; TG's
/// stamina drain gives way to Ratwood's hold.
/obj/structure/spider/stickyweb/proc/rogue_pve_reskin()
	icon = ROGUE_PVE_WEB_ICON
	icon_state = pick("stickyweb1", "stickyweb2")
	smoothing_flags = NONE
	has_frill = FALSE
	layer = OBJ_LAYER
	plane = GAME_PLANE
	alpha = rand(80, 109)
	opacity = TRUE
	max_integrity = 30
	resistance_flags |= FLAMMABLE
	dir = pick(GLOB.cardinals)
	stuck_chance = 0
	projectile_stuck_chance = rogue_value(rogue_pve_pass_value)

/obj/structure/spider/stickyweb/proc/rogue_pve_on_cross(datum/source, atom/movable/mover)
	SIGNAL_HANDLER
	return rogue_pve_web_holds(src, mover, rogue_value(rogue_pve_stuck_value))

/obj/structure/spider/stickyweb/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(rogue_pve_ratwood && rogue_pve_try_snip(src, user, tool))
		return ITEM_INTERACT_SUCCESS
	return ..()

/obj/structure/spider/stickyweb/atom_deconstruct(disassembled = TRUE)
	. = ..()
	if(rogue_pve_ratwood && rogue_pve_silk && prob(50))
		new /obj/item/natural/silk(get_turf(src))

/// Ratwood stickyweb/mirespider: the thin web the mire lurker's globs leave.
/obj/structure/spider/stickyweb/rogue_pve_mire
	rogue_pve_stuck_value = "pve_mire_web_stuck_chance"
	rogue_pve_pass_value = "pve_mire_web_projectile_pass"
	rogue_pve_silk = FALSE

/obj/structure/spider/stickyweb/rogue_pve_mire/rogue_pve_wants_ratwood()
	return TRUE

/obj/structure/spider/stickyweb/rogue_pve_mire/rogue_pve_reskin()
	. = ..()
	opacity = FALSE
	alpha = 100
	pass_flags_self |= LETPASSTHROW

/// Ratwood's decorative web of the port holds as Ratwood's does.
/obj/structure/spider/stickyweb/solo/Initialize(mapload)
	. = ..()
	if(rogue_combat_enabled())
		RegisterSignal(src, COMSIG_MOVABLE_CROSS, PROC_REF(rogue_pve_on_cross))

/obj/structure/spider/stickyweb/solo/proc/rogue_pve_on_cross(datum/source, atom/movable/mover)
	SIGNAL_HANDLER
	return rogue_pve_web_holds(src, mover, ROGUE_PVE_WEB_STUCK_CHANCE)

/// The port makes it a Rockhill structure, not a TG web, so it lets shots through as Ratwood's web does by itself.
/obj/structure/spider/stickyweb/solo/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(. && isprojectile(mover) && rogue_combat_enabled())
		return prob(ROGUE_PVE_WEB_PROJECTILE_PASS)

/obj/structure/spider/stickyweb/solo/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(rogue_combat_enabled() && rogue_pve_try_snip(src, user, tool))
		return ITEM_INTERACT_SUCCESS
	return ..()

/// Ratwood stickyweb CanPass(): a web holds whoever walks into it this often, unless they walk webs.
/proc/rogue_pve_web_holds(obj/web, atom/movable/mover, chance)
	if(!isliving(mover) || mover.throwing || HAS_TRAIT(mover, TRAIT_WEBWALK) || HAS_TRAIT(mover, TRAIT_WEB_SURFER))
		return NONE
	if(!prob(chance))
		return NONE
	to_chat(mover, span_danger("I get stuck in \the [web] for a moment."))
	return COMPONENT_BLOCK_CROSS

/// Ratwood stickyweb attacked_by(): scissors on the snip intent cut a web up into silk.
/proc/rogue_pve_try_snip(obj/web, mob/living/user, obj/item/tool)
	if(!ishuman(user) || !tool)
		return FALSE
	var/mob/living/carbon/human/snipper = user
	if(!istype(snipper.rogue_strike_intent(tool), /datum/intent/snip))
		return FALSE
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(rogue_pve_snip), web, snipper)
	return TRUE

/// Five seconds, a second less for every rank of sewing; one or two silk.
/proc/rogue_pve_snip(obj/web, mob/living/user)
	var/time = max(1 SECONDS, 5 SECONDS - user.rogue_skill_rank(/datum/attribute/skill/craft/sewing) * 1 SECONDS)
	if(!do_after(user, time, web) || QDELETED(web))
		return
	var/turf/spot = get_turf(web)
	for(var/i in 1 to rand(1, 2))
		new /obj/item/natural/silk(spot)
	user.visible_message(span_notice("[user] snips [web] up into silk."))
	playsound(spot, 'sound/items/tools/wirecutter_cut.ogg', 70, TRUE)
	qdel(web)

/// A spot near the spider to spin a web on: open ground without a web, while there are not too many webs around already.
/datum/bt_node/ai_behavior/rogue_pve_find_web_spot
	time_between_perform = 10 SECONDS
	var/target_key

/datum/bt_node/ai_behavior/rogue_pve_find_web_spot/perform(seconds_per_tick, datum/ai_controller/controller)
	var/mob/living/spider = controller.pawn
	var/turf/home = get_turf(spider)
	if(!isturf(spider.loc) || !home || !rogue_combat_enabled())
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED
	var/webs = 0
	for(var/obj/structure/spider/stickyweb/web in range(3, home))
		webs++
	if(webs >= ROGUE_PVE_WEB_CAP)
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED
	var/list/spots = list()
	for(var/turf/open/spot in range(2, home))
		if(istype(spot, /turf/open/water) || spot.is_blocked_turf(TRUE, source_atom = spider) || (locate(/obj/structure/spider/stickyweb) in spot))
			continue
		spots += spot
	if(!length(spots))
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED
	controller.set_blackboard_key(target_key, pick(spots))
	return AI_BEHAVIOR_INSTANT | AI_BEHAVIOR_SUCCEEDED

/// Spins a web where the spider stands: a moment of work, then the web.
/datum/bt_node/ai_behavior/rogue_pve_spin_web
	time_between_perform = 2 SECONDS
	var/target_key
	/// The first round only starts the work.
	var/started = FALSE

/datum/bt_node/ai_behavior/rogue_pve_spin_web/setup(datum/ai_controller/controller)
	started = FALSE
	return TRUE

/datum/bt_node/ai_behavior/rogue_pve_spin_web/perform(seconds_per_tick, datum/ai_controller/controller)
	var/mob/living/spider = controller.pawn
	var/turf/spot = controller.blackboard[target_key]
	if(!isturf(spot) || get_turf(spider) != spot || (locate(/obj/structure/spider/stickyweb) in spot))
		return AI_BEHAVIOR_INSTANT | AI_BEHAVIOR_FAILED
	if(!started)
		started = TRUE
		spider.visible_message(span_notice("[spider] begins to spin a web."))
		return AI_BEHAVIOR_DELAY
	new /obj/structure/spider/stickyweb(spot)
	return AI_BEHAVIOR_INSTANT | AI_BEHAVIOR_SUCCEEDED

/datum/bt_node/ai_behavior/rogue_pve_spin_web/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	controller.clear_blackboard_key(target_key)

// --- Cocoons ---

/// Ratwood /obj/structure/spider/cocoon: a captive wrapped in silk.
/obj/structure/rogue_pve_cocoon
	name = "cocoon"
	desc = "Something is wrapped tight in sticky silk."
	icon = ROGUE_PVE_WEB_ICON
	icon_state = "cocoon_person"
	anchored = TRUE
	density = FALSE
	max_integrity = 40
	resistance_flags = FLAMMABLE

/obj/structure/rogue_pve_cocoon/container_resist_act(mob/living/user)
	var/breakout_time = ROGUE_PVE_COCOON_BREAKOUT
	user.change_next_special_move(CLICK_CD_BREAKOUT)
	to_chat(user, span_notice("I struggle against the tight bonds... (This will take about [DisplayTimeText(breakout_time)].)"))
	visible_message(span_notice("Something struggles and writhes in \the [src]!"))
	if(!do_after(user, breakout_time, target = src))
		return
	if(QDELETED(src) || IS_UNCONSCIOUS_OR_CRIT(user) || user.loc != src)
		return
	qdel(src)

/obj/structure/rogue_pve_cocoon/atom_deconstruct(disassembled = TRUE)
	. = ..()
	new /obj/item/natural/silk(get_turf(src))

/obj/structure/rogue_pve_cocoon/Destroy()
	var/turf/spot = get_turf(src)
	if(length(contents))
		visible_message(span_warning("\The [src] splits open."))
	for(var/atom/movable/held as anything in contents)
		held.forceMove(spot)
	return ..()

/obj/structure/rogue_pve_cocoon/Exited(atom/movable/gone, direction)
	. = ..()
	if(isliving(gone))
		var/mob/living/freed = gone
		freed.remove_status_effect(/datum/status_effect/rogue_pve_cocoon)

/// Wraps the fallen one into a cocoon where it lies.
/proc/rogue_pve_cocoon(mob/living/fallen)
	var/turf/spot = get_turf(fallen)
	if(!spot)
		return
	var/obj/structure/rogue_pve_cocoon/cocoon = new(spot)
	fallen.forceMove(cocoon)
	fallen.apply_status_effect(/datum/status_effect/rogue_pve_cocoon)

/// Someone a spider would wrap: down but alive, lying in the open, not of its kind.
/proc/rogue_pve_wrappable(mob/living/spider, mob/living/fallen)
	if(!iscarbon(fallen) || !isturf(fallen.loc) || fallen.stat == DEAD || !IS_UNCONSCIOUS_OR_CRIT(fallen))
		return FALSE
	return !spider || !spider.faction_check_atom(fallen)

/// Azure's spider_cocoon: the silk slowly closes the captive's wounds and gives back blood, more for the hardy.
/datum/status_effect/rogue_pve_cocoon
	id = "rogue_pve_cocoon"
	alert_type = null
	duration = STATUS_EFFECT_PERMANENT
	tick_interval = 1 SECONDS
	/// Damage of each kind healed per tick.
	var/heal = 1
	/// Blood given back per tick.
	var/blood = 20

/datum/status_effect/rogue_pve_cocoon/on_apply()
	var/hardiness = 0
	hardiness += (owner.rogue_stat(ROGUE_STAT_CONSTITUTION) - ROGUE_ATTRIBUTE_MIDDLING) * 0.05
	hardiness += (owner.rogue_stat(ROGUE_STAT_STRENGTH) - ROGUE_ATTRIBUTE_MIDDLING) * 0.05
	hardiness += (owner.rogue_stat(ROGUE_STAT_WILLPOWER) - ROGUE_ATTRIBUTE_MIDDLING) * 0.05
	hardiness = max(hardiness, 0)
	heal = ROGUE_PVE_COCOON_HEAL + hardiness
	blood = ROGUE_PVE_COCOON_BLOOD + hardiness * 10
	return TRUE

/datum/status_effect/rogue_pve_cocoon/tick(seconds_between_ticks)
	if(!istype(owner.loc, /obj/structure/rogue_pve_cocoon))
		qdel(src)
		return
	if(owner.stat == DEAD)
		return
	owner.heal_overall_damage(heal, heal)
	owner.adjust_oxy_loss(-heal * 5)
	owner.adjust_tox_loss(-heal)
	if(owner.get_blood_volume() < BLOOD_VOLUME_NORMAL)
		owner.adjust_blood_volume(blood, maximum = BLOOD_VOLUME_NORMAL)

/// Ratwood find_cocoon_target: someone fallen in sight to wrap.
/datum/bt_node/ai_behavior/rogue_pve_find_cocoon
	time_between_perform = 5 SECONDS
	var/target_key

/datum/bt_node/ai_behavior/rogue_pve_find_cocoon/perform(seconds_per_tick, datum/ai_controller/controller)
	var/mob/living/spider = controller.pawn
	if(!isturf(spider.loc))
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED
	if(rogue_pve_wrappable(spider, controller.blackboard[target_key]))
		return AI_BEHAVIOR_INSTANT | AI_BEHAVIOR_SUCCEEDED
	controller.clear_blackboard_key(target_key)
	for(var/mob/living/carbon/fallen in oview(6, spider))
		if(rogue_pve_wrappable(spider, fallen))
			controller.set_blackboard_key(target_key, fallen)
			return AI_BEHAVIOR_INSTANT | AI_BEHAVIOR_SUCCEEDED
	return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED

/// Ratwood cocoon_target: five seconds of wrapping beside the fallen one.
/datum/bt_node/ai_behavior/rogue_pve_wrap
	var/target_key

/datum/bt_node/ai_behavior/rogue_pve_wrap/perform(seconds_per_tick, datum/ai_controller/controller)
	var/async_flags = handle_async()
	if(async_flags)
		return async_flags
	var/mob/living/spider = controller.pawn
	var/mob/living/fallen = controller.blackboard[target_key]
	if(!rogue_pve_wrappable(spider, fallen) || !spider.Adjacent(fallen))
		return AI_BEHAVIOR_INSTANT | AI_BEHAVIOR_FAILED
	spider.face_atom(fallen)
	spider.visible_message(span_danger("[spider] starts to wrap [fallen] in silk!"))
	return start_async()

/datum/bt_node/ai_behavior/rogue_pve_wrap/perform_async(datum/ai_controller/controller)
	var/mob/living/spider = controller.pawn
	var/mob/living/fallen = controller.blackboard[target_key]
	var/wrapped = do_after(spider, ROGUE_PVE_COCOON_TIME, fallen)
	if(!async_still_valid())
		return
	if(!wrapped || !rogue_pve_wrappable(spider, fallen))
		finish_async(AI_BEHAVIOR_FAILED)
		return
	rogue_pve_cocoon(fallen)
	finish_async(AI_BEHAVIOR_SUCCEEDED)

/datum/bt_node/ai_behavior/rogue_pve_wrap/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	controller.clear_blackboard_key(target_key)

// --- Nests ---

/// Vibelin /obj/structure/spider/nest: spiders live in it, fill it with honey and swarm out at whoever disturbs it.
/obj/structure/rogue_pve_spider_nest
	name = "spider nest"
	desc = "A woven nest for spiders to live in."
	icon = ROGUE_PVE_NEST_ICON
	icon_state = "nest"
	anchored = TRUE
	density = FALSE
	max_integrity = 80
	resistance_flags = FLAMMABLE
	/// Whoever comes this near disturbs it.
	var/datum/proximity_monitor/proximity_monitor
	/// Spider-deciseconds spent inside since the honey was last taken (ROGUE_PVE_NEST_HONEY_TIME of them make a honey).
	var/honey = 0
	/// When the honey was last reckoned.
	var/honey_at = 0
	/// The spiders inside won't come out again before this.
	var/calm_until = 0

/obj/structure/rogue_pve_spider_nest/Initialize(mapload)
	. = ..()
	honey_at = world.time
	proximity_monitor = new(src, ROGUE_PVE_NEST_DISTURB_RANGE)

/obj/structure/rogue_pve_spider_nest/Destroy()
	rogue_release()
	QDEL_NULL(proximity_monitor)
	return ..()

/obj/structure/rogue_pve_spider_nest/atom_deconstruct(disassembled = TRUE)
	. = ..()
	new /obj/item/natural/silk(get_turf(src))

/obj/structure/rogue_pve_spider_nest/examine(mob/user)
	. = ..()
	rogue_reckon_honey()
	var/static/list/fullness = list("slightly filled", "partially filled", "half filled", "almost full", "completely full")
	var/stored = rogue_honey_ready()
	. += span_notice("The nest looks [stored ? fullness[clamp(stored, 1, length(fullness))] : "empty"].")

/// A spider at home stays in: the escape from captivity at the head of its mind (TG escape_captivity) resists every moment it
/// is inside. It comes out when its mind says so (rogue_pve_keep_home); a spider in a player's hands crawls out at once.
/obj/structure/rogue_pve_spider_nest/container_resist_act(mob/living/user)
	if(!user.client && (user in rogue_dwellers()))
		return
	rogue_let_out(user)

/obj/structure/rogue_pve_spider_nest/HasProximity(atom/movable/proximity_check_mob)
	rogue_disturb(proximity_check_mob)

/obj/structure/rogue_pve_spider_nest/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	rogue_disturb(user)
	return ..()

/// Vibelin nest attack_hand(): the honey is taken out by hand, a while for each.
/obj/structure/rogue_pve_spider_nest/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	rogue_reckon_honey()
	var/stored = rogue_honey_ready()
	if(!stored)
		to_chat(user, span_warning("There is no honey in [src]."))
		return
	user.visible_message(span_warning("[user] starts to collect the honey from [src]!"), span_warning("I start to collect the honey from [src]!"))
	rogue_disturb(user)
	if(!do_after(user, ROGUE_PVE_NEST_HARVEST_TIME * stored, src))
		return
	rogue_reckon_honey()
	stored = min(stored, rogue_honey_ready())
	for(var/i in 1 to stored)
		new /obj/item/reagent_containers/food/snacks/rogue/honey/spider(get_turf(src))
	honey = max(0, honey - stored * ROGUE_PVE_NEST_HONEY_TIME)

/// The spiders inside.
/obj/structure/rogue_pve_spider_nest/proc/rogue_dwellers()
	. = list()
	for(var/mob/living/basic/rockhill/spider in contents)
		. += spider

/obj/structure/rogue_pve_spider_nest/proc/rogue_has_room()
	return length(rogue_dwellers()) < ROGUE_PVE_NEST_CAPACITY

/obj/structure/rogue_pve_spider_nest/proc/rogue_reckon_honey()
	var/elapsed = world.time - honey_at
	honey_at = world.time
	honey = min(honey + elapsed * length(rogue_dwellers()), ROGUE_PVE_NEST_HONEY_MAX * ROGUE_PVE_NEST_HONEY_TIME)

/obj/structure/rogue_pve_spider_nest/proc/rogue_honey_ready()
	return round(honey / ROGUE_PVE_NEST_HONEY_TIME)

/obj/structure/rogue_pve_spider_nest/proc/rogue_take_in(mob/living/basic/rockhill/spider)
	rogue_reckon_honey()
	spider.forceMove(src)

/obj/structure/rogue_pve_spider_nest/proc/rogue_let_out(mob/living/basic/rockhill/spider)
	rogue_reckon_honey()
	var/turf/home = get_turf(src)
	var/list/exits = list()
	for(var/turf/open/spot in range(1, home))
		if(!spot.is_blocked_turf(TRUE))
			exits += spot
	spider.forceMove(length(exits) ? pick(exits) : home)

/obj/structure/rogue_pve_spider_nest/proc/rogue_release()
	for(var/mob/living/basic/rockhill/spider as anything in rogue_dwellers())
		rogue_let_out(spider)

/// Vibelin nest disturb(): someone not of the spiders' kin came close or struck the nest; the spiders inside swarm out at them.
/obj/structure/rogue_pve_spider_nest/proc/rogue_disturb(atom/movable/intruder)
	if(world.time < calm_until || !isliving(intruder))
		return
	var/mob/living/living_intruder = intruder
	if(living_intruder.stat == DEAD || living_intruder.loc == src)
		return
	var/list/dwellers = rogue_dwellers()
	if(!length(dwellers))
		return
	var/mob/living/basic/rockhill/first = dwellers[1]
	if(first.faction_check_atom(living_intruder))
		return
	calm_until = world.time + ROGUE_PVE_NEST_DISTURB_COOLDOWN
	var/swarmed = FALSE
	for(var/mob/living/basic/rockhill/spider as anything in dwellers)
		if(HAS_TRAIT(spider, TRAIT_TAMED))
			continue
		rogue_let_out(spider)
		swarmed = TRUE
		if(spider.ai_controller)
			spider.ai_controller.insert_blackboard_key_lazylist(BB_BASIC_MOB_RETALIATE_LIST, living_intruder)
			spider.ai_controller.set_blackboard_key(BB_CURRENT_TARGET, living_intruder)
	if(swarmed)
		visible_message(span_danger("Spiders swarm out of [src]!"))

/// A spider at the start of the round weaves a nest where its colony has none near; a spider born or brought later moves into
/// a nest near it, if any.
/mob/living/basic/rockhill/proc/rogue_pve_settle(mapload)
	if(QDELETED(src) || stat == DEAD || !ai_controller || HAS_TRAIT(src, TRAIT_TAMED) || !rogue_combat_enabled())
		return
	var/obj/structure/rogue_pve_spider_nest/nest = locate() in range(ROGUE_PVE_NEST_RANGE, src)
	if(!nest)
		var/turf/spot = get_turf(src)
		if(!mapload || !isopenturf(spot) || istype(spot, /turf/open/water) || spot.is_blocked_turf(TRUE))
			return
		nest = new(spot)
	ai_controller.set_blackboard_key(BB_ROGUE_PVE_HOME, nest)

/// Vibelin enter_exit_home: a spider idle near its nest goes in now and then, and one inside comes out again now and then.
/datum/bt_node/ai_behavior/rogue_pve_keep_home
	time_between_perform = 1 SECONDS
	var/home_key
	/// It is on its way in.
	var/heading_home = FALSE
	/// When it set out, to give up on a nest it cannot reach.
	var/set_out_at = 0

/datum/bt_node/ai_behavior/rogue_pve_keep_home/setup(datum/ai_controller/controller)
	var/obj/structure/rogue_pve_spider_nest/nest = controller.blackboard[home_key]
	if(QDELETED(nest) || HAS_TRAIT(controller.pawn, TRAIT_TAMED))
		return FALSE
	heading_home = FALSE
	return TRUE

/datum/bt_node/ai_behavior/rogue_pve_keep_home/perform(seconds_per_tick, datum/ai_controller/controller)
	var/obj/structure/rogue_pve_spider_nest/nest = controller.blackboard[home_key]
	var/mob/living/basic/rockhill/spider = controller.pawn
	if(QDELETED(nest))
		return AI_BEHAVIOR_INSTANT | AI_BEHAVIOR_FAILED
	if(spider.loc == nest)
		if(prob(ROGUE_PVE_NEST_LEAVE_CHANCE))
			nest.rogue_let_out(spider)
			return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_SUCCEEDED
		return AI_BEHAVIOR_DELAY
	if(!heading_home)
		if(!prob(ROGUE_PVE_NEST_ENTER_CHANCE) || !nest.rogue_has_room())
			return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED
		heading_home = TRUE
		set_out_at = world.time
	if(get_turf(spider) == get_turf(nest) || spider.Adjacent(nest))
		controller.ai_movement.stop_moving_towards(controller)
		nest.rogue_take_in(spider)
		heading_home = FALSE
		return AI_BEHAVIOR_DELAY
	if(world.time > set_out_at + 30 SECONDS)
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED
	if(!controller.ai_movement.moving_controllers[controller])
		controller.ai_movement.start_moving_towards(controller, nest, 1)
	return AI_BEHAVIOR_DELAY

/datum/bt_node/ai_behavior/rogue_pve_keep_home/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	if(heading_home)
		controller.ai_movement.stop_moving_towards(controller)
	heading_home = FALSE
