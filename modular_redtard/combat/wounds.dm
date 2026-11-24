/// Vibelin's crits (code/datums/wounds/_wound.dm, modules/surgery/bodyparts/bodypart_wounds.dm) on medieval bodies, as wounds
/// of TG's machinery (all_wounds, remove_wound(), COMSIG_CARBON_GAIN_WOUND, the examine and the scanner keep working on them):
/// a crit carries its own numbers (whp, bleeding and clotting, pain, sewing and its sewn state, how it mends) and its own
/// chance to be dealt by a blow (get_crit_prob(), rolled by rogue_try_crit(), combat/crits.dm). The plain cuts, stabs and
/// bruises of a blow are no longer wounds: they are the injuries of combat/injuries/ (the breakdown of TG's limb damage).
/// On a body with TRAIT_ROGUE_WOUNDS (the blood element, combat/blood.dm) TG rolls no wounds (check_wounding()), and a TG
/// wound forced on it (cause_wound_of_type_and_severity(), force_wound_upwards() through apply_wound(), combat/chat.dm)
/// becomes the crit of its kind and severity, or an injury below that. A crit bleeds by bleed_rate (the module's blood
/// counts rogue_bleed(); TG's blood_flow stays 0), and is lived by the blood element's tick (rogue_on_life()).
/// The families: combat/wounds/fractures.dm (fractures, Azure Peak's shatter, dislocations), arteries.dm, special.dm.

/// Azure Peak TRAIT_BRITTLE of a limb (Vibelin's too): a crit paralysis or a broken bone; its next crit breaks bone more easily.
#define ROGUE_TRAIT_BRITTLE "rogue_brittle"
#define ROGUE_CRIT_PARALYSIS_SOURCE "rogue_crit_paralysis"

/// The numbers of the crits, wound_<key>_<field>, read through rogue_number() and kept until the mechanics revision moves.
GLOBAL_LIST_EMPTY(rogue_wound_numbers)
GLOBAL_VAR_INIT(rogue_wound_numbers_revision, -1)

/// A crit of Vibelin. Its numbers are wound_<rogue_key>_<field>, falling back to its parents' keys and then to wound_base_*;
/// they are read in New(), so a crit is never written with a number.
/datum/wound/rogue
	name = "wound"
	abstract_type = /datum/wound/rogue
	sound_effect = null
	severity = WOUND_SEVERITY_MODERATE
	processes = FALSE
	can_scar = FALSE
	wound_flags = CAN_BE_GRASPED
	blood_flow = 0
	/// The key of the numbers of this kind of crit.
	var/rogue_key = "base"
	/// Vibelin whp: what mending must take off it before it closes; null for a crit that never mends by itself (rogue_permanent).
	var/whp
	/// The crit has no health and never closes by mending (Vibelin whp = null).
	var/rogue_permanent = FALSE
	/// Vibelin bleed_rate: the blood a second it bleeds (rogue_bleed()).
	var/bleed_rate = 0
	/// Vibelin clotting_rate: what the bleeding falls by each Life tick while above its floor.
	var/clotting_rate = 0
	/// Vibelin clotting_threshold: the bleeding it clots down to; null when it does not clot.
	var/clotting_threshold
	/// The same floor under its old name, read by the miracles (faith/miracles/ravox.dm, undivided.dm); kept equal to it.
	var/rogue_clot_floor
	/// The kind clots (Vibelin's clotting_threshold not null).
	var/rogue_clots = FALSE
	/// Vibelin woundpain.
	var/woundpain = 0
	/// Vibelin can_sew, sew_progress, sew_threshold and the sewn state.
	var/can_sew = FALSE
	var/sew_progress = 0
	var/sew_threshold = 0
	var/sewn_whp
	var/sewn_bleed_rate = 0
	var/sewn_clotting_rate = 0
	var/sewn_clotting_threshold
	var/sewn_woundpain = 0
	/// The sewn state clots (Azure Peak's arteries do not: sewn_clotting_threshold = null).
	var/rogue_sewn_clots = TRUE
	var/can_cauterize = FALSE
	/// Vibelin critical: told as a crit ("Critical hit!").
	var/critical = FALSE
	/// Vibelin mortal: kills a body with TRAIT_CRITICAL_WEAKNESS outright.
	var/mortal = FALSE
	/// Azure Peak shatter_wound: a shatter (combat/wounds/fractures.dm).
	var/shatter_wound = FALSE
	var/sleep_healing = 0
	var/passive_healing = 0
	var/embed_chance = 0
	var/splint_suppression = FALSE
	var/limb_efficiency_reduction = 0
	var/organ_damage_increase = 0
	/// The kinds of blow (BCLASS_*) that may deal it as a crit, and the zones it may land on (null: any).
	var/list/associated_bclasses
	var/list/viable_zones
	/// Vibelin can_roll: a blow may deal it as a crit (the crits of surgery and the permanent ones are dealt only by code).
	var/can_roll = FALSE
	var/strong_intent_bonus = FALSE
	var/aimed_intent_bonus = FALSE
	var/brittle_bonus = FALSE
	/// Vibelin ignore_bloody: it may land on a limb that cannot bleed (bones, a skeleton).
	var/ignore_bloody = FALSE
	/// Vibelin required_bodypart_status = BODYPART_ORGANIC.
	var/required_organic = FALSE
	/// The chance numbers, read in New() when it rolls.
	var/min_damage = 0
	var/min_damage_dividend = 0
	var/base_prob_weight = 0
	var/dividend_multi = 0
	var/damage_divisor = 1
	/// Vibelin crit_message: what the strike's line tells (%VICTIM, %P_THEIR, %BODYPART).
	var/list/crit_message
	/// The emote it draws when it opens (Vibelin gain_emote).
	var/gain_emote
	/// The chat class it is told in (the span of Vibelin's check_name).
	var/rogue_chat_span = "danger"
	/// The limb it numbed for a while (rogue_crit_paralysis()).
	var/rogue_paralysis_done = FALSE
	/// Put on by code (a TG wound turned into it, rogue_tg_wound()): what a blow must have done first (a bleeding cut, a
	/// gaping belly) is not asked.
	var/rogue_forced = FALSE

