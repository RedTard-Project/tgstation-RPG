#define ROGUE_HATCHET_TWIRL_GRID list(list(-1,-1), list(1,-1, 0.2 SECONDS), list(0,0, 0.4 SECONDS))
#define ROGUE_HATCHET_TWIRL_GRID_MIRROR list(list(-1,-1, 0.4 SECONDS), list(1,-1, 0.2 SECONDS), list(0,0))
#define ROGUE_WARHAMMER_SWING_GRID list(list(0,0), list(-1,0, 0.2 SECONDS), list(-1,-1, 0.4 SECONDS))
#define ROGUE_WARHAMMER_SWING_GRID_MIRROR list(list(0,0, 0.4 SECONDS), list(-1,0, 0.2 SECONDS), list(-1,-1))
#define ROGUE_ARCYNE_RISE_SOURCE "rogue_arcyne_descent"
#define ROGUE_ARCYNE_RISE 16

/// Azure Peak's weapon specials that the module had not (code/modules/mob/living/combat/special_intents.dm), on the
/// special machinery of combat/specials.dm. No Ratwood item carries the first five: Azure Peak gives Hefty Flourish to
/// hatchets, Dazing Swing to warhammers and flanged cudgels, Vicious Swing to the Graggarite greataxe, Hoardbite to the
/// lirvan talon and Aureate Drakkyrcoil to the golden quarterstaff, but Ratwood's hatchets, warhammers and greataxe keep
/// their own specials and the other items are not in Ratwood. Arcyne Descent is Ratwood's too: the porter writes it on
/// Ratwood's tomes. Their numbers are in values.txt like every special's (special_<name>_<field>).

/datum/special_intent/hatchet_twirl
	name = "Hefty Flourish"
	desc = "A defensive flourish that sweeps to the side, before finishing up front. Briefly stuns and exposes the opponent if hit. Always targets the arms."
	post_icon_state = "sweep_fx"
	pre_icon = ROGUE_TELEGRAPH_ICON
	pre_icon_state = "warning"
	respect_adjacency = FALSE
	delay = 0.5 SECONDS
	cooldown = 25 SECONDS
	stamcost = 20
	tunables = list("cooldown", "delay", "stamcost", "bonus", "immob_dur", "exposed_dur", "self_immob_dur")
	var/bonus = 25
	var/immob_dur = 1.5 SECONDS
	var/exposed_dur = 3 SECONDS
	var/self_immob_dur = 0.9 SECONDS
	var/dam

/datum/special_intent/hatchet_twirl/process_attack()
	tile_coordinates = howner.active_hand_index == 1 ? ROGUE_HATCHET_TWIRL_GRID_MIRROR : ROGUE_HATCHET_TWIRL_GRID
	dam = iparent.force * stat_share(ROGUE_STAT_SPEED) + tune("bonus")
	return ..()

/datum/special_intent/hatchet_twirl/on_create()
	howner.Immobilize(tune("self_immob_dur"))
	howner.rogue_delay_action(tune("self_immob_dur"))
	playsound(howner, 'modular_redtard/rockhill/sound/combat/polearm_woosh.ogg', 100, TRUE)

/datum/special_intent/hatchet_twirl/apply_hit(turf/marked)
	for(var/mob/living/victim as anything in victims(marked))
		victim.Immobilize(tune("immob_dur"))
		if(victim.body_position == STANDING_UP)
			weapon_damage(victim, dam, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM), BCLASS_CHOP)
		victim.apply_status_effect(/datum/status_effect/rogue/exposed, tune("exposed_dur"))
	playsound(marked, pick('modular_redtard/rockhill/sound/combat/sp_axe_swing1.ogg', 'modular_redtard/rockhill/sound/combat/sp_axe_swing2.ogg', 'modular_redtard/rockhill/sound/combat/sp_axe_swing3.ogg'), 100, TRUE)

