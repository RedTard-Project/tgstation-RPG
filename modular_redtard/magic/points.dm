/// Who gets spellbook points, by Vibelin's rules (block Х1, owner's decision of 2026-11-22: "as Vibelin, for now"):
/// - a role trained in the arcyne starts with its role's points (Vibelin /datum/job form_points, technique_points, given in
///   after_spawn, and the extra points some roles give there). The module's roles are Ratwood's: a mage role takes the
///   numbers of the Vibelin role it answers to (rogue_role_spell_point_key()), and any other role with Arcyne Training
///   (TRAIT_ARCYNE) those of Vibelin's Magician's Apprentice, the least a Vibelin role versed in the arcyne starts with;
/// - the Arcyne Insight scroll (Vibelin /obj/item/book/granter/spell_points) gives a reader of Novice Arcyne or better form
///   points, its technique kind technique points; Ratwood's loot chest may hold one, as Vibelin's does.
/// Vibelin's spellbooks with charges and its magic school migrants have nothing to land on here yet (books with charges
/// wait for the magic theme; the module has no such migrants). Vibelin's Thinker, a special trait of the ruler, is not a
/// trait here: its points go to the port's mage lords.
/// Numbers: magic_points_<role>_form, _technique (and _imbue, _old_form where Vibelin has them), magic_insight_* of magic.txt.

/// The Vibelin role whose points a role of the port starts with: a role trained in the arcyne and not listed is "arcyne".
/proc/rogue_role_spell_point_key(datum/role)
	var/list/table = rogue_role_spell_point_table()
	return table[role.type] || "arcyne"

/// Role type of the port -> the Vibelin role it answers to. Types are the porter's (rockhill/ported/jobs.dm, advclasses.dm).
/proc/rogue_role_spell_point_table()
	var/static/list/keys
	if(!keys)
		keys = list(
			// Vibelin Court Magician (nobility/magician.dm).
			/datum/job/roguetown/magician = "court_magician",
			/datum/rockhill_advclass/heartfelt/retinue/magos = "court_magician",
			// Vibelin's ruler who casts, the Thinker (special_traits/traits.dm): the mage lords.
			/datum/rockhill_advclass/lord/wizard = "thinker",
			/datum/rockhill_advclass/heartfelt/lord/archmage = "thinker",
			// Vibelin Magician's Apprentice (apprentices/wapprentice.dm); there only an adult had them, and the module has
			// no younger age.
			/datum/job/roguetown/wapprentice = "apprentice",
			/datum/rockhill_advclass/wapprentice/apprentice = "apprentice",
			/datum/rockhill_advclass/vagabond_mage = "apprentice",
			// Vibelin adventurer Mage (adventurer/types/combat/mage.dm).
			/datum/rockhill_advclass/mage = "mage",
			/datum/rockhill_advclass/mage/spellsinger = "mage",
			/datum/rockhill_advclass/mage/spellthief = "mage",
			/datum/rockhill_advclass/wapprentice/associate = "mage",
			/datum/rockhill_advclass/sojourner = "mage",
			/datum/rockhill_advclass/mercenary/warscholar/pontifex = "mage",
			/datum/rockhill_advclass/mercenary/warscholar/vizier = "mage",
			// Vibelin mercenary Spellsword (merc_classes/spellsword.dm).
			/datum/rockhill_advclass/mage/spellblade = "spellsword",
			/datum/rockhill_advclass/mercenary/newmoon = "spellsword",
			/datum/rockhill_advclass/templar/noc_spellblade = "spellsword",
			// Vibelin mercenary Sellmage (merc_classes/mercmage.dm).
			/datum/rockhill_advclass/mercenary/grenzelhoft/mage = "sellmage",
			/datum/rockhill_advclass/mercenary/desert_rider/almah = "sellmage",
			/datum/rockhill_advclass/mercenary/warscholar = "sellmage",
			// Vibelin wretch Necromancer (wretch/necromancer.dm).
			/datum/rockhill_advclass/wretch/necromancer = "necromancer",
			// Vibelin Rogue Mage (antag/roguemage.dm).
			/datum/rockhill_advclass/wretch/roguemage = "rogue_mage",
		)
	return keys

