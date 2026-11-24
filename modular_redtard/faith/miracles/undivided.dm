/// The miracles of the Ten Undivided (Azure Peak and Twilight Axis, code/modules/spells/pantheon/divine/undivided.dm; the same file
/// in both): Enkindle, Recuperation, Twinned Gaze, Perseverance, Gallows Humor, Ten United and the Lesser Anastasis. In the forks
/// each needs a cross of the Undivided; here any holy symbol will do, as with the others of the basket. Their healing Miracle
/// is the one of healing.dm (Azure Peak's Undivided only adds a sixth to it). The numbers are in faith.txt, the ones of a cast
/// by miracle_<value_key>_*.

#define ROGUE_UNDIVIDED_FILTER_RECUPERATION "rogue_recuperation"

/proc/rogue_undivided_message(mob/speaker, text, selftext)
	speaker.visible_message("<font color='cyan'>[text]</font>", selftext ? "<font color='cyan'>[selftext]</font>" : null)

/// Azure Peak miracle/ignition/undivided "Enkindle" (T0 of the Undivided): the ignition of Astrata and Malum, a little
/// dearer.
/datum/action/cooldown/spell/pointed/rogue_miracle/ignition/enkindle
	name = "Enkindle"
	button_icon = ROGUE_MIRACLES_UNDIVIDED_ICON
	button_icon_state = "enkindle"
	value_key = "enkindle"
	miracle_forks = "Azure Peak, Twilight Axis"
	miracle_gods = "the Ten Undivided T0"
	needs_holy_symbol = TRUE

/// Azure Peak buff/recuperation: for a while some energy comes back every second, twice as much for one who is not in combat.
/datum/status_effect/rogue_recuperation
	id = "rogue_recuperation"
	alert_type = null
	tick_interval = 1 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	/// A longer one for the target of someone else's miracle.
	var/other = FALSE

/datum/status_effect/rogue_recuperation/on_creation(mob/living/new_owner, from_another = FALSE)
	other = from_another
	duration = rogue_value(from_another ? "faith_recup_time_other" : "faith_recup_time")
	return ..()

/datum/status_effect/rogue_recuperation/refresh(effect, from_another = FALSE)
	duration = max(duration, rogue_value(from_another ? "faith_recup_time_other" : "faith_recup_time"))

/datum/status_effect/rogue_recuperation/on_apply()
	if(!owner.get_filter(ROGUE_UNDIVIDED_FILTER_RECUPERATION))
		owner.add_filter(ROGUE_UNDIVIDED_FILTER_RECUPERATION, 2, list("type" = "outline", "color" = "#2e8d8d", "alpha" = 90, "size" = 1))
	return TRUE

/datum/status_effect/rogue_recuperation/tick(seconds_between_ticks)
	var/mob/living/carbon/human/rested = owner
	if(!istype(rested))
		return
	var/energy = rogue_value("faith_recup_tick")
	if(!rested.combat_mode)
		energy *= rogue_value("faith_recup_rest_factor")
	rested.rogue_energy_add(energy)

/datum/status_effect/rogue_recuperation/on_remove()
	owner.remove_filter(ROGUE_UNDIVIDED_FILTER_RECUPERATION)

/// Azure Peak recuperation "Recuperation" (T0 of the Undivided; Malum and Pestra): energy comes back to the caster, half as much as
/// to another, whom the caster gives twice what they give themselves of their own energy, if they have it.
/datum/action/cooldown/spell/pointed/rogue_miracle/recuperation
	name = "Recuperation"
	desc = "Restores the target's energy and gives them a brief regeneration of it. Twice as effective on someone other than myself, from my own energy."
	button_icon = ROGUE_MIRACLES_UNDIVIDED_ICON
	button_icon_state = "calming_respite"
	sound = 'sound/effects/magic/staff_healing.ogg'
	value_key = "recuperation"
	miracle_tier = ROGUE_MIRACLE_TIER_0
	needs_holy_symbol = TRUE
	miracle_forks = "Azure Peak, Twilight Axis"
	miracle_gods = "the Ten Undivided T0"

