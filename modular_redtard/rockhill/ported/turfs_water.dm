/turf/open/water/bath
	parent_type = /turf/open/water/rockhill
	name = "water"
	desc = "Soothing water, with soapy bubbles on the surface."
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	rockhill_water_level = 2
	rockhill_water_color = "#FFFFFF"
	icon_state = "bathtile"
	smoothing_flags = SMOOTH_BITMASK_CARDINALS

/turf/open/water/bath/fakepond
	name = "fake pond"
	desc = "Soothing water, with soapy bubbles on the surface. Dyed to perfection."
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	rockhill_water_level = 2
	rockhill_water_color = "#26aa98"
	icon_state = "bathtile"
	smoothing_flags = SMOOTH_BITMASK_CARDINALS

/turf/open/water/cleanshallow
	parent_type = /turf/open/water/rockhill
	name = "water"
	desc = "Clear and shallow water, what a blessing!"
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	rockhill_water_level = 2
	rockhill_water_color = "#6a9295"
	icon_state = "rock"
	rockhill_random_dir = TRUE
	smoothing_flags = SMOOTH_BITMASK_CARDINALS

/turf/open/water/ocean
	parent_type = /turf/open/water/rockhill
	name = "salt water"
	desc = "The waves lap at the coast, hungry to swallow the land. Doesn't look too deep."
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	icon_state = "ash"
	rockhill_water_level = 2
	rockhill_water_color = "#3e7459"
	smoothing_flags = SMOOTH_BITMASK_CARDINALS

/turf/open/water/ocean/deep
	name = "salt water"
	desc = "Deceptively deep, be careful not to find yourself this far out."
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	icon_state = "water"
	rockhill_water_level = 3
	rockhill_water_color = "#3e7459"
	smoothing_flags = SMOOTH_BITMASK_CARDINALS

/turf/open/water/ocean/deep/thermalwater
	name = "healing hot spring"
	desc = "A warm spring with gentle ripples. Standing here soothes your body."
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	icon_state = "together"
	rockhill_water_level = 3
	rockhill_water_color = "#23b9df"
	smoothing_flags = SMOOTH_BITMASK_CARDINALS

/turf/open/water/pond
	parent_type = /turf/open/water/rockhill
	name = "pond"
	desc = "Still and alarmingly idyllic water. Covered in concerning overgrowth of duckweed."
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	icon_state = "pond"
	rockhill_water_level = 3
	rockhill_water_color = "#367e94"
	smoothing_flags = SMOOTH_BITMASK_CARDINALS

/turf/open/water/river
	parent_type = /turf/open/water/rockhill
	name = "river"
	desc = "A river of crystal clear water flows swiftly along the contours of the land."
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	rockhill_water_level = 3
	rockhill_water_color = "#6a9295"
	rockhill_flow = TRUE
	icon_state = "rock"
	smoothing_flags = SMOOTH_BITMASK_CARDINALS

/turf/open/water/river/flow
	name = "river"
	desc = "A river of crystal clear water flows swiftly along the contours of the land."
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	rockhill_water_level = 3
	rockhill_water_color = "#6a9295"
	rockhill_flow = TRUE
	icon_state = "rock"
	smoothing_flags = SMOOTH_BITMASK_CARDINALS

/turf/open/water/river/flow/east
	name = "river"
	desc = "A river of crystal clear water flows swiftly along the contours of the land."
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	rockhill_water_level = 3
	rockhill_water_color = "#6a9295"
	dir = 4
	rockhill_flow = TRUE
	icon_state = "rock"
	smoothing_flags = SMOOTH_BITMASK_CARDINALS

/turf/open/water/river/flow/north
	name = "river"
	desc = "A river of crystal clear water flows swiftly along the contours of the land."
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	rockhill_water_level = 3
	rockhill_water_color = "#6a9295"
	dir = 1
	rockhill_flow = TRUE
	icon_state = "rock"
	smoothing_flags = SMOOTH_BITMASK_CARDINALS

/turf/open/water/river/flow/west
	name = "river"
	desc = "A river of crystal clear water flows swiftly along the contours of the land."
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	rockhill_water_level = 3
	rockhill_water_color = "#6a9295"
	dir = 8
	rockhill_flow = TRUE
	icon_state = "rock"
	smoothing_flags = SMOOTH_BITMASK_CARDINALS

/turf/open/water/river/muddy
	name = "muddy river"
	desc = "A river of thick, silt-laden sludge lurches languidly through the land."
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	rockhill_water_level = 3
	rockhill_water_color = "#705a43"
	rockhill_flow = TRUE
	icon_state = "rock"
	smoothing_flags = SMOOTH_BITMASK_CARDINALS

/turf/open/water/sewer
	parent_type = /turf/open/water/rockhill
	name = "sewage"
	desc = "This dark water smells like dead rats and sulphur!"
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	rockhill_water_level = 1
	rockhill_water_color = "#705a43"
	icon_state = "paving"
	smoothing_flags = SMOOTH_BITMASK_CARDINALS

/turf/open/water/swamp
	parent_type = /turf/open/water/rockhill
	name = "murk"
	desc = "Weeds and algae cover the surface of the water."
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	rockhill_water_level = 2
	rockhill_water_color = "#705a43"
	icon_state = "dirt"
	rockhill_random_dir = TRUE
	smoothing_flags = SMOOTH_BITMASK_CARDINALS

/turf/open/water/swamp/deep
	name = "murk"
	desc = "Deep water with several weeds and algae on the surface."
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	rockhill_water_level = 3
	rockhill_water_color = "#705a43"
	icon_state = "dirt"
	rockhill_random_dir = TRUE
	smoothing_flags = SMOOTH_BITMASK_CARDINALS
