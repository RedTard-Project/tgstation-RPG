/// What Ratwood's creatures shoot, as TG projectiles (fired by TG's ranged_attacks component, pve/mind.dm). Ratwood's damage,
/// armor piercing (armour_penetration is the PEN tier the module's armor reads, combat/armor.dm) and side effects; damage
/// comes from mechanics/values.dm when the projectile is made. A brute projectile hits armor as piercing.
/obj/projectile/rogue_pve
	name = "projectile"
	icon = 'icons/obj/weapons/guns/projectiles.dmi'
	damage = 10
	damage_type = BRUTE
	armor_flag = BULLET
	range = 15
	speed = 1
	/// Name of the value of mechanics/values.dm with its damage.
	var/damage_value
	/// What is left where it falls (Ratwood reusable projectiles: ammo_type).
	var/drop_type
	/// Percent chance it is left there.
	var/drop_chance = 100

/obj/projectile/rogue_pve/Initialize(mapload)
	if(damage_value)
		damage = rogue_value(damage_value)
	return ..()

/obj/projectile/rogue_pve/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	if(pierce_hit)
		return
	var/turf/spot = get_turf(target)
	rogue_drop(!spot || isclosedturf(spot) ? get_turf(src) : spot)

/obj/projectile/rogue_pve/on_range()
	rogue_drop(get_turf(src))
	return ..()

/// Leaves what it was where it fell: on the one it hit, or before the wall it struck.
/obj/projectile/rogue_pve/proc/rogue_drop(turf/spot)
	if(!drop_type || !spot || isclosedturf(spot) || !prob(drop_chance))
		return
	new drop_type(spot)
	drop_type = null

/// Ratwood /obj/projectile/bullet/reusable/arrow/ancient of the skeleton archer: a stone arrow, which may be picked up.
/obj/projectile/rogue_pve/arrow
	name = "arrow"
	icon = ROGUE_PVE_AMMO_ICON
	icon_state = "arrow_proj"
	damage_value = "pve_arrow_damage"
	armour_penetration = ROGUE_PEN_LIGHT
	sharpness = SHARP_POINTY
	hitsound = ROGUE_PVE_SOUND_ARROW_HIT
	drop_type = /obj/item/ammo_casing/caseless/rogue/arrow/stone

/obj/projectile/rogue_pve/arrow/Initialize(mapload)
	drop_chance = ROGUE_PVE_ARROW_RECOVER_CHANCE
	return ..()

/// Ratwood /obj/projectile/bullet/reusable/deepone: a stone the deep one spits.
/obj/projectile/rogue_pve/deepone_stone
	name = "stone"
	icon = ROGUE_PVE_NATURAL_ICON
	icon_state = "stone1"
	damage_value = "pve_deepone_stone_damage"
	armour_penetration = ROGUE_PEN_MEDIUM
	speed = 0.4
	hitsound = ROGUE_PVE_SOUND_ARROW_HIT
	drop_type = /obj/item/natural/stone
	drop_chance = 50

/// Ratwood /obj/projectile/magic/frostbolt of the deep one devout.
/obj/projectile/rogue_pve/frostbolt
	name = "frost bolt"
	icon_state = "ice_2"
	damage_value = "pve_frostbolt_damage"
	damage_type = BURN
	armor_flag = ENERGY
	speed = 1.25

/// Ratwood /obj/projectile/energy/rogue3 of the deep one devout: a slow spark that stops one in place.
/obj/projectile/rogue_pve/spark
	name = "spark"
	icon_state = "spark"
	damage_value = "pve_spark_damage"
	damage_type = BURN
	armor_flag = ENERGY
	speed = 0.3
	immobilize = 0.5 SECONDS

/// Ratwood /obj/projectile/magic/firebolt of the imp.
/obj/projectile/rogue_pve/firebolt
	name = "ball of fire"
	icon_state = "fireball"
	damage_value = "pve_firebolt_damage"
	damage_type = BURN
	armor_flag = FIRE
	speed = 0.8

/// Ratwood /obj/projectile/magic/aoe/fireball/rogue of the infernal watcher: burns around where it lands.
/obj/projectile/rogue_pve/fireball
	name = "fireball"
	icon_state = "fireball"
	damage_value = "pve_fireball_damage"
	damage_type = BURN
	armor_flag = FIRE
	speed = 0.4
	/// Fire stacks the one it hits catches.
	var/fire_stacks = 0

/obj/projectile/rogue_pve/fireball/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	var/turf/spot = get_turf(target)
	if(!spot)
		return
	new /obj/effect/temp_visual/rogue_pve_mark/strike(spot)
	var/splash = ROGUE_PVE_FIREBALL_SPLASH
	var/mob/living/caster = isliving(firer) ? firer : null
	for(var/mob/living/burnt in range(1, spot))
		if(burnt == target || !rogue_pve_is_foe(caster, burnt))
			continue
		burnt.apply_damage(splash, BURN, spread_damage = TRUE)
	if(fire_stacks && isliving(target) && blocked < 100)
		var/mob/living/victim = target
		victim.adjust_fire_stacks(fire_stacks)
		victim.ignite_mob()

/// Ratwood /obj/projectile/magic/aoe/fireball/rogue/great of the fiend: hits harder and sets its target alight.
/obj/projectile/rogue_pve/fireball/great
	name = "great fireball"
	damage_value = "pve_great_fireball_damage"
	fire_stacks = 2

/// Ratwood /obj/projectile/earthenchunk of the colossus: a slow lump of earth. Ratwood's "magic" armor flag has no TG
/// counterpart; ENERGY, as for the deep one devout's bolts. Ratwood's chance that the chunk breaks into elemental crawlers is
/// left out: the crawlers are not ported.
/obj/projectile/rogue_pve/earth_chunk
	name = "elemental chunk"
	icon = ROGUE_PVE_NATURAL_ICON
	icon_state = "stonebig1"
	damage_value = "pve_earth_chunk_damage"
	armor_flag = ENERGY
	range = 10
	speed = 0.25
	hitsound = ROGUE_PVE_SOUND_STONE_HIT

/// Ratwood /obj/projectile/bullet/spider of the mire lurker: a glob of web that holds its target, leaves it open to blows
/// and spins a thin web where it lands.
/obj/projectile/rogue_pve/web_glob
	name = "web glob"
	icon = ROGUE_PVE_WEB_ICON
	icon_state = "webglob"
	damage_value = "pve_web_glob_damage"
	speed = 0.6
	hitsound = ROGUE_PVE_SOUND_ARROW_HIT

/obj/projectile/rogue_pve/web_glob/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	if(isliving(target))
		var/mob/living/victim = target
		victim.rogue_open()
		victim.Immobilize(ROGUE_PVE_WEB_GLOB_HOLD)
	var/turf/spot = get_turf(target)
	if(spot && !isclosedturf(spot) && !(locate(/obj/structure/spider/stickyweb) in spot))
		new /obj/structure/spider/stickyweb/rogue_pve_mire(spot)
