/// The special abilities of Ratwood's monsters (and the axe troll's slam of Vibelin) as TG mob abilities: a creature gets them
/// at spawn (rogue_pve_ability_types, pve/mind.dm), its mind uses one whenever rogue_ai_wants() says the moment calls for it, and
/// a player in its body clicks them like any TG mob ability. Cooldowns, damage and timings are values of config/redtard/mechanics/values/pve.txt.
/datum/action/cooldown/mob_cooldown/rogue_pve
	name = "Ability"
	shared_cooldown = NONE
	/// Name of the value of config/redtard/mechanics/values/pve.txt with its cooldown.
	var/cooldown_value

/datum/action/cooldown/mob_cooldown/rogue_pve/New(Target, original = TRUE)
	. = ..()
	if(cooldown_value)
		cooldown_time = rogue_value(cooldown_value)

/// Whether the creature is still there to finish what it started.
/datum/action/cooldown/mob_cooldown/rogue_pve/proc/rogue_can_go_on()
	return !QDELETED(owner) && owner.stat != DEAD

/// The rock thrown at someone, flying over the ground.
/obj/effect/temp_visual/rogue_pve_rock
	name = "stone"
	icon = ROGUE_PVE_NATURAL_ICON
	icon_state = "stonebig1"
	layer = FLY_LAYER
	plane = ABOVE_GAME_PLANE
	randomdir = FALSE
	duration = 6

/// A rock thrust up by the behemoth's quake (Ratwood /obj/structure/flora/rock); it crumbles away after a while.
/obj/structure/roguerock/rogue_pve_quake
	desc = "A rock thrust up from the ground."

/// Ratwood stone_throw of the cave troll: it eyes someone, digs a huge rock out of the ground and hurls it. Whoever is still
/// where it aimed is hit and thrown off their feet for a moment.
/datum/action/cooldown/mob_cooldown/rogue_pve/stone_throw
	name = "Stone Throw"
	desc = "Dig a huge rock out of the ground and hurl it at someone."
	cooldown_value = "pve_stone_throw_cooldown"

/datum/action/cooldown/mob_cooldown/rogue_pve/stone_throw/rogue_ai_wants(mob/living/basic/rockhill/beast, atom/target)
	return rogue_in_reach(target)

/datum/action/cooldown/mob_cooldown/rogue_pve/stone_throw/proc/rogue_in_reach(atom/target)
	var/distance = get_dist(owner, target)
	var/reach = ROGUE_PVE_STONE_THROW_RANGE
	return distance > 1 && distance < reach && can_see(owner, target, reach)

/datum/action/cooldown/mob_cooldown/rogue_pve/stone_throw/Activate(atom/target)
	if(!isliving(target) || !rogue_in_reach(target))
		return FALSE
	owner.visible_message(span_alert("[owner] reaches towards the ground, eyeing [target]."))
	addtimer(CALLBACK(src, PROC_REF(rogue_dig), WEAKREF(target)), ROGUE_PVE_STONE_THROW_AIM)
	StartCooldown()
	return TRUE

/datum/action/cooldown/mob_cooldown/rogue_pve/stone_throw/proc/rogue_dig(datum/weakref/target_ref)
	if(!rogue_can_go_on())
		return
	owner.visible_message(span_alert("[owner] digs into the ground and grabs a massive rock!"))
	playsound(owner, ROGUE_PVE_SOUND_DIG, 100, TRUE)
	addtimer(CALLBACK(src, PROC_REF(rogue_hurl), target_ref), ROGUE_PVE_STONE_THROW_DIG)

/datum/action/cooldown/mob_cooldown/rogue_pve/stone_throw/proc/rogue_hurl(datum/weakref/target_ref)
	if(!rogue_can_go_on())
		return
	var/mob/living/target = target_ref?.resolve()
	if(!target || !rogue_in_reach(target))
		owner.visible_message(span_alert("[owner] roars in frustration."))
		return
	owner.visible_message(span_boldwarning("[owner] chucks a huge rock!"))
	playsound(owner, ROGUE_PVE_SOUND_HEAVE, 100, TRUE)
	var/turf/start = get_turf(owner)
	var/turf/aimed = get_turf(target)
	var/obj/effect/temp_visual/rogue_pve_rock/rock = new(start)
	animate(rock, pixel_x = (aimed.x - start.x) * ICON_SIZE_X, pixel_y = (aimed.y - start.y) * ICON_SIZE_Y, time = 4)
	addtimer(CALLBACK(src, PROC_REF(rogue_land), target_ref, aimed), 4)

