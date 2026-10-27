/// Vibelin's minotaur rage (ai/subtrees/minotaur_target.dm, minotaur_special.dm, minotaur_fury.dm) on Ratwood's minotaurs. While it
/// fights its rage grows, twice as fast below 60% health and three times below 30%; at those marks it enters its second and
/// third phase (a roar, more damage). Its blows hit harder with phase and rage, in the third phase it now and then mends a
/// little. It charges at a foe 4-10 tiles away; from the second phase it slams the ground and fire erupts around its foe; in the
/// third, with half its rage spent, it sends a shockwave around itself. Vibelin's speed gain and the visuals of the rage are
/// left out; its boss is a 1500-health monster, Ratwood's minotaurs keep their own health and strength.
/mob/living/simple_animal/hostile/retaliate/rogue/minotaur
	rogue_pve_ability_types = list(
		/datum/action/cooldown/mob_cooldown/charge/basic_charge/rogue_pve_minotaur,
		/datum/action/cooldown/mob_cooldown/rogue_pve/minotaur_fury,
		/datum/action/cooldown/mob_cooldown/rogue_pve/minotaur_slam,
	)
	/// Vibelin BB_MINOTAUR_RAGE_METER: 0-100.
	var/rogue_rage = 0
	/// Vibelin BB_MINOTAUR_PHASE: 1-3.
	var/rogue_rage_phase = 1
	/// When the rage was last reckoned.
	var/rogue_rage_at = 0

/// Vibelin minotaur_targeting and minotaur_enrage: the rage grows while it fights and cools while it does not.
/mob/living/simple_animal/hostile/retaliate/rogue/minotaur/rogue_pve_fight_tick(atom/target)
	var/elapsed = rogue_rage_at ? (world.time - rogue_rage_at) / (1 SECONDS) : 0
	rogue_rage_at = world.time
	if(elapsed > 5)
		rogue_rage = max(0, rogue_rage - ROGUE_PVE_RAGE_DECAY * elapsed)
		elapsed = 0
	var/share = maxHealth ? health / maxHealth : 1
	var/gain = ROGUE_PVE_RAGE_GAIN * elapsed
	if(share < ROGUE_PVE_RAGE_PHASE_THREE)
		gain *= ROGUE_PVE_RAGE_DYING_FACTOR
	else if(share < ROGUE_PVE_RAGE_PHASE_TWO)
		gain *= ROGUE_PVE_RAGE_HURT_FACTOR
	rogue_rage = min(100, rogue_rage + gain)
	if(share < ROGUE_PVE_RAGE_PHASE_THREE && rogue_rage_phase < 3)
		rogue_rage_phase = 3
		visible_message(span_danger("[src] lets out an earthshaking roar as blood seeps from its wounds!"))
		playsound(src, 'sound/effects/explosion/explosionfar.ogg', 60, TRUE)
		Shake(2, 2, 1 SECONDS)
	else if(share < ROGUE_PVE_RAGE_PHASE_TWO && rogue_rage_phase < 2)
		rogue_rage_phase = 2
		visible_message(span_warning("[src] stomps the ground in anger, its eyes burning with hatred!"))
		playsound(src, 'sound/effects/bang.ogg', 60, TRUE)
		Shake(2, 2, 1 SECONDS)
	var/bonus = rogue_rage / 100 * ROGUE_PVE_RAGE_DAMAGE
	if(rogue_rage_phase >= 3)
		bonus += ROGUE_PVE_RAGE_BONUS_THREE
	else if(rogue_rage_phase >= 2)
		bonus += ROGUE_PVE_RAGE_BONUS_TWO
	melee_damage_lower = initial(melee_damage_lower) + bonus
	melee_damage_upper = initial(melee_damage_upper) + bonus
	if(rogue_rage_phase >= 3 && health < maxHealth && prob(ROGUE_PVE_RAGE_HEAL_CHANCE))
		adjust_brute_loss(-maxHealth * ROGUE_PVE_RAGE_HEAL)
		new /obj/effect/temp_visual/heal(get_turf(src), "#FF0000")

