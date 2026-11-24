// The numbers of the essence machines (alch_ess_* in the mechanics values, alchemy.txt), read once and again only when the
// mechanics revision moves (as survival/sleep.dm does): machines tick in SSobj and read them every tick.

/// The numbers of the essence machines, current (read again after a reload or a set in the Rogue Mechanics panel).
/proc/rogue_essence_numbers()
	RETURN_TYPE(/datum/rogue_essence_numbers)
	var/static/datum/rogue_essence_numbers/numbers
	if(!numbers)
		numbers = new
	if(numbers.revision != rogue_mechanics_revision())
		numbers.read()
	return numbers

/datum/rogue_essence_numbers
	var/revision = -1
	// The network.
	var/link_bandwidth
	// The splitter and the extractor.
	var/splitter_capacity
	var/splitter_types
	var/splitter_items
	var/splitter_items_5
	var/splitter_items_6
	var/splitter_capacity_5
	var/splitter_capacity_6
	var/splitter_time
	var/splitter_time_item
	var/splitter_xp_share
	var/extractor_capacity
	var/extractor_types
	var/extractor_ticks
	var/extractor_time
	var/extractor_yield
	// The divider, the combiner, the reservoir.
	var/divider_capacity
	var/divider_types
	var/combiner_capacity
	var/combiner_types
	var/combiner_output_capacity
	var/combiner_output_types
	var/combiner_batches
	var/combiner_time
	var/combiner_time_recipe
	var/combiner_xp_share
	var/reservoir_capacity
	var/reservoir_types
	var/reservoir_void_rate
	var/reservoir_void_max
	var/reservoir_void_step
	// The infuser, the harvester, the breeding tube, the research matrix, the cauldron's node.
	var/infuser_capacity
	var/infuser_types
	var/infuser_time
	var/harvester_capacity
	var/harvester_types
	var/harvester_rate
	var/harvester_recharge
	var/harvester_install_time
	var/tube_capacity
	var/tube_life
	var/tube_time
	var/matrix_types
	var/cauldron_node_capacity
	var/cauldron_node_types
	var/research_xp
	// Vials.
	var/vial_capacity
	var/vial_step
	var/flask_capacity
	var/flask_step
	// Essence nodes, carried nodes and their jars.
	var/node_rare_chance
	var/node_capacity_min
	var/node_capacity_max
	var/node_recharge_min
	var/node_recharge_max
	var/node_integrity
	var/node_rare_capacity_min
	var/node_rare_capacity_max
	var/node_rare_recharge_min
	var/node_rare_recharge_max
	var/node_rare_integrity
	var/node_fill_min
	var/node_fill_max
	var/node_recharge_time
	var/node_harvest_min
	var/node_harvest_max
	var/node_extract_time
	var/node_carry_slowdown
	var/node_rare_carry_slowdown
	var/node_carry_drain
	var/node_rare_carry_drain
	var/node_carry_drain_time
	var/node_portable_recharge
	var/jar_drain
	var/jar_advanced_drain
	var/jar_drain_time
	var/jar_deploy_time

