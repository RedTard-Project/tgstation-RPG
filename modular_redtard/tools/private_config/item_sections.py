"""Put the staged table sections of the item generators of block K3 into the private mechanics tables.

tools/port_azure_items.py (K3b), port_twilight_items.py (K3v) and port_vibelin_items.py (K3g) stage their numbers in
.cache/modular_redtard/agents/k3/staged/<key>/<table>.txt, one section "# >>> <generator>" ... "# <<< <generator>"
per file. Each section replaces the one of the same name in config/redtard_private/mechanics/<table> and stands, in the
order Azure, Twilight, Vibelin, right after "# <<< port_rockhill.py" (before the hand overrides and
k2g_vibelin_numbers, which stay later and win); a table without a port_rockhill section (armor.txt) gets them at the
end. Running it again changes nothing; code_numbers.py sync writes the open tables afterwards.

    py -3 -I modular_redtard/tools/private_config/item_sections.py [--check] [--staged <dir>]
"""
import os
import re
import sys

REPO = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..'))
WORK = sys.argv[sys.argv.index('--staged') + 1] if '--staged' in sys.argv else os.path.join(REPO, '.cache', 'modular_redtard', 'agents', 'k3', 'staged')
PRIVATE = os.path.join(REPO, 'config', 'redtard_private', 'mechanics')
ORDER = ['k3b', 'k3v', 'k3g']
TABLES = ['items.txt', 'intents.txt', 'armor.txt']


def section(path):
    lines = open(path, encoding='utf-8').read().split('\n')
    while lines and not lines[-1].strip():
        lines.pop()
    head = re.match(r'^# >>> ([^:\s]+)', lines[0])
    assert head and lines[-1].strip() == f'# <<< {head.group(1)}', path
    return head.group(1), lines


def find(lines, name):
    start = next((i for i, l in enumerate(lines) if re.match(rf'^# >>> {re.escape(name)}(:|\s|$)', l)), None)
    if start is None:
        return None
    end = next(i for i in range(start, len(lines)) if lines[i].strip() == f'# <<< {name}')
    return start, end


def main():
    check = '--check' in sys.argv
    changed = []
    for table in TABLES:
        target = os.path.join(PRIVATE, table)
        lines = open(target, encoding='utf-8').read().split('\n')
        original = list(lines)
        placed = []
        for key in ORDER:
            src = os.path.join(WORK, key, table)
            if not os.path.exists(src):
                continue
            name, body = section(src)
            span = find(lines, name)
            if span:
                # taken out and put back in the K3 order (Azure, Twilight, Vibelin)
                end = span[1] + 1
                while end < len(lines) and not lines[end].strip():
                    end += 1
                del lines[span[0]:end]
            if True:
                anchor = None
                for prev in reversed(['port_rockhill.py'] + placed):
                    s = find(lines, prev)
                    if s:
                        anchor = s[1]
                        break
                if anchor is None:
                    while lines and not lines[-1].strip():
                        lines.pop()
                    lines += [''] + body + ['']
                else:
                    lines[anchor + 1:anchor + 1] = [''] + body
            placed.append(name)
            print(f'{table}: {name} ({sum(1 for l in body if l.startswith("["))} entries)')
        text = '\n'.join(lines)
        if not text.endswith('\n'):
            text += '\n'
        if text != '\n'.join(original) and text != '\n'.join(original) + '\n':
            changed.append(table)
            if not check:
                open(target, 'w', encoding='utf-8', newline='\n').write(text)
    print('changed:', changed or 'nothing')
    sys.exit(1 if check and changed else 0)


main()
