// Vibelin's essence network (essence_machines/essence_network.dm): a machine's store of essences, the ethereal links the
// pestran connector draws between machines (source -> sink), and the cluster of linked machines with its cache of what
// each machine wants. Fixes on Vibelin: a transfer no longer reaches for the network of a store that has none (vials,
// surplus) and a move shows one orb, not two.

/// A store of essences (Vibelin /datum/essence_storage): contents, list(essence = units), up to max_total units of up to
/// max_types kinds. Its owner, when there is one, hears every change.
/datum/essence_storage
	var/list/contents = list()
	var/max_total = 0
	var/max_types = 0
	var/obj/machinery/essence/owner

/datum/essence_storage/New(obj/machinery/essence/new_owner, total = 0, types = 0)
	owner = new_owner
	max_total = total
	max_types = types

/datum/essence_storage/Destroy()
	contents = null
	owner = null
	return ..()

/datum/essence_storage/proc/get(essence_type)
	return contents[essence_type] || 0

/datum/essence_storage/proc/total()
	. = 0
	for(var/essence_type in contents)
		. += contents[essence_type]

/datum/essence_storage/proc/space()
	return max(0, max_total - total())

/datum/essence_storage/proc/has(essence_type, amount = 1)
	return get(essence_type) >= amount

/datum/essence_storage/proc/type_count()
	return length(contents)

/// Adds up to amount units of an essence; returns what went in.
/datum/essence_storage/proc/add(essence_type, amount)
	if(amount <= 0 || !essence_type)
		return 0
	if(!(essence_type in contents) && length(contents) >= max_types)
		return 0
	var/actual = min(amount, space())
	if(actual <= 0)
		return 0
	contents[essence_type] = get(essence_type) + actual
	owner?.on_storage_changed(essence_type, actual, TRUE)
	return actual

/// Takes up to amount units of an essence; returns what came out.
/datum/essence_storage/proc/remove(essence_type, amount)
	if(amount <= 0 || !(essence_type in contents))
		return 0
	var/have = contents[essence_type]
	var/actual = min(amount, have)
	contents[essence_type] = have - actual
	if(contents[essence_type] <= 0)
		contents -= essence_type
	owner?.on_storage_changed(essence_type, actual, FALSE)
	return actual

/// Moves up to amount units of an essence into another store; returns what moved and shows it travelling.
/datum/essence_storage/proc/transfer_to(datum/essence_storage/target, essence_type, amount)
	if(!target)
		return 0
	var/to_move = min(amount, get(essence_type))
	if(to_move <= 0)
		return 0
	var/moved = target.add(essence_type, to_move)
	remove(essence_type, moved)
	if(moved <= 0)
		return 0
	// Vibelin rebuilds the cache on every transfer: some machines want what their stores already hold.
	owner?.network?.rebuild_cache()
	if(target.owner?.network && target.owner.network != owner?.network)
		target.owner.network.invalidate_cache()
	if(owner && target.owner)
		rogue_essence_orb(owner, target.owner, essence_type)
	return moved

/datum/essence_storage/proc/clear()
	contents = list()

/datum/essence_storage/proc/snapshot()
	return contents.Copy()

/// An ethereal link (Vibelin /datum/essence_link): essences flow from source to sink, up to bandwidth units a tick.
/datum/essence_link
	var/obj/machinery/essence/source
	var/obj/machinery/essence/sink
	var/bandwidth = 0
	var/active = TRUE
	/// The ckey of who drew it.
	var/creator = ""

/datum/essence_link/New()
	bandwidth = rogue_essence_numbers().link_bandwidth

/datum/essence_link/Destroy()
	source = null
	sink = null
	return ..()

/// A cluster of linked machines (Vibelin /datum/essence_network).
/datum/essence_network
	/// list(machine = TRUE).
	var/list/machines = list()
	/// list(link = TRUE), the links between the machines of the cluster.
	var/list/links = list()
	/// What each machine wants, list(machine = list(essence = units)), built again when dirty.
	var/list/allowed_cache = list()
	var/cache_dirty = TRUE

/datum/essence_network/Destroy()
	for(var/obj/machinery/essence/machine as anything in machines)
		if(machine.network == src)
			machine.network = null
	machines = null
	links = null
	allowed_cache = null
	return ..()

/datum/essence_network/proc/add_machine(obj/machinery/essence/machine)
	if(machines[machine])
		return
	machines[machine] = TRUE
	machine.network = src
	cache_dirty = TRUE

/datum/essence_network/proc/remove_machine(obj/machinery/essence/machine)
	machines -= machine
	allowed_cache -= machine
	if(machine.network == src)
		machine.network = null

/datum/essence_network/proc/add_link(datum/essence_link/link)
	links[link] = TRUE

