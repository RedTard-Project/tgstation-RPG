import argparse
import os
import shutil
import sys

REPO = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", ".."))
PUBLIC = os.path.join(REPO, "config", "redtard")
README = """# redtard private config

Приватный баланс modular_redtard. Репозиторий сервера подключает его сабмодулем в `config/redtard_private/`:

    git submodule add <адрес этого репозитория> config/redtard_private

## Главное правило механик

Числа механик живут здесь. В открытом репозитории (`config/redtard/mechanics/`) у каждого числа остаются только имя и
описание, а значение там — 10. Без этой папки (CI, открытые клоны) сервер собирается и работает, все числа механик — 10.
Число в коде модуля пишется как `rogue_value("имя")`, а не дефайном и не литералом.

## Что модуль читает отсюда

- `mechanics/values/*.txt` — файлы чисел, по одному на блок (`combat.txt`, `crafting.txt`, `treasury.txt` и так далее):
  строки `#` с описанием, под ними `имя = число`, пустая строка между записями; время — в децисекундах. Файл здесь
  заменяет открытый файл того же имени целиком; имя, которого здесь нет, берёт открытое значение (10).
- `mechanics/armor.txt`, `intents.txt`, `items.txt`, `formulas.txt` — таблицы и формулы, по тому же правилу.
- `config.txt` — читается после `config/redtard/config.txt` и меняет только записанные в нём ключи.

Панель Rogue Mechanics сохраняет формулы и числа сюда, когда эта папка есть.

## Инструменты (`modular_redtard/tools/private_config/`)

- `code_numbers.py find` — опись чисел кода модуля; `apply <список>` — замена их на `rogue_value()`;
  `merge` — перенос новых записей сюда; `sync` — открытые файлы по этим: те же имена и описания, число 10;
  `sync --check` — проверка без записи; `sync --verify <ревизия>` — числа здесь равны открытым числам той ревизии.
- `init_private_config.py <папка>` — заготовка такого репозитория по открытым файлам (их числа — 10, настоящие
  вписываются сюда).

Новое число: запись в нужный файл здесь, затем `code_numbers.py sync`. Новый файл чисел — ещё и строка в
`rogue_value_files()` (`modular_redtard/mechanics/registry.dm`).
"""


def main():
    parser = argparse.ArgumentParser(description="Lay out a private balance repository from the current public configs.")
    parser.add_argument("target", help="an empty folder that becomes the private repository")
    parser.add_argument("--with-config", action="store_true", help="also copy config/redtard/config.txt")
    args = parser.parse_args()
    target = os.path.abspath(args.target)
    if os.path.exists(target) and os.listdir(target):
        sys.exit(f"{target} is not empty")
    copied = []
    for folder in ("mechanics", "mechanics/values"):
        os.makedirs(os.path.join(target, folder), exist_ok=True)
        for name in sorted(os.listdir(os.path.join(PUBLIC, folder))):
            if name.endswith(".txt"):
                shutil.copyfile(os.path.join(PUBLIC, folder, name), os.path.join(target, folder, name))
                copied.append(f"{folder}/{name}")
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
