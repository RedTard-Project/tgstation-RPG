/area/rogue
	parent_type = /area/station
	name = "Rockhill"
	requires_power = FALSE

/area/rogue/outdoors
	outdoors = TRUE
	static_lighting = FALSE
	base_lighting_alpha = 255

/turf/open/floor/rockhill
	name = "ground"
	smoothing_groups = null
	canSmoothWith = null
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	init_air = FALSE

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

/turf/open/water/rockhill/Initialize(mapload)
	. = ..()
	for(var/layer_state in list("bottom", "top"))
		var/mutable_appearance/water = mutable_appearance('modular_redtard/rockhill/icons/turf/newwater.dmi', "[layer_state][rockhill_water_level]")
		water.color = rockhill_water_color
		add_overlay(water)

/turf/closed/rockhill
	name = "rock"
	icon = 'modular_redtard/rockhill/icons/turf/roguewall.dmi'
	icon_state = ""
	smoothing_flags = NONE
	smoothing_groups = null
	canSmoothWith = null

/obj/structure/rockhill
	anchored = TRUE
	density = FALSE

/obj/structure/rockhill/window
	density = TRUE

/obj/structure/rockhill/light

/obj/item/rockhill
	name = "item"

/obj/effect/spawner/random/rockhill
	name = "rockhill loot"

/mob/living/basic/rockhill
	name = "creature"
	faction = list(FACTION_HOSTILE)
	gold_core_spawnable = NO_SPAWN
