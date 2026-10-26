/datum/species/rogue_orc
	rogue_offsets = list(
		"m" = list(OFFSET_BACK = list(0, 1), OFFSET_BELT = list(0, 1), OFFSET_EARS = list(0, 1), OFFSET_FACE = list(0, 1), OFFSET_FACEMASK = list(0, 1), OFFSET_GLASSES = list(0, 1), OFFSET_GLOVES = list(0, 1), OFFSET_HEAD = list(0, 1), OFFSET_HELD = list(0, 1), OFFSET_NECK = list(0, 1), OFFSET_SUIT = list(0, 1), OFFSET_S_STORE = list(0, 1), ROGUE_OFFSET_CLOAK = list(0, 1), ROGUE_OFFSET_MOUTH = list(0, 1), ROGUE_OFFSET_RING = list(0, 1), ROGUE_OFFSET_SHIRT = list(0, 1), ROGUE_OFFSET_WRISTS = list(0, 1)),
		"f" = list(OFFSET_BACK = list(0, 1), OFFSET_BELT = list(0, 1), OFFSET_EARS = list(0, 1), OFFSET_FACE = list(0, 1), OFFSET_FACEMASK = list(0, 1), OFFSET_GLASSES = list(0, 1), OFFSET_GLOVES = list(0, 1), OFFSET_HEAD = list(0, 1), OFFSET_HELD = list(0, 1), OFFSET_NECK = list(0, 1), OFFSET_SUIT = list(0, 1), OFFSET_S_STORE = list(0, 1), OFFSET_UNIFORM = list(0, 1), ROGUE_OFFSET_CLOAK = list(0, 1), ROGUE_OFFSET_MOUTH = list(0, 1), ROGUE_OFFSET_RING = list(0, 1), ROGUE_OFFSET_SHIRT = list(0, 1), ROGUE_OFFSET_WRISTS = list(0, 1)),
		)

/datum/species/rogue_drow
	rogue_offsets = list(
		"m" = list(OFFSET_GLOVES = list(0, 1), OFFSET_SUIT = list(0, 1), OFFSET_S_STORE = list(0, 1), ROGUE_OFFSET_CLOAK = list(0, 1), ROGUE_OFFSET_SHIRT = list(0, 1), ROGUE_OFFSET_WRISTS = list(0, 1)),
		"f" = list(OFFSET_BACK = list(0, -1), OFFSET_BELT = list(0, -1), OFFSET_EARS = list(0, -1), OFFSET_FACE = list(0, -1), OFFSET_FACEMASK = list(0, -1), OFFSET_GLASSES = list(0, -1), OFFSET_HEAD = list(0, -1), OFFSET_NECK = list(0, -1), ROGUE_OFFSET_MOUTH = list(0, -1), ROGUE_OFFSET_RING = list(0, -1)),
		)

/datum/species/rogue_goblin
	rogue_offsets = list(
		"m" = list(OFFSET_HELD = list(0, -4)),
		"f" = list(OFFSET_HELD = list(0, -4)),
		)

/datum/species/rogue_goblin/cave
	rogue_offsets = list(
		"m" = list(OFFSET_HELD = list(0, -4)),
		"f" = list(OFFSET_HELD = list(0, -4)),
		)

/datum/species/rogue_goblin/hell
	rogue_offsets = list(
		"m" = list(OFFSET_HELD = list(0, -4)),
		"f" = list(OFFSET_HELD = list(0, -4)),
		)

/datum/species/rogue_goblin/sea
	rogue_offsets = list(
		"m" = list(OFFSET_HELD = list(0, -4)),
		"f" = list(OFFSET_HELD = list(0, -4)),
		)

/datum/species/rogue_goblin/moon
	rogue_offsets = list(
		"m" = list(OFFSET_HELD = list(0, -4)),
		"f" = list(OFFSET_HELD = list(0, -4)),
		)

/obj/item/clothing/head/roguetown/helmet/goblin
	rogue_goblin_state = "goblin_worn_plate_helm"

/obj/item/clothing/head/roguetown/helmet/leather/goblin
	rogue_goblin_state = "goblin_worn_leather_helm"

