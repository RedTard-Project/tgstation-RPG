import { useEffect, useReducer, useRef } from 'react';
import { toTitleCase } from 'tgui-core/string';
import { playSelectSound } from 'tgui-lobby/audio';
import { LobbyMenu, type ServerState } from 'tgui-lobby/LobbyMenu';
import { readDmiAnimation } from './dmi';

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
  titleSheetUrl?: string;
};

function mergeState(state: RogueState, update: RogueState): RogueState {
  return { ...state, ...update };
}

function sendAction(action: string) {
  playSelectSound();
  Byond.sendMessage('action', { action });
}

/**
 * TG's lobby menu as it is, over the title screen played frame by frame, and Azure Peak's lobby beside it. Both hear
 * the same init and state messages as TG's menu.
 */
export function RogueLobby() {
  const [state, merge] = useReducer(mergeState, {});

  useEffect(() => {
    Byond.subscribeTo('init', merge);
    Byond.subscribeTo('state', merge);
  }, []);

  return (
    <>
      {!state.transparent && !!state.titleSheetUrl && (
        <TitleAnimation url={state.titleSheetUrl} />
      )}
      <LobbyMenu />
      {!!state.gamePhase && <AzurePanel state={state} />}
    </>
  );
}

/** Class on the root while the title plays, so TG's still first frame gives way to it. */
const ANIMATED_CLASS = 'rogue-lobby-title-animated';

/**
 * The title screen as BYOND plays it on the map: TG's lobby shows a still picture of its first frame, so the menu
 * gets the DMI itself (a PNG of all frames) and draws one frame after another with the DMI's own delays, filling the
 * window as TG's background does (cover, centred). A title that does not animate stays TG's still picture.
 */
function TitleAnimation({ url }: { url: string }) {
  const canvasRef = useRef<HTMLCanvasElement>(null);

  useEffect(() => {
    let stopped = false;
    let timer: ReturnType<typeof setTimeout> | undefined;
    let paint = () => {};

    (async () => {
      const data = await fetch(url).then((response) => response.arrayBuffer());
      const animation = await readDmiAnimation(data);
      if (!animation || stopped) {
        return;
      }
      // The sheet from the bytes already fetched: no second download, and the canvas stays readable.
      const source = URL.createObjectURL(new Blob([data], { type: 'image/png' }));
      const image = new Image();
      image.src = source;
      await image.decode().finally(() => URL.revokeObjectURL(source));
      const canvas = canvasRef.current;
      const context = canvas?.getContext('2d');
      if (stopped || !canvas || !context) {
        return;
      }
      const { width, height, cells, delays, loops } = animation;
      const columns = Math.max(1, Math.floor(image.width / width));
      let step = 0;
      let played = 0;

      paint = () => {
        const ratio = window.devicePixelRatio || 1;
        const canvasWidth = Math.round(canvas.clientWidth * ratio);
        const canvasHeight = Math.round(canvas.clientHeight * ratio);
        if (canvas.width !== canvasWidth || canvas.height !== canvasHeight) {
          canvas.width = canvasWidth;
          canvas.height = canvasHeight;
        }
        const scale = Math.max(canvasWidth / width, canvasHeight / height);
        const cell = cells[step];
        context.imageSmoothingEnabled = false;
        context.clearRect(0, 0, canvasWidth, canvasHeight);
        context.drawImage(
          image,
          (cell % columns) * width,
          Math.floor(cell / columns) * height,
          width,
          height,
          (canvasWidth - width * scale) / 2,
          (canvasHeight - height * scale) / 2,
          width * scale,
          height * scale,
        );
      };

      const advance = () => {
        paint();
        if (step === cells.length - 1) {
          played++;
          if (loops && played >= loops) {
            return;
          }
        }
        // BYOND's delays are deciseconds.
        const delay = (delays[step] || 1) * 100;
        step = (step + 1) % cells.length;
        timer = setTimeout(advance, delay);
      };

      document.documentElement.classList.add(ANIMATED_CLASS);
      window.addEventListener('resize', paint);
      advance();
    })().catch(() => {
      // TG's still first frame stays under the menu.
    });

    return () => {
      stopped = true;
      clearTimeout(timer);
      window.removeEventListener('resize', paint);
      document.documentElement.classList.remove(ANIMATED_CLASS);
    };
  }, [url]);

  return <canvas ref={canvasRef} className="rogue-lobby-title" />;
}

/**
 * Azure Peak's lobby (NewPlayerPanel.tsx) for what TG's menu lacks: the welcome, the character one plays as, the
 * classes the ready players took, keybindings.
 */
function AzurePanel({ state }: { state: RogueState }) {
  const phase = state.gamePhase;

  return (
    <div className="rogue-lobby">
      <div className="rogue-lobby__welcome">
        Welcome To {toTitleCase(state.serverName || '')}
      </div>
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
