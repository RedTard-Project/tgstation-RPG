"""Move the balance numbers of modular_redtard's code into the private mechanics repository.

Subcommands (run with `py -3 -I modular_redtard/tools/private_config/code_numbers.py <subcommand> ...`):

  find                 list the numbers of the module's code: numeric #defines and numeric literals of prob(), rand(),
                       addtimer(), do_after() and other delays; writes numbers/a.tsv, b.tsv, c.tsv and numbers/manifest.md
                       to the work folder. Skips ported/, mechanics/, tests/, lighting/, localization/.
  apply <list>         replaces each row's text with rogue_value("name") and stages the entry (description and
                       name = number) in staged/<list>/<values file>. Running it again changes nothing.
  merge                moves the staged entries into config/redtard_private/mechanics/values/, refusing repeated names,
                       and prints the number files that are new (they go to rogue_value_files() in mechanics/registry.dm).
  sync                 writes the open config/redtard/mechanics/values/*.txt and armor.txt, intents.txt, items.txt from
                       the private files: the same names and descriptions, every number 10, the other table fields as they are.
  sync --check         the same as a check: writes nothing, exits 1 when an open file differs.
  sync --verify REV    the numbers of the private files equal the numbers of the open files of git revision REV.

--root points every subcommand at another copy of the repository (the tree with modular_redtard/ and config/), --work at
another work folder; the defaults are this repository and .cache/modular_redtard/agents/ch/. Git is only read (git show).
"""

import argparse
import csv
import os
import re
import subprocess
import sys

REPO = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", ".."))
DEFAULT_WORK = os.path.join(REPO, ".cache", "modular_redtard", "agents", "ch")
SKIPPED_DIRS = {"ported", "mechanics", "tests", "lighting", "localization"}
TABLES = ("armor.txt", "intents.txt", "items.txt")
LISTS = ("a", "b", "c")
DEFAULT_NUMBER = "10"
COLUMNS = ["file", "line", "col", "kind", "text", "name", "value", "desc", "values_file", "const"]
MANUAL = "manual"

# Module folder -> number file of mechanics/values/ (headers of the files say which folders they hold).
FOLDER_FILES = {
	"alchemy": "alchemy.txt",
	"burial": "burial.txt",
	"combat": "combat.txt",
	"crafting": "crafting.txt",
	"faith": "faith.txt",
	"farming": "farming.txt",
	"husbandry": "husbandry.txt",
	"library": "library.txt",
	"pve": "pve.txt",
	"ai": "pve.txt",
	"heritage": "races.txt",
	"races": "races.txt",
	"rockhill": "structures.txt",
	"survival": "survival.txt",
	"economy": "trade.txt",
	"triumphs": "triumphs.txt",
	"admin": "triumphs.txt",
	"migrants": "triumphs.txt",
}
DEFAULT_FILE = "combat.txt"  # "Combat and the rest: ... combat/, ai/, hud/ and others"

TIME_UNITS = {"MILLISECONDS": "*0.01", "DECISECONDS": "*1", "SECONDS": "*10", "MINUTES": "*600", "HOURS": "*36000"}
NUMERIC_EXPR = re.compile(r"^[\s\d.()+\-*/]*$")
NUMBER = re.compile(r"^-?\d+(\.\d+)?$")
IDENT = re.compile(r"[A-Za-z_]\w*")
DEFINE = re.compile(r"^\s*#define\s+([A-Za-z_]\w*)(?![\w(])\s+(.*?)\s*$")

STATUS_PROCS = "(?:Adjust)?(?:Paralyze|Paralyzed|Knockdown|Stun|Immobilize|Immobilized|Unconscious|Sleeping)"
# kind -> (call regex, 1-based argument numbers that may hold the number, name suffix, description, is a time)
CALLS = {
	"prob": (r"(?<![\w.])prob", (1,), "chance", "Percent chance", False),
	"rand": (r"(?<![\w.])rand", (1, 2), None, None, False),
	"addtimer": (r"(?<![\w.])addtimer", (2,), "delay", "Deciseconds before the timer fires", True),
	"do_after": (r"(?<![\w.])do_after", (2,), "time", "Deciseconds the action takes (do_after)", True),
	"sleep": (r"(?<![\w.])sleep", (1,), "pause", "Deciseconds the proc sleeps", True),
	"spawn": (r"(?<![\w.])spawn", (1,), "delay", "Deciseconds before the spawn() block runs", True),
	"cooldown": (r"(?<![\w.])(?:S_)?(?:TIMER_)?COOLDOWN_START", (3,), "cooldown", "Deciseconds of the cooldown", True),
	"status": (r"(?<![\w])" + STATUS_PROCS, (1,), None, None, True),
	"status_effect": (r"(?<![\w])apply_status_effect", (2,), "duration", "Deciseconds of the status effect", True),
}


