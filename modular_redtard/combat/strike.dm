GLOBAL_LIST_INIT(rogue_major_zones, list(
	"head" = "head",
	"skull" = "head",
	"nose" = "head",
	"ears" = "head",
	"neck" = "head",
	"r_eye" = "head",
	"l_eye" = "head",
	BODY_ZONE_PRECISE_EYES = "head",
	"mouth" = "head",
	"chest" = "chest",
	"stomach" = "chest",
	"groin" = "chest",
	"r_arm" = "r_arm",
	"r_hand" = "r_arm",
	"l_arm" = "l_arm",
	"l_hand" = "l_arm",
	"r_leg" = "r_leg",
	"r_foot" = "r_leg",
	"l_leg" = "l_leg",
	"l_foot" = "l_leg",
))
GLOBAL_LIST_INIT(rogue_face_zones, list("head", "skull", "nose", "ears", "r_eye", "l_eye", BODY_ZONE_PRECISE_EYES, "mouth"))
GLOBAL_LIST_INIT(rogue_low_zones, list("r_leg", "l_leg", "r_foot", "l_foot"))
GLOBAL_LIST_INIT(rogue_swing_sounds, list(
	"bladed_small" = list('modular_redtard/rockhill/sound/combat/wooshes/bladed/wooshsmall (1).ogg', 'modular_redtard/rockhill/sound/combat/wooshes/bladed/wooshsmall (2).ogg', 'modular_redtard/rockhill/sound/combat/wooshes/bladed/wooshsmall (3).ogg'),
	"bladed_med" = list('modular_redtard/rockhill/sound/combat/wooshes/bladed/wooshmed (1).ogg', 'modular_redtard/rockhill/sound/combat/wooshes/bladed/wooshmed (2).ogg', 'modular_redtard/rockhill/sound/combat/wooshes/bladed/wooshmed (3).ogg'),
	"bladed_large" = list('modular_redtard/rockhill/sound/combat/wooshes/bladed/wooshlarge (1).ogg', 'modular_redtard/rockhill/sound/combat/wooshes/bladed/wooshlarge (2).ogg', 'modular_redtard/rockhill/sound/combat/wooshes/bladed/wooshlarge (3).ogg'),
	"blunt_small" = list('modular_redtard/rockhill/sound/combat/wooshes/blunt/wooshmed (1).ogg', 'modular_redtard/rockhill/sound/combat/wooshes/blunt/wooshmed (2).ogg', 'modular_redtard/rockhill/sound/combat/wooshes/blunt/wooshmed (3).ogg'),
	"blunt_med" = list('modular_redtard/rockhill/sound/combat/wooshes/blunt/wooshmed (1).ogg', 'modular_redtard/rockhill/sound/combat/wooshes/blunt/wooshmed (2).ogg', 'modular_redtard/rockhill/sound/combat/wooshes/blunt/wooshmed (3).ogg'),
	"blunt_large" = list('modular_redtard/rockhill/sound/combat/wooshes/blunt/wooshlarge (1).ogg', 'modular_redtard/rockhill/sound/combat/wooshes/blunt/wooshlarge (2).ogg', 'modular_redtard/rockhill/sound/combat/wooshes/blunt/wooshlarge (3).ogg'),
	"punch" = list('modular_redtard/rockhill/sound/combat/wooshes/punch/punchwoosh (1).ogg', 'modular_redtard/rockhill/sound/combat/wooshes/punch/punchwoosh (2).ogg', 'modular_redtard/rockhill/sound/combat/wooshes/punch/punchwoosh (3).ogg'),
))
GLOBAL_LIST_INIT(rogue_punch_hit_sounds, list('modular_redtard/rockhill/sound/combat/hits/punch/punch (1).ogg', 'modular_redtard/rockhill/sound/combat/hits/punch/punch (2).ogg', 'modular_redtard/rockhill/sound/combat/hits/punch/punch (3).ogg'))
GLOBAL_LIST_INIT(rogue_no_damage_sounds, list('modular_redtard/rockhill/sound/combat/hits/nodmg (1).ogg', 'modular_redtard/rockhill/sound/combat/hits/nodmg (2).ogg'))

