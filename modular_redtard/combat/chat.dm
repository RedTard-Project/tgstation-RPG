/// Ratwood's combat chat (next_attack_msg): what a strike did besides its damage, a crit or a wound, is told at the end
/// of the strike's own line, so the chat reads one line per blow and in the order things happened. A list only while
/// a strike lands (rogue_take_strike), null otherwise.
/mob/living/var/list/rogue_strike_notes

/// A crit or a wound as Ratwood tells it: on the line of the strike that dealt it, or on a line of its own when no
/// strike is landing (a special, a guard's counter). The text comes in an element of its own: the chat translates
/// the strike's line and each note apart (rogue_panel/localization/translate.ts).
/mob/living/proc/rogue_strike_note(text)
	if(islist(rogue_strike_notes))
		rogue_strike_notes += text
		return
	visible_message(text, vision_distance = COMBAT_MESSAGE_RANGE)

/// "Critical hit!" in Ratwood's crit colour, before what the crit did.
/proc/rogue_crit_text(text)
	return span_crit("<b>Critical hit!</b> [text]")

/// TG tells a wound on a line of its own, and before the strike that dealt it, as the damage lands first. During a
/// strike the wound is told on the strike's line instead, as a crit when a crit dealt it; its sound still plays.
/datum/wound/apply_wound(obj/item/bodypart/limb, silent = FALSE, datum/wound/old_wound = null, smited = FALSE, attack_direction = null, wound_source = "Unknown", replacing = FALSE)
	var/mob/living/carbon/struck = limb?.owner
	if(silent || !islist(struck?.rogue_strike_notes))
		return ..()
	. = ..(limb, TRUE, old_wound, smited, attack_direction, wound_source, replacing)
	if(!. || severity == WOUND_SEVERITY_TRIVIAL || (old_wound && severity <= old_wound.severity))
		return
	var/text = "[struck]'s [limb.plaintext_zone] [occur_text]!"
	if(wound_source == ROGUE_CRIT_WOUND_SOURCE)
		text = rogue_crit_text(text)
	else
		text = severity > WOUND_SEVERITY_SEVERE ? "<b>[text]</b>" : span_danger(text)
	struck.rogue_strike_note(text)
	if(sound_effect)
		playsound(struck, sound_effect, sound_volume + (20 * severity), TRUE, falloff_exponent = SOUND_FALLOFF_EXPONENT + 2, ignore_walls = FALSE, falloff_distance = 0)
