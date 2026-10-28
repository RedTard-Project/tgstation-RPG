// The treasury of medieval maps beyond the Crown's Purse (Ratwood code/__DEFINES/banking.dm, decrees.dm): the funds of the
// realm's institutions, loans and indentures, the poll tax, the charters and the Crown's solvency.

/// Institutions that keep a fund and a JAWBANK (Ratwood ALL_FUND_IDS).
#define ROGUE_FUND_CROWN "crown"
#define ROGUE_FUND_CHURCH "church"
#define ROGUE_FUND_MERCHANT "merchant"
#define ROGUE_FUND_BATHHOUSE "bathhouse"
#define ROGUE_FUND_TAVERN "innkeeper"

/// Trait source of the marks the treasury puts on a subject (defaulter, poll tax arrears, agency).
#define ROGUE_TREASURY_TRAIT "rogue_treasury"

#ifndef TRAIT_ARREARS
/// Poll tax unpaid for several dawns (Ratwood TRAIT_ARREARS).
#define TRAIT_ARREARS "In Arrears"
#endif

/// A fine, for the charters that shield a subject from the Crown's fines (Ratwood TAX_CATEGORY_FINE).
#define ROGUE_TAX_FINE "fine"

/// The Crown's solvency (Ratwood TREASURY_NORMAL, TREASURY_IN_ARREARS, TREASURY_BANKRUPTCY).
#define ROGUE_TREASURY_SOLVENT 0
#define ROGUE_TREASURY_ARREARS 1
#define ROGUE_TREASURY_SEQUESTERED 2

/// Classes of the poll tax, a flat levy per head at every dawn (Ratwood POLL_TAX_CAT_*).
#define ROGUE_POLL_NOBLE "noble"
#define ROGUE_POLL_CLERGY "clergy"
#define ROGUE_POLL_INQUISITION "inquisition"
#define ROGUE_POLL_COURTIER "courtier"
#define ROGUE_POLL_GARRISON "garrison"
#define ROGUE_POLL_GUILDS "guilds"
#define ROGUE_POLL_MERCHANT "merchant"
#define ROGUE_POLL_BURGHER "burgher"
#define ROGUE_POLL_ADVENTURER "adventurer"
#define ROGUE_POLL_MERCENARY "mercenary"
#define ROGUE_POLL_PEASANT "peasant"

/// Charters of the realm (Ratwood DECREE_*).
#define ROGUE_DECREE_GREAT_WRIT "great_writ"
#define ROGUE_DECREE_CONCORDAT "zenitstadt_concordat"
#define ROGUE_DECREE_OTAVAN_ACCORDS "otavan_accords"
#define ROGUE_DECREE_GOLDEN_BULL "golden_bull"
#define ROGUE_DECREE_COVENANT "noc_pestra_covenant"
#define ROGUE_DECREE_ARMS_CHARTER "guild_charter_of_arms"
#define ROGUE_DECREE_INDENTURE_OF_WAR "indenture_of_war"
#define ROGUE_DECREE_MAGNA_CARTA "magna_carta"
#define ROGUE_DECREE_ANCIENT "ancient"
#define ROGUE_DECREE_NEW "new"

/// Royal decree trumpets of Ratwood.
#define ROGUE_SOUND_DECREE pick('modular_redtard/rockhill/sound/misc/royal_decree.ogg', 'modular_redtard/rockhill/sound/misc/royal_decree2.ogg')
/// Seal pressed on a signed writ (Ratwood sound/misc/gold_license.ogg).
#define ROGUE_SOUND_SEAL 'modular_redtard/economy/sound/gold_license.ogg'
/// A JAWBANK struck and spilling coin, and its groans (Ratwood jawbankhit.ogg, jawbankanguish.ogg).
#define ROGUE_SOUND_JAWBANK_HIT 'modular_redtard/economy/sound/jawbankhit.ogg'
#define ROGUE_SOUND_JAWBANK_ANGUISH 'modular_redtard/economy/sound/jawbankanguish.ogg'

