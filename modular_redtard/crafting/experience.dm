#define ROGUE_DREAM_SOUNDS list('modular_redtard/rockhill/sound/misc/levelup1.ogg', 'modular_redtard/rockhill/sound/misc/levelup2.ogg', 'modular_redtard/rockhill/sound/misc/levelup3.ogg')

/// Ratwood cross training (datums/sleep_adv/sleep_adv.dm, cross_training_map), the craft, labour and medicine rows:
/// dream experience banked in one skill also feeds its neighbours at these shares.
GLOBAL_LIST_INIT(rogue_cross_training, list(
	/datum/attribute/skill/craft/crafting = list(/datum/attribute/skill/craft/carpentry = 0.1, /datum/attribute/skill/craft/masonry = 0.1),
	/datum/attribute/skill/craft/weaponsmithing = list(/datum/attribute/skill/craft/armorsmithing = 0.25, /datum/attribute/skill/craft/blacksmithing = 0.25),
	/datum/attribute/skill/craft/armorsmithing = list(/datum/attribute/skill/craft/weaponsmithing = 0.25, /datum/attribute/skill/craft/blacksmithing = 0.25),
	/datum/attribute/skill/craft/blacksmithing = list(/datum/attribute/skill/craft/armorsmithing = 0.25, /datum/attribute/skill/craft/weaponsmithing = 0.25, /datum/attribute/skill/craft/smelting = 0.1),
	/datum/attribute/skill/craft/carpentry = list(/datum/attribute/skill/craft/crafting = 0.25, /datum/attribute/skill/craft/masonry = 0.1),
	/datum/attribute/skill/craft/masonry = list(/datum/attribute/skill/craft/crafting = 0.25, /datum/attribute/skill/craft/carpentry = 0.1),
	/datum/attribute/skill/craft/engineering = list(/datum/attribute/skill/craft/crafting = 0.1),
	/datum/attribute/skill/craft/tanning = list(/datum/attribute/skill/craft/sewing = 0.5, /datum/attribute/skill/labor/butchering = 0.1),
	/datum/attribute/skill/craft/alchemy = list(/datum/attribute/skill/craft/cooking = 0.1),
	/datum/attribute/skill/craft/sewing = list(/datum/attribute/skill/craft/sewing = 0.5, /datum/attribute/skill/misc/medicine = 0.1),
	/datum/attribute/skill/labor/mining = list(/datum/attribute/skill/combat/axes = 0.1, /datum/attribute/skill/combat/maces = 0.1, /datum/attribute/skill/misc/athletics = 0.1),
	/datum/attribute/skill/labor/butchering = list(/datum/attribute/skill/craft/tanning = 0.25, /datum/attribute/skill/misc/medicine = 0.25, /datum/attribute/skill/combat/knives = 0.25),
	/datum/attribute/skill/labor/lumberjacking = list(/datum/attribute/skill/combat/axes = 0.25, /datum/attribute/skill/combat/unarmed = 0.05, /datum/attribute/skill/misc/athletics = 0.1),
	/datum/attribute/skill/misc/medicine = list(/datum/attribute/skill/craft/sewing = 0.25, /datum/attribute/skill/labor/butchering = 0.1),
))

/// Ratwood dream experience a rank takes (code/__DEFINES/sleep_adv.dm SLEEP_EXP_*), indexed by the rank being reached.
GLOBAL_LIST_INIT(rogue_dream_xp_per_rank, list(40, 65, 125, 160, 220, 350))

/// The learned rank of a skill (Ratwood get_skill_level()): raw level without the governing characteristic.
/mob/living/proc/rogue_learned_rank(skill_type)
	return clamp(floor(ROGUE_NULLTOZERO(attributes?.raw_attribute_list[skill_type]) / ROGUE_SKILL_PER_RANK), ROGUE_RANK_NONE, ROGUE_RANK_LEGENDARY)

