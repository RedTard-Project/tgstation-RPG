"""Ratwood's trade data for the economy module (modular_redtard/economy/trade_data.dm).

Reads the Ratwood cache (.cache/ratwood) and writes the trade goods the realm deals in, the economic regions of the
realm, the foreign realms whose ships call at the harbor and the standing order templates the regions post. Only data
moves: names, numbers, item paths (as text, resolved in the game, so goods whose items are not ported are skipped there).
Ratwood's code is not copied; the module's trade code is economy/trade.dm.

Usage: py -3 -I modular_redtard/tools/gen_trade_data.py [ratwood_root]
"""
import glob
import os
import re
import sys

MODULE = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
REPO = os.path.normpath(os.path.join(MODULE, '..'))
OUTPUT = os.path.join(MODULE, 'economy', 'trade_data.dm')

GOODS_DIR = 'code/modules/roguetown/roguestock/trade_goods'
STOCK_GLOB = 'code/modules/roguetown/roguestock/stockpile_*.dm'
REALMS_DIR = 'code/modules/roguetown/roguemachine/merchant/trade/realms'
REGIONS_FILE = 'code/controllers/subsystem/rogue/economy/economic_region.dm'
ORDERS_FILE = 'code/modules/roguetown/roguestock/standing_order.dm'
ECONOMY_FILE = 'code/controllers/subsystem/rogue/economy/economy.dm'
MAP_SWAPS = {'rockhill': '/datum/economic_region/vespermill'}

HEADER = re.compile(r'^(/datum/[\w/]+)\s*$')
ASSIGN = re.compile(r'^\t(?:var/(?:\w+/)*)?(\w+)\s*=\s*(.*)$')
DEFINE = re.compile(r'^\s*#define\s+(\w+)\s+(.+?)\s*$')


def strip_comment(line):
    out, quoted, i = [], False, 0
    while i < len(line):
        ch = line[i]
        if ch == '\\' and quoted:
            out.append(line[i:i + 2])
            i += 2
            continue
        if ch == '"':
            quoted = not quoted
        if not quoted and line.startswith('//', i):
            break
        out.append(ch)
        i += 1
    return ''.join(out).rstrip()


def depth_change(text):
    depth, quoted, i = 0, False, 0
    while i < len(text):
        ch = text[i]
        if ch == '\\' and quoted:
            i += 2
            continue
        if ch == '"':
            quoted = not quoted
        elif not quoted:
            depth += {'(': 1, ')': -1}.get(ch, 0)
        i += 1
    return depth


def read_defines(root):
    defines = {}
    for path in glob.glob(os.path.join(root, 'code', '__DEFINES', '**', '*.dm'), recursive=True):
        for line in open(path, encoding='utf-8', errors='replace'):
            match = DEFINE.match(strip_comment(line))
            if match and '(' not in match.group(1):
                defines.setdefault(match.group(1), match.group(2))
    return defines


class Values:
    def __init__(self, defines):
        self.defines = defines

    def scalar(self, text, depth=0):
        text = text.strip()
        if text.startswith('"') and text.endswith('"'):
            return re.sub(r'\\(["\\])', r'\1', text[1:-1])
        if text.startswith('/'):
            return text.rstrip('/')
        if text in ('TRUE', 'FALSE'):
            return text == 'TRUE'
        if text == 'null':
            return None
        if depth > 20:
            raise ValueError(text)
        expanded = re.sub(r'\b[A-Z_][A-Z0-9_]*\b', lambda m: self.expand(m.group(0), depth), text)
        if expanded.startswith('"'):
            return self.scalar(expanded, depth + 1)
        if not re.fullmatch(r'[\d\s.+\-*/()]+', expanded):
            raise ValueError(text)
        value = eval(expanded, {'__builtins__': {}})
        return int(value) if value == int(value) else round(value, 4)

    def expand(self, name, depth):
        if name not in self.defines:
            raise ValueError(name)
        raw = self.defines[name].strip()
        if raw.startswith('"'):
            return raw
        return '(' + str(self.scalar(raw, depth + 1)) + ')'

    def parse(self, text):
        text = text.strip()
        if text.startswith('list(') and text.endswith(')'):
            items = split_top(text[5:-1])
            keyed = [split_key(item) for item in items if item.strip()]
            if any(key is not None for key, _ in keyed):
                return {self.scalar(key): self.parse(value) for key, value in keyed if key is not None}
            return [self.parse(value) for _, value in keyed]
        return self.scalar(text)


