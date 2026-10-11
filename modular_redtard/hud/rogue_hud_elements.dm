/// TRUE if some TG system (mood, crafting) listens for clicks on this element
/atom/movable/screen/proc/rogue_has_click_listener()
	return !isnull(_listen_lookup?[COMSIG_SCREEN_ELEMENT_CLICK])

/// Azure's left panel behind the HUD columns, without the border Azure draws around the map
/atom/movable/screen/rogue/panel
	name = " "
	icon = ROGUE_HUD_ICON_PANEL
	icon_state = "panel"
	screen_loc = rogueui_panel
	plane = FULLSCREEN_PLANE
	layer = ROGUE_BACKHUD_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/// TG's inventory toggle with Azure's bag sprite, in the bottom-left corner: shows and hides the inventory block
/atom/movable/screen/human/toggle/rogue
	name = "inventory"
	icon = ROGUE_HUD_ICON
	icon_state = "back"
	base_icon_state = "back"
	screen_loc = rogueui_inventory_toggle
	layer = ROGUE_HUD_LAYER

/atom/movable/screen/human/toggle/rogue/update_icon_state()
	. = ..()
	icon_state = base_icon_state

/// TG's toggle reads usr.client unchecked; the same flip, safe for client-less mobs
/atom/movable/screen/human/toggle/rogue/Click(location, control, params)
	var/datum/hud/viewer_hud = usr.hud_used
	if(!viewer_hud)
		return
	var/mob/target = usr
	if(isobserver(usr) && ishuman(usr.client?.eye) && usr.client.eye != usr)
		target = usr.client.eye
	var/list/inventory = target.hud_used?.screen_groups[HUD_GROUP_TOGGLEABLE_INVENTORY]
	viewer_hud.inventory_shown = !viewer_hud.inventory_shown
	if(usr.client && inventory)
		if(viewer_hud.inventory_shown)
			usr.client.screen |= inventory
		else
			usr.client.screen -= inventory
	update_appearance()

/atom/movable/screen/rogue/heatstam_overlay
	icon = ROGUE_HUD_ICON_HEAT
	icon_state = "heatstamover"
	screen_loc = rogueui_fat
	layer = ROGUE_HUD_LAYER + 0.1
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/// Azure's combat mode button, driving TG combat mode
/atom/movable/screen/combattoggle/rogue
	name = "combat mode"
	icon = ROGUE_HUD_ICON
	icon_state = "combat0"
	screen_loc = rogueui_cmode
	layer = ROGUE_HUD_LAYER

/atom/movable/screen/combattoggle/rogue/update_icon_state()
	. = ..()
	var/mob/living/owner = get_mob()
	icon_state = "combat[istype(owner) && owner.combat_mode ? 1 : 0]"

/atom/movable/screen/combattoggle/rogue/Click(location, control, params)
	var/mob/living/user = usr
	if(!isliving(user) || user != get_mob())
		return
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		user.emote("surrender")
		return
	if(LAZYACCESS(modifiers, MIDDLE_CLICK))
		rogue_hud_not_implemented(user)
		return
	if(LAZYACCESS(modifiers, SHIFT_CLICK))
		to_chat(user, span_info("* --- *<br>Combat mode button.<br><b>Left click:</b> toggles combat mode.<br><b>Right click:</b> surrender.<br><b>Middle click:</b> compliance mode, [ROGUE_HUD_STUB_TEXT]."))
		return
	return ..()

/// Azure's weapon intent selector. The intents themselves come with the combat port, which handles COMSIG_MOB_ROGUE_HUD_INTENT_CLICK.
/atom/movable/screen/rogue/weapon_intents
	name = "intent"
	icon = ROGUE_HUD_ICON_INTENT_BASE
	icon_state = "intentbase"
	screen_loc = rogueui_intents
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/rogue/weapon_intents/Click(location, control, params)
	. = ..()
	var/mob/user = get_mob()
	if(usr != user)
		return
	var/list/modifiers = params2list(params)
	var/index = get_index_at_loc(text2num(LAZYACCESS(modifiers, ICON_X)), text2num(LAZYACCESS(modifiers, ICON_Y)))
	if(!index)
		return
	if(SEND_SIGNAL(user, COMSIG_MOB_ROGUE_HUD_INTENT_CLICK, index, modifiers) & COMPONENT_ROGUE_INTENT_HANDLED)
		return
	rogue_hud_not_implemented(user)

