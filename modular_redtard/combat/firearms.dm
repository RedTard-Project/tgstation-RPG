/// Smokepowder weapons by Ratwood (rogueweapons/ranged/firearms/: firearm_base.dm, arquebus.dm, blunderbuss.dm,
/// handgonne.dm, firearm_ammo.dm) on the module's launchers (combat/launchers.dm). Azure Peak has no firearms. Ratwood's
/// /obj/item/gun/ballistic/firearm is grafted onto /obj/item/gun/ballistic/rogue_launcher/firearm by the porter
/// (rockhill/config.json graft_overrides); the blunderbuss, which the porter did not bring, is here.
/// - Loading: smokepowder from a powder flask (firearm_load_time less firearm_load_time_per_skill per rank of Firearms),
///   then a ball pushed down the barrel (the weapon held in the other hand), then rammed home with the ramrod (the same
///   time). The ramrod rides under the barrel: right-click the weapon with an empty hand to draw it, use it on the loaded
///   weapon to stow it again.
/// - Aiming is the charge of the shooting intent: firearm_aim_base (an arcing shot firearm_arc_aim_base) less
///   firearm_aim_per_skill per rank of Firearms and firearm_aim_per_perception per point of perception, never under
///   firearm_aim_floor; both hands are needed (the weapon wielded, or a pistol with the other hand free). Let go early the
///   ball strays by up to firearm_uncharged_spread degrees; a full aim teaches Firearms (firearm_full_aim_xp_per_int per
///   point of intelligence), and a hit teaches it as any launcher's.
/// - A handgonne's fuse and a flintlock's flint take a moment before the shot goes off (firearm_<kind>_delay_min/max).
/// - The shot shakes the view around, leaves a trail of smoke, and below the trained ranks it may burn the shooter's face or
///   hands and knock the weapon from his hands, or the recoil may throw him back (firearm_accident_*); a Fusilier
///   (TRAIT_FUSILIER) never fumbles it.
/// - A ball that strikes a person floors him unless his constitution beats a roll of firearm_stagger_roll, else it slows
///   him; a lead ball hits an opened guard harder; a silver ball sets the silver-weak alight; grapeshot flies as pellets.
#define ROGUE_FIREARM_SOUND_FIRE pick('modular_redtard/combat/sound/firearms/arquefire.ogg', 'modular_redtard/combat/sound/firearms/arquefire2.ogg', 'modular_redtard/combat/sound/firearms/arquefire3.ogg', 'modular_redtard/combat/sound/firearms/arquefire4.ogg', 'modular_redtard/combat/sound/firearms/arquefire5.ogg')
#define ROGUE_FIREARM_SOUND_FUSE 'modular_redtard/combat/sound/firearms/fuse.ogg'
#define ROGUE_FIREARM_SOUND_FLINT 'modular_redtard/rockhill/sound/items/flint.ogg'
#define ROGUE_FIREARM_SOUND_INSERT 'modular_redtard/combat/sound/firearms/insert.ogg'
#define ROGUE_FIREARM_SOUND_COCK 'modular_redtard/combat/sound/firearms/musketcock.ogg'
#define ROGUE_FIREARM_SOUND_STOW 'modular_redtard/combat/sound/firearms/musketload.ogg'
#define ROGUE_FIREARM_SOUND_POUR 'modular_redtard/combat/sound/firearms/pour_powder.ogg'
#define ROGUE_FIREARM_SOUND_RAM 'modular_redtard/combat/sound/firearms/ramrod.ogg'
/// Ratwood's smoke trail: tiles ahead of the shooter and when the puffs appear (visual only).
#define ROGUE_FIREARM_SHAKE_RANGE 5

/// Ratwood's kinds of firearm, most specific first: the fuse or flint before the shot, the one-handed pistol.
GLOBAL_LIST_INIT(rogue_firearm_kinds, list(
	/obj/item/gun/ballistic/firearm/flintgonne/fusil = "fusil",
	/obj/item/gun/ballistic/firearm/flintgonne = "flintgonne",
	/obj/item/gun/ballistic/firearm/handgonne = "handgonne",
	/obj/item/gun/ballistic/firearm/arquebus_pistol = "pistol",
))

