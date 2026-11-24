// Vibelin's research nodes (essence_machines/research_matrix/research_nodes/*.dm), carried over by
// .cache/modular_redtard/agents/va1/va1b_research.py: the costs in essences are the data of each node; each bonus is a
// mechanics value (alch_ess_rs_*), read by read_bonus().

/datum/thaumic_research_node/splitter_efficiency
	name = "Essence Division"
	desc = "Learn to safely and more precisely divide and separate thaumic materials into their essence parts. This will increase the splitter's efficiency."
	prerequisites = list(/datum/thaumic_research_node/basic_understanding)
	required_essences = list(/datum/thaumaturgical_essence/fire = 5, /datum/thaumaturgical_essence/earth = 5, /datum/thaumaturgical_essence/water = 5, /datum/thaumaturgical_essence/life = 5, /datum/thaumaturgical_essence/air = 5, /datum/thaumaturgical_essence/order = 5, /datum/thaumaturgical_essence/chaos = 5)
	node_x = 220
	node_y = 160
	bonus_type = "additive"

/datum/thaumic_research_node/splitter_efficiency/read_bonus()
	return rogue_value("alch_ess_rs_splitter_efficiency")

/datum/thaumic_research_node/splitter_efficiency/two
	name = "Refined Separation"
	desc = "Advanced techniques for essence splitting that achieve cleaner divisions, increasing the yield of the splitter."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/splitter_efficiency)
	required_essences = list(/datum/thaumaturgical_essence/fire = 10, /datum/thaumaturgical_essence/earth = 10, /datum/thaumaturgical_essence/water = 10, /datum/thaumaturgical_essence/life = 10, /datum/thaumaturgical_essence/air = 10, /datum/thaumaturgical_essence/order = 5, /datum/thaumaturgical_essence/chaos = 5)
	node_x = 460
	node_y = 80

/datum/thaumic_research_node/splitter_efficiency/two/read_bonus()
	return rogue_value("alch_ess_rs_splitter_efficiency_2")

/datum/thaumic_research_node/splitter_efficiency/three
	name = "Master's Division"
	desc = "Expert-level essence separation capable of isolating even the most volatile and complex essences without loss of yield."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/splitter_efficiency/two)
	required_essences = list(/datum/thaumaturgical_essence/fire = 20, /datum/thaumaturgical_essence/earth = 20, /datum/thaumaturgical_essence/water = 20, /datum/thaumaturgical_essence/life = 20, /datum/thaumaturgical_essence/air = 20, /datum/thaumaturgical_essence/order = 10, /datum/thaumaturgical_essence/chaos = 10)
	node_x = 300
	node_y = 200

/datum/thaumic_research_node/splitter_efficiency/three/read_bonus()
	return rogue_value("alch_ess_rs_splitter_efficiency_3")

/datum/thaumic_research_node/splitter_efficiency/four
	name = "Grandmaster's Cleaving"
	desc = "The pinnacle of separation arts, allowing for perfect division of any precursor while ensuring no essence is lost in the process."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/splitter_efficiency/three)
	required_essences = list(/datum/thaumaturgical_essence/fire = 30, /datum/thaumaturgical_essence/earth = 30, /datum/thaumaturgical_essence/water = 30, /datum/thaumaturgical_essence/life = 30, /datum/thaumaturgical_essence/air = 30, /datum/thaumaturgical_essence/order = 20, /datum/thaumaturgical_essence/chaos = 20)
	node_x = 260
	node_y = 320

/datum/thaumic_research_node/splitter_efficiency/four/read_bonus()
	return rogue_value("alch_ess_rs_splitter_efficiency_4")

/datum/thaumic_research_node/splitter_efficiency/five
	name = "Multiplied Division"
	desc = "Advanced splitting techniques that result in significant reduction of waste."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/splitter_efficiency/four)
	required_essences = list(/datum/thaumaturgical_essence/fire = 30, /datum/thaumaturgical_essence/earth = 30, /datum/thaumaturgical_essence/water = 30, /datum/thaumaturgical_essence/life = 30, /datum/thaumaturgical_essence/air = 30, /datum/thaumaturgical_essence/order = 20, /datum/thaumaturgical_essence/chaos = 20, /datum/thaumaturgical_essence/magic = 10)
	node_x = 400
	node_y = 200

/datum/thaumic_research_node/splitter_efficiency/five/read_bonus()
	return rogue_value("alch_ess_rs_splitter_efficiency_5")

