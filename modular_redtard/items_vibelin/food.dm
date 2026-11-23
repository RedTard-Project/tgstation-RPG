// Written by modular_redtard/tools/port_vibelin_food.py from modular_redtard/items_vibelin/food_port.json; do not edit by hand.
// Vibelin's own food (H2g): dishes, dough, produce and meat under the module's food (survival/: TG edible, grill and oven, Ratwood's bites, rot, slicing and recipes).
// Numbers (integrity, force, throw force) live in the private mechanics/items.txt.

/obj/item/reagent_containers/food/snacks/vibelin
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin

/obj/item/reagent_containers/food/snacks/vibelin/apple_dried
	name = "dried apple"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "driedapple"
	w_class = WEIGHT_CLASS_TINY
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 1.688, /datum/reagent/consumable/nutriment/vitamin = 0.562)
	foodtypes = FRUIT
	tastes = list("dried fruit" = 1)
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/blackberrybutterdough
	name = "blackberry butterdough"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "butterdough_blackberry"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 7.875, /datum/reagent/consumable/nutriment/vitamin = 2.625)
	foodtypes = GRAIN | RAW | DAIRY | FRUIT
	tastes = list("buttery dough" = 1, "dried blackberries" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/blackberrybookbread
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "fresh baked pastry"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/bookbreadslice
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/bookbreadslice

/obj/item/reagent_containers/food/snacks/vibelin/bookbreadslice/jacksberry
	name = "sliced raisin bookbread"
	desc = "Has an earthy taste that reminds the eater of growth cycles and rainfall percentages. Like a delicious almanac."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "jacksberry_bookbread_slice"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.419, /datum/reagent/consumable/nutriment/vitamin = 0.806)
	foodtypes = GRAIN | DAIRY | FRUIT
	tastes = list("chewy butterdough" = 1, "raisins" = 1)
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/bread
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/bread

/obj/item/reagent_containers/food/snacks/vibelin/bread/bookbread
	name = "bookbread"
	desc = "On the days when Noc's reign lengthens to its apex, all proper Ten fearing folk huddle by their warm hearths, exchanging both books and pastries such as this."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "bookbread"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 9.281, /datum/reagent/consumable/nutriment/vitamin = 3.094)
	foodtypes = GRAIN | DAIRY
	tastes = list("chewy butterdough" = 1)
	bitesize = 4
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/bookbread_slice
	slices_num = 5
	slice_batch = FALSE
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/bread/bookbread/jacksberry
	name = "raisin bookbread"
	desc = "As Nocsmas gained broader appeal, more and more commonfolk with poor access to books instead chose to simply forego their exchanging, focusing instead on the preparation of food."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "jacksberry_bookbread"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 9.844, /datum/reagent/consumable/nutriment/vitamin = 3.281)
	foodtypes = GRAIN | DAIRY | FRUIT
	tastes = list("chewy butterdough" = 1, "raisins" = 1)
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/bookbreadslice/jacksberry
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/bread/ribrack
	name = "cooked rib rack"
	desc = "Meat that's still attatched to the bone, so you can both feel like a beast AND keep your fingers clean."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "ribs"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 6.75, /datum/reagent/consumable/nutriment/vitamin = 2.25)
	foodtypes = MEAT
	tastes = list("supple cooked meat" = 1)
	bitesize = 5
	rotprocess = 18000
	become_rot_type = /obj/item/reagent_containers/food/snacks/vibelin/stale_bread
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/cooked/rib
	slices_num = 6
	slice_batch = FALSE
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/bread/ribrack/honey
	name = "glazed rib rack"
	desc = "Sometimes even Graggarites want some luxury."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "honey_ribs"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 9, /datum/reagent/consumable/nutriment/vitamin = 3)
	foodtypes = MEAT | SUGAR
	tastes = list("supple cooked meat" = 1, "honey glaze" = 1)
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/cooked/rib/honey
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/breadslice
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/breadslice

/obj/item/reagent_containers/food/snacks/vibelin/breadslice/raisin
	name = "raisinbread slice"
	desc = "A bit of comfort to start your dae."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "raisinbread_slice"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 1.688, /datum/reagent/consumable/nutriment/vitamin = 0.562)
	foodtypes = GRAIN | FRUIT
	tastes = list("bread" = 1, "dried fruit" = 1)
	rotprocess = 54000
	become_rot_type = /obj/item/reagent_containers/food/snacks/vibelin/rotten/breadslice
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cheese
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/cheese

/obj/item/reagent_containers/food/snacks/vibelin/cheese/gote
	name = "fresh gote cheese"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "freshcheese"
	w_class = WEIGHT_CLASS_TINY
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.531, /datum/reagent/consumable/nutriment/vitamin = 0.844)
	foodtypes = DAIRY
	tastes = list("cheese" = 1)
	bitesize = 1
	rotprocess = 18000
	rogue_faretype = ROGUE_FARE_POOR
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/chescake
	name = "cheesecake base"
	desc = "With this sweet thing, you shall make them sing. Lacking fresh cheese glazing."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "cake_filled"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 11.25, /datum/reagent/consumable/nutriment/vitamin = 3.75)
	foodtypes = GRAIN | DAIRY | EGG | RAW
	eat_effect = /datum/status_effect/rogue_food/uncooked
	rotprocess = 30000
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/chip
	name = "sun-crackers"
	desc = "A single sun-cracker. Great for dipping."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "chip"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 0.675, /datum/reagent/consumable/nutriment/vitamin = 0.225)
	foodtypes = GRAIN
	tastes = list("crunchy sunreed dough" = 1)
	bitesize = 1
	rogue_faretype = ROGUE_FARE_POOR
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/chip_cocaumole
	name = "cocaumole dipped sun-cracker"
	desc = "A single sun-cracker. Dipped in savory cocaumole."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "chip_cocaumole"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 1.519, /datum/reagent/consumable/nutriment/vitamin = 0.506)
	foodtypes = GRAIN
	tastes = list("crunchy sunreed dough" = 1, "savory goo" = 1)
	bitesize = 1
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/chip_drowsbane
	name = "drowsbane dipped sun-cracker"
	desc = "A single sun-cracker. Dipped in spicy drowsbane."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "chip_salsa"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 1.519, /datum/reagent/consumable/nutriment/vitamin = 0.506)
	foodtypes = GRAIN
	tastes = list("crunchy sunreed dough" = 1, "infernal spice" = 1)
	bitesize = 1
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/chippile
	name = "sun-crackers"
	desc = "A pile of crunchy sun-crackers."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "chippile"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 3.375, /datum/reagent/consumable/nutriment/vitamin = 1.125)
	foodtypes = GRAIN
	tastes = list("crunchy sunreed dough" = 1)
	bitesize = 4
	rogue_faretype = ROGUE_FARE_POOR
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/chippile/cocaumole
	name = "cocaumole smothered sun-crackers"
	desc = "A pile of crunchy sun-crackers, smothered in savory cocaumole."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "chippile_cocaumole"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 7.594, /datum/reagent/consumable/nutriment/vitamin = 2.531)
	tastes = list("crunchy sunreed dough" = 1, "savory goo" = 1)
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/chippile/drowsbane
	name = "drowsbane smothered sun-crackers"
	desc = "A pile of crunchy sun-crackers, smothered in spicy drowsbane."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "chippile_salsa"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 7.594, /datum/reagent/consumable/nutriment/vitamin = 2.531)
	tastes = list("crunchy sunreed dough" = 1, "infernal spice" = 1)
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/choccy_chip_dough
	name = "chocolate chip cookie dough"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "butterdough"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 9, /datum/reagent/consumable/nutriment/vitamin = 3)
	foodtypes = GRAIN | RAW | DAIRY | SUGAR
	tastes = list("buttery dough" = 1, "rich chocolate" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	rotprocess = 18000
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/choccy_cookie_raw
	slices_num = 4
	rogue_faretype = ROGUE_FARE_POOR
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/choccy_cookie
	name = "chocolate chip cookie"
	desc = "Salty cookie and sweet chocolate meet in this treat."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "cookie"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 5.906, /datum/reagent/consumable/nutriment/vitamin = 1.969)
	foodtypes = GRAIN | DAIRY | SUGAR
	tastes = list("chewy butterdough" = 1, "rich chocolate" = 1)
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/choccy_cookie_raw
	name = "unbaked chocolate chip cookie"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "uncookedcookie"
	w_class = WEIGHT_CLASS_TINY
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 5.906, /datum/reagent/consumable/nutriment/vitamin = 1.969)
	foodtypes = GRAIN | RAW | DAIRY | SUGAR
	tastes = list("buttery dough" = 1, "rich chocolate" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/choccy_cookie
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "fresh baked pastry"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/choco_bun
	name = "chocolate bun"
	desc = "A rich chocolate bun, buttery and sweet."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "bunchoc"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 5.906, /datum/reagent/consumable/nutriment/vitamin = 1.969)
	foodtypes = GRAIN | DAIRY | SUGAR
	tastes = list("chewy butterdough" = 1, "rich chocolate" = 1)
	rogue_faretype = ROGUE_FARE_LAVISH
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/choco_bun_raw
	name = "unbaked chocolate bun"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "butterdoughslicechoc"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 5.906, /datum/reagent/consumable/nutriment/vitamin = 1.969)
	foodtypes = GRAIN | RAW | DAIRY
	tastes = list("buttery dough" = 1, "rich chocolate" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/choco_bun
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "fresh baked buns"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/choco_butterdough_slice
	name = "unbaked chocolate pastry"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "butterdoughslicechoc"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 5.906, /datum/reagent/consumable/nutriment/vitamin = 1.969)
	foodtypes = GRAIN | RAW | DAIRY
	tastes = list("buttery dough" = 1, "rich chocolate" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/choco_pastry
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "fresh baked pastry"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/choco_pastry
	name = "chocolate pastry"
	desc = "A flaky pastry filled with rich chocolate."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pastrychoc"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 5.906, /datum/reagent/consumable/nutriment/vitamin = 1.969)
	foodtypes = GRAIN | DAIRY | SUGAR
	tastes = list("buttery pastry" = 1, "rich chocolate" = 1)
	rogue_faretype = ROGUE_FARE_LAVISH
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/chocolate
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/chocolate

/obj/item/reagent_containers/food/snacks/vibelin/chocolate/chunk
	name = "chocolate chunk"
	desc = "Unbelievably fancy chocolate, imported all the way from distant Grenzelhoft"
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "chocolatechopped"
	w_class = WEIGHT_CLASS_TINY
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 0.938, /datum/reagent/consumable/nutriment/vitamin = 0.312)
	foodtypes = SUGAR | JUNKFOOD
	tastes = list("chocolate" = 1)
	bitesize = 1
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/chocolate_carp
	name = "le carp au chocolat"
	desc = "Plundered Grenzelhoftian chocolate drizzled over fish, this abomination is a delicacy to dark elves. In this case the eyeless cave fish has been substituted for a carp."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "chocolatecarp"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 9.562, /datum/reagent/consumable/nutriment/vitamin = 3.188)
	foodtypes = GRAIN
	tastes = list("a horrible clash of salty fish and sweet chocolate" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	bitesize = 4
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/chocolatebutterdough
	name = "chocolate butterdough"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "butterdough_chocolate"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 9, /datum/reagent/consumable/nutriment/vitamin = 3)
	foodtypes = GRAIN | RAW | DAIRY | SUGAR
	tastes = list("buttery dough" = 1, "rich chocolate" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/chocolatebookbread
	cooktime = 250
	rotprocess = 18000
	rogue_faretype = ROGUE_FARE_POOR
	rogue_cooked_smell = "fresh baked pastry"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cocaumole
	name = "cocaumole"
	desc = "The delicious gooey inside of a cocaudo. Makes for great topping."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "cocaumole"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.812, /datum/reagent/consumable/nutriment/vitamin = 0.938)
	foodtypes = VEGETABLES
	tastes = list("savory goo" = 1)
	rotprocess = 18000
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/cocaumole/slice
	slices_num = 3
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_portable = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cocaumole/slice
	name = "cocaumole slice"
	desc = "The delicious gooey inside of a cocaudo. Makes for great topping."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "cocaumole_slice"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 0.938, /datum/reagent/consumable/nutriment/vitamin = 0.312)
	bitesize = 1
	slice_path = null
	slices_num = 0
	slice_batch = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/comelette_base
	name = "omelette base"
	desc = "All it needs now is some potato slices, for a perfect texture."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "comelette_base"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 0.75, /datum/reagent/consumable/nutriment/vitamin = 0.25)
	foodtypes = EGG | RAW
	rotprocess = 18000
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/comelette_slice
	name = "caravaneer's omelette slice"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "comelette_slice"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 3.188, /datum/reagent/consumable/nutriment/vitamin = 1.062)
	foodtypes = EGG | VEGETABLES
	tastes = list("fried cackleberries" = 1, "potato" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	rotprocess = 30000
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/comelette_slice/meat
	name = "caravaneer's omelette slice"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "meat_comelette_slice"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 3.281, /datum/reagent/consumable/nutriment/vitamin = 1.094)
	foodtypes = EGG | VEGETABLES | MEAT
	tastes = list("fried cackleberries" = 1, "potato" = 1, "succulant meat" = 1)
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/comelette_slice/veggie
	name = "caravaneer's omelette slice"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "veggie_comelette_slice"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	tastes = list("fried cackleberries" = 1, "potato" = 1, "caramalized onions" = 1)
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/comelette_uncooked
	name = "uncooked caravaneer's omelette"
	desc = "Eggs and potatoes in alternating tiers, could do with some meat or onions, or a bit of time in the oven."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "comelette_raw"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 0.75, /datum/reagent/consumable/nutriment/vitamin = 0.25)
	foodtypes = EGG | VEGETABLES | RAW
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/cooked/comelette
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "fried egg"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/comelette_uncooked/meat
	name = "uncooked meat caravaneer's omelette"
	desc = "Eggs and potatoes in alternating tiers, could do with a bit of time in the oven."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "meat_comelette_raw"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	foodtypes = EGG | VEGETABLES | MEAT | RAW
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/cooked/comelette/meat
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/comelette_uncooked/veggie
	name = "uncooked veggie caravaneer's omelette"
	desc = "Eggs and potatoes in alternating tiers, could do with a bit of time in the oven."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "veggie_comelette_raw"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/cooked/comelette/veggie
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cooked
	name = "cooked meat"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "frysteak"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 6.75, /datum/reagent/consumable/nutriment/vitamin = 2.25)
	foodtypes = MEAT
	rotprocess = 18000
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cooked/comelette
	name = "caraveneer's omelette"
	desc = "The very best breakfast for sharing amongst family and friends."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "comelette"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 16.312, /datum/reagent/consumable/nutriment/vitamin = 5.438)
	foodtypes = EGG | VEGETABLES
	tastes = list("fried cackleberries" = 1, "potato" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	bitesize = 6
	rotprocess = 30000
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/comelette_slice
	slices_num = 6
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cooked/comelette/meat
	name = "caraveneer's omelette"
	desc = "The very best breakfast for sharing amongst family and friends, with little bits of meat."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "meat_comelette"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 19.688, /datum/reagent/consumable/nutriment/vitamin = 6.562)
	foodtypes = EGG | VEGETABLES | MEAT
	tastes = list("fried cackleberries" = 1, "potato" = 1, "succulant meat" = 1)
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/comelette_slice/meat
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cooked/comelette/veggie
	name = "caraveneer's omelette"
	desc = "The very best breakfast for sharing amongst family and friends, with extra bits of onion."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "veggie_comelette"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 19.125, /datum/reagent/consumable/nutriment/vitamin = 6.375)
	tastes = list("fried cackleberries" = 1, "potato" = 1, "caramalized onions" = 1)
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/comelette_slice/veggie
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cooked/frybird_tatos
	name = "frybird and tatos"
	desc = "Poultry scorched to a perfect delicious crisp. Some warm tatos accompany it."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "frybirdtato"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 10.688, /datum/reagent/consumable/nutriment/vitamin = 3.562)
	foodtypes = MEAT | VEGETABLES
	tastes = list("frybird" = 1, "warm tato" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	bitesize = 5
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cooked/frysteak_onion
	name = "frysteak and onions"
	desc = "A slab of beastflesh, fried to a perfect medium-rare. Garnished with tender fried onion, juices made into a simple sauce."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "onionsteak"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 10.312, /datum/reagent/consumable/nutriment/vitamin = 3.438)
	foodtypes = MEAT | VEGETABLES
	tastes = list("roasted meat" = 1, "caramelized onions" = 1)
	bitesize = 5
	rogue_portable = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cooked/frysteak_salsa
	name = "frysteak and drowsbane"
	desc = "A slab of beastflesh, fried to a perfect medium-rare. It has been seasoned with highly-spicy drowsbane."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "steak_salsa"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 9.562, /datum/reagent/consumable/nutriment/vitamin = 3.188)
	foodtypes = MEAT | VEGETABLES
	tastes = list("warm steak" = 1, "infernal spice" = 1)
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cooked/frysteak_tatos
	name = "frysteak and potato"
	desc = "A slab of beastflesh, fried to a perfect medium-rare. Served with potatos, this will nourish even a starving volf."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "potatosteak"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 10.312, /datum/reagent/consumable/nutriment/vitamin = 3.438)
	foodtypes = MEAT | VEGETABLES
	tastes = list("roasted meat" = 2, "potato" = 1)
	bitesize = 4
	rogue_portable = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cooked/griddledog
	name = "griddledog"
	desc = "A classic piece of Grenzelhoftian street food, the fried butterdough is a Vanderlinian adulteration."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "griddledog"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 12.516, /datum/reagent/consumable/nutriment/vitamin = 4.172)
	foodtypes = GRAIN | MEAT
	tastes = list("savory sausage" = 2, "crispy butterdough" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	rotprocess = 54000
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cooked/ham
	name = "ham"
	desc = "A trufflepig's retirement plan."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "ham"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 7.875, /datum/reagent/consumable/nutriment/vitamin = 2.625)
	become_rot_type = /obj/item/reagent_containers/food/snacks/vibelin/rotten/bacon
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cooked/herbbird
	name = "herbird"
	desc = "Poultry scorched to a perfect delicious crisp. It has been seasoned with herbs."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "frybird"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 8.625, /datum/reagent/consumable/nutriment/vitamin = 2.875)
	foodtypes = MEAT | VEGETABLES
	tastes = list("frybird" = 1, "herbs" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cooked/herbsteak
	name = "herbsteak"
	desc = "A slab of beastflesh, fried to a perfect medium-rare. It has been seasoned with herbs."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "frysteak"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 9.562, /datum/reagent/consumable/nutriment/vitamin = 3.188)
	foodtypes = MEAT | VEGETABLES
	tastes = list("warm steak" = 1, "herbs" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cooked/rib
	name = "rib"
	desc = "A single rib, the meat easily falls off the bone."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "ribs_slice"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 1.125, /datum/reagent/consumable/nutriment/vitamin = 0.375)
	tastes = list("supple cooked meat" = 1)
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cooked/rib/honey
	name = "glazed rib"
	desc = "A single glazed rib, the meat easily falls off the bone."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "honey_ribs_slice"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 1.5, /datum/reagent/consumable/nutriment/vitamin = 0.5)
	foodtypes = MEAT | SUGAR
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cooked/royal_truffle
	name = "royal truffles"
	desc = "The height of decadence, a precious truffle pig, turned into an amusing meal, served on a bed of its beloved golden truffles."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "royaltruffles"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 10.688, /datum/reagent/consumable/nutriment/vitamin = 3.562)
	tastes = list("salted ham" = 1, "divine truffles" = 1)
	bitesize = 5
	become_rot_type = /obj/item/reagent_containers/food/snacks/vibelin/rotten/bacon
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cooked/sausage
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/cooked/sausage

