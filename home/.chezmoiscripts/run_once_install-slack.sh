#!/bin/bash

# Install slack
command -v slack >/dev/null && exit 0

DEB_URL="$(curl -sL 'https://slack.com/downloads/instructions/linux?ddl=1&build=deb' | grep -oE 'https://downloads\.slack-edge\.com[^"'"'"']*\.deb' | head -1)"
[[ -n $DEB_URL ]] || { echo "Unable to determine Slack .deb URL" >&2; exit 1; }

TMP_DEB="$(mktemp --suffix=.deb)"
trap 'rm -f "$TMP_DEB"' EXIT

curl -fsSL "$DEB_URL" -o "$TMP_DEB"
sudo apt install -y "$TMP_DEB"
