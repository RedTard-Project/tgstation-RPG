/// Ratwood's triumph shop (controllers/subsystem/rogue/triumphs: triumph_buys, triumph_buy_menu) in a window of its own,
/// with the leaderboard of this season and the past ones (Ratwood show_triumph_leaderboard()). Players spend triumphs on
/// effects of the round or of their next character. Whoever pays as much takes a round effect back off ("unbuy"), and its
/// buyer gets part of its cost back; a buy that conflicts with an active one refunds that one the same way. Open with the
/// Triumphs verb (OOC). Not ported: Ratwood's "Females can be in any job and class" (no role or class of the port is
/// limited by sex), and its paging (the window scrolls).

#define ROGUE_TRIUMPH_CATEGORY_ROUND "Round Effects"
#define ROGUE_TRIUMPH_CATEGORY_CHARACTER "Character"
#define ROGUE_TRIUMPH_CATEGORY_MISC "Misc"

/// Whether triumphs can be spent in the shop (Ratwood triumph_buys_enabled).
/datum/config_entry/flag/rogue_triumph_buys
	default = TRUE

/datum/rogue_triumph_buy
	abstract_type = /datum/rogue_triumph_buy
	var/name
	var/desc
	var/cost = 0
	var/category = ROGUE_TRIUMPH_CATEGORY_MISC
	/// Can only be bought, or taken back, before the round starts.
	var/pre_round_only = FALSE
	/// Listed among the active effects of the round, where others can take it back.
	var/shown_active = FALSE
	/// Done at once when bought; it never stays among the active ones.
	var/instant = FALSE
	/// Buys that cannot be active beside this one: buying it takes them back and refunds their buyers.
	var/list/conflicts_with
	var/buyer_key
	var/buyer_ckey

/// Right after it is paid for.
/datum/rogue_triumph_buy/proc/on_buy()
	return

/// When it is taken back, or a conflicting buy replaces it.
/datum/rogue_triumph_buy/proc/on_removal()
	return

/// For every character that spawns while it is active (Ratwood post_equip_calls).
/datum/rogue_triumph_buy/proc/on_spawn(mob/living/carbon/human/human)
	return

/datum/rogue_triumph_buy/pick_any_class
	name = "Pick Any Class"
	desc = "Your next class choice offers every class there is, whatever your role, once."
	cost = 5
	category = ROGUE_TRIUMPH_CATEGORY_CHARACTER

/datum/rogue_triumph_buy/wipe_triumphs
	name = "Burn the Hall"
	desc = "Burn down the hall of triumphs! Bring everyone back to ZERO and begin a new season."
	cost = 180
	instant = TRUE

/datum/rogue_triumph_buy/wipe_triumphs/on_buy()
	rogue_triumph_new_season()
	to_chat(world, span_redtext("[buyer_key] burns the hall of triumphs to the ground!"))

/datum/rogue_triumph_buy/grenzelhoft
	name = "Grenzelhoft Pilgrimage"
	desc = "Everyone is a human from Grenzelhoft!"
	cost = 60
	category = ROGUE_TRIUMPH_CATEGORY_ROUND
	pre_round_only = TRUE
	shown_active = TRUE

/datum/rogue_triumph_buy/grenzelhoft/on_spawn(mob/living/carbon/human/human)
	if(QDELETED(human))
		return
	if(!istype(human.dna?.species, /datum/species/human))
		human.set_species(/datum/species/human)
	human.skin_tone = "caucasian1"
	human.update_body(is_creating = TRUE)

GLOBAL_DATUM_INIT(rogue_triumph_shop, /datum/rogue_triumph_shop, new)

/datum/rogue_triumph_shop
	/// One of each buy, as the shop lists them.
	var/list/datum/rogue_triumph_buy/catalog = list()
	/// What was bought this round and still holds.
	var/list/datum/rogue_triumph_buy/active = list()
	/// Leaderboards of past seasons for the window, read once: list(list("season", "board")).
	var/list/past_boards

/datum/rogue_triumph_shop/New()
	for(var/buy_type in valid_subtypesof(/datum/rogue_triumph_buy))
		catalog += new buy_type

/datum/rogue_triumph_shop/proc/enabled()
	return rogue_lobby_enabled() && CONFIG_GET(flag/rogue_triumph_buys)

/// Whether an active buy keeps this one from being bought.
/datum/rogue_triumph_shop/proc/blocked(datum/rogue_triumph_buy/listed)
	for(var/datum/rogue_triumph_buy/held as anything in active)
		for(var/conflict_type in held.conflicts_with)
			if(istype(listed, conflict_type))
				return TRUE
	return FALSE

