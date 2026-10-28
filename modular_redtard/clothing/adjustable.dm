/// Visors, hoods, masks and coifs that adjust (Ratwood adjustable_clothing component, AdjustClothes() of the armored hood): right
/// click on the worn item raises the visor, lowers the hood, pulls the mask or the coif down. Open, the item shows its "<state>_t"
/// sprite, covers and hides only what its style leaves, bares the face (rogue_face_coverage, see the end of this file) and no longer
/// narrows the wearer's view (block2add, combat/fov.dm); taken off, it closes again. Ratwood says which items adjust in their
/// Initialize(), so the table at the end of this file names them by Ratwood's types; an item whose sheets have no "_t" sprite (the
/// skettle, the psydonic helm, the full coifs) does not adjust.
/datum/rogue_adjust_style
	/// Body parts the open item still covers (Ratwood flags_open, in TG's parts).
	var/open_coverage = NONE
	/// Parts of the face the open item still covers, ROGUE_FACE_* (the face parts of Ratwood flags_open); it never covers more than
	/// it does closed.
	var/open_face = NONE
	/// flags_inv of the open item (Ratwood flags_inv_open).
	var/open_inv = NONE
	var/toggle_sound

/// A raised visor leaves the ears and the hair covered (Ratwood HEAD|EARS|HAIR); eyes, nose and mouth are bare.
/datum/rogue_adjust_style/visor
	open_coverage = HEAD
	open_face = ROGUE_FACE_EARS | ROGUE_FACE_HAIR
	open_inv = HIDEEARS | HIDEHAIR
	toggle_sound = ROGUE_ADJUST_VISOR_SOUND

/// The Otavan helmet hides only the ears when open.
/datum/rogue_adjust_style/visor/ears
	open_inv = HIDEEARS

/// The visored sallet hides only the hair when open.
/datum/rogue_adjust_style/visor/hair
	open_inv = HIDEHAIR

/datum/rogue_adjust_style/hood
	open_coverage = NECK
	toggle_sound = ROGUE_ADJUST_CLOAK_SOUND

/// The armored hood lowers without a sound (its own AdjustClothes()).
/datum/rogue_adjust_style/hood/quiet
	toggle_sound = null

/datum/rogue_adjust_style/veil
	open_coverage = NECK | HEAD
	open_face = ROGUE_FACE_EARS | ROGUE_FACE_HAIR
	open_inv = HIDEEARS | HIDEHAIR
	toggle_sound = ROGUE_ADJUST_CLOAK_SOUND

/datum/rogue_adjust_style/mask
	open_coverage = NECK
	toggle_sound = ROGUE_ADJUST_MASK_SOUND

/datum/rogue_adjust_style/bevor
	open_coverage = NECK
	toggle_sound = ROGUE_ADJUST_VISOR_SOUND

/datum/rogue_adjust_style/coif
	open_coverage = NECK

/datum/rogue_adjust_style/coif/chain
	toggle_sound = ROGUE_ADJUST_CHAIN_SOUND

/datum/rogue_adjust_style/coif/mantle
	toggle_sound = ROGUE_ADJUST_MANTLE_SOUND

GLOBAL_LIST_INIT(rogue_adjust_styles, rogue_init_adjust_styles())

/proc/rogue_init_adjust_styles()
	. = list()
	for(var/style_type in subtypesof(/datum/rogue_adjust_style))
		.[style_type] = new style_type

/obj/item/clothing
	/// How the item adjusts, a /datum/rogue_adjust_style path; null - it does not.
	var/rogue_adjust_style
	/// While open: what the closed item covered, hid and blocked, list(body_parts_covered, flags_inv, block2add, rogue_face_coverage);
	/// null - closed.
	var/list/rogue_adjust_closed

/obj/item/clothing/proc/rogue_can_adjust()
	return rogue_adjust_style && icon_exists(worn_icon, "[initial(icon_state)][ROGUE_ADJUSTED_SUFFIX]")

/// Opens or closes the item; FALSE - it already is so. The sprite of the item itself changes only if its icon has the "_t" state; masks
/// rebuild their state from base_icon_state (TG's mask update_icon_state()), so that one is set too.
/obj/item/clothing/proc/rogue_set_adjusted(open)
	var/is_open = !isnull(rogue_adjust_closed)
	if(open == is_open)
		return FALSE
	var/open_state = "[initial(icon_state)][ROGUE_ADJUSTED_SUFFIX]"
	if(open)
		var/datum/rogue_adjust_style/style = GLOB.rogue_adjust_styles[rogue_adjust_style]
		rogue_adjust_closed = list(body_parts_covered, flags_inv, block2add, rogue_face_coverage)
		body_parts_covered = style.open_coverage
		rogue_face_coverage &= style.open_face
		flags_inv = style.open_inv
		block2add = NONE
		worn_icon_state = open_state
	else
		body_parts_covered = rogue_adjust_closed[1]
		flags_inv = rogue_adjust_closed[2]
		block2add = rogue_adjust_closed[3]
		rogue_face_coverage = rogue_adjust_closed[4]
		rogue_adjust_closed = null
		worn_icon_state = initial(worn_icon_state)
	var/shown_state = open && icon_exists(icon, open_state) ? open_state : initial(icon_state)
	icon_state = shown_state
	base_icon_state = shown_state == initial(icon_state) ? initial(base_icon_state) : shown_state
	update_appearance()
	return TRUE

