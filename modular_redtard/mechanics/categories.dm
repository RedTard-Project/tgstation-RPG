/datum/rogue_mechanics_category
	var/name
	var/file
	var/root
	var/desc
	var/list/fields = list()

/datum/rogue_mechanics_category/proc/id_of(path)
	return copytext("[path]", length("[root]") + 2)

/datum/rogue_mechanics_category/proc/path_of(id)
	var/path = text2path("[root]/[id]")
	return ispath(path, root) ? path : null

/datum/rogue_mechanics_category/proc/exported_types()
	return subtypesof(root)

/datum/rogue_mechanics_category/proc/apply(datum/target, list/values)
	for(var/field in values)
		var/list/spec = fields[field]
		var/var_name = spec[ROGUE_FIELD_VAR]
		if(var_name in target.vars)
			target.vars[var_name] = rogue_mechanics_copy(values[field])

/datum/rogue_mechanics_category/proc/has_field(datum/target, field)
	var/list/spec = fields[field]
	return spec[ROGUE_FIELD_VAR] in target.vars

/datum/rogue_mechanics_category/proc/field_text(datum/target, field)
	var/list/spec = fields[field]
	return rogue_mechanics_value_text(target.vars[spec[ROGUE_FIELD_VAR]], spec[ROGUE_FIELD_KIND])

/datum/rogue_mechanics_category/armor
	name = "armor"
	file = "armor.txt"
	root = /datum/rogue_armor
	desc = "Armor datums. The id is the path after /datum/rogue_armor/; items point at it with armor = id. Ratings are percent, as in Ratwood."
	fields = list(
		"blunt" = list("blunt", ROGUE_KIND_NUM),
		"slash" = list("slash", ROGUE_KIND_NUM),
		"stab" = list("stab", ROGUE_KIND_NUM),
		"piercing" = list("piercing", ROGUE_KIND_NUM),
		"fire" = list("fire", ROGUE_KIND_NUM),
		"acid" = list("acid", ROGUE_KIND_NUM),
		"magic" = list("magic", ROGUE_KIND_NUM),
		"wound" = list("wound", ROGUE_KIND_NUM),
		"slash_edge" = list("slash_ep", ROGUE_KIND_NUM),
		"stab_edge" = list("stab_ep", ROGUE_KIND_NUM),
		"piercing_edge" = list("piercing_ep", ROGUE_KIND_NUM),
	)

/datum/rogue_mechanics_category/intents
	name = "intents"
	file = "intents.txt"
	root = /datum/intent
	desc = "Attack intents. The id is the path after /datum/intent/; items list them with intents = id, id."
	fields = list(
		"name" = list("name", ROGUE_KIND_TEXT),
		"desc" = list("desc", ROGUE_KIND_TEXT),
		"strike_class" = list("blade_class", ROGUE_KIND_TEXT),
		"armor_type" = list("item_d_type", ROGUE_KIND_TEXT),
		"damage_factor" = list("damfactor", ROGUE_KIND_NUM),
		"penetration_factor" = list("penfactor", ROGUE_KIND_NUM),
		"click_delay" = list("clickcd", ROGUE_KIND_NUM),
		"stamina_cost" = list("releasedrain", ROGUE_KIND_NUM),
		"miss_cost" = list("misscost", ROGUE_KIND_NUM),
		"reach" = list("reach", ROGUE_KIND_NUM),
		"charge_time" = list("chargetime", ROGUE_KIND_NUM),
		"swing_delay" = list("swingdelay", ROGUE_KIND_NUM),
		"can_parry" = list("canparry", ROGUE_KIND_BOOL),
		"can_dodge" = list("candodge", ROGUE_KIND_BOOL),
		"no_attack" = list("no_attack", ROGUE_KIND_BOOL),
	)

/datum/rogue_mechanics_category/items
	name = "items"
	file = "items.txt"
	root = /obj/item
	desc = "Items. The id is the path after /obj/item/ and links the entry to the item in the game. Only the fields written here change; the rest stay as the code has them."
	fields = list(
		"name" = list("name", ROGUE_KIND_TEXT),
		"integrity" = list("max_integrity", ROGUE_KIND_NUM),
		"force" = list("force", ROGUE_KIND_NUM),
		"force_wielded" = list("rogue_force_wielded", ROGUE_KIND_NUM),
		"throw_force" = list("throwforce", ROGUE_KIND_NUM),
		"penetration" = list("armour_penetration", ROGUE_KIND_NUM),
		"armor" = list("rogue_armor", ROGUE_KIND_ARMOR),
		"armor_class" = list("armor_class", ROGUE_KIND_ARMOR_CLASS),
		"prevent_crits" = list("rogue_prevent_crits", ROGUE_KIND_TEXT_LIST),
		"intents" = list("possible_item_intents", ROGUE_KIND_INTENTS),
		"wielded_intents" = list("gripped_intents", ROGUE_KIND_INTENTS),
		"defense" = list("wdefense", ROGUE_KIND_NUM),
		"wielded_defense_bonus" = list("wdefense_wbonus", ROGUE_KIND_NUM),
		"length" = list("wlength", ROGUE_KIND_LENGTH),
		"balance" = list("wbalance", ROGUE_KIND_BALANCE),
		"min_strength" = list("minstr", ROGUE_KIND_NUM),
		"skill" = list("associated_skill", ROGUE_KIND_SKILL),
		"can_parry" = list("can_parry", ROGUE_KIND_BOOL),
	)

