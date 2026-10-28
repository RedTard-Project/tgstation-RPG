// Ratwood's potions (roguecrafting/alchemy/reagents.dm) as TG reagents under Ratwood's paths, so the porter fills Ratwood's
// bottles and vials with them (rockhill/config.json, list_reagents). Their effects are Ratwood's, per Ratwood tick of two seconds
// scaled to the seconds of the TG tick, as the soups count them (survival/soups.dm); Ratwood's products with its REM are written
// as Ratwood's number times ROGUE_REAGENT_EFFECT. Ratwood alpha is folded into the colour. TG has no clone damage, so Ratwood's
// clone healing is not ported.

/datum/reagent
	/// Ratwood harmful: what an antidote purges (poisons, toxins, dirty water).
	var/rogue_harmful = FALSE

/datum/reagent/toxin
	rogue_harmful = TRUE

/// Ratwood's health potions: they heal brute, burn, oxygen, the brain and the eyes, refill blood to normal and mend wounds
/// (Ratwood heal_wounds(), combat/medicine.dm). Over potion_overheal_volume units the body sheds the excess.
/datum/reagent/medicine/healthpot
	name = "Health Potion"
	description = "Gradually regenerates all types of damage."
	color = "#FF0000AD"
	taste_description = "lifeblood"
	metabolization_rate = ROGUE_REAGENT_RATE(1)
	/// Per Ratwood tick: brute and burn, oxygen, brain and eyes healed; blood given below normal; wound health mended.
	var/rogue_heal = 1.75 * ROGUE_REAGENT_EFFECT
	var/rogue_oxy_heal = 1.25
	var/rogue_brain_heal = 5 * ROGUE_REAGENT_EFFECT
	var/rogue_eye_heal = 1 * ROGUE_REAGENT_EFFECT
	var/rogue_blood = 15
	var/rogue_wound_heal = 3

/datum/reagent/medicine/healthpot/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/ticks = seconds_per_tick / ROGUE_REAGENT_TICK
	if(volume >= ROGUE_POTION_OVERHEAL_VOLUME)
		holder.remove_reagent(type, ROGUE_POTION_OVERHEAL_SHED * ticks)
	if(affected_mob.get_blood_volume() < BLOOD_VOLUME_NORMAL)
		affected_mob.adjust_blood_volume(rogue_blood * ticks, maximum = BLOOD_VOLUME_NORMAL)
	affected_mob.rogue_heal_wounds(rogue_wound_heal * ticks)
	if(volume < ROGUE_POTION_MIN_VOLUME)
		return
	var/updated = FALSE
	if(affected_mob.adjust_brute_loss(-rogue_heal * ticks, updating_health = FALSE))
		updated = TRUE
	if(affected_mob.adjust_fire_loss(-rogue_heal * ticks, updating_health = FALSE))
		updated = TRUE
	if(affected_mob.adjust_oxy_loss(-rogue_oxy_heal * ticks, updating_health = FALSE))
		updated = TRUE
	affected_mob.adjust_organ_loss(ORGAN_SLOT_BRAIN, -rogue_brain_heal * ticks)
	affected_mob.adjust_organ_loss(ORGAN_SLOT_EYES, -rogue_eye_heal * ticks)
	if(updated)
		return UPDATE_MOB_HEALTH

/// Heals four times as fast and spends itself three times as fast. Ratwood's strong potion sheds the plain one when there is
/// too much of it; here it sheds itself.
/datum/reagent/medicine/stronghealth
	parent_type = /datum/reagent/medicine/healthpot
	name = "Strong Health Potion"
	description = "Quickly regenerates all types of damage."
	color = "#820000"
	taste_description = "rich lifeblood"
	metabolization_rate = ROGUE_REAGENT_RATE(3)
	rogue_heal = 7 * ROGUE_REAGENT_EFFECT
	rogue_oxy_heal = 5
	rogue_brain_heal = 5 * ROGUE_REAGENT_EFFECT
	rogue_eye_heal = 2.5 * ROGUE_REAGENT_EFFECT
	rogue_blood = 20
	rogue_wound_heal = 6

/// Ratwood's mana potions restore energy (the rogue energy of humans, hud/rogue_hud_mechanics.dm).
/datum/reagent/medicine/manapot
	name = "Mana Potion"
	description = "Gradually regenerates energy."
	color = "#000042AD"
	taste_description = "sweet mana"
	metabolization_rate = ROGUE_REAGENT_RATE(1)
	/// Energy given per Ratwood tick.
	var/rogue_energy = 30

/datum/reagent/medicine/manapot/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(ishuman(affected_mob))
		var/mob/living/carbon/human/drinker = affected_mob
		drinker.rogue_energy_add(rogue_energy * seconds_per_tick / ROGUE_REAGENT_TICK)

