/obj/effect/rockhill
	anchored = TRUE
	var/rockhill_particles

/obj/effect/rockhill/Initialize(mapload)
	. = ..()
	apply_rockhill_look()
	if(rockhill_particles)
		new /obj/effect/abstract/particle_holder(src, rockhill_particles)

/obj/effect/falling_sakura
	rockhill_particles = /particles/rockhill/sakura

/obj/effect/falling_maple
	rockhill_particles = /particles/rockhill/maple

/particles/rockhill/sakura
	icon = 'modular_redtard/rockhill/icons/effects/particles/particle.dmi'
	icon_state = "petals1"
	spin = 6
	position = generator(GEN_BOX, list(0, 32, 0), list(32, 48, 0))
	gravity = list(0, -1, 0.1)
	friction = 0.5
	drift = generator(GEN_CIRCLE, 1)
	lifespan = generator(GEN_NUM, 35, 55)
	fade = generator(GEN_NUM, 2, 6)
	spawning = 1
	count = 3
	width = 800
	height = 800

/particles/rockhill/maple
	icon = 'modular_redtard/rockhill/icons/effects/particles/particle.dmi'
	icon_state = list("leaf1" = 5, "leaf2" = 6, "leaf3" = 5)
	color = "#E23B1E"
	spin = generator(GEN_NUM, -8, 8)
	position = generator(GEN_BOX, list(0, 32, 0), list(32, 48, 0))
	gravity = list(0, -1, 0.1)
	friction = 0.5
	drift = generator(GEN_CIRCLE, 1)
	lifespan = generator(GEN_NUM, 35, 55)
	fade = generator(GEN_NUM, 2, 6)
	spawning = 1
	count = 3
	width = 800
	height = 800

/obj/effect/oneway/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	var/turf/here = get_turf(src)
	var/turf/from = get_turf(mover)
	return . && (here == from || get_dir(from, here) == dir)

/obj/effect/oneway/baroness/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/roguekey) || tool.lockid != "baroness")
		return ..()
	visible_message(span_boldannounce("The magical barrier disperses!"))
	qdel(src)
	return ITEM_INTERACT_SUCCESS