// Intents: aimed in both hands, no tremble of a held draw (Ratwood chargedrain 0).

/datum/intent/shoot/firearm
	rogue_hold_strain = FALSE

/datum/intent/arc/firearm
	rogue_hold_strain = FALSE

/// Both hands on the weapon: wielded (the other hand holds its grip), or a pistol with the other hand free (Ratwood
/// can_charge()).
/proc/rogue_firearm_can_aim(mob/living/carbon/human/fighter, obj/item/held)
	var/obj/item/other = fighter.get_inactive_held_item()
	if(fighter.usable_hands < 2 || (other && !istype(other, /obj/item/offhand)))
		to_chat(fighter, span_warning("I need both hands to aim [held]!"))
		return FALSE
	return TRUE

/datum/intent/shoot/firearm/rogue_can_charge(mob/living/carbon/human/fighter, obj/item/held)
	return rogue_firearm_can_aim(fighter, held)

/datum/intent/arc/firearm/rogue_can_charge(mob/living/carbon/human/fighter, obj/item/held)
	return rogue_firearm_can_aim(fighter, held)

// Magazines: one ball, or one charge of grapeshot (Ratwood /obj/item/ammo_box/magazine/internal/firearm).

/obj/item/ammo_box/magazine/internal/rogue_launcher/lead
	name = "barrel"
	caliber = "lead_sphere"

/obj/item/ammo_box/magazine/internal/rogue_launcher/grapeshot
	name = "barrel"
	caliber = "grapeshot"

/// Base of Ratwood's firearms.
/obj/item/gun/ballistic/rogue_launcher/firearm
	name = "firearm"
	abstract_type = /obj/item/gun/ballistic/rogue_launcher/firearm
	icon = 'modular_redtard/rockhill/icons/modular_helmsguard/icons/weapons/arquebus.dmi'
	icon_state = "arquebus"
	weapon_weight = WEAPON_MEDIUM
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/rogue_launcher/lead
	cartridge_wording = "lead ball"
	must_hold_to_load = TRUE
	rogue_launch_skill = /datum/attribute/skill/combat/firearms
	/// Smokepowder is poured in (Ratwood gunpowder).
	var/rogue_powder = FALSE
	/// The ball is rammed home: it can fire (Ratwood reloaded).
	var/rogue_rammed = FALSE
	/// The ramrod under the barrel (Ratwood myrod).
	var/obj/item/ramrod/rogue_rod
	/// Kind of the firearm, the <kind> of its numbers (GLOB.rogue_firearm_kinds).
	var/rogue_firearm_kind
	/// The fuse or flint is at work: the shot goes off in a moment, with the aim taken when the trigger was pulled.
	var/rogue_fuse_lit = FALSE
	var/rogue_fuse_burnt = FALSE
	var/rogue_fuse_share = 1
	/// Share of the aim the last shot was let go with.
	var/rogue_last_share = 1

/obj/item/gun/ballistic/rogue_launcher/firearm/Initialize(mapload)
	. = ..()
	rogue_rod = new /obj/item/ramrod(src)
	for(var/kind_type in GLOB.rogue_firearm_kinds)
		if(istype(src, kind_type))
			rogue_firearm_kind = GLOB.rogue_firearm_kinds[kind_type]
			break
	if(rogue_firearm_kind == "pistol")
		weapon_weight = WEAPON_LIGHT

/obj/item/gun/ballistic/rogue_launcher/firearm/Destroy()
	QDEL_NULL(rogue_rod)
	return ..()

/obj/item/gun/ballistic/rogue_launcher/firearm/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == rogue_rod)
		rogue_rod = null

