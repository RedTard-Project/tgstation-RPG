"""How much of the build the server-side translation covers, and what is left to translate.

Descriptions: types whose desc is one plain string (no [interpolation]) and that strings/descriptions.txt lists.
Names: distinct names, article dropped, found case-insensitively in the noun files (items.txt, nouns.txt and the
module's module_items.txt, module_nouns.txt), which the chat declines and the examine title uses.
Traits: entries of rogue_trait_descriptions (rockhill/ported/_traits.dm) whose trait name traits.txt translates.

Scope "module" (default) counts the types the module's own .dm files mention; "build" counts every type of TG and
the module. With --out the untranslated entries are written as TSV for translating:
  desc_todo.tsv    declaring path, module types that show it, a name, English desc (key the two module sets by the
                   declaring path: port_localization.py gives its subtypes the same Russian)
  name_todo.tsv    name, types with it, one such type, its desc
  traits_todo.tsv  trait name (the traits.txt key), English description

Run from the repository root:
  python -I modular_redtard/tools/localization_todo.py [--scope module|build] [--out DIR] [type prefix ...]
Prefixes default to /obj/item /obj/structure /obj/machinery.
"""

import argparse
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import port_rockhill as porter  # noqa: E402
import port_localization as loc  # noqa: E402

STRINGS = loc.STRINGS
NOUN_FILES = ('items.txt', 'nouns.txt', 'module_items.txt', 'module_nouns.txt')
TRAITS = 'modular_redtard/rockhill/ported/_traits.dm'
ARTICLE = re.compile(r'^(?:a|an|the|some) ', re.I)


def keys(name):
    path = f'{STRINGS}/{name}'
    return {key for key, _ in loc.read_pairs(path)} if os.path.exists(path) else set()


def literal(build, path, var):
    raw = build.resolve(path, var)
    text = porter.string_value(raw) if raw else None
    if not text or '[' in text:
        return None
    return text[1:-1].replace('\\"', '"').replace('\\improper ', '').replace('\\proper ', '').strip()


def declaring(build, path, var):
    seen = set()
    while path and path not in seen:
        seen.add(path)
        if build.types.get(path, {}).get(var) is not None:
            return path
        path = build.parent(path)
    return None


def trait_rows(sheet):
    """(trait name, English description, translated?) for every rogue_trait_descriptions entry."""
    text = open(TRAITS, encoding='utf-8').read()
    names = dict(re.findall(r'^#define (TRAIT_\w+)\s+"([^"]*)"', text, re.M))
    for root in ('code/__DEFINES', 'modular_redtard'):
        for folder, _, files in os.walk(root):
            for file in files:
                if file.endswith('.dm'):
                    for define, name in re.findall(r'^#define (TRAIT_\w+)\s+"([^"]*)"',
                                                   open(os.path.join(folder, file), encoding='utf-8',
                                                        errors='ignore').read(), re.M):
                        names.setdefault(define, name)
    body = text.split('GLOBAL_LIST_INIT(rogue_trait_descriptions', 1)[1]
    rows = []
    for define, english in re.findall(r'^\s*(TRAIT_\w+)\s*=\s*(?:span_\w+\()?"((?:[^"\\]|\\.)*)"', body, re.M):
        name = names.get(define, define)
        rows.append((name, english, name in sheet))
    return rows


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('prefixes', nargs='*', default=['/obj/item', '/obj/structure', '/obj/machinery'])
    parser.add_argument('--scope', choices=('module', 'build'), default='module')
    parser.add_argument('--out', help='folder for the TSV lists of what is left')
    args = parser.parse_args()
    if not os.path.exists('tgstation.dme'):
        sys.exit('run from the repository root')

    ours = dict(porter.parse_codebase('.')[0])
    module = loc.module_codebase(['modular_redtard'])
    for path, block in module.items():
        ours.setdefault(path, {}).update(block)
    build = porter.Codebase(ours)
    scope = set(module) if args.scope == 'module' else set(build.types)
    described = keys('descriptions.txt')
    nouns = {key.lower() for name in NOUN_FILES for key in keys(name)}

    descs, names = {}, {}
    for prefix in args.prefixes:
        types = sorted(p for p in scope if p == prefix or p.startswith(prefix + '/'))
        with_desc = done_desc = 0
        seen_names, done_names = set(), set()
        for path in types:
            desc, name = literal(build, path, 'desc'), literal(build, path, 'name')
            if desc:
                with_desc += 1
                if path in described:
                    done_desc += 1
                else:
                    entry = descs.setdefault(declaring(build, path, 'desc'), [0, name or '', desc])
                    entry[0] += 1
            if name:
                bare = ARTICLE.sub('', name)
                seen_names.add(bare.lower())
                if bare.lower() in nouns:
                    done_names.add(bare.lower())
                else:
                    entry = names.setdefault(bare, [0, path, desc or ''])
                    entry[0] += 1
        print(f'{args.scope:6} {prefix:15} types {len(types):6}  desc {done_desc:5}/{with_desc:5}'
              f'  names {len(done_names):5}/{len(seen_names):5}')
    traits = trait_rows(keys('traits.txt'))
    print(f'traits: {sum(1 for row in traits if row[2])}/{len(traits)} entries of rogue_trait_descriptions')

    if args.out:
        os.makedirs(args.out, exist_ok=True)
        with open(os.path.join(args.out, 'desc_todo.tsv'), 'w', encoding='utf-8', newline='\n') as out:
            for path, (count, name, desc) in sorted(descs.items()):
                out.write(f'{path}\t{count}\t{name}\t{desc}\n')
        with open(os.path.join(args.out, 'name_todo.tsv'), 'w', encoding='utf-8', newline='\n') as out:
            for name, (count, path, desc) in sorted(names.items(), key=lambda item: item[1][1]):
                out.write(f'{name}\t{count}\t{path}\t{desc}\n')
        with open(os.path.join(args.out, 'traits_todo.tsv'), 'w', encoding='utf-8', newline='\n') as out:
            for name, english, done in traits:
                if not done:
                    out.write(f'{name}\t{english}\n')
        print(f'lists of what is left: {args.out}')


if __name__ == '__main__':
    main()
