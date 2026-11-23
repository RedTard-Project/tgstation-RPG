/// Vibelin's injuries (code/datums/injury/_injury.dm, Baystation's wound datum) on the medieval bodies of the module: the
/// breakdown of a limb's TG damage into cuts, punctures, bruises, burns, bites, lashes. TG's brute_dam and burn_dam stay the
/// truth; every change of them is mirrored here (combat/injuries/bodypart.dm), so whatever heals a limb heals its injuries.
/// An injury has stages named by Vibelin (worst first, combat/injuries/types.dm), bleeds while its damage per injury is above
/// its threshold and it is not bandaged, sutured or clamped, hurts by its damage, mends by itself while small or treated,
/// gathers germs when open (combat/injuries/infection.dm) and may be widened or merged with like ones. Azure Peak's armor
/// lies over it: an injury opened under armor bleeds a share of its bleeding, at most a ceiling of its kind.
/// Its numbers are injury_* values (injuries.txt), read once a type per revision of the mechanics numbers.

GLOBAL_LIST_EMPTY(rogue_injury_type_numbers)
GLOBAL_VAR_INIT(rogue_injury_type_numbers_revision, -1)
GLOBAL_DATUM(rogue_injury_numbers, /datum/rogue_injury_numbers)

/datum/rogue_injury
	/// What the injury is called at its present stage.
	var/desc = "injury"
	/// Index of its present stage in stage_names, 1 the worst.
	var/current_stage = 0
	/// Damage of all the injuries it stands for.
	var/damage = 0
	/// How many injuries it stands for (merged ones).
	var/amount = 1
	/// One of ROGUE_INJURY_* (combat/_medical_defines.dm).
	var/kind = ROGUE_INJURY_BLUNT
	/// ROGUE_INJ_* treatment flags.
	var/injury_flags = NONE
	/// Germs in the injury (combat/injuries/infection.dm).
	var/germ_level = 0
	/// The limb it is on.
	var/obj/item/bodypart/limb
	/// world.time it was made.
	var/created = 0
	/// Damage per injury of its present stage.
	var/min_damage = 0
	/// Numbers of the type (read_numbers()).
	var/bleed_rate = 0
	var/bleed_threshold = 0
	var/autoheal_cutoff = 0
	var/infection_rate = 0
	var/pain_modifier = 1
	var/base_autoheal = 0
	/// Damage per injury from which each stage begins, worst first.
	var/list/stage_damage
	/// Kind family of the type ("slash"), its own id ("slash_small") and the id of its stages ("slash_small_mech").
	var/rogue_family
	var/rogue_id
	var/rogue_stage_id
	/// Vibelin's stage names, worst first (types.dm).
	var/list/stage_names
	/// An injury of a prosthesis (Vibelin required_status BODYPART_ROBOTIC): it does not bleed, hurt, mend or fester.
	var/mechanical = FALSE
	/// Vibelin bleed_threshold INFINITY: it never bleeds.
	var/rogue_never_bleeds = FALSE
	/// Vibelin can_merge() FALSE (burns, so fluid loss is counted right).
	var/rogue_merges = TRUE
	/// Vibelin can_worsen() FALSE (punctures cannot be widened).
	var/rogue_worsens = TRUE
	/// Azure Peak's armor: the share of its bleeding an injury opened under armor keeps, 0 when it was opened bare.
	var/rogue_armor_share = 0
	/// Azure Peak's armor: the most it bleeds under armor, 0 for none.
	var/rogue_armor_cap = 0
	/// Azure Peak's armor_check() is_armor_maxed: the armor's hold was told.
	var/rogue_armor_told = FALSE

/datum/rogue_injury/New(new_damage, surgical = FALSE)
	. = ..()
	created = world.time
	read_numbers()
	if(surgical)
		injury_flags |= ROGUE_INJ_SURGICAL
		autoheal_cutoff = 0
		bleed_threshold = 0
		stage_names = list("surgical incision")
		stage_damage = list(0)
	if(new_damage)
		damage = new_damage
	init_stage(damage)

