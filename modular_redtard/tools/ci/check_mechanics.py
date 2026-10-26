import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dynamic_values

MODULE = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
CONFIG = os.path.normpath(os.path.join(MODULE, "..", "config", "redtard", "mechanics"))
VALUE_DEFINITION = re.compile(r'^\t"([a-z0-9_]+)" = list\("([^"]*)"', re.MULTILINE)
FORMULA_DEFINE = re.compile(r'^#define ROGUE_FORMULA_(?!NAME_|DIGITS)[A-Z0-9_]+ "([a-z0-9_]+)"', re.MULTILINE)
VALUE_USE = re.compile(r'rogue_value(?:_or)?\("([a-z0-9_]+)"')
CONFIG_LINE = re.compile(r"^([a-z0-9_]+)\s*=\s*(.+)$", re.MULTILINE)


def read(path):
    return open(path, encoding="utf-8").read()


def config_entries(name):
    return dict(CONFIG_LINE.findall(read(os.path.join(CONFIG, name))))


def main():
    values = dict(VALUE_DEFINITION.findall(read(os.path.join(MODULE, "mechanics", "values.dm"))))
    formulas = set(FORMULA_DEFINE.findall(read(os.path.join(MODULE, "mechanics", "_defines.dm"))))
    used = {}
    for folder, _, files in os.walk(MODULE):
        for name in files:
            if not name.endswith(".dm"):
                continue
            path = os.path.join(folder, name)
            for value_id in VALUE_USE.findall(read(path)):
                used.setdefault(value_id, os.path.relpath(path, MODULE).replace(os.sep, "/"))
    problems = []
    for value_id, where in sorted(used.items()):
        if value_id not in values:
            problems.append(f"{where}: rogue_value(\"{value_id}\") is not declared in mechanics/values.dm")
    public_values = config_entries("values.txt")
    for value_id, default in sorted(values.items()):
        if value_id not in public_values:
            problems.append(f"config/redtard/mechanics/values.txt has no {value_id}")
        elif float(public_values[value_id]) != float(default):
            problems.append(f"config/redtard/mechanics/values.txt: {value_id} = {public_values[value_id]}, the code default is {default}")
    for value_id, default, _ in dynamic_values.dynamic_values():
        if value_id not in public_values:
            problems.append(f"config/redtard/mechanics/values.txt has no {value_id} (special or cleave pattern)")
        elif float(public_values[value_id]) != float(default):
            problems.append(f"config/redtard/mechanics/values.txt: {value_id} = {public_values[value_id]}, the code default is {default}")
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
