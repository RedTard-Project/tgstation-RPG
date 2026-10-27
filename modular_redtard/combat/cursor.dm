/// Ratwood mouse cursors for fighters on medieval maps: a plain hand, a fist while attacking, an eye while looking or examining,
/// the middle-button intent's own cursor, and the filling sword of a charge (combat/charge.dm).
/mob/living/carbon/human/var/rogue_cursors = FALSE

/mob/living/carbon/human/proc/rogue_set_cursor(cursor)
	if(!client || !rogue_cursors || client.mouse_override_icon)
		return
	if(client.mouse_pointer_icon != cursor)
		client.mouse_pointer_icon = cursor

/mob/living/carbon/human/update_mouse_pointer()
	. = ..()
	if(!client || !rogue_cursors || client.mouse_override_icon)
		return
	if(client.mouse_pointer_icon == initial(client.mouse_pointer_icon))
		client.mouse_pointer_icon = ROGUE_CURSOR_DEFAULT

/mob/living/carbon/human/proc/rogue_mmb_cursor()
	switch(rogue_mmb_intent)
		if(ROGUE_MMB_KICK)
			return ROGUE_CURSOR_KICK
		if(ROGUE_MMB_JUMP)
			return ROGUE_CURSOR_JUMP
		if(ROGUE_MMB_NONE)
			return ROGUE_CURSOR_LOOKING
	return ROGUE_CURSOR_ATTACK

/mob/living/carbon/human/proc/rogue_enable_cursors(enabled)
	rogue_cursors = enabled
	examine_cursor_icon = enabled ? ROGUE_CURSOR_LOOKING : initial(examine_cursor_icon)
	update_mouse_pointer()

/// While a mouse button is held the fighter keeps facing where they clicked and steps sideways (Ratwood tempfixeye).
/mob/living/var/rogue_facing_held = FALSE

/mob/living/proc/rogue_hold_facing(held)
	if(rogue_facing_held == held)
		return
	rogue_facing_held = held
	set_dir_on_move = !(rogue_fixed_eye || rogue_facing_held)
