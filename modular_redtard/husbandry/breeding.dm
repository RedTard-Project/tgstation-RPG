/// Breeding (Ratwood simple_animal.dm make_babies(), rogue/rogueanimals.dm Life()) on TG's breed component and make_babies
/// subtree. A mother (female with Ratwood childtype and animal_species, not young herself) looks for a father every breedcd
/// (5 minutes; the first season starts 5 minutes after she first has food in her): she needs at least 10 food, a conscious male
/// of animal_species that is not a player within 7 tiles, fewer than 3 young of hers about, and fewer than ROGUE_FARM_ANIMAL_CAP
/// livestock on the map. Then she walks up to him (TG's make_babies) and TG's breed component puts one of her childtype, by
/// weight, where she stands. The young grow up (Ratwood adult_growth, 0.5 a Life to 100) through TG's growth_and_differentiation.

/// A mother: female, with young she may have and their father's kind, not young herself.
/mob/living/basic/rockhill/proc/rogue_is_mother()
	return gender == FEMALE && length(rogue_childtype) && rogue_partner_type && !rogue_adult_type

/// A father: a grown beast some mother breeds with (Ratwood animal_species of a mother names him or one of his parents).
/mob/living/basic/rockhill/proc/rogue_is_father()
	if(rogue_adult_type || gender != MALE)
		return FALSE
	var/static/list/fathers
	if(isnull(fathers))
		var/list/kinds = list()
		for(var/mob/living/basic/rockhill/kind as anything in subtypesof(/mob/living/basic/rockhill))
			var/partner = initial(kind.rogue_partner_type)
			if(partner && !initial(kind.rogue_adult_type))
				kinds |= partner
		fathers = typecacheof(kinds)
	return is_type_in_typecache(src, fathers)

/// Ratwood make_babies(): once a season a fed mother with a father in sight and few young about goes to him.
/datum/component/rogue_livestock/proc/try_breed(mob/living/basic/rockhill/mother)
	if(world.time < next_breed_scan || !SSticker.IsRoundInProgress())
		return
	if(rogue_livestock_count() >= CONFIG_GET(number/rogue_farm_animal_cap))
		return
	if(food < ROGUE_BREED_FOOD)
		return
	if(!next_breed_scan)
		next_breed_scan = world.time + mother.rogue_breed_cooldown
		return
	next_breed_scan = world.time + mother.rogue_breed_cooldown
	if(mother.rogue_is_angry())
		return
	var/young = 0
	var/mob/living/father
	for(var/mob/living/other in view(ROGUE_BREED_RANGE, mother))
		if(other.stat != STABLE)
			continue
		if(is_type_in_list(other, mother.rogue_childtype))
			young++
		else if(istype(other, mother.rogue_partner_type) && !other.ckey && other.gender == MALE && HAS_TRAIT(other, TRAIT_MOB_BREEDER))
			father = other
	if(!father || young >= ROGUE_BREED_MAX_YOUNG)
		return
	mother.rogue_seek(BB_BABIES_TARGET, father, ROGUE_BREED_SEEK_TIME)

/// The young is born where the mother stands (TG's breed component); her next season is a breedcd away.
/datum/component/rogue_livestock/proc/on_birth(mob/living/young, mob/living/father)
	var/mob/living/basic/rockhill/mother = parent
	mother.visible_message(span_notice("[mother] gives birth to [young]."))
	next_breed_scan = world.time + mother.rogue_breed_cooldown
