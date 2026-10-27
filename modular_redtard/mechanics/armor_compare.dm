/datum/rogue_armor_compare

/datum/rogue_armor_compare/ui_state(mob/user)
	return ADMIN_STATE(R_DEBUG)

/datum/rogue_armor_compare/ui_close(mob/user)
	qdel(src)

/datum/rogue_armor_compare/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ArmorCompare", "Armor Comparison")
		ui.open()

/datum/rogue_armor_compare/ui_data(mob/user)
	return list("usage_built" = TRUE)

/datum/rogue_armor_compare/ui_static_data(mob/user)
	var/list/usage = rogue_armor_item_usage()
	var/list/classes = rogue_armor_item_classes()
	var/list/armor_list = list()
	for(var/armor_type in subtypesof(/datum/rogue_armor))
		var/datum/rogue_armor/armor = rogue_armor_datum(armor_type)
		var/key = "[armor_type]"
		armor_list += list(list(
			"type" = key,
			"armor_class" = classes[key] || "-",
			"blunt" = armor.blunt,
			"slash" = armor.slash,
			"stab" = armor.stab,
			"piercing" = armor.piercing,
			"fire" = armor.fire,
			"acid" = armor.acid,
			"magic" = armor.magic,
			"items" = length(usage[key]),
		))
	return list("armors" = armor_list, "item_usage" = usage)

/proc/rogue_armor_item_usage()
	var/list/usage = list()
	var/datum/rogue_mechanics/mechanics = rogue_mechanics()
	for(var/obj/item/clothing/path as anything in subtypesof(/obj/item/clothing))
		var/list/configured = mechanics.values_for("items", path)
		var/armor_type = configured && ("armor" in configured) ? configured["armor"] : initial(path.rogue_armor)
		if(!armor_type)
			continue
		var/key = "[armor_type]"
		if(!usage[key])
			usage[key] = list()
		usage[key] += "[path]"
	return usage

/proc/rogue_armor_item_classes()
	var/list/counts = list()
	var/datum/rogue_mechanics/mechanics = rogue_mechanics()
	for(var/obj/item/clothing/path as anything in subtypesof(/obj/item/clothing))
		var/list/configured = mechanics.values_for("items", path)
		var/armor_type = configured && ("armor" in configured) ? configured["armor"] : initial(path.rogue_armor)
		if(!armor_type)
			continue
		var/armor_class = configured && ("armor_class" in configured) ? configured["armor_class"] : initial(path.armor_class)
		var/key = "[armor_type]"
		if(!counts[key])
			counts[key] = list()
		var/list/by_class = counts[key]
		var/class_name = rogue_mechanics_value_text(armor_class, ROGUE_KIND_ARMOR_CLASS)
		by_class[class_name] = (by_class[class_name] || 0) + 1
	var/list/classes = list()
	for(var/key in counts)
		var/list/by_class = counts[key]
		var/best
		for(var/class_name in by_class)
			if(!best || by_class[class_name] > by_class[best])
				best = class_name
		classes[key] = best
	return classes
