// Written by modular_redtard/tools/port_twilight_items.py from modular_redtard/items_twilight/port.json; do not edit by hand.
// Items only Twilight Axis has (the K1v lists), each flattened through Twilight Axis's own inheritance. Their numbers
// (integrity, force, defense, strength) are not here: they are in the private config/redtard_private/mechanics/items.txt.
// Other items only Twilight Axis has.

/obj/item/alch/silverdust_blessed
	name = "blessed silver dust"
	desc = ""
	icon = 'modular_redtard/items_twilight/assets/modular_twilight_axis/firearms/icons/misc.dmi'
	icon_state = "silverdust_blessed"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = NONE
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)

/obj/item/flowercrown/rosa/resprite
	name = "crown of eora flowers"
	desc = ""
	icon = 'modular_redtard/rockhill/icons/modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	icon_state = "flower_crown_eora"
	w_class = WEIGHT_CLASS_NORMAL
	worn_icon = 'modular_redtard/rockhill/icons/modular_twilight_axis/icons/roguetown/clothing/onmob/head.dmi'
	worn_icon_state = "flower_crown_eora"
	slot_flags = ITEM_SLOT_HEAD | ITEM_SLOT_MASK
	body_parts_covered = NONE
	alternate_worn_layer = (HANDS_LAYER - 0.1)
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 64
	rogue_grid_height = 32
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)

/obj/item/ingot/steel/zizo
	name = "cursed ancient ingot"
	desc = "There are legends about the appearance of this ingot..."
	icon = 'modular_redtard/items_twilight/assets/modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sprites/zingot.dmi'
	icon_state = "zalloy"
	w_class = WEIGHT_CLASS_NORMAL
	worn_icon_state = null
	slot_flags = NONE
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 64
	rogue_grid_height = 32
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use, /datum/intent/food)

/obj/item/melee/new_touch_attack/asperges
	name = "\improper rite of asperges"
	desc = "High Five?"
	icon = 'modular_redtard/rockhill/icons/mob/roguehudgrabs.dmi'
	icon_state = "grabbing_greyscale"
	w_class = WEIGHT_CLASS_HUGE
	worn_icon_state = null
	slot_flags = NONE
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	associated_skill = /datum/attribute/skill/magic/holy
	possible_item_intents = list(/datum/intent/fill)

/obj/item/quicksilver/TA/luxinfused
	name = "absolving silver"
	desc = "A daring blend of trace amounts of purifying lux, aberrant blood, and divine silver. This panacea fortifies the anointed's body with blessed silverdust, protecting them from the curses of vampyrism and lycanthropy."
	icon = 'modular_redtard/rockhill/icons/modular_azurepeak/icons/obj/items/quicksilver.dmi'
	icon_state = "quicksilverlux"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = NONE
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)

/obj/item/roguekey/folding_peddler
	name = "peddler key"
	desc = "A small key cut for a folding PEDDLER."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "rustkey"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_NECK
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 32
	rogue_grid_height = 32
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	lockid = null

/obj/item/roguekey/mage/driderboss
	name = "Drider's key"
	desc = "A strange key the Drider dropped."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "eyekey"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_NECK
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 32
	rogue_grid_height = 32
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	lockid = "driderboss"

/obj/item/roguekey/mage/forgottenking
	name = "forgotten king' key"
	desc = "An offputting key the King dropped."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "toothkey"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_NECK
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 32
	rogue_grid_height = 32
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	lockid = "forgottenking"

/obj/item/roguekey/mansion
	name = "Rockhill Mansion"
	desc = "This fancy key opens the doors of the Rockhill mansion."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "cheesekey"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_NECK
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 32
	rogue_grid_height = 32
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	lockid = "rockhill_mansion"

/obj/item/roguekey/mayor
	name = "Mayor key"
	desc = "This key opens the Mayor office."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "cheesekey"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_NECK
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 32
	rogue_grid_height = 32
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	lockid = "mayor"

