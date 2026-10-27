/**
 * Trade of the realm on medieval maps (Ratwood Economy 3: code/controllers/subsystem/rogue/economy/, merchant_trade.dm and
 * roguemachine/merchant/trade/), cut down to what the machines of the port use:
 * - trade goods: what the regions, ships and standing orders deal in, each tied to its item and to its stockpile entry;
 * - regions of the realm: what each produces and demands daily; the stockpile imports from the cheapest producer, and each
 *   region posts standing orders the Steward fills from the stockpile (economy/standing_orders.dm);
 * - foreign realms and their ships: offshore every day, hailed into port by the merchant, buying and selling cargo at the
 *   harbor (economy/harbor.dm).
 * Data is Ratwood's, generated into economy/trade_data.dm. Not ported: economic events and blockades, regional export by the
 * Steward, the merchant's favor, catalogs and upgrades, victualling, kinship, cultural stock.
 */
SUBSYSTEM_DEF(rogue_trade)
	name = "Trade"
	wait = 1 MINUTES
	runlevels = RUNLEVEL_GAME
	dependencies = list(
		/datum/controller/subsystem/rogue_treasury,
	)
	/// Trade good id -> good, for goods whose item is ported.
	var/list/goods = list()
	/// Region id -> region of the realm.
	var/list/regions = list()
	/// Template key -> standing order template.
	var/list/order_templates = list()
	/// Realm id -> foreign realm.
	var/list/realms = list()
	/// Every ship offshore or at the pier.
	var/list/datum/rogue_trade_ship/ships = list()
	/// Hails the merchant has left today (Ratwood hails_remaining).
	var/hails_left = 0
	/// Standing orders open now.
	var/list/datum/rogue_standing_order/orders = list()
	/// Share of a ship sale the merchant takes as middleman, percent (Ratwood merchant_levy_percent).
	var/middleman_cut = 0
	/// Last time the merchant worked the harbor; a long silence brings a ship in unbidden (Ratwood last_merchant_activity).
	var/last_merchant_activity = 0
	/// The dawn a ship last came in unbidden; once a day (Ratwood auto_hail_used_day).
	var/auto_hail_dawn = -1
	var/next_ship_id = 0
	var/next_order_id = 0
	/// Mammons of cargo sold to ships, bought off ships, paid for standing orders.
	var/total_ship_sales = 0
	var/total_ship_purchases = 0
	var/total_order_payouts = 0
	var/total_export_duty = 0

/datum/controller/subsystem/rogue_trade/Initialize()
	if(!rogue_economy_enabled())
		can_fire = FALSE
		return SS_INIT_NO_NEED
	for(var/good_type in subtypesof(/datum/rogue_trade_good))
		var/datum/rogue_trade_good/good = new good_type
		if(good.id && good.item_type)
			goods[good.id] = good
	link_stockpile()
	for(var/region_type in subtypesof(/datum/rogue_trade_region))
		var/datum/rogue_trade_region/region = new region_type
		regions[region.id] = region
	for(var/template_type in subtypesof(/datum/rogue_order_template))
		var/datum/rogue_order_template/template = new template_type
		order_templates[template.key] = template
	for(var/realm_type in subtypesof(/datum/rogue_foreign_realm))
		var/datum/rogue_foreign_realm/realm = new realm_type
		realms[realm.id] = realm
	register_levy(ROGUE_TAX_HEADEATER, rogue_value("trade_headeater_levy"))
	register_levy(ROGUE_TAX_EXPORT, rogue_value("trade_export_duty"))
	middleman_cut = rogue_value("trade_middleman_cut")
	last_merchant_activity = world.time
	reset_regions()
	start_day()
	RegisterSignal(SSdcs, COMSIG_GLOB_ROCKHILL_TIME_OF_DAY, PROC_REF(on_time_of_day))
	return SS_INIT_SUCCESS

/datum/controller/subsystem/rogue_trade/stat_entry(msg)
	msg = "Ships: [length(docked_ships())]/[length(ships)], orders: [length(orders)]"
	return ..()

