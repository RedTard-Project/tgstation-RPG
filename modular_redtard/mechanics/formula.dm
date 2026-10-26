GLOBAL_LIST_INIT(rogue_formula_precedence, list(
	"or" = 1,
	"and" = 2,
	"==" = 3,
	"!=" = 3,
	"<" = 3,
	"<=" = 3,
	">" = 3,
	">=" = 3,
	"+" = 4,
	"-" = 4,
	"*" = 5,
	"/" = 5,
	"%" = 5,
	"^" = 6,
	"neg" = 7,
	"not" = 7,
))

GLOBAL_LIST_INIT(rogue_formula_right_assoc, list("^" = TRUE, "neg" = TRUE, "not" = TRUE))

GLOBAL_LIST_INIT(rogue_formula_unary, list("neg" = TRUE, "not" = TRUE))

GLOBAL_LIST_INIT(rogue_formula_functions, list(
	"min" = ROGUE_FORMULA_ANY_ARGS,
	"max" = ROGUE_FORMULA_ANY_ARGS,
	"clamp" = 3,
	"abs" = 1,
	"round" = 1,
	"floor" = 1,
	"ceil" = 1,
	"sqrt" = 1,
	"if" = 3,
))

/datum/rogue_formula
	var/id
	var/desc
	var/text
	var/default_text
	var/list/program
	var/list/inputs
	var/list/known_inputs
	var/error
	var/is_value = FALSE
	var/number = 0

/datum/rogue_formula/New(id, default_text, desc, list/known_inputs, is_value = FALSE)
	src.id = id
	src.is_value = is_value
	src.desc = desc
	src.default_text = default_text
	src.known_inputs = known_inputs
	var/failure = set_text(default_text)
	if(failure)
		CRASH("Default rogue formula [id] does not compile: [failure]")

/datum/rogue_formula/proc/set_text(new_text)
	var/list/compiled = rogue_formula_compile(new_text)
	if(istext(compiled))
		return compiled
	var/list/used = list()
	for(var/step in compiled)
		if(islist(step) && length(step) == 1)
			used |= step[1]
	if(is_value && length(used))
		return "a value takes no inputs, got \"[used[1]]\""
	if(length(known_inputs))
		for(var/name in used)
			if(!(name in known_inputs))
				return "unknown input \"[name]\" (known: [jointext(known_inputs, ", ")])"
	text = new_text
	program = compiled
	inputs = used
	error = null
	if(is_value)
		number = evaluate()
	return null

/datum/rogue_formula/proc/reset()
	set_text(default_text)

/datum/rogue_formula/proc/evaluate(list/values)
	var/list/stack = list()
	for(var/step in program)
		if(isnum(step))
			stack += step
			continue
		if(islist(step))
			if(length(step) == 1)
				var/value = values[step[1]]
				stack += isnum(value) ? value : (value ? 1 : 0)
				continue
			var/argc = step[2]
			var/list/arguments = stack.Copy(length(stack) - argc + 1)
			stack.len -= argc
			stack += rogue_formula_call(step[1], arguments)
			continue
		if(GLOB.rogue_formula_unary[step])
			var/operand = stack[length(stack)]
			stack[length(stack)] = step == "neg" ? -operand : !operand
			continue
		var/right = stack[length(stack)]
		stack.len--
		var/left = stack[length(stack)]
		stack[length(stack)] = rogue_formula_apply(step, left, right)
	return length(stack) ? stack[length(stack)] : 0

/proc/rogue_formula_apply(operator, left, right)
	switch(operator)
		if("+")
			return left + right
		if("-")
			return left - right
		if("*")
			return left * right
		if("/")
			return right ? left / right : 0
		if("%")
			return right ? left % right : 0
		if("^")
			return left ** right
		if("<")
			return left < right
		if("<=")
			return left <= right
		if(">")
			return left > right
		if(">=")
			return left >= right
		if("==")
			return left == right
		if("!=")
			return left != right
		if("and")
			return left && right
		if("or")
			return left || right
	return 0

/proc/rogue_formula_call(name, list/arguments)
	switch(name)
		if("min")
			return min(arguments)
		if("max")
			return max(arguments)
		if("clamp")
			return clamp(arguments[1], arguments[2], arguments[3])
		if("abs")
			return abs(arguments[1])
		if("round")
			return round(arguments[1], 1)
		if("floor")
			return floor(arguments[1])
		if("ceil")
			return ceil(arguments[1])
		if("sqrt")
			return arguments[1] > 0 ? sqrt(arguments[1]) : 0
		if("if")
			return arguments[1] ? arguments[2] : arguments[3]
	return 0

