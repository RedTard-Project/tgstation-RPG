/// K2d1 (owner, 2026-11-22): a crit with a stabbing or cutting weapon may leave it stuck in the struck part, counted as Azure
/// Peak counts it (should_embed_weapon(): the embed_chance of the crit's wound; Azure's own lodging is commented out). While it
/// is stuck the one who struck holds the target in a hold of its own, and the weapon offers two intents instead of its own:
/// pull out (no more harm) and twist (a sure crit of the weapon's own kind of harm, then the weapon comes free). A kick or a
/// shove at either of them breaks the hold, and the weapon stays in the part as an arrow does and comes out the same way.

/// The blows that may leave a weapon stuck: stabbing and cutting ones. Blunt ones never do.
GLOBAL_LIST_INIT(rogue_stick_classes, list(BCLASS_CUT, BCLASS_CHOP, BCLASS_STAB, BCLASS_PICK, BCLASS_PIERCE))
/// The cutting classes a twist cuts with; the stabbing ones (rogue_stab_classes) stab.
GLOBAL_LIST_INIT(rogue_stick_cut_classes, list(BCLASS_CUT, BCLASS_CHOP))
/// Azure Peak's crit wounds with embed_chance 100 (fracture/head/brain, eyes, ears): a stab into the skull, an eye or an ear.
GLOBAL_LIST_INIT(rogue_stick_organ_crits, list(ROGUE_CRIT_BRAIN, ROGUE_CRIT_EYES, ROGUE_CRIT_EARS))
GLOBAL_LIST_INIT(rogue_stuck_intents, list(/datum/intent/rogue_stuck/pull_out, /datum/intent/rogue_stuck/twist))
GLOBAL_LIST_INIT(rogue_stuck_pull_intents, list(/datum/intent/rogue_stuck/pull_out))

/obj/item
	/// The hold this weapon is stuck in, while it is (K2d1).
	var/datum/rogue_stuck_weapon/rogue_stuck

/mob/living/carbon
	/// Chance that the blow whose crit just landed leaves its weapon stuck, and the time of that crit (-1 when none waits).
	var/rogue_stick_chance = 0
	var/rogue_stick_at = -1

/// Called by rogue_try_crit() when a crit took: the chance of Azure Peak's should_embed_weapon() for its wound. The crit does
/// not know the weapon, so the stick waits for the strike's COMSIG_ROGUE_STRIKE_LANDED, sent right after it (specials send
/// none, so their crits never stick).
/mob/living/carbon/proc/rogue_mark_stick(blade_class, list/attempt, mob/living/attacker)
	if(!attacker || attacker == src || !(blade_class in GLOB.rogue_stick_classes))
		return
	var/chance = 0
	if((attempt[3] in GLOB.rogue_stick_organ_crits) && (blade_class in GLOB.rogue_stab_classes))
		chance = rogue_value("stuck_weapon_chance_organ")
	else if((attempt[1] == WOUND_PIERCE || attempt[1] == WOUND_SLASH) && attempt[2] >= WOUND_SEVERITY_CRITICAL)
		chance = rogue_value("stuck_weapon_chance_artery")
	if(chance <= 0)
		return
	rogue_stick_chance = chance
	rogue_stick_at = world.time
	RegisterSignal(src, COMSIG_ROGUE_STRIKE_LANDED, PROC_REF(rogue_on_stick_strike), override = TRUE)

/mob/living/carbon/proc/rogue_on_stick_strike(datum/source, datum/rogue_strike/strike)
	SIGNAL_HANDLER
	UnregisterSignal(src, COMSIG_ROGUE_STRIKE_LANDED)
	var/crit_at = rogue_stick_at
	rogue_stick_at = -1
	if(crit_at != world.time || !strike.weapon || !strike.intent || !prob(rogue_stick_chance))
		return
	var/obj/item/bodypart/limb = get_bodypart(rogue_zone_target(strike.zone)) || get_bodypart(BODY_ZONE_CHEST)
	INVOKE_ASYNC(src, PROC_REF(rogue_stick_weapon), strike.attacker, strike.weapon, limb, strike.intent.blade_class, strike.intent)

/// Whether this weapon can stick in a body for a blow of this class.
/obj/item/proc/rogue_can_stick(blade_class)
	if(!(blade_class in GLOB.rogue_stick_classes) || rogue_stuck || (item_flags & (ABSTRACT|HAND_ITEM)) || HAS_TRAIT(src, TRAIT_NODROP))
		return FALSE
	return TRUE

