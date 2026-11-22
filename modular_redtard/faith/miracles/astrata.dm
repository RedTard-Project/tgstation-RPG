/// The miracles of Astrata that the basket (miracle.dm) did not have yet: Astratan Gaze, Immolation and Summon Spear (Ratwood
/// code/modules/spells/roguetown/acolyte/astrata.dm; Azure Peak and Twilight Axis have the Gaze and the Immolation too, Azure
/// Peak's Gaze is T1 and lasts twice as long). Ignition, Anastasis and Fortify are in daily.dm, light.dm, revival.dm, healing.dm.

#define ROGUE_ASTRATA_ICON 'modular_redtard/faith/miracles/icons/astratamiracles_ratwood.dmi'
#define ROGUE_IMMOLATION_FILTER "rogue_immolation"

/// Ratwood buff/astrata_gaze: the cone of the view is gone for a while, and the eyes of the devout are sharper; it lasts
/// longer the more skilled the caster is in miracles and twice as long in the light of day. Only the cone of the caster's
/// own helmet and sun glare is lifted (combat/fov.dm); a blind or nearsighted one stays so.
/datum/status_effect/rogue_astrata_gaze
	id = "rogue_astrata_gaze"
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null
	tick_interval = 1 SECONDS
	/// Ranks of the caster in miracles, at least one (Ratwood multiplies by the rank itself, which gives an untrained caster
	/// no gaze at all).
	var/gaze_rank = 1
	/// Perception it adds.
	var/perception_bonus = 0

/datum/status_effect/rogue_astrata_gaze/on_creation(mob/living/new_owner, rank)
	gaze_rank = max(rank, 1)
	duration = rogue_value("faith_gaze_time") * gaze_rank
	if(rank > 1)
		perception_bonus++
	if(GLOB.rockhill_time_of_day == ROCKHILL_DAY || GLOB.rockhill_time_of_day == ROCKHILL_DAWN)
		perception_bonus++
		duration *= rogue_value("faith_gaze_day_factor")
	return ..()

/datum/status_effect/rogue_astrata_gaze/on_apply()
	if(perception_bonus)
		owner.attributes?.set_variable_attribute_modifier(id, list(ROGUE_STAT_PERCEPTION = perception_bonus))
	owner.remove_fov_trait(ROGUE_FOV_SOURCE)
	to_chat(owner, span_info("She shines through me! I can perceive all clear as dae!"))
	return TRUE

/datum/status_effect/rogue_astrata_gaze/tick(seconds_between_ticks)
	// Putting on a helm or taking off an eyepatch draws the cone again (combat/fov.dm): lift it once more.
	if(LAZYACCESS(owner.fov_traits, ROGUE_FOV_SOURCE))
		owner.remove_fov_trait(ROGUE_FOV_SOURCE)

/datum/status_effect/rogue_astrata_gaze/on_remove()
	owner.attributes?.remove_attribute_modifier(id)
	if(ishuman(owner))
		var/mob/living/carbon/human/seer = owner
		seer.rogue_update_fov()

/datum/action/cooldown/spell/pointed/rogue_miracle/astratan_gaze
	name = "Astratan Gaze"
	desc = "Remove the limit on my vision, letting me see behind me for a time. It lasts longer in the light of day and with the skill in miracles, and gives a bonus to perception to the skilled."
	button_icon = ROGUE_MIRACLES_ASTRATA_ICON
	button_icon_state = "gaze"
	sound = 'modular_redtard/faith/sound/bless.ogg'
	invocation = "Astrata show me true."
	invocation_type = INVOCATION_SHOUT
	click_to_activate = FALSE
	cooldown_time = 120 SECONDS
	miracle_tier = ROGUE_MIRACLE_TIER_0
	devotion_cost = 30
	miracle_forks = "Ratwood, Azure Peak, Twilight Axis"
	miracle_gods = "Astrata T0 (Azure Peak T1)"

