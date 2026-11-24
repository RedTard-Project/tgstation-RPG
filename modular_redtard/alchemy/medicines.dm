// Vibelin's herbal medicines (reagents/chemistry/reagents/medicine_reagents.dm) and the other reagents that only keep a chemical
// effect or a mend of a limb (adrenaline, endorphin, the drugs of size and leaping, bone marrow). Each is data for the engine of
// alchemy/potions.dm: the channels it works through, the effects it keeps in the body, what it does to the limb a bandage lets it
// into, and the oddity of its own (rogue_extra()). Their names, descriptions, colours, tastes and scents are the generator's.
// Vibelin's atropine is TG's, and TG's stays.

/// A chance in percent a Vibelin tick, taken once a tick: the share of it this tick is.
/datum/reagent/proc/rogue_roll(percent, seconds_per_tick)
	return prob(percent * seconds_per_tick / ROGUE_REAGENT_TICK)

/// Burns, toxins and the lungs of the ones who go near volcanic vents; it turns the stomach now and then.
/datum/reagent/medicine/ashwarden_brew
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "ashwarden"
	rogue_channels = ROGUE_RG_BURN|ROGUE_RG_TOX|ROGUE_RG_LUNGS
	rogue_ungated = ROGUE_RG_LUNGS

/datum/reagent/medicine/ashwarden_brew/rogue_extra(mob/living/carbon/affected_mob, seconds_per_tick)
	if(rogue_roll(rogue_rg("ashwarden_nausea_chance"), seconds_per_tick))
		affected_mob.adjust_disgust(rogue_rg("ashwarden_nausea") * ROGUE_NAUSEA_TO_DISGUST)
	return NONE

/// Slow and long: it stays in the blood long after the rest have faded.
/datum/reagent/medicine/thornmorrow_tincture
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "thornmorrow"
	rogue_rate = "thornmorrow"
	rogue_channels = ROGUE_RG_BRUTE|ROGUE_RG_BURN|ROGUE_RG_TOX|ROGUE_RG_WOUNDS

/// Brings the brain and the organs back.
/datum/reagent/medicine/soulweave_distillate
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "soulweave"
	rogue_rate = "fast"
	rogue_channels = ROGUE_RG_BRAIN
	rogue_effects = ROGUE_CEF_BRAIN_REGEN|ROGUE_CEF_ORGAN_REGEN|ROGUE_CEF_STABLE|ROGUE_CEF_BLOODRESTORE

/// Numbs and cools a burn; on a bandage it heals the limb's burns.
/datum/reagent/medicine/coldvein_compress
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "coldvein"
	rogue_channels = ROGUE_RG_BURN
	rogue_effects = ROGUE_CEF_PAINKILLER
	rogue_absorbs = ROGUE_ABS_BURN

/// Seals wounds from the inside; on a bandage it heals the limb's bruises and cuts.
/datum/reagent/medicine/ichor_of_mending
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "ichor"
	rogue_rate = "mild"
	rogue_channels = ROGUE_RG_BRUTE|ROGUE_RG_WOUNDS
	rogue_absorbs = ROGUE_ABS_BRUTE

/// A salve for burns: on a bandage it cleans and mends the injuries of fire, and it goes into the body besides.
/datum/reagent/medicine/ashbinders_salve
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "ashbinders"
	rogue_channels = ROGUE_RG_BURN
	rogue_absorbs = ROGUE_ABS_INJURY_HEAL|ROGUE_ABS_INJURY_GERMS|ROGUE_ABS_LIMB_GERMS|ROGUE_ABS_DISINFECT|ROGUE_ABS_FIRE_ONLY|ROGUE_ABS_ENTERS

/// Oxygen and breath, and blood that comes back.
/datum/reagent/medicine/vitalroot_draught
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "vitalroot"
	rogue_channels = ROGUE_RG_OXY|ROGUE_RG_LUNGS
	rogue_effects = ROGUE_CEF_OXYGENATED|ROGUE_CEF_BLOODRESTORE

/// Toxins and infection.
/datum/reagent/medicine/tombsilt_tincture
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "tombsilt"
	rogue_channels = ROGUE_RG_TOX
	rogue_effects = ROGUE_CEF_ANTIBIOTIC