def fail(message):
	sys.exit(f"code_numbers: {message}")


def rel(path, root):
	return os.path.relpath(path, root).replace("\\", "/")


def read_text(path):
	with open(path, encoding="utf-8-sig", errors="replace") as handle:
		return handle.read().replace("\r\n", "\n").replace("\r", "\n")


def write_text(path, text):
	os.makedirs(os.path.dirname(path), exist_ok=True)
	with open(path, "w", encoding="utf-8", newline="\n") as handle:
		handle.write(text)


def number_text(value):
	if abs(value - round(value)) < 1e-9:
		return str(int(round(value)))
	return f"{value:.6f}".rstrip("0").rstrip(".")


def evaluate(expression):
	"""Value of a numeric DM expression of literals and time units (5 SECONDS -> 50), or None."""
	text = expression
	for unit, factor in TIME_UNITS.items():
		text = re.sub(rf"\b{unit}\b", factor, text)
	if not NUMERIC_EXPR.match(text) or not re.search(r"\d", text) or "**" in text or "//" in text:
		return None
	try:
		value = eval(text, {"__builtins__": {}}, {})  # only digits, dots, parentheses and + - * / reach here
	except Exception:
		return None
	return float(value) if isinstance(value, (int, float)) else None


# --- source reading -------------------------------------------------------------------------------------------------


def mask_source(text):
	"""The lines of a DM file with comments and string contents blanked to spaces (same columns), and the comments of each line."""
	out = []
	comments = []
	in_block = False
	in_long = False
	for line in text.split("\n"):
		chars = list(line)
		comment = ""
		i = 0
		quote = None
		while i < len(chars):
			c = chars[i]
			nxt = chars[i + 1] if i + 1 < len(chars) else ""
			if in_block:
				end = line.find("*/", i)
				stop = len(chars) if end < 0 else end + 2
				for j in range(i, stop):
					chars[j] = " "
				i = stop
				in_block = end < 0
				continue
			if in_long:
				end = line.find('"}', i)
				stop = len(chars) if end < 0 else end
				for j in range(i, stop):
					chars[j] = " "
				i = stop + 2 if end >= 0 else stop
				in_long = end < 0
				continue
			if quote:
				if c == "\\":
					chars[i] = " "
					if i + 1 < len(chars):
						chars[i + 1] = " "
					i += 2
					continue
				if c == quote:
					quote = None
					i += 1
					continue
				chars[i] = " "
				i += 1
				continue
			if c == "/" and nxt == "/":
				comment = line[i:].lstrip("/").strip()
				for j in range(i, len(chars)):
					chars[j] = " "
				break
			if c == "/" and nxt == "*":
				in_block = True
				continue
			if c == "{" and nxt == '"':
				in_long = True
				i += 2
				continue
			if c in "\"'":
				quote = c
			i += 1
		out.append("".join(chars))
		comments.append(comment)
	return out, comments


def indent_of(line):
	return len(line) - len(line.lstrip("\t"))


def ancestors(masked, index):
	"""(line index, stripped text) of the enclosing lines by indentation, innermost first."""
	result = []
	level = indent_of(masked[index]) if masked[index].strip() else 0
	j = index - 1
	while level > 0 and j >= 0:
		line = masked[j]
		if line.strip() and not line.lstrip().startswith("#") and indent_of(line) < level:
			level = indent_of(line)
			result.append((j, line.strip()))
		j -= 1
	return result


def is_code_line(stripped):
	"""A proc definition or a statement: a parenthesis before any '='."""
	paren = stripped.find("(")
	if paren < 0:
		return False
	equal = stripped.find("=")
	return equal < 0 or paren < equal


PROC_DEF = re.compile(r"^(?P<path>/?[\w/]*?)/?(?:(?:proc|verb)/)?(?P<proc>\w+)\s*\(")
CONTROL = {"if", "for", "while", "switch", "spawn", "do", "else", "return", "list", "alist", "sleep", "set"}


def enclosing_proc(masked, index):
	"""(type path, proc name) of the proc a line belongs to, or (type path or None, None)."""
	chain = [(index, masked[index].strip())] + ancestors(masked, index)
	type_parts = []
	proc = None
	for _, stripped in reversed(chain):
		match = PROC_DEF.match(stripped)
		if match and is_code_line(stripped) and match.group("proc") not in CONTROL and proc is None:
			path = match.group("path")
			if path:
				type_parts.append(path)
			proc = match.group("proc")
			break
		if not is_code_line(stripped) and "=" not in stripped and re.match(r"^/?[\w/]+$", stripped):
			type_parts.append(stripped)
	type_path = "/".join(part.strip("/") for part in type_parts if part.strip("/")) or None
	if type_path:
		type_path = "/" + re.sub(r"/(?:proc|verb)$", "", type_path)
	return type_path, proc


