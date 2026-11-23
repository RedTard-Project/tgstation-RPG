/// The injuries of a limb (Vibelin _bodyparts.dm create_injury(), update_injuries(), heal_damage(), bodypart_examine.dm) on a
/// medieval body (TRAIT_ROGUE_WOUNDS, given by the blood element): TG's brute_dam and burn_dam stay the truth, and every
/// change of them passes through set_brute_dam() and set_burn_dam(), so the injuries follow. Damage that grows opens or
/// widens an injury of the kind of the blow (rogue_pending_blow, set by receive_damage() for the time of the hit); damage
/// that falls mends the injuries (any healing: miracles, potions, soups, admin). When an injury changes by itself (it mends,
/// a surgeon opens it), it moves the limb's damage under rogue_injury_sync, and the mirror skips that change. Modern maps and
/// bodies without the trait keep TG's damage alone.

/obj/item/bodypart
	/// The limb's /datum/rogue_injury, oldest first.
	var/list/rogue_injuries
	/// Germs of the limb (Vibelin germ_level, combat/injuries/infection.dm).
	var/rogue_germ_level = 0
	/// The blow being taken, for the time of receive_damage(): list("bclass", "kind", "source").
	var/list/rogue_pending_blow
	/// TRUE while the injuries themselves move the limb's damage: the mirror of set_brute_dam() and set_burn_dam() skips it.
	var/rogue_injury_sync = FALSE

/obj/item/bodypart/Destroy()
	var/list/old_injuries = rogue_injuries
	rogue_injuries = null
	for(var/datum/rogue_injury/injury as anything in old_injuries)
		injury.limb = null
		qdel(injury)
	return ..()

/// The kind of the blow the limb is taking, for the injury its damage opens: TG's damage tells the limb how sharp the blow
/// was and what dealt it, and rogue_wound_blow_class() (combat/wounds.dm) turns that into the module's kind of blow.
/obj/item/bodypart/receive_damage(brute = 0, burn = 0, blocked = 0, updating_health = TRUE, forced = FALSE, required_bodytype = null, wound_bonus = 0, exposed_wound_bonus = 0, sharpness = NONE, attack_direction = null, damage_source, wound_clothing = TRUE)
	if(!owner || !HAS_TRAIT(owner, TRAIT_ROGUE_WOUNDS))
		return ..()
	var/list/outer_blow = rogue_pending_blow
	var/brute_type = WOUND_BLUNT
	if(sharpness & SHARP_EDGED)
		brute_type = WOUND_SLASH
	else if(sharpness & SHARP_POINTY)
		brute_type = WOUND_PIERCE
	var/bclass = rogue_wound_blow_class(brute_type, attack_direction, damage_source)
	rogue_pending_blow = list("bclass" = bclass, "kind" = rogue_injury_kind_for_bclass(bclass), "source" = damage_source)
	. = ..()
	rogue_pending_blow = outer_blow

/obj/item/bodypart/set_brute_dam(new_value)
	var/old_value = brute_dam
	. = ..()
	if(!rogue_injury_sync && brute_dam != old_value)
		rogue_mirror_damage(brute_dam - old_value, FALSE)

/obj/item/bodypart/set_burn_dam(new_value)
	var/old_value = burn_dam
	. = ..()
	if(!rogue_injury_sync && burn_dam != old_value)
		rogue_mirror_damage(burn_dam - old_value, TRUE)

/// The mirror: TG's damage of the limb grew or fell by change; the injuries follow it.
/obj/item/bodypart/proc/rogue_mirror_damage(change, fire)
	if(change > 0)
		if(!owner || !HAS_TRAIT(owner, TRAIT_ROGUE_WOUNDS))
			return
		var/kind = rogue_pending_blow?["kind"] || ROGUE_INJURY_BLUNT
		if(fire)
			kind = (kind & ROGUE_INJURY_FIRE) ? kind : ROGUE_INJURY_BURN
		else if(kind & ROGUE_INJURY_FIRE)
			kind = ROGUE_INJURY_BLUNT
		rogue_add_injury(kind, change, FALSE, rogue_pending_blow)
		return
	if(!length(rogue_injuries))
		return
	if((fire ? burn_dam : brute_dam) <= 0)
		for(var/datum/rogue_injury/injury as anything in rogue_injuries.Copy())
			if(!injury.is_fire() == !fire)
				qdel(injury)
		return
	if(fire)
		rogue_heal_injuries(0, -change)
	else
		rogue_heal_injuries(-change, 0)

