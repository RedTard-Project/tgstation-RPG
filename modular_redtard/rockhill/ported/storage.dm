/datum/storage/rogue_grid
	screen_max_columns = 3
	screen_max_rows = 8
	max_specific_storage = WEIGHT_CLASS_SMALL
	max_slots = 1000
	allow_quick_gather = FALSE
	allow_quick_empty = FALSE
	insert_preposition = "in"
	attack_hand_interact = TRUE
	rogue_not_while_equipped = FALSE

/datum/storage/rogue_grid/grid

/datum/storage/rogue_grid/roguetown

/datum/storage/rogue_grid/grid/magebag
	screen_max_columns = 5
	screen_max_rows = 8
	max_specific_storage = WEIGHT_CLASS_NORMAL
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE

/datum/storage/rogue_grid/grid/magebag/New()
	. = ..()
	set_holdable(list(/obj/item/alch, /obj/item/ash, /obj/item/herbseed, /obj/item/magic, /obj/item/reagent_containers/food/snacks/grown/berries/rogue))

/datum/storage/rogue_grid/grid/orestore
	screen_max_columns = 8
	screen_max_rows = 10
	max_specific_storage = WEIGHT_CLASS_NORMAL
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	insert_preposition = "in"

/datum/storage/rogue_grid/grid/orestore/New()
	. = ..()
	set_holdable(list(/obj/item/ingot, /obj/item/ingot/bronze, /obj/item/ingot/copper, /obj/item/ingot/decrepit, /obj/item/ingot/gold, /obj/item/ingot/iron, /obj/item/ingot/silver, /obj/item/ingot/steel, /obj/item/ingot/tin, /obj/item/riddleofsteel, /obj/item/roguegem, /obj/item/roguegem/amethyst, /obj/item/roguegem/blue, /obj/item/roguegem/diamond, /obj/item/roguegem/green, /obj/item/roguegem/ruby, /obj/item/roguegem/violet, /obj/item/roguegem/yellow, /obj/item/rogueore, /obj/item/rogueore/cinnabar, /obj/item/rogueore/coal, /obj/item/rogueore/copper, /obj/item/rogueore/gold, /obj/item/rogueore/iron, /obj/item/rogueore/silver, /obj/item/rogueore/tin))

/datum/storage/rogue_grid/roguetown/backpack
	screen_max_columns = 5
	screen_max_rows = 7
	max_specific_storage = WEIGHT_CLASS_NORMAL
	rogue_not_while_equipped = TRUE

/datum/storage/rogue_grid/roguetown/belt
	screen_max_columns = 2
	screen_max_rows = 3
	max_specific_storage = WEIGHT_CLASS_SMALL

/datum/storage/rogue_grid/roguetown/bin
	screen_max_columns = 4
	screen_max_rows = 8
	max_specific_storage = WEIGHT_CLASS_HUGE

/datum/storage/rogue_grid/roguetown/coin_pouch
	screen_max_columns = 1
	screen_max_rows = 4
	max_specific_storage = WEIGHT_CLASS_NORMAL
	rogue_not_while_equipped = FALSE

/datum/storage/rogue_grid/roguetown/dice_pouch
	screen_max_columns = 2
	screen_max_rows = 4
	max_specific_storage = WEIGHT_CLASS_TINY
	rogue_not_while_equipped = FALSE

/datum/storage/rogue_grid/roguetown/dice_pouch/New()
	. = ..()
	set_holdable(list(/obj/item/dice))

/datum/storage/rogue_grid/roguetown/keyring
	screen_max_columns = 5
	screen_max_rows = 4
	max_specific_storage = WEIGHT_CLASS_SMALL
	insert_preposition = "on"
	attack_hand_interact = FALSE

/datum/storage/rogue_grid/roguetown/keyring/New()
	. = ..()
	set_holdable(list(/obj/item/roguekey, /obj/item/seal))

/datum/storage/rogue_grid/roguetown/sack
	screen_max_columns = 4
	screen_max_rows = 5
	max_specific_storage = WEIGHT_CLASS_HUGE
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	insert_preposition = "in"

/datum/storage/rogue_grid/roguetown/satchel
	screen_max_rows = 4
	max_specific_storage = WEIGHT_CLASS_NORMAL

/datum/storage/rogue_grid/roguetown/satchelshort
	screen_max_rows = 3
	max_specific_storage = WEIGHT_CLASS_NORMAL

/datum/storage/rogue_grid/roguetown/surgery_bag
	screen_max_columns = 5
	screen_max_rows = 5
	max_specific_storage = WEIGHT_CLASS_NORMAL

/datum/storage/rogue_grid/roguetown/surgery_bag/New()
	. = ..()
	set_holdable(list(/obj/item/natural/bundle/cloth/bandage, /obj/item/natural/cloth, /obj/item/natural/worms/leech, /obj/item/needle, /obj/item/reagent_containers/lux, /obj/item/reagent_containers/lux_impure, /obj/item/rogueweapon/surgery))

/datum/storage/rogue_grid/grid/orestore/bronze
	screen_max_columns = 8
	screen_max_rows = 10

/datum/storage/rogue_grid/roguetown/belt/cloth
	screen_max_columns = 1

/datum/storage/rogue_grid/roguetown/belt/knife_belt
	screen_max_columns = 1
	screen_max_rows = 3

/datum/storage/rogue_grid/roguetown/sack/bag
	allow_quick_gather = FALSE
	allow_quick_empty = FALSE
	rogue_not_while_equipped = TRUE
