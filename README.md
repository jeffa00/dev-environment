# dev-environment

Cross-platform terminal and editor environment for macOS, Ubuntu, and WSL.

## Scope

This repo manages:

- macOS `zsh` config
- Ubuntu/WSL `bash` config
- Starship prompt config
- tmux config
- full Neovim config
- Ghostty config for macOS and Ubuntu
- Windows Terminal settings template for WSL

It is designed to be **safe to re-run**. Existing unmanaged files are backed up once before managed symlinks are created.

## Supported targets

- macOS
- Ubuntu on WSL
- standalone Ubuntu

## Usage

Run the top-level setup script:

```bash
bash scripts/setup.sh
```

Dry run:

```bash
bash scripts/setup.sh --dry-run
```

On WSL, optionally apply the tracked Windows Terminal settings template too:

```bash
bash scripts/setup.sh --apply-windows-terminal
```

## Notes

- The script installs `JetBrains Mono Nerd Font`.
- Ghostty is installed on macOS and standalone Ubuntu.
- WSL uses Windows Terminal rather than Ghostty.
- Oh My Zsh removal is intentionally **not** part of the setup flow. If you migrate away from it successfully, remove it later as an optional cleanup step.
