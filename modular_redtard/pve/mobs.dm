/// Which of Ratwood's creatures (rockhill/ported/mobs.dm) shoot and what with, which have special abilities, and the spiders'
/// ways; Ratwood's choices, numbers in config/redtard/mechanics/values/pve.txt.

// Shooters (Ratwood projectiletype, ranged_cooldown_time, retreat_distance and minimum_distance).

/mob/living/simple_animal/hostile/rogue/skeleton/bow
	rogue_pve_shot = /obj/projectile/rogue_pve/arrow
	rogue_pve_shot_sound = ROGUE_PVE_SOUND_BOW
	rogue_pve_shot_cooldown = "pve_skeleton_shot_cooldown"

/mob/living/simple_animal/hostile/rogue/deepone/spit
	rogue_pve_shot = /obj/projectile/rogue_pve/deepone_stone
	rogue_pve_shot_sound = ROGUE_PVE_SOUND_SPIT
	rogue_pve_shot_cooldown = "pve_deepone_shot_cooldown"

/mob/living/simple_animal/hostile/rogue/deepone/wiz
	rogue_pve_shots = list(/obj/projectile/rogue_pve/frostbolt, /obj/projectile/rogue_pve/spark)
	rogue_pve_shot_sound = 'sound/effects/magic/fireball.ogg'
	rogue_pve_shot_cooldown = "pve_deepone_devout_shot_cooldown"

/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp
	rogue_pve_shot = /obj/projectile/rogue_pve/firebolt
	rogue_pve_shot_sound = 'sound/effects/magic/fireball.ogg'
	rogue_pve_shot_cooldown = "pve_imp_shot_cooldown"
	rogue_pve_keep_max = 4

/mob/living/simple_animal/hostile/retaliate/rogue/infernal/watcher
	rogue_pve_shot = /obj/projectile/rogue_pve/fireball
	rogue_pve_shot_sound = 'sound/effects/magic/fireball.ogg'
	rogue_pve_shot_cooldown = "pve_watcher_shot_cooldown"
	rogue_pve_keep_max = 4

/mob/living/simple_animal/hostile/retaliate/rogue/infernal/fiend
	rogue_pve_shot = /obj/projectile/rogue_pve/fireball/great
	rogue_pve_shot_sound = 'sound/effects/magic/fireball.ogg'
	rogue_pve_shot_cooldown = "pve_fiend_shot_cooldown"
	rogue_pve_keep_min = 4
	rogue_pve_keep_max = 5
	rogue_pve_ability_types = list(
		/datum/action/cooldown/mob_cooldown/rogue_pve/meteors,
		/datum/action/cooldown/mob_cooldown/rogue_pve/call_infernals,
	)

/mob/living/simple_animal/hostile/retaliate/rogue/elemental/colossus
	rogue_pve_shot = /obj/projectile/rogue_pve/earth_chunk
	rogue_pve_shot_sound = ROGUE_PVE_SOUND_STONE_HIT
	rogue_pve_shot_cooldown = "pve_colossus_shot_cooldown"
	rogue_pve_shot_style = ROGUE_PVE_SKIRMISHER
	rogue_pve_ability_types = list(/datum/action/cooldown/mob_cooldown/rogue_pve/stomp)

// Fighters with special abilities.

/mob/living/simple_animal/hostile/retaliate/rogue/troll/cave
	rogue_pve_ability_types = list(/datum/action/cooldown/mob_cooldown/rogue_pve/stone_throw)

/mob/living/simple_animal/hostile/retaliate/rogue/troll/axe
	rogue_pve_ability_types = list(/datum/action/cooldown/mob_cooldown/rogue_pve/troll_slam)

/mob/living/simple_animal/hostile/retaliate/rogue/elemental/behemoth
	rogue_pve_ability_types = list(/datum/action/cooldown/mob_cooldown/rogue_pve/quake)
	rogue_pve_blow_effects = TRUE

/// Ratwood behemoth AttackingTarget() and yeet(): a moment after its blow lands, the one it hit is flung far away.
/mob/living/simple_animal/hostile/retaliate/rogue/elemental/behemoth/rogue_pve_blow_landed(mob/living/target)
	addtimer(CALLBACK(src, PROC_REF(rogue_pve_fling), WEAKREF(target)), ROGUE_PVE_FLING_DELAY)

