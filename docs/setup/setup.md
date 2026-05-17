# Setup Guide

Use this guide to bootstrap a new machine or re-apply the managed terminal environment from the repository root.

## Prerequisites

Before you start:

- Clone this repository locally.
- Make sure you have internet access for package downloads.
- Run the script as a user with `sudo` access on Ubuntu or WSL.
- Start from the repo root: `cd /path/to/dev-environment`

Platform-specific prerequisites:

- **macOS:** Homebrew must already be installed and available on `PATH`.
- **Ubuntu:** This setup currently supports Ubuntu only. `apt-get` must be available.
- **WSL:** Run inside an Ubuntu WSL distro. If you want the Windows Terminal template linked too, Windows Terminal must already be installed on the Windows side.

## Run the bootstrap

Standard run:

```bash
bash scripts/setup.sh
```

Preview the work first:

```bash
bash scripts/setup.sh --dry-run
```

On WSL, also link the tracked Windows Terminal settings template:

```bash
bash scripts/setup.sh --apply-windows-terminal
```

You can combine flags when needed, for example:

```bash
bash scripts/setup.sh --dry-run --apply-windows-terminal
```

## What the setup does

At a high level, the bootstrap script:

1. Detects the platform and dispatches to the macOS, Ubuntu, or WSL setup path.
2. Installs packages from the repo-managed manifest:
   - `Brewfile` on macOS
   - `packages/apt.txt` on Ubuntu and WSL
3. Installs or manages the terminal layer for the platform:
   - macOS: installs Ghostty through Homebrew
   - Ubuntu: adds the Ghostty Ubuntu PPA and installs Ghostty
   - WSL: skips Ghostty and uses Windows Terminal instead
4. Installs JetBrains Mono Nerd Font.
5. Symlinks the managed config files for the shell, Starship, tmux, and Neovim.
6. Backs up existing unmanaged files before replacing them with tracked symlinks.
7. Validates key tools such as `tmux`, `nvim`, `ghostty` (where applicable), and `starship`.

Backups use a timestamped suffix such as `.backup.YYYYMMDD-HHMMSS`.

## Dry-run behavior

`--dry-run` is a preview mode for the scripted actions.

In dry-run mode, the helper functions log the commands that would run instead of executing them. In practice, that makes it useful for checking:

- which package manager commands would run
- which files would be linked
- which existing files would be backed up
- which platform path the script would take

Dry-run still performs prerequisite and environment checks, including platform detection, Ubuntu validation on Linux/WSL, and Homebrew availability on macOS. On macOS it also checks whether the `Brewfile` is already satisfied.

Use it as a safety check before the real run, not as a substitute for the actual setup.

## Platform notes

### macOS

- Requires Homebrew before you begin.
- Uses the tracked `zsh` files: `.zprofile` and `.zshrc`.
- Links Ghostty config to `~/.config/ghostty/config.ghostty`.
- If older Ghostty config files exist in legacy macOS locations, the script backs them up before switching to the tracked config.

### Ubuntu

- Only Ubuntu is supported by the Linux path.
- Uses the tracked `bash` files: `.profile` and `.bashrc`.
- Installs packages from `packages/apt.txt`.
- Installs Ghostty from `ppa:mkasberg/ghostty-ubuntu`.
- Installs JetBrains Mono Nerd Font under `~/.local/share/fonts/JetBrainsMonoNerdFont`.

### WSL

- WSL is treated separately from standalone Linux.
- Uses the Ubuntu package manifest and the tracked `bash` config.
- Does **not** install Ghostty.
- Optionally links the repository's Windows Terminal `settings.json` into the Windows user profile when you pass `--apply-windows-terminal`.
- The Windows Terminal link is created through `cmd.exe` and `wslpath`, so it must be run from inside WSL.

## Manual follow-up after the script finishes

Expect to do a few manual checks after the bootstrap completes:

1. **Open a new shell session** so the linked shell config is picked up.
2. **Launch your terminal app and confirm the font** is JetBrains Mono Nerd Font. The tracked Ghostty config and Windows Terminal template already reference it, but other terminal apps may need a manual font change.
3. **Start `nvim` once** and let the first run finish. Plugin versions are pinned in `dotfiles/shared/nvim/lazy-lock.json`, and the initial launch may still install or update treesitter parsers.
4. **Review any backup files** if the script moved aside existing local config.
5. **On WSL, restart Windows Terminal** after linking the template so the new settings are loaded.
6. **Handle optional cleanup yourself** if needed. For example, removing Oh My Zsh is intentionally not part of this setup flow.

## Expected result

When the script completes successfully, the machine should have the repo-managed terminal/editor packages installed, the tracked dotfiles linked into place, and the core terminal workflow ready for normal use with only the manual follow-up above.
