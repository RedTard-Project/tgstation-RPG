// Ratwood polishing (roguejobs/blacksmith/items.dm: polishing_cream, armor_brush, remove_polish(), lose_polish(), metal_glint):
// anyone who can repair an item with a hammer (its anvilrepair skill, or Squire Knowledge, or Self-Sustenance) rubs polishing
// cream on it, scrubs it with the coarse side of a brush, brushes it with the fine side and washes it in water. A whole item
// washed after the fine brush shines: a tenth more integrity, +2 force (+3 wielded) and a glint; washed too early, the
// compound comes off. A masterwork from the anvil or a fine piece of pottery shines without it, and can be polished on top.
// Breaking the item (the module's broken: worn down to the armor failure share) takes the shine and the bonus away.

// Numbers of config/redtard/mechanics/values/crafting.txt.
#define POLISH_CREAM_USES rogue_value("polish_cream_uses")
#define POLISH_CREAM_LOW rogue_value("polish_cream_low")
/// Ratwood do_after(50 - SPD * 2) for the cream and (50 - STR * 1.5) for the brush, in deciseconds.
#define POLISH_TIME_BASE rogue_value("polish_time")
#define POLISH_CREAM_PER_SPEED rogue_value("polish_cream_per_speed")
#define POLISH_BRUSH_PER_STRENGTH rogue_value("polish_brush_per_strength")
#define POLISH_INTEGRITY_SHARE rogue_value("polish_integrity_share")
#define POLISH_FORCE_BONUS rogue_value("polish_force_bonus")
#define POLISH_WIELDED_BONUS rogue_value("polish_wielded_bonus")
#define POLISH_CREAM_COLOR "#635e65"
#define POLISH_SCRUBBED_COLOR "#9e9e9e"
#define POLISH_BRUSHED_COLOR "#cccccc"
#define POLISH_SCRUB_SOUNDS list('modular_redtard/crafting/sound/scrubbing1.ogg', 'modular_redtard/crafting/sound/scrubbing2.ogg')
#define POLISH_WASH_SOUND 'modular_redtard/crafting/sound/splishy.ogg'

/// Ratwood polished, polish_bonus and metal_glint on one item.
/datum/component/rogue_polish
	dupe_mode = COMPONENT_DUPE_UNIQUE
	/// ROGUE_POLISH_* (Ratwood polished).
	var/stage = ROGUE_POLISH_NONE
	/// Integrity the finished polish added; none for the own shine of a masterwork (Ratwood polish_bonus).
	var/bonus = 0
	/// Force the finished polish added in one hand and wielded, kept so a reloaded config takes back what was given.
	var/force_bonus = 0
	var/wielded_bonus = 0
	/// The item shines by itself (a masterwork, fine pottery): the glint stays while it is polished anew.
	var/masterwork = FALSE

/datum/component/rogue_polish/Initialize(new_stage = ROGUE_POLISH_NONE, shines = FALSE)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	masterwork = shines
	set_stage(new_stage)

/datum/component/rogue_polish/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(on_wash))
	RegisterSignal(parent, COMSIG_ITEM_INTERACTING_WITH_ATOM, PROC_REF(on_interact))
	RegisterSignal(parent, COMSIG_ATOM_INTEGRITY_CHANGED, PROC_REF(on_integrity_changed))

/datum/component/rogue_polish/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ATOM_EXAMINE, COMSIG_COMPONENT_CLEAN_ACT, COMSIG_ITEM_INTERACTING_WITH_ATOM, COMSIG_ATOM_INTEGRITY_CHANGED))

/datum/component/rogue_polish/Destroy(force)
	STOP_PROCESSING(SSobj, src)
	return ..()

/// The stage's look (Ratwood add_atom_colour at each step) and the glint of a finished or masterwork piece.
/datum/component/rogue_polish/proc/set_stage(new_stage)
	stage = new_stage
	var/obj/item/item = parent
	item.remove_atom_colour(FIXED_COLOUR_PRIORITY)
	switch(stage)
		if(ROGUE_POLISH_CREAM)
			item.add_atom_colour(POLISH_CREAM_COLOR, FIXED_COLOUR_PRIORITY)
		if(ROGUE_POLISH_SCRUBBED)
			item.add_atom_colour(POLISH_SCRUBBED_COLOR, FIXED_COLOUR_PRIORITY)
		if(ROGUE_POLISH_BRUSHED)
			item.add_atom_colour(POLISH_BRUSHED_COLOR, FIXED_COLOUR_PRIORITY)
	if(masterwork || stage == ROGUE_POLISH_DONE)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)

