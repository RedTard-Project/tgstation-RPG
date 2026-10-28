/// Ratwood stew recipe (modular/Neu_Food/code/recipes/stew_recipes.dm, /datum/stew_recipe): any of the inputs dropped into a
/// boiling pot of water on the hearth simmers into thirty units of the output. The recipes are tried in Ratwood's order, the
/// specific before the generic (the fallback meat stew comes last).
/datum/rogue_stew_recipe
	var/datum/reagent/output
	/// Simmering time before the cook's skill.
	var/cooktime = ROGUE_STEW_TIME
	/// Item types that brew into the output: Ratwood's inputs that exist here (text2path), so unported ones fall away.
	var/list/inputs

/datum/rogue_stew_recipe/New(datum/reagent/output, cooktime, list/input_paths)
	src.output = output
	src.cooktime = cooktime
	inputs = list()
	for(var/path_text in input_paths)
		var/path = text2path(path_text)
		if(path)
			inputs += path

/// The first stew recipe this ingredient goes into, or null.
/proc/rogue_stew_recipe_for(obj/item/ingredient)
	for(var/datum/rogue_stew_recipe/recipe as anything in GLOB.rogue_stew_recipes)
		for(var/input in recipe.inputs)
			if(istype(ingredient, input))
				return recipe
	return null

GLOBAL_LIST_INIT(rogue_stew_recipes, init_rogue_stew_recipes())

