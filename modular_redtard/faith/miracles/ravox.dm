/// The miracles of Ravox that the basket (miracle.dm) did not have yet: Divine Strike, Call to Arms, Persistence, Tug of War and
/// Challenge (Ratwood code/modules/spells/roguetown/acolyte/ravox.dm; Azure Peak has Tug of War, Persistence, Call to Arms
/// and Challenge in its own form). The numbers are in faith.txt, the ones of a cast by miracle_<value_key>_*.

#define ROGUE_RAVOX_ICON 'modular_redtard/faith/icons/ravoxmiracles.dmi'
#define ROGUE_RAVOX_FLAGS_ICON 'modular_redtard/faith/icons/ravox_flags.dmi'

/// Ratwood debuff/ravox_burden: divine chains on the arms and legs, a slower and weaker body for a while.
/datum/status_effect/rogue_miracle_stats/ravox_burden
	id = "rogue_ravox_burden"
	start_message = "<span class='warning'>My arms and legs are restrained by divine chains!</span>"

/datum/status_effect/rogue_miracle_stats/ravox_burden/stat_changes()
	return list(ROGUE_STAT_SPEED = -rogue_value("faith_ravox_burden_speed"), ROGUE_STAT_WILLPOWER = -rogue_value("faith_ravox_burden_willpower"))

/datum/status_effect/rogue_miracle_stats/ravox_burden/new_duration()
	return rogue_value("faith_ravox_burden_time")

/// Ratwood buff/call_to_arms: the voice of Ravox makes the arm stronger and the will harder.
/datum/status_effect/rogue_miracle_stats/call_to_arms
	id = "rogue_call_to_arms"
	start_message = "<span class='bloody'>FOR GLORY AND HONOR!</span>"

/datum/status_effect/rogue_miracle_stats/call_to_arms/stat_changes()
	return list(ROGUE_STAT_STRENGTH = rogue_value("faith_call_to_arms_strength"), ROGUE_STAT_WILLPOWER = rogue_value("faith_call_to_arms_willpower"), ROGUE_STAT_CONSTITUTION = rogue_value("faith_call_to_arms_constitution"))

/datum/status_effect/rogue_miracle_stats/call_to_arms/new_duration()
	return rogue_value("faith_call_to_arms_time")

/// Ratwood debuff/call_to_arms: the same voice rocks the soul of the inhumen.
/datum/status_effect/rogue_miracle_stats/call_to_arms_cursed
	id = "rogue_call_to_arms_cursed"
	start_message = "<span class='warning'>His voice keeps ringing in my ears, rocking my soul...</span>"

/datum/status_effect/rogue_miracle_stats/call_to_arms_cursed/stat_changes()
	return list(ROGUE_STAT_WILLPOWER = -rogue_value("faith_call_to_arms_curse_willpower"), ROGUE_STAT_CONSTITUTION = -rogue_value("faith_call_to_arms_curse_constitution"))

/datum/status_effect/rogue_miracle_stats/call_to_arms_cursed/new_duration()
	return rogue_value("faith_call_to_arms_time")

/// Ratwood status_effect/divine_strike: the next blow the devotee lands (with the weapon in the hand, which glows, or a fist)
/// binds the one it hits in the chains of Ravox. A blow that was parried does not spend it.
/datum/status_effect/rogue_divine_strike
	id = "rogue_divine_strike"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	tick_interval = STATUS_EFFECT_NO_TICK
	/// The weapon that was made to glow, and the one the last swing was aimed at.
	var/datum/weakref/lit_item
	var/datum/weakref/marked

/datum/status_effect/rogue_divine_strike/on_creation(mob/living/new_owner, obj/item/weapon)
	duration = rogue_value("faith_divine_strike_time")
	if(istype(weapon) && !(weapon.item_flags & ABSTRACT) && !weapon.light_range)
		lit_item = WEAKREF(weapon)
		weapon.set_light(1)
	return ..()

/datum/status_effect/rogue_divine_strike/on_apply()
	RegisterSignal(owner, COMSIG_ROGUE_STRIKE_SWING, PROC_REF(on_swing))
	return TRUE

/datum/status_effect/rogue_divine_strike/on_remove()
	UnregisterSignal(owner, COMSIG_ROGUE_STRIKE_SWING)
	var/mob/living/victim = marked?.resolve()
	if(victim)
		UnregisterSignal(victim, COMSIG_ROGUE_STRIKE_LANDED)
	var/obj/item/weapon = lit_item?.resolve()
	if(weapon)
		weapon.set_light(0)