/// Azure's hit map: four 32x16 cells on the right half of the 128x32 base, numbered left to right, top to bottom
/atom/movable/screen/rogue/weapon_intents/proc/get_index_at_loc(icon_x, icon_y)
	if(icon_x <= 64)
		return null
	if(icon_x < 96)
		return icon_y > 16 ? 1 : 3
	return icon_y > 16 ? 2 : 4

/// Azure's stress indicator, showing TG mood
/atom/movable/screen/mood/rogue
	name = "sanity"
	icon = ROGUE_HUD_ICON
	icon_state = "mood_idle"
	screen_loc = rogueui_stress
	layer = ROGUE_HUD_LAYER

/atom/movable/screen/mood/rogue/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	underlays += mutable_appearance(icon, "stressback")
	var/mob/owner = hud_owner?.mymob
	if(owner)
		RegisterSignal(owner, COMSIG_MOB_STATCHANGE, PROC_REF(on_stat_change))

/atom/movable/screen/mood/rogue/Click(location, control, params)
	. = ..()
	if(!rogue_has_click_listener())
		rogue_hud_not_implemented(usr)

/atom/movable/screen/mood/rogue/proc/on_stat_change(datum/source)
	SIGNAL_HANDLER
	update_from_mood()

/// Picks Azure's stress sprite for the owner's TG mood level and state
/atom/movable/screen/mood/rogue/proc/update_from_mood()
	var/mob/living/owner = get_mob()
	color = null
	if(!istype(owner))
		icon_state = "mood_idle"
		return
	var/static/list/level_states = list("stress4", "stress3", "stress2", "stress", "mood_idle", "peace", "peace2", "peace3", "mood_nirvana")
	var/state = "mood_idle"
	if(owner.mob_mood)
		state = level_states[clamp(owner.mob_mood.mood_level, 1, length(level_states))]
	if(owner.get_drunk_amount() >= 1)
		state = "mood_drunkorhigh"
	if(owner.stat == DEAD)
		state = "mood_dead"
	else if(owner.IsSleeping())
		state = "mood_sleep"
	else if(iscarbon(owner))
		var/mob/living/carbon/carbon_owner = owner
		if(carbon_owner.disgust >= DISGUST_LEVEL_DISGUSTED)
			state = "mood_sick"
	icon_state = state

/// Azure's "life" indicator: blood loss, toxin and oxygen damage
/atom/movable/screen/healths/rogue
	name = "life"
	icon = ROGUE_HUD_ICON_HEAT
	icon_state = "dam0"
	screen_loc = rogueui_blood
	layer = ROGUE_HUD_LAYER
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/healths/rogue/Click(location, control, params)
	var/mob/living/carbon/user = usr
	if(!iscarbon(user) || user != get_mob())
		return
	if(LAZYACCESS(params2list(params), RIGHT_CLICK))
		rogue_hud_not_implemented(user)
		return
	user.check_self_for_injuries()

/// Azure's update_health_hud body for the bloods element
/atom/movable/screen/healths/rogue/proc/update_for(mob/living/owner)
	cut_overlays()
	if(owner.stat == DEAD)
		icon_state = "damelse"
		return
	var/blood_loss = 0
	if(CAN_HAVE_BLOOD(owner))
		blood_loss = (BLOOD_VOLUME_NORMAL - owner.get_blood_volume(apply_modifiers = TRUE)) / BLOOD_VOLUME_NORMAL * 100
	if(blood_loss > 0)
		var/rounded_loss = round(blood_loss, 10)
		icon_state = rounded_loss <= 80 ? "dam[rounded_loss]" : "damelse"
		return
	icon_state = "dam0"
	var/tox_state = loss_overlay_state("toxloss", owner.get_tox_loss())
	if(tox_state)
		add_overlay(tox_state)
	var/oxy_state = loss_overlay_state("oxyloss", owner.get_oxy_loss())
	if(oxy_state)
		add_overlay(oxy_state)

