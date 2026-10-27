// Ratwood dye station (roguejobs/tailor/dyer.dm, /obj/machinery/gear_painter): clothing, bags, bedrolls, flower crowns and
// glazed pottery go in, and the station dyes them with one of Ratwood's colors - the cloth itself, and the trim of clothing
// that has one (detail_tag and altdetail_tag of clothing/details.dm) - or washes the dye out. A Dyemaster picks any color.
// Ratwood's browser window is TG's list and color inputs here; the ducal and barony schemes, the swatchbook and the dye brush
// are not ported.

#define DYE_SOUNDS list('modular_redtard/crafting/sound/bubbles1.ogg', 'modular_redtard/crafting/sound/bubbles2.ogg')
#define DYE_ACTION_PRIMARY "Dye it"
#define DYE_ACTION_DETAIL "Dye the trim"
#define DYE_ACTION_ALTDETAIL "Dye the second trim"
#define DYE_ACTION_CLEAR "Wash out the dye"
#define DYE_ACTION_EJECT "Take it out"
#define DYE_CUSTOM "Custom color..."
/// Ratwood: black from the color wheel would hide the sprite, it gives white instead.
#define DYE_FORBIDDEN_COLOR "#000000"
#define DYE_FALLBACK_COLOR "#FFFFFF"

/// Ratwood GLOB.colorlist: the dyes anyone can mix.
GLOBAL_LIST_INIT(rogue_dye_colors, list(
	"Swan White" = "#ffffff",
	"Chalk White" = "#f4ecde",
	"Cream" = "#fffdd0",
	"Light Grey" = "#999999",
	"Dunked in Water" = "#bbbbbb",
	"Mage Grey" = "#6c6c6c",
	"Sow's skin" = "#CE929F",
	"Salmon Pink" = "#FF91A4",
	"Cherry Blossom" = "#FF6699",
	"Knight's Red" = "#933030",
	"Royal Red" = "#8b2323",
	"Red Ochre" = "#913831",
	"Maroon" = "#550000",
	"Scarlet" = "#bb0a1e",
	"Royal Orange" = "#df8405",
	"Madroot Red" = "#AD4545",
	"Marigold Orange" = "#E2A844",
	"Chestnut" = "#613613",
	"Dirt" = "#7c6d5c",
	"Peasant Brown" = "#685542",
	"Russet" = "#7f461b",
	"Yellow Weld" = "#f4c430",
	"Yarrow" = "#f0cb76",
	"Yellow Ochre" = "#cb9d06",
	"Mage Yellow" = "#c1b144",
	"Astrata's Yellow" = "#ffe333",
	"Pale Gold" = "#FFFD8D",
	"Olive" = "#98bf64",
	"Royal Green" = "#264d26",
	"Forest Green" = "#428138",
	"Mage Green" = "#759259",
	"Bog Green" = "#375B48",
	"Seafoam Green" = "#49938B",
	"Royal Teal" = "#249589",
	"Watchman Blue" = "#557d8f",
	"Cornflower Blue" = "#749EE8",
	"Royal Blue" = "#173266",
	"Woad Blue" = "#395480",
	"Mage Blue" = "#4756d8",
	"Periwinkle Blue" = "#8f99fb",
	"Lavender" = "#865c9c",
	"Royal Purple" = "#5E4687",
	"Midnight Violet" = "#402c56",
	"Orchil" = "#66023C",
	"Wine Rouge" = "#752B55",
	"Royal Magenta" = "#962e5c",
	"Blacksteel Grey" = "#404040",
	"Dark Grey" = "#505050",
	"Darkest Night" = "#414143",
))

/obj/machinery/gear_painter
	interaction_flags_atom = NONE
	/// The item in the dye bin (Ratwood inserted).
	var/obj/item/inserted

/obj/machinery/gear_painter/Destroy()
	inserted?.forceMove(drop_location())
	return ..()

/obj/machinery/gear_painter/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == inserted)
		inserted = null

/obj/machinery/gear_painter/examine(mob/user)
	. = ..()
	if(inserted)
		. += span_info("\A [inserted] soaks in it.")
	else
		. += span_info("Put clothing, a bag or glazed pottery in to dye it.")

/// Ratwood allowed_types.
/obj/machinery/gear_painter/proc/can_dye(obj/item/thing)
	var/static/list/dyeable = typecacheof(list(
		/obj/item/clothing,
		/obj/item/storage,
		/obj/item/bedroll,
		/obj/item/flowercrown,
		/obj/item/legwears,
		/obj/item/undies,
		/obj/item/caparison,
		/obj/item/reagent_containers/glass/bottle/clayvase,
		/obj/item/reagent_containers/glass/bottle/clayfancyvase,
		/obj/item/reagent_containers/glass/cup/claycup,
		/obj/item/reagent_containers/glass/bottle/claybottle,
		/obj/item/roguestatue/clay,
		/obj/item/roguestatue/glass,
	))
	return is_type_in_typecache(thing, dyeable)

