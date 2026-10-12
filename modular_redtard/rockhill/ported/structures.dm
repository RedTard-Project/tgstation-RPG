/obj/structure/apiary
	parent_type = /obj/structure/rockhill

/obj/structure/bondage
	parent_type = /obj/structure/rockhill

/obj/structure/broadcast_horn
	parent_type = /obj/structure/rockhill

/obj/structure/curtain/directional
	parent_type = /obj/structure/rockhill

/obj/structure/deadbody
	parent_type = /obj/structure/rockhill

/obj/structure/drape
	parent_type = /obj/structure/rockhill

/obj/structure/dungeon_entry
	parent_type = /obj/structure/rockhill

/obj/structure/fireaxecabinet/unforgotten
	parent_type = /obj/structure/rockhill

/obj/structure/flora/ausbushes
	parent_type = /obj/structure/rockhill

/obj/structure/fluff/iconsign
	parent_type = /obj/structure/rockhill

/obj/structure/fluff/pillow
	parent_type = /obj/structure/rockhill

/obj/structure/fluff/walldeco
	parent_type = /obj/structure/rockhill

/obj/structure/ritualcircle
	parent_type = /obj/structure/rockhill

/obj/structure/rogue
	parent_type = /obj/structure/rockhill

/obj/structure/roguemachine
	parent_type = /obj/structure/rockhill

/obj/structure/shisha
	parent_type = /obj/structure/rockhill

/obj/structure/underworld
	parent_type = /obj/structure/rockhill

/obj/structure/wild_plant
	parent_type = /obj/structure/rockhill

/obj/structure/wooden_horse
	parent_type = /obj/structure/rockhill

/obj/machinery/anvil
	parent_type = /obj/structure/rockhill
	name = "iron anvil"
	desc = "It's surface is marred by countless hammer strikes."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/forge.dmi'
	icon_state = "anvil"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/machinery/anvil/crafted
	name = "iron anvil"
	desc = "It's surface is marred by countless hammer strikes."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/forge.dmi'
	icon_state = "caveanvil"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/machinery/artificer_table
	parent_type = /obj/structure/rockhill
	name = "artificer table"
	desc = "An artificers wood work station, blessed by some odd machination, or perhaps... magic..."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tables.dmi'
	icon_state = "art_table"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/machinery/gear_painter
	parent_type = /obj/structure/rockhill
	name = "Dye Station"
	desc = "A station to give your apparel a fresh new color! Recommended to use with white items for best results."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "dyestation"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/machinery/loom
	parent_type = /obj/structure/rockhill
	name = "loom"
	desc = "A wooden frame with taut threads ready to weave fabric."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "loom"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/machinery/tanningrack
	parent_type = /obj/structure/rockhill
	name = "drying rack"
	desc = "A rack for drying meats or scraping hides into leather. It can be moved with the help of a wooden stake."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "dryrack"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/apiary/starter
	name = "apiary"
	desc = "A structure housing bees that produce honey and pollinate plants."
	icon = 'modular_redtard/rockhill/icons/obj/structures/apiary.dmi'
	icon_state = "beebox-empty"
	layer = BELOW_OBJ_LAYER

/obj/structure/arcyne_wall
	parent_type = /obj/structure/rockhill
	name = "Arcyne Wall"
	desc = "A wall of pure arcyne force."
	icon = 'modular_redtard/rockhill/icons/effects/effects.dmi'
	icon_state = "arcynewall"
	density = TRUE
	opacity = 0
	layer = BELOW_OBJ_LAYER

/obj/structure/barricade/crude
	parent_type = /obj/structure/rockhill
	name = "crude plank barricade"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/obj/structures.dmi'
	icon_state = "woodenbarricade-old"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/barricade/crude/snow
	name = "crude plank barricade"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/obj/structures.dmi'
	icon_state = "woodenbarricade-snow-old"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/barricade/mineshaft
	parent_type = /obj/structure/rockhill
	name = "mineshaft support"
	desc = "This'll stop those tremors from triggering."
	icon = 'modular_redtard/rockhill/icons/obj/structures.dmi'
	icon_state = "woodenbarricade_mineshaft"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/bars
	parent_type = /obj/structure/rockhill
	name = "bars"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "bars"
	density = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/bars/cemetery
	name = "bars"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "cemetery"
	density = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/bars/grille
	name = "grille"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "floorgrille"
	density = FALSE
	layer = TABLE_LAYER
	rockhill_random_dir = TRUE

/obj/structure/bars/grille/rusty
	name = "rusty grille"
	desc = "A few good hits ought to smash it open."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "floorgrille"
	density = FALSE
	layer = TABLE_LAYER
	color = "#d9c8c1"
	rockhill_random_dir = TRUE

/obj/structure/bars/nopassthrow
	name = "bars"
	desc = "The bars are too thick to throw anything through the gaps."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "bars"
	density = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/bars/passage
	name = "bars"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "passage0"
	density = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/bars/passage/preopen
	name = "bars"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "passage1"
	density = FALSE
	layer = ABOVE_MOB_LAYER

/obj/structure/bars/passage/shutter
	name = "bars"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "shutter0"
	density = TRUE
	opacity = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/bars/passage/shutter/open
	name = "bars"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "shutter1"
	density = FALSE
	opacity = FALSE
	layer = ABOVE_MOB_LAYER

/obj/structure/bars/passage/steel
	name = "steel bars"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "passage0"
	density = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/bars/pipe
	name = "bronze pipe"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "pipe"
	density = FALSE
	layer = TABLE_LAYER

/obj/structure/bars/rusty
	name = "rusty bars"
	desc = "these look fragile"
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "bars"
	density = TRUE
	layer = ABOVE_MOB_LAYER
	color = "#ffcd9f"

/obj/structure/bars/shop
	name = "bars"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "barsbent"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/bars/steel
	name = "steel bars"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "bars"
	density = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/bars/tough
	name = "bars"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "bars"
	density = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/bearpelt
	parent_type = /obj/structure/rockhill
	name = "Bearpelt"
	desc = "The hide of a slain bear. Once a terror of the woods; now it decorates the floor."
	icon = 'modular_redtard/rockhill/icons/turf/floors/bear.dmi'
	icon_state = "bear"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/bell_common
	parent_type = /obj/structure/rockhill
	name = "bell"
	desc = "A good way to get someone's attention... or piss them off."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "bell_common"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/boatbell
	parent_type = /obj/structure/rockhill
	name = "bell"
	desc = "This is the doomspeller of Roguetown."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "bell"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/boatbell/fluff
	name = "bell"
	desc = "This is the doomspeller of Roguetown."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "bell"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/bobcatpelt
	parent_type = /obj/structure/rockhill
	name = "Lynxpelt"
	desc = "A hide of a slain lynx."
	icon = 'modular_redtard/rockhill/icons/turf/floors/animal_rugs.dmi'
	icon_state = "bobcat"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/bondage/chains
	name = "chains"
	desc = "Heavy chains bolted into place."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "CHAINS"
	density = FALSE
	pixel_x = 0
	pixel_y = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/bondage/gloryhole
	name = "gloryhole"
	desc = "A wooden partition with a suspicious hole."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "gloryhole"
	density = TRUE

/obj/structure/bondage/torture_table
	name = "torture table"
	desc = "A cruel table meant for restraining captives."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/64x64.dmi'
	icon_state = "tort_table"
	density = TRUE
	pixel_x = -16
	pixel_y = 0
	layer = TABLE_LAYER

/obj/structure/bondage/torture_table/lever
	name = "torture table lever"
	desc = "A torture table with a built-in lever mechanism. Right click to use the lever."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/64x64.dmi'
	icon_state = "tort_table_lever"
	density = TRUE
	pixel_x = -16
	pixel_y = 0
	layer = TABLE_LAYER

/obj/structure/bondage/x_pillory
	name = "x-pillory"
	desc = "A brutal restraint shaped like a cross."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "x_pillory"
	density = TRUE

/obj/structure/bonepile
	parent_type = /obj/structure/rockhill
	icon = 'modular_redtard/rockhill/icons/roguetown/mob/monster/wraith.dmi'
	icon_state = "hauntpile"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/bookcase/random/archive
	parent_type = /obj/structure/rockhill
	name = "bookcase"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/bookshelf.dmi'
	icon_state = "bookcase"
	density = TRUE
	opacity = 1
	layer = BELOW_OBJ_LAYER

/obj/structure/broadcast_horn/loudmouth
	name = "\improper Golden Mouth"
	desc = "The Loudmouth's own gleaming horn, its surface engraved with the ducal crest."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "broadcaster"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/broadcast_horn/loudmouth/guest
	name = "\improper Silver Tongue"
	desc = "A guest's horn. Not as gaudy as the Loudmouth's own, but still a fine piece of craftsmanship. "
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "broadcaster_crass"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/broadcast_horn/paid
	name = "\improper Streetpipe"
	desc = "Also known as the People's Mouth, so long as the people can afford the ratfeed to pay for it."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "broadcaster_crass"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/composter
	parent_type = /obj/structure/rockhill
	name = "composter"
	desc = "A wooden fencing with space for discarded produce to turn into compost."
	icon = 'modular_redtard/rockhill/icons/obj/structures/composter.dmi'
	icon_state = "composter"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/composter/full
	name = "composter"
	desc = "A wooden fencing with space for discarded produce to turn into compost."
	icon = 'modular_redtard/rockhill/icons/obj/structures/composter.dmi'
	icon_state = "composter"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/composter/halffull
	name = "composter"
	desc = "A wooden fencing with space for discarded produce to turn into compost."
	icon = 'modular_redtard/rockhill/icons/obj/structures/composter.dmi'
	icon_state = "composter"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/crabnest
	parent_type = /obj/structure/rockhill
	name = "Mudcrab Burrow"
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "crabnest"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/curtain/black
	parent_type = /obj/structure/rockhill
	name = "curtain"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "curtain-open"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	alpha = 255
	color = "#414143"

/obj/structure/curtain/blue
	parent_type = /obj/structure/rockhill
	name = "curtain"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "curtain-open"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	alpha = 255

/obj/structure/curtain/brown
	parent_type = /obj/structure/rockhill
	name = "curtain"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "curtain-open"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	alpha = 255

/obj/structure/curtain/directional/black
	name = "curtain"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "curtaindir"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	alpha = 255
	color = "#414143"

/obj/structure/curtain/directional/blue
	name = "curtain"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "curtaindir"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	alpha = 255

/obj/structure/curtain/directional/brown
	name = "curtain"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "curtaindir"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	alpha = 255

/obj/structure/curtain/directional/crafted
	name = "curtain"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "curtaindir"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	alpha = 255
	color = "#ffffff"

/obj/structure/curtain/directional/drab
	name = "curtain"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "curtaindir"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	alpha = 255

/obj/structure/curtain/directional/magenta
	name = "curtain"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "curtaindir"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	alpha = 255
	color = "#962e5c"

/obj/structure/curtain/directional/orange
	name = "curtain"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "curtaindir"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	alpha = 255
	color = "#a3622c"

/obj/structure/curtain/directional/red
	name = "curtain"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "curtaindir"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	alpha = 255
	color = "#a32121"

/obj/structure/curtain/directional/yellow
	name = "curtain"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "curtaindir"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	alpha = 255
	color = "#a18727"

/obj/structure/curtain/drab
	parent_type = /obj/structure/rockhill
	name = "curtain"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "curtain-open"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	alpha = 255

/obj/structure/curtain/green
	parent_type = /obj/structure/rockhill
	name = "curtain"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "curtain-open"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	alpha = 255

/obj/structure/curtain/magenta
	parent_type = /obj/structure/rockhill
	name = "curtain"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "curtain-open"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	alpha = 255
	color = "#962e5c"

/obj/structure/curtain/orange
	parent_type = /obj/structure/rockhill
	name = "curtain"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "curtain-open"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	alpha = 255
	color = "#a3622c"

/obj/structure/curtain/purple
	parent_type = /obj/structure/rockhill
	name = "curtain"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "curtain-open"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	alpha = 255
	color = "#8747b1"

/obj/structure/curtain/red
	parent_type = /obj/structure/rockhill
	name = "curtain"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "curtain-open"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	alpha = 255
	color = "#a32121"

/obj/structure/curtain/yellow
	parent_type = /obj/structure/rockhill
	name = "curtain"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "curtain-open"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	alpha = 255
	color = "#a18727"

