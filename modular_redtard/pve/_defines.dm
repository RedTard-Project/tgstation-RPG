// Stage 6, PvE depth (pve/): shooting creatures, the special abilities of Ratwood's monsters, the minotaur's rage, spider webs,
// nests and cocoons. Shared by pve/ and the minds of ai/.

/// How a creature that shoots fights: it keeps its distance and shoots (Ratwood skeleton archer, deep one spitter, imp), or
/// closes in to strike and shoots only from afar (Ratwood colossus).
#define ROGUE_PVE_SHOOTER "shooter"
#define ROGUE_PVE_SKIRMISHER "skirmisher"

/// Tiles a creature sees a foe at to shoot it or to throw at it (TG basic_ranged_attack max_range).
#define ROGUE_PVE_SIGHT 9

/// Source of the traits this stage gives.
#define ROGUE_PVE_TRAIT "rogue_pve"

/// The spider nest a spider lives in.
#define BB_ROGUE_PVE_HOME "rogue_pve_home"
/// The fallen one a spider wraps into a cocoon.
#define BB_ROGUE_PVE_COCOON "rogue_pve_cocoon"
/// When a spider next looks for someone fallen to wrap.
#define BB_ROGUE_PVE_NEXT_COCOON "rogue_pve_next_cocoon"
/// The tile a spider spins its next web on.
#define BB_ROGUE_PVE_WEB_SPOT "rogue_pve_web_spot"
/// When a spider may spin its next web.
#define BB_ROGUE_PVE_NEXT_WEB "rogue_pve_next_web"

/// Ratwood's sounds of this stage.
#define ROGUE_PVE_SOUND_BOW 'modular_redtard/pve/sound/flatbow_shot.ogg'
#define ROGUE_PVE_SOUND_ARROW_HIT 'modular_redtard/pve/sound/arrow_hit.ogg'
#define ROGUE_PVE_SOUND_STONE_HIT 'modular_redtard/pve/sound/stone_hit.ogg'
#define ROGUE_PVE_SOUND_SPIT 'modular_redtard/rockhill/sound/combat/wooshes/punch/punchwoosh (1).ogg'
#define ROGUE_PVE_SOUND_DIG 'modular_redtard/husbandry/sound/dig_shovel.ogg'
#define ROGUE_PVE_SOUND_SMASH_ROCK 'modular_redtard/rockhill/sound/foley/smash_rock.ogg'
#define ROGUE_PVE_SOUND_HEAVE 'modular_redtard/rockhill/sound/combat/shieldraise.ogg'

/// Ratwood's sprites of this stage.
#define ROGUE_PVE_WEB_ICON 'modular_redtard/rockhill/icons/modular/Mapping/icons/webbing.dmi'
#define ROGUE_PVE_NATURAL_ICON 'modular_redtard/rockhill/icons/roguetown/items/natural.dmi'
#define ROGUE_PVE_AMMO_ICON 'modular_redtard/rockhill/icons/roguetown/weapons/ammo.dmi'
#define ROGUE_PVE_NEST_ICON 'modular_redtard/pve/icons/spider_nest.dmi'
#define ROGUE_PVE_MARK_ICON 'modular_redtard/icons/effects/rogue_telegraph.dmi'
#define ROGUE_PVE_STRIKE_ICON 'modular_redtard/icons/effects/rogue_special_fx.dmi'