/// Ratwood add_sleep_experience(): craft experience. Below Apprentice and awake it is learned at once;
/// from Apprentice on it waits in the dream bank (/datum/component/rogue_dreams) until the crafter sleeps.
/mob/living/proc/rogue_craft_experience(skill_type, amount, silent = FALSE)
	if(!mind || !attributes || amount <= 0 || HAS_TRAIT(src, TRAIT_ROGUE_NO_EXPERIENCE))
		return FALSE
	amount *= CONFIG_GET(number/rogue_craft_xp_multiplier)
	if(amount <= 0)
		return FALSE
	if(!CONFIG_GET(flag/rogue_sleep_xp) || (rogue_learned_rank(skill_type) < ROGUE_RANK_APPRENTICE && !ROGUE_IS_DREAMING(src)))
		return rogue_adjust_experience(skill_type, amount, silent)
	var/datum/component/rogue_dreams/dreams = LoadComponent(/datum/component/rogue_dreams)
	return dreams.bank_experience(skill_type, amount, silent)

/// Ratwood's dream cost of a rank (datums/skills/_skill.dm get_dream_cost_for_level()): combat 2 + 1 per rank,
/// smelting 1, medicine 3, the rest 2 + 0.5 per rank; legendary costs one more.
/proc/rogue_dream_cost(skill_type, rank)
	var/base = 2
	var/per_rank = 0.5
	if(ispath(skill_type, /datum/attribute/skill/combat))
		per_rank = 1
	else if(ispath(skill_type, /datum/attribute/skill/craft/smelting))
		base = 1
	else if(ispath(skill_type, /datum/attribute/skill/misc/medicine))
		base = 3
	var/cost = floor(base + per_rank * (rank - 1))
	if(rank >= ROGUE_RANK_LEGENDARY)
		cost += 1
	return max(cost, 1)

/// Port of Ratwood's /datum/sleep_adv on a mob: banked dream experience, dream points and the tiredness that lets them come.
/// Every nightfall makes the sleeper one step more tired (Ratwood advance_sleep_depravation(), three steps at most);
/// every ROGUE_DREAM_CYCLE seconds of sleep while tired is one dream: tiredness falls, dream points come, banked skills rise.
/datum/component/rogue_dreams
	dupe_mode = COMPONENT_DUPE_UNIQUE
	/// Skill path to banked dream experience (Ratwood sleep_exp).
	var/list/sleep_xp = list()
	/// Dream points left to spend (Ratwood sleep_adv_points).
	var/points = 0
	/// Dream dust carried to the next dream (Ratwood retained_dust).
	var/dust = 0
	/// Nights not yet slept off, 0-3 (Ratwood sleepytime tiers).
	var/tiredness = 0
	/// Dreams so far (Ratwood sleep_adv_cycle).
	var/cycle = 0
	var/dream_timer
	COOLDOWN_DECLARE(level_up_cooldown)

/datum/component/rogue_dreams/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/rogue_dreams/RegisterWithParent()
	RegisterSignal(parent, COMSIG_LIVING_STATUS_APPLIED, PROC_REF(on_status_applied))
	RegisterSignal(parent, COMSIG_LIVING_STATUS_REMOVED, PROC_REF(on_status_removed))
	SSrogue_dreams.dreamers += src
	var/mob/living/sleeper = parent
	if(sleeper.IsSleeping())
		start_dreaming()

/datum/component/rogue_dreams/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_LIVING_STATUS_APPLIED, COMSIG_LIVING_STATUS_REMOVED))
	SSrogue_dreams.dreamers -= src
	stop_dreaming()

/datum/component/rogue_dreams/Destroy(force)
	SStgui.close_uis(src)
	return ..()

