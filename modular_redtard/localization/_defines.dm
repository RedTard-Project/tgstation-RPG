/// Vibelin's localization (modular_abel/localization): the player picks Russian or English; the server always speaks
/// English and the Russian is laid over it, in the chat by the player's own panel and in examine and character setup
/// by the server. The dictionaries are Vibelin's strings/ files.

#define ROGUE_LANG_RU "ru"
#define ROGUE_LANG_EN "en"

/// The choices of the language preference, as the player reads them.
#define ROGUE_LANGUAGE_RUSSIAN "Русский"
#define ROGUE_LANGUAGE_ENGLISH "English"

#define ROGUE_LOCALIZATION_STRINGS "modular_redtard/localization/strings"
/// A strings line is "key = value", split at the first " = ".
#define ROGUE_LOCALIZATION_SEPARATOR " = "
/// In a strings file the server's engine reads (translate.dm), a key that starts with this is a pattern.
#define ROGUE_LOCALIZATION_PATTERN_MARK "^"
/// Texts a dictionary of the server's engine remembers before it starts over (the panel keeps as many).
#define ROGUE_TRANSLATE_CACHE_LIMIT 4000
/// How deep a composed name may sit inside another ("masterwork iron sword").
#define ROGUE_TRANSLATE_DEPTH 2
