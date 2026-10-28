/// Ratwood's Manage Books and Archive Bans (modules/admin/admin_verbs.dm, topic.dm) in Rogue Systems: every archived
/// player book with its author and section, to read, amend, delete, and bar its author from adding more; and the barred
/// players, to let back. A book's text is only ever shown through TGUI, which sanitises it, never in this panel.
ADMIN_VERB(rogue_manage_books, R_ADMIN, "Manage Books", "Read, amend or delete the player books kept between rounds, and bar players from adding more.", ADMIN_CATEGORY_ROGUE)
	GLOB.rogue_book_admin.show(user)
	BLACKBOX_LOG_ADMIN_VERB("Manage Books")

GLOBAL_DATUM_INIT(rogue_book_admin, /datum/rogue_book_admin, new)

/datum/rogue_book_admin

/datum/rogue_book_admin/proc/href_for(action, list/params)
	var/list/query = list("src=[REF(src)]", HrefToken(), "action=[action]")
	for(var/param in params)
		query += "[param]=[url_encode("[params[param]]")]"
	return "byond://?[jointext(query, ";")]"

/datum/rogue_book_admin/proc/show(client/user)
	var/datum/rogue_book_archive/archive = rogue_book_archive()
	if(!archive)
		to_chat(user, span_warning("The server keeps no book archive (ROGUE_BOOK_ARCHIVE)."), confidential = TRUE)
		return
	var/list/rows = list()
	for(var/file_name in archive.entries)
		var/list/book = archive.get_entry(file_name)
		var/author_ckey = book["author_ckey"]
		var/list/actions = list(
			"<a href='[href_for("view", list("file" = file_name))]'>View</a>",
			"<a href='[href_for("amend", list("file" = file_name))]'>Amend</a>",
			"<a href='[href_for("delete", list("file" = file_name))]'>Delete</a>",
		)
		if(archive.is_banned(author_ckey))
			actions += "Author barred"
		else if(ckey(author_ckey))
			actions += "<a href='[href_for("ban", list("ckey" = author_ckey))]'>Bar author</a>"
		rows += list(list(
			archive.display_title(file_name),
			"[rogue_book_display_text(book["author"])] ([rogue_book_display_text(author_ckey)])",
			rogue_book_display_text(book["category"]),
			rogue_book_display_text(book["ic_date"]),
			jointext(actions, " "),
		))
	var/list/body = list(
		"<a href='[href_for("ban")]'>Bar a player from adding books</a> | <a href='[href_for("bans")]'>Barred players</a>",
		rogue_book_admin_table(list("Title", "Author", "Category", "Written", "Actions"), rows, "No books in the archive."),
	)
	var/datum/browser/popup = new(user.mob, "rogue_book_management", "Book Management", 800, 700)
	popup.set_content(jointext(body, ""))
	popup.open()

/datum/rogue_book_admin/proc/show_bans(client/user)
	var/datum/rogue_book_archive/archive = rogue_book_archive()
	if(!archive)
		return
	var/list/rows = list()
	for(var/banned_ckey in archive.upload_bans)
		var/list/ban = archive.upload_bans[banned_ckey]
		rows += list(list(
			rogue_book_display_text(banned_ckey),
			rogue_book_display_text(islist(ban) ? ban["admin"] : null),
			rogue_book_display_text(islist(ban) ? ban["date"] : null),
			"<a href='[href_for("unban", list("ckey" = banned_ckey))]'>Let back</a>",
		))
	var/list/body = list(
		"<a href='[href_for("books")]'>Back to the books</a>",
		rogue_book_admin_table(list("Player", "Barred by", "Date", "Actions"), rows, "No one is barred."),
	)
	var/datum/browser/popup = new(user.mob, "rogue_book_management", "Barred From the Book Archive", 600, 500)
	popup.set_content(jointext(body, ""))
	popup.open()

/// Ratwood player_archive_admin_table().
/proc/rogue_book_admin_table(list/headers, list/rows, empty_text)
	var/list/table = list("<table style='border-collapse: separate; border-spacing: 0 6px; width: 100%;'><tr>")
	for(var/header in headers)
		table += "<th style='padding: 6px 10px; text-align: left;'>[header]</th>"
	table += "</tr>"
	for(var/list/row as anything in rows)
		table += "<tr>"
		for(var/cell in row)
			table += "<td style='padding: 6px 10px;'>[cell]</td>"
		table += "</tr>"
	if(!length(rows))
		table += "<tr><td colspan='[length(headers)]' style='padding: 16px; text-align: center;'>[empty_text]</td></tr>"
	table += "</table>"
	return jointext(table, "")

