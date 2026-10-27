/// Ratwood's origins (modular/origins/origins.dm): the land a character hails from, on medieval maps. A homeland gives
/// its traits (Ratwood ORIGIN_TRAIT; the Underdark's light sensitivity is what clothing/sun_glare.dm waits for), names
/// the character's ancestry on examine, and some homelands are resented: a human who sees the face of someone from such
/// a land, and is not from it, gets a line of prejudice and a sour mood (Ratwood /datum/stressevent/prejudice), unless
/// the land is resented only by certain others (hated_by) and they are not among them.
///
/// Not "rogue_origin": that is Vibelin's ancestry, the skin colour of a race (heritage/races.dm).

/// Trait source of a homeland's traits (Ratwood ORIGIN_TRAIT).
#define ROGUE_HOMELAND_TRAIT "rogue_homeland"
/// Ratwood /datum/stressevent/prejudice: stressadd 2 for 2 minutes.
#define ROGUE_PREJUDICE_MOOD (-2 * ROGUE_STRESS_TO_MOOD)
#define ROGUE_PREJUDICE_MOOD_TIME (2 MINUTES)
/// Ratwood apply_prefs_origin(): a character without an origin hails from Ferentia.
#define ROGUE_DEFAULT_HOMELAND "Ferentia"

// Ratwood's trait of Ferentia and Etrusca, which the ported traits (rockhill/ported/_traits.dm) lack: no mechanics yet.
#ifndef TRAIT_WATERLOVING
#define TRAIT_WATERLOVING "Water loving"
#endif

/datum/rogue_homeland
	/// Ratwood ORIGIN_*: the name in the menu and the value of the rogue_homeland preference.
	var/name
	var/desc
	/// Ratwood origin_title: the land examine names.
	var/title
	/// Ratwood origin_traits.
	var/list/traits
	/// Ratwood hated_by: names of the homelands whose people resent this one; null is everyone from elsewhere.
	var/list/hated_by
	/// Ratwood prejudice_stress: the mood of whoever resents this land on seeing one of its people; none is no prejudice.
	var/datum/mood_event/prejudice
	/// Ratwood prejudice_examine.
	var/prejudice_examine

/// The homelands by name, in Ratwood's order, made once.
/proc/rogue_homelands()
	var/static/list/homelands
	if(!homelands)
		homelands = list()
		for(var/homeland_type in subtypesof(/datum/rogue_homeland))
			var/datum/rogue_homeland/homeland = new homeland_type
			homelands[homeland.name] = homeland
	return homelands

/datum/rogue_homeland/otava
	name = "Otava"
	desc = "An unforgivingly cold alpine clime, said to be the birthplace of the Psydonic faith. The Orthodoxist Inquisition operates from the capital of Otava's old monarchy."
	title = "Otava"
	traits = list(TRAIT_COLD_RESISTANCE, TRAIT_SLOW_METABOLISM)
	hated_by = list("Grenzelhoft")
	prejudice = /datum/mood_event/rogue_prejudice/otava
	prejudice_examine = "Sanctimonious Otavan! Pah!"

/datum/rogue_homeland/zybantine
	name = "Zybantine"
	desc = "The Zybantine Empire spans across many countries, encompassing many of the deserts of Ferentia. The Empire favours strength and wealth; though rumours are abound that the opulent empire gathers its wealth through unsavoury means."
	title = "Zybantine"
	traits = list(TRAIT_HEAT_RESISTANCE, TRAIT_WATCHFUL)

/datum/rogue_homeland/naledi
	name = "Naledi"
	desc = "Once a thriving empire in its own right, the Naledi people have warred against demons (or djinn in the local tongue) on their island for centuries. Their homeland was sundered by Zizo and all but finished off by the Ascension of Baotha about 100 yils ago. It is said that the first magics were born here."
	title = "Naledi"
	traits = list(TRAIT_HEAT_RESISTANCE, TRAIT_GOLD_AFFINITY)

