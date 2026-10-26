/// Ratwood fire heat (code/game/objects/lighting/_base_roguelight.dm heat_level, code/game/turfs/open/floor.dm heat): a burning
/// fire warms the floor under it and the floors around, one level less per step, through open floor only; standing on a warm
/// floor brings the body back to its normal heat (species.dm handle_environment(), heat * 4 per tick). Ratwood lets the heat seep
/// out every two seconds; here it is laid out when the fire lights and taken back when it goes out.
/obj/machinery/light/rogue/var/heat_level = 0
/// Floors this fire warms.
/obj/machinery/light/rogue/var/list/heated_floors

/// Heat on this floor, fire to level (Ratwood heat_sources and heat).
/turf/open/floor/var/list/rogue_heat_sources

/obj/machinery/light/rogue/firebowl
	heat_level = 4

/obj/machinery/light/rogue/firebowl/standing
	heat_level = 3

/obj/machinery/light/rogue/campfire
	heat_level = 5

/obj/machinery/light/rogue/campfire/fireplace
	heat_level = 6

/obj/machinery/light/rogue/hearth
	heat_level = 3

/obj/machinery/light/rogue/firebowl/ignite(silent = FALSE)
	. = ..()
	if(.)
		spread_heat()

/obj/machinery/light/rogue/firebowl/burn_out(silent = FALSE)
	. = ..()
	if(.)
		clear_heat()

/obj/machinery/light/rogue/firebowl/Destroy()
	clear_heat()
	return ..()

/obj/machinery/light/rogue/proc/spread_heat()
	clear_heat()
	var/heat = min(heat_level, ROGUE_FLOOR_HEAT_MAX)
	if(heat <= 0 || !isfloorturf(loc))
		return
	heated_floors = list()
	var/list/seen = list()
	seen[loc] = TRUE
	var/list/frontier = list(loc)
	while(length(frontier) && heat > 0)
		var/list/next = list()
		for(var/turf/open/floor/floor as anything in frontier)
			LAZYSET(floor.rogue_heat_sources, src, heat)
			heated_floors += floor
			for(var/direction in GLOB.cardinals)
				var/turf/open/floor/near = get_step(floor, direction)
				if(!isfloorturf(near) || seen[near])
					continue
				seen[near] = TRUE
				next += near
		frontier = next
		heat--

/obj/machinery/light/rogue/proc/clear_heat()
	for(var/turf/open/floor/floor as anything in heated_floors)
		if(isfloorturf(floor))
			LAZYREMOVE(floor.rogue_heat_sources, src)
	heated_floors = null

/// How warm this floor is (Ratwood get_source_heat(): the hottest fire on it).
/turf/open/floor/proc/rogue_heat()
	. = 0
	for(var/obj/machinery/light/rogue/fire as anything in rogue_heat_sources)
		if(fire.lit)
			. = max(., rogue_heat_sources[fire])

/// Ratwood warm floors on a human: body heat back towards normal, never past it.
/datum/element/rogue_warm_floor
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

