// Ratwood needle tuning (game/objects/items/rogueitems/needle.dm).
#define SEW_BASE_FAIL_CHANCE 60
#define SEW_NO_FAIL_RANK ROGUE_RANK_JOURNEYMAN
#define SEW_BASE_REPAIR 10
#define SEW_REPAIR_PER_RANK 10
#define SEW_BASE_TIME (4 SECONDS)
#define SEW_TIME_PER_RANK (1 SECONDS)
#define SEW_MIN_TIME (0.5 SECONDS)
#define SEW_XP_FAIL 0.25
#define SEW_XP_SUCCESS 0.5
/// An unskilled hand fixes a broken item only this far (Ratwood field repair).
#define FIELD_REPAIR_SHARE 0.6
#define REPAIR_CLOTH 0
#define REPAIR_METAL 1
/// Ratwood: a hammer mends 2.5% of a structure's integrity per strike and rank of its skill.
#define STRUCTURE_REPAIR_SHARE 0.025

/// Broken in Ratwood's sense: worn down to where armor stops protecting (ROGUE_ARMOR_FAILURE_SHARE).
/obj/item/proc/rogue_is_broken()
	return uses_integrity && atom_integrity <= max_integrity * ROGUE_ARMOR_FAILURE_SHARE

/// Ratwood ontable(): repairs need a table or an anvil under the item.
/obj/item/proc/rogue_on_workbench()
	if(!isturf(loc))
		return FALSE
	return (locate(/obj/structure/table) in loc) || (locate(/obj/machinery/anvil) in loc)

/// Repairs integrity with Ratwood's field-repair rule: an unskilled hand brings a broken item to 60% and no further,
/// marking it shoddy; a skilled one finishes it. Returns the integrity restored, or null when nothing more can be done.
/obj/item/proc/rogue_repair(mob/living/user, amount, unskilled)
	var/was_broken = rogue_is_broken()
	if(unskilled && shoddy_repair && !was_broken && atom_integrity >= max_integrity * FIELD_REPAIR_SHARE)
		to_chat(user, span_warning("I can't do anything else to fix this right now - I should see a skilled craftsman."))
		return null
	if(unskilled && (was_broken || shoddy_repair))
		amount = min(amount, max_integrity * FIELD_REPAIR_SHARE - atom_integrity)
	. = amount > 0 ? repair_damage(amount) : 0
	if(unskilled && (was_broken || shoddy_repair) && atom_integrity >= max_integrity * FIELD_REPAIR_SHARE)
		if(!shoddy_repair)
			user.visible_message(span_info("[user] finishes field-repairing [src]."))
			to_chat(user, span_warning("I should get this properly fixed by a skilled craftsman later."))
		shoddy_repair = TRUE
	else if(!unskilled && shoddy_repair && atom_integrity >= max_integrity)
		shoddy_repair = FALSE
		to_chat(user, span_notice("My skilled hand has fully repaired this item."))

/obj/item/proc/rogue_needs_repair()
	return uses_integrity && max_integrity && atom_integrity < max_integrity

/// A repair tool works on this item instead of the usual click; bags still take the tool in (Ratwood storage comes first).
/obj/item/proc/rogue_repairable_by_click(mob/living/user)
	return !user.combat_mode && !atom_storage

/// Squires and outlaws repair like craftsmen (Ratwood TRAIT_SQUIRE_REPAIR, TRAIT_SELF_SUSTENANCE).
/mob/living/proc/rogue_unskilled_repair(rank)
	return rank < ROGUE_RANK_JOURNEYMAN && !HAS_TRAIT(src, TRAIT_SQUIRE_REPAIR) && !HAS_TRAIT(src, TRAIT_SELF_SUSTENANCE)

/// Ratwood hammers (roguejobs/blacksmith/tools.dm): smithing quality for breakthroughs and repairs out of combat mode.
/obj/item/rogueweapon/hammer
	/// Ratwood quality: a better hammer lands more breakthroughs.
	var/smith_quality = 1

/obj/item/rogueweapon/hammer/blacksteel
	smith_quality = 2

/// Ratwood hammer attack_obj(): out of combat mode, a hammer repairs an item with anvilrepair lying on a table or an anvil,
/// 2.5% of its integrity per strike and skill rank, doubled on an anvil; untrained hands manage a little.
/obj/item/rogueweapon/hammer/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(isstructure(interacting_with))
		return structure_interaction(interacting_with, user)
	if(!isitem(interacting_with))
		return NONE
	var/obj/item/broken = interacting_with
	if(!broken.anvilrepair || !isturf(broken.loc) || !broken.rogue_repairable_by_click(user))
		return NONE
	if(!broken.rogue_needs_repair())
		return ITEM_INTERACT_BLOCKING
	if(!broken.rogue_on_workbench())
		to_chat(user, span_warning("I should put this on a table or an anvil first."))
		return ITEM_INTERACT_BLOCKING
	if(DOING_INTERACTION_WITH_TARGET(user, broken))
		return ITEM_INTERACT_BLOCKING
	INVOKE_ASYNC(src, PROC_REF(repair_loop), broken, user)
	return ITEM_INTERACT_SUCCESS

