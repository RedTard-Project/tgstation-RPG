#define PRESS_PRINT_BIBLE "Print The Verses and Acts of the Ten"
#define PRESS_PRINT_LAW "Print a Tome of Justice"
#define PRESS_PRINT_ARCHIVE "Print a book from the archive"
#define PRESS_PRINT_PAINTING "Print a painting from the archive"
#define PRESS_PRINT_MANUAL "Profession Manual"

/// Ratwood's printing press (modules/library/lib_machines.dm) on the porter's stub: a blank sheet of paper or a blank canvas
/// goes in, right click picks what to print - the Verses and Acts of the Ten, the Tome of Justice, a profession manual, a
/// book from the player archive on paper, or an archived painting on a canvas of its size - and after a while the copy
/// comes out by an empty hand. A player book bound this round or a canvas painted this round is added to its archive by
/// using it on the press.
/obj/machinery/printingpress
	interaction_flags_atom = NONE
	var/printing = FALSE
	/// The blank sheet or canvas the next print is made on.
	var/obj/item/loaded_medium
	/// The finished copy, waiting for a hand.
	var/obj/item/output_item
	COOLDOWN_DECLARE(print_cooldown)

/obj/machinery/printingpress/Destroy()
	loaded_medium?.forceMove(drop_location())
	if(!printing)
		output_item?.forceMove(drop_location())
	return ..()

/obj/machinery/printingpress/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == loaded_medium)
		loaded_medium = null
	if(gone == output_item)
		output_item = null
	if(!QDELETED(src))
		update_appearance(UPDATE_ICON_STATE)

/obj/machinery/printingpress/update_icon_state()
	if(printing)
		icon_state = "Ppress_Printing"
	else if(output_item)
		icon_state = "Ppress_Done"
	else if(loaded_medium)
		icon_state = "Ppress_Prepared"
	else
		icon_state = "Ppress_Clean"
	return ..()

/obj/machinery/printingpress/examine(mob/user)
	. = ..()
	. += span_info("Insert blank paper or a blank canvas, then right-click to select what to print. Use an empty hand to retrieve the loaded material or a finished print. Apply a newly bound player book or a finished painting to archive it.")
	if(printing)
		. += span_info("It is currently printing.")
		return
	if(output_item)
		. += span_info("It has [output_item] ready. Use an empty hand to retrieve it.")
	else if(loaded_medium)
		. += span_info("It has a blank [loaded_medium.name] loaded.")
	else
		. += span_info("It is empty and has nothing loaded.")
	if(!COOLDOWN_FINISHED(src, print_cooldown))
		. += span_info("It is currently recalibrating and cannot print yet.")

/obj/machinery/printingpress/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(printing)
		to_chat(user, span_warning("[src] is currently printing. Please wait."))
		return ITEM_INTERACT_BLOCKING
	if(istype(tool, /obj/item/book/rogue/playerbook))
		rogue_archive_book(user, tool)
		return ITEM_INTERACT_SUCCESS
	if(istype(tool, /obj/item/manuscript))
		to_chat(user, span_warning("Finish this manuscript with a book crafting kit and give it a title before uploading it."))
		return ITEM_INTERACT_BLOCKING
	if(istype(tool, /obj/item/canvas))
		var/obj/item/canvas/canvas = tool
		if(!canvas.rogue_is_blank())
			rogue_archive_painting(user, canvas)
			return ITEM_INTERACT_SUCCESS
		rogue_load(user, canvas)
		return ITEM_INTERACT_SUCCESS
	if(!istype(tool, /obj/item/paper))
		return NONE
	var/obj/item/paper/paper = tool
	if(paper.type != /obj/item/paper || !paper.is_empty())
		to_chat(user, span_warning("The paper needs to be blank to be put into [src]."))
		return ITEM_INTERACT_BLOCKING
	rogue_load(user, paper)
	return ITEM_INTERACT_SUCCESS

/// Ratwood load_medium(): blank paper or a blank canvas goes in.
/obj/machinery/printingpress/proc/rogue_load(mob/living/user, obj/item/medium)
	if(output_item)
		to_chat(user, span_warning("Retrieve the printed item before inserting new items."))
		return
	if(loaded_medium)
		to_chat(user, span_warning("It already has [loaded_medium] loaded."))
		return
	if(!user.transferItemToLoc(medium, src))
		to_chat(user, span_warning("You can't insert [medium] into [src]."))
		return
	loaded_medium = medium
	update_appearance(UPDATE_ICON_STATE)
	to_chat(user, span_notice("You insert the blank [medium.name] into [src]."))

/obj/machinery/printingpress/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(printing)
		to_chat(user, span_warning("[src] is currently printing. Please wait."))
		return TRUE
	// Exited() clears the reference once the item leaves.
	var/obj/item/retrieved = output_item || loaded_medium
	if(!retrieved)
		to_chat(user, span_warning("[src] is empty."))
		return TRUE
	retrieved.forceMove(drop_location())
	user.put_in_hands(retrieved)
	to_chat(user, span_notice("You retrieve [retrieved] from [src]."))
	return TRUE