/datum/element/rogue_warm_floor/Attach(datum/target)
	. = ..()
	if(!ishuman(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_LIVING_LIFE, PROC_REF(on_life))

/datum/element/rogue_warm_floor/Detach(datum/source)
	UnregisterSignal(source, COMSIG_LIVING_LIFE)
	return ..()

/datum/element/rogue_warm_floor/proc/on_life(mob/living/carbon/human/source, seconds_per_tick, times_fired)
	SIGNAL_HANDLER
	if(source.stat == DEAD || source.bodytemperature >= BODYTEMP_NORMAL || !isfloorturf(source.loc))
		return
	var/turf/open/floor/floor = source.loc
	var/heat = floor.rogue_heat()
	if(heat)
		source.adjust_bodytemperature(min(heat * ROGUE_FLOOR_WARMTH_PER_HEAT * seconds_per_tick / 2, BODYTEMP_NORMAL - source.bodytemperature))

/// Ratwood warming the hands at a fire (fireplace and hearth attack_hand(), brazier attack_right()): after a moment the body gets
/// some heat back, up to normal (Ratwood's +75 is past TG's heat damage, so TG's normal is the cap).
/obj/machinery/light/rogue/proc/warm_hands(mob/living/user, delay, warmth)
	if(!ishuman(user))
		return FALSE
	user.visible_message(span_info("[user] warms [user.p_their()] hands over [src]."), span_info("I warm my hands over [src]."))
	if(!do_after(user, delay, target = src) || !lit)
		return FALSE
	if(user.bodytemperature < BODYTEMP_NORMAL)
		user.adjust_bodytemperature(min(warmth, BODYTEMP_NORMAL - user.bodytemperature))
	return TRUE

/obj/machinery/light/rogue/firebowl/attack_hand_secondary(mob/living/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || !lit)
		return
	INVOKE_ASYNC(src, PROC_REF(warm_hands), user, 4 SECONDS, ROGUE_BRAZIER_WARMTH)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/// Ratwood campfire rest (code/game/objects/lighting/rogue_fires.dm campfire process(), attack_hand()): a burning campfire or
/// fireplace comforts everyone in sight within its reach - a short rest that restores energy and some warmth, and a better
/// mood; lying on a bed, a stump or a bedsheet beside it, out of combat, also slowly heals. Warming the hands at a campfire
/// is a longer rest that heals for as long as one stays.
/obj/machinery/light/rogue/campfire
	/// Reach of the rest (Ratwood healing_range).
	var/healing_range = 1
	/// Status effect of resting by it (Ratwood stamina_status_effect).
	var/datum/status_effect/rest_effect = /datum/status_effect/rogue_fire_rest
	/// A hand at it is a long healing rest; Ratwood fireplaces only warm the hands.
	var/rests_by_hand = TRUE

/obj/machinery/light/rogue/campfire/fireplace
	healing_range = 2
	rest_effect = /datum/status_effect/rogue_fire_rest/fireplace
	rests_by_hand = FALSE

/obj/machinery/light/rogue/campfire/fireplace/inn
	healing_range = 6

/obj/machinery/light/rogue/campfire/ignite(silent = FALSE)
	. = ..()
	if(.)
		spread_heat()
		START_PROCESSING(SSobj, src)

/obj/machinery/light/rogue/campfire/burn_out(silent = FALSE)
	. = ..()
	if(.)
		clear_heat()
		STOP_PROCESSING(SSobj, src)

/obj/machinery/light/rogue/campfire/Destroy()
	STOP_PROCESSING(SSobj, src)
	clear_heat()
	return ..()

/obj/machinery/light/rogue/campfire/process(seconds_per_tick)
	if(!lit)
		return PROCESS_KILL
	for(var/mob/living/carbon/human/resting in get_hearers_in_LOS(healing_range, src, RECURSIVE_CONTENTS_CLIENT_MOBS))
		if(resting.stat == DEAD || get_dist(src, resting) > healing_range)
			continue
		if(!resting.has_status_effect(rest_effect))
			to_chat(resting, span_info("The warmth of the fire comforts me, affording me a short rest. I would need to lie down on a bed to get a better rest."))
		resting.apply_status_effect(rest_effect)
		resting.add_mood_event("rogue_campfire", /datum/mood_event/rogue_campfire)
		if(resting.body_position != LYING_DOWN || resting.combat_mode || !rogue_on_bedding(resting))
			continue
		if(!resting.has_status_effect(/datum/status_effect/rogue_fire_sleep))
			to_chat(resting, span_info("Settling in by the flames lifts the burdens of the week."))
		resting.apply_status_effect(/datum/status_effect/rogue_fire_sleep)

/// Ratwood acceptable_beds of the campfire: a bed, a stump or a bedsheet under the resting one.
/proc/rogue_on_bedding(mob/living/resting)
	var/static/list/beddings
	if(!beddings)
		var/list/types = list(/obj/structure/bed, /obj/item/bedsheet)
		var/stump = text2path("/obj/structure/flora/roguetree/stump")
		if(stump)
			types += stump
		beddings = typecacheof(types)
	var/turf/spot = get_turf(resting)
	for(var/obj/thing in spot)
		if(is_type_in_typecache(thing, beddings))
			return TRUE
	return FALSE

/// Ratwood campfire attack_hand(): warm the hands, then rest by the fire - every ten seconds a little healing and comfort.
/obj/machinery/light/rogue/campfire/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(. || !lit || !ishuman(user))
		return
	INVOKE_ASYNC(src, PROC_REF(rest_by_fire), user)
	return TRUE

/obj/machinery/light/rogue/campfire/proc/rest_by_fire(mob/living/carbon/human/user)
	if(!rests_by_hand)
		warm_hands(user, 1.5 SECONDS, ROGUE_HAND_WARMTH)
		return
	user.visible_message(span_info("[user] warms [user.p_their()] hands near the fire."), span_info("I warm my hands near the fire."))
	if(user.bodytemperature < BODYTEMP_NORMAL)
		user.adjust_bodytemperature(min(ROGUE_HAND_WARMTH, BODYTEMP_NORMAL - user.bodytemperature))
	var/first = TRUE
	while(do_after(user, 10.5 SECONDS, target = src) && lit)
		user.apply_status_effect(/datum/status_effect/rogue_fire_sleep/respite)
		user.add_mood_event("rogue_campfire", /datum/mood_event/rogue_campfire)
		if(first)
			to_chat(user, span_good("The warmth of the fire comforts me, affording me a short rest."))
			first = FALSE

#define ROGUE_FIRE_REST_FILTER "rogue_fire_rest"

/// Ratwood campfire_stamina (code/datums/status_effects/rogue/roguebuff.dm): a short rest by the fire - energy back every second
/// (twice as much out of combat) and some warmth for a cold body.
/datum/status_effect/rogue_fire_rest
	id = "rogue_fire_rest"
	duration = 5 SECONDS
	tick_interval = 1 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/rogue_fire_rest
	/// Energy back per second (Ratwood healing_on_tick).
	var/energy = 5

/datum/status_effect/rogue_fire_rest/fireplace
	alert_type = /atom/movable/screen/alert/status_effect/rogue_fire_rest/fireplace

/datum/status_effect/rogue_fire_rest/on_apply()
	if(!owner.get_filter(ROGUE_FIRE_REST_FILTER))
		owner.add_filter(ROGUE_FIRE_REST_FILTER, 2, list("type" = "outline", "color" = "#7e6a3e", "alpha" = 60, "size" = 1))
	return TRUE

/datum/status_effect/rogue_fire_rest/on_remove()
	owner.remove_filter(ROGUE_FIRE_REST_FILTER)

/datum/status_effect/rogue_fire_rest/tick(seconds_between_ticks)
	if(ishuman(owner))
		var/mob/living/carbon/human/human = owner
		human.rogue_energy_add(energy * (human.combat_mode ? 1 : 2) * seconds_between_ticks)
	if(owner.bodytemperature < BODYTEMP_NORMAL - ROGUE_FIRE_REST_COLD)
		owner.adjust_bodytemperature(min(ROGUE_FIRE_REST_WARMTH * seconds_between_ticks, BODYTEMP_NORMAL - owner.bodytemperature))

/atom/movable/screen/alert/status_effect/rogue_fire_rest
	name = "Camp Rest"
	desc = "A break by the fire restores some of my energy."
	icon = ROGUE_SURVIVAL_ALERTS
	icon_state = "campfire"

/atom/movable/screen/alert/status_effect/rogue_fire_rest/fireplace
	name = "Warming Respite"
	desc = "The warmth of a fire restores some of my energy."
	icon_state = "fireplace"

/// Ratwood buff/campfire: lying by the fire on a bed, out of combat - brute, burn, suffocation, toxin and brain damage heal a
/// little every second, and blood comes back up to the safe level.
/datum/status_effect/rogue_fire_sleep
	id = "rogue_fire_sleep"
	duration = 6 SECONDS
	tick_interval = 1 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/rogue_fire_respite
	/// Healing per second (Ratwood healing_on_tick).
	var/healing = 2
	/// Blood the healing stops at.
	var/blood_cap = BLOOD_VOLUME_OKAY
	/// Healing only out of combat.
	var/peaceful = TRUE

/datum/status_effect/rogue_fire_sleep/tick(seconds_between_ticks)
	if(peaceful && owner.combat_mode)
		return
	new /obj/effect/temp_visual/heal(get_turf(owner), "#c7aa5c")
	var/amount = healing * seconds_between_ticks
	if(owner.get_blood_volume() < blood_cap)
		owner.adjust_blood_volume(amount, maximum = blood_cap)
	var/need_update = FALSE
	need_update += owner.adjust_brute_loss(-amount, updating_health = FALSE)
	need_update += owner.adjust_fire_loss(-amount, updating_health = FALSE)
	need_update += owner.adjust_oxy_loss(-amount, updating_health = FALSE)
	need_update += owner.adjust_tox_loss(-amount, updating_health = FALSE)
	owner.adjust_organ_loss(ORGAN_SLOT_BRAIN, -amount)
	if(need_update)
		owner.updatehealth()

/// Ratwood healing/campfire: warming the hands at a campfire heals one point a second for ten seconds, in or out of combat.
/datum/status_effect/rogue_fire_sleep/respite
	id = "rogue_fire_respite"
	duration = 10 SECONDS
	healing = 1
	blood_cap = BLOOD_VOLUME_NORMAL
	peaceful = FALSE

/atom/movable/screen/alert/status_effect/rogue_fire_respite
	name = "Warming Respite"
	desc = "The warmth of a fire soothes my ails."
	icon = ROGUE_SURVIVAL_ALERTS
	icon_state = "campfire"

/// Ratwood stressevent/campfire.
/datum/mood_event/rogue_campfire
	description = "The warmth of the fire is comforting."
	mood_change = 1 * ROGUE_STRESS_TO_MOOD
	timeout = 5 MINUTES

#undef ROGUE_FIRE_REST_FILTER