/obj/item/rogueweapon/hammer/proc/repair_loop(obj/item/broken, mob/living/user)
	while(!QDELETED(broken) && broken.rogue_needs_repair() && user.is_holding(src))
		if(!repair_strike(broken, user))
			return
		if(!do_after(user, CLICK_CD_MELEE, target = broken))
			return

/obj/item/rogueweapon/hammer/proc/repair_strike(obj/item/broken, mob/living/user)
	var/rank = user.rogue_skill_rank(broken.anvilrepair)
	var/on_anvil = locate(/obj/machinery/anvil) in broken.loc
	var/share = 0.025 * (on_anvil ? 2 : 1)
	var/fumbled = FALSE
	if(rank <= 0)
		share = on_anvil ? 0.035 : 0.015
		fumbled = !on_anvil
	else
		share *= rank
	playsound(src, ROGUE_SMITH_FAIL_SOUND, 40, FALSE)
	var/restored = broken.rogue_repair(user, share * broken.max_integrity, user.rogue_unskilled_repair(rank))
	if(isnull(restored))
		return FALSE
	if(fumbled)
		to_chat(user, span_warning("You fumble your way into slightly repairing [broken]."))
	else
		user.visible_message(span_info("[user] repairs [broken]!"))
	user.rogue_craft_experience(broken.anvilrepair, restored / 2)
	return !(broken.shoddy_repair && user.rogue_unskilled_repair(rank))

/// Ratwood hammer_repair (game/objects/structures.dm): the skill a hammer mends the structure with. Ratwood declares it and
/// gives it to no structure; here a structure takes the skill of the crafting recipe that builds its type
/// (rogue_structure_repair_skill()), unless the type names its own.
/obj/structure/var/hammer_repair

/// Built structure type to the skill of the medieval crafting recipe that builds it, gathered on first use.
GLOBAL_LIST(rogue_structure_repair_skills)

/proc/rogue_structure_repair_skill(structure_type)
	if(!GLOB.rogue_structure_repair_skills)
		GLOB.rogue_structure_repair_skills = list()
		for(var/datum/crafting_recipe/roguetown/recipe in GLOB.crafting_recipes)
			if(!recipe.rogue_skill)
				continue
			var/list/results = list(recipe.result)
			if(LAZYLEN(recipe.rogue_results))
				results += recipe.rogue_results
			for(var/result in results)
				if(ispath(result, /obj/structure) && !GLOB.rogue_structure_repair_skills[result])
					GLOB.rogue_structure_repair_skills[result] = recipe.rogue_skill
	return GLOB.rogue_structure_repair_skills[structure_type]

/obj/structure/proc/rogue_hammer_repair_skill()
	return hammer_repair || rogue_structure_repair_skill(type)

/// Doors mend with the planks or stone of their own repair (rockhill/doors.dm), as in Ratwood, not with a hammer.
/obj/structure/mineral_door/rockhill/rogue_hammer_repair_skill()
	return null

/// Ratwood hammer attack_obj() on a structure: out of combat mode, 2.5% of its integrity per strike and rank of its skill,
/// the restored integrity as experience; the unskilled do not know how.
/obj/item/rogueweapon/hammer/proc/structure_interaction(obj/structure/target, mob/living/user)
	if(user.combat_mode || !target.max_integrity || target.get_integrity() >= target.max_integrity)
		return NONE
	var/skill = target.rogue_hammer_repair_skill()
	if(!skill)
		return NONE
	if(user.rogue_skill_rank(skill) <= ROGUE_RANK_NONE)
		to_chat(user, span_warning("I don't know how to repair this.."))
		return ITEM_INTERACT_BLOCKING
	if(DOING_INTERACTION_WITH_TARGET(user, target))
		return ITEM_INTERACT_BLOCKING
	INVOKE_ASYNC(src, PROC_REF(structure_repair_loop), target, user, skill)
	return ITEM_INTERACT_SUCCESS

/obj/item/rogueweapon/hammer/proc/structure_repair_loop(obj/structure/target, mob/living/user, skill)
	while(!QDELETED(target) && target.get_integrity() < target.max_integrity && user.is_holding(src))
		var/restored = target.repair_damage(STRUCTURE_REPAIR_SHARE * user.rogue_skill_rank(skill) * target.max_integrity)
		user.rogue_craft_experience(skill, restored)
		playsound(src, ROGUE_SMITH_FAIL_SOUND, 100, FALSE)
		user.visible_message(span_info("[user] repairs [target]!"))
		if(!do_after(user, CLICK_CD_MELEE, target = target))
			return

