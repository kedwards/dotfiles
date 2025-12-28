#!/usr/bin/env bash
set -Eeuo pipefail

keys_cmd() {
  require rofi

  local theme="$HOME/.config/i3/rofi/showkeys.rasi"
  local sheet="$HOME/.config/i3/keys/cheatsheet.txt"

  [[ -f "$sheet" ]] || die "Key cheatsheet not found: $sheet"

  rofi \
    -dmenu \
    -i \
    -p "Keybindings" \
    -theme "$theme" \
    < "$sheet"
}