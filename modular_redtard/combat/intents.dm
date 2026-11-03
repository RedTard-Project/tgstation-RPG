GLOBAL_LIST_EMPTY(rogue_intents)

/proc/rogue_intent(intent_type)
	if(!ispath(intent_type, /datum/intent))
		return null
	if(!GLOB.rogue_intents[intent_type])
		GLOB.rogue_intents[intent_type] = new intent_type
	return GLOB.rogue_intents[intent_type]

/datum/intent
	var/name = "intent"
	var/desc = ""
	var/icon = 'modular_redtard/icons/mob/rogueintents.dmi'
	var/icon_state = "instrike"
	var/list/attack_verb = list("hits", "strikes")
	var/blade_class = BCLASS_BLUNT
	var/item_d_type = ROGUE_ARMOR_BLUNT
	var/list/hitsound
	var/canparry = TRUE
	var/candodge = TRUE
	var/damfactor = 1
	var/penfactor = 0
	var/clickcd = ROGUE_CLICK_CD_MELEE
	var/releasedrain = 1
	var/misscost = 1
	var/reach = 1
	var/no_attack = FALSE
	var/unarmed = FALSE
	var/chargetime = 0
	/// Stamina drained every second while a full charge is held (Ratwood).
	var/chargedrain = 0
	/// Movement slowdown while charging (Ratwood).
	var/charging_slowdown = 0
	/// Moving while charging drops the charge (Ratwood).
	var/movement_interrupt = FALSE
	/// Letting go before the charge is full cancels the blow instead of striking weaker (Ratwood).
	var/no_early_release = FALSE
	/// Overlay of effects.dmi shown over the attacker while charging (Ratwood warnie).
	var/warnie
	var/swingdelay = 0
	var/swingdelay_type = ROGUE_SWINGDELAY_NORMAL
	/// Distance at which the penetration applies in full, see effective_range_type (Ratwood).
	var/effective_range = 0
	var/effective_range_type = ROGUE_EFF_RANGE_NONE
	/// Extra sharpness lost per landed or parried blow (Ratwood).
	var/sharpness_penalty = 0
	/// How hard the intent wears armor down (Ratwood), combined with the item's intdamage_factor.
	var/intent_intdamage_factor = 1
	/// No attack animation and no swing at empty tiles (Ratwood).
	var/noaa = FALSE
	/// What one does on a swing at the air, said of oneself ("I swing a fist at the air!").
	var/miss_text
	/// The same said of someone else ("X swings a fist at the air!"); none means miss_text.
	var/miss_text_others
	var/miss_sound
	/// Stat changes a landed blow of an effect intent puts on the target (Ratwood intent_effect, e.g. a mordhau's dazing strike).
	var/list/effect_stats
	var/effect_duration = 0
	var/effect_name
	/// Body parts the effect needs to be aimed at; none listed means any.
	var/list/effect_zones
	var/tranged = FALSE
	var/tshield = FALSE

/datum/intent/proc/out_of_effective_range(distance)
	switch(effective_range_type)
		if(ROGUE_EFF_RANGE_EXACT)
			return distance != effective_range
		if(ROGUE_EFF_RANGE_ABOVE)
			return distance < effective_range
		if(ROGUE_EFF_RANGE_BELOW)
			return distance > effective_range
	return FALSE

/datum/intent/proc/get_sharpness()
	switch(blade_class)
		if(BCLASS_CUT, BCLASS_CHOP, BCLASS_LASHING)
			return SHARP_EDGED
		if(BCLASS_STAB, BCLASS_PICK, BCLASS_PIERCE, BCLASS_BITE)
			return SHARP_POINTY
	return NONE

/datum/intent/proc/speed_text()
	if(clickcd <= 8)
		return "<font color='#4af'>Very Quick</font>"
	if(clickcd <= 10)
		return "<font color='#8f8'>Quick</font>"
	if(clickcd <= ROGUE_CLICK_CD_MELEE)
		return "Normal"
	if(clickcd <= 14)
		return "<font color='#fa4'>Sluggish</font>"
	if(clickcd <= 16)
		return "<font color='#f44'>Very Sluggish</font>"
	if(clickcd <= 20)
		return "<font color='#f22'>Extremely Sluggish</font>"
	return "<font color='#d11'>Glacial</font>"