/obj/structure/deadbody/adventurer_leather
	name = "dead adventurer"
	desc = "Came looking for glory. You suppose they found it - with Necra."
	icon = 'modular_redtard/rockhill/icons/roguetown/rw_deadbodies.dmi'
	icon_state = "base"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/deadbody/bogman
	name = "dead bogman"
	desc = "They died for a greater cause, it seems like."
	icon = 'modular_redtard/rockhill/icons/roguetown/rw_deadbodies.dmi'
	icon_state = "base"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/deadbody/greater_skeleton
	name = "dead legionnaire"
	desc = "One of Zizo's many warriors. They probably died before, during or after Her reign."
	icon = 'modular_redtard/rockhill/icons/roguetown/rw_deadbodies.dmi'
	icon_state = "base"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/deadbody/necromancer
	name = "dead necromancer"
	desc = "Cheated death once. Couldn't manage twice."
	icon = 'modular_redtard/rockhill/icons/roguetown/rw_deadbodies.dmi'
	icon_state = "base"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/deadbody/old_knight
	name = "dead knight"
	desc = "Honor in death if not in victory."
	icon = 'modular_redtard/rockhill/icons/roguetown/rw_deadbodies.dmi'
	icon_state = "base"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/deadbody/peasant
	name = "dead peasant"
	desc = "Someone who had very little, and lost it."
	icon = 'modular_redtard/rockhill/icons/roguetown/rw_deadbodies.dmi'
	icon_state = "base"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/deadbody/rogue
	name = "dead rogue"
	desc = "Died with their secrets and cunning. More so secrets, less cunning."
	icon = 'modular_redtard/rockhill/icons/roguetown/rw_deadbodies.dmi'
	icon_state = "base"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/deadbody/skeleton
	name = "old bones"
	desc = "What little remains of someone."
	icon = 'modular_redtard/rockhill/icons/roguetown/rw_deadbodies.dmi'
	icon_state = "base"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/deadbody/warden
	name = "dead warden"
	desc = "Died doing what they swore to do - holding the line between Rockhill and the terrorbog."
	icon = 'modular_redtard/rockhill/icons/roguetown/rw_deadbodies.dmi'
	icon_state = "base"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/deadbody/wizard
	name = "dead mage"
	desc = "All that knowledge, gone."
	icon = 'modular_redtard/rockhill/icons/roguetown/rw_deadbodies.dmi'
	icon_state = "base"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/deadbodyrandom
	parent_type = /obj/structure/rockhill
	name = "random dead body (dummy)"
	desc = "This dummy object doesn't do anything"
	icon = 'modular_redtard/rockhill/icons/roguetown/rw_deadbodies.dmi'
	icon_state = "base"
	layer = BELOW_OBJ_LAYER

/obj/structure/deadbodyrandom/all
	name = "random dead body"
	desc = "This dummy object can spawn any body"
	icon = 'modular_redtard/rockhill/icons/roguetown/rw_deadbodies.dmi'
	icon_state = "base"
	layer = BELOW_OBJ_LAYER

/obj/structure/deadbodyrandom/high
	name = "random dead body (high)"
	desc = "This spawner spawns the best bodies"
	icon = 'modular_redtard/rockhill/icons/roguetown/rw_deadbodies.dmi'
	icon_state = "base"
	layer = BELOW_OBJ_LAYER

/obj/structure/deadbodyrandom/low
	name = "random dead body (low)"
	desc = "This spawner spawns only the basic bodies"
	icon = 'modular_redtard/rockhill/icons/roguetown/rw_deadbodies.dmi'
	icon_state = "base"
	layer = BELOW_OBJ_LAYER

/obj/structure/deadbodyrandom/med
	name = "random dead body (medium)"
	desc = "This spawner spawns bodies weighted by value"
	icon = 'modular_redtard/rockhill/icons/roguetown/rw_deadbodies.dmi'
	icon_state = "base"
	layer = BELOW_OBJ_LAYER

/obj/structure/dock_bell
	parent_type = /obj/structure/rockhill
	name = "Dock Bell"
	desc = "A loud bell that carries its sound to the nearby ports. Signals merchants we are looking to trade."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "dock_bell"
	layer = BELOW_OBJ_LAYER

/obj/structure/drape/desert
	name = "desert drape"
	desc = "Made from durable fabric, it serves its purpose."
	icon = 'modular_redtard/rockhill/icons/modular_deserttown/icons/drapes.dmi'
	icon_state = "desertdrape"
	layer = BELOW_OBJ_LAYER

/obj/structure/drape/zybantine
	name = "zybantine drape"
	desc = "Made from prestigious fabric, a display of wealth."
	icon = 'modular_redtard/rockhill/icons/modular_deserttown/icons/drapes.dmi'
	icon_state = "zybantinedrape1"
	layer = BELOW_OBJ_LAYER
	color = "#a3a3a3"
	rockhill_variant = "zybantinedrape#"
	rockhill_variant_min = 1
	rockhill_variant_max = 2

/obj/structure/dungeon_entry/center
	name = "The Tomb of Alotheos"
	desc = "Greedy fool, will you emerge rich and victorious, or be entombed forever?"
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/portal.dmi'
	icon_state = "portal"
	density = TRUE
	opacity = TRUE
	pixel_x = -48
	layer = BELOW_OBJ_LAYER

/obj/structure/eoran_pomegranate_tree
	parent_type = /obj/structure/rockhill
	name = "pomegranate tree"
	desc = "A mystical tree blessed by Eora."
	icon = 'modular_redtard/rockhill/icons/modular_azurepeak/icons/obj/items/eora_tree.dmi'
	icon_state = "sprout"
	density = TRUE
	pixel_x = -8
	layer = BELOW_OBJ_LAYER

/obj/structure/far_travel
	parent_type = /obj/structure/rockhill
	name = "far travel"
	desc = "Anywhere is better than here.\n(Drag your sprite onto this to exit the round!)"
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	icon_state = "fartravel"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/feedinghole
	parent_type = /obj/structure/rockhill
	name = "FEEDING HOLE"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "feedinghole"
	density = FALSE
	pixel_y = 32
	layer = BELOW_OBJ_LAYER

/obj/structure/fermentation_keg
	parent_type = /obj/structure/rockhill
	name = "fermentation keg"
	desc = "A simple keg that is meant for making booze."
	icon = 'modular_redtard/rockhill/icons/obj/brewing.dmi'
	icon_state = "barrel_tapless"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/fermentation_keg/beer
	name = "fermentation keg"
	desc = "A barrel containing a generic housebrewed small-beer."
	icon = 'modular_redtard/rockhill/icons/obj/brewing.dmi'
	icon_state = "barrel_tapless"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/fermentation_keg/distiller
	name = "copper distiller"
	desc = "A simple keg that is meant for making booze."
	icon = 'modular_redtard/rockhill/icons/obj/distillery.dmi'
	icon_state = "distillery"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/fermentation_keg/gronmead
	name = "fermentation keg"
	desc = "A barrel with a Shieldmaiden Brewery mark. A deep red honey-wine, refined with the red berries native to Gronns highlands."
	icon = 'modular_redtard/rockhill/icons/obj/brewing.dmi'
	icon_state = "barrel_tapless"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/fermentation_keg/random
	name = "fermentation keg"
	desc = "A simple keg that is meant for making booze."
	icon = 'modular_redtard/rockhill/icons/obj/brewing.dmi'
	icon_state = "barrel_tapless"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/fermentation_keg/random/beer
	name = "fermentation keg"
	desc = "A simple keg that is meant for making booze."
	icon = 'modular_redtard/rockhill/icons/obj/brewing.dmi'
	icon_state = "barrel_tapless"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/fermentation_keg/random/water
	name = "water barrel"
	desc = "A simple keg that is meant for making booze."
	icon = 'modular_redtard/rockhill/icons/obj/brewing.dmi'
	icon_state = "barrel_tapless"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/fermentation_keg/redwine
	name = "fermentation keg"
	desc = "A barrel that contains an Otavan luxury. It was originally served as part of Psydonic communion, eventually becoming wildly enjoyed within Otava to the point of being oft paired with EVERY meal."
	icon = 'modular_redtard/rockhill/icons/obj/brewing.dmi'
	icon_state = "barrel_tapless"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/fermentation_keg/sourwine
	name = "fermentation keg"
	desc = "A barrel that contains a Grenzelhoftian classic. An extremely sour wine that is watered down with mineral water."
	icon = 'modular_redtard/rockhill/icons/obj/brewing.dmi'
	icon_state = "barrel_tapless"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/fermentation_keg/water
	name = "water barrel"
	desc = "A simple keg that is meant for making booze."
	icon = 'modular_redtard/rockhill/icons/obj/brewing.dmi'
	icon_state = "barrel_tapless"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/fermentation_keg/whitewine
	name = "fermentation keg"
	desc = "A barrel that contains an Otavan luxury. A sweeter tasting wine that often serves to highlight and enhance savoury notes. The rarer the vintage, the harder the find. The names of the ingredients often grow more ostentatious the closer you get to the capital."
	icon = 'modular_redtard/rockhill/icons/obj/brewing.dmi'
	icon_state = "barrel_tapless"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/fireaxecabinet/south
	parent_type = /obj/structure/rockhill
	name = "Sword rack"
	desc = "A fitting resting place for a sword etched and scratched by tales long past."
	icon = 'modular_redtard/rockhill/icons/obj/wallmounts.dmi'
	icon_state = "fireaxe"
	density = FALSE
	pixel_y = 32
	layer = BELOW_OBJ_LAYER

/obj/structure/fireaxecabinet/unforgotten/south
	name = "unforgotten blade mantle"
	desc = "A fitting resting place for a Psydonian sword etched and scratched by endurance long past."
	icon = 'modular_redtard/rockhill/icons/obj/wallmounts.dmi'
	icon_state = "fireaxe"
	density = FALSE
	pixel_y = 32
	layer = BELOW_OBJ_LAYER

/obj/structure/flagpole
	parent_type = /obj/structure/rockhill
	name = "flagpole"
	desc = "An artificed flagpole. It responds to distant signals to show which of the town's important figures are currently active..."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/flagpole.dmi'
	icon_state = "flagpole"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/floordoor
	parent_type = /obj/structure/rockhill
	name = "floorhatch"
	desc = "A handy floor hatch for people who need privacy upstairs."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "floorhatch1"
	density = FALSE
	layer = ABOVE_OPEN_TURF_LAYER

/obj/structure/floordoor/gatehatch/inner
	name = ""
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = ""
	density = FALSE
	layer = ABOVE_OPEN_TURF_LAYER

/obj/structure/floordoor/gatehatch/outer
	name = ""
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = ""
	density = FALSE
	layer = ABOVE_OPEN_TURF_LAYER

/obj/structure/flora/ausbushes/brflowers
	name = "bush"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/obj/flora/ausflora.dmi'
	icon_state = "brflowers_1"
	layer = BELOW_OBJ_LAYER
	rockhill_variant = "brflowers_#"
	rockhill_variant_min = 1
	rockhill_variant_max = 3

/obj/structure/flora/ausbushes/fernybush
	name = "bush"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/obj/flora/ausflora.dmi'
	icon_state = "fernybush_1"
	layer = BELOW_OBJ_LAYER
	rockhill_variant = "fernybush_#"
	rockhill_variant_min = 1
	rockhill_variant_max = 3

/obj/structure/flora/ausbushes/lavendergrass
	name = "bush"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/obj/flora/ausflora.dmi'
	icon_state = "lavendergrass_1"
	layer = BELOW_OBJ_LAYER
	rockhill_variant = "lavendergrass_#"
	rockhill_variant_min = 1
	rockhill_variant_max = 4

/obj/structure/flora/ausbushes/ppflowers
	name = "bush"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/obj/flora/ausflora.dmi'
	icon_state = "ppflowers_1"
	layer = BELOW_OBJ_LAYER
	rockhill_variant = "ppflowers_#"
	rockhill_variant_min = 1
	rockhill_variant_max = 3

/obj/structure/flora/ausbushes/stalkybush
	name = "bush"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/obj/flora/ausflora.dmi'
	icon_state = "stalkybush_1"
	layer = BELOW_OBJ_LAYER
	rockhill_variant = "stalkybush_#"
	rockhill_variant_min = 1
	rockhill_variant_max = 3

/obj/structure/flora/ausbushes/ywflowers
	name = "bush"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/obj/flora/ausflora.dmi'
	icon_state = "ywflowers_1"
	layer = BELOW_OBJ_LAYER
	rockhill_variant = "ywflowers_#"
	rockhill_variant_min = 1
	rockhill_variant_max = 3

/obj/structure/flora/hotspring_rocks
	parent_type = /obj/structure/rockhill
	name = "large rock"
	icon = 'modular_redtard/rockhill/icons/obj/structures/hotspring.dmi'
	icon_state = "bigrock"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/flora/hotspring_rocks/grassy
	name = "grassy large rock"
	icon = 'modular_redtard/rockhill/icons/obj/structures/hotspring.dmi'
	icon_state = "bigrock_grass"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/flora/hotspring_rocks/small
	name = "small rock"
	icon = 'modular_redtard/rockhill/icons/obj/structures/hotspring.dmi'
	icon_state = "stones_1"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/flora/hotspring_rocks/small/four
	name = "small rock"
	icon = 'modular_redtard/rockhill/icons/obj/structures/hotspring.dmi'
	icon_state = "stones_4"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/flora/hotspring_rocks/small/three
	name = "small rock"
	icon = 'modular_redtard/rockhill/icons/obj/structures/hotspring.dmi'
	icon_state = "stones_3"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/flora/hotspring_rocks/small/two
	name = "small rock"
	icon = 'modular_redtard/rockhill/icons/obj/structures/hotspring.dmi'
	icon_state = "stones_2"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/flora/mushroomcluster
	parent_type = /obj/structure/rockhill
	name = "mushroom cluster"
	desc = "A large cluster of mushrooms with a strange glow."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliage.dmi'
	icon_state = "mushroomcluster"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/flora/mushroomcluster/unhappy
	name = "mushroom cluster"
	desc = "A cluster of mushrooms native to the underdark."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliage.dmi'
	icon_state = "mushroomclusterunhappy"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/flora/newleaf/corner
	parent_type = /obj/structure/rockhill
	name = "leaves"
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tree.dmi'
	icon_state = "corner-leaf1"
	density = FALSE
	layer = BELOW_OBJ_LAYER
	rockhill_variant = "corner-leaf#"
	rockhill_variant_min = 1
	rockhill_variant_max = 2

