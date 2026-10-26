/mob/living/var/rogue_in_combat_until = 0

/mob/living/proc/rogue_mark_in_combat()
	rogue_in_combat_until = world.time + ROGUE_IN_COMBAT_TIME
	SEND_SIGNAL(src, COMSIG_MOB_ROGUE_DEFENSE_CHANGED)

/mob/living/carbon/human/rogue_mark_in_combat()
	. = ..()
	rogue_reveal_sneak()

/atom/movable/screen/rogue/defdelay
	name = "defense readiness"
	desc = "My readiness in combat. If the light is gone, I cannot dodge or parry. If it is red, I am in combat, and cannot perform certain stealthy actions."
	icon_state = "defdelay0"
	screen_loc = rogueui_defdelay
	layer = ROGUE_ABOVE_HUD_LAYER
	alpha = 230
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/rogue/defdelay/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	var/mob/owner = hud_owner?.mymob
	if(owner)
		RegisterSignal(owner, COMSIG_MOB_ROGUE_DEFENSE_CHANGED, PROC_REF(refresh))
	refresh()

/atom/movable/screen/rogue/defdelay/proc/refresh()
	SIGNAL_HANDLER
	var/mob/living/owner = get_mob()
	if(!isliving(owner))
		return
	var/ready_at = owner.rogue_def_intent == ROGUE_INTENT_DODGE ? owner.rogue_last_dodge + owner.rogue_dodge_cooldown : owner.rogue_last_parry + ROGUE_PARRY_DELAY
	var/next_change = 0
	if(ready_at > world.time)
		icon_state = "defdelay1"
		next_change = ready_at
	else if(owner.rogue_in_combat_until > world.time)
		icon_state = "defdelay0c"
		next_change = owner.rogue_in_combat_until
	else
		icon_state = "defdelay0"
	if(next_change)
		addtimer(CALLBACK(src, PROC_REF(refresh)), next_change - world.time, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_DELETE_ME)

/atom/movable/screen/rogue/defdelay/Click(location, control, params)
	if(usr == get_mob())
		to_chat(usr, span_info(desc))

/mob/living/carbon/human/var/rogue_energy = 0
/mob/living/carbon/human/var/rogue_max_energy = 0

/mob/living/carbon/human/proc/rogue_update_max_energy()
	rogue_max_energy = rogue_formula_value(ROGUE_FORMULA_ENERGY_MAX, list("willpower" = rogue_stat(ROGUE_STAT_WILLPOWER), "athletics" = rogue_skill_rank(/datum/attribute/skill/misc/athletics)))
	rogue_energy = min(rogue_energy, rogue_max_energy)

/mob/living/carbon/human/proc/rogue_energy_add(amount)
	if(!rogue_max_energy || !amount)
		return
	var/old_energy = rogue_energy
	rogue_energy = clamp(rogue_energy + amount, 0, rogue_max_energy)
	if(rogue_energy <= 0 && move_intent == MOVE_INTENT_RUN)
		set_move_intent(MOVE_INTENT_WALK)
		to_chat(src, span_warning("I'm too exhausted to run."))
	if(old_energy != rogue_energy)
		SEND_SIGNAL(src, COMSIG_MOB_ROGUE_ENERGY_CHANGED)

/datum/element/rogue_energy
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

/datum/element/rogue_energy/Attach(datum/target)
	. = ..()
	if(!ishuman(target))
		return ELEMENT_INCOMPATIBLE
	var/mob/living/carbon/human/human = target
	human.rogue_update_max_energy()
	human.rogue_energy = human.rogue_max_energy
	RegisterSignal(target, COMSIG_LIVING_ADJUST_STAMINA_DAMAGE, PROC_REF(on_stamina))
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignal(target, COMSIG_LIVING_LIFE, PROC_REF(on_life))
	RegisterSignal(target, COMSIG_MOVE_INTENT_TOGGLED, PROC_REF(on_move_intent))

/datum/element/rogue_energy/Detach(datum/source)
	UnregisterSignal(source, list(COMSIG_LIVING_ADJUST_STAMINA_DAMAGE, COMSIG_MOVABLE_MOVED, COMSIG_LIVING_LIFE, COMSIG_MOVE_INTENT_TOGGLED))
	return ..()

/datum/element/rogue_energy/proc/on_stamina(mob/living/carbon/human/source, damage_type, amount, forced)
	SIGNAL_HANDLER
	if(amount > 0)
		source.rogue_energy_add(-amount)

