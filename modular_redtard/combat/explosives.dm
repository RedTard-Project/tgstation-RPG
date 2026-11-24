/// Bombs and grenades by Azure Peak (code/game/objects/items/rogueitems/bombs.dm, effects_smoke.dm gas belchers). Both trees
/// of bombs the module carries go off the same way: Azure Peak's /obj/item/explosive (items_azure/other.dm) and Ratwood's
/// /obj/item/bomb, tntstick, satchel_bomb and impact_grenade (rockhill/ported/items.dm), which the recipes, shops and kits
/// make. A bomb's root declares its kind (rogue_explosive_kind) and the rogue_explosive component does the rest:
/// - a fused bomb (bottle bomb, blastpowder stick and satchel) is lit by a flame held to it, by holding it to a fire, by a
///   spark or by fire around it, and goes off when its fuse burns down; put out, it can be lit again;
/// - a fragile bomb (bottle bomb, impact grenades, gas belchers, smoke bomb) goes off where it lands when thrown, lit or not;
///   a bottle may fail to (explosive_<kind>_fail); an impact grenade also goes off squeezed in hand, though an Explosive
///   Specialist refuses to do that with a shrapnel one;
/// - an explosion sets off the bombs it reaches and every bomb lying within explosive_chain_range of a blast; a bomb an
///   Explosive Specialist carries off his hands does not go off;
/// - a bottle bomb burns those within explosive_bottle_burn_range and sets the ground alight (wider when it was lit or set
///   off); blastpowder strikes everyone in its blast range by distance, wrecks structures (satchels) and blows up the
///   ground; a shrapnel grenade strikes its tile and flings shards that stick in the flesh where the armor is worn through;
///   a gas belcher lets out its gas (smoke, poison, healing, fire, blinding, silencing) and leaves its empty shell;
/// - a struck body is staggered and stays safe from another blast for explosive_hit_immunity; a thrower who is an Explosive
///   Specialist may blast a downed or burning mindless foe to bits (a critical hit), is not hurt by his own bomb and its shards;
/// - fibres tied to a bomb make a trip bomb with a tripwire in front of the setter: who steps on the wire is slowed and
///   the bomb goes off (luck may spare the foot; Specialists set it faster, hide it and are spared by it). A short cutting
///   blade disarms it (the crafting skill keeps it from going off), a clod of dirt hides it.
/// Azure Peak's traps skill is Ratwood's crafting here (the module has no traps skill). Azure Peak's spilt flames are TG's
/// fire of the explosion (flame_range), its scorch stacks are burning (on fire).
#define ROGUE_EXPLOSIVE_SOUND_LIT 'modular_redtard/rockhill/sound/items/firelight.ogg'
#define ROGUE_EXPLOSIVE_SOUND_SNUFF 'modular_redtard/rockhill/sound/items/firesnuff.ogg'
#define ROGUE_EXPLOSIVE_SOUND_BLAST pick('modular_redtard/combat/sound/explosives/bottlebomb1.ogg', 'modular_redtard/combat/sound/explosives/bottlebomb2.ogg')
#define ROGUE_EXPLOSIVE_SOUND_CRIT 'modular_redtard/rockhill/sound/combat/tf2crit.ogg'
#define ROGUE_EXPLOSIVE_SOUND_GAS 'modular_redtard/combat/sound/explosives/incendiary1.ogg'
#define ROGUE_EXPLOSIVE_SOUND_SMOKEBOMB 'modular_redtard/combat/sound/explosives/smokebomb.ogg'
#define ROGUE_EXPLOSIVE_SOUND_TRIP 'modular_redtard/combat/sound/explosives/knife_open.ogg'
#define ROGUE_EXPLOSIVE_SOUND_SHARD 'modular_redtard/rockhill/sound/combat/hits/hi_arrow2.ogg'
#define ROGUE_EXPLOSIVE_TRIP_OVERLAY_ICON 'modular_redtard/rockhill/icons/roguetown/items/misc.dmi'
#define ROGUE_EXPLOSIVE_BLAST_FIRE "fire"
#define ROGUE_EXPLOSIVE_BLAST_POWDER "powder"
#define ROGUE_EXPLOSIVE_BLAST_SHRAPNEL "shrapnel"
#define ROGUE_EXPLOSIVE_BLAST_GAS "gas"
#define ROGUE_EXPLOSIVE_BLAST_TRIP "trip"

GLOBAL_LIST_INIT(rogue_shrapnel_zones, list(BODY_ZONE_CHEST, BODY_ZONE_L_LEG, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_R_ARM))

/mob/living
	/// world.time of the last blast that struck this body (Azure Peak MT_BOMB_HIT).
	var/rogue_bomb_hit_at = 0

// The roots of the bombs: their kind, the component, and sparks.

/obj/item/explosive
	/// Kind of bomb (rogue_explosive component); none for the abstract parents.
	var/rogue_explosive_kind

/obj/item/bomb
	var/rogue_explosive_kind = "bottle"

/obj/item/tntstick
	var/rogue_explosive_kind = "stick"

/obj/item/satchel_bomb
	var/rogue_explosive_kind = "satchel"

/obj/item/impact_grenade
	var/rogue_explosive_kind

/obj/item/explosive/Initialize(mapload)
	. = ..()
	if(rogue_explosive_kind)
		AddComponent(/datum/component/rogue_explosive, rogue_explosive_kind)

/obj/item/bomb/Initialize(mapload)
	. = ..()
	if(rogue_explosive_kind)
		AddComponent(/datum/component/rogue_explosive, rogue_explosive_kind)

/obj/item/tntstick/Initialize(mapload)
	. = ..()
	if(rogue_explosive_kind)
		AddComponent(/datum/component/rogue_explosive, rogue_explosive_kind)

/obj/item/satchel_bomb/Initialize(mapload)
	. = ..()
	if(rogue_explosive_kind)
		AddComponent(/datum/component/rogue_explosive, rogue_explosive_kind)

/obj/item/impact_grenade/Initialize(mapload)
	. = ..()
	if(rogue_explosive_kind)
		AddComponent(/datum/component/rogue_explosive, rogue_explosive_kind)

