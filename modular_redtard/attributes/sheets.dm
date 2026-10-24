/datum/attribute_holder/sheet
	attribute_default = 0
	attribute_min = -INFINITY
	attribute_max = INFINITY
	skill_min = -INFINITY
	skill_max = INFINITY

/datum/attribute_holder/sheet/set_parent(mob/living/new_parent)
	if(new_parent)
		CRASH("Tried to give an attribute sheet a parent mob! ([type])")

/datum/attribute_holder/sheet/update_attributes()
	attribute_list = raw_attribute_list.Copy()

/datum/attribute_holder/sheet/job
	var/list/attribute_variance

/datum/attribute_holder/sheet/job/on_add(datum/attribute_holder/receiver)
	for(var/stat_type in attribute_variance)
		var/list/range = attribute_variance[stat_type]
		receiver.raw_attribute_list[stat_type] = clamp(ROGUE_NULLTOZERO(receiver.raw_attribute_list[stat_type]) + rand(range[1], range[2]), receiver.attribute_min, receiver.attribute_max)

/datum/attribute_holder/sheet/age_middle
	raw_attribute_list = list(
		ROGUE_STAT_SPEED = -1,
		ROGUE_STAT_WILLPOWER = 1,
		ROGUE_STAT_FORTUNE = 1,
	)

/datum/attribute_holder/sheet/age_old
	raw_attribute_list = list(
		ROGUE_STAT_STRENGTH = -1,
		ROGUE_STAT_SPEED = -2,
		ROGUE_STAT_PERCEPTION = -1,
		ROGUE_STAT_CONSTITUTION = -2,
		ROGUE_STAT_INTELLIGENCE = 3,
		ROGUE_STAT_FORTUNE = 1,
	)