/// Ratwood GLOB.stew_recipes in its order: output, simmering time, inputs.
/proc/init_rogue_stew_recipes()
	var/list/data = list(
		list(/datum/reagent/consumable/soup/porridge, ROGUE_STEW_TIME / 2, list("/obj/item/reagent_containers/food/snacks/grown/wheat", "/obj/item/reagent_containers/powder/flour", "/obj/item/reagent_containers/food/snacks/rogue/toastcrumbs", "/obj/item/reagent_containers/food/snacks/rogue/foodbase/hardtack_raw", "/obj/item/reagent_containers/food/snacks/rogue/breadslice", "/obj/item/reagent_containers/food/snacks/rogue/bun", "/obj/item/reagent_containers/food/snacks/rogue/breadslice/toast")),
		list(/datum/reagent/consumable/soup/porridge/thick, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/bread", "/obj/item/reagent_containers/food/snacks/rogue/bookbread", "/obj/item/reagent_containers/food/snacks/rogue/bookbread_slice")),
		list(/datum/reagent/allspice, ROGUE_STEW_TIME * 3, list("/obj/item/reagent_containers/food/snacks/allspice")),
		list(/datum/reagent/consumable/soup/porridge/pudding, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/rbread_half", "/obj/item/reagent_containers/food/snacks/rogue/abread_half", "/obj/item/reagent_containers/food/snacks/rogue/applebreadslice", "/obj/item/reagent_containers/food/snacks/rogue/raisinbreadslice", "/obj/item/reagent_containers/food/snacks/rogue/foodbase/pumpkinloaf_raw", "/obj/item/reagent_containers/food/snacks/rogue/pumpkinloafslice", "/obj/item/reagent_containers/food/snacks/rogue/pumpkinball", "/obj/item/reagent_containers/food/snacks/rogue/foodbase/pumpkinball_raw")),
		list(/datum/reagent/consumable/soup/porridge/thickpudding, ROGUE_STEW_TIME * 2, list("/obj/item/reagent_containers/food/snacks/rogue/rbreaduncooked", "/obj/item/reagent_containers/food/snacks/rogue/raisinbread", "/obj/item/reagent_containers/food/snacks/rogue/abreaduncooked", "/obj/item/reagent_containers/food/snacks/rogue/applebread", "/obj/item/reagent_containers/food/snacks/rogue/pumpkinloaf")),
		list(/datum/reagent/consumable/soup/porridge/frostedpudding, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/pearbread_uncooked", "/obj/item/reagent_containers/food/snacks/rogue/plumbread_uncooked", "/obj/item/reagent_containers/food/snacks/rogue/lemonbread_uncooked", "/obj/item/reagent_containers/food/snacks/rogue/tangerinebread_uncooked", "/obj/item/reagent_containers/food/snacks/rogue/blackberrybread_uncooked", "/obj/item/reagent_containers/food/snacks/rogue/raspberrybread_uncooked", "/obj/item/reagent_containers/food/snacks/rogue/jackberrybread_uncooked", "/obj/item/reagent_containers/food/snacks/rogue/pearbookbread_slice", "/obj/item/reagent_containers/food/snacks/rogue/plumbookbread_slice", "/obj/item/reagent_containers/food/snacks/rogue/lemonbookbread_slice", "/obj/item/reagent_containers/food/snacks/rogue/tangerinebookbread_slice", "/obj/item/reagent_containers/food/snacks/rogue/blackberrybookbread_slice", "/obj/item/reagent_containers/food/snacks/rogue/raspberrybookbread_slice", "/obj/item/reagent_containers/food/snacks/rogue/jackberrybookbread_slice")),
		list(/datum/reagent/consumable/soup/porridge/thickfrostedpudding, ROGUE_STEW_TIME * 2, list("/obj/item/reagent_containers/food/snacks/rogue/pearbookbread", "/obj/item/reagent_containers/food/snacks/rogue/plumbookbread", "/obj/item/reagent_containers/food/snacks/rogue/lemonbookbread", "/obj/item/reagent_containers/food/snacks/rogue/tangerinebookbread", "/obj/item/reagent_containers/food/snacks/rogue/blackberrybookbread", "/obj/item/reagent_containers/food/snacks/rogue/raspberrybookbread", "/obj/item/reagent_containers/food/snacks/rogue/jackberrybookbread")),
		list(/datum/reagent/consumable/soup/porridge/fudgepudding, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/chocolatebookbread_slice", "/obj/item/reagent_containers/food/snacks/rogue/chocolatebread_uncooked", "/obj/item/reagent_containers/food/snacks/rogue/foodbase/halfcookie_raw", "/obj/item/reagent_containers/food/snacks/rogue/foodbase/cookie_raw", "/obj/item/reagent_containers/food/snacks/rogue/cookieslice")),
		list(/datum/reagent/consumable/soup/porridge/thickfudgepudding, ROGUE_STEW_TIME * 2, list("/obj/item/reagent_containers/food/snacks/rogue/cookie", "/obj/item/reagent_containers/food/snacks/rogue/chocolatebookbread")),
		list(/datum/reagent/consumable/soup/porridge/oatmeal, ROGUE_STEW_TIME / 2, list("/obj/item/reagent_containers/food/snacks/grown/oat")),
		list(/datum/reagent/consumable/soup/stew/hardtack, ROGUE_STEW_TIME * 2, list("/obj/item/reagent_containers/food/snacks/rogue/crackerscooked")),
		list(/datum/reagent/consumable/soup/stew/thickhardtacksalo, ROGUE_STEW_TIME * 3, list("/obj/item/reagent_containers/food/snacks/balefire")),
		list(/datum/reagent/consumable/soup/stew/hardtacksalo, ROGUE_STEW_TIME * 2, list("/obj/item/reagent_containers/food/snacks/balefire/slice")),
		list(/datum/reagent/consumable/soup/porridge/congee, ROGUE_STEW_TIME / 2, list("/obj/item/reagent_containers/food/snacks/grown/rice")),
		list(/datum/reagent/consumable/soup/porridge/frycongee, ROGUE_STEW_TIME / 2, list("/obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked")),
		list(/datum/reagent/consumable/soup/purebutter, ROGUE_STEW_TIME / 3, list("/obj/item/reagent_containers/food/snacks/squiresdelight")),
		list(/datum/reagent/consumable/soup/veggie/potato, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced")),
		list(/datum/reagent/consumable/soup/veggie/thickpotato, ROGUE_STEW_TIME * 2, list("/obj/item/reagent_containers/food/snacks/grown/potato/rogue")),
		list(/datum/reagent/consumable/soup/veggie/thickfrypotato, ROGUE_STEW_TIME * 2, list("/obj/item/reagent_containers/food/snacks/rogue/preserved/potato_baked", "/obj/item/reagent_containers/food/snacks/rogue/preserved/potato_fried")),
		list(/datum/reagent/consumable/soup/veggie/onion, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced")),
		list(/datum/reagent/consumable/soup/veggie/thickonion, ROGUE_STEW_TIME * 2, list("/obj/item/reagent_containers/food/snacks/grown/onion/rogue")),
		list(/datum/reagent/consumable/soup/veggie/thickfryonion, ROGUE_STEW_TIME * 2, list("/obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried")),
		list(/datum/reagent/consumable/soup/veggie/cabbage, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced")),
		list(/datum/reagent/consumable/soup/veggie/thickcabbage, ROGUE_STEW_TIME * 2, list("/obj/item/reagent_containers/food/snacks/grown/cabbage/rogue")),
		list(/datum/reagent/consumable/soup/veggie/thickcabbage, ROGUE_STEW_TIME * 2, list("/obj/item/reagent_containers/food/snacks/rogue/preserved/cabbage_fried")),
		list(/datum/reagent/consumable/soup/veggie/thickturnip, ROGUE_STEW_TIME * 2, list("/obj/item/reagent_containers/food/snacks/grown/vegetable/turnip")),
		list(/datum/reagent/consumable/soup/veggie/turnip, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/veg/turnip_sliced")),
		list(/datum/reagent/consumable/soup/stew/veggiefryfish, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/garlickbass", "/obj/item/reagent_containers/food/snacks/rogue/onionplaice")),
		list(/datum/reagent/consumable/soup/stew/evilfryfish, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/fryfish/zizo_abberation")),
		list(/datum/reagent/consumable/soup/stew/pepperfryfish, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/pepperfish")),
		list(/datum/reagent/consumable/soup/stew/lavishfryfish, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/buttersole", "/obj/item/reagent_containers/food/snacks/rogue/jelliedeel", "/obj/item/reagent_containers/food/snacks/rogue/berrysalmon", "/obj/item/reagent_containers/food/snacks/rogue/dendorsalmon", "/obj/item/reagent_containers/food/snacks/rogue/alecod")),
		list(/datum/reagent/consumable/soup/stew/fryfish, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/fryfish", "/obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried")),
		list(/datum/reagent/consumable/soup/stew/fish, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish", "/obj/item/reagent_containers/food/snacks/rogue/meat/fish")),
		list(/datum/reagent/consumable/soup/stew/veggiefryrabbit, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried/garlick/cucumber", "/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried/garlick")),
		list(/datum/reagent/consumable/soup/stew/fryrabbit, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried")),
		list(/datum/reagent/consumable/soup/stew/rabbit, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit", "/obj/item/reagent_containers/food/snacks/rogue/meat/mince/rabbit")),
		list(/datum/reagent/consumable/soup/stew/kingvolf, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlick/cucumber")),
		list(/datum/reagent/consumable/soup/stew/veggiefryvolf, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlick")),
		list(/datum/reagent/consumable/soup/stew/fryvolf, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried")),
		list(/datum/reagent/consumable/soup/stew/volf, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf")),
		list(/datum/reagent/consumable/soup/stew/fryyucky, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/meat/spider/fried")),
		list(/datum/reagent/consumable/soup/stew/yucky, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/meat/spider")),
		list(/datum/reagent/consumable/soup/stew/slop, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/badrecipe")),
		list(/datum/reagent/consumable/soup/stew/veggiethickchicken, ROGUE_STEW_TIME * 2, list("/obj/item/reagent_containers/food/snacks/rogue/frybirdtato")),
		list(/datum/reagent/consumable/soup/stew/lavishchicken, ROGUE_STEW_TIME * 2, list("/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced/ducal", "/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/doublestacked", "/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/butter")),
		list(/datum/reagent/consumable/soup/stew/pepperchicken, ROGUE_STEW_TIME * 2, list("/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced")),
		list(/datum/reagent/consumable/soup/stew/bakedthickchicken, ROGUE_STEW_TIME * 2, list("/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked", "/obj/item/reagent_containers/food/snacks/rogue/meat/chickentender")),
		list(/datum/reagent/consumable/soup/stew/bakedchicken, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried")),
		list(/datum/reagent/consumable/soup/stew/chicken, ROGUE_STEW_TIME * 2, list("/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet", "/obj/item/reagent_containers/food/snacks/rogue/meat/mince/poultry")),
		list(/datum/reagent/consumable/soup/stew/frymeat, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried")),
		list(/datum/reagent/consumable/soup/stew/veggiefrymeat, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/onionsteak", "/obj/item/reagent_containers/food/snacks/rogue/carrotsteak", "/obj/item/reagent_containers/food/snacks/rogue/wienercabbage", "/obj/item/reagent_containers/food/snacks/rogue/wienerpotato", "/obj/item/reagent_containers/food/snacks/rogue/wieneronions", "/obj/item/reagent_containers/food/snacks/rogue/wienerpotatonions")),
		list(/datum/reagent/consumable/soup/stew/pepperfrymeat, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/peppersteak")),
		list(/datum/reagent/consumable/soup/stew/thickpork, ROGUE_STEW_TIME * 2, list("/obj/item/reagent_containers/food/snacks/rogue/meat/fatty")),
		list(/datum/reagent/consumable/soup/stew/frypork, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried", "/obj/item/reagent_containers/food/snacks/fat/salo")),
		list(/datum/reagent/consumable/soup/stew/pork, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/meat/bacon", "/obj/item/reagent_containers/food/snacks/fat/salo/slice")),
		list(/datum/reagent/consumable/soup/stew/thickfrypork, ROGUE_STEW_TIME * 2, list("/obj/item/reagent_containers/food/snacks/rogue/meat/fatty/roast", "/obj/item/reagent_containers/food/snacks/rogue/meat/nitzel", "/obj/item/reagent_containers/food/snacks/rogue/meat/nitzel/schnitzel", "/obj/item/reagent_containers/food/snacks/rogue/meat/nitzel/wiener")),
		list(/datum/reagent/consumable/soup/stew/frybisque, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/fried", "/obj/item/reagent_containers/food/snacks/rogue/meat/crab/fried", "/obj/item/reagent_containers/food/snacks/rogue/fryfish/crab", "/obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster", "/obj/item/reagent_containers/food/snacks/rogue/crabcake")),
		list(/datum/reagent/consumable/soup/stew/lavishfrybisque, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster/meal", "/obj/item/reagent_containers/food/snacks/rogue/pepperlobsta", "/obj/item/reagent_containers/food/snacks/rogue/crabcake")),
		list(/datum/reagent/consumable/soup/stew/seafoodbroil, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/fish/oyster", "/obj/item/reagent_containers/food/snacks/fish/clam", "/obj/item/reagent_containers/food/snacks/fish/shrimp")),
		list(/datum/reagent/consumable/soup/stew/fryseafoodbroil, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/fryfish/shrimp", "/obj/item/reagent_containers/food/snacks/rogue/fryfish/clam")),
		list(/datum/reagent/consumable/soup/stew/lavishfryseafoodbroil, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/milkclam")),
		list(/datum/reagent/consumable/soup/stew/bisque, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/meat/crab", "/obj/item/reagent_containers/food/snacks/fish/lobster", "/obj/item/reagent_containers/food/snacks/fish/crab", "/obj/item/reagent_containers/food/snacks/rogue/foodbase/crabcakeraw")),
		list(/datum/reagent/consumable/soup/stew/meatrice, ROGUE_STEW_TIME / 2, list("/obj/item/reagent_containers/food/snacks/rogue/ricebird", "/obj/item/reagent_containers/food/snacks/rogue/ricebeef", "/obj/item/reagent_containers/food/snacks/rogue/ricepork")),
		list(/datum/reagent/consumable/soup/stew/eggrice, ROGUE_STEW_TIME / 2, list("/obj/item/reagent_containers/food/snacks/rogue/riceegg")),
		list(/datum/reagent/consumable/soup/stew/shrimprice, ROGUE_STEW_TIME / 2, list("/obj/item/reagent_containers/food/snacks/rogue/riceshrimp")),
		list(/datum/reagent/consumable/soup/stew/cheeserice, ROGUE_STEW_TIME / 2, list("/obj/item/reagent_containers/food/snacks/rogue/ricecheese")),
		list(/datum/reagent/consumable/soup/stew/lavishfryrice, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/riceeggcheese", "/obj/item/reagent_containers/food/snacks/rogue/ricebirdcar", "/obj/item/reagent_containers/food/snacks/rogue/ricebeefcar", "/obj/item/reagent_containers/food/snacks/rogue/riceporkcuc", "/obj/item/reagent_containers/food/snacks/rogue/riceshrimpcar")),
		list(/datum/reagent/consumable/soup/bone_broth, ROGUE_STEW_TIME * 2, list("/obj/item/natural/bone", "/obj/item/alch/bone")),
		list(/datum/reagent/consumable/soup/stew/viscera_broth, ROGUE_STEW_TIME * 2, list("/obj/item/organ/appendix", "/obj/item/organ/lungs", "/obj/item/organ/liver", "/obj/item/organ/stomach", "/obj/item/organ/ears", "/obj/item/organ/eyes", "/obj/item/alch/viscera", "/obj/item/alch/sinew")),
		list(/datum/reagent/consumable/soup/stew/survival_broth, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique/slice")),
		list(/datum/reagent/consumable/soup/stew/thicksurvival_broth, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique")),
		list(/datum/reagent/consumable/soup/stew/saltmeat_stew, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/meat/salami", "/obj/item/reagent_containers/food/snacks/rogue/meat/salami/slice", "/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette", "/obj/item/reagent_containers/food/snacks/rogue/meat/driedfishfilet")),
		list(/datum/reagent/consumable/soup/stew/meat, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/meat")),
		list(/datum/reagent/consumable/soup/stew/berry_poisoned, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison")),
		list(/datum/reagent/consumable/soup/stew/berry, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/grown/berries/rogue", "/obj/item/reagent_containers/food/snacks/grown/fruit/strawberry", "/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry", "/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry")),
		list(/datum/reagent/consumable/soup/lemon, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/grown/fruit/lemon", "/obj/item/reagent_containers/food/snacks/rogue/lemoncoppiette")),
		list(/datum/reagent/consumable/soup/lime, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/grown/fruit/lime")),
		list(/datum/reagent/consumable/soup/pear, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/grown/fruit/pear")),
		list(/datum/reagent/consumable/soup/apple, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/grown/apple", "/obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced")),
		list(/datum/reagent/consumable/soup/stew/parmesan, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/cheddarwedge/aged", "/obj/item/reagent_containers/food/snacks/rogue/cheddarslice/aged")),
		list(/datum/reagent/consumable/soup/stew/thickparmesan, ROGUE_STEW_TIME * 2, list("/obj/item/reagent_containers/food/snacks/rogue/cheddar/aged")),
		list(/datum/reagent/consumable/soup/stew/cheese, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/cheddarwedge", "/obj/item/reagent_containers/food/snacks/rogue/cheddarslice")),
		list(/datum/reagent/consumable/soup/stew/thickcheese, ROGUE_STEW_TIME * 2, list("/obj/item/reagent_containers/food/snacks/rogue/cheese")),
		list(/datum/reagent/consumable/soup/stew/lavishfryegg, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/friedegg/tiberian", "/obj/item/reagent_containers/food/snacks/rogue/friedegg/hammerhold")),
		list(/datum/reagent/consumable/soup/stew/thickfryegg, ROGUE_STEW_TIME * 2, list("/obj/item/reagent_containers/food/snacks/rogue/friedegg/sausage", "/obj/item/reagent_containers/food/snacks/rogue/friedegg/sausagebacon", "/obj/item/reagent_containers/food/snacks/rogue/friedegg/bacon")),
		list(/datum/reagent/consumable/soup/stew/fryegg, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/friedegg/fried", "/obj/item/reagent_containers/food/snacks/rogue/friedegg/two", "/obj/item/reagent_containers/food/snacks/rogue/stuffedegg/cooked")),
		list(/datum/reagent/consumable/soup/stew/egg, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/egg", "/obj/item/reagent_containers/food/snacks/rogue/stuffedegg")),
		list(/datum/reagent/consumable/soup/stew/garlick_soup, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/grown/garlick/rogue", "/obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove")),
		list(/datum/reagent/consumable/soup/stew/cucumber_soup, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/veg/cucumber_sliced")),
		list(/datum/reagent/consumable/soup/stew/thickcucumber_soup, ROGUE_STEW_TIME * 2, list("/obj/item/reagent_containers/food/snacks/grown/cucumber")),
		list(/datum/reagent/consumable/soup/stew/eggplant_soup, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/grown/eggplant", "/obj/item/reagent_containers/food/snacks/rogue/eggplantcarved")),
		list(/datum/reagent/consumable/soup/stew/aubergine_soup, ROGUE_STEW_TIME * 2, list("/obj/item/reagent_containers/food/snacks/rogue/eggplantmeat", "/obj/item/reagent_containers/food/snacks/rogue/eggplantstuffedraw", "/obj/item/reagent_containers/food/snacks/rogue/preserved/eggplantstuffed")),
		list(/datum/reagent/consumable/soup/stew/lavishaubergine_soup, ROGUE_STEW_TIME * 2, list("/obj/item/reagent_containers/food/snacks/rogue/preserved/eggplantstuffedcheese")),
		list(/datum/reagent/consumable/soup/stew/carrot_stew, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/grown/carrot")),
		list(/datum/reagent/consumable/soup/stew/thickcarrot_stew, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked")),
		list(/datum/reagent/consumable/soup/stew/nutty_stew, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/grown/nut")),
		list(/datum/reagent/consumable/soup/stew/tomato_soup, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/grown/fruit/tomato", "/obj/item/reagent_containers/food/snacks/grown/fruit/tomato_sliced")),
		list(/datum/reagent/consumable/soup/stew/plum_soup, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/grown/fruit/plum")),
		list(/datum/reagent/consumable/soup/tangerine_marmalade, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine")),
		list(/datum/reagent/consumable/soup/stew/squash_soup, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/fruit/pumpkin_sliced")),
		list(/datum/reagent/consumable/soup/stew/frysquash_soup, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/rogue/preserved/pumpkin_mashed")),
		list(/datum/reagent/water/rosewater, ROGUE_STEW_TIME / 4, list("/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_dried")),
		list(/datum/reagent/water/rosewater_spiced, ROGUE_STEW_TIME / 3, list("/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_spiced")),
		list(/datum/reagent/consumable/caffeine/coffee, ROGUE_STEW_TIME / 4, list("/obj/item/reagent_containers/food/snacks/grown/coffeebeansroasted")),
		list(/datum/reagent/consumable/caffeine/coffee_spiced, ROGUE_STEW_TIME / 3, list("/obj/item/reagent_containers/food/snacks/grown/coffeebeans_spiced")),
		list(/datum/reagent/consumable/caffeine/tea, ROGUE_STEW_TIME / 4, list("/obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_ground")),
		list(/datum/reagent/consumable/caffeine/tea_spiced, ROGUE_STEW_TIME / 3, list("/obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_spiced")),
		list(/datum/reagent/consumable/spiced_chocolate, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/grown/rogue/chocolate_spiced")),
		list(/datum/reagent/consumable/chocolate, ROGUE_STEW_TIME / 2, list("/obj/item/reagent_containers/food/snacks/chocolate/slice", "/obj/item/reagent_containers/food/snacks/chocolate")),
		list(/datum/reagent/consumable/poppy_milk, ROGUE_STEW_TIME, list("/obj/item/reagent_containers/food/snacks/grown/rogue/poppy")),
	)
	. = list()
	for(var/list/entry as anything in data)
		var/datum/rogue_stew_recipe/recipe = new(entry[1], entry[2], entry[3])
		if(length(recipe.inputs))
			. += recipe

/obj/item/reagent_containers/food
	/// Tallow this melts into in a dry pot on the hearth (Ratwood fat_yield).
	var/rogue_fat_yield = 0
	/// What this deep fries into in a pot of tallow (Ratwood deep_fried_type).
	var/rogue_deep_fried_type

/// Examine lines of the pot: what this fries into, or that it melts into tallow.
/obj/item/reagent_containers/food/proc/rogue_fryer_examine()
	. = list()
	if(rogue_deep_fried_type)
		var/obj/item/fried = rogue_deep_fried_type
		. += span_smallnotice("It is prepared and ready to be <b>deep fried</b> into [initial(fried.name)] in a pot of tallow.")
	else if(rogue_fat_yield)
		. += span_smallnotice("It can be melted into tallow in a dry pot on a hearth.")

/// Ratwood hearth attackby() with a pot on it (rogue_fires.dm, "Stew + Deep Frying"): fat melts into tallow in a dry pot, food
/// with a deep fried form fries in tallow, a stew ingredient goes into boiling water. NONE when the item is none of these.
/obj/machinery/light/rogue/hearth/proc/pot_interaction(mob/living/user, obj/item/tool)
	var/obj/item/reagent_containers/glass/bucket/pot/pot = attachment
	if(!istype(pot) || (tool.item_flags & ABSTRACT) || HAS_TRAIT(tool, TRAIT_NODROP))
		return NONE
	var/divisor = rogue_cook_divisor(user)
	var/obj/item/reagent_containers/food/food = tool
	if(istype(food))
		if(food.rogue_fat_yield)
			return render_fat(user, pot, food, divisor)
		if(food.rogue_deep_fried_type && pot.reagents.has_reagent(/datum/reagent/consumable/oil/tallow))
			return deep_fry(user, pot, food, divisor)
	var/datum/rogue_stew_recipe/recipe = rogue_stew_recipe_for(tool)
	if(!recipe)
		return NONE
	return add_to_stew(user, pot, tool, recipe, divisor)

/obj/machinery/light/rogue/hearth/proc/render_fat(mob/living/user, obj/item/reagent_containers/glass/bucket/pot/pot, obj/item/reagent_containers/food/fat, divisor)
	if(pot.reagents.has_reagent(/datum/reagent/water))
		to_chat(user, span_warning("I can't render fat in a pot with water!"))
		return ITEM_INTERACT_BLOCKING
	if(!do_after(user, ROGUE_STEW_STEP / divisor, target = src) || QDELETED(fat) || attachment != pot)
		return ITEM_INTERACT_BLOCKING
	user.visible_message(span_info("[user] melts [fat] in the pot."), span_info("I melt [fat] in the pot."))
	pot.reagents.add_reagent(/datum/reagent/consumable/oil/tallow, fat.rogue_fat_yield, reagtemp = pot.reagents.chem_temp)
	qdel(fat)
	update_appearance(UPDATE_OVERLAYS)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/light/rogue/hearth/proc/deep_fry(mob/living/user, obj/item/reagent_containers/glass/bucket/pot/pot, obj/item/reagent_containers/food/food, divisor)
	if(!pot.reagents.has_reagent(/datum/reagent/consumable/oil/tallow, ROGUE_DEEP_FRY_OIL))
		to_chat(user, span_notice("Not enough tallow."))
		return ITEM_INTERACT_BLOCKING
	if(pot.reagents.has_reagent(/datum/reagent/water))
		to_chat(user, span_warning("I can't deep fry in a pot with water!"))
		return ITEM_INTERACT_BLOCKING
	if(!do_after(user, ROGUE_DEEP_FRY_TIME / divisor, target = src) || QDELETED(food) || attachment != pot)
		return ITEM_INTERACT_BLOCKING
	if(!pot.reagents.has_reagent(/datum/reagent/consumable/oil/tallow, ROGUE_DEEP_FRY_OIL))
		return ITEM_INTERACT_BLOCKING
	user.visible_message(span_info("[user] deep fries [food] in the pot."), span_info("I deep fry [food] in the pot."))
	playsound(src, 'modular_redtard/survival/sound/frying.ogg', 60, FALSE)
	var/fried_type = food.rogue_deep_fried_type
	qdel(food)
	new fried_type(drop_location())
	pot.reagents.remove_reagent(/datum/reagent/consumable/oil/tallow, ROGUE_DEEP_FRY_OIL)
	user.rogue_cooking_experience()
	update_appearance(UPDATE_OVERLAYS)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/light/rogue/hearth/proc/add_to_stew(mob/living/user, obj/item/reagent_containers/glass/bucket/pot/pot, obj/item/ingredient, datum/rogue_stew_recipe/recipe, divisor)
	if(!pot.reagents.has_reagent(/datum/reagent/water, ROGUE_STEW_WATER + ROGUE_STEW_WATER_AFTER))
		to_chat(user, span_notice("Not enough water."))
		return ITEM_INTERACT_BLOCKING
	if(pot.reagents.chem_temp < ROGUE_STEW_TEMPERATURE)
		to_chat(user, span_notice("[pot] isn't boiling!"))
		return ITEM_INTERACT_BLOCKING
	if(!do_after(user, ROGUE_STEW_STEP / divisor, target = src) || QDELETED(ingredient) || attachment != pot)
		return ITEM_INTERACT_BLOCKING
	if(!pot.reagents.has_reagent(/datum/reagent/water, ROGUE_STEW_WATER + ROGUE_STEW_WATER_AFTER))
		return ITEM_INTERACT_BLOCKING
	user.visible_message(span_info("[user] places [ingredient] into the pot."), span_info("I place [ingredient] into the pot."))
	user.rogue_cooking_experience()
	qdel(ingredient)
	playsound(src, 'modular_redtard/survival/sound/fish_out.ogg', 20, TRUE)
	pot.reagents.remove_reagent(/datum/reagent/water, ROGUE_STEW_WATER)
	update_appearance(UPDATE_OVERLAYS)
	addtimer(CALLBACK(pot, TYPE_PROC_REF(/obj/item/reagent_containers/glass/bucket/pot, finish_stew), recipe.output), recipe.cooktime / divisor)
	return ITEM_INTERACT_SUCCESS

/// Ratwood's stew is done after the simmering wherever the pot went: the last unit of water goes, thirty units of stew come,
/// as hot as the pot.
/obj/item/reagent_containers/glass/bucket/pot/proc/finish_stew(datum/reagent/output)
	playsound(src, 'sound/effects/bubbles/bubbles.ogg', 30, TRUE)
	reagents.remove_reagent(/datum/reagent/water, ROGUE_STEW_WATER_AFTER)
	reagents.add_reagent(output, ROGUE_STEW_WATER + ROGUE_STEW_WATER_AFTER, reagtemp = reagents.chem_temp)
	if(istype(loc, /obj/machinery/light/rogue/hearth))
		loc.update_appearance(UPDATE_OVERLAYS)

/// Ratwood boilloop: a boiling pot on a burning hearth bubbles.
/obj/machinery/light/rogue/hearth/proc/update_boiling()
	var/obj/item/reagent_containers/glass/bucket/pot/pot = attachment
	if(lit && istype(pot) && pot.reagents.total_volume && pot.reagents.chem_temp > ROGUE_STEW_TEMPERATURE)
		if(!boilloop)
			boilloop = new(src, FALSE)
		boilloop.start()
	else
		boilloop?.stop()
