GLOBAL_LIST_INIT(rogue_rmb_intents, rogue_init_rmb_intents())

/proc/rogue_init_rmb_intents()
	. = list()
	for(var/intent_type in list(
		/datum/rogue_rmb_intent/strong,
		/datum/rogue_rmb_intent/swift,
		/datum/rogue_rmb_intent/aimed,
		/datum/rogue_rmb_intent/feint,
		/datum/rogue_rmb_intent/defend,
		/datum/rogue_rmb_intent/weak,
	))
		.[intent_type] = new intent_type

/datum/rogue_rmb_intent
	var/name = "intent"
	var/desc = ""
	var/icon_state = ""
	var/has_action = FALSE
	var/needs_adjacency = TRUE
	var/bypasses_click_delay = FALSE

/datum/rogue_rmb_intent/proc/rmb_action(mob/living/carbon/human/user, atom/target)
	return FALSE

/datum/rogue_rmb_intent/strong
	name = "strong"
	desc = "Your attacks deal +15% damage. Your attacks will cost the enemy more sharpness and integrity to defend against. Higher critrate with brutal attacks.\nCosts more stamina per hit.\n(RMB WHILE IN COMBAT MODE) Use your weapon's special attack."
	icon_state = "rmbstrong"
	has_action = TRUE
	needs_adjacency = FALSE

/datum/rogue_rmb_intent/strong/rmb_action(mob/living/carbon/human/user, atom/target)
	return user.rogue_use_special(target)

/datum/rogue_rmb_intent/swift
	name = "swift"
	desc = "Your attacks have less recovery time but are less accurate.\nDrains extra stamina from anyone dodging you, most of all while their dodge is fresh. Does not work with a HEAVY balanced weapon."
	icon_state = "rmbswift"

/datum/rogue_rmb_intent/aimed
	name = "aimed"
	desc = "Your attacks are more precise but have a longer recovery time. Higher critrate with precise attacks.\n(RMB WHILE IN COMBAT MODE) Bait out your targeted limb to the enemy. If it matches where they're aiming, they will be thrown off balance."
	icon_state = "rmbaimed"
	has_action = TRUE

/datum/rogue_rmb_intent/aimed/rmb_action(mob/living/carbon/human/user, atom/target)
	return ishuman(target) && user.rogue_bait(target)

/datum/rogue_rmb_intent/feint
	name = "feint"
	desc = "(RMB WHILE IN COMBAT MODE) A deceptive half-attack with no follow-through, meant to force your opponent to open their guard. Will fail on targets that are relaxed and less alert."
	icon_state = "rmbfeint"
	has_action = TRUE

/datum/rogue_rmb_intent/feint/rmb_action(mob/living/carbon/human/user, atom/target)
	return isliving(target) && target != user && user.rogue_feint(target)

/datum/rogue_rmb_intent/defend
	name = "defend"
	desc = "No delay between dodge and parry rolls.\n(RMB WHILE IN COMBAT MODE AND NOT GRABBING ANYTHING) Enter a defensive stance, guaranteeing the next hit is defended against.\nTwo people who hit each other with the Guard up will have their weapons Clash, potentially disarming them.\nHitting someone with it who has no Guard up is tiresome."
	icon_state = "rmbdef"
	has_action = TRUE
	needs_adjacency = FALSE
	bypasses_click_delay = TRUE

/datum/rogue_rmb_intent/defend/rmb_action(mob/living/carbon/human/user, atom/target)
	return user.rogue_try_guard()

/datum/rogue_rmb_intent/weak
	name = "weak"
	desc = "Your attacks deal 20% damage and will never critically hit. Useful for longer punishments, play-fighting, and bloodletting.\n(RMB WHILE IN COMBAT MODE) Attempt to steal from the target."
	icon_state = "rmbweak"
	has_action = TRUE

/datum/rogue_rmb_intent/weak/rmb_action(mob/living/carbon/human/user, atom/target)
	return ishuman(target) && user.rogue_try_steal(target)