/datum/thaumic_research_node/splitter_efficiency/six
	name = "Infinite Fragmentation"
	desc = "The ultimate splitting technique, these result in additional essence yield beyond what was deemed possible."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/splitter_efficiency/five)
	required_essences = list(/datum/thaumaturgical_essence/fire = 30, /datum/thaumaturgical_essence/earth = 30, /datum/thaumaturgical_essence/water = 30, /datum/thaumaturgical_essence/life = 30, /datum/thaumaturgical_essence/air = 30, /datum/thaumaturgical_essence/order = 30, /datum/thaumaturgical_essence/chaos = 30, /datum/thaumaturgical_essence/magic = 30)
	node_x = 500
	node_y = 200

/datum/thaumic_research_node/splitter_efficiency/six/read_bonus()
	return rogue_value("alch_ess_rs_splitter_efficiency_6")

/datum/thaumic_research_node/splitter_speed
	name = "Swift Division"
	desc = "Techniques to accelerate the essence splitting process through optimized channeling patterns and improved focus methods."
	prerequisites = list(/datum/thaumic_research_node/splitter_efficiency)
	required_essences = list(/datum/thaumaturgical_essence/motion = 10, /datum/thaumaturgical_essence/air = 15, /datum/thaumaturgical_essence/energia = 10)
	node_x = 480
	node_y = 20
	bonus_type = "additive"

/datum/thaumic_research_node/splitter_speed/read_bonus()
	return rogue_value("alch_ess_rs_splitter_speed")

/datum/thaumic_research_node/splitter_speed/two
	name = "Rapid Separation"
	desc = "Further acceleration of splitting processes through advanced magical circuitry and enhanced essence flow control."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/splitter_speed)
	required_essences = list(/datum/thaumaturgical_essence/motion = 20, /datum/thaumaturgical_essence/energia = 20, /datum/thaumaturgical_essence/cycle = 15)
	node_x = 720
	node_y = 40

/datum/thaumic_research_node/splitter_speed/two/read_bonus()
	return rogue_value("alch_ess_rs_splitter_speed_2")

/datum/thaumic_research_node/splitter_speed/three
	name = "Lightning Division"
	desc = "Near-instantaneous essence separation achieved through mastery of temporal acceleration fields and perfected channeling techniques."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/splitter_speed/two)
	required_essences = list(/datum/thaumaturgical_essence/motion = 25, /datum/thaumaturgical_essence/energia = 25, /datum/thaumaturgical_essence/cycle = 25, /datum/thaumaturgical_essence/magic = 20)
	node_x = 580
	node_y = 120

/datum/thaumic_research_node/splitter_speed/three/read_bonus()
	return rogue_value("alch_ess_rs_splitter_speed_3")

/datum/thaumic_research_node/transmutation
	name = "Essence Transmutation"
	desc = "The art of converting one type of magical essence into another through careful application of thaumic principles and controlled energy transfer. This will increase transmutation speed."
	prerequisites = list(/datum/thaumic_research_node/basic_understanding)
	required_essences = list(/datum/thaumaturgical_essence/fire = 10, /datum/thaumaturgical_essence/earth = 10)
	node_x = 140
	node_y = 480
	bonus_type = "additive"

/datum/thaumic_research_node/transmutation/read_bonus()
	return rogue_value("alch_ess_rs_transmutation")

/datum/thaumic_research_node/machines/gnomes
	name = "Life Synthesis"
	desc = "Understand the principals behind life."
	prerequisites = list(/datum/thaumic_research_node/transmutation)
	required_essences = list(/datum/thaumaturgical_essence/life = 50)
	node_x = 480
	node_y = 300
	machine_path = /obj/machinery/essence/test_tube

/datum/thaumic_research_node/gnome_speed
	name = "Improved Essence Incorporation"
	desc = "Improves the speed at which life essences coalesce to form life."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/machines/gnomes)
	required_essences = list(/datum/thaumaturgical_essence/life = 20, /datum/thaumaturgical_essence/motion = 10)
	node_x = 340
	node_y = 420
	bonus_type = "additive"

/datum/thaumic_research_node/gnome_speed/read_bonus()
	return rogue_value("alch_ess_rs_gnome_speed")

/datum/thaumic_research_node/gnome_speed/two
	name = "Enhanced Essence Incorporation"
	desc = "Further improves the speed at which life essences coalesce into gnomes."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/gnome_speed)
	required_essences = list(/datum/thaumaturgical_essence/life = 30, /datum/thaumaturgical_essence/motion = 15, /datum/thaumaturgical_essence/energia = 10)
	node_x = 220
	node_y = 480

/datum/thaumic_research_node/gnome_speed/two/read_bonus()
	return rogue_value("alch_ess_rs_gnome_speed_2")

/datum/thaumic_research_node/gnome_speed/three
	name = "Perfected Essence Incorporation"
	desc = "Maximizes the speed at which life essences coalesce."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/gnome_speed/two)
	required_essences = list(/datum/thaumaturgical_essence/life = 50, /datum/thaumaturgical_essence/motion = 25, /datum/thaumaturgical_essence/energia = 15, /datum/thaumaturgical_essence/cycle = 20)
	node_x = 160
	node_y = 600

