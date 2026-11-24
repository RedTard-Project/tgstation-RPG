/// Vibelin's tomes of the arcyne (items/spellbooks/, datums/mana/mastery/_base.dm): a tome keeps a spellbook of its own -
/// form and technique points, spells learned into it - and its owner, opening it in hand, casts those spells while
/// holding it. A tome's spell is paid with the tome's charges (magic_book_charges, or the spell's own _charges) besides
/// its mana; charges come back at the recharging rune (block ВМ2). A themed starter tome ranks up its form and makes
/// spells of that form cheaper, quicker and stronger while held. One less versed in the arcyne than the owner, and not
/// chained to the tome, gets a shock for trying. Medieval maps only (rogue_magic_enabled()).

/// Charges a tome gives a spell (Vibelin initial_charges, x3 for a spell without a technique: "ONCE WE BALANCE REMOVE").
/proc/rogue_book_charges_of(spell_type)
	var/charges = rogue_spell_tune(spell_type, "charges")
	if(charges > 0)
		return charges
	charges = rogue_value("magic_book_charges")
	var/datum/action/cooldown/spell/rogue/path = spell_type
	if(ispath(path, /datum/action/cooldown/spell/rogue) && !initial(path.required_technique))
		charges *= rogue_value("magic_book_charges_untechniqued_mult")
	return charges

/obj/item/rogue_spellbook
	name = "tome of the arcyne"
	desc = "A crackling, glowing book, filled with runes and symbols that hurt the mind to stare at."
	icon = ROGUE_TOMES_ICON
	icon_state = "spellbookbrown_0"
	base_icon_state = "spellbookbrown"
	lefthand_file = ROGUE_TOMES_LEFTHAND
	righthand_file = ROGUE_TOMES_RIGHTHAND
	inhand_icon_state = "spellbookbrown_0"
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	w_class = WEIGHT_CLASS_NORMAL
	// Vibelin ITEM_SLOT_HIP: the hips of this port are the pockets, drawn from the baked hip sheet of the tomes.
	slot_flags = ITEM_SLOT_POCKETS
	rogue_onmob_sheet = 'modular_redtard/rockhill/icons/baked/roguetown/items/books_onmob.dmi'
	rogue_onmob_state = "spellbookbrown_0"
	force = 5
	resistance_flags = FLAMMABLE
	drop_sound = 'modular_redtard/rockhill/sound/items/book_close.ogg'
	rogue_grid_width = 32
	rogue_grid_height = 64
	/// The rung of Vibelin's ladder (ROGUE_TOME_TIER_*): the key of its numbers.
	var/tier = ROGUE_TOME_TIER_APPRENTICE
	/// The one who bound the tome: the first to open it, or its maker (weak: a tome outlives its owner).
	var/datum/weakref/owner_ref
	/// Weak references to up to magic_book_allowed_readers more who may read it: beaten over the head with it (Vibelin).
	var/list/datum/weakref/allowed_readers = list()
	/// Covers to choose from on the first right click; one cover is taken at once.
	var/list/designlist = list("green", "yellow", "brown")
	var/picked = FALSE
	var/open = FALSE
	/// A starter tome of one form (Vibelin spellbooks/*/starter): its form ranks up and its spells are better while held.
	var/themed_form
	var/starter = FALSE
	/// Made from a magic stone rather than a gem (spellcraft.dm).
	var/born_of_rock = FALSE
	var/datum/rogue_spell_mastery/mastery
	/// What the tome does to spells of a form or technique while worn or held, in the entries of the spell base's
	/// COMSIG_ROGUE_SPELL_REQUEST_MODIFIERS (block ВМ1б): list(ROGUE_SPELLMOD_FORM or _TECHNIQUE = track, the factors).
	var/list/spell_modifiers = list()
	/// Who wears or holds it now and is asked for its modifiers.
	var/mob/living/modified_holder

/obj/item/rogue_spellbook/Initialize(mapload)
	. = ..()
	mastery = new /datum/rogue_spell_mastery(null, src)
	if(starter && themed_form)
		apply_theme()
	if(length(designlist) == 1)
		set_design(designlist[1])

/obj/item/rogue_spellbook/Destroy()
	stop_modifying()
	QDEL_NULL(mastery)
	owner_ref = null
	allowed_readers = null
	return ..()

/// The one the tome is bound to, while that mob still exists.
/obj/item/rogue_spellbook/proc/get_owner()
	RETURN_TYPE(/mob/living)
	return owner_ref?.resolve()