/datum/intent/proc/swingdelay_text()
	var/delay = "<font color='#fa4'>Moderate</font>"
	if(swingdelay > 8)
		delay = "<font color='#f22'>Heavy</font>"
	else if(swingdelay > 4)
		delay = "<font color='#f44'>Significant</font>"
	switch(swingdelay_type)
		if(ROGUE_SWINGDELAY_PENALTY)
			return "[delay] | Type: <font color='#dab141'>Difficult</font> (my parries and dodges are much weaker while I swing)"
		if(ROGUE_SWINGDELAY_CANCEL, ROGUE_SWINGDELAY_CANCELSLOW)
			return "[delay] | Type: <font color='#a70d0d'>Rigid</font> (I cannot defend while I swing, and a hit interrupts the swing)"
	return "[delay] | Type: Normal"

/// Intent description in the manner of Azure Peak and Ratwood (Shift+click on an intent).
/datum/intent/proc/examine_text()
	var/list/lines = list("<span class='notice'><b>[name]</b> intent</span>")
	if(desc)
		lines += desc
	if(reach != 1)
		lines += "<b>Reach:</b> [reach] paces"
	if(effective_range && effective_range_type)
		var/static/list/range_words = list("exactly", "at and beyond", "at and within")
		lines += "<b>Effective Range:</b> [range_words[effective_range_type]] [effective_range] paces"
	if(damfactor != 1)
		lines += "<b>Damage:</b> [damfactor]"
	lines += "<b>Armor Penetration:</b> [penfactor > ROGUE_PEN_NONE ? rogue_tier_rating(uppertext(item_d_type), penfactor) : "<font color='#808080'>NONE</font>"]"
	if(chargetime)
		lines += "<b>Charge Time</b>"
	if(movement_interrupt)
		lines += "<b>Interrupted by Movement</b>"
	if(no_early_release)
		lines += "<b>No Early Release</b>"
	if(chargedrain)
		lines += "<b>Drain While Charged:</b> [chargedrain]"
	if(releasedrain)
		lines += "<b>Drain On Release:</b> [releasedrain]"
	if(misscost)
		lines += "<b>Drain On Miss:</b> [misscost]"
	lines += "<b>Attack Speed:</b> [speed_text()]"
	if(swingdelay > 0)
		lines += "<b>Attack Delay:</b> [swingdelay_text()]"
	if(intent_intdamage_factor != 1)
		lines += "This intent deals [abs(intent_intdamage_factor - 1) * 100]% [intent_intdamage_factor > 1 ? "more" : "less"] damage to armor integrity."
	if(sharpness_penalty)
		lines += "This intent will cost some sharpness for every attack made."
	if(!canparry)
		lines += "This attack cannot be parried."
	if(!candodge)
		lines += "This attack cannot be dodged."
	return boxed_message(jointext(lines, "\n"))

/obj/item
	var/list/possible_item_intents
	var/list/gripped_intents
	var/rogue_force_wielded = 0
	var/wdefense = 0
	var/wdefense_wbonus = 0
	var/wlength = WLENGTH_NORMAL
	var/wbalance = WBALANCE_NORMAL
	var/associated_skill
	var/minstr = 0
	var/can_parry = FALSE
	var/list/parrysound
	var/rogue_wielded = FALSE
	var/rogue_current_bclass

/obj/item/Initialize(mapload)
	. = ..()
	if(!length(possible_item_intents))
		return
	AddElement(/datum/element/rogue_weapon)
	if(length(gripped_intents) || rogue_force_wielded)
		AddComponent(/datum/component/two_handed, force_unwielded = force, force_wielded = rogue_force_wielded || force, wield_callback = CALLBACK(src, PROC_REF(rogue_on_wield)), unwield_callback = CALLBACK(src, PROC_REF(rogue_on_unwield)))

/obj/item/proc/rogue_on_wield(obj/item/source, mob/living/user)
	rogue_wielded = TRUE
	if(rogue_alt_grip)
		rogue_set_alt_grip(null, null)
	user?.rogue_refresh_intents()

/obj/item/proc/rogue_on_unwield(obj/item/source, mob/living/user)
	rogue_wielded = FALSE
	user?.rogue_refresh_intents()

