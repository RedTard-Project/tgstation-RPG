/// What a revival costs those it touches (Ratwood debuff/revived of status_effects/rogue/debuff.dm, and the tail of
/// acolyte/astrata.dm revive/cast, acolyte/resurrect.dm and the surgery of the hearth): whoever calls a body back is paid in PQ,
/// once for each body, and the body that comes back is sick with it for a time - every stat a little down, and twice as far down
/// if it had begun to rot before it was called back. Every miracle of revival ends in rogue_revived().

/// Set on a body whose first revival already paid its reviver (Ratwood TRAIT_IWASREVIVED).
#define TRAIT_ROGUE_WAS_REVIVED "rogue_was_revived"

/// The aftermath of a revival: PQ for the reviver the first time, and the sickness for the body. was_rotted is read before the
/// revival, which lifts the rot (burial/corpse_rot.dm on_revive()).
/proc/rogue_revived(mob/living/body, mob/living/reviver, was_rotted = FALSE, cause)
	if(QDELETED(body))
		return
	if(reviver?.ckey && !HAS_TRAIT(body, TRAIT_ROGUE_WAS_REVIVED))
		rogue_adjust_pq(rogue_value("pq_gain_revive"), reviver.ckey)
		ADD_TRAIT(body, TRAIT_ROGUE_WAS_REVIVED, cause || ROGUE_FAITH_TRAIT)
	body.apply_status_effect(/datum/status_effect/rogue_revived, was_rotted)

/// Ratwood debuff/revived: for a quarter of an hour the body that was called back is the weaker for it. A rotted body (Ratwood's
/// "doubly so") loses more. A new revival starts the time over, and takes the heavier penalty of the two.
/datum/status_effect/rogue_revived
	id = "rogue_revived"
	status_type = STATUS_EFFECT_REFRESH
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = /atom/movable/screen/alert/status_effect/rogue_revived
	/// Stat points lost from every stat.
	var/penalty = 0
	var/rotted = FALSE

/datum/status_effect/rogue_revived/on_creation(mob/living/new_owner, was_rotted = FALSE)
	duration = rogue_value("revival_sickness_time")
	rotted = was_rotted
	penalty = rogue_value(rotted ? "revival_sickness_penalty_rotted" : "revival_sickness_penalty")
	return ..()

/datum/status_effect/rogue_revived/on_apply()
	apply_penalty()
	return TRUE

/datum/status_effect/rogue_revived/refresh(effect, was_rotted = FALSE)
	if(was_rotted && !rotted)
		rotted = TRUE
		penalty = rogue_value("revival_sickness_penalty_rotted")
		apply_penalty()
	duration = rogue_value("revival_sickness_time")

/datum/status_effect/rogue_revived/on_remove()
	owner.attributes?.remove_attribute_modifier(id)
	to_chat(owner, span_notice("The ache of being called back from death fades from my limbs."))
	return ..()

/datum/status_effect/rogue_revived/proc/apply_penalty()
	owner.attributes?.set_variable_attribute_modifier(id, list(
		ROGUE_STAT_STRENGTH = -penalty,
		ROGUE_STAT_PERCEPTION = -penalty,
		ROGUE_STAT_INTELLIGENCE = -penalty,
		ROGUE_STAT_CONSTITUTION = -penalty,
		ROGUE_STAT_WILLPOWER = -penalty,
		ROGUE_STAT_SPEED = -penalty,
		ROGUE_STAT_FORTUNE = -penalty,
	))

/atom/movable/screen/alert/status_effect/rogue_revived
	name = "Revival Sickness"
	desc = "You felt lyfe itself course through you, restoring your lux and your essence. You... live - but your body aches. It still needs time to recover..."
	icon = ROGUE_COMBAT_ALERTS_ICON
	icon_state = "revived"

#undef TRAIT_ROGUE_WAS_REVIVED
