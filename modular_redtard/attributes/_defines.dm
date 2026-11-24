#define ROGUE_STAT /datum/attribute/stat
#define ROGUE_SKILL /datum/attribute/skill

#define ROGUE_STAT_STRENGTH /datum/attribute/stat/strength
#define ROGUE_STAT_PERCEPTION /datum/attribute/stat/perception
#define ROGUE_STAT_INTELLIGENCE /datum/attribute/stat/intelligence
#define ROGUE_STAT_CONSTITUTION /datum/attribute/stat/constitution
#define ROGUE_STAT_WILLPOWER /datum/attribute/stat/willpower
#define ROGUE_STAT_SPEED /datum/attribute/stat/speed
#define ROGUE_STAT_FORTUNE /datum/attribute/stat/fortune

#define ROGUE_ATTRIBUTE_MIN rogue_value("attribute_min")
#define ROGUE_ATTRIBUTE_MAX rogue_value("attribute_max")
#define ROGUE_ATTRIBUTE_MIDDLING rogue_value("attribute_middling")
#define ROGUE_ATTRIBUTE_DEFAULT ROGUE_ATTRIBUTE_MIDDLING

#define ROGUE_SKILL_MIN 0
#define ROGUE_SKILL_MAX rogue_value("skill_max")
#define ROGUE_SKILL_PER_RANK rogue_value("skill_per_rank")
#define ROGUE_SKILL_DEFAULT_CAP rogue_value("skill_default_cap")
#define ROGUE_SKILL_RANK_MAX 6

#define ROGUE_SKILL_LEVEL_NONE 0
#define ROGUE_SKILL_LEVEL_NOVICE 10
#define ROGUE_SKILL_LEVEL_APPRENTICE 20
#define ROGUE_SKILL_LEVEL_JOURNEYMAN 30
#define ROGUE_SKILL_LEVEL_EXPERT 40
#define ROGUE_SKILL_LEVEL_MASTER 50
#define ROGUE_SKILL_LEVEL_LEGENDARY 60

#define ROGUE_SKILL_XP_NONE 0
#define ROGUE_SKILL_XP_NOVICE rogue_value("skill_xp_novice")
#define ROGUE_SKILL_XP_APPRENTICE rogue_value("skill_xp_apprentice")
#define ROGUE_SKILL_XP_JOURNEYMAN rogue_value("skill_xp_journeyman")
#define ROGUE_SKILL_XP_EXPERT rogue_value("skill_xp_expert")
#define ROGUE_SKILL_XP_MASTER rogue_value("skill_xp_master")
#define ROGUE_SKILL_XP_LEGENDARY rogue_value("skill_xp_legendary")

#define ROGUE_SKILL_GOVERNING_POSITIVE rogue_value("skill_governing_positive")
#define ROGUE_SKILL_GOVERNING_NEGATIVE rogue_value("skill_governing_negative")
#define ROGUE_SKILL_XP_CATCHUP_MAX rogue_value("skill_xp_catchup_max")
#define ROGUE_SKILL_XP_CATCHUP_RANGE rogue_value("skill_xp_catchup_range")

#define ROGUE_DICE_CRIT_SUCCESS 2
#define ROGUE_DICE_SUCCESS 1
#define ROGUE_DICE_FAILURE 0
#define ROGUE_DICE_CRIT_FAILURE -1

#define ROGUE_DICE_RETURN_SUCCESS (1<<0)
#define ROGUE_DICE_RETURN_DIFFERENCE (1<<1)
#define ROGUE_DICE_RETURN_BOTH (ROGUE_DICE_RETURN_SUCCESS|ROGUE_DICE_RETURN_DIFFERENCE)
#define ROGUE_DICE_INDEX_SUCCESS 1
#define ROGUE_DICE_INDEX_DIFFERENCE 2

#define ROGUE_DICE_PHYSICAL "physical"
#define ROGUE_DICE_MENTAL "mental"

#define ROGUE_SKILL_CATEGORY_GENERAL "General Skills"
#define ROGUE_SKILL_CATEGORY_MELEE "Melee Skills"
#define ROGUE_SKILL_CATEGORY_RANGED "Ranged Skills"
#define ROGUE_SKILL_CATEGORY_BLOCKING "Blocking Skills"
#define ROGUE_SKILL_CATEGORY_SKULDUGGERY "Skulduggery Skills"
#define ROGUE_SKILL_CATEGORY_MEDICAL "Medical Skills"
#define ROGUE_SKILL_CATEGORY_RESEARCH "Research Skills"
#define ROGUE_SKILL_CATEGORY_TRADE "Trade Skills"
#define ROGUE_SKILL_CATEGORY_DOMESTIC "Domestic Skills"
#define ROGUE_SKILL_CATEGORY_MAGIC "Magic Skills"

#define ROGUE_SKILL_DIFFICULTY_VERY_EASY "Very Easy"
#define ROGUE_SKILL_DIFFICULTY_EASY "Easy"
#define ROGUE_SKILL_DIFFICULTY_AVERAGE "Medium"
#define ROGUE_SKILL_DIFFICULTY_HARD "Hard"
#define ROGUE_SKILL_DIFFICULTY_VERY_HARD "Very Hard"

#define ROGUE_AGE_MIDDLE rogue_value("age_middle")
#define ROGUE_AGE_OLD rogue_value("age_old")

#define ROGUE_SPEED_STEP rogue_value("speed_step")
#define ROGUE_SPEED_FASTEST rogue_value("speed_fastest")
#define ROGUE_SPEED_FASTEST_UNCAPPED rogue_value("speed_fastest_uncapped")
#define ROGUE_SPEED_SLOWEST rogue_value("speed_slowest")

#define TRAIT_ROGUE_NO_SKILLS "rogue_no_skills"
#define TRAIT_ROGUE_NO_EXPERIENCE "rogue_no_experience"
#define TRAIT_ROGUE_UNCAPPED_SPEED "rogue_uncapped_speed"
#define ROGUE_ATTRIBUTE_TRAIT "rogue_attributes"

#define COMSIG_ROGUE_SKILL_CHANGED "rogue_skill_changed"
#define COMSIG_ROGUE_ATTRIBUTES_UPDATED "rogue_attributes_updated"

#define ROGUE_NULLTOZERO(value) ((value) || 0)
#define GET_ROGUE_ATTRIBUTE(path) GLOB.rogue_attributes[path]
#define ROGUE_STAT_VALUE(mob, path) (LAZYACCESS(mob.attributes?.attribute_list, path) || ROGUE_ATTRIBUTE_DEFAULT)
#define ROGUE_STAT_VALUE_RAW(mob, path) (LAZYACCESS(mob.attributes?.raw_attribute_list, path) || ROGUE_ATTRIBUTE_DEFAULT)
#define ROGUE_SKILL_VALUE(mob, path) (mob.attributes?.return_effective_skill(path))
#define ROGUE_SKILL_RANK(mob, path) (clamp(floor(ROGUE_NULLTOZERO(ROGUE_SKILL_VALUE(mob, path)) / ROGUE_SKILL_PER_RANK), 0, ROGUE_SKILL_RANK_MAX))
