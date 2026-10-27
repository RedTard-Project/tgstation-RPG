/// The chat panel with Vibelin's translation (localization/code/chat/panel_hooks.dm). The panel's bundle is the module's
/// tgui-rogue-panel: TG's tgui-panel whole, plus the translation engine that rewrites each message as it lands
/// (modular_redtard/tgui/rogue_panel). It is served under TG's file names, so TG's panel code loads it unchanged.
#ifdef TGS
/datum/asset/simple/tgui_panel
	assets = list(
		"tgui-panel.bundle.js" = "tgui/public/tgui-rogue-panel.bundle.js",
		"tgui-panel.bundle.css" = "tgui/public/tgui-rogue-panel.bundle.css",
	)
#else
/datum/asset/simple/tgui_panel
	assets = list(
		"tgui-panel.bundle.js" = file("tgui/public/tgui-rogue-panel.bundle.js"),
		"tgui-panel.bundle.css" = file("tgui/public/tgui-rogue-panel.bundle.css"),
	)
#endif

/// The player's language and where the dictionary lies.
/datum/tgui_panel/proc/rogue_send_language()
	if(!is_ready())
		return
	window.send_message("localization/config", list(
		"lang" = rogue_ui_lang(client),
		"dictionaryUrl" = SSassets.transport.get_asset_url("rogue_chat_localization.json"),
	))

/// Character names' cases (declensions.dm), by name.
/datum/tgui_panel/proc/rogue_send_declensions(list/payload)
	if(!length(payload) || !is_ready())
		return
	window.send_message("localization/declensions", payload)

/// On the panel's own "ready" rather than in initialize(), which returns at its first sleep, before the window is up.
/datum/tgui_panel/on_message(type, payload)
	. = ..()
	if(type != "ready")
		return
	window.send_asset(get_asset_datum(/datum/asset/json/rogue_chat_localization))
	rogue_send_language()
	rogue_send_declensions(GLOB.rogue_chat_declensions)