/datum/action/cooldown/mob_cooldown/rogue_pve/stone_throw/proc/rogue_land(datum/weakref/target_ref, turf/aimed)
	playsound(aimed, ROGUE_PVE_SOUND_SMASH_ROCK, 100, TRUE)
	var/mob/living/target = target_ref?.resolve()
	if(QDELETED(owner) || !target || get_turf(target) != aimed)
		return
	rogue_pve_strike(owner, target, ROGUE_PVE_STONE_THROW_DAMAGE, pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_CHEST, BODY_ZONE_HEAD))
	target.Paralyze(0.5 SECONDS)
	to_chat(target, span_userdanger("I'm hit by a big rock!"))

/// Vibelin ground_slam of the axe troll: it rears back, the line to its foe is marked, and a moment later the axe comes down on
/// everyone still on it.
/datum/action/cooldown/mob_cooldown/rogue_pve/troll_slam
	name = "Ground Slam"
	desc = "Slam the axe into the ground in a line, crushing anything caught beneath it."
	cooldown_value = "pve_troll_slam_cooldown"

/datum/action/cooldown/mob_cooldown/rogue_pve/troll_slam/rogue_ai_wants(mob/living/basic/rockhill/beast, atom/target)
	var/distance = get_dist(owner, target)
	var/reach = ROGUE_PVE_TROLL_SLAM_RANGE
	return distance >= 1 && distance <= reach && can_see(owner, target, reach)

/datum/action/cooldown/mob_cooldown/rogue_pve/troll_slam/Activate(atom/target)
	var/turf/start = get_turf(owner)
	var/turf/end = get_turf(target)
	if(!start || !end || start == end)
		return FALSE
	var/reach = ROGUE_PVE_TROLL_SLAM_RANGE
	var/list/line = list()
	for(var/turf/tile as anything in get_line(start, end))
		if(tile == start)
			continue
		if(isclosedturf(tile) || length(line) >= reach)
			break
		line += tile
	if(!length(line))
		return FALSE
	var/windup = ROGUE_PVE_TROLL_SLAM_WINDUP
	owner.visible_message(span_danger("[owner] rears back, axe raised high!"))
	var/mob/living/troll = owner
	if(istype(troll))
		troll.Stun(windup, ignore_canstun = TRUE)
	for(var/turf/marked as anything in line)
		new /obj/effect/temp_visual/rogue_pve_mark(marked, windup)
	addtimer(CALLBACK(src, PROC_REF(rogue_slam), line), windup)
	StartCooldown()
	return TRUE

/datum/action/cooldown/mob_cooldown/rogue_pve/troll_slam/proc/rogue_slam(list/line)
	if(!rogue_can_go_on())
		return
	owner.visible_message(span_danger("[owner] slams its axe into the ground!"))
	playsound(owner, 'sound/effects/meteorimpact.ogg', 100, TRUE)
	var/damage = ROGUE_PVE_TROLL_SLAM_DAMAGE
	for(var/turf/hit as anything in line)
		new /obj/effect/temp_visual/rogue_pve_mark/strike(hit)
		for(var/mob/living/victim in hit)
			if(!rogue_pve_is_foe(owner, victim))
				continue
			rogue_pve_strike(owner, victim, damage, BODY_ZONE_HEAD, SHARP_EDGED, armored = FALSE)
			victim.visible_message(span_danger("[victim] is crushed by the slam!"))

/// Ratwood quake of the earthen behemoth: the ground around someone is marked, and a moment later it ruptures, throwing down
/// everyone there and pinning them with rock.
/datum/action/cooldown/mob_cooldown/rogue_pve/quake
	name = "Quake"
	desc = "Shake the ground beneath someone; whoever stands there is thrown down and pinned by rock."
	cooldown_value = "pve_quake_cooldown"