/obj/structure/flora/rock/jungle
	parent_type = /obj/structure/rockhill
	desc = ""
	icon = 'modular_redtard/rockhill/icons/obj/flora/jungleflora.dmi'
	icon_state = "rock"
	density = FALSE
	layer = BELOW_OBJ_LAYER
	rockhill_variant = "rock#"
	rockhill_variant_min = 1
	rockhill_variant_max = 5

/obj/structure/flora/roguegrass
	parent_type = /obj/structure/rockhill
	name = "grass"
	desc = "Green, soft, and lively."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliage.dmi'
	icon_state = "grass1"
	layer = BELOW_OBJ_LAYER

/obj/structure/flora/roguegrass/bush
	name = "bush"
	desc = "A bush. It's crawling with spiders, but maybe there's something useful inside..."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliage.dmi'
	icon_state = "bush2"
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/flora/roguegrass/bush/jungle
	name = "jungle bush"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/obj/flora/jungleflora.dmi'
	icon_state = "bushb"
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/flora/roguegrass/bush/jungle/large
	name = "jungle bush"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/obj/flora/largejungleflora.dmi'
	icon_state = "bush"
	opacity = TRUE
	pixel_x = -16
	pixel_y = -12
	layer = ABOVE_ALL_MOB_LAYER
	rockhill_variant = "bush#"
	rockhill_variant_min = 1
	rockhill_variant_max = 3

/obj/structure/flora/roguegrass/bush/wall
	name = "great bush"
	desc = "A bush. This one's roots are thick enough to block the way."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliage.dmi'
	icon_state = "bushwall1"
	density = TRUE
	opacity = TRUE
	layer = ABOVE_ALL_MOB_LAYER
	rockhill_variant = "bushwall#"
	rockhill_variant_min = 1
	rockhill_variant_max = 2

/obj/structure/flora/roguegrass/bush/wall/tall
	name = "great bush"
	desc = "A bush. This one's roots are thick enough to block the way."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliagetall.dmi'
	icon_state = "tallbush1"
	density = TRUE
	opacity = 1
	pixel_x = -16
	layer = ABOVE_ALL_MOB_LAYER
	rockhill_variant = "tallbush#"
	rockhill_variant_min = 1
	rockhill_variant_max = 2

/obj/structure/flora/roguegrass/bush/wall/tall/grown
	name = "great bush"
	desc = "A bush. This one's roots are thick enough to block the way."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliagetall.dmi'
	icon_state = "tallbush1"
	density = FALSE
	opacity = 1
	pixel_x = -16
	layer = ABOVE_ALL_MOB_LAYER
	rockhill_variant = "tallbush#"
	rockhill_variant_min = 1
	rockhill_variant_max = 2

/obj/structure/flora/roguegrass/bush/westleach
	name = "westleach bush"
	desc = "Large, red leaves peek out of it with an alluring aroma."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliage.dmi'
	icon_state = "bush1"
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/flora/roguegrass/bush/winter
	name = "bush"
	desc = "A bush. It's crawling with spiders, but maybe there's something useful inside..."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliage.dmi'
	icon_state = "bush1winter"
	layer = ABOVE_ALL_MOB_LAYER
	rockhill_variant = "bush#winter"
	rockhill_variant_min = 1
	rockhill_variant_max = 4

/obj/structure/flora/roguegrass/bush/winter/wall
	name = "bush"
	desc = "A bush. It's crawling with spiders, but maybe there's something useful inside..."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliage.dmi'
	icon_state = "bush5winter"
	layer = ABOVE_ALL_MOB_LAYER
	rockhill_variant = "bush#winter"
	rockhill_variant_min = 1
	rockhill_variant_max = 4

/obj/structure/flora/roguegrass/herb/artemisia
	name = "artemisia"
	desc = "A bush,for an herb. This shouldn't show up."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/herbfoliage.dmi'
	icon_state = "artemisia"

/obj/structure/flora/roguegrass/herb/atropa
	name = "atropa"
	desc = "A bush,for an herb. This shouldn't show up."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/herbfoliage.dmi'
	icon_state = "atropa"

/obj/structure/flora/roguegrass/herb/calendula
	name = "calendula"
	desc = "A bush,for an herb. This shouldn't show up."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/herbfoliage.dmi'
	icon_state = "calendula"

/obj/structure/flora/roguegrass/herb/manabloom
	name = "manabloom"
	desc = "A bush,for an herb. This shouldn't show up."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/crops.dmi'
	icon_state = "manabloom2"

/obj/structure/flora/roguegrass/herb/matricaria
	name = "matricaria"
	desc = "A bush,for an herb. This shouldn't show up."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/herbfoliage.dmi'
	icon_state = "matricaria"

/obj/structure/flora/roguegrass/herb/random
	name = "random herb"
	desc = "Haha, im in danger."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/herbfoliage.dmi'
	icon_state = "spritemeplz"

/obj/structure/flora/roguegrass/herb/rosa
	name = "rosa"
	desc = "A bush,for an herb. This shouldn't show up."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/herbfoliage.dmi'
	icon_state = "rosa"

/obj/structure/flora/roguegrass/herb/salvia
	name = "salvia"
	desc = "A bush,for an herb. This shouldn't show up."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/herbfoliage.dmi'
	icon_state = "salvia"

/obj/structure/flora/roguegrass/herb/symphitum
	name = "symphitum"
	desc = "A bush,for an herb. This shouldn't show up."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/herbfoliage.dmi'
	icon_state = "symphitum"

/obj/structure/flora/roguegrass/herb/taraxacum
	name = "taraxacum"
	desc = "A bush,for an herb. This shouldn't show up."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/herbfoliage.dmi'
	icon_state = "taraxacum"

/obj/structure/flora/roguegrass/herb/urtica
	name = "urtica"
	desc = "A bush,for an herb. This shouldn't show up."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/herbfoliage.dmi'
	icon_state = "urtica"

/obj/structure/flora/roguegrass/jungle
	name = "jungle grass"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/obj/flora/jungleflora.dmi'
	icon_state = "grassa"
	layer = BELOW_OBJ_LAYER
	rockhill_variant = "grassa#"
	rockhill_variant_min = 1
	rockhill_variant_max = 5

/obj/structure/flora/roguegrass/jungle/sparse
	name = "jungle grass"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/obj/flora/jungleflora.dmi'
	icon_state = "grassb"
	layer = BELOW_OBJ_LAYER
	rockhill_variant = "grassb#"
	rockhill_variant_min = 1
	rockhill_variant_max = 5

/obj/structure/flora/roguegrass/maneater
	name = "grass"
	desc = "Green and vivid. Was that a tendril?"
	icon = 'modular_redtard/rockhill/icons/roguetown/mob/monster/maneater.dmi'
	icon_state = "maneater-hidden"
	layer = BELOW_OBJ_LAYER

/obj/structure/flora/roguegrass/maneater/real
	name = "grass"
	desc = "Green and vivid. Was that a tendril?"
	icon = 'modular_redtard/rockhill/icons/roguetown/mob/monster/maneater.dmi'
	icon_state = "maneater-hidden"
	layer = BELOW_OBJ_LAYER

/obj/structure/flora/roguegrass/maneater/real/juvenile
	name = "juvenile maneater"
	desc = "Green and vivid. This one seems smaller than usual."
	icon = 'modular_redtard/rockhill/icons/roguetown/mob/monster/maneater.dmi'
	icon_state = "maneater-hidden"
	layer = BELOW_OBJ_LAYER

/obj/structure/flora/roguegrass/pumpkin
	name = "bunch of wild pumpkins"
	desc = "Wild pumpkins overgrown with vines."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliage.dmi'
	icon_state = "pumpkin1"
	layer = BELOW_OBJ_LAYER
	rockhill_variant = "pumpkin#"
	rockhill_variant_min = 1
	rockhill_variant_max = 2

/obj/structure/flora/roguegrass/pyroclasticflowers
	name = "odd group of flowers"
	desc = "A cluster of dangerously combustible flowers."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliage.dmi'
	icon_state = "pyroflower1"
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/flora/roguegrass/reedbush
	name = "reed bush"
	desc = "Green, soft, and lively."
	icon = 'modular_redtard/rockhill/icons/obj/flora/ausflora.dmi'
	icon_state = "reedbush_1"
	layer = BELOW_OBJ_LAYER
	rockhill_variant = "reedbush_#"
	rockhill_variant_min = 1
	rockhill_variant_max = 4

/obj/structure/flora/roguegrass/swampweed
	name = "bunch of swampweed"
	desc = "a green root good for smoking."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliage.dmi'
	icon_state = "swampweed1"
	layer = ABOVE_ALL_MOB_LAYER
	rockhill_variant = "swampweed#"
	rockhill_variant_min = 1
	rockhill_variant_max = 3

/obj/structure/flora/roguegrass/thorn_bush
	name = "thorn bush"
	desc = "A thorny bush. Watch your step!"
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliage.dmi'
	icon_state = "thornbush"
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/flora/roguegrass/water
	name = "grass"
	desc = "This grass is sodden and muddy."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliage.dmi'
	icon_state = "swampgrass"
	layer = BELOW_OBJ_LAYER

/obj/structure/flora/roguegrass/water/reeds
	name = "reeds"
	desc = "This plant thrives in water, and shelters dangers."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliage.dmi'
	icon_state = "reeds"
	opacity = 1
	layer = 4.1

/obj/structure/flora/rogueshroom
	parent_type = /obj/structure/rockhill
	name = "mushroom"
	desc = "Mushrooms are the only happy beings in this land."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliagetall.dmi'
	icon_state = "mush1"
	density = 0
	opacity = 0
	pixel_x = -16
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/flora/rogueshroom/happy
	name = "underdark mushroom"
	desc = "Mushrooms might be the happiest beings in this god forsaken place."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliagetall.dmi'
	icon_state = "happymush1"
	density = 0
	opacity = 0
	pixel_x = -16
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/flora/rogueshroom/happy/random
	name = "underdark mushroom"
	desc = "Mushrooms might be the happiest beings in this god forsaken place."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliagetall.dmi'
	icon_state = "happymush1"
	density = 0
	opacity = 0
	pixel_x = -16
	layer = ABOVE_ALL_MOB_LAYER
	rockhill_variant = "happymush#"
	rockhill_variant_min = 1
	rockhill_variant_max = 5

/obj/structure/flora/rogueshroom/unhappy/angel
	name = "grieving angel"
	desc = "Each of these mushrooms is believed to have sprouted out of angel tears in the long past."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliagemushroom48x64.dmi'
	icon_state = "angelmush"
	density = 0
	opacity = 0
	pixel_x = -8
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/flora/rogueshroom/unhappy/metal
	name = "metallic mushroom"
	desc = "An incomprehensible metal mushroom. It has a strange sheen. It seems nigh indestructible, but stubbornness can fell anything."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliagemushroom60x64.dmi'
	icon_state = "metal"
	density = 0
	opacity = 0
	pixel_x = -14
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/flora/rogueshroom/unhappy/random
	name = "corpse fungus"
	desc = "This mushroom looks alive and thinking, giving you mush to think about."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliagemushroom48x64.dmi'
	icon_state = "scarymush"
	density = 0
	opacity = 0
	pixel_x = -8
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/flora/rogueshroom/unhappy/white
	name = "marrow-cap"
	desc = "You swear these mushrooms weren't so vile, it's as if Baotha herself lifted the veil."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliagemushroom48x64.dmi'
	icon_state = "scarymush1"
	density = 0
	opacity = 0
	pixel_x = -8
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/flora/roguetree
	parent_type = /obj/structure/rockhill
	name = "old tree"
	desc = "An old wicked tree that not even elves could love."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliagetall.dmi'
	icon_state = "t1"
	density = 1
	opacity = 1
	pixel_x = -16
	layer = 4.81
	alpha = 200
	rockhill_variant = "t#"
	rockhill_variant_min = 1
	rockhill_variant_max = 16

/obj/structure/flora/roguetree/burnt
	name = "burnt tree"
	desc = "Maybe lightning, maybe war, took the life of this once lively tree."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/96x96.dmi'
	icon_state = "t1"
	density = 1
	opacity = 1
	pixel_x = -32
	layer = 4.81
	alpha = 200
	rockhill_variant = "t#"
	rockhill_variant_min = 1
	rockhill_variant_max = 4

/obj/structure/flora/roguetree/evil
	name = "old tree"
	desc = "An old wicked tree that not even elves could love."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliagetall.dmi'
	icon_state = "t1"
	density = 1
	opacity = 1
	pixel_x = -16
	layer = 4.81
	alpha = 200
	rockhill_variant = "wv#"
	rockhill_variant_min = 1
	rockhill_variant_max = 2

