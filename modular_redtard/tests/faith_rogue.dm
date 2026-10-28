#ifdef UNIT_TESTS
/// Every miracle of the basket (faith/miracle.dm) has its button, a tier the Miracles skill can reach and whose it was
/// written down; every devout role of faith/devotion.dm is an outfit with numbers the registry knows.
/datum/unit_test/rogue_miracle_basket

/datum/unit_test/rogue_miracle_basket/Run()
	var/list/basket = rogue_miracle_basket()
	if(!length(basket))
		Fail("The basket of miracles is empty.", __FILE__, __LINE__)
	for(var/datum/action/cooldown/spell/pointed/rogue_miracle/miracle_type as anything in basket)
		var/icon_file = initial(miracle_type.button_icon)
		var/state = initial(miracle_type.button_icon_state)
		if(!icon_exists(icon_file, state))
			Fail("[miracle_type] has no button icon state \"[state]\" in [icon_file].", __FILE__, __LINE__)
		var/tier = initial(miracle_type.miracle_tier)
		if(tier < ROGUE_MIRACLE_TIER_0 || tier > ROGUE_MIRACLE_TIER_4)
			Fail("[miracle_type] has tier [tier], out of 0-4.", __FILE__, __LINE__)
		if(!length(initial(miracle_type.miracle_forks)) || !length(initial(miracle_type.miracle_gods)))
			Fail("[miracle_type] does not say which forks and gods it came from.", __FILE__, __LINE__)
	for(var/outfit_type in GLOB.rogue_role_devotion)
		var/list/entry = GLOB.rogue_role_devotion[outfit_type]
		if(!ispath(outfit_type, /datum/outfit))
			Fail("[outfit_type] in rogue_role_devotion is not an outfit.", __FILE__, __LINE__)
		if(isnull(rogue_value_or(entry[2], null)) || (entry[3] && isnull(rogue_value_or(entry[3], null))))
			Fail("[outfit_type] in rogue_role_devotion names a value the registry does not have.", __FILE__, __LINE__)
#endif
