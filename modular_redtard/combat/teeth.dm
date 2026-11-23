/// Vibelin's teeth (modules/surgery/bodyparts/mouth.dm, datums/wounds/teeth.dm, datums/speech_modifiers/lisp.dm, the
/// operations extract_tooth.dm and fix_teeth.dm) on the head of a medieval body: TG has no jaw part, so the head holds the
/// teeth, counted by kind (rogue_teeth). A blow of the breaking kind to the mouth may knock teeth out (the crit
/// /datum/wound/rogue/teeth, rolled with the others by combat/crits.dm), and they fall about as teeth one can pick up; a mouth
/// short of teeth lisps, by how many it lacks, bites weaker, and shows it to one who looks close. A surgeon pulls a tooth out
/// with tongs or a hemostat and puts teeth back in, one or a pile (gold teeth too). The crit and the operations only ever
/// happen on medieval bodies (TRAIT_ROGUE_WOUNDS, the rogue_surgery element); modern maps keep TG's heads.

// --- The teeth as things.

/// Vibelin /obj/item/natural/teeth: a tooth.
/obj/item/natural/teeth
	name = "tooth"
	desc = "A tooth."
	icon = 'modular_redtard/items_vibelin/icons/icons/obj/surgery.dmi'
	icon_state = "tooth_4"
	w_class = WEIGHT_CLASS_TINY
	force = 0
	throwforce = 0
	/// The icon states it is drawn with, one picked (Vibelin icon_state_variation).
	var/list/rogue_icon_states = list("tooth_1", "tooth_2", "tooth_3", "tooth_4")
	/// The pile it makes with others of its kind.
	var/rogue_pile_type = /obj/item/natural/bundle/teeth

/obj/item/natural/teeth/Initialize(mapload)
	. = ..()
	if(length(rogue_icon_states))
		icon_state = pick(rogue_icon_states)

/// Vibelin /obj/item/natural/teeth/gold: a golden tooth, put in as any other.
/obj/item/natural/teeth/gold
	name = "gold tooth"
	desc = "A golden tooth."
	icon_state = "gold_tooth"
	rogue_icon_states = null
	rogue_pile_type = /obj/item/natural/bundle/teeth/gold

/// Vibelin /obj/item/natural/teeth/fang: a fang, which bites harder from a jaw.
/obj/item/natural/teeth/fang
	name = "fang"
	desc = "A bloody fang."
	icon_state = "fang_1"
	rogue_icon_states = null
	rogue_pile_type = /obj/item/natural/bundle/teeth/fang

/// Vibelin do_knock_out_animation(): a tooth knocked out spins and shrinks as it flies.
/obj/item/natural/teeth/proc/rogue_knock_out_animation()
	var/matrix/old_transform = matrix(transform)
	transform = transform.Scale(2, 2)
	transform = transform.Turn(rand(0, 360))
	animate(src, transform = old_transform, time = 5)

/// Teeth of a kind put together make a pile (Vibelin bundles them so).
/obj/item/natural/teeth/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(tool.type == type)
		var/obj/item/natural/bundle/teeth/pile = new rogue_pile_type(drop_location())
		pile.rogue_amount = 2
		pile.update_appearance()
		qdel(tool)
		qdel(src)
		user.put_in_hands(pile)
		to_chat(user, span_notice("I put the teeth together."))
		return ITEM_INTERACT_SUCCESS
	if(istype(tool, /obj/item/natural/bundle/teeth))
		var/obj/item/natural/bundle/teeth/pile = tool
		if(pile.rogue_tooth_type == type && pile.rogue_add(1))
			qdel(src)
			to_chat(user, span_notice("I add the tooth to [pile]."))
			return ITEM_INTERACT_SUCCESS
	return ..()

/// Vibelin /obj/item/natural/bundle/teeth: a pile of teeth of one kind.
/obj/item/natural/bundle/teeth
	name = "pile of teeth"
	desc = "A digusting pile of bleeding teeth."
	icon = 'modular_redtard/items_vibelin/icons/icons/obj/surgery.dmi'
	icon_state = "tooth1"
	w_class = WEIGHT_CLASS_TINY
	firefuel = 0
	/// The tooth it is a pile of, and how many.
	var/rogue_tooth_type = /obj/item/natural/teeth
	var/rogue_amount = 2
	/// Vibelin icon1 and icon2: drawn as a few, or as many from ten on.
	var/rogue_icon_few = "tooth1"
	var/rogue_icon_many = "tooth2"

