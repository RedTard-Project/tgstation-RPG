GLOBAL_LIST_EMPTY(rogue_armor_cache)

/datum/rogue_armor
	var/blunt = 0
	var/slash = 0
	var/stab = 0
	var/piercing = 0
	var/fire = 0
	var/acid = 0
	var/magic = 0
	var/wound = 0
	var/slash_ep = 0
	var/stab_ep = 0
	var/piercing_ep = 0

/datum/rogue_armor/proc/get_rating(rating)
	if(!(rating in ROGUE_ARMOR_ALL_TYPES))
		CRASH("Attempted to get a rogue armor rating '[rating]' that doesn't exist")
	return vars[rating]

/datum/rogue_armor/proc/get_edge_protection(rating)
	if(!(rating in ROGUE_ARMOR_EDGE_TYPES))
		return 0
	return vars["[rating]_ep"]

/datum/rogue_armor/proc/has_any_armor()
	for(var/rating in ROGUE_ARMOR_ALL_TYPES)
		if(vars[rating])
			return TRUE
	return FALSE

/proc/rogue_armor_datum(armor_type)
	if(!ispath(armor_type, /datum/rogue_armor))
		return null
	if(!GLOB.rogue_armor_cache[armor_type])
		GLOB.rogue_armor_cache[armor_type] = new armor_type
	return GLOB.rogue_armor_cache[armor_type]

/proc/rogue_armor_name(rating)
	switch(rating)
		if(ROGUE_ARMOR_BLUNT)
			return "BLUNT"
		if(ROGUE_ARMOR_SLASH)
			return "SLASH"
		if(ROGUE_ARMOR_STAB)
			return "STAB"
		if(ROGUE_ARMOR_PIERCING)
			return "PIERCING"
		if(ROGUE_ARMOR_FIRE)
			return "FIRE"
		if(ROGUE_ARMOR_ACID)
			return "ACID"
		if(ROGUE_ARMOR_MAGIC)
			return "MAGIC"
	return "WOUND"

/proc/rogue_armor_color(value)
	if(value >= 100)
		return "#1F3FBF"
	if(value >= 75)
		return "#00FF00"
	if(value >= 50)
		return "#7CFF7C"
	if(value >= 25)
		return "#fffb00"
	if(value > 0)
		return "#ff8800"
	return "#FF0000"

/proc/rogue_armor_class_name(value)
	if(value >= 100)
		return "(IMMUNE)"
	if(value >= 75)
		return "(RESISTANT)"
	if(value >= 50)
		return "(ENDURED)"
	if(value >= 25)
		return "(NORMAL)"
	if(value > 0)
		return "(WEAK)"
	return "(NONE)"

/proc/rogue_bclass_to_armor(bclass)
	switch(bclass)
		if(BCLASS_CUT, BCLASS_CHOP, BCLASS_LASHING)
			return ROGUE_ARMOR_SLASH
		if(BCLASS_STAB, BCLASS_PICK)
			return ROGUE_ARMOR_STAB
		if(BCLASS_PIERCE)
			return ROGUE_ARMOR_PIERCING
		if(BCLASS_BURN)
			return ROGUE_ARMOR_FIRE
	return ROGUE_ARMOR_BLUNT

/proc/rogue_bclass_to_wound(bclass)
	switch(bclass)
		if(BCLASS_CUT, BCLASS_CHOP, BCLASS_LASHING)
			return WOUND_SLASH
		if(BCLASS_STAB, BCLASS_PICK, BCLASS_PIERCE, BCLASS_BITE)
			return WOUND_PIERCE
		if(BCLASS_BURN)
			return WOUND_BURN
	return WOUND_BLUNT

