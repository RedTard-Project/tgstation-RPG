GLOBAL_LIST_EMPTY(rogue_armor_cache)

/datum/rogue_armor
	var/blunt = 0
	var/slash = 0
	var/stab = 0
	var/piercing = 0
	var/fire = 0
	var/acid = 0
	var/magic = 0

/datum/rogue_armor/proc/get_rating(rating)
	if(!(rating in ROGUE_ARMOR_ALL_TYPES))
		CRASH("Attempted to get a rogue armor rating '[rating]' that doesn't exist")
	return vars[rating]

/proc/rogue_armor_datum(armor_type)
	if(!ispath(armor_type, /datum/rogue_armor))
		return null
	if(!GLOB.rogue_armor_cache[armor_type])
		GLOB.rogue_armor_cache[armor_type] = new armor_type
	return GLOB.rogue_armor_cache[armor_type]

/proc/rogue_tier_color(tier)
	switch(tier)
		if(1)
			return "#c0a739"
		if(2)
			return "#e3e63c"
		if(3)
			return "#1a9c00"
		if(4)
			return "#339dff"
		if(5)
			return "#c757af"
	return "#808080"

/proc/rogue_tier_rating(label, tier, max_tier = ROGUE_PEN_BSTEEL)
	var/color = rogue_tier_color(tier)
	var/dots = ""
	for(var/i in 1 to max_tier)
		dots += i <= tier ? "<font color='[color]'>&#9679;</font>" : "<font color='#404040'>&#9675;</font>"
	return "<font color='[color]'>[label]</font> [dots]"

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
	// A spell bolt names the armor it meets (magic/projectile.dm rogue_armor_type); a burning one meets fire armor.
	if(istype(attacking_item, /obj/projectile/magic/rogue))
		var/obj/projectile/magic/rogue/bolt = attacking_item
		if(damagetype == BRUTE || (damagetype == BURN && bolt.rogue_armor_type == ROGUE_ARMOR_FIRE))
			return bolt.rogue_armor_type
		return null
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
GLOBAL_LIST_INIT(rogue_armor_degrade_sounds, list(
	"[ROGUE_ARMOR_MAT_PLATE]" = list('modular_redtard/rockhill/sound/combat/armor_degrade_plate1.ogg', 'modular_redtard/rockhill/sound/combat/armor_degrade_plate2.ogg', 'modular_redtard/rockhill/sound/combat/armor_degrade_plate3.ogg'),
	"[ROGUE_ARMOR_MAT_CHAINMAIL]" = list('modular_redtard/rockhill/sound/combat/armor_degrade_chain1.ogg', 'modular_redtard/rockhill/sound/combat/armor_degrade_chain2.ogg', 'modular_redtard/rockhill/sound/combat/armor_degrade_chain3.ogg'),
	"[ROGUE_ARMOR_MAT_LEATHER]" = list('modular_redtard/rockhill/sound/combat/armor_degrade_leather1.ogg', 'modular_redtard/rockhill/sound/combat/armor_degrade_leather2.ogg', 'modular_redtard/rockhill/sound/combat/armor_degrade_leather3.ogg'),
	"0" = list('modular_redtard/rockhill/sound/combat/armor_degrade1.ogg', 'modular_redtard/rockhill/sound/combat/armor_degrade2.ogg', 'modular_redtard/rockhill/sound/combat/armor_degrade3.ogg'),
))

/obj/item/clothing
	var/rogue_armor
	var/armor_class = ARMOR_CLASS_NONE
	var/rogue_blocksound
	var/material_category = 0
	var/chunkcolor = "#5e5e5e"

/obj/item/clothing/proc/get_rogue_armor()
	if(!rogue_intact())
		return null
	return rogue_armor_datum(rogue_armor)

/// Not broken: above the share of its integrity where worn armor fails.
/obj/item/clothing/proc/rogue_intact()
	return atom_integrity > max_integrity * ROGUE_ARMOR_FAILURE_SHARE

