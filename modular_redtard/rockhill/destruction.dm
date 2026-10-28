/// Ratwood's breaking of what grows (obj_defense.dm, get_complex_damage() of _onclick/item_attack.dm, rogueflora.dm): which
/// blows hurt it, how much, the sounds of a hit and of the fall, and what it leaves behind. The porter fills the vars below for
/// /obj/structure/flora (rockhill/config.json, limit_vars); a structure without rockhill_dulling keeps TG's damage.
/obj/structure
	/// The blows that hurt it (Ratwood blade_dulling): "cut" - only cutting and chopping ones (trees, bushes, grass), "bash" -
	/// only blunt and smashing ones (stone), "bashchop" - both (wood, Ratwood's default), "pick" - only a pick (rock).
	var/rockhill_dulling
	/// Sounds of a hit (Ratwood attacked_sound) and of breaking (destroy_sound); one of them is picked each time.
	var/list/rockhill_hit_sounds
	var/list/rockhill_break_sounds
	/// What it leaves when it breaks: of each debris type its count give or take one, of each static debris type exactly its
	/// count (Ratwood debris, static_debris).
	var/list/rockhill_debris
	var/list/rockhill_static_debris
	/// Left where it falls, with a crash (Ratwood stump_type and treefall.ogg).
	var/rockhill_stump

/// Ratwood /obj/attacked_by(): the blow's damage by its class against what the structure gives way to, no damage at all from
/// the wrong kind of blow (a club bounces off a tree, a sword shears grass in one cut).
/obj/structure/attacked_by(obj/item/attacking_item, mob/living/user, list/modifiers, list/attack_modifiers)
	if(!rockhill_dulling || !isliving(user))
		return ..()
	var/datum/intent/intent = user.rogue_hand_intent(user.get_held_index_of_item(attacking_item))
	if(intent?.no_attack)
		return 0
	var/damage = rockhill_blow_damage(attacking_item, user, intent)
	if(damage <= 0)
		return 0
	var/verb = length(intent?.attack_verb) ? pick(intent.attack_verb) : "hits"
	user.visible_message(span_danger("[user] [verb] [src] with [attacking_item]!"))
	log_combat(user, src, "attacked", attacking_item)
	if(damage > 1)
		user.adjust_stamina_loss(rogue_value("object_hit_stamina"))
	return take_damage(damage, attacking_item.damtype, MELEE, TRUE, get_dir(src, user), attacking_item.armour_penetration)

/// The damage of one blow (Ratwood get_complex_damage()): the weapon's force by the intent, the wielder's strength and how
/// well the blow's class bites into this; 0 when it does not bite at all.
/obj/structure/proc/rockhill_blow_damage(obj/item/weapon, mob/living/user, datum/intent/intent)
	if(!weapon.force)
		return 0
	var/blade_class = intent?.blade_class || rockhill_sharpness_class(weapon)
	var/factor = 1
	switch(rockhill_dulling)
		if("cut")
			if(blade_class != BCLASS_CUT && blade_class != BCLASS_CHOP)
				return 0
			var/chop = blade_class == BCLASS_CHOP
			if(weapon.rogue_dull(1, user))
				var/rank = user.rogue_skill_rank(/datum/attribute/skill/labor/lumberjacking)
				factor = chop ? rogue_value("flora_chop_factor") + rank * rogue_value("flora_chop_rank_factor") : rogue_value("flora_cut_factor") + rank * rogue_value("flora_cut_rank_factor")
				user.rogue_craft_experience(/datum/attribute/skill/labor/lumberjacking, user.rogue_stat(ROGUE_STAT_INTELLIGENCE) * rogue_value("lumber_hit_xp"))
			else
				factor = rogue_value(chop ? "flora_chop_dull_factor" : "flora_cut_dull_factor")
		if("bash")
			switch(blade_class)
				if(BCLASS_BLUNT)
					factor = 1
				if(BCLASS_SMASH, BCLASS_PICK)
					factor = rogue_value("object_smash_factor")
				else
					return 0
		if("bashchop")
			switch(blade_class)
				if(BCLASS_CUT)
					factor = weapon.rogue_dull(1, user) ? 1 : rogue_value("wood_dull_factor")
				if(BCLASS_CHOP)
					factor = weapon.rogue_dull(1, user) ? rogue_value("wood_chop_factor") : rogue_value("wood_dull_factor")
				if(BCLASS_SMASH)
					factor = rogue_value("object_smash_factor")
				if(BCLASS_BLUNT)
					factor = 1
				if(BCLASS_PICK)
					factor = user.rogue_skill_rank(/datum/attribute/skill/labor/mining) * rogue_value("wood_pick_rank_factor")
				else
					return 0
		if("pick")
			if(blade_class != BCLASS_PICK)
				return 0
			if(user.body_position == LYING_DOWN)
				to_chat(user, span_warning("I need to stand up to get a proper swing."))
				return 0
			factor = rogue_value("rock_pick_factor") + user.rogue_skill_rank(/datum/attribute/skill/labor/mining) * rogue_value("rock_pick_rank_factor")
	var/damage = weapon.force * (intent ? intent.damfactor : 1) * rogue_strength_factor(weapon, user) * factor
	if(user.body_position == LYING_DOWN)
		damage *= rogue_value("object_lying_factor")
	return max(round(damage), 1)

