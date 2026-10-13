/datum/job/roguetown
	abstract_type = /datum/job/roguetown
	faction = FACTION_STATION
	exp_granted_type = EXP_TYPE_CREW
	map_era = MAP_ERA_MEDIEVAL
	job_flags = ROCKHILL_JOB_FLAGS
	var/rockhill_advclass

/datum/job/roguetown/config_check()
	if(type == abstract_type)
		return FALSE
	return ..()

/datum/outfit/job/roguetown
	name = "Rockhill"
	uniform = null
	id = null
	ears = null
	belt = null
	back = null
	shoes = null
	box = null
	pda_slot = null
	var/shirt
	var/cloak
	var/wrists
	var/ring
	var/mouth
	var/backr

/datum/outfit/job/roguetown/pre_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	return

/datum/outfit/job/roguetown/equip(mob/living/carbon/human/user, visuals_only = FALSE)
	. = ..()
	var/list/layers = list(
		"[ITEM_SLOT_ROGUE_SHIRT]" = shirt,
		"[ITEM_SLOT_ROGUE_WRISTS]" = wrists,
		"[ITEM_SLOT_ROGUE_RING]" = ring,
		"[ITEM_SLOT_ROGUE_CLOAK]" = cloak,
		"[ITEM_SLOT_ROGUE_MOUTH]" = mouth,
		)
	for(var/slot in layers)
		var/obj/item/path = layers[slot]
		if(path)
			user.equip_to_slot_or_del(new path(user), text2num(slot), TRUE)
	if(backr)
		user.equip_to_rogue_cell(new backr(user), ITEM_SLOT_BACK, ROGUE_BACK_RIGHT, qdel_on_fail = TRUE, bypass_equip_delay_self = TRUE, initial = TRUE)

/datum/job_department/rockhill_nobles
	department_name = DEPARTMENT_ROCKHILL_NOBLES
	department_bitflags = DEPARTMENT_BITFLAG_ROCKHILL_NOBLES
	display_order = 1
	ui_color = "#c9a227"

/datum/job_department/rockhill_courtiers
	department_name = DEPARTMENT_ROCKHILL_COURTIERS
	department_bitflags = DEPARTMENT_BITFLAG_ROCKHILL_COURTIERS
	display_order = 2
	ui_color = "#8a6db5"

/datum/job_department/rockhill_garrison
	department_name = DEPARTMENT_ROCKHILL_GARRISON
	department_bitflags = DEPARTMENT_BITFLAG_ROCKHILL_GARRISON
	display_order = 3
	ui_color = "#b0413e"

/datum/job_department/rockhill_church
	department_name = DEPARTMENT_ROCKHILL_CHURCH
	department_bitflags = DEPARTMENT_BITFLAG_ROCKHILL_CHURCH
	display_order = 4
	ui_color = "#d8c27a"

/datum/job_department/rockhill_inquisition
	department_name = DEPARTMENT_ROCKHILL_INQUISITION
	department_bitflags = DEPARTMENT_BITFLAG_ROCKHILL_INQUISITION
	display_order = 5
	ui_color = "#7a2a2a"

/datum/job_department/rockhill_yeomen
	department_name = DEPARTMENT_ROCKHILL_YEOMEN
	department_bitflags = DEPARTMENT_BITFLAG_ROCKHILL_YEOMEN
	display_order = 6
	ui_color = "#5e8c3a"

/datum/job_department/rockhill_peasants
	department_name = DEPARTMENT_ROCKHILL_PEASANTS
	department_bitflags = DEPARTMENT_BITFLAG_ROCKHILL_PEASANTS
	display_order = 7
	ui_color = "#8c7448"

/datum/job_department/rockhill_youngfolk
	department_name = DEPARTMENT_ROCKHILL_YOUNGFOLK
	department_bitflags = DEPARTMENT_BITFLAG_ROCKHILL_YOUNGFOLK
	display_order = 8
	ui_color = "#4f8a9a"

/datum/job_department/rockhill_wanderers
	department_name = DEPARTMENT_ROCKHILL_WANDERERS
	department_bitflags = DEPARTMENT_BITFLAG_ROCKHILL_WANDERERS
	display_order = 9
	ui_color = "#777777"

/obj/effect/landmark/start/rockhill
	var/list/rockhill_latejoin_roles

/obj/effect/landmark/start/rockhill/Initialize(mapload)
	. = ..()
	if(!length(rockhill_latejoin_roles))
		return
	delete_after_roundstart = FALSE
	for(var/role in rockhill_latejoin_roles)
		LAZYADDASSOCLIST(GLOB.jobspawn_overrides, role, src)

/obj/effect/landmark/start/rockhill/Destroy()
	for(var/role in rockhill_latejoin_roles)
		LAZYREMOVEASSOC(GLOB.jobspawn_overrides, role, src)
	return ..()
