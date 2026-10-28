/// Ratwood's archive of player books (SSlibrarian, player_archives.dm): a book bound in the round can be added to it at the
/// printing press, and later rounds shelve and print it. Off - the archive is neither read nor written.
/datum/config_entry/flag/rogue_book_archive
	default = TRUE

/// Whether the Ratwood library runs (books, shelves, the press, manuscripts): on medieval maps, as the rest of the rogue
/// mechanics.
/proc/rogue_library_enabled()
	return rogue_combat_enabled()

/proc/rogue_book_archive_enabled()
	return CONFIG_GET(flag/rogue_book_archive)

/// Sections a player files a book under, matching the bookcases of the map (Ratwood player_book_categories).
GLOBAL_LIST_INIT(rogue_book_categories, list(
	BOOK_CATEGORY_FICTION,
	BOOK_CATEGORY_NONFICTION,
	BOOK_CATEGORY_RELIGION,
	BOOK_CATEGORY_ADULT,
	BOOK_CATEGORY_REFERENCE,
	ROGUE_BOOK_CATEGORY_MISC,
))

/// Covers a player picks for a book, by the closed sprite's name without "_0" (Ratwood player_book_icons).
GLOBAL_LIST_INIT(rogue_book_covers, list(
	"Sickly green with embossed bronze" = "book8",
	"Red with embossed toper" = "book7",
	"Purple with embossed obsidian" = "book6",
	"Brown with embossed obsidian" = "book5",
	"Yellow without embossed material" = "book4",
	"Blue without embossed material" = "book3",
	"Red without embossed material" = "book2",
	"Black without embossed material" = "book",
	"Green without embossed material" = "basic_book",
))
