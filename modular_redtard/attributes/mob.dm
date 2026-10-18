/mob/living
	var/datum/attribute_holder/attributes = /datum/attribute_holder

/mob/living/Initialize(mapload)
	. = ..()
	if(ispath(attributes))
		new attributes(src)

/mob/living/proc/rogue_attributes_updated()
	var/speed = ROGUE_STAT_VALUE(src, ROGUE_STAT_SPEED)
	var/slowdown = clamp((ROGUE_ATTRIBUTE_MIDDLING - speed) * ROGUE_SPEED_STEP, HAS_TRAIT(src, TRAIT_ROGUE_UNCAPPED_SPEED) ? ROGUE_SPEED_FASTEST_UNCAPPED : ROGUE_SPEED_FASTEST, ROGUE_SPEED_SLOWEST)
	if(slowdown)
		add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/rogue_speed, multiplicative_slowdown = slowdown)
	else
		remove_movespeed_modifier(/datum/movespeed_modifier/rogue_speed)

/datum/movespeed_modifier/rogue_speed
	variable = TRUE

/mob/living/proc/rogue_stat(stat_type)
	return ROGUE_STAT_VALUE(src, stat_type)

/mob/living/proc/rogue_skill(skill_type)
	return ROGUE_SKILL_VALUE(src, skill_type)

/mob/living/proc/rogue_skill_rank(skill_type)
	return ROGUE_SKILL_RANK(src, skill_type)

/mob/living/proc/rogue_adjust_stat(stat_type, amount)
	attributes?.adjust_stat(stat_type, amount)

/mob/living/proc/rogue_adjust_experience(skill_type, amount, silent = FALSE)
	if(HAS_TRAIT(src, TRAIT_ROGUE_NO_EXPERIENCE))
		return FALSE
	return attributes?.adjust_experience(skill_type, amount, silent)

/mob/living/proc/rogue_set_skill(skill_type, level, silent = TRUE)
	attributes?.set_skill_level(skill_type, level, silent)

/mob/living/proc/rogue_raise_skill(skill_type, level, silent = TRUE)
	attributes?.raise_skill_to(skill_type, level, silent)

/mob/living/proc/rogue_diceroll(requirement = 0, crit = 10, dice_num = 3, dice_sides = 6, count_modifiers = TRUE, context = ROGUE_DICE_PHYSICAL, return_flags = ROGUE_DICE_RETURN_SUCCESS)
	if(!attributes)
		return ROGUE_DICE_FAILURE
	return attributes.diceroll(requirement, crit, dice_num, dice_sides, count_modifiers, context, return_flags)

/mob/living/proc/rogue_stat_roll(stat_type, chance_per_point = 5, difficulty = ROGUE_ATTRIBUTE_MIDDLING)
	return prob(clamp(50 + (rogue_stat(stat_type) - difficulty) * chance_per_point, 0, 100))

/mob/living/proc/rogue_goodluck(multiplier = 3)
	var/fortune = rogue_stat(ROGUE_STAT_FORTUNE)
	return fortune > ROGUE_ATTRIBUTE_MIDDLING && prob((fortune - ROGUE_ATTRIBUTE_MIDDLING) * multiplier)

/mob/living/proc/rogue_badluck(multiplier = 3)
	var/fortune = rogue_stat(ROGUE_STAT_FORTUNE)
	return fortune < ROGUE_ATTRIBUTE_MIDDLING && prob((ROGUE_ATTRIBUTE_MIDDLING - fortune) * multiplier)

/mob/living/carbon/human/proc/rogue_apply_age()
	if(!attributes)
		return
	if(age >= ROGUE_AGE_OLD)
		attributes.add_sheet(/datum/attribute_holder/sheet/age_old)
	else if(age >= ROGUE_AGE_MIDDLE)
		attributes.add_sheet(/datum/attribute_holder/sheet/age_middle)