/datum/intent/rogue_fallback
	name = "strike"
	icon_state = "instrike"
	attack_verb = list("strikes", "hits")
	hitsound = list('modular_redtard/rockhill/sound/combat/hits/blunt/genblunt (1).ogg', 'modular_redtard/rockhill/sound/combat/hits/blunt/genblunt (2).ogg', 'modular_redtard/rockhill/sound/combat/hits/blunt/genblunt (3).ogg')

/datum/intent/rogue_fallback/cut
	name = "cut"
	icon_state = "incut"
	blade_class = BCLASS_CUT
	item_d_type = ROGUE_ARMOR_SLASH
	attack_verb = list("cuts", "slashes")
	hitsound = list('modular_redtard/rockhill/sound/combat/hits/bladed/genslash (1).ogg', 'modular_redtard/rockhill/sound/combat/hits/bladed/genslash (2).ogg', 'modular_redtard/rockhill/sound/combat/hits/bladed/genslash (3).ogg')

/datum/intent/rogue_fallback/stab
	name = "stab"
	icon_state = "instab"
	blade_class = BCLASS_STAB
	item_d_type = ROGUE_ARMOR_STAB
	attack_verb = list("stabs")
	hitsound = list('modular_redtard/rockhill/sound/combat/hits/bladed/genstab (1).ogg', 'modular_redtard/rockhill/sound/combat/hits/bladed/genstab (2).ogg', 'modular_redtard/rockhill/sound/combat/hits/bladed/genstab (3).ogg')

/proc/rogue_fallback_intent(obj/item/weapon)
	var/sharpness = weapon.get_sharpness()
	if(sharpness & SHARP_EDGED)
		return rogue_intent(/datum/intent/rogue_fallback/cut)
	if(sharpness & SHARP_POINTY)
		return rogue_intent(/datum/intent/rogue_fallback/stab)
	return rogue_intent(/datum/intent/rogue_fallback)

/proc/rogue_swing_sound(obj/item/weapon, datum/intent/intent)
	if(!weapon)
		return pick(GLOB.rogue_swing_sounds["punch"])
	var/size = weapon.w_class <= WEIGHT_CLASS_SMALL ? "small" : (weapon.w_class <= WEIGHT_CLASS_NORMAL ? "med" : "large")
	return pick(GLOB.rogue_swing_sounds["[intent.get_sharpness() ? "bladed" : "blunt"]_[size]"])

/mob/living/carbon/human/proc/rogue_strike_intent(obj/item/weapon)
	if(!weapon)
		return rogue_active_intent()
	var/hand_index = get_held_index_of_item(weapon)
	var/datum/intent/intent = (hand_index && length(weapon.rogue_intents())) ? rogue_hand_intent(hand_index) : null
	return (intent && !intent.unarmed) ? intent : rogue_fallback_intent(weapon)

/mob/living/carbon/human/proc/rogue_strike_zone(mob/living/target, obj/item/weapon, datum/intent/intent)
	var/zone = rogue_precise_zone()
	var/major = GLOB.rogue_major_zones[zone] || BODY_ZONE_CHEST
	if(target == src || zone == BODY_ZONE_CHEST || IS_UNCONSCIOUS_OR_CRIT(target))
		return zone
	var/perception = rogue_stat(ROGUE_STAT_PERCEPTION)
	var/precise = zone != major
	var/blade_class = intent.blade_class
	var/grab_state = 0
	if(target.pulledby)
		grab_state = target.pulledby.grab_state > GRAB_PASSIVE ? 2 : 1
	else if(target.pulling)
		grab_state = 1
	var/chance = rogue_formula_value(ROGUE_FORMULA_STRIKE_ACCURACY, list(
		"major_zone" = !precise,
		"face_zone" = (zone in GLOB.rogue_face_zones) && !!target.mind,
		"perception" = perception,
		"grab_state" = grab_state,
		"target_prone" = target.body_position == LYING_DOWN,
		"target_open" = !!target.has_status_effect(/datum/status_effect/rogue_vulnerable),
		"low_aim" = body_position == LYING_DOWN && (zone in GLOB.rogue_low_zones),
		"weapon_skill" = rogue_weapon_rank(weapon),
		"stab" = blade_class == BCLASS_STAB,
		"pick" = blade_class == BCLASS_PICK,
		"cut" = blade_class == BCLASS_CUT,
		"blunt_precise" = (blade_class == BCLASS_BLUNT || blade_class == BCLASS_SMASH) && precise,
		"short_weapon" = !weapon || weapon.wlength == WLENGTH_SHORT,
		"aimed" = rogue_rmb_is(/datum/rogue_rmb_intent/aimed),
		"swift" = rogue_rmb_is(/datum/rogue_rmb_intent/swift),
	))
	if(prob(chance))
		return zone
	if(prob(chance + perception - ROGUE_ATTRIBUTE_MIDDLING))
		if(!precise)
			return zone
		return perception > ROGUE_ATTRIBUTE_MIDDLING ? major : BODY_ZONE_CHEST
	return BODY_ZONE_CHEST

