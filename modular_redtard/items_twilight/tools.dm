// Written by modular_redtard/tools/port_twilight_items.py from modular_redtard/items_twilight/port.json; do not edit by hand.
// Items only Twilight Axis has (the K1v lists), each flattened through Twilight Axis's own inheritance. Their numbers
// (integrity, force, defense, strength) are not here: they are in the private config/redtard_private/mechanics/items.txt.
// Tools only Twilight Axis has.

/obj/item/flashlight/flare/torch/lantern/scrap
	name = "iron scrap lamptern"
	desc = "A light to guide the way."
	icon = 'modular_redtard/items_twilight/assets/modular_twilight_axis/icons/roguetown/items/lighting.dmi'
	icon_state = "lamp"
	w_class = WEIGHT_CLASS_NORMAL
	worn_icon_state = "torch"
	slot_flags = ITEM_SLOT_POCKETS
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
	possible_item_intents = list(/datum/intent/use, /datum/intent/hit)

/obj/item/rope/chain/fake/ice
	name = "ice chains"
	desc = "Magical ice freezing your wrists together."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/misc.dmi'
	icon_state = "chain"
	w_class = WEIGHT_CLASS_SMALL
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_ROGUE_WRISTS
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
	possible_item_intents = list(/datum/intent/tie, /datum/intent/whips)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	sewrepair = FALSE

/obj/item/storage/keyring/apothecaryenigma
	name = "keyring"
	desc = "A ring of keys, stowable on the wrist and hip. The finest jewelry that a manor's guard could ask for."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "keyring0"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_NECK | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_ROGUE_WRISTS
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	rockhill_keys = list(/obj/item/roguekey/apothecary, /obj/item/roguekey/keeper)

/obj/item/storage/keyring/apprenticeenigma
	name = "keyring"
	desc = "A ring of keys, stowable on the wrist and hip. The finest jewelry that a manor's guard could ask for."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "keyring0"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_NECK | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_ROGUE_WRISTS
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	rockhill_keys = list(/obj/item/roguekey/manor, /obj/item/roguekey/university)

/obj/item/storage/keyring/azeb
	name = "keyring"
	desc = "A ring of keys, stowable on the wrist and hip. The finest jewelry that a manor's guard could ask for."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "keyring0"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_NECK | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_ROGUE_WRISTS
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	rockhill_keys = list(/obj/item/roguekey/garrison, /obj/item/roguekey/walls, /obj/item/roguekey/dungeon, /obj/item/roguekey/armory, /obj/item/roguekey/warden)

/obj/item/storage/keyring/azebagha
	name = "keyring"
	desc = "A ring of keys, stowable on the wrist and hip. The finest jewelry that a manor's guard could ask for."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "keyring0"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_NECK | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_ROGUE_WRISTS
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	rockhill_keys = list(/obj/item/roguekey/garrison, /obj/item/roguekey/walls, /obj/item/roguekey/dungeon, /obj/item/roguekey/armory, /obj/item/roguekey/warden, /obj/item/roguekey/sergeant, /obj/item/roguekey/manor, /obj/item/roguekey/marshal)

/obj/item/storage/keyring/bailiff
	name = "keyring"
	desc = "A ring of keys, stowable on the wrist and hip. The finest jewelry that a manor's guard could ask for."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "keyring0"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_NECK | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_ROGUE_WRISTS
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing

/obj/item/storage/keyring/cataphract
	name = "keyring"
	desc = "A ring of keys, stowable on the wrist and hip. The finest jewelry that a manor's guard could ask for."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "keyring0"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_NECK | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_ROGUE_WRISTS
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	rockhill_keys = list(/obj/item/roguekey/garrison, /obj/item/roguekey/walls, /obj/item/roguekey/manor, /obj/item/roguekey/armory, /obj/item/roguekey/knight)

/obj/item/storage/keyring/courtphysician
	name = "keyring"
	desc = "A ring of keys, stowable on the wrist and hip. The finest jewelry that a manor's guard could ask for."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "keyring0"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_NECK | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_ROGUE_WRISTS
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	rockhill_keys = list(/obj/item/roguekey/manor, /obj/item/roguekey/courtphysician, /obj/item/roguekey/apothecary, /obj/item/roguekey/keeper)

