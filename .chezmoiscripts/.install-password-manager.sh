#!/bin/sh

# exit immediately if password-manager-binary is already in $PATH
type op >/dev/null 2>&1 && exit

case "$(uname -s)" in
  Darwin)
    # commands to install password-manager-binary on Darwin
    ;;
  Linux)
    [ -r /etc/os-release ] || {
      echo "unsupported Linux distribution"
      exit 1
    }

    . /etc/os-release

    cleanup() {
      [ -n "${tmpdir:-}" ] && rm -rf "$tmpdir"
    }

    arch="$(uname -m)"
    distro_info="${ID:-} ${ID_LIKE:-}"
    tmpdir="$(mktemp -d)"
    trap cleanup 0 HUP INT TERM

    case "$distro_info" in
      *ubuntu*|*debian*)
        case "$arch" in
          x86_64|amd64) deb_arch="amd64" ;;
          i386|i686) deb_arch="386" ;;
          armv7l|armhf) deb_arch="arm" ;;
          aarch64|arm64) deb_arch="arm64" ;;
          *)
            echo "unsupported architecture: $arch"
            exit 1
            ;;
        esac

        curl -fsSLo "$tmpdir/1password-cli.deb" \
          "https://downloads.1password.com/linux/debian/${deb_arch}/stable/1password-cli-${deb_arch}-latest.deb"
        sudo apt install -y "$tmpdir/1password-cli.deb"
        ;;
      *fedora*|*rhel*|*redhat*|*centos*|*rocky*|*almalinux*)
        case "$arch" in
          x86_64|amd64) rpm_arch="x86_64" ;;
          i386|i686) rpm_arch="i386" ;;
          aarch64|arm64) rpm_arch="aarch64" ;;
          armv7l|armhf) rpm_arch="armv7l" ;;
          *)
            echo "unsupported architecture: $arch"
            exit 1
            ;;
        esac

        curl -fsSLo "$tmpdir/1password-cli.rpm" \
          "https://downloads.1password.com/linux/rpm/stable/${rpm_arch}/1password-cli-latest.${rpm_arch}.rpm"

        if command -v dnf >/dev/null 2>&1; then
          sudo dnf install -y "$tmpdir/1password-cli.rpm"
        elif command -v yum >/dev/null 2>&1; then
          sudo yum install -y "$tmpdir/1password-cli.rpm"
        else
          echo "unsupported RPM installer: need dnf or yum"
          exit 1
        fi
        ;;
      *arch*)
        latest_version="$(curl -fsSL https://app-updates.agilebits.com/product_history/CLI2 | awk '/^### [0-9]+\.[0-9]+\.[0-9]+/ { print $2; exit }')"

        [ -n "$latest_version" ] || {
          echo "failed to determine latest 1Password CLI version"
          exit 1
        }

        case "$arch" in
          x86_64|amd64) zip_arch="amd64" ;;
          i386|i686) zip_arch="386" ;;
          armv7l|armhf) zip_arch="arm" ;;
          aarch64|arm64) zip_arch="arm64" ;;
          *)
            echo "unsupported architecture: $arch"
            exit 1
            ;;
        esac

        curl -fsSLo "$tmpdir/op.zip" \
          "https://cache.agilebits.com/dist/1P/op2/pkg/v${latest_version}/op_linux_${zip_arch}_v${latest_version}.zip"

        if command -v unzip >/dev/null 2>&1; then
          unzip -q "$tmpdir/op.zip" -d "$tmpdir"
        elif command -v bsdtar >/dev/null 2>&1; then
          bsdtar -xf "$tmpdir/op.zip" -C "$tmpdir"
        else
          echo "need unzip or bsdtar to install 1Password CLI on Arch"
          exit 1
        fi

        sudo install -m 755 "$tmpdir/op" /usr/local/bin/op
        ;;
      *)
        echo "unsupported Linux distribution"
        exit 1
        ;;
    esac

    command -v op >/dev/null 2>&1 || {
      echo "1Password CLI installation failed"
      exit 1
    }
    ;;
  *)
    echo "unsupported OS"
    exit 1
    ;;
esac
