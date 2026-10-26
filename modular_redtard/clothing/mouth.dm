/// The mouth slot as Ratwood uses it (carbon.dm can_speak_vocal, emotes.dm, human_movement.dm, emote.dm spit): most things
/// held in the mouth keep it shut, so speech comes out as "mmf" and audible emotes as a noise (TG's muffles_speech, only
/// for the mouth slot); whatever can be spat out drops when the holder is knocked down, now and then as they walk, and on
/// the spit emote.
/obj/item
	/// Something in the mouth keeps it shut (Ratwood muteinmouth); pipes, zigs and a feather do not.
	var/muteinmouth = TRUE
	/// It can be spat out and slips out on its own (Ratwood spitoutmouth).
	var/spitoutmouth = TRUE

/obj/item/Initialize(mapload)
	. = ..()
	if(muteinmouth && (slot_flags & ITEM_SLOT_ROGUE_MOUTH))
		AddElement(/datum/element/muffles_speech/rogue_mouth)

/// TG's gag muffles from any slot the item fits; a coin also fits a pocket, so this one only muffles from the mouth.
/datum/element/muffles_speech/rogue_mouth

/datum/element/muffles_speech/rogue_mouth/equipped(obj/item/source, mob/user, slot)
	SIGNAL_HANDLER
	if(slot & ITEM_SLOT_ROGUE_MOUTH)
		return ..()

/mob/living/carbon/human/proc/rogue_spit_out()
	var/obj/item/mouthful = wear_mouth
	if(!mouthful?.spitoutmouth)
		return FALSE
	visible_message(span_warning("[src] spits out [mouthful]."), span_notice("I spit out [mouthful]."))
	dropItemToGround(mouthful, silent = FALSE)
	return TRUE

/datum/element/rogue_combat/proc/on_mouth_step(mob/living/carbon/human/source, atom/old_loc, movement_dir, forced)
	SIGNAL_HANDLER
	if(!forced && prob(ROGUE_MOUTH_SLIP_CHANCE))
		source.rogue_spit_out()

/datum/emote/living/carbon/human/rogue_spit
	key = "spit"
	key_third_person = "spits"
	message = "spits on the ground."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/human/rogue_spit/run_emote(mob/living/carbon/human/user, params, type_override, intentional)
	if(istype(user) && user.rogue_spit_out())
		return TRUE
	return ..()
