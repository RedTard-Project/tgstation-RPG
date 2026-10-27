#define PRESS_PRINT_BIBLE "Print The Verses and Acts of the Ten"
#define PRESS_PRINT_LAW "Print a Tome of Justice"
#define PRESS_PRINT_ARCHIVE "Print a book from the archive"
#define PRESS_PRINT_MANUAL "Profession Manual"

/// Ratwood's printing press (modules/library/lib_machines.dm) on the porter's stub: a blank sheet of paper goes in, right
/// click picks what to print - the Verses and Acts of the Ten, the Tome of Justice, a profession manual or a book from the
/// player archive - and after a while the copy comes out by an empty hand. A player book bound this round is added to the
/// archive by using it on the press. Ratwood's printing of archived paintings is not here.
/obj/machinery/printingpress
	interaction_flags_atom = NONE
	var/printing = FALSE
	/// The blank sheet the next print is made on.
	var/obj/item/paper/loaded_medium
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
	. += span_info("Insert blank paper, then right-click to select what to print. Use an empty hand to retrieve the loaded paper or a finished print. Apply a newly bound player book to archive it.")
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
	if(!istype(tool, /obj/item/paper))
		return NONE
	if(output_item)
		to_chat(user, span_warning("Retrieve the printed item before inserting new items."))
		return ITEM_INTERACT_BLOCKING
	var/obj/item/paper/paper = tool
	if(paper.type != /obj/item/paper || !paper.is_empty())
		to_chat(user, span_warning("The paper needs to be blank to be put into [src]."))
		return ITEM_INTERACT_BLOCKING
	if(loaded_medium)
		to_chat(user, span_warning("It already has [loaded_medium] loaded."))
		return ITEM_INTERACT_BLOCKING
	if(!user.transferItemToLoc(paper, src))
		to_chat(user, span_warning("You can't insert [paper] into [src]."))
		return ITEM_INTERACT_BLOCKING
	loaded_medium = paper
	update_appearance(UPDATE_ICON_STATE)
	to_chat(user, span_notice("You insert the blank [paper.name] into [src]."))
	return ITEM_INTERACT_SUCCESS

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
	options += PRESS_PRINT_MANUAL
	var/choice = tgui_input_list(user, "Choose an option for [src]", "Printing Press", options)
	switch(choice)
		if(PRESS_PRINT_BIBLE)
			rogue_print(user, /obj/item/book/rogue/bibble)
		if(PRESS_PRINT_LAW)
			rogue_print(user, /obj/item/book/rogue/law)
		if(PRESS_PRINT_ARCHIVE)
			rogue_choose_archived(user)
		if(PRESS_PRINT_MANUAL)
			var/list/manuals = list()
			for(var/obj/item/recipe_book/manual_type as anything in subtypesof(/obj/item/recipe_book))
				manuals[initial(manual_type.name)] = manual_type
			var/manual_name = tgui_input_list(user, "Choose a manual", "Printing Press", manuals)
			if(manual_name)
				rogue_print(user, manuals[manual_name])

/// The archive's books to print (Ratwood PrintingPressArchive): every usable one, as "title - author (section)".
/obj/machinery/printingpress/proc/rogue_choose_archived(mob/living/user)
	var/datum/rogue_book_archive/archive = rogue_book_archive()
	if(!archive)
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

/// Ratwood can_print(): the press is free, loaded with blank paper and done recalibrating.
/obj/machinery/printingpress/proc/rogue_ready(mob/living/user)
	if(!user.can_perform_action(src))
		return FALSE
	if(printing)
		to_chat(user, span_warning("[src] is currently printing. Please wait."))
		return FALSE
	if(output_item)
		to_chat(user, span_warning("There is a finished product in [src]. Use an empty hand to retrieve it."))
		return FALSE
	if(!loaded_medium)
		to_chat(user, span_warning("[src] requires a blank piece of paper to print."))
		return FALSE
	if(!COOLDOWN_FINISHED(src, print_cooldown))
		to_chat(user, span_warning("[src] is still recalibrating."))
		return FALSE
	return TRUE

/// Ratwood start_printing(): the sheet is used up and the copy is made at once, so a book removed from the archive while
/// it prints still comes out whole.
/obj/machinery/printingpress/proc/rogue_print(mob/living/user, print_type, archive_file_name)
	if(!rogue_ready(user))
		return FALSE
	if(archive_file_name)
		var/datum/rogue_book_archive/archive = rogue_book_archive()
		if(!archive?.is_usable(archive_file_name))
			to_chat(user, span_warning("This book is no longer in the archive."))
			return FALSE
		output_item = new print_type(src, archive_file_name)
	else
		output_item = new print_type(src)
	output_item.desc = output_item.desc ? "[output_item.desc]<br>It is a printed copy." : "It is a printed copy."
	printing = TRUE
	QDEL_NULL(loaded_medium)
	to_chat(user, span_notice("[src] starts printing..."))
	playsound(src, ROGUE_PRESS_SOUND, 100, FALSE)
	update_appearance(UPDATE_ICON_STATE)
	addtimer(CALLBACK(src, PROC_REF(rogue_finish_printing)), ROGUE_PRESS_PRINT_TIME)
	return TRUE

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

#undef PRESS_PRINT_BIBLE
#undef PRESS_PRINT_LAW
#undef PRESS_PRINT_ARCHIVE
#undef PRESS_PRINT_MANUAL
