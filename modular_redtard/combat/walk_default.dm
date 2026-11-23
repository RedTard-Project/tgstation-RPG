/// Б22 (owner, 2026-11-22): on medieval maps and in the light launch (rogue_combat_enabled()) a person comes into the world
/// walking, as on Ratwood (m_intent = MOVE_INTENT_WALK for every mob), and the player switches to running; TG starts everyone
/// running. The move intent is set before TG's Initialize() so that its update_config_movespeed() takes the walking speed,
/// and the HUD's sprint button reads it when it is drawn. A rider who walks does not gallop (husbandry/mounts.dm). The
/// module's NPCs keep TG's running: their AI never switches to it, as Ratwood's NPCs do for a jump (npc_try_jump()).
/mob/living/carbon/human/Initialize(mapload)
	if(!rogue_npc && !ai_controller && rogue_combat_enabled())
		move_intent = MOVE_INTENT_WALK
	return ..()
