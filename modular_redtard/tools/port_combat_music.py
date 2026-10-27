"""Ratwood's combat music (cmode_music) for this build's roles: combat/ported_music.dm and the tracks it names.

Ratwood gives every mob a combat track (mob_helpers.dm: /mob/var/cmode_music, towner by default); a job's or a
subclass's cmode_music, or an unconditional H.cmode_music in its outfit's pre_equip(), replaces it, the subclass's
last. This reads that for the jobs and subclasses the porter brought over (rockhill/ported/jobs.dm, advclasses.dm; a
job without a choice of subclasses takes its one subclass's track, since the build never applies that subclass as
such), and Ratwood's list of selectable tracks (code/datums/combat_music.dm, /datum/combat_music). Most of the music
is not in the Ratwood cache (its checkout leaves sound/music/cmode out), so each file is taken from the cache if it is
there, else from Azure Peak at the same path, and copied to modular_redtard/combat/sound/music/ under its path below
sound/music/. A track found in neither is left out and listed. The DM names the tracks by text path, so the server
loads one only when somebody hears it (as the area music does) instead of packing them all into the resource file
every client downloads. The tracks are kept in git, as on Ratwood; re-run this tool when the list of tracks changes.

Selectable tracks are kept only when all their files are copied; by default only the role tracks are copied, and
--all-tracks copies the rest of the selectable ones too. Patron-dependent music (a cleric's pre_equip switch) is not
read. The porter's DM reader (port_rockhill.py) is reused as it is; nothing here runs git.

Run:  python -I modular_redtard/tools/port_combat_music.py [--azure ../Azure-Peak-Fork] [--all-tracks]
"""

import argparse
import os
import re
import shutil
import sys

TOOLS = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.normpath(os.path.join(TOOLS, '..', '..'))
sys.path.insert(0, TOOLS)
import port_rockhill as porter  # noqa: E402  (the porter's DM reader)

OUT_DM = 'modular_redtard/combat/ported_music.dm'
SOUND_DIR = 'modular_redtard/combat/sound/music'
SOURCE_MUSIC = 'sound/music/'
JOBS = 'modular_redtard/rockhill/ported/jobs.dm'
CLASSES = 'modular_redtard/rockhill/ported/advclasses.dm'
JOB_ROOT = '/datum/job/roguetown/'
CLASS_ROOT = '/datum/rockhill_advclass/'
SOURCE_CLASS_ROOT = '/datum/advclass/'
TRACK_ROOT = '/datum/combat_music/'
TRACK_TARGET = '/datum/rogue_combat_music/'
OGG = re.compile(r"'([^']+\.ogg)'")
OUTFIT_MUSIC = re.compile(r'^\t(?:H|human|user)\.cmode_music\s*=\s*(.+)$')
TYPE_LINE = re.compile(r'^(/[A-Za-z0-9_/]+)$', re.M)
SINGLE_CLASS = re.compile(r'^\trockhill_advclass = "(/datum/advclass/[A-Za-z0-9_/]+)"$', re.M)
CLASS_CHOICE = re.compile(r'^\t\t/datum/rockhill_advclass/[A-Za-z0-9_/]+,$', re.M)


def job_blocks(text):
    """(path, body) of every ported job: the indented lines under its type line."""
    blocks = []
    current = None
    body = []
    for line in text.split('\n'):
        if line.startswith('/'):
            if current:
                blocks.append((current, '\n'.join(body)))
            current = line.strip() if TYPE_LINE.match(line.strip()) and line.startswith(JOB_ROOT) else None
            body = []
        elif current:
            body.append(line)
    if current:
        blocks.append((current, '\n'.join(body)))
    return blocks


def files_of(raw):
    return OGG.findall(raw or '')


def outfit_music(rw, outfit):
    """The track an outfit's pre_equip() sets unconditionally (at the first indent), from the outfit or its parents."""
    seen = set()
    path = outfit
    while path and path not in seen and path.startswith('/datum/outfit'):
        seen.add(path)
        for line in porter.PRE_EQUIP.get(path) or []:
            found = OUTFIT_MUSIC.match(line)
            if found:
                return files_of(found.group(1))
        path = rw.parent(path)
    return []


def role_music(rw, source_path):
    music = files_of(rw.resolve(source_path, 'cmode_music'))
    if music:
        return music
    return outfit_music(rw, (rw.resolve(source_path, 'outfit') or '').strip())


def find_source(rel, roots):
    """The file at rel in the first root that has it, matched without regard to case; its real path below the root."""
    for root in roots:
        folder = os.path.join(root, os.path.dirname(rel))
        if not os.path.isdir(folder):
            continue
        wanted = os.path.basename(rel).lower()
        for name in os.listdir(folder):
            if name.lower() == wanted:
                return os.path.join(folder, name), os.path.dirname(rel) + '/' + name
    return None, None