/datum/element/rogue_energy/proc/on_moved(mob/living/carbon/human/source, atom/old_loc, movement_dir, forced, list/old_locs)
	SIGNAL_HANDLER
	if(forced || !isturf(source.loc) || source.buckled || source.move_intent != MOVE_INTENT_RUN || source.body_position != STANDING_UP)
		return
	source.rogue_energy_add(-ROGUE_ENERGY_RUN_COST)

/datum/element/rogue_energy/proc/on_move_intent(mob/living/carbon/human/source)
	SIGNAL_HANDLER
	if(source.move_intent == MOVE_INTENT_RUN && source.rogue_energy <= 0 && source.rogue_max_energy)
		source.set_move_intent(MOVE_INTENT_WALK)
		to_chat(source, span_warning("I'm too exhausted to run."))

/datum/element/rogue_energy/proc/on_life(mob/living/carbon/human/source, seconds_per_tick)
	SIGNAL_HANDLER
	if(source.stat == DEAD)
		return
	source.rogue_update_max_energy()
	var/factor = seconds_per_tick / ROGUE_ENERGY_TICK_SECONDS
	var/quality = source.rogue_sleep_quality()
	var/change = 0
	if(source.combat_mode)
		change -= ROGUE_ENERGY_COMBAT_DRAIN
	if(source.IsSleeping())
		change += ROGUE_ENERGY_SLEEP_GAIN * (quality || ROGUE_ENERGY_GROUND_FACTOR)
	else if(quality)
		change += ROGUE_ENERGY_REST_GAIN * quality
	else if(source.body_position == LYING_DOWN)
		change += ROGUE_ENERGY_REST_GAIN
	source.rogue_energy_add(change * factor)

/mob/living/proc/rogue_sleep_quality()
	if(istype(buckled, /obj/structure/bed/rockhill))
		var/obj/structure/bed/rockhill/bed = buckled
		return bed.sleepy
	if(istype(buckled, /obj/structure/chair/wood/rockhill))
		var/obj/structure/chair/wood/rockhill/chair = buckled
		return chair.sleepy
	if(isturf(loc) && body_position == LYING_DOWN)
		var/obj/structure/bed/rockhill/bed = locate() in loc
		if(bed)
			return bed.sleepy
	if(istype(buckled, /obj/structure/bed))
		return ROGUE_ENERGY_BED_FACTOR
	return 0

/atom/movable/screen/rogue/energy
	name = "energy"
	icon = ROGUE_HUD_ICON_HEAT
	icon_state = "energy100"
	screen_loc = rogueui_fat
	layer = ROGUE_HUD_LAYER
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/rogue/energy/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	var/mob/owner = hud_owner?.mymob
	if(owner)
		RegisterSignal(owner, COMSIG_MOB_ROGUE_ENERGY_CHANGED, PROC_REF(refresh))
	refresh()

/atom/movable/screen/rogue/energy/proc/refresh()
	SIGNAL_HANDLER
	var/mob/living/carbon/human/owner = get_mob()
	if(!ishuman(owner) || !owner.rogue_max_energy)
		icon_state = "energy100"
		return
	var/percent = owner.rogue_energy / owner.rogue_max_energy * 100
	icon_state = "energy[clamp(round(percent, ROGUE_ENERGY_HUD_STEP), 0, 100)]"

/atom/movable/screen/rogue/energy/Click(location, control, params)
	var/mob/living/carbon/human/owner = get_mob()
	if(usr != owner || !ishuman(owner))
		return
	to_chat(owner, span_info("<b>Energy:</b> [round(owner.rogue_energy, 0.1)] / [round(owner.rogue_max_energy, 0.1)]"))

/atom/movable/screen/rogue/advsetup
	name = "choose your calling"
	icon = null
	icon_state = ""
	screen_loc = rogueui_advsetup
	layer = ROGUE_HUD_LAYER
	mouse_over_pointer = MOUSE_HAND_POINTER
	var/showing = FALSE

/atom/movable/screen/rogue/advsetup/Click(location, control, params)
	var/mob/living/carbon/human/owner = get_mob()
	if(usr != owner || !ishuman(owner))
		return
	SEND_SIGNAL(owner, COMSIG_MOB_ROGUE_ADVSETUP_CLICKED)

