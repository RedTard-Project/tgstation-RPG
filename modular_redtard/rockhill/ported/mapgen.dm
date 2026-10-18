/obj/effect/landmark/mapGenerator/rogue/bograt
	mapGeneratorType = /datum/map_generator/rockhill/bograt

/datum/map_generator_module/rockhill/bogratnospawnsgrass
	spawnableTurfs = list(/turf/open/floor/rogue/grass/nospawn = 30)
	allowed_turfs = list(/turf/open/floor/rogue/grass)
	allowed_areas = list(/area/rogue/outdoors/bograt)
	clusterCheckFlags = CLUSTER_CHECK_NONE
	clusterMin = 1
	clusterMax = 5
	include_subtypes = TRUE

/datum/map_generator_module/rockhill/bogratnospawnsdirt
	spawnableTurfs = list(/turf/open/floor/rogue/dirt/nospawn = 60)
	allowed_turfs = list(/turf/open/floor/rogue/dirt)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	allowed_areas = list(/area/rogue/outdoors/bograt)
	clusterCheckFlags = CLUSTER_CHECK_NONE
	clusterMin = 1
	clusterMax = 5
	include_subtypes = TRUE

/datum/map_generator_module/rockhill/bograt
	spawnableAtoms = list(/obj/structure/flora/newtree = 2, /obj/structure/flora/roguetree = 7, /obj/structure/flora/roguegrass/bush = 5, /obj/structure/flora/roguegrass = 8, /obj/structure/flora/roguegrass/maneater = 2, /obj/structure/flora/roguegrass/maneater/real/juvenile = 1, /obj/item/grown/log/tree/stick = 4, /obj/structure/flora/roguetree/stump/log = 3, /obj/structure/flora/roguetree/stump = 1.5, /obj/structure/glowshroom = 1, /obj/structure/flora/ausbushes/ppflowers = 0.4, /obj/structure/flora/ausbushes/ywflowers = 0.3, /obj/item/natural/stone = 3, /obj/item/natural/rock = 3, /obj/item/magic/artifact = 0.2, /obj/structure/leyline = 0.15, /obj/structure/voidstoneobelisk = 0.12, /obj/structure/flora/roguegrass/herb/manabloom = 0.3, /obj/item/magic/manacrystal = 0.3, /obj/structure/closet/crate/wooden/rockhill/dirthole/closed/loot = 1, /obj/structure/flora/roguegrass/swampweed = 1, /obj/structure/flora/roguegrass/herb/random = 4, /obj/structure/flora/rogueshroom = 1, /obj/effect/decal/remains/bear = 0.5, /obj/structure/deadbodyrandom/low = 0.2)
	spawnableTurfs = list(/turf/open/floor/rogue/dirt/road = 2, /turf/open/water/swamp = 2)
	allowed_turfs = list(/turf/open/floor/rogue/dirt, /turf/open/floor/rogue/grass, /turf/open/floor/rogue/grasscold, /turf/open/floor/rogue/grassgrey, /turf/open/floor/rogue/grassred, /turf/open/floor/rogue/grassyel)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/nospawn, /turf/open/floor/rogue/dirt/road, /turf/open/floor/rogue/grass/nospawn)
	allowed_areas = list(/area/rogue/outdoors/bograt)
	clusterCheckFlags = CLUSTER_CHECK_NONE
	clusterMin = 1
	clusterMax = 5
	include_subtypes = TRUE

/datum/map_generator_module/rockhill/bogratroad
	spawnableAtoms = list(/obj/item/natural/stone = 6, /obj/item/grown/log/tree/stick = 5)
	allowed_turfs = list(/turf/open/floor/rogue/dirt/road)
	allowed_areas = list(/area/rogue/outdoors/bograt)
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	clusterMin = 1
	clusterMax = 5
	include_subtypes = TRUE

/datum/map_generator_module/rockhill/bogratsand
	spawnableAtoms = list(/obj/item/natural/stone = 10, /obj/item/grown/log/tree/stick = 10, /obj/item/reagent_containers/food/snacks/fish/crab = 1, /obj/item/reagent_containers/food/snacks/fish/lobster = 1, /obj/item/reagent_containers/food/snacks/fish/oyster = 2)
	allowed_turfs = list(/turf/open/floor/rogue/AzureSand)
	allowed_areas = list(/area/rogue/outdoors/bograt)
	clusterCheckFlags = CLUSTER_CHECK_NONE
	clusterMin = 1
	clusterMax = 5
	include_subtypes = TRUE

