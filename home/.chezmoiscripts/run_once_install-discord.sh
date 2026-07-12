#!/bin/bash

# Install discord
command -v discord >/dev/null && exit 0

TMP_DEB="$(mktemp --suffix=.deb)"
trap 'rm -f "$TMP_DEB"' EXIT

curl -fsSL "https://discord.com/api/download?platform=linux&format=deb" -o "$TMP_DEB"
sudo apt install -y "$TMP_DEB"