/datum/wound/rogue/New()
	. = ..()
	rogue_load_numbers()

/// The numbers of a fresh crit of this kind (Vibelin's type vars).
/datum/wound/rogue/proc/rogue_load_numbers()
	whp = rogue_permanent ? null : rogue_number("whp")
	bleed_rate = rogue_number("bleed")
	clotting_rate = rogue_number("clot_rate")
	clotting_threshold = rogue_clots ? rogue_number("clot_floor") : null
	rogue_clot_floor = clotting_threshold
	woundpain = rogue_number("pain")
	if(can_sew)
		sew_threshold = rogue_number("sew_threshold")
		sewn_whp = rogue_number("sewn_whp")
		sewn_bleed_rate = rogue_number("sewn_bleed")
		sewn_clotting_rate = rogue_number("sewn_clot_rate")
		sewn_clotting_threshold = rogue_sewn_clots ? rogue_number("sewn_clot_floor") : null
		sewn_woundpain = rogue_number("sewn_pain")
	sleep_healing = rogue_number("sleep_healing")
	passive_healing = rogue_number("passive_healing")
	embed_chance = rogue_number("embed_chance")
	limb_efficiency_reduction = rogue_number("limb_efficiency")
	organ_damage_increase = rogue_number("organ_damage_increase")
	damage_multiplier_penalty = rogue_number("damage_multiplier")
	if(can_roll)
		min_damage = rogue_number("min_damage")
		min_damage_dividend = rogue_number("min_dividend")
		base_prob_weight = rogue_number("base_prob")
		dividend_multi = rogue_number("dividend_multi")
		damage_divisor = rogue_number("damage_divisor")

/// A number of this kind of crit: wound_<key>_<field> of the nearest key up its type tree that has one, else wound_base_<field>.
/// Kept in GLOB until rogue_mechanics_revision() moves, so a tick reads none from the registry.
/datum/wound/rogue/proc/rogue_number(field)
	var/revision = rogue_mechanics_revision()
	if(GLOB.rogue_wound_numbers_revision != revision)
		GLOB.rogue_wound_numbers = list()
		GLOB.rogue_wound_numbers_revision = revision
	var/cache_key = "[type]:[field]"
	var/number = GLOB.rogue_wound_numbers[cache_key]
	if(!isnull(number))
		return number
	for(var/key in rogue_key_chain())
		number = rogue_value_or("wound_[key]_[field]", null)
		if(!isnull(number))
			break
	if(isnull(number))
		number = rogue_value("wound_[rogue_key]_[field]")
	GLOB.rogue_wound_numbers[cache_key] = number
	return number

/// The keys of the numbers from this kind of crit up to wound_base.
/datum/wound/rogue/proc/rogue_key_chain()
	var/static/list/chains = list()
	var/list/chain = chains[type]
	if(chain)
		return chain
	chain = list()
	var/datum/wound/rogue/path = type
	while(ispath(path, /datum/wound/rogue))
		var/key = initial(path.rogue_key)
		if(key && !(key in chain))
			chain += key
		path = initial(path.parent_type)
	if(!("base" in chain))
		chain += "base"
	chains[type] = chain
	return chain

/// No determination for these (TG's second_wind()): Vibelin's crits give none.
/datum/wound/rogue/second_wind()
	return

/datum/wound/rogue
	/// Its opening has had its effects. TG puts a crit on again when its limb is attached again (try_attach_limb()) or the crit
	/// is moved to another limb: then only what lasts comes back (rogue_on_regain()).
	var/rogue_gained = FALSE