// Numbers of mechanics/values.dm (section "Stage 6: PvE depth").
#define ROGUE_PVE_ARROW_RECOVER_CHANCE rogue_value("pve_arrow_recover_chance")
#define ROGUE_PVE_WEB_GLOB_HOLD rogue_value("pve_web_glob_hold")
#define ROGUE_PVE_FIREBALL_SPLASH rogue_value("pve_fireball_splash")
#define ROGUE_PVE_STONE_THROW_AIM rogue_value("pve_stone_throw_aim")
#define ROGUE_PVE_STONE_THROW_DIG rogue_value("pve_stone_throw_dig")
#define ROGUE_PVE_STONE_THROW_RANGE rogue_value("pve_stone_throw_range")
#define ROGUE_PVE_STONE_THROW_DAMAGE rogue_value("pve_stone_throw_damage")
#define ROGUE_PVE_TROLL_SLAM_WINDUP rogue_value("pve_troll_slam_windup")
#define ROGUE_PVE_TROLL_SLAM_RANGE rogue_value("pve_troll_slam_range")
#define ROGUE_PVE_TROLL_SLAM_DAMAGE rogue_value("pve_troll_slam_damage")
#define ROGUE_PVE_QUAKE_DELAY rogue_value("pve_quake_delay")
#define ROGUE_PVE_QUAKE_PARALYZE rogue_value("pve_quake_paralyze")
#define ROGUE_PVE_QUAKE_ROCK_TIME rogue_value("pve_quake_rock_time")
#define ROGUE_PVE_FLING_DELAY rogue_value("pve_fling_delay")
#define ROGUE_PVE_FLING_RANGE rogue_value("pve_fling_range")
#define ROGUE_PVE_FLING_DAMAGE rogue_value("pve_fling_damage")
#define ROGUE_PVE_STOMP_RANGE rogue_value("pve_stomp_range")
#define ROGUE_PVE_STOMP_DAMAGE rogue_value("pve_stomp_damage")
#define ROGUE_PVE_METEOR_RADIUS rogue_value("pve_meteor_radius")
#define ROGUE_PVE_METEOR_CHANCE rogue_value("pve_meteor_chance")
#define ROGUE_PVE_METEOR_DAMAGE rogue_value("pve_meteor_damage")
#define ROGUE_PVE_SUMMON_COUNT rogue_value("pve_summon_count")
#define ROGUE_PVE_SUMMON_CAP rogue_value("pve_summon_cap")
#define ROGUE_PVE_IGNITE_COOLDOWN rogue_value("pve_ignite_cooldown")
#define ROGUE_PVE_IGNITE_STACKS rogue_value("pve_ignite_stacks")
#define ROGUE_PVE_DUST_COOLDOWN rogue_value("pve_dust_cooldown")
#define ROGUE_PVE_DUST_TOXIN rogue_value("pve_dust_toxin")
#define ROGUE_PVE_DUST_TIME rogue_value("pve_dust_time")
#define ROGUE_PVE_RAGE_GAIN rogue_value("pve_rage_gain")
#define ROGUE_PVE_RAGE_HURT_FACTOR rogue_value("pve_rage_hurt_factor")
#define ROGUE_PVE_RAGE_DYING_FACTOR rogue_value("pve_rage_dying_factor")
#define ROGUE_PVE_RAGE_DECAY rogue_value("pve_rage_decay")
#define ROGUE_PVE_RAGE_PHASE_TWO rogue_value("pve_rage_phase_two")
#define ROGUE_PVE_RAGE_PHASE_THREE rogue_value("pve_rage_phase_three")
#define ROGUE_PVE_RAGE_BONUS_TWO rogue_value("pve_rage_bonus_two")
#define ROGUE_PVE_RAGE_BONUS_THREE rogue_value("pve_rage_bonus_three")
#define ROGUE_PVE_RAGE_DAMAGE rogue_value("pve_rage_damage")
#define ROGUE_PVE_RAGE_HEAL_CHANCE rogue_value("pve_rage_heal_chance")
#define ROGUE_PVE_RAGE_HEAL rogue_value("pve_rage_heal")
#define ROGUE_PVE_CHARGE_WINDUP rogue_value("pve_charge_windup")
#define ROGUE_PVE_CHARGE_MIN rogue_value("pve_charge_min")
#define ROGUE_PVE_CHARGE_MAX rogue_value("pve_charge_max")
#define ROGUE_PVE_CHARGE_DAMAGE rogue_value("pve_charge_damage")
#define ROGUE_PVE_CHARGE_KNOCKDOWN rogue_value("pve_charge_knockdown")
#define ROGUE_PVE_FURY_WINDUP rogue_value("pve_fury_windup")
#define ROGUE_PVE_FURY_DAMAGE rogue_value("pve_fury_damage")
#define ROGUE_PVE_SLAM_RAGE rogue_value("pve_slam_rage")
#define ROGUE_PVE_SLAM_WINDUP rogue_value("pve_slam_windup")
#define ROGUE_PVE_SLAM_DAMAGE rogue_value("pve_slam_damage")
#define ROGUE_PVE_WEB_STUCK_CHANCE rogue_value("pve_web_stuck_chance")
#define ROGUE_PVE_WEB_PROJECTILE_PASS rogue_value("pve_web_projectile_pass")
#define ROGUE_PVE_WEB_INTERVAL rogue_value("pve_web_interval")
#define ROGUE_PVE_WEB_CAP rogue_value("pve_web_cap")
#define ROGUE_PVE_NEST_RANGE rogue_value("pve_nest_range")
#define ROGUE_PVE_NEST_CAPACITY rogue_value("pve_nest_capacity")
#define ROGUE_PVE_NEST_ENTER_CHANCE rogue_value("pve_nest_enter_chance")
#define ROGUE_PVE_NEST_LEAVE_CHANCE rogue_value("pve_nest_leave_chance")
#define ROGUE_PVE_NEST_DISTURB_RANGE rogue_value("pve_nest_disturb_range")
#define ROGUE_PVE_NEST_DISTURB_COOLDOWN rogue_value("pve_nest_disturb_cooldown")
#define ROGUE_PVE_NEST_HONEY_TIME rogue_value("pve_nest_honey_time")
#define ROGUE_PVE_NEST_HONEY_MAX rogue_value("pve_nest_honey_max")
#define ROGUE_PVE_NEST_HARVEST_TIME rogue_value("pve_nest_harvest_time")
#define ROGUE_PVE_COCOON_TIME rogue_value("pve_cocoon_time")
#define ROGUE_PVE_COCOON_BREAKOUT rogue_value("pve_cocoon_breakout")
#define ROGUE_PVE_COCOON_HEAL rogue_value("pve_cocoon_heal")
#define ROGUE_PVE_COCOON_BLOOD rogue_value("pve_cocoon_blood")