/// Polishing can start anew: never polished, or a masterwork's own shine without a polish on top.
/datum/component/rogue_polish/proc/can_start()
	return stage == ROGUE_POLISH_NONE || (stage == ROGUE_POLISH_DONE && !bonus)

/datum/component/rogue_polish/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	switch(stage)
		if(ROGUE_POLISH_CREAM)
			examine_list += span_info("It has some polishing compound on it.")
		if(ROGUE_POLISH_SCRUBBED, ROGUE_POLISH_BRUSHED)
			examine_list += span_info("It's been thoroughly brushed.")
		if(ROGUE_POLISH_DONE)
			examine_list += span_green("It's been nicely polished.")

/// Washing in a wooden bin of water or open water (Ratwood: the bin cleans what is dipped in it).
/datum/component/rogue_polish/proc/on_interact(obj/item/source, mob/living/user, atom/target, list/modifiers)
	SIGNAL_HANDLER
	if(stage == ROGUE_POLISH_NONE || stage == ROGUE_POLISH_DONE || user.combat_mode || !rogue_water_source(target))
		return NONE
	playsound(target, POLISH_WASH_SOUND, 80, TRUE, -1)
	user.visible_message(span_info("[user] washes [source] in [target]."))
	source.wash(CLEAN_WASH)
	return ITEM_INTERACT_SUCCESS

/// Ratwood remove_polish(): brushed fine and whole, the wash brings out the shine; at any other stage the compound comes off.
/datum/component/rogue_polish/proc/on_wash(datum/source, clean_types)
	SIGNAL_HANDLER
	if(stage == ROGUE_POLISH_NONE || stage == ROGUE_POLISH_DONE)
		return NONE
	var/obj/item/item = parent
	if(stage == ROGUE_POLISH_BRUSHED && item.get_integrity() >= item.max_integrity)
		finish()
		return COMPONENT_CLEANED
	if(masterwork)
		set_stage(ROGUE_POLISH_NONE)
	else
		qdel(src)
	return COMPONENT_CLEANED

/datum/component/rogue_polish/proc/finish()
	var/obj/item/item = parent
	bonus = ceil(item.max_integrity * POLISH_INTEGRITY_SHARE)
	item.modify_max_integrity(item.max_integrity + bonus, FALSE)
	item.repair_damage(bonus)
	force_bonus = POLISH_FORCE_BONUS
	wielded_bonus = POLISH_WIELDED_BONUS
	adjust_force(1)
	set_stage(ROGUE_POLISH_DONE)

/// The force bonus of a finished polish, on the item and on its two-handed grip (Ratwood force += 2, force_wielded += 3).
/datum/component/rogue_polish/proc/adjust_force(sign)
	var/obj/item/item = parent
	var/datum/component/two_handed/grip = item.GetComponent(/datum/component/two_handed)
	if(item.rogue_force_wielded)
		item.rogue_force_wielded += wielded_bonus * sign
	if(!grip)
		item.force += force_bonus * sign
		return
	grip.force_unwielded += force_bonus * sign
	grip.force_wielded += wielded_bonus * sign
	item.force += (grip.wielded ? wielded_bonus : force_bonus) * sign

/// Ratwood lose_polish() when the item breaks: the bonus, the shine and the glint go.
/datum/component/rogue_polish/proc/on_integrity_changed(datum/source, old_value, new_value)
	SIGNAL_HANDLER
	if(stage != ROGUE_POLISH_DONE && !masterwork)
		return
	var/obj/item/item = parent
	var/threshold = item.max_integrity * ROGUE_ARMOR_FAILURE_SHARE
	if(new_value > threshold || old_value <= threshold)
		return
	stage = ROGUE_POLISH_NONE
	masterwork = FALSE
	if(bonus)
		var/lost = bonus
		bonus = 0
		adjust_force(-1)
		item.modify_max_integrity(item.max_integrity - lost, FALSE)
	item.remove_atom_colour(FIXED_COLOUR_PRIORITY)
	qdel(src)

