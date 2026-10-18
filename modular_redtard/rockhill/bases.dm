/atom
	var/rockhill_random_dir = FALSE
	var/rockhill_variant
	var/rockhill_variant_min = 1
	var/rockhill_variant_max = 1
	var/rockhill_overlay

/atom/proc/apply_rockhill_look()
	if(rockhill_random_dir)
		setDir(pick(GLOB.cardinals))
	if(rockhill_variant && icon_state == initial(icon_state))
		icon_state = replacetext(rockhill_variant, "#", "[rand(rockhill_variant_min, rockhill_variant_max)]")
	if(rockhill_overlay)
		add_overlay(mutable_appearance(icon, rockhill_overlay))

/area/rogue
	parent_type = /area/station
	name = "Rockhill"
	requires_power = FALSE
	ambient_buzz = null
	var/rockhill_sunlit = FALSE

/area/rogue/Initialize(mapload)
	. = ..()
	rockhill_refresh_oneshots()

/turf/open/floor/rockhill
	name = "ground"
	smoothing_groups = null
	canSmoothWith = null
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	init_air = FALSE

/turf/open/floor/rockhill/Initialize(mapload)
	. = ..()
	apply_rockhill_look()

/turf/open/openspace/rockhill
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	init_air = FALSE

/turf/open/water/rockhill
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	icon_state = "together"
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	init_air = FALSE
	var/rockhill_water_level = 2
	var/rockhill_water_color = "#6a9295"
	var/rockhill_flow = FALSE

/turf/open/water/rockhill/Initialize(mapload)
	. = ..()
	apply_rockhill_look()
	for(var/layer_state in list("bot", "top"))
		var/mutable_appearance/water = mutable_appearance('modular_redtard/rockhill/icons/turf/newwater.dmi', rockhill_flow ? "river[layer_state]" : "[layer_state == "bot" ? "bottom" : "top"][rockhill_water_level]")
		water.color = rockhill_water_color
		water.dir = dir
		add_overlay(water)

/turf/closed/rockhill
	name = "rock"
	icon = 'modular_redtard/rockhill/icons/turf/roguewall.dmi'
	icon_state = ""
	smoothing_flags = NONE
	smoothing_groups = null
	canSmoothWith = null

/turf/closed/rockhill/Initialize(mapload)
	. = ..()
	apply_rockhill_look()

/obj/structure/rockhill
	anchored = TRUE
	density = FALSE
	var/list/rockhill_random_pick

/obj/structure/rockhill/Initialize(mapload)
	. = ..()
	if(length(rockhill_random_pick))
		var/picked = pick(rockhill_random_pick)
		var/atom/movable/spawned = new picked(loc)
		spawned.pixel_x += rand(-3, 3)
		return INITIALIZE_HINT_QDEL
	apply_rockhill_look()
	register_redstone()

/obj/structure/rockhill/Destroy()
	unregister_redstone()
	return ..()

/obj/structure/rockhill/flaps
	name = "iron bars"
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "bars_passage"
	layer = ABOVE_MOB_LAYER
	can_atmos_pass = ATMOS_PASS_NO

/obj/structure/rockhill/window
	density = TRUE

/obj/structure/rockhill/light

/obj/item/rockhill
	name = "item"

/obj/item/clothing/under/roguetown
	female_sprite_flags = NO_FEMALE_UNIFORM

/obj/effect/spawner/random/rockhill
	name = "rockhill loot"

/mob/living/basic/rockhill
	name = "creature"
	faction = list(FACTION_HOSTILE)
	gold_core_spawnable = NO_SPAWN
