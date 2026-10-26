#ifdef ROGUE_LIGHT_NATIVE_TEST
#define NATIVE_ABI 4
#define NATIVE_SIZE 32
#define NATIVE_STATIC 8
#define NATIVE_OPAQUE 3
#define NATIVE_MODE_TENTS 2
#define NATIVE_RECORD_TENT 3
#define NATIVE_STATS 25

/world
	fps = 10
	maxx = NATIVE_SIZE
	maxy = NATIVE_SIZE
	maxz = 1

/world/New()
	. = ..()
	spawn(1)
		var/datum/native_test/test = new
		test.run_all()

/datum/native_test
	var/library
	var/list/failures = list()
	var/checks = 0

/datum/native_test/proc/check(condition, what)
	checks++
	if(condition)
		world.log << "ok   [what]"
		return TRUE
	failures += what
	world.log << "FAIL [what]"
	return FALSE

/datum/native_test/proc/native(function, ...)
	var/list/arguments = args.Copy(2)
	try
		return call_ext(library, "byond:[function]")(arglist(arguments))
	catch(var/exception/error)
		failures += "[function] threw [error]"
		world.log << "FAIL [function] threw [error]"
		return null

/datum/native_test/proc/finish()
	world.log << "ROGUE_LIGHT_NATIVE: [length(failures) ? "FAIL" : "PASS"] [checks] checks, [length(failures)] failed[length(failures) ? ": [jointext(failures, "; ")]" : ""]"
	text2file(length(failures) ? "FAIL" : "PASS", "native_test_result.txt")
	shutdown()

/datum/native_test/proc/run_all()
	library = world.system_type == UNIX ? "./librogue_light.so" : "rogue_light"
	world.log << "system [world.system_type], library [library], BYOND [world.byond_version].[world.byond_build]"
	if(!check(native("rlight_abi") == NATIVE_ABI, "rlight_abi is [NATIVE_ABI]"))
		finish()
		return
	var/version = native("rlight_version")
	check(istext(version) && length(version), "rlight_version answers ([version])")
	check(native("rlight_init", NATIVE_SIZE, NATIVE_SIZE, 1, 0) == 1, "rlight_init starts a 32x32x1 world")
	var/list/flags = new /list(NATIVE_SIZE * NATIVE_SIZE)
	for(var/index in 1 to length(flags))
		flags[index] = NATIVE_STATIC
	flags[(16 - 1) * NATIVE_SIZE + 18] = NATIVE_STATIC | NATIVE_OPAQUE
	check(native("rlight_zlevel", 1, NATIVE_SIZE, NATIVE_SIZE, 0, 0, 0, flags) == 1, "rlight_zlevel takes the level with one wall at 18,16")
	native("rlight_submit", list(6, NATIVE_MODE_TENTS, 1, 1, 14, 16, 1, 4, 1, 1, 1, 1, 0, 360, 1, 0, 0, 0, 0))
	var/list/status
	for(var/attempt in 1 to 50)
		status = native("rlight_status")
		if(islist(status) && length(status) >= 8 && !status[1])
			break
		sleep(1)
	check(islist(status) && length(status) >= 8 && !status[1] && !status[7], "worker finished the light without failing ([json_encode(status)])")
	check(status && status[3] == 1, "worker counts one source")
	var/list/records = native("rlight_collect", 4096)
	var/tents = 0
	if(islist(records))
		var/index = 1
		while(index + 5 <= length(records))
			if(records[index] == NATIVE_RECORD_TENT)
				tents++
			index += 6
	check(tents > 0, "rlight_collect returns tent records ([tents])")
	var/lit = native("rlight_lum", 14, 16, 1)
	var/dark = native("rlight_lum", 2, 2, 1)
	check(isnum(lit) && lit > 0, "rlight_lum next to the light is lit ([lit])")
	check(isnum(dark) && dark == 0, "rlight_lum far away is dark ([dark])")
	check(native("rlight_sky", 0.5) == 1, "rlight_sky accepts a level")
	var/list/shadow = native("rlight_shadow", 16, 16, 1, 10, 0)
	check(islist(shadow) && length(shadow) > 0, "rlight_shadow casts behind the wall ([length(shadow)] quads)")
	if(length(shadow))
		var/list/triangles = native("rlight_shadow_quad", shadow[1])
		check(islist(triangles) && length(triangles) >= 12 && !(length(triangles) % 6), "rlight_shadow_quad gives whole triangles ([length(triangles)] numbers)")
	var/list/open = native("rlight_shadow", 4, 4, 1, 3, 0)
	check(islist(open) && !length(open), "rlight_shadow casts nothing with no wall in range")
	var/list/stats = native("rlight_stats", 0)
	check(islist(stats) && length(stats) == NATIVE_STATS, "rlight_stats has [NATIVE_STATS] counters")
	check(stats && stats[1] >= 1, "rlight_stats counted the submit")
	var/unthrottled = native("rlight_unthrottle")
	check(isnum(unthrottled) && (world.system_type == UNIX ? unthrottled == 0 : unthrottled >= 0), "rlight_unthrottle answers ([unthrottled])")
	finish()

#undef NATIVE_ABI
#undef NATIVE_SIZE
#undef NATIVE_STATIC
#undef NATIVE_OPAQUE
#undef NATIVE_MODE_TENTS
#undef NATIVE_RECORD_TENT
#undef NATIVE_STATS
#endif
