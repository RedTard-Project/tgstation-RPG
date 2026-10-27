// Stage 7: library and the persistent world. Cross-file defines of the library module.

/// Ratwood's archive of player books (code/__HELPERS/player_archives.dm): one JSON file per book in Ratwood's own folder and
/// format, so an archive brought over from a Ratwood server loads as it is.
#define ROGUE_BOOK_ARCHIVE_DIR "data/player_generated_books/"
/// The archive's file of players barred from adding books, beside the books.
#define ROGUE_BOOK_BANS_FILE "_upload_bans.json"
/// The title index of Ratwood's older archive, still lying in old folders; not a book.
#define ROGUE_BOOK_OLD_INDEX_FILE "_book_titles.json"
/// Longest file name of an archived book (Ratwood refuses longer titles). A longer url-encoded title, as any Cyrillic one
/// of twenty-five letters, is stored under its hash instead.
#define ROGUE_BOOK_FILE_NAME_MAX 150

/// The texts of Ratwood's premade books (strings/books, the files Ratwood reads, taken from Azure Peak).
#define ROGUE_BOOK_TEXTS_DIR "modular_redtard/library/books/"

/// The category of player books filed under none of the others (Ratwood PLAYER_BOOK_DEFAULT_CATEGORY).
#define ROGUE_BOOK_CATEGORY_MISC "Misc"

/// Ratwood's text of a book whose archived entry is gone or broken.
#define ROGUE_BOOK_RUINED_TEXT "moisture in the air or water leaks have rendered the carefully written caligraphy of this book unreadable"

#define ROGUE_BOOK_OPEN_SOUND 'modular_redtard/rockhill/sound/items/book_open.ogg'
#define ROGUE_BOOK_CLOSE_SOUND 'modular_redtard/rockhill/sound/items/book_close.ogg'
#define ROGUE_BOOK_PAGE_SOUND 'modular_redtard/rockhill/sound/items/book_page.ogg'
#define ROGUE_PRESS_SOUND 'modular_redtard/library/sound/ppress.ogg'

/// Ratwood's bookcase sprites: eight looks, each drawn with 1 to 15 books ("a1" ... "h15") or empty ("bookcase").
#define ROGUE_SHELF_ICON 'modular_redtard/rockhill/icons/roguetown/misc/bookshelf.dmi'
#define ROGUE_SHELF_STYLES list("a", "b", "c", "d", "e", "f", "g", "h")
#define ROGUE_SHELF_EMPTY_STATE "bookcase"
/// The most books a shelf is stocked with, matching the filled sprites (Ratwood max_books).
#define ROGUE_SHELF_MAX_BOOKS 15
/// Ratwood's cut off the books of a random bookcase: 0 to 5, mostly 5 (pick(-5, -5, ... 0)).
#define ROGUE_SHELF_BOOK_CUTS list(5, 5, 5, 5, 5, 4, 4, 4, 4, 3, 3, 3, 2, 2, 1, 1, 0)

/// Ratwood's quill: a feather writes on paper in this hand and ink.
#define ROGUE_QUILL_FONT FOUNTAIN_PEN_FONT
#define ROGUE_QUILL_INK "black"

// Numbers of the mechanics registry (config/redtard/mechanics/values.txt).
#define ROGUE_PRESS_PRINT_TIME rogue_value("library_print_time")
#define ROGUE_PRESS_COOLDOWN rogue_value("library_print_cooldown")
#define ROGUE_SHELF_BOOKS rogue_value("library_shelf_books")
#define ROGUE_SHELF_EXTRA_BOOKS rogue_value("library_shelf_extra_books")
#define ROGUE_ARCHIVE_SHELF_BOOKS rogue_value("library_archive_shelf_books")
#define ROGUE_MANUSCRIPT_PAGES rogue_value("library_manuscript_pages")
#define ROGUE_PLAYER_BOOK_CHANCE_MIN rogue_value("library_player_book_chance_min")
#define ROGUE_PLAYER_BOOK_CHANCE_MAX rogue_value("library_player_book_chance_max")
#define ROGUE_BOOK_KIT_CHANCE rogue_value("library_book_kit_chance")
