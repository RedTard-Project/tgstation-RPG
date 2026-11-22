/// The orisons of the basket (miracle.dm) that light.dm and daily.dm do not have: Thaumaturgy and Lay Hands, from the orison of
/// Ratwood's modular_azurepeak (spells/orison.dm) and Azure Peak's and Twilight Axis's. Every god has them at the lowest tier;
/// the orison to bring one into a faith waits for the owner. Every number is a value of faith.txt: the orison's own by its
/// value_key (miracle.dm), the rest by the name written where it is read.

#define ROGUE_LAY_HANDS_FILTER "rogue_lay_hands"

/// Ratwood status_effect/thaumaturgy: for half a minute the next thing the devotee says carries far and loud; then it is spent.
/datum/status_effect/rogue_thaumaturgy
	id = "rogue_thaumaturgy"
	status_type = STATUS_EFFECT_UNIQUE
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = /atom/movable/screen/alert/status_effect/rogue_thaumaturgy
	/// The caster's rank in miracles (Ratwood potency): the further the voice carries.
	var/potency = 1

/datum/status_effect/rogue_thaumaturgy/on_creation(mob/living/new_owner, skill_power)
	potency = skill_power
	duration = rogue_value("thaumaturgy_time")
	return ..()

/datum/status_effect/rogue_thaumaturgy/on_apply()
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(on_say))
	return TRUE

/datum/status_effect/rogue_thaumaturgy/on_remove()
	UnregisterSignal(owner, COMSIG_MOB_SAY)
	return ..()

/// What the devotee says is the loud and the far for it, if it is not a whisper (Ratwood say.dm: SPAN_REALLYBIG and more range).
/datum/status_effect/rogue_thaumaturgy/proc/on_say(datum/source, list/speech_args)
	SIGNAL_HANDLER
	var/list/mods = speech_args[SPEECH_MODS]
	if(mods?[WHISPER_MODE])
		return
	var/list/spans = speech_args[SPEECH_SPANS]
	spans |= SPAN_REALLYBIG
	speech_args[SPEECH_RANGE] += rogue_value("thaumaturgy_voice_extra") + potency
	qdel(src)

/atom/movable/screen/alert/status_effect/rogue_thaumaturgy
	name = "Thaumaturgical Voice"
	desc = "The power of my god will make the next thing I say carry much further!"
	icon = ROGUE_COMBAT_ALERTS_ICON
	icon_state = "holy"

/// Ratwood orison "Thaumaturgy" (Touch in the hand of the prayer): on oneself, a prayer, and the next word spoken is loud and far;
/// on a light, or a flame at range, the flames about it flicker (torches and flares go out, lanterns waver), more the more skilled;
/// on a creature, the blessing of light on them is taken away. A prayer that does something costs devotion, and a little more for
/// each flame it touches.
/datum/action/cooldown/spell/pointed/rogue_miracle/thaumaturgy
	name = "Thaumaturgy"
	desc = "Direct a sliver of divine thaumaturgy: on myself, to make the next thing I say LOUD and far-carrying; on a light source or the ground, to make the flames nearby flicker; on a creature, to dismiss a blessing of light from them."
	button_icon_state = "thaumaturgy"
	sound = null
	value_key = "thaumaturgy"
	miracle_tier = ROGUE_MIRACLE_TIER_0
	miracle_forks = "Ratwood, Azure Peak, Twilight Axis"
	miracle_gods = "every god's orison T0"

