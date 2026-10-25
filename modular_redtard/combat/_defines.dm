#define BCLASS_BLUNT "blunt"
#define BCLASS_SMASH "smashing"
#define BCLASS_CUT "slash"
#define BCLASS_CHOP "chopping"
#define BCLASS_STAB "stabbing"
#define BCLASS_PICK "stab"
#define BCLASS_LASHING "lashing"
#define BCLASS_PIERCE "pierce"
#define BCLASS_TWIST "twist"
#define BCLASS_PUNCH "punch"
#define BCLASS_BITE "bite"
#define BCLASS_BURN "charring"
#define BCLASS_PEEL "peel"
#define BCLASS_PUNISH "punish"
#define BCLASS_EFFECT "effect"
#define BCLASS_SUNDER "sunder"

#define ROGUE_ARMOR_BLUNT "blunt"
#define ROGUE_ARMOR_SLASH "slash"
#define ROGUE_ARMOR_STAB "stab"
#define ROGUE_ARMOR_PIERCING "piercing"
#define ROGUE_ARMOR_FIRE "fire"
#define ROGUE_ARMOR_ACID "acid"
#define ROGUE_ARMOR_MAGIC "magic"
#define ROGUE_ARMOR_WOUND "wound"
#define ROGUE_ARMOR_DAMAGE_TYPES list(ROGUE_ARMOR_BLUNT, ROGUE_ARMOR_SLASH, ROGUE_ARMOR_STAB, ROGUE_ARMOR_PIERCING)
#define ROGUE_ARMOR_ALL_TYPES list(ROGUE_ARMOR_BLUNT, ROGUE_ARMOR_SLASH, ROGUE_ARMOR_STAB, ROGUE_ARMOR_PIERCING, ROGUE_ARMOR_FIRE, ROGUE_ARMOR_ACID, ROGUE_ARMOR_MAGIC, ROGUE_ARMOR_WOUND)
#define ROGUE_ARMOR_EDGE_TYPES list(ROGUE_ARMOR_SLASH, ROGUE_ARMOR_STAB, ROGUE_ARMOR_PIERCING)

#define ARMOR_CLASS_NONE 0
#define ARMOR_CLASS_LIGHT 1
#define ARMOR_CLASS_MEDIUM 2
#define ARMOR_CLASS_HEAVY 3

#define PLATEHIT "plate"
#define CHAINHIT "chain"
#define SOFTHIT "soft"
#define SOFTUNDERHIT "softunder"

#define WBALANCE_NORMAL 0
#define WBALANCE_HEAVY -1
#define WBALANCE_SWIFT 1

#define WLENGTH_SHORT 1
#define WLENGTH_NORMAL 2
#define WLENGTH_LONG 3
#define WLENGTH_GREAT 4

#define ROGUE_INTENT_DODGE 1
#define ROGUE_INTENT_PARRY 2
#define ROGUE_INTENT_SLOTS 4

#define ROGUE_UNARMED_HELP "help"
#define ROGUE_UNARMED_SHOVE "shove"
#define ROGUE_UNARMED_GRAB "grab"
#define ROGUE_UNARMED_HARM "harm"

#define ROGUE_CLICK_CD_MELEE 12
#define ROGUE_STRIKE_MIN_CLICK rogue_value("strike_min_click")
#define ROGUE_STRIKE_MISS_LUCK rogue_value("strike_miss_luck")
#define ROGUE_STRIKE_BLOOD_DAMAGE rogue_value("strike_blood_damage")
#define ROGUE_STRIKE_BLUNT_BLOOD_DAMAGE rogue_value("strike_blunt_blood_damage")
#define ROGUE_BLADE_HIT_WEAR rogue_value("blade_hit_wear")
#define ROGUE_BLADE_PARRY_WEAR rogue_value("blade_parry_wear")
#define ROGUE_BLADE_STRONG_WEAR rogue_value("blade_strong_wear")
#define ROGUE_BLADE_DULL_START rogue_value("blade_dull_start")
#define ROGUE_BLADE_DULL_FLOOR rogue_value("blade_dull_floor")
#define ROGUE_BLADE_CHIP_START rogue_value("blade_chip_start")
#define ROGUE_BLADE_SHARPEN_FIRST rogue_value("blade_sharpen_first")
#define ROGUE_BLADE_SHARPEN_TIME rogue_value("blade_sharpen_time")
#define ROGUE_BLADE_SHARPEN_WEAR rogue_value("blade_sharpen_wear")
#define ROGUE_BLADE_MIN_MAX rogue_value("blade_min_max")