/obj/machinery/printingpress/attack_hand_secondary(mob/living/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	INVOKE_ASYNC(src, PROC_REF(rogue_choose_print), user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/// Ratwood attack_right(): what to print.
/obj/machinery/printingpress/proc/rogue_choose_print(mob/living/user)
	if(!rogue_ready(user))
		return
	var/list/options = list(PRESS_PRINT_BIBLE, PRESS_PRINT_LAW)
	if(rogue_book_archive())
		options += PRESS_PRINT_ARCHIVE
	options += list(PRESS_PRINT_PAINTING, PRESS_PRINT_MANUAL)
	var/choice = tgui_input_list(user, "Choose an option for [src]", "Printing Press", options)
	switch(choice)
		if(PRESS_PRINT_BIBLE)
			rogue_print(user, /obj/item/book/rogue/bibble)
		if(PRESS_PRINT_LAW)
			rogue_print(user, /obj/item/book/rogue/law)
		if(PRESS_PRINT_ARCHIVE)
			rogue_choose_archived(user)
		if(PRESS_PRINT_PAINTING)
			rogue_choose_painting(user)
		if(PRESS_PRINT_MANUAL)
			if(!rogue_ready(user, /obj/item/paper))
				return
			var/list/manuals = list()
			for(var/obj/item/recipe_book/manual_type as anything in subtypesof(/obj/item/recipe_book))
				manuals[initial(manual_type.name)] = manual_type
			var/manual_name = tgui_input_list(user, "Choose a manual", "Printing Press", manuals)
			if(manual_name)
				rogue_print(user, manuals[manual_name])

/// The archive's books to print (Ratwood PrintingPressArchive): every usable one, as "title - author (section)".
/obj/machinery/printingpress/proc/rogue_choose_archived(mob/living/user)
	var/datum/rogue_book_archive/archive = rogue_book_archive()
	if(!archive || !rogue_ready(user, /obj/item/paper))
		return
	var/list/books = list()
	for(var/file_name in archive.usable_titles(include_placed = TRUE))
		var/list/book = archive.entries[file_name]
		var/label = "[html_decode(book["book_title"])] - [html_decode(book["author"] || "Unknown")] ([book["category"]])"
		if(books[label])
			label = "[label] [file_name]"
		books[label] = file_name
	if(!length(books))
		to_chat(user, span_warning("The archive holds no books yet."))
		return
	var/picked = tgui_input_list(user, "Choose a book from the archive", "Book Archive", sort_list(books))
	if(picked)
		rogue_print(user, /obj/item/book/rogue/playerbook, books[picked])

/// The archived paintings to print (Ratwood PrintingPressArchive): those of the loaded canvas's size, as "title - painter".
/obj/machinery/printingpress/proc/rogue_choose_painting(mob/living/user)
	if(!rogue_ready(user, /obj/item/canvas))
		return
	var/obj/item/canvas/blank = loaded_medium
	var/list/paintings = list()
	for(var/datum/painting/painting as anything in rogue_archived_paintings())
		if(painting.width != blank.width || painting.height != blank.height || !fexists(rogue_painting_image_path(painting)))
			continue
		var/label = "[painting.title] - [painting.creator_name || "Unknown"]"
		if(paintings[label])
			label = "[label] ([copytext(painting.md5, 1, 9)])"
		paintings[label] = painting.md5
	if(!length(paintings))
		to_chat(user, span_warning("The archive holds no paintings of this canvas's size."))
		return
	var/picked = tgui_input_list(user, "Choose a painting from the archive", "Painting Archive", sort_list(paintings))
	if(picked)
		rogue_print_painting(user, paintings[picked])

/// Ratwood can_print(): the press is free, loaded with the blank medium the print needs and done recalibrating. Without a
/// medium type only the press itself is checked (Ratwood attack_right()).
/obj/machinery/printingpress/proc/rogue_ready(mob/living/user, medium_type)
	if(!user.can_perform_action(src))
		return FALSE
	if(printing)
		to_chat(user, span_warning("[src] is currently printing. Please wait."))
		return FALSE
	if(output_item)
		to_chat(user, span_warning("There is a finished product in [src]. Use an empty hand to retrieve it."))
		return FALSE
	if(!medium_type)
		return TRUE
	if(!istype(loaded_medium, medium_type))
		to_chat(user, span_warning("[src] requires [ispath(medium_type, /obj/item/canvas) ? "a blank canvas" : "a blank piece of paper"] to print that."))
		return FALSE
	if(!COOLDOWN_FINISHED(src, print_cooldown))
		to_chat(user, span_warning("[src] is still recalibrating."))
		return FALSE
	return TRUE

/// Ratwood start_printing() of a book or a manual: the copy is made at once, so a book removed from the archive while it
/// prints still comes out whole.
/obj/machinery/printingpress/proc/rogue_print(mob/living/user, print_type, archive_file_name)
	if(!rogue_ready(user, /obj/item/paper))
		return FALSE
	if(archive_file_name)
		var/datum/rogue_book_archive/archive = rogue_book_archive()
		if(!archive?.is_usable(archive_file_name))
			to_chat(user, span_warning("This book is no longer in the archive."))
			return FALSE
		output_item = new print_type(src, archive_file_name)
	else
		output_item = new print_type(src)
	rogue_start_printing(user)
	return TRUE

/// Ratwood start_printing() of a painting: TG's copy of the archived painting on a new canvas of the loaded one's kind.
/// A printed copy cannot be archived again.
/obj/machinery/printingpress/proc/rogue_print_painting(mob/living/user, md5)
	if(!rogue_ready(user, /obj/item/canvas))
		return FALSE
	var/datum/painting/painting = rogue_archived_painting(md5)
	if(!painting)
		to_chat(user, span_warning("This painting can no longer be printed."))
		return FALSE
	var/obj/item/canvas/blank = loaded_medium
	if(!blank.rogue_is_blank() || painting.width != blank.width || painting.height != blank.height)
		to_chat(user, span_warning("This painting does not fit the loaded canvas."))
		return FALSE
	var/obj/item/canvas/print = new blank.type(src)
	painting.fill_canvas(print)
	output_item = print
	rogue_start_printing(user)
	return TRUE

/// The blank medium is used up and the press works for a while.
/obj/machinery/printingpress/proc/rogue_start_printing(mob/living/user)
	output_item.desc = output_item.desc ? "[output_item.desc]<br>It is a printed copy." : "It is a printed copy."
	printing = TRUE
	QDEL_NULL(loaded_medium)
	to_chat(user, span_notice("[src] starts printing..."))
	playsound(src, ROGUE_PRESS_SOUND, 100, FALSE)
	update_appearance(UPDATE_ICON_STATE)
	addtimer(CALLBACK(src, PROC_REF(rogue_finish_printing)), ROGUE_PRESS_PRINT_TIME)

/obj/machinery/printingpress/proc/rogue_finish_printing()
	printing = FALSE
	COOLDOWN_START(src, print_cooldown, ROGUE_PRESS_COOLDOWN)
	update_appearance(UPDATE_ICON_STATE)
	if(output_item)
		visible_message(span_notice("[src] hums as it produces [output_item]."))

/// Ratwood: a player book bound this round goes into the archive, after a confirmation.
/obj/machinery/printingpress/proc/rogue_archive_book(mob/living/user, obj/item/book/rogue/playerbook/book)
	var/datum/rogue_book_archive/archive = rogue_book_archive()
	if(!archive)
		to_chat(user, span_warning("[src] keeps no archive."))
		return
	if(!book.written)
		to_chat(user, span_warning("This book has yet to be authored and titled. You'll need to do so before uploading it."))
		return
	// Copies printed or shelved from the archive must not bring back books an admin removed.
	if(!book.is_in_round_player_generated)
		to_chat(user, span_warning("Only newly bound books can be added to the archive."))
		return
	if(tgui_alert(user, "Do you want to add the book to the archive?", "Confirm", list("Yes", "No")) != "Yes")
		to_chat(user, span_notice("You decide not to upload the book."))
		return
	if(QDELETED(book) || !book.is_in_round_player_generated || !user.can_perform_action(src) || !user.Adjacent(book))
		return
	if(archive.add_book(book, user))
		book.is_in_round_player_generated = FALSE

/// Ratwood attackby() with a signed canvas: a painting finished this round goes into the archive, after a confirmation.
/obj/machinery/printingpress/proc/rogue_archive_painting(mob/living/user, obj/item/canvas/canvas)
	if(!canvas.finalized)
		to_chat(user, span_warning("This painting has yet to be finished and titled. Finish it in its window before archiving it."))
		return
	if(!canvas.rogue_can_archive())
		to_chat(user, span_warning("Only newly painted canvases can be added to the archive."))
		return
	if(tgui_alert(user, "Do you want to add the painting to the archive?", "Confirm", list("Yes", "No")) != "Yes")
		to_chat(user, span_notice("You decide not to upload the painting."))
		return
	if(QDELETED(canvas) || printing || !user.can_perform_action(src) || !user.Adjacent(canvas))
		return
	canvas.rogue_archive(user)

#undef PRESS_PRINT_BIBLE
#undef PRESS_PRINT_LAW
#undef PRESS_PRINT_ARCHIVE
#undef PRESS_PRINT_PAINTING
#undef PRESS_PRINT_MANUAL
