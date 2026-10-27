// Ratwood palate (code/modules/food_and_drinks/food/snacks.dm On_Consume(), modules/client/preferences_culinary.dm,
// mob/living/rolecheck.dm, datums/stress/*_events.dm): how fine a food is (fare), the noble palate, favourite and hated
// food and drink, and the smell of fresh cooking (datums/pollutants/foods.dm). Ratwood stress is TG mood here (-1 stress is
// +ROGUE_STRESS_TO_MOOD mood).

/obj/item/reagent_containers/food
	/// Ratwood faretype (ROGUE_FARE_*). Null - Ratwood's value from GLOB.rogue_food_fare, else food for the desperate.
	var/rogue_faretype
	/// Ratwood portable: a noble may eat it away from a table. Null - from GLOB.rogue_food_not_portable.
	var/rogue_portable
	/// Ratwood cooked_smell: what fills the air when this is cooked. Null - from GLOB.rogue_cooking_smells.
	var/rogue_cooked_smell

/// Ratwood faretype of the ported foods that are not food for the desperate (the porter does not write faretype yet).
GLOBAL_LIST_INIT(rogue_food_fare, list(
	"/obj/item/reagent_containers/food/snacks/balefire" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/balefire/slice" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/chocolate" = ROGUE_FARE_LAVISH,
	"/obj/item/reagent_containers/food/snacks/chocolate/slice" = ROGUE_FARE_LAVISH,
	"/obj/item/reagent_containers/food/snacks/eoran_aril/auric" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/fish/lobster" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/fish/plaice" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/fish/sole" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/fish/sunny" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/grown/apple" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/berries/rogue" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry_sugared" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/grown/fruit/lemon" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/fruit/lime" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/fruit/pear" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/fruit/plum" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/fruit/strawberry" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine_sugared" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/grown/fruit/tomato" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/fruit/tomato_sliced" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/nut_sugared" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/grown/rogue/chocolate_spiced" = ROGUE_FARE_LAVISH,
	"/obj/item/reagent_containers/food/snacks/grown/sugarshape/amark" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/sugarshape/arch" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/sugarshape/archway" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/sugarshape/castle" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/sugarshape/dmark" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/sugarshape/flag" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/sugarshape/hmark" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/sugarshape/house" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/sugarshape/pmark" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/sugarshape/smark" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/sugarshape/statuek" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/sugarshape/statuel" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/sugarshape/statuer" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/sugarshape/statuey" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/sugarshape/tower" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/sugarshape/towers" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/sugarshape/tree" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/grown/sugarshape/zmark" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/biscuit" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/bread" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/breadslice" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/breadslice/toast" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/breadslice/toast/buttered" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/bun" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/bun_grenz" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/bun_raston" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/buttersole" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/carrotsteak" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/cheddar" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/cheddar/aged" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/cheddarslice" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/cheddarslice/aged" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/cheddarwedge" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/cheddarwedge/aged" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/cheese" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/cheesebun" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/cookie" = ROGUE_FARE_LAVISH,
	"/obj/item/reagent_containers/food/snacks/rogue/cookier" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/cookieslice" = ROGUE_FARE_LAVISH,
	"/obj/item/reagent_containers/food/snacks/rogue/cookieslicer" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/crackerscooked" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/friedegg/bacon" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/friedegg/fried" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/friedegg/hammerhold" = ROGUE_FARE_LAVISH,
	"/obj/item/reagent_containers/food/snacks/rogue/friedegg/sausage" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/friedegg/sausagebacon" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/friedegg/tiberian" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/friedegg/two" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/fruit/pumpkin_sliced" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/frybirdbucket" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/frybirdtato" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/fryfish/crab" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster/meal" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/fryfish/plaice" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/fryfish/shrimp" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/fryfish/sole" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/fryfish/sunny" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/handpie/fish" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/handpie/meat" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/honey" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/honey/spider" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/lemoncoppiette" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique/slice" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/crab/fried" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/driedfishfilet" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/fatty/roast" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/butter" = ROGUE_FARE_LAVISH,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/doublestacked" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced" = ROGUE_FARE_LAVISH,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced/ducal" = ROGUE_FARE_LAVISH,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/salami" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/salami/slice" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/fried" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/spider/fried" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll/seared" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlick" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/onionplaice" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/onionsteak" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/pepperfish" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/pepperlobsta" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/peppersteak" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/peppersteak/ducal" = ROGUE_FARE_LAVISH,
	"/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/apple" = ROGUE_FARE_LAVISH,
	"/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat" = ROGUE_FARE_LAVISH,
	"/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/poison" = ROGUE_FARE_LAVISH,
	"/obj/item/reagent_containers/food/snacks/rogue/pieslice" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/preserved/cabbage_fried" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/preserved/potato_baked" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/preserved/potato_fried" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/preserved/pumpkin_mashed" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/prezzel" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/rogue/raisinbread" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/raisinbreadslice" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/raisins" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/raisins/blackberry" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/raisins/lemon" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/raisins/lime" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/raisins/pear" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/raisins/plum" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/raisins/raspberry" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/raisins/strawberry" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/raisins/tangerine" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/sandwich/bacon" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/sandwich/cheese" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/sandwich/egg" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/sandwich/salami" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/sandwich/salo" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/steakcarrotonion" = ROGUE_FARE_LAVISH,
	"/obj/item/reagent_containers/food/snacks/rogue/trailmix" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove" = ROGUE_FARE_POOR,
	"/obj/item/reagent_containers/food/snacks/rogue/wienercabbage" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/wieneronions" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/wienerpotato" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/rogue/wienerpotatonions" = ROGUE_FARE_NEUTRAL,
	"/obj/item/reagent_containers/food/snacks/sugarstatue/amark" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/sugarstatue/arch" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/sugarstatue/archway" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/sugarstatue/castle" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/sugarstatue/dmark" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/sugarstatue/flag" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/sugarstatue/hmark" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/sugarstatue/house" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/sugarstatue/pmark" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/sugarstatue/smark" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/sugarstatue/statuek" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/sugarstatue/statuel" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/sugarstatue/statuer" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/sugarstatue/statuey" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/sugarstatue/tower" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/sugarstatue/towers" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/sugarstatue/tree" = ROGUE_FARE_FINE,
	"/obj/item/reagent_containers/food/snacks/sugarstatue/zmark" = ROGUE_FARE_FINE,
))

