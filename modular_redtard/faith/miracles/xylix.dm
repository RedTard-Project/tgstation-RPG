/// The miracles of Xylix of the basket (miracle.dm), from Ratwood's acolyte/xylix.dm: The Wheel, Ventriloquism, Master's
/// Illusion, Vicious Mockery, Xylixian Slip, Abscond, Mimicry and Xylixian Luck, with the statuses they leave. None of these
/// are in the other two forks. Every number is a value of faith.txt: the miracle's own by its value_key (miracle.dm), the
/// rest by the name written where it is read.

#define ROGUE_MIRACLES_XYLIX_ICON 'modular_redtard/faith/icons/xylixmiracles.dmi'

/// Ratwood wheel: the Wheel of Fortune turns once, and for a long time the target's luck is better or worse for it.
/datum/status_effect/rogue_wheel
	id = "rogue_wheel"
	status_type = STATUS_EFFECT_UNIQUE
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = /atom/movable/screen/alert/status_effect/rogue_wheel
	/// The change of Fortune the wheel dealt.
	var/luck_change = 0

/datum/status_effect/rogue_wheel/on_creation(mob/living/new_owner)
	duration = rogue_value("xylix_wheel_time")
	return ..()

/datum/status_effect/rogue_wheel/on_apply()
	var/spread = rogue_value("xylix_wheel_spread")
	luck_change = rand(-spread, spread)
	owner.attributes?.set_variable_attribute_modifier(id, list(ROGUE_STAT_FORTUNE = luck_change))
	if(luck_change < 0)
		to_chat(owner, span_boldnotice("My heart sinks, I feel as though I've lost something!"))
	else if(luck_change == 0)
		to_chat(owner, span_boldnotice("My heart beats, I feel as though nothing has changed at all..."))
	else
		to_chat(owner, span_boldnotice("My heart flutters, I feel as though I won the lottery!"))
	return TRUE

/datum/status_effect/rogue_wheel/on_remove()
	owner.attributes?.remove_attribute_modifier(id)
	return ..()

/atom/movable/screen/alert/status_effect/rogue_wheel
	name = "Lucky(?)"
	desc = "I feel different since my fortune was changed..."
	icon = ROGUE_COMBAT_ALERTS_ICON
	icon_state = "sleeping"

/// Ratwood wheel "The Wheel": the Wheel of Fortune is spun over a target, and its luck goes up or down for five minutes.
/datum/action/cooldown/spell/pointed/rogue_miracle/wheel
	name = "The Wheel"
	desc = "Spin the wheel, either buffing or debuffing the target's fortune."
	button_icon = ROGUE_MIRACLES_XYLIX_ICON
	button_icon_state = "xylixfort"
	sound = 'modular_redtard/faith/sound/letsgogambling.ogg'
	antimagic_flags = NONE
	value_key = "wheel"
	miracle_tier = ROGUE_MIRACLE_TIER_0
	miracle_forks = "Ratwood"
	miracle_gods = "none: in no patron's list"