/datum/thaumic_research_node/gnome_speed/three/read_bonus()
	return rogue_value("alch_ess_rs_gnome_speed_3")

/datum/thaumic_research_node/gnome_efficency
	name = "Improved Essence Handling"
	desc = "Reduces the essence needed to form gnomish life."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/machines/gnomes)
	required_essences = list(/datum/thaumaturgical_essence/life = 20, /datum/thaumaturgical_essence/order = 10)
	node_x = 420
	node_y = 440
	bonus_type = "multiplicative"

/datum/thaumic_research_node/gnome_efficency/read_bonus()
	return rogue_value("alch_ess_rs_gnome_efficency")

/datum/thaumic_research_node/gnome_efficency/two
	name = "Advanced Essence Handling"
	desc = "Further reduces the amount of life essence needed to form life."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/gnome_efficency)
	required_essences = list(/datum/thaumaturgical_essence/life = 30, /datum/thaumaturgical_essence/order = 15, /datum/thaumaturgical_essence/void = 10)
	node_x = 440
	node_y = 540

/datum/thaumic_research_node/gnome_efficency/two/read_bonus()
	return rogue_value("alch_ess_rs_gnome_efficency_2")

/datum/thaumic_research_node/gnome_efficency/three
	name = "Masterful Essence Handling"
	desc = "Greatly reduces the amount of life essence needed to form life."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/gnome_efficency/two)
	required_essences = list(/datum/thaumaturgical_essence/life = 40, /datum/thaumaturgical_essence/order = 20, /datum/thaumaturgical_essence/crystal = 15)
	node_x = 520
	node_y = 600

/datum/thaumic_research_node/gnome_efficency/three/read_bonus()
	return rogue_value("alch_ess_rs_gnome_efficency_3")

/datum/thaumic_research_node/gnome_hat_chance
	name = "Gnomish Perfection"
	desc = "The pinnacle of life, Gnomes with Hats. If Psydon were here to witness this, he would weep tears of joy."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/gnome_speed/three, /datum/thaumic_research_node/gnome_efficency/three)
	required_essences = list(/datum/thaumaturgical_essence/life = 300, /datum/thaumaturgical_essence/magic = 100, /datum/thaumaturgical_essence/order = 75, /datum/thaumaturgical_essence/crystal = 50)
	node_x = 320
	node_y = 520
	bonus_type = "special"

/datum/thaumic_research_node/gnome_hat_chance/read_bonus()
	return rogue_value("alch_ess_rs_gnome_hat_chance")

/datum/thaumic_research_node/resevoir_decay
	name = "Temporal Decay"
	desc = "Techniques to speed up the flow of time, letting one decay essences into waste in mere seconds."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/advanced_combiner_applications)
	required_essences = list(/datum/thaumaturgical_essence/cycle = 20, /datum/thaumaturgical_essence/void = 10, /datum/thaumaturgical_essence/chaos = 5)
	node_x = 180
	node_y = 680

/datum/thaumic_research_node/advanced_combiner_applications
	name = "Essence Fusion Mastery"
	desc = "Advanced techniques for combining different magical essences into more powerful and complex compounds. The foundation for all higher-level combination work."
	icon_state = "node"
	required_essences = list(/datum/thaumaturgical_essence/fire = 15, /datum/thaumaturgical_essence/water = 15, /datum/thaumaturgical_essence/earth = 15, /datum/thaumaturgical_essence/air = 15, /datum/thaumaturgical_essence/order = 9, /datum/thaumaturgical_essence/chaos = 9)
	node_x = 300
	node_y = 840

/datum/thaumic_research_node/combiner_output
	name = "Enhanced Yield"
	desc = "Techniques to increase the quantity of combined essences produced from each fusion process without a sacrifice in yield."
	prerequisites = list(/datum/thaumic_research_node/advanced_combiner_applications)
	required_essences = list(/datum/thaumaturgical_essence/crystal = 10, /datum/thaumaturgical_essence/order = 7, /datum/thaumaturgical_essence/earth = 8)
	node_x = 520
	node_y = 880
	bonus_type = "additive"

/datum/thaumic_research_node/combiner_output/read_bonus()
	return rogue_value("alch_ess_rs_combiner_output")

/datum/thaumic_research_node/combiner_output/two
	name = "Amplified Production"
	desc = "Advanced methods for maximizing essence combination output through improved channeling efficiency and reduced waste."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/combiner_output)
	required_essences = list(/datum/thaumaturgical_essence/crystal = 15, /datum/thaumaturgical_essence/order = 10, /datum/thaumaturgical_essence/life = 7)
	node_x = 700
	node_y = 840

