/// Ratwood's bookcases (modules/library/lib_items.dm, random_books.dm) on TG's: on medieval maps every bookcase has
/// Ratwood's look and blocks sight, takes Ratwood's books, and a random one is stocked with Ratwood's premade books and
/// the archived player books of its section instead of TG's database. The map's bookcases are TG paths
/// (/obj/structure/bookcase/random/fiction ...); the four Ratwood-only ones are the porter's stubs and turn into the
/// TG bookcases below.

/// Ratwood's books, recipe books and skill books go on TG's shelves like TG's books (Ratwood allowed_books).
/datum/controller/global_vars/InitGlobalbook_types()
	..()
	book_types += typecacheof(list(
		/obj/item/book/rogue,
		/obj/item/book/granter/spell,
		/obj/item/recipe_book,
		/obj/item/skillbook,
	))

/obj/structure/bookcase
	/// Ratwood's look ("a" ... "h"), on medieval maps; null keeps TG's.
	var/rogue_shelf_style
	/// Ratwood's archive bookcase: stocked with up to ROGUE_SHELF_EXTRA_BOOKS more books.
	var/rogue_extra_stock = FALSE

/obj/structure/bookcase/Initialize(mapload)
	. = ..()
	if(!rogue_library_enabled())
		return
	// Ratwood stocks its own number of books; TG's count is cleared before TG's random subtypes read it, so the reference
	// shelves spawn no station manuals.
	books_to_load = 0
	rogue_shelf_style = pick(ROGUE_SHELF_STYLES)
	icon = ROGUE_SHELF_ICON
	set_opacity(TRUE)
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/bookcase/update_icon_state()
	. = ..()
	if(!rogue_shelf_style)
		return
	var/books = length(contents)
	icon_state = books ? "[rogue_shelf_style][min(books, ROGUE_SHELF_MAX_BOOKS)]" : ROGUE_SHELF_EMPTY_STATE

/// On medieval maps a mapped bookcase is stocked by Ratwood's rules with the rest of its map load, not from TG's database.
/obj/structure/bookcase/load_shelf()
	if(!rogue_library_enabled())
		return ..()
	SSrogue_library.queue_shelf(src)

/// The section a random bookcase is stocked from; null for an unsorted one.
/obj/structure/bookcase/proc/rogue_shelf_category()
	if(!random_category || random_category == BOOK_CATEGORY_RANDOM)
		return null
	return random_category

/// Ratwood's /obj/structure/bookcase/random stock_books(): 10 books less a random cut, more for an archive bookcase.
/obj/structure/bookcase/proc/rogue_stock()
	if(!load_random_books)
		return
	var/books = ROGUE_SHELF_BOOKS - pick(ROGUE_SHELF_BOOK_CUTS)
	if(rogue_extra_stock)
		books += rand(0, ROGUE_SHELF_EXTRA_BOOKS)
	rogue_spawn_random_books(min(books, ROGUE_SHELF_MAX_BOOKS - length(contents)), src, rogue_shelf_category())
	update_appearance(UPDATE_ICON_STATE)

/// Ratwood /obj/structure/bookcase/random/archive: an unsorted bookcase with more books.
/obj/structure/bookcase/random/rogue_archive
	name = "bookcase"
	rogue_extra_stock = TRUE

/// Ratwood /obj/structure/bookcase/random/misc: no premade book is filed under Misc, so it holds archived player books only.
/obj/structure/bookcase/random/rogue_misc
	name = "bookcase (Misc)"
	random_category = ROGUE_BOOK_CATEGORY_MISC

/// Ratwood /obj/structure/bookcase/player_archive: random archived player books of any section. They do not count as
/// shelved, so the same books can turn up on other bookcases too.
/obj/structure/bookcase/rogue_player_archive
	name = "bookcase (Archive)"

/obj/structure/bookcase/rogue_player_archive/rogue_stock()
	var/datum/rogue_book_archive/archive = rogue_book_archive()
	if(!archive)
		return
	var/list/titles = archive.usable_titles(include_placed = TRUE)
	for(var/book in 1 to min(ROGUE_ARCHIVE_SHELF_BOOKS, ROGUE_SHELF_MAX_BOOKS - length(contents), length(titles)))
		new /obj/item/book/rogue/playerbook(src, pick_n_take(titles))
	update_appearance(UPDATE_ICON_STATE)

/// Ratwood /obj/structure/bookcase/random_recipes: one copy of every profession manual.
/obj/structure/bookcase/rogue_recipes
	name = "bookcase (Recipes)"

/obj/structure/bookcase/rogue_recipes/rogue_stock()
	var/list/manuals = subtypesof(/obj/item/recipe_book)
	for(var/book in 1 to min(length(manuals), ROGUE_SHELF_MAX_BOOKS - length(contents)))
		var/manual_type = pick_n_take(manuals)
		new manual_type(src)
	update_appearance(UPDATE_ICON_STATE)

/// Puts a TG bookcase where a porter's stub bookcase stands.
/proc/rogue_library_replace_shelf(obj/structure/stub, shelf_type)
	var/obj/structure/bookcase/shelf = new shelf_type(stub.loc)
	shelf.setDir(stub.dir)
	shelf.pixel_x = stub.pixel_x
	shelf.pixel_y = stub.pixel_y

/obj/structure/bookcase/random/archive/Initialize(mapload)
	..()
	rogue_library_replace_shelf(src, /obj/structure/bookcase/random/rogue_archive)
	return INITIALIZE_HINT_QDEL

/obj/structure/bookcase/random/misc/Initialize(mapload)
	..()
	rogue_library_replace_shelf(src, /obj/structure/bookcase/random/rogue_misc)
	return INITIALIZE_HINT_QDEL

/obj/structure/bookcase/player_archive/Initialize(mapload)
	..()
	rogue_library_replace_shelf(src, /obj/structure/bookcase/rogue_player_archive)
	return INITIALIZE_HINT_QDEL

/obj/structure/bookcase/random_recipes/Initialize(mapload)
	..()
	rogue_library_replace_shelf(src, /obj/structure/bookcase/rogue_recipes)
	return INITIALIZE_HINT_QDEL

/// Ratwood /obj/item/book/random: on medieval maps a random premade book in its place instead of TG's database book.
/obj/item/book/random/Initialize(mapload)
	. = ..()
	if(!rogue_library_enabled())
		return
	rogue_spawn_random_books(1, loc, null)
	if(istype(loc, /obj/structure/bookcase))
		loc.update_appearance(UPDATE_ICON_STATE)
	return INITIALIZE_HINT_QDEL
