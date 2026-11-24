// Written by modular_redtard/tools/port_vibelin_alchemy.py from Vibelin (Vanderlin); do not edit by hand.
// Values of vars only: the bases and every proc are the module's alchemy code (see BASES in the script).
// Infusions (Vibelin infusion_recipes.dm).

/datum/infusion_recipe/cinnabar
	name = "Cinnabar Transmutation"
	target_type = /obj/item/alch/silverdust
	result_type = /obj/item/rogueore/cinnabar
	required_essences = list(/datum/thaumaturgical_essence/magic = 20, /datum/thaumaturgical_essence/earth = 10, /datum/thaumaturgical_essence/motion = 10)

/datum/infusion_recipe/combat_flask
	name = "Combat Flask Synthesis"
	target_type = /obj/item/natural/glass
	result_type = /obj/item/essence_vial/combat
	required_essences = list(/datum/thaumaturgical_essence/magic = 20, /datum/thaumaturgical_essence/earth = 10)

/datum/infusion_recipe/glass
	name = "Glass Transmutation"
	target_type = /obj/item/natural/stone
	result_type = /obj/item/natural/glass
	required_essences = list(/datum/thaumaturgical_essence/crystal = 5)

/datum/infusion_recipe/heat_iron
	name = "Heat Iron"
	target_type = /obj/item/rogueore/iron
	result_type = /obj/item/ingot/iron
	required_essences = list(/datum/thaumaturgical_essence/fire = 10)

/datum/infusion_recipe/jar_two
	name = "Containment Enchantment"
	target_type = /obj/item/essence_node_jar
	result_type = /obj/item/essence_node_jar/advanced
	required_essences = list(/datum/thaumaturgical_essence/magic = 20, /datum/thaumaturgical_essence/earth = 10)

/datum/infusion_recipe/mana_crystal
	name = "Mana Crystal"
	target_type = /obj/item/roguegem/random
	result_type = /obj/item/magic/manacrystal
	required_essences = list(/datum/thaumaturgical_essence/magic = 10)

/datum/infusion_recipe/thaumic_iron
	name = "Thaumic Iron"
	target_type = /obj/item/ingot/iron
	result_type = /obj/item/ingot/thaumic
	required_essences = list(/datum/thaumaturgical_essence/fire = 10)