/datum/thaumic_research_node/combiner_output/two/read_bonus()
	return rogue_value("alch_ess_rs_combiner_output_2")

/datum/thaumic_research_node/combiner_output/three
	name = "Abundance Creation"
	desc = "Master-level techniques for achieving extraordinary yields from essence combination processes while maintaining perfect efficiency."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/combiner_output/two)
	required_essences = list(/datum/thaumaturgical_essence/crystal = 20, /datum/thaumaturgical_essence/order = 15, /datum/thaumaturgical_essence/life = 10, /datum/thaumaturgical_essence/magic = 8)
	node_x = 860
	node_y = 760

/datum/thaumic_research_node/combiner_output/three/read_bonus()
	return rogue_value("alch_ess_rs_combiner_output_3")

/datum/thaumic_research_node/combiner_output/four
	name = "Infinite Synthesis"
	desc = "The pinnacle of combination arts, allowing for theoretically unlimited output from minimal input through perfect efficiency mastery."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/combiner_output/three)
	required_essences = list(/datum/thaumaturgical_essence/crystal = 30, /datum/thaumaturgical_essence/magic = 25, /datum/thaumaturgical_essence/void = 20, /datum/thaumaturgical_essence/chaos = 16)
	node_x = 660
	node_y = 740

/datum/thaumic_research_node/combiner_output/four/read_bonus()
	return rogue_value("alch_ess_rs_combiner_output_4")

/datum/thaumic_research_node/combiner_speed
	name = "Swift Fusion"
	desc = "Accelerate the essence combination process through improved channeling techniques and optimized magical flow patterns."
	prerequisites = list(/datum/thaumic_research_node/advanced_combiner_applications)
	required_essences = list(/datum/thaumaturgical_essence/motion = 10, /datum/thaumaturgical_essence/energia = 7, /datum/thaumaturgical_essence/fire = 8)
	node_x = 280
	node_y = 700
	bonus_type = "additive"

/datum/thaumic_research_node/combiner_speed/read_bonus()
	return rogue_value("alch_ess_rs_combiner_speed")

/datum/thaumic_research_node/combiner_speed/two
	name = "Rapid Synthesis"
	desc = "Further acceleration of the essence combination processes through advanced magical circuitry and enhanced essence bonding techniques."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/combiner_speed)
	required_essences = list(/datum/thaumaturgical_essence/motion = 20, /datum/thaumaturgical_essence/energia = 12, /datum/thaumaturgical_essence/cycle = 14)
	node_x = 360
	node_y = 800

/datum/thaumic_research_node/combiner_speed/two/read_bonus()
	return rogue_value("alch_ess_rs_combiner_speed_2")

/datum/thaumic_research_node/combiner_speed/three
	name = "Instantaneous Fusion"
	desc = "Near-instantaneous essence combination achieved through mastery of temporal acceleration and perfected synthesis methods."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/combiner_output/two)
	required_essences = list(/datum/thaumaturgical_essence/motion = 30, /datum/thaumaturgical_essence/energia = 20, /datum/thaumaturgical_essence/cycle = 20, /datum/thaumaturgical_essence/magic = 15)
	node_x = 520
	node_y = 780

/datum/thaumic_research_node/combiner_speed/three/read_bonus()
	return rogue_value("alch_ess_rs_combiner_speed_3")

/datum/thaumic_research_node/combiner_speed/four
	name = "Transcendent Velocity"
	desc = "Achieve combination speeds that transcend normal temporal limitations through mastery of advanced magical acceleration."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/combiner_output/three)
	required_essences = list(/datum/thaumaturgical_essence/motion = 40, /datum/thaumaturgical_essence/energia = 25, /datum/thaumaturgical_essence/cycle = 25, /datum/thaumaturgical_essence/magic = 20, /datum/thaumaturgical_essence/void = 20)
	node_x = 340
	node_y = 640

/datum/thaumic_research_node/combiner_speed/four/read_bonus()
	return rogue_value("alch_ess_rs_combiner_speed_4")

/datum/thaumic_research_node/combiner_speed/five
	name = "Eternal Swiftness"
	desc = "The ultimate in combination speed, allowing for continuous, instantaneous essence fusion processes that operate beyond time itself."
	icon_state = "node"
	prerequisites = list(/datum/thaumic_research_node/combiner_output/four)
	required_essences = list(/datum/thaumaturgical_essence/motion = 50, /datum/thaumaturgical_essence/energia = 35, /datum/thaumaturgical_essence/cycle = 35, /datum/thaumaturgical_essence/magic = 35, /datum/thaumaturgical_essence/void = 30, /datum/thaumaturgical_essence/chaos = 25)
	node_x = 560
	node_y = 680

/datum/thaumic_research_node/combiner_speed/five/read_bonus()
	return rogue_value("alch_ess_rs_combiner_speed_5")
