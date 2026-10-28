/// Ratwood's way to a player book (modules/paperwork/paper.dm, rogueitems/books.dm): write on paper with a feather, lay two
/// written sheets together into a manuscript, add sheets up to eight, and bind it with a book crafting kit, naming the
/// title, section and cover. The paper is TG's, so its writing is TG's markdown; the manuscript keeps the sheets
/// themselves until the binding.

/// Ratwood's quill: a feather writes on paper like a pen.
/obj/item/natural/feather/get_writing_implement_details()
	return list(
		interaction_mode = MODE_WRITING,
		font = ROGUE_QUILL_FONT,
		color = ROGUE_QUILL_INK,
		use_bold = FALSE,
	)

/// Has writing on it (Ratwood info): only such sheets go into a manuscript.
/obj/item/paper/proc/rogue_is_written()
	return LAZYLEN(raw_text_inputs) > 0

/// The sheet's writing as HTML, as TG's book binder takes it (book_info set_content_using_paper()).
/obj/item/paper/proc/rogue_page_text()
	var/list/lines = list()
	for(var/datum/paper_input/text_input as anything in raw_text_inputs)
		lines += text_input.to_raw_html()
	return jointext(lines, "\n\n")

/// On medieval maps a written sheet laid on another starts a manuscript, and a manuscript takes the sheet it is used on.
/obj/item/paper/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!rogue_library_enabled() || !rogue_is_written())
		return ..()
	if(istype(tool, /obj/item/manuscript))
		var/obj/item/manuscript/held_manuscript = tool
		held_manuscript.rogue_add_page(user, src)
		return ITEM_INTERACT_SUCCESS
	if(!istype(tool, /obj/item/paper))
		return ..()
	var/obj/item/paper/second_page = tool
	if(!second_page.rogue_is_written())
		return ..()
	var/obj/item/manuscript/manuscript = new(drop_location())
	manuscript.rogue_take_page(src)
	manuscript.rogue_take_page(second_page)
	manuscript.add_fingerprint(user)
	user.put_in_hands(manuscript)
	return ITEM_INTERACT_SUCCESS

/// Moves an item into a container, out of whatever hand or pocket holds it.
/proc/rogue_library_take(obj/item/thing, atom/destination)
	if(ismob(thing.loc))
		var/mob/holder = thing.loc
		return holder.transferItemToLoc(thing, destination, force = TRUE)
	thing.forceMove(destination)
	return TRUE

/// Ratwood's manuscript: written sheets on the way to a book. The sheets lie inside it, in order.
/obj/item/manuscript
	name = "2 page manuscript"
	desc = "A 2 page written piece aspiring to one dae become a book."
	icon = 'modular_redtard/rockhill/icons/roguetown/items/misc.dmi'
	icon_state = "manuscript"
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE
	set_dir_on_move = FALSE
	lefthand_file = 'modular_redtard/rockhill/icons/baked/roguetown/items/misc_lefthand.dmi'
	righthand_file = 'modular_redtard/rockhill/icons/baked/roguetown/items/misc_righthand.dmi'
	inhand_icon_state = "paper"
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_baked_inhand = TRUE
	/// The sheets, first to last.
	var/list/obj/item/paper/pages = list()

/obj/item/manuscript/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone in pages)
		pages -= gone
		if(!QDELETED(src))
			rogue_update_pages()

/obj/item/manuscript/examine(mob/user)
	. = ..()
	. += span_info("It has [length(pages)] pages. Use paper to add more. Finish the book with a book crafting kit, then choose its title, category and cover before archiving it.")
	. += span_info("Right-click it in hand to take the last page off.")

/obj/item/manuscript/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/book_crafting_kit))
		rogue_bind(user, tool)
		return ITEM_INTERACT_SUCCESS
	if(istype(tool, /obj/item/paper))
		rogue_add_page(user, tool)
		return ITEM_INTERACT_SUCCESS
	return NONE

/obj/item/manuscript/attack_self(mob/user, modifiers)
	if(user.is_blind() || !user.can_read(src))
		return TRUE
	return ..()

/obj/item/manuscript/attack_self_secondary(mob/user, modifiers)
	. = ..()
	if(.)
		return
	rogue_take_off_page(user)
	return TRUE

