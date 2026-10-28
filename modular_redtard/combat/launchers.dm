/// Ratwood's bows, crossbows and slings (code/game/objects/items/rogueweapons/ranged/: bows.dm, crossbows.dm, slings.dm,
/// ammo.dm) on TG's guns. The porter grafts Ratwood's launchers onto /obj/item/gun/ballistic/rogue_launcher/{bow,crossbow,sling},
/// its ammunition onto /obj/item/ammo_casing/rogue and its projectiles onto /obj/projectile/rogue_ammo, and carries their
/// numbers (damfactor, accfactor, penfactor, reload time, the caliber of the internal magazine, the projectile's damage,
/// tier of penetration, speed, accuracy, chance to stick, what is left where it lands). What Ratwood does in code is here:
/// the draw of the shot is the charge of the intent (combat/charge.dm), its time set by skill, perception and strength
/// (get_chargetime()); letting go early strays the shot by up to launcher_uncharged_spread degrees; perception scales a
/// bow's and a sling's damage, a crossbow deals its bolt's damage times its damfactor (slurbows also by perception); the
/// aimed body part is kept by the shot's accuracy, which falls off with range, and is harder for small parts; an arrow that
/// gets through the armor may stick in the body part (TG embedding), and a reusable round is left where it lands.
#define ROGUE_LAUNCHER_BOW_DRAW_BASE rogue_value("launcher_bow_draw_base")
#define ROGUE_LAUNCHER_BOW_DRAW_SKILL_STEP rogue_value("launcher_bow_draw_skill_step")
#define ROGUE_LAUNCHER_BOW_HEAVY_DRAW_BASE rogue_value("launcher_bow_heavy_draw_base")
#define ROGUE_LAUNCHER_BOW_HEAVY_STRENGTH_DIVISOR rogue_value("launcher_bow_heavy_strength_divisor")
#define ROGUE_LAUNCHER_BOW_DRAW_PERCEPTION_BASE rogue_value("launcher_bow_draw_perception_base")
#define ROGUE_LAUNCHER_BOW_DRAW_MIN rogue_value("launcher_bow_draw_min")
#define ROGUE_LAUNCHER_BOW_ARC_DRAW_MIN rogue_value("launcher_bow_arc_draw_min")
#define ROGUE_LAUNCHER_CROSSBOW_DRAW_SKILL_STEP rogue_value("launcher_crossbow_draw_skill_step")
#define ROGUE_LAUNCHER_CROSSBOW_DRAW_PERCEPTION_STEP rogue_value("launcher_crossbow_draw_perception_step")
#define ROGUE_LAUNCHER_CROSSBOW_DRAW_MIN rogue_value("launcher_crossbow_draw_min")
#define ROGUE_LAUNCHER_CROSSBOW_ARC_SKILL_STEP rogue_value("launcher_crossbow_arc_skill_step")
#define ROGUE_LAUNCHER_CROSSBOW_ARC_PERCEPTION_BASE rogue_value("launcher_crossbow_arc_perception_base")
#define ROGUE_LAUNCHER_CROSSBOW_ARC_PERCEPTION_STEP rogue_value("launcher_crossbow_arc_perception_step")
#define ROGUE_LAUNCHER_CROSSBOW_ARC_FALLBACK rogue_value("launcher_crossbow_arc_fallback")
#define ROGUE_LAUNCHER_SLING_DRAW_BASE rogue_value("launcher_sling_draw_base")
#define ROGUE_LAUNCHER_SLING_ARC_DRAW_BASE rogue_value("launcher_sling_arc_draw_base")
#define ROGUE_LAUNCHER_SLING_DRAW_SKILL_STEP rogue_value("launcher_sling_draw_skill_step")
#define ROGUE_LAUNCHER_SLING_DRAW_PERCEPTION_DIVISOR rogue_value("launcher_sling_draw_perception_divisor")
#define ROGUE_LAUNCHER_SLING_DRAW_STRENGTH_DIVISOR rogue_value("launcher_sling_draw_strength_divisor")
#define ROGUE_LAUNCHER_SLING_DRAW_MIN rogue_value("launcher_sling_draw_min")
#define ROGUE_LAUNCHER_PER_SOFTCAP rogue_value("launcher_per_softcap")
#define ROGUE_LAUNCHER_PER_DAMAGE_STEP rogue_value("launcher_per_damage_step")
#define ROGUE_LAUNCHER_PER_DAMAGE_CAPPED_STEP rogue_value("launcher_per_damage_capped_step")
#define ROGUE_LAUNCHER_CROSSBOW_PER_MIN rogue_value("launcher_crossbow_per_min")
#define ROGUE_LAUNCHER_CROSSBOW_PER_MAX rogue_value("launcher_crossbow_per_max")
#define ROGUE_LAUNCHER_CROSSBOW_PER_DIVISOR rogue_value("launcher_crossbow_per_divisor")
#define ROGUE_LAUNCHER_SLING_STONE_FORCE rogue_value("launcher_sling_stone_force")
#define ROGUE_LAUNCHER_BOW_ACCURACY_BASE rogue_value("launcher_bow_accuracy_base")
#define ROGUE_LAUNCHER_BOW_ACCURACY_STEP rogue_value("launcher_bow_accuracy_step")
#define ROGUE_LAUNCHER_BOW_BONUS_BASE rogue_value("launcher_bow_bonus_base")
#define ROGUE_LAUNCHER_BOW_BONUS_STEP rogue_value("launcher_bow_bonus_step")
#define ROGUE_LAUNCHER_ACCURACY_BASE rogue_value("launcher_accuracy_base")
#define ROGUE_LAUNCHER_ACCURACY_STEP rogue_value("launcher_accuracy_step")
#define ROGUE_LAUNCHER_BONUS_BASE rogue_value("launcher_bonus_base")
#define ROGUE_LAUNCHER_BONUS_STEP rogue_value("launcher_bonus_step")
#define ROGUE_LAUNCHER_SKILL_ACCURACY_STEP rogue_value("launcher_skill_accuracy_step")
#define ROGUE_LAUNCHER_ACCURACY_FALLOFF rogue_value("launcher_accuracy_falloff")
#define ROGUE_LAUNCHER_ACCURACY_FLOOR rogue_value("launcher_accuracy_floor")
#define ROGUE_LAUNCHER_MOUNTED_ACCURACY_FACTOR rogue_value("launcher_mounted_accuracy_factor")
#define ROGUE_LAUNCHER_PRECISE_PENALTY rogue_value("launcher_precise_penalty")
#define ROGUE_LAUNCHER_PRECISE_MAX rogue_value("launcher_precise_max")
#define ROGUE_LAUNCHER_ULTRA_PRECISE_PENALTY rogue_value("launcher_ultra_precise_penalty")
#define ROGUE_LAUNCHER_ULTRA_PRECISE_MAX rogue_value("launcher_ultra_precise_max")
#define ROGUE_LAUNCHER_FACE_MAX rogue_value("launcher_face_max")
#define ROGUE_LAUNCHER_ZONE_MIN rogue_value("launcher_zone_min")
#define ROGUE_LAUNCHER_UNCHARGED_SPREAD rogue_value("launcher_uncharged_spread")
#define ROGUE_LAUNCHER_UNCHARGED_ACCURACY_PENALTY rogue_value("launcher_uncharged_accuracy_penalty")
#define ROGUE_LAUNCHER_UNCHARGED_EMBED_FACTOR rogue_value("launcher_uncharged_embed_factor")
#define ROGUE_LAUNCHER_EMBED_MIN_DAMAGE rogue_value("launcher_embed_min_damage")
#define ROGUE_LAUNCHER_HIT_XP_PER_INT rogue_value("launcher_hit_xp_per_int")
#define ROGUE_LAUNCHER_CROSSBOW_COCK_STRENGTH_STEP rogue_value("launcher_crossbow_cock_strength_step")
#define ROGUE_LAUNCHER_ARC_EXTRA_RANGE rogue_value("launcher_arc_extra_range")

