/// The miracles of light and fire of the basket (miracle.dm): Azure Peak's orison of light (spells/orison.dm, carried over
/// into Ratwood and Twilight Axis) and the ignitions of Ratwood, Azure Peak and Twilight Axis.

#define ROGUE_HOLY_LIGHT_FILTER "rogue_holy_light"

/// Azure Peak light_buff: a holy glow around a living creature, five minutes more with every orison.
/datum/status_effect/rogue_holy_light
	id = "rogue_holy_light"
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null
	/// How far the glow reaches; a skilled caster's goes further.
	var/glow_range = 0
	var/obj/effect/dummy/lighting_obj/moblight/glow

/datum/status_effect/rogue_holy_light/on_creation(mob/living/new_owner, new_range)
	duration = rogue_value("faith_holy_light_time")
	glow_range = new_range || rogue_value("faith_orison_light_glow_least")
	return ..()

/datum/status_effect/rogue_holy_light/on_apply()
	playsound(owner, 'modular_redtard/faith/sound/whiteflame.ogg', 75, FALSE)
	to_chat(owner, span_notice("Light blossoms into being around me!"))
	if(!owner.get_filter(ROGUE_HOLY_LIGHT_FILTER))
		owner.add_filter(ROGUE_HOLY_LIGHT_FILTER, 2, list("type" = "outline", "color" = "#ffffff", "alpha" = 60, "size" = 1))
	glow = owner.mob_light(glow_range, 1, "#f5edda")
	return TRUE

/datum/status_effect/rogue_holy_light/refresh(effect, new_range)
	duration += rogue_value("faith_holy_light_time")
	if(new_range > glow_range)
		glow_range = new_range
		glow?.set_light_range(glow_range)

/datum/status_effect/rogue_holy_light/on_remove()
	to_chat(owner, span_notice("The miraculous light surrounding me has fled..."))
	owner.remove_filter(ROGUE_HOLY_LIGHT_FILTER)
	QDEL_NULL(glow)

/datum/status_effect/rogue_holy_light/get_examine_text(mob/examiner)
	return span_notice("[owner.p_They()] [owner.p_are()] surrounded by an aura of gentle light.")

/// Azure Peak's orison of light (cast_light()): a short prayer at arm's length - shorter the more skilled - makes a living
/// creature glow with holy light for five minutes; again, and it glows five minutes longer.
/datum/action/cooldown/spell/pointed/rogue_miracle/orison_light
	name = "Orison of Light"
	desc = "Ask for a light to guide the way: a living creature at arm's length glows for five minutes, longer with every prayer."
	button_icon_state = "thaumaturgy"
	value_key = "orison_light"
	miracle_tier = ROGUE_MIRACLE_TIER_0
	miracle_forks = "Azure Peak, Twilight Axis, Ratwood"
	miracle_gods = "every god's orison T0"

/datum/action/cooldown/spell/pointed/rogue_miracle/orison_light/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !isliving(cast_on))
		to_chat(owner, span_warning("Only living creatures can bear the blessing of light."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/orison_light/cast(mob/living/cast_on)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(bless_with_light), owner, cast_on)

/datum/action/cooldown/spell/pointed/rogue_miracle/orison_light/proc/bless_with_light(mob/living/carbon/human/caster, mob/living/target)
	var/rank = caster.rogue_skill_rank(/datum/attribute/skill/magic/holy)
	if(target == caster)
		caster.visible_message(span_notice("[caster] closes [caster.p_their()] eyes and places a glowing hand upon [caster.p_their()] chest..."), span_notice("Gods above, I ask but for a light to guide the way..."))
	else
		caster.visible_message(span_notice("[caster] reaches gently towards [target], beads of light glimmering at [caster.p_their()] fingertips..."), span_notice("Gods above, I ask but for a light to guide the way..."))
	// The prayer (Azure 3.5 seconds), shorter by a step per rank in miracles.
	if(!do_after(caster, max(rogue_value("faith_orison_light_prayer") - rogue_value("faith_orison_light_prayer_rank") * rank, rogue_value("faith_orison_light_prayer_least")), target = target))
		refund()
		return
	target.apply_status_effect(/datum/status_effect/rogue_holy_light, clamp(rank + rogue_value("faith_orison_light_glow_extra"), rogue_value("faith_orison_light_glow_least"), rogue_value("faith_orison_light_glow_most")))

/// Ratwood ignition "Ignition" (acolyte/astrata.dm; Azure Peak miracle/ignition for Astrata, Malum and the Ten, Twilight Axis
/// TAignition; Ratwood's Malum's Fire works alike): a pointed finger lights a torch, a candle, a hearth or anything that burns.
/datum/action/cooldown/spell/pointed/rogue_miracle/ignition
	name = "Ignition"
	desc = "Ignite a flammable object at range: a torch, a candle, a hearth, anything that burns."
	button_icon = ROGUE_MIRACLES_ASTRATA_ICON
	button_icon_state = "ignite"
	sound = 'modular_redtard/faith/sound/heal.ogg'
	value_key = "ignition"
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_0
	miracle_forks = "Ratwood, Azure Peak, Twilight Axis"
	miracle_gods = "Astrata T0, Malum T0, the Ten Undivided T0"

/datum/action/cooldown/spell/pointed/rogue_miracle/ignition/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	if(!isobj(cast_on))
		to_chat(owner, span_warning("I can only set things alight."))
		return FALSE
	var/obj/thing = cast_on
	if(!istype(thing, /obj/item/flashlight/flare) && !istype(thing, /obj/machinery/light/rogue) && (!(thing.resistance_flags & FLAMMABLE) || (thing.resistance_flags & FIRE_PROOF)))
		to_chat(owner, span_warning("[thing] would not burn."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/ignition/cast(obj/cast_on)
	. = ..()
	if(istype(cast_on, /obj/item/flashlight/flare))
		var/obj/item/flashlight/flare/flare = cast_on
		flare.ignition()
		if(!flare.light_on)
			return fail("I point at [flare], but it fails to catch fire.")
	else if(istype(cast_on, /obj/machinery/light/rogue))
		var/obj/machinery/light/rogue/fire = cast_on
		if(fire.lit)
			return fail("[fire] is already burning.")
		fire.ignite()
		if(!fire.lit)
			return fail("I point at [fire], but it fails to catch fire.")
	else
		cast_on.fire_act(rogue_value("faith_ignition_heat"), rogue_value("faith_ignition_volume"))
	owner.visible_message("<font color='yellow'>[owner] points at [cast_on], igniting it with sacred flames!</font>")

#undef ROGUE_HOLY_LIGHT_FILTER