/obj/item/rogue_spellbook/rogue_charge_mastery()
	return mastery

/obj/item/rogue_spellbook/proc/set_design(design)
	base_icon_state = "spellbook[design]"
	picked = TRUE
	update_appearance(UPDATE_ICON_STATE)

/obj/item/rogue_spellbook/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]_[open]"

/// Vibelin apply_themed_bonuses() of a starter tome: points by its quality, half of the form points straight into its form,
/// and its form's spells cheaper, quicker and stronger.
/obj/item/rogue_spellbook/proc/apply_theme()
	var/list/flavor = rogue_tome_theme_flavor(themed_form)
	if(flavor[1])
		name = "[initial(name)], [flavor[1]]"
	if(flavor[2])
		desc = "[initial(desc)] [flavor[2]]"
	var/scale = rogue_value("magic_book_[tier]_quality") / rogue_value("magic_book_theme_baseline_quality")
	var/form_points = CEILING(rogue_value("magic_book_theme_baseline_form_points") * scale, 1)
	var/technique_points = CEILING(rogue_value("magic_book_theme_baseline_technique_points") * scale, 1)
	var/themed_points = CEILING(form_points * rogue_value("magic_book_theme_form_share"), 1)
	mastery.give_form_points(themed_points, themed_form)
	if(form_points - themed_points > 0)
		mastery.give_form_points(form_points - themed_points)
	mastery.give_technique_points(technique_points)
	add_spell_modifier(ROGUE_SPELLMOD_FORM, themed_form, rogue_value("magic_book_[tier]_theme_cost"), rogue_value("magic_book_[tier]_theme_castspeed"), rogue_value("magic_book_[tier]_theme_magnitude"))

/// One entry of the tome's modifiers (Vibelin spell_modifier component): cost and cast speed multiply, magnitude adds.
/obj/item/rogue_spellbook/proc/add_spell_modifier(kind, track, cost = 1, castspeed = 1, magnitude = 0)
	if(!track || (cost == 1 && castspeed == 1 && magnitude == 0))
		return
	var/list/entry = list(ROGUE_SPELLMOD_COST = cost, ROGUE_SPELLMOD_CASTSPEED = castspeed, ROGUE_SPELLMOD_MAGNITUDE = magnitude)
	entry[kind] = track
	spell_modifiers += list(entry)

/obj/item/rogue_spellbook/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	start_modifying(user)
	if(open && (slot & ITEM_SLOT_HANDS))
		try_give_spells(user)

/obj/item/rogue_spellbook/dropped(mob/user, silent = FALSE)
	. = ..()
	stop_modifying()
	mastery?.withdraw_spells()
	if(open)
		set_open(FALSE, null)

/obj/item/rogue_spellbook/proc/start_modifying(mob/living/user)
	if(modified_holder == user || !length(spell_modifiers) || !istype(user))
		return
	stop_modifying()
	modified_holder = user
	RegisterSignal(user, COMSIG_ROGUE_SPELL_REQUEST_MODIFIERS, PROC_REF(on_request_modifiers))

/obj/item/rogue_spellbook/proc/stop_modifying()
	if(!modified_holder)
		return
	UnregisterSignal(modified_holder, COMSIG_ROGUE_SPELL_REQUEST_MODIFIERS)
	modified_holder = null

/obj/item/rogue_spellbook/proc/on_request_modifiers(datum/source, list/out)
	SIGNAL_HANDLER
	for(var/list/entry as anything in spell_modifiers)
		out += list(entry.Copy())

/// Vibelin is_open() and add_spells(): an open tome in the hands of its owner, or of one it lets read it.
/obj/item/rogue_spellbook/proc/try_give_spells(mob/living/user)
	if(!rogue_magic_enabled() || !istype(user) || loc != user || !open)
		return
	if(!readable_by(user, recoil = FALSE))
		return
	mastery.give_spells(user)

/// Vibelin compare_magic(): the owner and those chained to the tome read it; anyone else only if no less versed in the
/// arcyne than the owner, or they take a shock.
/obj/item/rogue_spellbook/proc/readable_by(mob/living/user, recoil = TRUE)
	var/mob/living/owner = get_owner()
	if(!owner || user == owner || (WEAKREF(user) in allowed_readers))
		return TRUE
	if(ROGUE_NULLTOZERO(user.rogue_skill(/datum/attribute/skill/magic/arcane)) >= ROGUE_NULLTOZERO(owner.rogue_skill(/datum/attribute/skill/magic/arcane)))
		return TRUE
	if(recoil)
		user.visible_message(span_warning("[src] shoots out a spark of angry, arcyne energy at [user]!"))
		user.electrocute_act(rogue_value("magic_book_recoil_shock"), src)
	return FALSE

