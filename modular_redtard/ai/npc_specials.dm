/// How a Ratwood NPC judges the moment for its weapon's special (Azure Peak special_intents.dm npc_use_chance() and its helpers,
/// read by ai/human_npc.dm rogue_try_special()): a sweep is worth it when it would catch several foes and no friend, a lunge
/// down a line of foes, a finisher on a foe left open; the shield's guard is never used by NPCs. Specials without an opinion
/// leave it to the NPC's flat chance (npc_special_chance).

/// Percent chance an NPC uses this special now (0 - never, 100 - at once), or null for its flat chance.
/datum/special_intent/proc/rogue_npc_odds(mob/living/user, atom/target)
	return null

/// Azure Peak npc_count_nearby(): standing foes and friends of the user within the radius of the center (the user by default).
/datum/special_intent/proc/rogue_npc_count(mob/living/user, radius, atom/center)
	var/enemies = 0
	var/allies = 0
	for(var/mob/living/other in view(radius, get_turf(center || user)))
		if(other == user || other.stat == DEAD || other.body_position == LYING_DOWN)
			continue
		if(user.faction_check_atom(other))
			allies++
		else
			enemies++
	return list(enemies, allies)

/// Azure Peak npc_ring_chance(): a sweep all around the user.
/datum/special_intent/proc/rogue_npc_ring(mob/living/user, radius = 2)
	var/list/count = rogue_npc_count(user, radius)
	var/enemies = count[1]
	var/allies = count[2]
	if(!enemies)
		return 0
	if(enemies >= 3 && enemies >= allies)
		return 100
	return max(15 + (enemies - 1) * 20 - allies * 20, 5)

/// Azure Peak npc_front_chance(): a sweep of the tiles in front of the user.
/datum/special_intent/proc/rogue_npc_front(mob/living/user)
	var/turf/front = get_step(get_turf(user), user.dir)
	if(!front)
		return 0
	var/list/count = rogue_npc_count(user, 1, front)
	var/enemies = count[1]
	if(!enemies)
		return 0
	if(count[2])
		return 5
	if(enemies >= 3)
		return 100
	return enemies >= 2 ? 60 : 15

/// Azure Peak npc_line_chance(): a strike down a line of tiles in front of the user.
/datum/special_intent/proc/rogue_npc_line(mob/living/user, length = 3)
	var/enemies = 0
	var/allies = 0
	var/turf/spot = get_turf(user)
	for(var/i in 1 to length)
		spot = get_step(spot, user.dir)
		if(!spot || spot.density)
			break
		var/list/count = rogue_npc_count(user, 0, spot)
		enemies += count[1]
		allies += count[2]
	if(!enemies)
		return 0
	if(allies)
		return 5
	if(enemies >= 3)
		return 100
	return enemies >= 2 ? 80 : 15

/// Azure Peak npc_finisher_chance(): at once on a foe left open, rarely otherwise.
/datum/special_intent/proc/rogue_npc_finisher(atom/target)
	if(!isliving(target))
		return 0
	var/mob/living/foe = target
	return foe.rogue_is_open() ? 100 : 10

/datum/special_intent/ground_smash/rogue_npc_odds(mob/living/user, atom/target)
	return rogue_npc_line(user, 3)

/datum/special_intent/flail_sweep/rogue_npc_odds(mob/living/user, atom/target)
	var/list/count = rogue_npc_count(user, 1)
	var/enemies = count[1]
	if(enemies >= 3)
		return 100
	if(enemies == 2 && !count[2])
		return 10
	return 0

/datum/special_intent/quarterstaff_sweep/rogue_npc_odds(mob/living/user, atom/target)
	return rogue_npc_front(user)

/datum/special_intent/axe_swing/rogue_npc_odds(mob/living/user, atom/target)
	return rogue_npc_front(user)

/datum/special_intent/greatsword_swing/rogue_npc_odds(mob/living/user, atom/target)
	return rogue_npc_ring(user, 2)

/datum/special_intent/limbguard/rogue_npc_odds(mob/living/user, atom/target)
	return 0

/datum/special_intent/polearm_backstep/rogue_npc_odds(mob/living/user, atom/target)
	var/list/count = rogue_npc_count(user, 1)
	var/enemies = count[1]
	if(!enemies)
		return 0
	return enemies >= 2 ? 75 : 10

/datum/special_intent/martyr_volcano_slam/rogue_npc_odds(mob/living/user, atom/target)
	return rogue_npc_front(user)

/datum/special_intent/martyr_blazing_sweep/rogue_npc_odds(mob/living/user, atom/target)
	return rogue_npc_front(user)

/datum/special_intent/martyr_blazing_trident/rogue_npc_odds(mob/living/user, atom/target)
	return rogue_npc_front(user)

/datum/special_intent/upper_cut/rogue_npc_odds(mob/living/user, atom/target)
	return rogue_npc_finisher(target)

// Azure Peak's own specials (combat/specials_azure.dm).

/datum/special_intent/hatchet_twirl/rogue_npc_odds(mob/living/user, atom/target)
	return rogue_npc_front(user)

/datum/special_intent/warhammer_swing/rogue_npc_odds(mob/living/user, atom/target)
	return rogue_npc_front(user)

/datum/special_intent/vicious_swipe/rogue_npc_odds(mob/living/user, atom/target)
	return rogue_npc_ring(user, 2)

/datum/special_intent/drakkyrmaw_bite/rogue_npc_odds(mob/living/user, atom/target)
	return rogue_npc_line(user, 4)

/datum/special_intent/gilded_dragon_sweep/rogue_npc_odds(mob/living/user, atom/target)
	return rogue_npc_front(user)

/datum/special_intent/arcyne_descent/rogue_npc_odds(mob/living/user, atom/target)
	return rogue_npc_finisher(target)
