/// Ratwood's archive of player books (code/__HELPERS/player_archives.dm, controllers/subsystem/librarian.dm): the books
/// players bound and added at the printing press, kept between rounds. MySQL is not used: one JSON file per book
/// (book_title, author, author_ckey, icon, category, text, ic_date) in Ratwood's folder and format, beside the players
/// barred from adding books. Titles and authors are stored HTML-escaped and the text as it was written (the raw HTML of the
/// paper), as Ratwood does; the text is only ever shown through TGUI, which sanitises it.
/datum/rogue_book_archive
	/// Books by file name: read once, kept in step with the files on every change.
	var/list/entries = list()
	/// Books random stocking already put on a shelf this round, so none turns up twice.
	var/list/placed = list()
	/// Barred players by ckey: the key of the admin who barred them and the real date.
	var/list/upload_bans = list()

/datum/rogue_book_archive/New()
	. = ..()
	load_entries()
	load_upload_bans()

/datum/rogue_book_archive/proc/entry_path(file_name)
	return "[ROGUE_BOOK_ARCHIVE_DIR][file_name].json"

/datum/rogue_book_archive/proc/bans_path()
	return "[ROGUE_BOOK_ARCHIVE_DIR][ROGUE_BOOK_BANS_FILE]"

/datum/rogue_book_archive/proc/load_entries()
	var/static/list/reserved_files = list(ROGUE_BOOK_BANS_FILE, ROGUE_BOOK_OLD_INDEX_FILE)
	entries = list()
	for(var/file_name in flist(ROGUE_BOOK_ARCHIVE_DIR))
		if((file_name in reserved_files) || copytext(file_name, -5) != ".json")
			continue
		var/list/book = safe_json_decode(file2text("[ROGUE_BOOK_ARCHIVE_DIR][file_name]"))
		if(!islist(book))
			log_world("Book archive: [file_name] holds broken JSON and was skipped.")
			continue
		// Books archived before categories existed, or under one since removed, are filed under Misc.
		if(!(book["category"] in GLOB.rogue_book_categories))
			book["category"] = ROGUE_BOOK_CATEGORY_MISC
		entries[copytext(file_name, 1, -5)] = book

/datum/rogue_book_archive/proc/load_upload_bans()
	if(!fexists(bans_path()))
		return
	var/list/loaded = safe_json_decode(file2text(bans_path()))
	if(!islist(loaded))
		log_world("Book archive: [bans_path()] holds broken JSON and was skipped.")
		return
	upload_bans = loaded

/datum/rogue_book_archive/proc/write_file(path, list/contents)
	fdel(path)
	if(!text2file(json_encode(contents), path))
		message_admins("Book archive: unable to save [path].")
		return FALSE
	return TRUE

/// The book stored under a file name, or an empty list.
/datum/rogue_book_archive/proc/get_entry(file_name)
	var/list/book = entries[file_name]
	return book || list()

/// The escaped title of a book, or its file name.
/datum/rogue_book_archive/proc/display_title(file_name)
	var/list/book = get_entry(file_name)
	return rogue_book_display_text(book["book_title"], file_name)

/// Whether the book is whole enough to shelve or print.
/datum/rogue_book_archive/proc/is_usable(file_name)
	var/list/book = entries[file_name]
	return book && book["book_title"] && book["text"]

/// File names of the usable books, of one category if given. Books random stocking already shelved this round are left out
/// unless include_placed is set (Ratwood pull_player_book_titles()).
/datum/rogue_book_archive/proc/usable_titles(category, include_placed = FALSE)
	. = list()
	for(var/file_name in entries)
		if(!include_placed && placed[file_name])
			continue
		if(!is_usable(file_name))
			continue
		if(category && entries[file_name]["category"] != category)
			continue
		. += file_name

/// Whether a book is stored under the file name; fexists also catches titles differing only in case on Windows.
/datum/rogue_book_archive/proc/is_title_taken(file_name)
	return entries[file_name] || fexists(entry_path(file_name))

/datum/rogue_book_archive/proc/is_banned(key)
	var/banned_ckey = ckey(key)
	return banned_ckey && upload_bans[banned_ckey]

/datum/rogue_book_archive/proc/ban(key, admin_key)
	var/banned_ckey = ckey(key)
	if(!banned_ckey || upload_bans[banned_ckey])
		return FALSE
	var/list/new_bans = upload_bans.Copy()
	new_bans[banned_ckey] = list("admin" = "[admin_key]", "date" = time2text(world.realtime, "YYYY-MM-DD"))
	if(!write_file(bans_path(), new_bans))
		return FALSE
	upload_bans = new_bans
	return TRUE