/mob/living/proc/rogue_strike_missed(mob/living/attacker)
	if(stat != STABLE || body_position == LYING_DOWN || !attacker.rogue_badluck(ROGUE_STRIKE_MISS_LUCK))
		return FALSE
	rogue_badluck_message(attacker)
	return TRUE

/mob/living/carbon/human/proc/rogue_strike(mob/living/target, obj/item/weapon, datum/intent/intent, list/attack_modifiers)
	if(QDELETED(target) || incapacitated || (weapon && (QDELETED(weapon) || !is_holding(weapon))))
		return FALSE
	var/damtype = weapon ? weapon.damtype : BRUTE
	if(damtype != STAMINA && HAS_TRAIT(src, TRAIT_PACIFISM))
		to_chat(src, span_warning("I don't want to harm other living beings!"))
		return FALSE
	if(weapon && length(weapon.rogue_intents()))
		weapon.rogue_apply_intent(intent)
	face_atom(target)
	changeNext_move(max(round(intent.clickcd * rogue_rmb_factor("click_factor")), ROGUE_STRIKE_MIN_CLICK))
	rogue_mark_in_combat()
	target.rogue_mark_in_combat()
	if(intent.releasedrain)
		adjust_stamina_loss(intent.releasedrain * rogue_rmb_factor("stamina_factor"))
	playsound(src, rogue_swing_sound(weapon, intent), 100, FALSE, -1)
	do_attack_animation(target, weapon ? null : ATTACK_EFFECT_PUNCH, weapon)
	target.lastattacker = real_name
	target.lastattackerckey = ckey
	if(target != src && target.rogue_strike_missed(src))
		log_combat(src, target, "missed", weapon || intent.name)
		return FALSE
	var/force = weapon ? CALCULATE_FORCE(weapon, attack_modifiers) : rogue_unarmed_damage()
	if(target != src && target.check_block(weapon || src, force, weapon ? "\the [weapon]" : "the [intent.name]", weapon ? MELEE_ATTACK : UNARMED_ATTACK, weapon ? weapon.armour_penetration : 0, damtype))
		return FALSE
	var/zone = rogue_strike_zone(target, weapon, intent)
	var/damage = rogue_formula_value(ROGUE_FORMULA_STRIKE_DAMAGE, list(
		"force" = force,
		"strength_factor" = weapon ? rogue_strength_factor(weapon, src) : 1,
		"damage_factor" = intent.damfactor,
		"stance_factor" = rogue_rmb_factor("damage_factor"),
		"prone" = body_position == LYING_DOWN,
	))
	target.rogue_take_strike(src, weapon, intent, zone, damage, attack_modifiers)
	return TRUE