/// A swing is begun: the blow is watched on the one it is aimed at.
/datum/status_effect/rogue_divine_strike/proc/on_swing(datum/source, datum/rogue_strike/strike)
	SIGNAL_HANDLER
	var/mob/living/victim = strike.target
	if(!isliving(victim) || victim == owner)
		return NONE
	var/mob/living/old = marked?.resolve()
	if(old && old != victim)
		UnregisterSignal(old, COMSIG_ROGUE_STRIKE_LANDED)
	marked = WEAKREF(victim)
	RegisterSignal(victim, COMSIG_ROGUE_STRIKE_LANDED, PROC_REF(on_landed), override = TRUE)
	return NONE

/datum/status_effect/rogue_divine_strike/proc/on_landed(mob/living/victim, datum/rogue_strike/strike)
	SIGNAL_HANDLER
	if(strike.attacker != owner)
		return
	victim.apply_status_effect(/datum/status_effect/rogue_miracle_stats/ravox_burden)
	victim.visible_message(span_warning("The strike from [owner]'s [strike.weapon ? "weapon" : "fist"] causes [victim] to go stiff!"), vision_distance = COMBAT_MESSAGE_RANGE)
	qdel(src)

/// Ratwood divine_strike "Divine Strike" (T1 of Ravox): the next blow binds its target.
/datum/action/cooldown/spell/pointed/rogue_miracle/divine_strike
	name = "Divine Strike"
	desc = "Bless my next strike: the one it lands on is bound by divine chains and slowed."
	button_icon = ROGUE_RAVOX_ICON
	button_icon_state = "divine_strike"
	sound = 'sound/effects/magic/timeparadox2.ogg'
	invocation = "By Ravox, stand and fight!"
	invocation_type = INVOCATION_SHOUT
	click_to_activate = FALSE
	value_key = "divine_strike"
	miracle_tier = ROGUE_MIRACLE_TIER_1
	needs_holy_symbol = TRUE
	miracle_forks = "Ratwood"
	miracle_gods = "Ravox T1"

/datum/action/cooldown/spell/pointed/rogue_miracle/divine_strike/cast(atom/cast_on)
	. = ..()
	var/mob/living/caster = owner
	caster.apply_status_effect(/datum/status_effect/rogue_divine_strike, caster.get_active_held_item())

/// Ratwood call_to_arms "Call to Arms" (T2 of Ravox): the allies around the caster are made stronger; the inhumen are made
/// weaker; the devout of Psydon feel only a hot wave; the undead are left alone.
/datum/action/cooldown/spell/pointed/rogue_miracle/call_to_arms
	name = "Call to Arms"
	desc = "Grants me and all allies nearby a bonus to strength, willpower and constitution, and takes it from the inhumen."
	button_icon = ROGUE_RAVOX_ICON
	button_icon_state = "call_to_arms"
	sound = 'sound/effects/magic/timeparadox2.ogg'
	invocation = "FOR GLORY AND HONOR!"
	invocation_type = INVOCATION_SHOUT
	click_to_activate = FALSE
	value_key = "call_to_arms"
	miracle_tier = ROGUE_MIRACLE_TIER_2
	needs_holy_symbol = TRUE
	miracle_forks = "Ratwood, Azure Peak"
	miracle_gods = "Ravox T2"

/datum/action/cooldown/spell/pointed/rogue_miracle/call_to_arms/cast(atom/cast_on)
	. = ..()
	var/mob/living/caster = owner
	for(var/mob/living/carbon/target in view(rogue_value("faith_call_to_arms_range"), get_turf(caster)))
		var/datum/patron/creed
		if(ishuman(target))
			var/mob/living/carbon/human/believer = target
			creed = believer.rogue_patron
		if(istype(creed, /datum/patron/inhumen))
			target.apply_status_effect(/datum/status_effect/rogue_miracle_stats/call_to_arms_cursed)
			continue
		if(istype(creed, /datum/patron/psydon))
			to_chat(target, span_danger("I feel a hot wave wash over me, leaving as quickly as it came..."))
			continue
		if(!caster.faction_check_atom(target))
			continue
		if(target.mob_biotypes & MOB_UNDEAD)
			continue
		target.apply_status_effect(/datum/status_effect/rogue_miracle_stats/call_to_arms)