/atom/movable/screen/healths/rogue/proc/loss_overlay_state(prefix, amount)
	if(amount < 1)
		return null
	if(amount < 21)
		return "[prefix]20"
	if(amount < 50)
		return "[prefix]40"
	if(amount < 80)
		return "[prefix]60"
	if(amount < 100)
		return "[prefix]80"
	return "[prefix]100"

/// Azure's fatigue bar, showing TG stamina damage
/atom/movable/screen/stamina/rogue
	icon = ROGUE_HUD_ICON_HEAT
	icon_state = "stam100"
	screen_loc = rogueui_fat
	layer = ROGUE_HUD_LAYER
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/stamina/rogue/Click(location, control, params)
	var/mob/living/user = usr
	if(!isliving(user) || user != get_mob())
		return
	var/threshold = user.maxHealth - user.crit_threshold
	to_chat(user, span_info("<b>Stamina:</b> [round(max(threshold - user.get_stamina_loss(), 0), 0.1)] / [round(threshold, 0.1)]"))

/// Azure's 5% fatigue steps, from "stam100" (rested) down to "stam0" (spent)
/atom/movable/screen/stamina/rogue/proc/update_for(mob/living/owner, shown_stamina_loss)
	if(owner.stat == DEAD)
		return
	var/threshold = owner.maxHealth - owner.crit_threshold
	if(isnull(shown_stamina_loss))
		shown_stamina_loss = owner.get_stamina_loss()
	var/fatigue = threshold > 0 ? shown_stamina_loss / threshold : 1
	if(fatigue >= 1)
		icon_state = "stam0"
		return
	var/steps = max(ceil(fatigue * 20) - 1, 0)
	icon_state = "stam[100 - steps * 5]"

/atom/movable/screen/throw_catch/rogue
	icon = ROGUE_HUD_ICON
	icon_state = "catch0"
	screen_loc = rogueui_throw
	layer = ROGUE_HUD_LAYER

/atom/movable/screen/throw_catch/rogue/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	var/mob/owner = hud_owner?.mymob
	if(owner)
		RegisterSignals(owner, list(COMSIG_LIVING_THROW_MODE_TOGGLE, COMSIG_MOB_SWAP_HANDS, COMSIG_MOB_EQUIPPED_ITEM, COMSIG_MOB_UNEQUIPPED_ITEM), PROC_REF(on_owner_hands_changed))
	update_appearance(UPDATE_ICON_STATE)

/atom/movable/screen/throw_catch/rogue/proc/on_owner_hands_changed(datum/source)
	SIGNAL_HANDLER
	update_appearance(UPDATE_ICON_STATE)

/atom/movable/screen/throw_catch/rogue/update_icon_state()
	var/mob/living/owner = get_mob()
	var/throwing = istype(owner) && owner.throw_mode ? 1 : 0
	icon_state = "[owner?.get_active_held_item() ? "throw" : "catch"][throwing]"
	return ..()

/// Azure's give/take button; giving goes through TG's item offering
/atom/movable/screen/rogue/give
	name = "give/take"
	icon_state = "take0"
	screen_loc = rogueui_give
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/rogue/give/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	var/mob/owner = hud_owner?.mymob
	if(owner)
		RegisterSignals(owner, list(COMSIG_MOB_SWAP_HANDS, COMSIG_MOB_EQUIPPED_ITEM, COMSIG_MOB_UNEQUIPPED_ITEM), PROC_REF(on_owner_hands_changed))
	update_appearance(UPDATE_ICON_STATE)

/atom/movable/screen/rogue/give/proc/on_owner_hands_changed(datum/source)
	SIGNAL_HANDLER
	update_appearance(UPDATE_ICON_STATE)

