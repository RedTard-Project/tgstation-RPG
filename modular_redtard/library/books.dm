/// Ratwood's books (code/game/objects/items/rogueitems/books.dm): the porter's stubs under /obj/item/rockhill get Ratwood's
/// opening and reading. A book is opened by using it and read by using it open (TG's MarkdownViewer, which sanitises the
/// text); right click in hand shuts it. Premade books read their text from the file Ratwood names (bookfile); the
/// shelves sort them by category.
/obj/item/book/rogue
	icon = 'modular_redtard/rockhill/icons/roguetown/items/books.dmi'
	icon_state = "basic_book_0"
	w_class = WEIGHT_CLASS_NORMAL
	force = 5
	slot_flags = ITEM_SLOT_POCKETS
	resistance_flags = FLAMMABLE
	drop_sound = 'sound/items/handling/book_drop.ogg'
	pickup_sound = 'sound/items/handling/book_pickup.ogg'
	lefthand_file = 'modular_redtard/rockhill/icons/baked/roguetown/items/books_lefthand.dmi'
	righthand_file = 'modular_redtard/rockhill/icons/baked/roguetown/items/books_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	rogue_baked_inhand = TRUE
	rogue_grid_width = 32
	rogue_grid_height = 32
	associated_skill = /datum/attribute/skill/misc/reading
	firefuel = 5 MINUTES
	/// Lying open: it reads, and it does not go in a pocket.
	var/open = FALSE
	/// The file of the book's text in ROGUE_BOOK_TEXTS_DIR (Ratwood strings/books).
	var/bookfile
	/// The section random bookcases shelve the book under (GLOB.rogue_book_categories); null keeps it off sorted shelves.
	var/category

/obj/item/book/rogue/Initialize(mapload)
	. = ..()
	// The porter keeps Ratwood's closed sprite ("book2_0"); its open one ends in "_1".
	if(!base_icon_state && length(icon_state) > 2 && (copytext(icon_state, -2) == "_0" || copytext(icon_state, -2) == "_1"))
		base_icon_state = copytext(icon_state, 1, -2)
	if(base_icon_state)
		inhand_icon_state = "[base_icon_state]_0"
	update_appearance(UPDATE_ICON_STATE)

/obj/item/book/rogue/update_icon_state()
	if(base_icon_state)
		var/state = "[base_icon_state]_[open ? 1 : 0]"
		if(icon_exists(icon, state))
			icon_state = state
	return ..()

/obj/item/book/rogue/examine(mob/user)
	. = ..()
	. += span_info(open ? "It lies open. Use it to read, right-click it in hand to shut it." : "Use it to open it.")

/obj/item/book/rogue/attack_self(mob/user, modifiers)
	if(!open)
		rogue_toggle_open(user)
		return TRUE
	if(!rogue_can_read(user))
		return TRUE
	if(!length(rogue_book_text()))
		to_chat(user, span_warning("This book is completely blank."))
		return TRUE
	return ..()

/obj/item/book/rogue/attack_self_secondary(mob/user, modifiers)
	. = ..()
	if(.)
		return
	rogue_toggle_open(user)
	return TRUE

/// Ratwood attack_right(): opens or shuts the book.
/obj/item/book/rogue/proc/rogue_toggle_open(mob/user)
	open = !open
	slot_flags = open ? NONE : initial(slot_flags)
	playsound(src, open ? ROGUE_BOOK_OPEN_SOUND : ROGUE_BOOK_CLOSE_SOUND, 100, FALSE, SHORT_RANGE_SOUND_EXTRARANGE)
	update_appearance(UPDATE_ICON_STATE)
	if(!open)
		SStgui.close_uis(src)
	user?.update_held_items()

/obj/item/book/rogue/proc/rogue_can_read(mob/user)
	if(user.is_blind())
		to_chat(user, span_warning("I can't see the pages!"))
		return FALSE
	return user.can_read(src)

/// The book's text as HTML for MarkdownViewer.
/obj/item/book/rogue/proc/rogue_book_text()
	return rogue_premade_book_text(bookfile)

