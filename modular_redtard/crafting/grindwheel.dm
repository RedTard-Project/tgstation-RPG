#define GRINDWHEEL_SHARPEN_SOUND 'modular_redtard/rockhill/sound/foley/grindblade.ogg'
#define GRINDWHEEL_WOOD_SOUNDS list('modular_redtard/rockhill/sound/misc/slide_wood (1).ogg', 'modular_redtard/rockhill/sound/misc/slide_wood (2).ogg')
#define GRINDWHEEL_RUIN_SOUND 'modular_redtard/rockhill/sound/combat/hits/onwood/destroyfurniture.ogg'

/// Ratwood grinding wheel (roguejobs/blacksmith/grindwheel.dm): a blade held to it for 4 seconds comes back whole - edge
/// and the maximum the whetstone ground away (Ratwood restore_bintegrity()); a small log is planed into a plank.
/obj/structure/fluff/grindwheel
	max_integrity = 300

/obj/structure/fluff/grindwheel/examine(mob/user)
	. = ..()
	. += span_info("Hold a blade to it to restore the edge, or a small log to plane a plank.")

/obj/structure/fluff/grindwheel/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(tool.max_blade_int)
		INVOKE_ASYNC(src, PROC_REF(grind_blade), tool, user)
		return ITEM_INTERACT_SUCCESS
	if(istype(tool, /obj/item/grown/log/tree/small))
		INVOKE_ASYNC(src, PROC_REF(plane_log), tool, user)
		return ITEM_INTERACT_SUCCESS
	return ..()

/obj/structure/fluff/grindwheel/proc/grind_blade(obj/item/blade, mob/living/user)
	if(DOING_INTERACTION_WITH_TARGET(user, src))
		return
	playsound(src, GRINDWHEEL_SHARPEN_SOUND, 100, FALSE)
	if(!do_after(user, rogue_value("grindwheel_sharpen_time"), target = src) || QDELETED(blade))
		return
	blade.rogue_restore_edge()
	user.visible_message(span_notice("[user] grinds [blade] to a fresh edge."), span_notice("I grind [blade] to a fresh edge."))

/// Ratwood restore_bintegrity(): the maximum edge and the edge itself return to the blade's original.
/obj/item/proc/rogue_restore_edge()
	max_blade_int = initial(max_blade_int)
	blade_int = max_blade_int

/// Ratwood: carpentry rank cuts the time (4 seconds - 0.5 per rank) and the waste (40% - 10% per rank, all of it untrained).
/obj/structure/fluff/grindwheel/proc/plane_log(obj/item/log, mob/living/user)
	if(DOING_INTERACTION_WITH_TARGET(user, src))
		return
	var/rank = user.rogue_skill_rank(/datum/attribute/skill/craft/carpentry)
	playsound(src, pick(GRINDWHEEL_WOOD_SOUNDS), 100, FALSE)
	if(!do_after(user, max(4 SECONDS - rank * 0.5 SECONDS, 0), target = src) || QDELETED(log) || !user.is_holding(log))
		return
	if(!rank || prob(max(40 - rank * 10, 0)))
		to_chat(user, span_info("Curses! I ruined this piece of wood..."))
		playsound(src, GRINDWHEEL_RUIN_SOUND, 100, FALSE)
	else
		new /obj/item/natural/wood/plank(get_turf(src))
	user.rogue_craft_experience(/datum/attribute/skill/craft/carpentry, user.rogue_stat(ROGUE_STAT_INTELLIGENCE) * 0.5)
	qdel(log)

#undef GRINDWHEEL_SHARPEN_SOUND
#undef GRINDWHEEL_WOOD_SOUNDS
#undef GRINDWHEEL_RUIN_SOUND
