GLOBAL_LIST_EMPTY(rockhill_advclasses)

/proc/rockhill_advclass(path)
	if(!ispath(path, /datum/rockhill_advclass))
		return null
	if(!GLOB.rockhill_advclasses[path])
		GLOB.rockhill_advclasses[path] = new path
	return GLOB.rockhill_advclasses[path]

/datum/rockhill_advclass
	var/name
	var/desc
	var/outfit
	var/attribute_sheet
	var/list/rockhill_traits
	var/maximum_slots = ROCKHILL_ADVCLASS_UNLIMITED
	var/taken = 0

/datum/rockhill_advclass/proc/available()
	return maximum_slots == ROCKHILL_ADVCLASS_UNLIMITED || taken < maximum_slots

/datum/rockhill_advclass/proc/apply(mob/living/carbon/human/human)
	for(var/obj/item/worn as anything in human.get_equipped_items(INCLUDE_POCKETS | INCLUDE_HELD | INCLUDE_ACCESSORIES))
		qdel(worn)
	if(outfit)
		human.equipOutfit(outfit)
	if(attribute_sheet)
		human.attributes?.add_sheet(attribute_sheet)
	for(var/trait in rockhill_traits)
		ADD_TRAIT(human, trait, JOB_TRAIT)
	human.rockhill_advclass = src
	taken++

/datum/rockhill_advclass/proc/summary()
	var/list/stats = list()
	var/list/skills = list()
	var/datum/attribute_holder/sheet/sheet = attribute_sheet ? rockhill_sheet(attribute_sheet) : null
	for(var/attribute_type in sheet?.raw_attribute_list)
		var/datum/attribute/attribute = GET_ROGUE_ATTRIBUTE(attribute_type)
		if(!attribute)
			continue
		var/value = sheet.raw_attribute_list[attribute_type]
		if(ispath(attribute_type, ROGUE_SKILL))
			var/datum/attribute/skill/skill = attribute
			skills += list(list("name" = attribute.name, "level" = skill.description_from_level(value)))
		else
			stats += list(list("name" = attribute.name, "value" = value))
	var/list/traits = list()
	for(var/trait in rockhill_traits)
		traits += "[trait]"
	return list(
		"type" = "[type]",
		"name" = name,
		"desc" = desc,
		"stats" = stats,
		"skills" = skills,
		"traits" = traits,
		"slots" = maximum_slots == ROCKHILL_ADVCLASS_UNLIMITED ? null : maximum_slots - taken,
	)

/mob/living/carbon/human/var/datum/rockhill_advclass/rockhill_advclass

/proc/rockhill_sheet(path)
	if(!GLOB.rogue_attribute_sheets[path])
		GLOB.rogue_attribute_sheets[path] = new path
	return GLOB.rogue_attribute_sheets[path]

/// The classes of the list that still have room.
/proc/rockhill_class_choices(list/class_paths)
	. = list()
	for(var/path in class_paths)
		var/datum/rockhill_advclass/advclass = rockhill_advclass(path)
		if(advclass?.available())
			. += advclass

/// Lets the human pick a class from the list, as Ratwood's class handler does for a role (a job, a migrant's role);
/// the only class left, or any for a body without a player, is applied at once.
/proc/rockhill_start_class_choice(mob/living/carbon/human/human, client/player_client, title, list/class_paths)
	var/list/choices = rockhill_class_choices(class_paths)
	if(!length(choices))
		return FALSE
	if(length(choices) == 1 || !player_client)
		var/datum/rockhill_advclass/only = choices[1]
		only.apply(human)
		return TRUE
	var/datum/rockhill_class_select/menu = new(human, title, class_paths)
	if(human.client)
		menu.ui_interact(human)
	return TRUE

/datum/job/roguetown/proc/rockhill_class_choices()
	return global.rockhill_class_choices(rockhill_advclasses)

/datum/job/roguetown/proc/rockhill_start_class_choice(mob/living/carbon/human/human, client/player_client)
	return global.rockhill_start_class_choice(human, player_client, title, rockhill_advclasses)

/datum/rockhill_class_select
	var/datum/weakref/chooser
	/// Whose classes they are: the job's or the role's title.
	var/title
	var/list/class_paths
	var/chosen = FALSE
	var/deadline

