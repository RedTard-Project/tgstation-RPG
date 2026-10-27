"""Russian descriptions of this build's types from Vibelin's translation (modular_redtard/localization).

Vibelin keys its translated item descriptions by type path (strings/descriptions_vibelin.txt, a copy of its
modular_abel/localization/strings/descriptions.txt), and its paths are Vanderlin's, which this build mostly does not
have. The same Roguetown lineage writes the same English, though, so the translation is carried by the text: every
Vibelin type in the file gives its English desc (read from Vibelin's source) and its Russian; every type of this
build (TG's code, then the module's) whose desc reads exactly that English gets that Russian under its own path, and
so do its subtypes that inherit the desc.

The module's own translations, of the descriptions Vibelin never had, are two sets keyed by the type that declares the
desc: strings/module_descriptions_en.txt holds the English the translation was made from, module_descriptions_ru.txt
the Russian. A type whose desc in the code no longer reads as its English line is reported and left out, so the item
reads in English until both sets are brought up to date; its subtypes that inherit the desc get the same Russian.

The result is strings/descriptions.txt, which the game loads.

Run from the repository root:  python modular_redtard/tools/port_localization.py [--vibelin ../Vibelin]
"""

import argparse
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import port_rockhill as porter  # noqa: E402  (the porter's DM reader)

STRINGS = 'modular_redtard/localization/strings'
SOURCE = f'{STRINGS}/descriptions_vibelin.txt'
# The module's own translations, for the descriptions Vibelin never had: two sets keyed by the type declaring the desc.
MODULE_ENGLISH = f'{STRINGS}/module_descriptions_en.txt'
MODULE_RUSSIAN = f'{STRINGS}/module_descriptions_ru.txt'
TARGET = f'{STRINGS}/descriptions.txt'
SEPARATOR = ' = '


def read_pairs(path):
    pairs = []
    for line in open(path, encoding='utf-8'):
        line = line.strip()
        if not line or line.startswith('#') or SEPARATOR not in line:
            continue
        key, value = line.split(SEPARATOR, 1)
        pairs.append((key.strip(), value.strip()))
    return pairs


def literal_desc(base, path):
    """The type's desc as the text DM shows, when it is one plain string; None when it is built or absent."""
    raw = base.resolve(path, 'desc')
    text = porter.string_value(raw) if raw else None
    if not text or '[' in text:
        return None
    # The strings format writes a line break as \n, as DM does inside a string; quotes come unescaped.
    return text[1:-1].replace('\\"', '"').replace('\\improper ', '').replace('\\proper ', '')


def module_codebase(roots):
    files = []
    for root in roots:
        for folder, _, names in os.walk(root):
            files += [os.path.join(folder, name) for name in names if name.endswith('.dm')]
    original = porter.included_files
    porter.included_files = lambda _root: files
    try:
        types, _ = porter.parse_codebase('.')
    finally:
        porter.included_files = original
    return types


def module_translations(build):
    """Russian by type from the module's two sets; a type in only one set, gone from the build, or whose English in the
    code no longer reads as the set's is reported and left out."""
    english = dict(read_pairs(MODULE_ENGLISH))
    russian = dict(read_pairs(MODULE_RUSSIAN))
    usable = {}
    for path in sorted(english.keys() | russian.keys()):
        if path not in english or path not in russian:
            print(f'  {path}: in only one of the two module sets, skipped')
        elif path not in build.types:
            print(f'  {path}: no such type in this build, skipped')
        elif (literal_desc(build, path) or '').strip() != english[path]:
            print(f'  {path}: the English desc changed, the translation is out of date, skipped')
        else:
            usable[path] = russian[path]
    return usable


def module_russian(build, module, path):
    """The module's Russian for path: its own, or a parent's it inherits the desc from unchanged."""
    seen = set()
    while path and path not in seen:
        seen.add(path)
        if path in module:
            return module[path]
        if build.types.get(path, {}).get('desc') is not None:
            return None
        path = build.parent(path)
    return None


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--vibelin', default='../Vibelin')
    args = parser.parse_args()
    if not os.path.exists('tgstation.dme'):
        sys.exit('run from the repository root')

    print('parsing Vibelin', args.vibelin)
    vibelin = porter.Codebase(porter.parse_codebase(args.vibelin)[0])
    russian_by_english = {}
    for key, russian in read_pairs(SOURCE):
        english = literal_desc(vibelin, key) if key in vibelin.types else None
        if english and english not in russian_by_english:
            russian_by_english[english] = russian
    print(f'{len(russian_by_english)} English descriptions with a Russian one from Vibelin')

    print('parsing this build')
    ours = dict(porter.parse_codebase('.')[0])
    for path, block in module_codebase(['modular_redtard']).items():
        ours.setdefault(path, {}).update(block)
    build = porter.Codebase(ours)
    module = module_translations(build)
    print(f'{len(module)} types with the module\'s own translation')
    lines = []
    for path in sorted(build.types):
        english = literal_desc(build, path)
        if not english:
            continue
        # The strings format trims its keys, so a desc with a stray edge space is found trimmed.
        russian = (module_russian(build, module, path) or russian_by_english.get(english)
                   or russian_by_english.get(english.strip()))
        if russian:
            lines.append(f'{path}{SEPARATOR}{russian}')
    header = [
        '# Generated by modular_redtard/tools/port_localization.py from descriptions_vibelin.txt: do not edit by hand.',
        '# Each line is a type of this build whose English desc Vibelin or the module\'s two sets translated.',
    ]
    open(TARGET, 'w', encoding='utf-8', newline='\n').write('\n'.join(header + lines) + '\n')
    print(f'{TARGET}: {len(lines)} types')


if __name__ == '__main__':
    main()