/// Vibelin attack_self(): an open tome shows its spellbook; a shut one opens.
/obj/item/rogue_spellbook/attack_self(mob/user, modifiers)
	. = ..()
	if(.)
		return
	if(!open)
		toggle(user)
		return TRUE
	if(!rogue_magic_enabled())
		to_chat(user, span_warning("The runes are dead ink here."))
		return TRUE
	if(!readable_by(user))
		return TRUE
	try_give_spells(user)
	mastery.show_book(user)
	return TRUE

/// Vibelin attack_hand_secondary(): the first right click picks the cover, the next ones open and shut it.
/obj/item/rogue_spellbook/attack_self_secondary(mob/user, modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	toggle(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/rogue_spellbook/proc/toggle(mob/living/user)
	if(!picked)
		INVOKE_ASYNC(src, PROC_REF(pick_design), user)
		return
	if(!(src in user.held_items))
		return
	if(!get_owner())
		owner_ref = WEAKREF(user)
	if(!readable_by(user))
		return
	set_open(!open, user)

/obj/item/rogue_spellbook/proc/pick_design(mob/user)
	var/design = tgui_input_list(user, "Select a design.", "Spellbook Design", designlist, timeout = 30 SECONDS)
	if(!design || picked || QDELETED(src))
		return
	set_design(design)

/// An open tome does not go on the belt (Vibelin): its spells are for the hands.
/obj/item/rogue_spellbook/proc/set_open(new_open, mob/living/user)
	open = new_open
	if(open)
		slot_flags &= ~ITEM_SLOT_BELT
		playsound(src, ROGUE_TOME_OPEN_SOUND, 100, FALSE, -1)
		try_give_spells(user)
	else
		slot_flags |= ITEM_SLOT_BELT
		if(user)
			playsound(src, ROGUE_TOME_CLOSE_SOUND, 100, FALSE, -1)
		mastery?.withdraw_spells()
	update_appearance(UPDATE_ICON_STATE)
	if(ismob(loc))
		var/mob/holder = loc
		holder.update_held_items()

/obj/item/rogue_spellbook/examine(mob/user)
	. = ..()
	var/mob/living/owner = get_owner()
	if(owner)
		. += span_notice("It is bound to [owner == user ? "me" : owner.name].")
	if(mastery && length(mastery.learned))
		. += span_notice("It holds [length(mastery.learned)] spell\s.")

/// Vibelin: beating someone over the head with the tome chains them to it, so they may read it too.
/obj/item/rogue_spellbook/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with) || user != get_owner() || interacting_with == user)
		return NONE
	var/mob/living/target = interacting_with
	if(target.stat == DEAD)
		return NONE
	var/datum/weakref/target_ref = WEAKREF(target)
	if(length(allowed_readers) >= rogue_value("magic_book_allowed_readers") || (target_ref in allowed_readers))
		to_chat(user, span_smallnotice("I can't chain [target.p_them()] to my tome..."))
		return NONE
	allowed_readers += target_ref
	target.visible_message(span_danger("[user] beats [target] over the head with [src]!"))
	return NONE

/// Vibelin get_theme_flavor().
/proc/rogue_tome_theme_flavor(form)
	switch(form)
		if(ROGUE_FORM_FIRE)
			return list("aflame", "Faint heat radiates from its pages, and its runes are all subtly singed.")
		if(ROGUE_FORM_ICE)
			return list("frostbound", "Its pages are cool to the touch, rimed with a frost that never quite melts.")
		if(ROGUE_FORM_LIGHTNING)
			return list("storm-charged", "Tiny sparks crawl between its runes whenever the cover is opened.")
		if(ROGUE_FORM_EARTH)
			return list("stoneveined", "Its binding is threaded with fine mineral veins, heavy as river stone.")
		if(ROGUE_FORM_ARCANE)
			return list("thrice-warded", "Its script folds in on itself in ways the eye struggles to follow.")
		if(ROGUE_FORM_DEATH)
			return list("grave-touched", "A faint chill of the grave lingers about its pages.")
		if(ROGUE_FORM_LIFE)
			return list("verdant", "Its margins are traced with fine, living green filigree.")
		if(ROGUE_FORM_AIR)
			return list("windswept", "Its pages riffle gently even in still air.")
		if(ROGUE_FORM_WATER)
			return list("tidebound", "Condensation beads along its cover no matter how dry the room.")
		if(ROGUE_FORM_BLOOD)
			return list("blood-soaked", "The cloying smell of metal clings to the pages as endless blood seeps between them.")
	return list(null, null)