/datum/rogue_injury/Destroy()
	if(limb)
		LAZYREMOVE(limb.rogue_injuries, src)
		limb = null
	return ..()

/// The type's numbers (cached per type for a revision of the mechanics numbers): its stages and its fields.
/datum/rogue_injury/proc/read_numbers()
	if(GLOB.rogue_injury_type_numbers_revision != rogue_mechanics_revision())
		GLOB.rogue_injury_type_numbers = list()
		GLOB.rogue_injury_type_numbers_revision = rogue_mechanics_revision()
	var/list/numbers = GLOB.rogue_injury_type_numbers[type]
	if(!numbers)
		var/list/thresholds = list()
		for(var/index in 1 to length(stage_names))
			thresholds += rogue_value("injury_[rogue_stage_id]_stage_[index]")
		numbers = list(
			"stages" = thresholds,
			"bleed_rate" = rogue_field("bleed_rate"),
			"bleed_threshold" = rogue_field("bleed_threshold"),
			"autoheal_cutoff" = rogue_field("autoheal_cutoff"),
			"infection_rate" = rogue_field("infection_rate"),
			"pain_modifier" = rogue_field("pain_modifier"),
			"base_autoheal" = rogue_field("base_autoheal"),
		)
		GLOB.rogue_injury_type_numbers[type] = numbers
	stage_damage = numbers["stages"]
	bleed_rate = numbers["bleed_rate"]
	bleed_threshold = numbers["bleed_threshold"]
	autoheal_cutoff = numbers["autoheal_cutoff"]
	infection_rate = numbers["infection_rate"]
	pain_modifier = numbers["pain_modifier"]
	base_autoheal = numbers["base_autoheal"]

/// A field of the type as Vibelin inherits it: the type's own number, else its family's, else every injury's.
/datum/rogue_injury/proc/rogue_field(field)
	. = rogue_value_or("injury_[rogue_id]_[field]", null)
	if(isnull(.))
		. = rogue_value_or("injury_[rogue_family]_[field]", null)
	if(isnull(.))
		. = rogue_value("injury_[field]")

/// Vibelin init_stage(): the stage its damage per injury has reached.
/datum/rogue_injury/proc/init_stage(initial_damage)
	current_stage = length(stage_damage)
	if(!current_stage)
		return
	while(current_stage > 1 && stage_damage[current_stage - 1] <= initial_damage / amount)
		current_stage--
	update_stage_name()

/datum/rogue_injury/proc/update_stage_name()
	min_damage = stage_damage[current_stage]
	desc = current_stage <= length(stage_names) ? stage_names[current_stage] : initial(desc)

/datum/rogue_injury/proc/damage_per_injury()
	return damage / amount

/// Vibelin get_desc(): the name, in the plural for merged injuries; null for one not seen from outside.
/datum/rogue_injury/proc/get_desc(count = TRUE)
	if(count && amount > 1)
		return "[desc]s"
	return desc

/datum/rogue_injury/proc/is_fire()
	return kind & ROGUE_INJURY_FIRE

/datum/rogue_injury/proc/has_flag(flag)
	return injury_flags & flag

/datum/rogue_injury/proc/is_bandaged()
	return injury_flags & ROGUE_INJ_BANDAGED

/datum/rogue_injury/proc/is_sutured()
	return injury_flags & ROGUE_INJ_SUTURED

/datum/rogue_injury/proc/is_salved()
	return injury_flags & ROGUE_INJ_SALVED

/datum/rogue_injury/proc/is_clamped()
	return injury_flags & ROGUE_INJ_CLAMPED

/datum/rogue_injury/proc/is_surgical()
	return injury_flags & ROGUE_INJ_SURGICAL

