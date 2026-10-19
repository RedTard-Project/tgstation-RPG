GLOBAL_LIST_INIT(rogue_attribute_editor_vars, list(
	"attribute_min" = ROGUE_ATTRIBUTE_MIN,
	"attribute_max" = ROGUE_ATTRIBUTE_MAX,
	"attribute_default" = ROGUE_ATTRIBUTE_DEFAULT,
	"skill_min" = ROGUE_SKILL_MIN,
	"skill_max" = ROGUE_SKILL_MAX,
	"skill_default" = null,
))

/mob/living/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_ROGUE_ATTRIBUTES, "Edit Rogue Attributes")

/mob/living/vv_do_topic(list/href_list)
	. = ..()
	if(!. || !href_list[VV_HK_ROGUE_ATTRIBUTES] || !check_rights(R_ADMIN))
		return
	if(!istype(attributes))
		to_chat(usr, span_warning("[src] has no attributes."))
		return
	var/datum/rogue_attribute_editor/editor = new(attributes)
	editor.ui_interact(usr)

/datum/rogue_attribute_editor
	var/datum/weakref/target

/datum/rogue_attribute_editor/New(datum/attribute_holder/target)
	src.target = WEAKREF(target)

/datum/rogue_attribute_editor/ui_state(mob/user)
	return ADMIN_STATE(R_ADMIN)

/datum/rogue_attribute_editor/ui_close(mob/user)
	qdel(src)

/datum/rogue_attribute_editor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AttributeEditor")
		ui.open()

/datum/rogue_attribute_editor/ui_data(mob/user)
	var/datum/attribute_holder/holder = target?.resolve()
	if(!holder)
		return list()
	var/list/stats = list()
	var/list/skills = list()
	for(var/attribute_type in GLOB.rogue_attributes)
		var/datum/attribute/attribute = GLOB.rogue_attributes[attribute_type]
		var/list/entry = list(
			"name" = attribute.name,
			"type" = "[attribute_type]",
			"value" = holder.attribute_list[attribute_type],
			"raw_value" = holder.raw_attribute_list[attribute_type],
		)
		if(ispath(attribute_type, ROGUE_SKILL))
			skills += list(entry)
		else
			stats += list(entry)
	return list(
		"parent" = holder.parent?.name,
		"attribute_min" = holder.attribute_min,
		"attribute_max" = holder.attribute_max,
		"attribute_default" = holder.attribute_default,
		"skill_min" = holder.skill_min,
		"skill_max" = holder.skill_max,
		"skill_default" = holder.skill_default,
		"attributes" = stats,
		"skills" = skills,
	)

/datum/rogue_attribute_editor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/datum/attribute_holder/holder = target?.resolve()
	if(!holder)
		to_chat(ui.user, span_warning("The attribute holder is gone."))
		qdel(src)
		return
	var/attribute_type = text2path(params["attribute_type"])
	if(attribute_type && !(attribute_type in GLOB.rogue_attributes))
		return
	var/new_value = params["new_value"]
	switch(action)
		if("change_var")
			var/var_name = params["var_name"]
			if(!(var_name in GLOB.rogue_attribute_editor_vars) || !isnum(params["var_value"]))
				return
			holder.vars[var_name] = params["var_value"]
			holder.update_attributes()
		if("null_var")
			var/var_name = params["var_name"]
			if(!(var_name in GLOB.rogue_attribute_editor_vars))
				return
			holder.vars[var_name] = GLOB.rogue_attribute_editor_vars[var_name]
			holder.update_attributes()
		if("change_attribute")
			if(!attribute_type || !isnum(new_value))
				return
			var/datum/attribute_modifier/existing = holder.has_attribute_modifier(ROGUE_ATTRIBUTE_EDITOR_MODIFIER)
			var/list/bonuses = existing ? existing.attribute_list.Copy() : list()
			bonuses[attribute_type] = new_value
			if(!bonuses[attribute_type])
				bonuses -= attribute_type
			holder.set_variable_attribute_modifier(ROGUE_ATTRIBUTE_EDITOR_MODIFIER, bonuses)
		if("null_attribute")
			if(!attribute_type)
				return
			var/datum/attribute_modifier/existing = holder.has_attribute_modifier(ROGUE_ATTRIBUTE_EDITOR_MODIFIER)
			if(!existing)
				return
			var/list/bonuses = existing.attribute_list.Copy()
			bonuses -= attribute_type
			holder.set_variable_attribute_modifier(ROGUE_ATTRIBUTE_EDITOR_MODIFIER, bonuses)
		if("change_raw_attribute")
			if(!attribute_type || !isnum(new_value))
				return
			if(ispath(attribute_type, ROGUE_SKILL))
				holder.set_skill_level(attribute_type, new_value)
			else
				holder.raw_attribute_list[attribute_type] = clamp(new_value, holder.attribute_min, holder.attribute_max)
				holder.update_attributes()
		if("null_raw_attribute")
			if(!attribute_type)
				return
			if(ispath(attribute_type, ROGUE_SKILL))
				holder.apply_skill_level(attribute_type, null, holder.raw_attribute_list[attribute_type], TRUE)
			else
				holder.raw_attribute_list[attribute_type] = holder.attribute_default
				holder.update_attributes()
		else
			return
	log_admin("[key_name(ui.user)] edited the attributes of [holder.parent ? key_name(holder.parent) : "a holder"]: [action] [params["attribute_type"] || params["var_name"]] [isnull(new_value) ? params["var_value"] : new_value]")
	return TRUE