/mob/living/carbon/human/var/datum/rogue_rmb_intent/rogue_rmb_intent
/mob/living/carbon/human/var/rogue_feint_ready_at = 0

/mob/living/proc/rogue_rmb_is(intent_type)
	return FALSE

/mob/living/carbon/human/rogue_rmb_is(intent_type)
	return istype(rogue_rmb_intent, intent_type)

/mob/living/proc/rogue_rmb_factor(factor_name)
	return 1

/mob/living/carbon/human/rogue_rmb_factor(factor_name)
	return rogue_rmb_intent ? rogue_value_or("rmb_[rogue_rmb_intent.name]_[factor_name]", 1) : 1

/mob/living/carbon/human/proc/rogue_toggle_rmb_intent(intent_type)
	var/datum/rogue_rmb_intent/picked = GLOB.rogue_rmb_intents[intent_type]
	if(!picked)
		return
	rogue_rmb_intent = rogue_rmb_intent == picked ? null : picked
	playsound_local(src, 'sound/machines/click.ogg', 50, FALSE)
	SEND_SIGNAL(src, COMSIG_MOB_ROGUE_RMB_CHANGED)

/datum/status_effect/rogue_vulnerable
	parent_type = /datum/status_effect/rogue
	id = "rogue_vulnerable"
	effect_state = "eff_vulnerable"

/datum/status_effect/rogue_vulnerable/on_creation(mob/living/new_owner, set_duration)
	base_duration = ROGUE_FEINT_DURATION
	return ..()

/datum/element/rogue_combat_bus/proc/on_click(mob/living/carbon/human/source, atom/target, list/modifiers)
	SIGNAL_HANDLER
	if(!LAZYACCESS(modifiers, RIGHT_CLICK) || LAZYACCESS(modifiers, SHIFT_CLICK) || LAZYACCESS(modifiers, CTRL_CLICK) || LAZYACCESS(modifiers, ALT_CLICK))
		return NONE
	var/datum/rogue_rmb_intent/stance = source.rogue_rmb_intent
	if(!source.combat_mode || !stance?.has_action || isnull(target) || istype(target, /atom/movable/screen))
		return NONE
	if(stance.needs_adjacency && !target.Adjacent(source))
		return NONE
	if(!stance.bypasses_click_delay && world.time < source.next_move)
		return COMSIG_MOB_CANCEL_CLICKON
	INVOKE_ASYNC(stance, TYPE_PROC_REF(/datum/rogue_rmb_intent, rmb_action), source, target)
	return COMSIG_MOB_CANCEL_CLICKON