/// Ratwood "portable = FALSE" of the ported foods: dishes a noble eats at a table.
GLOBAL_LIST_INIT(rogue_food_not_portable, list(
	"/obj/item/reagent_containers/food/snacks/rogue/buttersole" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/friedegg/bacon" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/friedegg/fried" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/friedegg/hammerhold" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/friedegg/sausage" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/friedegg/sausagebacon" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/friedegg/tiberian" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/friedegg/two" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/frybirdbucket" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/frybirdtato" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster/meal" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/crab/fried" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/butter" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/doublestacked" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced/ducal" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/onionplaice" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/onionsteak" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/pepperfish" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/pepperlobsta" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/peppersteak" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/peppersteak/ducal" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/apple" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/poison" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/pieslice" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/preserved/cabbage_fried" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/preserved/potato_fried" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/preserved/pumpkin_mashed" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/wienercabbage" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/wieneronions" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/wienerpotato" = TRUE,
	"/obj/item/reagent_containers/food/snacks/rogue/wienerpotatonions" = TRUE,
))

/// Ratwood cooked_smell scents of the raw foods (the most specific type wins).
GLOBAL_LIST_INIT(rogue_cooking_smells, init_rogue_cooking_smells())

/proc/init_rogue_cooking_smells()
	var/list/scents = list(
		"/obj/item/reagent_containers/food/snacks/fish" = "cooked fish",
		"/obj/item/reagent_containers/food/snacks/fish/crab" = "fried crab",
		"/obj/item/reagent_containers/food/snacks/fish/lobster" = "fried shellfish",
		"/obj/item/reagent_containers/food/snacks/fish/oyster" = "fried shellfish",
		"/obj/item/reagent_containers/food/snacks/rogue/cookie" = "freshly baked chocolate cookies",
		"/obj/item/reagent_containers/food/snacks/rogue/foodbase/cookie_raw" = "freshly baked chocolate cookies",
		"/obj/item/reagent_containers/food/snacks/rogue/foodbase/halfcookie_raw" = "freshly baked chocolate cookies",
		"/obj/item/reagent_containers/food/snacks/rogue/cookier" = "freshly baked raisined cookies",
		"/obj/item/reagent_containers/food/snacks/rogue/foodbase/cookier_raw" = "freshly baked raisined cookies",
		"/obj/item/reagent_containers/food/snacks/rogue/foodbase/halfcookier_raw" = "freshly baked raisined cookies",
		"/obj/item/reagent_containers/food/snacks/rogue/doughslice" = "fresh baked buns",
		"/obj/item/reagent_containers/food/snacks/rogue/foodbase/hardtack_raw" = "fresh baked crackers",
		"/obj/item/reagent_containers/food/snacks/rogue/butterdough" = "fresh baked loaf of bookbread",
		"/obj/item/reagent_containers/food/snacks/rogue/butterdoughslice" = "fresh baked pastry",
		"/obj/item/reagent_containers/food/snacks/rogue/piedough" = "fresh baked pie crust",
		"/obj/item/reagent_containers/food/snacks/rogue/meat" = "fried meat",
		"/obj/item/reagent_containers/food/snacks/rogue/meat/bacon" = "fried bacon",
		"/obj/item/reagent_containers/food/snacks/rogue/meat/crab" = "fried crab",
		"/obj/item/reagent_containers/food/snacks/rogue/meat/fish" = "cooked fish",
		"/obj/item/reagent_containers/food/snacks/rogue/meat/mince/poultry" = "cooked chicken",
		"/obj/item/reagent_containers/food/snacks/rogue/meat/poultry" = "cooked chicken",
		"/obj/item/reagent_containers/food/snacks/rogue/meat/sausage" = "fried sausage",
		"/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish" = "fried shellfish",
		"/obj/item/reagent_containers/food/snacks/rogue/meat/spider" = "fried spidermeat",
		"/obj/item/reagent_containers/food/snacks/rogue/truffles" = "cooked truffles",
		"/obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced" = "fried cabbage",
		"/obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced" = "fried onion",
		"/obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced" = "baked potatos",
		"/obj/item/reagent_containers/food/snacks/rogue/foodbase/piebottom" = "fresh baked pie crust",
		"/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw" = "fresh baked pastry",
	)
	. = list()
	for(var/path_text in scents)
		var/path = text2path(path_text)
		if(path)
			.[path] = scents[path_text]

