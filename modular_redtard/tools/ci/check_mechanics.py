import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dynamic_values

MODULE = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
CONFIG = os.path.normpath(os.path.join(MODULE, "..", "config", "redtard", "mechanics"))
VALUES_DIR = os.path.join(CONFIG, "values")
VALUES = "config/redtard/mechanics/values"
TYPE_VALUES_FILE = "specials.txt"
FORMULA_DEFINE = re.compile(r'^#define ROGUE_FORMULA_(?!NAME_|DIGITS)[A-Z0-9_]+ "([a-z0-9_]+)"', re.MULTILINE)
VALUE_USE = re.compile(r'rogue_value(?:_or)?\("([a-z0-9_]+)"')
VALUE_FILE_ENTRY = re.compile(r"^\s*\"([a-z0-9_]+\.txt)\" = 'config/redtard/mechanics/values/([a-z0-9_]+\.txt)',?\s*$", re.MULTILINE)
CONFIG_LINE = re.compile(r"^([a-z0-9_]+)\s*=\s*(.+)$", re.MULTILINE)
NUMBER = re.compile(r"^-?(?:\d+\.?\d*|\.\d+)$")


def read(path):
    return open(path, encoding="utf-8").read()


def config_entries(name):
    return dict(CONFIG_LINE.findall(read(os.path.join(CONFIG, name))))


def value_files():
    return sorted(name for name in os.listdir(VALUES_DIR) if name.endswith(".txt"))


def value_entries(problems):
    """The files of config/redtard/mechanics/values/ read the way mechanics/registry.dm declares them: `name = number`,
    described by the `#` lines right above it (back to a blank line). Returns {name: (value, file, line)}."""
    entries = {}
    for file_name in value_files():
        described = False
        for number, line in enumerate(read(os.path.join(VALUES_DIR, file_name)).split("\n"), 1):
            line = line.strip()
            if not line:
                described = False
                continue
            if line.startswith("#"):
                described = True
                continue
            where = f"{VALUES}/{file_name}:{number}"
            name, equals, value = (part.strip() for part in line.partition("="))
            name = name.lower()
            if not equals:
                problems.append(f'{where}: expected "name = number"')
            else:
                if name in entries:
                    _, first_file, first_line = entries[name]
                    problems.append(f"{where}: {name} is already written at {VALUES}/{first_file}:{first_line}")
                if not NUMBER.match(value):
                    problems.append(f"{where}: {name} = {value} is not a number")
                if not described:
                    problems.append(f"{where}: {name} has no description (a # line right above it)")
                entries.setdefault(name, (value, file_name, number))
            described = False
    return entries


def check_file_list(problems):
    """rogue_value_files() in mechanics/registry.dm compiles the files in; it must name every file of the folder."""
    listed = {}
    for key, literal in VALUE_FILE_ENTRY.findall(read(os.path.join(MODULE, "mechanics", "registry.dm"))):
        if key != literal:
            problems.append(f'mechanics/registry.dm: rogue_value_files() names "{key}" with the file {literal}')
        listed[key] = literal
    present = set(value_files())
    for name in sorted(present - listed.keys()):
        problems.append(f"{VALUES}/{name} is not in rogue_value_files() (mechanics/registry.dm), so the game never reads it")
    for name in sorted(listed.keys() - present):
        problems.append(f"mechanics/registry.dm: rogue_value_files() names {name}, which {VALUES} does not have")
    return present


def main():
    problems = []
    values = value_entries(problems)
    files = check_file_list(problems)
    formulas = set(FORMULA_DEFINE.findall(read(os.path.join(MODULE, "mechanics", "_defines.dm"))))
    used = {}
    for folder, _, names in os.walk(MODULE):
        for name in names:
            if not name.endswith(".dm"):
                continue
            path = os.path.join(folder, name)
            for value_id in VALUE_USE.findall(read(path)):
                used.setdefault(value_id, os.path.relpath(path, MODULE).replace(os.sep, "/"))
    for value_id, where in sorted(used.items()):
        if value_id not in values:
            problems.append(f"{where}: rogue_value(\"{value_id}\") is in no file of {VALUES}")
    for value_id in sorted(values.keys() & formulas):
        _, file_name, line = values[value_id]
        problems.append(f"{VALUES}/{file_name}:{line}: {value_id} is also a formula, the game drops the value")
    for value_id, default, _ in dynamic_values.dynamic_values():
        if value_id not in values:
            problems.append(f"{VALUES}/{TYPE_VALUES_FILE} has no {value_id} (special or cleave pattern)")
            continue
        value, file_name, line = values[value_id]
        if file_name != TYPE_VALUES_FILE:
            problems.append(f"{VALUES}/{file_name}:{line}: {value_id} is made from a type and belongs in {TYPE_VALUES_FILE}")
        elif NUMBER.match(value) and float(value) != float(default):
            problems.append(f"{VALUES}/{file_name}:{line}: {value_id} = {value}, the code default is {default}")
    public_formulas = config_entries("formulas.txt")
    for formula_id in sorted(formulas):
        if formula_id not in public_formulas:
            problems.append(f"config/redtard/mechanics/formulas.txt has no {formula_id}")
    for line in problems:
        print(line)
    if problems:
        sys.exit(1)
    print(f"{len(values)} values in {len(files)} files, {len(formulas)} formulas, {len(used)} values referenced")


if __name__ == "__main__":
    main()
