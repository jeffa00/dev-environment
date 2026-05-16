# dev-environment

Cross-platform terminal and editor environment for macOS, Ubuntu, and WSL.

## Scope

This repo manages:

- macOS `zsh` config
- Ubuntu/WSL `bash` config
- Starship prompt config
- tmux config
- full Neovim config
- pinned Neovim plugin versions via `lazy-lock.json`
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

## Package notes

- macOS uses `Brewfile`
- Ubuntu/WSL uses `packages/apt.txt`
- Neovim treesitter support requires **`tree-sitter-cli`**, which is included in the managed package manifests
- The setup also installs **JetBrains Mono Nerd Font**

## Notes

- The script installs `JetBrains Mono Nerd Font`.
- Ghostty is installed on macOS and standalone Ubuntu.
- WSL uses Windows Terminal rather than Ghostty.
- The first Neovim run may install or update treesitter parsers.
- Plugin versions are pinned in `dotfiles/shared/nvim/lazy-lock.json`.
- Oh My Zsh removal is intentionally **not** part of the setup flow. If you migrate away from it successfully, remove it later as an optional cleanup step.

## Current test status

- macOS setup has been exercised successfully end-to-end
- A deprecated Homebrew tap reference was removed from the `Brewfile`
- The Neovim config was updated for the current `nvim-treesitter` API rewrite
