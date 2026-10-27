/// What Ratwood writes in code, not in vars, for single beasts (the porter brings the vars: husbandry/ported/husbandry.dm).

/// Saigas and goats eat weepvines (Ratwood saiga/find_food(), goat/find_food(), goat and goatmale Life()).
/mob/living/simple_animal/hostile/retaliate/rogue/saiga
	rogue_eats_vines = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/goat
	rogue_eats_vines = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/goatmale
	rogue_eats_vines = TRUE
	rogue_taunt_angers = TRUE

/// Bulls, billy goats, saiga bucks and swine charge whoever taunts them (Ratwood taunted()).
/mob/living/simple_animal/hostile/retaliate/rogue/bull
	rogue_taunt_angers = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck
	rogue_taunt_angers = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/swine
	rogue_taunt_angers = TRUE