/datum/action/cooldown/spell/pointed/rogue_miracle/wheel/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !isliving(cast_on))
		to_chat(owner, span_warning("Only the living have a fortune to spin."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/wheel/cast(mob/living/cast_on)
	. = ..()
	if(cast_on.can_block_magic(MAGIC_RESISTANCE_HOLY))
		return
	cast_on.apply_status_effect(/datum/status_effect/rogue_wheel)

/// Ratwood ventriloquism "Ventriloquism": the devotee throws their voice into an object, which says what they choose.
/datum/action/cooldown/spell/pointed/rogue_miracle/ventriloquism
	name = "Ventriloquism"
	desc = "Throw my voice into an object: it says what I choose."
	button_icon = ROGUE_MIRACLES_XYLIX_ICON
	button_icon_state = "ventril"
	sound = null
	value_key = "ventriloquism"
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_0
	miracle_forks = "Ratwood"
	miracle_gods = "Xylix T0"

/datum/action/cooldown/spell/pointed/rogue_miracle/ventriloquism/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !isobj(cast_on))
		to_chat(owner, span_warning("Only an object can be made to speak."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/ventriloquism/cast(obj/cast_on)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(throw_voice), owner, cast_on)

/datum/action/cooldown/spell/pointed/rogue_miracle/ventriloquism/proc/throw_voice(mob/living/caster, obj/target)
	var/message = tgui_input_text(caster, "What shall [target] say?", name, max_length = MAX_MESSAGE_LEN)
	if(!message || QDELETED(target))
		refund()
		return
	target.say(message)

/// Ratwood xylixdouble: the body double of Master's Illusion. It looks like the caster, is easy to cut down, and bursts into
/// smoke when its time is up or it is slain.
/mob/living/basic/rogue_xylix_double
	name = "Xylixian Double"
	gender = NEUTER
	mob_biotypes = MOB_HUMANOID
	basic_mob_flags = DEL_ON_DEATH
	ai_controller = null

/mob/living/basic/rogue_xylix_double/Initialize(mapload, mob/living/carbon/human/copycat, double_time)
	. = ..()
	maxHealth = rogue_value("xylix_illusion_double_health")
	health = maxHealth
	if(copycat)
		appearance = copycat.appearance
		alpha = 255
	addtimer(CALLBACK(src, PROC_REF(burst)), double_time, TIMER_DELETE_ME)

/mob/living/basic/rogue_xylix_double/proc/burst()
	if(stat != DEAD)
		death()

/mob/living/basic/rogue_xylix_double/death(gibbed)
	playsound(get_turf(src), 'modular_redtard/faith/sound/decoylaugh.ogg', 50)
	do_smoke(1, src, get_turf(src), effect_type = /obj/effect/particle_effect/fluid/smoke/quick)
	return ..()

/// Ratwood mastersillusion "Master's Illusion" (Set Decoy): a body double of the caster stands where they stood and they
/// fade from sight; when the double's time is up it bursts into smoke. Longer, the more skilled in miracles. Ratwood made the
/// likeness at the first cast, which cast nothing; here it is taken at each cast, which costs nothing.
/datum/action/cooldown/spell/pointed/rogue_miracle/masters_illusion
	name = "Master's Illusion"
	desc = "Create a body double of myself and fade from sight; after a delay the double bursts into smoke."
	button_icon = ROGUE_MIRACLES_XYLIX_ICON
	button_icon_state = "disguise"
	sound = null
	click_to_activate = FALSE
	antimagic_flags = NONE
	value_key = "masters_illusion"
	miracle_tier = ROGUE_MIRACLE_TIER_2
	miracle_forks = "Ratwood"
	miracle_gods = "Xylix T2"

/datum/action/cooldown/spell/pointed/rogue_miracle/masters_illusion/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/caster = owner
	var/rank = max(caster.rogue_skill_rank(/datum/attribute/skill/magic/holy), 1)
	var/hidden_time = min(rogue_value("xylix_illusion_cap"), rogue_value("xylix_illusion_base") + FLOOR(rank / 2, 1) * rogue_value("xylix_illusion_step"))
	var/double_time = max(rogue_value("xylix_illusion_double_min"), round(hidden_time * rogue_value("xylix_illusion_double_share")))
	new /mob/living/basic/rogue_xylix_double(get_turf(caster), caster, double_time)
	caster.apply_status_effect(/datum/status_effect/rogue_moon_shroud, hidden_time)

/// Ratwood viciousmockery: for a minute the one mocked is the dimmer, slower and weaker of will for the jibes.
/datum/status_effect/rogue_miracle_stats/viciousmockery
	id = "rogue_viciousmockery"
	alert_type = /atom/movable/screen/alert/status_effect/rogue_viciousmockery

/datum/status_effect/rogue_miracle_stats/viciousmockery/stat_changes()
	return list(ROGUE_STAT_STRENGTH = -rogue_value("xylix_mockery_strength"), ROGUE_STAT_SPEED = -rogue_value("xylix_mockery_speed"), ROGUE_STAT_WILLPOWER = -rogue_value("xylix_mockery_willpower"), ROGUE_STAT_INTELLIGENCE = -rogue_value("xylix_mockery_intelligence"))

/datum/status_effect/rogue_miracle_stats/viciousmockery/new_duration()
	return rogue_value("xylix_mockery_time")

/atom/movable/screen/alert/status_effect/rogue_viciousmockery
	name = "Vicious Mockery"
	desc = "<span class='warning'>THAT ARROGANT BARD! ARGH!</span>\n"
	icon = ROGUE_COMBAT_ALERTS_ICON
	icon_state = "mockery"

/// Ratwood mockery "Vicious Mockery": a jibe at the target, shouted aloud; if it hears, it is the weaker in INT, SPD, STR and WIL
/// for a minute.
/datum/action/cooldown/spell/pointed/rogue_miracle/mockery
	name = "Vicious Mockery"
	desc = "Mock my target, reducing their INT, SPD, STR and WIL for a time. They must hear me."
	button_icon = ROGUE_MIRACLES_XYLIX_ICON
	button_icon_state = "mockery"
	sound = 'modular_redtard/faith/sound/mockery.ogg'
	invocation_type = INVOCATION_SHOUT
	antimagic_flags = NONE
	value_key = "mockery"
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_1
	miracle_forks = "Ratwood"
	miracle_gods = "Xylix T1"
	/// The jibes of Ratwood, one shouted at random.
	var/static/list/jibes = list(
		"Your mother was a Rous, and your father smelled of jacksberries!",
		"What are you going to do for a face when the Archdevil wants his arse back?!",
		"Wandought thine blades stand, much like thine loving parts!",
		"That's a face not even Eora could love!",
		"Your breath smells like raw butter and cheap beer!",
		"I bite mine thumb, ser!",
		"But enough talk- have at thee!",
		"My grandmother fights better than you!",
		"Need you borrow mine spectacles? Come get them!",
		"How much sparring did it take to become this awful?!",
		"You may need a smith- for you seem ill-equipped for a battle of wits!",
		"Looks as if thou art PSY-DONE! No? Too soon? Alright.",
		"Ravox bring justice to your useless mentor, ser!",
	)

/datum/action/cooldown/spell/pointed/rogue_miracle/mockery/before_cast(atom/cast_on)
	invocation = pick(jibes)
	return ..()

/datum/action/cooldown/spell/pointed/rogue_miracle/mockery/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !isliving(cast_on))
		to_chat(owner, span_warning("Only the living can be mocked."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/mockery/cast(mob/living/cast_on)
	. = ..()
	if(cast_on.can_block_magic(MAGIC_RESISTANCE_HOLY))
		return
	if(HAS_TRAIT(cast_on, TRAIT_DEAF) || cast_on.stat != STABLE)
		return fail("They cannot hear my jibes.")
	cast_on.apply_status_effect(/datum/status_effect/rogue_miracle_stats/viciousmockery)

/// Ratwood xylixslip "Xylixian Slip": the devotee slips away a few tiles in the direction they face, and is off balance for a
/// while after; if they are off balance already, they only lose their footing and stumble to the side.
/datum/action/cooldown/spell/pointed/rogue_miracle/xylixian_slip
	name = "Xylixian Slip"
	desc = "Leap a few tiles in the direction I face. If I am still off balance, I only stumble."
	button_icon = ROGUE_MIRACLES_XYLIX_ICON
	button_icon_state = "slip"
	sound = null
	click_to_activate = FALSE
	value_key = "slip"
	miracle_tier = ROGUE_MIRACLE_TIER_0
	miracle_forks = "Ratwood"
	miracle_gods = "Xylix T0"
	var/static/list/slip_sounds = list(
		'modular_redtard/faith/sound/xylix_slip1.ogg',
		'modular_redtard/faith/sound/xylix_slip2.ogg',
		'modular_redtard/faith/sound/xylix_slip2.ogg',
		'modular_redtard/faith/sound/xylix_slip3.ogg',
		'modular_redtard/faith/sound/xylix_slip4.ogg',
		'modular_redtard/faith/sound/xylix_slip4.ogg',
	)

/datum/action/cooldown/spell/pointed/rogue_miracle/xylixian_slip/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/slipper = owner
	if(HAS_TRAIT(slipper, TRAIT_IMMOBILIZED) || slipper.body_position != STANDING_UP)
		return fail("I cannot slip away like this.")
	var/turf/here = get_turf(slipper)
	if(slipper.rogue_offbalanced(FALSE))
		slipper.visible_message(span_warning("[slipper] loses [slipper.p_their()] footing!"))
		var/stumble = rand(rogue_value("xylix_slip_stumble_min"), rogue_value("xylix_slip_stumble_max"))
		slipper.throw_at(get_ranged_target_turf(here, turn(slipper.dir, prob(50) ? 270 : 90), stumble), stumble, 1, slipper, TRUE)
		playsound(slipper, 'modular_redtard/faith/sound/xylix_slip_fail.ogg', 100)
		slipper.Knockdown(rogue_value("xylix_slip_knockdown"))
		return
	var/leap = rogue_value("xylix_slip_distance")
	slipper.visible_message(span_warning("[slipper] slips away!"))
	slipper.throw_at(get_ranged_target_turf(here, slipper.dir, leap), leap, 1, slipper, TRUE)
	slipper.rogue_off_balance(rogue_value("xylix_slip_offbalance"))
	playsound(slipper, pick(slip_sounds), 100, TRUE)

/// Ratwood abscond "Abscond": the devotee disappears in a flash of smoke and is at the spot they pointed at, a few tiles away.
/// The way must be open: no wall, nothing solid that cannot be climbed over (a barred window, a grate) in between, and the
/// spot not too near. They must stand still for a few seconds while the miracle gathers.
/datum/action/cooldown/spell/pointed/rogue_miracle/abscond
	name = "Abscond"
	desc = "Disappear in a flash of smoke to a spot a few tiles away. The way must be open, and I must stand still for a few moments."
	button_icon = ROGUE_MIRACLES_XYLIX_ICON
	button_icon_state = "abscond"
	sound = null
	value_key = "abscond"
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_4
	miracle_forks = "Ratwood"
	miracle_gods = "Xylix T4"

/datum/action/cooldown/spell/pointed/rogue_miracle/abscond/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	var/turf/spot = get_turf(cast_on)
	var/turf/here = get_turf(owner)
	if(!spot || spot.density || istransparentturf(spot))
		to_chat(owner, span_info("I cannot slip there!"))
		return FALSE
	if(spot.z == here.z && get_dist(here, spot) < rogue_value("xylix_abscond_nearest"))
		to_chat(owner, span_info("Too close!"))
		return FALSE
	if(!way_is_open(here, spot))
		to_chat(owner, span_info("The path is blocked!"))
		return FALSE

/// Nothing solid between the two spots: a wall or a solid thing that cannot be climbed over stops the way.
/datum/action/cooldown/spell/pointed/rogue_miracle/abscond/proc/way_is_open(turf/start, turf/goal)
	if(start.z != goal.z)
		return TRUE
	for(var/turf/passed as anything in get_line(start, goal))
		if(passed == start)
			continue
		if(passed.density)
			return FALSE
		for(var/obj/thing in passed)
			if(thing.density && !HAS_TRAIT(thing, TRAIT_CLIMBABLE))
				return FALSE
	return TRUE

/datum/action/cooldown/spell/pointed/rogue_miracle/abscond/cast(atom/cast_on)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(slip_away), owner, get_turf(cast_on))

/datum/action/cooldown/spell/pointed/rogue_miracle/abscond/proc/slip_away(mob/living/carbon/human/caster, turf/spot)
	var/turf/origin = get_turf(caster)
	to_chat(caster, span_info("I begin to slip away!"))
	playsound(spot, 'modular_redtard/faith/sound/shadowstep_destination.ogg', caster.move_intent == MOVE_INTENT_WALK ? 20 : 100, FALSE, 5)
	if(!do_after(caster, rogue_value("xylix_abscond_delay"), target = caster))
		to_chat(caster, span_warning("I lost my concentration, and the miracle fades."))
		refund()
		return
	if(QDELETED(spot) || QDELETED(caster))
		return
	do_smoke(1, caster, origin, effect_type = /obj/effect/particle_effect/fluid/smoke/quick)
	if(caster.buckled)
		caster.buckled.unbuckle_mob(caster, TRUE)
	if(do_teleport(caster, spot, no_effects = TRUE, channel = TELEPORT_CHANNEL_MAGIC))
		log_game("[key_name(caster)] absconded from [AREACOORD(origin)] to [AREACOORD(spot)].")
		playsound(origin, pick(list('modular_redtard/faith/sound/xylix_slip1.ogg', 'modular_redtard/faith/sound/xylix_slip3.ogg')), 60, TRUE)
		playsound(spot, pick(list('modular_redtard/faith/sound/xylix_slip2.ogg', 'modular_redtard/faith/sound/xylix_slip4.ogg')), 60, TRUE)
	else
		refund()

/// Ratwood parlor_trick: a conjured trinket of a touch. Used on an object it takes the object's look; used in the hand it makes
/// the devotee that object until they are touched or move it out of reach (TG's chameleon projector does all of it). It does not
/// stay: put down, it is gone.
/obj/item/chameleon/rogue_parlor_trick
	name = "parlor trick"
	desc = "A trick of Xylix's: touch an object to take its look, then use it in hand to become that object."
	slot_flags = NONE
	item_flags = NOBLUDGEON | DROPDEL

/obj/item/chameleon/rogue_parlor_trick/make_copy(atom/target, mob/user)
	playsound(get_turf(src), 'modular_redtard/faith/sound/decoylaugh.ogg', 20, TRUE, -6)
	return ..()

/// Ratwood mimicry "Mimicry": at a spot, a sound of the devotee's choosing; at an object, a parlor trick that copies it; at
/// themselves, an empty parlor trick in the hand to copy something with.
/datum/action/cooldown/spell/pointed/rogue_miracle/mimicry
	name = "Mimicry"
	desc = "Play a sound of my choice at the target spot, or take on the form of an object as a parlor trick: point at an object to copy it, at myself to conjure an empty trick."
	button_icon = ROGUE_MIRACLES_XYLIX_ICON
	button_icon_state = "mimicry"
	sound = null
	value_key = "mimicry"
	miracle_tier = ROGUE_MIRACLE_TIER_2
	miracle_forks = "Ratwood"
	miracle_gods = "Xylix T2"
	/// The sounds to choose from (Ratwood soundpick, without the ones this port has not got).
	var/static/list/sound_choices = list(
		"Armor Break" = 'modular_redtard/rockhill/sound/combat/sharpness_loss1.ogg',
		"Attack Swing" = 'modular_redtard/rockhill/sound/combat/wooshes/bladed/wooshlarge (1).ogg',
		"Bell" = 'modular_redtard/rockhill/sound/misc/bell.ogg',
		"Bell Jingle" = 'modular_redtard/faith/sound/mimicry/bell_jingle.ogg',
		"Broken Door" = 'modular_redtard/faith/sound/mimicry/broken_door.ogg',
		"Clap" = 'modular_redtard/faith/sound/mimicry/clap.ogg',
		"Clear Throat" = 'modular_redtard/rockhill/sound/vo/female/gen/clearthroat.ogg',
		"Defending" = 'modular_redtard/rockhill/sound/combat/clash_initiate.ogg',
		"Door Unlock" = 'modular_redtard/faith/sound/mimicry/door_unlock.ogg',
		"Explosion" = 'sound/effects/magic/fireball.ogg',
		"Glass Shatter" = 'modular_redtard/faith/sound/mimicry/glass_shatter.ogg',
		"Goblin Jabber" = 'modular_redtard/rockhill/sound/vo/male/goblin/giggle (2).ogg',
		"Guard Houndstone" = 'modular_redtard/faith/sound/mimicry/houndstone.ogg',
		"Howl" = 'modular_redtard/faith/sound/mimicry/howl.ogg',
		"Jumping" = 'modular_redtard/rockhill/sound/vo/male/gen/jump.ogg',
		"Large Creecher Jump" = 'modular_redtard/faith/sound/mimicry/creecher_jump.ogg',
		"Lockpick Click" = 'modular_redtard/rockhill/sound/doors/pickbad.ogg',
		"Psst" = 'modular_redtard/faith/sound/mimicry/psst.ogg',
		"Rat Chitter/SCOM" = 'modular_redtard/faith/sound/mimicry/rat_chitter.ogg',
		"Scream - Agony" = 'modular_redtard/faith/sound/mimicry/scream_agony.ogg',
		"Scream - Rage" = 'modular_redtard/rockhill/sound/vo/female/gen/rage (1).ogg',
		"Skeleton Laugh" = 'modular_redtard/faith/sound/mimicry/skeleton_laugh.ogg',
		"Snap Finger" = 'modular_redtard/faith/sound/mimicry/snap_finger.ogg',
		"Spider Chitter" = 'modular_redtard/faith/sound/mimicry/spider_chitter.ogg',
		"Vicious Mockery" = 'modular_redtard/faith/sound/mockery.ogg',
		"Volf Snarl" = 'modular_redtard/faith/sound/mimicry/volf_snarl.ogg',
	)

/// The parlor trick in the caster's hand, or a new one conjured there.
/datum/action/cooldown/spell/pointed/rogue_miracle/mimicry/proc/parlor_trick_for(mob/living/caster)
	var/obj/item/chameleon/rogue_parlor_trick/active = caster.get_active_held_item()
	if(istype(active))
		return active
	for(var/obj/item/chameleon/rogue_parlor_trick/trick in caster.held_items)
		return trick
	var/obj/item/chameleon/rogue_parlor_trick/fresh = new(caster)
	if(!caster.put_in_hands(fresh))
		qdel(fresh)
		return null
	to_chat(caster, span_notice("I channel a parlor trick into my hand."))
	return fresh

/datum/action/cooldown/spell/pointed/rogue_miracle/mimicry/cast(atom/cast_on)
	. = ..()
	var/mob/living/caster = owner
	if(cast_on == caster || isobj(cast_on))
		var/obj/item/chameleon/rogue_parlor_trick/trick = parlor_trick_for(caster)
		if(!trick)
			return fail("My hands are full!")
		if(cast_on == caster)
			to_chat(caster, span_notice("I channel a parlor trick into my hand. Touch an object with it to copy it, then use it in my hand to transform."))
			return
		trick.make_copy(cast_on, caster)
		to_chat(caster, span_notice("I copy [cast_on]. Using the trick in my hand will transform me."))
		return
	INVOKE_ASYNC(src, PROC_REF(play_sound_at), caster, get_turf(cast_on))

/datum/action/cooldown/spell/pointed/rogue_miracle/mimicry/proc/play_sound_at(mob/living/caster, turf/spot)
	var/choice = tgui_input_list(caster, "Choose a sound, my wise bureaucrat.", "Mimic Sound", sort_list(assoc_to_keys(sound_choices)))
	if(!choice || !spot)
		refund()
		return
	playsound(spot, sound_choices[choice], 100)

/// Ratwood xylix_blessed_luck and the favors of the gods: what Xylixian Luck deals out. Each is a status of its own, with its own
/// time and its own stats rolled when it comes (stat_rolls: the stat and the name of the value, whose _min and _max bound the
/// roll; roll_sign -1 for a punishment). The favors of a moment (the wounds of Graggar, the toll of Matthios) are done in
/// on_apply().
/datum/status_effect/rogue_xylix_favor
	id = "rogue_xylix_favor"
	status_type = STATUS_EFFECT_UNIQUE
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = /atom/movable/screen/alert/status_effect/rogue_xylix_favor
	/// The name the values of this favor go by: xylix_favor_<god>_time and so on.
	var/god
	var/list/stat_rolls
	var/roll_sign = 1

/datum/status_effect/rogue_xylix_favor/on_creation(mob/living/new_owner)
	duration = rogue_value("xylix_favor_[god]_time")
	return ..()

/datum/status_effect/rogue_xylix_favor/on_apply()
	if(length(stat_rolls))
		var/list/changes = list()
		for(var/stat in stat_rolls)
			var/value_name = stat_rolls[stat]
			changes[stat] = roll_sign * rand(rogue_value("[value_name]_min"), rogue_value("[value_name]_max"))
		owner.attributes?.set_variable_attribute_modifier(id, changes)
	return TRUE

/datum/status_effect/rogue_xylix_favor/on_remove()
	owner.attributes?.remove_attribute_modifier(id)
	return ..()

/atom/movable/screen/alert/status_effect/rogue_xylix_favor
	name = "A Favor of the Gods"
	desc = "Xylix's gamble paid out."
	icon = ROGUE_COMBAT_ALERTS_ICON
	icon_state = "status"

/datum/status_effect/rogue_xylix_favor/xylix
	id = "rogue_xylix_blessed_luck"
	god = "xylix"
	stat_rolls = list(ROGUE_STAT_FORTUNE = "xylix_favor_xylix_fortune")
	alert_type = /atom/movable/screen/alert/status_effect/rogue_xylix_favor/xylix

/datum/status_effect/rogue_xylix_favor/xylix/on_apply()
	. = ..()
	new /obj/item/roguecoin/gold(get_turf(owner), 1)

/atom/movable/screen/alert/status_effect/rogue_xylix_favor/xylix
	name = "Xylixian Blessed Luck"
	desc = "Even though you haven't won one of his favors, he still favors you."

/datum/status_effect/rogue_xylix_favor/astrata
	id = "rogue_astrata_favor"
	god = "astrata"
	stat_rolls = list(ROGUE_STAT_CONSTITUTION = "xylix_favor_astrata_constitution", ROGUE_STAT_WILLPOWER = "xylix_favor_astrata_willpower")
	alert_type = /atom/movable/screen/alert/status_effect/rogue_xylix_favor/astrata

/datum/status_effect/rogue_xylix_favor/astrata/on_apply()
	. = ..()
	owner.add_traits(list(TRAIT_CRITICAL_RESISTANCE, TRAIT_NOPAINSTUN, TRAIT_STEELHEARTED, TRAIT_IGNOREDAMAGESLOWDOWN), id)

/datum/status_effect/rogue_xylix_favor/astrata/on_remove()
	owner.remove_traits(list(TRAIT_CRITICAL_RESISTANCE, TRAIT_NOPAINSTUN, TRAIT_STEELHEARTED, TRAIT_IGNOREDAMAGESLOWDOWN), id)
	return ..()

/atom/movable/screen/alert/status_effect/rogue_xylix_favor/astrata
	name = "Astrata's Favor"
	desc = "Although it was difficult to obtain, Xylix used it. You are practically immortal."

/datum/status_effect/rogue_xylix_favor/noc
	id = "rogue_noc_favor"
	god = "noc"
	stat_rolls = list(ROGUE_STAT_INTELLIGENCE = "xylix_favor_noc_intelligence", ROGUE_STAT_SPEED = "xylix_favor_noc_speed")
	alert_type = /atom/movable/screen/alert/status_effect/rogue_xylix_favor/noc

/datum/status_effect/rogue_xylix_favor/noc/on_apply()
	. = ..()
	owner.alpha = 127

/datum/status_effect/rogue_xylix_favor/noc/on_remove()
	owner.alpha = 255
	return ..()

/atom/movable/screen/alert/status_effect/rogue_xylix_favor/noc
	name = "Noc's Favor"
	desc = "Knowledge, light and shadow of Noc covers you."

/datum/status_effect/rogue_xylix_favor/zizo
	id = "rogue_zizo_unfavor"
	god = "zizo"
	roll_sign = -1
	stat_rolls = list(
		ROGUE_STAT_STRENGTH = "xylix_favor_zizo_stat",
		ROGUE_STAT_PERCEPTION = "xylix_favor_zizo_stat",
		ROGUE_STAT_INTELLIGENCE = "xylix_favor_zizo_stat",
		ROGUE_STAT_CONSTITUTION = "xylix_favor_zizo_stat",
		ROGUE_STAT_WILLPOWER = "xylix_favor_zizo_stat",
		ROGUE_STAT_SPEED = "xylix_favor_zizo_stat",
	)
	alert_type = /atom/movable/screen/alert/status_effect/rogue_xylix_favor/zizo

/atom/movable/screen/alert/status_effect/rogue_xylix_favor/zizo
	name = "Zizo's Intervention"
	desc = "Your patron was not attentive enough and caught Zizo's attention. You feel weaker."

/datum/status_effect/rogue_xylix_favor/ravox
	id = "rogue_ravox_favor"
	god = "ravox"
	stat_rolls = list(ROGUE_STAT_STRENGTH = "xylix_favor_ravox_strength", ROGUE_STAT_SPEED = "xylix_favor_ravox_speed", ROGUE_STAT_WILLPOWER = "xylix_favor_ravox_willpower")
	alert_type = /atom/movable/screen/alert/status_effect/rogue_xylix_favor/ravox

/atom/movable/screen/alert/status_effect/rogue_xylix_favor/ravox
	name = "Favor of Ravox"
	desc = "The power of Ravox supports you."

/datum/status_effect/rogue_xylix_favor/malum
	id = "rogue_malum_favor"
	god = "malum"
	stat_rolls = list(ROGUE_STAT_CONSTITUTION = "xylix_favor_malum_constitution", ROGUE_STAT_WILLPOWER = "xylix_favor_malum_willpower")
	alert_type = /atom/movable/screen/alert/status_effect/rogue_xylix_favor/malum

/atom/movable/screen/alert/status_effect/rogue_xylix_favor/malum
	name = "Favor of Malum"
	desc = "Malum lends you his enduring strength and will."

/datum/status_effect/rogue_xylix_favor/baotha
	id = "rogue_baotha_favor"
	god = "baotha"
	stat_rolls = list(ROGUE_STAT_SPEED = "xylix_favor_baotha_speed")
	alert_type = /atom/movable/screen/alert/status_effect/rogue_xylix_favor/baotha

/datum/status_effect/rogue_xylix_favor/baotha/on_apply()
	. = ..()
	owner.adjust_drunk_effect(rogue_value("xylix_favor_baotha_drunk"))

/atom/movable/screen/alert/status_effect/rogue_xylix_favor/baotha
	name = "Baotha's Favor"
	desc = "You feel euphoric, quick, very flushed and intoxicated."

/datum/status_effect/rogue_xylix_favor/graggar
	id = "rogue_graggar_favor"
	god = "graggar"
	alert_type = /atom/movable/screen/alert/status_effect/rogue_xylix_favor/graggar

/datum/status_effect/rogue_xylix_favor/graggar/on_apply()
	. = ..()
	if(!iscarbon(owner))
		return
	var/mob/living/carbon/victim = owner
	var/obj/item/bodypart/limb = victim.get_bodypart(pick(BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
	if(limb)
		victim.cause_wound_of_type_and_severity(pick(WOUND_BLUNT, WOUND_SLASH, WOUND_PIERCE), limb, WOUND_SEVERITY_MODERATE, WOUND_SEVERITY_MODERATE, wound_source = "Graggar's favor")
		if(prob(rogue_value("xylix_favor_graggar_fracture")))
			victim.cause_wound_of_type_and_severity(WOUND_BLUNT, limb, WOUND_SEVERITY_SEVERE, WOUND_SEVERITY_SEVERE, wound_source = "Graggar's favor")
	owner.visible_message(span_warning("[owner] suddenly winces as flesh tears and bruises under Graggar's wrath!"), span_userdanger("Pain blossoms across my body as Graggar's rage wounds me!"))

/atom/movable/screen/alert/status_effect/rogue_xylix_favor/graggar
	name = "Graggar's Favor"
	desc = "Violence turns inward. Blood and pain has been inflicted upon you!"

/datum/status_effect/rogue_xylix_favor/matthios
	id = "rogue_matthios_favor"
	god = "matthios"
	alert_type = /atom/movable/screen/alert/status_effect/rogue_xylix_favor/matthios

/datum/status_effect/rogue_xylix_favor/matthios/on_apply()
	. = ..()
	var/datum/bank_account/rogue/account = owner.mind?.rogue_account
	if(account?.account_balance > 0)
		var/stolen = min(rand(rogue_value("xylix_favor_matthios_min"), rogue_value("xylix_favor_matthios_max")), account.account_balance)
		account.adjust_money(-stolen, "Matthios' toll")
		to_chat(owner, span_warning("Matthios skims [stolen] mammon from your nervelock!"))
	else
		to_chat(owner, span_notice("Matthios reaches for your nervelock, but finds it empty. Truly, a poor fool!"))

/atom/movable/screen/alert/status_effect/rogue_xylix_favor/matthios
	name = "Matthios' Favor"
	desc = "The Free-God palms coin from your nervelock with a crooked grin."

/datum/status_effect/rogue_xylix_favor/eora
	id = "rogue_eora_favor"
	god = "eora"
	tick_interval = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/rogue_xylix_favor/eora

/datum/status_effect/rogue_xylix_favor/eora/on_apply()
	. = ..()
	if(!HAS_TRAIT(owner, TRAIT_UNSEEMLY))
		ADD_TRAIT(owner, TRAIT_BEAUTIFUL, id)

/datum/status_effect/rogue_xylix_favor/eora/tick(seconds_between_ticks)
	var/heal = rogue_value("xylix_favor_eora_heal")
	owner.adjust_brute_loss(-heal)
	owner.adjust_fire_loss(-heal)

/datum/status_effect/rogue_xylix_favor/eora/on_remove()
	REMOVE_TRAIT(owner, TRAIT_BEAUTIFUL, id)
	return ..()

/atom/movable/screen/alert/status_effect/rogue_xylix_favor/eora
	name = "A Favor from Eora"
	desc = "Eora surrounds you with her love, soothing your wounds and making you glow with divine beauty."

/datum/status_effect/rogue_xylix_favor/necra
	id = "rogue_necra_favor"
	god = "necra"
	alert_type = /atom/movable/screen/alert/status_effect/rogue_xylix_favor/necra

/datum/status_effect/rogue_xylix_favor/necra/on_apply()
	. = ..()
	owner.AddElement(/datum/element/cleaning)

/datum/status_effect/rogue_xylix_favor/necra/on_remove()
	owner.RemoveElement(/datum/element/cleaning)
	return ..()

/atom/movable/screen/alert/status_effect/rogue_xylix_favor/necra
	name = "Necra's Favor"
	desc = "Necra's censer-smoke clings to your steps, cleansing the ground around you."

/datum/status_effect/rogue_xylix_favor/pestra
	id = "rogue_pestra_favor"
	god = "pestra"
	alert_type = /atom/movable/screen/alert/status_effect/rogue_xylix_favor/pestra

/datum/status_effect/rogue_xylix_favor/pestra/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/sick = owner
		sick.vomit()
	new /obj/item/natural/worms/leech(get_turf(owner))
	owner.adjust_tox_loss(-rogue_value("xylix_favor_pestra_toxin"))
	owner.heal_overall_damage(rogue_value("xylix_favor_pestra_heal"), rogue_value("xylix_favor_pestra_heal"))
	to_chat(owner, span_notice("A wet retch spills forth a leech as Pestra's swarm mends me from within."))

/atom/movable/screen/alert/status_effect/rogue_xylix_favor/pestra
	name = "Pestra's Favor"
	desc = "A leeching purge and crawling mercy ease poison and knit your wounds."

/datum/status_effect/rogue_xylix_favor/dendor
	id = "rogue_dendor_favor"
	god = "dendor"
	alert_type = /atom/movable/screen/alert/status_effect/rogue_xylix_favor/dendor

/datum/status_effect/rogue_xylix_favor/dendor/on_apply()
	. = ..()
	owner.electrocute_act(rogue_value("xylix_favor_dendor_shock"), owner)
	ADD_TRAIT(owner, TRAIT_LONGSTRIDER, id)
	to_chat(owner, span_warning("You're suddenly jolted with a kneestinger's touch as Dendor's power lets you stride freely on uneven terrain for a short time!"))

/datum/status_effect/rogue_xylix_favor/dendor/on_remove()
	REMOVE_TRAIT(owner, TRAIT_LONGSTRIDER, id)
	return ..()

/atom/movable/screen/alert/status_effect/rogue_xylix_favor/dendor
	name = "Dendor's Favor"
	desc = "Dendor's blessing jolts you with a kneestinger's touch and temporarily frees your stride from the grip of the earth."

/datum/status_effect/rogue_xylix_favor/abyssor
	id = "rogue_abyssor_favor"
	god = "abyssor"
	alert_type = /atom/movable/screen/alert/status_effect/rogue_xylix_favor/abyssor

/datum/status_effect/rogue_xylix_favor/abyssor/on_apply()
	. = ..()
	playsound(owner, 'modular_redtard/faith/sound/undertow.ogg', 75, FALSE)
	var/stamina = rogue_value("xylix_favor_abyssor_stamina")
	if(prob(rogue_value("xylix_favor_abyssor_drown_chance")))
		owner.adjust_stamina_loss(stamina)
		owner.adjust_oxy_loss(rogue_value("xylix_favor_abyssor_oxygen"))
		if(iscarbon(owner))
			var/mob/living/carbon/drowning = owner
			drowning.losebreath += rogue_value("xylix_favor_abyssor_breath")
		owner.adjust_dizzy(rogue_value("xylix_favor_abyssor_dizzy"))
		owner.set_eye_blur_if_lower(rogue_value("xylix_favor_abyssor_blur"))
		to_chat(owner, span_warning("Abyssor's depths seize your lungs and drag your breath away, draining your energy!"))
	else
		owner.adjust_stamina_loss(-stamina)
		to_chat(owner, span_notice("A cool tide washes over your mind, restoring your energy."))

/atom/movable/screen/alert/status_effect/rogue_xylix_favor/abyssor
	name = "Abyssor's Favor"
	desc = "You awoke something you shouldn't have. It pulls your breath away, or may give you a second wind."

/// Ratwood xylixlian_luck "Xylix's Fortune": the devotee gambles with their patron. A god is drawn by weight; the weights
/// start from a base for each god, and move with the luck of the devotee's use: each cast already made (since the miracle was
/// had) and each minute of waiting since the last one. A god's weight falls by its share of that bonus (Astrata's rises).
/datum/action/cooldown/spell/pointed/rogue_miracle/xylix_luck
	name = "Xylix's Fortune"
	desc = "Challenge my luck and my patron: one of the gods answers, with a favor or a toll. The more I gamble, the worse it goes; the longer I wait, the better."
	button_icon = ROGUE_MIRACLES_XYLIX_ICON
	button_icon_state = "xylixfort"
	sound = 'modular_redtard/faith/sound/letsgogambling.ogg'
	click_to_activate = FALSE
	antimagic_flags = NONE
	value_key = "xylix_luck"
	miracle_tier = ROGUE_MIRACLE_TIER_1
	miracle_forks = "Ratwood"
	miracle_gods = "Xylix T1"
	/// Casts made, and when the last one was (or the miracle was had).
	var/used_times = 0
	var/last_used = 0
	/// The gods that can answer, with the favor each gives; null is "nothing".
	var/static/list/favors = list(
		"xylix" = /datum/status_effect/rogue_xylix_favor/xylix,
		"ravox" = /datum/status_effect/rogue_xylix_favor/ravox,
		"eora" = /datum/status_effect/rogue_xylix_favor/eora,
		"nothing" = null,
		"malum" = /datum/status_effect/rogue_xylix_favor/malum,
		"noc" = /datum/status_effect/rogue_xylix_favor/noc,
		"abyssor" = /datum/status_effect/rogue_xylix_favor/abyssor,
		"necra" = /datum/status_effect/rogue_xylix_favor/necra,
		"pestra" = /datum/status_effect/rogue_xylix_favor/pestra,
		"astrata" = /datum/status_effect/rogue_xylix_favor/astrata,
		"zizo" = /datum/status_effect/rogue_xylix_favor/zizo,
		"dendor" = /datum/status_effect/rogue_xylix_favor/dendor,
		"baotha" = /datum/status_effect/rogue_xylix_favor/baotha,
		"graggar" = /datum/status_effect/rogue_xylix_favor/graggar,
		"matthios" = /datum/status_effect/rogue_xylix_favor/matthios,
	)
	/// What the devotee is told of the god who answered.
	var/static/list/verdicts = list(
		"xylix" = "Xylix's fortune favors you!",
		"ravox" = "Ravox blesses you with power!",
		"eora" = "Eora's love envelops you!",
		"nothing" = "You won... Nothing!",
		"malum" = "Malum reforges your body and gives you energy!",
		"noc" = "The shadow of Noc's silver light covers you!",
		"abyssor" = "Abyssor's tide turns against or for you in an instant!",
		"necra" = "Necra's censer-smoke follows your steps and purifies the way.",
		"pestra" = "Pestra's swarm stirs in your gut, purging poison and stitching flesh.",
		"astrata" = "The Light of Astrata gives you strength!",
		"zizo" = "Zizo's face is mocking you!",
		"dendor" = "Dendor's wild energy courses through you - if you can handle the kneestinger's kiss!",
		"baotha" = "Baotha's haze grips your body and mind!",
		"graggar" = "Graggar's fury marks your flesh!",
		"matthios" = "Matthios steals from your nervelock as a lesson in greed!",
	)

/datum/action/cooldown/spell/pointed/rogue_miracle/xylix_luck/Grant(mob/grant_to)
	. = ..()
	if(!last_used)
		last_used = world.time

/datum/action/cooldown/spell/pointed/rogue_miracle/xylix_luck/cast(atom/cast_on)
	. = ..()
	var/mob/living/caster = owner
	to_chat(caster, span_danger("Xylix gives you a chance to use one of his favors."))
	var/luck_bonus = -used_times * rogue_value("xylix_luck_use_penalty") + rogue_value("xylix_luck_idle_gain") * ((world.time - last_used) / rogue_value("xylix_luck_idle_step"))
	var/list/weights = list()
	for(var/god in favors)
		weights[god] = max(0, round(rogue_value("xylix_luck_weight_[god]") - rogue_value("xylix_luck_share_[god]") * luck_bonus))
	var/answer = pick_weight(weights)
	used_times++
	last_used = world.time
	var/favor_type = favors[answer]
	if(favor_type)
		caster.apply_status_effect(favor_type)
	to_chat(caster, span_danger(verdicts[answer]))

#undef ROGUE_MIRACLES_XYLIX_ICON
