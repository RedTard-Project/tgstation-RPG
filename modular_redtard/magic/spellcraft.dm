/// Binding a tome (Vibelin items/unfinished_spellbook/): scroll paper on cured hide makes bound scrollpaper, more scroll
/// paper finishes its pages, and the tome in waiting takes a catalyst - a gem or an arcyne meld - and up to six materials.
/// The catalyst decides the tome's rung and how strongly the materials count; each material gives form and technique
/// points and makes the tome's spells of some form or technique cheaper, quicker or stronger (the table at the end, numbers
/// magic_spellcraft_*). Vibelin's screen interface is a browser page here (owner's decision). The one who binds it owns
/// the tome. One untrained in the arcyne only admires a gem, and a meld blows up in their hands. Medieval maps only.
/// Vibelin's magic stones as catalysts are not here: the module's stones have no magic power.

/// Vibelin /obj/item/natural/hide/item_interaction(): scroll paper on cured hide, on a table, starts a tome.
/obj/item/natural/hide/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/paper/scroll) || !rogue_magic_enabled())
		return ..()
	if(!isturf(loc) || !(locate(/obj/structure/table) in loc))
		to_chat(user, span_warning("I need to put [src] on a table to work on it."))
		return ITEM_INTERACT_BLOCKING
	if(!do_after(user, rogue_spellcraft_time(user, "magic_spellcraft_cover_time"), target = src))
		return ITEM_INTERACT_BLOCKING
	playsound(src, ROGUE_TOME_CLOSE_SOUND, 100, TRUE)
	to_chat(user, span_notice("I add the first few pages to the leather cover..."))
	new /obj/item/rogue_spellbook_unfinished(loc)
	qdel(tool)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/// A step of the work, quicker the better versed in the arcyne (Vibelin: time minus five a rank).
/proc/rogue_spellcraft_time(mob/living/user, key)
	return max(0, rogue_value(key) - user.rogue_skill_rank(/datum/attribute/skill/magic/arcane) * rogue_value("magic_spellcraft_time_per_rank"))

/obj/item/rogue_spellbook_unfinished
	name = "bound scrollpaper"
	desc = "Thick scroll paper bound at the spine. It lacks pages."
	icon = ROGUE_TOMES_ICON
	icon_state = "basic_book_0"
	lefthand_file = ROGUE_TOMES_LEFTHAND
	righthand_file = ROGUE_TOMES_RIGHTHAND
	inhand_icon_state = "basic_book_0"
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FLAMMABLE
	rogue_grid_width = 32
	rogue_grid_height = 64
	/// Pages still needed (magic_spellcraft_pages).
	var/pages_left

/obj/item/rogue_spellbook_unfinished/Initialize(mapload)
	. = ..()
	pages_left = rogue_value("magic_spellcraft_pages")

/// Vibelin item_interaction(): a page of scroll paper at a time, on a table.
/obj/item/rogue_spellbook_unfinished/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/paper/scroll))
		return NONE
	if(!isturf(loc) || !(locate(/obj/structure/table) in loc))
		to_chat(user, span_warning("I need to put [src] on a table to work on it."))
		return ITEM_INTERACT_BLOCKING
	if(!do_after(user, rogue_spellcraft_time(user, "magic_spellcraft_page_time"), target = src))
		return ITEM_INTERACT_BLOCKING
	qdel(tool)
	pages_left--
	if(pages_left > 0)
		playsound(src, ROGUE_TOME_PAGE_SOUND, 100, TRUE)
		to_chat(user, span_notice("[pages_left] left..."))
		return ITEM_INTERACT_SUCCESS
	playsound(src, ROGUE_TOME_OPEN_SOUND, 100, TRUE)
	if(user.rogue_skill(/datum/attribute/skill/magic/arcane) > ROGUE_SKILL_LEVEL_NONE)
		to_chat(user, span_notice("The book is bound. I must find a catalyst to channel the arcyne into it now."))
	else
		to_chat(user, span_notice("I've made an empty book of thick, useless scroll paper. I can't even thumb through it!"))
	new /obj/item/rogue_spellbook_unfinished/pre_arcyne(loc)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/// The tome in waiting: the catalyst and the materials lie in it until it is bound or they are taken back.