/obj/item/reagent_containers/food/proc/rogue_fare()
	if(isnull(rogue_faretype))
		rogue_faretype = GLOB.rogue_food_fare["[type]"] || ROGUE_FARE_IMPOVERISHED
	return rogue_faretype

/obj/item/reagent_containers/food/proc/rogue_is_portable()
	if(isnull(rogue_portable))
		rogue_portable = !GLOB.rogue_food_not_portable["[type]"]
	return rogue_portable

/// The scent this food gives off when cooked, by its own Ratwood cooked_smell or the most specific listed type.
/obj/item/reagent_containers/food/proc/rogue_smell()
	if(rogue_cooked_smell)
		return rogue_cooked_smell
	var/best_path
	for(var/path in GLOB.rogue_cooking_smells)
		if(istype(src, path) && (!best_path || ispath(path, best_path)))
			best_path = path
	return best_path ? GLOB.rogue_cooking_smells[best_path] : null

/// Ratwood heating_act(): what cooked out of raw food smells for a while (temporary_pollution_emission of cooked_smell).
/obj/item/reagent_containers/food/proc/rogue_cooking_smell(obj/item/reagent_containers/food/raw)
	if(istype(src, ROGUE_BURNT_FOOD) || !rogue_survival_enabled() || !CONFIG_GET(flag/rogue_food_smells))
		return
	var/scent = raw.rogue_smell()
	if(scent)
		AddComponent(/datum/component/rogue_food_smell, scent)