/obj/item/natural/bundle/teeth/gold
	name = "pile of gold teeth"
	desc = "A digusting pile of gold teeth."
	color = COLOR_ASSEMBLY_GOLD
	rogue_tooth_type = /obj/item/natural/teeth/gold

/obj/item/natural/bundle/teeth/fang
	name = "pile of fangs"
	desc = "A digusting pile of bleeding fangs."
	icon_state = "fang1"
	rogue_tooth_type = /obj/item/natural/teeth/fang
	rogue_icon_few = "fang1"
	rogue_icon_many = "fang2"

/obj/item/natural/bundle/teeth/update_icon_state()
	icon_state = rogue_amount >= 10 ? rogue_icon_many : rogue_icon_few
	return ..()

/obj/item/natural/bundle/teeth/examine(mob/user)
	. = ..()
	. += span_notice("There [rogue_amount == 1 ? "is" : "are"] [rogue_amount] in it.")

/// Adds teeth to the pile up to a full mouth of them; returns how many it took.
/obj/item/natural/bundle/teeth/proc/rogue_add(amount)
	var/taken = clamp(rogue_teeth_max() - rogue_amount, 0, amount)
	if(taken > 0)
		rogue_amount += taken
		update_appearance()
	return taken

/// Takes teeth off the pile; the pile is gone when none are left. Returns how many it gave.
/obj/item/natural/bundle/teeth/proc/rogue_take(amount)
	var/given = clamp(amount, 0, rogue_amount)
	rogue_amount -= given
	if(rogue_amount <= 0)
		qdel(src)
	else
		update_appearance()
	return given

/// A pile takes teeth of its kind, a pile of its kind too.
/obj/item/natural/bundle/teeth/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(tool.type == rogue_tooth_type)
		if(!rogue_add(1))
			to_chat(user, span_warning("[src] can hold no more."))
			return ITEM_INTERACT_BLOCKING
		qdel(tool)
		to_chat(user, span_notice("I add the tooth to [src]."))
		return ITEM_INTERACT_SUCCESS
	if(istype(tool, /obj/item/natural/bundle/teeth))
		var/obj/item/natural/bundle/teeth/other = tool
		if(other.rogue_tooth_type != rogue_tooth_type)
			return ..()
		var/taken = rogue_add(other.rogue_amount)
		if(!taken)
			to_chat(user, span_warning("[src] can hold no more."))
			return ITEM_INTERACT_BLOCKING
		other.rogue_take(taken)
		to_chat(user, span_notice("I put the teeth together."))
		return ITEM_INTERACT_SUCCESS
	return ..()

/// A tooth is taken from the pile into the other hand; the last two part into two teeth.
/obj/item/natural/bundle/teeth/attack_self(mob/user, modifiers)
	. = ..()
	if(.)
		return
	var/turf/spot = drop_location()
	var/obj/item/natural/teeth/tooth = new rogue_tooth_type(spot)
	if(rogue_amount <= 2)
		var/obj/item/natural/teeth/last = new rogue_tooth_type(spot)
		qdel(src)
		user.put_in_hands(last)
	else
		rogue_take(1)
	user.put_in_hands(tooth)
	return TRUE

/// The most teeth a mouth holds (Vibelin max_teeth), and a pile.
/proc/rogue_teeth_max()
	var/static/most
	var/static/revision = -1
	if(revision != rogue_mechanics_revision())
		most = rogue_value("teeth_max")
		revision = rogue_mechanics_revision()
	return most

// --- The teeth of a head.

/obj/item/bodypart/head
	/// Vibelin jaw teeth: how many teeth of each kind the mouth holds (tooth type = count); null while it holds its full set
	/// of rogue_tooth_kind and nothing ever touched them.
	var/list/rogue_teeth
	/// The kind of tooth the mouth grows with (Vibelin default_tooth).
	var/rogue_tooth_kind = /obj/item/natural/teeth

/// The teeth of the mouth by kind, its full set first counted out when nothing has touched them yet.
/obj/item/bodypart/head/proc/rogue_teeth_counts()
	if(isnull(rogue_teeth))
		rogue_teeth = list()
		rogue_teeth[rogue_tooth_kind] = rogue_teeth_max()
	return rogue_teeth