/// Vibelin is_disinfected(): wiped clean and with no germs left.
/datum/rogue_injury/proc/is_disinfected()
	return (injury_flags & ROGUE_INJ_DISINFECTED) && germ_level <= 0

/// Vibelin is_treated(): what each kind needs - a cut, puncture, bite or lash a bandage or stitches, a bruise a bandage, a
/// burn salve or a bandage; anything else counts as treated.
/datum/rogue_injury/proc/is_treated()
	if(kind & ROGUE_INJURY_SEWABLE)
		return is_bandaged() || is_sutured()
	if(kind & (ROGUE_INJURY_BLUNT|ROGUE_INJURY_INTERNAL))
		return is_bandaged()
	if(kind & ROGUE_INJURY_FIRE)
		return is_salved() || is_bandaged()
	return TRUE

/// Vibelin can_heal(): a divine wound does not mend by itself or by healing that is not forced.
/datum/rogue_injury/proc/can_heal()
	return !(kind & ROGUE_INJURY_DIVINE)

/// Vibelin can_autoheal(): a living body's injury of flesh, not clamped, nothing stuck in the limb, not inflamed, mends by
/// itself when treated, or small enough (twice as big asleep).
/datum/rogue_injury/proc/can_autoheal()
	var/mob/living/carbon/body = limb?.owner
	if(!body || body.stat == DEAD || mechanical || is_clamped() || !can_heal())
		return FALSE
	if(LAZYLEN(limb.embedded_objects))
		return FALSE
	var/datum/rogue_injury_numbers/numbers = rogue_injury_numbers()
	if(germ_level > numbers.infection_one)
		return FALSE
	if(is_treated())
		return TRUE
	return damage_per_injury() <= autoheal_cutoff * (body.IsSleeping() ? numbers.sleep_cutoff_factor : 1)

/// Vibelin is_bleeding(): above its threshold, on a limb that bleeds, not bandaged (unless ignored), sutured or clamped.
/datum/rogue_injury/proc/is_bleeding(ignore_bandage = FALSE)
	if(mechanical || rogue_never_bleeds || !limb?.can_bleed())
		return FALSE
	if(!ignore_bandage && is_bandaged())
		return FALSE
	if(is_sutured() || is_clamped())
		return FALSE
	return damage_per_injury() > bleed_threshold

/// Its bleeding a second before Azure Peak's armor: Vibelin get_bleed_rate().
/datum/rogue_injury/proc/rogue_raw_bleed(ignore_bandage = FALSE)
	if(!is_bleeding(ignore_bandage))
		return 0
	var/datum/rogue_injury_numbers/numbers = rogue_injury_numbers()
	return max(numbers.bleed_least, bleed_rate * damage / numbers.bleed_damage_ratio)

/// Blood a second it loses: Vibelin get_bleed_rate(), held back by the armor it was opened under (Azure Peak armor_check()).
/datum/rogue_injury/proc/get_bleed_rate(ignore_bandage = FALSE)
	. = rogue_raw_bleed(ignore_bandage)
	if(!. || !rogue_armor_share)
		return
	. *= rogue_armor_share
	if(rogue_armor_cap)
		. = min(., rogue_armor_cap)

/// Vibelin return_pain(): its damage times its pain_modifier and the factor of a blow or a burn.
/datum/rogue_injury/proc/return_pain()
	if(mechanical)
		return 0
	var/datum/rogue_injury_numbers/numbers = rogue_injury_numbers()
	return damage * pain_modifier * (is_fire() ? numbers.pain_burn : numbers.pain_brute)

/datum/rogue_injury/proc/adjust_germ_level(amount)
	germ_level = clamp(germ_level + amount, 0, rogue_injury_numbers().infection_three)

/// Vibelin can_merge(): another injury of the same type, stage and treatment folds into this one.
/datum/rogue_injury/proc/can_merge(datum/rogue_injury/other)
	if(!rogue_merges || !other.rogue_merges)
		return FALSE
	return other.type == type && other.current_stage == current_stage && other.injury_flags == injury_flags