/mob/living/carbon/human/proc/rogue_feint(mob/living/target)
	if(incapacitated || world.time < next_move)
		return FALSE
	if(world.time < rogue_feint_ready_at)
		to_chat(src, span_warning("I can't feint again so soon."))
		return FALSE
	if(HAS_TRAIT(src, TRAIT_PACIFISM))
		to_chat(src, span_warning("I will not pretend to attack another."))
		return FALSE
	face_atom(target)
	rogue_mark_in_combat()
	target.rogue_mark_in_combat()
	visible_message(span_danger("[src] feints an attack at [target]!"))
	var/our_skill = rogue_weapon_rank(get_active_held_item())
	var/their_skill = target.mind ? target.rogue_weapon_rank(target.get_active_held_item()) : 0
	var/chance = rogue_formula_value(ROGUE_FORMULA_FEINT_CHANCE, list(
		"skill" = our_skill,
		"target_skill" = their_skill,
		"intelligence" = rogue_stat(ROGUE_STAT_INTELLIGENCE),
		"target_intelligence" = target.rogue_stat(ROGUE_STAT_INTELLIGENCE),
		"target_vulnerable" = target.rogue_is_open() || target.has_status_effect(/datum/status_effect/rogue/bind),
	))
	var/cooldown = ROGUE_FEINT_COOLDOWN - rogue_tempo_bonus("rmb_cooldown")
	if(target.mind && !target.rogue_sees(src) && target.rogue_tempo_reaches("aware"))
		chance = 0
		cooldown = ROGUE_TEMPO_UNSEEN_COOLDOWN
		to_chat(src, span_warning("They need to see me for me to feint them!"))
	if(target.remove_status_effect(/datum/status_effect/rogue/guard))
		to_chat(src, span_notice("[target.p_their(TRUE)] guard is disrupted!"))
		cooldown = ROGUE_FEINT_COOLDOWN + ROGUE_FEINT_GUARD_COOLDOWN - rogue_tempo_bonus("rmb_cooldown")
		chance = 100
	rogue_feint_ready_at = world.time + cooldown
	SEND_SIGNAL(src, COMSIG_MOB_ROGUE_FEINT_USED)
	changeNext_move(CLICK_CD_MELEE)
	if(!prob(chance))
		playsound(src, 'modular_redtard/rockhill/sound/combat/feint.ogg', 100, TRUE)
		to_chat(src, span_warning("[target] did not fall for my feint..."))
		if(target.rogue_def_intent == ROGUE_INTENT_DODGE)
			target.rogue_change_dodge_cooldown(-ROGUE_FEINT_DODGE_SHIFT)
			target.rogue_change_dodge_fatigue(-ROGUE_FEINT_DODGE_SHIFT)
		return FALSE
	target.rogue_open(ROGUE_FEINT_DURATION)
	target.rogue_delay_action(max(ROGUE_FEINT_TARGET_CLICK + (our_skill - their_skill) / 2, ROGUE_FEINT_TARGET_CLICK_MIN))
	target.Immobilize(ROGUE_FEINT_IMMOBILIZE)
	target.adjust_stamina_loss(target.get_stamina_loss() * ROGUE_FEINT_STAMINA_SHARE)
	target.rogue_slowdown(ROGUE_FEINT_SLOW)
	if(target.rogue_def_intent == ROGUE_INTENT_DODGE)
		target.rogue_change_dodge_cooldown(ROGUE_FEINT_DODGE_PENALTY)
		target.rogue_change_dodge_fatigue(-ROGUE_FEINT_DODGE_PENALTY)
	if(rogue_def_intent == ROGUE_INTENT_DODGE)
		rogue_change_dodge_cooldown(-ROGUE_FEINT_DODGE_PENALTY)
		rogue_change_dodge_fatigue(ROGUE_FEINT_DODGE_SHIFT)
	to_chat(src, span_notice("[target] fell for my feint attack!"))
	to_chat(target, span_danger("I fall for [src]'s feint attack!"))
	playsound(src, 'modular_redtard/rockhill/sound/combat/riposte.ogg', 100, TRUE)
	log_combat(src, target, "feinted")
	return TRUE

/atom/movable/screen/rogue/rmb_choice
	name = "alt intent"
	layer = ROGUE_HUD_LAYER
	mouse_over_pointer = MOUSE_HAND_POINTER
	var/intent_type

/atom/movable/screen/rogue/rmb_choice/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	var/mob/owner = hud_owner?.mymob
	if(owner)
		RegisterSignal(owner, COMSIG_MOB_ROGUE_RMB_CHANGED, PROC_REF(refresh))

/atom/movable/screen/rogue/rmb_choice/proc/set_intent(new_type)
	intent_type = new_type
	var/datum/rogue_rmb_intent/intent = GLOB.rogue_rmb_intents[intent_type]
	name = intent.name
	icon_state = intent.icon_state
	update_appearance()

/atom/movable/screen/rogue/rmb_choice/proc/refresh()
	SIGNAL_HANDLER
	update_appearance()

