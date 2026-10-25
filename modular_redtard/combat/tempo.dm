/datum/status_effect/rogue/tempo
	id = "rogue_tempo"
	var/list/attackers = list()
	var/level = 0

/datum/status_effect/rogue/tempo/on_creation(mob/living/new_owner, set_duration)
	tick_interval = ROGUE_TEMPO_CULL_DELAY
	return ..()

/datum/status_effect/rogue/tempo/on_remove()
	attackers = null
	set_level(0)
	return ..()

/datum/status_effect/rogue/tempo/tick(seconds_between_ticks)
	for(var/key in attackers)
		if(attackers[key] < world.time)
			attackers -= key
	update_level()

/datum/status_effect/rogue/tempo/proc/register(mob/living/attacker)
	var/key = REF(attacker)
	var/count = length(attackers)
	if(count > ROGUE_TEMPO_CAP && !(key in attackers))
		return
	var/memory = ROGUE_TEMPO_MEMORY_MAX
	if(count <= ROGUE_TEMPO_ONE)
		memory = ROGUE_TEMPO_MEMORY_ONE
	else if(count < ROGUE_TEMPO_MAX)
		memory = ROGUE_TEMPO_MEMORY_TWO
	attackers[key] = world.time + memory
	time_until_next_tick = tick_interval
	update_level()

/datum/status_effect/rogue/tempo/proc/update_level()
	var/count = length(attackers)
	if(!count)
		qdel(src)
		return
	var/new_level = 0
	if(count >= ROGUE_TEMPO_MAX)
		new_level = 3
	else if(count >= ROGUE_TEMPO_TWO)
		new_level = 2
	else if(count >= ROGUE_TEMPO_ONE)
		new_level = 1
	if(new_level != level)
		set_level(new_level)

/datum/status_effect/rogue/tempo/proc/set_level(new_level)
	var/old_level = level
	level = new_level
	if(old_level == 3)
		owner.remove_filter(ROGUE_TEMPO_FILTER)
		REMOVE_TRAIT(owner, TRAIT_GRABIMMUNE, ROGUE_TEMPO_SOURCE)
	if(!level)
		owner.clear_alert(ALERT_ROGUE_TEMPO)
		return
	var/atom/movable/screen/alert/rogue_tempo/alert = owner.throw_alert(ALERT_ROGUE_TEMPO, /atom/movable/screen/alert/rogue_tempo, level)
	alert?.show_level(level)
	switch(level)
		if(1)
			owner.adjust_stamina_loss(-owner.max_stamina * ROGUE_TEMPO_STAMINA_ONE)
			to_chat(owner, span_info("Tempo!"))
		if(2)
			owner.adjust_stamina_loss(-owner.max_stamina * ROGUE_TEMPO_STAMINA_TWO)
			to_chat(owner, span_notice("Tempo!!"))
		if(3)
			owner.adjust_stamina_loss(-owner.get_stamina_loss())
			owner.add_filter(ROGUE_TEMPO_FILTER, 2, list("type" = "outline", "color" = "#d3aa25", "alpha" = 80, "size" = 1))
			ADD_TRAIT(owner, TRAIT_GRABIMMUNE, ROGUE_TEMPO_SOURCE)
			owner.playsound_local(owner, 'modular_redtard/rockhill/sound/combat/tempo_max.ogg', 85, TRUE)
			to_chat(owner, span_notice("<b>TEMPO!!!</b>"))

/atom/movable/screen/alert/rogue_tempo
	icon = ROGUE_COMBAT_ALERTS_ICON
	icon_state = "tempo"

/atom/movable/screen/alert/rogue_tempo/proc/show_level(level)
	switch(level)
		if(1)
			name = "Tempo One"
			desc = "Three cowardly foes are attacking me. The need to focus has given me some light boons."
		if(2)
			name = "Tempo Two"
			desc = "Four on one! I am locked in. Greater boons come to me in the heat of battle."
		if(3)
			name = "Full Tempo"
			desc = "FIVE AND MORE! COME AND GET ME! I WILL NOT GO DOWN LIKE A KNAVE!"

/mob/living/proc/rogue_tempo_level()
	var/datum/status_effect/rogue/tempo/tempo = has_status_effect(/datum/status_effect/rogue/tempo)
	return tempo ? tempo.level : 0

/mob/living/proc/rogue_tempo_bonus(name)
	var/level = rogue_tempo_level()
	return level ? rogue_value("tempo_[name]_[level]") : 0

/mob/living/proc/rogue_tempo_factor(name)
	var/level = rogue_tempo_level()
	return level ? rogue_value("tempo_[name]_[level]") : 1

/mob/living/proc/rogue_tempo_reaches(name)
	var/level = rogue_tempo_level()
	return level && level >= rogue_value("tempo_[name]_level")

/mob/living/proc/rogue_tempo_hit(mob/living/attacker)
	if(!HAS_TRAIT(src, TRAIT_TEMPO) || attacker == src || !iscarbon(attacker) || !attacker.mind)
		return
	var/datum/status_effect/rogue/tempo/tempo = has_status_effect(/datum/status_effect/rogue/tempo) || apply_status_effect(/datum/status_effect/rogue/tempo)
	tempo?.register(attacker)

/mob/living/proc/rogue_clear_tempo()
	if(combat_mode)
		return
	var/datum/status_effect/rogue/tempo/tempo = has_status_effect(/datum/status_effect/rogue/tempo)
	if(!tempo)
		return
	var/count = length(tempo.attackers)
	if(count >= ROGUE_TEMPO_ONE)
		to_chat(src, span_info("My muscles relax. My tempo is gone."))
	if(count >= ROGUE_TEMPO_MAX)
		playsound_local(src, 'modular_redtard/rockhill/sound/combat/tempo_loss.ogg', 85, TRUE)
	qdel(tempo)
