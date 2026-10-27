/// Ratwood's painting archive (controllers/subsystem/painting.dm, __HELPERS/player_archives.dm, structures/artstuff.dm) on
/// TG's persistent paintings (SSpersistent_paintings). A TG canvas painted and finished this round is added at the printing
/// press at once - TG saves only paintings hung in its library frames, at round end - and the press prints an archived
/// painting on a blank canvas of the same size. Archived paintings carry ROGUE_PAINTING_TAG: the press prints only them,
/// and TG's frames on modern maps, which pick paintings by their own tags, never show them. Admins remove paintings with
/// TG's Paintings Manager. A player barred from the book archive cannot add paintings either.

/// The archived paintings the press prints.
/proc/rogue_archived_paintings()
	return SSpersistent_paintings.get_paintings_with_tag(ROGUE_PAINTING_TAG)

/// The archived painting of an image hash that can still be printed, or null.
/proc/rogue_archived_painting(md5)
	for(var/datum/painting/painting as anything in rogue_archived_paintings())
		if(painting.md5 == md5)
			return fexists(rogue_painting_image_path(painting)) ? painting : null

/// TG's file of a painting's image.
/proc/rogue_painting_image_path(datum/painting/painting)
	return "[ROGUE_PAINTING_IMAGES_DIR][painting.md5].png"

/obj/item/canvas/examine(mob/user)
	. = ..()
	if(!rogue_library_enabled())
		return
	if(rogue_is_blank())
		. += span_info("A blank canvas can be loaded into a printing press to print an archived painting.")
	else if(rogue_can_archive())
		. += span_info("It can be added to the archive at a printing press.")

/// Nothing has been painted on it yet: the press prints on it (Ratwood is_blank()).
/obj/item/canvas/proc/rogue_is_blank()
	return !used && !finalized && !icon_generated

/// Finished and painted this round, not a printed copy nor archived already.
/obj/item/canvas/proc/rogue_can_archive()
	return finalized && !no_save && painting_metadata && !painting_metadata.loaded_from_json

/// Ratwood upload_painting() and SSpaintings playerpainting2file(): the painting goes into the archive, its image written as
/// TG's frames write it at round end, and the archive saved at once. Tells the user how it went.
/obj/item/canvas/proc/rogue_archive(mob/user)
	if(!rogue_can_archive())
		rogue_book_feedback(user, "Only newly painted canvases can be added to the archive.")
		return FALSE
	var/datum/rogue_book_archive/book_archive = rogue_book_archive()
	if(book_archive && (book_archive.is_banned(user?.ckey) || book_archive.is_banned(painting_metadata.creator_ckey)))
		rogue_book_feedback(user, "Someone who worked on this painting has been barred from adding to the archive.")
		return FALSE
	var/data = get_data_string()
	var/image_md5 = md5(LOWER_TEXT(data))
	if(image_md5 in SSpersistent_paintings.deleted_paintings_md5s)
		rogue_book_feedback(user, "This painting has been taken out of the archive.")
		return FALSE
	for(var/datum/painting/entry as anything in SSpersistent_paintings.paintings)
		if(entry.md5 == image_md5)
			rogue_book_feedback(user, "This painting is already in the archive.")
			return FALSE
	painting_metadata.md5 = image_md5
	var/error = rustg_dmi_create_png(rogue_painting_image_path(painting_metadata), "[width]", "[height]", data)
	if(error)
		log_world("Painting archive: unable to save [rogue_painting_image_path(painting_metadata)]: [error]")
		rogue_book_feedback(user, "The archive could not store this painting.")
		return FALSE
	LAZYOR(painting_metadata.tags, ROGUE_PAINTING_TAG)
	SSpersistent_paintings.paintings += painting_metadata
	SSpersistent_paintings.save_to_file()
	// The archived canvas is a copy from now on: TG's frames will not save it a second time.
	no_save = TRUE
	message_admins("Painting [html_encode(painting_metadata.title)] has been saved to the painting archive by [key_name_admin(user)].")
	log_game("PAINTING ARCHIVE: [key_name(user)] archived the painting [painting_metadata.title] ([image_md5]).")
	rogue_book_feedback(user, "You have a feeling the painting will remain in the archive for a very long time...", TRUE)
	return TRUE
