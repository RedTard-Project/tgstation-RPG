/datum/hud/rogue
	ui_style = ROGUE_HUD_ICON
	var/list/folded_groups = list(HUD_GROUP_ROGUE_RMB)
	var/static/list/adopted_types = list(
		HUD_MOB_MOOD = /atom/movable/screen/mood/rogue,
		HUD_MOB_CRAFTING_MENU = /atom/movable/screen/craft/rogue,
	)

/datum/hud/rogue/add_screen_object(atom/movable/screen/new_object, hud_key, group_key = HUD_GROUP_STATIC, ui_icon, ui_loc, update_screen = FALSE)
	var/rogue_type = hud_key && adopted_types[hud_key]
	if(!rogue_type)
		return ..()
	if(isatom(new_object) && !istype(new_object, rogue_type))
		qdel(new_object)
		new_object = rogue_type
	var/atom/movable/screen/existing = screen_objects[hud_key]
	if(existing)
		return existing
	return ..(ispath(new_object) ? rogue_type : new_object, hud_key, HUD_GROUP_ROGUE_PANEL, null, null, update_screen)

/datum/hud/rogue/initialize_screen_objects()
	screen_groups.len = max(length(screen_groups), HUD_GROUP_ROGUE_RMB)
	. = ..()
	add_screen_object(/atom/movable/screen/rogue/placeholder/grain, HUD_ROGUE_GRAIN, group_key = FALSE)
	add_screen_object(/atom/movable/screen/rogue/placeholder/scannies, HUD_ROGUE_SCANNIES, group_key = FALSE)
	add_screen_object(/atom/movable/screen/rogue/panel_toggle, HUD_ROGUE_PANEL_TOGGLE, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/rogue/panel_strip, HUD_ROGUE_PANEL_STRIP, HUD_GROUP_ROGUE_PANEL)

/datum/hud/rogue/proc/group_shown(group_key)
	return !(group_key in folded_groups)

/datum/hud/rogue/proc/watched_mob(mob/viewer)
	if(isobserver(viewer) && ishuman(viewer.client?.eye) && viewer.client.eye != viewer)
		return viewer.client.eye
	return viewer

/datum/hud/rogue/proc/toggle_group(group_key, mob/viewer)
	var/mob/watched = watched_mob(viewer)
	var/datum/hud/rogue/watched_hud = watched.hud_used
	var/list/pieces = istype(watched_hud) ? watched_hud.screen_groups[group_key] : null
	var/shown = !group_shown(group_key)
	folded_groups ^= list(group_key)
	if(viewer.client && pieces)
		if(shown)
			viewer.client.screen |= pieces
		else
			viewer.client.screen -= pieces
	var/atom/movable/screen/toggle = screen_objects[group_toggle_key(group_key)]
	toggle?.update_appearance()
	return shown

/datum/hud/rogue/proc/group_toggle_key(group_key)
	switch(group_key)
		if(HUD_GROUP_ROGUE_DOLL)
			return HUD_ROGUE_DOLL_TOGGLE
		if(HUD_GROUP_ROGUE_RMB)
			return HUD_ROGUE_RMB_BUTTON
	return HUD_ROGUE_PANEL_TOGGLE

/datum/hud/rogue/proc/toggle_inventory(mob/viewer)
	var/mob/watched = watched_mob(viewer)
	var/list/inventory = watched.hud_used?.screen_groups[HUD_GROUP_TOGGLEABLE_INVENTORY]
	inventory_shown = !inventory_shown
	if(viewer.client && inventory)
		if(inventory_shown)
			viewer.client.screen |= inventory
		else
			viewer.client.screen -= inventory
	screen_objects[HUD_HUMAN_TOGGLE_INVENTORY]?.update_appearance()
	return inventory_shown

/datum/hud/rogue/get_ui_alert_placement(index)
	if(index > 5)
		return ""
	var/offset = (6 - index) * ICON_SIZE_Y + 29 - index * 2 - rogueui_alert_drop
	var/rows = round(offset / ICON_SIZE_Y)
	return "EAST-1:28,CENTER[rows < 0 ? "" : "+"][rows]:[offset - rows * ICON_SIZE_Y]"