/// Lodges the weapon the holder struck with in the limb and starts the hold. Azure Peak: only beside the target; the target
/// is stunned for a moment and the weapon sounds as it goes in. Azure keeps a long weapon out of all but the chest; the owner
/// wants a spear in the arm (K2d1), so that rule is not taken.
/mob/living/carbon/proc/rogue_stick_weapon(mob/living/carbon/human/holder, obj/item/weapon, obj/item/bodypart/limb, blade_class, datum/intent/intent)
	if(!istype(holder) || holder == src || QDELETED(weapon) || !holder.is_holding(weapon) || !weapon.rogue_can_stick(blade_class))
		return FALSE
	if(!limb || limb.owner != src || HAS_TRAIT(src, TRAIT_PIERCEIMMUNE) || !holder.Adjacent(src))
		return FALSE
	var/datum/rogue_stuck_weapon/stuck = new(holder, src, weapon, limb, blade_class, intent)
	if(QDELETED(stuck))
		return FALSE
	Stun(rogue_value("stuck_weapon_stun"))
	INVOKE_ASYNC(src, TYPE_PROC_REF(/mob, emote), "embed", NONE, null, FALSE, FALSE, TRUE)
	playsound(src, pick('modular_redtard/rockhill/sound/combat/hits/blunt/genblunt (1).ogg', 'modular_redtard/rockhill/sound/combat/hits/blunt/genblunt (2).ogg', 'modular_redtard/rockhill/sound/combat/hits/blunt/genblunt (3).ogg'), 100, FALSE, -1)
	holder.visible_message(span_danger("[holder]'s [weapon.name] sticks in [src]'s [limb.plaintext_zone]!"), span_danger("My [weapon.name] sticks in [src]'s [limb.plaintext_zone]!"))
	log_combat(holder, src, "stuck a weapon in", weapon, "(ZONE: [limb.body_zone])")
	return TRUE

/// The hold of a stuck weapon: the holder keeps the weapon in hand, neither of the two may step away from the other, and the
/// weapon's intents are pull out and twist. It ends with either of them, or when the holder lets go of the weapon, falls
/// unconscious or holds it too long; a kick or a shove at either, a throw apart, or letting go leaves the weapon in the part.
/datum/rogue_stuck_weapon
	var/mob/living/carbon/human/holder
	var/mob/living/carbon/victim
	var/obj/item/weapon
	var/obj/item/bodypart/limb
	/// The intent the weapon struck with, given back to it when it comes free.
	var/datum/intent/stuck_intent
	/// The wound a twist deals (WOUND_PIERCE or WOUND_SLASH), by the weapon's main intent; none for a blunt weapon.
	var/twist_wound
	/// The holder's intent key of the weapon's hand (rogue_intent_key()) and its slot before the hold.
	var/intent_key
	var/old_slot
	/// Until when a kick just aimed at the holder or the victim counts as landing (mob = time).
	var/list/kicked_until
	var/hold_timer
	var/next_move_note = 0

