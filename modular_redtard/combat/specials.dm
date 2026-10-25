#define ROGUE_SPECIAL_TIMER_INDEX 3
#define ROGUE_SPECIAL_RING list(list(0,0), list(1,0), list(1,-1), list(1,-2), list(0,-2), list(-1,-2), list(-1,-1), list(-1,0))

/obj/item
	var/special
	var/datum/special_intent/special_instance

/obj/item/Destroy(force)
	QDEL_NULL(special_instance)
	return ..()

/obj/item/proc/rogue_special()
	if(!ispath(special, /datum/special_intent))
		return null
	if(!special_instance)
		special_instance = new special
	return special_instance

/mob/living/carbon/human
	var/datum/special_intent/rogue_unarmed_special

/mob/living/carbon/human/Destroy()
	QDEL_NULL(rogue_unarmed_special)
	return ..()

/mob/living/carbon/human/proc/rogue_fist_special()
	if(!rogue_unarmed_special)
		rogue_unarmed_special = new /datum/special_intent/upper_cut
	return rogue_unarmed_special

/obj/effect/temp_visual/rogue_special
	icon = ROGUE_SPECIAL_FX_ICON
	icon_state = "blip"
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_GAME_PLANE
	duration = 1 SECONDS

/obj/effect/temp_visual/rogue_special/Initialize(mapload, set_duration)
	if(set_duration)
		duration = set_duration
	return ..()

/mob/living/carbon/human/proc/rogue_use_special(atom/target)
	if(incapacitated || has_status_effect(/datum/status_effect/rogue/special_cooldown))
		return FALSE
	var/obj/item/weapon = get_active_held_item()
	var/datum/special_intent/active = weapon ? weapon.rogue_special() : rogue_fist_special()
	if(!active)
		return FALSE
	if((weapon ? rogue_weapon_rank(weapon) : rogue_skill_rank(/datum/attribute/skill/combat/unarmed)) < ROGUE_SPECIAL_RANK)
		to_chat(src, span_info("I'm not knowledgeable enough in the arts of this weapon to use this."))
		return FALSE
	face_atom(target)
	if(!active.check_range(src, target) || (weapon && !active.check_reqs(src, weapon)) || !active.apply_cost(src))
		return FALSE
	rogue_mark_in_combat()
	SEND_SIGNAL(src, COMSIG_ROGUE_MANOEUVRE, ROGUE_MANOEUVRE_SPECIAL)
	active.deploy(src, weapon || src, target)
	return TRUE

/datum/special_intent
	var/name = "special intent"
	var/desc = "desc"
	var/mob/living/carbon/human/howner
	var/obj/item/iparent
	var/list/tile_coordinates
	var/list/affected_turfs = list()
	var/requires_wielding = FALSE
	var/use_clickloc = FALSE
	var/respect_dir = TRUE
	var/turf/click_loc
	var/cooldown = 30 SECONDS
	var/range = 0
	var/stamcost = 0
	var/cancelled = FALSE
	var/delay = 1 SECONDS
	var/list/custom_delays = list()
	var/fade_delay = 0.5 SECONDS
	var/respect_adjacency = TRUE
	var/sfx_pre_delay
	var/sfx_post_delay
	var/pre_icon = ROGUE_SPECIAL_FX_ICON
	var/pre_icon_state = "blip"
	var/post_icon_state = "strike"
	var/list/tunables = list("cooldown", "delay", "stamcost")

/datum/special_intent/Destroy(force)
	howner = null
	iparent = null
	click_loc = null
	affected_turfs = null
	return ..()

/datum/special_intent/proc/value_key()
	return "special_[replacetext(copytext("[type]", length("/datum/special_intent/") + 1), "/", "_")]"

/datum/special_intent/proc/tune(var_name)
	return rogue_value_or("[value_key()]_[var_name]", vars[var_name])

/datum/special_intent/proc/apply_cost(mob/living/user)
	var/cost = tune("stamcost")
	if(!cost)
		return TRUE
	var/spent = cost < 1 ? user.max_stamina * cost : cost
	if(user.get_stamina_loss() + spent >= user.max_stamina)
		to_chat(user, span_warning("I'm too tired for that!"))
		return FALSE
	user.adjust_stamina_loss(spent)
	return TRUE

/datum/special_intent/proc/check_range(atom/source, atom/target)
	var/max_range = tune("range")
	if(max_range && (get_dist(get_turf(source), get_turf(target)) > max_range || source.z != target.z))
		to_chat(source, span_warning("It's too far!"))
		return FALSE
	return TRUE

/datum/special_intent/proc/check_reqs(mob/living/carbon/human/user, obj/item/weapon)
	if(!requires_wielding)
		return TRUE
	if(!length(weapon.gripped_intents) && !weapon.rogue_force_wielded)
		return TRUE
	if(weapon.rogue_wielded)
		return TRUE
	to_chat(user, span_warning("I need to be wielding the weapon in both hands!"))
	return FALSE

/datum/special_intent/proc/get_examine()
	return "<details><summary><b>SPECIAL:</b> [name]</summary><i>[desc]</i>[tune("range") ? "\n<i>Max Range: [tune("range")]</i>" : ""][requires_wielding ? "\n<i>Requires wielding if the weapon can be held in two hands.</i>" : ""]\n<i>Right click in the STRONG stance or use the Special middle-click to use it.</i></details>"