/// The crit opens (Vibelin apply_to_bodypart(), on_bodypart_gain(), on_mob_gain()), once TG has put it on the limb; put on
/// again, what lasts of it comes back.
/datum/wound/rogue/apply_wound(obj/item/bodypart/limb, silent = FALSE, datum/wound/old_wound = null, smited = FALSE, attack_direction = null, wound_source = "Unknown", replacing = FALSE)
	. = ..()
	if(QDELETED(src) || !src.limb || !victim)
		return
	if(rogue_gained)
		rogue_on_regain()
		return
	rogue_gained = TRUE
	rogue_on_gain()

/// The limb with the crit is on a body again: what lasts while the crit is on comes back, without the pain, the knockout,
/// the cry and the shock of its opening. Every lasting effect rogue_on_gain() of a kind sets and rogue_on_loss() takes off
/// is set again here.
/datum/wound/rogue/proc/rogue_on_regain()
	rogue_update_disabling()
	limb.rogue_update_limb_efficiency()
	victim.update_health_hud()

/// The crit closes or is taken off: its effects end (Vibelin on_bodypart_loss(), on_mob_loss()).
/datum/wound/rogue/remove_wound(ignore_limb, replaced = FALSE, destroying = FALSE)
	var/obj/item/bodypart/old_limb = limb
	var/mob/living/carbon/old_victim = victim
	. = ..()
	rogue_on_loss(old_limb, old_victim, replaced, destroying)

/// Vibelin on_bodypart_gain() and on_mob_gain(): its pain lands on the limb, it numbs the limb a while and may knock one out,
/// the critical ones break one's stride, a mortal one kills the critically weak. A disabling crit (TG's disabling, Vibelin's)
/// numbs its limb through TG's set_limb() for as long as it lasts, unless a splint holds it (combat/splints.dm); a new bleeding
/// crit soaks through the bandage by the blood element's COMSIG_CARBON_GAIN_WOUND (combat/blood.dm rogue_soaks_bandage()).
/datum/wound/rogue/proc/rogue_on_gain()
	if(woundpain > 0)
		limb.rogue_add_pain(woundpain)
	rogue_update_disabling()
	var/paralysis = rogue_number("paralysis")
	if(paralysis > 0)
		rogue_paralysis_done = limb.rogue_crit_paralysis(paralysis)
	var/knockout = rogue_number("knockout")
	if(knockout > 0)
		victim.Unconscious(knockout)
	if(gain_emote)
		INVOKE_ASYNC(victim, TYPE_PROC_REF(/mob, emote), gain_emote, NONE, null, FALSE, FALSE, TRUE)
	if(critical)
		victim.rogue_crit_wound_shock()
	limb.rogue_update_limb_efficiency()
	victim.update_health_hud()
	if(mortal && HAS_TRAIT(victim, TRAIT_CRITICAL_WEAKNESS))
		victim.death()

/// Vibelin on_bodypart_loss() and on_mob_loss(). The limb and the body are those it was on (already let go by TG).
/datum/wound/rogue/proc/rogue_on_loss(obj/item/bodypart/old_limb, mob/living/carbon/old_victim, replaced, destroying)
	if(old_limb && !destroying)
		old_limb.rogue_update_limb_efficiency()
	if(old_victim && !QDELETED(old_victim))
		old_victim.update_health_hud()

/datum/wound/rogue
	/// The crit numbs its limb by its nature (Vibelin disabling); null until first asked: its type's TG disabling.
	var/rogue_disabling

/// Vibelin update_disabled(): a crit that numbs its limb does, unless a splint holds it (splint_suppression, combat/splints.dm).
/// TG's set_limb() sets disabling by TG's own splints; this sets it back by the module's, on gain and every Life tick.
/datum/wound/rogue/proc/rogue_update_disabling()
	if(isnull(rogue_disabling))
		rogue_disabling = !!initial(disabling)
	set_disabling(rogue_disabling && !(splint_suppression && limb?.rogue_splinted()))

/// Vibelin on_life(), on the blood element's tick (combat/blood.dm): while the body lives, the crit clots, then mends by itself.
/datum/wound/rogue/proc/rogue_on_life(seconds_per_tick)
	rogue_update_disabling()
	if(!victim || victim.stat == DEAD || HAS_TRAIT(victim, TRAIT_STASIS))
		return
	var/ticks = seconds_per_tick / ROGUE_LIFE_TICK
	if(!isnull(clotting_threshold) && clotting_rate > 0 && bleed_rate > clotting_threshold)
		bleed_rate = max(clotting_threshold, bleed_rate - clotting_rate * ticks)
	rogue_clot_floor = clotting_threshold
	if(passive_healing > 0)
		rogue_heal_wound(passive_healing * ticks)

/// The blood it bleeds (Vibelin bleed_rate, a second's as the blood tick counts it, before the pulse and the volume scale,
/// combat/blood.dm rogue_own_bleed_rate(); the name of the module's blood).
/datum/wound/rogue/proc/rogue_bleed()
	return max(bleed_rate, 0)

