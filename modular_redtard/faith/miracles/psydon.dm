/// The miracles of the weeping god (Ratwood code/datums/gods/patrons/old_god.dm: Boot-Check, Endure; code/modules/spells/roguetown/
/// oldgod.dm: Respite) that the basket (miracle.dm) did not have yet. The devout of Psydon turn most miracles away (miracle.dm
/// turned_away()); these are theirs. The numbers are in faith.txt, the ones of a cast by miracle_<value_key>_*.

#define ROGUE_PSYDON_ICON 'modular_redtard/faith/icons/psydonmiracles.dmi'

/// What a cross worn round the neck does to Psydon's miracles (Ratwood psicross_bonus): the finer the cross, the better. A
/// cross of the Archenemy does the opposite. Returns list(bonus, archenemy), the bonus a number of faith.txt by kind: "heal" for
/// the healing Endure brings the one who wears it, "mend" for the mending Respite brings the wearer.
/proc/rogue_psydon_cross(mob/living/carbon/human/wearer, kind)
	var/bonus = 0
	var/archenemy = FALSE
	for(var/obj/item/clothing/neck/worn in wearer.get_equipped_items(INCLUDE_HELD))
		switch(worn.type)
			if(/obj/item/clothing/neck/roguetown/psicross/wood)
				bonus = rogue_value("faith_psy_[kind]_wood")
			if(/obj/item/clothing/neck/roguetown/psicross/decrepit)
				bonus = rogue_value("faith_psy_[kind]_decrepit")
			if(/obj/item/clothing/neck/roguetown/psicross)
				bonus = rogue_value("faith_psy_[kind]_plain")
			if(/obj/item/clothing/neck/roguetown/psicross/silver, /obj/item/clothing/neck/roguetown/psicross/silver/sojourner, /obj/item/clothing/neck/roguetown/psicross/g)
				bonus = rogue_value("faith_psy_[kind]_silver")
			if(/obj/item/clothing/neck/roguetown/psicross/inhumen/ancient)
				archenemy = TRUE
	return list(bonus, archenemy)

/// The cross of the Archenemy laughs at one who calls on Psydon with it round the neck (Ratwood zcross_trigger): only a lux
/// freak goes on. TRUE when it stops the miracle.
/proc/rogue_psydon_archenemy_laughs(mob/living/carbon/human/caster)
	if(HAS_TRAIT(caster, TRAIT_LUX_FREAK))
		caster.visible_message(span_warning("[caster] shudders but [caster.p_their()] eyes flash silver and [caster.p_they()] keep on going."), span_userdanger("Cold shoots through my spine and dark laughter resounds, but I focus on my lux and ENDURE."))
		return FALSE
	caster.visible_message(span_warning("[caster] shudders. Something is very wrong."), span_userdanger("Cold shoots through my spine. Something laughs at me for trying."))
	caster.adjust_brute_loss(rogue_value("faith_psy_archenemy_damage"))
	return TRUE

/// Ratwood check_boot "Boot-Check" (T0 of Psydon): a coin turns up in the boot, gold for a lucky and happy man, silver for an
/// ordinary one, copper for the rest; and with luck something else besides.
/datum/action/cooldown/spell/pointed/rogue_miracle/check_boot
	name = "Boot-Check"
	desc = "Check my boot for a variety of items."
	button_icon = ROGUE_PSYDON_ICON
	button_icon_state = "BOOTCHECK"
	sound = null
	click_to_activate = FALSE
	value_key = "check_boot"
	miracle_tier = ROGUE_MIRACLE_TIER_0
	miracle_forks = "Ratwood, Azure Peak, Twilight Axis"
	miracle_gods = "Psydon T0"

