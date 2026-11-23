/// The wounds of surgery and what surgery does to the wounds (combat/wounds.dm, medicine.dm, dismember.dm), on Vibelin's model
/// of the body (block VR1):
/// - the incision is a surgical injury of the limb (Vibelin create_injury(WOUND_SLASH, ..., surgical = TRUE)): it bleeds and
///   never heals by itself until it is sutured; a needle sews it shut, which closes the site of the operation (TG's surgical
///   states of the limb), and the site closed by other means (searing, TG's tools) sutures it;
/// - the cut vein of a bloodletting (Ratwood /datum/wound/slash/vein) and the replantation of a limb put back on (Ratwood
///   /datum/wound/artery/reattachment) are crits on Vibelin's fields, sewn by Ratwood's stitching; the replantation bleeds
///   hard and keeps the limb from use until it is sewn;
/// - searing (Ratwood cauterize_wound()) of TG's wounds; Vibelin's crits sear their own way (combat/wounds.dm);
/// - a broken bone of TG set (Ratwood set_bone()) mends a part at once, then by itself and in sleep;
/// - a limb put back in place closes the stump it left on the chest (Ratwood attach_limb()).

/datum/wound
	/// Ratwood set_bone(): this broken bone has been set, and mends by itself and in sleep.
	var/rogue_bone_set = FALSE

/// Ratwood can_cauterize: searing closes this wound.
/datum/wound/proc/rogue_cauterizable()
	return FALSE

/// Ratwood cauterize_wound(): the searing mends the wound by the amount (TG's cuts and stabs, the stumps).
/datum/wound/proc/rogue_cauterize(amount)
	if(!rogue_cauterizable())
		return FALSE
	rogue_heal_wound(amount)
	return TRUE

/// The sewn tail of a cut or a stab, as the cut itself.
/datum/wound/rogue/sewn/rogue_cauterizable()
	return TRUE

/// TG's cuts and stabs on a medieval body are seared as Ratwood's arteries (/datum/wound/artery can_cauterize).
/datum/wound/slash/flesh/rogue_cauterizable()
	return TRUE

/datum/wound/pierce/bleed/rogue_cauterizable()
	return TRUE

/// Ratwood /datum/wound/dismemberment can_cauterize: searing mends a stump as the hot iron does (combat/dismember.dm).
/datum/wound/rogue_stump/rogue_cauterizable()
	return TRUE

/// Ratwood attach_limb(): a limb put back closes its stump (remove_wound(dismember_wound)): the chest keeps the bleeding,
/// the pain and the searing still owed of one stump less. An unsewn one goes first.
/datum/wound/rogue_stump/proc/rogue_remove_stump()
	if(stumps <= 0)
		return
	var/sewn_one = sewn >= stumps
	stumps--
	if(sewn_one)
		sewn = max(sewn - 1, 0)
	sewn = min(sewn, stumps)
	integrity = max(integrity - ROGUE_STUMP_INTEGRITY, 0)
	if(stumps <= 0 || integrity <= 0)
		qdel(src)
		return
	if(victim)
		victim.rogue_pain_hud_dirty = TRUE
	adjust_blood_flow(-(sewn_one ? ROGUE_STUMP_SEWN_BLEED : ROGUE_STUMP_BLEED))

/mob/living/carbon
	/// The tick a prosthetic came off this body by dismemberment (combat/surgery/prosthetics.dm): it leaves no bleeding stump.
	var/rogue_prosthetic_lost_at = -1

/// A prosthetic struck off leaves no bleeding stump (Ratwood's prosthetics leave a bruise, dismember_wound).
/mob/living/carbon/rogue_add_stump()
	if(rogue_prosthetic_lost_at == world.time)
		return
	return ..()

/// Ratwood attach_limb(): a limb put back in place closes the stump it left, so the chest keeps no more stumps than there are
/// limbs still missing (a limb cut off by surgery left none).
/mob/living/carbon/proc/rogue_close_stump()
	var/obj/item/bodypart/chest/chest = get_bodypart(BODY_ZONE_CHEST)
	if(!chest)
		return
	var/datum/wound/rogue_stump/stump = locate() in chest.wounds
	if(stump && stump.stumps > length(get_missing_limbs()))
		stump.rogue_remove_stump()

/// Ratwood set_bone(): a broken bone of TG (its hairline and compound fractures, the cracked skull) is set once. Vibelin's
/// fractures are set their own way (combat/wounds.dm).
/datum/wound/proc/rogue_settable()
	return FALSE