/datum/special_intent/warhammer_swing
	name = "Dazing Swing"
	desc = "A wide strike that swings through the nearest quadrant at a high angle. Briefly dazes and slows the opponent if hit. Always targets the head."
	post_icon_state = "sweep_fx"
	pre_icon = ROGUE_TELEGRAPH_ICON
	pre_icon_state = "warning"
	respect_adjacency = FALSE
	delay = 0.5 SECONDS
	cooldown = 25 SECONDS
	stamcost = 15
	tunables = list("cooldown", "delay", "stamcost", "bonus", "slow_dur", "daze_dur", "daze_perception", "daze_intelligence", "self_immob_dur")
	var/bonus = 25
	var/slow_dur = 3
	var/daze_dur = 5 SECONDS
	var/daze_perception = -2
	var/daze_intelligence = -2
	var/self_immob_dur = 0.9 SECONDS
	var/dam

/datum/special_intent/warhammer_swing/process_attack()
	tile_coordinates = howner.active_hand_index == 1 ? ROGUE_WARHAMMER_SWING_GRID_MIRROR : ROGUE_WARHAMMER_SWING_GRID
	dam = iparent.force * stat_share(ROGUE_STAT_STRENGTH) + tune("bonus")
	return ..()

/datum/special_intent/warhammer_swing/on_create()
	howner.Immobilize(tune("self_immob_dur"))
	howner.rogue_delay_action(tune("self_immob_dur"))
	playsound(howner, 'modular_redtard/rockhill/sound/combat/ground_smash_start.ogg', 100, TRUE)

/datum/special_intent/warhammer_swing/apply_hit(turf/marked)
	for(var/mob/living/victim as anything in victims(marked))
		if(victim.body_position == STANDING_UP)
			weapon_damage(victim, dam, BODY_ZONE_HEAD, BCLASS_BLUNT, no_pen = TRUE)
		victim.apply_status_effect(/datum/status_effect/rogue/dazed, tune("daze_dur"), list(ROGUE_STAT_PERCEPTION = tune("daze_perception"), ROGUE_STAT_INTELLIGENCE = tune("daze_intelligence")))
		victim.rogue_slowdown(tune("slow_dur"))
	playsound(marked, 'modular_redtard/rockhill/sound/combat/flail_sweep_hit_minor.ogg', 100, TRUE)

/// Four swings around the wielder, each wave harder than the one before. Unlike Azure Peak, which counts a wave when it is
/// drawn (so its later hits land with the multiplier of a wave still to come), a hit counts the wave it belongs to.
/datum/special_intent/vicious_swipe
	name = "Vicious Swing"
	desc = "A swing of your blade, in all quadrants. The last two swings expose. Always targets the chest."
	tile_coordinates = list(
		list(-1,0), list(0,0), list(1,0),
		list(-1,-2, 0.4 SECONDS), list(-1,-1, 0.4 SECONDS), list(-1,0, 0.4 SECONDS),
		list(-1,-2, 0.8 SECONDS), list(0,-2, 0.8 SECONDS), list(1,-2, 0.8 SECONDS),
		list(1,-2, 1.2 SECONDS), list(1,-1, 1.2 SECONDS), list(1,0, 1.2 SECONDS),
	)
	post_icon_state = "sweep_fx"
	pre_icon = ROGUE_TELEGRAPH_ICON
	pre_icon_state = "warning"
	sfx_pre_delay = 'modular_redtard/rockhill/sound/combat/wooshes/bladed/wooshlarge (2).ogg'
	sfx_post_delay = 'modular_redtard/rockhill/sound/combat/sp_axe_swing1.ogg'
	respect_adjacency = FALSE
	requires_wielding = TRUE
	delay = 0.7 SECONDS
	cooldown = 20 SECONDS
	stamcost = 30
	tunables = list("cooldown", "delay", "stamcost", "dam", "wave_bonus", "last_share", "slow_dur", "exposed_dur", "self_immob", "self_clickcd", "self_vuln")
	var/dam = 60
	/// Damage share added by every wave after the first (Azure Peak: x1, x1.5, x2, x2.5).
	var/wave_bonus = 0.5
	/// Share of the damage the last wave strikes again at the armor alone.
	var/last_share = 0.8
	var/slow_dur = 2
	var/exposed_dur = 3 SECONDS
	var/self_immob = 2.5 SECONDS
	var/self_clickcd = 3 SECONDS
	var/self_vuln = 3 SECONDS
	/// The waves' turf lists in the order they were drawn, and the number of the wave landing now.
	var/list/waves = list()
	var/landing_wave = 0

