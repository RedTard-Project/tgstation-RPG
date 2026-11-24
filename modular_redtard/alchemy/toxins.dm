// Vibelin's toxins and the rest of its poisons (reagents/chemistry/reagents/toxin_reagents.dm, special_reagents.dm): what lives
// under TG's /datum/reagent/toxin is written by hand (its base does the toxpwr of its own), the poisons that live under
// /datum/reagent/poison are data for the engine of alchemy/potions.dm like the ones of alchemy/poisons.dm, with a few oddities
// of their own (rogue_extra(), expose_mob()). Numbers are alch_rg_<key>_<channel>, see alchemy/potions.dm.
// Not ported: Vibelin's vitae users (bloodstone essence would not harm them), the clothes the ironblight eats, the frost of the
// cryzaline suspension and the sate and devour of the Psydonians (nothing of those systems is in the module).

/datum/reagent/toxin
	rogue_harmful = TRUE

/// Assassins' ice: toxins pour in, slowly, unless one is used to rotten food.
/datum/reagent/toxin/killersice
	toxpwr = 0
	rogue_key = "killersice"
	rogue_rate = "poison_slow"

/datum/reagent/toxin/killersice/New()
	. = ..()
	rogue_set_rates()

/datum/reagent/toxin/killersice/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(HAS_TRAIT(affected_mob, TRAIT_NASTY_EATER) || HAS_TRAIT(affected_mob, TRAIT_ORGAN_EATER))
		return
	if(affected_mob.adjust_tox_loss(rogue_rg("killersice_tox") * seconds_per_tick / ROGUE_REAGENT_TICK, updating_health = FALSE))
		return UPDATE_MOB_HEALTH

/// The nectar of the fyritius flower: now and then it turns the stomach, burns and sets one alight.
/datum/reagent/toxin/fyritiusnectar
	rogue_key = "fyritius"
	rogue_rate = "fyritius"

/datum/reagent/toxin/fyritiusnectar/New()
	. = ..()
	rogue_set_rates()

/datum/reagent/toxin/fyritiusnectar/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(volume <= rogue_rg("fyritius_volume") || !rogue_roll(rogue_rg("fyritius_chance"), seconds_per_tick))
		return
	affected_mob.adjust_disgust(rogue_rg("fyritius_nausea") * ROGUE_NAUSEA_TO_DISGUST)
	if(affected_mob.adjust_fire_loss(rogue_rg("fyritius_burn"), updating_health = FALSE))
		. = UPDATE_MOB_HEALTH
	affected_mob.adjust_fire_stacks(rogue_rg("fyritius_stacks"))
	affected_mob.ignite_mob()

/// Fills the mana of the one who drinks it with as much as there is of it in the blood, past the soft cap, and poisons as a toxin.
/datum/reagent/toxin/manabloom_juice
	rogue_key = "manabloom"
	rogue_rate = "manabloom"

/datum/reagent/toxin/manabloom_juice/New()
	. = ..()
	rogue_set_rates()

/datum/reagent/toxin/manabloom_juice/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(!ishuman(affected_mob))
		return
	// Past the pool's soft cap (magic/mana.dm rogue_mana_of(), safe FALSE).
	var/datum/rogue_mana/pool = rogue_mana_of(affected_mob)
	pool?.adjust(volume * rogue_rg("manabloom_mana") * seconds_per_tick / ROGUE_REAGENT_TICK, safe = FALSE)

/// The venom of the Aragn spider: it paralyses for a few seconds now and then, and the stronger and luckier one is the less.
/datum/reagent/toxin/spidervenom_paralytic
	toxpwr = 0
	silent_toxin = TRUE
	rogue_key = "venom"
	rogue_rate = "venom"
	/// How well the body is able to fight it off (Vibelin venom_resistance), made when it first gets in.
	var/venom_resistance = 0

/datum/reagent/toxin/spidervenom_paralytic/New()
	. = ..()
	rogue_set_rates()

/datum/reagent/toxin/spidervenom_paralytic/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	var/middle = rogue_rg("venom_middle")
	venom_resistance = (affected_mob.rogue_stat(ROGUE_STAT_CONSTITUTION) - middle) * rogue_rg("venom_constitution")
	venom_resistance += (affected_mob.rogue_stat(ROGUE_STAT_WILLPOWER) - middle) * rogue_rg("venom_willpower")
	venom_resistance += (affected_mob.rogue_stat(ROGUE_STAT_STRENGTH) - middle) * rogue_rg("venom_strength")
	venom_resistance += affected_mob.rogue_stat(ROGUE_STAT_FORTUNE)
	if(venom_resistance <= 0)
		venom_resistance = affected_mob.rogue_stat(ROGUE_STAT_FORTUNE) * rogue_rg("venom_fortune")