/// Examine lines of the palate (Ratwood snacks examine()): how fine the food is and whether a noble needs a table for it.
/obj/item/reagent_containers/food/proc/rogue_palate_examine()
	. = list()
	if(!rogue_survival_enabled())
		return
	switch(rogue_fare())
		if(ROGUE_FARE_IMPOVERISHED)
			. += span_smallnotice("It is food fit for the desperate.")
		if(ROGUE_FARE_POOR)
			. += span_smallnotice("It is food fit for the poor.")
		if(ROGUE_FARE_NEUTRAL)
			. += span_smallnotice("It is decent food.")
		if(ROGUE_FARE_FINE)
			. += span_smallnotice("It is fine food.")
		if(ROGUE_FARE_LAVISH)
			. += span_smallnotice("It is lavish food.")
	. += span_smallnotice(rogue_is_portable() ? "It can be eaten without a table." : "Eating this without a table would be disgraceful for a noble.")

/// Ratwood On_Consume(): what one bite means to the eater - a favourite or hated food, and for a noble, a yeoman or a courtier
/// whether the fare befits them. FALSE when their disdain spoils the good effect of the bite.
/obj/item/reagent_containers/food/proc/rogue_taste_for(mob/living/eater)
	var/mob/living/carbon/human/human_eater = eater
	if(!istype(human_eater) || !rogue_survival_enabled())
		return TRUE
	if(rogue_food_matches(human_eater.rogue_culinary_preference(ROGUE_CULINARY_FAVOURITE_FOOD)))
		human_eater.rogue_preference_mood("rogue_favourite_food", /datum/mood_event/rogue_favourite_food, span_green("Yum! My favorite food!"))
	if(rogue_food_matches(human_eater.rogue_culinary_preference(ROGUE_CULINARY_HATED_FOOD)))
		human_eater.rogue_preference_mood("rogue_hated_food", /datum/mood_event/rogue_hated_food, span_red("Yuck! My hated food!"))
	if(!CONFIG_GET(flag/rogue_noble_palate) || HAS_TRAIT(eater, TRAIT_NASTY_EATER) || HAS_TRAIT(eater, TRAIT_ORGAN_EATER) || HAS_TRAIT(eater, TRAIT_WILD_EATER))
		return TRUE
	// Bad food keeps its bad effect whoever eats it; only the good effects are lost on a disdainful eater.
	var/spoils_effect = !(eat_effect in list(/datum/status_effect/rogue_food/rotten, /datum/status_effect/rogue_food/burned, /datum/status_effect/rogue_food/uncooked))
	var/fare = rogue_fare()
	if(human_eater.rogue_is_noble())
		if(!rogue_is_portable() && !(locate(/obj/structure/table) in range(1, eater)))
			eater.add_mood_event("rogue_noble_table", /datum/mood_event/rogue_noble_ate_without_table)
			if(prob(ROGUE_PICKY_REMARK_CHANCE))
				to_chat(eater, span_red("I should really eat this at a table..."))
		switch(fare)
			if(ROGUE_FARE_IMPOVERISHED)
				eater.add_mood_event("rogue_noble_poor_food", /datum/mood_event/rogue_noble_impoverished_food)
				if(eater.nutrition >= NUTRITION_LEVEL_STARVING)
					eater.adjust_disgust(ROGUE_NOBLE_POOR_FOOD_NAUSEA * ROGUE_NAUSEA_TO_DISGUST)
					return FALSE
				eater.add_mood_event("rogue_noble_desperate", /datum/mood_event/rogue_noble_desperate)
				return !spoils_effect
			if(ROGUE_FARE_POOR, ROGUE_FARE_NEUTRAL)
				eater.add_mood_event("rogue_noble_bland", /datum/mood_event/rogue_noble_bland_food)
				if(prob(ROGUE_PICKY_REMARK_CHANCE))
					to_chat(eater, span_red("This is rather bland. I deserve better food than this..."))
				return !spoils_effect
			if(ROGUE_FARE_FINE)
				eater.clear_mood_event("rogue_noble_bland")
			if(ROGUE_FARE_LAVISH)
				eater.clear_mood_event("rogue_noble_bland")
				eater.add_mood_event("rogue_noble_lavish", /datum/mood_event/rogue_noble_lavish_food)
				if(prob(ROGUE_PICKY_REMARK_CHANCE))
					to_chat(eater, span_green("Ah, food fit for my title."))
		return TRUE
	if(human_eater.rogue_is_yeoman() || human_eater.rogue_is_courtier())
		if(fare != ROGUE_FARE_IMPOVERISHED)
			eater.clear_mood_event("rogue_noble_bland")
			return TRUE
		eater.add_mood_event("rogue_noble_bland", /datum/mood_event/rogue_noble_bland_food)
		if(prob(ROGUE_PICKY_REMARK_CHANCE))
			to_chat(eater, span_red("This is rather bland. I deserve better food than this..."))
		return !spoils_effect
	return TRUE

