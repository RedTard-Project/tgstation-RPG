/// The miracles of Matthios that the basket (miracle.dm) did not have yet: Appraise, Transact, Equalize and Churn Wealthy (Ratwood
/// modular_azurepeak/code/modules/spells/pantheon/inhumen/matthios.dm; Azure Peak and Twilight Axis have them in a form of
/// their own). Wealth is the coin on a body and the balance of the NERVELOCK account (economy/treasury.dm). The numbers are in
/// faith.txt, the ones of a cast by miracle_<value_key>_*.

#define ROGUE_MATTHIOS_ICON 'modular_redtard/faith/icons/matthiosmiracles.dmi'
#define ROGUE_EQUALIZED_FILTER "rogue_equalized"
/// Tiers of the weight of wealth: the last one is a fortune, which has no upper bound.
#define ROGUE_CHURN_TIERS 7

/// Matthios's yellow (Ratwood): the colour of what the Free-God does with gold.
/proc/rogue_matthios_message(mob/speaker, text)
	to_chat(speaker, "<font color='yellow'>[text]</font>")

/// Ratwood get_mammons_in_atom(): the coin on a creature and in everything it carries.
/proc/rogue_mammons_in_atom(atom/holder)
	. = 0
	for(var/obj/item/roguecoin/coin in holder.get_all_contents())
		. += coin.get_real_price()

/// What a creature is worth to Matthios: the coin on it and in its NERVELOCK account.
/proc/rogue_wealth_of(mob/living/carbon/human/target)
	return rogue_mammons_in_atom(target) + SSrogue_treasury.get_balance(target)

/// Ratwood appraise "Appraise" (T0 of Matthios): says how many mammons a man has on him and in the NERVELOCK.
/datum/action/cooldown/spell/pointed/rogue_miracle/appraise
	name = "Appraise"
	desc = "Tells me how many mammons someone has on them and in the NERVELOCK."
	button_icon = ROGUE_MATTHIOS_ICON
	button_icon_state = "appraise"
	sound = null
	value_key = "appraise"
	miracle_tier = ROGUE_MIRACLE_TIER_0
	miracle_forks = "Ratwood"
	miracle_gods = "Matthios T0"