/// Vibelin set_bleed_rate().
/datum/wound/rogue/proc/rogue_set_bleed(rate)
	bleed_rate = max(rate, 0)

/// What TG's healing (miracles, coagulants) does to the flow of a wound it does to the bleeding of a crit, which keeps TG's
/// own blood_flow at 0.
/datum/wound/rogue/adjust_blood_flow(adjust_by, minimum = 0)
	if(!adjust_by)
		return
	rogue_set_bleed(max(bleed_rate + adjust_by, minimum))

/// Vibelin is_clotted(): it bleeds no more than its floor (shown only on crits that still bleed).
/datum/wound/rogue/proc/rogue_clotted()
	return !isnull(clotting_threshold) && bleed_rate > 0 && bleed_rate <= clotting_threshold

/datum/wound/rogue/get_bleed_rate_of_change()
	if(!isnull(clotting_threshold) && clotting_rate > 0 && bleed_rate > clotting_threshold)
		return BLOOD_FLOW_DECREASING
	return BLOOD_FLOW_STEADY

/// Vibelin get_visible_name(): the crit by its name, sewn, clotted.
/datum/wound/rogue/get_wound_description(mob/user)
	return get_desc_intensity("[victim.p_Their()] [limb.plaintext_zone] has \a [name][rogue_visible_marks()]")

/// What a look at the crit tells beside its name (Vibelin get_visible_name()).
/datum/wound/rogue/proc/rogue_visible_marks()
	. = ""
	if(rogue_is_sewn())
		. += " (sewn)"
	if(rogue_clotted())
		. += " (clotted)"

/datum/wound/rogue/rogue_pain()
	return max(woundpain, 0)

/// Pain relief (the miracles): the pain eases by half of what it is told, never below the sewn pain (Vibelin persistence).
/datum/wound/rogue/rogue_ease_pain(amount)
	var/eased = min(max(woundpain - sewn_woundpain, 0), round(amount / 2, DAMAGE_PRECISION))
	if(eased <= 0)
		return
	woundpain -= eased
	victim?.update_health_hud()

/// Vibelin heal_wound(): the crit mends by the amount, and with nothing left to mend it closes. Returns what it took.
/datum/wound/rogue/rogue_heal_wound(amount)
	if(isnull(whp) || amount <= 0)
		return 0
	var/healed = min(whp, round(amount, DAMAGE_PRECISION))
	whp -= healed
	if(whp <= 0)
		qdel(src)
	return healed

/datum/wound/rogue/rogue_sleep_healing()
	return sleep_healing

/datum/wound/rogue/rogue_cauterizable()
	return can_cauterize

/// Vibelin cauterize_wound(): the bleeding falls to its floor, and the searing mends it a little.
/datum/wound/rogue/rogue_cauterize(amount)
	if(!can_cauterize)
		return FALSE
	if(!isnull(clotting_threshold) && bleed_rate > clotting_threshold)
		bleed_rate = clotting_threshold
	rogue_heal_wound(isnull(amount) ? rogue_number("cauterize_heal") : amount)
	return TRUE

/datum/wound/rogue/rogue_settable()
	return FALSE

/datum/wound/rogue/rogue_set_bone()
	return FALSE

/// Vibelin can_sew and is_sewn(): a needle can still sew it.
/datum/wound/rogue/proc/rogue_sewable()
	return can_sew && !rogue_is_sewn()

/// Vibelin is_sewn().
/datum/wound/rogue/proc/rogue_is_sewn()
	return sew_threshold > 0 && sew_progress >= sew_threshold

/// One stitch (Vibelin sewing_step_complete()): the needle of a doctor gets the stitches as far as their medicine allows, and
/// teaches them by their intelligence; the stitch that closes it sews it (rogue_sew_wound()). The loop, the time and the
/// thread are the needle's (combat/medicine.dm). Returns TRUE when it is sewn.
/datum/wound/rogue/proc/rogue_sew_step(mob/living/doctor, obj/item/needle/needle)
	if(!doctor || QDELETED(src) || !rogue_sewable())
		return FALSE
	var/power = (doctor.rogue_skill_rank(/datum/attribute/skill/misc/medicine) + 1) * rogue_number("sew_power")
	sew_progress = clamp(round(sew_progress + power), 0, sew_threshold)
	var/done = sew_progress >= sew_threshold
	if(done)
		rogue_sew_wound()
	doctor.rogue_adjust_experience(/datum/attribute/skill/misc/medicine, doctor.rogue_stat(ROGUE_STAT_INTELLIGENCE) * rogue_number(done ? "sew_xp_done" : "sew_xp_step"))
	var/mob/living/patient = victim
	var/where = limb ? "[patient == doctor ? "my" : "[patient]'s"] [limb.plaintext_zone]" : (patient == doctor ? "myself" : "[patient]")
	var/closed = done ? " The wound closes." : ""
	if(patient)
		doctor.visible_message(span_notice("[doctor] sews \a [name] on [patient == doctor ? "[doctor.p_them()]self" : "[patient]"].[closed]"), span_notice("I stitch \a [name] on [where].[closed]"))
	return done