/obj/structure/flora/roguetree/pine
	name = "pine tree"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/obj/flora/pines.dmi'
	icon_state = "pine1"
	density = 0
	opacity = 1
	pixel_x = -16
	layer = 4.81
	alpha = 200
	rockhill_variant = "pine#"
	rockhill_variant_min = 1
	rockhill_variant_max = 4

/obj/structure/flora/roguetree/pine/dead
	name = "burnt pine tree"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/obj/flora/pines.dmi'
	icon_state = "dead1"
	density = 0
	opacity = 1
	pixel_x = -16
	layer = 4.81
	alpha = 200
	rockhill_variant = "dead#"
	rockhill_variant_min = 1
	rockhill_variant_max = 3

/obj/structure/flora/roguetree/stump
	name = "tree stump"
	desc = "Someone cut this tree down."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliagetall.dmi'
	icon_state = "t1stump"
	density = 1
	opacity = 0
	pixel_x = -16
	layer = TABLE_LAYER
	alpha = 255
	rockhill_variant = "t#stump"
	rockhill_variant_min = 1
	rockhill_variant_max = 4

/obj/structure/flora/roguetree/stump/log
	name = "ancient log"
	desc = "The rotten remains of a tree that suffered nature's cruelty ages ago."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliagetall.dmi'
	icon_state = "log1"
	density = 1
	opacity = 0
	pixel_x = -16
	layer = TABLE_LAYER
	alpha = 255
	rockhill_variant = "log#"
	rockhill_variant_min = 1
	rockhill_variant_max = 2

/obj/structure/flora/roguetree/wise
	name = "sacred tree"
	desc = "A blessed primordial tree, ancient beyond years. Said to be the very embodiment of the Tree Father himself—whose presence alone imbues druids with wild energies."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliagetall.dmi'
	density = 1
	opacity = 1
	pixel_x = -16
	layer = 4.81
	alpha = 200
	icon_state = "mystical"

/obj/structure/flora/sakura
	parent_type = /obj/structure/rockhill
	name = "cherry blossom tree"
	desc = "A tree that has been introduced from the far east. A symbol of the transience of life. In the islands of Kazengun, it is strongly associated with both romance and death. On the mainland, it is known as a representation of brotherhood.\ "
	icon = 'modular_redtard/rockhill/icons/obj/structures/sakura_tree.dmi'
	icon_state = "sakura_tree"
	pixel_x = -60
	pixel_y = -10
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/flora/tinymushrooms
	parent_type = /obj/structure/rockhill
	name = "small mushroom cluster"
	desc = "A cluster of tiny mushrooms that are growing in a suspicious circle shape."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliage.dmi'
	icon_state = "tinymushrooms"
	layer = BELOW_OBJ_LAYER

/obj/structure/flora/tinymushrooms/unhappy
	name = "small mushroom cluster"
	desc = "A cluster of tiny mushrooms native to the underdark."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliage.dmi'
	icon_state = "tinymushroomsunhappy"
	layer = BELOW_OBJ_LAYER

/obj/structure/fluff/alch
	parent_type = /obj/structure/rockhill
	name = "alchemical lab"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "alch"
	density = TRUE
	opacity = 0
	layer = BELOW_OBJ_LAYER

/obj/structure/fluff/canopy
	parent_type = /obj/structure/rockhill
	name = "Canopy"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/modular_hearthstone/icons/obj/decor.dmi'
	icon_state = "canopy"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/canopy/booth/booth02
	name = "Canopy"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/modular_hearthstone/icons/obj/decor.dmi'
	icon_state = "canopyr-booth-2"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/canopy/green
	name = "Canopy"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/modular_hearthstone/icons/obj/decor.dmi'
	icon_state = "canopyg"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/canopy/side
	name = "Canopy"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/modular_hearthstone/icons/obj/decor.dmi'
	icon_state = "canopyb-side"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/canopy/side/end
	name = "Canopy"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/modular_hearthstone/icons/obj/decor.dmi'
	icon_state = "canopyb-side-end"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/clock
	parent_type = /obj/structure/rockhill
	name = "clock"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "clock"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/clodpile
	parent_type = /obj/structure/rockhill
	name = "dirt pile"
	desc = "A pile of dirt."
	icon = 'modular_redtard/rockhill/icons/roguetown/items/natural.dmi'
	icon_state = "clodpile"
	density = FALSE
	opacity = 0
	layer = BELOW_OBJ_LAYER
	rockhill_random_dir = TRUE

/obj/structure/fluff/customsign
	parent_type = /obj/structure/rockhill
	name = "sign"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "sign"
	density = FALSE
	opacity = 0
	pixel_y = 3
	layer = BELOW_OBJ_LAYER

/obj/structure/fluff/customsign/arrow
	name = "sign"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "shitsign"
	density = FALSE
	opacity = 0
	pixel_y = 3
	layer = BELOW_OBJ_LAYER

/obj/structure/fluff/grindwheel
	parent_type = /obj/structure/rockhill
	name = "grinding wheel"
	desc = "Steadily hums when operated, a massive wheel of grinding stone."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/forge.dmi'
	icon_state = "grindwheel"
	density = TRUE
	opacity = 0
	layer = BELOW_OBJ_LAYER

/obj/structure/fluff/headstake
	parent_type = /obj/structure/rockhill
	name = "head on a stake"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/items/natural.dmi'
	icon_state = "headstake"
	density = FALSE
	opacity = 0
	layer = BELOW_OBJ_LAYER

/obj/structure/fluff/iconsign/eaglesign
	name = "eagle sign"
	desc = "A sign with a heraldic eagle on it."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/signs.dmi'
	icon_state = "signeagle"
	density = FALSE
	opacity = 0
	layer = BELOW_OBJ_LAYER

/obj/structure/fluff/littlebanners
	parent_type = /obj/structure/rockhill
	name = "hanging little banners"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/modular_hearthstone/icons/obj/decor.dmi'
	icon_state = "hangingbanners_wr"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/littlebanners/bluewhite
	name = "hanging little banners"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/modular_hearthstone/icons/obj/decor.dmi'
	icon_state = "hangingbanners_bw"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/nest
	parent_type = /obj/structure/rockhill
	name = "nest"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "nest"
	density = FALSE
	opacity = 0
	layer = 2.8

/obj/structure/fluff/pillow/blue
	name = "pillows"
	desc = "Soft plush pillows. Resting your head on one is so relaxing."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "pillow"
	density = FALSE
	opacity = 0
	layer = BELOW_OBJ_LAYER

/obj/structure/fluff/pillow/brown
	name = "pillows"
	desc = "Soft plush pillows. Resting your head on one is so relaxing."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "pillow"
	density = FALSE
	opacity = 0
	layer = BELOW_OBJ_LAYER

/obj/structure/fluff/pillow/green
	name = "pillows"
	desc = "Soft plush pillows. Resting your head on one is so relaxing."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "pillow"
	density = FALSE
	opacity = 0
	layer = BELOW_OBJ_LAYER

/obj/structure/fluff/pillow/magenta
	name = "pillows"
	desc = "Soft plush pillows. Resting your head on one is so relaxing."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "pillow"
	density = FALSE
	opacity = 0
	layer = BELOW_OBJ_LAYER

/obj/structure/fluff/pillow/purple
	name = "pillows"
	desc = "Soft plush pillows. Resting your head on one is so relaxing."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "pillow"
	density = FALSE
	opacity = 0
	layer = BELOW_OBJ_LAYER

/obj/structure/fluff/pillow/red
	name = "pillows"
	desc = "Soft plush pillows. Resting your head on one is so relaxing."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "pillow"
	density = FALSE
	opacity = 0
	layer = BELOW_OBJ_LAYER

/obj/structure/fluff/psycross
	parent_type = /obj/structure/rockhill
	name = "pantheon cross"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "psycross"
	density = FALSE
	opacity = 0
	layer = BELOW_MOB_LAYER

/obj/structure/fluff/psycross/baotha
	name = "spider cross"
	desc = "A gnarled stone cross from which carved spider legs unfurl. You feel like you're being beckoned faintly, like a whisper in your ear."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "cross_baotha"
	density = FALSE
	opacity = 0
	layer = BELOW_MOB_LAYER

/obj/structure/fluff/psycross/copper
	name = "pantheon cross"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "psycrosschurch"
	density = FALSE
	opacity = 0
	layer = BELOW_MOB_LAYER

/obj/structure/fluff/psycross/crafted
	name = "wooden pantheon cross"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "psycrosscrafted"
	density = FALSE
	opacity = 0
	layer = BELOW_MOB_LAYER

/obj/structure/fluff/psycross/graggar
	name = "vicious cross"
	desc = "An unholy symbol wrought from stone. It promises glory to the conqueror and chains to the conquered."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "cross_graggar"
	density = FALSE
	opacity = 0
	layer = BELOW_MOB_LAYER

/obj/structure/fluff/psycross/psycrucifix/silver
	name = "silver psydonic crucifix"
	desc = "Constructed of Blessed Silver, this crucifix symbolises absolute faith in the ONE - For PSYDON WEEPS, for all mortal ilk. PSYDON WEEPS, for all who walk upon the soil. PSYDON WEEPS..."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "psycruci_s"
	density = FALSE
	opacity = 0
	layer = BELOW_MOB_LAYER

/obj/structure/fluff/psycross/psycrucifix/stone
	name = "stone psydonic crucifix"
	desc = "Formed of stone, this great Psycross symbolises that HE is forever ENDURING. Considered a rare sight upon the vale."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "psycruci_r"
	density = FALSE
	opacity = 0
	layer = BELOW_MOB_LAYER

/obj/structure/fluff/psycross/zizocross/golden
	name = "golden inverted cross"
	desc = "An unholy symbol meticilously plated with leaf gold. It stands in defiance to order. The dead will rise."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "cross_zizo_u"
	density = FALSE
	opacity = 0
	layer = BELOW_MOB_LAYER

/obj/structure/fluff/psycross/zizocross/stone
	name = "stone inverted cross"
	desc = "An unholy symbol, the knowledge that something so sturdy was able to be put up in reverence of the dark star, completely unattended... is a difficult anchovy to swallow for many."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "cross_zizo"
	density = FALSE
	opacity = 0
	layer = BELOW_MOB_LAYER

/obj/structure/fluff/railing/border
	parent_type = /obj/structure/rockhill
	name = "border"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/obj/railing.dmi'
	icon_state = "border"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/railing/border/east
	name = "border"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/obj/railing.dmi'
	icon_state = "border"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	dir = 4

/obj/structure/fluff/railing/border/north
	name = "border"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/obj/railing.dmi'
	icon_state = "border"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	dir = 1

/obj/structure/fluff/railing/border/west
	name = "border"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/obj/railing.dmi'
	icon_state = "border"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	dir = 8

/obj/structure/fluff/railing/corner
	parent_type = /obj/structure/rockhill
	name = "railing"
	desc = "A simple barrier of wood meant to prevent falls."
	icon = 'modular_redtard/rockhill/icons/obj/railing.dmi'
	icon_state = "border"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	dir = 9

/obj/structure/fluff/railing/corner/north_east
	name = "railing"
	desc = "A simple barrier of wood meant to prevent falls."
	icon = 'modular_redtard/rockhill/icons/obj/railing.dmi'
	icon_state = "border"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	dir = 5

/obj/structure/fluff/railing/corner/south_east
	name = "railing"
	desc = "A simple barrier of wood meant to prevent falls."
	icon = 'modular_redtard/rockhill/icons/obj/railing.dmi'
	icon_state = "border"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	dir = 6

/obj/structure/fluff/railing/corner/south_west
	name = "railing"
	desc = "A simple barrier of wood meant to prevent falls."
	icon = 'modular_redtard/rockhill/icons/obj/railing.dmi'
	icon_state = "border"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	dir = 10

/obj/structure/fluff/railing/fence
	parent_type = /obj/structure/rockhill
	name = "palisade"
	desc = "A rudimentary barrier that might keep the monsters at bay."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "fence"
	density = TRUE
	opacity = TRUE
	layer = 2.91

/obj/structure/fluff/railing/fence/flimsy
	name = "weak palisade"
	desc = "A rudimentary barrier that might keep the monsters at bay. This one looks old, weathered, and hastily constructed."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "fence"
	density = TRUE
	opacity = TRUE
	layer = 2.91
	color = "#cccac5"

/obj/structure/fluff/railing/wood
	parent_type = /obj/structure/rockhill
	name = "railing"
	desc = "A simple barrier of wood meant to prevent falls."
	icon = 'modular_redtard/rockhill/icons/obj/railing.dmi'
	icon_state = "woodrailing"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/railing/wood/east
	name = "railing"
	desc = "A simple barrier of wood meant to prevent falls."
	icon = 'modular_redtard/rockhill/icons/obj/railing.dmi'
	icon_state = "woodrailing"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	dir = 4

/obj/structure/fluff/railing/wood/north
	name = "railing"
	desc = "A simple barrier of wood meant to prevent falls."
	icon = 'modular_redtard/rockhill/icons/obj/railing.dmi'
	icon_state = "woodrailing"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	dir = 1

