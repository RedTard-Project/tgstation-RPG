/// Two Vibelin spells ported with the base (block M1) as the pattern for the basket of block M2 and for testing it: a plain
/// bolt (Arcyne Bolt, spell_types/pointed/projectile/arcyne_bolt.dm) and one that arcs with Shift+G or the staff's Magic
/// Arcing (Smoke Burst, smoke_ball.dm). Their numbers are spell_projectile_arcyne_bolt_* and spell_projectile_smoke_burst_*
/// of magic.txt.

/datum/action/cooldown/spell/rogue/projectile/arcyne_bolt
	name = "Arcyne Bolt"
	desc = "Shoot out rapid bolts of arcyne power."
	button_icon_state = "arcane_bolt"
	sound = 'modular_redtard/magic/sound/vlightning.ogg'
	tunables = list("cost", "cooldown", "charge", "slowdown", "damage", "tile_time", "range")
	required_form = ROGUE_FORM_ARCANE
	invocation = "MAGIC MISSILE!!!"
	invocation_type = INVOCATION_SHOUT
	projectile_type = /obj/projectile/magic/rogue/arcyne_bolt
	spell_forks = "Vibelin"
	spell_source_type = "/datum/action/cooldown/spell/projectile/arcyne_bolt"

/// Vibelin /obj/projectile/magic/arcyne_bolt: a blunt bolt; its damage comes from the spell (tune("damage")).
/obj/projectile/magic/rogue/arcyne_bolt
	name = "arcyne bolt"
	icon = 'modular_redtard/magic/icons/projectiles.dmi'
	icon_state = "arcane_barrage"
	damage_type = BRUTE

/datum/action/cooldown/spell/rogue/projectile/smoke_burst
	name = "Smoke Burst"
	desc = "Hurl a harmless ball of smouldering cinders that bursts into a thick cloud of smoke on impact, blocking sight for a while. Deals no damage. Toggle arc mode (Shift+G) while the spell is active to lob it over intervening mobs and obstacles."
	button_icon = 'modular_redtard/magic/icons/mage_pyromancy.dmi'
	button_icon_state = "smoke_burst"
	sound = 'modular_redtard/magic/sound/firesnuff.ogg'
	required_form = ROGUE_FORM_FIRE
	invocation = "Evomere Fumum!"
	invocation_type = INVOCATION_SHOUT
	weapon_cast_penalized = FALSE
	tunables = list("cost", "cooldown", "charge", "slowdown", "tile_time", "smoke_range")
	projectile_type = /obj/projectile/magic/rogue/smoke_burst
	arcs_itself = TRUE
	spell_forks = "Vibelin"
	spell_source_type = "/datum/action/cooldown/spell/projectile/smoke_burst"

/datum/action/cooldown/spell/rogue/projectile/smoke_burst/ready_projectile(obj/projectile/to_fire, atom/target, iteration, arc)
	. = ..()
	var/obj/projectile/magic/rogue/smoke_burst/ball = to_fire
	if(istype(ball))
		ball.smoke_range = tune("smoke_range")

/// Vibelin /obj/projectile/magic/smoke_burst: bursts into smoke where it strikes or falls (TG's smoke, which blocks sight).
/obj/projectile/magic/rogue/smoke_burst
	name = "smoke burst"
	icon = 'modular_redtard/magic/icons/projectiles.dmi'
	icon_state = "spark"
	light_color = "#8a8a8a"
	light_range = 2
	damage = 0
	reflectable = FALSE
	var/smoke_range = 0
	var/has_burst = FALSE

/obj/projectile/magic/rogue/smoke_burst/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	burst(get_turf(target))

/obj/projectile/magic/rogue/smoke_burst/on_range()
	burst(get_turf(src))
	return ..()

/obj/projectile/magic/rogue/smoke_burst/proc/burst(turf/epicenter)
	if(has_burst || !epicenter)
		return
	has_burst = TRUE
	playsound(epicenter, 'modular_redtard/magic/sound/firesnuff.ogg', 70, TRUE)
	do_smoke(smoke_range, null, epicenter)