/// Ratwood favourite and hated food match: the type itself, a subtype of the same name, or its slice.
/obj/item/reagent_containers/food/proc/rogue_food_matches(wanted)
	if(!ispath(wanted, /obj/item/reagent_containers/food))
		return FALSE
	if(type == wanted)
		return TRUE
	var/obj/item/reagent_containers/food/wanted_food = wanted
	if(ispath(type, wanted) && name == initial(wanted_food.name))
		return TRUE
	return type == initial(wanted_food.slice_path)

/// Ratwood favourite and hated drinks (food_reagents.dm consumable on_mob_add()): by the reagent drunk or spooned.
/proc/rogue_drink_preference(mob/living/drinker, datum/reagent/drunk_type)
	var/mob/living/carbon/human/human_drinker = drinker
	if(!istype(human_drinker) || !ispath(drunk_type, /datum/reagent) || !rogue_survival_enabled())
		return
	if(rogue_reagent_matches(drunk_type, human_drinker.rogue_culinary_preference(ROGUE_CULINARY_FAVOURITE_DRINK)))
		human_drinker.rogue_preference_mood("rogue_favourite_drink", /datum/mood_event/rogue_favourite_drink, span_green("Yum! My favorite drink!"))
	if(rogue_reagent_matches(drunk_type, human_drinker.rogue_culinary_preference(ROGUE_CULINARY_HATED_DRINK)))
		human_drinker.rogue_preference_mood("rogue_hated_drink", /datum/mood_event/rogue_hated_drink, span_red("Yuck! My hated drink!"))

/proc/rogue_reagent_matches(datum/reagent/drunk_type, datum/reagent/wanted)
	if(!ispath(wanted, /datum/reagent))
		return FALSE
	return drunk_type == wanted || (ispath(drunk_type, wanted) && initial(drunk_type.name) == initial(wanted.name))

/// Ratwood glass attack(): a noble drinking soup straight from a bowl minds the bad manners.
/proc/rogue_noble_bad_manners(mob/living/drinker)
	var/mob/living/carbon/human/human_drinker = drinker
	if(!istype(human_drinker) || !rogue_survival_enabled() || !CONFIG_GET(flag/rogue_noble_palate) || !human_drinker.rogue_is_noble())
		return
	human_drinker.add_mood_event("rogue_noble_manners", /datum/mood_event/rogue_noble_bad_manners)
	if(prob(ROGUE_PICKY_REMARK_CHANCE))
		to_chat(human_drinker, span_red("I've got better manners than this..."))

