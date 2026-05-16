#!/usr/bin/env bash

timestamp() {
  date +%Y%m%d-%H%M%S
}

ensure_dir() {
  local dir
  dir="$1"
  [ -d "$dir" ] || run mkdir -p "$dir"
}

backup_path() {
  local path
  local backup

  path="$1"
  backup="${path}.backup.$(timestamp)"

  if [ -e "$path" ] || [ -L "$path" ]; then
    run mv "$path" "$backup"
    log "Backed up $path to $backup"
  fi
}

link_path() {
  local source_path
  local destination_path
  local source_kind
  local destination_parent
  local current_target

  source_path="$1"
  destination_path="$2"
  source_kind="$3"

  [ -e "$source_path" ] || die "Managed path does not exist: $source_path"

  destination_parent="$(dirname "$destination_path")"
  ensure_dir "$destination_parent"

  if [ -L "$destination_path" ]; then
    current_target="$(readlink "$destination_path")"
    if [ "$current_target" = "$source_path" ]; then
      log "Already linked: $destination_path"
      return
    fi
    backup_path "$destination_path"
  elif [ -e "$destination_path" ]; then
    if [ "$source_kind" = "file" ] && [ -d "$destination_path" ]; then
      die "Refusing to replace directory with file link: $destination_path"
    fi

    if [ "$source_kind" = "dir" ] && [ ! -d "$destination_path" ]; then
      die "Refusing to replace file with directory link: $destination_path"
    fi

    backup_path "$destination_path"
  fi

  run ln -s "$source_path" "$destination_path"
}

link_file() {
  [ -f "$1" ] || die "Expected file source: $1"
  link_path "$1" "$2" "file"
}

link_dir() {
  [ -d "$1" ] || die "Expected directory source: $1"
  link_path "$1" "$2" "dir"
}