def const_context(masked, index):
	"""Why DM needs a constant on this line, or None."""
	stripped = masked[index].strip()
	if re.match(r"#\s*(if|elif)\b", stripped):
		return "#if"
	define = DEFINE.match(masked[index])
	if define:
		return f"define {define.group(1)}"
	if re.search(r"\bvar/(?:[\w/]*/)?const\b", stripped):
		return "var/const"
	if re.search(r"\bvar/(?:[\w/]*/)?(?:static|global)\b", stripped):
		return "var/static"
	chain = ancestors(masked, index)
	if re.match(r"GLOBAL_\w*INIT\w*\s*\(", stripped) or any(re.match(r"GLOBAL_\w*INIT\w*\s*\(", text) for _, text in chain):
		return "GLOBAL_INIT"
	if chain and re.match(r"if\s*\(", stripped) and re.match(r"switch\s*\(", chain[0][1]):
		return "switch"
	if any(is_code_line(text) for _, text in chain):
		return None
	if is_code_line(stripped) and not chain:
		return None
	if re.match(r"(?:var/|[\w/]*/var/|\w+\s*=)", stripped) or chain:
		return "var initial"
	return None


def split_args(masked, open_at):
	"""(start, end) spans of the arguments of the call whose '(' is at open_at, or None when it does not close on the line."""
	depth = 0
	spans = []
	start = open_at + 1
	for i in range(open_at, len(masked)):
		c = masked[i]
		if c in "([{":
			depth += 1
		elif c in ")]}":
			depth -= 1
			if depth == 0:
				spans.append((start, i))
				return spans
		elif c == "," and depth == 1:
			spans.append((start, i))
			start = i + 1
	return None


def module_files(root, skip=True):
	base = os.path.join(root, "modular_redtard")
	for folder, dirs, files in os.walk(base):
		dirs[:] = sorted(d for d in dirs if not (skip and d in SKIPPED_DIRS) and d not in ("tools", "tgui", "node_modules"))
		for name in sorted(files):
			if name.endswith(".dm"):
				yield os.path.join(folder, name)


def registry_names(root):
	"""Every number and formula name of the open and private mechanics files."""
	names = {}
	# Private first: its numbers are the real ones (the open files hold 10 once sync has run).
	for base in ("config/redtard_private/mechanics", "config/redtard/mechanics"):
		for folder in (base, base + "/values"):
			path = os.path.join(root, folder)
			if not os.path.isdir(path):
				continue
			for file_name in os.listdir(path):
				if file_name.endswith(".txt") and file_name not in TABLES:
					for name, value, _ in parse_values(read_text(os.path.join(path, file_name))):
						names.setdefault(name, (value, file_name))
	return names


def parse_values(text):
	"""(name, value text, description) of each entry of a values or formulas file."""
	entries = []
	description = []
	for raw in text.split("\n"):
		line = raw.strip()
		if not line:
			description = []
			continue
		if line.startswith("#"):
			description.append(line[1:].strip())
			continue
		if "=" in line:
			name, value = line.split("=", 1)
			entries.append((name.strip().lower(), value.strip(), " ".join(description)))
		description = []
	return entries


def clean_name(*parts):
	text = "_".join(p for p in parts if p)
	text = re.sub(r"[^a-z0-9]+", "_", text.lower()).strip("_")
	text = re.sub(r"^rogue_", "", text)
	if not text or text[0].isdigit():
		text = "n_" + text
	return text[:64].strip("_")


def unique_name(base, taken):
	name = base
	number = 2
	while name in taken:
		name = f"{base}_{number}"
		number += 1
	taken.add(name)
	return name


def comment_above(masked, comments, index):
	lines = []
	j = index - 1
	while j >= 0 and not masked[j].strip() and comments[j]:
		lines.insert(0, comments[j])
		j -= 1
	return " ".join(lines)


def short_places(places):
	"""context: file:line, line, line (+N more); ... - one group per context and file."""
	groups = {}
	for place in dict.fromkeys(places):
		context, where = place.split(": ", 1)
		file, line = where.rsplit(":", 1)
		groups.setdefault((context, file), []).append(line)
	parts = []
	for (context, file), lines in groups.items():
		more = f" (+{len(lines) - 3} more)" if len(lines) > 3 else ""
		parts.append(f"{context}: {file}:{','.join(lines[:3])}{more}")
	return "; ".join(parts)


def clean_desc(text):
	return re.sub(r"\s+", " ", text.replace("\t", " ")).strip()


