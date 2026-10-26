/// Ratwood food debuffs (code/datums/status_effects/rogue/debuff.dm: uncookedfood, burnedfood, rotfood, badmeal): what one bite
/// of bad food does at once. Ratwood nausea is TG disgust, Ratwood stress is a TG mood event.
/datum/status_effect/rogue_food
	id = "rogue_food"
	duration = 1
	tick_interval = STATUS_EFFECT_NO_TICK
	status_type = STATUS_EFFECT_MULTIPLE
	alert_type = null
	/// Ratwood nausea of the bite.
	var/nausea = 0
	/// Mood event of the bite (Ratwood stress event).
	var/datum/mood_event/mood
	/// Traits that make the eater shrug it off.
	var/list/immune_traits = list(TRAIT_NASTY_EATER)

/datum/status_effect/rogue_food/on_apply()
	for(var/trait in immune_traits)
		if(HAS_TRAIT(owner, trait))
			return TRUE
	if(nausea)
		owner.adjust_disgust(nausea * ROGUE_NAUSEA_TO_DISGUST)
	if(mood)
		owner.add_mood_event("[id]", mood)
	return TRUE

/datum/status_effect/rogue_food/uncooked
	id = "rogue_uncooked_food"
	nausea = 100
	immune_traits = list(TRAIT_NASTY_EATER, TRAIT_ORGAN_EATER, TRAIT_WILD_EATER, TRAIT_RAW_EATER)

/datum/status_effect/rogue_food/burned
	id = "rogue_burned_food"
	nausea = 100
	mood = /datum/mood_event/rogue_burnt_meal

/datum/status_effect/rogue_food/rotten
	id = "rogue_rotten_food"
	nausea = 200
	mood = /datum/mood_event/rogue_rotten_food
	immune_traits = list(TRAIT_NASTY_EATER, TRAIT_ROT_EATER)

/datum/status_effect/rogue_food/bad_meal
	id = "rogue_bad_meal"
	mood = /datum/mood_event/rogue_bad_meal
	immune_traits = list()

/// Ratwood food buffs (code/datums/status_effects/rogue/roguebuff.dm: snackbuff, greatsnackbuff, mealbuff, greatmealbuff, sweet):
/// a good bite lifts the mood and the stats for a while; the better buff of a pair pushes the lesser one out.
/datum/status_effect/rogue_food_buff
	id = "rogue_food_buff"
	status_type = STATUS_EFFECT_REFRESH
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = /atom/movable/screen/alert/status_effect/rogue_food_buff
	/// Stat changes while it lasts (Ratwood effectedstats).
	var/list/stats
	/// Mood event when it starts (Ratwood stress event of on_apply()).
	var/datum/mood_event/mood
	/// The better buff of the pair: while it is on, this one does not start.
	var/datum/status_effect/better
	/// The lesser buff of the pair, which this one replaces.
	var/datum/status_effect/lesser

/datum/status_effect/rogue_food_buff/on_apply()
	if(better && owner.has_status_effect(better))
		return FALSE
	if(lesser)
		owner.remove_status_effect(lesser)
	if(length(stats))
		owner.attributes?.set_variable_attribute_modifier(id, stats.Copy())
	if(mood)
		owner.add_mood_event(id, mood)
	return TRUE

/datum/status_effect/rogue_food_buff/on_remove()
	owner.attributes?.remove_attribute_modifier(id)
	return ..()

/datum/status_effect/rogue_food_buff/snack
	id = "rogue_snack"
	duration = 8 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/rogue_food_buff/snack
	stats = list(ROGUE_STAT_WILLPOWER = 1)
	mood = /datum/mood_event/rogue_good_snack
	better = /datum/status_effect/rogue_food_buff/great_snack

/datum/status_effect/rogue_food_buff/great_snack
	id = "rogue_great_snack"
	duration = 10 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/rogue_food_buff/great_snack
	stats = list(ROGUE_STAT_CONSTITUTION = 1, ROGUE_STAT_WILLPOWER = 1)
	mood = /datum/mood_event/rogue_great_snack
	lesser = /datum/status_effect/rogue_food_buff/snack

