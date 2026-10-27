# Community scripts

Scripts that contributors wrote to process content for their pull requests: converting, cutting, recolouring or generating sprites, porting types from other forks, rewriting maps, mass-editing strings. They are kept so that the next person who meets the same task starts from working (or half-working) code and from the notes about what went wrong, instead of from nothing.

This folder is not part of the build, and CI does not run anything in it.

## The rule

- Every script written to process content for a pull request is committed here **in its final version**, in the same pull request. Not every iteration — the one you ended with.
- This applies **above all to work with graphics**: `.dmi` sheets, icon states, frames, palettes, masks, on-mob sprites.
- Share it **even if the script is rough** and **even if the work was not finished**. Say so in the description; an unfinished script with honest notes is still worth keeping.
- What a script wrote is not verified by the script. Sprites are checked in DreamMaker and in game, code by compiling the project. Write down how you checked the result.

## Layout

One folder per task:

```
community_scripts/
  <short-task-name>/
    README.md        what the task was, what the script solved, what went wrong
    <script files>
```

Use a short, plain name for the folder (`sleeve-masks`, `title-gif-to-dmi`, `ratwood-food-port`). Scripts take every path as an argument: no absolute paths of your machine inside them.

## Template for `README.md`

```markdown
# <Task name>

- Pull request: #<number>
- Author: <GitHub name>; written with: <model, e.g. Claude Opus 5.5>
- Status: finished / unfinished (what is left)

## Task
What had to be done and why. Which files of the repository it was about.

## Problem it solved
What the script does, step by step. Why a script and not a hand edit.

## How to run
Language and version, dependencies, working directory, every argument,
what it reads and what it writes. One example command.

## Errors and failures seen
Every error, wrong output or dead end met while it ran, and what was done about it:
crashes, wrong colours or offsets, broken frames, states it skipped, slow runs,
cases it still gets wrong.

## How the result was checked
DreamMaker, in game, a compile, a diff — and what was not checked.
```
