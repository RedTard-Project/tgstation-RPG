/// Ratwood food rot (snacks.dm process()): food with a shelf life spoils on medieval maps. Off - nothing rots.
/datum/config_entry/flag/rogue_food_rot
	default = TRUE

/// Multiplier on every Ratwood shelf life (2 - food keeps twice as long).
/datum/config_entry/number/rogue_food_rot_multiplier
	default = 1
	integer = FALSE
	min_val = 0.1
	max_val = 100

/// Multiplier on the Ratwood healing of sleep by bed quality (carbon/life.dm handle_sleep()); 0 - sleep heals only as in TG.
/datum/config_entry/number/rogue_sleep_heal_multiplier
	default = 1
	integer = FALSE
	min_val = 0
	max_val = 10

/// Multiplier on the speed of Ratwood cooking on pans, fires and in ovens (on top of the cook's skill).
/datum/config_entry/number/rogue_cooking_speed
	default = 1
	integer = FALSE
	min_val = 0.1
	max_val = 10

/// Ratwood cooking smells: freshly cooked food smells to the people around it for a while. Off - nothing smells.
/datum/config_entry/flag/rogue_food_smells
	default = TRUE

/// Ratwood noble palate: nobles mind poor fare, eating without a table and drinking soup without a spoon. Off - they eat as anyone.
/datum/config_entry/flag/rogue_noble_palate
	default = TRUE

/// Whether the Ratwood survival mechanics run: on medieval maps, as the rest of the rogue mechanics.
/proc/rogue_survival_enabled()
	return rogue_combat_enabled()

/// Ratwood add_sleep_experience(user, cooking, STAINT * share) after a cooking step: cooking experience by intelligence
/// (dreamt from Apprentice on, crafting/experience.dm).
/mob/living/proc/rogue_cooking_experience(share = 1)
	return rogue_craft_experience(/datum/attribute/skill/craft/cooking, rogue_stat(ROGUE_STAT_INTELLIGENCE) * share)

/// Ratwood get_cooktime_divisor(): how many times faster this cook works, by cooking rank, times the server's cooking speed.
/proc/rogue_cook_divisor(mob/living/cook)
	var/list/divisors = ROGUE_COOK_DIVISORS
	var/rank = isliving(cook) ? cook.rogue_skill_rank(/datum/attribute/skill/craft/cooking) : 0
	return divisors[clamp(rank, 0, length(divisors) - 1) + 1] * CONFIG_GET(number/rogue_cooking_speed)
