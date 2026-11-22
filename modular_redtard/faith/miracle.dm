/// The miracles of the gods (Ratwood code/modules/spells/roguetown/acolyte, Azure Peak's and Twilight Axis's
/// code/modules/spells/pantheon) as TG spells, all in one basket: a miracle belongs to no patron here and only remembers whose
/// it was in the forks it came from (miracle_forks, miracle_gods); who gets which is the owner's call, until then the admins
/// hand them out (admin.dm). Devotion pays for a cast (devotion.dm), the Miracles skill must reach the miracle's tier
/// (faith_ranks_per_tier ranks a tier), and some want a holy symbol worn or held (Ratwood req_items). A cast that fails
/// after it began (Ratwood revert_cast()) costs no devotion and gives its cooldown back. A pointed spell: the devotee clicks
/// the target, or, with click_to_activate off, casts it on themselves.
/datum/action/cooldown/spell/pointed/rogue_miracle
	name = "Miracle"
	desc = "A miracle of the gods."
	button_icon = ROGUE_MIRACLES_ICON
	button_icon_state = "heal"
	background_icon = ROGUE_MIRACLES_ICON
	background_icon_state = "spell0"
	base_background_icon_state = "spell0"
	active_background_icon_state = "spell1"
	overlay_icon_state = null
	active_overlay_icon_state = null
	school = SCHOOL_HOLY
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	spell_requirements = SPELL_REQUIRES_HUMAN
	invocation_type = INVOCATION_NONE
	cast_range = 4
	/// A family of miracles, not one of the basket (TG's abstract_type).
	var/abstract_miracle_type = /datum/action/cooldown/spell/pointed/rogue_miracle
	/// Ratwood cleric tier (ROGUE_MIRACLE_TIER_*): how far the Miracles skill must go.
	var/miracle_tier = ROGUE_MIRACLE_TIER_0
	/// Devotion one cast costs (Ratwood devotion_cost).
	var/devotion_cost = 0
	/// A holy symbol must be worn or held (Ratwood req_items = psicross).
	var/needs_holy_symbol = FALSE
	/// May be cast on the devotee too.
	var/self_castable = TRUE
	/// The forks it came from ("Ratwood, Azure Peak"), and the gods it belonged to there with their tier ("Astrata T3").
	/// Text, so the basket reads them off the type without making the spell.
	var/miracle_forks = ""
	var/miracle_gods = ""
	/// The cast went wrong after it began: no devotion is spent and the cooldown comes back.
	var/miracle_failed = FALSE
	/// Stamina a cast takes (Ratwood releasedrain). A miracle pays it flat: the skill, the mind and the armour of the caster do
	/// not sway it (Ratwood calculate_fatigue_drain() lets a miracle off all of them).
	var/stamina_cost = 0
	/// Charges instead of a cooldown (Ratwood charge_type "charges"; 0 - a plain cooldown). A cast spends one; one comes back
	/// every charge_time, and with none left the lot comes back after empty_charge_time. Such a miracle has no cooldown_time.
	var/max_charges = 0
	var/charges = 0
	var/charge_time = 10 SECONDS
	var/empty_charge_time = 1 MINUTES
	var/charge_timer

/datum/action/cooldown/spell/pointed/rogue_miracle/New(Target)
	. = ..()
	charges = max_charges
	desc = "[desc]<br>Tier [miracle_tier]. Devotion: [devotion_cost].[stamina_cost ? " Stamina: [stamina_cost]." : ""][max_charges ? " [max_charges] charges: one is regained in [DisplayTimeText(charge_time)], all of them in [DisplayTimeText(empty_charge_time)] when none are left." : ""][needs_holy_symbol ? " Needs a holy symbol." : ""]"

/datum/action/cooldown/spell/pointed/rogue_miracle/Destroy()
	if(charge_timer)
		deltimer(charge_timer)
		charge_timer = null
	return ..()

/datum/action/cooldown/spell/pointed/rogue_miracle/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/devotee = owner
	if(!rogue_faith_enabled())
		if(feedback)
			to_chat(owner, span_warning("The gods do not answer here."))
		return FALSE
	if(!istype(devotee) || !devotee.rogue_devotion)
		if(feedback)
			to_chat(owner, span_warning("I have no devotion to draw upon."))
		return FALSE
	if(devotee.rogue_skill_rank(/datum/attribute/skill/magic/holy) < miracle_tier * rogue_value("faith_ranks_per_tier"))
		if(feedback)
			to_chat(owner, span_warning("I am not versed enough in miracles to call upon [src]."))
		return FALSE
	if(devotee.rogue_devotion.devotion < devotion_cost)
		if(feedback)
			to_chat(owner, span_warning("I don't have enough devotion!"))
		return FALSE
	if(needs_holy_symbol && !rogue_has_holy_symbol(devotee))
		if(feedback)
			to_chat(owner, span_warning("I need a holy symbol, worn or in hand, to call upon [src]."))
		return FALSE
	if(max_charges && charges <= 0)
		if(feedback)
			to_chat(owner, span_warning("[src] is exhausted and must recover before it can be used again."))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/pointed/rogue_miracle/is_valid_target(atom/cast_on)
	if(cast_on == owner && !self_castable)
		to_chat(owner, span_warning("I cannot call [src] upon myself!"))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/pointed/rogue_miracle/before_cast(atom/cast_on)
	miracle_failed = FALSE
	return ..()