/// Every minute: ships whose time at the pier is up sail; a harbor the merchant leaves idle gets a ship unbidden.
/datum/controller/subsystem/rogue_trade/fire(resumed)
	for(var/datum/rogue_trade_ship/ship as anything in docked_ships())
		if(world.time >= ship.dock_expires_at)
			depart(ship)
	auto_hail()

/// A Crown levy the trade code collects, added to the treasury's levies so the Steward sets it with the others.
/datum/controller/subsystem/rogue_trade/proc/register_levy(levy, percent)
	if(!(levy in SSrogue_treasury.tax_rates))
		SSrogue_treasury.tax_rates[levy] = percent / 100

/// Ties each trade good to its stockpile entry (Ratwood trade_good_id), or to the entry that takes the same item.
/datum/controller/subsystem/rogue_trade/proc/link_stockpile()
	for(var/datum/roguestock/stock as anything in SSrogue_treasury.stockpile_datums)
		var/datum/rogue_trade_good/good = goods[GLOB.rogue_stock_trade_goods["[stock.type]"]]
		if(!good)
			for(var/id in goods)
				var/datum/rogue_trade_good/candidate = goods[id]
				if(candidate.item_type == stock.item_type)
					good = candidate
					break
		if(good && !good.stock)
			good.stock = stock
			stock.trade_good = good

/// The trade good an item is sold as at the harbor (Ratwood identify_trade_good()).
/datum/controller/subsystem/rogue_trade/proc/good_for(obj/item/thing)
	for(var/id in goods)
		var/datum/rogue_trade_good/good = goods[id]
		if(good.accepts(thing))
			return good
	return null

/// Players who count for the size of the day's trade (Ratwood get_active_player_count()).
/datum/controller/subsystem/rogue_trade/proc/player_count()
	return length(GLOB.alive_player_list)

// The day.

/datum/controller/subsystem/rogue_trade/proc/on_time_of_day(datum/source, datum/rockhill_clock_step/phase/old_phase, datum/rockhill_clock_step/phase/new_phase)
	SIGNAL_HANDLER
	if(new_phase?.name != ROCKHILL_DAWN)
		return
	INVOKE_ASYNC(src, PROC_REF(new_day))

/// A new dawn (Ratwood daily_tick() of the economy and of merchant trade): the regions' trade resets, open orders run out,
/// new ones are posted, the merchant's hails refill and a new set of ships waits offshore.
/datum/controller/subsystem/rogue_trade/proc/new_day()
	reset_regions()
	start_day()

/datum/controller/subsystem/rogue_trade/proc/start_day()
	hails_left = rogue_value("trade_hails_per_day")
	expire_orders()
	var/posted = roll_orders()
	expire_offshore_ships()
	roll_ships()
	if(posted)
		rogue_scom_announce("[posted] new standing order\s for the Crown.")

/// Each region's daily produce and demand, grown with the population (Ratwood REGION_POP_SCALE_*).
/datum/controller/subsystem/rogue_trade/proc/reset_regions()
	var/pop_mult = min(rogue_value("trade_region_pop_max"), 1 + player_count() * rogue_value("trade_region_pop_per_player"))
	for(var/id in regions)
		var/datum/rogue_trade_region/region = regions[id]
		region.new_day(pop_mult)

// Regions: imports for the stockpile.

/**
 * The cheapest region that produces a good today, and the price of the next unit from it (Ratwood get_best_import_region()
 * and compute_import_unit_price()): a region sells at the good's trade price up to its daily pace, dearer past it.
 * Returns list("region" = region, "unit_cost" = mammons) or null when no region produces the good.
 */
/datum/controller/subsystem/rogue_trade/proc/import_quote(datum/rogue_trade_good/good)
	if(!good)
		return null
	var/datum/rogue_trade_region/best
	var/best_cost = INFINITY
	for(var/id in regions)
		var/datum/rogue_trade_region/region = regions[id]
		var/cost = region.import_unit_cost(good)
		if(cost && cost < best_cost)
			best = region
			best_cost = cost
	if(!best)
		return null
	return list("region" = best, "unit_cost" = best_cost)

// Standing orders.