/obj/item/manuscript/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MarkdownViewer", name)
		ui.open()
		playsound(src, ROGUE_BOOK_PAGE_SOUND, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

/obj/item/manuscript/ui_static_data(mob/user)
	return list(
		"title" = name,
		"author" = "",
		"content" = rogue_text(),
	)

/obj/item/manuscript/proc/rogue_text()
	var/list/texts = list()
	for(var/obj/item/paper/page as anything in pages)
		texts += page.rogue_page_text()
	return jointext(texts, "\n\n")

/obj/item/manuscript/proc/rogue_take_page(obj/item/paper/page)
	if(!rogue_library_take(page, src))
		return
	pages += page
	rogue_update_pages()

/// Ratwood manuscript attackby(): a written sheet goes on top, up to the most pages.
/obj/item/manuscript/proc/rogue_add_page(mob/living/user, obj/item/paper/page)
	if(!page.rogue_is_written())
		to_chat(user, span_warning("The paper needs to contain text to be added to a manuscript!"))
		return
	if(length(pages) >= ROGUE_MANUSCRIPT_PAGES)
		to_chat(user, span_warning("The manuscript pile cannot surpass [ROGUE_MANUSCRIPT_PAGES] pages!"))
		return
	rogue_take_page(page)
	playsound(src, ROGUE_BOOK_PAGE_SOUND, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

/// Ratwood manuscript attack_hand() in hand: the last sheet comes off; with one left the manuscript falls apart.
/obj/item/manuscript/proc/rogue_take_off_page(mob/user)
	if(!length(pages))
		return
	var/obj/item/paper/page = pages[length(pages)]
	page.forceMove(drop_location())
	user.put_in_hands(page)
	if(length(pages) > 1)
		return
	var/list/obj/item/paper/rest = pages.Copy()
	for(var/obj/item/paper/last_page as anything in rest)
		last_page.forceMove(drop_location())
	qdel(src)
	for(var/obj/item/paper/last_page as anything in rest)
		user.put_in_hands(last_page)

/obj/item/manuscript/proc/rogue_update_pages()
	var/count = length(pages)
	name = "[count] page manuscript"
	desc = "A [count] page written piece aspiring to one dae become a book."
	// Ratwood shows the size of the pile by the sprite's direction.
	var/static/list/dir_by_pages = list(SOUTH, SOUTH, NORTH, EAST, WEST, SOUTHEAST, SOUTHWEST, NORTHWEST)
	setDir(dir_by_pages[clamp(count, 1, length(dir_by_pages))])
	update_static_data_for_all_viewers()

/// Ratwood book crafting kit on a manuscript: asks for the title, section and cover, then binds the book in place of
/// the manuscript and the kit.
/obj/item/manuscript/proc/rogue_bind(mob/living/user, obj/item/book_crafting_kit/kit)
	if(!length(pages))
		to_chat(user, span_warning("Write the manuscript before binding it."))
		return
	var/title = tgui_input_text(user, "What title do you want to give the book? (max [MAX_NAME_LEN] characters)", "Title", max_length = MAX_NAME_LEN)
	if(!title)
		return
	title = capitalize(trim(title))
	if(!rogue_book_file_name(title))
		to_chat(user, span_warning("Choose a nonempty title of at most [MAX_NAME_LEN] characters that does not begin with an underscore."))
		return
	var/category = tgui_input_list(user, "Choose a category to file the book under", "Book Category", GLOB.rogue_book_categories)
	if(!category)
		return
	var/cover_name = tgui_input_list(user, "Choose a book style", "Book Style", GLOB.rogue_book_covers)
	if(!cover_name)
		return
	if(QDELETED(src) || QDELETED(kit) || !length(pages) || !user.can_perform_action(src) || !user.Adjacent(kit))
		return
	var/obj/item/book/rogue/playerbook/book = new(drop_location(), null, TRUE)
	book.rogue_bind(user, title, category, GLOB.rogue_book_covers[cover_name], rogue_text())
	book.add_fingerprint(user)
	qdel(kit)
	qdel(src)
	user.put_in_hands(book)
	var/who = "[rogue_book_display_text(user.ckey)]([book.player_book_author])"
	message_admins("[who] has bound the player book: [book.name]")
	log_game("BOOK: [key_name(user)] bound the book [html_decode(book.player_book_title)].")

/// The kit used on a manuscript binds it as well.
/obj/item/book_crafting_kit/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/manuscript))
		return ..()
	var/obj/item/manuscript/manuscript = tool
	manuscript.rogue_bind(user, src)
	return ITEM_INTERACT_SUCCESS

/// Ratwood's parchment, the plain sheet of medieval maps and crafts (the port rebases Ratwood's /obj/item/paper here, TG's
/// stays TG's): written on, it shows its ink.
/obj/item/paper/parchment
	show_written_words = FALSE

/obj/item/paper/parchment/update_icon_state()
	. = ..()
	if(rogue_is_written())
		icon_state = "paperwrite"
