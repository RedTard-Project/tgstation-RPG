// Written by modular_redtard/tools/port_vibelin_food.py from modular_redtard/items_vibelin/food_port.json; do not edit by hand.
// Vibelin's table recipes (repeatable cooking, orderless slapcraft) of its own food, as slapcraft recipes of the module (survival/recipes.dm).

/datum/rogue_food_recipe/vibelin

/datum/rogue_food_recipe/vibelin/orderless_pie_blackberry
	name = "Unbaked Blackberry Pie"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/piebottom
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry, /obj/item/reagent_containers/food/snacks/grown/fruit/blackberry, /obj/item/reagent_containers/food/snacks/grown/fruit/blackberry, /obj/item/reagent_containers/food/snacks/rogue/piedough)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/raw_pie/blackberry
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/orderless_pie_borowiki
	name = "unbaked borowiki pie"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/piebottom
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/produce/mushroom/borowiki, /obj/item/reagent_containers/food/snacks/vibelin/produce/mushroom/borowiki, /obj/item/reagent_containers/food/snacks/vibelin/produce/mushroom/borowiki, /obj/item/reagent_containers/food/snacks/rogue/piedough)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/raw_pie/borowiki
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/orderless_pie_pear
	name = "Unbaked Pear Pie"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/piebottom
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/pear, /obj/item/reagent_containers/food/snacks/grown/fruit/pear, /obj/item/reagent_containers/food/snacks/grown/fruit/pear, /obj/item/reagent_containers/food/snacks/rogue/piedough)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/raw_pie/pear
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/orderless_pie_pompkaun
	name = "Unbaked Pompkaun Pie"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/piebottom
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/fruit/pompkaun_goo, /obj/item/reagent_containers/food/snacks/vibelin/fruit/pompkaun_goo, /obj/item/reagent_containers/food/snacks/vibelin/fruit/pompkaun_goo, /obj/item/reagent_containers/food/snacks/rogue/piedough)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/raw_pie/pompkaun
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/orderless_pie_pot
	name = "Unbaked Pot Pie"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/piebottom
	ingredients = list(list(/obj/item/reagent_containers/food/snacks/rogue/cheddarwedge, /obj/item/reagent_containers/food/snacks/rogue/cheese, /obj/item/reagent_containers/food/snacks/butterslice, /obj/item/reagent_containers/food/snacks/egg), list(/obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced, /obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced, /obj/item/reagent_containers/food/snacks/veg/turnip_sliced, /obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced, /obj/item/reagent_containers/food/snacks/roastseeds), list(/obj/item/reagent_containers/food/snacks/rogue/meat/mince/poultry, /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef, /obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish, /obj/item/reagent_containers/food/snacks/fat), /obj/item/reagent_containers/food/snacks/rogue/piedough)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/raw_pie/pot_pie
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/orderless_pie_raspberry
	name = "Unbaked Raspberry Pie"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/piebottom
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry, /obj/item/reagent_containers/food/snacks/grown/fruit/raspberry, /obj/item/reagent_containers/food/snacks/grown/fruit/raspberry, /obj/item/reagent_containers/food/snacks/rogue/piedough)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/raw_pie/raspberry
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/orderless_tart_avocado
	name = "Unbaked Avocado Tart"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/tartcrust
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/fruit/avocado_half, /obj/item/reagent_containers/food/snacks/vibelin/fruit/avocado_half, /obj/item/reagent_containers/food/snacks/vibelin/fruit/avocado_half, /obj/item/reagent_containers/food/snacks/sugar)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/raw_tart/avocado
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/orderless_tart_chocolate
	name = "Unbaked Chocolate Tart"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/tartcrust
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/chocolate/chunk, /obj/item/reagent_containers/food/snacks/vibelin/chocolate/chunk, /obj/item/reagent_containers/food/snacks/vibelin/chocolate/chunk, /obj/item/reagent_containers/food/snacks/sugar)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/raw_tart/chocolate
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/orderless_tart_dragonfruit
	name = "Unbaked Piyata Tart"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/tartcrust
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/fruit/dragonfruit_half, /obj/item/reagent_containers/food/snacks/vibelin/fruit/dragonfruit_half, /obj/item/reagent_containers/food/snacks/vibelin/fruit/dragonfruit_half, /obj/item/reagent_containers/food/snacks/sugar)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/raw_tart/dragonfruit
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/orderless_tart_mango
	name = "Unbaked Mangga Tart"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/tartcrust
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/fruit/mango_half, /obj/item/reagent_containers/food/snacks/vibelin/fruit/mango_half, /obj/item/reagent_containers/food/snacks/vibelin/fruit/mango_half, /obj/item/reagent_containers/food/snacks/sugar)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/raw_tart/mango
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/orderless_tart_mangosteen
	name = "Unbaked Mangosteen Tart"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/tartcrust
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/fruit/mangosteen_opened, /obj/item/reagent_containers/food/snacks/vibelin/fruit/mangosteen_opened, /obj/item/reagent_containers/food/snacks/vibelin/fruit/mangosteen_opened, /obj/item/reagent_containers/food/snacks/sugar)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/raw_tart/mangosteen
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/orderless_tart_pineapple
	name = "Unbaked Ananas Tart"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/tartcrust
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/fruit/pineapple_slice, /obj/item/reagent_containers/food/snacks/vibelin/fruit/pineapple_slice, /obj/item/reagent_containers/food/snacks/vibelin/fruit/pineapple_slice, /obj/item/reagent_containers/food/snacks/sugar)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/raw_tart/pineapple
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_apple_fritter_raw
	name = "Raw Apple Fritter"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/apple)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/fritter_raw
	time_per_step = 60