/datum/controller/subsystem/rogue_trade/proc/expire_orders()
	for(var/datum/rogue_standing_order/order as anything in orders.Copy())
		if(order.dawn_expires <= GLOB.rockhill_dawns)
			orders -= order
			qdel(order)

/**
 * Posts the day's standing orders (Ratwood daily_tick()): a few more with more players, up to a cap, from regions with fewer
 * than their share open; each region picks one of its templates by weight. Returns how many were posted.
 */
/datum/controller/subsystem/rogue_trade/proc/roll_orders()
	. = 0
	var/to_roll = min(rogue_value("trade_orders_max_per_day"), rogue_value("trade_orders_per_day") + round(player_count() * rogue_value("trade_orders_per_player")))
	for(var/i in 1 to to_roll)
		if(length(orders) >= rogue_value("trade_orders_cap"))
			return
		var/list/eligible = list()
		for(var/id in regions)
			var/datum/rogue_trade_region/region = regions[id]
			if(length(region.order_templates) && open_orders_of(region) < rogue_value("trade_orders_per_region"))
				eligible += region
		if(!length(eligible))
			return
		var/datum/rogue_trade_region/region = pick(eligible)
		var/list/weighted = list()
		for(var/key in region.order_templates)
			var/datum/rogue_order_template/template = order_templates[key]
			if(template)
				weighted[template] = template.roll_weight
		if(!length(weighted))
			continue
		var/datum/rogue_order_template/template = pick_weight(weighted)
		var/datum/rogue_standing_order/order = template.instantiate(region)
		if(order)
			orders += order
			.++

/datum/controller/subsystem/rogue_trade/proc/open_orders_of(datum/rogue_trade_region/region)
	. = 0
	for(var/datum/rogue_standing_order/order as anything in orders)
		if(order.region == region)
			.++

/datum/controller/subsystem/rogue_trade/proc/find_order(order_id)
	for(var/datum/rogue_standing_order/order as anything in orders)
		if(order.id == order_id)
			return order
	return null

/**
 * Fills a standing order from the Crown's stockpile (Ratwood fulfill_order() for stockpile goods). Everything in stock: the
 * goods go and the whole payout comes into the Crown's Purse. Short of some: if what is in stock is worth at least half the
 * order, the Steward may settle it partially for a reduced share; otherwise it is refused.
 * Returns ROGUE_ORDER_FULL, ROGUE_ORDER_PARTIAL, ROGUE_ORDER_NEEDS_CONFIRM, or FALSE.
 */
/datum/controller/subsystem/rogue_trade/proc/fulfill_order(datum/rogue_standing_order/order, mob/user, partial = FALSE)
	if(!order || !(order in orders))
		return FALSE
	var/list/delivered = list()
	var/delivered_value = 0
	var/list/short = list()
	for(var/datum/rogue_trade_good/good as anything in order.required)
		var/needed = order.required[good]
		var/have = good.stock ? min(good.stock.stockpile_amount, needed) : 0
		delivered[good] = have
		delivered_value += order.unit_payout(good) * have
		if(have < needed)
			short += good.name
	var/payout
	if(!length(short))
		payout = order.payout
		. = ROGUE_ORDER_FULL
	else
		var/coverage = order.payout ? delivered_value / order.payout : 0
		if(coverage < rogue_value("trade_order_partial_threshold"))
			to_chat(user, span_warning("Coverage [round(coverage * 100)]% - below the [round(rogue_value("trade_order_partial_threshold") * 100)]% partial threshold. Short on: [english_list(short)]."))
			return FALSE
		if(!partial)
			return ROGUE_ORDER_NEEDS_CONFIRM
		payout = round(delivered_value * rogue_value("trade_order_partial_payout"))
		. = ROGUE_ORDER_PARTIAL
	for(var/datum/rogue_trade_good/good as anything in delivered)
		if(good.stock)
			good.stock.stockpile_amount -= delivered[good]
	orders -= order
	SSrogue_treasury.mint(SSrogue_treasury.crown_purse, payout, "Standing Order[. == ROGUE_ORDER_PARTIAL ? " (Partial)" : ""]: [order.title]")
	total_order_payouts += payout
	if(. == ROGUE_ORDER_FULL)
		to_chat(user, span_notice("Order fulfilled: [payout]m paid to the Crown's Purse."))
	else
		to_chat(user, span_notice("Order settled (partial): [payout]m paid to the Crown's Purse."))
	log_game("STANDING ORDER: [key_name(user)] filled [order.title] for [payout]m ([.])")
	qdel(order)

