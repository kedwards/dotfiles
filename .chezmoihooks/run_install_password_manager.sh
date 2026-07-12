#!/bin/sh

# exit immediately if both the CLI and desktop app are already installed
{ type op >/dev/null 2>&1 && command -v 1password >/dev/null 2>&1; } && exit

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

type op >/dev/null 2>&1 || {
	curl -fsSLo "$tmpdir/1password-cli.deb" \
		"https://downloads.1password.com/linux/debian/amd64/stable/1password-cli-amd64-latest.deb"
	sudo apt install -y "$tmpdir/1password-cli.deb"

	command -v op >/dev/null 2>&1 || {
		echo "1Password CLI installation failed"
		exit 1
	}
}

command -v 1password >/dev/null 2>&1 || {
	curl -fsSLo "$tmpdir/1password-desktop.deb" \
		"https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb"
	sudo apt install -y "$tmpdir/1password-desktop.deb"

	command -v 1password >/dev/null 2>&1 || {
		echo "1Password desktop app installation failed"
		exit 1
	}
}
