#!/usr/bin/env bash
set -Eeuo pipefail

workspace_cmd() {
  require i3-msg

  local max_workspaces=20

  # Generate list: 1..N
  local all
  all="$(seq 1 "$max_workspaces")"

  # Active workspace numbers
  local used
  used="$(
    i3-msg -t get_workspaces \
      | tr ',' '\n' \
      | awk -F: '/"num"/ {print int($2)}'
  )"

  # Find first unused workspace
  local target
  target="$(
    {
      echo "$used"
      echo "$all"
    } | sort -n | uniq -u | head -n 1
  )"

  [[ -n "$target" ]] || die "No free workspace found"

  i3-msg workspace "$target" >/dev/null
}