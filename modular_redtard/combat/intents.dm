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
	var/swingdelay = 0

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
	return "<font color='#f22'>Extremely Sluggish</font>"

/datum/intent/proc/examine_text()
	var/list/lines = list("<span class='notice'><b>[name]</b> intent</span>")
	if(desc)
		lines += desc
	if(reach != 1)
		lines += "<b>Reach:</b> [reach] paces"
	if(damfactor != 1)
		lines += "<b>Damage:</b> [damfactor]"
	lines += "<b>Armor Penetration:</b> [penfactor ? penfactor : "none"]"
	lines += "<b>Attack Speed:</b> [speed_text()]"
	if(releasedrain)
		lines += "<b>Drain On Release:</b> [releasedrain]"
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
	user?.rogue_refresh_intents()

/obj/item/proc/rogue_on_unwield(obj/item/source, mob/living/user)
	rogue_wielded = FALSE
	user?.rogue_refresh_intents()

/obj/item/proc/rogue_intents()
	return (rogue_wielded && length(gripped_intents)) ? gripped_intents : possible_item_intents

/obj/item/proc/rogue_wdefense()
	return wdefense + (rogue_wielded ? wdefense_wbonus : 0)

/obj/item/proc/rogue_apply_intent(datum/intent/intent)
	if(!intent)
		rogue_current_bclass = null
		return
	rogue_current_bclass = intent.blade_class
	sharpness = intent.get_sharpness()
	armour_penetration = initial(armour_penetration) + intent.penfactor
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

/mob/living/proc/rogue_intent_slot(hand_index = active_hand_index)
	return LAZYACCESS(rogue_intent_index, "[hand_index]") || 1

/mob/living/proc/rogue_hand_intent(hand_index = active_hand_index)
	var/obj/item/held = get_item_for_held_index(hand_index)
	var/list/intents = held?.rogue_intents()
	if(!length(intents))
		return null
	return rogue_intent(intents[clamp(rogue_intent_slot(hand_index), 1, length(intents))])

/mob/living/proc/rogue_active_intent()
	return rogue_hand_intent(active_hand_index)

/mob/living/proc/rogue_select_intent(slot)
	var/obj/item/held = get_active_held_item()
	var/list/intents = held?.rogue_intents()
	if(!length(intents) || slot < 1 || slot > min(length(intents), ROGUE_INTENT_SLOTS))
		return FALSE
	LAZYSET(rogue_intent_index, "[active_hand_index]", slot)
	held.rogue_apply_intent(rogue_active_intent())
	playsound_local(src, 'sound/machines/click.ogg', 50, FALSE)
	SEND_SIGNAL(src, COMSIG_MOB_ROGUE_INTENT_CHANGED)
	return TRUE

/mob/living/proc/rogue_refresh_intents()
	var/obj/item/held = get_active_held_item()
	held?.rogue_apply_intent(rogue_active_intent())
	SEND_SIGNAL(src, COMSIG_MOB_ROGUE_INTENT_CHANGED)

/mob/living/proc/rogue_examine_intent(slot)
	var/obj/item/held = get_active_held_item()
	var/list/intents = held?.rogue_intents()
	if(!length(intents) || slot < 1 || slot > length(intents))
		return
	var/datum/intent/intent = rogue_intent(intents[slot])
	to_chat(src, intent.examine_text())

/mob/living/proc/rogue_toggle_def_intent()
	rogue_def_intent = rogue_def_intent == ROGUE_INTENT_PARRY ? ROGUE_INTENT_DODGE : ROGUE_INTENT_PARRY
	playsound_local(src, 'sound/machines/click.ogg', 50, FALSE)
	SEND_SIGNAL(src, COMSIG_MOB_ROGUE_INTENT_CHANGED)
	to_chat(src, span_info("I will [rogue_def_intent == ROGUE_INTENT_PARRY ? "parry" : "dodge"] incoming blows."))