/obj/item/explosive/spark_act()
	rogue_explosive_spark(src)

/obj/item/bomb/spark_act()
	rogue_explosive_spark(src)

/obj/item/tntstick/spark_act()
	rogue_explosive_spark(src)

/obj/item/satchel_bomb/spark_act()
	rogue_explosive_spark(src)

/// A spark lights a fused bomb (Azure Peak fused spark_act() -> fire_act()).
/proc/rogue_explosive_spark(obj/item/bomb)
	var/datum/component/rogue_explosive/explosive = bomb.GetComponent(/datum/component/rogue_explosive)
	explosive?.catch_fire()

// Kinds (Azure Peak's types; Ratwood's types of the same bombs take the same kind).

/obj/item/explosive/fused/bottle
	rogue_explosive_kind = "bottle"

/obj/item/explosive/fused/powder/stick
	rogue_explosive_kind = "stick"

/obj/item/explosive/fused/powder/satchel
	rogue_explosive_kind = "satchel"

/obj/item/explosive/fused/powder/satchel/mega
	rogue_explosive_kind = "mega"

/obj/item/explosive/fused/tripbomb
	rogue_explosive_kind = "trip"
	anchored = TRUE

/obj/item/explosive/impact/shrapnel
	rogue_explosive_kind = "shrapnel"

/obj/item/explosive/impact/smoke
	rogue_explosive_kind = "smoke"

/obj/item/explosive/impact/smoke/poison_gas
	rogue_explosive_kind = "poison_gas"

/obj/item/explosive/impact/smoke/healing_gas
	rogue_explosive_kind = "healing_gas"

/obj/item/explosive/impact/smoke/fire_gas
	rogue_explosive_kind = "fire_gas"

/obj/item/explosive/impact/smoke/blind_gas
	rogue_explosive_kind = "blind_gas"

/obj/item/explosive/impact/smoke/mute_gas
	rogue_explosive_kind = "mute_gas"

/obj/item/explosive/impact/smoke/bomb
	rogue_explosive_kind = "smokebomb"

/obj/item/bomb/smoke
	rogue_explosive_kind = "smokebomb"

/obj/item/bomb/tripbomb
	rogue_explosive_kind = "trip"
	anchored = TRUE

/obj/item/impact_grenade/explosion
	rogue_explosive_kind = "shrapnel"

/obj/item/impact_grenade/smoke
	rogue_explosive_kind = "smoke"

/obj/item/impact_grenade/smoke/poison_gas
	rogue_explosive_kind = "poison_gas"

/obj/item/impact_grenade/smoke/healing_gas
	rogue_explosive_kind = "healing_gas"

/obj/item/impact_grenade/smoke/fire_gas
	rogue_explosive_kind = "fire_gas"

/obj/item/impact_grenade/smoke/blind_gas
	rogue_explosive_kind = "blind_gas"

/obj/item/impact_grenade/smoke/mute_gas
	rogue_explosive_kind = "mute_gas"

/// Azure Peak's explosive on any of the bomb types.
/datum/component/rogue_explosive
	dupe_mode = COMPONENT_DUPE_UNIQUE
	/// Kind of bomb, the <kind> of its numbers (explosive_<kind>_...).
	var/kind
	/// How it goes off (ROGUE_EXPLOSIVE_BLAST_*).
	var/blast
	/// It has a fuse to light (Azure Peak /obj/item/explosive/fused).
	var/fused = FALSE
	/// It goes off where it lands when thrown (Azure Peak fragile).
	var/fragile = FALSE
	/// An Explosive Specialist will not set it off in hand (Azure Peak cautious).
	var/cautious = FALSE
	/// It goes off with fire or a blast even inside a bag (Azure Peak explodes_in_sacks).
	var/explodes_in_sacks = FALSE
	/// What a gas belcher lets out, and what it leaves.
	var/gas_effect
	var/residue
	var/gas_sound
	/// What fibres tied to it make, and, for a trip bomb, what it sets off.
	var/trip_type
	var/payload
	var/lit = FALSE
	var/exploding = FALSE
	var/fuse_timer
	/// Chance to blast to bits added by a trap (Azure Peak tripcrit).
	var/tripcrit = 0
	var/datum/weakref/thrower_ref
	/// Who set the trip bomb up, and its wires.
	var/datum/weakref/setter_ref
	var/list/obj/item/tripwire/trips

/datum/component/rogue_explosive/Initialize(kind)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	src.kind = kind
	var/azure = istype(parent, /obj/item/explosive)
	trip_type = azure ? /obj/item/explosive/fused/tripbomb : /obj/item/bomb/tripbomb
	switch(kind)
		if("bottle")
			blast = ROGUE_EXPLOSIVE_BLAST_FIRE
			fused = TRUE
			fragile = TRUE
			explodes_in_sacks = TRUE
		if("stick", "satchel", "mega")
			blast = ROGUE_EXPLOSIVE_BLAST_POWDER
			fused = TRUE
			explodes_in_sacks = TRUE
		if("shrapnel")
			blast = ROGUE_EXPLOSIVE_BLAST_SHRAPNEL
			fragile = TRUE
			cautious = TRUE
		if("smoke", "poison_gas", "healing_gas", "fire_gas", "blind_gas", "mute_gas", "smokebomb")
			blast = ROGUE_EXPLOSIVE_BLAST_GAS
			fragile = TRUE
			gas_effect = GLOB.rogue_gas_effects[kind]
			residue = kind == "smokebomb" ? (azure ? /obj/item/natural/ash : /obj/item/ash) : /obj/item/smokeshell
			gas_sound = kind == "smokebomb" ? ROGUE_EXPLOSIVE_SOUND_SMOKEBOMB : ROGUE_EXPLOSIVE_SOUND_GAS
		if("trip")
			blast = ROGUE_EXPLOSIVE_BLAST_TRIP
			fused = TRUE
			payload = azure ? /obj/item/explosive/fused/bottle : /obj/item/bomb
			trip_type = null
		else
			return COMPONENT_INCOMPATIBLE

