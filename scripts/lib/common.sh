#!/usr/bin/env bash

log() {
  printf '==> %s\n' "$*"
}

warn() {
  printf 'Warning: %s\n' "$*" >&2
}

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

run() {
  log "$*"
  if [ "${DRY_RUN:-0}" -eq 0 ]; then
    "$@"
  fi
}

run_shell() {
  log "$*"
  if [ "${DRY_RUN:-0}" -eq 0 ]; then
    bash -lc "$*"
  fi
}

detect_platform() {
  case "$(uname -s)" in
    Darwin)
      printf 'macos\n'
      ;;
    Linux)
      if grep -qi microsoft /proc/version 2>/dev/null || [ -n "${WSL_DISTRO_NAME:-}" ]; then
        printf 'wsl\n'
      else
        printf 'linux\n'
      fi
      ;;
    *)
      printf 'unsupported\n'
      ;;
  esac
}

require_brew() {
  command_exists brew || die "Homebrew is required. Install it from https://brew.sh/"
}

require_apt() {
  command_exists apt-get || die "apt-get is required for Ubuntu/WSL installs."
}

require_ubuntu() {
  [ -f /etc/os-release ] || die "Cannot determine Linux distribution."
  . /etc/os-release
  [ "${ID:-}" = "ubuntu" ] || die "This setup currently supports Ubuntu for Linux/WSL."
}

repo_root_from_script_dir() {
  local script_dir
  script_dir="$1"
  cd "$script_dir/.." && pwd
}

legacy_ghostty_config_paths() {
  printf '%s\n' \
    "$HOME/.config/ghostty/config" \
    "$HOME/Library/Application Support/com.mitchellh.ghostty/config" \
    "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
}

install_nerd_font_ubuntu() {
  local font_dir
  local temp_dir
  local zip_path

  font_dir="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"

  if [ -d "$font_dir" ] && find "$font_dir" -name 'JetBrainsMonoNerdFont-*.ttf' -print -quit | grep -q .; then
    log "JetBrains Mono Nerd Font already installed for this user"
    return
  fi

  temp_dir="$(mktemp -d)"
  zip_path="$temp_dir/JetBrainsMono.zip"

  run mkdir -p "$font_dir"
  run curl -fsSL -o "$zip_path" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
  run unzip -o "$zip_path" -d "$font_dir"
  run fc-cache -f "$HOME/.local/share/fonts"
  run rm -rf "$temp_dir"
}

install_ghostty_ubuntu() {
  if dpkg -s ghostty >/dev/null 2>&1; then
    log "ghostty already installed"
    return
  fi

  run sudo add-apt-repository -y ppa:mkasberg/ghostty-ubuntu
  run sudo apt-get update
  run sudo apt-get install -y ghostty
}

validate_command() {
  local command_name
  local version_output
  command_name="$1"

  if command_exists "$command_name"; then
    case "$command_name" in
      tmux)
        version_output="$("$command_name" -V 2>/dev/null | head -n 1)"
        ;;
      *)
        version_output="$("$command_name" --version 2>/dev/null | head -n 1)"
        ;;
    esac

    if [ -n "$version_output" ]; then
      log "$version_output"
    else
      warn "Could not determine version for $command_name"
    fi
  else
    warn "$command_name is not available on PATH"
  fi
}
