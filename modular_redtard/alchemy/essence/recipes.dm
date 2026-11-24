// How the alchemist makes the essence apparatus (Vibelin crafting/blueprinting/blueprints/alchemy.dm and
// quality_of_crafting/alchemy.dm), in the module's crafting menu (crafting/rogue_recipes.dm). Machines are never mapped:
// the ones that start the work (splitter, combiner, divider, reservoir, infuser, extractor) are built from what the town
// has - iron, glass, wood, stone (coordinator's decision for block VA1); thaumic iron and mana crystals come from the
// infuser, as in Vibelin, and go into the harvester, the research engine and the connector. The breeding tube has no
// recipe while the homunculus is not ported (essence/test_tube.dm); the enchantment altar and the gauntlet are magic's
// (block VM2).

/// Thaumic iron (Vibelin /obj/item/ingot/thaumic): iron tempered with fire essence in the infuser, or smelted from
/// thaumic iron dust.
/obj/item/ingot/thaumic
	name = "thaumic iron bar"
	desc = "A bar of wrought iron tempered with fire essence."
	icon = ROGUE_ESSENCE_ALCHEMY_ICON
	icon_state = "infused_iron"
	smeltresult = /obj/item/ingot/thaumic

/datum/crafting_recipe/roguetown/alchemy/essence
	abstract_type = /datum/crafting_recipe/roguetown/alchemy/essence
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/alchemy/essence/splitter
	name = "essence splitter"
	result = /obj/machinery/essence/splitter
	reqs = list(/obj/item/ingot/iron = 2, /obj/item/natural/glass = 2, /obj/item/natural/wood/plank = 1)
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/alchemy/essence/combiner
	name = "essence combiner"
	result = /obj/machinery/essence/combiner
	reqs = list(/obj/item/ingot/iron = 2, /obj/item/natural/glass = 2)
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/alchemy/essence/divider
	name = "essence divider"
	result = /obj/machinery/essence/divider
	reqs = list(/obj/item/ingot/iron = 1, /obj/item/natural/glass = 1)
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/alchemy/essence/reservoir
	name = "essence reservoir"
	result = /obj/machinery/essence/reservoir
	reqs = list(/obj/item/ingot/iron = 1, /obj/item/natural/glass = 3)
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/alchemy/essence/infuser
	name = "essence infuser"
	result = /obj/machinery/essence/infuser
	reqs = list(/obj/item/natural/stone = 2, /obj/item/ingot/iron = 1)
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/alchemy/essence/extractor
	name = "essence extractor"
	result = /obj/machinery/essence/extractor
	reqs = list(/obj/item/ingot/iron = 2, /obj/item/natural/glass = 1, /obj/item/natural/wood/plank = 1)
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/alchemy/essence/harvester
	name = "essence harvester"
	result = /obj/machinery/essence/harvester
	reqs = list(/obj/item/ingot/thaumic = 2, /obj/item/magic/manacrystal = 1, /obj/item/natural/glass = 1)
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/alchemy/essence/research_matrix
	name = "alchemical engine (research matrix)"
	result = /obj/machinery/essence/research_matrix
	reqs = list(/obj/item/ingot/thaumic = 2, /obj/item/magic/manacrystal = 1)
	rogue_difficulty = 3

// The small apparatus is made at the alchemy station (Vibelin carves it with a knife).

/datum/crafting_recipe/roguetown/alchemy/essence/connector
	name = "pestran connector"
	result = /obj/item/essence_connector
	reqs = list(/obj/item/ingot/thaumic = 1, /obj/item/natural/glass = 1)
	rogue_structure = /obj/structure/fluff/alch
	rogue_difficulty = 1
	rogue_verb = "carves"
	rogue_verb_simple = "carve"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/essence/vials
	name = "essence vials (3)"
	result = /obj/item/essence_vial
	rogue_results = list(/obj/item/essence_vial, /obj/item/essence_vial)
	reqs = list(/obj/item/natural/glass = 1)
	rogue_structure = /obj/structure/fluff/alch
	rogue_difficulty = 0
	rogue_verb = "carves"
	rogue_verb_simple = "carve"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/essence/node_jar
	name = "essence node containment jar"
	result = /obj/item/essence_node_jar
	reqs = list(/obj/item/ingot/thaumic = 1, /obj/item/natural/glass = 3)
	rogue_structure = /obj/structure/fluff/alch
	rogue_difficulty = 1
	rogue_verb = "carves"
	rogue_verb_simple = "carve"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/// Vibelin's way to thaumic iron without a splitter: not efficient, there so the apparatus can be made from nothing.
/datum/crafting_recipe/roguetown/alchemy/essence/thaumic_dust
	name = "thaumic iron dust"
	result = /obj/item/alch/thaumicdust
	reqs = list(/obj/item/alch/firedust = 1, /obj/item/alch/irondust = 1, /obj/item/alch/feaudust = 1, /obj/item/alch/runedust = 1)
	rogue_structure = /obj/structure/fluff/alch
	rogue_difficulty = 3
	rogue_verb = "mixes"
	rogue_verb_simple = "mix"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