/// Mends the injuries by brute and burn damage already taken off the limb (Vibelin heal_damage() over the injuries): the
/// oldest first, divine wounds last (TG's healing has already mended the limb, so they mend too when nothing else is left).
/// It does not touch the limb's damage: that is the mirror's way. To mend a limb, heal_damage() it.
/obj/item/bodypart/proc/rogue_heal_injuries(brute, burn)
	for(var/divine_pass in list(FALSE, TRUE))
		for(var/datum/rogue_injury/injury as anything in rogue_injuries?.Copy())
			if(brute <= 0 && burn <= 0)
				return
			if(!injury.can_heal() != divine_pass)
				continue
			if(injury.is_fire())
				burn = injury.rogue_heal_raw(burn)
			else
				brute = injury.rogue_heal_raw(brute)

/// Opens an injury of the kind by damage the limb takes with it (Vibelin create_injury()): for a cause other than a blow - a
/// surgeon's cut (surgical), a trap, a curse. The limb's TG damage grows by it. Returns the injury, or null.
/obj/item/bodypart/proc/rogue_create_injury(kind, damage, surgical = FALSE)
	if(damage <= 0)
		return null
	if(!surgical)
		damage = min(damage, max_damage - get_damage())
		if(damage <= 0)
			return null
	var/datum/rogue_injury/injury = rogue_add_injury(kind, damage, surgical)
	if(injury)
		rogue_raise_damage(damage, kind & ROGUE_INJURY_FIRE)
	return injury

/// Vibelin create_injury() over damage the limb already took: widens a lone injury of the kind, folds a new one into a like
/// one, or opens a new one of the size the damage picks; then the blow's germs and Azure Peak's armor.
/obj/item/bodypart/proc/rogue_add_injury(kind, damage, surgical = FALSE, list/blow)
	if(damage <= 0)
		return null
	var/datum/rogue_injury_numbers/numbers = rogue_injury_numbers()
	var/datum/rogue_injury/result
	if(!surgical && damage >= numbers.widen_min_damage && length(rogue_injuries))
		var/chance = clamp(numbers.widen_chance + (rogue_injury_count() - 1) * numbers.widen_chance_per_injury, numbers.widen_chance, numbers.widen_chance_max)
		if(prob(chance))
			var/list/candidates = list()
			for(var/datum/rogue_injury/candidate as anything in rogue_injuries)
				if(candidate.can_worsen(kind, damage))
					candidates += candidate
			if(length(candidates))
				result = pick(candidates)
				result.rogue_grow(damage)
	var/fresh = FALSE
	if(!result)
		var/path = rogue_injury_type_for(kind, damage)
		if(!path)
			return null
		var/datum/rogue_injury/injury = new path(damage, surgical)
		if(!surgical)
			for(var/datum/rogue_injury/other as anything in rogue_injuries)
				if(other.can_merge(injury))
					other.merge_injury(injury)
					result = other
					break
		if(!result)
			injury.limb = src
			LAZYADD(rogue_injuries, injury)
			result = injury
			fresh = TRUE
			if(injury.kind == ROGUE_INJURY_INTENSE_BURN)
				rogue_intense_burn_fluid(injury, numbers)
	if(blow)
		rogue_blow_on_injury(result, blow, fresh, damage, numbers)
	return result

/// Vibelin get_injury_type(): the type of the kind the damage reaches, of flesh or of a prosthesis.
/obj/item/bodypart/proc/rogue_injury_type_for(kind, damage)
	var/list/steps = rogue_injury_pick_list(kind, !IS_ORGANIC_LIMB(src))
	for(var/path in steps)
		var/threshold = steps[path]
		if(!threshold || damage >= rogue_value(threshold))
			return path
	return null