/datum/component/rogue_explosive/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_ITEM_INTERACTION, PROC_REF(on_item_interaction))
	RegisterSignal(parent, COMSIG_ITEM_INTERACTING_WITH_ATOM, PROC_REF(on_interacting_with))
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF, PROC_REF(on_attack_self))
	RegisterSignal(parent, COMSIG_MOVABLE_IMPACT, PROC_REF(on_impact))
	RegisterSignal(parent, COMSIG_ATOM_FIRE_ACT, PROC_REF(on_fire_act))
	RegisterSignal(parent, COMSIG_ATOM_PRE_EX_ACT, PROC_REF(on_pre_ex_act))
	RegisterSignal(parent, COMSIG_ATOM_EXTINGUISH, PROC_REF(on_extinguish))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/component/rogue_explosive/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ATOM_ITEM_INTERACTION, COMSIG_ITEM_INTERACTING_WITH_ATOM, COMSIG_ITEM_ATTACK_SELF, COMSIG_MOVABLE_IMPACT, COMSIG_ATOM_FIRE_ACT, COMSIG_ATOM_PRE_EX_ACT, COMSIG_ATOM_EXTINGUISH, COMSIG_ATOM_EXAMINE))

/datum/component/rogue_explosive/Destroy(force)
	if(fuse_timer)
		deltimer(fuse_timer)
		fuse_timer = null
	for(var/obj/item/tripwire/wire as anything in trips)
		wire.rogue_trap = null
		qdel(wire)
	trips = null
	return ..()

/datum/component/rogue_explosive/proc/thrower_mob()
	return thrower_ref?.resolve()

/// An Explosive Specialist's bomb off his hands does not go off (Azure Peak stowed()).
/datum/component/rogue_explosive/proc/stowed()
	var/obj/item/bomb = parent
	for(var/atom/holder = bomb.loc; holder; holder = holder.loc)
		if(ismob(holder) && HAS_TRAIT(holder, TRAIT_BOMBER_EXPERT))
			var/mob/carrier = holder
			return !(bomb in carrier.held_items)
	return FALSE

/// Inside a bag only a fused bomb catches (Azure Peak explodes_in_sacks).
/datum/component/rogue_explosive/proc/shielded()
	var/obj/item/bomb = parent
	if(isobj(bomb.loc) && !explodes_in_sacks)
		return TRUE
	return stowed()

/datum/component/rogue_explosive/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(fused && blast != ROGUE_EXPLOSIVE_BLAST_TRIP)
		examine_list += span_info("Its fuse can be lit with a torch, a flint or another flame, or by holding it to a fire. Once lit, it goes off shortly.")
	if(fragile && blast != ROGUE_EXPLOSIVE_BLAST_FIRE)
		examine_list += span_info("It goes off where it lands when thrown, or when squeezed in hand.")
	else if(fragile)
		examine_list += span_info("It shatters and goes off where it lands when thrown.")
	if(trip_type)
		examine_list += span_info("Tying fibres to it makes a trip bomb.")
	if(lit)
		examine_list += span_danger("Its fuse is burning!")

/// A flame held to the bomb lights its fuse; fibres make a trip bomb; a short blade disarms a trip bomb, dirt hides it.
/datum/component/rogue_explosive/proc/on_item_interaction(datum/source, mob/living/user, obj/item/tool, list/modifiers)
	SIGNAL_HANDLER
	var/obj/item/bomb = parent
	if(blast == ROGUE_EXPLOSIVE_BLAST_TRIP)
		if(tool.rogue_current_bclass == BCLASS_CUT && tool.wlength == WLENGTH_SHORT)
			INVOKE_ASYNC(src, PROC_REF(disarm), user, bomb)
			return ITEM_INTERACT_SUCCESS
		if(istype(tool, /obj/item/natural/dirtclod))
			rogue_explosive_hide(bomb, user, tool)
			return ITEM_INTERACT_SUCCESS
		return NONE
	if(fused && !lit && tool.get_temperature())
		light(user)
		return ITEM_INTERACT_SUCCESS
	if(trip_type && !bomb.anchored && istype(tool, /obj/item/natural/fibers))
		INVOKE_ASYNC(src, PROC_REF(set_trap), user, tool)
		return ITEM_INTERACT_SUCCESS
	return NONE

/// Held to a fire or a burning thing, the fuse catches.
/datum/component/rogue_explosive/proc/on_interacting_with(datum/source, mob/living/user, atom/target, list/modifiers)
	SIGNAL_HANDLER
	if(!fused || lit || blast == ROGUE_EXPLOSIVE_BLAST_TRIP)
		return NONE
	var/burning = FALSE
	if(istype(target, /obj/machinery/light/rogue))
		var/obj/machinery/light/rogue/fire = target
		burning = fire.lit
	else if(isitem(target))
		var/obj/item/flame = target
		burning = flame.get_temperature()
	if(!burning)
		return NONE
	light(user)
	return ITEM_INTERACT_SUCCESS

/// An impact grenade goes off squeezed in hand (Azure Peak impact attack_self()).
/datum/component/rogue_explosive/proc/on_attack_self(datum/source, mob/user)
	SIGNAL_HANDLER
	if(fused || !fragile)
		return NONE
	if(cautious && HAS_TRAIT(user, TRAIT_BOMBER_EXPERT))
		to_chat(user, span_warning("Out of all the things you'd want to be fiddling with, you choose the worst? Bad idea."))
		return COMPONENT_CANCEL_ATTACK_CHAIN
	INVOKE_ASYNC(src, PROC_REF(detonate))
	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/component/rogue_explosive/proc/on_impact(datum/source, atom/hit_atom, datum/thrownthing/throwingdatum)
	SIGNAL_HANDLER
	var/mob/thrower = throwingdatum?.get_thrower()
	if(thrower)
		thrower_ref = WEAKREF(thrower)
	if(fragile && !exploding)
		addtimer(CALLBACK(src, PROC_REF(landed)), 1)

/// A fragile bomb goes off where it landed, or a bottle fails to (Azure Peak throw_impact()).
/datum/component/rogue_explosive/proc/landed()
	if(QDELETED(parent) || exploding)
		return
	if(prob(rogue_value_or("explosive_[kind]_fail", 0)))
		snuff()
		return
	detonate()

