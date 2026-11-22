/// Shift+G (Vibelin and Twilight Axis /datum/keybinding/carbon/toggle_arc_mode, "Toggle Spell Alt Mode"): the alt mode of the
/// armed spell, the arc of a projectile spell or what else a spell switches (toggle_alt_mode()). Medieval layout only, like
/// the rest of the medieval controls (hud/rogue_keybindings.dm).
/datum/keybinding/rogue/spell_alt_mode
	name = "rogue_spell_alt_mode"
	hotkey_keys = list("ShiftG")
	full_name = "Spell alt mode"
	description = "Toggle the alt mode of the spell you have readied: arc mode for bolts (they fly over everyone in between), and the like"
	keybind_signal = COMSIG_KB_ROGUE_SPELL_ALT_MODE_DOWN

/datum/keybinding/rogue/spell_alt_mode/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/owner = user.mob
	var/datum/action/cooldown/spell/rogue/spell = owner.click_intercept
	if(!istype(spell))
		to_chat(owner, span_warning("No readied spell with an alt mode."))
		return TRUE
	if(!spell.toggle_alt_mode(owner))
		to_chat(owner, span_warning("[spell] has no alt mode."))
	return TRUE