/datum/hud/rogue/show_hud(version = 0, mob/viewmob)
	. = ..()
	if(!. || hud_version != HUD_STYLE_STANDARD)
		return
	var/mob/screenmob = viewmob || mymob
	var/datum/hud/rogue/viewer_hud = screenmob.hud_used
	for(var/group_key in list(HUD_GROUP_ROGUE_PANEL, HUD_GROUP_ROGUE_DOLL, HUD_GROUP_ROGUE_RMB))
		if(istype(viewer_hud) ? viewer_hud.group_shown(group_key) : group_key != HUD_GROUP_ROGUE_RMB)
			screenmob.client.screen += screen_groups[group_key]

/datum/hud/rogue/build_hand_slots(update_hud = FALSE)
	for(var/atom/movable/screen/inventory/hand/hand in screen_groups[HUD_GROUP_STATIC])
		remove_screen_object(hand, FALSE)

	for(var/i in 1 to mymob.get_num_hand_slots())
		var/atom/movable/screen/inventory/hand/hand_box = add_screen_object(/atom/movable/screen/inventory/hand/rogue, HUD_KEY_HAND_SLOT(i), HUD_GROUP_STATIC, ui_style, rogueui_hand_position(i))
		hand_box.name = mymob.get_held_index_name(i)
		hand_box.icon_state = "hand_[mymob.held_index_to_dir(i)]"
		hand_box.held_index = i
		hand_box.update_appearance()

	if(update_hud && mymob?.hud_used == src)
		show_hud(hud_version)

/datum/hud/rogue/human
	default_inventory_slots = /datum/inventory_slot/rogue

