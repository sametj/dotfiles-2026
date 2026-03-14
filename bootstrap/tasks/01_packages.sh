#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/../lib.sh"

install_lazygit_linux_release() {
  need_cmd curl
  need_cmd tar
  need_cmd install

  local arch version url tmpdir

  arch="$(uname -m)"
  case "$arch" in
  x86_64 | amd64) arch="x86_64" ;;
  aarch64 | arm64) arch="arm64" ;;
  *) die "[packages] Unsupported arch for lazygit: $arch" ;;
  esac

  log "[packages] Installing lazygit from GitHub release..."

  version="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest |
    sed -n 's/.*"tag_name":[[:space:]]*"v\([^"]*\)".*/\1/p' |
    head -n1)"

  [[ -n "$version" ]] || die "[packages] Could not determine lazygit version."

  url="https://github.com/jesseduffield/lazygit/releases/download/v${version}/lazygit_${version}_Linux_${arch}.tar.gz"

  tmpdir="$(mktemp -d)"
  curl -fsSL "$url" -o "$tmpdir/lazygit.tar.gz"
  tar -xzf "$tmpdir/lazygit.tar.gz" -C "$tmpdir"

  mkdir -p "$HOME/.local/bin"
  install -m 0755 "$tmpdir/lazygit" "$HOME/.local/bin/lazygit"

  rm -rf "$tmpdir"

  log "[packages] lazygit installed at $HOME/.local/bin/lazygit"
}

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
    yazi \
    lazygit

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

  if command -v lazygit >/dev/null 2>&1; then
    log "[packages] lazygit already installed: $(command -v lazygit)"
  else
    if sudo apt-get install -y lazygit; then
      log "[packages] lazygit installed via apt"
    else
      warn "[packages] lazygit not available via apt; falling back to GitHub release"
      install_lazygit_linux_release
    fi
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
