// Trade on medieval maps (economy/trade*.dm, harbor.dm, standing_orders.dm and the coin machines): Ratwood's Economy 3 states
// and fixed shapes. Tuning numbers are mechanics values ("trade_*", config/redtard/mechanics/values/trade.txt).

/// Crown levies the trade code adds to the treasury's levies (Ratwood TAX_CATEGORY_HEADEATER_LEVY, TAX_CATEGORY_EXPORT_DUTY).
#define ROGUE_TAX_HEADEATER "headeater levy"
#define ROGUE_TAX_EXPORT "export duty"

/// A ship waits offshore for a hail, or lies at the pier (Ratwood TRADE_SHIP_STATE_*).
#define ROGUE_SHIP_OFFSHORE "offshore"
#define ROGUE_SHIP_DOCKED "docked"

/// Ship size (Ratwood TRADE_SHIP_DEFAULT_TONNAGE, TONNAGE_VARIANCE, TONNAGE_SCALE_SPAN, TONNAGE_SCALE_CAP): a ship's cargo and
/// the trade it hopes for grow with its tonnage over the default, up to twice.
#define ROGUE_SHIP_DEFAULT_TONNAGE 100
#define ROGUE_SHIP_TONNAGE_VARIANCE 0.3
#define ROGUE_SHIP_TONNAGE_SCALE_SPAN 700
#define ROGUE_SHIP_TONNAGE_SCALE_CAP 2
/// Optional cargo lines a ship carries besides the ones it always does (Ratwood TRADE_SHIP_BULK_LINES_MIN/MAX).
#define ROGUE_SHIP_BULK_LINES_MIN 2
#define ROGUE_SHIP_BULK_LINES_MAX 5
/// A ship's offered price swings by up to a tenth either way (Ratwood build_bulk_line() jitter).
#define ROGUE_SHIP_PRICE_JITTER 0.1

/// Keys of a ship's cargo line and of a standing order's mix entry.
#define ROGUE_LINE_GOOD "good"
#define ROGUE_LINE_TARGET "target"
#define ROGUE_LINE_DONE "done"
#define ROGUE_LINE_PRICE "price"

/// What fulfilling a standing order came to (Ratwood fulfill_order() results).
#define ROGUE_ORDER_FULL "full"
#define ROGUE_ORDER_PARTIAL "partial"
#define ROGUE_ORDER_NEEDS_CONFIRM "needs_confirm"

/// HEADEATER, lottery and HERMES sounds that the porter does not carry (Ratwood sound/misc), kept with the economy module.
#define ROGUE_SOUND_GAMBLING 'modular_redtard/economy/sound/letsgogambling.ogg'
#define ROGUE_SOUND_BUG 'modular_redtard/economy/sound/bug.ogg'
#define ROGUE_SOUND_MACHINE_QUESTION 'modular_redtard/economy/sound/machinequestion.ogg'
#define ROGUE_SOUND_MAIL 'modular_redtard/economy/sound/mail.ogg'
#define ROGUE_SOUND_MACHINE_YES 'modular_redtard/rockhill/sound/misc/machineyes.ogg'