/// Vibelin sew_wound(): the crit takes its sewn state (its little bleeding, clotting and pain, no more than its sewn health to
/// mend), stops numbing its limb and mends by itself from now on.
/datum/wound/rogue/proc/rogue_sew_wound()
	if(!can_sew)
		return FALSE
	bleed_rate = sewn_bleed_rate
	clotting_rate = sewn_clotting_rate
	clotting_threshold = sewn_clotting_threshold
	rogue_clot_floor = clotting_threshold
	woundpain = sewn_woundpain
	if(!isnull(whp) && !isnull(sewn_whp))
		whp = min(whp, sewn_whp)
	rogue_disabling = FALSE
	rogue_update_disabling()
	can_sew = FALSE
	sew_progress = sew_threshold
	var/mending = rogue_number("sewn_mending")
	sleep_healing = max(sleep_healing, mending)
	passive_healing = max(passive_healing, mending)
	victim?.update_health_hud()
	return TRUE

/// Vibelin get_crit_prob(): the chance a blow of this kind and damage deals the crit, by the limb's damage share; a strong
/// or aimed blow and a brittle limb count more damage where the kind takes them, and critical resistance lowers it.
/datum/wound/rogue/proc/get_crit_prob(bclass, damage, share, mob/living/attacker, obj/item/bodypart/limb)
	if(!can_roll || !(bclass in associated_bclasses) || damage < min_damage)
		return 0
	var/brittle = brittle_bonus && limb?.rogue_brittle()
	if(share < min_damage_dividend && !brittle)
		return 0
	var/chance = base_prob_weight
	var/counted = damage
	if(strong_intent_bonus && attacker?.rogue_rmb_is(/datum/rogue_rmb_intent/strong))
		counted += rogue_number("intent_bonus")
	if(aimed_intent_bonus && attacker?.rogue_rmb_is(/datum/rogue_rmb_intent/aimed))
		counted += rogue_number("intent_bonus")
	if(brittle)
		counted += rogue_number("brittle_bonus")
	if(limb?.owner && HAS_TRAIT(limb.owner, TRAIT_CRITICAL_RESISTANCE))
		chance -= rogue_number("resistance_malus")
	return chance + round(share * dividend_multi + counted / damage_divisor, 1)

/// Vibelin can_apply_to_bodypart(): the limb is on a body, can bleed unless the kind does not care, holds no crit it cannot
/// stack with, is of flesh where the kind wants it, and (given a zone) the zone is one of the kind's and lies on the limb.
/datum/wound/rogue/proc/rogue_can_apply(obj/item/bodypart/limb, zone, bclass)
	if(src.limb || QDELETED(limb) || QDELETED(limb.owner))
		return FALSE
	if(!ignore_bloody && !limb.rogue_can_bloody_wound())
		return FALSE
	for(var/datum/wound/other as anything in limb.wounds)
		if(!rogue_can_stack_with(other))
			return FALSE
	if(required_organic && !IS_ORGANIC_LIMB(limb))
		return FALSE
	if(zone)
		if(length(viable_zones) && !(zone in viable_zones))
			return FALSE
		if(rogue_zone_target(zone) != limb.body_zone)
			return FALSE
	return TRUE

/// Vibelin can_stack_with(): most kinds keep one crit of their own type on a limb.
/datum/wound/rogue/proc/rogue_can_stack_with(datum/wound/other)
	return other.type != type

/// What the strike's line tells when the crit opens (Vibelin get_crit_message()): "Critical hit!" for a critical one.
/datum/wound/rogue/proc/rogue_crit_message()
	if(!length(crit_message))
		return
	var/text = pick(crit_message)
	text = replacetext(text, "%VICTIM", "[victim]")
	text = replacetext(text, "%P_THEIR", "[victim.p_their()]")
	text = replacetext(text, "%BODYPART", "[limb.plaintext_zone]")
	if(critical)
		return rogue_crit_text(text)
	return "<span class='[rogue_chat_class()]'>[text]</span>"

/datum/wound/rogue/rogue_chat_class()
	return rogue_chat_span

/// Adds TRAIT_PARALYSIS of all four limbs to the body (Vibelin's paralysis of a broken neck or skull), or takes it off.
/datum/wound/rogue/proc/rogue_paralyze_body(mob/living/carbon/body, on)
	var/static/list/traits = list(TRAIT_PARALYSIS_L_ARM, TRAIT_PARALYSIS_R_ARM, TRAIT_PARALYSIS_L_LEG, TRAIT_PARALYSIS_R_LEG)
	if(on)
		body.add_traits(traits, REF(src))
	else
		body.remove_traits(traits, REF(src))

