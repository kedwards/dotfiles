#!/usr/bin/env bash
set -Eeuo pipefail

power_cmd() {
  require rofi
  require systemctl

  case "${1:-}" in
    profile)
      power_profile_menu
      ;;
    "")
      power_menu
      ;;
    *)
      die "Usage: i3ctl power [profile]"
      ;;
  esac
}

# --------------------------------------------------
# Main power menu
# --------------------------------------------------
power_menu() {
  require i3-msg

  local theme="$HOME/.config/i3/rofi/powermenu.rasi"

  local cancel="  Cancel"
  local lock="  Lock"
  local logout="  Logout"
  local reboot="  Reboot"
  local shutdown="  Shutdown"
  local suspend="  Suspend"
  local hibernate="  Hibernate"

  local options
  options=$(printf "%s\n" \
    "$cancel" \
    "$lock" \
    "$logout" \
    "$reboot" \
    "$shutdown" \
    "$suspend" \
    "$hibernate"
  )

  local choice
  choice="$(printf "%s" "$options" \
    | rofi -dmenu -i -p "Power Menu" -theme "$theme")"

  case "$choice" in
    "$lock")
      # Detach lock from this process tree so i3lock can handle input properly
      setsid "$HOME/.local/bin/i3ctl" lock < /dev/null &> /dev/null &
      ;;
    "$logout")    i3-msg exit ;;
    "$reboot")    systemctl reboot ;;
    "$shutdown")  systemctl poweroff ;;
    "$suspend")   systemctl suspend ;;
    "$hibernate") systemctl hibernate ;;
    *)            exit 0 ;;
  esac
}

# --------------------------------------------------
# Power profile menu
# --------------------------------------------------
power_profile_menu() {
  require powerprofilesctl
  require rofi

  local theme="$HOME/.config/i3/rofi/powerprofiles.rasi"

  local current
  current="$(powerprofilesctl get 2>/dev/null || true)"

  # mapfile -t profiles < <(powerprofilesctl list | awk '{print $1}')
  mapfile -t profiles < <(powerprofilesctl list | awk -F: '/^[* ]*[a-zA-Z0-9-]+:$/ {gsub(/[* ]/, "", $1); print $1}')

  [[ ${#profiles[@]} -gt 0 ]] || die "No power profiles available"

  local entries=()
  for profile in "${profiles[@]}"; do
    local label
    case "$profile" in
      performance) label="⚡ Performance" ;;
      balanced)    label="⚖ Balanced" ;;
      power-saver) label=" Power Saver" ;;
      *)           label="$profile" ;;
    esac

    if [[ "$profile" == "$current" ]]; then
      label="<span foreground='#00ff00'>$label ●</span>"
    fi

    entries+=("$profile::$label")
  done

  local choice
  choice="$(
    printf "%s\n" "${entries[@]#*::}" \
      | rofi -dmenu \
          -markup-rows \
          -i \
          -p "Power Profile" \
          -theme "$theme" \
          -mesg "<b>Current:</b> $current"
  )"

  [[ -n "$choice" ]] || exit 0

  for entry in "${entries[@]}"; do
    local key="${entry%%::*}"
    local value="${entry#*::}"
    if [[ "$choice" == "$value" ]]; then
      powerprofilesctl set "$key"
      notify_if_available "Power Profile Changed" "New profile: $key"
      return
    fi
  done
}

notify_if_available() {
  command -v notify-send >/dev/null 2>&1 || return 0
  notify-send -i dialog-information "$1" "$2"
}
