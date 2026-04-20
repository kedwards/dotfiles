#!/usr/bin/env bash
set -euo pipefail

PLUGIN_NAME="zjstatus"
GITHUB_REPO="dj95/zjstatus"
INSTALL_DIR="$HOME/.config/zellij/plugins"
INSTALL_PATH="$INSTALL_DIR/zjstatus.wasm"

log() {
  printf '[zjstatus] %s\n' "$*" >&2
}

fail() {
  log "ERROR: $*"
  exit 1
}

command -v curl >/dev/null || fail "curl is required"

mkdir -p "$INSTALL_DIR"

log "Resolving latest release version..."

LATEST_VERSION="$(
  curl -fsSL "https://api.github.com/repos/${GITHUB_REPO}/releases/latest" \
  | grep -Eo '"tag_name":\s*"[^"]+"' \
  | cut -d'"' -f4
)"

[[ -n "$LATEST_VERSION" ]] || fail "Unable to determine latest release"

DOWNLOAD_URL="https://github.com/${GITHUB_REPO}/releases/download/${LATEST_VERSION}/zjstatus.wasm"

log "Latest version: $LATEST_VERSION"
log "Download URL: $DOWNLOAD_URL"

TMP_FILE="$(mktemp)"

cleanup() {
  rm -f "$TMP_FILE"
}
trap cleanup EXIT

log "Downloading zjstatus.wasm..."
curl -fsSL "$DOWNLOAD_URL" -o "$TMP_FILE"

# Only replace if different
if [[ -f "$INSTALL_PATH" ]] && cmp -s "$TMP_FILE" "$INSTALL_PATH"; then
  log "Already up-to-date"
  exit 0
fi

log "Installing plugin → $INSTALL_PATH"
install -m 0644 "$TMP_FILE" "$INSTALL_PATH"

log "zjstatus installed successfully"