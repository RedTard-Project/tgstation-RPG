// Vibelin's potions (crafting/alchemy/reagents.dm) as TG reagents under Ratwood's paths, so the porter fills Ratwood's bottles and
// vials with them (rockhill/config.json, list_reagents) and the trade, the AI, the miracles and the bandage's soaking keep their
// paths (combat/medicine.dm). What a reagent does is not written reagent by reagent: the engine below does it from the channels
// (what it adds to the body each tick), the chemical effects (what the body keeps of it while it is in the blood), the limb
// effects (what it does to the limb a bandage lets it into) and the class of its metabolism that a type names. The number of
// each of them is alch_rg_<key>_<channel>, <key>_ce_<effect>, <key>_absorb_<field> and alch_rg_rate_<class>
// (config/redtard/mechanics/values/alchemy.txt); the data of a type (name, description, colour, taste, scent) is the generator's
// (tools/port_vibelin_alchemy.py, alchemy/vibelin/reagents.dm). Vibelin counts a reagent once per Life tick of two seconds, TG per
// second: a number of Vibelin is per tick, and what a second does is its share (survival/_defines.dm ROGUE_REAGENT_TICK).
// TG has no clone damage, so Vibelin's clone healing is not ported; Vibelin's vitae (vampires) and its stress are not in the
// module either.

/datum/reagent
	/// Ratwood harmful: what an antidote purges (poisons, toxins, dirty water).
	var/rogue_harmful = FALSE
	/// What the reagent smells of, to one who smells it (Vibelin scent_description; the cauldron's smell of a mix, alchemy/reagent_sight.dm).
	var/scent_description
	/// The key of the numbers of the reagent (alch_rg_<key>_*); null for a reagent the engine does nothing for.
	var/rogue_key
	/// The class of its metabolism (alch_rg_rate_<class>, units a Vibelin tick) and of its overdose (alch_rg_overdose_<class>).
	var/rogue_rate
	var/rogue_overdose
	/// ROGUE_RG_*: what it does every tick; the ones among them that work whatever the volume; the ones that are less to a
	/// poison-resilient body (the dwarves', _resist numbers); the volume the rest wait for (ROGUE_GATE_*).
	var/rogue_channels = NONE
	var/rogue_ungated = NONE
	var/rogue_resist_channels = NONE
	var/rogue_gate = ROGUE_GATE_NONE
	/// ROGUE_CEF_*: the chemical effects it keeps while it is in the blood (alchemy keeps them through combat/chem_effects.dm).
	var/rogue_effects = NONE
	/// ROGUE_ABS_*: what it does to a limb under a bandage; a reagent with nothing here goes into the body as it is.
	var/rogue_absorbs = NONE
	/// A potion over alch_rg_shed_volume units sheds the excess: no overhealing.
	var/rogue_shed = FALSE
	/// ROGUE_RG_* and ROGUE_CEF_* whose number is taken as minus its size (a heal, a lowering): the sign lives in the code, so the
	/// open numbers (every one 10) never turn a cure into harm (review of block VA1).
	var/rogue_minus_channels = NONE
	var/rogue_minus_effects = NONE

// ---------------------------------------------------------------------------------------------------------------------------
// The numbers.

GLOBAL_VAR_INIT(rogue_rg_revision, -1)
GLOBAL_LIST_EMPTY(rogue_rg_numbers)
GLOBAL_LIST_EMPTY(rogue_rg_profiles)
GLOBAL_LIST_EMPTY(rogue_rg_resist_profiles)

/// Forgets the numbers read when the mechanics numbers have changed (rogue_mechanics_revision()).
/proc/rogue_rg_fresh()
	var/revision = rogue_mechanics_revision()
	if(GLOB.rogue_rg_revision == revision)
		return
	GLOB.rogue_rg_revision = revision
	GLOB.rogue_rg_numbers.Cut()
	GLOB.rogue_rg_profiles.Cut()
	GLOB.rogue_rg_resist_profiles.Cut()

/// A number of the reagents of Vibelin (alch_rg_<name>), read once for each revision of the mechanics numbers: the Life tick asks.
/proc/rogue_rg(name)
	rogue_rg_fresh()
	var/number = GLOB.rogue_rg_numbers[name]
	if(isnull(number))
		number = rogue_value("alch_rg_[name]")
		GLOB.rogue_rg_numbers[name] = number
	return number

