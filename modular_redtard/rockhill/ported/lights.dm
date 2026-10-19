/obj/machinery/light/rogue
	parent_type = /obj/structure/rockhill/light

/obj/machinery/light/rogue/campfire
	name = "campfire"
	desc = "Oily smoke curls from a weak sputtering flame."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "badfire1"
	density = FALSE
	light_range = 5
	light_power = 1
	light_color = "#da5e21"
	layer = 2.8
	base_state = "badfire"
	fueluse = 15 MINUTES
	no_refuel = FALSE
	crossfire = TRUE
	status = LIGHT_OK

/obj/machinery/light/rogue/campfire/densefire
	name = "campfire"
	desc = "A ring of stones offers the fire enough protection from the wind to keep the dark at bay and the body warm."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "densefire1"
	density = TRUE
	light_range = 5
	light_power = 1
	light_color = "#eea96a"
	layer = 2.8
	base_state = "densefire"
	fueluse = 30 MINUTES
	no_refuel = FALSE
	crossfire = TRUE
	status = LIGHT_OK

/obj/machinery/light/rogue/campfire/fireplace
	name = "fireplace"
	desc = "A warm fire dances between a pile of half-burnt logs upon a bed of glowing embers."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "wallfire1"
	density = FALSE
	light_range = 5
	light_power = 1
	light_color = "#ffa35c"
	layer = 2.8
	base_state = "wallfire"
	fueluse = 0
	no_refuel = TRUE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/campfire/fireplace/blue
	name = "fireplace"
	desc = "A curious cool fire dances upon a bed of mysteriously glowing embers."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/wallfireblue.dmi'
	icon_state = "wallfire1"
	density = FALSE
	light_range = 5
	light_power = 1
	light_color = "#6e90ff"
	layer = 2.8
	base_state = "wallfire"
	fueluse = 0
	no_refuel = TRUE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/campfire/fireplace/crafted
	name = "fireplace"
	desc = "A warm fire dances between a pile of half-burnt logs upon a bed of glowing embers."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "wallfire1"
	density = FALSE
	pixel_y = 32
	light_range = 5
	light_power = 1
	light_color = "#ffa35c"
	layer = 2.8
	base_state = "wallfire"
	fueluse = 0
	no_refuel = TRUE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/campfire/fireplace/inn
	name = "grand fireplace"
	desc = "A warm fire dances between a pile of half-burnt logs upon a bed of glowing embers."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "wallfire1"
	density = FALSE
	light_range = 5
	light_power = 1
	light_color = "#ffa35c"
	layer = 2.8
	base_state = "wallfire"
	fueluse = 0
	no_refuel = TRUE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/campfire/longlived
	name = "campfire"
	desc = "Oily smoke curls from a weak sputtering flame."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "badfire1"
	density = FALSE
	light_range = 5
	light_power = 1
	light_color = "#da5e21"
	layer = 2.8
	base_state = "badfire"
	fueluse = 180 MINUTES
	no_refuel = FALSE
	crossfire = TRUE
	status = LIGHT_OK

/obj/machinery/light/rogue/campfire/pyre
	name = "pyre"
	desc = "Oily smoke curls from a weak sputtering flame."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	density = FALSE
	light_range = 10
	light_power = 1
	light_color = "#da5e21"
	dir = NORTH
	icon_state = null
	layer = BELOW_MOB_LAYER
	base_state = "pyre"
	fueluse = 30 MINUTES
	no_refuel = FALSE
	crossfire = TRUE
	status = LIGHT_OK