/obj/structure/fluff/railing/wood/west
	name = "railing"
	desc = "A simple barrier of wood meant to prevent falls."
	icon = 'modular_redtard/rockhill/icons/obj/railing.dmi'
	icon_state = "woodrailing"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER
	dir = 8

/obj/structure/fluff/signage
	parent_type = /obj/structure/rockhill
	name = "sign"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "shitsign"
	density = TRUE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue
	parent_type = /obj/structure/rockhill
	name = "angel statue"
	desc = "The angels of death are known to visit those whose time draws near, to offer them a less painful way to their final destination."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "bstatue"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/abyssor
	name = "abyssor statue"
	desc = "An ephemeral cerulean dream, carved by those who seek to understand unspoken truths."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallandwide.dmi'
	icon_state = "abyssor"
	density = FALSE
	opacity = 0
	pixel_x = -16
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/astrata
	name = "astrata statue"
	desc = "Astrata saw humanity as undisciplined for letting the world become so cruel and terrible, and became a radiant shepherd over the flock of mankind. The Church of the Sun believes that all mortals require guidance and protection from the terrors of the world."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallandwide.dmi'
	icon_state = "astrata"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/astrata/gold
	name = "decorated astrata statue"
	desc = "In the wild eyes of the carving you can see the fire that commands fear and respect, the light of daybreak that gives hope in an endless night, the scorching fury of templars that burns heretics and undead alike."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallandwide.dmi'
	icon_state = "astrata_bling"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/eora
	name = "eora statue"
	desc = "Despite the numerous misconceptions of drunken warriors; the Hearth Mother is not solely concerned with carnal love. To practice charity with the less fortunate and protect the vulnerable is love as well."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/statues/statue_eora.dmi'
	icon_state = "eora"
	density = FALSE
	opacity = 0
	pixel_x = -16
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/femalestatue
	name = "temptress statue"
	desc = "Artistic depiction of the mortal form, or an exploitation of mortal desire? One thing is known for sure, these statues are not often put up in charity houses or temples."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/ay.dmi'
	icon_state = "1"
	density = FALSE
	opacity = 0
	pixel_x = -32
	pixel_y = -16
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/femalestatue/zizo
	name = "zizo statue"
	desc = "With her mortal form destroyed and now chained in the underworld, she still whispers to her disciples, guiding them to act in her name and rebuild her powers."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/ay.dmi'
	icon_state = "4"
	density = FALSE
	opacity = 0
	pixel_x = -32
	pixel_y = -16
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/femalestatue1
	name = "queen alexia statue"
	desc = "A modest depiction of the Queen Alexia the Righteous, lacking her usual armors or finery, many were constructed as a show of her humility and piety by prisoners of the crown."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/ay.dmi'
	icon_state = "2"
	density = FALSE
	opacity = 0
	pixel_x = -32
	pixel_y = -16
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/femalestatue2
	name = "forest spirit statue"
	desc = "Dendor's Wild is protected by many a forest spirit more than glad to drown or throttle travelers who cut one too many trees, depictions of them are often made by his followers in his places as warnings of this for those who might forget the natural balance of things."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/ay.dmi'
	icon_state = "5"
	density = FALSE
	opacity = 0
	pixel_x = -32
	pixel_y = -16
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/gargoyle
	name = "gargoyle statue"
	desc = "Since before the first empires, ancient men would carve statues of horrific beasts to scare off angry and tormented spirits from their places of rest."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "gargoyle"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/gargoyle/candles
	name = "gargoyle statue"
	desc = "Since before the first empires, ancient men would carve statues of horrific beasts to scare off angry and tormented spirits from their places of rest."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "gargoyle_candles"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/gargoyle/moss
	name = "gargoyle statue"
	desc = "Since before the first empires, ancient men would carve statues of horrific beasts to scare off angry and tormented spirits from their places of rest."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "mgargoyle"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/gargoyle/moss/candles
	name = "gargoyle statue"
	desc = "Since before the first empires, ancient men would carve statues of horrific beasts to scare off angry and tormented spirits from their places of rest."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "mgargoyle_candles"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/knight
	name = "templar statue"
	desc = "This man stands staunch amongst the sands of time, a testament to his unending faith towards his divine masters. He will stand even when we are all dust."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "knightstatue_l"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/knight/interior
	name = "templar statue"
	desc = "This man stands staunch amongst the sands of time, a testament to his unending faith towards his divine masters. He will stand even when we are all dust."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "oknightstatue_l"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/knight/interior/r
	name = "templar statue"
	desc = "This man stands staunch amongst the sands of time, a testament to his unending faith towards his divine masters. He will stand even when we are all dust."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "oknightstatue_r"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/knight/r
	name = "templar statue"
	desc = "This man stands staunch amongst the sands of time, a testament to his unending faith towards his divine masters. He will stand even when we are all dust."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "knightstatue_r"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/knightalt
	name = "knight statue"
	desc = "Many men and women of the Otavan Orthodoxy died here to fight the Rot. It is tradition for the bones of their knights to be encased in these stone works."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "knightstatue2_l"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/knightalt/r
	name = "knight statue"
	desc = "Many men and women of the Otavan Orthodoxy died here to fight the Rot. It is tradition for the bones of their knights to be encased in these stone works."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "knightstatue2_r"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/noc
	name = "noc statue"
	desc = "This statue is a depiction of Noc the Wise who guides those who seek a greater understanding of the arcane sciences."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/statues/statue_noc.dmi'
	icon_state = "noc"
	density = FALSE
	opacity = 0
	pixel_x = -16
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/pillar
	name = "angel statue"
	desc = "The angels of death are known to visit those whose time draws near, to offer them a less painful way to their final destination."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "pillar"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/psy
	name = "psydon statue"
	desc = "The All-Father watched over Psydonia, once a paradise for his flourishing creations, without intervening upon the land. This would change one fateful day as the Arch-Enemy's ascension threatened mankind, narrowly stopped by Psydon. He wept for three daes and three nights after, and vanished from the realm."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/96x96.dmi'
	icon_state = "psy"
	density = FALSE
	opacity = 0
	pixel_x = -32
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/scare
	name = "scarecrow"
	desc = "Guardian of the harvest, and a harpy's worst nightmare."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "td"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/small
	name = "elven statue"
	desc = "Elves have long been seen as symbols of beauty and long life, and some believe statues of them will bring some luck, or at least make a place more bearable to look at."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "elfs"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/spider
	name = "idol of baotha"
	desc = "The temptress has been depicted in many forms, but a common shape is that of the spider, ensnaring the victims who call themselves her followers ever tighter in her web."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "spidercore"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/tdummy
	name = "practice dummy"
	desc = "A squire's best friend; take care it doesn't knock you on your arse."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "p_dummy"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/statue/valmora
	name = "saint valmora statue"
	desc = "A statue of Valmora the Sword-Saint, who led the dark elves in the city-state of Llurth Dreir to slaughter the cruel lords and priests of the Arch-Enemy and begin an exodus to the surface. The dark elves of Otava praise her as a redeemer and savior."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/statues/statue_zizo.dmi'
	icon_state = "zaelorian_crynsaris"
	density = FALSE
	opacity = 0
	pixel_x = -16
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/traveltile
	parent_type = /obj/structure/rockhill
	name = "travel"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	icon_state = "travel"
	density = FALSE
	opacity = 0
	layer = ABOVE_OPEN_TURF_LAYER

/obj/structure/fluff/traveltile/bandit
	name = "travel"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	icon_state = "travel"
	density = FALSE
	opacity = 0
	layer = ABOVE_OPEN_TURF_LAYER

/obj/structure/fluff/traveltile/bathhouse_passage
	name = "suspicious passage"
	desc = "A crevice in the wall. It looks like it leads somewhere."
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	icon_state = "travel"
	density = FALSE
	opacity = 0
	layer = ABOVE_OPEN_TURF_LAYER

/obj/structure/fluff/traveltile/bathhouse_passage/cave
	name = "suspicious passage"
	desc = "A crevice in the wall. It looks like it leads somewhere."
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	icon_state = "travel"
	density = FALSE
	opacity = 0
	layer = ABOVE_OPEN_TURF_LAYER

/obj/structure/fluff/traveltile/dungeoneer
	name = "travel"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	icon_state = "travel"
	density = FALSE
	opacity = 0
	layer = ABOVE_OPEN_TURF_LAYER

/obj/structure/fluff/traveltile/lich
	name = "travel"
	desc = "forboding, warping magick. Where could it possibly lead? Somewhere terrible, you must assume..."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "shitportal"
	density = FALSE
	opacity = 0
	layer = ABOVE_OPEN_TURF_LAYER
	color = "#fcff5e"

/obj/structure/fluff/traveltile/magicportal
	name = "mysterious portal"
	desc = "flickering, warping magick"
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "shitportal"
	density = FALSE
	opacity = 0
	layer = ABOVE_OPEN_TURF_LAYER

/obj/structure/fluff/traveltile/magicportal/unstable
	name = "unstable portal"
	desc = "flickering, warping magick. Where could it possibly lead?"
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "shitportal"
	density = FALSE
	opacity = 0
	layer = ABOVE_OPEN_TURF_LAYER
	color = "#ff0d00"

/obj/structure/fluff/traveltile/rockhillentrance
	name = "To Rockhill"
	desc = "Awake from this dream. The road to Rockhill awaits."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "underworldportal"
	density = FALSE
	opacity = 0
	layer = ABOVE_OPEN_TURF_LAYER

/obj/structure/fluff/traveltile/vampire
	name = "travel"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	icon_state = "travel"
	density = FALSE
	opacity = 0
	layer = ABOVE_OPEN_TURF_LAYER

/obj/structure/fluff/traveltile/wretch
	name = "travel"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	icon_state = "travel"
	density = FALSE
	opacity = 0
	layer = ABOVE_OPEN_TURF_LAYER

/obj/structure/fluff/wallclock
	parent_type = /obj/structure/rockhill
	name = "clock"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "wallclock"
	density = FALSE
	opacity = 0
	pixel_y = 32
	layer = BELOW_MOB_LAYER

/obj/structure/fluff/wallclock/l
	name = "clock"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "wallclock"
	density = FALSE
	opacity = 0
	pixel_x = -32
	pixel_y = 0
	layer = BELOW_MOB_LAYER

/obj/structure/fluff/wallclock/r
	name = "clock"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "wallclock"
	density = FALSE
	opacity = 0
	pixel_x = 32
	pixel_y = 0
	layer = BELOW_MOB_LAYER

/obj/structure/fluff/walldeco/alarm
	name = "le réveil murmure"
	desc = "This est un wall-mounted système d'alarme, designed dans les ."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "alarm"
	density = FALSE
	opacity = 0
	pixel_y = 32

/obj/structure/fluff/walldeco/artificerflag
	name = "artificer guild flag"
	desc = "Golden tools gleam against the blue of the oceans these craftsmen cross in their trade and works. The proud flag of the artificer guild, a collection of artisans and craftsmen who work together for shared profit and protection. In some cities their legal rights rival that of the petty nobility."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "artificer"
	density = FALSE
	opacity = 0

/obj/structure/fluff/walldeco/barbersignreverse
	name = "barber surgeon sign"
	desc = "The iconic swirl of the barber surgeon, where one can exchange coin for continued life."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "barbersignflip"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/bigpainting
	name = "midnight in the darkwood"
	desc = "Made by the traveling scholar Johann Grünwald in his travels across the continent, this painting depicts a moonlit night in the wilderness of Grenzelhoft. While there are many replicas of this painting, a few highly prized originals still exist."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/64x64.dmi'
	icon_state = "sherwoods"
	density = FALSE
	opacity = 0
	pixel_x = -16
	pixel_y = 32

/obj/structure/fluff/walldeco/bigpainting/lake
	name = "crimson lake lighthouse"
	desc = "Made by the traveling scholar Johann Grünwald in his travels across the lands, this painting depicts a peaceful moonlit lake in the Otavan countryside. A popular piece among the wealthy, even a good replica can fetch a fine price."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/64x64.dmi'
	icon_state = "lake"
	density = FALSE
	opacity = 0
	pixel_x = -16
	pixel_y = 32

/obj/structure/fluff/walldeco/bsmith
	name = "smithy sign"
	desc = "A small swinging anvil sign marks the smithy, where bloodied coin changes hands for hasty repairs and second hand weaponry."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "bsmith"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/chains
	name = "hanging chains"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "chains1"
	density = FALSE
	opacity = 0
	layer = 4.26
	alpha = 180
	rockhill_variant = "chains#"
	rockhill_variant_min = 1
	rockhill_variant_max = 8

/obj/structure/fluff/walldeco/church/line
	name = ""
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "churchslate"
	density = FALSE
	opacity = 0

/obj/structure/fluff/walldeco/customflag
	name = "Banner of Rotwood Vale"
	desc = "Prominently fluttering in the breeze you see the sturdy banner of the realm, the heraldry of the city lord's family. Many would be honored to wear these colors in loyal service to the crown."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "wallflag"
	density = FALSE
	opacity = 0