/// Cleanses infected wounds on a bandage; swallowed, it poisons a little.
/datum/reagent/medicine/mirewort_compress
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "mirewort"
	rogue_rate = "slow"
	rogue_channels = ROGUE_RG_TOX
	rogue_minus_channels = ROGUE_RG_HEALS & ~ROGUE_RG_TOX
	rogue_absorbs = ROGUE_ABS_INJURY_GERMS|ROGUE_ABS_LIMB_GERMS|ROGUE_ABS_DISINFECT

/// Closes the lacerations it is laid on; swallowed, it does next to nothing.
/datum/reagent/medicine/woundwrack_oil
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "woundwrack"
	rogue_channels = ROGUE_RG_BRUTE
	rogue_absorbs = ROGUE_ABS_INJURY_HEAL|ROGUE_ABS_SALVE|ROGUE_ABS_LIMB_GERMS

/// Brain, eyes and organs, not wounds.
/datum/reagent/medicine/pale_serum
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "paleserum"
	rogue_rate = "mild"
	rogue_channels = ROGUE_RG_BRAIN|ROGUE_RG_EYES
	rogue_effects = ROGUE_CEF_BRAIN_REGEN|ROGUE_CEF_ORGAN_REGEN

/// Heals fast and shrinks the one who drinks it.
/datum/reagent/medicine/spiritwood_elixir
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "spiritwood"
	rogue_rate = "quick"
	rogue_channels = ROGUE_RG_BRUTE|ROGUE_RG_BURN|ROGUE_RG_WOUNDS
	rogue_effects = ROGUE_CEF_STABLE|ROGUE_CEF_BLOODRESTORE|ROGUE_CEF_SHRINKING

/// A little of everything, and energy.
/datum/reagent/medicine/marrowbrew
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "marrowbrew"
	rogue_rate = "slow"
	rogue_channels = ROGUE_RG_BRUTE|ROGUE_RG_BURN|ROGUE_RG_TOX|ROGUE_RG_OXY
	rogue_effects = ROGUE_CEF_BLOODRESTORE|ROGUE_CEF_ENERGETIC

/// Clears the head.
/datum/reagent/medicine/mindclear_tonic
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "mindclear"
	rogue_rate = "fast"
	rogue_channels = ROGUE_RG_BRAIN|ROGUE_RG_CONFUSION|ROGUE_RG_DIZZY
	rogue_minus_channels = ROGUE_RG_HEALS|ROGUE_RG_CONFUSION|ROGUE_RG_DIZZY
	rogue_effects = ROGUE_CEF_BRAIN_REGEN

/// A paste for cuts: on a bandage it salves the injuries and mends them a little.
/datum/reagent/medicine/witchknit_paste
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "witchknit"
	rogue_channels = ROGUE_RG_BRUTE
	rogue_absorbs = ROGUE_ABS_INJURY_HEAL|ROGUE_ABS_SALVE|ROGUE_ABS_LIMB_GERMS

/// Burns the infection out and the head spins now and then.
/datum/reagent/medicine/fever_oil
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "feveroil"
	rogue_channels = ROGUE_RG_TOX
	rogue_effects = ROGUE_CEF_ANTIBIOTIC

/datum/reagent/medicine/fever_oil/rogue_extra(mob/living/carbon/affected_mob, seconds_per_tick)
	if(rogue_roll(rogue_rg("feveroil_chance"), seconds_per_tick))
		affected_mob.adjust_dizzy(rogue_rg("feveroil_dizzy"))
		affected_mob.set_jitter(rogue_rg("feveroil_jitter"))
	return NONE

/// Bruises and wounds.
/datum/reagent/medicine/stonevein_broth
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "stonevein"
	rogue_rate = "mild"
	rogue_channels = ROGUE_RG_BRUTE|ROGUE_RG_WOUNDS

/// Toxins and infection, a little of bruises.
/datum/reagent/medicine/sunpetal_decoction
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "sunpetal"
	rogue_rate = "slow"
	rogue_channels = ROGUE_RG_BRUTE|ROGUE_RG_TOX
	rogue_effects = ROGUE_CEF_ANTIBIOTIC

/// Kills pain, and sets the hands shaking now and then.
/datum/reagent/medicine/nervebind_extract
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "nervebind"
	rogue_effects = ROGUE_CEF_PAINKILLER|ROGUE_CEF_STABLE