/obj/item/reagent_containers/food/snacks/vibelin/cooked/sausage/wiener
	name = "wiener"
	desc = "Delicious flesh stuffed in an intestine casing."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "wiener"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 7.875, /datum/reagent/consumable/nutriment/vitamin = 2.625)
	tastes = list("savory sausage" = 2)
	rotprocess = 54000
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cooked/sausage_cocaumole
	name = "wiener with cocaumole"
	desc = "Stout and savory."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "wiener_cocaumole"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 10.688, /datum/reagent/consumable/nutriment/vitamin = 3.562)
	foodtypes = VEGETABLES | MEAT
	tastes = list("savory goo" = 1)
	bitesize = 5
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cooked/sausage_sticked
	name = "sausage onna stick"
	desc = "A sausage skewered for convenience and cleanliness, classic Grenzelhoftian street food."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "sausageonastick"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 7.875, /datum/reagent/consumable/nutriment/vitamin = 2.625)
	tastes = list("savory sausage" = 2)
	bitesize = 4
	rotprocess = 54000
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cooked/smoked_meat
	name = "smoked meat"
	desc = "A slab of flesh cured slow over smouldering wood. Keeps for a season, tastes of the fire that made it."
	icon = 'modular_redtard/items_vibelin/icons/modular_abel/dun_world/icons/cooked_meat.dmi'
	icon_state = "meat_smoked"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	tastes = list("smoky meat" = 1)
	rotprocess = 54000
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cooked/strange
	name = "fried strange meat"
	desc = "Whatever it was, it's roasted."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "fried_strange"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 3.375, /datum/reagent/consumable/nutriment/vitamin = 1.125)
	rogue_faretype = ROGUE_FARE_POOR
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cooked/truffle
	name = "cooked truffles"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/produce.dmi'
	icon_state = "mushroom1_full"
	w_class = WEIGHT_CLASS_SMALL
	color = "#835b4f"
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 3.562, /datum/reagent/consumable/nutriment/vitamin = 1.188)
	tastes = list("delicious truffles" = 2)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cooked/twin_egg
	name = "fried egg twins"
	desc = "A staple of Astratan midsummer festival eating. There are two of them."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "seggs"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 13.5, /datum/reagent/consumable/nutriment/vitamin = 4.5)
	foodtypes = EGG
	tastes = list("fried egg" = 1)
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/cooked/valorian_omlette
	name = "valorian omelette"
	desc = "Fried cackleberries on a bed of half-melted cheese, a dish from distant lands."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "omelette"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 17.297, /datum/reagent/consumable/nutriment/vitamin = 5.766)
	foodtypes = EGG | DAIRY
	tastes = list("fried cackleberries" = 1, "cheese" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	bitesize = 5
	rogue_faretype = ROGUE_FARE_FINE
	rogue_portable = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/crimsoncake
	name = "crimson pine cake base"
	desc = "With this sweet thing, you shall make them sing. Lacking chocolate bits."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "cake_filled"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 12.938, /datum/reagent/consumable/nutriment/vitamin = 4.312)
	foodtypes = GRAIN | DAIRY | FRUIT | RAW | EGG
	eat_effect = /datum/status_effect/rogue_food/uncooked
	rotprocess = 18000
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/crimsoncake_cooked
	name = "crimson pine cake"
	desc = "A fusion of Crimson Elf and Grenzelhoftian cuisines, the cake originates from the Valorian Republics. Rumor has it that one of the many casus belli in the Republics was based upon a disagreement on the cakes exact recipe."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "crimsonpinecake"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 23.625, /datum/reagent/consumable/nutriment/vitamin = 7.875, /datum/reagent/consumable/ethanol/plum_wine = 31.5)
	foodtypes = GRAIN | DAIRY | FRUIT | EGG | SUGAR | JUNKFOOD
	tastes = list("cake" = 1, "chocolate" = 1, "plum" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	rotprocess = 54000
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/crimsoncake_slice
	slices_num = 6
	rogue_faretype = ROGUE_FARE_LAVISH
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/crimsoncake_ready
	name = "unbaked crimson pine cake"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "crimsonpinecakeraw"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 15.75, /datum/reagent/consumable/nutriment/vitamin = 5.25)
	foodtypes = GRAIN | DAIRY | FRUIT | RAW | EGG | SUGAR
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/crimsoncake_cooked
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "fresh baked crimson pine cake"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/crimsoncake_slice
	name = "crimson pine cake slice"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "crimsonpinecakeslice"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 3.938, /datum/reagent/consumable/nutriment/vitamin = 1.312)
	foodtypes = GRAIN | DAIRY | FRUIT | EGG | SUGAR | JUNKFOOD
	tastes = list("cake" = 1, "chocolate" = 1, "plum" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	bitesize = 2
	rotprocess = 18000
	rogue_faretype = ROGUE_FARE_LAVISH
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/dottart_lemon
	name = "lemon dot tart"
	desc = "A small lemon jam-filled pastry, for when a whole pie would be inapropriate for canapes."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "lemon_dottart"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 8.016, /datum/reagent/consumable/nutriment/vitamin = 2.672)
	foodtypes = GRAIN | DAIRY | FRUIT
	tastes = list("crispy butterdough" = 1, "lemon jam" = 1)
	bitesize = 2
	rotprocess = 30000
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/dottart_lime
	name = "lime dot tart"
	desc = "A small lime jam-filled pastry, for when a whole pie would be inapropriate for canapes."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "lime_dottart"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 8.016, /datum/reagent/consumable/nutriment/vitamin = 2.672)
	foodtypes = GRAIN | DAIRY | FRUIT
	tastes = list("crispy butterdough" = 1, "lime jam" = 1)
	bitesize = 2
	rotprocess = 30000
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/drowsbanejam
	name = "drowsbane jam"
	desc = "A tantalizingly spicy jam. Incredibly toxic to dark-elves."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "salsa"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.812, /datum/reagent/consumable/nutriment/vitamin = 0.938)
	foodtypes = VEGETABLES
	tastes = list("infernal spice" = 1)
	rotprocess = 18000
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/drowsbanejam/slice
	slices_num = 3
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_portable = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/drowsbanejam/slice
	name = "drowsbane jam slice"
	desc = "A tantalizingly spicy jam. Incredibly toxic to dark-elves."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "salsa_slice"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 0.938, /datum/reagent/consumable/nutriment/vitamin = 0.312)
	bitesize = 1
	slice_path = null
	slices_num = 0
	slice_batch = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/eighthscake
	name = "eighthscake"
	desc = "Moulded to count out eight exactly rationed slices, because even the desperate want desert."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "eighthscake"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 16.031, /datum/reagent/consumable/nutriment/vitamin = 5.344)
	foodtypes = GRAIN | JUNKFOOD | EGG
	tastes = list("sweet sunreed dough" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	rotprocess = 54000
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/eighthscake_slice
	slices_num = 8
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/eighthscake/lemon
	name = "lemon eighthscake"
	desc = "Moulded to count out eight exactly rationed slices, because even the desperate want desert. This one has splendid little bits of lemon and glaze."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "lemon_eighthscake"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 19.406, /datum/reagent/consumable/nutriment/vitamin = 6.469)
	foodtypes = GRAIN | JUNKFOOD | EGG | FRUIT
	tastes = list("sweet sunreed dough" = 1, "lemon glaze" = 1)
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/eighthscake_slice/lemon
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/eighthscake/lime
	name = "lime eighthscake"
	desc = "Moulded to count out eight exactly rationed slices, because even the desperate want desert. This one has splendid little bits of lime and glaze."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "lemon_eighthscake"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 19.406, /datum/reagent/consumable/nutriment/vitamin = 6.469)
	foodtypes = GRAIN | JUNKFOOD | EGG | FRUIT
	tastes = list("sweet sunreed dough" = 1, "lime glaze" = 1)
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/eighthscake_slice/lime
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/eighthscake_slice
	name = "eighthscake slice"
	desc = "A perfectly rationed eighth of an eighthscake."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "eighthscake_slice"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.004, /datum/reagent/consumable/nutriment/vitamin = 0.668)
	foodtypes = GRAIN | JUNKFOOD | EGG
	tastes = list("sweet sunreed dough" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	rotprocess = 54000
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/eighthscake_slice/lemon
	name = "lemon eighthscake slice"
	desc = "A perfectly rationed eighth of an eighthscake. This one has splendid little bits of lemon and glaze."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "lemon_eighthscake_slice"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.426, /datum/reagent/consumable/nutriment/vitamin = 0.809)
	foodtypes = GRAIN | JUNKFOOD | EGG | FRUIT
	tastes = list("sweet sunreed dough" = 1, "lemon glaze" = 1)
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/eighthscake_slice/lime
	name = "lime eighthscake slice"
	desc = "A perfectly rationed eighth of an eighthscake. This one has splendid little bits of lime and glaze."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "lemon_eighthscake_slice"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.426, /datum/reagent/consumable/nutriment/vitamin = 0.809)
	foodtypes = GRAIN | JUNKFOOD | EGG | FRUIT
	tastes = list("sweet sunreed dough" = 1, "lime glaze" = 1)
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/eighthscake_unbaked
	name = "eighthscake base"
	desc = "Life is all about its small joys."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "eighthscake_uncooked"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 10.688, /datum/reagent/consumable/nutriment/vitamin = 3.562)
	foodtypes = GRAIN | EGG | RAW
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/eighthscake
	cooktime = 250
	rotprocess = 30000
	rogue_cooked_smell = "fresh baked sunreed"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/eighthscake_unbaked/lemon
	name = "unbaked lemon eighthscake"
	desc = "Life is all about its small joys."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "lemon_eighthscake_uncooked"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 12.938, /datum/reagent/consumable/nutriment/vitamin = 4.312)
	foodtypes = GRAIN | FRUIT | RAW | EGG
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/eighthscake/lemon
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/eighthscake_unbaked/lime
	name = "unbaked lime eighthscake"
	desc = "Life is all about its small joys."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "lime_eighthscake_uncooked"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 12.938, /datum/reagent/consumable/nutriment/vitamin = 4.312)
	foodtypes = GRAIN | FRUIT | RAW | EGG
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/eighthscake/lime
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/estrella
	name = "estrella"
	desc = "A sunreed pastry moulded into a star shape, delightful to children everywhere."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "estrella"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 3.375, /datum/reagent/consumable/nutriment/vitamin = 1.125)
	foodtypes = GRAIN
	tastes = list("semi-sweet bread" = 1)
	rotprocess = 30000
	rogue_faretype = ROGUE_FARE_POOR
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/applegriddlecake_raw
	name = "raw apple griddlecake"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "rawgriddlecakeapple"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 9.844, /datum/reagent/consumable/nutriment/vitamin = 3.281)
	foodtypes = GRAIN | DAIRY | RAW | EGG | FRUIT
	eat_effect = /datum/status_effect/rogue_food/uncooked
	fried_type = /obj/item/reagent_containers/food/snacks/vibelin/griddlecake/apple
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "freshly fried griddle cake"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/berrygriddlecake_raw
	name = "raw jacksberry griddlecake"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "rawgriddlecakeberry"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 8.156, /datum/reagent/consumable/nutriment/vitamin = 2.719)
	foodtypes = GRAIN | DAIRY | RAW | EGG | FRUIT
	eat_effect = /datum/status_effect/rogue_food/uncooked
	fried_type = /obj/item/reagent_containers/food/snacks/vibelin/griddlecake/berry
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "freshly fried griddle cake"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/dottart_base
	name = "unfilled dot tart"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "dottart_base"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 3.094, /datum/reagent/consumable/nutriment/vitamin = 1.031)
	foodtypes = GRAIN | DAIRY | RAW
	eat_effect = /datum/status_effect/rogue_food/uncooked
	rotprocess = 18000
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/dottart_base/blackberry
	name = "raw blackberry dot tart"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "blackberry_dottart_base"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 5.344, /datum/reagent/consumable/nutriment/vitamin = 1.781)
	foodtypes = GRAIN | DAIRY | RAW | FRUIT
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/blackberry
	cooktime = 250
	rogue_cooked_smell = "fresh baked pastry"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/dottart_base/lemon
	name = "raw lemon dot tart"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "lemon_dottart_base"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 5.344, /datum/reagent/consumable/nutriment/vitamin = 1.781)
	foodtypes = GRAIN | DAIRY | RAW | FRUIT
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/dottart_lemon
	cooktime = 250
	rogue_cooked_smell = "fresh baked pastry"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/dottart_base/lime
	name = "raw lime dot tart"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "lime_dottart_base"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 5.344, /datum/reagent/consumable/nutriment/vitamin = 1.781)
	foodtypes = GRAIN | DAIRY | RAW | FRUIT
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/dottart_lime
	cooktime = 250
	rogue_cooked_smell = "fresh baked pastry"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/dottart_base/pear
	name = "raw pear dot tart"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pear_dottart_base"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 5.344, /datum/reagent/consumable/nutriment/vitamin = 1.781)
	foodtypes = GRAIN | DAIRY | RAW | FRUIT
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/pear
	cooktime = 250
	rogue_cooked_smell = "fresh baked pastry"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/dottart_base/plum
	name = "raw plum dot tart"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "plum_dottart_base"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 5.344, /datum/reagent/consumable/nutriment/vitamin = 1.781)
	foodtypes = GRAIN | DAIRY | RAW | FRUIT
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/plum
	cooktime = 250
	rogue_cooked_smell = "fresh baked pastry"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/dottart_base/raspberry
	name = "raw raspberry dot tart"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "raspberry_dottart_base"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 5.344, /datum/reagent/consumable/nutriment/vitamin = 1.781)
	foodtypes = GRAIN | DAIRY | RAW | FRUIT
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/raspberry
	cooktime = 250
	rogue_cooked_smell = "fresh baked pastry"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/dottart_base/strawberry
	name = "raw strawberry dot tart"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "strawberry_dottart_base"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 5.344, /datum/reagent/consumable/nutriment/vitamin = 1.781)
	foodtypes = GRAIN | DAIRY | RAW | FRUIT
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/strawberry
	cooktime = 250
	rogue_cooked_smell = "fresh baked pastry"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/dottart_base/tangerine
	name = "raw tangerine dot tart"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "tangerine_dottart_base"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 5.344, /datum/reagent/consumable/nutriment/vitamin = 1.781)
	foodtypes = GRAIN | DAIRY | RAW | FRUIT
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/tangerine
	cooktime = 250
	rogue_cooked_smell = "fresh baked pastry"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/fritter_raw
	name = "uncooked apple fritter"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "applefritterraw"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 5.344, /datum/reagent/consumable/nutriment/vitamin = 1.781)
	foodtypes = GRAIN | DAIRY | RAW | FRUIT
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/fritter
	cooktime = 250
	rogue_cooked_smell = "fresh baked apple fritter"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/griddlecake_raw
	name = "raw griddlecake"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "rawgriddlecake"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 7.594, /datum/reagent/consumable/nutriment/vitamin = 2.531)
	foodtypes = GRAIN | DAIRY | RAW | EGG
	eat_effect = /datum/status_effect/rogue_food/uncooked
	fried_type = /obj/item/reagent_containers/food/snacks/vibelin/griddlecake
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "freshly fried griddle cake"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/griddledog_raw
	name = "uncooked griddledog"
	desc = "A sausage covered with dough, begging to be fried."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "rawgriddledog"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 7.594, /datum/reagent/consumable/nutriment/vitamin = 2.531)
	foodtypes = GRAIN | MEAT | RAW
	tastes = list("savory sausage" = 2, "butterdough" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	fried_type = /obj/item/reagent_containers/food/snacks/vibelin/cooked/griddledog
	cooktime = 250
	rotprocess = 54000
	rogue_faretype = ROGUE_FARE_POOR
	rogue_cooked_smell = "cooked sausage"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/huskbunbase
	name = "sunreed husk"
	desc = "Sunreed dough nested in its former husk, all that's left is to add filling."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "huskbun_husk"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.25, /datum/reagent/consumable/nutriment/vitamin = 0.75)
	foodtypes = GRAIN
	eat_effect = /datum/status_effect/rogue_food/uncooked
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/huskbunraw
	name = "raw huskbun"
	desc = "The husk helps cook it, and adds to the taste."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "huskbun_raw"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.25, /datum/reagent/consumable/nutriment/vitamin = 0.75)
	foodtypes = GRAIN
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/huskbun
	cooktime = 250
	rogue_cooked_smell = "fresh baked sunreed"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/lemongriddlecake_raw
	name = "raw lemon griddlecake"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "rawgriddlecakelemon"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 9.844, /datum/reagent/consumable/nutriment/vitamin = 3.281)
	foodtypes = GRAIN | DAIRY | RAW | EGG | FRUIT
	eat_effect = /datum/status_effect/rogue_food/uncooked
	fried_type = /obj/item/reagent_containers/food/snacks/vibelin/griddlecake/lemon
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "freshly fried griddle cake"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/saigaita
	name = "saigaita"
	desc = "Food-wrap for long travels, perfectly portable."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "lilsaiga_uncooked"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.25, /datum/reagent/consumable/nutriment/vitamin = 0.75)
	foodtypes = GRAIN
	eat_effect = /datum/status_effect/rogue_food/uncooked
	fried_type = /obj/item/reagent_containers/food/snacks/vibelin/saigaita_cooked
	cooktime = 250
	rogue_faretype = ROGUE_FARE_POOR
	rogue_cooked_smell = "fresh baked sunreed"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/scone_raw
	name = "unbaked scone"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "uncookedsconebase"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 4.594, /datum/reagent/consumable/nutriment/vitamin = 1.531)
	foodtypes = GRAIN | DAIRY | RAW | SUGAR
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/scone
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "fresh baked scones"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/scone_raw_choco
	name = "unbaked chocolate scone"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "uncookedchocscone"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 7.406, /datum/reagent/consumable/nutriment/vitamin = 2.469)
	foodtypes = GRAIN | DAIRY | RAW | SUGAR
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/scone_choco
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "fresh baked scones"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/scone_raw_plum
	name = "unbaked plum scone"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "uncookedplumscone"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 6.844, /datum/reagent/consumable/nutriment/vitamin = 2.281)
	foodtypes = GRAIN | DAIRY | RAW | SUGAR | FRUIT
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/scone_plum
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "fresh baked scones"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/scone_raw_tangerine
	name = "unbaked tangerine scone"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "uncookedtangerinescone"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 6.844, /datum/reagent/consumable/nutriment/vitamin = 2.281)
	foodtypes = GRAIN | DAIRY | RAW | SUGAR | FRUIT
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/scone_tangerine
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "fresh baked scones"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/tamtoplate_base
	name = "unfinished tamto plate"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pizza_base"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 4.5, /datum/reagent/consumable/nutriment/vitamin = 1.5)
	foodtypes = GRAIN | FRUIT | RAW
	eat_effect = /datum/status_effect/rogue_food/uncooked
	rotprocess = 18000
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/tamtoplate_unfinished
	name = "unbaked cheese tamto plate"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pizza_uncooked"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 7.031, /datum/reagent/consumable/nutriment/vitamin = 2.344)
	foodtypes = GRAIN | FRUIT | RAW | DAIRY
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/tamtoplate
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "fresh baked tamtoplate"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/tamtoplate_unfinished_fish
	name = "unbaked fish tamto plate"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "fish_pizza_uncooked"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 9.281, /datum/reagent/consumable/nutriment/vitamin = 3.094)
	foodtypes = GRAIN | FRUIT | RAW | DAIRY | MEAT
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/tamtoplate/fish
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "fresh baked tamtoplate"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/tamtoplate_unfinished_meat
	name = "unbaked sausage tamto plate"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "meat_pizza_uncooked"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 11.531, /datum/reagent/consumable/nutriment/vitamin = 3.844)
	foodtypes = GRAIN | FRUIT | RAW | DAIRY | MEAT
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/tamtoplate/meat
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "fresh baked tamtoplate"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/tamtoplate_unfinished_onion
	name = "unbaked onion tamto plate"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "onion_pizza_uncooked"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 8.906, /datum/reagent/consumable/nutriment/vitamin = 2.969)
	foodtypes = GRAIN | FRUIT | RAW | DAIRY | VEGETABLES
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/tamtoplate/onion
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "fresh baked tamtoplate"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/tartcrust
	name = "tart crust"
	desc = "The delicate foundation of a tart."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "tartcrust"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 5.221, /datum/reagent/consumable/nutriment/vitamin = 1.74)
	foodtypes = GRAIN | DAIRY | FRUIT | RAW
	eat_effect = /datum/status_effect/rogue_food/uncooked
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/foodbase/xylixbun_raw
	name = "mysterious dough"
	desc = "This dough seems entirely inconspicous, sure to bake into a regular bun."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "xylixdough"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 4.125, /datum/reagent/consumable/nutriment/vitamin = 1.375)
	foodtypes = GRAIN | DAIRY | RAW
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/xylixbun
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "fresh baked buns"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/friedmessenger
	name = "fried messenger"
	desc = "A fried messenger bird. Poor thing."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "fcrow"
	w_class = WEIGHT_CLASS_TINY
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 3.375, /datum/reagent/consumable/nutriment/vitamin = 1.125)
	foodtypes = GRAIN
	tastes = list("burnt flesh" = 1)
	bitesize = 2
	rotprocess = 12000
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/fritter
	name = "apple fritter"
	desc = "Having deep origins in the culture of Vanderlin, the humble fritter is perhaps the most patriotic pastry out there, long may it reign!"
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "applefritter"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 8.016, /datum/reagent/consumable/nutriment/vitamin = 2.672)
	foodtypes = GRAIN | DAIRY | FRUIT | JUNKFOOD
	tastes = list("crispy butterdough" = 1, "sweet apple bits" = 1)
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/fritter/good
	name = "apple fritter"
	desc = "Having deep origins in the culture of Vanderlin, the humble fritter is perhaps the most patriotic pastry out there, long may it reign!"
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "applefritter"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	rogue_faretype = ROGUE_FARE_LAVISH
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/fruit
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/fruit

