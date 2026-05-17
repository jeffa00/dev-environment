# Ghostty in this environment

This repo uses Ghostty as the **outer terminal app** on macOS and native Ubuntu. It is the fast GUI layer for windows, tabs, rendering, clipboard, and platform integration. For long-lived terminal work, pair it with `tmux` rather than replacing `tmux`.

## What this setup manages

The tracked Ghostty config is linked to:

```text
~/.config/ghostty/config.ghostty
```

This environment sets Ghostty up with:

- theme: `Horizon Bright` in light mode and `Broadcast` in dark mode
- font: `JetBrainsMono NFM Regular`
- font size: `20`
- block cursor
- balanced `10px` window padding
- slightly taller cell height for a roomier look
- `copy-on-select = clipboard`
- `window-save-state = always`
- translucent background (`background-opacity = 0.8`)

Platform-specific expectations:

- **macOS:** also enables `display-p3` blending, transparent title bar, and strong background blur
- **Ubuntu:** keeps the same overall look, but without the macOS-only blur/titlebar/color-space settings
- **WSL:** Ghostty is **not** part of this managed setup; use the Windows Terminal path instead

## The recommended mental model

Use Ghostty for the **top-level GUI layout**:

- separate windows for totally different contexts
- tabs for a handful of active workstreams
- occasional GUI splits when you want two terminals visible right now

Use `tmux` for the **persistent terminal workspace inside Ghostty**:

- projects you want to resume later
- pane layouts tied to a repo or task
- remote sessions and long-running jobs
- keyboard-first navigation that survives terminal restarts

A good default pattern is:

1. Open one Ghostty tab per broad context.
2. Start `tmux` inside that tab.
3. Use tmux windows/panes for the real working layout.
4. Keep Ghostty splits for short-lived comparison views, not deep nesting.

## Tabs and splits

This repo does **not** override Ghostty keybindings, so you get the app defaults.

### macOS defaults

| Action | Shortcut |
| --- | --- |
| New tab | `Cmd+T` |
| Close current surface | `Cmd+W` |
| Close current tab | `Cmd+Opt+W` |
| Split right (side-by-side) | `Cmd+D` |
| Split down (stacked) | `Cmd+Shift+D` |
| Next split | `Cmd+]` |
| Previous split | `Cmd+[` |
| Move to split by direction | `Cmd+Opt+Arrow` |
| Next tab | `Cmd+Shift+]` |
| Previous tab | `Cmd+Shift+[` |
| Bigger font | `Cmd+=` or `Cmd++` |
| Smaller font | `Cmd+-` |
| Reset font size | `Cmd+0` |

### Ubuntu defaults

Ghostty uses its Linux defaults here because the repo does not remap them. Common defaults are:

| Action | Shortcut |
| --- | --- |
| New tab | `Ctrl+Shift+T` |
| Close tab/surface | `Ctrl+Shift+W` |
| Split right (side-by-side) | `Ctrl+Shift+D` |
| Split down (stacked) | `Ctrl+Shift+E` |
| Next tab | `Ctrl+PageDown` |
| Previous tab | `Ctrl+PageUp` |
| Next split | `Ctrl+\`` |
| Previous split | `Ctrl+Shift+\`` |

If your build differs, check the exact defaults with:

```bash
ghostty +list-keybinds --default
```

## A practical workflow with tmux

The shared `tmux` config in this repo is intentionally simple:

- terminal type: `tmux-256color`
- mouse support: on
- clipboard integration: on
- pane and window numbering start at `1`
- vi-style copy-mode keys
- quick pane movement after the tmux prefix with `h`, `j`, `k`, `l`
- splits with tmux prefix + `|` or `-`
- new tmux window with tmux prefix + `c`

That makes the division of labor straightforward:

### Use Ghostty tabs when

- you want a clean visual separation between tasks
- you want different projects side by side at the app level
- you want to keep one `tmux` session per tab
- you want Ghostty to restore the window/tab state on relaunch

### Use tmux windows and panes when

- the layout belongs to one project
- you need persistence across reconnects or app restarts
- you are SSH'd into another machine
- you want repeatable keyboard navigation inside the same shell session

### Example

A concrete setup for one repo might look like this:

- **Ghostty window:** “work”
  - **Tab 1:** project A → inside, one `tmux` session
  - **Tab 2:** project B → inside, one `tmux` session
  - **Tab 3:** scratch shell or logs