/atom/movable/screen/rogue/advsetup/proc/show_setup()
	showing = TRUE
	icon = ROGUE_HUD_ICON_ADVSETUP
	alpha = 0
	animate(src, alpha = 255, time = ROGUE_ADVSETUP_FADE)
	var/mob/owner = get_mob()
	if(owner?.client && owner.hud_used?.hud_version != HUD_STYLE_NOHUD)
		owner.client.screen |= src

/atom/movable/screen/rogue/advsetup/proc/hide_setup()
	showing = FALSE
	animate(src)
	icon = null
	var/mob/owner = get_mob()
	owner?.client?.screen -= src

/datum/movespeed_modifier/rogue_sneak
	variable = TRUE

/mob/living/carbon/human/var/rogue_sneaking = FALSE
/mob/living/carbon/human/var/rogue_sneak_hidden = FALSE
/mob/living/carbon/human/var/rogue_sneak_revealed_until = 0

/mob/living/carbon/human/proc/rogue_toggle_sneak()
	if(rogue_sneaking)
		rogue_stop_sneaking()
		return
	if(stat != STABLE)
		return
	rogue_sneaking = TRUE
	set_move_intent(MOVE_INTENT_WALK)
	var/rank = rogue_skill_rank(/datum/attribute/skill/misc/sneaking)
	add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/rogue_sneak, multiplicative_slowdown = max(CONFIG_GET(number/movedelay/walk_delay) * (ROGUE_SNEAK_SLOW_BASE - rank * ROGUE_SNEAK_SLOW_PER_RANK), 0))
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(rogue_sneak_moved))
	RegisterSignal(src, COMSIG_LIVING_LIFE, PROC_REF(rogue_sneak_life))
	RegisterSignal(src, COMSIG_MOVE_INTENT_TOGGLED, PROC_REF(rogue_sneak_intent))
	to_chat(src, span_notice("I begin to move quietly."))
	rogue_update_sneak()
	SEND_SIGNAL(src, COMSIG_MOB_ROGUE_SNEAK_CHANGED)

/mob/living/carbon/human/proc/rogue_stop_sneaking()
	if(!rogue_sneaking)
		return
	rogue_sneaking = FALSE
	remove_movespeed_modifier(/datum/movespeed_modifier/rogue_sneak)
	UnregisterSignal(src, list(COMSIG_MOVABLE_MOVED, COMSIG_LIVING_LIFE, COMSIG_MOVE_INTENT_TOGGLED))
	rogue_sneak_reveal()
	SEND_SIGNAL(src, COMSIG_MOB_ROGUE_SNEAK_CHANGED)

/mob/living/carbon/human/proc/rogue_sneak_moved(datum/source, atom/old_loc, movement_dir, forced, list/old_locs)
	SIGNAL_HANDLER
	rogue_update_sneak()

/mob/living/carbon/human/proc/rogue_sneak_life(datum/source, seconds_per_tick)
	SIGNAL_HANDLER
	rogue_update_sneak()

/mob/living/carbon/human/proc/rogue_sneak_intent(datum/source)
	SIGNAL_HANDLER
	if(move_intent == MOVE_INTENT_RUN)
		rogue_stop_sneaking()

/mob/living/carbon/human/proc/rogue_reveal_sneak(duration = ROGUE_SNEAK_ATTACK_REVEAL)
	rogue_sneak_revealed_until = max(rogue_sneak_revealed_until, world.time + duration)
	if(rogue_sneaking)
		rogue_update_sneak()

/mob/living/carbon/human/proc/rogue_update_sneak()
	var/turf/here = get_turf(src)
	var/rank = rogue_skill_rank(/datum/attribute/skill/misc/sneaking)
	if(!rogue_sneaking || !here || stat > SOFT_CRIT || IsSleeping() || world.time < rogue_sneak_revealed_until || here.get_lumcount() >= ROGUE_SNEAK_LIGHT + rank / ROGUE_SNEAK_LIGHT_PER_RANK)
		rogue_sneak_reveal(rank)
		return
	if(rogue_sneak_hidden)
		return
	rogue_sneak_hidden = TRUE
	animate(src, alpha = rogue_sneak_alpha(rank), time = max(ROGUE_SNEAK_FADE - rank * ROGUE_SNEAK_FADE_PER_RANK, 0))
	SetInvisibility(SEE_INVISIBLE_LIVING + round(rank * ROGUE_SNEAK_INVIS_PER_RANK) + 1, id = ROGUE_SNEAK_SOURCE)