/datum/special_intent/proc/deploy(mob/living/carbon/human/user, obj/item/parent, atom/target)
	howner = user
	iparent = parent
	click_loc = use_clickloc ? get_turf(target) : null
	if(use_clickloc && !click_loc)
		return
	process_attack()

/datum/special_intent/proc/process_attack()
	SHOULD_CALL_PARENT(TRUE)
	cancelled = FALSE
	respect_adjacency = initial(respect_adjacency)
	affected_turfs = list()
	log_combat(howner, howner, "used the special [name] of", iparent)
	create_grid()
	on_create()
	manage_grid()
	howner.apply_status_effect(/datum/status_effect/rogue/special_cooldown, tune("cooldown"))

/datum/special_intent/proc/rotate(dx, dy)
	if(!respect_dir)
		return list(dx, dy)
	switch(howner.dir)
		if(SOUTH)
			return list(-dx, -dy)
		if(WEST)
			return list(-dy, dx)
		if(EAST)
			return list(dy, -dx)
	return list(dx, dy)

/datum/special_intent/proc/create_grid()
	var/turf/origin = use_clickloc ? click_loc : get_step(get_turf(howner), howner.dir)
	if(!origin)
		return
	for(var/list/coordinate in tile_coordinates)
		var/list/rotated = rotate(coordinate[1], coordinate[2])
		var/turf/step = locate(origin.x + rotated[1], origin.y + rotated[2], origin.z)
		if(!step || step.density)
			continue
		var/wave_delay = LAZYACCESS(coordinate, ROGUE_SPECIAL_TIMER_INDEX) || 0
		var/key = "[wave_delay]"
		if(!affected_turfs[key])
			affected_turfs[key] = list()
		var/list/wave = affected_turfs[key]
		wave += step

/datum/special_intent/proc/manage_grid()
	var/wave_index = 0
	for(var/key in affected_turfs)
		wave_index++
		var/wave_delay = text2num(key)
		var/hit_delay = LAZYACCESS(custom_delays, wave_index) || tune("delay")
		if(wave_delay)
			addtimer(CALLBACK(src, PROC_REF(process_grid), affected_turfs[key], hit_delay), wave_delay)
		else
			process_grid(affected_turfs[key], hit_delay)

/datum/special_intent/proc/process_grid(list/turfs, hit_delay)
	if(cancelled || QDELETED(howner))
		return
	for(var/turf/marked as anything in turfs)
		var/obj/effect/temp_visual/rogue_special/marker = new(marked, hit_delay)
		marker.icon = pre_icon
		marker.icon_state = pre_icon_state
	pre_delay(turfs)
	addtimer(CALLBACK(src, PROC_REF(post_delay), turfs), hit_delay)

/datum/special_intent/proc/on_create()
	return

/datum/special_intent/proc/pre_delay(list/turfs)
	if(sfx_pre_delay)
		playsound(howner, sfx_pre_delay, 100, TRUE)

/datum/special_intent/proc/post_delay(list/turfs)
	SHOULD_CALL_PARENT(TRUE)
	if(cancelled || QDELETED(howner) || !length(turfs))
		return
	if(respect_adjacency)
		var/adjacent = FALSE
		for(var/turf/marked as anything in turfs)
			if(howner.Adjacent(marked))
				adjacent = TRUE
				respect_adjacency = FALSE
				break
		if(!adjacent)
			to_chat(howner, span_danger("I moved too far from my manoeuvre!"))
			cancelled = TRUE
			return
	for(var/turf/marked as anything in turfs)
		if(post_icon_state)
			var/obj/effect/temp_visual/rogue_special/flash = new(marked, fade_delay)
			flash.icon_state = post_icon_state
		apply_hit(marked)
	if(sfx_post_delay)
		playsound(howner, sfx_post_delay, 100, TRUE)

/datum/special_intent/proc/apply_hit(turf/marked)
	return

/datum/special_intent/proc/victims(turf/marked)
	. = list()
	for(var/mob/living/victim in marked)
		if(victim != howner)
			. += victim

/datum/special_intent/proc/aimed_zone(mob/living/target)
	var/obj/item/weapon = isitem(iparent) ? iparent : null
	return howner.rogue_strike_zone(target, weapon, howner.rogue_strike_intent(weapon))

/datum/special_intent/proc/stat_share(stat_type)
	return howner.rogue_stat(stat_type) / ROGUE_ATTRIBUTE_MIDDLING

