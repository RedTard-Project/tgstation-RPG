"""Checks the mechanics numbers against the main rule: the open config/redtard/mechanics/ holds names and descriptions with
the number 10, the real numbers live in config/redtard_private/mechanics/ (a private repository, absent in CI).

Open files: every value and formula is 10 and described, every number field of a table is 10, every rogue_value("...")
of the module is written in an open value file, rogue_value_files() names exactly the files of the folder. Where the
private folder is present: its files and entry names match the open ones, its values are described numbers. Everywhere:
no private file is compiled in as a file literal, and rogue_value_or() never falls back to a balance number."""

import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dynamic_values

MODULE = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
ROOT = os.path.normpath(os.path.join(MODULE, ".."))
CONFIG = os.path.join(ROOT, "config", "redtard", "mechanics")
PRIVATE = os.path.join(ROOT, "config", "redtard_private", "mechanics")
OPEN_LABEL = "config/redtard/mechanics"
PRIVATE_LABEL = "config/redtard_private/mechanics"
VALUES = f"{OPEN_LABEL}/values"
TYPE_VALUES_FILE = "specials.txt"
FORMULAS_FILE = "formulas.txt"
TABLE_FILES = ("armor.txt", "intents.txt", "items.txt")
OPEN_NUMBER = 10
FORMULA_DEFINE = re.compile(r'^#define ROGUE_FORMULA_(?!NAME_|DIGITS)[A-Z0-9_]+ "([a-z0-9_]+)"', re.MULTILINE)
VALUE_USE = re.compile(r'rogue_value(?:_or)?\("([a-z0-9_]+)"')
VALUE_OR_CALL = re.compile(r"\brogue_value_or\(")
NEUTRAL_FALLBACKS = {"0", "1"}
VALUE_FILE_ENTRY = re.compile(r"^\s*\"([a-z0-9_]+\.txt)\" = 'config/redtard/mechanics/values/([a-z0-9_]+\.txt)',?\s*$", re.MULTILINE)
PRIVATE_LITERAL = re.compile(r"'[^'\n]*redtard_private[^'\n]*'")
NUMBER = re.compile(r"^-?(?:\d+\.?\d*|\.\d+)$")


def read(path):
    return open(path, encoding="utf-8").read()


def is_open_number(value):
    return NUMBER.match(value) is not None and float(value) == OPEN_NUMBER


def entry_file(path, label, problems, kind):
    """A file of `name = text` entries, each described by the `#` lines right above it (back to a blank line), the way
    mechanics/registry.dm reads them. kind is "value" (text must be a number) or "formula". Returns {name: (text, line)}."""
    entries = {}
    described = False
    for number, line in enumerate(read(path).split("\n"), 1):
        line = line.strip()
        if not line:
            described = False
            continue
        if line.startswith("#"):
            described = True
            continue
        where = f"{label}:{number}"
        name, equals, text = (part.strip() for part in line.partition("="))
        name = name.lower()
        if not equals:
            problems.append(f'{where}: expected "name = {"number" if kind == "value" else "expression"}"')
        else:
            if name in entries:
                problems.append(f"{where}: {name} is already written at line {entries[name][1]}")
            if kind == "value" and not NUMBER.match(text):
                problems.append(f"{where}: {name} = {text} is not a number")
            if not described:
                problems.append(f"{where}: {name} has no description (a # line right above it)")
            entries.setdefault(name, (text, number))
        described = False
    return entries


def value_files(folder):
    values_dir = os.path.join(folder, "values")
    if not os.path.isdir(values_dir):
        return []
    return sorted(name for name in os.listdir(values_dir) if name.endswith(".txt"))


def value_entries(folder, label, problems):
    """Every value of folder/values/: {name: (number, file, line)}; a name written in two files is a problem."""
    entries = {}
    per_file = {}
    for file_name in value_files(folder):
        found = entry_file(os.path.join(folder, "values", file_name), f"{label}/values/{file_name}", problems, "value")
        per_file[file_name] = found
        for name, (value, line) in found.items():
            if name in entries:
                _, first_file, first_line = entries[name]
                problems.append(f"{label}/values/{file_name}:{line}: {name} is already written at {label}/values/{first_file}:{first_line}")
                continue
            entries[name] = (value, file_name, line)
    return entries, per_file


def table_numbers(path, label, problems):
    """Number fields of a table (armor, intents, items) must be 10 in the open file; other fields stay as they are."""
    if not os.path.exists(path):
        problems.append(f"{label} is missing")
        return
    for number, line in enumerate(read(path).split("\n"), 1):
        line = line.strip()
        if not line or line.startswith("#") or line.startswith("["):
            continue
        field, equals, text = (part.strip() for part in line.partition("="))
        if equals and NUMBER.match(text) and not is_open_number(text):
            problems.append(f"{label}:{number}: {field} = {text}, the open file holds {OPEN_NUMBER} (the real number goes to {PRIVATE_LABEL})")


