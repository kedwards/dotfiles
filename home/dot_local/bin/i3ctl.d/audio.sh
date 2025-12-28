#!/usr/bin/env bash
set -Eeuo pipefail

audio_cmd() {
  require pactl

  local step=1

  get_default_sink() {
    pactl get-default-sink
  }

  get_default_source() {
    pactl get-default-source
  }

  switch_sink() {
    local sinks current next
    current="$(get_default_sink)"
    mapfile -t sinks < <(pactl list short sinks | awk '{print $2}')

    [[ ${#sinks[@]} -gt 1 ]] || return 0

    for i in "${!sinks[@]}"; do
      if [[ "${sinks[$i]}" == "$current" ]]; then
        next="${sinks[$(( (i + 1) % ${#sinks[@]} ))]}"
        pactl set-default-sink "$next"
        pactl list short sink-inputs | awk '{print $1}' \
          | xargs -r -n1 pactl move-sink-input "$next"
        return
      fi
    done
  }

  case "${1:-}" in
    up)
      pactl set-sink-volume @DEFAULT_SINK@ +"${step}%"
      ;;
    down)
      pactl set-sink-volume @DEFAULT_SINK@ -"${step}%"
      ;;
    mute)
      pactl set-sink-mute @DEFAULT_SINK@ toggle
      ;;
    mic-mute)
      pactl set-source-mute @DEFAULT_SOURCE@ toggle
      ;;
    switch)
      switch_sink
      ;;
    *)
      die "Usage: i3ctl audio {up|down|mute|mic-mute|switch}"
      ;;
  esac
}