/datum/rockhill_class_select/New(mob/living/carbon/human/human, title, list/class_paths)
	chooser = WEAKREF(human)
	src.title = title
	src.class_paths = class_paths
	deadline = world.time + ROCKHILL_ADVCLASS_CHOICE_TIME
	ADD_TRAIT(human, TRAIT_IMMOBILIZED, ROCKHILL_ADVCLASS_TRAIT)
	ADD_TRAIT(human, TRAIT_HANDS_BLOCKED, ROCKHILL_ADVCLASS_TRAIT)
	human.SetInvisibility(INVISIBILITY_OBSERVER, id = ROCKHILL_ADVCLASS_TRAIT)
	RegisterSignal(human, COMSIG_MOB_CLIENT_LOGIN, PROC_REF(on_login))
	RegisterSignal(human, COMSIG_MOB_ROGUE_ADVSETUP_CLICKED, PROC_REF(on_login))
	show_setup(human)
	addtimer(CALLBACK(src, PROC_REF(timed_out)), ROCKHILL_ADVCLASS_CHOICE_TIME)

/datum/rockhill_class_select/proc/on_login(mob/source, client/client)
	SIGNAL_HANDLER
	show_setup(source)
	INVOKE_ASYNC(src, PROC_REF(reopen))

/datum/rockhill_class_select/proc/show_setup(mob/living/carbon/human/human)
	var/atom/movable/screen/rogue/advsetup/setup = human.hud_used?.screen_objects[HUD_ROGUE_ADVSETUP]
	if(istype(setup))
		setup.show_setup()

/datum/rockhill_class_select/Destroy()
	class_paths = null
	return ..()

/datum/rockhill_class_select/ui_state(mob/user)
	return GLOB.always_state

/datum/rockhill_class_select/ui_status(mob/user, datum/ui_state/state)
	return user == chooser?.resolve() ? UI_INTERACTIVE : UI_CLOSE

/datum/rockhill_class_select/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RockhillClassSelect")
		ui.set_autoupdate(TRUE)
		ui.open()

/datum/rockhill_class_select/ui_close(mob/user)
	if(!chosen && !QDELETED(src))
		addtimer(CALLBACK(src, PROC_REF(reopen)), 1 SECONDS)

/datum/rockhill_class_select/proc/reopen()
	var/mob/living/carbon/human/human = chooser?.resolve()
	if(chosen || QDELETED(human) || !human.client)
		return
	ui_interact(human)

/datum/rockhill_class_select/ui_data(mob/user)
	var/list/classes = list()
	for(var/datum/rockhill_advclass/advclass as anything in rockhill_class_choices(class_paths))
		classes += list(advclass.summary())
	return list(
		"job" = title,
		"classes" = classes,
		"seconds_left" = max(0, round((deadline - world.time) / (1 SECONDS))),
	)

/datum/rockhill_class_select/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(. || chosen || action != "choose")
		return
	var/path = text2path(params["type"])
	if(!(path in class_paths))
		return
	var/datum/rockhill_advclass/advclass = rockhill_advclass(path)
	if(!advclass.available())
		to_chat(ui.user, span_warning("[advclass.name] is already taken."))
		return TRUE
	finish(advclass)
	return TRUE

/datum/rockhill_class_select/proc/timed_out()
	if(chosen)
		return
	var/list/choices = rockhill_class_choices(class_paths)
	if(length(choices))
		finish(choices[1])
	else
		finish(null)

/datum/rockhill_class_select/proc/finish(datum/rockhill_advclass/advclass)
	chosen = TRUE
	var/mob/living/carbon/human/human = chooser?.resolve()
	if(!QDELETED(human))
		UnregisterSignal(human, list(COMSIG_MOB_CLIENT_LOGIN, COMSIG_MOB_ROGUE_ADVSETUP_CLICKED))
		var/atom/movable/screen/rogue/advsetup/setup = human.hud_used?.screen_objects[HUD_ROGUE_ADVSETUP]
		if(istype(setup))
			setup.hide_setup()
		REMOVE_TRAIT(human, TRAIT_IMMOBILIZED, ROCKHILL_ADVCLASS_TRAIT)
		REMOVE_TRAIT(human, TRAIT_HANDS_BLOCKED, ROCKHILL_ADVCLASS_TRAIT)
		human.RemoveInvisibility(ROCKHILL_ADVCLASS_TRAIT)
		if(advclass)
			advclass.apply(human)
			to_chat(human, span_notice("I am the [advclass.name]."))
		SStgui.close_uis(src)
	qdel(src)