/datum/rogue_essence_numbers/proc/read()
	link_bandwidth = rogue_value("alch_ess_link_bandwidth")
	splitter_capacity = rogue_value("alch_ess_splitter_capacity")
	splitter_types = rogue_value("alch_ess_splitter_types")
	splitter_items = rogue_value("alch_ess_splitter_items")
	splitter_items_5 = rogue_value("alch_ess_splitter_items_5")
	splitter_items_6 = rogue_value("alch_ess_splitter_items_6")
	splitter_capacity_5 = rogue_value("alch_ess_splitter_capacity_5")
	splitter_capacity_6 = rogue_value("alch_ess_splitter_capacity_6")
	splitter_time = rogue_value("alch_ess_splitter_time")
	splitter_time_item = rogue_value("alch_ess_splitter_time_item")
	splitter_xp_share = rogue_value("alch_ess_splitter_xp_share")
	extractor_capacity = rogue_value("alch_ess_extractor_capacity")
	extractor_types = rogue_value("alch_ess_extractor_types")
	extractor_ticks = rogue_value("alch_ess_extractor_ticks")
	extractor_time = rogue_value("alch_ess_extractor_time")
	extractor_yield = rogue_value("alch_ess_extractor_yield")
	divider_capacity = rogue_value("alch_ess_divider_capacity")
	divider_types = rogue_value("alch_ess_divider_types")
	combiner_capacity = rogue_value("alch_ess_combiner_capacity")
	combiner_types = rogue_value("alch_ess_combiner_types")
	combiner_output_capacity = rogue_value("alch_ess_combiner_output_capacity")
	combiner_output_types = rogue_value("alch_ess_combiner_output_types")
	combiner_batches = rogue_value("alch_ess_combiner_batches")
	combiner_time = rogue_value("alch_ess_combiner_time")
	combiner_time_recipe = rogue_value("alch_ess_combiner_time_recipe")
	combiner_xp_share = rogue_value("alch_ess_combiner_xp_share")
	reservoir_capacity = rogue_value("alch_ess_reservoir_capacity")
	reservoir_types = rogue_value("alch_ess_reservoir_types")
	reservoir_void_rate = rogue_value("alch_ess_reservoir_void_rate")
	reservoir_void_max = rogue_value("alch_ess_reservoir_void_max")
	reservoir_void_step = rogue_value("alch_ess_reservoir_void_step")
	infuser_capacity = rogue_value("alch_ess_infuser_capacity")
	infuser_types = rogue_value("alch_ess_infuser_types")
	infuser_time = rogue_value("alch_ess_infuser_time")
	harvester_capacity = rogue_value("alch_ess_harvester_capacity")
	harvester_types = rogue_value("alch_ess_harvester_types")
	harvester_rate = rogue_value("alch_ess_harvester_rate")
	harvester_recharge = rogue_value("alch_ess_harvester_recharge")
	harvester_install_time = rogue_value("alch_ess_harvester_install_time")
	tube_capacity = rogue_value("alch_ess_tube_capacity")
	tube_life = rogue_value("alch_ess_tube_life")
	tube_time = rogue_value("alch_ess_tube_time")
	matrix_types = rogue_value("alch_ess_matrix_types")
	cauldron_node_capacity = rogue_value("alch_ess_cauldron_node_capacity")
	cauldron_node_types = rogue_value("alch_ess_cauldron_node_types")
	research_xp = rogue_value("alch_ess_research_xp")
	vial_capacity = rogue_value("alch_ess_vial_capacity")
	vial_step = rogue_value("alch_ess_vial_step")
	flask_capacity = rogue_value("alch_ess_flask_capacity")
	flask_step = rogue_value("alch_ess_flask_step")
	node_rare_chance = rogue_value("alch_ess_node_rare_chance")
	node_capacity_min = rogue_value("alch_ess_node_capacity_min")
	node_capacity_max = rogue_value("alch_ess_node_capacity_max")
	node_recharge_min = rogue_value("alch_ess_node_recharge_min")
	node_recharge_max = rogue_value("alch_ess_node_recharge_max")
	node_integrity = rogue_value("alch_ess_node_integrity")
	node_rare_capacity_min = rogue_value("alch_ess_node_rare_capacity_min")
	node_rare_capacity_max = rogue_value("alch_ess_node_rare_capacity_max")
	node_rare_recharge_min = rogue_value("alch_ess_node_rare_recharge_min")
	node_rare_recharge_max = rogue_value("alch_ess_node_rare_recharge_max")
	node_rare_integrity = rogue_value("alch_ess_node_rare_integrity")
	node_fill_min = rogue_value("alch_ess_node_fill_min")
	node_fill_max = rogue_value("alch_ess_node_fill_max")
	node_recharge_time = rogue_value("alch_ess_node_recharge_time")
	node_harvest_min = rogue_value("alch_ess_node_harvest_min")
	node_harvest_max = rogue_value("alch_ess_node_harvest_max")
	node_extract_time = rogue_value("alch_ess_node_extract_time")
	node_carry_slowdown = rogue_value("alch_ess_node_carry_slowdown")
	node_rare_carry_slowdown = rogue_value("alch_ess_node_rare_carry_slowdown")
	node_carry_drain = rogue_value("alch_ess_node_carry_drain")
	node_rare_carry_drain = rogue_value("alch_ess_node_rare_carry_drain")
	node_carry_drain_time = rogue_value("alch_ess_node_carry_drain_time")
	node_portable_recharge = rogue_value("alch_ess_node_portable_recharge")
	jar_drain = rogue_value("alch_ess_jar_drain")
	jar_advanced_drain = rogue_value("alch_ess_jar_advanced_drain")
	jar_drain_time = rogue_value("alch_ess_jar_drain_time")
	jar_deploy_time = rogue_value("alch_ess_jar_deploy_time")
	revision = rogue_mechanics_revision()