/datum/component/rogue_explosive/proc/on_fire_act(datum/source, exposed_temperature, exposed_volume)
	SIGNAL_HANDLER
	catch_fire()

/// Fire around a fused bomb lights it, unless it is safe in a Specialist's kit (Azure Peak fused fire_act()).
/datum/component/rogue_explosive/proc/catch_fire()
	if(!fused || shielded())
		return
	if(blast == ROGUE_EXPLOSIVE_BLAST_TRIP)
		INVOKE_ASYNC(src, PROC_REF(detonate))
		return
	light()

/datum/component/rogue_explosive/proc/on_pre_ex_act(datum/source, severity, target)
	SIGNAL_HANDLER
	if(exploding)
		return COMPONENT_CANCEL_EX_ACT
	if(shielded())
		return NONE
	INVOKE_ASYNC(src, PROC_REF(detonate), TRUE)
	return COMPONENT_CANCEL_EX_ACT

/datum/component/rogue_explosive/proc/on_extinguish(datum/source)
	SIGNAL_HANDLER
	snuff()

/// Lights the fuse (Azure Peak fused light()); a trip bomb goes off at once.
/datum/component/rogue_explosive/proc/light(mob/user)
	var/obj/item/bomb = parent
	if(QDELETED(bomb) || lit || exploding)
		return
	if(blast == ROGUE_EXPLOSIVE_BLAST_TRIP)
		INVOKE_ASYNC(src, PROC_REF(detonate))
		return
	if(!fused)
		INVOKE_ASYNC(src, PROC_REF(detonate))
		return
	lit = TRUE
	if(user)
		user.visible_message(span_warning("[user] lights [bomb]!"), span_warning("I light [bomb]!"))
	var/lit_state = "[initial(bomb.icon_state)]-lit"
	if(icon_exists(bomb.icon, lit_state))
		bomb.icon_state = lit_state
		bomb.update_inhand_icon()
	playsound(bomb, ROGUE_EXPLOSIVE_SOUND_LIT, 100)
	start_fuse(rand(rogue_value("explosive_[kind]_fuse_min"), rogue_value("explosive_[kind]_fuse_max")))

/datum/component/rogue_explosive/proc/start_fuse(time)
	if(fuse_timer)
		deltimer(fuse_timer)
	fuse_timer = addtimer(CALLBACK(src, PROC_REF(fuse_out)), max(time, 1), TIMER_STOPPABLE)

/datum/component/rogue_explosive/proc/fuse_out()
	fuse_timer = null
	detonate(TRUE)

/// Puts the fuse out (Azure Peak fused extinguish()).
/datum/component/rogue_explosive/proc/snuff()
	if(!lit || exploding)
		return
	lit = FALSE
	if(fuse_timer)
		deltimer(fuse_timer)
		fuse_timer = null
	var/obj/item/bomb = parent
	playsound(bomb, ROGUE_EXPLOSIVE_SOUND_SNUFF, 100)
	bomb.icon_state = initial(bomb.icon_state)
	bomb.update_inhand_icon()

/// Goes off (Azure Peak detonate()): the blast, then every bomb lying around it; a trip bomb sets off its payload.
/datum/component/rogue_explosive/proc/detonate(forced)
	var/obj/item/bomb = parent
	if(QDELETED(bomb) || exploding)
		return FALSE
	var/turf/spot = get_turf(bomb)
	if(!spot)
		return FALSE
	exploding = TRUE
	if(fuse_timer)
		deltimer(fuse_timer)
		fuse_timer = null
	if(blast == ROGUE_EXPLOSIVE_BLAST_TRIP)
		spring(spot)
		return TRUE
	var/mob/thrower = thrower_mob()
	switch(blast)
		if(ROGUE_EXPLOSIVE_BLAST_FIRE)
			blast_fire(spot, forced)
		if(ROGUE_EXPLOSIVE_BLAST_POWDER)
			blast_powder(spot)
		if(ROGUE_EXPLOSIVE_BLAST_SHRAPNEL)
			blast_shrapnel(spot)
		if(ROGUE_EXPLOSIVE_BLAST_GAS)
			blast_gas(spot)
	var/mob/owner = (isliving(thrower) && HAS_TRAIT(thrower, TRAIT_BOMBER_EXPERT)) ? thrower : null
	for(var/obj/item/other in range(rogue_value("explosive_chain_range"), spot))
		if(other == bomb || QDELETED(other) || !isturf(other.loc))
			continue
		var/datum/component/rogue_explosive/next = other.GetComponent(/datum/component/rogue_explosive)
		if(!next || next.exploding)
			continue
		if(owner)
			next.thrower_ref = WEAKREF(owner)
			next.tripcrit = rogue_value("explosive_chain_crit")
		INVOKE_ASYNC(next, PROC_REF(detonate), TRUE)
	qdel(bomb)
	return TRUE

/// A trip bomb sets off a fresh payload with a short fuse (Azure Peak tripbomb detonate()).
/datum/component/rogue_explosive/proc/spring(turf/spot)
	var/mob/owner = setter_ref?.resolve()
	var/obj/item/charge = new payload(spot)
	var/datum/component/rogue_explosive/explosive = charge.GetComponent(/datum/component/rogue_explosive)
	qdel(parent)
	if(!explosive)
		return
	if(owner)
		explosive.thrower_ref = WEAKREF(owner)
	explosive.tripcrit = tripcrit
	if(explosive.fused)
		explosive.lit = TRUE
		playsound(charge, ROGUE_EXPLOSIVE_SOUND_LIT, 100)
		var/expert = owner && HAS_TRAIT(owner, TRAIT_BOMBER_EXPERT)
		explosive.start_fuse(rogue_value(expert ? "explosive_trip_fuse_expert" : "explosive_trip_fuse"))
	else
		INVOKE_ASYNC(explosive, PROC_REF(detonate), TRUE)

/// The body was struck by a blast a moment ago and is spared this one (Azure Peak BOMB_HIT_IMMUNITY_DURATION).
/datum/component/rogue_explosive/proc/recently_struck(mob/living/target)
	if(target.rogue_bomb_hit_at && world.time < target.rogue_bomb_hit_at + rogue_value("explosive_hit_immunity"))
		return TRUE
	target.rogue_bomb_hit_at = world.time
	return FALSE