/// Ratwood repair kits (game/objects/items/rogueitems/repair_kits.dm): a sewing kit mends sewn things, metal plates smithed
/// ones (on a table); each use restores a tenth of the kit's charge and spends 10 of it. Ratwood lets a sewing kit mend
/// anything not smithed and plates anything not sewn; here each kit keeps to its own kind so it does not grab other clicks.
/obj/item/repair_kit
	var/repair_type = REPAIR_CLOTH
	var/table_need = FALSE
	/// Ratwood max_integrity of the kit: what it can restore in all, a tenth per use.
	var/kit_charge = 700
	var/charge_left

/obj/item/repair_kit/bad
	kit_charge = 300

/obj/item/repair_kit/metal
	repair_type = REPAIR_METAL
	table_need = TRUE
	kit_charge = 600

/obj/item/repair_kit/metal/bad
	kit_charge = 300

/obj/item/repair_kit/Initialize(mapload)
	. = ..()
	charge_left = kit_charge

/obj/item/repair_kit/examine(mob/user)
	. = ..()
	. += charge_left > 0 ? span_bold("It has [charge_left] left.") : span_bold("It has no uses left.")

/obj/item/repair_kit/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isitem(interacting_with))
		return NONE
	var/obj/item/broken = interacting_with
	if(!(repair_type == REPAIR_METAL ? broken.anvilrepair : broken.sewrepair) || !broken.rogue_repairable_by_click(user))
		return NONE
	if(!broken.uses_integrity || !broken.max_integrity)
		return NONE
	if(charge_left <= 0)
		used_up()
		return ITEM_INTERACT_BLOCKING
	if(!broken.rogue_needs_repair())
		to_chat(user, span_warning("This is not broken."))
		return ITEM_INTERACT_BLOCKING
	if(table_need && !broken.rogue_on_workbench())
		to_chat(user, span_warning("I should put this on a table first."))
		return ITEM_INTERACT_BLOCKING
	if(DOING_INTERACTION_WITH_TARGET(user, broken))
		return ITEM_INTERACT_BLOCKING
	INVOKE_ASYNC(src, PROC_REF(repair_loop), broken, user)
	return ITEM_INTERACT_SUCCESS

/obj/item/repair_kit/proc/repair_sound(obj/item/broken)
	return broken.anvilrepair ? pick(ROGUE_SMITH_SOUNDS) : ROGUE_SEW_SOUND

/obj/item/repair_kit/proc/repair_loop(obj/item/broken, mob/living/user)
	playsound(src, repair_sound(broken), 100, TRUE, -2)
	if(!do_after(user, 2 SECONDS, target = broken))
		return
	while(!QDELETED(src) && !QDELETED(broken) && broken.rogue_needs_repair() && charge_left > 0)
		playsound(src, repair_sound(broken), 100, TRUE, -2)
		var/rank = broken.anvilrepair ? user.rogue_skill_rank(broken.anvilrepair) : user.rogue_skill_rank(/datum/attribute/skill/craft/sewing)
		if(isnull(broken.rogue_repair(user, kit_charge / 10, user.rogue_unskilled_repair(rank))))
			return
		user.visible_message(span_info("[user] repairs [broken]!"))
		user.rogue_craft_experience(broken.anvilrepair || /datum/attribute/skill/craft/sewing, user.rogue_stat(ROGUE_STAT_INTELLIGENCE) * 0.7)
		charge_left -= 10
		if(charge_left <= 0)
			used_up()
			return
		if(!do_after(user, CLICK_CD_MELEE, target = broken))
			return

/// An empty kit falls apart into what it was made of (Ratwood self_del()).
/obj/item/repair_kit/proc/used_up()
	var/turf/here = drop_location()
	if(repair_type == REPAIR_CLOTH)
		playsound(here, 'modular_redtard/rockhill/sound/foley/cloth_rip.ogg', 100, TRUE, -2)
		if(prob(50))
			new /obj/item/natural/cloth(here)
		if(prob(40))
			new /obj/item/natural/fibers(here)
		if(prob(20))
			new /obj/item/natural/fibers(here)
	else
		playsound(here, ROGUE_SMITH_FAIL_SOUND, 100, TRUE, -2)
	qdel(src)

/// Ratwood needle (game/objects/items/rogueitems/needle.dm): mends sewn clothing on a table and is threaded with fibers.
/obj/item/needle
	var/stringamt = 20
	var/maxstring = 20
	var/infinite = FALSE

