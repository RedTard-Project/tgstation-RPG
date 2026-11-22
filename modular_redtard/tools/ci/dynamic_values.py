"""The values made from types: every tunable of a special intent (special_<type>_<tunable>) and the target limit of every
cleave pattern (cleave_<type>_max_targets). The registry declares them from the types' `tunables` lists and the cleave
pattern subtypes; their numbers live in specials.txt only. Since K2a the types of combat/specials.dm, specials_azure.dm and
cleave.dm carry no numbers (NUMBERLESS_FILES); a type of another file may still set one, which then has to agree with the
private file until it moves out too."""

import os
import re

MODULE = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
TYPE_LINE = re.compile(r"^(/datum/(?:special_intent|cleave_pattern)(?:/[a-z0-9_]+)*)$")
VAR_LINE = re.compile(r"^\t(?:var/(?:list/)?)?([a-z0-9_]+) = (.+)$")
SECONDS = re.compile(r"^(-?[\d.]+) SECONDS$")

SPECIAL_FILES = ("specials.dm", "specials_azure.dm", "azure_weapons.dm")
CLEAVE_FILES = ("cleave.dm",)
NUMBERLESS_FILES = ("specials.dm", "specials_azure.dm", "cleave.dm")


def number(raw):
	raw = raw.strip()
	seconds = SECONDS.match(raw)
	if seconds:
		value = float(seconds.group(1)) * 10
	else:
		try:
			value = float(raw)
		except ValueError:
			return None
	return str(int(value)) if value == int(value) else repr(value)


def read_types(path, file_name):
	"""{type path: {var name: (raw value, file name, line number)}} of the type definitions of one file."""
	types = {}
	current = None
	for line_number, line in enumerate(open(path, encoding="utf-8").read().split("\n"), 1):
		found = TYPE_LINE.match(line)
		if found:
			current = types.setdefault(found.group(1), {})
			continue
		if not line.startswith("\t"):
			current = None
			continue
		if current is None:
			continue
		assigned = VAR_LINE.match(line)
		if assigned:
			current[assigned.group(1)] = (assigned.group(2).strip(), file_name, line_number)
	return types


def read_files(names):
	types = {}
	for name in names:
		for path, found in read_types(os.path.join(MODULE, "combat", name), name).items():
			types.setdefault(path, {}).update(found)
	return types


def parent_of(path, types):
	declared = types.get(path, {}).get("parent_type")
	if declared:
		return declared[0]
	return path.rsplit("/", 1)[0]


def resolve(path, name, types):
	"""(raw value, file name, line number) of the nearest assignment of `name` up the type tree, or None."""
	while path and path.count("/") >= 2:
		if name in types.get(path, {}):
			return types[path][name]
		path = parent_of(path, types)
	return None


def raw_of(found, default=""):
	return found[0] if found else default


def special_values():
	"""(id, number the types set or None, description, where the number is written or None) of every special tunable."""
	types = read_files(SPECIAL_FILES)
	out = []
	for path in sorted(types):
		if path == "/datum/special_intent":
			continue
		tunables = re.findall(r'"([a-z0-9_]+)"', raw_of(resolve(path, "tunables", types)))
		key = "special_" + path[len("/datum/special_intent/"):].replace("/", "_")
		name = raw_of(resolve(path, "name", types), '""').strip('"')
		for tunable in tunables:
			found = resolve(path, tunable, types)
			value = number(found[0]) if found else None
			where = f"{found[1]}:{found[2]}" if found and value is not None else None
			out.append((f"{key}_{tunable}", value, f"{name}: {tunable}. Times are in deciseconds.", where))
	return out


def cleave_values():
	types = read_files(CLEAVE_FILES)
	out = []
	for path in sorted(types):
		if path == "/datum/cleave_pattern":
			continue
		key = "cleave_" + path[len("/datum/cleave_pattern/"):].replace("/", "_") + "_max_targets"
		desc = raw_of(resolve(path, "desc", types), '""').strip('"')
		found = resolve(path, "max_targets", types)
		value = number(found[0]) if found else None
		where = f"{found[1]}:{found[2]}" if found and value is not None else None
		out.append((key, value, f"Most extra targets of a cleave: {desc}", where))
	return out


def dynamic_values():
	return special_values() + cleave_values()


if __name__ == "__main__":
	for value_id, value, desc, where in dynamic_values():
		print(f"# {desc}\n{value_id} = {value}{f'  ({where})' if where else ''}\n")