// Vibelin's ladder (spellbooks/spellbook.dm). Its sell prices: the economy's numbers, not set here.
/obj/item/rogue_spellbook/horrible
	name = "poorly made tome of the arcyne"
	desc = "A poorly made book, it barely glows with arcyne and has only small notes on arcyne symbols."
	tier = ROGUE_TOME_TIER_HORRIBLE

/obj/item/rogue_spellbook/mid
	name = "beginners tome of the arcyne"
	desc = "An obviously handcrafted book, it glows occasionally with arcyne and has a meager amount of notes on arcyne symbols."
	tier = ROGUE_TOME_TIER_MID

/obj/item/rogue_spellbook/apprentice
	name = "apprentice tome of the arcyne"
	desc = "A carefully made book, faintly glowing with arcyne and half filled with notes and theory on arcyne symbols."
	tier = ROGUE_TOME_TIER_APPRENTICE

/obj/item/rogue_spellbook/adept
	name = "adept tome of the arcyne"
	desc = "A well-made book, it shines moderately with arcyne light. It has been filled with notes of varying degrees on the arcyne."
	tier = ROGUE_TOME_TIER_ADEPT

/obj/item/rogue_spellbook/expert
	name = "expert tome of the arcyne"
	desc = "A well cared for book, shining brightly with arcyne. It has many runes and arcyne symbols scribed within, with detailed notes."
	tier = ROGUE_TOME_TIER_EXPERT

/obj/item/rogue_spellbook/master
	name = "masterful tome of the arcyne"
	desc = "A crackling, glowing book, filled with advanced arcyne runes and symbols that hurt the mind to stare at. A true master of the arcyne has left their mark behind."
	tier = ROGUE_TOME_TIER_MASTER

/obj/item/rogue_spellbook/legendary
	name = "legendary tome of the arcyne"
	desc = "An incredible book that gives off glowing arcyne motes, it is filled with runes and arcyne theories that is hard for even masters of arcyne to understand. The arcyne script glows and practically whispers from the page..."
	tier = ROGUE_TOME_TIER_LEGENDARY

// Themed starter tomes (generated by vm1v_gen_starters.py): a role picks one (Vibelin roguemage.dm and the court mages); a family, not a tome.
/obj/item/rogue_spellbook/horrible/starter
	starter = TRUE

/obj/item/rogue_spellbook/horrible/starter/fire
	themed_form = ROGUE_FORM_FIRE
	designlist = list("steel")

/obj/item/rogue_spellbook/horrible/starter/ice
	themed_form = ROGUE_FORM_ICE
	designlist = list("steel")

/obj/item/rogue_spellbook/horrible/starter/lightning
	themed_form = ROGUE_FORM_LIGHTNING
	designlist = list("steel")

/obj/item/rogue_spellbook/horrible/starter/earth
	themed_form = ROGUE_FORM_EARTH
	designlist = list("steel")

/obj/item/rogue_spellbook/horrible/starter/arcane
	themed_form = ROGUE_FORM_ARCANE
	designlist = list("gem")

/obj/item/rogue_spellbook/horrible/starter/death
	themed_form = ROGUE_FORM_DEATH
	designlist = list("skin")

/obj/item/rogue_spellbook/horrible/starter/life
	themed_form = ROGUE_FORM_LIFE
	designlist = list("mimic")

/obj/item/rogue_spellbook/horrible/starter/air
	themed_form = ROGUE_FORM_AIR
	designlist = list("steel")

/obj/item/rogue_spellbook/horrible/starter/water
	themed_form = ROGUE_FORM_WATER
	designlist = list("steel")

/obj/item/rogue_spellbook/horrible/starter/blood
	themed_form = ROGUE_FORM_BLOOD
	designlist = list("blood")

/obj/item/rogue_spellbook/mid/starter
	starter = TRUE

/obj/item/rogue_spellbook/mid/starter/fire
	themed_form = ROGUE_FORM_FIRE
	designlist = list("steel")