/obj/machinery/light/rogue/candle
	name = "candles"
	desc = "Tiny flames flicker to the slightest breeze and offer enough light to see."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "wallcandle1"
	pixel_y = 32
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	layer = BELOW_MOB_LAYER
	base_state = "wallcandle"
	fueluse = 0
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/candle/blue
	name = "candles"
	desc = "Tiny bluish flames flicker gently like the stars themselves."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "wallcandleb1"
	pixel_y = 32
	light_range = 8
	light_power = 1
	light_color = "#7b60f3"
	layer = BELOW_MOB_LAYER
	base_state = "wallcandleb"
	fueluse = 0
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/candle/blue/l
	name = "candles"
	desc = "Tiny bluish flames flicker gently like the stars themselves."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "wallcandleb1"
	pixel_x = -32
	pixel_y = 0
	light_range = 8
	light_power = 1
	light_color = "#7b60f3"
	layer = BELOW_MOB_LAYER
	base_state = "wallcandleb"
	fueluse = 0
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/candle/blue/r
	name = "candles"
	desc = "Tiny bluish flames flicker gently like the stars themselves."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "wallcandleb1"
	pixel_x = 32
	pixel_y = 0
	light_range = 8
	light_power = 1
	light_color = "#7b60f3"
	layer = BELOW_MOB_LAYER
	base_state = "wallcandleb"
	fueluse = 0
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/candle/floorcandle
	name = "candles"
	desc = "Tiny flames flicker to the slightest breeze and offer enough light to see."
	icon = 'modular_redtard/rockhill/icons/roguetown/items/lighting.dmi'
	icon_state = "floorcandle1"
	pixel_y = 0
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	layer = TABLE_LAYER
	base_state = "floorcandle"
	fueluse = 0
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/candle/floorcandle/alt
	name = "candles"
	desc = "Tiny flames flicker to the slightest breeze and offer enough light to see."
	icon = 'modular_redtard/rockhill/icons/roguetown/items/lighting.dmi'
	icon_state = "floorcandlee1"
	pixel_y = 0
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	layer = TABLE_LAYER
	base_state = "floorcandlee"
	fueluse = 0
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/candle/floorcandle/alt/pink
	name = "candles"
	desc = "Tiny flames flicker to the slightest breeze and offer enough light to see."
	icon = 'modular_redtard/rockhill/icons/roguetown/items/lighting.dmi'
	icon_state = "floorcandlee1"
	pixel_y = 0
	light_range = 8
	light_power = 1
	light_color = "#ff13d8ff"
	color = "#f858b5ff"
	layer = TABLE_LAYER
	base_state = "floorcandlee"
	fueluse = 0
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/candle/floorcandle/pink
	name = "candles"
	desc = "Tiny flames flicker to the slightest breeze and offer enough light to see."
	icon = 'modular_redtard/rockhill/icons/roguetown/items/lighting.dmi'
	icon_state = "floorcandle1"
	pixel_y = 0
	light_range = 8
	light_power = 1
	light_color = "#ff13d8ff"
	color = "#f858b5ff"
	layer = TABLE_LAYER
	base_state = "floorcandle"
	fueluse = 0
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/candle/green
	name = "candles"
	desc = "Tiny greenish flames flicker with unearthly warmth."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "wallcandleg1"
	pixel_y = 32
	light_range = 8
	light_power = 1
	light_color = "#60f382"
	layer = BELOW_MOB_LAYER
	base_state = "wallcandleg"
	fueluse = 0
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/candle/green/l
	name = "candles"
	desc = "Tiny greenish flames flicker with unearthly warmth."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "wallcandleg1"
	pixel_x = -32
	pixel_y = 0
	light_range = 8
	light_power = 1
	light_color = "#60f382"
	layer = BELOW_MOB_LAYER
	base_state = "wallcandleg"
	fueluse = 0
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/candle/green/r
	name = "candles"
	desc = "Tiny greenish flames flicker with unearthly warmth."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "wallcandleg1"
	pixel_x = 32
	pixel_y = 0
	light_range = 8
	light_power = 1
	light_color = "#60f382"
	layer = BELOW_MOB_LAYER
	base_state = "wallcandleg"
	fueluse = 0
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/candle/l
	name = "candles"
	desc = "Tiny flames flicker to the slightest breeze and offer enough light to see."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "wallcandle1"
	pixel_x = -32
	pixel_y = 0
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	layer = BELOW_MOB_LAYER
	base_state = "wallcandle"
	fueluse = 0
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/candle/off
	name = "candles"
	desc = "Cold wax sticks in sad half-melted repose. All they need is a spark."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "wallcandle0"
	pixel_y = 32
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	layer = BELOW_MOB_LAYER
	base_state = "wallcandle"
	fueluse = 0
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_BURNED

/obj/machinery/light/rogue/candle/off/l
	name = "candles"
	desc = "Cold wax sticks in sad half-melted repose. All they need is a spark."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "wallcandle0"
	pixel_x = -32
	pixel_y = 0
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	layer = BELOW_MOB_LAYER
	base_state = "wallcandle"
	fueluse = 0
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_BURNED