/obj/item/book/rogue/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MarkdownViewer", name)
		ui.open()
		playsound(src, ROGUE_BOOK_PAGE_SOUND, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

/obj/item/book/rogue/ui_static_data(mob/user)
	return list(
		"title" = html_decode(name),
		"author" = "",
		"content" = rogue_book_text(),
	)

/// Ratwood file2book(): the pages of a premade book's file, joined; read once a round.
/proc/rogue_premade_book_text(bookfile)
	var/static/list/texts = list()
	if(!bookfile)
		return ""
	if(!isnull(texts[bookfile]))
		return texts[bookfile]
	var/text = ""
	var/path = "[ROGUE_BOOK_TEXTS_DIR][bookfile]"
	if(fexists(path))
		var/list/book = safe_json_decode(file2text(path))
		var/list/pages = islist(book) ? book["Contents"] : null
		if(islist(pages))
			text = jointext(pages, "<br>")
		else
			log_world("Rogue library: [path] has no pages.")
	texts[bookfile] = text
	return text

/// Ratwood's player book: bound from a manuscript in the round, or a copy of an archived one (from a shelf or the press).
/// Only a book bound this round may be added to the archive, so copies cannot bring back a book an admin removed.
/obj/item/book/rogue/playerbook
	name = "unknown title"
	desc = "by an unknown author"
	icon_state = "basic_book_0"
	/// The text as the pages were written (raw HTML of the paper), shown only through TGUI.
	var/player_book_text = ROGUE_BOOK_RUINED_TEXT
	/// Title and author are HTML-escaped, as Ratwood stores them.
	var/player_book_title = "unknown title"
	var/player_book_author = "unknown author"
	var/player_book_author_ckey = "unknown"
	/// The closed cover's sprite without "_0" (GLOB.rogue_book_covers).
	var/player_book_icon = "basic_book"
	/// The in-game date it was bound on.
	var/player_book_date
	var/player_book_category = ROGUE_BOOK_CATEGORY_MISC
	/// Bound this round and not archived yet.
	var/is_in_round_player_generated = FALSE
	/// Has a real title and author (Ratwood written).
	var/written = FALSE

/// archive_file_name - the archived book to copy; without it a random archived one (Ratwood). bound - a new book from a
/// manuscript, filled by rogue_bind() instead.
/obj/item/book/rogue/playerbook/Initialize(mapload, archive_file_name, bound = FALSE)
	. = ..()
	if(!bound)
		rogue_load_archived(archive_file_name)
	rogue_update_book()

/obj/item/book/rogue/playerbook/examine(mob/user)
	. = ..()
	if(is_in_round_player_generated && rogue_book_archive_enabled())
		. += span_info("It can be added to the archive at a printing press.")

/obj/item/book/rogue/playerbook/rogue_book_text()
	var/date = player_book_date ? "<br>Written: [rogue_book_display_text(player_book_date)]" : ""
	return "<h3>Title: [rogue_book_display_text(player_book_title)]<br>Author: [rogue_book_display_text(player_book_author)][date]</h3>[player_book_text]"

/// Copies an archived book; with no usable entry the book stays water-damaged (Ratwood).
/obj/item/book/rogue/playerbook/proc/rogue_load_archived(archive_file_name)
	var/datum/rogue_book_archive/archive = rogue_book_archive()
	if(!archive)
		return
	if(!archive_file_name && length(archive.entries))
		archive_file_name = pick(archive.entries)
	var/list/book = archive.get_entry(archive_file_name)
	if(!book["book_title"] || !book["text"])
		return
	player_book_title = book["book_title"]
	player_book_author = book["author"] || player_book_author
	player_book_author_ckey = book["author_ckey"] || player_book_author_ckey
	player_book_icon = book["icon"] || player_book_icon
	player_book_category = book["category"] || player_book_category
	player_book_text = book["text"]
	player_book_date = book["ic_date"]
	written = TRUE

/// Fills a book bound from a manuscript (Ratwood get_player_input()). The title comes HTML-escaped from the input.
/obj/item/book/rogue/playerbook/proc/rogue_bind(mob/living/author, title, category, cover, text)
	player_book_title = title
	player_book_author = rogue_book_display_text(author.real_name)
	player_book_author_ckey = author.ckey
	player_book_category = category
	player_book_icon = cover
	player_book_text = text
	player_book_date = rockhill_date_short()
	is_in_round_player_generated = TRUE
	written = TRUE
	rogue_update_book()

/obj/item/book/rogue/playerbook/proc/rogue_update_book()
	if(!(player_book_icon in rogue_book_cover_states()))
		player_book_icon = initial(player_book_icon)
	name = rogue_book_display_text(player_book_title)
	desc = "By [rogue_book_display_text(player_book_author)][player_book_date ? ", written [rogue_book_display_text(player_book_date)]" : ""]"
	base_icon_state = player_book_icon
	inhand_icon_state = "[player_book_icon]_0"
	update_appearance(UPDATE_ICON_STATE)
