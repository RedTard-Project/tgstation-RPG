// Written by modular_redtard/tools/port_vibelin_food.py from modular_redtard/items_vibelin/food_port.json; do not edit by hand.
// Vibelin's own vessels (H2g): bottles, cups, bowls, teapots, powders, pills and platters under the module's vessels (survival/vessels.dm, TG cups and plates).
// Numbers (integrity, force, throw force) live in the private mechanics/items.txt.

/obj/item/plate/vibelin
	abstract_type = /obj/item/plate/vibelin

/obj/item/plate/vibelin/clay
	name = "clay platter"
	desc = "A fragile platter made from fired clay. Probably shouldn't throw it."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/cooking.dmi'
	icon_state = "platter_clay"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = NONE
	rogue_grid_width = 32
	rogue_grid_height = 32
	max_items = 3
	max_x_offset = 5
	max_height_offset = 5
	placement_offset = -15

/obj/item/reagent_containers/glass/bottle/vibelin
	abstract_type = /obj/item/reagent_containers/glass/bottle/vibelin

/obj/item/reagent_containers/glass/bottle/vibelin/amanitin
	name = "amanitin bottle"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/glass_reagent_container.dmi'
	icon_state = "clear_bottle1"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_ROGUE_MOUTH
	rogue_grid_width = 32
	rogue_grid_height = 64
	volume = 75
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5, 10)
	spillable = FALSE
	list_reagents = list(/datum/reagent/toxin/amanitin = 30)
	sellprice = 1
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_onmob_sheet = null
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/bottle/vibelin/black
	name = "wine pot"
	desc = "A wine pot made of glazed clay."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/glass_reagent_container.dmi'
	icon_state = "blackbottle"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_ROGUE_MOUTH
	rogue_grid_width = 32
	rogue_grid_height = 64
	volume = 75
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5, 10)
	spillable = FALSE
	list_reagents = null
	sellprice = 1
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_onmob_sheet = null
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/bottle/vibelin/ethanol
	name = "ethanol bottle"
	desc = "A bottle with a cork."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/glass_reagent_container.dmi'
	icon_state = "clear_bottle1"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_ROGUE_MOUTH
	rogue_grid_width = 32
	rogue_grid_height = 64
	volume = 75
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5, 10)
	spillable = FALSE
	list_reagents = list(/datum/reagent/consumable/ethanol = 30)
	sellprice = 1
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_onmob_sheet = null
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/bottle/vibelin/fentanyl
	name = "fentanyl bottle"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/glass_reagent_container.dmi'
	icon_state = "clear_bottle1"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_ROGUE_MOUTH
	rogue_grid_width = 32
	rogue_grid_height = 64
	volume = 75
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5, 10)
	spillable = FALSE
	list_reagents = list(/datum/reagent/toxin/fentanyl = 30)
	sellprice = 1
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_onmob_sheet = null
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/bottle/vibelin/plasma
	name = "purple aetherium bottle"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/glass_reagent_container.dmi'
	icon_state = "clear_bottle1"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_ROGUE_MOUTH
	rogue_grid_width = 32
	rogue_grid_height = 64
	volume = 75
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5, 10)
	spillable = FALSE
	list_reagents = list(/datum/reagent/toxin/plasma = 30)
	sellprice = 1
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_onmob_sheet = null
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/bottle/vibelin/sacid
	name = "sulphuric acid bottle"
	desc = "A bottle with a cork."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/glass_reagent_container.dmi'
	icon_state = "clear_bottle1"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_ROGUE_MOUTH
	rogue_grid_width = 32
	rogue_grid_height = 64
	volume = 75
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5, 10)
	spillable = FALSE
	list_reagents = list(/datum/reagent/toxin/acid = 30)
	sellprice = 1
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_onmob_sheet = null
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/bottle/vibelin/sugar
	name = "sugar bottle"
	desc = "A bottle with a cork."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/glass_reagent_container.dmi'
	icon_state = "clear_bottle1"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_ROGUE_MOUTH
	rogue_grid_width = 32
	rogue_grid_height = 64
	volume = 75
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5, 10)
	spillable = FALSE
	list_reagents = list(/datum/reagent/consumable/sugar = 30)
	sellprice = 1
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_onmob_sheet = null
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/bottle/vibelin/toxin
	name = "toxin bottle"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/glass_reagent_container.dmi'
	icon_state = "clear_bottle1"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_ROGUE_MOUTH
	rogue_grid_width = 32
	rogue_grid_height = 64
	volume = 75
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5, 10)
	spillable = FALSE
	list_reagents = list(/datum/reagent/toxin = 30)
	sellprice = 1
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_onmob_sheet = null
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/bottle/vibelin/venom
	name = "venom bottle"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/glass_reagent_container.dmi'
	icon_state = "clear_bottle1"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_ROGUE_MOUTH
	rogue_grid_width = 32
	rogue_grid_height = 64
	volume = 75
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5, 10)
	spillable = FALSE
	list_reagents = list(/datum/reagent/toxin/venom = 30)
	sellprice = 1
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_onmob_sheet = null
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/bottle/vibelin/vial
	name = "vial"
	desc = "A vial with a cork."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/glass_reagent_container.dmi'
	icon_state = "clear_vial1"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_ROGUE_MOUTH
	rogue_grid_width = 32
	rogue_grid_height = 32
	volume = 25
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5)
	spillable = FALSE
	list_reagents = null
	sellprice = 1
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_onmob_sheet = null
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/carafe/vibelin
	abstract_type = /obj/item/reagent_containers/glass/carafe/vibelin

