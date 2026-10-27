/datum/language/rogue_orcish
	name = "Orcish"
	desc = "(Spoken with ,r) The harsh and powerful language of the orcish tribes, spoken with strength and authority. A tongue of warriors and conquerors."
	key = "r"
	space_chance = 66
	default_priority = 80
	syllables = list("AA", "AG", "AN", "AR", "AT", "BE", "DA", "DE", "EE", "EL", "EN", "ER", "ET", "GE", "HE", "UH", "IG", "KE", "LE", "ME", "OE", "ON", "OO", "OR", "RE", "ST", "TE", "BA", "BE", "WA", "GE", "EN", "DE", "ER", "EE", "AN", "ET", "GE", "TE", "UB", "AA", "EL", "UN", "HE", "UL", "AR", "OO", "LE", "PU", "OE", "ME", "AK", "RE", "OR", "AT", "DA", "KE", "ON", "BE", "NG", "WA", "ZE", "HEE", "WUG", "BUH", "AAN", "AAR", "ARG", "ALS", "AND", "CHT", "DAT", "DEN", "DER", "ERG", "GEN", "GAR", "HAA", "HET", "IEG", "ING", "KUN", "LLE", "LIG", "MAA", "MEN", "MET", "NDE", "NEN", "NGE", "NIE", "OND", "OOR", "RDE", "REN", "SCH", "STE", "TEN", "TER", "UIT", "BAN", "WAS", "EEN", "AAR", "HET", "VUN", "GEN", "OOR", "NDE", "DEN", "HUT", "ING", "TEN", "EER", "DER", "DAT", "IET", "STU", "AND", "RUN", "DUN", "MUT", "URA", "LUR", "MAA", "TER", "NGE", "OND", "ULS", "WAS", "UCH", "URD", "NEN", "MEN", "RAS", "UND", "DUH", "HAA", "UIT", "BAAN")
	icon = 'modular_redtard/rockhill/icons/languages.dmi'
	icon_state = "orc"

/datum/language/rogue_elvish
	name = "Elvish"
	desc = "(Spoken with ,e) The elegant and flowing language of the elven people, known for its melodic quality and ancient heritage. Spoken with grace and precision."
	key = "e"
	space_chance = 66
	default_priority = 80
	syllables = list("ac", "ad", "ag", "ái", "ai", "an", "ar", "ea", "ei", "gu", "ha", "he", "id", "il", "in", "ir", "is", "it", "le", "ma", "na", "oi", "ra", "ta", "us", "an", "ai", "ea", "in", "ar", "bh", "ac", "ag", "na", "ir", "le", "ha", "is", "ad", "il", "he", "ra", "us", "gu", "it", "ta", "ei", "id", "oi", "ma", "ái", "ach", "adh", "agu", "aib", "aid", "aig", "ain", "áin", "air", "ais", "ait", "amh", "ana", "ann", "aoi", "bhe", "bhf", "bhí", "cha", "cht", "chu", "eac", "ead", "ean", "ear", "eis", "gus", "hái", "hai", "héa", "hea", "ibh", "idh", "igh", "ile", "ine", "inn", "ith", "lea", "mar", "mha", "nac", "rai", "rea", "sin", "tai", "tea", "tha", "the", "uai", "uil", "ach", "gus", "agu", "ith", "bhí", "air", "hai", "adh", "eac", "ain", "cht", "hea", "ait", "the", "ann", "chu", "ean", "amh", "rai", "tha", "rea", "sin", "inn", "ear", "bhf", "ead", "mar", "igh", "uai", "ibh", "idh", "lea", "ine", "hái", "mha", "bhe", "eis", "tai", "uil", "cha", "héa", "aib", "áin", "ais", "ana", "aoi", "nac", "aid", "aig", "ile", "tea")
	icon = 'modular_redtard/rockhill/icons/languages.dmi'
	icon_state = "elf"

/datum/language_holder/rogue_orc
	understood_languages = list(/datum/language/common = list(LANGUAGE_ATOM), /datum/language/rogue_orcish = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/common = list(LANGUAGE_ATOM), /datum/language/rogue_orcish = list(LANGUAGE_ATOM))