/datum/special_intent/proc/weapon_damage(mob/living/target, damage, zone, blade_class, no_pen = FALSE, full_pen = FALSE)
	var/obj/item/weapon = isitem(iparent) ? iparent : null
	if((!weapon && iparent != howner) || QDELETED(target))
		return 0
	damage *= ROGUE_SPECIAL_DAMAGE_FACTOR
	var/def_zone = rogue_zone_target(zone)
	if(ishuman(target) && no_pen && !full_pen)
		var/mob/living/carbon/human/armored = target
		var/obj/item/clothing/worn = armored.rogue_best_armor(def_zone, rogue_bclass_to_armor(blade_class))
		if(worn)
			worn.take_damage(damage, BRUTE, "", FALSE)
			howner.visible_message(span_warning("[name] strikes [target]'s [rogue_zone_name(zone)], but [worn] takes the blow!"))
			return 0
	var/old_class
	if(weapon)
		old_class = weapon.rogue_current_bclass
		weapon.rogue_current_bclass = blade_class
	var/blocked = full_pen ? 0 : target.run_armor_check(def_zone, MELEE, armour_penetration = weapon?.armour_penetration, silent = TRUE)
	if(!weapon && !full_pen && ishuman(target))
		var/mob/living/carbon/human/armored = target
		blocked += armored.rogue_armor_protection(def_zone, rogue_bclass_to_armor(blade_class), 0)
	blocked = min(blocked, ARMOR_MAX_BLOCK)
	var/damage_done = target.apply_damage(damage, weapon ? weapon.damtype : BRUTE, def_zone, blocked, sharpness = rogue_bclass_sharpness(blade_class), attack_direction = get_dir(howner, target), attacking_item = full_pen ? null : weapon)
	if(weapon)
		weapon.rogue_current_bclass = old_class
	howner.visible_message(span_danger("<font color='#c2663c'>[name] strikes [target] in the [rogue_zone_name(zone)]![damage_done > 0 && full_pen ? " <b>It pierces through to their flesh!</b>" : ""]</font>"))
	var/hit_sound = weapon ? weapon.hitsound : pick(GLOB.rogue_punch_hit_sounds)
	if(damage_done > 0 && hit_sound)
		playsound(target, hit_sound, 80, TRUE)
	if(damage_done > 0)
		target.rogue_try_crit(blade_class, damage_done, howner, zone)
	target.rogue_pop_open()
	log_combat(howner, target, "struck with the special [name]", weapon || "fists", "(DAMAGE: [damage_done])")
	return damage_done

/datum/special_intent/proc/fling(mob/living/victim, turf/destination, distance)
	if(!victim.anchored && destination)
		victim.safe_throw_at(destination, distance, 1, howner, force = MOVE_FORCE_EXTREMELY_STRONG)

/datum/special_intent/proc/knock_off_balance(mob/living/victim, duration)
	if(ishuman(victim))
		var/mob/living/carbon/human/human_victim = victim
		human_victim.rogue_off_balance(duration)

/datum/special_intent/proc/is_off_balance(mob/living/victim)
	if(!ishuman(victim))
		return FALSE
	var/mob/living/carbon/human/human_victim = victim
	return human_victim.rogue_offbalanced(FALSE)

/datum/special_intent/side_sweep
	name = "Distracting Swipe"
	desc = "Swings at your primary flank in a distracting fashion. Anyone caught in it will be exposed for a short while. Aims for the targeted zone."
	tile_coordinates = list(list(0,0), list(1,0), list(1,-1))
	post_icon_state = "sweep_fx"
	pre_icon = ROGUE_TELEGRAPH_ICON
	pre_icon_state = "warning"
	sfx_post_delay = 'modular_redtard/rockhill/sound/combat/sidesweep_hit.ogg'
	delay = 0.6 SECONDS
	cooldown = 17 SECONDS
	requires_wielding = TRUE
	stamcost = 25
	tunables = list("cooldown", "delay", "stamcost", "eff_dur")
	var/eff_dur = 4 SECONDS
	var/dam = 20

/datum/special_intent/side_sweep/process_attack()
	tile_coordinates = howner.active_hand_index == 1 ? list(list(0,0), list(-1,0), list(-1,-1)) : list(list(0,0), list(1,0), list(1,-1))
	dam = iparent.force * max(howner.rogue_stat(ROGUE_STAT_STRENGTH), howner.rogue_stat(ROGUE_STAT_SPEED), howner.rogue_stat(ROGUE_STAT_PERCEPTION)) / ROGUE_ATTRIBUTE_MIDDLING
	return ..()

/datum/special_intent/side_sweep/apply_hit(turf/marked)
	for(var/mob/living/victim as anything in victims(marked))
		if(victim.body_position == STANDING_UP)
			weapon_damage(victim, dam, aimed_zone(victim), BCLASS_CUT)
			victim.apply_status_effect(/datum/status_effect/rogue/exposed, tune("eff_dur"))

/datum/special_intent/shin_swipe
	name = "Shin Prod"
	desc = "A hasty attack at the legs, extending ourselves. Slows down the opponent if hit. Always targets the legs."
	tile_coordinates = list(list(0,0), list(1,0), list(-1,0))
	post_icon_state = "sweep_fx"
	pre_icon = ROGUE_TELEGRAPH_ICON
	pre_icon_state = "warning"
	sfx_post_delay = 'modular_redtard/rockhill/sound/combat/shin_swipe.ogg'
	delay = 0.5 SECONDS
	cooldown = 20 SECONDS
	stamcost = 15
	tunables = list("cooldown", "delay", "stamcost", "eff_dur", "hobble_dur", "open_dur")
	var/eff_dur = 5
	var/hobble_dur = 4
	var/open_dur = 3 SECONDS
	var/dam

/datum/special_intent/shin_swipe/process_attack()
	dam = iparent.force * max(1 + ((stat_share(ROGUE_STAT_SPEED) - 1) + (stat_share(ROGUE_STAT_PERCEPTION) - 1)), 0.1)
	return ..()

/datum/special_intent/shin_swipe/apply_hit(turf/marked)
	for(var/mob/living/victim as anything in victims(marked))
		victim.rogue_slowdown(tune("eff_dur") + tune("hobble_dur"))
		if(victim.body_position == STANDING_UP)
			weapon_damage(victim, dam, pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG), BCLASS_CUT)
		victim.rogue_open(tune("open_dur"))