/// How many injuries the limb has, merged ones counted one by one (Vibelin number_injuries).
/obj/item/bodypart/proc/rogue_injury_count()
	. = 0
	for(var/datum/rogue_injury/injury as anything in rogue_injuries)
		. += injury.amount

/// Vibelin intense_burn apply_to_bodypart(): blistering of a badly burnt limb costs blood.
/obj/item/bodypart/proc/rogue_intense_burn_fluid(datum/rogue_injury/injury, datum/rogue_injury_numbers/numbers)
	if(!owner || max_damage <= 0 || burn_dam / max_damage < numbers.intense_burn_fluid_share)
		return
	owner.adjust_blood_volume(-CEILING(BLOOD_VOLUME_SURVIVE * injury.damage / numbers.intense_burn_fluid_divisor, 1))

/// What a blow does to the injury it opened or grew: the germs of a weapon or of teeth (Vibelin incoming_germ, less for the
/// antibiotics in the body), and Azure Peak's armor - over armor the limb is not exposed under, the injury keeps the share
/// of its bleeding by how far the weapon got through and bleeds at most the ceiling of its kind, told once; on bare skin an
/// injury that grows to an artery's bleeding tears the limb's artery (combat/wounds/arteries.dm).
/obj/item/bodypart/proc/rogue_blow_on_injury(datum/rogue_injury/injury, list/blow, fresh, damage, datum/rogue_injury_numbers/numbers)
	if(QDELETED(injury) || !owner)
		return
	var/bclass = blow["bclass"]
	var/source = blow["source"]
	if(!injury.mechanical && (isitem(source) || bclass == BCLASS_BITE))
		var/germs = numbers.blow_germs - owner.rogue_get_chem_effect(ROGUE_CE_ANTIBIOTIC) * numbers.blow_germs_antibiotic
		if(germs > 0)
			injury.adjust_germ_level(germs)
	var/share = 0
	var/cap = 0
	if(rogue_limb_armor(bclass) && !owner.has_status_effect(/datum/status_effect/rogue/exposed))
		share = rogue_pen_share(rogue_pen_info(source), numbers)
		cap = numbers.armor_caps["[injury.kind]"] || 0
	if(fresh)
		injury.rogue_armor_share = share
		injury.rogue_armor_cap = cap
	else if(!share || !injury.rogue_armor_share)
		injury.rogue_armor_share = 0
		injury.rogue_armor_cap = 0
	else
		injury.rogue_armor_share = max(injury.rogue_armor_share, share)
		injury.rogue_armor_cap = max(injury.rogue_armor_cap, cap)
	var/raw_bleed = injury.rogue_raw_bleed(TRUE)
	if(injury.rogue_armor_share)
		if(injury.rogue_armor_cap && !injury.rogue_armor_told && raw_bleed * injury.rogue_armor_share >= injury.rogue_armor_cap)
			injury.rogue_armor_told = TRUE
			playsound(owner, 'modular_redtard/combat/sound/misc/armored_wound.ogg', 100, TRUE)
			owner.rogue_strike_note(span_crit("The wound tears open from [owner]'s <b>[plaintext_zone]</b>, the armor won't let it go any further!"))
	else if(raw_bleed >= numbers.armor_artery_bleed && !rogue_artery_torn())
		playsound(owner, 'modular_redtard/combat/sound/misc/wound_tear.ogg', 100, TRUE)
		owner.rogue_strike_note(span_crit("The wound gushes open from [owner]'s <b>[plaintext_zone]</b>, nicking an artery!"))
		rogue_add_wound(/datum/wound/rogue/artery, TRUE)
	if(fresh && damage >= numbers.announce_min_damage)
		var/what = injury.get_desc(FALSE)
		if(what)
			owner.rogue_strike_note(span_red("\A [what] opens on [owner]'s [plaintext_zone]!"))

