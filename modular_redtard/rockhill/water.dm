/datum/controller/global_vars/InitGlobalimmerse_ignored_movable()
	..()
	immerse_ignored_movable += typecacheof(list(
		/obj/structure/bed/rockhill,
		/obj/structure/chair/wood/rockhill,
		/obj/structure/closet/crate/wooden/rockhill,
		/obj/structure/ladder/rockhill,
		/obj/structure/mineral_door/rockhill,
		/obj/structure/rack/rockhill,
		/obj/structure/rockhill,
		/obj/structure/table/wood/rockhill,
	))

/turf/open/lava/rockhill/burn_stuff(atom/movable/to_burn, seconds_per_tick = 1)
	if(to_burn && SSatoms.initialized == INITIALIZATION_INNEW_MAPLOAD)
		return FALSE
	return ..()