/// Chance a Specialist's blast has to blast a foe to bits (Azure Peak critbang).
/datum/component/rogue_explosive/proc/crit_chance(mob/living/thrower, per_skill)
	return thrower.rogue_skill_rank(/datum/attribute/skill/craft/engineering) * per_skill + thrower.rogue_stat(ROGUE_STAT_FORTUNE) * rogue_value("explosive_crit_per_luck")

/// Azure Peak crit(): a mindless foe that can be blasted apart is, another takes the blast again.
/datum/component/rogue_explosive/proc/crit(mob/living/target, damage_type)
	playsound(get_turf(target), ROGUE_EXPLOSIVE_SOUND_CRIT, 100, FALSE)
	if(rogue_can_be_gibbed(target))
		target.visible_message(span_userdanger("Critical hit! The explosive blasts [target] to pieces!"))
		target.gib(DROP_ALL_REMAINS)
		return
	target.visible_message(span_userdanger("Critical hit! The explosive deals devastating damage!"))
	target.apply_damage(rogue_value("explosive_[kind]_damage"), damage_type, BODY_ZONE_CHEST, attacking_item = parent)

/// Azure Peak bottle blast(): burns and staggers those around, sets the ground alight.
/datum/component/rogue_explosive/proc/blast_fire(turf/spot, forced)
	var/mob/living/thrower = thrower_mob()
	var/can_crit = FALSE
	var/critbang = 0
	if(isliving(thrower))
		can_crit = HAS_TRAIT(thrower, TRAIT_BOMBER_EXPERT)
		critbang = min(rogue_value("explosive_bottle_crit_cap"), crit_chance(thrower, rogue_value("explosive_bottle_crit_per_skill"))) + tripcrit
	playsound(spot, ROGUE_EXPLOSIVE_SOUND_SNUFF, 100)
	var/damage = rogue_value("explosive_bottle_damage")
	for(var/mob/living/target in range(rogue_value("explosive_bottle_burn_range"), spot))
		if(target == thrower && can_crit)
			continue
		if(recently_struck(target))
			continue
		var/burning = target.on_fire
		target.apply_damage(damage, BURN, BODY_ZONE_CHEST, attacking_item = parent)
		target.apply_status_effect(/datum/status_effect/rogue/staggered)
		if(can_crit && !target.mind && ((target.stat != STABLE && rogue_can_be_gibbed(target)) || (burning && prob(critbang))))
			crit(target, BURN)
	var/flames = (lit || forced) ? rogue_value("explosive_bottle_fire_range") : rogue_value("explosive_bottle_fire_range_cold")
	explosion(spot, light_impact_range = rogue_value("explosive_bottle_light_range"), flame_range = flames, adminlog = FALSE, smoke = (tripcrit > 0), explosion_cause = parent)
	playsound(spot, ROGUE_EXPLOSIVE_SOUND_BLAST, 100, TRUE)

/// Azure Peak powder blast(): strikes everyone in range by distance, wrecks structures, blows up the ground.
/datum/component/rogue_explosive/proc/blast_powder(turf/spot)
	var/range = rogue_value("explosive_[kind]_blast_range")
	var/damage = rogue_value("explosive_[kind]_damage")
	var/razes = rogue_value("explosive_[kind]_raze_factor")
	for(var/atom/movable/thing in dview(range, spot))
		if(QDELETED(thing))
			continue
		var/falloff = 1 - get_dist(thing, spot) / (range + 1)
		if(isliving(thing))
			var/mob/living/target = thing
			target.apply_damage(damage * falloff, BRUTE, BODY_ZONE_CHEST, attacking_item = parent)
			target.apply_status_effect(/datum/status_effect/rogue/staggered)
		else if(razes && isstructure(thing))
			var/obj/structure/building = thing
			building.take_damage(damage * razes * falloff, BRUTE, MELEE, FALSE)
	explosion(spot, devastation_range = rogue_value("explosive_[kind]_devastation_range"), heavy_impact_range = rogue_value("explosive_[kind]_heavy_range"), light_impact_range = rogue_value("explosive_[kind]_light_range"), flame_range = rogue_value("explosive_[kind]_flame_range"), ignorecap = (kind == "mega"), smoke = TRUE, explosion_cause = parent)
	playsound(spot, ROGUE_EXPLOSIVE_SOUND_BLAST, 100, TRUE)

/// Azure Peak shrapnel blast(): strikes its tile and flings shards about.
/datum/component/rogue_explosive/proc/blast_shrapnel(turf/spot)
	var/mob/living/thrower = thrower_mob()
	var/can_crit = FALSE
	var/critbang = 0
	if(isliving(thrower))
		can_crit = HAS_TRAIT(thrower, TRAIT_BOMBER_EXPERT)
		critbang = crit_chance(thrower, rogue_value("explosive_shrapnel_crit_per_skill")) + tripcrit
	var/damage = rogue_value("explosive_shrapnel_damage")
	for(var/mob/living/target in spot)
		if(target == thrower && can_crit)
			continue
		if(recently_struck(target))
			continue
		target.apply_damage(damage, BRUTE, BODY_ZONE_CHEST, attacking_item = parent)
		target.apply_status_effect(/datum/status_effect/rogue/staggered)
		if(can_crit && !target.mind && prob(critbang + (target.stat != STABLE ? rogue_value("explosive_crit_downed_bonus") : 0)))
			crit(target, BRUTE)
	var/shards = rogue_value("explosive_shrapnel_shards")
	var/scatter = rogue_value("explosive_shrapnel_scatter")
	for(var/i in 1 to shards)
		var/obj/projectile/bullet/rogue_bombshard/shard = new(spot)
		if(can_crit)
			shard.firer = thrower
		shard.fire(i * 360 / shards + rand(-scatter, scatter))
	explosion(spot, heavy_impact_range = rogue_value("explosive_shrapnel_heavy_range"), light_impact_range = rogue_value("explosive_shrapnel_light_range"), adminlog = FALSE, smoke = (tripcrit > 0), explosion_cause = parent)
	playsound(spot, ROGUE_EXPLOSIVE_SOUND_BLAST, 100, TRUE)

