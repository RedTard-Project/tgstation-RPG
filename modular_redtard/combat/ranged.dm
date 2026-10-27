/// Perception in ranged combat (Ratwood bows.dm, crossbows.dm, slings.dm process_fire(); Azure Peak launchers.dm) on TG's
/// projectiles. Every shot of a person on a medieval map, from a gun, a bow or a spell, aims by their perception: the
/// distance at which it still lands on the aimed part (TG accurate_range) grows by ranged_per_accuracy_step per point
/// above ranged_per_accuracy_base and shrinks below it (Ratwood: 3 per point that falls off with range plus 1 that does
/// not, from 8), and by ranged_skill_accuracy_step per rank of the launcher's skill (Ratwood: 5 per level). A gun spreads
/// its shots more by ranged_per_spread_step degrees per point of perception below ranged_per_baseline (Azure Peak's
/// archer spread). What a muscle-powered launcher shoots (rogue_per_damage: TG bows; Azure Peak per_scales_damage) hits
/// harder with perception: by ranged_per_damage_step per point from ranged_per_baseline up to ranged_per_softcap and by
/// ranged_per_damage_capped_step past it, never under ranged_per_damage_floor (Azure Peak get_per_damage_scaling()).
#define ROGUE_RANGED_PER_BASELINE rogue_value("ranged_per_baseline")
#define ROGUE_RANGED_PER_SOFTCAP rogue_value("ranged_per_softcap")
#define ROGUE_RANGED_PER_DAMAGE_STEP rogue_value("ranged_per_damage_step")
#define ROGUE_RANGED_PER_DAMAGE_CAPPED_STEP rogue_value("ranged_per_damage_capped_step")
#define ROGUE_RANGED_PER_DAMAGE_FLOOR rogue_value("ranged_per_damage_floor")
#define ROGUE_RANGED_PER_ACCURACY_BASE rogue_value("ranged_per_accuracy_base")
#define ROGUE_RANGED_PER_ACCURACY_STEP rogue_value("ranged_per_accuracy_step")
#define ROGUE_RANGED_SKILL_ACCURACY_STEP rogue_value("ranged_skill_accuracy_step")
#define ROGUE_RANGED_PER_SPREAD_STEP rogue_value("ranged_per_spread_step")

/obj/item
	/// Perception raises the damage of what this launches (Azure Peak per_scales_damage: bows and slings).
	var/rogue_per_damage = FALSE

/obj/item/gun/ballistic/bow
	rogue_per_damage = TRUE

/// Azure Peak's perception damage factor of a muscle-powered launcher.
/proc/rogue_per_damage_factor(perception)
	var/baseline = ROGUE_RANGED_PER_BASELINE
	var/softcap = ROGUE_RANGED_PER_SOFTCAP
	var/factor = 1 + (min(perception, softcap) - baseline) * ROGUE_RANGED_PER_DAMAGE_STEP + max(perception - softcap, 0) * ROGUE_RANGED_PER_DAMAGE_CAPPED_STEP
	return max(factor, ROGUE_RANGED_PER_DAMAGE_FLOOR)

/datum/element/rogue_combat/proc/on_fire_projectile(mob/living/carbon/human/source, obj/projectile/shot, atom/fired_from, atom/original_target)
	SIGNAL_HANDLER
	var/perception = source.rogue_stat(ROGUE_STAT_PERCEPTION)
	var/obj/item/launcher = isitem(fired_from) ? fired_from : null
	if(launcher?.rogue_per_damage)
		shot.damage *= rogue_per_damage_factor(perception)
	var/accuracy = (perception - ROGUE_RANGED_PER_ACCURACY_BASE) * ROGUE_RANGED_PER_ACCURACY_STEP
	if(launcher?.associated_skill)
		accuracy += source.rogue_skill_rank(launcher.associated_skill) * ROGUE_RANGED_SKILL_ACCURACY_STEP
	shot.accurate_range += accuracy

/datum/element/rogue_combat/proc/on_fired_gun(mob/living/carbon/human/source, obj/item/gun/gun_fired, atom/target, params, zone_override, list/bonus_spread_values)
	SIGNAL_HANDLER
	var/shortfall = ROGUE_RANGED_PER_BASELINE - source.rogue_stat(ROGUE_STAT_PERCEPTION)
	if(shortfall > 0)
		bonus_spread_values[MAX_BONUS_SPREAD_INDEX] += shortfall * ROGUE_RANGED_PER_SPREAD_STEP

#undef ROGUE_RANGED_PER_BASELINE
#undef ROGUE_RANGED_PER_SOFTCAP
#undef ROGUE_RANGED_PER_DAMAGE_STEP
#undef ROGUE_RANGED_PER_DAMAGE_CAPPED_STEP
#undef ROGUE_RANGED_PER_DAMAGE_FLOOR
#undef ROGUE_RANGED_PER_ACCURACY_BASE
#undef ROGUE_RANGED_PER_ACCURACY_STEP
#undef ROGUE_RANGED_SKILL_ACCURACY_STEP
#undef ROGUE_RANGED_PER_SPREAD_STEP