/datum/rogue_stuck_weapon/New(mob/living/carbon/human/holder, mob/living/carbon/victim, obj/item/weapon, obj/item/bodypart/limb, blade_class, datum/intent/intent)
	src.holder = holder
	src.victim = victim
	src.weapon = weapon
	src.limb = limb
	stuck_intent = intent
	twist_wound = rogue_twist_wound(weapon, blade_class)
	intent_key = holder.rogue_intent_key(holder.get_held_index_of_item(weapon))
	old_slot = LAZYACCESS(holder.rogue_intent_index, intent_key)
	LAZYSET(holder.rogue_intent_index, intent_key, 1)
	weapon.rogue_stuck = src
	RegisterSignals(holder, list(COMSIG_QDELETING), PROC_REF(on_party_deleted))
	RegisterSignals(victim, list(COMSIG_QDELETING), PROC_REF(on_party_deleted))
	for(var/mob/living/party as anything in list(holder, victim))
		RegisterSignal(party, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(on_pre_move))
		RegisterSignal(party, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
		RegisterSignal(party, COMSIG_ROGUE_STRIKE_INCOMING, PROC_REF(on_incoming))
		RegisterSignal(party, COMSIG_MOB_AFTER_APPLY_DAMAGE, PROC_REF(on_damaged))
		RegisterSignal(party, COMSIG_LIVING_DISARM_HIT, PROC_REF(on_shoved))
	RegisterSignal(holder, COMSIG_MOB_STATCHANGE, PROC_REF(on_holder_stat))
	RegisterSignals(weapon, list(COMSIG_QDELETING), PROC_REF(on_weapon_deleted))
	RegisterSignal(weapon, COMSIG_ITEM_DROPPED, PROC_REF(on_weapon_dropped))
	RegisterSignals(weapon, list(COMSIG_ITEM_INTERACTING_WITH_ATOM, COMSIG_ITEM_INTERACTING_WITH_ATOM_SECONDARY), PROC_REF(on_weapon_used))
	RegisterSignals(limb, list(COMSIG_BODYPART_REMOVED, COMSIG_QDELETING), PROC_REF(on_limb_lost))
	hold_timer = addtimer(CALLBACK(src, PROC_REF(break_hold), "can hold [weapon] no longer"), rogue_value("stuck_weapon_hold_time"), TIMER_STOPPABLE)
	holder.rogue_refresh_intents()
	weapon.rogue_apply_intent(stuck_intent)

/datum/rogue_stuck_weapon/Destroy(force)
	if(hold_timer)
		deltimer(hold_timer)
		hold_timer = null
	var/mob/living/carbon/human/old_holder = holder
	var/obj/item/old_weapon = weapon
	if(old_holder)
		UnregisterSignal(old_holder, list(COMSIG_QDELETING, COMSIG_MOVABLE_PRE_MOVE, COMSIG_MOVABLE_MOVED, COMSIG_ROGUE_STRIKE_INCOMING, COMSIG_MOB_AFTER_APPLY_DAMAGE, COMSIG_LIVING_DISARM_HIT, COMSIG_MOB_STATCHANGE))
	if(victim)
		UnregisterSignal(victim, list(COMSIG_QDELETING, COMSIG_MOVABLE_PRE_MOVE, COMSIG_MOVABLE_MOVED, COMSIG_ROGUE_STRIKE_INCOMING, COMSIG_MOB_AFTER_APPLY_DAMAGE, COMSIG_LIVING_DISARM_HIT))
	if(limb)
		UnregisterSignal(limb, list(COMSIG_BODYPART_REMOVED, COMSIG_QDELETING))
	if(old_weapon)
		UnregisterSignal(old_weapon, list(COMSIG_QDELETING, COMSIG_ITEM_DROPPED, COMSIG_ITEM_INTERACTING_WITH_ATOM, COMSIG_ITEM_INTERACTING_WITH_ATOM_SECONDARY))
		if(old_weapon.rogue_stuck == src)
			old_weapon.rogue_stuck = null
		if(!QDELETED(old_weapon))
			old_weapon.rogue_apply_intent(stuck_intent)
	if(old_holder && !QDELETED(old_holder))
		LAZYSET(old_holder.rogue_intent_index, intent_key, old_slot || 1)
		old_holder.rogue_refresh_intents()
	holder = null
	victim = null
	weapon = null
	limb = null
	stuck_intent = null
	kicked_until = null
	return ..()

/// The wound a twist deals: by the weapon's main intent (the first of its one-handed ones), stabbing for a spear, cutting for
/// a blade; a weapon whose main blow is blunt (a mace's pick) cannot twist. A thing without intents of its own goes by the blow.
/proc/rogue_twist_wound(obj/item/weapon, blade_class)
	var/datum/intent/main = length(weapon.possible_item_intents) ? rogue_intent(weapon.possible_item_intents[1]) : null
	var/main_class = (main && !main.no_attack && !main.unarmed) ? main.blade_class : blade_class
	if(main_class in GLOB.rogue_stab_classes)
		return WOUND_PIERCE
	if(main_class in GLOB.rogue_stick_cut_classes)
		return WOUND_SLASH
	return null

/datum/rogue_stuck_weapon/proc/intents()
	return twist_wound ? GLOB.rogue_stuck_intents : GLOB.rogue_stuck_pull_intents

/// The holder clicks with the stuck weapon: on the victim it does what the intent says; on anything else it does nothing.
/datum/rogue_stuck_weapon/proc/on_weapon_used(obj/item/source, mob/living/user, atom/target, list/modifiers)
	SIGNAL_HANDLER
	if(user != holder)
		return NONE
	if(target != victim || LAZYACCESS(modifiers, RIGHT_CLICK) || world.time < holder.next_move)
		if(target != victim)
			holder.balloon_alert(holder, "stuck!")
		return ITEM_INTERACT_BLOCKING
	var/datum/intent/rogue_stuck/intent = holder.rogue_hand_intent(holder.get_held_index_of_item(weapon))
	if(!istype(intent))
		return ITEM_INTERACT_BLOCKING
	INVOKE_ASYNC(intent, TYPE_PROC_REF(/datum/intent/rogue_stuck, stuck_act), src)
	return ITEM_INTERACT_SUCCESS

/// Pull out: the weapon comes free into the hand, with no more harm.
/datum/rogue_stuck_weapon/proc/pull_out()
	if(QDELETED(src))
		return FALSE
	holder.changeNext_move(CLICK_CD_MELEE)
	holder.do_attack_animation(victim, used_item = weapon)
	playsound(victim, 'modular_redtard/combat/sound/misc/flesh_rem.ogg', 100, TRUE, -2)
	holder.visible_message(span_notice("[holder] pulls [weapon] out of [victim]'s [limb.plaintext_zone]."), span_notice("I pull [weapon] out of [victim]'s [limb.plaintext_zone]."))
	log_combat(holder, victim, "pulled a stuck weapon out of", weapon)
	qdel(src)
	return TRUE

/// Twist: harm by the weapon's force and a sure crit of its own kind of harm (critical resistance still holds it off), then
/// the weapon comes free.
/datum/rogue_stuck_weapon/proc/twist()
	if(QDELETED(src) || !twist_wound)
		return FALSE
	var/mob/living/carbon/human/twister = holder
	var/mob/living/carbon/twisted = victim
	var/obj/item/bodypart/part = limb
	var/obj/item/blade = weapon
	twister.changeNext_move(CLICK_CD_MELEE)
	twister.do_attack_animation(twisted, used_item = blade)
	twisted.apply_damage(blade.force * rogue_value("stuck_weapon_twist_damage"), BRUTE, part, wound_bonus = CANT_WOUND, sharpness = (twist_wound == WOUND_PIERCE ? SHARP_POINTY : SHARP_EDGED), attacking_item = blade)
	twisted.visible_message(span_danger("[twister] twists [blade] in [twisted]'s [part.plaintext_zone]!"), span_userdanger("[twister] twists [blade] in my [part.plaintext_zone]!"))
	if(twisted.rogue_resist_crit())
		twisted.visible_message(span_crit("Critical resistance! [twisted] resists a wound!"))
	else
		twisted.rogue_apply_crit(part, twist_wound, WOUND_SEVERITY_CRITICAL, null, twister)
		playsound(twisted, 'modular_redtard/rockhill/sound/combat/crit.ogg', 100, TRUE)
		INVOKE_ASYNC(twisted, TYPE_PROC_REF(/mob, emote), "paincrit", NONE, null, FALSE, FALSE, TRUE)
		twisted.visible_message(rogue_crit_text("[blade] tears through [twisted]'s [part.plaintext_zone]!"))
	playsound(twisted, 'modular_redtard/combat/sound/misc/flesh_rem.ogg', 100, TRUE, -2)
	log_combat(twister, twisted, "twisted a stuck weapon in", blade, "(ZONE: [part.body_zone])")
	qdel(src)
	return TRUE

/// The hold breaks: the weapon leaves the holder's hand and stays in the part, as an arrow does (TG embedding, taken out the
/// same way). Without the part it just ends.
/datum/rogue_stuck_weapon/proc/break_hold(reason)
	hold_timer = null
	if(QDELETED(src))
		return
	var/mob/living/carbon/human/old_holder = holder
	var/mob/living/carbon/pierced = victim
	var/obj/item/bodypart/part = limb
	var/obj/item/blade = weapon
	qdel(src)
	if(QDELETED(blade) || QDELETED(pierced) || !part || part.owner != pierced)
		return
	if(old_holder?.is_holding(blade) && !old_holder.temporarilyRemoveItemFromInventory(blade, force = TRUE))
		return
	if(reason && old_holder)
		pierced.visible_message(span_danger("[old_holder] [reason], and [blade] stays in [pierced]'s [part.plaintext_zone]!"), span_userdanger("[blade] stays in my [part.plaintext_zone]!"))
	blade.rogue_lodge(pierced, part)

/// Leaves the item in the part through TG embedding, with no more harm on going in (it is in already).
/obj/item/proc/rogue_lodge(mob/living/carbon/victim, obj/item/bodypart/part)
	var/old_throwforce = throwforce
	throwforce = 0
	set_embed(/datum/embedding/rogue_projectile/stuck_weapon)
	. = force_embed(victim, part)
	throwforce = old_throwforce
	if(!.)
		set_embed(null)

/// The weapon came out of the body: it gets back its own embedding (none, or that of its type).
/obj/item/proc/rogue_unlodge(datum/embedding/stuck_embed)
	if(embed_data == stuck_embed)
		set_embed(null)

/// A weapon a broken hold left in a body: as an arrow (/datum/embedding/rogue_projectile), and its own again once out.
/datum/embedding/rogue_projectile/stuck_weapon

/datum/embedding/rogue_projectile/stuck_weapon/stop_embedding()
	var/obj/item/blade = parent
	. = ..()
	if(!. && !QDELETED(blade))
		addtimer(CALLBACK(blade, TYPE_PROC_REF(/obj/item, rogue_unlodge), src), 1)

/// Neither may walk away from the other; being thrown, shoved or dragged by someone else is no walking.
/datum/rogue_stuck_weapon/proc/on_pre_move(mob/living/source, atom/newloc)
	SIGNAL_HANDLER
	var/mob/living/other = source == holder ? victim : holder
	if(source.throwing || (source.pulledby && source.pulledby != other) || !newloc || (newloc.z == other.z && get_dist(newloc, other) <= 1))
		return NONE
	if(world.time >= next_move_note)
		next_move_note = world.time + 1 SECONDS
		to_chat(source, span_warning((source == holder ? "My [weapon.name] is stuck in [victim]!" : "[weapon] in my [limb.plaintext_zone] holds me fast!")))
	return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

/datum/rogue_stuck_weapon/proc/on_moved(mob/living/source, atom/old_loc, dir, forced, list/old_locs)
	SIGNAL_HANDLER
	if(holder.z != victim.z || get_dist(holder, victim) > 1)
		INVOKE_ASYNC(src, PROC_REF(break_hold), "is torn away")

/// A kick says it comes (COMSIG_ROGUE_STRIKE_INCOMING of kind kick) and lands as plain brute damage without an item a moment
/// later (rogue_try_kick()); the damage within that moment is the kick landing. A blocked kick does no damage.
/datum/rogue_stuck_weapon/proc/on_incoming(mob/living/source, datum/rogue_strike/strike)
	SIGNAL_HANDLER
	if(strike.kind == ROGUE_STRIKE_KICK)
		LAZYSET(kicked_until, source, world.time + ROGUE_KICK_SWING + 1)
	return NONE

/datum/rogue_stuck_weapon/proc/on_damaged(mob/living/source, damage, damagetype, def_zone, blocked, wound_bonus, exposed_wound_bonus, sharpness, attack_direction, attacking_item)
	SIGNAL_HANDLER
	if(damage <= 0 || damagetype != BRUTE || attacking_item || LAZYACCESS(kicked_until, source) < world.time)
		return
	INVOKE_ASYNC(src, PROC_REF(break_hold), (source == holder ? "is kicked away" : "is kicked free"))

/datum/rogue_stuck_weapon/proc/on_shoved(mob/living/source, mob/living/attacker, zone, obj/item/used)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(break_hold), (source == holder ? "is shoved away" : "is shoved free"))

