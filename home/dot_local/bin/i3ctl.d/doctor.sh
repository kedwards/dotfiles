#!/usr/bin/env bash
set -Eeuo pipefail

doctor_cmd() {
  local fail=0
  local session="${XDG_SESSION_TYPE:-unknown}"

  echo "i3ctl doctor"
  echo "=============="
  echo "Session type : $session"
  echo

  section() {
    echo
    echo "▶ $*"
  }

  ok()   { echo "  ✔ $*"; }
  warn() { echo "  ⚠ $*"; }
  err()  { echo "  ✖ $*"; fail=1; }

  have() {
    command -v "$1" >/dev/null 2>&1
  }

  # --------------------------------------------------
  section "Core i3 environment"
  have i3        && ok "i3 installed"        || err "i3 missing"
  have i3-msg    && ok "i3-msg available"    || err "i3-msg missing"
  have xsetroot  && ok "X utilities present" || warn "xsetroot missing"

  if [[ "$session" == "wayland" ]]; then
    warn "Wayland session detected — i3 config will not be used"
  fi

  # --------------------------------------------------
  section "Locking (xss-lock / i3ctl lock)"
  have xss-lock  && ok "xss-lock installed" || warn "xss-lock missing (no suspend lock)"
  have i3lock    && ok "i3lock installed"   || err "i3lock missing"
  have magick    && ok "ImageMagick present"|| err "imagemagick (magick) missing"

  if have scrot; then
    ok "scrot available for screenshots"
  elif have maim; then
    ok "maim available for screenshots"
  else
    err "No screenshot tool (install scrot or maim)"
  fi

  # --------------------------------------------------
  section "Audio controls (20-input-media.conf)"
  if have pactl; then
    ok "pactl available"
    if pactl info >/dev/null 2>&1; then
      ok "Audio backend responding"
    else
      warn "pactl present but audio backend not responding"
    fi
  else
    err "pactl missing (install pipewire-pulse or pulseaudio)"
  fi

  have i3status && ok "i3status installed" || warn "i3status missing (volume refresh)"

  # --------------------------------------------------
  section "Brightness control"
  if have brightnessctl; then
    ok "brightnessctl installed"
  elif have xbacklight; then
    ok "xbacklight installed"
  else
    warn "No brightness tool found (brightness keys may not work)"
  fi

  # Laptop heuristic
  if [[ -d /sys/class/backlight ]]; then
    ok "Backlight device detected"
  else
    warn "No backlight device detected (desktop?)"
  fi

  # --------------------------------------------------
  section "Launchers & apps"
  have rofi     && ok "rofi installed"     || warn "rofi missing"
  have firefox  && ok "firefox installed"  || warn "firefox missing"
  have thunar   && ok "thunar installed"   || warn "thunar missing"

  if have i3-sensible-terminal; then
    ok "i3-sensible-terminal available"
  else
    warn "i3-sensible-terminal missing (install i3-wm extras)"
  fi

  # --------------------------------------------------
  section "Status bar"
  have i3blocks && ok "i3blocks installed" || warn "i3blocks missing"
  have i3status && ok "i3status installed" || warn "i3status missing"

  # --------------------------------------------------
  section "Cleanup tooling"
  have lsof     && ok "lsof installed"     || warn "lsof missing"
  have pgrep    && ok "procps available"   || warn "procps missing"
  have find     && ok "findutils available"|| warn "findutils missing"

  # --------------------------------------------------
  section "Audio"
  have pactl        && ok "pactl available" || err "pactl missing (pipewire-pulse or pulseaudio)"
  have playerctl    && ok "playerctl available" || warn "playerctl missing (media keys)"

  # --------------------------------------------------
  section "Display"
  have xrandr && ok "xrandr available" || err "xrandr missing (display control)"

  # --------------------------------------------------
  section "Key overlay"
  have rofi && ok "rofi available for key overlay" || err "rofi missing (keys)"

  # --------------------------------------------------
  section "Power profiles"
  have powerprofilesctl && ok "powerprofilesctl available" || warn "powerprofilesctl missing (power profiles disabled)"

  # --------------------------------------------------
  echo
  if [[ $fail -eq 0 ]]; then
    echo "✔ Doctor check complete — no critical issues found"
  else
    echo "✖ Doctor check complete — critical issues detected"
    echo "  Fix errors above for full functionality"
  fi
}