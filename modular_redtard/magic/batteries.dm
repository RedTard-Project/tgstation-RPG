/// Vibelin's mana batteries (datums/mana/mana_battery.dm): crystals that hold mana without a body. Drawn from with the
/// crystal in the active hand (use it), filled with a right click on it in hand. Three sizes: Ratwood's crystalized mana
/// (/obj/item/magic/manacrystal, the standard crystal: a knife cuts it into two small ones), the small crystal (a knife
/// shapes it into a cut one) and the cut crystal, which goes into a Mana Star; a focus is a small crystal a spell is paid
/// from while it is carried. Their pools are made the first time they are touched, full (Vibelin meant them full).

/// A crystal's pool: no refill of its own, slow bleed above its cap.
/datum/rogue_mana/battery

/datum/rogue_mana/battery/setup()
	capacity = rogue_value("magic_battery_capacity")
	base_softcap = capacity
	overflow_divisor = rogue_value("magic_battery_overflow_divisor")
	amount = capacity

/datum/rogue_mana/battery/small/setup()
	. = ..()
	capacity = rogue_value("magic_battery_small_capacity")
	base_softcap = capacity
	amount = capacity

/// Vibelin's focus: draws on the leylines and pylons near it by itself (only while one is in reach).
/datum/rogue_mana/battery/small/focus/setup()
	. = ..()
	rogue_mana_sources = ROGUE_MANA_LEYLINES | ROGUE_MANA_PYLONS

/// Vibelin's Mana Star: fills slowly by itself, cannot be filled by hand.
/datum/rogue_mana/mana_star

/datum/rogue_mana/mana_star/setup()
	capacity = rogue_value("magic_manastar_capacity")
	base_softcap = capacity
	regen = rogue_value("magic_manastar_regen")

// --- Ratwood's crystalized mana: the standard crystal

/obj/item/magic/manacrystal/rogue_mana_pool_type()
	return /datum/rogue_mana/battery

/obj/item/magic/manacrystal/attack_self(mob/user, modifiers)
	. = ..()
	if(. || !rogue_magic_enabled())
		return
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(rogue_mana_draw_by_hand), src, user)
	return TRUE

/obj/item/magic/manacrystal/attack_self_secondary(mob/user, modifiers)
	. = ..()
	if(. || !rogue_magic_enabled())
		return
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(rogue_mana_send_by_hand), src, user)
	return TRUE

/// Vibelin standard crystal item_interaction(): a knife cuts it into two small crystals, which share its mana.
/obj/item/magic/manacrystal/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!rogue_magic_enabled() || !tool.get_sharpness())
		return ..()
	user.visible_message(span_notice("[user] starts to chop up [src]!"), span_notice("I start to chop up [src]!"))
	if(!do_after(user, rogue_value("magic_battery_cut_time"), src))
		return ITEM_INTERACT_BLOCKING
	var/datum/rogue_mana/pool = rogue_mana_of(src)
	var/left = pool ? pool.amount : 0
	var/turf/here = get_turf(src)
	for(var/i in 1 to 2)
		var/obj/item/rogue_mana_crystal/piece = new(here)
		var/datum/rogue_mana/piece_pool = rogue_mana_of(piece)
		if(piece_pool)
			piece_pool.adjust(-piece_pool.amount)
			left -= piece_pool.adjust(min(left, piece_pool.capacity))
	visible_message(span_notice("Mana flows freely into the newly made crystals!"))
	qdel(src)
	return ITEM_INTERACT_SUCCESS

// --- The small crystal

/obj/item/rogue_mana_crystal
	name = "small primordial quartz crystal"
	desc = "A miniaturized Primordial Quartz Crystal, formed using the run-off of cutting larger ones. Able to hold mana still, although not as much as a proper formation."
	icon = ROGUE_MANA_CRYSTAL_ICON
	icon_state = "small"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/rogue_mana_crystal/rogue_mana_pool_type()
	return /datum/rogue_mana/battery/small

/obj/item/rogue_mana_crystal/attack_self(mob/user, modifiers)
	. = ..()
	if(. || !rogue_magic_enabled())
		return
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(rogue_mana_draw_by_hand), src, user)
	return TRUE

/obj/item/rogue_mana_crystal/attack_self_secondary(mob/user, modifiers)
	. = ..()
	if(. || !rogue_magic_enabled())
		return
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(rogue_mana_send_by_hand), src, user)
	return TRUE