/// The pregen data of the crits: only ever opened by the module (never rolled by TG), each kind in a series of its own.
/datum/wound_pregen_data/rogue_crit
	abstract = TRUE
	can_be_randomly_generated = FALSE
	compete_for_wounding = FALSE
	required_limb_biostate = NONE
	required_wounding_type = WOUND_ALL

/datum/wound_pregen_data/rogue_crit/New()
	. = ..()
	if(wound_path_to_generate)
		wound_series = "rogue_crit_[wound_path_to_generate]"

/obj/item/bodypart
	/// Vibelin limb_efficiency: what the crits on the limb leave of it, in percent (organ hits and slowness, combat/organ_hits.dm).
	var/rogue_limb_efficiency = 100

/// Vibelin update_limb_efficiency(): every crit takes its share off the limb.
/obj/item/bodypart/proc/rogue_update_limb_efficiency()
	var/efficiency = 100
	for(var/datum/wound/rogue/crit in wounds)
		efficiency -= crit.limb_efficiency_reduction
	rogue_limb_efficiency = max(0, CEILING(efficiency, 1))

/// Vibelin can_bloody_wound(): a limb of flesh on a body that bleeds.
/obj/item/bodypart/proc/rogue_can_bloody_wound()
	return IS_ORGANIC_LIMB(src) && (biological_state & BIO_FLESH) && can_bleed()

/// Vibelin add_wound(): opens a crit of the type on the limb if it may go there (no zone asked), told on the strike's line
/// when crit_message is set. Returns the crit, or null.
/obj/item/bodypart/proc/rogue_add_wound(datum/wound/rogue/path, silent = FALSE, crit_message = FALSE)
	if(!owner || HAS_TRAIT(owner, TRAIT_GODMODE))
		return null
	var/datum/wound/rogue/crit = istype(path) ? path : (ispath(path, /datum/wound/rogue) ? new path : null)
	if(!crit)
		return null
	if(!crit.rogue_can_apply(src))
		qdel(crit)
		return null
	crit.apply_wound(src, silent = TRUE, wound_source = ROGUE_CRIT_WOUND_SOURCE)
	if(QDELETED(crit) || crit.limb != src)
		return null
	if(crit_message)
		var/text = crit.rogue_crit_message()
		if(text)
			owner.rogue_strike_note(text)
	if(!silent && crit.sound_effect)
		playsound(owner, crit.sound_effect, 100, TRUE)
	return crit

/// Vibelin has_wound(): the first crit (or wound) of the type on the limb.
/obj/item/bodypart/proc/rogue_has_wound(path)
	return locate(path) in wounds

/// Vibelin's damage_multiplier of the crits on the limb (TG's update_wounds() already multiplies wound_damage_multiplier by them).
/obj/item/bodypart/proc/rogue_wound_damage_multiplier()
	. = 1
	for(var/datum/wound/rogue/crit in wounds)
		. *= crit.damage_multiplier_penalty

/// Vibelin temporary_crit_paralysis(): the limb gives out for a while and stays brittle so long; a limb already brittle does
/// not (returns FALSE). Its paralysis is TG's (TRAIT_PARALYSIS, update_disabled()).
/obj/item/bodypart/proc/rogue_crit_paralysis(duration, brittle = TRUE)
	if(!can_be_disabled || HAS_TRAIT(src, ROGUE_TRAIT_BRITTLE))
		return FALSE
	ADD_TRAIT(src, TRAIT_PARALYSIS, ROGUE_CRIT_PARALYSIS_SOURCE)
	if(brittle)
		ADD_TRAIT(src, ROGUE_TRAIT_BRITTLE, ROGUE_CRIT_PARALYSIS_SOURCE)
	addtimer(CALLBACK(src, PROC_REF(rogue_end_crit_paralysis)), duration, TIMER_UNIQUE|TIMER_OVERRIDE)
	if(owner)
		update_disabled()
	return TRUE

/// The limb a crit numbed comes back (Vibelin remove_crit_paralysis()).
/obj/item/bodypart/proc/rogue_end_crit_paralysis()
	REMOVE_TRAIT(src, TRAIT_PARALYSIS, ROGUE_CRIT_PARALYSIS_SOURCE)
	REMOVE_TRAIT(src, ROGUE_TRAIT_BRITTLE, ROGUE_CRIT_PARALYSIS_SOURCE)
	if(owner)
		update_disabled()

/// Vibelin TRAIT_BRITTLE: the limb is broken or out of joint, or still numb from a crit.
/obj/item/bodypart/proc/rogue_brittle()
	return HAS_TRAIT(src, ROGUE_TRAIT_BRITTLE)

/// A crit makes its limb brittle while it lasts (Vibelin ADD_TRAIT(affected, TRAIT_BRITTLE, type)).
/obj/item/bodypart/proc/rogue_set_brittle(source, on)
	if(on)
		ADD_TRAIT(src, ROGUE_TRAIT_BRITTLE, source)
	else
		REMOVE_TRAIT(src, ROGUE_TRAIT_BRITTLE, source)