/obj/machinery/light/rogue/candle/off/r
	name = "candles"
	desc = "Cold wax sticks in sad half-melted repose. All they need is a spark."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "wallcandle0"
	pixel_x = 32
	pixel_y = 0
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	layer = BELOW_MOB_LAYER
	base_state = "wallcandle"
	fueluse = 0
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_BURNED

/obj/machinery/light/rogue/candle/r
	name = "candles"
	desc = "Tiny flames flicker to the slightest breeze and offer enough light to see."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "wallcandle1"
	pixel_x = 32
	pixel_y = 0
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	layer = BELOW_MOB_LAYER
	base_state = "wallcandle"
	fueluse = 0
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/candle/red
	name = "candles"
	desc = "Tiny red flames flicker hatefully in the dark."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "wallcandler1"
	pixel_y = 32
	light_range = 8
	light_power = 1
	light_color = "#f02929"
	layer = BELOW_MOB_LAYER
	base_state = "wallcandler"
	fueluse = 0
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/candle/red/l
	name = "candles"
	desc = "Tiny red flames flicker hatefully in the dark."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "wallcandler1"
	pixel_x = -32
	pixel_y = 0
	light_range = 8
	light_power = 1
	light_color = "#f02929"
	layer = BELOW_MOB_LAYER
	base_state = "wallcandler"
	fueluse = 0
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/candle/red/r
	name = "candles"
	desc = "Tiny red flames flicker hatefully in the dark."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "wallcandler1"
	pixel_x = 32
	pixel_y = 0
	light_range = 8
	light_power = 1
	light_color = "#f02929"
	layer = BELOW_MOB_LAYER
	base_state = "wallcandler"
	fueluse = 0
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/candle/weak
	name = "candles"
	desc = "Tiny flames flicker to the slightest breeze and offer enough light to see."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "wallcandle1"
	pixel_y = 32
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	layer = BELOW_MOB_LAYER
	base_state = "wallcandle"
	fueluse = 0
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/candle/weak/l
	name = "candles"
	desc = "Tiny flames flicker to the slightest breeze and offer enough light to see."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "wallcandle1"
	pixel_x = -32
	pixel_y = 0
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	layer = BELOW_MOB_LAYER
	base_state = "wallcandle"
	fueluse = 0
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/candle/weak/r
	name = "candles"
	desc = "Tiny flames flicker to the slightest breeze and offer enough light to see."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "wallcandle1"
	pixel_x = 32
	pixel_y = 0
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	layer = BELOW_MOB_LAYER
	base_state = "wallcandle"
	fueluse = 0
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/cauldron
	name = "cauldron"
	desc = "Bubble, Bubble, toil and trouble. A great iron cauldron for brewing potions."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/alchemy.dmi'
	icon_state = "cauldron1"
	density = TRUE
	opacity = FALSE
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	layer = BELOW_MOB_LAYER
	base_state = "cauldron"
	fueluse = 20 MINUTES
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/chand
	name = "chandelier"
	desc = "A dazzling and resplendant array of candles held aloft by a dozen slender metal arms joined together and suspended from the ceiling."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallwide.dmi'
	icon_state = "chand1"
	density = FALSE
	pixel_x = -10
	pixel_y = -10
	light_range = 10
	light_power = 1
	light_color = "#f9ad80"
	layer = 2
	base_state = "chand"
	fueluse = 0
	no_refuel = TRUE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/firebowl
	name = "brazier"
	desc = "A solid stone brazier. It's as sturdy as the mountains themselves."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "stonefire1"
	density = TRUE
	light_range = 12
	light_power = 1
	light_color = "#ffa35c"
	dir = SOUTH
	layer = BELOW_MOB_LAYER
	base_state = "stonefire"
	fueluse = 0
	no_refuel = TRUE
	crossfire = TRUE
	status = LIGHT_OK

/obj/machinery/light/rogue/firebowl/church
	name = "brazier"
	desc = "A wide metal bowl mounted on a stand for a healthy roaring flame."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "churchfire1"
	density = TRUE
	light_range = 12
	light_power = 1
	light_color = "#ffa35c"
	dir = SOUTH
	layer = BELOW_MOB_LAYER
	base_state = "churchfire"
	fueluse = 0
	no_refuel = TRUE
	crossfire = TRUE
	status = LIGHT_OK