// Ships.

/datum/controller/subsystem/rogue_trade/proc/docked_ships()
	. = list()
	for(var/datum/rogue_trade_ship/ship as anything in ships)
		if(ship.state == ROGUE_SHIP_DOCKED)
			. += ship

/datum/controller/subsystem/rogue_trade/proc/offshore_ships()
	. = list()
	for(var/datum/rogue_trade_ship/ship as anything in ships)
		if(ship.state == ROGUE_SHIP_OFFSHORE)
			. += ship

/datum/controller/subsystem/rogue_trade/proc/find_ship(ship_id)
	for(var/datum/rogue_trade_ship/ship as anything in ships)
		if(ship.id == ship_id)
			return ship
	return null

/datum/controller/subsystem/rogue_trade/proc/dock_spots()
	return rogue_value("trade_dock_spots")

/// The day's ships wait offshore, from realms picked by weight (Ratwood roll_daily_pool()).
/datum/controller/subsystem/rogue_trade/proc/roll_ships()
	var/list/weighted = list()
	for(var/id in realms)
		var/datum/rogue_foreign_realm/realm = realms[id]
		weighted[realm] = max(1, realm.roll_weight)
	if(!length(weighted))
		return
	for(var/i in 1 to rogue_value("trade_ships_per_day"))
		ships += new /datum/rogue_trade_ship(pick_weight(weighted), ++next_ship_id)

/// Ships nobody hailed sail on at dawn (Ratwood expire_undocked_ships()).
/datum/controller/subsystem/rogue_trade/proc/expire_offshore_ships()
	for(var/datum/rogue_trade_ship/ship as anything in offshore_ships())
		ships -= ship
		qdel(ship)

/// The merchant hails a ship into port (Ratwood hail_ship()). Returns null on success or the reason it failed.
/datum/controller/subsystem/rogue_trade/proc/hail(datum/rogue_trade_ship/ship, mob/user)
	if(!ship || ship.state != ROGUE_SHIP_OFFSHORE)
		return "That ship has sailed on."
	if(hails_left <= 0)
		return "No more hails today."
	if(length(docked_ships()) >= dock_spots())
		return "Every pier is taken."
	hails_left--
	dock(ship)
	var/hail_line = ship.realm.pick_hail_line()
	if(hail_line && user)
		to_chat(user, span_notice("<i>Captain [ship.captain] calls from the deck: \"[hail_line]\"</i>"))
	return null

/datum/controller/subsystem/rogue_trade/proc/dock(datum/rogue_trade_ship/ship)
	ship.state = ROGUE_SHIP_DOCKED
	ship.docked_at = world.time
	ship.dock_expires_at = world.time + rogue_value("trade_dock_time")
	rogue_scom_announce("The [ship.ship_type] [ship.name], flying the colors of [ship.realm.name], has made port at the docks.")

/// The merchant sends a ship away (Ratwood send_away_ship()): not before its grace time unless it came unbidden or its trade
/// was done. Returns null on success or the reason it failed.
/datum/controller/subsystem/rogue_trade/proc/send_away(datum/rogue_trade_ship/ship)
	if(!ship || ship.state != ROGUE_SHIP_DOCKED)
		return "That ship has sailed on."
	if(!ship.auto_hailed && !ship.honored() && world.time < ship.docked_at + rogue_value("trade_send_away_grace"))
		return "The captain will not cast off so soon."
	depart(ship)
	return null

/// A ship leaves port. One whose captain got the trade he hoped for gives the merchant back a hail (Ratwood
/// resolve_ship_favor(), without the favor itself).
/datum/controller/subsystem/rogue_trade/proc/depart(datum/rogue_trade_ship/ship)
	if(!ship.auto_hailed && ship.honored() && hails_left < rogue_value("trade_hails_per_day"))
		hails_left++
	ships -= ship
	qdel(ship)

