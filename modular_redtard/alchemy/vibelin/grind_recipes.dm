// Written by modular_redtard/tools/port_vibelin_alchemy.py from Vibelin (Vanderlin) and Azure Peak; do not edit by hand.
// Values of vars only: the bases and every proc are the module's alchemy code (see BASES in the script).
// Mortar recipes of Vibelin and Azure Peak the module (Ratwood's, alchemy/ported/alchemy.dm) lacks.

/datum/alch_grind_recipe/azure
	abstract_type = /datum/alch_grind_recipe/azure

/datum/alch_grind_recipe/azure/briar_essence
	name = "Briar Essence"
	valid_input = /obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals
	valid_outputs = list(/obj/item/alch/briar_essence = 1)
	bonus_chance_outputs = list(/obj/item/alch/earthdust = 50)

/datum/alch_grind_recipe/azure/gold_slag
	name = "Gold Slag"
	valid_input = /obj/item/goldslag
	valid_outputs = list(/obj/item/alch/golddust = 1)
	bonus_chance_outputs = list(/obj/item/alch/golddust = 33)

/datum/alch_grind_recipe/azure/mineraldustred
	name = "Mineral Dust (Rontz)"
	valid_input = /obj/item/roguegem/ruby
	valid_outputs = list(/obj/item/alch/mineraldust = 1, /obj/item/alch/waterdust = 2, /obj/item/alch/golddust = 4)
	bonus_chance_outputs = list(/obj/item/alch/silverdust = 33)

/datum/alch_grind_recipe/azure/scrap
	name = "Scrap"
	valid_input = /obj/item/scrap
	valid_outputs = list(/obj/item/alch/irondust = 1)
	bonus_chance_outputs = list(/obj/item/alch/runedust = 10)

/datum/alch_grind_recipe/azure/sleep_powder
	name = "Sleep Powder"
	valid_input = /obj/item/reagent_containers/food/snacks/zizo_bane
	valid_outputs = list(/obj/item/alch/sleep_powder = 1)
	bonus_chance_outputs = list(/obj/item/alch/airdust = 25)

/datum/alch_grind_recipe/vibelin
	abstract_type = /datum/alch_grind_recipe/vibelin

/datum/alch_grind_recipe/vibelin/charcoal_ore
	name = "charcoal"
	valid_input = /obj/item/rogueore/coal/charcoal
	valid_outputs = list(/obj/item/alch/coaldust = 1)
	bonus_chance_outputs = list(/obj/item/alch/coaldust = 33)

/datum/alch_grind_recipe/vibelin/dry_westleach
	name = "dried westleach leaf"
	valid_input = /obj/item/reagent_containers/food/snacks/vibelin/produce/dry_westleach
	valid_outputs = list(/obj/item/alch/tobaccodust = 1)
	bonus_chance_outputs = list(/obj/item/alch/airdust = 50, /obj/item/alch/tobaccodust = 50)

/datum/alch_grind_recipe/vibelin/leech
	name = "leech"
	picky = FALSE
	valid_input = /obj/item/natural/worms/leech
	valid_outputs = list(/obj/item/alch/waterdust = 1)
	bonus_chance_outputs = list(/obj/item/alch/waterdust = 10)

/datum/alch_grind_recipe/vibelin/worm
	name = "worm"
	valid_input = /obj/item/natural/worms
	valid_outputs = list(/obj/item/alch/earthdust = 1)
	bonus_chance_outputs = list(/obj/item/alch/earthdust = 10)