/obj/item/rogue_spellbook_unfinished/pre_arcyne
	name = "tome in waiting"
	desc = "A fully bound tome of scroll paper. It's lacking a certain arcyne energy."
	icon_state = "spellbook_unfinished"
	var/obj/item/catalyst
	/// Material slots (magic_spellcraft_slots of them), null where empty.
	var/list/materials

/obj/item/rogue_spellbook_unfinished/pre_arcyne/Initialize(mapload)
	. = ..()
	materials = new /list(rogue_value("magic_spellcraft_slots"))

/obj/item/rogue_spellbook_unfinished/pre_arcyne/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	return NONE

/obj/item/rogue_spellbook_unfinished/pre_arcyne/Destroy()
	var/turf/here = get_turf(src)
	for(var/obj/item/held in contents)
		if(here)
			held.forceMove(here)
		else
			qdel(held)
	catalyst = null
	materials = null
	return ..()

/obj/item/rogue_spellbook_unfinished/pre_arcyne/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == catalyst)
		catalyst = null
	var/index = materials?.Find(gone)
	if(index)
		materials[index] = null

/obj/item/rogue_spellbook_unfinished/pre_arcyne/attack_self(mob/user, modifiers)
	. = ..()
	if(.)
		return
	show_page(user)
	return TRUE

/// What a catalyst makes of the tome (Vibelin get_spellcraft_meld_data()): list(book type, amplifier, form points, technique
/// points, shock, unskilled behaviour), or null for one that is not arcyne enough.
/proc/rogue_spellcraft_meld_data(obj/item/item)
	if(istype(item, /obj/item/roguegem/violet))
		return list(/obj/item/rogue_spellbook/expert, rogue_value("magic_spellcraft_meld_violet_amplifier"), 0, 0, 0, "cosmetic")
	if(istype(item, /obj/item/roguegem))
		return list(/obj/item/rogue_spellbook/adept, rogue_value("magic_spellcraft_meld_gem_amplifier"), 0, 0, 0, "cosmetic")
	var/static/list/meld_books = list(
		/obj/item/magic/melded/t1 = list("t1", /obj/item/rogue_spellbook/adept),
		/obj/item/magic/melded/t2 = list("t2", /obj/item/rogue_spellbook/expert),
		/obj/item/magic/melded/t3 = list("t3", /obj/item/rogue_spellbook/master),
		/obj/item/magic/melded/t4 = list("t4", /obj/item/rogue_spellbook/legendary),
		/obj/item/magic/melded/t5 = list("t5", /obj/item/rogue_spellbook/legendary),
	)
	var/list/meld = meld_books[item.type]
	if(!meld)
		return null
	var/key = "magic_spellcraft_meld_[meld[1]]"
	return list(meld[2], rogue_value("[key]_amplifier"), rogue_value("[key]_form_points"), rogue_value("[key]_technique_points"), rogue_value("[key]_shock"), "explode")

/// Lowercase track of the table -> the module's form or technique.
/proc/rogue_spellcraft_track(track)
	var/static/list/tracks = list(
		"arcane" = ROGUE_FORM_ARCANE, "fire" = ROGUE_FORM_FIRE, "water" = ROGUE_FORM_WATER, "ice" = ROGUE_FORM_ICE,
		"earth" = ROGUE_FORM_EARTH, "air" = ROGUE_FORM_AIR, "lightning" = ROGUE_FORM_LIGHTNING, "life" = ROGUE_FORM_LIFE,
		"death" = ROGUE_FORM_DEATH, "blood" = ROGUE_FORM_BLOOD,
		"destruction" = ROGUE_TECHNIQUE_DESTRUCTION, "creation" = ROGUE_TECHNIQUE_CREATION, "summoning" = ROGUE_TECHNIQUE_SUMMONING,
		"restoration" = ROGUE_TECHNIQUE_RESTORATION, "alteration" = ROGUE_TECHNIQUE_ALTERATION, "illusion" = ROGUE_TECHNIQUE_ILLUSION,
		"imbue" = ROGUE_TECHNIQUE_IMBUE,
	)
	return tracks[track]