/datum/map_generator_module/rockhill/bogratmire
	spawnableAtoms = list(/obj/structure/glowshroom = 2, /obj/structure/flora/rogueshroom/unhappy/random = 4, /obj/structure/flora/roguetree = 4, /obj/structure/flora/roguegrass/bush = 5, /obj/structure/flora/roguegrass = 10, /obj/structure/flora/roguegrass/maneater = 2, /obj/structure/flora/roguegrass/maneater/real/juvenile = 2, /obj/item/natural/stone = 10, /obj/item/natural/rock = 5, /obj/item/grown/log/tree/stick = 5, /obj/item/magic/artifact = 0.5, /obj/structure/leyline = 0.5, /obj/structure/voidstoneobelisk = 1, /obj/structure/flora/roguegrass/herb/manabloom = 1, /obj/item/magic/manacrystal = 1, /obj/structure/flora/roguetree/stump/log = 5, /obj/structure/flora/roguetree/stump = 5, /obj/structure/closet/crate/wooden/rockhill/dirthole/closed/loot = 2, /obj/structure/flora/roguegrass/swampweed = 4, /obj/structure/flora/roguegrass/herb/random = 6, /obj/structure/flora/rogueshroom = 3, /obj/effect/decal/remains/bear = 2, /obj/effect/decal/remains/human = 2, /obj/structure/flora/mushroomcluster/unhappy = 2, /obj/structure/flora/tinymushrooms/unhappy = 2, /obj/structure/deadbodyrandom/med = 0.3, /obj/structure/zizo_bane = 3)
	spawnableTurfs = list(/turf/open/floor/rogue/dirt/road = 3, /turf/open/water/swamp = 3)
	allowed_turfs = list(/turf/open/floor/rogue/dirt, /turf/open/floor/rogue/grassgrey)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	allowed_areas = list(/area/rogue/outdoors/bograt/sunken)
	clusterCheckFlags = CLUSTER_CHECK_NONE
	clusterMin = 1
	clusterMax = 5
	include_subtypes = TRUE

/datum/map_generator_module/rockhill/bogratwater
	spawnableAtoms = list(/obj/structure/glowshroom = 5, /obj/item/restraints/legcuffs/beartrap/armed = 1, /obj/structure/flora/roguetree/stump/log = 10, /obj/structure/flora/roguetree = 10, /obj/structure/flora/roguegrass/reedbush = 20, /obj/structure/flora/roguegrass/water/reeds = 20, /obj/structure/zizo_bane = 2)
	allowed_turfs = list(/turf/open/water/swamp)
	excluded_turfs = list(/turf/open/water/swamp/deep)
	allowed_areas = list(/area/rogue/outdoors/bograt)
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	clusterMin = 1
	clusterMax = 5
	include_subtypes = TRUE

/datum/map_generator/rockhill/bograt
	modules = list(/datum/map_generator_module/rockhill/bogratnospawnsgrass, /datum/map_generator_module/rockhill/bogratnospawnsdirt, /datum/map_generator_module/rockhill/bograt, /datum/map_generator_module/rockhill/bogratroad, /datum/map_generator_module/rockhill/bogratsand, /datum/map_generator_module/rockhill/bogratmire, /datum/map_generator_module/rockhill/bogratwater)

/obj/effect/landmark/mapGenerator/rogue/decap
	mapGeneratorType = /datum/map_generator/rockhill/decap

/datum/map_generator_module/rockhill/decapsnow
	spawnableAtoms = list(/obj/structure/flora/grass/both = 15, /obj/structure/flora/grass/brown = 20, /obj/structure/flora/grass/green = 20, /obj/item/grown/log/tree/stick = 16, /obj/structure/flora/roguegrass/pyroclasticflowers = 3, /obj/structure/flora/roguegrass/maneater/real/juvenile = 3, /obj/structure/flora/roguegrass/herb/random = 5)
	spawnableTurfs = list(/turf/open/floor/rogue/snowpatchy = 15)
	allowed_turfs = list(/turf/open/floor/rogue/snow, /turf/open/floor/rogue/snowpatchy, /turf/open/floor/rogue/snowrough)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	allowed_areas = list(/area/rogue/outdoors/mountains/decap)
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	clusterMin = 1
	clusterMax = 5
	include_subtypes = TRUE