/datum/reagent/medicine/nervebind_extract/rogue_extra(mob/living/carbon/affected_mob, seconds_per_tick)
	if(rogue_roll(rogue_rg("nervebind_chance"), seconds_per_tick))
		affected_mob.adjust_jitter(rogue_rg("nervebind_jitter"))
	return NONE

/// Blood and a quicker pulse, a stronger heart; the head spins now and then.
/datum/reagent/medicine/bloodelder_wine
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "bloodelder"
	rogue_channels = ROGUE_RG_HEART
	rogue_ungated = ROGUE_RG_HEART
	rogue_effects = ROGUE_CEF_BLOODRESTORE|ROGUE_CEF_PULSE

/datum/reagent/medicine/bloodelder_wine/rogue_extra(mob/living/carbon/affected_mob, seconds_per_tick)
	if(rogue_roll(rogue_rg("bloodelder_chance"), seconds_per_tick))
		affected_mob.adjust_dizzy(rogue_rg("bloodelder_dizzy"))
	return NONE

/// Steadies the body, breath and all, and makes it bigger.
/datum/reagent/medicine/crystalline_lymph
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "lymph"
	rogue_rate = "quick"
	rogue_effects = ROGUE_CEF_STABLE|ROGUE_CEF_OXYGENATED|ROGUE_CEF_ENLARGING

/// The body's own painkiller (combat/pain.dm has its own endorphins as a status; this is the draught of it): it numbs; in excess
/// it makes drowsy, sick and jittery.
/datum/reagent/medicine/endorphin
	parent_type = /datum/reagent/medicine/rogue_herbal
	rogue_key = "endorphin"
	rogue_rate = "slow"
	rogue_overdose = "endorphin"
	rogue_effects = ROGUE_CEF_PAINKILLER

/datum/reagent/medicine/endorphin/overdose_start(mob/living/affected_mob, metabolization_ratio)
	. = ..()
	to_chat(affected_mob, span_userdanger("I feel EUPHORIC!"))