/// Azure Peak smoke blast(): the gas, and the spent shell.
/datum/component/rogue_explosive/proc/blast_gas(turf/spot)
	playsound(spot, gas_sound, kind == "smokebomb" ? 50 : 100)
	do_smoke(rogue_value("explosive_[kind]_smoke_range"), null, spot, effect_type = gas_effect || /obj/effect/particle_effect/fluid/smoke)
	if(residue)
		new residue(spot)

/// Ties fibres to the bomb: a trip bomb where it lies and a tripwire before the setter (Azure Peak attackby()).
/datum/component/rogue_explosive/proc/set_trap(mob/living/user, obj/item/fibers)
	var/obj/item/bomb = parent
	var/turf/front = get_turf(user)
	if(locate(/obj/item/tripwire) in front)
		to_chat(user, span_warning("There is already a trap here."))
		return
	if(!user.temporarilyRemoveItemFromInventory(fibers))
		return
	qdel(fibers)
	user.visible_message(span_warning("[user] begins to prepare [bomb]."), span_notice("I begin to set up [bomb] with the fibres."))
	var/expert = HAS_TRAIT(user, TRAIT_BOMBER_EXPERT)
	var/time = expert ? rogue_value("explosive_trap_time_expert") : max(rogue_value("explosive_trap_time") - user.rogue_skill_rank(/datum/attribute/skill/craft/crafting) * rogue_value("explosive_trap_time_per_skill"), 0)
	if(!do_after(user, time, target = bomb))
		to_chat(user, span_warning("I stop preparing [bomb]."))
		new /obj/item/natural/fibers(get_turf(user))
		if(!expert && prob(rogue_value("explosive_trap_fumble_chance")))
			to_chat(user, span_userdanger("Uh oh."))
			light()
		return
	if(QDELETED(bomb) || exploding)
		return
	var/obj/item/trap = new trip_type(get_turf(bomb))
	var/datum/component/rogue_explosive/trip = trap.GetComponent(/datum/component/rogue_explosive)
	if(!trip)
		qdel(trap)
		return
	trip.payload = bomb.type
	trip.setter_ref = WEAKREF(user)
	trip.tripcrit = tripcrit
	trap.icon = bomb.icon
	trap.icon_state = initial(bomb.icon_state)
	trap.add_overlay(mutable_appearance(ROGUE_EXPLOSIVE_TRIP_OVERLAY_ICON, "tripbomb"))
	var/obj/item/tripwire/wire = new(get_turf(user))
	wire.setDir(user.dir)
	wire.rogue_arm(trip)
	LAZYADD(trip.trips, wire)
	if(expert)
		trap.alpha = rogue_value("explosive_trap_expert_alpha")
		wire.alpha = rogue_value("explosive_trap_expert_alpha")
	user.visible_message(span_warning("[user] finishes setting up [trap]."), span_notice("I finish setting up [trap]."))
	qdel(bomb)

/// Cuts the trip bomb loose with a short blade; a clumsy cut sets it off (Azure Peak disarm()).
/datum/component/rogue_explosive/proc/disarm(mob/living/user, atom/cut)
	var/rank = user.rogue_skill_rank(/datum/attribute/skill/craft/crafting)
	var/time = HAS_TRAIT(user, TRAIT_BOMBER_EXPERT) ? rogue_value("explosive_trap_time_expert") : max(rogue_value("explosive_trap_time") - rank * rogue_value("explosive_trap_time_per_skill"), 0)
	if(!do_after(user, time, target = cut))
		to_chat(user, span_warning("I stop slicing [cut]."))
		if(!prob(rank * rogue_value("explosive_disarm_chance_per_skill")))
			to_chat(user, span_userdanger("Oh no."))
			INVOKE_ASYNC(src, PROC_REF(detonate))
		return
	if(QDELETED(parent) || exploding)
		return
	var/obj/item/trap = parent
	new payload(get_turf(trap))
	qdel(trap)

/// A clod of dirt hides a trip bomb or its wire, the better the more crafty the hand (Azure Peak dirtclod).
/proc/rogue_explosive_hide(atom/movable/hidden, mob/living/user, obj/item/clod)
	if(!user.temporarilyRemoveItemFromInventory(clod))
		return
	hidden.alpha = max(rogue_value("explosive_trap_hide_alpha") - user.rogue_skill_rank(/datum/attribute/skill/craft/crafting) * rogue_value("explosive_trap_hide_alpha_per_skill"), 0)
	qdel(clod)

/// Whether a blast may tear this body apart (Azure Peak can_be_gibbed()): not the great beasts, nor what cannot lose limbs.
/proc/rogue_can_be_gibbed(mob/living/target)
	if(target.maxHealth > rogue_value("explosive_gib_health_cap"))
		return FALSE
	if(HAS_TRAIT(target, TRAIT_NODISMEMBER))
		return FALSE
	return TRUE

// The tripwire (Azure Peak /obj/item/tripwire).

/obj/item/tripwire
	anchored = TRUE
	/// The trip bomb this wire sets off.
	var/datum/component/rogue_explosive/rogue_trap
	var/rogue_triggered = FALSE

/obj/item/tripwire/proc/rogue_arm(datum/component/rogue_explosive/trap)
	rogue_trap = trap
	var/static/list/connections = list(COMSIG_ATOM_ENTERED = PROC_REF(rogue_on_entered))
	AddElement(/datum/element/connect_loc, connections)

/obj/item/tripwire/Destroy()
	if(rogue_trap)
		LAZYREMOVE(rogue_trap.trips, src)
		rogue_trap = null
		var/turf/spot = get_turf(src)
		if(spot)
			new /obj/item/natural/fibers(spot)
	return ..()

/obj/item/tripwire/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(rogue_trap && tool.rogue_current_bclass == BCLASS_CUT && tool.wlength == WLENGTH_SHORT)
		if(!rogue_triggered)
			INVOKE_ASYNC(rogue_trap, TYPE_PROC_REF(/datum/component/rogue_explosive, disarm), user, src)
		return ITEM_INTERACT_SUCCESS
	if(istype(tool, /obj/item/natural/dirtclod))
		rogue_explosive_hide(src, user, tool)
		return ITEM_INTERACT_SUCCESS
	return ..()