/datum/map_generator_module/rockhill/decaproad
	spawnableAtoms = list(/obj/item/natural/stone = 15, /obj/item/natural/rock = 3, /obj/item/grown/log/tree/stick = 6)
	allowed_turfs = list(/turf/open/floor/rogue/dirt/road)
	allowed_areas = list(/area/rogue/outdoors/mountains/decap)
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	clusterMin = 1
	clusterMax = 5
	include_subtypes = TRUE

/datum/map_generator_module/rockhill/decapgrass
	spawnableAtoms = list(/obj/structure/flora/roguegrass = 25, /obj/structure/flora/roguegrass/herb/random = 2, /obj/structure/flora/roguegrass/bush/westleach = 2, /obj/item/natural/stone = 6, /obj/item/natural/rock = 1, /obj/item/grown/log/tree/stick = 3)
	allowed_turfs = list(/turf/open/floor/rogue/grass, /turf/open/floor/rogue/grasscold, /turf/open/floor/rogue/grassred, /turf/open/floor/rogue/grassyel)
	allowed_areas = list(/area/rogue/outdoors/mountains/decap)
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	clusterMin = 1
	clusterMax = 5
	include_subtypes = TRUE

/datum/map_generator/rockhill/decap
	modules = list(/datum/map_generator_module/rockhill/decapsnow, /datum/map_generator_module/rockhill/decaproad, /datum/map_generator_module/rockhill/decapgrass)

/obj/effect/landmark/mapGenerator/rogue/forestrat
	mapGeneratorType = /datum/map_generator/rockhill/forestrat

/datum/map_generator_module/rockhill/forestratnospawngrass
	spawnableTurfs = list(/turf/open/floor/rogue/grass/nospawn = 20)
	allowed_turfs = list(/turf/open/floor/rogue/grass)
	allowed_areas = list(/area/rogue/outdoors/woodsrat)
	clusterCheckFlags = CLUSTER_CHECK_NONE
	clusterMin = 1
	clusterMax = 5
	include_subtypes = TRUE

/datum/map_generator_module/rockhill/forestratnospawndirt
	spawnableTurfs = list(/turf/open/floor/rogue/dirt/nospawn = 20)
	allowed_turfs = list(/turf/open/floor/rogue/dirt)
	allowed_areas = list(/area/rogue/outdoors/woodsrat)
	clusterCheckFlags = CLUSTER_CHECK_NONE
	clusterMin = 1
	clusterMax = 5
	include_subtypes = TRUE

/datum/map_generator_module/rockhill/forestrat
	spawnableAtoms = list(/obj/structure/flora/newtree = 1, /obj/structure/flora/roguetree/wise = 0.4, /obj/structure/flora/roguetree = 8, /obj/structure/flora/roguegrass/bush = 5, /obj/structure/flora/roguegrass = 10, /obj/structure/flora/roguegrass/herb/random = 3, /obj/structure/flora/roguegrass/bush/westleach = 2, /obj/structure/flora/roguegrass/maneater = 3, /obj/structure/flora/ausbushes/ppflowers = 0.4, /obj/structure/flora/ausbushes/ywflowers = 0.4, /obj/item/natural/stone = 3, /obj/item/natural/rock = 3, /obj/item/grown/log/tree/stick = 3, /obj/structure/flora/roguetree/stump/log = 3, /obj/structure/flora/roguetree/stump = 1, /obj/structure/closet/crate/wooden/rockhill/dirthole/closed/loot = 1, /obj/structure/flora/roguegrass/maneater/real/juvenile = 1, /obj/structure/deadbodyrandom/low = 0.2, /obj/item/reagent_containers/food/snacks/smallrat = 0.3)
	spawnableTurfs = list(/turf/open/floor/rogue/dirt/road = 2, /turf/open/water/swamp = 1)
	allowed_turfs = list(/turf/open/floor/rogue/dirt, /turf/open/floor/rogue/grass, /turf/open/floor/rogue/grasscold, /turf/open/floor/rogue/grassgrey, /turf/open/floor/rogue/grassred, /turf/open/floor/rogue/grassyel)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/nospawn, /turf/open/floor/rogue/dirt/road, /turf/open/floor/rogue/grass/nospawn)
	allowed_areas = list(/area/rogue/outdoors/woodsrat)
	clusterCheckFlags = CLUSTER_CHECK_NONE
	clusterMin = 1
	clusterMax = 5
	include_subtypes = TRUE