/obj/item/reagent_containers/food/snacks/vibelin/fruit/avocado_half
	name = "avocado"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "avocado_half"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 1.125, /datum/reagent/consumable/nutriment/vitamin = 0.375)
	foodtypes = FRUIT
	bitesize = 2
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/fruit/cured_ollie
	name = "cured ollie"
	desc = "A small green fruit that's been cured, making it infinitely more palatable."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/produce.dmi'
	icon_state = "ollie"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.25, /datum/reagent/consumable/nutriment/vitamin = 0.75)
	foodtypes = FRUIT
	tastes = list("sour, savory brine" = 1)
	bitesize = 1
	rotprocess = 54000
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/fruit/dragonfruit_half
	name = "piyata"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "dragonfruit_half"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 1.125, /datum/reagent/consumable/nutriment/vitamin = 0.375)
	foodtypes = FRUIT
	bitesize = 2
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/fruit/mango_half
	name = "mangga"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "mango_half"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 1.125, /datum/reagent/consumable/nutriment/vitamin = 0.375)
	foodtypes = FRUIT
	bitesize = 2
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/fruit/mangosteen_opened
	name = "mangosteen"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "mangosteen_open"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.25, /datum/reagent/consumable/nutriment/vitamin = 0.75)
	foodtypes = FRUIT
	bitesize = 5
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/fruit/pineapple_slice
	name = "ananas slice"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pineapple_slice"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 1.125, /datum/reagent/consumable/nutriment/vitamin = 0.375)
	foodtypes = FRUIT | PINEAPPLE
	bitesize = 1
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/fruit/pompkaun_goo
	name = "pompkaun goo"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pompkaun_goo"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.25, /datum/reagent/consumable/nutriment/vitamin = 0.75)
	foodtypes = FRUIT
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/fruit/pompkaun_goo/cooked
	cooktime = 250
	bitesize = 1
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_cooked_smell = "baked pompkaun"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/fruit/pompkaun_goo/cooked
	name = "baked pompkaun goo"
	desc = "Mixed pompkaun goo and seeds, baked to perfection."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pompkaun_cooked"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 3.375, /datum/reagent/consumable/nutriment/vitamin = 1.125)
	tastes = list("sweet pompkaun goo" = 1)
	cooked_type = null
	cooktime = 0
	bitesize = 3
	rotprocess = 18000
	rogue_portable = FALSE
	rogue_cooked_smell = null
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/fruit/tamto_slice
	name = "sliced tamto"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "mato_split"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.25, /datum/reagent/consumable/nutriment/vitamin = 0.75)
	foodtypes = FRUIT
	bitesize = 1
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/grenzelbun_cocaumole
	name = "grenzelbun with cocaumole"
	desc = "A staple of Grenzelhoft cuisine, altered by Tiefling wanderers."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "grenzbun_cocaumole"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 12.938, /datum/reagent/consumable/nutriment/vitamin = 4.312)
	foodtypes = GRAIN | MEAT | VEGETABLES
	tastes = list("savory sausage" = 1, "bread" = 1, "savory goo" = 1)
	bitesize = 5
	rotprocess = 54000
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/griddlecake
	name = "griddlecake"
	desc = "Enjoyed by mercenaries throughout Psydonia, though despite their prevalence no one quite knows the origin."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "griddlecake"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 11.391, /datum/reagent/consumable/nutriment/vitamin = 3.797)
	foodtypes = GRAIN | DAIRY | EGG
	tastes = list("fluffy butterdough" = 1)
	bitesize = 6
	rotprocess = 30000
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/griddlecake/apple
	name = "apple griddlecake"
	desc = "Enjoyed by mercenaries throughout Psydonia, though despite their prevalence no one quite knows the origin."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "griddlecakeapple"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 14.766, /datum/reagent/consumable/nutriment/vitamin = 4.922)
	foodtypes = GRAIN | DAIRY | EGG | FRUIT
	tastes = list("fluffy butterdough" = 1, "sweet" = 1, "apple" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/griddlecake/berry
	name = "jacksberry griddlecake"
	desc = "Enjoyed by mercenaries throughout Psydonia, though despite their prevalence no one quite knows the origin."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "griddlecakeberry"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 12.234, /datum/reagent/consumable/nutriment/vitamin = 4.078)
	foodtypes = GRAIN | DAIRY | EGG | FRUIT
	tastes = list("fluffy butterdough" = 1, "sweet" = 1, "berry" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/griddlecake/lemon
	name = "lemon griddlecake"
	desc = "Enjoyed by mercenaries throughout Psydonia, though despite their prevalence no one quite knows the origin."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "griddlecakelemon"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 14.766, /datum/reagent/consumable/nutriment/vitamin = 4.922)
	foodtypes = GRAIN | DAIRY | EGG | FRUIT
	tastes = list("fluffy butterdough" = 1, "sweet" = 1, "lemon" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/huskbun
	name = "huskbun"
	desc = "Sunreed cooked in its own skin, a deliciously ironic fate."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "huskbun"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 6.75, /datum/reagent/consumable/nutriment/vitamin = 2.25)
	foodtypes = GRAIN
	tastes = list("crumbly sunreed dough" = 1)
	bitesize = 4
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/jacksberrybutterdough
	name = "raisin butterdough"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "butterdough_jacksberry"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 6.75, /datum/reagent/consumable/nutriment/vitamin = 2.25)
	foodtypes = GRAIN | RAW | DAIRY | FRUIT
	tastes = list("buttery dough" = 1, "raisins" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/bread/bookbread/jacksberry
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "fresh baked pastry"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/jellycake_apple
	name = "apple gelatine cake"
	desc = "A mildly unappetising desert, fittingly considered a delicacy by orcs. This one is colored blood(apple)-red."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "applegelatinecake"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 12.375, /datum/reagent/consumable/nutriment/vitamin = 4.125)
	foodtypes = MEAT | SUGAR | FRUIT
	tastes = list("sweet gelatine" = 1, "sweet apple" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	bitesize = 4
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/jellyslice_apple
	slices_num = 4
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/jellycake_base
	name = "plain gelatie cake"
	desc = "A mildly unappetising desert, fittingly considered a delicacy by orcs. Though it is traditionally made plain, chefs often mercifully flavor it with fruit."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "basegelatinecake"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 9, /datum/reagent/consumable/nutriment/vitamin = 3)
	foodtypes = MEAT | SUGAR | GROSS
	tastes = list("unflavored gelatine" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	bitesize = 4
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/jellyslice_base
	slices_num = 4
	rogue_faretype = ROGUE_FARE_POOR
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/jellycake_lime
	name = "lime gelatine cake"
	desc = "A mildly unappetising desert, fittingly considered a delicacy by orcs. This one is green, naturally."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "limegelatinecake"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 12.375, /datum/reagent/consumable/nutriment/vitamin = 4.125)
	foodtypes = MEAT | SUGAR | FRUIT
	tastes = list("sweet gelatine" = 1, "sweet lime" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	bitesize = 4
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/jellyslice_lime
	slices_num = 4
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/jellycake_pear
	name = "pear gelatine cake"
	desc = "A mildly unappetising dessert, fittingly considered a delicacy by orcs. This flavor is a strange fusion of Zalad and Orcish cuisines."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "peargelatinecake"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 12.375, /datum/reagent/consumable/nutriment/vitamin = 4.125)
	foodtypes = MEAT | SUGAR | FRUIT
	tastes = list("sweet gelatine" = 1, "sweet pear" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	bitesize = 4
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/jellyslice_pear
	slices_num = 4
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/jellycake_plum
	name = "plum gelatine cake"
	desc = "A mildly unappetising desert, fittingly considered a delicacy by orcs. Like the plum this treat is made from, orcs persevere against all."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "plumgelatinecake"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 12.375, /datum/reagent/consumable/nutriment/vitamin = 4.125)
	foodtypes = MEAT | SUGAR | FRUIT
	tastes = list("sweet gelatine" = 1, "sweet plum" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	bitesize = 4
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/jellyslice_plum
	slices_num = 4
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/jellycake_tangerine
	name = "tangerine gelatine cake"
	desc = "A mildly unappetising desert, fittingly considered a delicacy by orcs. This one is bittersweet, like the triumph of battle."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "tangerinegelatinecake"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 12.375, /datum/reagent/consumable/nutriment/vitamin = 4.125)
	foodtypes = MEAT | SUGAR | FRUIT
	tastes = list("sweet gelatine" = 1, "sweet tangerine" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	bitesize = 4
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/jellyslice_tangerine
	slices_num = 4
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/jellyslice_apple
	name = "apple gelatine slice"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "applegelatineslice"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 3.094, /datum/reagent/consumable/nutriment/vitamin = 1.031)
	foodtypes = MEAT | SUGAR | FRUIT
	tastes = list("sweet gelatine" = 1, "sweet apple" = 1)
	bitesize = 2
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/jellyslice_base
	name = "plain gelatine slice"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "basegelatinslice"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 1.5, /datum/reagent/consumable/nutriment/vitamin = 0.5)
	foodtypes = MEAT | SUGAR | GROSS
	tastes = list("unflavored gelatine" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	bitesize = 2
	rogue_faretype = ROGUE_FARE_POOR
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/jellyslice_lime
	name = "lime gelatine slice"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "limegelatineslice"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 3.094, /datum/reagent/consumable/nutriment/vitamin = 1.031)
	foodtypes = MEAT | SUGAR | FRUIT
	tastes = list("sweet gelatine" = 1, "sweet lime" = 1)
	bitesize = 2
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/jellyslice_pear
	name = "pear gelatine slice"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "peargelatineslice"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 3.094, /datum/reagent/consumable/nutriment/vitamin = 1.031)
	foodtypes = MEAT | SUGAR | FRUIT
	tastes = list("sweet gelatine" = 1, "sweet pear" = 1)
	bitesize = 2
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/jellyslice_plum
	name = "plum gelatine slice"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "plumgelatineslice"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 3.094, /datum/reagent/consumable/nutriment/vitamin = 1.031)
	foodtypes = MEAT | SUGAR | FRUIT
	tastes = list("sweet gelatine" = 1, "sweet plum" = 1)
	bitesize = 2
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/jellyslice_tangerine
	name = "tangerine gelatine slice"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "tangerinegelatineslice"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 3.094, /datum/reagent/consumable/nutriment/vitamin = 1.031)
	foodtypes = MEAT | SUGAR | FRUIT
	tastes = list("sweet gelatine" = 1, "sweet tangerine" = 1)
	bitesize = 2
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/lemonbutterdough
	name = "lemon butterdough"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "butterdough_lemon"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 7.875, /datum/reagent/consumable/nutriment/vitamin = 2.625)
	foodtypes = GRAIN | RAW | DAIRY | FRUIT
	tastes = list("buttery dough" = 1, "dried lemons" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/lemonbookbread
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "fresh baked pastry"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/masa
	name = "sunreed dough"
	desc = "Survive long enough, and prosper. Or at least something close."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "masa"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 4.5, /datum/reagent/consumable/nutriment/vitamin = 1.5)
	foodtypes = GRAIN | RAW
	tastes = list("semi-sweet dough" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/sunreed_bread
	cooktime = 250
	rotprocess = 30000
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/masa_slice
	slices_num = 2
	rogue_cooked_smell = "fresh baked sunreed"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/masa_base
	name = "unfinished sunreed dough"
	desc = "Through innovation, folk survive. They always do."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "masa_base"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.25, /datum/reagent/consumable/nutriment/vitamin = 0.75)
	foodtypes = GRAIN | RAW
	tastes = list("semi-sweet dough" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	rotprocess = 30000
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/masa_flat
	name = "sunreed flat-cake"
	desc = "Something to keep our future safe."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "masa_flat"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.25, /datum/reagent/consumable/nutriment/vitamin = 0.75)
	foodtypes = GRAIN | RAW
	tastes = list("semi-sweet dough" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	fried_type = /obj/item/reagent_containers/food/snacks/vibelin/tostada
	cooktime = 250
	rotprocess = 30000
	rogue_cooked_smell = "fresh baked sunreed"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/masa_honey
	name = "honeyed sunreed dough"
	desc = "Sweet dough with sweet honey."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "honey_masa"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 6.75, /datum/reagent/consumable/nutriment/vitamin = 2.25)
	foodtypes = GRAIN | RAW | SUGAR
	tastes = list("semi-sweet dough" = 1, "honey" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/sunreed_bread/honey
	cooktime = 250
	rotprocess = 30000
	rogue_cooked_smell = "fresh baked sunreed"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/masa_slice
	name = "sunreed dough piece"
	desc = "A fraction of hope for something greater."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "masa_slice"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.25, /datum/reagent/consumable/nutriment/vitamin = 0.75)
	foodtypes = GRAIN | RAW
	tastes = list("semi-sweet dough" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/estrella
	cooktime = 250
	rotprocess = 30000
	rogue_cooked_smell = "fresh baked sunreed"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/meat
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/meat

/obj/item/reagent_containers/food/snacks/vibelin/meat/fatty
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/meat/fatty

/obj/item/reagent_containers/food/snacks/vibelin/meat/fatty/dwarf
	name = "fatty manflesh"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pigflesh"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 4.5, /datum/reagent/consumable/nutriment/vitamin = 1.5)
	foodtypes = RAW | MEAT | GROSS
	tastes = list("meat" = 1, "fat" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	fried_type = /obj/item/reagent_containers/food/snacks/vibelin/cooked/ham
	cooktime = 250
	rotprocess = 12000
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef
	slices_num = 2
	rogue_cooked_smell = "fried bacon"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/meat/fatty/kobold
	name = "raw wyrmflesh"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pigflesh"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 4.5, /datum/reagent/consumable/nutriment/vitamin = 1.5)
	foodtypes = RAW | MEAT | GROSS
	tastes = list("gamey meat" = 1, "crunchy bits" = 1, "ash" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	fried_type = /obj/item/reagent_containers/food/snacks/vibelin/cooked/ham
	cooktime = 250
	rotprocess = 12000
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef
	slices_num = 2
	rogue_cooked_smell = "fried bacon"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/meat/mince
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/meat/mince

/obj/item/reagent_containers/food/snacks/vibelin/meat/mince/beef
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/meat/mince/beef

/obj/item/reagent_containers/food/snacks/vibelin/meat/mince/beef/cooked
	name = "cooked minced meat"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "meatmince"
	w_class = WEIGHT_CLASS_SMALL
	color = "#a0655f"
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 3.375, /datum/reagent/consumable/nutriment/vitamin = 1.125)
	foodtypes = MEAT
	tastes = list("meat" = 1)
	bitesize = 1
	rotprocess = 18000
	become_rot_type = /obj/item/reagent_containers/food/snacks/vibelin/rotten/mince
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/meat/mince/beef/mett
	name = "grenzel mett"
	desc = "A popular topping for bread in Grenzelhoft, while simply bizarre to people from Vanderlin."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "mett_minced"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 4.125, /datum/reagent/consumable/nutriment/vitamin = 1.375)
	foodtypes = RAW | MEAT
	tastes = list("meat" = 1)
	rotprocess = 7200
	become_rot_type = /obj/item/reagent_containers/food/snacks/vibelin/rotten/mince
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/meat/mince/beef/mett/slice
	slices_num = 3
	rogue_faretype = ROGUE_FARE_POOR
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/meat/mince/beef/mett/slice
	name = "grenzel mett"
	desc = "A popular topping for bread in Grenzelhoft, while simply bizarre to people from Vanderlin."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "mett_slice"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 1.375, /datum/reagent/consumable/nutriment/vitamin = 0.458)
	bitesize = 1
	slice_path = null
	slices_num = 0
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/meat/mince/fish
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/meat/mince/fish