/datum/wound/blunt/bone/rogue_settable()
	return severity >= WOUND_SEVERITY_SEVERE && !rogue_bone_set

/datum/wound/cranial_fissure/rogue_settable()
	return !rogue_bone_set

/// Ratwood set_bone(): the bone is set - it mends a part at once (its health over 1.6), then a little each Life tick and in
/// sleep, until it is whole. "(set)" by its name.
/datum/wound/proc/rogue_set_bone()
	if(!rogue_settable())
		return FALSE
	rogue_bone_set = TRUE
	processes = TRUE
	name = "[name] (set)"
	rogue_heal_wound(rogue_health_max() * rogue_value("surgery_set_bone_heal"))
	return TRUE

/// Ratwood passive_healing of a set bone, each Life tick of a living body.
/datum/wound/proc/rogue_set_bone_tick(seconds_per_tick)
	if(!rogue_bone_set || QDELETED(src) || !victim || victim.stat == DEAD || HAS_TRAIT(victim, TRAIT_STASIS))
		return
	rogue_heal_wound(rogue_value("surgery_set_bone_passive") * seconds_per_tick / ROGUE_LIFE_TICK)

/datum/wound/blunt/bone/handle_process(seconds_per_tick)
	. = ..()
	rogue_set_bone_tick(seconds_per_tick)

/datum/wound/cranial_fissure/handle_process(seconds_per_tick)
	. = ..()
	rogue_set_bone_tick(seconds_per_tick)

/// Ratwood set_bone(): sleep_healing max(sleep_healing, 1) - a set bone mends in sleep.
/datum/wound/blunt/bone/rogue_sleep_healing()
	if(rogue_bone_set)
		return rogue_value("surgery_set_bone_sleep")
	return ..()

/datum/wound/cranial_fissure/rogue_sleep_healing()
	if(rogue_bone_set)
		return rogue_value("surgery_set_bone_sleep")
	return ..()

// ---------------------------------------------------------------------------------------------------------------------------
// The incision: a surgical injury.

/// Vibelin incise (operations/surgeries/generic.dm): the cut of an operation is a surgical slash injury of the limb, its
/// damage a share of what makes an injury bleed (BLEED_DAMAGE_RATIO). The limb watches its site: closed by other means,
/// the incision is sutured with it.
/obj/item/bodypart/proc/rogue_surgery_incision()
	var/datum/rogue_injury/injury = rogue_create_injury(ROGUE_INJURY_SLASH, rogue_value("surgery_incision_damage"), TRUE)
	if(injury)
		RegisterSignal(src, COMSIG_BODYPART_UPDATING_SURGERY_STATE, PROC_REF(rogue_surgery_site_changed), override = TRUE)
	return injury

/// The open incisions of surgery on this limb: surgical injuries not sutured yet.
/obj/item/bodypart/proc/rogue_open_incisions()
	. = list()
	for(var/datum/rogue_injury/injury as anything in rogue_injuries)
		if((injury.injury_flags & ROGUE_INJ_SURGICAL) && !(injury.injury_flags & ROGUE_INJ_SUTURED))
			. += injury

/// The site of the operation was closed (searing, TG's tools, the last incision sewn): its incisions are sutured, and they
/// heal as treated injuries.
/obj/item/bodypart/proc/rogue_surgery_site_changed(datum/source, old_state, current_state, changed_states)
	SIGNAL_HANDLER
	if(HAS_ANY_SURGERY_STATE(current_state, ALL_SURGERY_SKIN_STATES))
		return
	UnregisterSignal(src, COMSIG_BODYPART_UPDATING_SURGERY_STATE)
	for(var/datum/rogue_injury/injury as anything in rogue_open_incisions())
		injury.injury_flags |= ROGUE_INJ_SUTURED

/// Ratwood incision sew_wound(): the last open incision sewn shut closes the site of the operation.
/obj/item/bodypart/proc/rogue_close_surgical_site()
	if(length(rogue_open_incisions()))
		return FALSE
	if(HAS_ANY_SURGERY_STATE(surgery_state, ALL_SURGERY_SKIN_STATES))
		remove_surgical_state(ALL_SURGERY_STATES_UNSET_ON_CLOSE)
	return TRUE

/// Ratwood /datum/wound/slash/incision, kept only as a type: surgery opens a surgical injury instead (rogue_surgery_wound()).
/// Applied by hand it still works as Ratwood's: sewn, seared or mended, it closes the site, and the site closed takes it along.
/datum/wound/rogue/incision
	name = "incision"
	desc = "A clean cut made to reach what lies beneath."
	treat_text = "Sew it shut with a needle, or sear it."
	treat_text_short = "Sew or sear it"
	examine_desc = "has a surgical incision"
	occur_text = "is cut open"
	wound_flags = NONE