/mob/living/carbon/human/proc/rogue_sneak_reveal(rank = 0)
	if(!rogue_sneak_hidden)
		return
	rogue_sneak_hidden = FALSE
	RemoveInvisibility(ROGUE_SNEAK_SOURCE)
	animate(src, alpha = initial(alpha), time = clamp(ROGUE_SNEAK_FADE - (ROGUE_SNEAK_FADE - rank * ROGUE_SNEAK_FADE_PER_RANK) * 1.75, ROGUE_SNEAK_MIN_REVEAL, ROGUE_SNEAK_FADE))

/mob/living/carbon/human/proc/rogue_sneak_alpha(rank)
	switch(rank)
		if(1)
			return 178
		if(2)
			return 140
		if(3)
			return 128
		if(4)
			return 102
		if(5)
			return 77
		if(6 to INFINITY)
			return 51
	return 255

/atom/movable/screen/rogue/sneak
	name = "sneak mode"
	icon_state = "sneak0"
	screen_loc = rogueui_moves
	layer = ROGUE_HUD_LAYER
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/rogue/sneak/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	var/mob/owner = hud_owner?.mymob
	if(owner)
		RegisterSignal(owner, COMSIG_MOB_ROGUE_SNEAK_CHANGED, PROC_REF(refresh))

/atom/movable/screen/rogue/sneak/proc/refresh()
	SIGNAL_HANDLER
	var/mob/living/carbon/human/owner = get_mob()
	icon_state = ishuman(owner) && owner.rogue_sneaking ? "sneak1" : "sneak0"

/atom/movable/screen/rogue/sneak/Click(location, control, params)
	var/mob/living/carbon/human/owner = get_mob()
	if(usr != owner || !ishuman(owner))
		return
	owner.rogue_toggle_sneak()

/mob/living/var/rogue_eyes_closed = FALSE
/mob/living/var/rogue_fixed_eye = FALSE

/mob/living/proc/rogue_set_eyes_closed(closed)
	if(rogue_eyes_closed == closed)
		return
	rogue_eyes_closed = closed
	if(closed)
		become_blind(ROGUE_EYELIDS_SOURCE)
	else
		cure_blind(ROGUE_EYELIDS_SOURCE)
	SEND_SIGNAL(src, COMSIG_MOB_ROGUE_EYE_CHANGED)

/mob/living/proc/rogue_toggle_fixed_eye()
	rogue_fixed_eye = !rogue_fixed_eye
	set_dir_on_move = !(rogue_fixed_eye || rogue_facing_held)
	SEND_SIGNAL(src, COMSIG_MOB_ROGUE_EYE_CHANGED)

/mob/living/proc/rogue_stealth_rank()
	return 0

/mob/living/carbon/human/rogue_stealth_rank()
	if(!mind)
		return 0
	return max(rogue_skill_rank(/datum/attribute/skill/misc/sneaking), rogue_skill_rank(/datum/attribute/skill/magic/holy), rogue_skill_rank(/datum/attribute/skill/magic/arcane))

/mob/living/proc/rogue_is_hidden()
	return FALSE

/mob/living/carbon/human/rogue_is_hidden()
	return rogue_sneaking && rogue_sneak_hidden