/datum/map_generator_module/rockhill/forestratroad
	spawnableAtoms = list(/obj/item/natural/stone = 9, /obj/item/grown/log/tree/stick = 6)
	allowed_turfs = list(/turf/open/floor/rogue/dirt/road)
	allowed_areas = list(/area/rogue/outdoors/woodsrat)
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	clusterMin = 1
	clusterMax = 5
	include_subtypes = TRUE

/datum/map_generator_module/rockhill/forestratyellow
	spawnableAtoms = list(/obj/structure/flora/roguegrass/pyroclasticflowers = 1.5, /obj/structure/flora/ausbushes/ppflowers = 0.7, /obj/structure/flora/ausbushes/ywflowers = 0.7)
	allowed_turfs = list(/turf/open/floor/rogue/grassred, /turf/open/floor/rogue/grassyel)
	allowed_areas = list(/area/rogue/outdoors/woodsrat)
	clusterCheckFlags = CLUSTER_CHECK_NONE
	clusterMin = 1
	clusterMax = 5
	include_subtypes = TRUE

/datum/map_generator/rockhill/forestrat
	modules = list(/datum/map_generator_module/rockhill/forestratnospawngrass, /datum/map_generator_module/rockhill/forestratnospawndirt, /datum/map_generator_module/rockhill/forestrat, /datum/map_generator_module/rockhill/forestratroad, /datum/map_generator_module/rockhill/forestratyellow)

/obj/effect/landmark/mapGenerator/rogue/roguetownfield
	mapGeneratorType = /datum/map_generator/rockhill/roguetownfield

/datum/map_generator_module/rockhill/grass
	spawnableAtoms = list(/obj/structure/flora/roguegrass/pumpkin = 1)
	spawnableTurfs = list(/turf/open/floor/rogue/grass = 15)
	allowed_turfs = list(/turf/open/floor/rogue/dirt)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	allowed_areas = list(/area/rogue/outdoors/rtfield)
	clusterCheckFlags = CLUSTER_CHECK_NONE
	clusterMin = 1
	clusterMax = 5
	include_subtypes = TRUE

/datum/map_generator_module/rockhill/roguetowngrass
	spawnableAtoms = list(/obj/structure/flora/roguegrass = 40, /obj/structure/flora/roguegrass/maneater = 7, /obj/item/natural/stone = 10, /obj/item/grown/log/tree/stick = 3)
	allowed_turfs = list(/turf/open/floor/rogue/dirt, /turf/open/floor/rogue/grass, /turf/open/floor/rogue/grasscold, /turf/open/floor/rogue/grassred, /turf/open/floor/rogue/grassyel)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	allowed_areas = list(/area/rogue/outdoors/rtfield, /area/rogue/outdoors/town)
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	clusterMin = 1
	clusterMax = 5
	include_subtypes = TRUE

/datum/map_generator_module/rockhill/roguetownfield
	spawnableAtoms = list(/obj/structure/flora/newtree = 5, /obj/structure/flora/roguegrass/bush = 13, /obj/structure/flora/roguegrass = 40, /obj/structure/flora/roguegrass/maneater = 16, /obj/item/natural/stone = 18, /obj/item/natural/rock = 2, /obj/item/grown/log/tree/stick = 3, /obj/structure/closet/crate/wooden/rockhill/dirthole/closed/loot = 3, /obj/structure/flora/roguegrass/pyroclasticflowers = 3)
	spawnableTurfs = list(/turf/open/floor/rogue/dirt/road = 5)
	allowed_turfs = list(/turf/open/floor/rogue/dirt)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	allowed_areas = list(/area/rogue/outdoors/rtfield)
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	clusterMin = 1
	clusterMax = 5
	include_subtypes = TRUE

