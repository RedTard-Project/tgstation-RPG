#ifdef REDTARD_MECHANICS_EXPORT

#define ROGUE_EXPORT_SAMPLES 1000

/datum/controller/subsystem/rogue_light/Initialize()
	Master.sleep_offline_after_initializations = FALSE
	. = ..()
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(rogue_mechanics_export_and_check)), 5 SECONDS)

/proc/rogue_mechanics_export_and_check()
	var/datum/rogue_mechanics/mechanics = rogue_mechanics()
	var/list/written = mechanics.export(ROGUE_MECHANICS_EXPORT_DIR)
	var/list/report = list("written" = written, "problems" = mechanics.problems, "mismatches" = rogue_formula_self_check())
	for(var/name in mechanics.tables)
		var/list/table = mechanics.tables[name]
		report["loaded_[name]"] = length(table)
	rustg_file_write(json_encode(report), "[ROGUE_MECHANICS_EXPORT_DIR]/report.json")
	log_world("MECHANICS EXPORT: [json_encode(report)]")

/proc/rogue_old_strength_factor(strength, min_strength)
	. = 1
	if(strength > 14)
		. += 4 * 0.1 + (strength - 14) * 0.034
	else if(strength > 10)
		. += (strength - 10) * 0.1
	else if(strength < 10)
		. -= (10 - strength) * 0.1
	if(min_strength > strength)
		. *= 0.3

/proc/rogue_old_parry(list/inputs)
	var/chance = inputs["defense"]
	if(inputs["running"])
		chance -= 15
	if(inputs["swift_guard"])
		chance += 10
	chance -= inputs["attacker_skill"] * 20
	chance -= inputs["speed_pressure"]
	if(inputs["prone"])
		chance *= 0.65
	if(inputs["dual_wield"])
		chance -= 5
	chance = clamp(chance, 5, 90)
	if(inputs["untrained_armor"])
		chance = min(chance, 75)
	return chance

/proc/rogue_old_speed_pressure(list/inputs)
	if(!(inputs["attacker_speed"] > inputs["defender_speed"] && inputs["swift_attack"]))
		return 0
	var/swift = (inputs["attacker_speed"] - inputs["defender_speed"]) * 10
	swift -= max(0, (inputs["defender_perception"] - inputs["attacker_perception"]) * (inputs["attacker_armed"] ? 5 : 10))
	swift -= max(0, (inputs["defender_intelligence"] - inputs["attacker_intelligence"]) * 3)
	return clamp(swift, 0, 30)

/proc/rogue_old_dodge(list/inputs)
	var/defender_spd = inputs["defender_speed"]
	var/attacker_spd = inputs["attacker_speed"]
	var/chance = 50 + defender_spd * 10 - attacker_spd * 10
	if(inputs["swift_attack"] && attacker_spd > defender_spd)
		chance -= (attacker_spd - defender_spd) * 10
	if(inputs["heavy_attack"] && defender_spd > attacker_spd)
		chance += (defender_spd - attacker_spd) * 10
	if(inputs["improvised"])
		chance += 10
	else
		chance += (inputs["defender_skill"] - inputs["attacker_skill"]) * 10
	if(inputs["prone"])
		chance *= 0.25
	else if(inputs["dodge_expert"])
		chance = 90
	if(inputs["dual_wield"])
		chance -= 5
	return clamp(chance, 5, 90)

/proc/rogue_old_wear(list/inputs)
	var/incoming = inputs["incoming"]
	var/wear = incoming
	if(!inputs["blunt_attack"] && incoming + inputs["penetration"] > inputs["rating"])
		wear = inputs["penetration"] >= inputs["rating"] ? incoming / 2 : max(inputs["rating"] - inputs["penetration"], incoming * 0.4)
	if(inputs["blunt_attack"] && inputs["blunt_rating"] > 0)
		wear -= wear * (inputs["blunt_rating"] / 2) / 100
	return wear

/proc/rogue_formula_self_check()
	var/list/mismatches = list()
	for(var/sample in 1 to ROGUE_EXPORT_SAMPLES)
		var/strength = rand(1, 20)
		var/min_strength = pick(0, rand(1, 20))
		var/expected = rogue_old_strength_factor(strength, min_strength)
		var/got = rogue_formula_value(ROGUE_FORMULA_STRENGTH_FACTOR, list("strength" = strength, "min_strength" = min_strength))
		if(abs(expected - got) > 0.0001)
			mismatches += "strength [strength]/[min_strength]: [expected] vs [got]"
		var/list/speed_in = list("swift_attack" = prob(50), "attacker_armed" = prob(50), "attacker_speed" = rand(1, 20), "defender_speed" = rand(1, 20), "attacker_perception" = rand(1, 20), "defender_perception" = rand(1, 20), "attacker_intelligence" = rand(1, 20), "defender_intelligence" = rand(1, 20))
		expected = rogue_old_speed_pressure(speed_in)
		got = rogue_formula_value(ROGUE_FORMULA_SPEED_PRESSURE, speed_in)
		if(abs(expected - got) > 0.0001)
			mismatches += "speed [json_encode(speed_in)]: [expected] vs [got]"
		var/list/parry_in = list("defense" = rand(0, 200), "attacker_skill" = rand(0, 6), "running" = prob(30), "swift_guard" = prob(30), "speed_pressure" = rand(0, 30), "prone" = prob(20), "dual_wield" = prob(20), "untrained_armor" = prob(30))
		expected = rogue_old_parry(parry_in)
		got = rogue_formula_value(ROGUE_FORMULA_PARRY_CHANCE, parry_in)
		if(abs(expected - got) > 0.0001)
			mismatches += "parry [json_encode(parry_in)]: [expected] vs [got]"
		var/list/dodge_in = list("defender_speed" = rand(1, 20), "attacker_speed" = rand(1, 20), "swift_attack" = prob(50), "heavy_attack" = prob(30), "improvised" = prob(20), "defender_skill" = rand(0, 6), "attacker_skill" = rand(0, 6), "prone" = prob(20), "dodge_expert" = prob(20), "dual_wield" = prob(20))
		expected = rogue_old_dodge(dodge_in)
		got = rogue_formula_value(ROGUE_FORMULA_DODGE_CHANCE, dodge_in)
		if(abs(expected - got) > 0.0001)
			mismatches += "dodge [json_encode(dodge_in)]: [expected] vs [got]"
		var/list/wear_in = list("incoming" = rand(1, 60), "rating" = rand(0, 100), "penetration" = rand(0, 60), "blunt_attack" = prob(30), "blunt_rating" = rand(0, 100))
		expected = rogue_old_wear(wear_in)
		got = rogue_formula_value(ROGUE_FORMULA_ARMOR_WEAR, wear_in)
		if(abs(expected - got) > 0.0001)
			mismatches += "wear [json_encode(wear_in)]: [expected] vs [got]"
		if(length(mismatches) > 20)
			break
	return mismatches

#undef ROGUE_EXPORT_SAMPLES

#endif
