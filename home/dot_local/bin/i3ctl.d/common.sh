#!/usr/bin/env bash
set -Eeuo pipefail

log() { echo "[i3ctl] $*" >&2; }
dbg() { [[ "${VERBOSE:-false}" == "true" ]] && echo "[debug] $*" >&2 || true; }
die() { log "ERROR: $*"; exit 1; }

require() {
  command -v "$1" >/dev/null 2>&1 || die "Missing dependency: $1"
}

i3ctl_help() {
  cat <<EOF
Usage: i3ctl <command>

Commands:
  lock
  brightness
  cleanup
  doctor
  workspace
EOF
}