/// A cut on the limb an artery can be torn through (Vibelin get_cut(ignore_gauze = TRUE)): an injury of the cutting kinds
/// that is not stitched and still bleeds, or an unsewn crit that bleeds.
/obj/item/bodypart/proc/rogue_open_cut()
	for(var/datum/rogue_injury/injury as anything in rogue_injuries)
		if(!(injury.kind & (ROGUE_INJURY_SLASH|ROGUE_INJURY_PUNCTURE|ROGUE_INJURY_BITE)) || (injury.injury_flags & ROGUE_INJ_SUTURED))
			continue
		if(injury.is_bleeding(TRUE))
			return injury
	for(var/datum/wound/rogue/crit in wounds)
		if(crit.rogue_bleed() > 0 && !crit.rogue_is_sewn())
			return crit
	return null

/// A gaping wound on the limb (Vibelin disembowel and gut spill): a bleeding crit with health enough, or a cut injury of
/// damage enough per injury.
/obj/item/bodypart/proc/rogue_gaping(least)
	for(var/datum/wound/rogue/crit in wounds)
		if(crit.rogue_bleed() > 0 && !isnull(crit.whp) && crit.whp >= least)
			return TRUE
	for(var/datum/rogue_injury/injury as anything in rogue_injuries)
		if((injury.kind & ROGUE_INJURY_SLASH) && injury.amount > 0 && injury.damage / injury.amount >= least)
			return TRUE
	return FALSE

/// The kind of blow (Ratwood's bclass) a hit was, as TG's damage tells it to the limb:
/// - a weapon or a round of the module says it: the intent its wielder struck with (rogue_current_bclass), a round's own
///   (rogue_bclass); unless TG saw the blow sharp another way (a special of another kind than the hand's intent), then as TG;
/// - a sharp hit with no weapon but a direction is a creature's bite or claw (TG's attack_animal(); Ratwood's beasts bite
///   and claw with intents of the slash kind);
/// - a pointed hit with neither a weapon nor a direction is a bite of the teeth (combat/mmb.dm deals bites so);
/// - else as TG saw it: a cut, a stab, a blunt blow. Burns are not blows (null).
/proc/rogue_wound_blow_class(wounding_type, attack_direction, damage_source)
	if(wounding_type == WOUND_BURN)
		return null
	var/bclass
	if(isitem(damage_source))
		var/obj/item/weapon = damage_source
		bclass = weapon.rogue_current_bclass
	else if(istype(damage_source, /obj/projectile/rogue_ammo))
		var/obj/projectile/rogue_ammo/shot = damage_source
		bclass = shot.rogue_bclass
	if(bclass && (wounding_type == WOUND_BLUNT || rogue_bclass_to_wound(bclass) == wounding_type))
		return bclass
	if(!isitem(damage_source) && !isprojectile(damage_source))
		if(attack_direction && (wounding_type == WOUND_SLASH || wounding_type == WOUND_PIERCE))
			return BCLASS_CUT
		if(!attack_direction && wounding_type == WOUND_PIERCE)
			return BCLASS_BITE
	switch(wounding_type)
		if(WOUND_SLASH)
			return BCLASS_CUT
		if(WOUND_PIERCE)
			return BCLASS_STAB
	return BCLASS_BLUNT

/// On a medieval body (TRAIT_ROGUE_WOUNDS, given by the blood element) TG rolls no wound of any kind, burns included: the
/// blow is an injury (combat/injuries/), and only a crit (combat/crits.dm) leaves a wound.
/obj/item/bodypart/check_wounding(woundtype, damage, wound_bonus, exposed_wound_bonus, attack_direction, damage_source, wound_clothing)
	if(owner && HAS_TRAIT(owner, TRAIT_ROGUE_WOUNDS))
		return null
	return ..()

/// A TG wound asked for on a medieval body (miracles, the limb guard, surgery, falling gates, smites aside) becomes the crit
/// of its kind and severity, or, below that, the damage of an injury of its kind. Returns the crit, or null.
/mob/living/carbon/cause_wound_of_type_and_severity(wounding_type, obj/item/bodypart/limb, min_severity, max_severity = min_severity, severity_pick_mode = WOUND_PICK_HIGHEST_SEVERITY, wound_source)
	if(!HAS_TRAIT(src, TRAIT_ROGUE_WOUNDS))
		return ..()
	if(isnull(limb))
		limb = pick(bodyparts)
	if(!limb)
		return null
	if(islist(wounding_type))
		wounding_type = pick(wounding_type)
	var/severity = severity_pick_mode == WOUND_PICK_LOWEST_SEVERITY ? min_severity : max_severity
	return limb.rogue_tg_wound(wounding_type, severity, wound_source)