/datum/component/rogue_dreams/proc/needed_xp(skill_type, ranks)
	var/mob/living/sleeper = parent
	var/rank = sleeper.rogue_learned_rank(skill_type)
	. = 0
	for(var/step in 1 to ranks)
		rank++
		if(rank > ROGUE_RANK_LEGENDARY)
			return INFINITY
		. += GLOB.rogue_dream_xp_per_rank[rank]

/// Ratwood enough_sleep_xp_to_advance().
/datum/component/rogue_dreams/proc/can_advance(skill_type, ranks = 1)
	var/mob/living/sleeper = parent
	if(sleeper.rogue_learned_rank(skill_type) >= ROGUE_RANK_LEGENDARY)
		return FALSE
	return ROGUE_NULLTOZERO(sleep_xp[skill_type]) >= needed_xp(skill_type, ranks)

/// Ratwood adjust_sleep_xp(): the bank holds at most two ranks' worth.
/datum/component/rogue_dreams/proc/adjust_xp(skill_type, amount)
	var/cap = needed_xp(skill_type, 2)
	if(cap == INFINITY)
		cap = needed_xp(skill_type, 1)
	if(cap == INFINITY)
		return
	sleep_xp[skill_type] = clamp(ROGUE_NULLTOZERO(sleep_xp[skill_type]) + amount, 0, cap)

/// The banking half of Ratwood add_sleep_experience(), with cross training and the "better grasp" / "needs rest" notices.
/datum/component/rogue_dreams/proc/bank_experience(skill_type, amount, silent = FALSE)
	var/mob/living/sleeper = parent
	if(sleeper.rogue_learned_rank(skill_type) >= ROGUE_RANK_LEGENDARY)
		return FALSE
	var/one_before = can_advance(skill_type, 1)
	var/two_before = can_advance(skill_type, 2)
	adjust_xp(skill_type, amount)
	var/list/neighbours = GLOB.rogue_cross_training[skill_type]
	for(var/neighbour in neighbours)
		var/share = round(amount * neighbours[neighbour])
		if(share > 0)
			adjust_xp(neighbour, share)
	SStgui.update_uis(src)
	if(silent)
		return TRUE
	var/datum/attribute/skill/skill = GET_ROGUE_ATTRIBUTE(skill_type)
	var/skill_name = LOWER_TEXT(skill.name)
	if(!one_before && can_advance(skill_type, 1))
		to_chat(sleeper, span_nicegreen(pick("I'm getting a better grasp at [skill_name]...", "With some rest, I feel like I can get better at [skill_name]...", "[skill.name] starts making more sense to me...")))
		level_up_sound()
	if(!two_before && can_advance(skill_type, 2))
		to_chat(sleeper, span_nicegreen("My [skill_name] can no longer improve without some rest and meditation..."))
		level_up_sound()
	return TRUE

/datum/component/rogue_dreams/proc/level_up_sound()
	if(!COOLDOWN_FINISHED(src, level_up_cooldown))
		return
	COOLDOWN_START(src, level_up_cooldown, 0.5 SECONDS)
	var/mob/living/sleeper = parent
	sleeper.playsound_local(get_turf(sleeper), pick(ROGUE_DREAM_SOUNDS), 100, TRUE)

/// Nightfall: Ratwood advance_sleep_depravation() on the "night" time of day.
/datum/component/rogue_dreams/proc/grow_tired()
	tiredness = min(tiredness + 1, 3)

/datum/component/rogue_dreams/proc/on_status_applied(mob/living/source, datum/status_effect/effect)
	SIGNAL_HANDLER
	if(istype(effect, /datum/status_effect/incapacitating/sleeping))
		start_dreaming()

/datum/component/rogue_dreams/proc/on_status_removed(mob/living/source, datum/status_effect/effect)
	SIGNAL_HANDLER
	if(!istype(effect, /datum/status_effect/incapacitating/sleeping))
		return
	stop_dreaming()
	SStgui.close_uis(src)