/datum/special_intent/piercing_lunge
	name = "Piercing Lunge"
	desc = "A planned thrust forward, extending ourselves. Pierces our enemy's armor and knocks the wind from them. Aims for the targeted zone."
	tile_coordinates = list(list(0,0), list(0,1))
	post_icon_state = "stab"
	pre_icon = ROGUE_TELEGRAPH_ICON
	pre_icon_state = "warning"
	sfx_post_delay = 'modular_redtard/rockhill/sound/combat/parry/bladed/bladedsmall (3).ogg'
	delay = 0.5 SECONDS
	cooldown = 25 SECONDS
	stamcost = 20
	tunables = list("cooldown", "delay", "stamcost", "winded", "open_dur")
	var/winded = 30
	var/open_dur = 3 SECONDS
	var/dam

/datum/special_intent/piercing_lunge/process_attack()
	dam = iparent.force * max(1 + ((stat_share(ROGUE_STAT_SPEED) - 1) + (stat_share(ROGUE_STAT_PERCEPTION) - 1)), 0.1)
	return ..()

/datum/special_intent/piercing_lunge/apply_hit(turf/marked)
	for(var/mob/living/victim as anything in victims(marked))
		victim.adjust_stamina_loss(tune("winded"))
		if(victim.body_position == STANDING_UP)
			weapon_damage(victim, dam, aimed_zone(victim), BCLASS_STAB, full_pen = TRUE)
		victim.rogue_open(tune("open_dur"))

/datum/special_intent/ground_smash
	name = "Ground Smash"
	desc = "Swings downward, leaving a traveling quake for a few tiles. Anyone struck by it will be slowed and off-balanced, or knocked down if they're already off-balanced. Always targets the chest."
	tile_coordinates = list(list(0,0), list(0,1, 0.1 SECONDS), list(0,2, 0.2 SECONDS))
	post_icon_state = "kick_fx"
	pre_icon = ROGUE_TELEGRAPH_ICON
	pre_icon_state = "warning"
	requires_wielding = TRUE
	delay = 0.7 SECONDS
	cooldown = 25 SECONDS
	stamcost = 25
	tunables = list("cooldown", "delay", "stamcost", "slow_dur", "knockdown_dur", "offbalance_dur", "self_immob_dur", "dam", "open_dur")
	var/slow_dur = 5
	var/knockdown_dur = 2 SECONDS
	var/offbalance_dur = 5 SECONDS
	var/self_immob_dur = 1.1 SECONDS
	var/dam = 200
	var/open_dur = 2.5 SECONDS

/datum/special_intent/ground_smash/on_create()
	howner.Immobilize(tune("self_immob_dur"))
	playsound(howner, 'modular_redtard/rockhill/sound/combat/ground_smash_start.ogg', 100, TRUE)

/datum/special_intent/ground_smash/apply_hit(turf/marked)
	for(var/mob/living/victim as anything in victims(marked))
		var/distance = rand(1, 3)
		fling(victim, get_ranged_target_turf(victim, turn(get_dir(victim, howner), pick(90, 270)), distance), distance)
		victim.rogue_slowdown(tune("slow_dur"))
		if(is_off_balance(victim))
			victim.Knockdown(tune("knockdown_dur"))
			victim.drop_all_held_items()
		else
			knock_off_balance(victim, tune("offbalance_dur"))
		weapon_damage(victim, tune("dam"), BODY_ZONE_CHEST, BCLASS_BLUNT, no_pen = TRUE)
		victim.apply_status_effect(/datum/status_effect/rogue/exposed, tune("open_dur"))
	playsound(marked, pick('modular_redtard/rockhill/sound/combat/ground_smash1.ogg', 'modular_redtard/rockhill/sound/combat/ground_smash2.ogg', 'modular_redtard/rockhill/sound/combat/ground_smash3.ogg'), 100, TRUE)

/datum/special_intent/flail_sweep
	name = "Flail Sweep"
	desc = "Swings in a perfect circle all around you, pushing people aside. The more are struck, the more powerful the effect. Always targets the chest."
	tile_coordinates = ROGUE_SPECIAL_RING
	post_icon_state = "sweep_fx"
	pre_icon = ROGUE_TELEGRAPH_ICON
	pre_icon_state = "warning"
	sfx_pre_delay = 'modular_redtard/rockhill/sound/combat/flail_sweep.ogg'
	respect_adjacency = FALSE
	delay = 0.7 SECONDS
	cooldown = 25 SECONDS
	tunables = list("cooldown", "delay", "stamcost", "slow_init", "exposed_init", "offbalance_init", "knockdown", "immobilize_init", "dam")
	var/slow_init = 2
	var/exposed_init = 3 SECONDS
	var/offbalance_init = 1.5 SECONDS
	var/knockdown = 2 SECONDS
	var/immobilize_init = 1 SECONDS
	var/dam = 20
	var/list/swept = list()

/datum/special_intent/flail_sweep/on_create()
	swept = list()
	howner.Immobilize(tune("delay"))
	howner.rogue_delay_action(tune("delay"))

/datum/special_intent/flail_sweep/apply_hit(turf/marked)
	for(var/mob/living/victim as anything in victims(marked))
		if(victim.body_position == STANDING_UP)
			swept |= victim

/datum/special_intent/flail_sweep/post_delay(list/turfs)
	. = ..()
	var/count = length(swept)
	for(var/mob/living/victim as anything in swept)
		sweep_effect(victim, count, TRUE)
	swept = list()

