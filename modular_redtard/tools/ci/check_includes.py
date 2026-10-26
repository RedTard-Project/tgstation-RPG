import os
import re
import sys

MODULE = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
ROOT = os.path.join(MODULE, "_module.dme")
STANDALONE = ("tests/native/",)
INCLUDE = re.compile(r'^\s*#include\s+"([^"]+)"', re.MULTILINE)


def relative(path):
    return os.path.relpath(path, MODULE).replace(os.sep, "/")


def walk(path, seen, missing):
    for target in INCLUDE.findall(open(path, encoding="utf-8").read()):
        full = os.path.normpath(os.path.join(os.path.dirname(path), target.replace("\\", "/")))
        if not os.path.isfile(full):
            missing.append(f"{relative(path)} includes {target}, which does not exist")
            continue
        if full in seen:
            continue
        seen.add(full)
        if full.endswith((".dm", ".dme")):
            walk(full, seen, missing)


def main():
    seen = set()
    missing = []
    walk(ROOT, seen, missing)
    orphans = []
    for folder, _, files in os.walk(MODULE):
        for name in files:
            full = os.path.join(folder, name)
            rel = relative(full)
            if not name.endswith(".dm") or rel.startswith(STANDALONE) or full in seen:
                continue
            orphans.append(rel)
    for line in missing:
        print(f"Missing file: {line}")
    for rel in sorted(orphans):
        print(f"Not included from _module.dme: {rel}")
    if missing or orphans:
        return 1
    print(f"modular_redtard: {len(seen)} included files, every .dm is reachable from _module.dme")
    return 0


if __name__ == "__main__":
    sys.exit(main())