/mob/living/proc/rogue_take_strike(mob/living/attacker, obj/item/weapon, datum/intent/intent, zone, damage, list/attack_modifiers)
	var/def_zone = rogue_zone_target(zone)
	var/damtype = weapon ? weapon.damtype : BRUTE
	var/blocked = run_armor_check(def_zone, MELEE, armour_penetration = weapon?.armour_penetration, silent = TRUE, weak_against_armour = weapon?.weak_against_armour)
	if(!weapon && ishuman(src))
		var/mob/living/carbon/human/human_target = src
		blocked += human_target.rogue_armor_protection(def_zone, ROGUE_ARMOR_BLUNT, 0)
	blocked = min(blocked, ARMOR_MAX_BLOCK)
	if(weapon)
		SEND_SIGNAL(weapon, COMSIG_ITEM_ATTACK_ZONE, src, attacker, def_zone)
		if(mob_biotypes & (MOB_ROBOTIC|MOB_MINERAL|MOB_SKELETAL))
			damage *= weapon.get_demolition_modifier(src)
	var/damage_done = apply_damage(
		damage = damage,
		damagetype = damtype,
		def_zone = def_zone,
		blocked = blocked,
		wound_bonus = weapon ? weapon.wound_bonus : 0,
		exposed_wound_bonus = weapon ? weapon.exposed_wound_bonus : 0,
		sharpness = weapon ? weapon.get_sharpness() : NONE,
		attack_direction = get_dir(attacker, src),
		attacking_item = weapon,
	)
	LAZYSET(attack_modifiers, DAMAGE_DONE, damage_done)
	rogue_strike_message(attacker, weapon, intent, zone, damage_done)
	var/hit_sound = pick(GLOB.rogue_no_damage_sounds)
	if(damage_done > 0)
		hit_sound = length(intent.hitsound) ? pick(intent.hitsound) : (weapon ? weapon.hitsound : pick(GLOB.rogue_punch_hit_sounds))
	if(hit_sound)
		playsound(src, hit_sound, 100, FALSE, -1)
	if(damtype == BRUTE && can_bleed() && damage_done > (intent.get_sharpness() ? ROGUE_STRIKE_BLOOD_DAMAGE : ROGUE_STRIKE_BLUNT_BLOOD_DAMAGE))
		weapon?.add_mob_blood(src)
		add_splatter_floor(get_turf(src))
		if(get_dist(attacker, src) <= 1)
			attacker.add_mob_blood(src)
	weapon?.rogue_after_strike(src, attacker, attack_modifiers)
	log_combat(attacker, src, "struck", weapon || intent.name, "(INTENT: [uppertext(intent.name)]) (ZONE: [zone]) (DAMAGE: [damage_done]) (DAMTYPE: [uppertext(damtype)])")
	return damage_done

/mob/living/proc/rogue_strike_message(mob/living/attacker, obj/item/weapon, datum/intent/intent, zone, damage_done)
	var/hit_verb = length(intent.attack_verb) ? pick(intent.attack_verb) : "hits"
	var/hit_area = iscarbon(src) ? rogue_zone_name(zone) : "body"
	var/with = weapon ? " with [weapon]" : ""
	var/stopped = damage_done > 0 ? "" : " Armor stops the damage."
	var/seen = (attacker in viewers(src, null))
	var/spectator_text = "[seen ? "[attacker]" : "Someone"] [hit_verb] [src] in the [hit_area][with]![stopped]"
	var/victim_text = "[seen ? "[attacker]" : "Someone"] [hit_verb] me in the [hit_area][with]![stopped]"
	if(attacker == src)
		to_chat(src, span_danger("I [hit_verb] myself in the [hit_area][with]![stopped]"))
		return
	visible_message(span_danger(spectator_text), span_userdanger(victim_text), null, COMBAT_MESSAGE_RANGE, attacker)
	to_chat(attacker, span_boldwarning("[attacker] [hit_verb] [src] in the [hit_area][with]![stopped]"))

/obj/item/proc/rogue_after_strike(mob/living/target, mob/living/user, list/attack_modifiers)
	SEND_SIGNAL(src, COMSIG_ITEM_AFTERATTACK, target, user, null, attack_modifiers)
	SEND_SIGNAL(target, COMSIG_ATOM_AFTER_ATTACKEDBY, src, user, null, attack_modifiers)
	afterattack(target, user, null, attack_modifiers)
	add_fingerprint(user)

/datum/element/rogue_striker
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

/datum/element/rogue_striker/Attach(datum/target)
	. = ..()
	if(!ishuman(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_USER_PRE_ITEM_ATTACK, PROC_REF(on_pre_item_attack))

/datum/element/rogue_striker/Detach(datum/source)
	UnregisterSignal(source, COMSIG_USER_PRE_ITEM_ATTACK)
	return ..()

/datum/element/rogue_striker/proc/on_pre_item_attack(mob/living/carbon/human/source, obj/item/weapon, atom/target, list/modifiers, list/attack_modifiers)
	SIGNAL_HANDLER
	if(!isliving(target) || (weapon.item_flags & NOBLUDGEON) || !source.is_holding(weapon) || CALCULATE_FORCE(weapon, attack_modifiers) <= 0)
		return NONE
	var/datum/intent/intent = source.rogue_strike_intent(weapon)
	if(intent.no_attack)
		return NONE
	INVOKE_ASYNC(source, TYPE_PROC_REF(/mob/living/carbon/human, rogue_strike), target, weapon, intent, attack_modifiers)
	return COMPONENT_CANCEL_ATTACK_CHAIN