/obj/item/organ/tongue/rogue_race/rogue_orc
	rogue_languages = list(/datum/language/rogue_orcish)
	emote_sounds = list(
		"agony" = list(MALE = list('modular_redtard/rockhill/sound/vo/male/elf/agony.ogg')),
		"breathgasp" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/elf/breathgasp (1).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/breathgasp (2).ogg')),
		"chuckle" = list(MALE = list('modular_redtard/rockhill/sound/vo/male/elf/chuckle (1).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/chuckle (2).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/chuckle (3).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/chuckle (4).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/chuckle (5).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/chuckle (6).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/chuckle (7).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/chuckle (8).ogg')),
		"cry" = list(MALE = list('modular_redtard/rockhill/sound/vo/male/elf/cry (1).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/cry (2).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/cry (3).ogg')),
		"embed" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/elf/pain (1).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/pain (2).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/pain (3).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/pain (4).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/elf/embed (1).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/embed (2).ogg')),
		"fatigue" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/elf/fatigue.ogg')),
		"firescream" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/elf/fatigue.ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/elf/firescream (1).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/firescream (2).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/firescream (3).ogg')),
		"gasp" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/elf/gasp (1).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/gasp (2).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/gasp (3).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/elf/gasp (1).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/gasp (2).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/gasp (3).ogg')),
		"groan" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/elf/groan.ogg')),
		"grumble" = list(MALE = list('modular_redtard/rockhill/sound/vo/male/elf/grumble.ogg')),
		"haltyell" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/elf/haltyell.ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/elf/haltyell.ogg')),
		"hmm" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/elf/hmm (1).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/hmm (2).ogg')),
		"huh" = list(MALE = list('modular_redtard/rockhill/sound/vo/male/elf/huh.ogg')),
		"laugh" = list(MALE = list('modular_redtard/rockhill/sound/vo/male/elf/laugh (1).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/laugh (2).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/laugh (3).ogg')),
		"pain" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/elf/pain (1).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/pain (2).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/pain (3).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/pain (4).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/elf/pain (1).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/pain (2).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/pain (3).ogg')),
		"paincrit" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/elf/paincrit.ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/elf/paincrit (1).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/paincrit (2).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/paincrit (3).ogg')),
		"painmoan" = list(MALE = list('modular_redtard/rockhill/sound/vo/male/elf/painmoan (1).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/painmoan (2).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/painmoan (3).ogg')),
		"painscream" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/elf/painscream (1).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/painscream (2).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/elf/painscream (1).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/painscream (2).ogg')),
		"rage" = list(MALE = list('modular_redtard/rockhill/sound/vo/male/elf/rage (1).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/rage (2).ogg')),
		"scream" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/elf/scream (1).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/scream (2).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/scream (3).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/scream (4).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/elf/scream (1).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/scream (2).ogg')),
	)

/datum/language_holder/rogue_drow
	understood_languages = list(/datum/language/common = list(LANGUAGE_ATOM), /datum/language/rogue_elvish = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/common = list(LANGUAGE_ATOM), /datum/language/rogue_elvish = list(LANGUAGE_ATOM))