/mob/living/proc/rogue_look_around()
	if(!client || incapacitated || rogue_eyes_closed || is_blind())
		return
	changeNext_move(ROGUE_LOOK_AROUND_CLICK)
	if(!rogue_is_hidden())
		visible_message(span_info("[src] begins looking around."))
	var/perception = rogue_stat(ROGUE_STAT_PERCEPTION)
	var/tracking = rogue_skill_rank(/datum/attribute/skill/misc/tracking)
	var/look_time = rogue_formula_value(ROGUE_FORMULA_LOOK_AROUND_TIME, list("perception" = perception, "tracking" = tracking))
	if(!do_after(src, look_time, target = src) || !client)
		return
	var/list/seen_turfs = list()
	for(var/turf/seen in view(ROGUE_LOOK_AROUND_RANGE, src))
		seen_turfs[seen] = TRUE
	for(var/mob/living/other in range(ROGUE_LOOK_AROUND_RANGE, src))
		if(other == src || !seen_turfs[other.loc])
			continue
		if(!other.rogue_is_hidden())
			rogue_found_ping(other.loc, ROGUE_PING_HIDDEN)
			continue
		var/chance = rogue_formula_value(ROGUE_FORMULA_LOOK_AROUND_CHANCE, list(
			"perception" = perception,
			"tracking" = tracking,
			"target_stealth" = other.rogue_stealth_rank(),
			"target_perception" = other.rogue_stat(ROGUE_STAT_PERCEPTION),
		))
		var/mob/living/carbon/human/hider = other
		if(!prob(chance))
			to_chat(hider, span_warning("[src] didn't find me."))
			continue
		to_chat(hider, span_danger("[src] sees me! I'm found!"))
		hider.rogue_reveal_sneak(ROGUE_LOOK_AROUND_REVEAL)
		rogue_found_ping(hider.loc, ROGUE_PING_HIDDEN)
	for(var/obj/hiding_place in range(ROGUE_LOOK_AROUND_RANGE, src))
		if(!seen_turfs[hiding_place.loc])
			continue
		var/datum/component/rockhill_hiding_spot/spot = hiding_place.GetComponent(/datum/component/rockhill_hiding_spot)
		var/mob/living/tucked = spot?.hider?.resolve()
		if(tucked && rogue_formula_value(ROGUE_FORMULA_LOOK_AROUND_SPOT, list("perception" = perception, "target_sneaking" = tucked.rogue_skill_rank(/datum/attribute/skill/misc/sneaking))))
			rogue_found_ping(hiding_place.loc, ROGUE_PING_HIDDEN)
	for(var/obj/structure/trap/trap in range(ROGUE_LOOK_AROUND_RANGE, src))
		if(seen_turfs[trap.loc] && trap.rockhill_armed && trap.charges > 0 && world.time >= trap.last_trigger + trap.time_between_triggers)
			rogue_found_ping(trap.loc, ROGUE_PING_TRAP)
	for(var/obj/item/restraints/legcuffs/beartrap/trap in range(ROGUE_LOOK_AROUND_RANGE, src))
		if(seen_turfs[trap.loc] && trap.armed)
			rogue_found_ping(trap.loc, ROGUE_PING_TRAP)

/mob/proc/rogue_found_ping(turf/where, state)
	if(!client || !isturf(where))
		return
	var/image/ping = image(icon = ROGUE_PING_ICON, loc = where, icon_state = state)
	SET_PLANE_EXPLICIT(ping, ABOVE_LIGHTING_PLANE, where)
	ping.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	flick_overlay_global(ping, list(client), ROGUE_PING_DURATION)

/mob/living/proc/rogue_toggle_compliance()
	if(has_status_effect(/datum/status_effect/rogue_compliance))
		remove_status_effect(/datum/status_effect/rogue_compliance)
	else
		apply_status_effect(/datum/status_effect/rogue_compliance)

/datum/status_effect/rogue_compliance
	id = "rogue_compliance"
	duration = STATUS_EFFECT_PERMANENT
	tick_interval = STATUS_EFFECT_NO_TICK
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/rogue_compliance

/datum/status_effect/rogue_compliance/on_apply()
	ADD_TRAIT(owner, TRAIT_GRABWEAKNESS, ROGUE_COMPLIANCE_SOURCE)
	to_chat(owner, span_info("I will not struggle against grabs."))
	return TRUE

/datum/status_effect/rogue_compliance/on_remove()
	REMOVE_TRAIT(owner, TRAIT_GRABWEAKNESS, ROGUE_COMPLIANCE_SOURCE)
	to_chat(owner, span_info("I will struggle against grabs as usual."))

/atom/movable/screen/alert/status_effect/rogue_compliance
	name = "Compliance"
	desc = "I am not resisting grabs and tackles. Click to stop."
	icon = ROGUE_ALERT_ICON
	icon_state = "compliance"

/atom/movable/screen/alert/status_effect/rogue_compliance/Click(location, control, params)
	. = ..()
	if(!.)
		return
	var/mob/living/living_owner = owner
	if(isliving(living_owner))
		living_owner.remove_status_effect(/datum/status_effect/rogue_compliance)

/mob/living/proc/rogue_take_offered()
	for(var/alert_key in alerts)
		var/atom/movable/screen/alert/give/offer_alert = alerts[alert_key]
		if(!istype(offer_alert) || !offer_alert.offer)
			continue
		offer_alert.handle_transfer()
		return TRUE
	balloon_alert(src, "nothing offered")
	return FALSE