/obj/item/gun/ballistic/rogue_launcher/firearm/examine(mob/user)
	. = ..()
	. += span_info("My <b>FIREARMS</b> skill and perception define how fast I aim and load. Below the trained ranks the shot may burn me or throw me back.")
	. += span_info("Load it with smokepowder from a flask, then a ball, then ram it home with the ramrod.")
	if(rogue_powder)
		. += span_notice("It is filled with smokepowder.")
	if(chambered)
		. += span_notice((rogue_rammed ? "A [chambered.name] is rammed home." : "A [chambered.name] sits loose in the barrel."))
	if(rogue_rod)
		. += span_notice("A ramrod is stowed under the barrel.")
	else
		. += span_warning("Its ramrod is missing!")

/// Z only wields it (Ratwood attack_self()): the ball stays in the barrel.
/obj/item/gun/ballistic/rogue_launcher/firearm/attack_self(mob/living/user, modifiers)
	SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_SELF, user)
	return TRUE

/// Right-click with an empty hand draws the ramrod (Ratwood attack_right()).
/obj/item/gun/ballistic/rogue_launcher/firearm/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(user.get_active_held_item())
		return
	if(!rogue_rod)
		to_chat(user, span_warning("There is no rod stowed in [src]!"))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	var/obj/item/ramrod/rod = rogue_rod
	if(user.put_in_hands(rod))
		playsound(src, 'modular_redtard/combat/sound/firearms/sharpen_short1.ogg', 100)
		to_chat(user, span_warning("I draw the ramrod from [src]!"))
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/gun/ballistic/rogue_launcher/firearm/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/powderflask))
		INVOKE_ASYNC(src, PROC_REF(rogue_pour), user)
		return ITEM_INTERACT_SUCCESS
	if(istype(tool, /obj/item/ramrod))
		INVOKE_ASYNC(src, PROC_REF(rogue_ram), user, tool)
		return ITEM_INTERACT_SUCCESS
	if(isammocasing(tool))
		if(chambered)
			to_chat(user, span_warning("There is already a [chambered.name] in [src]!"))
			return ITEM_INTERACT_BLOCKING
		if(!rogue_powder)
			to_chat(user, span_warning("I must fill [src] with smokepowder first!"))
			return ITEM_INTERACT_BLOCKING
		. = ..()
		if(chambered)
			playsound(src, ROGUE_FIREARM_SOUND_INSERT, 100)
			user.visible_message(span_notice("[user] forces a [chambered.name] down the barrel of [src]."))
		return
	return ..()

/// Loading time by the Firearms rank (Ratwood load_time - skill * 2).
/obj/item/gun/ballistic/rogue_launcher/firearm/proc/rogue_load_time(mob/living/user)
	return max(rogue_value("firearm_load_time") - user.rogue_skill_rank(rogue_launch_skill) * rogue_value("firearm_load_time_per_skill"), 0)

/obj/item/gun/ballistic/rogue_launcher/firearm/proc/rogue_pour(mob/living/user)
	if(rogue_powder)
		to_chat(user, span_warning("[src] is already filled with smokepowder!"))
		return
	playsound(src, ROGUE_FIREARM_SOUND_POUR, 100)
	if(!do_after(user, rogue_load_time(user), target = src) || rogue_powder)
		return
	rogue_powder = TRUE
	user.visible_message(span_notice("[user] fills [src] with smokepowder."))

/// The ramrod rams the loose ball home, or is stowed under the barrel (Ratwood attackby() with a ramrod).
/obj/item/gun/ballistic/rogue_launcher/firearm/proc/rogue_ram(mob/living/user, obj/item/ramrod/rod)
	if(!rogue_rammed && chambered)
		user.visible_message(span_notice("[user] begins ramming [rod] down the barrel of [src]."))
		playsound(src, ROGUE_FIREARM_SOUND_RAM, 100)
		if(!do_after(user, rogue_load_time(user), target = src) || rogue_rammed || !chambered)
			return
		rogue_rammed = TRUE
		user.visible_message(span_notice("[user] has finished reloading [src]."))
		return
	if(rogue_rod)
		to_chat(user, span_warning("There's already a ramrod in [src]."))
		return
	if(!user.transferItemToLoc(rod, src))
		return
	rogue_rod = rod
	playsound(src, ROGUE_FIREARM_SOUND_STOW, 100)
	user.visible_message(span_notice("[user] stows [rod] under the barrel of [src]."))