/// The coverage a blow on each zone looks for (Ratwood zone2covered()): the precise zones of the rogue HUD and TG's own.
GLOBAL_LIST_INIT(rogue_zone_coverage, list(
	BODY_ZONE_HEAD = HEAD,
	"skull" = ROGUE_COVER_HAIR,
	"ears" = ROGUE_COVER_EARS,
	"nose" = ROGUE_COVER_NOSE,
	ROGUE_ZONE_NECK = NECK,
	"r_eye" = ROGUE_COVER_RIGHT_EYE,
	"l_eye" = ROGUE_COVER_LEFT_EYE,
	BODY_ZONE_PRECISE_EYES = ROGUE_COVER_EYES,
	BODY_ZONE_PRECISE_MOUTH = ROGUE_COVER_MOUTH,
	BODY_ZONE_CHEST = CHEST,
	"stomach" = ROGUE_COVER_VITALS,
	BODY_ZONE_PRECISE_GROIN = GROIN,
	BODY_ZONE_R_ARM = ARM_RIGHT,
	BODY_ZONE_L_ARM = ARM_LEFT,
	BODY_ZONE_PRECISE_R_HAND = HAND_RIGHT,
	BODY_ZONE_PRECISE_L_HAND = HAND_LEFT,
	BODY_ZONE_R_LEG = LEG_RIGHT,
	BODY_ZONE_L_LEG = LEG_LEFT,
	BODY_ZONE_PRECISE_R_FOOT = FOOT_RIGHT,
	BODY_ZONE_PRECISE_L_FOOT = FOOT_LEFT,
))

/// What the item covers as Ratwood's coverage (rogue_coverage, rockhill/port_data.dm): its own, else TG's body parts, HEAD
/// the whole head and CHEST the chest and the vitals.
/obj/item/proc/rogue_coverage_flags()
	if(!isnull(rogue_coverage))
		return rogue_coverage
	. = body_parts_covered
	if(. & HEAD)
		. |= ROGUE_COVER_HEAD_PARTS
	if(. & CHEST)
		. |= ROGUE_COVER_VITALS

/// TG's body parts for a Ratwood coverage, folded as the porters fold them: the parts of the head into HEAD, the vitals into CHEST.
/proc/rogue_fold_coverage(coverage)
	. = coverage & ~(ROGUE_COVER_HEAD_PARTS | ROGUE_COVER_VITALS)
	if(coverage & ROGUE_COVER_HEAD_PARTS)
		. |= HEAD
	if(coverage & ROGUE_COVER_VITALS)
		. |= CHEST

/// Whether the garment covers the zone a blow lands on: a precise zone looks for its own part (a bevor guards the mouth
/// and the nose, not the eyes; gloves the hands, not the arms), a zone the table does not know for its body part.
/obj/item/clothing/proc/rogue_covers_zone(zone)
	var/needed = GLOB.rogue_zone_coverage[zone] || GLOB.rogue_zone_coverage[check_zone(zone)]
	return rogue_coverage_flags() & needed

/obj/item/clothing/proc/rogue_integrity_share()
	var/failure = max_integrity * ROGUE_ARMOR_FAILURE_SHARE
	var/usable = max_integrity - failure
	return usable > 0 ? max(atom_integrity - failure, 0) / usable : 0

/obj/item/clothing/proc/rogue_integrity_text()
	var/share = rogue_integrity_share()
	if(share >= 0.75)
		return null
	if(share >= 0.5)
		return "<span class='armoralert'><i>Dented.</i></span>"
	if(share >= 0.25)
		return "<span class='armoralert'>Damaged.</span>"
	return "<span class='armoralert'><b>Crumbling!</b></span>"