/obj/item/needle/examine(mob/user)
	. = ..()
	if(infinite)
		. += "Can be used indefinitely."
	else
		. += stringamt > 0 ? span_bold("It has [stringamt] uses left.") : span_bold("It has no uses left.")

/obj/item/needle/update_overlays()
	. = ..()
	if(stringamt > 0 && icon_exists(icon, "[icon_state]string"))
		. += "[icon_state]string"

/obj/item/needle/Initialize(mapload)
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

/// Ratwood: a fiber threads up to five more uses.
/obj/item/needle/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/natural/fibers))
		return ..()
	if(infinite || stringamt >= maxstring)
		to_chat(user, span_warning("The needle has no need to be refilled."))
		return ITEM_INTERACT_BLOCKING
	to_chat(user, "I begin threading the needle with additional fibers...")
	if(!do_after(user, 6 SECONDS - user.rogue_skill_rank(/datum/attribute/skill/craft/sewing), target = tool))
		return ITEM_INTERACT_BLOCKING
	var/refill = min(5, maxstring - stringamt)
	stringamt += refill
	to_chat(user, "I replenish the needle's thread by [refill] uses!")
	qdel(tool)
	update_appearance(UPDATE_OVERLAYS)
	return ITEM_INTERACT_SUCCESS

/obj/item/needle/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!istype(interacting_with, /obj/item/clothing))
		return NONE
	var/obj/item/clothing/cloth = interacting_with
	if(!cloth.sewrepair || !cloth.rogue_repairable_by_click(user))
		return NONE
	if(!infinite && stringamt < 1)
		to_chat(user, span_warning("The needle has no thread left!"))
		return ITEM_INTERACT_BLOCKING
	if(!cloth.rogue_needs_repair())
		to_chat(user, span_warning("This is not broken."))
		return ITEM_INTERACT_BLOCKING
	if(!cloth.rogue_on_workbench())
		to_chat(user, span_warning("I should put this on a table first."))
		return ITEM_INTERACT_BLOCKING
	if(DOING_INTERACTION_WITH_TARGET(user, cloth))
		return ITEM_INTERACT_BLOCKING
	INVOKE_ASYNC(src, PROC_REF(sew_loop), cloth, user)
	return ITEM_INTERACT_SUCCESS

/// Ratwood needle attack_obj(): the better of sewing and skincrafting sets the speed, the repair and the failure chance.
/obj/item/needle/proc/sew_loop(obj/item/clothing/cloth, mob/living/user)
	while(!QDELETED(cloth) && cloth.rogue_needs_repair() && (infinite || stringamt >= 1) && user.is_holding(src))
		var/rank = max(user.rogue_skill_rank(/datum/attribute/skill/craft/sewing), user.rogue_skill_rank(/datum/attribute/skill/craft/tanning))
		if(!do_after(user, max(SEW_MIN_TIME, SEW_BASE_TIME - SEW_TIME_PER_RANK * rank), target = cloth))
			return
		var/failed = prob(SEW_BASE_FAIL_CHANCE - rank * (SEW_BASE_FAIL_CHANCE / SEW_NO_FAIL_RANK))
		var/amount = SEW_BASE_REPAIR + rank * SEW_REPAIR_PER_RANK
		if(failed)
			amount *= 0.5
		var/was_broken = cloth.rogue_is_broken()
		if(isnull(cloth.rogue_repair(user, amount, user.rogue_unskilled_repair(rank))))
			return
		user.rogue_craft_experience(/datum/attribute/skill/craft/sewing, user.rogue_stat(ROGUE_STAT_INTELLIGENCE) * (failed ? SEW_XP_FAIL : SEW_XP_SUCCESS))
		playsound(loc, ROGUE_SEW_SOUND, 50, TRUE, -2)
		user.visible_message(span_info((failed ? "[user] makes a little progress towards repairing [cloth]..." : "[user] repairs [cloth]!")))
		if(was_broken && !cloth.rogue_is_broken() && !infinite)
			stringamt--
			update_appearance(UPDATE_OVERLAYS)
		if(cloth.shoddy_repair && user.rogue_unskilled_repair(rank))
			return
		if(!do_after(user, CLICK_CD_MELEE, target = cloth))
			return

#undef SEW_BASE_FAIL_CHANCE
#undef SEW_NO_FAIL_RANK
#undef SEW_BASE_REPAIR
#undef SEW_REPAIR_PER_RANK
#undef SEW_BASE_TIME
#undef SEW_TIME_PER_RANK
#undef SEW_MIN_TIME
#undef SEW_XP_FAIL
#undef SEW_XP_SUCCESS
#undef FIELD_REPAIR_SHARE
#undef REPAIR_CLOTH
#undef REPAIR_METAL
#undef STRUCTURE_REPAIR_SHARE