/datum/rogue_triumph_shop/proc/buy(client/buyer, datum/rogue_triumph_buy/listed)
	if(!enabled() || !buyer?.ckey)
		return
	if(listed.pre_round_only && SSticker.HasRoundStarted())
		to_chat(buyer, span_warning("The round has already started."))
		return
	if(blocked(listed))
		to_chat(buyer, span_warning("[listed.name] conflicts with something already bought."))
		return
	var/have = rogue_get_triumphs(buyer.ckey)
	if(have < listed.cost)
		to_chat(buyer, span_warning("I haven't TRIUMPHED enough. [listed.name] costs [listed.cost], I have [have]."))
		return
	if(tgui_alert(buyer.mob, "Spend [listed.cost] triumphs on [listed.name]?", "Triumphs", list("Yes", "No")) != "Yes" || !buyer)
		return
	// The answer took a while: check again.
	if(rogue_get_triumphs(buyer.ckey) < listed.cost || blocked(listed) || (listed.pre_round_only && SSticker.HasRoundStarted()))
		to_chat(buyer, span_warning("I can no longer buy [listed.name]."))
		return
	rogue_adjust_triumphs(buyer.ckey, -listed.cost)
	var/datum/rogue_triumph_buy/bought = new listed.type
	bought.buyer_key = buyer.key
	bought.buyer_ckey = buyer.ckey
	for(var/datum/rogue_triumph_buy/held as anything in active)
		for(var/conflict_type in bought.conflicts_with)
			if(istype(held, conflict_type))
				refund(held, "CONFLICTS")
				break
	log_game("Triumphs: [key_name(buyer)] bought [bought.name] for [bought.cost].")
	if(!bought.instant)
		active += bought
	bought.on_buy()
	if(bought.instant)
		qdel(bought)
	SStgui.update_uis(src)

/// Someone pays the full cost of an active effect to take it back (Ratwood attempt_to_unbuy_triumph_condition()).
/datum/rogue_triumph_shop/proc/unbuy(client/payer, datum/rogue_triumph_buy/held)
	if(!enabled() || !payer?.ckey || !(held in active) || !held.shown_active)
		return
	if(held.pre_round_only && SSticker.HasRoundStarted())
		to_chat(payer, span_warning("The round has already started."))
		return
	var/have = rogue_get_triumphs(payer.ckey)
	if(have < held.cost)
		to_chat(payer, span_warning("I haven't TRIUMPHED enough. Taking back [held.name] costs [held.cost], I have [have]."))
		return
	if(tgui_alert(payer.mob, "Spend [held.cost] triumphs to take back [held.name], bought by [held.buyer_key]?", "Triumphs", list("Yes", "No")) != "Yes" || !payer)
		return
	if(!(held in active) || rogue_get_triumphs(payer.ckey) < held.cost || (held.pre_round_only && SSticker.HasRoundStarted()))
		to_chat(payer, span_warning("I can no longer take back [held.name]."))
		return
	rogue_adjust_triumphs(payer.ckey, -held.cost)
	log_game("Triumphs: [key_name(payer)] took back [held.name] of [held.buyer_ckey] for [held.cost].")
	refund(held, "an UNBUY")
	SStgui.update_uis(src)

/// Ends an active buy and gives its buyer their share back.
/datum/rogue_triumph_shop/proc/refund(datum/rogue_triumph_buy/held, why)
	var/amount = round(held.cost * rogue_value("triumph_refund_share"))
	if(amount > 0)
		rogue_adjust_triumphs(held.buyer_ckey, amount)
		var/client/buyer = GLOB.directory[held.buyer_ckey]
		if(buyer)
			to_chat(buyer, span_redtext("You were refunded [amount] triumphs due to [why]."))
	active -= held
	held.on_removal()
	qdel(held)

/// Uses up a "Pick Any Class" of this player, if they have one.
/datum/rogue_triumph_shop/proc/take_any_class(ckey)
	for(var/datum/rogue_triumph_buy/pick_any_class/held in active)
		if(held.buyer_ckey == ckey)
			active -= held
			qdel(held)
			SStgui.update_uis(src)
			return TRUE
	return FALSE

/datum/rogue_triumph_shop/proc/on_spawn(mob/living/carbon/human/human)
	for(var/datum/rogue_triumph_buy/held as anything in active)
		held.on_spawn(human)

/// Pre-round buys close for good.
/datum/rogue_triumph_shop/proc/round_started()
	SStgui.update_uis(src)

/datum/rogue_triumph_shop/proc/season_changed()
	past_boards = null
	update_static_data_for_all_viewers()