/datum/wound/rogue/incision/New()
	. = ..()
	whp = rogue_value("surgery_incision_health")
	damage_multiplier_penalty = 1

/datum/wound/rogue/incision/rogue_sew_threshold()
	return rogue_value("surgery_incision_sew")

/// Ratwood incision sew_wound(): sewn shut, it is gone.
/datum/wound/rogue/incision/rogue_sew_done()
	qdel(src)

/datum/wound/rogue/incision/rogue_sleep_healing()
	return 0

/datum/wound/rogue/incision/rogue_cauterizable()
	return TRUE

/// Ratwood incision cauterize_wound(): seared, it is gone.
/datum/wound/rogue/incision/rogue_cauterize(amount)
	qdel(src)
	return TRUE

/datum/wound/rogue/incision/set_limb(obj/item/bodypart/new_value, replaced = FALSE, destroying = FALSE)
	. = ..()
	if(limb)
		RegisterSignal(limb, COMSIG_BODYPART_UPDATING_SURGERY_STATE, PROC_REF(rogue_site_changed), override = TRUE)

/// The site was closed by other means (searing oneself, TG's tools): the incision goes with it.
/datum/wound/rogue/incision/proc/rogue_site_changed(datum/source, old_state, current_state, changed_states)
	SIGNAL_HANDLER
	if(!HAS_ANY_SURGERY_STATE(current_state, ALL_SURGERY_SKIN_STATES))
		qdel(src)

/// Sewn, seared or mended, the incision closes the site of the operation; not when the limb only came off with it.
/datum/wound/rogue/incision/remove_wound(ignore_limb, replaced = FALSE, destroying = FALSE)
	var/obj/item/bodypart/site = limb
	. = ..()
	if(ignore_limb || replaced || destroying || QDELETED(site))
		return
	site.remove_surgical_state(ALL_SURGERY_STATES_UNSET_ON_CLOSE)

// ---------------------------------------------------------------------------------------------------------------------------
// The cut vein and the replantation: crits of surgery on Vibelin's fields (whp, woundpain, passive_healing), sewn by Ratwood's
// stitching (combat/medicine.dm rogue_stitch_wound()). Ratwood's numbers of their bleeding are a Life tick's; a crit bleeds by
// the second (rogue_set_bleed()). They do not make the limb take more damage.

/// Blood a Life tick the crit bleeds when surgery opens it (Ratwood bleed_rate of the fresh wound).
/datum/wound/rogue/proc/rogue_surgery_bleed()
	return 0

/// Ratwood /datum/wound/slash/vein: the vein a bloodletting opens. It bleeds and does not clot or mend by itself; sewn, it
/// bleeds little and mends.
/datum/wound/rogue/vein
	name = "cut vein"
	desc = "An opened vein, letting blood out."
	treat_text = "Sew it shut with a needle, or sear it."
	treat_text_short = "Sew or sear it"
	examine_desc = "bleeds from an opened vein"
	occur_text = "has a vein opened"
	can_cauterize = TRUE
	/// Sewn: it bleeds little and mends.
	var/rogue_sewn = FALSE

/datum/wound/rogue/vein/New()
	. = ..()
	whp = rogue_value("surgery_vein_health")
	damage_multiplier_penalty = 1

/datum/wound/rogue/vein/rogue_surgery_bleed()
	return rogue_value("surgery_vein_bleed")

/datum/wound/rogue/vein/rogue_sew_threshold()
	return rogue_sewn ? 0 : rogue_value("surgery_vein_sew")

/// Ratwood sew_wound(): sewn, the vein bleeds little (sewn_bleed_rate), has less to mend (sewn_whp) and mends by itself.
/datum/wound/rogue/vein/rogue_sew_done()
	rogue_sewn = TRUE
	rogue_sew_progress = 0
	rogue_stitched = 0
	name = "sewn vein"
	whp = min(whp, rogue_value("surgery_vein_sewn_health"))
	passive_healing = max(passive_healing, rogue_value("surgery_sewn_passive"))
	rogue_set_bleed(rogue_value("surgery_vein_sewn_bleed") / ROGUE_LIFE_TICK)

/datum/wound/rogue/vein/rogue_sleep_healing()
	return rogue_sewn ? ..() : 0

