/obj/effect/spawner/random/rockhill/trap
	name = "random trap"
	spawn_loot_chance = 50
	loot = list(
		/obj/structure/trap/curse = 2,
		/obj/structure/trap/curse/hidden = 1,
		/obj/structure/trap/flame = 1,
		/obj/structure/trap/shock = 1,
		/obj/structure/trap/bomb = 1,
		/obj/structure/trap/rock_fall = 1,
		/obj/structure/trap/saw_blades = 1,
		/obj/structure/trap/wall_projectile = 1,
		/obj/structure/trap/wall_projectile/acidsplash = 1,
		/obj/structure/trap/wall_projectile/frostbolt = 1,
		/obj/structure/trap/water = 1,
	)

/obj/effect/spawner/random/rockhill/mirespider
	name = "random spider spawner"
	loot = list(
		/mob/living/simple_animal/hostile/rogue/mirespider_paralytic = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/mirespider = 90,
	)