/// The channels of the engine, by name, and their bits.
/proc/rogue_rg_channels()
	var/static/list/channels = list(
		"brute" = ROGUE_RG_BRUTE, "burn" = ROGUE_RG_BURN, "tox" = ROGUE_RG_TOX, "oxy" = ROGUE_RG_OXY, "brain" = ROGUE_RG_BRAIN,
		"eyes" = ROGUE_RG_EYES, "lungs" = ROGUE_RG_LUNGS, "heart" = ROGUE_RG_HEART, "stamina" = ROGUE_RG_STAMINA,
		"wounds" = ROGUE_RG_WOUNDS, "blood" = ROGUE_RG_BLOOD, "energy" = ROGUE_RG_ENERGY, "mana" = ROGUE_RG_MANA,
		"nausea" = ROGUE_RG_NAUSEA, "dizzy" = ROGUE_RG_DIZZY, "jitter" = ROGUE_RG_JITTER, "confusion" = ROGUE_RG_CONFUSION,
		"drowsy" = ROGUE_RG_DROWSY, "blur" = ROGUE_RG_BLUR,
	)
	return channels

/// The chemical effects a reagent may keep, by their key in combat/chem_effects.dm, and their bits.
/proc/rogue_rg_effects()
	var/static/list/effects = list(
		ROGUE_CE_PAINKILLER = ROGUE_CEF_PAINKILLER, ROGUE_CE_ANTIBIOTIC = ROGUE_CEF_ANTIBIOTIC, ROGUE_CE_STABLE = ROGUE_CEF_STABLE,
		ROGUE_CE_PULSE = ROGUE_CEF_PULSE, ROGUE_CE_BLOODRESTORE = ROGUE_CEF_BLOODRESTORE, ROGUE_CE_OXYGENATED = ROGUE_CEF_OXYGENATED,
		ROGUE_CE_ORGAN_REGEN = ROGUE_CEF_ORGAN_REGEN, ROGUE_CE_BRAIN_REGEN = ROGUE_CEF_BRAIN_REGEN,
		ROGUE_CE_ENERGETIC = ROGUE_CEF_ENERGETIC, ROGUE_CE_STIMULANT = ROGUE_CEF_STIMULANT, ROGUE_CE_SHRINKING = ROGUE_CEF_SHRINKING,
		ROGUE_CE_ENLARGING = ROGUE_CEF_ENLARGING, ROGUE_CE_BOUNCY = ROGUE_CEF_BOUNCY,
	)
	return effects

/// Sets the rate of metabolism and the threshold of an overdose from the classes of the reagent. Not rogue_rg(): a reagent is made
/// while the globals are still being made, and a global cannot be read then.
/datum/reagent/proc/rogue_set_rates()
	if(rogue_rate)
		metabolization_rate = rogue_value("alch_rg_rate_[rogue_rate]") / ROGUE_REAGENT_TICK
	if(rogue_overdose)
		overdose_threshold = rogue_value("alch_rg_overdose_[rogue_overdose]")

/// The channels of the reagent with their numbers, the ones a poison-resilient body takes with their _resist numbers: read once for
/// each type and revision of the mechanics numbers.
/datum/reagent/proc/rogue_profile(resist = FALSE)
	rogue_rg_fresh()
	var/list/cache = resist ? GLOB.rogue_rg_resist_profiles : GLOB.rogue_rg_profiles
	var/list/profile = cache[type]
	if(!isnull(profile))
		return profile
	profile = list()
	var/list/channels = rogue_rg_channels()
	for(var/channel in channels)
		var/bit = channels[channel]
		if(!(rogue_channels & bit))
			continue
		var/suffix = (resist && (rogue_resist_channels & bit)) ? "_resist" : ""
		var/number = rogue_value("alch_rg_[rogue_key]_[channel][suffix]")
		profile[channel] = (rogue_minus_channels & bit) ? -abs(number) : number
	cache[type] = profile
	return profile

// ---------------------------------------------------------------------------------------------------------------------------
// The engine: what the reagent does to the body each Life tick, what it keeps in the body while it lasts, what it does to a limb.

/// One Life tick of the reagent in the blood of the body (called by the on_mob_life() of the bases below): the shedding of a
/// potion, the channels, and what the reagent does besides (rogue_extra()). UPDATE_MOB_HEALTH when the health changed.
/datum/reagent/proc/rogue_tick(mob/living/carbon/affected_mob, seconds_per_tick)
	. = NONE
	if(rogue_shed && holder && volume >= rogue_rg("shed_volume"))
		holder.remove_reagent(type, rogue_rg("shed") * seconds_per_tick / ROGUE_REAGENT_TICK)
	. |= rogue_life(affected_mob, seconds_per_tick)
	. |= rogue_extra(affected_mob, seconds_per_tick)