/datum/rogue_food_recipe/vibelin/table_beef_mett
	name = "Grenzel Mett"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/meat/mince/beef/mett
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_blackberry_butter_dough
	name = "Blackberry Butterdough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdough
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/blackberrybutterdough
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_cake_pear
	name = "Zaladin Cake Base"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/cake_base
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/pear)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/zybcake
	time_per_step = 90

/datum/rogue_food_recipe/vibelin/table_cake_plum
	name = "Crimson Pine Cake Base"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/cake_base
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/plum)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/crimsoncake
	time_per_step = 90

/datum/rogue_food_recipe/vibelin/table_cake_strawberry
	name = "Strawberry Cake Base"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/cake_base
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/strawberry)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/strawbycake
	time_per_step = 90

/datum/rogue_food_recipe/vibelin/table_cake_tamto
	name = "Tomato Silk Cake Base"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/cake_base
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/fruit/tamto_slice)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/tamtocake
	time_per_step = 90

/datum/rogue_food_recipe/vibelin/table_chescake
	name = "Raisin Cheesecake Base"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/cake_base
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/chescake
	time_per_step = 60

/datum/rogue_food_recipe/vibelin/table_chescake_raisan
	name = "Cheesecake Base"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/cake_base
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/raisins)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/chescake
	time_per_step = 60

/datum/rogue_food_recipe/vibelin/table_choccy_chip_dough
	name = "Chocolate Chip Cookie Dough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdough
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/chocolate/chunk)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/choccy_chip_dough
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_chocolate_bun
	name = "Unbaked Chocolate Bun"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/doughslice
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/chocolate/chunk)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/choco_bun_raw
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_chocolate_butter_dough
	name = "Chocolate Butterdough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdough
	ingredients = list(/obj/item/reagent_containers/food/snacks/chocolate)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/chocolatebutterdough
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_chocolate_pastry
	name = "Unbaked Chocolate Pastry"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/chocolate/chunk)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/choco_butterdough_slice
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_cocaumole_chip
	name = "Cocaumole Sun-Cracker"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/cocaumole
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/chip)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/chip_cocaumole
	time_per_step = 10

/datum/rogue_food_recipe/vibelin/table_cocaumole_chippile
	name = "Cocaumole Sun-Crackers"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/chippile
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/cocaumole)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/chippile/cocaumole
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_comelette
	name = "Uncooked Caravaneer's Omelette"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/comelette_base
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/comelette_uncooked
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_comelette_base
	name = "Caravaneer's Omelette Base"
	base_item = /obj/item/reagent_containers/food/snacks/egg
	ingredients = list(/obj/item/reagent_containers/food/snacks/egg)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/comelette_base
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_comelette_meat
	name = "Uncooked Meat Caravaneer's Omelette"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/comelette_uncooked
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/comelette_uncooked/meat
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_comelette_veggie
	name = "Uncooked Veggie Caravaneer's Omelette"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/comelette_uncooked
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/comelette_uncooked/veggie
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_deepfry_cutlet
	name = "Crumb Coated Bird Meat"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/meat/poultry/cutlet/egg_washed
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/toastcrumbs)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/meat/poultry/cutlet/coated

/datum/rogue_food_recipe/vibelin/table_drowsbane_chip
	name = "Drowsbane Sun-Cracker"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/drowsbanejam
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/chip)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/chip_drowsbane
	time_per_step = 10