/// What a material gives, for the page: "Pyromancy +2, Geomancy cost x1.1".
/proc/rogue_spellcraft_summary(obj/item/item)
	var/list/table = rogue_spellcraft_table()
	var/list/entry = table[item.type]
	if(!entry)
		return ""
	var/list/out = list()
	for(var/field_track in entry[2])
		var/field = copytext(field_track, 1, 3)
		var/track = rogue_spellcraft_track(copytext(field_track, 4))
		var/value = rogue_value("magic_spellcraft_[entry[1]]_[field_track]")
		switch(field)
			if("fp", "tp")
				out += "[track] +[value]"
			if("fc", "tc")
				out += "[track] cost x[value]"
			if("fs", "ts")
				out += "[track] speed x[value]"
			else
				out += "[track] power +[value]"
	return jointext(out, ", ")

/// Vibelin's spellcraft star as a browser page: the catalyst in the centre, the materials around it.
/obj/item/rogue_spellbook_unfinished/pre_arcyne/proc/show_page(mob/user)
	var/list/out = list("<h3>Catalyst</h3>")
	if(catalyst)
		out += "[catalyst] <a href='byond://?src=[REF(src)];eject_catalyst=1'>Take back</a>"
	else
		out += "Empty. <a href='byond://?src=[REF(src)];insert_catalyst=1'>Set the held item</a>"
	out += "<h3>Materials</h3><table>"
	for(var/i in 1 to length(materials))
		var/obj/item/material = materials[i]
		if(material)
			out += "<tr><td>[material]</td><td>[rogue_spellcraft_summary(material)]</td><td><a href='byond://?src=[REF(src)];eject_material=[i]'>Take back</a></td></tr>"
		else
			out += "<tr><td>Empty</td><td></td><td><a href='byond://?src=[REF(src)];insert_material=[i]'>Set the held item</a></td></tr>"
	out += "</table>"
	if(catalyst)
		out += "<h3><a href='byond://?src=[REF(src)];assemble=1'>Bind the tome</a></h3>"
	var/datum/browser/popup = new(user, "rogue_spellcraft", "[src]", 600, 500)
	popup.set_content(jointext(out, ""))
	popup.open()

/obj/item/rogue_spellbook_unfinished/pre_arcyne/Topic(href, list/href_list)
	. = ..()
	var/mob/living/user = usr
	if(!istype(user) || user.incapacitated || !IsReachableBy(user) || !rogue_magic_enabled())
		return
	if(href_list["insert_catalyst"])
		insert_catalyst(user)
	else if(href_list["eject_catalyst"])
		if(catalyst)
			user.put_in_hands(catalyst)
	else if(href_list["insert_material"])
		insert_material(user, text2num(href_list["insert_material"]))
	else if(href_list["eject_material"])
		var/index = text2num(href_list["eject_material"])
		if(index >= 1 && index <= length(materials) && materials[index])
			user.put_in_hands(materials[index])
	else if(href_list["assemble"])
		INVOKE_ASYNC(src, PROC_REF(assemble), user)
		return
	if(!QDELETED(src))
		show_page(user)

/obj/item/rogue_spellbook_unfinished/pre_arcyne/proc/insert_catalyst(mob/living/user)
	var/obj/item/item = user.get_active_held_item()
	if(!item || catalyst)
		return
	if(!rogue_spellcraft_meld_data(item))
		to_chat(user, span_warning("[item] doesn't feel arcyne enough to be a catalyst."))
		return
	if(!user.transferItemToLoc(item, src))
		return
	catalyst = item

/obj/item/rogue_spellbook_unfinished/pre_arcyne/proc/insert_material(mob/living/user, index)
	var/obj/item/item = user.get_active_held_item()
	if(!item || index < 1 || index > length(materials) || materials[index])
		return
	var/list/table = rogue_spellcraft_table()
	if(!table[item.type])
		to_chat(user, span_warning("[item] has no arcyne properties."))
		return
	if(!user.transferItemToLoc(item, src))
		return
	materials[index] = item