/// Wears the armor down and marks the 75/50/25% integrity steps with Ratwood's sound, chunk and balloon (Azure Peak "Pen Rework Requiem").
/obj/item/clothing/proc/rogue_armor_wear(amount)
	if(amount <= 0)
		return
	var/before = rogue_integrity_share()
	take_damage(amount, BRUTE, "", FALSE)
	var/after = rogue_integrity_share()
	var/step
	var/text
	if(before > 0.75 && after < 0.75)
		step = 1
		text = "Armor <br><font color='#8aaa4d'>marred</font>"
	if(before > 0.5 && after < 0.5)
		step = 2
		text = "Armor <br><font color='#d4d36c'>damaged</font>"
	if(before > 0.25 && after < 0.25)
		step = 3
		text = "Armor <br><font color='#a8705a'>sundered</font>"
	if(!step)
		return
	var/turf/here = get_turf(src)
	if(!here)
		return
	new /obj/effect/temp_visual/rogue_armor_chunk(here, chunkcolor, "chunkfall[step]")
	var/list/sounds = GLOB.rogue_armor_degrade_sounds["[material_category]"] || GLOB.rogue_armor_degrade_sounds["0"]
	playsound(here, sounds[step], 100, TRUE)
	rogue_trait_balloon(TRAIT_COMBAT_AWARE, text)

/obj/item/clothing/examine(mob/user)
	. = ..()
	var/datum/rogue_armor/armor = rogue_armor_datum(rogue_armor)
	if(armor && (armor.blunt || armor.slash || armor.stab || armor.piercing))
		. += "<b>ABSORPTION:</b> [rogue_tier_rating("BLUNT", armor.blunt, ROGUE_DR_ULTRA)]"
		. += "<b>BLOCK:</b> [rogue_tier_rating("SLASH", armor.slash)] | [rogue_tier_rating("STAB", armor.stab)] | [rogue_tier_rating("PIERCE", armor.piercing)]"
		. += "<b>RESIST:</b> [rogue_tier_rating("FIRE", armor.fire, ROGUE_DR_ULTRA)] | [rogue_tier_rating("ACID", armor.acid, ROGUE_DR_ULTRA)]"
	else if(rogue_armor || armor_class)
		. += "<b>NO ARMOR!</b>"
	switch(armor_class)
		if(ARMOR_CLASS_HEAVY)
			. += "AC: <b>Heavy</b>"
		if(ARMOR_CLASS_MEDIUM)
			. += "AC: <b>Medium</b>"
		if(ARMOR_CLASS_LIGHT)
			. += "AC: <b>Light</b>"

/obj/effect/temp_visual/rogue_armor_chunk
	icon = ROGUE_EFFECTS_ICON
	icon_state = "chunkfall1"
	plane = ABOVE_LIGHTING_PLANE
	duration = 0.7 SECONDS

/obj/effect/temp_visual/rogue_armor_chunk/Initialize(mapload, chunk_color, chunk_state)
	if(chunk_state)
		icon_state = chunk_state
	if(chunk_color)
		color = chunk_color
	return ..()

/// Everything worn but the pockets, in Azure Peak's order (get_best_worn_armor(), get_best_worn_armor_layered()): the cloak,
/// the back items and the belt among them. The order is the depth of a blunt blow's layers (rogue_dr_layers()).
/mob/living/carbon/human/proc/rogue_armor_slots()
	. = list(head, wear_mask, wear_wrists, gloves, wear_neck, wear_cloak, wear_suit, wear_shirt, shoes, w_uniform, wear_backr, back, belt, s_store, glasses, ears)
	if(length(wear_rings))
		. += wear_rings

/// Everything worn that can stop a cut, a stab or a shot: the same slots as the layers (Azure Peak).
/mob/living/carbon/human/proc/rogue_guard_slots()
	return rogue_armor_slots()

/mob/living/carbon/human/proc/rogue_best_armor(zone, armor_type)
	var/best_value = 0
	for(var/obj/item/clothing/worn in rogue_guard_slots())
		if(!worn.rogue_covers_zone(zone))
			continue
		var/datum/rogue_armor/armor = worn.get_rogue_armor()
		if(!armor)
			continue
		var/value = armor.get_rating(armor_type)
		if(value > best_value)
			best_value = value
			. = worn

/mob/living/carbon/human/proc/rogue_armor_tier(zone, armor_type)
	var/obj/item/clothing/used = rogue_best_armor(zone, armor_type)
	return used ? used.get_rogue_armor().get_rating(armor_type) : 0