/datum/rogue_stuck_weapon/proc/on_holder_stat(mob/living/source, new_stat, old_stat)
	SIGNAL_HANDLER
	if(new_stat >= HARD_CRIT)
		INVOKE_ASYNC(src, PROC_REF(break_hold), "goes limp")

/datum/rogue_stuck_weapon/proc/on_weapon_dropped(obj/item/source, mob/user)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(break_hold), "lets go")

/datum/rogue_stuck_weapon/proc/on_party_deleted(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/rogue_stuck_weapon/proc/on_weapon_deleted(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/// The part comes off (on the blade or otherwise): the hold ends and the weapon stays in hand.
/datum/rogue_stuck_weapon/proc/on_limb_lost(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/intent/rogue_stuck
	no_attack = TRUE
	canparry = FALSE
	candodge = FALSE
	attack_verb = null
	releasedrain = 0
	misscost = 0
	clickcd = CLICK_CD_MELEE

/datum/intent/rogue_stuck/proc/stuck_act(datum/rogue_stuck_weapon/stuck)
	return FALSE

/datum/intent/rogue_stuck/pull_out
	name = "pull out"
	desc = "Pull the stuck weapon out of the wound, doing no more harm."
	icon_state = "intake"

/datum/intent/rogue_stuck/pull_out/stuck_act(datum/rogue_stuck_weapon/stuck)
	return stuck.pull_out()

/datum/intent/rogue_stuck/twist
	name = "twist"
	desc = "Twist the stuck weapon in the wound: a sure crit of the weapon's own kind of harm, and the weapon comes free."
	icon_state = "intwist"

/datum/intent/rogue_stuck/twist/stuck_act(datum/rogue_stuck_weapon/stuck)
	return stuck.twist()