/datum/rogue_food_recipe/vibelin/table_drowsbane_chippile
	name = "Drowsbane Sun-Crackers"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/chippile
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/drowsbanejam)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/chippile/drowsbane
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_eighthscake_unbaked
	name = "Unbaked Eightscake"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/masa
	ingredients = list(/obj/item/reagent_containers/food/snacks/egg)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/eighthscake_unbaked
	time_per_step = 90

/datum/rogue_food_recipe/vibelin/table_frybird_herbs
	name = "Herbbird"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried
	ingredients = list(/obj/item/reagent_containers/powder/vibelin/herbs)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/cooked/herbbird

/datum/rogue_food_recipe/vibelin/table_frybird_potato
	name = "Frybird and Tatos"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/potato/rogue)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/cooked/frybird_tatos

/datum/rogue_food_recipe/vibelin/table_frysteak_drowsbane
	name = "Frysteak and Drowsbane"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/drowsbanejam)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/cooked/frysteak_salsa

/datum/rogue_food_recipe/vibelin/table_frysteak_herbs
	name = "Herbsteak"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	ingredients = list(/obj/item/reagent_containers/powder/vibelin/herbs)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/cooked/herbsteak

/datum/rogue_food_recipe/vibelin/table_frysteak_potato
	name = "Frysteak and Tatos"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/potato/rogue)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/cooked/frysteak_tatos

/datum/rogue_food_recipe/vibelin/table_grenzelbun_cocaumole
	name = "Grenzel Bun With Cocaumole"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/bun_grenz
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/cocaumole)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/grenzelbun_cocaumole
	time_per_step = 60

/datum/rogue_food_recipe/vibelin/table_grenzelbun_cocaumole_alt
	name = "Grenzel Bun With Cocaumole"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/bun
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/cooked/sausage_cocaumole)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/grenzelbun_cocaumole
	time_per_step = 60

/datum/rogue_food_recipe/vibelin/table_huskbun_husk
	name = "Sunreed Husk"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/masa_slice
	ingredients = list(/obj/item/natural/fibers)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/huskbunbase
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_jellycake_apple
	name = "Apple Jellycake"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/jellycake_base
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/apple)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/jellycake_apple
	time_per_step = 90

/datum/rogue_food_recipe/vibelin/table_jellycake_dried_apple
	name = "Dried Apple Jellycake"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/jellycake_base
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/apple_dried)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/jellycake_apple
	time_per_step = 90

/datum/rogue_food_recipe/vibelin/table_jellycake_dried_pear
	name = "Dried Pear Jellycake"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/jellycake_base
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/pear_dried)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/jellycake_pear
	time_per_step = 90

/datum/rogue_food_recipe/vibelin/table_jellycake_dried_plum
	name = "Dried Plum Jellycake"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/jellycake_base
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/plum_dried)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/jellycake_plum
	time_per_step = 90

/datum/rogue_food_recipe/vibelin/table_jellycake_dried_tangerine
	name = "Dried Tangerine Jellycake"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/jellycake_base
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/tangerine_dried)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/jellycake_tangerine
	time_per_step = 90

/datum/rogue_food_recipe/vibelin/table_jellycake_lime
	name = "Lime Jellycake"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/jellycake_base
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/lime)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/jellycake_lime
	time_per_step = 90

/datum/rogue_food_recipe/vibelin/table_jellycake_pear
	name = "Pear Jellycake"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/jellycake_base
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/pear)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/jellycake_pear
	time_per_step = 90

/datum/rogue_food_recipe/vibelin/table_jellycake_plum
	name = "Plum Jellycake"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/jellycake_base
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/plum)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/jellycake_plum
	time_per_step = 90

/datum/rogue_food_recipe/vibelin/table_jellycake_tangerine
	name = "Tangerine Jellycake"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/jellycake_base
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/jellycake_tangerine
	time_per_step = 90

/datum/rogue_food_recipe/vibelin/table_lemon_butter_dough
	name = "Lemon Butterdough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdough
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/lemon)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/lemonbutterdough
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_lemon_eighthscake_unbaked
	name = "Unbaked Lemon Eighthscake"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/eighthscake_unbaked
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/lemon)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/eighthscake_unbaked/lemon
	time_per_step = 90

/datum/rogue_food_recipe/vibelin/table_lime_eighthscake_unbaked
	name = "Unbaked Lime Eighthscake"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/eighthscake_unbaked
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/lime)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/eighthscake_unbaked/lime
	time_per_step = 90

