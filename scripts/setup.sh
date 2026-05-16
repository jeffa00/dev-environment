#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DRY_RUN=0
APPLY_WINDOWS_TERMINAL=0

source "$SCRIPT_DIR/lib/common.sh"

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      ;;
    --apply-windows-terminal)
      APPLY_WINDOWS_TERMINAL=1
      ;;
    *)
      die "Unknown argument: $1"
      ;;
  esac
  shift
done

export DRY_RUN
export APPLY_WINDOWS_TERMINAL
export REPO_ROOT

case "$(detect_platform)" in
  macos)
    bash "$SCRIPT_DIR/setup-macos.sh"
    ;;
  linux)
    bash "$SCRIPT_DIR/setup-linux.sh"
    ;;
  wsl)
    bash "$SCRIPT_DIR/setup-wsl.sh"
    ;;
  *)
    die "Unsupported platform"
    ;;
esac