/datum/action/cooldown/spell/pointed/rogue_miracle/astratan_gaze/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/seer = owner
	seer.apply_status_effect(/datum/status_effect/rogue_astrata_gaze, seer.rogue_skill_rank(/datum/attribute/skill/magic/holy))

/// Ratwood immolation (component and status effect, acolyte/astrata.dm; the same in Azure Peak and Twilight Axis): the holy fire
/// lit on a creature, the partner, cuts everything that stands close to it like a blade - a limb of each at a time, and
/// off it goes when the limb has had enough - and burns the partner too. The caster must stay within seven tiles and on their
/// feet, or it dies down; healing does not take on the partner. A devout Astratan burns better, so does a skilled caster.
/// The caster channels the flame onto another through the same effect, without burning themselves.
/datum/status_effect/rogue_immolation
	id = "rogue_immolation"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	tick_interval = 1 SECONDS
	/// The one who lit the fire, and the one it burns on.
	var/datum/weakref/caster
	var/datum/weakref/partner
	/// This is the effect of the partner: it is the one that cuts.
	var/is_partner = FALSE
	var/outline_color = "#ff4500"
	var/obj/effect/dummy/lighting_obj/moblight/flame
	/// Damage the cutting adds up to every second, and what the partner takes of it (Ratwood base_damage, self_damage).
	var/base_damage = 0
	var/self_share = 0
	var/damage_amplifier = 0
	var/next_message = 0

/datum/status_effect/rogue_immolation/on_creation(mob/living/new_owner, mob/living/carbon/caster_mob, mob/living/carbon/partner_mob, rank, astratan)
	caster = WEAKREF(caster_mob)
	partner = WEAKREF(partner_mob)
	duration = rogue_value("faith_immolation_time")
	base_damage = rogue_value("faith_immolation_damage")
	self_share = rogue_value("faith_immolation_self")
	damage_amplifier = rogue_value("faith_immolation_amplifier")
	if(rank >= rogue_value("faith_immolation_skill_rank"))
		self_share -= rogue_value("faith_immolation_skill_relief")
		damage_amplifier += rogue_value("faith_immolation_skill_boost")
	if(astratan)
		self_share -= rogue_value("faith_immolation_devout_relief")
		damage_amplifier += rogue_value("faith_immolation_devout_boost")
	return ..()

/datum/status_effect/rogue_immolation/on_apply()
	if(!owner.get_filter(ROGUE_IMMOLATION_FILTER))
		owner.add_filter(ROGUE_IMMOLATION_FILTER, 2, list("type" = "outline", "color" = outline_color, "alpha" = 60, "size" = 2))
	return TRUE

/datum/status_effect/rogue_immolation/on_remove()
	owner.remove_filter(ROGUE_IMMOLATION_FILTER)
	QDEL_NULL(flame)

/datum/status_effect/rogue_immolation/get_examine_text(mob/examiner)
	if(is_partner)
		return span_danger("[owner.p_They()] [owner.p_are()] wreathed in holy flames!")

/// Both ends of the flame go out together.
/datum/status_effect/rogue_immolation/proc/put_out()
	var/mob/living/carbon/caster_mob = caster?.resolve()
	var/mob/living/carbon/partner_mob = partner?.resolve()
	caster = null
	partner = null
	for(var/mob/living/carbon/end as anything in list(caster_mob, partner_mob))
		if(!QDELETED(end))
			end.remove_status_effect(/datum/status_effect/rogue_immolation)
			end.remove_status_effect(/datum/status_effect/rogue_immolation/burning)

/datum/status_effect/rogue_immolation/tick(seconds_between_ticks)
	var/mob/living/carbon/caster_mob = caster?.resolve()
	var/mob/living/carbon/partner_mob = partner?.resolve()
	if(QDELETED(caster_mob) || QDELETED(partner_mob) || partner_mob.stat == DEAD || caster_mob.stat != STABLE || get_dist(partner_mob, caster_mob) > rogue_value("faith_immolation_range"))
		put_out()
		return