/// Who steps on the wire is slowed and sets the bomb off; luck may spare the foot, the Specialist who set it is spared
/// (Azure Peak tripwire Crossed()).
/obj/item/tripwire/proc/rogue_on_entered(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER
	if(rogue_triggered || !isliving(arrived) || QDELETED(rogue_trap) || QDELETED(rogue_trap.parent))
		return
	var/mob/living/victim = arrived
	var/mob/owner = rogue_trap.setter_ref?.resolve()
	if(owner && victim == owner && HAS_TRAIT(owner, TRAIT_BOMBER_EXPERT))
		return
	var/luck = victim.rogue_stat(ROGUE_STAT_FORTUNE) - rogue_value("explosive_tripwire_luck_base")
	if(luck >= 0 && prob(luck * rogue_value("explosive_tripwire_luck_step")))
		to_chat(victim, span_warning("My foot narrowly misses [src]. Careful!"))
		return
	rogue_triggered = TRUE
	playsound(victim, ROGUE_EXPLOSIVE_SOUND_TRIP, 100, TRUE)
	victim.visible_message(span_userdanger("[victim] steps on [src]!"), span_userdanger("I feel the snapping of twine under my boot!"))
	victim.apply_status_effect(/datum/status_effect/rogue/slowed, rogue_value("explosive_tripwire_slowdown"))
	var/wits = rogue_value("explosive_tripwire_wits")
	if(victim.rogue_stat(ROGUE_STAT_INTELLIGENCE) <= wits || victim.rogue_stat(ROGUE_STAT_PERCEPTION) <= wits || !victim.mind)
		victim.Immobilize(rogue_value("explosive_tripwire_immobilize"))
		INVOKE_ASYNC(victim, TYPE_PROC_REF(/mob, emote), pick("gasp", "whimper"))
	rogue_trap.tripcrit = rogue_value("explosive_tripwire_crit")
	INVOKE_ASYNC(rogue_trap, TYPE_PROC_REF(/datum/component/rogue_explosive, detonate))

// Shards (Azure Peak bombshard, bomb_shrapnel, glass_shard/shrapnel, embed_bomb_shrapnel()).

/obj/projectile/bullet/rogue_bombshard
	name = "shrapnel"
	sharpness = SHARP_POINTY
	wound_bonus = 0
	hitsound = ROGUE_EXPLOSIVE_SOUND_SHARD

/obj/projectile/bullet/rogue_bombshard/Initialize(mapload)
	damage = rogue_value("explosive_shard_damage")
	range = rogue_value("explosive_shard_range")
	return ..()

/obj/projectile/bullet/rogue_bombshard/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	if(. == BULLET_ACT_HIT && isliving(target) && prob(rogue_value("explosive_shard_embed_chance")))
		rogue_embed_bomb_shrapnel(target, /obj/item/bomb_shrapnel, 1)

/// A shard sticks in a limb unless the armor over it holds, the likelier the more worn the armor (Azure Peak
/// embed_bomb_shrapnel()); held armor takes a bruise to the limb instead.
/proc/rogue_embed_bomb_shrapnel(mob/living/target, shrapnel_type, most)
	if(!iscarbon(target))
		return FALSE
	var/mob/living/carbon/victim = target
	var/list/limbs = list()
	for(var/obj/item/bodypart/limb as anything in victim.bodyparts)
		if(limb.body_zone in GLOB.rogue_shrapnel_zones)
			limbs += limb
	if(!length(limbs))
		return FALSE
	var/list/worn = victim.get_equipped_items()
	for(var/i in 1 to rand(1, min(most, length(limbs))))
		var/obj/item/bodypart/limb = pick_n_take(limbs)
		var/obj/item/protection
		for(var/obj/item/clothing in worn)
			if(clothing.body_parts_covered & limb.body_part)
				protection = clothing
				break
		var/hold_chance = 0
		if(protection?.max_integrity)
			var/floor_integrity = protection.max_integrity * protection.integrity_failure
			var/span = protection.max_integrity - floor_integrity
			if(span > 0)
				hold_chance = round(max(protection.get_integrity() - floor_integrity, 0) / span * 100)
		if(protection && prob(hold_chance))
			limb.receive_damage(brute = rogue_value("explosive_shrapnel_armor_damage"))
			continue
		var/obj/item/shard = new shrapnel_type(get_turf(victim))
		shard.set_embed(/datum/embedding/rogue_shrapnel)
		if(!shard.force_embed(victim, limb))
			qdel(shard)
	return TRUE

/datum/embedding/rogue_shrapnel
	embed_chance = 100
	fall_chance = 0
	ignore_throwspeed_threshold = TRUE

/datum/embedding/rogue_shrapnel/New(obj/item/creator)
	. = ..()
	pain_mult = rogue_value("explosive_shrapnel_pain_mult")

/// Pulled out, a shard of a bomb is only debris.
/obj/item/bomb_shrapnel/dropped(mob/user, silent)
	. = ..()
	if(!QDELETED(src))
		qdel(src)

/obj/item/natural/glass_shard/shrapnel/dropped(mob/user, silent)
	. = ..()
	if(QDELETED(src) || !prob(rogue_value("explosive_glass_shard_break_chance")))
		return
	var/turf/spot = get_turf(src)
	qdel(src)
	if(spot)
		new /obj/effect/decal/cleanable/glass(spot)

// Staggered (Azure Peak /datum/status_effect/debuff/staggered): perception, speed and constitution down, slower steps.

/datum/status_effect/rogue/staggered
	id = "rogue_staggered"
	alert_type = /atom/movable/screen/alert/status_effect/rogue/staggered

/datum/status_effect/rogue/staggered/on_creation(mob/living/new_owner, set_duration)
	base_duration = rogue_value("explosive_stagger_time")
	return ..()

/datum/status_effect/rogue/staggered/on_apply()
	. = ..()
	owner.attributes?.set_variable_attribute_modifier(id, list(ROGUE_STAT_PERCEPTION = -rogue_value("explosive_stagger_stat"), ROGUE_STAT_SPEED = -rogue_value("explosive_stagger_stat"), ROGUE_STAT_CONSTITUTION = -rogue_value("explosive_stagger_stat")))
	owner.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/rogue_staggered, multiplicative_slowdown = rogue_value("explosive_stagger_slowdown"))