/datum/special_intent/flail_sweep/proc/sweep_effect(mob/living/victim, count, with_damage)
	if(QDELETED(victim) || !count)
		return
	if(with_damage)
		weapon_damage(victim, tune("dam") * count, BODY_ZONE_CHEST, BCLASS_BLUNT, no_pen = TRUE)
	victim.rogue_slowdown(tune("slow_init") + count)
	if(count >= 2)
		victim.Immobilize(tune("immobilize_init") + count SECONDS)
		victim.apply_status_effect(/datum/status_effect/rogue/exposed, tune("exposed_init") + count SECONDS)
	if(count >= 3)
		victim.Knockdown(tune("knockdown"))
		victim.drop_all_held_items()
	if(count >= 5)
		knock_off_balance(victim, tune("offbalance_init") + count SECONDS)
		victim.Stun(5 SECONDS)
	playsound(howner, count < 3 ? 'modular_redtard/rockhill/sound/combat/flail_sweep_hit_minor.ogg' : 'modular_redtard/rockhill/sound/combat/flail_sweep_hit_major.ogg', 100, TRUE)
	fling(victim, get_edge_target_turf(howner, get_dir(howner, victim)), clamp(count, 1, 5))

/datum/special_intent/axe_swing
	name = "Hefty Swing"
	desc = "Swings from left to right. Anyone caught in the swing get immobilized and exposed. Always targets the legs."
	post_icon_state = "sweep_fx"
	pre_icon = ROGUE_TELEGRAPH_ICON
	pre_icon_state = "warning"
	requires_wielding = TRUE
	respect_adjacency = FALSE
	delay = 0.5 SECONDS
	cooldown = 25 SECONDS
	stamcost = 15
	tunables = list("cooldown", "delay", "stamcost", "immob_dur", "exposed_dur", "bonus")
	var/immob_dur = 3.5 SECONDS
	var/exposed_dur = 6 SECONDS
	var/bonus = 50
	var/dam

/datum/special_intent/axe_swing/process_attack()
	tile_coordinates = howner.active_hand_index == 1 ? list(list(-1,0, 4), list(0,0, 2), list(1,0)) : list(list(-1,0), list(0,0, 2), list(1,0, 4))
	dam = iparent.force * stat_share(ROGUE_STAT_STRENGTH) + tune("bonus")
	return ..()

/datum/special_intent/axe_swing/on_create()
	howner.Immobilize(0.9 SECONDS)
	howner.rogue_delay_action(0.9 SECONDS)
	playsound(howner, 'modular_redtard/rockhill/sound/combat/rend_start.ogg', 100, TRUE)

/datum/special_intent/axe_swing/apply_hit(turf/marked)
	for(var/mob/living/victim as anything in victims(marked))
		victim.Immobilize(tune("immob_dur"))
		if(victim.body_position == STANDING_UP)
			weapon_damage(victim, dam, pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG), BCLASS_CHOP)
		victim.apply_status_effect(/datum/status_effect/rogue/exposed, tune("exposed_dur"))
	playsound(marked, pick('modular_redtard/rockhill/sound/combat/sp_axe_swing1.ogg', 'modular_redtard/rockhill/sound/combat/sp_axe_swing2.ogg', 'modular_redtard/rockhill/sound/combat/sp_axe_swing3.ogg'), 100, TRUE)

/datum/special_intent/whip_coil
	name = "Whip Coil"
	desc = "A long-range lash that coils around the ankles of the target, immobilizing them. Always targets the feet."
	tile_coordinates = list(list(0,0))
	post_icon_state = "strike"
	pre_icon = ROGUE_TELEGRAPH_ICON
	pre_icon_state = "warning"
	sfx_pre_delay = 'modular_redtard/rockhill/sound/combat/sp_whip_start.ogg'
	respect_adjacency = FALSE
	use_clickloc = TRUE
	delay = 0.4 SECONDS
	cooldown = 15 SECONDS
	range = 4
	stamcost = 20
	tunables = list("cooldown", "delay", "stamcost", "range", "immob_dur", "dam", "open_dur")
	var/immob_dur = 3.5 SECONDS
	var/dam = 30
	var/open_dur = 2 SECONDS

/datum/special_intent/whip_coil/apply_hit(turf/marked)
	var/list/caught = victims(marked)
	for(var/mob/living/victim as anything in caught)
		victim.Immobilize(tune("immob_dur"))
		weapon_damage(victim, tune("dam"), pick("l_foot", "r_foot"), BCLASS_LASHING)
		victim.rogue_open(tune("open_dur"))
	playsound(marked, length(caught) ? 'modular_redtard/rockhill/sound/combat/sp_whip_hit.ogg' : 'modular_redtard/rockhill/sound/combat/sp_whip_whiff.ogg', 100, TRUE)

/datum/special_intent/greatsword_swing
	name = "Great Swing"
	desc = "Swing your greatsword all around you in a ring of Judgement. Always targets the chest."
	tile_coordinates = list(
		list(0,0), list(1,0), list(1,-1), list(1,-2), list(0,-2), list(-1,-2), list(-1,-1), list(-1,0),
		list(0,1, 10), list(1,1, 10), list(-1,1, 10), list(1,-3, 10), list(0,-3, 10), list(-1,-3, 10), list(-2,0, 10), list(-2,-1, 10), list(-2,-2, 10), list(2,0, 10), list(2,-1, 10), list(2,-2, 10),
		list(0,0, 17), list(1,0, 17), list(1,-1, 17), list(1,-2, 17), list(0,-2, 17), list(-1,-2, 17), list(-1,-1, 17), list(-1,0, 17),
	)
	post_icon_state = "sweep_fx"
	pre_icon_state = "fx_trap_long"
	sfx_pre_delay = 'modular_redtard/rockhill/sound/combat/rend_hit.ogg'
	respect_adjacency = FALSE
	delay = 0.7 SECONDS
	cooldown = 30 SECONDS
	requires_wielding = TRUE
	custom_delays = list(1 SECONDS)
	stamcost = 25
	tunables = list("cooldown", "delay", "stamcost", "dam", "slow_dur", "self_immob", "self_clickcd", "self_vuln")
	var/dam = 60
	var/slow_dur = 2
	var/self_immob = 2.5 SECONDS
	var/self_clickcd = 3 SECONDS
	var/self_vuln = 3 SECONDS
	var/hitcount = 0