/datum/controller/subsystem/rogue_trade/proc/touch_merchant_activity()
	last_merchant_activity = world.time

/// A harbor left idle draws a ship in unbidden, once a day (Ratwood auto_hail_tick()).
/datum/controller/subsystem/rogue_trade/proc/auto_hail()
	if(auto_hail_dawn == GLOB.rockhill_dawns || world.time - last_merchant_activity < rogue_value("trade_auto_hail_idle"))
		return
	if(length(docked_ships()) >= dock_spots())
		return
	var/list/weighted = list()
	for(var/datum/rogue_trade_ship/ship as anything in offshore_ships())
		weighted[ship] = max(1, ship.realm.roll_weight)
	if(!length(weighted))
		return
	var/datum/rogue_trade_ship/ship = pick_weight(weighted)
	ship.auto_hailed = TRUE
	auto_hail_dawn = GLOB.rockhill_dawns
	dock(ship)

/// The first docked ship that still buys this good, and its cargo line (Ratwood find_demand_match()).
/datum/controller/subsystem/rogue_trade/proc/find_demand(datum/rogue_trade_good/good)
	for(var/datum/rogue_trade_ship/ship as anything in docked_ships())
		for(var/list/line as anything in ship.demands)
			if(line[ROGUE_LINE_GOOD] == good && line[ROGUE_LINE_DONE] < line[ROGUE_LINE_TARGET])
				return list(ship, line)
	return null

/// Says a line on every SCOM of the realm (Ratwood scom_announce()).
/proc/rogue_scom_announce(message)
	for(var/obj/structure/roguemachine/scomm/scom as anything in GLOB.rockhill_scomms)
		scom.say(message)

/**
 * A good the realm trades in (Ratwood /datum/trade_good): its trade price and its item. Data in economy/trade_data.dm.
 */
/datum/rogue_trade_good
	var/id
	var/name = ""
	/// Trade price of one unit (Ratwood base_price).
	var/base_price = 1
	/// Crown-set multiplier of the price at the stockpile (Ratwood global_price_mod).
	var/global_price_mod = 1
	/// Item path as text, resolved at New(); a good whose item is not ported is left out.
	var/item_path
	var/obj/item/item_type
	/// Any subtype of the item counts (Ratwood accept_subtypes).
	var/accept_subtypes = FALSE
	/// The stockpile entry of the good, if the Crown stocks it.
	var/datum/roguestock/stock

/datum/rogue_trade_good/New()
	. = ..()
	var/path = text2path(item_path)
	if(ispath(path, /obj/item))
		item_type = path

/datum/rogue_trade_good/Destroy()
	stock = null
	return ..()

/// The item is this good (Ratwood identify_trade_good()).
/datum/rogue_trade_good/proc/accepts(obj/item/thing)
	return accept_subtypes ? istype(thing, item_type) : thing.type == item_type

/**
 * A region of the realm (Ratwood /datum/economic_region): how many units of each good it produces and demands a day. Data in
 * economy/trade_data.dm.
 */
/datum/rogue_trade_region
	var/id
	var/name = ""
	var/subtitle = ""
	/// Good id -> units a day at the baseline population.
	var/list/produces = list()
	var/list/demands = list()
	/// Keys of the standing order templates the region posts.
	var/list/order_templates = list()
	/// Good id -> units it still produces today.
	var/list/produces_today = list()

/datum/rogue_trade_region/proc/new_day(pop_mult)
	produces_today = list()
	for(var/id in produces)
		produces_today[id] = max(1, round(produces[id] * pop_mult))

/// Price of the next unit of a good from this region, dearer the more it has sold past its daily pace (Ratwood
/// compute_import_unit_price() with TRADE_ESCALATION_SLOPE); 0 if it does not produce the good.
/datum/rogue_trade_region/proc/import_unit_cost(datum/rogue_trade_good/good)
	var/pace = produces[good.id]
	if(!pace)
		return 0
	var/unit_index = max(0, pace - (produces_today[good.id] || 0)) + 1
	var/overshoot = max(0, (unit_index - pace) / pace)
	return max(1, round(good.base_price * (1 + overshoot * rogue_value("trade_escalation_slope")) * good.global_price_mod))

