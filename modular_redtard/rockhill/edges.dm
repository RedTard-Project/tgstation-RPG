GLOBAL_LIST_EMPTY(rockhill_turf_edge_caches)

/turf/open
	var/list/rockhill_edges

/turf/open/proc/update_rockhill_edges()
	var/static/list/suffixes = list("[NORTH]" = "n", "[SOUTH]" = "s", "[EAST]" = "e", "[WEST]" = "w")
	if(rockhill_edges)
		cut_overlay(rockhill_edges)
		rockhill_edges = null
	var/list/sources = GLOB.rockhill_turf_edge_caches[type]
	if(!sources)
		sources = typecacheof(GLOB.rockhill_turf_edge_sources[type])
		GLOB.rockhill_turf_edge_caches[type] = sources
	var/override = GLOB.rockhill_turf_edge_overrides[type]
	for(var/direction in GLOB.cardinals)
		var/turf/neighbor = get_step(src, direction)
		if(!neighbor || !sources[neighbor.type])
			continue
		var/edge = override || GLOB.rockhill_turf_edges[neighbor.type]
		if(!edge)
			continue
		LAZYADD(rockhill_edges, mutable_appearance(icon, "[edge]-[suffixes["[direction]"]]"))
	if(rockhill_edges)
		add_overlay(rockhill_edges)

/turf/open/floor/rockhill/smooth_icon()
	if(!GLOB.rockhill_turf_edge_sources[type])
		return ..()
	if(QDELETED(src))
		return
	smoothing_flags &= ~SMOOTH_QUEUED
	update_rockhill_edges()

/turf/open/water/rockhill/smooth_icon()
	if(!GLOB.rockhill_turf_edge_sources[type])
		return ..()
	if(QDELETED(src))
		return
	smoothing_flags &= ~SMOOTH_QUEUED
	update_rockhill_edges()

/turf/open/lava/rockhill/smooth_icon()
	if(!GLOB.rockhill_turf_edge_sources[type])
		return ..()
	if(QDELETED(src))
		return
	smoothing_flags &= ~SMOOTH_QUEUED
	update_rockhill_edges()