/datum/action/cooldown/mob_cooldown/rogue_pve/quake/rogue_ai_wants(mob/living/basic/rockhill/beast, atom/target)
	return can_see(owner, target, ROGUE_PVE_SIGHT)

/datum/action/cooldown/mob_cooldown/rogue_pve/quake/Activate(atom/target)
	var/turf/center = get_turf(target)
	if(!center)
		return FALSE
	owner.visible_message(span_danger("[owner] shakes the ground beneath [target]!"))
	playsound(owner, ROGUE_PVE_SOUND_STONE_HIT, 100, TRUE, 10)
	var/delay = ROGUE_PVE_QUAKE_DELAY
	for(var/turf/open/spot in range(1, center))
		new /obj/effect/temp_visual/rogue_pve_mark(spot, delay)
	addtimer(CALLBACK(src, PROC_REF(rogue_rupture), center), delay)
	StartCooldown()
	return TRUE

/datum/action/cooldown/mob_cooldown/rogue_pve/quake/proc/rogue_rupture(turf/center)
	if(!rogue_can_go_on())
		return
	var/paralyze = ROGUE_PVE_QUAKE_PARALYZE
	var/rock_time = ROGUE_PVE_QUAKE_ROCK_TIME
	for(var/mob/living/shaken in range(1, center))
		if(!rogue_pve_is_foe(owner, shaken))
			continue
		shake_camera(shaken, 5, 5)
		to_chat(shaken, span_danger("<b>The ground ruptures beneath my feet!</b>"))
		shaken.Paralyze(paralyze)
		var/turf/spot = get_turf(shaken)
		if(!spot || (locate(/obj/structure/roguerock/rogue_pve_quake) in spot))
			continue
		var/obj/structure/roguerock/rogue_pve_quake/rock = new(spot)
		QDEL_IN(rock, rock_time)

/// Ratwood stomp of the earthen colossus: everyone next to it is flung far away.
/datum/action/cooldown/mob_cooldown/rogue_pve/stomp
	name = "Stomp"
	desc = "Stomp the ground, flinging away everyone around."
	cooldown_value = "pve_stomp_cooldown"
	click_to_activate = FALSE

/datum/action/cooldown/mob_cooldown/rogue_pve/stomp/rogue_ai_wants(mob/living/basic/rockhill/beast, atom/target)
	return owner.Adjacent(target)

/datum/action/cooldown/mob_cooldown/rogue_pve/stomp/Activate(atom/target)
	var/damage = ROGUE_PVE_STOMP_DAMAGE
	var/distance = ROGUE_PVE_STOMP_RANGE
	for(var/mob/living/stomped in range(1, owner))
		if(!rogue_pve_is_foe(owner, stomped))
			continue
		new /obj/effect/temp_visual/rogue_pve_mark/strike(get_turf(stomped))
		if(!stomped.anchored)
			stomped.safe_throw_at(get_edge_target_turf(owner, get_dir(owner, stomped) || pick(GLOB.alldirs)), distance, 4, owner, force = MOVE_FORCE_EXTREMELY_STRONG)
		rogue_pve_strike(owner, stomped, damage, armored = FALSE)
	owner.visible_message(span_danger("[owner] stomps the ground!"))
	playsound(owner, 'sound/effects/bamf.ogg', 100, TRUE, 10)
	StartCooldown()
	return TRUE

/// Ratwood create_meteors() of the fiend: fire falls on tiles around someone.
/datum/action/cooldown/mob_cooldown/rogue_pve/meteors
	name = "Meteor Storm"
	desc = "Rain fire from the sky around someone."
	cooldown_value = "pve_meteor_cooldown"

/datum/action/cooldown/mob_cooldown/rogue_pve/meteors/rogue_ai_wants(mob/living/basic/rockhill/beast, atom/target)
	return can_see(owner, target, ROGUE_PVE_SIGHT)