/obj/structure/fluff/walldeco/customflag/barony
	name = "Banner of the Lowtown Barony"
	desc = "Prominently fluttering in the breeze you see the sturdy banner of the barony, the heraldry of the local baron. Many would be honored to wear these colors in loyal service to lowtown."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "wallflag"
	density = FALSE
	opacity = 0

/obj/structure/fluff/walldeco/fakewall
	name = "Wall...?"
	desc = "It certainly looks like a wall..."
	icon = 'modular_redtard/rockhill/icons/turf/walls/stone_wall.dmi'
	icon_state = "stone"
	density = FALSE
	opacity = TRUE

/obj/structure/fluff/walldeco/flower
	name = "bathhouse sign"
	desc = "In a world of disease and violence a bathhouse is a rare spot of respite, where one can wash away exhausion and sin alike in warm, perfumed waters."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "flower"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/goblet
	name = "dining hall sign"
	desc = "A small swinging sign engraved with a goblet marks a common dining hall, it may lack the majesty of a city tavern, but it serves as a place to eat and rest in relative safety."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "goblet"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/innsign
	name = "tavern sign"
	desc = "Weathered wood marks a place of respite in a cold and unfeeling world, where one can numb themselves with stale company and yet more stale drink."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "bar"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/mageguild
	name = "Mage's Guild Banner"
	desc = "The white hot flame of a mage's light on a mage blue background, these banners mark the colleges and laboratories of the Mage's Guild."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "mageguild"
	density = FALSE
	opacity = 0

/obj/structure/fluff/walldeco/mageguild2
	name = "Mage's Guild Banner"
	desc = "The white hot flame of a mage's light on a black background, these banners mark the colleges and laboratories of the Mage's Guild."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "mageguild2"
	density = FALSE
	opacity = 0

/obj/structure/fluff/walldeco/maidendrape
	name = "black drape"
	desc = "A dark drape of fabric, a featureless decoration for those too cowardly to mark their heraldry."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "black_drape"
	density = FALSE
	opacity = 0
	pixel_y = 32

/obj/structure/fluff/walldeco/maidensigil
	name = "stone sigil"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "maidensigil"
	density = FALSE
	opacity = 0
	pixel_y = 32

/obj/structure/fluff/walldeco/med
	name = "frostbite diagram"
	desc = "Frostbite can cause severe burns and tissue damage if untreated, and while warming up can lessen the damage, existing frostbite must be treated. Slice open the patient and apply clamps to prevent bleedout, retract the incision, cut away the dead tissue with a scalpel, then clean the cut before removing your tools and closing up the wound."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "medposter"
	density = FALSE
	opacity = 0

/obj/structure/fluff/walldeco/med2
	name = "eye diagram"
	desc = "Eye surgery is a delicate procedure, requiring focus and skill. Ensure the patient is numbed from pain, then carefully cut at the eye, clamping and retracting for better access. Manipulate the eye with care to remove it, insert the replacement, slice to ensure a flow of healthy blood to the new eyes, then clean and close the site."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "medposter2"
	density = FALSE
	opacity = 0

/obj/structure/fluff/walldeco/med3
	name = "limb attachment diagram"
	desc = "When a limb is severed, it must be sutured immediately before bleedout occurs. Once the limb is applied to the stump, the arteries will be re-opened, and you must suture the limb. Use bone forceps to set the limb in place, then forceps to ensure the muscles won't separate once the patient begins to move. Suture to finish."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "medposter3"
	density = FALSE
	opacity = 0

/obj/structure/fluff/walldeco/med4
	name = "toxin diagram"
	desc = "Toxins can quickly travel through the blood and overwhelm the patient, so the use of leeches has become essential in modern medicine. Regular leeches will drain blood until they are fully engorged, harming the patient if ripped off early. Some students of medical science are gifted with the cheele, a helpful specialized leech which can switch between draining or infusing blood when its stomach is gently pressed on."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "medposter4"
	density = FALSE
	opacity = 0

/obj/structure/fluff/walldeco/med5
	name = "lux diagram"
	desc = "As the pump that moves blood through the body, lux naturally accumulates over the heart in layers. With careful practice, it can be scraped off the surface and collected for further use. This will leave the patient weakened, and they should rest properly after volunteering for lux donation."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "medposter5"
	density = FALSE
	opacity = 0

/obj/structure/fluff/walldeco/med6
	name = "revival diagram"
	desc = "When the new medical student is confused on how to revive a patient, there may be several causes for a failure to revitalize. Attempt to diagnose your patient if possible, as the issue may be ensanguination, significant bodily trauma, or even sustained oxygen deprivation damage. Rebalance their humors, tend bruises and burns, conduct CPR, and if all else fails ask your mentor for advice."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "medposter6"
	density = FALSE
	opacity = 0

/obj/structure/fluff/walldeco/mercenaryflag
	name = "mercenary guild banner"
	desc = "A rugged white banner stitched with a blood-red sparrow, the mark of the Mercenary Guild. A loose confederation of smaller mercenary companies and independent contractors, they can be trusted as far as you can spend your gold."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "sparrow"
	density = FALSE
	opacity = 0

/obj/structure/fluff/walldeco/mona
	name = "old painting"
	desc = "A painting of a woman, its frame is weathered and its paint peels from the canvas. Time has not treated this piece well, but it has a certain charm to it."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "mona"
	density = FALSE
	opacity = 0
	pixel_y = 32

/obj/structure/fluff/walldeco/moon
	name = "noccite banner"
	desc = "On a plate of silvered metal is draped a banner of deep purple, with the leering face of a crescent moon in its center; the heraldry of Noc has an expression of deep concentration, meant to inspire insight in his acolytes."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "moon"
	density = FALSE
	opacity = 0

/obj/structure/fluff/walldeco/painting
	name = "vague painting"
	desc = "The artist is unknown. The subject is unknown. Maybe a memorial to a corpse that was trampled on the trail to this reality."
	icon = 'modular_redtard/rockhill/icons/roguetown/items/misc.dmi'
	icon_state = "painting_deployed"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/painting/queen
	name = "queen alexia painting"
	desc = "It's Queen Alexia I 'the Righteous' Valmont of Ferentia. Twenty years ago she rebelled against her father, King Mattimeo, and had him burned on a cross for heresy after he was seduced by a Baothan succubus."
	icon = 'modular_redtard/rockhill/icons/roguetown/items/misc.dmi'
	icon_state = "queenpainting_deployed"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/painting/seraphina
	name = "holy priest seraphina painting"
	desc = "The holy priest Seraphina, first leader of the Sun Cult of Astrata, who unified the ten sects of the gods after the disappearance of PSYDON. Seen as the great unifier of faith as the Age of Rot began a thousand years past."
	icon = 'modular_redtard/rockhill/icons/roguetown/items/misc.dmi'
	icon_state = "seraphinapainting_deployed"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/painting/skull
	name = "morbid painting"
	desc = "A painting of a candelabra and human skull on a covered table, it is a modestly grim yet tasteful piece of art. Memento mori."
	icon = 'modular_redtard/rockhill/icons/roguetown/items/misc.dmi'
	icon_state = "skullpainting_deployed"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/psybanner
	name = "sun cult banner"
	desc = "Fine silk dyed in deep purple with golden thread in its trim, this banner is the mark of the Sun Cult. Wherever the rays of Astrata touch the world, there may be found her followers, who claim authority over all sects and temples."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "Psybanner-PURPLE"
	density = FALSE
	opacity = 0

/obj/structure/fluff/walldeco/psybanner/red
	name = "otavan orthodoxy banner"
	desc = "Rich red silk trimmed with silver thread marks the banner of the Otavan Orthodoxy, the church of the Creator-God PSYDON which dominates the nation of Otava and sends its Inquisition abroad to root out heresy in its neighbors."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "Psybanner-RED"
	density = FALSE
	opacity = 0

/obj/structure/fluff/walldeco/rpainting
	name = "morbid painting"
	desc = "A painting of a candelabra and human skull on a covered table, it is a modestly grim yet tasteful piece of art."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "painting_1"
	density = FALSE
	opacity = 0

/obj/structure/fluff/walldeco/rpainting/crown
	name = "crown painting"
	desc = "A painting of a noble crown atop a book with an apple to its side, it is a simple yet elegant piece on the elements of any good ruler's life."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "painting_3"
	density = FALSE
	opacity = 0

/obj/structure/fluff/walldeco/rpainting/forest
	name = "forest painting"
	desc = "A painting of a forest and distant castle shrouded in fog, it gives a feeling of mystery as the mind fills in the details."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "painting_2"
	density = FALSE
	opacity = 0

/obj/structure/fluff/walldeco/sign/merchantsign
	name = "merchant guild sign"
	desc = "A sign advertising the services of the Merchant Guild, a widespread alliance of merchants across the world. Here you can hope to earn enough from your spoils to at least break even, if not afford a meal."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "shopsign_merchant_right"
	density = FALSE
	opacity = 0
	pixel_y = 16

/obj/structure/fluff/walldeco/steward
	name = "steward sign"
	desc = "Polished wood and leaf gold marks the office of the steward, manager of the city lord's estate and treasury."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "steward"
	density = FALSE
	opacity = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/stone
	name = ""
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "walldec1"
	density = FALSE
	opacity = 0
	rockhill_variant = "walldec#"
	rockhill_variant_min = 1
	rockhill_variant_max = 6

/obj/structure/fluff/walldeco/stone/bronze
	name = ""
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "walldec1"
	density = FALSE
	opacity = 0
	color = "#ff9c1a"
	rockhill_variant = "walldec#"
	rockhill_variant_min = 1
	rockhill_variant_max = 6

/obj/structure/fluff/walldeco/vinez
	name = "vines"
	desc = "Nature begins to retake this place, slowly but surely."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "vinez"
	density = FALSE
	opacity = 0

/obj/structure/fluff/walldeco/vinez/blue
	name = "vines"
	desc = "Nature begins to retake this place, slowly but surely."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "vinez_blue"
	density = FALSE
	opacity = 0

/obj/structure/fluff/walldeco/vinez/red
	name = "vines"
	desc = "Nature begins to retake this place, slowly but surely."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "vinez_red"
	density = FALSE
	opacity = 0

/obj/structure/fluff/walldeco/wallshield
	name = "old wall shield"
	desc = "An old shield mounted on the wall, its heraldry damaged and faded by time. No longer able to serve its purpose in combat, its function is now decorative."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "wallshield"
	density = FALSE
	opacity = 0

/obj/structure/fluff/walldeco/wantedposter
	name = "bandit notice"
	desc = "A place for posters displaying the faces of roving bandits. Let's see if there are any this week..."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "wanted1"
	density = FALSE
	opacity = 0
	pixel_y = 32
	layer = BELOW_MOB_LAYER
	rockhill_variant = "wanted#"
	rockhill_variant_min = 1
	rockhill_variant_max = 3
	rockhill_random_dir = TRUE

/obj/structure/fluff/walldeco/wantedposter/l
	name = "bandit notice"
	desc = "A place for posters displaying the faces of roving bandits. Let's see if there are any this week..."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/decoration.dmi'
	icon_state = "wanted1"
	density = FALSE
	opacity = 0
	pixel_x = -32
	pixel_y = 0
	layer = BELOW_MOB_LAYER
	rockhill_variant = "wanted#"
	rockhill_variant_min = 1
	rockhill_variant_max = 3
	rockhill_random_dir = TRUE

/obj/structure/gate
	parent_type = /obj/structure/rockhill
	name = "gate"
	desc = "A strong steel gate."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/gate.dmi'
	icon_state = "gate1"
	density = TRUE
	opacity = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/gate/bars
	name = "gate"
	desc = "A strong steel gate."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/gate.dmi'
	icon_state = "bar1"
	density = TRUE
	opacity = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/gate/bars/preopen
	name = "gate"
	desc = "A strong steel gate."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/gate.dmi'
	icon_state = "bar0"
	density = TRUE
	opacity = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/giantfur
	parent_type = /obj/structure/rockhill
	name = "giant fur"
	desc = "Pelt of some gigantic animal, made into a mat."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/96x96.dmi'
	icon_state = "fur"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/giantfur/small
	name = "fur pelt"
	desc = "Pelt of a young animal, made into a mat."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/96x96.dmi'
	icon_state = "fur_alt"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/globe
	parent_type = /obj/structure/rockhill
	name = "globe"
	desc = "A mysterious globe representing the world."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "globe"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/gravemarker
	parent_type = /obj/structure/rockhill
	name = "grave marker"
	desc = "A simple marker honouring the departed.."
	icon = 'modular_redtard/rockhill/icons/turf/roguefloor.dmi'
	icon_state = "gravemarker1"
	density = FALSE
	layer = 2.91

/obj/structure/handcart
	parent_type = /obj/structure/rockhill
	name = "cart"
	desc = "A wooden cart that will help you carry many things."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "cart-empty"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/hotspring
	parent_type = /obj/structure/rockhill
	name = "hot spring"
	icon = 'modular_redtard/rockhill/icons/obj/structures/hotspring.dmi'
	icon_state = "hotspring"
	layer = BELOW_OBJ_LAYER

