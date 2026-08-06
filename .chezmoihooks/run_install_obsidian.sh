#!/bin/sh

# exit immediately if Obsidian is already installed
command -v obsidian >/dev/null 2>&1 && exit

[ -r /etc/os-release ] || {
	echo "unsupported Linux distribution"
	exit 1
}

# shellcheck disable=SC1091
. /etc/os-release

case "${ID:-} ${ID_LIKE:-}" in
*ubuntu* | *debian*) ;;
*)
	echo "unsupported Linux distribution"
	exit 1
	;;
esac

cleanup() {
	[ -n "${tmpdir:-}" ] && rm -rf "$tmpdir"
}

arch="$(uname -m)"
case "$arch" in
x86_64 | amd64) ;;
*)
	echo "unsupported architecture: $arch"
	exit 1
	;;
esac

tmpdir="$(mktemp -d)"
trap cleanup 0 HUP INT TERM

url="$(curl -fsSL https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest |
	grep -o 'https://[^" ]*amd64\.deb' | head -n1)"
[ -n "$url" ] || {
	echo "failed to determine latest Obsidian download URL"
	exit 1
}

curl -fsSLo "$tmpdir/obsidian.deb" "$url"
sudo apt install -y "$tmpdir/obsidian.deb"

command -v obsidian >/dev/null 2>&1 || {
	echo "Obsidian installation failed"
	exit 1
}
