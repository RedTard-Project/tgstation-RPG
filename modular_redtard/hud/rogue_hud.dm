/// Rogue HUD: Azure Peak's layout on TG's HUD datum. Plane masters, palette and screentips stay TG's.
/datum/hud/rogue
	ui_style = ROGUE_HUD_ICON
	/// Keys TG systems (mood, personal crafting) add elements under on their own, and the rogue element that stands in for theirs
	var/static/list/adopted_types = list(
		HUD_MOB_MOOD = /atom/movable/screen/mood/rogue,
		HUD_MOB_CRAFTING_MENU = /atom/movable/screen/craft/rogue,
	)

/// Under an adopted key the caller gets the rogue element, at Azure's place, whatever type and location it asked for
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
	return ..(ispath(new_object) ? rogue_type : new_object, hud_key, HUD_GROUP_STATIC, null, null, update_screen)

/datum/hud/rogue/initialize_screen_objects()
	. = ..()
	add_screen_object(/atom/movable/screen/rogue/placeholder/grain, HUD_ROGUE_GRAIN, group_key = FALSE)
	add_screen_object(/atom/movable/screen/rogue/placeholder/scannies, HUD_ROGUE_SCANNIES, group_key = FALSE)
	add_screen_object(/atom/movable/screen/rogue/panel, HUD_ROGUE_PANEL, HUD_GROUP_STATIC)

/// Azure's hands sit above the belt, not at TG's centre-bottom slots
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

/// Elements in Azure's creation order; inventory boxes come from default_inventory_slots and fold away with the toggle, as on TG
/datum/hud/rogue/human/initialize_screen_objects()
	. = ..()
	add_screen_object(/atom/movable/screen/rogue/placeholder/read, HUD_ROGUE_READ, group_key = FALSE)
	add_screen_object(/atom/movable/screen/rogue/placeholder/readtext, HUD_ROGUE_READ_TEXT_RIGHT, group_key = FALSE)
	add_screen_object(/atom/movable/screen/rogue/placeholder/readtext, HUD_ROGUE_READ_TEXT_LEFT, group_key = FALSE)
	add_screen_object(/atom/movable/screen/rogue/weapon_intents, HUD_ROGUE_WEAPON_INTENTS, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/mood/rogue, HUD_MOB_MOOD, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/rogue/stub/rmb_intent, HUD_ROGUE_RMB_INTENT, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/healths/rogue, HUD_MOB_HEALTH, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/rogue/stub/quad_intents, HUD_ROGUE_QUAD_INTENTS, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/rogue/stub/def_intent, HUD_ROGUE_DEF_INTENT, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/combattoggle/rogue, HUD_MOB_INTENTS, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/rogue/give, HUD_ROGUE_GIVE, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/rogue/heatstam_overlay, HUD_ROGUE_HEATSTAM_OVERLAY, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/rogue/placeholder/fov, HUD_ROGUE_FOV, group_key = FALSE)
	add_screen_object(/atom/movable/screen/rogue/placeholder/fov_blocker, HUD_ROGUE_FOV_BLOCKER, group_key = FALSE)
	add_screen_object(/atom/movable/screen/rogue/clickdelay/left, HUD_ROGUE_CLICKDELAY_LEFT, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/rogue/clickdelay/right, HUD_ROGUE_CLICKDELAY_RIGHT, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/rogue/clickdelay/next_move, HUD_ROGUE_CLICKDELAY_MID, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/rogue/stub/defdelay, HUD_ROGUE_DEFDELAY, HUD_GROUP_STATIC)

	build_hand_slots()

	for(var/atom/movable/screen/rogue/stub/slot/slot_type as anything in subtypesof(/atom/movable/screen/rogue/stub/slot))
		add_screen_object(slot_type, HUD_ROGUE_SLOT_STUB(initial(slot_type.slot_name)), HUD_GROUP_TOGGLEABLE_INVENTORY)
	add_screen_object(/atom/movable/screen/human/toggle/rogue, HUD_HUMAN_TOGGLE_INVENTORY, HUD_GROUP_STATIC)

	add_screen_object(/atom/movable/screen/drop/rogue, HUD_MOB_DROP, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/throw_catch/rogue, HUD_MOB_THROW, HUD_GROUP_HOTKEYS)
	add_screen_object(/atom/movable/screen/rogue/stand_up, HUD_ROGUE_STAND_UP, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/rest/rogue, HUD_MOB_REST, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/rogue/skills, HUD_ROGUE_SKILLS, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/craft/rogue, HUD_MOB_CRAFTING_MENU, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/rogue/stub/sneak, HUD_ROGUE_SNEAK, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/mov_intent/rogue, HUD_MOB_MOVE_INTENT, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/rogue/eye, HUD_ROGUE_EYE, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/rogue/placeholder/advsetup, HUD_ROGUE_ADVSETUP, group_key = FALSE)
	add_screen_object(/atom/movable/screen/zone_sel/rogue, HUD_MOB_ZONE_SELECTOR, HUD_GROUP_STATIC)

	add_screen_object(/atom/movable/screen/stamina/rogue, HUD_MOB_STAMINA, HUD_GROUP_INFO)
	add_screen_object(/atom/movable/screen/rogue/stub/energy, HUD_ROGUE_ENERGY, HUD_GROUP_INFO)
	add_screen_object(/atom/movable/screen/rogue/stub/feint, HUD_ROGUE_FEINT, HUD_GROUP_INFO)

