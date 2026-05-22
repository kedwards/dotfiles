#!/usr/bin/env bash
set -Eeuo pipefail

doctor_cmd() {
	local fail=0
	local session="${XDG_SESSION_TYPE:-unknown}"

	echo "i3ctl doctor"
	echo "=============="
	echo "Session type : $session"
	echo

	section() {
		echo
		echo "▶ $*"
	}

	ok() { echo "  ✔ $*"; }
	warn() { echo "  ⚠ $*"; }
	err() {
		echo "  ✖ $*"
		fail=1
	}

	have() {
		command -v "$1" >/dev/null 2>&1
	}

	# --------------------------------------------------
	section "Core i3 environment"
	if have i3; then
		ok "i3 installed"
	else
		err "i3 missing"
	fi
	if have i3-msg; then
		ok "i3-msg available"
	else
		err "i3-msg missing"
	fi
	if have xsetroot; then
		ok "X utilities present"
	else
		warn "xsetroot missing"
	fi

	if [[ $session == "wayland" ]]; then
		warn "Wayland session detected — i3 config will not be used"
	fi

	# --------------------------------------------------
	section "Locking (xss-lock / i3ctl lock)"
	if have xss-lock; then
		ok "xss-lock installed"
	else
		warn "xss-lock missing (no suspend lock)"
	fi
	if have i3lock; then
		ok "i3lock installed"
	else
		err "i3lock missing"
	fi
	if have magick; then
		ok "ImageMagick present"
	else
		err "imagemagick (magick) missing"
	fi

	if have scrot; then
		ok "scrot available for screenshots"
	elif have maim; then
		ok "maim available for screenshots"
	else
		err "No screenshot tool (install scrot or maim)"
	fi

	# --------------------------------------------------
	section "Audio controls (20-input-media.conf)"
	if have pactl; then
		ok "pactl available"
		if pactl info >/dev/null 2>&1; then
			ok "Audio backend responding"
		else
			warn "pactl present but audio backend not responding"
		fi
	else
		err "pactl missing (install pipewire-pulse or pulseaudio)"
	fi

	if have i3status; then
		ok "i3status installed"
	else
		warn "i3status missing (volume refresh)"
	fi

	# --------------------------------------------------
	section "Brightness control"
	if have brightnessctl; then
		ok "brightnessctl installed"
	elif have xbacklight; then
		ok "xbacklight installed"
	else
		warn "No brightness tool found (brightness keys may not work)"
	fi

	# Laptop heuristic
	if [[ -d /sys/class/backlight ]]; then
		ok "Backlight device detected"
	else
		warn "No backlight device detected (desktop?)"
	fi

	# --------------------------------------------------
	section "Launchers & apps"
	if have rofi; then
		ok "rofi installed"
	else
		warn "rofi missing"
	fi
	if have firefox; then
		ok "firefox installed"
	else
		warn "firefox missing"
	fi
	if have thunar; then
		ok "thunar installed"
	else
		warn "thunar missing"
	fi

	if have i3-sensible-terminal; then
		ok "i3-sensible-terminal available"
	else
		warn "i3-sensible-terminal missing (install i3-wm extras)"
	fi

	# --------------------------------------------------
	section "Status bar"
	if have i3blocks; then
		ok "i3blocks installed"
	else
		warn "i3blocks missing"
	fi
	if have i3status; then
		ok "i3status installed"
	else
		warn "i3status missing"
	fi

	# --------------------------------------------------
	section "Cleanup tooling"
	if have lsof; then
		ok "lsof installed"
	else
		warn "lsof missing"
	fi
	if have pgrep; then
		ok "procps available"
	else
		warn "procps missing"
	fi
	if have find; then
		ok "findutils available"
	else
		warn "findutils missing"
	fi

	# --------------------------------------------------
	section "Audio"
	if have pactl; then
		ok "pactl available"
	else
		err "pactl missing (pipewire-pulse or pulseaudio)"
	fi
	if have playerctl; then
		ok "playerctl available"
	else
		warn "playerctl missing (media keys)"
	fi

	# --------------------------------------------------
	section "Display"
	if have xrandr; then
		ok "xrandr available"
	else
		err "xrandr missing (display control)"
	fi

	# --------------------------------------------------
	section "Key overlay"
	if have rofi; then
		ok "rofi available for key overlay"
	else
		err "rofi missing (keys)"
	fi

	# --------------------------------------------------
	section "Power profiles"
	if have powerprofilesctl; then
		ok "powerprofilesctl available"
	else
		warn "powerprofilesctl missing (power profiles disabled)"
	fi

	# --------------------------------------------------
	echo
	if [[ $fail -eq 0 ]]; then
		echo "✔ Doctor check complete — no critical issues found"
	else
		echo "✖ Doctor check complete — critical issues detected"
		echo "  Fix errors above for full functionality"
	fi
}
