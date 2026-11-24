/// Vibelin's splint and tourniquet on medieval maps (game/objects/items/medical/splint.dm, tourniquet.dm; bodypart
/// _bodyparts.dm apply_splint(), apply_tourniquet(), on_life(), update_disabled()), in TG's slots of a limb's applied items
/// (apply_item()). A splint keeps the crits it holds (Vibelin splint_suppression: broken bones, dislocations) from disabling
/// the limb and helps its other crits mend, and snaps under a hard blow. A tourniquet stops the limb's bleeding outright and
/// takes the limb from use; after a while it starves the limb (pain, cold), after a long while the limb dies, and taken
/// off a starved limb that still bleeds it lets the blood spray. TG's own tourniquet keeps its ways on modern maps.

/// Source of a tourniquet's paralysis of the limb (Vibelin BODYPART_DISABLED_TOURNIQUET).
#define ROGUE_TOURNIQUET_TRAIT "rogue_tourniquet"

/obj/item/bodypart
	/// Deciseconds the tourniquet on this limb has been starving it (Vibelin tourniquet_time).
	var/rogue_tourniquet_time = 0

/datum/wound/rogue
	/// What a splint on the limb adds to this crit's mending by itself (Vibelin apply_splint(): wound_healing), taken back
	/// when the splint comes off.
	var/rogue_splint_bonus = 0

/// A splint is on this limb (Vibelin splinted).
/obj/item/bodypart/proc/rogue_splinted()
	return !!LAZYACCESS(applied_items, ROGUE_LIMB_ITEM_SPLINT)

/// A tourniquet is on this limb (Vibelin tourniquet), TG's or the improvised one. While it is on, the limb bleeds no more
/// (Vibelin get_bleed_multiplier(): 0) - the blood of the body (combat/blood.dm) counts it.
/obj/item/bodypart/proc/rogue_tourniqueted()
	return !!LAZYACCESS(applied_items, LIMB_ITEM_TOURNIQUET)

// ---------------------------------------------------------------------------------------------------------------------------
// The splint.

/// Vibelin /obj/item/splint: a stick and some wrapping.
/obj/item/splint
	name = "improvised splint"
	desc = "A stick and some wrapping. Doesn't fix a break, just stops it grinding when you move."
	icon = 'modular_redtard/combat/icons/rogue_treatment.dmi'
	icon_state = "splint"
	inhand_icon_state = null
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE
	rogue_grid_width = 32
	rogue_grid_height = 32

/obj/item/splint/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_APPLIED_TO_LIMB, PROC_REF(on_applied))
	RegisterSignal(src, COMSIG_ITEM_UNAPPLIED_FROM_LIMB, PROC_REF(on_removed))

/obj/item/splint/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!ishuman(interacting_with) || !rogue_combat_enabled())
		return ..()
	INVOKE_ASYNC(src, PROC_REF(rogue_splint), interacting_with, user)
	return ITEM_INTERACT_SUCCESS