/datum/action/cooldown/spell/pointed/rogue_miracle/after_cast(atom/cast_on)
	var/mob/living/carbon/human/devotee = owner
	if(miracle_failed)
		reset_spell_cooldown()
	else
		if(devotion_cost && istype(devotee) && devotee.rogue_devotion)
			devotee.rogue_devotion.adjust(-devotion_cost)
			to_chat(devotee, "<font color='purple'>I lost [devotion_cost] devotion.</font>")
		if(stamina_cost && istype(devotee))
			devotee.adjust_stamina_loss(stamina_cost)
		if(max_charges && owner)
			spend_charge()
	return ..()

/// A charge goes. The first spent starts the slow regain; the last one starts the long wait for the whole lot.
/datum/action/cooldown/spell/pointed/rogue_miracle/proc/spend_charge()
	charges = max(charges - 1, 0)
	if(charges <= 0)
		if(charge_timer)
			deltimer(charge_timer)
		charge_timer = addtimer(CALLBACK(src, PROC_REF(refill_charges)), empty_charge_time, TIMER_STOPPABLE)
		to_chat(owner, span_warning("[src] is spent. It will take [DisplayTimeText(empty_charge_time)] to recover."))
	else if(!charge_timer)
		charge_timer = addtimer(CALLBACK(src, PROC_REF(regain_charge)), charge_time, TIMER_STOPPABLE)
		to_chat(owner, span_notice("[src]: [charges] of [max_charges] charges left."))
	build_all_button_icons()

/datum/action/cooldown/spell/pointed/rogue_miracle/proc/regain_charge()
	charge_timer = null
	charges = min(charges + 1, max_charges)
	if(charges < max_charges)
		charge_timer = addtimer(CALLBACK(src, PROC_REF(regain_charge)), charge_time, TIMER_STOPPABLE)
	build_all_button_icons()

/datum/action/cooldown/spell/pointed/rogue_miracle/proc/refill_charges()
	charge_timer = null
	charges = max_charges
	if(owner)
		to_chat(owner, span_notice("[src] has recovered."))
	build_all_button_icons()

/// The cast went wrong after it began (Ratwood revert_cast()): nothing is spent. Returns FALSE for cast() to return.
/datum/action/cooldown/spell/pointed/rogue_miracle/proc/fail(message)
	miracle_failed = TRUE
	if(message)
		to_chat(owner, span_warning(message))
	return FALSE

/// A miracle that kept on after the cast (a prayer, a strand of blood) was broken off: devotion and cooldown come back.
/datum/action/cooldown/spell/pointed/rogue_miracle/proc/refund()
	var/mob/living/carbon/human/devotee = owner
	if(devotion_cost && istype(devotee) && devotee.rogue_devotion)
		devotee.rogue_devotion.adjust(devotion_cost)
	if(stamina_cost && istype(devotee))
		devotee.adjust_stamina_loss(-stamina_cost)
	if(max_charges)
		charges = min(charges + 1, max_charges)
		if(charges >= max_charges && charge_timer)
			deltimer(charge_timer)
			charge_timer = null
		build_all_button_icons()
	reset_spell_cooldown()

/// Ratwood's Psydonite: the devout of the weeping god turn most miracles away.
/datum/action/cooldown/spell/pointed/rogue_miracle/proc/turned_away(mob/living/target)
	if(!HAS_TRAIT(target, TRAIT_PSYDONITE))
		return FALSE
	target.visible_message(span_info("[target] stirs for a moment, the miracle dissipates."), span_notice("A dull warmth swells in my heart, only to fade as quickly as it arrived."))
	playsound(target, 'modular_redtard/faith/sound/PSY.ogg', 100, FALSE, -1)
	return TRUE

/// Ratwood undead_hater: the holy light of the caster's patron (any but the inhumen) burns the undead.
/datum/action/cooldown/spell/pointed/rogue_miracle/proc/burns_undead(mob/living/target)
	if(!(target.mob_biotypes & MOB_UNDEAD))
		return FALSE
	var/mob/living/carbon/human/devotee = owner
	return !istype(devotee) || !devotee.rogue_patron || devotee.rogue_patron.rogue_faith_undead_hater

/// A holy symbol of any faith worn or held, not in a pocket (Ratwood req_items: a psicross in the caster's contents).
/proc/rogue_has_holy_symbol(mob/living/carbon/human/devotee)
	for(var/obj/item/worn as anything in devotee.get_equipped_items(INCLUDE_HELD))
		if(istype(worn, /obj/item/clothing/neck/roguetown/psicross))
			return TRUE
	return FALSE

/// The basket: every miracle type but the families, in the order of their names.
/proc/rogue_miracle_basket()
	var/static/list/basket
	if(basket)
		return basket
	var/list/by_name = list()
	for(var/datum/action/cooldown/spell/pointed/rogue_miracle/miracle_type as anything in subtypesof(/datum/action/cooldown/spell/pointed/rogue_miracle))
		if(initial(miracle_type.abstract_miracle_type) == miracle_type)
			continue
		by_name["[initial(miracle_type.name)] [miracle_type]"] = miracle_type
	basket = list()
	for(var/key in sort_list(by_name))
		basket += by_name[key]
	return basket

/// What the basket says of a miracle type: name, tier, devotion, forks and gods.
/proc/rogue_miracle_summary(datum/action/cooldown/spell/pointed/rogue_miracle/miracle_type)
	return "[initial(miracle_type.name)] (tier [initial(miracle_type.miracle_tier)], [initial(miracle_type.devotion_cost)] devotion; [initial(miracle_type.miracle_forks)]: [initial(miracle_type.miracle_gods)])"