def check_file_list(problems):
    """rogue_value_files() in mechanics/registry.dm compiles the files in; it must name every file of the folder."""
    listed = {}
    for key, literal in VALUE_FILE_ENTRY.findall(read(os.path.join(MODULE, "mechanics", "registry.dm"))):
        if key != literal:
            problems.append(f'mechanics/registry.dm: rogue_value_files() names "{key}" with the file {literal}')
        listed[key] = literal
    present = set(value_files(CONFIG))
    for name in sorted(present - listed.keys()):
        problems.append(f"{VALUES}/{name} is not in rogue_value_files() (mechanics/registry.dm), so the game never reads it")
    for name in sorted(listed.keys() - present):
        problems.append(f"mechanics/registry.dm: rogue_value_files() names {name}, which {VALUES} does not have")
    return present


def call_arguments(text, start):
    """Top-level arguments of the call whose `(` is at text[start - 1]; None if the call is not closed."""
    depth = 1
    quoted = False
    arguments = []
    current = start
    index = start
    while index < len(text):
        char = text[index]
        if quoted:
            if char == "\\":
                index += 1
            elif char == '"':
                quoted = False
        elif char == '"':
            quoted = True
        elif char in "([":
            depth += 1
        elif char in ")]":
            depth -= 1
            if depth == 0:
                arguments.append(text[current:index].strip())
                return arguments
        elif char == "," and depth == 1:
            arguments.append(text[current:index].strip())
            current = index + 1
        index += 1
    return None


def module_files(extensions):
    for folder, _, names in os.walk(MODULE):
        for name in names:
            if name.endswith(extensions):
                path = os.path.join(folder, name)
                yield path, os.path.relpath(path, MODULE).replace(os.sep, "/")


def check_code(problems):
    """Returns {value id: first file using it}; reports balance fallbacks of rogue_value_or() and private file literals."""
    used = {}
    for path, where in module_files((".dm", ".dme")):
        text = read(path)
        for match in PRIVATE_LITERAL.finditer(text):
            line = text.count("\n", 0, match.start()) + 1
            problems.append(f"{where}:{line}: {match.group(0)} compiles a private file into the .rsc; read it at run time with file2text()")
        if not where.endswith(".dm"):
            continue
        for value_id in VALUE_USE.findall(text):
            used.setdefault(value_id, where)
        for match in VALUE_OR_CALL.finditer(text):
            arguments = call_arguments(text, match.end())
            if not arguments or len(arguments) != 2:
                continue
            fallback = arguments[1]
            if NUMBER.match(fallback) and fallback not in NEUTRAL_FALLBACKS:
                line = text.count("\n", 0, match.start()) + 1
                problems.append(f"{where}:{line}: rogue_value_or() falls back to {fallback}; a fallback means none (0, 1 or null), the number goes to a value file")
    for dme in os.listdir(ROOT):
        if dme.endswith(".dme"):
            text = read(os.path.join(ROOT, dme))
            for match in PRIVATE_LITERAL.finditer(text):
                problems.append(f"{dme}: {match.group(0)} compiles a private file into the .rsc")
    return used


def check_private(open_files, open_per_file, open_formulas, problems):
    """Where config/redtard_private/mechanics exists: the same files and entry names as the open folder. Returns its values."""
    if not os.path.isdir(PRIVATE):
        return None
    private_values, private_per_file = value_entries(PRIVATE, PRIVATE_LABEL, problems)
    private_files = set(value_files(PRIVATE))
    for name in sorted(open_files - private_files):
        problems.append(f"{PRIVATE_LABEL}/values/{name} is missing ({VALUES}/{name} has it)")
    for name in sorted(private_files - open_files):
        problems.append(f"{PRIVATE_LABEL}/values/{name} has no open file {VALUES}/{name} (sync writes it)")
    for name in sorted(open_files & private_files):
        open_names = set(open_per_file.get(name, {}))
        private_names = set(private_per_file.get(name, {}))
        for value_id in sorted(open_names - private_names):
            problems.append(f"{PRIVATE_LABEL}/values/{name} has no {value_id} ({VALUES}/{name} has it)")
        for value_id in sorted(private_names - open_names):
            problems.append(f"{VALUES}/{name} has no {value_id} ({PRIVATE_LABEL}/values/{name} has it; sync writes it)")
    for name in (FORMULAS_FILE,) + TABLE_FILES:
        if not os.path.exists(os.path.join(PRIVATE, name)):
            problems.append(f"{PRIVATE_LABEL}/{name} is missing")
    private_formulas_path = os.path.join(PRIVATE, FORMULAS_FILE)
    if os.path.exists(private_formulas_path):
        private_formulas = entry_file(private_formulas_path, f"{PRIVATE_LABEL}/{FORMULAS_FILE}", problems, "formula")
        for formula_id in sorted(set(open_formulas) - set(private_formulas)):
            problems.append(f"{PRIVATE_LABEL}/{FORMULAS_FILE} has no {formula_id}")
        for formula_id in sorted(set(private_formulas) - set(open_formulas)):
            problems.append(f"{OPEN_LABEL}/{FORMULAS_FILE} has no {formula_id} ({PRIVATE_LABEL}/{FORMULAS_FILE} has it)")
    return private_values


