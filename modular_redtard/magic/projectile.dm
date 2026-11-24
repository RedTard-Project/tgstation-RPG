/// Vibelin's projectile spell (spells/spell_types/pointed/projectile/_projectile.dm): the click fires one or more bolts at the
/// target. Arc mode (Vibelin, Twilight Axis toggle_arc_mode(), Shift+G) lobs the bolt over everyone in between: it strikes
/// only on the tile it was aimed at, like an arcing arrow (combat/launchers.dm rogue_arc). Ratwood's staff intent "Magic
/// Arcing" (/datum/intent/special/magicarc, read by Ratwood's divine and unholy blast) arcs it too while the staff in the
/// active hand has it picked. A spell arcs only if it has an arcing bolt (projectile_type_arc) or arcs its own bolt
/// (arcs_itself).
/datum/action/cooldown/spell/rogue/projectile
	abstract_spell_type = /datum/action/cooldown/spell/rogue/projectile
	self_cast_possible = FALSE
	cast_range_key = "magic_range_projectile"
	weapon_cast_penalized = TRUE
	experience_modifier_key = "magic_experience_modifier_projectile"
	tunables = list("cost", "cooldown", "charge", "slowdown", "damage", "tile_time")
	/// What is fired, and what is fired in arc mode (null: the same bolt, arcing, when arcs_itself).
	var/obj/projectile/projectile_type = /obj/projectile/magic/rogue
	var/obj/projectile/projectile_type_arc
	var/arcs_itself = FALSE
	/// Bolts a cast may fire, one a click (Vibelin projectile_amount), and how many each click fires.
	var/projectile_amount = 1
	var/current_amount = 0
	var/projectiles_per_fire = 1
	var/arc_mode = FALSE

/datum/action/cooldown/spell/rogue/projectile/New(Target)
	. = ..()
	if(projectile_amount > 1)
		unset_after_click = FALSE

/datum/action/cooldown/spell/rogue/projectile/set_click_ability(mob/on_who)
	. = ..()
	if(.)
		current_amount = projectile_amount

/datum/action/cooldown/spell/rogue/projectile/unset_click_ability(mob/on_who, refund_cooldown = TRUE)
	. = ..()
	if(. && projectile_amount > 1 && current_amount)
		// Bolts left unfired shorten the cooldown (Vibelin on_deactivation()).
		StartCooldown(cooldown_time * ((projectile_amount - current_amount) / projectile_amount))
		current_amount = 0

/datum/action/cooldown/spell/rogue/projectile/cast(atom/cast_on)
	. = ..()
	if(!isturf(owner.loc))
		return fail()
	fire_projectile(cast_on)
	if(current_amount <= 0 && owner.click_intercept == src)
		unset_click_ability(owner, refund_cooldown = FALSE)
	return TRUE

/datum/action/cooldown/spell/rogue/projectile/after_cast(atom/cast_on)
	. = ..()
	if(current_amount > 0)
		reset_spell_cooldown()

/// Arcs this cast: Shift+G set it, or the active hand's item has Magic Arcing picked (Ratwood a_intent check).
/datum/action/cooldown/spell/rogue/projectile/proc/arcing()
	if(!projectile_type_arc && !arcs_itself)
		return FALSE
	if(arc_mode)
		return TRUE
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/caster = owner
	return istype(caster.rogue_active_intent(), /datum/intent/special/magicarc)

/datum/action/cooldown/spell/rogue/projectile/proc/fire_projectile(atom/target)
	current_amount--
	var/arc = arcing()
	var/obj/projectile/fired_type = (arc && projectile_type_arc) ? projectile_type_arc : projectile_type
	for(var/i in 1 to projectiles_per_fire)
		var/obj/projectile/to_fire = new fired_type(get_turf(owner))
		ready_projectile(to_fire, target, i, arc)
		to_fire.fire()
	return TRUE