/datum/rogue_food_recipe/vibelin/table_masa_honey
	name = "Honeyed Sunreed Dough"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/masa
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/honey/spider)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/masa_honey
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_pear_butter_dough
	name = "Pear Butterdough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdough
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/pear_dried)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/pearbutterdough
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_pestranstick
	name = "Pestran Stick"
	base_item = /obj/item/reagent_containers/food/snacks/butterslice
	ingredients = list(/obj/item/grown/log/tree/stick)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/pestranstick
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_plato_egg
	name = "Egg Plato"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/tostada
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/friedegg/fried)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/tostada_meat/egg
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_plato_fish
	name = "Fish Plato"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/tostada
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/fryfish)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/tostada_meat/fish
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_plato_frybird
	name = "Frybird Plato"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/tostada
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/tostada_meat/chicken
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_plato_steak
	name = "Steak Plato"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/tostada
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/tostada_meat
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_plum_butter_dough
	name = "Plum Butterdough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdough
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/plum_dried)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/plumbutterdough
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_raisin_butter_dough
	name = "Raisin Butterdough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdough
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/raisins)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/jacksberrybutterdough
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_raisin_dough
	name = "Raisin Dough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/dough
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/raisins)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/raisindough
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_raspberry_butter_dough
	name = "Raspberry Butterdough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdough
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/raspberrybutterdough
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_raw_griddle_cake
	name = "Raw Griddlecake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	ingredients = list(/obj/item/reagent_containers/food/snacks/egg)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/griddlecake_raw
	time_per_step = 60

/datum/rogue_food_recipe/vibelin/table_raw_griddle_dog
	name = "Raw Griddledog"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/cooked/sausage_sticked)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/griddledog_raw
	time_per_step = 60

/datum/rogue_food_recipe/vibelin/table_raw_sausage
	name = "Fatty Raw Sausage"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/mince
	ingredients = list(/obj/item/reagent_containers/food/snacks/fat)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/meat/sausage/wiener
	time_per_step = 90

/datum/rogue_food_recipe/vibelin/table_reform_masa
	name = "Reform Sunreed Dough"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/masa_slice
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/masa_slice)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/masa
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_ribrack_honey
	name = "Glazed Rib Rack"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/bread/ribrack
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/honey/spider)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/bread/ribrack/honey

/datum/rogue_food_recipe/vibelin/table_royal_truffle
	name = "Royal Truffles"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/cooked/ham
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/cooked/truffle)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/cooked/royal_truffle

/datum/rogue_food_recipe/vibelin/table_salsa
	name = "Drowsbane Jam"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/produce/mushroom/drowsbane
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/fruit/tamto_slice)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/drowsbanejam
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_tamtoplate_base
	name = "Tamtoplate Base"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/flatdough
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/fruit/tamto_slice)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/tamtoplate_base
	time_per_step = 60

/datum/rogue_food_recipe/vibelin/table_tamtoplate_cheese
	name = "Unbaked Cheese Tamtoplate"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/tamtoplate_base
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/cheese)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/tamtoplate_unfinished
	time_per_step = 60

/datum/rogue_food_recipe/vibelin/table_tangerine_butter_dough
	name = "Tangerine Butterdough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdough
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/tangerine_dried)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/tangerinebutterdough
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_unbaked_cheesecake
	name = "Unbaked Cheesecake"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/chescake
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/cheese)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/ccakeuncooked
	time_per_step = 90

/datum/rogue_food_recipe/vibelin/table_unbaked_crimsoncake
	name = "Unbaked Crimson Cake"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/crimsoncake
	ingredients = list(/obj/item/reagent_containers/food/snacks/chocolate)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/crimsoncake_ready
	time_per_step = 90