def main():
    problems = []
    values, per_file = value_entries(CONFIG, OPEN_LABEL, problems)
    for value_id, (value, file_name, line) in sorted(values.items()):
        if NUMBER.match(value) and not is_open_number(value):
            problems.append(f"{VALUES}/{file_name}:{line}: {value_id} = {value}, the open file holds {OPEN_NUMBER} (the real number goes to {PRIVATE_LABEL}/values/{file_name})")
    files = check_file_list(problems)
    formulas = set(FORMULA_DEFINE.findall(read(os.path.join(MODULE, "mechanics", "_defines.dm"))))
    public_formulas = entry_file(os.path.join(CONFIG, FORMULAS_FILE), f"{OPEN_LABEL}/{FORMULAS_FILE}", problems, "formula")
    for formula_id, (text, line) in sorted(public_formulas.items()):
        if formula_id not in formulas:
            problems.append(f"{OPEN_LABEL}/{FORMULAS_FILE}:{line}: no formula {formula_id} in mechanics/_defines.dm")
        if not is_open_number(text):
            problems.append(f"{OPEN_LABEL}/{FORMULAS_FILE}:{line}: {formula_id} = {text}, the open file holds {OPEN_NUMBER} (the expression goes to {PRIVATE_LABEL}/{FORMULAS_FILE})")
    for formula_id in sorted(formulas - public_formulas.keys()):
        problems.append(f"{OPEN_LABEL}/{FORMULAS_FILE} has no {formula_id}")
    for name in TABLE_FILES:
        table_numbers(os.path.join(CONFIG, name), f"{OPEN_LABEL}/{name}", problems)
    used = check_code(problems)
    for value_id, where in sorted(used.items()):
        if value_id not in values:
            problems.append(f"{where}: rogue_value(\"{value_id}\") is in no file of {VALUES}")
    for value_id in sorted(values.keys() & formulas):
        _, file_name, line = values[value_id]
        problems.append(f"{VALUES}/{file_name}:{line}: {value_id} is also a formula, the game drops the value")
    private_values = check_private(files, per_file, public_formulas, problems)
    # The values made from types (special tunables, cleave target limits) live in specials.txt. Since K2a the types of
    # dynamic_values.NUMBERLESS_FILES carry no numbers; a type elsewhere that still sets one must agree with the private file.
    for value_id, default, _, where in dynamic_values.dynamic_values():
        if value_id not in values:
            problems.append(f"{VALUES}/{TYPE_VALUES_FILE} has no {value_id} (special or cleave pattern)")
            continue
        _, file_name, line = values[value_id]
        if file_name != TYPE_VALUES_FILE:
            problems.append(f"{VALUES}/{file_name}:{line}: {value_id} is made from a type and belongs in {TYPE_VALUES_FILE}")
        if where is None:
            continue
        if where.split(":")[0] in dynamic_values.NUMBERLESS_FILES:
            problems.append(f"combat/{where}: sets {default} for {value_id}; the number belongs in {TYPE_VALUES_FILE} only, the type keeps the bare var")
            continue
        if private_values is None or value_id not in private_values:
            continue
        value, file_name, line = private_values[value_id]
        if NUMBER.match(value) and float(value) != float(default):
            problems.append(f"{PRIVATE_LABEL}/values/{file_name}:{line}: {value_id} = {value}, the code default ({where}) is {default}")
    for line in problems:
        print(line)
    if problems:
        sys.exit(1)
    private = "no private folder" if private_values is None else f"private folder matches ({len(private_values)} values)"
    print(f"{len(values)} values in {len(files)} files, {len(formulas)} formulas, {len(used)} values referenced, {private}")


if __name__ == "__main__":
    main()