/datum/special_intent/vicious_swipe/Destroy(force)
	waves = null
	return ..()

/datum/special_intent/vicious_swipe/on_create()
	waves = list()
	howner.Immobilize(tune("self_immob"))
	howner.apply_status_effect(/datum/status_effect/rogue_vulnerable, tune("self_vuln"))
	howner.rogue_delay_action(tune("self_clickcd"))

/datum/special_intent/vicious_swipe/process_grid(list/turfs, hit_delay)
	waves += list(turfs)
	return ..()

/datum/special_intent/vicious_swipe/post_delay(list/turfs)
	landing_wave = max(waves.Find(turfs), 1)
	. = ..()
	playsound(howner, 'modular_redtard/rockhill/sound/combat/wooshes/bladed/wooshlarge (3).ogg', 100, TRUE)

/datum/special_intent/vicious_swipe/apply_hit(turf/marked)
	var/total_waves = length(affected_turfs)
	for(var/mob/living/victim as anything in victims(marked))
		victim.rogue_slowdown(tune("slow_dur"))
		if(victim.body_position != STANDING_UP)
			continue
		weapon_damage(victim, tune("dam") * (1 + (landing_wave - 1) * tune("wave_bonus")), BODY_ZONE_CHEST, BCLASS_CUT)
		if(landing_wave >= total_waves)
			weapon_damage(victim, tune("dam") * tune("last_share"), BODY_ZONE_CHEST, BCLASS_CUT, no_pen = TRUE)
		if(landing_wave >= total_waves - 1)
			victim.apply_status_effect(/datum/status_effect/rogue/exposed, tune("exposed_dur"))
		playsound(marked, 'modular_redtard/rockhill/sound/combat/sp_gsword_hit.ogg', 100, TRUE)

/datum/special_intent/drakkyrmaw_bite
	name = "Drakkyrmaw: Hoardbite"
	desc = "The golden maw snaps shut in a four-pace bite-line. Bite marks appear one-by-one before the whole line activates at once. Victims are dragged closer, exposed, and burned. Always targets the aimed zone."
	tile_coordinates = list(list(0,0), list(0,1, 0.15 SECONDS), list(0,2, 0.3 SECONDS), list(0,3, 0.45 SECONDS))
	pre_icon_state = "bite"
	post_icon_state = "bite"
	respect_adjacency = FALSE
	delay = 0.85 SECONDS
	custom_delays = list(0.85 SECONDS, 0.7 SECONDS, 0.55 SECONDS, 0.4 SECONDS)
	cooldown = 30 SECONDS
	stamcost = 20
	tunables = list("cooldown", "delay", "stamcost", "dam", "fire_stacks", "slow_dur", "exposed_dur", "self_immob_dur")
	/// Azure Peak's bite only burns, drags and exposes: no weapon damage.
	var/dam = 0
	var/fire_stacks = 2
	var/slow_dur = 3
	var/exposed_dur = 3 SECONDS
	var/self_immob_dur = 0.9 SECONDS

/datum/special_intent/drakkyrmaw_bite/on_create()
	howner.Immobilize(tune("self_immob_dur"))
	howner.rogue_delay_action(tune("self_immob_dur"))
	playsound(howner, 'modular_redtard/rockhill/sound/combat/rend_start.ogg', 100, TRUE)
	to_chat(howner, span_warning("YOU KNOW WHAT TO DO."))