/datum/reagent/medicine/endorphin/overdose_process(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/ticks = seconds_per_tick / ROGUE_REAGENT_TICK
	if(rogue_roll(rogue_rg("endorphin_drowsy_chance"), seconds_per_tick))
		affected_mob.adjust_drowsiness(rogue_rg("endorphin_drowsy"))
	if(rogue_roll(rogue_rg("endorphin_disgust_chance"), seconds_per_tick))
		affected_mob.adjust_disgust(rogue_rg("endorphin_disgust"))
	affected_mob.adjust_jitter(rogue_rg("endorphin_jitter") * ticks)

// ---------------------------------------------------------------------------------------------------------------------------
// What is not a medicine of the engine's tree and keeps an effect or two.

/// The base of the reagents that keep chemical effects and nothing else (and the base of the drugs among them).
/datum/reagent/rogue_effect
	abstract_type = /datum/reagent/rogue_effect
	rogue_minus_channels = ROGUE_RG_HEALS

/datum/reagent/rogue_effect/New()
	. = ..()
	rogue_set_rates()

/datum/reagent/rogue_effect/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	. |= rogue_tick(affected_mob, seconds_per_tick)

/datum/reagent/rogue_effect/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	rogue_apply_effects(affected_mob)

/datum/reagent/rogue_effect/on_mob_end_metabolize(mob/living/affected_mob, metabolization_ratio)
	. = ..()
	rogue_apply_effects(affected_mob, FALSE)

/datum/reagent/rogue_effect/on_mob_delete(mob/living/affected_mob)
	. = ..()
	rogue_apply_effects(affected_mob, FALSE)

/datum/reagent/drug/rogue_effect
	abstract_type = /datum/reagent/drug/rogue_effect

/datum/reagent/drug/rogue_effect/New()
	. = ..()
	rogue_set_rates()

/datum/reagent/drug/rogue_effect/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	rogue_apply_effects(affected_mob)

/datum/reagent/drug/rogue_effect/on_mob_end_metabolize(mob/living/affected_mob, metabolization_ratio)
	. = ..()
	rogue_apply_effects(affected_mob, FALSE)

/datum/reagent/drug/rogue_effect/on_mob_delete(mob/living/affected_mob)
	. = ..()
	rogue_apply_effects(affected_mob, FALSE)

/// The second wind of a wound: blood, a stimulant, a quicker pulse and a numbness that grows with the dose.
/datum/reagent/adrenaline
	parent_type = /datum/reagent/rogue_effect
	rogue_key = "adrenaline"
	rogue_rate = "slow"
	rogue_effects = ROGUE_CEF_BLOODRESTORE|ROGUE_CEF_STIMULANT|ROGUE_CEF_PULSE
	self_consuming = TRUE

/datum/reagent/adrenaline/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.rogue_add_chem_effect(ROGUE_CE_PAINKILLER, min(rogue_rg("adrenaline_painkiller_unit") * volume, rogue_rg("adrenaline_painkiller_max")), "[type]")

/datum/reagent/adrenaline/on_mob_end_metabolize(mob/living/affected_mob, metabolization_ratio)
	. = ..()
	affected_mob.rogue_remove_chem_effect(ROGUE_CE_PAINKILLER, "[type]")

/// Makes the one who drinks it bigger.
/datum/reagent/drug/gravitum_elixir
	parent_type = /datum/reagent/drug/rogue_effect
	rogue_key = "gravitum"
	rogue_rate = "elixir"
	rogue_effects = ROGUE_CEF_ENLARGING

/// Makes the one who drinks it springy: it throws off what it hits.
/datum/reagent/drug/phlogiston_elasticum
	parent_type = /datum/reagent/drug/rogue_effect
	rogue_key = "phlogiston"
	rogue_rate = "elixir"
	rogue_effects = ROGUE_CEF_BOUNCY

/// Makes the one who drinks it smaller.
/datum/reagent/drug/subtilum_tincture
	parent_type = /datum/reagent/drug/rogue_effect
	rogue_key = "subtilum"
	rogue_rate = "elixir"
	rogue_effects = ROGUE_CEF_SHRINKING

/// Bone marrow brings the blood back.
/datum/reagent/consumable/nutriment/bone_marrow
	brute_heal = 1
	burn_heal = 1
	rogue_key = "bonemarrow"
	rogue_effects = ROGUE_CEF_BLOODRESTORE

/datum/reagent/consumable/nutriment/bone_marrow/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	rogue_apply_effects(affected_mob)

/datum/reagent/consumable/nutriment/bone_marrow/on_mob_end_metabolize(mob/living/affected_mob, metabolization_ratio)
	. = ..()
	rogue_apply_effects(affected_mob, FALSE)

/// Ash of the dead: it goes out slowly.
/datum/reagent/undeadash
	parent_type = /datum/reagent/rogue_effect
	rogue_rate = "undeadash"

/// Soap goes out quickly enough.
/datum/reagent/soap
	parent_type = /datum/reagent/rogue_effect
	rogue_rate = "soap"

/// The base of Vibelin's elixirs of skills: a slow reagent that raises a skill while it is in the blood. The base only: what each
/// elixir does (a status effect of the skill) is block ВА2's.
/datum/reagent/skill_elixir
	parent_type = /datum/reagent/rogue_effect
	abstract_type = /datum/reagent/skill_elixir
	rogue_rate = "skill_elixir"

/// Vibelin self_healing_effect (organs/_organ.dm can_self_heal()): under organ regeneration (the brain under its own effect,
/// ROGUE_CE_BRAIN_REGEN, alchemy/_defines.dm) an organ heals by itself whatever else stops it. TG's on_life() already heals the
/// organs that work; this heals the failing ones too (called by the medicine's Life,
/// combat/blood.dm rogue_medicine_life()), at the organ's own TG healing_factor (no number of the module's).
/mob/living/carbon/proc/rogue_organ_regen(seconds_per_tick)
	var/organ_regen = rogue_get_chem_effect(ROGUE_CE_ORGAN_REGEN) > 0
	var/brain_regen = rogue_get_chem_effect(ROGUE_CE_BRAIN_REGEN) > 0
	if(!organ_regen && !brain_regen)
		return
	for(var/obj/item/organ/organ as anything in organs)
		if(!organ.damage || !organ.healing_factor || !(organ.organ_flags & ORGAN_FAILING) || IS_ROBOTIC_ORGAN(organ))
			continue
		if(!(istype(organ, /obj/item/organ/brain) ? brain_regen : organ_regen))
			continue
		organ.apply_organ_damage(-organ.healing_factor * organ.maxHealth * seconds_per_tick, organ.damage)