/datum/special_intent/greatsword_swing/on_create()
	hitcount = 0
	howner.Immobilize(tune("self_immob"))
	howner.apply_status_effect(/datum/status_effect/rogue_vulnerable, tune("self_vuln"))
	howner.rogue_delay_action(tune("self_clickcd"))

/datum/special_intent/greatsword_swing/process_grid(list/turfs, hit_delay)
	hitcount++
	return ..()

/datum/special_intent/greatsword_swing/post_delay(list/turfs)
	. = ..()
	playsound(howner, 'modular_redtard/rockhill/sound/combat/wooshes/bladed/wooshlarge (3).ogg', 100, TRUE)

/datum/special_intent/greatsword_swing/apply_hit(turf/marked)
	for(var/mob/living/victim as anything in victims(marked))
		victim.rogue_slowdown(tune("slow_dur"))
		if(victim.body_position != STANDING_UP)
			continue
		var/wave_damage = tune("dam") * (hitcount == 2 ? 1.5 : (hitcount >= 3 ? 2 : 1))
		weapon_damage(victim, wave_damage, BODY_ZONE_CHEST, BCLASS_CUT)
		if(hitcount >= 3)
			weapon_damage(victim, tune("dam") * 0.8, BODY_ZONE_CHEST, BCLASS_CUT, no_pen = TRUE)
		playsound(marked, 'modular_redtard/rockhill/sound/combat/sp_gsword_hit.ogg', 100, TRUE)

/datum/special_intent/greatsword_swing/white_stag
	dam = 80
	cooldown = 25 SECONDS

/datum/special_intent/greatflail_swing
	name = "Greatflail Swing"
	desc = "Swing your greatflail all around you in a ring of Judgement."
	tile_coordinates = list(
		list(0,0), list(1,0), list(1,-1), list(1,-2), list(0,-2), list(-1,-2), list(-1,-1), list(-1,0),
		list(0,1, 7), list(1,1, 7), list(-1,1, 7), list(1,-3, 7), list(0,-3, 7), list(-1,-3, 7), list(-2,0, 7), list(-2,-1, 7), list(-2,-2, 7), list(2,0, 7), list(2,-1, 7), list(2,-2, 7),
		list(0,0, 14), list(1,0, 14), list(1,-1, 14), list(1,-2, 14), list(0,-2, 14), list(-1,-2, 14), list(-1,-1, 14), list(-1,0, 14),
	)
	post_icon_state = "sweep_fx"
	pre_icon_state = "fx_trap_long"
	sfx_pre_delay = 'modular_redtard/rockhill/sound/combat/flail_sweep.ogg'
	respect_adjacency = FALSE
	delay = 0.7 SECONDS
	cooldown = 30 SECONDS
	stamcost = 25
	tunables = list("cooldown", "delay", "stamcost", "dam", "slow_dur", "self_immob", "self_clickcd", "self_vuln")
	var/dam = 60
	var/slow_dur = 2
	var/self_immob = 2.2 SECONDS
	var/self_clickcd = 2.1 SECONDS
	var/self_vuln = 2.3 SECONDS
	var/hitcount = 0
	var/list/swept = list()

/datum/special_intent/greatflail_swing/on_create()
	hitcount = 0
	howner.Immobilize(tune("self_immob"))
	howner.apply_status_effect(/datum/status_effect/rogue_vulnerable, tune("self_vuln"))
	howner.rogue_delay_action(tune("self_clickcd"))

/datum/special_intent/greatflail_swing/process_grid(list/turfs, hit_delay)
	hitcount++
	return ..()

/datum/special_intent/greatflail_swing/apply_hit(turf/marked)
	for(var/mob/living/victim as anything in victims(marked))
		victim.rogue_slowdown(tune("slow_dur"))
		if(victim.body_position != STANDING_UP)
			continue
		swept |= victim
		var/wave_damage = tune("dam") * (hitcount == 2 ? 1.5 : (hitcount >= 3 ? 2 : 1))
		weapon_damage(victim, wave_damage, BODY_ZONE_CHEST, BCLASS_BLUNT)
		if(hitcount >= 3)
			weapon_damage(victim, tune("dam") * 0.8, BODY_ZONE_CHEST, BCLASS_BLUNT, no_pen = TRUE)
		playsound(marked, 'modular_redtard/rockhill/sound/combat/flail_sweep_hit_major.ogg', 100, TRUE)

