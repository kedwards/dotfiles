#!/usr/bin/env bash
set -Eeuo pipefail

display_cmd() {
  require xrandr

  # Guard: i3 is X11-only
  if [[ "${XDG_SESSION_TYPE:-}" == "wayland" ]]; then
    die "Display control via xrandr not supported on Wayland"
  fi

  # Helper to check output existence
  has_output() {
    xrandr --query | grep -q "^$1 connected"
  }

  case "${1:-}" in
    desk)
      # External dual monitors + laptop panel
      has_output DP-1-2 || die "Output DP-1-2 not found"
      has_output DP-1-3 || die "Output DP-1-3 not found"
      has_output eDP-1  || die "Output eDP-1 not found"

      xrandr \
        --output DP-1-2 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
        --output DP-1-3 --mode 1920x1080 --pos 1920x0 --rotate normal \
        --output eDP-1  --mode 2560x1600 --pos 960x1080 --rotate normal
      ;;
    laptop)
      # Laptop only
      has_output eDP-1 || die "Output eDP-1 not found"

      xrandr \
        --output eDP-1 --primary --auto \
        --output DP-1-2 --off \
        --output DP-1-3 --off
      ;;
    off)
      # Turn off externals
      xrandr --output DP-1-2 --off --output DP-1-3 --off
      ;;
    *)
      die "Usage: i3ctl display {desk|laptop|off}"
      ;;
  esac
}