/datum/rogue_book_admin/Topic(href, list/href_list)
	var/client/user = usr?.client
	if(!user?.holder?.CheckAdminHref(href, href_list) || !check_rights_for(user, R_ADMIN))
		return
	var/datum/rogue_book_archive/archive = rogue_book_archive()
	if(!archive)
		return
	var/file_name = href_list["file"]
	switch(href_list["action"])
		if("books")
			show(user)
		if("bans")
			show_bans(user)
		if("view")
			var/list/book = archive.get_entry(file_name)
			if(!length(book))
				to_chat(user, span_warning("That book is gone."), confidential = TRUE)
				return
			var/header = "<h3>[archive.display_title(file_name)]</h3><p>By [rogue_book_display_text(book["author"])] ([rogue_book_display_text(book["author_ckey"])]), written [rogue_book_display_text(book["ic_date"])]<br>Category: [rogue_book_display_text(book["category"])]</p>"
			var/datum/rogue_book_viewer/viewer = new(html_decode(archive.display_title(file_name)), "[header][book["text"]]")
			viewer.ui_interact(user.mob)
		if("amend")
			amend(user, archive, file_name)
			show(user)
		if("delete")
			if(!archive.entries[file_name])
				return
			var/title = archive.display_title(file_name)
			if(tgui_alert(user, "Are you sure you want to delete the book '[html_decode(title)]'?", "Confirm Deletion", list("Yes", "No")) != "Yes")
				return
			if(!archive.delete_entry(file_name))
				to_chat(user, span_warning("The book could not be deleted."), confidential = TRUE)
				return
			message_admins("[key_name_admin(user)] has deleted the player made book '[title]'.")
			log_admin("[key_name(user)] has deleted the player made book '[html_decode(title)]'.")
			show(user)
		if("ban")
			var/banned_ckey = ckey(href_list["ckey"])
			if(!banned_ckey)
				banned_ckey = ckey(tgui_input_text(user, "The ckey of the player to bar from adding books to the archive", "Archive Ban", max_length = MAX_NAME_LEN))
			if(!banned_ckey)
				return
			if(archive.is_banned(banned_ckey))
				to_chat(user, span_warning("[banned_ckey] is already barred from adding books."), confidential = TRUE)
				return
			if(tgui_alert(user, "Bar [banned_ckey] from adding books to the archive?", "Archive Ban", list("Yes", "No")) != "Yes")
				return
			if(!archive.ban(banned_ckey, user.key))
				to_chat(user, span_warning("[banned_ckey] could not be barred."), confidential = TRUE)
				return
			message_admins("[key_name_admin(user)] has barred [banned_ckey] from adding books to the archive.")
			log_admin("[key_name(user)] has barred [banned_ckey] from adding books to the archive.")
			show(user)
		if("unban")
			var/banned_ckey = ckey(href_list["ckey"])
			if(!archive.unban(banned_ckey))
				to_chat(user, span_warning("[banned_ckey] could not be let back."), confidential = TRUE)
				return
			message_admins("[key_name_admin(user)] has let [banned_ckey] add books to the archive again.")
			log_admin("[key_name(user)] has let [banned_ckey] add books to the archive again.")
			show_bans(user)

/// Ratwood amend_player_book from the panel: the title, the author, the cover or the section.
/datum/rogue_book_admin/proc/amend(client/user, datum/rogue_book_archive/archive, file_name)
	var/list/book = archive.entries[file_name]
	if(!book)
		return
	var/static/list/fields = list("Title" = "book_title", "Author" = "author", "Cover" = "icon", "Category" = "category")
	var/field_name = tgui_input_list(user, "What to change?", "Amend Book", fields)
	if(!field_name)
		return
	var/field = fields[field_name]
	var/value
	switch(field)
		if("category")
			value = tgui_input_list(user, "New category", "Amend Book", GLOB.rogue_book_categories, book["category"])
		if("icon")
			var/cover_name = tgui_input_list(user, "New cover", "Amend Book", GLOB.rogue_book_covers)
			value = cover_name && GLOB.rogue_book_covers[cover_name]
		else
			value = tgui_input_text(user, "New [LOWER_TEXT(field_name)]", "Amend Book", html_decode(book[field]), max_length = MAX_NAME_LEN)
			if(value && field == "book_title")
				value = capitalize(trim(value))
	if(!value)
		return
	var/old_title = archive.display_title(file_name)
	if(!archive.amend(file_name, field, value))
		to_chat(user, span_warning("The book could not be amended (an empty or taken title?)."), confidential = TRUE)
		return
	message_admins("[key_name_admin(user)] has amended the player made book '[old_title]': [LOWER_TEXT(field_name)] is now '[rogue_book_display_text(value)]'.")
	log_admin("[key_name(user)] has amended the player made book '[html_decode(old_title)]': [LOWER_TEXT(field_name)] is now '[html_decode(value)]'.")

/// A book shown to an admin through TGUI's MarkdownViewer, which sanitises it; gone when the window shuts.
/datum/rogue_book_viewer
	var/title
	var/content

/datum/rogue_book_viewer/New(title, content)
	. = ..()
	src.title = title
	src.content = content

/datum/rogue_book_viewer/ui_state(mob/user)
	return ADMIN_STATE(R_ADMIN)

/datum/rogue_book_viewer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MarkdownViewer", title)
		ui.open()

/datum/rogue_book_viewer/ui_static_data(mob/user)
	return list(
		"title" = title,
		"author" = "",
		"content" = content,
	)

/datum/rogue_book_viewer/ui_close(mob/user)
	qdel(src)
