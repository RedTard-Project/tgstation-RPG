/// Bows, crossbows and slings on TG's guns, shooting by Azure Peak (code/modules/projectiles/guns/ballistic/launchers.dm,
/// code/game/objects/items/rogueweapons/ranged/: bows.dm, crossbows.dm, slings.dm, _ammo.dm; projectile.dm get_aim_at();
/// accuracy_checks.dm bullet_hit_accuracy_check()). The porter grafts Ratwood's launchers onto
/// /obj/item/gun/ballistic/rogue_launcher/{bow,crossbow,sling}, its ammunition onto /obj/item/ammo_casing/rogue and its
/// projectiles onto /obj/projectile/rogue_ammo, and carries their numbers (damfactor, accfactor, penfactor, reload time, the
/// caliber of the internal magazine, the projectile's damage, tier of penetration, speed, chance to stick, what is left
/// where it lands). Azure Peak's code is here:
/// - the draw of the shot is the charge of the intent (combat/charge.dm), its time set by the launcher's kind: a floor plus
///   the rest of the base by the curve of the skill's rank (bows, slings), or the base less a step per rank down to the
///   floor (crossbows); a heavy bow draws slower below the strength baseline, an arcing shot slower still, a one-handed
///   crossbow held in one hand slower; perception plays no part;
/// - the shot's aim peaks at (base + per rank) times the launcher's accfactor plus the round's own aim_mod; past the visual
///   reach it falls off per tile, across a level by a flat penalty; outside the round's sweetspot it is nil (only the
///   chest); small parts are harder unless the launcher aims steady;
/// - outside the sweetspot the round's damage falls off by its factor;
/// - let go before the full draw the shot strays (up to launcher_uncharged_spread degrees) and hits weaker (a bow's also
///   aims worse and sticks less); held past the free hold it trembles (combat/charge.dm); a shot and a let-down draw cost
///   stamina; perception scales a bow's and a sling's damage (combat/ranged.dm rogue_per_damage_factor());
/// - a crossbow deals its bolt's damage times its damfactor (slurbows also by perception, Ratwood); an arrow that gets
///   through the armor may stick in the body part (TG embedding), and a reusable round is left where it lands.
/// The numbers of a launcher's kind (rogue_draw_kind) are launcher_draw_base_<kind>, launcher_draw_floor_<kind>,
/// launcher_draw_per_skill_<kind>, launcher_arc_draw_floor_extra_<kind> and launcher_release_drain_<kind>; those of a
/// round's kind (rogue_range_kind) are ammo_<kind>_min_range, _max_range, _falloff, _aim_mod and _charge_time_mult.
#define ROGUE_LAUNCHER_DRAW_STRENGTH_BASELINE rogue_value("launcher_draw_strength_baseline")
#define ROGUE_LAUNCHER_HEAVY_DRAW_PER_STRENGTH rogue_value("launcher_heavy_draw_per_strength")
#define ROGUE_LAUNCHER_ARC_DRAW_EXTRA rogue_value("launcher_arc_draw_extra")
#define ROGUE_LAUNCHER_ARC_DRAW_FLOOR_EXTRA rogue_value("launcher_arc_draw_floor_extra")
#define ROGUE_LAUNCHER_ONEHANDED_DRAW_MULT rogue_value("launcher_crossbow_onehanded_draw_mult")
#define ROGUE_LAUNCHER_ONEHANDED_ARC_DRAW_MULT rogue_value("launcher_crossbow_onehanded_arc_draw_mult")
#define ROGUE_LAUNCHER_AIM_BASE rogue_value("launcher_aim_base")
#define ROGUE_LAUNCHER_AIM_PER_SKILL rogue_value("launcher_aim_per_skill")
#define ROGUE_LAUNCHER_AIM_NPC_BASE rogue_value("launcher_aim_npc_base")
#define ROGUE_LAUNCHER_AIM_VISUAL_REACH rogue_value("launcher_aim_visual_reach")
#define ROGUE_LAUNCHER_AIM_FARSIGHT_PENALTY rogue_value("launcher_aim_farsight_penalty")
#define ROGUE_LAUNCHER_AIM_ZCROSS_PENALTY rogue_value("launcher_aim_zcross_penalty")
#define ROGUE_LAUNCHER_AIM_FLOOR rogue_value("launcher_aim_floor")
#define ROGUE_LAUNCHER_AIM_PRECISE_MAX rogue_value("launcher_aim_precise_max")
#define ROGUE_LAUNCHER_MOUNTED_ACCURACY_FACTOR rogue_value("launcher_mounted_accuracy_factor")
#define ROGUE_LAUNCHER_PRECISE_PENALTY rogue_value("launcher_precise_penalty")
#define ROGUE_LAUNCHER_ULTRA_PRECISE_PENALTY rogue_value("launcher_ultra_precise_penalty")
#define ROGUE_LAUNCHER_ZONE_MIN rogue_value("launcher_zone_min")
#define ROGUE_LAUNCHER_UNCHARGED_SPREAD rogue_value("launcher_uncharged_spread")
#define ROGUE_LAUNCHER_HOLD_SPREAD_MAX rogue_value("launcher_hold_spread_max")
#define ROGUE_LAUNCHER_UNCHARGED_ACCURACY_PENALTY rogue_value("launcher_uncharged_accuracy_penalty")
#define ROGUE_LAUNCHER_UNCHARGED_EMBED_FACTOR rogue_value("launcher_uncharged_embed_factor")
#define ROGUE_LAUNCHER_NPC_DRAIN_MULT rogue_value("launcher_npc_drain_mult")
#define ROGUE_LAUNCHER_LETDOWN_DRAIN_MULT rogue_value("launcher_letdown_drain_mult")
#define ROGUE_LAUNCHER_CROSSBOW_PER_MIN rogue_value("launcher_crossbow_per_min")
#define ROGUE_LAUNCHER_CROSSBOW_PER_MAX rogue_value("launcher_crossbow_per_max")
#define ROGUE_LAUNCHER_CROSSBOW_PER_DIVISOR rogue_value("launcher_crossbow_per_divisor")
#define ROGUE_LAUNCHER_SLING_STONE_FORCE rogue_value("launcher_sling_stone_force")
#define ROGUE_LAUNCHER_EMBED_MIN_DAMAGE rogue_value("launcher_embed_min_damage")
#define ROGUE_LAUNCHER_HIT_XP_PER_INT rogue_value("launcher_hit_xp_per_int")
#define ROGUE_LAUNCHER_CROSSBOW_COCK_STRENGTH_STEP rogue_value("launcher_crossbow_cock_strength_step")
#define ROGUE_LAUNCHER_ARC_EXTRA_RANGE rogue_value("launcher_arc_extra_range")

