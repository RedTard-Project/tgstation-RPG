/// The everyday miracles of the basket (miracle.dm): water, food, beasts, sight in the dark and the shroud of the night.

#define ROGUE_BLESSED_FOOD_FILTER "rogue_blessed_food"

/// Azure Peak's orison of filling (spells/orison.dm create_water()): with a hand held over a container at arm's length, water
/// streams from the caster's fingertips, more at a time the more skilled, until it is full or the prayer stops.
/datum/action/cooldown/spell/pointed/rogue_miracle/orison_water
	name = "Orison of Water"
	desc = "Beseech the gods for water: it streams from my fingertips into a container at arm's length while I hold still."
	button_icon_state = "thaumaturgy"
	cooldown_time = 10 SECONDS
	cast_range = 1
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_0
	devotion_cost = 5
	miracle_forks = "Azure Peak, Twilight Axis, Ratwood"
	miracle_gods = "every god's orison T0"
	/// Time of a trickle (Azure 1.5 seconds).
	var/trickle_time = 1.5 SECONDS
	/// Water a trickle pours per rank in miracles (Azure holy_skill * 5), and at least.
	var/water_per_rank = 5

/datum/action/cooldown/spell/pointed/rogue_miracle/orison_water/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	if(!cast_on.is_refillable() || !cast_on.reagents)
		to_chat(owner, span_warning("I'll need to find a container that can hold water."))
		return FALSE
	if(cast_on.reagents.holder_full())
		to_chat(owner, span_warning("[cast_on] is full."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/orison_water/cast(atom/cast_on)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(pour), owner, cast_on)

/datum/action/cooldown/spell/pointed/rogue_miracle/orison_water/proc/pour(mob/living/carbon/human/caster, atom/vessel)
	caster.visible_message(span_info("[caster] closes [caster.p_their()] eyes in prayer and extends a hand over [vessel] as water begins to stream from [caster.p_their()] fingertips..."), span_notice("I utter forth a plea for succour, and hold my hand out above [vessel]..."))
	var/amount = max(caster.rogue_skill_rank(/datum/attribute/skill/magic/holy), 1) * water_per_rank
	while(!QDELETED(vessel) && vessel.reagents && !vessel.reagents.holder_full() && do_after(caster, trickle_time, target = vessel))
		vessel.reagents.add_reagent(/datum/reagent/water, amount)
		if(prob(80))
			playsound(caster, 'sound/effects/slosh.ogg', 30, TRUE)

/// Ratwood blessed_food (acolyte/eora.dm): a blessed dish heals whoever eats of it - but its blesser - the better, the finer
/// the dish and the more skilled the blessing; the blessing raises a dish to the blesser's fare.
/datum/component/rogue_blessed_food
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/datum/weakref/blesser
	/// Healing every second of the aura a bite brings (Ratwood quality + skill / 5).
	var/healing = 1

/datum/component/rogue_blessed_food/Initialize(mob/living/caster, holy_rank)
	if(!istype(parent, /obj/item/reagent_containers/food))
		return COMPONENT_INCOMPATIBLE
	var/obj/item/reagent_containers/food/dish = parent
	blesser = WEAKREF(caster)
	healing = ((dish.rogue_faretype || 3) + holy_rank / 5) / 2
	dish.rogue_faretype = max(dish.rogue_faretype, clamp(holy_rank, 1, 5))
	dish.add_filter(ROGUE_BLESSED_FOOD_FILTER, 1, list("type" = "outline", "color" = holy_rank >= 5 ? "#f0b000" : "#ff00ff", "size" = 1))

/datum/component/rogue_blessed_food/RegisterWithParent()
	RegisterSignal(parent, COMSIG_FOOD_EATEN, PROC_REF(on_eaten))

/datum/component/rogue_blessed_food/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_FOOD_EATEN)

/datum/component/rogue_blessed_food/proc/on_eaten(datum/source, mob/living/eater, mob/living/feeder, bitecount, bitesize)
	SIGNAL_HANDLER
	if(eater == blesser?.resolve())
		eater.visible_message(span_notice("The divine energy fizzles harmlessly around [eater]."))
		return
	eater.apply_status_effect(/datum/status_effect/rogue_miracle_heal, healing)

