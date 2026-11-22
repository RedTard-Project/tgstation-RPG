/// The miracles of Graggar that the basket (miracle.dm) did not have yet: Bloodrage, Call to Slaughter, Unholy Grasp and Revel in
/// Slaughter (Ratwood modular_azurepeak/code/modules/spells/pantheon/inhumen/graggar.dm; Azure Peak and Twilight Axis have the
/// grasp as a thrown organ net, the roar as Call to Slaughter and the rage as Bloodrage in a form of their own). The numbers are
/// in faith.txt, the ones of a cast by miracle_<value_key>_*.

#define ROGUE_GRAGGAR_ICON 'modular_redtard/faith/icons/graggarmiracles.dmi'

/// Ratwood buff/call_to_slaughter: Graggar's call puts the strength of rage into the arm of his own.
/datum/status_effect/rogue_miracle_stats/call_to_slaughter
	id = "rogue_call_to_slaughter"
	start_message = "<span class='bloody'>LAMBS TO THE SLAUGHTER!</span>"

/datum/status_effect/rogue_miracle_stats/call_to_slaughter/stat_changes()
	return list(ROGUE_STAT_STRENGTH = rogue_value("faith_call_to_slaughter_strength"), ROGUE_STAT_WILLPOWER = rogue_value("faith_call_to_slaughter_willpower"), ROGUE_STAT_CONSTITUTION = rogue_value("faith_call_to_slaughter_constitution"))

/datum/status_effect/rogue_miracle_stats/call_to_slaughter/new_duration()
	return rogue_value("faith_call_to_slaughter_time")

/// Ratwood debuff/call_to_slaughter: for everyone else the same call is a rotting stench that rattles the soul.
/datum/status_effect/rogue_miracle_stats/call_to_slaughter_cursed
	id = "rogue_call_to_slaughter_cursed"
	start_message = "<span class='warning'>A putrid rotting scent fills my nose as Graggar's call for slaughter rattles me to my core...</span>"

/datum/status_effect/rogue_miracle_stats/call_to_slaughter_cursed/stat_changes()
	return list(ROGUE_STAT_WILLPOWER = -rogue_value("faith_call_to_slaughter_curse_willpower"), ROGUE_STAT_CONSTITUTION = -rogue_value("faith_call_to_slaughter_curse_constitution"))

/datum/status_effect/rogue_miracle_stats/call_to_slaughter_cursed/new_duration()
	return rogue_value("faith_call_to_slaughter_time")

/// Ratwood Call to Slaughter "Call to Slaughter" (T1 of Graggar): the inhumen around the caster are made stronger, everyone else
/// who is an ally is made weaker; the devout of Psydon feel only a cold wave; the undead are left alone.
/datum/action/cooldown/spell/pointed/rogue_miracle/call_to_slaughter
	name = "Call to Slaughter"
	desc = "Grants me and the inhumen nearby a bonus to strength, willpower and constitution, and takes it from the rest of my allies."
	button_icon = ROGUE_GRAGGAR_ICON
	button_icon_state = "call_to_slaughter"
	sound = 'sound/effects/magic/timeparadox2.ogg'
	invocation = "LAMBS TO THE SLAUGHTER!"
	invocation_type = INVOCATION_SHOUT
	click_to_activate = FALSE
	value_key = "call_to_slaughter"
	miracle_tier = ROGUE_MIRACLE_TIER_1
	miracle_forks = "Ratwood"
	miracle_gods = "Graggar T1"

/datum/action/cooldown/spell/pointed/rogue_miracle/call_to_slaughter/cast(atom/cast_on)
	. = ..()
	var/mob/living/caster = owner
	for(var/mob/living/carbon/target in view(rogue_value("faith_call_to_slaughter_range"), get_turf(caster)))
		var/datum/patron/creed
		if(ishuman(target))
			var/mob/living/carbon/human/believer = target
			creed = believer.rogue_patron
		if(istype(creed, /datum/patron/inhumen))
			target.apply_status_effect(/datum/status_effect/rogue_miracle_stats/call_to_slaughter)
			continue
		if(istype(creed, /datum/patron/psydon))
			to_chat(target, span_danger("I feel a surge of cold wash over me, leaving my body as quick as it hit..."))
			continue
		if(!caster.faction_check_atom(target))
			continue
		if(target.mob_biotypes & MOB_UNDEAD)
			continue
		target.apply_status_effect(/datum/status_effect/rogue_miracle_stats/call_to_slaughter_cursed)

