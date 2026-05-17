# tmux guide

This environment uses the shared tmux config at `dotfiles/shared/tmux/tmux.conf`, linked to `~/.tmux.conf` by the setup script.

This guide focuses on **how to use tmux day to day in this setup**.

## What is configured here

The tracked config keeps tmux close to stock behavior, but adds a few practical defaults:

- prefix key stays at the tmux default: `Ctrl-b`
- mouse support is on
- system clipboard integration is on
- window numbering starts at `1`
- pane numbering starts at `1`
- windows are renumbered automatically when one closes
- pane navigation uses `prefix` + `h/j/k/l`
- splitting and new windows start in the **current pane's directory**
- copy mode uses **vi keys**
- `Escape` handling is tuned to feel immediate
- tmux history is increased to `100000` lines
- config reload is bound to `prefix` + `r`
- terminal settings are set up for 256-color and truecolor-friendly apps like Neovim

If you are new to tmux, read `prefix` below as `Ctrl-b`, then release, then press the next key.

The `escape-time 0` setting is especially nice if you use Neovim inside tmux, because leaving insert mode with `Esc` feels snappy instead of delayed.

## Core ideas

tmux is easiest to use if you remember three levels:

1. **session**: a whole workspace, usually one per project or task
2. **window**: like a tab inside that session
3. **pane**: a split inside a window

A common structure is:

- one session per repo or client
- one window for editing
- one window for tests/logs
- one or two panes per window

## Starting tmux

Start a brand new unnamed session:

```bash
tmux
```

Start a named session:

```bash
tmux new -s dev
```

Start a named session in a project directory:

```bash
cd ~/src/my-project
tmux new -s my-project
```

Or in one command:

```bash
tmux new -s my-project -c ~/src/my-project
```

## Detaching and attaching

Detach from the current session without stopping anything:

- `prefix` + `d`

List sessions:

```bash
tmux ls
```

Attach to a session by name:

```bash
tmux attach -t my-project
```

If there is only one session, this also works:

```bash
tmux attach
```

Close a session when you are done with it:

```bash
tmux kill-session -t my-project
```

## Windows

Create a new window in the current directory:

- `prefix` + `c`

Why this matters here: the config uses `new-window -c "#{pane_current_path}"`, so if you are in a repo already, the new window opens there instead of dropping you into your home directory.

Useful default window keys:

- `prefix` + `n` — next window
- `prefix` + `p` — previous window
- `prefix` + `w` — choose from a list
- `prefix` + `,` — rename the current window
- `prefix` + `&` — close the current window
- `prefix` + `1` through `9` — jump directly to a window number

In this config, window numbers start at `1`, not `0`.

Because `renumber-windows` is enabled, if you close window 2 out of 3, the remaining windows shift to stay consecutive. That keeps `prefix` + number predictable.

## Panes

Split horizontally (side by side):

- `prefix` + `|`

Split vertically (top/bottom):

- `prefix` + `-`

These splits also inherit the current pane's working directory.

Move between panes with the custom bindings in this setup:

- `prefix` + `h` — left
- `prefix` + `j` — down
- `prefix` + `k` — up
- `prefix` + `l` — right

Useful default pane keys:

- `prefix` + `x` — close the current pane
- `prefix` + `z` — zoom/unzoom a pane
- `prefix` + `q` — briefly show pane numbers
- `prefix` + arrow keys — move between panes using defaults
- `prefix` + `o` — cycle through panes

### Suggested pane layouts

Editor + shell:

```text
+--------------------+--------------------+
| Neovim             | shell / git / test |
+--------------------+--------------------+
```

Editor + test runner + notes:

```text
+--------------------+--------------------+
| Neovim             | test run           |
|                    +--------------------+
|                    | notes / commands   |
+--------------------+--------------------+
```

Zoom the active pane with `prefix` + `z` when you want temporary full-screen focus.

## Mouse behavior

Mouse mode is enabled:

- click a pane to focus it
- drag pane borders to resize
- use the mouse wheel to scroll
- select text with the mouse

This makes tmux more forgiving, especially inside Ghostty.

That said, keyboard navigation is still faster once your layout is stable.

## Copy mode and clipboard

This environment is set up so clipboard use is practical across tmux, Ghostty, and Neovim:

- tmux has `set-clipboard on`
- tmux copy mode uses `vi` keys
- Ghostty has `copy-on-select = clipboard`
- Neovim uses `clipboard = unnamedplus`

### When to use what

- **Quick mouse selection in Ghostty**: good for grabbing visible output fast
- **tmux copy mode**: best when the text is in tmux scrollback and off-screen
- **Neovim yank/paste**: best when you are working inside files

### Entering copy mode

Use the tmux default:

- `prefix` + `[`

Once in copy mode, this setup uses vi-style movement, so common keys are:

- `h`, `j`, `k`, `l` — move
- `w`, `b`, `e` — move by word
- `0`, `^`, `$` — start/end of line
- `g` — top of history
- `G` — bottom of history
- `/` — search forward
- `?` — search backward
- `n` / `N` — next or previous match
- `Space` — begin selection
- `Enter` — copy selection
- `Esc` — leave copy mode