/// Ratwood draws the nocked arrow 20 pixels up and right on the bow's sprite.
#define ROGUE_BOW_ARROW_SHIFT 20
/// Training caps of a launcher's skill from shooting (Ratwood can_train_combat_skill(): Expert, slings Legendary).
#define ROGUE_LAUNCHER_TRAIN_CAP 4
#define ROGUE_SLING_TRAIN_CAP 6
#define ROGUE_SOUND_BOW_DRAW 'modular_redtard/rockhill/sound/combat/Ranged/bow-draw-01.ogg'
#define ROGUE_SOUND_SLING_DRAW 'modular_redtard/rockhill/sound/combat/Ranged/sling-draw-01.ogg'
#define ROGUE_SOUND_CROSSBOW_COCK 'modular_redtard/rockhill/sound/combat/Ranged/crossbow_medium_reload-01.ogg'
#define ROGUE_SOUND_CROSSBOW_READY 'modular_redtard/rockhill/sound/combat/Ranged/crossbow_medium_reload-02.ogg'
#define ROGUE_SOUND_CROSSBOW_TWANG 'modular_redtard/rockhill/sound/combat/Ranged/crossbow-small-shot-02.ogg'

GLOBAL_LIST_INIT(rogue_ranged_ultra_precise_zones, list(BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_R_FOOT))
GLOBAL_LIST_INIT(rogue_ranged_precise_zones, list(BODY_ZONE_HEAD, "neck", BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
GLOBAL_LIST_INIT(rogue_ranged_face_zones, list("r_eye", "l_eye", BODY_ZONE_PRECISE_EYES, "skull", "ears", "nose", BODY_ZONE_PRECISE_MOUTH))

/// Damage factor of a muscle-powered shot by perception (Ratwood per_scaling in bows.dm and slings.dm: 2 at perception 10).
/proc/rogue_launcher_per_scaling(perception)
	var/softcap = ROGUE_LAUNCHER_PER_SOFTCAP
	return 1 + min(perception, softcap) * ROGUE_LAUNCHER_PER_DAMAGE_STEP + max(perception - softcap, 0) * ROGUE_LAUNCHER_PER_DAMAGE_CAPPED_STEP

// Charge of a ranged intent (Ratwood get_chargetime(), can_charge(), prewarning() of the intent).

/datum/intent
	/// Base aiming time of a crossbow intent (Ratwood basetime), read by rogue_chargetime().
	var/basetime = 0

/// How long the charge of this intent takes for this fighter and item; the intent's own charge time by default.
/datum/intent/proc/rogue_chargetime(mob/living/carbon/human/fighter, obj/item/held)
	return chargetime

/// Whether the fighter may start the charge now.
/datum/intent/proc/rogue_can_charge(mob/living/carbon/human/fighter, obj/item/held)
	return TRUE

/// What the onlookers see and hear when the charge starts.
/datum/intent/proc/rogue_prewarning(mob/living/carbon/human/fighter, obj/item/held)
	return

/datum/intent/shoot/rogue_prewarning(mob/living/carbon/human/fighter, obj/item/held)
	fighter.visible_message(span_warning("[fighter] aims [held]!"))

/datum/intent/arc/rogue_prewarning(mob/living/carbon/human/fighter, obj/item/held)
	fighter.visible_message(span_warning("[fighter] aims [held]!"))

/proc/rogue_bow_draw_time(mob/living/carbon/human/fighter, obj/item/held)
	var/obj/item/gun/ballistic/rogue_launcher/bow = held
	. = ROGUE_LAUNCHER_BOW_DRAW_BASE - fighter.rogue_skill_rank(/datum/attribute/skill/combat/bows) * ROGUE_LAUNCHER_BOW_DRAW_SKILL_STEP
	if(istype(bow) && bow.heavy_bow)
		. += ROGUE_LAUNCHER_BOW_HEAVY_DRAW_BASE - fighter.rogue_stat(ROGUE_STAT_STRENGTH) / ROGUE_LAUNCHER_BOW_HEAVY_STRENGTH_DIVISOR
	. += ROGUE_LAUNCHER_BOW_DRAW_PERCEPTION_BASE - fighter.rogue_stat(ROGUE_STAT_PERCEPTION)

/proc/rogue_bow_can_draw(mob/living/carbon/human/fighter, obj/item/held)
	if(fighter.usable_hands < 2 || fighter.get_inactive_held_item())
		to_chat(fighter, span_warning("I need a free hand to draw [held]!"))
		return FALSE
	return TRUE

/datum/intent/shoot/bow/rogue_chargetime(mob/living/carbon/human/fighter, obj/item/held)
	return max(rogue_bow_draw_time(fighter, held), ROGUE_LAUNCHER_BOW_DRAW_MIN)

/datum/intent/shoot/bow/rogue_can_charge(mob/living/carbon/human/fighter, obj/item/held)
	return rogue_bow_can_draw(fighter, held)

/datum/intent/shoot/bow/rogue_prewarning(mob/living/carbon/human/fighter, obj/item/held)
	fighter.visible_message(span_warning("[fighter] draws [held]!"))
	playsound(fighter, ROGUE_SOUND_BOW_DRAW, 100, FALSE)

/datum/intent/arc/bow/rogue_chargetime(mob/living/carbon/human/fighter, obj/item/held)
	return max(rogue_bow_draw_time(fighter, held), ROGUE_LAUNCHER_BOW_ARC_DRAW_MIN)

/datum/intent/arc/bow/rogue_can_charge(mob/living/carbon/human/fighter, obj/item/held)
	return rogue_bow_can_draw(fighter, held)

/datum/intent/arc/bow/rogue_prewarning(mob/living/carbon/human/fighter, obj/item/held)
	fighter.visible_message(span_warning("[fighter] draws [held] in an arc!"))
	playsound(fighter, ROGUE_SOUND_BOW_DRAW, 100, FALSE)

/proc/rogue_crossbow_can_aim(mob/living/carbon/human/fighter)
	return fighter.usable_hands >= 2 && !fighter.get_inactive_held_item()

/datum/intent/shoot/crossbow/rogue_chargetime(mob/living/carbon/human/fighter, obj/item/held)
	var/time = chargetime + basetime - fighter.rogue_skill_rank(/datum/attribute/skill/combat/crossbows) * ROGUE_LAUNCHER_CROSSBOW_DRAW_SKILL_STEP
	time -= fighter.rogue_stat(ROGUE_STAT_PERCEPTION) * ROGUE_LAUNCHER_CROSSBOW_DRAW_PERCEPTION_STEP
	return max(time, ROGUE_LAUNCHER_CROSSBOW_DRAW_MIN)

/datum/intent/shoot/crossbow/rogue_can_charge(mob/living/carbon/human/fighter, obj/item/held)
	return rogue_crossbow_can_aim(fighter)

/datum/intent/shoot/crossbow/heavy/rogue_prewarning(mob/living/carbon/human/fighter, obj/item/held)
	fighter.visible_message(span_warning("[fighter] readies [held]!"))
	playsound(fighter, ROGUE_SOUND_CROSSBOW_READY, 100, FALSE)

/datum/intent/arc/crossbow/rogue_chargetime(mob/living/carbon/human/fighter, obj/item/held)
	var/time = chargetime + basetime - fighter.rogue_skill_rank(/datum/attribute/skill/combat/crossbows) * ROGUE_LAUNCHER_CROSSBOW_ARC_SKILL_STEP
	time += ROGUE_LAUNCHER_CROSSBOW_ARC_PERCEPTION_BASE - fighter.rogue_stat(ROGUE_STAT_PERCEPTION) * ROGUE_LAUNCHER_CROSSBOW_ARC_PERCEPTION_STEP
	return time > 0 ? time : ROGUE_LAUNCHER_CROSSBOW_ARC_FALLBACK

/datum/intent/arc/crossbow/rogue_can_charge(mob/living/carbon/human/fighter, obj/item/held)
	return rogue_crossbow_can_aim(fighter)

/datum/intent/arc/crossbow/heavy/rogue_prewarning(mob/living/carbon/human/fighter, obj/item/held)
	fighter.visible_message(span_warning("[fighter] readies [held] for a precise shot!"))
	playsound(fighter, ROGUE_SOUND_CROSSBOW_READY, 100, FALSE)

/proc/rogue_sling_swing_time(mob/living/carbon/human/fighter, base)
	. = base - fighter.rogue_skill_rank(/datum/attribute/skill/combat/slings) * ROGUE_LAUNCHER_SLING_DRAW_SKILL_STEP
	. -= fighter.rogue_stat(ROGUE_STAT_PERCEPTION) / ROGUE_LAUNCHER_SLING_DRAW_PERCEPTION_DIVISOR
	. -= fighter.rogue_stat(ROGUE_STAT_STRENGTH) / ROGUE_LAUNCHER_SLING_DRAW_STRENGTH_DIVISOR
	return max(., ROGUE_LAUNCHER_SLING_DRAW_MIN)

/datum/intent/swing/sling/rogue_chargetime(mob/living/carbon/human/fighter, obj/item/held)
	return rogue_sling_swing_time(fighter, ROGUE_LAUNCHER_SLING_DRAW_BASE)

/datum/intent/swing/sling/rogue_prewarning(mob/living/carbon/human/fighter, obj/item/held)
	fighter.visible_message(span_warning("[fighter] swings the [held]!"))
	playsound(fighter, ROGUE_SOUND_SLING_DRAW, 100, FALSE)

/datum/intent/arc/sling/rogue_chargetime(mob/living/carbon/human/fighter, obj/item/held)
	return rogue_sling_swing_time(fighter, ROGUE_LAUNCHER_SLING_ARC_DRAW_BASE)

/datum/intent/arc/sling/rogue_prewarning(mob/living/carbon/human/fighter, obj/item/held)
	fighter.visible_message(span_warning("[fighter] swings the [held] in an arc!"))
	playsound(fighter, ROGUE_SOUND_SLING_DRAW, 100, FALSE)

// Internal magazines: one round of the launcher's caliber (Ratwood mag_type, mapped by the porter).

/obj/item/ammo_box/magazine/internal/rogue_launcher
	name = "string"
	abstract_type = /obj/item/ammo_box/magazine/internal/rogue_launcher
	ammo_type = /obj/item/ammo_casing/rogue
	max_ammo = 1
	start_empty = TRUE

/obj/item/ammo_box/magazine/internal/rogue_launcher/arrow
	caliber = "arrow"

/obj/item/ammo_box/magazine/internal/rogue_launcher/bolt
	caliber = "regbolt"

/obj/item/ammo_box/magazine/internal/rogue_launcher/heavy_bolt
	caliber = "heabolt"

/obj/item/ammo_box/magazine/internal/rogue_launcher/sling
	caliber = "slingbullet"

/// Base of Ratwood's ammunition (the porter grafts /obj/item/ammo_casing/caseless onto it): a TG casing whose loaded
/// projectile is the Ratwood one. The casing is spent with the shot (TG caseless); what is left where the shot lands is
/// the projectile's business. Ratwood's ammunition keeps its sprite: no "-live" state, no "spent" text, no random offset.
/obj/item/ammo_casing/rogue
	name = "arrow"
	desc = ""
	abstract_type = /obj/item/ammo_casing/rogue
	icon = 'modular_redtard/rockhill/icons/roguetown/weapons/ammo.dmi'
	icon_state = "arrow"
	worn_icon_state = null
	slot_flags = NONE
	obj_flags = NONE
	custom_materials = null
	firing_effect_type = null

/obj/item/ammo_casing/rogue/Initialize(mapload)
	var/placed_x = pixel_x
	var/placed_y = pixel_y
	. = ..()
	pixel_x = placed_x
	pixel_y = placed_y
	setDir(SOUTH)
	AddElement(/datum/element/caseless)

/obj/item/ammo_casing/rogue/update_icon_state()
	. = ..()
	icon_state = initial(icon_state)

/obj/item/ammo_casing/rogue/update_desc()
	. = ..()
	desc = initial(desc)

/obj/item/ammo_casing/rogue/add_weapon_description()
	return

/// An arrow that sticks in a body part (Ratwood add_embedded_object()): it does not hurt more on entering, and thrown later it
/// does not stick on its own.
/datum/embedding/rogue_projectile
	embed_chance = 0
	impact_pain_mult = 0
	ignore_throwspeed_threshold = TRUE

/// Base of Ratwood's projectiles (the porter grafts their branches onto it). Ratwood's speed is deciseconds per tile
/// (rogue_tile_time), TG's tiles per decisecond. TG's own aim falloff is off: the body part is chosen by Ratwood's accuracy
/// (rogue_ranged_zone()) when the shot reaches a living target.
/obj/projectile/rogue_ammo
	name = "arrow"
	icon = 'modular_redtard/rockhill/icons/roguetown/weapons/ammo.dmi'
	icon_state = "arrow_proj"
	abstract_type = /obj/projectile/rogue_ammo
	damage = 10
	damage_type = BRUTE
	armor_flag = BULLET
	range = 15
	hitsound = null
	accuracy_falloff = 0
	accurate_range = 100
	wound_bonus = 0
	/// Deciseconds per tile (Ratwood speed).
	var/rogue_tile_time = 0.8
	/// Percent chance to stick in the body part when the shot gets through the armor (Ratwood embedchance).
	var/rogue_embed_chance = 0
	/// Ratwood woundclass: the kind of blow, and the TG sharpness of the hit.
	var/rogue_bclass
	/// Damage factor against a creature without a mind (Ratwood npc_simple_damage_mult).
	var/rogue_npc_damage_mult = 1
	/// Accuracy that falls off with range (Ratwood accuracy) and accuracy that does not (Ratwood bonus_accuracy).
	var/rogue_accuracy = 65
	var/rogue_bonus_accuracy = 0
	/// What is left where it lands (Ratwood ammo_type of a reusable projectile).
	var/rogue_drop_type
	var/rogue_reusable = FALSE
	/// An arcing shot flies over everyone but those on the tile it was aimed at (Ratwood arcshot).
	var/rogue_arc = FALSE
	/// The precise body part aimed at.
	var/rogue_aimed_zone
	/// The precise body part the shot struck, which the armor is looked for on (rogue_armor_zone(), combat/armor.dm); the damage
	/// goes to its body part, def_zone.
	var/rogue_struck_zone
	/// What the round carries into the blood when its damage gets through the armor, and how much (Ratwood poisontype,
	/// poisonamount: poisoned arrows, holy water bolts).
	var/datum/reagent/rogue_poison_type
	var/rogue_poison_amount = 0
	/// Slurred speech, blurred eyes and drowsiness it brings on then, in Ratwood Life ticks (Ratwood slur, eyeblur, drowsy).
	var/rogue_slur = 0
	var/rogue_eyeblur = 0
	var/rogue_drowsy = 0
	/// The launcher's skill that a hit trains, and the rank up to which it does.
	var/rogue_trained_skill
	var/rogue_trained_cap = ROGUE_LAUNCHER_TRAIN_CAP
	/// Fire stacks and burn of a pyroclastic round (Ratwood on_hit()).
	var/rogue_fire_stacks = 0
	var/rogue_fire_burn = 0
	/// A water round puts out what burns on the tile and on the target (Ratwood on_hit()).
	var/rogue_extinguishes = FALSE
	/// Extra burn and fire stacks of a silver round against the silver-weak (Ratwood sling bullets).
	var/rogue_silver_burn = 0
	var/rogue_silver_fire_stacks = 0
	/// The tempest bolt leaves its target exposed and blind (Ratwood).
	var/rogue_exposes = FALSE
	var/rogue_blind_time = 0

/obj/projectile/rogue_ammo/reusable
	abstract_type = /obj/projectile/rogue_ammo/reusable
	rogue_reusable = TRUE

/obj/projectile/rogue_ammo/Initialize(mapload)
	if(rogue_tile_time > 0)
		speed = 1 / rogue_tile_time
	sharpness = rogue_bclass_sharpness(rogue_bclass)
	return ..()

/obj/projectile/rogue_ammo/prehit_pierce(atom/target)
	. = ..()
	if(. != PROJECTILE_PIERCE_NONE || !isliving(target))
		return
	if(rogue_arc && original && get_turf(target) != get_turf(original))
		return PROJECTILE_PIERCE_PHASE
	var/zone = rogue_ranged_zone(target, rogue_aimed_zone || def_zone)
	rogue_struck_zone = zone
	def_zone = GLOB.rogue_major_zones[zone] || check_zone(zone)

/// Accuracy left after the flight: Ratwood takes 10 off per tile while it is above 20; the bonus never falls off.
/obj/projectile/rogue_ammo/proc/rogue_hit_chance()
	var/accuracy = rogue_accuracy
	var/floor = ROGUE_LAUNCHER_ACCURACY_FLOOR
	var/falloff = ROGUE_LAUNCHER_ACCURACY_FALLOFF
	if(accuracy > floor && starting && falloff > 0)
		accuracy -= falloff * min(get_dist(starting, get_turf(src)), CEILING((accuracy - floor) / falloff, 1))
	return accuracy + rogue_bonus_accuracy

/// Ratwood bullet_hit_accuracy_check(): the aimed part, else its parent part, else the chest. Small parts are harder.
/obj/projectile/rogue_ammo/proc/rogue_ranged_zone(mob/living/victim, zone)
	var/chance = rogue_hit_chance()
	var/zone_min = ROGUE_LAUNCHER_ZONE_MIN
	if((zone in GLOB.rogue_ranged_face_zones) && victim.mind)
		chance = clamp(chance - ROGUE_LAUNCHER_ULTRA_PRECISE_PENALTY - ROGUE_LAUNCHER_PRECISE_PENALTY, zone_min, ROGUE_LAUNCHER_FACE_MAX)
	else if((zone in GLOB.rogue_ranged_face_zones) || (zone in GLOB.rogue_ranged_ultra_precise_zones))
		chance = clamp(chance - ROGUE_LAUNCHER_ULTRA_PRECISE_PENALTY, zone_min, ROGUE_LAUNCHER_ULTRA_PRECISE_MAX)
	else if(zone in GLOB.rogue_ranged_precise_zones)
		chance = clamp(chance - ROGUE_LAUNCHER_PRECISE_PENALTY, zone_min, ROGUE_LAUNCHER_PRECISE_MAX)
	if(prob(chance))
		return zone
	var/parent = GLOB.rogue_major_zones[zone] || BODY_ZONE_CHEST
	if(parent != zone && prob(chance))
		return parent
	return BODY_ZONE_CHEST

/obj/projectile/rogue_ammo/on_hit(atom/target, blocked = 0, pierce_hit)
	var/mob/living/victim = isliving(target) ? target : null
	if(victim && !victim.mind)
		damage *= rogue_npc_damage_mult
	. = ..()
	if(pierce_hit)
		return
	if(. == BULLET_ACT_HIT)
		rogue_hit_effects(target)
		rogue_poison(target, blocked)
		if(victim)
			rogue_train(victim)
	rogue_land(target, blocked)

/// The damage that got through to the body: TG's armor, then the tiers of the armor on the part it struck.
/obj/projectile/rogue_ammo/proc/rogue_dealt(mob/living/carbon/victim, blocked)
	. = damage * (100 - blocked) / 100
	if(ishuman(victim))
		var/mob/living/carbon/human/person = victim
		. *= person.rogue_projectile_share(def_zone, src)

/// Ratwood's poisoned rounds (bullet_act()): when the damage got through, what the round carries gets into the blood and its
/// slur, blur and drowsiness come on.
/obj/projectile/rogue_ammo/proc/rogue_poison(atom/target, blocked)
	if(!iscarbon(target) || !(rogue_poison_type || rogue_slur || rogue_eyeblur || rogue_drowsy))
		return
	var/mob/living/carbon/victim = target
	if(rogue_dealt(victim, blocked) <= 0)
		return
	if(rogue_poison_type && rogue_poison_amount)
		victim.reagents?.add_reagent(rogue_poison_type, rogue_poison_amount)
	if(rogue_slur)
		victim.adjust_slurring_up_to(rogue_slur * ROGUE_LIFE_TICK SECONDS, rogue_slur * ROGUE_LIFE_TICK SECONDS)
	if(rogue_eyeblur)
		victim.adjust_eye_blur_up_to(rogue_eyeblur * ROGUE_LIFE_TICK SECONDS, rogue_eyeblur * ROGUE_LIFE_TICK SECONDS)
	if(rogue_drowsy)
		victim.adjust_drowsiness_up_to(rogue_drowsy * ROGUE_LIFE_TICK SECONDS, rogue_drowsy * ROGUE_LIFE_TICK SECONDS)

/obj/projectile/rogue_ammo/proc/rogue_hit_effects(atom/target)
	var/turf/spot = get_turf(target)
	if(rogue_extinguishes && spot)
		for(var/obj/burning in spot)
			burning.extinguish()
		if(isliving(target))
			for(var/obj/carried in target)
				carried.extinguish()
	if(!isliving(target))
		return
	var/mob/living/victim = target
	if(rogue_fire_stacks)
		victim.adjust_fire_stacks(rogue_fire_stacks)
		victim.ignite_mob()
	if(rogue_fire_burn)
		victim.apply_damage(rogue_fire_burn, BURN, def_zone)
	if((rogue_silver_burn || rogue_silver_fire_stacks) && HAS_TRAIT(victim, TRAIT_SILVER_WEAK))
		victim.apply_damage(rogue_silver_burn, BURN, def_zone)
		victim.adjust_fire_stacks(rogue_silver_fire_stacks)
		victim.ignite_mob()
		victim.visible_message(span_warning("[victim] erupts in flames upon being struck by [src]!"))
	if(rogue_exposes)
		victim.apply_status_effect(/datum/status_effect/rogue/exposed)
	if(rogue_blind_time)
		victim.adjust_temp_blindness(rogue_blind_time)

/// A hit on a living target trains the launcher's skill (Ratwood on_hit() of arrows, bolts and sling bullets).
/obj/projectile/rogue_ammo/proc/rogue_train(mob/living/victim)
	var/mob/living/shooter = firer
	if(!rogue_trained_skill || !istype(shooter) || !shooter.mind || victim.stat == DEAD)
		return
	if(shooter.rogue_learned_rank(rogue_trained_skill) >= rogue_trained_cap)
		return
	shooter.rogue_adjust_experience(rogue_trained_skill, shooter.rogue_stat(ROGUE_STAT_INTELLIGENCE) * ROGUE_LAUNCHER_HIT_XP_PER_INT)

/// A reusable round is left where it struck (Ratwood handle_drop()), or sticks in the body part when it got through the armor
/// with enough damage (Ratwood check_projectile_embed()).
/obj/projectile/rogue_ammo/proc/rogue_land(atom/target, blocked)
	if(!rogue_reusable || !rogue_drop_type)
		return
	var/drop_type = rogue_drop_type
	rogue_drop_type = null
	var/turf/spot = get_turf(target)
	if(!spot || isclosedturf(spot))
		spot = get_turf(src)
	if(!spot || isclosedturf(spot))
		return
	var/obj/item/round = new drop_type(spot)
	if(!iscarbon(target) || rogue_embed_chance <= 0)
		return
	var/mob/living/carbon/victim = target
	if(rogue_dealt(victim, blocked) <= ROGUE_LAUNCHER_EMBED_MIN_DAMAGE || !prob(rogue_embed_chance))
		return
	round.set_embed(/datum/embedding/rogue_projectile)
	round.force_embed(victim, def_zone)

/obj/projectile/rogue_ammo/on_range()
	if(rogue_reusable && rogue_drop_type)
		var/drop_type = rogue_drop_type
		rogue_drop_type = null
		var/turf/spot = get_turf(src)
		if(spot && !isclosedturf(spot))
			new drop_type(spot)
	return ..()

// Ratwood's projectiles with an effect of their own (ammo.dm on_hit()).

/obj/projectile/bullet/arrow/pyro
	rogue_fire_stacks = 4
	rogue_fire_burn = 10

/obj/projectile/bullet/bolt/pyro
	rogue_fire_stacks = 6
	rogue_fire_burn = 15

/obj/projectile/bullet/arrow/water
	rogue_extinguishes = TRUE

/obj/projectile/bullet/bolt/water
	rogue_extinguishes = TRUE

/obj/projectile/bullet/reusable/sling_bullet/silver
	rogue_silver_burn = 20
	rogue_silver_fire_stacks = 2

/obj/projectile/bullet/reusable/sling_bullet/silverblessed
	rogue_silver_burn = 30
	rogue_silver_fire_stacks = 4

/obj/projectile/bullet/reusable/sling_bullet/steelblessed
	rogue_silver_burn = 10
	rogue_silver_fire_stacks = 2

/obj/projectile/bullet/reusable/heavy_bolt/tempest
	rogue_exposes = TRUE
	rogue_blind_time = 6 SECONDS

/// Base of Ratwood's launchers: a TG ballistic gun with an internal magazine of one round, no bolt and no firing pin.
/// Firing needs the ranged intent of the launcher selected; the intent's charge is the draw (combat/charge.dm).
/obj/item/gun/ballistic/rogue_launcher
	name = "launcher"
	desc = ""
	abstract_type = /obj/item/gun/ballistic/rogue_launcher
	icon = 'modular_redtard/rockhill/icons/roguetown/weapons/32.dmi'
	icon_state = "bow"
	inhand_icon_state = null
	worn_icon_state = null
	lefthand_file = null
	righthand_file = null
	slot_flags = NONE
	obj_flags = NONE
	item_flags = NONE
	custom_materials = null
	pin = null
	pinless = TRUE
	clumsy_check = FALSE
	trigger_guard = TRIGGER_GUARD_ALLOW_ALL
	can_hold_up = FALSE
	can_muzzle_flash = FALSE
	internal_magazine = TRUE
	bolt_type = BOLT_TYPE_NO_BOLT
	casing_ejector = FALSE
	click_on_low_ammo = FALSE
	mag_display = FALSE
	show_bolt_icon = FALSE
	tac_reloads = FALSE
	never_misfire = TRUE
	weapon_weight = WEAPON_HEAVY
	dual_wield_spread = 0
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/rogue_launcher/arrow
	cartridge_wording = "arrow"
	/// Ratwood's numbers of the launcher (ported): damage and accuracy factors, change of the round's penetration tier,
	/// whether perception scales a crossbow's damage, a bow's heavy draw, a crossbow's cocking.
	var/damfactor = 1
	var/accfactor = 1
	var/penfactor = 0
	var/damage_from_perception = FALSE
	var/heavy_bow = FALSE
	var/reloadtime = 40
	var/movingreload = FALSE
	var/hasloadedsprite = FALSE
	/// The skill that aims it and that its hits train, and the rank up to which they do.
	var/rogue_launch_skill
	var/rogue_trained_cap = ROGUE_LAUNCHER_TRAIN_CAP

/obj/item/gun/ballistic/rogue_launcher/add_weapon_description()
	return

/// The intent the holder shoots with, if the holder has intents.
/obj/item/gun/ballistic/rogue_launcher/proc/rogue_fire_intent(mob/living/user)
	if(!ishuman(user) || !user.is_holding(src))
		return null
	var/mob/living/carbon/human/archer = user
	return archer.rogue_strike_intent(src)

/obj/item/gun/ballistic/rogue_launcher/try_fire_gun(atom/target, mob/living/user, params)
	var/datum/intent/intent = rogue_fire_intent(user)
	if(intent && !intent.tranged)
		return NONE
	return ..()

/// The right button does not hold anyone up or shoot: TG's gunpoint is not Ratwood's.
/obj/item/gun/ballistic/rogue_launcher/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	return NONE

/obj/item/gun/ballistic/rogue_launcher/ranged_interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	return NONE

/obj/item/gun/ballistic/rogue_launcher/shoot_with_empty_chamber(mob/living/user)
	return

/obj/item/gun/ballistic/rogue_launcher/shoot_live_shot(mob/living/user, pointblank = 0, atom/pbtarget = null, message = 1)
	. = ..(user, pointblank, pbtarget, FALSE)
	if(message && istype(user) && !suppressed)
		user.visible_message(span_danger("[user] shoots [src]!"), span_danger("I shoot [src]!"), vision_distance = COMBAT_MESSAGE_RANGE)

/// Share of the draw the shot gets: the charge of the intent, full for a holder without intents or without a client.
/obj/item/gun/ballistic/rogue_launcher/proc/rogue_draw_share(mob/living/user)
	var/datum/intent/intent = rogue_fire_intent(user)
	if(!intent?.chargetime || !user.client)
		return 1
	var/mob/living/carbon/human/archer = user
	return clamp(archer.rogue_take_charge(intent), 0, 1)

/obj/item/gun/ballistic/rogue_launcher/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	spread = 0
	var/obj/projectile/rogue_ammo/shot = chambered?.loaded_projectile
	if(istype(shot) && isliving(user) && !fire_cd)
		var/share = rogue_draw_share(user)
		if(share < 1)
			spread = ROGUE_LAUNCHER_UNCHARGED_SPREAD * (1 - share)
		rogue_prepare_shot(shot, user, target, share)
	return ..()

/// Sets the shot up from its type's numbers for this shooter (Ratwood process_fire()); always from the type's values, so a
/// shot that did not go off is not counted twice.
/obj/item/gun/ballistic/rogue_launcher/proc/rogue_prepare_shot(obj/projectile/rogue_ammo/shot, mob/living/user, atom/target, share)
	shot.damage = initial(shot.damage)
	shot.armour_penetration = initial(shot.armour_penetration)
	shot.rogue_accuracy = initial(shot.rogue_accuracy)
	shot.rogue_bonus_accuracy = initial(shot.rogue_bonus_accuracy)
	shot.rogue_embed_chance = initial(shot.rogue_embed_chance)
	shot.range = initial(shot.range)
	shot.rogue_aimed_zone = user.rogue_precise_zone()
	shot.rogue_trained_skill = rogue_launch_skill
	shot.rogue_trained_cap = rogue_trained_cap
	shot.rogue_arc = istype(rogue_fire_intent(user), /datum/intent/arc)
	if(shot.rogue_arc && target)
		shot.range = max(CEILING(get_dist_euclidean(user, target), 1), 1) + ROGUE_LAUNCHER_ARC_EXTRA_RANGE
	rogue_modify_shot(shot, user, share)
	if(user.buckled)
		var/factor = ROGUE_LAUNCHER_MOUNTED_ACCURACY_FACTOR
		shot.rogue_accuracy = max(ROGUE_LAUNCHER_ZONE_MIN, shot.rogue_accuracy * factor)
		shot.rogue_bonus_accuracy = max(0, shot.rogue_bonus_accuracy * factor)

/// What the launcher's kind does to the shot: perception, skill, damage factors.
/obj/item/gun/ballistic/rogue_launcher/proc/rogue_modify_shot(obj/projectile/rogue_ammo/shot, mob/living/user, share)
	var/perception = user.rogue_stat(ROGUE_STAT_PERCEPTION)
	shot.rogue_accuracy += accfactor * (perception - ROGUE_LAUNCHER_ACCURACY_BASE) * ROGUE_LAUNCHER_ACCURACY_STEP
	shot.rogue_bonus_accuracy += (perception - ROGUE_LAUNCHER_BONUS_BASE) * ROGUE_LAUNCHER_BONUS_STEP
	if(rogue_launch_skill)
		shot.rogue_bonus_accuracy += user.rogue_skill_rank(rogue_launch_skill) * ROGUE_LAUNCHER_SKILL_ACCURACY_STEP
	shot.damage *= damfactor

/// The round on the launcher's sprite: Ratwood draws the ammunition's own sprite over it.
/obj/item/gun/ballistic/rogue_launcher/proc/rogue_round_overlay()
	if(!chambered?.icon_state)
		return null
	return mutable_appearance(chambered.icon, chambered.icon_state)

// Bows (Ratwood bows.dm): a free hand to draw and to shoot, the arrow falls out when the bow leaves the hands, perception scales
// the damage, a shot let go before the full draw strays, sticks less and hits weaker.

/obj/item/gun/ballistic/rogue_launcher/bow
	name = "bow"
	icon = 'modular_redtard/rockhill/icons/roguetown/weapons/32.dmi'
	icon_state = "bow"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/rogue_launcher/arrow
	cartridge_wording = "arrow"
	rogue_launch_skill = /datum/attribute/skill/combat/bows

/obj/item/gun/ballistic/rogue_launcher/bow/rogue_modify_shot(obj/projectile/rogue_ammo/shot, mob/living/user, share)
	var/perception = user.rogue_stat(ROGUE_STAT_PERCEPTION)
	shot.rogue_accuracy += accfactor * (perception - ROGUE_LAUNCHER_BOW_ACCURACY_BASE) * ROGUE_LAUNCHER_BOW_ACCURACY_STEP
	shot.rogue_bonus_accuracy += (perception - ROGUE_LAUNCHER_BOW_BONUS_BASE) * ROGUE_LAUNCHER_BOW_BONUS_STEP
	shot.rogue_bonus_accuracy += user.rogue_skill_rank(rogue_launch_skill) * ROGUE_LAUNCHER_SKILL_ACCURACY_STEP
	if(share < 1)
		shot.damage *= share
		shot.rogue_embed_chance *= ROGUE_LAUNCHER_UNCHARGED_EMBED_FACTOR
		shot.rogue_accuracy -= ROGUE_LAUNCHER_UNCHARGED_ACCURACY_PENALTY
	shot.damage *= damfactor * rogue_launcher_per_scaling(perception)

/obj/item/gun/ballistic/rogue_launcher/bow/update_overlays()
	. = ..()
	var/mutable_appearance/nocked = rogue_round_overlay()
	if(!nocked)
		return
	var/matrix/shift = matrix()
	shift.Translate(ROGUE_BOW_ARROW_SHIFT, ROGUE_BOW_ARROW_SHIFT)
	nocked.transform = shift
	. += nocked

/obj/item/gun/ballistic/rogue_launcher/bow/examine(mob/user)
	. = ..()
	if(heavy_bow)
		. += span_notice("<b>Has a heavy draw.</b>")

/obj/item/gun/ballistic/rogue_launcher/bow/equipped(mob/user, slot, initial)
	. = ..()
	if(!(slot & ITEM_SLOT_HANDS))
		rogue_drop_arrow()

/// Moved from the hands to a slot, the bow is out of every inventory for a moment (TG's own bow waits the same way).
/obj/item/gun/ballistic/rogue_launcher/bow/dropped(mob/user, silent)
	. = ..()
	if(chambered)
		addtimer(CALLBACK(src, PROC_REF(rogue_drop_loose_arrow)), 0.1 SECONDS)

/obj/item/gun/ballistic/rogue_launcher/bow/proc/rogue_drop_loose_arrow()
	if(!ismob(loc))
		rogue_drop_arrow()

/obj/item/gun/ballistic/rogue_launcher/bow/proc/rogue_drop_arrow()
	var/atom/spot = drop_location()
	if(!chambered || !spot)
		return
	chambered.forceMove(spot)
	update_appearance()

// Crossbows (Ratwood crossbows.dm): cocked in hand with all one's strength (reload time less strength), loaded with a bolt only
// when cocked and held in the other hand; the bolt deals its damage times the crossbow's damfactor whatever the stats
// (slurbows: also by perception), the crossbow's penfactor changes the bolt's tier.

/obj/item/gun/ballistic/rogue_launcher/crossbow
	name = "crossbow"
	icon = 'modular_redtard/rockhill/icons/roguetown/weapons/misc32.dmi'
	icon_state = "crossbow0"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/rogue_launcher/bolt
	cartridge_wording = "bolt"
	must_hold_to_load = TRUE
	rogue_launch_skill = /datum/attribute/skill/combat/crossbows
	var/cocked = FALSE
	/// Sprite name without the trailing "0" of Ratwood's state ("crossbow0" -> "crossbow"): 0 uncocked, 1 cocked, 2 loaded.
	var/rogue_state_base

/obj/item/gun/ballistic/rogue_launcher/crossbow/Initialize(mapload)
	var/state = initial(icon_state)
	if(state && copytext(state, -1) == "0")
		rogue_state_base = copytext(state, 1, -1)
	return ..()

/obj/item/gun/ballistic/rogue_launcher/crossbow/update_icon_state()
	. = ..()
	if(!rogue_state_base)
		return
	icon_state = "[rogue_state_base][(chambered && hasloadedsprite) ? 2 : (cocked ? 1 : 0)]"

/obj/item/gun/ballistic/rogue_launcher/crossbow/update_overlays()
	. = ..()
	if(hasloadedsprite)
		return
	var/mutable_appearance/bolt = rogue_round_overlay()
	if(bolt)
		. += bolt

/obj/item/gun/ballistic/rogue_launcher/crossbow/examine(mob/user)
	. = ..()
	. += span_info("Crossbows increase in accuracy with a higher <b>PERCEPTION</b>, but deal a static amount of damage regardless of character stats.")
	. += span_info("Crossbows cannot be nocked directly from their quiver and require time to load.")
	if(penfactor < 0)
		. += span_info("This weapon <b>reduces</b> bolt penetration by <b>[abs(penfactor)]</b> tier(s).")
	else if(penfactor > 0)
		. += span_info("This weapon <b>increases</b> bolt penetration by <b>[penfactor]</b> tier(s).")
	if(cocked)
		. += span_notice("It is cocked.")

/obj/item/gun/ballistic/rogue_launcher/crossbow/rogue_modify_shot(obj/projectile/rogue_ammo/shot, mob/living/user, share)
	. = ..()
	shot.armour_penetration = max(ROGUE_PEN_NONE, rogue_attack_penetration(shot) + penfactor)
	if(damage_from_perception)
		var/perception = clamp(user.rogue_stat(ROGUE_STAT_PERCEPTION), ROGUE_LAUNCHER_CROSSBOW_PER_MIN, ROGUE_LAUNCHER_CROSSBOW_PER_MAX)
		shot.damage *= perception / ROGUE_LAUNCHER_CROSSBOW_PER_DIVISOR

/obj/item/gun/ballistic/rogue_launcher/crossbow/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	. = ..()
	if(!chambered && cocked)
		cocked = FALSE
		update_appearance()

/obj/item/gun/ballistic/rogue_launcher/crossbow/shoot_with_empty_chamber(mob/living/user)
	if(!cocked)
		return
	playsound(src, ROGUE_SOUND_CROSSBOW_TWANG, 100, FALSE)
	cocked = FALSE
	update_appearance()

/obj/item/gun/ballistic/rogue_launcher/crossbow/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(isammocasing(tool) && !cocked)
		to_chat(user, span_warning("I need to cock the bow first."))
		return ITEM_INTERACT_BLOCKING
	return ..()

/obj/item/gun/ballistic/rogue_launcher/crossbow/attack_self(mob/living/user)
	if(chambered)
		return ..()
	if(cocked)
		to_chat(user, span_warning("I carefully de-cock the crossbow."))
		cocked = FALSE
		update_appearance()
		return
	INVOKE_ASYNC(src, PROC_REF(rogue_cock), user)

/obj/item/gun/ballistic/rogue_launcher/crossbow/proc/rogue_cock(mob/living/user)
	to_chat(user, span_info("I step on the stirrup and use all my might..."))
	var/time = max(reloadtime - user.rogue_stat(ROGUE_STAT_STRENGTH) * ROGUE_LAUNCHER_CROSSBOW_COCK_STRENGTH_STEP, 0)
	if(!do_after(user, time, target = user, timed_action_flags = movingreload ? IGNORE_USER_LOC_CHANGE : NONE))
		return
	if(QDELETED(src) || cocked || chambered || !user.is_holding(src))
		return
	playsound(user, ROGUE_SOUND_CROSSBOW_COCK, 100, FALSE)
	cocked = TRUE
	update_appearance()

// Slings (Ratwood slings.dm): no free hand needed; loads sling bullets or a plain stone, whose force above a plain stone's
// adds to the shot and which is gone once thrown; perception scales the damage, a swing let go early hits weaker.

/obj/item/gun/ballistic/rogue_launcher/sling
	name = "sling"
	icon = 'modular_redtard/rockhill/icons/roguetown/weapons/misc32.dmi'
	icon_state = "sling"
	weapon_weight = WEAPON_MEDIUM
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/rogue_launcher/sling
	cartridge_wording = "stone"
	rogue_launch_skill = /datum/attribute/skill/combat/slings
	rogue_trained_cap = ROGUE_SLING_TRAIN_CAP
	/// A plain stone loaded in place of a sling bullet, and its force above a plain stone's.
	var/obj/item/rogue_temp_stone
	var/rogue_stone_bonus = 0

/obj/item/gun/ballistic/rogue_launcher/sling/Destroy()
	QDEL_NULL(rogue_temp_stone)
	return ..()

/obj/item/gun/ballistic/rogue_launcher/sling/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == rogue_temp_stone)
		rogue_temp_stone = null
		rogue_stone_bonus = 0

/obj/item/gun/ballistic/rogue_launcher/sling/update_icon_state()
	. = ..()
	var/state = initial(icon_state)
	if(state)
		icon_state = chambered ? "[state]_ready" : state

/obj/item/gun/ballistic/rogue_launcher/sling/update_overlays()
	. = ..()
	var/mutable_appearance/stone = rogue_round_overlay()
	if(stone)
		. += stone

/obj/item/gun/ballistic/rogue_launcher/sling/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/natural/stone))
		return ..()
	if(chambered || rogue_temp_stone || !magazine)
		return ITEM_INTERACT_BLOCKING
	if(!user.transferItemToLoc(tool, src))
		return ITEM_INTERACT_BLOCKING
	var/obj/item/ammo_casing/stone_round = new /obj/item/ammo_casing/caseless/rogue/sling_bullet(src)
	if(!magazine.give_round(stone_round))
		qdel(stone_round)
		tool.forceMove(drop_location())
		return ITEM_INTERACT_BLOCKING
	rogue_temp_stone = tool
	rogue_stone_bonus = tool.force - ROGUE_LAUNCHER_SLING_STONE_FORCE
	chamber_round()
	playsound(src, load_sound, load_sound_volume, load_sound_vary)
	update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/item/gun/ballistic/rogue_launcher/sling/attack_self(mob/living/user)
	if(!rogue_temp_stone)
		return ..()
	var/obj/item/stone = rogue_temp_stone
	for(var/obj/item/ammo_casing/stone_round as anything in get_ammo_list(FALSE))
		qdel(stone_round)
	stone.forceMove(drop_location())
	update_appearance()