/// Every intact armor piece covering the zone, outermost first.
/mob/living/carbon/human/proc/rogue_armor_layers(zone)
	. = list()
	for(var/obj/item/clothing/worn in rogue_armor_slots())
		if(worn.rogue_covers_zone(zone) && worn.get_rogue_armor())
			. += worn

/// The layers a blunt blow or fire wears (Azure Peak get_best_worn_armor_layered()): every intact garment over the zone with a
/// tier against it, in rogue_armor_slots() order; fire takes any real armor (a blunt, slash, stab or piercing tier) even
/// without a fire tier. Cloth without a tier is no layer.
/mob/living/carbon/human/proc/rogue_dr_layers(zone, armor_type)
	. = list()
	for(var/obj/item/clothing/worn in rogue_armor_slots())
		if(!worn.rogue_covers_zone(zone))
			continue
		var/datum/rogue_armor/armor = worn.get_rogue_armor()
		if(!armor)
			continue
		if(armor.get_rating(armor_type) > 0 || (armor_type == ROGUE_ARMOR_FIRE && (armor.blunt > 0 || armor.slash > 0 || armor.stab > 0 || armor.piercing > 0)))
			. += worn

/// Azure Peak get_pen_info(): how far a blow that reaches the armor's tier gets through it, in points from pen_info_min to
/// pen_info_max: twice the tiers the penetration is over the armor's (the least points when they match), a keen edge, and
/// the attacker's balance: strength over 10 (heavy weapons more and uncapped), the better of speed and strength for swift
/// ones, strength for bare hands. A blade worn to blade_dull_floor keeps no balance. Azure Peak also works out the intent's
/// damage factor there but never adds it, so it is left out.
/proc/rogue_armor_pen_points(mob/living/attacker, obj/item/weapon, penetration, tier)
	if(!penetration)
		return rogue_value("pen_info_min")
	. = penetration == tier ? rogue_value("pen_info_min") : (penetration - tier) * 2
	var/strength = attacker ? attacker.rogue_stat(ROGUE_STAT_STRENGTH) - ROGUE_ATTRIBUTE_MIDDLING : 0
	if(!weapon)
		. += strength
		return clamp(., rogue_value("pen_info_min"), rogue_value("pen_info_max"))
	var/balanced = !!attacker
	if(weapon.get_sharpness() && weapon.max_blade_int)
		var/edge = weapon.rogue_edge_ratio()
		if(edge > ROGUE_BLADE_DULL_START)
			. += rogue_value("dynamic_pen_edge_bonus")
		if(edge <= ROGUE_BLADE_DULL_FLOOR)
			balanced = FALSE
	if(balanced)
		switch(weapon.wbalance)
			if(WBALANCE_HEAVY)
				. += strength + rogue_value("dynamic_pen_heavy_bonus")
			if(WBALANCE_SWIFT)
				. += min(max(attacker.rogue_stat(ROGUE_STAT_SPEED) - ROGUE_ATTRIBUTE_MIDDLING, strength), rogue_value("dynamic_pen_balance_cap"))
			else
				. += min(strength, rogue_value("dynamic_pen_balance_cap"))
	return clamp(., rogue_value("pen_info_min"), rogue_value("pen_info_max"))

