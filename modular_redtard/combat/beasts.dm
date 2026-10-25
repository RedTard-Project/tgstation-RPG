/mob/living/proc/rogue_defense_base()
	return ROGUE_DODGE_BASE

/mob/living/basic/rockhill
	var/rogue_defprob = 50
	var/rogue_can_dodge = FALSE
	var/list/rogue_mob_stats
	var/rogue_beast_fatigue = 0
	var/rogue_beast_fatigue_at = 0
	var/rogue_winded_until = 0

/mob/living/basic/rockhill/Initialize(mapload)
	. = ..()
	for(var/stat_type in rogue_mob_stats)
		rogue_adjust_stat(stat_type, rogue_mob_stats[stat_type] - rogue_stat(stat_type))
	if(rogue_can_dodge)
		AddElement(/datum/element/rogue_beast)

/mob/living/basic/rockhill/rogue_defense_base()
	return rogue_defprob

/mob/living/basic/rockhill/proc/rogue_beast_current_fatigue()
	if(rogue_beast_fatigue <= 0)
		return 0
	var/idle = world.time - rogue_beast_fatigue_at - ROGUE_BEAST_FATIGUE_RECOVERY
	if(idle <= 0)
		return rogue_beast_fatigue
	rogue_beast_fatigue = max(0, rogue_beast_fatigue - round(idle / (1 SECONDS) * ROGUE_BEAST_FATIGUE_REGEN, 1))
	rogue_beast_fatigue_at = world.time
	return rogue_beast_fatigue

/mob/living/basic/rockhill/proc/rogue_beast_spend_dodge()
	rogue_beast_fatigue = min(rogue_beast_current_fatigue() + ROGUE_BEAST_FATIGUE_PER_DODGE, ROGUE_BEAST_FATIGUE_MAX)
	rogue_beast_fatigue_at = world.time
	if(rogue_beast_fatigue < ROGUE_BEAST_FATIGUE_MAX)
		return
	rogue_winded_until = world.time + ROGUE_BEAST_WINDED
	rogue_beast_fatigue = 0
	visible_message(span_boldwarning("[src] is winded!"))
	balloon_alert_to_viewers("winded!")

/mob/living/basic/rockhill/proc/rogue_beast_dodge_turf(mob/living/attacker)
	var/dx = x - attacker.x
	var/dy = y - attacker.y
	var/list/directions
	if(abs(dx) < abs(dy))
		directions = dy > 0 ? list(NORTH, WEST, EAST) : list(SOUTH, WEST, EAST)
	else
		directions = dx > 0 ? list(EAST, SOUTH, NORTH) : list(WEST, NORTH, SOUTH)
	for(var/direction in shuffle(directions))
		var/turf/candidate = get_step(src, direction)
		if(candidate && !candidate.is_blocked_turf(TRUE))
			return candidate

/mob/living/basic/rockhill/proc/rogue_beast_dodge(mob/living/attacker, obj/item/weapon)
	if(world.time < rogue_winded_until || pulledby || loc == attacker.loc || body_position == LYING_DOWN || HAS_TRAIT(src, TRAIT_IMMOBILIZED))
		return FALSE
	var/paired = attacker.rogue_dual_paired
	if(!paired && world.time < rogue_last_dodge + ROGUE_BEAST_DODGE_DELAY)
		return FALSE
	if(!paired)
		rogue_last_dodge = world.time
	var/turf/dodge_turf = rogue_beast_dodge_turf(attacker)
	if(!dodge_turf)
		return FALSE
	var/chance = rogue_formula_value(ROGUE_FORMULA_BEAST_DODGE_CHANCE, list(
		"defender_speed" = rogue_stat(ROGUE_STAT_SPEED),
		"attacker_speed" = attacker.rogue_stat(ROGUE_STAT_SPEED),
		"weapon_skill" = weapon ? attacker.rogue_weapon_rank(weapon) : 0,
		"fatigue" = rogue_beast_current_fatigue(),
	))
	if(!prob(chance))
		return FALSE
	rogue_beast_spend_dodge()
	playsound(src, 'modular_redtard/rockhill/sound/combat/dodge.ogg', 100, FALSE)
	throw_at(dodge_turf, 1, 2, src, FALSE)
	visible_message(span_warning("<b>[src]</b> dodges [attacker]'s attack!"))
	log_combat(src, attacker, "dodged against")
	return TRUE

/datum/element/rogue_beast
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

/datum/element/rogue_beast/Attach(datum/target)
	. = ..()
	if(!istype(target, /mob/living/basic/rockhill))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_LIVING_CHECK_BLOCK, PROC_REF(on_check_block))

/datum/element/rogue_beast/Detach(datum/source)
	UnregisterSignal(source, COMSIG_LIVING_CHECK_BLOCK)
	return ..()

/datum/element/rogue_beast/proc/on_check_block(mob/living/basic/rockhill/source, atom/movable/hitby, damage, attack_text, attack_type, armour_penetration, damage_type, attack_flag)
	SIGNAL_HANDLER
	if(attack_type != MELEE_ATTACK && attack_type != UNARMED_ATTACK)
		return NONE
	var/mob/living/attacker = isliving(hitby) ? hitby : get(hitby, /mob/living)
	if(!isliving(attacker) || attacker == source || source.stat != STABLE || source.rogue_is_open())
		return NONE
	source.rogue_mark_in_combat()
	attacker.rogue_mark_in_combat()
	return source.rogue_beast_dodge(attacker, isitem(hitby) ? hitby : null) ? SUCCESSFUL_BLOCK : NONE