Inside the tmux session for project A:

- pane 1: editor or shell
- pane 2: tests/watch process
- pane 3: git/status/logs

That keeps Ghostty uncluttered while still giving you persistence and fast keyboard navigation.

## Font and rendering expectations

You should expect this setup to look noticeably styled, not like a stock terminal.

### Font

Ghostty is configured for:

```text
JetBrainsMono NFM Regular
```

That is the Nerd Font variant, so prompt icons and other patched glyphs should render correctly.

Useful checks:

```bash
ghostty +list-fonts | rg "JetBrainsMono NFM Regular"
ls -l ~/.config/ghostty/config.ghostty
```

On Ubuntu, the setup installs the font under:

```text
~/.local/share/fonts/JetBrainsMonoNerdFont
```

### Rendering and feel

What is intentional in this setup:

- large default text (`20pt`)
- extra breathing room from padding and taller cells
- block cursor
- slightly faster-feeling mouse scroll
- immediate copy on text selection
- semi-transparent background

On macOS specifically, expect a more polished translucent look because the config also enables:

- background blur
- transparent title bar
- Display P3 color blending

On Ubuntu, the terminal should still be readable and translucent, but it will not look exactly the same as macOS. That difference is expected.

## Clipboard behavior

Ghostty is set to copy selected text directly to the system clipboard. In practice:

- drag to select text in Ghostty
- release the mouse
- the selection is already copied
- paste with your normal OS paste shortcut

Inside `tmux`, remember there are two different layers:

- **Ghostty selection** for quick GUI copy/paste
- **tmux copy mode** for scrollback- and pane-aware copying

This repo also enables `set-clipboard on` in tmux, so tmux copies are meant to integrate with the system clipboard too.

## Platform notes

### macOS

- Ghostty is installed via Homebrew cask as part of the repo setup.
- The managed config comes from `dotfiles/macos/ghostty/config.ghostty`.
- The setup also backs up older Ghostty config locations under `~/Library/Application Support/com.mitchellh.ghostty/` and `~/.config/ghostty/config`.
- `window-save-state = always` is especially noticeable here because Ghostty tends to come back with the last window/tab layout.

### Ubuntu

- Ghostty is installed from the Ubuntu Ghostty PPA used by the setup scripts.
- The managed config comes from `dotfiles/linux/ghostty/config.ghostty`.
- The setup backs up an unmanaged `~/.config/ghostty/config` before switching to the repo-managed file.
- Visual effects are a little simpler than on macOS; that is by design, not a broken config.

## Troubleshooting

### The wrong config seems to be loading

Check the managed path first:

```bash
ls -l ~/.config/ghostty/config.ghostty
```

You want that file to point at the repo copy, not a hand-edited local file.

Also look for older files that may be confusing your own troubleshooting:

- `~/.config/ghostty/config`
- macOS: `~/Library/Application Support/com.mitchellh.ghostty/config`
- macOS: `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`

### Icons or prompt glyphs look wrong

Usually this means the Nerd Font is missing or Ghostty is not using the managed font.

Checks:

```bash
ghostty +list-fonts | rg "JetBrainsMono NFM Regular"
```

On Ubuntu, also confirm the font files exist under `~/.local/share/fonts/JetBrainsMonoNerdFont`.

### It looks different on Ubuntu than on macOS

That is normal. The repo intentionally keeps the same base theme/font settings but only macOS gets the extra blur, transparent title bar, and Display P3 color handling.

### Copy/paste feels inconsistent inside tmux

Ghostty selection and tmux copy mode are different workflows. If plain mouse selection is awkward in a tmux-heavy session, use tmux copy mode for terminal-native copying instead of expecting Ghostty selection to solve every case.

### Ghostty restores old tabs you no longer want

That comes from:

```text
window-save-state = always
```

Close tabs you no longer want before quitting Ghostty. If you prefer a clean restart for a session, fully close the extra tabs/windows first.

### Shortcuts do not match this guide

The repo does not override Ghostty bindings, so differences usually come from Ghostty version or platform. Confirm your build's defaults with:

```bash
ghostty +list-keybinds --default
```

## Bottom line

In this environment, Ghostty is the fast, polished outer terminal layer. Use it for windows, tabs, rendering, and clipboard behavior; use `tmux` inside it for persistent shells, panes, and long-running work. That combination matches how this repo is configured and gives the least-friction day-to-day workflow.