/obj/item/reagent_containers/food/snacks/vibelin/meat/mince/fish/cooked
	name = "cooked minced fish"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "fishmince"
	w_class = WEIGHT_CLASS_SMALL
	color = "#a0655f"
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 3.375, /datum/reagent/consumable/nutriment/vitamin = 1.125)
	foodtypes = MEAT
	tastes = list("meat" = 1)
	bitesize = 1
	rotprocess = 18000
	become_rot_type = /obj/item/reagent_containers/food/snacks/vibelin/rotten/mince
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/meat/mince/poultry
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/meat/mince/poultry

/obj/item/reagent_containers/food/snacks/vibelin/meat/mince/poultry/cooked
	name = "cooked minced poultry"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "birdmince"
	w_class = WEIGHT_CLASS_SMALL
	color = "#a0655f"
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 3.375, /datum/reagent/consumable/nutriment/vitamin = 1.125)
	foodtypes = MEAT
	tastes = list("meat" = 1)
	bitesize = 1
	rotprocess = 18000
	become_rot_type = /obj/item/reagent_containers/food/snacks/vibelin/rotten/mince
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/meat/organ
	name = "organ"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/obj/surgery.dmi'
	icon_state = "guts"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.25, /datum/reagent/consumable/nutriment/vitamin = 0.75)
	foodtypes = RAW | MEAT | GROSS
	tastes = list("meat" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	rotprocess = 7200
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/meat/organ/heart
	name = "heart"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/obj/surgery.dmi'
	icon_state = "heart"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 4.5, /datum/reagent/consumable/nutriment/vitamin = 1.5)
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/meat/organ/liver
	name = "liver"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/obj/surgery.dmi'
	icon_state = "liver"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 4.5, /datum/reagent/consumable/nutriment/vitamin = 1.5)
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/meat/organ/lungs
	name = "lungs"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/obj/surgery.dmi'
	icon_state = "lungs"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 4.5, /datum/reagent/consumable/nutriment/vitamin = 1.5)
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/meat/poultry
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/meat/poultry

