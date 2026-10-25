GLOBAL_LIST_INIT(rogue_formula_definitions, list(
	ROGUE_FORMULA_STRENGTH_FACTOR = list(
		"if(strength > 14, 1.4 + (strength - 14) * 0.034, 1 + (strength - 10) * 0.1) * if(min_strength > strength, 0.3, 1)",
		"Damage multiplier from the attacker's strength (Ratwood). min_strength is the weapon's need, halved when wielded, 0 if none.",
		list("strength", "min_strength"),
	),
	ROGUE_FORMULA_WEAPON_DEFENSE = list(
		"skill * 20 + defense * 10",
		"Parry value of one weapon or of bare hands (Azure Peak): weapon skill rank and weapon defense.",
		list("skill", "defense"),
	),
	ROGUE_FORMULA_SPEED_PRESSURE = list(
		"if(swift_attack and attacker_speed > defender_speed, clamp((attacker_speed - defender_speed) * 10 - max(0, (defender_perception - attacker_perception) * if(attacker_armed, 5, 10)) - max(0, (defender_intelligence - attacker_intelligence) * 3), 0, 30), 0)",
		"Parry penalty when a faster attacker uses a swift weapon or bare hands (Azure Peak); perception and intelligence offset it.",
		list("swift_attack", "attacker_armed", "attacker_speed", "defender_speed", "attacker_perception", "defender_perception", "attacker_intelligence", "defender_intelligence"),
	),
	ROGUE_FORMULA_PARRY_CHANCE = list(
		"clamp((defense - attacker_skill * 20 - running * 15 + swift_guard * 10 - speed_pressure) * if(prone, 0.65, 1) - dual_wield * 5, 5, if(untrained_armor, 75, 90))",
		"Parry chance in percent (Azure Peak). defense is the best weapon_defense; swift_guard is a lone swift weapon in light armor.",
		list("defense", "attacker_skill", "running", "swift_guard", "speed_pressure", "prone", "dual_wield", "untrained_armor"),
	),
	ROGUE_FORMULA_DODGE_CHANCE = list(
		"clamp(if(prone, 0.25, 1) * if(dodge_expert and not prone, 90, 50 + (defender_speed - attacker_speed) * 10 - if(swift_attack and attacker_speed > defender_speed, (attacker_speed - defender_speed) * 10, 0) + if(heavy_attack and defender_speed > attacker_speed, (defender_speed - attacker_speed) * 10, 0) + if(improvised, 10, (defender_skill - attacker_skill) * 10)) - dual_wield * 5, 5, 90)",
		"Dodge chance in percent (Azure Peak). defender_skill is the defender's rank in the attacker's skill; improvised is a weapon without a skill.",
		list("defender_speed", "attacker_speed", "swift_attack", "heavy_attack", "improvised", "defender_skill", "attacker_skill", "prone", "dodge_expert", "dual_wield"),
	),
	ROGUE_FORMULA_ARMOR_PROTECTION = list(
		"clamp(rating - penetration, 0, 100)",
		"Percent of damage the best covering armor stops (Ratwood).",
		list("rating", "penetration"),
	),
	ROGUE_FORMULA_ARMOR_WEAR = list(
		"if(blunt_attack, incoming - incoming * max(blunt_rating, 0) / 200, if(incoming + penetration > rating, if(penetration >= rating, incoming / 2, max(rating - penetration, incoming * 0.4)), incoming))",
		"Integrity the armor loses from one hit (Ratwood). incoming is the damage before armor.",
		list("incoming", "rating", "penetration", "blunt_attack", "blunt_rating"),
	),
	ROGUE_FORMULA_WOUND_CONSTITUTION = list(
		"clamp(1 - (constitution - 10) * 0.03, 0.5, 1.5)",
		"Wound chance multiplier from constitution.",
		list("constitution"),
	),
	ROGUE_FORMULA_FEINT_CHANCE = list(
		"if(target_vulnerable, 0, clamp(50 + (skill - target_skill) * 15 + (intelligence - target_intelligence) * 10, 10, 90))",
		"Feint success chance in percent (Azure Peak): weapon skill ranks and intelligence of both sides. A target that is already open cannot be feinted again.",
		list("skill", "target_skill", "intelligence", "target_intelligence", "target_vulnerable"),
	),
	ROGUE_FORMULA_LOOK_AROUND_TIME = list(
		"clamp(50 - perception * 2 - tracking * 5, 7, 50)",
		"How long looking around takes, in deciseconds (Azure Peak).",
		list("perception", "tracking"),
	),
	ROGUE_FORMULA_LOOK_AROUND_CHANCE = list(
		"max(perception * 2 + tracking * 5 - target_stealth * 5 - if(target_perception > 10, target_perception / 2, 0), 5)",
		"Chance in percent that looking around finds a hidden creature (Azure Peak). target_stealth is the best of its sneaking, holy and arcane ranks, 0 without a mind.",
		list("perception", "tracking", "target_stealth", "target_perception"),
	),
	ROGUE_FORMULA_ENERGY_MAX = list(
		"(willpower + athletics / 2) * 100",
		"Maximum energy (blue stamina) from willpower and the athletics rank (Azure Peak).",
		list("willpower", "athletics"),
	),
	ROGUE_FORMULA_MINING_SWINGS = list(
		"ceil(integrity / max(force * (8 + mining * 1.5), 1))",
		"Pick swings needed to break a rock wall (Ratwood): wall integrity, the pick's force and the mining rank. One swing takes a melee click delay.",
		list("integrity", "force", "mining"),
	),
	ROGUE_FORMULA_WINDOW_PRY_TIME = list(
		"clamp(100 - (lockpicking * 8 + perception / 4 * 5 + speed / 4 * 5 + picklvl * 2), 20, 70)",
		"Time of one attempt to pry a window with a knife, in deciseconds (Ratwood).",
		list("lockpicking", "perception", "speed", "picklvl", "open"),
	),
	ROGUE_FORMULA_WINDOW_PRY_PROGRESS = list(
		"clamp(10 + lockpicking * 6 + perception / 4 + speed / 8 + picklvl * 2, 10, 100)",
		"Progress of one successful attempt; the window gives at 100 (reinforced 150) (Ratwood).",
		list("lockpicking", "perception", "speed", "picklvl", "open"),
	),
	ROGUE_FORMULA_WINDOW_PRY_CHANCE = list(
		"clamp((10 + lockpicking * 11 + perception / 4 * 4 + speed / 4 * 3) * picklvl * if(open, 1.1, 1), 1, 96)",
		"Chance in percent that one attempt succeeds; a failure breaks the window (Ratwood). picklvl is the knife's lockpicking level.",
		list("lockpicking", "perception", "speed", "picklvl", "open"),
	),
	ROGUE_FORMULA_TRAP_SET_TIME = list(
		"max((8 - max(crafting * 2, 2)) * 10, 0)",
		"Time to arm a floor trap by hand, in deciseconds (Ratwood). Needs crafting 1 or more.",
		list("crafting"),
	),
	ROGUE_FORMULA_TRAP_DISARM_TIME = list(
		"max((14 - max(crafting * 2, 2)) * 10, 0)",
		"Time to disarm a floor trap by hand, in deciseconds (Ratwood). Needs crafting 1 or more.",
		list("crafting"),
	),
	ROGUE_FORMULA_MANTRAP_SET_TIME = list(
		"max(50 - strength * 2, 0)",
		"Time to spring open or shut a mantrap held in hand, in deciseconds (Ratwood).",
		list("strength", "crafting"),
	),
	ROGUE_FORMULA_MANTRAP_SET_CHANCE = list(
		"clamp(10 + crafting * 15, 0, 100)",
		"Chance in percent to arm or shut a mantrap held in hand (Ratwood).",
		list("strength", "crafting"),
	),
	ROGUE_FORMULA_MANTRAP_DISARM_TIME = list(
		"max(100 - max(crafting * 20, 20), 0)",
		"Time to disarm an armed mantrap on the ground, in deciseconds (Ratwood); an interruption springs it on the hand.",
		list("crafting"),
	),
	ROGUE_FORMULA_LOOK_AROUND_SPOT = list(
		"perception >= 8 + target_sneaking * 2",
		"Whether looking around marks a hiding place with someone tucked inside (Azure Peak): non-zero means found.",
		list("perception", "target_sneaking"),
	),
	ROGUE_FORMULA_UNARMED_DAMAGE = list(
		"(17 + civilized * 5) * if(strength > 14, 1.4 + (strength - 14) * 0.034, 1 + (strength - 10) * 0.1)",
		"Bare-handed damage before the strike formula: a punch, twisting, chewing, headbutting (Ratwood get_punch_dmg). civilized is the civilized barbarian trait.",
		list("strength", "civilized"),
	),
	ROGUE_FORMULA_GRAB_CHANCE = list(
		"clamp(((4 + strength_diff / 2 + skill_diff) * 10 + noise) * modifier, 5, 95)",
		"Chance in percent to tighten a grab, or to shove a grabbed foe down (Ratwood). Strength and wrestling are grabber minus target; noise is -5 to 5; modifier is 2 for a compliant target, +0.25 restrained, +0.05 lying, +-0.3 for combat readiness, +0.15 chokehold.",
		list("strength_diff", "skill_diff", "noise", "modifier"),
	),
	ROGUE_FORMULA_GRAB_DISARM_CHANCE = list(
		"clamp((3 + strength_diff / 4 + skill_diff) * 10 * modifier, 5, 95) - weapon_skill * 5 - wielded * 20",
		"Chance in percent to take the item from a grabbed hand (Ratwood); 20 more to knock it to the floor instead. weapon_skill is the holder's rank in the item's skill.",
		list("strength_diff", "skill_diff", "modifier", "weapon_skill", "wielded"),
	),
	ROGUE_FORMULA_GRAB_PIN_TIME = list(
		"max((65 + skill_diff * 10 + strength_diff * 5) * modifier, 20)",
		"How long one pin holds a grabbed foe on the ground, in deciseconds (Ratwood).",
		list("strength_diff", "skill_diff", "modifier"),
	),
	ROGUE_FORMULA_GRAB_SMASH_DAMAGE = list(
		"punch * (1 + unarmed / 10)",
		"Damage of smashing a grabbed limb into a wall, floor or table (Ratwood). punch is unarmed_damage, unarmed the unarmed skill rank.",
		list("punch", "unarmed"),
	),
	ROGUE_FORMULA_CHOKE_DAMAGE = list(
		"if(strength > 14, 14, strength * 0.75) * if(chokehold, 1.2, 1) * if(held_back, 0.95, 1)",
		"Suffocation per choke of a neck grab (Ratwood). chokehold: grabbed from behind; held_back: the victim holds the choker aggressively.",
		list("strength", "chokehold", "held_back"),
	),
	ROGUE_FORMULA_BITE_DAMAGE = list(
		"strength / 2 * if(strong_bite, 2, 1)",
		"Damage of the first bite (Ratwood); it only hurts a limb that is already wounded unless the biter has a strong bite.",
		list("strength", "strong_bite"),
	),
	ROGUE_FORMULA_STRIKE_ACCURACY = list(
		"clamp(major_zone * 10 - face_zone * 24 + if(perception > 10, min((perception - 10) * 8, 40), 0) - if(perception < 10, (10 - perception) * 10, 0) + if(grab_state >= 2, 20, if(grab_state >= 1, 10, 0)) + target_prone * 30 + target_open * 20 + low_aim * 5 + weapon_skill * 8 + stab * 10 + pick * 15 + cut * 6 - blunt_precise * 10 + short_weapon * 10 + aimed * 20 - swift * 20, 5, 95)",
		"Chance in percent that a blow lands on the aimed body part (Azure Peak resolve_aimed_zone). major_zone: a whole limb, head or chest; face_zone: head or face against someone with a mind; grab_state: 1 held, 2 held aggressively; low_aim: the attacker lies and aims at legs or feet; blunt_precise: a blunt blow at a small part; short_weapon: short weapon or bare hands. A miss falls on the whole limb or the chest.",
		list("major_zone", "face_zone", "perception", "grab_state", "target_prone", "target_open", "low_aim", "weapon_skill", "stab", "pick", "cut", "blunt_precise", "short_weapon", "aimed", "swift"),
	),
	ROGUE_FORMULA_STRIKE_DAMAGE = list(
		"max(round(force * if(strength_factor > 1, 1 + (strength_factor - 1) * edge, strength_factor) * if(damage_factor > 1, 1 + (damage_factor - 1) * edge, damage_factor) * stance_factor * if(prone, 0.5, 1) * chipped), 1)",
		"Damage of one blow before armor (Azure Peak get_complex_damage). force is the weapon's force or bare-handed damage, strength_factor the strength_factor formula (1 for bare hands), damage_factor the intent's, stance_factor the alt intent's; prone: the attacker lies; edge: share of the strength and intent bonuses a worn blade keeps (1 for a sharp or blunt weapon); chipped: factor of a badly chipped blade (Azure Peak sharpness tiers).",
		list("force", "strength_factor", "damage_factor", "stance_factor", "prone", "edge", "chipped"),
	),
))