/proc/rogue_formula_tokens(expression)
	var/list/tokens = list()
	var/length = length(expression)
	var/index = 1
	while(index <= length)
		var/char = expression[index]
		if(char == " " || char == "\t" || char == "\n")
			index++
			continue
		if(findtext(ROGUE_FORMULA_DIGITS, char))
			var/start = index
			while(index <= length && findtext(ROGUE_FORMULA_DIGITS, expression[index]))
				index++
			var/number = text2num(copytext(expression, start, index))
			if(isnull(number))
				return "bad number \"[copytext(expression, start, index)]\""
			tokens += number
			continue
		if(findtext(ROGUE_FORMULA_NAME_START, char))
			var/start = index
			while(index <= length && findtext(ROGUE_FORMULA_NAME_CHARS, expression[index]))
				index++
			var/name = LOWER_TEXT(copytext(expression, start, index))
			switch(name)
				if("and", "or", "not")
					tokens += name
				else
					tokens += list(list(name))
			continue
		var/pair = copytext(expression, index, index + 2)
		switch(pair)
			if("<=", ">=", "==", "!=")
				tokens += pair
				index += 2
				continue
			if("&&")
				tokens += "and"
				index += 2
				continue
			if("||")
				tokens += "or"
				index += 2
				continue
		switch(char)
			if("+", "-", "*", "/", "%", "^", "(", ")", ",", "<", ">")
				tokens += char
			if("!")
				tokens += "not"
			else
				return "unexpected \"[char]\""
		index++
	return tokens

/proc/rogue_formula_compile(expression)
	if(!istext(expression) || !length(trim(expression)))
		return "empty formula"
	var/list/tokens = rogue_formula_tokens(expression)
	if(istext(tokens))
		return tokens
	var/list/output = list()
	var/list/operators = list()
	var/list/parens = list()
	var/expect_operand = TRUE
	var/token_count = length(tokens)
	for(var/index in 1 to token_count)
		var/token = tokens[index]
		if(isnum(token))
			if(!expect_operand)
				return "missing operator before [token]"
			output += token
			expect_operand = FALSE
			continue
		if(islist(token))
			if(!expect_operand)
				return "missing operator before \"[token[1]]\""
			var/name = token[1]
			if(index < token_count && tokens[index + 1] == "(")
				if(isnull(GLOB.rogue_formula_functions[name]))
					return "unknown function \"[name]\""
				operators += list(list(name))
			else
				output += list(list(name))
				expect_operand = FALSE
			continue
		switch(token)
			if("(")
				if(!expect_operand)
					return "missing operator before \"(\""
				var/list/previous = length(operators) ? operators[length(operators)] : null
				parens += (islist(previous) && index > 1 && islist(tokens[index - 1])) ? 1 : ROGUE_FORMULA_GROUP
				operators += "("
				expect_operand = TRUE
			if(",")
				if(expect_operand || !length(parens) || parens[length(parens)] == ROGUE_FORMULA_GROUP)
					return "misplaced \",\""
				while(length(operators) && operators[length(operators)] != "(")
					output += operators[length(operators)]
					operators.len--
				parens[length(parens)]++
				expect_operand = TRUE
			if(")")
				if(expect_operand || !length(parens))
					return "misplaced \")\""
				while(length(operators) && operators[length(operators)] != "(")
					output += operators[length(operators)]
					operators.len--
				operators.len--
				var/argc = parens[length(parens)]
				parens.len--
				if(argc != ROGUE_FORMULA_GROUP)
					var/list/pending_call = operators[length(operators)]
					operators.len--
					var/wanted = GLOB.rogue_formula_functions[pending_call[1]]
					if(wanted != ROGUE_FORMULA_ANY_ARGS && wanted != argc)
						return "\"[pending_call[1]]\" takes [wanted] arguments, got [argc]"
					output += list(list(pending_call[1], argc))
				expect_operand = FALSE
			else
				var/operator = token
				if(expect_operand)
					switch(token)
						if("-")
							operator = "neg"
						if("+")
							continue
						if("not")
							operator = "not"
						else
							return "missing value before \"[token]\""
				else if(token == "not")
					return "missing operator before \"not\""
				var/precedence = GLOB.rogue_formula_precedence[operator]
				var/right_assoc = GLOB.rogue_formula_right_assoc[operator]
				while(length(operators))
					var/top = operators[length(operators)]
					if(!istext(top) || top == "(")
						break
					var/top_precedence = GLOB.rogue_formula_precedence[top]
					if(top_precedence > precedence || (top_precedence == precedence && !right_assoc))
						output += top
						operators.len--
						continue
					break
				operators += operator
				expect_operand = TRUE
	if(expect_operand)
		return "formula ends with an operator"
	while(length(operators))
		var/top = operators[length(operators)]
		if(!istext(top) || top == "(")
			return "unclosed \"(\""
		output += top
		operators.len--
	return output