/atom/movable/screen/rogue/give/update_icon_state()
	var/mob/living/owner = get_mob()
	var/giving = istype(owner) && owner.has_status_effect(/datum/status_effect/offering) ? 1 : 0
	icon_state = "[owner?.get_active_held_item() ? "give" : "take"][giving]"
	return ..()

/atom/movable/screen/rogue/give/Click(location, control, params)
	. = ..()
	var/mob/living/user = usr
	if(!isliving(user) || user != get_mob())
		return
	if(!user.get_active_held_item())
		rogue_hud_not_implemented(user)
		return
	user.give()
	update_appearance(UPDATE_ICON_STATE)

/atom/movable/screen/drop/rogue
	icon = ROGUE_HUD_ICON
	icon_state = "act_drop"
	screen_loc = rogueui_drop
	layer = ROGUE_HUD_LAYER

/// Azure's lower half of the stance tile: lie down, right click looks down
/atom/movable/screen/rest/rogue
	name = "lay down"
	icon = ROGUE_HUD_ICON
	icon_state = "act_rest_down"
	base_icon_state = "act_rest_down"
	screen_loc = rogueui_stance
	layer = ROGUE_HUD_LAYER

/atom/movable/screen/rest/rogue/update_icon_state()
	. = ..()
	icon_state = base_icon_state

/atom/movable/screen/rest/rogue/Click(location, control, params)
	var/mob/living/user = usr
	if(!isliving(user) || user != get_mob())
		return
	if(LAZYACCESS(params2list(params), RIGHT_CLICK))
		if(user.looking_vertically == DOWN)
			user.end_look()
		else
			user.look_down()
		return
	user.set_resting(TRUE, silent = FALSE)

/// Azure's upper half of the stance tile: stand up, right click looks up
/atom/movable/screen/rogue/stand_up
	name = "stand up"
	icon_state = "act_rest_up"
	screen_loc = rogueui_stance
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/rogue/stand_up/Click(location, control, params)
	. = ..()
	var/mob/living/user = usr
	if(!isliving(user) || user != get_mob())
		return
	if(LAZYACCESS(params2list(params), RIGHT_CLICK))
		if(user.looking_vertically == UP)
			user.end_look()
		else
			user.look_up()
		return
	user.set_resting(FALSE, silent = FALSE)

/// Azure's sprint toggle, driving TG run/walk
/atom/movable/screen/mov_intent/rogue
	name = "sprint mode"
	icon = ROGUE_HUD_ICON
	icon_state = "sprint0"
	screen_loc = rogueui_moves
	layer = ROGUE_HUD_LAYER

/atom/movable/screen/mov_intent/rogue/update_icon_state()
	. = ..()
	var/mob/living/owner = get_mob()
	icon_state = "sprint[istype(owner) && owner.move_intent == MOVE_INTENT_RUN ? 1 : 0]"

/atom/movable/screen/rogue/skills
	name = "skills"
	icon_state = "skills"
	screen_loc = rogueui_skills
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/rogue/skills/Click(location, control, params)
	. = ..()
	var/mob/user = usr
	if(user != get_mob())
		return
	if(LAZYACCESS(params2list(params), RIGHT_CLICK) || !user.mind)
		rogue_hud_not_implemented(user)
		return
	user.mind.print_levels(user)

/// Azure's crafting button; TG's personal crafting component takes it over and opens its menu
/atom/movable/screen/craft/rogue
	icon = ROGUE_HUD_ICON
	icon_state = "craft"
	screen_loc = rogueui_craft
	layer = ROGUE_HUD_LAYER

/atom/movable/screen/craft/rogue/Click(location, control, params)
	. = ..()
	if(!rogue_has_click_listener())
		rogue_hud_not_implemented(usr)

/// Azure's eye button: middle click looks up; eyelids, fixed gaze and looking around are not ported
/atom/movable/screen/rogue/eye
	name = "eye intent"
	icon_state = "eye"
	screen_loc = rogueui_eye
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/rogue/eye/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