/atom/movable/screen/rogue/rmb_choice/update_overlays()
	. = ..()
	var/mob/living/carbon/human/owner = get_mob()
	if(ishuman(owner) && owner.rogue_rmb_intent && owner.rogue_rmb_intent == GLOB.rogue_rmb_intents[intent_type])
		. += "[icon_state]_x"

/atom/movable/screen/rogue/rmb_choice/Click(location, control, params)
	var/mob/living/carbon/human/owner = get_mob()
	if(usr != owner || !ishuman(owner) || !intent_type)
		return
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, RIGHT_CLICK) || LAZYACCESS(modifiers, SHIFT_CLICK))
		var/datum/rogue_rmb_intent/intent = GLOB.rogue_rmb_intents[intent_type]
		to_chat(owner, span_info("[intent.name]: [intent.desc]"))
		return
	owner.rogue_toggle_rmb_intent(intent_type)
	var/datum/hud/rogue/rogue_hud = hud
	if(istype(rogue_hud) && rogue_hud.group_shown(HUD_GROUP_ROGUE_RMB))
		rogue_hud.toggle_group(HUD_GROUP_ROGUE_RMB, usr)

/atom/movable/screen/rogue/rmb_intent
	name = "alt intents"
	desc = "Pick an alt intent."
	icon_state = "rmbintent"
	screen_loc = rogueui_rmb_button
	layer = ROGUE_HUD_LAYER
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/rogue/rmb_intent/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	var/mob/owner = hud_owner?.mymob
	if(owner)
		RegisterSignal(owner, COMSIG_MOB_ROGUE_RMB_CHANGED, PROC_REF(refresh))

/atom/movable/screen/rogue/rmb_intent/proc/refresh()
	SIGNAL_HANDLER
	update_appearance()

/atom/movable/screen/rogue/rmb_intent/update_overlays()
	. = ..()
	var/mob/living/carbon/human/owner = get_mob()
	if(ishuman(owner) && owner.rogue_rmb_intent)
		. += "[owner.rogue_rmb_intent.icon_state]_x"

/atom/movable/screen/rogue/rmb_intent/Click(location, control, params)
	var/mob/living/carbon/human/owner = get_mob()
	if(usr != owner || !ishuman(owner))
		return
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, RIGHT_CLICK) || LAZYACCESS(modifiers, SHIFT_CLICK))
		var/datum/rogue_rmb_intent/intent = owner.rogue_rmb_intent
		to_chat(owner, span_info(intent ? "[intent.name]: [intent.desc]" : "No alt intent picked."))
		return
	var/datum/hud/rogue/rogue_hud = hud
	if(istype(rogue_hud))
		rogue_hud.toggle_group(HUD_GROUP_ROGUE_RMB, usr)

/atom/movable/screen/rogue/feint
	name = "feint"
	icon = ROGUE_HUD_ICON_FEINT
	icon_state = "feintbar100"
	screen_loc = rogueui_feint
	layer = ROGUE_HUD_LAYER + 0.1
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/screen/rogue/feint/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	var/mob/owner = hud_owner?.mymob
	if(owner)
		RegisterSignal(owner, COMSIG_MOB_ROGUE_FEINT_USED, PROC_REF(refresh))

/atom/movable/screen/rogue/feint/proc/refresh()
	SIGNAL_HANDLER
	var/mob/living/carbon/human/owner = get_mob()
	if(!ishuman(owner))
		return
	var/left = owner.rogue_feint_ready_at - world.time
	if(left <= 0)
		icon_state = "feintbar100"
		return
	var/percent = 100 - left / ROGUE_FEINT_COOLDOWN * 100
	var/shown = 0
	for(var/step in GLOB.rogue_feint_bar_steps)
		if(percent >= step)
			shown = step
	icon_state = "feintbar[shown]"
	addtimer(CALLBACK(src, PROC_REF(refresh)), ROGUE_FEINT_BAR_TICK, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_DELETE_ME)

GLOBAL_LIST_INIT(rogue_feint_bar_steps, list(0, 20, 40, 50, 60, 70, 80, 90))