/datum/hud/rogue/human/initialize_screen_objects()
	. = ..()
	add_screen_object(/atom/movable/screen/rogue/placeholder/read, HUD_ROGUE_READ, group_key = FALSE)
	add_screen_object(/atom/movable/screen/rogue/placeholder/readtext, HUD_ROGUE_READ_TEXT_RIGHT, group_key = FALSE)
	add_screen_object(/atom/movable/screen/rogue/placeholder/readtext, HUD_ROGUE_READ_TEXT_LEFT, group_key = FALSE)
	add_screen_object(/atom/movable/screen/rogue/weapon_intents, HUD_ROGUE_WEAPON_INTENTS, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/mood/rogue, HUD_MOB_MOOD, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/rogue/rmb_intent, HUD_ROGUE_RMB_BUTTON, HUD_GROUP_STATIC)
	var/rmb_index = 0
	for(var/intent_type in GLOB.rogue_rmb_intents)
		rmb_index++
		var/atom/movable/screen/rogue/rmb_choice/choice = add_screen_object(/atom/movable/screen/rogue/rmb_choice, HUD_ROGUE_RMB_SLOT(rmb_index), HUD_GROUP_ROGUE_RMB, ui_loc = rmb_screen_loc(rmb_index))
		choice.set_intent(intent_type)
	add_screen_object(/atom/movable/screen/healths/rogue, HUD_MOB_HEALTH, HUD_GROUP_ROGUE_PANEL)
	add_screen_object(/atom/movable/screen/rogue/quad_intents, HUD_ROGUE_QUAD_INTENTS, HUD_GROUP_ROGUE_PANEL)
	add_screen_object(/atom/movable/screen/rogue/def_intent, HUD_ROGUE_DEF_INTENT, HUD_GROUP_ROGUE_PANEL)
	add_screen_object(/atom/movable/screen/combattoggle/rogue, HUD_MOB_INTENTS, HUD_GROUP_ROGUE_PANEL)
	add_screen_object(/atom/movable/screen/rogue/give, HUD_ROGUE_GIVE, HUD_GROUP_ROGUE_PANEL)
	add_screen_object(/atom/movable/screen/rogue/heatstam_overlay, HUD_ROGUE_HEATSTAM_OVERLAY, HUD_GROUP_ROGUE_PANEL)
	add_screen_object(/atom/movable/screen/rogue/placeholder/fov, HUD_ROGUE_FOV, group_key = FALSE)
	add_screen_object(/atom/movable/screen/rogue/placeholder/fov_blocker, HUD_ROGUE_FOV_BLOCKER, group_key = FALSE)
	add_screen_object(/atom/movable/screen/rogue/clickdelay/left, HUD_ROGUE_CLICKDELAY_LEFT, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/rogue/clickdelay/right, HUD_ROGUE_CLICKDELAY_RIGHT, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/rogue/clickdelay/next_move, HUD_ROGUE_CLICKDELAY_MID, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/rogue/defdelay, HUD_ROGUE_DEFDELAY, HUD_GROUP_ROGUE_PANEL)

	build_hand_slots()

	add_screen_object(/atom/movable/screen/human/toggle/rogue, HUD_HUMAN_TOGGLE_INVENTORY, HUD_GROUP_STATIC)

	add_screen_object(/atom/movable/screen/drop/rogue, HUD_MOB_DROP, HUD_GROUP_ROGUE_PANEL)
	add_screen_object(/atom/movable/screen/throw_catch/rogue, HUD_MOB_THROW, HUD_GROUP_ROGUE_PANEL)
	add_screen_object(/atom/movable/screen/rogue/stand_up, HUD_ROGUE_STAND_UP, HUD_GROUP_ROGUE_PANEL)
	add_screen_object(/atom/movable/screen/rest/rogue, HUD_MOB_REST, HUD_GROUP_ROGUE_PANEL)
	add_screen_object(/atom/movable/screen/rogue/skills, HUD_ROGUE_SKILLS, HUD_GROUP_ROGUE_PANEL)
	add_screen_object(/atom/movable/screen/craft/rogue, HUD_MOB_CRAFTING_MENU, HUD_GROUP_ROGUE_PANEL)
	add_screen_object(/atom/movable/screen/rogue/build, HUD_ROGUE_BUILD, HUD_GROUP_ROGUE_PANEL)
	add_screen_object(/atom/movable/screen/rogue/sneak, HUD_ROGUE_SNEAK, HUD_GROUP_ROGUE_PANEL)
	add_screen_object(/atom/movable/screen/mov_intent/rogue, HUD_MOB_MOVE_INTENT, HUD_GROUP_ROGUE_PANEL)
	add_screen_object(/atom/movable/screen/rogue/eye, HUD_ROGUE_EYE, HUD_GROUP_ROGUE_PANEL)
	add_screen_object(/atom/movable/screen/rogue/advsetup, HUD_ROGUE_ADVSETUP, group_key = FALSE)
	add_screen_object(/atom/movable/screen/rogue/doll_back, HUD_ROGUE_DOLL_BACK, HUD_GROUP_ROGUE_DOLL)
	add_screen_object(/atom/movable/screen/zone_sel/rogue, HUD_MOB_ZONE_SELECTOR, HUD_GROUP_ROGUE_DOLL)
	add_screen_object(/atom/movable/screen/rogue/panel_toggle/doll, HUD_ROGUE_DOLL_TOGGLE, HUD_GROUP_STATIC)

	add_screen_object(/atom/movable/screen/stamina/rogue, HUD_MOB_STAMINA, HUD_GROUP_ROGUE_PANEL)
	add_screen_object(/atom/movable/screen/rogue/energy, HUD_ROGUE_ENERGY, HUD_GROUP_ROGUE_PANEL)
	add_screen_object(/atom/movable/screen/rogue/feint, HUD_ROGUE_FEINT, HUD_GROUP_ROGUE_PANEL)

/datum/hud/rogue/human/proc/rmb_screen_loc(index)
	return "CENTER+1:20,SOUTH:[rogueui_rmb_menu_base + (index - 1) * rogueui_rmb_menu_step]"

/datum/hud/rogue/human/show_hud(version = 0, mob/viewmob)
	. = ..()
	if(!.)
		return
	var/mob/screenmob = viewmob || mymob
	var/atom/movable/screen/rogue/advsetup/setup = screen_objects[HUD_ROGUE_ADVSETUP]
	if(setup?.showing && hud_version != HUD_STYLE_NOHUD)
		screenmob.client.screen |= setup
	var/atom/movable/screen/intents = screen_objects[HUD_ROGUE_WEAPON_INTENTS]
	if(hud_version == HUD_STYLE_REDUCED && intents)
		screenmob.client.screen |= intents