/// Vibelin's after_spawn of a role: its form and technique points, the Spellsword's technique points straight into Imbue,
/// the old Rogue Mage's form point more. Only for one trained in the arcyne, once per person, on medieval maps.
/proc/rogue_grant_role_spell_points(mob/living/carbon/human/human, datum/role)
	if(!istype(human) || !role || !HAS_TRAIT(human, TRAIT_ARCYNE))
		return FALSE
	var/datum/rogue_spell_mastery/mastery = human.rogue_get_spell_mastery()
	if(!mastery || mastery.role_points_given)
		return FALSE
	mastery.role_points_given = TRUE
	var/key = rogue_role_spell_point_key(role)
	human.rogue_give_spell_points(rogue_value_or("magic_points_[key]_form", 0), rogue_value_or("magic_points_[key]_technique", 0))
	var/imbue = rogue_value_or("magic_points_[key]_imbue", 0)
	if(imbue)
		human.rogue_give_spell_points(technique_points = imbue, technique = ROGUE_TECHNIQUE_IMBUE)
	var/old_form = rogue_value_or("magic_points_[key]_old_form", 0)
	if(old_form && human.age >= ROGUE_AGE_OLD)
		human.rogue_give_spell_points(old_form)
	return TRUE

/// A role without classes gives its traits in after_spawn (rockhill/jobs.dm); one with classes gives them with the class.
/datum/job/roguetown/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	rogue_grant_role_spell_points(spawned, src)

/datum/rockhill_advclass/apply(mob/living/carbon/human/human)
	. = ..()
	rogue_grant_role_spell_points(human, src)

/// Vibelin /obj/item/book/granter/spell_points, "Arcyne Insight": dungeon loot that one versed in the arcyne (Novice or
/// better) reads for a point of the spellbook, then it is a blank scroll.
/obj/item/book/granter/rogue_arcyne_insight
	name = "Arcyne Insight"
	desc = "A scroll inscribed with arcyne scripture. One versed in the arcyne could draw an insight from it."
	icon = 'modular_redtard/rockhill/icons/roguetown/items/misc.dmi'
	icon_state = "enchantment"
	lefthand_file = 'modular_redtard/rockhill/icons/baked/roguetown/items/misc_lefthand.dmi'
	righthand_file = 'modular_redtard/rockhill/icons/baked/roguetown/items/misc_righthand.dmi'
	inhand_icon_state = "enchantment"
	w_class = WEIGHT_CLASS_SMALL
	drop_sound = 'sound/items/handling/paper_drop.ogg'
	pickup_sound = 'sound/items/handling/paper_pickup.ogg'
	starting_title = "Arcyne Insight"
	/// Vibelin is_technique_scroll: a technique point instead of a form point.
	var/technique_scroll = FALSE

/obj/item/book/granter/rogue_arcyne_insight/technique
	name = "Arcyne Insight (technique)"
	technique_scroll = TRUE

/// Vibelin: Novice Arcyne or better; checked before the reading, so the scroll is not wasted on one who cannot use it.
/obj/item/book/granter/rogue_arcyne_insight/can_learn(mob/living/user)
	if(!ishuman(user) || !rogue_magic_enabled())
		to_chat(user, span_notice("I don't know what to make of this."))
		return FALSE
	if(ROGUE_NULLTOZERO(user.rogue_skill(/datum/attribute/skill/magic/arcane)) < ROGUE_SKILL_LEVEL_NOVICE)
		to_chat(user, span_notice("I don't know what to make of this."))
		return FALSE
	return TRUE

/obj/item/book/granter/rogue_arcyne_insight/on_reading_finished(mob/living/user)
	var/mob/living/carbon/human/reader = user
	if(!istype(reader))
		return
	var/points = rogue_value("magic_insight_points")
	if(technique_scroll)
		reader.rogue_give_spell_points(technique_points = points)
	else
		reader.rogue_give_spell_points(points)
	to_chat(reader, span_notice("I absorb the insights on the scroll, and feel more adept at spellcraft!"))
	reader.visible_message(span_warning("[src] has had its magic ink ripped from the scroll!"))
	name = "siphoned scroll"
	desc = "A scroll once inscribed with magical scripture. The surface is now barren of knowledge, siphoned by someone else. It's utterly useless."
	icon_state = "scroll"
	inhand_icon_state = "scroll"
	update_appearance()

/obj/item/book/granter/rogue_arcyne_insight/recoil(mob/living/user)
	to_chat(user, span_notice("The scroll is barren. It's utterly useless."))

/// Vibelin's loot chest (crates_lockers/chest.dm lootbox) has the scroll among its finds; Ratwood's, ported, gets it too.
/obj/structure/closet/crate/wooden/rockhill/crate/chest/lootbox/PopulateContents()
	if(rogue_magic_enabled())
		LAZYSET(rockhill_loot, /obj/item/book/granter/rogue_arcyne_insight, rogue_value("magic_insight_chest_weight"))
	return ..()