/// Vibelin get_teeth_amount(): how many teeth the mouth holds.
/obj/item/bodypart/head/proc/rogue_teeth_amount()
	if(isnull(rogue_teeth))
		return rogue_teeth_max()
	. = 0
	for(var/kind in rogue_teeth)
		. += rogue_teeth[kind]

/// Takes one tooth from the mouth, of a kind picked by how many of each it holds; returns its kind, or null.
/obj/item/bodypart/head/proc/rogue_take_tooth()
	var/list/counts = rogue_teeth_counts()
	if(!length(counts))
		return null
	var/kind = pick_weight(counts)
	if(!kind)
		return null
	counts[kind] -= 1
	if(counts[kind] <= 0)
		counts -= kind
	return kind

/// Vibelin knock_out_teeth(): teeth fly out of the mouth, thrown a tile or two each way or one way (direction), as teeth on the
/// ground. Returns how many came out.
/obj/item/bodypart/head/proc/rogue_knock_out_teeth(amount = 1, direction = NONE, range = -1)
	if(SSticker.current_state < GAME_STATE_PLAYING || amount <= 0)
		return 0
	var/turf/spot = get_turf(src)
	. = 0
	for(var/i in 1 to amount)
		var/kind = rogue_take_tooth()
		if(!kind)
			break
		. += 1
		if(!spot)
			continue
		var/obj/item/natural/teeth/tooth = new kind(spot)
		tooth.rogue_knock_out_animation()
		var/throw_dir = direction || pick(GLOB.alldirs)
		var/throw_range = range < 0 ? rand(1, 2) : range
		INVOKE_ASYNC(tooth, TYPE_PROC_REF(/atom/movable, throw_at), get_ranged_target_turf(spot, throw_dir, throw_range), throw_range, rand(1, 3))
	if(.)
		rogue_update_teeth()

/// Vibelin remove_teeth(): teeth leave the mouth without falling out (they rot away, they are pulled for good). Returns how
/// many it lost.
/obj/item/bodypart/head/proc/rogue_remove_teeth(amount = 1)
	. = 0
	for(var/i in 1 to amount)
		if(!rogue_take_tooth())
			break
		. += 1
	if(.)
		rogue_update_teeth()

/// Vibelin insert_teeth: teeth of the kind go into the mouth, as many as there is room for. Returns how many went in.
/obj/item/bodypart/head/proc/rogue_add_teeth(kind, amount = 1)
	var/room = rogue_teeth_max() - rogue_teeth_amount()
	var/added = clamp(amount, 0, room)
	if(!added || !ispath(kind, /obj/item/natural/teeth))
		return 0
	var/list/counts = rogue_teeth_counts()
	counts[kind] += added
	rogue_update_teeth()
	return added

/// Vibelin update_teeth(): the body lisps and shows the gaps while teeth are missing.
/obj/item/bodypart/head/proc/rogue_update_teeth()
	if(!owner)
		return
	if(rogue_teeth_amount() < rogue_teeth_max())
		owner.apply_status_effect(/datum/status_effect/rogue_missing_teeth)
	else
		owner.remove_status_effect(/datum/status_effect/rogue_missing_teeth)

/// A head put on a body brings its gaps with it. TG calls this before update_owner(): owner is still empty, so the new
/// body is told by itself (review VR2r, finding 8).
/obj/item/bodypart/head/on_adding(mob/living/carbon/new_owner)
	. = ..()
	if(!isnull(rogue_teeth) && new_owner && rogue_teeth_amount() < rogue_teeth_max())
		new_owner.apply_status_effect(/datum/status_effect/rogue_missing_teeth)

/obj/item/bodypart/head/on_removal(mob/living/carbon/old_owner)
	. = ..()
	old_owner?.remove_status_effect(/datum/status_effect/rogue_missing_teeth)