/// Share of a blow's damage that reaches the body under Azure Peak's armor tiers (run_armor_check(), checkarmor()), wearing the
/// armor on the way. Slash and stab compare the penetration tier with the block tier of the best covering item: a lower one is
/// stopped and the armor takes the whole blow (more against an exposed or vulnerable defender); one that reaches it lets
/// pen_passthrough_min + pen_passthrough_per_point per point (rogue_armor_pen_points()) through and wears the armor by the
/// blow times one less pen_passthrough_per_point per point. Points are counted only for a melee blow, which names its
/// attacker or comes from a held weapon; any other blow that reaches the tier (a thrown item, a beast) passes whole and wears
/// the armor whole, as Azure Peak passes no pen_info there. Piercing (projectiles) passes and wears pen_projectile_passthrough
/// of the blow at the armor's tier and pen_projectile_passthrough_more over it. A blade chipped to blade_chip_start gets
/// through no armor.
/// Blunt and fire go to rogue_layered_armor_hit(). The zone is the precise one the blow lands on (rogue_covers_zone()).
/// no_debuff: the blow cannot pop an exposed or vulnerable defender (Azure Peak: projectiles cannot).
/mob/living/carbon/human/proc/rogue_armor_hit(zone, armor_type, damage, penetration = ROGUE_PEN_NONE, wear_factor = 1, obj/item/weapon, bclass, mob/living/attacker, no_debuff = FALSE)
	if(!armor_type || armor_type == ROGUE_ARMOR_ACID || armor_type == ROGUE_ARMOR_MAGIC)
		return 1
	wear_factor *= rogue_tempo_factor("armor_wear")
	if(armor_type == ROGUE_ARMOR_BLUNT || armor_type == ROGUE_ARMOR_FIRE)
		return rogue_layered_armor_hit(zone, armor_type, damage, wear_factor, bclass, no_debuff)
	var/obj/item/clothing/used = rogue_best_armor(zone, armor_type)
	var/tier = used ? used.get_rogue_armor().get_rating(armor_type) : 0
	if(tier <= 0)
		return 1
	if(used.rogue_blocksound)
		var/block_sound = rogue_armor_sound(used.rogue_blocksound, bclass || BCLASS_BLUNT)
		if(block_sound)
			playsound(src, block_sound, 100)
	. = 0
	var/wear = damage
	if(armor_type == ROGUE_ARMOR_PIERCING)
		if(penetration == tier)
			. = ROGUE_PEN_PROJECTILE_PASSTHROUGH
		else if(penetration > tier)
			. = rogue_value("pen_projectile_passthrough_more")
		if(.)
			wear = damage * .
	else if(penetration >= tier)
		// A blow of a held weapon that names no attacker (a special, combat/specials.dm) counts the holder's points.
		if(!attacker && isliving(weapon?.loc))
			attacker = weapon.loc
		var/per_point = rogue_value("pen_passthrough_per_point")
		var/points = attacker ? rogue_armor_pen_points(attacker, weapon, penetration, tier) : 0
		. = points ? min(ROGUE_PEN_PASSTHROUGH_MIN + points * per_point, 1) : 1
		wear = damage * max(1 - points * per_point, 0)
	if(.)
		used.rogue_armor_wear(wear * wear_factor)
	else
		used.rogue_armor_wear(wear * wear_factor * (no_debuff ? 1 : rogue_armor_pop_factor()))
	if(weapon?.max_blade_int && weapon.get_sharpness() && weapon.rogue_edge_ratio() <= ROGUE_BLADE_CHIP_START)
		return 0

/// Share of a projectile's damage the armor on a body part lets through, without wearing it or making a sound: the piercing
/// branch of rogue_armor_hit(), for what happens after the hit (Ratwood: an arrow sticks only if damage got through).
/mob/living/carbon/human/proc/rogue_projectile_share(zone, obj/projectile/shot)
	var/obj/item/clothing/used = rogue_best_armor(rogue_armor_zone(zone, shot), ROGUE_ARMOR_PIERCING)
	var/tier = used ? used.get_rogue_armor().get_rating(ROGUE_ARMOR_PIERCING) : 0
	if(tier <= 0)
		return 1
	var/penetration = rogue_attack_penetration(shot)
	if(penetration == tier)
		return ROGUE_PEN_PROJECTILE_PASSTHROUGH
	return penetration > tier ? rogue_value("pen_projectile_passthrough_more") : 0