/datum/action/cooldown/mob_cooldown/rogue_pve/meteors/Activate(atom/target)
	var/turf/center = get_turf(target)
	if(!center)
		return FALSE
	center.visible_message(span_boldwarning("Fire rains from the sky!"))
	var/chance = ROGUE_PVE_METEOR_CHANCE
	for(var/turf/open/spot in RANGE_TURFS(ROGUE_PVE_METEOR_RADIUS, center))
		if(prob(chance))
			new /obj/effect/temp_visual/rogue_pve_meteor(spot, owner)
	StartCooldown()
	return TRUE

/// A spot fire falls on (TG's drake meteor without its explosions and digging): a mark, the falling fire, then burns.
/obj/effect/temp_visual/rogue_pve_meteor
	icon = 'icons/mob/actions/actions_items.dmi'
	icon_state = "sniper_zoom"
	layer = BELOW_MOB_LAYER
	plane = GAME_PLANE
	randomdir = FALSE
	light_range = 2
	duration = 9
	/// Who called it down; its kin are spared.
	var/datum/weakref/caster_ref

/obj/effect/temp_visual/rogue_pve_meteor/Initialize(mapload, mob/living/caster)
	. = ..()
	caster_ref = WEAKREF(caster)
	new /obj/effect/temp_visual/fireball(loc)
	addtimer(CALLBACK(src, PROC_REF(rogue_fall)), duration - 1)

/obj/effect/temp_visual/rogue_pve_meteor/proc/rogue_fall()
	var/turf/spot = get_turf(src)
	if(!spot)
		return
	playsound(spot, 'sound/effects/meteorimpact.ogg', 80, TRUE)
	var/mob/living/caster = caster_ref?.resolve()
	var/damage = ROGUE_PVE_METEOR_DAMAGE
	for(var/mob/living/burnt in spot)
		if(!rogue_pve_is_foe(caster, burnt))
			continue
		burnt.apply_damage(damage, BURN, spread_damage = TRUE)
		burnt.adjust_fire_stacks(1)
		burnt.ignite_mob()
		to_chat(burnt, span_userdanger("I'm hit by falling fire!"))

/// Ratwood callforbackup() of the fiend: imps and hell hounds climb out of the abyss beside it. Unlike Ratwood, only so many
/// of its callers live at once.
/datum/action/cooldown/mob_cooldown/rogue_pve/call_infernals
	name = "Call Infernals"
	desc = "Call imps and hell hounds from the infernal abyss."
	cooldown_value = "pve_summon_cooldown"
	click_to_activate = FALSE
	/// What answers the call; a few are picked from it.
	var/list/summon_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp,
		/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp,
		/mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound,
		/mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound,
	)
	/// Weak references to those that came.
	var/list/summoned

/datum/action/cooldown/mob_cooldown/rogue_pve/call_infernals/rogue_ai_wants(mob/living/basic/rockhill/beast, atom/target)
	return rogue_alive() < ROGUE_PVE_SUMMON_CAP

/// How many of those that came still live.
/datum/action/cooldown/mob_cooldown/rogue_pve/call_infernals/proc/rogue_alive()
	var/list/alive = list()
	for(var/datum/weakref/minion_ref as anything in summoned)
		var/mob/living/minion = minion_ref.resolve()
		if(minion && minion.stat != DEAD)
			alive += minion_ref
	summoned = alive
	return length(alive)

/datum/action/cooldown/mob_cooldown/rogue_pve/call_infernals/Activate(atom/target)
	var/room = min(ROGUE_PVE_SUMMON_COUNT, ROGUE_PVE_SUMMON_CAP - rogue_alive())
	var/list/spots = list()
	for(var/turf/open/spot in range(1, owner))
		if(!spot.is_blocked_turf(TRUE))
			spots += spot
	if(room <= 0 || !length(spots))
		return FALSE
	owner.visible_message(span_notice("[owner] summons reinforcements from the infernal abyss."))
	playsound(owner, 'sound/effects/magic/fireball.ogg', 80, TRUE)
	var/list/pool = summon_types.Copy()
	for(var/i in 1 to room)
		if(!length(pool))
			break
		var/summon_type = pick_n_take(pool)
		var/mob/living/minion = new summon_type(pick(spots))
		LAZYADD(summoned, WEAKREF(minion))
	StartCooldown()
	return TRUE
