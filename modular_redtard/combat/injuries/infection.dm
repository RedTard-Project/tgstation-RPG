/// Vibelin's germs and infection (_bodyparts.dm update_germs(), handle_germ_sync(), handle_germ_effects(),
/// handle_antibiotics(); _injury.dm infection_check()) on the module's limbs. An open injury on dirty ground (earth, grass,
/// mud, filth on the floor) gathers germs up to the dirt's; an infected injury passes them to its limb. A limb's germs the body
/// fights off while they are few and its artery holds; past the first level the limb is inflamed and runs a fever, past the
/// second it festers, and at the third a living body's limb takes gangrene: it rots (burial/corpse_rot.dm). A torn artery
/// starves the limb into dry gangrene. Antibiotics (the chemical effect, combat/chem_effects.dm) stop and cure it. The rot of
/// a corpse and of the risen stays Azure Peak's (burial/): germs only work on a living body.

/// Ground that soils a wound: earth, grass, hay, mud, the bottom of a swamp, TG's natural ground.
GLOBAL_LIST_INIT(rogue_dirty_ground, typecacheof(list(
	/turf/open/floor/rogue/dirt,
	/turf/open/floor/rogue/grass,
	/turf/open/floor/rogue/grasscold,
	/turf/open/floor/rogue/grassgrey,
	/turf/open/floor/rogue/grasspurple,
	/turf/open/floor/rogue/grassred,
	/turf/open/floor/rogue/grassyel,
	/turf/open/floor/rogue/hay,
	/turf/open/water/swamp,
	/turf/open/water/river/muddy,
	/turf/open/misc,
)))

/// Filth on a floor that soils a wound.
GLOBAL_LIST_INIT(rogue_dirty_filth, typecacheof(list(
	/obj/effect/decal/cleanable/dirt,
	/obj/effect/decal/cleanable/vomit,
)))

/// Vibelin infection_check(): whether an open injury takes germs this tick - big enough, not treated while small, not
/// disinfected, not of a prosthesis, a bruise only while it bleeds; by a chance of its kind per point of damage.
/datum/rogue_injury/proc/infection_check(seconds_per_tick, datum/rogue_injury_numbers/numbers)
	if(mechanical)
		return FALSE
	var/per_injury = damage_per_injury()
	if(per_injury < numbers.infection_min_damage)
		return FALSE
	if(is_treated() && per_injury < numbers.infection_treated_max)
		return FALSE
	if(is_disinfected())
		return FALSE
	if((kind & ROGUE_INJURY_BLUNT) && !is_bleeding())
		return FALSE
	return rogue_infection_roll(per_injury, seconds_per_tick, numbers)

/datum/rogue_injury/proc/rogue_infection_roll(per_injury, seconds_per_tick, datum/rogue_injury_numbers/numbers)
	var/chance = numbers.infection_chances["[kind]"]
	if(!chance)
		return FALSE
	return SPT_PROB(per_injury * chance, seconds_per_tick)

/// Vibelin burn infection_check(): a burn takes no germs once treated, nor while small.
/datum/rogue_injury/burn/infection_check(seconds_per_tick, datum/rogue_injury_numbers/numbers)
	var/per_injury = damage_per_injury()
	if(mechanical || is_treated() || per_injury < numbers.infection_treated_max || is_disinfected())
		return FALSE
	return rogue_infection_roll(per_injury, seconds_per_tick, numbers)

/// Vibelin intense_burn infection_check(): not while small and treated.
/datum/rogue_injury/intense_burn/infection_check(seconds_per_tick, datum/rogue_injury_numbers/numbers)
	var/per_injury = damage_per_injury()
	if(mechanical || (is_treated() && per_injury < numbers.infection_treated_max) || is_disinfected())
		return FALSE
	return rogue_infection_roll(per_injury, seconds_per_tick, numbers)

/// Vibelin internal_bruise: under the skin, it takes no germs and is not seen.
/datum/rogue_injury/internal_bruise/infection_check(seconds_per_tick, datum/rogue_injury_numbers/numbers)
	return FALSE

/datum/rogue_injury/internal_bruise/get_desc(count = TRUE)
	return null