/// The share of its bleeding an injury keeps under armor by how far the blow got through (Azure Peak pen_info 1-2, 3-4,
/// 5-6, 7-8); a blow of no weapon counts as barely through.
/obj/item/bodypart/proc/rogue_pen_share(pen_info, datum/rogue_injury_numbers/numbers)
	switch(pen_info)
		if(3 to 4)
			return numbers.pen_fair
		if(5 to 6)
			return numbers.pen_good
		if(7 to 8)
			return numbers.pen_full
	return numbers.pen_low

/// The best tier of the limb's armor against this kind of blow (Ratwood's run_armor_check() in bodypart_attacked_by()); 0 for
/// none. Moved here from combat/wounds.dm: Azure Peak's armor now lies over the injuries.
/obj/item/bodypart/proc/rogue_limb_armor(bclass)
	var/mob/living/carbon/human/person = owner
	if(!istype(person))
		return 0
	var/armor_type
	switch(bclass)
		if(BCLASS_BLUNT, BCLASS_SMASH, BCLASS_TWIST, BCLASS_PUNCH)
			armor_type = ROGUE_ARMOR_BLUNT
		if(BCLASS_CHOP, BCLASS_CUT, BCLASS_LASHING, BCLASS_PUNISH)
			armor_type = ROGUE_ARMOR_SLASH
		if(BCLASS_PICK, BCLASS_STAB, BCLASS_BITE)
			armor_type = ROGUE_ARMOR_STAB
	return armor_type ? person.rogue_armor_tier(body_zone, armor_type) : 0

/// Ratwood get_pen_info(): how far a held weapon's blow got through the armor of the limb, pen_info_min to pen_info_max:
/// twice the tiers its intent pierces over the armor's (the least when they match), a keen edge and the wielder's balance on
/// top. Null for any other blow, as Ratwood passes it only with a weapon's. Moved here from combat/wounds.dm.
/obj/item/bodypart/proc/rogue_pen_info(obj/item/weapon)
	if(!isitem(weapon))
		return null
	var/mob/living/carbon/human/wielder = weapon.loc
	if(!istype(wielder))
		return null
	var/pen_min = rogue_value("pen_info_min")
	var/datum/intent/intent = wielder.rogue_strike_intent(weapon)
	var/penetration = intent?.penfactor
	if(!penetration)
		return pen_min
	var/mob/living/carbon/human/person = owner
	var/protection = istype(person) ? person.rogue_armor_tier(body_zone, intent.item_d_type) : 0
	. = penetration == protection ? pen_min : (penetration - protection) * 2
	var/balanced = TRUE
	if(weapon.get_sharpness() && weapon.max_blade_int)
		var/edge = weapon.rogue_edge_ratio()
		if(edge > ROGUE_BLADE_DULL_START)
			. += rogue_value("injury_armor_pen_edge_bonus")
		if(edge <= ROGUE_BLADE_DULL_FLOOR)
			balanced = FALSE
	if(balanced)
		var/strength = wielder.rogue_stat(ROGUE_STAT_STRENGTH) - ROGUE_ATTRIBUTE_MIDDLING
		var/balance = strength
		switch(weapon.wbalance)
			if(WBALANCE_HEAVY)
				balance = strength + rogue_value("injury_armor_pen_heavy_bonus")
			if(WBALANCE_SWIFT)
				balance = max(wielder.rogue_stat(ROGUE_STAT_SPEED) - ROGUE_ATTRIBUTE_MIDDLING, strength)
		if(weapon.wbalance != WBALANCE_HEAVY)
			balance = min(balance, rogue_value("injury_armor_pen_balance_cap"))
		. += balance
	return clamp(., pen_min, rogue_value("pen_info_max"))

/// Moves the limb's TG damage by a change the injuries made themselves, past the mirror.
/obj/item/bodypart/proc/rogue_raise_damage(amount, fire, updating_health = TRUE)
	rogue_injury_sync = TRUE
	if(fire)
		set_burn_dam(clamp(burn_dam + amount, 0, max_damage))
	else
		set_brute_dam(clamp(brute_dam + amount, 0, max_damage))
	rogue_injury_sync = FALSE
	if(updating_health)
		rogue_after_damage_change()

