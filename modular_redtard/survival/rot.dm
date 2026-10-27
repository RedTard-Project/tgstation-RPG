/// Ratwood food rot (code/modules/food_and_drinks/food/snacks.dm process(), become_rotten(), rotprocess_to_text()): from roundstart
/// food stays warm for its warming time and then keeps for its shelf life (rotprocess). Off a table the clock runs at full speed,
/// on a table at half, in a chest, on a platter, in a vendor or on a cooling table it stops. Rotten food turns into its rotten
/// form (become_rot_type) or gets flies and the rotten bite.
/// Ratwood counts every food down every two seconds; here a timer waits for the predicted moment and the speed is re-rated
/// whenever the food moves.
/datum/component/rogue_rot
	dupe_mode = COMPONENT_DUPE_UNIQUE
	/// Deciseconds of full-speed time the food lasts (Ratwood warming + rotprocess).
	var/life = 0
	/// The Ratwood shelf life alone, for the examine text.
	var/shelf_life = 0
	/// Deciseconds of full-speed time already spent.
	var/spent = 0
	/// Current speed of the clock: 1 off a table, 0.5 on one, 0 where food keeps.
	var/rate = 0
	/// world.time the spent time was last banked.
	var/rated_at = 0
	var/rot_timer
	/// The clock runs from roundstart, as in Ratwood (SSticker.OnRoundstart()).
	var/started = FALSE

/datum/component/rogue_rot/Initialize(shelf_life, warming)
	if(!isitem(parent) || shelf_life <= 0)
		return COMPONENT_INCOMPATIBLE
	src.shelf_life = shelf_life
	var/multiplier = CONFIG_GET(number/rogue_food_rot_multiplier)
	life = (max(warming, 0) + shelf_life) * multiplier
	rated_at = world.time

/datum/component/rogue_rot/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	if(SSticker.HasRoundStarted())
		start()
	else
		RegisterSignal(SSticker, COMSIG_TICKER_ROUND_STARTING, PROC_REF(on_round_start))

/datum/component/rogue_rot/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_MOVABLE_MOVED, COMSIG_ATOM_EXAMINE))
	UnregisterSignal(SSticker, COMSIG_TICKER_ROUND_STARTING)

/datum/component/rogue_rot/Destroy(force)
	deltimer(rot_timer)
	return ..()

/datum/component/rogue_rot/proc/on_round_start(datum/source)
	SIGNAL_HANDLER
	UnregisterSignal(SSticker, COMSIG_TICKER_ROUND_STARTING)
	start()

/datum/component/rogue_rot/proc/start()
	started = TRUE
	rated_at = world.time
	rerate()

/datum/component/rogue_rot/proc/on_moved(datum/source, atom/old_loc, dir, forced, list/old_locs)
	SIGNAL_HANDLER
	rerate()

/// Ratwood's rot speed for where the food is.
/datum/component/rogue_rot/proc/current_rate()
	var/obj/item/food = parent
	var/atom/holder = food.loc
	if(!holder || !started)
		return 0
	if(is_type_in_typecache(holder, GLOB.rogue_food_keepers))
		return 0
	if(!isturf(holder))
		return 1
	var/obj/structure/table/table = locate() in holder
	if(!table)
		return 1
	return is_type_in_typecache(table, GLOB.rogue_food_keepers) ? 0 : 0.5

/// Banks the time spent at the old speed, takes the new one and waits for the rot.
/datum/component/rogue_rot/proc/rerate()
	spent += (world.time - rated_at) * rate
	rated_at = world.time
	rate = current_rate()
	deltimer(rot_timer)
	rot_timer = null
	if(rate > 0)
		rot_timer = addtimer(CALLBACK(src, PROC_REF(check_rot)), max((life - spent) / rate, 1), TIMER_STOPPABLE | TIMER_DELETE_ME)

/datum/component/rogue_rot/proc/check_rot()
	rot_timer = null
	rerate()
	if(spent < life)
		return
	var/obj/item/reagent_containers/food/food = parent
	if(!istype(food))
		qdel(src)
		return
	if(!food.become_rotten())
		rot_timer = addtimer(CALLBACK(src, PROC_REF(check_rot)), 10 SECONDS, TIMER_STOPPABLE | TIMER_DELETE_ME)
		return
	if(!QDELETED(src))
		qdel(src)

/// Ratwood rotprocess_to_text(): how long the food keeps and how fresh it is.
/datum/component/rogue_rot/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	var/text
	switch(shelf_life)
		if(0 to 10 MINUTES)
			text = "This food will rot in less than a third of a dae."
		if(10 MINUTES to 15 MINUTES)
			text = "This food will rot in half a dae."
		if(15 MINUTES to 30 MINUTES)
			text = "This food will last about a dae."
		if(30 MINUTES to 45 MINUTES)
			text = "This food will last a dae and a half."
		else
			text = "This food will last three daes."
	var/used = (spent + (world.time - rated_at) * rate) / max(life, 1)
	switch(used)
		if(-INFINITY to 0.25)
			text += " It is very fresh."
		if(0.25 to 0.5)
			text += " It is fairly fresh."
		if(0.5 to 0.75)
			text += " It is starting to go stale."
		else
			text += " It is about to rot."
	examine_list += span_smallnotice(text)

/// Where Ratwood food does not rot (snacks.dm process()), or a table that keeps it (cooling table). The chest, the vendor and
/// the cooling table are ported map types, looked up by name so the module builds without them.
GLOBAL_LIST_INIT(rogue_food_keepers, init_rogue_food_keepers())

/proc/init_rogue_food_keepers()
	var/list/keepers = list(/obj/item/cooking/platter)
	for(var/name in list("/obj/structure/closet/crate/wooden/rockhill/crate/chest", "/obj/structure/roguemachine/vendor", "/obj/structure/table/wood/rockhill/cooling"))
		var/path = text2path(name)
		if(path)
			keepers += path
	return typecacheof(keepers)