/obj/machinery/light/rogue/firebowl/church/off
	name = "brazier"
	desc = "The fire is gone!"
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "churchfire0"
	density = TRUE
	light_range = 12
	light_power = 1
	light_color = "#ffa35c"
	dir = SOUTH
	layer = BELOW_MOB_LAYER
	base_state = "churchfire"
	fueluse = 0
	no_refuel = TRUE
	crossfire = TRUE
	status = LIGHT_BURNED

/obj/machinery/light/rogue/firebowl/off
	name = "brazier"
	desc = "The fire is gone!"
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "stonefire0"
	density = TRUE
	light_range = 12
	light_power = 1
	light_color = "#ffa35c"
	dir = SOUTH
	layer = BELOW_MOB_LAYER
	base_state = "stonefire"
	fueluse = 0
	no_refuel = TRUE
	crossfire = TRUE
	status = LIGHT_BURNED

/obj/machinery/light/rogue/firebowl/standing
	name = "standing fire"
	desc = "Wrought metal spun into a surprisingly stable stand for a large candle to sit upon."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "standing1"
	density = FALSE
	light_range = 12
	light_power = 1
	light_color = "#ff9648"
	dir = SOUTH
	layer = BELOW_MOB_LAYER
	base_state = "standing"
	fueluse = 0
	no_refuel = TRUE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/firebowl/standing/blue
	name = "standing fire"
	desc = "Soft and blue like the moon's light."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "standingb1"
	density = FALSE
	light_range = 12
	light_power = 1
	light_color = "#7b60f3"
	dir = SOUTH
	layer = BELOW_MOB_LAYER
	base_state = "standingb"
	fueluse = 0
	no_refuel = TRUE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/firebowl/standing/green
	name = "standing fire"
	desc = "Soft and green like... well, nothing you can really think of right now."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "standingg1"
	density = FALSE
	light_range = 12
	light_power = 1
	light_color = "#8ee2a7"
	dir = SOUTH
	layer = BELOW_MOB_LAYER
	base_state = "standingg"
	fueluse = 0
	no_refuel = TRUE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/firebowl/standing/red
	name = "standing fire"
	desc = "An unearthly red, wafting a faint scent of brimstone."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "standingr1"
	density = FALSE
	light_range = 12
	light_power = 1
	light_color = "#f02929"
	dir = SOUTH
	layer = BELOW_MOB_LAYER
	base_state = "standingr"
	fueluse = 0
	no_refuel = TRUE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/firebowl/stump
	name = "brazier"
	desc = "Somewhat crude, but it lights the long winding paths throughout the land."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "stumpfire1"
	density = TRUE
	light_range = 12
	light_power = 1
	light_color = "#ffa35c"
	dir = SOUTH
	layer = BELOW_MOB_LAYER
	base_state = "stumpfire"
	fueluse = 0
	no_refuel = TRUE
	crossfire = TRUE
	status = LIGHT_OK

/obj/machinery/light/rogue/forge
	name = "stone forge"
	desc = "This forge sings of war and creation."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/forge.dmi'
	icon_state = "forge0"
	density = TRUE
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	layer = BELOW_MOB_LAYER
	base_state = "forge"
	fueluse = 60 MINUTES
	no_refuel = FALSE
	crossfire = TRUE
	status = LIGHT_OK

/obj/machinery/light/rogue/hearth
	name = "hearth"
	desc = "A hearth of stones carefully arranged to support a pan or a pot above a steady bed of embers."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "hearth1"
	density = TRUE
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	layer = TABLE_LAYER
	base_state = "hearth"
	fueluse = 60 MINUTES
	no_refuel = FALSE
	crossfire = TRUE
	status = LIGHT_OK

/obj/machinery/light/rogue/lanternpost
	name = "lantern post"
	desc = "A small lamptern dangles from a wooden post. The metal frame around the inner flame casts shadows on its surroundings."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "streetlantern1"
	density = FALSE
	light_range = 5
	light_power = 1
	light_color = "#f9ad80"
	plane = ABOVE_GAME_PLANE
	layer = WALL_OBJ_LAYER
	base_state = "streetlantern"
	fueluse = 0
	no_refuel = TRUE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/oven
	name = "oven"
	desc = "With enough room for up to five whole pies, this humble yet wondrous invention has fed civilization since time immemorial."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "oven1"
	density = FALSE
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	layer = BELOW_MOB_LAYER
	base_state = "oven"
	fueluse = 60 MINUTES
	no_refuel = FALSE
	crossfire = TRUE
	status = LIGHT_OK

