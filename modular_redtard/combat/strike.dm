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
	var/charge = rogue_take_charge(intent)
	if(charge < 0)
		changeNext_move(intent.clickcd)
		return FALSE
	var/datum/rogue_strike/strike = new(src, target, weapon, intent, ROGUE_STRIKE_MELEE, attack_modifiers)
	. = rogue_resolve_strike(strike, charge)
	var/paired = strike.paired
	qdel(strike)
	if(paired)
		rogue_paired_strike(target)

/mob/living/carbon/human/proc/rogue_resolve_strike(datum/rogue_strike/strike, charge)
	var/mob/living/target = strike.target
	var/obj/item/weapon = strike.weapon
	var/datum/intent/intent = strike.intent
	if(weapon && length(weapon.rogue_intents()))
		weapon.rogue_apply_intent(intent)
	face_atom(target)
	changeNext_move(max(round(intent.clickcd * rogue_rmb_factor("click_factor")), ROGUE_STRIKE_MIN_CLICK))
	rogue_mark_in_combat()
	target.rogue_mark_in_combat()
	if(SEND_SIGNAL(src, COMSIG_ROGUE_STRIKE_SWING, strike) & ROGUE_STRIKE_CANCEL)
		return FALSE
	if(!intent.noaa)
		playsound(src, rogue_swing_sound(weapon, intent), 100, FALSE, -1)
	if(intent.swingdelay > 0)
		var/datum/status_effect/rogue/swing/rigid/rigid = rogue_start_swing(intent)
		sleep(intent.swingdelay)
		var/broken = istype(rigid) && rigid.disrupted
		rogue_end_swing()
		if(broken || QDELETED(target) || incapacitated || !target.IsReachableBy(src, weapon ? weapon.reach : 1) || (weapon && (QDELETED(weapon) || !is_holding(weapon))) || rogue_strike_intent(weapon) != intent)
			return FALSE
	strike.paired = rogue_dual_wield_step(weapon)
	if(intent.releasedrain)
		adjust_stamina_loss(intent.releasedrain * rogue_rmb_factor("stamina_factor"))
	do_attack_animation(target, weapon ? null : ATTACK_EFFECT_PUNCH, weapon)
	rogue_swung()
	target.lastattacker = real_name
	target.lastattackerckey = ckey
	target.rogue_tempo_hit(src)
	var/incoming = target != src ? strike.incoming() : NONE
	if(incoming & ROGUE_STRIKE_CANCEL)
		return FALSE
	if(target != src && target.rogue_strike_missed(src))
		log_combat(src, target, "missed", weapon || intent.name)
		return FALSE
	var/damtype = weapon ? weapon.damtype : BRUTE
	var/force = weapon ? CALCULATE_FORCE(weapon, strike.attack_modifiers) : rogue_unarmed_damage()
	var/broke_swing = target != src && target.rogue_swing_struck()
	if(target != src && !broke_swing && !(incoming & ROGUE_STRIKE_UNDEFENDABLE) && target.check_block(weapon || src, force, weapon ? "\the [weapon]" : "the [intent.name]", weapon ? MELEE_ATTACK : UNARMED_ATTACK, weapon ? weapon.armour_penetration : 0, damtype))
		strike.defended = TRUE
		SEND_SIGNAL(target, COMSIG_ROGUE_STRIKE_DEFENDED, strike)
		return FALSE
	strike.zone = rogue_strike_zone(target, weapon, intent)
	rogue_combat_aware(target, strike.zone)
	if(length(intent.effect_stats) && (!length(intent.effect_zones) || (strike.zone in intent.effect_zones)))
		target.apply_status_effect(/datum/status_effect/rogue/intent_debuff, intent)
	var/edged = weapon?.max_blade_int && intent.get_sharpness()
	var/sharp_ratio = edged ? weapon.rogue_edge_ratio() : 1
	if(edged && sharp_ratio < ROGUE_BLADE_CHIP_START && prob(33))
		to_chat(src, span_info("The blade is dull..."))
	strike.damage = rogue_formula_value(ROGUE_FORMULA_STRIKE_DAMAGE, list(
		"force" = force,
		"strength_factor" = weapon ? rogue_strength_factor(weapon, src) : 1,
		"damage_factor" = intent.damfactor,
		"stance_factor" = rogue_rmb_factor("damage_factor"),
		"prone" = body_position == LYING_DOWN,
		"edge" = clamp((sharp_ratio - ROGUE_BLADE_DULL_FLOOR) / (ROGUE_BLADE_DULL_START - ROGUE_BLADE_DULL_FLOOR), 0, 1),
		"chipped" = sharp_ratio < ROGUE_BLADE_CHIP_START ? sharp_ratio * 2 : 1,
		"uncharged" = intent.chargetime > 0 && charge < 1,
	))
	target.rogue_take_strike(strike)
	if(edged && !QDELETED(weapon))
		weapon.rogue_dull(ROGUE_BLADE_HIT_WEAR + intent.sharpness_penalty, src)
	if(mind)
		rogue_change_dodge_fatigue(ROGUE_DEFENSE_RECOVERY)
		rogue_change_dodge_cooldown(-ROGUE_DEFENSE_RECOVERY)
	if(intent.cleave && weapon)
		rogue_cleave(strike)
	return TRUE