// Numbers of the treasury, from config/redtard/mechanics/values.txt (descriptions in mechanics/values.dm).
#define ROGUE_CHURCH_FUND_SEED rogue_value("treasury_church_seed")
#define ROGUE_MERCHANT_FUND_SEED rogue_value("treasury_merchant_seed")
#define ROGUE_BATHHOUSE_FUND_SEED rogue_value("treasury_bathhouse_seed")
#define ROGUE_TAVERN_FUND_SEED rogue_value("treasury_tavern_seed")
#define ROGUE_LOAN_LAST_DAY rogue_value("treasury_loan_last_day")
#define ROGUE_LOAN_PERSONAL_MIN rogue_value("treasury_loan_personal_min")
#define ROGUE_LOAN_PERSONAL_MAX rogue_value("treasury_loan_personal_max")
#define ROGUE_INDENTURE_MIN rogue_value("treasury_indenture_min")
#define ROGUE_INDENTURE_MAX rogue_value("treasury_indenture_max")
#define ROGUE_LOAN_TERM_MAX rogue_value("treasury_loan_term_max")
#define ROGUE_WRIT_LIFETIME rogue_value("treasury_writ_lifetime")
#define ROGUE_CHURCH_RESERVE rogue_value("treasury_church_reserve")
#define ROGUE_CROWN_BASH_FLOOR rogue_value("treasury_crown_bash_floor")
#define ROGUE_FUND_BASH_FLOOR rogue_value("treasury_fund_bash_floor")
#define ROGUE_TAVERN_BASH_FLOOR rogue_value("treasury_tavern_bash_floor")
#define ROGUE_BASH_LUMP_HITS rogue_value("treasury_bash_lump_hits")
#define ROGUE_CROWN_LUMP rogue_value("treasury_crown_lump")
#define ROGUE_FUND_LUMP rogue_value("treasury_fund_lump")
#define ROGUE_TAVERN_LUMP rogue_value("treasury_tavern_lump")
#define ROGUE_BASH_RESET rogue_value("treasury_bash_reset")
#define ROGUE_BATHHOUSE_WORKER_LIMIT rogue_value("treasury_bathhouse_worker_limit")
#define ROGUE_BATHHOUSE_AGENT_LIMIT rogue_value("treasury_bathhouse_agent_limit")
#define ROGUE_PATRON_CAP_CHURCH rogue_value("treasury_patron_cap_church")
#define ROGUE_PATRON_CAP_MERCHANT rogue_value("treasury_patron_cap_merchant")
#define ROGUE_PATRON_CAP_BATHHOUSE rogue_value("treasury_patron_cap_bathhouse")
#define ROGUE_PATRON_WRIT_COOLDOWN rogue_value("treasury_patron_writ_cooldown")
#define ROGUE_POLL_MAX_RATE rogue_value("treasury_poll_max_rate")
#define ROGUE_POLL_MAX_SUBSIDY rogue_value("treasury_poll_max_subsidy")
#define ROGUE_POLL_ARREARS_DAYS rogue_value("treasury_poll_arrears_days")
#define ROGUE_POLL_ADVANCE_MAX rogue_value("treasury_poll_advance_max")
#define ROGUE_POLL_ADVANCE_FALLBACK rogue_value("treasury_poll_advance_fallback")
#define ROGUE_POLL_ADVANCE_LOCKOUT rogue_value("treasury_poll_advance_lockout")
#define ROGUE_FINE_RATE_CAP rogue_value("treasury_fine_cap")
#define ROGUE_BULL_RATE_CAP rogue_value("treasury_bull_cap")
#define ROGUE_BULL_FINE_CAP rogue_value("treasury_bull_fine_cap")
#define ROGUE_BULL_POLL_CAP rogue_value("treasury_bull_poll_cap")
#define ROGUE_COVENANT_POLL_CAP rogue_value("treasury_covenant_poll_cap")
#define ROGUE_ARMS_POLL_CAP rogue_value("treasury_arms_poll_cap")
#define ROGUE_CONCORDAT_TITHE rogue_value("treasury_concordat_tithe")
#define ROGUE_DECREE_COOLDOWN rogue_value("treasury_decree_cooldown")
#define ROGUE_ARREARS_ADVANCE rogue_value("treasury_arrears_advance")
#define ROGUE_SEQUESTRATION_FLOOR rogue_value("treasury_sequestration_floor")
#define ROGUE_SEQUESTRATION_DEBT rogue_value("treasury_sequestration_debt")
#define ROGUE_SEQUESTRATION_EXPORT_SHARE rogue_value("treasury_sequestration_export_share")
#define ROGUE_CONCESSION_PICKS rogue_value("treasury_concession_picks")
#define ROGUE_RECOVERY_PURSE rogue_value("treasury_recovery_purse")
#define ROGUE_FTC_LOAN_MIN rogue_value("treasury_ftc_loan_min")
#define ROGUE_FTC_LOAN_MAX rogue_value("treasury_ftc_loan_max")
#define ROGUE_FTC_LOAN_CLOSED_DAY rogue_value("treasury_ftc_loan_closed_day")
#define ROGUE_FTC_LOAN_INTEREST rogue_value("treasury_ftc_loan_interest")

/// Day of the round for the treasury: dawns since round start (Ratwood GLOB.dayspassed, without its weekly wrap).
#define ROGUE_TREASURY_DAY (GLOB.rockhill_dawns)