#define BASE_PARRY_STAMINA_DRAIN rogue_value("base_parry_stamina_drain")
#define UNARMED_BASE_WDEF_BARE rogue_value("unarmed_base_wdef_bare")
#define UNARMED_BASE_WDEF_EQUIPPED rogue_value("unarmed_base_wdef_equipped")
#define ROGUE_PARRY_DELAY rogue_value("parry_delay")
#define ROGUE_PARRY_UNTRAINED_DRAIN rogue_value("parry_untrained_drain")
#define ROGUE_PARRY_INTEGRITY_DAMAGE rogue_value("parry_integrity_damage")

#define ROGUE_DODGE_DELAY rogue_value("dodge_delay")
#define ROGUE_DODGE_STAMINA_DRAIN rogue_value("dodge_stamina_drain")
#define ROGUE_DODGE_MIN_DRAIN rogue_value("dodge_min_drain")


#define ROGUE_XP_PER_INT rogue_value("xp_per_int")
#define ROGUE_XP_NPC_FACTOR rogue_value("xp_npc_factor")

#define COMSIG_MOB_ROGUE_INTENT_CHANGED "mob_rogue_intent_changed"

#define COMSIG_MOB_ROGUE_DEFENSE_CHANGED "mob_rogue_defense_changed"
#define COMSIG_MOB_ROGUE_ENERGY_CHANGED "mob_rogue_energy_changed"
#define COMSIG_MOB_ROGUE_ADVSETUP_CLICKED "mob_rogue_advsetup_clicked"
#define ROGUE_IN_COMBAT_TIME rogue_value("in_combat_time")
#define ROGUE_ENERGY_RUN_COST rogue_value("energy_run_cost")
#define ROGUE_ENERGY_TICK_SECONDS 2
#define ROGUE_ENERGY_COMBAT_DRAIN rogue_value("energy_combat_drain")
#define ROGUE_ENERGY_SLEEP_GAIN rogue_value("energy_sleep_gain")
#define ROGUE_ENERGY_REST_GAIN rogue_value("energy_rest_gain")
#define ROGUE_ENERGY_BED_FACTOR rogue_value("energy_bed_factor")
#define ROGUE_ENERGY_GROUND_FACTOR rogue_value("energy_ground_factor")
#define ROGUE_ENERGY_HUD_STEP 5
#define ROGUE_ADVSETUP_FADE (3 SECONDS)
#define ROGUE_FOV_SOURCE "rogue_fov"
#define COMSIG_MOB_ROGUE_SNEAK_CHANGED "mob_rogue_sneak_changed"
#define ROGUE_SNEAK_SOURCE "rogue_sneak"
#define ROGUE_SNEAK_LIGHT rogue_value("sneak_light")
#define ROGUE_SNEAK_LIGHT_PER_RANK rogue_value("sneak_light_per_rank")
#define ROGUE_SNEAK_SLOW_BASE rogue_value("sneak_slow_base")
#define ROGUE_SNEAK_SLOW_PER_RANK rogue_value("sneak_slow_per_rank")
#define ROGUE_SNEAK_FADE rogue_value("sneak_fade")
#define ROGUE_SNEAK_FADE_PER_RANK rogue_value("sneak_fade_per_rank")
#define ROGUE_SNEAK_MIN_REVEAL rogue_value("sneak_min_reveal")
#define ROGUE_SNEAK_INVIS_PER_RANK rogue_value("sneak_invis_per_rank")
#define ROGUE_SNEAK_ATTACK_REVEAL rogue_value("sneak_attack_reveal")
#define COMSIG_MOB_ROGUE_MMB_CHANGED "mob_rogue_mmb_changed"
#define ROGUE_MMB_NONE 0
#define ROGUE_MMB_BITE 1
#define ROGUE_MMB_JUMP 2
#define ROGUE_MMB_KICK 3
#define ROGUE_MMB_STEAL 4
#define ROGUE_QUAD_STEAL_TOP 9
#define ROGUE_QUAD_KICK_TOP 16
#define ROGUE_QUAD_JUMP_TOP 24
#define ROGUE_ZONE_NECK "neck"
#define ROGUE_KICK_LEGS 2
#define ROGUE_KICK_SWING rogue_value("kick_swing")
#define ROGUE_KICK_DAMAGE rogue_value("kick_damage")
#define ROGUE_KICK_OFFBALANCE rogue_value("kick_offbalance")
#define ROGUE_KICK_SHOVE_PER_STRENGTH rogue_value("kick_shove_per_strength")
#define ROGUE_KICK_ITEM_RANGE rogue_value("kick_item_range")
#define ROGUE_KICK_LEVER_PER_STRENGTH rogue_value("kick_lever_per_strength")
#define ROGUE_JUMP_WALK_RANGE rogue_value("jump_walk_range")
#define ROGUE_JUMP_RUN_RANGE rogue_value("jump_run_range")
#define ROGUE_JUMP_WALK_STAMINA rogue_value("jump_walk_stamina")
#define ROGUE_JUMP_RUN_STAMINA rogue_value("jump_run_stamina")
#define ROGUE_JUMP_WALK_OFFBALANCE rogue_value("jump_walk_offbalance")
#define ROGUE_JUMP_RUN_OFFBALANCE rogue_value("jump_run_offbalance")
#define ROGUE_BITE_DAMAGE rogue_value("bite_damage")
#define ROGUE_STEAL_TIME rogue_value("steal_time")
#define ROGUE_STEAL_UNAWARE_FACTOR rogue_value("steal_unaware_factor")
#define ROGUE_STEAL_FUMBLE rogue_value("steal_fumble")
#define ROGUE_STEAL_RING_BASE rogue_value("steal_ring_base")
#define ROGUE_STEAL_RING_PER_RANK rogue_value("steal_ring_per_rank")
#define ROGUE_STEAL_RING_MIN rogue_value("steal_ring_min")
#define ROGUE_STEAL_RING_MAX rogue_value("steal_ring_max")
#define COMSIG_MOB_ROGUE_RMB_CHANGED "mob_rogue_rmb_changed"
#define COMSIG_MOB_ROGUE_FEINT_USED "mob_rogue_feint_used"
#define ROGUE_FEINT_DURATION rogue_value("feint_duration")
#define ROGUE_FEINT_COOLDOWN rogue_value("feint_cooldown")
#define ROGUE_FEINT_TARGET_CLICK rogue_value("feint_target_click")
#define ROGUE_FEINT_TARGET_CLICK_MIN rogue_value("feint_target_click_min")
#define ROGUE_FEINT_IMMOBILIZE rogue_value("feint_immobilize")
#define ROGUE_FEINT_BAR_TICK (1 SECONDS)
#define COMSIG_MOB_ROGUE_EYE_CHANGED "mob_rogue_eye_changed"
#define ROGUE_EYELIDS_SOURCE "rogue_eyelids"
#define ROGUE_EYELID_TOP 29
#define ROGUE_EYELID_BOTTOM 4
#define ROGUE_LOOK_AROUND_CLICK rogue_value("look_around_click")
#define ROGUE_LOOK_AROUND_RANGE rogue_value("look_around_range")
#define ROGUE_LOOK_AROUND_REVEAL rogue_value("look_around_reveal")
#define ROGUE_PING_ICON 'modular_redtard/icons/effects/rogue_ping.dmi'
#define ROGUE_PING_HIDDEN "hidden"
#define ROGUE_PING_TRAP "trap"
#define ROGUE_PING_DURATION (3 SECONDS)
#define ROGUE_COMPLIANCE_SOURCE "rogue_compliance"
#define ROGUE_ALERT_ICON 'modular_redtard/icons/hud/rogue_alerts.dmi'