/// Vibelin minotaur_charge_attack: it lowers its head, shakes, and charges past its foe; whoever it runs into is knocked down
/// and thrown aside. TG's basic charge does the run.
/datum/action/cooldown/mob_cooldown/charge/basic_charge/rogue_pve_minotaur
	name = "Charge"
	desc = "Lower your head and charge, trampling whoever is in the way."
	shared_cooldown = NONE
	charge_past = 2
	charge_distance = 15
	destroy_objects = FALSE

/datum/action/cooldown/mob_cooldown/charge/basic_charge/rogue_pve_minotaur/New(Target, original = TRUE)
	. = ..()
	cooldown_time = rogue_value("pve_charge_cooldown")
	charge_delay = ROGUE_PVE_CHARGE_WINDUP
	knockdown_duration = ROGUE_PVE_CHARGE_KNOCKDOWN

/datum/action/cooldown/mob_cooldown/charge/basic_charge/rogue_pve_minotaur/rogue_ai_wants(mob/living/basic/rockhill/beast, atom/target)
	var/distance = get_dist(owner, target)
	return distance >= ROGUE_PVE_CHARGE_MIN && distance <= ROGUE_PVE_CHARGE_MAX && can_see(owner, target, distance + 1)

/datum/action/cooldown/mob_cooldown/charge/basic_charge/rogue_pve_minotaur/do_charge_indicator(atom/charger, atom/charge_target)
	. = ..()
	charger.visible_message(span_danger("[charger] lowers its head and prepares to charge!"))
	playsound(charger, 'sound/effects/meteorimpact.ogg', 50, TRUE)
	var/turf/start = get_turf(charger)
	for(var/turf/marked as anything in get_line(start, get_turf(charge_target)))
		if(marked == start)
			continue
		if(isclosedturf(marked))
			break
		new /obj/effect/temp_visual/rogue_pve_mark(marked, charge_delay)

/datum/action/cooldown/mob_cooldown/charge/basic_charge/rogue_pve_minotaur/hit_target(atom/movable/source, atom/target, damage_dealt)
	if(!isliving(target))
		return ..()
	var/mob/living/victim = target
	if(ishuman(victim))
		var/mob/living/carbon/human/human_target = victim
		if(human_target.check_block(source, 0, "\the [source]", attack_type = LEAP_ATTACK))
			var/mob/living/charger = source
			if(istype(charger) && recoil_duration >= 0)
				charger.Stun(recoil_duration, ignore_canstun = TRUE)
			return
	victim.visible_message(span_danger("[source] charges into [victim]!"), span_userdanger("[source] charges into me!"))
	victim.Knockdown(knockdown_duration)
	rogue_pve_strike(source, victim, ROGUE_PVE_CHARGE_DAMAGE, armored = FALSE)
	playsound(victim, 'sound/effects/meteorimpact.ogg', 80, TRUE)
	if(!victim.anchored)
		victim.safe_throw_at(get_edge_target_turf(victim, get_dir(source, victim) || source.dir), 4, 1, source)

/// Vibelin minotaur_fury_slam, from the second phase: it raises its weapon, then fire erupts under its foe and on tiles around,
/// more of them in the third phase, when it also smashes the tile in front of it.
/datum/action/cooldown/mob_cooldown/rogue_pve/minotaur_fury
	name = "Fury"
	desc = "Slam the ground and rain fiery debris around someone."
	cooldown_value = "pve_fury_cooldown"

/datum/action/cooldown/mob_cooldown/rogue_pve/minotaur_fury/rogue_ai_wants(mob/living/basic/rockhill/beast, atom/target)
	var/mob/living/simple_animal/hostile/retaliate/rogue/minotaur/boss = beast
	return istype(boss) && boss.rogue_rage_phase >= 2 && get_dist(owner, target) <= 2 && can_see(owner, target, 2)