/// One unit bought from the region (Ratwood manual_import()): its daily produce shrinks.
/datum/rogue_trade_region/proc/take_import(datum/rogue_trade_good/good)
	produces_today[good.id] = (produces_today[good.id] || 0) - 1

/// Names of the goods of a produce or demand list, for the trade windows.
/datum/rogue_trade_region/proc/good_names(list/source)
	. = list()
	for(var/id in source)
		var/datum/rogue_trade_good/good = SSrogue_trade.goods[id]
		if(good)
			. += good.name

/**
 * A template of a region's standing order (Ratwood /datum/standing_order subtypes with plain goods): each mix entry may be in
 * the order (prob), as one of its goods (pick), in a random count. Data in economy/trade_data.dm.
 */
/datum/rogue_order_template
	var/key
	var/title = "STANDING ORDER"
	/// Flavor line; %REGION% is the region's name.
	var/description = ""
	var/roll_weight = 1
	/// list("goods" = ids, "min" =, "max" =, "prob" =) entries.
	var/list/mix = list()

/datum/rogue_order_template/New()
	. = ..()
	key = copytext("[type]", length("[/datum/rogue_order_template]/") + 1)

/// A standing order of this template from the region (Ratwood instantiate_standing_order()); null if none of its goods are
/// stocked by the Crown.
/datum/rogue_order_template/proc/instantiate(datum/rogue_trade_region/region)
	var/list/required = list()
	for(var/list/entry as anything in mix)
		if(!prob(entry["prob"]))
			continue
		var/list/options = list()
		for(var/id in entry["goods"])
			var/datum/rogue_trade_good/good = SSrogue_trade.goods[id]
			if(good?.stock)
				options += good
		if(!length(options))
			continue
		var/datum/rogue_trade_good/good = pick(options)
		required[good] = (required[good] || 0) + rand(entry["min"], entry["max"])
	if(!length(required))
		return null
	var/datum/rogue_standing_order/order = new
	order.id = ++SSrogue_trade.next_order_id
	order.region = region
	order.title = "[uppertext(region.name)] - [title]"
	order.description = replacetext(description, "%REGION%", region.name)
	order.required = required
	order.dawn_issued = GLOB.rockhill_dawns
	order.dawn_expires = GLOB.rockhill_dawns + rogue_value("trade_order_days")
	for(var/datum/rogue_trade_good/good as anything in required)
		order.payout += order.unit_payout(good) * required[good]
	return order

/// An open standing order of a region (Ratwood /datum/standing_order).
/datum/rogue_standing_order
	var/id
	var/datum/rogue_trade_region/region
	var/title
	var/description
	/// Good -> units wanted.
	var/list/required = list()
	/// Mammons the Crown's Purse gets for the whole order (Ratwood total_payout).
	var/payout = 0
	var/dawn_issued
	var/dawn_expires

/datum/rogue_standing_order/Destroy()
	region = null
	required = null
	return ..()

/// What the order pays per unit of a good: its trade price with Ratwood's standing order bonus (compute_good_unit_payout()).
/datum/rogue_standing_order/proc/unit_payout(datum/rogue_trade_good/good)
	return CEILING(good.base_price * (1 + rogue_value("trade_order_bonus")), 1)

/datum/rogue_standing_order/proc/ui_entry()
	var/list/lines = list()
	for(var/datum/rogue_trade_good/good as anything in required)
		lines += list(list(
			"name" = good.name,
			"needed" = required[good],
			"stocked" = good.stock?.stockpile_amount || 0,
		))
	return list(
		"id" = id,
		"title" = title,
		"description" = description,
		"region" = region.name,
		"payout" = payout,
		"days_left" = max(0, dawn_expires - GLOB.rockhill_dawns),
		"lines" = lines,
	)

