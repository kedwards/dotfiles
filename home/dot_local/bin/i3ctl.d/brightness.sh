#!/usr/bin/env bash
set -Eeuo pipefail

brightness_cmd() {
  require brightnessctl

  [[ -d /sys/class/backlight ]] || exit 0

  local step=5

  case "${1:-}" in
    up)
      brightnessctl set +"${step}%" >/dev/null
      ;;
    down)
      brightnessctl set "${step}%-" >/dev/null
      ;;
    *)
      die "Usage: i3ctl brightness {up|down}"
      ;;
  esac
}