/// The crit a TG wound of this kind and severity is on this limb (the table of combat/wounds.dm), or null for an injury.
/obj/item/bodypart/proc/rogue_tg_crit_type(wounding_type, severity, wound_source)
	switch(wounding_type)
		if(WOUND_BLUNT)
			if(severity >= WOUND_SEVERITY_SEVERE)
				switch(body_zone)
					if(BODY_ZONE_HEAD)
						return wound_source == "surgery" ? /datum/wound/rogue/fracture/head/surgical : /datum/wound/rogue/fracture/head
					if(BODY_ZONE_CHEST)
						return /datum/wound/rogue/fracture/chest
				return /datum/wound/rogue/fracture
			if(severity == WOUND_SEVERITY_MODERATE && body_zone != BODY_ZONE_HEAD && body_zone != BODY_ZONE_CHEST)
				return /datum/wound/rogue/dislocation
		if(WOUND_SLASH, WOUND_PIERCE)
			if(severity >= WOUND_SEVERITY_CRITICAL)
				if(body_zone == BODY_ZONE_CHEST && wound_source == "disembowelment")
					return /datum/wound/rogue/disembowel
				return /datum/wound/rogue/artery
		if(WOUND_BURN)
			if(severity >= WOUND_SEVERITY_SEVERE)
				switch(body_zone)
					if(BODY_ZONE_HEAD)
						return /datum/wound/rogue/charring/head
					if(BODY_ZONE_CHEST)
						return /datum/wound/rogue/charring/chest
				return /datum/wound/rogue/charring
	return null

/// A TG wound on this medieval limb: a cut or a stab cuts it first (an injury, the damage of its severity), then the crit
/// of the kind and severity opens. Returns the crit, or null.
/obj/item/bodypart/proc/rogue_tg_wound(wounding_type, severity, wound_source)
	if(!owner)
		return null
	var/crit_type = rogue_tg_crit_type(wounding_type, severity, wound_source)
	var/brute = 0
	var/burn = 0
	var/sharpness = NONE
	switch(wounding_type)
		if(WOUND_SLASH, WOUND_PIERCE)
			sharpness = wounding_type == WOUND_SLASH ? SHARP_EDGED : SHARP_POINTY
			if(severity >= WOUND_SEVERITY_SEVERE)
				brute = rogue_value("wound_tg_cut_severe")
			else if(severity == WOUND_SEVERITY_MODERATE)
				brute = rogue_value("wound_tg_cut_moderate")
			else
				brute = rogue_value("wound_tg_cut_trivial")
		if(WOUND_BURN)
			if(!crit_type)
				burn = rogue_value("wound_tg_burn_moderate")
		if(WOUND_BLUNT)
			if(!crit_type)
				brute = rogue_value("wound_tg_cut_moderate")
	if(brute || burn)
		receive_damage(brute, burn, wound_bonus = CANT_WOUND, sharpness = sharpness, damage_source = wound_source)
		owner?.updatehealth()
	if(!crit_type || !owner)
		return null
	var/datum/wound/rogue/crit = new crit_type
	crit.rogue_forced = TRUE
	return rogue_add_wound(crit)

/// The kind of a TG wound for the table above (null: not one of the kinds a medieval body turns into crits).
/datum/wound/proc/rogue_tg_wounding_type()
	return null

/datum/wound/blunt/bone/rogue_tg_wounding_type()
	return WOUND_BLUNT

/datum/wound/cranial_fissure/rogue_tg_wounding_type()
	return WOUND_BLUNT

/datum/wound/slash/flesh/rogue_tg_wounding_type()
	return WOUND_SLASH

/datum/wound/pierce/bleed/rogue_tg_wounding_type()
	return WOUND_PIERCE

/datum/wound/burn/flesh/rogue_tg_wounding_type()
	return WOUND_BURN

/// TG's force_wound_upwards() may not be overridden (SHOULD_NOT_OVERRIDE): a TG wound it puts on a medieval body is turned
/// here, as apply_wound() starts (combat/chat.dm), into the crit or injury of rogue_tg_wound(). Smites, the promotions
/// of a wound already there and a wound put on again with its limb attached again (try_attach_limb(): drop_limb() keeps
/// the wound's limb) stay TG's. Returns TRUE when it was turned (the TG wound is then deleted).
/datum/wound/proc/rogue_turn_into_crit(obj/item/bodypart/limb, smited, datum/wound/old_wound, replacing, wound_source)
	if(smited || old_wound || replacing || (limb && src.limb == limb) || !limb?.owner || !HAS_TRAIT(limb.owner, TRAIT_ROGUE_WOUNDS))
		return FALSE
	var/kind = rogue_tg_wounding_type()
	if(!kind)
		return FALSE
	var/the_severity = istype(src, /datum/wound/cranial_fissure) ? WOUND_SEVERITY_CRITICAL : severity
	limb.rogue_tg_wound(kind, the_severity, istext(wound_source) ? wound_source : null)
	qdel(src)
	return TRUE

#undef ROGUE_TRAIT_BRITTLE
#undef ROGUE_CRIT_PARALYSIS_SOURCE