/// Vibelin mouth update_limb_efficiency(): the jaw works as well as its crits leave it (those of the mouth: a broken jaw, a cut
/// tongue) and as full as its teeth are, in percent.
/obj/item/bodypart/head/proc/rogue_jaw_efficiency()
	. = 100
	for(var/datum/wound/rogue/crit in wounds)
		if(BODY_ZONE_PRECISE_MOUTH in crit.viable_zones)
			. -= crit.limb_efficiency_reduction
	var/most = rogue_teeth_max()
	if(most > 0)
		. -= 100 * (1 - rogue_teeth_amount() / most)
	. = max(0, CEILING(., 1))

/// Vibelin get_fang_bonus(): the fangs of the jaw add to its bite.
/obj/item/bodypart/head/proc/rogue_fang_bonus()
	if(isnull(rogue_teeth))
		return ispath(rogue_tooth_kind, /obj/item/natural/teeth/fang) ? rogue_teeth_max() * rogue_value("teeth_fang_bite_bonus") : 0
	. = 0
	for(var/kind in rogue_teeth)
		if(ispath(kind, /obj/item/natural/teeth/fang))
			. += rogue_teeth[kind] * rogue_value("teeth_fang_bite_bonus")

/// Vibelin get_bite_damage(): a bite of a medieval body bites as hard as its jaw works, and harder for its fangs. Elsewhere,
/// or without a head, the damage is as it was.
/mob/living/carbon/proc/rogue_bite_damage(damage)
	if(!HAS_TRAIT(src, TRAIT_ROGUE_WOUNDS))
		return damage
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	if(!istype(head))
		return damage
	return damage * head.rogue_jaw_efficiency() / 100 + head.rogue_fang_bonus()

// --- A mouth short of teeth.

/// Vibelin /datum/speech_modifier/lisp: the fewer teeth, the more the speech lisps; one looking close sees the gaps. It goes
/// once the mouth is full again.
/datum/status_effect/rogue_missing_teeth
	id = "rogue_missing_teeth"
	duration = STATUS_EFFECT_PERMANENT
	tick_interval = STATUS_EFFECT_NO_TICK
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null