/datum/wound/rogue/vein/rogue_cauterizable()
	return TRUE

/datum/wound/rogue/vein/rogue_soaks_bandage()
	return !rogue_sewn

/// Ratwood /datum/wound/artery/reattachment: a limb put back on bleeds as from an opened artery, hurts and will not serve until
/// it is sewn; sewn, it bleeds little, hurts less and mends.
/datum/wound/rogue/replantation
	name = "replantation"
	desc = "A limb put back on, its vessels still open."
	treat_text = "Sew it on with a needle."
	treat_text_short = "Sew it"
	examine_desc = "is barely attached, bleeding from the seam"
	occur_text = "is put back on"
	severity = WOUND_SEVERITY_CRITICAL
	disabling = TRUE
	rogue_disabling = TRUE
	can_cauterize = TRUE
	/// Sewn: it bleeds little, hurts less, serves and mends.
	var/rogue_sewn = FALSE

/datum/wound/rogue/replantation/New()
	. = ..()
	whp = rogue_value("surgery_replant_health")
	woundpain = rogue_value("surgery_replant_pain")
	damage_multiplier_penalty = 1

/datum/wound/rogue/replantation/rogue_surgery_bleed()
	return rogue_value("surgery_replant_bleed")

/datum/wound/rogue/replantation/rogue_sew_threshold()
	return rogue_sewn ? 0 : rogue_value("surgery_replant_sew")

/// Ratwood sew_wound(): sewn on, the limb bleeds little, hurts less, serves again and mends by itself and in sleep.
/datum/wound/rogue/replantation/rogue_sew_done()
	rogue_sewn = TRUE
	rogue_sew_progress = 0
	rogue_stitched = 0
	name = "sewn replantation"
	whp = min(whp, rogue_value("surgery_replant_sewn_health"))
	woundpain = min(woundpain, rogue_value("surgery_replant_sewn_pain"))
	passive_healing = max(passive_healing, rogue_value("surgery_sewn_passive"))
	rogue_disabling = FALSE
	rogue_update_disabling()
	if(victim)
		victim.rogue_pain_hud_dirty = TRUE
	rogue_set_bleed(rogue_value("surgery_replant_sewn_bleed") / ROGUE_LIFE_TICK)

/// Ratwood artery sleep_healing 0.5; sewn, max(sleep_healing, 1).
/datum/wound/rogue/replantation/rogue_sleep_healing()
	return rogue_sewn ? ..() : rogue_value("artery_sleep_healing")

/datum/wound/rogue/replantation/rogue_cauterizable()
	return TRUE

/datum/wound/rogue/replantation/rogue_soaks_bandage()
	return !rogue_sewn

/// The pregen data of surgery's wounds: only made by surgery, never rolled, one of each on a limb of flesh.
/datum/wound_pregen_data/rogue_surgery
	abstract = TRUE
	can_be_randomly_generated = FALSE
	compete_for_wounding = FALSE
	required_limb_biostate = BIO_FLESH
	required_wounding_type = WOUND_ALL

/datum/wound_pregen_data/rogue_surgery/incision
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/incision
	wound_series = ROGUE_WOUND_SERIES_INCISION

/datum/wound_pregen_data/rogue_surgery/vein
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/vein
	wound_series = ROGUE_WOUND_SERIES_VEIN
	required_limb_biostate = (BIO_FLESH|BIO_BLOODED)
	ignore_cannot_bleed = FALSE
	viable_zones = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)

/datum/wound_pregen_data/rogue_surgery/replantation
	abstract = FALSE
	wound_path_to_generate = /datum/wound/rogue/replantation
	wound_series = ROGUE_WOUND_SERIES_REPLANTATION
	required_limb_biostate = (BIO_FLESH|BIO_BLOODED)
	ignore_cannot_bleed = FALSE

/// Opens one of surgery's wounds on the limb (steps.dm, prosthetics.dm): the incision as a surgical injury, the vein and the
/// replantation as crits bleeding at their fresh rate. Returns the injury or the crit, null if the limb cannot take it.
/obj/item/bodypart/proc/rogue_surgery_wound(wound_type, wound_source)
	if(ispath(wound_type, /datum/wound/rogue/incision))
		return rogue_surgery_incision()
	var/datum/wound/rogue/wound = new wound_type
	if(!wound.apply_wound(src, silent = TRUE, wound_source = wound_source) || QDELETED(wound))
		return null
	wound.rogue_set_bleed(wound.rogue_surgery_bleed() / ROGUE_LIFE_TICK)
	return wound
