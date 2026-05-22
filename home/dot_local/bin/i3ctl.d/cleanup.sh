#!/usr/bin/env bash
set -Eeuo pipefail

cleanup_cmd() {
	require i3-msg

	local exec=false

	while [[ $# -gt 0 ]]; do
		case "$1" in
		--exec) exec=true ;;
		esac
		shift
	done

	# shellcheck disable=SC2329
	run() {
		if $exec; then
			"$@"
		else
			echo "[dry-run] $*"
		fi
	}

	# sockets, processes, logs...
	# TODO: implement cleanup logic that calls run()
}