/// What the reagent does besides its channels (a type with a chance, a condition or a trait of its own overrides this).
/datum/reagent/proc/rogue_extra(mob/living/carbon/affected_mob, seconds_per_tick)
	return NONE

/// The channels, each by its number a Vibelin tick and the share of it this tick is.
/datum/reagent/proc/rogue_life(mob/living/carbon/affected_mob, seconds_per_tick)
	. = NONE
	if(!rogue_channels)
		return
	var/gated = FALSE
	switch(rogue_gate)
		if(ROGUE_GATE_POTION)
			gated = volume < rogue_rg("gate_potion")
		if(ROGUE_GATE_POISON)
			gated = volume < rogue_rg("gate_poison")
	var/list/channels = rogue_rg_channels()
	var/list/profile = rogue_profile(rogue_resist_channels && rogue_poison_resilient(affected_mob))
	var/ticks = seconds_per_tick / ROGUE_REAGENT_TICK
	for(var/channel in profile)
		if(gated && !(rogue_ungated & channels[channel]))
			continue
		var/amount = profile[channel] * ticks
		switch(channel)
			if("brute")
				if(affected_mob.adjust_brute_loss(amount, updating_health = FALSE))
					. = UPDATE_MOB_HEALTH
			if("burn")
				if(affected_mob.adjust_fire_loss(amount, updating_health = FALSE))
					. = UPDATE_MOB_HEALTH
			if("tox")
				if(affected_mob.adjust_tox_loss(amount, updating_health = FALSE))
					. = UPDATE_MOB_HEALTH
			if("oxy")
				if(affected_mob.adjust_oxy_loss(amount, updating_health = FALSE))
					. = UPDATE_MOB_HEALTH
			if("stamina")
				if(affected_mob.adjust_stamina_loss(amount, updating_stamina = FALSE))
					. = UPDATE_MOB_HEALTH
			if("brain")
				affected_mob.adjust_organ_loss(ORGAN_SLOT_BRAIN, amount)
			if("eyes")
				affected_mob.adjust_organ_loss(ORGAN_SLOT_EYES, amount)
			if("lungs")
				affected_mob.adjust_organ_loss(ORGAN_SLOT_LUNGS, amount)
			if("heart")
				affected_mob.adjust_organ_loss(ORGAN_SLOT_HEART, amount)
			if("wounds")
				affected_mob.rogue_heal_wounds(amount)
			if("blood")
				affected_mob.adjust_blood_volume(amount, maximum = BLOOD_VOLUME_NORMAL)
			if("energy")
				if(ishuman(affected_mob))
					var/mob/living/carbon/human/person = affected_mob
					person.rogue_energy_add(amount)
			if("mana")
				// Mana to the body's pool (magic/mana.dm, the block's contract), not energy; up to its soft cap.
				var/datum/rogue_mana/pool = rogue_mana_of(affected_mob)
				pool?.adjust(amount, safe = TRUE)
			if("nausea")
				affected_mob.adjust_disgust(amount * ROGUE_NAUSEA_TO_DISGUST)
			if("dizzy")
				affected_mob.adjust_dizzy(amount)
			if("jitter")
				affected_mob.adjust_jitter(amount)
			if("confusion")
				affected_mob.adjust_confusion(amount)
			if("drowsy")
				affected_mob.adjust_drowsiness(amount)
			if("blur")
				affected_mob.set_eye_blur_if_lower(amount)

/// The body keeps (or, apply FALSE, gives up) the chemical effects of the reagent: each one's power is <key>_ce_<effect>. The
/// source is the type, so that two reagents of one effect add up and each goes on its own (combat/chem_effects.dm).
/datum/reagent/proc/rogue_apply_effects(mob/living/affected_mob, apply = TRUE)
	if(!rogue_effects)
		return
	var/list/effects = rogue_rg_effects()
	for(var/effect in effects)
		if(!(rogue_effects & effects[effect]))
			continue
		if(apply)
			var/power = rogue_rg("[rogue_key]_ce_[effect]")
			affected_mob.rogue_add_chem_effect(effect, (rogue_minus_effects & effects[effect]) ? -abs(power) : power, "[type]")
		else
			affected_mob.rogue_remove_chem_effect(effect, "[type]")
	if(rogue_effects & (ROGUE_CEF_SHRINKING|ROGUE_CEF_ENLARGING))
		affected_mob.rogue_update_effect_scaling()