/// Ratwood attack_right on the worn item: open it if closed, close it if open, then redraw the wearer and their view.
/obj/item/clothing/proc/rogue_toggle_adjust(mob/living/carbon/human/wearer)
	if(!rogue_set_adjusted(isnull(rogue_adjust_closed)))
		return FALSE
	var/datum/rogue_adjust_style/style = GLOB.rogue_adjust_styles[rogue_adjust_style]
	if(style.toggle_sound)
		playsound(src, style.toggle_sound, 50, TRUE, -1)
	wearer.refresh_obscured()
	update_slot_icon()
	if((wearer.head == src || wearer.wear_mask == src) && rogue_combat_enabled())
		wearer.rogue_update_fov()
	return TRUE

/// Right click with an empty hand on the item worn on the head, face or neck (not on a hip or in a hand).
/obj/item/clothing/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || !rogue_adjust_style || loc != user || !ishuman(user))
		return
	if(!(user.get_slot_by_item(src) & ROGUE_ADJUST_SLOTS) || !can_use(user) || !rogue_can_adjust())
		return
	rogue_toggle_adjust(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/// Ratwood closes an adjusted item when it is dropped or put on, so it is never worn open from the start.
/obj/item/clothing/dropped(mob/living/user)
	. = ..()
	if(rogue_adjust_closed)
		rogue_set_adjusted(FALSE)

/obj/item/clothing/examine(mob/user)
	. = ..()
	if(rogue_can_adjust())
		. += span_info("Right-click it while wearing it to adjust it.")

// What the face is covered by. Ratwood's helmets that close over the face keep food, drink and bites out and guard the eyes
// (flags_cover HEADCOVERSMOUTH, HEADCOVERSEYES, dropped with a raised visor); the port keeps which parts of the face an item
// covers instead (rogue_face_coverage, rockhill/port_data.dm), so on medieval maps headgear covers the mouth or both eyes while
// it covers them. Masks are left to TG's flags_cover, as Ratwood leaves them.

/mob/living/carbon/human/is_mouth_covered(check_flags = ALL)
	. = ..()
	if(!. && (check_flags & ITEM_SLOT_HEAD) && head && (head.rogue_face_coverage & ROGUE_FACE_MOUTH) && rogue_combat_enabled())
		return head

/mob/living/carbon/human/is_eyes_covered(check_flags = ALL)
	. = ..()
	if(!. && (check_flags & ITEM_SLOT_HEAD) && head && (head.rogue_face_coverage & ROGUE_FACE_EYES) == ROGUE_FACE_EYES && rogue_combat_enabled())
		return head

// Ratwood's adjustable items (Initialize() of each type adds adjustable_clothing with these flags); their children adjust alike.
/obj/item/clothing/head/roguetown/helmet/bascinet/antler
	rogue_adjust_style = /datum/rogue_adjust_style/visor

/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan
	rogue_adjust_style = /datum/rogue_adjust_style/visor

/obj/item/clothing/head/roguetown/helmet/bascinet/pigface
	rogue_adjust_style = /datum/rogue_adjust_style/visor

/obj/item/clothing/head/roguetown/helmet/blacksteel/modern/armet
	rogue_adjust_style = /datum/rogue_adjust_style/visor

/obj/item/clothing/head/roguetown/helmet/heavy/captain
	rogue_adjust_style = /datum/rogue_adjust_style/visor

/obj/item/clothing/head/roguetown/helmet/heavy/holysee
	rogue_adjust_style = /datum/rogue_adjust_style/visor

/obj/item/clothing/head/roguetown/helmet/heavy/knight
	rogue_adjust_style = /datum/rogue_adjust_style/visor

/obj/item/clothing/head/roguetown/helmet/heavy/ordinatorhelm
	rogue_adjust_style = /datum/rogue_adjust_style/visor

/obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm
	rogue_adjust_style = /datum/rogue_adjust_style/visor

/obj/item/clothing/head/roguetown/helmet/heavy/volfplate
	rogue_adjust_style = /datum/rogue_adjust_style/visor

/obj/item/clothing/head/roguetown/helmet/heavy/zizo
	rogue_adjust_style = /datum/rogue_adjust_style/visor

/obj/item/clothing/head/roguetown/helmet/otavan
	rogue_adjust_style = /datum/rogue_adjust_style/visor/ears

/obj/item/clothing/head/roguetown/helmet/sallet/visored
	rogue_adjust_style = /datum/rogue_adjust_style/visor/hair

/obj/item/clothing/head/roguetown/helmet/leather/armorhood
	rogue_adjust_style = /datum/rogue_adjust_style/hood/quiet

/obj/item/clothing/head/roguetown/roguehood
	rogue_adjust_style = /datum/rogue_adjust_style/hood

/obj/item/clothing/head/roguetown/veiled
	rogue_adjust_style = /datum/rogue_adjust_style/veil

/obj/item/clothing/mask/rogue/exoticsilkmask
	rogue_adjust_style = /datum/rogue_adjust_style/mask

/obj/item/clothing/mask/rogue/ragmask
	rogue_adjust_style = /datum/rogue_adjust_style/mask

/obj/item/clothing/mask/rogue/shepherd
	rogue_adjust_style = /datum/rogue_adjust_style/mask

/obj/item/clothing/mask/rogue/spectacles/duelist
	rogue_adjust_style = /datum/rogue_adjust_style/mask

/obj/item/clothing/mask/rogue/spectacles/golden
	rogue_adjust_style = /datum/rogue_adjust_style/mask

/obj/item/clothing/neck/roguetown/bevor
	rogue_adjust_style = /datum/rogue_adjust_style/bevor

/obj/item/clothing/neck/roguetown/chaincoif
	rogue_adjust_style = /datum/rogue_adjust_style/coif/chain

/obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	rogue_adjust_style = /datum/rogue_adjust_style/coif/mantle

/obj/item/clothing/neck/roguetown/coif
	rogue_adjust_style = /datum/rogue_adjust_style/coif
