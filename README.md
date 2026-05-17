# dev-environment

Bootstrap repo for a personal terminal/editor environment on macOS, Ubuntu, and Ubuntu on WSL. It installs the in-scope packages for each platform and links the tracked config in this repo into your home directory.

This repo manages the terminal/editor layer only. It does **not** try to do full machine provisioning, manage VS Code, or remove unrelated packages.

## Supported platforms

- macOS
- Ubuntu
- Ubuntu on WSL

## What it manages

The setup links tracked config into standard home-directory locations such as shell startup files, `~/.tmux.conf`, `~/.config/nvim`, `~/.config/starship.toml`, Ghostty config, and, on WSL with opt-in, Windows Terminal `settings.json`.

- package install via `Brewfile` on macOS
- package install via `packages/apt.txt` on Ubuntu and WSL
- shared `tmux`, Neovim, and Starship config in `dotfiles/shared/`
- macOS `zsh` and Ghostty config in `dotfiles/macos/`
- Ubuntu `bash` and Ghostty config in `dotfiles/linux/`
- optional Windows Terminal settings template for WSL in `dotfiles/wsl/windows-terminal/`
- pinned Neovim plugins via `dotfiles/shared/nvim/lazy-lock.json`
- JetBrains Mono Nerd Font

## Quick start

```bash
bash scripts/setup.sh
bash scripts/setup.sh --dry-run
```

WSL can also link the tracked Windows Terminal settings template:

```bash
bash scripts/setup.sh --apply-windows-terminal
bash scripts/setup.sh --dry-run --apply-windows-terminal
```

## Safe re-runs

Re-running `scripts/setup.sh` is expected.

- existing correct symlinks are left in place
- conflicting managed destinations are moved to timestamped `*.backup.YYYYMMDD-HHMMSS` paths before linking
- the setup installs missing in-scope tools and relinks managed config
- it does not uninstall unrelated software or do cleanup by default

## Shared core vs platform overlays

- `dotfiles/shared/` is the common core: `tmux`, Neovim, and Starship
- `dotfiles/macos/` adds macOS shell and Ghostty config
- `dotfiles/linux/` adds Ubuntu shell and Ghostty config
- `dotfiles/wsl/` adds the Windows-side Terminal overlay used with WSL
- `scripts/setup.sh` detects the platform and dispatches to the matching setup script

## Notes

- Ghostty is part of the managed setup on macOS and standalone Ubuntu, not WSL
- the first Neovim launch may finish plugin or treesitter bootstrap work
- Oh My Zsh removal is intentionally out of scope; only clean it up after the managed shell setup is working

## Documentation

This README is the quick entry point. Deeper setup docs live at:

- [`docs/index.md`](docs/index.md)
- [`docs/setup/setup.md`](docs/setup/setup.md)
- [`docs/setup/repo-layout.md`](docs/setup/repo-layout.md)
- [`docs/setup/maintenance.md`](docs/setup/maintenance.md)
