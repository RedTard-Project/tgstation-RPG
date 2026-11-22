/// B12b: Ratwood's chest mimic (creacher/mimic.dm, datums/ai/controllers/mimic.dm). It sits as a plain wooden chest, with the
/// chest's name, look and description, and does not move. Whoever comes within a few steps, touches it, drags it or strikes it
/// finds it out: it opens its maw and goes for them, and once the fight is over it settles down as a chest again. What lay on
/// its spot when the map was made is inside it and falls out when it dies.

/mob/living/simple_animal/hostile/retaliate/rogue/mimic
	/// It goes for whoever finds it out (Ratwood: Aggro() makes it aggressive).
	rogue_aggressive = TRUE
	/// Something to be shown while it lies in wait (rogue_lie_in_wait() of ai/vibelin_beasts.dm needs one): the chest itself.
	rogue_hide_state = "chest"
	/// The chest it passes for (Ratwood mimicking_chest).
	var/obj/structure/rogue_pve_chest_type = /obj/structure/closet/crate/wooden/rockhill/crate/chest
	/// It passes for a chest right now.
	var/rogue_pve_disguised = FALSE

/mob/living/simple_animal/hostile/retaliate/rogue/mimic/Initialize(mapload)
	. = ..()
	if(!rogue_combat_enabled())
		return
	if(mapload)
		for(var/obj/item/loot in loc)
			loot.forceMove(src)
	RegisterSignal(src, COMSIG_ATOM_ATTACK_HAND, PROC_REF(rogue_pve_on_touched))
	RegisterSignal(src, COMSIG_LIVING_GET_PULLED, PROC_REF(rogue_pve_on_pulled))
	RegisterSignal(src, COMSIG_ATOM_WAS_ATTACKED, PROC_REF(rogue_pve_on_attacked))
	rogue_hide()

/// Ratwood: its mind waits as a chest before it fights (lie in wait among its pastimes, after eating the dead).
/mob/living/simple_animal/hostile/retaliate/rogue/mimic/rogue_pve_idle_roots(hunts)
	. = ..()
	. += /datum/bt_node/subtree/rogue_lie_in_wait

/// Ratwood disguise().
/mob/living/simple_animal/hostile/retaliate/rogue/mimic/rogue_hide()
	if(stat != STABLE || !rogue_combat_enabled())
		return
	rogue_pve_disguised = TRUE
	name = initial(rogue_pve_chest_type.name)
	icon = initial(rogue_pve_chest_type.icon)
	icon_state = initial(rogue_pve_chest_type.icon_state)

/// Ratwood undisguise(): mask off.
/mob/living/simple_animal/hostile/retaliate/rogue/mimic/rogue_ambush()
	if(!rogue_pve_disguised)
		return
	rogue_pve_disguised = FALSE
	name = "\improper MIMIC"
	icon = initial(icon)
	icon_state = stat == DEAD ? icon_dead : icon_living

/// Found out: it goes for whoever did it.
/mob/living/simple_animal/hostile/retaliate/rogue/mimic/proc/rogue_pve_found_out(mob/living/finder)
	if(stat == DEAD || !isliving(finder) || finder == src)
		return
	rogue_ambush()
	ai_controller?.set_blackboard_key(BB_CURRENT_TARGET, finder)

/mob/living/simple_animal/hostile/retaliate/rogue/mimic/proc/rogue_pve_on_touched(datum/source, mob/user, list/modifiers)
	SIGNAL_HANDLER
	rogue_pve_found_out(user)

/mob/living/simple_animal/hostile/retaliate/rogue/mimic/proc/rogue_pve_on_pulled(datum/source, mob/living/puller)
	SIGNAL_HANDLER
	rogue_pve_found_out(puller)

/mob/living/simple_animal/hostile/retaliate/rogue/mimic/proc/rogue_pve_on_attacked(datum/source, atom/attacker, attack_flags)
	SIGNAL_HANDLER
	rogue_pve_found_out(attacker)

/// Ratwood examine(): while disguised it reads as the chest it passes for.
/mob/living/simple_animal/hostile/retaliate/rogue/mimic/examine(mob/user)
	if(!rogue_pve_disguised)
		return ..()
	. = list("This is \a [name].")
	var/chest_desc = initial(rogue_pve_chest_type.desc)
	if(chest_desc)
		. += span_info(chest_desc)

/// Ratwood death(): its loot falls out.
/mob/living/simple_animal/hostile/retaliate/rogue/mimic/death(gibbed)
	rogue_ambush()
	var/turf/spot = drop_location()
	for(var/obj/item/loot in src)
		loot.forceMove(spot)
	return ..()