/datum/special_intent/greatflail_swing/post_delay(list/turfs)
	swept = list()
	. = ..()
	var/count = min(length(swept), 9)
	for(var/mob/living/victim as anything in swept)
		if(QDELETED(victim))
			continue
		victim.rogue_slowdown(tune("slow_dur") + count)
		if(count >= 2)
			victim.Immobilize(1 SECONDS + count SECONDS)
			victim.apply_status_effect(/datum/status_effect/rogue/exposed, 3 SECONDS + count SECONDS)
		if(count >= 3)
			victim.Knockdown(2 SECONDS)
		if(count >= 5)
			knock_off_balance(victim, 1.5 SECONDS + count SECONDS)
			victim.Stun(5 SECONDS)
		fling(victim, get_edge_target_turf(howner, get_dir(howner, victim)), clamp(count, 1, 5))
	swept = list()
	playsound(howner, 'modular_redtard/rockhill/sound/combat/wooshes/bladed/wooshlarge (3).ogg', 100, TRUE)

/datum/special_intent/upper_cut
	name = "Upper Cut"
	desc = "Charge up a devastating strike in front of you. An exposed target falls over and is flung back with tremendous damage; others are pushed slightly back."
	tile_coordinates = list(list(0,0))
	post_icon_state = "kick_fx"
	pre_icon_state = "trap"
	delay = 1.2 SECONDS
	cooldown = 30 SECONDS
	stamcost = 25
	tunables = list("cooldown", "delay", "stamcost", "knockdown_dur", "self_immob_dur", "dam", "finisher_dam")
	var/knockdown_dur = 1 SECONDS
	var/self_immob_dur = 1.5 SECONDS
	var/dam = 50
	var/finisher_dam = 200

/datum/special_intent/upper_cut/on_create()
	howner.rogue_off_balance(tune("self_immob_dur"))
	howner.Immobilize(tune("self_immob_dur"))
	playsound(howner, 'modular_redtard/rockhill/sound/combat/ground_smash_start.ogg', 100, TRUE)

/datum/special_intent/upper_cut/apply_hit(turf/marked)
	for(var/mob/living/victim as anything in victims(marked))
		var/distance = 1
		var/damage = tune("dam")
		var/zone = BODY_ZONE_CHEST
		if(victim.rogue_is_open())
			victim.Knockdown(tune("knockdown_dur"))
			distance = rand(2, 4)
			damage = tune("finisher_dam")
			zone = BODY_ZONE_HEAD
			playsound(howner, 'modular_redtard/rockhill/sound/combat/tf2crit.ogg', 100, TRUE)
		weapon_damage(victim, damage, zone, BCLASS_BLUNT, no_pen = TRUE)
		fling(victim, get_edge_target_turf(howner, get_dir(howner, victim)), distance)
		playsound(howner, 'modular_redtard/rockhill/sound/combat/hits/punch/punch_hard (2).ogg', 100, TRUE)
		victim.remove_status_effect(/datum/status_effect/rogue/exposed)
		victim.remove_status_effect(/datum/status_effect/rogue_vulnerable)

/datum/special_intent/limbguard
	name = "Limb Guard"
	desc = "Raise your shield to protect a limb. You will deflect projectiles and anyone striking that limb will be severely penalized. You cannot regain stamina while this is active. It can be cancelled by jumping, kicking or by using the special again with the same shield out."
	respect_adjacency = FALSE
	cooldown = 60 SECONDS
	stamcost = 25

/datum/special_intent/limbguard/apply_cost(mob/living/user)
	if(user.remove_status_effect(/datum/status_effect/rogue/limbguard) || user.has_status_effect(/datum/status_effect/rogue/guard))
		return FALSE
	return ..()

/datum/special_intent/limbguard/process_attack()
	SHOULD_CALL_PARENT(FALSE)
	log_combat(howner, howner, "raised a limb guard with", iparent)
	howner.apply_status_effect(/datum/status_effect/rogue/limbguard, GLOB.rogue_major_zones[howner.rogue_precise_zone()] || BODY_ZONE_CHEST, iparent, tune("cooldown"))

/datum/special_intent/polearm_backstep
	name = "Backstep"
	desc = "A defensive manoeuvre to quickly gain distance, shoving back any pursuer, slowing and exposing them. Always targets the chest."
	tile_coordinates = list(list(0,-1), list(1,-1), list(-1,-1))
	post_icon_state = "sweep_fx"
	pre_icon_state = "fx_trap_long"
	sfx_post_delay = 'modular_redtard/rockhill/sound/combat/rend_hit.ogg'
	sfx_pre_delay = 'modular_redtard/rockhill/sound/combat/polearm_woosh.ogg'
	respect_adjacency = FALSE
	delay = 0.5 SECONDS
	cooldown = 25 SECONDS
	stamcost = 15
	tunables = list("cooldown", "delay", "stamcost", "dam", "slow_dur", "min_dist", "open_dur")
	var/dam = 30
	var/slow_dur = 5
	var/min_dist = 3
	var/open_dur = 3 SECONDS
	var/push_dir

/datum/special_intent/polearm_backstep/process_attack()
	. = ..()
	push_dir = howner.dir
	fling(howner, get_edge_target_turf(howner, REVERSE_DIR(howner.dir)), 1)

/datum/special_intent/polearm_backstep/apply_hit(turf/marked)
	if(get_dist(howner, marked) > tune("min_dist"))
		return
	for(var/mob/living/victim as anything in victims(marked))
		victim.rogue_slowdown(tune("slow_dur"))
		weapon_damage(victim, tune("dam"), BODY_ZONE_CHEST, BCLASS_BLUNT, no_pen = TRUE)
		victim.apply_status_effect(/datum/status_effect/rogue/exposed, tune("open_dur"))
		fling(victim, get_edge_target_turf(howner, push_dir), 1)