/// The class of a blow from a thing with no intents of its own: by TG's sharpness.
/obj/structure/proc/rockhill_sharpness_class(obj/item/weapon)
	switch(weapon.get_sharpness())
		if(SHARP_EDGED)
			return BCLASS_CUT
		if(SHARP_POINTY)
			return BCLASS_STAB
	return BCLASS_BLUNT

/// Ratwood's hit sound of its own (grass rustles, a trunk thuds) instead of TG's.
/obj/structure/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	if(!length(rockhill_hit_sounds) || damage_type != BRUTE || !damage_amount)
		return ..()
	playsound(src, pick(rockhill_hit_sounds), 100, FALSE, -1)

/// Ratwood obj_destruction() and deconstruct(): the breaking sound, the debris, and a stump where a tree stood. Fire and acid
/// leave nothing, as Ratwood's burn() and acid_melt().
/obj/structure/atom_destruction(damage_flag)
	if(!rockhill_dulling || damage_flag == FIRE || damage_flag == ACID)
		return ..()
	var/turf/here = get_turf(src)
	if(here)
		if(length(rockhill_break_sounds))
			playsound(here, pick(rockhill_break_sounds), 100, TRUE)
		for(var/thing in rockhill_debris)
			for(var/count in 1 to rockhill_debris[thing] + rand(-1, 1))
				new thing(here)
		for(var/thing in rockhill_static_debris)
			for(var/count in 1 to rockhill_static_debris[thing])
				new thing(here)
		if(rockhill_stump)
			new rockhill_stump(here)
			playsound(here, 'modular_redtard/rockhill/sound/misc/treefall.ogg', 100, FALSE)
	return ..()

/// Ratwood's stump: an axe's chopping blow splits it into firewood instead of hurting it, a shovel digs it out.
/obj/structure/flora/roguetree/stump/attacked_by(obj/item/attacking_item, mob/living/user, list/modifiers, list/attack_modifiers)
	if(!isliving(user) || !rogue_combat_enabled())
		return ..()
	var/datum/intent/intent = user.rogue_hand_intent(user.get_held_index_of_item(attacking_item))
	if(intent?.blade_class != BCLASS_CHOP)
		return ..()
	INVOKE_ASYNC(src, PROC_REF(rockhill_chop_lumber), user)
	return 0

/obj/structure/flora/roguetree/stump/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/rogueweapon/shovel) || !rogue_combat_enabled())
		return ..()
	INVOKE_ASYNC(src, PROC_REF(rockhill_dig_out), user)
	return ITEM_INTERACT_SUCCESS

/// How long a stump takes the user: less the better a lumberjack they are (Ratwood 120 - rank × 15 deciseconds).
/obj/structure/flora/roguetree/stump/proc/rockhill_lumber_time(mob/living/user)
	return max(rogue_value("stump_chop_time") - user.rogue_skill_rank(/datum/attribute/skill/labor/lumberjacking) * rogue_value("stump_chop_rank_time"), 0)

/// Ratwood stump attackby() with a chopping blow: a few small logs, more for a better lumberjack, now and then an essence log.
/obj/structure/flora/roguetree/stump/proc/rockhill_chop_lumber(mob/living/user)
	playsound(src, 'modular_redtard/rockhill/sound/misc/woodhit.ogg', 100, TRUE)
	if(!do_after(user, rockhill_lumber_time(user), target = src) || QDELETED(src))
		return
	var/rank = user.rogue_skill_rank(/datum/attribute/skill/labor/lumberjacking)
	var/turf/here = get_turf(src)
	var/blessed = FALSE
	for(var/count in 1 to rand(1, max(1, round(rank / 2))))
		if(prob(rank * rogue_value("stump_essence_rank_chance")))
			new /obj/item/grown/log/tree/small/essence(here)
			blessed = TRUE
		else
			new /obj/item/grown/log/tree/small(here)
	if(blessed)
		to_chat(user, span_warning("Dendor watches over us..."))
	if(!rank)
		to_chat(user, span_info("I could have gotten more timber were I more skilled..."))
	user.rogue_craft_experience(/datum/attribute/skill/labor/lumberjacking, user.rogue_stat(ROGUE_STAT_INTELLIGENCE) * rogue_value("stump_lumber_xp"))
	if(length(rockhill_break_sounds))
		playsound(here, pick(rockhill_break_sounds), 100, TRUE)
	qdel(src)

/// Ratwood stump attackby() with a shovel: dug out whole, as one small log.
/obj/structure/flora/roguetree/stump/proc/rockhill_dig_out(mob/living/user)
	playsound(src, 'modular_redtard/husbandry/sound/dig_shovel.ogg', 80, TRUE)
	if(!do_after(user, rockhill_lumber_time(user) / 2, target = src) || QDELETED(src))
		return
	to_chat(user, span_notice("I dig up [src]."))
	var/turf/here = get_turf(src)
	new /obj/item/grown/log/tree/small(here)
	if(length(rockhill_break_sounds))
		playsound(here, pick(rockhill_break_sounds), 100, TRUE)
	qdel(src)
