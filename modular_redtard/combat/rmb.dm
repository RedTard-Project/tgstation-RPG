GLOBAL_LIST_INIT(rogue_rmb_intents, rogue_init_rmb_intents())

/proc/rogue_init_rmb_intents()
	. = list()
	for(var/datum/rogue_rmb_intent/intent as anything in subtypesof(/datum/rogue_rmb_intent))
		.[intent] = new intent

/datum/rogue_rmb_intent
	var/name = "intent"
	var/desc = ""
	var/icon_state = ""
	var/damage_factor = 1
	var/click_factor = 1
	var/stamina_factor = 1

/datum/rogue_rmb_intent/strong
	name = "strong"
	desc = "Your attacks deal +15% damage, but cost more stamina per hit."
	icon_state = "rmbstrong"
	damage_factor = 1.15
	stamina_factor = 1.5

/datum/rogue_rmb_intent/swift
	name = "swift"
	desc = "Your attacks have less recovery time."
	icon_state = "rmbswift"
	click_factor = 0.75

/datum/rogue_rmb_intent/aimed
	name = "aimed"
	desc = "Your attacks are more careful and have a longer recovery time."
	icon_state = "rmbaimed"
	click_factor = 1.25

/datum/rogue_rmb_intent/feint
	name = "feint"
	desc = "(RMB WHILE IN COMBAT MODE) A deceptive half-attack with no follow-through, meant to force your opponent to open their guard. Will fail on targets that are relaxed and less alert."
	icon_state = "rmbfeint"

/datum/rogue_rmb_intent/defend
	name = "defend"
	desc = "No delay between dodge and parry rolls."
	icon_state = "rmbdef"

/datum/rogue_rmb_intent/weak
	name = "weak"
	desc = "Your attacks deal 20% damage. Useful for longer punishments, play-fighting, and bloodletting."
	icon_state = "rmbweak"
	damage_factor = 0.2

/mob/living/carbon/human/var/datum/rogue_rmb_intent/rogue_rmb_intent
/mob/living/carbon/human/var/rogue_feint_ready_at = 0

/mob/living/proc/rogue_rmb_is(intent_type)
	return FALSE

/mob/living/carbon/human/rogue_rmb_is(intent_type)
	return istype(rogue_rmb_intent, intent_type)

/mob/living/proc/rogue_rmb_factor(factor_name)
	return 1

/mob/living/carbon/human/rogue_rmb_factor(factor_name)
	return rogue_rmb_intent ? rogue_rmb_intent.vars[factor_name] : 1

/mob/living/carbon/human/proc/rogue_choose_rmb_intent()
	var/list/choices = list()
	var/list/by_name = list()
	for(var/path in GLOB.rogue_rmb_intents)
		var/datum/rogue_rmb_intent/intent = GLOB.rogue_rmb_intents[path]
		choices[intent.name] = image(icon = ROGUE_HUD_ICON, icon_state = intent.icon_state)
		by_name[intent.name] = intent
	choices[ROGUE_RMB_NONE_NAME] = image(icon = ROGUE_HUD_ICON, icon_state = "rmbintent")
	var/picked = show_radial_menu(src, src, choices, require_near = FALSE, tooltips = TRUE)
	if(!picked || QDELETED(src))
		return
	rogue_rmb_intent = by_name[picked]
	playsound_local(src, 'sound/machines/click.ogg', 50, FALSE)
	SEND_SIGNAL(src, COMSIG_MOB_ROGUE_RMB_CHANGED)

/datum/status_effect/rogue_vulnerable
	id = "rogue_vulnerable"
	duration = ROGUE_FEINT_DURATION
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null

/datum/element/rogue_rmb
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

/datum/element/rogue_rmb/Attach(datum/target)
	. = ..()
	if(!ishuman(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_MOB_CLICKON, PROC_REF(on_click))

/datum/element/rogue_rmb/Detach(datum/source)
	UnregisterSignal(source, COMSIG_MOB_CLICKON)
	return ..()

/datum/element/rogue_rmb/proc/on_click(mob/living/carbon/human/source, atom/target, list/modifiers)
	SIGNAL_HANDLER
	if(!LAZYACCESS(modifiers, RIGHT_CLICK) || LAZYACCESS(modifiers, SHIFT_CLICK) || LAZYACCESS(modifiers, CTRL_CLICK) || LAZYACCESS(modifiers, ALT_CLICK))
		return NONE
	if(!source.combat_mode || !source.rogue_rmb_is(/datum/rogue_rmb_intent/feint) || !isliving(target) || target == source || !target.Adjacent(source))
		return NONE
	INVOKE_ASYNC(source, TYPE_PROC_REF(/mob/living/carbon/human, rogue_feint), target)
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
		"target_vulnerable" = !!target.has_status_effect(/datum/status_effect/rogue_vulnerable),
	))
	rogue_feint_ready_at = world.time + ROGUE_FEINT_COOLDOWN
	SEND_SIGNAL(src, COMSIG_MOB_ROGUE_FEINT_USED)
	changeNext_move(CLICK_CD_MELEE)
	if(!prob(chance))
		playsound(src, 'modular_redtard/rockhill/sound/combat/feint.ogg', 100, TRUE)
		to_chat(src, span_warning("[target] did not fall for my feint..."))
		return FALSE
	target.apply_status_effect(/datum/status_effect/rogue_vulnerable)
	target.changeNext_move(max(ROGUE_FEINT_TARGET_CLICK + (our_skill - their_skill) / 2, ROGUE_FEINT_TARGET_CLICK_MIN))
	target.Immobilize(ROGUE_FEINT_IMMOBILIZE)
	to_chat(src, span_notice("[target] fell for my feint attack!"))
	to_chat(target, span_danger("I fall for [src]'s feint attack!"))
	playsound(src, 'modular_redtard/rockhill/sound/combat/riposte.ogg', 100, TRUE)
	log_combat(src, target, "feinted")
	return TRUE

/atom/movable/screen/rogue/rmb_intent
	name = "alt intents"
	icon_state = "rmbintent"
	screen_loc = rogueui_rmbintents
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
	if(LAZYACCESS(params2list(params), RIGHT_CLICK))
		if(owner.rogue_rmb_intent)
			to_chat(owner, span_info("[owner.rogue_rmb_intent.name]: [owner.rogue_rmb_intent.desc]"))
		return
	INVOKE_ASYNC(owner, TYPE_PROC_REF(/mob/living/carbon/human, rogue_choose_rmb_intent))

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