/atom/movable/screen/rogue/eye/update_overlays()
	. = ..()
	var/mob/living/carbon/human/owner = get_mob()
	if(!istype(owner))
		return
	var/mutable_appearance/iris = mutable_appearance(icon, "o[icon_state]")
	iris.color = owner.eye_color_left
	. += iris

/atom/movable/screen/rogue/eye/Click(location, control, params)
	. = ..()
	var/mob/living/user = usr
	if(!isliving(user) || user != get_mob())
		return
	if(!LAZYACCESS(params2list(params), MIDDLE_CLICK))
		rogue_hud_not_implemented(user)
		return
	if(user.looking_vertically == UP)
		user.end_look()
	else
		user.look_up()

/// Azure's hourglass over the hands. The middle one shows TG's click cooldown; the per-hand ones wait for the combat port.
/atom/movable/screen/rogue/clickdelay
	name = "click delay"
	icon_state = ""
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ROGUE_HUD_LAYER + 1
	alpha = 230

/// Shows the hourglass for delay deciseconds
/atom/movable/screen/rogue/clickdelay/proc/show_delay(delay)
	if(delay <= 0)
		return
	icon_state = "resiswait"
	addtimer(CALLBACK(src, PROC_REF(clear_delay)), delay, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_DELETE_ME)

/atom/movable/screen/rogue/clickdelay/proc/clear_delay()
	icon_state = ""

/atom/movable/screen/rogue/clickdelay/next_move
	screen_loc = rogueui_clickdelay_mid

/atom/movable/screen/rogue/clickdelay/next_move/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	var/mob/owner = hud_owner?.mymob
	if(owner)
		RegisterSignal(owner, COMSIG_LIVING_CHANGENEXT_MOVE, PROC_REF(on_next_move_changed))

/atom/movable/screen/rogue/clickdelay/next_move/proc/on_next_move_changed(datum/source, next_move)
	SIGNAL_HANDLER
	show_delay(next_move - world.time)

/atom/movable/screen/rogue/clickdelay/left
	screen_loc = rogueui_clickdelay_left

/atom/movable/screen/rogue/clickdelay/right
	screen_loc = rogueui_clickdelay_right

/atom/movable/screen/inventory/hand/rogue
	layer = ROGUE_HUD_LAYER

/// TG's hand overlays name TG-only active states; Azure marks the active hand with "hand_active"
/atom/movable/screen/inventory/hand/rogue/update_overlays()
	. = ..()
	. -= list("lhandactive", "rhandactive")
	if(held_index && held_index == get_mob()?.active_hand_index)
		. += "hand_active"

/atom/movable/screen/inventory/rogue
	layer = ROGUE_HUD_LAYER

/// Azure marks worn items that are damaged or broken
/atom/movable/screen/inventory/rogue/update_icon_state()
	. = ..()
	var/mob/owner = get_mob()
	if(!owner || !slot_id)
		return
	var/obj/item/worn = owner.get_item_by_slot(slot_id)
	if(!worn?.uses_integrity || !worn.max_integrity || worn.get_integrity() >= worn.max_integrity)
		return
	icon_state = "slotdmg"
	if(worn.integrity_failure && worn.get_integrity_percentage() <= worn.integrity_failure)
		icon_state = "slotbroke"

/// TG's equip preview with Azure's colours
/atom/movable/screen/inventory/rogue/add_overlays()
	var/mob/user = get_mob()
	if(!user || !slot_id)
		return
	var/obj/item/holding = user.get_active_held_item()
	if(!holding || user.get_item_by_slot(slot_id))
		return
	var/image/item_overlay = image(holding)
	item_overlay.alpha = 92
	item_overlay.color = holding.mob_can_equip(user, slot_id, disable_warning = TRUE, bypass_equip_delay_self = TRUE) ? "#c5c5c5" : "#fd0279"
	cut_overlay(object_overlay)
	object_overlay = item_overlay
	add_overlay(object_overlay)