/// Azure Peak's damage-reduction branch of checkarmor(), for blunt blows and fire: any layer over the zone (rogue_dr_layers())
/// takes the whole blow off the body. The layers wear by the blow over 1 + armor_dr_tier_coefficient times the best layer's
/// tier: blunt wears every layer by that over its depth (1, 2, 3...), an exposed defender's layers each take it whole (and no
/// more), a vulnerable defender's armor_vulnerable_integ_mod more; fire wears only the best layer.
/mob/living/carbon/human/proc/rogue_layered_armor_hit(zone, armor_type, damage, wear_factor, bclass, no_debuff = FALSE)
	var/list/layers = rogue_dr_layers(zone, armor_type)
	if(!length(layers))
		return 1
	var/obj/item/clothing/best
	var/tier = 0
	for(var/obj/item/clothing/worn as anything in layers)
		var/value = worn.get_rogue_armor().get_rating(armor_type)
		if(!best || value > tier)
			best = worn
			tier = value
	var/wear = damage * wear_factor
	if(tier > 0)
		wear /= 1 + rogue_value("armor_dr_tier_coefficient") * tier
	var/full = FALSE
	if(!no_debuff)
		switch(rogue_armor_pop())
			if("exposed")
				full = TRUE
			if("vulnerable")
				wear *= rogue_value("armor_vulnerable_integ_mod")
	if(armor_type == ROGUE_ARMOR_FIRE)
		best.rogue_armor_wear(wear)
		if(best.rogue_blocksound)
			var/block_sound = rogue_armor_sound(best.rogue_blocksound, bclass || BCLASS_BURN)
			if(block_sound)
				playsound(src, block_sound, 100)
		return 0
	var/depth = 1
	var/sounded = FALSE
	for(var/obj/item/clothing/worn as anything in layers)
		worn.rogue_armor_wear(full ? wear : wear / depth)
		if(!sounded && worn.rogue_blocksound)
			var/block_sound = rogue_armor_sound(worn.rogue_blocksound, bclass || BCLASS_BLUNT)
			if(block_sound)
				playsound(src, block_sound, 100)
				sounded = TRUE
		depth++
	return 0

/// A blow the armor stopped "pops" an exposed or vulnerable defender: takes the status, tells it and says which one it took
/// ("exposed", "vulnerable" or null).
/mob/living/proc/rogue_armor_pop()
	if(remove_status_effect(/datum/status_effect/rogue/exposed))
		playsound(src, 'modular_redtard/rockhill/sound/combat/exposed_pop.ogg', 100, TRUE)
		visible_message(span_danger("[src] suffers a savage hit to [p_their()] armor while exposed, sending [p_them()] reeling!"))
		emote("pain")
		return "exposed"
	if(remove_status_effect(/datum/status_effect/rogue_vulnerable))
		playsound(src, 'modular_redtard/rockhill/sound/combat/vulnerable_pop.ogg', 100, TRUE)
		visible_message(span_danger("[src] is struck while vulnerable, leaving a dent in [p_their()] armor!"))
		emote("groan")
		return "vulnerable"

/// The armor wear factor of a stopped cut, stab or shot after rogue_armor_pop() (Azure Peak EXPOSED_INTEG_MOD, VULN_INTEG_MOD).
/mob/living/proc/rogue_armor_pop_factor()
	switch(rogue_armor_pop())
		if("exposed")
			return ROGUE_ARMOR_EXPOSED_WEAR
		if("vulnerable")
			return rogue_value("armor_vulnerable_integ_mod")
	return 1

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

/// The zone of a hit as the armor reads it: a body part's zone, a zone the armor knows (rogue_zone_coverage: the precise
/// zones), else the body part a zone falls on.
/proc/rogue_zone_of(def_zone)
	if(isbodypart(def_zone))
		var/obj/item/bodypart/part = def_zone
		return part.body_zone
	if(def_zone in GLOB.rogue_zone_coverage)
		return def_zone
	return check_zone(def_zone || BODY_ZONE_CHEST)

/// The zone the armor is looked for on: the precise part a rogue projectile struck (combat/launchers.dm), else rogue_zone_of()
/// the zone the damage goes to.
/proc/rogue_armor_zone(def_zone, atom/attacking_item)
	var/obj/projectile/rogue_ammo/shot = attacking_item
	if(istype(shot) && shot.rogue_struck_zone)
		return shot.rogue_struck_zone
	return rogue_zone_of(def_zone)

