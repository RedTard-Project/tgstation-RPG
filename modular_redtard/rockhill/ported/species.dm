/datum/species/rogue_orc
	rogue_offsets = list(
		"m" = list(OFFSET_BACK = list(0, 1), OFFSET_BELT = list(0, 1), OFFSET_EARS = list(0, 1), OFFSET_FACE = list(0, 1), OFFSET_FACEMASK = list(0, 1), OFFSET_GLASSES = list(0, 1), OFFSET_GLOVES = list(0, 1), OFFSET_HEAD = list(0, 1), OFFSET_HELD = list(0, 1), OFFSET_NECK = list(0, 1), OFFSET_SUIT = list(0, 1), OFFSET_S_STORE = list(0, 1), ROGUE_OFFSET_CLOAK = list(0, 1), ROGUE_OFFSET_MOUTH = list(0, 1), ROGUE_OFFSET_RING = list(0, 1), ROGUE_OFFSET_SHIRT = list(0, 1), ROGUE_OFFSET_WRISTS = list(0, 1)),
		"f" = list(OFFSET_BACK = list(0, 1), OFFSET_BELT = list(0, 1), OFFSET_EARS = list(0, 1), OFFSET_FACE = list(0, 1), OFFSET_FACEMASK = list(0, 1), OFFSET_GLASSES = list(0, 1), OFFSET_GLOVES = list(0, 1), OFFSET_HEAD = list(0, 1), OFFSET_HELD = list(0, 1), OFFSET_NECK = list(0, 1), OFFSET_SUIT = list(0, 1), OFFSET_S_STORE = list(0, 1), OFFSET_UNIFORM = list(0, 1), ROGUE_OFFSET_CLOAK = list(0, 1), ROGUE_OFFSET_MOUTH = list(0, 1), ROGUE_OFFSET_RING = list(0, 1), ROGUE_OFFSET_SHIRT = list(0, 1), ROGUE_OFFSET_WRISTS = list(0, 1)),
		)
	rogue_race_sheet = /datum/attribute_holder/sheet/rockhill_race/rogue_orc
	rogue_worn_sex = "m"
	rogue_skin_tones = list("Shellcrest" = "#3C5166", "Bloodaxe" = "#A84C4F", "Splitjaw" = "#50715C", "Blackhammer" = "#1B2B21", "Skullseeker" = "#3D3725", "Crescent Fang" = "#8A8951", "Murkwalker" = "#716646", "Shatterhorn" = "#D6D5E2", "Spirit Crusher" = "#9D4D62")
	rogue_skin_wording = "Clan"
	rogue_description = "This is made for events. You shouldn't be able to use this as a normal person, For courtesies sake however, I've tried to half-assedly balance it for use by players (+1 Strength, +1 Constitution, -1 Intelligence, -1 Speed)"
	rogue_lore = list(
		"This is made for events. You shouldn't be able to use this as a normal person, For courtesies sake however, I've tried to half-assedly balance it for use by players (+1 Strength, +1 Constitution, -1 Intelligence, -1 Speed)",
		)