/// Ratwood Bloodrush "Bloodrage" (T0 of Graggar): the devotee shakes off every stun, hold and fall, gets to their feet and is
/// filled with an adrenaline rush for a while.
/datum/action/cooldown/spell/pointed/rogue_miracle/bloodrage
	name = "Bloodrush"
	desc = "Throws off every stun and fall, gets me to my feet and fills me with an adrenaline rush for a short while."
	button_icon = ROGUE_GRAGGAR_ICON
	button_icon_state = "bloodrage"
	sound = 'sound/effects/magic/enter_blood.ogg'
	invocation = "GRAGGAR!! GRAGGAR!! GRAGGAR!!"
	invocation_type = INVOCATION_SHOUT
	click_to_activate = FALSE
	value_key = "bloodrage"
	miracle_tier = ROGUE_MIRACLE_TIER_0
	miracle_forks = "Ratwood"
	miracle_gods = "Graggar T0"

/datum/action/cooldown/spell/pointed/rogue_miracle/bloodrage/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/raging = owner
	if(raging.resting)
		raging.set_resting(FALSE, TRUE)
	raging.emote("warcry")
	for(var/effect in list(/datum/status_effect/incapacitating/immobilized, /datum/status_effect/incapacitating/paralyzed, /datum/status_effect/incapacitating/stun, /datum/status_effect/incapacitating/knockdown))
		raging.remove_status_effect(effect)
	raging.apply_status_effect(/datum/status_effect/rogue_adrenaline)
	raging.visible_message(span_danger("[raging] rises upward, boiling with immense rage!"))

/// What the net of gore does to the legs it is thrown at: Ratwood ensnares them for as long as the victim takes to slip out, the
/// less the stronger they are, and wears the victim down meanwhile.
/datum/status_effect/rogue_miracle_stats/gore_net
	id = "rogue_gore_net"
	start_message = "<span class='danger'>A net of gore entraps me! How can I move?</span>"
	end_message = "<span class='notice'>I slip free of the net of gore.</span>"

/datum/status_effect/rogue_miracle_stats/gore_net/stat_changes()
	return list(ROGUE_STAT_SPEED = -rogue_value("faith_gore_net_speed"), ROGUE_STAT_WILLPOWER = -rogue_value("faith_gore_net_willpower"))

/datum/status_effect/rogue_miracle_stats/gore_net/on_apply()
	. = ..()
	owner.rogue_slow_for(duration)

/// Ratwood item/net/unholy_grasp: viscera twisted into a net in the caster's hand. It cannot be kept: let go of it any way but
/// a throw and it falls back into gore. A throw that lands on a creature ensnares it and the net falls apart; one that
/// lands anywhere else does too.
/obj/item/net/unholy_grasp
	color = "#80182e"
	slot_flags = NONE
	/// It is falling apart already.
	var/collapsing = FALSE

/obj/item/net/unholy_grasp/dropped(mob/user, silent = FALSE)
	. = ..()
	// A throw drops it first and then sends it flying: one tick to tell a throw from a let-go.
	addtimer(CALLBACK(src, PROC_REF(collapse_if_not_thrown), user), 1)

/obj/item/net/unholy_grasp/proc/collapse_if_not_thrown(mob/user)
	if(!throwing)
		revert_to_viscera(user)

/// The net goes back to what it was: the viscera, in the hand of whoever asked for it, or where it lay.
/obj/item/net/unholy_grasp/proc/revert_to_viscera(mob/user, to_hand = FALSE)
	if(collapsing || QDELETED(src))
		return
	collapsing = TRUE
	var/turf/where = get_turf(src)
	qdel(src)
	if(!where)
		return
	var/obj/item/alch/viscera/gore = new(where)
	if(to_hand && user)
		user.put_in_hands(gore)
	if(user)
		to_chat(user, span_danger("The unholy net collapses back into a mess of viscera!"))

/obj/item/net/unholy_grasp/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(collapsing || QDELETED(src))
		return
	collapsing = TRUE
	var/turf/where = get_turf(hit_atom)
	if(iscarbon(hit_atom))
		var/mob/living/carbon/victim = hit_atom
		var/slip_time = max(rogue_value("faith_gore_net_time_least"), rogue_value("faith_gore_net_time") - max(0, victim.rogue_stat(ROGUE_STAT_STRENGTH) - rogue_value("faith_gore_net_strong")) * rogue_value("faith_gore_net_strength_step"))
		victim.apply_status_effect(/datum/status_effect/rogue_miracle_stats/gore_net, slip_time)
		victim.visible_message(span_danger("The net of gore ensnares [victim]!"), span_userdanger("The net of gore entraps me!"))
	if(where)
		new /obj/effect/decal/cleanable/blood(where)
		playsound(where, 'sound/effects/splat.ogg', 50, TRUE)
	qdel(src)