#define ROGUE_GRAB_ACTION_DELAY rogue_value("grab_action_delay")
#define ROGUE_GRAB_COMPLIANT_MODIFIER rogue_value("grab_compliant_modifier")
#define ROGUE_GRAB_RESTRAINED_BONUS rogue_value("grab_restrained_bonus")
#define ROGUE_GRAB_PRONE_BONUS rogue_value("grab_prone_bonus")
#define ROGUE_GRAB_COMBAT_BONUS rogue_value("grab_combat_bonus")
#define ROGUE_GRAB_CHOKEHOLD_BONUS rogue_value("grab_chokehold_bonus")
#define ROGUE_GRAB_UPGRADE_COST_MIN rogue_value("grab_upgrade_cost_min")
#define ROGUE_GRAB_UPGRADE_COST_MAX rogue_value("grab_upgrade_cost_max")
#define ROGUE_GRAB_CHOKE_COST_MIN rogue_value("grab_choke_cost_min")
#define ROGUE_GRAB_CHOKE_COST_MAX rogue_value("grab_choke_cost_max")
#define ROGUE_GRAB_TWIST_COST_MIN rogue_value("grab_twist_cost_min")
#define ROGUE_GRAB_TWIST_COST_MAX rogue_value("grab_twist_cost_max")
#define ROGUE_GRAB_SHOVE_COST_MIN rogue_value("grab_shove_cost_min")
#define ROGUE_GRAB_SHOVE_COST_MAX rogue_value("grab_shove_cost_max")
#define ROGUE_GRAB_PIN_COST_MIN rogue_value("grab_pin_cost_min")
#define ROGUE_GRAB_PIN_COST_MAX rogue_value("grab_pin_cost_max")
#define ROGUE_GRAB_PIN_COST_TIME_FACTOR rogue_value("grab_pin_cost_time_factor")
#define ROGUE_GRAB_PIN_FIRST_CUT rogue_value("grab_pin_first_cut")
#define ROGUE_GRAB_PIN_DECAY rogue_value("grab_pin_decay")
#define ROGUE_GRAB_DISARM_COST_MIN rogue_value("grab_disarm_cost_min")
#define ROGUE_GRAB_DISARM_COST_MAX rogue_value("grab_disarm_cost_max")
#define ROGUE_GRAB_DISARM_DROP_BONUS rogue_value("grab_disarm_drop_bonus")
#define ROGUE_GRAB_DISARM_STUN rogue_value("grab_disarm_stun")
#define ROGUE_GRAB_DISARM_CLICK rogue_value("grab_disarm_click")
#define ROGUE_GRAB_STRUGGLE_USER rogue_value("grab_struggle_user")
#define ROGUE_GRAB_STRUGGLE_TARGET rogue_value("grab_struggle_target")
#define ROGUE_GRAB_KNOCKDOWN_BASE rogue_value("grab_knockdown_base")
#define ROGUE_GRAB_KNOCKDOWN_PER_SKILL rogue_value("grab_knockdown_per_skill")
#define ROGUE_GRAB_CHOKE_EMOTE_CHANCE rogue_value("grab_choke_emote_chance")
#define ROGUE_GRAB_HEADBUTT_TARGET_FACTOR rogue_value("grab_headbutt_target_factor")
#define ROGUE_GRAB_HEADBUTT_TARGET_HOLD rogue_value("grab_headbutt_target_hold")
#define ROGUE_GRAB_HEADBUTT_USER_HOLD rogue_value("grab_headbutt_user_hold")
#define ROGUE_BITE_CHEW_LINE 17
#define ROGUE_BITE_STRONG_FACTOR rogue_value("bite_strong_factor")
#define ROGUE_GRAB_SOUND 'modular_redtard/rockhill/sound/foley/grab.ogg'
#define ROGUE_GRAB_STRUGGLE_SOUND 'modular_redtard/rockhill/sound/foley/struggle.ogg'