/obj/item/organ/tongue/rogue_race/rogue_drow
	rogue_languages = list(/datum/language/rogue_elvish)
	emote_sounds = list(
		"agony" = list(MALE = list('modular_redtard/rockhill/sound/vo/male/elf/agony.ogg')),
		"breathgasp" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/elf/breathgasp (1).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/breathgasp (2).ogg')),
		"chuckle" = list(MALE = list('modular_redtard/rockhill/sound/vo/male/elf/chuckle (1).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/chuckle (2).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/chuckle (3).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/chuckle (4).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/chuckle (5).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/chuckle (6).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/chuckle (7).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/chuckle (8).ogg')),
		"cry" = list(MALE = list('modular_redtard/rockhill/sound/vo/male/elf/cry (1).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/cry (2).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/cry (3).ogg')),
		"embed" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/elf/pain (1).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/pain (2).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/pain (3).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/pain (4).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/elf/embed (1).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/embed (2).ogg')),
		"fatigue" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/elf/fatigue.ogg')),
		"firescream" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/elf/fatigue.ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/elf/firescream (1).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/firescream (2).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/firescream (3).ogg')),
		"gasp" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/elf/gasp (1).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/gasp (2).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/gasp (3).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/elf/gasp (1).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/gasp (2).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/gasp (3).ogg')),
		"groan" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/elf/groan.ogg')),
		"grumble" = list(MALE = list('modular_redtard/rockhill/sound/vo/male/elf/grumble.ogg')),
		"haltyell" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/elf/haltyell.ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/elf/haltyell.ogg')),
		"hmm" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/elf/hmm (1).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/hmm (2).ogg')),
		"huh" = list(MALE = list('modular_redtard/rockhill/sound/vo/male/elf/huh.ogg')),
		"laugh" = list(MALE = list('modular_redtard/rockhill/sound/vo/male/elf/laugh (1).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/laugh (2).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/laugh (3).ogg')),
		"pain" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/elf/pain (1).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/pain (2).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/pain (3).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/pain (4).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/elf/pain (1).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/pain (2).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/pain (3).ogg')),
		"paincrit" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/elf/paincrit.ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/elf/paincrit (1).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/paincrit (2).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/paincrit (3).ogg')),
		"painmoan" = list(MALE = list('modular_redtard/rockhill/sound/vo/male/elf/painmoan (1).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/painmoan (2).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/painmoan (3).ogg')),
		"painscream" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/elf/painscream (1).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/painscream (2).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/elf/painscream (1).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/painscream (2).ogg')),
		"rage" = list(MALE = list('modular_redtard/rockhill/sound/vo/male/elf/rage (1).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/rage (2).ogg')),
		"scream" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/elf/scream (1).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/scream (2).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/scream (3).ogg', 'modular_redtard/rockhill/sound/vo/female/elf/scream (4).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/elf/scream (1).ogg', 'modular_redtard/rockhill/sound/vo/male/elf/scream (2).ogg')),
	)

/datum/language_holder/rogue_goblin
	understood_languages = list(/datum/language/common = list(LANGUAGE_ATOM), /datum/language/rogue_orcish = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/common = list(LANGUAGE_ATOM), /datum/language/rogue_orcish = list(LANGUAGE_ATOM))

/obj/item/organ/tongue/rogue_race/rogue_goblin
	rogue_languages = list(/datum/language/rogue_orcish)
	emote_sounds = list(
		"aggro" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/mobs/gob/aggro (1).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/aggro (2).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/aggro (3).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/aggro (4).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/mobs/gob/aggro (1).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/aggro (2).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/aggro (3).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/aggro (4).ogg')),
		"deathgasp" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/mobs/gob/death (1).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/death (2).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/mobs/gob/death (1).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/death (2).ogg')),
		"idle" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/mobs/gob/idle (1).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/idle (2).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/idle (3).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/idle (4).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/idle (5).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/mobs/gob/idle (1).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/idle (2).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/idle (3).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/idle (4).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/idle (5).ogg')),
		"laugh" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/mobs/gob/laugh (1).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/laugh (2).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/mobs/gob/laugh (1).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/laugh (2).ogg')),
		"pain" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/mobs/gob/pain (1).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/pain (2).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/pain (3).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/pain (4).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/pain (5).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/mobs/gob/pain (1).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/pain (2).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/pain (3).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/pain (4).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/pain (5).ogg')),
		"paincrit" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/mobs/gob/pain (1).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/pain (2).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/pain (3).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/pain (4).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/pain (5).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/mobs/gob/pain (1).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/pain (2).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/pain (3).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/pain (4).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/pain (5).ogg')),
		"painscream" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/mobs/gob/painscream (1).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/painscream (2).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/painscream (3).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/painscream (4).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/painscream (5).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/mobs/gob/painscream (1).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/painscream (2).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/painscream (3).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/painscream (4).ogg', 'modular_redtard/rockhill/sound/vo/mobs/gob/painscream (5).ogg')),
	)

/datum/language_holder/rogue_goblinp
	understood_languages = list(/datum/language/common = list(LANGUAGE_ATOM), /datum/language/rogue_orcish = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/common = list(LANGUAGE_ATOM), /datum/language/rogue_orcish = list(LANGUAGE_ATOM))