/obj/item/rogue_spellbook/mid/starter/ice
	themed_form = ROGUE_FORM_ICE
	designlist = list("steel")

/obj/item/rogue_spellbook/mid/starter/lightning
	themed_form = ROGUE_FORM_LIGHTNING
	designlist = list("steel")

/obj/item/rogue_spellbook/mid/starter/earth
	themed_form = ROGUE_FORM_EARTH
	designlist = list("steel")

/obj/item/rogue_spellbook/mid/starter/arcane
	themed_form = ROGUE_FORM_ARCANE
	designlist = list("gem")

/obj/item/rogue_spellbook/mid/starter/death
	themed_form = ROGUE_FORM_DEATH
	designlist = list("skin")

/obj/item/rogue_spellbook/mid/starter/life
	themed_form = ROGUE_FORM_LIFE
	designlist = list("mimic")

/obj/item/rogue_spellbook/mid/starter/air
	themed_form = ROGUE_FORM_AIR
	designlist = list("steel")

/obj/item/rogue_spellbook/mid/starter/water
	themed_form = ROGUE_FORM_WATER
	designlist = list("steel")

/obj/item/rogue_spellbook/mid/starter/blood
	themed_form = ROGUE_FORM_BLOOD
	designlist = list("blood")

/obj/item/rogue_spellbook/apprentice/starter
	starter = TRUE

/obj/item/rogue_spellbook/apprentice/starter/fire
	themed_form = ROGUE_FORM_FIRE
	designlist = list("steel")

/obj/item/rogue_spellbook/apprentice/starter/ice
	themed_form = ROGUE_FORM_ICE
	designlist = list("steel")

/obj/item/rogue_spellbook/apprentice/starter/lightning
	themed_form = ROGUE_FORM_LIGHTNING
	designlist = list("steel")

/obj/item/rogue_spellbook/apprentice/starter/earth
	themed_form = ROGUE_FORM_EARTH
	designlist = list("steel")

/obj/item/rogue_spellbook/apprentice/starter/arcane
	themed_form = ROGUE_FORM_ARCANE
	designlist = list("gem")

/obj/item/rogue_spellbook/apprentice/starter/death
	themed_form = ROGUE_FORM_DEATH
	designlist = list("skin")

/obj/item/rogue_spellbook/apprentice/starter/life
	themed_form = ROGUE_FORM_LIFE
	designlist = list("mimic")

/obj/item/rogue_spellbook/apprentice/starter/air
	themed_form = ROGUE_FORM_AIR
	designlist = list("steel")

/obj/item/rogue_spellbook/apprentice/starter/water
	themed_form = ROGUE_FORM_WATER
	designlist = list("steel")

/obj/item/rogue_spellbook/apprentice/starter/blood
	themed_form = ROGUE_FORM_BLOOD
	designlist = list("blood")

/obj/item/rogue_spellbook/adept/starter
	starter = TRUE

/obj/item/rogue_spellbook/adept/starter/fire
	themed_form = ROGUE_FORM_FIRE
	designlist = list("steel")

/obj/item/rogue_spellbook/adept/starter/ice
	themed_form = ROGUE_FORM_ICE
	designlist = list("steel")

/obj/item/rogue_spellbook/adept/starter/lightning
	themed_form = ROGUE_FORM_LIGHTNING
	designlist = list("steel")

/obj/item/rogue_spellbook/adept/starter/earth
	themed_form = ROGUE_FORM_EARTH
	designlist = list("steel")

/obj/item/rogue_spellbook/adept/starter/arcane
	themed_form = ROGUE_FORM_ARCANE
	designlist = list("gem")

/obj/item/rogue_spellbook/adept/starter/death
	themed_form = ROGUE_FORM_DEATH
	designlist = list("skin")

/obj/item/rogue_spellbook/adept/starter/life
	themed_form = ROGUE_FORM_LIFE
	designlist = list("mimic")

/obj/item/rogue_spellbook/adept/starter/air
	themed_form = ROGUE_FORM_AIR
	designlist = list("steel")

/obj/item/rogue_spellbook/adept/starter/water
	themed_form = ROGUE_FORM_WATER
	designlist = list("steel")

/obj/item/rogue_spellbook/adept/starter/blood
	themed_form = ROGUE_FORM_BLOOD
	designlist = list("blood")

/obj/item/rogue_spellbook/expert/starter
	starter = TRUE

