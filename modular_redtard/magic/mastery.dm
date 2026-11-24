/// Vibelin's spell mastery (datums/mana/mastery/_base.dm, _ui.dm): how a magic user learns spells. Points come from the role,
/// a spellbook, a teacher or an admin, in two pools: form points rank up forms (what the spell is made of: Pyromancy,
/// Geomancy...), technique points rank up techniques (what it does: Destruction, Restoration...). Every rank of a track is
/// one spell bought in that track: a spell of form F and technique T costs one spendable point of F and one of T, and the
/// rank of its form must reach the spell's required_level. A spell without form and technique is not bought here: roles
/// and admins give it outright. Unlearning gives the points back. The book is opened with the "Spellbook" verb.
/datum/rogue_spell_mastery
	var/mob/living/carbon/human/holder
	/// Track (technique or form text) -> rank.
	var/list/technique_levels = list()
	var/list/form_levels = list()
	/// Points not yet put into a track (Vibelin unspent_*_points), and every point ever given (initial_*_points).
	var/unspent_form_points = 0
	var/unspent_technique_points = 0
	var/earned_form_points = 0
	var/earned_technique_points = 0
	/// Spell types learned here -> the spell given for it.
	var/list/learned = list()
	/// The role's points were given (points.dm): a job and its class both spawning the mage give them once.
	var/role_points_given = FALSE

/datum/rogue_spell_mastery/New(mob/living/carbon/human/new_holder)
	. = ..()
	holder = new_holder
	holder.rogue_spell_mastery = src
	RegisterSignal(holder, COMSIG_QDELETING, PROC_REF(on_holder_deleted))
	add_verb(holder, /mob/living/carbon/human/proc/rogue_open_spellbook)

/datum/rogue_spell_mastery/Destroy(force)
	for(var/spell_type in learned)
		var/datum/action/cooldown/spell/spell = learned[spell_type]
		if(!QDELETED(spell))
			qdel(spell)
	learned = null
	if(holder)
		UnregisterSignal(holder, COMSIG_QDELETING)
		remove_verb(holder, /mob/living/carbon/human/proc/rogue_open_spellbook)
		holder.rogue_spell_mastery = null
		holder = null
	return ..()