/datum/action/cooldown/spell/pointed/rogue_miracle/thaumaturgy/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	if(cast_on != owner && !isturf(cast_on) && !isliving(cast_on) && !istype(cast_on, /obj/machinery/light) && !istype(cast_on, /obj/item/flashlight))
		to_chat(owner, span_warning("I can only direct thaumaturgical prayers towards myself, the ground, and any nearby light sources."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/thaumaturgy/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/caster = owner
	var/rank = caster.rogue_skill_rank(/datum/attribute/skill/magic/holy)
	if(cast_on == caster)
		if(caster.has_status_effect(/datum/status_effect/rogue_thaumaturgy))
			return fail("I'm already empowered with divine thaumaturgy!")
		INVOKE_ASYNC(src, PROC_REF(empower_voice), caster, rank)
		return
	if(isliving(cast_on))
		var/mob/living/blessed = cast_on
		if(!blessed.has_status_effect(/datum/status_effect/rogue_holy_light))
			return fail("My divine thaumaturgy can only augment my own voice, or dismiss the blessing of light on others.")
		blessed.remove_status_effect(/datum/status_effect/rogue_holy_light)
		caster.visible_message(span_notice("[caster] issues a reserved gesture towards [blessed], and the holy light leaves [blessed.p_them()]."), span_notice("I gesture towards [blessed], and [blessed.p_their()] blessing of light recedes."))
		return
	var/flickered = 0
	for(var/obj/machinery/light/lamp in view(rogue_value("thaumaturgy_flame_range") + rank, cast_on))
		lamp.flicker(rank * rogue_value("thaumaturgy_flicker_rank"))
		flickered++
	for(var/obj/item/flashlight/flare/torch in view(rogue_value("thaumaturgy_flame_range") + rank, cast_on))
		if(torch.light_on)
			torch.turn_off()
			flickered++
	if(!flickered)
		return fail("My faith finds no flames to show its passage...")
	caster.rogue_devotion?.adjust(-flickered * rogue_value("thaumaturgy_flame_devotion"))
	to_chat(caster, span_notice("I direct the weight of my faith towards nearby flames, causing them to flicker!"))

/datum/action/cooldown/spell/pointed/rogue_miracle/thaumaturgy/proc/empower_voice(mob/living/carbon/human/caster, rank)
	caster.visible_message(span_notice("[caster] lowers [caster.p_their()] head solemnly, whispered prayers spilling from [caster.p_their()] lips..."), span_notice("O holy gods, share unto me a sliver of your power..."))
	if(!do_after(caster, max(rogue_value("thaumaturgy_prayer_base") - rank * rogue_value("thaumaturgy_prayer_rank"), 0), target = caster))
		refund()
		return
	caster.apply_status_effect(/datum/status_effect/rogue_thaumaturgy, rank)
	caster.visible_message(span_notice("[caster] throws open [caster.p_their()] eyes, suddenly emboldened!"), span_notice("A feeling of power wells up in my throat: speak, and many will hear!"))

/// Ratwood buff/lay_hands: a gentle, slow mending of the body, refreshed as long as the one who lays hands keeps still.
/datum/status_effect/rogue_lay_hands
	id = "rogue_lay_hands"
	status_type = STATUS_EFFECT_REFRESH
	tick_interval = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/rogue_lay_hands
	/// Healing every second (Ratwood healing_on_tick).
	var/healing = 0

/datum/status_effect/rogue_lay_hands/on_creation(mob/living/new_owner, new_healing)
	healing = new_healing
	duration = rogue_value("lay_hands_time")
	return ..()

/datum/status_effect/rogue_lay_hands/refresh(effect, new_healing)
	healing = new_healing
	duration = rogue_value("lay_hands_time")

/datum/status_effect/rogue_lay_hands/on_apply()
	if(!owner.get_filter(ROGUE_LAY_HANDS_FILTER))
		owner.add_filter(ROGUE_LAY_HANDS_FILTER, 2, list("type" = "outline", "color" = "#FFD700", "alpha" = 50, "size" = 1))
	playsound(owner, 'modular_redtard/faith/sound/churn.ogg', 50, FALSE)
	to_chat(owner, span_notice("Divine energy suffuses my body..."))
	return TRUE

/datum/status_effect/rogue_lay_hands/tick(seconds_between_ticks)
	var/amount = healing * seconds_between_ticks
	var/half = amount * rogue_value("lay_hands_other_share")
	new /obj/effect/temp_visual/heal(get_turf(owner), "#FFD700")
	if(owner.get_blood_volume() < BLOOD_VOLUME_NORMAL)
		owner.adjust_blood_volume(half, maximum = BLOOD_VOLUME_NORMAL)
	if(iscarbon(owner))
		var/mob/living/carbon/patient = owner
		patient.rogue_heal_wounds(amount)
	owner.adjust_brute_loss(-amount, updating_health = FALSE)
	owner.adjust_fire_loss(-amount, updating_health = FALSE)
	owner.adjust_oxy_loss(-half, updating_health = FALSE)
	owner.adjust_tox_loss(-half, updating_health = FALSE)
	owner.adjust_organ_loss(ORGAN_SLOT_BRAIN, -half)
	owner.updatehealth()

/datum/status_effect/rogue_lay_hands/on_remove()
	owner.remove_filter(ROGUE_LAY_HANDS_FILTER)
	to_chat(owner, span_notice("The divine energy fades from my body."))
	return ..()

/atom/movable/screen/alert/status_effect/rogue_lay_hands
	name = "Laying of Hands"
	desc = "Divine power flows through me, knitting my wounds."
	icon = ROGUE_COMBAT_ALERTS_ICON
	icon_state = "buff"

/// Ratwood orison "Lay Hands" (intent Shove of the prayer): after a prayer, shorter the more skilled, the devotee channels healing
/// into a living creature beside them, cycle after cycle, for as long as both keep still and the devotion lasts; each cycle takes
/// devotion, less the more skilled, and mends gently (more the more skilled).
/datum/action/cooldown/spell/pointed/rogue_miracle/lay_hands
	name = "Lay Hands"
	desc = "Lay hands upon an adjacent creature to channel divine restorative power through my touch. Both of us must remain still for the channeling to continue."
	button_icon_state = "thaumaturgy"
	sound = null
	value_key = "lay_hands"
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_0
	miracle_forks = "Ratwood, Azure Peak, Twilight Axis"
	miracle_gods = "every god's orison T0"

/datum/action/cooldown/spell/pointed/rogue_miracle/lay_hands/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	if(!isliving(cast_on))
		to_chat(owner, span_notice("I can only channel healing through living beings."))
		return FALSE
	var/mob/living/patient = cast_on
	if(patient.stat == DEAD)
		to_chat(owner, span_warning("The dead are beyond my reach..."))
		return FALSE
	if(patient.has_status_effect(/datum/status_effect/rogue_lay_hands))
		to_chat(owner, span_notice("[patient] is already receiving the laying of hands."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/lay_hands/cast(mob/living/cast_on)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(channel), owner, cast_on)

/datum/action/cooldown/spell/pointed/rogue_miracle/lay_hands/proc/channel(mob/living/carbon/human/caster, mob/living/patient)
	var/rank = caster.rogue_skill_rank(/datum/attribute/skill/magic/holy)
	caster.visible_message(span_notice("[caster] places [caster.p_their()] hands upon [patient], divine power beginning to gather..."), span_notice("I lay my hands upon [patient], channeling the gods' restorative power..."))
	if(!do_after(caster, max(rogue_value("lay_hands_prayer_base") - rank * rogue_value("lay_hands_prayer_rank"), 0), target = patient))
		refund()
		return
	var/healing = clamp(rogue_value("lay_hands_power_base") + rank * rogue_value("lay_hands_power_rank"), rogue_value("lay_hands_power_base"), rogue_value("lay_hands_power_max"))
	var/devotion_per_cycle = clamp(rogue_value("lay_hands_devotion_base") - rank, rogue_value("lay_hands_devotion_min"), rogue_value("lay_hands_devotion_max"))
	var/cycle_time = max(rogue_value("lay_hands_cycle_base") - rank * rogue_value("lay_hands_cycle_rank"), 1)
	caster.visible_message(span_notice("Divine energy suffuses [patient] as [caster]'s channeling takes hold!"), span_notice("The connection is established - the gods' power flows through me into [patient]."))
	var/first_cycle = TRUE
	while(do_after(caster, cycle_time, target = patient))
		if(!caster.rogue_devotion || caster.rogue_devotion.devotion < devotion_per_cycle)
			to_chat(caster, span_warning("My devotion is exhausted - I can no longer maintain the channeling!"))
			break
		if(patient.stat == DEAD)
			to_chat(caster, span_warning("[patient] has passed beyond my healing touch..."))
			break
		if(!patient.Adjacent(caster))
			to_chat(caster, span_warning("I am too far from [patient] - the blessing fades!"))
			break
		patient.apply_status_effect(/datum/status_effect/rogue_lay_hands, healing)
		caster.rogue_devotion.adjust(-devotion_per_cycle)
		if(first_cycle)
			to_chat(caster, span_notice("I maintain my focus, channeling the gods' restorative power through my hands..."))
			first_cycle = FALSE
	caster.visible_message(span_notice("[caster] withdraws [caster.p_their()] hands from [patient], the divine energy fading."), span_notice("I release my concentration and the channeling ends."))

#undef ROGUE_LAY_HANDS_FILTER