// Who minds the fare (Ratwood rolecheck.dm, jobs.dm GLOB.noble_positions, courtier_positions, yeoman_positions).

GLOBAL_LIST_INIT(rogue_noble_positions, list("Grand Duke", "Baron", "Consort", "Suitor", "Prince", "Hand", "Knight Captain", "Marshal", "Councillor", "Steward", "Clerk", "Knight"))
GLOBAL_LIST_INIT(rogue_courtier_positions, list("Court Magician", "Magicians Associate", "Head Physician", "Apothecary", "Jester", "Seneschal", "Servant", "Court Chaplain", "Head Slave", "Palace Chaplain"))
GLOBAL_LIST_INIT(rogue_yeoman_positions, list("Merchant", "Innkeeper", "Archivist", "Scribe", "Town Crier", "Bathmaster", "Guildmaster", "Guildsman", "Slaver", "Tailor"))

/// Ratwood is_noble(): noble blood or a noble office, unless the blood was drained.
/mob/living/carbon/human/proc/rogue_is_noble()
	if(HAS_TRAIT(src, TRAIT_DEFILED_NOBLE))
		return FALSE
	return HAS_TRAIT(src, TRAIT_NOBLE) || (mind?.assigned_role?.title in GLOB.rogue_noble_positions)

/mob/living/carbon/human/proc/rogue_is_courtier()
	return mind?.assigned_role?.title in GLOB.rogue_courtier_positions

/mob/living/carbon/human/proc/rogue_is_yeoman()
	return mind?.assigned_role?.title in GLOB.rogue_yeoman_positions

// Culinary preferences (Ratwood preferences_culinary.dm). The character menu has no picker yet, so everyone has Ratwood's
// defaults - bread is the favourite food, beer the favourite drink, a burned mess the hated food - until something sets
// rogue_culinary (type paths by ROGUE_CULINARY_* key).

/mob/living/carbon/human
	/// Favourite and hated food and drink: ROGUE_CULINARY_* = type path. Missing keys take Ratwood's defaults.
	var/list/rogue_culinary
	/// world.time this nose may notice a cooking smell again (Ratwood SMELL_COOLDOWN).
	var/rogue_next_smell = 0

/mob/living/carbon/human/proc/rogue_culinary_preference(key)
	if(LAZYACCESS(rogue_culinary, key))
		return rogue_culinary[key]
	switch(key)
		if(ROGUE_CULINARY_FAVOURITE_FOOD)
			return /obj/item/reagent_containers/food/snacks/rogue/bread
		if(ROGUE_CULINARY_HATED_FOOD)
			return ROGUE_BURNT_FOOD
		if(ROGUE_CULINARY_FAVOURITE_DRINK)
			return /datum/reagent/consumable/ethanol/beer
	return null

/// Sets a favourite or hated food or drink (for the character menu): the key and a food type or a reagent type.
/mob/living/carbon/human/proc/rogue_set_culinary_preference(key, path)
	LAZYSET(rogue_culinary, key, path)

/// A favourite or hated food or drink mood; the remark only when it is new (Ratwood can_apply()).
/mob/living/carbon/human/proc/rogue_preference_mood(category, datum/mood_event/mood, remark)
	var/fresh = !mob_mood?.has_mood_of_category(category)
	add_mood_event(category, mood)
	if(fresh)
		to_chat(src, remark)