/datum/status_effect/rogue_food_buff/meal
	id = "rogue_meal"
	duration = 30 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/rogue_food_buff/meal
	stats = list(ROGUE_STAT_CONSTITUTION = 1)
	mood = /datum/mood_event/rogue_good_meal
	better = /datum/status_effect/rogue_food_buff/great_meal

/datum/status_effect/rogue_food_buff/great_meal
	id = "rogue_great_meal"
	duration = 30 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/rogue_food_buff/great_meal
	stats = list(ROGUE_STAT_CONSTITUTION = 1, ROGUE_STAT_WILLPOWER = 1)
	mood = /datum/mood_event/rogue_great_meal
	lesser = /datum/status_effect/rogue_food_buff/meal

/datum/status_effect/rogue_food_buff/sweet
	id = "rogue_sweet"
	duration = 8 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/rogue_food_buff/sweet
	stats = list(ROGUE_STAT_FORTUNE = 1)
	mood = /datum/mood_event/rogue_sweet

/atom/movable/screen/alert/status_effect/rogue_food_buff
	icon = ROGUE_SURVIVAL_ALERTS
	icon_state = "foodbuff"

/atom/movable/screen/alert/status_effect/rogue_food_buff/snack
	name = "Good snack"
	desc = "Better than plain bread. Tasty."

/atom/movable/screen/alert/status_effect/rogue_food_buff/great_snack
	name = "Great Snack!"
	desc = "Nothing like a great and nutritious snack to help you on that final stretch. I feel invigorated."

/atom/movable/screen/alert/status_effect/rogue_food_buff/meal
	name = "Good meal"
	desc = "A meal a day keeps the barber away, or at least it makes it slightly easier."

/atom/movable/screen/alert/status_effect/rogue_food_buff/great_meal
	name = "Great meal!"
	desc = "That meal was something akin to a noble's feast! It's bound to keep me energized for an entire day."

/atom/movable/screen/alert/status_effect/rogue_food_buff/sweet
	name = "Sweet embrace"
	desc = "Sweets are always a sign of good luck, everything goes well when you eat some of them."

/// Ratwood food stress events (code/datums/stress/*_events.dm) as TG mood events.
/datum/mood_event/rogue_good_snack
	description = "That snack tastes pretty good."
	mood_change = 1 * ROGUE_STRESS_TO_MOOD
	timeout = 8 MINUTES

/datum/mood_event/rogue_great_snack
	description = "That snack was amazing! Can't wait for the next."
	mood_change = 2 * ROGUE_STRESS_TO_MOOD
	timeout = 10 MINUTES

/datum/mood_event/rogue_good_meal
	description = "That meal wasn't half bad."
	mood_change = 1 * ROGUE_STRESS_TO_MOOD
	timeout = 10 MINUTES

/datum/mood_event/rogue_great_meal
	description = "That meal tasted great!"
	mood_change = 2 * ROGUE_STRESS_TO_MOOD
	timeout = 15 MINUTES

/datum/mood_event/rogue_sweet
	description = "Sweets always bring my spirits up."
	mood_change = 2 * ROGUE_STRESS_TO_MOOD
	timeout = 8 MINUTES

/datum/mood_event/rogue_burnt_meal
	description = "YUCK! Burnt!"
	mood_change = -2 * ROGUE_STRESS_TO_MOOD
	timeout = 2 MINUTES

/datum/mood_event/rogue_rotten_food
	description = "YUCK! That was rotten!"
	mood_change = -4 * ROGUE_STRESS_TO_MOOD
	timeout = 2 MINUTES

/datum/mood_event/rogue_bad_meal
	description = "It tastes VILE!"
	mood_change = -2 * ROGUE_STRESS_TO_MOOD
	timeout = 3 MINUTES