/datum/status_effect/rogue_missing_teeth/on_apply()
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(on_say))
	RegisterSignal(owner, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	return TRUE

/datum/status_effect/rogue_missing_teeth/on_remove()
	UnregisterSignal(owner, list(COMSIG_MOB_SAY, COMSIG_ATOM_EXAMINE))

/// The head of the body, while it still has one.
/datum/status_effect/rogue_missing_teeth/proc/rogue_head()
	var/mob/living/carbon/body = owner
	return istype(body) ? body.get_bodypart(BODY_ZONE_HEAD) : null

/// Vibelin lisp handle_speech(): each sound lisps by the share of teeth missing; the Russian ones as well.
/datum/status_effect/rogue_missing_teeth/proc/on_say(datum/source, list/speech_args)
	SIGNAL_HANDLER
	var/obj/item/bodypart/head/head = rogue_head()
	var/most = rogue_teeth_max()
	var/power = 100
	if(istype(head) && most > 0)
		power = (1 - head.rogue_teeth_amount() / most) * 100
	if(power <= 0)
		qdel(src)
		return
	var/message = speech_args[SPEECH_MESSAGE]
	if(!length(message) || copytext(message, 1, 2) == "*")
		return
	var/static/list/sounds = list("f" = "ph", "t" = "ph", "s" = "sh", "th" = "hh", "ck" = "gh", "c" = "gh", "k" = "gh", "с" = "ш", "з" = "ж", "ц" = "ч")
	for(var/sound in sounds)
		if(prob(power))
			message = replacetext(message, sound, sounds[sound])
	speech_args[SPEECH_MESSAGE] = message

/// Vibelin mouth inspect_limb(): one looking close at an open mouth sees how many teeth it lacks.
/datum/status_effect/rogue_missing_teeth/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	var/obj/item/bodypart/head/head = rogue_head()
	if(!istype(head) || !user || get_dist(user, owner) > 1 || owner.is_mouth_covered())
		return
	var/held = head.rogue_teeth_amount()
	if(held <= 0)
		examine_list += span_warning("[owner.p_They()] [owner.p_have()] no teeth left.")
		return
	var/missing = rogue_teeth_max() - held
	if(missing > 0)
		examine_list += span_warning("[owner.p_They()] [owner.p_are()] missing [missing] [missing == 1 ? "tooth" : "teeth"].")

// --- The crit that knocks teeth out.

/// Vibelin /datum/wound/teeth: a breaking blow to the mouth knocks teeth out, which is all it does; it goes at once.
/datum/wound/rogue/teeth
	name = "dental avulsion"
	rogue_key = "teeth"
	can_roll = TRUE
	strong_intent_bonus = TRUE
	aimed_intent_bonus = TRUE
	brittle_bonus = TRUE
	ignore_bloody = TRUE
	associated_bclasses = list(BCLASS_BLUNT, BCLASS_SMASH, BCLASS_CHOP, BCLASS_PICK, BCLASS_PUNCH)
	viable_zones = list(BODY_ZONE_PRECISE_MOUTH)
	crit_message = list(
		"Teeth fly from %VICTIM's mouth!",
		"%VICTIM's teeth are knocked out!",
	)

/datum/wound/rogue/teeth/rogue_can_apply(obj/item/bodypart/limb, zone, bclass)
	var/obj/item/bodypart/head/head = limb
	if(!istype(head) || head.rogue_teeth_amount() <= 0)
		return FALSE
	return ..()

/datum/wound/rogue/teeth/rogue_on_gain()
	. = ..()
	if(QDELETED(src) || !limb)
		return
	var/obj/item/bodypart/head/head = limb
	if(istype(head))
		head.rogue_knock_out_teeth(rand(rogue_number("knock_min"), rogue_number("knock_max")))
	QDEL_IN(src, 1)

/datum/wound_pregen_data/rogue_crit/teeth
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/teeth

// --- The operations on the teeth (Vibelin extract_tooth.dm, fix_teeth.dm), as steps on the head aimed at the mouth (TG has no
// jaw part to operate on by zone).

/// The numbers of a step on the teeth, and the implements it takes with their qualities, read once a revision.
/datum/surgery_operation/limb/rogue/teeth
	abstract_type = /datum/surgery_operation/limb/rogue/teeth
	rogue_zones = list(BODY_ZONE_HEAD)
	/// The key of the step's numbers, surgery_<key>_*.
	var/rogue_teeth_key
	/// The implements of the step to their quality (rogue_implements()).
	var/list/rogue_teeth_implements

/datum/surgery_operation/limb/rogue/teeth/rogue_read_numbers()
	. = ..()
	rogue_dice_requirement = rogue_value("surgery_[rogue_teeth_key]_dice")
	rogue_skill_min = rogue_value("surgery_[rogue_teeth_key]_skill_min")
	rogue_skill_median = rogue_value("surgery_[rogue_teeth_key]_skill_median")
	time = rogue_value("surgery_[rogue_teeth_key]_time")
	rogue_teeth_implements = rogue_teeth_qualities()

/// The implements of the step to their quality, read from the numbers.
/datum/surgery_operation/limb/rogue/teeth/proc/rogue_teeth_qualities()
	return list()

/datum/surgery_operation/limb/rogue/teeth/rogue_implements()
	rogue_refresh_numbers()
	return rogue_teeth_implements || list()

/datum/surgery_operation/limb/rogue/teeth/rogue_time()
	rogue_refresh_numbers()
	return time

/// A step on the teeth is offered on the mouth only.
/datum/surgery_operation/limb/rogue/teeth/snowflake_check_availability(obj/item/bodypart/limb, mob/living/surgeon, tool, operated_zone)
	if(operated_zone != BODY_ZONE_PRECISE_MOUTH || !istype(limb, /obj/item/bodypart/head))
		return FALSE
	return ..()

/// Vibelin /datum/surgery_operation/basic/extract_tooth: a tooth is pulled with tongs (a hemostat does worse), and hurts; not
/// through an open face.
/datum/surgery_operation/limb/rogue/teeth/extract
	name = "extract tooth"
	desc = "Pull a tooth from the patient's jaw."
	rogue_teeth_key = "extract_tooth"
	any_surgery_states_blocked = SURGERY_SKIN_OPEN

/datum/surgery_operation/limb/rogue/teeth/extract/rogue_teeth_qualities()
	return list(
		/obj/item/rogueweapon/tongs = rogue_value("surgery_extract_tooth_tongs"),
		TOOL_HEMOSTAT = rogue_value("surgery_extract_tooth_hemostat"),
	)

/datum/surgery_operation/limb/rogue/teeth/extract/get_default_radial_image()
	return image(/obj/item/rogueweapon/tongs)

/datum/surgery_operation/limb/rogue/teeth/extract/all_required_strings()
	. = ..()
	. += "the patient must have teeth"

/datum/surgery_operation/limb/rogue/teeth/extract/snowflake_check_availability(obj/item/bodypart/limb, mob/living/surgeon, tool, operated_zone)
	var/obj/item/bodypart/head/head = limb
	if(!istype(head) || head.rogue_teeth_amount() <= 0)
		return FALSE
	return ..()

/datum/surgery_operation/limb/rogue/teeth/extract/on_preop(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	display_results(surgeon, limb.owner, span_danger("I start pulling [limb.owner]'s tooth."),
		span_danger("[surgeon] starts pulling <b>[limb.owner]</b>'s tooth."),
		span_warning("[surgeon] begins an extraction in [limb.owner]'s mouth."))

/datum/surgery_operation/limb/rogue/teeth/extract/rogue_effect(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	var/obj/item/bodypart/head/head = limb
	if(!istype(head) || !head.rogue_knock_out_teeth(1, pick(GLOB.alldirs)))
		return
	display_results(surgeon, limb.owner, span_danger("I pull out [limb.owner]'s tooth!"),
		span_danger("[surgeon] pulls a tooth out of [limb.owner]'s mouth!"),
		span_danger("[surgeon] pulls a tooth out of [limb.owner]'s mouth!"), TRUE)
	head.rogue_add_pain(rogue_value("surgery_extract_tooth_pain"))
	if(limb.owner && limb.owner.stat != DEAD)
		INVOKE_ASYNC(limb.owner, TYPE_PROC_REF(/mob, emote), "scream")

/// Vibelin /datum/surgery_operation/basic/insert_teeth: a tooth, or a pile of them (worse), goes into the gaps of the jaw;
/// gold teeth too.
/datum/surgery_operation/limb/rogue/teeth/insert
	name = "insert teeth"
	desc = "Insert a tooth or teeth into the patient's jaw."
	rogue_teeth_key = "insert_teeth"

/datum/surgery_operation/limb/rogue/teeth/insert/rogue_teeth_qualities()
	return list(
		/obj/item/natural/teeth = rogue_value("surgery_insert_teeth_tooth"),
		/obj/item/natural/bundle/teeth = rogue_value("surgery_insert_teeth_pile"),
	)

/datum/surgery_operation/limb/rogue/teeth/insert/get_default_radial_image()
	return image(/obj/item/natural/teeth)

/datum/surgery_operation/limb/rogue/teeth/insert/all_required_strings()
	. = ..()
	. += "the patient must be missing teeth"

/datum/surgery_operation/limb/rogue/teeth/insert/snowflake_check_availability(obj/item/bodypart/limb, mob/living/surgeon, tool, operated_zone)
	var/obj/item/bodypart/head/head = limb
	if(!istype(head) || head.rogue_teeth_amount() >= rogue_teeth_max())
		return FALSE
	return ..()

/datum/surgery_operation/limb/rogue/teeth/insert/on_preop(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	display_results(surgeon, limb.owner, span_notice("I begin placing teeth into [limb.owner]'s mouth..."),
		span_notice("[surgeon] begins fixing [limb.owner]'s teeth."),
		span_notice("[surgeon] begins an operation on [limb.owner]'s mouth."))

/datum/surgery_operation/limb/rogue/teeth/insert/rogue_effect(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	var/obj/item/bodypart/head/head = limb
	if(!istype(head))
		return
	var/added = 0
	if(istype(tool, /obj/item/natural/bundle/teeth))
		var/obj/item/natural/bundle/teeth/pile = tool
		added = head.rogue_add_teeth(pile.rogue_tooth_type, pile.rogue_amount)
		if(added)
			pile.rogue_take(added)
	else if(istype(tool, /obj/item/natural/teeth))
		var/obj/item/natural/teeth/tooth = tool
		added = head.rogue_add_teeth(tooth.type, 1)
		if(added)
			qdel(tooth)
	if(!added)
		return
	display_results(surgeon, limb.owner, span_notice("I fix [limb.owner]'s teeth."),
		span_notice("[surgeon] fixes [limb.owner]'s teeth!"),
		span_notice("[surgeon] completes the operation on [limb.owner]'s mouth."))