/datum/special_intent/drakkyrmaw_bite/apply_hit(turf/marked)
	for(var/mob/living/victim as anything in victims(marked))
		victim.rogue_slowdown(tune("slow_dur"))
		victim.adjust_fire_stacks(tune("fire_stacks"))
		victim.ignite_mob()
		fling(victim, get_step_towards(victim, howner), 1)
		if(victim.body_position == STANDING_UP && tune("dam") > 0)
			weapon_damage(victim, tune("dam"), aimed_zone(victim), BCLASS_BITE, full_pen = TRUE)
		victim.apply_status_effect(/datum/status_effect/rogue/exposed, tune("exposed_dur"))
	playsound(marked, pick('modular_redtard/rockhill/sound/combat/sp_axe_swing1.ogg', 'modular_redtard/rockhill/sound/combat/sp_axe_swing2.ogg', 'modular_redtard/rockhill/sound/combat/sp_axe_swing3.ogg'), 100, TRUE)

/datum/special_intent/gilded_dragon_sweep
	name = "Aureate Drakkyrcoil"
	desc = "I spin my heavy golden staff thrice in front of me. The first sweep batters foes aside; the returning coil scorches and off-balances them. Always targets the chest."
	tile_coordinates = list(
		list(-1,0), list(0,0), list(1,0),
		list(-1,1, 0.45 SECONDS), list(0,1, 0.45 SECONDS), list(1,1, 0.45 SECONDS),
		list(-1,0, 0.9 SECONDS), list(0,0, 0.9 SECONDS), list(1,0, 0.9 SECONDS),
	)
	post_icon_state = "sweep_fx"
	pre_icon_state = "fx_trap_long"
	sfx_pre_delay = 'modular_redtard/rockhill/sound/combat/polearm_woosh.ogg'
	sfx_post_delay = 'modular_redtard/rockhill/sound/combat/ground_smash2.ogg'
	respect_adjacency = FALSE
	requires_wielding = TRUE
	delay = 0.45 SECONDS
	cooldown = 30 SECONDS
	stamcost = 25
	tunables = list("cooldown", "delay", "stamcost", "fire_stacks", "slow_dur", "exposed_dur", "self_immob_dur")
	var/fire_stacks = 2
	/// Slowdown steps; Azure Peak passes 2 SECONDS to a proc that counts life ticks, read here as 2 steps.
	var/slow_dur = 2
	var/exposed_dur = 3 SECONDS
	var/self_immob_dur = 1.2 SECONDS
	var/dam

/datum/special_intent/gilded_dragon_sweep/process_attack()
	dam = iparent.force * max(stat_share(ROGUE_STAT_STRENGTH), 0.5)
	return ..()

/datum/special_intent/gilded_dragon_sweep/on_create()
	howner.Immobilize(tune("self_immob_dur"))
	howner.rogue_delay_action(tune("self_immob_dur"))
	to_chat(howner, span_warning("SAMSARA; COVETOUS COIL, WEALTH-TO-PAIN."))

/datum/special_intent/gilded_dragon_sweep/apply_hit(turf/marked)
	for(var/mob/living/victim as anything in victims(marked))
		fling(victim, get_ranged_target_turf(get_turf(victim), get_dir(howner, victim), 1), 1)
		victim.rogue_slowdown(tune("slow_dur"))
		victim.adjust_fire_stacks(tune("fire_stacks"))
		victim.ignite_mob()
		weapon_damage(victim, dam, BODY_ZONE_CHEST, BCLASS_BLUNT, no_pen = TRUE)
		victim.apply_status_effect(/datum/status_effect/rogue/exposed, tune("exposed_dur"))

