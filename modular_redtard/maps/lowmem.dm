/// The light launch (build/LOWMEM_REDTARD.cmd) is for getting onto a test map fast (owner's decision 2026-11-24). Its map
/// config (data/next_map.json, marked ROGUE_LOWMEM_MARKER) already drops the mining level, the space ruin levels and the
/// dungeon; this is what the start of the world itself skips for it. The numbers are from the owner's launch of
/// 2026-11-24 on Runtime Station: about 51 s from the start of the world to the lobby. The preview icons TG regenerates
/// at every start on a developer's machine are switched off where the marker is read (attributes/test_role.dm).

/// Ruins are never placed in the light launch: there are no ruin levels and no mining level to seed them on. TG still
/// parsed all 163 of their map files for their sizes: 3.9 s.
/datum/controller/subsystem/mapping/preloadRuinTemplates()
	if(current_map?.rogue_lowmem)
		return
	return ..()
