import { useEffect, useReducer, useState } from 'react';
import { createBundle, type TegakiBundle, TegakiRenderer } from 'tegaki/react';
import { toTitleCase } from 'tgui-core/string';
import { assetMap } from 'tgui-lobby/assets';
import { playSelectSound } from 'tgui-lobby/audio';
import { LobbyMenu, type ServerState } from 'tgui-lobby/LobbyMenu';

type ReadyJob = {
  name: string;
  length: number;
  players: string | null;
};

/** TG's lobby state with what the medieval menu adds (modular_redtard/lobby/rogue_lobby.dm, rogue_state()). */
type RogueState = Partial<ServerState> & {
  serverName?: string;
  activeCharacter?: string | null;
  readyJobs?: ReadyJob[];
  migrantQueued?: boolean;
  inLobby?: boolean;
};

function mergeState(state: RogueState, update: RogueState): RogueState {
  return { ...state, ...update };
}

function sendAction(action: string) {
  playSelectSound();
  Byond.sendMessage('action', { action });
}

/**
 * TG's lobby menu as it is, over the title screen in motion, and Azure Peak's lobby beside it. Both hear the same init
 * and state messages as TG's menu. The title leaves with the lobby, so that it costs nothing during the round.
 */
export function RogueLobby() {
  const [state, merge] = useReducer(mergeState, {});

  useEffect(() => {
    Byond.subscribeTo('init', merge);
    Byond.subscribeTo('state', merge);
  }, []);

  return (
    <>
      {!!state.inLobby && !state.transparent && <TitleAnimation />}
      <LobbyMenu />
      {!!state.gamePhase && <AzurePanel state={state} />}
    </>
  );
}

/** The title screen in motion, sent as the rogue_lobby_title asset. */
const TITLE_ASSET = 'rogue_lobby_title.webp';
/** Class on the root while the title plays, so TG's still first frame gives way to it. */
const ANIMATED_CLASS = 'rogue-lobby-title-animated';
/** How long the menu waits for the title: five minutes, once a second. */
const TITLE_FETCH_ATTEMPTS = 300;
const TITLE_FETCH_RETRY_MS = 1000;

/** The title once all of it is there: it is megabytes and comes after the menu, and a WebP states its own size. */
async function fetchTitle(url: string): Promise<ArrayBuffer | null> {
  try {
    const response = await fetch(url, { cache: 'no-store' });
    if (!response.ok) {
      return null;
    }
    const data = await response.arrayBuffer();
    const stated = data.byteLength > 8 && new DataView(data).getUint32(4, true);
    return stated && stated + 8 === data.byteLength ? data : null;
  } catch {
    return null;
  }
}

/**
 * The title screen in motion over TG's still picture of its first frame: a browser only gets that picture of a DMI, so
 * the animation is a WebP of its own, which the browser plays and scales by itself. Until it arrives, and if it never
 * does, TG's picture stays.
 */
function TitleAnimation() {
  const [source, setSource] = useState<string>();

  useEffect(() => {
    let stopped = false;
    let objectUrl: string | undefined;

    (async () => {
      for (let attempt = 0; attempt < TITLE_FETCH_ATTEMPTS && !stopped; attempt++) {
        const url = assetMap[TITLE_ASSET];
        const data = url ? await fetchTitle(url) : null;
        if (data) {
          if (!stopped) {
            objectUrl = URL.createObjectURL(new Blob([data], { type: 'image/webp' }));
            setSource(objectUrl);
          }
          return;
        }
        await new Promise((resolve) => setTimeout(resolve, TITLE_FETCH_RETRY_MS));
      }
    })();

    return () => {
      stopped = true;
      if (objectUrl) {
        URL.revokeObjectURL(objectUrl);
      }
      document.documentElement.classList.remove(ANIMATED_CLASS);
    };
  }, []);

  if (!source) {
    return null;
  }
  return (
    <img
      className="rogue-lobby-title"
      src={source}
      alt=""
      onLoad={() => document.documentElement.classList.add(ANIMATED_CLASS)}
    />
  );
}