/datum/rogue_spell_mastery/proc/on_holder_deleted(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/rogue_spell_mastery/proc/form_level(form)
	return form ? (form_levels[form] || 0) : 0

/datum/rogue_spell_mastery/proc/technique_level(technique)
	return technique ? (technique_levels[technique] || 0) : 0

/// Points of a track left for spells (Vibelin spendable_*_points): its rank minus the spells learned in it.
/datum/rogue_spell_mastery/proc/spendable_form(form)
	. = form_level(form)
	for(var/datum/action/cooldown/spell/rogue/spell_type as anything in learned)
		if(initial(spell_type.required_form) == form)
			. -= 1

/datum/rogue_spell_mastery/proc/spendable_technique(technique)
	. = technique_level(technique)
	for(var/datum/action/cooldown/spell/rogue/spell_type as anything in learned)
		if(initial(spell_type.required_technique) == technique)
			. -= 1

/// Vibelin adjust_form_mastery_points(): points to put into forms, or straight into one form's rank.
/datum/rogue_spell_mastery/proc/give_form_points(points, form)
	earned_form_points = max(0, earned_form_points + points)
	if(form)
		form_levels[form] = max(0, form_level(form) + points)
	else
		unspent_form_points = max(0, unspent_form_points + points)

/datum/rogue_spell_mastery/proc/give_technique_points(points, technique)
	earned_technique_points = max(0, earned_technique_points + points)
	if(technique)
		technique_levels[technique] = max(0, technique_level(technique) + points)
	else
		unspent_technique_points = max(0, unspent_technique_points + points)

/// Vibelin invest_form(): a free point ranks a form up. Hemomancy only for those versed in blood (Vibelin TRAIT_VITAE_USER).
/datum/rogue_spell_mastery/proc/invest_form(form)
	if(!(form in GLOB.rogue_spell_forms) || unspent_form_points < 1)
		return FALSE
	if(form == ROGUE_FORM_BLOOD && holder.rogue_skill_rank(/datum/attribute/skill/magic/blood) < 1)
		to_chat(holder, span_warning("I am not an adept enough blood mage to wield this unholy power."))
		return FALSE
	unspent_form_points--
	form_levels[form] = form_level(form) + 1
	return TRUE

/datum/rogue_spell_mastery/proc/invest_technique(technique)
	if(!(technique in GLOB.rogue_spell_techniques) || unspent_technique_points < 1)
		return FALSE
	unspent_technique_points--
	technique_levels[technique] = technique_level(technique) + 1
	return TRUE

/// Vibelin can_learn_spell().
/datum/rogue_spell_mastery/proc/can_learn(datum/action/cooldown/spell/rogue/spell_type)
	if(!ispath(spell_type, /datum/action/cooldown/spell/rogue) || (spell_type in learned) || !initial(spell_type.learnable))
		return FALSE
	var/form = initial(spell_type.required_form)
	var/technique = initial(spell_type.required_technique)
	if(!form && !technique)
		return FALSE
	if(form && spendable_form(form) < 1)
		return FALSE
	if(technique && spendable_technique(technique) < 1)
		return FALSE
	var/level = initial(spell_type.required_level)
	if(level > 0 && form && form_level(form) < level)
		return FALSE
	var/datum/action/cooldown/spell/rogue/prototype = rogue_spell_prototype(spell_type)
	for(var/needed in prototype.prerequisite_spells)
		if(!(needed in learned))
			return FALSE
	return TRUE

/// Vibelin try_learn_spell(): the spell is given at once.
/datum/rogue_spell_mastery/proc/learn(spell_type)
	if(!can_learn(spell_type))
		return FALSE
	var/datum/action/cooldown/spell/rogue/spell = new spell_type(holder.mind || holder)
	spell.Grant(holder)
	learned[spell_type] = spell
	to_chat(holder, span_nicegreen("I learnt [spell.name]!"))
	return TRUE

/// Vibelin try_unlearn_spell(): the points of the spell come back.
/datum/rogue_spell_mastery/proc/unlearn(spell_type)
	if(!(spell_type in learned))
		return FALSE
	var/datum/action/cooldown/spell/spell = learned[spell_type]
	learned -= spell_type
	if(!QDELETED(spell))
		to_chat(holder, span_boldwarning("I forgot [spell.name]!"))
		qdel(spell)
	return TRUE

/// Vibelin GLOB.mastery_rank_names.
/proc/rogue_mastery_rank_name(level)
	if(level >= ROGUE_MASTERY_RANK_MASTER)
		return "Master"
	if(level >= ROGUE_MASTERY_RANK_EXPERT)
		return "Expert"
	if(level >= ROGUE_MASTERY_RANK_ADEPT)
		return "Adept"
	return "Novice"

/// The spellbook (Vibelin's tgui SpellBook as a browser page): tracks with their ranks and free points, the spells of the
/// basket that a form and technique buy, each with what it needs.
/datum/rogue_spell_mastery/proc/show_book(mob/user = holder)
	var/list/out = list("<h3>Free points: [unspent_form_points] form, [unspent_technique_points] technique</h3>")
	out += "<table><tr><th>Form</th><th>Rank</th><th>For spells</th><th></th></tr>"
	for(var/form in GLOB.rogue_spell_forms)
		out += "<tr><td><font color='[GLOB.rogue_spell_form_colors[form]]'>[form]</font></td><td>[form_level(form)] ([rogue_mastery_rank_name(form_level(form))])</td><td>[spendable_form(form)]</td><td>[unspent_form_points ? "<a href='byond://?src=[REF(src)];invest_form=[form]'>+1</a>" : ""]</td></tr>"
	out += "</table><table><tr><th>Technique</th><th>Rank</th><th>For spells</th><th></th></tr>"
	for(var/technique in GLOB.rogue_spell_techniques)
		out += "<tr><td>[technique]</td><td>[technique_level(technique)] ([rogue_mastery_rank_name(technique_level(technique))])</td><td>[spendable_technique(technique)]</td><td>[unspent_technique_points ? "<a href='byond://?src=[REF(src)];invest_technique=[technique]'>+1</a>" : ""]</td></tr>"
	out += "</table><h3>Spells</h3><table><tr><th>Spell</th><th>Form</th><th>Technique</th><th>Form rank</th><th></th></tr>"
	for(var/datum/action/cooldown/spell/rogue/spell_type as anything in rogue_spell_basket())
		if(!initial(spell_type.learnable) || !initial(spell_type.required_form))
			continue
		var/action = ""
		if(spell_type in learned)
			action = "<a href='byond://?src=[REF(src)];unlearn=[spell_type]'>Forget</a>"
		else if(can_learn(spell_type))
			action = "<a href='byond://?src=[REF(src)];learn=[spell_type]'>Learn</a>"
		out += "<tr><td title='[html_encode(initial(spell_type.desc))]'>[initial(spell_type.name)]</td><td>[initial(spell_type.required_form)]</td><td>[initial(spell_type.required_technique)]</td><td>[initial(spell_type.required_level)]</td><td>[action]</td></tr>"
	out += "</table>"
	var/datum/browser/popup = new(user, "rogue_spellbook", "Spellbook", 700, 700)
	popup.set_content(jointext(out, ""))
	popup.open()

/datum/rogue_spell_mastery/Topic(href, list/href_list)
	. = ..()
	if(usr != holder || QDELETED(holder))
		return
	if(href_list["invest_form"])
		invest_form(href_list["invest_form"])
	else if(href_list["invest_technique"])
		invest_technique(href_list["invest_technique"])
	else if(href_list["learn"])
		learn(text2path(href_list["learn"]))
	else if(href_list["unlearn"])
		unlearn(text2path(href_list["unlearn"]))
	show_book()

/mob/living/carbon/human
	var/datum/rogue_spell_mastery/rogue_spell_mastery

/mob/living/carbon/human/proc/rogue_get_spell_mastery()
	RETURN_TYPE(/datum/rogue_spell_mastery)
	if(!rogue_spell_mastery && rogue_magic_enabled())
		new /datum/rogue_spell_mastery(src)
	return rogue_spell_mastery

/// Vibelin /mob/living/adjust_form_mastery_points(): points for the book; the first ones make a magic user.
/mob/living/carbon/human/proc/rogue_give_spell_points(form_points = 0, technique_points = 0, form, technique)
	var/datum/rogue_spell_mastery/mastery = rogue_get_spell_mastery()
	if(!mastery)
		return FALSE
	if(form_points)
		mastery.give_form_points(form_points, form)
	if(technique_points)
		mastery.give_technique_points(technique_points, technique)
	if(form_points > 0)
		rogue_attune_magic()
	return TRUE

/mob/living/carbon/human/proc/rogue_open_spellbook()
	set name = "Spellbook"
	set category = "IC"
	set desc = "The forms and techniques of the arcyne I know, and the spells they let me learn."
	var/datum/rogue_spell_mastery/mastery = rogue_get_spell_mastery()
	mastery?.show_book(src)

GLOBAL_LIST_INIT(rogue_spell_techniques, list(
	ROGUE_TECHNIQUE_DESTRUCTION,
	ROGUE_TECHNIQUE_CREATION,
	ROGUE_TECHNIQUE_SUMMONING,
	ROGUE_TECHNIQUE_RESTORATION,
	ROGUE_TECHNIQUE_ALTERATION,
	ROGUE_TECHNIQUE_ILLUSION,
	ROGUE_TECHNIQUE_IMBUE,
))

GLOBAL_LIST_INIT(rogue_spell_forms, list(
	ROGUE_FORM_ARCANE,
	ROGUE_FORM_FIRE,
	ROGUE_FORM_WATER,
	ROGUE_FORM_ICE,
	ROGUE_FORM_EARTH,
	ROGUE_FORM_AIR,
	ROGUE_FORM_LIGHTNING,
	ROGUE_FORM_LIFE,
	ROGUE_FORM_DEATH,
	ROGUE_FORM_BLOOD,
))

/// Vibelin GLOB.form_colors: the colour of a form's spells, their charge glow and the attunement of a staff.
GLOBAL_LIST_INIT(rogue_spell_form_colors, list(
	ROGUE_FORM_FIRE = "#FF4500",
	ROGUE_FORM_ICE = "#00BFFF",
	ROGUE_FORM_LIGHTNING = "#FFD700",
	ROGUE_FORM_WATER = "#00158b",
	ROGUE_FORM_LIFE = "#32CD32",
	ROGUE_FORM_DEATH = "#800080",
	ROGUE_FORM_EARTH = "#8B4513",
	ROGUE_FORM_AIR = "#C0C0C0",
	ROGUE_FORM_ARCANE = "#9932CC",
	ROGUE_FORM_BLOOD = "#8a0303",
))