/// Vibelin merge_injury(): takes the other in and deletes it. An injury opened bare stays bare.
/datum/rogue_injury/proc/merge_injury(datum/rogue_injury/other)
	damage += other.damage
	amount += other.amount
	germ_level = max(germ_level, other.germ_level)
	injury_flags |= other.injury_flags
	created = max(created, other.created)
	if(!other.rogue_armor_share || !rogue_armor_share)
		rogue_armor_share = 0
		rogue_armor_cap = 0
	else
		rogue_armor_share = max(rogue_armor_share, other.rogue_armor_share)
		rogue_armor_cap = max(rogue_armor_cap, other.rogue_armor_cap)
	qdel(other)

/// Vibelin can_worsen(): a lone injury of a matching kind takes a blow's damage into itself, up to a share over its worst stage.
/datum/rogue_injury/proc/can_worsen(blow_kind, blow_damage)
	if(!rogue_worsens || !(kind & blow_kind) || amount > 1 || !length(stage_damage))
		return FALSE
	return damage + blow_damage <= rogue_injury_numbers().worsen_cap_factor * stage_damage[1]

/// Grows it by damage already on the limb (Vibelin open_injury() without the limb): the stage follows.
/datum/rogue_injury/proc/rogue_grow(more, retracting = FALSE)
	damage += more
	while(current_stage > 1 && stage_damage[current_stage - 1] < damage_per_injury())
		current_stage--
	if(current_stage)
		update_stage_name()
	if(retracting)
		injury_flags |= ROGUE_INJ_RETRACTED

/// Vibelin open_injury(): opens it wider by damage the limb takes with it (a surgeon's retractor).
/datum/rogue_injury/proc/open_injury(more, retracting = FALSE)
	if(more <= 0)
		return
	var/obj/item/bodypart/part = limb
	rogue_grow(more, retracting)
	part?.rogue_raise_damage(more, is_fire())

/// Vibelin close_injury(): no longer retracted, and mended down to where it stops bleeding.
/datum/rogue_injury/proc/close_injury()
	injury_flags &= ~ROGUE_INJ_RETRACTED
	var/current = damage_per_injury()
	if(current > bleed_threshold)
		heal_damage((current - bleed_threshold) * amount)

/// Mends it by damage already taken off the limb (Vibelin heal_damage() without the limb); the stage follows. Returns what
/// is left of the amount. Can delete the injury.
/datum/rogue_injury/proc/rogue_heal_raw(amount_heal)
	if(amount_heal <= 0)
		return max(amount_heal, 0)
	var/healed = min(damage, amount_heal)
	damage -= healed
	var/stages = length(stage_damage)
	while(current_stage && current_stage < stages && damage_per_injury() < stage_damage[current_stage])
		current_stage++
	if(current_stage)
		update_stage_name()
	if(damage <= 0)
		qdel(src)
	return amount_heal - healed

/// Vibelin heal_damage(): mends it, and its limb's TG damage with it. Returns what is left of the amount. Can delete the injury.
/datum/rogue_injury/proc/heal_damage(amount_heal, updating_health = TRUE)
	var/obj/item/bodypart/part = limb
	var/fire = is_fire()
	. = rogue_heal_raw(amount_heal)
	var/healed = amount_heal - .
	if(healed > 0 && part)
		part.rogue_lower_damage(healed, fire, updating_health)