/obj/item/gun/ballistic/rogue_launcher/sling/rogue_modify_shot(obj/projectile/rogue_ammo/shot, mob/living/user, share)
	. = ..()
	shot.rogue_embed_chance = 0
	if(share < 1)
		shot.damage *= share
	shot.damage = shot.damage * rogue_launcher_per_scaling(user.rogue_stat(ROGUE_STAT_PERCEPTION)) + (rogue_temp_stone ? rogue_stone_bonus : 0)

/obj/item/gun/ballistic/rogue_launcher/sling/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	. = ..()
	if(!chambered && rogue_temp_stone)
		QDEL_NULL(rogue_temp_stone)
		rogue_stone_bonus = 0

#undef ROGUE_LAUNCHER_BOW_DRAW_BASE
#undef ROGUE_LAUNCHER_BOW_DRAW_SKILL_STEP
#undef ROGUE_LAUNCHER_BOW_HEAVY_DRAW_BASE
#undef ROGUE_LAUNCHER_BOW_HEAVY_STRENGTH_DIVISOR
#undef ROGUE_LAUNCHER_BOW_DRAW_PERCEPTION_BASE
#undef ROGUE_LAUNCHER_BOW_DRAW_MIN
#undef ROGUE_LAUNCHER_BOW_ARC_DRAW_MIN
#undef ROGUE_LAUNCHER_CROSSBOW_DRAW_SKILL_STEP
#undef ROGUE_LAUNCHER_CROSSBOW_DRAW_PERCEPTION_STEP
#undef ROGUE_LAUNCHER_CROSSBOW_DRAW_MIN
#undef ROGUE_LAUNCHER_CROSSBOW_ARC_SKILL_STEP
#undef ROGUE_LAUNCHER_CROSSBOW_ARC_PERCEPTION_BASE
#undef ROGUE_LAUNCHER_CROSSBOW_ARC_PERCEPTION_STEP
#undef ROGUE_LAUNCHER_CROSSBOW_ARC_FALLBACK
#undef ROGUE_LAUNCHER_SLING_DRAW_BASE
#undef ROGUE_LAUNCHER_SLING_ARC_DRAW_BASE
#undef ROGUE_LAUNCHER_SLING_DRAW_SKILL_STEP
#undef ROGUE_LAUNCHER_SLING_DRAW_PERCEPTION_DIVISOR
#undef ROGUE_LAUNCHER_SLING_DRAW_STRENGTH_DIVISOR
#undef ROGUE_LAUNCHER_SLING_DRAW_MIN
#undef ROGUE_LAUNCHER_PER_SOFTCAP
#undef ROGUE_LAUNCHER_PER_DAMAGE_STEP
#undef ROGUE_LAUNCHER_PER_DAMAGE_CAPPED_STEP
#undef ROGUE_LAUNCHER_CROSSBOW_PER_MIN
#undef ROGUE_LAUNCHER_CROSSBOW_PER_MAX
#undef ROGUE_LAUNCHER_CROSSBOW_PER_DIVISOR
#undef ROGUE_LAUNCHER_SLING_STONE_FORCE
#undef ROGUE_LAUNCHER_BOW_ACCURACY_BASE
#undef ROGUE_LAUNCHER_BOW_ACCURACY_STEP
#undef ROGUE_LAUNCHER_BOW_BONUS_BASE
#undef ROGUE_LAUNCHER_BOW_BONUS_STEP
#undef ROGUE_LAUNCHER_ACCURACY_BASE
#undef ROGUE_LAUNCHER_ACCURACY_STEP
#undef ROGUE_LAUNCHER_BONUS_BASE
#undef ROGUE_LAUNCHER_BONUS_STEP
#undef ROGUE_LAUNCHER_SKILL_ACCURACY_STEP
#undef ROGUE_LAUNCHER_ACCURACY_FALLOFF
#undef ROGUE_LAUNCHER_ACCURACY_FLOOR
#undef ROGUE_LAUNCHER_MOUNTED_ACCURACY_FACTOR
#undef ROGUE_LAUNCHER_PRECISE_PENALTY
#undef ROGUE_LAUNCHER_PRECISE_MAX
#undef ROGUE_LAUNCHER_ULTRA_PRECISE_PENALTY
#undef ROGUE_LAUNCHER_ULTRA_PRECISE_MAX
#undef ROGUE_LAUNCHER_FACE_MAX
#undef ROGUE_LAUNCHER_ZONE_MIN
#undef ROGUE_LAUNCHER_UNCHARGED_SPREAD
#undef ROGUE_LAUNCHER_UNCHARGED_ACCURACY_PENALTY
#undef ROGUE_LAUNCHER_UNCHARGED_EMBED_FACTOR
#undef ROGUE_LAUNCHER_EMBED_MIN_DAMAGE
#undef ROGUE_LAUNCHER_HIT_XP_PER_INT
#undef ROGUE_LAUNCHER_CROSSBOW_COCK_STRENGTH_STEP
#undef ROGUE_LAUNCHER_ARC_EXTRA_RANGE
#undef ROGUE_BOW_ARROW_SHIFT
#undef ROGUE_LAUNCHER_TRAIN_CAP
#undef ROGUE_SLING_TRAIN_CAP
#undef ROGUE_SOUND_BOW_DRAW
#undef ROGUE_SOUND_SLING_DRAW
#undef ROGUE_SOUND_CROSSBOW_COCK
#undef ROGUE_SOUND_CROSSBOW_READY
#undef ROGUE_SOUND_CROSSBOW_TWANG