def dm_text(rw, path, var):
    raw = rw.resolve(path, var)
    if raw is None:
        return None
    value = raw.strip()
    return value if porter.STRING_LITERAL.match(value) and value != '""' else None


def main():
    parser = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    parser.add_argument('--azure', default=os.path.join(REPO, '..', 'Azure-Peak-Fork'), help='Azure Peak checkout to take the music from')
    parser.add_argument('--all-tracks', action='store_true', help='also copy the selectable tracks no role uses')
    args = parser.parse_args()
    os.chdir(REPO)
    roots = [porter.CHECKOUT, os.path.abspath(args.azure)]
    types, _ = porter.parse_codebase(porter.CHECKOUT)
    rw = porter.Codebase(types)

    roles = {}
    for path, block in job_blocks(open(JOBS, encoding='utf-8').read()):
        # A job without a choice of subclasses never applies its one subclass, which in Ratwood sets the track after the job.
        single = SINGLE_CLASS.search(block)
        choices = CLASS_CHOICE.findall(block)
        music = role_music(rw, single.group(1)) if single and len(choices) <= 1 else []
        roles[path] = music or role_music(rw, path)
    for path in TYPE_LINE.findall(open(CLASSES, encoding='utf-8').read()):
        if path.startswith(CLASS_ROOT):
            source = SOURCE_CLASS_ROOT + path[len(CLASS_ROOT):]
            if source in types:
                roles[path] = role_music(rw, source)
    default = files_of(rw.resolve('/mob', 'cmode_music'))

    tracks = {}
    for path in sorted(p for p in types if p.startswith(TRACK_ROOT)):
        music = files_of(rw.resolve(path, 'musicpath'))
        name = dm_text(rw, path, 'name')
        if music and name:
            tracks[path] = (name, dm_text(rw, path, 'desc'), dm_text(rw, path, 'credits'), music)

    wanted = set(default)
    for music in roles.values():
        wanted.update(music)
    if args.all_tracks:
        for track in tracks.values():
            wanted.update(track[3])

    os.makedirs(SOUND_DIR, exist_ok=True)
    ignore = os.path.join(SOUND_DIR, '.gitignore')
    if not os.path.exists(ignore):
        open(ignore, 'w', encoding='utf-8', newline='\n').write('*\n!.gitignore\n')
    copied = {}
    missing = []
    size = 0
    for rel in sorted(wanted):
        source, real = find_source(rel, roots)
        if not source or not real.startswith(SOURCE_MUSIC):
            missing.append(rel)
            continue
        target = os.path.join(SOUND_DIR, real[len(SOURCE_MUSIC):])
        os.makedirs(os.path.dirname(target), exist_ok=True)
        if not os.path.exists(target) or os.path.getsize(target) != os.path.getsize(source):
            shutil.copyfile(source, target)
        copied[rel] = target.replace(os.sep, '/')
        size += os.path.getsize(target)

    def dm_list(music):
        kept = [copied[rel] for rel in music if rel in copied]
        return 'list(' + ', '.join(f'"{target}"' for target in kept) + ')' if kept else None

    lines = [
        '// Generated by modular_redtard/tools/port_combat_music.py from Ratwood; do not edit by hand.',
        '',
        '/// Combat track of anyone without a role track (Ratwood: /mob/var/cmode_music).',
        f'GLOBAL_LIST_INIT(rogue_cmode_music_default, {dm_list(default) or "list()"})',
        '',
        '/// Combat tracks of the ported jobs and subclasses, by the text of their type path (Ratwood cmode_music).',
        'GLOBAL_LIST_INIT(rogue_cmode_music_roles, list(',
    ]
    kept_roles = 0
    for path in sorted(roles):
        music = dm_list(roles[path])
        if music:
            lines.append(f'\t"{path}" = {music},')
            kept_roles += 1
    lines += ['))', '']
    kept_tracks = 0
    for path, (name, desc, credits, music) in tracks.items():
        if any(rel not in copied for rel in music):
            continue
        lines.append(TRACK_TARGET + path[len(TRACK_ROOT):])
        lines.append(f'\tname = {name}')
        if desc:
            lines.append(f'\tdesc = {desc}')
        if credits:
            lines.append(f'\tcredits = {credits}')
        lines.append(f'\tmusicpath = {dm_list(music)}')
        lines.append('')
        kept_tracks += 1
    open(OUT_DM, 'w', encoding='utf-8', newline='\n').write('\n'.join(lines).rstrip('\n') + '\n')
    print(f'{OUT_DM}: {kept_roles} of {len(roles)} roles with a track of their own, {kept_tracks} of {len(tracks)} selectable tracks')
    print(f'{SOUND_DIR}: {len(copied)} files, {size / 1e6:.1f} MB')
    if missing:
        print(f'not found in {", ".join(roots)}: {len(missing)}')
        for rel in missing:
            print('  ' + rel)


if __name__ == '__main__':
    main()