/obj/item/reagent_containers/food/snacks/vibelin/meat/poultry/cutlet
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/meat/poultry/cutlet

/obj/item/reagent_containers/food/snacks/vibelin/meat/poultry/cutlet/coated
	name = "crumb coated bird meat"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/obj/food/raw/raw_deep_fried.dmi'
	icon_state = "chickencutlet_coated"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 4.5, /datum/reagent/consumable/nutriment/vitamin = 1.5)
	foodtypes = RAW | MEAT
	tastes = list("meat" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried
	cooktime = 250
	rotprocess = 12000
	become_rot_type = /obj/item/reagent_containers/food/snacks/vibelin/rotten/chickenleg
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/poultry
	slices_num = 2
	slice_bclass = BCLASS_CHOP
	rogue_cooked_smell = "cooked chicken"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/meat/poultry/cutlet/egg_washed
	name = "egg washed bird meat"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/obj/food/raw/raw_deep_fried.dmi'
	icon_state = "chickencutlet_washed"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 4.5, /datum/reagent/consumable/nutriment/vitamin = 1.5)
	foodtypes = RAW | MEAT
	tastes = list("meat" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried
	cooktime = 250
	rotprocess = 12000
	become_rot_type = /obj/item/reagent_containers/food/snacks/vibelin/rotten/chickenleg
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/poultry
	slices_num = 2
	slice_bclass = BCLASS_CHOP
	rogue_cooked_smell = "cooked chicken"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/meat/poultry/cutlet/harpy
	name = "harpy cutlet"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "chickencutlet"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 4.5, /datum/reagent/consumable/nutriment/vitamin = 1.5)
	foodtypes = RAW | MEAT
	tastes = list("meat" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried
	cooktime = 250
	rotprocess = 12000
	become_rot_type = /obj/item/reagent_containers/food/snacks/vibelin/rotten/chickenleg
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/poultry
	slices_num = 2
	slice_bclass = BCLASS_CHOP
	rogue_cooked_smell = "cooked chicken"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/meat/ribs
	name = "raw ribs"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "raw_ribs"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 4.5, /datum/reagent/consumable/nutriment/vitamin = 1.5)
	foodtypes = RAW | MEAT
	tastes = list("meat" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/bread/ribrack
	fried_type = /obj/item/reagent_containers/food/snacks/vibelin/bread/ribrack
	cooktime = 250
	rotprocess = 12000
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef
	slices_num = 1
	slice_bclass = BCLASS_CHOP
	rogue_cooked_smell = "fried meat"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/meat/sausage
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/meat/sausage

/obj/item/reagent_containers/food/snacks/vibelin/meat/sausage/wiener
	name = "raw wiener"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "raw_wiener"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 5.25, /datum/reagent/consumable/nutriment/vitamin = 1.75)
	foodtypes = RAW | MEAT
	tastes = list("meat" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	fried_type = /obj/item/reagent_containers/food/snacks/vibelin/cooked/sausage/wiener
	cooktime = 250
	rotprocess = 12000
	become_rot_type = /obj/item/reagent_containers/food/snacks/vibelin/rotten/sausage
	rogue_cooked_smell = "cooked sausage"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/meat/steak
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/meat/steak

/obj/item/reagent_containers/food/snacks/vibelin/meat/steak/human
	name = "raw manflesh"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "meat"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 4.5, /datum/reagent/consumable/nutriment/vitamin = 1.5)
	foodtypes = RAW | MEAT | GROSS
	tastes = list("meat" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	cooktime = 250
	rotprocess = 12000
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef
	slices_num = 2
	slice_bclass = BCLASS_CHOP
	rogue_cooked_smell = "fried meat"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/meat/strange
	name = "strange meat"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "strange_meat"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 4.5, /datum/reagent/consumable/nutriment/vitamin = 1.5)
	foodtypes = RAW | MEAT
	tastes = list("meat" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	fried_type = /obj/item/reagent_containers/food/snacks/vibelin/cooked/strange
	cooktime = 250
	rotprocess = 12000
	rogue_cooked_smell = "fried meat"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/meat/strange/inhumen
	name = "foul manflesh"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "strange_meat"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/meat/triton
	name = "deepflesh"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "fishfillet"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 4.5, /datum/reagent/consumable/nutriment/vitamin = 1.5)
	foodtypes = RAW | MEAT
	tastes = list("meat" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	rotprocess = 12000
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish
	slices_num = 2
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/messenger_bird
	name = "messenger bird"
	desc = "A small bird, used by nobles to send messages beyond the borders of this city. It has a small pouch on its leg for carrying notes."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/mob/monster/messenger.dmi'
	icon_state = "messenger"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.25, /datum/reagent/consumable/nutriment/vitamin = 0.75)
	foodtypes = RAW | MEAT
	eat_effect = /datum/status_effect/rogue_food/uncooked
	fried_type = /obj/item/reagent_containers/food/snacks/vibelin/friedmessenger
	cooktime = 250
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_cooked_smell = "fried messenger"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/pear_dried
	name = "dried pear"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "driedpear"
	w_class = WEIGHT_CLASS_TINY
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 1.688, /datum/reagent/consumable/nutriment/vitamin = 0.562)
	foodtypes = FRUIT
	tastes = list("dried fruit" = 1)
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/pearbutterdough
	name = "pear butterdough"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "butterdough_pear"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 7.875, /datum/reagent/consumable/nutriment/vitamin = 2.625)
	foodtypes = GRAIN | RAW | DAIRY | FRUIT
	tastes = list("buttery dough" = 1, "dried pears" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pearbookbread
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "fresh baked pastry"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/pestranstick
	name = "pestran stick"
	desc = "An unappetizing snack adored by devout Pestrans, somehow doesn't taste half bad."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pestranstick"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 1.688, /datum/reagent/consumable/nutriment/vitamin = 0.562)
	foodtypes = DAIRY
	tastes = list("raw unsalted butter on a stick" = 1)
	rogue_faretype = ROGUE_FARE_POOR
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/pie
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/pie

/obj/item/reagent_containers/food/snacks/vibelin/pie/cooked
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/pie/cooked

/obj/item/reagent_containers/food/snacks/vibelin/pie/cooked/blackberry
	name = "blackberry pie"
	desc = "A sweet pie made from blackberries. A classic Vanderlinian treat, nearly lost to time."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "blackberrypie"
	w_class = WEIGHT_CLASS_SMALL
	color = "#e7e2df"
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 21.727, /datum/reagent/consumable/nutriment/vitamin = 7.242)
	foodtypes = GRAIN | DAIRY
	tastes = list("blackberry and butterdough" = 1)
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/pieslice
	slices_num = 6
	rogue_faretype = ROGUE_FARE_LAVISH
	rogue_portable = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/pie/cooked/borowiki
	name = "borowiki pie"
	desc = "A savory pie filled with hearty borowiki mushrooms."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pie"
	w_class = WEIGHT_CLASS_SMALL
	color = "#e7e2df"
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 20.039, /datum/reagent/consumable/nutriment/vitamin = 6.68)
	foodtypes = GRAIN | DAIRY
	tastes = list("borowiki and butterdough" = 1)
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/pieslice
	slices_num = 6
	rogue_faretype = ROGUE_FARE_LAVISH
	rogue_portable = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/pie/cooked/pear
	name = "pear pie"
	desc = "A sweet pie made from pears. Not as famous as it's other fruit cousins."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pie"
	w_class = WEIGHT_CLASS_SMALL
	color = "#e7e2df"
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 21.727, /datum/reagent/consumable/nutriment/vitamin = 7.242)
	foodtypes = GRAIN | DAIRY
	tastes = list("pears and butterdough" = 1)
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/pieslice
	slices_num = 6
	rogue_faretype = ROGUE_FARE_LAVISH
	rogue_portable = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/pie/cooked/pompkaun
	name = "pompkaun pie"
	desc = "Usually eaten in the second to last month of fall, when the pompkauns have been carved for Dendor but have not yet rotted."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pompkaunpie"
	w_class = WEIGHT_CLASS_SMALL
	color = "#e7e2df"
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 21.727, /datum/reagent/consumable/nutriment/vitamin = 7.242)
	foodtypes = GRAIN | DAIRY
	tastes = list("pompkaun and butterdough" = 1)
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/pieslice
	slices_num = 6
	rogue_faretype = ROGUE_FARE_LAVISH
	rogue_portable = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/pie/cooked/raspberry
	name = "raspberry pie"
	desc = "A sweet pie made from raspberries. A classic Vanderlinian treat, nearly lost to time."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pompkaunpie"
	w_class = WEIGHT_CLASS_SMALL
	color = "#e7e2df"
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 21.727, /datum/reagent/consumable/nutriment/vitamin = 7.242)
	foodtypes = GRAIN | DAIRY
	tastes = list("raspberry and butterdough" = 1)
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/pieslice
	slices_num = 6
	rogue_faretype = ROGUE_FARE_LAVISH
	rogue_portable = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/plum_dried
	name = "dried plum"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "driedplum"
	w_class = WEIGHT_CLASS_TINY
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 1.688, /datum/reagent/consumable/nutriment/vitamin = 0.562)
	foodtypes = FRUIT
	tastes = list("dried fruit" = 1)
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/plumbutterdough
	name = "plum butterdough"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "butterdough_plum"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 7.875, /datum/reagent/consumable/nutriment/vitamin = 2.625)
	foodtypes = GRAIN | RAW | DAIRY | FRUIT
	tastes = list("buttery dough" = 1, "dried plums" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/plumbookbread
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "fresh baked pastry"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/poisonglands
	name = "venom sac"
	desc = "A swollen venom sac drawn from a foul beast, heavy with bitter humors. Its contents are sought by alchemists for the brewing of deadly draughts."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "venomgland"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.25, /datum/reagent/consumable/nutriment/vitamin = 0.75, /datum/reagent/toxin/venom = 20)
	foodtypes = GROSS
	burntime = 0
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/produce
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/produce

