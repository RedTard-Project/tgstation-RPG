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
		"agony" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/agony (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/agony (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/agony (3).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/agony (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/agony (2).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/agony (4).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/agony (5).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/agony (6).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/agony (7).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/agony (8).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/agony (9).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/agony (10).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/agony (3).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/agony (11).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/agony (12).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/agony (13).ogg')),
		"breathgasp" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/breathgasp.ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/breathgasp (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/breathgasp (2).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/breathgasp (3).ogg')),
		"burp" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/burp.ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/burp.ogg')),
		"choke" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/choke (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/choke (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/choke (3).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/choke.ogg')),
		"chuckle" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/chuckle (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/chuckle (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/chuckle (3).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/chuckle.ogg')),
		"clearthroat" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/clearthroat.ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/clearthroat (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/clearthroat (2).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/clearthroat (3).ogg')),
		"cough" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/cough (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/cough (2).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/cough (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/cough (2).ogg')),
		"cry" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/cry (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/cry (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/cry (3).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/cry (4).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/cry (5).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/cry (6).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/cry (7).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/cry (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/cry (2).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/cry (3).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/cry (4).ogg')),
		"deathgasp" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/deathgurgle (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/deathgurgle (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/deathgurgle (3).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/deathgurgle (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/deathgurgle (2).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/deathgurgle (3).ogg')),
		"drown" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/drown (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/drown (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/drown (3).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/drown (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/drown (2).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/drown (3).ogg')),
		"embed" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/embed (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/embed (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/embed (3).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/embed (4).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/embed (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/embed (2).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/embed (3).ogg')),
		"fatigue" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/fatigue (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/fatigue (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/fatigue (3).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/fatigue.ogg')),
		"firescream" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/firescream (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/firescream (2).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/firescream (4).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/firescream (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/firescream (2).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/firescream (3).ogg')),
		"gag" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/gag (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/gag (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/gag (3).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/gag (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/gag (2).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/gag (3).ogg')),
		"gasp" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/gasp (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/gasp (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/gasp (3).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/gasp.ogg')),
		"giggle" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/giggle (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/giggle (2).ogg')),
		"groan" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/groan (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/groan (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/groan (3).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/groan (4).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/groan (5).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/groan (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/groan (2).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/groan (3).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/groan (4).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/groan (5).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/groan (6).ogg')),
		"groin" = list(MALE = list('modular_redtard/rockhill/sound/vo/male/gen/groin (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/groin (2).ogg')),
		"grumble" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/grumble.ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/grumble.ogg')),
		"haltyell" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/haltyell (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/haltyell (2).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/haltyell (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/haltyell (2).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/HEY.ogg')),
		"hmm" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/hmm.ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/hmm.ogg')),
		"hmph" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/hmph (1).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/hmph (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/hmph (2).ogg')),
		"huh" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/huh (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/huh (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/huh (3).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/huh (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/huh (2).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/huh (3).ogg')),
		"hum" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/hum (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/hum (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/hum (3).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/hum (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/hum (2).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/hum (3).ogg')),
		"jump" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/jump.ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/jump.ogg')),
		"laugh" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/laugh (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/laugh (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/laugh (3).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/laugh (2).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/laugh (3).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/laugh (4).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/laugh (5).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/laugh (6).ogg')),
		"leap" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/jump.ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/leap.ogg')),
		"pain" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/pain (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/pain (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/pain (3).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/pain (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/pain (2).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/pain (3).ogg')),
		"paincrit" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/paincrit (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/paincrit (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/paincrit (3).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/paincrit (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/paincrit (2).ogg')),
		"painmoan" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/painmoan (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/painmoan (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/painmoan (3).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/painmoan (4).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/painmoan (5).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/painmoan (6).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/painmoan (7).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/painmoan (8).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/painmoan (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/painmoan (2).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/painmoan (3).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/painmoan (4).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/painmoan (5).ogg')),
		"painscream" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/painscream (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/painscream (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/painscream (3).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/painscream (4).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/painscream (5).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/painscream (6).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/painscream (7).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/painscream (8).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/painscream (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/painscream (2).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/painscream (3).ogg')),
		"rage" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/rage (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/rage (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/rage (3).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/rage (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/rage (2).ogg')),
		"scream" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/scream (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/scream (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/scream (3).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/scream (4).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/scream (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/scream (2).ogg')),
		"shh" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/shh.ogg', 'modular_redtard/rockhill/sound/vo/female/gen/shh (2).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/shh.ogg')),
		"sigh" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/sigh (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/sigh (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/sigh (3).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/sigh.ogg')),
		"sneeze" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/female_sneeze.ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/male_sneeze.ogg')),
		"snore" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/snore (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/snore (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/snore (3).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/snore (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/snore (2).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/snore (3).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/snore (4).ogg')),
		"strain" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/strain.ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/strain.ogg')),
		"warcry" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/warcry_female1.ogg', 'modular_redtard/rockhill/sound/vo/female/gen/warcry_female2.ogg', 'modular_redtard/rockhill/sound/vo/female/gen/warcry_female3.ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/warcry_male1.ogg', 'modular_redtard/rockhill/sound/vo/male/gen/warcry_male2.ogg', 'modular_redtard/rockhill/sound/vo/male/gen/warcry_male3.ogg')),
		"whimper" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/whimper (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/whimper (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/whimper (3).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/whimper (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/whimper (2).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/whimper (3).ogg')),
		"whistle" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/whistle (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/whistle (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/whistle (3).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/whistle (4).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/whistle (5).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/whistle (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/whistle (2).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/whistle (3).ogg')),
		"yawn" = list(FEMALE = list('modular_redtard/rockhill/sound/vo/female/gen/yawn (1).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/yawn (2).ogg', 'modular_redtard/rockhill/sound/vo/female/gen/yawn (3).ogg'), MALE = list('modular_redtard/rockhill/sound/vo/male/gen/yawn (1).ogg', 'modular_redtard/rockhill/sound/vo/male/gen/yawn (2).ogg')),
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

/datum/emote/living/rogue_vocal/clearthroat
	key = "clearthroat"
	message = "clears their throat."

/datum/emote/living/rogue_vocal/drown
	key = "drown"

/datum/emote/living/rogue_vocal/embed
	key = "embed"

/datum/emote/living/rogue_vocal/fatigue
	key = "fatigue"

/datum/emote/living/rogue_vocal/firescream
	key = "firescream"

/datum/emote/living/rogue_vocal/groin
	key = "groin"

/datum/emote/living/rogue_vocal/haltyell
	key = "haltyell"
	message = "shouts a halt!"

/datum/emote/living/rogue_vocal/hmm
	key = "hmm"
	message = "hmms."

/datum/emote/living/rogue_vocal/hmph
	key = "hmph"
	message = "hmphs."

/datum/emote/living/rogue_vocal/huh
	key = "huh"

/datum/emote/living/rogue_vocal/hum
	key = "hum"
	message = "hums."

/datum/emote/living/rogue_vocal/idle
	key = "idle"

/datum/emote/living/rogue_vocal/leap
	key = "leap"
	message = "leaps!"

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

/datum/emote/living/rogue_vocal/shh
	key = "shh"
	message = "shooshes."

/datum/emote/living/rogue_vocal/strain
	key = "strain"
	message = "strains themselves!"

/datum/emote/living/rogue_vocal/warcry
	key = "warcry"
	message = "lets out an inspiring battle cry!"