/obj/item/reagent_containers/glass/carafe/vibelin/decanter
	name = "clay decanter"
	desc = "A decanter fired from clay."
	icon = 'modular_redtard/items_vibelin/icons/icons/obj/handmade/decanter.dmi'
	icon_state = "world"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = NONE
	rogue_grid_width = 32
	rogue_grid_height = 64
	volume = 50
	amount_per_transfer_from_this = 8
	possible_transfer_amounts = list(8)
	spillable = TRUE
	list_reagents = null
	sellprice = 5
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/carafe/vibelin/teapot
	name = "fancy teapot"
	desc = "A fancy tea pot made out of ceramic. Used to hold tea."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/cooking.dmi'
	icon_state = "teapot_fancy"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = NONE
	rogue_grid_width = 32
	rogue_grid_height = 64
	volume = 100
	amount_per_transfer_from_this = 6
	possible_transfer_amounts = list(6)
	spillable = TRUE
	list_reagents = null
	sellprice = 30
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/carafe/vibelin/teapot/amber
	name = "petriamber teapot"
	desc = "A dainty teapot carved out of petriamber."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/cooking.dmi'
	icon_state = "teapot_amber"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = NONE
	rogue_grid_width = 32
	rogue_grid_height = 64
	volume = 100
	amount_per_transfer_from_this = 6
	possible_transfer_amounts = list(6)
	spillable = TRUE
	list_reagents = null
	sellprice = 60
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/carafe/vibelin/teapot/bronze
	name = "bronze teapot"
	desc = "A dainty bronze teapot. The perfect item for a noble's tea party."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/precious_objects.dmi'
	icon_state = "teapot_bronze"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = NONE
	rogue_grid_width = 32
	rogue_grid_height = 64
	smeltresult = /obj/item/ingot/bronze
	volume = 100
	amount_per_transfer_from_this = 6
	possible_transfer_amounts = list(6)
	spillable = TRUE
	list_reagents = null
	sellprice = 25
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/carafe/vibelin/teapot/clay
	name = "clay teapot"
	desc = "A teapot fired from clay."
	icon = 'modular_redtard/items_vibelin/icons/icons/obj/handmade/teapot.dmi'
	icon_state = "world"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = NONE
	rogue_grid_width = 32
	rogue_grid_height = 64
	volume = 100
	amount_per_transfer_from_this = 6
	possible_transfer_amounts = list(6)
	spillable = TRUE
	list_reagents = null
	sellprice = 30
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/carafe/vibelin/teapot/coral
	name = "aoetal teapot"
	desc = "A dainty teapot carved out of aoetal."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/cooking.dmi'
	icon_state = "teapot_coral"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = NONE
	rogue_grid_width = 32
	rogue_grid_height = 64
	volume = 100
	amount_per_transfer_from_this = 6
	possible_transfer_amounts = list(6)
	spillable = TRUE
	list_reagents = null
	sellprice = 70
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/carafe/vibelin/teapot/gold
	name = "golden teapot"
	desc = "A dainty golden teapot. The perfect item for a noble's tea party."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/precious_objects.dmi'
	icon_state = "teapot_gold"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = NONE
	rogue_grid_width = 32
	rogue_grid_height = 64
	smeltresult = /obj/item/ingot/gold
	volume = 100
	amount_per_transfer_from_this = 6
	possible_transfer_amounts = list(6)
	spillable = TRUE
	list_reagents = null
	sellprice = 65
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/carafe/vibelin/teapot/jade
	name = "joapstone teapot"
	desc = "A dainty teapot carved out of joapstone."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/cooking.dmi'
	icon_state = "teapot_jade"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = NONE
	rogue_grid_width = 32
	rogue_grid_height = 64
	volume = 100
	amount_per_transfer_from_this = 6
	possible_transfer_amounts = list(6)
	spillable = TRUE
	list_reagents = null
	sellprice = 60
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/carafe/vibelin/teapot/opal
	name = "opaloise teapot"
	desc = "A dainty teapot carved out of opaloise."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/cooking.dmi'
	icon_state = "teapot_opal"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = NONE
	rogue_grid_width = 32
	rogue_grid_height = 64
	volume = 100
	amount_per_transfer_from_this = 6
	possible_transfer_amounts = list(6)
	spillable = TRUE
	list_reagents = null
	sellprice = 90
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/carafe/vibelin/teapot/rose
	name = "rosellusk teapot"
	desc = "A dainty teapot carved out of rosellusk."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/cooking.dmi'
	icon_state = "teapot_rose"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = NONE
	rogue_grid_width = 32
	rogue_grid_height = 64
	volume = 100
	amount_per_transfer_from_this = 6
	possible_transfer_amounts = list(6)
	spillable = TRUE
	list_reagents = null
	sellprice = 25
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/carafe/vibelin/teapot/silver
	name = "silver teapot"
	desc = "A dainty silver teapot. The perfect item for a noble's tea party."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/precious_objects.dmi'
	icon_state = "teapot_silv"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = NONE
	rogue_grid_width = 32
	rogue_grid_height = 64
	smeltresult = /obj/item/ingot/silver
	volume = 100
	amount_per_transfer_from_this = 6
	possible_transfer_amounts = list(6)
	spillable = TRUE
	list_reagents = null
	sellprice = 35
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/carafe/vibelin/teapot/turq
	name = "ceruleabaster teapot"
	desc = "A dainty teapot carved out of ceruleabaster."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/cooking.dmi'
	icon_state = "teapot_turq"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = NONE
	rogue_grid_width = 32
	rogue_grid_height = 64
	volume = 100
	amount_per_transfer_from_this = 6
	possible_transfer_amounts = list(6)
	spillable = TRUE
	list_reagents = null
	sellprice = 85
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/cup/vibelin
	abstract_type = /obj/item/reagent_containers/glass/cup/vibelin