/datum/reagent/medicine/strongmana
	parent_type = /datum/reagent/medicine/manapot
	name = "Strong Mana Potion"
	description = "Rapidly regenerates energy."
	color = "#0000FF"
	taste_description = "raw power"
	metabolization_rate = ROGUE_REAGENT_RATE(3)
	rogue_energy = 120

/// Ratwood's stamina potions take the fatigue off (Ratwood stamina, TG's stamina damage).
/datum/reagent/medicine/stampot
	name = "Stamina Potion"
	description = "Gradually regenerates stamina."
	color = "#129C00AD"
	taste_description = "sweet tea"
	metabolization_rate = ROGUE_REAGENT_RATE(1)
	/// Stamina damage taken off per Ratwood tick.
	var/rogue_stamina = 20

/datum/reagent/medicine/stampot/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(volume >= ROGUE_POTION_MIN_VOLUME && affected_mob.adjust_stamina_loss(-rogue_stamina * seconds_per_tick / ROGUE_REAGENT_TICK, updating_stamina = FALSE))
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/strongstam
	parent_type = /datum/reagent/medicine/stampot
	name = "Strong Stamina Potion"
	description = "Rapidly regenerates stamina."
	color = "#13DF00"
	taste_description = "sparkly static"
	rogue_stamina = 50

/// Ratwood's antidotes last as long as a poison and purge it much quicker: toxins healed and every harmful reagent purged a
/// little each tick, so drinking one before the poison is a defence.
/datum/reagent/medicine/antidote
	name = "Antidote"
	description = "Purges poisons from the blood and mends what they did."
	color = "#00FF00"
	taste_description = "sickly sweet"
	metabolization_rate = ROGUE_REAGENT_RATE(0.1)
	/// Per Ratwood tick: toxins healed, and units of each harmful reagent purged.
	var/rogue_toxin_heal = 4
	var/rogue_purge = 1

/datum/reagent/medicine/antidote/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/ticks = seconds_per_tick / ROGUE_REAGENT_TICK
	for(var/datum/reagent/poison as anything in holder.reagent_list)
		if(poison.rogue_harmful)
			holder.remove_reagent(poison.type, rogue_purge * ticks)
	if(volume >= ROGUE_POTION_MIN_VOLUME && affected_mob.adjust_tox_loss(-rogue_toxin_heal * ticks, updating_health = FALSE))
		return UPDATE_MOB_HEALTH

/// About three times as potent. Ratwood's strong antidote names the reagent to purge wrongly and purges nothing; here it purges.
/datum/reagent/medicine/strong_antidote
	parent_type = /datum/reagent/medicine/antidote
	name = "Strong Antidote"
	color = "#004200"
	taste_description = "dirt"
	rogue_toxin_heal = 12
	rogue_purge = 3

/// Ratwood's catalyst: with a potion or a poison it makes the strong one (the reactions below).
/datum/reagent/additive
	name = "Alchemical Additive"
	description = "A catalyst that strengthens a potion or a poison it is mixed with."
	color = "#C8C8C8"
	taste_description = "chalk"

// Ratwood's potion reactions: a potion or a poison and the additive, one to one, make the strong one at once.
/datum/chemical_reaction/rogue_alchemy
	abstract_type = /datum/chemical_reaction/rogue_alchemy
	mix_message = "The cauldron glows for a moment."
	required_temp = 0
	reaction_flags = REACTION_INSTANT

/datum/chemical_reaction/rogue_alchemy/stronghealth
	results = list(/datum/reagent/medicine/stronghealth = 1)
	required_reagents = list(/datum/reagent/medicine/healthpot = 1, /datum/reagent/additive = 1)

/datum/chemical_reaction/rogue_alchemy/strongmana
	results = list(/datum/reagent/medicine/strongmana = 1)
	required_reagents = list(/datum/reagent/medicine/manapot = 1, /datum/reagent/additive = 1)

/datum/chemical_reaction/rogue_alchemy/strongstam
	results = list(/datum/reagent/medicine/strongstam = 1)
	required_reagents = list(/datum/reagent/medicine/stampot = 1, /datum/reagent/additive = 1)

/datum/chemical_reaction/rogue_alchemy/strongpoison
	results = list(/datum/reagent/strongpoison = 1)
	required_reagents = list(/datum/reagent/berrypoison = 1, /datum/reagent/additive = 1)

/datum/chemical_reaction/rogue_alchemy/strongstampoison
	results = list(/datum/reagent/strongstampoison = 1)
	required_reagents = list(/datum/reagent/stampoison = 1, /datum/reagent/additive = 1)