/** Parisienne with its stroke data, sent as the rogue_lobby_font asset; null when it cannot be loaded. */
async function loadHandwriting(): Promise<TegakiBundle | null> {
  const fontUrl = assetMap['parisienne.ttf'];
  const dataUrl = assetMap['parisienne_data.json'];
  if (!fontUrl || !dataUrl) {
    return null;
  }
  try {
    const glyphData = await fetch(dataUrl).then((response) => response.json());
    return createBundle({
      family: 'Parisienne',
      fontUrl,
      glyphData,
      unitsPerEm: 2048,
      ascender: 1875,
      descender: -915,
    });
  } catch {
    return null;
  }
}

/**
 * Azure's welcome written out by hand, stroke after stroke (tegaki, Azure's TegakiAnimation); without the font it
 * fades in in MedievalSharp, as Azure falls back.
 */
function HandwrittenWelcome({ text }: { text: string }) {
  const [font, setFont] = useState<TegakiBundle | null | undefined>(undefined);

  useEffect(() => {
    let stopped = false;
    loadHandwriting().then((bundle) => {
      if (!stopped) {
        setFont(bundle);
      }
    });
    return () => {
      stopped = true;
    };
  }, []);

  if (font === undefined) {
    return <div className="rogue-lobby__welcome-space" />;
  }
  if (font === null) {
    return <div className="rogue-lobby__welcome">{text}</div>;
  }
  return (
    <div className="rogue-lobby__welcome rogue-lobby__welcome--handwritten">
      <TegakiRenderer
        font={font}
        time={{ mode: 'uncontrolled', speed: 10, loop: false }}
      >
        {text}
      </TegakiRenderer>
    </div>
  );
}

/**
 * Azure Peak's lobby (NewPlayerPanel.tsx) for what TG's menu lacks: the welcome, the character one plays as, the
 * classes the ready players took, keybindings.
 */
function AzurePanel({ state }: { state: RogueState }) {
  const phase = state.gamePhase;

  return (
    <div className="rogue-lobby">
      <HandwrittenWelcome
        text={`Welcome To ${toTitleCase(state.serverName || '')}`}
      />
      {!!state.activeCharacter && (
        <div className="rogue-lobby__line">
          Playing As: {state.activeCharacter}
        </div>
      )}
      {(phase === 'startup' || phase === 'pregame') && (
        <PreGame state={state} />
      )}
      {phase === 'setting_up' && (
        <div className="rogue-lobby__notice">Round Is Starting...</div>
      )}
      {phase === 'playing' && (
        <>
          {!!state.migrantQueued && (
            <div className="rogue-lobby__line rogue-lobby__good">
              In the migrant queue
            </div>
          )}
          <button
            type="button"
            className="rogue-lobby__button"
            onClick={() => sendAction('migrants')}
          >
            Migration
          </button>
        </>
      )}
      {phase === 'postgame' && (
        <div className="rogue-lobby__notice">
          WEEKS END
          <div className="rogue-lobby__small">
            Thanks For Playing! The server will restart soon.
          </div>
        </div>
      )}
      <button
        type="button"
        className="rogue-lobby__button"
        onClick={() => sendAction('keybindings')}
      >
        Keybindings
      </button>
    </div>
  );
}

function PreGame({ state }: { state: RogueState }) {
  return (
    <>
      <div className="rogue-lobby__line">Time to start: {state.countdown}</div>
      <div className="rogue-lobby__line">
        Total players ready: {state.readyCount}
      </div>
      <div
        className={`rogue-lobby__line ${state.isReady ? 'rogue-lobby__good' : 'rogue-lobby__bad'}`}
      >
        {state.isReady ? 'Ready' : 'Not Ready'}
      </div>
      <div
        className={`rogue-lobby__line ${state.isReady ? 'rogue-lobby__good' : 'rogue-lobby__bad'}`}
        title="Ready up for a pouch of twenty mammons, a full belly and a good meal!"
      >
        {state.isReady ? 'Ready Bonus!' : 'No bonus! Ready up!'}
      </div>
      <div className="rogue-lobby__header">Classes</div>
      <div className="rogue-lobby__classes">
        {(state.readyJobs || []).map((job) => (
          <div key={job.name}>
            <b>{job.name}</b> ({job.length})
            {job.players ? ` - ${job.players}` : null}
          </div>
        ))}
      </div>
    </>
  );
}