/datum/action/cooldown/spell/pointed/rogue_miracle/check_boot/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/boot_owner = owner
	var/luck = boot_owner.rogue_stat(ROGUE_STAT_FORTUNE)
	var/obj/item/found
	if(boot_owner.mob_mood?.mood_level > MOOD_LEVEL_NEUTRAL && luck > ROGUE_ATTRIBUTE_MIDDLING)
		found = new /obj/item/roguecoin/gold
	else if(luck == ROGUE_ATTRIBUTE_MIDDLING)
		found = new /obj/item/roguecoin/silver
	else
		found = new /obj/item/roguecoin/copper
	to_chat(boot_owner, span_info("A coin in my boot? Psydon smiles upon me!"))
	boot_owner.put_in_hands(found)
	if(prob(luck + boot_owner.rogue_skill_rank(/datum/attribute/skill/magic/holy)))
		var/static/list/stash = list(/obj/item/flowercrown/rosa, /obj/item/bouquet/rosa, /obj/item/jingle_bells, /obj/item/bouquet/salvia, /obj/item/bouquet/calendula, /obj/item/roguecoin/gold, /obj/item/roguecoin/silver, /obj/item/roguecoin/copper, /obj/item/alch/atropa, /obj/item/alch/salvia, /obj/item/alch/artemisia, /obj/item/alch/rosa, /obj/item/rogueweapon/huntingknife/idagger/navaja, /obj/item/lockpick, /obj/item/reagent_containers/glass/bottle/alchemical/strpot, /obj/item/reagent_containers/glass/bottle/alchemical/endpot, /obj/item/reagent_containers/glass/bottle/alchemical/conpot, /obj/item/reagent_containers/glass/bottle/alchemical/lucpot, /obj/item/reagent_containers/glass/bottle/rogue/poison, /obj/item/reagent_containers/glass/bottle/rogue/healthpot, /obj/item/needle, /obj/item/natural/rock, /obj/item/natural/bundle/cloth, /obj/item/natural/bundle/fibers, /obj/item/clothing/suit/roguetown/armor/leather/hide/bikini, /obj/item/reagent_containers/glass/bottle/waterskin/milk, /obj/item/reagent_containers/food/snacks/rogue/bread, /obj/item/reagent_containers/food/snacks/grown/apple, /obj/item/natural/worms, /obj/item/natural/worms/leech, /obj/item/reagent_containers/food/snacks/rogue/psycrossbun, /obj/item/clothing/neck/roguetown/psicross, /obj/item/clothing/neck/roguetown/psicross/wood, /obj/item/rope/chain, /obj/item/rope, /obj/item/clothing/neck/roguetown/collar/leather, /obj/item/natural/dirtclod, /obj/item/reagent_containers/glass/cup/wooden, /obj/item/natural/glass, /obj/item/clothing/shoes/roguetown/sandals, /obj/item/alch/transisdust)
		var/extra_type = pick(stash)
		var/obj/item/extra = new extra_type(get_turf(boot_owner))
		to_chat(boot_owner, span_info("Ah, of course! I almost forgot I had this stashed away for a perfect occasion."))
		boot_owner.put_in_hands(extra)

/// Ratwood psydonendure "ENDURE" (T1 of Psydon): at the cost of some blood, the target's wounds are mended over time by a healing
/// aura; the finer the cross they wear and the more they have endured, the better. Psydon weeps for the undead instead.
/datum/action/cooldown/spell/pointed/rogue_miracle/psydon_endure
	name = "ENDURE"
	desc = "At the cost of some lyfe sustaining blood, I can mend the wounds of my target."
	button_icon = ROGUE_PSYDON_ICON
	button_icon_state = "ENDURE"
	sound = 'sound/effects/magic/staff_healing.ogg'
	value_key = "psydon_endure"
	miracle_tier = ROGUE_MIRACLE_TIER_1
	miracle_forks = "Ratwood, Azure Peak, Twilight Axis"
	miracle_gods = "Psydon T1"