/obj/item/organ/tongue/rogue_race/rogue_goblinp
	rogue_languages = list(/datum/language/rogue_orcish)
	emote_sounds = list(
		"chuckle" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/goblin/chuckle (1).ogg', 'modular_redtard/rockhill/sound/vo/female/goblin/chuckle (3).ogg', 'modular_redtard/rockhill/sound/vo/female/goblin/chuckle (4).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/goblin/chuckle (1).ogg', 'modular_redtard/rockhill/sound/vo/male/goblin/chuckle (3).ogg')),
		"giggle" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/goblin/giggle (1).ogg', 'modular_redtard/rockhill/sound/vo/female/goblin/giggle (4).ogg', 'modular_redtard/rockhill/sound/vo/female/goblin/giggle (6).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/goblin/giggle (2).ogg', 'modular_redtard/rockhill/sound/vo/male/goblin/giggle (3).ogg')),
		"laugh" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/goblin/laugh (1).ogg', 'modular_redtard/rockhill/sound/vo/female/goblin/laugh (2).ogg', 'modular_redtard/rockhill/sound/vo/female/goblin/laugh (4).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/goblin/laugh (1).ogg', 'modular_redtard/rockhill/sound/vo/male/goblin/laugh (2).ogg')),
	)

/datum/species/rogue_orc
	species_language_holder = /datum/language_holder/rogue_orc
	mutanttongue = /obj/item/organ/tongue/rogue_race/rogue_orc
	mutanteyes = /obj/item/organ/eyes/rogue_goblin

/datum/species/rogue_drow
	species_language_holder = /datum/language_holder/rogue_drow
	mutanttongue = /obj/item/organ/tongue/rogue_race/rogue_drow

/datum/species/rogue_goblin
	species_language_holder = /datum/language_holder/rogue_goblin
	mutanttongue = /obj/item/organ/tongue/rogue_race/rogue_goblin

/datum/species/rogue_goblinp
	species_language_holder = /datum/language_holder/rogue_goblinp
	mutanttongue = /obj/item/organ/tongue/rogue_race/rogue_goblinp
	mutanteyes = /obj/item/organ/eyes/night_vision/rogue_wild_goblin

GLOBAL_LIST_INIT(rogue_human_voices, rogue_human_voices())

/proc/rogue_human_voices()
	return list(
		)

/obj/item/organ/eyes/night_vision/rogue_wild_goblin
	name = "wild goblin eyes"
	desc = "What manner of madness have these reddened orbs espied in the darker places of the realm?"
	low_light_cutoff = list(25, 25, 25)
	medium_light_cutoff = list(50, 50, 50)
	high_light_cutoff = list(100, 100, 100)

/obj/item/organ/eyes/rogue_goblin
	name = "goblin eyes"
	lighting_cutoff = 22

/datum/emote/living/rogue_vocal/aggro
	key = "aggro"

/datum/emote/living/rogue_vocal/agony
	key = "agony"
	message = "screams in agony!"

/datum/emote/living/rogue_vocal/breathgasp
	key = "breathgasp"
	message = "gasps for air!"

/datum/emote/living/rogue_vocal/embed
	key = "embed"

/datum/emote/living/rogue_vocal/fatigue
	key = "fatigue"

/datum/emote/living/rogue_vocal/firescream
	key = "firescream"

/datum/emote/living/rogue_vocal/haltyell
	key = "haltyell"
	message = "shouts a halt!"

/datum/emote/living/rogue_vocal/hmm
	key = "hmm"
	message = "hmms."

/datum/emote/living/rogue_vocal/huh
	key = "huh"

/datum/emote/living/rogue_vocal/idle
	key = "idle"

/datum/emote/living/rogue_vocal/pain
	key = "pain"

/datum/emote/living/rogue_vocal/paincrit
	key = "paincrit"

/datum/emote/living/rogue_vocal/painmoan
	key = "painmoan"

/datum/emote/living/rogue_vocal/painscream
	key = "painscream"
	message = "screams in pain!"

/datum/emote/living/rogue_vocal/rage
	key = "rage"
	message = "screams in rage!"