/obj/item/roguekey/rh_mage_1
	name = "Magicians quarter I"
	desc = "This key opens door in Magician Tower."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "greenkey"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_NECK
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 32
	rogue_grid_height = 32
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	lockid = "rh_mage_1"

/obj/item/roguekey/rh_mage_2
	name = "Magicians quarter II"
	desc = "This key opens door in Magician Tower."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "greenkey"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_NECK
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 32
	rogue_grid_height = 32
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	lockid = "rh_mage_2"

/obj/item/roguekey/rh_mage_3
	name = "Magicians quarter III"
	desc = "This key opens door in Magician Tower."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "greenkey"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_NECK
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 32
	rogue_grid_height = 32
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	lockid = "rh_mage_3"

/obj/item/roguekey/rh_mage_4
	name = "Magicians quarter IV"
	desc = "This key opens door in Magician Tower."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "greenkey"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_NECK
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 32
	rogue_grid_height = 32
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	lockid = "rh_mage_4"

/obj/item/roguekey/townsheriff
	name = "Sheriff key"
	desc = "This key opens the Sheriff office."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "spikekey"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_NECK
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 32
	rogue_grid_height = 32
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	lockid = "townsheriff"

/obj/item/seeds/melon
	name = "seeds"
	desc = "The distilled essence of agriculture. Skilled hands can plant these into soil and nurture them into bristling crops, or roast them for a delicious little snack."
	icon = 'modular_redtard/rockhill/icons/obj/hydroponics/seeds.dmi'
	icon_state = "seed"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = NONE
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)

/obj/item/sharpener/ignited
	name = "ignited stone"
	desc = "simple whetstone with sparks from fire essentia"
	icon = 'modular_redtard/items_twilight/assets/modular_twilight_axis/firearms/icons/magic/bstuff.dmi'
	icon_state = "istone"
	w_class = WEIGHT_CLASS_NORMAL
	worn_icon_state = null
	slot_flags = NONE
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)

/obj/item/signal_horn/vanguard_battle
	name = "vanguard battle horn"
	desc = "A horn used by the Vanguard bog patrols. Blowing it attracts the attention of various creechurs and rapscallions, enabling the Vanguard to clear them out."
	icon = 'modular_redtard/rockhill/icons/modular_hearthstone/icons/obj/items/signalhorn.dmi'
	icon_state = "signalhorn"
	w_class = WEIGHT_CLASS_NORMAL
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_NECK
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 32
	rogue_grid_height = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)

/obj/item/storage/backpack/rogue/backpack_trader
	name = "traders chests"
	desc = "Bulky, heavy, enormous. You're the rat in the world with a lot of shinies in your pockets for sell."
	icon = 'modular_redtard/rockhill/icons/modular_twilight_axis/icons/roguetown/clothing/back.dmi'
	icon_state = "backpack_trader"
	w_class = WEIGHT_CLASS_BULKY
	worn_icon = 'modular_redtard/rockhill/icons/modular_twilight_axis/icons/roguetown/clothing/onmob/back.dmi'
	worn_icon_state = "backpack_trader"
	slot_flags = ITEM_SLOT_BACK
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	sewrepair = TRUE
	sellprice = 150

/obj/item/storage/backpack/rogue/satchel/citywatch
	name = "watchman's satchel"
	desc = "Modest, easy on the shoulders, and holds a respectable amount."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/clothing/storage.dmi'
	icon_state = "satchel"
	w_class = WEIGHT_CLASS_BULKY
	worn_icon_state = "satchel"
	slot_flags = ITEM_SLOT_BACK
	body_parts_covered = NONE
	alternate_worn_layer = ROGUE_UNDER_CLOAK_LAYER
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	sewrepair = TRUE

/obj/item/storage/belt/rogue/leather/aria
	name = "aria belt"
	desc = "A pair of golden black silks to cover legs"
	icon = 'modular_redtard/items_twilight/assets/modular_twilight_axis/icons/clothing/aria.dmi'
	icon_state = "ariabelt"
	w_class = WEIGHT_CLASS_NORMAL
	worn_icon = 'modular_redtard/rockhill/icons/blank_worn.dmi'
	worn_icon_state = null
	slot_flags = ITEM_SLOT_BELT
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 64
	rogue_grid_height = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	sewrepair = TRUE
	rogue_female_worn = TRUE