/datum/species/rogue_drow
	rogue_offsets = list(
		"m" = list(OFFSET_GLOVES = list(0, 1), OFFSET_SUIT = list(0, 1), OFFSET_S_STORE = list(0, 1), ROGUE_OFFSET_CLOAK = list(0, 1), ROGUE_OFFSET_SHIRT = list(0, 1), ROGUE_OFFSET_WRISTS = list(0, 1)),
		"f" = list(OFFSET_BACK = list(0, -1), OFFSET_BELT = list(0, -1), OFFSET_EARS = list(0, -1), OFFSET_FACE = list(0, -1), OFFSET_FACEMASK = list(0, -1), OFFSET_GLASSES = list(0, -1), OFFSET_HEAD = list(0, -1), OFFSET_NECK = list(0, -1), ROGUE_OFFSET_MOUTH = list(0, -1), ROGUE_OFFSET_RING = list(0, -1)),
		)
	rogue_race_sheet = /datum/attribute_holder/sheet/rockhill_race/rogue_drow
	rogue_race_traits = list(TRAIT_WEBWALK, TRAIT_DARKVISION)
	rogue_worn_sex = "f"
	rogue_skin_tones = list("Commorah" = "#9796A9", "Gloomhaven" = "#897489", "Darkpila" = "#938F9C", "Sshanntynlan" = "#746E6E", "Llurth Dreir" = "#6A616D", "Tafravma" = "#5F5F70", "Yuethindrynn" = "#2F2F38", "Koredynn" = "#32356B", "Aiseedrynn" = "#A3C1C9", "Grenduskra" = "#8B8585", "Hun'sek" = "#6C6799")
	rogue_skin_wording = "Origin City-State"
	rogue_description = "\"Elf\" is a catch-all term used for tall, pointy-eared humanoids who can trace their heritage to the ancient and mysterious Snow Elves. This species of elf, less frequently seen, are also referred to by some as \"drow,\" and have several key differences that set them apart from their more well-known and surface-dwelling kin. Chief among these differences are their dark complexions and origins from the Underdark; a massive subterranean landscape made up of a vast network of interconnected caves, caverns and tunnels. In this world hidden deep beneath the soil are several dark elven cities who exist and function far from the reaches of the rest of the surface-dwelling societies. These are a large part of what has earned the dark elves their notoriety, for in these cities the worship of the ascendant pantheon is normalized, and their cruel and bloodthirsty culture reflects this. It was rare to see dark elves outside of their underground homes, but in recent years, more and more of them have fled to the surface. The reasons for each dark elf fleeing the Underdark vary depending on the individual, such as a kinder heart fleeing from a brutal society that scorns them for their less cruel nature. However, not every dark elf seen on the surface can be safely assumed as kind, for some leave the Underdark simply to find their own greater heights of power. (+1 Intellect, +1 Perception, Webwalker and Dark Vision Traits)"
	rogue_lore = list(
		"\"Elf\" is a catch-all term used for tall, pointy-eared humanoids who can trace their heritage to the ancient and mysterious Snow Elves. This species of elf, less frequently seen, are also referred to by some as \"drow,\" and have several key differences that set them apart from their more well-known and surface-dwelling kin. Chief among these differences are their dark complexions and origins from the Underdark; a massive subterranean landscape made up of a vast network of interconnected caves, caverns and tunnels. In this world hidden deep beneath the soil are several dark elven cities who exist and function far from the reaches of the rest of the surface-dwelling societies. These are a large part of what has earned the dark elves their notoriety, for in these cities the worship of the ascendant pantheon is normalized, and their cruel and bloodthirsty culture reflects this. It was rare to see dark elves outside of their underground homes, but in recent years, more and more of them have fled to the surface. The reasons for each dark elf fleeing the Underdark vary depending on the individual, such as a kinder heart fleeing from a brutal society that scorns them for their less cruel nature. However, not every dark elf seen on the surface can be safely assumed as kind, for some leave the Underdark simply to find their own greater heights of power.",
		"(+1 Intellect, +1 Perception, Webwalker and Dark Vision Traits)",
		)

/datum/species/rogue_goblin
	rogue_offsets = list(
		"m" = list(OFFSET_HELD = list(0, -4)),
		"f" = list(OFFSET_HELD = list(0, -4)),
		)
	rogue_race_traits = list(TRAIT_RESISTCOLD, TRAIT_RESISTHIGHPRESSURE, TRAIT_RESISTLOWPRESSURE, TRAIT_RADIMMUNE, TRAIT_CRITICAL_WEAKNESS, TRAIT_NASTY_EATER, TRAIT_LEECHIMMUNE)

/datum/species/rogue_goblin/cave
	rogue_offsets = list(
		"m" = list(OFFSET_HELD = list(0, -4)),
		"f" = list(OFFSET_HELD = list(0, -4)),
		)
	rogue_race_traits = list(TRAIT_RESISTCOLD, TRAIT_RESISTHIGHPRESSURE, TRAIT_RESISTLOWPRESSURE, TRAIT_RADIMMUNE, TRAIT_CRITICAL_WEAKNESS, TRAIT_NASTY_EATER, TRAIT_LEECHIMMUNE)

/datum/species/rogue_goblin/hell
	rogue_offsets = list(
		"m" = list(OFFSET_HELD = list(0, -4)),
		"f" = list(OFFSET_HELD = list(0, -4)),
		)
	rogue_race_traits = list(TRAIT_RESISTCOLD, TRAIT_RESISTHIGHPRESSURE, TRAIT_RESISTLOWPRESSURE, TRAIT_RADIMMUNE, TRAIT_CRITICAL_WEAKNESS, TRAIT_NASTY_EATER, TRAIT_LEECHIMMUNE)

/datum/species/rogue_goblin/sea
	rogue_offsets = list(
		"m" = list(OFFSET_HELD = list(0, -4)),
		"f" = list(OFFSET_HELD = list(0, -4)),
		)
	rogue_race_traits = list(TRAIT_RESISTCOLD, TRAIT_RESISTHIGHPRESSURE, TRAIT_RESISTLOWPRESSURE, TRAIT_RADIMMUNE, TRAIT_CRITICAL_WEAKNESS, TRAIT_NASTY_EATER, TRAIT_LEECHIMMUNE)