/datum/rogue_homeland/ferentia
	name = "Ferentia"
	desc = "An island kingdom off of the western coast of Grenzelhoft and Etrusca. The Ferentian people are a hardworking sort, eager to drink and revel after a dae's worth of toil. In the past, the kingdom has had to defend against Otava and Grenzelhoft, but now it acts as a mediator between the two nations."
	title = "Ferentia"
	traits = list(TRAIT_LOCAL_KNOWLEDGE, TRAIT_WATERLOVING)

/datum/rogue_homeland/underdark
	name = "The Underdark"
	desc = "Said to be an immense network of caves and tunnels located all throughout the crust of Grimoria, the Underdark is home to the Dark Elves and the Kobolds, as well as the elusive Fluvian city-state of Mercuriam. The caverns of the Underdark are filled with many threats from rivers of acid to man-eating spiders; and even exaggerated reports of dragons beneath."
	title = "The Underdark"
	traits = list(TRAIT_LIGHT_SENSITIVITY)
	prejudice = /datum/mood_event/rogue_prejudice/underdark
	prejudice_examine = "Squalid underdweller! Pah!"

/datum/rogue_homeland/hammerhold
	name = "Hammerhold"
	desc = "The Hammerhold Peninsula and Isles are home to a myriad of peoples, from the Abyssor-loving Witan of the peninsula, the red-heads of Ru-Yermon, or the isles that once made up the see of seasons. Within it lies the Platinum Dwarf Fortress, the ruins of a glorious cathedral that was once the seat of northern tennite faith, and various petty kingdoms, or Jarldoms, all loosely agreeing to the will of the Ringbearer, Lord of the Witan."
	title = "Hammerhold"
	traits = list(TRAIT_HEARTY_DRINKER, TRAIT_COLD_RESISTANCE)

/datum/rogue_homeland/grenzelhoft
	name = "Grenzelhoft"
	desc = "The Grenzelhoft Empire is the seat of the Holy See of the Dieci, the main Ten-worshipping religion of Grimoria. Due to the unfathomable hordes of deadites plaguing the Empire, many of the grand cities and artisan towns have been abandoned in favour of a lyfe across the seas or within the capital city. Despite all, Grenzelhoft still stands tall."
	title = "Grenzelhoft"
	traits = list(TRAIT_DEADITE_RESISTANCE, TRAIT_METICULOUS)
	hated_by = list("Otava")
	prejudice = /datum/mood_event/rogue_prejudice/grenzelhoft
	prejudice_examine = "Irksome Grenzel! Pah!"

/datum/rogue_homeland/avar
	name = "Avar"
	desc = "Avar is a land divided between the great Northern mountain ranges, the rolling grasslands of the Steppe, and the thick forests of the oncoming Taiga. It is home to the second greatest Psydonic kingdom behind Otava, the finest martial force of the Eastern ranges, and the most ethnically and culturally diverse peoples in Grimoria."
	title = "Avar"
	traits = list(TRAIT_STEPPE_RIDER, TRAIT_ANCESTOR_GUARDIAN)

/datum/rogue_homeland/gronn
	name = "Gronn"
	desc = "The steppes of Gronn are a place of bloodshed and war; Graggarite warbands laying waste to the people of Gronn and vying for dominance over Avar to the south. Not all is lost in the steppes, however, with many towns and nomad families eking out an existence fraught with danger despite the ravagers' conquest."
	title = "Gronn"
	traits = list(TRAIT_COLD_RESISTANCE, TRAIT_BATTLE_CRY)

/datum/rogue_homeland/etrusca
	name = "Etrusca"
	desc = "A sunny trade nation comprised mostly of beautiful archipelagos. Etrusca prides itself on its martial and culinary traditions, with people all across Grimoria striving to learn the ways of the vaqueros and duellists of the trader state."
	title = "Etrusca"
	traits = list(TRAIT_BLACKLEG, TRAIT_WATERLOVING)