/// Ratwood blood_net "Unholy Grasp" (T2 of Graggar): the viscera in the hand are twisted into a net of gore; cast again with
/// the net in the hand to unmake it, which costs nothing.
/datum/action/cooldown/spell/pointed/rogue_miracle/unholy_grasp
	name = "Unholy Grasp"
	desc = "Twist the viscera in my hand into a writhing net of gore. Cast again to unmake it back into gore. Throw it to snare a foe's legs."
	button_icon = ROGUE_GRAGGAR_ICON
	button_icon_state = "unholy_grasp"
	sound = 'sound/effects/splat.ogg'
	click_to_activate = FALSE
	value_key = "unholy_grasp"
	miracle_tier = ROGUE_MIRACLE_TIER_2
	miracle_forks = "Ratwood, Azure Peak, Twilight Axis"
	miracle_gods = "Graggar T2"

/datum/action/cooldown/spell/pointed/rogue_miracle/unholy_grasp/cast(atom/cast_on)
	. = ..()
	var/mob/living/caster = owner
	var/obj/item/held = caster.get_active_held_item()
	if(istype(held, /obj/item/net/unholy_grasp))
		var/obj/item/net/unholy_grasp/net = held
		net.revert_to_viscera(caster, TRUE)
		return fail()
	if(!istype(held, /obj/item/alch/viscera))
		return fail("I'm missing viscera to twist into a net.")
	qdel(held)
	var/obj/item/net/unholy_grasp/grasp = new(get_turf(caster))
	caster.put_in_hands(grasp)
	caster.visible_message(span_danger("The viscera in [caster]'s hand twists into a writhing net of gore!"), span_danger("The viscera in my hand twists into a writhing net of gore!"))

/// For Revel in Slaughter the pain is held apart from the bleeding: Ratwood lets them go off at different times.
/datum/status_effect/rogue_inflamed/pain_only
	id = "rogue_inflamed_pain"

/// Ratwood revel_in_slaughter "Revel in Slaughter" (T3 of Graggar): the spilled blood around the caster is spent to make the
/// target bleed and hurt more, the bleeding for longer than the pain.
/datum/action/cooldown/spell/pointed/rogue_miracle/revel_in_slaughter
	name = "Revel in Slaughter"
	desc = "The blood of my enemy shall boil, their skin feeling as if it's being ripped apart! Spills the blood around me to make their wounds bleed and hurt more."
	button_icon = ROGUE_GRAGGAR_ICON
	button_icon_state = "revel_in_slaughter"
	sound = 'modular_redtard/faith/sound/antimagic.ogg'
	invocation = "YOUR BLOOD WILL BOIL TILL IT'S SPILLED!"
	invocation_type = INVOCATION_SHOUT
	value_key = "revel_in_slaughter"
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_3
	miracle_forks = "Ratwood"
	miracle_gods = "Graggar T3"

/datum/action/cooldown/spell/pointed/rogue_miracle/revel_in_slaughter/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !ishuman(cast_on))
		to_chat(owner, span_warning("Only a man can be made to boil."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/revel_in_slaughter/cast(mob/living/carbon/human/cast_on)
	. = ..()
	var/spent = 0
	for(var/obj/effect/decal/cleanable/blood/spilled in view(rogue_value("faith_revel_range"), owner))
		spent++
		qdel(spilled)
	if(!spent)
		return fail("Graggar demands BLOOD to call upon his powers!")
	cast_on.apply_status_effect(/datum/status_effect/rogue_inflamed, rogue_value("faith_revel_bleed_time"), rogue_value("faith_revel_mult"), 1)
	cast_on.apply_status_effect(/datum/status_effect/rogue_inflamed/pain_only, rogue_value("faith_revel_pain_time"), 1, rogue_value("faith_revel_mult"))
	cast_on.visible_message(span_danger("[cast_on]'s wounds become inflamed as their vitality is sapped away!"), span_warning("My skin feels like pins and needles, as if something were ripping and tearing at me!"))

#undef ROGUE_GRAGGAR_ICON