/obj/item/gun/ballistic/rogue_launcher/firearm/can_shoot()
	return rogue_rammed && ..()

/obj/item/gun/ballistic/rogue_launcher/firearm/shoot_with_empty_chamber(mob/living/user)
	playsound(src, ROGUE_FIREARM_SOUND_COCK, 100, FALSE)

/obj/item/gun/ballistic/rogue_launcher/firearm/shoot_live_shot(mob/living/user, pointblank = 0, atom/pbtarget = null, message = 1)
	fire_sound = ROGUE_FIREARM_SOUND_FIRE
	return ..()

/// Ratwood get_chargetime() of the firearm intents: the base less the Firearms rank and perception.
/obj/item/gun/ballistic/rogue_launcher/firearm/rogue_draw_time(mob/living/carbon/human/fighter, arcing)
	if(!fighter)
		return 0
	var/time = rogue_value(arcing ? "firearm_arc_aim_base" : "firearm_aim_base")
	time -= fighter.rogue_skill_rank(rogue_launch_skill) * rogue_value("firearm_aim_per_skill")
	time -= fighter.rogue_stat(ROGUE_STAT_PERCEPTION) * rogue_value("firearm_aim_per_perception")
	return max(time, rogue_value("firearm_aim_floor"))

/// The aim taken when the trigger was pulled, if the fuse is the one firing now.
/obj/item/gun/ballistic/rogue_launcher/firearm/rogue_draw_share(mob/living/user)
	if(rogue_fuse_burnt)
		rogue_last_instability = 0
		rogue_last_share = rogue_fuse_share
		return rogue_fuse_share
	. = ..()
	rogue_last_share = .

/// Ratwood: an aim let go early strays by its share of firearm_uncharged_spread; a full aim flies true.
/obj/item/gun/ballistic/rogue_launcher/firearm/rogue_ranged_spread(share)
	if(share < 1)
		return rogue_value("firearm_uncharged_spread") * (1 - share)
	return 0

/// Deciseconds the fuse or flint takes before the shot (Ratwood handgonne, flintgonne fire_delay).
/obj/item/gun/ballistic/rogue_launcher/firearm/proc/rogue_fire_delay()
	if(!rogue_firearm_kind)
		return 0
	var/low = rogue_value_or("firearm_[rogue_firearm_kind]_delay_min", 0)
	var/high = rogue_value_or("firearm_[rogue_firearm_kind]_delay_max", 0)
	return high > 0 ? rand(low, high) : 0

/obj/item/gun/ballistic/rogue_launcher/firearm/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(rogue_fuse_lit && !rogue_fuse_burnt)
		return FALSE
	if(!rogue_fuse_burnt && isliving(user) && can_shoot())
		var/delay = rogue_fire_delay()
		if(delay)
			rogue_fuse_share = rogue_draw_share(user)
			rogue_fuse_lit = TRUE
			playsound(src, rogue_firearm_kind == "handgonne" ? ROGUE_FIREARM_SOUND_FUSE : ROGUE_FIREARM_SOUND_FLINT, 100)
			addtimer(CALLBACK(src, PROC_REF(rogue_fuse_fire), target, user, message, params, zone_override, bonus_spread), delay)
			return TRUE
	rogue_last_share = 1
	var/obj/item/ammo_casing/round = chambered
	var/obj/projectile/shot = round?.loaded_projectile
	. = ..()
	rogue_fuse_burnt = FALSE
	rogue_fuse_lit = FALSE
	if(shot && isliving(user) && (QDELETED(round) || round.loaded_projectile != shot))
		rogue_after_shot(user, rogue_last_share)