/obj/item/storage/belt/rogue/leather/citywatch
	name = "watchman's belt"
	desc = "A fine leather strap notched with holes for a buckle to secure itself."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/clothing/belts.dmi'
	icon_state = "leather"
	w_class = WEIGHT_CLASS_NORMAL
	worn_icon = 'modular_redtard/items_twilight/assets/icons/roguetown/clothing/onmob/belts.dmi'
	worn_icon_state = "leather"
	slot_flags = ITEM_SLOT_BELT
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 64
	rogue_grid_height = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	sewrepair = TRUE
	rogue_female_worn = TRUE

/obj/item/storage/belt/rogue/leather/overseer
	name = "confessor belt pouch"
	icon = 'modular_redtard/rockhill/icons/roguetown/clothing/special/overseer/overseer.dmi'
	icon_state = "overseerbelt"
	w_class = WEIGHT_CLASS_NORMAL
	worn_icon = 'modular_redtard/items_twilight/assets/modular_twilight_axis/icons/roguetown/clothing/inquisition_overseer/onmob/overseer_onmob.dmi'
	worn_icon_state = "overseerbelt"
	slot_flags = ITEM_SLOT_BELT
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 64
	rogue_grid_height = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	sewrepair = TRUE
	rogue_female_worn = TRUE

/obj/item/storage/belt/rogue/leather/twilight_holsterbelt/black
	name = "black holster belt"
	icon = 'modular_redtard/items_twilight/assets/modular_twilight_axis/firearms/icons/obj_belts_black.dmi'
	icon_state = "holsterbelt"
	w_class = WEIGHT_CLASS_NORMAL
	worn_icon = 'modular_redtard/items_twilight/assets/modular_twilight_axis/firearms/icons/onmob_belts_black.dmi'
	worn_icon_state = "holsterbelt"
	slot_flags = ITEM_SLOT_BELT
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 96
	rogue_grid_height = 96
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	sewrepair = TRUE
	rogue_female_worn = TRUE

/obj/item/storage/belt/rogue/leather/twilight_holsterbelt/blackpowder
	name = "blackpowder order holster belt"
	icon = 'modular_redtard/items_twilight/assets/modular_twilight_axis/firearms/icons/obj_belts_blackpowder.dmi'
	icon_state = "holsterbelt"
	w_class = WEIGHT_CLASS_NORMAL
	worn_icon = 'modular_redtard/items_twilight/assets/modular_twilight_axis/firearms/icons/onmob_belts_blackpowder.dmi'
	worn_icon_state = "holsterbelt"
	slot_flags = ITEM_SLOT_BELT
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 96
	rogue_grid_height = 96
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	sewrepair = TRUE
	rogue_female_worn = TRUE

/obj/item/storage/belt/rogue/leather/twilight_holsterbelt/commandant
	name = "officer's belt"
	desc = "A durable and reliable officer's belt, made to endure years of campaigning."
	icon = 'modular_redtard/items_twilight/assets/modular_twilight_axis/icons/clothing/commandant_set.dmi'
	icon_state = "holsterbelt"
	w_class = WEIGHT_CLASS_NORMAL
	worn_icon = 'modular_redtard/items_twilight/assets/modular_twilight_axis/icons/clothing/onmob/commandant_set.dmi'
	worn_icon_state = "holsterbelt"
	slot_flags = ITEM_SLOT_BELT
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 96
	rogue_grid_height = 96
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	sewrepair = TRUE
	rogue_female_worn = TRUE

/obj/item/storage/belt/rogue/leather/twilight_holsterbelt/hussar
	name = "hussar sash"
	icon = 'modular_redtard/items_twilight/assets/modular_twilight_axis/icons/clothing/hussar_set.dmi'
	icon_state = "hussar_sash"
	w_class = WEIGHT_CLASS_NORMAL
	worn_icon = 'modular_redtard/items_twilight/assets/modular_twilight_axis/icons/clothing/onmob/hussar_set.dmi'
	worn_icon_state = "hussar_sash"
	slot_flags = ITEM_SLOT_BELT
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 96
	rogue_grid_height = 96
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	sewrepair = TRUE
	rogue_female_worn = TRUE