/datum/hud/rogue/human/update_locked_slots()
	var/mob/living/carbon/human/human_mob = mymob
	if(!istype(human_mob))
		return
	var/blocked_slots = human_mob.dna?.species?.no_equip_flags
	if((isnull(human_mob.w_uniform) || !(human_mob.w_uniform.item_flags & IN_INVENTORY)) && !HAS_TRAIT(human_mob, TRAIT_NO_JUMPSUIT))
		var/obj/item/bodypart/chest = human_mob.get_bodypart(BODY_ZONE_CHEST)
		if(isnull(chest) || IS_ORGANIC_LIMB(chest))
			blocked_slots |= ITEM_SLOT_ID
	if(isnull(human_mob.belt) || !(human_mob.belt.item_flags & IN_INVENTORY))
		blocked_slots |= ITEM_SLOT_POCKETS
	if(human_mob.num_hands <= 0)
		blocked_slots |= ITEM_SLOT_GLOVES
	if(human_mob.num_legs < 2)
		blocked_slots |= ITEM_SLOT_FEET
	if(isnull(human_mob.get_bodypart(BODY_ZONE_HEAD)))
		blocked_slots |= ITEM_SLOT_HEAD|ITEM_SLOT_MASK|ITEM_SLOT_ROGUE_MOUTH

	for(var/slot_key in screen_objects)
		var/atom/movable/screen/inventory/inv = screen_objects[slot_key]
		if(!istype(inv) || !inv.slot_id)
			continue
		inv.alpha = (blocked_slots & inv.slot_id) ? 128 : initial(inv.alpha)

/datum/inventory_slot/rogue
	abstract_type = /datum/inventory_slot/rogue
	icon_full = "genslot"
	screen_type = /atom/movable/screen/inventory/rogue
	screen_group = HUD_GROUP_TOGGLEABLE_INVENTORY

/datum/inventory_slot/rogue/ring
	name = "ring"
	slot_id = ITEM_SLOT_ROGUE_RING
	icon_state = "ring"
	screen_type = /atom/movable/screen/inventory/rogue/indexed/ring

/datum/inventory_slot/rogue/ring/create_element(datum/hud/hud)
	for(var/index in 1 to ROGUE_RING_SLOTS)
		var/atom/movable/screen/inventory/rogue/indexed/cell = hud.add_screen_object(screen_type, HUD_ROGUE_RING_SLOT(index), screen_group, hud.ui_style, rogueui_ring_position(index))
		cell.name = HUD_ROGUE_RING_SLOT(index)
		cell.icon_state = icon_state
		cell.icon_full = icon_full
		cell.slot_id = slot_id
		cell.slot_index = index

/datum/inventory_slot/rogue/ring/get_slot_item(mob/owner, ring_index = 1)
	var/mob/living/carbon/human/wearer = owner
	return istype(wearer) ? wearer.get_rogue_ring(ring_index) : null

/datum/inventory_slot/rogue/ring/get_screen_slot(datum/hud/hud, ring_index = 1)
	return hud.screen_objects[HUD_ROGUE_RING_SLOT(ring_index)]

/datum/inventory_slot/rogue/ring/update_inventory_slot(datum/hud/hud, mob/owner, ring_index = null)
	if(isnull(ring_index))
		for(var/index in 1 to ROGUE_RING_SLOTS)
			update_inventory_slot(hud, owner, index)
		return
	var/atom/movable/screen/inventory/slot = get_screen_slot(hud, ring_index)
	if(slot)
		update_slot_icon_contents(slot, get_slot_item(owner, ring_index))

/datum/inventory_slot/rogue/mouth
	name = "mouth"
	slot_id = ITEM_SLOT_ROGUE_MOUTH
	icon_state = "mouth"
	screen_loc = rogueui_mouth

/datum/inventory_slot/rogue/wrists
	name = "wrists"
	icon_state = "wrist"
	screen_loc = rogueui_wrists
	slot_id = ITEM_SLOT_ROGUE_WRISTS

