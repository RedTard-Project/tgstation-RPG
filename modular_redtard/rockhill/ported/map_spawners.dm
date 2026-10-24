/obj/effect/spawner/roguemap
	parent_type = /obj/effect/spawner/random/rockhill

/obj/effect/spawner/roguemap/beartrap
	name = "beartrap"
	loot = list(/obj/item/restraints/legcuffs/beartrap/armed/camouflage)
	spawn_loot_chance = 50

/obj/effect/spawner/roguemap/hauntpile
	name = "hauntpile"
	loot = list(/obj/structure/bonepile)
	spawn_loot_chance = 23

/obj/effect/spawner/roguemap/stump
	name = "stump spawner"
	loot = list(/obj/structure/flora/roguetree/stump)
	spawn_loot_chance = 75

/obj/effect/spawner/roguemap/treeorbush
	name = "Tree or bush spawner"
	loot = list(/obj/structure/flora/roguetree, /obj/structure/flora/roguegrass/bush)
	spawn_loot_chance = 50

/obj/effect/spawner/roguemap/treeorstump
	name = "Tree or stump spawner"
	loot = list(/obj/structure/flora/roguetree, /obj/structure/flora/roguetree/stump)
	spawn_loot_chance = 50
