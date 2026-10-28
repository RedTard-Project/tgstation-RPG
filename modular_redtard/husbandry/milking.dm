/// Milking (Ratwood friendly/farm_animals.dm /obj/item/udder, rogue/rogueanimals.dm Initialize(), Life() and attackby()) on TG's
/// udder component: a grown cow or nanny goat has an udder that fills by a unit of milk out of every point of what she has eaten
/// (the production of husbandry/livestock.dm) while she has food in her, and is milked into an open vessel held to her. With
/// the hit or splash intent the vessel does what it always does.
/mob/living/basic/rockhill
	/// Ratwood milkies: what a grown female of this kind is milked of; null - nothing.
	var/rogue_milk_type

/// TG's udder with Ratwood's milking: by a click with an open vessel (not TG's attackby, which the module's combat takes for a
/// blow), a moment long, from what she eats rather than over time.
/datum/component/udder/rogue
	/// Someone is milking her right now (Ratwood in_use).
	var/milking = FALSE

/datum/component/udder/rogue/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ATOM_ITEM_INTERACTION, PROC_REF(on_item_interaction))
	RegisterSignal(parent, COMSIG_LIVING_LIFE, PROC_REF(on_life))

/datum/component/udder/rogue/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ATOM_ITEM_INTERACTION, COMSIG_LIVING_LIFE))
	return ..()

/// Ratwood rogueanimals Life(): while she has eaten, the udder fills at the pace the food meter empties.
/datum/component/udder/rogue/proc/on_life(mob/living/basic/rockhill/source, seconds_per_tick)
	SIGNAL_HANDLER
	if(source.stat == DEAD || !udder || udder.reagents.holder_full())
		return
	var/datum/component/rogue_livestock/stock = source.GetComponent(/datum/component/rogue_livestock)
	if(!stock || stock.production <= 0)
		return
	var/used = min(stock.production, ROGUE_BEAST_FOOD_PER_SECOND * seconds_per_tick)
	stock.production -= used
	udder.reagents.add_reagent(udder.reagent_produced_typepath, used * ROGUE_MILK_PER_PRODUCTION, added_purity = 1)

/datum/component/udder/rogue/proc/on_item_interaction(mob/living/basic/rockhill/source, mob/living/user, obj/item/tool, list/modifiers)
	SIGNAL_HANDLER
	if(!istype(tool, /obj/item/reagent_containers/cup) || !tool.is_refillable() || IS_UNCONSCIOUS_OR_CRIT(source))
		return NONE
	var/datum/intent/intent = user.rogue_active_intent()
	if(istype(intent, /datum/intent/hit) || istype(intent, /datum/intent/splash))
		return NONE
	INVOKE_ASYNC(src, PROC_REF(milk_into), tool, user)
	return ITEM_INTERACT_SUCCESS

/// Ratwood milkAnimal(): an udder with a few units in it is milked into the vessel over a moment (TG's milk() pours rand(5, 10)).
/datum/component/udder/rogue/proc/milk_into(obj/item/reagent_containers/cup/vessel, mob/living/user)
	if(milking || !udder)
		return
	if(vessel.reagents.holder_full())
		to_chat(user, span_warning("[vessel] is full."))
		return
	if(!udder.reagents.has_reagent(udder.reagent_produced_typepath, ROGUE_MILK_MIN))
		to_chat(user, span_warning("The udder is dry. Wait a bit longer..."))
		return
	milking = TRUE
	playsound(vessel, pick('modular_redtard/husbandry/sound/milking1.ogg', 'modular_redtard/husbandry/sound/milking2.ogg'), 100, TRUE, -1)
	var/milked = do_after(user, ROGUE_MILK_TIME, target = parent)
	if(QDELETED(src))
		return
	milking = FALSE
	if(milked && udder && !QDELETED(vessel) && user.is_holding(vessel))
		udder.milk(vessel, user)

/// Ratwood's udder: a hundred units, born with up to twenty, filled by the cow's Life (above) rather than TG's processing.
/obj/item/udder/rogue

/obj/item/udder/rogue/add_features(parent, callback, reagent_override)
	size = ROGUE_MILK_UDDER_SIZE
	return ..()

/obj/item/udder/rogue/initial_conditions()
	var/start = rand(0, ROGUE_MILK_START_MAX)
	if(start)
		reagents.add_reagent(reagent_produced_typepath, start, added_purity = 1)
