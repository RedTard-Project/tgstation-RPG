// Money and trade on medieval maps: Ratwood's coins, NERVELOCK accounts, Crown's treasury and trading machines.

/// The most coins one pile holds (Ratwood coins.dm, MAX_COIN_STACK_SIZE).
#define ROGUE_COIN_PILE_MAX 20

/// Coin kinds a machine pays change in (Ratwood budget2change()), largest first.
#define ROGUE_COIN_GOLD "GOLD"
#define ROGUE_COIN_SILVER "SILVER"
#define ROGUE_COIN_BRONZE "BRONZE"

/// Crown levy this port collects (Ratwood TAX_CATEGORY_IMPORT_TARIFF): the GOLDFACE import tariff.
#define ROGUE_TAX_IMPORT "import tariff"

/// How often the treasury imports and exports the stockpile (Ratwood treasury.dm, TREASURY_TICK_AMOUNT).
#define ROGUE_TREASURY_TICK (6 MINUTES)
/// Share of a stockpile's limit the Crown keeps before it exports the surplus (Ratwood autoexport_percentage).
#define ROGUE_AUTOEXPORT_SHARE 0.6
/// Import/export spread of Ratwood's pricing engine (IMPORT_EXPORT_SPREAD): what a stockpile pays and sells for.
#define ROGUE_TRADE_SPREAD 0.25
/// Fresh estates pay this much more on the first payout (Ratwood ESTATE_STARTER_BONUS).
#define ROGUE_ESTATE_STARTER_BONUS 30
/// The most a NERVELOCK pays out in one withdrawal, in coins (Ratwood atm_tgui.dm).
#define ROGUE_WITHDRAW_COINS_MAX 20
/// The most a single item or transfer can be worth (Ratwood give_money_account(): "No exponentials, please!").
#define ROGUE_TRANSFER_MAX 10000

/// Machine sounds, Ratwood's (sound/misc, sound/foley).
#define ROGUE_SOUND_COIN_INSERT 'modular_redtard/rockhill/sound/misc/coininsert.ogg'
#define ROGUE_SOUND_COIN_DISPENSE 'modular_redtard/rockhill/sound/misc/coindispense.ogg'
#define ROGUE_SOUND_MACHINE_VOMIT 'modular_redtard/rockhill/sound/misc/machinevomit.ogg'
#define ROGUE_SOUND_MACHINE_NO 'modular_redtard/rockhill/sound/misc/machineno.ogg'
#define ROGUE_SOUND_MACHINE_TALK 'modular_redtard/rockhill/sound/misc/machinetalk.ogg'
#define ROGUE_SOUND_BEEP 'modular_redtard/rockhill/sound/misc/beep.ogg'
#define ROGUE_SOUND_HISS 'modular_redtard/rockhill/sound/misc/hiss.ogg'
#define ROGUE_SOUND_KEYBOARD 'modular_redtard/rockhill/sound/misc/keyboard_enter.ogg'
#define ROGUE_SOUND_GOLD_MISC 'modular_redtard/rockhill/sound/misc/gold_misc.ogg'
#define ROGUE_SOUND_GOLD_MENU 'modular_redtard/rockhill/sound/misc/gold_menu.ogg'
#define ROGUE_SOUND_FLUSH 'modular_redtard/rockhill/sound/misc/disposalflush.ogg'
#define ROGUE_SOUND_COINS 'modular_redtard/rockhill/sound/foley/coins1.ogg'
#define ROGUE_SOUND_COIN_DROP 'modular_redtard/rockhill/sound/foley/coinphy (1).ogg'
#define ROGUE_SOUND_COIN_TAKE 'modular_redtard/rockhill/sound/foley/coinphy (2).ogg'