/obj/item/reagent_containers/food/snacks/vibelin/produce/dry_westleach
	name = "dried westleach leaf"
	desc = "A common, strong-smelling leaf dried for smoking."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/produce.dmi'
	icon_state = "westleachd"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 0.75, /datum/reagent/consumable/nutriment/vitamin = 0.25, /datum/reagent/drug/nicotine = 5)
	foodtypes = GRAIN
	eat_effect = /datum/status_effect/rogue_food/bad_meal
	rogue_faretype = ROGUE_FARE_POOR
	sellprice = 1
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/produce/fruit
	name = "fruit"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/produce.dmi'
	icon_state = null
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.25, /datum/reagent/consumable/nutriment/vitamin = 0.75)
	foodtypes = FRUIT
	rogue_faretype = ROGUE_FARE_POOR
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/produce/fruit/avocado
	name = "avocado"
	desc = "A verdant tropical fruit known for its smooth and creamy flesh."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/produce.dmi'
	icon_state = "avocado"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	tastes = list("avocado" = 1)
	bitesize = 2
	rotprocess = 18000
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/fruit/avocado_half
	slices_num = 2
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/produce/fruit/dragonfruit
	name = "piyata"
	desc = "A spiky fruit with a pink skin and white flesh, Its taste is mild yet refreshing."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/produce.dmi'
	icon_state = "dragonfruit"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	tastes = list("piyata" = 1)
	bitesize = 2
	rotprocess = 18000
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/fruit/dragonfruit_half
	slices_num = 2
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/produce/fruit/mango
	name = "mangga"
	desc = "A golden tropical fruit bursting with sweet, juicy flesh."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/produce.dmi'
	icon_state = "mango"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	tastes = list("mangga" = 1)
	bitesize = 2
	rotprocess = 12000
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/fruit/mango_half
	slices_num = 2
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/produce/fruit/mangosteen
	name = "mangosteen"
	desc = "A tropical fruit with a thick purple rind and white segments within."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/produce.dmi'
	icon_state = "mangosteen"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	tastes = list("mangosteen" = 1)
	bitesize = 2
	rotprocess = 12000
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/fruit/mangosteen_opened
	slices_num = 1
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/produce/fruit/ollie
	name = "ollie"
	desc = "A small green fruit best made into oil."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/produce.dmi'
	icon_state = "ollie"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	tastes = list("bitterness" = 1)
	bitesize = 2
	rotprocess = 18000
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/produce/fruit/pineapple
	name = "ananas"
	desc = "A spiky fruit with golden skin, Its taste is tangy yet sweet and refreshing."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/produce.dmi'
	icon_state = "pineapple"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	foodtypes = FRUIT | PINEAPPLE
	tastes = list("ananas" = 1)
	bitesize = 2
	rotprocess = 18000
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/fruit/pineapple_slice
	slices_num = 4
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/produce/fruit/pompkaun
	name = "pompkaun"
	desc = "This fruit is equal parts Dendorite and Pestran, carved in offering to the former, and collected by followers of the latter after the offerings rot."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/produce.dmi'
	icon_state = "pompkaun"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	tastes = list("pompkaun" = 1)
	rotprocess = 18000
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/fruit/pompkaun_goo
	slices_num = 2
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/produce/fruit/tamto
	name = "tamto"
	desc = "A deliciously sweet berry that grows abundantly in the bogs of Daftmarsh."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/produce.dmi'
	icon_state = "mato"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	tastes = list("sweet tamto" = 1)
	bitesize = 2
	rotprocess = 12000
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/fruit/tamto_slice
	slices_num = 1
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/produce/grain
	name = "grain"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/produce.dmi'
	icon_state = null
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.25, /datum/reagent/consumable/nutriment/vitamin = 0.75)
	foodtypes = GRAIN
	rogue_faretype = ROGUE_FARE_POOR
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/produce/grain/sunreed
	name = "sunreed kernels"
	desc = "Kernels so hard you could chip a tooth. Only the most desperate would use this in any sort of food."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/produce.dmi'
	icon_state = "maize"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	tastes = list("chipping a tooth" = 1)
	rogue_faretype = ROGUE_FARE_IMPOVERISHED
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/produce/mushroom
	name = "mushroom"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/produce.dmi'
	icon_state = null
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 1.875, /datum/reagent/consumable/nutriment/vitamin = 0.625)
	rogue_faretype = ROGUE_FARE_POOR
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/produce/mushroom/borowiki
	name = "borowiki"
	desc = "Also known as Cépes to the Drow, this fungus was cultivated over generations into this hearty crop by the Dwarves of the mountain passes. It is not known which of them were the first to discover it, though their use by the surface dwelling species of Psydonia has grown significantly in the last few centuries."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/produce.dmi'
	icon_state = "borowiki"
	w_class = WEIGHT_CLASS_TINY
	rogue_grid_width = 32
	rogue_grid_height = 32
	tastes = list("earthy" = 1, "nutty" = 1)
	rotprocess = 18000
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/produce/mushroom/capillus
	name = "capillus mort"
	desc = "Also called Corpse Caps or Necra’s Nightcaps, this toxic fungus was first discovered by Necran gravetenders, growing amongst tombs. It has long since been harvested and dried to make use of its fibrous gills in the weaving of winding sheets."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/produce.dmi'
	icon_state = "capillus"
	w_class = WEIGHT_CLASS_TINY
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 1)
	tastes = list("bitter" = 1, "fibrous" = 1)
	eat_effect = /datum/status_effect/rogue_food/bad_meal
	rotprocess = 54000
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/produce/mushroom/caveweep
	name = "caveweep"
	desc = "Once thought to be the wept tears of Psydonia itself, this fungus can be found growing deep within the damp caves along the coasts of Faience. It is known only to those brave enough to delve their depths and discover its unique, briney flavors."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/produce.dmi'
	icon_state = "caveweep"
	w_class = WEIGHT_CLASS_TINY
	rogue_grid_width = 32
	rogue_grid_height = 32
	tastes = list("sweet" = 1, "briny" = 1)
	rotprocess = 18000
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/produce/mushroom/drowsbane
	name = "drowsbane"
	desc = "Creates a burning sensation in the mouth of anyone who eats it, this lichen is particularly adept at warding off its consumption by any Subterra denizens. However, in a cruel twist of fate, Tieflings find it particularly delectable."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/produce.dmi'
	icon_state = "drowsbane"
	w_class = WEIGHT_CLASS_TINY
	rogue_grid_width = 32
	rogue_grid_height = 32
	tastes = list("burning" = 1)
	rotprocess = 18000
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/produce/mushroom/merkel
	name = "merkel"
	desc = "A rare fungus popularized by the ruling class of Grenzelhoft. It has been said that these mushrooms smell SO divine when prepared correctly, it could raise a man from the dead."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/produce.dmi'
	icon_state = "merkel"
	w_class = WEIGHT_CLASS_TINY
	rogue_grid_width = 32
	rogue_grid_height = 32
	tastes = list("sweet" = 1, "nutty" = 1, "rich" = 1)
	rotprocess = 18000
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/produce/mushroom/waddle
	name = "waddle"
	desc = "A staple to all those that wander the forests of Faience. Its bright color and unique shape have lent it its name. Some even say it tastes like roast bird."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/produce.dmi'
	icon_state = "waddle"
	w_class = WEIGHT_CLASS_TINY
	rogue_grid_width = 32
	rogue_grid_height = 32
	tastes = list("meaty" = 1)
	rotprocess = 18000
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/produce/vegetable
	name = "vegetable"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/produce.dmi'
	icon_state = null
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 1.875, /datum/reagent/consumable/nutriment/vitamin = 0.625)
	foodtypes = VEGETABLES
	rogue_faretype = ROGUE_FARE_POOR
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/produce/vegetable/potato
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/produce/vegetable/potato