/datum/action/cooldown/mob_cooldown/rogue_pve/minotaur_fury/Activate(atom/target)
	var/turf/center = get_turf(target)
	if(!center)
		return FALSE
	var/mob/living/simple_animal/hostile/retaliate/rogue/minotaur/boss = owner
	var/phase = istype(boss) ? boss.rogue_rage_phase : 2
	var/windup = ROGUE_PVE_FURY_WINDUP
	owner.visible_message(span_danger("[owner] raises its weapon high, the air around it shimmering with heat!"))
	playsound(owner, 'sound/effects/magic/fireball.ogg', 80, TRUE)
	if(istype(boss))
		boss.Immobilize(windup, ignore_canstun = TRUE)
	new /obj/effect/temp_visual/rogue_pve_mark(center, windup)
	addtimer(CALLBACK(src, PROC_REF(rogue_erupt), center, phase), windup)
	StartCooldown()
	return TRUE

/datum/action/cooldown/mob_cooldown/rogue_pve/minotaur_fury/proc/rogue_erupt(turf/center, phase)
	if(!rogue_can_go_on())
		return
	owner.visible_message(span_danger("[owner] slams the ground, creating a rain of fiery debris!"))
	playsound(owner, 'sound/effects/bamf.ogg', 80, TRUE)
	new /obj/effect/temp_visual/rogue_pve_fury_zone/strong(center, owner)
	var/list/spots = list()
	for(var/turf/open/spot in range(3, center))
		if(spot != center && !spot.density)
			spots += spot
	for(var/i in 1 to min(3 + phase * 2, length(spots)))
		addtimer(CALLBACK(src, PROC_REF(rogue_zone), pick_n_take(spots), phase >= 3 && prob(40)), i * 3)
	if(phase < 3)
		return
	var/turf/front = get_step(owner, owner.dir)
	if(!front)
		return
	owner.visible_message(span_danger("[owner] smashes the ground in front of it!"))
	new /obj/effect/temp_visual/rogue_pve_mark/strike(front)
	for(var/mob/living/smashed in front)
		if(!rogue_pve_is_foe(owner, smashed))
			continue
		smashed.Knockdown(2 SECONDS)
		rogue_pve_strike(owner, smashed, ROGUE_PVE_FURY_DAMAGE * 1.5, armored = FALSE)

/datum/action/cooldown/mob_cooldown/rogue_pve/minotaur_fury/proc/rogue_zone(turf/spot, strong)
	if(QDELETED(owner) || !spot)
		return
	var/zone_type = strong ? /obj/effect/temp_visual/rogue_pve_fury_zone/strong : /obj/effect/temp_visual/rogue_pve_fury_zone
	new zone_type(spot, owner)

/// Vibelin minotaur_fury_zone: a patch of ground glowing yellow, then flaring red twice, burning whoever stands on it.
/obj/effect/temp_visual/rogue_pve_fury_zone
	name = "fiery zone"
	desc = "A patch of ground that's about to erupt in flames!"
	icon = 'icons/effects/fire.dmi'
	icon_state = "fire"
	layer = BELOW_MOB_LAYER
	randomdir = FALSE
	light_range = 2
	light_color = LIGHT_COLOR_FIRE
	duration = 4 SECONDS
	/// Factor of the burn of each flare.
	var/damage_factor = 1
	/// How long a flare may knock someone down.
	var/knockdown = 0.5 SECONDS
	/// Who started the fire; its kin are spared.
	var/datum/weakref/caster_ref

/obj/effect/temp_visual/rogue_pve_fury_zone/Initialize(mapload, mob/living/caster)
	. = ..()
	caster_ref = WEAKREF(caster)
	alpha = 150
	color = "#ffff00"
	transform = matrix() * 0.5
	animate(src, alpha = 200, color = "#ff5500", transform = matrix(), time = 1 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(rogue_flare)), 1.5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(rogue_flare)), 2.5 SECONDS)