/obj/machinery/light/rogue/oven/east
	name = "oven"
	desc = "With enough room for up to five whole pies, this humble yet wondrous invention has fed civilization since time immemorial."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "oven1"
	density = FALSE
	pixel_x = -32
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	dir = EAST
	layer = BELOW_MOB_LAYER
	base_state = "oven"
	fueluse = 60 MINUTES
	no_refuel = FALSE
	crossfire = TRUE
	status = LIGHT_OK

/obj/machinery/light/rogue/oven/north
	name = "oven"
	desc = "With enough room for up to five whole pies, this humble yet wondrous invention has fed civilization since time immemorial."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "oven1"
	density = FALSE
	pixel_y = -32
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	dir = NORTH
	layer = BELOW_MOB_LAYER
	base_state = "oven"
	fueluse = 60 MINUTES
	no_refuel = FALSE
	crossfire = TRUE
	status = LIGHT_OK

/obj/machinery/light/rogue/oven/south
	name = "oven"
	desc = "With enough room for up to five whole pies, this humble yet wondrous invention has fed civilization since time immemorial."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "oven1"
	density = FALSE
	pixel_y = 32
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	dir = SOUTH
	layer = BELOW_MOB_LAYER
	base_state = "oven"
	fueluse = 60 MINUTES
	no_refuel = FALSE
	crossfire = TRUE
	status = LIGHT_OK

/obj/machinery/light/rogue/oven/west
	name = "oven"
	desc = "With enough room for up to five whole pies, this humble yet wondrous invention has fed civilization since time immemorial."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "oven1"
	density = FALSE
	pixel_x = 32
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	dir = WEST
	layer = BELOW_MOB_LAYER
	base_state = "oven"
	fueluse = 60 MINUTES
	no_refuel = FALSE
	crossfire = TRUE
	status = LIGHT_OK

/obj/machinery/light/rogue/smelter
	name = "stone furnace"
	desc = "A stone furnace, weathered by time and heat."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/forge.dmi'
	icon_state = "cavesmelter0"
	density = TRUE
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	layer = BELOW_MOB_LAYER
	base_state = "cavesmelter"
	fueluse = 30 MINUTES
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/smelter/bronze
	name = "bronze melter"
	desc = "An object of humen make, this furnace is capable of making bronze or iron."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/forge.dmi'
	icon_state = "brosmelter0"
	density = TRUE
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	layer = BELOW_MOB_LAYER
	base_state = "brosmelter"
	fueluse = 30 MINUTES
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/smelter/great
	name = "great furnace"
	desc = "The pinnacle of dwarven engineering and the miracle of Malum's blessed fire crystal, allowing for greater alloys to be made."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/forge.dmi'
	icon_state = "smelter0"
	density = TRUE
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	layer = BELOW_MOB_LAYER
	base_state = "smelter"
	fueluse = 30 MINUTES
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/smelter/hiron
	name = "iron bloomery"
	desc = "An object of humen make, this furnace is capable of making high quantities of iron."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/forge.dmi'
	icon_state = "hironsmelter0"
	density = TRUE
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	layer = BELOW_MOB_LAYER
	base_state = "hironsmelter"
	fueluse = 30 MINUTES
	no_refuel = FALSE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/torchholder
	name = "sconce"
	desc = "A wall-mounted fixture that allows a torch to illuminate the area while freeing the hands for other tasks."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "torchwall1"
	density = FALSE
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	plane = ABOVE_GAME_PLANE
	layer = WALL_OBJ_LAYER
	base_state = "torchwall"
	fueluse = FALSE
	no_refuel = TRUE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/torchholder/c
	name = "sconce"
	desc = "A wall-mounted fixture that allows a torch to illuminate the area while freeing the hands for other tasks."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "torchwall1"
	density = FALSE
	pixel_y = 32
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	plane = ABOVE_GAME_PLANE
	layer = WALL_OBJ_LAYER
	base_state = "torchwall"
	fueluse = FALSE
	no_refuel = TRUE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/torchholder/hotspring
	name = "stone lantern"
	desc = "A stone lantern, built in Kazengunese style. It is believed these lanterns attracts spirits and guide their way."
	icon = 'modular_redtard/rockhill/icons/obj/structures/hotspring.dmi'
	icon_state = "stonelantern1"
	density = FALSE
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	plane = ABOVE_GAME_PLANE
	layer = WALL_OBJ_LAYER
	base_state = "stonelantern"
	fueluse = FALSE
	no_refuel = TRUE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/torchholder/hotspring/standing
	name = "standing stone lantern"
	desc = "A stone lantern, built in Kazengunese style. It is believed these lanterns attracts spirits and guide their way."
	icon = 'modular_redtard/rockhill/icons/obj/structures/hotspring.dmi'
	icon_state = "stonelantern_standing1"
	density = FALSE
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	plane = ABOVE_GAME_PLANE
	layer = WALL_OBJ_LAYER
	base_state = "stonelantern_standing"
	fueluse = FALSE
	no_refuel = TRUE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/torchholder/l
	name = "sconce"
	desc = "A wall-mounted fixture that allows a torch to illuminate the area while freeing the hands for other tasks."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "torchwall1"
	density = FALSE
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	dir = EAST
	plane = ABOVE_GAME_PLANE
	layer = WALL_OBJ_LAYER
	base_state = "torchwall"
	fueluse = FALSE
	no_refuel = TRUE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/rogue/torchholder/r
	name = "sconce"
	desc = "A wall-mounted fixture that allows a torch to illuminate the area while freeing the hands for other tasks."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/lighting.dmi'
	icon_state = "torchwall1"
	density = FALSE
	light_range = 8
	light_power = 1
	light_color = "#f9ad80"
	dir = WEST
	plane = ABOVE_GAME_PLANE
	layer = WALL_OBJ_LAYER
	base_state = "torchwall"
	fueluse = FALSE
	no_refuel = TRUE
	crossfire = FALSE
	status = LIGHT_OK