/datum/action/cooldown/spell/pointed/rogue_miracle/recuperation/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !ishuman(cast_on))
		to_chat(owner, span_warning("I can only cast this on a man."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/recuperation/cast(mob/living/carbon/human/cast_on)
	. = ..()
	var/mob/living/carbon/human/caster = owner
	var/energy = rogue_value("faith_recup_energy") * caster.rogue_skill_rank(/datum/attribute/skill/magic/holy)
	if(cast_on == caster)
		caster.rogue_energy_add(energy * rogue_value("faith_recup_self_factor"))
		caster.apply_status_effect(/datum/status_effect/rogue_recuperation)
		rogue_undivided_message(caster, "As [caster] intones the incantation, vibrant flames swirl around them.", "As I intone the incantation, vibrant flames swirl around me. I feel refreshed.")
		return
	if(caster.rogue_energy <= rogue_value("faith_recup_energy"))
		return fail("I do not have the strength to give.")
	caster.rogue_energy_add(-energy)
	cast_on.rogue_energy_add(energy * rogue_value("faith_recup_other_factor"))
	cast_on.apply_status_effect(/datum/status_effect/rogue_recuperation, TRUE)
	rogue_undivided_message(cast_on, "As [caster] intones the incantation, vibrant flames swirl around them, a dance of energy flowing towards [cast_on].", "As [caster] intones the incantation, vibrant flames swirl around them, a dance of energy flowing towards me. I feel refreshed.")

/// Azure Peak buff/twinned_gaze: the limit on the sight is gone for a while, and with the skill to darkvision the night as well;
/// it lasts longer the more skilled the caster is, and twice as long by day and by night (not at dawn or dusk). The cone of the
/// caster's own helmet and sun glare is lifted (combat/fov.dm), as with Astrata's gaze.
/datum/status_effect/rogue_twinned_gaze
	id = "rogue_twinned_gaze"
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null
	tick_interval = 1 SECONDS
	/// The traits it gave.
	var/list/granted = list()

/datum/status_effect/rogue_twinned_gaze/on_creation(mob/living/new_owner, rank)
	rank = max(rank, 1)
	duration = rogue_value("faith_twinned_time") * rank
	if(GLOB.rockhill_time_of_day == ROCKHILL_DAY || GLOB.rockhill_time_of_day == ROCKHILL_NIGHT)
		duration *= rogue_value("faith_twinned_day_factor")
	if(rank > rogue_value("faith_twinned_night_rank"))
		granted += TRAIT_TRUE_NIGHT_VISION
	if(rank >= rogue_value("faith_twinned_dark_rank"))
		granted += TRAIT_NIGHT_VISION
	return ..()

/datum/status_effect/rogue_twinned_gaze/on_apply()
	for(var/trait in granted)
		ADD_TRAIT(owner, trait, ROGUE_FAITH_TRAIT)
	owner.remove_fov_trait(ROGUE_FOV_SOURCE)
	to_chat(owner, span_info("They grant me clarity, allowing me to see evil clearly."))
	return TRUE

/datum/status_effect/rogue_twinned_gaze/tick(seconds_between_ticks)
	if(LAZYACCESS(owner.fov_traits, ROGUE_FOV_SOURCE))
		owner.remove_fov_trait(ROGUE_FOV_SOURCE)

/datum/status_effect/rogue_twinned_gaze/on_remove()
	for(var/trait in granted)
		REMOVE_TRAIT(owner, trait, ROGUE_FAITH_TRAIT)
	if(ishuman(owner))
		var/mob/living/carbon/human/seer = owner
		seer.rogue_update_fov()

/// Azure Peak twinned_gaze "Twinned Gaze" (T1 of the Undivided; Astrata and Noc): sight all around and in the dark.
/datum/action/cooldown/spell/pointed/rogue_miracle/twinned_gaze
	name = "Twinned Gaze"
	desc = "Removes the limit on my vision, letting me see behind me for a time, with varying degrees of night vision. The time and the darksight scale with my skill in miracles and the time of dae."
	button_icon = ROGUE_MIRACLES_UNDIVIDED_ICON
	button_icon_state = "twinned_gaze"
	sound = 'modular_redtard/faith/sound/bless.ogg'
	invocation = "Grant your sight unto me."
	invocation_type = INVOCATION_WHISPER
	click_to_activate = FALSE
	value_key = "twinned_gaze"
	miracle_tier = ROGUE_MIRACLE_TIER_1
	needs_holy_symbol = TRUE
	miracle_forks = "Azure Peak, Twilight Axis"
	miracle_gods = "the Ten Undivided T1"

/datum/action/cooldown/spell/pointed/rogue_miracle/twinned_gaze/cast(atom/cast_on)
	. = ..()
	var/mob/living/caster = owner
	caster.apply_status_effect(/datum/status_effect/rogue_twinned_gaze, caster.rogue_skill_rank(/datum/attribute/skill/magic/holy))

/// Azure Peak stressevent/perseverance: a mere respite from the horrors.
/datum/mood_event/rogue_perseverance
	description = "A mere respite from the horrors."

/datum/mood_event/rogue_perseverance/add_effects(...)
	mood_change = rogue_value("faith_persev_mood")
	timeout = rogue_value("faith_persev_mood_time")

/// Azure Peak perseverance "Perseverance" (T3 of the Undivided; Ravox and Eora): the wounds of the chosen limb stop bleeding and
/// hurt less, the less the more skilled the caster is, and the living are eased in mind. Azure Peak lets the wounds keep the share
/// of their pain that grows with the skill; here it is the share that is eased which grows with it.
/datum/action/cooldown/spell/pointed/rogue_miracle/perseverance
	name = "Perseverance"
	desc = "Slows the bleeding, speeds the clotting and eases the pain of the wounds of a chosen limb, and gives the living a slight relief from stress."
	button_icon = ROGUE_MIRACLES_UNDIVIDED_ICON
	button_icon_state = "perseverance"
	sound = 'sound/effects/magic/staff_healing.ogg'
	invocation = "Falter not before evyl!"
	invocation_type = INVOCATION_SHOUT
	value_key = "perseverance"
	miracle_tier = ROGUE_MIRACLE_TIER_3
	needs_holy_symbol = TRUE
	miracle_forks = "Azure Peak, Twilight Axis"
	miracle_gods = "the Ten Undivided T3"

/datum/action/cooldown/spell/pointed/rogue_miracle/perseverance/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !isliving(cast_on))
		to_chat(owner, span_warning("I can only cast this on a living being."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/perseverance/cast(mob/living/cast_on)
	. = ..()
	cast_on.visible_message(span_notice("Warmth radiates from [cast_on] as their wounds seal over!"), span_notice("The pain from my wounds fades as warmth radiates from my soul!"))
	if(!iscarbon(cast_on))
		return
	var/mob/living/carbon/patient = cast_on
	if(patient.mind)
		patient.add_mood_event("rogue_perseverance", /datum/mood_event/rogue_perseverance)
	var/obj/item/bodypart/affecting = patient.get_bodypart(check_zone(owner.zone_selected))
	if(!affecting)
		return
	var/mob/living/caster = owner
	var/relief = min(rogue_value("faith_persev_relief") + rogue_value("faith_persev_relief_rank") * caster.rogue_skill_rank(/datum/attribute/skill/magic/holy), 1)
	for(var/datum/wound/wound as anything in affecting.wounds)
		wound.rogue_ease_pain(wound.rogue_pain() * relief * 2)
		var/datum/wound/rogue/bleeder = wound
		if(istype(bleeder) && !isnull(bleeder.rogue_clot_floor) && bleeder.rogue_bleed() > bleeder.rogue_clot_floor)
			bleeder.rogue_set_bleed(bleeder.rogue_clot_floor)
		else if(!istype(bleeder) && wound.blood_flow > 0)
			wound.set_blood_flow(0)
	// Block VR1: on a medieval body the pain is the limb's and the blood the injuries' (combat/injuries/). The limb's pain eases
	// by the same relief; each bleeding injury mends down to where it stops bleeding, as a crit's bleeding drops to its floor.
	affecting.rogue_remove_pain(affecting.rogue_pain_dam * relief)
	for(var/datum/rogue_injury/injury as anything in affecting.rogue_injuries?.Copy())
		if(QDELETED(injury) || !injury.is_bleeding())
			continue
		var/excess = (injury.damage_per_injury() - injury.bleed_threshold) * injury.amount
		if(excess > 0)
			injury.heal_damage(excess)

/// Azure Peak debuff/gallowshumor: a terrible secret learnt; for a while the mood is the worse for it.
/datum/status_effect/rogue_gallows_humor
	id = "rogue_gallows_humor"
	alert_type = null
	tick_interval = STATUS_EFFECT_NO_TICK

/datum/status_effect/rogue_gallows_humor/on_creation(mob/living/new_owner)
	duration = rogue_value("faith_gallows_time")
	return ..()

/datum/status_effect/rogue_gallows_humor/on_apply()
	ADD_TRAIT(owner, TRAIT_BAD_MOOD, ROGUE_FAITH_TRAIT)
	to_chat(owner, span_warning("THAT CHILLED ME TO MY CORE!"))
	return TRUE

/datum/status_effect/rogue_gallows_humor/on_remove()
	REMOVE_TRAIT(owner, TRAIT_BAD_MOOD, ROGUE_FAITH_TRAIT)

/// Azure Peak stressevent/gallowshumor.
/datum/mood_event/rogue_gallows_humor
	description = "NO NO NO!"

/datum/mood_event/rogue_gallows_humor/add_effects(...)
	mood_change = -rogue_value("faith_gallows_mood")
	timeout = rogue_value("faith_gallows_mood_time")

/// Azure Peak gallows_humor "Gallows Humor" (T3 of the Undivided; Necra and Xylix): a terrible secret of lyfe shared with the
/// target stresses it out for a long while; a mindless creature is held still for a few seconds instead. Azure Peak throws it as
/// a note that flies; here it lands on the target the caster points at.
/datum/action/cooldown/spell/pointed/rogue_miracle/gallows_humor
	name = "Gallows Humor"
	desc = "Share a terrible secret of lyfe with my target, stressing them out. Mindless creatures are held still for a few seconds."
	button_icon = ROGUE_MIRACLES_UNDIVIDED_ICON
	button_icon_state = "gallows"
	sound = 'sound/effects/magic/curse.ogg'
	invocation = "Terror reigns!"
	invocation_type = INVOCATION_SHOUT
	value_key = "gallows_humor"
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_3
	needs_holy_symbol = TRUE
	miracle_forks = "Azure Peak, Twilight Axis"
	miracle_gods = "the Ten Undivided T3"

/datum/action/cooldown/spell/pointed/rogue_miracle/gallows_humor/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !isliving(cast_on))
		to_chat(owner, span_warning("Only the living can hear it."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/gallows_humor/cast(mob/living/cast_on)
	. = ..()
	if(cast_on.can_block_magic(MAGIC_RESISTANCE_HOLY))
		cast_on.visible_message(span_warning("The terror fizzles on contact with [cast_on]!"))
		return
	if(!cast_on.mind)
		cast_on.Immobilize(rogue_value("faith_gallows_mindless"))
		cast_on.emote("cry", forced = TRUE)
		return
	if(cast_on.has_status_effect(/datum/status_effect/rogue_gallows_humor))
		return fail("They already heard this one!")
	cast_on.apply_status_effect(/datum/status_effect/rogue_gallows_humor)
	cast_on.add_mood_event("rogue_gallows_humor", /datum/mood_event/rogue_gallows_humor)

/// Azure Peak buff/guidinglight/undivided: the caster carries a light of their own for a long while, and sees farther in it.
/datum/status_effect/rogue_miracle_stats/guiding_light
	id = "rogue_guiding_light"
	start_message = "<span class='notice'>Light blossoms into being around me!</span>"
	var/obj/effect/dummy/lighting_obj/moblight/glow

/datum/status_effect/rogue_miracle_stats/guiding_light/stat_changes()
	return list(ROGUE_STAT_PERCEPTION = rogue_value("faith_guiding_perception"))

/datum/status_effect/rogue_miracle_stats/guiding_light/new_duration()
	return rogue_value("faith_guiding_time")

/datum/status_effect/rogue_miracle_stats/guiding_light/on_apply()
	. = ..()
	glow = owner.mob_light(rogue_value("faith_guiding_light"), 1, "#fdfbd3")

/datum/status_effect/rogue_miracle_stats/guiding_light/on_remove()
	QDEL_NULL(glow)
	return ..()

/datum/status_effect/rogue_miracle_stats/guiding_light/get_examine_text(mob/examiner)
	return span_notice("[owner.p_They()] walk[owner.p_s()] with the light of the Ten!")

/// Azure Peak buff/ten_united: the faithful of the Ten are given constitution, will and fortune.
/datum/status_effect/rogue_miracle_stats/ten_united
	id = "rogue_ten_united"
	start_message = "<span class='notice'>My heart basks in Their light..!</span>"
	end_message = "<span class='notice'>My heart is no longer protected by Their light..!</span>"

/datum/status_effect/rogue_miracle_stats/ten_united/stat_changes()
	return list(ROGUE_STAT_CONSTITUTION = rogue_value("faith_ten_constitution"), ROGUE_STAT_WILLPOWER = rogue_value("faith_ten_willpower"), ROGUE_STAT_FORTUNE = rogue_value("faith_ten_fortune"))

/datum/status_effect/rogue_miracle_stats/ten_united/new_duration()
	return rogue_value("faith_ten_time")

/// Azure Peak undivided_battlecry "Ten United" (T4 of the Undivided): the caster is lit with the light of the Ten and every
/// worshipper of the Ten around them is strengthened. Azure Peak also keeps the rallied from panic and heart attacks; the port
/// has neither.
/datum/action/cooldown/spell/pointed/rogue_miracle/ten_united
	name = "Ten United"
	desc = "Rally the faithful to fight by my side, giving a bonus to constitution, willpower and fortune to the worshippers of the Ten around me."
	button_icon = ROGUE_MIRACLES_UNDIVIDED_ICON
	button_icon_state = "united"
	sound = 'sound/effects/magic/timeparadox2.ogg'
	invocation = "United we stand, together we fall!"
	invocation_type = INVOCATION_SHOUT
	click_to_activate = FALSE
	value_key = "ten_united"
	miracle_tier = ROGUE_MIRACLE_TIER_4
	needs_holy_symbol = TRUE
	miracle_forks = "Azure Peak, Twilight Axis"
	miracle_gods = "the Ten Undivided T4"

/datum/action/cooldown/spell/pointed/rogue_miracle/ten_united/cast(atom/cast_on)
	. = ..()
	var/mob/living/caster = owner
	caster.apply_status_effect(/datum/status_effect/rogue_miracle_stats/guiding_light)
	for(var/mob/living/carbon/human/target in view(rogue_value("faith_ten_range"), get_turf(caster)))
		if(istype(target.rogue_patron, /datum/patron/divine))
			target.apply_status_effect(/datum/status_effect/rogue_miracle_stats/ten_united)

/// Azure Peak miracle/anastasis/undivided "Lesser Anastasis" (the Undivided): the Anastasis of Astrata (revival.dm), dearer in time,
/// and a body that has begun to rot cannot be called back by it.
/datum/action/cooldown/spell/pointed/rogue_miracle/anastasis/undivided
	name = "Lesser Anastasis"
	desc = "Resurrect a person that is free of rot and decay; the undead are unmade when it is attempted."
	button_icon = ROGUE_MIRACLES_UNDIVIDED_ICON
	button_icon_state = "revive"
	value_key = "lesser_anastasis"
	miracle_forks = "Azure Peak, Twilight Axis"
	miracle_gods = "the Ten Undivided"

/datum/action/cooldown/spell/pointed/rogue_miracle/anastasis/undivided/is_valid_target(atom/cast_on)
	. = ..()
	if(. && isliving(cast_on))
		var/mob/living/body = cast_on
		if(body.has_status_effect(/datum/status_effect/rogue_rotted_corpse))
			to_chat(owner, span_warning("[body] has begun to rot: this cannot call them back."))
			return FALSE

#undef ROGUE_UNDIVIDED_FILTER_RECUPERATION