/datum/action/cooldown/spell/rogue/projectile/proc/ready_projectile(obj/projectile/to_fire, atom/target, iteration, arc)
	to_fire.firer = owner
	to_fire.fired_from = src
	var/damage = tune("damage")
	if(damage)
		to_fire.damage = damage
	// Deciseconds a tile, as the launchers' rounds have it (rogue_tile_time); none keeps the bolt's own speed.
	var/tile_time = tune("tile_time")
	if(tile_time > 0)
		to_fire.speed = 1 / tile_time
	if(istype(to_fire, /obj/projectile/magic))
		var/obj/projectile/magic/magic_bolt = to_fire
		magic_bolt.antimagic_flags = antimagic_flags
	if(istype(to_fire, /obj/projectile/magic/rogue))
		var/obj/projectile/magic/rogue/bolt = to_fire
		bolt.rogue_arc = arc
		// The bolt meets the armor of combat/ as an arrow does (Vibelin flag "piercing" and armor_penetration): its
		// penetration is the spell's spell_<type>_penetration (Ratwood's tier 0-4, or a percent as Vibelin writes it), none
		// without one (0) the bolt keeps the TG magic bolt's 100 that passes every armor, as before the port.
		var/penetration = tune("penetration")
		if(rogue_combat_enabled() && penetration > 0)
			bolt.armour_penetration = penetration
		if(!bolt.spell_impact_color)
			bolt.spell_impact_color = spell_color
		if(arc)
			bolt.range = max(CEILING(get_dist_euclidean(owner, target), 1), 1) + rogue_value("magic_arc_extra_range")
	to_fire.aim_projectile(target, owner)
	RegisterSignal(to_fire, COMSIG_PROJECTILE_SELF_ON_HIT, PROC_REF(on_cast_hit))

/// Vibelin on_cast_hit(): a bolt that strikes the living teaches a little more.
/datum/action/cooldown/spell/rogue/projectile/proc/on_cast_hit(datum/source, mob/firer, atom/target, angle, hit_limb)
	SIGNAL_HANDLER
	SEND_SIGNAL(src, COMSIG_SPELL_PROJECTILE_HIT, source, firer, target, angle, hit_limb)
	if(QDELETED(owner) || !isliving(target))
		return
	var/mob/living/victim = target
	if(victim.stat != DEAD)
		handle_exp(get_adjusted_cost() * rogue_value("magic_experience_hit_share"))

/datum/action/cooldown/spell/rogue/projectile/toggle_alt_mode(mob/user)
	if(!projectile_type_arc && !arcs_itself)
		to_chat(user, span_warning("[name] cannot be arced."))
		return TRUE
	arc_mode = !arc_mode
	if(arc_mode)
		to_chat(user, span_notice("[name] arc mode enabled - the bolt flies over everyone in between."))
	else
		to_chat(user, span_notice("[name] arc mode disabled."))
	update_arc_maptext()
	return TRUE

/// Vibelin update_arc_maptext(): ARC on the button while arc mode is on.
/datum/action/cooldown/spell/rogue/projectile/proc/update_arc_maptext()
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/button = viewers[hud]
		if(!button)
			continue
		var/atom/movable/screen/rogue_arc_maptext/holder = locate() in button.vis_contents
		if(!holder)
			holder = new
			button.vis_contents += holder
		holder.maptext = arc_mode ? MAPTEXT("ARC") : null

/// Vibelin /atom/movable/screen/arc_maptext_holder.
/atom/movable/screen/rogue_arc_maptext
	maptext_x = 6
	maptext_y = 12
	color = "#00ccff"
	vis_flags = VIS_INHERIT_PLANE|VIS_INHERIT_LAYER

/// The bolt of the basket's spells (Vibelin /obj/projectile/magic). Arcing, it flies over the living that are not on the
/// tile it was aimed at (Ratwood arcshot; combat/launchers.dm does it for arrows). It flashes where it strikes (Vibelin
/// spell_impact, visuals.dm) in its spell's colour.
/obj/projectile/magic/rogue
	name = "arcyne bolt"
	icon_state = "energy"
	damage = 0
	var/rogue_arc = FALSE
	/// What armor of combat/ it meets (Vibelin flag: ROGUE_ARMOR_PIERCING, _SLASH, _BLUNT, _FIRE...) and the blow class of
	/// the wound it leaves (Vibelin woundclass, BCLASS_*); combat/armor.dm and combat/wounds.dm read them (see the ВМ1б report).
	var/rogue_armor_type = ROGUE_ARMOR_PIERCING
	var/rogue_bclass
	/// Vibelin spell_impact_intensity and spell_impact_color (the spell's colour when unset, else the bolt's light).
	var/spell_impact_intensity = ROGUE_SPELL_IMPACT_LOW
	var/spell_impact_color

/obj/projectile/magic/rogue/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	if(spell_impact_intensity > ROGUE_SPELL_IMPACT_NONE && get_turf(target))
		new /obj/effect/temp_visual/rogue_spell_impact(get_turf(target), spell_impact_color || light_color || COLOR_WHITE, spell_impact_intensity)

/obj/projectile/magic/rogue/prehit_pierce(atom/target)
	if(rogue_arc && isliving(target) && original && get_turf(target) != get_turf(original))
		return PROJECTILE_PIERCE_PHASE
	return ..()