def split_top(text):
    parts, depth, quoted, current, i = [], 0, False, '', 0
    while i < len(text):
        ch = text[i]
        if ch == '\\' and quoted:
            current += text[i:i + 2]
            i += 2
            continue
        if ch == '"':
            quoted = not quoted
        if not quoted:
            depth += {'(': 1, ')': -1}.get(ch, 0)
            if ch == ',' and depth == 0:
                parts.append(current)
                current = ''
                i += 1
                continue
        current += ch
        i += 1
    parts.append(current)
    return parts


def split_key(item):
    depth, quoted, i = 0, False, 0
    while i < len(item):
        ch = item[i]
        if ch == '\\' and quoted:
            i += 2
            continue
        if ch == '"':
            quoted = not quoted
        elif not quoted:
            depth += {'(': 1, ')': -1}.get(ch, 0)
            if ch == '=' and depth == 0 and item[i + 1:i + 2] != '=' and item[i - 1:i] not in ('!', '<', '>', '='):
                return item[:i].strip(), item[i + 1:].strip()
        i += 1
    return None, item.strip()


def read_blocks(paths):
    """Type path -> {var: raw text}; procs are skipped."""
    blocks = {}
    for path in paths:
        current, pending_name, pending = None, None, ''
        for raw in open(path, encoding='utf-8', errors='replace'):
            line = strip_comment(raw.rstrip('\n'))
            if pending_name:
                pending += ' ' + line.strip()
                if depth_change(pending) <= 0:
                    current[pending_name] = pending
                    pending_name = None
                continue
            header = HEADER.match(line)
            if header:
                current = blocks.setdefault(header.group(1), {})
                continue
            if line and not line.startswith('\t'):
                current = None
                continue
            if current is None:
                continue
            match = ASSIGN.match(line)
            if not match:
                continue
            name, value = match.group(1), match.group(2).strip()
            if depth_change(value) > 0:
                pending_name, pending = name, value
            else:
                current[name] = value
    return blocks


def resolved(blocks, path, name):
    while path:
        if name in blocks.get(path, {}):
            return blocks[path][name]
        path = path.rsplit('/', 1)[0] if path.count('/') > 2 else ''
    return None


def dm_string(text):
    return '"' + text.replace('\\', '\\\\').replace('"', '\\"').replace('[', '\\[').replace(']', '\\]') + '"'


def dm_value(value):
    if isinstance(value, bool):
        return 'TRUE' if value else 'FALSE'
    if isinstance(value, (int, float)):
        return str(value)
    if isinstance(value, str):
        return dm_string(value)
    if isinstance(value, dict):
        return 'list(' + ', '.join(f'{dm_value(k)} = {dm_value(v)}' for k, v in value.items()) + ')'
    if isinstance(value, list):
        return 'list(' + ', '.join(dm_value(v) for v in value) + ')'
    raise ValueError(value)


def dm_list_block(name, values, per_line=1):
    if not values:
        return [f'\t{name} = list()']
    lines = [f'\t{name} = list(']
    for i in range(0, len(values), per_line):
        lines.append('\t\t' + ', '.join(dm_value(v) for v in values[i:i + per_line]) + ',')
    lines.append('\t)')
    return lines


def dm_assoc_block(name, entries, per_line=4):
    pairs = list(entries.items())
    if not pairs:
        return [f'\t{name} = list()']
    lines = [f'\t{name} = list(']
    for i in range(0, len(pairs), per_line):
        lines.append('\t\t' + ', '.join(f'{dm_value(k)} = {dm_value(v)}' for k, v in pairs[i:i + per_line]) + ',')
    lines.append('\t)')
    return lines