/datum/status_effect/rogue/staggered/on_remove()
	owner.attributes?.remove_attribute_modifier(id)
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/rogue_staggered)
	return ..()

/datum/movespeed_modifier/rogue_staggered
	variable = TRUE

/atom/movable/screen/alert/status_effect/rogue/staggered
	name = "Staggered"
	desc = "I've been smacked by something big. The force of the impact has left me staggered."
	icon_state = "dazed"

// Gases of the belchers (Azure Peak effects_smoke.dm): what a breath of each does, at most once a second.

GLOBAL_LIST_INIT(rogue_gas_effects, list(
	"smoke" = /obj/effect/particle_effect/fluid/smoke,
	"smokebomb" = /obj/effect/particle_effect/fluid/smoke,
	"poison_gas" = /obj/effect/particle_effect/fluid/smoke/rogue_gas/poison,
	"healing_gas" = /obj/effect/particle_effect/fluid/smoke/rogue_gas/healing,
	"fire_gas" = /obj/effect/particle_effect/fluid/smoke/rogue_gas/fire,
	"blind_gas" = /obj/effect/particle_effect/fluid/smoke/rogue_gas/blind,
	"mute_gas" = /obj/effect/particle_effect/fluid/smoke/rogue_gas/mute,
))

/obj/effect/particle_effect/fluid/smoke/rogue_gas
	/// The <kind> of its numbers (explosive_<kind>_...).
	var/gas_kind

/obj/effect/particle_effect/fluid/smoke/rogue_gas/Initialize(mapload, datum/fluid_group/group, ...)
	. = ..()
	if(gas_kind)
		lifetime = rogue_value("explosive_[gas_kind]_lifetime")

/obj/effect/particle_effect/fluid/smoke/rogue_gas/poison
	color = "#369c50"
	gas_kind = "poison_gas"

/obj/effect/particle_effect/fluid/smoke/rogue_gas/poison/smoke_mob(mob/living/carbon/smoker, seconds_per_tick)
	. = ..()
	if(!.)
		return
	smoker.adjust_tox_loss(rogue_value("explosive_poison_gas_toxin"))
	smoker.emote("cough")

/obj/effect/particle_effect/fluid/smoke/rogue_gas/healing
	color = "#da4011"
	gas_kind = "healing_gas"

/// Azure Peak healing gas: mends a little of everything and closes bleeding wounds.
/obj/effect/particle_effect/fluid/smoke/rogue_gas/healing/smoke_mob(mob/living/carbon/smoker, seconds_per_tick)
	. = ..()
	if(!.)
		return
	smoker.adjust_brute_loss(-rogue_value("explosive_healing_gas_brute"), updating_health = FALSE)
	smoker.adjust_fire_loss(-rogue_value("explosive_healing_gas_burn"), updating_health = FALSE)
	smoker.adjust_oxy_loss(-rogue_value("explosive_healing_gas_oxy"), updating_health = FALSE)
	smoker.adjust_tox_loss(-rogue_value("explosive_healing_gas_toxin"), updating_health = FALSE)
	smoker.updatehealth()
	for(var/datum/wound/wound as anything in LAZYCOPY(smoker.all_wounds))
		// A crit of block VR1 keeps blood_flow at 0 and bleeds by rogue_bleed() (combat/wounds.dm).
		var/datum/wound/rogue/crit = wound
		if(wound.blood_flow > 0 || (istype(crit) && crit.rogue_bleed() > 0))
			wound.remove_wound()
	smoker.emote("cough")

/obj/effect/particle_effect/fluid/smoke/rogue_gas/fire
	color = "#d1b411"
	gas_kind = "fire_gas"

/obj/effect/particle_effect/fluid/smoke/rogue_gas/fire/smoke_mob(mob/living/carbon/smoker, seconds_per_tick)
	. = ..()
	if(!.)
		return
	smoker.adjust_fire_stacks(rogue_value("explosive_fire_gas_stacks"))
	smoker.ignite_mob()
	smoker.emote("scream")

/obj/effect/particle_effect/fluid/smoke/rogue_gas/blind
	color = "#292822"
	gas_kind = "blind_gas"

/obj/effect/particle_effect/fluid/smoke/rogue_gas/blind/smoke_mob(mob/living/carbon/smoker, seconds_per_tick)
	. = ..()
	if(!.)
		return
	smoker.adjust_temp_blindness_up_to(rogue_value("explosive_blind_gas_time"), rogue_value("explosive_blind_gas_time"))
	smoker.emote("cry")

/obj/effect/particle_effect/fluid/smoke/rogue_gas/mute
	color = "#529bfc"
	gas_kind = "mute_gas"

/obj/effect/particle_effect/fluid/smoke/rogue_gas/mute/smoke_mob(mob/living/carbon/smoker, seconds_per_tick)
	. = ..()
	if(!.)
		return
	smoker.set_silence_if_lower(rogue_value("explosive_mute_gas_time"))

#undef ROGUE_EXPLOSIVE_SOUND_LIT
#undef ROGUE_EXPLOSIVE_SOUND_SNUFF
#undef ROGUE_EXPLOSIVE_SOUND_BLAST
#undef ROGUE_EXPLOSIVE_SOUND_CRIT
#undef ROGUE_EXPLOSIVE_SOUND_GAS
#undef ROGUE_EXPLOSIVE_SOUND_SMOKEBOMB
#undef ROGUE_EXPLOSIVE_SOUND_TRIP
#undef ROGUE_EXPLOSIVE_SOUND_SHARD
#undef ROGUE_EXPLOSIVE_TRIP_OVERLAY_ICON
#undef ROGUE_EXPLOSIVE_BLAST_FIRE
#undef ROGUE_EXPLOSIVE_BLAST_POWDER
#undef ROGUE_EXPLOSIVE_BLAST_SHRAPNEL
#undef ROGUE_EXPLOSIVE_BLAST_GAS
#undef ROGUE_EXPLOSIVE_BLAST_TRIP