/obj/item/bodypart/proc/rogue_lower_damage(amount, fire, updating_health = TRUE)
	rogue_raise_damage(-amount, fire, updating_health)

/// What TG does after a limb's damage changes (heal_damage()): the limb may give out, the body's health and look follow.
/obj/item/bodypart/proc/rogue_after_damage_change()
	if(!owner)
		return
	if(can_be_disabled)
		update_disabled()
	owner.updatehealth()
	if(update_bodypart_damage_state())
		owner.update_damage_overlays()

/// Blood a second the limb's injuries lose (Vibelin get_bleed_rate() over the injuries).
/obj/item/bodypart/proc/rogue_injury_bleed(ignore_bandage = FALSE)
	. = 0
	for(var/datum/rogue_injury/injury as anything in rogue_injuries)
		. += injury.get_bleed_rate(ignore_bandage)

/// Pain of the limb's injuries (Vibelin return_pain() over the injuries).
/obj/item/bodypart/proc/rogue_injury_pain()
	. = 0
	for(var/datum/rogue_injury/injury as anything in rogue_injuries)
		. += injury.return_pain()

/// Sets (or, apply FALSE, clears) a ROGUE_INJ_* flag on every injury of the kinds: a bandage, stitches, salve, a disinfecting soak (which
/// also wipes the germs). Returns how many injuries changed.
/obj/item/bodypart/proc/rogue_flag_injuries(kinds, flag, apply = TRUE)
	. = 0
	for(var/datum/rogue_injury/injury as anything in rogue_injuries)
		if(!(injury.kind & kinds))
			continue
		if(apply)
			if(flag & ROGUE_INJ_DISINFECTED)
				injury.germ_level = 0
			if((injury.injury_flags & flag) == flag)
				continue
			injury.injury_flags |= flag
		else
			if(!(injury.injury_flags & flag))
				continue
			injury.injury_flags &= ~flag
		.++

/// A Life tick of the limb's injuries (Vibelin update_injuries(), called by the blood element's tick, combat/blood.dm): they
/// mend by themselves - by constitution, twice as fast asleep, not while toxins or a failing heart poison the body - then the
/// germs (combat/injuries/infection.dm). A limb with nothing to do is passed over at once (Vibelin consider_processing()).
/// Returns TRUE when the limb's damage changed.
/obj/item/bodypart/proc/rogue_injury_life(seconds_per_tick)
	if(!owner || owner.stat == DEAD)
		return FALSE
	if(!length(rogue_injuries) && rogue_germ_level <= 0 && !rogue_artery_torn())
		return FALSE
	var/datum/rogue_injury_numbers/numbers = rogue_injury_numbers()
	. = FALSE
	if(length(rogue_injuries))
		var/toxins = owner.rogue_get_chem_effect(ROGUE_CE_TOXIN)
		if(owner.rogue_get_chem_effect(ROGUE_CE_ANTITOX) >= numbers.antitox_block)
			toxins = 0
		if(owner.needs_heart())
			var/obj/item/organ/heart = owner.get_organ_slot(ORGAN_SLOT_HEART)
			if(!heart || (heart.organ_flags & ORGAN_FAILING))
				toxins = max(toxins, 1)
		var/constitution = max(owner.rogue_stat(ROGUE_STAT_CONSTITUTION), 1)
		var/asleep = owner.IsSleeping()
		for(var/datum/rogue_injury/injury as anything in rogue_injuries.Copy())
			if(injury.damage <= 0)
				qdel(injury)
				continue
			var/heal = injury.base_autoheal
			if(!toxins && injury.can_autoheal())
				heal += constitution * numbers.heal_per_constitution
				if(asleep)
					heal *= numbers.sleep_heal_factor
			if(heal > 0)
				injury.heal_damage(heal * injury.amount * seconds_per_tick, FALSE)
				. = TRUE
	rogue_infection_life(seconds_per_tick, numbers)
	if(.)
		rogue_after_damage_change()

