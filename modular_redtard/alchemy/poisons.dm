// Vibelin's poisons (crafting/alchemy/reagents.dm) under Ratwood's paths, and Ratwood's sleep powder, blessed water, cursed
// water and concentrated rot (Azure Peak's and Ratwood's content, below). A poison works slowly: a dose of 5 units makes one
// sick or kills over a minute, a poisoned round carries 2. What a poison does is the engine's (alchemy/potions.dm): the channels
// it works through, the ones the dwarves take less of, the volume it waits for; the numbers are alch_rg_<key>_<channel> and
// alch_rg_<key>_<channel>_resist. Vibelin's nausea is TG's disgust (survival/soups.dm ROGUE_NAUSEA_TO_DISGUST); an antidote of
// Ratwood's (the strong one) purges every poison (rogue_harmful). The rot infects, but its turning waits for the deadite; the
// poisons of other systems (the vampire's quietus, Pestra's humours) wait for them.

/// Ratwood isdwarf(): of the dwarven kin, the races Vibelin's dwarves gave (heritage/).
/proc/rogue_is_dwarf(mob/living/carbon/target)
	var/datum/species/kind = target?.dna?.species
	return kind && findtext(kind.rogue_vibelin_type, "/datum/species/dwarf") == 1

/// The base of Vibelin's poisons: harmful (an antidote of Ratwood's purges it), and a reagent of the engine.
/datum/reagent/poison
	rogue_harmful = TRUE
	rogue_rate = "poison_full"

/datum/reagent/poison/New()
	. = ..()
	rogue_set_rates()

/datum/reagent/poison/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	. |= rogue_tick(affected_mob, seconds_per_tick)

/datum/reagent/poison/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	rogue_apply_effects(affected_mob)

/datum/reagent/poison/on_mob_end_metabolize(mob/living/affected_mob, metabolization_ratio)
	. = ..()
	rogue_apply_effects(affected_mob, FALSE)

/datum/reagent/poison/on_mob_delete(mob/living/affected_mob)
	. = ..()
	rogue_apply_effects(affected_mob, FALSE)

/// Weaker, meant to make one wish for death and incapacitate but not kill: nausea and toxins; a dwarf takes a third and a quarter.
/datum/reagent/berrypoison
	parent_type = /datum/reagent/poison
	rogue_key = "berry"
	rogue_rate = "poison_slow"
	rogue_gate = ROGUE_GATE_POISON
	rogue_channels = ROGUE_RG_NAUSEA|ROGUE_RG_TOX
	rogue_resist_channels = ROGUE_RG_NAUSEA|ROGUE_RG_TOX

/datum/reagent/berrypoison/shroom
	rogue_key = "shroom"

/// Meant to kill in one full dose (5 units): a dwarf is left just above dying.
/datum/reagent/strongpoison
	parent_type = /datum/reagent/poison
	rogue_key = "doom"
	rogue_rate = "poison_slow"
	rogue_gate = ROGUE_GATE_POISON
	rogue_channels = ROGUE_RG_NAUSEA|ROGUE_RG_TOX
	rogue_resist_channels = ROGUE_RG_NAUSEA|ROGUE_RG_TOX

/// Leeches stamina; a dwarf loses a third of it.
/datum/reagent/stampoison
	parent_type = /datum/reagent/poison
	rogue_key = "stampoison"
	rogue_rate = "poison_quick"
	rogue_channels = ROGUE_RG_STAMINA
	rogue_resist_channels = ROGUE_RG_STAMINA

/datum/reagent/strongstampoison
	parent_type = /datum/reagent/poison
	rogue_key = "strongstampoison"
	rogue_rate = "strongstampoison"
	rogue_channels = ROGUE_RG_STAMINA
	rogue_resist_channels = ROGUE_RG_STAMINA