/obj/item/rogue_spellbook/expert/starter/fire
	themed_form = ROGUE_FORM_FIRE
	designlist = list("steel")

/obj/item/rogue_spellbook/expert/starter/ice
	themed_form = ROGUE_FORM_ICE
	designlist = list("steel")

/obj/item/rogue_spellbook/expert/starter/lightning
	themed_form = ROGUE_FORM_LIGHTNING
	designlist = list("steel")

/obj/item/rogue_spellbook/expert/starter/earth
	themed_form = ROGUE_FORM_EARTH
	designlist = list("steel")

/obj/item/rogue_spellbook/expert/starter/arcane
	themed_form = ROGUE_FORM_ARCANE
	designlist = list("gem")

/obj/item/rogue_spellbook/expert/starter/death
	themed_form = ROGUE_FORM_DEATH
	designlist = list("skin")

/obj/item/rogue_spellbook/expert/starter/life
	themed_form = ROGUE_FORM_LIFE
	designlist = list("mimic")

/obj/item/rogue_spellbook/expert/starter/air
	themed_form = ROGUE_FORM_AIR
	designlist = list("steel")

/obj/item/rogue_spellbook/expert/starter/water
	themed_form = ROGUE_FORM_WATER
	designlist = list("steel")

/obj/item/rogue_spellbook/expert/starter/blood
	themed_form = ROGUE_FORM_BLOOD
	designlist = list("blood")

/obj/item/rogue_spellbook/master/starter
	starter = TRUE

/obj/item/rogue_spellbook/master/starter/fire
	themed_form = ROGUE_FORM_FIRE
	designlist = list("steel")

/obj/item/rogue_spellbook/master/starter/ice
	themed_form = ROGUE_FORM_ICE
	designlist = list("steel")

/obj/item/rogue_spellbook/master/starter/lightning
	themed_form = ROGUE_FORM_LIGHTNING
	designlist = list("steel")

/obj/item/rogue_spellbook/master/starter/earth
	themed_form = ROGUE_FORM_EARTH
	designlist = list("steel")

/obj/item/rogue_spellbook/master/starter/arcane
	themed_form = ROGUE_FORM_ARCANE
	designlist = list("gem")

/obj/item/rogue_spellbook/master/starter/death
	themed_form = ROGUE_FORM_DEATH
	designlist = list("skin")

/obj/item/rogue_spellbook/master/starter/life
	themed_form = ROGUE_FORM_LIFE
	designlist = list("mimic")

/obj/item/rogue_spellbook/master/starter/air
	themed_form = ROGUE_FORM_AIR
	designlist = list("steel")

/obj/item/rogue_spellbook/master/starter/water
	themed_form = ROGUE_FORM_WATER
	designlist = list("steel")

/obj/item/rogue_spellbook/master/starter/blood
	themed_form = ROGUE_FORM_BLOOD
	designlist = list("blood")

/obj/item/rogue_spellbook/legendary/starter
	starter = TRUE

/obj/item/rogue_spellbook/legendary/starter/fire
	themed_form = ROGUE_FORM_FIRE
	designlist = list("steel")

/obj/item/rogue_spellbook/legendary/starter/ice
	themed_form = ROGUE_FORM_ICE
	designlist = list("steel")

/obj/item/rogue_spellbook/legendary/starter/lightning
	themed_form = ROGUE_FORM_LIGHTNING
	designlist = list("steel")

/obj/item/rogue_spellbook/legendary/starter/earth
	themed_form = ROGUE_FORM_EARTH
	designlist = list("steel")

/obj/item/rogue_spellbook/legendary/starter/arcane
	themed_form = ROGUE_FORM_ARCANE
	designlist = list("gem")

/obj/item/rogue_spellbook/legendary/starter/death
	themed_form = ROGUE_FORM_DEATH
	designlist = list("skin")

/obj/item/rogue_spellbook/legendary/starter/life
	themed_form = ROGUE_FORM_LIFE
	designlist = list("mimic")

/obj/item/rogue_spellbook/legendary/starter/air
	themed_form = ROGUE_FORM_AIR
	designlist = list("steel")

/obj/item/rogue_spellbook/legendary/starter/water
	themed_form = ROGUE_FORM_WATER
	designlist = list("steel")

/obj/item/rogue_spellbook/legendary/starter/blood
	themed_form = ROGUE_FORM_BLOOD
	designlist = list("blood")