/// Vibelin get_injuries_desc() and the infection of the limb (check_for_injuries()): a line for each kind of injury, counted
/// ("pair of", "several", "ton of") and told as bleeding, treated, inflamed; then the limb's infection.
/obj/item/bodypart/proc/rogue_injury_examine(mob/user)
	var/list/lines = list()
	var/datum/rogue_injury_numbers/numbers = rogue_injury_numbers()
	var/list/counted = list()
	for(var/datum/rogue_injury/injury as anything in rogue_injuries)
		var/text = injury.get_desc(FALSE)
		if(!text)
			continue
		if(injury.can_autoheal() && injury.current_stage >= length(injury.stage_damage) && injury.damage_per_injury() < numbers.faint_damage)
			text = "<span style='color: [COLOR_PALE_RED_GRAY];'>[text]</span>"
		if(injury.is_bleeding())
			if(rogue_artery_torn())
				text = span_danger("<b><i>blood-gushing</i></b> [text]")
			else if(injury.get_bleed_rate() > numbers.badly_bleeding)
				text = "<b><i>badly bleeding</i></b> [text]"
			else
				text = "<b>bleeding</b> [text]"
		if(injury.is_clamped())
			text = "<span style='color: [COLOR_SILVER];'>clamped</span> [text]"
		if(injury.is_sutured())
			text = "<span style='color: [COLOR_SILVER];'>sutured</span> [text]"
		if(injury.is_bandaged())
			text = "<span style='color: [COLOR_ASSEMBLY_WHITE];'>bandaged</span> [text]"
		if(injury.is_salved())
			text = "[span_green("salved")] [text]"
		if(injury.is_disinfected())
			text = "<span style='color: [COLOR_BLUE_LIGHT];'>disinfected</span> [text]"
		if(injury.germ_level >= numbers.infection_two)
			text = "[span_boldwarning("pus-ridden")] [text]"
		else if(injury.germ_level >= numbers.infection_one)
			text = "[span_warning("inflamed")] [text]"
		counted[text] += injury.amount
	for(var/text in counted)
		switch(counted[text])
			if(2)
				lines += "pair of [text]s"
			if(3 to 5)
				lines += "several [text]s"
			if(6 to INFINITY)
				lines += "ton of [text]s"
			else
				lines += text
	var/infection = rogue_infection_status(numbers)
	if(infection)
		lines += infection
	return lines

/// Checking one's own body (TG check_self_for_injuries()): the limb's injuries and infection under TG's line of the limb.
/obj/item/bodypart/check_for_injuries(mob/living/carbon/human/examiner)
	. = ..()
	if(!length(rogue_injuries) && rogue_germ_level <= 0)
		return
	var/list/lines = rogue_injury_examine(examiner)
	if(length(lines))
		var/to_be = length(lines) == 1 ? "is" : "are"
		. += "<br>\t[span_warning("There [to_be] [english_list(lines)] on it.")]"

/// Examining someone: the injuries of the limbs their clothes do not cover.
/mob/living/carbon/human/examine(mob/user)
	. = ..()
	if(!rogue_combat_enabled())
		return
	var/list/covered = get_covered_body_zones()
	for(var/obj/item/bodypart/limb as anything in bodyparts)
		if(!length(limb.rogue_injuries) || (limb.body_zone in covered))
			continue
		var/list/lines = limb.rogue_injury_examine(user)
		if(length(lines))
			. += span_warning("[p_They()] [p_have()] [english_list(lines)] on [p_their()] [limb.plaintext_zone].")

/// A full heal (TG fully_heal() with HEAL_WOUNDS: revival, an admin, a cure-all) wipes the germs of the limbs too; the
/// injuries go with the damage.
/mob/living/carbon/fully_heal(heal_flags = HEAL_ALL)
	. = ..()
	if(!(heal_flags & HEAL_WOUNDS))
		return
	for(var/obj/item/bodypart/limb as anything in bodyparts)
		limb.rogue_clear_germs()