/// Azure's body doll on roguehud64.dmi: picks the target zone and shows limb damage and bleeding
/atom/movable/screen/zone_sel/rogue
	icon = ROGUE_HUD_ICON_64
	icon_state = "m-zone_sel"
	screen_loc = rogueui_targetdoll
	layer = ROGUE_HUD_LAYER
	overlay_icon = null
	/// Hover overlays by Azure state name, shared by all rogue dolls
	var/static/list/rogue_hover_cache = list()
	/// Last limb state drawn, so health updates that change nothing skip the overlay rebuild
	var/limb_state_key

/atom/movable/screen/zone_sel/rogue/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		var/mob/living/carbon/user = usr
		if(iscarbon(user) && user == get_mob())
			user.check_self_for_injuries()
		return
	return ..()

/atom/movable/screen/zone_sel/rogue/MouseMove(location, control, params)
	if(isobserver(usr))
		return
	var/list/modifiers = params2list(params)
	var/zone = get_rogue_zone_at(text2num(LAZYACCESS(modifiers, ICON_X)), text2num(LAZYACCESS(modifiers, ICON_Y)))
	var/choice = zone ? "[body_prefix()]_[zone]" : null
	if(hovering == choice)
		return
	vis_contents -= rogue_hover_cache[hovering]
	hovering = choice
	if(!choice)
		return
	var/obj/effect/overlay/zone_sel/rogue/overlay_object = rogue_hover_cache[choice]
	if(!overlay_object)
		overlay_object = new
		overlay_object.icon_state = choice
		rogue_hover_cache[choice] = overlay_object
	vis_contents += overlay_object

/atom/movable/screen/zone_sel/rogue/MouseExited(location, control, params)
	if(!isobserver(usr) && hovering)
		vis_contents -= rogue_hover_cache[hovering]
		hovering = null

/// TG zone for a click on the doll; Azure's finer zones fold into the zones TG targets
/atom/movable/screen/zone_sel/rogue/get_zone_at(icon_x, icon_y)
	var/static/list/rogue_to_tg = list(
		"head" = BODY_ZONE_HEAD,
		"skull" = BODY_ZONE_HEAD,
		"nose" = BODY_ZONE_HEAD,
		"ears" = BODY_ZONE_HEAD,
		"neck" = BODY_ZONE_HEAD,
		"r_eye" = BODY_ZONE_PRECISE_EYES,
		"l_eye" = BODY_ZONE_PRECISE_EYES,
		"mouth" = BODY_ZONE_PRECISE_MOUTH,
		"chest" = BODY_ZONE_CHEST,
		"stomach" = BODY_ZONE_CHEST,
		"groin" = BODY_ZONE_PRECISE_GROIN,
		"r_arm" = BODY_ZONE_R_ARM,
		"r_hand" = BODY_ZONE_R_ARM,
		"l_arm" = BODY_ZONE_L_ARM,
		"l_hand" = BODY_ZONE_L_ARM,
		"r_leg" = BODY_ZONE_R_LEG,
		"r_foot" = BODY_ZONE_R_LEG,
		"l_leg" = BODY_ZONE_L_LEG,
		"l_foot" = BODY_ZONE_L_LEG,
	)
	return rogue_to_tg[get_rogue_zone_at(icon_x, icon_y)]

/// "m" or "f": Azure draws a male and a female doll
/atom/movable/screen/zone_sel/rogue/proc/body_prefix()
	var/mob/owner = get_mob()
	var/body_type = owner?.gender
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		body_type = human_owner.physique
	return body_type == FEMALE ? "f" : "m"

/atom/movable/screen/zone_sel/rogue/update_icon_state()
	icon_state = "[body_prefix()]-zone_sel"
	return ..()

/atom/movable/screen/zone_sel/rogue/update_overlays()
	. = ..()
	var/mob/owner = get_mob()
	if(!owner)
		return
	var/prefix = body_prefix()
	. += limb_overlays(owner, prefix)
	var/static/list/selection_states = list(
		BODY_ZONE_PRECISE_EYES = list("r_eye", "l_eye"),
	)
	for(var/zone in selection_states[owner.zone_selected] || list(owner.zone_selected))
		var/mutable_appearance/selection = mutable_appearance(icon, "[prefix]_[zone]")
		selection.layer = layer + 0.2
		. += selection