# --- find -----------------------------------------------------------------------------------------------------------


def command_find(args):
	root = args.root
	taken = set(registry_names(root))
	sources = {}
	generated = set()  # files a generator writes ("do not edit by hand"): read like ported/
	for path in module_files(root, skip=False):
		text = read_text(path)
		masked, comments = mask_source(text)
		file = rel(path, os.path.join(root, "modular_redtard"))
		sources[file] = (masked, comments)
		if "do not edit by hand" in text[:600]:
			generated.add(file)

	def skipped(file):
		return bool(SKIPPED_DIRS & set(file.split("/")[:-1])) or file in generated

	rows = []
	stats = {"define_derived": 0, "define_bits": 0, "literal_mixed": 0, "define_params": 0}
	numeric_defines = {}
	for file, (masked, comments) in sources.items():
		if skipped(file):
			continue
		group_desc = ""
		group_prefix = "\0"
		for index, line in enumerate(masked):
			match = DEFINE.match(line)
			if not match:
				if line.strip():
					group_desc = group_desc if re.match(r"^\s*#define\b", line) else ""
				elif not comments[index]:
					group_desc = ""
				if re.match(r"^\s*#define\s+\w+\(", line):
					stats["define_params"] += 1
				continue
			own = comment_above(masked, comments, index)
			if own:
				group_desc = own
				group_prefix = match.group(1).rsplit("_", 1)[0] + "_"
			name, body = match.group(1), match.group(2)
			if re.search(r"<<|>>|0x|[|&^~]", body):
				stats["define_bits"] += 1
				continue
			value = evaluate(body)
			if value is None:
				if IDENT.search(re.sub(r"\b(?:%s)\b" % "|".join(TIME_UNITS), "", body)) and re.search(r"\d", body):
					stats["define_derived"] += 1
				continue
			col = line.index(body, match.start(2))
			numeric_defines.setdefault(name, []).append(len(rows))
			inherited = group_desc if name.startswith(group_prefix) else ""
			desc = comments[index] or own or inherited
			rows.append({
				"file": file, "line": index + 1, "col": col + 1, "kind": "define", "text": body,
				"name": clean_name(name), "value": number_text(value), "desc": clean_desc(desc) or f"TODO describe {name}",
				"folder": file.split("/")[0] if "/" in file else "(root)", "places": [],
			})
		for index, line in enumerate(masked):
			for kind, (pattern, positions, suffix, phrase, is_time) in CALLS.items():
				for call in re.finditer(pattern + r"\s*\(", line):
					spans = split_args(line, call.end() - 1)
					if not spans:
						continue
					for position in positions:
						if position > len(spans):
							continue
						start, end = spans[position - 1]
						raw = line[start:end]
						text = raw.strip()
						if not text:
							continue
						value = evaluate(text)
						if value is None:
							if re.search(r"(?<![\w.])\d", text) and kind in ("prob", "rand"):
								stats["literal_mixed"] += 1
							continue
						if kind in ("sleep", "spawn") and value <= 1:
							continue
						col = start + (len(raw) - len(raw.lstrip())) + 1
						type_path, proc = enclosing_proc(masked, index)
						owner = (type_path or "").rstrip("/").split("/")[-1] if type_path else file.split("/")[-1][:-3]
						call_name = call.group(0).rstrip("( ").strip()
						if kind == "rand":
							part = "min" if position == 1 else "max"
							base = clean_name(owner, proc, "roll", part)
							what = f"{'Lowest' if position == 1 else 'Highest'} roll of rand()"
						elif kind == "status":
							base = clean_name(owner, proc, re.sub(r"^Adjust", "", call_name))
							what = f"Deciseconds of {call_name}()"
						elif kind == "status_effect":
							effect = line[spans[0][0]:spans[0][1]].strip().rstrip("/").split("/")[-1]
							base = clean_name(owner, proc, effect, suffix)
							what = f"{phrase} {effect}"
						elif kind == "cooldown" and len(spans) >= 2:
							cooldown = line[spans[1][0]:spans[1][1]].strip()
							base = clean_name(owner, proc, cooldown)
							what = f"{phrase} {cooldown}"
						else:
							base = clean_name(owner, proc, suffix)
							what = phrase
						where = f"{type_path or file}{'/' + proc + '()' if proc else ''}"
						note = comments[index] or comment_above(masked, comments, index)
						rows.append({
							"file": file, "line": index + 1, "col": col, "kind": kind, "text": text,
							"name": base, "value": number_text(value),
							"desc": clean_desc(f"{what} in {where}" + (f": {note}" if note else "") + "."),
							"folder": file.split("/")[0] if "/" in file else "(root)", "places": [],
							"_line_const": const_context(masked, index),
						})
	# Where DM needs a constant: literals by their own line, defines by every place that uses them (ported/ included).
	if numeric_defines:
		pattern = re.compile(r"\b(" + "|".join(sorted(numeric_defines, key=len, reverse=True)) + r")\b")
		for file, (masked, _) in sources.items():
			for index, line in enumerate(masked):
				for use in pattern.finditer(line):
					define = DEFINE.match(line)
					if define and define.group(1) == use.group(1):
						continue
					if re.match(r"^\s*#\s*(?:undef|ifdef|ifndef)\b", line):
						continue
					context = "ported" if ("/ported/" in f"/{file}" or file in generated) else const_context(masked, index)
					if context:
						for row_index in numeric_defines[use.group(1)]:
							rows[row_index]["places"].append(f"{context}: {file}:{index + 1}")
	for row in rows:
		line_const = row.pop("_line_const", None)
		if line_const and not line_const.startswith("define "):
			row["places"].insert(0, f"{line_const}: {row['file']}:{row['line']}")
		row["const"] = short_places(row["places"])
		row["values_file"] = FOLDER_FILES.get(row["folder"], DEFAULT_FILE)
		if row["file"].startswith("combat/surgery/"):
			row["values_file"] = "surgery.txt"
		row["name"] = unique_name(row["name"], taken)
		if not row["desc"]:
			row["desc"] = f"TODO describe #define {row['text']} of {row['file']}" if row["kind"] == "define" else "TODO"
	# Split by folders into three lists of about the same size.
	counts = {}
	for row in rows:
		counts[row["folder"]] = counts.get(row["folder"], 0) + 1
	buckets = {name: [] for name in LISTS}
	sizes = {name: 0 for name in LISTS}
	for folder in sorted(counts, key=lambda f: (-counts[f], f)):
		target = min(LISTS, key=lambda n: (sizes[n], n))
		buckets[target].append(folder)
		sizes[target] += counts[folder]
	out = os.path.join(args.work, "numbers")
	os.makedirs(out, exist_ok=True)
	for name in LISTS:
		chosen = [r for r in rows if r["folder"] in buckets[name]]
		with open(os.path.join(out, f"{name}.tsv"), "w", encoding="utf-8", newline="") as handle:
			writer = csv.writer(handle, delimiter="\t", lineterminator="\n", quoting=csv.QUOTE_MINIMAL)
			writer.writerow(COLUMNS)
			for row in chosen:
				writer.writerow([row[c] for c in COLUMNS])
	lines = [
		"# Опись чисел кода модуля (code_numbers.py find)",
		"",
		f"Всего строк: {len(rows)}. Из них с пометкой «DM ждёт константу»: {sum(1 for r in rows if r['const'])}.",
		"",
		"| Список | Строк | Константа | Папки модуля (строк) |",
		"|---|---|---|---|",
	]
	for name in LISTS:
		folders = ", ".join(f"`{f}/` ({counts[f]})" for f in sorted(buckets[name]))
		const = sum(1 for r in rows if r["folder"] in buckets[name] and r["const"])
		lines.append(f"| `{name}.tsv` | {sizes[name]} | {const} | {folders} |")
	kinds = {}
	for row in rows:
		kinds[row["kind"]] = kinds.get(row["kind"], 0) + 1
	lines += [
		"",
		"По видам: " + ", ".join(f"{k} {v}" for k, v in sorted(kinds.items())) + ".",
		"",
		"Не попали в опись: дефайны с параметрами — {define_params}; битовые и шестнадцатеричные дефайны — {define_bits};"
		" дефайны из других дефайнов — {define_derived}; prob()/rand() с выражением, где число смешано с переменными, — {literal_mixed}.".format(**stats),
		"Не смотрятся папки: " + ", ".join(f"`{d}/`" for d in sorted(SKIPPED_DIRS)) + " (а также `tools/`, `tgui/`).",
	]
	write_text(os.path.join(out, "manifest.md"), "\n".join(lines) + "\n")
	print(f"{len(rows)} rows -> " + ", ".join(f"{n}.tsv {sizes[n]}" for n in LISTS) + f"; {out}")