/datum/rogue_book_archive/proc/unban(key)
	var/banned_ckey = ckey(key)
	if(!banned_ckey || !upload_bans[banned_ckey])
		return FALSE
	var/list/new_bans = upload_bans.Copy()
	new_bans -= banned_ckey
	if(!write_file(bans_path(), new_bans))
		return FALSE
	upload_bans = new_bans
	return TRUE

/// Writes a book under a file name, replacing whatever is there.
/datum/rogue_book_archive/proc/save_entry(file_name, list/book)
	if(!write_file(entry_path(file_name), book))
		return FALSE
	entries[file_name] = book
	return TRUE

/datum/rogue_book_archive/proc/delete_entry(file_name)
	if(!entries[file_name])
		return FALSE
	var/path = entry_path(file_name)
	fdel(path)
	if(fexists(path))
		message_admins("Book archive: unable to delete [path].")
		return FALSE
	entries -= file_name
	placed -= file_name
	return TRUE

/// Adds a newly bound player book (Ratwood playerbook2file()). Tells the player and the admins how it went.
/datum/rogue_book_archive/proc/add_book(obj/item/book/rogue/playerbook/book, mob/user)
	if(!book.player_book_text)
		rogue_book_feedback(user, "There is no text in the book!")
		return FALSE
	if(is_banned(user?.ckey) || is_banned(book.player_book_author_ckey))
		rogue_book_feedback(user, "Someone who worked on this book has been barred from adding books to the archive.")
		return FALSE
	var/file_name = rogue_book_file_name(book.player_book_title)
	if(!file_name)
		rogue_book_feedback(user, "That title cannot be archived. Use a shorter title that does not begin with an underscore.")
		return FALSE
	if(is_title_taken(file_name))
		rogue_book_feedback(user, "There is already a book by this title!")
		return FALSE
	var/category = book.player_book_category
	if(!(category in GLOB.rogue_book_categories))
		category = ROGUE_BOOK_CATEGORY_MISC
	var/list/contents = list(
		"book_title" = "[book.player_book_title]",
		"author" = "[book.player_book_author]",
		"author_ckey" = "[book.player_book_author_ckey]",
		"icon" = "[book.player_book_icon]",
		"category" = "[category]",
		"text" = "[book.player_book_text]",
		"ic_date" = "[book.player_book_date || rockhill_date_short()]",
	)
	if(!save_entry(file_name, contents))
		rogue_book_feedback(user, "The archive could not store this book.")
		return FALSE
	var/who = "[rogue_book_display_text(contents["author_ckey"])]([rogue_book_display_text(contents["author"])])"
	message_admins("Book [display_title(file_name)] has been saved to the player book archive by [who].")
	log_game("BOOK ARCHIVE: [key_name(user)] archived the book [html_decode(contents["book_title"])] as [file_name].")
	rogue_book_feedback(user, "You have a feeling the book will remain in the archive for a very long time...", TRUE)
	return TRUE

/// Changes one field of an archived book (Ratwood amend_player_book()); a new title moves the book to its new file.
/datum/rogue_book_archive/proc/amend(file_name, field, value)
	if(!istext(value) || !length(trim(value)) || !(field in list("book_title", "author", "icon", "category")))
		return FALSE
	if(field == "category" && !(value in GLOB.rogue_book_categories))
		return FALSE
	if(field == "icon" && !(value in rogue_book_cover_states()))
		return FALSE
	var/list/book = entries[file_name]
	if(!book)
		return FALSE
	book = book.Copy()
	book[field] = value
	var/new_file_name = file_name
	if(field == "book_title")
		new_file_name = rogue_book_file_name(value)
		if(!new_file_name)
			return FALSE
		if(new_file_name != file_name && is_title_taken(new_file_name))
			return FALSE
	// The amended copy is written before the original goes, so a failed save cannot lose the book.
	if(!save_entry(new_file_name, book))
		return FALSE
	if(new_file_name != file_name)
		return delete_entry(file_name)
	return TRUE

