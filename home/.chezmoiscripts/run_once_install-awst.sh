#!/bin/bash

# Install awst
command -v awst >/dev/null && exit 0

ARCH="$(uname -m)"
case "$ARCH" in
x86_64) ARCH="amd64" ;;
aarch64 | arm64) ARCH="arm64" ;;
*)
	echo "Unsupported architecture: $ARCH" >&2
	exit 1
	;;
esac

LATEST_VERSION="$(
	curl -fsSL "https://api.github.com/repos/kedwards/awst/releases/latest" |
		grep -Eo '"tag_name":\s*"v[^"]+"' |
		cut -d'"' -f4
)"
[[ -n $LATEST_VERSION ]] || {
	echo "Unable to determine latest awst release" >&2
	exit 1
}

VERSION="${LATEST_VERSION#v}"
DOWNLOAD_URL="https://github.com/kedwards/awst/releases/download/${LATEST_VERSION}/awst_${VERSION}_linux_${ARCH}.tar.gz"

TMP_TAR="$(mktemp --suffix=.tar.gz)"
trap 'rm -f "$TMP_TAR"' EXIT

curl -fsSL "$DOWNLOAD_URL" -o "$TMP_TAR"
sudo tar -xzf "$TMP_TAR" -C /usr/local/bin awst