/// A knife shapes a small crystal into a cut one, for an amulet (keeping its mana).
/obj/item/rogue_mana_crystal/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(type != /obj/item/rogue_mana_crystal || !rogue_magic_enabled() || !tool.get_sharpness())
		return ..()
	user.visible_message(span_notice("[user] starts to shape [src]."), span_notice("I start to shape [src]."))
	if(!do_after(user, rogue_value("magic_battery_cut_time"), src))
		return ITEM_INTERACT_BLOCKING
	var/datum/rogue_mana/pool = rogue_mana_of(src)
	var/left = pool ? pool.amount : 0
	var/obj/item/rogue_mana_crystal/cut/shaped = new(get_turf(src))
	var/datum/rogue_mana/shaped_pool = rogue_mana_of(shaped)
	if(shaped_pool)
		shaped_pool.adjust(min(left, shaped_pool.capacity) - shaped_pool.amount)
	qdel(src)
	user.put_in_hands(shaped)
	return ITEM_INTERACT_SUCCESS

/obj/item/rogue_mana_crystal/cut
	name = "cut primordial quartz crystal"
	desc = "A cut and shaped Primordial Quartz Crystal, using a standardized square cut. It is meant to be slotted into a proper amulet."
	icon_state = "cut"

// --- The focus

/obj/item/rogue_mana_crystal/focus
	name = "focused small primordial quartz crystal"
	desc = "A Primordial Quartz Crystal entwined in gold and arcyne meld. Spells draw on it while you carry it, and it drinks from the leylines and pylons near it."
	icon_state = "foci"

/obj/item/rogue_mana_crystal/focus/rogue_mana_pool_type()
	return /datum/rogue_mana/battery/small/focus

/obj/item/rogue_mana_crystal/focus/rogue_mana_cast_source()
	return TRUE

/// Vibelin focus item_interaction(): an attuned gem attunes the focus to its pylon network (pylons.dm).
/obj/item/rogue_mana_crystal/focus/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/roguegem) || !rogue_magic_enabled())
		return ..()
	var/datum/rogue_mana/pool = rogue_mana_of(src)
	if(!pool)
		return ..()
	user.visible_message(span_notice("[user] starts to attune [src]."), span_notice("I start to attune [src] to [tool]."))
	if(!do_after(user, rogue_value("magic_focus_attune_time"), src) || QDELETED(pool))
		return ITEM_INTERACT_BLOCKING
	pool.attunement = tool.type
	pool.recheck_sources()
	return ITEM_INTERACT_SUCCESS

// --- The Mana Star (the Vibelin amulet the porter brought)

/obj/item/clothing/neck/roguetown/vibelin/mana_star/rogue_mana_pool_type()
	return /datum/rogue_mana/mana_star

/// Its pool is there from the start, so it fills while worn (Vibelin has_initial_mana_pool).
/obj/item/clothing/neck/roguetown/vibelin/mana_star/Initialize(mapload)
	. = ..()
	if(rogue_magic_enabled())
		rogue_mana_of(src)

/// Vibelin mana_star attack_self(): it can only be drawn from.
/obj/item/clothing/neck/roguetown/vibelin/mana_star/attack_self(mob/user, modifiers)
	. = ..()
	if(. || !rogue_magic_enabled())
		return
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(rogue_mana_draw_by_hand), src, user)
	return TRUE

// --- Making them (Vibelin has them from caches and migrants; here they are crafted)

/datum/crafting_recipe/roguetown/arcana/rogue_mana_focus
	name = "mana focus"
	result = /obj/item/rogue_mana_crystal/focus
	reqs = list(/obj/item/rogue_mana_crystal = 1, /obj/item/ingot/gold = 1, /obj/item/magic/melded/t1 = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/rogue_mana_focus/New()
	. = ..()
	rogue_difficulty = rogue_value("magic_focus_craft_difficulty")

/datum/crafting_recipe/roguetown/arcana/rogue_mana_star
	name = "primordial quartz amulet"
	result = /obj/item/clothing/neck/roguetown/vibelin/mana_star
	reqs = list(/obj/item/rogue_mana_crystal/cut = 1, /obj/item/ingot/gold = 1)
	category = "Arcane Magic"
	rogue_skill = /datum/attribute/skill/magic/arcane
	rogue_on_table = TRUE
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/arcana/rogue_mana_star/New()
	. = ..()
	rogue_difficulty = rogue_value("magic_manastar_craft_difficulty")