/// Vibelin assemble(): the catalyst and the materials go into the tome, which is born bound to its maker.
/obj/item/rogue_spellbook_unfinished/pre_arcyne/proc/assemble(mob/living/user)
	if(!catalyst)
		return FALSE
	var/list/meld = rogue_spellcraft_meld_data(catalyst)
	if(!meld)
		return FALSE
	if(!do_after(user, rogue_spellcraft_time(user, "magic_spellcraft_bind_time"), target = src) || !catalyst)
		return FALSE
	if(user.rogue_skill(/datum/attribute/skill/magic/arcane) <= ROGUE_SKILL_LEVEL_NONE)
		if(meld[6] == "cosmetic")
			to_chat(user, span_notice("I press [catalyst] into the cover of the book. What a pretty design this would make!"))
			return FALSE
		user.visible_message(span_warning("[user] sets down [catalyst] upon the surface of [src] and watches expectantly. Without warning, [catalyst] violently explodes!"), span_notice("I should have known messing with the arcyne was dangerous!"))
		user.electrocute_act(meld[5], src)
		QDEL_NULL(catalyst)
		clear_materials()
		return TRUE
	var/amplifier = meld[2]
	var/list/points = list()
	var/list/multipliers = list()
	var/list/additions = list()
	var/list/table = rogue_spellcraft_table()
	for(var/obj/item/material as anything in materials)
		if(!material)
			continue
		var/list/entry = table[material.type]
		if(!entry)
			continue
		for(var/field_track in entry[2])
			var/field = copytext(field_track, 1, 3)
			var/track = rogue_spellcraft_track(copytext(field_track, 4))
			var/value = rogue_value("magic_spellcraft_[entry[1]]_[field_track]")
			var/slot = "[copytext(field, 2)]|[track]"
			switch(field)
				if("fp", "tp")
					points[track] = (points[track] || 0) + value * amplifier
				if("fc", "fs", "tc", "ts")
					multipliers[slot] = (multipliers[slot] || 1) * (1 + (value - 1) * amplifier)
				else
					additions[slot] = (additions[slot] || 0) + value
	user.visible_message(span_warning("[user] imbues [user.p_their()] [catalyst]! It fuses into [src]."), span_notice("I join my arcyne energy with that of [catalyst] in my hands, which shudders briefly before dissolving into motes of energy..."))
	playsound(src, 'modular_redtard/magic/sound/crystal.ogg', 100, TRUE)
	var/turf/here = get_turf(src)
	var/book_type = meld[1]
	var/obj/item/rogue_spellbook/tome = new book_type(here)
	tome.owner_ref = WEAKREF(user)
	var/datum/rogue_spell_mastery/mastery = tome.mastery
	if(meld[3])
		mastery.give_form_points(meld[3])
	if(meld[4])
		mastery.give_technique_points(meld[4])
	// Vibelin keeps a fraction of a rank; ranks are whole here.
	for(var/track in points)
		var/amount = round(points[track])
		if(amount <= 0)
			continue
		if(track in GLOB.rogue_spell_forms)
			mastery.give_form_points(amount, track)
		else
			mastery.give_technique_points(amount, track)
	var/list/tracks = list()
	for(var/slot in multipliers | additions)
		tracks |= copytext(slot, findtext(slot, "|") + 1)
	for(var/track in tracks)
		var/kind = (track in GLOB.rogue_spell_forms) ? ROGUE_SPELLMOD_FORM : ROGUE_SPELLMOD_TECHNIQUE
		tome.add_spell_modifier(kind, track, multipliers["c|[track]"] || 1, multipliers["s|[track]"] || 1, additions["m|[track]"] || 0)
	QDEL_NULL(catalyst)
	clear_materials()
	var/was_held = (loc == user)
	qdel(src)
	if(was_held)
		user.put_in_hands(tome)
	return TRUE

/obj/item/rogue_spellbook_unfinished/pre_arcyne/proc/clear_materials()
	for(var/i in 1 to length(materials))
		var/obj/item/material = materials[i]
		materials[i] = null
		if(material)
			qdel(material)

// GENERATED by vm1v_spellcraft.py - do not edit below