/mob/living/proc/rogue_take_strike(datum/rogue_strike/strike)
	var/mob/living/attacker = strike.attacker
	var/obj/item/weapon = strike.weapon
	var/datum/intent/intent = strike.intent
	var/zone = strike.zone
	var/damage = strike.damage
	var/def_zone = rogue_zone_target(zone)
	var/damtype = weapon ? weapon.damtype : BRUTE
	// The target's name on the strike's line: as it was known when the blow fell, before a crit disfigures its face or
	// a blade takes its head (a human without a face is "Unknown").
	var/struck_name = "\the [src]"
	var/blocked = min(run_armor_check(def_zone, MELEE, armour_penetration = weapon?.armour_penetration, silent = TRUE, weak_against_armour = weapon?.weak_against_armour), ARMOR_MAX_BLOCK)
	var/penetration = intent.penfactor
	if(body_position != LYING_DOWN && intent.out_of_effective_range(get_dist(attacker, src)))
		penetration = ROGUE_PEN_NONE
		damage *= ROGUE_EFFECTIVE_RANGE_DAMAGE
	if(weapon)
		SEND_SIGNAL(weapon, COMSIG_ITEM_ATTACK_ZONE, src, attacker, def_zone)
		if(mob_biotypes & (MOB_ROBOTIC|MOB_MINERAL|MOB_SKELETAL))
			damage *= weapon.get_demolition_modifier(src)
	var/obj/item/clothing/armor_hit
	rogue_strike_notes = list()
	if(ishuman(src) && damtype == BRUTE)
		var/mob/living/carbon/human/armored = src
		armor_hit = armored.rogue_best_armor(zone, intent.item_d_type)
		damage *= armored.rogue_armor_hit(zone, intent.item_d_type, damage, penetration, rogue_wear_factor(weapon, intent), weapon, intent.blade_class)
	var/damage_done = rogue_apply_armored_damage(
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
	strike.damage_done = damage_done
	LAZYSET(strike.attack_modifiers, DAMAGE_DONE, damage_done)
	if(damage_done <= 0)
		var/integrity = armor_hit?.rogue_integrity_text()
		rogue_strike_notes += integrity ? "[ROGUE_ARMOR_BLOCKED_TEXT] [integrity]" : ROGUE_ARMOR_BLOCKED_TEXT
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
	// Everything the blow did lands before its line is told, so the line carries it all (combat/chat.dm): the armor,
	// a crit and its wounds, then a severed limb.
	if(damage_done > 0)
		rogue_try_crit(intent.blade_class, damage_done, attacker, zone)
		rogue_try_dismember(weapon, intent, attacker, zone, damage)
	rogue_strike_message(attacker, weapon, intent, zone, struck_name)
	rogue_strike_notes = null
	if(damage_done > 0)
		rogue_pop_open()
	SEND_SIGNAL(src, COMSIG_ROGUE_STRIKE_LANDED, strike)
	weapon?.rogue_after_strike(src, attacker, strike.attack_modifiers)
	log_combat(attacker, src, strike.kind == ROGUE_STRIKE_CLEAVE ? "cleaved" : "struck", weapon || intent.name, "(INTENT: [uppertext(intent.name)]) (ZONE: [zone]) (DAMAGE: [damage_done]) (DAMTYPE: [uppertext(damtype)])")
	return damage_done

/// Ratwood's strike line (send_item_attack_message): the struck part highlighted, and the strike's notes after it
/// (armor, crits, wounds, a severed limb; combat/chat.dm). The attacker reads it as everyone around does.
/// struck_name: how the line names the target, when it was named before the blow changed it (rogue_take_strike).
/mob/living/proc/rogue_strike_message(mob/living/attacker, obj/item/weapon, datum/intent/intent, zone, struck_name)
	var/hit_verb = length(intent.attack_verb) ? pick(intent.attack_verb) : "hits"
	var/hit_area = span_userdanger((iscarbon(src) ? rogue_zone_name(zone) : "body"))
	var/with = weapon ? " with [weapon]" : ""
	var/notes = length(rogue_strike_notes) ? " [jointext(rogue_strike_notes, " ")]" : ""
	if(attacker == src)
		to_chat(src, span_danger("I [rogue_first_person_verb(hit_verb)] myself in the [hit_area][with]![notes]"))
		return
	var/who = (attacker in viewers(src, null)) ? "[attacker]" : "Someone"
	var/whom = struck_name || "\the [src]"
	visible_message(span_danger("[who] [hit_verb] [whom] in the [hit_area][with]![notes]"), span_danger("[who] [hit_verb] me in the [hit_area][with]![notes]"), null, COMBAT_MESSAGE_RANGE)

/// An intent's verb as said of oneself: "slashes" -> "slash", "cuts across" -> "cut across", "lunges and hacks" ->
/// "lunge and hack", "viciously bites" -> "viciously bite". Intents name their verbs in the third person.
/proc/rogue_first_person_verb(verb_text)
	var/static/regex/third_person = regex(@"\b([A-Za-z\-]+?)(ies|sses|shes|ches|xes|zzes|oes|s)\b", "g")
	return third_person.Replace(verb_text, GLOBAL_PROC_REF(rogue_verb_stem))

/// One word of rogue_first_person_verb(): the verb without its third person ending; words that only end in s stay.
/proc/rogue_verb_stem(word, stem, ending)
	var/static/list/kept = list("this", "thus", "always", "towards", "upwards", "downwards", "backwards", "sideways", "afterwards")
	if(length(word) <= 3 || (LOWER_TEXT(word) in kept))
		return word
	switch(ending)
		if("ies")
			return length(stem) >= 2 ? "[stem]y" : copytext(word, 1, -1)
		if("sses", "shes", "ches", "xes", "zzes")
			return copytext(word, 1, -2)
		if("oes")
			return "[stem]o"
	// A plain -s: "across" and "kiss" end in -ss and are no third person.
	return copytext(stem, -1) == "s" ? word : stem

/obj/item/proc/rogue_after_strike(mob/living/target, mob/living/user, list/attack_modifiers)
	SEND_SIGNAL(src, COMSIG_ITEM_AFTERATTACK, target, user, null, attack_modifiers)
	SEND_SIGNAL(target, COMSIG_ATOM_AFTER_ATTACKEDBY, src, user, null, attack_modifiers)
	afterattack(target, user, null, attack_modifiers)
	add_fingerprint(user)

/datum/element/rogue_combat/proc/on_pre_item_attack(mob/living/carbon/human/source, obj/item/weapon, atom/target, list/modifiers, list/attack_modifiers)
	SIGNAL_HANDLER
	if(!isliving(target) || (weapon.item_flags & NOBLUDGEON) || !source.is_holding(weapon) || CALCULATE_FORCE(weapon, attack_modifiers) <= 0)
		return NONE
	var/datum/intent/intent = source.rogue_strike_intent(weapon)
	if(intent.no_attack)
		return NONE
	if(intent.tranged)
		return COMPONENT_CANCEL_ATTACK_CHAIN
	INVOKE_ASYNC(source, TYPE_PROC_REF(/mob/living/carbon/human, rogue_strike), target, weapon, intent, attack_modifiers)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/// A balloon only the viewers with a trait see (Ratwood filtered_balloon_alert).
/atom/proc/rogue_trait_balloon(trait, text)
	for(var/mob/living/viewer in viewers(DEFAULT_MESSAGE_RANGE, get_turf(src)))
		if(viewer.client && HAS_TRAIT(viewer, trait))
			balloon_alert(viewer, text)

/// Combat Aware (Ratwood): the attacker sees where the blow landed, onlookers see where the attacker aims; Deceiving Meekness hides the aim.
/mob/living/carbon/human/proc/rogue_combat_aware(mob/living/target, zone)
	if(target == src)
		return
	if(HAS_TRAIT(src, TRAIT_COMBAT_AWARE))
		target.balloon_alert(src, "[rogue_zone_name(zone)]...")
	var/aim_text = "[rogue_zone_name(rogue_precise_zone())]..."
	if(HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))
		if(!prob(ROGUE_MEEKNESS_HINT_CHANCE))
			return
		aim_text = "<i>I can't tell...</i>"
	for(var/mob/living/carbon/human/onlooker in viewers(DEFAULT_MESSAGE_RANGE, src))
		if(onlooker != src && onlooker.client && HAS_TRAIT(onlooker, TRAIT_COMBAT_AWARE))
			balloon_alert(onlooker, aim_text)
