<p align="center">
  <img width="512" height="512" alt="Vibelin_logo" src="https://github.com/user-attachments/assets/4a549649-633a-4ca9-a895-6e8145fbdb14" />
</p>

# TGSTATION-RPG
[![modular_redtard](https://github.com/RedTard-Project/tgstation-RPG/actions/workflows/redtard_ci.yml/badge.svg)](https://github.com/RedTard-Project/tgstation-RPG/actions/workflows/redtard_ci.yml)
[![CI Suite](https://github.com/RedTard-Project/tgstation-RPG/actions/workflows/ci_suite.yml/badge.svg)](https://github.com/RedTard-Project/tgstation-RPG/actions/workflows/ci_suite.yml)

A vibe fork of /tg/station turned RPG: Roguetown (Ratwood, Azure Peak, Vibelin) rebuilt on top of current /tg/station.

| Website | Link |
|---------|------|
| Discord | [https://discord.gg/9DfkYJcFyF](https://discord.gg/9DfkYJcFyF) |
| Code    | [https://github.com/RedTard-Project/tgstation-RPG](https://github.com/RedTard-Project/tgstation-RPG) |

Everything of the fork lives in [`modular_redtard/`](./modular_redtard): the module, its build wrapper and its documentation (in Russian) — what is done and what is left ([TASKS.md](./modular_redtard/TASKS.md)), how each system works ([README.md](./modular_redtard/README.md)), and every place it touches /tg/station ([OVERRIDES.md](./modular_redtard/OVERRIDES.md)).

## BUILDING

`modular_redtard/build/BUILD_REDTARD.cmd` builds the game with the module (Linux: `modular_redtard/build/build.sh build`). `tgstation.dme` and `bin/build.cmd` build plain /tg/station without it.

## MAINTAINER POLICY

These rules exist to help fellow vibe coders: whoever comes next should find the prompts, the skills and the scripts that worked, along with the mistakes made on the way, instead of starting from nothing.

- **AI code is welcome.** This repository mainly takes AI-written code signed by Claude Opus 5.5 or a stronger model: a `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>` trailer (or a newer model's) on the commits.
- **We never edit upstream code.** /tg/station is merged in as it is, and every pull request that changes upstream code will be rejected: reach the behaviour from `modular_redtard/` instead. The only upstream files the fork touches are repository meta (this page, `.github/`) and one line of the CI include schema, each logged in [OVERRIDES.md](./modular_redtard/OVERRIDES.md).
- **Share your content scripts.** Every script written to process content for a pull request (converting, cutting, recolouring or generating sprites, porting types, rewriting maps, mass-editing strings) goes in its final version into [`community_scripts/`](./community_scripts), in the same pull request. This matters most for work with graphics. Describe each script clearly and in detail: what the task was, what problem it solved, how to run it, and which errors and failures showed up while it ran. Share it even if the script is rough and even if the work never reached its goal: the next contributor starts from it instead of from nothing, and that is how the repository grows. The format is in [community_scripts/README.md](./community_scripts/README.md).
- **Subsystems and defines need a separate discussion.** Adding, changing or removing a subsystem or a define, upstream's or the module's, is discussed on Discord before the pull request.
- **Vibe check for high-risk changes.** A pull request that works in the high-risk zone — levels 4 and 5 below (new defaults and overrides on upstream types), subsystems, defines, the build wrapper or CI — comes with the prompts that mattered most and the list of skills used to write it. Paste them into the pull request description. Maintainers and trusted contributors may skip this.
- **Levels of impact on code**, from the safest to the most invasive. Use the lowest level that does the job; every change from level 2 up is logged in [OVERRIDES.md](./modular_redtard/OVERRIDES.md).
  1. A new file or type inside `modular_redtard/`.
  2. A subtype of an upstream type.
  3. A new var or proc on an upstream type, re-opened from a module file.
  4. A new default value for a var of an upstream type.
  5. An override of an upstream proc that wraps it with `..()`. Never copy a whole upstream proc to change one line: the copy silently hides every later upstream fix.
  6. An edit of an upstream file: not accepted (see above). The same goes for upstream maps, icons and sounds; ship your own inside the module.

## LICENSE

All code after [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/12/31 at 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU AGPL v3](https://www.gnu.org/licenses/agpl-3.0.html).

All code before [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/12/31 at 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html).
(Including tools unless their readme specifies otherwise.)

See LICENSE and GPLv3.txt for more details.

The TGS DMAPI is licensed as a subproject under the MIT license.

See the footer of [code/\_\_DEFINES/tgs.dm](./code/__DEFINES/tgs.dm) and [code/modules/tgs/LICENSE](./code/modules/tgs/LICENSE) for the MIT license.

All assets including icons and sound are under a [Creative Commons 3.0 BY-SA license](https://creativecommons.org/licenses/by-sa/3.0/) unless otherwise indicated.