/obj/item/clothing/suit/roguetown/armor/leather/goblin
	rogue_goblin_state = "goblin_worn_leather_armor"

/obj/item/clothing/suit/roguetown/armor/leather/hide/goblin
	rogue_goblin_state = "goblin_worn_cloth_armor"

/obj/item/clothing/suit/roguetown/armor/plate/half/iron/goblin
	rogue_goblin_state = "goblin_worn_plate_armor"

/datum/sprite_accessory/facial_hair/rogue_longbeard
	name = "Beard (Long) (Ratwood)"
	icon = 'modular_redtard/rockhill/icons/bodies.dmi'
	icon_state = "rogue_facial_longbeard"
	locked = TRUE
	natural_spawn = FALSE

/datum/sprite_accessory/facial_hair/rogue_manly
	name = "Beard (Manly)"
	icon = 'modular_redtard/rockhill/icons/bodies.dmi'
	icon_state = "rogue_facial_manly"
	locked = TRUE
	natural_spawn = FALSE

/datum/sprite_accessory/facial_hair/rogue_viking
	name = "Beard (Viking)"
	icon = 'modular_redtard/rockhill/icons/bodies.dmi'
	icon_state = "rogue_facial_viking"
	locked = TRUE
	natural_spawn = FALSE

/datum/sprite_accessory/hair/rogue_countryponytailalt
	name = "Ponytail (Country Alt)"
	icon = 'modular_redtard/rockhill/icons/bodies.dmi'
	icon_state = "rogue_hair_countryponytailalt"
	locked = TRUE
	natural_spawn = FALSE

/datum/sprite_accessory/hair/rogue_dave
	name = "Dave"
	icon = 'modular_redtard/rockhill/icons/bodies.dmi'
	icon_state = "rogue_hair_dave"
	locked = TRUE
	natural_spawn = FALSE

/datum/sprite_accessory/hair/rogue_emo
	name = "Emo (Ratwood)"
	icon = 'modular_redtard/rockhill/icons/bodies.dmi'
	icon_state = "rogue_hair_emo"
	locked = TRUE
	natural_spawn = FALSE

/datum/sprite_accessory/hair/rogue_himecut
	name = "Hime Cut (Ratwood)"
	icon = 'modular_redtard/rockhill/icons/bodies.dmi'
	icon_state = "rogue_hair_himecut"
	locked = TRUE
	natural_spawn = FALSE

/datum/sprite_accessory/hair/rogue_kusanagi_alt
	name = "Kusanagi (Alt)"
	icon = 'modular_redtard/rockhill/icons/bodies.dmi'
	icon_state = "rogue_hair_kusanagi_alt"
	locked = TRUE
	natural_spawn = FALSE

/datum/sprite_accessory/hair/rogue_lowbraid
	name = "Braid (Low) (Ratwood)"
	icon = 'modular_redtard/rockhill/icons/bodies.dmi'
	icon_state = "rogue_hair_lowbraid"
	locked = TRUE
	natural_spawn = FALSE

/datum/sprite_accessory/hair/rogue_ponytailwitcher
	name = "Ponytail (Witcher)"
	icon = 'modular_redtard/rockhill/icons/bodies.dmi'
	icon_state = "rogue_hair_ponytailwitcher"
	locked = TRUE
	natural_spawn = FALSE

/datum/sprite_accessory/hair/rogue_sabitsuki
	name = "Sabitsuki"
	icon = 'modular_redtard/rockhill/icons/bodies.dmi'
	icon_state = "rogue_hair_sabitsuki"
	locked = TRUE
	natural_spawn = FALSE

/datum/sprite_accessory/hair/rogue_sabitsuki_ponytail
	name = "Sabitsuki (Ponytail)"
	icon = 'modular_redtard/rockhill/icons/bodies.dmi'
	icon_state = "rogue_hair_sabitsuki_ponytail"
	locked = TRUE
	natural_spawn = FALSE

/datum/sprite_accessory/hair/rogue_stacy
	name = "Stacy"
	icon = 'modular_redtard/rockhill/icons/bodies.dmi'
	icon_state = "rogue_hair_stacy"
	locked = TRUE
	natural_spawn = FALSE