/proc/rogue_damage_armor_type(damagetype, sharpness, atom/attacking_item)
	if(damagetype == BURN)
		return ROGUE_ARMOR_FIRE
	if(damagetype != BRUTE)
		return null
	if(istype(attacking_item, /obj/projectile))
		return ROGUE_ARMOR_PIERCING
	var/obj/item/weapon = attacking_item
	if(istype(weapon) && weapon.rogue_current_bclass)
		return rogue_bclass_to_armor(weapon.rogue_current_bclass)
	if(sharpness & SHARP_EDGED)
		return ROGUE_ARMOR_SLASH
	if(sharpness & SHARP_POINTY)
		return ROGUE_ARMOR_STAB
	return ROGUE_ARMOR_BLUNT

/proc/rogue_armor_sound(blocksound, bclass)
	var/sharp = bclass in list(BCLASS_CUT, BCLASS_CHOP, BCLASS_STAB, BCLASS_PICK, BCLASS_BITE)
	switch(blocksound)
		if(PLATEHIT)
			if(bclass in list(BCLASS_CUT, BCLASS_CHOP))
				return pick(GLOB.rogue_plate_slashed_sounds)
			if(bclass in list(BCLASS_STAB, BCLASS_PICK, BCLASS_BITE))
				return pick(GLOB.rogue_plate_stabbed_sounds)
			return pick(GLOB.rogue_plate_blunt_sounds)
		if(CHAINHIT)
			return pick(sharp ? GLOB.rogue_chain_slashed_sounds : GLOB.rogue_chain_blunt_sounds)
		if(SOFTHIT, SOFTUNDERHIT)
			return pick(sharp ? GLOB.rogue_light_stabbed_sounds : GLOB.rogue_light_blunt_sounds)

GLOBAL_LIST_INIT(rogue_plate_slashed_sounds, list('modular_redtard/rockhill/sound/combat/hits/armor/plate_slashed (1).ogg', 'modular_redtard/rockhill/sound/combat/hits/armor/plate_slashed (2).ogg', 'modular_redtard/rockhill/sound/combat/hits/armor/plate_slashed (3).ogg', 'modular_redtard/rockhill/sound/combat/hits/armor/plate_slashed (4).ogg'))
GLOBAL_LIST_INIT(rogue_plate_stabbed_sounds, list('modular_redtard/rockhill/sound/combat/hits/armor/plate_stabbed (1).ogg', 'modular_redtard/rockhill/sound/combat/hits/armor/plate_stabbed (2).ogg', 'modular_redtard/rockhill/sound/combat/hits/armor/plate_stabbed (3).ogg'))
GLOBAL_LIST_INIT(rogue_plate_blunt_sounds, list('modular_redtard/rockhill/sound/combat/hits/armor/plate_blunt (1).ogg', 'modular_redtard/rockhill/sound/combat/hits/armor/plate_blunt (2).ogg', 'modular_redtard/rockhill/sound/combat/hits/armor/plate_blunt (3).ogg'))
GLOBAL_LIST_INIT(rogue_chain_slashed_sounds, list('modular_redtard/rockhill/sound/combat/hits/armor/chain_slashed (1).ogg', 'modular_redtard/rockhill/sound/combat/hits/armor/chain_slashed (2).ogg', 'modular_redtard/rockhill/sound/combat/hits/armor/chain_slashed (3).ogg', 'modular_redtard/rockhill/sound/combat/hits/armor/chain_slashed (4).ogg'))
GLOBAL_LIST_INIT(rogue_chain_blunt_sounds, list('modular_redtard/rockhill/sound/combat/hits/armor/chain_blunt (1).ogg', 'modular_redtard/rockhill/sound/combat/hits/armor/chain_blunt (2).ogg', 'modular_redtard/rockhill/sound/combat/hits/armor/chain_blunt (3).ogg'))
GLOBAL_LIST_INIT(rogue_light_stabbed_sounds, list('modular_redtard/rockhill/sound/combat/hits/armor/light_stabbed (1).ogg', 'modular_redtard/rockhill/sound/combat/hits/armor/light_stabbed (2).ogg', 'modular_redtard/rockhill/sound/combat/hits/armor/light_stabbed (3).ogg'))
GLOBAL_LIST_INIT(rogue_light_blunt_sounds, list('modular_redtard/rockhill/sound/combat/hits/armor/light_blunt (1).ogg', 'modular_redtard/rockhill/sound/combat/hits/armor/light_blunt (2).ogg', 'modular_redtard/rockhill/sound/combat/hits/armor/light_blunt (3).ogg'))