/// The numbers of the injury model a Life tick and a blow read, kept for a revision of the mechanics numbers.
/datum/rogue_injury_numbers
	var/revision = -1
	var/bleed_damage_ratio
	var/bleed_least
	var/badly_bleeding
	var/pain_brute
	var/pain_burn
	var/widen_min_damage
	var/widen_chance
	var/widen_chance_per_injury
	var/widen_chance_max
	var/worsen_cap_factor
	var/heal_per_constitution
	var/sleep_heal_factor
	var/sleep_cutoff_factor
	var/antitox_block
	var/announce_min_damage
	var/faint_damage
	var/intense_burn_fluid_share
	var/intense_burn_fluid_divisor
	var/armor_artery_bleed
	/// "[kind]" = most bleeding under armor.
	var/list/armor_caps
	var/pen_low
	var/pen_fair
	var/pen_good
	var/pen_full
	var/infection_one
	var/infection_two
	var/infection_three
	var/env_clean
	var/env_dirty
	var/blow_germs
	var/blow_germs_antibiotic
	var/infection_min_damage
	var/infection_treated_max
	/// "[kind]" = percent a second per point of damage.
	var/list/infection_chances
	var/spread_divisor
	var/spread_max
	var/spread_share
	var/spread_antibiotic_stop
	var/immunity_chance
	var/immunity_cleanse
	var/dry_gangrene
	var/growth_antibiotic_stop
	var/growth_chance_divisor
	var/growth_rate
	var/fever_antibiotic_stop
	var/fever_margin
	var/warning_chance
	var/warning_pain
	var/fever_chance
	var/fever_pain
	var/pus_antibiotic_stop
	var/pus_chance
	var/pus_pain
	var/antibiotic_cure
	var/antibiotic_rate
	var/lying_cleanse
	var/cold_stop