/// Ratwood metal_glint process(): a shining piece glints on the ground, and armor glints on its wearer.
/datum/component/rogue_polish/process(seconds_per_tick)
	var/obj/item/item = parent
	if(isturf(item.loc))
		if(prob(25))
			new /obj/effect/temp_visual/rogue_glint(item.loc)
		if(prob(15))
			new /obj/effect/temp_visual/rogue_glint(item.loc, 2)
		if(prob(5))
			new /obj/effect/temp_visual/rogue_glint(item.loc, 3)
	else if(isliving(item.loc) && istype(item, /obj/item/clothing/suit/roguetown/armor))
		var/turf/worn_at = get_turf(item)
		if(prob(8))
			new /obj/effect/temp_visual/rogue_glint(worn_at)
		if(prob(4))
			new /obj/effect/temp_visual/rogue_glint(worn_at, 2)
		if(prob(2))
			new /obj/effect/temp_visual/rogue_glint(worn_at, 3)

/obj/effect/temp_visual/rogue_glint
	name = "glint"
	icon = 'modular_redtard/rockhill/icons/roguetown/items/misc.dmi'
	icon_state = "glint"
	alpha = 200
	duration = 1.3 SECONDS
	randomdir = FALSE
	layer = ABOVE_ALL_MOB_LAYER

/obj/effect/temp_visual/rogue_glint/Initialize(mapload, spread = 1)
	. = ..()
	pixel_w = spread * rand(-5, 5)
	pixel_z = spread * rand(-5, 5)
	animate(src, alpha = 0, time = duration)

/// The item's polish stage (Ratwood polished).
/obj/item/proc/rogue_polish_stage()
	var/datum/component/rogue_polish/polish = GetComponent(/datum/component/rogue_polish)
	return polish ? polish.stage : ROGUE_POLISH_NONE

/obj/item/proc/rogue_set_polish(new_stage)
	var/datum/component/rogue_polish/polish = GetComponent(/datum/component/rogue_polish)
	if(polish)
		polish.set_stage(new_stage)
	else
		AddComponent(/datum/component/rogue_polish, new_stage)

/// A masterwork or fine pottery shines from the start (Ratwood polished = 4 and the metal glint).
/obj/item/proc/rogue_shine()
	var/datum/component/rogue_polish/polish = GetComponent(/datum/component/rogue_polish)
	if(!polish)
		AddComponent(/datum/component/rogue_polish, ROGUE_POLISH_DONE, TRUE)
		return
	polish.masterwork = TRUE
	if(polish.stage == ROGUE_POLISH_NONE)
		polish.set_stage(ROGUE_POLISH_DONE)

/// Ratwood: whoever can repair the item with a hammer can polish it; squires and outlaws always can.
/mob/living/proc/rogue_can_polish(obj/item/thing)
	if(!thing.anvilrepair)
		return FALSE
	return HAS_TRAIT(src, TRAIT_SQUIRE_REPAIR) || HAS_TRAIT(src, TRAIT_SELF_SUSTENANCE) || rogue_skill_rank(thing.anvilrepair) > ROGUE_RANK_NONE

/// Ratwood polishing cream: uses of the compound (twelve at Ratwood), the first step of a polish.
/obj/item/polishing_cream
	/// Uses left; a fresh tin gets polish_cream_uses of values/crafting.txt.
	var/uses

/obj/item/polishing_cream/Initialize(mapload)
	. = ..()
	if(isnull(uses))
		uses = POLISH_CREAM_USES

/obj/item/polishing_cream/examine(mob/user)
	. = ..()
	. += span_info("It has [uses] uses left.")

/obj/item/polishing_cream/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isitem(interacting_with) || user.combat_mode)
		return NONE
	var/obj/item/thing = interacting_with
	if(!thing.anvilrepair)
		return NONE
	if(uses <= 0)
		to_chat(user, span_warning("[src] is empty."))
		return ITEM_INTERACT_BLOCKING
	if(!user.rogue_can_polish(thing))
		to_chat(user, span_warning("I don't know how to care for [thing]."))
		return ITEM_INTERACT_BLOCKING
	var/datum/component/rogue_polish/polish = thing.GetComponent(/datum/component/rogue_polish)
	if(polish && !polish.can_start())
		to_chat(user, span_warning("[thing] is already being polished."))
		return ITEM_INTERACT_BLOCKING
	if(DOING_INTERACTION_WITH_TARGET(user, thing))
		return ITEM_INTERACT_BLOCKING
	INVOKE_ASYNC(src, PROC_REF(apply_cream), thing, user)
	return ITEM_INTERACT_SUCCESS