/mob/living
	/// The scale of the body the chemical effects of size have made it (Vibelin last_scale_number); 1 when they have done nothing.
	var/rogue_effect_scale = 1

/// Vibelin update_effect_scaling(): the body is as big as the enlarging effects less the shrinking ones make it (a tenth of its
/// size a point, never under a fifth of it).
/mob/living/proc/rogue_update_effect_scaling()
	var/new_scale = max(0.2, 1 + (rogue_get_chem_effect(ROGUE_CE_ENLARGING) - rogue_get_chem_effect(ROGUE_CE_SHRINKING)) * rogue_value("alch_rg_size_step"))
	var/old_scale = rogue_effect_scale
	rogue_effect_scale = new_scale
	if(old_scale && new_scale != old_scale)
		update_transform(new_scale / old_scale)

/// Whether a reagent that the dwarves shrug off works on the body in full (Ratwood isdwarf(); Vibelin TRAIT_POISON_RESILIENCE).
/proc/rogue_poison_resilient(mob/living/carbon/target)
	return rogue_is_dwarf(target)

/// Whether the body is of a species of Vibelin (a path of Vibelin's species, the module's rogue_vibelin_type, and its kin).
/proc/rogue_vibelin_species(mob/living/carbon/target, species_path)
	var/datum/species/kind = target?.dna?.species
	return kind && findtext(kind.rogue_vibelin_type, species_path) == 1

/// Vibelin on_bodypart_absorb(): what the reagent does to the limb a bandage lets it into (the cloth lets it in by its rate of
/// metabolism, combat/medicine.dm rogue_seep_tick()). TRUE when it goes into the body as it is, FALSE when this is all it does.
/datum/reagent/proc/rogue_bodypart_absorb(mob/living/carbon/affected_mob, obj/item/bodypart/limb, amount)
	if(!rogue_absorbs)
		return TRUE
	var/healing = rogue_absorbs & (ROGUE_ABS_INJURY_HEAL|ROGUE_ABS_SALVE)
	var/heal = (rogue_absorbs & ROGUE_ABS_INJURY_HEAL) ? rogue_rg("[rogue_key]_absorb_injury_heal") : 0
	var/germs = (rogue_absorbs & ROGUE_ABS_INJURY_GERMS) ? rogue_rg("[rogue_key]_absorb_injury_germs") : 0
	if(heal || germs || (rogue_absorbs & ROGUE_ABS_SALVE))
		for(var/datum/rogue_injury/injury as anything in limb.rogue_injuries?.Copy())
			if(healing && !injury.can_heal())
				continue
			if((rogue_absorbs & ROGUE_ABS_FIRE_ONLY) && !injury.is_fire())
				continue
			if(germs)
				injury.adjust_germ_level(-germs)
			if(rogue_absorbs & ROGUE_ABS_SALVE)
				injury.injury_flags |= ROGUE_INJ_SALVED
			if(heal)
				injury.heal_damage(heal)
	var/brute = (rogue_absorbs & ROGUE_ABS_BRUTE) ? rogue_rg("[rogue_key]_absorb_brute") : 0
	var/burn = (rogue_absorbs & ROGUE_ABS_BURN) ? rogue_rg("[rogue_key]_absorb_burn") : 0
	if(brute || burn)
		limb.heal_damage(brute, burn)
	if(rogue_absorbs & ROGUE_ABS_LIMB_GERMS)
		limb.rogue_adjust_germs(-rogue_rg("[rogue_key]_absorb_limb_germs"))
	if(rogue_absorbs & ROGUE_ABS_DISINFECT)
		limb.rogue_flag_injuries(ROGUE_INJURY_ANY, ROGUE_INJ_DISINFECTED)
	return !!(rogue_absorbs & ROGUE_ABS_ENTERS)

// ---------------------------------------------------------------------------------------------------------------------------
// The base of the medicines of Vibelin: the potions below and the herbal ones of medicines.dm.

/datum/reagent/medicine/rogue_herbal
	abstract_type = /datum/reagent/medicine/rogue_herbal
	rogue_minus_channels = ROGUE_RG_HEALS
	rogue_rate = "potion"
	rogue_gate = ROGUE_GATE_POTION

