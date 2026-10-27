/**
 * XYLIX'S FORTUNE (Ratwood code/modules/roguetown/roguemachine/lottery.dm): coins go in as the tithe, between a floor and a
 * ceiling; a spin either grows the tithe (by a tenth to double) or takes it all. The odds are Ratwood's: a base chance plus the
 * gambler's fortune, less a house penalty. Click with an empty hand to spin or cash out, right click to cash out. The tithe is
 * the machine's coin budget; the machine's idle chatter is not ported.
 */
/obj/structure/roguemachine/lottery_roguetown
	/// A spin is under way; nothing else happens until it ends.
	var/spinning = FALSE

/obj/structure/roguemachine/lottery_roguetown/Initialize(mapload)
	. = ..()
	set_light(5, 1, "#1b7bf1")

/obj/structure/roguemachine/lottery_roguetown/examine(mob/user)
	. = ..()
	. += span_info("Insert [rogue_value("trade_lottery_min_tithe")] to [rogue_value("trade_lottery_max_tithe")] mammons, then click to spin. Right click cashes the tithe out.")
	if(budget)
		. += span_info("The current tithe is [budget] mammons.")

/obj/structure/roguemachine/lottery_roguetown/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.combat_mode || !istype(tool, /obj/item/roguecoin))
		return NONE
	if(spinning)
		return ITEM_INTERACT_BLOCKING
	if(!rogue_coin_accepted(tool))
		return ITEM_INTERACT_BLOCKING
	var/value = tool.get_real_price()
	if(budget + value > rogue_value("trade_lottery_max_tithe"))
		refuse("This puts the starting tithe over [rogue_value("trade_lottery_max_tithe")] mammons.")
		return ITEM_INTERACT_BLOCKING
	if(budget + value < rogue_value("trade_lottery_min_tithe"))
		refuse("This is below [rogue_value("trade_lottery_min_tithe")] mammons.")
		return ITEM_INTERACT_BLOCKING
	take_coins(tool, user)
	say("Your current tithe is now [budget] mammons. Care to spin?")
	playsound(src, ROGUE_SOUND_MACHINE_QUESTION, 100, FALSE, -1)
	return ITEM_INTERACT_SUCCESS

/obj/structure/roguemachine/lottery_roguetown/interact(mob/user)
	if(!ishuman(user) || spinning)
		return TRUE
	if(budget <= 0)
		say(pick("Eager fool; you need mammons to gamble your life away.", "You are missing your tithe.", "A lord without land is no lord at all."))
		playsound(src, ROGUE_SOUND_MACHINE_TALK, 100, FALSE, -1)
		return TRUE
	var/choice = tgui_alert(user, "Your current tithe is [budget] mammons. Care to spin?", name, list("Spin", "Cash out", "Walk away"))
	if(QDELETED(src) || spinning || !user.Adjacent(src))
		return TRUE
	switch(choice)
		if("Spin")
			spin(user)
		if("Cash out")
			cash_out(user)
	return TRUE

/obj/structure/roguemachine/lottery_roguetown/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || !ishuman(user))
		return
	if(!spinning)
		cash_out(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/roguemachine/lottery_roguetown/proc/cash_out(mob/user)
	if(budget <= 0)
		say("Poor thing, you are coinless.")
		return
	return_change(user)

/// Starts a spin (Ratwood MiddleClick()): the machine shakes, and the wheel stops after a few seconds.
/obj/structure/roguemachine/lottery_roguetown/proc/spin(mob/living/user)
	if(spinning || budget <= 0)
		return
	spinning = TRUE
	say(pick("Around and around I go, where I stop, only I know.", "Xylix smiles upon your idiocy, child.", "The wheel of fate spins, and spins.", "Oh, you poor fool.", "This is going to hurt for one of us.", "I laugh, you cry; I weep, you cheer..", "I will be your fool; I'll perform for you...", "Let's go gambling!", "Around and around, folly abounds.", "Dance with ruin and wealth."))
	playsound(src, ROGUE_SOUND_MACHINE_TALK, 100, FALSE, -1)
	playsound(src, ROGUE_SOUND_GAMBLING, 100, FALSE, -1)
	var/chance = rogue_value("trade_lottery_base_chance") + user.rogue_stat(ROGUE_STAT_FORTUNE) - rogue_value("trade_lottery_house_penalty")
	var/start_x = pixel_x
	animate(src, pixel_x = start_x + 1, time = 1)
	animate(pixel_x = start_x - 1, time = 1)
	animate(pixel_x = start_x, time = 1)
	addtimer(CALLBACK(src, PROC_REF(finish_spin), chance), rogue_value("trade_lottery_spin_time"))

/// The wheel stops (Ratwood): a win multiplies the tithe, a loss takes it.
/obj/structure/roguemachine/lottery_roguetown/proc/finish_spin(chance)
	spinning = FALSE
	if(rand(1, 100) < chance)
		var/old_tithe = budget
		budget = round(budget * pick(1.1, 1.1, 1.1, 1.1, 1.2, 1.2, 1.2, 1.4, 1.4, 2))
		if(budget == old_tithe)
			budget += pick(1, 1, 1, 1, 2, 2)
		say(pick("Well-maneuvered, aristocrat! Your peasant's tithe is now [budget] mammons. Play again?", "A bountiful harvest, this year- the peasant's tithe rises to [budget] mammons. Spin me again?"))
		playsound(src, ROGUE_SOUND_MACHINE_TALK, 100, FALSE, -1)
		return
	budget = 0
	say(pick("TEN, WHEEL OF FORTUNE - inversed.", "The Castle. O, Omen!", "A harvest of locusts...!", "Look into my eyes and whisper your woes.", "Aw, dangit.", "Fool. Poor fool.", "Your eyes leak out of your skull, drool falling from your lips.", "Divine idiocy.", "You stand just as I did; loser and a freek."))
	playsound(src, ROGUE_SOUND_BUG, 100, FALSE, -1)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/movable, say), pick("King of fools, your land is barren. Play again?", "Divine comedy. Play again?", "Next time, surely. Play again?", "Haha-...ah-ha-ha! Again! Play again, jester!", "Poor beggar! Spin me again?")), 2 SECONDS)
