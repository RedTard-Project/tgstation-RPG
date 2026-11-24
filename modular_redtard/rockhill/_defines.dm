#define DEPARTMENT_ROCKHILL_NOBLES "Nobles"
#define DEPARTMENT_BITFLAG_ROCKHILL_NOBLES (1<<10)
#define DEPARTMENT_ROCKHILL_COURTIERS "Courtiers"
#define DEPARTMENT_BITFLAG_ROCKHILL_COURTIERS (1<<11)
#define DEPARTMENT_ROCKHILL_GARRISON "Garrison"
#define DEPARTMENT_BITFLAG_ROCKHILL_GARRISON (1<<12)
#define DEPARTMENT_ROCKHILL_CHURCH "Churchmen"
#define DEPARTMENT_BITFLAG_ROCKHILL_CHURCH (1<<13)
#define DEPARTMENT_ROCKHILL_INQUISITION "Inquisition"
#define DEPARTMENT_BITFLAG_ROCKHILL_INQUISITION (1<<14)
#define DEPARTMENT_ROCKHILL_YEOMEN "Yeomen"
#define DEPARTMENT_BITFLAG_ROCKHILL_YEOMEN (1<<15)
#define DEPARTMENT_ROCKHILL_PEASANTS "Peasants"
#define DEPARTMENT_BITFLAG_ROCKHILL_PEASANTS (1<<16)
#define DEPARTMENT_ROCKHILL_YOUNGFOLK "Youngfolk"
#define DEPARTMENT_BITFLAG_ROCKHILL_YOUNGFOLK (1<<17)
#define DEPARTMENT_ROCKHILL_WANDERERS "Wanderers"
#define DEPARTMENT_BITFLAG_ROCKHILL_WANDERERS (1<<18)

#define ROCKHILL_JOB_FLAGS (JOB_CREW_MANIFEST|JOB_CREW_MEMBER|JOB_NEW_PLAYER_JOINABLE|JOB_REOPEN_ON_ROUNDSTART_LOSS|JOB_ASSIGN_QUIRKS)

#define TRAIT_BASHDOORS "bashdoors"

#define ROCKHILL_SUNLIGHT_RANGE rogue_value("rockhill_sunlight_range")
#define ROCKHILL_SUNLIGHT_POWER rogue_value("rockhill_sunlight_power")

#define ROCKHILL_GATE_WIDTH 3

#define COOLDOWN_ROCKHILL_TRAVEL "rockhill_travel"
#define ROCKHILL_PEEK_TIME rogue_value("rockhill_peek_time")
#define ROCKHILL_OAR /obj/item/rogueweapon/mace/oar
#define ROCKHILL_TRAP_DAMAGE rogue_value("rockhill_trap_damage")
#define ROCKHILL_TRAP_WALL_RANGE rogue_value("rockhill_trap_wall_range")
#define ROCKHILL_HATCH_CYCLE rogue_value("rockhill_hatch_cycle")
#define ROCKHILL_DAY_RATE CONFIG_GET(number/rockhill_day_rate)
#define ROCKHILL_DAY_START CONFIG_GET(number/rockhill_day_start)
#define ROCKHILL_DAY_TRANSITION (1 HOURS / ROCKHILL_DAY_RATE)
#define ROCKHILL_DAWN "dawn"
#define ROCKHILL_DAY "day"
#define ROCKHILL_DUSK "dusk"
#define ROCKHILL_NIGHT "night"
#define ROCKHILL_CLOCK "clock"
#define ROCKHILL_SOUND_MUSIC "music"
#define ROCKHILL_SOUND_LOOP "loop"
#define ROCKHILL_CALENDAR_EPOCH_YEAR CONFIG_GET(number/rockhill_calendar_epoch_year)
#define ROCKHILL_CALENDAR_YEARS_PER_CYCLE CONFIG_GET(number/rockhill_calendar_years_per_cycle)
#define ROCKHILL_CALENDAR_MONTHS 12
#define ROCKHILL_CALENDAR_DAYS_IN_MONTH CONFIG_GET(number/rockhill_calendar_days_in_month)
#define ROCKHILL_CALENDAR_DAYS_IN_WEEK 7
#define ROCKHILL_CALENDAR_DAYS_IN_YEAR (ROCKHILL_CALENDAR_MONTHS * ROCKHILL_CALENDAR_DAYS_IN_MONTH)
#define ROCKHILL_CALENDAR_WEEKS_IN_YEAR (ROCKHILL_CALENDAR_DAYS_IN_YEAR / ROCKHILL_CALENDAR_DAYS_IN_WEEK)
#define ROCKHILL_CALENDAR_SYSTEM "azurian"
#define ROCKHILL_CALENDAR_DEFAULT_COLOR "#7c5b10"
#define ROCKHILL_CALENDAR_EVENTS_FILE "modular_redtard/rockhill/strings/calendar_events.json"
#define ROCKHILL_TIME_TIPS_FILE "modular_redtard/rockhill/strings/timechangetips.txt"
#define ROCKHILL_DUNGEON_TRAVEL_TIME rogue_value("rockhill_dungeon_travel_time")
#define ROCKHILL_DUNGEON_MARKERS_PER_FIRE rogue_value("rockhill_dungeon_markers_per_fire")
#define ROCKHILL_DUNGEON_ENTRY_SPACING rogue_value("rockhill_dungeon_entry_spacing")
#define ROCKHILL_DUNGEON_ENTRY_CHANCE rogue_value("rockhill_dungeon_entry_chance")
#define ROCKHILL_DUNGEON_REQUIRED_ENTRIES rogue_value("rockhill_dungeon_required_entries")
#define ROCKHILL_SECRET_DOOR_RANGE 1
#define ROCKHILL_SECRET_DOOR_SLIDE (1 SECONDS)
#define ROCKHILL_SECRET_DOOR_SHIFT -22
#define ROCKHILL_SECRET_DOOR_OPEN_ALPHA 50
#define ROCKHILL_WATER_COLOR "#6a9295"
#define ROCKHILL_ACID_COLOR "#5eff00"
#define ROCKHILL_WATERFALL_MIST_ALPHA 175
#define COMSIG_GLOB_ROCKHILL_TIME_OF_DAY "!rockhill_time_of_day"