/obj/machinery/gear_painter/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.combat_mode)
		return ..()
	if(inserted)
		to_chat(user, span_warning("Something is already inside!"))
		return ITEM_INTERACT_BLOCKING
	if(!can_dye(tool))
		to_chat(user, span_warning("[tool] cannot be dyed!"))
		return ITEM_INTERACT_BLOCKING
	if(!user.transferItemToLoc(tool, src))
		to_chat(user, span_warning("[tool] is stuck to your hand!"))
		return ITEM_INTERACT_BLOCKING
	inserted = tool
	user.visible_message(span_notice("[user] inserts [tool] into [src]'s receptable."))
	INVOKE_ASYNC(src, PROC_REF(dye_menu), user)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/gear_painter/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	INVOKE_ASYNC(src, PROC_REF(dye_menu), user)
	return TRUE

/// Ratwood interact(): what to do with the item in the bin, until the dyer is done or takes it out.
/obj/machinery/gear_painter/proc/dye_menu(mob/living/user)
	if(!inserted)
		to_chat(user, span_warning("No item inserted."))
		return
	while(inserted && user.Adjacent(src))
		var/obj/item/clothing/garment = inserted
		var/list/actions = list(DYE_ACTION_PRIMARY)
		if(istype(garment))
			if(garment.detail_tag)
				actions += DYE_ACTION_DETAIL
			if(garment.altdetail_tag)
				actions += DYE_ACTION_ALTDETAIL
		actions += list(DYE_ACTION_CLEAR, DYE_ACTION_EJECT)
		var/action = tgui_input_list(user, "What to do with [inserted]?", "Dye Station", actions)
		if(!action || QDELETED(garment) || garment != inserted || !user.Adjacent(src))
			return
		switch(action)
			if(DYE_ACTION_EJECT)
				eject(user)
				return
			if(DYE_ACTION_CLEAR)
				wash_out()
				continue
		var/dye = pick_color(user, action)
		if(!dye || garment != inserted || !user.Adjacent(src))
			continue
		apply_dye(action, dye)
		// Ratwood: an item with only one color to it comes out once it is dyed.
		if(action == DYE_ACTION_PRIMARY && !(istype(garment) && (garment.detail_tag || garment.altdetail_tag)))
			eject(user)
			return

/// Ratwood select: a preset color, or with Dyemaster any color from the wheel.
/obj/machinery/gear_painter/proc/pick_color(mob/living/user, title)
	var/list/options = list()
	if(HAS_TRAIT(user, TRAIT_DYES))
		options += DYE_CUSTOM
	options += GLOB.rogue_dye_colors
	var/choice = tgui_input_list(user, "Choose your dye:", title, options)
	if(!choice)
		return null
	if(choice != DYE_CUSTOM)
		return GLOB.rogue_dye_colors[choice]
	var/picked = tgui_color_picker(user, "Choose your dye:", title, DYE_FALLBACK_COLOR)
	if(!picked)
		return null
	picked = sanitize_hexcolor(picked, 6, TRUE)
	return picked == DYE_FORBIDDEN_COLOR ? DYE_FALLBACK_COLOR : picked

/obj/machinery/gear_painter/proc/apply_dye(action, dye)
	var/obj/item/clothing/garment = inserted
	switch(action)
		if(DYE_ACTION_PRIMARY)
			inserted.add_atom_colour(dye, FIXED_COLOUR_PRIORITY)
		if(DYE_ACTION_DETAIL)
			garment.detail_color = dye
		if(DYE_ACTION_ALTDETAIL)
			garment.altdetail_color = dye
	inserted.update_appearance()
	playsound(src, pick(DYE_SOUNDS), 50, TRUE)

/// Ratwood clear_primary, clear_detail and clear_altdetail at once.
/obj/machinery/gear_painter/proc/wash_out()
	inserted.remove_atom_colour(FIXED_COLOUR_PRIORITY)
	var/obj/item/clothing/garment = inserted
	if(istype(garment))
		garment.detail_color = initial(garment.detail_color)
		garment.altdetail_color = initial(garment.altdetail_color)
	inserted.update_appearance()
	playsound(src, pick(DYE_SOUNDS), 50, TRUE)

/obj/machinery/gear_painter/proc/eject(mob/living/user)
	var/obj/item/taken = inserted
	taken.forceMove(drop_location())
	if(user?.Adjacent(src))
		user.put_in_hands(taken)

#undef DYE_SOUNDS
#undef DYE_ACTION_PRIMARY
#undef DYE_ACTION_DETAIL
#undef DYE_ACTION_ALTDETAIL
#undef DYE_ACTION_CLEAR
#undef DYE_ACTION_EJECT
#undef DYE_CUSTOM
#undef DYE_FORBIDDEN_COLOR
#undef DYE_FALLBACK_COLOR
