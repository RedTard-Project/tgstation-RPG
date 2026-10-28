/// The faith in Rogue Systems: give a person a miracle of the basket (and devotion to cast it, if they have none), take one
/// away, set their devotion, and look over the whole basket with whose each miracle was in the forks. Until the owner hands
/// the miracles out to the patrons, this is how they reach the game.

/proc/rogue_admin_grant_miracle(client/user, mob/living/carbon/human/target)
	if(!rogue_faith_enabled())
		to_chat(user, span_warning("Miracles work on medieval maps only."), confidential = TRUE)
		return
	var/list/choices = list()
	for(var/miracle_type in rogue_miracle_basket())
		choices[rogue_miracle_summary(miracle_type)] = miracle_type
	var/picked = tgui_input_list(user, "Which miracle shall [target] be granted?", "Grant Miracle", choices)
	if(!picked || QDELETED(target))
		return
	var/miracle_type = choices[picked]
	if(locate(miracle_type) in target.actions)
		to_chat(user, span_warning("[target] already has that miracle."), confidential = TRUE)
		return
	var/datum/action/cooldown/spell/miracle = new miracle_type(target.mind || target)
	miracle.Grant(target)
	if(!target.rogue_devotion)
		var/datum/rogue_devotion/devotion = target.rogue_get_devotion()
		devotion.setup()
	log_admin("[key_name(user)] granted the miracle [miracle.name] to [key_name(target)].")
	message_admins("[key_name_admin(user)] granted the miracle [miracle.name] to [key_name_admin(target)].")

/proc/rogue_admin_remove_miracle(client/user, mob/living/carbon/human/target)
	var/list/miracles = list()
	for(var/datum/action/cooldown/spell/pointed/rogue_miracle/miracle in target.actions)
		miracles["[miracle.name] ([miracle.type])"] = miracle
	if(!length(miracles))
		to_chat(user, span_warning("[target] has no miracles."), confidential = TRUE)
		return
	var/picked = tgui_input_list(user, "Which miracle shall [target] lose?", "Remove Miracle", miracles)
	var/datum/action/cooldown/spell/pointed/rogue_miracle/taken = miracles[picked]
	if(!taken || QDELETED(taken))
		return
	log_admin("[key_name(user)] took the miracle [taken.name] from [key_name(target)].")
	message_admins("[key_name_admin(user)] took the miracle [taken.name] from [key_name_admin(target)].")
	qdel(taken)

/proc/rogue_admin_adjust_devotion(client/user, mob/living/carbon/human/target)
	var/datum/rogue_devotion/devotion = target.rogue_devotion
	var/list/options = list("Add devotion", "Set up as a role", "Remove devotion")
	var/what = tgui_input_list(user, devotion ? "[target]'s devotion: [round(devotion.devotion)]/[devotion.max_devotion], tier [devotion.level], regain [devotion.passive_gain]." : "[target] has no devotion.", "Adjust Devotion", options)
	if(!what || QDELETED(target))
		return
	switch(what)
		if("Add devotion")
			var/amount = tgui_input_number(user, "How much devotion to add (negative to take)?", "Adjust Devotion", 50, 1000, -1000)
			if(isnull(amount) || QDELETED(target))
				return
			devotion = target.rogue_get_devotion()
			devotion.adjust(amount, max(amount, 0))
		if("Set up as a role")
			var/tier = tgui_input_number(user, "Starting tier (0-4)?", "Adjust Devotion", 4, ROGUE_MIRACLE_TIER_4, ROGUE_MIRACLE_TIER_0)
			if(isnull(tier))
				return
			var/static/list/regains = list("none", "faith_regen_weak", "faith_regen_devotee", "faith_regen_minor", "faith_regen_major", "faith_regen_witch", "faith_regen_stigmata", "faith_regen_absolver")
			var/regain = tgui_input_list(user, "Passive regain?", "Adjust Devotion", regains)
			if(!regain)
				return
			var/full = tgui_alert(user, "Start full?", "Adjust Devotion", list("Yes", "No")) == "Yes"
			if(QDELETED(target))
				return
			devotion = target.rogue_get_devotion()
			devotion.setup(tier, regain == "none" ? 0 : rogue_value(regain), null, full)
		if("Remove devotion")
			if(!devotion)
				return
			qdel(devotion)
	log_admin("[key_name(user)] adjusted the devotion of [key_name(target)]: [what].")
	message_admins("[key_name_admin(user)] adjusted the devotion of [key_name_admin(target)]: [what].")

/proc/rogue_admin_show_basket(client/user)
	var/list/rows = list("<table><tr><th>Miracle</th><th>Tier</th><th>Devotion</th><th>Symbol</th><th>Forks</th><th>Gods there</th><th>Type</th></tr>")
	for(var/datum/action/cooldown/spell/pointed/rogue_miracle/miracle_type as anything in rogue_miracle_basket())
		rows += "<tr><td>[initial(miracle_type.name)]</td><td>[initial(miracle_type.miracle_tier)]</td><td>[initial(miracle_type.devotion_cost)]</td><td>[initial(miracle_type.needs_holy_symbol) ? "yes" : ""]</td><td>[initial(miracle_type.miracle_forks)]</td><td>[initial(miracle_type.miracle_gods)]</td><td>[miracle_type]</td></tr>"
	rows += "</table>"
	var/datum/browser/popup = new(user.mob, "rogue_miracle_basket", "The Basket of Miracles", 900, 600)
	popup.set_content(jointext(rows, ""))
	popup.open()

ADMIN_VERB_AND_CONTEXT_MENU(rogue_grant_miracle, R_ADMIN, "Grant Miracle", "Give a person a miracle of the basket, and devotion to cast it if they have none.", ADMIN_CATEGORY_ROGUE, /mob/living/carbon/human)
	VERB_ARG_TYPED(target, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /mob/living/carbon/human)
	rogue_admin_grant_miracle(user, target)
	BLACKBOX_LOG_ADMIN_VERB("Grant Miracle")

ADMIN_VERB_AND_CONTEXT_MENU(rogue_remove_miracle, R_ADMIN, "Remove Miracle", "Take a miracle away from a person.", ADMIN_CATEGORY_ROGUE, /mob/living/carbon/human)
	VERB_ARG_TYPED(target, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /mob/living/carbon/human)
	rogue_admin_remove_miracle(user, target)
	BLACKBOX_LOG_ADMIN_VERB("Remove Miracle")

ADMIN_VERB_AND_CONTEXT_MENU(rogue_adjust_devotion, R_ADMIN, "Adjust Devotion", "Give, set up or take away a person's devotion.", ADMIN_CATEGORY_ROGUE, /mob/living/carbon/human)
	VERB_ARG_TYPED(target, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /mob/living/carbon/human)
	rogue_admin_adjust_devotion(user, target)
	BLACKBOX_LOG_ADMIN_VERB("Adjust Devotion")

ADMIN_VERB(rogue_show_miracle_basket, R_ADMIN, "Miracle Basket", "Every miracle ported, with its tier, its devotion and whose it was in Ratwood, Azure Peak and Twilight Axis.", ADMIN_CATEGORY_ROGUE)
	rogue_admin_show_basket(user)
	BLACKBOX_LOG_ADMIN_VERB("Miracle Basket")