/// A combination of the strong stamina poison and the doom poison, craft only: the poison to out-poison anyone.
/datum/reagent/poison/dreaddeath
	rogue_key = "dreaddeath"
	rogue_rate = "poison_brisk"
	rogue_channels = ROGUE_RG_STAMINA|ROGUE_RG_TOX|ROGUE_RG_OXY
	rogue_resist_channels = ROGUE_RG_STAMINA|ROGUE_RG_TOX|ROGUE_RG_OXY

/// Rotten innards: the ones of the kind it was taken from are made sick by it (the more the less constitution they have). The
/// turning into Graggar's own at the end of it (Vibelin graggometer) waits for the species swap of the heritage and the patrons.
/datum/reagent/organpoison
	parent_type = /datum/reagent/poison
	rogue_key = "organ"
	rogue_rate = "poison_slow"
	/// Whose flesh it is: ROGUE_POOL_*, the ones that take it as poison.
	var/rogue_pool = ROGUE_POOL_ALL

/datum/reagent/organpoison/human
	rogue_pool = ROGUE_POOL_MEN

/datum/reagent/organpoison/kobold
	rogue_pool = ROGUE_POOL_KOBOLD

/datum/reagent/organpoison/rogue_extra(mob/living/carbon/affected_mob, seconds_per_tick)
	var/kobold = rogue_vibelin_species(affected_mob, "/datum/species/kobold")
	if((rogue_pool == ROGUE_POOL_MEN && kobold) || (rogue_pool == ROGUE_POOL_KOBOLD && !kobold))
		return NONE
	if(HAS_TRAIT(affected_mob, TRAIT_NOHUNGER) || HAS_TRAIT(affected_mob, TRAIT_NASTY_EATER) || HAS_TRAIT(affected_mob, TRAIT_ORGAN_EATER) || HAS_TRAIT(affected_mob, TRAIT_WILD_EATER))
		return NONE
	var/ticks = seconds_per_tick / ROGUE_REAGENT_TICK
	var/sick = max(rogue_rg("organ_nausea") * (1 - affected_mob.rogue_stat(ROGUE_STAT_CONSTITUTION) / rogue_rg("organ_constitution")), 0)
	affected_mob.adjust_disgust(sick * ticks * ROGUE_NAUSEA_TO_DISGUST)
	if(affected_mob.adjust_tox_loss(rogue_rg("organ_tox") * ticks, updating_health = FALSE))
		return UPDATE_MOB_HEALTH
	return NONE

/// Burns the lungs and throat of a dark elf, heals a tiefling, and chokes the rest in large doses.
/datum/reagent/poison/drowsbane
	rogue_key = "drowsbane"
	rogue_rate = "poison_slow"
	rogue_gate = ROGUE_GATE_POISON

