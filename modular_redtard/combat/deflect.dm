GLOBAL_LIST_INIT(rogue_deflect_sounds, list(
	'modular_redtard/rockhill/sound/combat/parry/deflect_1.ogg',
	'modular_redtard/rockhill/sound/combat/parry/deflect_2.ogg',
	'modular_redtard/rockhill/sound/combat/parry/deflect_3.ogg',
	'modular_redtard/rockhill/sound/combat/parry/deflect_4.ogg',
	'modular_redtard/rockhill/sound/combat/parry/deflect_5.ogg',
	'modular_redtard/rockhill/sound/combat/parry/deflect_6.ogg',
))

/// Deflecting thrown items (Azure Peak "Adds Projectile Deflection (not arrows)", Ratwood combat 2.0): in combat mode, facing
/// the thing thrown at us with a weapon in hand, it may be knocked aside; right after one's own swing the chance doubles.
/mob/living/carbon/human/var/rogue_deflect_until = 0

/// Called by every swing of ours, landed or at the air, the way Ratwood hooks the attack animation.
/mob/living/carbon/human/proc/rogue_swung()
	rogue_deflect_until = world.time + ROGUE_DEFLECT_WINDOW

/datum/element/rogue_combat/proc/on_pre_hitby(mob/living/carbon/human/source, atom/movable/thrown, datum/thrownthing/throwingdatum)
	SIGNAL_HANDLER
	var/obj/item/flying = thrown
	if(!istype(flying) || !source.combat_mode || source.incapacitated)
		return NONE
	var/obj/item/weapon = source.get_active_held_item()
	if(!weapon || !length(weapon.rogue_intents()) || get_dir(source, flying) != source.dir)
		return NONE
	var/chance = source.rogue_weapon_rank(weapon) * ROGUE_DEFLECT_PER_RANK
	if(world.time < source.rogue_deflect_until)
		chance *= 2
	if(!prob(min(chance, ROGUE_DEFLECT_MAX)))
		return NONE
	var/turf/here = get_turf(flying)
	do_sparks(2, TRUE, here)
	playsound(source, pick(GLOB.rogue_deflect_sounds), 100, TRUE)
	source.visible_message(span_warning("[source] deflects \the [flying]!"))
	var/turn_angle = prob(ROGUE_DEFLECT_BACK_CHANCE) ? 0 : pick(90, 270)
	var/distance = rand(ROGUE_DEFLECT_MIN_RANGE, ROGUE_DEFLECT_MAX_RANGE)
	var/turf/landing = get_ranged_target_turf(here, turn(source.dir, turn_angle), distance)
	addtimer(CALLBACK(flying, TYPE_PROC_REF(/atom/movable, safe_throw_at), landing, distance, distance, source), 0.1 SECONDS)
	return COMSIG_HIT_PREVENTED