# --- apply ----------------------------------------------------------------------------------------------------------


def read_list(path):
	with open(path, encoding="utf-8-sig", newline="") as handle:
		rows = list(csv.DictReader(handle, delimiter="\t"))
	missing = [c for c in COLUMNS if rows and c not in rows[0]]
	if missing:
		fail(f"{path}: no columns {', '.join(missing)}")
	return rows


def anchor_pattern(row):
	text = re.escape(row["text"])
	if row["kind"] == "define":
		return re.compile(rf"^(\s*#define\s+\w+\s+){text}(?=\s*(?://.*)?$)")
	pattern = CALLS[row["kind"]][0]
	return re.compile(rf"{pattern}\s*\([^\n]*?(?<![\w.]){text}(?![\w.])")


def command_apply(args):
	root = args.root
	list_path = args.list if os.path.isfile(args.list) else os.path.join(args.work, "numbers", args.list + ("" if args.list.endswith(".tsv") else ".tsv"))
	if not os.path.isfile(list_path):
		fail(f"no list {args.list}")
	list_name = os.path.splitext(os.path.basename(list_path))[0]
	rows = read_list(list_path)
	registry = registry_names(root)
	errors = []
	staged = {}
	by_file = {}
	names = {}
	for number, row in enumerate(rows, 2):
		row["_where"] = f"{os.path.basename(list_path)}:{number}"
		name = row["name"].strip()
		row["name"] = name
		if not re.match(r"^[a-z][a-z0-9_]*$", name):
			errors.append(f"{row['_where']}: bad name \"{name}\"")
			continue
		if evaluate(row["value"]) is None:
			errors.append(f"{row['_where']}: value \"{row['value']}\" is not a number")
			continue
		if not row["desc"].strip() or row["desc"].startswith("TODO"):
			errors.append(f"{row['_where']}: {name} has no description")
			continue
		if not re.match(r"^[a-z0-9_]+\.txt$", row["values_file"]) or row["values_file"] in TABLES + ("formulas.txt",):
			errors.append(f"{row['_where']}: bad values file \"{row['values_file']}\"")
			continue
		if name in names and evaluate(names[name]["value"]) != evaluate(row["value"]):
			errors.append(f"{row['_where']}: {name} is also {names[name]['_where']} with another number")
			continue
		row["_reuse"] = name in registry
		if row["_reuse"] and evaluate(registry[name][0]) != evaluate(row["value"]):
			errors.append(f"{row['_where']}: {name} is already a mechanics number ({registry[name][1]}) with another number")
			continue
		names.setdefault(name, row)
		const = row["const"].strip()
		if const and const != MANUAL:
			print(f"skip {row['_where']}: {name}: DM needs a constant ({const}); fix it by hand and set const to {MANUAL}")
			continue
		if const != MANUAL:
			by_file.setdefault(row["file"], []).append(row)
		elif not row["_reuse"]:
			staged.setdefault(row["values_file"], {})[name] = row
	changed = []
	for file, file_rows in sorted(by_file.items()):
		path = os.path.join(root, "modular_redtard", file.replace("/", os.sep))
		if not os.path.isfile(path):
			errors.extend(f"{r['_where']}: no file {file}" for r in file_rows)
			continue
		text = read_text(path)
		lines = text.split("\n")
		edits = 0
		for row in sorted(file_rows, key=lambda r: (-int(r["line"]), -int(r["col"]))):
			replacement = f'rogue_value("{row["name"]}")'
			index = int(row["line"]) - 1
			col = int(row["col"]) - 1
			done = False
			if 0 <= index < len(lines) and lines[index][col:col + len(row["text"])] == row["text"]:
				lines[index] = lines[index][:col] + replacement + lines[index][col + len(row["text"]):]
				done = True
			elif 0 <= index < len(lines) and replacement in lines[index]:
				done = True  # applied before
			else:
				pattern = anchor_pattern(row)
				for distance in range(0, 60):
					for candidate in {index - distance, index + distance}:
						if not (0 <= candidate < len(lines)):
							continue
						if replacement in lines[candidate] and distance <= 3:
							done = True
							break
						hits = list(pattern.finditer(lines[candidate]))
						if len(hits) == 1:
							hit = hits[0]
							start = lines[candidate].index(row["text"], hit.start() + (len(hit.group(1)) if row["kind"] == "define" else 0))
							lines[candidate] = lines[candidate][:start] + replacement + lines[candidate][start + len(row["text"]):]
							done = True
							break
					if done:
						break
				if done:
					print(f"moved {row['_where']}: {row['name']} found near {file}:{row['line']}")
			if done:
				edits += 1
				if not row["_reuse"]:
					staged.setdefault(row["values_file"], {})[row["name"]] = row
			else:
				errors.append(f"{row['_where']}: \"{row['text']}\" is not at {file}:{row['line']}:{row['col']}")
		new_text = "\n".join(lines)
		if new_text != text:
			write_text(path, new_text)
			changed.append(file)
	stage_dir = os.path.join(args.work, "staged", list_name)
	os.makedirs(stage_dir, exist_ok=True)
	for name in os.listdir(stage_dir):
		if name.endswith(".txt") and name not in staged:
			os.remove(os.path.join(stage_dir, name))
	for values_file, entries in sorted(staged.items()):
		body = [f"# --- From the code of modular_redtard (code_numbers.py, list {list_name})", ""]
		for name, row in entries.items():
			body += [f"# {clean_desc(row['desc'])}", f"{name} = {number_text(evaluate(row['value']))}", ""]
		write_text(os.path.join(stage_dir, values_file), "\n".join(body))
	print(f"{list_name}: {len(changed)} files changed, {sum(len(e) for e in staged.values())} entries staged in {stage_dir}")
	for error in errors:
		print(f"error {error}")
	return 1 if errors else 0