/**
 * A foreign realm whose ships call at the harbor (Ratwood /datum/foreign_realm): ship names, captains and the cargo its ships
 * buy and sell. Data in economy/trade_data.dm; Ratwood's realm conditions, victualling and cultural stock are not ported.
 */
/datum/rogue_foreign_realm
	var/id
	var/name = ""
	var/roll_weight = 10
	var/list/ship_name_words = list()
	/// Ship names are one word, not two (Ratwood single_word_base).
	var/single_word_base = FALSE
	var/list/captain_first_names = list()
	var/list/captain_last_names = list()
	/// list("name" =, "tonnage" =, "weight" =) entries.
	var/list/ship_types = list()
	/// list("text" =, "chance" =) entries; the first that rolls is used.
	var/list/name_prefixes = list()
	var/list/name_suffixes = list()
	var/list/city_tags = list()
	var/city_tag_chance = 0
	/// list("good" =, "qty_min" =, "qty_max" =, "price_mod" =, "always" =) entries: what its ships buy and sell.
	var/list/demand_pool = list()
	var/list/supply_pool = list()
	var/list/hail_lines = list()

/datum/rogue_foreign_realm/proc/pick_ship_type()
	var/list/weighted = list()
	for(var/list/entry as anything in ship_types)
		weighted[entry] = entry["weight"] || 1
	return length(weighted) ? pick_weight(weighted) : null

/// Ratwood generate_ship_name() without the saints' names of Otava.
/datum/rogue_foreign_realm/proc/ship_name()
	var/base = "Vessel"
	if(length(ship_name_words) == 1 || (single_word_base && length(ship_name_words)))
		base = pick(ship_name_words)
	else if(length(ship_name_words))
		var/list/words = ship_name_words.Copy()
		var/first = pick_n_take(words)
		base = "[first] [pick(words)]"
	return "[roll_affix(name_prefixes)][base][roll_affix(name_suffixes)]"

/datum/rogue_foreign_realm/proc/roll_affix(list/affixes)
	for(var/list/entry as anything in affixes)
		if(prob(entry["chance"]))
			return entry["text"]
	return ""

/datum/rogue_foreign_realm/proc/captain_name()
	return "[length(captain_first_names) ? pick(captain_first_names) : "Unnamed"] [length(captain_last_names) ? pick(captain_last_names) : "Captain"]"

/datum/rogue_foreign_realm/proc/port_of_origin()
	return (length(city_tags) && prob(city_tag_chance)) ? pick(city_tags) : ""

/datum/rogue_foreign_realm/proc/pick_hail_line()
	return length(hail_lines) ? pick(hail_lines) : null

/**
 * A foreign trading ship (Ratwood /datum/trade_ship): it waits offshore for the day, or lies at the pier for an hour buying
 * the cargo of its demand lines at the harbor and selling the cargo of its supply lines. Its size scales its cargo.
 */
/datum/rogue_trade_ship
	var/id
	var/datum/rogue_foreign_realm/realm
	var/name
	var/captain
	var/ship_type = "Ship"
	var/port_of_origin = ""
	var/tonnage = ROGUE_SHIP_DEFAULT_TONNAGE
	var/state = ROGUE_SHIP_OFFSHORE
	var/docked_at = 0
	var/dock_expires_at = 0
	/// Came in unbidden: may be sent away at once and never gives a hail back.
	var/auto_hailed = FALSE
	/// Mammons traded with the ship, and how much its captain hopes for (Ratwood favor_earned, expected_favor).
	var/traded = 0
	var/expected_trade = 0
	/// Cargo lines: list(ROGUE_LINE_GOOD = good, ROGUE_LINE_TARGET =, ROGUE_LINE_DONE =, ROGUE_LINE_PRICE =).
	var/list/demands = list()
	var/list/supplies = list()

