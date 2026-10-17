/obj/structure/roguewindow
	var/base_state

/obj/structure/roguewindow/openclose
	var/lockdir

/obj/structure/roguewindow/openclose/Initialize(mapload)
	. = ..()
	lockdir = dir
	RegisterSignal(SSdcs, COMSIG_GLOB_ROCKHILL_TIME_OF_DAY, PROC_REF(on_time_of_day))
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/roguewindow/openclose/proc/on_time_of_day(datum/source)
	SIGNAL_HANDLER
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/roguewindow/openclose/update_icon_state()
	. = ..()
	icon_state = "[GLOB.rockhill_time_of_day == ROCKHILL_NIGHT ? "" : "w-"][base_state][opacity ? "" : "op"]"

/obj/structure/roguewindow/openclose/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || !user.can_perform_action(src))
		return
	if(get_dir(src, user) != lockdir)
		to_chat(user, span_warning("The window doesn't close from this side."))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	set_shutters(!opacity, user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/roguewindow/openclose/proc/set_shutters(closed, mob/user)
	if(closed)
		RemoveElement(/datum/element/climbable)
	else
		AddElement(/datum/element/climbable)
	set_opacity(closed)
	if(user)
		visible_message(span_info("[user] [closed ? "closes" : "opens"] [src]."))
	playsound(src, closed ? 'modular_redtard/rockhill/sound/doors/windowdown.ogg' : 'modular_redtard/rockhill/sound/doors/windowup.ogg', 100, FALSE)
	update_appearance(UPDATE_ICON_STATE)