/// The flame on the one it burns: it cuts everyone around, and mends no wounds.
/datum/status_effect/rogue_immolation/burning
	id = "rogue_immolation_burning"
	is_partner = TRUE

/datum/status_effect/rogue_immolation/burning/on_apply()
	. = ..()
	if(!flame)
		flame = owner.mob_light(2, 2, "#ff8c1a")

/datum/status_effect/rogue_immolation/burning/tick(seconds_between_ticks)
	. = ..()
	var/mob/living/carbon/caster_mob = caster?.resolve()
	var/mob/living/carbon/partner_mob = partner?.resolve()
	if(!caster_mob || !partner_mob)
		return
	// Ratwood: the healing of a miracle does not take on the one that burns.
	partner_mob.remove_status_effect(/datum/status_effect/rogue_miracle_heal)
	var/list/victims = list()
	for(var/mob/living/victim in view(rogue_value("faith_immolation_aura"), partner_mob))
		if(victim == partner_mob || victim == caster_mob || victim.stat == DEAD)
			continue
		victims += victim
	var/count = length(victims)
	if(!count)
		// Ratwood: the flame still burns the one it is on a little.
		partner_mob.adjust_brute_loss(rogue_value("faith_immolation_idle"))
		return
	var/each = base_damage * (damage_amplifier + rogue_value("faith_immolation_crowd") * (count - 1)) / count
	var/speak = world.time >= next_message
	for(var/mob/living/victim as anything in victims)
		if(iscarbon(victim))
			var/mob/living/carbon/cut = victim
			var/list/limbs = list()
			for(var/zone in list(BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
				var/obj/item/bodypart/limb = cut.get_bodypart(zone)
				if(limb)
					limbs += limb
			if(!length(limbs))
				continue
			var/obj/item/bodypart/struck = pick(limbs)
			struck.receive_damage(brute = each)
			if(speak)
				cut.visible_message(span_danger("[cut]'s [struck.name] is cut by holy flames!"))
			if(struck.brute_dam >= struck.max_damage)
				cut.visible_message(span_danger("[cut]'s [struck.name] is dismembered violently by cutting flames!"))
				struck.dismember()
		else
			victim.adjust_brute_loss(each * rogue_value("faith_immolation_beast"))
			if(speak)
				victim.visible_message(span_danger("[victim] is cut by holy flames!"))
	if(speak)
		next_message = world.time + rogue_value("faith_immolation_message_gap")
	partner_mob.adjust_brute_loss(base_damage * self_share)

/// Ratwood immolation "Immolation" (T4 of Astrata): the fire is lit on the target after a short prayer; a caster that
/// lights it on themselves burns alone, otherwise they hold it from afar.
/datum/action/cooldown/spell/pointed/rogue_miracle/immolation
	name = "Immolation"
	desc = "Ignite a target in holy flames, burning those that surround them. The fire burns brighter within devout Astratans, and with the skill of the caster."
	button_icon = ROGUE_MIRACLES_ASTRATA_ICON
	button_icon_state = "immolation"
	sound = 'sound/effects/magic/fireball.ogg'
	invocation = "By sacred fire, be cleansed!"
	invocation_type = INVOCATION_SHOUT
	cooldown_time = 600 SECONDS
	cast_range = 2
	miracle_tier = ROGUE_MIRACLE_TIER_4
	devotion_cost = 60
	miracle_forks = "Ratwood, Azure Peak (T4)"
	miracle_gods = "Astrata T4"
	/// The prayer before the fire (Ratwood 1 second).
	var/prayer_time = 1 SECONDS

/datum/action/cooldown/spell/pointed/rogue_miracle/immolation/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	if(!iscarbon(cast_on))
		to_chat(owner, span_warning("Only flesh can be set alight by this."))
		return FALSE
	if(owner.has_status_effect(/datum/status_effect/rogue_immolation) || owner.has_status_effect(/datum/status_effect/rogue_immolation/burning))
		to_chat(owner, span_warning("I am already channeling someone."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/immolation/cast(mob/living/carbon/cast_on)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(light), owner, cast_on)

/datum/action/cooldown/spell/pointed/rogue_miracle/immolation/proc/light(mob/living/carbon/caster, mob/living/carbon/target)
	caster.visible_message(span_danger("[caster] begins lighting [target] ablaze with strange, divine fire!"))
	if(!do_after(caster, prayer_time, target = target))
		to_chat(caster, span_warning("Astratan might requires unwavering focus to channel!"))
		refund()
		return
	// Ratwood reads the skill of the target here, which is no one's meaning: the caster's skill counts.
	var/rank = caster.rogue_skill_rank(/datum/attribute/skill/magic/holy)
	var/astratan = FALSE
	if(ishuman(target))
		var/mob/living/carbon/human/lit = target
		astratan = istype(lit.rogue_patron, /datum/patron/divine/astrata)
	if(target != caster)
		caster.apply_status_effect(/datum/status_effect/rogue_immolation, caster, target, rank, astratan)
	target.apply_status_effect(/datum/status_effect/rogue_immolation/burning, caster, target, rank, astratan)
	caster.visible_message(span_notice("Holy flames erupt from [caster]'s hands and engulf [target]!"))
	if(astratan)
		target.visible_message(span_danger("[target] lights ablaze with a grand, roaring pyre of divinity. Fire slashing violently like a blade in a small area around them."))
	else
		target.visible_message(span_danger("[target] lights ablaze with sacred fire. Fire cutting like a blade in a small area around them."))

/// Ratwood light_spear (acolyte/astrata.dm): a spear of light. It cannot be kept: any use but a throw, and letting it go
/// any other way, unmakes it. Thrown, it lands as a lightning strike on a creature and on the ground around it, a quarter
/// less far from the centre; the undead are struck harder; the struck are shocked and slowed.
/obj/item/rogueweapon/light_spear/conjured
	item_flags = SLOWS_WHILE_IN_HAND
	slowdown = 2
	throw_speed = 2
	throwforce = 15
	/// The strike on its own tile and, a ring further out, a share of it (Ratwood strike_damage 25, ring 0.75).
	var/strike_damage = 0
	var/ring_share = 0
	var/strike_delay = 0
	var/struck = FALSE

/obj/item/rogueweapon/light_spear/conjured/Initialize(mapload)
	. = ..()
	strike_damage = rogue_value("faith_spear_damage")
	ring_share = rogue_value("faith_spear_ring")
	strike_delay = rogue_value("faith_spear_delay")
	// Nobody carries it for long.
	addtimer(CALLBACK(src, PROC_REF(vanish)), rogue_value("faith_spear_lifetime"))

/obj/item/rogueweapon/light_spear/conjured/proc/vanish()
	if(QDELETED(src) || struck)
		return
	visible_message(span_notice("[src] dissolves into motes of light."))
	qdel(src)

/obj/item/rogueweapon/light_spear/conjured/attack_self(mob/user)
	vanish()
	return TRUE

/obj/item/rogueweapon/light_spear/conjured/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	vanish()

/obj/item/rogueweapon/light_spear/conjured/dropped(mob/user, silent = FALSE)
	. = ..()
	// A throw drops it first and then sends it flying: one tick to tell a throw from a let-go.
	addtimer(CALLBACK(src, PROC_REF(vanish_if_not_thrown)), 1)

/obj/item/rogueweapon/light_spear/conjured/proc/vanish_if_not_thrown()
	if(!throwing)
		vanish()

/obj/item/rogueweapon/light_spear/conjured/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(struck)
		return
	struck = TRUE
	if(isliving(hit_atom))
		var/mob/living/hit = hit_atom
		hit.electrocute_act(1, src, 1, SHOCK_NOSTUN)
	var/turf/centre = get_turf(hit_atom)
	alpha = 0
	new /obj/effect/temp_visual/rogue_thunderstrike(centre, 4)
	addtimer(CALLBACK(src, PROC_REF(strike), centre, 1), strike_delay)
	for(var/turf/ring in range(1, centre))
		if(get_dist(centre, ring) != 1 || !(ring in view(centre)))
			continue
		new /obj/effect/temp_visual/rogue_thunderstrike(ring, 8)
		addtimer(CALLBACK(src, PROC_REF(strike), ring, ring_share), strike_delay)
	addtimer(CALLBACK(src, GLOBAL_PROC_REF(qdel), src), strike_delay + 1 SECONDS)

/obj/item/rogueweapon/light_spear/conjured/proc/strike(turf/where, share)
	playsound(where, 'sound/effects/magic/lightningbolt.ogg', 50, TRUE)
	new /obj/effect/temp_visual/rogue_thunderstrike(where, 3, TRUE)
	for(var/mob/living/victim in where)
		var/damage = strike_damage * share
		if(victim.mob_biotypes & MOB_UNDEAD)
			damage += rogue_value("faith_spear_undead") * share
		victim.electrocute_act(damage, src, 1, SHOCK_NOSTUN)
		victim.apply_status_effect(/datum/status_effect/rogue_miracle_stats/lightningstruck, rogue_value("faith_spear_shock_time"))

/// The marks of a spear of light that lands: a flash where it will strike, the bolt itself.
/obj/effect/temp_visual/rogue_thunderstrike
	icon = 'icons/effects/effects.dmi'
	icon_state = "electricity3"
	duration = 4
	layer = MASSIVE_OBJ_LAYER
	light_range = 2
	light_color = "#fff1a8"

/obj/effect/temp_visual/rogue_thunderstrike/Initialize(mapload, set_duration, bolt)
	if(set_duration)
		duration = set_duration
	if(bolt)
		icon_state = "lightning"
	return ..()

/// Ratwood astratan_spear "Summon Spear" (T1 of Astrata): the spear of light in the hand; a spear conjured before is unmade.
/datum/action/cooldown/spell/pointed/rogue_miracle/summon_spear
	name = "Summon Spear"
	desc = "An ancient miracle, honed by those who served as Astrata's martial arm in the second era. Beseech Astrata for a spear of light: throw it far, and it strikes as lightning."
	button_icon = ROGUE_MIRACLES_ASTRATA_ICON
	button_icon_state = "spear"
	sound = 'sound/effects/magic/lightningbolt.ogg'
	invocation = "Lady of Order, guide my hand!"
	invocation_type = INVOCATION_SHOUT
	click_to_activate = FALSE
	cooldown_time = 30 SECONDS
	miracle_tier = ROGUE_MIRACLE_TIER_1
	devotion_cost = 50
	needs_holy_symbol = TRUE
	miracle_forks = "Ratwood"
	miracle_gods = "Astrata T1"
	var/datum/weakref/conjured

/datum/action/cooldown/spell/pointed/rogue_miracle/summon_spear/Destroy()
	conjured = null
	return ..()

/datum/action/cooldown/spell/pointed/rogue_miracle/summon_spear/cast(atom/cast_on)
	. = ..()
	var/obj/item/old_spear = conjured?.resolve()
	if(old_spear)
		qdel(old_spear)
	var/obj/item/rogueweapon/light_spear/conjured/spear = new(owner.drop_location())
	conjured = WEAKREF(spear)
	owner.put_in_hands(spear)
	owner.visible_message(span_notice("A spear of light forms in [owner]'s hand!"), span_notice("I beseech Astrata and a mote of Her power forms in my hand."))

#undef ROGUE_ASTRATA_ICON
#undef ROGUE_IMMOLATION_FILTER