# --- merge ----------------------------------------------------------------------------------------------------------


def values_header(file_name):
	title = file_name[:-4].replace("_", " ").capitalize()
	return (
		f"# {title}: numbers moved from the code of modular_redtard.\n"
		"# Mechanics numbers: name = value, described by the # lines right above it; times are in deciseconds. The build"
		" compiles this file in, so its numbers are the defaults; a file of the same name in"
		" config/redtard_private/mechanics/values/ is read instead when present.\n"
	)


def command_merge(args):
	root = args.root
	private_values = os.path.join(root, "config", "redtard_private", "mechanics", "values")
	if not os.path.isdir(private_values):
		fail(f"no private folder {private_values}")
	stage_root = os.path.join(args.work, "staged")
	registry = registry_names(root)
	incoming = {}
	errors = []
	for list_name in sorted(os.listdir(stage_root)) if os.path.isdir(stage_root) else []:
		folder = os.path.join(stage_root, list_name)
		if not os.path.isdir(folder):
			continue
		for file_name in sorted(os.listdir(folder)):
			if not file_name.endswith(".txt"):
				continue
			text = read_text(os.path.join(folder, file_name))
			for name, value, desc in parse_values(text):
				where = f"staged/{list_name}/{file_name}"
				if name in registry:
					if evaluate(registry[name][0]) == evaluate(value) and registry[name][1] == file_name:
						continue  # merged before
					errors.append(f"{where}: {name} is already in {registry[name][1]}")
				elif name in incoming:
					errors.append(f"{where}: {name} is also in {incoming[name][0]}")
				else:
					incoming[name] = (where, file_name, value, desc)
	if errors:
		for error in errors[:40]:
			print(f"error {error}")
		fail(f"{len(errors)} errors, nothing merged")
	by_file = {}
	for name, (where, file_name, value, desc) in incoming.items():
		by_file.setdefault(file_name, []).append((name, value, desc, where.split("/")[1]))
	new_files = []
	for file_name, entries in sorted(by_file.items()):
		path = os.path.join(private_values, file_name)
		text = read_text(path) if os.path.isfile(path) else values_header(file_name)
		if not os.path.isfile(path):
			new_files.append(file_name)
		text = text.rstrip("\n") + "\n"
		last_list = None
		for name, value, desc, list_name in entries:
			if list_name != last_list:
				text += f"\n# --- From the code of modular_redtard (code_numbers.py, list {list_name})\n"
				last_list = list_name
			text += f"\n# {desc}\n{name} = {value}\n"
		write_text(path, text)
		print(f"{file_name}: +{len(entries)}")
	print(f"merged {len(incoming)} numbers into {private_values}")
	if new_files:
		print("new number files (add to rogue_value_files() in mechanics/registry.dm): " + ", ".join(new_files))
	return 0