/obj/effect/temp_visual/rogue_pve_fury_zone/proc/rogue_flare()
	color = "#ff0000"
	alpha = 230
	playsound(src, 'sound/effects/bamf.ogg', 40, TRUE)
	var/mob/living/caster = caster_ref?.resolve()
	var/damage = ROGUE_PVE_FURY_DAMAGE * damage_factor
	for(var/mob/living/burnt in get_turf(src))
		if(!rogue_pve_is_foe(caster, burnt))
			continue
		burnt.apply_damage(damage, BURN, spread_damage = TRUE)
		if(prob(20))
			burnt.Knockdown(knockdown)

/obj/effect/temp_visual/rogue_pve_fury_zone/strong
	name = "raging inferno"
	desc = "A violent eruption of flames!"
	duration = 5 SECONDS
	damage_factor = 1.6
	knockdown = 1 SECONDS

/// Vibelin minotaur_ground_slam, in the third phase with half its rage: it raises its fists, then a shockwave rolls out from it,
/// ring by ring: the nearer, the harder it hits, knocking down and throwing back.
/datum/action/cooldown/mob_cooldown/rogue_pve/minotaur_slam
	name = "Ground Slam"
	desc = "Slam the ground with tremendous force, sending a shockwave all around."
	cooldown_value = "pve_slam_cooldown"
	click_to_activate = FALSE

/datum/action/cooldown/mob_cooldown/rogue_pve/minotaur_slam/rogue_ai_wants(mob/living/basic/rockhill/beast, atom/target)
	var/mob/living/simple_animal/hostile/retaliate/rogue/minotaur/boss = beast
	return istype(boss) && boss.rogue_rage_phase >= 3 && boss.rogue_rage >= ROGUE_PVE_SLAM_RAGE && get_dist(owner, target) <= 3

/datum/action/cooldown/mob_cooldown/rogue_pve/minotaur_slam/Activate(atom/target)
	var/mob/living/simple_animal/hostile/retaliate/rogue/minotaur/boss = owner
	if(istype(boss))
		boss.rogue_rage = max(0, boss.rogue_rage - ROGUE_PVE_SLAM_RAGE)
	var/windup = ROGUE_PVE_SLAM_WINDUP
	owner.visible_message(span_danger("[owner] raises its fists high into the air!"))
	playsound(owner, 'sound/effects/bang.ogg', 80, TRUE)
	var/mob/living/slammer = owner
	if(istype(slammer))
		slammer.Immobilize(windup, ignore_canstun = TRUE)
	for(var/turf/open/spot in range(1, owner))
		new /obj/effect/temp_visual/rogue_pve_mark(spot, windup)
	addtimer(CALLBACK(src, PROC_REF(rogue_slam)), windup)
	StartCooldown()
	return TRUE

/datum/action/cooldown/mob_cooldown/rogue_pve/minotaur_slam/proc/rogue_slam()
	if(!rogue_can_go_on())
		return
	owner.visible_message(span_danger("[owner] slams the ground with tremendous force!"))
	playsound(owner, 'sound/effects/explosion/explosionfar.ogg', 80, TRUE)
	for(var/radius in 1 to 5)
		addtimer(CALLBACK(src, PROC_REF(rogue_shockwave), get_turf(owner), radius), radius * 3)

/datum/action/cooldown/mob_cooldown/rogue_pve/minotaur_slam/proc/rogue_shockwave(turf/center, radius)
	if(QDELETED(owner) || !center)
		return
	for(var/turf/open/spot in range(radius, center))
		if(get_dist(spot, center) == radius && prob(20))
			new /obj/effect/temp_visual/small_smoke/halfsecond(spot)
	var/damage = ROGUE_PVE_SLAM_DAMAGE - radius * 5
	for(var/mob/living/shaken in range(radius, center))
		if(get_dist(shaken, center) != radius || !rogue_pve_is_foe(owner, shaken))
			continue
		rogue_pve_strike(owner, shaken, damage, armored = FALSE)
		if(radius <= 3)
			shaken.Knockdown(3 SECONDS - radius * 0.5 SECONDS)
		if(!shaken.anchored)
			shaken.safe_throw_at(get_edge_target_turf(shaken, get_dir(center, shaken)), radius == 3 ? 3 : 1, 1, owner)
