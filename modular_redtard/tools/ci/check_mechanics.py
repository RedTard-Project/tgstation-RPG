import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dynamic_values

MODULE = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
CONFIG = os.path.normpath(os.path.join(MODULE, "..", "config", "redtard", "mechanics"))
VALUES = "config/redtard/mechanics/values.txt"
FORMULA_DEFINE = re.compile(r'^#define ROGUE_FORMULA_(?!NAME_|DIGITS)[A-Z0-9_]+ "([a-z0-9_]+)"', re.MULTILINE)
VALUE_USE = re.compile(r'rogue_value(?:_or)?\("([a-z0-9_]+)"')
CONFIG_LINE = re.compile(r"^([a-z0-9_]+)\s*=\s*(.+)$", re.MULTILINE)
NUMBER = re.compile(r"^-?(?:\d+\.?\d*|\.\d+)$")


def read(path):
    return open(path, encoding="utf-8").read()


def config_entries(name):
    return dict(CONFIG_LINE.findall(read(os.path.join(CONFIG, name))))


def value_entries(problems):
    """values.txt read the way mechanics/registry.dm declares it: `name = number`, described by the `#` lines right above
    it (back to a blank line)."""
    entries = {}
    described = False
    for number, line in enumerate(read(os.path.join(CONFIG, "values.txt")).split("\n"), 1):
        line = line.strip()
        if not line:
            described = False
            continue
        if line.startswith("#"):
            described = True
            continue
        where = f"{VALUES}:{number}"
        name, equals, value = (part.strip() for part in line.partition("="))
        name = name.lower()
        if not equals:
            problems.append(f'{where}: expected "name = number"')
        else:
            if name in entries:
                problems.append(f"{where}: {name} is written twice")
            if not NUMBER.match(value):
                problems.append(f"{where}: {name} = {value} is not a number")
            if not described:
                problems.append(f"{where}: {name} has no description (a # line right above it)")
            entries[name] = value
        described = False
    return entries


def main():
    problems = []
    values = value_entries(problems)
    formulas = set(FORMULA_DEFINE.findall(read(os.path.join(MODULE, "mechanics", "_defines.dm"))))
    used = {}
    for folder, _, files in os.walk(MODULE):
        for name in files:
            if not name.endswith(".dm"):
                continue
            path = os.path.join(folder, name)
            for value_id in VALUE_USE.findall(read(path)):
                used.setdefault(value_id, os.path.relpath(path, MODULE).replace(os.sep, "/"))
    for value_id, where in sorted(used.items()):
        if value_id not in values:
            problems.append(f"{where}: rogue_value(\"{value_id}\") is not in {VALUES}")
    for value_id in sorted(values.keys() & formulas):
        problems.append(f"{VALUES}: {value_id} is also a formula, the game drops the value")
    for value_id, default, _ in dynamic_values.dynamic_values():
        if value_id not in values:
            problems.append(f"{VALUES} has no {value_id} (special or cleave pattern)")
        elif NUMBER.match(values[value_id]) and float(values[value_id]) != float(default):
            problems.append(f"{VALUES}: {value_id} = {values[value_id]}, the code default is {default}")
    public_formulas = config_entries("formulas.txt")
    for formula_id in sorted(formulas):
        if formula_id not in public_formulas:
            problems.append(f"config/redtard/mechanics/formulas.txt has no {formula_id}")
    for line in problems:
        print(line)
    if problems:
        sys.exit(1)
    print(f"{len(values)} values, {len(formulas)} formulas, {len(used)} values referenced")


if __name__ == "__main__":
    main()