# --- sync -----------------------------------------------------------------------------------------------------------


def open_values_text(private_text):
	out = []
	for line in private_text.split("\n"):
		stripped = line.strip()
		if stripped and not stripped.startswith("#") and "=" in stripped:
			name = stripped.split("=", 1)[0].strip()
			out.append(f"{name} = {DEFAULT_NUMBER}")
		else:
			out.append(line)
	return "\n".join(out)


def open_table_text(private_text):
	out = []
	for line in private_text.split("\n"):
		stripped = line.strip()
		if stripped and not stripped.startswith(("#", "[")) and "=" in stripped:
			field, value = stripped.split("=", 1)
			if NUMBER.match(value.strip()):
				out.append(f"{field.strip()} = {DEFAULT_NUMBER}")
				continue
		out.append(line)
	return "\n".join(out)


def table_numbers(text):
	numbers = {}
	section = None
	for line in text.split("\n"):
		stripped = line.strip()
		if stripped.startswith("[") and stripped.endswith("]"):
			section = stripped[1:-1].strip()
		elif stripped and not stripped.startswith("#") and "=" in stripped:
			field, value = stripped.split("=", 1)
			if NUMBER.match(value.strip()):
				numbers[f"[{section}].{field.strip()}"] = value.strip()
	return numbers