/// Penetration tier of anything that is not our own melee blow: projectiles carry it in armour_penetration (Ratwood PEN tiers),
/// TG projectiles with percent penetration are read on the same 0-4 scale.
/proc/rogue_attack_penetration(atom/attacking_item)
	var/raw = 0
	if(istype(attacking_item, /obj/projectile))
		var/obj/projectile/bullet = attacking_item
		raw = bullet.armour_penetration
	else if(isitem(attacking_item))
		var/obj/item/thrown = attacking_item
		raw = thrown.armour_penetration
	else if(istype(attacking_item, /mob/living/basic/rockhill))
		var/mob/living/basic/rockhill/beast = attacking_item
		return clamp(beast.rogue_attack_pen, ROGUE_PEN_NONE, ROGUE_PEN_BSTEEL)
	if(raw > ROGUE_PEN_BSTEEL)
		raw = round(raw / ROGUE_PEN_PERCENT_PER_TIER)
	return clamp(raw, ROGUE_PEN_NONE, ROGUE_PEN_BSTEEL)

/datum/element/rogue_combat/proc/on_damage_modifiers(mob/living/carbon/human/source, list/damage_mods, damage, damagetype, def_zone, sharpness, attack_direction, attacking_item)
	SIGNAL_HANDLER
	if(source.rogue_armor_resolved || !attacking_item)
		return
	var/armor_type = rogue_damage_armor_type(damagetype, sharpness, attacking_item)
	if(!armor_type)
		return
	var/obj/item/weapon = isitem(attacking_item) ? attacking_item : null
	damage_mods += source.rogue_armor_hit(rogue_armor_zone(def_zone, attacking_item), armor_type, damage, rogue_attack_penetration(attacking_item), weapon ? weapon.intdamage_factor : 1, weapon, weapon?.rogue_current_bclass, no_debuff = istype(attacking_item, /obj/projectile))

/// Set while our own blow applies damage it already ran through the armor, so the damage signal does not take armor twice.
/mob/living/var/rogue_armor_resolved = FALSE

/// apply_damage() for a blow whose armor share is already in damage.
/mob/living/proc/rogue_apply_armored_damage(damage, damagetype, def_zone, blocked, wound_bonus = 0, exposed_wound_bonus = 0, sharpness = NONE, attack_direction, attacking_item)
	rogue_armor_resolved = TRUE
	. = apply_damage(damage = damage, damagetype = damagetype, def_zone = def_zone, blocked = blocked, wound_bonus = wound_bonus, exposed_wound_bonus = exposed_wound_bonus, sharpness = sharpness, attack_direction = attack_direction, attacking_item = attacking_item)
	rogue_armor_resolved = FALSE

/obj/item
	/// Ratwood intdamage_factor: how hard the item wears armor down, combined with the intent's intent_intdamage_factor.
	var/intdamage_factor = 1

/// Ratwood's rule for the item and intent integrity factors: the lowest one under 1 wins, then the highest one over 1.
/proc/rogue_wear_factor(obj/item/weapon, datum/intent/intent)
	var/item_factor = weapon ? weapon.intdamage_factor : 1
	var/intent_factor = intent ? intent.intent_intdamage_factor : 1
	. = 1
	if(min(item_factor, intent_factor) < 1)
		. = min(item_factor, intent_factor)
	if(max(item_factor, intent_factor) > 1)
		. = max(item_factor, intent_factor)

/obj/item/bodypart/check_woundings_mods(wounding_type, injury_roll, damage, wound_bonus, exposed_wound_bonus, wound_clothing)
	. = ..()
	// Medieval maps only: on a modern map the wound rolls stay tg's.
	if(!ishuman(owner) || !rogue_combat_enabled())
		return
	var/mob/living/carbon/human/human_owner = owner
	. *= rogue_formula_value(ROGUE_FORMULA_WOUND_CONSTITUTION, list("constitution" = human_owner.rogue_stat(ROGUE_STAT_CONSTITUTION)))