/obj/item/storage/keyring/harem
	name = "keyring"
	desc = "A ring of keys, stowable on the wrist and hip. The finest jewelry that a manor's guard could ask for."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "keyring0"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_NECK | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_ROGUE_WRISTS
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	rockhill_keys = list(/obj/item/roguekey/royal, /obj/item/roguekey/manor, /obj/item/roguekey/heir)

/obj/item/storage/keyring/knightenigma
	name = "keyring"
	desc = "A ring of keys, stowable on the wrist and hip. The finest jewelry that a manor's guard could ask for."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "keyring0"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_NECK | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_ROGUE_WRISTS
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	rockhill_keys = list(/obj/item/roguekey/garrison, /obj/item/roguekey/walls, /obj/item/roguekey/manor, /obj/item/roguekey/knight, /obj/item/roguekey/armory)

/obj/item/storage/keyring/magicianenigma
	name = "keyring"
	desc = "A ring of keys, stowable on the wrist and hip. The finest jewelry that a manor's guard could ask for."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "keyring0"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_NECK | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_ROGUE_WRISTS
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	rockhill_keys = list(/obj/item/roguekey/manor, /obj/item/roguekey/mage, /obj/item/roguekey/university)

/obj/item/storage/keyring/mayor
	name = "keyring"
	desc = "A ring of keys, stowable on the wrist and hip. The finest jewelry that a manor's guard could ask for."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "keyring0"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_NECK | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_ROGUE_WRISTS
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	rockhill_keys = list(/obj/item/roguekey/walls)

/obj/item/storage/keyring/rockhillmansion
	name = "keyring"
	desc = "A ring of keys, stowable on the wrist and hip. The finest jewelry that a manor's guard could ask for."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "keyring0"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_NECK | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_ROGUE_WRISTS
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing

/obj/item/storage/keyring/slave
	name = "keyring"
	desc = "A ring of keys, stowable on the wrist and hip. The finest jewelry that a manor's guard could ask for."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "keyring0"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_NECK | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_ROGUE_WRISTS
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	rockhill_keys = list(/obj/item/roguekey/manor, /obj/item/roguekey/dungeon)

/obj/item/storage/keyring/slavemaster
	name = "keyring"
	desc = "A ring of keys, stowable on the wrist and hip. The finest jewelry that a manor's guard could ask for."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "keyring0"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_NECK | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_ROGUE_WRISTS
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	rockhill_keys = list(/obj/item/roguekey/garrison, /obj/item/roguekey/walls, /obj/item/roguekey/manor, /obj/item/roguekey/dungeon)

/obj/item/storage/keyring/vanguard_enigma
	name = "keyring"
	desc = "A ring of keys, stowable on the wrist and hip. The finest jewelry that a manor's guard could ask for."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "keyring0"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_NECK | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_ROGUE_WRISTS
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	rockhill_keys = list(/obj/item/roguekey/warden)

/obj/item/storage/keyring/veteran_d
	name = "keyring"
	desc = "A ring of keys, stowable on the wrist and hip. The finest jewelry that a manor's guard could ask for."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "keyring0"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_NECK | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_ROGUE_WRISTS
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	rockhill_keys = list(/obj/item/roguekey/manor, /obj/item/roguekey/veteran)

/obj/item/storage/keyring/warden_enigma
	name = "keyring"
	desc = "A ring of keys, stowable on the wrist and hip. The finest jewelry that a manor's guard could ask for."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "keyring0"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_NECK | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_ROGUE_WRISTS
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	rockhill_keys = list(/obj/item/roguekey/walls, /obj/item/roguekey/warden)

/obj/item/storage/keyring/watchman
	name = "keyring"
	desc = "A ring of keys, stowable on the wrist and hip. The finest jewelry that a manor's guard could ask for."
	icon = 'modular_redtard/items_twilight/assets/icons/roguetown/items/keys.dmi'
	icon_state = "keyring0"
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = null
	slot_flags = ITEM_SLOT_POCKETS | ITEM_SLOT_NECK | ITEM_SLOT_ROGUE_MOUTH | ITEM_SLOT_ROGUE_WRISTS
	body_parts_covered = NONE
	worn_x_dimension = 32
	worn_y_dimension = 32
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	can_parry = FALSE
	possible_item_intents = list(/datum/intent/use)
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	rockhill_keys = list(/obj/item/roguekey/walls)
