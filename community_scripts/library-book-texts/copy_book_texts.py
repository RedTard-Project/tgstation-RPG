"""Copy the texts of Ratwood's premade books and the printing press sound into modular_redtard/library.

Ratwood reads a premade book's text from strings/books/<bookfile> (a JSON object {"Contents": [page, ...]}). The Ratwood
cache of this repository holds no strings/books, so the texts are taken from an Azure Peak checkout, which has the same
files. Those files carry raw line breaks and other control characters inside JSON strings: BYOND's json_decode() takes
them, a strict parser does not. Every copy is therefore parsed leniently and written back as strict JSON, so any parser
reads it. The press sound comes from the Ratwood checkout.

Usage (Python 3.9+, standard library only):
    python -I copy_book_texts.py --azure <Azure Peak root> --ratwood <Ratwood root> --repo <this repository's root>
    python -I copy_book_texts.py --azure ... --ratwood ... --out <some empty folder>   (a dry run outside the repository)

Writes <out>/books/<file>.json and <out>/sound/ppress.ogg; <out> defaults to <repo>/modular_redtard/library.
"""
import argparse
import json
import os
import shutil
import sys

# The files named by the ported Ratwood books and by the books the library module adds (modular_redtard/library/books.dm).
DEFAULT_BOOKS = [
	'law_2.json', 'cooking.json', 'knowledge.json', 'xylix.json', 'holyguide.json', 'Neu_cooking.json',
	'tales1.json', 'tales2.json', 'tales3.json', 'tales4.json', 'tales5.json', 'tales6.json', 'tales7.json',
	'tales8.json', 'tales9.json', 'tales10.json', 'tales11.json', 'tales12.json', 'tales13.json', 'tales14.json',
	'naledi1.json', 'naledi2.json', 'naledi3.json', 'naledi4.json',
]
PRESS_SOUND = os.path.join('sound', 'misc', 'ppress.ogg')


def read_text(path):
	raw = open(path, 'rb').read()
	try:
		return raw.decode('utf-8'), 'utf-8'
	except UnicodeDecodeError:
		return raw.decode('cp1252'), 'cp1252'


def load_book(path):
	"""Returns (pages, how it parsed) or raises ValueError."""
	text, encoding = read_text(path)
	try:
		data = json.loads(text)
		how = 'strict JSON'
	except json.JSONDecodeError:
		data = json.loads(text, strict=False)
		how = 'lenient JSON (control characters inside strings)'
	pages = data.get('Contents') if isinstance(data, dict) else None
	if not isinstance(pages, list) or not all(isinstance(page, str) for page in pages):
		raise ValueError('no list of text pages under "Contents"')
	if encoding != 'utf-8':
		how += f', read as {encoding}'
	return pages, how


def main():
	parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
	parser.add_argument('--azure', required=True, help='Azure Peak checkout (reads strings/books)')
	parser.add_argument('--ratwood', required=True, help='Ratwood checkout or cache (reads sound/misc/ppress.ogg)')
	parser.add_argument('--repo', help='root of this repository; output goes to modular_redtard/library')
	parser.add_argument('--out', help='output folder instead of <repo>/modular_redtard/library')
	parser.add_argument('--books', nargs='*', default=DEFAULT_BOOKS, help='book files to copy (default: the module\'s list)')
	args = parser.parse_args()
	if not args.out and not args.repo:
		parser.error('give --repo or --out')
	out = args.out or os.path.join(args.repo, 'modular_redtard', 'library')
	books_in = os.path.join(args.azure, 'strings', 'books')
	books_out = os.path.join(out, 'books')
	sound_out = os.path.join(out, 'sound')
	os.makedirs(books_out, exist_ok=True)
	os.makedirs(sound_out, exist_ok=True)
	failed = 0
	for name in args.books:
		source = os.path.join(books_in, name)
		if not os.path.exists(source):
			print(f'MISSING {name}: not in {books_in}')
			failed += 1
			continue
		try:
			pages, how = load_book(source)
		except ValueError as error:
			print(f'BROKEN {name}: {error}')
			failed += 1
			continue
		target = os.path.join(books_out, name)
		with open(target, 'w', encoding='utf-8', newline='\n') as handle:
			handle.write(json.dumps({'Contents': pages}, ensure_ascii=False))
			handle.write('\n')
		# The copy must read back strictly and hold the same pages.
		with open(target, encoding='utf-8') as handle:
			if json.load(handle)['Contents'] != pages:
				print(f'MISMATCH {name}: the copy does not read back the same')
				failed += 1
				continue
		print(f'{name}: {len(pages)} page(s), {sum(len(page) for page in pages)} chars, source {how}')
	sound_source = os.path.join(args.ratwood, PRESS_SOUND)
	if os.path.exists(sound_source):
		shutil.copyfile(sound_source, os.path.join(sound_out, 'ppress.ogg'))
		print('ppress.ogg copied')
	else:
		print(f'MISSING {sound_source}')
		failed += 1
	if failed:
		print(f'{failed} problem(s)')
		sys.exit(1)


if __name__ == '__main__':
	main()
