/// The miracles of Abyssor that the basket (miracle.dm) did not have yet: Aquatic Compulsion, Second Wind (Ratwood: Abyssor's Wind),
/// Depth Bends, Undertow, Abyssal Healing, Call Dreamfiend, Abyssal Infusion with the Abyssal Strength it gives, and the Abyssal
/// Revival (Ratwood code/modules/spells/roguetown/acolyte/abyssor.dm and resurrect.dm). Call Mossback, which needs a mob and the
/// orders to a minion that the port does not have, is not here. The numbers are in faith.txt, the ones of a cast by
/// miracle_<value_key>_*.

#define ROGUE_ABYSSOR_ICON 'modular_redtard/faith/icons/abyssormiracles.dmi'
#define ROGUE_ABYSSAL_FILTER "rogue_abyssal_glow"

/// The dreamfiends a summoner can call (the port has the minor and the ancient; Ratwood's major one is missing).
#define ROGUE_DREAMFIEND_MINOR /mob/living/simple_animal/hostile/rogue/dreamfiend/unbound
#define ROGUE_DREAMFIEND_ANCIENT /mob/living/simple_animal/hostile/rogue/dreamfiend/ancient/unbound

/// Ratwood summon_dreamfiend(): a dreamfiend of the given kind manifests on a free tile of a ring around the target, and
/// hunts it. False when there was no room. The fiend does not fight its summoner's allies.
/proc/rogue_summon_dreamfiend(mob/living/target, mob/living/summoner, fiend_type = ROGUE_DREAMFIEND_MINOR, outer_radius = 2, inner_radius = 1)
	var/turf/centre = get_turf(target)
	if(!centre)
		return FALSE
	var/list/spots = list()
	for(var/turf/open/tile in range(outer_radius, centre))
		if(get_dist(tile, centre) <= inner_radius || tile.density || isspaceturf(tile) || istransparentturf(tile))
			continue
		spots += tile
	if(!length(spots))
		return FALSE
	var/mob/living/basic/fiend = new fiend_type(pick(spots))
	if(summoner)
		fiend.faction = summoner.faction.Copy()
	fiend.faction |= "dream"
	if(fiend.ai_controller)
		fiend.ai_controller.set_blackboard_key(BB_CURRENT_TARGET, target)
	fiend.visible_message(span_notice("A [fiend] manifests following after [target]... countless teeth bared with hostility!"))
	return TRUE

/// Ratwood abyssor_bends "Depth Bends" (T1 of Abyssor): the weight of the deep drains the stamina of whoever does not worship
/// Abyssor, more the more skilled the caster; and makes them dizzy and blurs their sight.
/datum/action/cooldown/spell/pointed/rogue_miracle/depth_bends
	name = "Depth Bends"
	desc = "Drains the target's stamina, unless they worship Abyssor. Also makes them dizzy and blurs their screen."
	button_icon = ROGUE_ABYSSOR_ICON
	button_icon_state = "bends"
	sound = 'sound/effects/bubbles/bubbles.ogg'
	invocation = "Weight of the deep, crush!"
	invocation_type = INVOCATION_SHOUT
	value_key = "depth_bends"
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_1
	miracle_forks = "Ratwood"
	miracle_gods = "Abyssor T1"