/obj/machinery/light/roguestreet
	parent_type = /obj/structure/rockhill/light
	name = "street lamp"
	desc = "An obelisk of caste iron with an eerily glowing lamp attached to it. A promise of new technology at the dawn of a new age."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "slamp1"
	light_range = 10.9
	light_power = 0.95
	light_color = "#58dd90"
	plane = ABOVE_GAME_PLANE
	layer = 4.81

/obj/machinery/light/roguestreet/midlamp
	name = "street lamp"
	desc = "An obelisk of caste iron with an eerily glowing lamp attached to it. A promise of new technology at the dawn of a new age."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/64x64.dmi'
	icon_state = "midlamp1"
	density = TRUE
	pixel_x = -16
	light_range = 10.9
	light_power = 0.95
	light_color = "#58dd90"
	plane = ABOVE_GAME_PLANE
	layer = 4.81

/obj/machinery/light/roguestreet/orange
	name = "street lamp"
	desc = "An obelisk of caste iron with an eerily glowing lamp attached to it. A promise of new technology at the dawn of a new age."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "o_slamp1"
	light_range = 10.9
	light_power = 1
	light_color = "#da8c45"
	plane = ABOVE_GAME_PLANE
	layer = 4.81

/obj/machinery/light/roguestreet/orange/midlamp
	name = "street lamp"
	desc = "An obelisk of caste iron with an eerily glowing lamp attached to it. A promise of new technology at the dawn of a new age."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/64x64.dmi'
	icon_state = "o_midlamp1"
	density = TRUE
	pixel_x = -16
	light_range = 10.9
	light_power = 1
	light_color = "#da8c45"
	plane = ABOVE_GAME_PLANE
	layer = 4.81

/obj/machinery/light/roguestreet/orange/walllamp
	name = "wall lamp"
	desc = "An eerily glowing lamp attached to the wall via a caste iron frame. A promise of new technology at the dawn of a new age."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "o_wlamp1"
	density = FALSE
	light_range = 7.8
	light_power = 1
	light_color = "#da8c45"
	plane = ABOVE_GAME_PLANE
	layer = 4.81

/obj/machinery/light/roguestreet/walllamp
	name = "wall lamp"
	desc = "An eerily glowing lamp attached to the wall via a caste iron frame. A promise of new technology at the dawn of a new age."
	icon = 'modular_redtard/rockhill/icons/roguetown/misc/tallstructure.dmi'
	icon_state = "wlamp1"
	density = FALSE
	light_range = 7.8
	light_power = 0.95
	light_color = "#58dd90"
	plane = ABOVE_GAME_PLANE
	layer = 4.81
