#ifdef UNIT_TESTS
#define TEST_ASSERT(assertion, reason) if (!(assertion)) { return Fail("Assertion failed: [reason || "No reason"]", __FILE__, __LINE__) }
#define TEST_ASSERT_EQUAL(a, b, message) do { \
	var/lhs = ##a; \
	var/rhs = ##b; \
	if (lhs != rhs) { \
		return Fail("Expected [isnull(lhs) ? "null" : lhs] to be equal to [isnull(rhs) ? "null" : rhs].[message ? " [message]" : ""]", __FILE__, __LINE__); \
	} \
} while (FALSE)

/// The mechanics registry (mechanics/registry.dm). The live one is the registry the round uses: the first rogue_value()
/// builds it, and a reagent's New() asks while GLOB is still initializing (2026-11-22 every formula went missing and every
/// negative number read 0 that way). So these check the live registry, not a fresh one.

/// Every formula of rogue_formula_definitions() is in the registry, with its inputs, and compiled.
/datum/unit_test/rogue_mechanics_formulas

/datum/unit_test/rogue_mechanics_formulas/Run()
	var/datum/rogue_mechanics/mechanics = rogue_mechanics()
	var/list/definitions = rogue_formula_definitions()
	TEST_ASSERT(length(definitions), "rogue_formula_definitions() is empty")
	for(var/id in definitions)
		var/datum/rogue_formula/formula = mechanics.formulas[id]
		TEST_ASSERT(formula, "The registry has no formula [id]")
		TEST_ASSERT(!formula.is_value, "The formula [id] is a value in the registry")
		TEST_ASSERT(islist(formula.program) && length(formula.program), "The formula [id] did not compile")
		var/list/inputs = definitions[id][3]
		TEST_ASSERT_EQUAL(jointext(formula.known_inputs, ","), jointext(inputs, ","), "The formula [id] lost its inputs")
	var/strength = rogue_formula_value(ROGUE_FORMULA_STRENGTH_FACTOR, list("strength" = 10, "min_strength" = 0))
	TEST_ASSERT(isnum(strength), "strength_factor did not evaluate")

/// Every number the registry read compiled and holds a number, and loading reported no problem (no unknown id, no entry
/// without its type, no expression that kept its default).
/datum/unit_test/rogue_mechanics_load

/datum/unit_test/rogue_mechanics_load/Run()
	var/datum/rogue_mechanics/mechanics = rogue_mechanics()
	var/values = 0
	for(var/id in mechanics.formulas)
		var/datum/rogue_formula/formula = mechanics.formulas[id]
		if(!formula.is_value)
			continue
		values++
		TEST_ASSERT(islist(formula.program) && length(formula.program), "The value [id] = [formula.text] did not compile")
		TEST_ASSERT(isnum(formula.number), "The value [id] holds no number")
		TEST_ASSERT(!formula.error, "The value [id] kept its default: [formula.error]")
	TEST_ASSERT(values, "The registry holds no values")
	if(length(mechanics.problems))
		var/list/shown = mechanics.problems.Copy(1, min(length(mechanics.problems), 5) + 1)
		TEST_FAIL("Loading the mechanics files reported [length(mechanics.problems)] problems: [jointext(shown, "; ")]")

/// The parser reads unary minus, a fraction without its zero, spaces and nested calls, and refuses broken text.
/datum/unit_test/rogue_mechanics_parser

/datum/unit_test/rogue_mechanics_parser/Run()
	var/list/cases = list(
		"-6" = -6,
		"-0.5" = -0.5,
		".5" = 0.5,
		" - 2 " = -2,
		"--2" = 2,
		"+3" = 3,
		"1 - -1" = 2,
		"2 ^ -1" = 0.5,
		"-(1 + 2)" = -3,
		"max(-1, -2)" = -1,
		"clamp(-5, -2, 2)" = -2,
		"if(1 > 2, -1, -3)" = -3,
		"not 0" = 1,
		"10 / 0" = 0,
	)
	for(var/text in cases)
		var/datum/rogue_formula/value = new("unit_test_value", text, "", null, TRUE)
		TEST_ASSERT_EQUAL(value.number, cases[text], "\"[text]\" read wrong")
	for(var/text in list("(1", "1)", "min()", "5 # note", "1 +", "foo(1)", ""))
		TEST_ASSERT(istext(rogue_formula_compile(text)), "\"[text]\" compiled but is not a formula")

#undef TEST_ASSERT
#undef TEST_ASSERT_EQUAL
#endif