/datum/rogue_trade_ship/New(datum/rogue_foreign_realm/from_realm, new_id)
	. = ..()
	realm = from_realm
	id = new_id
	var/list/picked = realm.pick_ship_type()
	var/listed = ROGUE_SHIP_DEFAULT_TONNAGE
	if(picked)
		ship_type = picked["name"]
		listed = picked["tonnage"] || ROGUE_SHIP_DEFAULT_TONNAGE
	var/swing = listed * ROGUE_SHIP_TONNAGE_VARIANCE
	tonnage = round(listed + rand(-swing, swing))
	name = realm.ship_name()
	captain = realm.captain_name()
	port_of_origin = realm.port_of_origin()
	expected_trade = round(rogue_value("trade_ship_expected_trade") * scale())
	demands = roll_lines(realm.demand_pool, FALSE)
	supplies = roll_lines(realm.supply_pool, TRUE)

/datum/rogue_trade_ship/Destroy()
	realm = null
	demands = null
	supplies = null
	return ..()

/// Bigger ships carry more, up to twice the default (Ratwood tonnage_scale_mult()).
/datum/rogue_trade_ship/proc/scale()
	return clamp(1 + (tonnage - ROGUE_SHIP_DEFAULT_TONNAGE) / ROGUE_SHIP_TONNAGE_SCALE_SPAN, 1, ROGUE_SHIP_TONNAGE_SCALE_CAP)

/// The captain got the trade he hoped for (Ratwood: favor earned at least the expected favor).
/datum/rogue_trade_ship/proc/honored()
	return expected_trade > 0 && traded >= expected_trade

/// Every line the realm always trades, and a few of the rest (Ratwood roll_bulk_pool()).
/datum/rogue_trade_ship/proc/roll_lines(list/pool, supply)
	. = list()
	var/list/rare = list()
	for(var/list/entry as anything in pool)
		if(!SSrogue_trade.goods[entry["good"]])
			continue
		if(entry["always"])
			var/list/line = build_line(entry, supply)
			if(line)
				. += list(line)
		else
			rare += list(entry)
	if(!length(rare))
		return
	var/count = rand(ROGUE_SHIP_BULK_LINES_MIN, min(ROGUE_SHIP_BULK_LINES_MAX, length(rare)))
	for(var/i in 1 to count)
		if(!length(rare))
			break
		var/list/line = build_line(pick_n_take(rare), supply)
		if(line)
			. += list(line)

/// A cargo line: a count scaled by the ship's size (half for what it sells) and a price around the good's trade price times
/// the realm's markup (Ratwood build_bulk_line()).
/datum/rogue_trade_ship/proc/build_line(list/entry, supply)
	var/datum/rogue_trade_good/good = SSrogue_trade.goods[entry["good"]]
	if(!good)
		return null
	var/qty = round(rand(entry["qty_min"], entry["qty_max"]) * scale() * (supply ? rogue_value("trade_supply_share") : 1))
	var/jitter = 1 - ROGUE_SHIP_PRICE_JITTER + rand() * ROGUE_SHIP_PRICE_JITTER * 2
	var/price = max(1, round(good.base_price * entry["price_mod"] * jitter))
	return list(
		ROGUE_LINE_GOOD = good,
		ROGUE_LINE_TARGET = max(1, qty),
		ROGUE_LINE_DONE = 0,
		ROGUE_LINE_PRICE = price,
	)

/datum/rogue_trade_ship/proc/ui_lines(list/lines)
	. = list()
	for(var/list/line as anything in lines)
		var/datum/rogue_trade_good/good = line[ROGUE_LINE_GOOD]
		. += list(list(
			"good" = good.id,
			"name" = good.name,
			"target" = line[ROGUE_LINE_TARGET],
			"done" = line[ROGUE_LINE_DONE],
			"price" = line[ROGUE_LINE_PRICE],
		))

/datum/rogue_trade_ship/proc/ui_entry()
	return list(
		"id" = id,
		"name" = name,
		"captain" = captain,
		"ship_type" = ship_type,
		"tonnage" = tonnage,
		"realm" = realm.name,
		"port" = port_of_origin,
		"docked" = state == ROGUE_SHIP_DOCKED,
		"minutes_left" = state == ROGUE_SHIP_DOCKED ? max(0, round((dock_expires_at - world.time) / (1 MINUTES))) : 0,
		"traded" = traded,
		"expected" = expected_trade,
		"demands" = ui_lines(demands),
		"supplies" = ui_lines(supplies),
	)
