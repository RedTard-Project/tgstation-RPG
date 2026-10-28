/// Ratwood revive "Anastasis" (acolyte/astrata.dm; Twilight Axis TArevive, Azure Peak miracle/anastasis/astrata): a prayer
/// of five seconds over a dead body, with a holy symbol and a cross nearby, calls the soul back into it - even one that
/// gave up its body - and mends it enough to live. Holy light unmakes the undead instead.
/datum/action/cooldown/spell/pointed/rogue_miracle/anastasis
	name = "Anastasis"
	desc = "Focus the gods' energy through a cross nearby to bring the target back from death. Unmakes the undead."
	button_icon = ROGUE_MIRACLES_ASTRATA_ICON
	button_icon_state = "revive"
	sound = 'modular_redtard/faith/sound/revive.ogg'
	cooldown_time = 2 MINUTES
	cast_range = 1
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_3
	devotion_cost = 80
	needs_holy_symbol = TRUE
	miracle_forks = "Ratwood, Azure Peak, Twilight Axis"
	miracle_gods = "Astrata T3"
	/// The prayer before the soul returns (Ratwood chargetime 5 seconds).
	var/prayer_time = 5 SECONDS
	/// How far a cross may stand (Ratwood oview(5)).
	var/cross_range = 5
	/// Damage of each kind the body is mended down to (TG heal_and_revive()).
	var/mended_to = 50

/datum/action/cooldown/spell/pointed/rogue_miracle/anastasis/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	if(!isliving(cast_on))
		to_chat(owner, span_warning("Only the dead can be called back."))
		return FALSE
	var/mob/living/body = cast_on
	if(body.stat != DEAD && !(body.mob_biotypes & MOB_UNDEAD))
		to_chat(owner, span_warning("[body] is not dead."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/anastasis/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	if(!(locate(/obj/structure/fluff/psycross) in oview(cross_range, owner)))
		to_chat(owner, span_warning("I need a holy cross nearby."))
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/pointed/rogue_miracle/anastasis/cast(mob/living/cast_on)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(call_back), owner, cast_on)

/datum/action/cooldown/spell/pointed/rogue_miracle/anastasis/proc/call_back(mob/living/carbon/human/caster, mob/living/body)
	caster.visible_message(span_notice("[caster] raises [caster.p_their()] hands over [body], calling upon the gods..."), span_notice("I call upon the gods to return [body] to this world..."))
	if(!do_after(caster, prayer_time, target = body))
		to_chat(caster, span_warning("My prayer was interrupted!"))
		refund()
		return
	if(burns_undead(body))
		body.visible_message(span_danger("[body] is unmade by holy light!"), span_userdanger("I'm unmade by holy light!"))
		body.gib()
		return
	if(body.stat != DEAD)
		refund()
		return
	body.grab_ghost(force = TRUE)
	if(!body.mind?.active)
		to_chat(caster, span_warning("[body] will not return from the afterlife."))
		refund()
		return
	if(!body.heal_and_revive(mended_to))
		to_chat(caster, span_warning("Nothing happens."))
		refund()
		return
	body.visible_message(span_notice("[body] is revived by holy light!"), span_green("I awake from the void."))
	body.emote("gasp")
	body.set_jitter_if_lower(10 SECONDS)
