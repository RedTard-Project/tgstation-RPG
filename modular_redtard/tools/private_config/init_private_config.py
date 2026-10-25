import argparse
import os
import shutil
import sys

REPO = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", ".."))
PUBLIC = os.path.join(REPO, "config", "redtard")
README = """# redtard private config

Private balance for modular_redtard. The server repository mounts this repository as a git submodule at
`config/redtard_private/`:

    git submodule add <url of this repository> config/redtard_private

What the module reads from here, before the public defaults in `config/redtard/`:

- `mechanics/armor.txt`, `intents.txt`, `items.txt`, `formulas.txt`: a file here replaces the public file of the
  same name as a whole; a file that is missing here falls back to `config/redtard/mechanics/`.
- `config.txt`: loaded after `config/redtard/config.txt`; only the keys written here change, the rest keep the
  public values.

The Rogue Mechanics admin panel saves formulas here when this folder exists.

Without access to this repository (CI, public clones) the server builds and runs on the public defaults.
"""


def main():
    parser = argparse.ArgumentParser(description="Lay out a private balance repository from the current public configs.")
    parser.add_argument("target", help="an empty folder that becomes the private repository")
    parser.add_argument("--with-config", action="store_true", help="also copy config/redtard/config.txt")
    args = parser.parse_args()
    target = os.path.abspath(args.target)
    if os.path.exists(target) and os.listdir(target):
        sys.exit(f"{target} is not empty")
    os.makedirs(os.path.join(target, "mechanics"), exist_ok=True)
    copied = []
    for name in sorted(os.listdir(os.path.join(PUBLIC, "mechanics"))):
        if name.endswith(".txt"):
            shutil.copyfile(os.path.join(PUBLIC, "mechanics", name), os.path.join(target, "mechanics", name))
            copied.append(f"mechanics/{name}")
    if args.with_config:
        shutil.copyfile(os.path.join(PUBLIC, "config.txt"), os.path.join(target, "config.txt"))
        copied.append("config.txt")
    with open(os.path.join(target, "README.md"), "w", encoding="utf-8", newline="\n") as readme:
        readme.write(README)
    print(f"{target}: {', '.join(copied)}, README.md")
    print("Next: git init there, commit, push to a private repository, then from the server repository:")
    print("    git submodule add <url> config/redtard_private")


if __name__ == "__main__":
    main()
