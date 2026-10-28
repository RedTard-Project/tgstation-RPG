/**
 * HEADEATER (Ratwood code/modules/roguetown/roguemachine/headeater.dm): heads of beasts and wanted folk go in, the bounty goes to
 * the bearer's NERVELOCK account, less the Crown's Headeater Levy. Animal heads carry their bounty (sellprice); heads cut from
 * the NPC brigands, goblins, orcs and drow Ratwood prices carry it once severed. Right click feeds every head at its foot.
 */
/obj/structure/roguemachine/headeater
	/// Takes heads for bounties; its bathhouse kin, the TREASURE SEEKER, takes trinkets for a vault that is not ported.
	var/eats_heads = TRUE

/obj/structure/roguemachine/headeater/treasureseeker
	eats_heads = FALSE

/obj/structure/roguemachine/headeater/examine(mob/user)
	. = ..()
	if(!eats_heads)
		return
	. += span_info("Use a head on it to deposit it, right click to deposit every head at its foot.")
	. += span_smallnotice("Crown's Headeater Levy: [round(SSrogue_treasury.get_tax_rate(ROGUE_TAX_HEADEATER) * 100)]%")

/obj/structure/roguemachine/headeater/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.combat_mode)
		return NONE
	if(!eats_heads)
		to_chat(user, span_warning("Its jaws stay shut."))
		return ITEM_INTERACT_BLOCKING
	if(!rogue_head_bounty_of(tool, TRUE))
		to_chat(user, span_danger("It seems uninterested by [tool]."))
		return ITEM_INTERACT_BLOCKING
	if(!SSrogue_treasury.get_account(user))
		to_chat(user, span_warning("[src] refuses the head - to benefit from the Crown's bounties you must be registered with a Nervelock."))
		return ITEM_INTERACT_BLOCKING
	var/gross = eat_head(tool)
	if(gross)
		pay_bounty(user, gross)
	else
		to_chat(user, span_warning("No one has put a price on [tool]."))
	return ITEM_INTERACT_SUCCESS

/obj/structure/roguemachine/headeater/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || !ishuman(user) || !eats_heads)
		return
	if(!SSrogue_treasury.get_account(user))
		to_chat(user, span_warning("[src] refuses to process bounties without a registered account. Visit a Nervelock."))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	var/gross = 0
	for(var/obj/item/head in get_turf(src))
		gross += eat_head(head)
	if(gross)
		pay_bounty(user, gross)
	else
		to_chat(user, span_warning("There are no wanted heads at its foot."))
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/// Swallows a head and returns its bounty; anything else is left alone (Ratwood eathead()).
/obj/structure/roguemachine/headeater/proc/eat_head(obj/item/head)
	var/bounty = rogue_head_bounty_of(head)
	if(bounty <= 0)
		return 0
	playsound(src, ROGUE_SOUND_MACHINE_VOMIT, 100, FALSE, -1)
	qdel(head)
	return bounty

/// The bounty goes to the bearer's account, the Crown's levy to the Crown's Purse (Ratwood payout() and apply_tax()).
/obj/structure/roguemachine/headeater/proc/pay_bounty(mob/living/user, gross)
	var/datum/bank_account/rogue/account = SSrogue_treasury.get_account(user)
	if(!account)
		return
	var/levy = round(gross * SSrogue_treasury.get_tax_rate(ROGUE_TAX_HEADEATER))
	SSrogue_treasury.mint(account, gross - levy, "headeater bounty ([name])")
	if(levy > 0)
		SSrogue_treasury.mint(SSrogue_treasury.crown_purse, levy, "[ROGUE_TAX_HEADEATER] ([name])")
		to_chat(user, span_danger("[src] credits [gross - levy] mammons to my account, less [levy] mammons to the Crown's Levy."))
	else
		to_chat(user, span_danger("[src] credits [gross] mammons to my account."))

/**
 * The HEADEATER bounty of an item, 0 for anything but a wanted head (Ratwood: sellprice of /obj/item/natural/head and of a
 * severed /obj/item/bodypart/head). Any head counts when any_head is set, for the machine's refusal message.
 */
/proc/rogue_head_bounty_of(obj/item/thing, any_head = FALSE)
	if(istype(thing, /obj/item/natural/head))
		return max(any_head ? 1 : 0, thing.get_real_price())
	if(istype(thing, /obj/item/bodypart/head))
		var/obj/item/bodypart/head/head = thing
		return max(any_head ? 1 : 0, head.rogue_head_bounty)
	return 0

/obj/item/bodypart/head
	/// Bounty the HEADEATER pays for this head, set when it is cut from a wanted NPC (Ratwood head sellprice of NPC spawns).
	var/rogue_head_bounty = 0

/// Head bounties of Ratwood's NPCs (npc/goblin.dm, orc.dm, drow.dm, soldiers/highwayman.dm, bog_deserters.dm): mob path text ->
/// mechanics value; mobs not ported are skipped.
GLOBAL_LIST_INIT(rogue_head_bounty_values, list(
	"/mob/living/carbon/human/species/goblin" = "trade_head_bounty_goblin",
	"/mob/living/carbon/human/species/orc" = "trade_head_bounty_orc",
	"/mob/living/carbon/human/species/elf/dark/drowraider" = "trade_head_bounty_drow",
	"/mob/living/carbon/human/species/human/northern/highwayman" = "trade_head_bounty_highwayman",
	"/mob/living/carbon/human/species/human/northern/bog_deserters" = "trade_head_bounty_deserter",
))

/// The bounty on the head of a mob: wanted NPC kinds only, never a player character (Ratwood sets it on NPC spawns).
/proc/rogue_npc_head_bounty(mob/living/carbon/owner)
	if(!owner || owner.client || owner.mind?.key)
		return 0
	for(var/path_text in GLOB.rogue_head_bounty_values)
		var/mob_type = text2path(path_text)
		if(mob_type && istype(owner, mob_type))
			return rogue_value(GLOB.rogue_head_bounty_values[path_text])
	return 0

/// A head cut from a wanted NPC keeps its bounty for the HEADEATER (Ratwood: the head was priced when the NPC spawned).
/obj/item/bodypart/head/drop_limb(special, dismembered, move_to_floor = TRUE)
	if(!special && owner && rogue_economy_enabled())
		rogue_head_bounty = rogue_npc_head_bounty(owner)
	return ..()

/// A wanted head shows it instead of a price (Ratwood /obj/item/bodypart/head/examine()).
/obj/item/bodypart/head/rogue_value_examine(mob/user)
	if(rogue_head_bounty > 0)
		return list(span_notice("This head seems to be wanted by the Judiciary of The Realm. It can be sold at a HEADEATER."))
	return list()