/// The tome's finisher (Azure Peak and Ratwood): an upper cut from above. The wielder rises and crashes down on the tile
/// ahead; an exposed or vulnerable target falls, is flung back and takes the finisher's damage in the head.
/datum/special_intent/arcyne_descent
	name = "Arcyne Descent"
	desc = "Rise with arcyne force, then crash down on the target. If the target is Exposed or Vulnerable, they will fall over and be flung back with tremendous damage; otherwise they are pushed slightly back."
	tile_coordinates = list(list(0,0))
	post_icon_state = "kick_fx"
	pre_icon = ROGUE_TELEGRAPH_ICON
	pre_icon_state = "warning"
	delay = 1.2 SECONDS
	cooldown = 30 SECONDS
	stamcost = 25
	tunables = list("cooldown", "delay", "stamcost", "knockdown_dur", "self_immob_dur", "dam", "finisher_dam")
	var/knockdown_dur = 1 SECONDS
	var/self_immob_dur = 1.5 SECONDS
	var/dam = 50
	var/finisher_dam = 200

/datum/special_intent/arcyne_descent/on_create()
	howner.rogue_off_balance(tune("self_immob_dur"))
	howner.Immobilize(tune("self_immob_dur"))
	howner.visible_message(span_warning("[howner] rises on a surge of arcyne force!"), span_warning("I rise on a surge of arcyne force!"))
	playsound(howner, 'modular_redtard/combat/sound/magic/charging.ogg', 100, TRUE)
	howner.add_offsets(ROGUE_ARCYNE_RISE_SOURCE, z_add = ROGUE_ARCYNE_RISE)
	addtimer(CALLBACK(src, PROC_REF(land), howner), tune("delay") + fade_delay)

/// Brings the wielder back down: on the hit, or after it if the manoeuvre was cancelled.
/datum/special_intent/arcyne_descent/proc/land(mob/living/riser)
	if(!QDELETED(riser))
		riser.remove_offsets(ROGUE_ARCYNE_RISE_SOURCE)

/datum/special_intent/arcyne_descent/apply_hit(turf/marked)
	land(howner)
	playsound(marked, 'modular_redtard/combat/sound/magic/whiteflame.ogg', 100, TRUE)
	for(var/mob/living/victim as anything in victims(marked))
		var/distance = 1
		var/damage = tune("dam")
		var/zone = aimed_zone(victim)
		if(victim.rogue_is_open())
			victim.Knockdown(tune("knockdown_dur"))
			distance = rand(2, 4)
			damage = tune("finisher_dam")
			zone = BODY_ZONE_HEAD
			playsound(howner, 'modular_redtard/combat/sound/misc/meteorimpact.ogg', 100, TRUE)
			victim.remove_status_effect(/datum/status_effect/rogue/exposed)
			victim.remove_status_effect(/datum/status_effect/rogue_vulnerable)
		weapon_damage(victim, damage, zone, BCLASS_BLUNT, no_pen = TRUE)
		fling(victim, get_edge_target_turf(howner, get_dir(howner, victim)), distance)
		playsound(howner, 'modular_redtard/rockhill/sound/combat/hits/punch/punch_hard (2).ogg', 100, TRUE)

/// Azure Peak's dazed debuff (a Dazing Swing): perception and intelligence down for a few seconds.
/datum/status_effect/rogue/dazed
	id = "rogue_dazed"
	alert_type = /atom/movable/screen/alert/status_effect/rogue/intent_debuff
	var/list/stats

/datum/status_effect/rogue/dazed/on_creation(mob/living/new_owner, set_duration, list/stats)
	src.stats = stats
	return ..(new_owner, set_duration)

/datum/status_effect/rogue/dazed/on_apply()
	. = ..()
	if(length(stats))
		owner.attributes?.set_variable_attribute_modifier(id, stats.Copy())

/datum/status_effect/rogue/dazed/on_remove()
	owner.attributes?.remove_attribute_modifier(id)
	return ..()

#undef ROGUE_HATCHET_TWIRL_GRID
#undef ROGUE_HATCHET_TWIRL_GRID_MIRROR
#undef ROGUE_WARHAMMER_SWING_GRID
#undef ROGUE_WARHAMMER_SWING_GRID_MIRROR
#undef ROGUE_ARCYNE_RISE_SOURCE
#undef ROGUE_ARCYNE_RISE