/datum/rogue_food_recipe/vibelin/table_unbaked_dottart_blackberry
	name = "Unbaked Blackberry Dot Tart"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/dottart_base
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/dottart_base/blackberry
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_unbaked_dottart_lemon
	name = "Unbaked Lemon Dot Tart"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/dottart_base
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/lemon)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/dottart_base/lemon
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_unbaked_dottart_lime
	name = "Unbaked Lime Dot Tart"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/dottart_base
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/lime)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/dottart_base/lime
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_unbaked_dottart_pear
	name = "Unbaked Pear Dot Tart"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/dottart_base
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/pear)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/dottart_base/pear
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_unbaked_dottart_plum
	name = "Unbaked Plum Dot Tart"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/dottart_base
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/plum)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/dottart_base/plum
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_unbaked_dottart_raspberry
	name = "Unbaked Raspberry Dot Tart"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/dottart_base
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/dottart_base/raspberry
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_unbaked_dottart_strawberry
	name = "Unbaked Strawberry Dot Tart"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/dottart_base
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/strawberry)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/dottart_base/strawberry
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_unbaked_dottart_tangerine
	name = "Unbaked Tangerine Dot Tart"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/dottart_base
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/dottart_base/tangerine
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_unbaked_griddlecake_apple
	name = "Unbaked Apple Griddlecake"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/griddlecake_raw
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/apple)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/applegriddlecake_raw
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_unbaked_griddlecake_berry
	name = "Unbaked Berry Griddlecake"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/griddlecake_raw
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/berrygriddlecake_raw
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_unbaked_griddlecake_dried_apple
	name = "Unbaked Dried Apple Griddlecake"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/griddlecake_raw
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/apple_dried)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/applegriddlecake_raw
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_unbaked_griddlecake_lemon
	name = "Unbaked Lemon Griddlecake"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/griddlecake_raw
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/lemon)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/lemongriddlecake_raw
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_unbaked_griddlecake_raisin
	name = "Unbaked Raisin Griddlecake"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/griddlecake_raw
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/raisins)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/berrygriddlecake_raw
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_unbaked_scone_choco
	name = "Unbaked Chocolate Scone"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/scone_raw
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/chocolate/chunk)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/scone_raw_choco
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_unbaked_scone_plum
	name = "Unbaked Plum Scone"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/scone_raw
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/plum)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/scone_raw_plum
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_unbaked_scone_tangerine
	name = "Unbaked Tangerine Scone"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/scone_raw
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/scone_raw_tangerine
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_unbaked_scones
	name = "Unbaked Scones"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	ingredients = list(/obj/item/reagent_containers/food/snacks/sugar)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/scone_raw
	time_per_step = 60

/datum/rogue_food_recipe/vibelin/table_unbaked_strawberrycake
	name = "Unbaked Strawberry Cake"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/strawbycake
	ingredients = list(/obj/item/reagent_containers/food/snacks/sugar)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/strawbycake_ready
	time_per_step = 90

/datum/rogue_food_recipe/vibelin/table_unbaked_tamtocake
	name = "Unbaked Tomato Silk Cake"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/tamtocake
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/cheese)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/tamtocake_ready
	time_per_step = 90

/datum/rogue_food_recipe/vibelin/table_unbaked_tangerinecake
	name = "Unbaked Scarletharp Cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/tangerinecake
	ingredients = list(/obj/item/reagent_containers/food/snacks/sugar)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/tangerinecake_ready
	time_per_step = 90

/datum/rogue_food_recipe/vibelin/table_unbaked_zybcake
	name = "Unbaked Zaladin Cake"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/zybcake
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/honey/spider)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/zybcake_ready
	time_per_step = 90

/datum/rogue_food_recipe/vibelin/table_uncooked_tamtoplate_fish
	name = "Unbaked Fish Tamto Plate"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/tamtoplate_unfinished
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/tamtoplate_unfinished_fish
	time_per_step = 30

/datum/rogue_food_recipe/vibelin/table_uncooked_tamtoplate_meat
	name = "Unbaked Sausage Tamto Plate"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/tamtoplate_unfinished
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/meat/sausage)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/tamtoplate_unfinished_meat
	time_per_step = 30

/datum/rogue_food_recipe/vibelin/table_uncooked_tamtoplate_onion
	name = "Unbaked Onion Tamto Plate"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/tamtoplate_unfinished
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/tamtoplate_unfinished_onion
	time_per_step = 30

/datum/rogue_food_recipe/vibelin/table_valorian_omlette
	name = "Valorian Omlette"
	base_item = /obj/item/reagent_containers/food/snacks/vibelin/cooked/twin_egg
	ingredients = list(/obj/item/reagent_containers/food/snacks/rogue/cheddarwedge)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/cooked/valorian_omlette
	time_per_step = 50

/datum/rogue_food_recipe/vibelin/table_wiener_cocaumole
	name = "Wiener with Cocaumole"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/cocaumole)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/cooked/sausage_cocaumole

/datum/rogue_food_recipe/vibelin/table_wiener_stick
	name = "Skewered Wiener"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	ingredients = list(/obj/item/grown/log/tree/stick)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/cooked/sausage_sticked
	time_per_step = 30

/datum/rogue_food_recipe/vibelin/table_xylixbun
	name = "Xylixbun"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/doughslice
	ingredients = list(/obj/item/reagent_containers/food/snacks/vibelin/produce/mushroom/drowsbane)
	result_type = /obj/item/reagent_containers/food/snacks/vibelin/foodbase/xylixbun_raw
	time_per_step = 60