/// Germs of the ground the body is on: dirty ground or filth on it, else clean.
/obj/item/bodypart/proc/rogue_ground_germs(datum/rogue_injury_numbers/numbers)
	var/turf/ground = get_turf(owner)
	if(!isopenturf(ground))
		return numbers.env_clean
	if(is_type_in_typecache(ground, GLOB.rogue_dirty_ground))
		return numbers.env_dirty
	for(var/obj/effect/decal/cleanable/filth in ground)
		if(is_type_in_typecache(filth, GLOB.rogue_dirty_filth))
			return numbers.env_dirty
	return numbers.env_clean

/// Adds germs to the limb (Vibelin adjust_germ_level()); the third level on a living body is gangrene.
/obj/item/bodypart/proc/rogue_adjust_germs(amount)
	var/datum/rogue_injury_numbers/numbers = rogue_injury_numbers()
	rogue_germ_level = clamp(rogue_germ_level + amount, 0, numbers.infection_three)
	if(rogue_germ_level >= numbers.infection_three)
		rogue_gangrene()

/// No germs left in the limb or its injuries: a cure of the rot, a full heal.
/obj/item/bodypart/proc/rogue_clear_germs()
	rogue_germ_level = 0
	for(var/datum/rogue_injury/injury as anything in rogue_injuries)
		injury.germ_level = 0

/// Vibelin kill_limb() from germs: the living flesh of the limb rots (burial/corpse_rot.dm) and gives out.
/obj/item/bodypart/proc/rogue_gangrene()
	if(!owner || owner.stat == DEAD || rogue_rotted || !rogue_rottable())
		return FALSE
	if(!rogue_rot_flesh())
		return FALSE
	to_chat(owner, span_userdanger("I can't feel my [plaintext_zone] anymore..."))
	owner.update_body_parts()
	return TRUE

/// A Life tick of the limb's germs (Vibelin update_germs()), on a living body's limb of flesh above the cold that stops them.
/obj/item/bodypart/proc/rogue_infection_life(seconds_per_tick, datum/rogue_injury_numbers/numbers)
	if(!IS_ORGANIC_LIMB(src) || !owner || owner.stat == DEAD)
		return
	if(owner.bodytemperature <= numbers.cold_stop)
		return
	var/antibiotics = owner.rogue_get_chem_effect(ROGUE_CE_ANTIBIOTIC)
	rogue_germ_sync(seconds_per_tick, numbers, antibiotics)
	rogue_germ_effects(seconds_per_tick, numbers, antibiotics)
	rogue_germ_antibiotics(seconds_per_tick, numbers, antibiotics)

/// Vibelin handle_germ_sync(): open injuries take germs from dirty ground, up to its germs; then, without enough antibiotics,
/// the limb takes germs from one infected injury a tick.
/obj/item/bodypart/proc/rogue_germ_sync(seconds_per_tick, datum/rogue_injury_numbers/numbers, antibiotics)
	if(!length(rogue_injuries))
		return
	// The ground is looked at only once an injury would take its germs (review VR2r, finding 10: the walk over the turf was
	// made for every hurt part every tick); the roll and the comparison are independent, so the odds are the same.
	var/ground
	for(var/datum/rogue_injury/injury as anything in rogue_injuries)
		if(!injury.infection_check(seconds_per_tick, numbers))
			continue
		if(isnull(ground))
			ground = rogue_ground_germs(numbers)
		if(injury.germ_level < ground)
			injury.adjust_germ_level(min(injury.infection_rate * seconds_per_tick, ground - injury.germ_level))
	if(antibiotics >= numbers.spread_antibiotic_stop)
		return
	for(var/datum/rogue_injury/injury as anything in rogue_injuries)
		if(injury.germ_level <= 0)
			continue
		var/chance = CEILING(min(injury.germ_level / numbers.spread_divisor, numbers.spread_max) * numbers.spread_share, 1)
		if(injury.germ_level > rogue_germ_level || SPT_PROB(chance, seconds_per_tick))
			rogue_adjust_germs(injury.infection_rate * seconds_per_tick)
			return