/obj/item/clothing
	var/rogue_armor
	var/armor_class = ARMOR_CLASS_NONE
	var/list/rogue_prevent_crits
	var/rogue_blocksound

/obj/item/clothing/proc/get_rogue_armor()
	if(atom_integrity <= 0)
		return null
	return rogue_armor_datum(rogue_armor)

/obj/item/clothing/proc/rogue_covers_zone(zone)
	return body_parts_covered & body_zone2cover_flags(zone)

/obj/item/clothing/examine(mob/user)
	. = ..()
	var/datum/rogue_armor/armor = rogue_armor_datum(rogue_armor)
	if(!armor && !length(rogue_prevent_crits) && !armor_class)
		return
	var/list/defense = list()
	if(armor)
		for(var/rating in ROGUE_ARMOR_DAMAGE_TYPES)
			var/value = armor.get_rating(rating)
			defense += "<font color='[rogue_armor_color(value)]'>[rogue_armor_name(rating)] [rogue_armor_class_name(value)]</font>"
		. += "<u><b>DEFENSE:</b></u> [defense.Join(" | ")]"
	if(length(rogue_prevent_crits))
		. += "<u><b>PREVENT CRITS:</b></u> [jointext(rogue_prevent_crits, " | ")]"
	switch(armor_class)
		if(ARMOR_CLASS_HEAVY)
			. += "AC: <b>Heavy</b>"
		if(ARMOR_CLASS_MEDIUM)
			. += "AC: <b>Medium</b>"
		if(ARMOR_CLASS_LIGHT)
			. += "AC: <b>Light</b>"

/mob/living/carbon/human/proc/rogue_best_armor(zone, armor_type)
	var/best_value = 0
	for(var/obj/item/clothing/worn in get_equipped_items())
		if(!worn.rogue_covers_zone(zone))
			continue
		var/datum/rogue_armor/armor = worn.get_rogue_armor()
		if(!armor)
			continue
		var/value = armor.get_rating(armor_type)
		if(value > best_value)
			best_value = value
			. = worn

/mob/living/carbon/human/proc/rogue_armor_protection(zone, armor_type, armour_penetration)
	var/obj/item/clothing/used = rogue_best_armor(zone, armor_type)
	if(!used)
		return 0
	return rogue_formula_value(ROGUE_FORMULA_ARMOR_PROTECTION, list("rating" = used.get_rogue_armor().get_rating(armor_type), "penetration" = armour_penetration))

/mob/living/carbon/human/proc/rogue_highest_armor_class()
	. = ARMOR_CLASS_NONE
	for(var/obj/item/clothing/worn in get_equipped_items())
		. = max(., worn.armor_class)

/mob/living/carbon/human/proc/rogue_armor_trained()
	switch(rogue_highest_armor_class())
		if(ARMOR_CLASS_HEAVY)
			return HAS_TRAIT(src, TRAIT_HEAVYARMOR)
		if(ARMOR_CLASS_MEDIUM)
			return HAS_TRAIT(src, TRAIT_HEAVYARMOR) || HAS_TRAIT(src, TRAIT_MEDIUMARMOR)
	return TRUE

/mob/living/carbon/human/proc/rogue_dodge_expert()
	return HAS_TRAIT(src, TRAIT_DODGEEXPERT) && rogue_highest_armor_class() <= ARMOR_CLASS_LIGHT

/proc/rogue_zone_of(def_zone)
	if(isbodypart(def_zone))
		var/obj/item/bodypart/part = def_zone
		return part.body_zone
	return check_zone(def_zone || BODY_ZONE_CHEST)