/// Ratwood persistence "Persistence" (T3 of Ravox): the undead are made to bleed and hurt more, the living have the bleeding and
/// the pain of the wounds of the chosen limb eased, the more so the more blood has been spilled around. The pain and bleeding
/// multipliers on the undead are given back by the effect itself, not by timers on the physiology.
/datum/action/cooldown/spell/pointed/rogue_miracle/persistence
	name = "Persistence"
	desc = "Harms the undead and makes their wounds bleed and hurt more; closes the wounds of the living faster and eases their pain, easier with spilled blood around."
	button_icon = ROGUE_RAVOX_ICON
	button_icon_state = "persistence"
	sound = 'sound/effects/magic/timeparadox2.ogg'
	invocation = "Ravox deems your persistence worthy!"
	invocation_type = INVOCATION_SHOUT
	value_key = "persistence"
	miracle_tier = ROGUE_MIRACLE_TIER_3
	needs_holy_symbol = TRUE
	miracle_forks = "Ratwood, Azure Peak"
	miracle_gods = "Ravox T3"

/datum/action/cooldown/spell/pointed/rogue_miracle/persistence/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !isliving(cast_on))
		to_chat(owner, span_warning("Only a living or undead body can be answered."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/persistence/cast(mob/living/cast_on)
	. = ..()
	if(cast_on.mob_biotypes & MOB_UNDEAD)
		if(!ishuman(cast_on))
			return fail()
		cast_on.apply_status_effect(/datum/status_effect/rogue_inflamed, rogue_value("faith_persistence_undead_time"), rogue_value("faith_persistence_undead_mult"), rogue_value("faith_persistence_undead_mult"))
		cast_on.visible_message(span_danger("[cast_on]'s wounds become inflamed as their vitality is sapped away!"), span_userdanger("Ravox inflames my wounds and weakens my body!"))
		return
	cast_on.visible_message(span_info("Warmth radiates from [cast_on] as their wounds seal over!"), span_notice("The pain from my wounds fades as warmth radiates from my soul!"))
	var/bonus = rogue_value("faith_persistence_bonus")
	for(var/obj/effect/decal/cleanable/blood/spilled in oview(rogue_value("faith_persistence_blood_range"), cast_on))
		bonus = min(bonus + rogue_value("faith_persistence_blood_step"), rogue_value("faith_persistence_bonus_cap"))
	if(bonus > rogue_value("faith_persistence_bonus"))
		to_chat(owner, "Channeling Ravox's power is easier in these conditions!")
	if(!iscarbon(cast_on))
		return
	var/mob/living/carbon/patient = cast_on
	var/obj/item/bodypart/affecting = patient.get_bodypart(check_zone(owner.zone_selected))
	if(!affecting)
		return
	for(var/datum/wound/wound as anything in affecting.wounds)
		// The pain of the wound is eased down to its share (rogue_ease_pain eases by half of what it is told).
		wound.rogue_ease_pain(wound.rogue_pain() * (1 - rogue_value("faith_persistence_pain_left")) * 2)
		var/datum/wound/rogue/bleeder = wound
		if(istype(bleeder) && !isnull(bleeder.rogue_clot_floor) && bleeder.rogue_bleed() > bleeder.rogue_clot_floor)
			var/difference = bleeder.rogue_bleed() - bleeder.rogue_clot_floor
			bleeder.rogue_set_bleed(max(bleeder.rogue_clot_floor, bleeder.rogue_bleed() - difference * bonus))
		else if(!istype(bleeder) && wound.blood_flow > 0)
			wound.adjust_blood_flow(-wound.blood_flow * bonus)

/// Ratwood tug_of_war "Tug of War" (T0 of Ravox): a chain of Ravox pulls the target toward the caster; it holds firmer the
/// better its stats are than the caster's, and a stronger caster, the undead and a skilled caster pull farther.
/datum/action/cooldown/spell/pointed/rogue_miracle/tug_of_war
	name = "Tug of War"
	desc = "Cast out a chain that tries to pull the target closer. Stronger in the hands of the skilled, and harder on the undead."
	button_icon = ROGUE_RAVOX_ICON
	button_icon_state = "ravox_tug"
	sound = 'sound/effects/magic/timeparadox2.ogg'
	invocation = "By Ravox, let your sins guide you to justice!"
	invocation_type = INVOCATION_SHOUT
	value_key = "tug_of_war"
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_0
	needs_holy_symbol = TRUE
	miracle_forks = "Ratwood, Azure Peak"
	miracle_gods = "Ravox T0"

/datum/action/cooldown/spell/pointed/rogue_miracle/tug_of_war/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !ishuman(cast_on))
		to_chat(owner, span_warning("The chain finds no hold in that."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/tug_of_war/cast(mob/living/carbon/human/cast_on)
	. = ..()
	var/mob/living/caster = owner
	var/pull = rogue_value("faith_tug_pull")
	var/slow = rogue_value("faith_tug_slowdown")
	var/chance = 0
	if(cast_on.mob_biotypes & MOB_UNDEAD)
		pull++
		chance += rogue_value("faith_tug_undead_chance")
	var/count = 0
	for(var/attribute in list(ROGUE_STAT_STRENGTH, ROGUE_STAT_WILLPOWER, ROGUE_STAT_CONSTITUTION, ROGUE_STAT_SPEED, ROGUE_STAT_FORTUNE))
		var/difference = caster.rogue_stat(attribute) - cast_on.rogue_stat(attribute)
		if(difference > 0)
			chance += rogue_value("faith_tug_stat_step")
			count++
		else if(difference < 0)
			chance -= rogue_value("faith_tug_stat_step")
	var/rank = caster.rogue_skill_rank(/datum/attribute/skill/magic/holy)
	chance += rank * rogue_value("faith_tug_skill_step")
	pull += floor((rank - 1) / rogue_value("faith_tug_ranks_per_pull"))
	caster.visible_message(span_boldwarning("[caster] yanks on a translucent chain sticking out of [cast_on]!"))
	if(count > rogue_value("faith_tug_majority"))
		pull++
		slow++
	if(prob(chance))
		cast_on.throw_at(caster, pull, 1, cast_on, FALSE)
		cast_on.visible_message(span_warning("[cast_on]'s body moves on its own!"))
		caster.Beam(cast_on, icon_state = "chain", time = 5)
	else
		cast_on.visible_message(span_warning("[cast_on] holds firm!"))
	cast_on.rogue_slowdown(slow)

GLOBAL_LIST_EMPTY(rogue_arena_folks)

/// The trial is over: one of the two goes back where they stood.
/proc/rogue_trial_return(mob/living/fighter, turf/home)
	if(QDELETED(fighter) || !home)
		return
	do_teleport(fighter, home, channel = TELEPORT_CHANNEL_MAGIC)

/// The arena of Ravox's trial (Ratwood area/rogue/indoors/ravoxarena): the place the challenged and the challenger are brought
/// to. No map has one yet: a mapper puts the area down with a flag of the challenger and a flag of the challenged in it.
/area/rogue/indoors/ravoxarena
	name = "Ravox's Arena"


/// What the arena returns after a trial: the things left lying in it go to the place of the challenged.
/area/rogue/indoors/ravoxarena/proc/cleanthearena(turf/returnzone)
	for(var/obj/item/trash in src)
		do_teleport(trash, returnzone, channel = TELEPORT_CHANNEL_MAGIC)
	GLOB.rogue_arena_folks.Cut()

/// Ratwood structure/fluff/ravox: the flags that mark where the challenger and the challenged are put, and where they return.
/obj/structure/fluff/ravox
	icon = ROGUE_RAVOX_FLAGS_ICON
	density = FALSE
	anchored = TRUE
	layer = BELOW_MOB_LAYER
	resistance_flags = INDESTRUCTIBLE

/obj/structure/fluff/ravox/proc/spawnprotection()
	playsound(src, 'sound/effects/magic/repulse.ogg', 80, TRUE)
	for(var/turf/tile in view(rogue_value("faith_challenge_push_range"), src))
		new /obj/effect/temp_visual/kinetic_blast(tile)
		for(var/atom/movable/thing in tile)
			if(thing == src || thing.anchored)
				continue
			var/mob/living/living_thing = thing
			if(istype(living_thing) && living_thing.can_block_magic(MAGIC_RESISTANCE_HOLY))
				continue
			var/distance = get_dist(src, thing)
			if(!distance)
				if(istype(living_thing))
					living_thing.Paralyze(rogue_value("faith_challenge_slam_stun"))
					living_thing.adjust_brute_loss(rogue_value("faith_challenge_slam_damage"))
					to_chat(living_thing, span_danger("You're slammed into the floor by Ravox's strength!!"))
				continue
			var/turf/away = get_edge_target_turf(src, get_dir(src, get_step_away(thing, src)))
			if(istype(living_thing))
				living_thing.Paralyze(rogue_value("faith_challenge_push_stun"))
				to_chat(living_thing, span_danger("You're thrown back by Ravox's strength!!"))
			var/maxthrow = rogue_value("faith_challenge_push_throw")
			thing.safe_throw_at(away, clamp(maxthrow - clamp(distance - 2, 0, distance), rogue_value("faith_challenge_push_least"), maxthrow), 1, null, force = MOVE_FORCE_EXTREMELY_STRONG)

/obj/structure/fluff/ravox/challenger
	name = "Flag of the challenger"
	desc = "Where the challenger will return after the trial is decided."
	icon_state = "ravoxchallenger"

/obj/structure/fluff/ravox/challenged
	name = "Flag of the challenged"
	desc = "Where the challenged will return after the trial is decided."
	icon_state = "ravoxchallenged"

/// The flag that comes out where a challenger was taken from: it marks the place for the trial's length, and throws everyone
/// back a second before it ends so that the one who comes back finds room.
/obj/structure/fluff/ravox/challenger/recall
/obj/structure/fluff/ravox/challenged/recall

/obj/structure/fluff/ravox/challenger/recall/Initialize(mapload)
	. = ..()
	QDEL_IN(src, rogue_value("faith_challenge_time"))
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/structure/fluff/ravox, spawnprotection)), rogue_value("faith_challenge_time") - rogue_value("faith_challenge_warning"))