/// Ratwood bless_food "Bless Food" (acolyte/eora.dm, in Azure Peak and Twilight Axis too): a dish that heals whoever eats it.
/datum/action/cooldown/spell/pointed/rogue_miracle/bless_food
	name = "Bless Food"
	desc = "Bless a dish: those who eat of it are healed, the more the finer the dish and the more skilled my blessing."
	button_icon = ROGUE_MIRACLES_EORA_ICON
	button_icon_state = "bread"
	sound = 'modular_redtard/faith/sound/magnet.ogg'
	cooldown_time = 90 SECONDS
	cast_range = 1
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_1
	devotion_cost = 25
	needs_holy_symbol = TRUE
	miracle_forks = "Ratwood, Azure Peak, Twilight Axis"
	miracle_gods = "Eora T1"
	/// Ratwood: the cooldown is six seconds shorter per rank in miracles.
	var/cooldown_per_rank = 6 SECONDS

/datum/action/cooldown/spell/pointed/rogue_miracle/bless_food/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	if(!istype(cast_on, /obj/item/reagent_containers/food))
		to_chat(owner, span_warning("I can only bless food!"))
		return FALSE
	if(cast_on.GetComponent(/datum/component/rogue_blessed_food))
		to_chat(owner, span_warning("[cast_on] is blessed already."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/bless_food/cast(obj/item/reagent_containers/food/cast_on)
	. = ..()
	var/mob/living/caster = owner
	var/rank = caster.rogue_skill_rank(/datum/attribute/skill/magic/holy)
	cast_on.AddComponent(/datum/component/rogue_blessed_food, caster, rank)
	cooldown_time = max(initial(cooldown_time) - cooldown_per_rank * rank, 0)
	to_chat(caster, span_notice("I bless [cast_on], and it glows with holy love!"))

/// Ratwood beasttame "Tame Beast" (acolyte/dendor.dm): Dendor's whisper soothes a beast of a kind that can be tamed; it
/// calms down and takes the caster for a friend, as if fed by hand (husbandry/taming.dm).
/datum/action/cooldown/spell/pointed/rogue_miracle/tame_beast
	name = "Tame Beast"
	desc = "Pacify a beast of a kind that can be tamed with Dendor's blessing: it calms down and takes me for a friend."
	button_icon = ROGUE_MIRACLES_DENDOR_ICON
	button_icon_state = "tamebeast"
	sound = 'modular_redtard/faith/sound/churn.ogg'
	invocation = "Be still and calm, brotherbeast."
	invocation_type = INVOCATION_WHISPER
	cooldown_time = 10 SECONDS
	cast_range = 5
	self_castable = FALSE
	miracle_tier = ROGUE_MIRACLE_TIER_2
	devotion_cost = 20
	needs_holy_symbol = TRUE
	miracle_forks = "Ratwood"
	miracle_gods = "Dendor T2"

/datum/action/cooldown/spell/pointed/rogue_miracle/tame_beast/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	var/mob/living/basic/rockhill/beast = cast_on
	if(!istype(beast) || (beast.mob_biotypes & MOB_UNDEAD) || !beast.GetComponent(/datum/component/tameable))
		to_chat(owner, span_warning("This creature is not of a tameable kind."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/tame_beast/cast(mob/living/basic/rockhill/cast_on)
	. = ..()
	var/datum/component/tameable/tameable = cast_on.GetComponent(/datum/component/tameable)
	if(!tameable)
		return fail("[cast_on] cannot be tamed any more.")
	if(cast_on.rogue_is_angry())
		cast_on.rogue_calm_down()
	tameable.on_tame(cast_on, owner, null, TRUE)
	owner.visible_message(span_green("[owner] soothes the beastblood with Dendor's whisper."), span_green("With Dendor's blessing, I soothe [cast_on]'s anger."))

/// Azure Peak noc/nitevision "Nitevision" (in Twilight Axis too): the caster and everyone beside them see in the dark for a
/// quarter of an hour.
/datum/status_effect/rogue_nitevision
	id = "rogue_nitevision"
	duration = 15 MINUTES
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null

/datum/status_effect/rogue_nitevision/on_apply()
	ADD_TRAIT(owner, TRAIT_NIGHT_VISION, ROGUE_FAITH_TRAIT)
	to_chat(owner, span_notice("The darkness thins before my eyes."))
	return TRUE

/datum/status_effect/rogue_nitevision/on_remove()
	REMOVE_TRAIT(owner, TRAIT_NIGHT_VISION, ROGUE_FAITH_TRAIT)
	to_chat(owner, span_notice("The night grows dark again."))

/datum/action/cooldown/spell/pointed/rogue_miracle/nitevision
	name = "Nitevision"
	desc = "I and everyone beside me see in the dark for a quarter of an hour."
	button_icon = ROGUE_MIRACLES_NOC_ICON
	button_icon_state = "noc_sight"
	click_to_activate = FALSE
	cooldown_time = 90 SECONDS
	miracle_tier = ROGUE_MIRACLE_TIER_0
	devotion_cost = 20
	miracle_forks = "Azure Peak, Twilight Axis"
	miracle_gods = "Noc T0"

/datum/action/cooldown/spell/pointed/rogue_miracle/nitevision/cast(atom/cast_on)
	. = ..()
	owner.visible_message(span_notice("[owner] mutters an incantation and a dim pulse of light radiates out from [owner.p_them()]."))
	for(var/mob/living/beside in range(1, owner))
		beside.apply_status_effect(/datum/status_effect/rogue_nitevision)

/// Ratwood invisibility/miracle (Azure Peak and Twilight Axis noc/invisibility "Moon Shroud"): the target fades out of sight for
/// five seconds per rank of the caster in miracles; casting, attacking or being hurt brings them back.
/datum/status_effect/rogue_moon_shroud
	id = "rogue_moon_shroud"
	duration = 5 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null

/datum/status_effect/rogue_moon_shroud/on_creation(mob/living/new_owner, shroud_time)
	if(shroud_time)
		duration = shroud_time
	return ..()

/datum/status_effect/rogue_moon_shroud/refresh(effect, shroud_time)
	duration = max(duration, shroud_time || initial(duration))

/datum/status_effect/rogue_moon_shroud/on_apply()
	owner.visible_message(span_warning("[owner] starts to fade into thin air!"), span_notice("I start to become invisible!"))
	animate(owner, alpha = 0, time = 1 SECONDS, easing = EASE_IN)
	RegisterSignals(owner, list(COMSIG_MOB_CAST_SPELL, COMSIG_MOB_ITEM_ATTACK, COMSIG_LIVING_UNARMED_ATTACK, COMSIG_MOB_APPLY_DAMAGE, COMSIG_MOB_FIRED_GUN), PROC_REF(break_shroud))
	return TRUE

/datum/status_effect/rogue_moon_shroud/on_remove()
	UnregisterSignal(owner, list(COMSIG_MOB_CAST_SPELL, COMSIG_MOB_ITEM_ATTACK, COMSIG_LIVING_UNARMED_ATTACK, COMSIG_MOB_APPLY_DAMAGE, COMSIG_MOB_FIRED_GUN))
	animate(owner, alpha = 255, time = 1 SECONDS, easing = EASE_OUT)
	owner.visible_message(span_warning("[owner] fades back into view."), span_notice("I become visible again."))

/datum/status_effect/rogue_moon_shroud/proc/break_shroud(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/action/cooldown/spell/pointed/rogue_miracle/moon_shroud
	name = "Moon Shroud"
	desc = "Make another, or myself, invisible for a while: longer the more skilled I am. Casting, attacking or being hurt ends it."
	button_icon = ROGUE_MIRACLES_NOC_ICON
	button_icon_state = "invisibility"
	cooldown_time = 30 SECONDS
	cast_range = 3
	miracle_tier = ROGUE_MIRACLE_TIER_1
	devotion_cost = 25
	needs_holy_symbol = TRUE
	miracle_forks = "Ratwood, Azure Peak, Twilight Axis"
	miracle_gods = "Noc T1 (Azure Peak and Twilight Axis T2)"
	/// Invisibility per rank of the caster in miracles (Ratwood 5 seconds), and at least.
	var/shroud_per_rank = 5 SECONDS

/datum/action/cooldown/spell/pointed/rogue_miracle/moon_shroud/is_valid_target(atom/cast_on)
	. = ..()
	if(. && !isliving(cast_on))
		to_chat(owner, span_warning("Only the living can be shrouded."))
		return FALSE

/datum/action/cooldown/spell/pointed/rogue_miracle/moon_shroud/cast(mob/living/cast_on)
	. = ..()
	if(cast_on.can_block_magic(MAGIC_RESISTANCE_HOLY))
		return
	var/mob/living/caster = owner
	cast_on.apply_status_effect(/datum/status_effect/rogue_moon_shroud, max(caster.rogue_skill_rank(/datum/attribute/skill/magic/holy), 1) * shroud_per_rank)

#undef ROGUE_BLESSED_FOOD_FILTER
