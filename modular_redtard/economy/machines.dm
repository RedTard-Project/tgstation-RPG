// Ratwood's roguemachines that deal in coins (code/modules/roguetown/roguemachine/money.dm): coins go in whole and become the
// machine's budget, which buys from it or comes back as change.

/obj/structure/roguemachine
	/// Mammons inserted and not yet spent (Ratwood budget).
	var/budget = 0

/// Ghosts may not peek into the machines' windows (Ratwood ui_status()).
/obj/structure/roguemachine/ui_status(mob/user, datum/ui_state/state)
	if(isobserver(user))
		return UI_CLOSE
	return ..()

/obj/structure/roguemachine/Destroy()
	if(budget > 0)
		rogue_coins_out(budget, null, null, src)
		budget = 0
	return ..()

/// Eats a pile of coins into the budget (Ratwood: every machine swallows coins whole). Returns the mammons taken.
/obj/structure/roguemachine/proc/take_coins(obj/item/roguecoin/coins, mob/user)
	if(!rogue_coin_accepted(coins))
		to_chat(user, span_warning("[src] will not take [coins]."))
		return 0
	var/value = coins.get_real_price()
	qdel(coins)
	budget += value
	playsound(src, ROGUE_SOUND_COIN_INSERT, 100, FALSE, -1)
	SStgui.update_uis(src)
	return value

/// Pays the whole budget back as coins (Ratwood "change").
/obj/structure/roguemachine/proc/return_change(mob/user)
	if(budget <= 0)
		return
	budget -= rogue_coins_out(budget, user, null, src)
	SStgui.update_uis(src)

/// The machine refuses with Ratwood's sound.
/obj/structure/roguemachine/proc/refuse(message)
	if(message)
		say(message)
	playsound(src, ROGUE_SOUND_MACHINE_NO, 100, FALSE, -1)
