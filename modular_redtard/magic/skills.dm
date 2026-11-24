/// Vibelin's sub-skills of Arcyne Magic (datums/attributes/attributes/skills/magic.dm): one skill per form of the spellbook. A
/// spell trains the skill of its form (associated_skill: Smoke Burst trains Pyromancy), and that skill lowers its price and
/// charge (spell.dm). Untrained, a sub-skill stands a step under the Arcyne skill (the default of a Vibelin sub-skill), so a
/// trained arcanist is never a beginner in a form; a share of what a sub-skill learns goes to Arcyne Magic as well
/// (shared_xp_percent, attributes/experience.dm), and Arcyne Magic is what grows the mana pool (mana.dm). Category,
/// difficulty and Intelligence as the governing characteristic come from Arcyne Magic (rockhill/ported/skills.dm).
/// The step and the share are magic_subskill_* of magic.txt, set in New(): the attributes are made while GLOB initializes,
/// which rogue_value() allows.

/datum/attribute/skill/magic/arcane
	/// A sub-skill of Arcyne Magic: the prefix of its numbers in magic.txt (<prefix>_default, <prefix>_shared). Arcyne
	/// Magic itself has none.
	var/subskill_value_prefix

/datum/attribute/skill/magic/arcane/New()
	. = ..()
	if(!subskill_value_prefix)
		return
	default_attributes = list(
		/datum/attribute/skill/magic/arcane = -rogue_value("[subskill_value_prefix]_default"),
		)
	shared_xp_percent = rogue_value("[subskill_value_prefix]_shared")

/datum/attribute/skill/magic/arcane/fire
	name = ROGUE_FORM_FIRE
	desc = "Represents your character's ability to perform Fire Magic. The higher your skill the more powerful your Fire Magic will be. This is a sub-skill of Arcyne Magic."
	subskill_value_prefix = "magic_subskill"

/datum/attribute/skill/magic/arcane/water
	name = ROGUE_FORM_WATER
	desc = "Represents your character's ability to perform Water Magic. The higher your skill the more powerful your Water Magic will be. This is a sub-skill of Arcyne Magic."
	subskill_value_prefix = "magic_subskill"

/datum/attribute/skill/magic/arcane/ice
	name = ROGUE_FORM_ICE
	desc = "Represents your character's ability to perform Ice Magic. The higher your skill the more powerful your Ice Magic will be. This is a sub-skill of Arcyne Magic."
	subskill_value_prefix = "magic_subskill"

/datum/attribute/skill/magic/arcane/earth
	name = ROGUE_FORM_EARTH
	desc = "Represents your character's ability to perform Earth Magic. The higher your skill the more powerful your Earth Magic will be. This is a sub-skill of Arcyne Magic."
	subskill_value_prefix = "magic_subskill"

/datum/attribute/skill/magic/arcane/air
	name = ROGUE_FORM_AIR
	desc = "Represents your character's ability to perform Air Magic. The higher your skill the more powerful your Air Magic will be. This is a sub-skill of Arcyne Magic."
	subskill_value_prefix = "magic_subskill"

/datum/attribute/skill/magic/arcane/lightning
	name = ROGUE_FORM_LIGHTNING
	desc = "Represents your character's ability to perform Lightning Magic. The higher your skill the more powerful your Lightning Magic will be. This is a sub-skill of Arcyne Magic."
	subskill_value_prefix = "magic_subskill"

/datum/attribute/skill/magic/arcane/life
	name = ROGUE_FORM_LIFE
	desc = "Represents your character's ability to perform Life Magic. The higher your skill the more powerful your Life Magic will be. This is a sub-skill of Arcyne Magic."
	subskill_value_prefix = "magic_subskill"

/// Vibelin defines arcane/death twice: first as the Necromancy sub-skill, then again as Dark Magic, and the second wins. This
/// is that second one, as Vibelin's game has it: the skill of the Necromancy form, further under Arcyne untrained and
/// sharing less of what it learns.
/datum/attribute/skill/magic/arcane/death
	name = "Dark Magic"
	desc = "Represents your character's ability to perform Dark Magic. The corrupted essence of another form of magic, Dark Magic takes things to the extreme. This is a sub-skill of Arcyne Magic."
	subskill_value_prefix = "magic_subskill_dark"

/// The skill a form's spells train in Vibelin (the associated_skill its spells set), by the spellbook's form. The basket of
/// block M2 takes associated_skill from the source spell; this is what the unit test holds a spell's skill against.
/proc/rogue_form_skill(form)
	var/static/list/skills
	if(!skills)
		skills = list(
			ROGUE_FORM_ARCANE = /datum/attribute/skill/magic/arcane,
			ROGUE_FORM_FIRE = /datum/attribute/skill/magic/arcane/fire,
			ROGUE_FORM_WATER = /datum/attribute/skill/magic/arcane/water,
			ROGUE_FORM_ICE = /datum/attribute/skill/magic/arcane/ice,
			ROGUE_FORM_EARTH = /datum/attribute/skill/magic/arcane/earth,
			ROGUE_FORM_AIR = /datum/attribute/skill/magic/arcane/air,
			ROGUE_FORM_LIGHTNING = /datum/attribute/skill/magic/arcane/lightning,
			ROGUE_FORM_LIFE = /datum/attribute/skill/magic/arcane/life,
			ROGUE_FORM_DEATH = /datum/attribute/skill/magic/arcane/death,
			ROGUE_FORM_BLOOD = /datum/attribute/skill/magic/blood,
		)
	return skills[form]

/// Vibelin GET_MOB_SKILL_VALUE_OLD(): a skill in ranks with the fraction kept (Arcyne 35 is 3.5 ranks), as Vibelin's mana
/// pool and spell prices read it; untrained is no rank.
/mob/living/proc/rogue_magic_rank(skill_type)
	return max(ROGUE_NULLTOZERO(rogue_skill(skill_type)), 0) / ROGUE_SKILL_PER_RANK
