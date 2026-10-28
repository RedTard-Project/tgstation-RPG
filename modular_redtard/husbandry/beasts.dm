/// What Ratwood writes in code, not in vars, for single beasts (the porter brings the vars: husbandry/ported/husbandry.dm), and the
/// vars of riding, milking and manure the porter does not bring yet (Ratwood can_saddle, move_to_delay of a mount, the saddle
/// states of update_icon(), milkies, pooptype).

/// Saigas and goats eat weepvines (Ratwood saiga/find_food(), goat/find_food(), goat and goatmale Life()).
/// Saigas and goats are mounts, the saiga doe and the nanny goat with saddle states of their own.
/mob/living/simple_animal/hostile/retaliate/rogue/saiga
	rogue_eats_vines = TRUE
	rogue_can_saddle = TRUE
	rogue_saddle_state = "saddle-f"
	rogue_saddle_front_state = "saddle-f-above"
	rogue_mounted_state = "saiga_mounted"
	rogue_manure_type = /obj/item/natural/poo/horse

/mob/living/simple_animal/hostile/retaliate/rogue/goat
	rogue_eats_vines = TRUE
	rogue_can_saddle = TRUE
	rogue_saddle_state = "saddle-f"
	rogue_saddle_front_state = "saddle-f-above"
	rogue_mounted_state = "goat_mounted"
	rogue_milk_type = /datum/reagent/consumable/milk
	rogue_manure_type = /obj/item/natural/poo/horse

/mob/living/simple_animal/hostile/retaliate/rogue/goatmale
	rogue_eats_vines = TRUE
	rogue_taunt_angers = TRUE
	rogue_can_saddle = TRUE
	rogue_mounted_state = "goatmale_mounted"
	rogue_manure_type = /obj/item/natural/poo/horse

/// Bulls, billy goats, saiga bucks and swine charge whoever taunts them (Ratwood taunted()).
/mob/living/simple_animal/hostile/retaliate/rogue/bull
	rogue_taunt_angers = TRUE
	rogue_manure_type = /obj/item/natural/poo/cow

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck
	rogue_taunt_angers = TRUE
	rogue_saddle_state = "saddle"
	rogue_saddle_front_state = "saddle-above"
	rogue_mounted_state = "buck_mounted"

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled
	rogue_start_saddled = TRUE

/// The deadite saiga is a risen corpse, no mount.
/mob/living/simple_animal/hostile/retaliate/rogue/saiga/undead
	rogue_can_saddle = FALSE
	rogue_manure_type = null

/mob/living/simple_animal/hostile/retaliate/rogue/swine
	rogue_taunt_angers = TRUE
	rogue_manure_type = /obj/item/natural/poo/horse

/// The hog is the slowest mount (Ratwood move_to_delay 10).
/mob/living/simple_animal/hostile/retaliate/rogue/swine/hog
	rogue_can_saddle = TRUE
	rogue_mount_delay = 10
	rogue_mounted_state = "piggie_mounted"

/mob/living/simple_animal/hostile/retaliate/rogue/cow
	rogue_milk_type = /datum/reagent/consumable/milk
	rogue_manure_type = /obj/item/natural/poo/cow

/mob/living/simple_animal/hostile/retaliate/rogue/chicken
	rogue_manure_type = /obj/item/natural/poo/horse

/mob/living/simple_animal/hostile/retaliate/rogue/trufflepig
	rogue_manure_type = /obj/item/natural/poo/horse

/// The beetle carries one rider and drops nothing (Ratwood pooptype = null); its saddle is one state drawn twice.
/mob/living/simple_animal/hostile/retaliate/rogue/beetle
	rogue_can_saddle = TRUE
	rogue_mount_seats = 1
	rogue_saddle_front_state = "saddle"

/mob/living/simple_animal/hostile/retaliate/rogue/beetle/tame/saddled
	rogue_start_saddled = TRUE

/// Goats and the hog seat their riders lower than the saiga (Ratwood goat, goatmale and hog tamed()).
/mob/living/simple_animal/hostile/retaliate/rogue/goat/rogue_rider_offsets(pass_index)
	return rogue_low_rider_offsets(pass_index)

/mob/living/simple_animal/hostile/retaliate/rogue/goatmale/rogue_rider_offsets(pass_index)
	return rogue_low_rider_offsets(pass_index)

/mob/living/simple_animal/hostile/retaliate/rogue/swine/hog/rogue_rider_offsets(pass_index)
	return rogue_low_rider_offsets(pass_index)

/mob/living/basic/rockhill/proc/rogue_low_rider_offsets(pass_index)
	var/static/list/rider = list(TEXT_NORTH = list(0, 6), TEXT_SOUTH = list(0, 6), TEXT_EAST = list(-2, 6), TEXT_WEST = list(2, 6))
	var/static/list/passenger = list(TEXT_NORTH = list(0, -2), TEXT_SOUTH = list(0, 14), TEXT_EAST = list(-10, 6), TEXT_WEST = list(10, 6))
	return pass_index > 1 ? passenger : rider

/// The beetle covers its rider facing away from the viewer (Ratwood beetle tamed(): north above the mob layer).
/mob/living/simple_animal/hostile/retaliate/rogue/beetle/rogue_mount_layers()
	var/static/list/layers = list(
		TEXT_NORTH = list(0, 0, MOB_LAYER + 0.5),
		TEXT_SOUTH = list(0, 0, MOB_BELOW_PIGGYBACK_LAYER),
		TEXT_EAST = list(0, 0, MOB_BELOW_PIGGYBACK_LAYER),
		TEXT_WEST = list(0, 0, MOB_BELOW_PIGGYBACK_LAYER),
	)
	return layers