/datum/essence_network/proc/get_allowed_types(obj/machinery/essence/machine)
	if(cache_dirty)
		rebuild_cache()
	return allowed_cache[machine] || list()

/datum/essence_network/proc/invalidate_cache()
	cache_dirty = TRUE

/datum/essence_network/proc/rebuild_cache()
	allowed_cache = list()
	for(var/obj/machinery/essence/machine as anything in machines)
		allowed_cache[machine] = machine.build_allowed_types()
	cache_dirty = FALSE

/datum/essence_network/proc/merge(datum/essence_network/other)
	if(!other || other == src)
		return
	for(var/obj/machinery/essence/machine as anything in other.machines)
		add_machine(machine)
	for(var/datum/essence_link/link as anything in other.links)
		links[link] = TRUE
	other.machines = list()
	other.links = list()
	cache_dirty = TRUE
	qdel(other)

/// What the machines of the cluster want, summed by essence, skipping machines of the excluded types.
/datum/essence_network/proc/get_demand(list/excluded_types)
	var/list/demand = list()
	for(var/obj/machinery/essence/machine as anything in machines)
		if(excluded_types && is_type_in_list(machine, excluded_types))
			continue
		var/list/wanted = machine.build_allowed_types()
		for(var/essence_type in wanted)
			demand[essence_type] = (demand[essence_type] || 0) + wanted[essence_type]
	return demand

/// After a link is cut: floods the links again from every machine and gives each part that fell apart its own network.
/datum/essence_network/proc/rebuild_after_split()
	var/list/unvisited = machines.Copy()
	for(var/obj/machinery/essence/machine as anything in unvisited)
		machine.network = null
	machines = list()
	links = list()
	allowed_cache = list()
	var/first = TRUE
	while(length(unvisited))
		var/obj/machinery/essence/seed = unvisited[1]
		var/datum/essence_network/part = first ? src : new /datum/essence_network()
		first = FALSE
		var/list/queue = list(seed)
		var/list/visited = list()
		while(length(queue))
			var/obj/machinery/essence/current = queue[1]
			queue.Cut(1, 2)
			if(visited[current])
				continue
			visited[current] = TRUE
			unvisited -= current
			part.add_machine(current)
			for(var/datum/essence_link/link as anything in current.links)
				part.add_link(link)
				var/obj/machinery/essence/neighbor = link.source == current ? link.sink : link.source
				if(neighbor && !QDELETED(neighbor) && !visited[neighbor])
					queue += neighbor
		part.cache_dirty = TRUE

/// Draws a link from source to sink and joins their clusters (Vibelin essence_create_link()); null when it cannot be.
/proc/essence_create_link(obj/machinery/essence/source, obj/machinery/essence/sink, mob/creator)
	if(!source || !sink || source == sink || !source.can_link_to(sink))
		return null
	for(var/datum/essence_link/existing as anything in source.links)
		if((existing.source == source && existing.sink == sink) || (existing.source == sink && existing.sink == source))
			return null
	var/datum/essence_link/link = new
	link.source = source
	link.sink = sink
	link.creator = creator?.ckey || ""
	source.links += link
	sink.links += link
	if(!source.network)
		var/datum/essence_network/source_network = new
		source_network.add_machine(source)
	if(!sink.network)
		var/datum/essence_network/sink_network = new
		sink_network.add_machine(sink)
	if(source.network != sink.network)
		source.network.merge(sink.network)
	source.network.add_link(link)
	source.network.invalidate_cache()
	source.on_link_changed()
	sink.on_link_changed()
	var/atom/from = source.essence_anchor()
	var/atom/target_anchor = sink.essence_anchor()
	if(from && target_anchor)
		from.Beam(target_anchor, icon_state = "light_beam", time = 1 SECONDS)
	return link

/// Cuts a link and splits its cluster if it fell apart (Vibelin essence_remove_link()).
/proc/essence_remove_link(datum/essence_link/link)
	if(!link)
		return
	var/obj/machinery/essence/source = link.source
	var/obj/machinery/essence/sink = link.sink
	source?.links -= link
	sink?.links -= link
	var/datum/essence_network/old_network = source?.network || sink?.network
	if(old_network)
		old_network.rebuild_after_split()
		if(!length(old_network.machines))
			qdel(old_network)
	qdel(link)
	if(source && !QDELETED(source))
		source.on_link_changed()
	if(sink && !QDELETED(sink))
		sink.on_link_changed()

/// Cuts every link of a machine and takes it out of its cluster (Vibelin essence_disconnect_machine()).
/proc/essence_disconnect_machine(obj/machinery/essence/machine)
	for(var/datum/essence_link/link as anything in machine.links.Copy())
		essence_remove_link(link)
	var/datum/essence_network/network = machine.network
	if(network)
		network.remove_machine(machine)
		if(!length(network.machines))
			qdel(network)
	machine.network = null
