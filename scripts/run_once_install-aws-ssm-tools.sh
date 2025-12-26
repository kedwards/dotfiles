#!/bin/bash

# Install aws-ssm-tools to ~/.local/aws-ssm-tools
INSTALL_DIR="${HOME}/.local/aws-ssm-tools"
BIN_DIR="${HOME}/.local/bin"

# Check if already installed
if [ -d "$INSTALL_DIR" ] && [ -f "${BIN_DIR}/aws-ssm-connect" ]; then
  echo "aws-ssm-tools already installed at $INSTALL_DIR"
  exit 0
fi

echo "Installing aws-ssm-tools to $INSTALL_DIR..."

# Create directories
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"

# Download and extract
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

if ! curl -sSL "https://github.com/kedwards/aws-ssm-tools/archive/refs/heads/main.tar.gz" | tar xz -C "$tmpdir"; then
  echo "Failed to download aws-ssm-tools" >&2
  exit 1
fi

# Copy files
EXTRACTED_DIR="${tmpdir}/aws-ssm-tools-main"
if ! rsync -a --delete "${EXTRACTED_DIR}/" "${INSTALL_DIR}/"; then
  echo "Failed to copy aws-ssm-tools files" >&2
  exit 1
fi

# Create symlinks
for f in "${INSTALL_DIR}/bin/"*; do
  [ -f "$f" ] || continue
  cmd="$(basename "$f")"
  ln -sf "${f}" "${BIN_DIR}/${cmd}"
done

echo "aws-ssm-tools installed successfully"