/datum/reagent/medicine/rogue_herbal/New()
	. = ..()
	rogue_set_rates()

/datum/reagent/medicine/rogue_herbal/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	. |= rogue_tick(affected_mob, seconds_per_tick)

/datum/reagent/medicine/rogue_herbal/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	rogue_apply_effects(affected_mob)

/datum/reagent/medicine/rogue_herbal/on_mob_end_metabolize(mob/living/affected_mob, metabolization_ratio)
	. = ..()
	rogue_apply_effects(affected_mob, FALSE)

/datum/reagent/medicine/rogue_herbal/on_mob_delete(mob/living/affected_mob)
	. = ..()
	rogue_apply_effects(affected_mob, FALSE)

// ---------------------------------------------------------------------------------------------------------------------------
// The potions.

/// Vibelin's health potions: they mend the wounds, refill blood to normal, heal brute, burn and oxygen when there is enough of them
/// in the blood, steady the heart and keep the blood coming back. Over alch_rg_shed_volume units the body sheds the excess.
/datum/reagent/medicine/healthpot
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "healthpot"
	rogue_channels = ROGUE_RG_BRUTE|ROGUE_RG_BURN|ROGUE_RG_OXY|ROGUE_RG_WOUNDS|ROGUE_RG_BLOOD
	rogue_ungated = ROGUE_RG_WOUNDS|ROGUE_RG_BLOOD
	rogue_effects = ROGUE_CEF_BLOODRESTORE|ROGUE_CEF_STABLE
	rogue_shed = TRUE

/// Heals four times as fast and spends itself twice as fast; it brings the brain back with it.
/datum/reagent/medicine/stronghealth
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "stronghealth"
	rogue_rate = "quick"
	rogue_channels = ROGUE_RG_BRUTE|ROGUE_RG_BURN|ROGUE_RG_OXY|ROGUE_RG_WOUNDS|ROGUE_RG_BLOOD
	rogue_ungated = ROGUE_RG_WOUNDS|ROGUE_RG_BLOOD
	rogue_effects = ROGUE_CEF_BLOODRESTORE|ROGUE_CEF_STABLE|ROGUE_CEF_BRAIN_REGEN
	rogue_shed = TRUE

/// Vibelin's mana potions give mana to the pool of the one who drinks (up to the soft cap, as Vibelin's safe adjustment does), not energy.
/datum/reagent/medicine/manapot
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "manapot"
	rogue_channels = ROGUE_RG_MANA
	rogue_gate = ROGUE_GATE_NONE

/datum/reagent/medicine/manapot/weak
	rogue_key = "manapot_weak"

/datum/reagent/medicine/strongmana
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "strongmana"
	rogue_rate = "potion_strong"
	rogue_channels = ROGUE_RG_MANA
	rogue_gate = ROGUE_GATE_NONE

/// Vibelin's stamina potions take the fatigue off.
/datum/reagent/medicine/stampot
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "stampot"
	rogue_channels = ROGUE_RG_STAMINA
	rogue_gate = ROGUE_GATE_NONE

/datum/reagent/medicine/strongstam
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "strongstam"
	rogue_rate = "potion_strong"
	rogue_channels = ROGUE_RG_STAMINA
	rogue_gate = ROGUE_GATE_NONE

/// Vibelin's blood potions refill blood (their vitae is the vampires' and the module has none). Over the shed volume the body sheds them.
/datum/reagent/medicine/bloodpot
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "bloodpot"
	rogue_channels = ROGUE_RG_BLOOD
	rogue_gate = ROGUE_GATE_NONE
	rogue_shed = TRUE

/datum/reagent/medicine/strongbloodpot
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "strongbloodpot"
	rogue_channels = ROGUE_RG_BLOOD
	rogue_gate = ROGUE_GATE_NONE
	rogue_shed = TRUE

/// Vibelin's antidote heals the toxins the blood carries. (Ratwood's one purged every poison too; its strong antidote below still does.)
/datum/reagent/medicine/antidote
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "antidote"
	rogue_channels = ROGUE_RG_TOX

/// Heals the toxins fast, keeps infection off the body and cleans the limb it is let into.
/datum/reagent/medicine/diseasecure
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "diseasecure"
	rogue_rate = "potion_strong"
	rogue_channels = ROGUE_RG_TOX
	rogue_effects = ROGUE_CEF_ANTIBIOTIC
	rogue_absorbs = ROGUE_ABS_INJURY_GERMS|ROGUE_ABS_LIMB_GERMS|ROGUE_ABS_DISINFECT