/// The fuse has burnt down: the shot goes off where it was aimed.
/obj/item/gun/ballistic/rogue_launcher/firearm/proc/rogue_fuse_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	if(QDELETED(src) || QDELETED(user))
		rogue_fuse_lit = FALSE
		return
	rogue_fuse_burnt = TRUE
	process_fire(target, user, message, params, zone_override, bonus_spread)
	rogue_fuse_burnt = FALSE
	rogue_fuse_lit = FALSE

/// Chance the shot goes wrong for this shooter (Ratwood process_fire(): 50 below the trained ranks, 10 below the safe one;
/// Ratwood's 80 at no rank is overwritten by its own next line).
/obj/item/gun/ballistic/rogue_launcher/firearm/proc/rogue_accident_chance(mob/living/user)
	if(HAS_TRAIT(user, TRAIT_FUSILIER))
		return 0
	var/rank = user.rogue_skill_rank(rogue_launch_skill)
	if(rank >= rogue_value("firearm_accident_safe_rank"))
		return 0
	if(rank >= rogue_value("firearm_accident_trained_rank"))
		return rogue_value("firearm_accident_chance_trained")
	return rogue_value("firearm_accident_chance_untrained")

/// What follows the shot (Ratwood process_fire()): the powder and the ram are spent, smoke, the view shakes, a full aim
/// teaches, an unskilled hand may be burnt or thrown back.
/obj/item/gun/ballistic/rogue_launcher/firearm/proc/rogue_after_shot(mob/living/user, share)
	rogue_powder = FALSE
	rogue_rammed = FALSE
	addtimer(CALLBACK(src, PROC_REF(rogue_smoke_puff), user, 1), 5)
	addtimer(CALLBACK(src, PROC_REF(rogue_smoke_puff), user, 2), 10)
	addtimer(CALLBACK(src, PROC_REF(rogue_smoke_puff), user, 1), 16)
	for(var/mob/living/witness in range(ROGUE_FIREARM_SHAKE_RANGE, user))
		if(witness.stat == STABLE)
			shake_camera(witness, 3, 1)
	if(share >= 1 && user.client && user.mind && user.rogue_learned_rank(rogue_launch_skill) < rogue_trained_cap)
		user.rogue_adjust_experience(rogue_launch_skill, user.rogue_stat(ROGUE_STAT_INTELLIGENCE) * rogue_value("firearm_full_aim_xp_per_int"))
	var/accident = rogue_accident_chance(user)
	if(!accident)
		return
	if(prob(accident))
		user.rogue_drug_flash()
		user.apply_damage(rand(rogue_value("firearm_burn_min"), rogue_value("firearm_burn_max")), BURN, pick(BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		user.visible_message(span_danger("[user] accidentally burnt [user.p_them()]self while firing [src]."))
		INVOKE_ASYNC(user, TYPE_PROC_REF(/mob, emote), "painscream")
		if(prob(rogue_value("firearm_burn_drop_chance")))
			rogue_fumble(user)
	if(prob(accident))
		user.visible_message(span_danger("[user] is knocked back by the recoil!"))
		var/turf/behind = get_ranged_target_turf(user, REVERSE_DIR(user.dir), rand(1, rogue_value("firearm_recoil_distance")))
		user.throw_at(behind, rogue_value("firearm_recoil_distance"), rogue_value("firearm_recoil_speed"))
		if(prob(accident))
			rogue_fumble(user)

/// The weapon falls from the hands and the shooter is floored (Ratwood dropItemToGround, Knockdown, Immobilize).
/obj/item/gun/ballistic/rogue_launcher/firearm/proc/rogue_fumble(mob/living/user)
	user.dropItemToGround(src)
	user.Knockdown(rand(rogue_value("firearm_fumble_knockdown_min"), rogue_value("firearm_fumble_knockdown_max")))
	user.Immobilize(rogue_value("firearm_fumble_immobilize"))

/// A puff of smoke along the shooter's facing at the time (Ratwood spawn_arquebus_smoke()).
/obj/item/gun/ballistic/rogue_launcher/firearm/proc/rogue_smoke_puff(mob/living/user, distance)
	if(QDELETED(user))
		return
	var/turf/spot = get_ranged_target_turf(user, user.dir, distance)
	if(spot)
		new /obj/effect/particle_effect/fluid/smoke/rogue_gunsmoke(spot)

/// Ratwood /obj/effect/particle_effect/smoke/arquebus: a short see-through puff.
/obj/effect/particle_effect/fluid/smoke/rogue_gunsmoke
	opacity = FALSE
	lifetime = 4 SECONDS

/// Ratwood's blunderbuss: grapeshot, a scatter of small balls.
/obj/item/gun/ballistic/rogue_launcher/firearm/blunderbuss
	name = "blunderbuss"
	desc = "A makeshift smokepowder weapon, intended to shoot grapeshot. Such weapons are that of the rabble. Put together from salvaged handgonnes and scrap."
	icon = 'modular_redtard/rockhill/icons/roguetown/weapons/guns32.dmi'
	icon_state = "blunderbuss"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	worn_icon = 'modular_redtard/rockhill/icons/blank_worn.dmi'
	worn_icon_state = null
	wlength = WLENGTH_LONG
	can_parry = TRUE
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/rogue_launcher/grapeshot
	cartridge_wording = "grapeshot"
	possible_item_intents = list(/datum/intent/mace/strike/wood)
	gripped_intents = list(/datum/intent/shoot/firearm, /datum/intent/arc/firearm, /datum/intent/hit)
	smeltresult = /obj/item/ingot/steel

/// Ratwood grapeshot: several pellets that spread.
/obj/item/ammo_casing/caseless/bullet/grapeshot/Initialize(mapload)
	pellets = rogue_value("firearm_grapeshot_pellets")
	variance = rogue_value("firearm_grapeshot_variance")
	return ..()

// Smokepowder projectiles (Ratwood firearm_ammo.dm on_hit()).

/// A struck person goes down unless his constitution beats the roll, else stumbles (Ratwood: 1d12 against CON).
/obj/projectile/bullet/firearm/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	if(pierce_hit || . != BULLET_ACT_HIT || !ishuman(target))
		return
	var/mob/living/carbon/human/victim = target
	if(rand(1, rogue_value("firearm_stagger_roll")) > victim.rogue_stat(ROGUE_STAT_CONSTITUTION))
		INVOKE_ASYNC(victim, TYPE_PROC_REF(/mob, emote), "painscream")
		victim.Knockdown(rand(rogue_value("firearm_stagger_knockdown_min"), rogue_value("firearm_stagger_knockdown_max")))
		victim.Immobilize(rand(rogue_value("firearm_stagger_immobilize_min"), rogue_value("firearm_stagger_immobilize_max")))
		return
	victim.rogue_slowdown(rogue_value(istype(src, /obj/projectile/bullet/firearm/grapeshot) ? "firearm_grapeshot_stumble" : "firearm_stumble"))

/// A lead ball hits an opened guard harder (Ratwood: exposed or vulnerable).
/obj/projectile/bullet/firearm/lead/on_hit(atom/target, blocked = 0, pierce_hit)
	var/mob/living/victim = isliving(target) ? target : null
	if(victim?.rogue_is_open())
		damage *= rogue_value("firearm_lead_open_mult")
	return ..()

/// A silver ball sets the silver-weak alight (Ratwood silver).
/obj/projectile/bullet/firearm/lead/silver/Initialize(mapload)
	rogue_silver_fire_stacks = rogue_value("firearm_silver_fire_stacks")
	return ..()

#undef ROGUE_FIREARM_SOUND_FIRE
#undef ROGUE_FIREARM_SOUND_FUSE
#undef ROGUE_FIREARM_SOUND_FLINT
#undef ROGUE_FIREARM_SOUND_INSERT
#undef ROGUE_FIREARM_SOUND_COCK
#undef ROGUE_FIREARM_SOUND_STOW
#undef ROGUE_FIREARM_SOUND_POUR
#undef ROGUE_FIREARM_SOUND_RAM
#undef ROGUE_FIREARM_SHAKE_RANGE
