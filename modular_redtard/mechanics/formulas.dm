/// Formulas: id = list(default expression, description, inputs). The open repository holds no balance: every default is 10,
/// the real expressions live in config/redtard_private/mechanics/formulas.txt (read over this at load), and the open
/// config/redtard/mechanics/formulas.txt is 10 too. Names, descriptions and inputs stay here.
/// A proc and not a GLOB list: the registry may be built while GLOB is still initializing (mechanics/formula.dm).
/proc/rogue_formula_definitions()
	return list(
		ROGUE_FORMULA_STRENGTH_FACTOR = list(
			"10",
			"Damage multiplier from the attacker's strength (Ratwood STRENGTH_MULT up to STRENGTH_SOFTCAP, STRENGTH_CAPPEDMULT past it). min_strength is the weapon's need, reduced when wielded, 0 if none.",
			list("strength", "min_strength"),
		),
		ROGUE_FORMULA_WEAPON_DEFENSE = list(
			"10",
			"Parry value of one weapon or of bare hands (Azure Peak): weapon skill rank and weapon defense.",
			list("skill", "defense"),
		),
		ROGUE_FORMULA_SPEED_PRESSURE = list(
			"10",
			"Parry penalty when a faster attacker uses a swift weapon or bare hands (Azure Peak); perception and intelligence offset it.",
			list("swift_attack", "attacker_armed", "attacker_speed", "defender_speed", "attacker_perception", "defender_perception", "attacker_intelligence", "defender_intelligence", "cap"),
		),
		ROGUE_FORMULA_PARRY_CHANCE = list(
			"10",
			"Parry chance in percent (Azure Peak). defense is the best weapon_defense; swift_guard is a lone swift weapon in light armor.",
			list("defense", "attacker_skill", "running", "swift_guard", "speed_pressure", "prone", "dual_wield", "untrained_armor", "bound"),
		),
		ROGUE_FORMULA_DODGE_CHANCE = list(
			"10",
			"Dodge chance in percent (Azure Peak). base is the attacker's defprob (dodge_base for a person); defender_skill is the defender's rank in the attacker's skill; improvised is a weapon without a skill.",
			list("defender_speed", "attacker_speed", "swift_attack", "heavy_attack", "improvised", "defender_skill", "attacker_skill", "prone", "dodge_expert", "dual_wield", "fatigue", "base"),
		),
		ROGUE_FORMULA_WOUND_CONSTITUTION = list(
			"10",
			"Wound chance multiplier from constitution.",
			list("constitution"),
		),
		ROGUE_FORMULA_FEINT_CHANCE = list(
			"10",
			"Feint success chance in percent (Azure Peak): weapon skill ranks and intelligence of both sides. A target that is already open cannot be feinted again.",
			list("skill", "target_skill", "intelligence", "target_intelligence", "target_vulnerable"),
		),
		ROGUE_FORMULA_LOOK_AROUND_TIME = list(
			"10",
			"How long looking around takes, in deciseconds (Azure Peak).",
			list("perception", "tracking"),
		),
		ROGUE_FORMULA_LOOK_AROUND_CHANCE = list(
			"10",
			"Chance in percent that looking around finds a hidden creature (Azure Peak). target_stealth is the best of its sneaking, holy and arcane ranks, 0 without a mind.",
			list("perception", "tracking", "target_stealth", "target_perception"),
		),
		ROGUE_FORMULA_ENERGY_MAX = list(
			"10",
			"Maximum energy (blue stamina) from willpower and the athletics rank (Azure Peak).",
			list("willpower", "athletics"),
		),
		ROGUE_FORMULA_MINING_SWINGS = list(
			"10",
			"Pick swings needed to break a rock wall (Ratwood): wall integrity, the pick's force and the mining rank. One swing takes a melee click delay.",
			list("integrity", "force", "mining"),
		),
		ROGUE_FORMULA_WINDOW_PRY_TIME = list(
			"10",
			"Time of one attempt to pry a window with a knife, in deciseconds (Ratwood).",
			list("lockpicking", "perception", "speed", "picklvl", "open"),
		),
		ROGUE_FORMULA_WINDOW_PRY_PROGRESS = list(
			"10",
			"Progress of one successful attempt; the window gives when the progress reaches its limit, a higher one when reinforced (Ratwood).",
			list("lockpicking", "perception", "speed", "picklvl", "open"),
		),
		ROGUE_FORMULA_WINDOW_PRY_CHANCE = list(
			"10",
			"Chance in percent that one attempt succeeds; a failure breaks the window (Ratwood). picklvl is the knife's lockpicking level.",
			list("lockpicking", "perception", "speed", "picklvl", "open"),
		),
		ROGUE_FORMULA_TRAP_SET_TIME = list(
			"10",
			"Time to arm a floor trap by hand, in deciseconds (Ratwood). Needs some crafting skill.",
			list("crafting"),
		),
		ROGUE_FORMULA_TRAP_DISARM_TIME = list(
			"10",
			"Time to disarm a floor trap by hand, in deciseconds (Ratwood). Needs some crafting skill.",
			list("crafting"),
		),
		ROGUE_FORMULA_MANTRAP_SET_TIME = list(
			"10",
			"Time to spring open or shut a mantrap held in hand, in deciseconds (Ratwood).",
			list("strength", "crafting"),
		),
		ROGUE_FORMULA_MANTRAP_SET_CHANCE = list(
			"10",
			"Chance in percent to arm or shut a mantrap held in hand (Ratwood).",
			list("strength", "crafting"),
		),
		ROGUE_FORMULA_MANTRAP_DISARM_TIME = list(
			"10",
			"Time to disarm an armed mantrap on the ground, in deciseconds (Ratwood); an interruption springs it on the hand.",
			list("crafting"),
		),
		ROGUE_FORMULA_LOOK_AROUND_SPOT = list(
			"10",
			"Whether looking around marks a hiding place with someone tucked inside (Azure Peak): non-zero means found.",
			list("perception", "target_sneaking"),
		),
		ROGUE_FORMULA_UNARMED_DAMAGE = list(
			"10",
			"Bare-handed damage before the strike formula: a punch, twisting, chewing, headbutting (Ratwood get_punch_dmg after the Azure Peak unarmed rework). civilized is the Expert Pugilist trait, gloves the flat unarmed bonus of the worn gloves or knuckles, added after strength.",
			list("strength", "civilized", "gloves"),
		),
		ROGUE_FORMULA_GRAB_CHANCE = list(
			"10",
			"Chance in percent to tighten a grab, or to shove a grabbed foe down (Ratwood). Strength and wrestling are grabber minus target; noise is a small random spread; modifier is a factor built from the target's state: compliant, restrained, lying, combat readiness, chokehold.",
			list("strength_diff", "skill_diff", "noise", "modifier"),
		),
		ROGUE_FORMULA_GRAB_DISARM_CHANCE = list(
			"10",
			"Chance in percent to take the item from a grabbed hand (Ratwood); more to knock it to the floor instead. weapon_skill is the holder's rank in the item's skill.",
			list("strength_diff", "skill_diff", "modifier", "weapon_skill", "wielded"),
		),
		ROGUE_FORMULA_GRAB_PIN_TIME = list(
			"10",
			"How long one pin holds a grabbed foe on the ground, in deciseconds (Ratwood).",
			list("strength_diff", "skill_diff", "modifier"),
		),
		ROGUE_FORMULA_GRAB_SMASH_DAMAGE = list(
			"10",
			"Damage of smashing a grabbed limb into a wall, floor or table (Ratwood). punch is unarmed_damage, unarmed the unarmed skill rank.",
			list("punch", "unarmed"),
		),
		ROGUE_FORMULA_CHOKE_DAMAGE = list(
			"10",
			"Suffocation per choke of a neck grab (Ratwood). chokehold: grabbed from behind; held_back: the victim holds the choker aggressively.",
			list("strength", "chokehold", "held_back"),
		),
		ROGUE_FORMULA_BITE_DAMAGE = list(
			"10",
			"Damage of the first bite (Ratwood); it only hurts a limb that is already wounded unless the biter has a strong bite.",
			list("strength", "strong_bite"),
		),
		ROGUE_FORMULA_STRIKE_ACCURACY = list(
			"10",
			"Chance in percent that a blow lands on the aimed body part (Azure Peak resolve_aimed_zone). major_zone: a whole limb, head or chest; face_zone: head or face against someone with a mind; grab_state: 1 held, 2 held aggressively; target_open: the target is exposed or vulnerable; low_aim: the attacker lies and aims at legs or feet (Azure Peak ACC_PRONE_ATTACKER_LEG_BONUS); blunt_precise: a blunt blow at a small part; short_weapon: short weapon or bare hands. A miss falls on the whole limb or the chest.",
			list("major_zone", "face_zone", "perception", "grab_state", "target_prone", "target_open", "low_aim", "weapon_skill", "stab", "pick", "cut", "blunt_precise", "short_weapon", "aimed", "swift"),
		),
		ROGUE_FORMULA_STRIKE_DAMAGE = list(
			"10",
			"Damage of one blow before armor (Azure Peak get_complex_damage). force is the weapon's force or bare-handed damage, strength_factor the strength_factor formula (1 for bare hands), damage_factor the intent's, stance_factor the alt intent's; prone: the attacker lies; edge: share of the strength and intent bonuses a worn blade keeps (1 for a sharp or blunt weapon); chipped: factor of a badly chipped blade (Azure Peak sharpness tiers).",
			list("force", "strength_factor", "damage_factor", "stance_factor", "prone", "edge", "chipped", "uncharged"),
		),
		ROGUE_FORMULA_CRIT_CHANCE = list(
			"10",
			"Chance in percent of one critical wound (Azure Peak try_crit). limb_damage: share of the limb's damage; divisor: crit_damage_divisor or crit_chest_divisor; bonus: 1 for a matching alt intent (strong for fractures and chops, aimed for cuts and stabs).",
			list("limb_damage", "damage", "divisor", "bonus"),
		),
		ROGUE_FORMULA_BEAST_DODGE_CHANCE = list(
			"10",
			"Dodge chance in percent of a creature (Azure Peak SIMPLEMOB_DODGE_*). weapon_skill is the attacker's rank with the weapon, fatigue the creature's dodge fatigue.",
			list("defender_speed", "attacker_speed", "weapon_skill", "fatigue"),
		),
	)
