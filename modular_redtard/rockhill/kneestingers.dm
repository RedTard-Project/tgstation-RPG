/mob/living/var/rockhill_kneestinger_time = -ROCKHILL_KNEESTINGER_RESHOCK

/obj/structure/rockhill/kneestinger
	name = "kneestingers"
	desc = "Deceptively-delicate stalks sprout from the ground in luminous-green repose. Some scholars claim they're not really a fungus, even if the Dendorites insist otherwise. Either way they hurt like hell."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliage.dmi'
	icon_state = "glowshroom1"
	layer = BELOW_OBJ_LAYER
	obj_flags = CAN_BE_HIT
	max_integrity = 30
	resistance_flags = FLAMMABLE
	light_range = 2
	light_power = 1.5
	light_color = "#d4fcac"

/obj/structure/rockhill/kneestinger/Initialize(mapload)
	. = ..()
	icon_state = "glowshroom[rand(1, ROCKHILL_KNEESTINGER_STATES)]"
	pixel_x = rand(-ROCKHILL_KNEESTINGER_SHIFT_X, ROCKHILL_KNEESTINGER_SHIFT_X)
	pixel_y = rand(0, ROCKHILL_KNEESTINGER_SHIFT_Y)
	var/static/list/loc_connections = list(COMSIG_ATOM_ENTERED = PROC_REF(on_entered))
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/rockhill/kneestinger/proc/blocks(atom/movable/mover)
	if(!isliving(mover) || mover.z != z)
		return FALSE
	if(HAS_TRAIT(mover, TRAIT_KNEESTINGER_IMMUNITY))
		return FALSE
	return !(mover.movement_type & MOVETYPES_NOT_TOUCHING_GROUND)

/obj/structure/rockhill/kneestinger/proc/stings(mob/living/victim)
	if(!blocks(victim))
		return FALSE
	if(victim.mind && (!victim.client || victim.client.inactivity > ROCKHILL_KNEESTINGER_IDLE))
		return FALSE
	return TRUE

/obj/structure/rockhill/kneestinger/proc/zap(mob/living/victim)
	victim.throwing?.finalize(FALSE)
	var/damage = world.time < victim.rockhill_kneestinger_time + ROCKHILL_KNEESTINGER_RESHOCK ? ROCKHILL_KNEESTINGER_DAMAGE / 2 : ROCKHILL_KNEESTINGER_DAMAGE
	if(!victim.electrocute_act(damage, src))
		return FALSE
	victim.rockhill_kneestinger_time = world.time
	victim.emote("scream")
	return TRUE

/obj/structure/rockhill/kneestinger/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(blocks(mover))
		return FALSE

/obj/structure/rockhill/kneestinger/Bumped(atom/movable/bumped_atom)
	. = ..()
	if(!stings(bumped_atom))
		return
	var/mob/living/victim = bumped_atom
	var/away = get_dir(src, victim)
	if(!zap(victim))
		return
	take_damage(ROCKHILL_KNEESTINGER_DAMAGE)
	if(victim.stat == STABLE && !QDELETED(victim))
		victim.throw_at(get_step(victim, away), pick(1, ROCKHILL_KNEESTINGER_THROW), 1, victim, spin = FALSE)

/obj/structure/rockhill/kneestinger/proc/on_entered(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER
	if(arrived != src && stings(arrived))
		INVOKE_ASYNC(src, PROC_REF(zap), arrived)

/obj/structure/rockhill/kneestinger/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(isliving(user) && user.z == z && (attacking_item.obj_flags & CONDUCTS_ELECTRICITY))
		var/mob/living/fool = user
		if(fool.electrocute_act(ROCKHILL_KNEESTINGER_DAMAGE, src))
			fool.emote("scream")
			fool.throwing?.finalize(FALSE)
			return TRUE
	return ..()

/obj/structure/rockhill/kneestinger/fire_act(exposed_temperature, exposed_volume)
	visible_message(span_warning("[src] catches fire!"))
	qdel(src)

/obj/structure/rockhill/kneestinger/acid_act(acidpwr, acid_volume)
	visible_message(span_danger("[src] melts away!"))
	var/obj/effect/decal/cleanable/molten_object/remains = new(get_turf(src))
	remains.desc = ""
	qdel(src)
	return TRUE
