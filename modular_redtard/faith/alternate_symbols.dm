/// The holy symbols and idols of the faiths Vibelin brought that Ratwood and Azure Peak lack (faith.dm): Alternate Beliefs
/// and the Archdevils. Vibelin gives the Great Hunt its bone amulet (patrons/alternate.dm associated_objects, the recipe of
/// quality_of_crafting/crafting.dm, the amulet the porter brought in items_vibelin/), and no idol; the Archdevils hear their
/// followers anywhere (patrons/archdevils.dm can_pray()), so they need neither. The Wurm has nothing at Vibelin: it gets
/// one symbol and one idol here, on sprites of the sources - a wooden amulet of Pestra (Azure Peak), whose belief it
/// twists, and the skull on a stake of Ratwood's tallstructure.dmi, which no source uses. The Black Briar, a patron no one
/// picks (Vibelin: joined by its curse, "todo: unique prayer system"), stays without one.

/// The Wurm's holy symbol: Azure Peak's wooden amulet of Pestra, carved for the Wurm.
/obj/item/clothing/neck/roguetown/psicross/pestra/wood/wurm
	name = "wurm amulet"
	desc = "A wooden amulet of Pestra, its carving gnawed into the coils of a wurm. Those who wear it live for the Wurm, and will die for it."

/// The Wurm's idol: a skull on a stake (Ratwood's skullstick sprite).
/obj/structure/fluff/psycross/crafted/wurm
	name = "wurm idol"
	desc = "A skull set on a stake, scarred and seared. The faithful of the Wurm pray before such marks of their suffering."
	icon_state = "skullstick"

// --- How they are made

/// Vibelin /datum/repeatable_crafting_recipe/crafting/bone_amulet: bones and sinew whittled with a knife.
/datum/crafting_recipe/roguetown/survival/bone_amulet
	// Vibelin
	name = "bone amulet"
	result = /obj/item/clothing/neck/roguetown/vibelin/psycross/great_hunt
	reqs = list(/obj/item/alch/bone = 2, /obj/item/alch/sinew = 3)
	tool_paths = list(/obj/item/rogueweapon/huntingknife)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/// As Azure Peak's wooden amulets of the gods (craft_recipes.dm woodpestracross).
/datum/crafting_recipe/roguetown/survival/woodwurmcross
	name = "wurm amulet"
	result = /obj/item/clothing/neck/roguetown/psicross/pestra/wood/wurm
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/grown/log/tree/stick = 2)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting

/// As Ratwood's wooden cross (craft_recipes.dm psycrss), a skull for its beam.
/datum/crafting_recipe/roguetown/structure/wurm_idol
	name = "wurm idol"
	result = /obj/structure/fluff/psycross/crafted/wurm
	reqs = list(/obj/item/grown/log/tree/stake = 1, /obj/item/skull = 1)
	category = "Crafting"
	rogue_skill = /datum/attribute/skill/craft/crafting
	rogue_verb = "constructs"
	rogue_verb_simple = "construct"
	rogue_sound = 'modular_redtard/rockhill/sound/foley/Building-01.ogg'