/// Azure's limb layers: base limb, damage tint by alpha, bleeding, and dark purple for a missing limb
/atom/movable/screen/zone_sel/rogue/proc/limb_overlays(mob/owner, prefix)
	. = list()
	if(!ishuman(owner) || owner.stat == DEAD)
		return
	var/mob/living/carbon/human/human_owner = owner
	var/no_pain = HAS_TRAIT(human_owner, TRAIT_ANALGESIA)
	for(var/zone in GLOB.all_body_zones)
		var/obj/item/bodypart/limb = human_owner.get_bodypart(zone)
		var/mutable_appearance/limb_layer = mutable_appearance(icon, "[prefix]-[zone]")
		limb_layer.layer = layer + 0.1
		if(!limb)
			limb_layer.color = "#2f002f"
			. += limb_layer
			continue
		var/damage = min(limb.get_damage(), limb.max_damage)
		var/bleeding = limb.cached_bleed_rate > 0
		if(no_pain && (damage || bleeding))
			limb_layer.color = "#78a8ba"
		. += limb_layer
		if(!no_pain && damage)
			var/mutable_appearance/wound_layer = mutable_appearance(icon, "[prefix]w-[zone]")
			wound_layer.layer = layer + 0.11
			wound_layer.alpha = clamp(round(damage / limb.max_damage * 510), 0, 255)
			. += wound_layer
		if(bleeding)
			var/mutable_appearance/bleed_layer = mutable_appearance(icon, "[prefix]-[zone]-bleed")
			bleed_layer.layer = layer + 0.12
			. += bleed_layer

/// Rebuilds the doll only when limb damage, bleeding or limbs changed
/atom/movable/screen/zone_sel/rogue/proc/refresh_limbs()
	var/mob/living/carbon/human/owner = get_mob()
	if(!istype(owner))
		return
	var/list/state = list(owner.stat, body_prefix(), HAS_TRAIT(owner, TRAIT_ANALGESIA))
	for(var/zone in GLOB.all_body_zones)
		var/obj/item/bodypart/limb = owner.get_bodypart(zone)
		state += limb ? "[round(limb.get_damage())]:[limb.cached_bleed_rate > 0]" : "missing"
	var/new_key = jointext(state, "|")
	if(new_key == limb_state_key)
		return
	limb_state_key = new_key
	update_appearance()

/// Azure's pixel map of the 64x64 doll, male and female variants
/atom/movable/screen/zone_sel/rogue/proc/get_rogue_zone_at(icon_x, icon_y)
	if(body_prefix() == "f")
		return get_female_zone_at(icon_x, icon_y)
	switch(icon_y)
		if(1 to 5)
			switch(icon_x)
				if(17 to 28)
					return "r_foot"
				if(38 to 49)
					return "l_foot"
		if(6 to 15)
			switch(icon_x)
				if(20 to 29)
					return "r_leg"
				if(37 to 46)
					return "l_leg"
		if(16 to 21)
			switch(icon_x)
				if(12 to 18)
					return "r_hand"
				if(20 to 29)
					return "r_leg"
				if(37 to 46)
					return "l_leg"
				if(48 to 54)
					return "l_hand"
		if(22 to 24)
			switch(icon_x)
				if(12 to 18)
					return "r_hand"
				if(20 to 29)
					return "r_leg"
				if(30 to 36)
					return "groin"
				if(37 to 46)
					return "l_leg"
				if(48 to 54)
					return "l_hand"
		if(25 to 29)
			switch(icon_x)
				if(16 to 22)
					return "r_arm"
				if(27 to 39)
					return "stomach"
				if(44 to 50)
					return "l_arm"
		if(30 to 38)
			switch(icon_x)
				if(16 to 22)
					return "r_arm"
				if(24 to 42)
					return "chest"
				if(44 to 50)
					return "l_arm"
		if(39)
			if(icon_x in 29 to 37)
				return "neck"
		if(40 to 46)
			if(icon_x in 27 to 39)
				if((icon_y in 40 to 41) && (icon_x in 29 to 37))
					return "neck"
				if((icon_y in 42 to 44) && (icon_x in 32 to 34))
					return "mouth"
				if(icon_y == 46 && (icon_x in 32 to 34))
					return "nose"
				return "head"
		if(47 to 50)
			switch(icon_x)
				if(24 to 26)
					return "ears"
				if(27 to 39)
					if(icon_y in 49 to 50)
						if(icon_x in 30 to 32)
							return "r_eye"
						if(icon_x in 34 to 36)
							return "l_eye"
					if((icon_y in 47 to 48) && (icon_x in 32 to 34))
						return "nose"
					return "head"
				if(40 to 42)
					return "ears"
		if(51 to 55)
			if(icon_x in 27 to 39)
				if(icon_y == 51)
					if(icon_x in 30 to 32)
						return "r_eye"
					if(icon_x in 34 to 36)
						return "l_eye"
				if((icon_y in 53 to 55) && (icon_x in 29 to 37))
					return "skull"
				return "head"