def main():
    root = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else os.path.join(REPO, '.cache', 'ratwood'))
    values = Values(read_defines(root))

    good_blocks = read_blocks(sorted(glob.glob(os.path.join(root, GOODS_DIR, '*.dm'))))
    goods = {}
    for path in good_blocks:
        raw_id = resolved(good_blocks, path, 'id')
        item = resolved(good_blocks, path, 'item_type')
        if not raw_id or not item or resolved(good_blocks, path, 'reagent_type'):
            continue
        try:
            good_id = values.scalar(raw_id)
            base = values.scalar(resolved(good_blocks, path, 'base_price') or '0')
            mod = values.scalar(resolved(good_blocks, path, 'global_price_mod') or '1')
        except ValueError:
            continue
        if not base:
            continue
        goods[good_id] = {
            'path': path,
            'name': values.scalar(resolved(good_blocks, path, 'name') or '""'),
            'base': base,
            'mod': mod,
            'item': values.scalar(item),
            'subtypes': values.scalar(resolved(good_blocks, path, 'accept_subtypes') or 'FALSE'),
        }

    stock_blocks = read_blocks(sorted(glob.glob(os.path.join(root, STOCK_GLOB))))
    stock_links = {}
    for path, body in stock_blocks.items():
        if 'trade_good_id' in body and path.startswith('/datum/roguestock/stockpile/'):
            try:
                stock_links[path] = values.scalar(body['trade_good_id'])
            except ValueError:
                pass

    used = set(stock_links.values())

    region_blocks = read_blocks([os.path.join(root, REGIONS_FILE)])
    regions = []
    for path, body in region_blocks.items():
        if 'region_id' not in body or 'map_swap_only' in body:
            continue
        region_id = values.scalar(body['region_id'])
        source = MAP_SWAPS.get(region_id, path)
        swapped = region_blocks[source]
        entry = {
            'path': path,
            'id': region_id,
            'name': values.scalar(swapped['name']),
            'subtitle': values.scalar(swapped.get('subtitle', '""')),
            'produces': values.parse(swapped.get('produces', 'list()')) or {},
            'demands': values.parse(swapped.get('demands', 'list()')) or {},
        }
        used |= set(entry['produces']) | set(entry['demands'])
        regions.append(entry)

    realm_blocks = read_blocks(sorted(glob.glob(os.path.join(root, REALMS_DIR, '*.dm'))))
    realms = []
    for path, body in sorted(realm_blocks.items()):
        if 'id' not in body:
            continue
        realm = {'path': path, 'id': values.scalar(body['id']), 'name': values.scalar(body['name'])}
        realm['roll_weight'] = values.scalar(body.get('roll_weight', 'TRADE_REALM_WEIGHT_DEFAULT'))
        realm['single_word_base'] = values.scalar(body.get('single_word_base', 'FALSE'))
        for name in ('ship_name_words', 'captain_first_names', 'captain_last_names', 'city_tags', 'hail_lines'):
            realm[name] = values.parse(body.get(name, 'list()')) or []
        realm['city_tag_chance'] = values.scalar(body.get('city_tag_chance', '0'))
        realm['ship_types'] = values.parse(body.get('ship_types', 'list()')) or []
        realm['name_prefixes'] = [p for p in (values.parse(body.get('name_prefixes', 'list()')) or []) if p.get('text') and not p.get('requires_proper_name')]
        realm['name_suffixes'] = [p for p in (values.parse(body.get('name_suffixes', 'list()')) or []) if p.get('text')]
        for name, key in (('bulk_demand_pool_base', 'demand_pool'), ('bulk_supply_pool_base', 'supply_pool')):
            pool = []
            for entry in values.parse(body.get(name, 'list()')) or []:
                line = {'good': entry['good'], 'qty_min': entry['qty_min'], 'qty_max': entry['qty_max'], 'price_mod': entry.get('price_mod', 1)}
                if entry.get('always'):
                    line['always'] = True
                pool.append(line)
                used.add(entry['good'])
            realm[key] = pool
        realms.append(realm)

    # Standing order templates whose item mix is plain goods: rand() counts, prob() gates and pick() between goods.
    order_text = open(os.path.join(root, ORDERS_FILE), encoding='utf-8', errors='replace').read()
    templates = {}
    for match in re.finditer(r'^/datum/standing_order/(\w+)/generate_item_mix\(\)\n((?:\t.*\n|\n)+)', order_text, re.MULTILINE):
        key, body = match.group(1), match.group(2)
        mix, pick_vars, gate, ok = [], {}, 100, True
        for raw in body.split('\n'):
            line = strip_comment(raw).strip()
            if not line or line in ('var/list/mix = list()', 'return mix'):
                continue
            prob = re.fullmatch(r'if\(prob\((\d+)\)\)', line)
            if prob:
                gate = int(prob.group(1))
                continue
            pick = re.fullmatch(r'var/(\w+) = pick\((TRADE_GOOD_\w+(?:, TRADE_GOOD_\w+)*)\)', line)
            if pick:
                pick_vars[pick.group(1)] = [values.scalar(g.strip()) for g in pick.group(2).split(',')]
                continue
            fill = re.fullmatch(r'mix\[(\w+)\] = rand\((\d+), (\d+)\)', line)
            if fill:
                target = fill.group(1)
                goods_list = pick_vars.get(target) or ([values.scalar(target)] if target.startswith('TRADE_GOOD_') else None)
                if not goods_list:
                    ok = False
                    break
                # Goods priced by Ratwood's pricing engine or held as reagents have no trade price here: an optional
                # line of them is left out, a required one drops the template.
                goods_list = [g for g in goods_list if g in goods]
                if not goods_list:
                    if gate >= 100:
                        ok = False
                        break
                    gate = 100
                    continue
                mix.append({'goods': goods_list, 'min': int(fill.group(2)), 'max': int(fill.group(3)), 'prob': gate})
                gate = 100
                continue
            ok = False
            break
        if not ok or not mix:
            continue
        for entry in mix:
            used |= set(entry['goods'])
        head = re.search(r'^/datum/standing_order/' + key + r'\n((?:\t.*\n)*)', order_text, re.MULTILINE)
        weight = re.search(r'\troll_weight = (\d+)', head.group(1)) if head else None
        title = re.search(r'/datum/standing_order/' + key + r'/generate_name\(.*?\)\n\treturn "\[uppertext\(region\.name\)\] - ([^"]+)"', order_text)
        desc = re.search(r'/datum/standing_order/' + key + r'/generate_description\(.*?\)\n(?:\t.*\n)*?\treturn "([^"]+)"\n', order_text)
        templates[key] = {
            'weight': int(weight.group(1)) if weight else 1,
            'title': title.group(1) if title else 'STANDING ORDER',
            'description': desc.group(1).replace('[region.name]', '%REGION%') if desc else 'A standing order has been posted from %REGION%.',
            'mix': mix,
        }

    economy_text = open(os.path.join(root, ECONOMY_FILE), encoding='utf-8', errors='replace').read()
    region_templates = {}
    for match in re.finditer(r'\t\t(TRADE_REGION_\w+) = list\(\n((?:\t\t\t/datum/standing_order/\w+,\n)+)\t\t\)', economy_text):
        region_templates[values.scalar(match.group(1))] = [t for t in re.findall(r'/datum/standing_order/(\w+)', match.group(2)) if t in templates]

    out = [
        '// Generated by modular_redtard/tools/gen_trade_data.py from Ratwood\'s trade data; do not edit by hand.',
        '// Item paths are text: a good whose item is not ported is skipped in the game (economy/trade.dm).',
        '',
    ]
    for good_id in sorted(g for g in used if g in goods):
        good = goods[good_id]
        out += [
            f'/datum/rogue_trade_good/{good_id.lower()}',
            f'\tid = {dm_string(good_id)}',
            f'\tname = {dm_string(good["name"])}',
            f'\tbase_price = {good["base"]}',
        ]
        if good['mod'] != 1:
            out.append(f'\tglobal_price_mod = {good["mod"]}')
        out.append(f'\titem_path = {dm_string(good["item"])}')
        if good['subtypes']:
            out.append('\taccept_subtypes = TRUE')
        out.append('')

    out.append('/// Ratwood stockpile entry -> its trade good (Ratwood trade_good_id).')
    out.append('GLOBAL_LIST_INIT(rogue_stock_trade_goods, list(')
    for path in sorted(stock_links):
        if stock_links[path] in goods:
            out.append(f'\t{dm_string(path)} = {dm_string(stock_links[path])},')
    out += ['))', '']

    for region in regions:
        name = region['path'].rsplit('/', 1)[1]
        out += [
            f'/datum/rogue_trade_region/{name}',
            f'\tid = {dm_string(region["id"])}',
            f'\tname = {dm_string(region["name"])}',
            f'\tsubtitle = {dm_string(region["subtitle"])}',
        ]
        for var in ('produces', 'demands'):
            out += dm_assoc_block(var, {k: v for k, v in region[var].items() if k in goods})
        out += dm_list_block('order_templates', region_templates.get(region['id'], []), 4)
        out.append('')

    for key, template in sorted(templates.items()):
        out += [
            f'/datum/rogue_order_template/{key}',
            f'\ttitle = {dm_string(template["title"])}',
            f'\tdescription = {dm_string(template["description"])}',
            f'\troll_weight = {template["weight"]}',
        ]
        out += dm_list_block('mix', [{'goods': m['goods'], 'min': m['min'], 'max': m['max'], 'prob': m['prob']} for m in template['mix']])
        out.append('')

    for realm in realms:
        name = realm['path'].rsplit('/', 1)[1]
        out += [
            f'/datum/rogue_foreign_realm/{name}',
            f'\tid = {dm_string(realm["id"])}',
            f'\tname = {dm_string(realm["name"])}',
            f'\troll_weight = {realm["roll_weight"]}',
        ]
        if realm['single_word_base']:
            out.append('\tsingle_word_base = TRUE')
        out += dm_list_block('ship_name_words', realm['ship_name_words'], 6)
        out += dm_list_block('captain_first_names', realm['captain_first_names'], 6)
        out += dm_list_block('captain_last_names', realm['captain_last_names'], 6)
        out += dm_list_block('ship_types', realm['ship_types'])
        if realm['name_prefixes']:
            out += dm_list_block('name_prefixes', [{'text': p['text'], 'chance': p.get('chance', 0)} for p in realm['name_prefixes']])
        if realm['name_suffixes']:
            out += dm_list_block('name_suffixes', [{'text': p['text'], 'chance': p.get('chance', 0)} for p in realm['name_suffixes']])
        out += dm_list_block('city_tags', realm['city_tags'], 6)
        out.append(f'\tcity_tag_chance = {realm["city_tag_chance"]}')
        out += dm_list_block('demand_pool', [l for l in realm['demand_pool'] if l['good'] in goods])
        out += dm_list_block('supply_pool', [l for l in realm['supply_pool'] if l['good'] in goods])
        out += dm_list_block('hail_lines', realm['hail_lines'])
        out.append('')

    open(OUTPUT, 'w', encoding='utf-8', newline='\n').write('\n'.join(out).rstrip('\n') + '\n')
    print(f'{os.path.relpath(OUTPUT, REPO)}: {len([g for g in used if g in goods])} goods, {len(regions)} regions, '
          f'{len(templates)} order templates, {len(realms)} realms, {len(stock_links)} stockpile links')


if __name__ == '__main__':
    main()