/datum/special_intent/martyr
	name = "Martyr's Blaze"
	pre_icon_state = "trap"
	post_icon_state = "sweep_fx"
	delay = 0.7 SECONDS
	stamcost = 25
	tunables = list("cooldown", "delay", "stamcost", "fire_stacks", "self_immob_dur")
	var/fire_stacks = 4
	var/self_immob_dur = 1 SECONDS
	var/blade_class = BCLASS_CUT
	var/damage_divisor = 1
	var/start_text
	var/dam

/datum/special_intent/martyr/process_attack()
	dam = iparent.force * max(stat_share(ROGUE_STAT_STRENGTH) + stat_share(ROGUE_STAT_PERCEPTION), 1) / damage_divisor
	return ..()

/datum/special_intent/martyr/on_create()
	howner.Immobilize(tune("self_immob_dur"))
	if(start_text)
		to_chat(howner, span_warning(start_text))

/datum/special_intent/martyr/apply_hit(turf/marked)
	for(var/mob/living/victim as anything in victims(marked))
		victim.adjust_fire_stacks(tune("fire_stacks"))
		victim.ignite_mob()
		if(victim.body_position == STANDING_UP)
			weapon_damage(victim, dam, BODY_ZONE_CHEST, blade_class)

/datum/special_intent/martyr_volcano_slam
	parent_type = /datum/special_intent/martyr
	name = "Volcanic Blaze Slam"
	desc = "A powerful blow to the ground in front of the Martyr, leaving behind scorched earth and setting fire to anyone it touches."
	tile_coordinates = list(
		list(-1,0), list(0,0), list(1,0), list(-1,1), list(0,1), list(1,1), list(-1,2), list(0,2), list(1,2),
		list(-1,0, 30), list(0,0, 30), list(1,0, 30), list(-1,1, 30), list(0,1, 30), list(1,1, 30), list(-1,2, 30), list(0,2, 30), list(1,2, 30),
	)
	delay = 1.2 SECONDS
	fade_delay = 1 SECONDS
	post_icon_state = "strike"
	sfx_pre_delay = 'modular_redtard/rockhill/sound/combat/ground_smash_start.ogg'
	sfx_post_delay = 'modular_redtard/rockhill/sound/combat/ground_smash1.ogg'
	cooldown = 60 SECONDS
	fire_stacks = 5
	blade_class = BCLASS_BLUNT
	damage_divisor = 1.5
	start_text = "I slam the ground with volcanic fury!"

/datum/special_intent/martyr_blazing_sweep
	parent_type = /datum/special_intent/martyr
	name = "Blazing Axe Sweep"
	desc = "Two powerful swings of the axe forward, which spread forward in a semicircle and set fire to the heretics."
	tile_coordinates = list(
		list(-1,-1), list(1,-1), list(-1,0), list(0,0), list(1,0),
		list(-2,-1, 10), list(-2,0, 10), list(-1,1, 10), list(0,1, 10), list(1,1, 10), list(2,0, 10), list(2,-1, 10),
	)
	sfx_pre_delay = 'modular_redtard/rockhill/sound/combat/wooshes/bladed/wooshlarge (1).ogg'
	sfx_post_delay = 'modular_redtard/rockhill/sound/combat/sp_axe_swing1.ogg'
	cooldown = 50 SECONDS
	blade_class = BCLASS_CHOP
	start_text = "I unleash a blazing sweep with the martyr's axe in two furious waves!"

/datum/special_intent/martyr_blazing_sweep_sword
	parent_type = /datum/special_intent/martyr
	name = "Blazing Sword Sweep"
	desc = "Two powerful circular strikes, dealing fire damage and crushing all those fools who dared to surround the Martyr."
	tile_coordinates = list(
		list(-1,0), list(0,0), list(1,0), list(-1,-1), list(1,-1), list(-1,-2), list(0,-2), list(1,-2),
		list(-1,0, 15), list(0,0, 15), list(1,0, 15), list(-1,-1, 15), list(1,-1, 15), list(-1,-2, 15), list(0,-2, 15), list(1,-2, 15),
	)
	sfx_pre_delay = 'modular_redtard/rockhill/sound/combat/wooshes/bladed/wooshlarge (1).ogg'
	sfx_post_delay = 'modular_redtard/rockhill/sound/combat/sidesweep_hit.ogg'
	cooldown = 50 SECONDS
	self_immob_dur = 2 SECONDS
	start_text = "I unleash a blazing sword sweep around myself in two furious waves!"

/datum/special_intent/martyr_blazing_trident
	parent_type = /datum/special_intent/martyr
	name = "Blazing Trident Strike"
	desc = "A powerful blow with the trident forward, releasing arcs of fire from its teeth in the shape of a cross."
	tile_coordinates = list(
		list(0,0), list(-1,1), list(0,1), list(1,1), list(-2,2), list(0,2), list(2,2), list(-1,3), list(0,3), list(1,3), list(0,4),
	)
	sfx_pre_delay = 'modular_redtard/rockhill/sound/combat/wooshes/bladed/wooshlarge (1).ogg'
	sfx_post_delay = 'modular_redtard/rockhill/sound/combat/sidesweep_hit.ogg'
	cooldown = 30 SECONDS
	self_immob_dur = 0.5 SECONDS
	blade_class = BCLASS_STAB
	start_text = "I thrust my trident forward and bring down the power stored in it."

#undef ROGUE_SPECIAL_TIMER_INDEX
#undef ROGUE_SPECIAL_RING
