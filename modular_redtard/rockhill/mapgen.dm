/obj/effect/landmark/mapGenerator
	name = "map generator"
	var/mapGeneratorType

/obj/effect/landmark/mapGenerator/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/landmark/mapGenerator/LateInitialize()
	if(ispath(mapGeneratorType, /datum/map_generator))
		var/datum/map_generator/generator = new mapGeneratorType()
		generator.defineRegion(locate(1, 1, z), locate(world.maxx, world.maxy, z))
		INVOKE_ASYNC(generator, TYPE_PROC_REF(/datum/map_generator, generate))
	qdel(src)

/datum/map_generator/rockhill/generate()
	syncModules()
	for(var/datum/map_generator_module/module as anything in modules)
		module.generate()
	qdel(src)

/datum/map_generator_module/rockhill
	var/list/allowed_turfs
	var/list/excluded_turfs
	var/list/allowed_areas
	var/include_subtypes = TRUE

/datum/map_generator_module/rockhill/generate()
	if(!mother)
		return
	var/list/allowed = allowed_turfs && typecacheof(allowed_turfs)
	var/list/excluded = excluded_turfs && typecacheof(excluded_turfs)
	var/list/areas = allowed_areas && typecacheof(allowed_areas, only_root_path = !include_subtypes)
	for(var/turf/place_on as anything in mother.map)
		CHECK_TICK
		if(excluded?[place_on.type] || (allowed && !allowed[place_on.type]))
			continue
		var/area/place_area = place_on.loc
		if(areas && !areas[place_area.type])
			continue
		place(place_on)
