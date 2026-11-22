/// The miracles of Noc of the basket (miracle.dm), from Ratwood's acolyte/noc.dm (the other forks have none of these four):
/// Shroud of Noc, Silence, Moonlit Ward and Noc's Gaze. Nitevision and Moon Shroud, Noc's other miracles, are in daily.dm.

/// Ratwood's sheet of Noc's buttons, which has the states of Silence and the Ward that Azure Peak's sheet does not.
#define ROGUE_MIRACLES_NOC_RATWOOD_ICON 'modular_redtard/faith/icons/nocmiracles_ratwood.dmi'

/// Ratwood magical_blindness: a haze of darkness over the whole screen.
/atom/movable/screen/fullscreen/rogue_magical_blindness
	icon_state = "oxydamageoverlay9"
	layer = BLIND_LAYER

/// Ratwood debuff/magical_blindness: for three seconds per rank of the caster the target sees through a haze of darkness and
/// misses the more for it: a lower Perception, half a point per rank.
/datum/status_effect/rogue_magical_blindness
	id = "rogue_magical_blindness"
	status_type = STATUS_EFFECT_REFRESH
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = /atom/movable/screen/alert/status_effect/rogue_magical_blindness
	var/penalty = 0

/datum/status_effect/rogue_magical_blindness/on_creation(mob/living/new_owner, blind_time, perception_penalty)
	if(blind_time)
		duration = blind_time
	penalty = perception_penalty
	return ..()

/datum/status_effect/rogue_magical_blindness/on_apply()
	owner.overlay_fullscreen(id, /atom/movable/screen/fullscreen/rogue_magical_blindness)
	owner.attributes?.set_variable_attribute_modifier(id, list(ROGUE_STAT_PERCEPTION = -penalty))
	return TRUE

/datum/status_effect/rogue_magical_blindness/refresh(effect, blind_time, perception_penalty)
	duration = max(duration, blind_time)
	if(perception_penalty > penalty)
		penalty = perception_penalty
		owner.attributes?.set_variable_attribute_modifier(id, list(ROGUE_STAT_PERCEPTION = -penalty))

/datum/status_effect/rogue_magical_blindness/on_remove()
	owner.clear_fullscreen(id)
	owner.attributes?.remove_attribute_modifier(id)
	to_chat(owner, span_notice("The darkness lifts from my eyes."))
	return ..()

/atom/movable/screen/alert/status_effect/rogue_magical_blindness
	name = "Magically Blinded"
	desc = "A mote of darkness clouds my eyes! It's harder to see, and my weapon strikes are less accurate."
	icon = ROGUE_COMBAT_ALERTS_ICON
	icon_state = "blind"

/// Ratwood blindness "Shroud of Noc": a mote of living darkness blinds the target for three seconds per rank of the caster in
/// miracles (at least one rank), and with it the target's Perception is lower.
/datum/action/cooldown/spell/pointed/rogue_miracle/shroud_of_noc
	name = "Shroud of Noc"
	desc = "Direct a mote of living darkness to temporarily blind another, restricting their combative skills relative to my faith."
	button_icon = ROGUE_MIRACLES_NOC_ICON
	button_icon_state = "blindness"
	sound = 'modular_redtard/faith/sound/churn.ogg'
	invocation = "Noc blinds thee of thy sins!"
	invocation_type = INVOCATION_SHOUT
	cooldown_time = 30 SECONDS
	cast_range = 7
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_2
	devotion_cost = 15
	stamina_cost = 30
	needs_holy_symbol = TRUE
	miracle_forks = "Ratwood"
	miracle_gods = "Noc T2"
	/// Darkness per rank of the caster in miracles (Ratwood 3 seconds).
	var/blind_per_rank = 3 SECONDS