/obj/item/reagent_containers/glass/cup/vibelin/clay
	name = "clay cup"
	desc = "A cup made from fired clay."
	icon = 'modular_redtard/items_vibelin/icons/icons/obj/handmade/cup.dmi'
	icon_state = "world"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = NONE
	rogue_grid_width = 32
	rogue_grid_height = 64
	volume = 25
	amount_per_transfer_from_this = 6
	possible_transfer_amounts = list(6)
	spillable = TRUE
	list_reagents = null
	sellprice = 5
	anvilrepair = null
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/cup/vibelin/clay_mug
	name = "clay mug"
	desc = "A mug made from fired clay."
	icon = 'modular_redtard/items_vibelin/icons/icons/obj/handmade/mug.dmi'
	icon_state = "world"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = NONE
	rogue_grid_width = 32
	rogue_grid_height = 64
	volume = 25
	amount_per_transfer_from_this = 6
	possible_transfer_amounts = list(6)
	spillable = TRUE
	list_reagents = null
	sellprice = 1
	anvilrepair = null
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/cup/vibelin/cocaudo_husk
	name = "cocaudo husk"
	desc = "A hollowed out half of a cocaudo. It holds liquid."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/cooking.dmi'
	icon_state = "cocaudo_empty"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = NONE
	rogue_grid_width = 32
	rogue_grid_height = 32
	volume = 25
	amount_per_transfer_from_this = 6
	possible_transfer_amounts = list(6)
	spillable = TRUE
	list_reagents = null
	sellprice = 1
	anvilrepair = null
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/cup/vibelin/fancy_clay
	name = "fancy clay cup"
	desc = "A cup made from fired clay."
	icon = 'modular_redtard/items_vibelin/icons/icons/obj/handmade/cup_fancy.dmi'
	icon_state = "world"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = NONE
	rogue_grid_width = 32
	rogue_grid_height = 64
	volume = 25
	amount_per_transfer_from_this = 6
	possible_transfer_amounts = list(6)
	spillable = TRUE
	list_reagents = null
	sellprice = 1
	anvilrepair = null
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/cup/vibelin/glassware
	name = "glass cup"
	desc = "A fancy glass cup; the few scratches that are upon it tell grand tales of lies and betrayal. It tends to break easily..."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/glass_reagent_container.dmi'
	icon_state = "clear_cup1"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = NONE
	rogue_grid_width = 32
	rogue_grid_height = 64
	volume = 25
	amount_per_transfer_from_this = 6
	possible_transfer_amounts = list(6)
	spillable = TRUE
	list_reagents = null
	sellprice = 24
	anvilrepair = null
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/cup/vibelin/glassware/shotglass
	name = "shot glass"
	desc = "A fancy shot glass; the few scratches that are upon it tell grand tales of lies and betrayal. It tends to break easily..."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/glass_reagent_container.dmi'
	icon_state = "clear_shotglass1"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = NONE
	rogue_grid_width = 32
	rogue_grid_height = 32
	volume = 5
	amount_per_transfer_from_this = 6
	possible_transfer_amounts = list(6)
	spillable = TRUE
	list_reagents = null
	sellprice = 18
	anvilrepair = null
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/glass/cup/vibelin/glassware/wineglass
	name = "wine glass"
	desc = "A fancy wine glass; the few scratches that are upon it tell grand tales of lies and betrayal. It tends to break easily..."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/glass_reagent_container.dmi'
	icon_state = "clear_wineglass1"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = NONE
	rogue_grid_width = 32
	rogue_grid_height = 64
	volume = 25
	amount_per_transfer_from_this = 6
	possible_transfer_amounts = list(6)
	spillable = TRUE
	list_reagents = null
	sellprice = 24
	anvilrepair = null
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/powder/vibelin
	abstract_type = /obj/item/reagent_containers/powder/vibelin

/obj/item/reagent_containers/powder/vibelin/herbs
	name = "herbs and spices"
	desc = "A bunch of herbs and spices mixed together."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/produce.dmi'
	icon_state = "flour"
	w_class = WEIGHT_CLASS_TINY
	color = "#B7D993"
	slot_flags = NONE
	rogue_grid_width = 32
	rogue_grid_height = 32
	volume = 1
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = 0
	spillable = FALSE
	list_reagents = list(/datum/reagent/ash = 1)
	sellprice = 10
	inhand_icon_state = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	lefthand_file = null
	righthand_file = null
	rogue_baked_inhand = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32
