/datum/crafting_recipe/roguetown/alch/feaudust
	name = "feau dust"
	result = /obj/item/alch/feaudust
	reqs = list(/obj/item/alch/irondust = 2, /obj/item/alch/golddust = 1)
	rogue_results = list(/obj/item/alch/feaudust)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 0
	rogue_structure = /obj/structure/table/wood/rockhill/wood
	rogue_verb = "mixes"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/scribble.ogg'

/datum/crafting_recipe/roguetown/alch/magicdust
	name = "pure essentia"
	result = /obj/item/alch/magicdust
	reqs = list(/obj/item/alch/waterdust = 1, /obj/item/alch/firedust = 1, /obj/item/alch/airdust = 1, /obj/item/alch/earthdust = 1)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 0
	rogue_structure = /obj/structure/table/wood/rockhill/wood
	rogue_verb = "mixes"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/scribble.ogg'

/datum/crafting_recipe/roguetown/alchemy/b2app
	name = "berry to apple"
	result = /obj/item/reagent_containers/food/snacks/grown/apple
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 2)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 3
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "transmute"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/bandage
	name = "bandages (alchemy)"
	result = /obj/item/natural/cloth/bandage
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/alch/bonemeal = 1)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 2
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/bbomb
	name = "bottle bomb"
	result = /obj/item/bomb
	reqs = list(/obj/item/reagent_containers/glass/bottle = 1, /obj/item/ash = 2, /obj/item/rogueore/coal = 1, /obj/item/natural/cloth = 1)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 2
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/c2sto
	name = "clay to stone"
	result = /obj/item/natural/stone
	reqs = list(/obj/item/natural/clay = 2)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 2
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "transmute"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/curerot
	name = "rot cure potion"
	result = /obj/item/reagent_containers/glass/bottle/alchemical/rogue/rotcure
	reqs = list(/obj/item/reagent_containers/glass/bottle/alchemical = 1, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 1, /obj/item/alch/golddust = 1, /obj/item/alch/viscera = 2)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 5
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/d2ros
	name = "diamond to riddle of steel"
	result = /obj/item/riddleofsteel
	reqs = list(/obj/item/roguegem/diamond = 2, /obj/item/rogueore/iron = 1, /obj/item/rogueore/coal = 1)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 6
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "transmute"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/distill
	name = "distill water"
	result = /obj/item/reagent_containers/glass/bottle/rogue/water
	reqs = list(/obj/item/reagent_containers/glass/bottle = 1, /datum/reagent/water/gross = 48)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/f2gra
	name = "fiber to grain"
	result = /obj/item/reagent_containers/food/snacks/grown/wheat
	reqs = list(/obj/item/natural/fibers = 4)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 3
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "transmute"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/frankenbrew
	name = "reanimation elixir"
	result = /obj/item/reagent_containers/glass/bottle/frankenbrew
	reqs = list(/obj/item/reagent_containers/glass/bottle = 2, /obj/item/reagent_containers/food/snacks/grown/manabloom = 1, /obj/item/reagent_containers/lux = 1, /obj/item/alch/calendula = 1, /datum/reagent/water = 98)
	rogue_results = list(/obj/item/reagent_containers/glass/bottle/frankenbrew)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 4
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/frankenbrew_impure
	name = "reanimation elixir (impure lux)"
	result = /obj/item/reagent_containers/glass/bottle/frankenbrew
	reqs = list(/obj/item/reagent_containers/glass/bottle = 2, /obj/item/reagent_containers/food/snacks/grown/manabloom = 1, /obj/item/reagent_containers/lux_impure = 1, /obj/item/alch/calendula = 1, /datum/reagent/water = 98)
	rogue_results = list(/obj/item/reagent_containers/glass/bottle/frankenbrew)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 4
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_tech_node = "LUX_FILTRATION"

/datum/crafting_recipe/roguetown/alchemy/g2saf
	name = "gemerald to saffira"
	result = /obj/item/roguegem/violet
	reqs = list(/obj/item/roguegem/green = 1, /obj/item/rogueore/gold = 2)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 5
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "transmute"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/g2top
	name = "gold to toper"
	result = /obj/item/roguegem/yellow
	reqs = list(/obj/item/rogueore/gold = 2, /obj/item/natural/stone = 1)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 5
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "transmute"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/g2wes
	name = "grain to westleach"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/wheat = 2)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 3
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "transmute"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/glassbottles
	name = "alchemy bottles"
	result = /obj/item/reagent_containers/glass/bottle/alchemical
	reqs = list(/obj/item/natural/stone = 1, /obj/item/natural/dirtclod = 1)
	rogue_results = list(/obj/item/reagent_containers/glass/bottle/alchemical, /obj/item/reagent_containers/glass/bottle/alchemical, /obj/item/reagent_containers/glass/bottle/alchemical, /obj/item/reagent_containers/glass/bottle/alchemical, /obj/item/reagent_containers/glass/bottle/alchemical)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "forge"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/glassbottles2
	name = "glass bottles"
	result = /obj/item/reagent_containers/glass/bottle
	reqs = list(/obj/item/natural/stone = 1, /obj/item/natural/dirtclod = 1)
	rogue_results = list(/obj/item/reagent_containers/glass/bottle, /obj/item/reagent_containers/glass/bottle)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "forge"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/glut
	name = "glut (from gnoll flesh)"
	result = /obj/item/roguegem/blood_diamond
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll = 2)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 4
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/gnoll_flesh
	name = "gnoll flesh (from glut)"
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll
	reqs = list(/obj/item/roguegem/blood_diamond = 2)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 4
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/menthazig
	name = "handmade mentha zig"
	result = /obj/item/clothing/mask/cigarette/rollie/mentha
	reqs = list(/obj/item/clothing/mask/cigarette/rollie/nicotine = 1, /obj/item/alch/mentha = 1)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/moon
	name = "moondust"
	result = /obj/item/reagent_containers/powder/moondust
	reqs = list(/obj/item/ash = 2, /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1, /datum/reagent/berrypoison = 2)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 2
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/moon_3x
	name = "moondust (x3)"
	result = /obj/item/reagent_containers/powder/moondust
	reqs = list(/obj/item/ash = 3, /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 2, /datum/reagent/berrypoison = 3)
	rogue_results = list(/obj/item/reagent_containers/powder/moondust, /obj/item/reagent_containers/powder/moondust)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 3
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/ozium
	name = "ozium"
	result = /obj/item/reagent_containers/powder/ozium
	reqs = list(/obj/item/ash = 2, /datum/reagent/berrypoison = 2, /obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry = 1)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 2
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/ozium_3x
	name = "ozium (x3)"
	result = /obj/item/reagent_containers/powder/ozium
	reqs = list(/obj/item/ash = 3, /datum/reagent/berrypoison = 3, /obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry = 2)
	rogue_results = list(/obj/item/reagent_containers/powder/ozium, /obj/item/reagent_containers/powder/ozium)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 3
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/paralytic_venom
	name = "paralytic venom activation"
	result = /obj/item/reagent_containers/glass/bottle/alchemical/spidervenom_paralytic
	reqs = list(/obj/item/reagent_containers/spidervenom_inert = 2, /obj/item/reagent_containers/powder/moondust = 1, /obj/item/reagent_containers/glass/bottle/alchemical = 1)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 5
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/qsabsolution
	name = "absolving silver"
	result = /obj/item/quicksilver/luxinfused
	reqs = list(/datum/reagent/water/blessed = 45, /obj/item/alch/silverdust = 1)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 0
	rogue_verb_simple = "transmute"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	crafting_flags = CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/roguetown/alchemy/quicksilver
	name = "quicksilver"
	result = /obj/item/quicksilver
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied = 1, /datum/reagent/water/blessed = 45, /obj/item/natural/cloth = 1, /obj/item/alch/silverdust = 1)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 4
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/r2dia
	name = "blortz to diamond"
	result = /obj/item/roguegem/diamond
	reqs = list(/obj/item/roguegem/blue = 2, /obj/item/rogueore/gold = 2)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 5
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "transmute"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/revival_potion
	name = "Revival potion"
	result = /obj/item/reagent_containers/glass/bottle/revival
	reqs = list(/obj/item/reagent_containers/food/snacks/eoran_aril/auric = 1, /obj/item/alch/viscera = 2, /obj/item/reagent_containers/glass/bottle/alchemical = 1, /obj/item/reagent_containers/spidervenom_inert = 1, /obj/item/alch/horn = 1)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 5
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/revival_potion_spider
	name = "Revival potion"
	result = /obj/item/reagent_containers/glass/bottle/revival
	reqs = list(/obj/item/reagent_containers/food/snacks/eoran_aril/auric = 1, /obj/item/alch/viscera = 2, /obj/item/reagent_containers/glass/bottle/alchemical = 1, /obj/item/reagent_containers/spidervenom_inert = 3)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 5
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/s2blo
	name = "saffira to blortz"
	result = /obj/item/roguegem/blue
	reqs = list(/obj/item/roguegem/violet = 1, /obj/item/rogueore/gold = 2)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 5
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "transmute"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/s2coa
	name = "stone to coal"
	result = /obj/item/rogueore/coal
	reqs = list(/obj/item/natural/stone = 4)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 4
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "transmute"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/s2cto
	name = "stone to clay"
	result = /obj/item/natural/clay
	reqs = list(/obj/item/natural/stone = 1)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 2
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "transmute"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/salt
	name = "salt pile"
	result = /obj/item/reagent_containers/powder/salt
	reqs = list(/obj/item/ash = 1, /datum/reagent/water = 10, /obj/item/reagent_containers/food/snacks/fat = 1)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 0
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/salt_2
	name = "salt pile"
	result = /obj/item/reagent_containers/powder/salt
	reqs = list(/obj/item/ash = 1, /datum/reagent/water = 10, /obj/item/reagent_containers/food/snacks/rogue/meat/mince = 1)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 0
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/skysugar
	name = "skysugar slab to skysugar powder (x3)"
	result = /obj/item/reagent_containers/powder/starsugar/skysugar
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/skysugarslab = 1)
	rogue_results = list(/obj/item/reagent_containers/powder/starsugar/skysugar, /obj/item/reagent_containers/powder/starsugar/skysugar)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "transmute"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/skysugarbase
	name = "panacea of skysugar"
	result = /obj/item/reagent_containers/food/snacks/grown/fruit/blackberry/skysugarbase
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/raisins/blackberry = 1, /obj/item/reagent_containers/lux_impure = 1, /obj/item/reagent_containers/powder/starsugar = 1)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 5
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "transmute"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/t2gem
	name = "toper to gemerald"
	result = /obj/item/roguegem/green
	reqs = list(/obj/item/roguegem/yellow = 1, /obj/item/rogueore/gold = 2)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 5
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "transmute"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/transisdust
	name = "sui dust"
	result = /obj/item/alch/transisdust
	reqs = list(/obj/item/herbseed/taraxacum = 1, /obj/item/herbseed/euphrasia = 1, /obj/item/herbseed/hypericum = 1, /obj/item/herbseed/salvia = 1)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 3
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/w2swa
	name = "westleach to swampweed"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/swampweed
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed = 2)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 3
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "transmute"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/w2w
	name = "water to wine"
	result = /obj/item/reagent_containers/glass/bottle/rogue/wine
	reqs = list(/obj/item/reagent_containers/glass/bottle = 1, /datum/reagent/water = 48)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 3
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "transmute"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/abyssalflame
	name = "abyssal flame"
	result = /obj/item/magic/infernal/flame
	reqs = list(/obj/item/magic/infernal/core = 2, /obj/item/roguegem/ruby = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 5
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/amethyst
	name = "amythortz"
	result = /obj/item/roguegem/amethyst
	reqs = list(/obj/item/natural/stone = 1, /datum/reagent/medicine/manapot = 15)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/artifact
	name = "runed artifact"
	result = /obj/item/magic/artifact
	reqs = list(/obj/item/natural/rock = 1, /datum/reagent/medicine/manapot = 15)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/binding
	name = "binding shackles"
	result = /obj/item/rope/chain/bindingshackles
	reqs = list(/obj/item/rope/chain = 2, /obj/item/magic/melded/t1 = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/bindingt2
	name = "binding shackles (T2)"
	result = /obj/item/rope/chain/bindingshackles/t2
	reqs = list(/obj/item/rope/chain/bindingshackles = 1, /obj/item/magic/melded/t2 = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/bindingt3
	name = "binding shackles (T3)"
	result = /obj/item/rope/chain/bindingshackles/t3
	reqs = list(/obj/item/rope/chain/bindingshackles/t2 = 1, /obj/item/magic/melded/t3 = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/bindingt4
	name = "binding shackles (T4)"
	result = /obj/item/rope/chain/bindingshackles/t4
	reqs = list(/obj/item/rope/chain/bindingshackles/t3 = 1, /obj/item/magic/melded/t4 = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/bindingt5
	name = "binding shackles (T5)"
	result = /obj/item/rope/chain/bindingshackles/t5
	reqs = list(/obj/item/rope/chain/bindingshackles/t4 = 1, /obj/item/magic/voidstone = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/blacksteel_upgrade
	name = "upgrade blacksteel staff (gemerald)"
	result = /obj/item/rogueweapon/woodstaff/implement/grand/blacksteel
	reqs = list(/obj/item/rogueweapon/woodstaff/implement/greater/blacksteel = 1, /obj/item/roguegem/green = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/chalk
	name = "chalk"
	result = /obj/item/chalk
	reqs = list(/obj/item/rogueore/cinnabar = 1, /datum/reagent/medicine/manapot = 15)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/elementalfragment
	name = "elemental fragment"
	result = /obj/item/magic/elemental/fragment
	reqs = list(/obj/item/magic/elemental/shard = 3, /obj/item/rogueore/iron = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 4
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/elementalmote
	name = "elemental mote"
	result = /obj/item/magic/elemental/mote
	reqs = list(/obj/item/magic/manacrystal = 1, /obj/item/magic/artifact = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/elementalrelic
	name = "elemental relic"
	result = /obj/item/magic/elemental/relic
	reqs = list(/obj/item/magic/elemental/fragment = 4, /obj/item/roguegem/yellow = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 5
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/elementalshard
	name = "elemental shard"
	result = /obj/item/magic/elemental/shard
	reqs = list(/obj/item/magic/elemental/mote = 2, /obj/item/rogueore/copper = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 3
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/fairydust
	name = "fairy dust - (2 berries, 1 crystalized mana)"
	result = /obj/item/magic/fae/dust
	reqs = list(/obj/item/magic/manacrystal = 1, /obj/item/reagent_containers/food/snacks/grown/berries/rogue = 2)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/forge
	name = "infernal forge"
	result = /obj/machinery/light/rogue/forge/arcane
	reqs = list(/obj/item/magic/infernal/core = 1, /obj/item/natural/stone = 4)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/heartwoodcore
	name = "heartwood core - (2 iridescent scales, 1 small log)"
	result = /obj/item/magic/fae/core
	reqs = list(/obj/item/magic/fae/scale = 2, /obj/item/grown/log/tree/small = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 4
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/hellhoundfang
	name = "hellhound fang"
	result = /obj/item/magic/infernal/fang
	reqs = list(/obj/item/magic/infernal/ash = 2, /obj/item/natural/bone = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 3
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/infernalash
	name = "infernal ash"
	result = /obj/item/magic/infernal/ash
	reqs = list(/obj/item/magic/manacrystal = 1, /obj/item/ash = 2)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/infernalcore
	name = "infernal core"
	result = /obj/item/magic/infernal/core
	reqs = list(/obj/item/magic/infernal/fang = 3, /obj/item/rogueore/coal = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 4
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/infernalfeather
	name = "infernal feather"
	result = /obj/item/natural/feather/infernal
	reqs = list(/obj/item/natural/feather = 1, /obj/item/magic/infernal/ash = 2)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/iridescentscale
	name = "iridescent scales - (2 fairy dust, 1 fish)"
	result = /obj/item/magic/fae/scale
	reqs = list(/obj/item/magic/fae/dust = 2, /obj/item/reagent_containers/food/snacks/fish = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 3
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/meldt1
	name = "arcanic meld"
	result = /obj/item/magic/melded/t1
	reqs = list(/obj/item/magic/infernal/ash = 1, /obj/item/magic/fae/dust = 1, /obj/item/magic/elemental/mote = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/meldt2
	name = "dense arcanic meld"
	result = /obj/item/magic/melded/t2
	reqs = list(/obj/item/magic/infernal/fang = 1, /obj/item/magic/fae/scale = 1, /obj/item/magic/elemental/shard = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/meldt3
	name = "sorcerous weave"
	result = /obj/item/magic/melded/t3
	reqs = list(/obj/item/magic/infernal/core = 1, /obj/item/magic/fae/core = 1, /obj/item/magic/elemental/fragment = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/meldt4
	name = "magical confluence"
	result = /obj/item/magic/melded/t4
	reqs = list(/obj/item/magic/infernal/flame = 1, /obj/item/magic/fae/essence = 1, /obj/item/magic/elemental/relic = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/meldt5
	name = "arcanic abberation"
	result = /obj/item/magic/melded/t5
	reqs = list(/obj/item/magic/melded/t4 = 1, /obj/item/magic/voidstone = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/mimictrinket
	name = "mimic trinket"
	result = /obj/item/mimictrinket
	reqs = list(/obj/item/natural/wood/plank = 2, /obj/item/magic/melded/t1 = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/nomagiccollar
	name = "mana binding collar"
	result = /obj/item/clothing/neck/roguetown/collar/leather/nomagic
	reqs = list(/obj/item/clothing/neck/roguetown/collar = 1, /obj/item/roguegem = 1, /obj/item/magic/melded/t2 = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/nomagicglove
	name = "mana binding gloves"
	result = /obj/item/clothing/gloves/roguetown/nomagic
	reqs = list(/obj/item/clothing/gloves/roguetown/leather = 1, /obj/item/roguegem = 1, /obj/item/magic/melded/t3 = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 3
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/nullring
	name = "ring of null magic"
	result = /obj/item/clothing/ring/active/nomag
	reqs = list(/obj/item/clothing/ring/gold = 1, /obj/item/magic/voidstone = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 4
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/rawmana
	name = "mana crystal"
	result = /obj/item/magic/manacrystal
	reqs = list(/datum/reagent/medicine/manapot = 45)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/ritechalk
	name = "ritual chalk (blessed)"
	result = /obj/item/ritechalk
	reqs = list(/obj/item/rogueore/cinnabar = 1, /datum/reagent/water/blessed = 15)
	category = "Miracles"
	rogue_skill = /datum/attribute/skill/magic/holy
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = 0

/datum/crafting_recipe/roguetown/arcana/ritechalk_unholy
	name = "ritual chalk (unholy)"
	result = /obj/item/ritechalk
	reqs = list(/obj/item/rogueore/cinnabar = 1, /datum/reagent/water/cursed = 15)
	category = "Miracles"
	rogue_skill = /datum/attribute/skill/magic/holy
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = 0

/datum/crafting_recipe/roguetown/arcana/shimmeringlens
	name = "shimmering lens"
	result = /obj/item/clothing/ring/active/shimmeringlens
	reqs = list(/obj/item/magic/fae/scale = 1, /obj/item/magic/leyline = 1, /obj/item/magic/melded/t2 = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 3
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/staff/grand_diamond
	name = "grand staff (dorpel)"
	result = /obj/item/rogueweapon/woodstaff/implement/grand
	reqs = list(/obj/item/rogueweapon/woodstaff = 1, /obj/item/roguegem/diamond = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/staff/grand_riddle
	name = "grand staff (riddle of steel)"
	result = /obj/item/rogueweapon/woodstaff/implement/grand/riddle
	reqs = list(/obj/item/rogueweapon/woodstaff = 1, /obj/item/riddleofsteel = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/staff/greater_emerald
	name = "greater staff (gemerald)"
	result = /obj/item/rogueweapon/woodstaff/implement/greater
	reqs = list(/obj/item/rogueweapon/woodstaff = 1, /obj/item/roguegem/green = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/staff/greater_quartz
	name = "greater staff (blortz)"
	result = /obj/item/rogueweapon/woodstaff/implement/greater/quartz
	reqs = list(/obj/item/rogueweapon/woodstaff = 1, /obj/item/roguegem/blue = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/staff/greater_ruby
	name = "greater staff (rontz)"
	result = /obj/item/rogueweapon/woodstaff/implement/greater/ruby
	reqs = list(/obj/item/rogueweapon/woodstaff = 1, /obj/item/roguegem/ruby = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/staff/greater_sapphire
	name = "greater staff (saffira)"
	result = /obj/item/rogueweapon/woodstaff/implement/greater/sapphire
	reqs = list(/obj/item/rogueweapon/woodstaff = 1, /obj/item/roguegem/violet = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/staff/lesser_amethyst
	name = "lesser staff (amethyst)"
	result = /obj/item/rogueweapon/woodstaff/implement/amethyst
	reqs = list(/obj/item/rogueweapon/woodstaff = 1, /obj/item/roguegem/amethyst = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/staff/lesser_toper
	name = "lesser staff (toper)"
	result = /obj/item/rogueweapon/woodstaff/implement
	reqs = list(/obj/item/rogueweapon/woodstaff = 1, /obj/item/roguegem/yellow = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/sylvanessence
	name = "sylvan essence - (4 heartwood core, 1 gemerald)"
	result = /obj/item/magic/fae/essence
	reqs = list(/obj/item/magic/fae/core = 4, /obj/item/roguegem/green = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 5
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/temporalhourglass
	name = "temporal hourglass"
	result = /obj/item/hourglass/temporal
	reqs = list(/obj/item/natural/wood/plank = 4, /obj/item/magic/leyline = 1, /obj/item/magic/melded/t2 = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 3
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/tome/grand_diamond
	name = "grand tome (dorpel)"
	result = /obj/item/rogueweapon/spellbook/grand
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/roguegem/diamond = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/tome/grand_riddle
	name = "grand tome (riddle of steel)"
	result = /obj/item/rogueweapon/spellbook/grand
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/riddleofsteel = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/tome/greater_emerald
	name = "greater tome (gemerald)"
	result = /obj/item/rogueweapon/spellbook/greater
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/roguegem/green = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/tome/greater_quartz
	name = "greater tome (blortz)"
	result = /obj/item/rogueweapon/spellbook/greater
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/roguegem/blue = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/tome/greater_ruby
	name = "greater tome (rontz)"
	result = /obj/item/rogueweapon/spellbook/greater
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/roguegem/ruby = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/tome/greater_sapphire
	name = "greater tome (saffira)"
	result = /obj/item/rogueweapon/spellbook/greater
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/roguegem/violet = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/tome/lesser_amethyst
	name = "lesser tome (amethyst)"
	result = /obj/item/rogueweapon/spellbook
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/roguegem/amethyst = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/tome/lesser_toper
	name = "lesser tome (toper)"
	result = /obj/item/rogueweapon/spellbook
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/roguegem/yellow = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/voidlamptern
	name = "void lamptern"
	result = /obj/item/flashlight/flare/torch/lantern/voidlamptern
	reqs = list(/obj/item/flashlight/flare/torch/lantern = 1, /obj/item/magic/obsidian = 1, /obj/item/magic/melded/t1 = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/blacksmith/mailledhauberk
	name = "layer a steel cuirass atop hauberk"
	result = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/half = 1, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1)
	blacklist = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient/decrepit, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/atgervi, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/bronze, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/bronze/donator, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/dasfox_ranger, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/donator, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/fluted, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/fluted/robed, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/fluted/robed/grandmaster, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/gold, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/graggar, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/grenzelhoft, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/ancient, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/ancient/decrepit, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/decorated, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/donator_gothic, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/rockhill, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/donator, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/donator_gothic, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/rockhill, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/zycuirass, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/taur, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/janissary, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/matthios, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate/robed, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/taur, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/timesoldier/temperance/eb_armor, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/woodland, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/woodland/plackart, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zizo, /obj/item/clothing/suit/roguetown/armor/plate/half/ancient, /obj/item/clothing/suit/roguetown/armor/plate/half/ancient/decrepit, /obj/item/clothing/suit/roguetown/armor/plate/half/copper, /obj/item/clothing/suit/roguetown/armor/plate/half/fencer, /obj/item/clothing/suit/roguetown/armor/plate/half/fencer/decorated, /obj/item/clothing/suit/roguetown/armor/plate/half/fencer/psydon, /obj/item/clothing/suit/roguetown/armor/plate/half/fluted, /obj/item/clothing/suit/roguetown/armor/plate/half/fluted/decorated, /obj/item/clothing/suit/roguetown/armor/plate/half/fluted/ornate, /obj/item/clothing/suit/roguetown/armor/plate/half/iron, /obj/item/clothing/suit/roguetown/armor/plate/half/iron/goblin)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/breakdowntorch
	name = "uncraft torch"
	result = /obj/item/natural/fibers
	reqs = list(/obj/item/flashlight/flare/torch = 1)
	rogue_results = list(/obj/item/grown/log/tree/stick)
	blacklist = list(/obj/item/flashlight/flare/torch/everburning, /obj/item/flashlight/flare/torch/lantern, /obj/item/flashlight/flare/torch/lantern/bronze, /obj/item/flashlight/flare/torch/lantern/bronzelamptern, /obj/item/flashlight/flare/torch/lantern/copper, /obj/item/flashlight/flare/torch/lantern/prelit, /obj/item/flashlight/flare/torch/lantern/psycenser, /obj/item/flashlight/flare/torch/lantern/pumpkin, /obj/item/flashlight/flare/torch/lantern/pumpkin/frown, /obj/item/flashlight/flare/torch/lantern/pumpkin/grin, /obj/item/flashlight/flare/torch/lantern/pumpkin/psy, /obj/item/flashlight/flare/torch/lantern/pumpkin/surprise, /obj/item/flashlight/flare/torch/lantern/pumpkin/ten, /obj/item/flashlight/flare/torch/lantern/pumpkin/woozy, /obj/item/flashlight/flare/torch/lantern/pumpkin/zizo, /obj/item/flashlight/flare/torch/lantern/scrap, /obj/item/flashlight/flare/torch/lantern/voidlamptern, /obj/item/flashlight/flare/torch/metal, /obj/item/flashlight/flare/torch/on, /obj/item/flashlight/flare/torch/red, /obj/item/flashlight/flare/torch/red/on)
	category = "Other"
	rogue_skill = null
	rogue_difficulty = 0
	rogue_verb = "picks apart"
	rogue_verb_simple = "pick apart"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/allspice
	name = "blend spices into allspice"
	result = /obj/item/reagent_containers/food/snacks/allspice
	reqs = list(/obj/item/reagent_containers/food/snacks/pepper = 1, /obj/item/reagent_containers/powder/salt = 1, /obj/item/reagent_containers/food/snacks/pumpkinspice = 1, /obj/item/reagent_containers/powder/rocknut = 1, /obj/item/reagent_containers/food/snacks/sugar = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 4
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "blends"
	rogue_verb_simple = "blend"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/appledry
	name = "cheroot - apple"
	result = /obj/item/clothing/mask/cigarette/rollie/apple/cheroot
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1, /obj/item/reagent_containers/food/snacks/grown/apple = 1)
	blacklist = list(/obj/item/reagent_containers/food/snacks/grown/apple/gold)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/blackberrydry
	name = "cheroot - blackberry"
	result = /obj/item/clothing/mask/cigarette/rollie/blackberry/cheroot
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1, /obj/item/reagent_containers/food/snacks/grown/fruit/blackberry = 1)
	blacklist = list(/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry/skysugarbase)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/brothbrique
	name = "brothbrique"
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/reagent_containers/food/snacks/rogue/raisins = 1, /obj/item/reagent_containers/food/snacks/rogue/meat/salami = 1)
	blacklist = list(/obj/item/reagent_containers/food/snacks/rogue/meat/salami/slice, /obj/item/reagent_containers/food/snacks/rogue/raisins/blackberry, /obj/item/reagent_containers/food/snacks/rogue/raisins/lemon, /obj/item/reagent_containers/food/snacks/rogue/raisins/lime, /obj/item/reagent_containers/food/snacks/rogue/raisins/pear, /obj/item/reagent_containers/food/snacks/rogue/raisins/plum, /obj/item/reagent_containers/food/snacks/rogue/raisins/raspberry, /obj/item/reagent_containers/food/snacks/rogue/raisins/strawberry, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/blackberry, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/lemon, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/lime, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/pear, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/plum, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/raspberry, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/strawberry, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/tangerine, /obj/item/reagent_containers/food/snacks/rogue/raisins/tangerine, /obj/item/reagent_containers/food/snacks/tallow/black, /obj/item/reagent_containers/food/snacks/tallow/red, /obj/item/reagent_containers/food/snacks/tallow/soft)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/brothbriquealt
	name = "brothbrique, alternate"
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/reagent_containers/food/snacks/rogue/raisins = 1, /obj/item/reagent_containers/food/snacks/rogue/meat/coppiette = 1)
	blacklist = list(/obj/item/reagent_containers/food/snacks/rogue/raisins/blackberry, /obj/item/reagent_containers/food/snacks/rogue/raisins/lemon, /obj/item/reagent_containers/food/snacks/rogue/raisins/lime, /obj/item/reagent_containers/food/snacks/rogue/raisins/pear, /obj/item/reagent_containers/food/snacks/rogue/raisins/plum, /obj/item/reagent_containers/food/snacks/rogue/raisins/raspberry, /obj/item/reagent_containers/food/snacks/rogue/raisins/strawberry, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/blackberry, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/lemon, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/lime, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/pear, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/plum, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/raspberry, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/strawberry, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/tangerine, /obj/item/reagent_containers/food/snacks/rogue/raisins/tangerine, /obj/item/reagent_containers/food/snacks/tallow/black, /obj/item/reagent_containers/food/snacks/tallow/red, /obj/item/reagent_containers/food/snacks/tallow/soft)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/calenduladry
	name = "cheroot - calendula"
	result = /obj/item/clothing/mask/cigarette/rollie/calendula/cheroot
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1, /obj/item/alch/calendula = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/carrotdry
	name = "cheroot - carrot"
	result = /obj/item/clothing/mask/cigarette/rollie/carrot/cheroot
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1, /obj/item/reagent_containers/food/snacks/grown/carrot = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/chocolatedry
	name = "cheroot - chocolate"
	result = /obj/item/clothing/mask/cigarette/rollie/chocolate/cheroot
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1, /obj/item/reagent_containers/food/snacks/chocolate = 1)
	blacklist = list(/obj/item/reagent_containers/food/snacks/chocolate/slice)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/coppiette
	name = "coppiette"
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/coppiette
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1, /obj/item/reagent_containers/powder/salt = 1)
	blacklist = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak/bear, /obj/item/reagent_containers/food/snacks/rogue/meat/steak/bear/fried, /obj/item/reagent_containers/food/snacks/rogue/meat/steak/beetle, /obj/item/reagent_containers/food/snacks/rogue/meat/steak/beetle/cooked, /obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried, /obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll, /obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll/seared, /obj/item/reagent_containers/food/snacks/rogue/meat/steak/rat, /obj/item/reagent_containers/food/snacks/rogue/meat/steak/rat/fried, /obj/item/reagent_containers/food/snacks/rogue/meat/steak/smoked, /obj/item/reagent_containers/food/snacks/rogue/meat/steak/smoked_z, /obj/item/reagent_containers/food/snacks/rogue/meat/steak/troll, /obj/item/reagent_containers/food/snacks/rogue/meat/steak/troll/fried, /obj/item/reagent_containers/food/snacks/rogue/meat/steak/vilespawn, /obj/item/reagent_containers/food/snacks/rogue/meat/steak/vilespawn/admin, /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf, /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried, /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlick, /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlick/cucumber, /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlickcucumber)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/dryleaf
	name = "dry swampweed"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/swampweed = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_structure = /obj/machinery/tanningrack
	rogue_verb = "dries"
	rogue_verb_simple = "dry"

/datum/crafting_recipe/roguetown/cooking/dryrosa
	name = "dry rosa petals"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_dried
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals = 1)
	blacklist = list(/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals/azure)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_structure = /obj/machinery/tanningrack
	rogue_verb = "dries"
	rogue_verb_simple = "dry"

/datum/crafting_recipe/roguetown/cooking/drytea
	name = "dry tea leaves"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_dry
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/tea = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_structure = /obj/machinery/tanningrack
	rogue_verb = "dries"
	rogue_verb_simple = "dry"

/datum/crafting_recipe/roguetown/cooking/dryweed
	name = "dry westleach leaf"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_structure = /obj/machinery/tanningrack
	rogue_verb = "dries"
	rogue_verb_simple = "dry"

/datum/crafting_recipe/roguetown/cooking/fish
	name = "dried fish filet"
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/driedfishfilet
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/fish = 1, /obj/item/reagent_containers/powder/salt = 1)
	blacklist = list(/obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried, /obj/item/reagent_containers/food/snacks/rogue/meat/fish/salmon, /obj/item/reagent_containers/food/snacks/rogue/meat/fish/salmon/fried, /obj/item/reagent_containers/food/snacks/rogue/meat/fish/salmon/smoked)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/frybirdbucket
	name = "frybird bucket"
	result = /obj/item/reagent_containers/food/snacks/rogue/frybirdbucket
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried = 3, /obj/item/reagent_containers/glass/bucket = 1, /obj/item/reagent_containers/powder/salt = 1)
	blacklist = list(/obj/item/reagent_containers/glass/bucket/pot, /obj/item/reagent_containers/glass/bucket/pot/aalloy, /obj/item/reagent_containers/glass/bucket/pot/bronze, /obj/item/reagent_containers/glass/bucket/pot/carved, /obj/item/reagent_containers/glass/bucket/pot/carved/teapotamber, /obj/item/reagent_containers/glass/bucket/pot/carved/teapotcoral, /obj/item/reagent_containers/glass/bucket/pot/carved/teapotjade, /obj/item/reagent_containers/glass/bucket/pot/carved/teapotonyxa, /obj/item/reagent_containers/glass/bucket/pot/carved/teapotopal, /obj/item/reagent_containers/glass/bucket/pot/carved/teapotrose, /obj/item/reagent_containers/glass/bucket/pot/carved/teapotshell, /obj/item/reagent_containers/glass/bucket/pot/carved/teapotturq, /obj/item/reagent_containers/glass/bucket/pot/copper, /obj/item/reagent_containers/glass/bucket/pot/decrepit, /obj/item/reagent_containers/glass/bucket/pot/kettle, /obj/item/reagent_containers/glass/bucket/pot/kettle/tankard, /obj/item/reagent_containers/glass/bucket/pot/kettle/tankard/blacksteel, /obj/item/reagent_containers/glass/bucket/pot/kettle/tankard/silver, /obj/item/reagent_containers/glass/bucket/pot/porcelain, /obj/item/reagent_containers/glass/bucket/pot/stone, /obj/item/reagent_containers/glass/bucket/pot/teapot, /obj/item/reagent_containers/glass/bucket/pot/teapot/fancy, /obj/item/reagent_containers/glass/bucket/pot/teapot/porcelain, /obj/item/reagent_containers/glass/bucket/pot/teapot/porcelain/decorative, /obj/item/reagent_containers/glass/bucket/pot/teapot/porcelain/fancy, /obj/item/reagent_containers/glass/bucket/tinypot)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/jacksberriesdry
	name = "cheroot - jacksberries"
	result = /obj/item/clothing/mask/cigarette/rollie/jacksberries/cheroot
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1, /obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1)
	blacklist = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/jacksberriespoisondry
	name = "cheroot - jacksberries poison"
	result = /obj/item/clothing/mask/cigarette/rollie/jacksberriespoison/cheroot
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1, /obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/lemonystickets
	name = "lemony stickets"
	result = /obj/item/reagent_containers/food/snacks/rogue/lemoncoppiette
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/lemon = 1, /obj/item/reagent_containers/food/snacks/sugar = 1, /obj/item/ash = 1)
	blacklist = list(/obj/item/ash/snappop_phoenix)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/limedry
	name = "cheroot - lime"
	result = /obj/item/clothing/mask/cigarette/rollie/lime/cheroot
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1, /obj/item/reagent_containers/food/snacks/grown/fruit/lime = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/menthaappledry
	name = "cheroot - mentha-apple"
	result = /obj/item/clothing/mask/cigarette/rollie/menthaapple/cheroot
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1, /obj/item/alch/mentha = 1, /obj/item/reagent_containers/food/snacks/grown/apple = 1)
	blacklist = list(/obj/item/reagent_containers/food/snacks/grown/apple/gold)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/menthadry
	name = "cheroot - mentha"
	result = /obj/item/clothing/mask/cigarette/rollie/mentha/cheroot
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1, /obj/item/alch/mentha = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/mobilestove_soft_tallow
	name = "render soft tallow over the mobile stove (1 tallow, 1 fat)"
	result = /obj/item/reagent_containers/food/snacks/tallow/soft
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/reagent_containers/food/snacks/fat = 1)
	tool_paths = list(/obj/item/cooking/pan)
	blacklist = list(/obj/item/reagent_containers/food/snacks/fat/salo, /obj/item/reagent_containers/food/snacks/fat/salo/slice, /obj/item/reagent_containers/food/snacks/tallow/black, /obj/item/reagent_containers/food/snacks/tallow/red, /obj/item/reagent_containers/food/snacks/tallow/soft)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/light/rogue/hearth/mobilestove
	rogue_verb = "renders"
	rogue_verb_simple = "render"
	rogue_sound = 'modular_redtard/rockhill/sound/misc/frying.ogg'

/datum/crafting_recipe/roguetown/cooking/mobilestove_tallow
	name = "render tallow over the mobile stove (x3) (1 fat)"
	result = /obj/item/reagent_containers/food/snacks/tallow
	reqs = list(/obj/item/reagent_containers/food/snacks/fat = 1)
	rogue_results = list(/obj/item/reagent_containers/food/snacks/tallow, /obj/item/reagent_containers/food/snacks/tallow)
	tool_paths = list(/obj/item/cooking/pan)
	blacklist = list(/obj/item/reagent_containers/food/snacks/fat/salo, /obj/item/reagent_containers/food/snacks/fat/salo/slice)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 0
	rogue_structure = /obj/machinery/light/rogue/hearth/mobilestove
	rogue_verb = "renders"
	rogue_verb_simple = "render"
	rogue_sound = 'modular_redtard/rockhill/sound/misc/frying.ogg'

/datum/crafting_recipe/roguetown/cooking/raisins
	name = "raisins"
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1)
	parts = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/raisinsblackberry
	name = "raisins, blackberries"
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/blackberry
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry = 1)
	blacklist = list(/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry/skysugarbase)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/raisinslemon
	name = "raisins, lemon"
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/lemon
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/lemon = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/raisinslime
	name = "raisins, lime"
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/lime
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/lime = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/raisinspear
	name = "raisins, pear"
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/pear
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/pear = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/raisinsplum
	name = "raisins, plum"
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/plum
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/plum = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/raisinsraspberry
	name = "raisins, raspberries"
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/raspberry
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/raisinsstrawberry
	name = "raisins, strawberry"
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/strawberry
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/strawberry = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/raisinstangerine
	name = "raisins, tangerine"
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/tangerine
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/rocknutdry
	name = "zig - rocknut"
	result = /obj/item/clothing/mask/cigarette/rollie/nicotine
	reqs = list(/obj/item/reagent_containers/powder/rocknut = 1, /obj/item/paper/parchment = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_verb = "rolls"
	rogue_verb_simple = "roll"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/salami
	name = "salumoi"
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/salami
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/sausage = 1, /obj/item/reagent_containers/powder/salt = 1)
	blacklist = list(/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/salo
	name = "salo"
	result = /obj/item/reagent_containers/food/snacks/fat/salo
	reqs = list(/obj/item/reagent_containers/food/snacks/fat = 1, /obj/item/reagent_containers/powder/salt = 1)
	blacklist = list(/obj/item/reagent_containers/food/snacks/fat/salo, /obj/item/reagent_containers/food/snacks/fat/salo/slice)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/salotack
	name = "salotack"
	result = /obj/item/reagent_containers/food/snacks/balefire
	reqs = list(/obj/item/reagent_containers/food/snacks/fat/salo = 1, /obj/item/reagent_containers/food/snacks/pepper = 1, /obj/item/reagent_containers/food/snacks/rogue/crackerscooked = 1)
	blacklist = list(/obj/item/reagent_containers/food/snacks/fat/salo/slice)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/salviadry
	name = "cheroot - salvia"
	result = /obj/item/clothing/mask/cigarette/rollie/salvia/cheroot
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1, /obj/item/alch/salvia = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/salviavalerianadry
	name = "cheroot - salvia-valeriana"
	result = /obj/item/clothing/mask/cigarette/rollie/salviavaleriana/cheroot
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1, /obj/item/alch/salvia = 1, /obj/item/alch/valeriana = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/sigdry
	name = "zig - westleach"
	result = /obj/item/clothing/mask/cigarette/rollie/nicotine
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1, /obj/item/paper/parchment = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_verb = "rolls"
	rogue_verb_simple = "roll"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/sigdry/cheroot
	name = "cheroot - westleach"
	result = /obj/item/clothing/mask/cigarette/rollie/nicotine/cheroot
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1, /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "rolls"
	rogue_verb_simple = "roll"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/cooking/sigsweet
	name = "zig - swampweed"
	result = /obj/item/clothing/mask/cigarette/rollie/cannabis
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry = 1, /obj/item/paper/parchment = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_verb = "rolls"
	rogue_verb_simple = "roll"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/sigsweet/cheroot
	name = "cheroot - swampweed"
	result = /obj/item/clothing/mask/cigarette/rollie/cannabis/cheroot
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1, /obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "rolls"
	rogue_verb_simple = "roll"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/cooking/spicechocolate
	name = "chocolate with pumpkin spice"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/chocolate_spiced
	reqs = list(/obj/item/reagent_containers/food/snacks/chocolate/slice = 1, /obj/item/reagent_containers/food/snacks/pumpkinspice = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/spicecoffee
	name = "roasted coffee beans with pumpkin spice"
	result = /obj/item/reagent_containers/food/snacks/grown/coffeebeans_spiced
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/coffeebeansroasted = 1, /obj/item/reagent_containers/food/snacks/pumpkinspice = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/spicerosa
	name = "dried rosa petals with pumpkin spice"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_spiced
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_dried = 1, /obj/item/reagent_containers/food/snacks/pumpkinspice = 1)
	blacklist = list(/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_dried/azure)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 2
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/spicetea
	name = "ground tea leaves with pumpkin spice"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_spiced
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_ground = 1, /obj/item/reagent_containers/food/snacks/pumpkinspice = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 2
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/strawberrydry
	name = "cheroot - strawberry"
	result = /obj/item/clothing/mask/cigarette/rollie/strawberry/cheroot
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1, /obj/item/reagent_containers/food/snacks/grown/fruit/strawberry = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/sugarblackberry
	name = "smothered blackberries"
	result = /obj/item/reagent_containers/food/snacks/grown/fruit/blackberry_sugared
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry = 1, /obj/item/reagent_containers/food/snacks/sugar = 1)
	blacklist = list(/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry/skysugarbase)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/sugarrocknut
	name = "smothered rocknuts"
	result = /obj/item/reagent_containers/food/snacks/grown/nut_sugared
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/nut = 1, /obj/item/reagent_containers/food/snacks/sugar = 1, /obj/item/alch/calendula = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 4
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/sugarrocknutalt
	name = "smothered rocknuts, alternate"
	result = /obj/item/reagent_containers/food/snacks/grown/nut_sugared
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/nut = 1, /obj/item/reagent_containers/food/snacks/sugar = 1, /obj/item/alch/calendula = 1)
	category = "Medicine"
	rogue_skill = /datum/attribute/skill/misc/medicine
	rogue_difficulty = 5
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/sugarshapedarch
	name = "sugarshape, bridge"
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/arch
	reqs = list(/obj/item/reagent_containers/food/snacks/sugar = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 4
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "sculpts"
	rogue_verb_simple = "sculpt"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/sugarshapedarchway
	name = "sugarshape, archway"
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/archway
	reqs = list(/obj/item/reagent_containers/food/snacks/sugar = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 4
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "sculpts"
	rogue_verb_simple = "sculpt"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/sugarshapedcastle
	name = "sugarshape, castle"
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/castle
	reqs = list(/obj/item/reagent_containers/food/snacks/sugar = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 4
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "sculpts"
	rogue_verb_simple = "sculpt"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/sugarshapedflag
	name = "sugarshape, flag"
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/flag
	reqs = list(/obj/item/reagent_containers/food/snacks/sugar = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 4
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "sculpts"
	rogue_verb_simple = "sculpt"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/sugarshapedhouse
	name = "sugarshape, house"
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/house
	reqs = list(/obj/item/reagent_containers/food/snacks/sugar = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 4
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "sculpts"
	rogue_verb_simple = "sculpt"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/sugarshapedmarka
	name = "sugarshape, holy mark"
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/amark
	reqs = list(/obj/item/reagent_containers/food/snacks/sugar = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 4
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "sculpts"
	rogue_verb_simple = "sculpt"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/sugarshapedmarkd
	name = "sugarshape, ducal mark"
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/dmark
	reqs = list(/obj/item/reagent_containers/food/snacks/sugar = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 4
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "sculpts"
	rogue_verb_simple = "sculpt"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/sugarshapedmarkh
	name = "sugarshape, heart mark"
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/hmark
	reqs = list(/obj/item/reagent_containers/food/snacks/sugar = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 4
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "sculpts"
	rogue_verb_simple = "sculpt"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/sugarshapedmarkp
	name = "sugarshape, psydonic mark"
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/pmark
	reqs = list(/obj/item/reagent_containers/food/snacks/sugar = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 4
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "sculpts"
	rogue_verb_simple = "sculpt"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/sugarshapedmarks
	name = "sugarshape, skull mark"
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/smark
	reqs = list(/obj/item/reagent_containers/food/snacks/sugar = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 4
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "sculpts"
	rogue_verb_simple = "sculpt"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/sugarshapedmarkz
	name = "sugarshape, zizonic mark"
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/zmark
	reqs = list(/obj/item/reagent_containers/food/snacks/sugar = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 4
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "sculpts"
	rogue_verb_simple = "sculpt"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/sugarshapedstatuek
	name = "sugarshape, knightly statue"
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/statuek
	reqs = list(/obj/item/reagent_containers/food/snacks/sugar = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 4
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "sculpts"
	rogue_verb_simple = "sculpt"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/sugarshapedstatuel
	name = "sugarshape, lordly statue"
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/statuel
	reqs = list(/obj/item/reagent_containers/food/snacks/sugar = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 4
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "sculpts"
	rogue_verb_simple = "sculpt"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/sugarshapedstatuer
	name = "sugarshape, ducal statue"
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/statuer
	reqs = list(/obj/item/reagent_containers/food/snacks/sugar = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 4
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "sculpts"
	rogue_verb_simple = "sculpt"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/sugarshapedstatuey
	name = "sugarshape, yeomannic statue"
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/statuey
	reqs = list(/obj/item/reagent_containers/food/snacks/sugar = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 4
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "sculpts"
	rogue_verb_simple = "sculpt"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/sugarshapedtower
	name = "sugarshape, tower"
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/tower
	reqs = list(/obj/item/reagent_containers/food/snacks/sugar = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 4
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "sculpts"
	rogue_verb_simple = "sculpt"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/sugarshapedtowers
	name = "sugarshape, small tower"
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/towers
	reqs = list(/obj/item/reagent_containers/food/snacks/sugar = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 4
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "sculpts"
	rogue_verb_simple = "sculpt"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/sugarshapedtree
	name = "sugarshape, tree"
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/tree
	reqs = list(/obj/item/reagent_containers/food/snacks/sugar = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 4
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "sculpts"
	rogue_verb_simple = "sculpt"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/sugartangerine
	name = "smothered tangerines"
	result = /obj/item/reagent_containers/food/snacks/grown/fruit/tangerine_sugared
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine = 1, /obj/item/reagent_containers/food/snacks/sugar = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/trailmix
	name = "trail-mix"
	result = /obj/item/reagent_containers/food/snacks/rogue/trailmix
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/raisins = 1, /obj/item/reagent_containers/food/snacks/rogue/fruit/pumpkin_sliced = 1, /obj/item/reagent_containers/food/snacks/roastseeds = 1, /obj/item/ration = 1)
	blacklist = list(/obj/item/reagent_containers/food/snacks/roastseeds/pumpkin, /obj/item/reagent_containers/food/snacks/roastseeds/sunflower, /obj/item/reagent_containers/food/snacks/rogue/raisins/blackberry, /obj/item/reagent_containers/food/snacks/rogue/raisins/lemon, /obj/item/reagent_containers/food/snacks/rogue/raisins/lime, /obj/item/reagent_containers/food/snacks/rogue/raisins/pear, /obj/item/reagent_containers/food/snacks/rogue/raisins/plum, /obj/item/reagent_containers/food/snacks/rogue/raisins/raspberry, /obj/item/reagent_containers/food/snacks/rogue/raisins/strawberry, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/blackberry, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/lemon, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/lime, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/pear, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/plum, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/raspberry, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/strawberry, /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/tangerine, /obj/item/reagent_containers/food/snacks/rogue/raisins/tangerine)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/cooking/zigardry
	name = "cheroot - zigar"
	result = /obj/item/clothing/mask/cigarette/rollie/zigar/cheroot
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 2, /obj/item/alch/hypericum = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/druidic/blessedseedpowder
	name = "blessed seed powder"
	result = /obj/item/alch/blessedseedpowder
	reqs = list(/obj/item/seeds/treesap = 1, /datum/reagent/water/blessed = 10)
	tool_paths = list(/obj/item/pestle/rogue)
	category = "Druidic Trickery"
	rogue_skill = /datum/attribute/skill/magic/druidic
	rogue_verb = "prepares"
	rogue_verb_simple = "prepare"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/mortarpestle.ogg'
	rogue_xp = 5

/datum/crafting_recipe/roguetown/engineering/autogrinder
	name = "autogrinder"
	result = /obj/structure/autogrinder
	reqs = list(/obj/item/roguegear/bronze = 3, /obj/item/ingot/iron = 2, /obj/item/natural/wood/plank = 4, /obj/item/natural/stone = 4)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/bars
	name = "metal bars"
	result = /obj/structure/bars
	reqs = list(/obj/item/ingot/iron = 1)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_ignore_density = TRUE
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/bars/cemetery
	name = "cemetery bars"
	result = /obj/structure/bars/cemetery
	reqs = list(/obj/item/ingot/iron = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = TRUE
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/engineering/bronzeboltstwenty
	name = "Bronze Crossbow Bolts 20x"
	result = /obj/item/ammo_casing/caseless/rogue/bolt/bronze
	reqs = list(/obj/item/natural/wood/plank = 3, /obj/item/ingot/bronze = 1)
	rogue_results = list(/obj/item/ammo_casing/caseless/rogue/bolt/bronze, /obj/item/ammo_casing/caseless/rogue/bolt/bronze, /obj/item/ammo_casing/caseless/rogue/bolt/bronze, /obj/item/ammo_casing/caseless/rogue/bolt/bronze, /obj/item/ammo_casing/caseless/rogue/bolt/bronze, /obj/item/ammo_casing/caseless/rogue/bolt/bronze, /obj/item/ammo_casing/caseless/rogue/bolt/bronze, /obj/item/ammo_casing/caseless/rogue/bolt/bronze, /obj/item/ammo_casing/caseless/rogue/bolt/bronze, /obj/item/ammo_casing/caseless/rogue/bolt/bronze, /obj/item/ammo_casing/caseless/rogue/bolt/bronze, /obj/item/ammo_casing/caseless/rogue/bolt/bronze, /obj/item/ammo_casing/caseless/rogue/bolt/bronze, /obj/item/ammo_casing/caseless/rogue/bolt/bronze, /obj/item/ammo_casing/caseless/rogue/bolt/bronze, /obj/item/ammo_casing/caseless/rogue/bolt/bronze, /obj/item/ammo_casing/caseless/rogue/bolt/bronze, /obj/item/ammo_casing/caseless/rogue/bolt/bronze, /obj/item/ammo_casing/caseless/rogue/bolt/bronze)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/canistershotimpact
	name = "canister shot, bombard charge"
	result = /obj/item/cannonball/canister
	reqs = list(/obj/item/ammo_casing/caseless/bullet/grapeshot = 3, /obj/item/alch/coaldust = 2, /obj/item/paper/parchment = 4)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/cog
	name = "wooden cogwheel(x6)"
	result = /obj/item/rotation_contraption/cog
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/roguegear/wood/basic = 2, /obj/item/natural/wood/plank = 2)
	rogue_results = list(/obj/item/rotation_contraption/cog, /obj/item/rotation_contraption/cog, /obj/item/rotation_contraption/cog, /obj/item/rotation_contraption/cog, /obj/item/rotation_contraption/cog)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 3
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/coolingtable
	name = "cooling table"
	result = /obj/structure/table/wood/rockhill/cooling
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/ingot/iron = 1, /obj/item/roguegear/bronze = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/crossbow
	name = "Crossbow"
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	reqs = list(/obj/item/ingot/steel = 1, /obj/item/natural/fibers = 1, /obj/item/natural/wood/plank = 2)
	blacklist = list(/obj/item/ingot/steel/zizo)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/distiller
	name = "copper distiller"
	result = /obj/structure/fermentation_keg/distiller
	reqs = list(/obj/item/ingot/copper = 2, /obj/item/reagent_containers/glass/bucket/pot/stone = 1)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/flametrap
	name = "flame trap"
	result = /obj/structure/trap/flame
	reqs = list(/obj/item/roguegear/bronze = 1, /obj/item/natural/clay = 2, /obj/item/roguegem/amethyst = 2, /obj/item/alch/irondust = 1, /obj/item/alch/firedust = 1)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/flareimpact
	name = "flare shell, bombard charge"
	result = /obj/item/cannonball/flare
	reqs = list(/obj/item/rogueore/cinnabar = 2, /obj/item/alch/coaldust = 1, /obj/item/paper/parchment = 4)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/gearbox
	name = "gearbox (2x)"
	result = /obj/item/rotation_contraption/horizontal
	reqs = list(/obj/item/roguegear/bronze = 2, /obj/item/natural/stoneblock = 2, /obj/item/natural/wood/plank = 2)
	rogue_results = list(/obj/item/rotation_contraption/horizontal)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 3
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/heavyboltsten
	name = "Heavy Bolts 10x"
	result = /obj/item/ammo_casing/caseless/rogue/heavy_bolt
	reqs = list(/obj/item/natural/wood/plank = 4, /obj/item/ingot/iron = 2)
	rogue_results = list(/obj/item/ammo_casing/caseless/rogue/heavy_bolt, /obj/item/ammo_casing/caseless/rogue/heavy_bolt, /obj/item/ammo_casing/caseless/rogue/heavy_bolt, /obj/item/ammo_casing/caseless/rogue/heavy_bolt, /obj/item/ammo_casing/caseless/rogue/heavy_bolt, /obj/item/ammo_casing/caseless/rogue/heavy_bolt, /obj/item/ammo_casing/caseless/rogue/heavy_bolt, /obj/item/ammo_casing/caseless/rogue/heavy_bolt, /obj/item/ammo_casing/caseless/rogue/heavy_bolt)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/highexplosiveimpact
	name = "high explosive impact, bombard charge"
	result = /obj/item/cannonball/explosive
	reqs = list(/obj/item/tntstick = 2, /obj/item/alch/coaldust = 1, /obj/item/paper/parchment = 4)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/impactblindingsmoke
	name = "smoke grenades, blinding (x3)"
	result = /obj/item/impact_grenade/smoke/blind_gas
	reqs = list(/obj/item/smokeshell = 3, /obj/item/alch/coaldust = 1, /obj/item/ash = 1, /obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced = 1, /obj/item/natural/dirtclod = 1, /datum/reagent/water = 48)
	rogue_results = list(/obj/item/impact_grenade/smoke/blind_gas, /obj/item/impact_grenade/smoke/blind_gas)
	blacklist = list(/obj/item/ash/snappop_phoenix, /obj/item/natural/dirtclod/sand, /obj/item/natural/dirtclod/snow)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/impactexplosive
	name = "impact grenades (x3)"
	result = /obj/item/impact_grenade/explosion
	reqs = list(/obj/item/natural/clay = 1, /obj/item/paper/parchment = 1, /obj/item/alch/coaldust = 1, /obj/item/alch/firedust = 1, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 1)
	rogue_results = list(/obj/item/impact_grenade/explosion, /obj/item/impact_grenade/explosion)
	blacklist = list(/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/impactfiresmoke
	name = "smoke grenades, incendiary (x3)"
	result = /obj/item/impact_grenade/smoke/fire_gas
	reqs = list(/obj/item/smokeshell = 3, /obj/item/alch/coaldust = 2, /obj/item/ash = 1, /obj/item/alch/firedust = 1, /obj/item/alch/solardust = 1, /datum/reagent/water = 48)
	rogue_results = list(/obj/item/impact_grenade/smoke/fire_gas, /obj/item/impact_grenade/smoke/fire_gas)
	blacklist = list(/obj/item/ash/snappop_phoenix)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/impacthealingsmoke
	name = "smoke grenades, healing (x3)"
	result = /obj/item/impact_grenade/smoke/healing_gas
	reqs = list(/obj/item/smokeshell = 3, /obj/item/alch/coaldust = 1, /obj/item/ash = 1, /obj/item/alch/viscera = 1, /obj/item/alch/bonemeal = 1, /datum/reagent/water = 48)
	rogue_results = list(/obj/item/impact_grenade/smoke/healing_gas, /obj/item/impact_grenade/smoke/healing_gas)
	blacklist = list(/obj/item/ash/snappop_phoenix)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/impactmutesmoke
	name = "smoke grenades, muting (x3)"
	result = /obj/item/impact_grenade/smoke/mute_gas
	reqs = list(/obj/item/smokeshell = 3, /obj/item/alch/coaldust = 1, /obj/item/ash = 1, /obj/item/alch/irondust = 1, /obj/item/rogueore/cinnabar = 1, /datum/reagent/water = 48)
	rogue_results = list(/obj/item/impact_grenade/smoke/mute_gas, /obj/item/impact_grenade/smoke/mute_gas)
	blacklist = list(/obj/item/ash/snappop_phoenix)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/impactpoisonsmoke
	name = "smoke grenades, poisonous (x3)"
	result = /obj/item/impact_grenade/smoke/poison_gas
	reqs = list(/obj/item/smokeshell = 3, /obj/item/alch/coaldust = 1, /obj/item/ash = 1, /datum/reagent/berrypoison = 5, /obj/item/alch/airdust = 1, /datum/reagent/water = 48)
	rogue_results = list(/obj/item/impact_grenade/smoke/poison_gas, /obj/item/impact_grenade/smoke/poison_gas)
	blacklist = list(/obj/item/ash/snappop_phoenix)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/impactsmoke
	name = "smoke grenades (x3)"
	result = /obj/item/impact_grenade/smoke
	reqs = list(/obj/item/smokeshell = 3, /obj/item/alch/coaldust = 1, /obj/item/ash = 1, /datum/reagent/water = 48)
	rogue_results = list(/obj/item/impact_grenade/smoke, /obj/item/impact_grenade/smoke)
	blacklist = list(/obj/item/ash/snappop_phoenix)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/incendiaryimpact
	name = "incendiary shell, bombard charge"
	result = /obj/item/cannonball/incendiary
	reqs = list(/obj/item/alch/coaldust = 4, /obj/item/paper/parchment = 4)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/infernalengine
	name = "infernal engine"
	result = /obj/structure/infernalengine
	reqs = list(/obj/item/magic/infernal/core = 1, /obj/item/ingot/steel = 1)
	blacklist = list(/obj/item/ingot/steel/zizo)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/large_cog
	name = "large wooden cogwheel (3x)"
	result = /obj/item/rotation_contraption/large_cog
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/roguegear/wood/basic = 2, /obj/item/natural/wood/plank = 4)
	rogue_results = list(/obj/item/rotation_contraption/large_cog, /obj/item/rotation_contraption/large_cog)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 3
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/lever
	name = "lever"
	result = /obj/structure/lever
	reqs = list(/obj/item/roguegear/bronze = 1)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/minecart
	name = "minecart"
	result = /obj/structure/closet/crate/wooden/rockhill/crate/miningcar
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/ingot/iron = 1, /obj/item/grown/log/tree/stick = 4, /obj/item/roguegear/bronze = 2)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 3
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/minershelmet
	name = "reinforced miners helmet"
	result = /obj/item/clothing/head/roguetown/helmet/kettle/minershelm
	reqs = list(/obj/item/flashlight/flare/torch/lantern/bronzelamptern = 1, /obj/item/clothing/head/roguetown/articap = 1, /obj/item/roguegear/bronze = 1)
	blacklist = list(/obj/item/clothing/head/roguetown/articap/lich)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/passage
	name = "passage"
	result = /obj/structure/bars/passage
	reqs = list(/obj/item/ingot/iron = 1, /obj/item/roguegear/bronze = 1)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 2
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/peddlercart
	name = "peddler cart"
	result = /obj/structure/roguemachine/vendor/mobile/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/ingot/iron = 1, /obj/item/natural/glass = 1, /obj/item/roguegear/bronze = 2)
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/natural/glass/heated)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/potioncart
	name = "potion cart"
	result = /obj/structure/roguemachine/potionseller/mobile/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/ingot/iron = 1, /obj/item/natural/glass = 2, /obj/item/roguegear/bronze = 2)
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/natural/glass/heated)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/potionseller
	name = "potion seller peddler"
	result = /obj/structure/roguemachine/potionseller/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/ingot/iron = 1, /obj/item/natural/glass = 1, /obj/item/roguegear/bronze = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/natural/glass/heated)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/pyroarrow
	name = "pyroclastic arrow"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/pyro
	reqs = list(/obj/item/ammo_casing/caseless/rogue/arrow/iron = 1, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 1)
	blacklist = list(/obj/item/ammo_casing/caseless/rogue/arrow/iron/aalloy, /obj/item/ammo_casing/caseless/rogue/arrow/iron/conjured, /obj/item/ammo_casing/caseless/rogue/arrow/iron/decrepit, /obj/item/ammo_casing/caseless/rogue/arrow/iron/paint, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/pyroarrow_five
	name = "pyroclastic arrow"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/pyro
	reqs = list(/obj/item/ammo_casing/caseless/rogue/arrow/iron = 5, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 5)
	rogue_results = list(/obj/item/ammo_casing/caseless/rogue/arrow/pyro, /obj/item/ammo_casing/caseless/rogue/arrow/pyro, /obj/item/ammo_casing/caseless/rogue/arrow/pyro, /obj/item/ammo_casing/caseless/rogue/arrow/pyro)
	blacklist = list(/obj/item/ammo_casing/caseless/rogue/arrow/iron/aalloy, /obj/item/ammo_casing/caseless/rogue/arrow/iron/conjured, /obj/item/ammo_casing/caseless/rogue/arrow/iron/decrepit, /obj/item/ammo_casing/caseless/rogue/arrow/iron/paint, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/pyrobolt
	name = "pyroclastic bolt"
	result = /obj/item/ammo_casing/caseless/rogue/bolt/pyro
	reqs = list(/obj/item/ammo_casing/caseless/rogue/bolt = 1, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 1)
	blacklist = list(/obj/item/ammo_casing/caseless/rogue/bolt/aalloy, /obj/item/ammo_casing/caseless/rogue/bolt/ancient, /obj/item/ammo_casing/caseless/rogue/bolt/blacksteel, /obj/item/ammo_casing/caseless/rogue/bolt/blunt, /obj/item/ammo_casing/caseless/rogue/bolt/bronze, /obj/item/ammo_casing/caseless/rogue/bolt/conjured, /obj/item/ammo_casing/caseless/rogue/bolt/decrepit, /obj/item/ammo_casing/caseless/rogue/bolt/heavyblunt, /obj/item/ammo_casing/caseless/rogue/bolt/holy, /obj/item/ammo_casing/caseless/rogue/bolt/light, /obj/item/ammo_casing/caseless/rogue/bolt/lightholy, /obj/item/ammo_casing/caseless/rogue/bolt/paalloy, /obj/item/ammo_casing/caseless/rogue/bolt/pyro, /obj/item/ammo_casing/caseless/rogue/bolt/silver, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/pyrobolt_five
	name = "pyroclastic bolt"
	result = /obj/item/ammo_casing/caseless/rogue/bolt/pyro
	reqs = list(/obj/item/ammo_casing/caseless/rogue/bolt = 5, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 5)
	rogue_results = list(/obj/item/ammo_casing/caseless/rogue/bolt/pyro, /obj/item/ammo_casing/caseless/rogue/bolt/pyro, /obj/item/ammo_casing/caseless/rogue/bolt/pyro, /obj/item/ammo_casing/caseless/rogue/bolt/pyro)
	blacklist = list(/obj/item/ammo_casing/caseless/rogue/bolt/aalloy, /obj/item/ammo_casing/caseless/rogue/bolt/ancient, /obj/item/ammo_casing/caseless/rogue/bolt/blacksteel, /obj/item/ammo_casing/caseless/rogue/bolt/blunt, /obj/item/ammo_casing/caseless/rogue/bolt/bronze, /obj/item/ammo_casing/caseless/rogue/bolt/conjured, /obj/item/ammo_casing/caseless/rogue/bolt/decrepit, /obj/item/ammo_casing/caseless/rogue/bolt/heavyblunt, /obj/item/ammo_casing/caseless/rogue/bolt/holy, /obj/item/ammo_casing/caseless/rogue/bolt/light, /obj/item/ammo_casing/caseless/rogue/bolt/lightholy, /obj/item/ammo_casing/caseless/rogue/bolt/paalloy, /obj/item/ammo_casing/caseless/rogue/bolt/pyro, /obj/item/ammo_casing/caseless/rogue/bolt/silver, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/railbreak
	name = "minecart rail break (8x)"
	result = /obj/item/rotation_contraption/minecart_rail/railbreak
	reqs = list(/obj/item/roguegear/bronze = 1, /obj/item/ingot/iron = 1)
	rogue_results = list(/obj/item/rotation_contraption/minecart_rail/railbreak, /obj/item/rotation_contraption/minecart_rail/railbreak, /obj/item/rotation_contraption/minecart_rail/railbreak, /obj/item/rotation_contraption/minecart_rail/railbreak, /obj/item/rotation_contraption/minecart_rail/railbreak, /obj/item/rotation_contraption/minecart_rail/railbreak, /obj/item/rotation_contraption/minecart_rail/railbreak)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 3
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/rails
	name = "minecart rails (x20)"
	result = /obj/item/rotation_contraption/minecart_rail
	reqs = list(/obj/item/natural/wood/plank = 5, /obj/item/ingot/iron = 1)
	rogue_results = list(/obj/item/rotation_contraption/minecart_rail, /obj/item/rotation_contraption/minecart_rail, /obj/item/rotation_contraption/minecart_rail, /obj/item/rotation_contraption/minecart_rail, /obj/item/rotation_contraption/minecart_rail, /obj/item/rotation_contraption/minecart_rail, /obj/item/rotation_contraption/minecart_rail, /obj/item/rotation_contraption/minecart_rail, /obj/item/rotation_contraption/minecart_rail, /obj/item/rotation_contraption/minecart_rail, /obj/item/rotation_contraption/minecart_rail, /obj/item/rotation_contraption/minecart_rail, /obj/item/rotation_contraption/minecart_rail, /obj/item/rotation_contraption/minecart_rail, /obj/item/rotation_contraption/minecart_rail, /obj/item/rotation_contraption/minecart_rail, /obj/item/rotation_contraption/minecart_rail, /obj/item/rotation_contraption/minecart_rail, /obj/item/rotation_contraption/minecart_rail)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 3
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/ramrod
	name = "bombard ramrod"
	result = /obj/item/rogueweapon/woodstaff/quarterstaff/bombard_sponge
	reqs = list(/obj/item/rogueweapon/woodstaff/quarterstaff = 1, /obj/item/natural/cloth = 2)
	blacklist = list(/obj/item/natural/cloth/bandage, /obj/item/rogueweapon/woodstaff/quarterstaff/blacksteel, /obj/item/rogueweapon/woodstaff/quarterstaff/bombard_sponge, /obj/item/rogueweapon/woodstaff/quarterstaff/bostaff, /obj/item/rogueweapon/woodstaff/quarterstaff/gold, /obj/item/rogueweapon/woodstaff/quarterstaff/iron, /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter, /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter/warden, /obj/item/rogueweapon/woodstaff/quarterstaff/psy, /obj/item/rogueweapon/woodstaff/quarterstaff/silver, /obj/item/rogueweapon/woodstaff/quarterstaff/steel, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/astrata, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/donator_elegant, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/holysee, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/noc, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/silver, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/silver/psy, /obj/item/rogueweapon/woodstaff/quarterstaff/virtue)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/satchelbomb
	name = "blastsand satchel"
	result = /obj/item/satchel_bomb
	reqs = list(/obj/item/storage/backpack/rogue/satchel = 1, /obj/item/tntstick = 3, /obj/item/alch/firedust = 1, /obj/item/natural/fibers = 1)
	blacklist = list(/obj/item/storage/backpack/rogue/satchel/beltpack, /obj/item/storage/backpack/rogue/satchel/beltpack/donator_naman, /obj/item/storage/backpack/rogue/satchel/black, /obj/item/storage/backpack/rogue/satchel/case, /obj/item/storage/backpack/rogue/satchel/citywatch, /obj/item/storage/backpack/rogue/satchel/cloth, /obj/item/storage/backpack/rogue/satchel/heartfelt, /obj/item/storage/backpack/rogue/satchel/otavan, /obj/item/storage/backpack/rogue/satchel/otavan/short, /obj/item/storage/backpack/rogue/satchel/short, /obj/item/storage/backpack/rogue/satchel/short/black, /obj/item/storage/backpack/rogue/satchel/short/timesoldier_ifak, /obj/item/storage/backpack/rogue/satchel/tailchel)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/sawbladetrap
	name = "saw blades trap"
	result = /obj/structure/trap/saw_blades
	reqs = list(/obj/item/roguegear/bronze = 3, /obj/item/natural/clay = 2, /obj/item/roguegem/amethyst = 2, /obj/item/alch/irondust = 1, /obj/item/natural/whetstone = 1)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/shaft
	name = "wooden shaft(8x)"
	result = /obj/item/rotation_contraption/shaft
	reqs = list(/obj/item/grown/log/tree/small = 1)
	rogue_results = list(/obj/item/rotation_contraption/shaft, /obj/item/rotation_contraption/shaft, /obj/item/rotation_contraption/shaft, /obj/item/rotation_contraption/shaft, /obj/item/rotation_contraption/shaft, /obj/item/rotation_contraption/shaft, /obj/item/rotation_contraption/shaft)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/shocktrap
	name = "shock trap"
	result = /obj/structure/trap/shock
	reqs = list(/obj/item/roguegear/bronze = 1, /obj/item/natural/clay = 2, /obj/item/roguegem/amethyst = 2, /obj/item/alch/irondust = 1, /obj/item/alch/magicdust = 1)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 6
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/shopbars
	name = "shop bars"
	result = /obj/structure/bars/shop
	reqs = list(/obj/item/ingot/iron = 1)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_ignore_density = TRUE
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/shutters
	name = "shutters"
	result = /obj/structure/bars/passage/shutter
	reqs = list(/obj/item/ingot/iron = 1, /obj/item/roguegear/bronze = 1)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 2
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/signalflare
	name = "signal flare canister (x4)"
	result = /obj/item/signal_flare
	reqs = list(/obj/item/natural/clay = 1, /obj/item/paper/parchment = 1, /obj/item/alch/coaldust = 1, /obj/item/alch/firedust = 1, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 1)
	rogue_results = list(/obj/item/signal_flare, /obj/item/signal_flare, /obj/item/signal_flare)
	blacklist = list(/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/slurbow
	name = "Slurbow"
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
	reqs = list(/obj/item/ingot/steel = 2, /obj/item/natural/fibers = 1, /obj/item/natural/wood/plank = 2)
	blacklist = list(/obj/item/ingot/steel/zizo)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/smither
	name = "Autosmither"
	result = /obj/structure/autosmither
	reqs = list(/obj/item/roguegear/bronze = 4, /obj/item/ingot/steel = 2, /obj/item/natural/wood/plank = 4)
	blacklist = list(/obj/item/ingot/steel/zizo)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/smokeimpact
	name = "smoke shell, bombard charge"
	result = /obj/item/cannonball/smoke
	reqs = list(/obj/item/bomb/smoke = 3, /obj/item/alch/coaldust = 2, /obj/item/paper/parchment = 4)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/smokepowder
	name = "Smokepowder Flask"
	result = /obj/item/powderflask
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/alch/firedust = 2, /obj/item/alch/coaldust = 2)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/stickshaft
	name = "wooden shaft"
	result = /obj/item/rotation_contraption/shaft
	reqs = list(/obj/item/grown/log/tree/stick = 2)
	rogue_results = list(/obj/item/rotation_contraption/shaft)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/tntbomb
	name = "blastsand sticks (x3)"
	result = /obj/item/tntstick
	reqs = list(/obj/item/paper/parchment = 3, /obj/item/alch/coaldust = 2, /obj/item/compost = 2, /obj/item/natural/fibers = 1)
	rogue_results = list(/obj/item/tntstick, /obj/item/tntstick)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/trapdoor
	name = "floorhatch"
	result = /obj/structure/floordoor
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/roguegear/bronze = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 2
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/twentybolts
	name = "Crossbow Bolts 20x"
	result = /obj/item/ammo_casing/caseless/rogue/bolt
	reqs = list(/obj/item/natural/wood/plank = 3, /obj/item/ingot/iron = 1)
	rogue_results = list(/obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/artificer_table
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/vertical_gearbox
	name = "vertical gearbox (2x)"
	result = /obj/item/rotation_contraption/vertical
	reqs = list(/obj/item/roguegear/bronze = 2, /obj/item/natural/stoneblock = 2, /obj/item/natural/wood/plank = 2)
	rogue_results = list(/obj/item/rotation_contraption/vertical)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 3
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/waterwheel
	name = "wooden waterwheel (x2)"
	result = /obj/item/rotation_contraption/waterwheel
	reqs = list(/obj/item/natural/wood/plank = 3)
	rogue_results = list(/obj/item/rotation_contraption/waterwheel)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 3
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/engineering/windmill
	name = "windmill"
	result = /obj/structure/windmill
	reqs = list(/obj/item/natural/wood/plank = 4, /obj/item/natural/cloth = 2, /obj/item/grown/log/tree/stick = 2)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	blacklist = list(/obj/item/natural/cloth/bandage)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/farming/fertilizer
	name = "fertilizer"
	result = /obj/item/fertilizer
	reqs = list(/obj/item/compost = 1, /obj/item/natural/bone = 1, /obj/item/natural/poo = 1)
	category = "Farming"
	rogue_skill = /datum/attribute/skill/labor/farming
	rogue_difficulty = 3
	rogue_verb_simple = "mix"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/fleshcrafting/black_rose
	name = "Black Rose"
	result = /obj/item/black_rose
	reqs = list(/obj/item/heart_blood_canister/filled = 5, /obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 15)
	category = "Butchering"
	rogue_skill = /datum/attribute/skill/labor/butchering
	rogue_difficulty = 5
	rogue_structure = /obj/structure/roguemachine/chimeric_heart_beast
	rogue_verb_simple = "assembles"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_tech_node = "BLACK_ROSE"

/datum/crafting_recipe/roguetown/fleshcrafting/decoy
	name = "flesh decoy (2x fresh meat)"
	result = /obj/item/flesh_decoy
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/meat = 2)
	category = "Butchering"
	rogue_skill = /datum/attribute/skill/labor/butchering
	rogue_difficulty = 2
	rogue_verb_simple = "assembles"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_tech_node = "FLESH_DECOYS"

/datum/crafting_recipe/roguetown/fleshcrafting/decoy_alt
	name = "flesh decoy (2x viscera)"
	result = /obj/item/flesh_decoy
	reqs = list(/obj/item/alch/viscera = 2)
	category = "Butchering"
	rogue_skill = /datum/attribute/skill/labor/butchering
	rogue_difficulty = 2
	rogue_verb_simple = "assembles"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_tech_node = "VISCERA_DECOYS"

/datum/crafting_recipe/roguetown/fleshcrafting/eyes
	name = "Eyes"
	result = /obj/item/organ/eyes
	reqs = list(/obj/item/flesh_node = 1, /obj/item/heart_blood_vial/filled = 1)
	category = "Butchering"
	rogue_skill = /datum/attribute/skill/labor/butchering
	rogue_difficulty = 4
	rogue_structure = /obj/structure/roguemachine/chimeric_heart_beast
	rogue_verb_simple = "assembles"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_tech_node = "BASIC_ORGANS"

/datum/crafting_recipe/roguetown/fleshcrafting/flesh_node
	name = "flesh node (1x rotten meat)"
	result = /obj/item/flesh_node
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 1)
	category = "Butchering"
	rogue_skill = /datum/attribute/skill/labor/butchering
	rogue_structure = /obj/structure/roguemachine/chimeric_heart_beast
	rogue_verb_simple = "assembles"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/fleshcrafting/heart
	name = "Heart"
	result = /obj/item/organ/heart
	reqs = list(/obj/item/flesh_node = 2, /obj/item/heart_blood_vial/filled = 1)
	category = "Butchering"
	rogue_skill = /datum/attribute/skill/labor/butchering
	rogue_difficulty = 4
	rogue_structure = /obj/structure/roguemachine/chimeric_heart_beast
	rogue_verb_simple = "assembles"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_tech_node = "BASIC_ORGANS"

/datum/crafting_recipe/roguetown/fleshcrafting/imperfect_gnoll
	name = "vilespawn flesh"
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/vilespawn
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll = 1, /obj/item/roguegem/blood_diamond = 1)
	category = "Butchering"
	rogue_skill = /datum/attribute/skill/labor/butchering
	rogue_verb_simple = "assembles"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/fleshcrafting/leechbait
	name = "leechbait"
	result = /obj/item/bait/leech
	reqs = list(/obj/item/storage/roguebag = 3, /obj/item/reagent_containers/lux_impure = 1)
	rogue_results = list(/obj/item/bait/leech, /obj/item/bait/leech)
	category = "Butchering"
	rogue_skill = /datum/attribute/skill/labor/butchering
	rogue_verb_simple = "assembles"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/fleshcrafting/liver
	name = "Liver"
	result = /obj/item/organ/liver
	reqs = list(/obj/item/flesh_node = 2, /obj/item/heart_blood_vial/filled = 1)
	category = "Butchering"
	rogue_skill = /datum/attribute/skill/labor/butchering
	rogue_difficulty = 4
	rogue_structure = /obj/structure/roguemachine/chimeric_heart_beast
	rogue_verb_simple = "assembles"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_tech_node = "BASIC_ORGANS"

/datum/crafting_recipe/roguetown/fleshcrafting/lungs
	name = "Lungs"
	result = /obj/item/organ/lungs
	reqs = list(/obj/item/flesh_node = 2, /obj/item/heart_blood_vial/filled = 1)
	category = "Butchering"
	rogue_skill = /datum/attribute/skill/labor/butchering
	rogue_difficulty = 4
	rogue_structure = /obj/structure/roguemachine/chimeric_heart_beast
	rogue_verb_simple = "assembles"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_tech_node = "BASIC_ORGANS"

/datum/crafting_recipe/roguetown/fleshcrafting/tongue
	name = "Tongue"
	result = /obj/item/organ/tongue
	reqs = list(/obj/item/flesh_node = 1, /obj/item/heart_blood_vial/filled = 1)
	category = "Butchering"
	rogue_skill = /datum/attribute/skill/labor/butchering
	rogue_difficulty = 4
	rogue_structure = /obj/structure/roguemachine/chimeric_heart_beast
	rogue_verb_simple = "assembles"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_tech_node = "BASIC_ORGANS"

/datum/crafting_recipe/roguetown/gemcarving/amber/amulet
	name = "amber amulet"
	result = /obj/item/clothing/neck/roguetown/carved/amberamulet
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/amber/beaver
	name = "amber beaver statue"
	result = /obj/item/carvedgem/amber/beaver
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/amber/bowl
	name = "amber bowl"
	result = /obj/item/reagent_containers/glass/bowl/carved/amber
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/amber/bracelet
	name = "amber bracelets"
	result = /obj/item/clothing/wrists/roguetown/gem/amberbracelet
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/amber/bust
	name = "amber bust"
	result = /obj/item/carvedgem/amber/bust
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/amber/cameo
	name = "amber cameo"
	result = /obj/item/carvedgem/amber/cameo
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/amber/circlet
	name = "amber circlet"
	result = /obj/item/clothing/head/roguetown/circlet/carvedgem/amber
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/amber/comb
	name = "amber comb"
	result = /obj/item/carvedgem/amber/comb
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/amber/cup
	name = "amber cup"
	result = /obj/item/reagent_containers/glass/cup/carved/amber
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/amber/duck
	name = "amber duck"
	result = /obj/item/carvedgem/amber/duck
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/amber/fancycup
	name = "fancy amber cup"
	result = /obj/item/reagent_containers/glass/cup/carved/amberfancy
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/amber/fancyvase
	name = "fancy amber vase"
	result = /obj/item/carvedgem/amber/fancyvase
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/amber/figurine
	name = "amber figurine"
	result = /obj/item/carvedgem/amber/figurine
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/amber/fish
	name = "amber fish figurine"
	result = /obj/item/carvedgem/amber/fish
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/amber/fork
	name = "amber fork"
	result = /obj/item/kitchen/fork/carved/amber
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/amber/mask
	name = "amber mask"
	result = /obj/item/clothing/mask/rogue/facemask/carved/ambermask
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/amber/obelisk
	name = "amber obelisk"
	result = /obj/item/carvedgem/amber/obelisk
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/amber/platter
	name = "amber platter"
	result = /obj/item/cooking/platter/carved/amber
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/amber/ring
	name = "amber ring"
	result = /obj/item/clothing/ring/amber
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/amber/spoon
	name = "amber spoon"
	result = /obj/item/kitchen/spoon/carved/amber
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/amber/statue
	name = "amber statue"
	result = /obj/item/carvedgem/amber/statue
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/amber/sun
	name = "amber sun carving"
	result = /obj/item/carvedgem/amber/sun
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/amber/tablet
	name = "amber tablet"
	result = /obj/item/carvedgem/amber/tablet
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/amber/teapot
	name = "amber teapot"
	result = /obj/item/reagent_containers/glass/bucket/pot/carved/teapotamber
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/amber/urn
	name = "amber urn"
	result = /obj/item/carvedgem/amber/urn
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/amber/vase
	name = "amber vase"
	result = /obj/item/carvedgem/amber/vase
	reqs = list(/obj/item/roguegem/amber = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/chitin/amulet
	name = "chitin amulet"
	result = /obj/item/clothing/neck/roguetown/carved/chitinamulet
	reqs = list(/obj/item/carvedgem/chitin/rawchitin = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/chitin/beetle
	name = "chitin beetle sculpture"
	result = /obj/item/carvedgem/chitin/beetle
	reqs = list(/obj/item/carvedgem/chitin/rawchitin = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/chitin/bracelet
	name = "chitin bracelets"
	result = /obj/item/clothing/wrists/roguetown/gem/chitinbracelet
	reqs = list(/obj/item/carvedgem/chitin/rawchitin = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/chitin/bust
	name = "chitin bust"
	result = /obj/item/carvedgem/chitin/bust
	reqs = list(/obj/item/carvedgem/chitin/rawchitin = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/chitin/cameo
	name = "chitin cameo"
	result = /obj/item/carvedgem/chitin/cameo
	reqs = list(/obj/item/carvedgem/chitin/rawchitin = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/chitin/circlet
	name = "chitin circlet"
	result = /obj/item/clothing/head/roguetown/circlet/carvedgem/chitin
	reqs = list(/obj/item/carvedgem/chitin/rawchitin = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/chitin/comb
	name = "chitin comb"
	result = /obj/item/carvedgem/chitin/comb
	reqs = list(/obj/item/carvedgem/chitin/rawchitin = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/chitin/duck
	name = "chitin duck"
	result = /obj/item/carvedgem/chitin/duck
	reqs = list(/obj/item/carvedgem/chitin/rawchitin = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/chitin/fancyvase
	name = "fancy chitin vase"
	result = /obj/item/carvedgem/chitin/fancyvase
	reqs = list(/obj/item/carvedgem/chitin/rawchitin = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/chitin/figurine
	name = "chitin figurine"
	result = /obj/item/carvedgem/chitin/figurine
	reqs = list(/obj/item/carvedgem/chitin/rawchitin = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/chitin/fish
	name = "chitin fish figurine"
	result = /obj/item/carvedgem/chitin/fish
	reqs = list(/obj/item/carvedgem/chitin/rawchitin = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/chitin/obelisk
	name = "chitin obelisk"
	result = /obj/item/carvedgem/chitin/obelisk
	reqs = list(/obj/item/carvedgem/chitin/rawchitin = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/chitin/ring
	name = "chitin ring"
	result = /obj/item/clothing/ring/chitin
	reqs = list(/obj/item/carvedgem/chitin/rawchitin = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/chitin/statue
	name = "chitin statue"
	result = /obj/item/carvedgem/chitin/statue
	reqs = list(/obj/item/carvedgem/chitin/rawchitin = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/chitin/tablet
	name = "chitin tablet"
	result = /obj/item/carvedgem/chitin/tablet
	reqs = list(/obj/item/carvedgem/chitin/rawchitin = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/chitin/urn
	name = "chitin urn"
	result = /obj/item/carvedgem/chitin/urn
	reqs = list(/obj/item/carvedgem/chitin/rawchitin = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/chitin/vase
	name = "chitin vase"
	result = /obj/item/carvedgem/chitin/vase
	reqs = list(/obj/item/carvedgem/chitin/rawchitin = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/amulet
	name = "heartstone amulet"
	result = /obj/item/clothing/neck/roguetown/carved/coralamulet
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/bowl
	name = "heartstone bowl"
	result = /obj/item/reagent_containers/glass/bowl/carved/coral
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/bracelet
	name = "heartstone bracelets"
	result = /obj/item/clothing/wrists/roguetown/gem/coralbracelet
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/bust
	name = "heartstone bust"
	result = /obj/item/carvedgem/coral/bust
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/cameo
	name = "heartstone cameo"
	result = /obj/item/carvedgem/coral/cameo
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/circlet
	name = "heartstone circlet"
	result = /obj/item/clothing/head/roguetown/circlet/carvedgem/coral
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/comb
	name = "heartstone comb"
	result = /obj/item/carvedgem/coral/comb
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/cup
	name = "heartstone cup"
	result = /obj/item/reagent_containers/glass/cup/carved/coral
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/duck
	name = "heartstone duck"
	result = /obj/item/carvedgem/coral/duck
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/fancycup
	name = "fancy heartstone cup"
	result = /obj/item/reagent_containers/glass/cup/carved/coralfancy
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/fancyvase
	name = "fancy heartstone vase"
	result = /obj/item/carvedgem/coral/fancyvase
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/figurine
	name = "heartstone figurine"
	result = /obj/item/carvedgem/coral/figurine
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/fish
	name = "heartstone fish figurine"
	result = /obj/item/carvedgem/coral/fish
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/fork
	name = "heartstone fork"
	result = /obj/item/kitchen/fork/carved/coral
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/jaw
	name = "shark jaw statue"
	result = /obj/item/carvedgem/coral/jaw
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/mask
	name = "heartstone mask"
	result = /obj/item/clothing/mask/rogue/facemask/carved/coralmask
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/obelisk
	name = "heartstone obelisk"
	result = /obj/item/carvedgem/coral/obelisk
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/platter
	name = "heartstone platter"
	result = /obj/item/cooking/platter/carved/coral
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/ring
	name = "heartstone ring"
	result = /obj/item/clothing/ring/coral
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/shark
	name = "heartstone shark statue"
	result = /obj/item/carvedgem/coral/shark
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/spoon
	name = "heartstone spoon"
	result = /obj/item/kitchen/spoon/carved/coral
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/statue
	name = "heartstone statue"
	result = /obj/item/carvedgem/coral/statue
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/tablet
	name = "heartstone tablet"
	result = /obj/item/carvedgem/coral/tablet
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/teapot
	name = "heartstone teapot"
	result = /obj/item/reagent_containers/glass/bucket/pot/carved/teapotcoral
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/urn
	name = "heartstone urn"
	result = /obj/item/carvedgem/coral/urn
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/coral/vase
	name = "heartstone vase"
	result = /obj/item/carvedgem/coral/vase
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/head_roguetown_circlet_carvedgem_porcelain
	name = "porcelain circlet"
	result = /obj/item/clothing/head/roguetown/circlet/carvedgem/porcelain
	reqs = list(/obj/item/natural/clay/porcelain = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	blacklist = list(/obj/item/natural/clay/porcelain/bauble, /obj/item/natural/clay/porcelain/beaver, /obj/item/natural/clay/porcelain/bowl, /obj/item/natural/clay/porcelain/box, /obj/item/natural/clay/porcelain/bust, /obj/item/natural/clay/porcelain/cameo, /obj/item/natural/clay/porcelain/carp, /obj/item/natural/clay/porcelain/caryatid, /obj/item/natural/clay/porcelain/comb, /obj/item/natural/clay/porcelain/cup, /obj/item/natural/clay/porcelain/decorativeteapot, /obj/item/natural/clay/porcelain/display, /obj/item/natural/clay/porcelain/duck, /obj/item/natural/clay/porcelain/fancycup, /obj/item/natural/clay/porcelain/fancyteacup, /obj/item/natural/clay/porcelain/fancyteapot, /obj/item/natural/clay/porcelain/fancyvase, /obj/item/natural/clay/porcelain/figurine, /obj/item/natural/clay/porcelain/fish, /obj/item/natural/clay/porcelain/fork, /obj/item/natural/clay/porcelain/heart, /obj/item/natural/clay/porcelain/mask, /obj/item/natural/clay/porcelain/moon, /obj/item/natural/clay/porcelain/obelisk, /obj/item/natural/clay/porcelain/octopus, /obj/item/natural/clay/porcelain/platter, /obj/item/natural/clay/porcelain/rungu, /obj/item/natural/clay/porcelain/spoon, /obj/item/natural/clay/porcelain/statue, /obj/item/natural/clay/porcelain/statuette, /obj/item/natural/clay/porcelain/sun, /obj/item/natural/clay/porcelain/tablet, /obj/item/natural/clay/porcelain/teapot, /obj/item/natural/clay/porcelain/turtle, /obj/item/natural/clay/porcelain/urn, /obj/item/natural/clay/porcelain/vase)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jade/bracelet
	name = "jade bracelets"
	result = /obj/item/clothing/wrists/roguetown/gem/jadebracelet
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jade/bust
	name = "jade bust"
	result = /obj/item/carvedgem/jade/bust
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jade/circlet
	name = "jade circlet"
	result = /obj/item/clothing/head/roguetown/circlet/carvedgem/jade
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jade/comb
	name = "jade comb"
	result = /obj/item/carvedgem/jade/comb
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jade/duck
	name = "jade duck"
	result = /obj/item/carvedgem/jade/duck
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jade/fancycup
	name = "fancy jade cup"
	result = /obj/item/reagent_containers/glass/cup/carved/jadefancy
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jade/fancyvase
	name = "fancy jade vase"
	result = /obj/item/carvedgem/jade/fancyvase
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jade/fish
	name = "jade fish figurine"
	result = /obj/item/carvedgem/jade/fish
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jade/kukri
	name = "jade kukri"
	result = /obj/item/rogueweapon/huntingknife/stoneknife/kukri
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jade/mask
	name = "jade mask"
	result = /obj/item/clothing/mask/rogue/facemask/carved/jademask
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jade/obelisk
	name = "jade obelisk"
	result = /obj/item/carvedgem/jade/obelisk
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jade/statue
	name = "jade statue"
	result = /obj/item/carvedgem/jade/statue
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jade/tablet
	name = "jade tablet"
	result = /obj/item/carvedgem/jade/tablet
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jade/teapot
	name = "jade teapot"
	result = /obj/item/reagent_containers/glass/bucket/pot/carved/teapotjade
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jade/urn
	name = "jade urn"
	result = /obj/item/carvedgem/jade/urn
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jade/wyrm
	name = "jade wyrm"
	result = /obj/item/carvedgem/jade/wyrm
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jadeamulet
	name = "jade amulet"
	result = /obj/item/clothing/neck/roguetown/carved/jadeamulet
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jadebowl
	name = "jade bowl"
	result = /obj/item/reagent_containers/glass/bowl/carved/jade
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jadecameo
	name = "jade cameo"
	result = /obj/item/carvedgem/jade/cameo
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jadecup
	name = "jade cup"
	result = /obj/item/reagent_containers/glass/cup/carved/jade
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jadefigurine
	name = "jade figurine"
	result = /obj/item/carvedgem/jade/figurine
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jadefork
	name = "jade fork"
	result = /obj/item/kitchen/fork/carved/jade
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jadeplatter
	name = "jade platter"
	result = /obj/item/cooking/platter/carved/jade
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jadering
	name = "jade ring"
	result = /obj/item/clothing/ring/jade
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jadespoon
	name = "jade spoon"
	result = /obj/item/kitchen/spoon/carved/jade
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/jadevase
	name = "jade vase"
	result = /obj/item/carvedgem/jade/vase
	reqs = list(/obj/item/roguegem/jade = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/mask_rogue_xylixmask_ceramic
	name = "ceramic mask"
	result = /obj/item/clothing/mask/rogue/xylixmask/ceramic
	reqs = list(/obj/item/natural/clay/porcelain = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	blacklist = list(/obj/item/natural/clay/porcelain/bauble, /obj/item/natural/clay/porcelain/beaver, /obj/item/natural/clay/porcelain/bowl, /obj/item/natural/clay/porcelain/box, /obj/item/natural/clay/porcelain/bust, /obj/item/natural/clay/porcelain/cameo, /obj/item/natural/clay/porcelain/carp, /obj/item/natural/clay/porcelain/caryatid, /obj/item/natural/clay/porcelain/comb, /obj/item/natural/clay/porcelain/cup, /obj/item/natural/clay/porcelain/decorativeteapot, /obj/item/natural/clay/porcelain/display, /obj/item/natural/clay/porcelain/duck, /obj/item/natural/clay/porcelain/fancycup, /obj/item/natural/clay/porcelain/fancyteacup, /obj/item/natural/clay/porcelain/fancyteapot, /obj/item/natural/clay/porcelain/fancyvase, /obj/item/natural/clay/porcelain/figurine, /obj/item/natural/clay/porcelain/fish, /obj/item/natural/clay/porcelain/fork, /obj/item/natural/clay/porcelain/heart, /obj/item/natural/clay/porcelain/mask, /obj/item/natural/clay/porcelain/moon, /obj/item/natural/clay/porcelain/obelisk, /obj/item/natural/clay/porcelain/octopus, /obj/item/natural/clay/porcelain/platter, /obj/item/natural/clay/porcelain/rungu, /obj/item/natural/clay/porcelain/spoon, /obj/item/natural/clay/porcelain/statue, /obj/item/natural/clay/porcelain/statuette, /obj/item/natural/clay/porcelain/sun, /obj/item/natural/clay/porcelain/tablet, /obj/item/natural/clay/porcelain/teapot, /obj/item/natural/clay/porcelain/turtle, /obj/item/natural/clay/porcelain/urn, /obj/item/natural/clay/porcelain/vase)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/mask_rogue_xylixmask_weathered
	name = "weathered mask"
	result = /obj/item/clothing/mask/rogue/xylixmask/weathered
	reqs = list(/obj/item/natural/clay/porcelain = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	blacklist = list(/obj/item/natural/clay/porcelain/bauble, /obj/item/natural/clay/porcelain/beaver, /obj/item/natural/clay/porcelain/bowl, /obj/item/natural/clay/porcelain/box, /obj/item/natural/clay/porcelain/bust, /obj/item/natural/clay/porcelain/cameo, /obj/item/natural/clay/porcelain/carp, /obj/item/natural/clay/porcelain/caryatid, /obj/item/natural/clay/porcelain/comb, /obj/item/natural/clay/porcelain/cup, /obj/item/natural/clay/porcelain/decorativeteapot, /obj/item/natural/clay/porcelain/display, /obj/item/natural/clay/porcelain/duck, /obj/item/natural/clay/porcelain/fancycup, /obj/item/natural/clay/porcelain/fancyteacup, /obj/item/natural/clay/porcelain/fancyteapot, /obj/item/natural/clay/porcelain/fancyvase, /obj/item/natural/clay/porcelain/figurine, /obj/item/natural/clay/porcelain/fish, /obj/item/natural/clay/porcelain/fork, /obj/item/natural/clay/porcelain/heart, /obj/item/natural/clay/porcelain/mask, /obj/item/natural/clay/porcelain/moon, /obj/item/natural/clay/porcelain/obelisk, /obj/item/natural/clay/porcelain/octopus, /obj/item/natural/clay/porcelain/platter, /obj/item/natural/clay/porcelain/rungu, /obj/item/natural/clay/porcelain/spoon, /obj/item/natural/clay/porcelain/statue, /obj/item/natural/clay/porcelain/statuette, /obj/item/natural/clay/porcelain/sun, /obj/item/natural/clay/porcelain/tablet, /obj/item/natural/clay/porcelain/teapot, /obj/item/natural/clay/porcelain/turtle, /obj/item/natural/clay/porcelain/urn, /obj/item/natural/clay/porcelain/vase)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/amulet
	name = "onyxa amulet"
	result = /obj/item/clothing/neck/roguetown/carved/onyxaamulet
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/bowl
	name = "onyxa bowl"
	result = /obj/item/reagent_containers/glass/bowl/carved/onyxa
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/bracelet
	name = "onyxa bracelets"
	result = /obj/item/clothing/wrists/roguetown/gem/onyxabracelet
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/bust
	name = "onyxa bust"
	result = /obj/item/carvedgem/onyxa/bust
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/cameo
	name = "onyxa cameo"
	result = /obj/item/carvedgem/onyxa/cameo
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/circlet
	name = "onyxa circlet"
	result = /obj/item/clothing/head/roguetown/circlet/carvedgem/onyxa
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/comb
	name = "onyxa comb"
	result = /obj/item/carvedgem/onyxa/comb
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/cup
	name = "onyxa cup"
	result = /obj/item/reagent_containers/glass/cup/carved/onyxa
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/duck
	name = "onyxa duck"
	result = /obj/item/carvedgem/onyxa/duck
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/fancycup
	name = "fancy onyxa cup"
	result = /obj/item/reagent_containers/glass/cup/carved/onyxafancy
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/fancyvase
	name = "fancy onyxa vase"
	result = /obj/item/carvedgem/onyxa/fancyvase
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/figurine
	name = "onyxa figurine"
	result = /obj/item/carvedgem/onyxa/figurine
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/fish
	name = "onyxa fish figurine"
	result = /obj/item/carvedgem/onyxa/fish
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/fork
	name = "onyxa fork"
	result = /obj/item/kitchen/fork/carved/onyxa
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/mask
	name = "onyxa mask"
	result = /obj/item/clothing/mask/rogue/facemask/carved/onyxamask
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/obelisk
	name = "onyxa obelisk"
	result = /obj/item/carvedgem/onyxa/obelisk
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/platter
	name = "onyxa platter"
	result = /obj/item/cooking/platter/carved/onyxa
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/ring
	name = "onyxa ring"
	result = /obj/item/clothing/ring/onyxa
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/snake
	name = "onyxa snake statue"
	result = /obj/item/carvedgem/onyxa/snake
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/spider
	name = "onyxa spider statue"
	result = /obj/item/carvedgem/onyxa/spider
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/spoon
	name = "onyxa spoon"
	result = /obj/item/kitchen/spoon/carved/onyxa
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/statue
	name = "onyxa statue"
	result = /obj/item/carvedgem/onyxa/statue
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/tablet
	name = "onyxa tablet"
	result = /obj/item/carvedgem/onyxa/tablet
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/teapot
	name = "onyxa teapot"
	result = /obj/item/reagent_containers/glass/bucket/pot/carved/teapotonyxa
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/urn
	name = "onyxa urn"
	result = /obj/item/carvedgem/onyxa/urn
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/onyxa/vase
	name = "onyxa vase"
	result = /obj/item/carvedgem/onyxa/vase
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/amulet
	name = "opal amulet"
	result = /obj/item/clothing/neck/roguetown/carved/opalamulet
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/bowl
	name = "opal bowl"
	result = /obj/item/reagent_containers/glass/bowl/carved/opal
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/bracelet
	name = "opal bracelets"
	result = /obj/item/clothing/wrists/roguetown/gem/opalbracelet
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/bust
	name = "opal bust"
	result = /obj/item/carvedgem/opal/bust
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/cameo
	name = "opal cameo"
	result = /obj/item/carvedgem/opal/cameo
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/circlet
	name = "opal circlet"
	result = /obj/item/clothing/head/roguetown/circlet/carvedgem/opal
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/comb
	name = "opal comb"
	result = /obj/item/carvedgem/opal/comb
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/crab
	name = "opal crab sculpture"
	result = /obj/item/carvedgem/opal/crab
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/cup
	name = "opal cup"
	result = /obj/item/reagent_containers/glass/cup/carved/opal
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/duck
	name = "opal duck"
	result = /obj/item/carvedgem/opal/duck
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/fancycup
	name = "fancy opal cup"
	result = /obj/item/reagent_containers/glass/cup/carved/opalfancy
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/fancyvase
	name = "fancy opal vase"
	result = /obj/item/carvedgem/opal/fancyvase
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/figurine
	name = "opal figurine"
	result = /obj/item/carvedgem/opal/figurine
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/fish
	name = "opal fish figurine"
	result = /obj/item/carvedgem/opal/fish
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/fork
	name = "opal fork"
	result = /obj/item/kitchen/fork/carved/opal
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/knife
	name = "opal knife"
	result = /obj/item/rogueweapon/huntingknife/stoneknife/opalknife
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/mask
	name = "opal mask"
	result = /obj/item/clothing/mask/rogue/facemask/carved/opalmask
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/obelisk
	name = "opal obelisk"
	result = /obj/item/carvedgem/opal/obelisk
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/platter
	name = "opal platter"
	result = /obj/item/cooking/platter/carved/opal
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/ring
	name = "opal ring"
	result = /obj/item/clothing/ring/opal
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/spoon
	name = "opal spoon"
	result = /obj/item/kitchen/spoon/carved/opal
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/statue
	name = "opal statue"
	result = /obj/item/carvedgem/opal/statue
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/tablet
	name = "opal tablet"
	result = /obj/item/carvedgem/opal/tablet
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/teapot
	name = "opal teapot"
	result = /obj/item/reagent_containers/glass/bucket/pot/carved/teapotopal
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/urn
	name = "opal urn"
	result = /obj/item/carvedgem/opal/urn
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/opal/vase
	name = "opal vase"
	result = /obj/item/carvedgem/opal/vase
	reqs = list(/obj/item/roguegem/opal = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/amulet
	name = "rosestone amulet"
	result = /obj/item/clothing/neck/roguetown/carved/roseamulet
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/bowl
	name = "rosestone bowl"
	result = /obj/item/reagent_containers/glass/bowl/carved/rose
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/bracelet
	name = "rosestone bracelets"
	result = /obj/item/clothing/wrists/roguetown/gem/rosebracelet
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/bust
	name = "rosestone bust"
	result = /obj/item/carvedgem/rose/bust
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/cameo
	name = "rosestone cameo"
	result = /obj/item/carvedgem/rose/cameo
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/carp
	name = "rosestone carp statue"
	result = /obj/item/carvedgem/rose/carp
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/circlet
	name = "rosestone circlet"
	result = /obj/item/clothing/head/roguetown/circlet/carvedgem/rose
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/comb
	name = "rosestone comb"
	result = /obj/item/carvedgem/rose/comb
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/cup
	name = "rosestone cup"
	result = /obj/item/reagent_containers/glass/cup/carved/rose
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/duck
	name = "rosestone duck"
	result = /obj/item/carvedgem/rose/duck
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/fancycup
	name = "fancy rosestone cup"
	result = /obj/item/reagent_containers/glass/cup/carved/rosefancy
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/fancyvase
	name = "fancy rosestone vase"
	result = /obj/item/carvedgem/rose/fancyvase
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/figurine
	name = "rosestone figurine"
	result = /obj/item/carvedgem/rose/figurine
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/fish
	name = "rosestone fish figurine"
	result = /obj/item/carvedgem/rose/fish
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/flower
	name = "rosestone flower carving"
	result = /obj/item/carvedgem/rose/flower
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/fork
	name = "rosestone fork"
	result = /obj/item/kitchen/fork/carved/rose
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/mask
	name = "rosestone mask"
	result = /obj/item/clothing/mask/rogue/facemask/carved/rosemask
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/obelisk
	name = "rosestone obelisk"
	result = /obj/item/carvedgem/rose/obelisk
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/platter
	name = "rosestone platter"
	result = /obj/item/cooking/platter/carved/rose
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/ring
	name = "rosestone ring"
	result = /obj/item/clothing/ring/rose
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/spoon
	name = "rosestone spoon"
	result = /obj/item/kitchen/spoon/carved/rose
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/statue
	name = "rosestone statue"
	result = /obj/item/carvedgem/rose/statue
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/tablet
	name = "rosestone tablet"
	result = /obj/item/carvedgem/rose/tablet
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/teapot
	name = "rosestone teapot"
	result = /obj/item/reagent_containers/glass/bucket/pot/carved/teapotrose
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/urn
	name = "rosestone urn"
	result = /obj/item/carvedgem/rose/urn
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/rose/vase
	name = "rosestone vase"
	result = /obj/item/carvedgem/rose/vase
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/amulet
	name = "shell amulet"
	result = /obj/item/clothing/neck/roguetown/carved/shellamulet
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/bowl
	name = "shell bowl"
	result = /obj/item/reagent_containers/glass/bowl/carved/shell
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/bracelet
	name = "shell bracelets"
	result = /obj/item/clothing/wrists/roguetown/gem/shellbracelet
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/bust
	name = "shell bust"
	result = /obj/item/carvedgem/shell/bust
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/cameo
	name = "shell cameo"
	result = /obj/item/carvedgem/shell/cameo
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/circlet
	name = "shell circlet"
	result = /obj/item/clothing/head/roguetown/circlet/carvedgem/shell
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/comb
	name = "shell comb"
	result = /obj/item/carvedgem/shell/comb
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/cup
	name = "shell cup"
	result = /obj/item/reagent_containers/glass/cup/carved/shell
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/duck
	name = "shell duck"
	result = /obj/item/carvedgem/shell/duck
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/fancycup
	name = "fancy shell cup"
	result = /obj/item/reagent_containers/glass/cup/carved/shellfancy
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/fancyvase
	name = "fancy shell vase"
	result = /obj/item/carvedgem/shell/fancyvase
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/figurine
	name = "shell figurine"
	result = /obj/item/carvedgem/shell/figurine
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/fish
	name = "shell fish figurine"
	result = /obj/item/carvedgem/shell/fish
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/fork
	name = "shell fork"
	result = /obj/item/kitchen/fork/carved/shell
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/mask
	name = "shell mask"
	result = /obj/item/clothing/mask/rogue/facemask/carved/shellmask
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/obelisk
	name = "shell obelisk"
	result = /obj/item/carvedgem/shell/obelisk
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/platter
	name = "shell platter"
	result = /obj/item/cooking/platter/carved/shell
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/ring
	name = "shell ring"
	result = /obj/item/clothing/ring/shell
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/rungu
	name = "shell rungu"
	result = /obj/item/rogueweapon/mace/cudgel/shellrungu
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/spoon
	name = "shell spoon"
	result = /obj/item/kitchen/spoon/carved/shell
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/statue
	name = "shell statue"
	result = /obj/item/carvedgem/shell/statue
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/tablet
	name = "shell tablet"
	result = /obj/item/carvedgem/shell/tablet
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/teapot
	name = "shell teapot"
	result = /obj/item/reagent_containers/glass/bucket/pot/carved/teapotshell
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/turtle
	name = "turtle carving"
	result = /obj/item/carvedgem/shell/turtle
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/urn
	name = "shell urn"
	result = /obj/item/carvedgem/shell/urn
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/shell/vase
	name = "shell vase"
	result = /obj/item/carvedgem/shell/vase
	reqs = list(/obj/item/carvedgem/shell/rawshell = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/turq/amulet
	name = "cerulite amulet"
	result = /obj/item/clothing/neck/roguetown/carved/turqamulet
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/turq/bowl
	name = "cerulite bowl"
	result = /obj/item/reagent_containers/glass/bowl/carved/turq
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/turq/bracelet
	name = "cerulite bracelets"
	result = /obj/item/clothing/wrists/roguetown/gem/turqbracelet
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/turq/bust
	name = "cerulite bust"
	result = /obj/item/carvedgem/turq/bust
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/turq/cameo
	name = "cerulite cameo"
	result = /obj/item/carvedgem/turq/cameo
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/turq/circlet
	name = "cerulite circlet"
	result = /obj/item/clothing/head/roguetown/circlet/carvedgem/turq
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/turq/comb
	name = "cerulite comb"
	result = /obj/item/carvedgem/turq/comb
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/turq/cup
	name = "cerulite cup"
	result = /obj/item/reagent_containers/glass/cup/carved/turq
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/turq/duck
	name = "cerulite duck"
	result = /obj/item/carvedgem/turq/duck
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/turq/fancycup
	name = "fancy cerulite cup"
	result = /obj/item/reagent_containers/glass/cup/carved/turqfancy
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/turq/fancyvase
	name = "fancy cerulite vase"
	result = /obj/item/carvedgem/turq/fancyvase
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/turq/figurine
	name = "cerulite figurine"
	result = /obj/item/carvedgem/turq/figurine
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/turq/fish
	name = "cerulite fish figurine"
	result = /obj/item/carvedgem/turq/fish
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/turq/fork
	name = "cerulite fork"
	result = /obj/item/kitchen/fork/carved/turq
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/turq/ka
	name = "cerulite ka statue"
	result = /obj/item/carvedgem/turq/ka
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/turq/mask
	name = "cerulite mask"
	result = /obj/item/clothing/mask/rogue/facemask/carved/turqmask
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/turq/obelisk
	name = "cerulite obelisk"
	result = /obj/item/carvedgem/turq/obelisk
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/turq/platter
	name = "cerulite platter"
	result = /obj/item/cooking/platter/carved/turq
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/turq/ring
	name = "cerulite ring"
	result = /obj/item/clothing/ring/turq
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/turq/scarab
	name = "cerulite scarab"
	result = /obj/item/carvedgem/turq/scarab
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/turq/spoon
	name = "cerulite spoon"
	result = /obj/item/kitchen/spoon/carved/turq
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/turq/statue
	name = "cerulite statue"
	result = /obj/item/carvedgem/turq/statue
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/turq/tablet
	name = "cerulite tablet"
	result = /obj/item/carvedgem/turq/tablet
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/turq/urn
	name = "cerulite urn"
	result = /obj/item/carvedgem/turq/urn
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gemcarving/turq/vase
	name = "cerulite vase"
	result = /obj/item/carvedgem/turq/vase
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/gravemarker
	name = "grave marker"
	result = /obj/structure/gravemarker
	reqs = list(/obj/item/grown/log/tree/stick = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_structure = /obj/structure/closet/crate/wooden/rockhill/dirthole
	rogue_verb = "ties together"
	rogue_verb_simple = "tie together"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/hunting/bait
	name = "bait"
	result = /obj/item/bait
	reqs = list(/obj/item/storage/roguebag = 1, /obj/item/reagent_containers/food/snacks/grown/wheat = 2)
	category = "Hunting"
	rogue_skill = /datum/attribute/skill/misc/hunting
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = 1

/datum/crafting_recipe/roguetown/hunting/bloodbait
	name = "bloodbait"
	result = /obj/item/bait/bloody
	reqs = list(/obj/item/storage/roguebag = 1, /obj/item/reagent_containers/food/snacks/rogue/meat = 2)
	category = "Hunting"
	rogue_skill = /datum/attribute/skill/misc/hunting
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = 1

/datum/crafting_recipe/roguetown/hunting/sbait
	name = "sweetbait (berry)"
	result = /obj/item/bait/sweet
	reqs = list(/obj/item/storage/roguebag = 1, /obj/item/reagent_containers/food/snacks/grown/berries/rogue = 2)
	category = "Hunting"
	rogue_skill = /datum/attribute/skill/misc/hunting
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = 1

/datum/crafting_recipe/roguetown/hunting/sbaita
	name = "sweetbait (apple)"
	result = /obj/item/bait/sweet
	reqs = list(/obj/item/storage/roguebag = 1, /obj/item/reagent_containers/food/snacks/grown/apple = 2)
	category = "Hunting"
	rogue_skill = /datum/attribute/skill/misc/hunting
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = 1

/datum/crafting_recipe/roguetown/ironore
	name = "iron ore"
	result = /obj/item/rogueore/iron
	reqs = list(/obj/item/alch/irondust = 3)
	category = "Smelting"
	rogue_skill = /datum/attribute/skill/craft/smelting
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/ironore/advanced
	name = "iron ore (advanced)"
	result = /obj/item/rogueore/iron
	reqs = list(/obj/item/alch/irondust = 2)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Smelting"
	rogue_skill = /datum/attribute/skill/craft/smelting
	rogue_difficulty = 4
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/leather/apron/blacksmith
	name = "leather apron"
	result = /obj/item/clothing/cloak/apron/blacksmith
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/armor/armor
	name = "leather armor"
	result = /obj/item/clothing/suit/roguetown/armor/leather
	reqs = list(/obj/item/natural/hide/cured = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/armor/bracers
	name = "leather bracers"
	result = /obj/item/clothing/wrists/roguetown/bracers/leather
	reqs = list(/obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/armor/cuirass
	name = "leather cuirass"
	result = /obj/item/clothing/suit/roguetown/armor/leather/cuirass
	reqs = list(/obj/item/natural/hide/cured = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/armor/duelcoat
	name = "leather coat"
	result = /obj/item/clothing/armor/leather/jacket/leathercoat/duelcoat
	reqs = list(/obj/item/natural/hide/cured = 4, /obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/armor/explorer_helmet
	name = "explorer's hat"
	result = /obj/item/clothing/head/roguetown/explorer
	reqs = list(/obj/item/natural/hide/cured = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/armor/explorer_pants
	name = "explorer's trousers"
	result = /obj/item/clothing/under/roguetown/trou/leather/explorer
	reqs = list(/obj/item/natural/hide/cured = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/armor/explorer_vest
	name = "explorer's vest"
	result = /obj/item/clothing/suit/roguetown/armor/gambeson/explorer
	reqs = list(/obj/item/natural/hide/cured = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/armor/freivest
	name = "fencing jacket"
	result = /obj/item/clothing/suit/roguetown/armor/leather/heavy/freifechter
	reqs = list(/obj/item/natural/hide/cured = 4, /obj/item/reagent_containers/food/snacks/tallow = 2, /obj/item/natural/fibers = 4)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_armor
	name = "hardened leather armor"
	result = /obj/item/clothing/suit/roguetown/armor/leather/heavy
	reqs = list(/obj/item/natural/hide/cured = 3, /obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_armor/coat
	name = "hardened leather coat"
	result = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	reqs = list(/obj/item/natural/hide/cured = 4, /obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/natural/fibers = 1)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_armor/jacket
	name = "hardened leather jacket"
	result = /obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket
	reqs = list(/obj/item/natural/hide/cured = 3, /obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/natural/fibers = 1)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/tanningrack
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_pants
	name = "hardened leather pants"
	result = /obj/item/clothing/under/roguetown/heavy_leather_pants
	reqs = list(/obj/item/natural/hide/cured = 3, /obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_pants/shorts
	name = "hardened leather shorts"
	result = /obj/item/clothing/under/roguetown/heavy_leather_pants/shorts
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/natural/fibers = 1)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/tanningrack
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/leather/armor/heavybracers
	name = "hardened leather bracers"
	result = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/armor/helmet
	name = "leather helmet"
	result = /obj/item/clothing/head/roguetown/helmet/leather
	reqs = list(/obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/armor/helmet/advanced
	name = "hardened leather helmet"
	result = /obj/item/clothing/head/roguetown/helmet/leather/advanced
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1, /obj/item/reagent_containers/food/snacks/tallow = 1)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/tanningrack
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/leather/armor/hidearmor
	name = "hide armor"
	result = /obj/item/clothing/suit/roguetown/armor/leather/hide
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fur = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/armor/lgorget
	name = "hardened leather gorget"
	result = /obj/item/clothing/neck/roguetown/leather
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/armor/pants
	name = "leather pants"
	result = /obj/item/clothing/under/roguetown/trou/leather
	reqs = list(/obj/item/natural/hide/cured = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/armor/saigahelm
	name = "saiga skull helm"
	result = /obj/item/clothing/head/roguetown/helmet/leather/saiga
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/hide = 2, /obj/item/natural/head/saiga = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/armor/volfhelm
	name = "volf helm"
	result = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fur/wolf = 1, /obj/item/natural/head/volf = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/armor/volfmantle
	name = "volf mantle"
	result = /obj/item/clothing/cloak/volfmantle
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/head/volf = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/bandana
	name = "leather bandana"
	result = /obj/item/clothing/head/roguetown/helmet/bandana
	reqs = list(/obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 0
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/bearcloak
	name = "direbear cloak"
	result = /obj/item/clothing/cloak/darkcloak/bear
	reqs = list(/obj/item/natural/fur/direbear = 1, /obj/item/natural/hide/cured = 4)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/bedroll
	name = "bedroll"
	result = /obj/item/bedroll
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/rope = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/belt_rogue_leather_belthooks
	name = "belt hooks"
	result = /obj/item/storage/belt/rogue/leather/belthooks
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/belt_rogue_leather_hammerhold_sash
	name = "hammerhold sash"
	result = /obj/item/storage/belt/rogue/leather/hammerhold_sash
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/belt_rogue_leather_iron
	name = "iron belt"
	result = /obj/item/storage/belt/rogue/leather/iron
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/bikini
	name = "leather corslet"
	result = /obj/item/clothing/suit/roguetown/armor/leather/bikini
	reqs = list(/obj/item/natural/hide/cured = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/cloak
	name = "rain cloak"
	result = /obj/item/clothing/cloak/raincloak/brown
	reqs = list(/obj/item/natural/hide/cured = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/cloak_bandolier
	name = "bandolier"
	result = /obj/item/clothing/cloak/bandolier
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/rope = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/cloak_bandolier_inq
	name = "inquisitorial bandolier"
	result = /obj/item/clothing/cloak/bandolier/inq
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/cloakfur
	name = "fur cloak"
	result = /obj/item/clothing/cloak/raincloak/furcloak/crafted
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fur = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/container/backpack
	name = "backpack"
	result = /obj/item/storage/backpack/rogue/backpack
	reqs = list(/obj/item/natural/hide/cured = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/container/backpack_rogue_backpack_trader
	name = "trader's pack"
	result = /obj/item/storage/backpack/rogue/backpack/trader
	reqs = list(/obj/item/natural/hide/cured = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/container/belt
	name = "leather belt"
	result = /obj/item/storage/belt/rogue/leather
	reqs = list(/obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/container/belt/black
	name = "black leather belt"
	result = /obj/item/storage/belt/rogue/leather/black
	reqs = list(/obj/item/natural/hide/cured = 1)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 1
	rogue_structure = /obj/machinery/tanningrack
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/leather/container/belt/double
	name = "paired belts"
	result = /obj/item/storage/belt/rogue/leather/double
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/fibers = 2)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 1
	rogue_structure = /obj/machinery/tanningrack
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/leather/container/belt/knifebelt
	name = "tossblade belt"
	result = /obj/item/storage/belt/rogue/leather/knifebelt
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/fibers = 2)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 1
	rogue_structure = /obj/machinery/tanningrack
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/leather/container/belt/surgicalbag
	name = "surgeon's bag"
	result = /obj/item/storage/belt/rogue/surgery_bag/empty
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/fibers = 1)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/tanningrack
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/leather/container/belt/suspenders
	name = "suspenders"
	result = /obj/item/storage/belt/rogue/leather/suspenders/butler
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/leather/container/belt/suspenders_colored
	name = "suspenders (colorable)"
	result = /obj/item/storage/belt/rogue/leather/suspenders/butler/colored
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/leather/container/bmbstrap
	name = "bombdolier"
	result = /obj/item/bmbstrap
	reqs = list(/obj/item/natural/hide/cured = 5, /obj/item/rope = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/container/gwstrap
	name = "greatweapon strap"
	result = /obj/item/rogueweapon/scabbard/gwstrap
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/rope = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/container/hurlstrap
	name = "hurlbat bandolier"
	result = /obj/item/hurlstrap
	reqs = list(/obj/item/natural/hide/cured = 3, /obj/item/rope = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/container/javelinbag
	name = "javelin bag"
	result = /obj/item/quiver/javelin
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/rope = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/container/magepouch
	name = "summoner's pouch"
	result = /obj/item/storage/magebag
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/container/meatbag
	name = "game satchel"
	result = /obj/item/storage/meatbag
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/container/pouch
	name = "pouch x2"
	result = /obj/item/storage/belt/rogue/pouch
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	rogue_results = list(/obj/item/storage/belt/rogue/pouch)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 0
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/container/quiver
	name = "quiver"
	result = /obj/item/quiver
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/container/satchel
	name = "satchel"
	result = /obj/item/storage/backpack/rogue/satchel
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/container/satchelshort
	name = "short satchel"
	result = /obj/item/storage/backpack/rogue/satchel/short
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/container/scabbard/dagger
	name = "dagger sheath"
	result = /obj/item/rogueweapon/scabbard/sheath
	reqs = list(/obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/container/scabbard/sword
	name = "sword scabbard"
	result = /obj/item/rogueweapon/scabbard/sword
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/container/twstrap
	name = "knife bandolier"
	result = /obj/item/twstrap
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/rope = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/container/waterskin
	name = "waterskin"
	result = /obj/item/reagent_containers/glass/bottle/waterskin
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/corset
	name = "corset"
	result = /obj/item/clothing/suit/roguetown/armor/corset
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/corset_colored
	name = "colorable corset"
	result = /obj/item/clothing/suit/roguetown/armor/corset/colored
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/darkcloak
	name = "dark cloak"
	result = /obj/item/clothing/cloak/darkcloak
	reqs = list(/obj/item/natural/fur = 2, /obj/item/natural/hide/cured = 4)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/doctormask
	name = "plague mask"
	result = /obj/item/clothing/mask/rogue/physician
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/bone = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/doublepeltbedsheet
	name = "bedsheet, double pelt"
	result = /obj/item/bedsheet/rogue/double_pelt
	reqs = list(/obj/item/natural/fibers = 1, /obj/item/natural/fur = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/druid
	name = "druid armor"
	result = /obj/item/clothing/suit/roguetown/armor/leather/druid
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/hide/cured = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/drum
	name = "Drum"
	result = /obj/item/rogue/instrument/drum
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/grown/log/tree/small = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/fingerless_leather_gloves
	name = "fingerless leather gloves"
	result = /obj/item/clothing/gloves/roguetown/fingerless_leather
	reqs = list(/obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/footwear/boots
	name = "leather boots"
	result = /obj/item/clothing/shoes/roguetown/boots/leather
	reqs = list(/obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/footwear/boots/dark
	name = "dark boots"
	result = /obj/item/clothing/shoes/roguetown/boots
	reqs = list(/obj/item/natural/hide/cured = 1)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/leather/footwear/boots/furlinedboots
	name = "fur-lined boots"
	result = /obj/item/clothing/shoes/roguetown/boots/furlinedboots
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fur = 1)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/leather/footwear/boots/heels
	name = "black heels"
	result = /obj/item/clothing/shoes/roguetown/heels
	reqs = list(/obj/item/natural/hide/cured = 1)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/leather/footwear/boots/heels_color
	name = "colorable heels"
	result = /obj/item/clothing/shoes/roguetown/heels/color
	reqs = list(/obj/item/natural/hide/cured = 1)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/leather/footwear/boots/noble
	name = "noble boots"
	result = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	reqs = list(/obj/item/natural/hide/cured = 3, /obj/item/natural/fur = 1)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/tanningrack
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/leather/footwear/boots/short
	name = "shortboots"
	result = /obj/item/clothing/shoes/roguetown/shortboots
	reqs = list(/obj/item/natural/hide/cured = 1)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 1
	rogue_structure = /obj/machinery/tanningrack
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/leather/footwear/boots/thigh
	name = "thigh boots"
	result = /obj/item/clothing/shoes/roguetown/boots/hand/thigh
	reqs = list(/obj/item/natural/hide/cured = 3, /obj/item/natural/cloth = 1)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/tanningrack
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/leather/footwear/boots_heavy
	name = "heavy leather boots"
	result = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fur = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/footwear/boots_heavy_b
	name = "dress boots"
	result = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fur = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/footwear/boots_heavy_footwrap
	name = "hardened leather footwraps"
	result = /obj/item/clothing/shoes/roguetown/boots/footwraps/hleather
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fur = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/footwear/shoes
	name = "shoes"
	result = /obj/item/clothing/shoes/roguetown/simpleshoes
	reqs = list(/obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/footwear/toga_sandals
	name = "fancy sandals"
	result = /obj/item/clothing/shoes/roguetown/sandals/toga_sandals
	reqs = list(/obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/gloves
	name = "leather gloves"
	result = /obj/item/clothing/gloves/roguetown/leather
	reqs = list(/obj/item/natural/hide/cured = 1)
	rogue_results = list(/obj/item/clothing/gloves/roguetown/leather)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_fingerless_shadowgloves_spymaster
	name = "hand's gloves"
	result = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/spymaster
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa
	name = "ivory gloves"
	result = /obj/item/clothing/gloves/roguetown/rosa
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa_eight
	name = "courtly gloves"
	result = /obj/item/clothing/gloves/roguetown/rosa/eight
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa_five
	name = "sable gloves"
	result = /obj/item/clothing/gloves/roguetown/rosa/five
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa_four
	name = "obsidian gloves"
	result = /obj/item/clothing/gloves/roguetown/rosa/four
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa_nine
	name = "royal gloves"
	result = /obj/item/clothing/gloves/roguetown/rosa/nine
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa_seven
	name = "regal gloves"
	result = /obj/item/clothing/gloves/roguetown/rosa/seven
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa_six
	name = "maroon gloves"
	result = /obj/item/clothing/gloves/roguetown/rosa/six
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa_ten
	name = "stately gloves"
	result = /obj/item/clothing/gloves/roguetown/rosa/ten
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa_three
	name = "silvered gloves"
	result = /obj/item/clothing/gloves/roguetown/rosa/three
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/head_roguetown_headband_fur
	name = "fur headband"
	result = /obj/item/clothing/head/roguetown/headband/fur
	reqs = list(/obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/heavygloves
	name = "heavy leather gloves"
	result = /obj/item/clothing/gloves/roguetown/angle
	reqs = list(/obj/item/natural/hide/cured = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/hidebikini
	name = "hide corslet"
	result = /obj/item/clothing/suit/roguetown/armor/leather/hide/bikini
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/fur = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/hood
	name = "leather hood"
	result = /obj/item/clothing/head/roguetown/roguehood
	reqs = list(/obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/leathermask
	name = "leather mask"
	result = /obj/item/clothing/mask/rogue/facemask/leather
	reqs = list(/obj/item/natural/hide/cured = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/leathertights
	name = "leather tights"
	result = /obj/item/clothing/under/roguetown/trou/leathertights
	reqs = list(/obj/item/natural/hide/cured = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/lightbearcloak
	name = "light direbear cloak"
	result = /obj/item/clothing/cloak/darkcloak/bear/light
	reqs = list(/obj/item/natural/fur/direbear = 1, /obj/item/natural/hide/cured = 4)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/neck/catbell_collar
	name = "catbell collar"
	result = /obj/item/clothing/neck/roguetown/collar/catbell
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/catbell = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/neck/cowbell_collar
	name = "cowbell collar"
	result = /obj/item/clothing/neck/roguetown/collar/cowbell
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/catbell/cow = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/neck/leather_collar
	name = "leather collar"
	result = /obj/item/clothing/neck/roguetown/collar/leather
	reqs = list(/obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/neck/leather_leash
	name = "leather leash"
	result = /obj/item/leash/leather
	reqs = list(/obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/papakha
	name = "papakha hat"
	result = /obj/item/clothing/head/roguetown/papakha/crafted
	reqs = list(/obj/item/natural/fur = 1, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/peltbedsheet
	name = "bedsheet, pelt"
	result = /obj/item/bedsheet/rogue/pelt
	reqs = list(/obj/item/natural/fibers = 1, /obj/item/natural/fur = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/reinforcement/crafteast
	name = "decorated dopo robe"
	result = /obj/item/clothing/suit/roguetown/armor/basiceast/crafteast
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/natural/fibers = 2, /obj/item/clothing/suit/roguetown/armor/basiceast = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/saddle
	name = "saddle"
	result = /obj/item/natural/saddle
	reqs = list(/obj/item/natural/hide/cured = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_boots_hammerhold_boots
	name = "hammerhold boots"
	result = /obj/item/clothing/shoes/roguetown/boots/hammerhold_boots
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_courtphysician
	name = "sanguine shoes"
	result = /obj/item/clothing/shoes/roguetown/courtphysician
	reqs = list(/obj/item/natural/hide/cured = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_courtphysician_female
	name = "sanguine heels"
	result = /obj/item/clothing/shoes/roguetown/courtphysician/female
	reqs = list(/obj/item/natural/hide/cured = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_hammerhold_shoes
	name = "hammerhold shoes"
	result = /obj/item/clothing/shoes/roguetown/hammerhold_shoes
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_rosa
	name = "ivory shoes"
	result = /obj/item/clothing/shoes/roguetown/rosa
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_rosa_eight
	name = "courtly shoes"
	result = /obj/item/clothing/shoes/roguetown/rosa/eight
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_rosa_five
	name = "sable shoes"
	result = /obj/item/clothing/shoes/roguetown/rosa/five
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_rosa_four
	name = "obsidian shoes"
	result = /obj/item/clothing/shoes/roguetown/rosa/four
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_rosa_nine
	name = "royal shoes"
	result = /obj/item/clothing/shoes/roguetown/rosa/nine
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_rosa_seven
	name = "regal shoes"
	result = /obj/item/clothing/shoes/roguetown/rosa/seven
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_rosa_ten
	name = "stately shoes"
	result = /obj/item/clothing/shoes/roguetown/rosa/ten
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_rosa_three
	name = "silvered shoes"
	result = /obj/item/clothing/shoes/roguetown/rosa/three
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/skillbook
	name = "unfinished skillbook"
	result = /obj/item/skillbook/unfinished
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/paper/parchment = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/sophisticated_coat
	name = "sophisticated coat"
	result = /obj/item/clothing/armor/gambeson/sophisticated_coat
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fur = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/studhood
	name = "leather padded hood"
	result = /obj/item/clothing/head/roguetown/helmet/leather/armorhood
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/suit_roguetown_shirt_tunic_rosacoat
	name = "regal coat"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/rosacoat
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/silk = 2, /obj/item/alch/rosa = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/suit_roguetown_shirt_tunic_rosacoat_four
	name = "stately coat"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/rosacoat/four
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/silk = 2, /obj/item/alch/rosa = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/suit_roguetown_shirt_tunic_rosacoat_two
	name = "courtly coat"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/rosacoat/two
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/silk = 2, /obj/item/alch/rosa = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/tricorn
	name = "leather tricorn"
	result = /obj/item/clothing/head/roguetown/helmet/tricorn
	reqs = list(/obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/unique/artipants
	name = "tinker trousers"
	result = /obj/item/clothing/under/roguetown/trou/artipants
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/hide/cured = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/unique/baggyleatherpants
	name = "pontifex's chaqchur"
	result = /obj/item/clothing/under/roguetown/trou/leather/pontifex
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1, /obj/item/natural/hide/cured = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/unique/buckleshoes
	name = "buckled shoes"
	result = /obj/item/clothing/shoes/roguetown/simpleshoes/buckle
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 6
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/unique/crafteast
	name = "decorated dopo robe"
	result = /obj/item/clothing/suit/roguetown/armor/basiceast/crafteast
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/natural/fibers = 2, /obj/item/clothing/suit/roguetown/armor/basiceast = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/unique/fencingbreeches
	name = "fencing breeches"
	result = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic
	reqs = list(/obj/item/natural/fibers = 1, /obj/item/natural/hide/cured = 2, /obj/item/natural/cloth = 4)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 6
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/unique/furlinedjacket
	name = "artificer jacket"
	result = /obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/fur = 1, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/unique/grenzelboots
	name = "grenzelhoftian boots"
	result = /obj/item/clothing/shoes/roguetown/boots/grenzelhoft
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/natural/fur = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 6
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/unique/monkleather
	name = "pontifex's kaftan"
	result = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/pontifex
	reqs = list(/obj/item/natural/hide/cured = 4, /obj/item/natural/cloth = 1, /obj/item/reagent_containers/food/snacks/tallow = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/unique/monkrobes
	name = "holy monk vestments"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/monk/holy
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 6
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/unique/openrobes
	name = "shamanic coat"
	result = /obj/item/clothing/suit/roguetown/armor/leather/heavy/atgervi
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/fibers = 1, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/unique/otavanboots
	name = "otavan leather boots"
	result = /obj/item/clothing/shoes/roguetown/boots/otavan
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/natural/fur = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 6
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/unique/otavanleatherpants
	name = "otavan leather trousers"
	result = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/natural/fibers = 1, /obj/item/natural/hide/cured = 2, /obj/item/natural/fur = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 6
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/unique/winterjacket
	name = "winter jacket"
	result = /obj/item/clothing/suit/roguetown/armor/leather/vest/winterjacket
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/fur = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/unleatherbelt
	name = "untie leather belt"
	result = /obj/item/natural/hide/cured
	reqs = list(/obj/item/storage/belt/rogue/leather = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 0
	rogue_structure = /obj/machinery/tanningrack
	rogue_verb = "unties"
	rogue_verb_simple = "untie"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/vest
	name = "leather vest"
	result = /obj/item/clothing/suit/roguetown/armor/leather/vest
	reqs = list(/obj/item/natural/hide/cured = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/vest/sailor
	name = "leather sea jacket"
	result = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
	reqs = list(/obj/item/natural/hide/cured = 2)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 1
	rogue_structure = /obj/machinery/tanningrack
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/leather/whip
	name = "leather whip"
	result = /obj/item/rogueweapon/whip
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/stone = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leather/winter_coat
	name = "warm winter coat"
	result = /obj/item/clothing/suit/roguetown/armor/gambeson/winter_coat
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fur = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/leatherunique/gladsandals
	name = "gladiator sandals"
	result = /obj/item/clothing/shoes/roguetown/gladiator
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/quicksand
	name = "quicksand pit"
	result = /obj/structure/quicksand
	reqs = list(/datum/reagent/water = 240)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "mixes together"
	rogue_verb_simple = "mixes together"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/roguebin
	name = "wooden bin"
	result = /obj/item/roguebin
	reqs = list(/obj/item/grown/log/tree/small = 2)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0
	rogue_verb = "makes"
	rogue_verb_simple = "make"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/Leyepatch
	name = "left eye patch"
	result = /obj/item/clothing/mask/rogue/eyepatch/left
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/Reyepatch
	name = "right eye patch"
	result = /obj/item/clothing/mask/rogue/eyepatch
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/abyssor
	name = "tabard, abyssor"
	result = /obj/item/clothing/cloak/templar/abyssor
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/abyssortemplartabard
	name = "tabard, abyssorite templar"
	result = /obj/item/clothing/cloak/abyssortabard
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/allwrappings
	name = "cloth wrappings"
	result = /obj/item/clothing/wrists/roguetown/allwrappings
	reqs = list(/obj/item/natural/cloth = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/anklets
	name = "exotic silk anklets"
	result = /obj/item/clothing/shoes/roguetown/anklets
	reqs = list(/obj/item/natural/silk = 5)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 6
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/apothpants
	name = "apothecary trousers"
	result = /obj/item/clothing/under/roguetown/trou/apothecary
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/apothshirt
	name = "apothecary shirt"
	result = /obj/item/clothing/suit/roguetown/shirt/apothshirt
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/apron/blacksmith
	name = "leather apron"
	result = /obj/item/clothing/cloak/apron/blacksmith
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/apron_waist
	name = "apron"
	result = /obj/item/clothing/cloak/apron/waist
	reqs = list(/obj/item/natural/cloth = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/archer
	name = "archer cap"
	result = /obj/item/clothing/head/roguetown/archercap
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/archivist
	name = "scholar's robes"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/archivist
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/armingjacket
	name = "arming jacket"
	result = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/armordress
	name = "padded dress"
	result = /obj/item/clothing/suit/roguetown/armor/armordress
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/articap
	name = "artificer's cap"
	result = /obj/item/clothing/head/roguetown/articap
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1, /obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/artificer
	name = "tinker doublet"
	result = /obj/item/clothing/suit/roguetown/shirt/undershirt/artificer
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2, /obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/astrata
	name = "tabard, astrata"
	result = /obj/item/clothing/cloak/templar/astrata
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/athletic_leotard
	name = "athletic leotard (1 fibers, 1 silk)"
	result = /obj/item/undies/athletic_leotard
	reqs = list(/obj/item/natural/silk = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/bandage
	name = "bandages (sewing)"
	result = /obj/item/natural/cloth/bandage
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/bandithood
	name = "free man's shroud"
	result = /obj/item/clothing/head/roguetown/menacing/bandit
	reqs = list(/obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/bardhat
	name = "bard hat"
	result = /obj/item/clothing/head/roguetown/bardhat
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/barding
	name = "padded barding (saiga)"
	result = /obj/item/clothing/barding
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/barding/fogbeast
	name = "padded barding (fogbeast)"
	result = /obj/item/clothing/barding/fogbeast
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 1)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/sewing/bardress
	name = "bar dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/basiceast
	name = "simple dopo robe"
	result = /obj/item/clothing/suit/roguetown/armor/basiceast
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/basichood
	name = "hood"
	result = /obj/item/clothing/head/roguetown/roguehood
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/battleskirt
	name = "cloth military skirt"
	result = /obj/item/storage/belt/rogue/leather/battleskirt
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/beekeeper
	name = "beekeeper's hood"
	result = /obj/item/clothing/head/roguetown/beekeeper
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 4)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/belt_rogue_leather_battleskirt_loincloth
	name = "cloth loincloth"
	result = /obj/item/storage/belt/rogue/leather/battleskirt/loincloth
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/belt_rogue_leather_beltshawl
	name = "belt shawl"
	result = /obj/item/storage/belt/rogue/leather/beltshawl
	reqs = list(/obj/item/natural/cloth = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/belt_rogue_leather_sash_maid
	name = "cloth sash"
	result = /obj/item/storage/belt/rogue/leather/sash/maid
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/bikini
	name = "bikini (1 fibers, 2 cloth)"
	result = /obj/item/undies/bikini
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/bisht
	name = "bisht"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/beige
	reqs = list(/obj/item/natural/cloth = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/bisht/fancy
	name = "fine bisht"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/bluegrey
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 1)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/sewing/blouse
	name = "blouse"
	result = /obj/item/clothing/suit/roguetown/shirt/undershirt/blouse
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/bragreen
	name = "exotic silk bra(green)"
	result = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/green
	reqs = list(/obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/braies
	name = "braies (1 cloth)"
	result = /obj/item/undies/braies
	reqs = list(/obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/brared
	name = "exotic silk bra (red)"
	result = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/red
	reqs = list(/obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/breechclothbelt
	name = "belt with breechcloth"
	result = /obj/item/storage/belt/rogue/leather/battleskirt/breechcloth
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/breechclothbeltalt
	name = "belt with breechcloth, black"
	result = /obj/item/storage/belt/rogue/leather/battleskirt/breechcloth/blackbelt
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/breechclothbeltaltimprovised
	name = "belt with breechcloth, black, improvised"
	result = /obj/item/storage/belt/rogue/leather/battleskirt/breechcloth/blackbelt
	reqs = list(/obj/item/clothing/cloak/tabard = 1, /obj/item/storage/belt/rogue/leather/black = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/breechclothbeltimprovised
	name = "belt with breechcloth, improvised"
	result = /obj/item/storage/belt/rogue/leather/battleskirt/breechcloth
	reqs = list(/obj/item/clothing/cloak/tabard = 1, /obj/item/storage/belt/rogue/leather = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/brimmed
	name = "brimmed hat"
	result = /obj/item/clothing/head/roguetown/brimmed
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/brownloincloth
	name = "brown loincloth"
	result = /obj/item/clothing/under/roguetown/loincloth/brown
	reqs = list(/obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/bucklehat
	name = "folded hat"
	result = /obj/item/clothing/head/roguetown/bucklehat
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/burial_shroud
	name = "winding sheet"
	result = /obj/item/burial_shroud
	reqs = list(/obj/item/natural/cloth = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/buttonedlongcoat
	name = "plague coat"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/physician
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/caparison
	name = "caparison"
	result = /obj/item/caparison
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/caparison/astrata
	name = "astratan caparison"
	result = /obj/item/caparison/astrata
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 2)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/sewing/caparison/eora
	name = "eoran caparison"
	result = /obj/item/caparison/eora
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 2)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/sewing/caparison/fogbeast
	name = "fogbeast caparison"
	result = /obj/item/caparison/fogbeast
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 2)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/sewing/caparison/psy
	name = "psydonite caparison"
	result = /obj/item/caparison/psy
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 2)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/sewing/cape
	name = "cape"
	result = /obj/item/clothing/cloak/cape
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cape/desert
	name = "desert cape"
	result = /obj/item/clothing/cloak/cape/crusader
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 2)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/sewing/cape/half
	name = "half cloak"
	result = /obj/item/clothing/cloak/half
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/fibers = 1)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/sewing/cape/rider
	name = "rider cloak"
	result = /obj/item/clothing/cloak/half/rider
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/sewing/chaperon
	name = "chaperon hat"
	result = /obj/item/clothing/head/roguetown/chaperon
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/chaperon/noble
	name = "noble's chaperon"
	result = /obj/item/clothing/head/roguetown/chaperon/noble
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 2)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/sewing/cloak_absolutionistrobe_black
	name = "blessed robe"
	result = /obj/item/clothing/cloak/absolutionistrobe/black
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_apron_waist_maid
	name = "maid apron"
	result = /obj/item/clothing/cloak/apron/waist/maid
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_bishop
	name = "bishop cape"
	result = /obj/item/clothing/cloak/bishop
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_cape_inquisitorgold
	name = "golden order cloak"
	result = /obj/item/clothing/cloak/cape/inquisitorgold
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_cape_inquisitorsilver
	name = "silver order cloak"
	result = /obj/item/clothing/cloak/cape/inquisitorsilver
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_desert
	name = "desert cloak"
	result = /obj/item/clothing/cloak/desert
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_elven
	name = "elven cloak"
	result = /obj/item/clothing/cloak/elven
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_elven_short
	name = "elven shortcloak"
	result = /obj/item/clothing/cloak/elven/short
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_etrcape
	name = "wanderer's cape"
	result = /obj/item/clothing/cloak/etrcape
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_half_duelcape
	name = "duelist cape"
	result = /obj/item/clothing/cloak/half/duelcape
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_half_shadowcloak_spymaster
	name = "hand's cloak"
	result = /obj/item/clothing/cloak/half/shadowcloak/spymaster
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_poncho_fancycoat
	name = "fancy coat"
	result = /obj/item/clothing/cloak/poncho/fancycoat
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_poncho_fancycoat_trimmed
	name = "trimmed fancy coat"
	result = /obj/item/clothing/cloak/poncho/fancycoat/trimmed
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_rangercloak
	name = "ranger cloak"
	result = /obj/item/clothing/cloak/rangercloak
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_sash
	name = "sash"
	result = /obj/item/clothing/cloak/sash
	reqs = list(/obj/item/natural/cloth = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_sash_dupatta
	name = "dupatta"
	result = /obj/item/clothing/cloak/sash/dupatta
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_scaledcloak
	name = "scaled cloak"
	result = /obj/item/clothing/cloak/scaledcloak
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_scarf
	name = "scarf"
	result = /obj/item/clothing/cloak/scarf
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_scout
	name = "scout cloak"
	result = /obj/item/clothing/cloak/scout
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_sheriff
	name = "sheriff's cloak"
	result = /obj/item/clothing/cloak/sheriff
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_sleevedtabard
	name = "sleeved tabard"
	result = /obj/item/clothing/cloak/sleevedtabard
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_psydontabard_black
	name = "blessed tabard"
	result = /obj/item/clothing/cloak/tabard/psydontabard/black
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_psydontabard_white
	name = "traditional tabard"
	result = /obj/item/clothing/cloak/tabard/psydontabard/white
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_psydontabard_white_alt
	name = "opened traditional tabard"
	result = /obj/item/clothing/cloak/tabard/psydontabard/white/alt
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_stabard_crusader
	name = "surcoat of the golden order"
	result = /obj/item/clothing/cloak/tabard/stabard/crusader
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_stabard_crusader_astrata
	name = "surcoat of the golden order (astrata)"
	result = /obj/item/clothing/cloak/tabard/stabard/crusader/astrata
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_stabard_crusader_bsteel
	name = "surcoat of the blacksteel order"
	result = /obj/item/clothing/cloak/tabard/stabard/crusader/bsteel
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_stabard_crusader_heavy
	name = "overvestments"
	result = /obj/item/clothing/cloak/tabard/stabard/crusader/heavy
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_stabard_crusader_see
	name = "surcoat of the golden order (see)"
	result = /obj/item/clothing/cloak/tabard/stabard/crusader/see
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_stabard_crusader_t
	name = "surcoat of the silver order"
	result = /obj/item/clothing/cloak/tabard/stabard/crusader/t
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_stabard_crusader_t_astrata
	name = "surcoat of the silver order (astrata)"
	result = /obj/item/clothing/cloak/tabard/stabard/crusader/t/astrata
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_stabard_crusader_t_see
	name = "surcoat of the silver order (see)"
	result = /obj/item/clothing/cloak/tabard/stabard/crusader/t/see
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_stabard_surcoat_short
	name = "short jupon"
	result = /obj/item/clothing/cloak/tabard/stabard/surcoat/short
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_toga
	name = "toga"
	result = /obj/item/clothing/cloak/tabard/toga
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_toga_alt
	name = "bared toga"
	result = /obj/item/clothing/cloak/tabard/toga/alt
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_toga_dress
	name = "toga (dress)"
	result = /obj/item/clothing/cloak/tabard/toga/dress
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_tabard_toga_dress_alt
	name = "bared toga (alt)"
	result = /obj/item/clothing/cloak/tabard/toga/dress/alt
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_templar_astratancleric
	name = "astratan cloak"
	result = /obj/item/clothing/cloak/templar/astratancleric
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_templar_astratancleric_grey
	name = "frayed cloak"
	result = /obj/item/clothing/cloak/templar/astratancleric/grey
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_templar_eoran_alt
	name = "eoran tabard"
	result = /obj/item/clothing/cloak/templar/eoran/alt
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_templar_necrancleric
	name = "necran cloak"
	result = /obj/item/clothing/cloak/templar/necrancleric
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_templar_ravoxcleric
	name = "justice cloak"
	result = /obj/item/clothing/cloak/templar/ravoxcleric
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_templar_see_alt
	name = "see templar tabard"
	result = /obj/item/clothing/cloak/templar/see_alt
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cloak_templar_seecleric
	name = "see devotee tabard"
	result = /obj/item/clothing/cloak/templar/seecleric
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/clothbedsheet
	name = "bedsheet, cloth"
	result = /obj/item/bedsheet/rogue/cloth
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/clothblindfold
	name = "blindfold"
	result = /obj/item/clothing/mask/rogue/blindfold
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/clothgloves
	name = "fingerless gloves"
	result = /obj/item/clothing/gloves/roguetown/fingerless
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/clothpaddedfootwraps
	name = "padded footwraps"
	result = /obj/item/clothing/shoes/roguetown/boots/footwraps/padded
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/clothshirt
	name = "shirt"
	result = /obj/item/clothing/suit/roguetown/shirt/undershirt
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/clothtrou
	name = "work trousers"
	result = /obj/item/clothing/under/roguetown/trou
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/coif
	name = "coif"
	result = /obj/item/clothing/neck/roguetown/coif
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/cotehardie
	name = "fitted coat"
	result = /obj/item/clothing/cloak/cotehardie
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/courtesan
	name = "courtesan dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/courtesan
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/decorative_captainrobe
	name = "decorative flowery robe"
	result = /obj/item/clothing/suit/roguetown/armor/basiceast/captainrobe/decorative
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/decorative_mentorsuit
	name = "decorative mentor robe"
	result = /obj/item/clothing/suit/roguetown/armor/basiceast/mentorsuit/decorative
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/dendor
	name = "tabard, dendor"
	result = /obj/item/clothing/cloak/templar/dendor
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/desertgown
	name = "hierophant's kandys"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/hierophant
	reqs = list(/obj/item/natural/cloth = 6, /obj/item/natural/fibers = 4)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/deserts_hood
	name = "desert sorceress hood"
	result = /obj/item/clothing/head/roguetown/desert_sorceress
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/deserts_skirt
	name = "desert sorceress skirt"
	result = /obj/item/clothing/under/roguetown/loincloth/desert_sorceress
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/deserts_top
	name = "desert sorceress top"
	result = /obj/item/clothing/suit/roguetown/shirt/desert_sorceress
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/doublefabricbedsheet
	name = "bedsheet, double fabric"
	result = /obj/item/bedsheet/rogue/fabric_double
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/duelist
	name = "duelist hat"
	result = /obj/item/clothing/head/roguetown/duelhat
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/duelmask
	name = "duelist's mask"
	result = /obj/item/clothing/mask/rogue/duelmask
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/eora
	name = "tabard, eora"
	result = /obj/item/clothing/cloak/templar/eora
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/exoticsilkbelt
	name = "exotic silk belt"
	result = /obj/item/storage/belt/rogue/leather/exoticsilkbelt
	reqs = list(/obj/item/natural/silk = 5)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 6
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/exoticsilkbra
	name = "exotic silk bra"
	result = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra
	reqs = list(/obj/item/natural/silk = 5)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 6
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/exoticsilkmask
	name = "exotic silk mask"
	result = /obj/item/clothing/mask/rogue/exoticsilkmask
	reqs = list(/obj/item/natural/silk = 5)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 6
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/fabricbedsheet
	name = "bedsheet, fabric"
	result = /obj/item/bedsheet/rogue/fabric
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1, /obj/item/natural/silk = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/fancyhat
	name = "fancy hat"
	result = /obj/item/clothing/head/roguetown/fancyhat
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/fancyshirt
	name = "noble shirt"
	result = /obj/item/clothing/suit/roguetown/shirt/noble/hand
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/fauldedbelt
	name = "belt with faulds"
	result = /obj/item/storage/belt/rogue/leather/battleskirt/faulds
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/fineparasol
	name = "fine parasol"
	result = /obj/item/rogueweapon/mace/parasol/noble
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 4, /obj/item/paper/scroll = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/formalshirt
	name = "formal shirt"
	result = /obj/item/clothing/suit/roguetown/shirt/undershirt/formal
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/formaltrousers
	name = "formal trousers"
	result = /obj/item/clothing/under/roguetown/trou/formal
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/furovercoat
	name = "fur overcoat"
	result = /obj/item/clothing/cloak/black_cloak
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1, /obj/item/natural/silk = 1, /obj/item/natural/fur = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/gambeson
	name = "gambeson"
	result = /obj/item/clothing/suit/roguetown/armor/gambeson
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/gbandages
	name = "bandages, gloved"
	result = /obj/item/clothing/gloves/roguetown/bandages
	reqs = list(/obj/item/natural/cloth = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/gerkit
	name = "Ger Kit"
	result = /obj/item/tent_kit/ger
	reqs = list(/obj/item/natural/cloth = 10, /obj/item/natural/fibers = 6, /obj/item/grown/log/tree/stick = 10)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/grenzelblack
	name = "grenzelhoftian hat with blacksteel armet"
	result = /obj/item/clothing/head/roguetown/helmet/blacksteel/modern/armet/grenzelhoft
	reqs = list(/obj/item/clothing/head/roguetown/grenzelhofthat = 1, /obj/item/clothing/head/roguetown/helmet/blacksteel/modern/armet = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/grenzelhat
	name = "grenzelhoftian hat"
	result = /obj/item/clothing/head/roguetown/grenzelhofthat
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/grenzelhelm
	name = "grenzelhoftian hat with steel sallet"
	result = /obj/item/clothing/head/roguetown/helmet/sallet/grenzelhoft
	reqs = list(/obj/item/clothing/head/roguetown/grenzelhofthat = 1, /obj/item/clothing/head/roguetown/helmet/sallet = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/grenzelhelm/off
	name = "take hat off steel sallet"
	result = /obj/item/clothing/head/roguetown/grenzelhofthat
	reqs = list(/obj/item/clothing/head/roguetown/helmet/sallet/grenzelhoft = 1)
	rogue_results = list(/obj/item/clothing/head/roguetown/helmet/sallet)
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/sewing/grenzelklapper
	name = "grenzelhoftian hat with klappvisier"
	result = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan/grenzelhoft
	reqs = list(/obj/item/clothing/head/roguetown/grenzelhofthat = 1, /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/grenzelklapper/off
	name = "take hat off etruscan bascinet"
	result = /obj/item/clothing/head/roguetown/grenzelhofthat
	reqs = list(/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan/grenzelhoft = 1)
	rogue_results = list(/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan)
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/sewing/grenzelpants
	name = "grenzelhoftian paumpers"
	result = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 2, /obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/grenzelshirt
	name = "grenzelhoftian hip-shirt"
	result = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft
	reqs = list(/obj/item/natural/cloth = 6, /obj/item/natural/fibers = 4, /obj/item/natural/silk = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/guildedjacket
	name = "guilder jacket"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/merchant
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/gweightedbandages
	name = "weighted bandages, gloved"
	result = /obj/item/clothing/gloves/roguetown/bandages/weighted
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/gweightedbandagesalt
	name = "bandages into weighted bandages, gloved"
	result = /obj/item/clothing/gloves/roguetown/bandages/weighted
	reqs = list(/obj/item/clothing/gloves/roguetown/bandages = 1, /obj/item/natural/cloth = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/halfrobe
	name = "hierophant's shawl"
	result = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant
	reqs = list(/obj/item/natural/cloth = 6, /obj/item/natural/fibers = 5)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/handcoat
	name = "noble coat"
	result = /obj/item/clothing/suit/roguetown/shirt/coat/hand
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/hatfur
	name = "fur hat"
	result = /obj/item/clothing/head/roguetown/hatfur
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1, /obj/item/natural/fur = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_antlers
	name = "old antlers"
	result = /obj/item/clothing/head/roguetown/antlers
	reqs = list(/obj/item/natural/bone = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_courtphysician
	name = "sanguine hat"
	result = /obj/item/clothing/head/roguetown/courtphysician
	reqs = list(/obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_courtphysician_female
	name = "sanguine cap"
	result = /obj/item/clothing/head/roguetown/courtphysician/female
	reqs = list(/obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_deserthood
	name = "desert hood"
	result = /obj/item/clothing/head/roguetown/deserthood
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_doublehennin
	name = "dual hennin"
	result = /obj/item/clothing/head/roguetown/doublehennin
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_duelhat_etrhat
	name = "wanderer's hat"
	result = /obj/item/clothing/head/roguetown/duelhat/etrhat
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_duelhat_etrusca
	name = "etruscan duelist hat"
	result = /obj/item/clothing/head/roguetown/duelhat/etrusca
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_durag
	name = "durag"
	result = /obj/item/clothing/head/roguetown/durag
	reqs = list(/obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_eaststrawhat
	name = "worn rice hat"
	result = /obj/item/clothing/head/roguetown/eaststrawhat
	reqs = list(/obj/item/natural/fibers = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_elven_hat
	name = "elven burka"
	result = /obj/item/clothing/head/roguetown/elven_hat
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_explorerhat
	name = "explorer's hat"
	result = /obj/item/clothing/head/roguetown/explorerhat
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_flamboyant
	name = "flamboyant hat"
	result = /obj/item/clothing/head/roguetown/flamboyant
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_flotsam
	name = "flotsam bonnet"
	result = /obj/item/clothing/head/roguetown/flotsam
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_gasa
	name = "gasa"
	result = /obj/item/clothing/head/roguetown/gasa
	reqs = list(/obj/item/natural/fibers = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_hammerhold_hat
	name = "kokoshnik"
	result = /obj/item/clothing/head/roguetown/hammerhold_hat
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_hammerhold_hat_peasant
	name = "hammerhold hat"
	result = /obj/item/clothing/head/roguetown/hammerhold_hat/peasant
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_hscarf
	name = "head scarf"
	result = /obj/item/clothing/head/roguetown/hscarf
	reqs = list(/obj/item/natural/silk = 4)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_longveil
	name = "long veil"
	result = /obj/item/clothing/head/roguetown/longveil
	reqs = list(/obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_maidhead
	name = "maid headdress"
	result = /obj/item/clothing/head/roguetown/maidhead
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_menacing_executioner
	name = "executioners hood"
	result = /obj/item/clothing/head/roguetown/menacing/executioner
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_nightcap
	name = "nitecap"
	result = /obj/item/clothing/head/roguetown/nightcap
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_nun_hood
	name = "nun hood"
	result = /obj/item/clothing/head/roguetown/nun_hood
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_onhelm_tw_d_horns
	name = "horns helmkleinod"
	result = /obj/item/clothing/head/roguetown/onhelm/tw_d_horns
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_roguehood_bishop
	name = "bishop hood"
	result = /obj/item/clothing/head/roguetown/roguehood/bishop
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_roguehood_burgerhood
	name = "noble hood"
	result = /obj/item/clothing/head/roguetown/roguehood/burgerhood
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_roningasa
	name = "roningasa"
	result = /obj/item/clothing/head/roguetown/roningasa
	reqs = list(/obj/item/natural/fibers = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_sandogasa
	name = "sandogasa"
	result = /obj/item/clothing/head/roguetown/sandogasa
	reqs = list(/obj/item/natural/fibers = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_stewardtophat
	name = "top hat"
	result = /obj/item/clothing/head/roguetown/stewardtophat
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_tiyon
	name = "tiyon"
	result = /obj/item/clothing/head/roguetown/tiyon
	reqs = list(/obj/item/natural/cloth = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_torioigasa
	name = "torioigasa"
	result = /obj/item/clothing/head/roguetown/torioigasa
	reqs = list(/obj/item/natural/fibers = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/head_roguetown_veiledhat
	name = "veiled hat"
	result = /obj/item/clothing/head/roguetown/veiledhat
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/headband
	name = "headband"
	result = /obj/item/clothing/head/roguetown/headband
	reqs = list(/obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/heavyhood
	name = "heavy hood"
	result = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/heavypadded
	name = "heavy padded coif"
	result = /obj/item/clothing/neck/roguetown/coif/heavypadding
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/hgambeson
	name = "padded gambeson"
	result = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	reqs = list(/obj/item/natural/cloth = 6, /obj/item/natural/fibers = 4)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/hgambeson/fencer
	name = "fencing shirt"
	result = /obj/item/clothing/suit/roguetown/shirt/freifechter
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/silk = 2)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/sewing/hijab
	name = "hijab"
	result = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/hoodfeld
	name = "feldsher's hood"
	result = /obj/item/clothing/head/roguetown/roguehood/feld
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/hoodphys
	name = "physicker's hood"
	result = /obj/item/clothing/head/roguetown/roguehood/phys
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/hw_dress
	name = "light green dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/hw_dress
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/jesterchest
	name = "jester's tunick"
	result = /obj/item/clothing/suit/roguetown/shirt/jester
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/jesterhead
	name = "jester's hat"
	result = /obj/item/clothing/head/roguetown/jester
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1, /obj/item/jingle_bells = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/jestershoes
	name = "jester's shoes"
	result = /obj/item/clothing/shoes/roguetown/jester
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1, /obj/item/jingle_bells = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/jupon
	name = "jupon"
	result = /obj/item/clothing/cloak/stabard/surcoat
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/keffiyeh
	name = "keffiyeh"
	result = /obj/item/clothing/head/roguetown/roguehood/shalal
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/knitcap
	name = "knit cap"
	result = /obj/item/clothing/head/roguetown/knitcap
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/ladycloak
	name = "ladylike shortcloak"
	result = /obj/item/clothing/cloak/lordcloak/ladycloak
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 2, /obj/item/natural/fur = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 6
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/leo_robe
	name = "leopard robe"
	result = /obj/item/clothing/suit/roguetown/shirt/leo_robe
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/leotard
	name = "leotard (1 fibers, 1 silk)"
	result = /obj/item/undies/leotard
	reqs = list(/obj/item/natural/silk = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/lgambeson
	name = "light gambeson"
	result = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/linedanklet
	name = "cloth lined anklet"
	result = /obj/item/clothing/shoes/roguetown/boots/clothlinedanklets
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/loincloth
	name = "loincloth"
	result = /obj/item/clothing/under/roguetown/loincloth
	reqs = list(/obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/loinclothadjusttwo
	name = "Adjust Small Loincloth to be looser (trousers)"
	result = /obj/item/clothing/under/roguetown/loincloth
	reqs = list(/obj/item/undies/loinclothunder = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/loinclothunder
	name = "Small Loincloth (1 cloth)"
	result = /obj/item/undies/loinclothunder
	reqs = list(/obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/longcoat
	name = "longcoat"
	result = /obj/item/clothing/suit/roguetown/armor/longcoat
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/lordlycloak
	name = "lordly cloak"
	result = /obj/item/clothing/cloak/lordcloak
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2, /obj/item/natural/fur = 2, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 6
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/lowcut_shirt
	name = "low cut tunic"
	result = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/maidapron
	name = "maid apron"
	result = /obj/item/clothing/cloak/apron/maid
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1, /obj/item/natural/silk = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/maidband
	name = "maid headband"
	result = /obj/item/clothing/head/roguetown/maidband
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/maiddress
	name = "maid dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/maid
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/malum
	name = "tabard, malum"
	result = /obj/item/clothing/cloak/templar/malum
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/mask_rogue_blindfold_psydon
	name = "blessed blindfold"
	result = /obj/item/clothing/mask/rogue/blindfold/psydon
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/mask_rogue_eyepatch_fake
	name = "eyepatch"
	result = /obj/item/clothing/mask/rogue/eyepatch/fake
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/mask_rogue_eyepatch_left_fake
	name = "eyepatch (fake)"
	result = /obj/item/clothing/mask/rogue/eyepatch/left/fake
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/mask_rogue_faceveil
	name = "simple veil"
	result = /obj/item/clothing/mask/rogue/faceveil
	reqs = list(/obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/mask_rogue_physician_feld
	name = "feldsher's mask"
	result = /obj/item/clothing/mask/rogue/physician/feld
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/bouquet/calendula = 1, /obj/item/natural/bone = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/mask_rogue_physician_phys
	name = "physicker's mask"
	result = /obj/item/clothing/mask/rogue/physician/phys
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/bouquet/calendula = 1, /obj/item/natural/bone = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/mask_rogue_shepherd_shadowmask_spymaster
	name = "hand's halfmask"
	result = /obj/item/clothing/mask/rogue/shepherd/shadowmask/spymaster
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/maskgreen
	name = "exotic silk mask (green)"
	result = /obj/item/clothing/mask/rogue/exoticsilkmask/green
	reqs = list(/obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/maskred
	name = "exotic silk mask (red)"
	result = /obj/item/clothing/mask/rogue/exoticsilkmask/red
	reqs = list(/obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/monkheadband
	name = "padded headband"
	result = /obj/item/clothing/head/roguetown/headband/monk
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/monkrobe
	name = "pontifex's qaba"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/pointfex
	reqs = list(/obj/item/natural/cloth = 6, /obj/item/natural/fibers = 5)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/monkwraps
	name = "padded arm wrappings"
	result = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/naledisash
	name = "hierophant's sash"
	result = /obj/item/clothing/cloak/hierophant
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/neck_roguetown_collar_fur
	name = "fur collar"
	result = /obj/item/clothing/neck/roguetown/collar/fur
	reqs = list(/obj/item/natural/fur = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/neck_roguetown_cravat
	name = "cravat"
	result = /obj/item/clothing/neck/roguetown/cravat
	reqs = list(/obj/item/natural/cloth = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/neck_roguetown_ruffle
	name = "ruffled collar"
	result = /obj/item/clothing/neck/roguetown/ruffle
	reqs = list(/obj/item/natural/cloth = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/necra
	name = "tabard, necra"
	result = /obj/item/clothing/cloak/templar/necra
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/necramask
	name = "death mask"
	result = /obj/item/clothing/head/roguetown/necramask
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1, /obj/item/natural/bone = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/nemes
	name = "nemes"
	result = /obj/item/clothing/head/roguetown/headdress
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/nightgown
	name = "nightgown"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/gen/nightgown
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/noblecoat
	name = "fancy coat"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/noblecoat
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/silk = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/nobledress
	name = "noble dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/noble
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/noc
	name = "tabard, noc"
	result = /obj/item/clothing/cloak/templar/noc
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/nocwrappings
	name = "moon wrappings"
	result = /obj/item/clothing/wrists/roguetown/nocwrappings
	reqs = list(/obj/item/natural/cloth = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/nunhabit
	name = "nun habit"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/nun
	reqs = list(/obj/item/natural/cloth = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/nunveil
	name = "nun veil"
	result = /obj/item/clothing/head/roguetown/nun
	reqs = list(/obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/nurseveil
	name = "nurse's veil"
	result = /obj/item/clothing/head/roguetown/veiled
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/otavangambeson
	name = "otavan gambeson"
	result = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan
	reqs = list(/obj/item/natural/cloth = 5, /obj/item/natural/silk = 2, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 6
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/paddedcap
	name = "padded cap"
	result = /obj/item/clothing/head/roguetown/paddedcap
	reqs = list(/obj/item/natural/fibers = 5)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/paddedcoif
	name = "padded coif"
	result = /obj/item/clothing/neck/roguetown/coif/padded
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/paddedmask
	name = "padded mask"
	result = /obj/item/clothing/mask/rogue/facemask/padded
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/panties
	name = "panties (1 cloth)"
	result = /obj/item/undies/panties
	reqs = list(/obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/paperparasol
	name = "paper parasol"
	result = /obj/item/rogueweapon/mace/parasol
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 2, /obj/item/paper/scroll = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/peasantcap
	name = "cap"
	result = /obj/item/clothing/head/roguetown/armingcap
	reqs = list(/obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/pestra
	name = "tabard, pestran templar"
	result = /obj/item/clothing/cloak/templar/pestra
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/pestran
	name = "tabard, pestran"
	result = /obj/item/clothing/cloak/templar/pestran
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/poncho
	name = "cloth poncho"
	result = /obj/item/clothing/cloak/poncho
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/psydon
	name = "tabard, psydon orthodoxist"
	result = /obj/item/clothing/cloak/psydontabard
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/puritanhat
	name = "puritan's buckled hat"
	result = /obj/item/clothing/head/roguetown/puritan
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/ragmask
	name = "rag mask"
	result = /obj/item/clothing/mask/rogue/ragmask
	reqs = list(/obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/rags
	name = "rags"
	result = /obj/item/clothing/suit/roguetown/shirt/rags
	reqs = list(/obj/item/natural/cloth = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/ravox
	name = "tabard, ravox"
	result = /obj/item/clothing/cloak/cleric/ravox
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/ravoxgorget
	name = "ravox gorget"
	result = /obj/item/clothing/head/roguetown/roguehood/ravoxgorget
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/ravoxtemplar
	name = "tabard, ravox templar"
	result = /obj/item/clothing/cloak/templar/ravox
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/regalrobes
	name = "regal silks"
	result = /obj/item/clothing/suit/roguetown/shirt/vampire
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/reinforced_hood
	name = "reinforced hood"
	result = /obj/item/clothing/head/roguetown/roguehood/reinforced
	reqs = list(/obj/item/clothing/head/roguetown/roguehood = 1, /obj/item/natural/cloth = 6, /obj/item/natural/silk = 1, /obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/robe
	name = "robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/royaldress
	name = "pristine dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/royal/princess
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/royalgown
	name = "royal gown"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/royal
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 6
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/royalshirt
	name = "gilded dress shirt"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/royal/prince
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/royalsleeves
	name = "royal sleeves"
	result = /obj/item/clothing/wrists/roguetown/royalsleeves
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/sack
	name = "sack hood"
	result = /obj/item/clothing/head/roguetown/menacing
	reqs = list(/obj/item/natural/cloth = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/sailorshirt_colored
	name = "striped shirt (colorable)"
	result = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/colored
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/sailorspants
	name = "sailor's pants"
	result = /obj/item/clothing/under/roguetown/tights/sailor
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/scarf
	name = "scarf (1 fibers, 1 cloth)"
	result = /obj/item/clothing/head/roguetown/scarf
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/selune
	name = "moon robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/selune
	reqs = list(/obj/item/natural/cloth = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/servantdress
	name = "servant dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/maid/servant
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/sexydress
	name = "sheer dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/gen/sexy
	reqs = list(/obj/item/natural/cloth = 6, /obj/item/natural/fibers = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/shadowpants
	name = "silk tights"
	result = /obj/item/clothing/under/roguetown/trou/shadowpants
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/shadowshirt
	name = "silk shirt"
	result = /obj/item/clothing/suit/roguetown/shirt/shadowshirt
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/shawl
	name = "shawl"
	result = /obj/item/clothing/head/roguetown/shawl
	reqs = list(/obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/shroudwhite
	name = "white shroud"
	result = /obj/item/clothing/head/roguetown/roguehood/shroudwhite
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/silkdress
	name = "ornate silk dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress/steward
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/silktunic
	name = "ornate silk tunic"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/silktunic
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/silkydress
	name = "silky dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/silkydress
	reqs = list(/obj/item/natural/cloth = 6, /obj/item/natural/fibers = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 6
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/sirwal
	name = "sirwal"
	result = /obj/item/clothing/under/roguetown/sirwal
	reqs = list(/obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/skirt
	name = "skirt"
	result = /obj/item/clothing/under/roguetown/skirt
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/skirt_knee
	name = "knee-high skirt"
	result = /obj/item/clothing/under/roguetown/skirt/knee
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/skirt_knee_colored
	name = "knee-high skirt (colorable)"
	result = /obj/item/clothing/under/roguetown/skirt/knee/colored
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/skirtgreen
	name = "exotic silk belt (green)"
	result = /obj/item/storage/belt/rogue/leather/exoticsilkbelt/skirtgreen
	reqs = list(/obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/skirtred
	name = "exotic silk belt (red)"
	result = /obj/item/storage/belt/rogue/leather/exoticsilkbelt/skirtred
	reqs = list(/obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/skyrim_dress
	name = "light blue dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/skyrim_dress
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/skyrim_mage
	name = "mage robes"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/skyrim_mage
	reqs = list(/obj/item/natural/cloth = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/skyrim_taven
	name = "waitress dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/skyrim_taven
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/sleevelessrobefeld
	name = "feldsher's robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/feld
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/sleevelessrobephys
	name = "physicker's robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/phys
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/slitdress
	name = "slitted dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/slit
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/sophisticated_jacket
	name = "sophisticated jacket"
	result = /obj/item/clothing/armor/gambeson/sophisticated_jacket
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/spellsingerhat
	name = "spellsinger hat"
	result = /obj/item/clothing/head/roguetown/spellcasterhat
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 6
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/spellsingerrobes
	name = "spellsinger robes"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/spellcasterrobe
	reqs = list(/obj/item/natural/cloth = 6, /obj/item/natural/fibers = 4, /obj/item/natural/silk = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 6
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/stabard
	name = "surcoat"
	result = /obj/item/clothing/cloak/stabard
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/stabard/bog
	name = "surcoat, bog"
	result = /obj/item/clothing/cloak/stabard/bog
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/sewing/stabard/guard
	name = "surcoat, guard"
	result = /obj/item/clothing/cloak/stabard/guard
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/sewing/stabard/guardhood
	name = "guard hood"
	result = /obj/item/clothing/cloak/stabard/guardhood
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/sewing/stewarddress
	name = "ornate dark dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/steward
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/stewardtailcoat
	name = "ornate dark tailcoat"
	result = /obj/item/clothing/suit/roguetown/shirt/coat/steward
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/stockdress
	name = "simple dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/gen
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/stockings_knee_white
	name = "stockings - knee (1 fibers, 1 cloth)"
	result = /obj/item/legwears/knee_high
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/stockings_thigh_white
	name = "stockings - thigh (1 fibers, 1 cloth)"
	result = /obj/item/legwears/thigh_high/white
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/stockings_white
	name = "stockings (1 fibers, 1 cloth)"
	result = /obj/item/legwears/white
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/stockings_white_fishnet
	name = "fishnet stockings (2 fibers)"
	result = /obj/item/legwears/fishnet/white
	reqs = list(/obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/stockings_white_silk
	name = "silk stockings (1 fibers, 1 silk)"
	result = /obj/item/legwears/silk/white
	reqs = list(/obj/item/natural/silk = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/strapless_dress
	name = "strapless dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/strapless_dress_alt
	name = "strapless dress alt"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/alt
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/strawhat
	name = "straw hat"
	result = /obj/item/clothing/head/roguetown/strawhat
	reqs = list(/obj/item/natural/fibers = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_courtphysician
	name = "sanguine vest"
	result = /obj/item/clothing/suit/roguetown/shirt/courtphysician
	reqs = list(/obj/item/natural/silk = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_courtphysician_female
	name = "sanguine blouse"
	result = /obj/item/clothing/suit/roguetown/shirt/courtphysician/female
	reqs = list(/obj/item/natural/silk = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_desertbra
	name = "desert bra"
	result = /obj/item/clothing/suit/roguetown/shirt/desertbra
	reqs = list(/obj/item/natural/fibers = 5)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_dress_blue
	name = "light blue dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/blue
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_dress_etrdress
	name = "low-cut dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/etrdress
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_dress_etrdress2
	name = "embroidered dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/etrdress2
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_dress_etrdress3
	name = "strapless gown"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/etrdress3
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_dress_green
	name = "light green dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/green
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_dress_maidfancy
	name = "valorian maid dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/maidfancy
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_dress_nightgown
	name = "nightgown"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/nightgown
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_dress_saree
	name = "saree"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/saree
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_dress_silkdress_bishop
	name = "bishop's cassock"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress/bishop
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_dress_tavern
	name = "tavern dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/tavern
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_elven
	name = "elven suit"
	result = /obj/item/clothing/suit/roguetown/shirt/elven
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_elven_coat
	name = "elven coat"
	result = /obj/item/clothing/suit/roguetown/shirt/elven/coat
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_elven_coat_alt
	name = "elven furcoat"
	result = /obj/item/clothing/suit/roguetown/shirt/elven/coat/alt
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_explorer
	name = "explorer's vest"
	result = /obj/item/clothing/suit/roguetown/shirt/explorer
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_fancyjacket
	name = "fancy jacket"
	result = /obj/item/clothing/suit/roguetown/shirt/fancyjacket
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_fancyjacket_triumph_padded
	name = "dark jacket"
	result = /obj/item/clothing/suit/roguetown/shirt/fancyjacket/triumph_padded
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_hammerhold
	name = "hammerhold shirt"
	result = /obj/item/clothing/suit/roguetown/shirt/hammerhold
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_hammerhold_coat
	name = "noble coat"
	result = /obj/item/clothing/suit/roguetown/shirt/hammerhold/coat
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_haori
	name = "haori"
	result = /obj/item/clothing/suit/roguetown/shirt/haori
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_kamishimo
	name = "kamishimo"
	result = /obj/item/clothing/suit/roguetown/shirt/kamishimo
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_kazengun_jacket
	name = "kazengun jacket"
	result = /obj/item/clothing/suit/roguetown/shirt/kazengun_jacket
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_kimono
	name = "kimono"
	result = /obj/item/clothing/suit/roguetown/shirt/kimono
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_kimono2
	name = "long sleeved kimono"
	result = /obj/item/clothing/suit/roguetown/shirt/kimono2
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_robe_abyssor_leader
	name = "sylveric robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor_leader
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_robe_abyssor_painter
	name = "rainfall robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor_painter
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_robe_abyssor_painter_sea
	name = "sea robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor_painter_sea
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_robe_bared
	name = "bared robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/bared
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_robe_eora_resprite
	name = "eoran robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/eora/resprite
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_robe_eora_resprite_pink
	name = "eoran robe (pink)"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/eora/resprite/pink
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_robe_hag
	name = "hedge robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/hag
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_robe_leopard
	name = "leopard robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/leopard
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_robe_leopard_alt
	name = "open leopard robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/leopard/alt
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_robe_nun_dress
	name = "nun dress"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/nun_dress
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_silkbra
	name = "giltsilk bra"
	result = /obj/item/clothing/suit/roguetown/shirt/silkbra
	reqs = list(/obj/item/natural/silk = 5)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 6
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_undershirt_etrdoublet
	name = "doublet"
	result = /obj/item/clothing/suit/roguetown/shirt/undershirt/etrdoublet
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/suit_roguetown_shirt_yoroihitatare
	name = "yoroihitatare"
	result = /obj/item/clothing/suit/roguetown/shirt/yoroihitatare
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/surgcollar
	name = "surgeon's collar"
	result = /obj/item/clothing/neck/roguetown/collar/surgcollar
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/surgicalbag
	name = "surgeon's bag"
	result = /obj/item/storage/belt/rogue/surgery_bag/empty
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1, /obj/item/natural/hide/cured = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/tabard
	name = "tabard"
	result = /obj/item/clothing/cloak/tabard
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/tagelmust
	name = "tagelmust"
	result = /obj/item/clothing/head/roguetown/turban
	reqs = list(/obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/tailcoat
	name = "tailcoat"
	result = /obj/item/clothing/armor/gambeson/tailcoat
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/tentkit
	name = "Small Tent Kit"
	result = /obj/item/tent_kit
	reqs = list(/obj/item/natural/cloth = 12, /obj/item/rope = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/thawb
	name = "thawb"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/beige
	reqs = list(/obj/item/natural/cloth = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/thong
	name = "thong"
	result = /obj/item/clothing/under/roguetown/thong
	reqs = list(/obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/tights
	name = "tights"
	result = /obj/item/clothing/under/roguetown/tights/random
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/toga
	name = "toga"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/toga
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/trousershorts
	name = "trouser shorts"
	result = /obj/item/clothing/under/roguetown/trou/formal/shorts
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/tunic
	name = "tunic"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/white
	reqs = list(/obj/item/natural/cloth = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/turban
	name = "turban"
	result = /obj/item/clothing/head/roguetown/turban
	reqs = list(/obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/turban/fancy
	name = "fancy turban"
	result = /obj/item/clothing/head/roguetown/turban/fancypurple
	reqs = list(/obj/item/natural/silk = 3)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/sewing/under_roguetown_loincloth_deprived
	name = "large loincloth"
	result = /obj/item/clothing/under/roguetown/loincloth/deprived
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/under_roguetown_skirt_courtphysician
	name = "sanguine skirt"
	result = /obj/item/clothing/under/roguetown/skirt/courtphysician
	reqs = list(/obj/item/natural/silk = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/under_roguetown_skirt_desert
	name = "desert skirt"
	result = /obj/item/clothing/under/roguetown/skirt/desert
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/under_roguetown_skirt_formal
	name = "knee-high skirt"
	result = /obj/item/clothing/under/roguetown/skirt/formal
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/under_roguetown_skirt_short
	name = "short skirt"
	result = /obj/item/clothing/under/roguetown/skirt/short
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/under_roguetown_tights_dhoti
	name = "dhoti"
	result = /obj/item/clothing/under/roguetown/tights/dhoti
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/under_roguetown_tights_hose
	name = "cloth hosen"
	result = /obj/item/clothing/under/roguetown/tights/hose
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/undervestments
	name = "undervestments"
	result = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/undies
	name = "briefs (1 fibers, 1 cloth)"
	result = /obj/item/undies
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/velvetdress
	name = "velvet dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/velvet
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/weaving/fallgown
	name = "gown (fall, silk)"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/gown/fallgown
	reqs = list(/obj/item/natural/fibers = 3, /obj/item/natural/silk = 2, /obj/item/natural/cloth = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 6
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/weaving/springgown
	name = "gown (spring)"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/gown
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/silk = 4)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 6
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/weaving/summergown
	name = "gown (summer)"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/gown/summergown
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/natural/cloth = 1, /obj/item/natural/silk = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 6
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/weaving/wintergown
	name = "gown (winter)"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/gown/wintergown
	reqs = list(/obj/item/natural/fibers = 3, /obj/item/natural/silk = 2, /obj/item/natural/fur = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 6
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/weddingdress
	name = "wedding silk dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress/weddingdress
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/whitetabard
	name = "tabard (alt)"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/tabardwhite
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/winterdress
	name = "winter dress"
	result = /obj/item/clothing/suit/roguetown/armor/armordress/winterdress
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/winterdress_light
	name = "cold dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/winterdress_light
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/witchhat
	name = "witch hat"
	result = /obj/item/clothing/head/roguetown/witchhat
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/wizhatblack
	name = "black wizard hat"
	result = /obj/item/clothing/head/roguetown/wizhat/black
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/wizhatblue
	name = "blue wizard hat"
	result = /obj/item/clothing/head/roguetown/wizhat
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/wizhatgreen
	name = "green wizard hat"
	result = /obj/item/clothing/head/roguetown/wizhat/green
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/wizhatred
	name = "red wizard hat"
	result = /obj/item/clothing/head/roguetown/wizhat/red
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/wizhatyellow
	name = "yellow wizard hat"
	result = /obj/item/clothing/head/roguetown/wizhat/yellow
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/woolencollar
	name = "wool collar"
	result = /obj/item/clothing/neck/roguetown/collar/woolen
	reqs = list(/obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/workervest
	name = "striped tunic"
	result = /obj/item/clothing/suit/roguetown/armor/workervest
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/wrappings
	name = "solar wrappings"
	result = /obj/item/clothing/wrists/roguetown/wrappings
	reqs = list(/obj/item/natural/cloth = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/xylix
	name = "tabard, xylix"
	result = /obj/item/clothing/cloak/templar/xylix
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/xylixian
	name = "tabard, xylix templar"
	result = /obj/item/clothing/cloak/templar/xylixian
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/yurtkit
	name = "Yurt Kit"
	result = /obj/item/tent_kit/yurt
	reqs = list(/obj/item/natural/cloth = 15, /obj/item/natural/fibers = 9, /obj/item/grown/log/tree/stick = 15)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/zybcushion1
	name = "desert cushion (yellow)"
	result = /obj/item/cushion/desert1
	reqs = list(/obj/item/natural/cloth = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/zybcushion2
	name = "desert cushion (grey)"
	result = /obj/item/cushion/desert2
	reqs = list(/obj/item/natural/cloth = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/zybcushionfancy
	name = "zybantine cushion"
	result = /obj/item/cushion/zybantine
	reqs = list(/obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/zybnoblesash
	name = "sash (zybantine noble)"
	result = /obj/item/storage/belt/rogue/leather/noblesash
	reqs = list(/obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/sewing/zybsash
	name = "sash (zybantine)"
	result = /obj/item/storage/belt/rogue/leather/cloth/sash
	reqs = list(/obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/smithing/catbell
	name = "catbell"
	result = /obj/item/catbell
	reqs = list(/obj/item/ingot/iron = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/smithing/cowbell
	name = "cowbell"
	result = /obj/item/catbell/cow
	reqs = list(/obj/item/ingot/iron = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/structure/activator
	name = "engineer's launcher"
	result = /obj/structure/englauncher
	reqs = list(/obj/item/roguegear/bronze = 1, /obj/item/natural/wood/plank = 4, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow = 1)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/actualfancytable
	name = "metallic wooden table (2 planks)"
	result = /obj/structure/table/wood/rockhill/wood
	reqs = list(/obj/item/natural/wood/plank = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 3
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/alch
	name = "alchemy station"
	result = /obj/structure/fluff/alch
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/stone = 4, /obj/item/grown/log/tree/small = 1)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 0
	rogue_verb = "assembles"
	rogue_verb_simple = "assemble"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/altcouchleft
	name = "couch alt (left)"
	result = /obj/structure/chair/wood/rockhill/bench/coucha
	reqs = list(/obj/item/natural/wood/plank = 3, /obj/item/natural/silk = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 4
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/altcouchright
	name = "couch alt (right)"
	result = /obj/structure/chair/wood/rockhill/bench/coucha/r
	reqs = list(/obj/item/natural/wood/plank = 3, /obj/item/natural/silk = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 4
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/anvil
	name = "anvil"
	result = /obj/machinery/anvil
	reqs = list(/obj/item/ingot/iron = 1)
	category = "Blacksmithing"
	rogue_skill = /datum/attribute/skill/craft/blacksmithing
	rogue_verb = "forges"
	rogue_verb_simple = "forge"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/apiary
	name = "apiary"
	result = /obj/structure/apiary
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/grown/log/tree/stick = 4)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/art_table
	name = "artificer table"
	result = /obj/machinery/artificer_table
	reqs = list(/obj/item/natural/wood/plank = 1)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_verb = "constructs"
	rogue_verb_simple = "constructs"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/ascendant
	name = "ascendant's altar"
	result = /obj/structure/ascendant_altar
	reqs = list(/obj/item/bodypart = 2, /obj/item/organ/stomach = 1)
	category = "Other"
	rogue_skill = null
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	crafting_flags = CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/roguetown/structure/barrel
	name = "wooden barrel"
	result = /obj/structure/fermentation_keg/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_verb = "makes"
	rogue_verb_simple = "make"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/bearrug
	name = "bearpelt rug"
	result = /obj/structure/bearpelt
	reqs = list(/obj/item/natural/fur/direbear = 2, /obj/item/natural/head/direbear = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/bed
	name = "bed, nice"
	result = /obj/structure/bed/rockhill/rogue/inn
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/natural/cloth = 2)
	tool_paths = list(/obj/item/needle)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/blackcouchleft
	name = "black couch (left)"
	result = /obj/structure/chair/wood/rockhill/bench/couchablack
	reqs = list(/obj/item/natural/wood/plank = 3, /obj/item/natural/silk = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 4
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/blackcouchright
	name = "black couch (right)"
	result = /obj/structure/chair/wood/rockhill/bench/couchablack/r
	reqs = list(/obj/item/natural/wood/plank = 3, /obj/item/natural/silk = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 4
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/blackpillows
	name = "black pillows (2 cloth)"
	result = /obj/structure/fluff/pillow/black
	reqs = list(/obj/item/natural/cloth = 2)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/bluepillows
	name = "blue pillows (2 cloth)"
	result = /obj/structure/fluff/pillow/blue
	reqs = list(/obj/item/natural/cloth = 2)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/bobcatrug
	name = "lynxpelt rug"
	result = /obj/structure/bobcatpelt
	reqs = list(/obj/item/natural/fur/bobcat = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/booth
	name = "market booth"
	result = /obj/structure/fluff/canopy/booth
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/cloth = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/booth02
	name = "market booth"
	result = /obj/structure/fluff/canopy/booth/booth02
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/cloth = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/booth_green
	name = "green market booth"
	result = /obj/structure/fluff/canopy/booth/booth_green
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/cloth = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/booth_green_02
	name = "green market booth02"
	result = /obj/structure/fluff/canopy/booth/booth_green02
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/cloth = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/border
	name = "border"
	result = /obj/structure/fluff/railing/border
	reqs = list(/obj/item/natural/wood/plank = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_on_tile = TRUE
	rogue_build_same = TRUE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/bordercorner
	name = "border corner"
	result = /obj/structure/fluff/railing/corner
	reqs = list(/obj/item/natural/wood/plank = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_on_tile = TRUE
	rogue_build_same = TRUE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_diagonal = TRUE

/datum/crafting_recipe/roguetown/structure/brazier
	name = "brazier"
	result = /obj/machinery/light/rogue/firebowl/stump
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/rogueore/coal = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "assembles"
	rogue_verb_simple = "assembles"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/brownpillows
	name = "brown pillows (2 cloth)"
	result = /obj/structure/fluff/pillow/brown
	reqs = list(/obj/item/natural/cloth = 2)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/campfire
	name = "campfire"
	result = /obj/machinery/light/rogue/campfire
	reqs = list(/obj/item/grown/log/tree/stick = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/cauldronalchemy
	name = "alchemy cauldron"
	result = /obj/machinery/light/rogue/cauldron
	reqs = list(/obj/item/grown/log/tree/stick = 2, /obj/item/natural/stone = 3, /obj/item/reagent_containers/glass/bucket/pot/stone = 1)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_verb = "assembles"
	rogue_verb_simple = "assemble"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/celldoor
	name = "cell door"
	result = /obj/structure/mineral_door/rockhill/bars
	reqs = list(/obj/item/ingot/iron = 2)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/ceramicswheel
	name = "potter's wheel"
	result = /obj/structure/fluff/ceramicswheel
	reqs = list(/obj/item/natural/stone = 2, /obj/item/grown/log/tree/small = 2, /obj/item/cooking/platter = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/chains
	name = "chains"
	result = /obj/structure/bondage/chains
	reqs = list(/obj/item/rope/chain = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/chair
	name = "wooden chair"
	result = /obj/item/chair/rogue/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/chair/zyb
	name = "wooden chair"
	result = /obj/structure/chair/wood/rockhill/wood/zybantine
	reqs = list(/obj/item/grown/log/tree/small = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/chairthrone
	name = "small throne"
	result = /obj/structure/chair/wood/rockhill/wood/rogue/throne
	reqs = list(/obj/item/natural/wood/plank = 2, /obj/item/natural/silk = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/chest
	name = "chest"
	result = /obj/structure/closet/crate/wooden/rockhill/crate/chest/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/closet
	name = "closet"
	result = /obj/structure/closet/crate/wooden/rockhill/crate/roguecloset
	reqs = list(/obj/item/grown/log/tree/small = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/coffin
	name = "wooden coffin"
	result = /obj/structure/closet/crate/wooden/rockhill/crate/coffin
	reqs = list(/obj/item/grown/log/tree/small = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/composter
	name = "composter"
	result = /obj/structure/composter
	reqs = list(/obj/item/grown/log/tree/small = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/cookpit
	name = "hearth"
	result = /obj/machinery/light/rogue/hearth
	reqs = list(/obj/item/grown/log/tree/stick = 1, /obj/item/natural/stone = 3)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/couchleft
	name = "couch (left)"
	result = /obj/structure/chair/wood/rockhill/bench/couch
	reqs = list(/obj/item/natural/wood/plank = 3, /obj/item/natural/silk = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 4
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/couchright
	name = "couch (right)"
	result = /obj/structure/chair/wood/rockhill/bench/couch/r
	reqs = list(/obj/item/natural/wood/plank = 3, /obj/item/natural/silk = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 4
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/curtain
	name = "curtain"
	result = /obj/structure/rockhill/curtain
	reqs = list(/obj/item/natural/cloth = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_ignore_density = TRUE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/curtainblack
	name = "curtain(black)"
	result = /obj/structure/rockhill/curtain/black
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	rogue_ignore_density = TRUE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/curtainblue
	name = "curtain(blue)"
	result = /obj/structure/rockhill/curtain/blue
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	rogue_ignore_density = TRUE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/curtainbrown
	name = "curtain(brown)"
	result = /obj/structure/rockhill/curtain/brown
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	rogue_ignore_density = TRUE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/curtaindirectional
	name = "curtain (directional)"
	result = /obj/structure/rockhill/curtain/directional/crafted
	reqs = list(/obj/item/natural/cloth = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_ignore_density = TRUE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/curtaingreen
	name = "curtain(green)"
	result = /obj/structure/rockhill/curtain/green
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	rogue_ignore_density = TRUE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/curtainmagenta
	name = "curtain(magenta)"
	result = /obj/structure/rockhill/curtain/magenta
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	rogue_ignore_density = TRUE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/curtainpurple
	name = "curtain(purple)"
	result = /obj/structure/rockhill/curtain/purple
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	rogue_ignore_density = TRUE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/curtainred
	name = "curtain(red)"
	result = /obj/structure/rockhill/curtain/red
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	rogue_ignore_density = TRUE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/densefire
	name = "greater campfire"
	result = /obj/machinery/light/rogue/campfire/densefire
	reqs = list(/obj/item/grown/log/tree/stick = 2, /obj/item/natural/stone = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/display_booth01
	name = "display booth"
	result = /obj/structure/fluff/canopy
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/natural/cloth = 2)
	rogue_results = list(/obj/structure/table/wood/rockhill/wood/crafted)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/display_booth02
	name = "display booth green"
	result = /obj/structure/fluff/canopy/green
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/natural/cloth = 2)
	rogue_results = list(/obj/structure/table/wood/rockhill/wood/crafted)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/display_stand
	name = "display stand"
	result = /obj/structure/mannequin
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/grown/log/tree/stick = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/donjon
	name = "metal door"
	result = /obj/structure/mineral_door/rockhill/wood/donjon
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/ingot/iron = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/door
	name = "wooden door"
	result = /obj/structure/mineral_door/rockhill/wood
	reqs = list(/obj/item/grown/log/tree/small = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/doorbolt
	name = "wooden door (deadbolt)"
	result = /obj/structure/mineral_door/rockhill/wood/deadbolt
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/grown/log/tree/stick = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/doublebed
	name = "bed, double nice"
	result = /obj/structure/bed/rockhill/rogue/inn/double
	reqs = list(/obj/item/grown/log/tree/small = 3, /obj/item/natural/cloth = 4)
	tool_paths = list(/obj/item/needle)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/drawer1
	name = "long dresser (2 planks)"
	result = /obj/structure/closet/crate/wooden/rockhill/crate/drawer/drawer2
	reqs = list(/obj/item/natural/wood/plank = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/drawer2
	name = "long dresser (alt) (2 planks)"
	result = /obj/structure/closet/crate/wooden/rockhill/crate/drawer/drawer2
	reqs = list(/obj/item/natural/wood/plank = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/drawer3
	name = "tall and long dresser (2 planks)"
	result = /obj/structure/closet/crate/wooden/rockhill/crate/drawer/drawer3
	reqs = list(/obj/item/natural/wood/plank = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/drawer4
	name = "tall and skinny dresser (2 planks)"
	result = /obj/structure/closet/crate/wooden/rockhill/crate/drawer/drawer4
	reqs = list(/obj/item/natural/wood/plank = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/drawer5
	name = "bedside drawer (2 planks)"
	result = /obj/structure/closet/crate/wooden/rockhill/crate/drawer
	reqs = list(/obj/item/natural/wood/plank = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/dummy
	name = "training dummy"
	result = /obj/structure/fluff/statue/tdummy
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/grown/log/tree/stick = 1, /obj/item/natural/fibers = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/dyestation
	name = "dye station"
	result = /obj/machinery/gear_painter
	reqs = list(/obj/item/natural/stone = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "makes"
	rogue_verb_simple = "make"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/fancychair
	name = "fancy wooden chair"
	result = /obj/item/chair/rogue/fancy/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/silk = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/fancydoor
	name = "fancy door"
	result = /obj/structure/mineral_door/rockhill/wood/fancywood
	reqs = list(/obj/item/grown/log/tree/small = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 3
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/fancymirror
	name = "fancy mirror (north)"
	result = /obj/structure/mirror/fancy
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/ingot/silver = 1, /obj/item/ingot/gold = 1, /obj/item/natural/glass = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 5
	rogue_on_wall = TRUE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/fancypot
	name = "sand pot (fancy)"
	result = /obj/structure/fermentation_keg/fancypot
	reqs = list(/obj/item/natural/clay = 1)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 3
	rogue_verb = "makes"
	rogue_verb_simple = "make"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/fancytableblack
	name = "fancy wooden table(black)"
	result = /obj/structure/table/wood/rockhill/wood/fancy/black
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/silk = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 3
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/fancytableblue
	name = "fancy wooden table(blue)"
	result = /obj/structure/table/wood/rockhill/wood/fancy/blue
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/silk = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 3
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/fancytablegreen
	name = "fancy wooden table(green)"
	result = /obj/structure/table/wood/rockhill/wood/fancy/green
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/silk = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 3
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/fancytablepurple
	name = "fancy wooden table(purple)"
	result = /obj/structure/table/wood/rockhill/wood/fancy/purple
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/silk = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 3
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/fancytablered
	name = "fancy wooden table(red)"
	result = /obj/structure/table/wood/rockhill/wood/fancy/red
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/silk = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 3
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/fancytableroyalblack
	name = "fancy wooden table(royal black)"
	result = /obj/structure/table/wood/rockhill/wood/fancy/royalblack
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/silk = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 4
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/fence
	name = "palisade (stakes)"
	result = /obj/structure/fluff/railing/fence
	reqs = list(/obj/item/grown/log/tree/stake = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_on_tile = TRUE
	rogue_build_same = TRUE
	rogue_verb = "sets up"
	rogue_verb_simple = "set up"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/fencealt
	name = "palisade (log)"
	result = /obj/structure/fluff/railing/fence
	reqs = list(/obj/item/grown/log/tree/small = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_on_tile = TRUE
	rogue_build_same = TRUE
	rogue_verb = "sets up"
	rogue_verb_simple = "set up"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/finestonetable
	name = "fine stone table (1 stone block)"
	result = /obj/structure/table/wood/rockhill/finestone
	reqs = list(/obj/item/natural/stoneblock = 1)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/fireplace
	name = "fireplace (north)"
	result = /obj/machinery/light/rogue/campfire/fireplace/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/stoneblock = 3)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_on_wall = TRUE
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/fireplace/blue
	name = "blue fireplace (north)"
	result = /obj/machinery/light/rogue/campfire/fireplace/crafted/blue
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/stoneblock = 3, /obj/item/rogueore/copper = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = TRUE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/fireplace/desert
	name = "desert fireplace"
	result = /obj/machinery/light/rogue/campfire/fireplace/desert
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/stoneblock = 3)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = TRUE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/floorcandle
	name = "floor candles (2 candles)"
	result = /obj/machinery/light/rogue/candle/floorcandle
	reqs = list(/obj/item/candle/yellow = 2)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 0
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/floorcandlealt
	name = "alt floor candles (2 candles)"
	result = /obj/machinery/light/rogue/candle/floorcandle/alt
	reqs = list(/obj/item/candle/yellow = 2)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 0
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/floorcandlealtpink
	name = "alt eoran floor candles"
	result = /obj/machinery/light/rogue/candle/floorcandle/alt/pink
	reqs = list(/obj/item/candle/eora = 2)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 0
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/floorcandlepink
	name = "eoran floor candles"
	result = /obj/machinery/light/rogue/candle/floorcandle/pink
	reqs = list(/obj/item/candle/eora = 2)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 0
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/floorclock
	name = "floor clock (anchored)"
	result = /obj/structure/fluff/clock
	reqs = list(/obj/item/natural/wood/plank = 2, /obj/item/roguegear/bronze = 1, /obj/item/ingot/iron = 1)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/floorgrille
	name = "floorgrille"
	result = /obj/structure/bars/grille
	reqs = list(/obj/item/ingot/iron = 1, /obj/item/roguegear/bronze = 1)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 3
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/forge
	name = "forge"
	result = /obj/machinery/light/rogue/forge
	reqs = list(/obj/item/natural/stone = 4, /obj/item/rogueore/coal = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "builds"
	rogue_verb_simple = "build"

/datum/crafting_recipe/roguetown/structure/foxrug
	name = "foxpelt rug"
	result = /obj/structure/foxpelt
	reqs = list(/obj/item/natural/fur/fox = 2, /obj/item/natural/head/fox = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/gallows
	name = "gallows"
	result = /obj/structure/noose/gallows
	reqs = list(/obj/item/rope = 1, /obj/item/grown/log/tree/small = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2
	rogue_on_tile = TRUE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/glassdoor
	name = "Wooden Glass Door"
	result = /obj/structure/mineral_door/rockhill/wood/window
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/natural/glass = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 3
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/globe
	name = "globe"
	result = /obj/structure/globe
	reqs = list(/obj/item/grown/log/tree/stick = 2, /obj/item/natural/wood/plank = 3)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 3
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/gloryhole
	name = "gloryhole"
	result = /obj/structure/bondage/gloryhole
	reqs = list(/obj/item/natural/wood/plank = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/greatsmelter
	name = "great furnace"
	result = /obj/machinery/light/rogue/smelter/great
	reqs = list(/obj/item/ingot/iron = 2, /obj/item/riddleofsteel = 1, /obj/item/rogueore/coal = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2
	rogue_verb = "builds"
	rogue_verb_simple = "build"

/datum/crafting_recipe/roguetown/structure/greenpillows
	name = "green pillows (2 cloth)"
	result = /obj/structure/fluff/pillow/green
	reqs = list(/obj/item/natural/cloth = 2)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/handcart
	name = "handcart"
	result = /obj/structure/handcart
	reqs = list(/obj/item/grown/log/tree/small = 3, /obj/item/rope = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/hangingchains
	name = "hanging chains (2 chains)"
	result = /obj/structure/fluff/walldeco/chains
	reqs = list(/obj/item/rope/chain = 2)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/headstake
	name = "head stake"
	result = /obj/structure/fluff/headstake
	reqs = list(/obj/item/grown/log/tree/stake = 1, /obj/item/bodypart/head = 1)
	parts = list(/obj/item/bodypart/head = 1, /obj/item/grown/log/tree/stake = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "sets up"
	rogue_verb_simple = "set up"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/largetable
	name = "large table (2 planks)"
	result = /obj/structure/table/wood/rockhill/wood/large_table
	reqs = list(/obj/item/natural/wood/plank = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 3
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/littlebanners
	name = "fair banners red-white"
	result = /obj/structure/fluff/littlebanners
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/littlebanners/bluered
	name = "fair banners blue-red"
	result = /obj/structure/fluff/littlebanners/bluered
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/littlebanners/bluewhite
	name = "fair banners blue-white"
	result = /obj/structure/fluff/littlebanners/bluewhite
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/littlebanners/greenblue
	name = "fair banners green-blue"
	result = /obj/structure/fluff/littlebanners/greenblue
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/littlebanners/greenred
	name = "fair banners green-red"
	result = /obj/structure/fluff/littlebanners/greenred
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/littlebanners/greenwhite
	name = "fair banners green-white"
	result = /obj/structure/fluff/littlebanners/greenwhite
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/longtable
	name = "nice long table (2 planks)"
	result = /obj/structure/table/wood/rockhill/wood/long_table
	reqs = list(/obj/item/natural/wood/plank = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 4
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/longtablealt
	name = "nice long table(middle) (2 planks)"
	result = /obj/structure/table/wood/rockhill/wood/long_table/mid/alt
	reqs = list(/obj/item/natural/wood/plank = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 4
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/loom
	name = "loom"
	result = /obj/machinery/loom
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/grown/log/tree/stick = 2, /obj/item/natural/fibers = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/magentacouchleft
	name = "magenta couch (left)"
	result = /obj/structure/chair/wood/rockhill/bench/couchamagenta
	reqs = list(/obj/item/natural/wood/plank = 3, /obj/item/natural/silk = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 4
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/magentacouchright
	name = "magenta couch (right)"
	result = /obj/structure/chair/wood/rockhill/bench/couchamagenta/r
	reqs = list(/obj/item/natural/wood/plank = 3, /obj/item/natural/silk = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 4
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/magentapillows
	name = "magenta pillows (2 cloth)"
	result = /obj/structure/fluff/pillow/magenta
	reqs = list(/obj/item/natural/cloth = 2)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/mannequin_female
	name = "mannequin (female)"
	result = /obj/structure/mannequin/male/female
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/grown/log/tree/stick = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/mannequin_male
	name = "mannequin (male)"
	result = /obj/structure/mannequin/male
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/grown/log/tree/stick = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/meathook
	name = "meat hook"
	result = /obj/structure/meathook
	reqs = list(/obj/item/grown/log/tree = 2, /obj/item/rope = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/millstone
	name = "millstone"
	result = /obj/item/millstone
	reqs = list(/obj/item/natural/stone = 3)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_verb = "assembles"
	rogue_verb_simple = "construct"

/datum/crafting_recipe/roguetown/structure/mineshaft_support
	name = "mineshaft support"
	result = /obj/structure/barricade/mineshaft
	reqs = list(/obj/item/grown/log/tree/small = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_on_tile = TRUE
	rogue_build_same = TRUE
	rogue_verb = "sets up"
	rogue_verb_simple = "set up"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/mirror
	name = "mirror (north)"
	result = /obj/structure/mirror
	reqs = list(/obj/item/natural/wood/plank = 2, /obj/item/ingot/iron = 1, /obj/item/natural/glass = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 4
	rogue_on_wall = TRUE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/noose
	name = "noose"
	result = /obj/structure/noose
	reqs = list(/obj/item/rope = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_on_tile = TRUE
	rogue_verb = "tie"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/noose_idle.ogg'

/datum/crafting_recipe/roguetown/structure/operatingtable
	name = "operating table (2 small logs)"
	result = /obj/structure/table/wood/rockhill/optable
	reqs = list(/obj/item/grown/log/tree/small = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/oven
	name = "oven"
	result = /obj/machinery/light/rogue/oven
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/stone = 3)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_on_wall = TRUE
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/parkbenchleft
	name = "park bench (left)"
	result = /obj/structure/chair/wood/rockhill/hotspring_bench/left
	reqs = list(/obj/item/grown/log/tree/small = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/parkbenchmiddle
	name = "park bench (middle)"
	result = /obj/structure/chair/wood/rockhill/hotspring_bench
	reqs = list(/obj/item/grown/log/tree/small = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/parkbenchright
	name = "park bench (right)"
	result = /obj/structure/chair/wood/rockhill/hotspring_bench/right
	reqs = list(/obj/item/grown/log/tree/small = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/pillar/desert
	name = "sandstone pillar"
	result = /obj/structure/pillar/sand1
	reqs = list(/obj/item/natural/stone = 2)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_verb = "builds"
	rogue_verb_simple = "builds"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/pillory
	name = "pillory"
	result = /obj/structure/pillory
	reqs = list(/obj/item/ingot/iron = 1, /obj/item/grown/log/tree/small = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2
	rogue_on_tile = TRUE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/plough
	name = "plough"
	result = /obj/structure/plough
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/ingot/iron = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/pressure_plate
	name = "pressure plate"
	result = /obj/structure/pressure_plate
	reqs = list(/obj/item/roguegear/bronze = 1, /obj/item/natural/wood/plank = 2)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 2
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/psycrss
	name = "wooden cross"
	result = /obj/structure/fluff/psycross/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/grown/log/tree/stake = 3)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/psycruci
	name = "wooden psydonic cross"
	result = /obj/structure/fluff/psycross/psycrucifix
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/grown/log/tree/stake = 3)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/purplepillows
	name = "purple pillows (2 cloth)"
	result = /obj/structure/fluff/pillow/purple
	reqs = list(/obj/item/natural/cloth = 2)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/rack
	name = "rack"
	result = /obj/structure/rack/rockhill/rogue
	reqs = list(/obj/item/grown/log/tree/stick = 3)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/railing
	name = "railing"
	result = /obj/structure/fluff/railing/wood
	reqs = list(/obj/item/grown/log/tree/stick = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_on_tile = TRUE
	rogue_build_same = TRUE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/rcom
	name = "RCOM"
	result = /obj/structure/roguemachine/scomm/receive_only
	reqs = list(/obj/item/ingot/iron = 1, /obj/item/reagent_containers/food/snacks/smallrat = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 3
	rogue_on_tile = TRUE
	rogue_on_wall = TRUE
	rogue_verb = "assembles"
	rogue_verb_simple = "assemble"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/redpillows
	name = "red pillows (2 cloth)"
	result = /obj/structure/fluff/pillow/red
	reqs = list(/obj/item/natural/cloth = 2)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/sandpot
	name = "sand pot"
	result = /obj/structure/fermentation_keg/sandpot
	reqs = list(/obj/item/natural/clay = 1)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_verb = "makes"
	rogue_verb_simple = "make"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/sharpwheel
	name = "sharpening wheel"
	result = /obj/structure/fluff/grindwheel
	reqs = list(/obj/item/ingot/iron = 1, /obj/item/natural/stone = 1)
	category = "Blacksmithing"
	rogue_skill = /datum/attribute/skill/craft/blacksmithing
	rogue_verb = "builds"
	rogue_verb_simple = "build"

/datum/crafting_recipe/roguetown/structure/sign
	name = "custom sign"
	result = /obj/structure/fluff/customsign
	reqs = list(/obj/item/grown/log/tree/small = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/sign/eaglesign
	name = "wooden eagle sign (1 small log)"
	result = /obj/structure/fluff/iconsign/eaglesign
	reqs = list(/obj/item/grown/log/tree/small = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/sign/elksign
	name = "wooden elk sign (1 small log)"
	result = /obj/structure/fluff/iconsign/elksign
	reqs = list(/obj/item/grown/log/tree/small = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/sign/innsign
	name = "wooden inn sign (1 small log)"
	result = /obj/structure/fluff/iconsign/innsign
	reqs = list(/obj/item/grown/log/tree/small = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/sign/psydoniconsign
	name = "wooden psydon sign (1 small log)"
	result = /obj/structure/fluff/iconsign/psycrosssign
	reqs = list(/obj/item/grown/log/tree/small = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/sign/skullsign
	name = "wooden skull sign (1 small log)"
	result = /obj/structure/fluff/iconsign/skullsign
	reqs = list(/obj/item/grown/log/tree/small = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/sign/smithsign
	name = "wooden smith sign (1 small log)"
	result = /obj/structure/fluff/iconsign/smithsign
	reqs = list(/obj/item/grown/log/tree/small = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/sign/spidersign
	name = "wooden spider sign (1 small log)"
	result = /obj/structure/fluff/iconsign/spidersign
	reqs = list(/obj/item/grown/log/tree/small = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/sign/zizoiconsign
	name = "wooden zizo sign (1 small log)"
	result = /obj/structure/fluff/iconsign/zizosign
	reqs = list(/obj/item/grown/log/tree/small = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/silverpsycruci
	name = "silver psydonic cross"
	result = /obj/structure/fluff/psycross/psycrucifix/silver
	reqs = list(/obj/item/ingot/silverblessed = 1, /obj/item/ingot/steel = 2)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/sleepcoffin
	name = "sleep coffin"
	result = /obj/structure/closet/crate/wooden/rockhill/crate/coffin/vampire
	reqs = list(/obj/item/natural/wood/plank = 2, /obj/item/natural/silk = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/smelter
	name = "ore furnace"
	result = /obj/machinery/light/rogue/smelter
	reqs = list(/obj/item/natural/stone = 4, /obj/item/rogueore/coal = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "builds"
	rogue_verb_simple = "build"

/datum/crafting_recipe/roguetown/structure/smelterbronze
	name = "bronze melter"
	result = /obj/machinery/light/rogue/smelter/bronze
	reqs = list(/obj/item/natural/stone = 6, /obj/item/rogueore/coal = 1, /obj/item/rogueore/iron = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "builds"
	rogue_verb_simple = "build"

/datum/crafting_recipe/roguetown/structure/smelterhiron
	name = "iron bloomery"
	result = /obj/machinery/light/rogue/smelter/hiron
	reqs = list(/obj/item/natural/stone = 7, /obj/item/rogueore/coal = 2, /obj/item/rogueore/iron = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "builds"
	rogue_verb_simple = "build"

/datum/crafting_recipe/roguetown/structure/spike_pit
	name = "spike pit (Dirt Floor needed)"
	result = /obj/structure/spike_pit
	reqs = list(/obj/item/grown/log/tree/stake = 3)
	tool_paths = list(/obj/item/rogueweapon/shovel)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/stairsd
	name = "wooden stairs (down)"
	result = /obj/structure/rockhill/stairs/d
	reqs = list(/obj/item/grown/log/tree/small = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_on_tile = TRUE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/standing
	name = "standing fire"
	result = /obj/machinery/light/rogue/firebowl/standing
	reqs = list(/obj/item/natural/stone = 1, /obj/item/rogueore/coal = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/standingblue
	name = "standing blue fire"
	result = /obj/machinery/light/rogue/firebowl/standing/blue
	reqs = list(/obj/item/natural/stone = 1, /obj/item/rogueore/coal = 1, /obj/item/ash = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/statue/aasimar
	name = "statue (aasimar)"
	result = /obj/structure/fluff/statue/aasimar
	reqs = list(/obj/item/natural/stone = 4)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/statue/gargoyle
	name = "statue (gargoyle)"
	result = /obj/structure/fluff/statue/gargoyle
	reqs = list(/obj/item/natural/stone = 2)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/statue/grand/abyssor
	name = "statue (grand, Abyssor)"
	result = /obj/structure/fluff/statue/abyssor
	reqs = list(/obj/item/natural/stone = 5)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/statue/grand/abyssor/dolomite
	name = "statue (grand, Abyssor (dolomite))"
	result = /obj/structure/fluff/statue/abyssor/dolomite
	reqs = list(/obj/item/natural/stone = 5)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/statue/grand/astrata
	name = "statue (grand, Astrata)"
	result = /obj/structure/fluff/statue/astrata/gold
	reqs = list(/obj/item/natural/stone = 4, /obj/item/ingot/gold = 1)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/statue/grand/eora
	name = "statue (grand, Eora)"
	result = /obj/structure/fluff/statue/eora
	reqs = list(/obj/item/natural/stone = 4, /obj/item/ingot/gold = 1)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/statue/grand/noc
	name = "statue (grand, Noc)"
	result = /obj/structure/fluff/statue/noc
	reqs = list(/obj/item/natural/stone = 4, /obj/item/ingot/gold = 1)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/statue/grand/valmora
	name = "statue (grand, Valmora)"
	result = /obj/structure/fluff/statue/valmora
	reqs = list(/obj/item/natural/stone = 4, /obj/item/ingot/gold = 1)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/statue/hooded
	name = "statue (hooded)"
	result = /obj/structure/fluff/statue
	reqs = list(/obj/item/natural/stone = 3)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/statue/knight
	name = "statue (knight, facing left)"
	result = /obj/structure/fluff/statue/knight
	reqs = list(/obj/item/natural/stone = 4)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/statue/knightalt
	name = "statue (knight, tall, facing left)"
	result = /obj/structure/fluff/statue/knightalt
	reqs = list(/obj/item/natural/stone = 4)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/statue/knightaltr
	name = "statue (knight, tall, facing right)"
	result = /obj/structure/fluff/statue/knightalt/r
	reqs = list(/obj/item/natural/stone = 4)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/statue/knightr
	name = "statue (knight, facing right)"
	result = /obj/structure/fluff/statue/knight/r
	reqs = list(/obj/item/natural/stone = 4)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/statue/tiefling
	name = "statue (tiefling)"
	result = /obj/structure/fluff/statue/small
	reqs = list(/obj/item/natural/stone = 2)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/statue/woman
	name = "statue (lady sitting)"
	result = /obj/structure/fluff/statue/femalestatue2
	reqs = list(/obj/item/natural/stone = 4)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/stonedoor
	name = "stone door"
	result = /obj/structure/mineral_door/rockhill/wood/donjon/stone
	reqs = list(/obj/item/natural/stone = 2)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/stonelantern
	name = "stone lantern on ground"
	result = /obj/machinery/light/rogue/torchholder/hotspring
	reqs = list(/obj/item/natural/stone = 2)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/stonelanternstanding
	name = "stone lantern standing"
	result = /obj/machinery/light/rogue/torchholder/hotspring/standing
	reqs = list(/obj/item/natural/stone = 2)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/stonepsycrss
	name = "stone cross"
	result = /obj/structure/fluff/psycross
	reqs = list(/obj/item/natural/stone = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/stonepsycruci
	name = "stone psydonic cross"
	result = /obj/structure/fluff/psycross/psycrucifix/stone
	reqs = list(/obj/item/natural/stone = 3)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/stonestairsd
	name = "stone stairs (down)"
	result = /obj/structure/rockhill/stairs/stone/d
	reqs = list(/obj/item/natural/stone = 2)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_on_tile = TRUE
	rogue_verb = "builds"
	rogue_verb_simple = "builds"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/stonetable
	name = "stone table (1 stone)"
	result = /obj/structure/table/wood/rockhill/church
	reqs = list(/obj/item/natural/stone = 1)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/stonewalldeco
	name = "stone wall decoration"
	result = /obj/structure/fluff/walldeco/stone
	reqs = list(/obj/item/natural/stone = 1)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_on_wall = TRUE
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/stool
	name = "wooden stool"
	result = /obj/item/chair/stool/bar/rogue/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/strawbed
	name = "bed, straw"
	result = /obj/structure/bed/rockhill/rogue/shit
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/fibers = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/swing_door
	name = "swing door"
	result = /obj/structure/mineral_door/rockhill/swing_door
	reqs = list(/obj/item/grown/log/tree/small = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/table
	name = "wooden table (1 small log)"
	result = /obj/structure/table/wood/rockhill/wood/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/tablewood3
	name = "wooden table (alt) (1 plank)"
	result = /obj/structure/table/wood/rockhill/wood/poor/alt_alt
	reqs = list(/obj/item/natural/wood/plank = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/tanningrack
	name = "drying rack (3 sticks)"
	result = /obj/machinery/tanningrack
	reqs = list(/obj/item/grown/log/tree/stick = 3)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/telescope
	name = "telescope"
	result = /obj/structure/telescope
	reqs = list(/obj/item/grown/log/tree/stick = 2, /obj/item/ingot/iron = 1, /obj/item/natural/glass = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/tinypot
	name = "small clay pot"
	result = /obj/item/reagent_containers/glass/bucket/tinypot
	reqs = list(/obj/item/natural/clay = 1)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 2
	rogue_verb = "makes"
	rogue_verb_simple = "make"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/torchholder
	name = "sconce"
	result = /obj/machinery/light/rogue/torchholder
	reqs = list(/obj/item/natural/stone = 2)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 0
	rogue_on_wall = TRUE
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/torture_table
	name = "torture table"
	result = /obj/structure/bondage/torture_table
	reqs = list(/obj/item/natural/wood/plank = 3, /obj/item/ingot/iron = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/torture_table/lever
	name = "torture table lever"
	result = /obj/structure/bondage/torture_table/lever
	reqs = list(/obj/item/natural/wood/plank = 3, /obj/item/ingot/iron = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/ultimacouchleft
	name = "ultima couch (left)"
	result = /obj/structure/chair/wood/rockhill/bench/ultimacouch
	reqs = list(/obj/item/natural/wood/plank = 3, /obj/item/natural/silk = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 4
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/ultimacouchright
	name = "ultima couch (right)"
	result = /obj/structure/chair/wood/rockhill/bench/ultimacouch/r
	reqs = list(/obj/item/natural/wood/plank = 3, /obj/item/natural/silk = 2)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 4
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/wallcandle
	name = "wall candles"
	result = /obj/machinery/light/rogue/candle
	reqs = list(/obj/item/natural/stone = 1, /obj/item/candle/yellow = 1)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 0
	rogue_on_wall = TRUE
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/wallcandleblue
	name = "wall candles blue"
	result = /obj/machinery/light/rogue/candle/blue
	reqs = list(/obj/item/natural/stone = 1, /obj/item/candle/yellow = 1, /obj/item/ash = 1)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 0
	rogue_on_wall = TRUE
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/wallclock
	name = "wall clock (north)"
	result = /obj/structure/fluff/wallclock
	reqs = list(/obj/item/natural/wood/plank = 2, /obj/item/roguegear/bronze = 1, /obj/item/ingot/iron = 1)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 2
	rogue_on_wall = TRUE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/wallladder
	name = "wall ladder"
	result = /obj/structure/wallladder
	reqs = list(/obj/item/grown/log/tree/small = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_on_wall = TRUE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/wallshelf
	name = "wall shelf (1 plank)"
	result = /obj/structure/rack/rockhill/rogue/shelf
	reqs = list(/obj/item/natural/wood/plank = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_on_wall = TRUE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/wicker
	name = "wicker basket"
	result = /obj/structure/closet/crate/wooden/rockhill/crate/chest/wicker
	reqs = list(/obj/item/grown/log/tree/stick = 4, /obj/item/natural/fibers = 3)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "weaves"
	rogue_verb_simple = "weave"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/wonder
	name = "wonder"
	result = /obj/structure/wonder
	reqs = list(/obj/item/bodypart = 2, /obj/item/organ/stomach = 1)
	category = "Other"
	rogue_skill = null
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	crafting_flags = CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/roguetown/structure/wonder/first
	name = "first wonder"
	result = /obj/structure/wonder
	reqs = list(/obj/item/bodypart = 2, /obj/item/organ/stomach = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Other"
	rogue_skill = null
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = CRAFT_MUST_BE_LEARNED
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/wonder/fourth
	name = "fourth wonder"
	result = /obj/structure/wonder
	reqs = list(/obj/item/organ/tongue = 4, /obj/item/organ/eyes = 3, /obj/item/organ/liver = 4)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Other"
	rogue_skill = null
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = CRAFT_MUST_BE_LEARNED
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/wonder/second
	name = "second wonder"
	result = /obj/structure/wonder
	reqs = list(/obj/item/bodypart = 2, /obj/item/organ/lungs = 2)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Other"
	rogue_skill = null
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = CRAFT_MUST_BE_LEARNED
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/wonder/third
	name = "third wonder"
	result = /obj/structure/wonder
	reqs = list(/obj/item/bodypart/head = 3, /obj/item/bodypart = 2, /obj/item/organ/stomach = 2)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Other"
	rogue_skill = null
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = CRAFT_MUST_BE_LEARNED
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/wooden_horse
	name = "static wooden horse"
	result = /obj/structure/wooden_horse
	reqs = list(/obj/item/natural/wood/plank = 3)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/wooden_horse/iron
	name = "static wooden horse (iron)"
	result = /obj/structure/wooden_horse/iron
	reqs = list(/obj/item/natural/wood/plank = 2, /obj/item/ingot/iron = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/wooden_horse/mobile
	name = "mobile wooden horse"
	result = /obj/structure/wooden_horse/mobile
	reqs = list(/obj/item/natural/wood/plank = 3)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/wooden_horse/small
	name = "static wooden horse (small)"
	result = /obj/structure/wooden_horse/small
	reqs = list(/obj/item/natural/wood/plank = 2)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/wooden_spit
	name = "wooden spit"
	result = /obj/machinery/light/rogue/hearth/wooden_spit
	reqs = list(/obj/item/grown/log/tree/stick = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_structure = /obj/machinery/light/rogue/campfire
	rogue_ignore_density = TRUE
	rogue_verb = "sets up"
	rogue_verb_simple = "set up"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/woolbed
	name = "bed, wood"
	result = /obj/structure/bed/rockhill/rogue/inn/wool
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/wooldoublebed
	name = "bed, double wool"
	result = /obj/structure/bed/rockhill/rogue/inn/wooldouble
	reqs = list(/obj/item/grown/log/tree/small = 3, /obj/item/natural/cloth = 3)
	tool_paths = list(/obj/item/needle)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/x_pillory
	name = "x-pillory"
	result = /obj/structure/bondage/x_pillory
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/ingot/iron = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/zizo_shrine
	name = "wooden inverse cross"
	result = /obj/structure/fluff/psycross/zizocross
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/grown/log/tree/stake = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/zizo_shrine/gold
	name = "gold inverse cross"
	result = /obj/structure/fluff/psycross/zizocross/golden
	reqs = list(/obj/item/ingot/gold = 1, /obj/item/ingot/steel = 2)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/zizo_shrine/stone
	name = "stone inverse cross"
	result = /obj/structure/fluff/psycross/zizocross/stone
	reqs = list(/obj/item/natural/stone = 3)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/structure/zybdrape
	name = "desert drape"
	result = /obj/structure/drape/desert
	reqs = list(/obj/item/natural/cloth = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_ignore_density = TRUE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/zybdrapefancy
	name = "fancy zybantine drape"
	result = /obj/structure/drape/zybantine
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 4
	rogue_on_wall = TRUE
	rogue_ignore_density = TRUE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structures/psycross/baotha
	name = "stone baotha cross"
	result = /obj/structure/fluff/psycross/baotha
	reqs = list(/obj/item/natural/stone = 3)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/structures/psycross/graggar
	name = "stone graggarite cross"
	result = /obj/structure/fluff/psycross/graggar
	reqs = list(/obj/item/natural/stone = 3)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/structures/psycross/matthios
	name = "stone matthios cross"
	result = /obj/structure/fluff/psycross/matthios
	reqs = list(/obj/item/natural/stone = 3)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/structures/psycross/necra
	name = "stone necra cross"
	result = /obj/structure/fluff/psycross/crafted/necra
	reqs = list(/obj/item/natural/stone = 3)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/abyssoramulet
	name = "amulet of abyssor"
	result = /obj/item/clothing/neck/roguetown/psicross/abyssor
	reqs = list(/obj/item/natural/fibers = 1, /obj/item/pearl/blue = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/ancientmailledhauberk
	name = "layer an ancient cuirass atop hauberk"
	result = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/ancient
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/half/ancient = 1, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient = 1)
	blacklist = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient/decrepit, /obj/item/clothing/suit/roguetown/armor/plate/half/ancient/decrepit)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/antlerhood
	name = "antlerhood"
	result = /obj/item/clothing/head/roguetown/antlerhood
	reqs = list(/obj/item/natural/hide = 1, /obj/item/natural/bone = 2)
	tool_paths = list(/obj/item/needle)
	blacklist = list(/obj/item/natural/hide/cured)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0
	rogue_verb = "sews"
	rogue_verb_simple = "sew"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/bag
	name = "sack"
	result = /obj/item/storage/roguebag
	reqs = list(/obj/item/natural/fibers = 1, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	blacklist = list(/obj/item/natural/cloth/bandage)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/bandage
	name = "bandages (medicine)"
	result = /obj/item/natural/cloth/bandage
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/silk = 1, /obj/item/ash = 1)
	blacklist = list(/obj/item/ash/snappop_phoenix, /obj/item/natural/cloth/bandage)
	category = "Medicine"
	rogue_skill = /datum/attribute/skill/misc/medicine
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/billhook
	name = "improvised billhook"
	result = /obj/item/rogueweapon/spear/improvisedbillhook
	reqs = list(/obj/item/rogueweapon/sickle = 1, /obj/item/rope = 1, /obj/item/grown/log/tree/small = 1)
	tool_paths = list(/obj/item/rogueweapon/hammer)
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/rogueweapon/sickle/aalloy, /obj/item/rogueweapon/sickle/blacksteel, /obj/item/rogueweapon/sickle/bronze, /obj/item/rogueweapon/sickle/copper, /obj/item/rogueweapon/sickle/decrepit, /obj/item/rope/chain, /obj/item/rope/chain/bindingshackles, /obj/item/rope/chain/bindingshackles/t2, /obj/item/rope/chain/bindingshackles/t3, /obj/item/rope/chain/bindingshackles/t4, /obj/item/rope/chain/bindingshackles/t5, /obj/item/rope/chain/fake, /obj/item/rope/chain/fake/ice, /obj/item/rope/inqarticles/inquirycord)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/blessedbolt
	name = "holy water bolt"
	result = /obj/item/ammo_casing/caseless/rogue/bolt/holy
	reqs = list(/obj/item/ammo_casing/caseless/rogue/bolt = 1, /datum/reagent/water/blessed = 5)
	blacklist = list(/obj/item/ammo_casing/caseless/rogue/bolt/aalloy, /obj/item/ammo_casing/caseless/rogue/bolt/ancient, /obj/item/ammo_casing/caseless/rogue/bolt/blacksteel, /obj/item/ammo_casing/caseless/rogue/bolt/blunt, /obj/item/ammo_casing/caseless/rogue/bolt/bronze, /obj/item/ammo_casing/caseless/rogue/bolt/conjured, /obj/item/ammo_casing/caseless/rogue/bolt/decrepit, /obj/item/ammo_casing/caseless/rogue/bolt/heavyblunt, /obj/item/ammo_casing/caseless/rogue/bolt/holy, /obj/item/ammo_casing/caseless/rogue/bolt/light, /obj/item/ammo_casing/caseless/rogue/bolt/lightholy, /obj/item/ammo_casing/caseless/rogue/bolt/paalloy, /obj/item/ammo_casing/caseless/rogue/bolt/pyro, /obj/item/ammo_casing/caseless/rogue/bolt/silver, /obj/item/ammo_casing/caseless/rogue/bolt/water)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/bluntarrow
	name = "blunt arrow"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/blunt
	reqs = list(/obj/item/grown/log/tree/stick = 1, /obj/item/natural/stone = 1)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/bluntarrow_five
	name = "blunt arrow (x5)"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/blunt
	reqs = list(/obj/item/grown/log/tree/stick = 5, /obj/item/natural/stone = 5)
	rogue_results = list(/obj/item/ammo_casing/caseless/rogue/arrow/blunt, /obj/item/ammo_casing/caseless/rogue/arrow/blunt, /obj/item/ammo_casing/caseless/rogue/arrow/blunt, /obj/item/ammo_casing/caseless/rogue/arrow/blunt)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/boat
	name = "Dinghy (4 Logs, 3 Ash, 5 Fibers)"
	result = /obj/vehicle/ridden/rockhill/dinghy
	reqs = list(/obj/item/grown/log/tree = 4, /obj/item/ash = 3, /obj/item/natural/fibers = 5)
	blacklist = list(/obj/item/ash/snappop_phoenix, /obj/item/grown/log/tree/bowpartial, /obj/item/grown/log/tree/bowpartial/longbow, /obj/item/grown/log/tree/bowpartial/recurve, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small/essence, /obj/item/grown/log/tree/stake, /obj/item/grown/log/tree/stick)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/bombard
	name = "Portable Bombard (Barrel and Frame)"
	result = /obj/structure/bombard
	reqs = list(/obj/item/bombard_frame = 1, /obj/item/bombard_barrel = 1)
	category = "Firearms"
	rogue_skill = /datum/attribute/skill/combat/firearms
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/boneaxe
	name = "bone axe"
	result = /obj/item/rogueweapon/stoneaxe/boneaxe
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/bone = 2, /obj/item/natural/fibers = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/bonespear
	name = "bone spear"
	result = /obj/item/rogueweapon/spear/bonespear
	reqs = list(/obj/item/rogueweapon/woodstaff = 1, /obj/item/natural/bone = 2, /obj/item/natural/fibers = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/book_crafting_kit
	name = "book crafting kit"
	result = /obj/item/book_crafting_kit
	reqs = list(/obj/item/natural/hide = 2, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	blacklist = list(/obj/item/natural/cloth/bandage, /obj/item/natural/hide/cured)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/bouquet_calendula
	name = "calendula bouquet"
	result = /obj/item/bouquet/calendula
	reqs = list(/obj/item/alch/calendula = 4, /obj/item/natural/fibers = 2, /obj/item/paper/scroll = 1)
	blacklist = list(/obj/item/paper/scroll/bounty, /obj/item/paper/scroll/cargo, /obj/item/paper/scroll/custom, /obj/item/paper/scroll/fake_evidence, /obj/item/paper/scroll/grudge, /obj/item/paper/scroll/ministry_writ, /obj/item/paper/scroll/sell_price_changes, /obj/item/paper/scroll/trade_requests, /obj/item/paper/scroll/writ_of_esteem, /obj/item/paper/scroll/writ_of_esteem/grenzel, /obj/item/paper/scroll/writ_of_esteem/otavan, /obj/item/paper/scroll/writ_of_esteem/zybantine)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "arranges"
	rogue_verb_simple = "arranged"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/bouquet_matricaria
	name = "matricaria bouquet"
	result = /obj/item/bouquet/matricaria
	reqs = list(/obj/item/alch/matricaria = 4, /obj/item/natural/fibers = 2, /obj/item/paper/scroll = 1)
	blacklist = list(/obj/item/paper/scroll/bounty, /obj/item/paper/scroll/cargo, /obj/item/paper/scroll/custom, /obj/item/paper/scroll/fake_evidence, /obj/item/paper/scroll/grudge, /obj/item/paper/scroll/ministry_writ, /obj/item/paper/scroll/sell_price_changes, /obj/item/paper/scroll/trade_requests, /obj/item/paper/scroll/writ_of_esteem, /obj/item/paper/scroll/writ_of_esteem/grenzel, /obj/item/paper/scroll/writ_of_esteem/otavan, /obj/item/paper/scroll/writ_of_esteem/zybantine)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "arranges"
	rogue_verb_simple = "arranged"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/bouquet_rosa
	name = "rosa bouquet"
	result = /obj/item/bouquet/rosa
	reqs = list(/obj/item/alch/rosa = 4, /obj/item/natural/fibers = 2, /obj/item/paper/scroll = 1)
	blacklist = list(/obj/item/alch/rosa/azure, /obj/item/paper/scroll/bounty, /obj/item/paper/scroll/cargo, /obj/item/paper/scroll/custom, /obj/item/paper/scroll/fake_evidence, /obj/item/paper/scroll/grudge, /obj/item/paper/scroll/ministry_writ, /obj/item/paper/scroll/sell_price_changes, /obj/item/paper/scroll/trade_requests, /obj/item/paper/scroll/writ_of_esteem, /obj/item/paper/scroll/writ_of_esteem/grenzel, /obj/item/paper/scroll/writ_of_esteem/otavan, /obj/item/paper/scroll/writ_of_esteem/zybantine)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "arranges"
	rogue_verb_simple = "arranged"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/bouquet_salvia
	name = "salvia bouquet"
	result = /obj/item/bouquet/salvia
	reqs = list(/obj/item/alch/salvia = 4, /obj/item/natural/fibers = 2, /obj/item/paper/scroll = 1)
	blacklist = list(/obj/item/paper/scroll/bounty, /obj/item/paper/scroll/cargo, /obj/item/paper/scroll/custom, /obj/item/paper/scroll/fake_evidence, /obj/item/paper/scroll/grudge, /obj/item/paper/scroll/ministry_writ, /obj/item/paper/scroll/sell_price_changes, /obj/item/paper/scroll/trade_requests, /obj/item/paper/scroll/writ_of_esteem, /obj/item/paper/scroll/writ_of_esteem/grenzel, /obj/item/paper/scroll/writ_of_esteem/otavan, /obj/item/paper/scroll/writ_of_esteem/zybantine)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "arranges"
	rogue_verb_simple = "arranged"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/bow
	name = "wooden bow"
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	reqs = list(/obj/item/natural/bowstring = 1, /obj/item/grown/log/tree/bowpartial = 1)
	blacklist = list(/obj/item/grown/log/tree/bowpartial/longbow, /obj/item/grown/log/tree/bowpartial/recurve)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2
	rogue_verb = "strings together"
	rogue_verb_simple = "string together"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/bowpartial
	name = "unstrung bow"
	result = /obj/item/grown/log/tree/bowpartial
	reqs = list(/obj/item/grown/log/tree/small = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "carves"
	rogue_verb_simple = "carve"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/bowstring
	name = "fiber bowstring"
	result = /obj/item/natural/bowstring
	reqs = list(/obj/item/natural/fibers = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "twists"
	rogue_verb_simple = "twist"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/bpearlcross
	name = "amulet (blue pearls) "
	result = /obj/item/clothing/neck/roguetown/psicross/bpearl
	reqs = list(/obj/item/natural/fibers = 1, /obj/item/pearl/blue = 3)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/broom
	name = "broom"
	result = /obj/item/broom
	reqs = list(/obj/item/natural/fibers = 1, /obj/item/grown/log/tree/stick = 4)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/candle
	name = "candle (x3) (1 tallow)"
	result = /obj/item/candle/yellow
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 1)
	rogue_results = list(/obj/item/candle/yellow, /obj/item/candle/yellow)
	blacklist = list(/obj/item/reagent_containers/food/snacks/tallow/black, /obj/item/reagent_containers/food/snacks/tallow/red, /obj/item/reagent_containers/food/snacks/tallow/soft)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/candle/eora
	name = "eora's candle (x3) (1 tallow, 1 rosa, 25 blessed water)"
	result = /obj/item/candle/eora
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/alch/rosa = 1, /datum/reagent/water/blessed = 25)
	rogue_results = list(/obj/item/candle/eora, /obj/item/candle/eora)
	tool_paths = null
	parts = null
	blacklist = list(/obj/item/alch/rosa/azure, /obj/item/reagent_containers/food/snacks/tallow/black, /obj/item/reagent_containers/food/snacks/tallow/red, /obj/item/reagent_containers/food/snacks/tallow/soft)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/survival/chain_leash
	name = "chain leash"
	result = /obj/item/leash/chain
	reqs = list(/obj/item/rope/chain = 1)
	blacklist = list(/obj/item/rope/chain/bindingshackles, /obj/item/rope/chain/bindingshackles/t2, /obj/item/rope/chain/bindingshackles/t3, /obj/item/rope/chain/bindingshackles/t4, /obj/item/rope/chain/bindingshackles/t5, /obj/item/rope/chain/fake, /obj/item/rope/chain/fake/ice)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/cheele
	name = "cheele"
	result = /obj/item/natural/worms/leech/cheele
	reqs = list(/obj/item/reagent_containers/lux = 1, /obj/item/natural/worms/leech = 1)
	blacklist = list(/obj/item/natural/worms/leech/abyssoid, /obj/item/natural/worms/leech/cheele, /obj/item/reagent_containers/lux/eoran_aril)
	category = "Medicine"
	rogue_skill = /datum/attribute/skill/misc/medicine
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/cloth
	name = "cloth"
	result = /obj/item/natural/cloth
	reqs = list(/obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0
	rogue_verb = "sews"
	rogue_verb_simple = "sew"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/clothbelt
	name = "cloth belt"
	result = /obj/item/storage/belt/rogue/leather/cloth
	reqs = list(/obj/item/natural/cloth = 1)
	blacklist = list(/obj/item/natural/cloth/bandage)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "ties"
	rogue_verb_simple = "tie"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/clothblindfold
	name = "blindfold"
	result = /obj/item/clothing/mask/rogue/blindfold
	reqs = list(/obj/item/natural/cloth = 1)
	blacklist = list(/obj/item/natural/cloth/bandage)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "ties"
	rogue_verb_simple = "tie"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/clothsash
	name = "fine sash"
	result = /obj/item/storage/belt/rogue/leather/sash
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/silk = 1)
	blacklist = list(/obj/item/natural/cloth/bandage)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/custom_seal
	name = "Blank Custom Seal (1 Small Log)"
	result = /obj/item/seal/custom
	reqs = list(/obj/item/grown/log/tree/small = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	rogue_verb = "carves"
	rogue_verb_simple = "carve"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/d10
	name = "bone die (d10)"
	result = /obj/item/dice/d10
	reqs = list(/obj/item/natural/bone = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/d12
	name = "bone die (d12)"
	result = /obj/item/dice/d12
	reqs = list(/obj/item/natural/bone = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/d20
	name = "bone die (d20)"
	result = /obj/item/dice/d20
	reqs = list(/obj/item/natural/bone = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/d4
	name = "bone die (d4)"
	result = /obj/item/dice/d4
	reqs = list(/obj/item/natural/bone = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/d6
	name = "bone die (d6)"
	result = /obj/item/dice/d6
	reqs = list(/obj/item/natural/bone = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/d8
	name = "bone die (d8)"
	result = /obj/item/dice/d8
	reqs = list(/obj/item/natural/bone = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/decoratedmailledhauberk
	name = "layer a decorated cuirass atop hauberk"
	result = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/decorated
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/half/fluted/decorated = 1, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1)
	blacklist = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient/decrepit, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/atgervi, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/bronze, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/bronze/donator, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/dasfox_ranger, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/donator, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/fluted, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/fluted/robed, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/fluted/robed/grandmaster, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/gold, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/graggar, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/grenzelhoft, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/ancient, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/ancient/decrepit, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/decorated, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/donator_gothic, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/rockhill, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/donator, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/donator_gothic, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/rockhill, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/zycuirass, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/taur, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/janissary, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/matthios, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate/robed, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/taur, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/timesoldier/temperance/eb_armor, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/woodland, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/woodland/plackart, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zizo)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/decorative_mentorhat
	name = "decorative bamboo hat"
	result = /obj/item/clothing/head/roguetown/mentorhat/decorative
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/grown/log/tree/stick = 2, /obj/item/natural/fibers = 2)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/dryleaf
	name = "dry swampweed"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/swampweed = 1)
	category = "Other"
	rogue_skill = null
	rogue_structure = /obj/machinery/tanningrack
	rogue_verb = "dries"
	rogue_verb_simple = "dry"

/datum/crafting_recipe/roguetown/survival/dryrosa
	name = "dry rosa petals"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_dried
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals = 1)
	blacklist = list(/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals/azure)
	category = "Other"
	rogue_skill = null
	rogue_structure = /obj/machinery/tanningrack
	rogue_verb = "dries"
	rogue_verb_simple = "dry"

/datum/crafting_recipe/roguetown/survival/drytea
	name = "dry tea leaves"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_dry
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/tea = 1)
	category = "Other"
	rogue_skill = null
	rogue_structure = /obj/machinery/tanningrack
	rogue_verb = "dries"
	rogue_verb_simple = "dry"

/datum/crafting_recipe/roguetown/survival/dryweed
	name = "dry westleach leaf"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed = 1)
	category = "Other"
	rogue_skill = null
	rogue_structure = /obj/machinery/tanningrack
	rogue_verb = "dries"
	rogue_verb_simple = "dry"

/datum/crafting_recipe/roguetown/survival/dye_brush
	name = "dye brush"
	result = /obj/item/dye_brush
	reqs = list(/obj/item/grown/log/tree/stick = 2, /obj/item/natural/fur = 1)
	blacklist = list(/obj/item/natural/fur/bobcat, /obj/item/natural/fur/direbear, /obj/item/natural/fur/fox, /obj/item/natural/fur/goat, /obj/item/natural/fur/mole, /obj/item/natural/fur/rabbit, /obj/item/natural/fur/raccoon, /obj/item/natural/fur/rat, /obj/item/natural/fur/wolf)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/fiberfuse
	name = "fiber fuse (2 Fibers + 1 Fat)"
	result = /obj/item/cannon_fuse/fiber
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/reagent_containers/food/snacks/fat = 1)
	blacklist = list(/obj/item/reagent_containers/food/snacks/fat/salo, /obj/item/reagent_containers/food/snacks/fat/salo/slice)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/fishingcage
	name = "fishing cage"
	result = /obj/item/fishingcage
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/grown/log/tree/stick = 2)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/flowercrown_calendula
	name = "calendula crown"
	result = /obj/item/flowercrown/calendula
	reqs = list(/obj/item/alch/calendula = 4, /obj/item/natural/fibers = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "ties"
	rogue_verb_simple = "tied"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/flowercrown_manabloom
	name = "manabloom crown"
	result = /obj/item/flowercrown/manabloom
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/manabloom = 4, /obj/item/natural/fibers = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "ties"
	rogue_verb_simple = "tied"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/flowercrown_matricaria
	name = "matricaria crown"
	result = /obj/item/flowercrown/matricaria
	reqs = list(/obj/item/alch/matricaria = 4, /obj/item/natural/fibers = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "ties"
	rogue_verb_simple = "tied"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/flowercrown_rosa
	name = "rosa crown"
	result = /obj/item/flowercrown/rosa
	reqs = list(/obj/item/alch/rosa = 4, /obj/item/natural/fibers = 2)
	blacklist = list(/obj/item/alch/rosa/azure)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "ties"
	rogue_verb_simple = "tied"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/flowercrown_rosa_gray
	name = "gray flower crown"
	result = /obj/item/flowercrown/rosa/dyecrown
	reqs = list(/obj/item/natural/fibers = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "ties"
	rogue_verb_simple = "tied"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/flowercrown_rosa_thorns
	name = "rosa crown with thorns"
	result = /obj/item/flowercrown/rosa/thorns
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/natural/thorn = 2, /obj/item/alch/rosa = 3)
	blacklist = list(/obj/item/alch/rosa/azure)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "ties"
	rogue_verb_simple = "tied"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/flowercrown_salvia
	name = "salvia crown"
	result = /obj/item/flowercrown/salvia
	reqs = list(/obj/item/alch/salvia = 4, /obj/item/natural/fibers = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "ties"
	rogue_verb_simple = "tied"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/flutedmailledhauberk
	name = "layer a fluted cuirass atop hauberk"
	result = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/fluted
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/half/fluted = 1, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1)
	blacklist = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient/decrepit, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/atgervi, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/bronze, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/bronze/donator, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/dasfox_ranger, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/donator, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/fluted, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/fluted/robed, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/fluted/robed/grandmaster, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/gold, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/graggar, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/grenzelhoft, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/ancient, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/ancient/decrepit, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/decorated, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/donator_gothic, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/rockhill, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/donator, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/donator_gothic, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/rockhill, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/zycuirass, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/taur, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/janissary, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/matthios, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate/robed, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/taur, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/timesoldier/temperance/eb_armor, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/woodland, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/woodland/plackart, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zizo, /obj/item/clothing/suit/roguetown/armor/plate/half/fluted/decorated, /obj/item/clothing/suit/roguetown/armor/plate/half/fluted/ornate)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/fork
	name = "fork (x3) (1 small log)"
	result = /obj/item/kitchen/fork
	reqs = list(/obj/item/grown/log/tree/small = 1)
	rogue_results = list(/obj/item/kitchen/fork, /obj/item/kitchen/fork)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/goedendag
	name = "goedendag"
	result = /obj/item/rogueweapon/mace/goden
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/rope = 1, /obj/item/rogueweapon/hoe = 1)
	tool_paths = list(/obj/item/rogueweapon/hammer)
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/rogueweapon/hoe/aalloy, /obj/item/rogueweapon/hoe/blacksteel, /obj/item/rogueweapon/hoe/bronze, /obj/item/rogueweapon/hoe/copper, /obj/item/rogueweapon/hoe/decrepit, /obj/item/rogueweapon/hoe/stone, /obj/item/rope/chain, /obj/item/rope/chain/bindingshackles, /obj/item/rope/chain/bindingshackles/t2, /obj/item/rope/chain/bindingshackles/t3, /obj/item/rope/chain/bindingshackles/t4, /obj/item/rope/chain/bindingshackles/t5, /obj/item/rope/chain/fake, /obj/item/rope/chain/fake/ice, /obj/item/rope/inqarticles/inquirycord)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/goodluckcharm
	name = "cabbit's foot luck charm"
	result = /obj/item/clothing/neck/roguetown/luckcharm
	reqs = list(/obj/item/natural/rabbitsfoot = 1, /obj/item/natural/fibers = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/handmirror
	name = "hand mirror"
	result = /obj/item/handmirror
	reqs = list(/obj/item/natural/glass = 1, /obj/item/grown/log/tree/stick = 1)
	blacklist = list(/obj/item/natural/glass/heated)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/head_roguetown_onhelm_tw_d_basic
	name = "helm's chaperon"
	result = /obj/item/clothing/head/roguetown/onhelm/tw_d_basic
	reqs = list(/obj/item/natural/cloth = 3)
	tool_paths = list(/obj/item/needle)
	blacklist = list(/obj/item/natural/cloth/bandage)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2
	rogue_verb = "sews"
	rogue_verb_simple = "sew"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/heatershield
	name = "heater shield"
	result = /obj/item/rogueweapon/shield/heater/crafted
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/natural/hide/cured = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/improvisedclamp
	name = "improvised retractor"
	result = /obj/item/rogueweapon/surgery/retractor/improv
	reqs = list(/obj/item/natural/fibers = 1, /obj/item/grown/log/tree/stick = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/improvisedhemo
	name = "improvised clamp"
	result = /obj/item/rogueweapon/surgery/hemostat/improv
	reqs = list(/obj/item/natural/fibers = 1, /obj/item/grown/log/tree/stick = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/improvisedsaw
	name = "improvised surgery saw"
	result = /obj/item/rogueweapon/surgery/saw/improv
	reqs = list(/obj/item/natural/fibers = 1, /obj/item/natural/stone = 1, /obj/item/grown/log/tree/stick = 1)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/improvisedscalpel
	name = "improvised scalpel"
	result = /obj/item/rogueweapon/surgery/scalpel/improv
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/grown/log/tree/stick = 2, /obj/item/natural/whetstone = 1, /obj/item/natural/stone = 1)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/kneaded_clay
	name = "kneaded clay"
	result = /obj/item/natural/clay/kneaded
	reqs = list(/obj/item/natural/clay = 2, /datum/reagent/water = 2)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/longbow
	name = "long bow"
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
	reqs = list(/obj/item/natural/bowstring = 1, /obj/item/grown/log/tree/bowpartial/longbow = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 4
	rogue_verb = "strings together"
	rogue_verb_simple = "string together"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/longbow_warden
	name = "blackhorn longbow"
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/warden
	reqs = list(/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow = 1, /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/warden = 1)
	blacklist = list(/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/eora, /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/towner, /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/warden)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2
	rogue_verb = "re-strings"
	rogue_verb_simple = "re-string"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/longbowpartial
	name = "unstrung long bow"
	result = /obj/item/grown/log/tree/bowpartial/longbow
	reqs = list(/obj/item/grown/log/tree = 1, /obj/item/natural/cloth = 1, /obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	blacklist = list(/obj/item/grown/log/tree/bowpartial, /obj/item/grown/log/tree/bowpartial/longbow, /obj/item/grown/log/tree/bowpartial/recurve, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small/essence, /obj/item/grown/log/tree/stake, /obj/item/grown/log/tree/stick, /obj/item/natural/cloth/bandage, /obj/item/reagent_containers/food/snacks/tallow/black, /obj/item/reagent_containers/food/snacks/tallow/red, /obj/item/reagent_containers/food/snacks/tallow/soft)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 4
	rogue_verb = "carves"
	rogue_verb_simple = "carve"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/mantrap
	name = "mantrap"
	result = /obj/item/restraints/legcuffs/beartrap
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/fibers = 2, /obj/item/ingot/iron = 1)
	rogue_results = list(/obj/item/restraints/legcuffs/beartrap)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_verb = "puts together"
	rogue_verb_simple = "put together"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/mentorhat
	name = "worn bamboo hat"
	result = /obj/item/clothing/head/roguetown/mentorhat
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/grown/log/tree/stick = 2, /obj/item/natural/fibers = 2)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/mortar
	name = "alchemical mortar"
	result = /obj/item/reagent_containers/glass/mortar
	reqs = list(/obj/item/natural/stone = 1)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/net
	name = "net"
	result = /obj/item/net
	reqs = list(/obj/item/rope = 2, /obj/item/natural/stone = 3)
	blacklist = list(/obj/item/natural/stone/sending, /obj/item/rope/chain, /obj/item/rope/chain/bindingshackles, /obj/item/rope/chain/bindingshackles/t2, /obj/item/rope/chain/bindingshackles/t3, /obj/item/rope/chain/bindingshackles/t4, /obj/item/rope/chain/bindingshackles/t5, /obj/item/rope/chain/fake, /obj/item/rope/chain/fake/ice, /obj/item/rope/inqarticles/inquirycord)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2
	rogue_verb = "braids"
	rogue_verb_simple = "braid"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/oar
	name = "Oar (1 Log, 2 Fibers)"
	result = /obj/item/rogueweapon/mace/oar
	reqs = list(/obj/item/grown/log/tree = 1, /obj/item/natural/fibers = 2)
	blacklist = list(/obj/item/grown/log/tree/bowpartial, /obj/item/grown/log/tree/bowpartial/longbow, /obj/item/grown/log/tree/bowpartial/recurve, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small/essence, /obj/item/grown/log/tree/stake, /obj/item/grown/log/tree/stick)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/ornatemailledhauberk
	name = "layer a psydonic cuirass atop hauberk"
	result = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/half/fluted/ornate = 1, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1)
	blacklist = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient/decrepit, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/atgervi, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/bronze, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/bronze/donator, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/dasfox_ranger, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/donator, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/fluted, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/fluted/robed, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/fluted/robed/grandmaster, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/gold, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/graggar, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/grenzelhoft, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/ancient, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/ancient/decrepit, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/decorated, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/donator_gothic, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/rockhill, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/donator, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/donator_gothic, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/rockhill, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/zycuirass, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/taur, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/janissary, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/matthios, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate/robed, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/taur, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/timesoldier/temperance/eb_armor, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/woodland, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/woodland/plackart, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zizo)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/paperscroll
	name = "scroll of parchment (x3)"
	result = /obj/item/paper/scroll
	reqs = list(/obj/item/grown/log/tree/small = 1, /datum/reagent/water = 48)
	rogue_results = list(/obj/item/paper/scroll, /obj/item/paper/scroll)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_structure = /obj/machinery/tanningrack
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/parchmentfuse
	name = "parchment fuse (2 Parchment + 1 Fat)"
	result = /obj/item/cannon_fuse/parchment
	reqs = list(/obj/item/paper/parchment = 2, /obj/item/reagent_containers/food/snacks/fat = 1)
	blacklist = list(/obj/item/reagent_containers/food/snacks/fat/salo, /obj/item/reagent_containers/food/snacks/fat/salo/slice)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/pearlcross
	name = "amulet (pearls)"
	result = /obj/item/clothing/neck/roguetown/psicross/pearl
	reqs = list(/obj/item/natural/fibers = 1, /obj/item/pearl = 3)
	blacklist = list(/obj/item/pearl/blue)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/peasantry/goedendag
	name = "militia goedendag"
	result = /obj/item/rogueweapon/woodstaff/militia
	reqs = list(/obj/item/rogueweapon/woodstaff = 1, /obj/item/natural/whetstone = 2, /obj/item/rope = 1)
	tool_paths = list(/obj/item/rogueweapon/hammer)
	blacklist = list(/obj/item/rope/chain, /obj/item/rope/chain/bindingshackles, /obj/item/rope/chain/bindingshackles/t2, /obj/item/rope/chain/bindingshackles/t3, /obj/item/rope/chain/bindingshackles/t4, /obj/item/rope/chain/bindingshackles/t5, /obj/item/rope/chain/fake, /obj/item/rope/chain/fake/ice, /obj/item/rope/inqarticles/inquirycord)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/peasantry/waraxe
	name = "militia shovel-waraxe"
	result = /obj/item/rogueweapon/greataxe/militia
	reqs = list(/obj/item/rogueweapon/shovel = 1, /obj/item/grown/log/tree/small = 2, /obj/item/rope = 1)
	tool_paths = list(/obj/item/rogueweapon/hammer)
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/rogueweapon/shovel/aalloy, /obj/item/rogueweapon/shovel/blacksteel, /obj/item/rogueweapon/shovel/bronze, /obj/item/rogueweapon/shovel/bronze/spade, /obj/item/rogueweapon/shovel/decrepit, /obj/item/rogueweapon/shovel/mort_staff, /obj/item/rogueweapon/shovel/saperka, /obj/item/rogueweapon/shovel/silver, /obj/item/rogueweapon/shovel/small, /obj/item/rogueweapon/shovel/small/crafted, /obj/item/rogueweapon/shovel/zoe_silence, /obj/item/rope/chain, /obj/item/rope/chain/bindingshackles, /obj/item/rope/chain/bindingshackles/t2, /obj/item/rope/chain/bindingshackles/t3, /obj/item/rope/chain/bindingshackles/t4, /obj/item/rope/chain/bindingshackles/t5, /obj/item/rope/chain/fake, /obj/item/rope/chain/fake/ice, /obj/item/rope/inqarticles/inquirycord)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/peasantry/waraxe/silver
	name = "silver militia shovelaxe"
	result = /obj/item/rogueweapon/greataxe/militia/silver
	reqs = list(/obj/item/rogueweapon/shovel/silver = 1, /obj/item/grown/log/tree/small = 2, /obj/item/rope = 1)
	rogue_results = null
	tool_paths = list(/obj/item/rogueweapon/hammer)
	parts = null
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/rope/chain, /obj/item/rope/chain/bindingshackles, /obj/item/rope/chain/bindingshackles/t2, /obj/item/rope/chain/bindingshackles/t3, /obj/item/rope/chain/bindingshackles/t4, /obj/item/rope/chain/bindingshackles/t5, /obj/item/rope/chain/fake, /obj/item/rope/chain/fake/ice, /obj/item/rope/inqarticles/inquirycord)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_structure = null
	rogue_on_table = TRUE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/survival/peasantry/warflail
	name = "militia flail"
	result = /obj/item/rogueweapon/flail/militia
	reqs = list(/obj/item/natural/whetstone = 2, /obj/item/rogueweapon/thresher = 1)
	tool_paths = list(/obj/item/rogueweapon/hammer)
	blacklist = list(/obj/item/rogueweapon/thresher/aalloy, /obj/item/rogueweapon/thresher/blacksteel, /obj/item/rogueweapon/thresher/bronze, /obj/item/rogueweapon/thresher/decrepit)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/peasantry/warpick
	name = "militia warpick"
	result = /obj/item/rogueweapon/pick/militia
	reqs = list(/obj/item/rogueweapon/pick = 1, /obj/item/natural/whetstone = 1)
	tool_paths = list(/obj/item/rogueweapon/hammer)
	blacklist = list(/obj/item/rogueweapon/pick/aalloy, /obj/item/rogueweapon/pick/blacksteel, /obj/item/rogueweapon/pick/bronze, /obj/item/rogueweapon/pick/copper, /obj/item/rogueweapon/pick/decrepit, /obj/item/rogueweapon/pick/militia, /obj/item/rogueweapon/pick/militia/steel, /obj/item/rogueweapon/pick/militia/steel/warpick, /obj/item/rogueweapon/pick/paalloy, /obj/item/rogueweapon/pick/steel, /obj/item/rogueweapon/pick/stone, /obj/item/rogueweapon/pick/woodcutter/dolabra, /obj/item/rogueweapon/pick/woodcutter/dolabra/albranze, /obj/item/rogueweapon/pick/woodcutter/dolabra/blacksteel, /obj/item/rogueweapon/pick/woodcutter/dolabra/pioneer)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/peasantry/warpick_steel
	name = "militia steel warpick "
	result = /obj/item/rogueweapon/pick/militia/steel
	reqs = list(/obj/item/rogueweapon/pick/steel = 1, /obj/item/natural/whetstone = 1)
	tool_paths = list(/obj/item/rogueweapon/hammer)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/peasantry/warspear_pitchfork
	name = "militia warspear"
	result = /obj/item/rogueweapon/spear/militia
	reqs = list(/obj/item/rogueweapon/pitchfork = 1, /obj/item/grown/log/tree/small = 2, /obj/item/rope = 1)
	tool_paths = list(/obj/item/rogueweapon/hammer)
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/rogueweapon/pitchfork/aalloy, /obj/item/rogueweapon/pitchfork/blacksteel, /obj/item/rogueweapon/pitchfork/bronze, /obj/item/rogueweapon/pitchfork/copper, /obj/item/rogueweapon/pitchfork/decrepit, /obj/item/rope/chain, /obj/item/rope/chain/bindingshackles, /obj/item/rope/chain/bindingshackles/t2, /obj/item/rope/chain/bindingshackles/t3, /obj/item/rope/chain/bindingshackles/t4, /obj/item/rope/chain/bindingshackles/t5, /obj/item/rope/chain/fake, /obj/item/rope/chain/fake/ice, /obj/item/rope/inqarticles/inquirycord)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/pestle
	name = "stone pestle"
	result = /obj/item/pestle/rogue
	reqs = list(/obj/item/natural/stone = 1)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/pipe
	name = "wood pipe"
	result = /obj/item/clothing/mask/cigarette/pipe/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/platter
	name = "platter (x2) (1 small log)"
	result = /obj/item/cooking/platter
	reqs = list(/obj/item/grown/log/tree/small = 1)
	rogue_results = list(/obj/item/cooking/platter)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/poisonarrow
	name = "poisoned arrow"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/poison
	reqs = list(/obj/item/ammo_casing/caseless/rogue/arrow/iron = 1, /datum/reagent/stampoison = 5)
	blacklist = list(/obj/item/ammo_casing/caseless/rogue/arrow/iron/aalloy, /obj/item/ammo_casing/caseless/rogue/arrow/iron/conjured, /obj/item/ammo_casing/caseless/rogue/arrow/iron/decrepit, /obj/item/ammo_casing/caseless/rogue/arrow/iron/paint)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/poisonarrow_five
	name = "poisoned arrow (x5)"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/poison
	reqs = list(/obj/item/ammo_casing/caseless/rogue/arrow/iron = 5, /datum/reagent/stampoison = 25)
	rogue_results = list(/obj/item/ammo_casing/caseless/rogue/arrow/poison, /obj/item/ammo_casing/caseless/rogue/arrow/poison, /obj/item/ammo_casing/caseless/rogue/arrow/poison, /obj/item/ammo_casing/caseless/rogue/arrow/poison)
	blacklist = list(/obj/item/ammo_casing/caseless/rogue/arrow/iron/aalloy, /obj/item/ammo_casing/caseless/rogue/arrow/iron/conjured, /obj/item/ammo_casing/caseless/rogue/arrow/iron/decrepit, /obj/item/ammo_casing/caseless/rogue/arrow/iron/paint)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/poisonarrow_five_stone
	name = "poisoned stone arrow (x5)"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/stone/poison
	reqs = list(/obj/item/ammo_casing/caseless/rogue/arrow/stone = 5, /datum/reagent/stampoison = 25)
	rogue_results = list(/obj/item/ammo_casing/caseless/rogue/arrow/stone/poison, /obj/item/ammo_casing/caseless/rogue/arrow/stone/poison, /obj/item/ammo_casing/caseless/rogue/arrow/stone/poison, /obj/item/ammo_casing/caseless/rogue/arrow/stone/poison)
	blacklist = list(/obj/item/ammo_casing/caseless/rogue/arrow/stone/poison)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/poisonarrow_stone
	name = "poisoned stone arrow"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/stone/poison
	reqs = list(/obj/item/ammo_casing/caseless/rogue/arrow/stone = 1, /datum/reagent/stampoison = 5)
	blacklist = list(/obj/item/ammo_casing/caseless/rogue/arrow/stone/poison)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/pot
	name = "stone pot (2 stones)"
	result = /obj/item/reagent_containers/glass/bucket/pot/stone
	reqs = list(/obj/item/natural/stone = 2)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/prosthetic/woodleftarm
	name = "wood arm (L)"
	result = /obj/item/bodypart/l_arm/prosthetic/woodleft
	reqs = list(/obj/item/grown/log/tree/small = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/prosthetic/woodleftleft
	name = "wood leg (L)"
	result = /obj/item/bodypart/l_leg/prosthetic
	reqs = list(/obj/item/grown/log/tree/small = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/prosthetic/woodrightarm
	name = "wood arm (R)"
	result = /obj/item/bodypart/r_arm/prosthetic/woodright
	reqs = list(/obj/item/grown/log/tree/small = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/prosthetic/woodrightleg
	name = "wood leg (R)"
	result = /obj/item/bodypart/r_leg/prosthetic
	reqs = list(/obj/item/grown/log/tree/small = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/purify_lux
	name = "purifiy lux"
	result = /obj/item/heart_blood_canister
	reqs = list(/obj/item/reagent_containers/lux_impure = 1, /obj/item/heart_blood_canister/filled = 1)
	rogue_results = list(/obj/item/reagent_containers/lux)
	category = "Medicine"
	rogue_skill = /datum/attribute/skill/misc/medicine
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/purify_lux_compress
	name = "purifiy lux (compression)"
	result = /obj/item/reagent_containers/lux
	reqs = list(/obj/item/reagent_containers/lux_impure = 2)
	category = "Medicine"
	rogue_skill = /datum/attribute/skill/misc/medicine
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/purify_lux_vials
	name = "purifiy lux (vials)"
	result = /obj/item/reagent_containers/lux
	reqs = list(/obj/item/reagent_containers/lux_impure = 1, /obj/item/heart_blood_vial/filled = 3)
	rogue_results = list(/obj/item/heart_blood_vial, /obj/item/heart_blood_vial, /obj/item/heart_blood_vial)
	category = "Medicine"
	rogue_skill = /datum/attribute/skill/misc/medicine
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/quarterstaff
	name = "quarterstaff"
	result = /obj/item/rogueweapon/woodstaff/quarterstaff
	reqs = list(/obj/item/grown/log/tree = 1)
	blacklist = list(/obj/item/grown/log/tree/bowpartial, /obj/item/grown/log/tree/bowpartial/longbow, /obj/item/grown/log/tree/bowpartial/recurve, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small/essence, /obj/item/grown/log/tree/stake, /obj/item/grown/log/tree/stick)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/quarterstaff_iron
	name = "iron-reinforced quarterstaff"
	result = /obj/item/rogueweapon/woodstaff/quarterstaff/iron
	reqs = list(/obj/item/rogueweapon/woodstaff/quarterstaff = 1, /obj/item/ingot/iron = 1)
	blacklist = list(/obj/item/rogueweapon/woodstaff/quarterstaff/blacksteel, /obj/item/rogueweapon/woodstaff/quarterstaff/bombard_sponge, /obj/item/rogueweapon/woodstaff/quarterstaff/bostaff, /obj/item/rogueweapon/woodstaff/quarterstaff/gold, /obj/item/rogueweapon/woodstaff/quarterstaff/iron, /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter, /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter/warden, /obj/item/rogueweapon/woodstaff/quarterstaff/psy, /obj/item/rogueweapon/woodstaff/quarterstaff/silver, /obj/item/rogueweapon/woodstaff/quarterstaff/steel, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/astrata, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/donator_elegant, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/holysee, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/noc, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/silver, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/silver/psy, /obj/item/rogueweapon/woodstaff/quarterstaff/virtue)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/quarterstaff_psydonic
	name = "psydonic silver-reinforced quarterstaff"
	result = /obj/item/rogueweapon/woodstaff/quarterstaff/psy
	reqs = list(/obj/item/rogueweapon/woodstaff/quarterstaff = 1, /obj/item/ingot/silverblessed = 1)
	blacklist = list(/obj/item/ingot/silverblessed/bullion, /obj/item/rogueweapon/woodstaff/quarterstaff/blacksteel, /obj/item/rogueweapon/woodstaff/quarterstaff/bombard_sponge, /obj/item/rogueweapon/woodstaff/quarterstaff/bostaff, /obj/item/rogueweapon/woodstaff/quarterstaff/gold, /obj/item/rogueweapon/woodstaff/quarterstaff/iron, /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter, /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter/warden, /obj/item/rogueweapon/woodstaff/quarterstaff/psy, /obj/item/rogueweapon/woodstaff/quarterstaff/silver, /obj/item/rogueweapon/woodstaff/quarterstaff/steel, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/astrata, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/donator_elegant, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/holysee, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/noc, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/silver, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/silver/psy, /obj/item/rogueweapon/woodstaff/quarterstaff/virtue)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/quarterstaff_psydonic/bullion
	name = "psydonic silver-reinforced quarterstaff"
	result = /obj/item/rogueweapon/woodstaff/quarterstaff/psy
	reqs = list(/obj/item/rogueweapon/woodstaff/quarterstaff = 1, /obj/item/ingot/silverblessed/bullion = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = list(/obj/item/rogueweapon/woodstaff/quarterstaff/blacksteel, /obj/item/rogueweapon/woodstaff/quarterstaff/bombard_sponge, /obj/item/rogueweapon/woodstaff/quarterstaff/bostaff, /obj/item/rogueweapon/woodstaff/quarterstaff/gold, /obj/item/rogueweapon/woodstaff/quarterstaff/iron, /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter, /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter/warden, /obj/item/rogueweapon/woodstaff/quarterstaff/psy, /obj/item/rogueweapon/woodstaff/quarterstaff/silver, /obj/item/rogueweapon/woodstaff/quarterstaff/steel, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/astrata, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/donator_elegant, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/holysee, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/noc, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/silver, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/silver/psy, /obj/item/rogueweapon/woodstaff/quarterstaff/virtue)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 5
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/survival/quarterstaff_silver
	name = "silver-reinforced quarterstaff"
	result = /obj/item/rogueweapon/woodstaff/quarterstaff/silver
	reqs = list(/obj/item/rogueweapon/woodstaff/quarterstaff = 1, /obj/item/ingot/silver = 1)
	blacklist = list(/obj/item/rogueweapon/woodstaff/quarterstaff/blacksteel, /obj/item/rogueweapon/woodstaff/quarterstaff/bombard_sponge, /obj/item/rogueweapon/woodstaff/quarterstaff/bostaff, /obj/item/rogueweapon/woodstaff/quarterstaff/gold, /obj/item/rogueweapon/woodstaff/quarterstaff/iron, /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter, /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter/warden, /obj/item/rogueweapon/woodstaff/quarterstaff/psy, /obj/item/rogueweapon/woodstaff/quarterstaff/silver, /obj/item/rogueweapon/woodstaff/quarterstaff/steel, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/astrata, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/donator_elegant, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/holysee, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/noc, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/silver, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/silver/psy, /obj/item/rogueweapon/woodstaff/quarterstaff/virtue)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/quarterstaff_steel
	name = "steel-reinforced quarterstaff"
	result = /obj/item/rogueweapon/woodstaff/quarterstaff/steel
	reqs = list(/obj/item/rogueweapon/woodstaff/quarterstaff = 1, /obj/item/ingot/steel = 1)
	blacklist = list(/obj/item/ingot/steel/zizo, /obj/item/rogueweapon/woodstaff/quarterstaff/blacksteel, /obj/item/rogueweapon/woodstaff/quarterstaff/bombard_sponge, /obj/item/rogueweapon/woodstaff/quarterstaff/bostaff, /obj/item/rogueweapon/woodstaff/quarterstaff/gold, /obj/item/rogueweapon/woodstaff/quarterstaff/iron, /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter, /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter/warden, /obj/item/rogueweapon/woodstaff/quarterstaff/psy, /obj/item/rogueweapon/woodstaff/quarterstaff/silver, /obj/item/rogueweapon/woodstaff/quarterstaff/steel, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/astrata, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/donator_elegant, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/holysee, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/noc, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/silver, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/silver/psy, /obj/item/rogueweapon/woodstaff/quarterstaff/virtue)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/ration_wrapper
	name = "ration wrapping paper (x2)"
	result = /obj/item/ration
	reqs = list(/obj/item/paper/parchment = 1, /obj/item/reagent_containers/food/snacks/tallow = 1)
	rogue_results = list(/obj/item/ration)
	blacklist = list(/obj/item/reagent_containers/food/snacks/tallow/black, /obj/item/reagent_containers/food/snacks/tallow/red, /obj/item/reagent_containers/food/snacks/tallow/soft)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/recurvebow
	name = "recurve bow"
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	reqs = list(/obj/item/natural/bowstring = 1, /obj/item/grown/log/tree/bowpartial/recurve = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	rogue_verb = "strings together"
	rogue_verb_simple = "string together"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/recurvepartial
	name = "unstrung recurve bow"
	result = /obj/item/grown/log/tree/bowpartial/recurve
	reqs = list(/obj/item/grown/log/tree = 1, /obj/item/natural/bone = 2, /obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	blacklist = list(/obj/item/grown/log/tree/bowpartial, /obj/item/grown/log/tree/bowpartial/longbow, /obj/item/grown/log/tree/bowpartial/recurve, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small/essence, /obj/item/grown/log/tree/stake, /obj/item/grown/log/tree/stick, /obj/item/reagent_containers/food/snacks/tallow/black, /obj/item/reagent_containers/food/snacks/tallow/red, /obj/item/reagent_containers/food/snacks/tallow/soft)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	rogue_verb = "carves"
	rogue_verb_simple = "carve"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/repairkitcloth
	name = "sewing kit"
	result = /obj/item/repair_kit
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/hide/cured = 2)
	blacklist = list(/obj/item/natural/cloth/bandage)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/repairkitclothbad
	name = "fabric patch"
	result = /obj/item/repair_kit/bad
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2, /obj/item/rope = 1)
	blacklist = list(/obj/item/natural/cloth/bandage, /obj/item/rope/chain, /obj/item/rope/chain/bindingshackles, /obj/item/rope/chain/bindingshackles/t2, /obj/item/rope/chain/bindingshackles/t3, /obj/item/rope/chain/bindingshackles/t4, /obj/item/rope/chain/bindingshackles/t5, /obj/item/rope/chain/fake, /obj/item/rope/chain/fake/ice, /obj/item/rope/inqarticles/inquirycord)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/repairkitmetalingot
	name = "empty metal repair kit (iron bar)"
	result = /obj/item/armorkit_empty
	reqs = list(/obj/item/ingot/iron = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/repairkitmetalscrap
	name = "empty metal repair kit (iron scrap)"
	result = /obj/item/armorkit_empty
	reqs = list(/obj/item/scrap = 3)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/rocknutdry
	name = "rocknut zig"
	result = /obj/item/clothing/mask/cigarette/rollie/nicotine
	reqs = list(/obj/item/reagent_containers/powder/rocknut = 1, /obj/item/paper/parchment = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "rolls"
	rogue_verb_simple = "roll"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/rod
	name = "fishing rod"
	result = /obj/item/fishingrod/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/fibers = 2)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/rollingpin
	name = "rollingpin (1 small log)"
	result = /obj/item/kitchen/rollingpin
	reqs = list(/obj/item/grown/log/tree/small = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/rope
	name = "rope"
	result = /obj/item/rope
	reqs = list(/obj/item/natural/fibers = 3)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "braids"
	rogue_verb_simple = "braid"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/rope_leash
	name = "rope leash"
	result = /obj/item/leash
	reqs = list(/obj/item/rope = 1)
	tool_paths = list(/obj/item/needle)
	blacklist = list(/obj/item/rope/chain, /obj/item/rope/chain/bindingshackles, /obj/item/rope/chain/bindingshackles/t2, /obj/item/rope/chain/bindingshackles/t3, /obj/item/rope/chain/bindingshackles/t4, /obj/item/rope/chain/bindingshackles/t5, /obj/item/rope/chain/fake, /obj/item/rope/chain/fake/ice, /obj/item/rope/inqarticles/inquirycord)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "sews"
	rogue_verb_simple = "sew"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/ropebelt
	name = "rope belt"
	result = /obj/item/storage/belt/rogue/leather/rope
	reqs = list(/obj/item/rope = 1)
	blacklist = list(/obj/item/rope/chain, /obj/item/rope/chain/bindingshackles, /obj/item/rope/chain/bindingshackles/t2, /obj/item/rope/chain/bindingshackles/t3, /obj/item/rope/chain/bindingshackles/t4, /obj/item/rope/chain/bindingshackles/t5, /obj/item/rope/chain/fake, /obj/item/rope/chain/fake/ice, /obj/item/rope/inqarticles/inquirycord)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "ties"
	rogue_verb_simple = "tie"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/rucksack
	name = "rucksack"
	result = /obj/item/storage/backpack/rogue/backpack/bagpack
	reqs = list(/obj/item/storage/roguebag = 1, /obj/item/rope = 1)
	blacklist = list(/obj/item/rope/chain, /obj/item/rope/chain/bindingshackles, /obj/item/rope/chain/bindingshackles/t2, /obj/item/rope/chain/bindingshackles/t3, /obj/item/rope/chain/bindingshackles/t4, /obj/item/rope/chain/bindingshackles/t5, /obj/item/rope/chain/fake, /obj/item/rope/chain/fake/ice, /obj/item/rope/inqarticles/inquirycord, /obj/item/storage/roguebag/ash, /obj/item/storage/roguebag/crafted, /obj/item/storage/roguebag/farmer_berries, /obj/item/storage/roguebag/farmer_fruits, /obj/item/storage/roguebag/farmer_naledi, /obj/item/storage/roguebag/farmer_rocknut, /obj/item/storage/roguebag/farmer_smokes, /obj/item/storage/roguebag/fetish, /obj/item/storage/roguebag/food, /obj/item/storage/roguebag/gambling_kit_bundle, /obj/item/storage/roguebag/heartfelt/armorer, /obj/item/storage/roguebag/leechbait, /obj/item/storage/roguebag/slaver/master, /obj/item/storage/roguebag/trans)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/rucksack/crafted
	name = "rucksack"
	result = /obj/item/storage/backpack/rogue/backpack/bagpack
	reqs = list(/obj/item/storage/roguebag = 1, /obj/item/rope = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = list(/obj/item/rope/chain, /obj/item/rope/chain/bindingshackles, /obj/item/rope/chain/bindingshackles/t2, /obj/item/rope/chain/bindingshackles/t3, /obj/item/rope/chain/bindingshackles/t4, /obj/item/rope/chain/bindingshackles/t5, /obj/item/rope/chain/fake, /obj/item/rope/chain/fake/ice, /obj/item/rope/inqarticles/inquirycord, /obj/item/storage/roguebag/ash, /obj/item/storage/roguebag/crafted, /obj/item/storage/roguebag/farmer_berries, /obj/item/storage/roguebag/farmer_fruits, /obj/item/storage/roguebag/farmer_naledi, /obj/item/storage/roguebag/farmer_rocknut, /obj/item/storage/roguebag/farmer_smokes, /obj/item/storage/roguebag/fetish, /obj/item/storage/roguebag/food, /obj/item/storage/roguebag/gambling_kit_bundle, /obj/item/storage/roguebag/heartfelt/armorer, /obj/item/storage/roguebag/leechbait, /obj/item/storage/roguebag/slaver/master, /obj/item/storage/roguebag/trans)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/survival/shellbracelet
	name = "shell bracelet"
	result = /obj/item/clothing/neck/roguetown/psicross/shell/bracelet
	reqs = list(/obj/item/oystershell = 3, /obj/item/natural/fibers = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/shellnecklace
	name = "shell necklace"
	result = /obj/item/clothing/neck/roguetown/psicross/shell
	reqs = list(/obj/item/oystershell = 5, /obj/item/natural/fibers = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/sigdry
	name = "westleach zig"
	result = /obj/item/clothing/mask/cigarette/rollie/nicotine
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1, /obj/item/paper/parchment = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "rolls"
	rogue_verb_simple = "roll"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/sigdry/cheroot
	name = "westleach cheroot"
	result = /obj/item/clothing/mask/cigarette/rollie/nicotine/cheroot
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1, /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "rolls"
	rogue_verb_simple = "roll"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/survival/sigsweet
	name = "swampweed zig"
	result = /obj/item/clothing/mask/cigarette/rollie/cannabis
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry = 1, /obj/item/paper/parchment = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "rolls"
	rogue_verb_simple = "roll"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/sigsweet/cheroot
	name = "swampweed cheroot"
	result = /obj/item/clothing/mask/cigarette/rollie/cannabis/cheroot
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry = 1, /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "rolls"
	rogue_verb_simple = "roll"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/survival/skullmask
	name = "skull mask"
	result = /obj/item/clothing/mask/rogue/skullmask
	reqs = list(/obj/item/natural/bone = 3, /obj/item/natural/fibers = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "crafted"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/slingcraft
	name = "sling"
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
	reqs = list(/obj/item/natural/fibers = 6)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "twists"
	rogue_verb_simple = "twist"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/slingpouchcraft
	name = "sling bullet pouch"
	result = /obj/item/quiver/sling
	reqs = list(/obj/item/natural/fibers = 1, /obj/item/natural/cloth = 1)
	blacklist = list(/obj/item/natural/cloth/bandage)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/soap
	name = "soap (3x) (1 tallow)"
	result = /obj/item/soap
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 1)
	rogue_results = list(/obj/item/soap, /obj/item/soap)
	blacklist = list(/obj/item/reagent_containers/food/snacks/tallow/black, /obj/item/reagent_containers/food/snacks/tallow/red, /obj/item/reagent_containers/food/snacks/tallow/soft)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/spoon
	name = "spoon (x3) (1 small log)"
	result = /obj/item/kitchen/spoon
	reqs = list(/obj/item/grown/log/tree/small = 1)
	rogue_results = list(/obj/item/kitchen/spoon, /obj/item/kitchen/spoon)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/stonearrow
	name = "stone arrow"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/stone
	reqs = list(/obj/item/grown/log/tree/stick = 1, /obj/item/natural/stone = 1)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/stonearrow_five
	name = "stone arrow (x5)"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/stone
	reqs = list(/obj/item/grown/log/tree/stick = 5, /obj/item/natural/stone = 5)
	rogue_results = list(/obj/item/ammo_casing/caseless/rogue/arrow/stone, /obj/item/ammo_casing/caseless/rogue/arrow/stone, /obj/item/ammo_casing/caseless/rogue/arrow/stone, /obj/item/ammo_casing/caseless/rogue/arrow/stone)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/stoneaxe
	name = "stone axe"
	result = /obj/item/rogueweapon/stoneaxe
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/stone = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/stonebullets
	name = "sling bullets - stone (x2)"
	result = /obj/item/ammo_casing/caseless/rogue/sling_bullet/stone
	reqs = list(/obj/item/natural/stone = 1)
	rogue_results = list(/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "smooths"
	rogue_verb_simple = "smooth"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/stonebullets10x
	name = "sling bullets - stone (x10)"
	result = /obj/item/ammo_casing/caseless/rogue/sling_bullet/stone
	reqs = list(/obj/item/natural/stone = 5)
	rogue_results = list(/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone, /obj/item/ammo_casing/caseless/rogue/sling_bullet/stone, /obj/item/ammo_casing/caseless/rogue/sling_bullet/stone, /obj/item/ammo_casing/caseless/rogue/sling_bullet/stone, /obj/item/ammo_casing/caseless/rogue/sling_bullet/stone, /obj/item/ammo_casing/caseless/rogue/sling_bullet/stone, /obj/item/ammo_casing/caseless/rogue/sling_bullet/stone, /obj/item/ammo_casing/caseless/rogue/sling_bullet/stone, /obj/item/ammo_casing/caseless/rogue/sling_bullet/stone)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "smooths"
	rogue_verb_simple = "smooth"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/stonehammer
	name = "stone hammer"
	result = /obj/item/rogueweapon/hammer/stone
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/stone = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/stonehoe
	name = "stone hoe"
	result = /obj/item/rogueweapon/hoe/stone
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/natural/fibers = 1, /obj/item/natural/stone = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/stoneknife
	name = "stone knife"
	result = /obj/item/rogueweapon/huntingknife/stoneknife
	reqs = list(/obj/item/grown/log/tree/stick = 1, /obj/item/natural/stone = 1)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/stonepick
	name = "stone pick"
	result = /obj/item/rogueweapon/pick/stone
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/stone = 2)
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/stonespear
	name = "stone spear"
	result = /obj/item/rogueweapon/spear/stone
	reqs = list(/obj/item/rogueweapon/woodstaff = 1, /obj/item/natural/stone = 1)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/stonesword
	name = "stone sword"
	result = /obj/item/rogueweapon/sword/stone
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/fibers = 1, /obj/item/natural/stone = 3)
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/stonetongs
	name = "stone tongs"
	result = /obj/item/rogueweapon/tongs/stone
	reqs = list(/obj/item/grown/log/tree/stick = 2, /obj/item/natural/stone = 1)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/strucrepairkit
	name = "Structure Repair Kit"
	result = /obj/item/construction/repairkit/structure
	reqs = list(/obj/item/construction/nail = 3, /obj/item/natural/wood/plank = 3, /obj/item/natural/stoneblock = 3)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 5
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/tarot_deck
	name = "tarot deck"
	result = /obj/item/toy/cards/deck/tarot
	reqs = list(/obj/item/paper/scroll = 3, /obj/item/grown/log/tree/small = 1, /obj/item/ash = 1)
	tool_paths = list(/obj/item/natural/feather)
	blacklist = list(/obj/item/ash/snappop_phoenix, /obj/item/grown/log/tree/small/essence, /obj/item/paper/scroll/bounty, /obj/item/paper/scroll/cargo, /obj/item/paper/scroll/custom, /obj/item/paper/scroll/fake_evidence, /obj/item/paper/scroll/grudge, /obj/item/paper/scroll/ministry_writ, /obj/item/paper/scroll/sell_price_changes, /obj/item/paper/scroll/trade_requests, /obj/item/paper/scroll/writ_of_esteem, /obj/item/paper/scroll/writ_of_esteem/grenzel, /obj/item/paper/scroll/writ_of_esteem/otavan, /obj/item/paper/scroll/writ_of_esteem/zybantine)
	category = "Literacy"
	rogue_skill = /datum/attribute/skill/misc/reading
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/tarot_deck_majorarcana
	name = "tarot deck (major arcana)"
	result = /obj/item/toy/cards/deck/tarot/majorarcana
	reqs = list(/obj/item/paper/scroll = 3, /obj/item/grown/log/tree/small = 1, /obj/item/ash = 1)
	tool_paths = list(/obj/item/natural/feather)
	blacklist = list(/obj/item/ash/snappop_phoenix, /obj/item/grown/log/tree/small/essence, /obj/item/paper/scroll/bounty, /obj/item/paper/scroll/cargo, /obj/item/paper/scroll/custom, /obj/item/paper/scroll/fake_evidence, /obj/item/paper/scroll/grudge, /obj/item/paper/scroll/ministry_writ, /obj/item/paper/scroll/sell_price_changes, /obj/item/paper/scroll/trade_requests, /obj/item/paper/scroll/writ_of_esteem, /obj/item/paper/scroll/writ_of_esteem/grenzel, /obj/item/paper/scroll/writ_of_esteem/otavan, /obj/item/paper/scroll/writ_of_esteem/zybantine)
	category = "Literacy"
	rogue_skill = /datum/attribute/skill/misc/reading
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/tneedle
	name = "sewing needle"
	result = /obj/item/needle/thorn
	reqs = list(/obj/item/natural/thorn = 1, /obj/item/natural/fibers = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/torch
	name = "torch"
	result = /obj/item/flashlight/flare/torch
	reqs = list(/obj/item/grown/log/tree/stick = 1, /obj/item/natural/fibers = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/tribalrags
	name = "tribal rags"
	result = /obj/item/clothing/suit/roguetown/shirt/tribalrag
	reqs = list(/obj/item/natural/hide = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	blacklist = list(/obj/item/natural/hide/cured)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0
	rogue_verb = "sews"
	rogue_verb_simple = "sew"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/unclothbelt
	name = "untie cloth belt"
	result = /obj/item/natural/cloth
	reqs = list(/obj/item/storage/belt/rogue/leather/cloth = 1)
	blacklist = list(/obj/item/storage/belt/rogue/leather/cloth/bandit, /obj/item/storage/belt/rogue/leather/cloth/lady, /obj/item/storage/belt/rogue/leather/cloth/sash, /obj/item/storage/belt/rogue/leather/cloth/sash/brown, /obj/item/storage/belt/rogue/leather/cloth/sash/orange, /obj/item/storage/belt/rogue/leather/cloth/sash/purple, /obj/item/storage/belt/rogue/leather/cloth/sash/random, /obj/item/storage/belt/rogue/leather/cloth/sash/red, /obj/item/storage/belt/rogue/leather/cloth/sash/yellow, /obj/item/storage/belt/rogue/leather/cloth/upgraded, /obj/item/storage/belt/rogue/leather/cloth/upgraded/lady)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "unties"
	rogue_verb_simple = "untie"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/unropebelt
	name = "untie rope belt"
	result = /obj/item/rope
	reqs = list(/obj/item/storage/belt/rogue/leather/rope = 1)
	blacklist = list(/obj/item/storage/belt/rogue/leather/rope/dark, /obj/item/storage/belt/rogue/leather/rope/upgraded, /obj/item/storage/belt/rogue/leather/rope/upgraded/dark)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "unties"
	rogue_verb_simple = "untie"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/waterarrow_ten
	name = "water arrow (x10)"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/water
	reqs = list(/obj/item/natural/glass_shard = 1, /obj/item/grown/log/tree/stick = 10)
	rogue_results = list(/obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water)
	blacklist = list(/obj/item/natural/glass_shard/shrapnel)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 0
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/waterarrow_twenty
	name = "water arrow (x20)"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/water
	reqs = list(/obj/item/natural/glass_shard = 2, /obj/item/grown/log/tree/stick = 20)
	rogue_results = list(/obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water, /obj/item/ammo_casing/caseless/rogue/arrow/water)
	blacklist = list(/obj/item/natural/glass_shard/shrapnel)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 0
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/waterbolt_ten
	name = "water bolt (x10)"
	result = /obj/item/ammo_casing/caseless/rogue/bolt/water
	reqs = list(/obj/item/natural/glass_shard = 1, /obj/item/grown/log/tree/stick = 10)
	rogue_results = list(/obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water)
	blacklist = list(/obj/item/natural/glass_shard/shrapnel)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 0
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/waterbolt_twenty
	name = "water bolt (x20)"
	result = /obj/item/ammo_casing/caseless/rogue/bolt/water
	reqs = list(/obj/item/natural/glass_shard = 2, /obj/item/grown/log/tree/stick = 10)
	rogue_results = list(/obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water, /obj/item/ammo_casing/caseless/rogue/bolt/water)
	blacklist = list(/obj/item/natural/glass_shard/shrapnel)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 0
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/whetstone
	name = "whetstone"
	result = /obj/item/natural/whetstone
	reqs = list(/obj/item/natural/stone = 1, /obj/item/grown/log/tree/stake = 1)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/wickercloak
	name = "wicker cloak"
	result = /obj/item/clothing/cloak/wickercloak
	reqs = list(/obj/item/natural/dirtclod = 1, /obj/item/grown/log/tree/stick = 5, /obj/item/natural/fibers = 3)
	blacklist = list(/obj/item/natural/dirtclod/sand, /obj/item/natural/dirtclod/snow)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/wood_stake
	name = "stake"
	result = /obj/item/grown/log/tree/stake
	reqs = list(/obj/item/grown/log/tree/stick = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/woodbowl
	name = "wooden bowls (x3) (1 small log)"
	result = /obj/item/reagent_containers/glass/bowl
	reqs = list(/obj/item/grown/log/tree/small = 1)
	rogue_results = list(/obj/item/reagent_containers/glass/bowl, /obj/item/reagent_containers/glass/bowl)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/woodbucket
	name = "bucket (1 small log)"
	result = /obj/item/reagent_containers/glass/bucket
	reqs = list(/obj/item/grown/log/tree/small = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/woodclub
	name = "wood club"
	result = /obj/item/rogueweapon/mace/woodclub/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/woodcross
	name = "wooden psycross"
	result = /obj/item/clothing/neck/roguetown/psicross/wood
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/grown/log/tree/stick = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/woodcup
	name = "wooden cups (x3) (1 small log)"
	result = /obj/item/reagent_containers/glass/cup/wooden/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1)
	rogue_results = list(/obj/item/reagent_containers/glass/cup/wooden/crafted, /obj/item/reagent_containers/glass/cup/wooden/crafted)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/wooddagger
	name = "wood dagger (3x)"
	result = /obj/item/rogueweapon/huntingknife/idagger/wood
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/fibers = 1)
	rogue_results = list(/obj/item/rogueweapon/huntingknife/idagger/wood, /obj/item/rogueweapon/huntingknife/idagger/wood)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/woodhammer
	name = "wood mallet"
	result = /obj/item/rogueweapon/hammer/wood
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/fibers = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/woodshield
	name = "wooden shield"
	result = /obj/item/rogueweapon/shield/wood
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/hide = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/natural/hide/cured)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/woodspade
	name = "wood spade"
	result = /obj/item/rogueweapon/shovel/small
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/grown/log/tree/stick = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/woodstaff
	name = "wood staff (3x)"
	result = /obj/item/rogueweapon/woodstaff
	reqs = list(/obj/item/grown/log/tree = 1)
	rogue_results = list(/obj/item/rogueweapon/woodstaff, /obj/item/rogueweapon/woodstaff)
	blacklist = list(/obj/item/grown/log/tree/bowpartial, /obj/item/grown/log/tree/bowpartial/longbow, /obj/item/grown/log/tree/bowpartial/recurve, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small/essence, /obj/item/grown/log/tree/stake, /obj/item/grown/log/tree/stick)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/woodsword
	name = "wood sword (2x)"
	result = /obj/item/rogueweapon/mace/wsword
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/fibers = 1)
	rogue_results = list(/obj/item/rogueweapon/mace/wsword)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/woodtray
	name = "wooden trays (x2) (1 small log)"
	result = /obj/item/storage/bag/tray
	reqs = list(/obj/item/grown/log/tree/small = 1)
	rogue_results = list(/obj/item/storage/bag/tray)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/tallow/campfire_soft_tallow
	name = "render soft tallow over the campfire (1 tallow, 1 fat)"
	result = /obj/item/reagent_containers/food/snacks/tallow/soft
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/reagent_containers/food/snacks/fat = 1)
	tool_paths = list(/obj/item/cooking/pan)
	blacklist = list(/obj/item/reagent_containers/food/snacks/fat/salo, /obj/item/reagent_containers/food/snacks/fat/salo/slice, /obj/item/reagent_containers/food/snacks/tallow/black, /obj/item/reagent_containers/food/snacks/tallow/red, /obj/item/reagent_containers/food/snacks/tallow/soft)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/light/rogue/campfire
	rogue_verb = "renders"
	rogue_verb_simple = "render"
	rogue_sound = 'modular_redtard/rockhill/sound/misc/frying.ogg'

/datum/crafting_recipe/roguetown/tallow/campfire_tallow
	name = "render tallow over the campfire (x3) (1 fat)"
	result = /obj/item/reagent_containers/food/snacks/tallow
	reqs = list(/obj/item/reagent_containers/food/snacks/fat = 1)
	rogue_results = list(/obj/item/reagent_containers/food/snacks/tallow, /obj/item/reagent_containers/food/snacks/tallow)
	tool_paths = list(/obj/item/cooking/pan)
	blacklist = list(/obj/item/reagent_containers/food/snacks/fat/salo, /obj/item/reagent_containers/food/snacks/fat/salo/slice)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 0
	rogue_structure = /obj/machinery/light/rogue/campfire
	rogue_verb = "renders"
	rogue_verb_simple = "render"
	rogue_sound = 'modular_redtard/rockhill/sound/misc/frying.ogg'

/datum/crafting_recipe/roguetown/tallow/hearth_soft_tallow
	name = "render soft tallow over the hearth (1 tallow, 1 fat)"
	result = /obj/item/reagent_containers/food/snacks/tallow/soft
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/reagent_containers/food/snacks/fat = 1)
	tool_paths = list(/obj/item/cooking/pan)
	blacklist = list(/obj/item/reagent_containers/food/snacks/fat/salo, /obj/item/reagent_containers/food/snacks/fat/salo/slice, /obj/item/reagent_containers/food/snacks/tallow/black, /obj/item/reagent_containers/food/snacks/tallow/red, /obj/item/reagent_containers/food/snacks/tallow/soft)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/light/rogue/hearth
	rogue_verb = "renders"
	rogue_verb_simple = "render"
	rogue_sound = 'modular_redtard/rockhill/sound/misc/frying.ogg'

/datum/crafting_recipe/roguetown/tallow/hearth_tallow
	name = "render tallow over the hearth (x4) (1 fat)"
	result = /obj/item/reagent_containers/food/snacks/tallow
	reqs = list(/obj/item/reagent_containers/food/snacks/fat = 1)
	rogue_results = list(/obj/item/reagent_containers/food/snacks/tallow, /obj/item/reagent_containers/food/snacks/tallow, /obj/item/reagent_containers/food/snacks/tallow)
	tool_paths = list(/obj/item/cooking/pan)
	blacklist = list(/obj/item/reagent_containers/food/snacks/fat/salo, /obj/item/reagent_containers/food/snacks/fat/salo/slice)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 0
	rogue_structure = /obj/machinery/light/rogue/hearth
	rogue_verb = "renders"
	rogue_verb_simple = "render"
	rogue_sound = 'modular_redtard/rockhill/sound/misc/frying.ogg'

/datum/crafting_recipe/roguetown/turfs/brick/floor
	name = "floor (brick) (1 brick)"
	result = /turf/open/floor/rogue/tile/brick
	reqs = list(/obj/item/natural/brick = 1)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/brick/window/openclose
	name = "reinforced window (brick) (2 brick, 1 iron, 1 glass, 1 dirtclod)"
	result = /obj/structure/roguewindow/openclose/reinforced/brick
	reqs = list(/obj/item/natural/brick = 2, /obj/item/ingot/iron = 1, /obj/item/natural/glass = 1, /obj/item/natural/dirtclod = 1)
	blacklist = list(/obj/item/natural/dirtclod/sand, /obj/item/natural/dirtclod/snow, /obj/item/natural/glass/heated)
	category = "Blacksmithing"
	rogue_skill = /datum/attribute/skill/craft/blacksmithing
	rogue_difficulty = 2
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/items/bsmith1.ogg'

/datum/crafting_recipe/roguetown/turfs/druidic_grass/grass
	name = "grass"
	result = /turf/open/floor/rogue/grass
	reqs = list(/obj/item/fertilizer = 1, /obj/item/natural/fibers = 3)
	tool_paths = list(/obj/item/alch/bloomstone)
	category = "Druidic Trickery"
	rogue_skill = /datum/attribute/skill/magic/druidic
	rogue_difficulty = 5
	rogue_verb = "grows"
	rogue_verb_simple = "grow"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/druidic_grass/grasscold
	name = "cold grass"
	result = /turf/open/floor/rogue/grasscold
	reqs = list(/obj/item/fertilizer = 1, /obj/item/natural/fibers = 3)
	tool_paths = list(/obj/item/alch/bloomstone)
	category = "Druidic Trickery"
	rogue_skill = /datum/attribute/skill/magic/druidic
	rogue_difficulty = 5
	rogue_verb = "grows"
	rogue_verb_simple = "grow"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/druidic_grass/grasspurple
	name = "purple grass"
	result = /turf/open/floor/rogue/grasspurple
	reqs = list(/obj/item/fertilizer = 1, /obj/item/natural/fibers = 3)
	tool_paths = list(/obj/item/alch/bloomstone)
	category = "Druidic Trickery"
	rogue_skill = /datum/attribute/skill/magic/druidic
	rogue_difficulty = 5
	rogue_verb = "grows"
	rogue_verb_simple = "grow"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/druidic_grass/grassred
	name = "red grass"
	result = /turf/open/floor/rogue/grassred
	reqs = list(/obj/item/fertilizer = 1, /obj/item/natural/fibers = 3)
	tool_paths = list(/obj/item/alch/bloomstone)
	category = "Druidic Trickery"
	rogue_skill = /datum/attribute/skill/magic/druidic
	rogue_difficulty = 5
	rogue_verb = "grows"
	rogue_verb_simple = "grow"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/druidic_grass/grassyel
	name = "yellow grass"
	result = /turf/open/floor/rogue/grassyel
	reqs = list(/obj/item/fertilizer = 1, /obj/item/natural/fibers = 3)
	tool_paths = list(/obj/item/alch/bloomstone)
	category = "Druidic Trickery"
	rogue_skill = /datum/attribute/skill/magic/druidic
	rogue_difficulty = 5
	rogue_verb = "grows"
	rogue_verb_simple = "grow"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/fancywindow/openclose
	name = "window (fancy) (2 small logs, 1 stone, 1 glass, 1 dirtclod)"
	result = /obj/structure/roguewindow/openclose
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/natural/stone = 1, /obj/item/natural/glass = 1, /obj/item/natural/dirtclod = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/natural/dirtclod/sand, /obj/item/natural/dirtclod/snow, /obj/item/natural/glass/heated, /obj/item/natural/stone/sending)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 3
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/turfs/hay
	name = "floor (hay) (2 wheat stalks)"
	result = /turf/open/floor/rogue/hay
	reqs = list(/obj/item/natural/chaff/wheat = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "assembles"
	rogue_verb_simple = "assemble"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/reinforcedwindow/openclose
	name = "window (reinforced) (2 small logs, 1 iron, 1 glass, 1 dirtclod)"
	result = /obj/structure/roguewindow/openclose/reinforced
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/ingot/iron = 1, /obj/item/natural/glass = 1, /obj/item/natural/dirtclod = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/natural/dirtclod/sand, /obj/item/natural/dirtclod/snow, /obj/item/natural/glass/heated)
	category = "Blacksmithing"
	rogue_skill = /datum/attribute/skill/craft/blacksmithing
	rogue_difficulty = 2
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/items/bsmith1.ogg'

/datum/crafting_recipe/roguetown/turfs/roguewindow
	name = "static glass window (2 small logs)"
	result = /obj/structure/roguewindow
	reqs = list(/obj/item/grown/log/tree/small = 2)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 4
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/turfs/roguewindow/dynamic
	name = "openable glass window (2 small logs)"
	result = /obj/structure/roguewindow/openclose
	reqs = list(/obj/item/grown/log/tree/small = 2)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 4
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/turfs/roguewindow/reinforced
	name = "reinforced glass window (2 small logs, 1 iron, 1 glass)"
	result = /obj/structure/roguewindow/openclose/reinforced
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/natural/glass = 1, /obj/item/ingot/iron = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/natural/glass/heated)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 3
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/turfs/roguewindow/stone
	name = "static glass window (2 stone, 1 glass)"
	result = /obj/structure/roguewindow/stained/silver
	reqs = list(/obj/item/natural/stone = 2, /obj/item/natural/glass = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = list(/obj/item/natural/glass/heated, /obj/item/natural/stone/sending)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/turfs/stone/block
	name = "floor (stoneblock) (1 stone)"
	result = /turf/open/floor/rogue/blocks
	reqs = list(/obj/item/natural/stoneblock = 1)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/stone/bluelargetile
	name = "Blue Large Tiles"
	result = /turf/open/floor/rogue/tile/bfloorz
	reqs = list(/obj/item/natural/stoneblock = 2)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/stone/brick
	name = "wall (stonebrick) (2 stoneblocks)"
	result = /turf/closed/wall/mineral/rogue/stonebrick
	reqs = list(/obj/item/natural/stoneblock = 2)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/stone/brick/bricklight
	name = "wall (stonebrick light) (2 stoneblocks, 1 lamptern)"
	result = /turf/closed/wall/mineral/rogue/stonebrick/stonebricklight
	reqs = list(/obj/item/natural/stoneblock = 2, /obj/item/flashlight/flare/torch/lantern = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = list(/obj/item/flashlight/flare/torch/lantern/bronze, /obj/item/flashlight/flare/torch/lantern/bronzelamptern, /obj/item/flashlight/flare/torch/lantern/copper, /obj/item/flashlight/flare/torch/lantern/prelit, /obj/item/flashlight/flare/torch/lantern/psycenser, /obj/item/flashlight/flare/torch/lantern/pumpkin, /obj/item/flashlight/flare/torch/lantern/pumpkin/frown, /obj/item/flashlight/flare/torch/lantern/pumpkin/grin, /obj/item/flashlight/flare/torch/lantern/pumpkin/psy, /obj/item/flashlight/flare/torch/lantern/pumpkin/surprise, /obj/item/flashlight/flare/torch/lantern/pumpkin/ten, /obj/item/flashlight/flare/torch/lantern/pumpkin/woozy, /obj/item/flashlight/flare/torch/lantern/pumpkin/zizo, /obj/item/flashlight/flare/torch/lantern/scrap, /obj/item/flashlight/flare/torch/lantern/voidlamptern)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/turfs/stone/churchredbrick
	name = "Large Red Masonic Bricks"
	result = /turf/open/floor/rogue/churchbrick
	reqs = list(/obj/item/natural/stoneblock = 2)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/stone/cobble
	name = "floor (cobblestone) (1 stone)"
	result = /turf/open/floor/rogue/cobble
	reqs = list(/obj/item/natural/stone = 1)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/stone/cobblerock
	name = "road (cobblerock) (1 stone)"
	result = /turf/open/floor/rogue/cobblerock
	reqs = list(/obj/item/natural/stone = 1)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 0
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/stone/concreteslab
	name = "Large Stone Slabs"
	result = /turf/open/floor/rogue/concrete
	reqs = list(/obj/item/natural/stoneblock = 2)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/stone/craft
	name = "wall (craftstone) (3 stoneblocks)"
	result = /turf/closed/wall/mineral/rogue/craftstone
	reqs = list(/obj/item/natural/stoneblock = 3)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/stone/decorated
	name = "wall decorated (stone) (2 stone)"
	result = /turf/closed/wall/mineral/rogue/decostone
	reqs = list(/obj/item/natural/stone = 2)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/stone/haremgreenbricks
	name = "Harem Green Bricks"
	result = /turf/open/floor/rogue/tile/harem1
	reqs = list(/obj/item/natural/stoneblock = 2)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/stone/harempink
	name = "Harem Pink Bricks"
	result = /turf/open/floor/rogue/tile/harem2
	reqs = list(/obj/item/natural/stoneblock = 2)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/stone/haremredbricks
	name = "Harem Red Bricks"
	result = /turf/open/floor/rogue/tile/harem
	reqs = list(/obj/item/natural/stoneblock = 2)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/stone/herringbone
	name = "floor (herringbone) (2 stoneblocks)"
	result = /turf/open/floor/rogue/herringbone
	reqs = list(/obj/item/natural/stoneblock = 1)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/stone/hexstone
	name = "floor (hexstone) (2 stoneblocks)"
	result = /turf/open/floor/rogue/hexstone
	reqs = list(/obj/item/natural/stoneblock = 1)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/stone/marblefloor
	name = "Marble Floor (stone)"
	result = /turf/open/floor/rogue/churchmarble
	reqs = list(/obj/item/natural/stoneblock = 4)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 4
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/stone/masonic
	name = "Masonic Decorative Floor"
	result = /turf/open/floor/rogue/tile/masonic
	reqs = list(/obj/item/natural/stoneblock = 2)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/stone/masonicalt
	name = "Masonic Inverse Decorative Floor"
	result = /turf/open/floor/rogue/tile/masonic/inverted
	reqs = list(/obj/item/natural/stoneblock = 2)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/stone/masonicspiral
	name = "Masonic Spiral Decorative Floor"
	result = /turf/open/floor/rogue/tile/masonic/spiral
	reqs = list(/obj/item/natural/stoneblock = 2)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/stone/newstone
	name = "floor (newstone) (2 stoneblocks)"
	result = /turf/open/floor/rogue/blocks/newstone/alt
	reqs = list(/obj/item/natural/stoneblock = 1)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/stone/platform
	name = "platform (stone) (2 stoneblocks)"
	result = /turf/open/floor/rogue/blocks/platform
	reqs = list(/obj/item/natural/stoneblock = 2)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/stone/redstone
	name = "floor (red stone)"
	result = /turf/open/floor/rogue/blocks/stonered
	reqs = list(/obj/item/natural/stoneblock = 1)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/stone/tinyredstone
	name = "floor (tiny red stone)"
	result = /turf/open/floor/rogue/blocks/stonered/tiny
	reqs = list(/obj/item/natural/stoneblock = 1)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/stone/wall
	name = "wall (stone) (2 stone)"
	result = /turf/closed/wall/mineral/rogue/stone
	reqs = list(/obj/item/natural/stone = 2)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/stone/window
	name = "murder hole (stone) (2 stoneblocks)"
	result = /turf/closed/wall/mineral/rogue/stone/window
	reqs = list(/obj/item/natural/stoneblock = 2)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 2
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/tentdoor
	name = "tent door (1 stick, 1 cloth)"
	result = /obj/structure/roguetent
	reqs = list(/obj/item/grown/log/tree/stick = 1, /obj/item/natural/cloth = 1)
	blacklist = list(/obj/item/natural/cloth/bandage)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "sets up"
	rogue_verb_simple = "set up"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/tentdoor/leather
	name = "leather tent door (1 stick, 1 leather)"
	result = /obj/structure/roguetent/leather
	reqs = list(/obj/item/grown/log/tree/stick = 1, /obj/item/natural/hide/cured = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "sets up"
	rogue_verb_simple = "set up"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/turfs/tentwall
	name = "tent wall (1 stick, 1 cloth)"
	result = /turf/closed/wall/mineral/rogue/tent
	reqs = list(/obj/item/grown/log/tree/stick = 1, /obj/item/natural/cloth = 1)
	blacklist = list(/obj/item/natural/cloth/bandage)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "sets up"
	rogue_verb_simple = "set up"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/twig
	name = "floor (twig) (2 sticks)"
	result = /turf/open/floor/rogue/twig
	reqs = list(/obj/item/grown/log/tree/stick = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "assembles"
	rogue_verb_simple = "assemble"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/twigplatform
	name = "platform (twig) (2 sticks)"
	result = /turf/open/floor/rogue/twig/platform
	reqs = list(/obj/item/grown/log/tree/stick = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "assembles"
	rogue_verb_simple = "assemble"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/wood
	name = "floor (crude wood) (1 small log)"
	result = /turf/open/floor/rogue/ruinedwood
	reqs = list(/obj/item/grown/log/tree/small = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/turfs/wood/darkwoodwall
	name = "dark wood wall (2 wood planks)"
	result = /turf/closed/wall/mineral/rogue/wooddark
	reqs = list(/obj/item/natural/wood/plank = 2)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 3
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/turfs/wood/darkwoodwall/horizontal
	name = "dark wood wall horizontal (2 wood planks)"
	result = /turf/closed/wall/mineral/rogue/wooddark/horizontal
	reqs = list(/obj/item/natural/wood/plank = 2)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 3
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/turfs/wood/darkwoodwall/vertical
	name = "dark wood wall vertical (2 wood planks)"
	result = /turf/closed/wall/mineral/rogue/wooddark/vertical
	reqs = list(/obj/item/natural/wood/plank = 2)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 3
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/turfs/wood/darkwoodwindow
	name = "dark wood murderhole (2 wood planks)"
	result = /turf/closed/wall/mineral/rogue/wooddark/window
	reqs = list(/obj/item/natural/wood/plank = 2)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 3
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/turfs/wood/fancy
	name = "wall fancy (wood) (2 wooden planks)"
	result = /turf/closed/wall/mineral/rogue/decowood
	reqs = list(/obj/item/natural/wood/plank = 2)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 3
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/turfs/wood/floor
	name = "floor (wood) (1 wooden plank)"
	result = /turf/open/floor/rogue/wood
	reqs = list(/obj/item/natural/wood/plank = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/turfs/wood/floorhs
	name = "floor (herringbone stamped)"
	result = /turf/open/floor/rogue/ruinedwood/chevron
	reqs = list(/obj/item/natural/wood/plank = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 4
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/turfs/wood/floorhw
	name = "floor (herringbone weathered)"
	result = /turf/open/floor/rogue/ruinedwood/herringbone
	reqs = list(/obj/item/natural/wood/plank = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 4
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/turfs/wood/floorslanted
	name = "floor (slanted)"
	result = /turf/open/floor/rogue/ruinedwood/spiral
	reqs = list(/obj/item/natural/wood/plank = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 3
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/turfs/wood/murderhole
	name = "murder hole (wood) (2 small logs)"
	result = /turf/closed/wall/mineral/rogue/wood/window
	reqs = list(/obj/item/grown/log/tree/small = 2)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/turfs/wood/murderhole/alt
	name = "murder hole (wood) (2 small logs)"
	result = /turf/closed/wall/mineral/rogue/wood/window
	reqs = list(/obj/item/natural/wood/plank = 2)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/turfs/wood/platform
	name = "platform (wood) (2 wooden planks)"
	result = /turf/open/floor/rogue/ruinedwood/platform
	reqs = list(/obj/item/natural/wood/plank = 2)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/turfs/wood/wall
	name = "wall (wood) (2 small logs)"
	result = /turf/closed/wall/mineral/rogue/wood
	reqs = list(/obj/item/grown/log/tree/small = 2)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/turfs/wood/wall/alt
	name = "wall (wood) (2 small logs)"
	result = /turf/closed/wall/mineral/rogue/wood
	reqs = list(/obj/item/natural/wood/plank = 2)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/weaving/abyssorhood
	name = "abyssor hood"
	result = /obj/item/clothing/head/roguetown/roguehood/abyssor
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/abyssorrobe
	name = "abyssor robes"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/silk = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/astratahood
	name = "solar hood"
	result = /obj/item/clothing/head/roguetown/roguehood/astrata
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/astratarobe
	name = "astrata robes"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/astrata
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/silk = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/barkeep
	name = "bar dress"
	result = /obj/item/clothing/suit/roguetown/shirt/dress
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 2)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/cloak
	name = "silk half cloak"
	result = /obj/item/clothing/cloak/half
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/silk = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/cloak_rosa
	name = "regal cloak"
	result = /obj/item/clothing/cloak/rosa
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1, /obj/item/alch/rosa = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/cloak_rosa_two
	name = "courtly cloak"
	result = /obj/item/clothing/cloak/rosa/two
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1, /obj/item/alch/rosa = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/dendorrobe
	name = "dendor robes"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/dendor
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/silk = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/eoramask
	name = "eora mask"
	result = /obj/item/clothing/head/roguetown/eoramask
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/silk = 2)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/eorarobes
	name = "eora robes"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/eora
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/head_roguetown_roguehood_eorahood
	name = "opera hood"
	result = /obj/item/clothing/head/roguetown/roguehood/eorahood
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/head_roguetown_roguehood_ravox
	name = "ravox hood"
	result = /obj/item/clothing/head/roguetown/roguehood/ravox
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/head_roguetown_roguehood_see
	name = "see hood"
	result = /obj/item/clothing/head/roguetown/roguehood/see
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/necrahood
	name = "necra hood"
	result = /obj/item/clothing/head/roguetown/necrahood
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/necrarobe
	name = "necra robes"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/necra
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/silk = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/nochood
	name = "moon hood"
	result = /obj/item/clothing/head/roguetown/nochood
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/nocrobe
	name = "noc robes"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/noc
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/silk = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/puritan
	name = "puritan's cape"
	result = /obj/item/clothing/cloak/cape/puritan
	reqs = list(/obj/item/natural/silk = 4)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/rags
	name = "webbed shirt"
	result = /obj/item/clothing/suit/roguetown/shirt/undershirt/webs
	reqs = list(/obj/item/natural/silk = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/shepardmask
	name = "half-mask"
	result = /obj/item/clothing/mask/rogue/shepherd
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/silk = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/shirt
	name = "formal silks"
	result = /obj/item/clothing/suit/roguetown/shirt/undershirt/puritan
	reqs = list(/obj/item/natural/silk = 5)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/silkcoat
	name = "silk coat"
	result = /obj/item/clothing/suit/roguetown/armor/silkcoat
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/silk = 3, /obj/item/natural/fur = 2)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/silkdress
	name = "chemise"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress/random
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 3)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/suit_roguetown_shirt_robe_ravox
	name = "ravox robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/ravox
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/silk = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/suit_roguetown_shirt_robe_see
	name = "see robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/see
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/silk = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/suit_roguetown_shirt_robe_seecleric
	name = "see clerical robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/seecleric
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/silk = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/suit_roguetown_shirt_tunic_rosa
	name = "ivory dress"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/rosa
	reqs = list(/obj/item/natural/silk = 3, /obj/item/natural/cloth = 2, /obj/item/alch/rosa = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/suit_roguetown_shirt_tunic_rosa_five
	name = "sable dress"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/rosa/five
	reqs = list(/obj/item/natural/silk = 3, /obj/item/natural/cloth = 2, /obj/item/alch/rosa = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/suit_roguetown_shirt_tunic_rosa_four
	name = "obsidian dress"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/rosa/four
	reqs = list(/obj/item/natural/silk = 3, /obj/item/natural/cloth = 2, /obj/item/alch/rosa = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/suit_roguetown_shirt_tunic_rosa_six
	name = "maroon dress"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/rosa/six
	reqs = list(/obj/item/natural/silk = 3, /obj/item/natural/cloth = 2, /obj/item/alch/rosa = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/suit_roguetown_shirt_tunic_rosa_three
	name = "velvet dress"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/rosa/three
	reqs = list(/obj/item/natural/silk = 3, /obj/item/natural/cloth = 2, /obj/item/alch/rosa = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/weaving/webbing
	name = "webbed leggings"
	result = /obj/item/clothing/under/roguetown/webs
	reqs = list(/obj/item/natural/silk = 2)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_structure = /obj/machinery/loom
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/wood_dildo
	name = "wooden dildo"
	result = /obj/item/dildo/wood
	reqs = list(/obj/item/grown/log/tree/small = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/alchemy/begin_magnum_opus
	// Azure Peak
	name = "blackened materia"
	result = /obj/item/alch/precursor/nigredo
	reqs = list(/obj/item/rogueore/cinnabar = 1, /obj/item/natural/ash = 3)
	rogue_results = list(/obj/item/alch/precursor/nigredo)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 5
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"

/datum/crafting_recipe/roguetown/alchemy/catalyzation_reagent
	// Azure Peak
	name = "catalyzing reagent (iridescent scale)"
	result = /obj/item/storage/roguebag/trans
	reqs = list(/obj/item/magic/fae/iridescentscale = 1, /obj/item/natural/ash = 3, /obj/item/storage/roguebag = 1)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 4
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"

/datum/crafting_recipe/roguetown/alchemy/catalyzation_reagent_pacifist
	// Azure Peak
	name = "catalyzing reagent (cinnabar)"
	result = /obj/item/storage/roguebag/trans
	reqs = list(/obj/item/rogueore/cinnabar = 1, /obj/item/natural/ash = 3, /obj/item/storage/roguebag = 1)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 4
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"

/datum/crafting_recipe/roguetown/alchemy/herozium
	// Azure Peak
	name = "herozium"
	result = /obj/item/reagent_containers/powder/herozium
	reqs = list(/obj/item/reagent_containers/powder/ozium = 1, /datum/reagent/buff/strength = 15, /obj/item/natural/ash = 2)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 4
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"

/datum/crafting_recipe/roguetown/alchemy/moon_purest
	// Azure Peak
	name = "purified moondust"
	result = /obj/item/reagent_containers/powder/moondust_purest
	reqs = list(/obj/item/reagent_containers/powder/moondust = 1, /datum/reagent/buff/speed = 15, /datum/reagent/buff/endurance = 15)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 4
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"

/datum/crafting_recipe/roguetown/alchemy/spice_compost
	// Azure Peak
	name = "spice (compost)"
	result = /obj/item/reagent_containers/powder/spice
	reqs = list(/obj/item/natural/ash = 2, /obj/item/compost = 2, /datum/reagent/berrypoison = 2)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 3
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"

/datum/crafting_recipe/roguetown/alchemy/spice_poo
	// Azure Peak
	name = "spice (nightsoil)"
	result = /obj/item/reagent_containers/powder/spice
	reqs = list(/obj/item/natural/ash = 2, /obj/item/natural/poo = 1, /datum/reagent/berrypoison = 2)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 3
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"

/datum/crafting_recipe/roguetown/alchemy/starsugar
	// Azure Peak
	name = "starsugar"
	result = /obj/item/reagent_containers/powder/starsugar
	reqs = list(/obj/item/alch/solardust = 1, /obj/item/alch/salvia = 1, /datum/reagent/medicine/strongmana = 15, /obj/item/alch/sleep_powder = 1)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 4
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "mix"

/datum/crafting_recipe/roguetown/alchemy/transmutation_equipment
	// Azure Peak
	name = "transmutation equipment"
	result = /obj/item/trans_table_upgrade
	reqs = list(/obj/item/ingot/purifiedaalloy = 2)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_structure = /obj/structure/fluff/alch
	rogue_verb_simple = "forge"

/datum/crafting_recipe/roguetown/arcana/arcyne_dagger
	// Azure Peak
	name = "arcyne silver dagger"
	result = /obj/item/rogueweapon/huntingknife/idagger/steel/silver/arcyne
	reqs = list(/obj/item/rogueweapon/huntingknife/idagger/steel/silver = 1, /obj/item/rogueore/cinnabar = 1)
	category = "Arcana"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/arcana/fission_elemental_grand
	// Azure Peak
	name = "grand arcyne fission of elemental relic"
	result = /obj/item/magic/elemental/fragment
	reqs = list(/obj/item/magic/elemental/relic = 1)
	category = "Arcana"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/arcana/fission_elemental_greater
	// Azure Peak
	name = "greater arcyne fission of elemental fragment"
	result = /obj/item/magic/elemental/shard
	reqs = list(/obj/item/magic/elemental/fragment = 1)
	rogue_results = list(/obj/item/magic/elemental/shard)
	category = "Arcana"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/arcana/fission_elemental_lesser
	// Azure Peak
	name = "lesser arcyne fission of elemental shard"
	result = /obj/item/magic/elemental/mote
	reqs = list(/obj/item/magic/elemental/shard = 1)
	rogue_results = list(/obj/item/magic/elemental/mote)
	category = "Arcana"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/arcana/fission_fae_grand
	// Azure Peak
	name = "grand arcyne fission of sylvan essence"
	result = /obj/item/magic/fae/heartwoodcore
	reqs = list(/obj/item/magic/fae/sylvanessence = 1)
	category = "Arcana"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/arcana/fission_fae_greater
	// Azure Peak
	name = "greater arcyne fission of heartwood core"
	result = /obj/item/magic/fae/iridescentscale
	reqs = list(/obj/item/magic/fae/heartwoodcore = 1)
	rogue_results = list(/obj/item/magic/fae/iridescentscale)
	category = "Arcana"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/arcana/fission_fae_lesser
	// Azure Peak
	name = "lesser arcyne fission of iridescent scale"
	result = /obj/item/magic/fae/fairydust
	reqs = list(/obj/item/magic/fae/iridescentscale = 1)
	rogue_results = list(/obj/item/magic/fae/fairydust)
	category = "Arcana"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/arcana/fission_infernal_grand
	// Azure Peak
	name = "grand arcyne fission of abyssal flame"
	result = /obj/item/magic/infernal/core
	reqs = list(/obj/item/magic/infernal/flame = 1)
	category = "Arcana"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/arcana/fission_infernal_greater
	// Azure Peak
	name = "greater arcyne fission of infernal core"
	result = /obj/item/magic/infernal/fang
	reqs = list(/obj/item/magic/infernal/core = 1)
	rogue_results = list(/obj/item/magic/infernal/fang)
	category = "Arcana"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/arcana/fission_infernal_lesser
	// Azure Peak
	name = "lesser arcyne fission of hellhound fang"
	result = /obj/item/magic/infernal/ash
	reqs = list(/obj/item/magic/infernal/fang = 1)
	rogue_results = list(/obj/item/magic/infernal/ash)
	category = "Arcana"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/arcana/fusion_elemental_grand
	// Azure Peak
	name = "grand arcyne fusion of elemental relic"
	result = /obj/item/magic/elemental/relic
	reqs = list(/obj/item/magic/elemental/fragment = 2)
	category = "Arcana"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/arcana/fusion_elemental_greater
	// Azure Peak
	name = "greater arcyne fusion of elemental shards"
	result = /obj/item/magic/elemental/fragment
	reqs = list(/obj/item/magic/elemental/shard = 2)
	category = "Arcana"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/arcana/fusion_elemental_lesser
	// Azure Peak
	name = "lesser arcyne fusion of elemental motes"
	result = /obj/item/magic/elemental/shard
	reqs = list(/obj/item/magic/elemental/mote = 4)
	category = "Arcana"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/arcana/fusion_fae_grand
	// Azure Peak
	name = "grand arcyne fusion of sylvan essence"
	result = /obj/item/magic/fae/sylvanessence
	reqs = list(/obj/item/magic/fae/heartwoodcore = 2)
	category = "Arcana"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/arcana/fusion_fae_greater
	// Azure Peak
	name = "greater arcyne fusion of heartwood cores"
	result = /obj/item/magic/fae/heartwoodcore
	reqs = list(/obj/item/magic/fae/iridescentscale = 2)
	category = "Arcana"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/arcana/fusion_fae_lesser
	// Azure Peak
	name = "lesser arcyne fusion of iridescent scales"
	result = /obj/item/magic/fae/iridescentscale
	reqs = list(/obj/item/magic/fae/fairydust = 4)
	category = "Arcana"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/arcana/fusion_infernal_grand
	// Azure Peak
	name = "grand arcyne fusion of infernal cores"
	result = /obj/item/magic/infernal/flame
	reqs = list(/obj/item/magic/infernal/core = 2)
	category = "Arcana"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/arcana/fusion_infernal_greater
	// Azure Peak
	name = "greater arcyne fusion of infernal fangs"
	result = /obj/item/magic/infernal/core
	reqs = list(/obj/item/magic/infernal/fang = 2)
	category = "Arcana"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/arcana/fusion_infernal_lesser
	// Azure Peak
	name = "lesser arcyne fusion of infernal ashes"
	result = /obj/item/magic/infernal/fang
	reqs = list(/obj/item/magic/infernal/ash = 4)
	category = "Arcana"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/arcana/runed_artifact_replication
	// Azure Peak
	name = "arcyne replication of runed artifact"
	result = /obj/item/magic/artifact
	reqs = list(/obj/item/magic/artifact = 1, /datum/reagent/medicine/manapot = 45)
	rogue_results = list(/obj/item/magic/artifact)
	category = "Arcana"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/basket
	// Azure Peak
	name = "basket"
	result = /obj/item/storage/roguebasket
	reqs = list(/obj/item/grown/log/tree/stick = 2, /obj/item/natural/fibers = 3)
	category = "Other"
	rogue_skill = null
	rogue_difficulty = 0
	rogue_verb = "weaves"
	rogue_verb_simple = "weave"

/datum/crafting_recipe/roguetown/bouquet_azurosa
	// Azure Peak
	name = "azurosa bouquet"
	result = /obj/item/bouquet/rosa/azure
	reqs = list(/obj/item/alch/rosa/azure = 4, /obj/item/natural/fibers = 2, /obj/item/paper/scroll = 1)
	blacklist = list(/obj/item/paper/scroll/bounty, /obj/item/paper/scroll/cargo, /obj/item/paper/scroll/custom, /obj/item/paper/scroll/fake_evidence, /obj/item/paper/scroll/grudge, /obj/item/paper/scroll/ministry_writ, /obj/item/paper/scroll/sell_price_changes, /obj/item/paper/scroll/trade_requests, /obj/item/paper/scroll/writ_of_esteem, /obj/item/paper/scroll/writ_of_esteem/grenzel, /obj/item/paper/scroll/writ_of_esteem/otavan, /obj/item/paper/scroll/writ_of_esteem/zybantine)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "arranges"
	rogue_verb_simple = "arranged"

/datum/crafting_recipe/roguetown/ceramics/clay/clayamphora
	// Azure Peak
	name = "clay amphora"
	result = /obj/item/natural/clay/rawamphora
	reqs = list(/obj/item/natural/clay = 4)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 4
	rogue_structure = /obj/structure/fluff/ceramicswheel

/datum/crafting_recipe/roguetown/ceramics/clay/claybamana
	// Azure Peak
	name = "clay bamana pot"
	result = /obj/item/natural/clay/rawbamana
	reqs = list(/obj/item/natural/clay = 3)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 3
	rogue_structure = /obj/structure/fluff/ceramicswheel

/datum/crafting_recipe/roguetown/ceramics/clay/claybottleclassic
	// Azure Peak
	name = "clay bottle, traditional"
	result = /obj/item/natural/clay/claybottleclassic
	reqs = list(/obj/item/natural/clay = 1)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_structure = /obj/structure/fluff/ceramicswheel

/datum/crafting_recipe/roguetown/ceramics/clay/claybrick3
	// Azure Peak
	name = "clay brick 3x"
	result = /obj/item/natural/clay/claybrick
	reqs = list(/obj/item/natural/clay = 3)
	rogue_results = list(/obj/item/natural/clay/claybrick, /obj/item/natural/clay/claybrick)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 0
	rogue_structure = /obj/structure/fluff/ceramicswheel

/datum/crafting_recipe/roguetown/ceramics/clay/claycarafe
	// Azure Peak
	name = "clay carafe"
	result = /obj/item/natural/clay/rawcarafe
	reqs = list(/obj/item/natural/clay = 3)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 2
	rogue_structure = /obj/structure/fluff/ceramicswheel

/datum/crafting_recipe/roguetown/ceramics/clay/claycup3
	// Azure Peak
	name = "clay flask, dyeable (3x)"
	result = /obj/item/natural/clay/claycup
	reqs = list(/obj/item/natural/clay = 3)
	rogue_results = list(/obj/item/natural/clay/claycup, /obj/item/natural/clay/claycup)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 0
	rogue_structure = /obj/structure/fluff/ceramicswheel

/datum/crafting_recipe/roguetown/ceramics/clay/claycup3classic3
	// Azure Peak
	name = "clay flask, traditional (3x)"
	result = /obj/item/natural/clay/claycupclassic
	reqs = list(/obj/item/natural/clay = 3)
	rogue_results = list(/obj/item/natural/clay/claycupclassic, /obj/item/natural/clay/claycupclassic)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 0
	rogue_structure = /obj/structure/fluff/ceramicswheel

/datum/crafting_recipe/roguetown/ceramics/clay/claycupclassic
	// Azure Peak
	name = "clay cup"
	result = /obj/item/natural/clay/rawcup
	reqs = list(/obj/item/natural/clay = 1)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 0
	rogue_structure = /obj/structure/fluff/ceramicswheel

/datum/crafting_recipe/roguetown/ceramics/clay/clayfancyvaseclassic
	// Azure Peak
	name = "fancy clay vase, traditional"
	result = /obj/item/natural/clay/clayfancyvaseclassic
	reqs = list(/obj/item/natural/clay = 2)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 3
	rogue_structure = /obj/structure/fluff/ceramicswheel

/datum/crafting_recipe/roguetown/ceramics/clay/clayfoot
	// Azure Peak
	name = "clay standing vase"
	result = /obj/item/natural/clay/rawfoot
	reqs = list(/obj/item/natural/clay = 3)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 5
	rogue_structure = /obj/structure/fluff/ceramicswheel

/datum/crafting_recipe/roguetown/ceramics/clay/clayskinny
	// Azure Peak
	name = "clay vase (skinny)"
	result = /obj/item/natural/clay/rawskinnyvase
	reqs = list(/obj/item/natural/clay = 2)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_structure = /obj/structure/fluff/ceramicswheel

/datum/crafting_recipe/roguetown/ceramics/clay/claystatue
	// Azure Peak
	name = "clay statue"
	result = /obj/item/natural/clay/claystatue
	reqs = list(/obj/item/natural/clay = 3)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 4
	rogue_structure = /obj/structure/fluff/ceramicswheel

/datum/crafting_recipe/roguetown/ceramics/clay/claytallvase
	// Azure Peak
	name = "tall clay vase"
	result = /obj/item/natural/clay/rawtallvase
	reqs = list(/obj/item/natural/clay = 3)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 3
	rogue_structure = /obj/structure/fluff/ceramicswheel

/datum/crafting_recipe/roguetown/ceramics/clay/clayvaseclassic
	// Azure Peak
	name = "clay vase, traditional"
	result = /obj/item/natural/clay/clayvaseclassic
	reqs = list(/obj/item/natural/clay = 2)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 2
	rogue_structure = /obj/structure/fluff/ceramicswheel

/datum/crafting_recipe/roguetown/ceramics/clayamulet
	// Azure Peak
	name = "clay amulet"
	result = /obj/item/natural/clay/rawamulet
	reqs = list(/obj/item/natural/clay = 1)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/ceramics/claybauble
	// Azure Peak
	name = "clay bauble x3"
	result = /obj/item/natural/clay/rawbauble
	reqs = list(/obj/item/natural/clay = 1)
	rogue_results = list(/obj/item/natural/clay/rawbauble, /obj/item/natural/clay/rawbauble)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 0

/datum/crafting_recipe/roguetown/ceramics/claybeaver
	// Azure Peak
	name = "clay beaver statuette"
	result = /obj/item/natural/clay/rawbeaver
	reqs = list(/obj/item/natural/clay = 3)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/ceramics/claybowl
	// Azure Peak
	name = "clay bowl"
	result = /obj/item/natural/clay/rawbowl
	reqs = list(/obj/item/natural/clay = 1)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics

/datum/crafting_recipe/roguetown/ceramics/claybox
	// Azure Peak
	name = "clay box"
	result = /obj/item/natural/clay/rawbox
	reqs = list(/obj/item/natural/clay = 2)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics

/datum/crafting_recipe/roguetown/ceramics/claybust
	// Azure Peak
	name = "clay bust"
	result = /obj/item/natural/clay/rawbust
	reqs = list(/obj/item/natural/clay = 3)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/ceramics/claycameo
	// Azure Peak
	name = "clay cameo"
	result = /obj/item/natural/clay/rawcameo
	reqs = list(/obj/item/natural/clay = 1)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 0

/datum/crafting_recipe/roguetown/ceramics/claycarp
	// Azure Peak
	name = "clay carp statuette"
	result = /obj/item/natural/clay/rawcarp
	reqs = list(/obj/item/natural/clay = 3)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/ceramics/claycaryatid
	// Azure Peak
	name = "clay caryatid"
	result = /obj/item/natural/clay/rawcaryatid
	reqs = list(/obj/item/natural/clay = 2)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/ceramics/claycirclet
	// Azure Peak
	name = "clay circlet"
	result = /obj/item/natural/clay/rawcirclet
	reqs = list(/obj/item/natural/clay = 1)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/ceramics/claycomb
	// Azure Peak
	name = "clay comb"
	result = /obj/item/natural/clay/rawcomb
	reqs = list(/obj/item/natural/clay = 1)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/ceramics/claydisplay
	// Azure Peak
	name = "clay display stand"
	result = /obj/item/natural/clay/rawdisplay
	reqs = list(/obj/item/natural/clay = 1)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics

/datum/crafting_recipe/roguetown/ceramics/clayduck
	// Azure Peak
	name = "clay duck figurine"
	result = /obj/item/natural/clay/rawduck
	reqs = list(/obj/item/natural/clay = 1)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics

/datum/crafting_recipe/roguetown/ceramics/clayfigurine
	// Azure Peak
	name = "clay figurine"
	result = /obj/item/natural/clay/rawfigurine
	reqs = list(/obj/item/natural/clay = 1)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics

/datum/crafting_recipe/roguetown/ceramics/clayfish
	// Azure Peak
	name = "clay fish figurine"
	result = /obj/item/natural/clay/rawfish
	reqs = list(/obj/item/natural/clay = 1)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics

/datum/crafting_recipe/roguetown/ceramics/clayfork
	// Azure Peak
	name = "clay fork"
	result = /obj/item/natural/clay/rawfork
	reqs = list(/obj/item/natural/clay = 1)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics

/datum/crafting_recipe/roguetown/ceramics/claygoblet
	// Azure Peak
	name = "fancy clay goblet"
	result = /obj/item/natural/clay/rawcupfancy
	reqs = list(/obj/item/natural/clay = 1)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/ceramics/clayheart
	// Azure Peak
	name = "clay heart"
	result = /obj/item/natural/clay/rawheart
	reqs = list(/obj/item/natural/clay = 1)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics

/datum/crafting_recipe/roguetown/ceramics/claymoon
	// Azure Peak
	name = "clay moon"
	result = /obj/item/natural/clay/rawmoon
	reqs = list(/obj/item/natural/clay = 2)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/ceramics/claymug
	// Azure Peak
	name = "clay mug"
	result = /obj/item/natural/clay/rawmug
	reqs = list(/obj/item/natural/clay = 1)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 0

/datum/crafting_recipe/roguetown/ceramics/clayobelisk
	// Azure Peak
	name = "clay obelisk"
	result = /obj/item/natural/clay/rawobelisk
	reqs = list(/obj/item/natural/clay = 2)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/ceramics/clayoctopus
	// Azure Peak
	name = "clay octopus statuette"
	result = /obj/item/natural/clay/rawoctopus
	reqs = list(/obj/item/natural/clay = 3)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/ceramics/clayplatter
	// Azure Peak
	name = "clay platter"
	result = /obj/item/natural/clay/rawplatter
	reqs = list(/obj/item/natural/clay = 1)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics

/datum/crafting_recipe/roguetown/ceramics/claypot
	// Azure Peak
	name = "clay pot"
	result = /obj/item/natural/clay/rawpot
	reqs = list(/obj/item/natural/clay = 3)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/ceramics/clayring
	// Azure Peak
	name = "clay ring"
	result = /obj/item/natural/clay/rawring
	reqs = list(/obj/item/natural/clay = 1)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics

/datum/crafting_recipe/roguetown/ceramics/clayspoon
	// Azure Peak
	name = "clay spoon"
	result = /obj/item/natural/clay/rawspoon
	reqs = list(/obj/item/natural/clay = 1)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics

/datum/crafting_recipe/roguetown/ceramics/claystatuette
	// Azure Peak
	name = "clay statuette"
	result = /obj/item/natural/clay/rawstatuette
	reqs = list(/obj/item/natural/clay = 2)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/ceramics/claysun
	// Azure Peak
	name = "clay sun"
	result = /obj/item/natural/clay/rawsun
	reqs = list(/obj/item/natural/clay = 1)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/ceramics/claytablet
	// Azure Peak
	name = "clay tablet"
	result = /obj/item/natural/clay/rawtablet
	reqs = list(/obj/item/natural/clay = 2)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/ceramics/clayturtle
	// Azure Peak
	name = "clay turtle statuette"
	result = /obj/item/natural/clay/rawturtle
	reqs = list(/obj/item/natural/clay = 2)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/ceramics/clayurn
	// Azure Peak
	name = "clay urn"
	result = /obj/item/natural/clay/rawurn
	reqs = list(/obj/item/natural/clay = 3)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/ceramics/glass/bottles
	// Azure Peak
	name = "glass bottle (x2)"
	result = /obj/item/reagent_containers/glass/bottle
	reqs = list(/obj/item/natural/glass = 1)
	rogue_results = list(/obj/item/reagent_containers/glass/bottle)
	tool_paths = list(/obj/item/rogueweapon/blowrod)
	blacklist = list(/obj/item/natural/glass/heated)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/light/rogue/smelter

/datum/crafting_recipe/roguetown/ceramics/glass/carafe
	// Azure Peak
	name = "glass carafe"
	result = /obj/item/reagent_containers/glass/carafe/glass
	reqs = list(/obj/item/natural/glass = 1)
	tool_paths = list(/obj/item/rogueweapon/blowrod)
	blacklist = list(/obj/item/natural/glass/heated)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/light/rogue/smelter

/datum/crafting_recipe/roguetown/ceramics/glass/cups
	// Azure Peak
	name = "glass flute (x3)"
	result = /obj/item/reagent_containers/glass/cup/glass/flute
	reqs = list(/obj/item/natural/glass = 1)
	rogue_results = list(/obj/item/reagent_containers/glass/cup/glass/flute, /obj/item/reagent_containers/glass/cup/glass/flute)
	tool_paths = list(/obj/item/rogueweapon/blowrod)
	blacklist = list(/obj/item/natural/glass/heated)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/light/rogue/smelter

/datum/crafting_recipe/roguetown/ceramics/glass/smallcups
	// Azure Peak
	name = "glass cup (x3)"
	result = /obj/item/reagent_containers/glass/cup/glass/small
	reqs = list(/obj/item/natural/glass = 1)
	rogue_results = list(/obj/item/reagent_containers/glass/cup/glass/small, /obj/item/reagent_containers/glass/cup/glass/small)
	tool_paths = list(/obj/item/rogueweapon/blowrod)
	blacklist = list(/obj/item/natural/glass/heated)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/light/rogue/smelter

/datum/crafting_recipe/roguetown/ceramics/glass/statue
	// Azure Peak
	name = "glass statue"
	result = /obj/item/roguestatue/glass
	reqs = list(/obj/item/natural/glass = 1)
	tool_paths = list(/obj/item/rogueweapon/blowrod)
	blacklist = list(/obj/item/natural/glass/heated)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/light/rogue/smelter

/datum/crafting_recipe/roguetown/ceramics/glassraw_bone
	// Azure Peak
	name = "glass batch (using bonemeal)"
	result = /obj/item/natural/glassbatch
	reqs = list(/obj/item/natural/clay = 2, /obj/item/natural/ash = 2, /obj/item/alch/bonemeal = 1)
	tool_paths = list(/obj/item/reagent_containers/glass/mortar, /obj/item/pestle/rogue)
	blacklist = list(/obj/item/natural/ash/snappop_phoenix)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/ceramics/portable_hookah
	// Azure Peak
	name = "portable hookah"
	result = /obj/item/portable_hookah
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/clay = 2, /obj/item/candle = 1)
	category = "Pottery"
	rogue_skill = /datum/attribute/skill/craft/ceramics
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/cooking/blend/avantare
	// Azure Peak
	name = "avantare preparation"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/avantare
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/lemon = 1, /obj/item/alch/mentha = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "blends"
	rogue_verb_simple = "blend"

/datum/crafting_recipe/roguetown/cooking/blend/baothablend
	// Azure Peak
	name = "void blend"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/baothablend
	reqs = list(/obj/item/reagent_containers/lux_impure = 1, /obj/item/alch/atropa = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 4
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "blends"
	rogue_verb_simple = "blend"

/datum/crafting_recipe/roguetown/cooking/blend/barleytea
	// Azure Peak
	name = "barley tea preparation"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/barleytea
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/wheat = 1, /obj/item/alch/artemisia = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "blends"
	rogue_verb_simple = "blend"

/datum/crafting_recipe/roguetown/cooking/blend/chai
	// Azure Peak
	name = "chai blend"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/chai
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_ground = 1, /obj/item/reagent_containers/powder/rocknut = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "blends"
	rogue_verb_simple = "blend"

/datum/crafting_recipe/roguetown/cooking/blend/eoragrace
	// Azure Peak
	name = "Eora's grace blend"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/eoragrace
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1, /obj/item/alch/calendula = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 2
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "blends"
	rogue_verb_simple = "blend"

/datum/crafting_recipe/roguetown/cooking/blend/eoralove
	// Azure Peak
	name = "Eora's love blend"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/eoralove
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/blend/eoragrace = 1, /obj/item/reagent_containers/food/snacks/rogue/honey/spider = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 4
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "blends"
	rogue_verb_simple = "blend"

/datum/crafting_recipe/roguetown/cooking/blend/eoralovefake
	// Azure Peak
	name = "Eora's love blend (fake)"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/eoralovefake
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/blend/eoragrace = 1, /obj/item/reagent_containers/food/snacks/sugar = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "blends"
	rogue_verb_simple = "blend"

/datum/crafting_recipe/roguetown/cooking/blend/forgottenlove
	// Azure Peak
	name = "Sister's tea blend"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/forgottenlove
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/blend/baothablend = 1, /obj/item/reagent_containers/food/snacks/grown/rogue/blend/eoralove = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 6
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "blends"
	rogue_verb_simple = "blend"

/datum/crafting_recipe/roguetown/cooking/blend/frukkte
	// Azure Peak
	name = "frukkte preparation"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/frukkte
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/raisins = 1, /obj/item/reagent_containers/food/snacks/rogue/raisins/blackberry = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "blends"
	rogue_verb_simple = "blend"

/datum/crafting_recipe/roguetown/cooking/blend/fyrebloom
	// Azure Peak
	name = "fyrebloom preparation"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/fyrebloom
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 1, /obj/item/alch/manabloompowder = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "blends"
	rogue_verb_simple = "blend"

/datum/crafting_recipe/roguetown/cooking/blend/gerevine
	// Azure Peak
	name = "gerevine blend"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/gerevine
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/raisins = 1, /obj/item/alch/benedictus = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 2
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "blends"
	rogue_verb_simple = "blend"

/datum/crafting_recipe/roguetown/cooking/blend/kvass
	// Azure Peak
	name = "kvass preparation"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/kvass
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/toastcrumbs = 1, /obj/item/reagent_containers/food/snacks/rogue/raisins = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "blends"
	rogue_verb_simple = "blend"

/datum/crafting_recipe/roguetown/cooking/blend/mocha
	// Azure Peak
	name = "veranda coffee blend"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/mocha
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/coffeebeansroasted = 1, /obj/item/reagent_containers/food/snacks/chocolate/slice = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "blends"
	rogue_verb_simple = "blend"

/datum/crafting_recipe/roguetown/cooking/blend/raneshenbitters
	// Azure Peak
	name = "Raneshen bitters blend"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/raneshenbitters
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_ground = 1, /obj/item/alch/artemisia = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "blends"
	rogue_verb_simple = "blend"

/datum/crafting_recipe/roguetown/cooking/blend/ravoxcalm
	// Azure Peak
	name = "Ravox's calm blend"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/ravoxcalm
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/coffeebeansroasted = 1, /obj/item/alch/taraxacum = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "blends"
	rogue_verb_simple = "blend"

/datum/crafting_recipe/roguetown/cooking/blend/schorle
	// Azure Peak
	name = "apfelschorle preparation"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/schorle
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced = 1, /obj/item/reagent_containers/food/snacks/grown/manabloom = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "blends"
	rogue_verb_simple = "blend"

/datum/crafting_recipe/roguetown/cooking/blend/volfmilk
	// Azure Peak
	name = "vargmjölk syrup"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/volfmilk
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/raisins = 1, /obj/item/reagent_containers/food/snacks/rogue/raisins/raspberry = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE
	rogue_verb = "blends"
	rogue_verb_simple = "blend"

/datum/crafting_recipe/roguetown/cooking/cane_sugar
	// Azure Peak
	name = "sugar"
	result = /obj/item/reagent_containers/food/snacks/sugar
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/sugarcane = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/item/millstone

/datum/crafting_recipe/roguetown/cooking/corn_flour
	// Azure Peak
	name = "cornmeal"
	result = /obj/item/reagent_containers/powder/flour/cornmeal
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/maize = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/item/millstone

/datum/crafting_recipe/roguetown/cooking/millcoffee
	// Azure Peak
	name = "ground coffee cherries"
	result = /obj/item/reagent_containers/food/snacks/grown/coffeebeans
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/coffee = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/item/millstone

/datum/crafting_recipe/roguetown/cooking/mix_sbiten
	// Azure Peak
	name = "sbiten Brick"
	result = /obj/item/reagent_containers/food/snacks/mix_sbiten
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/honey = 1, /obj/item/reagent_containers/food/snacks/pumpkinspice = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 2
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/cooking/mix_taraxamint
	// Azure Peak
	name = "taraxacum-mentha tea mix"
	result = /obj/item/reagent_containers/food/snacks/mix_taraxamint
	reqs = list(/obj/item/alch/taraxacum = 1, /obj/item/alch/mentha = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/cooking/mix_utricasalvia
	// Azure Peak
	name = "utrica-salvia tea mix"
	result = /obj/item/reagent_containers/food/snacks/mix_utricasalvia
	reqs = list(/obj/item/alch/urtica = 1, /obj/item/alch/salvia = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_structure = /obj/structure/table/wood/rockhill
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/cooking/oat_flour
	// Azure Peak
	name = "oat flour"
	result = /obj/item/reagent_containers/powder/flour
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/oat = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/item/millstone

/datum/crafting_recipe/roguetown/cooking/powdernut
	// Azure Peak
	name = "ground rocknuts"
	result = /obj/item/reagent_containers/powder/rocknut
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/nut = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/item/millstone

/datum/crafting_recipe/roguetown/cooking/rice_flour
	// Azure Peak
	name = "rice flour"
	result = /obj/item/reagent_containers/powder/flour
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rice = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/item/millstone

/datum/crafting_recipe/roguetown/cooking/teagrind
	// Azure Peak
	name = "ground tea leaves"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_ground
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_dry = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/item/millstone

/datum/crafting_recipe/roguetown/cooking/tomatosauce
	// Azure Peak
	name = "tomato sauce"
	result = /obj/item/reagent_containers/food/snacks/grown/fruit/tomato_sauce
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/tomato = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/item/millstone

/datum/crafting_recipe/roguetown/cooking/wheat_flour
	// Azure Peak
	name = "wheat flour"
	result = /obj/item/reagent_containers/powder/flour
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/wheat = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 3
	rogue_structure = /obj/item/millstone

/datum/crafting_recipe/roguetown/dryazurrosa
	// Azure Peak
	name = "dry azurosa petals"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_dried/azure
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals/azure = 1)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 0
	rogue_structure = /obj/machinery/tanningrack
	rogue_verb = "dries"
	rogue_verb_simple = "dry"

/datum/crafting_recipe/roguetown/engineering/activator
	// Azure Peak
	name = "engineer's launcher"
	result = /obj/structure/englauncher
	reqs = list(/obj/item/roguegear = 1, /obj/item/natural/wood/plank = 4, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow = 1)
	blacklist = list(/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/aalloy, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/ancient, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/donator_stalkerino, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy/ancient, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy/paalloy, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy/relic, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy/relic/marque, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/iron, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow/donator_stalkerino, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow/stalker, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow/stalker/lesser, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/staker, /obj/item/roguegear/bronze, /obj/item/roguegear/wood, /obj/item/roguegear/wood/basic, /obj/item/roguegear/wood/reliable, /obj/item/roguegear/wood/unstable)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"

/datum/crafting_recipe/roguetown/engineering/bbomb_expert
	// Azure Peak
	name = "bottle bomb (clod jury rig)"
	result = /obj/item/explosive/fused/bottle
	reqs = list(/obj/item/natural/dirtclod = 3, /obj/item/natural/ash = 2, /obj/item/natural/fibers = 2)
	blacklist = list(/obj/item/natural/ash/snappop_phoenix, /obj/item/natural/dirtclod/sand, /obj/item/natural/dirtclod/snow)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/engineering/bbomb_expert_2
	// Azure Peak
	name = "bottle bomb (glass jury rig)"
	result = /obj/item/explosive/fused/bottle
	reqs = list(/obj/item/natural/glass_shard = 1, /obj/item/natural/ash = 2, /obj/item/natural/fibers = 2)
	blacklist = list(/obj/item/natural/ash/snappop_phoenix, /obj/item/natural/glass_shard/shrapnel)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/engineering/bbomb_expert_3
	// Azure Peak
	name = "bottle bomb (shard jury rig)"
	result = /obj/item/explosive/fused/bottle
	reqs = list(/obj/item/natural/glass_shard/shrapnel = 1, /obj/item/natural/ash = 2, /obj/item/natural/fibers = 2)
	blacklist = list(/obj/item/natural/ash/snappop_phoenix)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/engineering/bombtrap
	// Azure Peak
	name = "bomb trap (engineered)"
	result = /obj/structure/trap/bomb
	reqs = list(/obj/item/roguegear = 1, /obj/item/natural/clay = 1, /obj/item/roguegem/amethyst = 1, /obj/item/explosive/impact/shrapnel = 1)
	blacklist = list(/obj/item/roguegear/bronze, /obj/item/roguegear/wood, /obj/item/roguegear/wood/basic, /obj/item/roguegear/wood/reliable, /obj/item/roguegear/wood/unstable)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 6

/datum/crafting_recipe/roguetown/engineering/floorgrille
	// Azure Peak
	name = "floorgrille"
	result = /obj/structure/bars/grille
	reqs = list(/obj/item/ingot/iron = 1, /obj/item/roguegear = 1)
	blacklist = list(/obj/item/roguegear/bronze, /obj/item/roguegear/wood, /obj/item/roguegear/wood/basic, /obj/item/roguegear/wood/reliable, /obj/item/roguegear/wood/unstable)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 3
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"

/datum/crafting_recipe/roguetown/engineering/gate
	// Azure Peak
	name = "gate"
	result = /obj/structure/bars/passage
	reqs = list(/obj/item/ingot/iron = 1, /obj/item/roguegear = 1)
	blacklist = list(/obj/item/roguegear/bronze, /obj/item/roguegear/wood, /obj/item/roguegear/wood/basic, /obj/item/roguegear/wood/reliable, /obj/item/roguegear/wood/unstable)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 2
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"

/datum/crafting_recipe/roguetown/engineering/impactexplosive_expert
	// Azure Peak
	name = "impact grenades (fyritius jury rig)"
	result = /obj/item/explosive/impact/shrapnel
	reqs = list(/obj/item/scrap = 1, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 1, /obj/item/natural/fibers = 3)
	blacklist = list(/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/engineering/impactexplosive_expert_2
	// Azure Peak
	name = "impact grenades (infernal jury rig)"
	result = /obj/item/explosive/impact/shrapnel
	reqs = list(/obj/item/scrap = 1, /obj/item/magic/infernal/ash = 1, /obj/item/natural/fibers = 3)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/engineering/impactexplosive_expert_3
	// Azure Peak
	name = "impact grenades (coal dust jury rig)"
	result = /obj/item/explosive/impact/shrapnel
	reqs = list(/obj/item/scrap = 1, /obj/item/alch/coaldust = 1, /obj/item/natural/fibers = 3)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/engineering/pressure_plate
	// Azure Peak
	name = "pressure plate"
	result = /obj/structure/pressure_plate
	reqs = list(/obj/item/roguegear = 1, /obj/item/natural/wood/plank = 2)
	blacklist = list(/obj/item/roguegear/bronze, /obj/item/roguegear/wood, /obj/item/roguegear/wood/basic, /obj/item/roguegear/wood/reliable, /obj/item/roguegear/wood/unstable)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 2
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"

/datum/crafting_recipe/roguetown/engineering/rocktrap
	// Azure Peak
	name = "rock trap (engineered)"
	result = /obj/structure/trap/rock_fall
	reqs = list(/obj/item/roguegear = 1, /obj/item/natural/clay = 1, /obj/item/roguegem/amethyst = 1, /obj/item/natural/rock = 1)
	blacklist = list(/obj/item/natural/rock/cinnabar, /obj/item/natural/rock/coal, /obj/item/natural/rock/copper, /obj/item/natural/rock/desert, /obj/item/natural/rock/dungeon, /obj/item/natural/rock/elementalmote, /obj/item/natural/rock/gem, /obj/item/natural/rock/gold, /obj/item/natural/rock/iron, /obj/item/natural/rock/random, /obj/item/natural/rock/random_ore, /obj/item/natural/rock/salt, /obj/item/natural/rock/silver, /obj/item/natural/rock/tin, /obj/item/roguegear/bronze, /obj/item/roguegear/wood, /obj/item/roguegear/wood/basic, /obj/item/roguegear/wood/reliable, /obj/item/roguegear/wood/unstable)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/engineering/roller
	// Azure Peak
	name = "rollers (4x)"
	result = /obj/item/rotation_contraption/roller
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/grown/log/tree/stick = 4, /obj/item/roguegear = 2)
	rogue_results = list(/obj/item/rotation_contraption/roller, /obj/item/rotation_contraption/roller, /obj/item/rotation_contraption/roller)
	blacklist = list(/obj/item/roguegear/bronze, /obj/item/roguegear/wood, /obj/item/roguegear/wood/basic, /obj/item/roguegear/wood/reliable, /obj/item/roguegear/wood/unstable)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 4
	rogue_verb = "engineers"
	rogue_verb_simple = "engineer"

/datum/crafting_recipe/roguetown/farming/stockbait
	// Azure Peak
	name = "stockbait (via farming)"
	result = /obj/item/bait/stockbait
	reqs = list(/obj/item/storage/roguebag = 1, /obj/item/natural/chaff/wheat = 1, /obj/item/reagent_containers/food/snacks/roastseeds = 1, /obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1, /obj/item/natural/cured/essence = 1)
	category = "Farming"
	rogue_skill = /datum/attribute/skill/labor/farming
	rogue_difficulty = 5
	rogue_verb_simple = "mix"

/datum/crafting_recipe/roguetown/fleshcrafting/imperfect_gnoll_alt
	// Azure Peak
	name = "vilespawn flesh (from crystallized glut)"
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/vilespawn
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll = 1, /obj/item/ingot/component/glutcrystal = 1)
	category = "Butchering"
	rogue_skill = /datum/attribute/skill/labor/butchering
	rogue_verb_simple = "assembles"

/datum/crafting_recipe/roguetown/fleshcrafting/leechbait_leech
	// Azure Peak
	name = "leechbait (from bag - with tick)"
	result = /obj/item/bait/leech
	reqs = list(/obj/item/storage/roguebag = 1, /obj/item/leechtick_bloated = 1)
	rogue_results = list(/obj/item/bait/leech, /obj/item/bait/leech)
	category = "Butchering"
	rogue_skill = /datum/attribute/skill/labor/butchering
	rogue_verb_simple = "assembles"

/datum/crafting_recipe/roguetown/fleshcrafting/leechbait_leech_perfect
	// Azure Peak
	name = "perfect leechbait (from cloth - with tick)"
	result = /obj/item/bait/leech/perfect
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/leechtick_bloated = 1)
	rogue_results = list(/obj/item/bait/leech/perfect, /obj/item/bait/leech/perfect)
	category = "Medicine"
	rogue_skill = /datum/attribute/skill/misc/medicine
	rogue_difficulty = 5
	rogue_verb_simple = "assembles"

/datum/crafting_recipe/roguetown/fleshcrafting/leechbaitcloth
	// Azure Peak
	name = "leechbait (from cloth)"
	result = /obj/item/bait/leech
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/reagent_containers/lux_impure = 1)
	rogue_results = list(/obj/item/bait/leech, /obj/item/bait/leech)
	category = "Butchering"
	rogue_skill = /datum/attribute/skill/labor/butchering
	rogue_verb_simple = "assembles"

/datum/crafting_recipe/roguetown/fleshcrafting/leechbaitcloth_leech
	// Azure Peak
	name = "leechbait (from cloth - with tick)"
	result = /obj/item/bait/leech
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/leechtick_bloated = 1)
	rogue_results = list(/obj/item/bait/leech, /obj/item/bait/leech)
	category = "Butchering"
	rogue_skill = /datum/attribute/skill/labor/butchering
	rogue_verb_simple = "assembles"

/datum/crafting_recipe/roguetown/fleshcrafting/leechbaitcloth_perfect
	// Azure Peak
	name = "perfect leechbait (from cloth)"
	result = /obj/item/bait/leech/perfect
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/reagent_containers/lux_impure = 1)
	rogue_results = list(/obj/item/bait/leech/perfect, /obj/item/bait/leech/perfect)
	category = "Butchering"
	rogue_skill = /datum/attribute/skill/labor/butchering
	rogue_verb_simple = "assembles"

/datum/crafting_recipe/roguetown/gemcarving/amber/kaskara
	// Azure Peak
	name = "amber kaskara"
	result = /obj/item/rogueweapon/sword/amber
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5

/datum/crafting_recipe/roguetown/gemcarving/coral/nsapo
	// Azure Peak
	name = "heartstone nsapo"
	result = /obj/item/rogueweapon/stoneaxe/battle/coral
	reqs = list(/obj/item/roguegem/coral = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5

/datum/crafting_recipe/roguetown/gemcarving/onyxa/macuahuitl
	// Azure Peak
	name = "onyxa macuahuitl"
	result = /obj/item/rogueweapon/sword/short/messer/onyxa
	reqs = list(/obj/item/roguegem/onyxa = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5

/datum/crafting_recipe/roguetown/gemcarving/rose/dagger
	// Azure Peak
	name = "rosestone dagger"
	result = /obj/item/rogueweapon/huntingknife/idagger/steel/rondel/rose
	reqs = list(/obj/item/carvedgem/rose/rawrose = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5

/datum/crafting_recipe/roguetown/gemcarving/turq/spear
	// Azure Peak
	name = "cerulite spear"
	result = /obj/item/rogueweapon/spear/turq
	reqs = list(/obj/item/roguegem/turq = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 5

/datum/crafting_recipe/roguetown/hunting/baito
	// Azure Peak
	name = "bait (oats)"
	result = /obj/item/bait
	reqs = list(/obj/item/storage/roguebag = 1, /obj/item/reagent_containers/food/snacks/grown/oat = 2)
	category = "Hunting"
	rogue_skill = /datum/attribute/skill/misc/hunting
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/hunting/baitr
	// Azure Peak
	name = "bait (rice)"
	result = /obj/item/bait
	reqs = list(/obj/item/storage/roguebag = 1, /obj/item/reagent_containers/food/snacks/grown/rice = 2)
	category = "Hunting"
	rogue_skill = /datum/attribute/skill/misc/hunting
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/hunting/goat_horn
	// Azure Peak
	name = "goat horn bundle"
	result = /obj/item/natural/goathorn
	reqs = list(/obj/item/natural/head/goat_wild = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Butchering"
	rogue_skill = /datum/attribute/skill/labor/butchering
	rogue_difficulty = 5

/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_armor/coat/tailcoat
	// Azure Peak
	name = "tailcoat"
	result = /obj/item/clothing/suit/roguetown/armor/leather/heavy/tailcoat
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/natural/fibers = 1)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/tanningrack
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = null
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/leather/belt_alt
	// Azure Peak
	name = "pouched suspenders"
	result = /obj/item/clothing/cloak/suspenders
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/cloth = 2, /obj/item/storage/belt/rogue/pouch = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/leather/container/boltpouch
	// Azure Peak
	name = "quiver, bolt pouch"
	result = /obj/item/quiver/bolt
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/leather/container/grenstrap
	// Azure Peak
	name = "grenadier bandolier"
	result = /obj/item/twstrap/bombstrap
	reqs = list(/obj/item/natural/hide/cured = 3, /obj/item/rope = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/leather/container/heavyboltpouch
	// Azure Peak
	name = "quiver, heavy bolt pouch"
	result = /obj/item/quiver/bolt/heavy
	reqs = list(/obj/item/natural/hide/cured = 3, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/leather/container/satchel/black
	// Azure Peak
	name = "black satchel"
	result = /obj/item/storage/backpack/rogue/satchel/black
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/fibers = 1)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 1
	rogue_structure = /obj/machinery/tanningrack
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = null
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/leather/container/satchelshort/black
	// Azure Peak
	name = "short black satchel"
	result = /obj/item/storage/backpack/rogue/satchel/short/black
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/fibers = 1)
	rogue_results = null
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 1
	rogue_structure = /obj/machinery/tanningrack
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = null
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/leather/container/stakepouch
	// Azure Peak
	name = "quiver, shotstake pouch"
	result = /obj/item/quiver/bolt/stake
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/leather/container/tailsatchel
	// Azure Peak
	name = "tail satchel"
	result = /obj/item/storage/backpack/rogue/satchel/tailchel
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/leather/doctormaskphys
	// Azure Peak
	name = "head physician's mask"
	result = /obj/item/clothing/mask/rogue/courtphysician
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/bone = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_structure = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/leather/heavyglovesfeld
	// Azure Peak
	name = "heavy leather gloves, feldsher's"
	result = /obj/item/clothing/gloves/roguetown/angle/feld
	reqs = list(/obj/item/natural/fur = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/leather/heavyglovesphys
	// Azure Peak
	name = "heavy leather gloves, physicker's"
	result = /obj/item/clothing/gloves/roguetown/angle/phys
	reqs = list(/obj/item/natural/fur = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/leather/reinforcement/studded/bikini
	// Azure Peak
	name = "studded leather corslet"
	result = /obj/item/clothing/suit/roguetown/armor/leather/studded/bikini
	reqs = list(/obj/item/clothing/suit/roguetown/armor/leather = 1, /obj/item/scrap = 1, /obj/item/reagent_containers/food/snacks/fat = 1)
	tool_paths = list(/obj/item/needle, /obj/item/rogueweapon/hammer)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/leather/reinforcement/studded/chestplate
	// Azure Peak
	name = "studded leather chestplate"
	result = /obj/item/clothing/suit/roguetown/armor/leather/studded
	reqs = list(/obj/item/clothing/suit/roguetown/armor/leather = 1, /obj/item/scrap = 2, /obj/item/reagent_containers/food/snacks/fat = 1)
	tool_paths = list(/obj/item/needle, /obj/item/rogueweapon/hammer)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/leather/reinforcement/studded/cuirbouilli
	// Azure Peak
	name = "studded leather cuirass, 'cuir-bouilli'-style"
	result = /obj/item/clothing/suit/roguetown/armor/leather/studded/cuirbouilli
	reqs = list(/obj/item/clothing/suit/roguetown/armor/leather/cuirass = 1, /obj/item/scrap = 2, /obj/item/reagent_containers/food/snacks/fat = 1)
	tool_paths = list(/obj/item/needle, /obj/item/rogueweapon/hammer)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/leather/reinforcement/studded/forester
	// Azure Peak
	name = "forester's brigandine"
	result = /obj/item/clothing/suit/roguetown/armor/leather/studded/warden/upgraded
	reqs = list(/obj/item/clothing/suit/roguetown/armor/leather/studded/warden = 1, /obj/item/natural/cured/essence = 1, /obj/item/reagent_containers/food/snacks/fat = 1)
	tool_paths = list(/obj/item/needle, /obj/item/rogueweapon/hammer)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/leather/reinforcement/studded/hood
	// Azure Peak
	name = "studded leather hood"
	result = /obj/item/clothing/head/roguetown/roguehood/studded
	reqs = list(/obj/item/clothing/head/roguetown/roguehood = 1, /obj/item/scrap = 1, /obj/item/reagent_containers/food/snacks/fat = 1)
	tool_paths = list(/obj/item/needle, /obj/item/rogueweapon/hammer)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 2
	rogue_structure = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/leather/rosacoat/three
	// Azure Peak
	name = "royal coat"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/rosacoat/three
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/silk = 2, /obj/item/alch/rosa = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/leather/rosagloves/two
	// Azure Peak
	name = "scarlet gloves"
	result = /obj/item/clothing/gloves/roguetown/rosa/two
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/leather/rosashoes/six
	// Azure Peak
	name = "maroon shoes"
	result = /obj/item/clothing/shoes/roguetown/rosa/six
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/leather/rosashoes/two
	// Azure Peak
	name = "scarlet shoes"
	result = /obj/item/clothing/shoes/roguetown/rosa/two
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/leather/sanguinecoat
	// Azure Peak
	name = "sanguine coat"
	result = /obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket/courtphysician
	reqs = list(/obj/item/natural/hide/cured = 3)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/leather/sanguinegloves
	// Azure Peak
	name = "sanguine gloves"
	result = /obj/item/clothing/gloves/roguetown/courtphysician
	reqs = list(/obj/item/natural/hide/cured = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/leather/sanguinejacket
	// Azure Peak
	name = "sanguine jacket"
	result = /obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket/courtphysician/female
	reqs = list(/obj/item/natural/hide/cured = 3)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/leather/sanguinesleeves
	// Azure Peak
	name = "sanguine sleeves"
	result = /obj/item/clothing/gloves/roguetown/courtphysician/female
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/leather/unique/grenzelgloves
	// Azure Peak
	name = "grenzelhoftian gloves"
	result = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/natural/fur = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 6
	rogue_structure = /obj/machinery/tanningrack
	crafting_flags = CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/roguetown/leather/unique/gronnboots
	// Azure Peak
	name = "atgervi leather boots"
	result = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/atgervi
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/fibers = 1, /obj/item/natural/fur = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	crafting_flags = CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/roguetown/leather/unique/gronngloves
	// Azure Peak
	name = "fur-lined leather gloves"
	result = /obj/item/clothing/gloves/roguetown/angle/atgervi
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/fibers = 1, /obj/item/natural/fur = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	crafting_flags = CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/roguetown/leather/unique/gronnpants
	// Azure Peak
	name = "fur pants"
	result = /obj/item/clothing/under/roguetown/trou/leather/atgervi
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/natural/fibers = 1, /obj/item/natural/fur = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 5
	rogue_structure = /obj/machinery/tanningrack
	crafting_flags = CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/roguetown/leather/unique/otavanleathergloves
	// Azure Peak
	name = "otavan leather gloves"
	result = /obj/item/clothing/gloves/roguetown/otavan
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/natural/fur = 1, /obj/item/natural/fibers = 1, /obj/item/natural/cloth = 1)
	tool_paths = list(/obj/item/needle)
	category = "Skincrafting"
	rogue_skill = /datum/attribute/skill/craft/tanning
	rogue_difficulty = 6
	rogue_structure = /obj/machinery/tanningrack
	crafting_flags = CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/roguetown/reading/goat_map
	// Azure Peak
	name = "goat map"
	result = /obj/item/hunting_map/goats
	reqs = list(/obj/item/paper/scroll = 3, /obj/item/natural/hide = 1)
	tool_paths = list(/obj/item/natural/feather)
	category = "Literacy"
	rogue_skill = /datum/attribute/skill/misc/reading
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_verb_simple = "write"

/datum/crafting_recipe/roguetown/sewing/abyssortemplar
	// Azure Peak
	name = "tabard, abyssorite templar"
	result = /obj/item/clothing/cloak/tabard/abyssorite
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/sewing/apron/cook
	// Azure Peak
	name = "cooking apron"
	result = /obj/item/clothing/cloak/apron/cook
	reqs = list(/obj/item/natural/cloth = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0

/datum/crafting_recipe/roguetown/sewing/armingcap
	// Azure Peak
	name = "arming cap"
	result = /obj/item/clothing/head/roguetown/armingcap
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/sewing/astratahoodstonekeep
	// Azure Peak
	name = "turn sun hood into sunwrought visage"
	result = /obj/item/clothing/head/roguetown/roguehood/astrata/stonekeep
	reqs = list(/obj/item/clothing/head/roguetown/roguehood/astrata = 1, /obj/item/clothing/mask/rogue/facemask/goldmask = 1)
	tool_paths = list(/obj/item/needle)
	category = "Miracles"
	rogue_skill = /datum/attribute/skill/magic/holy
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/sewing/astratahoodstonekeepalt
	// Azure Peak
	name = "turn sun hood into sunwrought visage"
	result = /obj/item/clothing/head/roguetown/roguehood/astrata/stonekeep
	reqs = list(/obj/item/clothing/head/roguetown/roguehood/astrata = 1, /obj/item/clothing/mask/rogue/facemask/goldmaskc = 1)
	tool_paths = list(/obj/item/needle)
	category = "Miracles"
	rogue_skill = /datum/attribute/skill/magic/holy
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/sewing/astratatemplar
	// Azure Peak
	name = "tabard, astratan templar"
	result = /obj/item/clothing/cloak/templar/astratan
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/sewing/bandages_underwear
	// Azure Peak
	name = "bandages (underwear)"
	result = /obj/item/undies/bandages
	reqs = list(/obj/item/natural/cloth/bandage = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/sewing/battlenun
	// Azure Peak
	name = "tabard, battle-nun"
	result = /obj/item/clothing/cloak/battlenun
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/sewing/clothknapsack
	// Azure Peak
	name = "cloth knapsack"
	result = /obj/item/storage/backpack/rogue/satchel/cloth
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing

/datum/crafting_recipe/roguetown/sewing/clothpaddedgloves
	// Azure Peak
	name = "padded gloves"
	result = /obj/item/clothing/gloves/roguetown/cloth
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/sewing/clothpouch
	// Azure Peak
	name = "cloth pouch"
	result = /obj/item/storage/belt/rogue/pouch/cloth
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing

/datum/crafting_recipe/roguetown/sewing/eoratemplar
	// Azure Peak
	name = "tabard, eoran templar"
	result = /obj/item/clothing/cloak/templar/eoran
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/sewing/exoticcarpet
	// Azure Peak
	name = "Exotic Carpet (1 use)"
	result = /obj/item/carpet/exotic
	reqs = list(/obj/item/natural/silk = 4)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5

/datum/crafting_recipe/roguetown/sewing/feldcollar
	// Azure Peak
	name = "collar, feldsher's"
	result = /obj/item/clothing/neck/roguetown/collar/feldcollar
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/sewing/footwrap
	// Azure Peak
	name = "bandages, ankles"
	result = /obj/item/clothing/shoes/roguetown/footwraps
	reqs = list(/obj/item/natural/cloth = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing

/datum/crafting_recipe/roguetown/sewing/formalbreeches
	// Azure Peak
	name = "formal breeches"
	result = /obj/item/clothing/under/roguetown/tights/puritan
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5

/datum/crafting_recipe/roguetown/sewing/formalsilkjacket
	// Azure Peak
	name = "besilked jacket"
	result = /obj/item/clothing/suit/roguetown/armor/gambeson/lord/heavy/silkjacket
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 6)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5

/datum/crafting_recipe/roguetown/sewing/formalsilks
	// Azure Peak
	name = "formal silks"
	result = /obj/item/clothing/suit/roguetown/shirt/undershirt/puritan
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5

/datum/crafting_recipe/roguetown/sewing/gambesonskirt
	// Azure Peak
	name = "gambesoned kilt"
	result = /obj/item/clothing/under/roguetown/skirt/gambeson
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/sewing/grenzelsalletvis
	// Azure Peak
	name = "grenzelhoftian hat with visored sallet"
	result = /obj/item/clothing/head/roguetown/helmet/sallet/visored/grenzelhoft
	reqs = list(/obj/item/clothing/head/roguetown/grenzelhofthat = 1, /obj/item/clothing/head/roguetown/helmet/sallet/visored = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0
	rogue_skip_quality = TRUE

/datum/crafting_recipe/roguetown/sewing/grenzelsalletvis/off
	// Azure Peak
	name = "take hat off visored sallet"
	result = /obj/item/clothing/head/roguetown/grenzelhofthat
	reqs = list(/obj/item/clothing/head/roguetown/helmet/sallet/visored/grenzelhoft = 1)
	rogue_results = list(/obj/item/clothing/head/roguetown/helmet/sallet/visored)
	tool_paths = list(/obj/item/needle)
	parts = null
	blacklist = null
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 0
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = null
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = TRUE

/datum/crafting_recipe/roguetown/sewing/harmingjacket
	// Azure Peak
	name = "padded arming jacket"
	result = /obj/item/clothing/suit/roguetown/armor/gambeson/lord/heavy
	reqs = list(/obj/item/natural/cloth = 5, /obj/item/natural/fibers = 5)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/sewing/hgambesonskirt
	// Azure Peak
	name = "padded gambesoned kilt"
	result = /obj/item/clothing/under/roguetown/skirt/gambeson/heavy
	reqs = list(/obj/item/natural/cloth = 6, /obj/item/natural/fibers = 4)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/sewing/hunterheadband
	// Azure Peak
	name = "roughspun headband"
	result = /obj/item/clothing/head/roguetown/headband/monk/barbarian
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/sewing/larmingjacket
	// Azure Peak
	name = "light arming jacket"
	result = /obj/item/clothing/suit/roguetown/armor/gambeson/lord/light
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/sewing/lgambesonskirt
	// Azure Peak
	name = "light gambesoned kilt"
	result = /obj/item/clothing/under/roguetown/skirt/gambeson/light
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing

/datum/crafting_recipe/roguetown/sewing/loudmouth_headgear
	// Azure Peak
	name = "loudmouth's headcover"
	result = /obj/item/clothing/head/roguetown/veiled/loudmouth
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/sewing/loudmouth_robes
	// Azure Peak
	name = "crier's garb"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress/loudmouth
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/sewing/lunarrobe
	// Azure Peak
	name = "moonlit robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/lunar
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/sewing/magerobes
	// Azure Peak
	name = "mage robe"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/magician
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/sewing/malumtemplar
	// Azure Peak
	name = "tabard, malumite templar"
	result = /obj/item/clothing/cloak/templar/malumite
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/sewing/necratemplar
	// Azure Peak
	name = "tabard, necran templar"
	result = /obj/item/clothing/cloak/templar/necran
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/sewing/noble
	// Azure Peak
	name = "noble's pinafore"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/nobledress
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/sewing/paddedchausses
	// Azure Peak
	name = "padded chausses"
	result = /obj/item/clothing/under/roguetown/tights/clothlegs
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/sewing/paddedchaussesalt
	// Azure Peak
	name = "padded chausses, alternate"
	result = /obj/item/clothing/under/roguetown/tights/clothlegs
	reqs = list(/obj/item/clothing/under/roguetown/tights/hose = 1, /obj/item/clothing/under/roguetown/trou/leather = 1, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/sewing/psydonhood
	// Azure Peak
	name = "hood, psydonic"
	result = /obj/item/clothing/head/roguetown/roguehood/psydon/black
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/sewing/psydonhoodinq
	// Azure Peak
	name = "hood, psydonian orthodoxist"
	result = /obj/item/clothing/head/roguetown/roguehood/psydon
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/sewing/psydoninq
	// Azure Peak
	name = "tabard, psydonian orthodoxist"
	result = /obj/item/clothing/cloak/tabard/psydontabard
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/sewing/psydonold
	// Azure Peak
	name = "tabard, psydonian devotee"
	result = /obj/item/clothing/cloak/tabard/devotee/psydon
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/sewing/saigataurbarding_cloth
	// Azure Peak
	name = "cloth saiga barding"
	result = /obj/item/clothing/suit/roguetown/armor/saiga_barding/cloth
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/sewing/saigataurbarding_leather
	// Azure Peak
	name = "leather saiga barding"
	result = /obj/item/clothing/suit/roguetown/armor/saiga_barding/leather
	reqs = list(/obj/item/natural/hide/cured = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/sewing/saigataurbarding_padded
	// Azure Peak
	name = "padded saiga barding"
	result = /obj/item/clothing/suit/roguetown/armor/saiga_barding/padded
	reqs = list(/obj/item/natural/cloth = 5, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/sewing/saigataurtabard
	// Azure Peak
	name = "saiga tabard"
	result = /obj/item/clothing/cloak/tabard/saiga
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/sewing/sanguinetrousers
	// Azure Peak
	name = "sanguine trousers"
	result = /obj/item/clothing/under/roguetown/trou/leather/courtphysician
	reqs = list(/obj/item/natural/silk = 3)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/sewing/shalwar
	// Azure Peak
	name = "shalwar pants"
	result = /obj/item/clothing/under/roguetown/tights/shalwar
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/sewing/shawlhood
	// Azure Peak
	name = "shawl (hijab)"
	result = /obj/item/clothing/head/roguetown/roguehood/shawlhood
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/sewing/silkbelt
	// Azure Peak
	name = "giltsilk belt"
	result = /obj/item/storage/belt/rogue/leather/silkbelt
	reqs = list(/obj/item/natural/silk = 5)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 6

/datum/crafting_recipe/roguetown/sewing/silkmask
	// Azure Peak
	name = "giltsilk mask"
	result = /obj/item/clothing/mask/rogue/silkmask
	reqs = list(/obj/item/natural/silk = 5)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 6

/datum/crafting_recipe/roguetown/sewing/sleeves_ankle_silk_white
	// Azure Peak
	name = "silk sleeves - ankle (stirrup)"
	result = /obj/item/legwears/sleeve_stir_ankle_silk/white
	reqs = list(/obj/item/natural/silk = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5

/datum/crafting_recipe/roguetown/sewing/sleeves_knee_silk_white
	// Azure Peak
	name = "silk sleeves - knee (stirrup)"
	result = /obj/item/legwears/sleeve_stir_knee_silk/white
	reqs = list(/obj/item/natural/silk = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5

/datum/crafting_recipe/roguetown/sewing/sleeves_thigh_silk_white
	// Azure Peak
	name = "silk sleeves - thigh (stirrup)"
	result = /obj/item/legwears/sleeve_stir_thigh_silk/white
	reqs = list(/obj/item/natural/silk = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5

/datum/crafting_recipe/roguetown/sewing/stabardheavy
	// Azure Peak
	name = "surcoat, overvestments"
	result = /obj/item/clothing/cloak/tabard/stabard/overvestments
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/sewing/standardcarpet
	// Azure Peak
	name = "Standard Carpet (6 use)"
	result = /obj/item/carpet/standard
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 4)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/sewing/stockings_knee_silk_white
	// Azure Peak
	name = "silk stockings - knee"
	result = /obj/item/legwears/knee_high_silk/white
	reqs = list(/obj/item/natural/silk = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5

/datum/crafting_recipe/roguetown/sewing/stockings_thigh_silk_white
	// Azure Peak
	name = "silk stockings - thigh"
	result = /obj/item/legwears/thigh_high_silk/white
	reqs = list(/obj/item/natural/silk = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5

/datum/crafting_recipe/roguetown/sewing/surcoatgoldlegacy
	// Azure Peak
	name = "ancient surcoat of the golden order"
	result = /obj/item/clothing/cloak/tabard/stabard/crusader/legacy
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/sewing/surcoatgolduni
	// Azure Peak
	name = "surcoat of the golden order, undivided"
	result = /obj/item/clothing/cloak/tabard/stabard/crusader/undivided
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/sewing/surcoatsilverlegacy
	// Azure Peak
	name = "ancient surcoat of the silver order"
	result = /obj/item/clothing/cloak/tabard/stabard/crusader/t/legacy
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/sewing/surcoatsilveruni
	// Azure Peak
	name = "surcoat of the silver order, undivided"
	result = /obj/item/clothing/cloak/tabard/stabard/crusader/t/undivided
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/sewing/tailor/otavangambeson
	// Azure Peak
	name = "otavan gambeson"
	result = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan
	reqs = list(/obj/item/natural/cloth = 6, /obj/item/natural/fibers = 5)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 6
	crafting_flags = CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/roguetown/sewing/thinwinterdress
	// Azure Peak
	name = "thin winter dress"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/thinwinterdress
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2, /obj/item/natural/silk = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 5

/datum/crafting_recipe/roguetown/sewing/undies_eoran
	// Azure Peak
	name = "briefs - eoran"
	result = /obj/item/undies/briefs_eoran
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/sewing/undividedclericcloak
	// Azure Peak
	name = "cloak, undivided devotee"
	result = /obj/item/clothing/cloak/undividedcleric
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/sewing/undividedclerictabard
	// Azure Peak
	name = "tabard, undivided devotee"
	result = /obj/item/clothing/cloak/templar/undividedcleric
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/sewing/undividedtemplar
	// Azure Peak
	name = "tabard, undivided templar"
	result = /obj/item/clothing/cloak/templar/undivided
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/sewing/valorian_maidapron
	// Azure Peak
	name = "valorian maid apron"
	result = /obj/item/clothing/cloak/apron/waist/fancymaid
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/sewing/valorian_maidband
	// Azure Peak
	name = "valorian maid headband"
	result = /obj/item/clothing/head/roguetown/maidband
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/sewing/wintercoat
	// Azure Peak
	name = "winter coat"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/winter
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 2)
	tool_paths = list(/obj/item/needle)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing

/datum/crafting_recipe/roguetown/stealth/puddy_butter
	// Azure Peak
	name = "Wax Putty (Butter slices & Flour)"
	result = /obj/item/waxputty
	reqs = list(/obj/item/reagent_containers/food/snacks/butterslice = 3, /obj/item/reagent_containers/powder/flour = 2)
	blacklist = list(/obj/item/reagent_containers/powder/flour/cornmeal)
	category = "Sneaking"
	rogue_skill = /datum/attribute/skill/misc/sneaking
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/stealth/puddy_candles
	// Azure Peak
	name = "Wax Putty (Candles)"
	result = /obj/item/waxputty
	reqs = list(/obj/item/candle = 5)
	category = "Sneaking"
	rogue_skill = /datum/attribute/skill/misc/sneaking
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/stealth/puddy_recycle
	// Azure Peak
	name = "Wax Putty (Recycle)"
	result = /obj/item/waxputty
	reqs = list(/obj/item/waxputty_used = 2)
	category = "Sneaking"
	rogue_skill = /datum/attribute/skill/misc/sneaking
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/stealth/puddy_tallow
	// Azure Peak
	name = "Wax Putty (Tallow)"
	result = /obj/item/waxputty
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 2)
	blacklist = list(/obj/item/reagent_containers/food/snacks/tallow/black, /obj/item/reagent_containers/food/snacks/tallow/red, /obj/item/reagent_containers/food/snacks/tallow/soft)
	category = "Sneaking"
	rogue_skill = /datum/attribute/skill/misc/sneaking
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/structure/baotha_cross_meat
	// Azure Peak
	name = "webbed spider cross"
	result = /obj/structure/fluff/psycross/baotha/decorated
	reqs = list(/obj/item/natural/stone = 3, /obj/item/natural/silk = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	crafting_flags = CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/roguetown/structure/ceramicswheelalt
	// Azure Peak
	name = "potter's wheel, alternate"
	result = /obj/structure/fluff/ceramicswheel
	reqs = list(/obj/item/natural/stone = 2, /obj/item/grown/log/tree/small = 2, /obj/item/roguegear = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"

/datum/crafting_recipe/roguetown/structure/chest_wood_plain
	// Azure Peak
	name = "chest (wooden)"
	result = /obj/structure/closet/crate/wooden/rockhill/crate/roguecloset/inn/chest
	reqs = list(/obj/item/grown/log/tree/small = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"

/datum/crafting_recipe/roguetown/structure/chest_wood_plain_alt
	// Azure Peak
	name = "chest (wooden, old, alt)"
	result = /obj/structure/closet/crate/wooden/rockhill/crate/chest/old_crate
	reqs = list(/obj/item/grown/log/tree/small = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"

/datum/crafting_recipe/roguetown/structure/chest_wood_sturdy
	// Azure Peak
	name = "chest (wooden, sturdy)"
	result = /obj/structure/closet/crate/wooden/rockhill/crate/chest/neu
	reqs = list(/obj/item/grown/log/tree/small = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"

/datum/crafting_recipe/roguetown/structure/closet_wood_inn
	// Azure Peak
	name = "closet (wide, inn)"
	result = /obj/structure/closet/crate/wooden/rockhill/crate/roguecloset/inn/south
	reqs = list(/obj/item/grown/log/tree/small = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"

/datum/crafting_recipe/roguetown/structure/drawer_wood
	// Azure Peak
	name = "drawer (small)"
	result = /obj/structure/closet/crate/wooden/rockhill/crate/drawer/inn
	reqs = list(/obj/item/grown/log/tree/small = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"

/datum/crafting_recipe/roguetown/structure/graggar_cross_meat
	// Azure Peak
	name = "revered vicious cross"
	result = /obj/structure/fluff/psycross/graggar/decorated
	reqs = list(/obj/item/natural/stone = 3, /obj/item/reagent_containers/food/snacks/rogue/meat = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	crafting_flags = CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/roguetown/structure/lamplighter_brazier
	// Azure Peak
	name = "brazier (Lamplighter)"
	result = /obj/machinery/light/rogue/firebowl/stump
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/stone = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "assembles"
	rogue_verb_simple = "assembles"
	crafting_flags = CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/roguetown/structure/matthios_cross_meat
	// Azure Peak
	name = "ornate grinning cross"
	result = /obj/structure/fluff/psycross/matthios/decorated
	reqs = list(/obj/item/natural/stone = 3, /obj/item/roguecoin/gold = 4)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	crafting_flags = CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/roguetown/structure/portholedoor
	// Azure Peak
	name = "porthole door"
	result = /obj/structure/mineral_door/rockhill/wood/donjon
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/ingot/iron = 1, /obj/item/roguegear = 1)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 3
	rogue_verb = "builds"
	rogue_verb_simple = "build"

/datum/crafting_recipe/roguetown/structure/shelf_big
	// Azure Peak
	name = "wooden shelf (big)"
	result = /obj/structure/rack/rockhill/rogue/shelf/biggest
	reqs = list(/obj/item/grown/log/tree/stick = 4)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0
	rogue_ignore_density = TRUE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"

/datum/crafting_recipe/roguetown/structure/shelf_medium
	// Azure Peak
	name = "wooden shelf (medium)"
	result = /obj/structure/rack/rockhill/rogue/shelf/big
	reqs = list(/obj/item/grown/log/tree/stick = 3)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0
	rogue_ignore_density = TRUE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"

/datum/crafting_recipe/roguetown/structure/statue/noc
	// Azure Peak
	name = "statue of Noc"
	result = /obj/structure/fluff/statue/noc
	reqs = list(/obj/item/ingot/silver = 1, /obj/item/natural/stone = 2)
	tool_paths = list(/obj/item/rogueweapon/hammer)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"

/datum/crafting_recipe/roguetown/structure/stone_stool
	// Azure Peak
	name = "stone stool"
	result = /obj/item/chair/stool/bar/rogue/stone
	reqs = list(/obj/item/natural/stone = 2)
	tool_paths = list(/obj/item/rogueweapon/chisel)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_verb = "chisels"
	rogue_verb_simple = "chisel"

/datum/crafting_recipe/roguetown/structure/zizo_cross_gold
	// Azure Peak
	name = "gilded profane cross"
	result = /obj/structure/fluff/psycross/zizocross/golden
	reqs = list(/obj/item/natural/stone = 3, /obj/item/rogueore/gold = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"

/datum/crafting_recipe/roguetown/survival/autumnwoadarmor
	// Azure Peak
	name = "autumnwoad elven plate, imbuement"
	result = /obj/item/clothing/suit/roguetown/armor/plate/elven_plate/autumn
	reqs = list(/obj/item/natural/fibers = 3, /obj/item/grown/log/tree/stick = 3, /obj/item/clothing/suit/roguetown/armor/plate/elven_plate/autumn/light = 1, /obj/item/grown/log/tree/small = 1, /obj/item/natural/cured/essence = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry

/datum/crafting_recipe/roguetown/survival/autumnwoadhelmet
	// Azure Peak
	name = "autumnwoad elven helm, imbuement"
	result = /obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/autumn
	reqs = list(/obj/item/natural/fibers = 3, /obj/item/grown/log/tree/stick = 3, /obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/autumn/light = 1, /obj/item/grown/log/tree/small = 1, /obj/item/natural/cured/essence = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry

/datum/crafting_recipe/roguetown/survival/bakers_peel
	// Azure Peak
	name = "baker's peel"
	result = /obj/item/storage/bag/tray/peel
	reqs = list(/obj/item/grown/log/tree = 1, /obj/item/grown/log/tree/small = 1)
	blacklist = list(/obj/item/grown/log/tree/bowpartial, /obj/item/grown/log/tree/bowpartial/longbow, /obj/item/grown/log/tree/bowpartial/recurve, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small/essence, /obj/item/grown/log/tree/stake, /obj/item/grown/log/tree/stick)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry

/datum/crafting_recipe/roguetown/survival/bell_collar
	// Azure Peak
	name = "bell collar"
	result = /obj/item/clothing/neck/roguetown/collar/bell_collar
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/jingle_bells = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0

/datum/crafting_recipe/roguetown/survival/blcktankard
	// Azure Peak
	name = "tankards, blacksteel (x1)"
	result = /obj/item/reagent_containers/glass/bucket/pot/kettle/tankard/blacksteel
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/ingot/blacksteel = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 6

/datum/crafting_recipe/roguetown/survival/bog_cream
	// Azure Peak
	name = "Bog Cream (Artemisia)"
	result = /obj/item/bog_cream
	reqs = list(/obj/item/natural/worms/leech = 1, /obj/item/alch/artemisia = 1, /obj/item/reagent_containers/food/snacks/tallow = 1)
	blacklist = list(/obj/item/natural/worms/leech/abyssoid, /obj/item/natural/worms/leech/cheele, /obj/item/reagent_containers/food/snacks/tallow/black, /obj/item/reagent_containers/food/snacks/tallow/red, /obj/item/reagent_containers/food/snacks/tallow/soft)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/datum/crafting_recipe/roguetown/survival/bog_cream/pipeweed
	// Azure Peak
	name = "Bog Cream (Pipeweed)"
	result = /obj/item/bog_cream
	reqs = list(/obj/item/natural/worms/leech = 1, /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed = 1, /obj/item/reagent_containers/food/snacks/tallow = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = list(/obj/item/natural/worms/leech/abyssoid, /obj/item/natural/worms/leech/cheele, /obj/item/reagent_containers/food/snacks/tallow/black, /obj/item/reagent_containers/food/snacks/tallow/red, /obj/item/reagent_containers/food/snacks/tallow/soft)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = null
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/survival/bouquet_fyritius
	// Azure Peak
	name = "fyritius bouquet"
	result = /obj/item/bouquet/fyritius
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 4, /obj/item/natural/fibers = 2, /obj/item/paper/scroll = 1)
	blacklist = list(/obj/item/paper/scroll/bounty, /obj/item/paper/scroll/cargo, /obj/item/paper/scroll/custom, /obj/item/paper/scroll/fake_evidence, /obj/item/paper/scroll/grudge, /obj/item/paper/scroll/ministry_writ, /obj/item/paper/scroll/sell_price_changes, /obj/item/paper/scroll/trade_requests, /obj/item/paper/scroll/writ_of_esteem, /obj/item/paper/scroll/writ_of_esteem/grenzel, /obj/item/paper/scroll/writ_of_esteem/otavan, /obj/item/paper/scroll/writ_of_esteem/zybantine, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "arranges"
	rogue_verb_simple = "arranged"

/datum/crafting_recipe/roguetown/survival/briarthorns
	// Azure Peak
	name = "briar thorns"
	result = /obj/item/clothing/head/roguetown/briarthorns
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/natural/thorn = 4)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "ties"
	rogue_verb_simple = "tied"

/datum/crafting_recipe/roguetown/survival/charcoal
	// Azure Peak
	name = "wood into charcoal"
	result = /obj/item/rogueore/coal/charcoal
	reqs = list(/obj/item/grown/log/tree/small = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_structure = /obj/machinery/light/rogue/oven
	rogue_verb = "chars"
	rogue_verb_simple = "char"

/datum/crafting_recipe/roguetown/survival/clothbelt/upgraded
	// Azure Peak
	name = "pouch-fitted cloth belt"
	result = /obj/item/storage/belt/rogue/leather/cloth/upgraded
	reqs = list(/obj/item/storage/belt/rogue/leather/cloth = 1, /obj/item/storage/belt/rogue/pouch = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "tie"
	rogue_verb_simple = "tie"
	rogue_sound = null
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/survival/collar
	// Azure Peak
	name = "collar"
	result = /obj/item/clothing/neck/roguetown/collar
	reqs = list(/obj/item/natural/hide/cured = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0

/datum/crafting_recipe/roguetown/survival/decant_heartblood
	// Azure Peak
	name = "decant heartblood (canister)"
	result = /obj/item/heart_blood_vial
	reqs = list(/obj/item/heart_blood_canister = 1, /obj/item/heart_blood_vial/filled = 3)
	rogue_results = list(/obj/item/heart_blood_vial, /obj/item/heart_blood_vial, /obj/item/heart_blood_canister/filled)
	blacklist = list(/obj/item/heart_blood_canister/filled)
	category = "Medicine"
	rogue_skill = /datum/attribute/skill/misc/medicine

/datum/crafting_recipe/roguetown/survival/decant_heartblood_vials
	// Azure Peak
	name = "decant heartblood (vials)"
	result = /obj/item/heart_blood_vial/filled
	reqs = list(/obj/item/heart_blood_canister/filled = 1, /obj/item/heart_blood_vial = 3)
	rogue_results = list(/obj/item/heart_blood_vial/filled, /obj/item/heart_blood_vial/filled, /obj/item/heart_blood_canister)
	blacklist = list(/obj/item/heart_blood_vial/filled)
	category = "Medicine"
	rogue_skill = /datum/attribute/skill/misc/medicine

/datum/crafting_recipe/roguetown/survival/feldcollar
	// Azure Peak
	name = "feldcollar"
	result = /obj/item/clothing/neck/roguetown/collar/feldcollar
	reqs = list(/obj/item/natural/cloth = 2)
	blacklist = list(/obj/item/natural/cloth/bandage)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0

/datum/crafting_recipe/roguetown/survival/fire_pot
	// Azure Peak
	name = "fire pot (x4)"
	result = /obj/item/ammo_casing/caseless/rogue/sling_bullet/fire_pot
	reqs = list(/obj/item/alch/firedust = 1, /obj/item/natural/clay = 1)
	rogue_results = list(/obj/item/ammo_casing/caseless/rogue/sling_bullet/fire_pot, /obj/item/ammo_casing/caseless/rogue/sling_bullet/fire_pot, /obj/item/ammo_casing/caseless/rogue/sling_bullet/fire_pot)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 3
	rogue_on_table = TRUE
	rogue_verb = "prepares"
	rogue_verb_simple = "prepare"

/datum/crafting_recipe/roguetown/survival/fishing/bait_dough
	// Azure Peak
	name = "doughy bait (x6)"
	result = /obj/item/fishing/bait/dough
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/dough = 1)
	rogue_results = list(/obj/item/fishing/bait/dough, /obj/item/fishing/bait/dough, /obj/item/fishing/bait/dough, /obj/item/fishing/bait/dough, /obj/item/fishing/bait/dough)
	category = "Fishing"
	rogue_skill = /datum/attribute/skill/labor/fishing

/datum/crafting_recipe/roguetown/survival/fishing/bait_gray
	// Azure Peak
	name = "gray bait (x6)"
	result = /obj/item/fishing/bait/gray
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish = 1, /obj/item/reagent_containers/food/snacks/rogue/doughslice = 1)
	rogue_results = list(/obj/item/fishing/bait/gray, /obj/item/fishing/bait/gray, /obj/item/fishing/bait/gray, /obj/item/fishing/bait/gray, /obj/item/fishing/bait/gray)
	category = "Fishing"
	rogue_skill = /datum/attribute/skill/labor/fishing

/datum/crafting_recipe/roguetown/survival/fishing/bait_red
	// Azure Peak
	name = "red bait (x6)"
	result = /obj/item/fishing/bait/meat
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish = 2)
	rogue_results = list(/obj/item/fishing/bait/meat, /obj/item/fishing/bait/meat, /obj/item/fishing/bait/meat, /obj/item/fishing/bait/meat, /obj/item/fishing/bait/meat)
	category = "Fishing"
	rogue_skill = /datum/attribute/skill/labor/fishing

/datum/crafting_recipe/roguetown/survival/fishing/bait_shell
	// Azure Peak
	name = "shell bait (x6)"
	result = /obj/item/fishing/bait/shell
	reqs = list(/obj/item/oystershell = 1, /obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish = 1)
	rogue_results = list(/obj/item/fishing/bait/shell, /obj/item/fishing/bait/shell, /obj/item/fishing/bait/shell, /obj/item/fishing/bait/shell, /obj/item/fishing/bait/shell)
	category = "Fishing"
	rogue_skill = /datum/attribute/skill/labor/fishing

/datum/crafting_recipe/roguetown/survival/fishing/bait_speckled
	// Azure Peak
	name = "speckled bait (x6)"
	result = /obj/item/fishing/bait/speckled
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish = 1, /obj/item/reagent_containers/food/snacks/rogue/doughslice = 1, /obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1)
	rogue_results = list(/obj/item/fishing/bait/speckled, /obj/item/fishing/bait/speckled, /obj/item/fishing/bait/speckled, /obj/item/fishing/bait/speckled, /obj/item/fishing/bait/speckled)
	blacklist = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison)
	category = "Fishing"
	rogue_skill = /datum/attribute/skill/labor/fishing
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/survival/fishing/bobber
	// Azure Peak
	name = "wooden bobber"
	result = /obj/item/fishing/line/bobber
	reqs = list(/obj/item/grown/log/tree/stick = 1, /obj/item/natural/fibers = 2)
	category = "Fishing"
	rogue_skill = /datum/attribute/skill/labor/fishing

/datum/crafting_recipe/roguetown/survival/fishing/creel
	// Azure Peak
	name = "fisherman's creel"
	result = /obj/item/storage/meatbag/creel
	reqs = list(/obj/item/grown/log/tree/stick = 3, /obj/item/natural/fibers = 2)
	category = "Fishing"
	rogue_skill = /datum/attribute/skill/labor/fishing
	rogue_verb = "weaves"
	rogue_verb_simple = "weave"

/datum/crafting_recipe/roguetown/survival/fishing/hook_thorn
	// Azure Peak
	name = "thorn fishing hook"
	result = /obj/item/fishing/hook/thorn
	reqs = list(/obj/item/natural/thorn = 2)
	category = "Fishing"
	rogue_skill = /datum/attribute/skill/labor/fishing

/datum/crafting_recipe/roguetown/survival/fishing/hook_wooden
	// Azure Peak
	name = "wooden gorge fishing hook"
	result = /obj/item/fishing/hook/wooden
	reqs = list(/obj/item/grown/log/tree/stick = 2)
	category = "Fishing"
	rogue_skill = /datum/attribute/skill/labor/fishing

/datum/crafting_recipe/roguetown/survival/fishing/reel_leather
	// Azure Peak
	name = "leather fishing line"
	result = /obj/item/fishing/reel/leather
	reqs = list(/obj/item/natural/hide = 1, /obj/item/natural/fibers = 1)
	blacklist = list(/obj/item/natural/hide/cured)
	category = "Fishing"
	rogue_skill = /datum/attribute/skill/labor/fishing

/datum/crafting_recipe/roguetown/survival/fishing/reel_silk
	// Azure Peak
	name = "silk fishing line"
	result = /obj/item/fishing/reel/silk
	reqs = list(/obj/item/natural/silk = 2)
	category = "Fishing"
	rogue_skill = /datum/attribute/skill/labor/fishing
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/survival/fishing/reel_twine
	// Azure Peak
	name = "twine fishing line"
	result = /obj/item/fishing/reel/twine
	reqs = list(/obj/item/natural/fibers = 2)
	category = "Fishing"
	rogue_skill = /datum/attribute/skill/labor/fishing

/datum/crafting_recipe/roguetown/survival/fishing/sinker
	// Azure Peak
	name = "stone sinker"
	result = /obj/item/fishing/line/sinker
	reqs = list(/obj/item/natural/stone = 1, /obj/item/natural/fibers = 2)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Fishing"
	rogue_skill = /datum/attribute/skill/labor/fishing

/datum/crafting_recipe/roguetown/survival/flint
	// Azure Peak
	name = "flint"
	result = /obj/item/flint
	reqs = list(/obj/item/scrap = 2, /obj/item/natural/whetstone = 2, /obj/item/natural/fibers = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/survival/flowercrown_azurosa
	// Azure Peak
	name = "azurosa crown"
	result = /obj/item/flowercrown/rosa/azure
	reqs = list(/obj/item/alch/rosa/azure = 4, /obj/item/natural/fibers = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "ties"
	rogue_verb_simple = "tied"

/datum/crafting_recipe/roguetown/survival/flowercrown_briar
	// Azure Peak
	name = "briar thorn crown"
	result = /obj/item/flowercrown/briar
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/natural/thorn = 4)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "ties"
	rogue_verb_simple = "tied"

/datum/crafting_recipe/roguetown/survival/flowercrown_fyritius
	// Azure Peak
	name = "fyritius crown"
	result = /obj/item/flowercrown/fyritius
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 4, /obj/item/natural/fibers = 2)
	blacklist = list(/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_verb = "ties"
	rogue_verb_simple = "tied"

/datum/crafting_recipe/roguetown/survival/gothicironmailledhauberk
	// Azure Peak
	name = "layer a gothic iron cuirass atop hauberk"
	result = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/donator_gothic
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/donator_gothic = 1, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron = 1)
	blacklist = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/donator, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/donator_gothic, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/rockhill, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/zycuirass, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/taur)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/survival/gothicmailledhauberk
	// Azure Peak
	name = "layer a gothic cuirass atop hauberk"
	result = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/donator_gothic
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/donator_gothic = 1, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1)
	blacklist = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient/decrepit, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/atgervi, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/bronze, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/bronze/donator, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/dasfox_ranger, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/donator, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/fluted, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/fluted/robed, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/fluted/robed/grandmaster, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/gold, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/graggar, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/grenzelhoft, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/ancient, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/ancient/decrepit, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/decorated, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/donator_gothic, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/rockhill, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/donator, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/donator_gothic, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/rockhill, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/zycuirass, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/taur, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/janissary, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/matthios, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate/robed, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/taur, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/timesoldier/temperance/eb_armor, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/woodland, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/woodland/plackart, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zizo)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/survival/heattreat_otavanstake
	// Azure Peak
	name = "heat-treat otavan stake into silver shotstakes (x3)"
	result = /obj/item/ammo_casing/caseless/rogue/stake/silver
	reqs = list(/obj/item/rogueweapon/huntingknife/idagger/steel/silver/stake/psy = 1)
	rogue_results = list(/obj/item/ammo_casing/caseless/rogue/stake/silver, /obj/item/ammo_casing/caseless/rogue/stake/silver)
	blacklist = list(/obj/item/rogueweapon/huntingknife/idagger/steel/silver/stake/psy/preblessed)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_structure = /obj/machinery/light/rogue
	rogue_verb = "heat-treats"
	rogue_verb_simple = "heat-treat"

/datum/crafting_recipe/roguetown/survival/heattreat_sharpstake
	// Azure Peak
	name = "heat-treat sharpened stake into shotstakes (x3)"
	result = /obj/item/ammo_casing/caseless/rogue/stake
	reqs = list(/obj/item/rogueweapon/huntingknife/idagger/stake = 1)
	rogue_results = list(/obj/item/ammo_casing/caseless/rogue/stake, /obj/item/ammo_casing/caseless/rogue/stake)
	blacklist = list(/obj/item/rogueweapon/huntingknife/idagger/stake/inq)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_structure = /obj/machinery/light/rogue
	rogue_verb = "heat-treats"
	rogue_verb_simple = "heat-treat"

/datum/crafting_recipe/roguetown/survival/heattreat_silverstake
	// Azure Peak
	name = "heat-treat silver stake into silver shotstakes (x3)"
	result = /obj/item/ammo_casing/caseless/rogue/stake/silver
	reqs = list(/obj/item/rogueweapon/huntingknife/idagger/steel/silver/stake = 1)
	rogue_results = list(/obj/item/ammo_casing/caseless/rogue/stake/silver, /obj/item/ammo_casing/caseless/rogue/stake/silver)
	blacklist = list(/obj/item/rogueweapon/huntingknife/idagger/steel/silver/stake/preblessed, /obj/item/rogueweapon/huntingknife/idagger/steel/silver/stake/psy, /obj/item/rogueweapon/huntingknife/idagger/steel/silver/stake/psy/preblessed)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_structure = /obj/machinery/light/rogue
	rogue_verb = "heat-treats"
	rogue_verb_simple = "heat-treat"

/datum/crafting_recipe/roguetown/survival/heattreat_stake
	// Azure Peak
	name = "heat-treat stake into shotstake"
	result = /obj/item/ammo_casing/caseless/rogue/stake
	reqs = list(/obj/item/grown/log/tree/stake = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_structure = /obj/machinery/light/rogue
	rogue_verb = "heat-treats"
	rogue_verb_simple = "heat-treat"

/datum/crafting_recipe/roguetown/survival/heavy_sling_bullet
	// Azure Peak
	name = "heavy sling bullet (x2)"
	result = /obj/item/ammo_casing/caseless/rogue/sling_bullet/heavy_sling_bullet
	reqs = list(/obj/item/natural/stone = 3)
	rogue_results = list(/obj/item/ammo_casing/caseless/rogue/sling_bullet/heavy_sling_bullet)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_on_table = TRUE
	rogue_verb = "shapes"
	rogue_verb_simple = "shape"

/datum/crafting_recipe/roguetown/survival/hornbow
	// Azure Peak
	name = "horn bow"
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/goat
	reqs = list(/obj/item/natural/bowstring = 1, /obj/item/natural/goathorn = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2
	rogue_verb = "strings together"
	rogue_verb_simple = "string together"

/datum/crafting_recipe/roguetown/survival/hotrock
	// Azure Peak
	name = "assemble stones into hotrock"
	result = /obj/item/cooking/pan/stone
	reqs = list(/obj/item/natural/stone = 4)
	blacklist = list(/obj/item/natural/stone/sending)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/survival/hotrock_boulder
	// Azure Peak
	name = "chisel boulder into hotrock"
	result = /obj/item/cooking/pan/stone
	reqs = list(/obj/item/natural/rock = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	blacklist = list(/obj/item/natural/rock/cinnabar, /obj/item/natural/rock/coal, /obj/item/natural/rock/copper, /obj/item/natural/rock/desert, /obj/item/natural/rock/dungeon, /obj/item/natural/rock/elementalmote, /obj/item/natural/rock/gem, /obj/item/natural/rock/gold, /obj/item/natural/rock/iron, /obj/item/natural/rock/random, /obj/item/natural/rock/random_ore, /obj/item/natural/rock/salt, /obj/item/natural/rock/silver, /obj/item/natural/rock/tin)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/survival/hotrock_whetstone
	// Azure Peak
	name = "combine whetstones into hotrock"
	result = /obj/item/cooking/pan/stone
	reqs = list(/obj/item/natural/whetstone = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/survival/huntinglongbow
	// Azure Peak
	name = "hunting longbow"
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/towner
	reqs = list(/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow = 1, /obj/item/gun/ballistic/revolver/grenadelauncher/bow/towner = 1, /obj/item/natural/silk = 1)
	blacklist = list(/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/eora, /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/towner, /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/warden)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2
	rogue_verb = "re-strings"
	rogue_verb_simple = "re-string"

/datum/crafting_recipe/roguetown/survival/iron_slingbullets
	// Azure Peak
	name = "hammered iron sling bullets (x10)"
	result = /obj/item/ammo_casing/caseless/rogue/sling_bullet/iron
	reqs = list(/obj/item/ingot/iron = 1)
	rogue_results = list(/obj/item/ammo_casing/caseless/rogue/sling_bullet/iron, /obj/item/ammo_casing/caseless/rogue/sling_bullet/iron, /obj/item/ammo_casing/caseless/rogue/sling_bullet/iron, /obj/item/ammo_casing/caseless/rogue/sling_bullet/iron, /obj/item/ammo_casing/caseless/rogue/sling_bullet/iron, /obj/item/ammo_casing/caseless/rogue/sling_bullet/iron, /obj/item/ammo_casing/caseless/rogue/sling_bullet/iron, /obj/item/ammo_casing/caseless/rogue/sling_bullet/iron, /obj/item/ammo_casing/caseless/rogue/sling_bullet/iron)
	tool_paths = list(/obj/item/rogueweapon/hammer)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 2
	rogue_on_table = TRUE
	rogue_verb = "hammers out"
	rogue_verb_simple = "hammer out"

/datum/crafting_recipe/roguetown/survival/ironandclothhose
	// Azure Peak
	name = "layer a cloth hose atop iron chain hosen"
	result = /obj/item/clothing/under/roguetown/chainlegs/iron/hose/dyeable
	reqs = list(/obj/item/clothing/under/roguetown/tights/hose = 1, /obj/item/clothing/under/roguetown/chainlegs/iron = 1)
	blacklist = list(/obj/item/clothing/under/roguetown/chainlegs/iron/hose, /obj/item/clothing/under/roguetown/chainlegs/iron/hose/dyeable, /obj/item/clothing/under/roguetown/chainlegs/iron/hose/dyeable/necro, /obj/item/clothing/under/roguetown/chainlegs/iron/kilt)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/survival/ironmailledhauberk
	// Azure Peak
	name = "layer a iron cuirass atop hauberk"
	result = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron = 1, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron = 1)
	blacklist = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/donator, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/donator_gothic, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/rockhill, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/zycuirass, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/taur, /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/donator_girdle, /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/donator_gothic, /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/goblin, /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/heartplate, /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/hobgoblin)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/survival/lampstaff
	// Azure Peak
	name = "lamplighter's staff"
	result = /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter
	reqs = list(/obj/item/rogueweapon/woodstaff/quarterstaff = 1, /obj/item/flashlight/flare/torch/lantern = 1, /obj/item/reagent_containers/food/snacks/tallow = 2)
	blacklist = list(/obj/item/flashlight/flare/torch/lantern/bronze, /obj/item/flashlight/flare/torch/lantern/bronzelamptern, /obj/item/flashlight/flare/torch/lantern/copper, /obj/item/flashlight/flare/torch/lantern/prelit, /obj/item/flashlight/flare/torch/lantern/psycenser, /obj/item/flashlight/flare/torch/lantern/pumpkin, /obj/item/flashlight/flare/torch/lantern/pumpkin/frown, /obj/item/flashlight/flare/torch/lantern/pumpkin/grin, /obj/item/flashlight/flare/torch/lantern/pumpkin/psy, /obj/item/flashlight/flare/torch/lantern/pumpkin/surprise, /obj/item/flashlight/flare/torch/lantern/pumpkin/ten, /obj/item/flashlight/flare/torch/lantern/pumpkin/woozy, /obj/item/flashlight/flare/torch/lantern/pumpkin/zizo, /obj/item/flashlight/flare/torch/lantern/scrap, /obj/item/flashlight/flare/torch/lantern/voidlamptern, /obj/item/reagent_containers/food/snacks/tallow/black, /obj/item/reagent_containers/food/snacks/tallow/red, /obj/item/reagent_containers/food/snacks/tallow/soft, /obj/item/rogueweapon/woodstaff/quarterstaff/blacksteel, /obj/item/rogueweapon/woodstaff/quarterstaff/bombard_sponge, /obj/item/rogueweapon/woodstaff/quarterstaff/bostaff, /obj/item/rogueweapon/woodstaff/quarterstaff/gold, /obj/item/rogueweapon/woodstaff/quarterstaff/iron, /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter, /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter/warden, /obj/item/rogueweapon/woodstaff/quarterstaff/psy, /obj/item/rogueweapon/woodstaff/quarterstaff/silver, /obj/item/rogueweapon/woodstaff/quarterstaff/steel, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/astrata, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/donator_elegant, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/holysee, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/noc, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/silver, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/silver/psy, /obj/item/rogueweapon/woodstaff/quarterstaff/virtue)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	crafting_flags = CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/roguetown/survival/lampwarden
	// Azure Peak
	name = "lampwarden's staff"
	result = /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter/warden
	reqs = list(/obj/item/rogueweapon/woodstaff/quarterstaff = 1, /obj/item/flashlight/flare/torch/lantern = 1, /obj/item/reagent_containers/food/snacks/tallow = 2, /obj/item/ingot/iron = 1)
	blacklist = list(/obj/item/flashlight/flare/torch/lantern/bronze, /obj/item/flashlight/flare/torch/lantern/bronzelamptern, /obj/item/flashlight/flare/torch/lantern/copper, /obj/item/flashlight/flare/torch/lantern/prelit, /obj/item/flashlight/flare/torch/lantern/psycenser, /obj/item/flashlight/flare/torch/lantern/pumpkin, /obj/item/flashlight/flare/torch/lantern/pumpkin/frown, /obj/item/flashlight/flare/torch/lantern/pumpkin/grin, /obj/item/flashlight/flare/torch/lantern/pumpkin/psy, /obj/item/flashlight/flare/torch/lantern/pumpkin/surprise, /obj/item/flashlight/flare/torch/lantern/pumpkin/ten, /obj/item/flashlight/flare/torch/lantern/pumpkin/woozy, /obj/item/flashlight/flare/torch/lantern/pumpkin/zizo, /obj/item/flashlight/flare/torch/lantern/scrap, /obj/item/flashlight/flare/torch/lantern/voidlamptern, /obj/item/reagent_containers/food/snacks/tallow/black, /obj/item/reagent_containers/food/snacks/tallow/red, /obj/item/reagent_containers/food/snacks/tallow/soft, /obj/item/rogueweapon/woodstaff/quarterstaff/blacksteel, /obj/item/rogueweapon/woodstaff/quarterstaff/bombard_sponge, /obj/item/rogueweapon/woodstaff/quarterstaff/bostaff, /obj/item/rogueweapon/woodstaff/quarterstaff/gold, /obj/item/rogueweapon/woodstaff/quarterstaff/iron, /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter, /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter/warden, /obj/item/rogueweapon/woodstaff/quarterstaff/psy, /obj/item/rogueweapon/woodstaff/quarterstaff/silver, /obj/item/rogueweapon/woodstaff/quarterstaff/steel, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/astrata, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/donator_elegant, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/holysee, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/noc, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/silver, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/silver/psy, /obj/item/rogueweapon/woodstaff/quarterstaff/virtue)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
	crafting_flags = CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/roguetown/survival/lumberjacking/cart_upgrade
	// Azure Peak
	name = "woodcutters wheelbrace"
	result = /obj/item/cart_upgrade/level_1
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/natural/stone = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/natural/stone/sending)
	category = "Lumberjacking"
	rogue_skill = /datum/attribute/skill/labor/lumberjacking
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/survival/lumberjacking/cart_upgrade2
	// Azure Peak
	name = "reinforced woodcutters wheelbrace"
	result = /obj/item/cart_upgrade/level_2
	reqs = list(/obj/item/grown/log/tree/small = 4, /obj/item/cart_upgrade/level_1 = 1, /obj/item/ingot/iron = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Lumberjacking"
	rogue_skill = /datum/attribute/skill/labor/lumberjacking
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/survival/mailledhauberk
	// Azure Peak
	name = "layer a steel cuirass atop hauberk"
	result = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass = 1, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1)
	blacklist = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient/decrepit, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/atgervi, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/bronze, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/bronze/donator, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/dasfox_ranger, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/donator, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/fluted, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/fluted/robed, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/fluted/robed/grandmaster, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/gold, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/graggar, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/grenzelhoft, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/ancient, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/ancient/decrepit, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/decorated, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/donator_gothic, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/rockhill, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/donator, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/donator_gothic, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/rockhill, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/zycuirass, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/taur, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/janissary, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/matthios, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate/robed, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy/heavy, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/taur, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/timesoldier/temperance/eb_armor, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/woodland, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/woodland/plackart, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zizo)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/survival/peasantry/hoe
	// Azure Peak
	name = "hoe - iron ingot"
	result = /obj/item/rogueweapon/hoe
	reqs = list(/obj/item/grown/log/tree/stick = 2, /obj/item/ingot/iron = 1)
	tool_paths = list(/obj/item/rogueweapon/hammer)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/survival/peasantry/hoe/whetstone
	// Azure Peak
	name = "hoe - whetstone"
	result = /obj/item/rogueweapon/hoe
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/natural/whetstone = 3, /obj/item/rope = 1)
	rogue_results = null
	tool_paths = list(/obj/item/rogueweapon/hammer)
	parts = null
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/rope/chain, /obj/item/rope/chain/bindingshackles, /obj/item/rope/chain/bindingshackles/t2, /obj/item/rope/chain/bindingshackles/t3, /obj/item/rope/chain/bindingshackles/t4, /obj/item/rope/chain/bindingshackles/t5, /obj/item/rope/chain/fake, /obj/item/rope/chain/fake/ice, /obj/item/rope/inqarticles/inquirycord)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0
	rogue_structure = null
	rogue_on_table = TRUE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = null
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/survival/peasantry/maciejowski_knife
	// Azure Peak
	name = "maciejowski (hunting knife)"
	result = /obj/item/rogueweapon/sword/falchion/militia
	reqs = list(/obj/item/rogueweapon/huntingknife = 1, /obj/item/natural/whetstone = 2)
	tool_paths = list(/obj/item/rogueweapon/hammer)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/survival/peasantry/maciejowski_messer
	// Azure Peak
	name = "maciejowski (iron messer)"
	result = /obj/item/rogueweapon/sword/falchion/militia
	reqs = list(/obj/item/rogueweapon/sword/short/messer/iron = 1, /obj/item/natural/whetstone = 1)
	tool_paths = list(/obj/item/rogueweapon/hammer)
	blacklist = list(/obj/item/rogueweapon/sword/short/messer/iron/virtue)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/survival/peasantry/peasantwarflail
	// Azure Peak
	name = "peasant war flail (thresher)"
	result = /obj/item/rogueweapon/flail/peasantwarflail
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/rope = 1, /obj/item/rogueweapon/thresher = 1)
	tool_paths = list(/obj/item/rogueweapon/hammer)
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/rogueweapon/thresher/aalloy, /obj/item/rogueweapon/thresher/blacksteel, /obj/item/rogueweapon/thresher/bronze, /obj/item/rogueweapon/thresher/decrepit, /obj/item/rope/chain, /obj/item/rope/chain/bindingshackles, /obj/item/rope/chain/bindingshackles/t2, /obj/item/rope/chain/bindingshackles/t3, /obj/item/rope/chain/bindingshackles/t4, /obj/item/rope/chain/bindingshackles/t5, /obj/item/rope/chain/fake, /obj/item/rope/chain/fake/ice, /obj/item/rope/inqarticles/inquirycord)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/survival/peasantry/pitchfork
	// Azure Peak
	name = "pitchfork - iron ingot"
	result = /obj/item/rogueweapon/pitchfork
	reqs = list(/obj/item/grown/log/tree/stick = 2, /obj/item/ingot/iron = 1)
	tool_paths = list(/obj/item/rogueweapon/hammer)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/survival/peasantry/pitchfork/whetstone
	// Azure Peak
	name = "pitchfork - whetstone"
	result = /obj/item/rogueweapon/pitchfork
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/natural/whetstone = 3, /obj/item/rope = 1)
	rogue_results = null
	tool_paths = list(/obj/item/rogueweapon/hammer)
	parts = null
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/rope/chain, /obj/item/rope/chain/bindingshackles, /obj/item/rope/chain/bindingshackles/t2, /obj/item/rope/chain/bindingshackles/t3, /obj/item/rope/chain/bindingshackles/t4, /obj/item/rope/chain/bindingshackles/t5, /obj/item/rope/chain/fake, /obj/item/rope/chain/fake/ice, /obj/item/rope/inqarticles/inquirycord)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0
	rogue_structure = null
	rogue_on_table = TRUE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = null
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/survival/peasantry/scythe
	// Azure Peak
	name = "scythe"
	result = /obj/item/rogueweapon/scythe
	reqs = list(/obj/item/natural/whetstone = 1, /obj/item/grown/log/tree/small = 2, /obj/item/rope = 1)
	tool_paths = list(/obj/item/rogueweapon/hammer)
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/rope/chain, /obj/item/rope/chain/bindingshackles, /obj/item/rope/chain/bindingshackles/t2, /obj/item/rope/chain/bindingshackles/t3, /obj/item/rope/chain/bindingshackles/t4, /obj/item/rope/chain/bindingshackles/t5, /obj/item/rope/chain/fake, /obj/item/rope/chain/fake/ice, /obj/item/rope/inqarticles/inquirycord)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/survival/peasantry/shovel
	// Azure Peak
	name = "shovel - iron ingot"
	result = /obj/item/rogueweapon/shovel
	reqs = list(/obj/item/grown/log/tree/stick = 2, /obj/item/ingot/iron = 1)
	tool_paths = list(/obj/item/rogueweapon/hammer)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/survival/peasantry/shovel/whetstone
	// Azure Peak
	name = "shovel - whetstone"
	result = /obj/item/rogueweapon/shovel
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/natural/whetstone = 3, /obj/item/rope = 1)
	rogue_results = null
	tool_paths = list(/obj/item/rogueweapon/hammer)
	parts = null
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/rope/chain, /obj/item/rope/chain/bindingshackles, /obj/item/rope/chain/bindingshackles/t2, /obj/item/rope/chain/bindingshackles/t3, /obj/item/rope/chain/bindingshackles/t4, /obj/item/rope/chain/bindingshackles/t5, /obj/item/rope/chain/fake, /obj/item/rope/chain/fake/ice, /obj/item/rope/inqarticles/inquirycord)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0
	rogue_structure = null
	rogue_on_table = TRUE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = null
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/survival/peasantry/silverscythe
	// Azure Peak
	name = "silver scythe"
	result = /obj/item/rogueweapon/scythe/silver
	reqs = list(/obj/item/ingot/silver = 1, /obj/item/grown/log/tree/small = 2, /obj/item/rope = 1)
	tool_paths = list(/obj/item/rogueweapon/hammer)
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/rope/chain, /obj/item/rope/chain/bindingshackles, /obj/item/rope/chain/bindingshackles/t2, /obj/item/rope/chain/bindingshackles/t3, /obj/item/rope/chain/bindingshackles/t4, /obj/item/rope/chain/bindingshackles/t5, /obj/item/rope/chain/fake, /obj/item/rope/chain/fake/ice, /obj/item/rope/inqarticles/inquirycord)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/survival/peasantry/thresher
	// Azure Peak
	name = "thresher"
	result = /obj/item/rogueweapon/thresher
	reqs = list(/obj/item/grown/log/tree/stick = 1, /obj/item/ingot/iron = 1)
	tool_paths = list(/obj/item/rogueweapon/hammer)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/survival/peasantry/thresher/whetstone
	// Azure Peak
	name = "thresher"
	result = /obj/item/rogueweapon/thresher
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/whetstone = 4, /obj/item/rope = 1)
	rogue_results = null
	tool_paths = list(/obj/item/rogueweapon/hammer)
	parts = null
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/rope/chain, /obj/item/rope/chain/bindingshackles, /obj/item/rope/chain/bindingshackles/t2, /obj/item/rope/chain/bindingshackles/t3, /obj/item/rope/chain/bindingshackles/t4, /obj/item/rope/chain/bindingshackles/t5, /obj/item/rope/chain/fake, /obj/item/rope/chain/fake/ice, /obj/item/rope/inqarticles/inquirycord)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0
	rogue_structure = null
	rogue_on_table = TRUE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = null
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/survival/peasantry/warspear_hoe
	// Azure Peak
	name = "militia warspear (hoe)"
	result = /obj/item/rogueweapon/spear/militia
	reqs = list(/obj/item/rogueweapon/hoe = 1, /obj/item/grown/log/tree/small = 2, /obj/item/rope = 1)
	tool_paths = list(/obj/item/rogueweapon/hammer)
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/rogueweapon/hoe/aalloy, /obj/item/rogueweapon/hoe/blacksteel, /obj/item/rogueweapon/hoe/bronze, /obj/item/rogueweapon/hoe/copper, /obj/item/rogueweapon/hoe/decrepit, /obj/item/rogueweapon/hoe/stone, /obj/item/rope/chain, /obj/item/rope/chain/bindingshackles, /obj/item/rope/chain/bindingshackles/t2, /obj/item/rope/chain/bindingshackles/t3, /obj/item/rope/chain/bindingshackles/t4, /obj/item/rope/chain/bindingshackles/t5, /obj/item/rope/chain/fake, /obj/item/rope/chain/fake/ice, /obj/item/rope/inqarticles/inquirycord)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/survival/peppermill
	// Azure Peak
	name = "peppermill"
	result = /obj/item/reagent_containers/peppermill
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/reagent_containers/food/snacks/pepper = 5)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Cooking"
	rogue_skill = /datum/attribute/skill/craft/cooking
	rogue_difficulty = 5

/datum/crafting_recipe/roguetown/survival/quarterstaff_blacksteel
	// Azure Peak
	name = "blacksteel-reinforced quarterstaff"
	result = /obj/item/rogueweapon/woodstaff/quarterstaff/blacksteel
	reqs = list(/obj/item/rogueweapon/woodstaff/quarterstaff = 1, /obj/item/ingot/blacksteel = 1)
	blacklist = list(/obj/item/rogueweapon/woodstaff/quarterstaff/blacksteel, /obj/item/rogueweapon/woodstaff/quarterstaff/bombard_sponge, /obj/item/rogueweapon/woodstaff/quarterstaff/bostaff, /obj/item/rogueweapon/woodstaff/quarterstaff/gold, /obj/item/rogueweapon/woodstaff/quarterstaff/iron, /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter, /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter/warden, /obj/item/rogueweapon/woodstaff/quarterstaff/psy, /obj/item/rogueweapon/woodstaff/quarterstaff/silver, /obj/item/rogueweapon/woodstaff/quarterstaff/steel, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/astrata, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/donator_elegant, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/holysee, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/noc, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/silver, /obj/item/rogueweapon/woodstaff/quarterstaff/steel/silver/psy, /obj/item/rogueweapon/woodstaff/quarterstaff/virtue)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 5

/datum/crafting_recipe/roguetown/survival/rodblacksteel
	// Azure Peak
	name = "fishing rod, blacksteel"
	result = /obj/item/fishingrod/blacksteel
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/fibers = 2, /obj/item/ingot/blacksteel = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/datum/crafting_recipe/roguetown/survival/rodbronze
	// Azure Peak
	name = "fishing rod, bronze"
	result = /obj/item/fishingrod/bronze
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/fibers = 2, /obj/item/ingot/bronze = 1)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/datum/crafting_recipe/roguetown/survival/ropebelt/upgraded
	// Azure Peak
	name = "pouch-fitted rope belt"
	result = /obj/item/storage/belt/rogue/leather/rope/upgraded
	reqs = list(/obj/item/storage/belt/rogue/leather/rope = 1, /obj/item/storage/belt/rogue/pouch = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "ties"
	rogue_verb_simple = "tie"
	rogue_sound = null
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/survival/runicflask
	// Azure Peak
	name = "runic tincture flask"
	result = /obj/item/runicflask/charged
	reqs = list(/obj/item/alch/firedust = 2, /obj/item/alch/waterdust = 2, /obj/item/natural/hide/cured = 2)
	category = "Alchemy"
	rogue_skill = /datum/attribute/skill/craft/alchemy
	rogue_difficulty = 4
	rogue_on_table = TRUE
	rogue_verb = "assembles"
	rogue_verb_simple = "assemble"

/datum/crafting_recipe/roguetown/survival/sharpenedstake
	// Azure Peak
	name = "stake, sharpened"
	result = /obj/item/rogueweapon/huntingknife/idagger/stake
	reqs = list(/obj/item/grown/log/tree/stake = 1, /obj/item/natural/whetstone = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/survival/shillelagh
	// Azure Peak
	name = "shillelagh (x3)"
	result = /obj/item/rogueweapon/woodstaff/polearm
	reqs = list(/obj/item/grown/log/tree = 1)
	rogue_results = list(/obj/item/rogueweapon/woodstaff/polearm, /obj/item/rogueweapon/woodstaff/polearm)
	blacklist = list(/obj/item/grown/log/tree/bowpartial, /obj/item/grown/log/tree/bowpartial/longbow, /obj/item/grown/log/tree/bowpartial/recurve, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small/essence, /obj/item/grown/log/tree/stake, /obj/item/grown/log/tree/stick)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0

/datum/crafting_recipe/roguetown/survival/silvtankard
	// Azure Peak
	name = "tankards, silver (x2)"
	result = /obj/item/reagent_containers/glass/bucket/pot/kettle/tankard/silver
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/ingot/silver = 1)
	rogue_results = list(/obj/item/reagent_containers/glass/bucket/pot/kettle/tankard/silver)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/survival/soap/calendula
	// Azure Peak
	name = "calendula soap (3x)"
	result = /obj/item/soap/calendula
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/alch/calendula = 1)
	rogue_results = list(/obj/item/soap/calendula, /obj/item/soap/calendula)
	tool_paths = null
	parts = null
	blacklist = list(/obj/item/reagent_containers/food/snacks/tallow/black, /obj/item/reagent_containers/food/snacks/tallow/red, /obj/item/reagent_containers/food/snacks/tallow/soft)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = null
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/survival/soap/citrus
	// Azure Peak
	name = "citrus soap (3x)"
	result = /obj/item/soap/citrus
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/reagent_containers/food/snacks/grown/fruit/lemon = 1)
	rogue_results = list(/obj/item/soap/citrus, /obj/item/soap/citrus)
	tool_paths = null
	parts = null
	blacklist = list(/obj/item/reagent_containers/food/snacks/tallow/black, /obj/item/reagent_containers/food/snacks/tallow/red, /obj/item/reagent_containers/food/snacks/tallow/soft)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = null
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/survival/soap/jackberry
	// Azure Peak
	name = "jackberry soap (3x)"
	result = /obj/item/soap/jackberry
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1)
	rogue_results = list(/obj/item/soap/jackberry, /obj/item/soap/jackberry)
	tool_paths = null
	parts = null
	blacklist = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison, /obj/item/reagent_containers/food/snacks/tallow/black, /obj/item/reagent_containers/food/snacks/tallow/red, /obj/item/reagent_containers/food/snacks/tallow/soft)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = null
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/survival/soap/mana
	// Azure Peak
	name = "manabloom soap (3x)"
	result = /obj/item/soap/mana
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/alch/manabloompowder = 1)
	rogue_results = list(/obj/item/soap/mana, /obj/item/soap/mana)
	tool_paths = null
	parts = null
	blacklist = list(/obj/item/reagent_containers/food/snacks/tallow/black, /obj/item/reagent_containers/food/snacks/tallow/red, /obj/item/reagent_containers/food/snacks/tallow/soft)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = null
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/survival/soap/rosa
	// Azure Peak
	name = "rosa soap (3x)"
	result = /obj/item/soap/rosa
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/alch/rosa = 1)
	rogue_results = list(/obj/item/soap/rosa, /obj/item/soap/rosa)
	tool_paths = null
	parts = null
	blacklist = list(/obj/item/alch/rosa/azure, /obj/item/reagent_containers/food/snacks/tallow/black, /obj/item/reagent_containers/food/snacks/tallow/red, /obj/item/reagent_containers/food/snacks/tallow/soft)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = null
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/survival/soap/tea
	// Azure Peak
	name = "tea-leaf soap (3x)"
	result = /obj/item/soap/tea
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 1, /obj/item/reagent_containers/food/snacks/grown/tea = 1)
	rogue_results = list(/obj/item/soap/tea, /obj/item/soap/tea)
	tool_paths = null
	parts = null
	blacklist = list(/obj/item/reagent_containers/food/snacks/tallow/black, /obj/item/reagent_containers/food/snacks/tallow/red, /obj/item/reagent_containers/food/snacks/tallow/soft)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 1
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = null
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/survival/steel_scattershot
	// Azure Peak
	name = "hammered steel scattershot (x10)"
	result = /obj/item/ammo_casing/caseless/rogue/sling_bullet/scattershot
	reqs = list(/obj/item/ingot/steel = 1)
	rogue_results = list(/obj/item/ammo_casing/caseless/rogue/sling_bullet/scattershot, /obj/item/ammo_casing/caseless/rogue/sling_bullet/scattershot, /obj/item/ammo_casing/caseless/rogue/sling_bullet/scattershot, /obj/item/ammo_casing/caseless/rogue/sling_bullet/scattershot, /obj/item/ammo_casing/caseless/rogue/sling_bullet/scattershot, /obj/item/ammo_casing/caseless/rogue/sling_bullet/scattershot, /obj/item/ammo_casing/caseless/rogue/sling_bullet/scattershot, /obj/item/ammo_casing/caseless/rogue/sling_bullet/scattershot, /obj/item/ammo_casing/caseless/rogue/sling_bullet/scattershot)
	tool_paths = list(/obj/item/rogueweapon/hammer)
	blacklist = list(/obj/item/ingot/steel/zizo)
	category = "Engineering"
	rogue_skill = /datum/attribute/skill/craft/engineering
	rogue_difficulty = 3
	rogue_on_table = TRUE
	rogue_verb = "hammers out"
	rogue_verb_simple = "hammer out"

/datum/crafting_recipe/roguetown/survival/steelandclothhose
	// Azure Peak
	name = "layer a cloth hose atop steel chain hosen"
	result = /obj/item/clothing/under/roguetown/chainlegs/hose/dyeable
	reqs = list(/obj/item/clothing/under/roguetown/tights/hose = 1, /obj/item/clothing/under/roguetown/chainlegs/hose = 1)
	blacklist = list(/obj/item/clothing/under/roguetown/chainlegs/hose/dyeable)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/survival/surgcollar
	// Azure Peak
	name = "surgcollar"
	result = /obj/item/clothing/neck/roguetown/collar/surgcollar
	reqs = list(/obj/item/natural/cloth = 2)
	blacklist = list(/obj/item/natural/cloth/bandage)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 0

/datum/crafting_recipe/roguetown/survival/tarot_deck_minorarcana
	// Azure Peak
	name = "tarot deck (major and minor arcana)"
	result = /obj/item/deck/tarot/includes_minor_arcana
	reqs = list(/obj/item/paper/scroll = 3, /obj/item/grown/log/tree/small = 1, /obj/item/natural/ash = 1)
	tool_paths = list(/obj/item/natural/feather)
	blacklist = list(/obj/item/grown/log/tree/small/essence, /obj/item/natural/ash/snappop_phoenix, /obj/item/paper/scroll/bounty, /obj/item/paper/scroll/cargo, /obj/item/paper/scroll/custom, /obj/item/paper/scroll/fake_evidence, /obj/item/paper/scroll/grudge, /obj/item/paper/scroll/ministry_writ, /obj/item/paper/scroll/sell_price_changes, /obj/item/paper/scroll/trade_requests, /obj/item/paper/scroll/writ_of_esteem, /obj/item/paper/scroll/writ_of_esteem/grenzel, /obj/item/paper/scroll/writ_of_esteem/otavan, /obj/item/paper/scroll/writ_of_esteem/zybantine)
	category = "Literacy"
	rogue_skill = /datum/attribute/skill/misc/reading
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/survival/wood_dagger
	// Azure Peak
	name = "wooden dagger (x3)"
	result = /obj/item/rogueweapon/huntingknife/wood
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/fibers = 1)
	rogue_results = list(/obj/item/rogueweapon/huntingknife/wood, /obj/item/rogueweapon/huntingknife/wood)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 0

/datum/crafting_recipe/roguetown/survival/woodabyssorcross
	// Azure Peak
	name = "wooden amulet of Abyssor"
	result = /obj/item/clothing/neck/roguetown/psicross/abyssor/wood
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/grown/log/tree/stick = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/datum/crafting_recipe/roguetown/survival/woodastratacross
	// Azure Peak
	name = "wooden amulet of Astrata"
	result = /obj/item/clothing/neck/roguetown/psicross/astrata/wood
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/grown/log/tree/stick = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/datum/crafting_recipe/roguetown/survival/woodbaothacross
	// Azure Peak
	name = "wooden amulet of Baotha"
	result = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha/wood
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/grown/log/tree/stick = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/datum/crafting_recipe/roguetown/survival/wooddendorcross
	// Azure Peak
	name = "wooden amulet of Dendor"
	result = /obj/item/clothing/neck/roguetown/psicross/dendor/wood
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/grown/log/tree/stick = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/datum/crafting_recipe/roguetown/survival/woodeoracross
	// Azure Peak
	name = "wooden amulet of Eora"
	result = /obj/item/clothing/neck/roguetown/psicross/eora/wood
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/grown/log/tree/stick = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/datum/crafting_recipe/roguetown/survival/woodgraggarcross
	// Azure Peak
	name = "wooden amulet of Graggar"
	result = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/wood
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/grown/log/tree/stick = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/datum/crafting_recipe/roguetown/survival/woodmalumcross
	// Azure Peak
	name = "wooden amulet of Malum"
	result = /obj/item/clothing/neck/roguetown/psicross/malum/wood
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/grown/log/tree/stick = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/datum/crafting_recipe/roguetown/survival/woodmatthioscross
	// Azure Peak
	name = "wooden amulet of Matthios"
	result = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/wood
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/grown/log/tree/stick = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/datum/crafting_recipe/roguetown/survival/woodnecracross
	// Azure Peak
	name = "wooden amulet of Necra"
	result = /obj/item/clothing/neck/roguetown/psicross/necra/wood
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/grown/log/tree/stick = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/datum/crafting_recipe/roguetown/survival/woodnoccross
	// Azure Peak
	name = "wooden amulet of Noc"
	result = /obj/item/clothing/neck/roguetown/psicross/noc/wood
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/grown/log/tree/stick = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/datum/crafting_recipe/roguetown/survival/woodpestracross
	// Azure Peak
	name = "wooden amulet of Pestra"
	result = /obj/item/clothing/neck/roguetown/psicross/pestra/wood
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/grown/log/tree/stick = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/datum/crafting_recipe/roguetown/survival/woodravoxcross
	// Azure Peak
	name = "wooden amulet of Ravox"
	result = /obj/item/clothing/neck/roguetown/psicross/ravox/wood
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/grown/log/tree/stick = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/datum/crafting_recipe/roguetown/survival/woodreformcross
	// Azure Peak
	name = "wooden reformist psycross"
	result = /obj/item/clothing/neck/roguetown/psicross/reform/wood
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/grown/log/tree/stick = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/datum/crafting_recipe/roguetown/survival/woodtankard
	// Azure Peak
	name = "tankards, wooden (x3)"
	result = /obj/item/reagent_containers/glass/bucket/pot/kettle/tankard
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/ingot/iron = 1)
	rogue_results = list(/obj/item/reagent_containers/glass/bucket/pot/kettle/tankard, /obj/item/reagent_containers/glass/bucket/pot/kettle/tankard)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/survival/woodtencross
	// Azure Peak
	name = "wooden amulet of Ten"
	result = /obj/item/clothing/neck/roguetown/psicross/undivided/wood
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/grown/log/tree/stick = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/datum/crafting_recipe/roguetown/survival/woodxylixcross
	// Azure Peak
	name = "wooden amulet of Xylix"
	result = /obj/item/clothing/neck/roguetown/psicross/xylix/wood
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/grown/log/tree/stick = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/datum/crafting_recipe/roguetown/survival/woodzcross
	// Azure Peak
	name = "wooden inverted psycross"
	result = /obj/item/clothing/neck/roguetown/psicross/inhumen/wood
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/grown/log/tree/stick = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/datum/crafting_recipe/roguetown/survival/zigbox
	// Azure Peak
	name = "zigbox"
	result = /obj/item/storage/belt/rogue/pouch/zigarrete
	reqs = list(/obj/item/paper/scroll = 2)
	blacklist = list(/obj/item/paper/scroll/bounty, /obj/item/paper/scroll/cargo, /obj/item/paper/scroll/custom, /obj/item/paper/scroll/fake_evidence, /obj/item/paper/scroll/grudge, /obj/item/paper/scroll/ministry_writ, /obj/item/paper/scroll/sell_price_changes, /obj/item/paper/scroll/trade_requests, /obj/item/paper/scroll/writ_of_esteem, /obj/item/paper/scroll/writ_of_esteem/grenzel, /obj/item/paper/scroll/writ_of_esteem/otavan, /obj/item/paper/scroll/writ_of_esteem/zybantine)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2
	rogue_on_table = TRUE

/datum/crafting_recipe/roguetown/turfs/roguewindow/stone_astrata
	// Azure Peak
	name = "static astratan church window"
	result = /obj/structure/roguewindow/stained/yellow
	reqs = list(/obj/item/natural/stone = 2, /obj/item/natural/glass = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = list(/obj/item/natural/glass/heated, /obj/item/natural/stone/sending)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = null
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/turfs/roguewindow/stone_zizo
	// Azure Peak
	name = "static ecclesial church window"
	result = /obj/structure/roguewindow/stained/zizo
	reqs = list(/obj/item/natural/stone = 2, /obj/item/natural/glass = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = list(/obj/item/natural/glass/heated, /obj/item/natural/stone/sending)
	category = "Masonry"
	rogue_skill = /datum/attribute/skill/craft/masonry
	rogue_difficulty = 3
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "builds"
	rogue_verb_simple = "build"
	rogue_sound = null
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/turfs/wood/floorhl
	// Azure Peak
	name = "floor (herringbone light)"
	result = /turf/open/floor/rogue/ruinedwood/herringbone_clear
	reqs = list(/obj/item/natural/wood/plank = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Carpentry"
	rogue_skill = /datum/attribute/skill/craft/carpentry
	rogue_difficulty = 4
	rogue_structure = null
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = null
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/weaving/openeorarobes
	// Azure Peak
	name = "open eoran robes"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/eora/alt
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/loom

/datum/crafting_recipe/roguetown/weaving/puritangold
	// Azure Peak
	name = "puritan's cape, golden order"
	result = /obj/item/clothing/cloak/cape/puritan/gold
	reqs = list(/obj/item/natural/silk = 4)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/loom

/datum/crafting_recipe/roguetown/weaving/puritansilver
	// Azure Peak
	name = "puritan's cape, silver order"
	result = /obj/item/clothing/cloak/cape/puritan/silver
	reqs = list(/obj/item/natural/silk = 4)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/loom

/datum/crafting_recipe/roguetown/weaving/rosa/two
	// Azure Peak
	name = "scarlet dress"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/rosa/two
	reqs = list(/obj/item/natural/silk = 3, /obj/item/natural/cloth = 2, /obj/item/alch/rosa = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/loom

/datum/crafting_recipe/roguetown/weaving/rosahat
	// Azure Peak
	name = "scarlet hat"
	result = /obj/item/clothing/head/roguetown/rosa
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1, /obj/item/alch/rosa = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/loom

/datum/crafting_recipe/roguetown/weaving/rosahat/five
	// Azure Peak
	name = "sable hat"
	result = /obj/item/clothing/head/roguetown/rosa/five
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1, /obj/item/alch/rosa = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/loom
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = null
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/weaving/rosahat/four
	// Azure Peak
	name = "obsidian hat"
	result = /obj/item/clothing/head/roguetown/rosa/four
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1, /obj/item/alch/rosa = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/loom
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = null
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/weaving/rosahat/six
	// Azure Peak
	name = "maroon cap"
	result = /obj/item/clothing/head/roguetown/rosa/six
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1, /obj/item/alch/rosa = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/loom
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = null
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/weaving/rosahat/three
	// Azure Peak
	name = "velvet hat"
	result = /obj/item/clothing/head/roguetown/rosa/three
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/cloth = 1, /obj/item/alch/rosa = 1)
	rogue_results = null
	tool_paths = null
	parts = null
	blacklist = null
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/loom
	rogue_on_table = FALSE
	rogue_on_tile = FALSE
	rogue_on_wall = FALSE
	rogue_build_same = FALSE
	rogue_ignore_density = FALSE
	rogue_verb = "crafts"
	rogue_verb_simple = "craft"
	rogue_sound = null
	rogue_xp = -1
	crafting_flags = NONE
	rogue_tech_node = null
	rogue_diagonal = FALSE
	rogue_skip_quality = FALSE

/datum/crafting_recipe/roguetown/weaving/undividedclerichood
	// Azure Peak
	name = "undivided devotee hood"
	result = /obj/item/clothing/head/roguetown/roguehood/undividedcleric
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/loom

/datum/crafting_recipe/roguetown/weaving/undividedclericrobe
	// Azure Peak
	name = "undivided devotee robes"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/undividedcleric
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/silk = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 3
	rogue_structure = /obj/machinery/loom

/datum/crafting_recipe/roguetown/weaving/undividedhood
	// Azure Peak
	name = "undivided hood"
	result = /obj/item/clothing/head/roguetown/roguehood/undivided
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/loom

/datum/crafting_recipe/roguetown/weaving/undividedrobe
	// Azure Peak
	name = "undivided robes"
	result = /obj/item/clothing/suit/roguetown/shirt/robe/undivided
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/silk = 1)
	category = "Sewing"
	rogue_skill = /datum/attribute/skill/craft/sewing
	rogue_difficulty = 4
	rogue_structure = /obj/machinery/loom

/datum/crafting_recipe/roguetown/woodcarving/ashtray
	// Azure Peak
	name = "wooden zigtray"
	result = /obj/item/carvedwood/ashtray
	reqs = list(/obj/item/grown/log/tree/stick = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/woodcarving/beaver
	// Azure Peak
	name = "wooden beaver"
	result = /obj/item/carvedwood/beaver
	reqs = list(/obj/item/grown/log/tree/small = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/woodcarving/bottle
	// Azure Peak
	name = "wooden bottle"
	result = /obj/item/reagent_containers/glass/bottle/waterskin/wood
	reqs = list(/obj/item/grown/log/tree/small = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/woodcarving/box
	// Azure Peak
	name = "wooden box"
	result = /obj/item/carvedwood/box
	reqs = list(/obj/item/grown/log/tree/small = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/woodcarving/bust
	// Azure Peak
	name = "wooden bust"
	result = /obj/item/carvedwood/bust
	reqs = list(/obj/item/grown/log/tree/small = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/woodcarving/cameo
	// Azure Peak
	name = "wooden cameo"
	result = /obj/item/carvedwood/cameo
	reqs = list(/obj/item/grown/log/tree/stick = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/datum/crafting_recipe/roguetown/woodcarving/chessboard
	// Azure Peak
	name = "folded chessboard"
	result = /obj/item/chessboard_folded
	reqs = list(/obj/item/grown/log/tree/small = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/woodcarving/comb
	// Azure Peak
	name = "wooden comb"
	result = /obj/item/carvedwood/comb
	reqs = list(/obj/item/grown/log/tree/stick = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/datum/crafting_recipe/roguetown/woodcarving/displaystand
	// Azure Peak
	name = "wooden display stand"
	result = /obj/item/carvedwood/displaystand
	reqs = list(/obj/item/grown/log/tree/stick = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/datum/crafting_recipe/roguetown/woodcarving/duck
	// Azure Peak
	name = "wooden duck figurine"
	result = /obj/item/carvedwood/duck
	reqs = list(/obj/item/grown/log/tree/stick = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/woodcarving/fancyvase
	// Azure Peak
	name = "fancy wooden vase"
	result = /obj/item/carvedwood/fancyvase
	reqs = list(/obj/item/grown/log/tree/small = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/woodcarving/figurine
	// Azure Peak
	name = "wooden figurine"
	result = /obj/item/carvedwood/figurine
	reqs = list(/obj/item/grown/log/tree/stick = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/woodcarving/figurineanthro
	// Azure Peak
	name = "wooden wildkin figurine"
	result = /obj/item/carvedwood/figurineanthro
	reqs = list(/obj/item/grown/log/tree/stick = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/woodcarving/figurineelf
	// Azure Peak
	name = "wooden elf figurine"
	result = /obj/item/carvedwood/figurineelf
	reqs = list(/obj/item/grown/log/tree/stick = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/woodcarving/fish
	// Azure Peak
	name = "wooden fish figurine"
	result = /obj/item/carvedwood/fish
	reqs = list(/obj/item/grown/log/tree/stick = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/woodcarving/frog
	// Azure Peak
	name = "wooden frog figurine"
	result = /obj/item/carvedwood/frog
	reqs = list(/obj/item/grown/log/tree/stick = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/woodcarving/gameboard
	// Azure Peak
	name = "ornamental game table"
	result = /obj/item/carvedwood/gameboard
	reqs = list(/obj/item/grown/log/tree/small = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/woodcarving/heart
	// Azure Peak
	name = "wooden heart"
	result = /obj/item/carvedwood/heart
	reqs = list(/obj/item/grown/log/tree/stick = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/woodcarving/marble
	// Azure Peak
	name = "wooden marble"
	result = /obj/item/carvedwood/marble
	reqs = list(/obj/item/grown/log/tree/stick = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/datum/crafting_recipe/roguetown/woodcarving/moon
	// Azure Peak
	name = "wooden moon"
	result = /obj/item/carvedwood/moon
	reqs = list(/obj/item/grown/log/tree/stick = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/woodcarving/pillar
	// Azure Peak
	name = "wooden pillar"
	result = /obj/item/carvedwood/pillar
	reqs = list(/obj/item/grown/log/tree/small = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/woodcarving/plinth
	// Azure Peak
	name = "wooden plinth"
	result = /obj/item/carvedwood/plinth
	reqs = list(/obj/item/grown/log/tree/small = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/woodcarving/prism
	// Azure Peak
	name = "wooden prism"
	result = /obj/item/carvedwood/prism
	reqs = list(/obj/item/grown/log/tree/stick = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/datum/crafting_recipe/roguetown/woodcarving/saiga
	// Azure Peak
	name = "wooden saiga figurine"
	result = /obj/item/carvedwood/saiga
	reqs = list(/obj/item/grown/log/tree/stick = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/woodcarving/shrine
	// Azure Peak
	name = "wooden shrine"
	result = /obj/item/carvedwood/shrine
	reqs = list(/obj/item/grown/log/tree/small = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 4

/datum/crafting_recipe/roguetown/woodcarving/spire
	// Azure Peak
	name = "wooden spire"
	result = /obj/item/carvedwood/spire
	reqs = list(/obj/item/grown/log/tree/stick = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/datum/crafting_recipe/roguetown/woodcarving/sun
	// Azure Peak
	name = "wooden sun"
	result = /obj/item/carvedwood/sun
	reqs = list(/obj/item/grown/log/tree/stick = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3

/datum/crafting_recipe/roguetown/woodcarving/vase
	// Azure Peak
	name = "wooden vase"
	result = /obj/item/carvedwood/vase
	reqs = list(/obj/item/grown/log/tree/small = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 2

/datum/crafting_recipe/roguetown/woodcarving/vessel
	// Azure Peak
	name = "large wooden vessel"
	result = /obj/item/carvedwood/vessel
	reqs = list(/obj/item/grown/log/tree/small = 1)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	blacklist = list(/obj/item/grown/log/tree/small/essence)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_difficulty = 3
