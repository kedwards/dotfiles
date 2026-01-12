#!/usr/bin/env bash
set -Eeuo pipefail

lock_cmd() {
  require i3lock
  require magick

  if command -v scrot >/dev/null 2>&1; then
    screenshot() { scrot -zo "$1"; }
  elif command -v maim >/dev/null 2>&1; then
    screenshot() { maim "$1"; }
  else
    die "Missing screenshot tool (scrot or maim)"
  fi

  local img
  img="$(mktemp "${XDG_RUNTIME_DIR:-/tmp}/i3lock.XXXXXX.png")"
  trap "rm -f '$img'" EXIT INT TERM

  screenshot "$img"
  magick "$img" -blur 5x4 "$img"

  i3lock --nofork -i "$img"
}