/datum/reagent/poison/drowsbane/rogue_extra(mob/living/carbon/affected_mob, seconds_per_tick)
	if(volume < rogue_rg("gate_poison"))
		return NONE
	var/ticks = seconds_per_tick / ROGUE_REAGENT_TICK
	var/update = NONE
	var/chance = rogue_rg("drowsbane_chance")
	if(rogue_vibelin_species(affected_mob, "/datum/species/tieberian"))
		var/heal = rogue_rg("drowsbane_heal") * ticks
		if(affected_mob.adjust_brute_loss(-heal, updating_health = FALSE))
			update = UPDATE_MOB_HEALTH
		if(affected_mob.adjust_fire_loss(-heal, updating_health = FALSE))
			update = UPDATE_MOB_HEALTH
		if(volume >= rogue_rg("drowsbane_shed_volume"))
			holder.remove_reagent(type, rogue_rg("drowsbane_shed") * ticks)
		if(rogue_roll(chance, seconds_per_tick))
			to_chat(affected_mob, span_notice("Something inside me burns, it's rejuvenating!"))
	if(rogue_vibelin_species(affected_mob, "/datum/species/elf/dark") || rogue_vibelin_species(affected_mob, "/datum/species/human/halfdrow"))
		if(affected_mob.adjust_tox_loss(rogue_rg("drowsbane_tox") * ticks, updating_health = FALSE))
			update = UPDATE_MOB_HEALTH
		if(affected_mob.adjust_oxy_loss(rogue_rg("drowsbane_oxy") * ticks, updating_health = FALSE))
			update = UPDATE_MOB_HEALTH
		if(rogue_roll(chance, seconds_per_tick))
			affected_mob.adjust_eye_blur(rogue_rg("drowsbane_blur"))
			to_chat(affected_mob, span_warning("My eyes water..."))
			affected_mob.emote("cough")
		if(rogue_roll(chance, seconds_per_tick))
			affected_mob.emote("gasp")
			to_chat(affected_mob, span_warning("My throat feels like it's on fire!"))
		return update
	if(affected_mob.adjust_oxy_loss(rogue_rg("drowsbane_oxy_other") * ticks, updating_health = FALSE))
		update = UPDATE_MOB_HEALTH
	if(rogue_roll(chance, seconds_per_tick))
		to_chat(affected_mob, span_warning("My tongue feels like its on fire!"))
	if(volume > rogue_rg("drowsbane_irritate_volume"))
		if(rogue_roll(chance, seconds_per_tick))
			affected_mob.adjust_eye_blur(rogue_rg("drowsbane_blur"))
			to_chat(affected_mob, span_warning("My eyes water..."))
			affected_mob.emote("cough")
		if(rogue_roll(chance, seconds_per_tick))
			affected_mob.emote("gasp")
			to_chat(affected_mob, span_warning("My throat feels like it's on fire!"))
	return update

/// Ratwood's sleep powder: it saps energy, poisons the hale a little and after some forty seconds puts one to sleep.
/datum/reagent/sleep_powder
	name = "Sleep Powder"
	description = "A pale powder that makes one drowsy, then puts one to sleep."
	color = "#DDD3DF"
	metabolization_rate = ROGUE_REAGENT_RATE(0.2)
	rogue_harmful = TRUE
	/// Per Ratwood tick: energy sapped, the chance of the warning, and toxins while health is over rogue_toxin_health.
	var/rogue_energy_drain = 10
	var/rogue_warn_chance = 20
	var/rogue_toxin = 1 * ROGUE_REAGENT_EFFECT
	var/rogue_toxin_health = 80
	/// From this Ratwood tick on it puts one to sleep, so long a tick.
	var/rogue_sleep_cycle = 22
	var/rogue_sleep = 4 SECONDS

/datum/reagent/sleep_powder/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/ticks = seconds_per_tick / ROGUE_REAGENT_TICK
	if(ishuman(affected_mob))
		var/mob/living/carbon/human/drowsy = affected_mob
		drowsy.rogue_energy_add(-rogue_energy_drain * ticks)
	if(prob(rogue_warn_chance * ticks))
		to_chat(affected_mob, span_danger("I feel like I'm going to pass out!"))
	if(affected_mob.health > rogue_toxin_health && affected_mob.adjust_tox_loss(rogue_toxin * ticks, updating_health = FALSE))
		. = UPDATE_MOB_HEALTH
	if(current_cycle >= rogue_sleep_cycle)
		affected_mob.Sleeping(rogue_sleep)

/// Ratwood's blessed water (orison.dm): it heals the body from within, but not its wounds, and burns the undead, drunk or
/// splashed.
/datum/reagent/water/blessed
	name = "Blessed Water"
	description = "A gift of Devotion. Heals the body from within, but not physical wounds."
	metabolization_rate = ROGUE_REAGENT_RATE(1)
	/// Per Ratwood tick: the burns of the undead; toxins, oxygen and the brain healed and blood given below normal to the living.
	var/rogue_undead_burn = 1.5 * ROGUE_REAGENT_EFFECT
	var/rogue_heal = 3 * ROGUE_REAGENT_EFFECT
	var/rogue_blood = 10
	/// The fire the undead catch when it gets into their blood, and the burns a unit splashed on them deals.
	var/rogue_undead_fire_stacks = 2
	var/rogue_splash_burn = 2