/datum/action/cooldown/spell/pointed/rogue_miracle/appraise/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !ishuman(cast_on))
		to_chat(owner, span_warning("Only a man can be counted."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/appraise/cast(mob/living/carbon/human/cast_on)
	. = ..()
	var/on_person = rogue_mammons_in_atom(cast_on)
	var/in_bank = SSrogue_treasury.get_balance(cast_on)
	rogue_matthios_message(owner, "[cast_on] has [on_person] mammons on them, [in_bank] in their NERVELOCK, for a total of [on_person + in_bank] mammons.")

/// Ratwood transact "Transact" (T0 of Matthios): an item in the hand is burned for a healing that grows with its worth: on a
/// creature of flesh as a healing aura, on anything else as harm.
/datum/action/cooldown/spell/pointed/rogue_miracle/transact
	name = "Transact"
	desc = "Sacrifice an item in my hand, healing the target over time with a strength that depends on the item's worth; whatever is not flesh is burned instead."
	button_icon = ROGUE_MATTHIOS_ICON
	button_icon_state = "transact"
	sound = null
	value_key = "transact"
	miracle_tier = ROGUE_MIRACLE_TIER_0
	miracle_forks = "Ratwood"
	miracle_gods = "Matthios T0"

/datum/action/cooldown/spell/pointed/rogue_miracle/transact/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !isliving(cast_on))
		to_chat(owner, span_warning("A transaction needs a living one."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/transact/cast(mob/living/cast_on)
	. = ..()
	var/mob/living/caster = owner
	var/obj/item/offering = caster.get_active_held_item()
	if(!offering)
		return fail("I need something of value to make a transaction...")
	var/worth = offering.get_real_price()
	if(!worth || worth < rogue_value("faith_transact_least"))
		return fail("This has little value, it will be of no use in such a transaction.")
	if(turned_away(cast_on))
		return fail()
	caster.visible_message(span_notice("The transaction is made, [cast_on] is bathed in empowerment!"))
	rogue_matthios_message(caster, "[offering] burns into the air suddenly, my transaction is accepted.")
	if(iscarbon(cast_on))
		cast_on.apply_status_effect(/datum/status_effect/rogue_miracle_heal, worth * rogue_value("faith_transact_share"))
	else
		cast_on.adjust_brute_loss(worth * rogue_value("faith_transact_share"))
		cast_on.adjust_fire_loss(worth * rogue_value("faith_transact_share"))
	playsound(caster, 'sound/effects/magic/fireball.ogg', 50, TRUE)
	qdel(offering)

/// Ratwood buff/equalizebuff: the strength, speed and constitution Matthios takes from one are given to the caster.
/datum/status_effect/rogue_miracle_stats/equalize_gain
	id = "rogue_equalize_gain"
	end_message = "<span class='notice'>My link wears off, their stolen fire returns to them.</span>"

/datum/status_effect/rogue_miracle_stats/equalize_gain/stat_changes()
	var/gain = rogue_value("faith_equalize_stat")
	return list(ROGUE_STAT_STRENGTH = gain, ROGUE_STAT_CONSTITUTION = gain, ROGUE_STAT_SPEED = gain)

/datum/status_effect/rogue_miracle_stats/equalize_gain/new_duration()
	return rogue_value("faith_equalize_time")

/datum/status_effect/rogue_miracle_stats/equalize_gain/on_apply()
	. = ..()
	owner.add_filter(ROGUE_EQUALIZED_FILTER, 2, list("type" = "outline", "color" = "#FFD700", "alpha" = 200, "size" = 1))

/datum/status_effect/rogue_miracle_stats/equalize_gain/on_remove()
	owner.remove_filter(ROGUE_EQUALIZED_FILTER)
	return ..()

/// Ratwood debuff/equalizedebuff: the same stats, taken.
/datum/status_effect/rogue_miracle_stats/equalize_loss
	id = "rogue_equalize_loss"
	start_message = "<span class='warning'>My fire is stolen from me!</span>"
	end_message = "<span class='notice'>My fire returns to me!</span>"

/datum/status_effect/rogue_miracle_stats/equalize_loss/stat_changes()
	var/loss = rogue_value("faith_equalize_stat")
	return list(ROGUE_STAT_STRENGTH = -loss, ROGUE_STAT_CONSTITUTION = -loss, ROGUE_STAT_SPEED = -loss)

/datum/status_effect/rogue_miracle_stats/equalize_loss/new_duration()
	return rogue_value("faith_equalize_time")

/datum/status_effect/rogue_miracle_stats/equalize_loss/on_apply()
	. = ..()
	owner.add_filter(ROGUE_EQUALIZED_FILTER, 2, list("type" = "outline", "color" = "#FFD700", "alpha" = 200, "size" = 1))

/datum/status_effect/rogue_miracle_stats/equalize_loss/on_remove()
	owner.remove_filter(ROGUE_EQUALIZED_FILTER)
	return ..()

/// Ratwood equalize "Equalize" (T2 of Matthios): the target is robbed of strength, speed and constitution and the caster
/// is given them, for a minute.
/datum/action/cooldown/spell/pointed/rogue_miracle/equalize
	name = "Equalize"
	desc = "Create equality, with a thumb on the scales, with my target. Siphon strength, speed and constitution from them."
	button_icon = ROGUE_MATTHIOS_ICON
	button_icon_state = "equalize"
	sound = 'sound/effects/magic/swap.ogg'
	value_key = "equalize"
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_2
	miracle_forks = "Ratwood"
	miracle_gods = "Matthios T2"

/datum/action/cooldown/spell/pointed/rogue_miracle/equalize/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !ishuman(cast_on))
		to_chat(owner, span_warning("Only a man can be equalized."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/equalize/cast(mob/living/carbon/human/cast_on)
	. = ..()
	cast_on.apply_status_effect(/datum/status_effect/rogue_miracle_stats/equalize_loss)
	var/mob/living/caster = owner
	caster.apply_status_effect(/datum/status_effect/rogue_miracle_stats/equalize_gain)

/// How hard the weight of a man's greed falls on him (Ratwood churnwealthy): the tier of his wealth, 0 for none. Each tier has
/// the wealth up to which it counts and its damage, fire, stun and blast in the numbers of faith.txt.
/proc/rogue_churn_tier(wealth)
	if(wealth <= rogue_value("faith_churn_least"))
		return 0
	for(var/tier in 1 to ROGUE_CHURN_TIERS - 1)
		if(wealth <= rogue_value("faith_churn_[tier]_wealth"))
			return tier
	return ROGUE_CHURN_TIERS

/// Ratwood churnwealthy "Churn Wealthy" (T3 of Matthios): the target is burned by the weight of its wealth: more the wealthier it
/// is, from a burn to a stunned, burning, exploding man; past a fortune the target is torn into coin and gems.
/datum/action/cooldown/spell/pointed/rogue_miracle/churn_wealthy
	name = "Churn Wealthy"
	desc = "Attacks the target by the weight of their greed, dealing more damage and worse effects the wealthier they are."
	button_icon = ROGUE_MATTHIOS_ICON
	button_icon_state = "churn_wealthy"
	sound = 'modular_redtard/faith/sound/churn.ogg'
	value_key = "churn_wealthy"
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_3
	miracle_forks = "Ratwood"
	miracle_gods = "Matthios T3"

/datum/action/cooldown/spell/pointed/rogue_miracle/churn_wealthy/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !ishuman(cast_on))
		to_chat(owner, span_warning("Only a man can be churned."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/churn_wealthy/cast(mob/living/carbon/human/cast_on)
	. = ..()
	var/mob/living/caster = owner
	if(caster.z != cast_on.z)
		return fail("The Free-God compels me to face [cast_on] on level ground before I transact.")
	var/wealth = rogue_wealth_of(cast_on)
	if(HAS_TRAIT(cast_on, TRAIT_NOBLE))
		wealth += rogue_value("faith_churn_noble_bonus")
	var/tier = rogue_churn_tier(wealth)
	if(!tier)
		return fail("[cast_on] has no wealth to hold against them.")
	INVOKE_ASYNC(src, PROC_REF(churn), caster, cast_on, tier)

/datum/action/cooldown/spell/pointed/rogue_miracle/churn_wealthy/proc/churn(mob/living/caster, mob/living/carbon/human/target, tier)
	var/damage = rogue_value("faith_churn_[tier]_damage")
	var/stacks = rogue_value("faith_churn_[tier]_stacks")
	var/stun = rogue_value("faith_churn_[tier]_stun")
	var/blast = rogue_value("faith_churn_[tier]_blast")
	if(tier <= 3)
		caster.say("Wealth becomes woe!")
		target.visible_message(span_danger("[target] is burned by holy light!"), span_userdanger("I feel the weight of my wealth burning at my soul!"))
	else if(tier <= 5)
		caster.say("The Free-God rebukes!")
		target.visible_message(span_danger("[target] is burned by holy light!"), span_userdanger("I feel the weight of my wealth tearing at my soul!"))
	else if(tier == 6)
		caster.say("Your final transaction! The Free-God rebukes!!")
		target.visible_message(span_danger("[target] is smited with holy light!"), span_userdanger("I feel the weight of my wealth rend my soul apart!"))
	else
		caster.say("Wealth beyond measure- YOUR FINAL TRANSACTION!!")
		target.visible_message(span_danger("[target]'s skin begins to SLOUGH AND BURN HORRIFICALLY, glowing like molten metal!"), span_userdanger("MY LIMBS BURN IN AGONY..."))
	if(stun)
		target.Stun(stun)
	if(tier >= 6)
		target.emote("agony")
	target.adjust_fire_loss(damage)
	if(stacks)
		target.adjust_fire_stacks(stacks)
		target.ignite_mob()
	playsound(caster, 'modular_redtard/faith/sound/churn.ogg', 100, TRUE)
	if(!blast)
		return
	explosion(get_turf(target), light_impact_range = blast, flame_range = blast, smoke = FALSE)
	if(tier < ROGUE_CHURN_TIERS)
		return
	sleep(rogue_value("faith_churn_rend_delay"))
	if(QDELETED(target))
		return
	target.visible_message(span_danger("[target]'s limbs REND into coin and gem!"), span_userdanger("WEALTH. POWER. THE FINAL SIGHT UPON MINE EYE IS A DRAGON'S MAW TEARING ME IN TWAIN. MY ENTRAILS ARE OF GOLD AND SILVER."))
	playsound(caster, 'modular_redtard/faith/sound/churn.ogg', 100, TRUE)
	playsound(caster, 'modular_redtard/faith/sound/whiteflame.ogg', 100, TRUE)
	var/turf/where = get_turf(target)
	explosion(where, light_impact_range = blast, flame_range = blast, smoke = FALSE)
	new /obj/item/roguecoin/silver/pile(where)
	new /obj/item/roguecoin/gold/pile(where)
	for(var/gems in 1 to rogue_value("faith_churn_gems"))
		new /obj/item/roguegem/random(where)
	var/list/limbs = list()
	for(var/zone in list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG))
		var/obj/item/bodypart/limb = target.get_bodypart(zone)
		if(limb)
			limbs += limb
	for(var/torn in 1 to min(rand(1, rogue_value("faith_churn_limbs")), length(limbs)))
		var/obj/item/bodypart/chosen = pick_n_take(limbs)
		if(chosen.dismember())
			new /obj/effect/decal/cleanable/blood/gibs/limb(where)

#undef ROGUE_MATTHIOS_ICON
#undef ROGUE_EQUALIZED_FILTER
#undef ROGUE_CHURN_TIERS