/datum/rogue_mechanics_category/items/exported_types()
	. = list()
	for(var/obj/item/path as anything in subtypesof(root))
		if(initial(path.associated_skill) || initial(path.can_parry) || initial(path.wdefense) || initial(path.rogue_force_wielded))
			. += path
	for(var/obj/item/clothing/path as anything in subtypesof(/obj/item/clothing))
		if(initial(path.rogue_armor) || initial(path.armor_class))
			. |= path

/datum/rogue_mechanics_category/items/apply(datum/target, list/values)
	var/obj/item/thing = target
	var/ratio = thing.max_integrity ? thing.get_integrity() / thing.max_integrity : 1
	. = ..()
	if(!(thing.flags_1 & INITIALIZED_1) || !("integrity" in values))
		return
	thing.update_integrity(thing.max_integrity * ratio)

/proc/rogue_mechanics_copy(value)
	if(islist(value))
		var/list/listed = value
		return listed.Copy()
	return value

/proc/rogue_mechanics_parse(text, kind)
	switch(kind)
		if(ROGUE_KIND_NUM)
			var/number = text2num(text)
			return isnull(number) ? "not a number: [text]" : list(number)
		if(ROGUE_KIND_TEXT)
			return list(text)
		if(ROGUE_KIND_BOOL)
			switch(lowertext(text))
				if("yes", "true", "1", "on")
					return list(TRUE)
				if("no", "false", "0", "off")
					return list(FALSE)
			return "not yes/no: [text]"
		if(ROGUE_KIND_TEXT_LIST)
			var/list/values = list()
			for(var/part in splittext(text, ","))
				part = trim(part)
				if(length(part))
					values += part
			return list(values)
		if(ROGUE_KIND_INTENTS)
			var/list/intents = list()
			for(var/part in splittext(text, ","))
				part = trim(part)
				if(!length(part))
					continue
				var/path = text2path("/datum/intent/[part]")
				if(!ispath(path, /datum/intent))
					return "unknown intent: [part]"
				intents += path
			return list(intents)
		if(ROGUE_KIND_ARMOR)
			if(!length(text) || lowertext(text) == ROGUE_MECHANICS_NONE)
				return list(null)
			var/path = text2path("/datum/rogue_armor/[text]")
			return ispath(path, /datum/rogue_armor) ? list(path) : "unknown armor: [text]"
		if(ROGUE_KIND_SKILL)
			if(!length(text) || lowertext(text) == ROGUE_MECHANICS_NONE)
				return list(null)
			var/path = text2path("/datum/attribute/skill/[text]")
			return ispath(path, /datum/attribute/skill) ? list(path) : "unknown skill: [text]"
		if(ROGUE_KIND_ARMOR_CLASS, ROGUE_KIND_LENGTH, ROGUE_KIND_BALANCE)
			var/list/names = rogue_mechanics_enum(kind)
			var/value = names[lowertext(text)]
			if(isnull(value))
				value = text2num(text)
			return isnull(value) ? "expected a number or one of [jointext(names, ", ")]: [text]" : list(value)
	return "unknown field kind [kind]"

/proc/rogue_mechanics_value_text(value, kind)
	switch(kind)
		if(ROGUE_KIND_NUM)
			return "[isnum(value) ? value : 0]"
		if(ROGUE_KIND_BOOL)
			return value ? "yes" : "no"
		if(ROGUE_KIND_TEXT)
			return "[value]"
		if(ROGUE_KIND_TEXT_LIST)
			return islist(value) ? jointext(value, ", ") : ""
		if(ROGUE_KIND_INTENTS)
			var/list/ids = list()
			for(var/path in value)
				ids += copytext("[path]", length("/datum/intent/") + 1)
			return jointext(ids, ", ")
		if(ROGUE_KIND_ARMOR)
			return ispath(value) ? copytext("[value]", length("/datum/rogue_armor/") + 1) : ROGUE_MECHANICS_NONE
		if(ROGUE_KIND_SKILL)
			return ispath(value) ? copytext("[value]", length("/datum/attribute/skill/") + 1) : ROGUE_MECHANICS_NONE
		if(ROGUE_KIND_ARMOR_CLASS, ROGUE_KIND_LENGTH, ROGUE_KIND_BALANCE)
			var/list/names = rogue_mechanics_enum(kind)
			for(var/name in names)
				if(names[name] == value)
					return name
	return "[value]"

/proc/rogue_mechanics_enum(kind)
	switch(kind)
		if(ROGUE_KIND_ARMOR_CLASS)
			return list("none" = ARMOR_CLASS_NONE, "light" = ARMOR_CLASS_LIGHT, "medium" = ARMOR_CLASS_MEDIUM, "heavy" = ARMOR_CLASS_HEAVY)
		if(ROGUE_KIND_LENGTH)
			return list("short" = WLENGTH_SHORT, "normal" = WLENGTH_NORMAL, "long" = WLENGTH_LONG, "great" = WLENGTH_GREAT)
		if(ROGUE_KIND_BALANCE)
			return list("heavy" = WBALANCE_HEAVY, "normal" = WBALANCE_NORMAL, "swift" = WBALANCE_SWIFT)
	return list()