/// Ratwood smell_act(): a cooking smell reaches this nose, plainer the nearer it is; once a minute at most.
/mob/living/carbon/human/proc/rogue_notice_smell(scent, distance)
	if(!client || stat != STABLE || IS_UNCONSCIOUS(src) || HAS_TRAIT(src, TRAIT_ANOSMIA) || world.time < rogue_next_smell)
		return
	rogue_next_smell = world.time + ROGUE_SMELL_COOLDOWN
	if(distance <= ROGUE_SMELL_STRONG_RANGE)
		to_chat(src, span_notice("The unmistakable smell of [scent] bombards your nostrils."))
	else if(distance <= ROGUE_SMELL_NORMAL_RANGE)
		to_chat(src, span_notice("The smell of [scent] fills the air."))
	else
		to_chat(src, span_notice("The subtle smell of [scent] tickles your nose..."))

/// Ratwood temporary_pollution_emission of a cooked food: for five minutes it wafts its scent to the noses around it.
/datum/component/rogue_food_smell
	dupe_mode = COMPONENT_DUPE_HIGHLANDER
	var/scent
	var/fades_at = 0
	var/smell_timer

/datum/component/rogue_food_smell/Initialize(scent)
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE
	src.scent = scent
	fades_at = world.time + ROGUE_SMELL_DURATION
	smell_timer = addtimer(CALLBACK(src, PROC_REF(waft)), ROGUE_SMELL_INTERVAL, TIMER_STOPPABLE | TIMER_LOOP | TIMER_DELETE_ME)
	waft()

/datum/component/rogue_food_smell/Destroy(force)
	deltimer(smell_timer)
	smell_timer = null
	return ..()

/datum/component/rogue_food_smell/proc/waft()
	if(world.time >= fades_at)
		qdel(src)
		return
	var/turf/center = get_turf(parent)
	if(!center)
		return
	for(var/mob/living/carbon/human/sniffer in get_hearers_in_view(ROGUE_SMELL_RANGE, center))
		sniffer.rogue_notice_smell(scent, get_dist(sniffer, center))

// Mood events of the palate (Ratwood stress events).

/datum/mood_event/rogue_favourite_food
	description = "I ate my favourite food!"
	mood_change = 1 * ROGUE_STRESS_TO_MOOD
	timeout = 5 MINUTES

/datum/mood_event/rogue_hated_food
	description = "I had to eat my most hated food!"
	mood_change = -1 * ROGUE_STRESS_TO_MOOD
	timeout = 10 MINUTES

/datum/mood_event/rogue_favourite_drink
	description = "I had my favourite drink!"
	mood_change = 1 * ROGUE_STRESS_TO_MOOD
	timeout = 5 MINUTES

/datum/mood_event/rogue_hated_drink
	description = "I had to consume my most hated drink!"
	mood_change = -1 * ROGUE_STRESS_TO_MOOD
	timeout = 10 MINUTES

/datum/mood_event/rogue_noble_impoverished_food
	description = "This is disgusting. How can anyone eat this?"
	mood_change = -2 * ROGUE_STRESS_TO_MOOD
	timeout = 10 MINUTES

/datum/mood_event/rogue_noble_desperate
	description = "What level of desperation have I fallen to?"
	mood_change = -6 * ROGUE_STRESS_TO_MOOD
	timeout = 60 MINUTES

/datum/mood_event/rogue_noble_bland_food
	description = "This fare is really beneath me. I deserve better than this..."
	mood_change = -1 * ROGUE_STRESS_TO_MOOD
	timeout = 5 MINUTES

/datum/mood_event/rogue_noble_bad_manners
	description = "I should've used a spoon..."
	mood_change = -1 * ROGUE_STRESS_TO_MOOD
	timeout = 5 MINUTES

/datum/mood_event/rogue_noble_ate_without_table
	description = "Eating such a meal without a table? Churlish."
	mood_change = -1 * ROGUE_STRESS_TO_MOOD
	timeout = 2 MINUTES

/datum/mood_event/rogue_noble_lavish_food
	description = "Truly, a feast befitting my station."
	mood_change = 4 * ROGUE_STRESS_TO_MOOD
	timeout = 30 MINUTES