/obj/item/reagent_containers/food/snacks/vibelin/produce/vegetable/potato/baked
	name = "baked potatos"
	desc = "A dwarven favorite, as a meal or a game of hot potato."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "potato_baked"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.812, /datum/reagent/consumable/nutriment/vitamin = 0.938)
	tastes = list("potato" = 1)
	rotprocess = 30000
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced
	slices_num = 1
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/produce/vegetable/sunreed_cooked
	name = "grilled sunreed"
	desc = "Sunreed cooked to soften it somewhat."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "maize_cooked"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.812, /datum/reagent/consumable/nutriment/vitamin = 0.938)
	tastes = list("softened sunreed" = 1)
	bitesize = 5
	rotprocess = 30000
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/raisindough
	name = "dough of raisins"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "dough_raisin"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 5.062, /datum/reagent/consumable/nutriment/vitamin = 1.688)
	foodtypes = GRAIN | RAW | FRUIT
	tastes = list("dough" = 1, "dried fruit" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/raisinbread
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "fresh baked loaf of raisin bread"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/raspberrybutterdough
	name = "raspberry butterdough"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "butterdough_raspberry"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 7.875, /datum/reagent/consumable/nutriment/vitamin = 2.625)
	foodtypes = GRAIN | RAW | DAIRY | FRUIT
	tastes = list("buttery dough" = 1, "dried raspberries" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/raspberrybookbread
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "fresh baked pastry"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/raw_pie
	name = "uncooked pie"
	desc = "The foundation of the fantastical."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pieuncooked"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 7.734, /datum/reagent/consumable/nutriment/vitamin = 2.578)
	foodtypes = GRAIN
	eat_effect = /datum/status_effect/rogue_food/uncooked
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/raw_pie/apple
	name = "uncooked apple pie"
	desc = "The foundation of the fantastical."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pieuncooked"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 14.484, /datum/reagent/consumable/nutriment/vitamin = 4.828)
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/apple
	cooktime = 250
	rogue_cooked_smell = "apple pie"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/raw_pie/berry
	name = "uncooked berry pie"
	desc = "The foundation of the fantastical."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pieuncooked"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 9.984, /datum/reagent/consumable/nutriment/vitamin = 3.328)
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/berry
	cooktime = 250
	rogue_cooked_smell = "berry pie"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/raw_pie/blackberry
	name = "uncooked blackberry pie"
	desc = "The foundation of the fantastical."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pieuncooked"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 14.484, /datum/reagent/consumable/nutriment/vitamin = 4.828)
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/pie/cooked/blackberry
	cooktime = 250
	rogue_cooked_smell = "blackberry pie"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/raw_pie/borowiki
	name = "uncoooked borowiki pie"
	desc = "The foundation of the fantastical."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pieuncooked"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 13.359, /datum/reagent/consumable/nutriment/vitamin = 4.453)
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/pie/cooked/borowiki
	cooktime = 250
	rogue_cooked_smell = "borowiki pie"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/raw_pie/fish
	name = "uncooked fish pie"
	desc = "The foundation of the fantastical."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "fishpie_raw"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 14.484, /datum/reagent/consumable/nutriment/vitamin = 4.828)
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat/fish
	cooktime = 250
	rogue_cooked_smell = "fish pie"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/raw_pie/meat
	name = "uncooked meat pie"
	desc = "The foundation of the fantastical."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "meatpie_raw"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 14.484, /datum/reagent/consumable/nutriment/vitamin = 4.828)
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat
	cooktime = 250
	rogue_cooked_smell = "meat pie"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/raw_pie/pear
	name = "uncooked pear pie"
	desc = "The foundation of the fantastical."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pieuncooked"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 14.484, /datum/reagent/consumable/nutriment/vitamin = 4.828)
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/pie/cooked/pear
	cooktime = 250
	rogue_cooked_smell = "pear pie"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/raw_pie/pompkaun
	name = "uncooked pompkaun pie"
	desc = "The foundation of the fantastical."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pieuncooked"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 14.484, /datum/reagent/consumable/nutriment/vitamin = 4.828)
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/pie/cooked/pompkaun
	cooktime = 250
	rogue_cooked_smell = "pompkaun pie"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/raw_pie/pot_pie
	name = "uncooked pot pie"
	desc = "The foundation of the fantastical."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pieuncooked"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 16.359, /datum/reagent/consumable/nutriment/vitamin = 5.453)
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/pot
	cooktime = 250
	rogue_cooked_smell = "pot pie"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/raw_pie/raspberry
	name = "uncooked raspberry pie"
	desc = "The foundation of the fantastical."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pieuncooked"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 14.484, /datum/reagent/consumable/nutriment/vitamin = 4.828)
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/pie/cooked/raspberry
	cooktime = 250
	rogue_cooked_smell = "raspberry pie"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/raw_tart
	name = "uncooked tart"
	desc = "A tart ready for the oven."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "tartuncooked"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 11.971, /datum/reagent/consumable/nutriment/vitamin = 3.99)
	foodtypes = GRAIN
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/raw_tart/avocado
	name = "uncooked avocado tart"
	desc = "A tart ready for the oven."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "tartuncooked"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/tart/cooked/avocado
	cooktime = 250
	rogue_cooked_smell = "fresh baked pastry"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/raw_tart/chocolate
	name = "uncooked chocolate tart"
	desc = "A tart ready for the oven."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "tartuncooked"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/tart/cooked/chocolate
	cooktime = 250
	rogue_cooked_smell = "fresh baked pastry"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/raw_tart/dragonfruit
	name = "uncooked piyata tart"
	desc = "A tart ready for the oven."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "tartuncooked"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/tart/cooked/dragonfruit
	cooktime = 250
	rogue_cooked_smell = "fresh baked pastry"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/raw_tart/mango
	name = "uncooked mango tart"
	desc = "A tart ready for the oven."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "tartuncooked"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/tart/cooked/mango
	cooktime = 250
	rogue_cooked_smell = "fresh baked pastry"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/raw_tart/mangosteen
	name = "uncooked mangosteen tart"
	desc = "A tart ready for the oven."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "tartuncooked"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/tart/cooked/mangosteen
	cooktime = 250
	rogue_cooked_smell = "fresh baked pastry"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/raw_tart/pineapple
	name = "uncooked ananas tart"
	desc = "A tart ready for the oven."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "tartuncooked"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	foodtypes = GRAIN | DAIRY | FRUIT | PINEAPPLE | RAW
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/tart/cooked/pineapple
	cooktime = 250
	rogue_cooked_smell = "fresh baked pastry"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/rotten
	name = "rotten food"
	desc = "A vile decaying morsel, its last hope is to become food for the soil."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = null
	w_class = WEIGHT_CLASS_SMALL
	color = "#6c6897"
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 0.75, /datum/reagent/consumable/nutriment/vitamin = 0.25, /datum/reagent/yuck = 5)
	foodtypes = GRAIN
	eat_effect = /datum/status_effect/rogue_food/rotten
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/rotten/bacon
	name = "rotten flesh"
	desc = "A vile decaying morsel, its last hope is to become food for the soil."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pigflesh"
	w_class = WEIGHT_CLASS_SMALL
	color = "#6c6897"
	rogue_grid_width = 32
	rogue_grid_height = 32
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/rotten/breadslice
	name = "moldy bread"
	desc = "A vile decaying morsel, its last hope is to become food for the soil."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "loaf_slice"
	w_class = WEIGHT_CLASS_SMALL
	color = "#6c6897"
	rogue_grid_width = 32
	rogue_grid_height = 32
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/rotten/chickenleg
	name = "rotten bird meat"
	desc = "A vile decaying morsel, its last hope is to become food for the soil."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "chickencutlet"
	w_class = WEIGHT_CLASS_SMALL
	color = "#6c6897"
	rogue_grid_width = 32
	rogue_grid_height = 32
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/rotten/egg
	name = "rotten egg"
	desc = "A vile decaying morsel, its last hope is to become food for the soil."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "eggB"
	w_class = WEIGHT_CLASS_SMALL
	color = "#6c6897"
	rogue_grid_width = 32
	rogue_grid_height = 32
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/rotten/mince
	name = "rotten mince"
	desc = "A vile decaying morsel, its last hope is to become food for the soil."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "meatmince"
	w_class = WEIGHT_CLASS_SMALL
	color = "#6c6897"
	rogue_grid_width = 32
	rogue_grid_height = 32
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/rotten/poultry
	name = "rotten plucked bird"
	desc = "A vile decaying morsel, its last hope is to become food for the soil."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "poultry"
	w_class = WEIGHT_CLASS_SMALL
	color = "#6c6897"
	rogue_grid_width = 32
	rogue_grid_height = 32
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/rotten/sausage
	name = "rotten sausage"
	desc = "A vile decaying morsel, its last hope is to become food for the soil."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "raw_wiener"
	w_class = WEIGHT_CLASS_SMALL
	color = "#6c6897"
	rogue_grid_width = 32
	rogue_grid_height = 32
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/saigaita_cooked
	name = "grilled saigaita"
	desc = "This saigaita has been heated to perfection."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "lilsaiga"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 6.75, /datum/reagent/consumable/nutriment/vitamin = 2.25)
	foodtypes = GRAIN
	tastes = list("semi-sweet bread" = 1)
	bitesize = 4
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/salad
	name = "salad"
	desc = "Cut fresh vegetables, loved by peasants and health-conscious nobles alike."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/cooking.dmi'
	icon_state = ""
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.812, /datum/reagent/consumable/nutriment/vitamin = 0.938)
	foodtypes = VEGETABLES
	tastes = list("fresh cabbage" = 1)
	bitesize = 5
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_portable = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/saltfish
	name = "saltfish"
	desc = "Dried fish."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/misc/fish.dmi'
	icon_state = "clownfishdried"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 3.375, /datum/reagent/consumable/nutriment/vitamin = 1.125)
	foodtypes = MEAT
	tastes = list("salted meat" = 1)
	bitesize = 4
	rogue_faretype = ROGUE_FARE_POOR
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/saltseeds
	name = "salted roasted seeds"
	desc = "Too salty for rats, delectable for humens."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "roastseeds"
	w_class = WEIGHT_CLASS_SMALL
	color = "#e5b175"
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.25, /datum/reagent/consumable/nutriment/vitamin = 0.75)
	foodtypes = VEGETABLES
	tastes = list("salted roasted seeds" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/scone
	name = "plain scone"
	desc = "A delightfully fancy treat adored by the upper echelons of Kingsfield."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "cookedscone"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 6.891, /datum/reagent/consumable/nutriment/vitamin = 2.297)
	foodtypes = GRAIN | DAIRY | SUGAR
	tastes = list("crumbly butterdough" = 1, "sweet" = 1)
	rotprocess = 30000
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/scone_choco
	name = "chocolate scone"
	desc = "A luxurious treat made with exotic chocolate."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "cookedsconechoc"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 11.109, /datum/reagent/consumable/nutriment/vitamin = 3.703)
	foodtypes = GRAIN | DAIRY | SUGAR
	tastes = list("crumbly butterdough" = 1, "sweet" = 1, "rich chocolate" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/scone_plum
	name = "plum scone"
	desc = "A delightfully fancy treat adored by the upper echelons of Kingsfield, complete with plum filling."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "cookedplumscone"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 10.266, /datum/reagent/consumable/nutriment/vitamin = 3.422)
	foodtypes = GRAIN | DAIRY | SUGAR | FRUIT
	tastes = list("crumbly butterdough" = 1, "sweet" = 1, "plum" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/scone_tangerine
	name = "tangerine scone"
	desc = "A delightfully fancy treat adored by the upper echelons of Kingsfield, complete with tangerine frosting."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "cookedtangerinescone"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 10.266, /datum/reagent/consumable/nutriment/vitamin = 3.422)
	foodtypes = GRAIN | DAIRY | SUGAR | FRUIT
	tastes = list("crumbly butterdough" = 1, "sweet" = 1, "tangerine" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/spiderhoney
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/spiderhoney

/obj/item/reagent_containers/food/snacks/vibelin/spiderhoney/honey
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/spiderhoney/honey

/obj/item/reagent_containers/food/snacks/vibelin/spiderhoney/honey/luminescent
	name = "moon honey"
	desc = "Strange blue honey, softly glowing with all the promise and danger of Noc's starborne knowledge."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "honey_glowing"
	w_class = WEIGHT_CLASS_TINY
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.25, /datum/reagent/consumable/nutriment/vitamin = 0.75, /datum/reagent/consumable/honey = 5, /datum/reagent/medicine/manapot = 10)
	foodtypes = SUGAR | RAW
	tastes = list("complex sweetness" = 1, "sharp floral tones" = 1)
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/spiderhoney/honey/mad
	name = "mad honey"
	desc = "Dark green honey tainted by the strange plants of the bog, yet often sought by Dendorite Melissae."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "honey_green"
	w_class = WEIGHT_CLASS_TINY
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.25, /datum/reagent/consumable/nutriment/vitamin = 0.75, /datum/reagent/consumable/honey = 4, /datum/reagent/druqks = 10, /datum/reagent/toxin = 5)
	foodtypes = SUGAR | RAW
	tastes = list("earthy sweetness" = 1, "something spicy" = 1)
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/spiderhoney/honey/poppy
	name = "rouge honey"
	desc = "A rich red honey, still used in traditional medicine and prized by the faithful of Pestra."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "honey_red"
	w_class = WEIGHT_CLASS_TINY
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.25, /datum/reagent/consumable/nutriment/vitamin = 0.75, /datum/reagent/consumable/honey = 4, /datum/reagent/ozium = 10)
	foodtypes = SUGAR | RAW
	tastes = list("numbing sweetness" = 1, "a flash of white" = 1)
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/stale_bread
	name = "stale bread"
	desc = "Old. Is that mold? Not fit for slicing, just eating in sullen silence."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "loaf"
	w_class = WEIGHT_CLASS_NORMAL
	color = "#92908a"
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 3.375, /datum/reagent/consumable/nutriment/vitamin = 1.125)
	foodtypes = GRAIN
	tastes = list("stale bread" = 1)
	rotprocess = 54000
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/strawberry_dried
	name = "dried strawberry"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "driedstrawberry"
	w_class = WEIGHT_CLASS_TINY
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 1.688, /datum/reagent/consumable/nutriment/vitamin = 0.562)
	foodtypes = FRUIT
	tastes = list("dried fruit" = 1)
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/strawbycake
	name = "strawberry cake base"
	desc = "With this sweet thing, you shall make them sing. Lacking sugar frosting."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "cake_filled"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 12.938, /datum/reagent/consumable/nutriment/vitamin = 4.312)
	foodtypes = GRAIN | DAIRY | FRUIT | RAW | EGG
	eat_effect = /datum/status_effect/rogue_food/uncooked
	rotprocess = 18000
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/strawbycake_ready
	name = "unbaked strawberry cake"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "strawberrycakeuncooked"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 14.438, /datum/reagent/consumable/nutriment/vitamin = 4.812)
	foodtypes = GRAIN | DAIRY | FRUIT | RAW | EGG | SUGAR
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/strawberrycake
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "fresh baked strawberry cake"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/sunreed_bread
	name = "sunbread"
	desc = "Preserves very well over long travels."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "maizebread"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 6.75, /datum/reagent/consumable/nutriment/vitamin = 2.25)
	foodtypes = GRAIN
	tastes = list("semi-sweet bread" = 1)
	bitesize = 4
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/sunreed_bread_slice
	slices_num = 4
	rogue_faretype = ROGUE_FARE_POOR
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/sunreed_bread/honey
	name = "honeyed sunbread"
	desc = "Poor-fare with rich topping."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "honey_maizebread"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 9, /datum/reagent/consumable/nutriment/vitamin = 3)
	foodtypes = GRAIN | SUGAR
	tastes = list("semi-sweet bread" = 1, "honey" = 1)
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/sunreed_bread_slice/honey
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/sunreed_bread_slice
	name = "sunbread cube"
	desc = "Cut into an exact fourth."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "maizebread_slice"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 1.688, /datum/reagent/consumable/nutriment/vitamin = 0.562)
	foodtypes = GRAIN
	tastes = list("semi-sweet bread" = 1)
	rogue_faretype = ROGUE_FARE_POOR
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/sunreed_bread_slice/honey
	name = "honeyed sunbread cube"
	desc = "Cut into an exact fourth."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "honey_maizebread_slice"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.25, /datum/reagent/consumable/nutriment/vitamin = 0.75)
	foodtypes = GRAIN | SUGAR
	tastes = list("semi-sweet bread" = 1, "honey" = 1)
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tamtocake
	name = "tamto silk cake base"
	desc = "With this sweet thing, you shall make them sing. Lacking fresh cheese glazing."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "cake_filled"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 12.938, /datum/reagent/consumable/nutriment/vitamin = 4.312)
	foodtypes = GRAIN | DAIRY | FRUIT | RAW | EGG
	eat_effect = /datum/status_effect/rogue_food/uncooked
	rotprocess = 18000
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tamtocake_cooked
	name = "tamto silk cake"
	desc = "A silky smooth cake with delectably sweet tamto filling, originating from the bogs of Daftmarsh."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "tomatosilk"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 23.203, /datum/reagent/consumable/nutriment/vitamin = 7.734)
	foodtypes = GRAIN | DAIRY | FRUIT | EGG | JUNKFOOD
	tastes = list("cake" = 1, "sweet tamto" = 1, "creamy cheese" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	rotprocess = 30000
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/tamtocake_slice
	slices_num = 6
	rogue_faretype = ROGUE_FARE_LAVISH
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tamtocake_ready
	name = "unbaked tamto silk cake"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "tomatosilk_raw"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 15.469, /datum/reagent/consumable/nutriment/vitamin = 5.156)
	foodtypes = GRAIN | DAIRY | FRUIT | RAW | EGG
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/tamtocake_cooked
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "fresh baked tamto silk caake"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tamtocake_slice
	name = "tamto silk cake slice"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "tomatosilk_slice"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 3.867, /datum/reagent/consumable/nutriment/vitamin = 1.289)
	foodtypes = GRAIN | DAIRY | FRUIT | EGG | JUNKFOOD
	tastes = list("cake" = 1, "sweet tamto" = 1, "creamy cheese" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	bitesize = 2
	rotprocess = 18000
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tamtoplate
	name = "cheese tamto plate"
	desc = "A deliciously greasy cheese half-pie originating from the trade-capital of Vanderlin, long may it reign!"
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pizza"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 10.547, /datum/reagent/consumable/nutriment/vitamin = 3.516)
	foodtypes = GRAIN | FRUIT | DAIRY
	tastes = list("crispy dough" = 1, "warm tomato" = 1, "gooey cheese" = 1, "" = 1)
	bitesize = 6
	rotprocess = 30000
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/tamtoplate_slice
	slices_num = 6
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tamtoplate/fish
	name = "fish tamto plate"
	desc = "A deliciously greasy fish half-pie originating from the trade-capital of Vanderlin, long may it reign!"
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "fish_pizza"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 13.922, /datum/reagent/consumable/nutriment/vitamin = 4.641)
	foodtypes = GRAIN | FRUIT | DAIRY | MEAT
	tastes = list("crispy dough" = 1, "warm tomato" = 1, "gooey cheese" = 1, "crispy fish" = 1)
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/tamtoplate_slice/fish
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tamtoplate/meat
	name = "sausage tamto plate"
	desc = "A deliciously greasy sausage half-pie originating from the trade-capital of Vanderlin, long may it reign!"
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "meat_pizza"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 17.297, /datum/reagent/consumable/nutriment/vitamin = 5.766)
	foodtypes = GRAIN | FRUIT | DAIRY | MEAT
	tastes = list("crispy dough" = 1, "warm tomato" = 1, "gooey cheese" = 1, "savory sausage" = 1)
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/tamtoplate_slice/meat
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tamtoplate/onion
	name = "onion tamto plate"
	desc = "A deliciously greasy onion half-pie originating from the trade-capital of Vanderlin, long may it reign!"
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "onion_pizza"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 13.359, /datum/reagent/consumable/nutriment/vitamin = 4.453)
	foodtypes = GRAIN | FRUIT | DAIRY | VEGETABLES
	tastes = list("crispy dough" = 1, "warm tomato" = 1, "gooey cheese" = 1, "crunchy onion" = 1)
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/tamtoplate_slice/onion
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tamtoplate_slice
	name = "cheese tamto plate slice"
	desc = "A deliciously greasy cheese half-pie originating from the trade-capital of Vanderlin, long may it reign!"
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pizza_slice"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 1.758, /datum/reagent/consumable/nutriment/vitamin = 0.586)
	foodtypes = GRAIN | FRUIT | DAIRY
	tastes = list("crispy dough" = 1, "warm tomato" = 1, "gooey cheese" = 1, "" = 1)
	rotprocess = 30000
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tamtoplate_slice/fish
	name = "sausage tamto plate"
	desc = "A deliciously greasy fish half-pie originating from the trade-capital of Vanderlin, long may it reign!"
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "fish_pizza_slice"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.32, /datum/reagent/consumable/nutriment/vitamin = 0.773)
	foodtypes = GRAIN | FRUIT | DAIRY | MEAT
	tastes = list("crispy dough" = 1, "warm tomato" = 1, "gooey cheese" = 1, "crispy fish" = 1)
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tamtoplate_slice/meat
	name = "sausage tamto plate slice"
	desc = "A deliciously greasy sausage half-pie originating from the trade-capital of Vanderlin, long may it reign!"
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "meat_pizza_slice"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.883, /datum/reagent/consumable/nutriment/vitamin = 0.961)
	foodtypes = GRAIN | FRUIT | DAIRY | MEAT
	tastes = list("crispy dough" = 1, "warm tomato" = 1, "gooey cheese" = 1, "savory sausage" = 1)
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tamtoplate_slice/onion
	name = "onion tamto plate slice"
	desc = "A deliciously greasy onion half-pie originating from the trade-capital of Vanderlin, long may it reign!"
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "onion_pizza_slice"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.227, /datum/reagent/consumable/nutriment/vitamin = 0.742)
	foodtypes = GRAIN | FRUIT | DAIRY | VEGETABLES
	tastes = list("crispy dough" = 1, "warm tomato" = 1, "gooey cheese" = 1, "crunchy onion" = 1)
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tangerine_dried
	name = "dried tangerine"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "driedtangerine"
	w_class = WEIGHT_CLASS_TINY
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 1.688, /datum/reagent/consumable/nutriment/vitamin = 0.562)
	foodtypes = FRUIT
	tastes = list("dried fruit" = 1)
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tangerinebutterdough
	name = "tangerine butterdough"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "butterdough_tangerine"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 7.875, /datum/reagent/consumable/nutriment/vitamin = 2.625)
	foodtypes = GRAIN | RAW | DAIRY | FRUIT
	tastes = list("buttery dough" = 1, "dried tangerines" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/tangerinebookbread
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "fresh baked pastry"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tangerinecake_cooked
	name = "scarletharp cake"
	desc = "The Scarletharp cake, named not so aptly for its town of origin, is a twist on the traditional lunch cake substituting the dried fruit bits for a center filling of tangerine jam."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "tangerinecake"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 21.656, /datum/reagent/consumable/nutriment/vitamin = 7.219)
	foodtypes = GRAIN | DAIRY | FRUIT | EGG | SUGAR | JUNKFOOD
	tastes = list("cake" = 1, "tangerine" = 1, "sugar" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	rotprocess = 30000
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/tangerinecake_slice
	slices_num = 6
	rogue_faretype = ROGUE_FARE_LAVISH
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tangerinecake_ready
	name = "unbaked scarletharp cake"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "tangerinecakeraw"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 14.438, /datum/reagent/consumable/nutriment/vitamin = 4.812)
	foodtypes = GRAIN | DAIRY | FRUIT | RAW | EGG | SUGAR
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/tangerinecake_cooked
	cooktime = 250
	rotprocess = 18000
	rogue_cooked_smell = "fresh baked strawberry cake"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tangerinecake_slice
	name = "scarletharp cake slice"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "tangerinecakeslice"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 3.609, /datum/reagent/consumable/nutriment/vitamin = 1.203)
	foodtypes = GRAIN | DAIRY | FRUIT | EGG | SUGAR | JUNKFOOD
	tastes = list("cake" = 1, "tangerine" = 1, "sugar" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	bitesize = 2
	rotprocess = 18000
	rogue_faretype = ROGUE_FARE_FINE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tart
	name = "tart"
	desc = "A sweet and delicate pastry."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = null
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 0.75, /datum/reagent/consumable/nutriment/vitamin = 0.25)
	foodtypes = GRAIN
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tart/cooked
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/tart/cooked