/// Vibelin handle_germ_effects(): a few germs the body fights off while the artery holds, a torn artery starves the limb
/// (dry gangrene); an infection grows by itself without antibiotics, warms and swells the limb, runs a fever and festers.
/obj/item/bodypart/proc/rogue_germ_effects(seconds_per_tick, datum/rogue_injury_numbers/numbers, antibiotics)
	if(!rogue_artery_torn())
		if(rogue_germ_level <= 0)
			return
		if(rogue_germ_level < numbers.infection_one / 2 && SPT_PROB(numbers.immunity_chance, seconds_per_tick))
			rogue_adjust_germs(-numbers.immunity_cleanse * seconds_per_tick)
			return
	else
		rogue_adjust_germs(numbers.dry_gangrene * seconds_per_tick)
	if(rogue_germ_level < numbers.infection_one / 2)
		return
	if(rogue_germ_level <= numbers.infection_one && SPT_PROB(numbers.warning_chance, seconds_per_tick))
		owner.rogue_custom_pain("My [plaintext_zone] feels a bit warm and swollen...", numbers.warning_pain, FALSE, src)
	if(antibiotics < numbers.growth_antibiotic_stop && SPT_PROB(FLOOR(rogue_germ_level / numbers.growth_chance_divisor, 1), seconds_per_tick))
		rogue_adjust_germs(numbers.growth_rate * seconds_per_tick)
	if(rogue_germ_level >= numbers.infection_one && antibiotics < numbers.fever_antibiotic_stop)
		if(rogue_germ_level <= numbers.infection_two && SPT_PROB(numbers.fever_chance, seconds_per_tick))
			owner.rogue_custom_pain("My [plaintext_zone] feels hotter than normal...", numbers.fever_pain, FALSE, src)
		var/fever = (BODYTEMP_HEAT_DAMAGE_LIMIT - BODYTEMP_NORMAL - numbers.fever_margin) * min(rogue_germ_level / max(numbers.infection_two, 1), 1) + BODYTEMP_NORMAL
		if(owner.bodytemperature < fever)
			owner.adjust_bodytemperature(fever - owner.bodytemperature)
	if(rogue_germ_level >= numbers.infection_two && antibiotics < numbers.pus_antibiotic_stop && SPT_PROB(numbers.pus_chance, seconds_per_tick))
		owner.rogue_custom_pain("My [plaintext_zone] starts leaking some pus...", numbers.pus_pain, FALSE, src)

/// Vibelin handle_antibiotics(): enough antibiotics cure a limb not yet inflamed with a working artery at once; else they kill
/// germs by their strength, more while lying down.
/obj/item/bodypart/proc/rogue_germ_antibiotics(seconds_per_tick, datum/rogue_injury_numbers/numbers, antibiotics)
	if(rogue_germ_level <= 0 || antibiotics <= 0)
		return
	if(rogue_germ_level < numbers.infection_one && antibiotics >= numbers.antibiotic_cure)
		if(!rogue_artery_torn())
			rogue_germ_level = 0
		return
	rogue_adjust_germs(-antibiotics * numbers.antibiotic_rate * seconds_per_tick)
	if(owner.body_position == LYING_DOWN)
		rogue_adjust_germs(-numbers.lying_cleanse * seconds_per_tick)

/// Vibelin's infection of the limb at examine (get_injury_status()): light, medium, serious, acute, septic; necrosis once rotted.
/obj/item/bodypart/proc/rogue_infection_status(datum/rogue_injury_numbers/numbers)
	if(rogue_rotted)
		return null
	var/one = numbers.infection_one
	var/two = numbers.infection_two
	var/three = numbers.infection_three
	var/germs = rogue_germ_level
	if(germs < one)
		return null
	if(germs >= three)
		return span_boldwarning("septic flesh")
	if(germs >= two)
		var/acute_step = (three - two) / 3
		if(germs >= two + 2 * acute_step)
			return span_boldwarning("an acute infection++")
		if(germs >= two + acute_step)
			return span_boldwarning("an acute infection+")
		return span_boldwarning("an acute infection")
	var/light_step = (two - one) / 3
	if(germs >= one + 2 * light_step)
		return span_warning("a serious infection")
	if(germs >= one + light_step)
		return span_warning("a medium infection")
	return span_warning("a light infection")
