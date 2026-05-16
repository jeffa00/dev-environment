#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/linking.sh"

[ "$(detect_platform)" = "macos" ] || die "setup-macos.sh must be run on macOS"

manage_ghostty_macos() {
  local managed_source
  local legacy_path

  managed_source="$REPO_ROOT/dotfiles/macos/ghostty/config.ghostty"

  ensure_dir "$HOME/.config/ghostty"
  link_file "$managed_source" "$HOME/.config/ghostty/config.ghostty"

  while IFS= read -r legacy_path; do
    if [ "$legacy_path" != "$HOME/.config/ghostty/config.ghostty" ] && { [ -e "$legacy_path" ] || [ -L "$legacy_path" ]; }; then
      backup_path "$legacy_path"
    fi
  done < <(legacy_ghostty_config_paths)
}

log "Installing macOS packages"
require_brew
run brew update
if brew bundle check --file "$REPO_ROOT/Brewfile" >/dev/null 2>&1; then
  log "Brewfile dependencies are already satisfied"
else
  run brew bundle install --file "$REPO_ROOT/Brewfile"
fi

log "Applying managed config"
ensure_dir "$HOME/.config"
link_file "$REPO_ROOT/dotfiles/macos/zsh/.zprofile" "$HOME/.zprofile"
link_file "$REPO_ROOT/dotfiles/macos/zsh/.zshrc" "$HOME/.zshrc"
link_file "$REPO_ROOT/dotfiles/shared/shell/starship.toml" "$HOME/.config/starship.toml"
link_file "$REPO_ROOT/dotfiles/shared/tmux/tmux.conf" "$HOME/.tmux.conf"
link_dir "$REPO_ROOT/dotfiles/shared/nvim" "$HOME/.config/nvim"
manage_ghostty_macos

log "Validating installed tools"
validate_command tmux
validate_command nvim
validate_command ghostty
validate_command starship