/datum/rogue_homeland/kazengun
	name = "Kazengun"
	desc = "Kazengun is not but one nation, but three dynasties that have been in stand-still for centuries. The Kazengun Shogunate to the west of the island, the Pui-Maen Dynasty to the east, and the Clan Xinyi to the north. Kazengun is oft travelled by the people of the west, but those who visit recount (mostly tall) tales of the warriors and monsters within. Kazengunese imports are particularly expensive considering the vast ocean between the dynasties and the western world."
	title = "Kazengun"
	traits = list(TRAIT_SOFT_FOOTED)
	hated_by = list("Ferentia")
	prejudice = /datum/mood_event/rogue_prejudice/kazengun
	prejudice_examine = "Uninvited Kazengunite! Pah!"

/// Whether someone from that homeland (null: from nowhere known) resents people of this one on sight.
/datum/rogue_homeland/proc/resented_by(datum/rogue_homeland/viewer_homeland)
	if(!prejudice || viewer_homeland == src)
		return FALSE
	return !hated_by || (viewer_homeland?.name in hated_by)

/mob/living/carbon/human
	/// Ratwood origin: the land this person hails from (medieval maps).
	var/datum/rogue_homeland/rogue_homeland

/// Sets the homeland and its traits in place of the old one's.
/mob/living/carbon/human/proc/rogue_set_homeland(datum/rogue_homeland/homeland)
	REMOVE_TRAITS_IN(src, ROGUE_HOMELAND_TRAIT)
	rogue_homeland = homeland
	if(length(homeland?.traits))
		add_traits(homeland.traits, ROGUE_HOMELAND_TRAIT)

/// Ratwood human examine(): the ancestry, and the prejudice of the one looking, while the face can be seen.
/mob/living/carbon/human/examine(mob/user)
	. = ..()
	if(!rogue_homeland || !rogue_lobby_enabled() || (is_face_obscured() && !isobserver(user)))
		return
	. += span_info("[user == src ? "My" : p_Their()] ancestry is [rogue_homeland.title].")
	var/mob/living/carbon/human/viewer = user
	if(viewer == src || !istype(viewer) || !rogue_homeland.resented_by(viewer.rogue_homeland))
		return
	. += span_red(rogue_homeland.prejudice_examine)
	viewer.add_mood_event("rogue_prejudice_[rogue_homeland.name]", rogue_homeland.prejudice)

/// The homeland of a medieval character (Ratwood's origin picker, preferences.dm origin_select); a name it does not
/// know is Ferentia.
/datum/preference/choiced/rogue_homeland
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "rogue_homeland"
	should_update_preview = FALSE
	can_randomize = FALSE

/datum/preference/choiced/rogue_homeland/is_accessible(datum/preferences/preferences)
	return ..() && rogue_lobby_enabled()

/datum/preference/choiced/rogue_homeland/init_possible_values()
	. = list()
	for(var/name in rogue_homelands())
		. += name

/datum/preference/choiced/rogue_homeland/create_default_value()
	return ROGUE_DEFAULT_HOMELAND

/datum/preference/choiced/rogue_homeland/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(!rogue_lobby_enabled())
		return
	var/list/homelands = rogue_homelands()
	target.rogue_set_homeland(homelands[value] || homelands[ROGUE_DEFAULT_HOMELAND])

/// Ratwood /datum/stressevent/prejudice: someone from a land one resents is around.
/datum/mood_event/rogue_prejudice
	mood_change = ROGUE_PREJUDICE_MOOD
	timeout = ROGUE_PREJUDICE_MOOD_TIME

/datum/mood_event/rogue_prejudice/otava
	description = "There's too many Otavans around here!"

/datum/mood_event/rogue_prejudice/grenzelhoft
	description = "There's too many Grenzels around here!"

/datum/mood_event/rogue_prejudice/kazengun
	description = "Who invited Kazengunites to Ferentia?"

/datum/mood_event/rogue_prejudice/underdark
	description = "That underdweller should be underground, where it belongs."

#undef ROGUE_HOMELAND_TRAIT
#undef ROGUE_PREJUDICE_MOOD
#undef ROGUE_PREJUDICE_MOOD_TIME
#undef ROGUE_DEFAULT_HOMELAND
