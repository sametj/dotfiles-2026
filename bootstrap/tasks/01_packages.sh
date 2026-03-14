#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

install_common_packages_macos() {
  log "[packages] Installing common packages on macOS..."

  ensure_brew
  setup_brew_shellenv

  pkg_install \
    git \
    curl \
    ca-certificates \
    tmux \
    zsh \
    fzf \
    ripgrep \
    fd \
    bat \
    zoxide \
    jq \
    unzip \
    file-formula \
    poppler \
    p7zip \
    imagemagick \
    ffmpegthumbnailer \
    python \
    pipx \
    yazi

  # Optional but useful
  brew install tree-sitter || true
}

install_common_packages_linux() {
  log "[packages] Installing common packages on Linux/WSL..."

  ensure_apt
  ensure_sudo

  pkg_update

  pkg_install \
    git \
    ca-certificates \
    curl \
    tar \
    xz-utils \
    unzip \
    jq \
    file \
    poppler-utils \
    p7zip-full \
    imagemagick \
    ffmpegthumbnailer \
    build-essential \
    gcc \
    g++ \
    make \
    pkg-config \
    python3 \
    python3-venv \
    python3-pip \
    pipx \
    tmux \
    zsh \
    locales

  sudo apt-get install -y \
    fzf \
    ripgrep \
    fd-find \
    bat \
    zoxide \
    git-delta || true

  sudo apt-get install -y tree-sitter-cli || true

  mkdir -p "$HOME/.local/bin"

  if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    ln -sfn "$(command -v fdfind)" "$HOME/.local/bin/fd"
    log "[packages] Linked fd -> fdfind"
  fi

  if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
    ln -sfn "$(command -v batcat)" "$HOME/.local/bin/bat"
    log "[packages] Linked bat -> batcat"
  fi
}

packages_task() {
  case "${PLATFORM:-}" in
  macos)
    install_common_packages_macos
    ;;
  linux | wsl)
    install_common_packages_linux
    ;;
  *)
    die "[packages] Unsupported platform: ${PLATFORM:-unset}"
    ;;
  esac

  log "[packages] Done."
}

packages_task "$@"