/datum/reagent/water/blessed/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/ticks = seconds_per_tick / ROGUE_REAGENT_TICK
	if(affected_mob.mob_biotypes & MOB_UNDEAD)
		if(affected_mob.adjust_fire_loss(rogue_undead_burn * ticks, updating_health = FALSE))
			return UPDATE_MOB_HEALTH
		return
	if(rogue_reagent_restore(affected_mob, seconds_per_tick, 0, rogue_heal, rogue_heal, rogue_blood))
		. = UPDATE_MOB_HEALTH
	affected_mob.adjust_organ_loss(ORGAN_SLOT_BRAIN, -rogue_heal * ticks)

/datum/reagent/water/blessed/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	if(!(affected_mob.mob_biotypes & MOB_UNDEAD))
		return
	affected_mob.adjust_fire_stacks(rogue_undead_fire_stacks)
	affected_mob.ignite_mob()
	INVOKE_ASYNC(affected_mob, TYPE_PROC_REF(/mob, emote), "scream")
	affected_mob.visible_message(span_warning("[affected_mob] erupts into angry fizzling and hissing!"), span_warning("BLESSED WATER!!! IT BURNS!!!"))

/datum/reagent/water/blessed/expose_mob(mob/living/exposed_mob, methods = TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	if(!(methods & TOUCH) || !(exposed_mob.mob_biotypes & MOB_UNDEAD))
		return
	exposed_mob.adjust_fire_loss(rogue_splash_burn * reac_volume)
	exposed_mob.visible_message(span_warning("[exposed_mob] erupts into angry fizzling and hissing!"), span_warning("BLESSED WATER!!! IT BURNS!!!"))
	INVOKE_ASYNC(exposed_mob, TYPE_PROC_REF(/mob, emote), "scream")

/// Ratwood holywaterboil: blessed water boiled in a pot is plain water again.
/datum/chemical_reaction/food/rogue_boiled_blessed_water
	results = list(/datum/reagent/water = 1)
	required_reagents = list(/datum/reagent/water/blessed = 1)
	required_temp = ROGUE_BOIL_TEMPERATURE
	mob_react = FALSE

/// Azure Peak's cursed water (its spells/orison.dm), the water a priest of a dark patron draws: it mends from within, as
/// little as blessed water mends, the undead and the followers of the dark patrons (Ratwood's undead_hater off), and mends
/// anyone else as little but wearies them.
/datum/reagent/water/cursed
	name = "cursed water"
	description = "A gift of Devotion. Very slightly heals wounds of the dead and the enlightened."
	metabolization_rate = ROGUE_REAGENT_RATE(1)
	/// Per Azure tick: brute and burns healed, oxygen healed, wound health mended; the fatigue (TG stamina damage) of the rest.
	var/rogue_heal = 0.1 * ROGUE_REAGENT_EFFECT
	var/rogue_oxy_heal = 0.1
	var/rogue_wound_heal = 1
	var/rogue_fatigue = 0.5 * ROGUE_REAGENT_EFFECT

/datum/reagent/water/cursed/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/ticks = seconds_per_tick / ROGUE_REAGENT_TICK
	if(affected_mob.adjust_brute_loss(-rogue_heal * ticks, updating_health = FALSE))
		. = UPDATE_MOB_HEALTH
	if(affected_mob.adjust_fire_loss(-rogue_heal * ticks, updating_health = FALSE))
		. = UPDATE_MOB_HEALTH
	if(affected_mob.adjust_oxy_loss(-rogue_oxy_heal * ticks, updating_health = FALSE))
		. = UPDATE_MOB_HEALTH
	affected_mob.rogue_heal_wounds(rogue_wound_heal * ticks)
	if(!rogue_cursed_kin(affected_mob) && affected_mob.adjust_stamina_loss(rogue_fatigue * ticks, updating_stamina = FALSE))
		. = UPDATE_MOB_HEALTH

/// The dead and the followers of the dark patrons, whom cursed water does not weary.
/proc/rogue_cursed_kin(mob/living/drinker)
	if(drinker.mob_biotypes & MOB_UNDEAD)
		return TRUE
	var/mob/living/carbon/human/follower = drinker
	return istype(follower) && follower.rogue_patron && !follower.rogue_patron.rogue_faith_undead_hater

/// How long the deadite rot of the cauldron takes to turn one, and how much longer for the resistant (Ratwood 3 minutes, x 2).
#define ROGUE_DEADITE_ROT_TIME rogue_value("deadite_rot_time")
#define ROGUE_DEADITE_RESISTANCE rogue_value("deadite_rot_resistance")

/// Ratwood's concentrated rot (the cauldron's Concentrated rot, from Master alchemists): the deadite rot itself. Any of it
/// infects the living who can turn (a mind, not immune) and is gone at once.
/datum/reagent/deaditerot
	name = "Concentrated Rot"
	description = ""
	color = "#000000"
	taste_description = "sour meat"
	metabolization_rate = ROGUE_REAGENT_RATE(1)
	self_consuming = TRUE
	rogue_harmful = TRUE

/datum/reagent/deaditerot/on_mob_add(mob/living/affected_mob, amount)
	. = ..()
	var/mob/living/carbon/human/infected = affected_mob
	if(istype(infected) && infected.mind && !HAS_TRAIT(infected, TRAIT_ZOMBIE_IMMUNE))
		infected.apply_status_effect(/datum/status_effect/rogue_deadite_rot, ROGUE_DEADITE_ROT_TIME)
	holder.del_reagent(type)

/// Ratwood's deadite rot (antagonists/roguetown/villain/zombie/zombie_disease.dm): the infected feels the rot spread until it
/// turns them. The deadite waits for stage 5 (antagonists); until then the rot runs its course and passes, as Ratwood's does in
/// a body that cannot turn.
/datum/status_effect/rogue_deadite_rot
	id = "rogue_deadite_rot"
	duration = 3 MINUTES
	tick_interval = 20 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/rogue_deadite_rot
	/// Percent chance a word of the rot is a shout.
	var/rogue_shout_chance = 10
	var/static/list/rogue_rot_messages = list(
		"I can feel rot creeping up in the back of my throat. An oily, coppery taste flooding my mouth.",
		"My skin feels cold and clammy. I can feel my veins hardening up like cold steel.",
		"A deep hunger gnaws at my stomach. Nothing sates it.",
		"The color drains from the world as I view it, momentarily.",
		"I keep hearing whispers. Is she calling for me?",
		"My joints ache with a strange stiffness. It hurts to move.",
		"My mind is fraying, who am I?",
		"I can feel my pulse slowing. I've never felt this calm.",
		"There's a strange numbness spreading through my limbs, I'm bleeding but I can't tell where.",
		"I can smell my own flesh, it smells foul.",
	)

/datum/status_effect/rogue_deadite_rot/on_creation(mob/living/new_owner, time_to_turn)
	if(time_to_turn)
		duration = time_to_turn
	if(HAS_TRAIT(new_owner, TRAIT_DEADITE_RESISTANCE))
		duration *= ROGUE_DEADITE_RESISTANCE
	return ..()

/datum/status_effect/rogue_deadite_rot/tick(seconds_between_ticks)
	var/message = pick(rogue_rot_messages)
	to_chat(owner, prob(rogue_shout_chance) ? span_userdanger(message) : span_danger(message))

/atom/movable/screen/alert/status_effect/rogue_deadite_rot
	name = "Zombie Infection"
	desc = "You feel a coldness spreading through your body. You're turning into one of -them-!"
	icon = ROGUE_COMBAT_ALERTS_ICON
	icon_state = "rot"

#undef ROGUE_DEADITE_ROT_TIME
#undef ROGUE_DEADITE_RESISTANCE
