/obj/effect/falling_maple
	parent_type = /obj/effect/rockhill
	icon = 'modular_redtard/rockhill/icons/effects/effects.dmi'

/obj/effect/falling_sakura
	parent_type = /obj/effect/rockhill
	icon = 'modular_redtard/rockhill/icons/effects/effects.dmi'

/obj/effect/lily_petal
	parent_type = /obj/effect/rockhill
	name = "lily petals"
	icon = 'modular_redtard/rockhill/icons/obj/structures/hotspring.dmi'
	icon_state = "lilypetals1"

/obj/effect/lily_petal/three
	name = "lily petals"
	icon = 'modular_redtard/rockhill/icons/obj/structures/hotspring.dmi'
	icon_state = "lilypetals3"

/obj/effect/lily_petal/two
	name = "lily petals"
	icon = 'modular_redtard/rockhill/icons/obj/structures/hotspring.dmi'
	icon_state = "lilypetals2"

/obj/effect/oneway/baroness
	parent_type = /obj/effect/rockhill
	name = "magical barrier"
	desc = "Victory or death - once you pass this point you will either triumph or fall. Recommended 3 players or more."
	icon = 'modular_redtard/rockhill/icons/effects/effects.dmi'
	icon_state = "smoke"
	invisibility = SEE_INVISIBLE_LIVING

/obj/effect/particle_effect/smoke
	parent_type = /obj/effect/rockhill
	name = "smoke"
	icon = 'modular_redtard/rockhill/icons/effects/96x96.dmi'
	icon_state = "smoke"
	pixel_x = -32
	pixel_y = -32
	opacity = 1
	plane = ABOVE_GAME_PLANE
	layer = FLY_LAYER

/obj/effect/wisp/bluegreen
	parent_type = /obj/effect/rockhill
	name = "will-o'-the-wisp"
	desc = "A small, fiery ball of light made up of mystical energy."
	icon = 'modular_redtard/rockhill/icons/roguetown/items/lighting.dmi'
	icon_state = "wisp"
	color = "#59ff93"
	light_range = 4
	light_color = "#33ff00"

/obj/effect/wisp/geothermal
	parent_type = /obj/effect/rockhill
	name = "Odd Wisp"
	desc = "A peculiar natural phenomena, seemingly related to the roiling lava below"
	icon = 'modular_redtard/rockhill/icons/roguetown/items/lighting.dmi'
	icon_state = "wisp"
	color = "#ff5630"
	light_range = 4
	light_color = "#ff5630"

/obj/effect/wisp/green
	parent_type = /obj/effect/rockhill
	name = "will-o'-the-wisp"
	desc = "A small, fiery ball of light made up of mystical energy."
	icon = 'modular_redtard/rockhill/icons/roguetown/items/lighting.dmi'
	icon_state = "wisp"
	color = "#33ff00"
	light_range = 4
	light_color = "#ffff00"

/obj/effect/wisp/infernal
	parent_type = /obj/effect/rockhill
	name = "Infernal Wisp"
	desc = "An ominous manifestation of latent ambient magick"
	icon = 'modular_redtard/rockhill/icons/roguetown/items/lighting.dmi'
	icon_state = "wisp"
	color = "#ff0008"
	light_range = 4
	light_color = "#ff0008"

/obj/effect/wisp/prestidigitation
	parent_type = /obj/effect/rockhill
	name = "minor magelight mote"
	desc = "A tiny display of arcyne power used to illuminate."
	icon = 'modular_redtard/rockhill/icons/roguetown/items/lighting.dmi'
	icon_state = "wisp"
	pixel_x = 20
	light_range = 5
	light_color = "#3FBAFD"