/datum/action/cooldown/spell/pointed/rogue_miracle/shroud_of_noc/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !isliving(cast_on))
		to_chat(owner, span_warning("Only the living can be blinded."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/shroud_of_noc/cast(mob/living/cast_on)
	. = ..()
	if(cast_on.can_block_magic(MAGIC_RESISTANCE_HOLY))
		return
	var/mob/living/caster = owner
	var/rank = max(caster.rogue_skill_rank(/datum/attribute/skill/magic/holy), 1)
	cast_on.visible_message(span_warning("[owner] points at [cast_on]'s eyes!"), span_warning("My eyes are covered in darkness!"))
	cast_on.apply_status_effect(/datum/status_effect/rogue_magical_blindness, rank * blind_per_rank, round(rank / 2))

/// Ratwood Silence's mute: the voice goes still for a time.
/datum/status_effect/rogue_silenced
	id = "rogue_silenced"
	status_type = STATUS_EFFECT_REFRESH
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = null

/datum/status_effect/rogue_silenced/on_creation(mob/living/new_owner, silence_time)
	if(silence_time)
		duration = silence_time
	return ..()

/datum/status_effect/rogue_silenced/on_apply()
	ADD_TRAIT(owner, TRAIT_MUTE, id)
	to_chat(owner, span_warning("The wind in my voice goes still. I can't speak!"))
	return TRUE

/datum/status_effect/rogue_silenced/refresh(effect, silence_time)
	duration = max(duration, silence_time)

/datum/status_effect/rogue_silenced/on_remove()
	REMOVE_TRAIT(owner, TRAIT_MUTE, id)
	to_chat(owner, span_notice("My voice returns."))
	return ..()

/// Ratwood silence/miracle "Silence" (the ultimate move of Noc's clergy): after a prayer of five seconds - the caster may
/// move - the target can utter no word, spell or insult, for five seconds per rank of the caster in miracles. Not those whom
/// magic turns from, those who already cannot speak, and those who know to counter a counterspell.
/datum/action/cooldown/spell/pointed/rogue_miracle/silence
	name = "Silence"
	desc = "Shutter voices and empty the air of sound - naught mage-nor-man shall utter a word, be it invocation or insult."
	button_icon = ROGUE_MIRACLES_NOC_RATWOOD_ICON
	button_icon_state = "silencenoc"
	sound = 'modular_redtard/faith/sound/zizo_snuff.ogg'
	invocation = "Lunaria Silentium!"
	invocation_type = INVOCATION_SHOUT
	cooldown_time = 30 SECONDS
	cast_range = 7
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_3
	devotion_cost = 100
	stamina_cost = 30
	needs_holy_symbol = TRUE
	miracle_forks = "Ratwood"
	miracle_gods = "Noc T3"
	/// The prayer before the silence falls (Ratwood chargetime 5 seconds).
	var/prayer_time = 5 SECONDS
	/// Silence per rank of the caster in miracles (Ratwood 5 seconds).
	var/silence_per_rank = 5 SECONDS

/datum/action/cooldown/spell/pointed/rogue_miracle/silence/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !iscarbon(cast_on))
		to_chat(owner, span_warning("Only a body of flesh can be silenced."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/silence/cast(mob/living/carbon/cast_on)
	. = ..()
	if(HAS_TRAIT(cast_on, TRAIT_COUNTERCOUNTERSPELL) || HAS_TRAIT(cast_on, TRAIT_ANTIMAGIC) || HAS_TRAIT(cast_on, TRAIT_MUTE))
		return fail("The spell fizzles, it won't work on them!")
	INVOKE_ASYNC(src, PROC_REF(still_voice), owner, cast_on)

/datum/action/cooldown/spell/pointed/rogue_miracle/silence/proc/still_voice(mob/living/carbon/human/caster, mob/living/carbon/target)
	caster.visible_message(span_warning("[caster] stretches out a hand towards [target] and the air around [target.p_them()] begins to still..."), span_notice("I call upon Noc to still the voice of [target]..."))
	if(!do_after(caster, prayer_time, target = target, timed_action_flags = IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE))
		to_chat(caster, span_warning("My prayer was interrupted!"))
		refund()
		return
	if(QDELETED(target) || target.can_block_magic(MAGIC_RESISTANCE_HOLY))
		return
	playsound(get_turf(target), 'modular_redtard/faith/sound/zizo_snuff.ogg', 80, TRUE)
	target.apply_status_effect(/datum/status_effect/rogue_silenced, max(caster.rogue_skill_rank(/datum/attribute/skill/magic/holy), 1) * silence_per_rank)

/// Ratwood magicshield's TRAIT_ANTIMAGIC: magic does not touch them while it lasts.
/datum/status_effect/rogue_moonlit_ward
	id = "rogue_moonlit_ward"
	status_type = STATUS_EFFECT_REFRESH
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = /atom/movable/screen/alert/status_effect/rogue_moonlit_ward

/datum/status_effect/rogue_moonlit_ward/on_creation(mob/living/new_owner, ward_time)
	if(ward_time)
		duration = ward_time
	return ..()

/datum/status_effect/rogue_moonlit_ward/on_apply()
	ADD_TRAIT(owner, TRAIT_ANTIMAGIC, id)
	owner.visible_message(span_warning("A ward of moonlight settles around [owner]!"), span_warning("A nullifying force settles over me!"))
	return TRUE

/datum/status_effect/rogue_moonlit_ward/refresh(effect, ward_time)
	duration = max(duration, ward_time)

/datum/status_effect/rogue_moonlit_ward/on_remove()
	REMOVE_TRAIT(owner, TRAIT_ANTIMAGIC, id)
	to_chat(owner, span_warning("The anti-magic ward fades."))
	return ..()

/atom/movable/screen/alert/status_effect/rogue_moonlit_ward
	name = "Moonlit Ward"
	desc = "A ward of anti-magic is wrapped around me: spells cannot touch me."
	icon = ROGUE_COMBAT_ALERTS_ICON
	icon_state = "holybuff"

/// Ratwood magicshield "Moonlit Ward": after a prayer of three seconds - the caster may move - the target is wrapped in a ward of
/// anti-magic for five seconds per rank of the caster in miracles.
/datum/action/cooldown/spell/pointed/rogue_miracle/moonlit_ward
	name = "Moonlit Ward"
	desc = "Wrap a target in a ward of anti-magic."
	button_icon = ROGUE_MIRACLES_NOC_RATWOOD_ICON
	button_icon_state = "antimagenoc"
	sound = 'modular_redtard/faith/sound/antimagic.ogg'
	invocation = "No spell shall touch thee!"
	invocation_type = INVOCATION_SHOUT
	cooldown_time = 60 SECONDS
	cast_range = 7
	miracle_tier = ROGUE_MIRACLE_TIER_2
	devotion_cost = 100
	stamina_cost = 30
	needs_holy_symbol = TRUE
	miracle_forks = "Ratwood"
	miracle_gods = "Noc T2"
	/// The prayer before the ward is raised (Ratwood chargetime 3 seconds).
	var/prayer_time = 3 SECONDS
	/// Ward per rank of the caster in miracles (Ratwood 5 seconds).
	var/ward_per_rank = 5 SECONDS

/datum/action/cooldown/spell/pointed/rogue_miracle/moonlit_ward/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !isliving(cast_on))
		to_chat(owner, span_warning("Only the living can be warded."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/moonlit_ward/cast(mob/living/cast_on)
	. = ..()
	if(HAS_TRAIT(cast_on, TRAIT_ANTIMAGIC))
		return fail("They are already protected from magic!")
	INVOKE_ASYNC(src, PROC_REF(raise_ward), owner, cast_on)

/datum/action/cooldown/spell/pointed/rogue_miracle/moonlit_ward/proc/raise_ward(mob/living/carbon/human/caster, mob/living/target)
	caster.visible_message(span_notice("[caster] raises a hand and moonlight gathers around [target]..."), span_notice("I call upon Noc to ward [target == caster ? "myself" : target] from magic..."))
	if(!do_after(caster, prayer_time, target = target, timed_action_flags = IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE))
		to_chat(caster, span_warning("My prayer was interrupted!"))
		refund()
		return
	if(QDELETED(target) || HAS_TRAIT(target, TRAIT_ANTIMAGIC))
		return
	target.apply_status_effect(/datum/status_effect/rogue_moonlit_ward, max(caster.rogue_skill_rank(/datum/attribute/skill/magic/holy), 1) * ward_per_rank)

/// Peering ahead: the view is shifted towards the spot looked at until the gazer moves or the time runs out.
/datum/status_effect/rogue_noc_gaze
	id = "rogue_noc_gaze"
	status_type = STATUS_EFFECT_REFRESH
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = null
	var/shift_x = 0
	var/shift_y = 0
	/// The client that was shifted, to be put back.
	var/client/shifted

/datum/status_effect/rogue_noc_gaze/on_creation(mob/living/new_owner, gaze_time, new_shift_x, new_shift_y)
	if(gaze_time)
		duration = gaze_time
	shift_x = new_shift_x
	shift_y = new_shift_y
	return ..()

/datum/status_effect/rogue_noc_gaze/on_apply()
	if(!owner.client)
		return FALSE
	shift_view()
	RegisterSignals(owner, list(COMSIG_MOVABLE_MOVED, COMSIG_MOB_LOGOUT), PROC_REF(on_moved))
	return TRUE

/datum/status_effect/rogue_noc_gaze/refresh(effect, gaze_time, new_shift_x, new_shift_y)
	duration = gaze_time
	shift_x = new_shift_x
	shift_y = new_shift_y
	shift_view()

/datum/status_effect/rogue_noc_gaze/on_remove()
	UnregisterSignal(owner, list(COMSIG_MOVABLE_MOVED, COMSIG_MOB_LOGOUT))
	if(shifted)
		animate(shifted, pixel_x = 0, pixel_y = 0, time = 0.6 SECONDS)
		shifted = null
	return ..()

/datum/status_effect/rogue_noc_gaze/proc/shift_view()
	shifted = owner.client
	animate(shifted, pixel_x = shift_x, pixel_y = shift_y, time = 0.6 SECONDS)

/datum/status_effect/rogue_noc_gaze/proc/on_moved(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/// Ratwood noc_sight "Noc's Gaze": a whispered prayer lets the devotee peer at a spot three to seven tiles away, as if their
/// eyes were the keenest in the realm; the view drifts back when they move. Noc's patron list has no room for it in Ratwood:
/// it is only to be had by grant.
/datum/action/cooldown/spell/pointed/rogue_miracle/noc_gaze
	name = "Noc's Gaze"
	desc = "Peer ahead: my sight reaches out towards a spot three to seven tiles away until I move."
	button_icon = ROGUE_MIRACLES_NOC_ICON
	button_icon_state = "noc_gaze"
	invocation = "Noc guide my gaze."
	invocation_type = INVOCATION_WHISPER
	antimagic_flags = NONE
	cooldown_time = 5 SECONDS
	cast_range = 7
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_0
	devotion_cost = 5
	miracle_forks = "Ratwood"
	miracle_gods = "none: in no patron's list"
	/// How long the view holds if the devotee stands still.
	var/gaze_time = 10 SECONDS
	/// Nearest spot that can be peered at, in tiles (Ratwood: farther than 2).
	var/nearest = 3

/datum/action/cooldown/spell/pointed/rogue_miracle/noc_gaze/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	if(!owner.client)
		return FALSE
	var/distance = get_dist(owner, get_turf(cast_on))
	if(distance < nearest || distance > cast_range)
		to_chat(owner, span_warning("I can only peer at a spot [nearest] to [cast_range] tiles away."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/noc_gaze/cast(atom/cast_on)
	. = ..()
	var/turf/spot = get_turf(cast_on)
	var/turf/here = get_turf(owner)
	owner.apply_status_effect(/datum/status_effect/rogue_noc_gaze, gaze_time, (spot.x - here.x) * ICON_SIZE_X, (spot.y - here.y) * ICON_SIZE_Y)

#undef ROGUE_MIRACLES_NOC_RATWOOD_ICON