/datum/map_generator_module/rockhill/road
	spawnableAtoms = list(/obj/item/natural/stone = 18, /obj/item/grown/log/tree/stick = 3)
	spawnableTurfs = list(/turf/open/floor/rogue/dirt/road = 5)
	allowed_turfs = list(/turf/open/floor/rogue/dirt/road)
	allowed_areas = list(/area/rogue/outdoors/rtfield)
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	clusterMin = 1
	clusterMax = 5
	include_subtypes = TRUE

/datum/map_generator/rockhill/roguetownfield
	modules = list(/datum/map_generator_module/rockhill/grass, /datum/map_generator_module/rockhill/roguetowngrass, /datum/map_generator_module/rockhill/roguetownfield, /datum/map_generator_module/rockhill/road)

/obj/effect/landmark/mapGenerator/rogue/underdarkrat
	mapGeneratorType = /datum/map_generator/rockhill/underdarkrat

/datum/map_generator_module/rockhill/underdarkratstone
	spawnableAtoms = list(/obj/structure/flora/tinymushrooms = 20, /obj/structure/roguerock = 25, /obj/item/natural/rock = 25, /obj/structure/vine = 5)
	allowed_turfs = list(/turf/open/floor/rogue/naturalstone)
	allowed_areas = list(/area/rogue/under/underdark)
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	clusterMin = 1
	clusterMax = 5
	include_subtypes = TRUE

/datum/map_generator_module/rockhill/underdarkratmud
	spawnableAtoms = list(/obj/structure/flora/mushroomcluster = 20, /obj/structure/flora/roguegrass/thorn_bush = 10, /obj/structure/flora/rogueshroom/happy/random = 40, /obj/structure/flora/rogueshroom = 20, /obj/structure/flora/tinymushrooms = 20, /obj/structure/flora/roguegrass = 30, /obj/structure/flora/roguegrass/herb/random = 5)
	allowed_turfs = list(/turf/open/floor/rogue/dirt, /turf/open/floor/rogue/grasscold, /turf/open/floor/rogue/grasspurple)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	allowed_areas = list(/area/rogue/under/underdark)
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	clusterMin = 1
	clusterMax = 5
	include_subtypes = TRUE

/datum/map_generator_module/rockhill/underdarkratscarymud
	spawnableAtoms = list(/obj/structure/flora/mushroomcluster = 20, /obj/structure/flora/roguegrass/thorn_bush = 10, /obj/structure/flora/rogueshroom/unhappy/random = 30, /obj/structure/flora/rogueshroom/happy/random = 1, /obj/structure/flora/mushroomcluster/unhappy = 20, /obj/structure/flora/tinymushrooms/unhappy = 20, /obj/structure/glowshroom = 2, /obj/structure/zizo_bane = 2, /obj/structure/flora/roguegrass = 30, /obj/structure/flora/roguegrass/herb/random = 5)
	spawnableTurfs = list(/turf/open/floor/rogue/grasspurple = 2)
	allowed_turfs = list(/turf/open/floor/rogue/dirt, /turf/open/floor/rogue/grasscold, /turf/open/floor/rogue/grasspurple)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	allowed_areas = list(/area/rogue/under/underdarker)
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	clusterMin = 1
	clusterMax = 5
	include_subtypes = TRUE

/datum/map_generator_module/rockhill/underdarkratscarystone
	spawnableAtoms = list(/obj/structure/flora/rogueshroom/unhappy/random = 30, /obj/structure/flora/rogueshroom/happy/random = 1, /obj/structure/flora/mushroomcluster/unhappy = 20, /obj/structure/flora/tinymushrooms/unhappy = 20, /obj/structure/roguerock = 25, /obj/item/natural/rock = 25, /obj/structure/vine = 5)
	allowed_turfs = list(/turf/open/floor/rogue/grasspurple, /turf/open/floor/rogue/naturalstone)
	allowed_areas = list(/area/rogue/under/underdarker)
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	clusterMin = 1
	clusterMax = 5
	include_subtypes = TRUE

/datum/map_generator/rockhill/underdarkrat
	modules = list(/datum/map_generator_module/rockhill/underdarkratstone, /datum/map_generator_module/rockhill/underdarkratmud, /datum/map_generator_module/rockhill/underdarkratscarymud, /datum/map_generator_module/rockhill/underdarkratscarystone)