#define COMSIG_KB_LIVING_ROGUE_LOOK_LOCK_DOWN "keybinding_living_rogue_look_lock_down"
#define ROCKHILL_WEATHER_MIN_STRENGTH rogue_value("rockhill_weather_min_strength")
#define ROCKHILL_WEATHER_MAX_DELAY rogue_value("rockhill_weather_max_delay")
#define ROCKHILL_LIGHTNING_RANGE rogue_value("rockhill_lightning_range")
#define ROCKHILL_LIGHTNING_MIN_DELAY rogue_value("rockhill_lightning_min_delay")
#define ROCKHILL_LIGHTNING_MAX_DELAY rogue_value("rockhill_lightning_max_delay")
#define ROCKHILL_RIPPLE_RANGE 6
#define ROCKHILL_RIPPLE_MIN_DELAY (2 SECONDS)
#define ROCKHILL_RIPPLE_MAX_DELAY (6 SECONDS)
#define ROCKHILL_RIPPLE_SEVERITY_STEP 40
#define ROCKHILL_RIPPLE_MAX 3
#define ROCKHILL_OVERLAY_LIGHT_PLATE "Overlight plate"
#define ZTRAIT_ROCKHILL_WEATHER "Rockhill Weather"
#define ROCKHILL_KNEESTINGER_DAMAGE rogue_value("rockhill_kneestinger_damage")
#define ROCKHILL_KNEESTINGER_RESHOCK rogue_value("rockhill_kneestinger_reshock")
#define ROCKHILL_KNEESTINGER_IDLE (0.2 SECONDS)
#define ROCKHILL_KNEESTINGER_STATES 3
#define ROCKHILL_KNEESTINGER_SHIFT_X 4
#define ROCKHILL_KNEESTINGER_SHIFT_Y 5
#define ROCKHILL_KNEESTINGER_THROW rogue_value("rockhill_kneestinger_throw")
#ifndef TRAIT_KNEESTINGER_IMMUNITY
#define TRAIT_KNEESTINGER_IMMUNITY "Blessing of Dendor"
#endif
#define ROCKHILL_ADVCLASS_UNLIMITED -1
#define ROCKHILL_ADVCLASS_CHOICE_TIME rogue_value("rockhill_advclass_choice_time")
#define ROCKHILL_ADVCLASS_TRAIT "rockhill_class_select"
#define ROCKHILL_FIRE_SPENT_MIN rogue_value("rockhill_fire_spent_min")
#define ROCKHILL_FIRE_SPENT_MAX rogue_value("rockhill_fire_spent_max")
#define ROCKHILL_FIRE_FULL_MARGIN rogue_value("rockhill_fire_full_margin")
#define ROCKHILL_FIRE_CROSS_STACKS rogue_value("rockhill_fire_cross_stacks")
#define ROCKHILL_FIRE_TOPPLE_PER_STRENGTH rogue_value("rockhill_fire_topple_per_strength")
#define ROCKHILL_FIRE_RAISE_TIME rogue_value("rockhill_fire_raise_time")
#define ROCKHILL_FIRE_LIGHT_SOUND 'modular_redtard/rockhill/sound/items/firelight.ogg'
#define ROCKHILL_FIRE_SNUFF_SOUND 'modular_redtard/rockhill/sound/items/firesnuff.ogg'
#define ROCKHILL_FIRE_KICK_SOUND 'modular_redtard/rockhill/sound/combat/hits/blunt/woodblunt (1).ogg'
#define ROCKHILL_TORCH_TAKE_SOUND 'modular_redtard/rockhill/sound/foley/torchfixturetake.ogg'
#define ROCKHILL_TORCH_PUT_SOUND 'modular_redtard/rockhill/sound/foley/torchfixtureput.ogg'
#define ROCKHILL_FLARE_IGNITED 1
#define ROCKHILL_VEIN_SALT "salt"
#define ROCKHILL_VEIN_IRON "iron"
#define ROCKHILL_VEIN_COPPER "copper"
#define ROCKHILL_VEIN_TIN "tin"
#define ROCKHILL_VEIN_COAL "coal"
#define ROCKHILL_VEIN_GOLD "gold"
#define ROCKHILL_VEIN_SILVER "silver"
#define ROCKHILL_VEIN_CINNABAR "cinnabar"
#define ROCKHILL_VEIN_GEM "gem"
#define ROCKHILL_VEIN_MOTE "elementalmote"
#define ROCKHILL_ROCK_INTEGRITY rogue_value("rockhill_rock_integrity")
#define ROCKHILL_MINE_SWING_TIME CLICK_CD_MELEE
#define ROCKHILL_MINE_STAMINA rogue_value("rockhill_mine_stamina")
#define ROCKHILL_MINE_XP_PER_INT rogue_value("rockhill_mine_xp_per_int")
#define ROCKHILL_MINE_EXTRA_STONE_CHANCE rogue_value("rockhill_mine_extra_stone_chance")
#define ROCKHILL_MINE_ORE_CHANCE rogue_value("rockhill_mine_ore_chance")
#define ROCKHILL_MINE_EXTRA_ROCK_CHANCE rogue_value("rockhill_mine_extra_rock_chance")
#define ROCKHILL_MINE_LUCK_MULTIPLIER rogue_value("rockhill_mine_luck_multiplier")
#define ROCKHILL_MINED_FLOOR /turf/open/floor/rogue/naturalstone
#define ROCKHILL_MINE_SOUNDS list('modular_redtard/rockhill/sound/combat/hits/pick/genpick (1).ogg', 'modular_redtard/rockhill/sound/combat/hits/pick/genpick (2).ogg')
#define ROCKHILL_BOULDER_CLIMB_TIME rogue_value("rockhill_boulder_climb_time")
#define ROCKHILL_WINDOW_KNIFE_DAMAGE rogue_value("rockhill_window_knife_damage")
#define ROCKHILL_WINDOW_CRASH_RANGE rogue_value("rockhill_window_crash_range")
#define ROCKHILL_WINDOW_PICK_GOOD_SOUND pick('modular_redtard/rockhill/sound/doors/pickgood1.ogg', 'modular_redtard/rockhill/sound/doors/pickgood2.ogg')
#define ROCKHILL_WINDOW_PICK_BAD_SOUND 'modular_redtard/rockhill/sound/doors/pickbad.ogg'
#define ROCKHILL_TRAP_MIN_CRAFTING rogue_value("rockhill_trap_min_crafting")
#define ROCKHILL_TRAP_DISARMED_ALPHA 255
#define ROCKHILL_TRAP_FADE (1 SECONDS)
#define ROCKHILL_MANTRAP_BADLUCK rogue_value("rockhill_mantrap_badluck")
#define ROCKHILL_MANTRAP_HIDDEN_ALPHA 90
#define ROCKHILL_MANTRAP_HIDDEN_PER_CRAFTING rogue_value("rockhill_mantrap_hidden_per_crafting")
#define ROCKHILL_MANTRAP_TOOL_DAMAGE rogue_value("rockhill_mantrap_tool_damage")
#define ROCKHILL_RAIN_WASH_CHANCE rogue_value("rockhill_rain_wash_chance")
#define ROCKHILL_LIGHTNING_BADLUCK rogue_value("rockhill_lightning_badluck")
#define ROCKHILL_LIGHTNING_DAMAGE rogue_value("rockhill_lightning_damage")
#define ROCKHILL_LIGHTNING_IMMOBILIZE rogue_value("rockhill_lightning_immobilize")
#define ROCKHILL_LIGHTNING_CLICK_DELAY rogue_value("rockhill_lightning_click_delay")
#define ROCKHILL_FIREFLIES_MOOD rogue_value("rockhill_fireflies_mood")
#define ROCKHILL_FIREFLIES_MOOD_TIME rogue_value("rockhill_fireflies_mood_time")

// Ratwood's trait of the Abyssor faithful and the sea peoples: cold water does not chill them (rockhill/swimming.dm); the
// origins of homelands/ give it too. The ported traits (rockhill/ported/_traits.dm) lack it.
#ifndef TRAIT_WATERLOVING
#define TRAIT_WATERLOVING "Water loving"
#endif