/obj/item/reagent_containers/food/snacks/vibelin/tart/cooked/avocado
	name = "avocado tart"
	desc = "A smooth and creamy tart filled with mashed avocado."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "avocadotart"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 11.971, /datum/reagent/consumable/nutriment/vitamin = 3.99)
	foodtypes = GRAIN | DAIRY | FRUIT
	tastes = list("avocado and butterdough" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/tartslice/avocado
	slices_num = 4
	rogue_faretype = ROGUE_FARE_LAVISH
	rogue_portable = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tart/cooked/chocolate
	name = "chocolate tart"
	desc = "A tart filled with rich, sweet chocolate."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "choctart"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 11.971, /datum/reagent/consumable/nutriment/vitamin = 3.99)
	foodtypes = GRAIN | DAIRY | FRUIT
	tastes = list("chocolate and butterdough" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/tartslice/chocolate
	slices_num = 4
	rogue_faretype = ROGUE_FARE_LAVISH
	rogue_portable = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tart/cooked/dragonfruit
	name = "piyata tart"
	desc = "A tart topped with mild, refreshing dragonfruit."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "dragonfruittart"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 11.971, /datum/reagent/consumable/nutriment/vitamin = 3.99)
	foodtypes = GRAIN | DAIRY | FRUIT
	tastes = list("piyata and butterdough" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/tartslice/dragonfruit
	slices_num = 4
	rogue_faretype = ROGUE_FARE_LAVISH
	rogue_portable = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tart/cooked/mango
	name = "mangga tart"
	desc = "A tart filled with the tropical mangga flesh."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "mangotart"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 11.971, /datum/reagent/consumable/nutriment/vitamin = 3.99)
	foodtypes = GRAIN | DAIRY | FRUIT
	tastes = list("mango and butterdough" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/tartslice/mango
	slices_num = 4
	rogue_faretype = ROGUE_FARE_LAVISH
	rogue_portable = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tart/cooked/mangosteen
	name = "mangosteen tart"
	desc = "A tart with the sweet tang of mangosteen."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "mangosteentart"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 11.971, /datum/reagent/consumable/nutriment/vitamin = 3.99)
	foodtypes = GRAIN | DAIRY | FRUIT
	tastes = list("mangosteen and butterdough" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/tartslice/mangosteen
	slices_num = 4
	rogue_faretype = ROGUE_FARE_LAVISH
	rogue_portable = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tart/cooked/pineapple
	name = "ananas tart"
	desc = "A tart bursting with bright, tangy pineapple."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pineappletart"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 11.971, /datum/reagent/consumable/nutriment/vitamin = 3.99)
	foodtypes = GRAIN | DAIRY | FRUIT | PINEAPPLE
	tastes = list("ananas and butterdough" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/tartslice/pineapple
	slices_num = 4
	rogue_faretype = ROGUE_FARE_LAVISH
	rogue_portable = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tartslice
	name = "tart slice"
	desc = "A small slice of tart."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = ""
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 2.993, /datum/reagent/consumable/nutriment/vitamin = 0.998)
	foodtypes = GRAIN | DAIRY | FRUIT
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	rotprocess = 30000
	rogue_faretype = ROGUE_FARE_FINE
	rogue_portable = FALSE
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tartslice/avocado
	name = "avocado tart slice"
	desc = "A small slice of tart."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "avocadotart_slice"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	tastes = list("avocado and butterdough" = 1)
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tartslice/chocolate
	name = "chocolate tart slice"
	desc = "A small slice of tart."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "choctart_slice"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	tastes = list("chocolate and butterdough" = 1)
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tartslice/dragonfruit
	name = "piyata tart slice"
	desc = "A small slice of tart."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "dragonfruittart_slice"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	tastes = list("piyata and butterdough" = 1)
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tartslice/mango
	name = "mangga tart slice"
	desc = "A small slice of tart."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "mangotart_slice"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	tastes = list("mango and butterdough" = 1)
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tartslice/mangosteen
	name = "mangosteen tart slice"
	desc = "A small slice of tart."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "mangosteentart_slice"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	tastes = list("mangosteen and butterdough" = 1)
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tartslice/pineapple
	name = "ananas tart slice"
	desc = "A small slice of tart."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "pineappletart_slice"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	foodtypes = GRAIN | DAIRY | FRUIT | PINEAPPLE
	tastes = list("ananas and butterdough" = 1)
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tiefsugar
	name = "Tiefling Sugar"
	desc = "Originating from subterra, Tiefling blood that has been expertly dried and mixed into a sugar base, sweetens when boiled."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/produce.dmi'
	icon_state = "tsugar"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 1.5, /datum/reagent/consumable/nutriment/vitamin = 0.5)
	foodtypes = SUGAR | RAW
	tastes = list("sweet" = 1)
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tostada
	name = "sunreed plato"
	desc = "Fried sunreed which makes a delicious plate."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "tostada"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 3.375, /datum/reagent/consumable/nutriment/vitamin = 1.125)
	foodtypes = GRAIN
	tastes = list("crunchy sunreed dough" = 1)
	bitesize = 5
	rogue_faretype = ROGUE_FARE_POOR
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tostada_meat
	name = "steak plato"
	desc = "Succulent frysteak on an edible plate."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "tostada_steak"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 10.125, /datum/reagent/consumable/nutriment/vitamin = 3.375)
	foodtypes = GRAIN
	tastes = list("crunchy sunreed dough" = 1, "warm steak" = 1)
	bitesize = 5
	rogue_faretype = ROGUE_FARE_NEUTRAL
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tostada_meat/chicken
	name = "frybird plato"
	desc = "Fried bird on an edible plate."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "tostada_steak"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	tastes = list("crunchy sunreed dough" = 1, "frybird" = 1)
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tostada_meat/egg
	name = "egg plato"
	desc = "Sunny-side egg on an edible plate."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "tostada_egg"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	tastes = list("crunchy sunreed dough" = 1, "fried egg" = 1)
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/tostada_meat/fish
	name = "fish plato"
	desc = "Crispy fish on an edible plate."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "tostada_fish"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	tastes = list("crunchy sunreed dough" = 1, "crispy fish" = 1)
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/veg
	abstract_type = /obj/item/reagent_containers/food/snacks/vibelin/veg

/obj/item/reagent_containers/food/snacks/vibelin/veg/cocaudo_half
	name = "cocaudo half"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "cocaudo_split"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 1.875, /datum/reagent/consumable/nutriment/vitamin = 0.625)
	foodtypes = GRAIN
	tastes = list("savory goo" = 1)
	rogue_faretype = ROGUE_FARE_POOR
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/waddle_dried
	name = "dried waddle"
	desc = "A waddle mushroom that has been dried for use in tea. Not pleasant to eat in this state."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "driedwaddle"
	w_class = WEIGHT_CLASS_TINY
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 1.406, /datum/reagent/consumable/nutriment/vitamin = 0.469)
	tastes = list("woody" = 1, "bitter" = 1)
	eat_effect = /datum/status_effect/rogue_food/uncooked
	rogue_faretype = ROGUE_FARE_POOR
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/xylixbun
	name = "xylixbun"
	desc = "A very smug looking bun throwing up a holy gesture. Surely nothing bad could come of eating this?"
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "xylixbun"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 6.188, /datum/reagent/consumable/nutriment/vitamin = 2.062)
	foodtypes = GRAIN | DAIRY
	tastes = list("horribly spicy bread" = 1)
	rotprocess = 18000
	rogue_faretype = ROGUE_FARE_POOR
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/zybcake
	name = "zaladin cake base"
	desc = "With this sweet thing, you shall make them sing. Lacking spider-honey glazing."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "cake_filled"
	w_class = WEIGHT_CLASS_SMALL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 12.938, /datum/reagent/consumable/nutriment/vitamin = 4.312)
	foodtypes = GRAIN | DAIRY | FRUIT | RAW | EGG
	eat_effect = /datum/status_effect/rogue_food/uncooked
	rotprocess = 30000
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/zybcake_cooked
	name = "zalad cake"
	desc = "Cake glazed with honey, in the famous Zaladin fashion, a delicious sweet treat. Said to be very hard to poison, perhaps the honey counteracting such malicious concotions."
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "honeycake"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 22.781, /datum/reagent/consumable/nutriment/vitamin = 7.594)
	foodtypes = GRAIN | FRUIT | SUGAR | DAIRY | JUNKFOOD | EGG
	tastes = list("cake" = 1, "pear" = 1, "delicious honeyfrosting" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	rotprocess = 30000
	slice_path = /obj/item/reagent_containers/food/snacks/vibelin/zybcake_slice
	slices_num = 6
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/zybcake_ready
	name = "unbaked zaladin cake"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "honeycakeuncook"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 15.188, /datum/reagent/consumable/nutriment/vitamin = 5.062)
	foodtypes = GRAIN | DAIRY | FRUIT | RAW | EGG
	eat_effect = /datum/status_effect/rogue_food/uncooked
	cooked_type = /obj/item/reagent_containers/food/snacks/vibelin/zybcake_cooked
	cooktime = 250
	rotprocess = 30000
	rogue_cooked_smell = "fresh baked honey cake"
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/reagent_containers/food/snacks/vibelin/zybcake_slice
	name = "zalad cake slice"
	desc = ""
	icon = 'modular_redtard/items_vibelin/icons/icons/roguetown/items/food.dmi'
	icon_state = "hcake_slice"
	w_class = WEIGHT_CLASS_NORMAL
	rogue_grid_width = 32
	rogue_grid_height = 32
	food_reagents = list(/datum/reagent/consumable/nutriment = 3.797, /datum/reagent/consumable/nutriment/vitamin = 1.266)
	foodtypes = GRAIN | FRUIT | SUGAR | DAIRY | JUNKFOOD | EGG
	tastes = list("cake" = 1, "pear" = 1, "delicious honeyfrosting" = 1)
	eat_effect = /datum/status_effect/rogue_food_buff/great_snack
	bitesize = 2
	rotprocess = 18000
	rogue_faretype = ROGUE_FARE_LAVISH
	rogue_sleeved = null
	worn_icon_state = null
	worn_x_dimension = 32
	worn_y_dimension = 32