/mob/living/simple_animal/hostile/retaliate/rogue/elemental/behemoth/proc/rogue_pve_fling(datum/weakref/target_ref)
	var/mob/living/target = target_ref?.resolve()
	if(!target || stat == DEAD || target.stat == DEAD || get_dist(src, target) > 2)
		return
	if(!target.anchored)
		target.safe_throw_at(get_edge_target_turf(src, get_dir(src, target) || dir), ROGUE_PVE_FLING_RANGE, 4, src, force = MOVE_FORCE_EXTREMELY_STRONG)
	rogue_pve_strike(src, target, ROGUE_PVE_FLING_DAMAGE, armored = FALSE)

/mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound
	rogue_pve_blow_effects = TRUE
	/// Ratwood flame_cd: when its bite next sets someone alight.
	var/rogue_pve_next_ignite = 0

/// Ratwood hellhound AttackingTarget(): every ten seconds its bite sets its prey on fire.
/mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound/rogue_pve_blow_landed(mob/living/target)
	if(world.time < rogue_pve_next_ignite)
		return
	rogue_pve_next_ignite = world.time + ROGUE_PVE_IGNITE_COOLDOWN
	target.adjust_fire_stacks(ROGUE_PVE_IGNITE_STACKS)
	target.ignite_mob()
	target.visible_message(span_danger("[src] sets [target] on fire!"))

/mob/living/simple_animal/hostile/retaliate/rogue/fae/glimmerwing
	rogue_pve_blow_effects = TRUE
	/// Ratwood drug_cd: when its blow next dusts someone.
	var/rogue_pve_next_dust = 0

/// Ratwood glimmerwing AttackingTarget(): every 25 seconds its blow dusts its prey with fae powder: poison, and for a while
/// sharper wits and will but slower feet (Ratwood seelie_drugs; TG's drugginess for the haze).
/mob/living/simple_animal/hostile/retaliate/rogue/fae/glimmerwing/rogue_pve_blow_landed(mob/living/target)
	if(world.time < rogue_pve_next_dust)
		return
	rogue_pve_next_dust = world.time + ROGUE_PVE_DUST_COOLDOWN
	target.visible_message(span_danger("[src] dusts [target] with some kind of powder!"))
	target.adjust_tox_loss(ROGUE_PVE_DUST_TOXIN)
	target.apply_status_effect(/datum/status_effect/rogue_pve_fae_dust)

/// Ratwood /datum/status_effect/buff/seelie_drugs.
/datum/status_effect/rogue_pve_fae_dust
	id = "rogue_pve_fae_dust"
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null
	tick_interval = STATUS_EFFECT_NO_TICK
	/// Ratwood effectedstats.
	var/list/stats = list(ROGUE_STAT_INTELLIGENCE = 2, ROGUE_STAT_WILLPOWER = 4, ROGUE_STAT_SPEED = -3)

/datum/status_effect/rogue_pve_fae_dust/on_creation(mob/living/new_owner)
	duration = ROGUE_PVE_DUST_TIME
	return ..()

/datum/status_effect/rogue_pve_fae_dust/on_apply()
	owner.attributes?.set_variable_attribute_modifier(id, stats.Copy())
	owner.adjust_drugginess(duration)
	return TRUE

/// Dusted again: the time starts over (TG's refresh would take the type's own, endless, duration).
/datum/status_effect/rogue_pve_fae_dust/refresh(effect, ...)
	duration = ROGUE_PVE_DUST_TIME
	owner.adjust_drugginess(duration)

/datum/status_effect/rogue_pve_fae_dust/on_remove()
	owner.attributes?.remove_attribute_modifier(id)

// Spiders: all of them walk webs; beespiders spin webs and live in nests; the mire lurker and the aragn wrap the fallen.

/mob/living/simple_animal/hostile/retaliate/rogue/spider
	rogue_pve_webwalker = TRUE
	rogue_pve_spins_webs = TRUE
	rogue_pve_nests = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/mirespider
	rogue_pve_webwalker = TRUE

/// Ratwood's lurker only spits (its mind has no melee) and leaves the biting to the mire crawlers that follow it; the
/// crawlers' following is not ported, so here it closes in and bites (its 35-70 bite, "slow attacks, devastating
/// consequences") and spits its glob from two tiles away and further.
/mob/living/simple_animal/hostile/rogue/mirespider_lurker
	rogue_pve_webwalker = TRUE
	rogue_pve_cocoons = TRUE
	rogue_pve_shot = /obj/projectile/rogue_pve/web_glob
	rogue_pve_shot_sound = ROGUE_PVE_SOUND_SPIT
	rogue_pve_shot_cooldown = "pve_lurker_shot_cooldown"
	rogue_pve_shot_style = ROGUE_PVE_SKIRMISHER

/mob/living/simple_animal/hostile/rogue/mirespider_paralytic
	rogue_pve_webwalker = TRUE
	rogue_pve_cocoons = TRUE
