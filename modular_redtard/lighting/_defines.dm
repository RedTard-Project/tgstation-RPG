#define ROGUE_LIGHT_CONFIG_FILE "redtard/config.txt"

#define ROGUE_LIGHT_CARRIER_OBJECT "object"
#define ROGUE_LIGHT_CARRIER_UNDERLAY "underlay"
#define ROGUE_LIGHT_CARRIER_TENT "tent"
#define ROGUE_LIGHT_CARRIER_QUARTER "quarter"

#define ROGUE_LIGHT_BACKEND_DM "dm"
#define ROGUE_LIGHT_BACKEND_NATIVE "native"
#define ROGUE_LIGHT_NATIVE_DIR "modular_redtard/native"

#define ROGUE_LIGHT_ABI 4

#define ROGUE_LIGHT_CMD_SET 1
#define ROGUE_LIGHT_CMD_DEL 2
#define ROGUE_LIGHT_CMD_TURF 3
#define ROGUE_LIGHT_CMD_RESEND 5
#define ROGUE_LIGHT_CMD_MODE 6

#define ROGUE_LIGHT_MODE_LOOKS 0
#define ROGUE_LIGHT_MODE_PALETTE 1
#define ROGUE_LIGHT_MODE_TENTS 2

#define ROGUE_LIGHT_RECORD_LOOK 2
#define ROGUE_LIGHT_RECORD_TENT 3
#define ROGUE_LIGHT_RECORD_SUN 4
#define ROGUE_LIGHT_LOOK_SIZE 17
#define ROGUE_LIGHT_TENT_SIZE 6
#define ROGUE_LIGHT_TENT_LEVELS 65
#define ROGUE_LIGHT_TENT_MAX (ROGUE_LIGHT_TENT_LEVELS * ROGUE_LIGHT_TENT_LEVELS * ROGUE_LIGHT_TENT_LEVELS + 1)

#define ROGUE_LIGHT_CHANNEL_LAMP 0
#define ROGUE_LIGHT_CHANNEL_SUN 1

#define ROGUE_SUN_PLANE 9
#define ROGUE_LIGHT_PALETTE_MAX 32768

#define ROGUE_LIGHT_QUARTER_NE 1
#define ROGUE_LIGHT_QUARTER_NW 2
#define ROGUE_LIGHT_QUARTER_SE 3
#define ROGUE_LIGHT_QUARTER_SW 4

#define ROGUE_LIGHT_TURF_FULL_OPAQUE (1<<0)
#define ROGUE_LIGHT_TURF_ANY_OPAQUE (1<<1)
#define ROGUE_LIGHT_TURF_TRANSPARENT (1<<2)
#define ROGUE_LIGHT_TURF_STATIC (1<<3)
#define ROGUE_LIGHT_TURF_REAPPLY (1<<7)

#define ROGUE_LIGHT_STATUS_JOBS 1
#define ROGUE_LIGHT_STATUS_RECORDS 2
#define ROGUE_LIGHT_STATUS_SOURCES 3
#define ROGUE_LIGHT_STATUS_LOOKS 4
#define ROGUE_LIGHT_STATUS_LAST_JOB_US 5
#define ROGUE_LIGHT_STATUS_TOTAL_JOBS 6
#define ROGUE_LIGHT_STATUS_FAILED 7
#define ROGUE_LIGHT_STATUS_TOTAL_JOB_MS 8
#define ROGUE_LIGHT_STATUS_SIZE 8

#define ROGUE_LIGHT_DARK 0
#define ROGUE_LIGHT_LUM_EPSILON 1e-6

#define ROGUE_LIGHT_COLLECT_CHUNK 512
#define ROGUE_LIGHT_APPLY_CHECK 8
#define ROGUE_LIGHT_TICK_BUDGET 30
#define ROGUE_LIGHT_INIT_TIMEOUT (60 SECONDS)

#define ROGUE_LIGHT_MATRIX(r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4) list(r1, g1, b1, 0, r2, g2, b2, 0, r3, g3, b3, 0, r4, g4, b4, 0, 0, 0, 0, 1)
#define ROGUE_LIGHT_RECORD_MATRIX(batch, at) ROGUE_LIGHT_MATRIX(batch[at], batch[at + 1], batch[at + 2], batch[at + 3], batch[at + 4], batch[at + 5], batch[at + 6], batch[at + 7], batch[at + 8], batch[at + 9], batch[at + 10], batch[at + 11])
#define ROGUE_LIGHT_CORNERS_MATRIX(red, green, blue, alpha) ROGUE_LIGHT_MATRIX(red.cache_r, red.cache_g, red.cache_b, green.cache_r, green.cache_g, green.cache_b, blue.cache_r, blue.cache_g, blue.cache_b, alpha.cache_r, alpha.cache_g, alpha.cache_b)
#define ROGUE_SIGHT_ICON 'modular_redtard/icons/effects/rogue_sight_shadow.dmi'
#define ROGUE_SIGHT_STATE "triangle"
#define ROGUE_SIGHT_RANGE 10
#define ROGUE_SIGHT_REACH 24
#define ROGUE_SIGHT_EYE 0.5
#define ROGUE_SIGHT_HALF_TILE 16
#define ROGUE_SIGHT_MAX_TRIANGLES 400
#define ROGUE_SIGHT_ALPHA 255
#define ROGUE_SIGHT_CLEAR 2
#define ROGUE_SIGHT_MAX_RANGE 32

#define ROGUE_LOWER_LEVEL_SHADE 0.8
#define ROGUE_DARKNESS_FLOOR LIGHTING_CUTOFF_REAL_LOW

#define COMSIG_GLOB_ROGUE_LIGHT_CARRIER "!rogue_light_carrier"