/datum/component/rogue_dreams/proc/start_dreaming()
	if(dream_timer || !CONFIG_GET(flag/rogue_sleep_xp))
		return
	dream_timer = addtimer(CALLBACK(src, PROC_REF(dream_tick)), CONFIG_GET(number/rogue_dream_cycle) SECONDS, TIMER_STOPPABLE | TIMER_LOOP | TIMER_DELETE_ME)

/datum/component/rogue_dreams/proc/stop_dreaming()
	deltimer(dream_timer)
	dream_timer = null

/// Ratwood human/Life(): asleep, alive and tired - one tiredness step goes and the sleeper dreams.
/datum/component/rogue_dreams/proc/dream_tick()
	var/mob/living/sleeper = parent
	if(!sleeper.IsSleeping())
		stop_dreaming()
		return
	if(sleeper.stat == DEAD || sleeper.health <= 0 || tiredness <= 0 || !sleeper.mind)
		return
	tiredness--
	advance_cycle()

/// Ratwood advance_cycle(): dream dust from intelligence and mood, inspiration, dream points, then the dream window.
/datum/component/rogue_dreams/proc/advance_cycle()
	var/mob/living/sleeper = parent
	cycle++
	to_chat(sleeper, span_notice("My consciousness slips and I start dreaming..."))
	var/intelligence = sleeper.rogue_stat(ROGUE_STAT_INTELLIGENCE)
	var/dream_dust = dust + 100 + intelligence * 25
	if(intelligence < ROGUE_ATTRIBUTE_MIDDLING)
		to_chat(sleeper, span_boldwarning("My shallow imagination makes them dull..."))
	else if(intelligence > ROGUE_ATTRIBUTE_MIDDLING)
		to_chat(sleeper, span_notice("My creative thinking enhances them..."))
	var/inspirations = 1
	var/mood = sleeper.mob_mood?.mood_level
	if(mood >= MOOD_LEVEL_HAPPY2)
		to_chat(sleeper, span_notice("With no stresses throughout the day I dream vividly..."))
		dream_dust += 100
		inspirations++
	else if(mood && mood <= MOOD_LEVEL_SAD2)
		to_chat(sleeper, span_boldwarning("Bothered by the stresses of the day my dreams are short..."))
		dream_dust -= 100
	grant_inspiration(inspirations)
	points += floor(dream_dust / 100) + 1
	dust = max(dream_dust % 100, 0)
	ui_interact(sleeper)

/// Ratwood grant_inspiration_xp(): untrained skills below Apprentice get a rank's worth of dream experience.
/datum/component/rogue_dreams/proc/grant_inspiration(count)
	var/mob/living/sleeper = parent
	var/list/viable = list()
	for(var/skill_type in GLOB.rogue_skills)
		if(ispath(skill_type, /datum/attribute/skill/magic) || can_advance(skill_type, 1))
			continue
		var/rank = sleeper.rogue_learned_rank(skill_type)
		if(rank >= ROGUE_RANK_APPRENTICE || ROGUE_NULLTOZERO(sleep_xp[skill_type]) >= needed_xp(skill_type, ROGUE_RANK_APPRENTICE - rank))
			continue
		viable += skill_type
	var/list/names = list()
	for(var/i in 1 to count)
		if(!length(viable))
			break
		var/skill_type = pick_n_take(viable)
		bank_experience(skill_type, needed_xp(skill_type, 1), TRUE)
		var/datum/attribute/skill/skill = GET_ROGUE_ATTRIBUTE(skill_type)
		names += LOWER_TEXT(skill.name)
	if(length(names))
		to_chat(sleeper, span_notice("I feel inspired about [english_list(names)]..."))