/obj/item/proc/rogue_intents()
	if(length(rogue_alt_grip?.grip_intents))
		return rogue_alt_grip.grip_intents
	var/list/intents = (rogue_wielded && length(gripped_intents)) ? gripped_intents : possible_item_intents
	if(length(intents) || !rogue_combat_enabled())
		return intents
	// Ratwood's /obj/item has list(/datum/intent/use), which the porter leaves out where it is inherited: a thing with no
	// intents of its own is used, not swung (no_attack), and the hand's intent grid shows USE instead of empty boxes.
	var/static/list/use_only = list(/datum/intent/use)
	return use_only

/obj/item/proc/rogue_wdefense()
	return wdefense + (rogue_wielded ? wdefense_wbonus : 0)

/obj/item/proc/rogue_apply_intent(datum/intent/intent)
	if(!intent)
		rogue_current_bclass = null
		return
	rogue_current_bclass = intent.blade_class
	sharpness = intent.get_sharpness()
	if(length(intent.hitsound))
		hitsound = pick(intent.hitsound)
	if(length(intent.attack_verb))
		attack_verb_continuous = intent.attack_verb
		attack_verb_simple = intent.attack_verb

/mob/living
	var/list/rogue_intent_index
	var/rogue_def_intent = ROGUE_INTENT_PARRY
	var/rogue_last_parry = 0
	var/rogue_last_dodge = 0

/mob/living/proc/rogue_fist_intents()
	return null

/mob/living/proc/rogue_hand_intents(hand_index = active_hand_index)
	var/obj/item/held = get_item_for_held_index(hand_index)
	return held ? held.rogue_intents() : rogue_fist_intents()

/mob/living/proc/rogue_intent_key(hand_index)
	return get_item_for_held_index(hand_index) ? "[hand_index]" : "fist[hand_index]"

/mob/living/proc/rogue_intent_slot(hand_index = active_hand_index)
	return LAZYACCESS(rogue_intent_index, rogue_intent_key(hand_index)) || 1

/mob/living/proc/rogue_hand_intent(hand_index = active_hand_index)
	var/list/intents = rogue_hand_intents(hand_index)
	if(!length(intents))
		return null
	return rogue_intent(intents[clamp(rogue_intent_slot(hand_index), 1, length(intents))])

/mob/living/proc/rogue_active_intent()
	return rogue_hand_intent(active_hand_index)

/mob/living/proc/rogue_select_intent(slot)
	var/list/intents = rogue_hand_intents()
	if(!length(intents) || slot < 1 || slot > min(length(intents), ROGUE_INTENT_SLOTS))
		return FALSE
	LAZYSET(rogue_intent_index, rogue_intent_key(active_hand_index), slot)
	get_active_held_item()?.rogue_apply_intent(rogue_active_intent())
	playsound_local(src, 'sound/machines/click.ogg', 50, FALSE)
	SEND_SIGNAL(src, COMSIG_MOB_ROGUE_INTENT_CHANGED)
	return TRUE

/mob/living/proc/rogue_refresh_intents()
	var/obj/item/held = get_active_held_item()
	held?.rogue_apply_intent(rogue_active_intent())
	SEND_SIGNAL(src, COMSIG_MOB_ROGUE_INTENT_CHANGED)

/mob/living/proc/rogue_examine_intent(slot)
	var/list/intents = rogue_hand_intents()
	if(!length(intents) || slot < 1 || slot > length(intents))
		return
	var/datum/intent/intent = rogue_intent(intents[slot])
	to_chat(src, intent.examine_text())

/mob/living/proc/rogue_toggle_def_intent()
	rogue_def_intent = rogue_def_intent == ROGUE_INTENT_PARRY ? ROGUE_INTENT_DODGE : ROGUE_INTENT_PARRY
	playsound_local(src, 'sound/machines/click.ogg', 50, FALSE)
	SEND_SIGNAL(src, COMSIG_MOB_ROGUE_INTENT_CHANGED)
	SEND_SIGNAL(src, COMSIG_MOB_ROGUE_DEFENSE_CHANGED)
	to_chat(src, span_info("I will [rogue_def_intent == ROGUE_INTENT_PARRY ? "parry" : "dodge"] incoming blows."))