/// Azure keeps only the hands, the info bars and the weapon intents (moved to the corner) on the reduced HUD
/datum/hud/rogue/human/show_hud(version = 0, mob/viewmob)
	var/atom/movable/screen/intents = screen_objects[HUD_ROGUE_WEAPON_INTENTS]
	intents?.screen_loc = initial(intents.screen_loc)
	. = ..()
	if(!. || hud_version != HUD_STYLE_REDUCED || !intents)
		return
	var/mob/screenmob = viewmob || mymob
	intents.screen_loc = rogueui_intents_alt
	screenmob.client.screen += intents

/// TG's human slot locking, applied to the rogue boxes
/datum/hud/rogue/human/update_locked_slots()
	var/mob/living/carbon/human/human_mob = mymob
	if(!istype(human_mob))
		return
	var/blocked_slots = human_mob.dna?.species?.no_equip_flags
	if((isnull(human_mob.w_uniform) || !(human_mob.w_uniform.item_flags & IN_INVENTORY)) && !HAS_TRAIT(human_mob, TRAIT_NO_JUMPSUIT))
		var/obj/item/bodypart/chest = human_mob.get_bodypart(BODY_ZONE_CHEST)
		if(isnull(chest) || IS_ORGANIC_LIMB(chest))
			blocked_slots |= ITEM_SLOT_ID|ITEM_SLOT_BELT
		var/obj/item/bodypart/left_leg = human_mob.get_bodypart(BODY_ZONE_L_LEG)
		if(isnull(left_leg) || IS_ORGANIC_LIMB(left_leg))
			blocked_slots |= ITEM_SLOT_LPOCKET
		var/obj/item/bodypart/right_leg = human_mob.get_bodypart(BODY_ZONE_R_LEG)
		if(isnull(right_leg) || IS_ORGANIC_LIMB(right_leg))
			blocked_slots |= ITEM_SLOT_RPOCKET
	if(human_mob.num_hands <= 0)
		blocked_slots |= ITEM_SLOT_GLOVES
	if(human_mob.num_legs < 2)
		blocked_slots |= ITEM_SLOT_FEET
	if(isnull(human_mob.get_bodypart(BODY_ZONE_HEAD)))
		blocked_slots |= ITEM_SLOT_HEAD|ITEM_SLOT_MASK

	for(var/slot_key in screen_objects)
		var/atom/movable/screen/inventory/inv = screen_objects[slot_key]
		if(!istype(inv) || !inv.slot_id)
			continue
		inv.alpha = (blocked_slots & inv.slot_id) ? 128 : initial(inv.alpha)

/// Azure's inventory boxes for the slots TG has; the rest are stubs in rogue_hud_stubs.dm
/datum/inventory_slot/rogue
	abstract_type = /datum/inventory_slot/rogue
	icon_full = "genslot"
	screen_type = /atom/movable/screen/inventory/rogue
	screen_group = HUD_GROUP_TOGGLEABLE_INVENTORY

/datum/inventory_slot/rogue/ring
	name = "ring"
	icon_state = "ring"
	screen_loc = rogueui_ringr
	slot_id = ITEM_SLOT_ID

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
	slot_id = ITEM_SLOT_ICLOTHING

/datum/inventory_slot/rogue/armor
	name = "armor"
	icon_state = "armor"
	screen_loc = rogueui_armor
	slot_id = ITEM_SLOT_OCLOTHING