/datum/rogue_triumph_shop/proc/past_board_data()
	if(isnull(past_boards))
		past_boards = list()
		for(var/season in rogue_triumph_season() - 1 to 1 step -1)
			if(!fexists(rogue_triumph_board_path(season)))
				continue
			past_boards += list(list(
				"season" = season,
				"board" = board_rows(rogue_triumph_board(season)),
			))
	return past_boards

/datum/rogue_triumph_shop/proc/board_rows(list/board)
	. = list()
	for(var/key in board)
		. += list(list("key" = key, "triumphs" = board[key]))

/datum/rogue_triumph_shop/ui_state(mob/user)
	return GLOB.always_state

/datum/rogue_triumph_shop/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RogueTriumphShop", "Triumphs")
		ui.open()

/datum/rogue_triumph_shop/ui_static_data(mob/user)
	var/list/buys = list()
	for(var/datum/rogue_triumph_buy/listed as anything in catalog)
		buys += list(list(
			"type" = "[listed.type]",
			"name" = listed.name,
			"desc" = listed.desc,
			"cost" = listed.cost,
			"category" = listed.category,
			"pre_round_only" = listed.pre_round_only,
		))
	return list(
		"categories" = list(ROGUE_TRIUMPH_CATEGORY_ROUND, ROGUE_TRIUMPH_CATEGORY_CHARACTER, ROGUE_TRIUMPH_CATEGORY_MISC),
		"buys" = buys,
		"past_seasons" = past_board_data(),
		"board_min" = rogue_value("triumph_board_min"),
		"refund_percent" = round(rogue_value("triumph_refund_share") * 100),
	)

/datum/rogue_triumph_shop/ui_data(mob/user)
	var/ckey = user.ckey
	var/pq = rogue_get_pq(ckey)
	var/list/pq_step = rogue_pq_rank_step(pq)
	var/round_started = SSticker.HasRoundStarted()
	var/list/blocked_types = list()
	for(var/datum/rogue_triumph_buy/listed as anything in catalog)
		if(blocked(listed))
			blocked_types += "[listed.type]"
	var/list/active_rows = list()
	for(var/datum/rogue_triumph_buy/held as anything in active)
		if(!held.shown_active)
			continue
		active_rows += list(list(
			"ref" = REF(held),
			"name" = held.name,
			"desc" = held.desc,
			"cost" = held.cost,
			"buyer" = held.buyer_key,
			"locked" = held.pre_round_only && round_started,
		))
	var/list/mine = list()
	for(var/datum/rogue_triumph_buy/held as anything in active)
		if(held.buyer_ckey == ckey && !held.shown_active)
			mine += held.name
	return list(
		"enabled" = enabled(),
		"triumphs" = rogue_get_triumphs(ckey),
		"pq" = pq,
		"pq_rank" = pq_step[2],
		"pq_color" = pq_step[3],
		"season" = rogue_triumph_season(),
		"round_started" = round_started,
		"blocked" = blocked_types,
		"active" = active_rows,
		"mine" = mine,
		"board" = board_rows(rogue_triumph_board()),
	)

/datum/rogue_triumph_shop/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/client/user = ui.user?.client
	if(!user)
		return
	switch(action)
		if("buy")
			var/buy_type = text2path(params["type"])
			for(var/datum/rogue_triumph_buy/listed as anything in catalog)
				if(listed.type == buy_type)
					buy(user, listed)
					break
			return TRUE
		if("unbuy")
			var/datum/rogue_triumph_buy/held = locate(params["ref"]) in active
			if(held)
				unbuy(user, held)
			return TRUE
		if("my_pq")
			rogue_show_pq(user, user.ckey)
			return TRUE

/// A bought "Pick Any Class" turns the next class choice into a choice of every class.
/datum/rockhill_class_select/New(mob/living/carbon/human/human, title, list/class_paths)
	var/ckey = ckey(human?.mind?.key)
	if(ckey && GLOB.rogue_triumph_shop.take_any_class(ckey))
		var/list/every_class = list()
		for(var/datum/rockhill_advclass/class_type as anything in subtypesof(/datum/rockhill_advclass))
			if(initial(class_type.name))
				every_class += class_type
		class_paths = every_class
		to_chat(human, span_notice("My triumph lets me choose any class."))
	return ..(human, title, class_paths)

GAME_VERB_DESC(/client, rogue_triumphs, "Triumphs", "Spend your triumphs and see the leaderboard of the season.", "OOC")
	if(!rogue_lobby_enabled())
		to_chat(src, span_warning("There are no triumphs in this world."))
		return
	GLOB.rogue_triumph_shop.ui_interact(mob)

#undef ROGUE_TRIUMPH_CATEGORY_ROUND
#undef ROGUE_TRIUMPH_CATEGORY_CHARACTER
#undef ROGUE_TRIUMPH_CATEGORY_MISC
