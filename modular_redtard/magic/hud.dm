/// Vibelin's mana orb (/atom/movable/screen/mana, icons/mob/rogueheat.dmi mana10-mana120 and manaover): how full the pool is
/// against its soft cap, in tenths; past the soft cap it overflows. Shown to magic users only (TRAIT_ARCYNE) or while they
/// hold any mana above none; a click says the numbers. The medieval HUD adds it (hud/rogue_hud.dm, see the M1 report).
/atom/movable/screen/rogue/mana
	name = "mana"
	icon = ROGUE_MANA_ICON
	icon_state = "mana100"
	screen_loc = rogueui_mana
	layer = ROGUE_HUD_LAYER
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/rogue/mana/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	var/mob/owner = hud_owner?.mymob
	if(owner)
		RegisterSignal(owner, COMSIG_MOB_ROGUE_MANA_CHANGED, PROC_REF(refresh))
		RegisterSignals(owner, list(SIGNAL_ADDTRAIT(TRAIT_ARCYNE), SIGNAL_REMOVETRAIT(TRAIT_ARCYNE)), PROC_REF(on_attunement))
	on_attunement()

/// A magic user gets their pool with the trait (a mage class gives it at spawn), so the orb has something to show.
/atom/movable/screen/rogue/mana/proc/on_attunement()
	SIGNAL_HANDLER
	var/mob/living/carbon/human/owner = get_mob()
	if(ishuman(owner) && HAS_TRAIT(owner, TRAIT_ARCYNE))
		owner.rogue_get_mana()
	refresh()

/atom/movable/screen/rogue/mana/proc/refresh()
	SIGNAL_HANDLER
	var/mob/living/carbon/human/owner = get_mob()
	var/datum/rogue_mana/mana = ishuman(owner) ? owner.rogue_mana : null
	if(!mana || (!HAS_TRAIT(owner, TRAIT_ARCYNE) && mana.amount <= 0))
		icon_state = ""
		return
	// Vibelin set_parent(): tenths of the soft cap, at most 120; under a tenth it shows the lowest.
	var/filled = clamp(round(mana.amount / max(mana.softcap(), 1) * 100, 10), 10, 120)
	icon_state = "mana[filled == 110 ? 100 : filled]"

/atom/movable/screen/rogue/mana/Click(location, control, params)
	var/mob/living/carbon/human/owner = get_mob()
	if(usr != owner || !ishuman(owner) || !owner.rogue_mana)
		return
	to_chat(owner, span_info("<b>Mana:</b> [round(owner.rogue_mana.amount)] / [round(owner.rogue_mana.softcap())]"))
