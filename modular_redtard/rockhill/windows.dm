/obj/structure/roguewindow
	max_integrity = 200
	integrity_failure = 0.5
	var/base_state

/obj/structure/roguewindow/update_icon_state()
	. = ..()
	if(base_state)
		icon_state = "[base_state][broken ? "br" : ""]"

/obj/structure/roguewindow/atom_break(damage_flag)
	. = ..()
	if(broken)
		return
	broken = TRUE
	AddElement(/datum/element/climbable)
	set_opacity(FALSE)
	playsound(src, SFX_SHATTER, 100, TRUE)
	new /obj/item/natural/glass_shard(drop_location())
	new /obj/effect/decal/cleanable/debris/glassy(drop_location())
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/roguewindow/openclose
	var/lockdir
	var/window_lock_strength = ROCKHILL_WINDOW_LOCK

/obj/structure/roguewindow/openclose/reinforced
	max_integrity = 800
	integrity_failure = 0.1
	window_lock_strength = ROCKHILL_WINDOW_LOCK_REINFORCED

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
	var/suffix = broken ? "br" : (opacity ? "" : "op")
	icon_state = "[GLOB.rockhill_time_of_day == ROCKHILL_NIGHT ? "" : "w-"][base_state][suffix]"

/obj/structure/roguewindow/openclose/proc/is_open()
	return !opacity

/obj/structure/roguewindow/openclose/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || !user.can_perform_action(src))
		return
	toggle_from(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/roguewindow/openclose/item_interaction_secondary(mob/living/user, obj/item/tool, list/modifiers)
	if(get_dir(src, user) == lockdir || !istype(tool, /obj/item/rogueweapon/huntingknife))
		if(!user.can_perform_action(src))
			return ITEM_INTERACT_BLOCKING
		toggle_from(user)
		return ITEM_INTERACT_SUCCESS
	pry(user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/structure/roguewindow/openclose/proc/toggle_from(mob/user)
	if(get_dir(src, user) != lockdir)
		to_chat(user, span_warning("The window doesn't close from this side."))
		return
	if(broken)
		to_chat(user, span_warning("It's broken, that would be foolish."))
		return
	set_shutters(is_open(), user)

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

/obj/structure/roguewindow/openclose/proc/pry(mob/living/user, obj/item/knife)
	if(broken)
		to_chat(user, span_warning("It's broken, that would be foolish."))
		return
	if(DOING_INTERACTION_WITH_TARGET(user, src))
		return
	var/list/inputs = list(
		"lockpicking" = user.rogue_skill_rank(/datum/attribute/skill/misc/lockpicking),
		"perception" = user.rogue_stat(ROGUE_STAT_PERCEPTION),
		"speed" = user.rogue_stat(ROGUE_STAT_SPEED),
		"picklvl" = knife.picklvl,
		"open" = is_open(),
	)
	var/pry_time = rogue_formula_value(ROGUE_FORMULA_WINDOW_PRY_TIME, inputs)
	var/progress_step = rogue_formula_value(ROGUE_FORMULA_WINDOW_PRY_PROGRESS, inputs)
	var/chance = rogue_formula_value(ROGUE_FORMULA_WINDOW_PRY_CHANCE, inputs)
	var/progress = 0
	if(!is_open())
		to_chat(user, span_notice("I slide [knife] through [src] seal..."))
	while(progress < window_lock_strength)
		if(!do_after(user, pry_time, target = src) || QDELETED(knife) || user.get_active_held_item() != knife || broken)
			return
		if(!prob(chance))
			botch_pry(user, knife, chance)
			return
		progress += progress_step
		playsound(src, ROCKHILL_WINDOW_PICK_GOOD_SOUND, 5, TRUE)
		to_chat(user, span_warning("Click... [chance]% chance to succeed..."))
		user.rogue_adjust_experience(/datum/attribute/skill/misc/lockpicking, max(round(user.rogue_stat(ROGUE_STAT_INTELLIGENCE) / 2), 1), silent = TRUE)
	var/was_open = is_open()
	set_shutters(was_open)
	user.log_message("pried [src] [was_open ? "closed" : "open"] at [AREACOORD(src)]", LOG_GAME)
	if(was_open)
		user.visible_message(span_notice("[user] closes the window!"), span_notice("I close the window!"))
	else
		user.visible_message(span_notice("[user] pries open [src] with [knife]!"), span_notice("I pry [src] open!"))

/obj/structure/roguewindow/openclose/proc/botch_pry(mob/living/user, obj/item/knife, chance)
	playsound(src, ROCKHILL_WINDOW_PICK_BAD_SOUND, 40, TRUE)
	knife.take_damage(ROCKHILL_WINDOW_KNIFE_DAMAGE, BRUTE, MELEE)
	to_chat(user, span_warning("Clack. [100 - chance]% chance to fail."))
	user.rogue_adjust_experience(/datum/attribute/skill/misc/lockpicking, max(round(user.rogue_stat(ROGUE_STAT_INTELLIGENCE) / 4), 1), silent = TRUE)
	user.log_message("broke [src] while prying it at [AREACOORD(src)]", LOG_GAME)
	update_integrity(min(get_integrity(), max_integrity * integrity_failure))
	atom_break(BRUTE)
	user.visible_message(span_warning("[user] fails! The window is broken!"), span_danger("I fail! The window breaks!"))
	audible_message(span_warning("A loud crash of a window getting broken rings out."), hearing_distance = ROCKHILL_WINDOW_CRASH_RANGE)
