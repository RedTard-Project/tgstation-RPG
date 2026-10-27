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
  More: 'Ещё',
  Keybindings: 'Клавиши',

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

  // The settings page: TG's categories of game preferences, the names and descriptions of the preferences.
  Sound: 'Звук',
  Chat: 'Чат',
  Runechat: 'Реплики над головой',
  Tooltips: 'Подсказки',
  Accessibility: 'Доступность',
  Ghost: 'Призрак',
  Admin: 'Админ',
  'Enable darkened flashes': 'Тёмная вспышка',
  'When toggled, being flashed will show a dark screen rather than a bright one.':
    'Ослепление вспышкой затемняет экран, а не засвечивает его.',
  'Darken screen shake': 'Затемнять тряску экрана',
  'When toggled, experiencing screen shake will darken your screen.':
    'Тряска экрана затемняет его.',
  'Remove double click': 'Без двойного щелчка',
  'When toggled, actions that require a double click will instead offer alternatives, good if you have a not-so-functional mouse.':
    'Действия, которым нужен двойной щелчок, предложат другой способ — полезно, если мышь подводит.',
  'Cosmetic Recoil Strength': 'Сила косметической отдачи',
  "Modifies the strength of cosmetic recoil's effect on your camera. 0 will disable cosmetic recoil entirely, though mechanical recoil will be unaffected.":
    'Насколько отдача трясёт камеру. 0 убирает косметическую отдачу совсем; механическая отдача не меняется.',
  'Enable stair indicator': 'Указатель на лестницах',
  'When toggled, staircases will have a visual indicator showing which direction to walk to transition floors.':
    'На лестницах видно, в какую сторону идти, чтобы сменить этаж.',
  'Twelve-Hour Clock': '12-часовой формат времени',
  'When toggled, will replace many instances of real-world time with AM/PM instead.':
    'Реальное время во многих местах показывается в формате AM/PM.',
  'Admin chat color': 'Цвет админского чата',
  'The color of your messages in Adminsay.': 'Цвет ваших сообщений в Adminsay.',
  'Brief outfit': 'Снаряжение брифинга',
  'The outfit to gain when spawning as the briefing officer.':
    'Снаряжение при появлении офицером брифинга.',
  'Bypass deadmin options when in CentCom': 'Не деадминиться на ЦентКоме',
  'Whether or not to always remain an admin when spawned in CentCom.':
    'Оставаться админом при появлении на ЦентКоме.',
  'Enable fast MC stat panel refreshes': 'Быстрое обновление вкладки MC',
  'Whether or not the MC tab of the Stat Panel refreshes fast. This is expensive so make sure you need it.':
    'Вкладка MC в статпанели обновляется быстро. Это дорого — включайте, только если нужно.',
  'Get ghost roles while adminned': 'Роли призрака под админкой',
  'If you de-select this, you will not get any ghost role pop-ups while adminned! Every single pop-up WILL never show up for you in an adminned state. However, this does not suppress notifications when you are a regular player (deadminned).':
    'Если выключить, под админкой не будет ни одного предложения роли призрака. Когда вы деадминены, предложения приходят как обычно.',
  'Enable comms console sound': 'Звук консоли связи',
  'Auto deadmin - Ready or Latejoin':
    'Автодеадмин — готовность или поздний вход',
  'When enabled, you will automatically deadmin when you click to ready up or latejoin a round.':
    'Вы автоматически деадминитесь, когда отмечаетесь готовым или входите в раунд позже.',
  'Enable ambient occlusion, light shadows around characters.':
    'Мягкие тени вокруг персонажей и предметов.',
  'Broadcast login/logout': 'Сообщать о входе и выходе',
  'When enabled, disconnecting and reconnecting will announce to deadchat.':
    'Ваши отключения и переподключения объявляются в чате мёртвых.',
  'When enabled, action buttons will be locked in place.':
    'Кнопки действий нельзя сдвинуть.',
  'Emissive Bloom Strength': 'Сила свечения',
  'How strong the bloom on emissive objects, such as computer screens, is. This has negligible performance impact.':
    'Насколько сильно светятся светящиеся предметы. На производительность почти не влияет.',
  FPS: 'Кадров в секунду (FPS)',
  'Ghost accessories': 'Вид призрака',
  'Determines what adjustments your ghost will have.':
    'Какие особенности будут у вашего призрака.',
  'Ghosts form': 'Облик призрака',
  'The appearance of your ghost. Requires BYOND membership.':
    'Внешний вид вашего призрака. Нужен BYOND Membership.',
  'Ghost HUD': 'HUD призрака',
  'Enable HUD buttons for ghosts.': 'Кнопки HUD у призрака.',
  'Ghost orbit': 'Орбита призрака',
  'The shape in which your ghost will orbit. Requires BYOND membership.':
    'По какой фигуре ваш призрак кружит вокруг цели. Нужен BYOND Membership.',
  'Ghosts of others': 'Чужие призраки',
  'Do you want the ghosts of others to show up as their own setting, as their default sprites, or always as the default white ghost?':
    'Как показывать чужих призраков: как их настроили, обычными спрайтами или всегда белым призраком.',
  'Ghost inquisitiveness': 'Любопытный призрак',
  'Clicking on something as a ghost will examine it.':
    'Щелчок призраком по чему-то осматривает это.',
  'Get ghost roles': 'Предлагать роли призрака',
  'If you de-select this, you will not get any ghost role pop-ups what-so-ever! Every single type of these pop-ups WILL be muted for you when you are ghosted. Very useful for those who find ghost roles or the pop-ups annoying, use at your own peril.':
    'Если выключить, призраком вы не получите ни одного предложения роли. Удобно, если они мешают.',
  'Ghost Lighting': 'Освещение призрака',
  'Effects the brightness of lights for ghosts':
    'Насколько ярко призрак видит свет.',
  'When enabled, will revert to the legacy hotkeys, using the input bar rather than popups.':
    'Старые горячие клавиши: ввод в строке, а не во всплывающих окнах.',
  'Item outlines': 'Обводка предметов',
  'When enabled, hovering over items will outline them.':
    'Предмет под курсором обводится.',
  'Enable income updates': 'Уведомления о доходах',
  'Receive notifications for your bank account.':
    'Уведомления о вашем банковском счёте.',
  'Enable deadchat': 'Чат мёртвых',
  'Hear all messages': 'Слышать всю речь',
  'When enabled, you will be able to hear all speech as a ghost. When disabled, you will only be able to hear nearby speech.':
    'Призраком слышна вся речь; если выключить — только рядом.',
  'Enable law change updates': 'Смена законов ИИ',
  'When enabled, be notified of any new law changes as a ghost.':
    'Призраком получать уведомления о смене законов.',
  'Enable PDA notifications': 'Сообщения КПК',
  'When enabled, be notified of any PDA messages as a ghost.':
    'Призраком видеть все сообщения КПК.',
  'Enable radio': 'Радио',
  'When enabled, be notified of any radio messages as a ghost.':
    'Призраком слышать все радиосообщения.',
  'See all emotes': 'Видеть все эмоции',
  'When enabled, see all emotes as a ghost.': 'Призраком видеть все эмоции.',
  'See all whispers': 'Слышать весь шёпот',
  'When enabled, you will be able to hear all whispers as a ghost. When disabled, you will only be able to hear nearby whispers.':
    'Призраком слышен весь шёпот; если выключить — только рядом.',
  'See login/logout messages': 'Входы и выходы игроков',
  'When enabled, be notified when a player logs in or out.':
    'Уведомлять, когда игрок входит или выходит.',
  'Enable OOC': 'OOC-чат',
  'Listen to prayers': 'Слышать молитвы',
  'Enable pull request notifications': 'Уведомления о пулл-реквестах',
  'Be notified when a pull request is made, closed, or merged.':
    'Уведомлять, когда пулл-реквест открыт, закрыт или влит.',
  'Prevent being summoned as a cult ghost': 'Не призываться духом культа',
  'When enabled and observing, prevents Spirit Realm from forcing you into a cult ghost.':
    'Пока вы наблюдаете, Spirit Realm не превратит вас в духа культа.',
  'Announce login': 'Сообщать о входе',
  'Admins will be notified when you login.':
    'Админы получат уведомление о вашем входе.',
  'Enable fullbright Combo HUD': 'Полное освещение в Combo HUD',
  'Auto deadmin - Always': 'Автодеадмин — всегда',
  'When enabled, you will automatically deadmin.':
    'Вы всегда автоматически деадминитесь.',
  'Auto deadmin - Antagonist': 'Автодеадмин — антагонист',
  'When enabled, you will automatically deadmin as an antagonist.':
    'Вы автоматически деадминитесь, став антагонистом.',
  'Auto deadmin - Head of Staff': 'Автодеадмин — глава отдела',
  'When enabled, you will automatically deadmin as a head of staff.':
    'Вы автоматически деадминитесь на должности главы.',
  'Auto deadmin - Security': 'Автодеадмин — охрана',
  'When enabled, you will automatically deadmin as a member of security.':
    'Вы автоматически деадминитесь в охране.',
  'Auto deadmin - Silicon': 'Автодеадмин — синтетик',
  'When enabled, you will automatically deadmin as a silicon.':
    'Вы автоматически деадминитесь, став синтетиком.',
  'Notify for new arrivals': 'Сообщать о прибывших',
  'When enabled, you will be notified as a ghost for new crew.':
    'Призраком получать уведомления о новых прибывших.',
  'Notify for deaths': 'Сообщать о смертях',
  'When enabled, you will be notified as a ghost whenever someone dies.':
    'Призраком получать уведомление о каждой смерти.',
  'Publicize BYOND membership': 'Показывать BYOND Membership',
  'When enabled, a BYOND logo will be shown next to your name in OOC.':
    'Рядом с вашим именем в OOC виден значок BYOND.',
  'Enable adminhelp sounds': 'Звук адмихелпа',
  'Enable prayer sound': 'Звук молитв',
  'Split admin tabs': 'Разделить вкладки админа',
  "When enabled, will split the 'Admin' panel into several tabs.":
    'Панель «Admin» делится на несколько вкладок.',
  'Disable Lobby-menu Transparency': 'Без прозрачности меню лобби',
  'Prevent admins from making the lobby screen transparent.':
    'Админы не смогут сделать экран лобби прозрачным.',
  'MOD active module key': 'Клавиша активного модуля MOD',
  'The key you need to use an active MODsuit module.':
    'Клавиша, которой используется активный модуль MODsuit.',
  'Enable multi-z parallax': 'Параллакс уровней',
  'Enable multi-z parallax, for a 3D effect.':
    'Нижние уровни слегка смещаются — эффект объёма.',
  'Multi-Z Depth': 'Глубина уровней',
  'How many Multi-Z levels are rendered before they start getting culled. Decrease this to improve performance in case of lag on multi-z maps.':
    'Сколько уровней по высоте рисуется, прежде чем нижние отсекаются. Уменьшите, если на многоуровневых картах лагает.',
  'OOC color': 'Цвет OOC',
  'The color of your OOC messages.': 'Цвет ваших сообщений в OOC.',
  'Parallax (fancy space)': 'Параллакс (красивый космос)',
  'Enable fancy (particle) weather (AMD GPU incompatible)':
    'Погода из частиц (не для видеокарт AMD)',
  'Enable fancy particle weather. Incompatible with AMD GPUs and will cause heavy lag on them due to a BYOND bug.':
    'Красивая погода из частиц. Из-за ошибки BYOND на видеокартах AMD сильно лагает.',
  'Preferred map': 'Любимая карта',
  'During map rotation, prefer this map be chosen. This does not affect the map vote, only random rotation when a vote is not held.':
    'При смене карты без голосования предпочитать эту. На голосование не влияет.',
  'Russian translates the chat and the game texts the server sends in English; English shows them as they are.':
    'Русский переводит чат и игровые тексты, которые сервер присылает по-английски; English показывает их как есть.',
  'Enable Runechat': 'Реплики над головой',
  'Chat messages will show above heads.': 'Сообщения чата видны над головами.',
  'Enable Runechat on objects': 'Реплики над предметами',
  'Chat messages will show above objects when they speak.':
    'Над говорящими предметами видны их сообщения.',
  'Enable Runechat on ghosts': 'Реплики над призраками',
  'Chat messages will show above ghosts when they speak.':
    'Над говорящими призраками видны их сообщения.',
  'Enable Runechat emotes': 'Эмоции над головой',
  'Emotes will show above heads.': 'Эмоции видны над головами.',
  'Max chat length': 'Длина реплики',
  'The maximum length a Runechat message will show as.':
    'Сколько символов реплики видно над головой.',
  'Enable widescreen': 'Широкий экран',
  'Toggle Fullscreen': 'Полный экран',
  'Toggles Fullscreen for the game, can also be toggled with F11.':
    'Игра на весь экран; переключается и клавишей F11.',
  'Screentips: Screentips color': 'Подсказки на экране: цвет',
  'The color of screen tips, the text you see when hovering over something.':
    'Цвет подсказок — текста, который виден при наведении курсора.',
  'Screentips: Allow images': 'Подсказки на экране: картинки',
  'When enabled, screentip hints use images for the mouse button rather than LMB/RMB.':
    'Кнопки мыши в подсказках показываются картинками, а не ЛКМ/ПКМ.',
  'Screentips: Enable screentips': 'Подсказки на экране',
  'Enables screen tips, the text you see when hovering over something. When set to "Only with tips", will only show when there is more information than just the name, such as what right-clicking it does.':
    'Текст при наведении курсора. «Only with tips» — только если там есть что-то кроме имени, например что делает ПКМ.',
  'Ambience refers to the more noticeable ambient sounds that play on occasion.':
    'Фоновые звуки зон: петли и редкие одиночные звуки.',
  'Enable breathing sounds': 'Звук дыхания',
  'When enabled, hear breathing sounds when using internals.':
    'Слышать дыхание через баллон.',
  'Enable announcement sounds': 'Звук объявлений',
  'When enabled, hear sounds for command reports, notices, etc.':
    'Слышать звук объявлений и сообщений командования.',
  'Ghost poll prompt': 'Звук предложения роли',
  'Choose which sound prompt to play on getting ghost polls.':
    'Какой звук играет, когда призраку предлагают роль.',
  'Ghost poll prompt volume': 'Громкость предложения роли',
  'The volume that ghost poll prompts will play at.':
    'Громкость звука предложения роли.',
  'Enable combat mode sound': 'Звук боевого режима',
  'When enabled, hear sounds when toggling combat mode.':
    'Звук при включении и выключении боевого режима.',
  'Volume of instruments.': 'Громкость музыкальных инструментов.',
  'Jukebox volume': 'Громкость музыкального автомата',
  'Volume of jukebox tracks.': 'Громкость треков музыкального автомата.',
  'Enable TTS': 'Озвучка речи (TTS)',
  'When enabled, be able to hear text-to-speech sounds in game. When set to "Blips", text to speech will be replaced with blip sounds based on the voice.':
    'Слышать озвучку речи. «Blips» — вместо озвучки короткие звуки по голосу.',
  'Enable TTS Over Radio': 'Озвучка по радио',
  'When enabled, be able to hear text-to-speech sounds in game over radio channels. When set to "Departmental Radio Only", text to speech over the radio will only play for departmental radio channels. Anything that isn\'t Common. When disabled, text to speech will not play over radio sources.':
    'Слышать озвучку речи по радио. «Departmental Radio Only» — только в каналах отделов, не в общем. Если выключить, по радио озвучки нет.',
  'Enable TTS Hear Self Over Radio': 'Слышать свою озвучку по радио',
  'When enabled, hear yourself over the radio when Text to Speech and TTS Over Radio is enabled.':
    'Слышать себя по радио, когда включены озвучка и озвучка по радио.',
  'TTS Volume': 'Громкость озвучки',
  'The volume that the text-to-speech sounds will play at.':
    'Громкость озвучки речи.',
  'TTS Radio Volume': 'Громкость озвучки по радио',
  'The volume that radio text-to-speech sounds will play at. This is independent of regular TTS volume.':
    'Громкость озвучки по радио, отдельно от обычной.',
  'Volume of admin musics.': 'Громкость музыки, которую включают админы.',
  'Ship ambience volume': 'Громкость музыки зон',
  'Ship ambience refers to the low ambient buzz that plays on loop.':
    'Музыка зон и боевая музыка.',
  'Achievement unlock sound': 'Звук достижения',
  "The sound that's played when unlocking an achievement. If disabled, no sound will be played.":
    'Звук при получении достижения; если выключить, звука нет.',
  'Radio sound volume': 'Громкость звуков радио',
  'Volume of the bloops that play when a radio message is said or received.':
    'Громкость сигналов при отправке и получении радиосообщения.',
  'AI VOX announcements volume': 'Громкость голоса ИИ (VOX)',
  'Volume of vocal AI announcements (also known as "VOX").':
    'Громкость голосовых объявлений ИИ (VOX).',
  'Enable status bar': 'Строка состояния',
  'When toggled, a bar at the bottom left of the screen will display the name of what your mouse cursor is hovering over.':
    'Внизу слева экрана видно имя того, что под курсором.',
  'Renders input boxes in TGUI.': 'Окна ввода рисуются в TGUI.',
  'Input: Larger buttons': 'Ввод: крупные кнопки',
  'Makes TGUI buttons less traditional, more functional.':
    'Кнопки окон ввода TGUI — менее привычные, но удобнее.',
  'Input: Swap Submit/Cancel buttons':
    'Ввод: поменять местами «Отправить» и «Отмена»',
  'Locks TGUI windows to your main monitor.':
    'Окна TGUI не уходят с главного монитора.',
  'Uncap TGUI window limit': 'Без ограничения окон TGUI',
  'Disables the window limit for TGUI windows. Having more than 5 windows open can tank performance on lower end computers.':
    'Снимает предел числа окон TGUI. Больше 5 открытых окон может сильно тормозить на слабых компьютерах.',
  'If UIs should scale up to match your monitor scaling.':
    'Окна масштабируются вместе с масштабом монитора.',
  'Say: Light mode': 'Окно речи: светлая тема',
  'Sets TGUI Say to use a light mode.': 'Окно речи TGUI в светлой теме.',
  'Enable tooltips': 'Подсказки',
  'Do you want to see tooltips when hovering over items?':
    'Показывать подсказки при наведении на предметы.',
  'Tooltip delay (in milliseconds)': 'Задержка подсказки (мс)',
  'How long should it take to see a tooltip when hovering over items?':
    'Через сколько появляется подсказка при наведении на предмет.',
  'Enable typing indicators for self': 'Показывать, что вы печатаете',
  "Enable typing indicators that show you're typing a message.":
    'Над вами виден значок, пока вы набираете сообщение.',
  'UI Style': 'Стиль интерфейса',
  'When toggled, some important events will make your game icon flash on your task tray.':
    'При важных событиях значок игры мигает на панели задач.',
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