/// Vibelin do_splint(): on the limb aimed at, only where a crit the splint holds is.
/obj/item/splint/proc/rogue_splint(mob/living/carbon/human/patient, mob/living/user)
	var/obj/item/bodypart/limb = patient.get_bodypart(check_zone(user.zone_selected))
	if(!limb)
		to_chat(user, span_warning("[patient] is missing that limb!"))
		return FALSE
	if(limb.rogue_splinted())
		to_chat(user, span_warning("[patient]'s [limb.plaintext_zone] is already splinted!"))
		return FALSE
	if(!limb.rogue_splint_needed())
		to_chat(user, span_warning("There's nothing broken in [patient]'s [limb.plaintext_zone]!"))
		return FALSE
	user.visible_message(span_notice("[user] starts splinting [patient]'s [limb.plaintext_zone]..."), span_notice("I start splinting [patient == user ? "my" : "[patient]'s"] [limb.plaintext_zone]..."), vision_distance = COMBAT_MESSAGE_RANGE)
	if(!do_after(user, rogue_value("splint_time"), target = patient))
		return FALSE
	if(QDELETED(limb) || limb.owner != patient || limb.rogue_splinted() || !user.is_holding(src))
		return FALSE
	if(!user.temporarilyRemoveItemFromInventory(src))
		return FALSE
	if(!limb.apply_item(src, ROGUE_LIMB_ITEM_SPLINT))
		user.put_in_hands(src)
		return FALSE
	log_combat(user, patient, "splinted")
	user.visible_message(span_notice("[user] splints [patient]'s [limb.plaintext_zone]."), span_notice("I splint [patient == user ? "my" : "[patient]'s"] [limb.plaintext_zone]."), vision_distance = COMBAT_MESSAGE_RANGE)
	return TRUE

/obj/item/splint/proc/on_applied(datum/source, obj/item/bodypart/limb)
	SIGNAL_HANDLER
	limb.rogue_on_splinted()

/obj/item/splint/proc/on_removed(datum/source, obj/item/bodypart/limb)
	SIGNAL_HANDLER
	limb.rogue_on_unsplinted()

/// A crit on this limb a splint holds (Vibelin splint_suppression).
/obj/item/bodypart/proc/rogue_splint_needed()
	for(var/datum/wound/rogue/crit in wounds)
		if(crit.splint_suppression)
			return TRUE
	return FALSE

/// Vibelin apply_splint(): the crits the splint does not hold mend faster by themselves, the ones it holds disable the limb
/// no more, and a hard blow will snap it.
/obj/item/bodypart/proc/rogue_on_splinted()
	var/bonus = rogue_value("splint_healing")
	for(var/datum/wound/rogue/crit in wounds)
		if(crit.splint_suppression || crit.rogue_splint_bonus)
			continue
		crit.rogue_splint_bonus = bonus
		crit.passive_healing += bonus
	RegisterSignal(src, COMSIG_BODYPART_CHANGED_OWNER, PROC_REF(rogue_splint_owner_changed), override = TRUE)
	if(owner)
		RegisterSignal(owner, COMSIG_CARBON_LIMB_DAMAGED, PROC_REF(rogue_splint_struck), override = TRUE)
	rogue_update_splint_hold()

/// Vibelin remove_splint(): the mending it gave is taken back and the crits it held disable the limb again.
/obj/item/bodypart/proc/rogue_on_unsplinted()
	for(var/datum/wound/rogue/crit in wounds)
		if(!crit.rogue_splint_bonus)
			continue
		crit.passive_healing -= crit.rogue_splint_bonus
		crit.rogue_splint_bonus = 0
	UnregisterSignal(src, COMSIG_BODYPART_CHANGED_OWNER)
	if(owner)
		UnregisterSignal(owner, COMSIG_CARBON_LIMB_DAMAGED)
	rogue_update_splint_hold()

/// The splinted limb went to another body, or off one: the blows that snap the splint are those of its new owner.
/obj/item/bodypart/proc/rogue_splint_owner_changed(datum/source, mob/living/carbon/new_owner, mob/living/carbon/old_owner)
	SIGNAL_HANDLER
	if(old_owner)
		UnregisterSignal(old_owner, COMSIG_CARBON_LIMB_DAMAGED)
	if(new_owner)
		RegisterSignal(new_owner, COMSIG_CARBON_LIMB_DAMAGED, PROC_REF(rogue_splint_struck), override = TRUE)

/// Vibelin check_wounding(): a blow of this much brute or more on the splinted limb snaps the splint.
/obj/item/bodypart/proc/rogue_splint_struck(mob/living/carbon/source, obj/item/bodypart/struck, brute, burn)
	SIGNAL_HANDLER
	if(struck != src || brute < rogue_value("splint_break_damage"))
		return
	INVOKE_ASYNC(src, PROC_REF(rogue_break_splint))

/// Vibelin remove_splint(broken = TRUE): the splint snaps and falls off, and it hurts.
/obj/item/bodypart/proc/rogue_break_splint()
	var/obj/item/splint = LAZYACCESS(applied_items, ROGUE_LIMB_ITEM_SPLINT)
	if(!splint)
		return
	var/mob/living/carbon/body = owner
	splint.forceMove(body ? body.drop_location() : drop_location())
	if(!body)
		return
	to_chat(body, span_userdanger("The splint on my [plaintext_zone] snaps!"))
	rogue_add_pain(rand(rogue_value("splint_break_pain_min"), rogue_value("splint_break_pain_max")))

/// Vibelin update_disabled(): a disabling crit the splint holds does not disable a splinted limb. The crits follow the splint
/// themselves (combat/wounds.dm rogue_update_disabling(), also every Life tick); a splint put on or taken off tells them at once.
/obj/item/bodypart/proc/rogue_update_splint_hold()
	for(var/datum/wound/rogue/crit in wounds)
		if(crit.splint_suppression)
			crit.rogue_update_disabling()

/// Vibelin do_remove_splint(): the splint comes into the hand.
/mob/living/carbon/human/proc/rogue_unsplint(mob/living/user, obj/item/bodypart/limb)
	var/obj/item/splint = LAZYACCESS(limb.applied_items, ROGUE_LIMB_ITEM_SPLINT)
	if(!splint)
		return
	if(!IsReachableBy(user))
		to_chat(user, span_warning("I need to be closer to remove that!"))
		return
	user.visible_message(span_notice("[user] starts removing the splint on [user == src ? "[user.p_their()]" : "[src]'s"] [limb.plaintext_zone]..."), span_notice("I start removing the splint on [user == src ? "my" : "[src]'s"] [limb.plaintext_zone]..."), vision_distance = COMBAT_MESSAGE_RANGE)
	if(!do_after(user, rogue_value("unsplint_time"), target = src))
		return
	if(QDELETED(splint) || QDELETED(limb) || splint.loc != limb || limb.owner != src)
		return
	log_combat(user, src, "removed a splint from")
	splint.forceMove(drop_location())
	user.put_in_hands(splint)

// ---------------------------------------------------------------------------------------------------------------------------
// The tourniquet.

/// Vibelin /obj/item/tourniquet: a strip of cloth twisted tight around a stick, on TG's tourniquet (its slot, its examine
/// line and its removal). Only on arms and legs; it takes the limb from use while it is on.
/obj/item/tourniquet/improvised
	name = "improvised tourniquet"
	desc = "A strip of cloth twisted tight around a stick. Stops bleeding fast. Stops a lot else too, given time."
	icon = 'modular_redtard/combat/icons/rogue_treatment.dmi'
	icon_state = "tourniquet"
	inhand_icon_state = null
	w_class = WEIGHT_CLASS_TINY
	custom_premium_price = 0
	rogue_grid_width = 32
	rogue_grid_height = 32

/// Vibelin do_apply_tourniquet(): not on the neck, through what does not cover the limb; slower on oneself than on another,
/// and no harm done by the tying.
/obj/item/tourniquet/improvised/do_apply_tourniquet(mob/user, mob/living/patient, obj/item/bodypart/limb)
	if(!rogue_combat_enabled())
		return ..()
	if(limb.body_zone == BODY_ZONE_HEAD)
		to_chat(user, span_warning("A tourniquet won't do anything for that!"))
		return FALSE
	if(!patient.try_inject(user, limb.body_zone, INJECT_TRY_SHOW_ERROR_MESSAGE))
		return FALSE
	user.visible_message(span_notice("[user] starts tying [src] around [patient]'s [limb.plaintext_zone]!"), span_notice("I start tying [src] around [patient == user ? "my" : "[patient]'s"] [limb.plaintext_zone]..."), vision_distance = COMBAT_MESSAGE_RANGE)
	if(!do_after(user, patient == user ? rogue_value("tourniquet_self_time") : rogue_value("tourniquet_time"), target = patient))
		return FALSE
	if(QDELETED(limb) || limb.owner != patient || limb.rogue_tourniqueted())
		return FALSE
	log_combat(user, patient, "applied a tourniquet to")
	user.visible_message(span_notice("<b>[user]</b> cinches a tourniquet tight around <b>[patient]</b>'s [limb.plaintext_zone]!"), span_notice("I cinch a tourniquet tight around [patient == user ? "my" : "[patient]'s"] [limb.plaintext_zone]."), vision_distance = COMBAT_MESSAGE_RANGE)
	return TRUE

/// Vibelin apply_tourniquet(): the starving starts anew, and on a medieval body the limb is of no use while it is on.
/obj/item/tourniquet/improvised/on_applied_to_limb(datum/source, obj/item/bodypart/limb)
	SIGNAL_HANDLER
	. = ..()
	limb.rogue_tourniquet_time = 0
	if(!rogue_combat_enabled() || !limb.can_be_disabled)
		return
	ADD_TRAIT(limb, TRAIT_PARALYSIS, ROGUE_TOURNIQUET_TRAIT)
	if(limb.owner)
		limb.update_disabled()

/// Vibelin remove_tourniquet(sudden): the limb serves again; taken off a starved limb that still bleeds, the blood sprays.
/obj/item/tourniquet/improvised/on_removed_from_limb(datum/source, obj/item/bodypart/limb)
	SIGNAL_HANDLER
	. = ..()
	var/starved = limb.rogue_tourniquet_time >= rogue_value("tourniquet_ischemia_delay")
	limb.rogue_tourniquet_time = 0
	REMOVE_TRAIT(limb, TRAIT_PARALYSIS, ROGUE_TOURNIQUET_TRAIT)
	if(limb.owner && limb.can_be_disabled)
		limb.update_disabled()
	if(starved && rogue_combat_enabled() && limb.owner)
		INVOKE_ASYNC(limb, TYPE_PROC_REF(/obj/item/bodypart, rogue_tourniquet_released))

/// Vibelin remove_tourniquet(sudden = TRUE): blood sprays from the starved limb, and it hurts.
/obj/item/bodypart/proc/rogue_tourniquet_released()
	var/mob/living/carbon/body = owner
	if(!body || !CAN_HAVE_BLOOD(body) || rogue_limb_bleed_rate() <= 0)
		return
	body.visible_message(span_danger("Blood sprays from [body]'s [plaintext_zone] as the tourniquet comes off!"), span_userdanger("Blood sprays from my [plaintext_zone] as the tourniquet comes off!"))
	body.bleed(rand(rogue_value("tourniquet_release_bleed_min"), rogue_value("tourniquet_release_bleed_max")))
	rogue_add_pain(rand(rogue_value("tourniquet_release_pain_min"), rogue_value("tourniquet_release_pain_max")))

/// Vibelin on_life(), the tourniquet, each Life tick of a living body (rogue_bandage_tick(), combat/medicine.dm): past the
/// time of starving, the limb hurts now and then and feels cold; past the time of dying, its flesh is dead (the rot of
/// burial/corpse_rot.dm) until the rot is cured.
/obj/item/bodypart/proc/rogue_tourniquet_tick(seconds_per_tick)
	var/list/numbers = rogue_treatment_numbers()
	rogue_tourniquet_time += seconds_per_tick SECONDS
	if(rogue_tourniquet_time < numbers["tourniquet_ischemia_delay"])
		return
	if(SPT_PROB(numbers["tourniquet_pain_chance"], seconds_per_tick))
		rogue_add_pain(rand(numbers["tourniquet_pain_min"], numbers["tourniquet_pain_max"]))
	if(owner && SPT_PROB(numbers["tourniquet_message_chance"], seconds_per_tick))
		owner.rogue_custom_pain("My [plaintext_zone] feels cold and distant...", numbers["tourniquet_message_pain"], FALSE, src)
	if(rogue_tourniquet_time < numbers["tourniquet_necrosis_delay"] || rogue_rotted || !rogue_rottable())
		return
	rogue_rot_flesh()
	if(owner)
		owner.update_body_parts()
		to_chat(owner, span_userdanger("My [plaintext_zone] has gone numb, dark, and still. It's dead."))

// ---------------------------------------------------------------------------------------------------------------------------
// Making them (Vibelin quality_of_crafting/natural_items.dm).

/datum/crafting_recipe/roguetown/survival/splint
	name = "improvised splint"
	result = /obj/item/splint
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/grown/log/tree/stick = 1)
	blacklist = list(/obj/item/natural/cloth/bandage)
	category = "Medicine"
	rogue_skill = /datum/attribute/skill/misc/medicine
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

/datum/crafting_recipe/roguetown/survival/tourniquet
	name = "improvised tourniquet"
	result = /obj/item/tourniquet/improvised
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/grown/log/tree/stick = 1)
	blacklist = list(/obj/item/natural/cloth/bandage)
	category = "Medicine"
	rogue_skill = /datum/attribute/skill/misc/medicine
	rogue_sound = 'modular_redtard/rockhill/sound/foley/bandage.ogg'

#undef ROGUE_TOURNIQUET_TRAIT
