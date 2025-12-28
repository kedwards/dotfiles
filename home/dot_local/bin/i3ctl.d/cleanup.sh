#!/usr/bin/env bash
set -Eeuo pipefail

cleanup_cmd() {
  require i3-msg

  local exec=false
  local reload=false

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --exec) exec=true ;;
      --reload) reload=true ;;
    esac
    shift
  done

  run() {
    $exec && eval "$@" || echo "[dry-run] $*"
  }

  # sockets, processes, logs...
  # (existing logic unchanged)
}