/// Ratwood player_archive_filename(): the file a title is archived under, or null when it cannot be stored safely. A title
/// too long once url-encoded is stored under its hash (Ratwood refuses it).
/proc/rogue_book_file_name(title)
	if(!istext(title) || !length(trim(title)) || length_char(html_decode(title)) > MAX_NAME_LEN)
		return
	if(copytext(title, 1, 2) == "_")
		return
	var/file_name = url_encode(title)
	// Windows keeps a few device names for itself, whatever the extension.
	var/static/regex/device_name = regex(@"^(con|prn|aux|nul|com\d|lpt\d)$", "i")
	if(length(file_name) > ROGUE_BOOK_FILE_NAME_MAX || device_name.Find(file_name))
		return "book_[md5(title)]"
	var/static/regex/unsafe_file_name = regex(@{"[\\/:*?"<>|]"})
	if(unsafe_file_name.Find(file_name))
		return
	return file_name

/// Ratwood player_archive_display_text(): archived text escaped once for HTML, however it was stored.
/proc/rogue_book_display_text(text, fallback = "Unknown")
	if(isnull(text) || text == "")
		return html_encode(fallback)
	return html_encode(html_decode("[text]"))

/proc/rogue_book_feedback(mob/user, message, success = FALSE)
	if(user)
		to_chat(user, success ? span_notice(message) : span_warning(message))

/// The closed cover sprites a player book may have.
/proc/rogue_book_cover_states()
	var/list/states = list()
	for(var/cover_name in GLOB.rogue_book_covers)
		states += GLOB.rogue_book_covers[cover_name]
	return states

/// The archive, read on first use; null when the server keeps no archive.
/proc/rogue_book_archive()
	if(!rogue_book_archive_enabled())
		return null
	if(!SSrogue_library.archive)
		SSrogue_library.archive = new /datum/rogue_book_archive
	return SSrogue_library.archive

/// Ratwood's SSlibrarian part of the library: the archive, and the shelves of each map load stocked in a random order once
/// all of them are in place, so which shelves get the archived books differs every round.
SUBSYSTEM_DEF(rogue_library)
	name = "Rogue Library"
	ss_flags = SS_NO_FIRE
	dependencies = list(
		/datum/controller/subsystem/library,
	)
	var/datum/rogue_book_archive/archive
	/// Bookcases waiting to be stocked.
	var/list/obj/structure/bookcase/pending_shelves = list()

/datum/controller/subsystem/rogue_library/Initialize()
	if(rogue_library_enabled())
		rogue_book_archive()
		stock_pending()
	return SS_INIT_SUCCESS

/// Takes a bookcase to stock with the rest of its map load; one loaded later is stocked on the next tick.
/datum/controller/subsystem/rogue_library/proc/queue_shelf(obj/structure/bookcase/shelf)
	pending_shelves += shelf
	if(initialized)
		addtimer(CALLBACK(src, PROC_REF(stock_pending)), 0, TIMER_UNIQUE)

/datum/controller/subsystem/rogue_library/proc/stock_pending()
	var/list/shelves = shuffle(pending_shelves)
	pending_shelves = list()
	for(var/obj/structure/bookcase/shelf as anything in shelves)
		if(QDELETED(shelf))
			continue
		shelf.rogue_stock()

/// Ratwood create_random_books_rogue(): random books for a shelf or a spot. A categorised shelf takes premade books of its
/// category and archived player books of it not yet shelved this round, more of them the more there are; an
/// uncategorised one takes premade books only. Now and then a slot holds a book crafting kit instead.
/proc/rogue_spawn_random_books(amount, atom/location, category)
	var/static/list/premade_books
	if(!premade_books)
		premade_books = subtypesof(/obj/item/book/rogue) - typesof(/obj/item/book/rogue/playerbook, /obj/item/book/rogue/secret, /obj/item/book/rogue/bibble)
	var/list/eligible_books = premade_books
	if(category)
		eligible_books = list()
		for(var/obj/item/book/rogue/book_type as anything in premade_books)
			if(initial(book_type.category) == category)
				eligible_books += book_type
	var/datum/rogue_book_archive/archive = category ? rogue_book_archive() : null
	var/list/unused_titles = archive ? archive.usable_titles(category) : list()
	var/player_book_chance = clamp(length(unused_titles), ROGUE_PLAYER_BOOK_CHANCE_MIN, ROGUE_PLAYER_BOOK_CHANCE_MAX)
	for(var/slot in 1 to amount)
		if(prob(ROGUE_BOOK_KIT_CHANCE))
			new /obj/item/book_crafting_kit(location)
			continue
		// Categories without premade books (Adult, Misc) are stocked from the archive alone.
		if(length(unused_titles) && (!length(eligible_books) || prob(player_book_chance)))
			var/file_name = pick_n_take(unused_titles)
			new /obj/item/book/rogue/playerbook(location, file_name)
			archive.placed[file_name] = TRUE
			continue
		if(!length(eligible_books))
			continue
		var/book_type = pick(eligible_books)
		new book_type(location)