/atom/movable/screen/zone_sel/rogue/proc/get_female_zone_at(icon_x, icon_y)
	switch(icon_y)
		if(1 to 7)
			switch(icon_x)
				if(26 to 32)
					return "r_foot"
				if(34 to 40)
					return "l_foot"
		if(8 to 16)
			switch(icon_x)
				if(24 to 31)
					return "r_leg"
				if(35 to 42)
					return "l_leg"
		if(17 to 20)
			switch(icon_x)
				if(20 to 23)
					return "r_hand"
				if(24 to 31)
					return "r_leg"
				if(35 to 42)
					return "l_leg"
				if(43 to 46)
					return "l_hand"
		if(21)
			switch(icon_x)
				if(20 to 23)
					return "r_hand"
				if(30 to 36)
					return "groin"
				if(43 to 46)
					return "l_hand"
		if(22 to 23)
			switch(icon_x)
				if(20 to 25)
					return "r_arm"
				if(30 to 36)
					return "groin"
				if(41 to 46)
					return "l_arm"
		if(24 to 29)
			switch(icon_x)
				if(20 to 25)
					return "r_arm"
				if(28 to 38)
					return "stomach"
				if(41 to 46)
					return "l_arm"
		if(30 to 37)
			switch(icon_x)
				if(20 to 25)
					return "r_arm"
				if(27 to 39)
					return "chest"
				if(41 to 46)
					return "l_arm"
		if(38 to 39)
			if(icon_x in 30 to 36)
				return "neck"
		if(40 to 43)
			if(icon_x in 28 to 38)
				if(icon_y == 40 && (icon_x in 30 to 36))
					return "neck"
				if((icon_y in 41 to 43) && (icon_x in 32 to 34))
					return "mouth"
				return "head"
		if(44 to 47)
			switch(icon_x)
				if(26 to 27)
					return "ears"
				if(28 to 38)
					if((icon_y in 44 to 46) && (icon_x in 32 to 34))
						return "nose"
					if(icon_y == 47)
						if(icon_x in 30 to 32)
							return "r_eye"
						if(icon_x in 34 to 36)
							return "l_eye"
					return "head"
				if(39 to 40)
					return "ears"
		if(48 to 51)
			if(icon_x in 28 to 38)
				if(icon_y in 48 to 49)
					if(icon_x in 30 to 32)
						return "r_eye"
					if(icon_x in 34 to 36)
						return "l_eye"
				if((icon_y in 50 to 51) && (icon_x in 30 to 36))
					return "skull"
				return "head"
		if(52)
			if(icon_x in 30 to 36)
				return "skull"

/obj/effect/overlay/zone_sel/rogue
	icon = ROGUE_HUD_ICON_64
	plane = HUD_PLANE
	layer = ROGUE_HUD_LAYER + 0.15