/datum/rogue_injury_numbers/proc/read()
	bleed_damage_ratio = max(rogue_value("injury_bleed_damage_ratio"), 1)
	bleed_least = rogue_value("injury_bleed_least")
	badly_bleeding = rogue_value("injury_badly_bleeding")
	pain_brute = rogue_value("injury_pain_brute_factor")
	pain_burn = rogue_value("injury_pain_burn_factor")
	widen_min_damage = rogue_value("injury_widen_min_damage")
	widen_chance = rogue_value("injury_widen_chance")
	widen_chance_per_injury = rogue_value("injury_widen_chance_per_injury")
	widen_chance_max = rogue_value("injury_widen_chance_max")
	worsen_cap_factor = rogue_value("injury_worsen_cap_factor")
	heal_per_constitution = rogue_value("injury_heal_per_constitution")
	sleep_heal_factor = rogue_value("injury_sleep_heal_factor")
	sleep_cutoff_factor = rogue_value("injury_sleep_cutoff_factor")
	antitox_block = rogue_value("injury_antitox_block")
	announce_min_damage = rogue_value("injury_announce_min_damage")
	faint_damage = rogue_value("injury_faint_damage")
	intense_burn_fluid_share = rogue_value("injury_intense_burn_fluid_share")
	intense_burn_fluid_divisor = max(rogue_value("injury_intense_burn_fluid_divisor"), 1)
	armor_artery_bleed = rogue_value("injury_armor_artery_bleed")
	armor_caps = list(
		"[ROGUE_INJURY_SLASH]" = rogue_value("injury_armor_cap_slash"),
		"[ROGUE_INJURY_PUNCTURE]" = rogue_value("injury_armor_cap_puncture"),
		"[ROGUE_INJURY_BITE]" = rogue_value("injury_armor_cap_bite"),
		"[ROGUE_INJURY_LASH]" = rogue_value("injury_armor_cap_lash"),
		"[ROGUE_INJURY_BLUNT]" = rogue_value("injury_armor_cap_blunt"),
	)
	pen_low = rogue_value("injury_armor_pen_low")
	pen_fair = rogue_value("injury_armor_pen_fair")
	pen_good = rogue_value("injury_armor_pen_good")
	pen_full = rogue_value("injury_armor_pen_full")
	infection_one = rogue_value("germ_infection_one")
	infection_two = rogue_value("germ_infection_two")
	infection_three = rogue_value("germ_infection_three")
	env_clean = rogue_value("germ_env_clean")
	env_dirty = rogue_value("germ_env_dirty")
	blow_germs = rogue_value("germ_blow_start")
	blow_germs_antibiotic = rogue_value("germ_blow_antibiotic_factor")
	infection_min_damage = rogue_value("infection_min_damage")
	infection_treated_max = rogue_value("infection_treated_max")
	infection_chances = list(
		"[ROGUE_INJURY_BLUNT]" = rogue_value("infection_chance_blunt"),
		"[ROGUE_INJURY_BURN]" = rogue_value("infection_chance_burn"),
		"[ROGUE_INJURY_INTENSE_BURN]" = rogue_value("infection_chance_burn"),
		"[ROGUE_INJURY_SLASH]" = rogue_value("infection_chance_slash"),
		"[ROGUE_INJURY_PUNCTURE]" = rogue_value("infection_chance_puncture"),
		"[ROGUE_INJURY_LASH]" = rogue_value("infection_chance_lash"),
		"[ROGUE_INJURY_BITE]" = rogue_value("infection_chance_bite"),
	)
	spread_divisor = max(rogue_value("germ_limb_spread_divisor"), 1)
	spread_max = rogue_value("germ_limb_spread_max")
	spread_share = rogue_value("germ_limb_spread_share")
	spread_antibiotic_stop = rogue_value("germ_antibiotic_stop")
	immunity_chance = rogue_value("germ_immunity_chance")
	immunity_cleanse = rogue_value("germ_immunity_cleanse")
	dry_gangrene = rogue_value("germ_dry_gangrene")
	growth_antibiotic_stop = rogue_value("germ_growth_antibiotic_stop")
	growth_chance_divisor = max(rogue_value("germ_growth_chance_divisor"), 1)
	growth_rate = rogue_value("germ_growth_rate")
	fever_antibiotic_stop = rogue_value("germ_fever_antibiotic_stop")
	fever_margin = rogue_value("germ_fever_margin")
	warning_chance = rogue_value("germ_warning_chance")
	warning_pain = rogue_value("germ_warning_pain")
	fever_chance = rogue_value("germ_fever_chance")
	fever_pain = rogue_value("germ_fever_pain")
	pus_antibiotic_stop = rogue_value("germ_pus_antibiotic_stop")
	pus_chance = rogue_value("germ_pus_chance")
	pus_pain = rogue_value("germ_pus_pain")
	antibiotic_cure = rogue_value("germ_antibiotic_cure")
	antibiotic_rate = rogue_value("germ_antibiotic_rate")
	lying_cleanse = rogue_value("germ_lying_cleanse")
	cold_stop = rogue_value("germ_cold_stop")
	revision = rogue_mechanics_revision()

/// The numbers of the injury model, read again when the mechanics numbers change.
/proc/rogue_injury_numbers()
	if(!GLOB.rogue_injury_numbers)
		GLOB.rogue_injury_numbers = new /datum/rogue_injury_numbers
	var/datum/rogue_injury_numbers/numbers = GLOB.rogue_injury_numbers
	if(numbers.revision != rogue_mechanics_revision())
		numbers.read()
	return numbers

/// The injury kind of a kind of blow (Vibelin bodypart_attacked_by()): blows and twists bruise, cuts and chops cut, stabs,
/// picks and arrows puncture, teeth bite, whips lash, charring burns. Anything else bruises.
/proc/rogue_injury_kind_for_bclass(bclass)
	switch(bclass)
		if(BCLASS_CUT, BCLASS_CHOP)
			return ROGUE_INJURY_SLASH
		if(BCLASS_STAB, BCLASS_PICK, BCLASS_PIERCE)
			return ROGUE_INJURY_PUNCTURE
		if(BCLASS_BITE)
			return ROGUE_INJURY_BITE
		if(BCLASS_LASHING, BCLASS_PUNISH)
			return ROGUE_INJURY_LASH
		if(BCLASS_BURN)
			return ROGUE_INJURY_BURN
	return ROGUE_INJURY_BLUNT
