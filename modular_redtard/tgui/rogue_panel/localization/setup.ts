// Wires Vibelin's chat translation into TG's chat panel without touching it. Vibelin hooks TG's renderer.tsx and
// listeners.ts; here a MutationObserver translates each chat message as the renderer puts it on the page, and the
// server's messages (modular_redtard/localization/panel.dm) are taken with Byond.subscribeTo beside TG's own.
import { createLogger } from 'tgui/logging';
import {
  loadDeclensions,
  loadDictionary,
  setLang,
  translateNode,
} from './translate';
import type { Cases, Dictionary, Lang } from './types';

const logger = createLogger('localization');

type LocalizationConfig = {
  lang?: Lang;
  dictionaryUrl?: string;
};

const MESSAGE_CLASS = 'ChatMessage';

let fetchedUrl: string | null = null;

async function fetchDictionary(url: string): Promise<void> {
  try {
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }
    loadDictionary((await response.json()) as Dictionary);
  } catch (error) {
    fetchedUrl = null;
    logger.error(
      'failed to load the chat dictionary, staying in English',
      error,
    );
  }
}

function translateAdded(node: Node): void {
  if (!(node instanceof HTMLElement)) {
    return;
  }
  if (node.classList.contains(MESSAGE_CLASS)) {
    translateNode(node);
    return;
  }
  // A whole batch of messages added at once (a tab switch, history replay).
  for (const message of Array.from(
    node.getElementsByClassName(MESSAGE_CLASS),
  )) {
    translateNode(message);
  }
}

function observeMessages(): void {
  const observer = new MutationObserver((mutations) => {
    for (const mutation of mutations) {
      for (const node of Array.from(mutation.addedNodes)) {
        translateAdded(node);
      }
    }
  });
  observer.observe(document.body, { childList: true, subtree: true });
}

export function setupLocalization(): void {
  Byond.subscribeTo('localization/config', (payload: LocalizationConfig) => {
    const lang = payload?.lang === 'en' ? 'en' : 'ru';
    setLang(lang);
    // Ratwood's Pterra has no Cyrillic: the chat reads in it in English only (chat/ratwood.scss). On the body, as
    // TG's Layout overwrites the root's classes with its theme.
    document.body?.classList.toggle('rogue-lang-en', lang === 'en');
    const url = payload?.dictionaryUrl;
    if (url && url !== fetchedUrl) {
      fetchedUrl = url;
      fetchDictionary(url);
    }
  });
  Byond.subscribeTo(
    'localization/declensions',
    (payload: Record<string, Cases>) => {
      if (payload) {
        loadDeclensions(payload);
      }
    },
  );
  // The bundle may run before the body exists, as TG's panel itself waits for it.
  if (document.body) {
    observeMessages();
  } else {
    document.addEventListener('DOMContentLoaded', observeMessages);
  }
}
