/// Rockhill stacks five levels, deeper than TG's MAX_EXPECTED_Z_DEPTH (3): TG's sanity check in SSmapping
/// update_plane_tracking() traced at every start, and the Multi-Z Performance preference stopped two levels short.
/// The build wrapper (build/build_modular.ts) includes this file right after code/__DEFINES/layers.dm, so TG's own code
/// compiles with the deeper limit (the preference then reaches all five levels by itself); the include in _module.dme
/// comes later and DM skips it as a repeat.
#undef MAX_EXPECTED_Z_DEPTH
#define MAX_EXPECTED_Z_DEPTH 5
