#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

install_yazi_release_linux() {
  need_cmd curl
  need_cmd unzip
  need_cmd install

  local arch url_arch tag url tmp
  arch="$(uname -m)"

  case "$arch" in
    x86_64|amd64) url_arch="x86_64-unknown-linux-gnu" ;;
    aarch64|arm64) url_arch="aarch64-unknown-linux-gnu" ;;
    *) die "[yazi] Unsupported Linux arch: $arch" ;;
  esac

  log "[yazi] Installing Yazi from GitHub releases..."

  tag="$(curl -fsSL https://api.github.com/repos/sxyazi/yazi/releases/latest \
    | sed -n 's/.*"tag_name":[[:space:]]*"\([^"]*\)".*/\1/p' | head -n1)"
  [[ -n "$tag" ]] || die "[yazi] Could not determine latest release tag."

  url="https://github.com/sxyazi/yazi/releases/download/${tag}/yazi-${url_arch}.zip"

  tmp="$(mktemp -d)"
  curl -fsSL "$url" -o "$tmp/yazi.zip"
  unzip -q "$tmp/yazi.zip" -d "$tmp/unpack"

  mkdir -p "$HOME/.local/bin"
  install -m 0755 "$tmp"/unpack/*/yazi "$HOME/.local/bin/yazi"
  install -m 0755 "$tmp"/unpack/*/ya "$HOME/.local/bin/ya"

  rm -rf "$tmp"

  log "[yazi] Installed: $HOME/.local/bin/yazi and $HOME/.local/bin/ya"
}

install_macos_yazi() {
  ensure_brew
  setup_brew_shellenv

  log "[yazi] Installing Yazi + preview deps on macOS..."

  if ! has_cmd yazi; then
    pkg_install yazi
  else
    log "[yazi] yazi already installed."
  fi

  pkg_install \
    file-formula \
    unzip \
    jq \
    ffmpegthumbnailer \
    poppler \
    p7zip \
    imagemagick
}

install_linux_yazi() {
  ensure_apt
  ensure_sudo

  log "[yazi] Installing Yazi + preview deps on Linux/WSL..."

  pkg_update

  sudo apt-get install -y \
    file \
    unzip \
    jq \
    ffmpegthumbnailer \
    poppler-utils \
    p7zip-full \
    imagemagick

  if ! command -v yazi >/dev/null 2>&1; then
    install_yazi_release_linux
  else
    log "[yazi] yazi already installed."
  fi
}

yazi_task() {
  case "${PLATFORM:-}" in
    macos)
      install_macos_yazi
      ;;
    linux|wsl)
      install_linux_yazi
      ;;
    *)
      die "[yazi] Unsupported platform: ${PLATFORM:-unset}"
      ;;
  esac

  log "[yazi] Done."
}

yazi_task "$@"