/datum/action/cooldown/spell/pointed/rogue_miracle/depth_bends/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !isliving(cast_on))
		to_chat(owner, span_warning("Only the living can feel the deep."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/depth_bends/cast(mob/living/cast_on)
	. = ..()
	var/mob/living/caster = owner
	caster.visible_message("<font color='yellow'>[caster] makes a fist at [cast_on]!</font>")
	if(iscarbon(cast_on))
		var/mob/living/carbon/victim = cast_on
		var/devout = FALSE
		if(ishuman(victim))
			var/mob/living/carbon/human/believer = victim
			devout = istype(believer.rogue_patron, /datum/patron/divine/abyssor)
		if(!devout)
			victim.adjust_stamina_loss(caster.rogue_skill_rank(/datum/attribute/skill/magic/holy) * rogue_value("faith_bends_drain"))
	cast_on.set_dizzy_if_lower(rogue_value("faith_bends_dizzy"))
	cast_on.adjust_eye_blur(rogue_value("faith_bends_blur"))
	cast_on.emote("gasp")

/// Ratwood abyssor_undertow "Undertow" (T2 of Abyssor): a creature in the water is thrown down; on land it is only put off
/// balance.
/datum/action/cooldown/spell/pointed/rogue_miracle/undertow
	name = "Undertow"
	desc = "Throws the target down if they are in water, otherwise puts them off balance."
	button_icon = ROGUE_ABYSSOR_ICON
	button_icon_state = "undertow"
	sound = 'sound/effects/bubbles/bubbles2.ogg'
	invocation = "Strangling waters, pull!"
	invocation_type = INVOCATION_SHOUT
	value_key = "undertow"
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_2
	miracle_forks = "Ratwood"
	miracle_gods = "Abyssor T2"

/datum/action/cooldown/spell/pointed/rogue_miracle/undertow/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !isliving(cast_on))
		to_chat(owner, span_warning("Only the living can be pulled under."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/undertow/cast(mob/living/cast_on)
	. = ..()
	var/mob/living/caster = owner
	caster.visible_message("<font color='yellow'>[caster] raises a hand towards [cast_on]!</font>")
	if(istype(get_turf(cast_on), /turf/open/water))
		cast_on.Knockdown(rogue_value("faith_undertow_knockdown"))
		return
	if(ishuman(cast_on))
		var/mob/living/carbon/human/victim = cast_on
		victim.rogue_off_balance(rogue_value("faith_undertow_offbalance"))

/// Ratwood abyssor_wind "Second Wind" (T0 of Abyssor): rise if fallen, shake off a fall, a hold or an unbalance, and have some
/// of the stamina and energy back, more with the skill; no use to the stunned.
/datum/action/cooldown/spell/pointed/rogue_miracle/second_wind
	name = "Second Wind"
	desc = "Rise if fallen, and regain some of my stamina and energy."
	button_icon = ROGUE_ABYSSOR_ICON
	button_icon_state = "abyssor_wind"
	sound = 'sound/effects/bubbles/bubbles.ogg'
	click_to_activate = FALSE
	value_key = "second_wind"
	miracle_tier = ROGUE_MIRACLE_TIER_0
	miracle_forks = "Ratwood"
	miracle_gods = "Abyssor T0"

/datum/action/cooldown/spell/pointed/rogue_miracle/second_wind/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/winded = owner
	if(winded.IsStun() || winded.IsParalyzed())
		return fail("I am too incapacitated!")
	winded.remove_status_effect(/datum/status_effect/incapacitating/knockdown)
	winded.remove_status_effect(/datum/status_effect/incapacitating/immobilized)
	winded.rogue_offbalance_until = 0
	var/message = span_warning("[winded] ")
	if(winded.resting)
		winded.set_resting(FALSE, TRUE)
		message += span_warning("rises and ")
	var/regen = rogue_value("faith_second_wind_share") * winded.rogue_skill_rank(/datum/attribute/skill/magic/holy)
	winded.adjust_stamina_loss(-regen * winded.maxHealth)
	winded.rogue_energy_add(regen * winded.rogue_max_energy)
	message += span_warning("becomes invigorated!")
	winded.visible_message(message)

/// Ratwood aquatic_compulsion "Aquatic Compulsion" (T0 of Abyssor): a fish, or whatever else the water holds, leaps out of the
/// targeted water and flies toward the caster. It draws on the catch of that water as the angler's rod does, with its own draw
/// of the kinds (common, rare, treasure, trash, danger and cerulean, in the order of the fishing tables).
/datum/action/cooldown/spell/pointed/rogue_miracle/aquatic_compulsion
	name = "Aquatic Compulsion"
	desc = "Compel a fish to leap out from the targeted water tile and toward me."
	button_icon = ROGUE_ABYSSOR_ICON
	button_icon_state = "aqua"
	sound = 'sound/effects/bubbles/bubbles.ogg'
	invocation = "Splash forth."
	invocation_type = INVOCATION_SHOUT
	value_key = "aquatic_compulsion"
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_0
	miracle_forks = "Ratwood"
	miracle_gods = "Abyssor T0"

/datum/action/cooldown/spell/pointed/rogue_miracle/aquatic_compulsion/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !istype(cast_on, /turf/open/water/rockhill))
		to_chat(owner, span_warning("That is not water I can draw a fish from."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/aquatic_compulsion/cast(turf/open/water/rockhill/cast_on)
	. = ..()
	var/mob/living/caster = owner
	if(!cast_on.rogue_fish_waters)
		return fail("Nothing bites here.")
	// What the water draws: nothing from the bait's slot, then common, rare, treasure, trash, danger and cerulean.
	var/list/draws = list(0, rogue_value("faith_compel_common"), rogue_value("faith_compel_rare"), rogue_value("faith_compel_treasure"), rogue_value("faith_compel_trash"), rogue_value("faith_compel_danger"), rogue_value("faith_compel_cerulean"))
	var/catch_type = rogue_pick_catch(cast_on.rogue_fish_waters, draws)
	if(!catch_type)
		return fail("The water gives nothing.")
	var/atom/movable/caught = new catch_type(cast_on)
	caught.throw_at(get_turf(caster), rogue_value("faith_compel_throw"), 1, null)
	playsound(cast_on, 'sound/effects/bubbles/bubbles2.ogg', 100)
	caster.visible_message("<font color='yellow'>[caster] makes a beckoning gesture at [cast_on]!</font>")

/// Ratwood abyssheal "Abyssal Healing" (T2 of Abyssor): the target is healed over time, more with water around the caster;
/// the connection with Abyssor is worn down by every cast away from water and restored near it. The burns of the target are
/// mended at once. The undead are crushed by the pressure instead.
/datum/action/cooldown/spell/pointed/rogue_miracle/abyssal_healing
	name = "Abyssal Healing"
	desc = "Heals the target over time, more if there is water around me. Weakens if cast away from water for too long."
	button_icon = ROGUE_ABYSSOR_ICON
	button_icon_state = "deepheal"
	sound = 'sound/effects/bubbles/bubbles2.ogg'
	invocation = "Healing waters, come forth!"
	invocation_type = INVOCATION_SHOUT
	value_key = "abyssal_healing"
	miracle_tier = ROGUE_MIRACLE_TIER_2
	miracle_forks = "Ratwood, Azure Peak"
	miracle_gods = "Abyssor T2"
	/// The connection: it is worn down a point by every cast away from water, and the most it can be a point above which the
	/// healing weakens. Set when the miracle is made.
	var/slickness = 0
	var/max_slickness = 0

/datum/action/cooldown/spell/pointed/rogue_miracle/abyssal_healing/New(Target)
	. = ..()
	max_slickness = rogue_value("faith_abyssheal_slickness")
	slickness = max_slickness

/datum/action/cooldown/spell/pointed/rogue_miracle/abyssal_healing/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !isliving(cast_on))
		to_chat(owner, span_warning("Only the living can be healed."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/abyssal_healing/cast(mob/living/cast_on)
	. = ..()
	var/mob/living/caster = owner
	if(turned_away(cast_on))
		return
	if(burns_undead(cast_on))
		cast_on.visible_message(span_danger("[cast_on] is crushed by divine pressure!"), span_userdanger("I'm crushed by divine pressure!"))
		cast_on.adjust_brute_loss(rogue_value("faith_abyssheal_crush"))
		return
	cast_on.visible_message(span_info("A wave of divine energy crashes over [cast_on]!"), span_notice("I'm crushed by healing energies!"))
	var/static/list/water = typecacheof(list(/turf/open/water/bath, /turf/open/water/ocean, /turf/open/water/cleanshallow, /turf/open/water/swamp, /turf/open/water/pond, /turf/open/water/river))
	var/static/list/deep = typecacheof(list(/turf/open/water/ocean/deep))
	var/situational_bonus = 0
	for(var/turf/tile in oview(rogue_value("faith_abyssheal_range"), caster))
		if(water[tile.type])
			situational_bonus = min(situational_bonus + rogue_value("faith_abyssheal_water_step"), rogue_value("faith_abyssheal_water_cap"))
	for(var/turf/tile in oview(rogue_value("faith_abyssheal_range"), caster))
		if(deep[tile.type])
			situational_bonus += rogue_value("faith_abyssheal_deep_step")
	// A caster past the third rank keeps a stronger connection (Ratwood: held at forty instead of twenty).
	if(caster.rogue_skill_rank(/datum/attribute/skill/magic/holy) > rogue_value("faith_abyssheal_greater_rank"))
		max_slickness = rogue_value("faith_abyssheal_slickness_greater")
	var/conditional = FALSE
	if(situational_bonus > 0)
		slickness = max_slickness
		conditional = TRUE
		to_chat(caster, "Calling upon Abyssor's power is easier in these conditions!")
	if(slickness / max_slickness <= rogue_value("faith_abyssheal_weak_share"))
		to_chat(caster, span_warning("My connection to Abyssor is weakening. Cast near water to renew it."))
	var/healing = max(rogue_value("faith_abyssheal_healing") * (slickness / max_slickness) + situational_bonus, rogue_value("faith_abyssheal_healing_least"))
	if(!situational_bonus)
		slickness = max(0, slickness - 1)
	cast_on.adjust_fire_loss(-rogue_value("faith_abyssheal_burn"))
	if(conditional)
		cast_on.adjust_fire_loss(-rogue_value("faith_abyssheal_burn_water"))
	cast_on.apply_status_effect(/datum/status_effect/rogue_miracle_heal, healing)

/// Ratwood call_dreamfiend "Summon Dreamfiend" (T3 of Abyssor): a dreamfiend manifests close to the target and hounds it.
/datum/action/cooldown/spell/pointed/rogue_miracle/call_dreamfiend
	name = "Summon Dreamfiend"
	desc = "Summons a dreamfiend to hound my target."
	button_icon = ROGUE_ABYSSOR_ICON
	button_icon_state = "dreamfiend"
	sound = 'sound/effects/bubbles/bubbles.ogg'
	invocation = "From the dream, consume!"
	invocation_type = INVOCATION_SHOUT
	value_key = "call_dreamfiend"
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_3
	miracle_forks = "Ratwood, Azure Peak"
	miracle_gods = "Abyssor T3"

/datum/action/cooldown/spell/pointed/rogue_miracle/call_dreamfiend/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !iscarbon(cast_on))
		to_chat(owner, span_warning("This only works on creatures capable of dreaming!"))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/call_dreamfiend/cast(mob/living/carbon/cast_on)
	. = ..()
	if(!rogue_summon_dreamfiend(cast_on, owner, ROGUE_DREAMFIEND_MINOR, rogue_value("faith_dreamfiend_outer"), rogue_value("faith_dreamfiend_inner")))
		return fail("No valid space to manifest the dreamfiend!")

/// Ratwood buff/abyssal: for a while a body swells with strength, constitution and will, at the cost of luck, speed and sight;
/// the stats are set by the stage of the miracle that gave it.
/datum/status_effect/rogue_abyssal_strength
	id = "rogue_abyssal_strength"
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null
	tick_interval = STATUS_EFFECT_NO_TICK
	/// The stats it moves.
	var/list/stats

/datum/status_effect/rogue_abyssal_strength/on_creation(mob/living/new_owner, list/new_stats)
	stats = new_stats
	duration = rogue_value("faith_abyssal_time")
	return ..()

/datum/status_effect/rogue_abyssal_strength/refresh(effect, list/new_stats)
	stats = new_stats
	duration = rogue_value("faith_abyssal_time")
	owner.attributes?.set_variable_attribute_modifier(id, stats.Copy())

/datum/status_effect/rogue_abyssal_strength/get_examine_text(mob/examiner)
	return span_warning("[owner.p_They()] [owner.p_have()] muscles swollen with a strange pale strength.")

/datum/status_effect/rogue_abyssal_strength/on_apply()
	owner.attributes?.set_variable_attribute_modifier(id, stats.Copy())
	ADD_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, ROGUE_FAITH_TRAIT)
	if(!owner.get_filter(ROGUE_ABYSSAL_FILTER))
		owner.add_filter(ROGUE_ABYSSAL_FILTER, 2, list("type" = "outline", "color" = "#00051f", "alpha" = 180, "size" = 1))
	to_chat(owner, span_warning("My limbs swell with otherworldly power!"))
	return TRUE

/datum/status_effect/rogue_abyssal_strength/on_remove()
	owner.attributes?.remove_attribute_modifier(id)
	REMOVE_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, ROGUE_FAITH_TRAIT)
	owner.remove_filter(ROGUE_ABYSSAL_FILTER)
	to_chat(owner, span_warning("The strange power fades."))

/// Ratwood abyssal_strength "Abyssal Strength" (given by Abyssal Infusion): buffs every stat but fortune and lowers perception,
/// more with each stage; the more it is used the louder the whispers, and the more likely a dreamfiend is to come out of the
/// dream to take its due. It is no miracle of the basket and costs no devotion: the infusion gives it to a person for good.
/datum/action/cooldown/spell/rogue_abyssal_strength
	name = "Abyssal Strength"
	desc = "Buffs all my stats besides fortune, and lowers my perception. The dream grows louder with every use."
	button_icon = ROGUE_ABYSSOR_ICON
	button_icon_state = "abyssal_strength1"
	background_icon = ROGUE_MIRACLES_ICON
	background_icon_state = "spell0"
	base_background_icon_state = "spell0"
	active_background_icon_state = "spell1"
	overlay_icon_state = null
	active_overlay_icon_state = null
	school = SCHOOL_HOLY
	spell_requirements = SPELL_REQUIRES_HUMAN
	invocation = "shogg vulgt!"
	invocation_type = INVOCATION_SHOUT
	sound = 'sound/effects/bubbles/bubbles.ogg'
	/// How far the whispers have come (1 to 3), and the casts made in this stage.
	var/stage = 1
	var/casts_in_stage = 0
	/// The chance a dreamfiend comes at the last stage; it grows with every cast.
	var/last_stage_chance = 0

/datum/action/cooldown/spell/rogue_abyssal_strength/New(Target)
	cooldown_time = rogue_value("miracle_abyssal_strength_cooldown")
	last_stage_chance = rogue_value("faith_abyssal_chance_3_start")
	return ..()

/datum/action/cooldown/spell/rogue_abyssal_strength/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/vessel = owner
	var/summon_chance = 0
	var/fiend_type = ROGUE_DREAMFIEND_MINOR
	switch(stage)
		if(1)
			summon_chance = rogue_value("faith_abyssal_chance_1_base") + casts_in_stage * rogue_value("faith_abyssal_chance_1_step")
		if(2)
			summon_chance = rogue_value("faith_abyssal_chance_2_base") + casts_in_stage * rogue_value("faith_abyssal_chance_2_step")
		if(3)
			summon_chance = last_stage_chance
			last_stage_chance += rand(1, rogue_value("faith_abyssal_chance_3_growth"))
			fiend_type = ROGUE_DREAMFIEND_ANCIENT
	if(prob(summon_chance))
		rogue_summon_dreamfiend(vessel, vessel, fiend_type)
		to_chat(vessel, span_userdanger("You feel the dream manifest in reality, bearing a horrifying form!"))
		qdel(src)
		return
	if(stage < 3)
		casts_in_stage++
		if(casts_in_stage > rogue_value("faith_abyssal_casts_per_stage"))
			stage++
			casts_in_stage = 0
			if(stage == 3)
				to_chat(vessel, span_warning("I can feel countless slimy and oozing teeth biting into my skin! Something horrifying is observing me!"))
			else
				to_chat(vessel, span_warning("The whispers in my head grow louder..."))
	vessel.apply_status_effect(/datum/status_effect/rogue_abyssal_strength, list(
		ROGUE_STAT_STRENGTH = rogue_value("faith_abyssal_strength_base") + (stage - 1) * rogue_value("faith_abyssal_strength_step"),
		ROGUE_STAT_CONSTITUTION = rogue_value("faith_abyssal_stat_base") + stage * rogue_value("faith_abyssal_stat_step"),
		ROGUE_STAT_WILLPOWER = rogue_value("faith_abyssal_stat_base") + stage * rogue_value("faith_abyssal_stat_step"),
		ROGUE_STAT_FORTUNE = rogue_value("faith_abyssal_malus_base") - stage * rogue_value("faith_abyssal_malus_step"),
		ROGUE_STAT_SPEED = rogue_value("faith_abyssal_malus_base") - stage * rogue_value("faith_abyssal_malus_step"),
		ROGUE_STAT_PERCEPTION = -stage * rogue_value("faith_abyssal_perception_step")))
	button_icon_state = "abyssal_strength[stage]"
	build_all_button_icons()

/// Ratwood abyssal_infusion "Abyssal Infusion" (T4 of Abyssor): an anglerfish in the caster's hand is consumed to bless the
/// target with Abyssal Strength.
/datum/action/cooldown/spell/pointed/rogue_miracle/abyssal_infusion
	name = "Abyssal Infusion"
	desc = "Consumes an anglerfish held in my hand to bless the target with the ability to call upon Abyssal Strength."
	button_icon = ROGUE_ABYSSOR_ICON
	button_icon_state = "abyssal_infusion"
	sound = 'sound/effects/bubbles/bubbles.ogg'
	invocation = "shogg vulgt!"
	invocation_type = INVOCATION_SHOUT
	value_key = "abyssal_infusion"
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_4
	miracle_forks = "Ratwood, Azure Peak"
	miracle_gods = "Abyssor T4"

/datum/action/cooldown/spell/pointed/rogue_miracle/abyssal_infusion/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !ishuman(cast_on))
		to_chat(owner, span_warning("This only works on creatures capable of dreaming!"))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/abyssal_infusion/cast(mob/living/carbon/human/cast_on)
	. = ..()
	var/mob/living/caster = owner
	if(!cast_on.mind)
		return fail("This only works on creatures capable of dreaming!")
	if(locate(/datum/action/cooldown/spell/rogue_abyssal_strength) in cast_on.actions)
		return fail("[cast_on] is already blessed with Abyssor's strength.")
	var/obj/item/angler
	for(var/obj/item/held as anything in caster.held_items)
		if(istype(held, /obj/item/reagent_containers/food/snacks/fish/angler))
			angler = held
			break
	if(!angler)
		return fail("An anglerfish is required to channel the abyssal energies!")
	qdel(angler)
	var/datum/action/cooldown/spell/rogue_abyssal_strength/gift = new(cast_on.mind)
	gift.Grant(cast_on)
	to_chat(cast_on, span_warning("My mind writhes, revealing a new ability."))

/// Ratwood debuff/dreamfiend_curse: a body Abyssor called back is sapped, strength aside, by a dreamfiend that stalks it until it
/// is confronted: it has a spell to call it, in a while.
/datum/status_effect/rogue_miracle_stats/dreamfiend_curse
	id = "rogue_dreamfiend_curse"
	start_message = "<span class='warning'>A nightmare entity has revived me, but now it is draining my vitality. I must summon it to confront it.</span>"
	/// The kind of dreamfiend that stalks it.
	var/fiend_type = ROGUE_DREAMFIEND_MINOR

/datum/status_effect/rogue_miracle_stats/dreamfiend_curse/on_creation(mob/living/new_owner, set_duration)
	if(prob(rogue_value("faith_curse_ancient_chance")))
		fiend_type = ROGUE_DREAMFIEND_ANCIENT
	return ..()

/datum/status_effect/rogue_miracle_stats/dreamfiend_curse/stat_changes()
	return list(ROGUE_STAT_STRENGTH = rogue_value("faith_curse_strength"), ROGUE_STAT_INTELLIGENCE = -rogue_value("faith_curse_intelligence"), ROGUE_STAT_FORTUNE = -rogue_value("faith_curse_fortune"), ROGUE_STAT_SPEED = -rogue_value("faith_curse_speed"), ROGUE_STAT_PERCEPTION = -rogue_value("faith_curse_perception"))

/// It lasts until it is confronted.
/datum/status_effect/rogue_miracle_stats/dreamfiend_curse/new_duration()
	return STATUS_EFFECT_PERMANENT

/datum/status_effect/rogue_miracle_stats/dreamfiend_curse/on_apply()
	. = ..()
	if(owner.mind && !(locate(/datum/action/cooldown/spell/rogue_confront_terror) in owner.actions))
		var/datum/action/cooldown/spell/rogue_confront_terror/confront = new(owner.mind)
		confront.fiend_type = fiend_type
		confront.ready_at = world.time + rogue_value("faith_confront_wait")
		confront.Grant(owner)

/datum/status_effect/rogue_miracle_stats/dreamfiend_curse/on_remove()
	for(var/datum/action/cooldown/spell/rogue_confront_terror/confront in owner.actions)
		qdel(confront)
	return ..()

/// Ratwood summon_dreamfiend_curse "Confront Terror": the one a dreamfiend haunts calls it to face it directly, once they have
/// gathered their strength; the curse is lifted when it comes.
/datum/action/cooldown/spell/rogue_confront_terror
	name = "Confront Terror"
	desc = "Summon the dreamfiend haunting me to confront it directly."
	button_icon = ROGUE_ABYSSOR_ICON
	button_icon_state = "dreamfiend"
	background_icon = ROGUE_MIRACLES_ICON
	background_icon_state = "spell0"
	base_background_icon_state = "spell0"
	active_background_icon_state = "spell1"
	overlay_icon_state = null
	active_overlay_icon_state = null
	school = SCHOOL_HOLY
	spell_requirements = SPELL_REQUIRES_HUMAN
	invocation = "begins to smell of saltwater. You can hear waves crashing nearby..."
	invocation_type = INVOCATION_EMOTE
	sound = 'sound/effects/bubbles/bubbles2.ogg'
	var/fiend_type = ROGUE_DREAMFIEND_MINOR
	/// world.time from which the spell can be cast.
	var/ready_at = 0

/datum/action/cooldown/spell/rogue_confront_terror/New(Target)
	cooldown_time = rogue_value("miracle_confront_terror_cooldown")
	return ..()

/datum/action/cooldown/spell/rogue_confront_terror/can_cast_spell(feedback = TRUE)
	. = ..()
	if(. && world.time < ready_at)
		if(feedback)
			to_chat(owner, span_warning("I must gather my strength before I am ready to confront my terror! ([DisplayTimeText(ready_at - world.time)] left)"))
		return FALSE

/datum/action/cooldown/spell/rogue_confront_terror/cast(atom/cast_on)
	. = ..()
	var/mob/living/haunted = owner
	if(!rogue_summon_dreamfiend(haunted, haunted, fiend_type, rogue_value("faith_confront_outer"), rogue_value("faith_confront_inner")))
		to_chat(haunted, span_warning("No valid space to manifest the nightmare!"))
		return
	haunted.remove_status_effect(/datum/status_effect/rogue_miracle_stats/dreamfiend_curse)

/// Ratwood resurrect/abyssor "Abyssal Revival" (T4 of Abyssor): ten fish of the sea lying by the body and the sea within a tile
/// of it buy the soul back, healed well; a dreamfiend stalks the revived until they face it. The undead are unmade.
/datum/action/cooldown/spell/pointed/rogue_miracle/abyssal_revival
	name = "Abyssal Revival"
	desc = "Revive the target at a cost: fish of the sea on the ground by them, and the sea near them. A dreamfiend will stalk the revived and sap their stats until they confront it."
	button_icon = ROGUE_ABYSSOR_ICON
	button_icon_state = "revive"
	sound = 'sound/effects/bubbles/bubbles2.ogg'
	value_key = "abyssal_revival"
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_4
	needs_holy_symbol = TRUE
	miracle_forks = "Ratwood"
	miracle_gods = "Abyssor T4"

/// What the revival burns: the sea fish lying next to the body, by kind.
/datum/action/cooldown/spell/pointed/rogue_miracle/abyssal_revival/proc/offering()
	return list(
		/obj/item/reagent_containers/food/snacks/fish/sole = rogue_value("faith_revival_sole"),
		/obj/item/reagent_containers/food/snacks/fish/cod = rogue_value("faith_revival_cod"),
		/obj/item/reagent_containers/food/snacks/fish/bass = rogue_value("faith_revival_bass"),
		/obj/item/reagent_containers/food/snacks/fish/plaice = rogue_value("faith_revival_plaice"),
		/obj/item/reagent_containers/food/snacks/fish/lobster = rogue_value("faith_revival_lobster"))

/datum/action/cooldown/spell/pointed/rogue_miracle/abyssal_revival/is_valid_target(atom/cast_on)
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

/datum/action/cooldown/spell/pointed/rogue_miracle/abyssal_revival/cast(mob/living/cast_on)
	. = ..()
	var/mob/living/carbon/human/caster = owner
	var/sea = FALSE
	for(var/turf/open/water/ocean/tile in range(rogue_value("faith_revival_sea_range"), cast_on))
		sea = TRUE
		break
	if(!sea)
		return fail("I need the sea near [cast_on].")
	var/list/wanted = offering()
	var/list/have = list()
	for(var/obj/item/fish in range(rogue_value("faith_revival_item_range"), cast_on))
		if(wanted[fish.type])
			have[fish.type]++
	var/list/missing = list()
	for(var/fish_type in wanted)
		if((have[fish_type] || 0) < wanted[fish_type])
			var/obj/item/fish_item = fish_type
			missing += "[wanted[fish_type] - (have[fish_type] || 0)] [initial(fish_item.name)]"
	if(length(missing))
		return fail("Missing components: [missing.Join(", ")] on the floor next to or on top of [cast_on].")
	INVOKE_ASYNC(src, PROC_REF(call_back), caster, cast_on, wanted)

/datum/action/cooldown/spell/pointed/rogue_miracle/abyssal_revival/proc/call_back(mob/living/carbon/human/caster, mob/living/body, list/wanted)
	caster.visible_message(span_notice("[caster] raises [caster.p_their()] hands over [body], calling upon the deep..."), span_notice("I call upon the deep to return [body] to this world..."))
	if(!do_after(caster, rogue_value("faith_revival_prayer"), target = body))
		to_chat(caster, span_warning("My prayer was interrupted!"))
		refund()
		return
	if(body.mob_biotypes & MOB_UNDEAD)
		body.visible_message(span_danger("[body] is unmade by divine magic!"), span_userdanger("I'm unmade by divine magic!"))
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
	var/was_rotted = body.has_status_effect(/datum/status_effect/rogue_rotted_corpse)
	if(!body.heal_and_revive(rogue_value("faith_revival_mend")))
		to_chat(caster, span_warning("Nothing happens."))
		refund()
		return
	for(var/fish_type in wanted)
		var/left = wanted[fish_type]
		for(var/obj/item/fish in range(rogue_value("faith_revival_item_range"), body))
			if(left <= 0)
				break
			if(fish.type == fish_type)
				left--
				qdel(fish)
	body.visible_message(span_notice("[body] is revived by divine magic!"), span_green("I awake from the void."))
	body.emote("gasp")
	body.set_jitter_if_lower(10 SECONDS)
	rogue_revived(body, caster, was_rotted, type)
	body.apply_status_effect(/datum/status_effect/rogue_miracle_stats/dreamfiend_curse)
	body.apply_status_effect(/datum/status_effect/rogue_miracle_heal, rogue_value("faith_revival_healing"))

#undef ROGUE_ABYSSOR_ICON
#undef ROGUE_ABYSSAL_FILTER
#undef ROGUE_DREAMFIEND_MINOR
#undef ROGUE_DREAMFIEND_ANCIENT