/// Ratwood buy_skill(): a rank for dream points and the banked experience, with the skill's dream.
/datum/component/rogue_dreams/proc/buy_rank(skill_type)
	var/mob/living/sleeper = parent
	var/next_rank = sleeper.rogue_learned_rank(skill_type) + 1
	var/cost = rogue_dream_cost(skill_type, next_rank)
	if(points < cost || !can_advance(skill_type, 1))
		return FALSE
	var/datum/attribute/skill/skill = GET_ROGUE_ATTRIBUTE(skill_type)
	if(length(skill.dreams))
		to_chat(sleeper, span_notice(pick(skill.dreams)))
	points -= cost
	adjust_xp(skill_type, -needed_xp(skill_type, 1))
	var/level = ROGUE_NULLTOZERO(sleeper.attributes.raw_attribute_list[skill_type])
	sleeper.attributes.set_skill_level(skill_type, min(level + ROGUE_SKILL_PER_RANK, ROGUE_SKILL_MAX), silent = FALSE)
	return TRUE

/datum/component/rogue_dreams/ui_state(mob/user)
	return GLOB.always_state

/datum/component/rogue_dreams/ui_status(mob/user, datum/ui_state/state)
	if(user != parent)
		return UI_CLOSE
	return ..()

/datum/component/rogue_dreams/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RogueDreams")
		ui.open()

/datum/component/rogue_dreams/ui_data(mob/user)
	var/mob/living/sleeper = parent
	var/list/skills = list()
	for(var/skill_type in GLOB.rogue_skills)
		if(!can_advance(skill_type, 1))
			continue
		var/datum/attribute/skill/skill = GLOB.rogue_skills[skill_type]
		var/next_rank = sleeper.rogue_learned_rank(skill_type) + 1
		var/cost = rogue_dream_cost(skill_type, next_rank)
		skills += list(list(
			"type" = "[skill_type]",
			"name" = skill.name,
			"next" = skill.description_from_level(next_rank * ROGUE_SKILL_PER_RANK),
			"cost" = cost,
			"affordable" = points >= cost,
		))
	return list(
		"cycle" = cycle,
		"points" = points,
		"asleep" = sleeper.IsSleeping(),
		"skills" = skills,
	)

/datum/component/rogue_dreams/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/living/sleeper = parent
	if(ui.user != sleeper || !sleeper.IsSleeping())
		ui.close()
		return TRUE
	switch(action)
		if("buy")
			var/skill_type = text2path(params["type"])
			if(skill_type in GLOB.rogue_skills)
				buy_rank(skill_type)
			return TRUE
		if("continue")
			to_chat(sleeper, span_notice("...and that's all I dreamt of."))
			ui.close()
			return TRUE

/// Lets the dreams of every sleeper on the medieval map wait for nightfall (Ratwood update_tod() "night").
SUBSYSTEM_DEF(rogue_dreams)
	name = "Rogue Dreams"
	ss_flags = SS_NO_FIRE
	/// Every dream bank in the world.
	var/list/datum/component/rogue_dreams/dreamers = list()

/datum/controller/subsystem/rogue_dreams/Initialize()
	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN, PROC_REF(on_job_after_spawn))
	RegisterSignal(SSdcs, COMSIG_GLOB_ROCKHILL_TIME_OF_DAY, PROC_REF(on_time_of_day))
	return SS_INIT_SUCCESS

/datum/controller/subsystem/rogue_dreams/proc/on_job_after_spawn(datum/source, datum/job/job, mob/living/spawned, client/player_client)
	SIGNAL_HANDLER
	if(ishuman(spawned) && rogue_combat_enabled() && CONFIG_GET(flag/rogue_sleep_xp))
		spawned.AddComponent(/datum/component/rogue_dreams)

/datum/controller/subsystem/rogue_dreams/proc/on_time_of_day(datum/source, datum/rockhill_clock_step/phase/old_phase, datum/rockhill_clock_step/phase/new_phase)
	SIGNAL_HANDLER
	if(new_phase?.name != ROCKHILL_NIGHT)
		return
	for(var/datum/component/rogue_dreams/dreams as anything in dreamers)
		dreams.grow_tired()

#undef ROGUE_DREAM_SOUNDS
