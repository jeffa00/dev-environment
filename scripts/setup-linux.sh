#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/linking.sh"

[ "$(detect_platform)" = "linux" ] || die "setup-linux.sh must be run on Linux"
require_apt
require_ubuntu

log "Installing Ubuntu packages"
run sudo apt-get update
run xargs -a "$REPO_ROOT/packages/apt.txt" sudo apt-get install -y
install_ghostty_ubuntu
install_nerd_font_ubuntu

log "Applying managed config"
ensure_dir "$HOME/.config"
ensure_dir "$HOME/.config/ghostty"
link_file "$REPO_ROOT/dotfiles/linux/bash/.profile" "$HOME/.profile"
link_file "$REPO_ROOT/dotfiles/linux/bash/.bashrc" "$HOME/.bashrc"
link_file "$REPO_ROOT/dotfiles/shared/shell/starship.toml" "$HOME/.config/starship.toml"
link_file "$REPO_ROOT/dotfiles/shared/tmux/tmux.conf" "$HOME/.tmux.conf"
link_dir "$REPO_ROOT/dotfiles/shared/nvim" "$HOME/.config/nvim"
link_file "$REPO_ROOT/dotfiles/linux/ghostty/config.ghostty" "$HOME/.config/ghostty/config.ghostty"

if [ -e "$HOME/.config/ghostty/config" ] && [ ! -L "$HOME/.config/ghostty/config" ]; then
  backup_path "$HOME/.config/ghostty/config"
fi

log "Validating installed tools"
validate_command tmux
validate_command nvim
validate_command ghostty
validate_command starship