/obj/structure/hotspring/border
	name = "hot spring"
	icon = 'modular_redtard/rockhill/icons/obj/structures/hotspring.dmi'
	icon_state = "hotspring_border_1"
	layer = BELOW_OBJ_LAYER

/obj/structure/hotspring/border/eight
	name = "hot spring"
	icon = 'modular_redtard/rockhill/icons/obj/structures/hotspring.dmi'
	icon_state = "hotspring_border_8"
	layer = BELOW_OBJ_LAYER

/obj/structure/hotspring/border/eleven
	name = "hot spring"
	icon = 'modular_redtard/rockhill/icons/obj/structures/hotspring.dmi'
	icon_state = "hotspring_border_11"
	layer = BELOW_OBJ_LAYER

/obj/structure/hotspring/border/five
	name = "hot spring"
	icon = 'modular_redtard/rockhill/icons/obj/structures/hotspring.dmi'
	icon_state = "hotspring_border_5"
	layer = BELOW_OBJ_LAYER

/obj/structure/hotspring/border/four
	name = "hot spring"
	icon = 'modular_redtard/rockhill/icons/obj/structures/hotspring.dmi'
	icon_state = "hotspring_border_4"
	layer = BELOW_OBJ_LAYER

/obj/structure/hotspring/border/nine
	name = "hot spring"
	icon = 'modular_redtard/rockhill/icons/obj/structures/hotspring.dmi'
	icon_state = "hotspring_border_9"
	layer = BELOW_OBJ_LAYER

/obj/structure/hotspring/border/seven
	name = "hot spring"
	icon = 'modular_redtard/rockhill/icons/obj/structures/hotspring.dmi'
	icon_state = "hotspring_border_7"
	layer = BELOW_OBJ_LAYER

/obj/structure/hotspring/border/six
	name = "hot spring"
	icon = 'modular_redtard/rockhill/icons/obj/structures/hotspring.dmi'
	icon_state = "hotspring_border_6"
	layer = BELOW_OBJ_LAYER

/obj/structure/hotspring/border/ten
	name = "hot spring"
	icon = 'modular_redtard/rockhill/icons/obj/structures/hotspring.dmi'
	icon_state = "hotspring_border_10"
	layer = BELOW_OBJ_LAYER

/obj/structure/hotspring/border/thirteen
	name = "hot spring"
	icon = 'modular_redtard/rockhill/icons/obj/structures/hotspring.dmi'
	icon_state = "hotspring_border_13"
	layer = BELOW_OBJ_LAYER

/obj/structure/hotspring/border/three
	name = "hot spring"
	icon = 'modular_redtard/rockhill/icons/obj/structures/hotspring.dmi'
	icon_state = "hotspring_border_3"
	layer = BELOW_OBJ_LAYER

/obj/structure/hotspring/border/twelve
	name = "hot spring"
	icon = 'modular_redtard/rockhill/icons/obj/structures/hotspring.dmi'
	icon_state = "hotspring_border_12"
	layer = BELOW_OBJ_LAYER

/obj/structure/hotspring/border/two
	name = "hot spring"
	icon = 'modular_redtard/rockhill/icons/obj/structures/hotspring.dmi'
	icon_state = "hotspring_border_2"
	layer = BELOW_OBJ_LAYER

/obj/structure/kybraxor
	parent_type = /obj/structure/rockhill
	name = "Kybraxor the Devourer"
	desc = "The mad duke's hungriest pet."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/96x96.dmi'
	icon_state = "kybraxor1"
	density = FALSE
	layer = ABOVE_OPEN_TURF_LAYER

/obj/structure/lever
	parent_type = /obj/structure/rockhill
	name = "lever"
	desc = "I want to pull it."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "leverfloor0"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/lever/wall
	name = "lever"
	desc = "I want to pull it."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "leverwall0"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/leyline
	parent_type = /obj/structure/rockhill
	name = "inactive leyline"
	desc = "A curious arrangement of stones."
	icon = 'modular_redtard/rockhill/icons/effects/effects.dmi'
	icon_state = "inactiveleyline"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/manaflower
	parent_type = /obj/structure/rockhill
	name = "manaflower"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/crops.dmi'
	icon_state = "manabloom2"
	density = FALSE
	layer = BELOW_MOB_LAYER
	color = null

/obj/structure/mannequin/male
	parent_type = /obj/structure/rockhill
	name = "mannequin"
	desc = "It's unnvervingly still..."
	icon = 'modular_redtard/rockhill/icons/obj/mannequin.dmi'
	icon_state = "man"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/mannequin/male/female
	name = "mannequin"
	desc = "It's unnvervingly still..."
	icon = 'modular_redtard/rockhill/icons/obj/mannequin.dmi'
	icon_state = "woman"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/meathook
	parent_type = /obj/structure/rockhill
	name = "meathook"
	desc = "A hook used to secure livestock for butchering."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "meathook"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/mirror/fancy
	parent_type = /obj/structure/rockhill
	name = "mirror"
	desc = "Mirror, mirror, on the wall..."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "fancymirror"
	density = FALSE
	pixel_y = 32
	layer = BELOW_OBJ_LAYER

/obj/structure/noose
	parent_type = /obj/structure/rockhill
	name = "noose"
	desc = "Abandon all hope."
	icon = 'modular_redtard/rockhill/icons/modular/icons/obj/gallows.dmi'
	icon_state = "noose"
	density = FALSE
	pixel_y = 10
	layer = ABOVE_MOB_LAYER

/obj/structure/noose/gallows
	name = "gallows"
	desc = "Stranded and hanging, limp and dead."
	icon = 'modular_redtard/rockhill/icons/modular/icons/obj/gallows.dmi'
	icon_state = "gallows"
	density = FALSE
	pixel_y = 0
	layer = ABOVE_MOB_LAYER

/obj/structure/pillory
	parent_type = /obj/structure/rockhill
	name = "pillory"
	desc = "To keep the criminals locked!"
	icon = 'modular_redtard/rockhill/icons/modular/icons/obj/pillory.dmi'
	icon_state = "pillory_single"
	density = TRUE
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/pillory/double
	name = "pillory"
	desc = "To keep the criminals locked!"
	icon = 'modular_redtard/rockhill/icons/modular/icons/obj/pillory.dmi'
	icon_state = "pillory_double"
	density = TRUE
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/pillory/reinforced
	name = "pillory"
	desc = "To keep the criminals locked!"
	icon = 'modular_redtard/rockhill/icons/modular/icons/obj/pillory.dmi'
	icon_state = "pillory_reinforced"
	density = TRUE
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/plough
	parent_type = /obj/structure/rockhill
	name = "plough"
	desc = "A wooden plough with iron blades to till the earth for crops."
	icon = 'modular_redtard/rockhill/icons/obj/structures/plough.dmi'
	icon_state = "plough"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/ritualcircle/abyssor
	name = "Rune of Storm"
	desc = "A Holy Rune of Abyssor. You sense your mind getting pulled into the drawn spiral."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/rituals.dmi'
	icon_state = "abyssor_chalky"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/ritualcircle/abyssor_alt
	name = "Rune of Stirring"
	desc = "A Holy Rune of Abyssor. This one seems different to the rest. Something observes."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/rituals.dmi'
	icon_state = "abyssoralt_active"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/ritualcircle/noc
	name = "Rune of the Moon"
	desc = "A Holy Rune of Noc. Moonlight shines upon thee."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/rituals.dmi'
	icon_state = "noc_chalky"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/ritualcircle/zizo
	name = "Rune of Ambition"
	desc = "A Holy Rune of ZIZO. Ambition at any cost."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/rituals.dmi'
	icon_state = "zizo_chalky"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/rogue/trophy/deer
	name = "deer trophy"
	desc = "A deer's head, stuffed and mounted for the wall. A skilled hunter must have slain this creature."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "deer_trophy"
	pixel_y = 32
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/atm
	name = "nervelock"
	desc = "Stores and withdraws currency for accounts managed by the Grand Duchy of the realm."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "atm"
	density = FALSE
	pixel_y = 32
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/bathvend
	name = "BRASSFACE"
	desc = "Sweet, sweet, addiction. Love in the veins, comfort in my heart."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "brassface"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/blackmarket
	name = "COPPERFACE"
	desc = "Never gets tired, does not ask questions, only minor signs of tampering. Alas, fashioned with copper of low quality."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "copperface"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/bounty
	name = "EXCIDIUM"
	desc = "Created by a fanatical sect of devout followers of Ravox, this machine sets bounties."
	icon = 'modular_redtard/rockhill/icons/roguetown/topadd/statue1.dmi'
	icon_state = "baldguy"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/camera
	name = "eerie face"
	desc = "these eerie trinkets dangle from awnings, etched into the shape of a leering face. Hung above protected areas, to give interlopers a forboding sense of Being Watched..."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "camera-mid"
	density = FALSE
	pixel_y = 10
	layer = ABOVE_MOB_LAYER

/obj/structure/roguemachine/chimeric_heart_beast
	icon = 'modular_redtard/rockhill/icons/obj/structures/heart_beast.dmi'
	icon_state = "heart_beast"
	pixel_x = -32
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/contractledger
	name = "Grand Contract Ledger"
	desc = "A massive ledger book with gilded edges, sitting atop a pedestal with the Mercenary's Guild banner. Its myriad enchanted pages are filled with various contracts and bounties issued by Mercenary's Guild, with arcane scripts that appears and fades as contracts are issued and completed."
	icon = 'modular_redtard/rockhill/icons/code/modules/roguetown/roguemachine/questing/questing.dmi'
	icon_state = "contractledger"
	density = TRUE

/obj/structure/roguemachine/crier
	name = "rous master"
	desc = "The crier's most trusted friend."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "crier_machine"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/drugmachine
	name = "PURITY"
	desc = "You want to destroy your life."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "purity"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/escrow
	name = "COMMISSIONER"
	desc = "A brass-plated contraption with a coin slot above and an iron strongbox beneath. The guild posts and fulfills smithing or engineering work here, coin held in escrow until the job is done."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/escrow/tailor
	name = "TAILORING COMMISSIONER"
	desc = "A brass-plated commission board for the weavers' and tailors' guild. Coin held in escrow until the work is delivered."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/goldface
	name = "GOLDFACE"
	desc = "Gilded tombs do worms enfold."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/goldface/public
	name = "SILVERFACE"
	desc = "Gilded tombs do worms enfold."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/goldface/public/apothecary
	name = "Apothecary's SILVERFACE"
	desc = "Gilded tombs do worms enfold."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/goldface/public/smith
	name = "Smithy's SILVERFACE"
	desc = "Gilded tombs do worms enfold."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/goldface/public/tailor
	name = "Tailor's SILVERFACE"
	desc = "Gilded tombs do worms enfold."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/headeater
	name = "HEADEATER"
	desc = "A machine that indulges in humenity's oldest profession; killing. The heads of Dendor's creechers, goblins, and brigands go in, and the bounty is credited directly to the bearer's account - less the Crown's Headeater Levy, of course."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "headeater"
	density = FALSE
	pixel_y = 32
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/headeater/treasureseeker
	name = "TREASURE SEEKER"
	desc = "A kin of the HEADEATER, its brass gullet re-tuned by the Bathhouse for gentler appetites. Feed it any trinket and the prize is whisked away to the Nightmistress's vault - where the hoard remembers its worth. Its jaws open only for the Bathhouse's own."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "headeater"
	density = FALSE
	pixel_y = 32
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/lottery_roguetown
	name = "XYLIX'S FORTUNE"
	desc = "An infinite, yawning hole that makes or breaks men. Come and play!"
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "lottery"
	density = FALSE
	pixel_y = 32
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/mail
	name = "HERMES"
	desc = "Carrier zads have fallen severely out of fashion ever since the advent of this hydropneumatic mail system. A coin slot activates the mechanism for dispensing parchment(a zenny) and quills(a ziliqua)."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "mail"
	density = FALSE
	pixel_y = 32
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/mail/l
	name = "HERMES"
	desc = "Carrier zads have fallen severely out of fashion ever since the advent of this hydropneumatic mail system. A coin slot activates the mechanism for dispensing parchment(a zenny) and quills(a ziliqua)."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "mail"
	density = FALSE
	pixel_x = -32
	pixel_y = 0
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/mail/r
	name = "HERMES"
	desc = "Carrier zads have fallen severely out of fashion ever since the advent of this hydropneumatic mail system. A coin slot activates the mechanism for dispensing parchment(a zenny) and quills(a ziliqua)."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "mail"
	density = FALSE
	pixel_x = 32
	pixel_y = 0
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/musicbox
	name = "wax music device"
	desc = "A marvelous device invented to record sermons. Aleksandar Gemrald Sparks invented this machine to discover prophecies of Psydon's return but failed. It now brings us strange music from another realm."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "music0"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/musicbox/tavern
	name = "wax music device"
	desc = "A marvelous device invented to record sermons. Aleksandar Gemrald Sparks invented this machine to discover prophecies of Psydon's return but failed. It now brings us strange music from another realm."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "music0"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/noticeboard
	name = "Notice Board"
	desc = "A large wooden notice board, carrying postings from all across Rotwood Vale. A ZAD perch sits atop it."
	icon = 'modular_redtard/rockhill/icons/roguetown/structure/noticeboard64.dmi'
	icon_state = "noticeboard0"
	density = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/roguemachine/noticeboard/wall
	name = "Notice Board"
	desc = "A large wooden notice board, carrying postings from all across Rotwood Vale. A ZAD perch sits atop it."
	icon = 'modular_redtard/rockhill/icons/roguetown/structure/noticeboard32.dmi'
	icon_state = "noticeboard0"
	density = FALSE
	pixel_y = 32
	layer = ABOVE_MOB_LAYER