/// Ratwood draws the nocked arrow 20 pixels up and right on the bow's sprite.
#define ROGUE_BOW_ARROW_SHIFT 20
#define ROGUE_SOUND_BOW_DRAW 'modular_redtard/rockhill/sound/combat/Ranged/bow-draw-01.ogg'
#define ROGUE_SOUND_SLING_DRAW 'modular_redtard/rockhill/sound/combat/Ranged/sling-draw-01.ogg'
#define ROGUE_SOUND_CROSSBOW_COCK 'modular_redtard/rockhill/sound/combat/Ranged/crossbow_medium_reload-01.ogg'
#define ROGUE_SOUND_CROSSBOW_READY 'modular_redtard/rockhill/sound/combat/Ranged/crossbow_medium_reload-02.ogg'
#define ROGUE_SOUND_CROSSBOW_TWANG 'modular_redtard/rockhill/sound/combat/Ranged/crossbow-small-shot-02.ogg'

GLOBAL_LIST_INIT(rogue_ranged_ultra_precise_zones, list(BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_R_FOOT))
GLOBAL_LIST_INIT(rogue_ranged_precise_zones, list(BODY_ZONE_HEAD, "neck", BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
GLOBAL_LIST_INIT(rogue_ranged_face_zones, list("r_eye", "l_eye", BODY_ZONE_PRECISE_EYES, "skull", "ears", "nose", BODY_ZONE_PRECISE_MOUTH))

// Charge of a ranged intent (Azure Peak get_chargetime(), can_charge(), prewarning() of the intent).

/datum/intent
	/// Ratwood's base aiming time of a crossbow intent; the porter still carries it, the draw is the launcher's now.
	var/basetime = 0
	/// Held past the free hold, the full charge trembles and drains more (Azure Peak hold_grace, hold_ramp: shooting,
	/// arcing and swinging intents, not crossbows).
	var/rogue_hold_strain = FALSE

/datum/intent/shoot
	rogue_hold_strain = TRUE

/datum/intent/arc
	rogue_hold_strain = TRUE

/datum/intent/swing
	rogue_hold_strain = TRUE

/datum/intent/shoot/crossbow
	rogue_hold_strain = FALSE

/datum/intent/arc/crossbow
	rogue_hold_strain = FALSE

/// How long the charge of this intent takes for this fighter and item; the intent's own charge time by default.
/datum/intent/proc/rogue_chargetime(mob/living/carbon/human/fighter, obj/item/held)
	return chargetime

/// Whether the fighter may start the charge now.
/datum/intent/proc/rogue_can_charge(mob/living/carbon/human/fighter, obj/item/held)
	return TRUE

/// What the onlookers see and hear when the charge starts.
/datum/intent/proc/rogue_prewarning(mob/living/carbon/human/fighter, obj/item/held)
	return

/// The draw of the launcher held, or the intent's own charge time when it has none (Azure Peak: the draw lives on the
/// launcher so players and NPCs share one curve).
/proc/rogue_launcher_chargetime(datum/intent/intent, mob/living/carbon/human/fighter, obj/item/held, arcing)
	var/obj/item/gun/ballistic/rogue_launcher/launcher = held
	if(istype(launcher) && intent.chargetime)
		var/time = launcher.rogue_draw_time(fighter, arcing)
		if(time)
			return time
	return intent.chargetime

/datum/intent/shoot/rogue_chargetime(mob/living/carbon/human/fighter, obj/item/held)
	return rogue_launcher_chargetime(src, fighter, held, FALSE)

/datum/intent/arc/rogue_chargetime(mob/living/carbon/human/fighter, obj/item/held)
	return rogue_launcher_chargetime(src, fighter, held, TRUE)

/datum/intent/swing/rogue_chargetime(mob/living/carbon/human/fighter, obj/item/held)
	return rogue_launcher_chargetime(src, fighter, held, FALSE)

/datum/intent/shoot/rogue_prewarning(mob/living/carbon/human/fighter, obj/item/held)
	fighter.visible_message(span_warning("[fighter] aims [held]!"))

/datum/intent/arc/rogue_prewarning(mob/living/carbon/human/fighter, obj/item/held)
	fighter.visible_message(span_warning("[fighter] aims [held]!"))

/proc/rogue_bow_can_draw(mob/living/carbon/human/fighter, obj/item/held)
	if(fighter.usable_hands < 2 || fighter.get_inactive_held_item())
		to_chat(fighter, span_warning("I need a free hand to draw [held]!"))
		return FALSE
	return TRUE

/datum/intent/shoot/bow/rogue_can_charge(mob/living/carbon/human/fighter, obj/item/held)
	return rogue_bow_can_draw(fighter, held)

/datum/intent/shoot/bow/rogue_prewarning(mob/living/carbon/human/fighter, obj/item/held)
	fighter.visible_message(span_warning("[fighter] draws [held]!"))
	playsound(fighter, ROGUE_SOUND_BOW_DRAW, 100, FALSE)

/datum/intent/arc/bow/rogue_can_charge(mob/living/carbon/human/fighter, obj/item/held)
	return rogue_bow_can_draw(fighter, held)

/datum/intent/arc/bow/rogue_prewarning(mob/living/carbon/human/fighter, obj/item/held)
	fighter.visible_message(span_warning("[fighter] draws [held] in an arc!"))
	playsound(fighter, ROGUE_SOUND_BOW_DRAW, 100, FALSE)

/// Both hands free for the crossbow; a one-handed crossbow aims in one hand too, only slower (Azure Peak can_charge()).
/proc/rogue_crossbow_can_aim(mob/living/carbon/human/fighter, obj/item/held)
	var/obj/item/gun/ballistic/rogue_launcher/crossbow/crossbow = held
	if(istype(crossbow) && crossbow.rogue_onehanded)
		return TRUE
	return rogue_has_free_hand(fighter)

/proc/rogue_has_free_hand(mob/living/carbon/human/fighter)
	return fighter.usable_hands >= 2 && !fighter.get_inactive_held_item()

/datum/intent/shoot/crossbow/rogue_can_charge(mob/living/carbon/human/fighter, obj/item/held)
	return rogue_crossbow_can_aim(fighter, held)

/datum/intent/shoot/crossbow/heavy/rogue_prewarning(mob/living/carbon/human/fighter, obj/item/held)
	fighter.visible_message(span_warning("[fighter] readies [held]!"))
	playsound(fighter, ROGUE_SOUND_CROSSBOW_READY, 100, FALSE)

/datum/intent/arc/crossbow/rogue_can_charge(mob/living/carbon/human/fighter, obj/item/held)
	return rogue_crossbow_can_aim(fighter, held)

/datum/intent/arc/crossbow/heavy/rogue_prewarning(mob/living/carbon/human/fighter, obj/item/held)
	fighter.visible_message(span_warning("[fighter] readies [held] for a precise shot!"))
	playsound(fighter, ROGUE_SOUND_CROSSBOW_READY, 100, FALSE)

/datum/intent/swing/sling/rogue_prewarning(mob/living/carbon/human/fighter, obj/item/held)
	fighter.visible_message(span_warning("[fighter] swings the [held]!"))
	playsound(fighter, ROGUE_SOUND_SLING_DRAW, 100, FALSE)

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

/// Azure Peak get_mechanics_examine() of ammunition: the sweetspot and what the round's heft does to the aim.
/obj/item/ammo_casing/rogue/examine(mob/user)
	. = ..()
	var/obj/projectile/rogue_ammo/shot = loaded_projectile
	if(!istype(shot))
		return
	var/list/sweetspot = shot.rogue_sweetspot_examine("This projectile")
	if(length(sweetspot))
		. += span_info("Projectiles have maximum and minimum falloff ranges, with particular falloff factors for damage.")
		. += sweetspot
	if(shot.rogue_aim_mod < 0)
		. += span_info("Its heft throws off my aim by <b>[-shot.rogue_aim_mod]</b>.")

/// Multiplier of the draw of a launcher loaded with this round (Azure Peak charge_time_mult: heavy sling ammunition).
/obj/item/ammo_casing/rogue/proc/rogue_charge_time_mult()
	var/obj/projectile/rogue_ammo/shot = loaded_projectile
	if(!istype(shot) || !shot.rogue_range_kind)
		return 1
	return rogue_value_or("ammo_[shot.rogue_range_kind]_charge_time_mult", 1)

/// An arrow that sticks in a body part (Ratwood add_embedded_object()): it does not hurt more on entering, and thrown later it
/// does not stick on its own.
/datum/embedding/rogue_projectile
	embed_chance = 0
	impact_pain_mult = 0
	ignore_throwspeed_threshold = TRUE

/// Base of Ratwood's projectiles (the porter grafts their branches onto it). Ratwood's speed is deciseconds per tile
/// (rogue_tile_time), TG's tiles per decisecond. TG's own aim falloff is off: the body part is chosen by Azure Peak's aim
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
	/// Ratwood's accuracy of the round; the porter still carries them, the aim is Azure Peak's now (rogue_aim_peak).
	var/rogue_accuracy = 65
	var/rogue_bonus_accuracy = 0
	/// Peak of the shot's aim, set by the launcher when it fires (Azure Peak aim_peak); an NPC's default otherwise.
	var/rogue_aim_peak = 0
	/// The launcher aims steady: no penalty and no ceiling for small parts (Azure Peak steady_aim).
	var/rogue_steady_aim = FALSE
	/// Kind of round whose sweetspot, falloff and aim the numbers name (ammo_<kind>_...), and those numbers: the distance
	/// in tiles of full force, the damage factor outside it, the aim the round's heft adds (Azure Peak min_range,
	/// max_range, dam_falloff_factor, aim_mod).
	var/rogue_range_kind
	var/rogue_min_range = 0
	var/rogue_max_range = 0
	var/rogue_falloff = 1
	var/rogue_aim_mod = 0
	/// The falloff was weighed for the target the shot struck.
	var/rogue_falloff_done = FALSE
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
	var/rogue_trained_cap
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
	rogue_aim_peak = ROGUE_LAUNCHER_AIM_NPC_BASE
	if(rogue_range_kind)
		rogue_min_range = rogue_value_or("ammo_[rogue_range_kind]_min_range", 0)
		rogue_max_range = rogue_value_or("ammo_[rogue_range_kind]_max_range", 0)
		rogue_falloff = rogue_value_or("ammo_[rogue_range_kind]_falloff", 1)
		rogue_aim_mod = rogue_value_or("ammo_[rogue_range_kind]_aim_mod", 0)
	return ..()

/obj/projectile/rogue_ammo/prehit_pierce(atom/target)
	. = ..()
	if(. != PROJECTILE_PIERCE_NONE)
		return
	if(isliving(target) && rogue_arc && original && get_turf(target) != get_turf(original))
		return PROJECTILE_PIERCE_PHASE
	rogue_apply_falloff(target)
	if(!isliving(target))
		return
	var/zone = rogue_ranged_zone(target, rogue_aimed_zone || def_zone)
	rogue_struck_zone = zone
	def_zone = GLOB.rogue_major_zones[zone] || check_zone(zone)

/// Tiles from where the shot was fired to the spot, across levels by the map alone (Azure Peak get_aim_from()).
/obj/projectile/rogue_ammo/proc/rogue_flight_distance(turf/spot)
	return max(abs(spot.x - starting.x), abs(spot.y - starting.y))

/// The spot is short of or past the round's sweetspot (Azure Peak check_range(): on the level it was fired on only).
/obj/projectile/rogue_ammo/proc/rogue_outside_sweetspot(turf/spot)
	if(!starting || !istype(spot) || spot.z != starting.z)
		return FALSE
	var/distance = get_dist(spot, starting)
	return (rogue_min_range && distance < rogue_min_range) || (rogue_max_range && distance > rogue_max_range)

/// Outside the sweetspot the round deals its damage times its falloff (Azure Peak process_hit()).
/obj/projectile/rogue_ammo/proc/rogue_apply_falloff(atom/target)
	if(rogue_falloff_done)
		return
	rogue_falloff_done = TRUE
	if(damage && rogue_falloff != 1 && rogue_outside_sweetspot(get_turf(target)))
		damage = round(damage * rogue_falloff)

/// Chance to keep to the aimed part at the target (Azure Peak get_aim_at()): nil outside the sweetspot, the peak plus the
/// round's aim within the visual reach, less per tile past it and across a level.
/obj/projectile/rogue_ammo/proc/rogue_aim_from(atom/target)
	var/turf/spot = get_turf(target)
	if(!starting || !istype(spot))
		return rogue_aim_peak + rogue_aim_mod
	var/distance = rogue_flight_distance(spot)
	var/aim_floor = ROGUE_LAUNCHER_AIM_FLOOR
	if((rogue_min_range && distance < rogue_min_range) || (rogue_max_range && distance > rogue_max_range))
		return aim_floor
	var/aim = rogue_aim_peak + rogue_aim_mod
	var/reach = ROGUE_LAUNCHER_AIM_VISUAL_REACH
	if(distance > reach)
		aim -= (distance - reach) * ROGUE_LAUNCHER_AIM_FARSIGHT_PENALTY
	if(spot.z != starting.z)
		aim -= ROGUE_LAUNCHER_AIM_ZCROSS_PENALTY
	return max(aim_floor, aim)

/// Azure Peak bullet_hit_accuracy_check(): the aimed part, else its parent part, else the chest. Small parts are harder
/// unless the launcher aims steady: the head, neck and limbs within a floor and a ceiling, the hands and feet more, the
/// face most.
/obj/projectile/rogue_ammo/proc/rogue_ranged_zone(mob/living/victim, zone)
	var/chance = rogue_aim_from(victim)
	if(!rogue_steady_aim)
		if(zone in GLOB.rogue_ranged_face_zones)
			chance -= ROGUE_LAUNCHER_ULTRA_PRECISE_PENALTY + ROGUE_LAUNCHER_PRECISE_PENALTY
		else if(zone in GLOB.rogue_ranged_ultra_precise_zones)
			chance -= ROGUE_LAUNCHER_ULTRA_PRECISE_PENALTY
		else if(zone in GLOB.rogue_ranged_precise_zones)
			chance = clamp(chance - ROGUE_LAUNCHER_PRECISE_PENALTY, ROGUE_LAUNCHER_ZONE_MIN, ROGUE_LAUNCHER_AIM_PRECISE_MAX)
	if(prob(chance))
		return zone
	var/parent = GLOB.rogue_major_zones[zone] || BODY_ZONE_CHEST
	if(parent != zone && prob(chance))
		return parent
	return BODY_ZONE_CHEST

/// Examine lines of the round's sweetspot (Azure Peak get_sweetspot_examine()); empty when it has none.
/obj/projectile/rogue_ammo/proc/rogue_sweetspot_examine(subject)
	. = list()
	if(!rogue_min_range && !rogue_max_range)
		return
	if(rogue_min_range && rogue_max_range)
		. += span_info("[subject] has a sweetspot between <b>[rogue_min_range]</b> and <b>[rogue_max_range]</b> tiles, where it delivers full force.")
	else if(rogue_max_range)
		. += span_info("[subject] has a sweetspot up to <b>[rogue_max_range]</b> tiles, where it delivers full force.")
	else
		. += span_info("[subject] has a sweetspot beyond <b>[rogue_min_range]</b> tiles, where it delivers full force.")
	if(rogue_falloff != 1)
		. += span_info("Outside the sweetspot, its damage is reduced to <b>[rogue_falloff * 100]%</b>.")

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

// Kinds of the ported rounds by Azure Peak's ammunition (ammo_arrows.dm, ammo_bolts.dm, ammo_bullets.dm): arrows, bolts,
// heavy bolts and reusable sling bullets have a sweetspot; a sling bullet's heft throws the aim off, the loose stone's too.

/obj/projectile/bullet/reusable/arrow
	rogue_range_kind = "arrow"

/obj/projectile/bullet/reusable/bolt
	rogue_range_kind = "bolt"

/obj/projectile/bullet/reusable/heavy_bolt
	rogue_range_kind = "heavy_bolt"

/obj/projectile/bullet/reusable/sling_bullet
	rogue_range_kind = "sling"

/obj/projectile/bullet/sling_bullet
	rogue_range_kind = "stone"

/obj/projectile/bullet/bolt
	rogue_range_kind = "bolt"

// Ratwood's projectiles with an effect of their own (ammo.dm on_hit()).

/obj/projectile/bullet/arrow/pyro
	rogue_range_kind = "arrow"
	rogue_fire_stacks = 4
	rogue_fire_burn = 10

/obj/projectile/bullet/bolt/pyro
	rogue_fire_stacks = 6
	rogue_fire_burn = 15

/obj/projectile/bullet/arrow/water
	rogue_range_kind = "arrow"
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
	var/rogue_trained_cap
	/// Name of the mechanics value (combat.txt) of that rank: Initialize() reads it into rogue_trained_cap (Ratwood
	/// can_train_combat_skill()).
	var/rogue_trained_cap_key = "launcher_train_cap"
	/// Kind whose draw and stamina numbers the launcher takes (launcher_draw_base_<kind> and the rest; Azure Peak draw_base,
	/// draw_floor, draw_per_skill, release_drain of the launcher's type).
	var/rogue_draw_kind
	/// The draw follows the curve of the skill's rank (Azure Peak uses_draw_curve: bows, slings) instead of a step per rank.
	var/rogue_draw_curve = FALSE
	/// The launcher aims steady: no penalty and no ceiling for small parts (Azure Peak steady_aim: bows, crossbows).
	var/rogue_steady_aim = FALSE
	/// A shot let go early also aims worse and sticks less (Azure Peak early_release_acc_penalty and embed_mult of bows).
	var/rogue_early_release_penalty = FALSE
	/// Unstable hold of the draw when the shot is let go, read before the charge is taken.
	var/rogue_last_instability = 0

/obj/item/gun/ballistic/rogue_launcher/add_weapon_description()
	return

/obj/item/gun/ballistic/rogue_launcher/examine(mob/user)
	. = ..()
	if(rogue_steady_aim)
		. += span_info("This weapon has <b>steady aim</b>: I can pick out a limb, hand, foot or face as easily as the chest.")
	var/obj/projectile/rogue_ammo/shot = chambered?.loaded_projectile
	if(istype(shot))
		. += shot.rogue_sweetspot_examine("The loaded [chambered.name]")

/// The intent the holder shoots with, if the holder has intents.
/obj/item/gun/ballistic/rogue_launcher/proc/rogue_fire_intent(mob/living/user)
	if(!ishuman(user) || !user.is_holding(src))
		return null
	var/mob/living/carbon/human/archer = user
	return archer.rogue_strike_intent(src)

/// Deciseconds of the draw for this fighter (Azure Peak get_draw_time()): 0 for a launcher of no kind, the intent's own
/// charge time then.
/obj/item/gun/ballistic/rogue_launcher/proc/rogue_draw_time(mob/living/carbon/human/fighter, arcing)
	if(!rogue_draw_kind || !fighter)
		return 0
	var/time = rogue_value("launcher_draw_base_[rogue_draw_kind]")
	var/floor_time = rogue_value("launcher_draw_floor_[rogue_draw_kind]")
	if(arcing)
		time += ROGUE_LAUNCHER_ARC_DRAW_EXTRA
		var/floor_extra = rogue_value_or("launcher_arc_draw_floor_extra_[rogue_draw_kind]", null)
		floor_time += isnull(floor_extra) ? ROGUE_LAUNCHER_ARC_DRAW_FLOOR_EXTRA : floor_extra
	if(rogue_launch_skill)
		var/rank = fighter.rogue_skill_rank(rogue_launch_skill)
		if(rogue_draw_curve)
			time = floor_time + (time - floor_time) * rogue_value("launcher_draw_curve_[rank]")
		else
			time -= rank * rogue_value_or("launcher_draw_per_skill_[rogue_draw_kind]", 0)
	if(heavy_bow)
		time += max(0, ROGUE_LAUNCHER_DRAW_STRENGTH_BASELINE - fighter.rogue_stat(ROGUE_STAT_STRENGTH)) * ROGUE_LAUNCHER_HEAVY_DRAW_PER_STRENGTH
	time = max(time, floor_time)
	var/obj/item/ammo_casing/rogue/round = chambered
	if(istype(round))
		time *= round.rogue_charge_time_mult()
	return time

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

/// Share of the draw the shot gets: the charge of the intent, full for a holder without intents or without a client. The
/// tremble of a held draw is kept in rogue_last_instability.
/obj/item/gun/ballistic/rogue_launcher/proc/rogue_draw_share(mob/living/user)
	rogue_last_instability = 0
	var/datum/intent/intent = rogue_fire_intent(user)
	if(!intent?.chargetime || !user.client)
		return 1
	var/mob/living/carbon/human/archer = user
	var/datum/component/rogue_charge/charge = archer.GetComponent(/datum/component/rogue_charge)
	if(charge?.intent == intent)
		rogue_last_instability = charge.hold_instability()
	return clamp(archer.rogue_take_charge(intent), 0, 1)

/// Degrees the shot may stray (Azure Peak get_ranged_spread()): let go early, by the share of the draw it lacks; held past
/// the free hold, by its tremble. An NPC's launcher does not stray: its aim is its own.
/obj/item/gun/ballistic/rogue_launcher/proc/rogue_ranged_spread(share)
	if(share < 1)
		return ROGUE_LAUNCHER_UNCHARGED_SPREAD * (1 - share)
	return rogue_last_instability * ROGUE_LAUNCHER_HOLD_SPREAD_MAX

/obj/item/gun/ballistic/rogue_launcher/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	spread = 0
	var/obj/item/ammo_casing/round = chambered
	var/obj/projectile/rogue_ammo/shot = round?.loaded_projectile
	var/prepared = FALSE
	if(istype(shot) && isliving(user) && !fire_cd)
		var/share = rogue_draw_share(user)
		spread = rogue_ranged_spread(share)
		rogue_prepare_shot(shot, user, target, share)
		prepared = TRUE
	. = ..()
	if(prepared && (QDELETED(round) || round.loaded_projectile != shot))
		rogue_pay_release_drain(user)

/// Stamina a shot or a let-down draw costs (Azure Peak get_shot_drain()): an NPC pays less.
/obj/item/gun/ballistic/rogue_launcher/proc/rogue_shot_drain(mob/living/user, drain)
	if(!drain || !user)
		return 0
	if(!user.client)
		drain *= ROGUE_LAUNCHER_NPC_DRAIN_MULT
	return drain

/// Stamina of the shot let go (Azure Peak pay_release_drain()).
/obj/item/gun/ballistic/rogue_launcher/proc/rogue_pay_release_drain(mob/living/user)
	if(!rogue_draw_kind)
		return
	var/cost = rogue_shot_drain(user, rogue_value_or("launcher_release_drain_[rogue_draw_kind]", 0))
	if(cost)
		user.adjust_stamina_loss(cost)

/// Stamina of a draw let down without a shot, by how far it was drawn (Azure Peak pay_letdown_drain()).
/obj/item/gun/ballistic/rogue_launcher/proc/rogue_pay_letdown_drain(mob/living/user, draw_share)
	if(!rogue_draw_kind)
		return
	var/drain = rogue_value_or("launcher_release_drain_[rogue_draw_kind]", 0) * ROGUE_LAUNCHER_LETDOWN_DRAIN_MULT * clamp(draw_share, 0, 1)
	var/cost = rogue_shot_drain(user, drain)
	if(cost)
		user.adjust_stamina_loss(cost)

/obj/item/gun/ballistic/rogue_launcher/Initialize(mapload)
	if(isnull(rogue_trained_cap))
		rogue_trained_cap = rogue_value(rogue_trained_cap_key)
	return ..()

/// Sets the shot up from its type's numbers for this shooter (Azure Peak process_fire(), apply_ranged_accuracy()); always
/// from the type's values, so a shot that did not go off is not counted twice.
/obj/item/gun/ballistic/rogue_launcher/proc/rogue_prepare_shot(obj/projectile/rogue_ammo/shot, mob/living/user, atom/target, share)
	shot.damage = initial(shot.damage)
	shot.armour_penetration = initial(shot.armour_penetration)
	shot.rogue_embed_chance = initial(shot.rogue_embed_chance)
	shot.range = initial(shot.range)
	shot.rogue_falloff_done = FALSE
	var/rank = rogue_launch_skill ? user.rogue_skill_rank(rogue_launch_skill) : 0
	shot.rogue_aim_peak = (ROGUE_LAUNCHER_AIM_BASE + rank * ROGUE_LAUNCHER_AIM_PER_SKILL) * accfactor
	shot.rogue_steady_aim = rogue_steady_aim
	shot.rogue_aimed_zone = user.rogue_precise_zone()
	shot.rogue_trained_skill = rogue_launch_skill
	shot.rogue_trained_cap = rogue_trained_cap
	shot.rogue_arc = istype(rogue_fire_intent(user), /datum/intent/arc)
	if(shot.rogue_arc && target)
		shot.range = max(CEILING(get_dist_euclidean(user, target), 1), 1) + ROGUE_LAUNCHER_ARC_EXTRA_RANGE
	rogue_modify_shot(shot, user, share)
	if(user.buckled)
		shot.rogue_aim_peak = max(0, shot.rogue_aim_peak * ROGUE_LAUNCHER_MOUNTED_ACCURACY_FACTOR)

/// What the launcher's kind does to the shot: damage factors, the early release.
/obj/item/gun/ballistic/rogue_launcher/proc/rogue_modify_shot(obj/projectile/rogue_ammo/shot, mob/living/user, share)
	shot.damage *= damfactor

/// A shot let go before the full draw (Azure Peak apply_early_release_penalty()): its damage by the share of the draw; a
/// bow's also aims worse and sticks less.
/obj/item/gun/ballistic/rogue_launcher/proc/rogue_early_release(obj/projectile/rogue_ammo/shot, mob/living/user, share)
	if(share >= 1 || !user.client)
		return
	shot.damage *= share
	if(rogue_early_release_penalty)
		shot.rogue_embed_chance *= ROGUE_LAUNCHER_UNCHARGED_EMBED_FACTOR
		shot.rogue_aim_peak -= ROGUE_LAUNCHER_UNCHARGED_ACCURACY_PENALTY

/// The round on the launcher's sprite: Ratwood draws the ammunition's own sprite over it.
/obj/item/gun/ballistic/rogue_launcher/proc/rogue_round_overlay()
	if(!chambered?.icon_state)
		return null
	return mutable_appearance(chambered.icon, chambered.icon_state)

// Bows (Azure Peak bows.dm): a free hand to draw and to shoot, the arrow falls out when the bow leaves the hands, the draw
// by the curve of the archery rank, perception scales the damage, a shot let go before the full draw strays, aims worse,
// sticks less and hits weaker. Ratwood's base bow is the short bow, its recurve Azure Peak's plain bow.

/obj/item/gun/ballistic/rogue_launcher/bow
	name = "bow"
	icon = 'modular_redtard/rockhill/icons/roguetown/weapons/32.dmi'
	icon_state = "bow"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/rogue_launcher/arrow
	cartridge_wording = "arrow"
	rogue_launch_skill = /datum/attribute/skill/combat/bows
	rogue_draw_kind = "bow"
	rogue_draw_curve = TRUE
	rogue_steady_aim = TRUE
	rogue_early_release_penalty = TRUE

/obj/item/gun/ballistic/revolver/grenadelauncher/bow
	rogue_draw_kind = "shortbow"

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	rogue_draw_kind = "recurve"

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
	rogue_draw_kind = "longbow"

/obj/item/gun/ballistic/rogue_launcher/bow/rogue_modify_shot(obj/projectile/rogue_ammo/shot, mob/living/user, share)
	rogue_early_release(shot, user, share)
	shot.damage *= damfactor * rogue_per_damage_factor(user.rogue_stat(ROGUE_STAT_PERCEPTION))

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
	. += span_info("My <b>ARCHERY</b> skill defines how precise my shots are and how fast I can draw.")
	. += span_info("Bows increase in damage the higher your <b>PERCEPTION</b>.")
	. += span_info("When I shoot a target too close or too far away, I will only hit the chest.")
	if(heavy_bow)
		. += span_notice("<b>Has a heavy draw:</b> it draws slower for characters with low <b>STRENGTH</b>.")

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

// Crossbows (Azure Peak crossbows.dm): cocked in hand with all one's strength (reload time less strength), loaded with a bolt
// only when cocked and held in the other hand; aimed in both hands, a one-handed crossbow in one too but slower; the aim
// takes the base less a step per rank of crossbows; the bolt deals its damage times the crossbow's damfactor whatever the
// stats (slurbows: also by perception, Ratwood), the crossbow's penfactor changes the bolt's tier.

/obj/item/gun/ballistic/rogue_launcher/crossbow
	name = "crossbow"
	icon = 'modular_redtard/rockhill/icons/roguetown/weapons/misc32.dmi'
	icon_state = "crossbow0"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/rogue_launcher/bolt
	cartridge_wording = "bolt"
	must_hold_to_load = TRUE
	rogue_launch_skill = /datum/attribute/skill/combat/crossbows
	rogue_draw_kind = "crossbow"
	rogue_steady_aim = TRUE
	var/cocked = FALSE
	/// Sprite name without the trailing "0" of Ratwood's state ("crossbow0" -> "crossbow"): 0 uncocked, 1 cocked, 2 loaded.
	var/rogue_state_base
	/// Aimed and shot in one hand too, at a slower aim (Azure Peak onehanded: slurbows).
	var/rogue_onehanded = FALSE

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy
	rogue_draw_kind = "heavy_crossbow"

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
	rogue_draw_kind = "slurbow"
	rogue_onehanded = TRUE

/obj/item/gun/ballistic/rogue_launcher/crossbow/Initialize(mapload)
	var/state = initial(icon_state)
	if(state && copytext(state, -1) == "0")
		rogue_state_base = copytext(state, 1, -1)
	return ..()

/// A one-handed crossbow aimed without a free hand aims slower (Azure Peak crossbow get_draw_time()).
/obj/item/gun/ballistic/rogue_launcher/crossbow/rogue_draw_time(mob/living/carbon/human/fighter, arcing)
	. = ..()
	if(!. || !rogue_onehanded || rogue_has_free_hand(fighter))
		return
	. *= arcing ? ROGUE_LAUNCHER_ONEHANDED_ARC_DRAW_MULT : ROGUE_LAUNCHER_ONEHANDED_DRAW_MULT

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
	. += span_info("Crossbows deal a static amount of damage regardless of character stats.")
	. += span_info("My <b>CROSSBOWS</b> skill defines how precise my shots are and how fast I can draw.")
	. += span_info("When I shoot a target too close or too far away, I will only hit the chest.")
	. += span_info("Crossbows cannot be nocked directly from their quiver and require time to load.")
	if(penfactor < 0)
		. += span_info("This weapon <b>reduces</b> bolt penetration by <b>[abs(penfactor)]</b> tier(s).")
	else if(penfactor > 0)
		. += span_info("This weapon <b>increases</b> bolt penetration by <b>[penfactor]</b> tier(s).")
	if(rogue_onehanded)
		. += span_info("This weapon can be used in one hand, at the penalty of aim time.")
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

// Slings (Azure Peak slings.dm): no free hand needed; loads sling bullets or a plain stone, whose force above a plain stone's
// adds to the shot and which is gone once thrown; the swing by the curve of the slings rank, perception scales the damage,
// a swing let go early strays and hits weaker.

/obj/item/gun/ballistic/rogue_launcher/sling
	name = "sling"
	icon = 'modular_redtard/rockhill/icons/roguetown/weapons/misc32.dmi'
	icon_state = "sling"
	weapon_weight = WEAPON_MEDIUM
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/rogue_launcher/sling
	cartridge_wording = "stone"
	rogue_launch_skill = /datum/attribute/skill/combat/slings
	rogue_trained_cap_key = "sling_train_cap"
	rogue_draw_kind = "sling"
	rogue_draw_curve = TRUE
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

/obj/item/gun/ballistic/rogue_launcher/sling/examine(mob/user)
	. = ..()
	. += span_info("My <b>SLINGS</b> skill defines how precise my shots are and how fast I can swing.")
	. += span_info("Slings increase in damage the higher your <b>PERCEPTION</b>.")
	. += span_info("When I shoot a target too close or too far away, I will only hit the chest.")

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
	rogue_early_release(shot, user, share)
	shot.damage = shot.damage * rogue_per_damage_factor(user.rogue_stat(ROGUE_STAT_PERCEPTION)) + (rogue_temp_stone ? rogue_stone_bonus : 0)

/obj/item/gun/ballistic/rogue_launcher/sling/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	. = ..()
	if(!chambered && rogue_temp_stone)
		QDEL_NULL(rogue_temp_stone)
		rogue_stone_bonus = 0

#undef ROGUE_LAUNCHER_DRAW_STRENGTH_BASELINE
#undef ROGUE_LAUNCHER_HEAVY_DRAW_PER_STRENGTH
#undef ROGUE_LAUNCHER_ARC_DRAW_EXTRA
#undef ROGUE_LAUNCHER_ARC_DRAW_FLOOR_EXTRA
#undef ROGUE_LAUNCHER_ONEHANDED_DRAW_MULT
#undef ROGUE_LAUNCHER_ONEHANDED_ARC_DRAW_MULT
#undef ROGUE_LAUNCHER_AIM_BASE
#undef ROGUE_LAUNCHER_AIM_PER_SKILL
#undef ROGUE_LAUNCHER_AIM_NPC_BASE
#undef ROGUE_LAUNCHER_AIM_VISUAL_REACH
#undef ROGUE_LAUNCHER_AIM_FARSIGHT_PENALTY
#undef ROGUE_LAUNCHER_AIM_ZCROSS_PENALTY
#undef ROGUE_LAUNCHER_AIM_FLOOR
#undef ROGUE_LAUNCHER_AIM_PRECISE_MAX
#undef ROGUE_LAUNCHER_MOUNTED_ACCURACY_FACTOR
#undef ROGUE_LAUNCHER_PRECISE_PENALTY
#undef ROGUE_LAUNCHER_ULTRA_PRECISE_PENALTY
#undef ROGUE_LAUNCHER_ZONE_MIN
#undef ROGUE_LAUNCHER_UNCHARGED_SPREAD
#undef ROGUE_LAUNCHER_HOLD_SPREAD_MAX
#undef ROGUE_LAUNCHER_UNCHARGED_ACCURACY_PENALTY
#undef ROGUE_LAUNCHER_UNCHARGED_EMBED_FACTOR
#undef ROGUE_LAUNCHER_NPC_DRAIN_MULT
#undef ROGUE_LAUNCHER_LETDOWN_DRAIN_MULT
#undef ROGUE_LAUNCHER_CROSSBOW_PER_MIN
#undef ROGUE_LAUNCHER_CROSSBOW_PER_MAX
#undef ROGUE_LAUNCHER_CROSSBOW_PER_DIVISOR
#undef ROGUE_LAUNCHER_SLING_STONE_FORCE
#undef ROGUE_LAUNCHER_EMBED_MIN_DAMAGE
#undef ROGUE_LAUNCHER_HIT_XP_PER_INT
#undef ROGUE_LAUNCHER_CROSSBOW_COCK_STRENGTH_STEP
#undef ROGUE_LAUNCHER_ARC_EXTRA_RANGE
#undef ROGUE_BOW_ARROW_SHIFT
#undef ROGUE_SOUND_BOW_DRAW
#undef ROGUE_SOUND_SLING_DRAW
#undef ROGUE_SOUND_CROSSBOW_COCK
#undef ROGUE_SOUND_CROSSBOW_READY
#undef ROGUE_SOUND_CROSSBOW_TWANG