/datum/reagent/toxin/spidervenom_paralytic/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/period = rogue_rg("venom_period")
	if(current_cycle % period)
		return
	if(!prob(venom_resistance / period))
		affected_mob.Paralyze(rogue_rg("venom_paralyze"))
	if(current_cycle >= rogue_rg("venom_late_cycle") && prob(venom_resistance))
		holder.remove_reagent(type, rogue_rg("venom_purge"))

/// The same venom of the pale gland, harmless: it is gone at once.
/datum/reagent/toxin/spidervenom_inert
	toxpwr = 0
	silent_toxin = TRUE
	rogue_rate = "venom_inert"

/datum/reagent/toxin/spidervenom_inert/New()
	. = ..()
	rogue_set_rates()

/// Vibelin's methamphetamine precursor: harmful to drink (what makes of it, TG's methamphetamine, stays TG's).
/datum/reagent/meth_precursor
	rogue_harmful = TRUE

/// Vibelin's sal petris: a splash of enough of it turns one to stone for a time.
/datum/reagent/sal_petris
	parent_type = /datum/reagent/rogue_effect
	rogue_rate = "salpetris"

/datum/reagent/sal_petris/expose_mob(mob/living/exposed_mob, methods = TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	if(reac_volume < rogue_rg("salpetris_min"))
		return
	exposed_mob.Stun(rogue_rg("salpetris_stun"))
	exposed_mob.petrify(reac_volume * rogue_rg("salpetris_time"))

// ---------------------------------------------------------------------------------------------------------------------------
// The poisons that live under /datum/reagent/poison (alchemy/poisons.dm has the base).

/// Drowns the lungs: oxygen and toxins, and after a while dizziness.
/datum/reagent/poison/mirelung_brew
	rogue_key = "mirelung"
	rogue_rate = "poison_mild"
	rogue_channels = ROGUE_RG_OXY|ROGUE_RG_TOX

/datum/reagent/poison/mirelung_brew/rogue_extra(mob/living/carbon/affected_mob, seconds_per_tick)
	if(current_cycle > rogue_rg("mirelung_cycle"))
		affected_mob.adjust_dizzy(rogue_rg("mirelung_dizzy") * seconds_per_tick / ROGUE_REAGENT_TICK)
	return NONE

/// Makes the hands shake, tires and poisons a little; a touch of it is enough to start the jitters.
/datum/reagent/poison/heatcramp_oil
	rogue_key = "heatcramp"
	rogue_rate = "poison_brisk"
	rogue_channels = ROGUE_RG_JITTER|ROGUE_RG_STAMINA|ROGUE_RG_TOX

/datum/reagent/poison/heatcramp_oil/expose_mob(mob/living/exposed_mob, methods = TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	if(methods & TOUCH)
		exposed_mob.set_jitter(rogue_rg("heatcramp_touch_jitter"))

/// Blinds and dizzies, and poisons a little; a splash of it in the eyes is enough.
/datum/reagent/poison/blinding_spore
	rogue_key = "blindspore"
	rogue_channels = ROGUE_RG_BLUR|ROGUE_RG_DIZZY|ROGUE_RG_TOX

/datum/reagent/poison/blinding_spore/expose_mob(mob/living/exposed_mob, methods = TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	if(!(methods & (TOUCH|VAPOR)) || reac_volume < rogue_rg("blindspore_volume"))
		return
	exposed_mob.adjust_eye_blur(rogue_rg("blindspore_touch_blur"))
	exposed_mob.adjust_dizzy(rogue_rg("blindspore_touch_dizzy"))
	if(show_message)
		exposed_mob.visible_message(span_danger("[exposed_mob] staggers, clutching at their eyes!"), span_userdanger("Your eyes burn and your vision whites out!"))

/// Tears the body apart from the inside, and takes the pulse and the blood with it.
/datum/reagent/poison/soulbane_ichor
	rogue_key = "soulbane"
	rogue_rate = "poison_brisk"
	rogue_channels = ROGUE_RG_BRUTE|ROGUE_RG_BURN|ROGUE_RG_TOX|ROGUE_RG_OXY
	rogue_effects = ROGUE_CEF_PULSE|ROGUE_CEF_BLOODRESTORE
	rogue_minus_effects = ROGUE_CEF_PULSE|ROGUE_CEF_BLOODRESTORE

/// Brute and toxins; a splash of it bruises (what it does to metal worn is not ported).
/datum/reagent/poison/ironblight
	rogue_key = "ironblight"
	rogue_channels = ROGUE_RG_BRUTE|ROGUE_RG_TOX

/datum/reagent/poison/ironblight/expose_mob(mob/living/exposed_mob, methods = TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	if(methods & (TOUCH|VAPOR))
		exposed_mob.adjust_brute_loss(reac_volume * rogue_rg("ironblight_touch"))

/// Silent until it detonates: nothing for twenty ticks, then the toxins mount with every tick it has been in the blood and the
/// brain goes; and when it leaves the body (or the body of it) a tenth tick on, what it has built up goes off at once.
/datum/reagent/poison/quietdeath
	rogue_key = "quietdeath"
	rogue_rate = "poison_slow"

/datum/reagent/poison/quietdeath/rogue_extra(mob/living/carbon/affected_mob, seconds_per_tick)
	if(current_cycle < rogue_rg("quietdeath_cycle"))
		return NONE
	var/ticks = seconds_per_tick / ROGUE_REAGENT_TICK
	. = NONE
	if(affected_mob.adjust_tox_loss(current_cycle * rogue_rg("quietdeath_tox") * ticks, updating_health = FALSE))
		. = UPDATE_MOB_HEALTH
	affected_mob.adjust_organ_loss(ORGAN_SLOT_BRAIN, rogue_rg("quietdeath_brain") * ticks)

/datum/reagent/poison/quietdeath/on_mob_delete(mob/living/affected_mob)
	if(current_cycle >= rogue_rg("quietdeath_burst_cycle"))
		affected_mob.adjust_tox_loss(current_cycle * rogue_rg("quietdeath_burst"))
	return ..()

/// Silver water: to the dead it is fire and ruin, to the living a little poison.
/datum/reagent/poison/mirrorwaste
	rogue_key = "mirrorwaste"

/datum/reagent/poison/mirrorwaste/expose_mob(mob/living/exposed_mob, methods = TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	if(!(exposed_mob.mob_biotypes & MOB_UNDEAD))
		return
	exposed_mob.adjust_brute_loss(reac_volume * rogue_rg("mirrorwaste_touch_brute"), updating_health = FALSE)
	exposed_mob.adjust_fire_loss(reac_volume * rogue_rg("mirrorwaste_touch_burn"))
	if(show_message)
		exposed_mob.visible_message(span_danger("[exposed_mob] writhes as the silvery liquid disrupts their form!"), span_userdanger("The liquid tears at your very existence!"))

/datum/reagent/poison/mirrorwaste/rogue_extra(mob/living/carbon/affected_mob, seconds_per_tick)
	var/ticks = seconds_per_tick / ROGUE_REAGENT_TICK
	. = NONE
	if(affected_mob.mob_biotypes & MOB_UNDEAD)
		if(affected_mob.adjust_brute_loss(rogue_rg("mirrorwaste_undead_brute") * ticks, updating_health = FALSE))
			. = UPDATE_MOB_HEALTH
		if(affected_mob.adjust_tox_loss(rogue_rg("mirrorwaste_undead_tox") * ticks, updating_health = FALSE))
			. = UPDATE_MOB_HEALTH
	else if(affected_mob.adjust_tox_loss(rogue_rg("mirrorwaste_tox") * ticks, updating_health = FALSE))
		. = UPDATE_MOB_HEALTH

/// A splash of it opens every wound and fouls it; on the unwounded flesh of a beast it is a blow.
/datum/reagent/poison/hexblood_poison
	rogue_key = "hexblood"
	rogue_rate = "poison_fast"

/datum/reagent/poison/hexblood_poison/expose_mob(mob/living/exposed_mob, methods = TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	if(!(methods & (TOUCH|VAPOR)))
		return
	var/mob/living/carbon/body = exposed_mob
	if(!istype(body))
		exposed_mob.adjust_brute_loss(reac_volume * rogue_rg("hexblood_beast"))
		return
	for(var/obj/item/bodypart/limb as anything in body.bodyparts)
		for(var/datum/rogue_injury/injury as anything in limb.rogue_injuries?.Copy())
			injury.open_injury(reac_volume * rogue_rg("hexblood_open"))
			injury.adjust_germ_level(reac_volume * rogue_rg("hexblood_germs"))

/// Drowns the blood: oxygen and toxins, and after a while dizziness.
/datum/reagent/poison/bloodstone_essence
	rogue_key = "bloodstone"
	rogue_rate = "poison_mild"
	rogue_channels = ROGUE_RG_OXY|ROGUE_RG_TOX

/datum/reagent/poison/bloodstone_essence/rogue_extra(mob/living/carbon/affected_mob, seconds_per_tick)
	if(current_cycle > rogue_rg("bloodstone_cycle"))
		affected_mob.adjust_dizzy(rogue_rg("bloodstone_dizzy") * seconds_per_tick / ROGUE_REAGENT_TICK)
	return NONE

/// Fouls the blood and wounds: the longer it stays the worse the toxins, it takes the body's guard against infection, and
/// where it is splashed the germs breed.
/datum/reagent/poison/rotwater
	rogue_key = "rotwater"
	rogue_rate = "poison_brisk"
	rogue_effects = ROGUE_CEF_ANTIBIOTIC
	rogue_minus_effects = ROGUE_CEF_ANTIBIOTIC

/datum/reagent/poison/rotwater/rogue_extra(mob/living/carbon/affected_mob, seconds_per_tick)
	var/ticks = seconds_per_tick / ROGUE_REAGENT_TICK
	. = NONE
	if(affected_mob.adjust_tox_loss(min(rogue_rg("rotwater_tox") + current_cycle * rogue_rg("rotwater_tox_cycle"), rogue_rg("rotwater_tox_max")) * ticks, updating_health = FALSE))
		. = UPDATE_MOB_HEALTH
	affected_mob.adjust_disgust(rogue_rg("rotwater_nausea") * ticks * ROGUE_NAUSEA_TO_DISGUST)
	if(current_cycle > rogue_rg("rotwater_late_cycle"))
		affected_mob.rogue_add_chem_effect(ROGUE_CE_ANTIBIOTIC, -abs(rogue_rg("rotwater_ce_antibiotic_late")), "[type]")

/datum/reagent/poison/rotwater/expose_mob(mob/living/exposed_mob, methods = TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	var/mob/living/carbon/body = exposed_mob
	if(!(methods & (TOUCH|VAPOR)) || !istype(body))
		return
	for(var/obj/item/bodypart/limb as anything in body.bodyparts)
		for(var/datum/rogue_injury/injury as anything in limb.rogue_injuries)
			if(injury.can_heal())
				injury.adjust_germ_level(reac_volume * rogue_rg("rotwater_germs"))

/// Clouds the head, and later damages the brain and the blood.
/datum/reagent/poison/gloomvenom
	rogue_key = "gloomvenom"
	rogue_rate = "poison_quick"
	rogue_channels = ROGUE_RG_CONFUSION|ROGUE_RG_DIZZY

/datum/reagent/poison/gloomvenom/rogue_extra(mob/living/carbon/affected_mob, seconds_per_tick)
	var/ticks = seconds_per_tick / ROGUE_REAGENT_TICK
	. = NONE
	if(current_cycle > rogue_rg("gloomvenom_brain_cycle"))
		affected_mob.adjust_organ_loss(ORGAN_SLOT_BRAIN, rogue_rg("gloomvenom_brain") * ticks)
	if(current_cycle > rogue_rg("gloomvenom_tox_cycle") && affected_mob.adjust_tox_loss(rogue_rg("gloomvenom_tox") * ticks, updating_health = FALSE))
		. = UPDATE_MOB_HEALTH

/// Burns; a splash of it catches fire on the skin.
/datum/reagent/poison/ashfall_dust
	rogue_key = "ashfall"
	rogue_channels = ROGUE_RG_BURN

/datum/reagent/poison/ashfall_dust/expose_mob(mob/living/exposed_mob, methods = TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	if(!(methods & (TOUCH|VAPOR)))
		return
	exposed_mob.adjust_fire_stacks(reac_volume * rogue_rg("ashfall_stacks"))
	exposed_mob.adjust_fire_loss(reac_volume * rogue_rg("ashfall_touch"))

/// Burns and poisons; a splash of it raises blisters.
/datum/reagent/poison/blistergall
	rogue_key = "blistergall"
	rogue_channels = ROGUE_RG_BURN|ROGUE_RG_TOX

/datum/reagent/poison/blistergall/expose_mob(mob/living/exposed_mob, methods = TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	if(!(methods & (TOUCH|VAPOR)))
		return
	exposed_mob.adjust_fire_loss(reac_volume * rogue_rg("blistergall_touch"))
	if(show_message)
		exposed_mob.visible_message(span_danger("[exposed_mob]'s skin erupts in blistering welts!"), span_userdanger("Your skin erupts in boiling blisters!"))