/datum/element/rogue_armor_wearer
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

/datum/element/rogue_armor_wearer/Attach(datum/target)
	. = ..()
	if(!ishuman(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_MOB_APPLY_DAMAGE_MODIFIERS, PROC_REF(on_damage_modifiers))
	RegisterSignal(target, COMSIG_MOB_APPLY_DAMAGE, PROC_REF(on_damage_applied))

/datum/element/rogue_armor_wearer/Detach(datum/source)
	UnregisterSignal(source, list(COMSIG_MOB_APPLY_DAMAGE_MODIFIERS, COMSIG_MOB_APPLY_DAMAGE))
	return ..()

/datum/element/rogue_armor_wearer/proc/attack_penetration(atom/attacking_item)
	if(istype(attacking_item, /obj/projectile))
		var/obj/projectile/bullet = attacking_item
		return bullet.armour_penetration
	if(isitem(attacking_item))
		var/obj/item/weapon = attacking_item
		return weapon.armour_penetration
	return 0

/datum/element/rogue_armor_wearer/proc/on_damage_modifiers(mob/living/carbon/human/source, list/damage_mods, damage, damagetype, def_zone, sharpness, attack_direction, attacking_item)
	SIGNAL_HANDLER
	var/armor_type = rogue_damage_armor_type(damagetype, sharpness, attacking_item)
	if(!armor_type || !attacking_item)
		return
	var/protection = source.rogue_armor_protection(rogue_zone_of(def_zone), armor_type, attack_penetration(attacking_item))
	if(protection)
		damage_mods += (100 - protection) / 100

/datum/element/rogue_armor_wearer/proc/on_damage_applied(mob/living/carbon/human/source, damage, damagetype, def_zone, blocked, wound_bonus, exposed_wound_bonus, sharpness, attack_direction, attacking_item, wound_clothing)
	SIGNAL_HANDLER
	var/armor_type = rogue_damage_armor_type(damagetype, sharpness, attacking_item)
	if(!armor_type || !attacking_item)
		return
	var/obj/item/clothing/used = source.rogue_best_armor(rogue_zone_of(def_zone), armor_type)
	if(!used)
		return
	var/datum/rogue_armor/armor = used.get_rogue_armor()
	var/rating = armor.get_rating(armor_type)
	var/penetration = attack_penetration(attacking_item)
	var/protection = rogue_formula_value(ROGUE_FORMULA_ARMOR_PROTECTION, list("rating" = rating, "penetration" = penetration))
	var/incoming = protection < 100 ? damage * 100 / (100 - protection) : damage
	var/integrity_damage = rogue_formula_value(ROGUE_FORMULA_ARMOR_WEAR, list("incoming" = incoming, "rating" = rating, "penetration" = penetration, "blunt_attack" = armor_type == ROGUE_ARMOR_BLUNT, "blunt_rating" = armor.blunt))
	var/obj/item/weapon = attacking_item
	if(used.rogue_blocksound)
		var/block_sound = rogue_armor_sound(used.rogue_blocksound, istype(weapon) ? weapon.rogue_current_bclass : null)
		if(block_sound)
			playsound(source, block_sound, 100)
	if(integrity_damage > 0)
		used.take_damage(integrity_damage, BRUTE, "", FALSE)

/obj/item/bodypart/check_woundings_mods(wounding_type, injury_roll, damage, wound_bonus, exposed_wound_bonus, wound_clothing)
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/human_owner = owner
	for(var/obj/item/clothing/worn as anything in human_owner.get_clothing_on_part(src))
		if(worn.atom_integrity <= 0 || !length(worn.rogue_prevent_crits))
			continue
		for(var/bclass in worn.rogue_prevent_crits)
			if(rogue_bclass_to_wound(bclass) == wounding_type)
				return 0
	. *= rogue_formula_value(ROGUE_FORMULA_WOUND_CONSTITUTION, list("constitution" = human_owner.rogue_stat(ROGUE_STAT_CONSTITUTION)))
