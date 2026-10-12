import pathlib
import sys

sys.path.insert(0, '.')

import yaml

from tools.maplint.source import dmm, lint

LIMIT = 40

lints = {}
for lint_file in sorted(pathlib.Path('tools/maplint/lints').glob('*.yml')):
    lints[lint_file.stem] = lint.Lint(yaml.safe_load(lint_file.read_text(encoding='utf-8-sig')))

failed = False
for map_path in sys.argv[1:]:
    try:
        with open(map_path, encoding='utf-8') as handle:
            data = dmm.parse_dmm(handle)
    except Exception as error:
        print(f'{map_path}: cannot parse: {error}')
        failed = True
        continue
    problems = []
    for name, rule in lints.items():
        problems.extend((name, problem) for problem in rule.run(data))
    if not problems:
        continue
    failed = True
    print(f'{map_path}: {len(problems)} problem(s) from {len(lints)} lints')
    for name, problem in problems[:LIMIT]:
        where = f' at {problem.coordinates}' if problem.coordinates else ''
        print(f'  [{name}] line {problem.line_number}{where}: {problem}')
    if len(problems) > LIMIT:
        print(f'  ... {len(problems) - LIMIT} more')

sys.exit(1 if failed else 0)