/obj/structure/roguemachine/potionseller
	name = "POTION SELLER"
	desc = "The stomach of this thing can been stuffed with fluids for you to buy."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/rosewall
	name = "The Rosewall"
	desc = "A rosewood board scented with bath-oils, hung with perfumed slips of parchment. The bathhouse's workers pin their offerings here for any passerby to peruse."
	icon = 'modular_redtard/rockhill/icons/roguetown/structure/noticeboard32.dmi'
	icon_state = "noticeboardbh0"
	density = FALSE
	pixel_y = 32
	layer = ABOVE_MOB_LAYER

/obj/structure/roguemachine/scomm
	name = "SCOM"
	desc = "The Supernatural Communication Optical Machine is a wonder of magic and technology, able to transmit and receive messages across long distance. There's a button in the MIDDLE for making private jabberline connections."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "scomm1"
	density = FALSE
	pixel_y = 32
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/scomm/l
	name = "SCOM"
	desc = "The Supernatural Communication Optical Machine is a wonder of magic and technology, able to transmit and receive messages across long distance. There's a button in the MIDDLE for making private jabberline connections."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "scomm1"
	density = FALSE
	pixel_x = -32
	pixel_y = 0
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/scomm/r
	name = "SCOM"
	desc = "The Supernatural Communication Optical Machine is a wonder of magic and technology, able to transmit and receive messages across long distance. There's a button in the MIDDLE for making private jabberline connections."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "scomm1"
	density = FALSE
	pixel_x = 32
	pixel_y = 0
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/scomm/receive_only
	name = "RCOM"
	desc = "The Receiving Communication Optical Machine is a much cheaper, ubiquitous version of the SCOM, designed only to receive message over long distance. They are oft found outside of the town, especially in older ruins."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "scomm1"
	density = FALSE
	pixel_y = 32
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/scomm/receive_only/l
	name = "RCOM"
	desc = "The Receiving Communication Optical Machine is a much cheaper, ubiquitous version of the SCOM, designed only to receive message over long distance. They are oft found outside of the town, especially in older ruins."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "scomm1"
	density = FALSE
	pixel_x = -32
	pixel_y = 0
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/scomm/receive_only/r
	name = "RCOM"
	desc = "The Receiving Communication Optical Machine is a much cheaper, ubiquitous version of the SCOM, designed only to receive message over long distance. They are oft found outside of the town, especially in older ruins."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "scomm1"
	density = FALSE
	pixel_x = 32
	pixel_y = 0
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/scrapper/smith
	name = "smith's scrapper"
	desc = "A brass-trimmed contraption with a hopper above and an iron strongbox beneath. Takes whatever a smith can smelt back into ingots."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/scrapper/tailor
	name = "rag-picker"
	desc = "A brass-trimmed contraption with a hopper above and an iron strongbox beneath. Takes whatever a tailor can rework into fabrics."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/ship_fulfillment
	name = "ship fulfillment crate"
	desc = "A wide crate stamped with the seal of the Ferentian Trading Company. Goods deposited here are accepted against the demands of foreign vessels in port - the depositor is paid in mammon to their account, less the Crown's export duty and the Merchant's middleman cut."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/steward
	name = "nerve master"
	desc = "The stewards most trusted friend."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "steward_machine"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/steward_export
	name = "steward's export machine"
	desc = "A machine near where Crown-hired clerks tally exports. Wares left within reach of this machine are counted toward Crown standing orders."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "ballooner"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/stockpile
	name = "stockpile"
	desc = "A magitech device connected to the trade network. Users can buy basic goods, crafting materials, and food for a price from these units, or sell them here for money."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "stockpile_vendor"
	density = FALSE
	pixel_y = 32
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/talkstatue/mercenary
	name = "mercenary statue"
	desc = "A gilbronze warrior erupts from the stone bell that homes them; foreign garb, horns of stone, claws of deathly metals. The perfect central-point of a proud warrior extrinsic to this place and tyme."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/economy_machines.dmi'
	icon_state = "mercstatue"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/titan
	name = "throat"
	desc = "He who wears the crown holds the key to this strange thing. If all else fails, demand the \"secrets of the throat!\""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = ""
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/vaultbank
	name = "\improper JAWBANK"
	desc = "Collects and secures the treasury of the Grand Duchy of the realm."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "jawbank"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/vaultbank/bathhouse
	name = "\improper BATHHOUSE JAWBANK"
	desc = "A biomechanical obelisk that secures the takings of the Bathhouse. Throttle it with a strike to spill that which is rightfully yours."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "jawbank"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/vaultbank/church
	name = "\improper CHURCH JAWBANK"
	desc = "A biomechanical obelisk that holds the alms and tithe of the Church's faithful. Throttle it with a strike to spill that which is rightfully yours."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "jawbank"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/vaultbank/innkeeper
	name = "\improper TAVERN JAWBANK"
	desc = "A biomechanical obelisk that hoards the tavern's takings. Throttle it with a strike to spill that which is rightfully yours."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "jawbank"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/vaultbank/merchant
	name = "\improper MERCHANT JAWBANK"
	desc = "A biomechanical obelisk that secures the coffers of the Ferentian Trading Company. Throttle it with a strike to spill that which is rightfully yours."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "jawbank"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/vendor
	name = "PEDDLER"
	desc = "The stomach of this thing can been stuffed with fun things for you to buy."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/vendor/bathhouse
	name = "PEDDLER"
	desc = "The stomach of this thing can been stuffed with fun things for you to buy."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/vendor/bathhouse/locker
	name = "PEDDLER"
	desc = "The stomach of this thing can been stuffed with fun things for you to buy."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/vendor/innrockhill
	name = "PEDDLER"
	desc = "The stomach of this thing can been stuffed with fun things for you to buy."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/withdraw
	name = "vomitorium"
	desc = "A magitech wall device connected to the local trade network. Users can buy basic goods, crafting materials, and food for a price from these units, either from in-town or imported for a heftier price."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/machines.dmi'
	icon_state = "submit"
	density = FALSE
	pixel_y = 32
	layer = BELOW_OBJ_LAYER

/obj/structure/roguerock
	parent_type = /obj/structure/rockhill
	name = "rock"
	desc = "A rock protuding from the ground."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/foliage.dmi'
	icon_state = "rock1"
	density = TRUE
	opacity = 0
	layer = TABLE_LAYER
	alpha = 255
	rockhill_variant = "rock#"
	rockhill_variant_min = 1
	rockhill_variant_max = 4

/obj/structure/roguetent
	parent_type = /obj/structure/rockhill
	name = "tent flap"
	icon = 'modular_redtard/rockhill/icons/turf/roguewall.dmi'
	icon_state = "tent_door1"
	density = TRUE
	opacity = TRUE
	layer = WALL_OBJ_LAYER

/obj/structure/roguethrone
	parent_type = /obj/structure/rockhill
	name = "throne of The Realm"
	desc = "A big throne, to hold the Lord's giant personality. Say 'secrets of the throat' with the crown on your head if you are confused."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/96x96.dmi'
	icon_state = "throne"
	density = FALSE
	pixel_x = -32
	layer = BELOW_OBJ_LAYER

/obj/structure/shisha/hookah
	name = "shisha pipe"
	desc = "A traditional shisha pipe."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "hookah"
	density = FALSE
	layer = ABOVE_MOB_LAYER

/obj/structure/spider/stickyweb/solo
	parent_type = /obj/structure/rockhill
	name = "web"
	icon = 'modular_redtard/rockhill/icons/modular/Mapping/icons/webbing.dmi'
	icon_state = "stickyweb3"
	opacity = TRUE
	layer = BELOW_OBJ_LAYER
	alpha = 109
	rockhill_random_dir = TRUE

/obj/structure/standingbell
	parent_type = /obj/structure/rockhill
	name = "service bell"
	desc = "A small mana-infused bell that carries its chime across the city to a select few ears. Use this to call for service."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "standingbell"
	density = FALSE
	layer = BELOW_OBJ_LAYER

/obj/structure/stationary_bell
	parent_type = /obj/structure/rockhill
	name = "church bell"
	desc = "A large bell that rings out for all to hear."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/96x96.dmi'
	icon_state = "churchbell"
	density = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/stone_rack
	parent_type = /obj/structure/rockhill
	name = "Aspect rack"
	desc = "A specialized holder designed to securely hold chimeric aspect canisters. The crystal reinforces the creature's personality, increases it's thinking capacity. The brighter the red glow of the crystal, the better the aspects match the creature."
	icon = 'modular_redtard/rockhill/icons/obj/structures/heart_rack.dmi'
	icon_state = "rack"
	pixel_y = 32
	layer = BELOW_OBJ_LAYER

/obj/structure/telescope
	parent_type = /obj/structure/rockhill
	name = "telescope"
	desc = "A mysterious telescope pointing towards the stars."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "telescope"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/underworld/barrier
	name = "DONT STAND HERE"
	desc = "The Undermaiden awaits."
	icon = 'modular_redtard/rockhill/icons/roguetown/underworld/underworld.dmi'
	icon_state = "spiritpart"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/underworld/carriage_normal
	name = "Carriage"
	desc = "The vale awaits."
	icon = 'modular_redtard/rockhill/icons/roguetown/underworld/enigma_carriage.dmi'
	icon_state = "carriage_normal"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/vine
	parent_type = /obj/structure/rockhill
	name = "weepvine"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/effects/spacevines.dmi'
	icon_state = "Light1"
	density = FALSE
	layer = SPACEVINE_LAYER
	rockhill_variant = "Light#"
	rockhill_variant_min = 1
	rockhill_variant_max = 2
	rockhill_random_dir = TRUE

/obj/structure/voidstoneobelisk
	parent_type = /obj/structure/rockhill
	name = "Voidstone Obelisk"
	desc = "A smooth unnatural Obelisk, looking at it provides the sense of unease."
	icon = 'modular_redtard/rockhill/icons/mob/summonable/32x32.dmi'
	icon_state = "dormantobelisk"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/waterwheel
	parent_type = /obj/structure/rockhill
	name = "waterwheel"
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/waterwheel.dmi'
	icon_state = "1"
	layer = 5

/obj/structure/well
	parent_type = /obj/structure/rockhill
	name = "well"
	desc = "Far down inside the dark hole, water laps the walls of smooth brickwork."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "well"
	density = TRUE
	opacity = 0
	layer = 2.91

/obj/structure/well/fountain
	name = "water fountain"
	desc = "A slightly more civilized alternative to drinking straight from a river."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/64x64.dmi'
	icon_state = "fountain"
	density = TRUE
	opacity = 0
	pixel_x = -15
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/well/fountain/mana
	name = "mana fountain"
	desc = "This fountain produces a strange blue liquid. It seems faintly magical. Attempts to bottle it seems to cause it to inexplicably turn into water."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/64x64.dmi'
	icon_state = "manafountain"
	density = TRUE
	opacity = 0
	pixel_x = -16
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/well/fountainswamp
	name = "water fountain"
	desc = "Green-tinted bogwater dances through sheets of thick floating algae."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/64x64.dmi'
	icon_state = "fountain"
	density = TRUE
	opacity = 0
	pixel_x = -15
	layer = ABOVE_ALL_MOB_LAYER
	color = "#a3c2a8"

/obj/structure/well/poisoned
	name = "dubious well"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "well"
	density = TRUE
	opacity = 0
	layer = 2.91
	color = "#59aa65"

/obj/structure/wild_plant/nospread/manabloom
	name = "wild manabloom"
	desc = "Wild manabloom"
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/crops.dmi'
	icon_state = "manabloom2"
	layer = BELOW_OBJ_LAYER

/obj/structure/winch
	parent_type = /obj/structure/rockhill
	name = "winch"
	desc = "A gatekeeper's only, and most important responsibility."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "winch"
	density = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/wooden_horse/iron
	name = "wooden saiga"
	desc = "This tireless steed promises a less than pleasant journey, should you dare to ride it."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "wooden_horse_iron"
	density = TRUE
	pixel_x = 0

/obj/structure/wooden_horse/mobile
	name = "wooden horse"
	desc = "An affordable means of transportation for all walks of life, though few wish to ride. Watching the galloping of unlucky riders is one of the favorite pastimes of local nobility."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/structure.dmi'
	icon_state = "wooden_horse2"
	density = TRUE
	pixel_x = 0

/obj/structure/zizo_bane
	parent_type = /obj/structure/rockhill
	name = "Zizo's bane"
	desc = "A small purple mushroom that has been growing in areas of rot."
	icon = 'modular_redtard/rockhill/icons/obj/flora/rogueflora.dmi'
	icon_state = "zizo_bane"
	density = FALSE
	layer = BELOW_OBJ_LAYER