def sync_pairs(root):
	private = os.path.join(root, "config", "redtard_private", "mechanics")
	public = os.path.join(root, "config", "redtard", "mechanics")
	if not os.path.isdir(private):
		fail(f"no private folder {private}")
	pairs = []
	for file_name in TABLES:
		if os.path.isfile(os.path.join(private, file_name)):
			pairs.append((f"{file_name}", os.path.join(private, file_name), os.path.join(public, file_name), True))
	for file_name in sorted(os.listdir(os.path.join(private, "values"))):
		if file_name.endswith(".txt"):
			pairs.append((f"values/{file_name}", os.path.join(private, "values", file_name), os.path.join(public, "values", file_name), False))
	return pairs, public


def git_show(revision, path):
	result = subprocess.run(
		["git", f"--git-dir={os.path.join(REPO, '.git')}", "show", f"{revision}:{path}"],
		capture_output=True, text=True, encoding="utf-8", errors="replace",
	)
	return result.stdout.replace("\r\n", "\n") if result.returncode == 0 else None


def command_sync(args):
	root = args.root
	pairs, public = sync_pairs(root)
	if args.verify:
		problems = []
		new = 0
		checked = 0
		for label, private_path, _, table in pairs:
			old = git_show(args.verify, f"config/redtard/mechanics/{label}")
			mine = read_text(private_path)
			if table:
				old_numbers = table_numbers(old or "")
				my_numbers = table_numbers(mine)
			else:
				old_numbers = {n: v for n, v, _ in parse_values(old or "")}
				my_numbers = {n: v for n, v, _ in parse_values(mine)}
			if old is None:
				new += len(my_numbers)
				continue
			for name, value in old_numbers.items():
				checked += 1
				if name not in my_numbers:
					problems.append(f"{label}: {name} is missing from the private file ({args.verify}: {value})")
				elif evaluate(my_numbers[name]) != evaluate(value):
					problems.append(f"{label}: {name} = {my_numbers[name]}, {args.verify} has {value}")
			new += len(set(my_numbers) - set(old_numbers))
		for problem in problems:
			print(problem)
		print(f"verify {args.verify}: {checked} numbers checked, {len(problems)} differ, {new} new in the private files")
		return 1 if problems else 0
	differs = []
	refused = []
	for label, private_path, public_path, table in pairs:
		private_text = read_text(private_path)
		wanted = open_table_text(private_text) if table else open_values_text(private_text)
		current = read_text(public_path) if os.path.isfile(public_path) else None
		if not table and current is not None:
			dropped = sorted({n for n, _, _ in parse_values(current)} - {n for n, _, _ in parse_values(private_text)})
			if dropped and not args.allow_drop:
				refused.append(f"{label}: the private file lacks {', '.join(dropped[:8])}{' ...' if len(dropped) > 8 else ''}")
				continue
		if current != wanted:
			differs.append(label)
			if not args.check:
				write_text(public_path, wanted)
	private_labels = {label for label, *_ in pairs}
	only_open = sorted(f"values/{n}" for n in os.listdir(os.path.join(public, "values")) if n.endswith(".txt") and f"values/{n}" not in private_labels)
	for item in refused:
		print(f"refused {item} (names the code still reads; --allow-drop writes it anyway)")
	if only_open:
		print("open files without a private file (left as they are): " + ", ".join(only_open))
	verb = "differ" if args.check else "written"
	print(f"sync{' --check' if args.check else ''}: {len(differs)} of {len(pairs)} open files {verb}" + (f": {', '.join(differs)}" if differs else ""))
	return 1 if (refused or (args.check and differs)) else 0


def main():
	parser = argparse.ArgumentParser(description=__doc__.split("\n")[0], formatter_class=argparse.RawDescriptionHelpFormatter, epilog=__doc__)
	parser.add_argument("--root", default=REPO, help="repository tree to work on (default: this repository)")
	parser.add_argument("--work", default=DEFAULT_WORK, help="work folder with numbers/ and staged/")
	commands = parser.add_subparsers(dest="command", required=True)
	commands.add_parser("find")
	apply_parser = commands.add_parser("apply")
	apply_parser.add_argument("list", help="a, b, c or the path of a .tsv list")
	commands.add_parser("merge")
	sync_parser = commands.add_parser("sync")
	sync_parser.add_argument("--check", action="store_true")
	sync_parser.add_argument("--verify", metavar="REV")
	sync_parser.add_argument("--allow-drop", action="store_true")
	args = parser.parse_args()
	args.root = os.path.abspath(args.root)
	args.work = os.path.abspath(args.work)
	handler = {"find": command_find, "apply": command_apply, "merge": command_merge, "sync": command_sync}[args.command]
	sys.exit(handler(args) or 0)


if __name__ == "__main__":
	main()