### Practical copy workflow

Example: copy a failing test command from earlier output.

1. Press `prefix` + `[`
2. Search with `/error` or scroll to the section you need
3. Press `Space` to start selecting
4. Move to extend the selection
5. Press `Enter` to copy
6. Paste into Ghostty, Neovim, or another app

If plain mouse selection is enough, Ghostty's `copy-on-select` can be faster.

## Session workflows that fit this setup

### 1. One session per project

For a repo called `dev-environment`:

```bash
cd ~/repos/dev-environment
tmux new -s dev-env
```

Suggested windows:

- `1` editor
- `2` shell
- `3` git
- `4` docs/tests

That gives you a stable mental map:

- `prefix` + `1` for editing
- `prefix` + `2` for commands
- `prefix` + `3` for git work

### 2. Neovim in one pane, terminal tasks in another

A strong default in this environment is:

- left pane: `nvim`
- right pane: shell for git, searches, and test commands

Because Neovim is configured with:

- mouse support
- system clipboard access
- `Ctrl-h/j/k/l` window movement inside Neovim

You can keep editor navigation and tmux navigation conceptually similar:

- **inside Neovim splits**: `Ctrl-h/j/k/l`
- **between tmux panes**: `prefix` + `h/j/k/l`

That consistency makes it easier to move around without thinking too much.

### 3. Ghostty outside, tmux inside

A good layering model is:

- **Ghostty window/tab** = broad context
- **tmux session** = project workspace
- **tmux window** = task area
- **tmux pane** = active process

Example:

- Ghostty window 1: work project
- Ghostty window 2: personal notes or admin tasks
- inside Ghostty window 1, tmux session `client-a`
- inside that tmux session, windows for editor, logs, and git

Ghostty already remembers window state and supports clipboard-friendly selection, so you can let Ghostty handle the outer terminal experience and let tmux handle persistence and structure.

## Useful commands to remember

```bash
tmux ls                      # list sessions
tmux new -s name            # create session
tmux attach -t name         # attach to session
tmux kill-session -t name   # close session
tmux source-file ~/.tmux.conf
```

Inside tmux, the most useful keys in this setup are:

- `prefix` + `d` — detach
- `prefix` + `c` — new window in current directory
- `prefix` + `|` — split left/right in current directory
- `prefix` + `-` — split top/bottom in current directory
- `prefix` + `h/j/k/l` — move between panes
- `prefix` + `z` — zoom pane
- `prefix` + `[` — enter copy mode
- `prefix` + `r` — reload tmux config

## Reloading config

After changing `~/.tmux.conf` or the tracked repo file, reload without restarting tmux:

- `prefix` + `r`

This runs:

```tmux
source-file ~/.tmux.conf
```

You should see the message:

```text
tmux.conf reloaded
```

## Troubleshooting

### New windows or panes start in the wrong directory

In this setup, `c`, `|`, and `-` are explicitly configured to reuse the current pane path. If a new shell still lands somewhere unexpected, usually the cause is one of these:

- you created the session from a different directory
- the current pane changed directories before you split
- you used a tmux default binding instead of the configured one

Use the configured keys from this guide when you want path inheritance:

- `prefix` + `c`
- `prefix` + `|`
- `prefix` + `-`

### Copy and paste feels inconsistent

Check which layer you are using:

- Ghostty selection copies directly to the system clipboard
- tmux copy mode copies from tmux scrollback
- Neovim yanks to the system clipboard because `unnamedplus` is enabled

If one method feels odd, switch layers instead of fighting it. For example, use tmux copy mode for older output and Ghostty selection for visible text.

### Pane movement keys are not working

Remember that tmux pane movement here is **not** bare `h/j/k/l`.
You must press the prefix first:

- `Ctrl-b`, then `h`
- `Ctrl-b`, then `j`
- `Ctrl-b`, then `k`
- `Ctrl-b`, then `l`

If you are inside Neovim, `Ctrl-h/j/k/l` belongs to Neovim window movement, not tmux pane movement.

### Window numbers seem to change after closing one

That is expected. This config has `renumber-windows on`, so tmux removes gaps automatically.

Example:

- open windows `1`, `2`, `3`
- close window `2`
- the old window `3` becomes window `2`

### Mouse scrolling behaves differently depending on context

That is normal too:

- in a shell pane, the wheel usually scrolls tmux history
- in Neovim, mouse handling may be captured by Neovim
- selecting text may behave differently depending on whether you use Ghostty selection or tmux copy mode

If mouse behavior is awkward, fall back to keyboard-driven tmux copy mode with `prefix` + `[`.

## Example day-to-day workflow

Start a project workspace:

```bash
cd ~/repos/dev-environment
tmux new -s dev-env
```

Then:

1. press `prefix` + `|` to create a right-hand shell pane
2. run `nvim` in the left pane
3. use the right pane for `git status`, searches, and setup commands
4. press `prefix` + `c` to create a second window for longer-running tasks
5. detach with `prefix` + `d` when stepping away
6. later, return with `tmux attach -t dev-env`

That is the main benefit of tmux in this environment: your project layout survives terminal closes, network hiccups, and context switches.