/datum/inventory_slot/rogue/cloak
	name = "cloak"
	icon_state = "cloak"
	screen_loc = rogueui_cloak
	slot_id = ITEM_SLOT_ROGUE_CLOAK

/datum/inventory_slot/rogue/pants
	name = "trou"
	icon_state = "pants"
	screen_loc = rogueui_pants
	slot_id = ITEM_SLOT_ICLOTHING

/datum/inventory_slot/rogue/mask
	name = "mask"
	icon_state = "mask"
	screen_loc = rogueui_mask
	slot_id = ITEM_SLOT_MASK

/datum/inventory_slot/rogue/neck
	name = "neck"
	icon_state = "neck"
	screen_loc = rogueui_neck
	slot_id = ITEM_SLOT_NECK

/datum/inventory_slot/rogue/backl
	name = "backl"
	icon_state = "back"
	screen_loc = rogueui_backl
	slot_id = ITEM_SLOT_BACK

/datum/inventory_slot/rogue/backl/create_element(datum/hud/hud)
	. = ..()
	var/atom/movable/screen/inventory/rogue/indexed/cell = hud.add_screen_object(/atom/movable/screen/inventory/rogue/indexed, HUD_ROGUE_BACKR, screen_group, hud.ui_style, rogueui_backr)
	cell.name = HUD_ROGUE_BACKR
	cell.icon_state = icon_state
	cell.icon_full = icon_full
	cell.slot_id = slot_id
	cell.slot_index = ROGUE_BACK_RIGHT

/datum/inventory_slot/rogue/backl/get_slot_item(mob/owner, back_index = 1)
	var/mob/living/carbon/human/wearer = owner
	if(!istype(wearer))
		return ..()
	return wearer.get_rogue_indexed(ITEM_SLOT_BACK, back_index)

/datum/inventory_slot/rogue/backl/get_screen_slot(datum/hud/hud, back_index = 1)
	if(back_index == ROGUE_BACK_RIGHT)
		return hud.screen_objects[HUD_ROGUE_BACKR]
	return ..()

/datum/inventory_slot/rogue/backl/update_inventory_slot(datum/hud/hud, mob/owner, back_index = null)
	if(isnull(back_index))
		update_inventory_slot(hud, owner, 1)
		update_inventory_slot(hud, owner, ROGUE_BACK_RIGHT)
		return
	var/atom/movable/screen/inventory/slot = get_screen_slot(hud, back_index)
	if(slot)
		update_slot_icon_contents(slot, get_slot_item(owner, back_index))

/datum/inventory_slot/rogue/gloves
	name = "gloves"
	icon_state = "gloves"
	screen_loc = rogueui_gloves
	slot_id = ITEM_SLOT_GLOVES

/datum/inventory_slot/rogue/head
	name = "head"
	icon_state = "head"
	screen_loc = rogueui_head
	slot_id = ITEM_SLOT_HEAD

/datum/inventory_slot/rogue/shoes
	name = "shoes"
	icon_state = "shoes"
	screen_loc = rogueui_shoes
	slot_id = ITEM_SLOT_FEET

/datum/inventory_slot/rogue/belt
	name = "belt"
	icon_state = "belt"
	screen_loc = rogueui_belt
	slot_id = ITEM_SLOT_BELT

/datum/inventory_slot/rogue/hip_r
	name = "hip r"
	icon_state = "hip"
	screen_loc = rogueui_beltr
	slot_id = ITEM_SLOT_RPOCKET

/datum/inventory_slot/rogue/hip_l
	name = "hip l"
	icon_state = "hip"
	screen_loc = rogueui_beltl
	slot_id = ITEM_SLOT_LPOCKET

/datum/inventory_slot/rogue/shirt
	name = "shirt"
	icon_state = "shirt"
	screen_loc = rogueui_shirt
	slot_id = ITEM_SLOT_ROGUE_SHIRT

/datum/inventory_slot/rogue/armor
	name = "armor"
	icon_state = "armor"
	screen_loc = rogueui_armor
	slot_id = ITEM_SLOT_OCLOTHING