/obj/structure/fluff/ravox/challenged/recall/Initialize(mapload)
	. = ..()
	QDEL_IN(src, rogue_value("faith_challenge_time"))
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/structure/fluff/ravox, spawnprotection)), rogue_value("faith_challenge_time") - rogue_value("faith_challenge_warning"))

/// Ratwood challenge "Challenge" (T2 of Ravox): the challenger and the one challenged are taken to the arena for a trial of a
/// few minutes and then sent back where they stood. Only one trial at a time; with no arena on the map there is none.
/datum/action/cooldown/spell/pointed/rogue_miracle/challenge
	name = "Challenge"
	desc = "Bring an opponent with me to a Ravoxian Trial in the arena, and fight there until the trial is over."
	button_icon = ROGUE_RAVOX_ICON
	button_icon_state = "ravoxchallenge"
	sound = 'sound/effects/magic/timeparadox2.ogg'
	invocation = "By Ravox, I challenge you!!"
	invocation_type = INVOCATION_SHOUT
	value_key = "challenge"
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_2
	needs_holy_symbol = TRUE
	miracle_forks = "Ratwood, Azure Peak"
	miracle_gods = "Ravox T2"

/datum/action/cooldown/spell/pointed/rogue_miracle/challenge/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !isliving(cast_on))
		to_chat(owner, span_warning("Only a living one can be challenged."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/challenge/cast(mob/living/cast_on)
	. = ..()
	var/mob/living/caster = owner
	var/area/rogue/indoors/ravoxarena/arena = GLOB.areas_by_type[/area/rogue/indoors/ravoxarena]
	if(!arena)
		return fail("There is no arena of Ravox in these lands.")
	if(length(GLOB.rogue_arena_folks) >= 2)
		return fail("The arena is not yet ready for the next trial! Wait your turn!")
	if(caster.z != cast_on.z)
		return fail()
	var/turf/challenger_spot
	var/turf/challenged_spot
	for(var/obj/structure/fluff/ravox/challenger/flag in arena)
		challenger_spot = get_turf(flag)
	for(var/obj/structure/fluff/ravox/challenged/flag in arena)
		challenged_spot = get_turf(flag)
	if(!challenger_spot || !challenged_spot)
		return fail("The arena of Ravox is not ready for a trial.")
	var/turf/challenger_home = get_turf(caster)
	var/turf/challenged_home = get_turf(cast_on)
	do_teleport(caster, challenger_spot, channel = TELEPORT_CHANNEL_MAGIC)
	do_teleport(cast_on, challenged_spot, channel = TELEPORT_CHANNEL_MAGIC)
	GLOB.rogue_arena_folks += caster
	GLOB.rogue_arena_folks += cast_on
	challenger_home.visible_message(span_cult("[caster] calls upon the Ravoxian rite of Trial! [cast_on] and [caster] are brought to Trial!"))
	new /obj/structure/fluff/ravox/challenger/recall(challenger_home)
	new /obj/structure/fluff/ravox/challenged/recall(challenged_home)
	to_chat(caster, span_userdanger("THE TRIAL IS CALLED, IMPRESS US, PROSECUTOR!!"))
	to_chat(cast_on, span_userdanger("A TRIAL OF RAVOX BEGINS. IMPRESS US, DEFENDANT!!"))
	var/trial = rogue_value("faith_challenge_time")
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(rogue_trial_return), caster, challenger_home), trial)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(rogue_trial_return), cast_on, challenged_home), trial)
	// Whatever is left lying in the arena goes to the place of the challenged.
	addtimer(CALLBACK(arena, TYPE_PROC_REF(/area/rogue/indoors/ravoxarena, cleanthearena), challenged_home), trial)

#undef ROGUE_RAVOX_ICON
#undef ROGUE_RAVOX_FLAGS_ICON