/obj/item/polishing_cream/proc/apply_cream(obj/item/thing, mob/living/user)
	to_chat(user, span_info("I start applying some compound to \the [thing]..."))
	if(!do_after(user, max(POLISH_TIME_BASE - user.rogue_stat(ROGUE_STAT_SPEED) * POLISH_CREAM_PER_SPEED, 0), target = thing))
		return
	var/datum/component/rogue_polish/polish = thing.GetComponent(/datum/component/rogue_polish)
	if(uses <= 0 || (polish && !polish.can_start()))
		return
	thing.rogue_set_polish(ROGUE_POLISH_CREAM)
	uses--
	if(!uses)
		icon_state = "empty_cream"
	else if(uses <= POLISH_CREAM_LOW)
		icon_state = "low_cream"

/// Ratwood armor brush: use it in hand to turn the coarse or the fine side out.
/obj/item/armor_brush
	/// The coarse side is out (Ratwood roughness).
	var/coarse = FALSE

/obj/item/armor_brush/examine(mob/user)
	. = ..()
	. += span_info("To polish a weapon or a piece of armor, you must have the knowledge of a squire or how to repair the item. Follow the following steps:")
	. += span_info("I. Apply polishing cream to the item.")
	. += span_info("II. Use the coarse side (use the item to flip it) to scrub the item roughly.")
	. += span_info("III. Use the fine side to gently polish the item.")
	. += span_info("IV. Wash the item in a wooden bin with water to polish it.")
	. += span_info("A fully polished item will be slightly stronger and or more durable.")

/obj/item/armor_brush/attack_self(mob/user, modifiers)
	. = ..()
	if(.)
		return
	coarse = !coarse
	name = coarse ? "coarse brush" : "fine brush"
	icon_state = "brush_[coarse ? 1 : 0]"
	to_chat(user, span_info((coarse ? "I flip the brush to the coarse side." : "I flip the brush to the fine side.")))
	return TRUE

/obj/item/armor_brush/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isitem(interacting_with) || user.combat_mode)
		return NONE
	var/obj/item/thing = interacting_with
	var/stage = thing.rogue_polish_stage()
	if(!(stage == ROGUE_POLISH_CREAM && coarse) && !(stage == ROGUE_POLISH_SCRUBBED && !coarse))
		return NONE
	if(!user.rogue_can_polish(thing))
		to_chat(user, span_warning("I don't know how to care for [thing]."))
		return ITEM_INTERACT_BLOCKING
	if(DOING_INTERACTION_WITH_TARGET(user, thing))
		return ITEM_INTERACT_BLOCKING
	INVOKE_ASYNC(src, PROC_REF(scrub), thing, user, stage)
	return ITEM_INTERACT_SUCCESS

/obj/item/armor_brush/proc/scrub(obj/item/thing, mob/living/user, stage)
	if(stage == ROGUE_POLISH_CREAM)
		to_chat(user, span_info("I start roughly scrubbing the compound on \the [thing]..."))
	else
		to_chat(user, span_info("I start gently scrubbing the edges of \the [thing]..."))
	playsound(thing, pick(POLISH_SCRUB_SOUNDS), 100, TRUE)
	if(!do_after(user, max(POLISH_TIME_BASE - user.rogue_stat(ROGUE_STAT_STRENGTH) * POLISH_BRUSH_PER_STRENGTH, 0), target = thing))
		return
	if(thing.rogue_polish_stage() != stage)
		return
	thing.rogue_set_polish(stage + 1)

#undef POLISH_CREAM_USES
#undef POLISH_CREAM_LOW
#undef POLISH_TIME_BASE
#undef POLISH_CREAM_PER_SPEED
#undef POLISH_BRUSH_PER_STRENGTH
#undef POLISH_INTEGRITY_SHARE
#undef POLISH_FORCE_BONUS
#undef POLISH_WIELDED_BONUS
#undef POLISH_CREAM_COLOR
#undef POLISH_SCRUBBED_COLOR
#undef POLISH_BRUSHED_COLOR
#undef POLISH_SCRUB_SOUNDS
#undef POLISH_WASH_SOUND