/// Ratwood's strong antidote (Vibelin has none): about three times as potent as the antidote, and it purges the poisons from the
/// blood a little each tick (Ratwood's antidote did; it named the reagent to purge wrongly and purged nothing, here it purges).
/datum/reagent/medicine/strong_antidote
	parent_type = /datum/reagent/medicine/rogue_herbal
	name = "Strong Antidote"
	description = "Purges poisons from the blood and mends what they did."
	color = "#004200"
	taste_description = "dirt"
	rogue_key = "strong_antidote"
	rogue_rate = "strong_antidote"
	rogue_channels = ROGUE_RG_TOX

/datum/reagent/medicine/strong_antidote/rogue_extra(mob/living/carbon/affected_mob, seconds_per_tick)
	var/purge = rogue_rg("strong_antidote_purge") * seconds_per_tick / ROGUE_REAGENT_TICK
	for(var/datum/reagent/poison as anything in holder.reagent_list)
		if(poison.rogue_harmful)
			holder.remove_reagent(poison.type, purge)
	return NONE

/// Steeped roses mend a little; to the beasts they are a poison.
/datum/reagent/medicine/rosawater
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "rosawater"
	rogue_channels = ROGUE_RG_BRUTE|ROGUE_RG_BURN|ROGUE_RG_OXY|ROGUE_RG_WOUNDS
	rogue_gate = ROGUE_GATE_NONE

/datum/reagent/medicine/rosawater/rogue_life(mob/living/carbon/affected_mob, seconds_per_tick)
	if(!(affected_mob.mob_biotypes & MOB_BEAST))
		return ..()
	if(affected_mob.adjust_fire_loss(rogue_rg("rosawater_beast_burn") * seconds_per_tick / ROGUE_REAGENT_TICK, updating_health = FALSE))
		return UPDATE_MOB_HEALTH
	return NONE

/// Changes the sex of whoever drinks it.
/datum/reagent/medicine/gender_potion
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_rate = "gender"

/datum/reagent/medicine/gender_potion/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(!ishuman(affected_mob) || affected_mob.stat == DEAD)
		to_chat(affected_mob, span_warning("The potion can only be used on living things!"))
		return
	var/mob/living/carbon/human/drinker = affected_mob
	if(drinker.gender != MALE && drinker.gender != FEMALE)
		to_chat(drinker, span_warning("The potion can only be used on gendered things!"))
		return
	if(drinker.gender == MALE)
		drinker.gender = FEMALE
		drinker.physique = FEMALE
		drinker.visible_message(span_boldnotice("[drinker] suddenly looks more feminine!"), span_boldwarning("You suddenly feel more feminine!"))
	else
		drinker.gender = MALE
		drinker.physique = MALE
		drinker.visible_message(span_boldnotice("[drinker] suddenly looks more masculine!"), span_boldwarning("You suddenly feel more masculine!"))
	drinker.update_body()
	drinker.regenerate_icons()

/// Vibelin's soporific: it clouds the head and drains energy, then tires the body or puts it to sleep once it is tired enough.
/datum/reagent/medicine/soporpot
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "soporpot"
	rogue_channels = ROGUE_RG_CONFUSION|ROGUE_RG_DIZZY|ROGUE_RG_ENERGY
	rogue_minus_channels = ROGUE_RG_HEALS|ROGUE_RG_ENERGY
	rogue_gate = ROGUE_GATE_NONE

/datum/reagent/medicine/soporpot/rogue_extra(mob/living/carbon/affected_mob, seconds_per_tick)
	var/ticks = seconds_per_tick / ROGUE_REAGENT_TICK
	if(affected_mob.get_stamina_loss() > rogue_rg("soporpot_tired"))
		affected_mob.adjust_drowsiness(rogue_rg("soporpot_drowsy") * ticks)
	else if(affected_mob.adjust_stamina_loss(rogue_rg("soporpot_stamina") * ticks, updating_stamina = FALSE))
		return UPDATE_MOB_HEALTH
	return NONE

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

/// The alchemy's reactions (these and Vibelin's, alchemy/vibelin/reactions.dm) happen on medieval maps only: two of Vibelin's
/// are made of TG reagents alone, and a TG chemist would brew Vibelin's poisons (review of block VA1).
/datum/chemical_reaction/rogue_alchemy/pre_reaction_other_checks(datum/reagents/holder)
	return rogue_medieval_map() && ..()

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