/datum/action/cooldown/spell/pointed/rogue_miracle/psydon_endure/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !isliving(cast_on))
		to_chat(owner, span_warning("Only the living can endure."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/psydon_endure/cast(mob/living/cast_on)
	. = ..()
	var/mob/living/carbon/human/caster = owner
	if(burns_undead(cast_on))
		cast_on.visible_message(span_danger("[cast_on] shudders with a strange stirring feeling!"), span_userdanger("It hurts. You feel like weeping."))
		cast_on.adjust_brute_loss(rogue_value("faith_psy_endure_undead"))
		return
	var/cross_bonus = 0
	if(ishuman(cast_on))
		var/list/cross = rogue_psydon_cross(cast_on, "heal")
		cross_bonus = cross[1]
		if(cross[2] && rogue_psydon_archenemy_laughs(caster))
			return fail()
	var/healing = rogue_value("faith_psy_endure_healing") + cross_bonus
	var/embolden = 0
	if(cast_on.get_brute_loss() + cast_on.get_fire_loss() >= rogue_value("faith_psy_endure_damage"))
		embolden += rogue_value("faith_psy_endure_bonus")
	if(iscarbon(cast_on))
		var/mob/living/carbon/patient = cast_on
		if(length(patient.all_wounds) > rogue_value("faith_psy_endure_wounds"))
			embolden += rogue_value("faith_psy_endure_bonus")
	cast_on.visible_message(span_info("A strange stirring feeling pours from [cast_on]!"), span_info("Sentimental thoughts drive away my pain..."))
	if(embolden)
		to_chat(caster, "In <b>ENDURING</b> so much, become <b>EMBOLDENED</b>!")
		healing += embolden
	cast_on.apply_status_effect(/datum/status_effect/rogue_miracle_heal, healing)
	caster.adjust_blood_volume(-rogue_value("faith_psy_endure_blood"))

/// Ratwood psydonrespite "RESPITE" (T2 of Psydon): the devotee stands still and mends their own wounds for a few moments at a
/// time, as long as they stand, at the cost of some blood and some devotion each time; the more hurt they are, and the finer
/// the cross they wear, the more it mends.
/datum/action/cooldown/spell/pointed/rogue_miracle/psydon_respite
	name = "RESPITE"
	desc = "At the cost of some lyfe sustaining blood, I can stand still to focus on mending my injuries."
	button_icon = ROGUE_PSYDON_ICON
	button_icon_state = "RESPITE"
	sound = null
	click_to_activate = FALSE
	value_key = "psydon_respite"
	miracle_tier = ROGUE_MIRACLE_TIER_2
	miracle_forks = "Ratwood, Azure Peak, Twilight Axis"
	miracle_gods = "Psydon T2"
	/// The devotee is mending right now.
	var/mending = FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/psydon_respite/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/caster = owner
	if(mending)
		return fail("I am already focused on mending.")
	var/list/cross = rogue_psydon_cross(caster, "mend")
	if(cross[2] && rogue_psydon_archenemy_laughs(caster))
		return fail()
	INVOKE_ASYNC(src, PROC_REF(mend), caster)

/datum/action/cooldown/spell/pointed/rogue_miracle/psydon_respite/proc/mend(mob/living/carbon/human/caster)
	mending = TRUE
	to_chat(caster, span_info("I take a moment to collect myself..."))
	while(!QDELETED(caster) && do_after(caster, rogue_value("faith_psy_respite_time")))
		if(!caster.rogue_devotion || caster.rogue_devotion.devotion < rogue_value("faith_psy_respite_devotion"))
			to_chat(caster, span_warning("I have no devotion left to give."))
			break
		var/brute = caster.get_brute_loss()
		var/burn = caster.get_fire_loss()
		if(brute + burn <= 0 || caster.get_blood_volume() <= BLOOD_VOLUME_OKAY)
			break
		var/list/cross = rogue_psydon_cross(caster, "mend")
		var/brute_heal = rogue_value("faith_psy_respite_heal") + cross[1] + psydon_sitting_bonus(brute)
		var/burn_heal = rogue_value("faith_psy_respite_heal") + cross[1] + psydon_sitting_bonus(burn)
		playsound(caster, 'sound/effects/magic/staff_healing.ogg', 100, TRUE)
		new /obj/effect/temp_visual/heal(get_turf(caster), "#e4e4e4")
		caster.adjust_brute_loss(-brute_heal)
		caster.adjust_fire_loss(-burn_heal)
		caster.adjust_blood_volume(-rogue_value("faith_psy_respite_blood"))
		if(psydon_sitting_bonus(brute) || psydon_sitting_bonus(burn))
			to_chat(caster, span_info("My pain gives way to a sense of furthered clarity before returning again, dulled."))
		caster.rogue_devotion.adjust(-rogue_value("faith_psy_respite_devotion"))
		to_chat(caster, "<font color='purple'>I lose [rogue_value("faith_psy_respite_devotion")] devotion!</font>")
	if(!QDELETED(caster))
		to_chat(caster, span_warning("My thoughts and sense of quiet escape me."))
	mending = FALSE

/// What the more hurt a body is the more a respite mends of it (Ratwood sit_bonus): damage of a kind over each of the six steps.
/datum/action/cooldown/spell/pointed/rogue_miracle/psydon_respite/proc/psydon_sitting_bonus(damage)
	. = 0
	for(var/rung in 1 to 6)
		if(damage > rogue_value("faith_psy_sit_[rung]_damage"))
			. = rogue_value("faith_psy_sit_[rung]_heal")

#undef ROGUE_PSYDON_ICON