/// Material type -> list(key, list of "<field>_<track>"): what a material gives a tome (Vibelin
/// spellcraft_contributions/*.dm). The numbers are magic_spellcraft_<key>_<field>_<track>; fields: fp, tp (points),
/// fc, fs, tc, ts (cost and cast speed multipliers), fm, tm (magnitude added); f is a form, t a technique.
/proc/rogue_spellcraft_table()
	var/static/list/table
	if(table)
		return table
	table = list()
	var/list/raw = list(
		list(/obj/item/alch/viscera, "alch_viscera", FALSE, list("fm_life", "fp_death")),
		list(/obj/item/alch/coaldust, "alch_coaldust", FALSE, list("fc_fire", "fs_fire")),
		list(/obj/item/alch/silverdust, "alch_silverdust", FALSE, list("fc_ice", "fm_arcane")),
		list(/obj/item/alch/sinew, "alch_sinew", FALSE, list("fp_life", "tp_restoration")),
		list(/obj/item/alch/irondust, "alch_irondust", FALSE, list("fc_earth", "fs_earth")),
		list(/obj/item/alch/tobaccodust, "alch_tobaccodust", FALSE, list("fc_air", "fp_air")),
		list(/obj/item/alch/horn, "alch_horn", FALSE, list("fm_earth", "fp_life")),
		list(/obj/item/alch/golddust, "alch_golddust", FALSE, list("fc_arcane", "fm_earth")),
		list(/obj/item/alch/ozium, "alch_ozium", FALSE, list("fm_arcane", "fp_air")),
		list(/obj/item/alch/transisdust, "alch_transisdust", FALSE, list("fp_arcane", "tp_alteration")),
		list(/obj/item/alch/atropa, "alch_herb_atropa", FALSE, list("fm_death", "fp_life")),
		list(/obj/item/alch/matricaria, "alch_herb_matricaria", FALSE, list("fp_life", "fs_ice")),
		list(/obj/item/alch/symphitum, "alch_herb_symphitum", FALSE, list("fp_life", "tp_restoration")),
		list(/obj/item/alch/taraxacum, "alch_herb_taraxacum", FALSE, list("fp_life", "fs_air")),
		list(/obj/item/alch/euphrasia, "alch_herb_euphrasia", FALSE, list("fp_life", "tp_illusion")),
		list(/obj/item/alch/paris, "alch_herb_paris", FALSE, list("fm_death", "fp_life")),
		list(/obj/item/alch/calendula, "alch_herb_calendula", FALSE, list("fp_life", "tp_restoration")),
		list(/obj/item/alch/mentha, "alch_herb_mentha", FALSE, list("fp_life", "fs_ice")),
		list(/obj/item/alch/urtica, "alch_herb_urtica", FALSE, list("fm_lightning", "fp_life")),
		list(/obj/item/alch/salvia, "alch_herb_salvia", FALSE, list("fp_life", "tp_illusion")),
		list(/obj/item/alch/rosa, "alch_herb_rosa", FALSE, list("fm_death", "fp_life")),
		list(/obj/item/alch/hypericum, "alch_herb_hypericum", FALSE, list("fm_arcane", "fp_life", "tp_restoration")),
		list(/obj/item/alch/benedictus, "alch_herb_benedictus", FALSE, list("fp_life", "tp_restoration")),
		list(/obj/item/alch/valeriana, "alch_herb_valeriana", FALSE, list("fp_life", "fs_ice")),
		list(/obj/item/alch/artemisia, "alch_herb_artemisia", FALSE, list("fp_life", "tp_illusion")),
		list(/obj/item/magic/fae/fairydust, "fairydust", FALSE, list("fc_earth", "fc_lightning", "fp_earth")),
		list(/obj/item/alch/earthdust, "earthdust", FALSE, list("fp_earth", "fs_earth", "fs_lightning")),
		list(/obj/item/magic/fae/iridescentscale, "iridescentscale", FALSE, list("fm_earth", "fm_lightning", "fp_earth")),
		list(/obj/item/magic/fae/heartwoodcore, "heartwoodcore", FALSE, list("fc_earth", "fc_lightning", "fp_earth", "tp_creation")),
		list(/obj/item/magic/fae/sylvanessence, "sylvanessence", FALSE, list("fc_earth", "fc_lightning", "fp_earth", "tp_creation", "tp_imbue")),
		list(/obj/item/natural/stone, "stone", FALSE, list("fc_earth", "fm_earth", "fs_earth")),
		list(/obj/item/natural/rock/elementalmote, "elementalmote", FALSE, list("fc_lightning", "fc_water", "fc_ice", "fc_air", "fc_earth")),
		list(/obj/item/alch/airdust, "airdust", FALSE, list("fp_air")),
		list(/obj/item/alch/waterdust, "waterdust", FALSE, list("fp_water")),
		list(/obj/item/alch/seeddust, "seeddust", FALSE, list("fp_life")),
		list(/obj/item/alch/feaudust, "feaudust", FALSE, list("fp_death")),
		list(/obj/item/alch/magicdust, "magicdust", FALSE, list("fp_arcane")),
		list(/obj/item/alch/runedust, "runedust", FALSE, list("fp_lightning")),
		list(/obj/item/alch/swampdust, "swampdust", FALSE, list("fp_ice")),
		list(/obj/item/alch/firedust, "firedust", FALSE, list("fc_fire", "fm_fire", "fs_fire")),
		list(/obj/item/flint, "flint", FALSE, list("fm_earth", "fp_fire")),
		list(/obj/item/roguegem/blood_diamond, "gem_blood_diamond", FALSE, list("fc_death", "fm_arcane", "fp_death", "tp_destruction", "tp_imbue")),
		list(/obj/item/roguegem/green, "gem_green", FALSE, list("fm_earth", "fp_life")),
		list(/obj/item/roguegem/blue, "gem_blue", FALSE, list("fp_water", "fs_ice")),
		list(/obj/item/roguegem/yellow, "gem_yellow", FALSE, list("fp_lightning", "fs_air")),
		list(/obj/item/roguegem/violet, "gem_violet", FALSE, list("fp_arcane", "tp_alteration")),
		list(/obj/item/roguegem/diamond, "gem_diamond", FALSE, list("fc_arcane", "fp_arcane", "tp_imbue")),
		list(/obj/item/roguegem/ruby, "gem_red", FALSE, list("fm_life", "fp_fire")),
		list(/obj/item/roguegem/vibelin/onyxa, "gem_onyxa", FALSE, list("fc_arcane", "fp_death", "tp_illusion")),
		list(/obj/item/roguegem/vibelin/jade, "gem_jade", FALSE, list("fc_earth", "fp_life")),
		list(/obj/item/roguegem/oyster, "gem_oyster", FALSE, list("fp_water", "tp_illusion")),
		list(/obj/item/roguegem/vibelin/coral, "gem_coral", FALSE, list("fm_life", "fp_water")),
		list(/obj/item/roguegem/vibelin/turq, "gem_turq", FALSE, list("fp_water", "fs_air")),
		list(/obj/item/roguegem/vibelin/amber, "gem_amber", FALSE, list("fm_fire", "fp_earth", "tp_restoration")),
		list(/obj/item/roguegem/vibelin/opal, "gem_opal", FALSE, list("fp_arcane", "tp_illusion")),
		list(/obj/item/roguegem/amethyst, "gem_amethyst", FALSE, list("fp_arcane", "fs_ice", "tp_restoration")),
		list(/obj/item/natural/head, "natural_head", FALSE, list("fp_death")),
		list(/obj/item/natural/head/volf, "natural_head_volf", FALSE, list("fp_death", "fs_air")),
		list(/obj/item/natural/head/saiga, "natural_head_saiga", FALSE, list("fm_earth", "fp_death")),
		list(/obj/item/natural/head/troll, "natural_head_troll", FALSE, list("fm_earth", "fp_death", "tp_restoration")),
		list(/obj/item/natural/head/troll/axe, "natural_head_troll_axe", FALSE, list("fm_fire", "fp_death", "tp_destruction")),
		list(/obj/item/natural/head/troll/cave, "natural_head_troll_cave", FALSE, list("fm_ice", "fp_death", "tp_restoration")),
		list(/obj/item/natural/head/rous, "natural_head_rous", FALSE, list("fm_life", "fp_death")),
		list(/obj/item/natural/head/direbear, "natural_head_direbear", FALSE, list("fm_earth", "fp_death")),
		list(/obj/item/natural/head/fox, "natural_head_fox", FALSE, list("fp_death", "tp_illusion")),
		list(/obj/item/natural/head/mole, "natural_head_mole", FALSE, list("fm_earth", "fp_death")),
		list(/obj/item/skull, "skull", FALSE, list("fp_death")),
		list(/obj/item/bait, "bait", FALSE, list("fm_life", "fp_life")),
		list(/obj/item/bait/sweet, "bait_sweet", FALSE, list("fc_life", "fp_life", "fs_life")),
		list(/obj/item/bait/bloody, "bait_bloody", FALSE, list("fm_death", "fp_life", "tp_summoning")),
		list(/obj/item/natural/feather, "natural_feather", FALSE, list("fp_air", "fs_air")),
		list(/obj/item/natural/feather/infernal, "natural_feather_infernal", FALSE, list("fm_air", "fp_fire", "tp_destruction")),
		list(/obj/item/natural/hide, "natural_hide", FALSE, list("fm_earth", "fp_life")),
		list(/obj/item/natural/hide/cured, "natural_hide_cured", FALSE, list("fc_life", "fp_life", "tp_restoration")),
		list(/obj/item/natural/cured/essence, "natural_cured_essence", FALSE, list("fm_arcane", "fp_life", "tp_restoration")),
		list(/obj/item/natural/fur, "natural_fur", FALSE, list("fp_life")),
		list(/obj/item/natural/fur/mole, "natural_fur_mole", FALSE, list("fm_earth", "fp_life")),
		list(/obj/item/natural/fur/direbear, "natural_fur_direbear", FALSE, list("fm_earth", "fp_life")),
		list(/obj/item/natural/fur/fox, "natural_fur_fox", FALSE, list("fp_life", "tp_illusion")),
		list(/obj/item/natural/fur/raccoon, "natural_fur_raccoon", FALSE, list("fp_life", "tp_alteration")),
		list(/obj/item/natural/fur/bobcat, "natural_fur_bobcat", FALSE, list("fp_life", "fs_air")),
		list(/obj/item/natural/brick, "natural_brick", FALSE, list("fc_earth", "fp_earth")),
		list(/obj/item/natural/glass, "natural_glass", FALSE, list("fm_fire", "fp_earth", "tc_illusion", "tp_illusion")),
		list(/obj/item/natural/poo, "natural_poo", TRUE, list("fm_earth", "fp_life")),
		list(/obj/item/natural/worms, "natural_worms", FALSE, list("fm_death", "fp_life")),
		list(/obj/item/natural/worms/leech, "natural_worms_leech", FALSE, list("fm_life", "fp_death")),
		list(/obj/item/natural/worms/leech/parasite, "natural_worms_leech_parasite", FALSE, list("fp_death", "tp_destruction")),
		list(/obj/item/natural/worms/leech/abyssoid, "natural_worms_leech_abyssoid", FALSE, list("fm_arcane", "fp_death", "tp_summoning", "tp_destruction")),
		list(/obj/item/natural/teeth, "natural_teeth", FALSE, list("fp_death", "fs_death")),
		list(/obj/item/natural/teeth/gold, "natural_teeth_gold", FALSE, list("fc_arcane", "fm_earth", "fp_death")),
		list(/obj/item/natural/teeth/fang, "natural_teeth_fang", FALSE, list("fc_death", "fp_death")),
		list(/obj/item/rogueore/gold, "ore_gold", FALSE, list("fc_arcane", "fp_earth")),
		list(/obj/item/rogueore/silver, "ore_silver", FALSE, list("fp_earth", "fs_ice")),
		list(/obj/item/rogueore/iron, "ore_iron", FALSE, list("fp_earth")),
		list(/obj/item/rogueore/copper, "ore_copper", FALSE, list("fp_earth", "fs_lightning")),
		list(/obj/item/rogueore/tin, "ore_tin", FALSE, list("fp_earth", "fs_air")),
		list(/obj/item/rogueore/coal, "ore_coal", FALSE, list("fm_fire", "fp_earth")),
		list(/obj/item/rogueore/coal/charcoal, "ore_coal_charcoal", FALSE, list("fc_fire", "fp_fire")),
		list(/obj/item/rogueore/cinnabar, "ore_cinnabar", FALSE, list("fm_arcane", "fp_fire")),
		list(/obj/item/ingot/gold, "ingot_gold", FALSE, list("fc_arcane", "fp_earth")),
		list(/obj/item/ingot/iron, "ingot_iron", FALSE, list("fc_earth", "fp_earth")),
		list(/obj/item/ingot/copper, "ingot_copper", FALSE, list("fp_earth", "fs_lightning")),
		list(/obj/item/ingot/tin, "ingot_tin", FALSE, list("fp_earth", "fs_air")),
		list(/obj/item/ingot/bronze, "ingot_bronze", FALSE, list("fm_fire", "fp_earth")),
		list(/obj/item/ingot/silver, "ingot_silver", FALSE, list("fp_earth", "fs_ice", "tp_restoration")),
		list(/obj/item/ingot/steel, "ingot_steel", FALSE, list("fc_earth", "fp_earth")),
		list(/obj/item/ingot/steelholy, "ingot_steelholy", FALSE, list("fm_life", "fp_earth", "tp_restoration")),
		list(/obj/item/ingot/silverblessed, "ingot_silverblessed", FALSE, list("fp_life", "fs_ice", "tp_restoration")),
		list(/obj/item/ingot/blacksteel, "ingot_blacksteel", FALSE, list("fm_death", "fp_earth", "tp_destruction")),
		list(/obj/item/ingot/aalloy, "ingot_aalloy", FALSE, list("fm_arcane", "fp_earth")),
		list(/obj/item/ingot/purifiedaalloy, "ingot_purifiedaalloy", FALSE, list("fc_arcane", "fp_arcane", "tp_alteration")),
		list(/obj/item/ingot/aaslag, "ingot_aaslag", FALSE, list("fm_arcane", "fp_earth")),
		list(/obj/item/ingot/weeping, "ingot_weeping", FALSE, list("fm_death", "fp_water", "tp_restoration")),
		list(/obj/item/ingot/draconic, "ingot_draconic", FALSE, list("fm_arcane", "fp_fire", "tp_destruction", "tp_imbue")),
		list(/obj/item/ingot/avantyne, "ingot_avantyne", FALSE, list("fm_arcane", "fp_air")),
		list(/obj/item/ingot/ketryl, "ingot_ketryl", FALSE, list("fm_arcane", "fp_lightning")),
		list(/obj/item/ingot/lithmyc, "ingot_lithmyc", FALSE, list("fm_arcane", "fp_ice")),
		list(/obj/item/ingot/component/glutcrystal, "ingot_component_glutcrystal", FALSE, list("fp_arcane", "tp_creation")),
		list(/obj/item/ingot/component/threadavantyne, "ingot_component_threadavantyne", FALSE, list("fp_air", "tp_creation")),
		list(/obj/item/ingot/component/threadketryl, "ingot_component_threadketryl", FALSE, list("fp_lightning", "tp_creation")),
		list(/obj/item/ingot/component/zizo, "ingot_component_zizo", FALSE, list("fp_arcane", "tp_summoning")),
		list(/obj/item/ingot/component/graggar, "ingot_component_graggar", FALSE, list("fp_earth", "tp_creation")),
		list(/obj/item/ingot/component/matthios, "ingot_component_matthios", FALSE, list("fp_life", "tp_restoration")),
		list(/obj/item/ingot/component/baotha, "ingot_component_baotha", FALSE, list("fp_water", "tp_creation")),
		list(/obj/item/quicksilver, "quicksilver", FALSE, list("fm_water", "fp_arcane", "tp_illusion")),
		list(/obj/item/magic/voidstone, "voidstone", FALSE, list("tp_destruction", "tp_creation", "tp_alteration", "tp_summoning", "tp_restoration")),
		list(/obj/item/alch/bone, "bone", FALSE, list("fc_death", "fc_life")),
		list(/obj/item/riddleofsteel, "riddleofsteel", FALSE, list("fp_earth", "tp_creation", "tp_destruction")),
		list(/obj/item/mimictrinket, "mimictrinket", FALSE, list("fp_arcane", "tp_illusion", "tp_summoning")),
		list(/obj/item/magic/leyline, "natural_leyline", FALSE, list("fc_arcane", "fp_arcane", "tp_creation", "tp_restoration")),
		list(/obj/item/magic/artifact, "natural_artifact", FALSE, list("fc_arcane", "fp_arcane", "tp_alteration", "tp_imbue")),
	)
	for(var/list/row as anything in raw)
		var/list/entry = list(row[2], row[4])
		if(row[3])
			for(var/sub in typesof(row[1]))
				if(!table[sub])
					table[sub] = entry
		else
			table[row[1]] = entry
	return table