/obj/item/storage/belt/rogue/leather/twilight_holsterbelt/lord
	name = "plaque holster belt"
	icon = 'modular_redtard/items_twilight/assets/modular_twilight_axis/firearms/icons/obj_belts_royal.dmi'
	icon_state = "holsterbelt"
	w_class = WEIGHT_CLASS_NORMAL
	worn_icon = 'modular_redtard/items_twilight/assets/modular_twilight_axis/firearms/icons/onmob_belts_royal.dmi'
	worn_icon_state = "holsterbelt"
	slot_flags = ITEM_SLOT_BELT
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 96
	rogue_grid_height = 96
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/armorsmithing
	sewrepair = FALSE
	sellprice = 50
	rogue_female_worn = TRUE

/obj/item/storage/belt/rogue/pouch/i_scrap
	name = "pouch"
	desc = "A small sack with a drawstring that allows it to be worn around the neck. Or at the hips, provided you have a belt."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/clothing/storage.dmi'
	icon_state = "pouch"
	w_class = WEIGHT_CLASS_NORMAL
	worn_icon_state = "pouch"
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_NECK | ITEM_SLOT_ROGUE_CLOAK
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 32
	rogue_grid_height = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	sewrepair = TRUE

/obj/item/storage/belt/rogue/pouch/kronas
	name = "pouch"
	desc = "A small sack with a drawstring that allows it to be worn around the neck. Or at the hips, provided you have a belt."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/clothing/storage.dmi'
	icon_state = "pouch"
	w_class = WEIGHT_CLASS_NORMAL
	worn_icon_state = "pouch"
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_NECK | ITEM_SLOT_ROGUE_CLOAK
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 32
	rogue_grid_height = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	sewrepair = TRUE

/obj/item/storage/belt/rogue/pouch/s_scrap
	name = "pouch"
	desc = "A small sack with a drawstring that allows it to be worn around the neck. Or at the hips, provided you have a belt."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/clothing/storage.dmi'
	icon_state = "pouch"
	w_class = WEIGHT_CLASS_NORMAL
	worn_icon_state = "pouch"
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_NECK | ITEM_SLOT_ROGUE_CLOAK
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 32
	rogue_grid_height = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	sewrepair = TRUE

/obj/item/storage/belt/rogue/pouch/shucoin
	name = "pouch"
	desc = "A small sack with a drawstring that allows it to be worn around the neck. Or at the hips, provided you have a belt."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/clothing/storage.dmi'
	icon_state = "pouch"
	w_class = WEIGHT_CLASS_NORMAL
	worn_icon_state = "pouch"
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_NECK | ITEM_SLOT_ROGUE_CLOAK
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 32
	rogue_grid_height = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	sewrepair = TRUE

/obj/item/storage/belt/rogue/pouch/t1_oint
	name = "pouch"
	desc = "A small sack with a drawstring that allows it to be worn around the neck. Or at the hips, provided you have a belt."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/clothing/storage.dmi'
	icon_state = "pouch"
	w_class = WEIGHT_CLASS_NORMAL
	worn_icon_state = "pouch"
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_NECK | ITEM_SLOT_ROGUE_CLOAK
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 32
	rogue_grid_height = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	sewrepair = TRUE

/obj/item/storage/belt/rogue/pouch/t2_oint
	name = "pouch"
	desc = "A small sack with a drawstring that allows it to be worn around the neck. Or at the hips, provided you have a belt."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/clothing/storage.dmi'
	icon_state = "pouch"
	w_class = WEIGHT_CLASS_NORMAL
	worn_icon_state = "pouch"
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_NECK | ITEM_SLOT_ROGUE_CLOAK
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_grid_width = 32
	rogue_grid_height = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	sewrepair = TRUE
