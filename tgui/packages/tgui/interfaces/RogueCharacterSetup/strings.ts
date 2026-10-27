// The character menu in Russian (Vibelin's PreferencesMenu.strings.ts, with the lines this menu has and Vibelin's does
// not, and the names of TG's preferences it shows). The window reads the player's language from its data (lang, the
// rogue_ui_language preference); the catalogs (species, faiths, patrons, cultures, stats, ages) come from the server
// already in that language. A text missing here stays English.
import { useBackend } from 'tgui/backend';

import type { SetupData } from './types';

const RU: Record<string, string> = {
  // The frame: header, round box, sections, looking glass, footer.
  'Character Setup': 'Настройка персонажа',
  'Change Character': 'Сменить персонажа',
  'Empty slot {0}': 'Пустой слот {0}',
  'Slot {0}': 'Слот {0}',
  Unnamed: 'Без имени',
  'Round Start': 'Начало раунда',
  'Starts In': 'Начнётся через',
  'Setting Up': 'Подготовка',
  'Round Started': 'Раунд начался',
  'Round Finished': 'Раунд окончен',
  Delayed: 'Отложено',
  DELAYED: 'ОТЛОЖЕНО',
  Unavailable: 'Недоступно',
  Ready: 'Готов',
  'Cancel Ready': 'Отменить готовность',
  'Join Now': 'Войти сейчас',
  'In the migrant queue': 'В очереди мигрантов',
  Identity: 'Личность',
  Appearance: 'Внешность',
  Gameplay: 'Геймплей',
  'Character Profile': 'Профиль персонажа',
  'Appearance & Profile': 'Внешность и профиль',
  'Hair, underwear and the rest of the look are on the buttons beside the looking glass.':
    'Причёска, бельё и прочий облик — на кнопках справа от зеркала.',
  Settings: 'Настройки',
  'Looking Glass': 'Зеркало',
  Rotate: 'Поворот',
  'Rotate left': 'Повернуть влево',
  'Rotate right': 'Повернуть вправо',
  'Work Clothes Layer': 'Слой рабочей одежды',
  'Randomise Appearance': 'Случайная внешность',
  Randomise: 'Случайно',
  Class: 'Класс',
  Triumphs: 'Триумфы',
  Undo: 'Отменить',
  'Undo the changes since the last save': 'Откатить к сохранению',
  Save: 'Сохранить',
  Done: 'Готово',

  // Identity.
  Name: 'Имя',
  'Random name': 'Случайное имя',
  'Body Type': 'Телосложение',
  Age: 'Возраст',
  '{0} from {1}: {2}': '{0} с {1}: {2}',
  'no stat modifiers': 'без модификаторов',
  Species: 'Раса',
  Faith: 'Вера',
  Ancestry: 'Происхождение',
  Culture: 'Культура',
  Standing: 'Статус',
  'Player Quality': 'Качество игрока',
  'Age: {0}': 'Возраст: {0}',
  'No age modifiers.': 'Возраст не меняет характеристик.',
  'No stat modifiers.': 'Без модификаторов характеристик.',
  'Choose Species': 'Выбор расы',
  'Search species...': 'Поиск расы...',
  All: 'Все',
  Medieval: 'Средневековые',
  Other: 'Прочие',
  "Ratwood's races": 'Расы Ратвуда',
  'No species match.': 'Нет подходящих рас.',
  'No species available.': 'Нет доступных рас.',
  Current: 'Текущая',
  'Current Species': 'Текущая раса',
  'Apply Species': 'Применить расу',
  'No description.': 'Нет описания.',
  'Stat modifiers': 'Модификаторы характеристик',
  Traits: 'Черты',
  Lore: 'Предания',
  'Choose Ancestry': 'Выбор происхождения',
  '{0} has no skin or colour to choose.':
    'У расы «{0}» нет цвета кожи на выбор.',
  'This species': 'Эта раса',
  'Skin tone': 'Цвет кожи',
  'Body colour': 'Цвет тела',
  'Choose Faith': 'Выбор веры',
  'No faiths available.': 'Нет доступных вер.',
  '{0} patrons': 'Покровителей: {0}',
  'Use Faith': 'Принять веру',
  "Choose this faith's godhead": 'Выбрать главное божество этой веры',
  'Current Faith': 'Текущая вера',
  Patrons: 'Покровители',
  Patron: 'Покровитель',
  'Not for this race': 'Недоступно этой расе',
  Domain: 'Домен',
  About: 'Описание',
  Worshippers: 'Последователи',
  Flaws: 'Пороки',
  Boons: 'Дары',
  Sins: 'Грехи',
  'Search cultures...': 'Поиск культуры...',
  'No cultures match.': 'Нет подходящих культур.',
  'Only those of the same culture know where you come from.':
    'Откуда вы родом, знают лишь люди той же культуры.',

  // Appearance.
  Underwear: 'Бельё',
  Details: 'Детали',
  'Search...': 'Поиск...',
  'Nothing to set here.': 'Здесь нечего настраивать.',

  // Gameplay.
  'Class & Roles': 'Класс и роли',
  'Wanted most': 'Желаемая роль',
  None: 'Нет',
  Loadout: 'Лодаут',
  "The loadout (the wardrobe of Vibelin's clothes among it) and quirks are kept in TG's preferences.":
    'Лодаут (в нём и гардероб одежды Вайблина) и черты характера настраиваются в меню настроек ТГ.',
  'Open Loadout & Quirks': 'Открыть лодаут и черты',
  Balance: 'Баланс',
  High: 'Высокий',
  Medium: 'Средний',
  Low: 'Низкий',
  Never: 'Никогда',
  'The roles are not ready yet.': 'Роли ещё не готовы.',
  'Search roles...': 'Поиск роли...',
  'Search Results ({0})': 'Результаты поиска ({0})',
  Role: 'Роль',
  Classes: 'Классы',
  Priority: 'Приоритет',
  'No roles match.': 'Нет подходящих ролей.',
  BANNED: 'ЗАБАНЕН',
  'Any number': 'Без ограничений',
  '{0} slot': '{0} место',
  '{0} slots': 'Мест: {0}',

  // Character profile.
  Flavour: 'Описание',
  OOC: 'OOC',
  '{0} / {1} characters needed to ready up':
    '{0} / {1} символов нужно, чтобы отметиться готовым',
  Declensions: 'Склонения имени',
  'How the chat names your character in each case.':
    'Как чат склоняет имя персонажа по падежам.',
  'This map asks for no character profile.':
    'Эта карта не просит профиль персонажа.',

  // Settings.
  Interface: 'Интерфейс',
  Display: 'Дисплей',
  Audio: 'Звук',
  More: 'Ещё',
  Keybindings: 'Клавиши',
  'All Game Preferences': 'Все настройки игры',

  // TG's preferences the menu shows, by their names in TG's menu.
  Hairstyle: 'Причёска',
  'Hair color': 'Цвет волос',
  'Hair gradient': 'Градиент волос',
  'Hair gradient color': 'Цвет градиента волос',
  'Facial hair': 'Борода и усы',
  'Facial hair color': 'Цвет бороды',
  'Facial hair gradient': 'Градиент бороды',
  'Facial hair gradient color': 'Цвет градиента бороды',
  'Eye color': 'Цвет глаз',
  'Heterochromatic (Right Eye) color': 'Цвет правого глаза (гетерохромия)',
  'Mutant color': 'Цвет тела',
  'Underwear color': 'Цвет белья',
  Undershirt: 'Нательная рубаха',
  Socks: 'Носки',
  Ears: 'Уши',
  Tail: 'Хвост',
  Horns: 'Рога',
  'Body markings': 'Узоры на теле',
  'Body type': 'Тип тела',
  'Character Height': 'Рост',
  'Flavor text': 'Описание',
  'OOC notes': 'OOC-заметки',
  Voice: 'Голос',
  'Classic hotkeys': 'Классические горячие клавиши',
  'Lock action buttons': 'Закрепить кнопки действий',
  'Lock TGUI to main monitor': 'Держать окна TGUI на главном мониторе',
  'Input: Enable TGUI': 'Ввод: окна TGUI',
  'Enable window flashing': 'Мигание окна',
  'Toggle UI scaling': 'Масштабирование интерфейса',
  'Enable ambient occlusion': 'Затенение (AO)',
  'Auto fit viewport': 'Подгонять обзор под окно',
  'Pixel Scaling': 'Масштаб пикселей',
  'Scaling method': 'Метод масштабирования',
  'Lobby music volume': 'Громкость музыки лобби',
  'Admin music volume': 'Громкость админской музыки',
  'Ambience volume': 'Громкость окружения',
  'Instruments volume': 'Громкость инструментов',
};

/** Translates one of the menu's texts; {0}, {1}... take the arguments. */
export type Translate = (text: string, ...args: unknown[]) => string;

export function useTr(): Translate {
  const { data } = useBackend<SetupData>();
  const russian = data.lang !== 'en';
  return (text, ...args) => {
    let result = (russian && RU[text]) || text;
    args.forEach((arg, index) => {
      result = result.replace(`{${index}}`, String(arg));
    });
    return result;
  };
}