/datum/species/rogue_goblin/moon
	rogue_offsets = list(
		"m" = list(OFFSET_HELD = list(0, -4)),
		"f" = list(OFFSET_HELD = list(0, -4)),
		)
	rogue_race_traits = list(TRAIT_RESISTCOLD, TRAIT_RESISTHIGHPRESSURE, TRAIT_RESISTLOWPRESSURE, TRAIT_RADIMMUNE, TRAIT_CRITICAL_WEAKNESS, TRAIT_NASTY_EATER, TRAIT_LEECHIMMUNE)

/datum/species/rogue_goblinp
	rogue_offsets = list(
		"m" = list(OFFSET_BACK = list(0, -4), OFFSET_BELT = list(0, -4), OFFSET_EARS = list(0, -4), OFFSET_FACE = list(0, -5), OFFSET_FACEMASK = list(0, -5), OFFSET_GLASSES = list(0, -5), OFFSET_GLOVES = list(0, -4), OFFSET_HEAD = list(0, -4), OFFSET_HELD = list(0, -3), OFFSET_NECK = list(0, -4), ROGUE_OFFSET_MOUTH = list(0, -4), ROGUE_OFFSET_RING = list(0, -4), ROGUE_OFFSET_WRISTS = list(0, -4)),
		"f" = list(OFFSET_BACK = list(0, -5), OFFSET_BELT = list(0, -4), OFFSET_EARS = list(0, -5), OFFSET_FACE = list(0, -5), OFFSET_FACEMASK = list(0, -5), OFFSET_GLASSES = list(0, -5), OFFSET_GLOVES = list(0, -4), OFFSET_HEAD = list(0, -5), OFFSET_HELD = list(0, -4), OFFSET_NECK = list(0, -5), ROGUE_OFFSET_MOUTH = list(0, -5), ROGUE_OFFSET_RING = list(0, -5), ROGUE_OFFSET_WRISTS = list(0, -4)),
		)
	rogue_race_sheet = /datum/attribute_holder/sheet/rockhill_race/rogue_goblinp
	rogue_race_traits = list(TRAIT_DARKVISION)
	rogue_worn_sex = "f"
	rogue_skin_tones = list("Ochre" = "#968127", "Meadow" = "#909630", "Olive" = "#6B8A08", "Green" = "#4C6835", "Moss" = "#43533E", "Taiga" = "#373F29", "Bronze" = "#725237", "Red" = "#87312A", "Frost" = "#6486B0", "Abyss" = "#2A6986", "Teal" = "#008080", "Hadal" = "#24353D", "Pale" = "#C9C9C9")
	rogue_skin_wording = "Skin Color"
	rogue_clothes_id = "dwarf"
	rogue_description = "A clever and stubborn nature are two charitable qualities of a goblin - scheming and selfish are less so. The Fell Gods use them as an avatar of malice, sending out mindless, enthralled waves of the creatures to attack civilization from lunar portals. It leaves the typical goblinoid to cloister in their hidden away tribes, stealing from the scraps out of fear of reprisal while shooing away outsiders. The cities of Man typically shun them, but it's not unheard of to see one pushing their luck in a town square or out on a well-traveled road, as even the most backwater peasant can tell the difference between a sapient one and portal-spawn. Usually. (+1 Speed, Dark Vision Trait)"
	rogue_lore = list(
		"A clever and stubborn nature are two charitable qualities of a goblin - scheming and selfish are less so. The Fell Gods use them as an avatar of malice, sending out mindless, enthralled waves of the creatures to attack civilization from lunar portals. It leaves the typical goblinoid to cloister in their hidden away tribes, stealing from the scraps out of fear of reprisal while shooing away outsiders. The cities of Man typically shun them, but it's not unheard of to see one pushing their luck in a town square or out on a well-traveled road, as even the most backwater peasant can tell the difference between a sapient one and portal-spawn. Usually.",
		"(+1 Speed, Dark Vision Trait)",
		)

/datum/attribute_holder/sheet/rockhill_race/rogue_orc
	raw_attribute_list = list(
		ROGUE_STAT_CONSTITUTION = 1,
		ROGUE_STAT_INTELLIGENCE = -1,
		ROGUE_STAT_SPEED = -1,
		ROGUE_STAT_STRENGTH = 1,
		)

/datum/attribute_holder/sheet/rockhill_race/rogue_drow
	raw_attribute_list = list(
		ROGUE_STAT_INTELLIGENCE = 1,
		ROGUE_STAT_PERCEPTION = 1,
		)

/datum/attribute_holder/sheet/rockhill_race/rogue_goblinp
	raw_attribute_list = list(
		ROGUE_STAT_SPEED = 1,
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
